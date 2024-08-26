/*
Number of days overseas
- during 2015
- One row for each person

Context:
IDI Demonstration project & training videos
SQL definitions and wrangling phase

Inputs / Dependencies:
- [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___data___person_overseas_spell]

Output:
- [IDI_Sandpit].[DL-MAA2023-999].[defn_days_overseas]

Notes:
1) Uses randomly generated data
2) Partial overlaps with 2015 are trimmed to 2015.
	For example:
		departs NZ 2015-12-28 returns 2016-03-12
		trimmed to
		departs NZ 2015-12-28 returns 2015-12-31
		before calculating days overseas

History:
2023-06-27 original
2023-06-28 new header and notes
*/

DROP TABLE IF EXISTS [IDI_Sandpit].[DL-MAA2023-999].[defn_days_overseas]
GO

WITH setup AS (

SELECT [snz_uid]
      ,[pos_applied_date] -- start overseas, end local
      ,[pos_ceased_date] -- end overseas, begin local
	  ,IIF([pos_applied_date] < '2015-01-01', '2015-01-01', [pos_applied_date]) AS trimmed_start_date
	  ,IIF([pos_ceased_date] > '2015-12-31', '2015-12-31', [pos_ceased_date]) AS trimmed_end_date
FROM [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___data___person_overseas_spell]
WHERE NOT '2015-12-31' < [pos_applied_date]
AND NOT [pos_ceased_date] < '2015-01-01'

)
SELECT snz_uid
	,SUM(DATEDIFF(DAY, trimmed_start_date, trimmed_end_date)) AS total_days_overseas
INTO [IDI_Sandpit].[DL-MAA2023-999].[defn_days_overseas]
FROM setup
GROUP BY snz_uid
GO
