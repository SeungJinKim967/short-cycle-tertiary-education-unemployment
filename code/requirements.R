# R Package Requirements for Nature HSSC Replication Package
# Short-cycle tertiary education and unemployment analysis

# Install and load required packages
required_packages <- c(
  # Data manipulation
  "dplyr",
  "tidyr", 
  "readr",
  
  # Panel data analysis
  "plm",
  "lmtest",
  "sandwich",
  
  # Structural break testing
  "strucchange",
  "bcp",
  
  # Data visualization
  "ggplot2",
  "gridExtra",
  "corrplot",
  
  # Statistical analysis
  "boot",
  "stargazer",
  
  # Data download
  "WDI",
  "OECD",
  "httr",
  "jsonlite"
)

# Function to install missing packages
install_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new_packages)) {
    install.packages(new_packages, dependencies = TRUE)
  }
}

# Install missing packages
install_missing(required_packages)

# Load all packages
lapply(required_packages, library, character.only = TRUE)

# Print R session info for reproducibility
print("R Session Info:")
sessionInfo()

# Print package versions
print("Package Versions:")
for(pkg in required_packages) {
  version <- as.character(packageVersion(pkg))
  cat(paste(pkg, ":", version, "\n"))
}

print("All required packages loaded successfully!")
print("Estimated computation time for full replication: ~45 minutes")
