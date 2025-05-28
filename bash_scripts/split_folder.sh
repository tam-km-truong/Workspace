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

# Calculate digits needed for padding
DIGITS=${#NUM_SUBDIRS}

# Calculate base and extra counts
BASE_COUNT=$((NUM_FILES / NUM_SUBDIRS))
EXTRA_FILES=$((NUM_FILES % NUM_SUBDIRS))

INDEX=0
for ((i=0; i<NUM_SUBDIRS; i++)); do
    SUBDIR_NUM=$(printf "%0${DIGITS}d" $((i+1)))
    SUBDIR="${FOLDER}/part_${SUBDIR_NUM}"
    mkdir -p "$SUBDIR"
    
    FILE_COUNT=$BASE_COUNT
    if [ "$i" -lt "$EXTRA_FILES" ]; then
        FILE_COUNT=$((FILE_COUNT + 1))
    fi

    for ((j=0; j<FILE_COUNT; j++)); do
        mv "${FILES[INDEX]}" "$SUBDIR/"
        INDEX=$((INDEX + 1))
    done
done

echo "Files split into $NUM_SUBDIRS subdirectories (named subdir_$(printf "%0${DIGITS}d" 1) to subdir_$(printf "%0${DIGITS}d" $NUM_SUBDIRS))."
