#!/bin/bash

# Requirement: get dashing tool and put it in your $PATH
# Usage: ./compute_cardinality.sh <input_folder> <presketched (true/false)> <output_csv>

if [ "$#" -ne 3 ]; then
    echo "Usage: ./compute_cardinality.sh <input_folder> <presketched (true/false)> <output_csv>"
    exit 1
fi

INPUT_FOLDER="$1"
PRESKETCHED="$2"
OUTPUT_CSV="$3"

# Ensure output file is empty or create it
> "$OUTPUT_CSV"

# Set file extension filter
if [ "$PRESKETCHED" == "true" ]; then
    FILE_PATTERN="*.hll"
else
    FILE_PATTERN="*.fa*"
fi

# Find and process files based on type
find "$INPUT_FOLDER" -type f \( -name "$FILE_PATTERN" \) | while read -r FILE; do
    # Determine if presketched
    if [ "$PRESKETCHED" == "true" ]; then
        RESULT=$(dashing card --presketched "$FILE")
    else
        RESULT=$(dashing card "$FILE")
    fi

    # Extract genome name (remove path and extensions)
    BASENAME=$(basename "$FILE")
    GENOME_NAME=$(echo "$BASENAME" | sed -E 's/\..*//') # Remove everything after first dot
    
    # Extract cardinality from the output
    CARDINALITY=$(echo "$RESULT" | tail -n1 | awk '{print $NF}')

    # Write to CSV
    echo "$GENOME_NAME,$CARDINALITY" >> "$OUTPUT_CSV"

    echo "Processed: $GENOME_NAME"
done

echo "Cardinality CSV saved to: $OUTPUT_CSV"