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