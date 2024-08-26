/*
Study population
- NZ residents who are resident in 2015

Context:
IDI Demonstration project & training videos
R definitions and wrangling phase

Inputs / Dependencies:
- [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___data___snz_res_pop]
- [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___data___personal_detail]

Output:
- [IDI_UserCode].[DL-MAA2023-999].[defn_population_definition]

Notes:
1) Uses randomly generated data
2) A small number of rows in [personal_details] contain unacceptable values:
	No snz_uid or different identities with the same uid.
	These are deliberately excluded from our population definition.

History:
2023-06-28 original
2023-06-29 new header and notes
*/

USE IDI_UserCode
GO

DROP VIEW IF EXISTS [DL-MAA2023-999].[defn_population_definition]
GO

CREATE VIEW [DL-MAA2023-999].[defn_population_definition] AS
SELECT [snz_uid]
      ,[srp_ref_date]
FROM [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___data___snz_res_pop]
WHERE YEAR([srp_ref_date]) = 2015
AND [snz_uid] IS NOT NULL
AND snz_uid NOT IN (
	SELECT snz_uid
	FROM [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___data___personal_detail]
	WHERE snz_uid IS NOT NULL
	GROUP BY [snz_uid]
	HAVING COUNT(*) > 1
)
GO
