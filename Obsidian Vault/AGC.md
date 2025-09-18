```bash
for f in data/batches/subdir_1/*; do ref=$(head -n 1 $f); echo $f; agc create -a -b 500 -s 1500 -t 25 -v 2 -o results/agc/$(basename $f .txt).agc -i $f $ref; done
```