alter table bcdl_bank_num add(area_code varchar2(30));
comment on column BCDL_BANK_NUM.area_code
  is '����CDOE';
alter table bcdl_bank_num add(area_name varchar2(200));
comment on column BCDL_BANK_NUM.area_name
  is '��������';
