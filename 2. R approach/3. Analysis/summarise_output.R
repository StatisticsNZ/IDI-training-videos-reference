#####################################################################
# Output summary tables
#
# Context:
# IDI Demonstration project & training videos
# R output phase
#
# Inputs / Dependencies:
# - [IDI_Sandpit].[DL-MAA2023-999].[tidy]
# - summarise and confidentise functions from Dataset Assembly Tool bundle
# 
# Output:
# - summaries.csv
# - conf_summaries.csv
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
PATH_FOR_ANALYSIS = "~//<<<NETWOR-SHARE PATH >>>/2. R approach/3. Analysis"

SANDPIT = "[IDI_Sandpit]"
USERCODE = "[IDI_UserCode]"
PROJECT_SCHEMA = "[DL-MAA2023-999]"

INPUT = "[tidy]"
OUTPUT_FOLDER = "~/<<<NETWOR-SHARE PATH >>>/2. R approach/4. Output"

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

## create groups ----------------------------------------------------

each_of_these = c("any_hospital", "any_overseas", "income_quantile")

combinations = cross_product_column_names(
  each_of_these,
  always = "age_group"
)

## summaries --------------------------------------------------------

out1 = summarise_and_label_over_lists(
  df = db_table,
  group_by_list = combinations,
  summarise_list = list("income_monthly_equiv"),
  make_distinct = FALSE,
  make_count = TRUE,
  make_sum = TRUE,
  clean = "none"
)

out2 = summarise_and_label_over_lists(
  df = db_table,
  group_by_list = combinations,
  summarise_list = list("snz_uid"),
  make_distinct = FALSE,
  make_count = TRUE,
  make_sum = FALSE,
  clean = "none"
)

summaries = bind_rows(out1, out2)

## confidentialise --------------------------------------------------

confidenalised = confidentialise_results(summaries)

## conclude --------------------------------------------------------

write.csv(summaries, file = file.path(OUTPUT_FOLDER, "summaries.csv"))
write.csv(confidenalised, file = file.path(OUTPUT_FOLDER, "conf_summaries.csv"))

close_database_connection(db_con)
