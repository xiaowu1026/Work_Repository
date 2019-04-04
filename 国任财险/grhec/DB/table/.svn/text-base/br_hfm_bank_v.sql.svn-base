create or replace view br_hfm_bank_v as
select bs.code as bank_branch_num,
       bs.name as bank_branch_name,
       bs.bankid as bank_code,
       (select name from t_banks@BRHFM_LINK where urid = bankid) as bank_name,
       bs.standardareaid as area_code,
       (select name
          from t_standardareas@BRHFM_LINK
         where urid = bs.standardareaid) as area_name,
       bs.lastmodifiedon as lastmodifiedon
  from t_banklocations@BRHFM_LINK bs;
