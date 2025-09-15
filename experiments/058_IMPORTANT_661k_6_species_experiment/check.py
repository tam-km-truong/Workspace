print('Hello')
with open('experiments/058_IMPORTANT_661k_6_species_experiment/by_species.txt', 'r') as bs:
    l1 = [line.strip() for line in bs]
with open('experiments/058_IMPORTANT_661k_6_species_experiment/uncompressed.txt', 'r') as un:
    l2 = [line.strip() for line in un]

for it in l1:
    if it not in l2:
        print(it)

print('_____')

for it in l2:
    if it not in l1:
        print(it)