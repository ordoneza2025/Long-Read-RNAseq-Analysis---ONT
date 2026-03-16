#!/bin/bash
#SBATCH --job-name=bam_merge
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=16gb
#SBATCH --time=24:00:00
#SBATCH --partition=short
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err

# =============================================================
# Configuration
# =============================================================
workDir=/path/to/alignment/long_read
numThreads=8

# =============================================================
# Job info
# =============================================================
echo "Job name:       $SLURM_JOB_NAME"
echo "Job ID:         $SLURM_JOB_ID"
echo "Nodes:          $SLURM_JOB_NODELIST"
echo "Date:           $(date)"

# =============================================================
# Load modules
# =============================================================
module load samtools
echo "Samtools version:"; samtools --version | head -1

# =============================================================
# Step 1: Merge BAM files
# =============================================================
echo "Merging BAM files..."
samtools merge \
    -@ ${numThreads} \
    ${workDir}/merged.bam \
    ${workDir}/sample1.sorted.bam \
    ${workDir}/sample2.sorted.bam \
    ${workDir}/sample3.sorted.bam \
    ${workDir}/sample4.sorted.bam

# =============================================================
# Step 2: Filter merged BAM by mapping quality (MAPQ >= 10)
# =============================================================
echo "Filtering merged BAM for MAPQ >= 10..."
samtools view \
    -@ ${numThreads} \
    -bq 10 \
    ${workDir}/merged.bam \
    > ${workDir}/merged.q10.bam

# =============================================================
# Step 3: Sort filtered BAM
# =============================================================
echo "Sorting filtered BAM..."
samtools sort \
    -@ ${numThreads} \
    -o ${workDir}/merged.q10.sorted.bam \
    ${workDir}/merged.q10.bam

# =============================================================
# Step 4: Index sorted filtered BAM
# =============================================================
echo "Indexing sorted filtered BAM..."
samtools index \
    -@ ${numThreads} \
    ${workDir}/merged.q10.sorted.bam

echo "Done: $(date)"
