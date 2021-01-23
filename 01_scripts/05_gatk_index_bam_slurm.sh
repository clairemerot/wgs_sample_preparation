#!/bin/bash
#SBATCH -J "wgsindexBam"
#SBATCH -o log_%j
#SBATCH -c 1 
#SBATCH -p medium
#SBATCH --mail-type=ALL
#SBATCH --mail-user=claire.merot@gmail.com
#SBATCH --time=7-00:00
#SBATCH --mem=10G

# Important: Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

# Global variables
BAMINDEX="/prg/picard-tools/1.119/BuildBamIndex.jar"
DEDUPFOLDER="07_deduplicated"

# Load needed modules
module load java/jdk/1.8.0_102

# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT="$0"
NAME="$(basename $0)"
LOG_FOLDER="99_log_files"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Build Bam Index
ls -1 "$DEDUPFOLDER"/*.dedup.bam |
while read file
do
    java -jar "$BAMINDEX" INPUT="$file"
done
