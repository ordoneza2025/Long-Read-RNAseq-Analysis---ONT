#!/bin/bash
#==============================================================================
# Dorado Basecalling Script for Oxford Nanopore Data
#
# Description: GPU-accelerated basecalling using Dorado on SLURM cluster
# Requirements: Dorado v0.7.0+, CUDA-compatible GPU
#
# Usage: 
#   Edit the configuration variables below, then submit with:
#   sbatch dorado_basecalling.sbatch
#==============================================================================
#SBATCH --partition=nvidia-a100
#SBATCH --time=500:00:00
#SBATCH --mem=500GB
#SBATCH --cpus-per-task=64
#SBATCH --gres=gpu:4
#SBATCH --job-name=dorado_basecall
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err

# --- Configuration: modify these paths before submitting ---
INPUT_DIR="/path/to/raw/pod5_or_fast5_files"
OUTPUT_DIR="/path/to/output"
OUTPUT_FILE="calls_sup_notrim.bam"
MODEL="sup"               # Options: fast, hac, sup
KIT_NAME="SQK-PCB114-24" # Sequencing kit used

# --- Setup ---
mkdir -p "${OUTPUT_DIR}"

# --- Job Info ---
echo "$(date +'[%Y-%m-%d %H:%M:%S]') Starting basecalling on $(hostname)"
echo "Dorado version: $(dorado --version)"
echo "Input:  ${INPUT_DIR}"
echo "Output: ${OUTPUT_DIR}/${OUTPUT_FILE}"
echo "Model:  ${MODEL}"
echo "Kit:    ${KIT_NAME}"

# --- Run Basecalling ---
echo "$(date +'[%Y-%m-%d %H:%M:%S]') Running dorado basecaller..."
dorado basecaller "${MODEL}" "${INPUT_DIR}" \
    --kit-name "${KIT_NAME}" \
    --no-trim \
    > "${OUTPUT_DIR}/${OUTPUT_FILE}"

echo "$(date +'[%Y-%m-%d %H:%M:%S]') Done!"
