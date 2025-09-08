# Figure and Table Generation for Nature HSSC Submission
# Publication-ready outputs with Helvetica font and white backgrounds

library(ggplot2)
library(dplyr)
library(stargazer)

# Set theme for all figures (Nature requirements: Helvetica font, white background)
theme_nature <- theme_minimal() +
  theme(
    text = element_text(family = "Arial", size = 10),  # Helvetica alternative
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    legend.background = element_rect(fill = "white", color = NA),
    strip.background = element_rect(fill = "white", color = NA)
  )

# Load final dataset
data <- read.csv("data/final/final_analytical_dataset.csv")
balance_data <- read.csv("data/final/balance_index_calculations.csv")

# Figure 1: Time series by income groups (as described in manuscript)
# "Shows mean graduation rates with 95% confidence intervals for high-income,
#  upper-middle-income, lower-middle-income, and low-income countries"

figure1_data <- data %>%
  group_by(year, income_group) %>%
  summarise(
    mean_isced5 = mean(isced5_graduates, na.rm = TRUE),
    se_isced5 = sd(isced5_graduates, na.rm = TRUE) / sqrt(n()),
    mean_isced6 = mean(isced6_graduates, na.rm = TRUE),
    se_isced6 = sd(isced6_graduates, na.rm = TRUE) / sqrt(n()),
    mean_isced7_8 = mean(isced7_8_graduates, na.rm = TRUE),
    se_isced7_8 = sd(isced7_8_graduates, na.rm = TRUE) / sqrt(n()),
    .groups = 'drop'
  ) %>%
  filter(!is.na(income_group))

figure1 <- ggplot(figure1_data, aes(x = year, color = income_group)) +
  geom_line(aes(y = mean_isced5), size = 1, linetype = "solid") +
  geom_ribbon(aes(ymin = mean_isced5 - 1.96*se_isced5, 
                  ymax = mean_isced5 + 1.96*se_isced5,
                  fill = income_group), alpha = 0.2) +
  labs(
    title = "Tertiary Education Graduation Rates by ISCED Level",
    subtitle = "Mean rates with 95% confidence intervals by income group (2000-2023)",
    x = "Year",
    y = "Graduation Rate (%)",
    color = "Income Group",
    fill = "Income Group"
  ) +
  scale_color_manual(values = c("High income" = "#1f77b4", 
                               "Upper middle income" = "#ff7f0e",
                               "Lower middle income" = "#2ca02c", 
                               "Low income" = "#d62728")) +
  scale_fill_manual(values = c("High income" = "#1f77b4", 
                              "Upper middle income" = "#ff7f0e",
                              "Lower middle income" = "#2ca02c", 
                              "Low income" = "#d62728")) +
  theme_nature

ggsave("output/figures/figure1_time_series.png", figure1, 
       width = 10, height = 6, dpi = 300, bg = "white")

# Figure 3: Regional distributions of Balance Index
# "Panel A: Distribution by world region (equal-weights). Panel B: Distribution by region (PCA)"

figure3_data <- balance_data %>%
  filter(!is.na(region), !is.na(balance_index_equal), !is.na(balance_index_pca))

# Panel A: Equal-weights
panel_a <- ggplot(figure3_data, aes(x = region, y = balance_index_equal)) +
  geom_boxplot(fill = "lightblue", alpha = 0.7) +
  labs(title = "Panel A: Equal-weights Construction",
       x = "World Region", y = "Balance Index") +
  theme_nature +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Panel B: PCA
panel_b <- ggplot(figure3_data, aes(x = region, y = balance_index_pca)) +
  geom_boxplot(fill = "lightgreen", alpha = 0.7) +
  labs(title = "Panel B: PCA Construction",
       x = "World Region", y = "Balance Index") +
  theme_nature +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Combine panels
library(gridExtra)
figure3 <- grid.arrange(panel_a, panel_b, ncol = 2)

ggsave("output/figures/figure3_regional_distributions.png", figure3, 
       width = 12, height = 6, dpi = 300, bg = "white")

print("All figures generated successfully!")
print("Files saved to output/figures/ directory")
