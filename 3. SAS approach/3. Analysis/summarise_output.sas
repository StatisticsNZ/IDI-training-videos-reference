/*summarise tables*/

/*
Output:
age x anytime overseas
age x hospitalised
age x income quantile
*/

/*Create table age_anytime_overseas*/

proc sql;
create table age_anytime_overseas as
select age_group,
overseas_during_2015,
sum(month_equiv_income) as total_month_equiv_income,
count(month_equiv_income) as num_w_month_equiv_income,
count(*) as num_people
from tidy_table2
group by age_group, overseas_during_2015;
quit;

/*Create table age_hospitalised*/

proc sql;
create table age_hospitalised as
select age_group,
hospital_during_2015,
sum(month_equiv_income) as total_month_equiv_income,
count(month_equiv_income) as num_w_month_equiv_income,
count(*) as num_people
from tidy_table2
group by age_group, hospital_during_2015;
quit;

/*Create table age_income_quantile*/

proc sql;
create table age_income_quantile as
select age_group,
income_quantile,
sum(month_equiv_income) as total_month_equiv_income,
count(month_equiv_income) as num_w_month_equiv_income,
count(*) as num_people
from tidy_table2
group by age_group, income_quantile;
quit;

/*export the results*/
ods csv file="//<<<NETWORK-SHARE>>>/3. SAS approach/4. Output/age_by_x_results1.csv";
proc print data=age_anytime_overseas noobs;
run;

proc print data=age_hospitalised noobs;
run;

proc print data=age_income_quantile noobs;
run;
ods csv close;
