#! /usr/bin/env python3

#given a list of genome id, extract them from a compressed file

from xopen import xopen
import tarfile
import os
import argparse

DEFAULT_OUTPUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'extracted_genomes')

def extract_genomes(genome_id_file, archives_dir, output_dir):
    
    #extract the id into a set
    id_file = open(genome_id_file,"r")
    id_data = id_file.read()
    
    neccessary_genomes = set(id_data.split('\n'))
    neccessary_genomes.discard('')
    tar_files = [archives_dir + '/'+ f for f in os.listdir(archives_dir) if tarfile.is_tarfile(archives_dir + '/'+ f)]
    
    number_of_file = len(tar_files)
    counter = 1
    for tar in tar_files:
        print(counter, '/', number_of_file, ': Searching in', ' ', tar)
        counter = counter + 1
        file = tarfile.open(tar)
        
        for genome in file.getmembers():   
            genome_id = genome.name.split('/')[1][:-3]
            if len(neccessary_genomes) == 0:
                print('Extracted all neccessary genomes.')
                return
            if genome_id in neccessary_genomes:
                file.extract(genome, path = output_dir)
                neccessary_genomes.discard(genome_id)
            
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
    
    parser.add_argument(
        '-o',
        dest='output_dir',
        metavar='str',
        default= DEFAULT_OUTPUT_DIR,
        help='Output directory',
    )
    
    args = parser.parse_args()
    
    extract_genomes(args.id_file, args.archive_dir, args.output_dir)
    
if __name__ == "__main__":
    main()