# Create batches steps

## Metadata download

Original metadata from 661k paper: [download](https://figshare.com/ndownloader/files/30449916)

BakRep metadata download:

To download the metadata of 661402 genomes (There are 3 missing?):

Go to [BakRep Search](https://bakrep.computational.bio/search).

Search without any condition.

Export the result using the 'Export as tsv' feature provided.

## Compress tsv to tsv.xz

Compress the metadata file using xz:

```shell
xz [filename.tsv]
```

## run create_batches.py

exemple 1: BakRep metadata

```shell
./create_batches.py /home/ktruong/Documents/code/Workspace/files/bakrep-export-661k.tsv.xz -s bakta.genome.species -f '#id'
```

Loaded 661401 genomes across 3914 species clusters

Put 16467 genomes of 3796 species into the dustbin

Created 277 batches of 119 pseudoclusters

Finished



exemple 2: original 661k metadata

```shell
./create_batches.py /home/ktruong/Documents/code/Workspace/files/File1_full_krakenbracken.tsv.xz -s V2 -f 'sample_id'
```

Loaded 661403 genomes across 2600 species clusters

Put 21912 genomes of 2458 species into the dustbin

Created 305 batches of 143 pseudoclusters

Finished

