import os
import argparse
import glob
import sys

def find_all_paths(search_folder):
    """
    Recursively finds all files under search_folder and maps filenames to their full paths.

    :param search_folder: Root folder to search.
    :return: Dictionary {filename: full_path}
    """
    file_paths = {}
    for file_path in glob.iglob(os.path.join(search_folder, "**", "*"), recursive=True):
        filename = os.path.basename(file_path)
        file_paths[filename] = os.path.abspath(file_path)
    return file_paths

def process_file(input_file, search_folder, output_file=None, inplace=False):
    """
    Replaces filenames in a text file with their full paths.

    :param input_file: Input text file with one filename per line.
    :param search_folder: Folder to search for the files.
    :param output_file: Output file path (ignored if inplace is True).
    :param inplace: If True, modifies the input file in place.
    """
    path_map = find_all_paths(search_folder)
    target_file = input_file if inplace else output_file

    if not target_file:
        raise ValueError("Output file must be specified unless --inplace is used.")
    
    with open(input_file, "r") as infile:
        lines = infile.readlines()

    with open(target_file, "w") as outfile:
        for line in lines:
            filename = line.strip()
            full_path = path_map.get(filename, "NOT_FOUND")
            if full_path == "NOT_FOUND":
                print(f"Warning: {filename} not found in {search_folder}", file=sys.stderr)
            outfile.write(f"{full_path}\n")

    print(f"Processed: {input_file} -> {target_file}")

def main():
    parser = argparse.ArgumentParser(description="Replace filenames in a text file with their full paths by searching a folder.")
    parser.add_argument("input_file", help="Text file containing filenames (one per line).")
    parser.add_argument("search_folder", help="Folder to search for the files.")
    parser.add_argument("output_file", nargs="?", help="Output file path (required unless --inplace is set).")
    parser.add_argument("--inplace", action="store_true", help="Modify the input file in place.")

    args = parser.parse_args()

    if args.inplace:
        process_file(args.input_file, args.search_folder, inplace=True)
    else:
        if not args.output_file:
            parser.error("output_file is required unless --inplace is specified.")
        process_file(args.input_file, args.search_folder, output_file=args.output_file)

if __name__ == "__main__":
    main()
