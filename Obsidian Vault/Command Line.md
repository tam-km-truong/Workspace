Add `time` before the command you want to measure. For example: `time ls`.
Move all into 1 folder mv source source source destination
mv ./salmonella_enterica__08/* ./salmonella_enterica__37/* ./salmonella_enterica__38/* ./salmonella_enterica__08_37_38_12k
![[Pasted image 20241211105420.png]]
symlink hard vs soft
```shell
ln -s <path to the file/folder to be linked> <the path of the link to be created>
```

conda info --envs
to view list of environments

**chmod +x filename**

du -ch --block-size=1M  ./* >> files_size.csv
./kmc -k31 -fa genome.fa countkmerstuber01.res ./kmc_tmp_dir

`<(cat *.fa)` is a **process substitution**

```
for d in /home/ktruong/Documents/data/tuberculosis/*; do ./dashing_s128 card -k 31 <(cat $d/*.fa); 
done
```