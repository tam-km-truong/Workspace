use std::collections::HashSet;
use std::env;
use std::fs;
use std::io::{self, BufRead};
use std::path::Path;
use tar::Archive;

fn extract_genomes(genome_id_file: &str, archives_dir: &str, output_dir: &str) -> io::Result<()> {
    // Read genome IDs into a HashSet
    let file = fs::File::open(genome_id_file)?;
    let reader = io::BufReader::new(file);
    let mut necessary_genomes: HashSet<String> = reader
        .lines()
        .filter_map(Result::ok)
        .filter(|line| !line.is_empty())
        .collect();    

    for x in &necessary_genomes {
        println!("{x:?}");
    }

    return Ok(());
}

fn main() {
    let file_name = "/home/ktruong/Documents/code/Workspace/experiments/002_BatchesUsingBakRep/BakRep_batches/acinetobacter_baumannii__01.txt";
    if let Err(e) = extract_genomes(file_name, "", "") {
        eprintln!("Error: {}", e);
    }
}
