CREATE OR REPLACE PACKAGE data_load_pkg IS

  -- Author  : WANGXIAOQIAN
  -- Created : 16-4月-18 17:09:49
  -- Purpose : 

  PROCEDURE load_sys_role(p_role_code   VARCHAR2,
                          p_role_name   VARCHAR2,
                          p_description VARCHAR2);

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
                          p_user_name          VARCHAR2,
                          p_company_code       VARCHAR2);

  PROCEDURE load_account(p_account_set_code   VARCHAR2,
                         p_account_code       VARCHAR2,
                         p_description        VARCHAR2,
                         p_account_type       VARCHAR2,
                         p_enabled_flag       VARCHAR2,
                         p_summary_flag       VARCHAR2,
                         p_cashflow_flag      VARCHAR2 DEFAULT NULL,
                         p_inter_flag         VARCHAR2 DEFAULT NULL,
                         p_tax_flag           VARCHAR2 DEFAULT NULL,
                         p_expense_account    VARCHAR2 DEFAULT NULL,
                         p_receivable_account VARCHAR2 DEFAULT NULL,
                         p_asset_account      VARCHAR2 DEFAULT NULL);
  PROCEDURE load_segments(p_set_of_books_code VARCHAR2,
                          p_segment_code      VARCHAR2,
                          p_segment_name      VARCHAR2,
                          p_segment_field     VARCHAR2,
                          p_segment_type      VARCHAR2,
                          p_default_text      VARCHAR2,
                          p_enabled_flag      VARCHAR2,
                          p_sql_query         VARCHAR2);

  PROCEDURE load_segments_source(p_segment_code      VARCHAR2,
                                 p_document_category VARCHAR2,
                                 p_value_table       VARCHAR2,
                                 p_value_item        VARCHAR2,
                                 p_enabled_flag      VARCHAR2);

  PROCEDURE load_exp_ygz_input_tax_struc(p_type_code                  VARCHAR2,
                                         p_type_name                  VARCHAR2,
                                         p_tax_rate                   NUMBER,
                                         p_input_tax_account          VARCHAR2,
                                         p_input_tax_transfer_account VARCHAR2,
                                         p_enabled_flag               VARCHAR2);
  PROCEDURE load_employee_account(p_employee_code      VARCHAR2,
                                  p_bank_account       VARCHAR2,
                                  p_same_city_flag     VARCHAR2,
                                  p_same_bank_flag     VARCHAR2,
                                  p_sparticipantbankno VARCHAR2);
  PROCEDURE load_unit_charge_manager(p_unit_code            VARCHAR2,
                                     p_leader_position_code VARCHAR2);
  PROCEDURE check_budget_item(p_item_code VARCHAR2);

  PROCEDURE load_org_unit(p_unit_code                  VARCHAR2,
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
  --更改抵扣规则
  PROCEDURE load_ded_rule_desc(p_expense_item_desc VARCHAR2,
                               p_ded_rule_desc     VARCHAR2);
  ----------------------------------------------------
  --更改预算项目类型
  ----------------------------------------------------
  PROCEDURE update_budget_item_types(p_item VARCHAR2, p_type VARCHAR2);
  -----------------------------------------------------------------------
  --更改岗位描述
  --参数一：要替换的岗位描述
  --参数二：替换后的岗位描述
  -----------------------------------------------------------------------
  PROCEDURE update_exp_org_position(p_description         VARCHAR2,
                                    p_replace_description VARCHAR2);
  --帐套级责任中心定义
  PROCEDURE load_fnd_set_book_resp_cen(p_set_of_books_code          VARCHAR2,
                                       p_responsibility_center_code VARCHAR2,
                                       p_responsibility_center_name VARCHAR2,
                                       p_resp_center_type_code      VARCHAR2,
                                       p_start_date_active          VARCHAR2,
                                       p_end_date_active            VARCHAR2,
                                       p_summary_flag               VARCHAR2);

  --部门定义
  PROCEDURE load_org_unit1(p_unit_code                  VARCHAR2,
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
  PROCEDURE load_employee1(p_employee_code      VARCHAR2,
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
                           p_user_name          VARCHAR2,
                           p_company_code       VARCHAR2);
  -------------------------------------
  --岗位导入
  -------------------------------------
  PROCEDURE load_employee_assigns(p_company_code  VARCHAR2,
                                  p_employee_code VARCHAR2,
                                  p_unit_code     VARCHAR2,
                                  p_zhiwu         VARCHAR2,
                                  p_node          VARCHAR2);
  PROCEDURE select_unit(p_unit_name VARCHAR2);

  PROCEDURE select_employee(p_employee_code VARCHAR2);
  --岗位增量导入
  --根据岗位描述去重
  PROCEDURE load_org_position(p_company_code         VARCHAR2,
                              p_unit_code            VARCHAR2,
                              p_position_code        VARCHAR2,
                              p_description          VARCHAR2,
                              p_parent_position_code VARCHAR2,
                              p_employee_job_code    VARCHAR2,
                              p_enabled_flag         VARCHAR2);
  PROCEDURE select_pos(p_description VARCHAR2);
  ----------------------------------------------------
  --更改现金流代码
  --参数1.p_description_text 项目类型描述
  --参数2.p_ded_rule_desc 现金流代码
  ----------------------------------------------------
  PROCEDURE load_expense_type(p_description_text VARCHAR2,
                              p_cashflow_code    VARCHAR2);
  PROCEDURE load_employee_assigns(p_company_code          VARCHAR2,
                                  p_employee_code         VARCHAR2,
                                  p_position_code         VARCHAR2,
                                  p_employee_job_code     VARCHAR2,
                                  p_employee_levels_code  VARCHAR2,
                                  p_primary_position_flag VARCHAR2,
                                  p_enabled_flag          VARCHAR2,
                                  p_unit                  varchar2);
  --系统级银行账户
  PROCEDURE insert_vender_bank_assigns(p_code          VARCHAR2,
                                       p_name          VARCHAR2,
                                       p_bank_location VARCHAR2);
  --更新员工角色
  PROCEDURE update_employee_role(p_employee_code varchar2,
                                 p_role_code     varchar2);
  PROCEDURE load_con_contract_oa(p_contract_code varchar2,
                                 p_contract_name varchar2,
                                 p_contract_url  varchar2,
                                 p_contract_promoter varchar2);
  --给某一用户分配admin的角色，所有公司的。
  PROCEDURE LOAD_ADMIN_ROLE(P_USER_NAME VARCHAR2);

  --公司分配db_code
  PROCEDURE update_db_code(p_com_name VARCHAR2, p_db_code varchar2);
  --供应商银行校验
  PROCEDURE CHECK_BACK_NAME_V;
  --员工银行校验
  PROCEDURE CHECK_BACK_NAME_E;
  --校验银行名称
  PROCEDURE CHECK_BACK_NAME(P_BACK_CODE VARCHAR2, P_BACK_NAME VARCHAR2);
  --更新方式
  PROCEDURE update_con_contract_oa(p_contract_code varchar2,
                                   p_contract_name varchar2,
                                   p_contract_url  varchar2);
  --根据科目代码，找到后将应付科目Y
  PROCEDURE load_gld_account(P_gld_account VARCHAR2);
END data_load_pkg;
/
CREATE OR REPLACE PACKAGE BODY data_load_pkg IS
  g_exists NUMBER;
  --导入角色脚本
  PROCEDURE load_sys_role(p_role_code   VARCHAR2,
                          p_role_name   VARCHAR2,
                          p_description VARCHAR2) IS
    v_role_id NUMBER;
  BEGIN
    v_role_id := sys_role_pkg.get_role_id;
    sys_role_pkg.insert_sys_role(p_role_code   => p_role_code,
                                 p_role_name   => p_role_name,
                                 p_description => p_description,
                                 p_created_by  => 1,
                                 p_start_date  => to_date('2018-04-01',
                                                          'YYYY-MM-DD'),
                                 p_role_id     => v_role_id,
                                 p_end_date    => NULL);
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
                          p_user_name          VARCHAR2,
                          p_company_code       VARCHAR2) IS
    v_employee_type_id NUMBER;
    v_employee_id      NUMBER;
    v_user_id          NUMBER;
    v_role_id          NUMBER;
    v_frozen_flag      VARCHAR2(10);
    v_company_id       NUMBER;
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
                                 p_user_password           => 1,
                                 p_start_date              => to_date('2018-04-01',
                                                                      'yyyy-mm-dd'),
                                 p_end_date                => NULL,
                                 p_description             => p_name,
                                 p_password_lifespan_check => 3,
                                 p_password_lifespan       => NULL,
                                 p_employee_id             => v_employee_id,
                                 p_customer_id             => NULL,
                                 p_vender_id               => NULL,
                                 p_frozen_flag             => v_frozen_flag,
                                 p_frozen_date             => NULL,
                                 p_password_start_date     => to_date('2018-04-01',
                                                                      'yyyy-mm-dd'),
                                 p_last_updated_by         => -1,
                                 p_created_by              => -1,
                                 p_ip_address              => '10.1.1.1',
                                 p_user_id                 => v_user_id);
  
    SELECT f.company_id
      INTO v_company_id
      FROM fnd_companies f
     WHERE f.company_code = p_company_code;
    sys_user_pkg.insert_sys_user_role_groups(p_user_id    => v_user_id,
                                             p_role_id    => v_role_id,
                                             p_company_id => v_company_id,
                                             p_start_date => to_date('2018-04-01',
                                                                     'yyyy-mm-dd'),
                                             p_end_date   => NULL,
                                             p_created_by => -1);
  
    --==============新增员工对应的用户================ 
  END;

  PROCEDURE load_employee(p_employee_code         VARCHAR2,
                          p_employee_type_code    VARCHAR2,
                          p_name                  VARCHAR2,
                          p_email                 VARCHAR2,
                          p_mobil                 VARCHAR2,
                          p_phone                 VARCHAR2,
                          p_bank_of_deposit       VARCHAR2,
                          p_bank_account          VARCHAR2,
                          p_enabled_flag          VARCHAR2,
                          p_id_type               VARCHAR2,
                          p_id_code               VARCHAR2,
                          p_notes                 VARCHAR2,
                          p_user_name             VARCHAR2,
                          p_company_code          VARCHAR2,
                          p_position_code         VARCHAR2,
                          p_primary_position_flag VARCHAR2,
                          p_ass_enabled_flag      VARCHAR2) IS
    v_employee_type_id    NUMBER;
    v_employee_id         NUMBER;
    v_user_id             NUMBER;
    v_role_id             NUMBER;
    v_frozen_flag         VARCHAR2(10);
    v_company_id          NUMBER;
    v_position_id         NUMBER;
    v_employee_job_id     NUMBER;
    v_employees_assign_id NUMBER;
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
                                 p_user_password           => 1,
                                 p_start_date              => to_date('2018-04-01',
                                                                      'yyyy-mm-dd'),
                                 p_end_date                => NULL,
                                 p_description             => p_name,
                                 p_password_lifespan_check => 3,
                                 p_password_lifespan       => NULL,
                                 p_employee_id             => v_employee_id,
                                 p_customer_id             => NULL,
                                 p_vender_id               => NULL,
                                 p_frozen_flag             => v_frozen_flag,
                                 p_frozen_date             => NULL,
                                 p_password_start_date     => to_date('2018-04-01',
                                                                      'yyyy-mm-dd'),
                                 p_last_updated_by         => -1,
                                 p_created_by              => -1,
                                 p_ip_address              => '10.1.1.1',
                                 p_user_id                 => v_user_id);
  
    SELECT f.company_id
      INTO v_company_id
      FROM fnd_companies f
     WHERE f.company_code = p_company_code;
    sys_user_pkg.insert_sys_user_role_groups(p_user_id    => v_user_id,
                                             p_role_id    => v_role_id,
                                             p_company_id => v_company_id,
                                             p_start_date => to_date('2018-04-01',
                                                                     'yyyy-mm-dd'),
                                             p_end_date   => NULL,
                                             p_created_by => -1);
  
    --==============员工分配================ 
  
    SELECT position_id, employee_job_id
      INTO v_position_id, v_employee_job_id
      FROM exp_org_position a
     WHERE a.position_code = p_position_code
       AND a.company_id = v_company_id;
  
    exp_employees_pkg.insert_exp_employee_assigns(p_employee_id           => v_employee_id,
                                                  p_company_id            => v_company_id,
                                                  p_position_id           => v_position_id,
                                                  p_employee_job_id       => v_employee_job_id,
                                                  p_employee_levels_id    => NULL,
                                                  p_primary_position_flag => p_primary_position_flag,
                                                  p_enabled_flag          => p_ass_enabled_flag,
                                                  p_user_id               => 1,
                                                  p_employees_assign_id   => v_employees_assign_id);
  END;
  --员工银行账号导入，导入时默认为 主账号  已启用  对私
  PROCEDURE load_employee_account(p_employee_code      VARCHAR2,
                                  p_bank_account       VARCHAR2,
                                  p_same_city_flag     VARCHAR2,
                                  p_same_bank_flag     VARCHAR2,
                                  p_sparticipantbankno VARCHAR2) IS
    v_employee_id   NUMBER;
    v_employee_name VARCHAR2(100);
    v_bank_location VARCHAR2(100);
    v_province_code VARCHAR2(100);
    v_province_name VARCHAR2(100);
    v_city_code     VARCHAR2(100);
    v_city_name     VARCHAR2(100);
    v_bank_code     VARCHAR2(100);
    v_bank_name     VARCHAR2(100);
  BEGIN
  
    SELECT e.employee_id, e.name
      INTO v_employee_id, v_employee_name
      FROM exp_employees e
     WHERE e.employee_code = p_employee_code;
  
    SELECT b.bank_name,
           b.prov_code,
           b.prov_name,
           b.city_code,
           b.city_name,
           b.belong_bank_value,
           b.belong_bank_name
      INTO v_bank_location,
           v_province_code,
           v_province_name,
           v_city_code,
           v_city_name,
           v_bank_code,
           v_bank_name
      FROM bcdl_bank_num b
     WHERE b.bank_num = p_sparticipantbankno;
  
    UPDATE exp_employee_accounts
       SET bank_code          = v_bank_code,
           bank_name          = v_bank_name,
           bank_location_code = p_sparticipantbankno,
           bank_location      = v_bank_location,
           province_code      = v_province_code,
           province_name      = v_province_name,
           city_code          = v_city_code,
           city_name          = v_city_name,
           account_number     = p_bank_account,
           account_name       = v_employee_name,
           sparticipantbankno = p_sparticipantbankno,
           same_city_flag     = p_same_city_flag,
           same_bank_flag     = p_same_bank_flag
     WHERE employee_id = v_employee_id;
  
  END;

  PROCEDURE load_account(p_account_set_code   VARCHAR2,
                         p_account_code       VARCHAR2,
                         p_description        VARCHAR2,
                         p_account_type       VARCHAR2,
                         p_enabled_flag       VARCHAR2,
                         p_summary_flag       VARCHAR2,
                         p_cashflow_flag      VARCHAR2 DEFAULT NULL,
                         p_inter_flag         VARCHAR2 DEFAULT NULL,
                         p_tax_flag           VARCHAR2 DEFAULT NULL,
                         p_expense_account    VARCHAR2 DEFAULT NULL,
                         p_receivable_account VARCHAR2 DEFAULT NULL,
                         p_asset_account      VARCHAR2 DEFAULT NULL) IS
    v_account_id     NUMBER;
    v_account_set_id NUMBER;
  BEGIN
  
    SELECT account_set_id
      INTO v_account_set_id
      FROM gld_account_sets a
     WHERE a.account_set_code = p_account_set_code;
  
    BEGIN
      SELECT 1
        INTO g_exists
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM gld_accounts a
               WHERE a.account_set_id = v_account_set_id
                 AND a.account_code = p_account_code);
      RETURN;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    gld_account_pkg.insert_gld_account(p_account_set_id     => v_account_set_id,
                                       p_account_code       => p_account_code,
                                       p_description        => p_description,
                                       p_account_type       => p_account_type,
                                       p_enabled_flag       => p_enabled_flag,
                                       p_summary_flag       => p_summary_flag,
                                       p_created_by         => 1,
                                       p_last_updated_by    => 1,
                                       p_function_code      => 'FND2140',
                                       p_company_id         => NULL,
                                       p_account_id         => v_account_id,
                                       p_cashflow_flag      => p_cashflow_flag,
                                       p_inter_flag         => p_inter_flag,
                                       p_tax_flag           => p_tax_flag,
                                       p_expense_account    => p_expense_account,
                                       p_receivable_account => p_receivable_account,
                                       p_asset_account      => p_asset_account);
  
  END;

  PROCEDURE load_segments(p_set_of_books_code VARCHAR2,
                          p_segment_code      VARCHAR2,
                          p_segment_name      VARCHAR2,
                          p_segment_field     VARCHAR2,
                          p_segment_type      VARCHAR2,
                          p_default_text      VARCHAR2,
                          p_enabled_flag      VARCHAR2,
                          p_sql_query         VARCHAR2) IS
    v_set_of_books_id NUMBER;
    v_description_id  NUMBER;
  BEGIN
    SELECT b.set_of_books_id
      INTO v_set_of_books_id
      FROM gld_set_of_books b
     WHERE b.set_of_books_code = p_set_of_books_code;
  
    v_description_id := fnd_description_pkg.get_fnd_description_id;
  
    fnd_description_pkg.reset_fnd_descriptions(v_description_id,
                                               'GLD_SEGMENTS',
                                               'DESCRIPTION_ID',
                                               p_segment_name,
                                               1,
                                               1,
                                               userenv('lang'));
  
    BEGIN
      INSERT INTO gld_segments
        (segment_id,
         segment_field,
         segment_code,
         description_id,
         enabled_flag,
         set_of_books_id,
         segment_type,
         sql_query,
         sql_validate,
         default_text,
         dr_cr_flag,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date)
      VALUES
        (gld_segments_s.nextval,
         p_segment_field,
         p_segment_code,
         v_description_id,
         p_enabled_flag,
         v_set_of_books_id,
         p_segment_type,
         p_sql_query,
         NULL,
         p_default_text,
         NULL,
         1,
         SYSDATE,
         1,
         SYSDATE);
    
    END;
  
  END;

  PROCEDURE load_segments_source(p_segment_code      VARCHAR2,
                                 p_document_category VARCHAR2,
                                 p_value_table       VARCHAR2,
                                 p_value_item        VARCHAR2,
                                 p_enabled_flag      VARCHAR2) IS
    v_segment_id NUMBER;
  BEGIN
    SELECT b.segment_id
      INTO v_segment_id
      FROM gld_segments b
     WHERE b.segment_code = p_segment_code;
  
    gld_segments_pkg.insert_segments_source(p_segment_id        => v_segment_id,
                                            p_document_category => p_document_category,
                                            p_value_table       => p_value_table,
                                            p_value_item        => p_value_item,
                                            p_enabled_flag      => p_enabled_flag,
                                            p_user_id           => 1);
  
  END;
  --导入进项分类
  PROCEDURE load_exp_ygz_input_tax_struc(p_type_code                  VARCHAR2,
                                         p_type_name                  VARCHAR2,
                                         p_tax_rate                   NUMBER,
                                         p_input_tax_account          VARCHAR2,
                                         p_input_tax_transfer_account VARCHAR2,
                                         p_enabled_flag               VARCHAR2) IS
  
  BEGIN
    BEGIN
      INSERT INTO exp_ygz_input_tax_struc_dtl
        (type_id,
         type_code,
         type_name,
         tax_rate,
         input_tax_account,
         input_tax_transfer_account,
         order_num,
         vms_value,
         enabled_flag,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date)
      VALUES
        (exp_ygz_input_tax_struc_dtl_s.nextval,
         p_type_code,
         p_type_name,
         p_tax_rate / 100,
         p_input_tax_account,
         p_input_tax_transfer_account,
         NULL,
         NULL,
         p_enabled_flag,
         1,
         SYSDATE,
         1,
         SYSDATE);
    END;
  
  END;
  --导入部门分管总，如果部门为财务会计部，自动更新公司财务分管总
  PROCEDURE load_unit_charge_manager(p_unit_code            VARCHAR2,
                                     p_leader_position_code VARCHAR2) IS
  
    v_position_id NUMBER;
    v_desc        VARCHAR2(100);
    v_company_id  NUMBER;
  BEGIN
    BEGIN
      SELECT p.position_id
        INTO v_position_id
        FROM exp_org_position p
       WHERE p.position_code = p_leader_position_code;
      --更新部门主管岗位
      UPDATE exp_org_unit u
         SET u.leader_position_id = v_position_id
       WHERE u.unit_code = p_unit_code;
    
      SELECT v.description, v.company_id
        INTO v_desc, v_company_id
        FROM exp_org_unit_vl v
       WHERE v.unit_code = p_unit_code;
    
      IF v_desc LIKE '%财务会计部%' THEN
        --更新公司财务分管总
        UPDATE fnd_companies f
           SET f.fina_resp_position_id = v_position_id
         WHERE f.company_id = v_company_id;
      END IF;
    
    END;
  
  END;

  PROCEDURE check_budget_item(p_item_code VARCHAR2) IS
    v_item_id NUMBER;
  BEGIN
    SELECT b.budget_item_id
      INTO v_item_id
      FROM bgt_budget_items b
     WHERE b.budget_item_code = p_item_code;
  EXCEPTION
    WHEN no_data_found THEN
      dbms_output.put_line('not found : ' || p_item_code);
  END;
  --导入部门  当责任中心未分配给该公司时，自动分配
  PROCEDURE load_org_unit(p_unit_code                  VARCHAR2,
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
      BEGIN
      
        SELECT a.responsibility_center_id
          INTO v_responsibility_center_id
          FROM fnd_responsibility_centers a
         WHERE a.company_id = v_company_id
           AND a.responsibility_center_code = p_responsibility_center_code;
      
      EXCEPTION
        WHEN no_data_found THEN
          SELECT a.responsibility_center_id
            INTO v_responsibility_center_id
            FROM fnd_responsibility_centers a
           WHERE a.responsibility_center_code =
                 p_responsibility_center_code;
          fnd_responsibility_center_pkg.assign_fnd_set_book_resp_cen(p_company_id               => v_company_id,
                                                                     p_responsibility_center_id => v_responsibility_center_id,
                                                                     p_enabled_flag             => 'Y',
                                                                     p_create_by                => -1);
      END;
    
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
                                     p_leader_employee_id => v_leader_employee_id);
  END;
  ----------------------------------------------------
  --更改抵扣规则
  --参数1.p_expense_item_desc 账套级费用项目定义描述
  --参数2.p_ded_rule_desc 抵扣规则描述
  ----------------------------------------------------
  PROCEDURE load_ded_rule_desc(p_expense_item_desc VARCHAR2,
                               p_ded_rule_desc     VARCHAR2) IS
    v_ded_rule          exp_ygz_usage_types.type_code%TYPE;
    v_expense_item_code exp_expense_items.expense_item_code%TYPE;
  BEGIN
    --根据抵扣规则描述确定抵扣规则代码
    BEGIN
      SELECT type_code
        INTO v_ded_rule
        FROM exp_ygz_usage_types
       WHERE type_name = p_ded_rule_desc;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    BEGIN
      --根据费用描述确定费用代码
      SELECT v.expense_item_code
        INTO v_expense_item_code
        FROM exp_expense_items_vl v
       WHERE v.description = p_expense_item_desc;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    --更新抵扣规则  
    UPDATE exp_expense_items e
       SET e.ded_rule = v_ded_rule
     WHERE e.expense_item_code = v_expense_item_code;
  END load_ded_rule_desc;

  ----------------------------------------------------
  --更改预算项目类型
  ----------------------------------------------------
  PROCEDURE update_budget_item_types(p_item VARCHAR2, p_type VARCHAR2) IS
    v_id NUMBER;
  BEGIN
    SELECT t.budget_item_type_id
      INTO v_id
      FROM bgt_budget_item_types t
     WHERE t.budget_item_type_code = p_type;
  
    UPDATE bgt_budget_items b
       SET b.budget_item_type_id = v_id
     WHERE b.budget_item_code = p_item;
  END update_budget_item_types;

  -----------------------------------------------------------------------
  --更改岗位描述
  --参数一：要替换的岗位描述 P_DESCRIPTION
  --参数二：替换后的岗位描述 P_REPLACE_DESCRIPTION
  -----------------------------------------------------------------------
  PROCEDURE update_exp_org_position(p_description         VARCHAR2,
                                    p_replace_description VARCHAR2) IS
  BEGIN
    UPDATE fnd_descriptions f
       SET f.description_text = REPLACE(f.description_text,
                                        p_description,
                                        p_replace_description)
     WHERE f.description_id IN
           (SELECT e.description_id FROM exp_org_position e)
       AND f.description_text LIKE '%' || p_description || '%'
       AND f.language = 'ZHS';
  END update_exp_org_position;

  -------------------------------------
  --岗位导入
  -------------------------------------
  PROCEDURE load_employee_assigns(p_company_code  VARCHAR2,
                                  p_employee_code VARCHAR2,
                                  p_unit_code     VARCHAR2,
                                  p_zhiwu         VARCHAR2,
                                  p_node          VARCHAR2) IS
    v_u_description        VARCHAR2(100);
    p_position_code        VARCHAR2(100);
    p_employee_levels_code VARCHAR2(100);
    p_employee_job_code    VARCHAR2(100);
    v_count                NUMBER;
  BEGIN
    IF p_zhiwu = '部门负责人' THEN
      SELECT e.description
        INTO v_u_description
        FROM exp_org_unit_vl e
       WHERE e.unit_code = p_unit_code;
      SELECT ep.position_code
        INTO p_position_code
        FROM exp_org_position_vl ep
       WHERE ep.description = '总公司' || v_u_description || '部门主要负责人' || '%';
      p_employee_levels_code := 'A';
      p_employee_job_code    := 'H30';
    END IF;
    IF p_zhiwu = '一般员工' THEN
      IF p_node = '预算管理员' THEN
        SELECT e.description
          INTO v_u_description
          FROM exp_org_unit_vl e
         WHERE e.unit_code = p_unit_code;
        SELECT ep.position_code
          INTO p_position_code
          FROM exp_org_position_vl ep
         WHERE ep.description = '总公司' || v_u_description || '部门预算员' || '%';
      END IF;
      IF p_node = '考勤员' THEN
        SELECT e.description
          INTO v_u_description
          FROM exp_org_unit_vl e
         WHERE e.unit_code = p_unit_code;
        SELECT ep.position_code
          INTO p_position_code
          FROM exp_org_position_vl ep
         WHERE ep.description = '总公司' || v_u_description || '考勤员' || '%';
      END IF;
      IF p_node = '公司预算管理员' THEN
        SELECT e.description
          INTO v_u_description
          FROM exp_org_unit_vl e
         WHERE e.unit_code = p_unit_code;
        SELECT ep.position_code
          INTO p_position_code
          FROM exp_org_position_vl ep
         WHERE ep.description = '总公司预算员' || '%';
      END IF;
      IF p_node = '财务记账' THEN
        SELECT e.description
          INTO v_u_description
          FROM exp_org_unit_vl e
         WHERE e.unit_code = p_unit_code;
        SELECT ep.position_code
          INTO p_position_code
          FROM exp_org_position_vl ep
         WHERE ep.description = '总公司' || v_u_description || '财务记账' || '%';
      END IF;
      IF p_node = '税务' THEN
        SELECT e.description
          INTO v_u_description
          FROM exp_org_unit_vl e
         WHERE e.unit_code = p_unit_code;
        SELECT ep.position_code
          INTO p_position_code
          FROM exp_org_position_vl ep
         WHERE ep.description = '总公司' || v_u_description || '税务';
      END IF;
      IF p_node = '税务复核' THEN
        SELECT e.description
          INTO v_u_description
          FROM exp_org_unit_vl e
         WHERE e.unit_code = p_unit_code;
        SELECT ep.position_code
          INTO p_position_code
          FROM exp_org_position_vl ep
         WHERE ep.description = '总公司' || v_u_description || '税务复核';
      END IF;
      IF p_node = '费用复核' THEN
        SELECT e.description
          INTO v_u_description
          FROM exp_org_unit_vl e
         WHERE e.unit_code = p_unit_code;
        SELECT ep.position_code
          INTO p_position_code
          FROM exp_org_position_vl ep
         WHERE ep.description LIKE
               '总公司' || v_u_description || '费用复核' || '%';
      END IF;
      IF p_node = '出纳' THEN
        SELECT e.description
          INTO v_u_description
          FROM exp_org_unit_vl e
         WHERE e.unit_code = p_unit_code;
        SELECT ep.position_code
          INTO p_position_code
          FROM exp_org_position_vl ep
         WHERE ep.description LIKE '总公司' || v_u_description || '出纳' || '%';
      END IF;
      IF p_node = '记账审核' THEN
        SELECT e.description
          INTO v_u_description
          FROM exp_org_unit_vl e
         WHERE e.unit_code = p_unit_code;
        SELECT ep.position_code
          INTO p_position_code
          FROM exp_org_position_vl ep
         WHERE ep.description LIKE
               '总公司' || v_u_description || '记账审核' || '%';
      END IF;
      p_employee_levels_code := 'B';
      p_employee_job_code    := 'H30';
    END IF;
    IF p_zhiwu = '部门其他负责人' THEN
      SELECT e.description
        INTO v_u_description
        FROM exp_org_unit_vl e
       WHERE e.unit_code = p_unit_code;
      SELECT ep.position_code
        INTO p_position_code
        FROM exp_org_position_vl ep
       WHERE ep.description = '总公司' || v_u_description || '部门负责人';
      p_employee_levels_code := 'C';
      p_employee_job_code    := 'H20';
    END IF;
    SELECT COUNT(1)
      INTO v_count
      FROM exp_employee_assigns t
     WHERE t.company_id =
           (SELECT fc.company_id
              FROM fnd_companies fc
             WHERE fc.company_code = p_company_code)
       AND t.employee_id =
           (SELECT ee.employee_id
              FROM exp_employees ee
             WHERE ee.employee_code = p_employee_code)
       AND t.position_id =
           (SELECT ep.position_id
              FROM exp_org_position ep
             WHERE ep.position_code = p_position_code);
    IF v_count = 0 THEN
      exp_data_load_pkg.load_employee_assigns(p_company_code,
                                              p_employee_code,
                                              p_position_code,
                                              p_employee_job_code,
                                              p_employee_levels_code,
                                              'Y',
                                              'Y');
    END IF;
  END load_employee_assigns;

  --帐套级责任中心定义
  PROCEDURE load_fnd_set_book_resp_cen(p_set_of_books_code          VARCHAR2,
                                       p_responsibility_center_code VARCHAR2,
                                       p_responsibility_center_name VARCHAR2,
                                       p_resp_center_type_code      VARCHAR2,
                                       p_start_date_active          VARCHAR2,
                                       p_end_date_active            VARCHAR2,
                                       p_summary_flag               VARCHAR2) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM fnd_set_book_resp_centers t
     WHERE t.responsibility_center_code = p_responsibility_center_code;
    IF v_count = 0 THEN
      fnd_data_load_pkg.load_fnd_set_book_resp_cen(p_set_of_books_code,
                                                   p_responsibility_center_code,
                                                   p_responsibility_center_name,
                                                   p_resp_center_type_code,
                                                   p_start_date_active,
                                                   p_end_date_active,
                                                   p_summary_flag);
    END IF;
  END;

  --部门定义
  PROCEDURE load_org_unit1(p_unit_code                  VARCHAR2,
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
    v_count NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM exp_org_unit t
     WHERE t.unit_code = p_unit_code;
    IF v_count = 0 THEN
      exp_data_load_pkg.load_org_unit(p_unit_code,
                                      p_description,
                                      p_company_code,
                                      p_responsibility_center_code,
                                      p_parent_unit_code,
                                      p_operate_unit_code,
                                      --p_chief_position_code      number,
                                      p_org_unit_level_code,
                                      p_enabled_flag,
                                      p_unit_type_code,
                                      p_leader_employee_code);
    END IF;
  END;

  PROCEDURE load_employee1(p_employee_code      VARCHAR2,
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
                           p_user_name          VARCHAR2,
                           p_company_code       VARCHAR2) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM exp_employees ee
     WHERE ee.employee_code = p_employee_code;
    IF v_count = 0 THEN
      load_employee(p_employee_code,
                    p_employee_type_code,
                    p_name,
                    p_email,
                    p_mobil,
                    p_phone,
                    p_bank_of_deposit,
                    p_bank_account,
                    p_enabled_flag,
                    p_id_type,
                    p_id_code,
                    p_notes,
                    p_user_name,
                    p_company_code);
    END IF;
  END;
  --查询部门 参数1：部门名称
  PROCEDURE select_unit(p_unit_name VARCHAR2) IS
    v_unit_code VARCHAR2(100);
  BEGIN
    SELECT e.unit_code
      INTO v_unit_code
      FROM exp_org_unit e, fnd_descriptions f
     WHERE e.description_id = f.description_id
       AND e.company_id = 835
       AND f.language = 'ZHS'
       AND f.description_text = p_unit_name;
  EXCEPTION
    WHEN no_data_found THEN
      dbms_output.put_line(p_unit_name || '部门不存在！');
  END;

  PROCEDURE select_employee(p_employee_code VARCHAR2) IS
    v_employee_code VARCHAR2(100);
  BEGIN
    SELECT ee.employee_code
      INTO v_employee_code
      FROM exp_employees ee
     WHERE ee.employee_code = p_employee_code;
  EXCEPTION
    WHEN no_data_found THEN
      dbms_output.put_line(p_employee_code || '员工不存在！');
  END;

  --岗位增量导入
  --根据岗位描述去重
  PROCEDURE load_org_position(p_company_code         VARCHAR2,
                              p_unit_code            VARCHAR2,
                              p_position_code        VARCHAR2,
                              p_description          VARCHAR2,
                              p_parent_position_code VARCHAR2,
                              p_employee_job_code    VARCHAR2,
                              p_enabled_flag         VARCHAR2) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM exp_org_position_vl v
     WHERE v.description = p_description;
    IF v_count = 0 THEN
      exp_data_load_pkg.load_org_position(p_company_code,
                                          p_unit_code,
                                          p_position_code,
                                          p_description,
                                          p_parent_position_code,
                                          p_employee_job_code,
                                          p_enabled_flag);
    END IF;
  END;

  --检验岗位是否存在
  PROCEDURE select_pos(p_description VARCHAR2) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM exp_org_position_vl v
     WHERE v.description = p_description;
    IF v_count = 0 THEN
      dbms_output.put_line(p_description);
    END IF;
  END;

  ----------------------------------------------------
  --更改现金流代码
  --参数1.p_description_text 项目类型描述
  --参数2.p_ded_rule_desc 现金流代码
  ----------------------------------------------------
  PROCEDURE load_expense_type(p_description_text VARCHAR2,
                              p_cashflow_code    VARCHAR2) IS
    v_expense_type_id   NUMBER;
    v_expense_type_code VARCHAR2(30);
  BEGIN
    --根据项目类型描述确定类型ID和CODE
    BEGIN
      SELECT ee.expense_type_id, ee.expense_type_code
        INTO v_expense_type_id, v_expense_type_code
        FROM fnd_descriptions f, exp_sob_expense_types ee
       WHERE f.description_text = p_description_text
         AND ee.description_id = f.description_id
         AND f.language = 'ZHS';
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    --更新现金流代码
    UPDATE exp_sob_expense_types e
       SET e.cashflow_code = p_cashflow_code
     WHERE e.expense_type_id = v_expense_type_id
       AND e.expense_type_code = v_expense_type_code;
  END load_expense_type;

  PROCEDURE load_employee_assigns(p_company_code          VARCHAR2,
                                  p_employee_code         VARCHAR2,
                                  p_position_code         VARCHAR2,
                                  p_employee_job_code     VARCHAR2,
                                  p_employee_levels_code  VARCHAR2,
                                  p_primary_position_flag VARCHAR2,
                                  p_enabled_flag          VARCHAR2,
                                  p_unit                  varchar2) IS
    v_position_code        varchar2(100);
    v_employee_levels_code varchar2(100);
    v_company_id           NUMBER;
    v_employee_id          NUMBER;
    v_position_id          NUMBER;
    v_count                NUMBER;
  BEGIN
    if p_unit != 'ZB-' then
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
        FROM exp_org_position_vl a
       WHERE a.DESCRIPTION = p_position_code
         AND a.company_id = v_company_id;
    
      SELECT COUNT(1)
        INTO v_count
        FROM exp_employee_assigns a
       WHERE a.employee_id = v_employee_id
         AND a.company_id = v_company_id
         AND a.position_id = v_position_id;
    
      SELECT v.POSITION_CODE
        INTO v_position_code
        FROM exp_org_position_vl v
       where v.DESCRIPTION = p_position_code
         AND V.COMPANY_ID = 835;
      v_employee_levels_code := '30';
      if p_position_code like '部门主要负责人' then
        v_employee_levels_code := '10';
      end if;
      if p_position_code like '部门负责人' then
        v_employee_levels_code := '20';
      end if;
      IF v_count = 0 THEN
        exp_data_load_pkg.load_employee_assigns(p_company_code,
                                                p_employee_code,
                                                v_position_code,
                                                p_employee_job_code,
                                                v_employee_levels_code,
                                                p_primary_position_flag,
                                                p_enabled_flag);
      
      END IF;
    
    end if;
  END;

  --系统级银行账户
  PROCEDURE insert_vender_bank_assigns(p_code          VARCHAR2,
                                       p_name          VARCHAR2,
                                       p_bank_location VARCHAR2) IS
  BEGIN
    update pur_vender_accounts t
       set t.bank_location = p_bank_location
     where t.vender_id = (select p.vender_id
                            from pur_system_venders_vl p
                           where p.vender_code = p_code
                             and p.DESCRIPTION = p_name);
  
  END insert_vender_bank_assigns;

  PROCEDURE update_employee_role(p_employee_code varchar2,
                                 p_role_code     varchar2) is
    /*  v_employee_id number;*/
    v_user_id number;
    v_role_id number;
  begin
    /*select ee.employee_id
      into v_employee_id
      from exp_employees ee
     where ee.employee_code = p_employee_code;
    
    select s.user_id
      into v_user_id
      from sys_user s
     where s.employee_id = v_employee_id;*/
  
    select s.user_id
      into v_user_id
      from sys_user s
     where s.user_name = p_employee_code;
  
    select s.role_id
      into v_role_id
      from sys_role s
     where s.role_code = p_role_code;
  
    delete sys_user_role_groups t
     where t.user_id = v_user_id
       and t.company_id = 835
       and t.user_role_group_id !=
           (select t.user_role_group_id
              from sys_user_role_groups t
             where t.user_id = v_user_id
               and t.company_id = 835
               and rownum = 1);
    update sys_user_role_groups sg
       set sg.role_id = v_role_id, sg.end_date = NULL
     where sg.user_id = v_user_id
       and sg.company_id = 835;
  end;
  --========================================================
  -- 导入合同初始化数据
  -- 1、代码 2、名称 3、链接
  --========================================================
  PROCEDURE load_con_contract_oa(p_contract_code varchar2,
                                 p_contract_name varchar2,
                                 p_contract_url  varchar2,
                                 p_contract_promoter varchar2) is
    v_contract_id number;
    v_flag        varchar2(1);
  begin
    begin
      select 'Y'
        into v_flag
        from con_contract_oa cc
       where cc.contract_code = p_contract_code;
    exception
      when no_data_found then
        select con_contract_oa_s.nextval into v_contract_id from dual;
        insert into con_contract_oa
          (contract_id, contract_code, contract_name, contract_url,contract_promoter)
        values
          (v_contract_id, p_contract_code, p_contract_name, p_contract_url,p_contract_promoter);
    end;
  
    if v_flag = 'Y' then
      update_con_contract_oa(p_contract_code => p_contract_code,
                             p_contract_name => p_contract_name,
                             p_contract_url  => p_contract_url);
    end if;
  end load_con_contract_oa;
  --更新合同表数据方法
  PROCEDURE update_con_contract_oa(p_contract_code varchar2,
                                   p_contract_name varchar2,
                                   p_contract_url  varchar2) is
  begin
    update con_contract_oa cc
       set cc.contract_name = p_contract_name,
           cc.contract_url  = p_contract_url
     where cc.contract_code = p_contract_code;
  end update_con_contract_oa;

  --给某一用户分配admin的角色，所有公司的。
  PROCEDURE LOAD_ADMIN_ROLE(P_USER_NAME VARCHAR2) IS
    V_USER_ID NUMBER;
    CURSOR COLS IS
      SELECT * FROM FND_COMPANIES F;
  BEGIN
    SELECT S.USER_ID
      INTO V_USER_ID
      FROM SYS_USER S
     WHERE S.USER_NAME = UPPER(P_USER_NAME);
    FOR C IN COLS LOOP
      SYS_USER_PKG.INSERT_SYS_USER_ROLE_GROUPS(P_USER_ID    => V_USER_ID,
                                               P_ROLE_ID    => 1,
                                               P_COMPANY_ID => C.COMPANY_ID,
                                               P_START_DATE => TO_DATE('2018-04-01',
                                                                       'YYYY-MM-DD'),
                                               P_END_DATE   => NULL,
                                               P_CREATED_BY => -1);
    END LOOP;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('NOT FOUND USER_ID: ' || P_USER_NAME);
  END LOAD_ADMIN_ROLE;

  --公司分配db_code
  PROCEDURE update_db_code(p_com_name VARCHAR2, p_db_code varchar2) IS
    v_company_id NUMBER;
  BEGIN
    select fc.company_id
      into v_company_id
      from fnd_companies fc
     where fc.company_id =
           (select fv.company_id
              from fnd_companies_vl fv
             where fv.company_short_name like '%' || p_com_name || '%');
  
    update fnd_companies fc
       set fc.db_code = p_db_code
     where fc.company_id = v_company_id;
  END update_db_code;
  --供应商银行校验
  PROCEDURE CHECK_BACK_NAME_V IS
    V_BANK_NAME VARCHAR2(100);
  BEGIN
    FOR C IN (select distinct decode(t.bank_code, NULL, 'null', t.bank_code) bank_code,
                              t.bank_name
                from PUR_VENDER_ACCOUNTS t) LOOP
      BEGIN
        SELECT B.CODE_VALUE_NAME
          INTO V_BANK_NAME
          FROM SYS_CODES_VL A, SYS_CODE_VALUES_VL B
         WHERE A.CODE_ID = B.CODE_ID
           AND A.CODE = 'OPEN_BANK'
           AND B.ENABLED_FLAG = 'Y'
           AND B.CODE_VALUE = C.BANK_CODE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('银行代码：' || C.BANK_CODE);
      END;
      IF C.BANK_NAME = V_BANK_NAME THEN
        DBMS_OUTPUT.PUT_LINE(C.BANK_CODE);
      END IF;
    END LOOP;
  END;
  --员工银行校验
  PROCEDURE CHECK_BACK_NAME_E IS
    V_BANK_NAME VARCHAR2(100);
  BEGIN
    FOR C IN (SELECT * FROM EXP_EMPLOYEE_ACCOUNTS) LOOP
      BEGIN
        SELECT B.CODE_VALUE_NAME
          INTO V_BANK_NAME
          FROM SYS_CODES_VL A, SYS_CODE_VALUES_VL B
         WHERE A.CODE_ID = B.CODE_ID
           AND A.CODE = 'OPEN_BANK'
           AND B.ENABLED_FLAG = 'Y'
           AND B.CODE_VALUE = C.BANK_CODE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('银行代码：' || C.BANK_CODE);
      END;
      IF C.BANK_NAME != V_BANK_NAME THEN
        DBMS_OUTPUT.PUT_LINE(C.EMPLOYEE_ID);
      END IF;
    END LOOP;
  END;
  --校验银行名称
  PROCEDURE CHECK_BACK_NAME(P_BACK_CODE VARCHAR2, P_BACK_NAME VARCHAR2) IS
    V_BANK_NAME VARCHAR2(100);
  BEGIN
    BEGIN
      SELECT B.CODE_VALUE_NAME
        INTO V_BANK_NAME
        FROM SYS_CODES_VL A, SYS_CODE_VALUES_VL B
       WHERE A.CODE_ID = B.CODE_ID
         AND A.CODE = 'OPEN_BANK'
         AND B.ENABLED_FLAG = 'Y'
         AND B.CODE_VALUE = P_BACK_CODE;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('银行代码：' || P_BACK_CODE);
    END;
    IF V_BANK_NAME = P_BACK_NAME THEN
      DBMS_OUTPUT.PUT_LINE(P_BACK_CODE);
    END IF;
  END;
  PROCEDURE load_gld_account(p_gld_account VARCHAR2) is
    v_flag               varchar2(1);
    v_cashflow_flag      varchar2(1);
    v_inter_flag         varchar2(1);
    v_tax_flag           varchar2(1);
    v_expense_account    varchar2(1);
    v_receivable_account varchar2(1);
    v_asset_account      varchar2(1);
    v_pay_account        varchar2(1);
    v_message            varchar2(100);
  begin
    begin
      select 'Y'
        into v_flag
        from gld_accounts ga
       where ga.account_code = P_gld_account;
    exception
      when no_data_found then
        dbms_output.put_line('未找到该科目：' || P_gld_account);
    end;
    if v_flag = 'Y' then
      update gld_accounts ga
         set ga.pay_account = 'Y'
       where ga.account_code = P_gld_account;
      select ga.cashflow_flag, --现金流标志 
             ga.inter_flag, --往来科目 
             ga.tax_flag, --税科目 
             ga.expense_account, --费用科目  
             ga.receivable_account, --应收科目  
             ga.asset_account, --资产科目 
             ga.pay_account --应付科目
        into v_cashflow_flag,
             v_inter_flag,
             v_tax_flag,
             v_expense_account,
             v_receivable_account,
             v_asset_account,
             v_pay_account
        from gld_accounts ga
       where ga.account_code = p_gld_account;
      v_message := p_gld_account || '*****';
      if v_cashflow_flag = 'Y' then
        v_message := v_message || '该科目启用现金流标志*****';
      elsif v_inter_flag = 'Y' then
        v_message := v_message || '该科目启用往来科目*****';
      elsif v_tax_flag = 'Y' then
        v_message := v_message || '该科目启用税科目*****';
      elsif v_expense_account = 'Y' then
        v_message := v_message || '该科目启用费用科目*****';
      elsif v_receivable_account = 'Y' then
        v_message := v_message || '该科目启用应收科目*****';
      elsif v_asset_account = 'Y' then
        v_message := v_message || '该科目启用资产科目*****';
      elsif v_pay_account = 'Y' then
        v_message := v_message || '该科目启用应付科目*****';
      end if;
    end if;
    dbms_output.put_line(v_message);
  end;
END data_load_pkg;
/
