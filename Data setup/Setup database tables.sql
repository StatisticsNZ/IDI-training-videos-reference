/********************************************************************************************************************
Data setup for training demonstration

The data used for the training demonstration videos was randomly generated. The intention was to generate data
that mimics the structure of real data (for example: same column names and data types), but not the contents.
None of the data in these files is from real people, it has been randomly generated. The project did not have
access to any real data, it used only this fake data for teaching, training, and demonstration purposes.

Should it be necessary to reproduce the data configuration for further training or teaching, we note the steps
to load the data below.

Method:
1) Visit: https://github.com/simon-anasta/randomly_generated_integrated_data
2) Download: Final 10k people with linking error.zip
3) Transfer this zip file into the data lab project
4) Unzip file to access individual csv datasets
5) Import each csv file into a temporary Sandpit table, we used the import wizard for this purpose
6) Run the below code to ensure correct data types
7) Delete the temporary tables

Version:
2023-06-21 original data load
2023-12-05 create of this file as reference point
********************************************************************************************************************/

/***********************************************************
Loading of input table: residential population
***********************************************************/

/* delete prior to creation */
DROP TABLE IF EXISTS [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___data___snz_res_pop]
GO

/* table loaded into tmp location */
SELECT IIF(["snz_uid"] = 'NA', NULL,CAST(["snz_uid"] AS INT)) AS [snz_uid]
	,IIF(["srp_ref_date"] = 'NA', NULL,CAST(SUBSTRING(["srp_ref_date"], 2, LEN(["srp_ref_date"]) - 2) AS DATE)) AS [srp_ref_date]
	,IIF(["srp_flag_ir_ind"] = 'NA', NULL,CAST(["srp_flag_ir_ind"] AS INT)) AS [srp_flag_ir_ind]
	,IIF(["srp_flag_ed_ind"] = 'NA', NULL,CAST(["srp_flag_ed_ind"] AS INT)) AS [srp_flag_ed_ind]
	,IIF(["srp_flag_health_ind"] = 'NA', NULL,CAST(["srp_flag_health_ind"] AS INT)) AS [srp_flag_health_ind]
	,IIF(["srp_flag_acc_ind"] = 'NA', NULL,CAST(["srp_flag_acc_ind"] AS INT)) AS [srp_flag_acc_ind]
	,IIF(["srp_flag_under5_ind"] = 'NA', NULL,CAST(["srp_flag_under5_ind"] AS INT)) AS [srp_flag_under5_ind]
INTO [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___data___snz_res_pop]
FROM [IDI_Sandpit].[DL-MAA2023-999].[tmp_ERP]

/***********************************************************
Loading of input table: personal detail
***********************************************************/

/* delete prior to creation */
DROP TABLE IF EXISTS [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___data___personal_detail]
GO
DROP TABLE IF EXISTS [IDI_Sandpit].[DL-MAA2023-999].[tmp_staging]
GO

/* table loaded into tmp location */
SELECT IIF(["snz_uid"] = 'NA', NULL, CAST(["snz_uid"] AS INT)) AS snz_uid
	,IIF(["snz_sex_gender_code"] = 'NA', NULL, CAST(["snz_sex_gender_code"] AS INT)) AS snz_sex_gender_code
	,IIF(["snz_birth_year_nbr"] = 'NA', NULL, CAST(["snz_birth_year_nbr"] AS INT)) AS snz_birth_year_nbr
	,IIF(["snz_birth_month_nbr"] = 'NA', NULL, CAST(["snz_birth_month_nbr"] AS INT)) AS snz_birth_month_nbr
	,IIF(["snz_ethnicity_grp1_nbr"] = 'NA', NULL, CAST(["snz_ethnicity_grp1_nbr"] AS INT)) AS snz_ethnicity_grp1_nbr
	,IIF(["snz_ethnicity_grp2_nbr"] = 'NA', NULL, CAST(["snz_ethnicity_grp2_nbr"] AS INT)) AS snz_ethnicity_grp2_nbr
	,IIF(["snz_ethnicity_grp3_nbr"] = 'NA', NULL, CAST(["snz_ethnicity_grp3_nbr"] AS INT)) AS snz_ethnicity_grp3_nbr
	,IIF(["snz_ethnicity_grp4_nbr"] = 'NA', NULL, CAST(["snz_ethnicity_grp4_nbr"] AS INT)) AS snz_ethnicity_grp4_nbr
	,IIF(["snz_ethnicity_grp5_nbr"] = 'NA', NULL, CAST(["snz_ethnicity_grp5_nbr"] AS INT)) AS snz_ethnicity_grp5_nbr
	,IIF(["snz_ethnicity_grp6_nbr"] = 'NA', NULL, CAST(["snz_ethnicity_grp6_nbr"] AS INT)) AS snz_ethnicity_grp6_nbr
	,IIF(["snz_deceased_year_nbr"] = 'NA', NULL, CAST(["snz_deceased_year_nbr"] AS INT)) AS snz_deceased_year_nbr
	,IIF(["snz_deceased_month_nbr"] = 'NA', NULL, CAST(["snz_deceased_month_nbr"] AS INT)) AS snz_deceased_month_nbr
	,IIF(["snz_parent1_uid"] = 'NA', NULL, CAST(["snz_parent1_uid"] AS INT)) AS snz_parent1_uid
	,IIF(["snz_parent2_uid"] = 'NA', NULL, CAST(["snz_parent2_uid"] AS INT)) AS snz_parent2_uid
INTO [IDI_Sandpit].[DL-MAA2023-999].[tmp_staging]
FROM [IDI_Sandpit].[DL-MAA2023-999].[tmp]
GO

/* handle future death dates */
SELECT snz_uid
	,snz_sex_gender_code
	,snz_birth_year_nbr
	,snz_birth_month_nbr
	,snz_ethnicity_grp1_nbr
	,snz_ethnicity_grp2_nbr
	,snz_ethnicity_grp3_nbr
	,snz_ethnicity_grp4_nbr
	,snz_ethnicity_grp5_nbr
	,snz_ethnicity_grp6_nbr
	,IIF(snz_deceased_year_nbr > 2020, NULL, snz_deceased_year_nbr) AS snz_deceased_year_nbr
	,IIF(snz_deceased_year_nbr > 2020, NULL, snz_deceased_month_nbr) AS snz_deceased_month_nbr
	,snz_parent1_uid
	,snz_parent2_uid
INTO [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___data___personal_detail]
FROM [IDI_Sandpit].[DL-MAA2023-999].[tmp_staging]
GO

DROP TABLE IF EXISTS [IDI_Sandpit].[DL-MAA2023-999].[tmp_staging]
GO

/***********************************************************
Loading of input table: person overseas spells
***********************************************************/

/* delete prior to creation */
DROP TABLE IF EXISTS [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___data___personal_overseas_spell]
GO

/* table loaded into tmp location */
SELECT IIF(["snz_uid"] = 'NA', NULL,CAST(["snz_uid"] AS INT)) AS [snz_uid]
	,IIF(["pos_applied_date"] = 'NA', NULL,CAST(SUBSTRING(["pos_applied_date"], 2, LEN(["pos_applied_date"]) - 2) AS DATE)) AS [pos_applied_date]
	,IIF(["pos_ceased_date"] = 'NA', NULL,CAST(SUBSTRING(["pos_ceased_date"], 2, LEN(["pos_ceased_date"]) - 2) AS DATE)) AS [pos_ceased_date]
	,IIF(["pos_day_span_nbr"] = 'NA', NULL,CAST(["pos_day_span_nbr"] AS INT)) AS [pos_day_span_nbr]
	,IIF(["pos_first_arrival_ind"] = 'NA', NULL,CAST(SUBSTRING(["pos_first_arrival_ind"], 2, LEN(["pos_first_arrival_ind"]) - 2) AS CHAR(1))) AS [pos_first_arrival_ind]
	,IIF(["pos_last_departure_ind"] = 'NA', NULL,CAST(SUBSTRING(["pos_last_departure_ind"], 2, LEN(["pos_last_departure_ind"]) - 2) AS CHAR(1))) AS [pos_last_departure_ind]
	,IIF(["pos_source_code"] = 'NA', NULL,CAST(SUBSTRING(["pos_source_code"], 2, LEN(["pos_source_code"]) - 2) AS VARCHAR(5))) AS [pos_source_code]
INTO [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___data___personal_overseas_spell]
FROM [IDI_Sandpit].[DL-MAA2023-999].[tmp_overseas]	
GO

/***********************************************************
Loading of input table: Hospital discharge events
***********************************************************/

/* delete prior to creation */
DROP TABLE IF EXISTS [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___moh_clean___pub_fund_hosp_discharges_event]
GO

/* table loaded into tmp location */
SELECT IIF(["snz_uid"] = 'NA', NULL,CAST(["snz_uid"] AS INT)) AS [snz_uid]
	,IIF(["snz_moh_uid"] = 'NA', NULL,CAST(["snz_moh_uid"] AS INT)) AS [snz_moh_uid]
	,IIF(["snz_acc_claim_uid"] = 'NA', NULL,CAST(["snz_acc_claim_uid"] AS INT)) AS [snz_acc_claim_uid]
	,IIF(["snz_moh_evt_uid"] = 'NA', NULL,CAST(["snz_moh_evt_uid"] AS INT)) AS [snz_moh_evt_uid]
	,IIF(["moh_evt_event_id_nbr"] = 'NA', NULL,CAST(["moh_evt_event_id_nbr"] AS INT)) AS [moh_evt_event_id_nbr]
	,IIF(["moh_evt_adm_src_code"] = 'NA', NULL,CAST(SUBSTRING(["moh_evt_adm_src_code"], 2, LEN(["moh_evt_adm_src_code"]) - 2) AS CHAR(1))) AS [moh_evt_adm_src_code]
	,IIF(["moh_evt_adm_type_code"] = 'NA', NULL,CAST(SUBSTRING(["moh_evt_adm_type_code"], 2, LEN(["moh_evt_adm_type_code"]) - 2) AS CHAR(1))) AS [moh_evt_adm_type_code]
	,IIF(["moh_evt_nz_res_code"] = 'NA', NULL,CAST(["moh_evt_nz_res_code"] AS INT)) AS [moh_evt_nz_res_code]
	,IIF(["moh_evt_birth_month_nbr"] = 'NA', NULL,CAST(["moh_evt_birth_month_nbr"] AS INT)) AS [moh_evt_birth_month_nbr]
	,IIF(["moh_evt_birth_year_nbr"] = 'NA', NULL,CAST(["moh_evt_birth_year_nbr"] AS INT)) AS [moh_evt_birth_year_nbr]
	,IIF(["moh_evt_sex_snz_code"] = 'NA', NULL,CAST(["moh_evt_sex_snz_code"] AS INT)) AS [moh_evt_sex_snz_code]
	,IIF(["moh_evt_eth_priority_grp_code"] = 'NA', NULL,CAST(["moh_evt_eth_priority_grp_code"] AS INT)) AS [moh_evt_eth_priority_grp_code]
	,IIF(["moh_evt_ethnicity_1_code"] = 'NA', NULL,CAST(["moh_evt_ethnicity_1_code"] AS INT)) AS [moh_evt_ethnicity_1_code]
	,IIF(["moh_evt_ethnicity_2_code"] = 'NA', NULL,CAST(["moh_evt_ethnicity_2_code"] AS INT)) AS [moh_evt_ethnicity_2_code]
	,IIF(["moh_evt_dhb_dom_code"] = 'NA', NULL,CAST(["moh_evt_dhb_dom_code"] AS INT)) AS [moh_evt_dhb_dom_code]
	,IIF(["moh_evt_event_type_code"] = 'NA', NULL,CAST(["moh_evt_event_type_code"] AS INT)) AS [moh_evt_event_type_code]
	,IIF(["moh_evt_end_type_code"] = 'NA', NULL,CAST(SUBSTRING(["moh_evt_end_type_code"], 2, LEN(["moh_evt_end_type_code"]) - 2) AS CHAR(1))) AS [moh_evt_end_type_code]
	,IIF(["moh_evt_evst_date"] = 'NA', NULL,CAST(SUBSTRING(["moh_evt_evst_date"], 2, LEN(["moh_evt_evst_date"]) - 2) AS DATE)) AS [moh_evt_evst_date]
	,IIF(["moh_evt_even_date"] = 'NA', NULL,CAST(SUBSTRING(["moh_evt_even_date"], 2, LEN(["moh_evt_even_date"]) - 2) AS DATE)) AS [moh_evt_even_date]
	,IIF(["moh_evt_local_id_nbr"] = 'NA', NULL,CAST(["moh_evt_local_id_nbr"] AS INT)) AS [moh_evt_local_id_nbr]
	,IIF(["moh_evt_facility_code"] = 'NA', NULL,CAST(["moh_evt_facility_code"] AS INT)) AS [moh_evt_facility_code]
	,IIF(["moh_evt_facility_type_code"] = 'NA', NULL,CAST(SUBSTRING(["moh_evt_facility_type_code"], 2, LEN(["moh_evt_facility_type_code"]) - 2) AS CHAR(1))) AS [moh_evt_facility_type_code]
	,IIF(["moh_evt_hours_on_cpap_nbr"] = 'NA', NULL,CAST(["moh_evt_hours_on_cpap_nbr"] AS INT)) AS [moh_evt_hours_on_cpap_nbr]
	,IIF(["moh_evt_tot_icu_hours_nbr"] = 'NA', NULL,CAST(["moh_evt_tot_icu_hours_nbr"] AS INT)) AS [moh_evt_tot_icu_hours_nbr]
	,IIF(["moh_evt_tot_niv_hours_nbr"] = 'NA', NULL,CAST(["moh_evt_tot_niv_hours_nbr"] AS INT)) AS [moh_evt_tot_niv_hours_nbr]
	,IIF(["moh_evt_acc_flag_code"] = 'NA', NULL,CAST(["moh_evt_acc_flag_code"] AS INT)) AS [moh_evt_acc_flag_code]
	,IIF(["moh_evt_facility_xfer_to_code"] = 'NA', NULL,CAST(["moh_evt_facility_xfer_to_code"] AS INT)) AS [moh_evt_facility_xfer_to_code]
	,IIF(["moh_evt_facility_xfer_from_code"] = 'NA', NULL,CAST(["moh_evt_facility_xfer_from_code"] AS INT)) AS [moh_evt_facility_xfer_from_code]
	,IIF(["moh_evt_occupation_code"] = 'NA', NULL,CAST(["moh_evt_occupation_code"] AS INT)) AS [moh_evt_occupation_code]
	,IIF(["moh_evt_occupation_text"] = 'NA', NULL,CAST(["moh_evt_occupation_text"] AS INT)) AS [moh_evt_occupation_text]
	,IIF(["moh_evt_ethnic_snz_code"] = 'NA', NULL,CAST(SUBSTRING(["moh_evt_ethnic_snz_code"], 2, LEN(["moh_evt_ethnic_snz_code"]) - 2) AS VARCHAR(8))) AS [moh_evt_ethnic_snz_code]
	,IIF(["moh_evt_ethnic1_snz_code"] = 'NA', NULL,CAST(["moh_evt_ethnic1_snz_code"] AS INT)) AS [moh_evt_ethnic1_snz_code]
	,IIF(["moh_evt_ethnic2_snz_code"] = 'NA', NULL,CAST(["moh_evt_ethnic2_snz_code"] AS INT)) AS [moh_evt_ethnic2_snz_code]
	,IIF(["moh_evt_ethnic_grp1_snz_ind"] = 'NA', NULL,CAST(["moh_evt_ethnic_grp1_snz_ind"] AS INT)) AS [moh_evt_ethnic_grp1_snz_ind]
	,IIF(["moh_evt_ethnic_grp2_snz_ind"] = 'NA', NULL,CAST(["moh_evt_ethnic_grp2_snz_ind"] AS INT)) AS [moh_evt_ethnic_grp2_snz_ind]
	,IIF(["moh_evt_ethnic_grp3_snz_ind"] = 'NA', NULL,CAST(["moh_evt_ethnic_grp3_snz_ind"] AS INT)) AS [moh_evt_ethnic_grp3_snz_ind]
	,IIF(["moh_evt_ethnic_grp4_snz_ind"] = 'NA', NULL,CAST(["moh_evt_ethnic_grp4_snz_ind"] AS INT)) AS [moh_evt_ethnic_grp4_snz_ind]
	,IIF(["moh_evt_ethnic_grp5_snz_ind"] = 'NA', NULL,CAST(["moh_evt_ethnic_grp5_snz_ind"] AS INT)) AS [moh_evt_ethnic_grp5_snz_ind]
	,IIF(["moh_evt_ethnic_grp6_snz_ind"] = 'NA', NULL,CAST(["moh_evt_ethnic_grp6_snz_ind"] AS INT)) AS [moh_evt_ethnic_grp6_snz_ind]
INTO [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___moh_clean___pub_fund_hosp_discharges_event]
FROM [IDI_Sandpit].[DL-MAA2023-999].[tmp_moh_event];
GO

/***********************************************************
Loading of input table: hospital discharge diagnoses
***********************************************************/

/* delete prior to creation */
DROP TABLE IF EXISTS [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___moh_clean___pub_fund_hosp_discharges_diag]
GO

/* table loaded into tmp location */
SELECT IIF(["moh_dia_event_id_nbr"] = 'NA', NULL,CAST(["moh_dia_event_id_nbr"] AS INT)) AS [moh_dia_event_id_nbr]
	,IIF(["moh_dia_clinical_sys_code"] = 'NA', NULL,CAST(["moh_dia_clinical_sys_code"] AS INT)) AS [moh_dia_clinical_sys_code]
	,IIF(["moh_dia_submitted_system_code"] = 'NA', NULL,CAST(["moh_dia_submitted_system_code"] AS INT)) AS [moh_dia_submitted_system_code]
	,IIF(["moh_dia_diagnosis_type_code"] = 'NA', NULL,CAST(SUBSTRING(["moh_dia_diagnosis_type_code"], 2, LEN(["moh_dia_diagnosis_type_code"]) - 2) AS CHAR(1))) AS [moh_dia_diagnosis_type_code]
	,IIF(["moh_dia_clinical_code"] = 'NA', NULL,CAST(SUBSTRING(["moh_dia_clinical_code"], 2, LEN(["moh_dia_clinical_code"]) - 2) AS VARCHAR(8))) AS [moh_dia_clinical_code]
	,IIF(["moh_dia_op_date"] = 'NA', NULL,CAST(["moh_dia_op_date"] AS DATE)) AS [moh_dia_op_date]
	,IIF(["moh_dia_op_flag_ind"] = 'NA', NULL,CAST(["moh_dia_op_flag_ind"] AS INT)) AS [moh_dia_op_flag_ind]
INTO [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___moh_clean___pub_fund_hosp_discharges_diag]
FROM [IDI_Sandpit].[DL-MAA2023-999].[tmp_pfhd]
GO

/***********************************************************
Loading of input table: Employer Monthly Summaries (EMS)
***********************************************************/

/* delete prior to creation */
DROP TABLE IF EXISTS [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___ir_clean___ird_ems]
GO

/* table loaded into tmp location */
SELECT IIF(["snz_uid"] = 'NA', NULL,CAST(["snz_uid"] AS INT)) AS [snz_uid]
	,IIF(["snz_ird_uid"] = 'NA', NULL,CAST(["snz_ird_uid"] AS INT)) AS [snz_ird_uid]
	,IIF(["snz_employer_ird_uid"] = 'NA', NULL,CAST(["snz_employer_ird_uid"] AS INT)) AS [snz_employer_ird_uid]
	,IIF(["ir_ems_employer_location_nbr"] = 'NA', NULL,CAST(["ir_ems_employer_location_nbr"] AS INT)) AS [ir_ems_employer_location_nbr]
	,IIF(["ir_ems_return_period_date"] = 'NA', NULL,CAST(SUBSTRING(["ir_ems_return_period_date"], 2, LEN(["ir_ems_return_period_date"]) - 2) AS DATE)) AS [ir_ems_return_period_date]
	,IIF(["ir_ems_line_nbr"] = 'NA', NULL,CAST(["ir_ems_line_nbr"] AS INT)) AS [ir_ems_line_nbr]
	,IIF(["ir_ems_snz_unique_nbr"] = 'NA', NULL,CAST(["ir_ems_snz_unique_nbr"] AS INT)) AS [ir_ems_snz_unique_nbr]
	,IIF(["ir_ems_version_nbr"] = 'NA', NULL,CAST(["ir_ems_version_nbr"] AS INT)) AS [ir_ems_version_nbr]
	,IIF(["ir_ems_doc_lodge_prefix_nbr"] = 'NA', NULL,CAST(["ir_ems_doc_lodge_prefix_nbr"] AS INT)) AS [ir_ems_doc_lodge_prefix_nbr]
	,IIF(["ir_ems_doc_lodge_nbr"] = 'NA', NULL,CAST(["ir_ems_doc_lodge_nbr"] AS INT)) AS [ir_ems_doc_lodge_nbr]
	,IIF(["ir_ems_doc_lodge_suffix_nbr"] = 'NA', NULL,CAST(["ir_ems_doc_lodge_suffix_nbr"] AS INT)) AS [ir_ems_doc_lodge_suffix_nbr]
	,IIF(["ir_ems_gross_earnings_amt"] = 'NA', NULL,CAST(["ir_ems_gross_earnings_amt"] AS DECIMAL(13,2))) AS [ir_ems_gross_earnings_amt]
	,IIF(["ir_ems_gross_earnings_imp_code"] = 'NA', NULL,CAST(["ir_ems_gross_earnings_imp_code"] AS CHAR(1))) AS [ir_ems_gross_earnings_imp_code]
	,IIF(["ir_ems_paye_deductions_amt"] = 'NA', NULL,CAST(["ir_ems_paye_deductions_amt"] AS DECIMAL(13,2))) AS [ir_ems_paye_deductions_amt]
	,IIF(["ir_ems_paye_imp_ind"] = 'NA', NULL,CAST(["ir_ems_paye_imp_ind"] AS CHAR(1))) AS [ir_ems_paye_imp_ind]
	,IIF(["ir_ems_earnings_not_liable_amt"] = 'NA', NULL,CAST(["ir_ems_earnings_not_liable_amt"] AS DECIMAL(13,2))) AS [ir_ems_earnings_not_liable_amt]
	,IIF(["ir_ems_earnings_not_liab_imp_ind"] = 'NA', NULL,CAST(["ir_ems_earnings_not_liab_imp_ind"] AS CHAR(1))) AS [ir_ems_earnings_not_liab_imp_ind]
	,IIF(["ir_ems_fstc_amt"] = 'NA', NULL,CAST(["ir_ems_fstc_amt"] AS DECIMAL(13,2))) AS [ir_ems_fstc_amt]
	,IIF(["ir_ems_sl_amt"] = 'NA', NULL,CAST(["ir_ems_sl_amt"] AS DECIMAL(13,2))) AS [ir_ems_sl_amt]
	,IIF(["ir_ems_return_line_item_code"] = 'NA', NULL,CAST(["ir_ems_return_line_item_code"] AS INT)) AS [ir_ems_return_line_item_code]
	,IIF(["ir_ems_withholding_type_code"] = 'NA', NULL,CAST(SUBSTRING(["ir_ems_withholding_type_code"], 2, LEN(["ir_ems_withholding_type_code"]) - 2) AS CHAR(1))) AS [ir_ems_withholding_type_code]
	,IIF(["ir_ems_income_source_code"] = 'NA', NULL,CAST(SUBSTRING(["ir_ems_income_source_code"], 2, LEN(["ir_ems_income_source_code"]) - 2) AS VARCHAR(5))) AS [ir_ems_income_source_code]
	,IIF(["ir_ems_lump_sum_ind"] = 'NA', NULL,CAST(SUBSTRING(["ir_ems_lump_sum_ind"], 2, LEN(["ir_ems_lump_sum_ind"]) - 2) AS CHAR(1))) AS [ir_ems_lump_sum_ind]
	,IIF(["ir_ems_tax_code"] = 'NA', NULL,CAST(SUBSTRING(["ir_ems_tax_code"], 2, LEN(["ir_ems_tax_code"]) - 2) AS CHAR(1))) AS [ir_ems_tax_code]
	,IIF(["ir_ems_enterprise_nbr"] = 'NA', NULL,CAST(["ir_ems_enterprise_nbr"] AS INT)) AS [ir_ems_enterprise_nbr]
	,IIF(["ir_ems_pbn_nbr"] = 'NA', NULL,CAST(["ir_ems_pbn_nbr"] AS INT)) AS [ir_ems_pbn_nbr]
	,IIF(["ir_ems_pbn_anzsic06_code"] = 'NA', NULL,CAST(SUBSTRING(["ir_ems_pbn_anzsic06_code"], 2, LEN(["ir_ems_pbn_anzsic06_code"]) - 2) AS VARCHAR(12))) AS [ir_ems_pbn_anzsic06_code]
	,IIF(["ir_ems_ent_anzsic06_code"] = 'NA', NULL,CAST(SUBSTRING(["ir_ems_ent_anzsic06_code"], 2, LEN(["ir_ems_ent_anzsic06_code"]) - 2) AS VARCHAR(12))) AS [ir_ems_ent_anzsic06_code]
INTO [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___ir_clean___ird_ems]
FROM [IDI_Sandpit].[DL-MAA2023-999].[tmp_ems];
GO

/***********************************************************
Loading of input table: drivers licence, current
***********************************************************/

/* delete prior to creation */
DROP TABLE IF EXISTS [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___nzta_clean___drivers_licence_register]
GO

/* table loaded into tmp location */
SELECT IIF(["snz_uid"] = 'NA', NULL,CAST(["snz_uid"] AS INT)) AS [snz_uid]
	,IIF(["snz_nzta_uid"] = 'NA', NULL,CAST(["snz_nzta_uid"] AS INT)) AS [snz_nzta_uid]
	,IIF(["nzta_snz_sex_code"] = 'NA', NULL,CAST(["nzta_snz_sex_code"] AS INT)) AS [nzta_snz_sex_code]
	,IIF(["nzta_dlr_birth_month_nbr"] = 'NA', NULL,CAST(["nzta_dlr_birth_month_nbr"] AS INT)) AS [nzta_dlr_birth_month_nbr]
	,IIF(["nzta_dlr_birth_year_nbr"] = 'NA', NULL,CAST(["nzta_dlr_birth_year_nbr"] AS INT)) AS [nzta_dlr_birth_year_nbr]
	,IIF(["nzta_dlr_licence_issue_date"] = 'NA', NULL,CAST(SUBSTRING(["nzta_dlr_licence_issue_date"], 2, LEN(["nzta_dlr_licence_issue_date"]) - 2) AS DATE)) AS [nzta_dlr_licence_issue_date]
	,IIF(["nzta_dlr_organ_donor_ind"] = 'NA', NULL,CAST(SUBSTRING(["nzta_dlr_organ_donor_ind"], 2, LEN(["nzta_dlr_organ_donor_ind"]) - 2) AS CHAR(1))) AS [nzta_dlr_organ_donor_ind]
	,IIF(["nzta_dlr_licence_type_text"] = 'NA', NULL,CAST(SUBSTRING(["nzta_dlr_licence_type_text"], 2, LEN(["nzta_dlr_licence_type_text"]) - 2) AS VARCHAR(15))) AS [nzta_dlr_licence_type_text]
	,IIF(["nzta_dlr_licence_status_text"] = 'NA', NULL,CAST(SUBSTRING(["nzta_dlr_licence_status_text"], 2, LEN(["nzta_dlr_licence_status_text"]) - 2) AS VARCHAR(15))) AS [nzta_dlr_licence_status_text]
	,IIF(["nzta_dlr_lic_class_grant_date"] = 'NA', NULL,CAST(SUBSTRING(["nzta_dlr_lic_class_grant_date"], 2, LEN(["nzta_dlr_lic_class_grant_date"]) - 2) AS DATE)) AS [nzta_dlr_lic_class_grant_date]
	,IIF(["nzta_dlr_licence_start_date"] = 'NA', NULL,CAST(SUBSTRING(["nzta_dlr_licence_start_date"], 2, LEN(["nzta_dlr_licence_start_date"]) - 2) AS DATE)) AS [nzta_dlr_licence_start_date]
	,IIF(["nzta_dlr_licence_from_date"] = 'NA', NULL,CAST(SUBSTRING(["nzta_dlr_licence_from_date"], 2, LEN(["nzta_dlr_licence_from_date"]) - 2) AS DATE)) AS [nzta_dlr_licence_from_date]
	,IIF(["nzta_dlr_class_status_text"] = 'NA', NULL,CAST(SUBSTRING(["nzta_dlr_class_status_text"], 2, LEN(["nzta_dlr_class_status_text"]) - 2) AS VARCHAR(15))) AS [nzta_dlr_class_status_text]
	,IIF(["nzta_dlr_licence_class_text"] = 'NA', NULL,CAST(["nzta_dlr_licence_class_text"] AS VARCHAR(15))) AS [nzta_dlr_licence_class_text]
	,IIF(["nzta_dlr_licence_stage_text"] = 'NA', NULL,CAST(SUBSTRING(["nzta_dlr_licence_stage_text"], 2, LEN(["nzta_dlr_licence_stage_text"]) - 2) AS VARCHAR(15))) AS [nzta_dlr_licence_stage_text]
	,IIF(["nzta_dlr_class_from_date"] = 'NA', NULL,CAST(SUBSTRING(["nzta_dlr_class_from_date"], 2, LEN(["nzta_dlr_class_from_date"]) - 2) AS DATE)) AS [nzta_dlr_class_from_date]
	,IIF(["nzta_dlr_endorsement_type_text"] = 'NA', NULL,CAST(SUBSTRING(["nzta_dlr_endorsement_type_text"], 2, LEN(["nzta_dlr_endorsement_type_text"]) - 2) AS CHAR(1))) AS [nzta_dlr_endorsement_type_text]
	,IIF(["nzta_dlr_region_code"] = 'NA', NULL,CAST(["nzta_dlr_region_code"] AS INT)) AS [nzta_dlr_region_code]
INTO [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___nzta_clean___drivers_licence_register]
FROM [IDI_Sandpit].[DL-MAA2023-999].[tmp_dlr_current];

/***********************************************************
Loading of input table: drivers licence, historic
***********************************************************/

/* delete prior to creation */
DROP TABLE IF EXISTS [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___nzta_clean___dlr_historic]
GO

/* table loaded into tmp location */
SELECT IIF(["snz_uid"] = 'NA', NULL,CAST(["snz_uid"] AS INT)) AS [snz_uid]
	,IIF(["snz_nzta_uid"] = 'NA', NULL,CAST(["snz_nzta_uid"] AS INT)) AS [snz_nzta_uid]
	,IIF(["nzta_snz_sex_code"] = 'NA', NULL,CAST(["nzta_snz_sex_code"] AS INT)) AS [nzta_snz_sex_code]
	,IIF(["nzta_hist_birth_month_nbr"] = 'NA', NULL,CAST(["nzta_hist_birth_month_nbr"] AS INT)) AS [nzta_hist_birth_month_nbr]
	,IIF(["nzta_hist_birth_year_nbr"] = 'NA', NULL,CAST(["nzta_hist_birth_year_nbr"] AS INT)) AS [nzta_hist_birth_year_nbr]
	,IIF(["nzta_hist_licence_type_text"] = 'NA', NULL,CAST(SUBSTRING(["nzta_hist_licence_type_text"], 2, LEN(["nzta_hist_licence_type_text"]) - 2) AS VARCHAR(15))) AS [nzta_hist_licence_type_text]
	,IIF(["nzta_hist_licence_start_date"] = 'NA', NULL,CAST(SUBSTRING(["nzta_hist_licence_start_date"], 2, LEN(["nzta_hist_licence_start_date"]) - 2) AS DATE)) AS [nzta_hist_licence_start_date]
	,IIF(["nzta_hist_licence_class_text"] = 'NA', NULL,CAST(["nzta_hist_licence_class_text"] AS INT)) AS [nzta_hist_licence_class_text]
	,IIF(["nzta_hist_learner_start_date"] = 'NA', NULL,CAST(SUBSTRING(["nzta_hist_learner_start_date"], 2, LEN(["nzta_hist_learner_start_date"]) - 2) AS DATE)) AS [nzta_hist_learner_start_date]
	,IIF(["nzta_hist_restricted_start_date"] = 'NA', NULL,CAST(SUBSTRING(["nzta_hist_restricted_start_date"], 2, LEN(["nzta_hist_restricted_start_date"]) - 2) AS DATE)) AS [nzta_hist_restricted_start_date]
	,IIF(["nzta_hist_full_start_date"] = 'NA', NULL,CAST(SUBSTRING(["nzta_hist_full_start_date"], 2, LEN(["nzta_hist_full_start_date"]) - 2) AS DATE)) AS [nzta_hist_full_start_date]
INTO [IDI_Sandpit].[DL-MAA2023-999].[IDI_Clean___nzta_clean___dlr_historic]
FROM [IDI_Sandpit].[DL-MAA2023-999].[tmp_DLR_history]
GO
