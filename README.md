# adultery-law-south-korea-demres

## Overview

#### This repository provides replication materials for:

* Lee, Jiwon and Yool Choi. 2024. ”Decriminalization of Adultery Likely Changed Women’s Views on Divorce Following Spousal Infidelity in South Korea.” Demographic Research.

## Road map of code 

The content below is copied from the file, roadmap-for-lee-and-choi-DemRes-2024.txt, which can be found in the docs folder of the repository.

### Notes

# 1.  Working Directory Setup
The working directory in Stata should be set to the top directory (i.e., the one that includes the folders: code, data, docs, output, log).  If using as a GitHub repository, and when stored locally in a folder "GitHub," the working directory would be set as the main repository folder for the project:

    GitHub/adultery-law-south-korea-demres

preceded, as necessary, by any machine-specific location information that indicates where the GitHub folder is located.


# 2. Data requirements  
This study employs person-level data from Waves 1–5 of the Korean Longitudinal Survey of Women and Families (KLoWF), as well as data from Google Trends. All required data can be downloaded from the authors' [Dropbox](https://www.dropbox.com/scl/fo/ys78iii2eo952ab7bx9dq/h?dl=0&rlkey=cs33pcs5btwses89loy8rp9rm) and should be placed into the /data folder before executing any do-files. 

(Important Note: The KLoWF dataset can also be obtained directly from the KLoWF Portal (https://gsis.kwdi.re.kr/klowf/portal/eng/dataSet/), which now includes an English version with English variable labels (as of November 27, 2024). The latest version of KLoWF, as of November 27, 2024, includes significant updates to variable names (and possibly minor changes to the variables themselves), which will require manual adjustments to the code for alignment. The changes to the variables, if any, may affect the ability to fully replicate the findings. To ensure exact replication, it is recommended to use the specific version of the dataset utilized in the study, available via the Dropbox link above)

# 3. Running the Scripts
It is recommended that the scripts be run in order and can be run with the script:

	do-all-to-replicate-lee-choi-2024-demres



### Roadmap for the code

1.	code/01-data-prep.do, log

Data preparation

	Inputs:
		data/klowf01p.dta (KLOWF micro-level data Wave 1)
		data/klowf02p.dta (KLOWF micro-level data Wave 2)
		data/klowf03p.dta (KLOWF micro-level data Wave 3)
		data/klowf04p.dta (KLOWF micro-level data Wave 4)
		data/klowf05p.dta (KLOWF micro-level data Wave 5)

	Calls:
		code/remove-labels.do (removes variable/value labels; comment out if you need the labels)

	Output: 
		data/data_w1_w5_recoded.dta


2.	code/02-descriptives.do, log

Produces descriptive statistics (e.g., sample means of key variables) and visualizes the distribution of interview dates.


	Input:
		data/data_w1_w5_recoded.dta

	Outputs:
		output/descriptive-table.xlsx (Table 1)
		gr save output/interview-dates.gph, png, pdf (Figure 2)


3.	code/03-web-search-trends.do, log

Processes and visualizes Google search trends for terms Adultery, Adultery law, and Abolition of adultery law.

	Inputs:
		data/adultery_abolision.csv (Google search data obtained from Google Tends)
		data/adultery_crime.csv
		data/adultery_law.csv

	Outputs: 
		output/web-search-trends.gph, png, pdf (Figure 1) 


4.	code/04-analysis.do, log

Estimates the main models and generates accompanying graphs.

	Takes in:
		data/data_w1_w5_recoded.dta

	Yields: 
		output/baseline-model-est.xls (Table 2 panel A)
		output/covariate-model-est.xls (Table 2 panel B)
		output/pre-trends-levels.gph, png, pdf (Figure 3)


	Takes in:
		data/gss-1972-and-later-recoded-and-imputed.dta
	Yields:
		docs/descriptives-indep.csv (Table S3)
		docs/descriptives-eqwlth.csv (Table 3 top panel)
		docs/descriptives-taxr.csv (Table 3 bottom panel)
