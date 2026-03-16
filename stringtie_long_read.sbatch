
#!/bin/bash

## Example usage
## conda activate Stringtie2
## inFile=. refFile=. outDir=. sbatch stringtie_long_read.sbatch

##General Settings
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=24gb
#SBATCH --time=20:00:00
#SBATCH --partition=short

##Job name and output
#SBATCH --job-name=stringtie_long_read
#SBATCH --output=
#SBATCH --error=

# Run Stringtie2

echo "Stringtie version: "$(stringtie --version)

pwd; hostname; date

stringtie ${inFile} -p 8 \
-L #long_read mode \
--conservative \
-G ${refFile} \
-A ${outDir}/.tab #RSEM quantification of transcripts \
-o ${outDir}/.gtf

echo $(date +"[%b %d %H:%M:%S] Done")
