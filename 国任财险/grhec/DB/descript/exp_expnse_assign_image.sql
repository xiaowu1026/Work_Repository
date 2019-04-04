begin
  sys_service_pkg.sys_service_load('modules/expm/EXP1070/exp_expense_assign_image.screen','”∞œÒ∑÷¿‡',1,1,0); 
    sys_register_bm_pkg.register_bm('modules/expm/EXP1070/exp_expense_type.screen','expm.EXP1070.exp_image_types');
  end;
