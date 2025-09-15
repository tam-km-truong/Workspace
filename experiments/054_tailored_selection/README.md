Step 1: generate references and queries datasets from jupyter notebook (selection)

Step 2: prepend path

```bash
python python_scripts/find_genome_paths.py ref_input  ~/data/661k/gziped_full/ ref_output --is_text
```

```bash
python python_scripts/find_genome_paths.py rem_input  ~/data/661k/gziped_full/ rem_output --is_text
```

Step 3: run attotree then postprocess then prepend the path

```bash
attotree -L ref_input -o tree.nw -t 10
```

```bash
python python_scripts/postprocess_tree.py --standardize --midpoint-outgroup --ladderize --name-internals -l leaf_output.txt -n node_output.txt tree.nw tree.std.nw
```

```bash
python python_scripts/find_genome_paths.py leaf_output  ~/data/661k/gziped_full/ leaf_output_path --is_text
```

```bash
mash sketch -l leaf_order.txt -o ref_sketch.msh -p 10 -s 1000
```

```bash
time python experiments/034_phylogenetic_placements/compute_distance_matrix.py ref.msh remains.txt -l -o distance.csv -v -t 10
```

real	63m35.042s
user	308m6.761s
sys	94m50.553s

need rerun

Step 6: run jupyter notebook for genomes assignment

Step 7: prependpath for local and for cluster, split into 4000

local

```bash
python python_scripts/find_genome_paths.py input  ~/data/661k/gziped_full/ output --is_text
```

genouest - copy from without path first
```bash
sed -i '' 's|^|/projects/reall/tam/data/661k/uncompressed_fastas/|; s|$|.fa|' input
```

split for all

```bash
gsplit -l 4000 -d -a 2 --additional-suffix=.txt experiments/046_selection_strategy_percentage_for_single_species/first_reorder/genouest_path/first_order_01.txt experiments/046_selection_strategy_percentage_for_single_species/batches/genouest_batches/batch_01__
```

8th step: compress with the workflow on the cluster