set more off
capture log close
cls

log using log/04-analysis.log, replace

use data/data_w1_w5_recoded.dta, clear

*** select the analytical sample
keep if w4_part ==1 & w5_part == 1 & w3_part == 1 & w2_part ==1 & w1_par== 1
// count if W == 1
keep if num_y == 5 // drop Rs with missing outcome in any wave
// count if W == 1
drop if covar_miss == 1 // drop Rs with missing covariates
// count if W == 1
// count
// tab d if W ==1

********************************************************************************
*** DiD Estimation
********************************************************************************

*** No covariates **************************************************************
* models
reg y w d post if days_all >= 88  [pw= wt_rs], vce(cluster opid) // 5 months
est store months_5
reg y w d post    [pw= wt_rs], vce(cluster opid) // All
est store all
reg y w d post if days_all >= 118  [pw= wt_rs], vce(cluster opid) // 4 months
est store months_4
reg y w d post if days_all >= 149  [pw= wt_rs], vce(cluster opid) // 3 months
est store months_3
reg y w d post if days_all >= 179   [pw= wt_rs], vce(cluster opid) // 2 months
est store months_2
reg y  w d post if days_all >= 210  [pw= wt_rs], vce(cluster opid) // 1 month
est store months_1

*** store the estimates
estout months_5 all months_4 months_3 months_2 months_1 ///
		using output/baseline-model-est.xls,  ///
	cells(b(fmt(a2)) se(par)  p(fmt(a2))) stats(N ) replace  

*** Include covariates **********************************************************

*** Dummies for each level of the covariates
foreach var in age_4_r educ_4_r  employed_4_r relig_4_r reg15_1_r marital_4_r {
	dis ""
	dis "*******************************************************************"
	dis "Distribution of: `var'"  
	dis "*******************************************************************"
	dis ""
	tab `var', gen(`var'_c)
}

* model specificiation
global full_model c.w i.d i.f5 ///
	c.w#c.age_4_r_c2  c.w#c.age_4_r_c3   ///
	c.w#c.educ_4_r_c2  c.w#c.employed_4_r_c2 ///
	c.w#c.relig_4_r_c2 c.w#c.relig_4_r_c3 c.w#c.relig_4_r_c4  ///
	c.w#c.reg15_1_r_c2 c.w#c.reg15_1_r_c3 c.w#c.health_4_r_dm ///
	c.age_4_r_c2 c.age_4_r_c3 c.educ_4_r_c2 c.employed_4_r_c2 ///
	c.relig_4_r_c2 c.relig_4_r_c3 c.relig_4_r_c4  ///
	c.reg15_1_r_c2 c.reg15_1_r_c3 c.health_4_r_dm ///
	i.d#c.age_4_r_c2 i.d#c.age_4_r_c3 i.d#c.educ_4_r_c2  ///
	i.d#c.employed_4_r_c2 ///
	i.d#c.relig_4_r_c2 i.d#c.relig_4_r_c3 i.d#c.relig_4_r_c4  ///
	i.d#c.reg15_1_r_c2 i.d#c.reg15_1_r_c3 i.d#c.health_4_r_dm ///
	i.f5#c.age_4_r_c2 i.f5#c.age_4_r_c3 i.f5#c.educ_4_r_c2 ///
	i.f5#c.employed_4_r_c2 ///
	i.f5#c.relig_4_r_c2 i.f5#c.relig_4_r_c3 i.f5#c.relig_4_r_c4 ///
	i.f5#c.reg15_1_r_c2 i.f5#c.reg15_1_r_c3 i.f5#c.health_4_r_dm

// * model specificiation: model with marital status
// global full_model c.w i.d i.f5 ///
// 	c.w#c.age_4_r_c2  c.w#c.age_4_r_c3   ///
// 	c.w#c.educ_4_r_c2  c.w#c.employed_4_r_c2 ///
// 	c.w#c.relig_4_r_c2 c.w#c.relig_4_r_c3 c.w#c.relig_4_r_c4  ///
// 	c.w#c.marital_4_r_c2 ///
// 	c.w#c.reg15_1_r_c2 c.w#c.reg15_1_r_c3 c.w#c.health_4_r_dm ///
// 	c.age_4_r_c2 c.age_4_r_c3 c.educ_4_r_c2 c.employed_4_r_c2 ///
// 	c.relig_4_r_c2 c.relig_4_r_c3 c.relig_4_r_c4  marital_4_r_c2 ///
// 	c.reg15_1_r_c2 c.reg15_1_r_c3 c.health_4_r_dm ///
// 	i.d#c.age_4_r_c2 i.d#c.age_4_r_c3 i.d#c.educ_4_r_c2  ///
// 	i.d#c.marital_4_r_c2 ///
// 	i.d#c.employed_4_r_c2 ///
// 	i.d#c.relig_4_r_c2 i.d#c.relig_4_r_c3 i.d#c.relig_4_r_c4  ///
// 	i.d#c.reg15_1_r_c2 i.d#c.reg15_1_r_c3 i.d#c.health_4_r_dm ///
// 	i.f5#c.age_4_r_c2 i.f5#c.age_4_r_c3 i.f5#c.educ_4_r_c2 ///
// 	 i.f5#c.employed_4_r_c2 ///
// 	i.f5#c.relig_4_r_c2 i.f5#c.relig_4_r_c3 i.f5#c.relig_4_r_c4 ///
// 	i.f5#c.reg15_1_r_c2 i.f5#c.reg15_1_r_c3 i.f5#c.health_4_r_dm ///
// 	i.f5#c.marital_4_r_c2 

 
*** Estimation
foreach num of numlist 88 0 118 149 179 210 {

*** de-mean for continous variables
foreach var in health_4_r {
	qui sum `var' [aw= wt_rs] if d & days >= `num'
	gen `var'_dm =`var' - r(mean)
}

* Estimate the full model
reg y $full_model [pw= wt_rs]  if days_all >= `num' , vce(cluster opid)

* Estimate ATT
margins, dydx(w) at(f5==1) subpop(if d == 1) vce(uncond) post
	est store cov_model_`num'
drop *_dm
}

* store the estimates
estout ///
cov_model_88 cov_model_0 cov_model_118 cov_model_149 cov_model_179 cov_model_210  ///
		using output/covariate-model-est.xls,  ///
	cells(b(fmt(a2)) se(par)  p(fmt(a2))) stats(N ) replace  

********************************************************************************
*** Visualization
********************************************************************************

*** Trends *********************************************************************
la def treat 0 "Comparison" 1 "Treated"
la val d treat

la def wave 1 "2007-2008" 2 "2008-2009" 3 "2010-2011" 4 "2012-2013" 5 "2014-2015"
la val W wave

// ssc install schemepack, replace // Need to install first

reg y i.d##i.W [pw= wt_rs] if days_all >= 88 , vce(cluster opid)
margins, over(d W)
marginsplot, xdim(W) noci xline(4.5, lcolor(red%40) lwidth(medthick) lpattern(solid)) ///
 title("") xtitle("Survey Year", size(medsmall) margin(l+0 r+0 b+0 t+3)) ///
 ytitle(`""Husband's infidelity should result in divorce""', size(3.3)) ///
 ylabel(1.5(0.5)3, labsize(medsmall)) ///
 legend(ring(0) size(4) pos(7) region(lc(none%0))) ///
 plot1opts(lwidth(medthick) msize(medium)) ///
  plot2opts(lwidth(medthick) msize(medium)) ///
 graphregion(margin(large)) scheme(cblind1 )  xlabel(, labsize(medsmall)) ///
 aspectratio(0.5)   graphregion(margin(large))
 
gr save output/pre-trends-levels.gph, replace
graph export output/pre-trends-levels.png,   replace 
graph export output/pre-trend-levels.pdf,   replace 


log close