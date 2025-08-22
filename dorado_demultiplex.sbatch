#!/bin/bash

#==============================================================================
# Dorado Demultiplexing Script for Oxford Nanopore Data
# 
# Description: Demultiplex barcoded Oxford Nanopore reads using Dorado
# Requirements: Dorado v0.7.0+, BAM file with barcoded reads
# Usage: sbatch dorado_demultiplex.sbatch
#==============================================================================

#SBATCH --job-name=demultiplex
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=200gb
#SBATCH --time=20:00:00
#SBATCH --partition=short
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err

# Configuration - modify these paths for your setup
INPUT_BAM="calls_sup_notrim.bam"
OUTPUT_DIR="demultiplex_output"
THREADS=32

# Create output directory
mkdir -p "${OUTPUT_DIR}"

# Job info
echo "$(date +'[%Y-%m-%d %H:%M:%S]') Starting demultiplexing on $(hostname)"
echo "Dorado version: $(dorado --version)"
echo "Input BAM: ${INPUT_BAM}"
echo "Output directory: ${OUTPUT_DIR}"

# Run demultiplexing
echo "$(date +'[%Y-%m-%d %H:%M:%S]') Running dorado demultiplexer..."
dorado demux \
    ${INPUT_BAM} \
    --output-dir ${OUTPUT_DIR} \
    --no-classify \
    --no-trim \
    -t ${THREADS}

echo "$(date +'[%b %d %H:%M:%S]') Done!"
