#!/bin/bash

mkdir porechop_trimmed

mkdir ont_raw

for i in *.fastq.gz;
 
 do j=`echo $i | cut -d "_" -f 1`; ### leave all characters before last "_"

 porechop_abi -t 24 -i $i -o $j"_ont_trimmed.fastq.gz";	
	
	mv $j"_ont_trimmed.fastq.gz" porechop_trimmed;
	
	echo "Porechop_abi processing of sample $j has been finished";
	
	mv $i ont_raw;

done
