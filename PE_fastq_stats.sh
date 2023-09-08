#!/bin/bash

### PE fastq stats generator. It calculates number of reads for paired end files and summarizes total bases. 
### Written by JanG DNA Sequencing Facility IBB PAS at 08.09.2023 with help of ChatGPT v3.5

# Function to print usage information
usage() {
    echo -e "\e[93mPE_fastq_stats.sh - Paired End fastq statistics script written by JanG at 08.09.2023\e[0m"
    echo "Usage: $0 [-p <fastq_pairs_directory>] -o <output_file>"
    echo "If -p is not provided, the current directory will be used."
    echo -e "\e[91mError: An output file must be provided.\e[0m" >&2
    exit 1
}

# Initialize variables
fastq_pairs_dir=""
output_file=""

# Parse command-line options
while getopts "p:o:h" opt; do
    case $opt in
        p)
            fastq_pairs_dir="$OPTARG"
            ;;
        o)
            output_file="$OPTARG"
            ;;
        h)
            usage
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
    esac
done

# If -p is not provided, use the current directory
if [ -z "$fastq_pairs_dir" ]; then
    fastq_pairs_dir="./"
fi

# Check if the output file is provided
if [ -z "$output_file" ]; then
    usage
fi

# Function to format numbers with commas using Perl
format_number() {
    local number="$1"
    perl -pe 's/(?<=\d)(?=(?:\d{3})+(?!\d))/,/g' <<< "$number"
}

# Function to print statistics for a pair of FASTQ files
print_statistics() {
    local fastq1="$1"
    local fastq2="$2"
    
    # Function to count reads in a FASTQ file
    count_reads() {
        local file="$1"
        local reads=$(zcat "$file" | wc -l)
        reads=$((reads / 4))
        echo "$reads"
    }

    # Trim underscores from the sample name
    trim_underscores() {
        local sample_name="$1"
        echo "${sample_name%%_*}"
    }

    # Count reads from the first FASTQ file
    reads1=$(count_reads "$fastq1")

    # Trim underscores from the sample name
    sample_name=$(trim_underscores "$(basename "$fastq1" .fastq.gz)")

    # Format the read count with commas
    formatted_reads1=$(format_number "$reads1")

    # Function to count nucleotides in a FASTQ file
    count_nucleotides() {
        local file="$1"
        local nucleotides=$(zcat "$file" | tr -d '\n' | wc -c)
        echo "$nucleotides"
    }

    # Count nucleotides from both FASTQ files
    nucleotides1=$(count_nucleotides "$fastq1")
    nucleotides2=$(count_nucleotides "$fastq2")
    total_nucleotides=$((nucleotides1 + nucleotides2))

    # Format the total nucleotides with commas
    formatted_total_nucleotides=$(format_number "$total_nucleotides")

    # Create a tab-separated output file with a header
    if [ ! -e "$output_file" ]; then
        echo -e "sample name\tnumber of sequences\tsum_length" > "$output_file"
    fi

    # Append results to the output file with formatted read count and total nucleotides
    echo -e "$sample_name\t$formatted_reads1\t$formatted_total_nucleotides" >> "$output_file"
}

# Process each pair of FASTQ files in the directory
for pair in "$fastq_pairs_dir"/*_R1.fastq.gz; do
    if [[ -f "$pair" ]]; then
        # Generate the corresponding R2 file name
        fastq1="$pair"
        fastq2="${pair/_R1/_R2}"
        
        # Check if the R2 file exists
        if [[ -f "$fastq2" ]]; then
            relative_path1=${fastq1#$fastq_pairs_dir}
            relative_path2=${fastq2#$fastq_pairs_dir}
            echo -e "\e[96mProcessing files: $relative_path1 and $relative_path2\e[0m"
            
            # Print statistics with formatted read count and total nucleotides
            print_statistics "$fastq1" "$fastq2"
        else
            echo -e "\e[91mR2 file not found for $fastq1. Skipping.\e[0m"
        fi
    fi
done

echo -e "\e[92mStatistics have been written to $output_file\e[0m"



# Print summarized results to the console
cat "$output_file"
