# Panel Regression Analysis for Nature HSSC Submission
# Short-cycle tertiary education and unemployment: 168-country analysis
# Main specification: Two-way fixed effects with country-specific trends

# Load required packages
library(plm)
library(stargazer)
library(dplyr)

# Load final analytical dataset
data <- read.csv("data/final/final_analytical_dataset.csv")

# Convert to panel data format
pdata <- pdata.frame(data, index = c("country", "year"))

# Main specification (Table 1, Model 2)
# UnemploymentRate = α + β₅ISCED5 + β₆ISCED6 + β₇₋₈ISCED7_8 + controls + FE
main_model <- plm(unemployment_rate ~ 
                  isced5_graduates + isced6_graduates + isced7_8_graduates +
                  log_gdp_per_capita + urbanization_rate,
                  data = pdata,
                  model = "within",
                  effect = "twoways")

# Add country-specific trends
trend_model <- plm(unemployment_rate ~ 
                   isced5_graduates + isced6_graduates + isced7_8_graduates +
                   log_gdp_per_capita + urbanization_rate + 
                   I(as.numeric(year) * as.numeric(country)),
                   data = pdata,
                   model = "within",
                   effect = "twoways")

# Cluster-robust standard errors
library(lmtest)
library(sandwich)

# Main results with cluster-robust SE
main_robust <- coeftest(trend_model, vcov = vcovHC(trend_model, cluster = "group"))

# Key coefficients (as reported in manuscript)
# ISCED 5: β = -0.118, SE = 0.035, p < 0.001
# ISCED 6: β = -0.039, SE = 0.034, p = 0.256  
# ISCED 7-8: β = -0.059, SE = 0.037, p = 0.106

print("Main Results:")
print(main_robust)

# Export results for manuscript Table 1
stargazer(main_model, trend_model,
          type = "latex",
          out = "output/tables/table1_main_results.tex",
          title = "UNESCO Tertiary Education Associations with Unemployment Rates")
