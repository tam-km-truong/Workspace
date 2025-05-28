setup
testing to compare mash distance of 1 genomes and 10000 reference genomes

remark
mash sketch reference can pre sketch a list of genome
then just compare it

clI:
mash sketch -l experiments/029_mash_sketches_ecoli/Escherichia_coli.full_path.txt -o ref_ecoli_10k -p 10 -s 10000

then

mash info ref_ecoli_10k.msh 

and

mash dist ref_ecoli_10k.msh /Users/ktruong/data/661k/gziped_full/escherichia_coli__01/SAMD00002695.fa.gz 
