./miniphy2 compress 
--output: path to output file
--list: input is a list
--compression: use this to xz compress

miniphy2 to install has to have cmake available


#[test]

fn test_read_fof() {

let fof_path = create_temp_file("file1.fa\nfile2.fa\nfile3.fa", "txt");

let fof_string = fof_path.to_str().unwrap().to_string();

let result = read_fof(Some(&fof_string), None);

assert_eq!(result, vec!["file1.fa", "file2.fa", "file3.fa"]);

}

  

#[test]

#[should_panic]

fn test_read_fof_missing_file() {

read_fof(Some(&"non_existent.fof".to_string()), None);

}

  

#[test]

fn test_read_fof_with_input_dir() {

let fof_path = create_temp_file("file1.fa\nfile2.fa", "txt");

let fof_string = fof_path.to_str().unwrap().to_string();

let input_string = "/tmp/my_tmp_dir".to_string();

let result = read_fof(Some(&fof_string), Some(&input_string));

assert_eq!(

result,

vec!["/tmp/my_tmp_dir/file1.fa", "/tmp/my_tmp_dir/file2.fa"]

);

}


error on the clusters 

        ./miniphy2 compress -p 'batch_035/' -lfo /projects/reall/tam/data/661k/taxo_independent/batches_4000_compressed_result/batch_035.tar.xz /projects/reall/tam/data/661k/taxo_independent/batches_4000/subdir_1/batch_035.txt

        (command exited with non-zero exit code)

[Sun May 25 09:04:58 2025]

Error in rule compress_batch:

    message: None

    jobid: 72

    input: /projects/reall/tam/data/661k/taxo_independent/batches_4000/subdir_1/batch_021.txt

    output: /projects/reall/tam/data/661k/taxo_independent/batches_4000_compressed_result/batch_021.tar.xz

    shell:

        ./miniphy2 compress -p 'batch_021/' -lfo /projects/reall/tam/data/661k/taxo_independent/batches_4000_compressed_result/batch_021.tar.xz /projects/reall/tam/data/661k/taxo_independent/batches_4000/subdir_1/batch_021.txt

        (command exited with non-zero exit code)

[Sun May 25 09:04:58 2025]

Error in rule compress_batch:

    message: None

    jobid: 65

    input: /projects/reall/tam/data/661k/taxo_independent/batches_4000/subdir_1/batch_037.txt

    output: /projects/reall/tam/data/661k/taxo_independent/batches_4000_compressed_result/batch_037.tar.xz

    shell:

        ./miniphy2 compress -p 'batch_037/' -lfo /projects/reall/tam/data/661k/taxo_independent/batches_4000_compressed_result/batch_037.tar.xz /projects/reall/tam/data/661k/taxo_independent/batches_4000/subdir_1/batch_037.txt

        (command exited with non-zero exit code)

[Sun May 25 09:04:58 2025]

Error in rule compress_batch:

    message: None

    jobid: 2

    input: /projects/reall/tam/data/661k/taxo_independent/batches_4000/subdir_1/batch_057.txt

    output: /projects/reall/tam/data/661k/taxo_independent/batches_4000_compressed_result/batch_057.tar.xz

    shell:

        ./miniphy2 compress -p 'batch_057/' -lfo /projects/reall/tam/data/661k/taxo_independent/batches_4000_compressed_result/batch_057.tar.xz /projects/reall/tam/data/661k/taxo_independent/batches_4000/subdir_1/batch_057.txt

        (command exited with non-zero exit code)

Complete log(s): /projects/reall/tam/tools/miniphy2/.snakemake/log/2025-05-25T090455.078179.snakemake.log

WorkflowError:

At least one job did not complete successfully.