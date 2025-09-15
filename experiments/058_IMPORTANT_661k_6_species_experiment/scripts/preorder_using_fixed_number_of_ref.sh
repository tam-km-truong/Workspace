declare -a arr=("100" "250" "500" "750" "1000" "2500" "5000" "7500" "10000" "12500" "15000" "17500" "20000")

for i in "${arr[@]}"
    do
        for f in /Users/ktruong/workspace/Workspace/experiments/058_IMPORTANT_661k_6_species_experiment/input_genomes/*.txt
            do
                basename=$(basename $f .txt)
                echo "running $basename and $i"
                phylopack preorder $f -o /Users/ktruong/workspace/Workspace/experiments/058_IMPORTANT_661k_6_species_experiment/placement_orders_fixed_size/${basename}_placement_order_${i}.txt --verbose --statistic --cut-point $i --statistic-file-type csv
            done
    done