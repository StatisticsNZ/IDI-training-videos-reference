/*
Assembly of rectangular table

Context:
IDI Demonstration project & training videos
SQL assembly phase

Inputs / Dependencies:
- [IDI_Sandpit].[DL-MAA2023-999].[defn_num_hospital_discharges]
- [IDI_Sandpit].[DL-MAA2023-999].[defn_ird_monthly]
- [IDI_Sandpit].[DL-MAA2023-999].[defn_days_overseas]
- [IDI_UserCode].[DL-MAA2023-999].[defn_personal_details]
- [IDI_UserCode].[DL-MAA2023-999].[defn_res_pop]

Output:
- [IDI_Sandpit].[DL-MAA2023-999].[assembled_table]

Notes:
1) Uses randomly generated data
2) We make use of the fact that all the input tables
	have been prepared as 2015 only, and one row per person.

History:
2023-06-27 original
2023-06-28 new header and notes
*/

DROP TABLE IF EXISTS [IDI_Sandpit].[DL-MAA2023-999].[assembled_table]
GO

SELECT r.[snz_uid]

      /* from personal details */
	  ,p.[snz_sex_gender_code]
      ,p.[snz_birth_year_nbr]
      ,p.[snz_birth_month_nbr]
      ,p.[eth_euro]
      ,p.[eth_maori]
      ,p.[eth_pacific]
      ,p.[eth_asian]
      ,p.[eth_melaa]
      ,p.[eth_other]
      ,p.[snz_deceased_year_nbr]
      ,p.[snz_deceased_month_nbr]
      ,p.[birth_date]
      ,p.[death_date]

	  /* from IR EMS */
	  ,i.[total_2015_income]
      ,i.[num_months_w_income]
      ,i.[any_PEN]
      ,i.[any_BEN]
      ,i.[any_WAS]
      ,i.[any_WHP]

	  /* from MOH hospital */
	  ,h.[num_hospital_discharges]

	  /* from Overseas */
	  ,o.[total_days_overseas]
  
INTO [IDI_Sandpit].[DL-MAA2023-999].[assembled_table]
FROM [IDI_UserCode].[DL-MAA2023-999].[defn_res_pop] AS r
LEFT JOIN [IDI_UserCode].[DL-MAA2023-999].[defn_personal_details] AS p
ON r.snz_uid = p.snz_uid
LEFT JOIN [IDI_Sandpit].[DL-MAA2023-999].[defn_ird_monthly] AS i
ON r.snz_uid = i.snz_uid
LEFT JOIN [IDI_Sandpit].[DL-MAA2023-999].[defn_num_hospital_discharges] AS h
ON r.snz_uid = h.snz_uid
LEFT JOIN [IDI_Sandpit].[DL-MAA2023-999].[defn_days_overseas] AS o
ON r.snz_uid = o.snz_uid
GO
