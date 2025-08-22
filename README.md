# ONT cDNA sequencing analysis

## Dorado Basecalling
This script converts pod5 sequencing output files to bam (Note: these are not alignment bam files) for downstream demultiplexing.  

## Demultiplexing
This script demultiplexs the bam file input. A fastq output it given for each individual barcode detected in the library. 

