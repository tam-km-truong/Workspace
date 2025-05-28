library(tidyverse)

# Read CSV
data <- read.csv("experiments/037_candlestick_slope/slopes.csv", check.names = FALSE)
colnames(data)[1] <- "species"

# Pivot longer
data_long <- pivot_longer(data, cols = -species, names_to = "method", values_to = "value")

# Set method order manually
method_order <- c("random", "accession", "random_phylo", "accession_phylo", "phylo")
data_long$method <- factor(data_long$method, levels = method_order)

# Summarize: calculate min (low), max (high), mean (open), median (close) per method
candlestick_data <- data_long %>%
  group_by(method) %>%
  summarise(
    low = min(value),
    high = max(value),
    open = quantile(value, 0.25),  # First Quartile (Q1)
    close = quantile(value, 0.75)  # Third Quartile (Q3)
  )

# Manually define colors
custom_colors <- c(
  random = "#1f77b4",        # blue
  accession = "red",     # orange
  random_phylo = "cyan",  # green
  accession_phylo = "gold", # red
  phylo = "green"          # purple
)

# Plot
ggplot(candlestick_data, aes(x = method, fill = method)) +
  geom_linerange(aes(ymin = low, ymax = high), color = "black", size = 1) +
  geom_rect(aes(xmin = as.numeric(method) - 0.2,
                xmax = as.numeric(method) + 0.2,
                ymin = pmin(open, close),
                ymax = pmax(open, close)),
            color = "black") +
  # Points for species
  geom_point(data = data_long, aes(x = method, y = value), size = 2, shape = 21, fill = "white", stroke = 0.8)+
  
  # Labels for species
  geom_text_repel(data = data_long, aes(x = method, y = value, label = species),
                  size = 3, max.overlaps = 10, box.padding = 0.3, point.padding = 0.2, segment.size = 0.2) +
  
  scale_fill_manual(values = custom_colors) +  # <- Manual colors here
  theme_minimal() +
  labs(title = "Summary of Slopes for Top 6 Species: Distinct K-mers vs. Compression Size", x = "Ordering methods", y = "Slope values") +
  scale_x_discrete(expand = expansion(add = 0.5)) +
  expand_limits(y = 0) +
  guides(fill = "none")  +  # Remove legend
  theme(
    axis.text = element_text(size = 14),  # Increase axis text size
    axis.title = element_text(size = 16), # Increase axis title size
    plot.title = element_text(size = 18, face = "bold"),  # Increase plot title size
    legend.text = element_text(size = 14), # Increase legend text size
    legend.title = element_text(size = 16)  # Increase legend title size
  )

