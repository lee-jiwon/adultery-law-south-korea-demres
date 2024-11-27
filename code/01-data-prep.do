set more off
capture log close
cls

log using log/01_data-prep.log, replace

******************************************************************************
*** Process Waves 1 to W4
*****************************************************************************
tempfile w1 w2 w3 w4 


*** W1 *************************************************************************
use data/klowf01p.dta, clear

do code/remove-labels.do // (comment out if you want the variable/value labels)

* keep only the initally sampled respondents 
keep if roundf == 1

* indicator variables for survey waves
gen W = 1
gen w1 = 1

* recode missing outcome
recode P127AM04 -9=., gen(y)
clonevar y1 = y

*** recode background variables
egen age_1 = cut(P199AG), at(0 40 50 70) // age
tab age_1 P199AG, m 
recode PP102ED01 -8 = . -9=. 1/4 = 1 5/8 = 2 , gen(educ_1) // education
gen marital_1 = (P104ML01 == 1) if !missing(P104ML01) // marital status
clonevar marital_d_1 = PP107ML02 // marital status - detailed
replace marital_d_1 = . if marital_d_1 < 0
gen employed_1 = (WW101EA02 == 1 ) if !missing(WW101EA02) // employment status
recode P128RG01 .=0 1=0 2=3 3=3 4=1 5=2   6=0 -8 = . -9 = ., gen(relig_1) // religion
tab P128RG01 relig_1, m
recode P1011505  -8 = . -9=. 1/4 = 1 5/8 = 2  , gen(educ_f_1) // parent education
recode P1011506 -8 = . -9=. 1/4 = 1 5/8 = 2   , gen(educ_m_1)
recode PP101SN03 -8 = . -9=., gen(sibnum_1) // number of siblings
recode P115PG01 1=1 2=0, gen(cbirth_1) // fertility experience
recode P1011501 -9 = 3 4=1, gen(reg15_1) //

* save as a tempfile
save `w1', replace


*** W2 *************************************************************************
use data/klowf02p.dta, clear

do code/remove-labels.do // (comment out if you want the variable/value labels)


* keep only the inital sampled respondents
keep if  roundf == 1
keep if P299ONE == 1

* indicator variables for survey waves
gen W = 2
gen w2= 1

* recode missing outcome
recode P227AM04 -9=., gen(y)
clonevar y2 = y

*** recode background variables
egen age_2 = cut(P299AG), at(0 40 50 70) // age
tab age_2 P299AG, m 
recode PP202ED01 -8 = . -9=. 1/4 = 1 5/8 = 2 , gen(educ_2) // education
gen marital_2 = (P204ML01 == 1) if !missing(P204ML01) // marital status
clonevar marital_d_2 = PP207ML02 // marital status - detailed
gen employed_2 = (WW201EA02 == 1 ) if !missing(WW201EA02) // employment status
recode P228RG01 .=0 1=0 2=3 3=3 4=1 5=2   6=0 -8 = . -9 = ., gen(relig_2) // religion
tab P228RG01 relig_2, m
recode PP201SN03 -8 = . -9=., gen(sibnum_2) // number of siblings
recode P215PG01 1=1 2=0, gen(cbirth_2) // fertility experience

* save as a tempfile
save `w2', replace

*** W3 *************************************************************************
use data/klowf03p.dta, clear

do code/remove-labels.do // (comment out if you want the variable/value labels)


* keep only the inital sampled respondents
keep if  roundf == 1
keep if P399ONE == 1

* indicator variables for survey waves
gen W = 3
gen w3= 1

* recode missing outcome
recode P327FV14 -9=. , gen(y)
clonevar y3 = y

*** recode background variables
egen age_3 = cut(P399AG), at(0 40 50 70) // age
tab age_3 P399AG, m 
recode PP302ED01 -8 = . -9=. 1/4 = 1 5/8 = 2 , gen(educ_3) // education
gen marital_3 = (P304ML01 == 1) if !missing(P304ML01) // marital status
clonevar marital_d_3 = PP307ML02B // marital status - detailed
gen employed_3 = (WW301EA02 == 1 ) if !missing(WW301EA02) // employment status
recode P328RG01 1=0 2=3 3=3 4=1 5=2   6=0 7= 0 -8 = . -9 = ., gen(relig_3) // religion
tab P328RG01 relig_3, m
recode P324SN03 -8 = . -9=., gen(sibnum_3) // number of siblings
recode P315PG01 1=1 2=0, gen(cbirth_3) // fertility experience

* save as a tempfile
save `w3', replace


*** W4 *************************************************************************
use data/klowf04p.dta, clear

do code/remove-labels.do // (comment out if you want the variable/value labels)

* keep only the inital sampled respondents
keep if  roundf == 1
keep if P499ONE == 1

* indicator variables for survey waves
gen W = 4
gen w4= 1

* recode missing outcome
recode P427FV14 -8=. -9=. , gen(y)
clonevar y4 = y

*** recode background variables
egen age_4 = cut(P499AG), at(0 40 50 70) // age
tab age_4 P499AG, m 
recode PP402ED01 -8 = . -9=. 1/4 = 1 5/8 = 2 , gen(educ_4) // education
recode PP407ML02B 1=0 2/5=1, gen(marital_4) // marital status
clonevar marital_d_4 = PP407ML02B // marital status - detailed
gen employed_4 = ( WW401EA02 == 1 ) if !missing( WW401EA02) // employment status
recode P428RG01 1=0 2=3 3=3 4=1 5=2   6=0 7= 0 -8 = . -9 = ., gen(relig_4) // religion
tab P428RG01 relig_4, m
recode P424SN03 -8 = . -9=., gen(sibnum_4) // number of siblings
recode P415PG01 1=1 2=0, gen(cbirth_4) // fertility experience
gen health_4 = 6- P428HE03

* save as a tempfile
save `w4', replace


*** W5 *************************************************************************
use data/klowf05p.dta, clear

do code/remove-labels.do // (comment out if you want the variable/value labels)

* keep only the inital sampled respondents
keep if  roundf == 1
keep if P599ONE == 1


* indicator variables for survey waves
gen W = 5
gen w5 = 1

* recode missing outcome
recode P527FV14 -9=.,gen(y)
clonevar y5 = y

*** convert interview dates into days since Jan 1 
tab P05D_DAY, m
gen int_y = substr(P05D_DAY, 1,4)
gen int_m = substr(P05D_DAY, 6,2)
gen int_d = substr(P05D_DAY, 9,2)
destring int_y, replace
destring int_m, replace
destring int_d, replace

tab int_y
tab int_m
tab int_d

gen days =.
replace days =  0 if int_m == 6 & int_y == 2014
replace days =  int_d if int_m == 7 & int_y == 2014
replace days =  int_d + 31 if int_m == 8 & int_y == 2014
replace days =  int_d + 62 if int_m == 9 & int_y == 2014
replace days =  int_d + 92 if int_m == 10 & int_y == 2014
replace days =  int_d + 123 if int_m == 11 & int_y == 2014
replace days =  int_d + 153 if int_m == 12 & int_y == 2014
replace days =  int_d + 184 if int_m == 1 & int_y == 2015
replace days =  int_d + 215 if int_m == 2 & int_y == 2015
replace days =  int_d + 244 if int_m == 3 & int_y == 2015
replace days =  int_d + 275 if int_m == 4 & int_y == 2015
tab days,m

*** treatment indicator
tab days if int_m == 2 & int_d ==26  & int_y == 2015 // treatment date: days == 241
gen treat = (days >= 241) 
tab treat, m


********************************************************************************
*** Append the previous waves
********************************************************************************

append using `w1'
append using `w2'
append using `w3'
append using `w4'

********************************************************************************
*** Outcast the variable values
*******************************************************************************

*** Indicators
bys opid: egen tind = total(treat) // treatment indicator
bys opid: gen waves =_N // total completed waves
bys opid: egen w1_part = total(w1==1)
bys opid: egen w2_part = total(w2==1)
bys opid: egen w3_part = total(w3==1)
bys opid: egen w4_part = total(w4==1)
bys opid: egen w5_part = total(w5==1)
tab waves
bys W: tab waves

gen post = (W == 5) // post treatment period
recode treat .=0, gen(w)
tab w
tab W, gen(f) // dummy for each period

bys opid: egen days_all = total(days)
// bys opid: egen mar = total(marital)
// tab mar if W == 1
// recode mar 0=0 1/5=1
bys opid: egen weight = mean(P05wei_L)
// bys opid: egen educ_total = mean(educ)
bys opid: egen d = total(treat) // eventually treated


*** Stableized Weights
egen wt_sum = sum(P05wei_L)
gen wt_rs = weight / wt_sum

bys opid: egen num_y = count(y) // number of waves with valid y

*** Reverse code the outcome variables
replace y = 5 - y if !missing(y)
replace y1  = 5- y1 if !missing(y1)
replace y2  = 5- y2 if !missing(y2)
replace y3  = 5- y3 if !missing(y3)
replace y4  = 5- y4 if !missing(y4)
replace y5  = 5- y5 if !missing(y5)

*** Covariates
/* Note: All covariates drawn from wave 4, except place of residence at 15  */

foreach var in age_4 educ_4 marital_4 employed_4 relig_4 health_4 reg15_1  {
	bys opid: egen `var'_r = mean(`var')
}

gen covar_miss = ///
	missing(age_4_r, educ_4_r, marital_4_r,employed_4_r, relig_4_r, ///
				health_4_r,  reg15_1_r )

*** misc variables needed for auxiliary analysis
foreach var in marital_1 marital_2 marital_3   {
	bys opid: egen `var'_r = mean(`var')
}

*** misc variables needed for auxiliary analysis
foreach var in marital_d_1 marital_d_2 marital_d_3 marital_d_4   {
	bys opid: egen `var'_r = mean(`var')
}


foreach var in y1 y2 y3 y4 y5   {
	bys opid: egen `var'_r = mean(`var')
}

********************************************************************************
*** Variable and value labels
********************************************************************************

la def AGE 0 "Below 40" 40 "40-49" 50 "50 and Above" 
la def EMPLOYED 1 "Employed" 0 "Unemployed/NIL"
la def MARITAL 0  "Never Married" 1 "Ever Married" 
la def EDUC 1 "HS or Less" 2 "AA/BA/MA/PHD" 
la def  REG15  1 "Metropolitan/Abroad" 2 "Mid-sized" 3 "Rural"
la def  RELIG 0 "None/Other" 1 "Protestant" 2 "Catholic" 3 "Buddhist"
la def YESNO 0 "No" 1 "Yes"

la var age_4_r  "Age groups (w4)"
la var educ_4_r "Eduation (w4)"
la var marital_4_r "Marital status (w4)"
la var relig_4_r "Religion (w4)"
la var employed_4_r "Employement status (w4)"
la var health_4_r "Self-rated Health (w4)"
la var reg15_1 "Metro status at 15 (w4)"

la val age_4_r AGE
la val educ_4_r EDUC
la val marital_4_r MARITAL
la val relig_4_r RELIG
la val employed_4_r EMPLOYED
la val reg15_1 REG15

********************************************************************************
*** Save the data
********************************************************************************
save data/data_w1_w5_recoded.dta, replace

log close