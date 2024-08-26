/*
Tidy variables in dataset

Context:
IDI Demonstration project & training videos
SQL analysis phase

Inputs / Dependencies:
- [IDI_Sandpit].[DL-MAA2023-999].[assembled_table]

Output:
- [IDI_Sandpit].[DL-MAA2023-999].[tidy_table1]
- [IDI_Sandpit].[DL-MAA2023-999].[tidy_table2]

Notes:
1) Uses randomly generated data
2) Tiding is done in two steps as second step
	makes use of variables prepared in the first step.
3) Could be more efficient: right now we write to
	database twice. Doing this as a single query
	would be more efficient.
4) Corresponding verification in tidy_verification.sql

History:
2023-06-27 original
2023-06-28 new header and notes
*/

DROP TABLE IF EXISTS [IDI_Sandpit].[DL-MAA2023-999].[tidy_table1]
GO

SELECT [snz_uid]
      ,[snz_sex_gender_code]
      ,[snz_birth_year_nbr]
      ,[snz_birth_month_nbr]
      ,[eth_euro]
      ,[eth_maori]
      ,[eth_pacific]
      ,[eth_asian]
      ,[eth_melaa]
      ,[eth_other]
      ,[snz_deceased_year_nbr]
      ,[snz_deceased_month_nbr]
      ,[birth_date]
      ,[death_date]
      ,[total_2015_income]
      ,[num_months_w_income]
      ,COALESCE([any_PEN], 0) AS [any_PEN]
      ,COALESCE([any_BEN], 0) AS [any_BEN]
      ,COALESCE([any_WAS], 0) AS [any_WAS]
      ,COALESCE([any_WHP], 0) AS [any_WHP]
      ,[num_hospital_discharges]
      ,[total_days_overseas]
	  /* derived columns */
	  ,2015 - [snz_birth_year_nbr] AS age_2015
	  ,IIF([snz_deceased_year_nbr] IS NOT NULL AND [snz_deceased_year_nbr] <= 2015, 1, 0) AS died_before_during_2015
	  ,[total_2015_income] / [num_months_w_income] AS month_equiv_income
	  ,IIF([total_days_overseas] IS NOT NULL AND [total_days_overseas] > 0, 1, 0) AS overseas_during_2015
	  ,IIF([num_hospital_discharges] IS NOT NULL AND [num_hospital_discharges] > 0, 1, 0) AS hospital_during_2015
INTO [IDI_Sandpit].[DL-MAA2023-999].[tidy_table1]
FROM [IDI_Sandpit].[DL-MAA2023-999].[assembled_table]
GO

/*
step 2
-filter
-age groups
-income quantiles
*/

DROP TABLE IF EXISTS [IDI_Sandpit].[DL-MAA2023-999].[tidy_table2]
GO

SELECT [snz_uid]
      ,[snz_sex_gender_code]
      ,[snz_birth_year_nbr]
      ,[snz_birth_month_nbr]
      ,[eth_euro]
      ,[eth_maori]
      ,[eth_pacific]
      ,[eth_asian]
      ,[eth_melaa]
      ,[eth_other]
      ,[snz_deceased_year_nbr]
      ,[snz_deceased_month_nbr]
      ,[birth_date]
      ,[death_date]
      ,[total_2015_income]
      ,[num_months_w_income]
      ,[any_PEN]
      ,[any_BEN]
      ,[any_WAS]
      ,[any_WHP]
      ,[num_hospital_discharges]
      ,[total_days_overseas]
	  /* derived columns */
	  ,age_2015
	  ,died_before_during_2015
	  ,month_equiv_income
	  ,overseas_during_2015
	  ,hospital_during_2015
	  /* further derived columns */
	  ,CASE
		WHEN age_2015 BETWEEN 15 AND 45 THEN 'younger'
		WHEN age_2015 BETWEEN 46 AND 65 THEN 'older'
		ELSE 'error' END AS age_group
	  ,CASE
		WHEN month_equiv_income < 569 THEN 'Q1'
		WHEN month_equiv_income < 856 THEN 'Q2'
		WHEN month_equiv_income < 1052 THEN 'Q3'
		WHEN month_equiv_income IS NOT NULL THEN 'Q4'
		ELSE NULL END AS income_quantile

INTO [IDI_Sandpit].[DL-MAA2023-999].[tidy_table2]
FROM [IDI_Sandpit].[DL-MAA2023-999].[tidy_table1]
WHERE age_2015 IS NOT NULL
AND age_2015 BETWEEN 15 AND 65
AND died_before_during_2015 = 0
GO
