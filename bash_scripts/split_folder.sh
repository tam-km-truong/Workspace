#!/bin/bash

# Check arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <folder> <num_subdirs>"
    exit 1
fi

FOLDER="$1"
NUM_SUBDIRS="$2"

# Check if folder exists
if [ ! -d "$FOLDER" ]; then
    echo "Error: Folder '$FOLDER' does not exist."
    exit 1
fi

# Get the list of files in the folder
FILES=("$FOLDER"/*)
NUM_FILES=${#FILES[@]}

# Check if there are files to split
if [ "$NUM_FILES" -eq 0 ]; then
    echo "Error: No files found in '$FOLDER'."
    exit 1
fi

# Calculate how many files per subdir (approximate)
FILES_PER_SUBDIR=$(( (NUM_FILES + NUM_SUBDIRS - 1) / NUM_SUBDIRS ))  # Ceiling division

# Create subdirectories and distribute files
for ((i=0; i<NUM_SUBDIRS; i++)); do
    SUBDIR="${FOLDER}/subdir_$((i+1))"
    mkdir -p "$SUBDIR"
    
    # Move files to the subdir
    for ((j=0; j<FILES_PER_SUBDIR && ${#FILES[@]}>0; j++)); do
        mv "${FILES[0]}" "$SUBDIR/"
        FILES=("${FILES[@]:1}")  # Remove moved file from array
    done
done

echo "Files split into $NUM_SUBDIRS subdirectories."
