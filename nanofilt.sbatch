#!/bin/bash
#==============================================================================
# NanoFilt Script for Oxford Nanopore Data
#
# Description: Quality filter Oxford Nanopore reads using NanoFilt
# Requirements: NanoFilt
#
# Usage:
#   Edit the configuration variables below, then submit with:
#   sbatch --array=0-N nanofilt.sbatch
#   where N = number of fastq files in INPUT_DIR minus 1
#==============================================================================
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 32
#SBATCH --time=24:00:00
#SBATCH --mem=128GB
#SBATCH -J NanoFilt
#SBATCH --output=%x.%A_%a.out
#SBATCH --error=%x.%A_%a.err

# --- Configuration: modify these paths before submitting ---
INPUT_DIR="/path/to/pychopper/output"
OUTPUT_DIR="/path/to/nanofilt/output"
LOG_FILE="${OUTPUT_DIR}/nanofilt.log"
MIN_QUALITY=10

# --- Setup ---
mkdir -p "${OUTPUT_DIR}"
queries=($(ls "${INPUT_DIR}"/*.fastq | xargs -n 1 basename))
SAMPLE="${queries[$SLURM_ARRAY_TASK_ID]%.fastq}"

# --- Job Info ---
echo "$(date +'[%Y-%m-%d %H:%M:%S]') Starting NanoFilt on $(hostname)"
echo "Processing file: ${queries[$SLURM_ARRAY_TASK_ID]}"

# --- Run NanoFilt ---
NanoFilt \
    --logfile "${LOG_FILE}" \
    -q "${MIN_QUALITY}" \
    "${INPUT_DIR}/${queries[$SLURM_ARRAY_TASK_ID]}" \
    > "${OUTPUT_DIR}/${SAMPLE}.filtered.fastq"

echo "$(date +'[%Y-%m-%d %H:%M:%S]') Done!"
