# Structural Break Analysis for Nature HSSC Submission
# Bai-Perron sequential testing for education-employment relationships

library(strucchange)
library(plm)
library(dplyr)

# Load final dataset
data <- read.csv("data/final/final_analytical_dataset.csv")

# Convert to panel data
pdata <- pdata.frame(data, index = c("country", "year"))

# Bai-Perron sequential testing with trimming (15% minimum segment)
# Test for structural breaks in ISCED 5 relationship

# Prepare time series for break testing
time_series_data <- data %>%
  group_by(year) %>%
  summarise(
    mean_unemployment = mean(unemployment_rate, na.rm = TRUE),
    mean_isced5 = mean(isced5_graduates, na.rm = TRUE),
    mean_isced6 = mean(isced6_graduates, na.rm = TRUE),
    mean_isced7_8 = mean(isced7_8_graduates, na.rm = TRUE),
    .groups = 'drop'
  ) %>%
  arrange(year)

# Time series regression for break testing
ts_model <- lm(mean_unemployment ~ mean_isced5 + mean_isced6 + mean_isced7_8, 
               data = time_series_data)

# Bai-Perron test (maximum 5 breaks, 15% trimming)
bp_test <- breakpoints(ts_model, h = 0.15, breaks = 5)

# Extract break dates
break_dates <- time_series_data$year[bp_test$breakpoints]

# Results as reported in manuscript:
# "Primary change-point around 2013 (90% CI in SI)"
print("Structural Break Analysis Results:")
print(paste("Detected break point:", break_dates[1]))

# Pre/post 2013 analysis for ISCED coefficients
pre_2013 <- data[data$year <= 2013, ]
post_2013 <- data[data$year > 2013, ]

# Panel models for each period
pre_model <- plm(unemployment_rate ~ 
                 isced5_graduates + isced6_graduates + isced7_8_graduates +
                 log_gdp_per_capita + urbanization_rate,
                 data = pdata.frame(pre_2013, index = c("country", "year")),
                 model = "within", effect = "twoways")

post_model <- plm(unemployment_rate ~ 
                  isced5_graduates + isced6_graduates + isced7_8_graduates +
                  log_gdp_per_capita + urbanization_rate,
                  data = pdata.frame(post_2013, index = c("country", "year")),
                  model = "within", effect = "twoways")

# Coefficient comparison (as reported in manuscript)
pre_isced5 <- coef(pre_model)["isced5_graduates"]
post_isced5 <- coef(post_model)["isced5_graduates"]

print("ISCED 5 Coefficient Changes:")
print(paste("Pre-2013:", round(pre_isced5, 3)))
print(paste("Post-2013:", round(post_isced5, 3)))
print(paste("Change:", round(post_isced5 - pre_isced5, 3), 
            paste0("(", round(((post_isced5 - pre_isced5)/abs(pre_isced5))*100, 0), "% increase)")))

# Save structural break results
break_results <- data.frame(
  break_year = break_dates[1],
  pre_2013_isced5 = pre
