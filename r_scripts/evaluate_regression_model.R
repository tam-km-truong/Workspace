merge_species_data <- function(species, order) {
  # Construct the file paths for cardinalities and compression size
  path_card <- paste0("./experiments/021_20000_genomes_experiment/output/", species, "/", order, "/cardinalities.csv")
  path_cpr_size <- paste0("./experiments/021_20000_genomes_experiment/output/", species, "/", order, "/cpr_size.", order,".csv")
  
  # Read the cardinalities data
  df_random_card <- read_csv(path_card)
  df_random_card$filename <- gsub("\\.txt$", "", df_random_card$filename)
  
  # Read the compression size data
  df_random_cpr <- read_csv(path_cpr_size, col_names = c("name", "size_MB"))
  df_random_cpr$name <- basename(df_random_cpr$name)
  
  # Filter out any unwanted rows and clean file names
  df_random_cpr <- df_random_cpr %>%
    filter(name != ".snakemake_timestamp")
  df_random_cpr$name <- gsub("\\.tar.xz$", "", df_random_cpr$name)
  if (order == "accession_phylo" || order == "random_phylo"){
    df_random_cpr$name <- gsub("phylo_order_tree_", "", df_random_cpr$name)
  }
  
  # Merge the two data frames based on the cleaned file names
  merged_df <- inner_join(df_random_card, df_random_cpr, by = c("filename" = "name"))
  merged_df$cardinality <- merged_df$cardinality/1e+6
  return(merged_df)
}

replace_outliers_with_mean <- function(df, column) {
  Q1 <- quantile(df[[column]], 0.25, na.rm = TRUE)
  Q3 <- quantile(df[[column]], 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1
  
  lower_bound <- Q1 - 1.5 * IQR
  upper_bound <- Q3 + 1.5 * IQR
  
  mean_value <- mean(df[[column]], na.rm = TRUE)
  
  df[[column]] <- ifelse(df[[column]] < lower_bound | df[[column]] > upper_bound, mean_value, df[[column]])
  
  return(df)
}

species = "mycobacterium_tuberculosis"

train_random_df <- merge_species_data(species, "random")
train_accession_df2 <- merge_species_data(species, "accession")
train_phylo_df3 <- merge_species_data(species, "phylo")
train_accession_phylo_df <- merge_species_data(species, "accession_phylo")
train_random_phylo_df <- merge_species_data(species, "random_phylo")

train_df <- train_phylo_df3
test_order <- "phylo"
replace_outliers = FALSE

if (replace_outliers) {
  train_df <- replace_outliers_with_mean(train_df, "size_MB")
  train_df <- replace_outliers_with_mean(train_df, "cardinality")
}

train_data <- data.frame(x = train_df$cardinality, y = train_df$size_MB)
# train_data <- data.frame(x = df_salmonella_enterica$distinct_31mers, y = df_salmonella_enterica$size_MB)
# Step 2: Fit the linear regression model
lm_df <- lm(y ~ x, data = train_data)

# Step 3: Read the test data (distinct kmers and true compressed sizes)
path_test_distinct_kmers <- paste0("./experiments/022_predict_compression_sizes/output/", species, "/", test_order, "/cardinalities.csv")
test_distinct_kmers <- read_csv(path_test_distinct_kmers)
test_distinct_kmers$filename <- gsub("\\.txt$", "", test_distinct_kmers$filename)
test_distinct_kmers$cardinality <- test_distinct_kmers$cardinality/1e+6

path_true_compressed_sizes <- paste0("./experiments/022_predict_compression_sizes/output/", species, "/", test_order, "/cpr_size.", test_order,".csv")
true_compressed_sizes <- read_csv(path_true_compressed_sizes, col_names = c("name", "size_MB"))
true_compressed_sizes$name <- basename(true_compressed_sizes$name)

# Filter out any unwanted rows and clean file names
true_compressed_sizes <- true_compressed_sizes %>%
  filter(name != ".snakemake_timestamp")
true_compressed_sizes$name <- gsub("\\.tar.xz$", "", true_compressed_sizes$name)
if (test_order == "accession_phylo" || test_order == "random_phylo"){
  true_compressed_sizes$name <- gsub("phylo_order_tree_", "", true_compressed_sizes$name)
}

# Step 4: Calculate the predicted compressed size from the distinct kmers count
test_data <- data.frame(x = test_distinct_kmers$cardinality)
predicted_compressed_sizes <- predict(lm_df, newdata = test_data)

# Step 5: Evaluate the model using different metrics

# Mean Squared Error (MSE)
mse <- mean((true_compressed_sizes$size_MB - predicted_compressed_sizes)^2)

# Mean Absolute Error (MAE)
mae <- mean(abs(true_compressed_sizes$size_MB - predicted_compressed_sizes))

# Root Mean Squared Error (RMSE)
rmse <- sqrt(mse)

# R-squared (R²)
rsq <- 1 - sum((true_compressed_sizes$size_MB - predicted_compressed_sizes)^2) / sum((true_compressed_sizes$size_MB - mean(true_compressed_sizes$size_MB))^2)

# Print evaluation metrics
cat("Model Evaluation Metrics:\n", species)
cat("Mean Squared Error (MSE):", mse, "\n")
cat("Mean Absolute Error (MAE):", mae, "\n")
cat("Root Mean Squared Error (RMSE):", rmse, "\n")
cat("R-squared (R²):", rsq, "\n")
