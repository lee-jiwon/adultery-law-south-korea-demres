# adultery-law-south-korea-demres

## Overview

#### This repository provides replication materials for:

* Lee, Jiwon and Yool Choi. 2024. ”Decriminalization of Adultery Likely Changed Women’s Views on Divorce Following Spousal Infidelity in South Korea.” *Demographic Research*.

## Road map of code 

The content below is copied from the file, roadmap-for-lee-and-choi-DemRes-2024.txt, which can be found in the `docs` folder of the repository.

### Notes

### 1. Working Directory Setup
The working directory in Stata should be set to the top directory (i.e., the one that includes the folders: `code`, `data`, `docs`, `output`, `log`).  If using as a GitHub repository, and when stored locally in a folder "GitHub," the working directory would be set as the main repository folder for the project:

    `GitHub/adultery-law-south-korea-demres`

preceded, as necessary, by any machine-specific location information that indicates where the GitHub folder is located.


### 2. Data Requirements
This study employs person-level data from Waves 1–5 of the Korean Longitudinal Survey of Women and Families (KLoWF), as well as data from Google Trends. All required data can be downloaded from the authors' [Dropbox](https://www.dropbox.com/scl/fo/ys78iii2eo952ab7bx9dq/h?dl=0&rlkey=cs33pcs5btwses89loy8rp9rm) and should be placed into the /data folder before executing any do-files. 

(**Important Note:** The KLoWF dataset can also be obtained directly from the [KLoWF Portal](https://gsis.kwdi.re.kr/klowf/portal/eng/dataSet/), which now includes an English version with English variable labels (not available at the time this research was conducted). The latest version of KLoWF, as of November 27, 2024, includes significant updates to variable names (and possibly minor changes to the variables themselves), which will require manual adjustments to the code for alignment. The changes to the variables, if any, may affect the ability to fully replicate the findings. To ensure exact replication, it is recommended to use the specific version of the dataset utilized in the study, available via the Dropbox link above)

### 3. Running the Scripts
It is recommended that the scripts be run in order and can be run with the script:

	do-all-to-replicate-lee-choi-2024-demres



### Roadmap for the Code

1. **Data Preparation**

- **Script:** `code/01-data-prep.do`
- **Purpose:** Prepares the data for analysis.
- **Inputs:**
  - `data/klowf01p.dta` (KLoWF micro-level data Wave 1)
  - `data/klowf02p.dta` (KLoWF micro-level data Wave 2)
  - `data/klowf03p.dta` (KLoWF micro-level data Wave 3)
  - `data/klowf04p.dta` (KLoWF micro-level data Wave 4)
  - `data/klowf05p.dta` (KLoWF micro-level data Wave 5)
- **Calls:**
  - `code/remove-labels.do` (Removes variable/value labels; comment out if you need the labels)
- **Output:**
  - `data/data_w1_w5_recoded.dta`

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

---




