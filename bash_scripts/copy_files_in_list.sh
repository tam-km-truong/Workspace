#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <file_list> <source_dir> <output_dir>"
    exit 1
fi

# Define input variables
file_list="$1"   # Path to the file containing the list of filenames
source_dir="$2"  # Root directory where the files should be searched
output_dir="$3"  # Default to './output' if not provided

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Loop through each filename in the list
while IFS= read -r filename; do
  # Search for all occurrences of the file in the source directory and subdirectories
  found_files=$(find "$source_dir" -type f -name "$filename.*" 2>/dev/null)

  if [[ -n "$found_files" ]]; then
    # Copy all found files
    while IFS= read -r file_path; do
      cp "$file_path" "$output_dir/"
      echo "Copied: $file_path → $output_dir/"
    done <<< "$found_files"
  else
    echo "File not found: $filename"
  fi
done < "$file_list"
