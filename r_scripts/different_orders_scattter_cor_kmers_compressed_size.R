# Load required libraries

library(tidyverse) 
library(geomtextpath)


merge_species_data <- function(species, order) {
  # Construct the file paths for cardinalities and compression size
  path_card <- paste0("./experiments/019_version_2_snakemake_workflow/output/", species, "/", order, "/cardinalities.csv")
  path_cpr_size <- paste0("./experiments/019_version_2_snakemake_workflow/output/", species, "/", order, "/cpr_size.", order,".csv")
  
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
  
  # Merge the two data frames based on the cleaned file names
  merged_df <- inner_join(df_random_card, df_random_cpr, by = c("filename" = "name"))
  
  return(merged_df)
}

replace_outliers <- function(df, column) {
  Q1 <- quantile(df[[column]], 0.25)
  Q3 <- quantile(df[[column]], 0.75)
  IQR <- Q3 - Q1
  
  lower_bound <- Q1 - 1.5 * IQR
  upper_bound <- Q3 + 1.5 * IQR
  
  df$outlier <- df[[column]] < lower_bound | df[[column]] > upper_bound
  return(df)
}

species = "Mycobacterium_tuberculosis"
order = "random"
merged_df <- merge_species_data(species, order)
merged_df <- replace_outliers(merged_df, "size_MB")
merged_df <- replace_outliers(merged_df, "cardinality")

order = "accession"
merged_df2 <- merge_species_data(species, order)
merged_df2 <- replace_outliers(merged_df2, "size_MB")
merged_df2 <- replace_outliers(merged_df2, "cardinality")

order_phylo = "phylo"
merged_df3 <- merge_species_data(species, order_phylo)
merged_df3 <- replace_outliers(merged_df3, "size_MB")
merged_df3 <- replace_outliers(merged_df3, "cardinality")

# Calculate correlation for merged_df
cor_merged_df <- cor(merged_df$cardinality, merged_df$size_MB, method = "pearson")
print(paste("Correlation for merged_df:", cor_merged_df))

# Calculate correlation for merged_df2 (assuming you have this data frame)
cor_merged_df2 <- cor(merged_df2$cardinality, merged_df2$size_MB, method = "pearson")
print(paste("Correlation for merged_df2:", cor_merged_df2))

# Calculate correlation for merged_df2 (assuming you have this data frame)
cor_merged_df3 <- cor(merged_df3$cardinality, merged_df3$size_MB, method = "pearson")
print(paste("Correlation for merged_df3:", cor_merged_df3))

# Calculate correlation and regression equation for merged_df
lm_merged_df <- lm(size_MB ~ cardinality, data = merged_df)
slope_merged_df <- coef(lm_merged_df)[2]
intercept_merged_df <- coef(lm_merged_df)[1]
cor_merged_df <- cor(merged_df$cardinality, merged_df$size_MB, method = "pearson")
equation_merged_df <- paste("y = ", format(slope_merged_df, scientific = TRUE, digits = 3), "x +", round(intercept_merged_df, 2))

# Calculate correlation and regression equation for merged_df2
lm_merged_df2 <- lm(size_MB ~ cardinality, data = merged_df2)
slope_merged_df2 <- coef(lm_merged_df2)[2]
intercept_merged_df2 <- coef(lm_merged_df2)[1]
cor_merged_df2 <- cor(merged_df2$cardinality, merged_df2$size_MB, method = "pearson")
equation_merged_df2 <- paste("y = ", format(slope_merged_df2, scientific = TRUE, digits = 3), "x +", round(intercept_merged_df2, 2))

lm_merged_df3 <- lm(size_MB ~ cardinality, data = merged_df3)
slope_merged_df3 <- coef(lm_merged_df3)[2]
intercept_merged_df3 <- coef(lm_merged_df3)[1]
cor_merged_df3 <- cor(merged_df3$cardinality, merged_df3$size_MB, method = "pearson")
equation_merged_df3 <- paste("y = ", format(slope_merged_df3, scientific = TRUE, digits = 3), "x +", round(intercept_merged_df3, 2))


ggplot() +
  # Plot the first merged_df (existing data)
  geom_point(data = merged_df, aes(x = cardinality, y = size_MB), shape = 18, size = 4, color = 'blue') +
  geom_text(data = merged_df, aes(x = cardinality, y = size_MB, label = filename), size = 3, vjust = -0.5) +
  geom_labelsmooth(data = merged_df, aes(x = cardinality, y = size_MB, label = "random"), fill = "white", color = 'blue', 
                   method = "lm", formula = y ~ x, size = 3, linewidth = 1, boxlinewidth = 0.4) +
  
  # Plot the second merged_df2 (new data)
  geom_point(data = merged_df2, aes(x = cardinality, y = size_MB), shape = 18, size = 4, color = 'red') +
  geom_text(data = merged_df2, aes(x = cardinality, y = size_MB, label = filename), size = 3, vjust = -0.5) +
  geom_labelsmooth(data = merged_df2, aes(x = cardinality, y = size_MB, label = "accession"), fill = "white", color = 'red', 
                   method = "lm", formula = y ~ x, size = 3, linewidth = 1, boxlinewidth = 0.4) +
  # Plot the second merged_df3 (new data)
  geom_point(data = merged_df3, aes(x = cardinality, y = size_MB), shape = 18, size = 4, color = 'green') +
  geom_text(data = merged_df3, aes(x = cardinality, y = size_MB, label = filename), size = 3, vjust = -0.5) +
  geom_labelsmooth(data = merged_df3, aes(x = cardinality, y = size_MB, label = "phylo"), fill = "white", color = 'green', 
                   method = "lm", formula = y ~ x, size = 3, linewidth = 1, boxlinewidth = 0.4) +
  
  # Add correlation and equation text at the top
  annotate("text", x = 20000000, y = 30, 
           label = paste("Correlation (random):", round(cor_merged_df, 2), "\n", equation_merged_df), 
           color = "blue", size = 4, hjust = 1) +
  
  annotate("text", x = 20000000, y = 25, 
           label = paste("Correlation (accession):", round(cor_merged_df2, 2), "\n", equation_merged_df2), 
           color = "red", size = 4, hjust = 1) +
  
  annotate("text", x = 20000000, y = 20, 
           label = paste("Correlation (phylo):", round(cor_merged_df3, 2), "\n", equation_merged_df3), 
           color = "green", size = 4, hjust = 1) +
  
  # Customize plot appearance
  theme_minimal(base_size = 14) +
  theme(
    panel.border = element_blank(),
    axis.line = element_line(linewidth = 1.2)
  ) +
  #xlim(0, 111500000) +
  #ylim(0, 110) +
  labs(
    x = "Distinct Kmers",
    y = "Size(MB)",
    title = paste0("Compressed Size vs Distinct Kmers Count - ",species)
  )


ggplot() +
  # Plot the first merged_df (existing data)
  geom_point(data = merged_df, aes(x = cardinality, y = size_MB), shape = 18, size = 4, color = 'blue') +
  geom_text(data = merged_df, aes(x = cardinality, y = size_MB, label = filename), size = 3, vjust = -0.5) +
  geom_labelsmooth(data = merged_df, aes(x = cardinality, y = size_MB, label = "random"), fill = "white", color = 'blue', 
                   method = "lm", formula = y ~ x, size = 3, linewidth = 1, boxlinewidth = 0.4) +
  
  
  # Add correlation and equation text at the top
  annotate("text", x = 35000000, y = 80, 
           label = paste("Correlation (random):", round(cor_merged_df, 2), "\n", equation_merged_df), 
           color = "blue", size = 4, hjust = 1) +
  
  
  # Customize plot appearance
  theme_minimal(base_size = 14) +
  theme(
    panel.border = element_blank(),
    axis.line = element_line(linewidth = 1.2)
  ) +
  #xlim(0, 111500000) +
  #ylim(0, 110) +
  labs(
    x = "Distinct Kmers",
    y = "Size(MB)",
    title = paste0("Compressed Size vs Distinct Kmers Count - ",species)
  )

