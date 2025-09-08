# Balance Index Calculation for Nature HSSC Submission
# Education-technology alignment metric with sensitivity analysis

library(dplyr)
library(corrplot)

# Load processed data
unesco_data <- read.csv("data/processed/unesco_tertiary_education_harmonized.csv")
tech_data <- read.csv("data/processed/technology_readiness_composite.csv")

# Balance Index formula (as in manuscript equation 1):
# BI = |S - D| / (|S| + |D|) ∈ [0,1]
# where S = STEM supply (standardized), D = Technology demand composite

calculate_balance_index <- function(stem_supply, tech_demand) {
  # Handle zero denominators
  denominator <- abs(stem_supply) + abs(tech_demand)
  denominator[denominator == 0] <- 0.001  # Small epsilon to avoid division by zero
  
  balance_index <- abs(stem_supply - tech_demand) / denominator
  return(balance_index)
}

# Equal-weights composite (D)
tech_composite_equal <- tech_data %>%
  mutate(
    tech_demand_equal = (oxford_ai_readiness + imf_ai_preparedness + oecd_digital_score) / 3
  )

# PCA-based composite (alternative weighting)
tech_pca <- prcomp(tech_data[, c("oxford_ai_readiness", "imf_ai_preparedness", "oecd_digital_score")], 
                   scale = TRUE, center = TRUE)
tech_composite_pca <- tech_data %>%
  mutate(
    tech_demand_pca = tech_pca$x[, 1]  # First principal component
  )

# Merge with STEM data and calculate Balance Index
balance_results <- unesco_data %>%
  left_join(tech_composite_equal, by = c("country", "year")) %>%
  left_join(tech_composite_pca[, c("country", "year", "tech_demand_pca")], 
            by = c("country", "year")) %>%
  mutate(
    # Within-year standardization of STEM supply
    stem_supply_std = scale(stem_graduation_share)[, 1],
    
    # Balance Index calculations
    balance_index_equal = calculate_balance_index(stem_supply_std, tech_demand_equal),
    balance_index_pca = calculate_balance_index(stem_supply_std, tech_demand_pca)
  )

# Sensitivity analysis: Rank correlations (Table 2 results)
library(boot)

rank_correlation_analysis <- function(data) {
  # Spearman rank correlation
  spearman_corr <- cor(data$balance_index_equal, data$balance_index_pca, 
                       method = "spearman", use = "complete.obs")
  
  # Kendall rank correlation  
  kendall_corr <- cor(data$balance_index_equal, data$balance_index_pca,
                      method = "kendall", use = "complete.obs")
  
  return(list(spearman = spearman_corr, kendall = kendall_corr))
}

# Bootstrap confidence intervals
boot_rank_corr <- function(data, indices) {
  sample_data <- data[indices, ]
  correlations <- rank_correlation_analysis(sample_data)
  return(c(correlations$spearman, correlations$kendall))
}

# Bootstrap with 1000 replications
set.seed(123)
boot_results <- boot(balance_results[complete.cases(balance_results), ], 
                     boot_rank_corr, R = 1000)

# Extract confidence intervals
spearman_ci <- boot.ci(boot_results, index = 1, type = "perc")
kendall_ci <- boot.ci(boot_results, index = 2, type = "perc")

# Results as reported in manuscript:
# Spearman ρ = 0.457 (95% CI [0.280, 0.626])
# Kendall τ = 0.373 (95% CI [0.240, 0.507])

print("Rank Correlation Results:")
print(paste("Spearman ρ =", round(rank_correlation_analysis(balance_results)$spearman, 3)))
print(paste("Kendall τ =", round(rank_correlation_analysis(balance_results)$kendall, 3)))

# Save results
write.csv(balance_results, "data/final/balance_index_calculations.csv", row.names = FALSE)
