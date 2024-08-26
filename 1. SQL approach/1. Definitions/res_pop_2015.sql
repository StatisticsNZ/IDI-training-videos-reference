/*
Population definition
- NZ residents who are resident in 2015

Context:
IDI Demonstration project & training videos
SQL definitions and wrangling phase

Inputs / Dependencies:
- [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___data___snz_res_pop]

Output:
- [IDI_UserCode].[DL-MAA2023-999].[defn_res_pop]

Notes:
1) Uses randomly generated data

History:
2023-06-27 original
2023-06-28 new header and notes
*/

USE IDI_UserCode
GO

DROP VIEW IF EXISTS [DL-MAA2023-999].[defn_res_pop]
GO

CREATE VIEW [DL-MAA2023-999].[defn_res_pop] AS
SELECT [snz_uid]
      --,[srp_ref_date]
FROM [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___data___snz_res_pop]
WHERE YEAR([srp_ref_date]) = 2015
GO
