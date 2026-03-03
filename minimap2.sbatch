#!/bin/bash
#==============================================================================
# Minimap2 Alignment Script for Oxford Nanopore Data
#
# Description: Align long reads to reference genome using Minimap2,
#              then convert, sort, and index with Samtools
# Requirements: minimap2/2.17, samtools
#
# Usage:
#   Edit the configuration variables below, then submit with:
#   sbatch --array=0-N minimap2.sbatch
#   where N = number of fastq files in INPUT_DIR minus 1
#==============================================================================
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --time=6:00:00
#SBATCH --mem=64GB
#SBATCH -J minimap2
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err

# --- Load modules ---
module load minimap2/2.17
module load samtools

# --- Configuration: modify these paths before submitting ---
INPUT_DIR="/path/to/trimmed/fastq"
OUTPUT_DIR="/path/to/alignment/output"
REFERENCE="/path/to/reference.fa"
THREADS=8

# --- Setup ---
mkdir -p "${OUTPUT_DIR}"
queries=($(ls "${INPUT_DIR}"/*.fastq | xargs -n 1 basename))
SAMPLE="${queries[$SLURM_ARRAY_TASK_ID]%.fastq}"

# --- Job Info ---
echo "$(date +'[%Y-%m-%d %H:%M:%S]') Starting alignment on $(hostname)"
echo "Processing file: ${queries[$SLURM_ARRAY_TASK_ID]}"

# --- Align ---
minimap2 -a -x splice -k14 -uf -t "${THREADS}" \
    "${REFERENCE}" \
    "${INPUT_DIR}/${queries[$SLURM_ARRAY_TASK_ID]}" \
    > "${OUTPUT_DIR}/${SAMPLE}.sam"

# --- Convert, filter, sort, and index ---
samtools view -bS -q 10 "${OUTPUT_DIR}/${SAMPLE}.sam" | \
    samtools sort -o "${OUTPUT_DIR}/${SAMPLE}.sorted.bam"
samtools index "${OUTPUT_DIR}/${SAMPLE}.sorted.bam"

echo "$(date +'[%Y-%m-%d %H:%M:%S]') Done!"
