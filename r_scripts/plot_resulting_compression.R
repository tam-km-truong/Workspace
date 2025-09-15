library(tidyverse)
library(ggbreak)
df <- data.frame(
  type = c("661k Collection", "AllTheBacteria v0.3"),
  gzipped = c(0.805, 3.9),
  with_phylo = c(0.029, 0.102)
)

# Reshape the data into long format for ggplot
df_long <- df %>% 
  pivot_longer(cols = -type, names_to = "variable", values_to = "value")

# Define new names for compression types
compression_labels <- c(
  "gzipped" = "Standard protocol",
  "with_phylo" = "Phylo. Reordering xz"
)

# Create the bar plot
ggplot(df_long, aes(x = type, y = value, fill = variable)) +
  geom_col(position = "dodge") +  # Dodged bars for each category
  theme_minimal() +  # Clean theme
  # geom_text(aes(label = c('805G','29G','3,9T','102G')), 
  #           position = position_dodge(width = 0.9), # Align text with bars
  #           vjust = -0.3, # Slightly above bars
  #           size = 8) +  # Text size
  scale_fill_manual(
    name = "Compression Strategy",   # Legend title
    values = c("gzipped" = "red","with_phylo" = "lightblue"),  # Custom colors
    labels = compression_labels  # Use custom labels
  ) +
  theme_minimal(base_size = 20) +
  labs(
    x = "",
    y = "Size (T)",
    fill = "Compression Strategy",
    title = "Comparison of Compressed Sizes"
  ) + scale_y_break(c(1, 2.5))+ 
  theme(axis.text.x = element_text(angle = 0, hjust = 0.5))  # Rotate x-axis labels for readability
