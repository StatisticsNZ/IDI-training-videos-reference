#####################################################################
# Tidy variables in dataset
#
# Context:
# IDI Demonstration project & training videos
# R analysis phase
#
# Inputs / Dependencies:
# - [IDI_Sandpit].[DL-MAA2023-999].[rectangular]
# - helper functions from Dataset Assembly Tool bundle
# 
# Output:
# - [IDI_Sandpit].[DL-MAA2023-999].[tidy]
# 
# Notes:
# 1) Uses randomly generated data
# 2) Uses dbplyr to translate R commands into SQL
# 
# History:
# 2023-06-28 original
# 2023-06-29 new header and notes
#####################################################################

## parameters -------------------------------------------------------

PATH_TO_TOOL = "~//<<<NETWOR-SHARE PATH >>>/2. R approach/Tools/Dataset Assembly Tool"
PATH_FOR_ANALYSIS = "/<<<NETWOR-SHARE PATH >>>/2. R approach/3. Analysis"

SANDPIT = "[IDI_Sandpit]"
USERCODE = "[IDI_UserCode]"
PROJECT_SCHEMA = "[DL-MAA2023-999]"

INPUT = "[rectangular]"
OUTPUT = "[tidy]"

## setup ------------------------------------------------------------

setwd(PATH_TO_TOOL)
source("utility_functions.R")
source("dbplyr_helper_functions.R")
source("table_consistency_checks.R")
source("overview_dataset.R")
source("summary_confidential.R")
setwd(PATH_FOR_ANALYSIS)

## access SQL -------------------------------------------------------

db_con = create_database_connection(database = "IDI_Sandpit")
db_table = create_access_point(db_con, SANDPIT, PROJECT_SCHEMA, INPUT)

# explore_report(db_table, output_file = "rectangular")

## tidy dataset -----------------------------------------------------

tidied_table = db_table %>%
  # year and age
  mutate(
    age_2015 = 2015 - birth_year,
    dead_during_before_2015 = ifelse(!is.na(death_year) & death_year <= 2015, 1, 0)
  ) %>%
  mutate(
    age_group = case_when(
      15 <= age_2015 & age_2015 <= 40 ~ "younger",
      46 <= age_2015 & age_2015 <= 65 ~ "older",
      TRUE ~ "error"
    )
  ) %>%
  
  # income
  mutate(
    income_monthly_equiv = total_income / months_income,
    any_income = ifelse(!is.na(total_income), 1, 0),
    income_quantile = case_when(
      0 < income_monthly_equiv & income_monthly_equiv <= 696 ~ "Q1",
      696 < income_monthly_equiv & income_monthly_equiv <= 922 ~ "Q2",
      922 < income_monthly_equiv & income_monthly_equiv <= 1077 ~ "Q3",
      1077 < income_monthly_equiv ~ "Q4",
      TRUE ~ NA
    )
  ) %>%
  
  # indicator variables
  mutate(
    any_overseas = ifelse(!is.na(days_overseas) & days_overseas > 0, 1, 0),
    any_PEN = ifelse(!is.na(`income_source=PEN`) & `income_source=PEN` > 0, 1, 0),
    any_BEN = ifelse(!is.na(`income_source=BEN`) & `income_source=BEN` > 0, 1, 0),
    any_WAS = ifelse(!is.na(`income_source=WAS`) & `income_source=WAS` > 0, 1, 0),
    any_WHP = ifelse(!is.na(`income_source=WHP`) & `income_source=WHP` > 0, 1, 0),
    any_hospital = ifelse(!is.na(num_hosp_discharge) & num_hosp_discharge > 0, 1, 0),
    
    eth_euro = coalesce(eth_euro, 0),
    eth_maori = coalesce(eth_maori, 0),
    eth_pacific = coalesce(eth_pacific, 0),
    eth_asian = coalesce(eth_asian, 0),
    eth_melaa = coalesce(eth_melaa, 0),
    eth_other = coalesce(eth_other, 0)
  ) %>%
  
  # filter
  filter(
    dead_during_before_2015 == 0,
    age_2015 >= 15,
    age_2015 <= 65,
    age_group != "error"
  ) %>%
  
  # rename
  rename(snz_uid = identity_column) %>%
  
  # remove unwanted columns
  select(
    -label_identity,
    -summary_period_start_date,
    -summary_period_end_date,
    -label_summary_period,
    -birth_month,
    -days_overseas,
    -death_month,
    -`income_source=BEN`,
    -`income_source=PEN`,
    -`income_source=WAS`,
    -`income_source=WHP`,
    -num_hosp_discharge
  )
  
## write for output -------------------------------------------------

saved_table = write_to_database(
  tidied_table,
  db_con,
  SANDPIT,
  PROJECT_SCHEMA,
  OUTPUT,
  OVERWRITE = TRUE
)
create_nonclustered_index(db_con, SANDPIT, PROJECT_SCHEMA, OUTPUT, "snz_uid")
compress_table(db_con, SANDPIT, PROJECT_SCHEMA, OUTPUT)

## conclude ---------------------------------------------------------

explore_report(saved_table, output_file = "tidied")
close_database_connection(db_con)
