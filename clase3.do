******************************
**		CURSO DE STATA		**
******************************

******************************
** 		  CLASE 3			**
******************************
//change directory
ls
cd "C:\Users\DELL GAMER\Desktop\clases_stata"

//begin log file
log using Clase3.txt, replace text

*pause / resume logging with "log on" / "log off"



*******************************************************************************
*******************************************************************************
                      *MICROECONOMETRICS - EMPIRICAL PROJECT*
							   
*******************************************************************************
*******************************************************************************



*******************************************************************************
                                 *1. PRELIMINARIES*
*******************************************************************************
*******************************************************************************


clear
set maxvar 20000
set more off
cd "C:\Users\DELL GAMER\Desktop\clases_stata"
glo data "data21"			
glo results "results21"	
cap log close
local date = "`: di %tdCCYY-NN-DD date(c(current_date), "DMY")'"	
log using "$results\psf_`date'.log",append
use "$data\randhrs1992_2014v2"


ssc install estout, replace
ssc install distplot, replace
ssc install ivregress2, replace


*******************************************************************************
                            *2. DESCRIPTIVE STATISTICS *
*******************************************************************************
*******************************************************************************



*Outcome variable: Drinking behavior 
des r12drink
sum r12drink
tab r12drink
codebook r1drink

des r12drinkn
sum r12drinkn
tab r12drinkn
codebook r12drinkn


*Main explanatory variable: Religion
des rarelig
sum rarelig
tab rarelig
codebook rarelig

*Other explanatory variables:
  
*Age 
des r12agey_b
sum r12agey_b
tab r12agey_b
codebook r12agey_b

*Gender

des ragender
sum ragender
tab ragender
codebook ragender

*Race
des raracem
sum raracem
tab raracem
codebook raracem

*Race-Hispanic
des rahispan
sum rahispan
tab rahispan
codebook rahispan


*Education 
des raedyrs
sum raedyrs
tab raedyrs
codebook raedyrs

*Marital Status 
des r12mstat
sum r12mstat
tab r12mstat
codebook r12mstat

*Total Income
des h12itot
sum h12itot
tab h12itot
codebook h12itot

*Mother's education 
des rameduc
sum rameduc
tab rameduc
codebook rameduc


*******************************************************************************
                            *3.TRANSFORMATION OF VARIABLES*
*******************************************************************************
*******************************************************************************


*Outcome variable 1: Consumption of alcohol 
tab r12drink

foreach x in r {
	gen `x'alcon=0 if `x'12drink==0                       
	replace `x'alcon=1 if `x'12drink==1				    
	replace `x'alcon=. if missing(`x'12drink)
	}      
label variable ralcon "Respondent - Consumption of alcohol"	
label define ralconlabel 0 "No" 1 "Yes" 
label values ralcon ralconlabel
tab ralcon	

*Outcome variable 2: Frequency of consumption of alcohol per day  
tab r12drinkn

foreach x in r {
	gen `x'consu=0 if `x'12drinkn==0                      
	replace `x'consu=1 if `x'12drinkn==1				   
	replace `x'consu=2 if `x'12drinkn==2				   
	replace `x'consu=3 if `x'12drinkn>=3				   
	replace `x'consu=. if missing(`x'12drinkn)
	}      
 label variable rconsu "Respondent - Frequency of alcohol consumption per day"	
 label define rconsulabel 0 "Sober" 1 "Occasional Drinker" 2 "Regular drinker" 3 "Drinking Problem" 
label values rconsu rconsulabel
tab rconsu
 
 
*Main Explanatory variable: Religion
tab rarelig 

foreach x in r {
	gen `x'eli=1 if `x'arelig==1
	replace `x'eli=2 if `x'arelig==2
	replace `x'eli=3 if `x'arelig==3
	replace `x'eli=4 if `x'arelig==4
	replace `x'eli=5 if `x'arelig==5
	replace `x'eli=. if missing(`x'arelig)	
	}                                               
	label variable reli "Respondent - Religion"                                
	label define relilabel 1 "Protestant"  2 "Catholic" 3 "Jewish" 4 "No-preference" 5 "Other" 
	label values reli relilabel
tab reli

*Other explanatory variables:
  
*Age 
des r12agey_b
sum r12agey_b
label variable r12agey_b "Respondent - Age"
tab r12agey_b

**Gender 			                             
gen rfemale=(ragender==2)											 
replace rfemale=. if missing(ragender)
label variable rfemale "Respondent is a woman"
tab rfemale

**Race
des raracem
sum raracem					
label variable raracem "Respondent - Race/ethnicithy"
tab raracem

*Race-Hispanic
des rahispan
sum rahispan
label variable rahispan "Respondent - Whether Hispanic"
tab rahispan

*Education    
foreach x in r {
	gen `x'educa=1 if `x'aedyrs>=11
	replace `x'educa=0 if `x'aedyrs<=10
	replace `x'educa=. if missing(`x'aedyrs)							
}      
    label variable reduca "Respondent - more than 11 years of education"	                                      

tab reduca
														  
**Marital Status  
foreach x in r {
	gen `x'partner=1 if `x'12mstat<=3
	replace `x'partner=0 if `x'12mstat>=4
	replace `x'partner=. if missing(`x'12mstat)							
}      
    label variable rpartner "Respondent has a partner"	
tab rpartner

*Total Income
generate linc = ln(h12itot)
tab linc


*Mother's education 
foreach x in r {
	gen `x'mothere=1 if `x'ameduc>=11
	replace `x'mothere=0 if `x'ameduc<=10
	replace `x'mothere=. if missing(`x'ameduc)							
}      
    label variable rmothere "Mother's Respondent - more than 11 years of education"	                                      

tab rmothere


*******************************************************************************
                            *4.ANALYSIS OF DATA *
*******************************************************************************
*******************************************************************************

 ** Binary model 
	
	list reli ralcon
	tab reli ralcon
	histogram reli, w(.9) name(Religionb) percent
	histogram ralcon, w(.5) name(Alcohol) percent
	correlate reli ralcon
	
**  Ordered Probit
	
	list reli rconsu
	tab reli rconsu
	histogram reli,  name(Religionm) 
	histogram rconsu, name(Drinking)
	correlate reli rconsu
	
	
*******************************************************************************
                            *5.BINARY MODEL*
*******************************************************************************
*******************************************************************************
	
*LPM	
regress ralcon i.reli c.r12agey_b##c.r12agey_b rfemale i.raracem rahispan reduca rpartner linc rmothere ,vce(robust) 
estimates store lpm
outreg2 using Reg1.tex, replace ctitle(LPM)

*PROBIT
probit ralcon i.reli c.r12agey_b##c.r12agey_b rfemale i.raracem rahispan reduca rpartner linc rmothere ,vce(robust)  
estimates store probit
outreg2 using Reg2.tex, replace ctitle(PROBIT)

*LOGIT
logit ralcon i.reli c.r12agey_b##c.r12agey_b rfemale i.raracem rahispan reduca rpartner linc rmothere ,vce(robust) 
estimates store logit
outreg2 using Reg3.tex, replace ctitle(LOGIT)
	
** Table for comparing models ** 
esttab lpm probit logit, cells("b(star label(Coef.) fmt(%9.3f)) ") se noparentheses stats(N N_clust r2 r2_p,fmt(0 0 3)) starlevels(* 0.1 ** 0.05 *** 0.01) /* r2_p for pseudo-r-squared */
outreg2 using Reg4.tex, replace ctitle(Summary)

	  
* Predicted probabilities **
estimates restore lpm												 
predict plpm if e(sample), xb								        
estimates restore probit
predict pprobit if e(sample), pr
estimates restore logit
predict plogit if e(sample), pr

* Plot the cumulative distribution functions	
distplot plpm pprobit plogit if e(sample),legend(label(1 lpm) label(2 probit) label(3 logit) row(1))

* Description of Probabilities
sum plpm if e(sample), detail
sum pprobit if e(sample), detail
sum plogit if e(sample), detail

* Partial effect of religion on drinking behavior for an “average” individual*/
estimates restore lpm
margins, dydx(i.reli) predict(xb) atmeans post  /* lpm */
estimates store mem_lpm
estimates restore probit
margins, dydx(i.reli) predict(pr) atmeans post  /* probit */
estimates store mem_probit
estimates restore logit
margins, dydx(i.reli) predict(pr) atmeans post  /* logit */
estimates store mem_logit


*Average marginal effect (AME) religion on drinking behavior based on estimates from the lpm, probit and logit models **/
estimates restore lpm
margins, dydx(i.reli) predict(xb) post  /* lpm */
estimates store ame_lpm
estimates restore probit
margins, dydx(i.reli) predict(pr) post  /* probit */
estimates store ame_probit
estimates restore logit
margins, dydx(i.reli) predict(pr) post  /* logit */
estimates store ame_logit

*Table of comparison
foreach name in lpm probit logit{
		esttab ame_`name', not starlevels(* 0.1 ** 0.05 *** 0.01) 			  
		} 
outreg2 using Reg5.tex, replace ctitle(Summary)

	
*******************************************************************************
                            *6.ORDERED PROBIT*
*******************************************************************************
*******************************************************************************
			
oprobit rconsu i.reli c.r12agey_b##c.r12agey_b rfemale i.raracem rahispan reduca rpartner linc rmothere ,vce(robust) 
	outreg2 using Reg6.tex, replace ctitle(Oprobit)																  
																		
predict p1oprobit p2oprobit p3oprobit p4oprobit, pr
sum p1oprobit p2oprobit p3oprobit p4oprobit
tab rconsu
																		
																		

margins, dydx(*) predict(outcome(0)) atmeans noatlegend	
outreg2 using Reg7.tex, replace ctitle(Outcome0)
																	
margins, dydx(*) predict(outcome(1)) atmeans noatlegend
outreg2 using Reg8.tex, replace ctitle(Outcome1)

margins, dydx(*) predict(outcome(2)) atmeans noatlegend
outreg2 using Reg9.tex, replace ctitle(Outcome2)

margins, dydx(*) predict(outcome(3)) atmeans noatlegend
outreg2 using Reg10.tex, replace ctitle(Outcome3)
																		

log close