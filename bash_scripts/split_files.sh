#!/bin/bash

# Check if correct number of arguments is provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <folder_path> <file_extension> <num_splits> <output_folder>"
    exit 1
fi

# Input parameters
FOLDER_PATH="$1"
FILE_TYPE="$2"
NUM_SPLITS="$3"
OUTPUT_FOLDER="$4"

# Validate that the folder exists
if [ ! -d "$FOLDER_PATH" ]; then
    echo "Error: Folder '$FOLDER_PATH' does not exist."
    exit 1
fi

# Create output folder if it doesn't exist
mkdir -p "$OUTPUT_FOLDER"

# Get list of files with the specified type
FILES=($(find "$FOLDER_PATH" -type f -name "*$FILE_TYPE"))
TOTAL_FILES=${#FILES[@]}
echo "Total_files: '$TOTAL_FILES'"

# Check if there are files to process
if [ "$TOTAL_FILES" -eq 0 ]; then
    echo "Error: No files with extension '$FILE_TYPE' found in '$FOLDER_PATH'."
    exit 1
fi

# Determine how many files per split (distribute evenly)
FILES_PER_SPLIT=$((TOTAL_FILES / NUM_SPLITS))
REMAINDER=$((TOTAL_FILES % NUM_SPLITS))

# Create the split files
start_index=0
for ((i=0; i<NUM_SPLITS; i++)); do
    split_size=$FILES_PER_SPLIT

    # Distribute remainder files across first few splits
    if [ "$i" -lt "$REMAINDER" ]; then
        ((split_size++))
    fi

    # Create output file in the output folder
    OUTPUT_FILE="${OUTPUT_FOLDER}/split_${i}.txt"
    
    # Write the file paths to the output file
    printf "%s\n" "${FILES[@]:start_index:split_size}" > "$OUTPUT_FILE"

    echo "Created $OUTPUT_FILE with $split_size file paths."

    # Update start index
    ((start_index += split_size))
done
