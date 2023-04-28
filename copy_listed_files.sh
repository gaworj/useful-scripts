#!/bin/bash

# Bash script for copying files from one folder into another basing on file basename provided in text file.
# JanG (DNA Sequencing Facility IBB PAS Poland), ChatGPT, 28.04.2023



# Define usage function
usage() {
    echo "Usage: $0 [-h] -i input_dir -o output_dir -l list_file"
    echo "Copy files from input directory to output directory based on sample basenames"
    echo ""
    echo "Options:"
    echo "  -h                 Print this help message"
    echo "  -i input_dir       Input directory containing files"
    echo "  -o output_dir      Output directory to copy files to"
    echo "  -l list_file       List of sample basenames to copy files for"
    echo ""
    exit 1
}

# Parse command-line options
while getopts ":hi:o:l:" opt; do
    case ${opt} in
        h )
            usage
            ;;
        i )
            input_dir=$OPTARG
            ;;
        o )
            output_dir=$OPTARG
            ;;
        l )
            list_file=$OPTARG
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
if [[ -z "$input_dir" || -z "$output_dir" || -z "$list_file" ]]; then
    usage
fi

# Loop through list file and copy files
while read -r sample; do
    for file in "${input_dir}/${sample}"*; do
        cp "$file" "$output_dir"
    done
done < "$list_file"

