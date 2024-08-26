/* Get percentiles */
proc summary data=tidy_table1; where month_equiv_income^=.;
var month_equiv_income;
output out=quantile p25= p50= p75=/autoname;
run;
