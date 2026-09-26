# Did the Reddito di Cittadinanza Discourage Labour-Market Participation?
### Regional evidence from an INPS–ISTAT panel (2019–2023) and the 2023 eligibility tightening

## Project Overview
This repository contains the empirical econometric research conducted for the **Python for Economists** course, AY 2025/2026 (Group20 Python code Rdc). The project investigates whether Italy's guaranteed minimum income scheme (*Reddito di Cittadinanza* – RdC) reduced regional labour-market participation between 2019 and 2023, exploiting the policy's tightening under Law 197/2022 as an empirical quasi-experiment.

## Data Sources & Pipeline
The analysis is based on a balanced panel of **20 Italian regions observed over 18 quarters** (360 observations):
- **ISTAT SDMX API:** Quarterly regional labour force survey micro/macro statistics (activity rate 15–64).
- **INPS Statistical Observatories:** Microdata and administrative appendices on recipient households and average transfer amounts.
- **Data Pipeline:** Automated download, ingestion, data cleaning, seasonal adjustment (moving-average decomposition), and validation against official published benchmarks.

## Econometric Methodology
1. **Descriptive & Two-Way Fixed-Effects (TWFE):**
   - Estimation of the conditional participation gradient using `linearmodels.PanelOLS` with region and quarter fixed effects.
   - Standard errors clustered at the regional level, complemented by a **wild cluster bootstrap** (Rademacher weights, null imposed) to handle small cluster count (G = 20).
2. **Quasi-Experimental Design (Event Study & DiD):**
   - Evaluation of the **August 2023 7-month eligibility cap** for employable beneficiaries.
   - Continuous regional policy dose definition based on benefit contraction ($Q_2 \rightarrow Q_4$ 2023).
   - Event study with dynamic quarterly leads and lags to test parallel pre-trends, accompanied by placebo tests (2022-Q3).

## Tech Stack & Dependencies
- **Language:** Python
- **Key Libraries:** `pandas`, `numpy`, `statsmodels`, `linearmodels`, `matplotlib`

## Authors & Contributions
- **Team (Group 20):** Marco Orlandi, Gianluca Corradini, Riccardo Bonzagni, Federico Bernardi.
- **Individual Contribution:** 
  - Implementation of data ingestion pipelines and harmonization across ISTAT/INPS datasets.
  - Development and validation of econometric panel models (`PanelOLS`, TWFE, event study specification).
  - Visualization of the policy life cycle and regional distributional impacts.
