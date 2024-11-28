
### Replication materials for:

	Lee, Jiwon and Yool Choi. 2024. ”Decriminalization of Adultery Likely Changed Women’s Views on Divorce Following Spousal Infidelity in South Korea.” Demographic Research.

The replication materials can also be otained via the authors' Github respository: github.com/lee-jiwon/adultery-law-south-korea-demres

## Notes

### 1. Working Directory Setup
The working directory in Stata should be set to the top directory (i.e., the one that includes the folders: `code`, `data`, `output`, `log`).


### 2. Data Requirements
This study employs person-level data from Waves 1–5 of the Korean Longitudinal Survey of Women and Families (KLoWF), as well as data from Google Trends. All required data are contained in the `data` folder:

  - data/klowf01p.dta (KLoWF individual-level data Waves 1-5)
  - ata/klowf02p.dta 
  - data/klowf03p.dta
  - data/klowf04p.dta 
  - data/klowf05p.dta 

  - data/adultery_abolition.csv (Google search data obtained from Google Trends)
  - data/adultery_crime.csv
  - data/adultery_law.csv


### 3. Running the Scripts
It is recommended that the scripts be run in order and can be run with the script:

	do-all-to-replicate-lee-choi-2024-demres


### Roadmap for the Code

1. **Data Preparation**

- **Script:** `code/01-data-prep.do`
- **Purpose:** Prepares the data for analysis.
- **Inputs:**
  - `data/klowf01p.dta` 
  - `data/klowf02p.dta` 
  - `data/klowf03p.dta` 
  - `data/klowf04p.dta` 
  - `data/klowf05p.dta` 
- **Calls:**
  - `code/remove-labels.do` (Removes variable/value labels; comment out if you need the labels)
- **Output:**
  - `data/data_w1_w5_recoded.dta`

---

2. **Descriptive Analysis**

- **Script:** `code/02-descriptives.do`
- **Purpose:** Produces descriptive statistics (e.g., sample means of key variables) and visualizes the distribution of interview dates.
- **Input:**
  - `data/data_w1_w5_recoded.dta`
- **Outputs:**
  - `output/descriptive-table.xlsx` (Table 1)
  - Graphs saved as:
    - `output/interview-dates.gph`
    - `output/interview-dates.png`
    - `output/interview-dates.pdf` (Figure 2)

---

3. **Google Search Trends Analysis**

- **Script:** `code/03-web-search-trends.do`
- **Purpose:** Processes and visualizes Google search trends for the terms "Adultery," "Adultery law," and "Abolition of adultery law."
- **Inputs:**
  - `data/adultery_abolition.csv` (Google search data obtained from Google Trends)
  - `data/adultery_crime.csv`
  - `data/adultery_law.csv`
- **Outputs:**
  - Graphs saved as:
    - `output/web-search-trends.gph`
    - `output/web-search-trends.png`
    - `output/web-search-trends.pdf` (Figure 1)

---

4. **Main Analysis**

- **Script:** `code/04-analysis.do`
- **Purpose:** Estimates the main models and generates accompanying graphs.
- **Input:**
  - `data/data_w1_w5_recoded.dta`
- **Outputs:**
  - `output/baseline-model-est.xls` (Table 2, Panel A)
  - `output/covariate-model-est.xls` (Table 2, Panel B)
  - Graphs saved as:
    - `output/pre-trends-levels.gph`
    - `output/pre-trends-levels.png`
    - `output/pre-trends-levels.pdf` (Figure 3)



