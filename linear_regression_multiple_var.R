library(tidyverse) 
library(geomtextpath)

compute_equation <- function(df, x, y) {
  
  lm_df <- lm(y ~ x, data = df)
  slope_df <- coef(lm_df)[2]
  intercept_df <- coef(lm_df)[1]
  if (intercept_df<0) {
    equation_df <- paste("y = ", round(slope_df,5), 
                         "x -", round(intercept_df*-1, 5))
  } else {
    equation_df <- paste("y = ", round(slope_df,5), 
                         "x +", round(intercept_df, 5))
  }
  
  return(equation_df)
}

df_cpr <- read_csv("./experiments/064_xz_binning_phylo_order/compression_results.csv",col_names = c("size_MB", "name"))
df_cpr$size_MB <- df_cpr$size_MB/1e+6
cardinalities <- read_csv("./experiments/064_xz_binning_phylo_order/cardinalities.csv", col_names = c("nb_genomes","batches"))
distinct_31mers_batches <- read_csv("./experiments/064_xz_binning_phylo_order/distinct_kmers.csv", col_names = c("batches", "distinct_31mers"))

merged_df <- inner_join(df_cpr, cardinalities, by = c("name" = "batches"))
merged_df <- inner_join(merged_df, distinct_31mers_batches, by = c("name" = "batches"))
merged_df$distinct_31mers <- merged_df$distinct_31mers/1e+6

equation_size_nb_genomes<-compute_equation(merged_df,merged_df$nb_genomes,merged_df$size_MB)
equation_size_kmers<-compute_equation(merged_df,merged_df$distinct_31mers,merged_df$size_MB)

correlations <- merged_df %>%
  summarise(
    cor_nb_genomes   = cor(nb_genomes, size_MB),
    cor_distinct31   = cor(distinct_31mers, size_MB)
  )

# Generate the plot
plot1<-ggplot(merged_df, aes(x = distinct_31mers, y = size_MB)) +
  geom_point(shape = 18, size = 4)+
  geom_labelsmooth(aes(label = "Linear fit"),fill = "white",
                   method = "lm", formula = y ~ x,
                   size = 3, linewidth = 1, boxlinewidth = 0.4) +
  theme_minimal(base_size = 14) +
  theme(
    panel.border = element_blank(),
    axis.line = element_line(linewidth = 1.2)
  ) +
  labs(
    x = "Distinct Kmers (M)",
    y = "Size (MB)",
    title = "Compressed Size vs Distinct Kmers Count - 661k Collection",
    color = "Species"
  )

plot2<-ggplot(merged_df, aes(x = nb_genomes, y = size_MB)) +
  geom_point(shape = 18, size = 4)+
  geom_labelsmooth(aes(label = "Linear fit"),fill = "white",
                   method = "lm", formula = y ~ x,
                   size = 3, linewidth = 1, boxlinewidth = 0.4) +
  theme_minimal(base_size = 14) +
  theme(
    panel.border = element_blank(),
    axis.line = element_line(linewidth = 1.2)
  ) +
  labs(
    x = "Distinct Kmers (M)",
    y = "Size (MB)",
    title = "Compressed Size vs nb of genomes - 661k Collection",
    color = "Species"
  )

plot1
plot2

model <- lm(size_MB ~ nb_genomes + distinct_31mers, data = merged_df)
summary(model)
