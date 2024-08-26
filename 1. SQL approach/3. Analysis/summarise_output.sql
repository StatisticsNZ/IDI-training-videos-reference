/*
Output summary tables

Context:
IDI Demonstration project & training videos
SQL output phase

Inputs / Dependencies:
- [IDI_Sandpit].[DL-MAA2023-999].[tidy_table2]

Output:
- tables copied to Excel

Notes:
1) Uses randomly generated data
2) Key outputs:	
	- total monthly-equivalised income
	- number of people with monthly-equivalised income
	- total number of people in scope
3) Key interactions
	- age x anytime overseas
	- age x hospitalised
	- age x income quantile

History:
2023-06-27 original
2023-06-28 new header and notes
*/

/*
SELECT TOP 100 *
FROM [IDI_Sandpit].[DL-MAA2023-999].[tidy_table2]
*/

-- age x anytime overseas
SELECT age_group
	,overseas_during_2015
	,SUM(month_equiv_income) AS total_month_equiv_income
	,COUNT(month_equiv_income) AS num_w_month_equiv_income
	,COUNT(*) AS num_people
FROM [IDI_Sandpit].[DL-MAA2023-999].[tidy_table2]
GROUP BY age_group, overseas_during_2015

-- age x hospitalised
SELECT age_group
	,hospital_during_2015
	,SUM(month_equiv_income) AS total_month_equiv_income
	,COUNT(month_equiv_income) AS num_w_month_equiv_income
	,COUNT(*) AS num_people
FROM [IDI_Sandpit].[DL-MAA2023-999].[tidy_table2]
GROUP BY age_group, hospital_during_2015

-- age x income quantile
SELECT age_group
	,income_quantile
	,SUM(month_equiv_income) AS total_month_equiv_income
	,COUNT(month_equiv_income) AS num_w_month_equiv_income
	,COUNT(*) AS num_people
FROM [IDI_Sandpit].[DL-MAA2023-999].[tidy_table2]
GROUP BY age_group, income_quantile
