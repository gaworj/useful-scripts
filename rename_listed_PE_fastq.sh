#!/bin/bash

# Bash script to rename fastq files in a folder based on old and new base names in a text file.
# JanG (DNA Sequencing Facility IBB PAS Poland), ChatGPT, 26.04.2023


# Define usage function
usage() {
    echo "Usage: $0 [-h] -i input_dir -t tab_file"
    echo "Rename paired FASTQ files based on tab-separated file"
    echo ""
    echo "Options:"
    echo "  -h               Print this help message"
    echo "  -i input_dir     Input directory containing FASTQ files"
    echo "  -t tab_file      Tab-separated file containing old and new names"
    echo ""
    exit 1
}

# Parse command-line options
while getopts ":hi:t:" opt; do
    case ${opt} in
        h )
            usage
            ;;
        i )
            input_dir=$OPTARG
            ;;
        t )
            tab_file=$OPTARG
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            usage
            ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            usage
            ;;
    esac
done

# Check required options are set
if [[ -z "$input_dir" || -z "$tab_file" ]]; then
    usage
fi

# Loop through tab-separated file and rename files
while IFS=$'\t' read -r old_name new_name; do
    old_name_1=${old_name}_R1.fastq.gz
    old_name_2=${old_name}_R2.fastq.gz
    new_name_1=${new_name}_R1.fastq.gz
    new_name_2=${new_name}_R2.fastq.gz
    mv "${input_dir}/${old_name_1}" "${input_dir}/${new_name_1}"
    mv "${input_dir}/${old_name_2}" "${input_dir}/${new_name_2}"
done < "$tab_file"
