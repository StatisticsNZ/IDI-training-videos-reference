/*
Number of hospital stays
- Filtered to 2015
- One row for each person

Context:
IDI Demonstration project & training videos
SQL definitions and wrangling phase

Inputs / Dependencies:
- [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___moh_clean___pub_fund_hosp_discharges_event]

Output:
- [IDI_Sandpit].[DL-MAA2023-999].[defn_num_hospital_discharges]

Notes:
1) Uses randomly generated data
2) Partial overlaps with 2015 are included.
	E.g. hospital stay 31 Dec 2014 --> 1 Jan 2015 is included.

History:
2023-06-27 original
2023-06-28 new header and notes
*/

DROP TABLE IF EXISTS [IDI_Sandpit].[DL-MAA2023-999].[defn_num_hospital_discharges]
GO

SELECT [snz_uid], COUNT(*) AS num_hospital_discharges
      --,[moh_evt_evst_date]
      --,[moh_evt_even_date]
INTO [IDI_Sandpit].[DL-MAA2023-999].[defn_num_hospital_discharges]
FROM [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___moh_clean___pub_fund_hosp_discharges_event]
WHERE NOT '2015-12-31' < [moh_evt_evst_date]
AND NOT [moh_evt_even_date] < '2015-01-01'
GROUP BY snz_uid
