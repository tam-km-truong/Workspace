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
df_cpr$species <- "ecoli"
df_cpr$size_MB <- df_cpr$size_MB/1e+6
distinct_31mers_batches <- read_csv("./experiments/064_xz_binning_phylo_order/distinct_kmers.csv", col_names = c("batches", "distinct_31mers"))
merged_df <- inner_join(df_cpr, distinct_31mers_batches, by = c("name" = "batches"))
merged_df$distinct_31mers <- merged_df$distinct_31mers/1e+6
eq_escherichia_coli<-compute_equation(merged_df,
                                      merged_df$distinct_31mers,merged_df$size_MB)
correlations <- merged_df %>%
  summarise(cor_value = cor(distinct_31mers, size_MB))


equations<- list(eq_escherichia_coli)

# Generate the plot
plot1<-ggplot(merged_df, aes(x = distinct_31mers, y = size_MB, color = species)) +
  geom_point(shape = 18, size = 4)+
  geom_labelsmooth(aes(label = species), fill = "white",
                   method = "lm", formula = y ~ x,
                   size = 3, linewidth = 1, boxlinewidth = 0.4) +
  xlim(0, 200) +
  ylim(0, 100) +
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
  )+
  theme(legend.position = c(0.95, 0.05),  # Bottom right
        legend.justification = c(1, 0)) 

# Add correlation and equation text at the top
y_positions <- seq(22 * 1.9, 22 * 0.3, length.out = length(equations))
for (i in seq_along(equations)) {
  plot1 <- plot1 +
    annotate("text", x = 150, y = y_positions[i], 
             label = paste0(equations[[i]]), 
             color = colors[[i]], size = 5, hjust = 1, fontface = "bold")
}

plot1
