/*Create table personal detail*/
/*people with unique demographic information*/

Proc sql;
create table defn_personal_detail as 
SELECT snz_uid
      ,case 
when snz_sex_gender_code=1 then 'male'
when snz_sex_gender_code= 2 then 'female'
else  'neither' end as snz_gender_code
      ,snz_birth_year_nbr
      ,snz_birth_month_nbr
      ,snz_ethnicity_grp1_nbr as eth_euro
      ,snz_ethnicity_grp2_nbr as eth_maori
      ,snz_ethnicity_grp3_nbr as eth_pacific
      ,snz_ethnicity_grp4_nbr as eth_asian
      ,snz_ethnicity_grp5_nbr as eth_melaa
      ,snz_ethnicity_grp6_nbr as eth_other
      ,snz_deceased_year_nbr
      ,snz_deceased_month_nbr,
mdy(snz_birth_month_nbr, 15,snz_birth_year_nbr) format date9. as birth_date,
mdy(snz_deceased_month_nbr, 15,snz_deceased_year_nbr) format date9. as death_date
FROM sandpit.personal_detail
where snz_uid is not null
group by snz_uid
having count(*)=1;
quit;
