#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input_file> <output_folder> <num_splits>"
    exit 1
fi

# Assign input arguments to variables
INPUT_FILE="$1"
OUTPUT_FOLDER="$2"
NUM_SPLITS="$3"

FILE_NAME=$(basename "$INPUT_FILE" .txt)
OUTPUT_FOLDER="${OUTPUT_FOLDER}/${FILE_NAME}"

# Ensure the output directory exists
mkdir -p "$OUTPUT_FOLDER"

# Read all lines from the input file into an array
FILES=()
while IFS= read -r line; do
    FILES+=("$line")
done < "$INPUT_FILE"
TOTAL_LINES=${#FILES[@]}
echo "${TOTAL_LINES}"
# Check if the number of splits is valid
if [ "$NUM_SPLITS" -le 0 ] || [ "$NUM_SPLITS" -gt "$TOTAL_LINES" ]; then
    echo "Error: Invalid number of splits ($NUM_SPLITS)."
    exit 1
fi

# Determine how many lines per split (distribute evenly)
FILES_PER_SPLIT=$((TOTAL_LINES / NUM_SPLITS))
REMAINDER=$((TOTAL_LINES % NUM_SPLITS))

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

    # Write the lines to the output file
    printf "%s\n" "${FILES[@]:start_index:split_size}" > "$OUTPUT_FILE"
    
    echo "Created $OUTPUT_FILE with $split_size lines."

    # Update start index
    ((start_index += split_size))
done

echo "Splitting completed!"
