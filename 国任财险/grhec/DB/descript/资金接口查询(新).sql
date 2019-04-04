begin
--页面注册
  sys_service_pkg.sys_service_load('modules/capital/capitalManage/CPMANAGE0010/acp_req_data_maintain_new3.screen','acp_req_data_maintain_new3',1,1,0);

--功能定义
  sys_function_pkg.sys_function_load('CPMANAGE9070','资金接口查询(新)','CAPITAL_MANAGE','F','modules/capital/capitalManage/CPMANAGE0010/acp_req_data_maintain_new3.screen','9070','','ZHS');


--分配页面
  sys_function_service_pkg.load_service('modules/capital/capitalManage/CPMANAGE0010/acp_req_data_maintain_new3.screen','modules/capital/capitalManage/CPMANAGE0010/acp_req_data_maintain_new3.screen');

--分配BM
  sys_register_bm_pkg.register_bm('modules/capital/capitalManage/CPMANAGE0010/acp_req_data_maintain_new3.screen','capital.capitalManage.CPMANAGE9050.acp_req_data_maintain');
  sys_register_bm_pkg.register_bm('modules/capital/capitalManage/CPMANAGE0010/acp_req_data_maintain_new3.screen','capital.capitalManage.CPMANAGE9050.acp_req_data_maintain2');
  sys_register_bm_pkg.register_bm('modules/capital/capitalManage/CPMANAGE0010/acp_req_data_maintain_new3.screen','capital.capitalManage.CPMANAGE9050.acp_req_data_maintain3');
  sys_register_bm_pkg.register_bm('modules/capital/capitalManage/CPMANAGE0010/acp_req_data_maintain_new3.screen','capital.capitalManage.CPMANAGE0010.csh_pay_req_ven_lov');
  sys_register_bm_pkg.register_bm('modules/capital/capitalManage/CPMANAGE0010/acp_req_data_maintain_new3.screen','capital.capitalManage.CPMANAGE0010.csh_pay_req_emp_lov');
end;

