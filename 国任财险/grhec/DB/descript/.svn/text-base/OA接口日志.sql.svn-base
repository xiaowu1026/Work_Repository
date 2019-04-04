begin
--页面注册
  sys_service_pkg.sys_service_load('modules/sch/SCH113/cux_oa_trans_logs.screen','cux_oa_trans_logs',1,1,0);
  sys_service_pkg.sys_service_load('modules/sch/SCH113/log_detail.screen','log_detail',1,1,0);
  sys_service_pkg.sys_service_load('modules/sch/SCH113/log_detail2.screen','log_detail',1,1,0);

--功能定义
  sys_function_pkg.sys_function_load('SCH113','OA接口日志','INTERFACE_MGR','F','modules/sch/SCH113/cux_oa_trans_logs.screen','110','','ZHS');

--分配页面
  sys_function_service_pkg.load_service('modules/sch/SCH113/cux_oa_trans_logs.screen','modules/sch/SCH113/cux_oa_trans_logs.screen');
  sys_function_service_pkg.load_service('modules/sch/SCH113/cux_oa_trans_logs.screen','modules/sch/SCH113/log_detail.screen');
  sys_function_service_pkg.load_service('modules/sch/SCH113/cux_oa_trans_logs.screen','modules/sch/SCH113/log_detail2.screen');

--分配BM
  sys_register_bm_pkg.register_bm('modules/sch/SCH113/cux_oa_trans_logs.screen','sch.SCH113.cux_oa_trans_logs');
end;
