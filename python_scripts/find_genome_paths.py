import os
import argparse
import glob

def find_genome_paths(genome_folder):
    """
    Recursively finds all genome files (*.fa, *.hll) and maps genome names to their full paths.

    :param genome_folder: Root folder where genome files are stored.
    :return: Dictionary {genome_name: full_path}
    """
    genome_paths = {}
    # Search for both .fa and .hll files in the genome folder (and subdirectories)
    for file_path in glob.iglob(os.path.join(genome_folder, "**", "*.*"), recursive=True):
        # Extract the genome name (excluding extension)
        genome_name = os.path.basename(file_path).split(".")[0]
        # Store full path
        genome_paths[genome_name] = os.path.abspath(file_path)
    
    return genome_paths

def process_text_files(input_folder, genome_folder, output_folder):
    """
    Reads input text files, replaces genome names with their full paths, and saves results.

    :param input_folder: Folder containing text files with genome names.
    :param genome_folder: Folder containing genome files (*.fa, *.hll) in subdirectories.
    :param output_folder: Folder where output text files will be saved.
    """
    os.makedirs(output_folder, exist_ok=True)

    # Get genome paths mapping
    genome_paths = find_genome_paths(genome_folder)

    # Process each text file
    for text_file in glob.glob(os.path.join(input_folder, "*.txt")):
        output_file = os.path.join(output_folder, os.path.basename(text_file))

        with open(text_file, "r") as infile, open(output_file, "w") as outfile:
            for line in infile:
                genome_name = line.strip().split('.')[0]
                genome_path = genome_paths.get(genome_name, "NOT_FOUND")
                outfile.write(f"{genome_path}\n")

        print(f"Processed: {text_file} -> {output_file}")

def main():
    # Set up command-line argument parsing
    parser = argparse.ArgumentParser(description="Process text files and replace genome names with full paths.")
    parser.add_argument("input_folder", help="Folder containing text files with genome names.")
    parser.add_argument("genome_folder", help="Folder containing genome files (*.fa, *.hll) in subdirectories.")
    parser.add_argument("output_folder", help="Folder where output text files will be saved.")
    
    args = parser.parse_args()

    # Process the text files with the provided arguments
    process_text_files(args.input_folder, args.genome_folder, args.output_folder)

if __name__ == "__main__":
    main()
