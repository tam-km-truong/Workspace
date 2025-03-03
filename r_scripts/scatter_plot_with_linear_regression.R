# Load necessary libraries
library(ggplot2)
library(dplyr)

# Set seed for reproducibility
set.seed(123)

# Generate synthetic data with 20 groups
n <- 500  # Total points
data <- data.frame(
  x = runif(n, 1, 100),  # Random x values
  group = factor(sample(1:20, n, replace = TRUE))  # Assign to 20 groups
)

# Create a different y value for each group with some noise
data <- data %>%
  group_by(group) %>%
  mutate(y = 2 * x + as.numeric(group) * 5 + rnorm(n()/20, sd = 10)) %>%
  ungroup()

# Plot scatter plot with linear regression lines for each group
ggplot(data, aes(x = x, y = y, color = group)) +
  geom_point(alpha = 0.6) +  # Scatter points
  geom_smooth(method = "lm", se = FALSE) +  # Linear regression lines
  theme_minimal() +
  labs(title = "Scatter Plot with Linear Regression Lines for 20 Groups",
       x = "X values",
       y = "Y values",
       color = "Group")

