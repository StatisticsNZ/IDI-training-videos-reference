/*******************************************************************************

					ANALYSIS
					
					Read in data, some basic transformations, create some x-tabs
					save as output
					
					Author: Corey
					
					Date created: 25/08/2023
					Date modified:
					
*******************************************************************************/

#delim ;
odbc load, bigint clear $IDI_CONN exec("
	select [snz_uid]
		,[sex_gender_code]
		,[eth_euro]
		,[eth_maori]
		,[eth_pacific]
		,[eth_asian]
		,[eth_melaa]
		,[eth_other]
		,[birth_year]
		,[birth_month]
		,[death_year]
		,[death_month]
		,[total_income]
		,[months_income]
		,COALESCE([income_source=PEN], 0) as any_pen
		,COALESCE([income_source=BEN], 0) as any_ben
		,COALESCE([income_source=WAS], 0) as any_was
		,COALESCE([income_source=WHP], 0) as any_whp
		,[days_overseas]
		,[num_hosp_discharge]
		, age = 2015 - birth_year
		, IIF(death_year is not null and death_year <=2015, 1, 0) as died_before_2015
		, total_income / months_income as month_equiv_income
		, IIF(days_overseas is not null and days_overseas >1, 1, 0) as overseas_during_2015
		, IIF(num_hosp_discharge is not null and num_hosp_discharge > 0, 1, 0) as hospital_during_2015
		, age_group = case when 2015 - birth_year between 15 and 45 then 'younger'
				when 2015 - birth_year between 46 and 65 then 'older'
				else 'error' end
	from [DL-MAA2023-999].rectangular_data"
);

#delim cr


xtile income_quantile = month_equiv_income, n(4)

drop if died_before_2015 == 1 | age_group == "error"


label define yn 0 "No" 1 "Yes" 99 "Total"
lab val overseas_during_2015 yn
lab val hospital_during_2015 yn

lab def quart 1 "Bottom 25%" 2 "25th-50th percentile" 3 "50th-75th" 4 "Top 25%" 99 "Total"
lab val income_quantile quart

global outfile = "${out}\Summ stats.xlsx"
global outfile_c = "${out}\Summ stats CONFID.xlsx"

ta age_group overseas_during_2015

global ss_list = "overseas_during_2015 hospital_during_2015 income_quantile"

cap frame change default
cap frame drop analysis

cap erase "$outfile"
cap erase "$outfile_c"

local rc = 2

foreach k of global ss_list {

	frame put snz_uid `k' age_group months_income month_equiv_income, into(analysis)
	frame change analysis

	table age_group `k', c(count snz_uid count months_income sum month_equiv_income) row col replace

	ren (table*) (N_people N_w_income tot_inc)


	foreach i of varlist N_people N_w_income {
		
		grr `i', $conf3 gen("rr3_")

	}

	gen conf_tot_inc = tot_inc
	replace conf_tot_inc = .s if N_w_income<20

	replace age_group = "Total" if age_group==""
	replace `k' = 99 if `k'==.
	

	order age_group `k' N_people rr3_N_people N_w_income rr3_N_w_income tot_inc conf_tot_inc
	sort age_group `k'

	count
	local n = r(N)
	
	export excel using "$outfile", sheet("Population X-tabs", modify) first(var) cell(b`rc') miss(".s")
	export excel age_group `k' rr3* conf_tot_inc using "$outfile_c", sheet("Population X-tabs", modify) first(var) cell(b`rc') miss(".s")
	
	local rc = `rc'+`n'+5

	frame change default
	frame drop analysis

}