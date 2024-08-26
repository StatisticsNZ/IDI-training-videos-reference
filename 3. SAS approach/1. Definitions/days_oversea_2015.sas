/*create the table which contains number of days people stayed overseas in 2015*/
/*- people depart NZ before 31DEC2015 and return after 01JAN2015*/
/*- we assume that partial overlap in 2015 are trimmed to 2015*/

/*First we create the setup table*/
data setup;
set sandpit.person_overseas_spell (rename=(pos_applied_date=trimmed_start_date pos_ceased_date=trimmed_end_date));
format trimmed_start_date date9.;
format trimmed_end_date date9.;
where trimmed_start_date<='31DEC2015'd and trimmed_end_date>='01JAN2015'd;
if trimmed_start_date<'01JAN2015'd then trimmed_start_date='01JAN2015'd;
if trimmed_end_date>'31DEC2015'd then trimmed_end_date='31DEC2015'd;
keep snz_uid trimmed_start_date trimmed_end_date;
run;

/*Create table defn_days_overseas */
proc sql;
create table defn_days_overseas as
select snz_uid,
sum(intck('day',trimmed_start_date,trimmed_end_date)) as total_days_overseas
from setup
group by snz_uid;
quit;
