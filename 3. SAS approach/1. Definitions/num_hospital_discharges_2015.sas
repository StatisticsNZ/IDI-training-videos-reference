/*Number of hospital discharges in 2015*/
/*
- filter to 2015
- one row for each person
*/

/*Create table defn_num_hospital_discharges*/
proc sql;
create table defn_num_hospital_discharges as 
select snz_uid,
count(*) as num_hospital_discharges,
  moh_evt_evst_date,
      moh_evt_even_date
from sandpit.pub_fund_hosp_dis_evnt
where moh_evt_evst_date<='31DEC2015'd and moh_evt_even_date>='01JAN2015'd
group by snz_uid;
quit;
