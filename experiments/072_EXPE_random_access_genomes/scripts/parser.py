import argparse
import os
import sys
import pathlib
import random
from datetime import datetime
import time
import json 
import csv
import resource

def add_args(parser):
    parser.add_argument('-i','--input', help='Path to the the folder with fof of batches', default='experiments/072_EXPE_random_access_genomes/data/batches')
    parser.add_argument('-q','--queries', help='Path to the queries', default='experiments/072_EXPE_random_access_genomes/data/genomes_to_query.txt')
    parser.add_argument('-a','--archives', help='Path to the archives folders', default='experiments/072_EXPE_random_access_genomes/data')
    parser.add_argument('-o', '--output', help='Output bash file (default: current folder)', default='experiments/072_EXPE_random_access_genomes/scripts')
    parser.add_argument('-n', '--nb-gen-per-batch', help='Number of genomes per batch to query', default=60, type=int)
    parser.add_argument('-e','--extract-folder', help='Path to the folder storing the extracted files', default='experiments/072_EXPE_random_access_genomes/results')
    parser.add_argument('-t','--threads', help='Number of thread to be used', default=25)



def run_(args):

    input_dir = pathlib.Path(args.input)
    output_file = pathlib.Path(f"{args.archives}/genomes_to_query.txt")
    n = args.nb_gen_per_batch

    with output_file.open("w") as out:
        for txt_file in sorted(input_dir.glob("*.txt")):
            name = txt_file.stem
            out.write(name + "\n")
            with txt_file.open() as f:
                lines = f.readlines()
            sample = random.sample(lines, n)
            out.writelines(sample)

    with open(args.queries, 'r') as infile:
        lines = [ line.strip() for line in infile.readlines()]

    idx = 0
    bash_script_xz = []
    bash_script_mbgc = []
    bash_script_agc = []
    while idx < len(lines):
        current_batch = lines[idx]
        current_queries = [ os.path.basename(genome).split('.')[0] for genome in lines[idx+1:idx+n+1]]
        idx += (n + 1)
        bash_script_xz = bash_script_xz + [f'tar -xvf {args.archives}/xz/{current_batch}.tar.xz -C {args.extract_folder}/xz/ {current_batch}/{genome}.fa' for genome in current_queries]
        bash_script_mbgc = bash_script_mbgc + [f'mbgc d -t {args.threads} -f {genome}.fa {args.archives}/mbgc/{current_batch}.mbgc {args.extract_folder}/mbgc/{genome}.fa' for genome in current_queries]
        bash_script_agc = bash_script_agc + [f'agc getset -t {args.threads} {args.archives}/agc/{current_batch}.agc {genome} > {args.extract_folder}/agc/{genome}.fa.fa' for genome in current_queries]

        # print(current_batch)
        # print(current_queries)

    with open(f'{args.output}/benchmark_extraction_xz.sh','w') as outxz:
        for cmd in bash_script_xz:
            outxz.write(cmd + '\n')  
    with open(f'{args.output}/benchmark_extraction_mbgc.sh','w') as outmbgc:
        for cmd in bash_script_mbgc:
            outmbgc.write(cmd + '\n')      
    with open(f'{args.output}/benchmark_extraction_agc.sh','w') as outagc:
        for cmd in bash_script_agc:
            outagc.write(cmd + '\n')      

def main():
    parser = argparse.ArgumentParser(
        description='Create bash script to decompress genomes from archives.'
    )
    add_args(parser)
    args = parser.parse_args()
    run_(args)

if __name__ == "__main__":
    main()