# ONT cDNA sequencing analysis

This repository will take you from basecalling to aligning long-read ONT files (RNA-seq isoform aware analysis). 

## Dorado Basecalling
This script converts pod5 sequencing output files to bam (Note: these are not alignment bam files) for downstream demultiplexing.  

## Demultiplexing
This script demultiplexs the bam file input. A fastq output it given for each individual barcode detected in the library. 

## Pyhopper
Finds and orients full-length reads. It also trims adapter and primer sequences. 

## Nanofilt
Filtering reads by quality. 

## Minimap2
Aling trimmed/filtered reads. Script also uses samtools to filter for aligned reads with quality of 10 or higher, convert sam to bam, and index file. 

Output alignment files can be used for quantification, uploaded to genome broswer, or assembled into a transcriptome.  
