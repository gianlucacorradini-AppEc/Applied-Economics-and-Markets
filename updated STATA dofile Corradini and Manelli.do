*================================

* Stata/SE 18.0

*================================

* Housekeeping

clear all
capture log close
log close _all
set more off
ssc instal prodest

*================================

use "IET_TH_2025.dta", clear

*================================

* Problem 1/A

*================================

*Descriptive statistics 

*data clearing for specific focus: french firm in FR30

keep if nuts2 == "FR30"

* Descriptive statistics for L variable 

summarize L if sector == 13 & year == 2007
summarize L if sector == 13 & year == 2017
summarize L if sector == 29 & year == 2007
summarize L if sector == 29 & year == 2017

* Descriptive statistics for real_VA variable 

summarize real_VA if sector == 13 & year == 2007
summarize real_VA if sector == 13 & year == 2017
summarize real_VA if sector == 29 & year == 2007
summarize real_VA if sector == 29 & year == 2017

* Count of firms

count if sector == 13 & year == 2007
count if sector == 29 & year == 2007
count if sector == 13 & year == 2017
count if sector == 29 & year == 2017


*================================

* Problem 1/B

*================================

* % decline for sector NACE 13

di= ((142-87)/142)*100

* % decline for sector NACE 29

di= ((60-49)/60)*100

use "IET_TH_2025.dta", clear

*================================


* Problem 2/A

*================================

* OLS coefficients

gen ln_realVA = ln(real_VA)
gen ln_L = ln(L)
gen ln_realK = ln(real_K)
gen ln_realM = ln(real_M)

sort sector
encode country, gen(country_id)

reg ln_realVA ln_L ln_realK i.country_id i.year if sector == 13
reg ln_realVA ln_L ln_realK i.country_id i.year if sector == 29

*================================

* WRDG coefficients

tabulate year, generate (y_)
tabulate country, generate (c_)

prodest ln_realVA if sector == 13, method(wrdg) free(ln_L) proxy(ln_realM) state(ln_realK) control(y_* c_*) valueadded

prodest ln_realVA if sector == 29, method(wrdg) free(ln_L) proxy(ln_realM) state(ln_realK) control(y_* c_*) valueadded

*================================

* LP coefficients
* via prodest, to include FE

prodest ln_realVA if sector == 13, method(lp) free(ln_L) proxy(ln_realM) state(ln_realK) control(y_* c_*) valueadded

scalar beta_L_13 = _b[ln_L]

prodest ln_realVA if sector == 29, method(lp) free(ln_L) proxy(ln_realM) state(ln_realK) control(y_* c_*) valueadded

scalar beta_L_29 = _b[ln_L]

*================================


* Problem 4/A

*================================

* TFP for sector 13
predict ln_TFP_lp_13 if sector == 13, residuals
gen TFP_lp_13 = exp(ln_TFP_lp_13) 

* clean un 1st and 99th percentiles of TFP_lp_13 for each country 
bysort country: egen p1  = pctile(TFP_lp_13), p(1)
bysort country: egen p99 = pctile(TFP_lp_13), p(99)

* mean and median of TFP_lp_13 for each country excluding 1st and 99th percentile 
table country, statistic(mean TFP_lp_13) statistic(median TFP_lp_13), if TFP_lp_13 > p1 & TFP_lp_13 < p99

* TFP in 2006 vs 2015 for NACE 13: mean, skewness for France and Spain
table country year, statistic(count TFP_lp_13) statistic(mean TFP_lp_13) statistic(median TFP_lp_13) statistic(skewness TFP_lp_13), if TFP_lp_13 > p1 & TFP_lp_13 < p99 & (country != "Italy") & (year == 2006 | year == 2015)

* count N
count if sector == 13 & (year == 2006) & (country == "Spain") & TFP_lp_13 > p1 & TFP_lp_13 < p99

count if sector == 13 & (year == 2015) & (country == "Spain") & TFP_lp_13 > p1 & TFP_lp_13 < p99

count if sector == 13 & (year == 2006) & (country == "France") & TFP_lp_13 > p1 & TFP_lp_13 < p99

count if sector == 13 & (year == 2015) & (country == "France") & TFP_lp_13 > p1 & TFP_lp_13 < p99

*================================


* Problem 5/A

*================================

* PCM markup 
gen PCM_index = (sales - W - M) / sales
gen PCM_markup = 1 / (1 - PCM_index)

* mean PCM markup
tabstat PCM_markup if sector == 13, s(mean)
tabstat PCM_markup if sector == 29, s(mean)

* DLW markups
gen alpha_L = W / sales
gen DLW_markup13 = 0.6386161 / alpha_L if sector == 13
gen DLW_markup29 = 0.6465677 / alpha_L if sector == 29

* mean DLW markups, excluding 1st and 99th percentiles
centile DLW_markup13, centile (1 99)
summarize DLW_markup13 if DLW_markup13 > r(c_1) & DLW_markup13 < r(c_2)
centile DLW_markup29, centile (1 99)
summarize DLW_markup29 if DLW_markup29 > r(c_1) & DLW_markup29 < r(c_2)

* Correlation DLW-PCM markups 
corr PCM_markup DLW_markup13 if sector == 13
corr PCM_markup DLW_markup29 if sector == 29

*================================


* PROBLEM 5/B

*================================

* Markups by size class 
table sizeclass if sector == 13, statistic(mean PCM_markup)

