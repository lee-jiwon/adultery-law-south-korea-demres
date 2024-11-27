set more off
capture log close
cls

log using log/02-descriptives.log, replace

use data/data_w1_w5_recoded.dta, clear

keep if w4_part ==1 & w5_part == 1 & w3_part == 1 & w2_part ==1 & w1_par== 1
keep if num_y == 5 // drop Rs with missing outcome in any wave
drop if covar_miss == 1 // drop Rs with missing covariates

********************************************************************************
*** Descriptive Statistics of the outcome and contionous covariates
********************************************************************************

*** The number of respondents who change marital status during w1-w5
count if W == 4
count if marital_1_r == marital_2_r == marital_3_r == marital_4_r & W == 4
tab marital_4_r [aw= wt_rs] if W ==4 

*** Mean outcome pre/post-treatment by treatment group status
egen y_m = rowmean(y1_r y2_r y3_r y4_r) // create the mean of w1-4 outcomes

* pre-treatment period averages
sum y_m [aw= wt_rs] if days_all >= 88 & post == 0 & W == 4 & d== 1  
scalar  y_pre_t = round(r(mean), 0.01) 
scalar  y_sd_pre_t = round(r(sd), 0.01) 

sum y_m [aw= wt_rs] if days_all >= 88 & post == 0 & W == 4 & d== 0 
scalar y_pre_u = round(r(mean), 0.01) 
scalar y_sd_pre_u = round(r(sd), 0.01) 

reg y_m i.d [pw= wt_rs] if days_all >= 88 & post == 0 & W == 4 // t-test of pre-treatment differences
mat mat = r(table)
scalar y_diff_pre = round(mat[1,2], 0.01)
scalar y_diff_pre_se = round(mat[2,2], 0.01)
scalar y_diff_pre_p = round(mat[4,2], 0.01)

* post-treatment period averages
sum y [aw= wt_rs] if days_all >= 88 & W == 5 & d== 1 // post-treatment averages
scalar  y_post_t = round(r(mean), 0.01)
scalar  y_sd_post_t = round(r(sd), 0.01)

sum y [aw= wt_rs] if days_all >= 88 & W == 5 & d== 0 // post-treatment averages
scalar  y_post_u = round(r(mean), 0.01)
scalar  y_sd_post_u = round(r(sd), 0.01)

reg y i.d [pw= wt_rs] if days_all >= 88 & post == 1 & W == 5 // t-test of post-treatment differences
mat mat = r(table)
scalar y_diff_post = round(mat[1,2], 0.01)
scalar y_diff_post_se = round(mat[2,2], 0.01)
scalar y_diff_post_p = round(mat[4,2], 0.01)

* estimates for self-rated health
sum health_4 if d == 0 & days_all >= 88 & W == 4 [aw= wt_rs]
scalar health_u =  round(r(mean), 0.01)
scalar health_sd_u = round(r(sd), 0.01)

sum health_4 if d == 1 & days_all >= 88 & W == 4 [aw= wt_rs]
scalar health_t =  round(r(mean), 0.01)
scalar health_sd_t = round(r(sd), 0.01)

reg health_4 i.d [pw= wt_rs] if W ==4  & days_all >= 88
mat mat = r(table)
scalar health_diff = round(mat[1,2], 0.01)
scalar health_diff_se = round(mat[2,2], 0.01)
scalar health_diff_p = round(mat[4,2], 0.01)

********************************************************************************
*** Descriptive Statistics of discrete covariates
********************************************************************************

*** Dummies for each level of the covariates
foreach var in age_4_r educ_4_r  employed_4_r relig_4_r reg15_1_r  {
	dis ""
	dis "*******************************************************************"
	dis "Distribution of: `var'"
	dis "*******************************************************************"
	dis ""
	tab `var', gen(`var'_c)
}

* tabulate
estpost tabstat  age_4_r_* educ_4_r_*  employed_4_r_* ///
	relig_4_r_* reg15_1_r_*  ///
	if days_all >= 88 & W == 4 [aw= wt_rs], by(d) c(stat) stat( mean sd n)

ereturn list

esttab, main(mean %8.2fc) aux(sd  %8.2fc) nostar nonumber unstack ///
   nonote noobs label ///
   collabels(none) ///
   eqlabels("Comparison" "Treated") /// 
   nomtitles
   
* store the estimates into a matrix and generate scalars
mat mat_disc = e(mean)

* Define names for the scalars
local varnames "age_c1 age_c2 age_c3 educ_c1 educ_c2 emp_c1 emp_c2 relig_c1 relig_c2 relig_c3 relig_c4 reg15_c1 reg15_c2 reg15_c3"
local suffixes "_u _t"

* Loop over variable names and suffixes
local col = 1
foreach suffix in `suffixes' {
    foreach var in `varnames' {
        scalar `var'`suffix' = round(mat_disc[1, `col'], 0.01)
        local col = `col' + 1
    }
}

*** chi-squared tests
svyset [pweight=wt_rs]

foreach prefix in age educ employed relig reg15 {
    if "`prefix'" == "reg15" {
        svy: tab d `prefix'_1_r if W == 4 & days_all >= 88, row
    }
    else {
        svy: tab d `prefix'_4_r if W == 4 & days_all >= 88, row
    }
    scalar `prefix'_p = round(e(p_Pear), 0.01)
}

* total sample sizes
tab d if d == 0 & W ==4  & days_all >= 88
scalar N_u = r(N)

tab d if d == 1 & W ==4  & days_all >= 88
scalar N_t = r(N)

********************************************************************************
*** Put into excel
********************************************************************************
putexcel set output/descriptive-table.xlsx, replace

* Define headers
putexcel B1 = "Descriptive Statistics by the Treatment Status"
putexcel B2 = "Mean" D2 = "Min/Max" F2 = "p-value"
putexcel B3 = "Untreated Group" C3 = "Treated Group" D3 = "Min" E3 = "Max" F3 = "χ2/t-test"

* Fill in the table
* Outcome Variable
putexcel A4 = "Outcome Variable"
putexcel A5 = "Pre-treatment periods (waves 1-4)" B5 = y_pre_u ///
		 C5 = y_pre_t D5 = 1 E5 = 4 F5 = y_diff_pre_p
putexcel B6 = y_sd_pre_u C6 = y_sd_pre_t 
putexcel A7 = "Post-treatment period (wave 5)" B7 = y_post_u ///
		 C7 = y_post_t D7 = 1 E7 = 4 F7 = y_diff_post_p
putexcel B8 = y_sd_post_u C8 = y_sd_post_t 

* Age
putexcel A9 = "Age"
putexcel A10 = "Below 40" B10 = age_c1_u C10 = age_c1_t D10 = 0 E10 = 1 F10 = age_p
putexcel A11 = "40-49" B11 = age_c2_u C11 = age_c2_t D11 = 0 E11 = 1
putexcel A12 = "50 and above" B12 = age_c3_u C12 = age_c3_t D12 = 0 E12 = 1

* Education
putexcel A13 = "Education"
putexcel A14 = "HS or Less" B14 = educ_c1_u C14 = educ_c1_t D14 = 0 E14 = 1 F14 = educ_p
putexcel A15 = "Some College or above" B15 = educ_c2_u C15 = educ_c2_t D15 = 0 E15 = 1

* Employment Status
putexcel A16 = "Employment Status"
putexcel A17 = "Not in labor force/unemployed" B17 = emp_c1_u C17 = emp_c1_t D17 = 0 E17 = 1 F17 = employed_p 
putexcel A18 = "Employed" B18 = emp_c2_u C18 = emp_c2_t D18 = 0 E18 = 1

* Religion
putexcel A19 = "Religion"
putexcel A20 = "None/other" B20 = relig_c1_u C20 = relig_c1_t D20 = 0 E20 = 1 F20 = relig_p
putexcel A21 = "Protestant" B21 = relig_c2_u C21 = relig_c2_t D21 = 0 E21 = 1
putexcel A22 = "Catholic" B22 = relig_c3_u C22 = relig_c3_t D22 = 0 E22 = 1
putexcel A23 = "Buddhist" B23 = relig_c4_u C23 = relig_c4_t D23 = 0 E23 = 1

* Type of residence at age 15
putexcel A24 = "Type of residence at age 15"
putexcel A25 = "Metropolitan/Abroad" B25 = reg15_c1_u C25 = reg15_c1_t D25 = 0 E25= 1 F25 = reg15_p
putexcel A26 = "Mid-sized city" B26= reg15_c2_u C26 = reg15_c2_t D26 = 0 E26 = 1
putexcel A27 = "Rural" B27 = reg15_c3_u C27 = reg15_c3_t D27 = 0 E27 = 1

* Self-rated health
putexcel A28 = "Self-rated health" B28 = health_u C28 = health_t D28 = 1 E28 = 5 F28 = health_diff_p
putexcel A29 = "" B29 = health_sd_u C29 = health_sd_t

* Number of Individuals
putexcel A30 = "No. of Individuals" B30 = N_u C30 = N_t

********************************************************************************
*** Visualize the resarch design
********************************************************************************
set scheme white_ptol

gen date = mdy(int_m, int_d, int_y)
format date %d
tab date if days_all == 88
tab date if days_all == 241
tab d if days_all >= 88 & days_all < 241 & W == 5
tab d if days_all >= 241  & W == 5

twoway (hist date if days_all <= 88, width(1) freq ///
color(gray%40) lpattern(solid) lwidth(medium)) || ///
(hist date if days_all >= 88 & days_all < 241, width(1) freq ///
color(blue%40) lpattern(solid) lwidth(medium)) ||  ///
(hist date if days_all >= 241 , width(1) freq ///
 color(red%40) lpattern(solid) lwidth(medium)) || ///
 (pcarrowi 140 20130 140 20145 (9) "Court Decision Announced", msize(2) barbsize(2)  color(black) mlabsize(small), legend(off) ) || ///
  (pcarrowi 140 19975 140 19992 (9) "5 Months Prior", msize(2) barbsize(2)  color(black) mlabsize(small), legend(off) ) , ///
graphregion(margin(large)) ylabel(0(30)150) xline(19992 20145, lcolor(black) lpattern(solid) lwidth(medium))  legend(off) ///
ytitle("No. of Respondents", size(medsmall)) xtitle("Interview Date", size(medsmall)) ///
	xlabel(19905 "01jul2014" 19992 "26sep2014" 20145 "26feb2015" 20180 "01apr2015") ///
 text(120 20025 "{bf: Comparison Group }", place(e) size(.33cm)) ///
  text(110 20045 "{bf:(N = 4,675)}", place(e) size(.33cm)) ///
 text(120 20148 "{bf: Treatment}", place(e) size(.33cm)) ///
  text(113 20155 "{bf: Group}", place(e) size(.33cm)) ///
 text(103 20149 "{bf: (N = 406)}", place(e) size(.33cm)) 
 
gr save output/interview-dates.gph, replace
graph export output/interview-dates.png,   replace 
graph export output/interview-dates.pdf,   replace 


log close