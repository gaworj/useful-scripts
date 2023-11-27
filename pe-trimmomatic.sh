#!/bin/bash

# Shell script to adapter trim PE MiSeq *.fastq.gz sequence read files with Trimmomatic

for infile in *_R1.fastq.gz

do

base=$(basename ${infile} _R1.fastq.gz)

echo "Trimmomatic adapter removal for sample $base"
	java -Xmx64g -jar /home/jang/biosoft/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 32 ${infile} ${base}_R2.fastq.gz \
                 ${base}_trim_R1.fastq.gz ${base}_R1un.trim.fastq.gz \
                 ${base}_trim_R2.fastq.gz ${base}_R2un.trim.fastq.gz \
                 SLIDINGWINDOW:4:20 MINLEN:20 ILLUMINACLIP:/home/jang/biosoft/Trimmomatic-0.39/adapters/adapters.fa:2:40:15 
done

rm *un.trim*;
