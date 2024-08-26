/*Library*/
libname sandpit ODBC dsn=idi_sandpit_srvprd schema="DL-MAA2023-999";
/*step 1*/
/*
- calculate age in 2015: filter to have non missing value
- calculate monthly income
*/

proc sql;
create table tidy_table1 as
select snz_uid,
	snz_gender_code,
	snz_birth_year_nbr,
	snz_birth_month_nbr,
	eth_euro,
	eth_maori,
	eth_pacific,
	eth_asian,
	eth_melaa,
	eth_other,
	snz_deceased_year_nbr,
	snz_deceased_month_nbr,
	birth_date,
	death_date,
	total_2015_income,
	num_months_w_income,
	any_PEN,
	any_BEN,
	any_WAS,
	any_WHP,
	num_hospital_discharges,
	total_days_overseas,
	coalesce(any_PEN,0) as any_PEN,
	coalesce(any_BEN,0) as any_BEN,
	coalesce(any_WAS,0) as any_WAS,
	coalesce(any_WHP,0) as any_WHP,
	2015-snz_birth_year_nbr as age_2015,
	case
		when snz_deceased_year_nbr is not null and snz_deceased_year_nbr<=2015
		then 1
		else 0 end as died_before_during_2015,
	(total_2015_income/num_months_w_income) as month_equiv_income,
	case
		when total_days_overseas is not null and total_days_overseas > 0
		then 1
		else 0 end as overseas_during_2015,
	case
		when num_hospital_discharges is not null and num_hospital_discharges > 0
		then 1
		else 0 end as hospital_during_2015
from sandpit.assemble_table;
quit;



/*step 2*/
/*
- add age groups
- income quantiles
*/

proc sql;
create table tidy_table2 as
select snz_uid,
	snz_gender_code,
	snz_birth_year_nbr,
	snz_birth_month_nbr,
	eth_euro,
	eth_maori,
	eth_pacific,
	eth_asian,
	eth_melaa,
	eth_other,
	snz_deceased_year_nbr,
	snz_deceased_month_nbr,
	birth_date,
	death_date,
	total_2015_income,
	num_months_w_income,
	any_PEN,
	any_BEN,
	any_WAS,
	any_WHP,
	num_hospital_discharges,
	total_days_overseas,
	month_equiv_income,
	overseas_during_2015,
	hospital_during_2015,
	case 
		when age_2015 between 15 and 45 then 'younger'
		when age_2015 between 46 and 65 then 'older'
		else 'error' end as age_group,
	case
		when month_equiv_income=. then 'NULL'
		when month_equiv_income<569 then 'Q1'
		when month_equiv_income<856 then 'Q2'
		when month_equiv_income<1052 then 'Q3'
		else 'Q4' end as income_quantile
from tidy_table1
where age_2015^=.
and age_2015 between 15 and 65
and died_before_during_2015=0;
quit;
