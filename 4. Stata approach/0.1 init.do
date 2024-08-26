/*****************************************

			INITIALISATION FILE
			
			setting file paths and key macros
			
*********************************************/

clear
set more off
cap log close
macro drop _all

cd "I:\MAA2023-999\4. Stata approach"

adopath ++ "I:\MAA2023-999\4. Stata approach\Resources"

global out = "4. Output"

cap mkdir "$out"

set seed 123
global s = 123

global conf3 = "seed(${s}) base(3)"
global conf0 = "seed($s) base(0)"



***** setting up odbc connection


global LBD_DB ibuldd_clean
global IDI_DB idi_Sandpit


***************************************************************************************************************
* ODBC parameters 
* (shouldn't need to be changed)
***************************************************************************************************************
global LBD_CONN conn("Driver={ODBC Driver 17 for SQL Server}; Trusted_Connection=YES; Server=<insert server name here>, <insert port number here>;Database=$LBD_DB")
global IDI_CONN conn("Driver={ODBC Driver 17 for SQL Server}; Trusted_Connection=YES; Server=<insert server name here>, <insert port number here>;Database=$IDI_DB")


