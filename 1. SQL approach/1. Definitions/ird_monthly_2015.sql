/*
Income measures from IR data
- Filtered to 2015
- One row for each person
- required columns
	snz_uid
	total income for year
	number of months with income
	indicators for PEN income type
	indicators for BEN income type
	indicators for WAS income type
	indicators for WHP income type

Context:
IDI Demonstration project & training videos
SQL definitions and wrangling phase

Inputs / Dependencies:
- [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___ir_clean___ird_ems]

Output:
- [IDI_Sandpit].[DL-MAA2023-999].[defn_ird_monthly]

Notes:
1) Uses randomly generated data
2) Some people have more than one record per month.
	(Multiple concurrent jobs?)
	Hence we can not count records when summarising,
	and instead need to count distinct dates.

History:
2023-06-27 original
2023-06-28 new header and notes
*/

DROP TABLE IF EXISTS [IDI_Sandpit].[DL-MAA2023-999].[defn_ird_monthly]
GO

WITH setup AS (

SELECT [snz_uid]
      ,[ir_ems_return_period_date]
      ,[ir_ems_gross_earnings_amt]
      ,[ir_ems_income_source_code]
	  ,IIF([ir_ems_income_source_code] = 'PEN', 1, 0) AS ind_PEN
	  ,IIF([ir_ems_income_source_code] = 'BEN', 1, 0) AS ind_BEN
	  ,IIF([ir_ems_income_source_code] = 'WAS', 1, 0) AS ind_WAS
	  ,IIF([ir_ems_income_source_code] = 'WHP', 1, 0) AS ind_WHP
FROM [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___ir_clean___ird_ems]
WHERE YEAR([ir_ems_return_period_date]) = 2015

)
SELECT snz_uid
	,SUM([ir_ems_gross_earnings_amt]) AS total_2015_income
	,COUNT(DISTINCT [ir_ems_return_period_date]) AS num_months_w_income
	,MAX(ind_PEN) AS any_PEN
	,MAX(ind_BEN) AS any_BEN
	,MAX(ind_WAS) AS any_WAS
	,MAX(ind_WHP) AS any_WHP
INTO [IDI_Sandpit].[DL-MAA2023-999].[defn_ird_monthly]
FROM setup
GROUP BY snz_uid
GO
