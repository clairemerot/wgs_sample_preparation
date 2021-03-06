#!/bin/bash
#SBATCH -J "wgsTrim"
#SBATCH -o log_%j
#SBATCH -c 3 
#SBATCH -p medium
#SBATCH --mail-type=ALL
#SBATCH --mail-user=claire.merot@gmail.com
#SBATCH --time=7-00:00
#SBATCH --mem=20G

# Important: Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

# trim input files in 04_raw_data with fastp
# No need to parallelize more, using 6 CPUs makes fastp really fast

# WARNING: File name formats may require changing code below

ls -1 /project/lbernatchez/00_raw_data/2018-06-16_claire_merot_mouche_wgs/03_renamed/all_lanes/*_R1*.gz

# Iterate over files in data folder
for file in $(ls -1 /project/lbernatchez/00_raw_data/2018-06-16_claire_merot_mouche_wgs/03_renamed/all_lanes/*_R1*.gz)
do
    input_file=$(echo "$file" | perl -pe 's/_R1.*\.fastq.gz//')
    output_file=$(basename "$input_file")
    echo "Treating: $output_file"

    fastp -w 3 \
        -i "$input_file"_R1.fastq.gz \
        -I "$input_file"_R2.fastq.gz \
        -o 05_trimmed/"$output_file"_1.trimmed.fastq.gz \
        -O 05_trimmed/"$output_file"_2.trimmed.fastq.gz \
        -j 05_trimmed/01_reports/"$output_file".json \
        -h 05_trimmed/01_reports/"$output_file".html
done
