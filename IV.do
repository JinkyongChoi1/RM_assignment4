* 1. Load the data 

cd "/Users/jc5901/Documents/GitHub/RM_assignment4"
insheet using crime-iv.csv, clear

* 4. Balance tables 

egen mymean = mean(monthsinjail)
gen treatment = 0 
replace treatment = 1 if monthsinjail > mymean 


global balanceopts "prehead(\begin{tabular}{l*{6}{c}}) postfoot(\end{tabular}) noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01)"

estpost ttest republicanjudge severityofcrime, by(treatment) unequal welch

esttab . using test1.tex, cell("mu_1(f(3)) mu_2(f(3)) b(f(3) star)") wide label collabels("Control" "Treatment" "Difference") noobs $balanceopts mlabels(none) eqlabels(none) replace mgroups(none)

* 5. First stage 

reg monthsinjail republicanjudge severityofcrime 
eststo first_stage 
esttab first_stage using first_stage.rtf  

* 7. Reduced form 

reg recidivates republicanjudge severityofcrime  
eststo reduced_form 
esttab reduced_form using reduced_form.rtf  

* 9. IV regression

ssc install ivreg2
ivreg2 recidivates (monthsinjail=republicanjudge) severityofcrime
eststo ivreg_result 
esttab ivreg_result using ivreg_result.rtf  
