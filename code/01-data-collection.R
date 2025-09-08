# Data Collection Script for Nature HSSC Submission
# Downloads and organizes data from 7 international organizations

# Required packages for data download and processing
required_packages <- c("readr", "dplyr", "httr", "jsonlite", "WDI", "OECD")

# Install missing packages
install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}

sapply(required_packages, install_if_missing)

# Create directory structure
dir.create("data/raw/unesco", recursive = TRUE, showWarnings = FALSE)
dir.create("data/raw/oecd", recursive = TRUE, showWarnings = FALSE)
dir.create("data/raw/worldbank", recursive = TRUE, showWarnings = FALSE)
dir.create("data/raw/ilo", recursive = TRUE, showWarnings = FALSE)
dir.create("data/raw/itu", recursive = TRUE, showWarnings = FALSE)
dir.create("data/raw/oxford_insights", recursive = TRUE, showWarnings = FALSE)
dir.create("data/raw/imf", recursive = TRUE, showWarnings = FALSE)

print("=== UNESCO UIS Data Collection ===")
# UNESCO data collection instructions
# Manual download required from: https://databrowser.uis.unesco.org/
# Search for: "Percentage of graduates by field of education (tertiary education)"
# Years: 2000-2023, All countries
# Save as: data/raw/unesco/tertiary_education_graduates.csv

print("UNESCO data requires manual download from:")
print("https://databrowser.uis.unesco.org/")
print("Please download tertiary education statistics and save to data/raw/unesco/")

print("=== World Bank WDI Data Collection ===")
# World Bank data - can be automated
wb_indicators <- c(
  "NY.GDP.PCAP.CD",      # GDP per capita
  "SP.URB.TOTL.IN.ZS",   # Urban population %
  "SL.UEM.TOTL.ZS",      # Unemployment rate
  "SP.POP.TOTL"          # Total population
)

wb_data <- WDI(indicator = wb_indicators, 
               start = 2000, end = 2023, 
               extra = TRUE)

write.csv(wb_data, "data/raw/worldbank/world_development_indicators.csv", 
          row.names = FALSE)
print("✓ World Bank data downloaded")

print("=== Other Data Sources ===")
print("The following require manual download:")
print("• OECD: https://stats.oecd.org/ (Education at a Glance)")
print("• ILO: https://ilostat.ilo.org/ (Unemployment statistics)")
print("• ITU: https://www.itu.int/ (ICT indicators)")
print("• Oxford Insights: https://www.oxfordinsights.com/ (AI Readiness Index 2024)")
print("• IMF: https://www.imf.org/ (AI Preparedness Index)")

print("=== Data Collection Complete ===")
print("Next step: Run 02-data-harmonization.R")
