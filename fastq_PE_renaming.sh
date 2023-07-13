#!/bin/bash

# shell script to rename PE MiSeq *.fastq.gz sequence read files to raw name_R1.fastq.gz and name_R2.fastq.gz


echo "Starting renaming of fastq.gz samples "


for i in *R1*.fastq.gz;

	# rename input PE read files
	do j=`echo $i | cut -d "_" -f 1`;

	mv $i $j"_R1.fastq.gz";

	mv $j*"_R2_001.fastq.gz" $j"_R2.fastq.gz";
		
done;

echo "Renaming of fastq.gz files has been finished"
