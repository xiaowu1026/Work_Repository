CREATE OR REPLACE PACKAGE exp_data_load_pkg IS

  -- Author  : zhanglei
  -- Created : 2009-7-20 19:08:44
  -- Purpose : 数据导入

  --EXP1010 部门定义
  PROCEDURE load_org_unit(p_unit_code                  VARCHAR2,
                          p_hr_code                    VARCHAR2,
                          p_description                VARCHAR2,
                          p_company_code               VARCHAR2,
                          p_responsibility_center_code VARCHAR2,
                          p_parent_unit_code           VARCHAR2,
                          p_operate_unit_code          VARCHAR2,
                          --p_chief_position_code      number,
                          p_org_unit_level_code  VARCHAR2,
                          p_enabled_flag         VARCHAR2,
                          p_unit_type_code       VARCHAR2,
                          p_leader_employee_code VARCHAR2);
  --EXP1010 部门定义 -  分配主管岗位
  PROCEDURE load_org_unit_chief_position(p_company_code        VARCHAR2,
                                         p_unit_code           VARCHAR2,
                                         p_chief_position_code VARCHAR2);

  --EXP1020 岗位定义
  PROCEDURE load_org_position(p_company_code         VARCHAR2,
                              p_unit_code            VARCHAR2,
                              p_position_code        VARCHAR2,
                              p_description          VARCHAR2,
                              p_parent_position_code VARCHAR2,
                              p_employee_job_code    VARCHAR2,
                              p_enabled_flag         VARCHAR2);

  --EXP1030 员工级别定义
  PROCEDURE load_employee_level(p_level_series_code    VARCHAR2,
                                p_employee_levels_code VARCHAR2,
                                p_description          VARCHAR2,
                                p_enabled_flag         VARCHAR2);

  --EXP1040 员工职务定义
  PROCEDURE load_employee_job(p_employee_job_code VARCHAR2,
                              p_description       VARCHAR2,
                              p_level_series_code VARCHAR2,
                              p_enabled_flag      VARCHAR2);

  --EXP1050 员工定义
  PROCEDURE load_employee(p_employee_code      VARCHAR2,
                          p_employee_type_code VARCHAR2,
                          p_name               VARCHAR2,
                          p_email              VARCHAR2,
                          p_mobil              VARCHAR2,
                          p_phone              VARCHAR2,
                          p_bank_of_deposit    VARCHAR2,
                          p_bank_account       VARCHAR2,
                          p_enabled_flag       VARCHAR2,
                          p_id_type            VARCHAR2,
                          p_id_code            VARCHAR2,
                          p_notes              VARCHAR2,
                          p_user_name          VARCHAR2);
  --EXP1050 员工分配
  PROCEDURE load_employee_assigns(p_company_code          VARCHAR2,
                                  p_employee_code         VARCHAR2,
                                  p_position_code         VARCHAR2,
                                  p_employee_job_code     VARCHAR2,
                                  p_employee_levels_code  VARCHAR2,
                                  p_primary_position_flag VARCHAR2,
                                  p_enabled_flag          VARCHAR2);

  --EXP1060 员工组定义
  PROCEDURE load_employee_group(p_company_code               VARCHAR2,
                                p_employee_group_code        VARCHAR2,
                                p_description                VARCHAR2,
                                p_responsibility_center_code VARCHAR2,
                                p_enabled_flag               VARCHAR2);

  --EXP1060 员工组 员工分配
  PROCEDURE load_employee_group_assigns(p_company_code        VARCHAR2,
                                        p_employee_group_code VARCHAR2,
                                        p_employee_code       VARCHAR2);

  --EXP4030 帐套级 报销类型
  PROCEDURE load_sob_expense_type(p_set_of_books_code      VARCHAR2,
                                  p_expense_type_code      VARCHAR2,
                                  p_description            VARCHAR2,
                                  p_other_company_use_flag VARCHAR2,
                                  p_enabled_flag           VARCHAR2);

  --EXP4030 帐套级 报销类型  分配费用项目
  PROCEDURE load_sob_expense_type_exp_item(p_set_of_books_code VARCHAR2,
                                           p_expense_type_code VARCHAR2,
                                           p_expense_item_code VARCHAR2,
                                           p_enabled_flag      VARCHAR2);

  --EXP4030 帐套级 报销类型  分配申请项目
  PROCEDURE load_sob_expense_type_req_item(p_set_of_books_code VARCHAR2,
                                           p_expense_type_code VARCHAR2,
                                           p_exp_req_item_code VARCHAR2,
                                           p_enabled_flag      VARCHAR2);

  --EXP1070 报销类型
  PROCEDURE load_expense_type(p_company_code      VARCHAR2,
                              p_expense_type_code VARCHAR2,
                              p_description       VARCHAR2,
                              p_enabled_flag      VARCHAR2);

  --EXP1080 费用对象定义
  PROCEDURE load_expense_object_type(p_company_code             VARCHAR2,
                                     p_expense_object_type_code VARCHAR2,
                                     p_description              VARCHAR2,
                                     p_system_flag              VARCHAR2,
                                     p_expense_object_method    VARCHAR2,
                                     p_enabled_flag             VARCHAR2);
  --EXP1080 费用对象 - 查询语句
  PROCEDURE load_expense_object_sql(p_company_code             VARCHAR2,
                                    p_expense_object_type_code VARCHAR2,
                                    p_sql_query                VARCHAR2,
                                    p_sql_validate             VARCHAR2);

  --EXP1080 费用对象 - 值列表
  PROCEDURE load_expense_object_value(p_company_code             VARCHAR2,
                                      p_expense_object_type_code VARCHAR2,
                                      p_expense_object_code      VARCHAR2,
                                      p_description              VARCHAR2,
                                      p_enabled_flag             VARCHAR2);

  --EXP1100 岗位组定义
  PROCEDURE load_position_group(p_company_code        VARCHAR2,
                                p_position_group_code VARCHAR2,
                                p_description         VARCHAR2,
                                p_enabled_flag        VARCHAR2);
  --EXP1100 岗位组分配
  PROCEDURE load_position_group_assigns(p_company_code        VARCHAR2,
                                        p_position_group_code VARCHAR2,
                                        p_position_code       VARCHAR2);

  --EXP1110 部门组定义
  PROCEDURE load_unit_group(p_company_code    VARCHAR2,
                            p_unit_group_code VARCHAR2,
                            p_description     VARCHAR2,
                            p_enabled_flag    VARCHAR2);
  --EXP1110 部门组分配
  PROCEDURE load_unit_group_assigns(p_company_code    VARCHAR2,
                                    p_unit_group_code VARCHAR2,
                                    p_unit_code       VARCHAR2);

  --EXP1120 部门级别定义
  PROCEDURE load_unit_level(p_org_unit_level_code VARCHAR2,
                            p_description         VARCHAR2,
                            p_enabled_flag        VARCHAR2);

  --EXP1130 费用报销政策定义
  PROCEDURE load_expense_policy(p_priority             VARCHAR2,
                                p_company_level_code   VARCHAR2,
                                p_expense_item_code    VARCHAR2,
                                p_expense_address      VARCHAR2,
                                p_employee_job_code    VARCHAR2,
                                p_position_code        VARCHAR2,
                                p_employee_levels_code VARCHAR2,
                                p_default_flag         VARCHAR2,
                                p_currency_code        VARCHAR2,
                                p_expense_standard     NUMBER,
                                p_upper_limit          NUMBER,
                                p_lower_limit          NUMBER,
                                p_changeable_flag      VARCHAR2,
                                p_start_date           VARCHAR2,
                                p_end_date             VARCHAR2,
                                p_commit_flag          VARCHAR2,
                                p_event_name           VARCHAR2,
                                p_place_type_code      VARCHAR2,
                                p_place_code           VARCHAR2,
                                p_upper_std_event_name VARCHAR2,
                                p_transportation       VARCHAR2 DEFAULT NULL);

  --EXP1140 费用申请政策定义
  PROCEDURE load_req_expense_policy(p_priority             VARCHAR2,
                                    p_company_level_code   VARCHAR2,
                                    p_expense_item_code    VARCHAR2,
                                    p_expense_address      VARCHAR2,
                                    p_employee_job_code    VARCHAR2,
                                    p_position_code        VARCHAR2,
                                    p_employee_levels_code VARCHAR2,
                                    p_default_flag         VARCHAR2,
                                    p_currency_code        VARCHAR2,
                                    p_expense_standard     NUMBER,
                                    p_upper_limit          NUMBER,
                                    p_lower_limit          NUMBER,
                                    p_changeable_flag      VARCHAR2,
                                    p_start_date           VARCHAR2,
                                    p_end_date             VARCHAR2,
                                    p_commit_flag          VARCHAR2,
                                    p_event_name           VARCHAR2,
                                    p_place_type_code      VARCHAR2,
                                    p_place_code           VARCHAR2,
                                    p_upper_std_event_name VARCHAR2,
                                    p_transportation       VARCHAR2 DEFAULT NULL);

  --EXP1200 级别系列定义
  PROCEDURE load_level_series(p_level_series_code VARCHAR2,
                              p_description       VARCHAR2,
                              p_enabled_flag      VARCHAR2);

  --EXP1210 员工类型定义
  PROCEDURE load_employee_type(p_employee_type_code VARCHAR2,
                               p_description        VARCHAR2,
                               p_enabled_flag       VARCHAR2);

  --EXP1900 业务规则定义
  PROCEDURE load_business_rule(p_company_code       VARCHAR2,
                               p_business_rule_code VARCHAR2,
                               p_description        VARCHAR2,
                               p_doc_category       VARCHAR2,
                               p_start_date         VARCHAR2,
                               p_end_date           VARCHAR2);
  --EXP1900 业务规则明细定义
  PROCEDURE load_business_rule_detail(p_company_code             VARCHAR2,
                                      p_business_rule_code       VARCHAR2,
                                      p_rule_parameter           VARCHAR2,
                                      p_and_or                   VARCHAR2,
                                      p_filtrate_method          VARCHAR2,
                                      p_parameter_lower_limit    VARCHAR2,
                                      p_parameter_upper_limit    VARCHAR2,
                                      p_currency_code            VARCHAR2,
                                      p_dimension_code           VARCHAR2,
                                      p_expense_object_type_code VARCHAR2,
                                      p_user_exit_procedure      VARCHAR2,
                                      p_invalid_date             VARCHAR2);
  --EXP1900 业务规则审批顺序定义
  PROCEDURE load_business_rule_appr(p_company_code       VARCHAR2,
                                    p_business_rule_code VARCHAR2,
                                    p_approval_sequence  NUMBER,
                                    p_approver_category  VARCHAR2,
                                    p_approver_code      VARCHAR2,
                                    p_approver_company   VARCHAR2 DEFAULT NULL);

  --EXP1910 业务规则指定
  PROCEDURE load_wf_approval_rule(p_company_code       VARCHAR2,
                                  p_workflow_code      VARCHAR2,
                                  p_node_seq           NUMBER,
                                  p_and_or             VARCHAR2,
                                  p_business_rule_code VARCHAR2);

  --EXP1960 业务工作流指定
  PROCEDURE load_workflow_transaction(p_company_code          VARCHAR2,
                                      p_transaction_category  VARCHAR2,
                                      p_transaction_type_code VARCHAR2,
                                      p_workflow_code         VARCHAR2);

  --EXP2010 费用申请单类型定义
  PROCEDURE load_expense_req_type(p_company_code             VARCHAR2,
                                  p_expense_req_type_code    VARCHAR2,
                                  p_description              VARCHAR2,
                                  p_currency_code            VARCHAR2,
                                  p_expense_report_type_code VARCHAR2,
                                  p_accrued_flag             VARCHAR2,
                                  p_enabled_flag             VARCHAR2,
                                  p_auto_approve_flag        VARCHAR2,
                                  p_auto_audit_flag          VARCHAR2,
                                  p_payment_object           VARCHAR2,
                                  p_one_off_flag             VARCHAR2,
                                  p_tolerance_flag           VARCHAR2,
                                  p_tolerance_range          VARCHAR2,
                                  p_tolerance_ratio          NUMBER,
                                  p_report_name              VARCHAR2,
                                  p_reserve_budget           VARCHAR2,
                                  p_budget_control_enabled   VARCHAR2);
  PROCEDURE load_exp_req_ref_expensetype(p_company_code          VARCHAR2,
                                         p_expense_req_type_code VARCHAR2,
                                         p_expense_type_code     VARCHAR2);
  PROCEDURE load_exp_req_ref_usergroup(p_company_code            VARCHAR2,
                                       p_expense_req_type_code   VARCHAR2,
                                       p_expense_user_group_code VARCHAR2);
  PROCEDURE load_exp_req_ref_objecttype(p_company_code             VARCHAR2,
                                        p_expense_req_type_code    VARCHAR2,
                                        p_expense_object_type_code VARCHAR2,
                                        p_layout_position          VARCHAR2,
                                        p_layout_priority          NUMBER,
                                        p_default_object_code      VARCHAR2,
                                        p_required_flag            VARCHAR2);
  PROCEDURE load_exp_req_ref_dimensions(p_company_code           VARCHAR2,
                                        p_expense_req_type_code  VARCHAR2,
                                        p_dimension_code         VARCHAR2,
                                        p_layout_position        VARCHAR2,
                                        p_layout_priority        NUMBER,
                                        p_default_dim_value_code VARCHAR2);

  --EXP2020 公司级申请项目定义
  PROCEDURE load_req_company_items(p_set_of_books_code VARCHAR2,
                                   p_req_item_code     VARCHAR2,
                                   p_company_code      VARCHAR2,
                                   p_enabled_flag      VARCHAR2);
  --EXP2020 公司级申请项目 - 指定报销类型
  PROCEDURE load_req_items_type(p_company_code      VARCHAR2,
                                p_req_item_code     VARCHAR2,
                                p_expense_type_code VARCHAR2);

  --EXP2030 申请项目定义
  PROCEDURE load_req_items(p_set_of_books_code VARCHAR2,
                           p_req_item_code     VARCHAR2,
                           p_description       VARCHAR2,
                           p_enabled_flag      VARCHAR2,
                           p_budget_org_code   VARCHAR2,
                           p_budget_item_code  VARCHAR2);

  --EXP2110 费用报销单类型定义
  PROCEDURE load_expense_report_type(p_company_code             VARCHAR2,
                                     p_expense_report_type_code VARCHAR2,
                                     p_description              VARCHAR2,
                                     p_currency_code            VARCHAR2,
                                     p_coding_rule              VARCHAR2,
                                     p_enabled_flag             VARCHAR2,
                                     p_auto_approve_flag        VARCHAR2,
                                     p_auto_audit_flag          VARCHAR2,
                                     p_payment_object           VARCHAR2,
                                     p_req_required_flag        VARCHAR2,
                                     p_adjustment_flag          VARCHAR2,
                                     p_report_name              VARCHAR2,
                                     p_payment_flag             VARCHAR2,
                                     p_amortization_flag        VARCHAR2,
                                     p_template_flag            VARCHAR2,
                                     p_reserve_budget           VARCHAR2,
                                     p_budget_control_enabled   VARCHAR2,
                                     p_payment_method_code      VARCHAR2);
  PROCEDURE load_exp_rpt_ref_expensetype(p_company_code             VARCHAR2,
                                         p_expense_report_type_code VARCHAR2,
                                         p_expense_type_code        VARCHAR2);
  PROCEDURE load_exp_rpt_ref_usergroup(p_company_code             VARCHAR2,
                                       p_expense_report_type_code VARCHAR2,
                                       p_expense_user_group_code  VARCHAR2);
  PROCEDURE load_exp_rpt_ref_objecttype(p_company_code             VARCHAR2,
                                        p_expense_report_type_code VARCHAR2,
                                        p_expense_object_type_code VARCHAR2,
                                        p_layout_position          VARCHAR2,
                                        p_layout_priority          NUMBER,
                                        p_default_object_code      VARCHAR2,
                                        p_required_flag            VARCHAR2);
  PROCEDURE load_exp_rpt_ref_dimensions(p_company_code             VARCHAR2,
                                        p_expense_report_type_code VARCHAR2,
                                        p_dimension_code           VARCHAR2,
                                        p_layout_position          VARCHAR2,
                                        p_layout_priority          NUMBER,
                                        p_default_dim_value_code   VARCHAR2);

  --EXP2120 公司级费用项目定义
  PROCEDURE load_expense_company_items(p_set_of_books_code VARCHAR2,
                                       p_expense_item_code VARCHAR2,
                                       p_company_code      VARCHAR2,
                                       p_enabled_flag      VARCHAR2);
  --EXP2120 公司级费用项目 - 指定报销类型
  PROCEDURE load_expense_items_type(p_company_code      VARCHAR2,
                                    p_expense_item_code VARCHAR2,
                                    p_expense_type_code VARCHAR2);
  --EXP2130 费用项目定义
  PROCEDURE load_expense_items(p_set_of_books_code VARCHAR2,
                               p_expense_item_code VARCHAR2,
                               p_description       VARCHAR2,
                               p_currency_code     VARCHAR2,
                               p_standard_price    NUMBER,
                               p_enabled_flag      VARCHAR2,
                               p_req_item_code     VARCHAR2,
                               p_budget_org_code   VARCHAR2,
                               p_budget_item_code  VARCHAR2);

  --EXP2130/EXP2140 单据授权
  PROCEDURE load_document_anthority(p_document_type         VARCHAR2,
                                    p_granted_employee_code VARCHAR2,
                                    p_granted_company_code  VARCHAR2,
                                    p_granted_position_code VARCHAR2,
                                    p_company_code          VARCHAR2,
                                    p_org_unit_code         VARCHAR2,
                                    p_position_code         VARCHAR2,
                                    p_employee_code         VARCHAR2,
                                    p_start_date            VARCHAR2,
                                    p_end_date              VARCHAR2,
                                    p_query_authority       VARCHAR2,
                                    p_maintenance_authority VARCHAR2,
                                    p_view_limit            VARCHAR2);
  --帐套级报销单类型定义
  PROCEDURE load_exp_sob_rep_types(p_company_code             VARCHAR2,
                                   p_set_of_books_code        VARCHAR2,
                                   p_expense_report_type_code VARCHAR2,
                                   p_description              VARCHAR2,
                                   p_document_page_type       VARCHAR2,
                                   p_currency_code            VARCHAR2,
                                   p_coding_rule              VARCHAR2,
                                   p_auto_approve_flag        VARCHAR2,
                                   p_auto_audit_flag          VARCHAR2,
                                   p_payment_object           VARCHAR2,
                                   p_payment_method           NUMBER,
                                   p_req_required_flag        VARCHAR2,
                                   p_adjustment_flag          VARCHAR2,
                                   p_report_name              VARCHAR2,
                                   p_payment_flag             VARCHAR2,
                                   p_amortization_flag        VARCHAR2,
                                   p_enabled_flag             VARCHAR2,
                                   p_template_flag            VARCHAR2,
                                   p_reserve_budget           VARCHAR2,
                                   p_budget_control_enabled   VARCHAR2);
  --帐套级报销单关联报销类型定义
  PROCEDURE load_exp_sob_rep_ref_t(p_set_of_books_code        VARCHAR2,
                                   p_expense_report_type_code VARCHAR2,
                                   p_expense_type_code        VARCHAR2);
  --帐套级报销类型关联帐套级费用项目定义
  PROCEDURE load_exp_sob_rep_ref_object(p_set_of_books_code        VARCHAR2,
                                        p_expense_report_type_code VARCHAR2,
                                        p_expense_object_type_code VARCHAR2,
                                        p_layout_position          VARCHAR2,
                                        p_layout_priority          NUMBER,
                                        p_default_object_code      VARCHAR2,
                                        p_required_flag            VARCHAR2);
  --帐套级报销单关联员工组定义
  PROCEDURE load_exp_sob_user_groups(p_set_of_books_code        VARCHAR2,
                                     p_expense_report_type_code VARCHAR2,
                                     p_expense_user_groups_code VARCHAR2);
  --帐套级申请单类型定义
  PROCEDURE load_exp_sob_req_types(p_set_of_books_code        VARCHAR2,
                                   p_company_code             VARCHAR2,
                                   p_expense_req_type_code    VARCHAR2,
                                   p_description              VARCHAR2,
                                   p_document_page_type       VARCHAR2,
                                   p_currency_code            VARCHAR2,
                                   p_expense_report_type_code VARCHAR2,
                                   p_accrued_flag             VARCHAR2,
                                   p_enabled_flag             VARCHAR2,
                                   p_auto_approve_flag        VARCHAR2,
                                   p_auto_audit_flag          VARCHAR2,
                                   p_payment_object           VARCHAR2,
                                   p_one_off_flag             VARCHAR2,
                                   p_tolerance_flag           VARCHAR2,
                                   p_tolerance_range          VARCHAR2,
                                   p_tolerance_ratio          NUMBER,
                                   p_report_name              VARCHAR2,
                                   p_reserve_budget           VARCHAR2,
                                   p_budget_control_enabled   VARCHAR2,
                                   p_app_documents_icon       VARCHAR2 DEFAULT NULL,
                                   p_mobile_approve           VARCHAR2 DEFAULT 'N',
                                   p_mobile_fill              VARCHAR2 DEFAULT 'N');
  --帐套级申请单关联报销类型定义
  PROCEDURE load_exp_sob_req_ref_t(p_set_of_books_code     VARCHAR2,
                                   p_expense_req_type_code VARCHAR2,
                                   p_expense_type_code     VARCHAR2);
  --帐套级申请类型关联帐套级申请项目定义
  PROCEDURE load_exp_sob_req_object_o(p_set_of_books_code        VARCHAR2,
                                      p_expense_req_type_code    VARCHAR2,
                                      p_expense_object_type_code VARCHAR2,
                                      p_layout_position          VARCHAR2,
                                      p_layout_priority          NUMBER,
                                      p_default_object_code      VARCHAR2,
                                      p_required_flag            VARCHAR2);
  --帐套级申请单关联员工组定义
  PROCEDURE load_set_req_ref_user_g(p_set_of_books_code       VARCHAR2,
                                    p_expense_req_type_code   VARCHAR2,
                                    p_expense_user_group_code VARCHAR2);
  /*--员工分配银行账号
  PROCEDURE load_exp_bank_assigns(p_line_number        NUMBER,
                                  p_employee_code      VARCHAR2,
                                  p_bank_code          VARCHAR2,
                                  p_bank_location      VARCHAR2,
                                  p_province_code      VARCHAR2,
                                  p_region_code        VARCHAR2,
                                  p_account_number     VARCHAR2,
                                  p_account_name       VARCHAR2,
                                  p_notes              VARCHAR2,
                                  p_primary_flag       VARCHAR2,
                                  p_enabled_flag       VARCHAR2,
                                  p_sparticipantbankno VARCHAR2,
                                  p_account_flag       VARCHAR2);*/
  --员工分配银行账号
  PROCEDURE load_exp_bank_assigns(p_line_number    NUMBER,
                                  p_employee_code  VARCHAR2,
                                  p_bank_code      VARCHAR2,
                                  p_bank_location  VARCHAR2,
                                  p_province_code  VARCHAR2,
                                  p_region_code    VARCHAR2,
                                  p_account_number VARCHAR2,
                                  p_account_name   VARCHAR2,
                                  p_notes          VARCHAR2,
                                  p_primary_flag   VARCHAR2,
                                  p_enabled_flag   VARCHAR2);

  --导入费用政策地点

  PROCEDURE load_exp_policy_places(p_place_code       VARCHAR2,
                                   p_description_text VARCHAR2,
                                   p_place_type_code  VARCHAR2);
  --导入部门级维度分配表
  PROCEDURE load_fnd_unit_dim_value_assign(p_company_code         VARCHAR2,
                                           p_unit_code            VARCHAR2,
                                           p_dimension_code       VARCHAR2,
                                           p_dimension_value_code VARCHAR2,
                                           p_default_flag         VARCHAR2);

  --帐套级报销类型定义

  PROCEDURE load_exp_sob_expense_types(p_set_of_books_code        VARCHAR2,
                                       p_expense_type_code        VARCHAR2,
                                       p_expense_type_description VARCHAR2,
                                       p_enabled_flag             VARCHAR2);

  --帐套级报销类型关联费用项目
  PROCEDURE load_sob_expense_items(p_set_of_books_code VARCHAR2,
                                   p_expense_type_code VARCHAR2,
                                   p_expense_item_code VARCHAR2,
                                   p_enabled_flag      VARCHAR);

  -- 帐套级报销类型关联申请项目
  PROCEDURE load_sob_exp_req_items(p_set_of_books_code VARCHAR2,
                                   p_expense_type_code VARCHAR2,
                                   p_exp_req_item_code VARCHAR2,
                                   p_enabled_flag      VARCHAR2);
  --帐套级费用报销单关联付款用途
  PROCEDURE load_sob_report_type_usedes(p_expense_report_type_code VARCHAR2,
                                        p_usedes_code              VARCHAR2,
                                        p_primary_flag             VARCHAR2);
  --帐套级费用报销单关联付款用途 --费用项目
  PROCEDURE load_sob_usedes_ref_expense(p_set_of_books_code        VARCHAR2,
                                        p_expense_report_type_code VARCHAR2,
                                        p_usedes_code              VARCHAR2,
                                        p_expense_item_code        VARCHAR2);
  --部门定义-维度分配
  PROCEDURE load_unit_ref_dimensions(p_company_code           VARCHAR2,
                                     p_unit_code              VARCHAR2,
                                     p_dimension_code         VARCHAR2,
                                     p_default_dim_value_code VARCHAR2);
  --导入员工分配岗位
  PROCEDURE load_employee_assigns_po(p_company_code          VARCHAR2,
                                     p_employee_code         VARCHAR2,
                                     p_position_code         VARCHAR2,
                                     p_employee_levels_code  VARCHAR2,
                                     p_primary_position_flag VARCHAR2,
                                     p_enabled_flag          VARCHAR2);
  --工作台-派工规则
  PROCEDURE load_wbc_dispatch_rule(p_dispatch_rule_code VARCHAR2,
                                   p_description        VARCHAR2,
                                   p_start_date         VARCHAR2,
                                   p_rule_flag          VARCHAR2);
  --add by Qu yuanyuan 导入工作台派工规则明细
  --工作台-派工规则明细
  PROCEDURE load_wbc_rule_details(p_dispatch_rule_code    VARCHAR2,
                                  p_rule_parameter        VARCHAR2,
                                  p_and_or                VARCHAR2,
                                  p_filtrate_method       VARCHAR2,
                                  p_parameter_lower_limit VARCHAR2,
                                  p_parameter_upper_limit VARCHAR2,
                                  p_currency_code         VARCHAR2,
                                  p_invalid_date          VARCHAR2);
  --工作台-共享业务类型分配-取单组
  PROCEDURE load_wbc_dispatch_operater(p_business_type_code     VARCHAR2,
                                       p_business_node_sequence NUMBER,
                                       p_work_team_code         VARCHAR2,
                                       p_employee_code          VARCHAR2,
                                       p_max_quan_per           NUMBER,
                                       p_enabled_flag           VARCHAR2);
  --工作台-共享业务类型分配-取单组关联取单规则
  PROCEDURE load_wbc_dispatch_line(p_business_type_code     VARCHAR2,
                                   p_business_node_sequence NUMBER,
                                   p_work_team_code         VARCHAR2,
                                   p_employee_code          VARCHAR2,
                                   p_dispatch_rule_code     VARCHAR2);

  --银行账号导入
  PROCEDURE load_account_info(p_company_code     VARCHAR2, --公司代码
                              p_bank_account     VARCHAR2, --账号
                              p_account_name     VARCHAR2, --账户名称
                              p_branch_bank      VARCHAR2, --连行号
                              p_segment2         VARCHAR2, --责任中心代码
                              p_segment3         VARCHAR2, --科目
                              p_segment4         VARCHAR2, --明细
                              p_account_property VARCHAR2 -- 账户类型
                              );

  --系统级供应商->公司级供应商
  PROCEDURE load_venders(p_company_code       VARCHAR2,
                         p_vender_type_code   VARCHAR2,
                         p_vender_code        VARCHAR2,
                         p_vender_name        VARCHAR2,
                         p_vender_description VARCHAR2,
                         p_enabled_flag       VARCHAR2);

  --公司级供应商银行账户
  PROCEDURE load_pur_vender_accounts(p_line_number    VARCHAR2,
                                     p_vender_code    VARCHAR2,
                                     p_vender_name    VARCHAR2,
                                     p_bank_code      VARCHAR2,
                                     p_province_name  VARCHAR2,
                                     p_city_name      VARCHAR2,
                                     p_account_number VARCHAR2,
                                     p_account_name   VARCHAR2,
                                     p_notes          VARCHAR2,
                                     p_primary_flag   VARCHAR2,
                                     p_enabled_flag   VARCHAR2);

  -- 加载银行账号
  PROCEDURE load_employee_accounts(p_employee_code      VARCHAR2,
                                   p_bank_location_code VARCHAR2,
                                   p_account_number     VARCHAR2,
                                   p_account_name       VARCHAR2);
  --加载供应商维护供应商
  PROCEDURE load_wlzq_venders(p_vender_code  VARCHAR2,
                              p_company_code VARCHAR2,
                              p_unit_code    VARCHAR2);
  --加载批扣流水规则
  PROCEDURE load_cp_batch_cut_rule(p_description              VARCHAR2,
                                   p_payment_bank_account     VARCHAR2,
                                   p_gather_bank_account      VARCHAR2,
                                   p_gather_bank_account_name VARCHAR2,
                                   p_summary                  VARCHAR2,
                                   p_position_code            VARCHAR2);

  PROCEDURE load_exp_rep_policy(p_priority             VARCHAR2, --优先级
                                p_description          VARCHAR2, --描述
                                p_company_level_code   VARCHAR2, --公司级别代码
                                p_level1_unit_code     VARCHAR2, --一级投行部门代码
                                p_control_type_code    VARCHAR2, --控制类型代码
                                p_req_item_code        VARCHAR2, --费用项目
                                p_place_code           VARCHAR2, --费用发生地代码
                                p_place_type_code      VARCHAR2, --费用发生地类型代码
                                p_transportation       VARCHAR2, --交通工具
                                p_job_code             VARCHAR2, --职务代码
                                p_position_code        VARCHAR2, --岗位代码
                                p_employee_levels_code VARCHAR2, --员工级别
                                p_currency_code        VARCHAR2, --币种 CNY
                                p_expense_standard     NUMBER, --费用标砖
                                p_upper_limit          NUMBER, --费用上限
                                p_lower_limit          NUMBER, --费用下限
                                p_commit_flag          VARCHAR2, --超标准能否提交
                                p_upper_std_event_name VARCHAR2, --超上下限时间
                                p_event_name           VARCHAR2, --超标准时间
                                p_start_date           VARCHAR2, --开始时间
                                p_end_date             VARCHAR2 --结束时间
                                );

  --导入企业未达
  PROCEDURE load_erp_account_check(p_voucher_no      VARCHAR2, --凭证标号
                                   p_voucher_date    VARCHAR2, --凭证日期
                                   p_subject         VARCHAR2, --科目,
                                   p_subjectd_detail VARCHAR2, --科目明细
                                   p_account_number  VARCHAR2, --银行账号
                                   p_account_name    VARCHAR2, --户名
                                   p_debit_amount    NUMBER, --借方金额
                                   p_credit_amount   NUMBER, --贷方金额
                                   p_memo            VARCHAR2 --描述
                                   );
  --给部门分配岗位
  PROCEDURE load_org_position_unit(p_unit_code VARCHAR2,
                                   p_org_name  VARCHAR2);

  --sap功能范围值
  procedure load_gl_account_entry_function(p_commit_items_code varchar2,
                                           p_account_code      varchar2,
                                           p_function_envelop  varchar2);
END exp_data_load_pkg;
/
CREATE OR REPLACE PACKAGE BODY exp_data_load_pkg IS

  g_exists NUMBER;

  PROCEDURE load_org_unit(p_unit_code                  VARCHAR2,
                          p_hr_code                    VARCHAR2,
                          p_description                VARCHAR2,
                          p_company_code               VARCHAR2,
                          p_responsibility_center_code VARCHAR2,
                          p_parent_unit_code           VARCHAR2,
                          p_operate_unit_code          VARCHAR2,
                          --p_chief_position_code      number,
                          p_org_unit_level_code  VARCHAR2,
                          p_enabled_flag         VARCHAR2,
                          p_unit_type_code       VARCHAR2,
                          p_leader_employee_code VARCHAR2) IS
    v_company_id               NUMBER;
    v_responsibility_center_id NUMBER;
    v_parent_unit_id           NUMBER;
    v_operate_unit_id          NUMBER;
    v_chief_position_id        NUMBER;
    v_org_unit_level_id        NUMBER;
    v_unit_type_id             NUMBER;
    v_leader_employee_id       NUMBER;
  BEGIN
  
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    IF p_responsibility_center_code IS NOT NULL THEN
      SELECT a.responsibility_center_id
        INTO v_responsibility_center_id
        FROM fnd_responsibility_centers a
       WHERE a.company_id = v_company_id
         AND a.responsibility_center_code = p_responsibility_center_code;
    END IF;
  
    IF p_parent_unit_code IS NOT NULL THEN
      SELECT a.unit_id
        INTO v_parent_unit_id
        FROM exp_org_unit a
       WHERE a.unit_code = p_parent_unit_code
         AND a.company_id = v_company_id;
    END IF;
  
    IF p_operate_unit_code IS NOT NULL THEN
      SELECT a.operation_unit_id
        INTO v_operate_unit_id
        FROM fnd_operation_units a
       WHERE a.operation_unit_code = p_operate_unit_code
         AND a.company_id = v_company_id;
    END IF;
  
    IF p_leader_employee_code IS NOT NULL THEN
      SELECT e.employee_id
        INTO v_leader_employee_id
        FROM exp_employees e
       WHERE e.employee_code = p_leader_employee_code;
    END IF;
  
    /*if p_chief_position_code is not null then
      select a.position_id
        into v_chief_position_id
        from exp_org_position a
       where a.company_id = v_company_id
         and a.position_code = p_chief_position_code;
    end if;*/
  
    IF p_org_unit_level_code IS NOT NULL THEN
      SELECT a.org_unit_level_id
        INTO v_org_unit_level_id
        FROM exp_org_unit_levels a
       WHERE a.org_unit_level_code = p_org_unit_level_code;
    END IF;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_org_unit a
               WHERE a.company_id = v_company_id
                 AND a.unit_code = p_unit_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    IF p_unit_type_code IS NOT NULL THEN
      SELECT t.unit_type_id
        INTO v_unit_type_id
        FROM exp_org_unit_types t
       WHERE t.unit_type_code = p_unit_type_code;
    END IF;
  
    exp_org_unit_pkg.insert_org_unit(p_unit_code                => p_unit_code,
                                     p_description              => p_description,
                                     p_company_id               => v_company_id,
                                     p_responsibility_center_id => v_responsibility_center_id,
                                     p_parent_unit_id           => v_parent_unit_id,
                                     p_operate_unit_id          => v_operate_unit_id,
                                     p_enabled_flag             => p_enabled_flag,
                                     p_created_by               => 1,
                                     p_chief_position_id        => v_chief_position_id,
                                     p_org_unit_level_id        => v_org_unit_level_id,
                                     p_language_code            => 'ZHS',
                                     p_unit_type_id             => v_unit_type_id,
                                     --add by Qu yuanyuan 添加分管领导
                                     p_leader_employee_id => v_leader_employee_id,
                                     p_hr_code            => p_hr_code);
  END;

  PROCEDURE load_org_unit_chief_position(p_company_code        VARCHAR2,
                                         p_unit_code           VARCHAR2,
                                         p_chief_position_code VARCHAR2) IS
    v_company_id        NUMBER;
    v_unit_id           NUMBER;
    v_chief_position_id NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT a.unit_id
      INTO v_unit_id
      FROM exp_org_unit a
     WHERE a.unit_code = p_unit_code
       AND a.company_id = v_company_id;
  
    SELECT a.position_id
      INTO v_chief_position_id
      FROM exp_org_position a
     WHERE a.company_id = v_company_id
       AND a.position_code = p_chief_position_code;
  
    UPDATE exp_org_unit a
       SET a.chief_position_id = v_chief_position_id
     WHERE a.unit_id = v_unit_id;
  
  END;

  PROCEDURE load_org_position(p_company_code         VARCHAR2,
                              p_unit_code            VARCHAR2,
                              p_position_code        VARCHAR2,
                              p_description          VARCHAR2,
                              p_parent_position_code VARCHAR2,
                              p_employee_job_code    VARCHAR2,
                              p_enabled_flag         VARCHAR2) IS
    v_company_id         NUMBER;
    v_unit_id            NUMBER;
    v_parent_position_id NUMBER;
    v_employee_job_id    NUMBER;
    v_position_id        NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT a.unit_id
      INTO v_unit_id
      FROM exp_org_unit a
     WHERE a.company_id = v_company_id
       AND a.unit_code = p_unit_code;
  
    IF p_parent_position_code IS NOT NULL THEN
      SELECT a.position_id
        INTO v_parent_position_id
        FROM exp_org_position a
       WHERE a.company_id = v_company_id
         AND a.position_code = p_parent_position_code;
    END IF;
  
    IF p_employee_job_code IS NOT NULL THEN
      SELECT a.employee_job_id
        INTO v_employee_job_id
        FROM exp_employee_jobs a
       WHERE a.employee_job_code = p_employee_job_code;
    END IF;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_org_position a
               WHERE a.unit_id = v_unit_id
                 AND a.position_code = p_position_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    exp_org_position_pkg.insert_org_position(p_unit_id            => v_unit_id,
                                             p_position_code      => p_position_code,
                                             p_description        => p_description,
                                             p_parent_position_id => v_parent_position_id,
                                             p_company_id         => v_company_id,
                                             p_enabled_flag       => p_enabled_flag,
                                             p_created_by         => 1,
                                             p_language_code      => 'ZHS',
                                             p_employee_job_id    => v_employee_job_id,
                                             p_position_id        => v_position_id);
  END;

  PROCEDURE load_employee_level(p_level_series_code    VARCHAR2,
                                p_employee_levels_code VARCHAR2,
                                p_description          VARCHAR2,
                                p_enabled_flag         VARCHAR2) IS
    v_level_series_id    NUMBER;
    v_employee_levels_id NUMBER;
  BEGIN
    SELECT a.level_series_id
      INTO v_level_series_id
      FROM exp_level_series a
     WHERE a.level_series_code = p_level_series_code;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_employee_levels a
               WHERE a.level_series_id = v_level_series_id
                 AND a.employee_levels_code = p_employee_levels_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_employee_levels_pkg.insert_exp_employee_levels(p_employee_levels_code => p_employee_levels_code,
                                                       p_description          => p_description,
                                                       p_enabled_flag         => p_enabled_flag,
                                                       p_created_by           => 1,
                                                       p_language_code        => 'ZHS',
                                                       p_level_series_id      => v_level_series_id,
                                                       p_employee_levels_id   => v_employee_levels_id);
  END;

  PROCEDURE load_employee_job(p_employee_job_code VARCHAR2,
                              p_description       VARCHAR2,
                              p_level_series_code VARCHAR2,
                              p_enabled_flag      VARCHAR2) IS
    v_level_series_id NUMBER;
    v_employee_job_id NUMBER;
  BEGIN
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_employee_jobs a
               WHERE a.employee_job_code = p_employee_job_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    IF p_level_series_code IS NOT NULL THEN
      SELECT a.level_series_id
        INTO v_level_series_id
        FROM exp_level_series a
       WHERE a.level_series_code = p_level_series_code;
    END IF;
    exp_employee_jobs_pkg.insert_exp_employee_jobs(p_employee_job_code => p_employee_job_code,
                                                   p_description       => p_description,
                                                   p_enabled_flag      => p_enabled_flag,
                                                   p_created_by        => 1,
                                                   p_level_series_id   => v_level_series_id,
                                                   p_employee_job_id   => v_employee_job_id);
  END;

  PROCEDURE load_employee(p_employee_code      VARCHAR2,
                          p_employee_type_code VARCHAR2,
                          p_name               VARCHAR2,
                          p_email              VARCHAR2,
                          p_mobil              VARCHAR2,
                          p_phone              VARCHAR2,
                          p_bank_of_deposit    VARCHAR2,
                          p_bank_account       VARCHAR2,
                          p_enabled_flag       VARCHAR2,
                          p_id_type            VARCHAR2,
                          p_id_code            VARCHAR2,
                          p_notes              VARCHAR2,
                          p_user_name          VARCHAR2) IS
    v_employee_type_id NUMBER;
    v_employee_id      NUMBER;
    v_user_id          NUMBER;
    v_role_id          NUMBER;
    v_frozen_flag      VARCHAR2(10);
  BEGIN
  
    SELECT a.employee_type_id
      INTO v_employee_type_id
      FROM exp_employee_types a
     WHERE a.employee_type_code = p_employee_type_code;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_employees a
               WHERE a.employee_code = p_employee_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    exp_employees_pkg.insert_employees(p_employee_code    => p_employee_code,
                                       p_name             => p_name,
                                       p_email            => p_email,
                                       p_mobil            => p_mobil,
                                       p_phone            => p_phone,
                                       p_enabled_flag     => p_enabled_flag,
                                       p_created_by       => 1,
                                       p_bank_of_deposit  => p_bank_of_deposit,
                                       p_bank_account     => p_bank_account,
                                       p_employee_type_id => v_employee_type_id,
                                       p_employee_id      => v_employee_id,
                                       p_id_type          => p_id_type,
                                       p_id_code          => p_id_code,
                                       p_notes            => p_notes);
  
    --==============新增员工对应的用户================  add by Shen Jinan 2017.12.16
    --获取冻结标志
    IF p_enabled_flag = 'Y' THEN
      v_frozen_flag := 'N';
    ELSE
      v_frozen_flag := 'Y';
    END IF;
  
    --初始化角色为 报销用户  exp_data_load_pkg
    SELECT role_id
      INTO v_role_id
      FROM sys_role s
     WHERE s.role_code = 'GENERAL_USER';
  
    sys_user_pkg.insert_sys_user(p_user_name               => p_user_name,
                                 p_user_password           => p_user_name,
                                 p_start_date              => to_date(to_char(SYSDATE,
                                                                              'yyyymmdd'),
                                                                      'yyyy/mm/dd'),
                                 p_end_date                => NULL,
                                 p_description             => p_name,
                                 p_password_lifespan_check => 3,
                                 p_password_lifespan       => NULL,
                                 p_employee_id             => v_employee_id,
                                 p_customer_id             => NULL,
                                 p_vender_id               => NULL,
                                 p_frozen_flag             => v_frozen_flag,
                                 p_frozen_date             => NULL,
                                 p_password_start_date     => to_date(to_char(SYSDATE,
                                                                              'yyyymmdd'),
                                                                      'yyyy/mm/dd'),
                                 p_last_updated_by         => -1,
                                 p_created_by              => -1,
                                 p_ip_address              => '10.1.1.1',
                                 p_user_id                 => v_user_id);
  
    /* sys_user_pkg.insert_sys_user_role_groups(p_user_id    => v_user_id,
    p_role_id    => v_role_id,
    p_company_id => v_company_id,
    p_start_date => to_date(to_char(SYSDATE,
                                    'yyyymmdd'),
                            'yyyy/mm/dd'),
    p_end_date   => NULL,
    p_created_by => -1);*/
  
    --==============新增员工对应的用户================ 
  END;

  /*--员工分配银行账号
  PROCEDURE load_exp_bank_assigns(p_line_number        NUMBER,
                                  p_employee_code      VARCHAR2,
                                  p_bank_code          VARCHAR2,
                                  p_bank_location      VARCHAR2,
                                  p_province_code      VARCHAR2,
                                  p_region_code        VARCHAR2,
                                  p_account_number     VARCHAR2,
                                  p_account_name       VARCHAR2,
                                  p_notes              VARCHAR2,
                                  p_primary_flag       VARCHAR2,
                                  p_enabled_flag       VARCHAR2,
                                  p_sparticipantbankno VARCHAR2,
                                  p_account_flag       VARCHAR2) IS
    v_employee_id   NUMBER;
    v_bank_name     VARCHAR2(1000);
    v_province_name VARCHAR2(1000);
    v_city_name     VARCHAR2(1000);
  BEGIN
    SELECT ee.employee_id
      INTO v_employee_id
      FROM exp_employees ee
     WHERE ee.employee_code = upper(p_employee_code);
    SELECT cbv.bank_name
      INTO v_bank_name
      FROM csh_banks_vl cbv
     WHERE cbv.bank_code = p_bank_code;
    BEGIN
      SELECT dv.district_desc
        INTO v_province_name
        FROM exp_policy_districts_vl dv
       WHERE dv.district_code = p_province_code;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    BEGIN
      SELECT fv.description
        INTO v_city_name
        FROM fnd_region_code_vl fv
       WHERE fv.region_code = p_region_code;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    exp_employees_pkg.insert_exp_bank_assigns(p_employee_id        => v_employee_id,
                                              p_line_number        => p_line_number,
                                              p_bank_code          => p_bank_code,
                                              p_bank_name          => v_bank_name,
                                              p_bank_location_code => '',
                                              p_bank_location      => p_bank_location,
                                              p_province_code      => p_province_code,
                                              p_province_name      => v_province_name,
                                              p_city_code          => p_region_code,
                                              p_city_name          => v_city_name,
                                              p_account_number     => p_account_number,
                                              p_account_name       => p_account_name,
                                              p_notes              => p_notes,
                                              p_primary_flag       => p_primary_flag,
                                              p_enabled_flag       => p_enabled_flag,
                                              p_user_id            => 1,
                                              p_sparticipantbankno => p_sparticipantbankno,
                                              p_account_flag       => p_account_flag);
  END;*/

  --员工分配银行账号
  PROCEDURE load_exp_bank_assigns(p_line_number    NUMBER,
                                  p_employee_code  VARCHAR2,
                                  p_bank_code      VARCHAR2,
                                  p_bank_location  VARCHAR2,
                                  p_province_code  VARCHAR2,
                                  p_region_code    VARCHAR2,
                                  p_account_number VARCHAR2,
                                  p_account_name   VARCHAR2,
                                  p_notes          VARCHAR2,
                                  p_primary_flag   VARCHAR2,
                                  p_enabled_flag   VARCHAR2) IS
    v_employee_id   NUMBER;
    v_bank_name     VARCHAR2(1000);
    v_province_name VARCHAR2(1000);
    v_city_name     VARCHAR2(1000);
    v_count         NUMBER;
    v_count1        NUMBER;
    v_primary_flag  VARCHAR2(1000);
  BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM exp_employees ee
     WHERE ee.employee_code = upper(p_employee_code);
    IF v_count = 1 THEN
      SELECT ee.employee_id
        INTO v_employee_id
        FROM exp_employees ee
       WHERE ee.employee_code = upper(p_employee_code);
    
      /*SELECT cbv.bank_name
       INTO v_bank_name
       FROM csh_banks_vl cbv
      WHERE cbv.bank_code = p_bank_code;*/
      BEGIN
        SELECT dv.district_desc
          INTO v_province_name
          FROM exp_policy_districts_vl dv
         WHERE dv.district_code = p_province_code;
      EXCEPTION
        WHEN no_data_found THEN
          NULL;
      END;
      BEGIN
        SELECT fv.description
          INTO v_city_name
          FROM fnd_region_code_vl fv
         WHERE fv.region_code = p_region_code;
      EXCEPTION
        WHEN no_data_found THEN
          NULL;
      END;
    
      SELECT COUNT(1)
        INTO v_count1
        FROM exp_employee_accounts e
       WHERE e.employee_id = v_employee_id
         AND e.primary_flag = 'Y';
    
      IF v_count1 > 0 THEN
        --v_primary_flag := 'N';
        DELETE exp_employee_accounts t WHERE t.employee_id = v_employee_id;
      END IF;
      exp_employees_pkg.insert_exp_bank_assigns(p_employee_id        => v_employee_id,
                                                p_line_number        => p_line_number,
                                                p_bank_code          => p_bank_code,
                                                p_bank_name          => '',
                                                p_bank_location_code => '',
                                                p_bank_location      => p_bank_location,
                                                p_province_code      => '',
                                                p_province_name      => p_province_code,
                                                p_city_code          => '',
                                                p_city_name          => p_region_code,
                                                p_account_number     => p_account_number,
                                                p_account_name       => p_account_name,
                                                p_notes              => p_notes,
                                                p_primary_flag       => p_primary_flag,
                                                p_enabled_flag       => p_enabled_flag,
                                                p_user_id            => 1,
                                                p_sparticipantbankno => '',
                                                p_account_flag       => 20);
    END IF;
  
  END;

  PROCEDURE load_employee_assigns(p_company_code          VARCHAR2,
                                  p_employee_code         VARCHAR2,
                                  p_position_code         VARCHAR2,
                                  p_employee_job_code     VARCHAR2,
                                  p_employee_levels_code  VARCHAR2,
                                  p_primary_position_flag VARCHAR2,
                                  p_enabled_flag          VARCHAR2) IS
    v_company_id          NUMBER;
    v_employee_id         NUMBER;
    v_position_id         NUMBER;
    v_employee_job_id     NUMBER;
    v_employee_levels_id  NUMBER;
    v_level_series_id     NUMBER;
    v_employees_assign_id NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT a.employee_id
      INTO v_employee_id
      FROM exp_employees a
     WHERE a.employee_code = upper(p_employee_code);
  
    SELECT position_id
      INTO v_position_id
      FROM exp_org_position a
     WHERE a.position_code = p_position_code
       AND a.company_id = v_company_id;
  
    IF p_employee_job_code IS NOT NULL THEN
      SELECT a.employee_job_id, a.level_series_id
        INTO v_employee_job_id, v_level_series_id
        FROM exp_employee_jobs a
       WHERE a.employee_job_code = p_employee_job_code;
    END IF;
  
    IF p_employee_levels_code IS NOT NULL THEN
      SELECT a.employee_levels_id
        INTO v_employee_levels_id
        FROM exp_employee_levels a
       WHERE a.employee_levels_code = p_employee_levels_code /*
                                                                                                               AND a.level_series_id = v_level_series_id*/
      ;
    END IF;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_employee_assigns a
               WHERE a.employee_id = v_employee_id
                 AND a.company_id = v_company_id
                 AND a.position_id = v_position_id
                 AND a.employee_job_id = v_employee_job_id
                 AND a.employee_levels_id = v_employee_levels_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_employees_pkg.insert_exp_employee_assigns(p_employee_id           => v_employee_id,
                                                  p_company_id            => v_company_id,
                                                  p_position_id           => v_position_id,
                                                  p_employee_job_id       => v_employee_job_id,
                                                  p_employee_levels_id    => v_employee_levels_id,
                                                  p_primary_position_flag => p_primary_position_flag,
                                                  p_enabled_flag          => p_enabled_flag,
                                                  p_user_id               => 1,
                                                  p_employees_assign_id   => v_employees_assign_id);
  
  END;
  --导入员工分配岗位
  PROCEDURE load_employee_assigns_po(p_company_code          VARCHAR2,
                                     p_employee_code         VARCHAR2,
                                     p_position_code         VARCHAR2,
                                     p_employee_levels_code  VARCHAR2,
                                     p_primary_position_flag VARCHAR2,
                                     p_enabled_flag          VARCHAR2) IS
    v_company_id          NUMBER;
    v_employee_id         NUMBER;
    v_position_id         NUMBER;
    v_employee_job_id     NUMBER;
    v_employee_levels_id  NUMBER;
    v_employees_assign_id NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT a.employee_id
      INTO v_employee_id
      FROM exp_employees a
     WHERE a.employee_code = p_employee_code;
  
    SELECT a.position_id, a.employee_job_id
      INTO v_position_id, v_employee_job_id
      FROM exp_org_position a
     WHERE a.position_code = p_position_code
       AND a.company_id = v_company_id;
  
    IF p_employee_levels_code IS NOT NULL THEN
      SELECT a.employee_levels_id
        INTO v_employee_levels_id
        FROM exp_employee_levels a
       WHERE a.employee_levels_code = p_employee_levels_code;
    END IF;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_employee_assigns a
               WHERE a.employee_id = v_employee_id
                 AND a.company_id = v_company_id
                 AND a.position_id = v_position_id
                 AND a.employee_job_id = v_employee_job_id
                 AND a.employee_levels_id = v_employee_levels_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_employees_pkg.insert_exp_employee_assigns(p_employee_id           => v_employee_id,
                                                  p_company_id            => v_company_id,
                                                  p_position_id           => v_position_id,
                                                  p_employee_job_id       => v_employee_job_id,
                                                  p_employee_levels_id    => v_employee_levels_id,
                                                  p_primary_position_flag => p_primary_position_flag,
                                                  p_enabled_flag          => p_enabled_flag,
                                                  p_user_id               => 1,
                                                  p_employees_assign_id   => v_employees_assign_id);
  
  END load_employee_assigns_po;

  PROCEDURE load_employee_group(p_company_code               VARCHAR2,
                                p_employee_group_code        VARCHAR2,
                                p_description                VARCHAR2,
                                p_responsibility_center_code VARCHAR2,
                                p_enabled_flag               VARCHAR2) IS
    v_company_id               NUMBER;
    v_responsibility_center_id NUMBER;
    v_expense_user_group_id    NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    IF p_responsibility_center_code IS NOT NULL THEN
      SELECT a.responsibility_center_id
        INTO v_responsibility_center_id
        FROM fnd_responsibility_centers a
       WHERE a.company_id = v_company_id
         AND a.responsibility_center_code = p_responsibility_center_code;
    END IF;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_user_group_headers a
               WHERE a.company_id = v_company_id
                 AND a.expense_user_group_code = p_employee_group_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_user_group_pkg.insert_user_group_headers(p_company_id               => v_company_id,
                                                 p_expense_user_group_code  => p_employee_group_code,
                                                 p_description              => p_description,
                                                 p_responsibility_center_id => v_responsibility_center_id,
                                                 p_enabled_flag             => p_enabled_flag,
                                                 p_created_by               => 1,
                                                 p_language_code            => 'ZHS',
                                                 p_expense_user_group_id    => v_expense_user_group_id);
  END;

  PROCEDURE load_employee_group_assigns(p_company_code        VARCHAR2,
                                        p_employee_group_code VARCHAR2,
                                        p_employee_code       VARCHAR2) IS
    v_company_id            NUMBER;
    v_expense_user_group_id NUMBER;
    v_employee_id           NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT a.employee_id
      INTO v_employee_id
      FROM exp_employees a
     WHERE a.employee_code = upper(p_employee_code);
  
    SELECT a.expense_user_group_id
      INTO v_expense_user_group_id
      FROM exp_user_group_headers a
     WHERE a.company_id = v_company_id
       AND a.expense_user_group_code = p_employee_group_code;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_user_group_lines a
               WHERE a.expense_user_group_id = v_expense_user_group_id
                 AND a.employee_id = v_employee_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    exp_user_group_pkg.insert_user_group_lines(p_expense_user_group_id => v_expense_user_group_id,
                                               p_employee_id           => v_employee_id,
                                               p_created_by            => 1);
  END;

  PROCEDURE load_sob_expense_type(p_set_of_books_code      VARCHAR2,
                                  p_expense_type_code      VARCHAR2,
                                  p_description            VARCHAR2,
                                  p_other_company_use_flag VARCHAR2,
                                  p_enabled_flag           VARCHAR2) IS
    v_expense_type_id NUMBER;
    v_set_of_books_id NUMBER;
  BEGIN
    SELECT b.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books b
     WHERE b.set_of_books_code = p_set_of_books_code;
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_sob_expense_types a
               WHERE a.expense_type_code = p_expense_type_code
                 AND a.set_of_books_id = v_set_of_books_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_sob_expense_types_pkg.insert_exp_sob_expense_types(p_set_books_id           => v_set_of_books_id,
                                                           p_expense_type_code      => p_expense_type_code,
                                                           p_description            => p_description,
                                                           p_enabled_flag           => p_enabled_flag,
                                                           p_created_by             => 1,
                                                           p_other_company_use_flag => p_other_company_use_flag,
                                                           p_expense_type_id        => v_expense_type_id);
  END;

  PROCEDURE load_sob_expense_type_exp_item(p_set_of_books_code VARCHAR2,
                                           p_expense_type_code VARCHAR2,
                                           p_expense_item_code VARCHAR2,
                                           p_enabled_flag      VARCHAR2) IS
    v_expense_item_id  NUMBER;
    v_set_of_books_id  NUMBER;
    v_sob_expense_desc VARCHAR2(2000);
  BEGIN
    SELECT b.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books b
     WHERE b.set_of_books_code = p_set_of_books_code;
  
    SELECT a.expense_item_id
      INTO v_expense_item_id
      FROM exp_expense_items a
     WHERE a.expense_item_code = p_expense_item_code
       AND a.set_of_books_id = v_set_of_books_id;
  
    SELECT t.description
      INTO v_sob_expense_desc
      FROM exp_sob_expense_types_vl t
     WHERE t.expense_type_code = p_expense_type_code
       AND t.set_of_books_id = v_set_of_books_id;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_sob_type_expense_items i
               WHERE i.expense_type_code = p_expense_type_code
                 AND i.set_of_books_id = v_set_of_books_id
                 AND i.expense_item_id = v_expense_item_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_sob_expense_types_pkg.insert_sob_expense_items(p_expense_type_code => p_expense_type_code,
                                                       p_expense_item_id   => v_expense_item_id,
                                                       p_set_of_books_id   => v_set_of_books_id,
                                                       p_enabled_flag      => p_enabled_flag,
                                                       p_description       => v_sob_expense_desc,
                                                       p_user_id           => 1);
  END;

  PROCEDURE load_sob_expense_type_req_item(p_set_of_books_code VARCHAR2,
                                           p_expense_type_code VARCHAR2,
                                           p_exp_req_item_code VARCHAR2,
                                           p_enabled_flag      VARCHAR2) IS
    v_req_item_id      NUMBER;
    v_set_of_books_id  NUMBER;
    v_sob_expense_desc VARCHAR2(2000);
  BEGIN
    SELECT b.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books b
     WHERE b.set_of_books_code = p_set_of_books_code;
  
    BEGIN
      SELECT a.req_item_id
        INTO v_req_item_id
        FROM exp_req_items a
       WHERE a.req_item_code = p_exp_req_item_code
         AND a.set_of_books_id = v_set_of_books_id;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    SELECT t.description
      INTO v_sob_expense_desc
      FROM exp_sob_expense_types_vl t
     WHERE t.expense_type_code = p_expense_type_code
       AND t.set_of_books_id = v_set_of_books_id;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_sob_type_req_items i
               WHERE i.expense_type_code = p_expense_type_code
                 AND i.set_of_books_id = v_set_of_books_id
                 AND i.req_item_id = v_req_item_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_sob_expense_types_pkg.insert_sob_exp_req_items(p_expense_type_code => p_expense_type_code,
                                                       p_exp_req_item_id   => v_req_item_id,
                                                       p_set_of_books_id   => v_set_of_books_id,
                                                       p_enabled_flag      => p_enabled_flag,
                                                       p_description       => v_sob_expense_desc,
                                                       p_user_id           => 1);
  END;

  PROCEDURE load_expense_type(p_company_code      VARCHAR2,
                              p_expense_type_code VARCHAR2,
                              p_description       VARCHAR2,
                              p_enabled_flag      VARCHAR2) IS
    v_company_id      NUMBER;
    v_expense_type_id NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_expense_types a
               WHERE a.expense_type_code = p_expense_type_code
                 AND a.company_id = v_company_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_types_pkg.insert_exp_expense_types(p_company_id        => v_company_id,
                                                   p_expense_type_code => p_expense_type_code,
                                                   p_description       => p_description,
                                                   p_enabled_flag      => p_enabled_flag,
                                                   p_created_by        => 1,
                                                   p_last_updated_by   => 1,
                                                   p_expense_type_id   => v_expense_type_id);
  END;

  PROCEDURE load_expense_object_type(p_company_code             VARCHAR2,
                                     p_expense_object_type_code VARCHAR2,
                                     p_description              VARCHAR2,
                                     p_system_flag              VARCHAR2,
                                     p_expense_object_method    VARCHAR2,
                                     p_enabled_flag             VARCHAR2) IS
    v_company_id             NUMBER;
    v_expense_object_type_id NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_expense_object_types a
               WHERE a.expense_object_type_code = p_expense_object_type_code
                 AND a.company_id = v_company_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_object_types_pkg.insert_exp_expense_object_type(p_company_id               => v_company_id,
                                                                p_expense_object_type_code => p_expense_object_type_code,
                                                                p_description              => p_description,
                                                                p_system_flag              => p_system_flag,
                                                                p_expense_object_method    => p_expense_object_method,
                                                                p_sql_query                => NULL,
                                                                p_sql_validate             => NULL,
                                                                p_enabled_flag             => p_enabled_flag,
                                                                p_created_by               => 1,
                                                                p_expense_object_type_id   => v_expense_object_type_id,
                                                                p_language_code            => 'ZHS');
  
  END;

  PROCEDURE load_expense_object_sql(p_company_code             VARCHAR2,
                                    p_expense_object_type_code VARCHAR2,
                                    p_sql_query                VARCHAR2,
                                    p_sql_validate             VARCHAR2) IS
    v_expense_object_type_id NUMBER;
    v_company_id             NUMBER;
  BEGIN
  
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT a.expense_object_type_id
      INTO v_expense_object_type_id
      FROM exp_expense_object_types a
     WHERE a.company_id = v_company_id
       AND a.expense_object_type_code = p_expense_object_type_code;
  
    exp_expense_object_types_pkg.update_exp_expense_object_type(p_expense_object_type_id => v_expense_object_type_id,
                                                                p_sql_query              => p_sql_query,
                                                                p_sql_validate           => p_sql_validate,
                                                                p_last_updated_by        => 1);
  END;

  PROCEDURE load_expense_object_value(p_company_code             VARCHAR2,
                                      p_expense_object_type_code VARCHAR2,
                                      p_expense_object_code      VARCHAR2,
                                      p_description              VARCHAR2,
                                      p_enabled_flag             VARCHAR2) IS
    v_expense_object_type_id NUMBER;
    v_company_id             NUMBER;
    v_expense_object_id      NUMBER;
  BEGIN
  
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT a.expense_object_type_id
      INTO v_expense_object_type_id
      FROM exp_expense_object_types a
     WHERE a.company_id = v_company_id
       AND a.expense_object_type_code = p_expense_object_type_code;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_expense_object_values a
               WHERE a.expense_object_type_id = v_expense_object_type_id
                 AND a.expense_object_code = p_expense_object_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_object_types_pkg.insert_expense_object_values(p_expense_object_type_id => v_expense_object_type_id,
                                                              p_expense_object_code    => p_expense_object_code,
                                                              p_description            => p_description,
                                                              p_enabled_flag           => p_enabled_flag,
                                                              p_created_by             => 1,
                                                              p_expense_object_id      => v_expense_object_id);
  END;

  PROCEDURE load_position_group(p_company_code        VARCHAR2,
                                p_position_group_code VARCHAR2,
                                p_description         VARCHAR2,
                                p_enabled_flag        VARCHAR2) IS
    v_company_id        NUMBER;
    v_position_group_id NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_position_groups a
               WHERE a.position_group_code = p_position_group_code
                 AND a.company_id = v_company_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_position_groups_pkg.insert_position_groups_h(p_position_group_code => p_position_group_code,
                                                     p_description         => p_description,
                                                     p_company_id          => v_company_id,
                                                     p_enabled_flag        => p_enabled_flag,
                                                     p_created_by          => 1,
                                                     p_language_code       => 'ZHS',
                                                     p_position_group_id   => v_position_group_id);
  END;

  PROCEDURE load_position_group_assigns(p_company_code        VARCHAR2,
                                        p_position_group_code VARCHAR2,
                                        p_position_code       VARCHAR2) IS
    v_company_id        NUMBER;
    v_position_group_id NUMBER;
    v_position_id       NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT position_group_id
      INTO v_position_group_id
      FROM exp_position_groups a
     WHERE a.company_id = v_company_id
       AND a.position_group_code = p_position_group_code;
  
    SELECT position_id
      INTO v_position_id
      FROM exp_org_position a
     WHERE a.company_id = v_company_id
       AND a.position_code = p_position_code;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_position_group_relations a
               WHERE a.position_group_id = v_position_group_id
                 AND a.position_id = v_position_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_position_groups_pkg.insert_position_group_l(p_position_group_id => v_position_group_id,
                                                    p_position_id       => v_position_id,
                                                    p_created_by        => 1);
  END;

  PROCEDURE load_unit_group(p_company_code    VARCHAR2,
                            p_unit_group_code VARCHAR2,
                            p_description     VARCHAR2,
                            p_enabled_flag    VARCHAR2) IS
    v_company_id    NUMBER;
    v_unit_group_id NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_org_unit_groups a
               WHERE a.unit_group_code = p_unit_group_code
                 AND a.company_id = v_company_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    exp_org_unit_groups_pkg.insert_unit_groups_h(p_unit_group_code => p_unit_group_code,
                                                 p_description     => p_description,
                                                 p_company_id      => v_company_id,
                                                 p_enabled_flag    => p_enabled_flag,
                                                 p_created_by      => 1,
                                                 p_language_code   => 'ZHS',
                                                 p_unit_group_id   => v_unit_group_id);
  END;

  PROCEDURE load_unit_group_assigns(p_company_code    VARCHAR2,
                                    p_unit_group_code VARCHAR2,
                                    p_unit_code       VARCHAR2) IS
    v_company_id    NUMBER;
    v_unit_group_id NUMBER;
    v_unit_id       NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT unit_group_id
      INTO v_unit_group_id
      FROM exp_org_unit_groups a
     WHERE a.company_id = v_company_id
       AND a.unit_group_code = p_unit_group_code;
  
    SELECT unit_id
      INTO v_unit_id
      FROM exp_org_unit a
     WHERE a.company_id = v_company_id
       AND a.unit_code = p_unit_code;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_unit_group_relations a
               WHERE a.unit_group_id = v_unit_group_id
                 AND a.unit_id = v_unit_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    exp_org_unit_groups_pkg.insert_unit_groups_l(p_unit_group_id => v_unit_group_id,
                                                 p_unit_id       => v_unit_id,
                                                 p_created_by    => 1);
  END;

  PROCEDURE load_unit_level(p_org_unit_level_code VARCHAR2,
                            p_description         VARCHAR2,
                            p_enabled_flag        VARCHAR2) IS
    v_org_unit_level_id NUMBER;
  BEGIN
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_org_unit_levels a
               WHERE a.org_unit_level_code = p_org_unit_level_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_org_unit_level_pkg.insert_exp_org_unit_levels(p_org_unit_level_code => p_org_unit_level_code,
                                                      p_description         => p_description,
                                                      p_enabled_flag        => p_enabled_flag,
                                                      p_created_by          => 1,
                                                      p_org_unit_level_id   => v_org_unit_level_id);
  END;

  PROCEDURE load_expense_policy(p_priority             VARCHAR2,
                                p_company_level_code   VARCHAR2,
                                p_expense_item_code    VARCHAR2,
                                p_expense_address      VARCHAR2,
                                p_employee_job_code    VARCHAR2,
                                p_position_code        VARCHAR2,
                                p_employee_levels_code VARCHAR2,
                                p_default_flag         VARCHAR2,
                                p_currency_code        VARCHAR2,
                                p_expense_standard     NUMBER,
                                p_upper_limit          NUMBER,
                                p_lower_limit          NUMBER,
                                p_changeable_flag      VARCHAR2,
                                p_start_date           VARCHAR2,
                                p_end_date             VARCHAR2,
                                p_commit_flag          VARCHAR2,
                                p_event_name           VARCHAR2,
                                p_place_type_code      VARCHAR2,
                                p_place_code           VARCHAR2,
                                p_upper_std_event_name VARCHAR2,
                                p_transportation       VARCHAR2 DEFAULT NULL) IS
    v_company_level_id    NUMBER;
    v_expense_item_id     NUMBER;
    v_job_id              NUMBER;
    v_position_id         NUMBER;
    v_employee_levels_id  NUMBER;
    v_expense_policies_id NUMBER;
    v_place_type_id       NUMBER;
    v_place_id            NUMBER;
  BEGIN
    IF p_company_level_code IS NOT NULL THEN
      SELECT company_level_id
        INTO v_company_level_id
        FROM fnd_company_levels a
       WHERE a.company_level_code = p_company_level_code;
    END IF;
  
    IF p_expense_item_code IS NOT NULL THEN
      SELECT expense_item_id
        INTO v_expense_item_id
        FROM exp_expense_items a
       WHERE a.expense_item_code = p_expense_item_code;
    END IF;
  
    IF p_employee_job_code IS NOT NULL THEN
      SELECT a.employee_job_id
        INTO v_job_id
        FROM exp_employee_jobs a
       WHERE a.employee_job_code = p_employee_job_code;
    END IF;
  
    IF p_position_code IS NOT NULL THEN
      SELECT a.position_id
        INTO v_position_id
        FROM exp_org_position a
       WHERE a.position_code = p_position_code;
    END IF;
  
    IF p_employee_levels_code IS NOT NULL THEN
      SELECT employee_levels_id
        INTO v_employee_levels_id
        FROM exp_employee_levels a
       WHERE a.employee_levels_code = p_employee_levels_code;
    END IF;
  
    IF p_place_type_code IS NOT NULL THEN
      SELECT t.place_type_id
        INTO v_place_type_id
        FROM exp_policy_place_types t
       WHERE t.place_type_code = p_place_type_code;
    END IF;
  
    IF p_place_code IS NOT NULL THEN
      SELECT t.place_id
        INTO v_place_id
        FROM exp_policy_places t
       WHERE t.place_code = p_place_code;
    END IF;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_expense_policies a
               WHERE a.priority = p_priority);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_policies_pkg.insert_exp_expense_policies(p_priority             => p_priority,
                                                         p_company_level_id     => v_company_level_id,
                                                         p_expense_item_id      => v_expense_item_id,
                                                         p_expense_address      => p_expense_address,
                                                         p_job_id               => v_job_id,
                                                         p_position_id          => v_position_id,
                                                         p_employee_levels_id   => v_employee_levels_id,
                                                         p_default_flag         => p_default_flag,
                                                         p_currency_code        => p_currency_code,
                                                         p_expense_standard     => p_expense_standard,
                                                         p_upper_limit          => p_upper_limit,
                                                         p_lower_limit          => p_lower_limit,
                                                         p_changeable_flag      => p_changeable_flag,
                                                         p_start_date           => to_date(p_start_date,
                                                                                           'YYYY-MM-DD'),
                                                         p_end_date             => to_date(p_end_date,
                                                                                           'YYYY-MM-DD'),
                                                         p_commit_flag          => p_commit_flag,
                                                         p_event_name           => p_event_name,
                                                         p_user_id              => 1,
                                                         p_expense_policies_id  => v_expense_policies_id,
                                                         p_place_type_id        => v_place_type_id,
                                                         p_place_id             => v_place_id,
                                                         p_upper_std_event_name => p_upper_std_event_name,
                                                         p_transportation       => p_transportation);
  END;

  PROCEDURE load_req_expense_policy(p_priority             VARCHAR2,
                                    p_company_level_code   VARCHAR2,
                                    p_expense_item_code    VARCHAR2,
                                    p_expense_address      VARCHAR2,
                                    p_employee_job_code    VARCHAR2,
                                    p_position_code        VARCHAR2,
                                    p_employee_levels_code VARCHAR2,
                                    p_default_flag         VARCHAR2,
                                    p_currency_code        VARCHAR2,
                                    p_expense_standard     NUMBER,
                                    p_upper_limit          NUMBER,
                                    p_lower_limit          NUMBER,
                                    p_changeable_flag      VARCHAR2,
                                    p_start_date           VARCHAR2,
                                    p_end_date             VARCHAR2,
                                    p_commit_flag          VARCHAR2,
                                    p_event_name           VARCHAR2,
                                    p_place_type_code      VARCHAR2,
                                    p_place_code           VARCHAR2,
                                    p_upper_std_event_name VARCHAR2,
                                    p_transportation       VARCHAR2 DEFAULT NULL) IS
    v_company_level_id    NUMBER;
    v_req_item_id         NUMBER;
    v_job_id              NUMBER;
    v_position_id         NUMBER;
    v_employee_levels_id  NUMBER;
    v_expense_policies_id NUMBER;
    v_place_type_id       NUMBER;
    v_place_id            NUMBER;
  BEGIN
    IF p_company_level_code IS NOT NULL THEN
      SELECT company_level_id
        INTO v_company_level_id
        FROM fnd_company_levels a
       WHERE a.company_level_code = p_company_level_code;
    END IF;
  
    IF p_expense_item_code IS NOT NULL THEN
      SELECT expense_item_id
        INTO v_req_item_id
        FROM exp_expense_items a
       WHERE a.expense_item_code = p_expense_item_code;
    END IF;
  
    IF p_employee_job_code IS NOT NULL THEN
      SELECT a.employee_job_id
        INTO v_job_id
        FROM exp_employee_jobs a
       WHERE a.employee_job_code = p_employee_job_code;
    END IF;
  
    IF p_position_code IS NOT NULL THEN
      SELECT a.position_id
        INTO v_position_id
        FROM exp_org_position a
       WHERE a.position_code = p_position_code;
    END IF;
  
    IF p_employee_levels_code IS NOT NULL THEN
      SELECT employee_levels_id
        INTO v_employee_levels_id
        FROM exp_employee_levels a
       WHERE a.employee_levels_code = p_employee_levels_code;
    END IF;
  
    IF p_place_type_code IS NOT NULL THEN
      SELECT t.place_type_id
        INTO v_place_type_id
        FROM exp_policy_place_types t
       WHERE t.place_type_code = p_place_type_code;
    END IF;
  
    IF p_place_code IS NOT NULL THEN
      SELECT t.place_id
        INTO v_place_id
        FROM exp_policy_places t
       WHERE t.place_code = p_place_code;
    END IF;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_req_expense_policies a
               WHERE a.priority = p_priority);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_req_exp_policies_pkg.insert_exp_req_exp_policies(p_priority             => p_priority,
                                                         p_company_level_id     => v_company_level_id,
                                                         p_req_item_id          => v_req_item_id,
                                                         p_expense_address      => p_expense_address,
                                                         p_job_id               => v_job_id,
                                                         p_position_id          => v_position_id,
                                                         p_employee_levels_id   => v_employee_levels_id,
                                                         p_default_flag         => p_default_flag,
                                                         p_currency_code        => p_currency_code,
                                                         p_expense_standard     => p_expense_standard,
                                                         p_upper_limit          => p_upper_limit,
                                                         p_lower_limit          => p_lower_limit,
                                                         p_changeable_flag      => p_changeable_flag,
                                                         p_start_date           => to_date(p_start_date,
                                                                                           'YYYY-MM-DD'),
                                                         p_end_date             => to_date(p_end_date,
                                                                                           'YYYY-MM-DD'),
                                                         p_commit_flag          => p_commit_flag,
                                                         p_event_name           => p_event_name,
                                                         p_user_id              => 1,
                                                         p_expense_policies_id  => v_expense_policies_id,
                                                         p_place_type_id        => v_place_type_id,
                                                         p_place_id             => v_place_id,
                                                         p_upper_std_event_name => p_upper_std_event_name,
                                                         p_transportation       => p_transportation);
  
  END;

  PROCEDURE load_level_series(p_level_series_code VARCHAR2,
                              p_description       VARCHAR2,
                              p_enabled_flag      VARCHAR2) IS
    v_level_series_id NUMBER;
  BEGIN
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_level_series a
               WHERE a.level_series_code = p_level_series_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    exp_level_series_pkg.insert_exp_level_series(p_level_series_code => p_level_series_code,
                                                 p_description       => p_description,
                                                 p_enabled_flag      => p_enabled_flag,
                                                 p_created_by        => 1,
                                                 p_level_series_id   => v_level_series_id);
  END;

  PROCEDURE load_employee_type(p_employee_type_code VARCHAR2,
                               p_description        VARCHAR2,
                               p_enabled_flag       VARCHAR2) IS
    v_employee_type_id NUMBER;
  BEGIN
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_employee_levels a
               WHERE a.employee_levels_code = p_employee_type_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    exp_employee_types_pkg.insert_exp_employee_types(p_employee_type_code => p_employee_type_code,
                                                     p_description        => p_description,
                                                     p_enabled_flag       => p_enabled_flag,
                                                     p_created_by         => 1,
                                                     p_employee_type_id   => v_employee_type_id,
                                                     p_language_code      => 'ZHS');
  END;

  PROCEDURE load_business_rule(p_company_code       VARCHAR2,
                               p_business_rule_code VARCHAR2,
                               p_description        VARCHAR2,
                               p_doc_category       VARCHAR2,
                               p_start_date         VARCHAR2,
                               p_end_date           VARCHAR2) IS
    v_company_id NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_business_rules a
               WHERE a.company_id = v_company_id
                 AND a.business_rule_code = p_business_rule_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_business_rule_pkg.insert_exp_business_rule(p_business_rule_code => p_business_rule_code,
                                                   p_description        => p_description,
                                                   p_company_id         => v_company_id,
                                                   p_doc_category       => p_doc_category,
                                                   p_start_date         => to_date(p_start_date,
                                                                                   'YYYY-MM-DD'),
                                                   p_end_date           => to_date(p_end_date,
                                                                                   'YYYY-MM-DD'),
                                                   p_user_id            => 1,
                                                   p_function_code      => 'EXP1900');
  END;

  PROCEDURE load_business_rule_detail(p_company_code             VARCHAR2,
                                      p_business_rule_code       VARCHAR2,
                                      p_rule_parameter           VARCHAR2,
                                      p_and_or                   VARCHAR2,
                                      p_filtrate_method          VARCHAR2,
                                      p_parameter_lower_limit    VARCHAR2,
                                      p_parameter_upper_limit    VARCHAR2,
                                      p_currency_code            VARCHAR2,
                                      p_dimension_code           VARCHAR2,
                                      p_expense_object_type_code VARCHAR2,
                                      p_user_exit_procedure      VARCHAR2,
                                      p_invalid_date             VARCHAR2) IS
    v_business_rule_id       NUMBER;
    v_company_id             NUMBER;
    v_dimension_id           NUMBER;
    v_expense_object_type_id NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
    SELECT business_rule_id
      INTO v_business_rule_id
      FROM exp_business_rules a
     WHERE a.business_rule_code = upper(p_business_rule_code)
       AND a.company_id = v_company_id;
  
    IF p_dimension_code IS NOT NULL THEN
      SELECT a.dimension_id
        INTO v_dimension_id
        FROM fnd_dimensions a
       WHERE a.dimension_code = p_dimension_code;
    END IF;
  
    IF p_expense_object_type_code IS NOT NULL THEN
      SELECT a.expense_object_type_id
        INTO v_expense_object_type_id
        FROM exp_expense_object_types a
       WHERE a.expense_object_type_code = p_expense_object_type_code
         AND a.company_id = v_company_id;
    END IF;
  
    exp_business_rule_pkg.insert_exp_business_rule_dtl(p_business_rule_id       => v_business_rule_id,
                                                       p_rule_parameter         => p_rule_parameter,
                                                       p_and_or                 => p_and_or,
                                                       p_filtrate_method        => p_filtrate_method,
                                                       p_parameter_lower_limit  => p_parameter_lower_limit,
                                                       p_parameter_upper_limit  => p_parameter_upper_limit,
                                                       p_currency_code          => p_currency_code,
                                                       p_dimension_id           => v_dimension_id,
                                                       p_expense_object_type_id => v_expense_object_type_id,
                                                       p_user_exit_procedure    => p_user_exit_procedure,
                                                       p_invalid_date           => to_date(p_invalid_date,
                                                                                           'YYYY-MM-DD'),
                                                       p_user_id                => 1);
  END;

  PROCEDURE load_business_rule_appr(p_company_code       VARCHAR2,
                                    p_business_rule_code VARCHAR2,
                                    p_approval_sequence  NUMBER,
                                    p_approver_category  VARCHAR2,
                                    p_approver_code      VARCHAR2,
                                    p_approver_company   VARCHAR2 DEFAULT NULL --跨公司岗位，需要输入公司+岗位
                                    ) IS
    v_business_rule_id NUMBER;
    v_company_id       NUMBER;
    v_approver_id      NUMBER;
  
    v_approver_company_id NUMBER;
  
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
    SELECT business_rule_id
      INTO v_business_rule_id
      FROM exp_business_rules a
     WHERE a.business_rule_code = upper(p_business_rule_code)
       AND a.company_id = v_company_id;
  
    IF p_approver_company IS NULL THEN
      SELECT position_id
        INTO v_approver_id
        FROM exp_org_position
       WHERE position_code = p_approver_code;
    ELSE
      SELECT company_id
        INTO v_approver_company_id
        FROM fnd_companies
       WHERE company_code = p_approver_company;
    
      SELECT position_id
        INTO v_approver_id
        FROM exp_org_position
       WHERE position_code = p_approver_code
         AND company_id = v_approver_company_id;
    END IF;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_wf_bus_rule_approvers a
               WHERE a.business_rule_id = v_business_rule_id
                 AND a.approval_sequence = p_approval_sequence
                 AND a.approver_category = p_approver_category
                 AND a.approver_id = v_approver_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_business_rule_pkg.insert_exp_wf_bus_rule_appr(p_business_rule_id  => v_business_rule_id,
                                                      p_approval_sequence => p_approval_sequence,
                                                      p_approver_category => p_approver_category,
                                                      p_approver_id       => v_approver_id,
                                                      p_user_id           => 1);
  END;

  PROCEDURE load_wf_approval_rule(p_company_code       VARCHAR2,
                                  p_workflow_code      VARCHAR2,
                                  p_node_seq           NUMBER,
                                  p_and_or             VARCHAR2,
                                  p_business_rule_code VARCHAR2) IS
    v_company_id       NUMBER;
    v_workflow_id      NUMBER;
    v_business_rule_id NUMBER;
    v_node_id          NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT a.workflow_id
      INTO v_workflow_id
      FROM wfl_workflow a
     WHERE a.workflow_code = p_workflow_code;
  
    SELECT node_id
      INTO v_node_id
      FROM wfl_workflow_node a
     WHERE a.workflow_id = v_workflow_id
       AND a.sequence_num = p_node_seq;
  
    SELECT business_rule_id
      INTO v_business_rule_id
      FROM exp_business_rules a
     WHERE a.business_rule_code = p_business_rule_code
       AND a.company_id = v_company_id;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_wf_business_approval_rule a
               WHERE a.workflow_id = v_workflow_id
                 AND a.node_id = v_node_id
                 AND a.business_rule_id = v_business_rule_id
                 AND a.and_or = p_and_or);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_wf_approval_rule_pkg.insert_exp_business_appr_rule(p_workflow_id      => v_workflow_id,
                                                           p_node_id          => v_node_id,
                                                           p_and_or           => p_and_or,
                                                           p_business_rule_id => v_business_rule_id,
                                                           p_company_id       => v_company_id,
                                                           p_user_id          => 1);
  END;

  --jinxiao.lin 2010.1.6 添加公司code参数
  PROCEDURE load_workflow_transaction(p_company_code          VARCHAR2,
                                      p_transaction_category  VARCHAR2,
                                      p_transaction_type_code VARCHAR2,
                                      p_workflow_code         VARCHAR2) IS
    v_company_id          NUMBER;
    v_record_id           NUMBER;
    v_transaction_type_id NUMBER;
  BEGIN
  
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    IF p_transaction_type_code IS NOT NULL THEN
      IF p_transaction_category = 'EXP_REPORT' THEN
        SELECT a.expense_report_type_id
          INTO v_transaction_type_id
          FROM exp_expense_report_types a
         WHERE a.expense_report_type_code = p_transaction_type_code
           AND a.company_id = v_company_id;
      
      ELSIF p_transaction_category = 'EXP_REQUISITION' THEN
        SELECT a.expense_requisition_type_id
          INTO v_transaction_type_id
          FROM exp_expense_req_types a
         WHERE a.expense_requisition_type_code = p_transaction_type_code
           AND a.company_id = v_company_id;
      END IF;
    END IF;
  
    wfl_workflow_pkg.insert_workflow_transaction(p_record_id            => v_record_id,
                                                 p_transaction_category => p_transaction_category,
                                                 p_transaction_type_id  => v_transaction_type_id,
                                                 p_workflow_code        => p_workflow_code,
                                                 p_user_id              => 1);
  
  END;

  PROCEDURE load_expense_req_type(p_company_code             VARCHAR2,
                                  p_expense_req_type_code    VARCHAR2,
                                  p_description              VARCHAR2,
                                  p_currency_code            VARCHAR2,
                                  p_expense_report_type_code VARCHAR2,
                                  p_accrued_flag             VARCHAR2,
                                  p_enabled_flag             VARCHAR2,
                                  p_auto_approve_flag        VARCHAR2,
                                  p_auto_audit_flag          VARCHAR2,
                                  p_payment_object           VARCHAR2,
                                  p_one_off_flag             VARCHAR2,
                                  p_tolerance_flag           VARCHAR2,
                                  p_tolerance_range          VARCHAR2,
                                  p_tolerance_ratio          NUMBER,
                                  p_report_name              VARCHAR2,
                                  p_reserve_budget           VARCHAR2,
                                  p_budget_control_enabled   VARCHAR2) IS
    v_company_id             NUMBER;
    v_expense_report_type_id NUMBER;
    v_expense_req_type_id    NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    IF p_expense_report_type_code IS NOT NULL THEN
      SELECT a.expense_report_type_id
        INTO v_expense_report_type_id
        FROM exp_expense_report_types a
       WHERE a.company_id = v_company_id
         AND a.expense_report_type_code = p_expense_report_type_code;
    END IF;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_expense_req_types a
               WHERE a.company_id = v_company_id
                 AND a.expense_requisition_type_code =
                     p_expense_report_type_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_req_types_pkg.insert_exp_expense_req_types(p_company_id             => v_company_id,
                                                           p_expense_req_type_code  => p_expense_req_type_code,
                                                           p_document_page_type     => 'STANDARD',
                                                           p_description            => p_description,
                                                           p_currency_code          => p_currency_code,
                                                           p_expense_report_type_id => v_expense_report_type_id,
                                                           p_accrued_flag           => p_accrued_flag,
                                                           p_enabled_flag           => p_enabled_flag,
                                                           p_auto_approve_flag      => p_auto_approve_flag,
                                                           p_auto_audit_flag        => p_auto_audit_flag,
                                                           p_payment_object         => p_payment_object,
                                                           p_created_by             => 1,
                                                           p_one_off_flag           => p_one_off_flag,
                                                           p_tolerance_flag         => p_tolerance_flag,
                                                           p_tolerance_range        => p_tolerance_range,
                                                           p_tolerance_ratio        => p_tolerance_ratio,
                                                           p_report_name            => p_report_name,
                                                           p_reserve_budget         => p_reserve_budget,
                                                           p_budget_control_enabled => p_budget_control_enabled,
                                                           p_expense_req_type_id    => v_expense_req_type_id);
  END;

  PROCEDURE load_exp_req_ref_expensetype(p_company_code          VARCHAR2,
                                         p_expense_req_type_code VARCHAR2,
                                         p_expense_type_code     VARCHAR2) IS
    v_company_id                  NUMBER;
    v_expense_requisition_type_id NUMBER;
    v_expense_type_id             NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT a.expense_requisition_type_id
      INTO v_expense_requisition_type_id
      FROM exp_expense_req_types a
     WHERE a.expense_requisition_type_code = p_expense_req_type_code
       AND a.company_id = v_company_id;
  
    SELECT a.expense_type_id
      INTO v_expense_type_id
      FROM exp_expense_types a
     WHERE a.expense_type_code = p_expense_type_code
       AND a.company_id = v_company_id;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_req_ref_types a
               WHERE a.expense_requisition_type_id =
                     v_expense_requisition_type_id
                 AND a.expense_type_id = v_expense_type_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_req_types_pkg.insert_exp_req_ref_types(p_expense_requisition_type_id => v_expense_requisition_type_id,
                                                       p_expense_type_id             => v_expense_type_id,
                                                       p_created_by                  => 1);
  
  END;

  PROCEDURE load_exp_req_ref_usergroup(p_company_code            VARCHAR2,
                                       p_expense_req_type_code   VARCHAR2,
                                       p_expense_user_group_code VARCHAR2) IS
    v_company_id                  NUMBER;
    v_expense_requisition_type_id NUMBER;
    v_expense_user_group_id       NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT a.expense_requisition_type_id
      INTO v_expense_requisition_type_id
      FROM exp_expense_req_types a
     WHERE a.expense_requisition_type_code = p_expense_req_type_code
       AND a.company_id = v_company_id;
  
    SELECT a.expense_user_group_id
      INTO v_expense_user_group_id
      FROM exp_user_group_headers a
     WHERE a.expense_user_group_code = p_expense_user_group_code
       AND a.company_id = v_company_id;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_req_ref_user_groups a
               WHERE a.expense_requisition_type_id =
                     v_expense_requisition_type_id
                 AND a.expense_user_group_id = v_expense_user_group_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_req_types_pkg.insert_exp_req_ref_user_groups(p_expense_requisition_type_id => v_expense_requisition_type_id,
                                                             p_expense_user_group_id       => v_expense_user_group_id,
                                                             p_created_by                  => 1);
  END;

  PROCEDURE load_exp_req_ref_objecttype(p_company_code             VARCHAR2,
                                        p_expense_req_type_code    VARCHAR2,
                                        p_expense_object_type_code VARCHAR2,
                                        p_layout_position          VARCHAR2,
                                        p_layout_priority          NUMBER,
                                        p_default_object_code      VARCHAR2,
                                        p_required_flag            VARCHAR2) IS
    v_company_id                  NUMBER;
    v_expense_requisition_type_id NUMBER;
    v_expense_object_type_id      NUMBER;
    v_default_object_id           NUMBER;
    v_exp_req_ref_object_types_id NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT a.expense_requisition_type_id
      INTO v_expense_requisition_type_id
      FROM exp_expense_req_types a
     WHERE a.expense_requisition_type_code = p_expense_req_type_code
       AND a.company_id = v_company_id;
  
    SELECT a.expense_object_type_id
      INTO v_expense_object_type_id
      FROM exp_expense_object_types a
     WHERE a.expense_object_type_code = p_expense_object_type_code
       AND a.company_id = v_company_id;
  
    IF p_default_object_code IS NOT NULL THEN
      SELECT a.expense_object_id
        INTO v_default_object_id
        FROM exp_expense_object_values a
       WHERE a.expense_object_type_id = v_expense_object_type_id
         AND a.expense_object_code = p_default_object_code;
    END IF;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_req_ref_object_types a
               WHERE a.expense_requisition_type_id =
                     v_expense_requisition_type_id
                 AND a.expense_object_type_id = v_expense_object_type_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_req_types_pkg.insert_exp_req_ref_obj_types(p_expense_requisition_type_id => v_expense_requisition_type_id,
                                                           p_expense_object_type_id      => v_expense_object_type_id,
                                                           p_layout_position             => p_layout_position,
                                                           p_layout_priority             => p_layout_priority,
                                                           p_default_object_id           => v_default_object_id,
                                                           p_required_flag               => p_required_flag,
                                                           p_created_by                  => 1,
                                                           p_exp_req_ref_object_types_id => v_exp_req_ref_object_types_id);
  END;

  PROCEDURE load_exp_req_ref_dimensions(p_company_code           VARCHAR2,
                                        p_expense_req_type_code  VARCHAR2,
                                        p_dimension_code         VARCHAR2,
                                        p_layout_position        VARCHAR2,
                                        p_layout_priority        NUMBER,
                                        p_default_dim_value_code VARCHAR2) IS
    v_company_id                  NUMBER;
    v_expense_requisition_type_id NUMBER;
    v_dimension_id                NUMBER;
    v_default_dim_value_id        NUMBER;
  
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT a.expense_requisition_type_id
      INTO v_expense_requisition_type_id
      FROM exp_expense_req_types a
     WHERE a.expense_requisition_type_code = p_expense_req_type_code
       AND a.company_id = v_company_id;
  
    SELECT a.dimension_id
      INTO v_dimension_id
      FROM fnd_dimensions a
     WHERE a.dimension_code = p_dimension_code;
  
    IF p_default_dim_value_code IS NOT NULL THEN
      SELECT a.dimension_value_id
        INTO v_default_dim_value_id
        FROM fnd_dimension_values a
       WHERE a.dimension_id = v_dimension_id
         AND a.dimension_value_code = p_default_dim_value_code;
    END IF;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_req_ref_dimensions a
               WHERE a.expense_requisition_type_id =
                     v_expense_requisition_type_id
                 AND a.dimension_id = v_dimension_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_req_types_pkg.insert_exp_req_ref_dimensions(p_expense_requisition_type_id => v_expense_requisition_type_id,
                                                            p_dimension_id                => v_dimension_id,
                                                            p_layout_position             => p_layout_position,
                                                            p_layout_priority             => p_layout_priority,
                                                            p_default_dim_value_id        => v_default_dim_value_id,
                                                            p_created_by                  => 1);
  END;

  PROCEDURE load_req_company_items(p_set_of_books_code VARCHAR2,
                                   p_req_item_code     VARCHAR2,
                                   p_company_code      VARCHAR2,
                                   p_enabled_flag      VARCHAR2) IS
    v_set_of_books_id NUMBER;
    v_req_item_id     NUMBER;
    v_company_id      NUMBER;
  BEGIN
    SELECT a.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books a
     WHERE a.set_of_books_code = p_set_of_books_code;
  
    SELECT a.req_item_id
      INTO v_req_item_id
      FROM exp_req_items a
     WHERE a.set_of_books_id = v_set_of_books_id
       AND a.req_item_code = p_req_item_code;
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_company_req_items a
               WHERE a.req_item_id = v_req_item_id
                 AND a.company_id = v_company_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_req_items_pkg.insert_exp_company_req_items(p_req_item_id  => v_req_item_id,
                                                   p_company_id   => v_company_id,
                                                   p_enabled_flag => p_enabled_flag,
                                                   p_created_by   => 1);
  END;

  PROCEDURE load_req_items_type(p_company_code      VARCHAR2,
                                p_req_item_code     VARCHAR2,
                                p_expense_type_code VARCHAR2) IS
    v_set_of_books_id NUMBER;
    v_req_item_id     NUMBER;
    v_expense_type_id NUMBER;
    v_company_id      NUMBER;
  BEGIN
    --for:HEC标准产品项目 0029722]  帐套code参数修改为 公司code参数传入
    v_company_id      := fnd_common_pkg.get_company_id(p_company_code);
    v_set_of_books_id := gld_common_pkg.get_set_of_books_id(v_company_id);
  
    SELECT a.req_item_id
      INTO v_req_item_id
      FROM exp_req_items a
     WHERE a.set_of_books_id = v_set_of_books_id
       AND a.req_item_code = p_req_item_code;
  
    SELECT a.expense_type_id
      INTO v_expense_type_id
      FROM exp_expense_types a
     WHERE a.expense_type_code = p_expense_type_code
       AND v_company_id = a.company_id;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_req_item_types a
               WHERE a.req_item_id = v_req_item_id
                 AND a.expense_type_id = v_expense_type_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_req_items_pkg.insert_exp_req_item_types(p_req_item_id     => v_req_item_id,
                                                p_expense_type_id => v_expense_type_id,
                                                p_created_by      => 1);
  END;

  PROCEDURE load_sob_req_items_type(p_set_of_books_code VARCHAR2,
                                    p_req_item_code     VARCHAR2,
                                    p_expense_type_code VARCHAR2) IS
    v_set_of_books_id NUMBER;
  BEGIN
  
    SELECT v.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books_vl v
     WHERE v.set_of_books_code = p_set_of_books_code;
  
    FOR c_cur IN (SELECT f.company_code
                    FROM fnd_companies_vl f
                   WHERE f.set_of_books_id = v_set_of_books_id) LOOP
      load_req_items_type(c_cur.company_code,
                          p_req_item_code,
                          p_expense_type_code);
    END LOOP;
  END;

  PROCEDURE load_req_items(p_set_of_books_code VARCHAR2,
                           p_req_item_code     VARCHAR2,
                           p_description       VARCHAR2,
                           p_enabled_flag      VARCHAR2,
                           p_budget_org_code   VARCHAR2,
                           p_budget_item_code  VARCHAR2) IS
    v_set_of_books_id NUMBER;
    v_budget_item_id  NUMBER;
    v_req_item_id     NUMBER;
    v_budget_org_id   NUMBER;
  BEGIN
    SELECT a.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books a
     WHERE a.set_of_books_code = p_set_of_books_code;
  
    IF p_budget_item_code IS NOT NULL AND p_budget_org_code IS NOT NULL THEN
      SELECT a.bgt_org_id
        INTO v_budget_org_id
        FROM bgt_organizations a
       WHERE a.bgt_org_code = p_budget_org_code;
    
      SELECT a.budget_item_id
        INTO v_budget_item_id
        FROM bgt_budget_items a
       WHERE a.budget_item_code = p_budget_item_code
         AND a.budget_org_id = v_budget_org_id;
    END IF;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_req_items a
               WHERE a.set_of_books_id = v_set_of_books_id
                 AND a.req_item_code = p_req_item_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_req_items_pkg.insert_exp_req_items(p_set_of_books_id => v_set_of_books_id,
                                           p_req_item_code   => p_req_item_code,
                                           p_description     => p_description,
                                           p_enabled_flag    => p_enabled_flag,
                                           p_created_by      => 1,
                                           p_budget_item_id  => v_budget_item_id,
                                           p_req_item_id     => v_req_item_id);
  END;

  PROCEDURE load_expense_report_type(p_company_code             VARCHAR2,
                                     p_expense_report_type_code VARCHAR2,
                                     p_description              VARCHAR2,
                                     p_currency_code            VARCHAR2,
                                     p_coding_rule              VARCHAR2,
                                     p_enabled_flag             VARCHAR2,
                                     p_auto_approve_flag        VARCHAR2,
                                     p_auto_audit_flag          VARCHAR2,
                                     p_payment_object           VARCHAR2,
                                     p_req_required_flag        VARCHAR2,
                                     p_adjustment_flag          VARCHAR2,
                                     p_report_name              VARCHAR2,
                                     p_payment_flag             VARCHAR2,
                                     p_amortization_flag        VARCHAR2,
                                     p_template_flag            VARCHAR2,
                                     p_reserve_budget           VARCHAR2,
                                     p_budget_control_enabled   VARCHAR2,
                                     p_payment_method_code      VARCHAR2) IS
    v_company_id             NUMBER;
    v_expense_report_type_id NUMBER;
    p_payment_method_id      NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_expense_report_types a
               WHERE a.expense_report_type_code = p_expense_report_type_code
                 AND a.company_id = v_company_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    BEGIN
      SELECT pm.payment_method_id
        INTO p_payment_method_id
        FROM csh_payment_methods pm
       WHERE pm.payment_method_code = p_payment_method_code;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_report_types_pkg.insert_exp_expense_rep_types(p_company_id               => v_company_id,
                                                              p_expense_report_type_code => p_expense_report_type_code,
                                                              p_description              => p_description,
                                                              p_document_page_type       => 'STANDARD',
                                                              p_currency_code            => p_currency_code,
                                                              p_coding_rule              => p_coding_rule,
                                                              p_enabled_flag             => p_enabled_flag,
                                                              p_created_by               => 1,
                                                              p_auto_approve_flag        => p_auto_approve_flag,
                                                              p_auto_audit_flag          => p_auto_audit_flag,
                                                              p_payment_object           => p_payment_object,
                                                              p_req_required_flag        => p_req_required_flag,
                                                              p_adjustment_flag          => p_adjustment_flag,
                                                              p_report_name              => p_report_name,
                                                              p_payment_flag             => p_payment_flag,
                                                              p_amortization_flag        => p_amortization_flag,
                                                              p_template_flag            => p_template_flag,
                                                              p_expense_report_type_id   => v_expense_report_type_id,
                                                              p_reserve_budget           => p_reserve_budget,
                                                              p_budget_control_enabled   => p_budget_control_enabled,
                                                              p_payment_method           => p_payment_method_id);
  END;

  PROCEDURE load_exp_rpt_ref_expensetype(p_company_code             VARCHAR2,
                                         p_expense_report_type_code VARCHAR2,
                                         p_expense_type_code        VARCHAR2) IS
    v_company_id             NUMBER;
    v_expense_report_type_id NUMBER;
    v_expense_type_id        NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT a.expense_report_type_id
      INTO v_expense_report_type_id
      FROM exp_expense_report_types a
     WHERE a.expense_report_type_code = p_expense_report_type_code
       AND a.company_id = v_company_id;
  
    SELECT a.expense_type_id
      INTO v_expense_type_id
      FROM exp_expense_types a
     WHERE a.expense_type_code = p_expense_type_code
       AND a.company_id = v_company_id;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_report_ref_types a
               WHERE a.expense_report_type_id = v_expense_report_type_id
                 AND a.expense_type_id = v_expense_type_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_report_types_pkg.insert_exp_report_ref_types(p_expense_report_type_id => v_expense_report_type_id,
                                                             p_expense_type_id        => v_expense_type_id,
                                                             p_created_by             => 1);
  
  END;

  PROCEDURE load_exp_rpt_ref_usergroup(p_company_code             VARCHAR2,
                                       p_expense_report_type_code VARCHAR2,
                                       p_expense_user_group_code  VARCHAR2) IS
    v_company_id             NUMBER;
    v_expense_report_type_id NUMBER;
    v_expense_user_group_id  NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT a.expense_report_type_id
      INTO v_expense_report_type_id
      FROM exp_expense_report_types a
     WHERE a.expense_report_type_code = p_expense_report_type_code
       AND a.company_id = v_company_id;
  
    SELECT a.expense_user_group_id
      INTO v_expense_user_group_id
      FROM exp_user_group_headers a
     WHERE a.expense_user_group_code = p_expense_user_group_code
       AND a.company_id = v_company_id;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_report_ref_user_groups a
               WHERE a.expense_report_type_id = v_expense_report_type_id
                 AND a.expense_user_group_id = v_expense_user_group_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_report_types_pkg.insert_exp_rep_ref_user_groups(p_expense_report_type_id => v_expense_report_type_id,
                                                                p_expense_user_group_id  => v_expense_user_group_id,
                                                                p_created_by             => 1);
  END;

  PROCEDURE load_exp_rpt_ref_objecttype(p_company_code             VARCHAR2,
                                        p_expense_report_type_code VARCHAR2,
                                        p_expense_object_type_code VARCHAR2,
                                        p_layout_position          VARCHAR2,
                                        p_layout_priority          NUMBER,
                                        p_default_object_code      VARCHAR2,
                                        p_required_flag            VARCHAR2) IS
    v_company_id                  NUMBER;
    v_expense_report_type_id      NUMBER;
    v_expense_object_type_id      NUMBER;
    v_default_object_id           NUMBER;
    v_exp_req_ref_object_types_id NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT a.expense_report_type_id
      INTO v_expense_report_type_id
      FROM exp_expense_report_types a
     WHERE a.expense_report_type_code = p_expense_report_type_code
       AND a.company_id = v_company_id;
  
    SELECT a.expense_object_type_id
      INTO v_expense_object_type_id
      FROM exp_expense_object_types a
     WHERE a.expense_object_type_code = p_expense_object_type_code
       AND a.company_id = v_company_id;
  
    IF p_default_object_code IS NOT NULL THEN
      SELECT a.expense_object_id
        INTO v_default_object_id
        FROM exp_expense_object_values a
       WHERE a.expense_object_type_id = v_expense_object_type_id
         AND a.expense_object_code = p_default_object_code;
    END IF;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_report_ref_object_types a
               WHERE a.expense_report_type_id = v_expense_report_type_id
                 AND a.expense_object_type_id = v_expense_object_type_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_report_types_pkg.insert_exp_rep_ref_object_type(p_expense_report_type_id      => v_expense_report_type_id,
                                                                p_expense_object_type_id      => v_expense_object_type_id,
                                                                p_layout_position             => p_layout_position,
                                                                p_layout_priority             => p_layout_priority,
                                                                p_default_object_id           => v_default_object_id,
                                                                p_required_flag               => p_required_flag,
                                                                p_created_by                  => 1,
                                                                p_exp_rep_ref_object_types_id => v_exp_req_ref_object_types_id);
  END;

  PROCEDURE load_exp_rpt_ref_dimensions(p_company_code             VARCHAR2,
                                        p_expense_report_type_code VARCHAR2,
                                        p_dimension_code           VARCHAR2,
                                        p_layout_position          VARCHAR2,
                                        p_layout_priority          NUMBER,
                                        p_default_dim_value_code   VARCHAR2) IS
    v_company_id             NUMBER;
    v_expense_report_type_id NUMBER;
    v_dimension_id           NUMBER;
    v_default_dim_value_id   NUMBER;
  
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT a.expense_report_type_id
      INTO v_expense_report_type_id
      FROM exp_expense_report_types a
     WHERE a.expense_report_type_code = p_expense_report_type_code
       AND a.company_id = v_company_id;
  
    SELECT a.dimension_id
      INTO v_dimension_id
      FROM fnd_dimensions a
     WHERE a.dimension_code = p_dimension_code;
  
    IF p_default_dim_value_code IS NOT NULL THEN
      SELECT a.dimension_value_id
        INTO v_default_dim_value_id
        FROM fnd_dimension_values a
       WHERE a.dimension_id = v_dimension_id
         AND a.dimension_value_code = p_default_dim_value_code;
    END IF;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_rep_ref_dimensions a
               WHERE a.expense_report_type_id = v_expense_report_type_id
                 AND a.dimension_id = v_dimension_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_report_types_pkg.insert_exp_rep_ref_dimensions(p_expense_report_type_id => v_expense_report_type_id,
                                                               p_dimension_id           => v_dimension_id,
                                                               p_layout_position        => p_layout_position,
                                                               p_layout_priority        => p_layout_priority,
                                                               p_default_dim_value_id   => v_default_dim_value_id,
                                                               p_created_by             => 1);
  END;

  PROCEDURE load_expense_company_items(p_set_of_books_code VARCHAR2,
                                       p_expense_item_code VARCHAR2,
                                       p_company_code      VARCHAR2,
                                       p_enabled_flag      VARCHAR2) IS
    v_set_of_books_id NUMBER;
    v_expense_item_id NUMBER;
    v_company_id      NUMBER;
  BEGIN
    SELECT a.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books a
     WHERE a.set_of_books_code = p_set_of_books_code;
  
    SELECT a.expense_item_id
      INTO v_expense_item_id
      FROM exp_expense_items a
     WHERE a.set_of_books_id = v_set_of_books_id
       AND a.expense_item_code = p_expense_item_code;
  
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_company_expense_items a
               WHERE a.expense_item_id = v_expense_item_id
                 AND a.company_id = v_company_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_items_pkg.insert_company_expense_items(p_expense_item_id => v_expense_item_id,
                                                       p_company_id      => v_company_id,
                                                       p_enabled_flag    => p_enabled_flag,
                                                       p_created_by      => 1);
  END;

  PROCEDURE load_expense_items_type(p_company_code      VARCHAR2,
                                    p_expense_item_code VARCHAR2,
                                    p_expense_type_code VARCHAR2) IS
    v_set_of_books_id NUMBER;
    v_expense_item_id NUMBER;
    v_expense_type_id NUMBER;
    v_company_id      NUMBER;
  BEGIN
    v_company_id      := fnd_common_pkg.get_company_id(p_company_code);
    v_set_of_books_id := gld_common_pkg.get_set_of_books_id(v_company_id);
  
    SELECT a.expense_item_id
      INTO v_expense_item_id
      FROM exp_expense_items a
     WHERE a.set_of_books_id = v_set_of_books_id
       AND a.expense_item_code = p_expense_item_code;
  
    SELECT a.expense_type_id
      INTO v_expense_type_id
      FROM exp_expense_types a
     WHERE a.expense_type_code = p_expense_type_code
       AND a.company_id = v_company_id;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_expense_item_types a
               WHERE a.expense_item_id = v_expense_item_id
                 AND a.expense_type_id = v_expense_type_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_items_pkg.insert_exp_expense_item_types(p_expense_item_id => v_expense_item_id,
                                                        p_expense_type_id => v_expense_type_id,
                                                        p_created_by      => 1,
                                                        p_last_updated_by => 1);
  END;

  PROCEDURE load_sob_expense_items_type(p_set_of_books_code VARCHAR2,
                                        p_expense_item_code VARCHAR2,
                                        p_expense_type_code VARCHAR2) IS
    v_set_of_books_id NUMBER;
  BEGIN
    SELECT v.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books_vl v
     WHERE v.set_of_books_code = p_set_of_books_code;
  
    FOR c_cur IN (SELECT f.company_code
                    FROM fnd_companies_vl f
                   WHERE f.set_of_books_id = v_set_of_books_id) LOOP
      load_expense_items_type(c_cur.company_code,
                              p_expense_item_code,
                              p_expense_type_code);
    END LOOP;
  
  END;

  PROCEDURE load_expense_items(p_set_of_books_code VARCHAR2,
                               p_expense_item_code VARCHAR2,
                               p_description       VARCHAR2,
                               p_currency_code     VARCHAR2,
                               p_standard_price    NUMBER,
                               p_enabled_flag      VARCHAR2,
                               p_req_item_code     VARCHAR2,
                               p_budget_org_code   VARCHAR2,
                               p_budget_item_code  VARCHAR2) IS
    v_set_of_books_id NUMBER;
    v_budget_item_id  NUMBER;
    v_req_item_id     NUMBER;
    v_expense_item_id NUMBER;
    v_budget_org_id   NUMBER;
  BEGIN
    SELECT a.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books a
     WHERE a.set_of_books_code = p_set_of_books_code;
  
    IF p_budget_item_code IS NOT NULL AND p_budget_org_code IS NOT NULL THEN
    
      SELECT a.bgt_org_id
        INTO v_budget_org_id
        FROM bgt_organizations a
       WHERE a.bgt_org_code = p_budget_org_code;
    
      SELECT a.budget_item_id
        INTO v_budget_item_id
        FROM bgt_budget_items a
       WHERE a.budget_item_code = p_budget_item_code
         AND a.budget_org_id = v_budget_org_id;
    END IF;
  
    IF p_req_item_code IS NOT NULL THEN
      SELECT a.req_item_id
        INTO v_req_item_id
        FROM exp_req_items a
       WHERE a.req_item_code = p_req_item_code
         AND a.set_of_books_id = v_set_of_books_id;
    END IF;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_expense_items a
               WHERE a.set_of_books_id = v_set_of_books_id
                 AND a.expense_item_code = p_expense_item_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_items_pkg.insert_exp_expense_items(p_set_of_books_id   => v_set_of_books_id,
                                                   p_expense_item_code => p_expense_item_code,
                                                   p_description       => p_description,
                                                   p_currency_code     => p_currency_code,
                                                   p_standard_price    => p_standard_price,
                                                   p_enabled_flag      => p_enabled_flag,
                                                   p_created_by        => 1,
                                                   p_last_updated_by   => 1,
                                                   p_req_item_id       => v_req_item_id,
                                                   p_budget_item_id    => v_budget_item_id,
                                                   p_expense_item_id   => v_expense_item_id);
  END;

  PROCEDURE load_document_anthority(p_document_type         VARCHAR2, --单据类型代码
                                    p_granted_employee_code VARCHAR2, --被授权人员工代码
                                    p_granted_company_code  VARCHAR2, --被授权人公司代码
                                    p_granted_position_code VARCHAR2, --被授权人岗位代码
                                    p_company_code          VARCHAR2, --授权人公司代码
                                    p_org_unit_code         VARCHAR2, --授权人部门代码
                                    p_position_code         VARCHAR2, --授权人岗位代码
                                    p_employee_code         VARCHAR2, --授权人员工代码
                                    p_start_date            VARCHAR2, --开始时间
                                    p_end_date              VARCHAR2, --结束时间
                                    p_query_authority       VARCHAR2, --查看权限
                                    p_maintenance_authority VARCHAR2, --维护权限
                                    p_view_limit            VARCHAR2) --查看受限 
   IS
    p_authority_id        NUMBER;
    v_granted_company_id  NUMBER;
    v_granted_employee_id NUMBER;
    v_granted_position_id NUMBER;
    v_company_id          NUMBER;
    v_org_unit_id         NUMBER;
    v_position_id         NUMBER;
    v_employee_id         NUMBER;
  
  BEGIN
    IF p_granted_employee_code IS NOT NULL THEN
      SELECT employee_id
        INTO v_granted_employee_id
        FROM exp_employees a
       WHERE a.employee_code = p_granted_employee_code;
    END IF;
    IF p_company_code IS NOT NULL THEN
      SELECT company_id
        INTO v_company_id
        FROM fnd_companies
       WHERE company_code = p_company_code;
    END IF;
  
    IF p_org_unit_code IS NOT NULL THEN
      SELECT a.unit_id
        INTO v_org_unit_id
        FROM exp_org_unit a
       WHERE a.company_id = v_company_id
         AND a.unit_code = p_org_unit_code;
    END IF;
  
    IF p_position_code IS NOT NULL THEN
      SELECT position_id
        INTO v_position_id
        FROM exp_org_position a
       WHERE a.company_id = v_company_id
         AND a.position_code = p_position_code;
    END IF;
  
    IF p_granted_company_code IS NOT NULL THEN
      SELECT company_id
        INTO v_granted_company_id
        FROM fnd_companies
       WHERE company_code = p_granted_company_code;
    END IF;
  
    IF p_granted_position_code IS NOT NULL THEN
      SELECT position_id
        INTO v_granted_position_id
        FROM exp_org_position a
       WHERE a.company_id = v_granted_company_id
         AND a.position_code = p_granted_position_code;
    END IF;
  
    IF p_employee_code IS NOT NULL THEN
      SELECT employee_id
        INTO v_employee_id
        FROM exp_employees a
       WHERE a.employee_code = p_employee_code;
    END IF;
  
    IF exp_document_authorities_pkg.exist_exp_doc_authorities(p_document_type,
                                                              v_granted_employee_id,
                                                              v_employee_id,
                                                              'MAINTENANCE',
                                                              1) = 'N' THEN
      exp_document_authorities_pkg.insert_exp_doc_authorities(p_document_type         => p_document_type,
                                                              p_granted_employee_id   => v_granted_employee_id,
                                                              p_granted_position_id   => v_granted_position_id,
                                                              p_company_id            => v_company_id,
                                                              p_org_unit_id           => v_org_unit_id,
                                                              p_position_id           => v_position_id,
                                                              p_employee_id           => v_employee_id,
                                                              p_start_date            => to_date(p_start_date,
                                                                                                 'YYYY-MM-DD'),
                                                              p_end_date              => to_date(p_end_date,
                                                                                                 'YYYY-MM-DD'),
                                                              p_query_authority       => p_query_authority,
                                                              p_maintenance_authority => p_maintenance_authority,
                                                              p_view_limit            => p_view_limit,
                                                              p_user_id               => 1,
                                                              p_authority_id          => p_authority_id);
    END IF;
  END;

  --帐套级报销单类型定义
  PROCEDURE load_exp_sob_rep_types(p_company_code             VARCHAR2,
                                   p_set_of_books_code        VARCHAR2,
                                   p_expense_report_type_code VARCHAR2,
                                   p_description              VARCHAR2,
                                   p_document_page_type       VARCHAR2,
                                   p_currency_code            VARCHAR2,
                                   p_coding_rule              VARCHAR2,
                                   p_auto_approve_flag        VARCHAR2,
                                   p_auto_audit_flag          VARCHAR2,
                                   p_payment_object           VARCHAR2,
                                   p_payment_method           NUMBER,
                                   p_req_required_flag        VARCHAR2,
                                   p_adjustment_flag          VARCHAR2,
                                   p_report_name              VARCHAR2,
                                   p_payment_flag             VARCHAR2,
                                   p_amortization_flag        VARCHAR2,
                                   p_enabled_flag             VARCHAR2,
                                   p_template_flag            VARCHAR2,
                                   p_reserve_budget           VARCHAR2,
                                   p_budget_control_enabled   VARCHAR2) IS
    v_company_id             NUMBER;
    v_set_of_books_id        NUMBER;
    v_expense_report_type_id NUMBER;
    v_payment_method_id      NUMBER;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
  
    SELECT s.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books s
     WHERE s.set_of_books_code = p_set_of_books_code;
  
    SELECT m.payment_method_id
      INTO v_payment_method_id
      FROM csh_payment_methods m
     WHERE m.payment_method_code = p_payment_method;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_sob_report_types a
               WHERE a.expense_report_type_code = p_expense_report_type_code
                 AND a.set_of_books_id = v_set_of_books_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    exp_sob_report_types_pkg.insert_exp_sob_rep_types(p_company_id               => v_company_id,
                                                      p_set_of_books_id          => v_set_of_books_id,
                                                      p_expense_report_type_code => p_expense_report_type_code,
                                                      p_description              => p_description,
                                                      p_document_page_type       => p_document_page_type,
                                                      p_currency_code            => p_currency_code,
                                                      p_coding_rule              => p_coding_rule,
                                                      p_auto_approve_flag        => p_auto_approve_flag,
                                                      p_auto_audit_flag          => p_auto_audit_flag,
                                                      p_payment_object           => p_payment_object,
                                                      p_req_required_flag        => p_req_required_flag,
                                                      p_adjustment_flag          => p_adjustment_flag,
                                                      p_report_name              => p_report_name,
                                                      p_payment_flag             => p_payment_flag,
                                                      p_payment_method           => v_payment_method_id,
                                                      p_amortization_flag        => p_amortization_flag,
                                                      p_enabled_flag             => p_enabled_flag,
                                                      p_created_by               => 1,
                                                      p_template_flag            => p_template_flag,
                                                      p_reserve_budget           => p_reserve_budget,
                                                      p_budget_control_enabled   => p_budget_control_enabled,
                                                      p_expense_report_type_id   => v_expense_report_type_id);
  END load_exp_sob_rep_types;
  --帐套级报销单关联报销类型定义
  PROCEDURE load_exp_sob_rep_ref_t(p_set_of_books_code        VARCHAR2,
                                   p_expense_report_type_code VARCHAR2,
                                   p_expense_type_code        VARCHAR2) IS
    v_set_of_books_id            NUMBER;
    v_expense_report_type_id     NUMBER;
    v_expense_report_ref_type_id NUMBER;
  BEGIN
    SELECT s.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books s
     WHERE s.set_of_books_code = p_set_of_books_code;
  
    SELECT e.expense_report_type_id
      INTO v_expense_report_type_id
      FROM exp_sob_report_types e
     WHERE e.set_of_books_id = v_set_of_books_id
       AND e.expense_report_type_code = p_expense_report_type_code;
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_sob_report_ref_types a
               WHERE a.expense_type_code = p_expense_type_code
                 AND a.expense_report_type_id = v_expense_report_type_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    exp_sob_report_types_pkg.insert_exp_sob_rep_ref_t(p_expense_report_type_id     => v_expense_report_type_id,
                                                      p_expense_type_code          => p_expense_type_code,
                                                      p_created_by                 => 1,
                                                      p_expense_report_ref_type_id => v_expense_report_ref_type_id);
  END load_exp_sob_rep_ref_t;
  --帐套级报销类型关联帐套级费用项目定义
  PROCEDURE load_exp_sob_rep_ref_object(p_set_of_books_code        VARCHAR2,
                                        p_expense_report_type_code VARCHAR2,
                                        p_expense_object_type_code VARCHAR2,
                                        p_layout_position          VARCHAR2,
                                        p_layout_priority          NUMBER,
                                        p_default_object_code      VARCHAR2,
                                        p_required_flag            VARCHAR2) IS
    v_set_of_books_id             NUMBER;
    v_expense_report_type_id      NUMBER;
    v_expense_object_type_id      NUMBER;
    v_default_object_id           NUMBER;
    v_exp_rep_ref_object_types_id NUMBER;
  BEGIN
    SELECT s.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books s
     WHERE s.set_of_books_code = p_set_of_books_code;
  
    SELECT e.expense_report_type_id
      INTO v_expense_report_type_id
      FROM exp_sob_report_types e
     WHERE e.set_of_books_id = v_set_of_books_id
       AND e.expense_report_type_code = p_expense_report_type_code;
  
    SELECT a.expense_object_type_id
      INTO v_expense_object_type_id
      FROM exp_sob_expense_object_types a
     WHERE a.set_of_books_id = v_set_of_books_id
       AND a.expense_object_type_code = p_expense_object_type_code;
  
    IF p_default_object_code IS NOT NULL THEN
      SELECT a1.expense_object_id
        INTO v_default_object_id
        FROM exp_sob_expense_object_values a1
       WHERE a1.expense_object_type_id = v_expense_object_type_id
         AND a1.expense_object_code = p_default_object_code;
    END IF;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_sob_report_ref_object es
               WHERE es.expense_report_type_id = v_expense_report_type_id
                 AND es.expense_object_type_id = v_expense_object_type_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    exp_sob_report_types_pkg.insert_exp_sob_rep_ref_object(p_expense_report_type_id      => v_expense_report_type_id,
                                                           p_expense_object_type_id      => v_expense_object_type_id,
                                                           p_layout_position             => p_layout_position,
                                                           p_layout_priority             => p_layout_priority,
                                                           p_default_object_id           => v_default_object_id,
                                                           p_created_by                  => 1,
                                                           p_required_flag               => p_required_flag,
                                                           p_exp_rep_ref_object_types_id => v_exp_rep_ref_object_types_id);
  END load_exp_sob_rep_ref_object;
  --帐套级报销单关联员工组定义
  PROCEDURE load_exp_sob_user_groups(p_set_of_books_code        VARCHAR2,
                                     p_expense_report_type_code VARCHAR2,
                                     p_expense_user_groups_code VARCHAR2) IS
    v_set_of_books_id        NUMBER;
    v_expense_report_type_id NUMBER;
  BEGIN
    SELECT s.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books s
     WHERE s.set_of_books_code = p_set_of_books_code;
  
    SELECT e.expense_report_type_id
      INTO v_expense_report_type_id
      FROM exp_sob_report_types e
     WHERE e.set_of_books_id = v_set_of_books_id
       AND e.expense_report_type_code = p_expense_report_type_code;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_sob_rep_t_user_groups es
               WHERE es.expense_report_type_id = v_expense_report_type_id
                 AND es.expense_user_groups_code =
                     p_expense_user_groups_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    exp_sob_report_types_pkg.insert_exp_sob_user_groups(p_expense_report_type_id   => v_expense_report_type_id,
                                                        p_expense_user_groups_code => p_expense_user_groups_code,
                                                        p_created_by               => 1);
  END load_exp_sob_user_groups;
  --帐套级申请单类型定义
  PROCEDURE load_exp_sob_req_types(p_set_of_books_code        VARCHAR2,
                                   p_company_code             VARCHAR2,
                                   p_expense_req_type_code    VARCHAR2,
                                   p_description              VARCHAR2,
                                   p_document_page_type       VARCHAR2,
                                   p_currency_code            VARCHAR2,
                                   p_expense_report_type_code VARCHAR2,
                                   p_accrued_flag             VARCHAR2,
                                   p_enabled_flag             VARCHAR2,
                                   p_auto_approve_flag        VARCHAR2,
                                   p_auto_audit_flag          VARCHAR2,
                                   p_payment_object           VARCHAR2,
                                   p_one_off_flag             VARCHAR2,
                                   p_tolerance_flag           VARCHAR2,
                                   p_tolerance_range          VARCHAR2,
                                   p_tolerance_ratio          NUMBER,
                                   p_report_name              VARCHAR2,
                                   p_reserve_budget           VARCHAR2,
                                   p_budget_control_enabled   VARCHAR2,
                                   p_app_documents_icon       VARCHAR2 DEFAULT NULL,
                                   p_mobile_approve           VARCHAR2 DEFAULT 'N',
                                   p_mobile_fill              VARCHAR2 DEFAULT 'N') IS
    v_set_of_books_id     NUMBER;
    v_company_id          NUMBER;
    v_expense_req_type_id NUMBER;
  BEGIN
    SELECT s.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books s
     WHERE s.set_of_books_code = p_set_of_books_code;
  
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM exp_sob_req_types a
               WHERE a.set_of_books_id = v_set_of_books_id
                 AND a.expense_requisition_type_code =
                     p_expense_req_type_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    exp_sob_expense_req_types_pkg.insert_exp_sob_req_types(p_set_of_books_id          => v_set_of_books_id,
                                                           p_company_id               => v_company_id,
                                                           p_expense_req_type_code    => p_expense_req_type_code,
                                                           p_description              => p_description,
                                                           p_document_page_type       => p_document_page_type,
                                                           p_currency_code            => p_currency_code,
                                                           p_expense_report_type_code => p_expense_report_type_code,
                                                           p_accrued_flag             => p_accrued_flag,
                                                           p_enabled_flag             => p_enabled_flag,
                                                           p_auto_approve_flag        => p_auto_approve_flag,
                                                           p_auto_audit_flag          => p_auto_audit_flag,
                                                           p_payment_object           => p_payment_object,
                                                           p_created_by               => 1,
                                                           p_one_off_flag             => p_one_off_flag,
                                                           p_tolerance_flag           => p_tolerance_flag,
                                                           p_tolerance_range          => p_tolerance_range,
                                                           p_tolerance_ratio          => p_tolerance_ratio,
                                                           p_report_name              => p_report_name,
                                                           p_reserve_budget           => p_reserve_budget,
                                                           p_budget_control_enabled   => p_budget_control_enabled,
                                                           p_app_documents_icon       => p_app_documents_icon,
                                                           p_mobile_approve           => p_mobile_approve,
                                                           p_mobile_fill              => p_mobile_fill,
                                                           p_expense_req_type_id      => v_expense_req_type_id,
                                                           p_company_flag             => NULL,
                                                           p_unit_flag                => NULL);
  END load_exp_sob_req_types;
  --帐套级申请单关联报销类型定义
  PROCEDURE load_exp_sob_req_ref_t(p_set_of_books_code     VARCHAR2,
                                   p_expense_req_type_code VARCHAR2,
                                   p_expense_type_code     VARCHAR2) IS
    v_set_of_books_id     NUMBER;
    v_expense_req_type_id NUMBER;
  BEGIN
    SELECT s.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books s
     WHERE s.set_of_books_code = p_set_of_books_code;
  
    SELECT e.expense_requisition_type_id
      INTO v_expense_req_type_id
      FROM exp_sob_req_types e
     WHERE e.set_of_books_id = v_set_of_books_id
       AND e.expense_requisition_type_code = p_expense_req_type_code;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_sob_req_ref_types a
               WHERE a.expense_requisition_type_id = v_expense_req_type_id
                 AND a.expense_type_code = p_expense_type_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    exp_sob_expense_req_types_pkg.insert_exp_sob_req_ref_t(p_expense_requisition_type_id => v_expense_req_type_id,
                                                           p_expense_type_code           => p_expense_type_code,
                                                           p_created_by                  => 1);
  END load_exp_sob_req_ref_t;
  --帐套级申请类型关联帐套级申请项目定义
  PROCEDURE load_exp_sob_req_object_o(p_set_of_books_code        VARCHAR2,
                                      p_expense_req_type_code    VARCHAR2,
                                      p_expense_object_type_code VARCHAR2,
                                      p_layout_position          VARCHAR2,
                                      p_layout_priority          NUMBER,
                                      p_default_object_code      VARCHAR2,
                                      p_required_flag            VARCHAR2) IS
    v_set_of_books_id             NUMBER;
    v_expense_req_type_id         NUMBER;
    v_expense_object_type_id      NUMBER;
    v_default_object_id           NUMBER;
    v_exp_req_ref_object_types_id NUMBER;
  BEGIN
    SELECT s.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books s
     WHERE s.set_of_books_code = p_set_of_books_code;
  
    SELECT e.expense_requisition_type_id
      INTO v_expense_req_type_id
      FROM exp_sob_req_types e
     WHERE e.set_of_books_id = v_set_of_books_id
       AND e.expense_requisition_type_code = p_expense_req_type_code;
  
    SELECT es.expense_object_type_id
      INTO v_expense_object_type_id
      FROM exp_sob_expense_object_types es
     WHERE es.set_of_books_id = v_set_of_books_id
       AND es.expense_object_type_code = p_expense_object_type_code;
  
    IF p_default_object_code IS NOT NULL THEN
      SELECT a.expense_object_id
        INTO v_default_object_id
        FROM exp_sob_expense_object_values a
       WHERE a.expense_object_type_id = v_expense_object_type_id
         AND a.expense_object_code = p_default_object_code;
    END IF;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_sob_req_object_types a
               WHERE a.expense_requisition_type_id = v_expense_req_type_id
                 AND a.expense_object_type_id = v_expense_object_type_id);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    exp_sob_expense_req_types_pkg.insert_exp_sob_req_object_o(p_expense_requisition_type_id => v_expense_req_type_id,
                                                              p_expense_object_type_id      => v_expense_object_type_id,
                                                              p_layout_position             => p_layout_position,
                                                              p_layout_priority             => p_layout_priority,
                                                              p_default_object_id           => v_default_object_id,
                                                              p_created_by                  => 1,
                                                              p_required_flag               => p_required_flag,
                                                              p_exp_req_ref_object_types_id => v_exp_req_ref_object_types_id);
  END load_exp_sob_req_object_o;
  --帐套级申请单关联员工组定义
  PROCEDURE load_set_req_ref_user_g(p_set_of_books_code       VARCHAR2,
                                    p_expense_req_type_code   VARCHAR2,
                                    p_expense_user_group_code VARCHAR2) IS
    v_set_of_books_id     NUMBER;
    v_expense_req_type_id NUMBER;
  BEGIN
    SELECT s.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books s
     WHERE s.set_of_books_code = p_set_of_books_code;
  
    SELECT e.expense_requisition_type_id
      INTO v_expense_req_type_id
      FROM exp_sob_req_types e
     WHERE e.set_of_books_id = v_set_of_books_id
       AND e.expense_requisition_type_code = p_expense_req_type_code;
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM exp_sob_req_ref_user_g a
               WHERE a.expense_requisition_type_id = v_expense_req_type_id
                 AND a.expense_user_group_code = p_expense_user_group_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    exp_sob_expense_req_types_pkg.insert_set_req_ref_user_g(p_expense_requisition_type_id => v_expense_req_type_id,
                                                            p_expense_user_group_code     => p_expense_user_group_code,
                                                            p_created_by                  => 1);
  END load_set_req_ref_user_g;

  --导入费用政策地点

  PROCEDURE load_exp_policy_places(p_place_code       VARCHAR2,
                                   p_description_text VARCHAR2,
                                   p_place_type_code  VARCHAR2) IS
    v_district_id    NUMBER;
    v_description_id NUMBER;
  
  BEGIN
  
    SELECT fnd_descriptions_s.nextval INTO v_description_id FROM dual;
    fnd_description_pkg.insert_fnd_descriptions(p_description_id   => v_description_id,
                                                p_ref_table        => 'EXP_POLICY_PLACES',
                                                p_ref_field        => 'DESCRIPTION_ID',
                                                p_description_text => p_description_text,
                                                p_created_by       => 1,
                                                p_last_updated_by  => 1,
                                                p_language_code    => 'ZHS');
  
    SELECT t.district_id
      INTO v_district_id
      FROM exp_policy_districts t
     WHERE t.district_code = p_place_type_code;
  
    INSERT INTO exp_policy_places
      (place_id,
       place_code,
       description_id,
       district_id,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (exp_policy_places_s.nextval,
       p_place_code,
       v_description_id,
       v_district_id,
       'Y',
       1,
       SYSDATE,
       1,
       SYSDATE);
  END load_exp_policy_places;

  --导入部门级维度分配表
  PROCEDURE load_fnd_unit_dim_value_assign(p_company_code         VARCHAR2,
                                           p_unit_code            VARCHAR2,
                                           p_dimension_code       VARCHAR2,
                                           p_dimension_value_code VARCHAR2,
                                           p_default_flag         VARCHAR2) IS
    v_unit_id             NUMBER;
    v_dimension_id        NUMBER;
    v_dimension_value_id  NUMBER;
    v_assign_id           NUMBER;
    v_dim_value_assign_id NUMBER;
    v_dim_assign_id       NUMBER;
    v_dimension_code      VARCHAR2(200);
  BEGIN
  
    SELECT fnd_unit_dim_value_assign_s.nextval
      INTO v_dim_value_assign_id
      FROM dual;
  
    SELECT unit_id
      INTO v_unit_id
      FROM exp_org_unit
     WHERE unit_code = p_unit_code
       AND company_id = (SELECT company_id
                           FROM fnd_companies
                          WHERE company_code = p_company_code);
  
    SELECT dimension_id
      INTO v_dimension_id
      FROM fnd_dimensions
     WHERE dimension_code = p_dimension_code;
    SELECT dimension_value_id
      INTO v_dimension_value_id
      FROM fnd_dimension_values
     WHERE dimension_value_code = p_dimension_value_code
       AND dimension_id = v_dimension_id;
  
    BEGIN
      SELECT dimension_code
        INTO v_dimension_code
        FROM fnd_dimensions
       WHERE dimension_id IN
             (SELECT dimension_id
                FROM fnd_unit_dim_assign
               WHERE unit_id =
                     (SELECT unit_id
                        FROM exp_org_unit
                       WHERE unit_code = p_unit_code
                         AND company_id =
                             (SELECT company_id
                                FROM fnd_companies
                               WHERE company_code = p_company_code)));
    
    EXCEPTION
      WHEN no_data_found THEN
        SELECT fnd_unit_dim_assign_s.nextval INTO v_assign_id FROM dual;
        INSERT INTO fnd_unit_dim_assign
          (assign_id,
           unit_id,
           dimension_id,
           default_dimension_value_id,
           created_by,
           creation_date,
           last_updated_by,
           last_update_date)
        VALUES
          (v_assign_id,
           v_unit_id,
           v_dimension_id,
           -1,
           1,
           SYSDATE,
           1,
           SYSDATE);
      
        INSERT INTO fnd_unit_dim_value_assign
          (assign_id,
           dim_assign_id,
           unit_id,
           dimension_id,
           dimension_value_id,
           default_flag,
           created_by,
           creation_date,
           last_updated_by,
           last_update_date)
        VALUES
          (v_dim_value_assign_id,
           v_assign_id,
           v_unit_id,
           v_dimension_id,
           v_dimension_value_id,
           p_default_flag,
           1,
           SYSDATE,
           1,
           SYSDATE);
      
        IF p_default_flag = 'Y' THEN
          UPDATE fnd_unit_dim_assign
             SET default_dimension_value_id = v_dimension_value_id
           WHERE assign_id = v_assign_id;
        END IF;
        RETURN;
    END;
  
    FOR c_dimension_code IN (SELECT dimension_code
                               FROM fnd_dimensions
                              WHERE dimension_id IN
                                    (SELECT dimension_id
                                       FROM fnd_unit_dim_assign
                                      WHERE unit_id =
                                            (SELECT unit_id
                                               FROM exp_org_unit
                                              WHERE unit_code = p_unit_code
                                                AND company_id =
                                                    (SELECT company_id
                                                       FROM fnd_companies
                                                      WHERE company_code =
                                                            p_company_code)))) LOOP
    
      IF c_dimension_code.dimension_code = p_dimension_code THEN
      
        SELECT assign_id
          INTO v_dim_assign_id
          FROM fnd_unit_dim_assign
         WHERE unit_id =
               (SELECT unit_id
                  FROM exp_org_unit
                 WHERE unit_code = p_unit_code
                   AND company_id =
                       (SELECT company_id
                          FROM fnd_companies
                         WHERE company_code = p_company_code))
           AND dimension_id =
               (SELECT dimension_id
                  FROM fnd_dimensions
                 WHERE dimension_code = p_dimension_code);
        INSERT INTO fnd_unit_dim_value_assign
          (assign_id,
           dim_assign_id,
           unit_id,
           dimension_id,
           dimension_value_id,
           default_flag,
           created_by,
           creation_date,
           last_updated_by,
           last_update_date)
        VALUES
          (v_dim_value_assign_id,
           v_dim_assign_id,
           v_unit_id,
           v_dimension_id,
           v_dimension_value_id,
           p_default_flag,
           1,
           SYSDATE,
           1,
           SYSDATE);
      
        IF p_default_flag = 'Y' THEN
          UPDATE fnd_unit_dim_assign
             SET default_dimension_value_id = v_dimension_value_id
           WHERE assign_id = v_dim_assign_id;
        END IF;
      
      ELSE
      
        SELECT fnd_unit_dim_assign_s.nextval INTO v_assign_id FROM dual;
        INSERT INTO fnd_unit_dim_assign
          (assign_id,
           unit_id,
           dimension_id,
           default_dimension_value_id,
           created_by,
           creation_date,
           last_updated_by,
           last_update_date)
        VALUES
          (v_assign_id,
           v_unit_id,
           v_dimension_id,
           -1,
           1,
           SYSDATE,
           1,
           SYSDATE);
      
        INSERT INTO fnd_unit_dim_value_assign
          (assign_id,
           dim_assign_id,
           unit_id,
           dimension_id,
           dimension_value_id,
           default_flag,
           created_by,
           creation_date,
           last_updated_by,
           last_update_date)
        VALUES
          (v_dim_value_assign_id,
           v_assign_id,
           v_unit_id,
           v_dimension_id,
           v_dimension_value_id,
           p_default_flag,
           1,
           SYSDATE,
           1,
           SYSDATE);
      
        IF p_default_flag = 'Y' THEN
          UPDATE fnd_unit_dim_assign
             SET default_dimension_value_id = v_dimension_value_id
           WHERE assign_id = v_assign_id;
        END IF;
      
      END IF;
    
    END LOOP;
  
  END load_fnd_unit_dim_value_assign;

  --帐套级报销类型定义

  PROCEDURE load_exp_sob_expense_types(p_set_of_books_code        VARCHAR2,
                                       p_expense_type_code        VARCHAR2,
                                       p_expense_type_description VARCHAR2,
                                       p_enabled_flag             VARCHAR2) IS
    v_set_of_books_id NUMBER;
    v_expense_type_id NUMBER;
    e_exception EXCEPTION;
  BEGIN
    SELECT s.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books s
     WHERE s.set_of_books_code = p_set_of_books_code;
    IF (p_enabled_flag != 'Y' AND p_enabled_flag != 'N') THEN
      RAISE e_exception;
    END IF;
    IF (p_expense_type_description IS NULL) THEN
      RAISE e_exception;
    END IF;
    exp_sob_expense_types_pkg.insert_exp_sob_expense_types(p_set_books_id           => v_set_of_books_id,
                                                           p_expense_type_code      => p_expense_type_code,
                                                           p_description            => p_expense_type_description,
                                                           p_enabled_flag           => p_enabled_flag,
                                                           p_created_by             => 1,
                                                           p_other_company_use_flag => '',
                                                           p_expense_type_id        => v_expense_type_id);
  END;

  --帐套级报销类型关联费用项目
  PROCEDURE load_sob_expense_items(p_set_of_books_code VARCHAR2,
                                   p_expense_type_code VARCHAR2,
                                   p_expense_item_code VARCHAR2,
                                   p_enabled_flag      VARCHAR
                                   
                                   ) IS
    v_set_of_books_id NUMBER;
    v_expense_item_id NUMBER;
    v_description     VARCHAR2(1000);
    e_exception EXCEPTION;
    v_exp_sob_type_item_id NUMBER;
  BEGIN
    SELECT s.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books s
     WHERE s.set_of_books_code = p_set_of_books_code;
    SELECT t.expense_item_id
      INTO v_expense_item_id
      FROM exp_expense_items t
     WHERE t.set_of_books_id = v_set_of_books_id
       AND t.expense_item_code = p_expense_item_code;
  
    SELECT v.description
      INTO v_description
      FROM exp_sob_expense_types_vl v
     WHERE v.set_of_books_id = v_set_of_books_id
       AND v.expense_type_code = p_expense_type_code;
  
    IF (p_enabled_flag != 'Y' AND p_enabled_flag != 'N') THEN
      RAISE e_exception;
    END IF;
  
    BEGIN
      SELECT t.exp_sob_type_item_id
        INTO v_exp_sob_type_item_id
        FROM exp_sob_type_expense_items t
       WHERE t.expense_type_code = p_expense_type_code
         AND t.set_of_books_id = v_set_of_books_id
         AND t.expense_item_id = v_expense_item_id;
    EXCEPTION
      WHEN no_data_found THEN
        exp_sob_expense_types_pkg.insert_sob_expense_items(p_expense_type_code => p_expense_type_code,
                                                           p_expense_item_id   => v_expense_item_id,
                                                           p_set_of_books_id   => v_set_of_books_id,
                                                           p_enabled_flag      => p_enabled_flag,
                                                           p_description       => v_description,
                                                           p_user_id           => 1);
    END;
  
  END;

  -- 帐套级报销类型关联申请项目
  PROCEDURE load_sob_exp_req_items(p_set_of_books_code VARCHAR2,
                                   p_expense_type_code VARCHAR2,
                                   p_exp_req_item_code VARCHAR2,
                                   p_enabled_flag      VARCHAR2) IS
    v_set_of_books_id NUMBER;
    e_exception EXCEPTION;
    v_description              VARCHAR2(1000);
    v_req_item_id              NUMBER;
    v_exp_sob_type_req_item_id NUMBER;
  BEGIN
    SELECT s.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books s
     WHERE s.set_of_books_code = p_set_of_books_code;
  
    SELECT v.description
      INTO v_description
      FROM exp_sob_expense_types_vl v
     WHERE v.set_of_books_id = v_set_of_books_id
       AND v.expense_type_code = p_expense_type_code;
  
    SELECT v.req_item_id
      INTO v_req_item_id
      FROM exp_req_items_vl v
     WHERE v.set_of_books_id = v_set_of_books_id
       AND v.req_item_code = p_exp_req_item_code;
  
    IF (p_enabled_flag != 'Y' AND p_enabled_flag != 'N') THEN
      RAISE e_exception;
    END IF;
  
    BEGIN
      SELECT t.exp_sob_type_req_item_id
        INTO v_exp_sob_type_req_item_id
        FROM exp_sob_type_req_items t
       WHERE t.set_of_books_id = v_set_of_books_id
         AND t.expense_type_code = p_expense_type_code
         AND t.req_item_id = v_req_item_id;
    EXCEPTION
      WHEN no_data_found THEN
        exp_sob_expense_types_pkg.insert_sob_exp_req_items(p_expense_type_code => p_expense_type_code,
                                                           p_exp_req_item_id   => v_req_item_id,
                                                           p_set_of_books_id   => v_set_of_books_id,
                                                           p_enabled_flag      => p_enabled_flag,
                                                           p_description       => v_description,
                                                           p_user_id           => 1);
    END;
  
  END;
  --帐套级费用报销单关联付款用途
  PROCEDURE load_sob_report_type_usedes(p_expense_report_type_code VARCHAR2,
                                        p_usedes_code              VARCHAR2,
                                        p_primary_flag             VARCHAR2) IS
    v_expense_report_type_id NUMBER;
    v_usedes_id              NUMBER;
  
  BEGIN
  
    SELECT t.expense_report_type_id
      INTO v_expense_report_type_id
      FROM exp_sob_report_types t
     WHERE t.expense_report_type_code = p_expense_report_type_code;
    SELECT t.usedes_id
      INTO v_usedes_id
      FROM csh_payment_usedes t
     WHERE t.usedes_code = p_usedes_code;
    exp_sob_report_types_pkg.insert_exp_sob_rep_ref_usedes(p_expense_report_type_id => v_expense_report_type_id,
                                                           p_usedes_id              => v_usedes_id,
                                                           p_primary_flag           => p_primary_flag,
                                                           p_user_id                => 1);
  END load_sob_report_type_usedes;
  --帐套级费用报销单关联付款用途 --费用项目
  PROCEDURE load_sob_usedes_ref_expense(p_set_of_books_code        VARCHAR2,
                                        p_expense_report_type_code VARCHAR2,
                                        p_usedes_code              VARCHAR2,
                                        p_expense_item_code        VARCHAR2) IS
    v_expense_report_type_id NUMBER;
    v_set_of_books_id        NUMBER;
    v_usedes_id              NUMBER;
    v_expense_item_id        NUMBER;
  BEGIN
    SELECT s.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books s
     WHERE s.set_of_books_code = p_set_of_books_code;
  
    SELECT t.expense_report_type_id
      INTO v_expense_report_type_id
      FROM exp_sob_report_types t
     WHERE t.expense_report_type_code = p_expense_report_type_code;
  
    SELECT t.usedes_id
      INTO v_usedes_id
      FROM csh_payment_usedes t
     WHERE t.usedes_code = p_usedes_code;
  
    SELECT e.expense_item_id
      INTO v_expense_item_id
      FROM exp_expense_items e
     WHERE e.expense_item_code = p_expense_item_code
       AND e.set_of_books_id = v_set_of_books_id;
  
    INSERT INTO exp_sob_rep_pay_items_ref r
      (ref_id,
       usedes_id,
       expense_item_id,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       expense_report_type_id,
       set_of_book_id)
    VALUES
      (exp_sob_rep_pay_items_ref_s.nextval,
       v_usedes_id,
       v_expense_item_id,
       1,
       SYSDATE,
       1,
       SYSDATE,
       v_expense_report_type_id,
       v_set_of_books_id);
  END load_sob_usedes_ref_expense;

  --add by Qu yuanyuan 2015-11-24 导入部门定义——维度分配
  PROCEDURE load_unit_ref_dimensions(p_company_code           VARCHAR2,
                                     p_unit_code              VARCHAR2,
                                     p_dimension_code         VARCHAR2,
                                     p_default_dim_value_code VARCHAR2) IS
    v_company_id             NUMBER;
    v_unit_id                NUMBER;
    v_dimension_id           NUMBER;
    v_default_dim_value_id   NUMBER;
    v_default_dim_value_id_1 NUMBER;
    v_assign_id              NUMBER;
    v_dim_assign_id          NUMBER;
    v_data                   VARCHAR2(200);
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies
     WHERE company_code = p_company_code;
    SELECT unit_id
      INTO v_unit_id
      FROM exp_org_unit a
     WHERE a.company_id = v_company_id
       AND a.unit_code = p_unit_code;
    SELECT a.dimension_id
      INTO v_dimension_id
      FROM fnd_dimensions a
     WHERE a.dimension_code = p_dimension_code;
  
    IF p_default_dim_value_code IS NOT NULL THEN
      SELECT a.dimension_value_id
        INTO v_default_dim_value_id
        FROM fnd_dimension_values a
       WHERE a.dimension_id = v_dimension_id
         AND a.dimension_value_code = p_default_dim_value_code;
    END IF;
  
    SELECT COUNT(1)
      INTO g_exists
      FROM fnd_unit_dim_assign a
     WHERE a.unit_id = v_unit_id
       AND a.dimension_id = v_dimension_id;
    IF g_exists = 0 THEN
      SELECT fnd_unit_dim_assign_s.nextval INTO v_assign_id FROM dual;
      INSERT INTO fnd_unit_dim_assign
        (assign_id,
         unit_id,
         dimension_id,
         default_dimension_value_id,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date)
      VALUES
        (v_assign_id,
         v_unit_id,
         v_dimension_id,
         v_default_dim_value_id,
         1,
         SYSDATE,
         1,
         SYSDATE);
      INSERT INTO fnd_unit_dim_value_assign
        (assign_id,
         dim_assign_id,
         unit_id,
         dimension_id,
         dimension_value_id,
         default_flag,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date)
      VALUES
        (fnd_unit_dim_value_assign_s.nextval,
         v_assign_id,
         v_unit_id,
         v_dimension_id,
         v_default_dim_value_id,
         'Y',
         1,
         SYSDATE,
         1,
         SYSDATE);
    ELSE
      IF g_exists = 1 THEN
        SELECT f.assign_id, f.default_dimension_value_id
          INTO v_assign_id, v_default_dim_value_id_1
          FROM fnd_unit_dim_assign f
         WHERE f.unit_id = v_unit_id
           AND f.dimension_id = v_dimension_id;
        IF v_default_dim_value_id != v_default_dim_value_id_1 THEN
        
          FOR v_data IN (SELECT dimension_value_id
                           FROM fnd_unit_dim_value_assign
                          WHERE dim_assign_id = v_assign_id) LOOP
            IF v_data.dimension_value_id = v_default_dim_value_id_1 THEN
            
              UPDATE fnd_unit_dim_assign
                 SET dimension_id               = v_dimension_id,
                     default_dimension_value_id = v_default_dim_value_id_1,
                     last_updated_by            = 1,
                     last_update_date           = SYSDATE
               WHERE assign_id = v_assign_id;
            
              UPDATE fnd_unit_dim_value_assign
                 SET default_flag = 'N'
               WHERE dim_assign_id = v_assign_id
                 AND dimension_value_id != v_default_dim_value_id_1;
            
              UPDATE fnd_unit_dim_value_assign
                 SET default_flag = 'Y'
               WHERE dim_assign_id = v_assign_id
                 AND dimension_value_id = v_default_dim_value_id_1;
            END IF;
          END LOOP;
        
          UPDATE fnd_unit_dim_assign
             SET dimension_id               = v_dimension_id,
                 default_dimension_value_id = v_default_dim_value_id,
                 last_updated_by            = 1,
                 last_update_date           = SYSDATE
           WHERE assign_id = v_assign_id;
        
          SELECT fnd_unit_dim_value_assign_s.nextval
            INTO v_dim_assign_id
            FROM dual;
        
          INSERT INTO fnd_unit_dim_value_assign
            (assign_id,
             dim_assign_id,
             unit_id,
             dimension_id,
             dimension_value_id,
             default_flag,
             created_by,
             creation_date,
             last_updated_by,
             last_update_date)
          VALUES
            (v_dim_assign_id,
             v_assign_id,
             v_unit_id,
             v_dimension_id,
             v_default_dim_value_id,
             'Y',
             1,
             SYSDATE,
             1,
             SYSDATE);
        
          UPDATE fnd_unit_dim_value_assign
             SET default_flag = 'N'
           WHERE dim_assign_id = v_assign_id
             AND assign_id != v_dim_assign_id;
        END IF;
      END IF;
    END IF;
  
  END load_unit_ref_dimensions;
  --end by Qu yuanyuan 2015-11-24
  PROCEDURE load_wbc_dispatch_rule(p_dispatch_rule_code VARCHAR2,
                                   p_description        VARCHAR2,
                                   p_start_date         VARCHAR2,
                                   p_rule_flag          VARCHAR2) IS
  BEGIN
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM wbc_dispatch_rule a
               WHERE a.dispatch_rule_code = p_dispatch_rule_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    INSERT INTO wbc_dispatch_rule
      (dispatch_rule_id,
       dispatch_rule_code,
       description,
       start_date,
       rule_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (wbc_dispatch_rule_s.nextval,
       p_dispatch_rule_code,
       p_description,
       to_date(p_start_date, 'YYYY-MM-DD'),
       p_rule_flag,
       1,
       SYSDATE,
       1,
       SYSDATE);
  END;

  PROCEDURE load_wbc_rule_details(p_dispatch_rule_code    VARCHAR2,
                                  p_rule_parameter        VARCHAR2,
                                  p_and_or                VARCHAR2,
                                  p_filtrate_method       VARCHAR2,
                                  p_parameter_lower_limit VARCHAR2,
                                  p_parameter_upper_limit VARCHAR2,
                                  p_currency_code         VARCHAR2,
                                  p_invalid_date          VARCHAR2) IS
    v_dispatch_rule_id NUMBER;
    v_rule_description VARCHAR2(100);
  BEGIN
    SELECT wdr.dispatch_rule_id
      INTO v_dispatch_rule_id
      FROM wbc_dispatch_rule wdr
     WHERE wdr.dispatch_rule_code = p_dispatch_rule_code;
  
    SELECT wdrm.rule_parameter_description
      INTO v_rule_description
      FROM wbc_dispatch_rule_modules wdrm
     WHERE wdrm.rule_parameter_code = p_rule_parameter;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS
       (SELECT 1
                FROM wbc_dispatch_rule_details a
               WHERE a.dispatch_rule_id = v_dispatch_rule_id
                 AND a.rule_parameter = p_rule_parameter
                 AND a.and_or = p_and_or
                 AND a.filtrate_method = p_filtrate_method
                 AND a.parameter_lower_limit = p_parameter_lower_limit
                 AND a.parameter_upper_limit = p_parameter_upper_limit);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    INSERT INTO wbc_dispatch_rule_details
      (dispatch_rule_detail_id,
       dispatch_rule_id,
       rule_parameter,
       rule_description,
       and_or,
       filtrate_method,
       parameter_lower_limit,
       parameter_upper_limit,
       currency_code,
       invalid_date,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (wbc_dispatch_rule_details_s.nextval,
       v_dispatch_rule_id,
       p_rule_parameter,
       v_rule_description,
       p_and_or,
       p_filtrate_method,
       p_parameter_lower_limit,
       p_parameter_upper_limit,
       p_currency_code,
       to_date(p_invalid_date, 'YYYY-MM-DD'),
       1,
       SYSDATE,
       1,
       SYSDATE);
  END;

  PROCEDURE load_wbc_dispatch_operater(p_business_type_code     VARCHAR2,
                                       p_business_node_sequence NUMBER,
                                       p_work_team_code         VARCHAR2,
                                       p_employee_code          VARCHAR2,
                                       p_max_quan_per           NUMBER,
                                       p_enabled_flag           VARCHAR2) IS
    v_assign_id        NUMBER;
    v_business_node_id NUMBER;
    v_work_team_id     NUMBER;
    v_employee_id      NUMBER;
  
  BEGIN
    SELECT wbta.assign_id
      INTO v_assign_id
      FROM wbc_business_type_assign wbta
     WHERE wbta.business_type_code = p_business_type_code;
  
    SELECT wbn.business_node_id
      INTO v_business_node_id
      FROM wbc_business_nodes wbn
     WHERE wbn.assign_id = v_assign_id
       AND wbn.business_node_sequence = p_business_node_sequence;
  
    SELECT wwt.work_team_id
      INTO v_work_team_id
      FROM wbc_work_teams wwt
     WHERE wwt.work_team_code = p_work_team_code;
  
    SELECT e.employee_id
      INTO v_employee_id
      FROM exp_employees e
     WHERE e.employee_code = p_employee_code;
  
    INSERT INTO wbc_doc_dispatch_operater
      (doc_dispatch_operater_id,
       wbc_bus_doc_type_node_id,
       work_team_id,
       max_quan_per,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       employee_id)
    VALUES
      (wbc_doc_dispatch_operater_s.nextval,
       v_business_node_id,
       v_work_team_id,
       p_max_quan_per,
       p_enabled_flag,
       1,
       SYSDATE,
       1,
       SYSDATE,
       v_employee_id);
  END;

  PROCEDURE load_wbc_dispatch_line(p_business_type_code     VARCHAR2,
                                   p_business_node_sequence NUMBER,
                                   p_work_team_code         VARCHAR2,
                                   p_employee_code          VARCHAR2,
                                   p_dispatch_rule_code     VARCHAR2) IS
    v_assign_id                NUMBER;
    v_business_node_id         NUMBER;
    v_work_team_id             NUMBER;
    v_doc_dispatch_operater_id NUMBER;
    v_dispatch_rule_id         NUMBER;
    v_start_date               DATE;
    v_employee_id              NUMBER;
  
  BEGIN
    SELECT e.employee_id
      INTO v_employee_id
      FROM exp_employees e
     WHERE e.employee_code = p_employee_code;
  
    SELECT wbta.assign_id
      INTO v_assign_id
      FROM wbc_business_type_assign wbta
     WHERE wbta.business_type_code = p_business_type_code;
  
    SELECT wbn.business_node_id
      INTO v_business_node_id
      FROM wbc_business_nodes wbn
     WHERE wbn.assign_id = v_assign_id
       AND wbn.business_node_sequence = p_business_node_sequence;
  
    SELECT wwt.work_team_id
      INTO v_work_team_id
      FROM wbc_work_teams wwt
     WHERE wwt.work_team_code = p_work_team_code;
  
    SELECT wddo.doc_dispatch_operater_id
      INTO v_doc_dispatch_operater_id
      FROM wbc_doc_dispatch_operater wddo
     WHERE wddo.wbc_bus_doc_type_node_id = v_business_node_id
       AND wddo.work_team_id = v_work_team_id
       AND wddo.employee_id = v_employee_id;
  
    SELECT wdr.dispatch_rule_id, wdr.start_date
      INTO v_dispatch_rule_id, v_start_date
      FROM wbc_dispatch_rule wdr
     WHERE wdr.dispatch_rule_code = p_dispatch_rule_code;
  
    INSERT INTO wbc_doc_rule_dispatch
      (wbc_doc_rule_dispatch_id,
       doc_dispatch_operater_id,
       dispatch_rule_id,
       start_date,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (wbc_doc_rule_dispatch_s.nextval,
       v_doc_dispatch_operater_id,
       v_dispatch_rule_id,
       v_start_date,
       1,
       SYSDATE,
       1,
       SYSDATE);
  END;

  --银行账号导入
  PROCEDURE load_account_info(p_company_code     VARCHAR2, --公司代码
                              p_bank_account     VARCHAR2, --账号
                              p_account_name     VARCHAR2, --账户名称
                              p_branch_bank      VARCHAR2, --连行号
                              p_segment2         VARCHAR2, --责任中心代码
                              p_segment3         VARCHAR2, --科目
                              p_segment4         VARCHAR2, --明细
                              p_account_property VARCHAR2 -- 账户类型
                              ) IS
    v_bcdl_bank_num bcdl_bank_num%ROWTYPE;
    v_account_id    NUMBER;
    v_company_id    NUMBER;
  BEGIN
    dbms_output.put_line(p_branch_bank);
    SELECT *
      INTO v_bcdl_bank_num
      FROM bcdl_bank_num b
     WHERE b.bank_num = p_branch_bank;
  
    SELECT fc.company_id
      INTO v_company_id
      FROM fnd_companies fc
     WHERE fc.company_code = p_company_code;
  
    cp_account_info_pkg.insert_account_info(p_account_id       => v_account_id,
                                            p_company_id       => v_company_id,
                                            p_bank_account     => p_bank_account,
                                            p_account_name     => p_account_name,
                                            p_open_bank        => v_bcdl_bank_num.belong_bank_value,
                                            p_branch_bank      => p_branch_bank,
                                            p_open_province    => v_bcdl_bank_num.prov_code,
                                            p_open_city        => v_bcdl_bank_num.city_code,
                                            p_currency         => 'CNY',
                                            p_segment2         => p_segment2,
                                            p_segment3         => p_segment3,
                                            p_segment4         => p_segment4,
                                            p_status           => 'NORMAL',
                                            p_user_id          => 1,
                                            p_account_property => p_account_property);
  
  END load_account_info;

  --系统级供应商->公司级供应商
  PROCEDURE load_venders(p_company_code       VARCHAR2,
                         p_vender_type_code   VARCHAR2,
                         p_vender_code        VARCHAR2,
                         p_vender_name        VARCHAR2,
                         p_vender_description VARCHAR2,
                         p_enabled_flag       VARCHAR2) IS
  
    v_vender_type_id NUMBER;
    v_company_id     NUMBER;
    v_vender_id      NUMBER;
    v_exists         NUMBER;
  BEGIN
    SELECT pvt.vender_type_id
      INTO v_vender_type_id
      FROM pur_vender_types_vl pvt
     WHERE pvt.enabled_flag = 'Y'
       AND pvt.vender_type_code = p_vender_type_code;
  
    SELECT t.company_id
      INTO v_company_id
      FROM fnd_companies t
     WHERE t.company_code = p_company_code;
  
    /*    SELECT COUNT(1)
      INTO v_exists
      FROM pur_system_venders_vl psv
     WHERE psv.description = p_vender_name;
    --供应商名称存在，插公司级
    IF v_exists > 0 THEN
      SELECT psv.vender_id
        INTO v_vender_id
        FROM pur_system_venders_vl psv
       WHERE psv.description = p_vender_name;
    
      BEGIN
        --公司级存在，return
        SELECT 1
          INTO g_exists
          FROM dual
         WHERE EXISTS (SELECT 1
                  FROM pur_company_venders a
                 WHERE a.company_id = v_company_id
                   AND a.vender_id = v_vender_id);
        RETURN;
      EXCEPTION
        WHEN no_data_found THEN
          --公司级不存在，插公司级，return
          INSERT INTO pur_company_venders v
            (company_id,
             vender_id,
             payment_term_id,
             payment_method,
             currency_code,
             tax_type_id,
             approved_vender_flag,
             enabled_flag,
             created_by,
             creation_date,
             last_updated_by,
             last_update_date)
          VALUES
            (v_company_id,
             v_vender_id,
             NULL,
             NULL,
             NULL,
             NULL,
             NULL,
             'Y',
             1,
             SYSDATE,
             1,
             SYSDATE);
          RETURN;
      END;
    END IF;*/
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM pur_system_venders a
               WHERE a.vender_code = p_vender_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        null;
    end;
  
    if p_vender_code = 'ZV11' then
      --供应商名称不存在，先插系统级供应商，再插公司级
      pur_system_venders_pkg.load_pur_system_venders(p_vender_code          => '16' ||
                                                                               p_vender_code,
                                                     p_description          => p_vender_name,
                                                     p_address              => NULL,
                                                     p_artificial_person    => NULL,
                                                     p_tax_id_number        => NULL,
                                                     p_bank_branch_code     => NULL,
                                                     p_bank_account_code    => NULL,
                                                     p_enabled_flag         => 'Y',
                                                     p_created_by           => 1,
                                                     p_company_id           => v_company_id,
                                                     p_vender_type_id       => v_vender_type_id,
                                                     p_payment_term_id      => NULL,
                                                     p_payment_method       => NULL,
                                                     p_vender_id            => v_vender_id,
                                                     p_currency_code        => NULL,
                                                     p_tax_type_id          => NULL,
                                                     p_approved_vender_flag => NULL --,
                                                     --p_vender_description   => p_vender_description
                                                     );
    else
      --供应商名称不存在，先插系统级供应商，再插公司级
      pur_system_venders_pkg.insert_pur_system_venders(p_vender_code          => p_vender_code,
                                                       p_description          => p_vender_name,
                                                       p_address              => NULL,
                                                       p_artificial_person    => NULL,
                                                       p_tax_id_number        => NULL,
                                                       p_bank_branch_code     => NULL,
                                                       p_bank_account_code    => NULL,
                                                       p_enabled_flag         => 'Y',
                                                       p_created_by           => 1,
                                                       p_company_id           => v_company_id,
                                                       p_vender_type_id       => v_vender_type_id,
                                                       p_payment_term_id      => NULL,
                                                       p_payment_method       => NULL,
                                                       p_vender_id            => v_vender_id,
                                                       p_currency_code        => NULL,
                                                       p_tax_type_id          => NULL,
                                                       p_approved_vender_flag => NULL --,
                                                       --p_vender_description   => p_vender_description
                                                       );
    end if;
  END;

  --公司级供应商银行账户
  PROCEDURE load_pur_vender_accounts(p_line_number    VARCHAR2,
                                     p_vender_code    VARCHAR2,
                                     p_vender_name    VARCHAR2,
                                     p_bank_code      VARCHAR2,
                                     p_province_name  VARCHAR2,
                                     p_city_name      VARCHAR2,
                                     p_account_number VARCHAR2,
                                     p_account_name   VARCHAR2,
                                     p_notes          VARCHAR2,
                                     p_primary_flag   VARCHAR2,
                                     p_enabled_flag   VARCHAR2) IS
  
    v_vender_id     NUMBER;
    v_count         NUMBER;
    v_bank_name     VARCHAR2(1000);
    v_province_code VARCHAR2(100);
    v_city_code     VARCHAR2(100);
    v_bcdl_bank_num bcdl_bank_num%ROWTYPE;
  BEGIN
  
    SELECT t.vender_id
      INTO v_vender_id
      FROM pur_system_venders t
     WHERE t.vender_code = p_vender_code;
  
    /* SELECT *
     INTO v_bcdl_bank_num
     FROM bcdl_bank_num bbn
    WHERE bbn.bank_num = p_bank_code;*/
  
    SELECT COUNT(*)
      INTO v_count
      FROM pur_vender_accounts t
     WHERE t.vender_id = v_vender_id
       AND t.line_number = p_line_number;
    IF v_count != 0 THEN
      RETURN;
    END IF;
  
    /*    SELECT t.bank_name
      INTO v_bank_name
      FROM csh_banks_vl t
     WHERE t.enabled_flag = 'Y'
       AND t.bank_code = p_bank_code;
    
    SELECT dv.district_code
      INTO v_province_code
      FROM exp_policy_districts_vl dv
     WHERE dv.district_desc = p_province_name;
    SELECT pv.place_code
      INTO v_city_code
      FROM exp_policy_districts_vl dv, exp_policy_places_vl pv
     WHERE pv.district_id = dv.district_id
       AND pv.enabled_flag = 'Y'
       AND dv.district_code = v_province_code
       AND pv.place_desc = p_city_name;*/
  
    /*pur_vender_items_pkg.insert_vender_bank_assigns(p_vender_id          => v_vender_id,
    p_line_number        => p_line_number,
    p_bank_code          => v_bcdl_bank_num.belong_bank_value,
    p_bank_name          => v_bcdl_bank_num.belong_bank_name,
    p_bank_location_code => p_bank_code,
    p_bank_location      => v_bcdl_bank_num.bank_name,
    p_province_code      => v_bcdl_bank_num.prov_code,
    p_province_name      => v_bcdl_bank_num.prov_name,
    p_city_code          => v_bcdl_bank_num.city_code,
    p_city_name          => v_bcdl_bank_num.city_name,
    p_account_number     => p_account_number,
    p_account_name       => p_account_name,
    p_notes              => p_notes,
    p_primary_flag       => p_primary_flag,
    p_enabled_flag       => p_enabled_flag,
    p_user_id            => 1,
    p_sparticipantbankno => p_bank_code,
    p_account_flag       => '10');*/
  
    pur_vender_items_pkg.insert_vender_bank_assigns(p_vender_id          => v_vender_id,
                                                    p_line_number        => p_line_number,
                                                    p_bank_code          => p_bank_code,
                                                    p_bank_name          => '',
                                                    p_bank_location_code => p_bank_code,
                                                    p_bank_location      => '',
                                                    p_province_code      => '',
                                                    p_province_name      => p_province_name,
                                                    p_city_code          => '',
                                                    p_city_name          => p_city_name,
                                                    p_account_number     => p_account_number,
                                                    p_account_name       => p_account_name,
                                                    p_notes              => p_notes,
                                                    p_primary_flag       => p_primary_flag,
                                                    p_enabled_flag       => p_enabled_flag,
                                                    p_user_id            => 1,
                                                    p_sparticipantbankno => '',
                                                    p_account_flag       => '10');
  
    /*  pur_system_venders_pkg.insert_into_pur_accounts(p_vender_id          => v_vender_id,
    p_line_number        => p_line_number,
    p_bank_code          => p_bank_code,
    p_bank_name          => v_bank_name,
    p_bank_location_code => '',
    p_bank_location      => '',
    p_province_code      => v_province_code,
    p_province_name      => p_province_name,
    p_city_code          => v_city_code,
    p_city_name          => p_city_name,
    p_account_number     => p_account_number,
    p_account_name       => p_account_name,
    p_notes              => p_notes,
    p_primary_flag       => p_primary_flag,
    p_enabled_flag       => p_enabled_flag,
    p_pc_flag            => 'CB',
    p_user_id            => 1);*/
  
  EXCEPTION
    WHEN no_data_found THEN
      dbms_output.put_line(p_bank_code);
  END;

  -- 加载银行账号
  PROCEDURE load_employee_accounts(p_employee_code      VARCHAR2,
                                   p_bank_location_code VARCHAR2,
                                   p_account_number     VARCHAR2,
                                   p_account_name       VARCHAR2) IS
    v_exp_employees exp_employees%ROWTYPE;
    v_bcdl_bank_num bcdl_bank_num%ROWTYPE;
  BEGIN
    /*    SELECT *
     INTO v_exp_employees
     FROM exp_employees ee
    WHERE ee.employee_code = p_employee_code;*/
  
    BEGIN
      SELECT *
        INTO v_bcdl_bank_num
        FROM bcdl_bank_num bbn
       WHERE bbn.bank_num = p_bank_location_code;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    UPDATE exp_employee_accounts eea
       SET eea.bank_code          = v_bcdl_bank_num.belong_bank_value,
           eea.bank_name          = v_bcdl_bank_num.belong_bank_name,
           eea.bank_location_code = p_bank_location_code,
           eea.sparticipantbankno = p_bank_location_code,
           eea.bank_location      = v_bcdl_bank_num.bank_name,
           eea.province_code      = v_bcdl_bank_num.prov_code,
           eea.province_name      = v_bcdl_bank_num.prov_name,
           eea.city_code          = v_bcdl_bank_num.city_code,
           eea.city_name          = v_bcdl_bank_num.city_name
     WHERE eea.account_number = p_account_number
       AND eea.employee_id =
           (SELECT ee.employee_id
              FROM exp_employees ee
             WHERE ee.employee_code = p_employee_code);
  
    /*    exp_employees_pkg.insert_exp_bank_assigns(p_employee_id        => v_exp_employees.employee_id,
    p_line_number        => '10',
    p_bank_code          => v_bcdl_bank_num.belong_bank_value,
    p_bank_name          => v_bcdl_bank_num.belong_bank_name,
    p_bank_location_code => v_bcdl_bank_num.bank_num,
    p_bank_location      => v_bcdl_bank_num.bank_name,
    p_province_code      => v_bcdl_bank_num.prov_code,
    p_province_name      => v_bcdl_bank_num.prov_name,
    p_city_code          => v_bcdl_bank_num.city_code,
    p_city_name          => v_bcdl_bank_num.city_name,
    p_account_number     => p_account_number,
    p_account_name       => p_account_name,
    p_notes              => '',
    p_primary_flag       => 'Y',
    p_enabled_flag       => 'Y',
    p_user_id            => 1,
    p_sparticipantbankno => v_bcdl_bank_num.bank_num,
    p_account_flag       => '20',
    p_edit_flag          => 'N');*/
  END load_employee_accounts;

  --加载供应商维护供应商
  PROCEDURE load_wlzq_venders(p_vender_code  VARCHAR2,
                              p_company_code VARCHAR2,
                              p_unit_code    VARCHAR2) IS
    v_company_id    NUMBER;
    v_unit_id       NUMBER;
    v_exists        VARCHAR2(1);
    v_venders       pur_system_venders%ROWTYPE;
    v_accounts      pur_vender_accounts%ROWTYPE;
    v_sys_vender_id NUMBER;
    v_vender_id     NUMBER;
  BEGIN
    SELECT f.company_id
      INTO v_company_id
      FROM fnd_companies f
     WHERE f.company_code = p_company_code;
  
    SELECT p.vender_id
      INTO v_sys_vender_id
      FROM pur_system_venders p
     WHERE p.vender_code = p_vender_code;
  
    SELECT e.unit_id
      INTO v_unit_id
      FROM exp_org_unit e
     WHERE e.unit_code = p_unit_code
       AND e.company_id = v_company_id;
  
    SELECT *
      INTO v_venders
      FROM pur_system_venders p
     WHERE p.vender_code = p_vender_code;
    BEGIN
      SELECT p.vender_id
        INTO v_vender_id
        FROM pur_wlzq_venders p
       WHERE p.vender_code = p_vender_code
         AND p.unit_id = v_unit_id;
    EXCEPTION
      WHEN no_data_found THEN
        INSERT INTO pur_wlzq_venders
          (vender_id,
           vender_code,
           vender_type_id,
           description_id,
           address,
           artificial_person,
           tax_id_number,
           bank_branch_code,
           bank_account_code,
           payment_term_id,
           payment_method,
           currency_code,
           tax_type_id,
           tax_number,
           approved_vender_flag,
           enabled_flag,
           created_by,
           creation_date,
           last_updated_by,
           last_update_date,
           company_id,
           unit_id)
        VALUES
          (pur_wlzq_venders_s.nextval,
           v_venders.vender_code,
           v_venders.vender_type_id,
           v_venders.description_id,
           v_venders.address,
           v_venders.artificial_person,
           v_venders.tax_id_number,
           v_venders.bank_branch_code,
           v_venders.bank_account_code,
           v_venders.payment_term_id,
           v_venders.payment_method,
           v_venders.currency_code,
           v_venders.tax_type_id,
           v_venders.tax_id_number,
           v_venders.approved_vender_flag,
           v_venders.enabled_flag,
           1,
           SYSDATE,
           1,
           SYSDATE,
           v_company_id,
           v_unit_id) RETURN vender_id INTO v_vender_id;
    END;
    --插银行账户
    FOR cur_accounts IN (SELECT *
                           FROM pur_vender_accounts p
                          WHERE p.vender_id = v_sys_vender_id) LOOP
    
      pur_wlzq_vender_pkg.insert_vender_bank_assigns(p_vender_id          => v_vender_id,
                                                     p_line_number        => cur_accounts.line_number,
                                                     p_bank_code          => cur_accounts.bank_code,
                                                     p_bank_name          => cur_accounts.bank_name,
                                                     p_bank_location_code => cur_accounts.bank_location_code,
                                                     p_bank_location      => cur_accounts.bank_location,
                                                     p_province_code      => cur_accounts.province_code,
                                                     p_province_name      => cur_accounts.province_name,
                                                     p_city_code          => cur_accounts.city_code,
                                                     p_city_name          => cur_accounts.city_name,
                                                     p_account_number     => cur_accounts.account_number,
                                                     p_account_name       => cur_accounts.account_name,
                                                     p_notes              => cur_accounts.notes,
                                                     p_primary_flag       => cur_accounts.primary_flag,
                                                     p_enabled_flag       => cur_accounts.enabled_flag,
                                                     p_user_id            => 1,
                                                     p_sparticipantbankno => cur_accounts.sparticipantbankno,
                                                     p_account_flag       => cur_accounts.account_flag);
    END LOOP;
    UPDATE pur_wlzq_ve_accounts p
       SET p.status = 'P'
     WHERE p.vender_id = v_vender_id;
  END;

  --加载批扣流水规则
  PROCEDURE load_cp_batch_cut_rule(p_description              VARCHAR2,
                                   p_payment_bank_account     VARCHAR2,
                                   p_gather_bank_account      VARCHAR2,
                                   p_gather_bank_account_name VARCHAR2,
                                   p_summary                  VARCHAR2,
                                   p_position_code            VARCHAR2) IS
    v_company_id  NUMBER;
    v_position_id NUMBER;
  BEGIN
    SELECT f.company_id
      INTO v_company_id
      FROM am_account_info a, fnd_companies f
     WHERE a.bank_account = p_payment_bank_account
       AND f.company_code = a.segment1;
  
    SELECT position_id
      INTO v_position_id
      FROM exp_org_position p
     WHERE p.position_code = p_position_code
       AND p.company_id = v_company_id;
  
    INSERT INTO cp_batch_cut_rule
      (cp_batch_cut_rule_id,
       payment_bank_account,
       gather_bank_account,
       summary,
       position_id,
       payment_company_id,
       gather_bank_account_name,
       description,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (cp_batch_cut_rule_s.nextval,
       p_payment_bank_account,
       p_gather_bank_account,
       p_summary,
       v_position_id,
       v_company_id,
       p_gather_bank_account_name,
       p_description,
       1,
       SYSDATE,
       1,
       SYSDATE);
  END;

  --银行未达导入
  PROCEDURE load_bank_deposit_details(p_voucher_no   VARCHAR2, --凭证号
                                      p_voucher_date VARCHAR2, --凭证日期
                                      p_subjet       VARCHAR2, -- 科目
                                      p_bank_account VARCHAR2,
                                      p_sub_subject  VARCHAR2, --明细
                                      p_organ_code   VARCHAR2, --公司代码
                                      p_organ_name   VARCHAR2, --公司名称
                                      p_account_name VARCHAR2, --账户名称
                                      p_currency     VARCHAR2, --币种
                                      p_amount       NUMBER, --金额
                                      p_direction    VARCHAR2, --借贷方向
                                      p_memo         VARCHAR2 --摘要
                                      ) IS
    v_account_info am_account_info%ROWTYPE;
    v_org_name     VARCHAR2(100);
  BEGIN
    dbms_output.put_line(p_bank_account);
  
    /*  SELECT *
    INTO v_account_info
    FROM am_account_info aai
    WHERE aai.segment4  = p_sub_subject;
    
    dbms_output.put_line(p_organ_code);
    
    select fc.COMPANY_SHORT_NAME
    INTO v_org_name
    from fnd_companies_vl fc
    where fc.COMPANY_CODE = p_organ_code;
    
    
    
            --将数据插入表中
      INSERT INTO bank_deposit_details
        (id,
         voucherno,
         voucherdate,
         subject,
         subjectdetail,
         orgcode,
         orgname,
         accountname,
         bankname,
         modifierid,
         checker,
         SOURCE,
         currency,
         amount,
         dirction,
         memo,
         serial_num)
      VALUES
        (--c_core.interface_id,
         SYS_GUID(),
         nvl(p_VOUCHER_NO,'-'),
         to_date(p_voucher_date,'yyyy-mm-dd'),
         v_account_info.segment3, --syn_deposit.subject,
         v_account_info.segment4,
         p_organ_code,
         v_org_name,
         null,
         '',
         '', --syn_deposit.modifierid,--todo
         '', --syn_deposit.checker,--todo
         '', --syn_deposit.source,--todo
         p_currency,
         p_amount,
         p_direction,
         p_memo,
         null);              */
  END load_bank_deposit_details;

  PROCEDURE load_exp_rep_policy(p_priority             VARCHAR2, --优先级
                                p_description          VARCHAR2, --描述
                                p_company_level_code   VARCHAR2, --公司级别代码
                                p_level1_unit_code     VARCHAR2, --一级投行部门代码
                                p_control_type_code    VARCHAR2, --控制类型代码
                                p_req_item_code        VARCHAR2, --费用项目
                                p_place_code           VARCHAR2, --费用发生地代码
                                p_place_type_code      VARCHAR2, --费用发生地类型代码
                                p_transportation       VARCHAR2, --交通工具
                                p_job_code             VARCHAR2, --职务代码
                                p_position_code        VARCHAR2, --岗位代码
                                p_employee_levels_code VARCHAR2, --员工级别
                                p_currency_code        VARCHAR2, --币种 CNY
                                p_expense_standard     NUMBER, --费用标砖
                                p_upper_limit          NUMBER, --费用上限
                                p_lower_limit          NUMBER, --费用下限
                                p_commit_flag          VARCHAR2, --超标准能否提交
                                p_upper_std_event_name VARCHAR2, --超标准事件
                                p_event_name           VARCHAR2, --上下限事件
                                p_start_date           VARCHAR2, --开始时间
                                p_end_date             VARCHAR2 --结束时间
                                ) IS
    v_company_level_id    NUMBER;
    v_req_item_id         NUMBER;
    v_employee_level_id   NUMBER;
    v_expense_policies_id NUMBER;
    v_place_type_id       NUMBER;
  
    v_expense_address VARCHAR2(40);
    v_place_id        NUMBER;
    v_job_id          NUMBER;
    v_position_id     NUMBER;
    v_level1_unit_id  NUMBER;
  BEGIN
    BEGIN
      SELECT eppt.place_type_id
        INTO v_place_type_id
        FROM exp_policy_place_types eppt
       WHERE eppt.place_type_code = p_place_type_code;
    EXCEPTION
      WHEN no_data_found THEN
        v_place_type_id := NULL;
    END;
  
    BEGIN
      SELECT fcl.company_level_id
        INTO v_company_level_id
        FROM fnd_company_levels fcl
       WHERE fcl.company_level_code = p_company_level_code;
    END;
    BEGIN
      SELECT eri.expense_item_id
        INTO v_req_item_id
        FROM exp_expense_items eri
       WHERE eri.expense_item_code = p_req_item_code;
    EXCEPTION
      WHEN no_data_found THEN
        v_req_item_id := NULL;
    END;
    BEGIN
      SELECT eel.employee_levels_id
        INTO v_employee_level_id
        FROM exp_employee_levels eel
       WHERE eel.employee_levels_code = p_employee_levels_code;
    EXCEPTION
      WHEN no_data_found THEN
        v_employee_level_id := NULL;
    END;
  
    BEGIN
      SELECT epp.place_id, epp.place_desc
        INTO v_place_id, v_expense_address
        FROM exp_policy_places_vl epp
       WHERE epp.place_code = p_place_code;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    BEGIN
      SELECT eej.employee_job_id
        INTO v_job_id
        FROM exp_employee_jobs eej
       WHERE eej.employee_job_code = p_job_code;
    
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    BEGIN
      SELECT eop.position_id
        INTO v_position_id
        FROM exp_org_position eop
       WHERE eop.position_code = p_position_code;
    
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    BEGIN
      SELECT eou.unit_id
        INTO v_level1_unit_id
        FROM exp_org_unit eou
       WHERE eou.unit_code = p_level1_unit_code;
    
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    exp_expense_policies_pkg.insert_exp_expense_policies(p_priority             => p_priority,
                                                         p_company_level_id     => v_company_level_id,
                                                         p_expense_item_id      => v_req_item_id,
                                                         p_expense_address      => v_expense_address,
                                                         p_job_id               => v_job_id,
                                                         p_position_id          => v_position_id,
                                                         p_employee_levels_id   => v_employee_level_id,
                                                         p_default_flag         => NULL,
                                                         p_currency_code        => p_currency_code,
                                                         p_expense_standard     => p_expense_standard,
                                                         p_upper_limit          => p_upper_limit,
                                                         p_lower_limit          => p_lower_limit,
                                                         p_changeable_flag      => NULL,
                                                         p_start_date           => to_date(p_start_date,
                                                                                           'yyyy-mm-dd'),
                                                         p_end_date             => to_date(p_end_date,
                                                                                           'yyyy-mm-dd'),
                                                         p_commit_flag          => p_commit_flag,
                                                         p_event_name           => p_event_name,
                                                         p_user_id              => 1,
                                                         p_expense_policies_id  => v_expense_policies_id,
                                                         p_place_type_id        => v_place_type_id,
                                                         p_place_id             => v_place_id,
                                                         p_transportation       => p_transportation,
                                                         p_upper_std_event_name => p_upper_std_event_name,
                                                         p_control_type_code    => p_control_type_code,
                                                         p_level1_unit_id       => v_level1_unit_id,
                                                         p_description          => p_description);
  
  END load_exp_rep_policy;

  --导入企业未达
  PROCEDURE load_erp_account_check(p_voucher_no      VARCHAR2, --凭证标号
                                   p_voucher_date    VARCHAR2, --凭证日期
                                   p_subject         VARCHAR2, --科目,
                                   p_subjectd_detail VARCHAR2, --科目明细
                                   p_account_number  VARCHAR2, --银行账号
                                   p_account_name    VARCHAR2, --户名
                                   p_debit_amount    NUMBER, --借方金额
                                   p_credit_amount   NUMBER, --贷方金额
                                   p_memo            VARCHAR2 --描述
                                   ) IS
    v_account_info am_account_info%ROWTYPE;
    v_com_info     fnd_companies_vl%ROWTYPE;
    v_dirction     VARCHAR2(10);
    v_amount       NUMBER;
  BEGIN
    SELECT *
      INTO v_account_info
      FROM am_account_info aai
     WHERE aai.bank_account = p_account_number;
  
    SELECT *
      INTO v_com_info
      FROM fnd_companies_vl fc
     WHERE fc.company_code = v_account_info.open_organ;
  
    IF (nvl(p_debit_amount, 0) - nvl(p_credit_amount, 0) > 0) THEN
      v_amount   := nvl(p_debit_amount, 0) - nvl(p_credit_amount, 0);
      v_dirction := '1';
    ELSE
      v_amount   := nvl(p_credit_amount, 0) - nvl(p_debit_amount, 0);
      v_dirction := '2';
    END IF;
  
    INSERT INTO cp_bank_deposit_details
      (cp_bank_deposit_details_id,
       voucher_no,
       voucher_date,
       subject,
       subjectd_detail,
       orgcode,
       orgname,
       bank_account,
       bank_account_name,
       bankname,
       SOURCE,
       currency,
       amount,
       dirction,
       memo,
       serial_num,
       other_name)
    VALUES
      (cp_bank_deposit_details_s.nextval,
       p_voucher_no,
       to_date(p_voucher_date, 'yyyy-mm-dd'),
       p_subject, -- 科目
       v_account_info.segment4,
       v_account_info.open_organ,
       v_com_info.company_short_name, --
       p_account_number,
       p_account_name, --
       v_account_info.open_bank, --
       '报账通系统',
       'CNY',
       v_amount,
       v_dirction,
       p_memo,
       '',
       '');
  
  END load_erp_account_check;

  --给部门分配岗位
  PROCEDURE load_org_position_unit(p_unit_code VARCHAR2,
                                   p_org_name  VARCHAR2) IS
    v_unit_id       NUMBER;
    v_num           NUMBER;
    v_position_code VARCHAR2(100);
    v_position_id   NUMBER;
    v_unit_desc     VARCHAR2(300);
    v_description   VARCHAR2(300);
  BEGIN
    SELECT a.unit_id
      INTO v_unit_id
      FROM exp_org_unit a
     WHERE a.company_id = 835
       AND a.unit_code = p_unit_code;
  
    SELECT e.description
      INTO v_unit_desc
      FROM exp_org_unit_vl e
     WHERE e.unit_code = p_unit_code;
  
    v_description := '总公司' || v_unit_desc || p_org_name;
    SELECT MAX(p.position_code)
      INTO v_position_code
      FROM exp_org_position p;
    v_num := to_number(substr(v_position_code,
                              length(v_position_code) - 2,
                              length(v_position_code))) + 1;
  
    v_position_code := substr(v_position_code, 0, 4) || v_num;
  
    exp_org_position_pkg.insert_org_position(p_unit_id            => v_unit_id,
                                             p_position_code      => v_position_code,
                                             p_description        => p_org_name,
                                             p_parent_position_id => NULL,
                                             p_company_id         => 835,
                                             p_enabled_flag       => 'Y',
                                             p_created_by         => 1,
                                             p_language_code      => 'ZHS',
                                             p_employee_job_id    => NULL,
                                             p_position_id        => v_position_id);
  END;

  --费用项目关联报销类型关联保险单
  PROCEDURE load_type(p_set_of_books_code        VARCHAR2,
                      p_expense_report_type_code VARCHAR2,
                      p_expense_type_code        VARCHAR2,
                      p_expense_item_code        VARCHAR2,
                      p_item_category            VARCHAR2) IS
    v_set_of_books_id            NUMBER;
    v_expense_report_type_id     NUMBER;
    v_expense_report_ref_type_id NUMBER;
  BEGIN
  
    SELECT s.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books s
     WHERE s.set_of_books_code = p_set_of_books_code;
  
    SELECT e.expense_report_type_id
      INTO v_expense_report_type_id
      FROM exp_sob_report_types e
     WHERE e.set_of_books_id = v_set_of_books_id
       AND e.expense_report_type_code = p_expense_report_type_code;
  
    SELECT esrrt.expense_report_ref_type_id
      INTO v_expense_report_ref_type_id
      FROM exp_sob_report_ref_types esrrt, exp_sob_report_types esrt
     WHERE esrt.expense_report_type_id = esrrt.expense_report_type_id
       AND esrrt.expense_type_code = p_expense_type_code
       AND esrt.expense_report_type_code = p_expense_report_type_code;
  
    exp_sob_report_types_pkg.insert_exp_sob_ref_types_item(p_expense_item_code         => p_expense_item_code,
                                                           p_expense_type_ref_id       => v_expense_report_ref_type_id,
                                                           p_item_category             => p_item_category,
                                                           p_unified_order_flag        => 'N',
                                                           p_centralized_clearing_flag => 'N',
                                                           p_user_id                   => 1);
  END;

  --sap功能范围值
  procedure load_gl_account_entry_function(p_commit_items_code varchar2,
                                           p_account_code      varchar2,
                                           p_function_envelop  varchar2) is
  begin
    begin
      --范围存在
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM gl_account_entry_function g
               WHERE g.commit_items_code = p_commit_items_code
                 and g.account_code = p_account_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        null;
    end;
  
    insert into gl_account_entry_function
    values
      (entry_function_s.nextval,
       p_commit_items_code,
       p_account_code,
       p_function_envelop,
       sysdate,
       1,
       sysdate,
       1);
  end;

END exp_data_load_pkg;
/
