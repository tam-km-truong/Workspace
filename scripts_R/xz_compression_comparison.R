library(tidyverse)
library(ggbreak)

# Create a properly formatted dataframe
df <- data.frame(
  type = c("xz-random-sample-5000", "xz-salmonella-enterica-10000"),
  no_phylo = c(5.2, 0.9),
  with_phylo = c(4.2, 0.2)
)

# Reshape the data into long format for ggplot
df_long <- df %>%
  pivot_longer(cols = -type, names_to = "variable", values_to = "value")

# Define new names for compression types
compression_labels <- c(
  "no_phylo" = "Without Phylo. Reordering",
  "with_phylo" = "With Phylo. Reordering"
)

# Create the bar plot
ggplot(df_long, aes(x = c('5000 random sampled genomes','5000 random sampled genomes','10000 Sal. enterica genomes','10000 Sal. enterica genomes'), y = value, fill = variable)) +
  geom_col(position = "dodge") +  # Dodged bars for each category
  theme_minimal() +  # Clean theme
  geom_text(aes(label = c('5.2G','4.2G','0.9G','0.2G')), 
            position = position_dodge(width = 0.9), # Align text with bars
            vjust = -0.3, # Slightly above bars
            size = 4) +  # Text size
  scale_fill_manual(
    name = "Compression Strategy",   # Legend title
    values = c("no_phylo" = "green", "with_phylo" = "lightblue"),  # Custom colors
    labels = compression_labels  # Use custom labels
  ) +
  theme_minimal(base_size = 20) +
  labs(
    x = "",
    y = "Size (GB)",
    fill = "Compression Strategy",
    title = "Comparison of XZ Compressed Sizes"
  ) +
  theme(axis.text.x = element_text(angle = 0, hjust = 0.5))  # Rotate x-axis labels for readability


