# Input: an archive file, a text file with a list of file name
# Output: a directory of needed genomes, a new batch input file

from xopen import xopen
import tarfile
import os


GENOMES_BATCH_LIST =[]
OUTPUT_PATH = ''

directory = '/home/ktruong/Documents/data/661k-xz'

tar_files = [directory + '/'+ f for f in os.listdir(directory) if tarfile.is_tarfile(directory + '/'+ f)]


#extract the needed genome from the archive
def extract_genomes(archive_name):
    #get the list of file from the archive
    tar = tarfile.open(archive_name)
    
    for member in tar.getmembers():
        genome_id = member.name.split('/')[1]
        if genome_id in GENOMES_BATCH_LIST:
            tar.extract(member, path = OUTPUT_PATH)
    return

extract_genomes('/home/ktruong/Documents/data/661k-xz/staphylococcus_aureus__06.tar.xz')