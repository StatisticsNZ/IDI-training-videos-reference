#####################################################################
# Run assembly phase using Dataset Assembly Tool
#
# Context:
# IDI Demonstration project & training videos
# R assembly phase
#
# Inputs / Dependencies:
# - population and period control file
# - measures control file
# - Dataset Assembly Tool bundle
# 
# Output:
# - [IDI_Sandpit].[DL-MAA2023-999].[rectangular]
# 
# Notes:
# 1) Uses randomly generated data
# 2) More of this script is pre-written, we just edited the user controls
# 
# History:
# 2023-06-28 edit of script provided with tool
# 2023-06-29 new header and notes
#####################################################################

## USER CONTROLS START ----------------------------------------------------------------------------

# file paths
ABSOLUTE_PATH_TO_TOOL <- "/<<<NETWOR-SHARE PATH >>>/2. R approach/Tools/Dataset Assembly Tool"
ABSOLUTE_PATH_TO_ANALYSIS <- "~ /<<<NETWOR-SHARE PATH >>>/2. R approach/2. Assembly"
POPULATION_FILE <- "population_and_period.xlsx"
MEASURES_FILE <- "measures.xlsx"

# outputs
OUTPUT_DATABASE <- "[IDI_Sandpit]"
OUTPUT_SCHEMA <- "[DL-MAA2023-999]"
LONG_THIN_TABLE_NAME <- "[assembled_data]"
RECTANGULAR_TABLE_NAME <- "[rectangular]"

OVERWRITE_EXISTING_TABLES <- TRUE # {FALSE will append to LONG_THIN_TABLE but RECTANGULAR_TABLE must not exist}

# controls
DEVELOPMENT_MODE <- FALSE # {TRUE for testing, FALSE for production}
RUN_CHECKS_ONLY <- FALSE # {TRUE for testing inputs without assembly}
INFO_TO_PRINT_TO_CONSOLE <- "details" # {"all", "details", "heading", "none", "default"}

## USER CONTROLS END ------------------------------------------------------------------------------

## setup ------------------------------------------------------------------------------------------

setwd(ABSOLUTE_PATH_TO_TOOL)
source("utility_functions.R")
source("table_consistency_checks.R")
source("dbplyr_helper_functions.R")
source("general_assembly_tool_functions.R")
source("general_assembly_tool.R")

setwd(ABSOLUTE_PATH_TO_ANALYSIS)
VERBOSE <- INFO_TO_PRINT_TO_CONSOLE

## create dataset ---------------------------------------------------------------------------------

try(log_running_of_tool("start"))

# run assembly of long-thin table
general_data_assembly_tool(
  input_population_and_period_table = POPULATION_FILE,
  input_measures_to_assemble_table = MEASURES_FILE,
  output_database = OUTPUT_DATABASE,
  output_schema = OUTPUT_SCHEMA,
  output_table = LONG_THIN_TABLE_NAME,
  control_development_mode = DEVELOPMENT_MODE,
  control_verbose = VERBOSE,
  control_overwrite_output_table = OVERWRITE_EXISTING_TABLES,
  control_run_checks_only = RUN_CHECKS_ONLY,
  control_skip_pre_checks = FALSE
)

if (!RUN_CHECKS_ONLY) {
  #### warn if long-thin table contains duplicates --------------------------------------
  run_time_inform_user("checking for duplicates", context = "details", print_level = VERBOSE)
  column_combination_expecting_uniqueness <- c(
    "identity_column", "label_identity",
    "summary_period_start_date", "summary_period_end_date",
    "label_summary_period", "label_measure"
  )
  db_con <- create_database_connection(database = OUTPUT_DATABASE)
  long_thin_tbl <- create_access_point(db_connection = db_con, OUTPUT_DATABASE, OUTPUT_SCHEMA, tbl_name = LONG_THIN_TABLE_NAME)
  any_duplicates <- !check_all_unique(long_thin_tbl, column_combination_expecting_uniqueness)
  close_database_connection(db_con)
  if (any_duplicates) {
    warning(
      "Duplicate outputs detected in long-thin table. Unexpected output likely.\n",
      "Check input population for duplicates identities.\n",
      "Check measure and summary period labels for duplicates.\n"
    )
  }

  #### pivot to create rectangular research ready table ---------------------------------
  # connect
  db_con <- create_database_connection(database = OUTPUT_DATABASE)
  # compress & index assembled table
  run_time_inform_user("compacting long thin table", context = "heading", print_level = VERBOSE)
  compress_table(db_con, OUTPUT_DATABASE, OUTPUT_SCHEMA, LONG_THIN_TABLE_NAME)
  run_time_inform_user("indexing long thin table", context = "heading", print_level = VERBOSE)
  create_nonclustered_index(db_con, OUTPUT_DATABASE, OUTPUT_SCHEMA, LONG_THIN_TABLE_NAME, "identity_column")
  
  # pivot table
  pivoted_table <- create_access_point(db_connection = db_con, OUTPUT_DATABASE, OUTPUT_SCHEMA, tbl_name = LONG_THIN_TABLE_NAME) %>%
    pivot_table(label_column = "label_measure", value_column = "value_measure")

  run_time_inform_user("pivoting and saving", context = "heading", print_level = VERBOSE)
  written_tbl <- write_to_database(pivoted_table, db_con, OUTPUT_DATABASE, OUTPUT_SCHEMA, RECTANGULAR_TABLE_NAME, OVERWRITE = OVERWRITE_EXISTING_TABLES)

  # tidy
  run_time_inform_user("compacting rectangular table", context = "heading", print_level = VERBOSE)
  compress_table(db_con, OUTPUT_DATABASE, OUTPUT_SCHEMA, RECTANGULAR_TABLE_NAME)
  run_time_inform_user("creating nonclustered index", context = "heading", print_level = VERBOSE)
  create_nonclustered_index(db_con, OUTPUT_DATABASE, OUTPUT_SCHEMA, RECTANGULAR_TABLE_NAME, "identity_column")

  # close connection
  close_database_connection(db_con)
  run_time_inform_user("grand completion", context = "heading", print_level = VERBOSE)
}

try(log_running_of_tool("end"))
