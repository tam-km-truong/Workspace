import os
import shutil
import sys
from pathlib import Path

def copy_files(file_list_path, source_dir, output_dir):
    # Ensure output directory exists
    os.makedirs(output_dir, exist_ok=True)

    # Read filenames (without extensions) from the list
    with open(file_list_path, 'r') as file:
        filenames = [line.strip() for line in file if line.strip()]

    # Search and copy matching files
    for filename in filenames:
        # Find all files in source_dir (including subdirectories) that start with the given filename
        matches = list(Path(source_dir).rglob(f"{filename}.*"))

        if matches:
            for file_path in matches:
                shutil.copy(file_path, output_dir)
                print(f"Copied: {file_path} → {output_dir}/")
        else:
            print(f"File not found: {filename}.*")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python copy_files_list.py <file_list> <source_dir> <output_dir>")
        sys.exit(1)

    file_list = sys.argv[1]
    source_dir = sys.argv[2]
    output_dir = sys.argv[3]

    copy_files(file_list, source_dir, output_dir)
