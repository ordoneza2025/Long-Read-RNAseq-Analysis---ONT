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

## Artibeus Jamaicensis Sequencing

Frozen Jamaican fruit bat (Artibeus.jamaicensis) tissues were homogenized by grinding with a pellet pestle (Fisherbrand 12-141-361) under liquid nitrogen. RNA was then extracted from ground homogenized tissues using the Quick-RNA Miniprep Kit (Zymo Research, R1054) according to the manufacturer's protocol for tissue samples. RNA concentration was measured by Qubit with the RNA Broad Range Assay kit (Invitrogen Q10210) and the integrity was assessed by TapeStation (Agilent; High Sensitivity RNA ScreenTape 5067-5579). All samples had RNA integrity (RIN) values between 6.6–7.2 and were used for downstream RNA-sequencing.

For long-read based RNA-seq, cDNA libraries were prepared with the PCR-cDNA Barcoding kit from Oxford Nanopore Technologies (SQK-PCB111.24), according to the manufacturer’s instructions. Briefly, poly(A) RNA was reverse transcribed using a strand-switching approach incorporating a UMI, generating full-length double-stranded cDNA. Samples were then PCR-amplified using barcoded primers (14 cycles), pooled equimolarly, and ligated with Rapid Sequencing Adapters prior to loading. Libraries were sequenced on a  R9.4.1 MinION flow cell (AJ1) or a R9.4.1 PromethION flow cell (AJ2) (Oxford Nanopore Technologies, Oxford) for 72 hours. AJ2 PromethION sequencing generated pod5 files while AJ1 MinION sequencing generated fast5 files, which were converted to the newer pod5 format using the dorado pod5 convert function (Dorado v0.7.2 (GitHub - nanoporetech/dorado: Oxford)). Pod5 files from both bats were processed with dorado basecaller on super high accuracy and demultiplexed (dorado demux  –not-trim, –no-classify, and –emit-fastq flags). Output fastq files were run through pychopper for read orientation, adapter trimming, and selection of full-length cDNA (Pychopper v2.7.10 (GitHub - epi2me-labs/pychopper: cDNA ...)). Pychopper was run with default parameters (pychopper -k PCB111 -w); output reads were combined with rescued reads and Nanofilt v2.8.0 (De Coster et al. 2018)  was used to filter reads based on a quality threshold of 10.
