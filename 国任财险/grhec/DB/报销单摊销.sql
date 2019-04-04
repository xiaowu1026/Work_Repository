--------------------------PKG-----------------------
EXP_REPORT_PKG
exp_report_invoice_import_pkg


-----------------------------------SCRIPT-----------------------------------
BEGIN
	sys_service_pkg.sys_service_load('modules/expm/public/cux_exp_report_lines_assign_return_periods.screen','cux_exp_report_lines_assign_return_periods',1,1,0);
	sys_service_pkg.sys_service_load('modules/expm/public/cux_exp_report_lines_assign_return_periods_execute.svc','cux_exp_report_lines_assign_return_periods_execute',1,1,0);
	sys_service_pkg.sys_service_load('modules/expm/public/cux_exp_report_lines_assign_return_periods_init.svc','cux_exp_report_lines_assign_return_periods_init',1,1,0);
	
	sys_function_service_pkg.load_service('modules/expm/public/exp_report_type_choice.screen','modules/expm/public/cux_exp_report_lines_assign_return_periods.screen');
	sys_function_service_pkg.load_service('modules/expm/public/exp_report_type_choice.screen','modules/expm/public/cux_exp_report_lines_assign_return_periods_execute.svc');
	sys_function_service_pkg.load_service('modules/expm/public/exp_report_type_choice.screen','modules/expm/public/cux_exp_report_lines_assign_return_periods_init.svc');

	sys_register_bm_pkg.register_bm('modules/expm/public/exp_report_type_choice.screen','expm.cux_exp_report_return_periods_tmp_delete');
	sys_register_bm_pkg.register_bm('modules/expm/public/exp_report_type_choice.screen','expm.cux_exp_report_return_periods_tmp_insert');
	sys_register_bm_pkg.register_bm('modules/expm/public/exp_report_type_choice.screen','expm.cux_exp_report_lines_assign_return_periods_execute');
	sys_register_bm_pkg.register_bm('modules/expm/public/exp_report_type_choice.screen','cont.con_contract_return_periods');
	sys_register_bm_pkg.register_bm('modules/expm/public/exp_report_type_choice.screen','expm.cux_exp_report_lines_assign_return_periods_tmp_delete');
	sys_register_bm_pkg.register_bm('modules/expm/public/exp_report_type_choice.screen','expm.cux_exp_report_lines_assign_return_periods_tmp_insert');
	
END ;


-- Create/Recreate indexes 
drop index CON_DOCUMENT_FLOWS_U1;
create unique index CON_DOCUMENT_FLOWS_U1 on CON_DOCUMENT_FLOWS (DOCUMENT_TYPE, DOCUMENT_ID, DOCUMENT_LINE_ID, SOURCE_DOCUMENT_TYPE, SOURCE_DOCUMENT_ID, SOURCE_DOCUMENT_LINE_ID, SOURCE_DOCUMENT_DISTS_ID);