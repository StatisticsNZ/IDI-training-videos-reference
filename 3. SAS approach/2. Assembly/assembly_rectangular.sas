/*Create table assemble_table*/

Proc sql;
create table sandpit.assemble_table as

	/*snz_uid from res_pop - r*/
	select r.snz_uid,

	/*Personal table - p*/
	p.snz_gender_code,
	p.snz_birth_year_nbr,
	p.snz_birth_month_nbr,
	p.eth_euro,
	p.eth_maori,
	p.eth_pacific,
	p.eth_asian,
	p.eth_melaa,
	p.eth_other,
	p.snz_deceased_year_nbr,
	p.snz_deceased_month_nbr,
	p.birth_date,
	p.death_date,

	/*IRD ems - i*/
	i.total_2015_income,
	i.num_months_w_income,
	i.any_PEN,
	i.any_BEN,
	i.any_WAS,
	i.any_WHP,
	
	/*from MOH hospital data - h*/
	h.num_hospital_discharges,
	
	/*From overseas - o */
	o.total_days_overseas

FROM defn_res_pop as r 
LEFT JOIN defn_personal_detail as p on r.snz_uid=p.snz_uid
LEFT JOIN defn_ird_monthly as i on r.snz_uid=i.snz_uid
LEFT JOIN defn_num_hospital_discharges as h on r.snz_uid=h.snz_uid
LEFT JOIN defn_days_overseas as o on r.snz_uid=o.snz_uid;
quit;


/*Output to the CSV/excel file*/

ods csv file="/<<<NETWORK-SHARE>>>/3. SAS approach/Documents/assemble_table.csv";
proc print data=assemble_table noobs;
run;

ods csv close;
