/*Library*/
libname sandpit ODBC dsn=idi_sandpit_srvprd schema="DL-MAA2023-999";

/*Create table resident population*/
/*people who are resident in 2015*/

proc sql;
create table defn_res_pop as 
select snz_uid,
srp_ref_date
from sandpit.snz_res_pop
where year(srp_ref_date)=2015;
quit;
