# Load required libraries

library(tidyverse) 
library(geomtextpath)
library(ggrepel)
library(shadowtext)

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

compute_equation <- function(df, x, y) {
  
  lm_df <- lm(y ~ x, data = df)
  slope_df <- coef(lm_df)[2]
  intercept_df <- coef(lm_df)[1]
  if (intercept_df<0) {
    equation_df <- paste("y = ", round(slope_df,3), 
                         "x -", round(intercept_df*-1, 3))
  } else {
    equation_df <- paste("y = ", round(slope_df,3), 
                         "x +", round(intercept_df, 3))
  }
  
  return(equation_df)
}

species = "Staphylococcus_aureus"
replace_outliers = FALSE
replace_outliers = TRUE

adjust_annotation_x = 1
adjust_annotation_y = 0.45

merged_df <- merge_species_data(species, "random")
merged_df2 <- merge_species_data(species, "accession")
merged_df3 <- merge_species_data(species, "phylo")
accession_phylo_df <- merge_species_data(species, "accession_phylo")
random_phylo_df <- merge_species_data(species, "random_phylo")

max_x = max(merged_df$cardinality, merged_df2$cardinality,merged_df3$cardinality)
max_y = max(merged_df$size_MB,merged_df2$size_MB,merged_df3$size_MB)

# max_x = 200
# max_y = 40

if (replace_outliers) {
  merged_df <- replace_outliers_with_mean(merged_df, "size_MB")
  merged_df <- replace_outliers_with_mean(merged_df, "cardinality")
  
  merged_df2 <- replace_outliers_with_mean(merged_df2, "size_MB")
  merged_df2 <- replace_outliers_with_mean(merged_df2, "cardinality")  
  
  merged_df3 <- replace_outliers_with_mean(merged_df3, "size_MB")
  merged_df3 <- replace_outliers_with_mean(merged_df3, "cardinality")
  
  accession_phylo_df <- replace_outliers_with_mean(accession_phylo_df, "size_MB")
  accession_phylo_df <- replace_outliers_with_mean(accession_phylo_df, "cardinality")
  
  random_phylo_df <- replace_outliers_with_mean(random_phylo_df, "size_MB")
  random_phylo_df <- replace_outliers_with_mean(random_phylo_df, "cardinality")
}

# Calculate correlation for merged_df
cor_merged_df <- cor(merged_df$cardinality, merged_df$size_MB, method = "pearson")

# Calculate correlation for merged_df2 (assuming you have this data frame)
cor_merged_df2 <- cor(merged_df2$cardinality, merged_df2$size_MB, method = "pearson")

# Calculate correlation for merged_df2 (assuming you have this data frame)
cor_merged_df3 <- cor(merged_df3$cardinality, merged_df3$size_MB, method = "pearson")
# print(paste("Correlation for merged_df3:", cor_merged_df3))

cor_accession_phylo_df <- cor(accession_phylo_df$cardinality, 
                              accession_phylo_df$size_MB, method = "pearson")

cor_random_phylo_df <- cor(random_phylo_df$cardinality, 
                           random_phylo_df$size_MB, method = "pearson")

# Calculate correlation and regression equation for merged_df
equation_merged_df <- compute_equation(merged_df, merged_df$cardinality,merged_df$size_MB)
# Calculate correlation and regression equation for merged_df2
equation_merged_df2 <- compute_equation(merged_df2, merged_df2$cardinality,merged_df2$size_MB)

equation_merged_df3 <- compute_equation(merged_df3, merged_df3$cardinality,merged_df3$size_MB)

equation_accession_phylo_df <-compute_equation(accession_phylo_df,
                                               accession_phylo_df$cardinality,
                                               accession_phylo_df$size_MB)

equation_random_phylo_df <-compute_equation(random_phylo_df,
                                            random_phylo_df$cardinality,
                                            random_phylo_df$size_MB)

annotate_x = (min(merged_df$cardinality, merged_df2$cardinality,merged_df3$cardinality) + max_x)/adjust_annotation_x
annotate_y = (min(merged_df$size_MB,merged_df2$size_MB,merged_df3$size_MB) + max_y)*adjust_annotation_y

# Define a list of datasets and their corresponding colors & labels
datasets <- list(
  list(df = merged_df, color = "blue", label = "random", cor = cor_merged_df, equ = equation_merged_df),
  
  list(df = merged_df2, color = "red", label = "accession", cor = cor_merged_df2, equ = equation_merged_df2),
  
  list(df = merged_df3, color = "green", label = "phylo", cor = cor_merged_df3, equ = equation_merged_df3),
  
  list(df = accession_phylo_df, color = "gold", label = "accession_phylo", cor = cor_accession_phylo_df, equ = equation_accession_phylo_df),
  
  list(df = random_phylo_df, color = "cyan", label = "random_phylo", cor = cor_random_phylo_df, equ = equation_random_phylo_df)
)
p <- ggplot()

for (data in datasets) {
  p <- p +
    geom_point(data = data$df, aes(x = cardinality, y = size_MB), shape = 4, size = 2, color = data$color) +
    # geom_text_repel(data = data$df, aes(x = cardinality, y = size_MB, label = filename), 
    #                 size = 2, color = data$color) +
    geom_labelsmooth(data = data$df, aes(x = cardinality, y = size_MB, label = ""), 
                     fill = "white", color = data$color, method = "lm", formula = y ~ x, 
                     size =3, linewidth = 0.5, boxlinewidth = 0.4)
}

# Add correlation and equation text at the top
y_positions <- seq(annotate_y * 1.4, annotate_y * 0.8, length.out = length(datasets))
for (i in seq_along(datasets)) {
  p <- p +
    annotate("text", x = annotate_x, y = y_positions[i], 
             label = paste0("R (", datasets[[i]]$label, "): ", 
                            round(datasets[[i]]$cor, 2), "\n", datasets[[i]]$equ), 
             color = datasets[[i]]$color, size = 4, hjust = 1, fontface = "bold")
}

# Define tick breaks based on the max range
# max_value <- max(max_x, max_y)  # Find the largest range to synchronize ticks
# breaks_seq <- seq(0, max_value * 1.1, length.out = 6)  # Generate 6 evenly spaced ticks

# Finalize plot
p + 
  theme_minimal(base_size = 14) +
  theme(
    panel.border = element_blank(),
    axis.line = element_line(linewidth = 1.2)
  ) +
  # Set x-axis limits with labels in "M" format
  scale_x_continuous( limits = c(-max_x * 0.1, max_x * 1.2)) +  # Ensure x-axis starts from 0
  # Set y-axis limits
  scale_y_continuous(limits = c(-max_y * 0.1, max_y * 1.2)) +  
  labs(
    x = "Distinct Kmers (M)",
    y = "Size (MB)",
    title = paste0("Compressed Size vs Distinct Kmers Count - ", species)
  )

# plot_secondary <- ggplot() +
#   # Plot the first merged_df (existing data)
#   geom_point(data = merged_df3, aes(x = cardinality, y = size_MB), shape = 18, size = 4, color = 'green') +
#   geom_text(data = merged_df3, aes(x = cardinality, y = size_MB, label = filename), size = 3, vjust = -0.5) +
#   geom_labelsmooth(data = merged_df3, aes(x = cardinality, y = size_MB, label = "phylo"), fill = "white", color = 'green', 
#                    method = "lm", formula = y ~ x, size = 3, linewidth = 1, boxlinewidth = 0.4) +
#   
#   
#   annotate("text", x = 10000000, y = 5, 
#            label = paste("Correlation (phylo):", round(cor_merged_df3, 2), "\n", equation_merged_df3), 
#            color = "green", size = 4, hjust = 1) +
#   
#   
#   # Customize plot appearance
#   theme_minimal(base_size = 14) +
#   theme(
#     panel.border = element_blank(),
#     axis.line = element_line(linewidth = 1.2)
#   ) +
#   #xlim(0, 111500000) +
#   #ylim(0, 110) +
#   labs(
#     x = "Distinct Kmers",
#     y = "Size(MB)",
#     title = paste0("Compressed Size vs Distinct Kmers Count - ",species)
#   )

