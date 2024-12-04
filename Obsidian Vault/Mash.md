### In a nutshell
Mash uses the MinHash technique to create "sketches" of sequences,small, representation of sequences
Mash distance, an estimate of the mutation rate between sequences. I is calculated from the fraction of shared k-mers (Jaccard index) between MinHash sketches.

**MinHash sketches**:

1. **Generate k-mers**
2. **Hash each k-mer** to a number
3. **Select the smallest hashes**: Retain the _s_ smallest hash values (the "sketch size")
- **Smaller k values**:
    
    - more divergent sequences (higher sensitivity).
    - May lead to chance matches between unrelated sequences (lower specificity).
- **Larger k values**:
    
    - Provide greater specificity by reducing chance matches.
    - Lose sensitivity for divergent sequences.

Hash using MurmurHash3 for kmer hashing