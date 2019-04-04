CREATE OR REPLACE PACKAGE exp_expense_items_pkg IS

  -- Author  : BOBO
  -- Created : 2009-4-21 10:26:16
  -- Purpose : 费用项目定义

  FUNCTION get_expense_item_id RETURN NUMBER;
  FUNCTION get_expense_item_types_id RETURN NUMBER;

  PROCEDURE insert_exp_expense_items(p_set_of_books_id      NUMBER,
                                     p_expense_item_code    VARCHAR2,
                                     p_description          VARCHAR2,
                                     p_currency_code        VARCHAR2,
                                     p_standard_price       NUMBER,
                                     p_enabled_flag         VARCHAR2,
                                     p_created_by           NUMBER,
                                     p_last_updated_by      NUMBER,
                                     p_req_item_id          NUMBER,
                                     p_budget_item_id       NUMBER,
                                     p_item_date_flag       VARCHAR2 DEFAULT NULL,
                                     p_item_where_flag      VARCHAR2 DEFAULT NULL,
                                     p_item_transport_flag  VARCHAR2 DEFAULT NULL,
                                     p_expense_item_id      OUT NUMBER,
                                     p_expense_item_code_xs VARCHAR2 DEFAULT NULL,
                                     p_ded_rule             varchar2 default null,
                                     p_commitment_item_code varchar2 default null,
                                     p_item_emp_level_flag  varchar2 default null);

  PROCEDURE update_exp_expense_items(p_expense_item_id      NUMBER,
                                     p_description          VARCHAR2,
                                     p_currency_code        VARCHAR2,
                                     p_enabled_flag         VARCHAR2,
                                     p_req_item_id          NUMBER,
                                     p_budget_item_id       NUMBER,
                                     p_last_updated_by      NUMBER,
                                     p_item_date_flag       VARCHAR2 DEFAULT NULL,
                                     p_item_where_flag      VARCHAR2 DEFAULT NULL,
                                     p_item_transport_flag  VARCHAR2 DEFAULT NULL,
                                     p_expense_item_code_xs VARCHAR2 DEFAULT NULL,
                                     p_ded_rule             VARCHAR2 DEFAULT NULL,
                                     p_commitment_item_code varchar2 default null,
                                     p_item_emp_level_flag  varchar2 default null);

  --分配公司
  PROCEDURE insert_company_expense_items(p_expense_item_id NUMBER,
                                         p_company_id      NUMBER,
                                         p_enabled_flag    VARCHAR2,
                                         p_created_by      NUMBER);

  --更新公司级启用
  procedure update_company_expense_items(p_expense_item_id NUMBER,
                                         p_company_id      NUMBER,
                                         p_enabled_flag    VARCHAR2,
                                         p_last_updated_by NUMBER);

  --公司级更新
  PROCEDURE update_company_expense_items(p_expense_item_id     NUMBER,
                                         p_company_id          NUMBER,
                                         p_enabled_flag        VARCHAR2,
                                         p_item_date_flag      VARCHAR2,
                                         p_item_where_flag     VARCHAR2,
                                         p_item_transport_flag VARCHAR2,
                                         p_item_emp_level_flag VARCHAR2,
                                         p_last_updated_by     NUMBER,
                                         p_ded_rule            VARCHAR DEFAULT NULL);

  --组织及更新
  PROCEDURE update_assign_comp_exp_items(p_expense_item_id NUMBER,
                                         p_company_id      NUMBER,
                                         p_enabled_flag    VARCHAR2,
                                         p_last_updated_by NUMBER);

  --分配给所有公司
  PROCEDURE insert_all_company_exp_items(p_expense_item_id NUMBER,
                                         p_created_by      NUMBER);

  --为费用项目指定报销类型
  PROCEDURE insert_exp_expense_item_types(p_expense_item_id NUMBER,
                                          p_expense_type_id NUMBER,
                                          p_created_by      NUMBER,
                                          p_last_updated_by NUMBER);

  PROCEDURE update_exp_expense_item_types(p_expense_item_types_id NUMBER,
                                          p_expense_item_id       NUMBER,
                                          p_expense_type_id       NUMBER,
                                          p_last_updated_by       NUMBER);

  PROCEDURE delete_exp_expense_item_types(p_expense_item_types_id NUMBER);

  --为费用项目 导入报销类型
  PROCEDURE load_expense_item_types(p_expense_item_id NUMBER,
                                    p_created_by      NUMBER,
                                    p_company_id      NUMBER);

  --批量分配公司
  PROCEDURE del_expense_items_asgn_company(p_session_id       NUMBER,
                                           p_application_code VARCHAR2);

  PROCEDURE inst_exp_items_asgn_company(p_session_id       NUMBER,
                                        p_application_code VARCHAR2,
                                        p_expense_item_id  NUMBER,
                                        p_user_id          NUMBER);

  PROCEDURE batch_import_com_expense_items(p_company_id       NUMBER,
                                           p_set_of_books_id  NUMBER,
                                           p_session_id       NUMBER,
                                           p_application_code VARCHAR2,
                                           p_user_id          NUMBER);

  --导入账套级费用项目说明定义
  PROCEDURE load_expense_item_descs(p_exp_report_type_code VARCHAR2,
                                    p_expense_type_code    VARCHAR2,
                                    p_expense_item_code    VARCHAR2,
                                    p_description          VARCHAR2);

  --导入账套级申请项目说明定义
  PROCEDURE load_exp_req_item_descs(p_exp_req_type_code VARCHAR2,
                                    p_expense_type_code VARCHAR2,
                                    p_req_item_code     VARCHAR2,
                                    p_description       VARCHAR2);

END exp_expense_items_pkg;
/
CREATE OR REPLACE PACKAGE BODY exp_expense_items_pkg IS

  FUNCTION get_expense_item_id RETURN NUMBER IS
    v_expense_item_id exp_expense_items.expense_item_id%TYPE;
  BEGIN
    SELECT exp_expense_items_s.nextval INTO v_expense_item_id FROM dual;
    RETURN v_expense_item_id;
  END get_expense_item_id;

  FUNCTION get_expense_item_types_id RETURN NUMBER IS
    v_expense_item_types_id exp_expense_item_types.expense_item_types_id%TYPE;
  BEGIN
    SELECT exp_expense_item_types_s.nextval
      INTO v_expense_item_types_id
      FROM dual;
    RETURN v_expense_item_types_id;
  END get_expense_item_types_id;

  PROCEDURE insert_exp_expense_items(p_set_of_books_id      NUMBER,
                                     p_expense_item_code    VARCHAR2,
                                     p_description          VARCHAR2,
                                     p_currency_code        VARCHAR2,
                                     p_standard_price       NUMBER,
                                     p_enabled_flag         VARCHAR2,
                                     p_created_by           NUMBER,
                                     p_last_updated_by      NUMBER,
                                     p_req_item_id          NUMBER,
                                     p_budget_item_id       NUMBER,
                                     p_item_date_flag       VARCHAR2 DEFAULT NULL,
                                     p_item_where_flag      VARCHAR2 DEFAULT NULL,
                                     p_item_transport_flag  VARCHAR2 DEFAULT NULL,
                                     p_expense_item_id      OUT NUMBER,
                                     p_expense_item_code_xs VARCHAR2 DEFAULT NULL,
                                     p_ded_rule             varchar2 default null,
                                     p_commitment_item_code varchar2 default null,
                                     p_item_emp_level_flag  varchar2 default null) IS
    v_expense_item_id exp_expense_items.expense_item_id%TYPE;
    v_description_id  exp_expense_items.description_id%TYPE;
  BEGIN
    v_expense_item_id := get_expense_item_id;
    v_description_id  := fnd_description_pkg.get_fnd_description_id;
  
    INSERT INTO exp_expense_items
      (expense_item_id,
       set_of_books_id,
       expense_item_code,
       description_id,
       currency_code,
       standard_price,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       req_item_id,
       budget_item_id,
       expense_item_code_xs,
       item_date_flag,
       item_where_flag,
       item_transport_flag,
       ded_rule,
       commitment_item_code,
       item_emp_level_flag)
    VALUES
      (v_expense_item_id,
       p_set_of_books_id,
       upper(p_expense_item_code),
       v_description_id,
       upper(p_currency_code),
       p_standard_price,
       p_enabled_flag,
       p_created_by,
       SYSDATE,
       p_last_updated_by,
       SYSDATE,
       p_req_item_id,
       p_budget_item_id,
       p_expense_item_code_xs,
       p_item_date_flag,
       p_item_where_flag,
       p_item_transport_flag,
       p_ded_rule,
       p_commitment_item_code,
       p_item_emp_level_flag);
  
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'EXP_EXPENSE_ITEMS',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => '',
                                               p_created_by       => p_created_by,
                                               p_last_updated_by  => p_last_updated_by,
                                               p_language_code    => userenv('lang'));
    p_expense_item_id := v_expense_item_id;
  
  EXCEPTION
    WHEN dup_val_on_index THEN
      --捕获 唯一索引错误
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXPENSE_ITEM_CODE_DUPLICATE',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'exp_expense_items_pkg',
                                                      p_procedure_function_name => 'insert_exp_expense_items');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_last_updated_by,
                                                     p_package_name            => 'exp_expense_items_pkg',
                                                     p_procedure_function_name => 'insert_exp_expense_items');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_exp_expense_items;

  PROCEDURE update_exp_expense_items(p_expense_item_id      NUMBER,
                                     p_description          VARCHAR2,
                                     p_currency_code        VARCHAR2,
                                     p_enabled_flag         VARCHAR2,
                                     p_req_item_id          NUMBER,
                                     p_budget_item_id       NUMBER,
                                     p_last_updated_by      NUMBER,
                                     p_item_date_flag       VARCHAR2 DEFAULT NULL,
                                     p_item_where_flag      VARCHAR2 DEFAULT NULL,
                                     p_item_transport_flag  VARCHAR2 DEFAULT NULL,
                                     p_expense_item_code_xs VARCHAR2 DEFAULT NULL,
                                     p_ded_rule             VARCHAR2 DEFAULT NULL,
                                     p_commitment_item_code varchar2 default null,
                                     p_item_emp_level_flag  varchar2 default null) IS
    v_description_id exp_expense_items.description_id%TYPE;
  BEGIN
    SELECT e.description_id
      INTO v_description_id
      FROM exp_expense_items e
     WHERE e.expense_item_id = p_expense_item_id;
  
    UPDATE exp_expense_items e
       SET e.enabled_flag         = p_enabled_flag,
           e.currency_code        = upper(p_currency_code),
           e.last_updated_by      = p_last_updated_by,
           e.last_update_date     = SYSDATE,
           e.budget_item_id       = p_budget_item_id,
           e.req_item_id          = p_req_item_id,
           e.expense_item_code_xs = p_expense_item_code_xs,
           e.item_date_flag       = p_item_date_flag,
           e.item_where_flag      = p_item_where_flag,
           e.item_transport_flag  = p_item_transport_flag,
           e.ded_rule             = p_ded_rule,
           e.commitment_item_code = p_commitment_item_code,
           e.item_emp_level_flag  = p_item_emp_level_flag
     WHERE e.expense_item_id = p_expense_item_id;
  
    --同步更新公司级
    UPDATE exp_company_expense_items a
       SET a.last_updated_by      = p_last_updated_by,
           a.last_update_date     = SYSDATE,
           a.enabled_flag         = p_enabled_flag,
           a.item_date_flag       = p_item_date_flag,
           a.item_where_flag      = p_item_where_flag,
           a.item_transport_flag  = p_item_transport_flag,
           a.ded_rule             = p_ded_rule,
           a.commitment_item_code = p_commitment_item_code,
           a.item_emp_level_flag  = p_item_emp_level_flag
     WHERE a.expense_item_id = p_expense_item_id;
  
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'EXP_EXPENSE_ITEMS',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => '',
                                               p_created_by       => p_last_updated_by,
                                               p_last_updated_by  => p_last_updated_by,
                                               p_language_code    => userenv('lang'));
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_last_updated_by,
                                                     p_package_name            => 'exp_expense_types_pkg',
                                                     p_procedure_function_name => 'update_exp_expense_types');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_exp_expense_items;

  --分配公司
  PROCEDURE insert_company_expense_items(p_expense_item_id NUMBER,
                                         p_company_id      NUMBER,
                                         p_enabled_flag    VARCHAR2,
                                         p_created_by      NUMBER) IS
    v_item_date_flag       VARCHAR2(10);
    v_item_where_flag      VARCHAR2(10);
    v_item_transport_flag  VARCHAR2(10);
    v_item_emp_level_flag  VARCHAR2(10);
    v_ded_rule             VARCHAR2(100);
    v_commitment_item_code VARCHAR2(100);
  BEGIN
    BEGIN
      SELECT ee.ded_rule, ee.commitment_item_code
        INTO v_ded_rule, v_commitment_item_code
        FROM exp_expense_items ee
       WHERE ee.expense_item_id = p_expense_item_id;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    INSERT INTO exp_company_expense_items
      (expense_item_id,
       company_id,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       ded_rule,
       commitment_item_code)
    VALUES
      (p_expense_item_id,
       p_company_id,
       p_enabled_flag,
       p_created_by,
       SYSDATE,
       p_created_by,
       SYSDATE,
       v_ded_rule,
       v_commitment_item_code);
  
    ---增加日期 地点  交通工具三个字段的更新  add by Shen Jinan 20180116
    SELECT eri.item_date_flag,
           eri.item_where_flag,
           eri.item_transport_flag,
           eri.item_emp_level_flag
      INTO v_item_date_flag,
           v_item_where_flag,
           v_item_transport_flag,
           v_item_emp_level_flag
      FROM exp_expense_items eri
     WHERE eri.expense_item_id = p_expense_item_id;
    UPDATE exp_company_expense_items ec
       SET ec.item_date_flag      = v_item_date_flag,
           ec.item_where_flag     = v_item_where_flag,
           ec.item_transport_flag = v_item_transport_flag,
           ec.item_emp_level_flag = v_item_emp_level_flag
     WHERE ec.expense_item_id = p_expense_item_id
       AND ec.company_id = p_company_id;
  
  EXCEPTION
    WHEN dup_val_on_index THEN
      --捕获 唯一索引错误
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXPENSE_ITEMS_APPOINTED_COMPANY_DUPLICATE',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'exp_expense_items_pkg',
                                                      p_procedure_function_name => 'insert_company_expense_items');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'exp_expense_items_pkg',
                                                     p_procedure_function_name => 'insert_company_expense_items');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_company_expense_items;
  
  --账套级下启用公司报销类型
  procedure update_company_expense_items(p_expense_item_id NUMBER,
                                         p_company_id      NUMBER,
                                         p_enabled_flag    VARCHAR2,
                                         p_last_updated_by NUMBER) is
  begin
    update exp_company_expense_items e
       set e.enabled_flag    = p_enabled_flag,
           e.last_updated_by = p_last_updated_by
     where e.company_id = p_company_id
       and e.expense_item_id = p_expense_item_id;
  end;

  PROCEDURE update_company_expense_items(p_expense_item_id     NUMBER,
                                         p_company_id          NUMBER,
                                         p_enabled_flag        VARCHAR2,
                                         p_item_date_flag      VARCHAR2,
                                         p_item_where_flag     VARCHAR2,
                                         p_item_transport_flag VARCHAR2,
                                         p_item_emp_level_flag VARCHAR2,
                                         p_last_updated_by     NUMBER,
                                         p_ded_rule            VARCHAR DEFAULT NULL) IS
    v_enabled_flag exp_expense_items.enabled_flag%TYPE;
  BEGIN
    IF p_enabled_flag = 'Y' THEN
      SELECT enabled_flag
        INTO v_enabled_flag
        FROM exp_expense_items
       WHERE expense_item_id = p_expense_item_id
         AND enabled_flag = p_enabled_flag;
    END IF;
  
    UPDATE exp_company_expense_items a
       SET a.last_updated_by     = p_last_updated_by,
           a.last_update_date    = SYSDATE,
           a.enabled_flag        = p_enabled_flag,
           a.item_date_flag      = p_item_date_flag,
           a.item_where_flag     = p_item_where_flag,
           a.item_emp_level_flag = p_item_emp_level_flag,
           a.item_transport_flag = p_item_transport_flag,
           a.ded_rule            = p_ded_rule
     WHERE a.expense_item_id = p_expense_item_id
       AND a.company_id = p_company_id;
  
  EXCEPTION
    WHEN no_data_found THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXPENSE_ITEMS_COMPANY_ENABLED_ERROR',
                                                      p_created_by              => p_last_updated_by,
                                                      p_package_name            => 'exp_expense_items_pkg',
                                                      p_procedure_function_name => 'update_company_expense_items');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_company_expense_items;

  --组织及更新
  PROCEDURE update_assign_comp_exp_items(p_expense_item_id NUMBER,
                                         p_company_id      NUMBER,
                                         p_enabled_flag    VARCHAR2,
                                         p_last_updated_by NUMBER) IS
  BEGIN
    UPDATE exp_company_expense_items a
       SET a.last_updated_by  = p_last_updated_by,
           a.last_update_date = SYSDATE,
           a.enabled_flag     = p_enabled_flag
     WHERE a.expense_item_id = p_expense_item_id
       AND a.company_id = p_company_id;
  END update_assign_comp_exp_items;

  --分配给所有公司
  PROCEDURE insert_all_company_exp_items(p_expense_item_id NUMBER,
                                         p_created_by      NUMBER) IS
    v_sysdate DATE := trunc(SYSDATE);
  BEGIN
    INSERT INTO exp_company_expense_items
      (expense_item_id,
       company_id,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
      SELECT p_expense_item_id,
             f.company_id,
             'Y',
             p_created_by,
             SYSDATE,
             p_created_by,
             SYSDATE
        FROM fnd_companies f
       WHERE f.start_date_active <= v_sysdate
         AND (f.end_date_active >= v_sysdate OR f.end_date_active IS NULL)
            --and f.company_type = '1'
         AND f.set_of_books_id =
             (SELECT set_of_books_id
                FROM exp_expense_items r
               WHERE r.expense_item_id = p_expense_item_id)
         AND NOT EXISTS (SELECT 1
                FROM exp_company_expense_items ri
               WHERE ri.expense_item_id = p_expense_item_id
                 AND ri.company_id = f.company_id);
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'exp_expense_items_pkg',
                                                     p_procedure_function_name => 'insert_all_company_exp_items');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_all_company_exp_items;

  --为费用项目指定报销类型
  PROCEDURE insert_exp_expense_item_types(p_expense_item_id NUMBER,
                                          p_expense_type_id NUMBER,
                                          p_created_by      NUMBER,
                                          p_last_updated_by NUMBER) IS
    v_expense_item_types_id exp_expense_item_types.expense_item_types_id%TYPE;
  BEGIN
    v_expense_item_types_id := get_expense_item_types_id;
  
    INSERT INTO exp_expense_item_types
      (expense_item_types_id,
       expense_item_id,
       expense_type_id,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (v_expense_item_types_id,
       p_expense_item_id,
       p_expense_type_id,
       p_created_by,
       SYSDATE,
       p_last_updated_by,
       SYSDATE);
  
  EXCEPTION
    WHEN dup_val_on_index THEN
      --捕获 唯一索引错误
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXPENSE_ITEM_EXPENSE_TYPE_DUPLICATE',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'exp_expense_items_pkg',
                                                      p_procedure_function_name => 'insert_exp_expense_item_types');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_last_updated_by,
                                                     p_package_name            => 'exp_expense_items_pkg',
                                                     p_procedure_function_name => 'insert_exp_expense_item_types');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_exp_expense_item_types;

  PROCEDURE update_exp_expense_item_types(p_expense_item_types_id NUMBER,
                                          p_expense_item_id       NUMBER,
                                          p_expense_type_id       NUMBER,
                                          p_last_updated_by       NUMBER) IS
  BEGIN
    UPDATE exp_expense_item_types t
       SET t.last_updated_by  = p_last_updated_by,
           t.last_update_date = SYSDATE,
           t.expense_item_id  = p_expense_item_id,
           t.expense_type_id  = p_expense_type_id
     WHERE t.expense_item_types_id = p_expense_item_types_id;
  
  EXCEPTION
    WHEN dup_val_on_index THEN
      --捕获 唯一索引错误
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXPENSE_ITEM_EXPENSE_TYPE_DUPLICATE',
                                                      p_created_by              => p_last_updated_by,
                                                      p_package_name            => 'exp_expense_items_pkg',
                                                      p_procedure_function_name => 'update_exp_expense_item_types');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_last_updated_by,
                                                     p_package_name            => 'exp_expense_items_pkg',
                                                     p_procedure_function_name => 'update_exp_expense_item_types');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_exp_expense_item_types;

  PROCEDURE delete_exp_expense_item_types(p_expense_item_types_id NUMBER) IS
  BEGIN
    DELETE FROM exp_expense_item_types t
     WHERE t.expense_item_types_id = p_expense_item_types_id;
  END delete_exp_expense_item_types;

  --为费用项目 导入报销类型
  PROCEDURE load_expense_item_types(p_expense_item_id NUMBER,
                                    p_created_by      NUMBER,
                                    p_company_id      NUMBER) IS
  
    CURSOR cur_lock_table IS
      SELECT *
        FROM exp_expense_item_types t
       WHERE t.expense_item_id = p_expense_item_id
         FOR UPDATE NOWAIT;
  
    --v_exp_expense_item_types cur_lock_table%rowtype;
  
    e_lock_table EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_lock_table, -54);
  BEGIN
    --锁表
    OPEN cur_lock_table;
  
    --从exp_expense_types表中取得报销类型，导入exp_expense_item_types表中 未定义过的报销类型
    FOR cur_expense_type IN (SELECT t.expense_type_id
                               FROM exp_expense_types t
                              WHERE t.enabled_flag = 'Y'
                                AND t.company_id = p_company_id
                                AND NOT EXISTS
                              (SELECT 1
                                       FROM exp_expense_item_types e
                                      WHERE e.expense_type_id =
                                            t.expense_type_id
                                        AND e.expense_item_id =
                                            p_expense_item_id)) LOOP
      insert_exp_expense_item_types(p_expense_item_id => p_expense_item_id,
                                    p_expense_type_id => cur_expense_type.expense_type_id,
                                    p_created_by      => p_created_by,
                                    p_last_updated_by => p_created_by);
    END LOOP;
  
    IF cur_lock_table%ISOPEN THEN
      CLOSE cur_lock_table;
    END IF;
  EXCEPTION
    WHEN e_lock_table THEN
      IF cur_lock_table%ISOPEN THEN
        CLOSE cur_lock_table;
      END IF;
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXPENSE_ITEMTYPE_LOCK_TABLE_ERROR',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'exp_expense_items_pkg',
                                                      p_procedure_function_name => 'load_expense_item_types');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      IF cur_lock_table%ISOPEN THEN
        CLOSE cur_lock_table;
      END IF;
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'exp_expense_items_pkg',
                                                     p_procedure_function_name => 'load_expense_item_types');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END load_expense_item_types;

  --批量分配公司
  PROCEDURE del_expense_items_asgn_company(p_session_id       NUMBER,
                                           p_application_code VARCHAR2) IS
  BEGIN
    DELETE FROM exp_expense_items_asgn_cm_tmp t
     WHERE t.session_id = p_session_id
       AND t.application_code = p_application_code;
  END del_expense_items_asgn_company;

  PROCEDURE inst_exp_items_asgn_company(p_session_id       NUMBER,
                                        p_application_code VARCHAR2,
                                        p_expense_item_id  NUMBER,
                                        p_user_id          NUMBER) IS
  BEGIN
    INSERT INTO exp_expense_items_asgn_cm_tmp
      (session_id,
       application_code,
       expense_item_id,
       creation_date,
       created_by)
    VALUES
      (p_session_id,
       p_application_code,
       p_expense_item_id,
       SYSDATE,
       p_user_id);
  END inst_exp_items_asgn_company;

  PROCEDURE batch_import_com_expense_items(p_company_id       NUMBER,
                                           p_set_of_books_id  NUMBER,
                                           p_session_id       NUMBER,
                                           p_application_code VARCHAR2,
                                           p_user_id          NUMBER) IS
  BEGIN
    INSERT INTO exp_company_expense_items
      (expense_item_id,
       company_id,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       ded_rule)
      SELECT t.expense_item_id,
             f.company_id,
             eei.enabled_flag,
             p_user_id,
             SYSDATE,
             p_user_id,
             SYSDATE,
             eei.ded_rule
        FROM fnd_companies                 f,
             exp_expense_items_asgn_cm_tmp t,
             exp_expense_items             eei
       WHERE eei.expense_item_id = t.expense_item_id
         AND (f.set_of_books_id = nvl(p_set_of_books_id, f.set_of_books_id))
         AND f.company_id = p_company_id
         AND t.session_id = p_session_id
         AND t.application_code = p_application_code
         AND NOT EXISTS (SELECT 1
                FROM exp_company_expense_items ri
               WHERE ri.expense_item_id = t.expense_item_id
                 AND ri.company_id = f.company_id);
  END batch_import_com_expense_items;

  --导入账套级费用项目说明定义
  PROCEDURE load_expense_item_descs(p_exp_report_type_code VARCHAR2,
                                    p_expense_type_code    VARCHAR2,
                                    p_expense_item_code    VARCHAR2,
                                    p_description          VARCHAR2) IS
    v_count              NUMBER;
    v_desc_id            NUMBER;
    v_exp_report_type_id NUMBER;
    v_expense_type_id    NUMBER;
    v_expense_item_id    NUMBER;
  
    e_exp_report_error   EXCEPTION;
    e_expense_type_error EXCEPTION;
    e_expense_item_error EXCEPTION;
  BEGIN
  
    IF p_exp_report_type_code IS NOT NULL THEN
      BEGIN
        SELECT t.expense_report_type_id
          INTO v_exp_report_type_id
          FROM exp_sob_report_types t
         WHERE t.expense_report_type_code = p_exp_report_type_code;
      EXCEPTION
        WHEN no_data_found THEN
          RAISE e_exp_report_error;
      END;
    END IF;
  
    IF p_expense_type_code IS NOT NULL THEN
      BEGIN
        SELECT t.expense_type_id
          INTO v_expense_type_id
          FROM exp_sob_expense_types t
         WHERE t.expense_type_code = p_expense_type_code;
      EXCEPTION
        WHEN no_data_found THEN
          RAISE e_expense_type_error;
      END;
    END IF;
  
    IF p_expense_item_code IS NOT NULL THEN
      BEGIN
        SELECT t.expense_item_id
          INTO v_expense_item_id
          FROM exp_expense_items t
         WHERE t.expense_item_code = p_expense_item_code;
      EXCEPTION
        WHEN no_data_found THEN
          RAISE e_expense_item_error;
      END;
    END IF;
  
    SELECT COUNT(1)
      INTO v_count
      FROM exp_expense_item_descs d
     WHERE d.exp_report_type_code = p_exp_report_type_code
       AND d.expense_type_code = p_expense_type_code
       AND d.expense_item_code = p_expense_item_code;
    IF v_count = 0 THEN
      SELECT exp_expense_item_descs_s.nextval INTO v_desc_id FROM dual;
      INSERT INTO exp_expense_item_descs d
        (desc_id,
         exp_report_type_code,
         expense_type_code,
         expense_item_code,
         description,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date)
      VALUES
        (v_desc_id,
         p_exp_report_type_code,
         p_expense_type_code,
         p_expense_item_code,
         p_description,
         -1,
         SYSDATE,
         -1,
         SYSDATE);
    ELSE
      UPDATE exp_expense_item_descs d
         SET d.description      = p_description,
             d.last_updated_by  = -1,
             d.last_update_date = SYSDATE
       WHERE d.exp_report_type_code = p_exp_report_type_code
         AND d.expense_type_code = p_expense_type_code
         AND d.expense_item_code = p_expense_item_code;
    END IF;
  EXCEPTION
    WHEN e_exp_report_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '账套级报销单类型不存在!',
                                                     p_created_by              => -1,
                                                     p_package_name            => 'exp_expense_items_pkg',
                                                     p_procedure_function_name => 'load_expense_item_descs');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_expense_type_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '账套级报销类型不存在!',
                                                     p_created_by              => -1,
                                                     p_package_name            => 'exp_expense_items_pkg',
                                                     p_procedure_function_name => 'load_expense_item_descs');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_expense_item_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '费用项目不存在!',
                                                     p_created_by              => -1,
                                                     p_package_name            => 'exp_expense_items_pkg',
                                                     p_procedure_function_name => 'load_expense_item_descs');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => -1,
                                                     p_package_name            => 'exp_expense_items_pkg',
                                                     p_procedure_function_name => 'load_expense_item_descs');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END load_expense_item_descs;

  --导入账套级申请项目说明定义
  PROCEDURE load_exp_req_item_descs(p_exp_req_type_code VARCHAR2,
                                    p_expense_type_code VARCHAR2,
                                    p_req_item_code     VARCHAR2,
                                    p_description       VARCHAR2) IS
    v_count           NUMBER;
    v_desc_id         NUMBER;
    v_exp_req_type_id NUMBER;
    v_expense_type_id NUMBER;
    v_req_item_id     NUMBER;
  
    e_exp_req_type_error EXCEPTION;
    e_expense_type_error EXCEPTION;
    e_req_item_error     EXCEPTION;
  BEGIN
    IF p_exp_req_type_code IS NOT NULL THEN
      BEGIN
        SELECT t.expense_requisition_type_id
          INTO v_exp_req_type_id
          FROM exp_sob_req_types t
         WHERE t.expense_requisition_type_code = p_exp_req_type_code;
      EXCEPTION
        WHEN no_data_found THEN
          RAISE e_exp_req_type_error;
      END;
    END IF;
  
    IF p_expense_type_code IS NOT NULL THEN
      BEGIN
        SELECT t.expense_type_id
          INTO v_expense_type_id
          FROM exp_sob_expense_types t
         WHERE t.expense_type_code = p_expense_type_code;
      EXCEPTION
        WHEN no_data_found THEN
          RAISE e_expense_type_error;
      END;
    END IF;
  
    IF p_req_item_code IS NOT NULL THEN
      BEGIN
        SELECT t.req_item_id
          INTO v_req_item_id
          FROM exp_req_items t
         WHERE t.req_item_code = p_req_item_code;
      EXCEPTION
        WHEN no_data_found THEN
          RAISE e_req_item_error;
      END;
    END IF;
    SELECT COUNT(1)
      INTO v_count
      FROM exp_req_item_descs d
     WHERE d.exp_req_type_code = p_exp_req_type_code
       AND d.expense_type_code = p_expense_type_code
       AND d.req_item_code = p_req_item_code;
    IF v_count = 0 THEN
      SELECT exp_req_item_descs_s.nextval INTO v_desc_id FROM dual;
      INSERT INTO exp_req_item_descs d
        (desc_id,
         exp_req_type_code,
         expense_type_code,
         req_item_code,
         description,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date)
      VALUES
        (v_desc_id,
         p_exp_req_type_code,
         p_expense_type_code,
         p_req_item_code,
         p_description,
         -1,
         SYSDATE,
         -1,
         SYSDATE);
    ELSE
      UPDATE exp_req_item_descs d
         SET d.description      = p_description,
             d.last_updated_by  = -1,
             d.last_update_date = SYSDATE
       WHERE d.exp_req_type_code = p_exp_req_type_code
         AND d.expense_type_code = p_expense_type_code
         AND d.req_item_code = p_req_item_code;
    END IF;
  EXCEPTION
    WHEN e_exp_req_type_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '账套级申请单类型不存在!',
                                                     p_created_by              => -1,
                                                     p_package_name            => 'exp_expense_items_pkg',
                                                     p_procedure_function_name => 'load_exp_req_item_descs');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_expense_type_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '账套级报销类型不存在!',
                                                     p_created_by              => -1,
                                                     p_package_name            => 'exp_expense_items_pkg',
                                                     p_procedure_function_name => 'load_exp_req_item_descs');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_req_item_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '费用项目不存在!',
                                                     p_created_by              => -1,
                                                     p_package_name            => 'exp_expense_items_pkg',
                                                     p_procedure_function_name => 'load_exp_req_item_descs');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => -1,
                                                     p_package_name            => 'exp_expense_items_pkg',
                                                     p_procedure_function_name => 'load_exp_req_item_descs');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END load_exp_req_item_descs;

END exp_expense_items_pkg;
/
