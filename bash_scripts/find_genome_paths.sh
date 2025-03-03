#!/bin/bash

# Check arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <genome_list.txt> <genome_folder> <output_file>"
    exit 1
fi

GENOME_LIST="$1"  # Input text file with genome names
GENOME_FOLDER="$2"  # Folder containing genome files
OUTPUT_FILE="$3"  # Output file for paths

# Ensure the genome folder exists
if [ ! -d "$GENOME_FOLDER" ]; then
    echo "Error: Genome folder '$GENOME_FOLDER' not found!"
    exit 1
fi

# Clear the output file
> "$OUTPUT_FILE"

# Process each genome name in the list
while IFS= read -r genome; do
    # Find the genome file in the folder (supports .fa, .fasta, .fa.gz, sketch hll etc.)
    genome_path=$(find "$GENOME_FOLDER" -type f \( -name "$genome.fa" -o -name "$genome.fasta" -o -name "$genome.*.hll" -o -name "$genome.fa.gz" \) 2>/dev/null | head -n 1)

    # If a matching file is found, write it to the output file
    if [ -n "$genome_path" ]; then
        echo "$genome_path" >> "$OUTPUT_FILE"
    else
        echo "Warning: Genome file for '$genome' not found!" >&2
    fi
done < "$GENOME_LIST"

echo "Genome file paths saved to '$OUTPUT_FILE'"
