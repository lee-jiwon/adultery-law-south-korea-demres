set more off
capture log close
cls

log using log/03-web-search-trends.log, replace

********************************************************************************
*** Visualize the Google Search Trends
********************************************************************************

import delimited using data/adultery_abolision.csv, clear

fre v1, all
fre v2, all

gen type = "Abolision of adultery law"
gen y = substr(v1, 1,4)
gen m = substr(v1, 6,2)
gen d = substr(v1, 9,2)
destring y, replace
destring m, replace
destring d, replace

tab y, m
tab m, m
tab d, m

gen date = mdy(m,d,y) 
format date %d

replace v2 = v2 + 0.2 if v2 == 0

tempfile data1
save `data1', replace

twoway bar v2 date

import delimited using data/adultery_crime.csv, clear
fre v1, all
fre v2, all

gen type = "Adultery"
gen y = substr(v1, 1,4)
gen m = substr(v1, 6,2)
gen d = substr(v1, 9,2)
destring y, replace
destring m, replace
destring d, replace

tab y, m
tab m, m
tab d, m

gen date = mdy(m,d,y) 
format date %d

replace v2 = v2 + 0.2 if v2 == 0

tempfile data2
save `data2', replace

import delimited using data/adultery_law.csv, clear
fre v1, all
fre v2, all

gen type = "Adultery law"
gen y = substr(v1, 1,4)
gen m = substr(v1, 6,2)
gen d = substr(v1, 9,2)
destring y, replace
destring m, replace
destring d, replace

tab y, m
tab m, m
tab d, m

gen date = mdy(m,d,y) 
format date %d

replace v2 = v2 + 0.2 if v2 == 0

append using `data1'
append using `data2'

set scheme white_ptol

twoway (line v2 date if type == "Abolision of adultery law") || ///
 (line  v2 date if type == "Adultery law", lcolor(midgreen)) || ///
 (line  v2 date if type == "Adultery", lcolor(dkorange)) || ///
 (pcarrowi 100 20220 100 20145 (3) "Court Decision Announced", msize(2) barbsize(2)  color(black) mlabsize(small), legend(off) ), legend(ring(0) position(11) ///
 order(1 "Abolision of adultery law" ///
                    2 "Adultery law" ///
                    3 "Adultery"))  graphregion(margin(large)) ///
 ytitle("Web Search Frequency") 
  
//  tline(30Jun2014 29sep2014, lcolor(black%70) lwidth(medium) lpattern(solid) ) 


 gr save output/web-search-trends.gph, replace
graph export output/web-search-trends.png,   replace 
graph export output/web-search-trends.pdf,   replace 

log close
