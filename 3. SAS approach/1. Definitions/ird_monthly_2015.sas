/*Income data from IR data*/
/*
- filter income in 2015
- some people may have more than 1 record per month, we need to count the 
unique dates they have income
*/

/*Creat table setup*/
proc sql;
	create table setup as 
		select snz_uid
			,ir_ems_return_period_date
			,ir_ems_gross_earnings_amt
			,ir_ems_income_source_code,
		case 
			when ir_ems_income_source_code='PEN' then 1 
			else 0 
		end 
	as ind_PEN,
		case 
			when ir_ems_income_source_code='BEN' then 1 
			else 0 
		end 
	as ind_BEN,
		case 
			when ir_ems_income_source_code='WAS' then 1 
			else 0 
		end 
	as ind_WAS,
		case 
			when ir_ems_income_source_code='WHP' then 1 
			else 0 
		end 
	as ind_WHP
		from sandpit.ird_ems
			where year(ir_ems_return_period_date)=2015;
quit;

/*Create table defn_ird_monthly*/
/*
-Total income in 2015
-how many months people have income
*/

Proc sql;
create table defn_ird_monthly as
select snz_uid,
sum(ir_ems_gross_earnings_amt) as total_2015_income,
count(distinct ir_ems_return_period_date) as num_months_w_income,
max(ind_PEN)as any_PEN,
max(ind_BEN)as any_BEN,
max(ind_WAS)as any_WAS,
max(ind_WHP)as any_WHP
from setup
group by snz_uid;
quit;
