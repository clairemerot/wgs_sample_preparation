#!/bin/bash
#SBATCH -J "wgsindexGenome"
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
CSD="/prg/picard-tools/1.119/CreateSequenceDictionary.jar"
GENOMEFOLDER="03_genome"
GENOME="genome.fasta"
DICT="$GENOMEFOLDER"/"${GENOME%.fasta}".dict

# Load needed modules
module load java/jdk/1.8.0_102
module load samtools/1.8

# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="99_log_files"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# create a dictionnary from reference fasta file
java -jar "$CSD" \
    R="$GENOMEFOLDER"/"$GENOME" \
    O="$DICT"

# Also index genome with samtools
samtools faidx "$GENOMEFOLDER"/"$GENOME"
