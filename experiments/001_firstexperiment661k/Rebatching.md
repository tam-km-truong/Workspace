# Create batches steps

## Metadata download

Original metadata from 661k paper: [download](https://figshare.com/ndownloader/files/30449916)

BakRep metadata download:

To download the metadata of 661402 genomes (There are 3 missing?):

Go to [BakRep Search](https://bakrep.computational.bio/search).

Search without any condition.

Export the result using the 'Export as tsv' feature provided.

Now can be download directly from the website

## Compress tsv to tsv.xz

Compress the metadata file using xz:

```shell
xz [filename.tsv]
```

## Run create_batches.py

exemple 1: BakRep metadata

```shell
./create_batches.py /home/ktruong/Documents/code/Workspace/files/bakrep-export_18112024.tsv.xz -s gtdbtk.classification.species -f '#id'
```
Loaded 661401 genomes across 8208 species clusters

Put 25485 genomes of 8067 species into the dustbin

Created 306 batches of 142 pseudoclusters

Finished

exemple 2: original 661k metadata

```shell
./create_batches.py /home/ktruong/Documents/code/Workspace/files/File1_full_krakenbracken.tsv.xz -s V2 -f 'sample_id'
```

Loaded 661403 genomes across 2600 species clusters

Put 21912 genomes of 2458 species into the dustbin

Created 305 batches of 143 pseudoclusters

Finished


## Download the 661k collection

The compressed 661k collection with MiniPhy is available at [zenodo](https://zenodo.org/record/4602622)

The 661k collection is downloadable from [ebi](http://ftp.ebi.ac.uk/pub/databases/ENA2018-bacteria-661k/)
The entire compressed file here is 750gb.

## Extract genomes from the collection
Use extract_genomes.py in experiment 003 to extract the needed genomes for each batch from create_batches.py

## Continue by following MiniPhy instruction
                                                                                                                        
