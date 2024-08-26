/*
Population definition
- Personal details/demographics
- For all people with unique details
- One row per person

Context:
IDI Demonstration project & training videos
SQL definitions and wrangling phase

Inputs / Dependencies:
- [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___data___personal_detail]

Output:
- [IDI_UserCode].[DL-MAA2023-999].[defn_personal_details]

Notes:
1) Uses randomly generated data
2) A small number of rows contain unacceptable values:
	No snz_uid or different identities with the same uid.
	Hence these are excluded using a subquery.

History:
2023-06-27 original
2023-06-28 new header and notes
*/

USE IDI_UserCode
GO

DROP VIEW IF EXISTS [DL-MAA2023-999].[defn_personal_details]
GO

CREATE VIEW [DL-MAA2023-999].[defn_personal_details] AS
SELECT [snz_uid]
      ,[snz_sex_gender_code] -- 1 = male, 2 = female, 3 = neither
      ,[snz_birth_year_nbr]
      ,[snz_birth_month_nbr]
      ,[snz_ethnicity_grp1_nbr] AS eth_euro
      ,[snz_ethnicity_grp2_nbr] AS eth_maori
      ,[snz_ethnicity_grp3_nbr] AS eth_pacific
      ,[snz_ethnicity_grp4_nbr] AS eth_asian
      ,[snz_ethnicity_grp5_nbr] AS eth_melaa
      ,[snz_ethnicity_grp6_nbr] AS eth_other
      ,[snz_deceased_year_nbr]
      ,[snz_deceased_month_nbr]
	  ,DATEFROMPARTS([snz_birth_year_nbr], [snz_birth_month_nbr], 15) AS birth_date
	  ,DATEFROMPARTS([snz_deceased_year_nbr], [snz_deceased_month_nbr], 15) AS death_date
FROM [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___data___personal_detail]
/* exclude uid's that are a concern */
WHERE snz_uid IS NOT NULL
AND snz_uid NOT IN (
	SELECT snz_uid
	FROM [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___data___personal_detail]
	WHERE snz_uid IS NOT NULL
	GROUP BY snz_uid
	HAVING COUNT(*) > 1
)
GO
