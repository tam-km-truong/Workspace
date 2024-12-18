# take into 2 fasta files, calculate the mash distance between them

import argparse

def calcualte_mash_distance(file1, file2):
    print(file1)
    print(file2)
    return 0

def main():
    
    parser = argparse.ArgumentParser(description="")
    
    parser.add_argument(
        dest='file1',
        metavar='str',
        help='path to genome file 1',
    )
    
    parser.add_argument(
        dest= 'file2',
        metavar='str',
        help='path to genome file 2' ,
    )    
    
    args = parser.parse_args()
    
    calcualte_mash_distance(args.file1, args.file2)
    
    
if __name__ == "__main__":
    main()