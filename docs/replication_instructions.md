# Replication Instructions

## Complete replication of "Short-cycle tertiary education and unemployment: a 168-country panel analysis, 2000–2023"

### System Requirements
- R ≥ 4.3.0
- Python ≥ 3.9 (optional, for data processing)
- ~2GB free disk space
- Internet connection for data download

### Step-by-Step Replication

#### 1. Setup Environment
```r
# Install required packages
source("code/requirements.R")
2. Data Collection (Manual + Automated)
# Download available data automatically
source("code/01-data-collection.R")

# Manual downloads required:
# - UNESCO UIS: https://databrowser.uis.unesco.org/
# - OECD: https://stats.oecd.org/
# - ILO: https://ilostat.ilo.org/
# - ITU: https://www.itu.int/
# - Oxford Insights: https://www.oxfordinsights.com/
# - IMF: https://www.imf.org/
3. Data Harmonization
source("code/02-data-harmonization.R")
4. Balance Index Calculation
source("code/03-balance-index.R")
5. Main Panel Regression Analysis
source("code/04-panel-regression.R")
6. Structural Break Analysis
source("code/05-structural-breaks.R")
7. Robustness Checks
source("code/06-robustness-checks.R")
8. Generate Figures and Tables
source("code/07-figures-tables.R")
Expected Outputs
Tables (LaTeX format in output/tables/)

table1_main_results.tex: Main panel regression results
table2_balance_index.tex: Balance Index sensitivity analysis
table3_period_interactions.tex: COVID-19 and technology diffusion periods

Figures (PNG format in output/figures/)

figure1_time_series.png: Graduation rates by income groups
figure2_structural_breaks.png: 2013 structural break analysis
figure3_regional_distributions.png: Balance Index regional patterns

Key Results (as reported in manuscript)

ISCED 5 coefficient: β = -0.118*** (SE = 0.035)
ISCED 6 coefficient: β = -0.039 (SE = 0.034, p = 0.256)
ISCED 7-8 coefficient: β = -0.059 (SE = 0.037, p = 0.106)
Balance Index rank correlation: ρ = 0.457

Troubleshooting
Common Issues:

Missing data files: Ensure all manual downloads are completed
Package installation errors: Update R to latest version
Memory issues: Close other applications, increase R memory limit
Path errors: Check working directory is set to repository root

Data Availability:

All primary sources are publicly available
Generated datasets will be archived on Zenodo upon manuscript acceptance
Contact: via GitHub issues for technical support

Estimated Computation Time

Data collection: 30-60 minutes (depending on download speeds)
Full analysis: ~45 minutes on standard hardware
Figure generation: ~5 minutes

Reproducibility Notes

All analysis uses set.seed() for consistent random number generation
Package versions recorded in requirements.R
Cluster-robust standard errors may vary slightly across R versions
All results should match manuscript within rounding precision
