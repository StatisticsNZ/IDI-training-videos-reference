/*
Income spell definition

Context:
IDI Demonstration project & training videos
R definitions and wrangling phase

Inputs / Dependencies:
- [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___ir_clean___ird_ems]

Output:
- [IDI_UserCode].[DL-MAA2023-999].[defn_ems_spell]

Notes:
1) Uses randomly generated data
2) Output includes overlapping spells
	E.g. Two income sources in the same month
3) Example at bottom gives an alternative if we prefer a single
	record/row for each time period.

History:
2023-06-28 original
2023-06-29 new header and notes
*/

USE IDI_UserCode
GO

DROP VIEW IF EXISTS [DL-MAA2023-999].[defn_ems_spell]
GO

CREATE VIEW [DL-MAA2023-999].[defn_ems_spell] AS
SELECT [snz_uid]
	  ,DATEFROMPARTS(YEAR([ir_ems_return_period_date]), MONTH([ir_ems_return_period_date]), 1) AS [start_date]
      ,[ir_ems_return_period_date] AS [end_date]
      ,[ir_ems_gross_earnings_amt]
      ,[ir_ems_income_source_code]
FROM [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___ir_clean___ird_ems]
GO

/*
Alternative approach
The below produces once record/row for each person-spell combination.
*/

/*
WITH setup AS (

SELECT [snz_uid]
	  ,DATEFROMPARTS(YEAR([ir_ems_return_period_date]), MONTH([ir_ems_return_period_date]), 1) AS [start_date]
      ,[ir_ems_return_period_date] AS [end_date]
      ,[ir_ems_gross_earnings_amt]
      ,[ir_ems_income_source_code]
FROM [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___ir_clean___ird_ems]

)
SELECT snz_uid
	, [start_date]
	, [end_date]
	, SUM([ir_ems_gross_earnings_amt]) AS [ir_ems_gross_earnings_amt]
	, MAX(IIF([ir_ems_income_source_code] = 'BEN', 1, 0)) AS any_BEN
	, MAX(IIF([ir_ems_income_source_code] = 'PEN', 1, 0)) AS any_PEN
	, MAX(IIF([ir_ems_income_source_code] = 'WAS', 1, 0)) AS any_WAS
	, MAX(IIF([ir_ems_income_source_code] = 'WHP', 1, 0)) AS any_WHP
FROM setup
GROUP BY snz_uid, [start_date], [end_date]
*/
