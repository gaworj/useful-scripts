#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 [-m metadata_file] [-t target_folder]"
    echo "Options:"
    echo "  -m metadata_file   Specify the metadata file"
    echo "  -t target_folder   Specify the target folder"
    exit 1
}

# Process command-line options
while getopts ":m:t:" opt; do
    case ${opt} in
        m)
            metadata_file=$OPTARG
            ;;
        t)
            target_folder=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

# Check if the metadata file is provided
if [[ -z "$metadata_file" ]]; then
    echo "Metadata file not provided."
    usage
    exit 1
fi

# Check if the target folder is provided
if [[ -z "$target_folder" ]]; then
    echo "Target folder not provided."
    usage
    exit 1
fi

# Check if the metadata file exists
if [[ ! -f "$metadata_file" ]]; then
    echo "Metadata file not found: $metadata_file"
    exit 1
fi

# Create the target folder if it doesn't exist
mkdir -p "$target_folder"

# Read the metadata file line by line
while IFS= read -r line; do
  # Extract the columns from the line
  column1=$(echo "$line" | awk '{print $1}')
  column2=$(echo "$line" | awk '{print $2}')

  # Check if the columns are not empty
  if [[ -n "$column1" && -n "$column2" ]]; then
    # Extract the base name (without extension) from column1
    base_name=$(basename "$column1" | cut -d. -f1)

    # Remove any invalid characters from the column2 value
    sanitized_column2=$(echo "$column2" | tr -cd '[:alnum:]._-' | tr '[:upper:]' '[:lower:]')

    # Search for files that match the base name
    matched_files=$(find . -maxdepth 1 -type f -name "$base_name*")

    # Loop through the matched files
    while IFS= read -r file; do
      # Get the base name of the file
      file_base_name=$(basename "$file")

      # Create a folder for the column2 value if it doesn't exist
      mkdir -p "$target_folder/$sanitized_column2"

      # Copy the file to the corresponding folder with the base name
      cp "$file" "$target_folder/$sanitized_column2/$file_base_name"
    done <<< "$matched_files"
  fi
done < "$metadata_file"

