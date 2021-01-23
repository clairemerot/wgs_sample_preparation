#!/bin/bash
#SBATCH -J "wgsClipOverlaps"
#SBATCH -o log_%j
#SBATCH -c 1 
#SBATCH -p medium
#SBATCH --mail-type=ALL
#SBATCH --mail-user=claire.merot@gmail.com
#SBATCH --time=7-00:00
#SBATCH --mem=30G

# Important: Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

# Global variables
GATK="/home/clrou103/00-soft/GATK/GenomeAnalysisTK.jar"
DEDUPFOLDER="07_deduplicated_reprise"
REALIGNFOLDER="08_realigned_reprise"
CLIPFOLDER="09_no_overlap"
GENOMEFOLDER="03_genome"
GENOME="genome.fasta"

# Load needed modules
module load bamUtil
module load samtools/1.8

# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="99_log_files"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

for file in "$REALIGNFOLDER"/*.bam
do
    echo "$file"

    # Clip overlap
    bam clipOverlap \
        --in "$file" \
        --out "$CLIPFOLDER"/$(basename "$file" .realigned.bam).temp.bam \
        --unmapped --storeOrig OC --stats

    # Remove the reads that became unmapped in the clipping
    samtools view -hb -F 4 \
        "$CLIPFOLDER"/$(basename "$file" .realigned.bam).temp.bam \
        > "$CLIPFOLDER"/$(basename "$file" .realigned.bam).no_overlap.bam

    # Index bam
    samtools index "$CLIPFOLDER"/$(basename "$file" .realigned.bam).no_overlap.bam

    # Cleanup
    rm "$CLIPFOLDER"/$(basename "$file" .realigned.bam).temp.bam

done
