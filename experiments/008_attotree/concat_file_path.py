#! /usr/bin/env python3

#given a list of genome id, extract them from a compressed file

import os
import argparse

DEFAULT_OUTPUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'list_of_files.txt')

def concat_path(leaves_order, path_to_files):
    
    #extract the id into a set
    id_file = open(leaves_order,"r")
    id_data = id_file.read()
    
    id_names = id_data.split('\n')

    list_of_files = [f'{path_to_files}/{name}.fa' for name in id_names if name != '']
    
    with open('list_of_files.txt', 'w') as f:
        for line in list_of_files:
            f.write(f"{line}\n")
    
            
def main():
    parser = argparse.ArgumentParser(description="")
    
    parser.add_argument(
        '-i',
        dest='id_file',
        required=True,
        metavar='str',
        help='Text file contain the id of genomes to be extracted',
    )
    
    parser.add_argument(
        '-a',
        dest= 'archive_dir',
        required=True,
        metavar='str',
        help='Directory contain all the compressed tarfiles',
    )
    
    
    args = parser.parse_args()
    
    concat_path(args.id_file, args.archive_dir)
    
if __name__ == "__main__":
    main()