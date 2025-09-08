# Education Level Employment Effects: A 168-Country Panel Analysis (2000–2023)

**Replication package for Nature Humanities & Social Sciences Communications submission**


## Overview

This repository contains the complete replication package for "Short-cycle tertiary education and unemployment: a 168-country panel analysis, 2000–2023", a systematic analysis of tertiary education-labour market associations using UNESCO's ISCED framework.

## Key Findings

- Short-cycle tertiary programmes (ISCED 5) show consistently stronger negative associations with unemployment (β=-0.118, 95% CI [-0.187, -0.049], p<0.001)
- Bachelor's degrees (ISCED 6): β=-0.039 (p=0.256)  
- Advanced degrees (ISCED 7-8): β=-0.059 (p=0.106)
- Patterns robust across 168 countries and multiple specifications

## Data Sources

This study integrates data from seven international organizations:
- UNESCO Institute for Statistics (UIS)
- OECD Statistics
- World Bank (WDI)
- International Labour Organization (ILO)
- International Telecommunication Union (ITU)
- Oxford Insights (AI Readiness Index)
- International Monetary Fund (IMF AI Preparedness)

## Repository Structure

```
├── data/
│   ├── raw/           # Original downloads from 7 agencies
│   ├── processed/     # Harmonized analytical datasets  
│   └── final/         # Final datasets for analysis
├── code/              # R scripts for complete replication
├── output/            # Generated tables and figures
├── docs/              # Documentation and codebooks
└── manuscript/        # Submission materials
```

## Quick Start

1. **Install dependencies:**
```r
source("code/utils/packages.R")
```

2. **Run complete replication:**
```r
source("code/01-data-collection.R")
source("code/02-data-harmonization.R")
source("code/03-balance-index.R")
source("code/04-panel-regression.R")
source("code/05-structural-breaks.R")
source("code/06-robustness-checks.R")
source("code/07-figures-tables.R")
```

**Estimated computation time:** ~45 minutes on standard hardware

## System Requirements

- R ≥ 4.3.0
- Required packages: plm, bcp, ggplot2, dplyr, stargazer
- Python ≥ 3.9 (for data processing)

## Main Results

### Table 1: Main Panel Regression Results
| Education Level | Coefficient | Std. Error | p-value | Observations |
|-----------------|-------------|------------|---------|--------------|
| ISCED 5 (Short-cycle) | -0.118*** | 0.035 | <0.001 | 2,180 |
| ISCED 6 (Bachelor's) | -0.039 | 0.034 | 0.256 | 2,180 |
| ISCED 7-8 (Advanced) | -0.059 | 0.037 | 0.106 | 2,180 |

### Balance Index Sensitivity
- Spearman rank correlation: ρ = 0.457
- Kendall rank correlation: τ = 0.373
- Substantial methodological sensitivity limits country ranking utility

## Files

### Core Analysis Scripts
- `01-data-collection.R`: Download and organize data from 7 agencies
- `02-data-harmonization.R`: Integrate multi-source datasets
- `03-balance-index.R`: Calculate education-technology alignment metric
- `04-panel-regression.R`: Main fixed-effects models
- `05-structural-breaks.R`: Bai-Perron sequential testing
- `06-robustness-checks.R`: Alternative specifications and diagnostics
- `07-figures-tables.R`: Generate publication-ready outputs

### Key Datasets
- `final_analytical_dataset.csv`: Complete harmonized dataset (168 countries, 2000-2023)
- `balance_index_calculations.csv`: BI results with sensitivity analysis
- `structural_break_analysis.csv`: Change-point detection results

## Citation

If you use this replication package, please cite:

```
Kim, S. (2025). Short-cycle tertiary education and unemployment: a 168-country panel analysis, 2000–2023. 
Humanities & Social Sciences Communications. [Under review]
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

- **Author:** Seung Jin Kim
- **GitHub:** @SeungJinKim967
- **Email:** [Contact via GitHub Issues]

## Acknowledgments

This research uses publicly available data from UNESCO, OECD, World Bank, ILO, ITU, Oxford Insights, and IMF. All computational analysis conducted using open-source software.

---

**Status:** Manuscript submitted to Nature Humanities & Social Sciences Communications  
**Last Updated:** September 2025
