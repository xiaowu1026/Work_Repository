--------------------------------TABLE----------------------------------
alter table con_contract_headers  add invoice_sales_amount number ;
comment on  column con_contract_headers.invoice_sales_amount is '不含税金额';

ALTER TABLE CON_DOCUMENT_FLOWS ADD contract_return_period_id NUMBER;
ALTER TABLE CON_DOCUMENT_FLOWS ADD source_document_dists_id NUMBER;
ALTER TABLE CON_DOCUMENT_FLOWS ADD AMOUNT NUMBER;
ALTER TABLE CON_DOCUMENT_FLOWS ADD RELEASE_AMOUNT NUMBER;
comment on column CON_DOCUMENT_FLOWS.contract_return_period_id
  is '关联的合同收益期';
comment on column CON_DOCUMENT_FLOWS.source_document_dists_id
  is '源单据分配行ID';
  comment on column CON_DOCUMENT_FLOWS.amount
  is '关联金额';
comment on column CON_DOCUMENT_FLOWS.release_amount
  is '未核销金额';
  
  
alter table EXP_REPORT_ACCOUNTS add VAT_JE_SOURCE VARCHAR2(30);
alter table EXP_REPORT_ACCOUNTS add TRANSFER_OUT_RATE number;
alter table EXP_REPORT_ACCOUNTS add TRANSFER_OUT_IMPORT_FLAG VARCHAR2(10);
alter table EXP_REPORT_ACCOUNTS add TRANSFER_OUT_ERROR_MESSAGE VARCHAR2(200);





CON_CONTRACT_RETURN_PERIODS
CUX_EXP_REPORT_LINE_PERIOD_TMP
CUX_EXP_REPORT_REF_PERIOD_TMP
CUX_EXP_REPORT_LINE_PERIODS
contract_period_allocation
CON_PREEXTRACT_ACCOUNTS_H
con_preextract_accounts_l
CON_ALLOCATION_TMP
CON_ALLOCATION_ERROR



--------------------------PKG-------------------------
cux_exp_report_pkg
CUX_CON_CONTRACT_PKG
bgt_budget_reserves_pkg
acc_builder_employee_exp_pkg
con_contract_maintenance_pkg
con_allocation_import_pkg


--------------------------SEQUENCE---------------------------------
-- Create sequence 
create sequence CUX_EXP_REPORT_LINE_PERIODS_S
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

create sequence con_contract_return_periods_s
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

create sequence contract_period_allocation_s
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

create sequence con_preextract_accounts_h_s
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

create sequence con_preextract_accounts_l_s
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;















---------------------------------------------SCRIPT----------------------------------------------------------
BEGIN
	sys_service_pkg.sys_service_load('modules/cont/public/con_contract_headers_add_return_period_tab.screen','合同受益期',1,1,0);
	sys_service_pkg.sys_service_load('modules/cont/CON5050/contract_period_allocation.screen','contract_period_allocation',1,1,0);
	sys_service_pkg.sys_service_load('modules/cont/CON5050/contract_period_allocation_save.svc','contract_period_allocation_save',1,1,0);
	sys_service_pkg.sys_service_load('modules/cont/CON5050/contract_period_allocation_batch.screen','contract_period_allocation_batch',1,1,0);
	sys_service_pkg.sys_service_load('modules/cont/CON5050/contract_period_allocation_batch_save.svc','contract_period_allocation_batch_save',1,1,0);
	sys_service_pkg.sys_service_load('modules/cont/CON5080/con_contract_import.screen','con_contract_import',1,1,0);
	sys_service_pkg.sys_service_load('modules/cont/CON5080/con_contract_import_err.screen','con_contract_import_err',1,1,0);
	sys_service_pkg.sys_service_load('modules/cont/CON5080/con_contract_import_upload.screen','con_contract_import_upload',1,1,0);
	sys_service_pkg.sys_service_load('modules/cont/public/con_contract_headers_add_return_period_tab_readonly.screen','合同受益期',1,1,0);
	sys_service_pkg.sys_service_load('modules/cont/CON5050/contract_period_allocation_readonly.screen','合同受益期',1,1,0);
	sys_service_pkg.sys_service_load('modules/cont/CON5050/con_preextract_accounts_detail.screen','con_preextract_accounts_detail',1,1,0);
	
	
	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/public/con_contract_headers_add_return_period_tab.screen');
	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/public/con_contract_headers_add_return_period_tab.screen');
	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/CON5050/contract_period_allocation.screen');
	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/CON5050/contract_period_allocation_save.svc');
	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/CON5050/contract_period_allocation_batch.screen');
	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/CON5050/contract_period_allocation_batch_save.svc');
	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/CON5080/con_contract_import.screen');
	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/CON5080/con_contract_import_err.screen');
	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/CON5080/con_contract_import_upload.screen');
	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/public/con_contract_headers_add_return_period_tab_readonly.screen');
	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/CON5050/contract_period_allocation_readonly.screen');
	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/CON5050/con_preextract_accounts_detail.screen');



	sys_register_bm_pkg.register_bm('modules/cont/public/con_contract_headers.screen','cont.con_contract_headers_add_return_period_execute');
	sys_register_bm_pkg.register_bm('modules/cont/public/con_contract_headers.screen','cont.con_contract_return_periods');
	sys_register_bm_pkg.register_bm('modules/cont/public/con_contract_headers.screen','cont.CON5050.contract_period_allocation');
	sys_register_bm_pkg.register_bm('modules/cont/public/con_contract_headers.screen','expm.exp_expense_item');
	sys_register_bm_pkg.register_bm('modules/cont/public/con_contract_headers.screen','expm.fnd_company_responsibility_centers_lov');
	sys_register_bm_pkg.register_bm('modules/cont/public/con_contract_headers.screen','exp.exp_org_unit');
	sys_register_bm_pkg.register_bm('modules/cont/public/con_contract_headers.screen','cont.CON5050.contract_period_batch_allocation');
	sys_register_bm_pkg.register_bm('modules/cont/public/con_contract_headers.screen','bgt.BGT6100.bgt_journal_import_batch_id');
	sys_register_bm_pkg.register_bm('modules/cont/public/con_contract_headers.screen','bgt.bgt_get_sys_import_head_id');
	sys_register_bm_pkg.register_bm('modules/cont/public/con_contract_headers.screen','cont.CON5080.con_contract_lns_error');
	sys_register_bm_pkg.register_bm('modules/cont/public/con_contract_headers.screen','cont.CON5080.con_contract_lns_tmp');
	sys_register_bm_pkg.register_bm('modules/cont/public/con_contract_headers.screen','cont.con_contract_return_period_combo');
	
		
	sys_service_pkg.sys_service_load('modules/cont/CON5080/con_contract_import.screen','con_contract_import',1,1,0);
	sys_service_pkg.sys_service_load('modules/cont/CON5080/con_contract_import_err.screen','con_contract_import_err',1,1,0);
	sys_service_pkg.sys_service_load('modules/cont/CON5080/con_contract_import_upload.screen','con_contract_import_upload',1,1,0);
	sys_service_pkg.sys_service_load('modules/cont/CON5080/con_contract_import_trans_upload.screen','con_contract_import_upload',1,1,0);
	

	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/CON5080/con_contract_import.screen');
	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/CON5080/con_contract_import_err.screen');
	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/CON5080/con_contract_import_upload.screen');
	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/CON5080/con_contract_import_trans_upload.screen');

	sys_register_bm_pkg.register_bm('modules/cont/public/con_contract_headers.screen','cont.CON5080.con_contract_lns_error');
	sys_register_bm_pkg.register_bm('modules/cont/public/con_contract_headers.screen','cont.CON5080.con_contract_lns_tmp');
	
	
	sys_service_pkg.sys_service_load('modules/cont/CON5060/con_preextract_accounts_list.screen','合同预提凭证',1,1,0);
	sys_service_pkg.sys_service_load('modules/cont/CON5060/con_preextract_accounts_detail.screen','合同预提凭证',1,1,0);
	sys_function_pkg.sys_function_load('CON5060','合同预提凭证查询','CONTRACT','F','modules/cont/CON5060/con_preextract_accounts_list.screen',70,'','ZHS');
	sys_function_pkg.sys_function_load('CON5060','合同预提凭证查询','CONTRACT','F','modules/cont/CON5060/con_preextract_accounts_list.screen',70,'','US');
	sys_function_service_pkg.load_service('modules/cont/CON5060/con_preextract_accounts_list.screen','modules/cont/CON5060/con_preextract_accounts_list.screen');
	sys_function_service_pkg.load_service('modules/cont/CON5060/con_preextract_accounts_list.screen','modules/cont/CON5060/con_preextract_accounts_detail.screen');
	sys_register_bm_pkg.register_bm('modules/cont/CON5060/con_preextract_accounts_list.screen','cont.CON5050.con_preextract_accounts_h');
	sys_register_bm_pkg.register_bm('modules/cont/CON5060/con_preextract_accounts_list.screen','cont.CON5050.con_preextract_accounts_l');
	
	sys_service_pkg.sys_service_load('modules/cont/CON5060/con_preextract_accounts_detail.screen','合同预提凭证',1,1,0);
	sys_service_pkg.sys_service_load('modules/cont/CON5070/con_preextract_accounts_audit_list.screen','合同预提凭证审核',1,1,0);
	sys_function_pkg.sys_function_load('CON5070','合同预提凭证审核','CONTRACT','F','modules/cont/CON5070/con_preextract_accounts_audit_list.screen',80,'','ZHS');
	sys_function_pkg.sys_function_load('CON5070','合同预提凭证审核','CONTRACT','F','modules/cont/CON5070/con_preextract_accounts_audit_list.screen',80,'','US');
	sys_function_service_pkg.load_service('modules/cont/CON5070/con_preextract_accounts_audit_list.screen','modules/cont/CON5060/con_preextract_accounts_detail.screen');
	sys_function_service_pkg.load_service('modules/cont/CON5070/con_preextract_accounts_audit_list.screen','modules/cont/CON5070/con_preextract_accounts_audit_list.screen');
	sys_register_bm_pkg.register_bm('modules/cont/CON5070/con_preextract_accounts_audit_list.screen','cont.CON5050.con_preextract_accounts_h');
	sys_register_bm_pkg.register_bm('modules/cont/CON5070/con_preextract_accounts_audit_list.screen','cont.CON5050.con_preextract_accounts_l');
	
	sys_service_pkg.sys_service_load('modules/cont/CON5050/contract_period_preextract_account.screen','contract_period_preextract_account',1,1,0);
	sys_service_pkg.sys_service_load('modules/cont/public/con_contract_headers_details_query_for_preextract.screen','contract_period_preextract_account',1,1,0);
	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/CON5050/contract_period_preextract_account.screen');
	sys_function_service_pkg.load_service('modules/cont/public/con_contract_headers.screen','modules/cont/public/con_contract_headers_details_query_for_preextract.screen');
	sys_register_bm_pkg.register_bm('modules/cont/CON5050/contract_period_preextract_account.screen','cont.CON5050.con_preextract_accounts_h');
	sys_register_bm_pkg.register_bm('modules/cont/CON5050/contract_period_preextract_account.screen','cont.CON5050.con_preextract_accounts_l');
	
	sys_service_pkg.sys_service_load('modules/cont/public/con_contract_headers_add_return_period_tab_readonly.screen','contract_period_preextract_account',1,1,0);
	
	
	
	
	
	
	
END;