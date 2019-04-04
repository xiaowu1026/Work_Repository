CREATE OR REPLACE PACKAGE "CSH_PAY_REQ_TYPES_PKG" IS

  -- Author  : zhanglei1966
  -- Created : 2009-8-31 17:34:17
  -- Purpose : 借款申请类型定义

  FUNCTION get_csh_types_id RETURN NUMBER;

  procedure insert_csh_pay_req_types(p_company_id         number,
                                     p_type_code          varchar2,
                                     p_description        varchar2,
                                     p_currency_code      varchar2,
                                     p_approve_flag       varchar2,
                                     p_enabled_flag       varchar2,
                                     p_user_id            number,
                                     p_report_name        varchar2,
                                     p_payment_method     varchar2,
                                     p_type_id            out number,
                                     p_mobile_approve     VARCHAR2 DEFAULT 'N',
                                     p_mobile_fill        VARCHAR2 DEFAULT 'N',
                                     p_app_documents_icon VARCHAR2 DEFAULT NULL,
                                     p_auto_audit_flag    VARCHAR2 DEFAULT NULL);
  --帐套级借款类型下派到公司insert
  --create by duanjian
  --2012.2.9
  PROCEDURE assign_csh_pay_req_types(p_company_id      NUMBER,
                                     p_set_of_books_id NUMBER,
                                     p_type_code       VARCHAR2,
                                     p_user_id         NUMBER);

  --帐套级借款类型下派到公司(批量添加公司)
  --create by duanjian
  PROCEDURE batch_csh_pay_req_types(p_company_code_from VARCHAR2,
                                    p_company_code_to   VARCHAR2,
                                    p_v_set_of_books_id NUMBER,
                                    p_v_type_code       VARCHAR2,
                                    p_v_user_id         NUMBER);

  --帐套级借款类型update下派的公司
  --create by duanjian
  PROCEDURE assign_csh_pay_req_types(p_company_id      NUMBER,
                                     p_set_of_books_id NUMBER,
                                     p_type_code       VARCHAR2,
                                     p_enabled_flag    VARCHAR2,
                                     p_user_id         NUMBER);

  --insert帐套级借款申请单
  --create by duanjian
  PROCEDURE insert_sob_csh_pay_req_types(p_set_of_books_id    NUMBER,
                                         p_type_code          VARCHAR2,
                                         p_company_id         NUMBER,
                                         p_description        VARCHAR2,
                                         p_currency_code      VARCHAR2,
                                         p_approve_flag       VARCHAR2,
                                         p_enabled_flag       VARCHAR2,
                                         p_user_id            NUMBER,
                                         p_report_name        VARCHAR2,
                                         p_payment_method     VARCHAR2,
                                         p_type_id            OUT NUMBER,
                                         p_mobile_approve     VARCHAR2 DEFAULT 'N',
                                         p_mobile_fill        VARCHAR2 DEFAULT 'N',
                                         p_app_documents_icon VARCHAR2 DEFAULT NULL,
                                         p_auto_audit_flag    VARCHAR2 DEFAULT NULL);

  procedure update_csh_pay_req_types(p_type_id            number,
                                     p_company_id         number,
                                     p_description        varchar2,
                                     p_currency_code      varchar2,
                                     p_approve_flag       varchar2,
                                     p_enabled_flag       varchar2,
                                     p_user_id            number,
                                     p_report_name        varchar2,
                                     p_payment_method     varchar2,
                                     p_mobile_approve     VARCHAR2 DEFAULT 'N',
                                     p_mobile_fill        VARCHAR2 DEFAULT 'N',
                                     p_app_documents_icon VARCHAR2 DEFAULT NULL,
                                     p_auto_audit_flag    VARCHAR2 DEFAULT NULL);
  --update帐套级借款申请单
  --create by duanjian
  PROCEDURE update_sob_csh_pay_req_types(p_type_id            NUMBER,
                                         p_type_code          VARCHAR,
                                         p_set_of_books_id    NUMBER,
                                         p_description        VARCHAR2,
                                         p_currency_code      VARCHAR2,
                                         p_approve_flag       VARCHAR2,
                                         p_enabled_flag       VARCHAR2,
                                         p_user_id            NUMBER,
                                         p_report_name        VARCHAR2,
                                         p_payment_method     VARCHAR2,
                                         p_mobile_approve     VARCHAR2 DEFAULT 'N',
                                         p_mobile_fill        VARCHAR2 DEFAULT 'N',
                                         p_app_documents_icon VARCHAR2 DEFAULT NULL,
                                         p_auto_audit_flag    VARCHAR2 DEFAULT NULL);
  --关联员工组
  --create by ldd
  --2012.3.13
  PROCEDURE insert_csh_pay_ref_user_groups(p_type_id                    NUMBER,
                                           p_expense_user_group_id      NUMBER,
                                           p_created_by                 NUMBER,
                                           p_csh_pay_ref_user_groups_id OUT NUMBER);
  PROCEDURE delete_csh_pay_ref_user_groups(p_csh_pay_ref_user_groups_id NUMBER);

  FUNCTION get_pay_req_trs_class_id RETURN NUMBER;

  PROCEDURE insert_csh_pay_type_classes(p_pay_req_type_id      NUMBER,
                                        p_class_code           VARCHAR2,
                                        p_enabled_flag         VARCHAR2,
                                        p_user_id              NUMBER,
                                        p_pay_req_trs_class_id OUT NUMBER,
                                        p_req_required_flag    VARCHAR2 DEFAULT NULL);

  PROCEDURE insert_sob_pay_type_classes(p_pay_req_type_id NUMBER,
                                        p_class_code      VARCHAR2,
                                        p_enabled_flag    VARCHAR2,
                                        p_user_id         NUMBER,
                                        --add by Qu yuanyuan 是否必须关联申请
                                        p_req_required_flag    VARCHAR2,
                                        p_pay_req_trs_class_id OUT NUMBER);

  PROCEDURE update_csh_pay_type_classes(p_pay_req_trs_class_id NUMBER,
                                        p_pay_req_type_id      NUMBER,
                                        p_class_code           VARCHAR2,
                                        p_enabled_flag         VARCHAR2,
                                        p_user_id              NUMBER,
                                        p_req_required_flag    VARCHAR2 DEFAULT NULL);

  PROCEDURE update_sob_pay_type_classes(p_pay_req_trs_class_id NUMBER,
                                        p_pay_req_type_id      NUMBER,
                                        p_type_code            VARCHAR,
                                        p_set_of_books_id      NUMBER,
                                        p_class_code           VARCHAR2,
                                        p_enabled_flag         VARCHAR2,
                                        p_user_id              NUMBER,
                                        --add by Qu yuanyuan 是否必须关联申请
                                        p_req_required_flag VARCHAR2);

  PROCEDURE insert_sob_pay_ref_user_groups(p_type_id                    NUMBER,
                                           p_set_of_books_id            NUMBER,
                                           p_expense_user_group_id      NUMBER,
                                           p_created_by                 NUMBER,
                                           p_csh_pay_ref_user_groups_id OUT NUMBER);

  PROCEDURE delete_sob_pay_ref_user_groups(p_type_id                    NUMBER,
                                           p_set_of_books_id            NUMBER,
                                           p_expense_user_group_id      NUMBER,
                                           p_created_by                 NUMBER,
                                           p_csh_pay_ref_user_groups_id NUMBER);

  PROCEDURE update_sob_pay_ref_user_groups(p_type_id                    NUMBER,
                                           p_set_of_books_id            NUMBER,
                                           p_expense_user_group_id      NUMBER,
                                           p_created_by                 NUMBER,
                                           p_csh_pay_ref_user_groups_id NUMBER);

END csh_pay_req_types_pkg;
/
CREATE OR REPLACE PACKAGE BODY "CSH_PAY_REQ_TYPES_PKG" IS
  e_cmp_user_group_id_exception EXCEPTION;

  FUNCTION get_csh_types_id RETURN NUMBER IS
    v_csh_types_id csh_pay_req_types.type_id%TYPE;
  BEGIN
    SELECT csh_pay_req_types_s.nextval INTO v_csh_types_id FROM dual;
    RETURN v_csh_types_id;
  END get_csh_types_id;

  FUNCTION get_sob_csh_types_id RETURN NUMBER IS
    v_csh_types_id csh_pay_req_types.type_id%TYPE;
  BEGIN
    SELECT csh_sob_pay_req_types_s.nextval INTO v_csh_types_id FROM dual;
    RETURN v_csh_types_id;
  END get_sob_csh_types_id;

  --
  FUNCTION get_csh_pay_ref_user_groups_id RETURN NUMBER IS
    v_csh_pay_ref_user_groups_id csh_pay_ref_user_groups.csh_pay_ref_user_groups_id%TYPE;
  BEGIN
    SELECT csh_pay_ref_object_types_s.nextval
      INTO v_csh_pay_ref_user_groups_id
      FROM dual;
    RETURN v_csh_pay_ref_user_groups_id;
  END;
  PROCEDURE insert_csh_pay_type_classes_v(p_pay_req_type_id NUMBER,
                                          p_class_code      VARCHAR2,
                                          p_enabled_flag    VARCHAR2,
                                          p_user_id         NUMBER,
                                          --add by Qu yuanyuan 是否必须关联申请
                                          p_req_required_flag    VARCHAR2,
                                          p_pay_req_trs_class_id OUT NUMBER) IS
  
    v_pay_req_trs_class_id csh_pay_req_type_trs_classes.pay_req_trs_class_id%TYPE;
    v_count                NUMBER;
    e_types_duplicate_error EXCEPTION;
  
  BEGIN
    v_pay_req_trs_class_id := get_pay_req_trs_class_id;
  
    SELECT COUNT(*)
      INTO v_count
      FROM csh_pay_req_type_trs_classes t
     WHERE t.pay_req_type_id = p_pay_req_type_id
       AND t.class_code = p_class_code;
  
    IF v_count > 0 THEN
      RETURN;
    ELSE
      INSERT INTO csh_pay_req_type_trs_classes
        (pay_req_trs_class_id,
         pay_req_type_id,
         class_code,
         enabled_flag,
         creation_date,
         created_by,
         last_update_date,
         last_updated_by,
         req_required_flag)
      VALUES
        (v_pay_req_trs_class_id,
         p_pay_req_type_id,
         p_class_code,
         p_enabled_flag,
         SYSDATE,
         p_user_id,
         SYSDATE,
         p_user_id,
         p_req_required_flag);
      p_pay_req_trs_class_id := v_pay_req_trs_class_id;
    END IF;
  EXCEPTION
    WHEN e_types_duplicate_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH2010_TYPES_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_pay_req_types_pkg',
                                                      p_procedure_function_name => 'insert_csh_pay_type_classes');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN dup_val_on_index THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH2010_TYPES_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_pay_req_types_pkg',
                                                      p_procedure_function_name => 'insert_csh_pay_type_classes');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_pay_req_types_pkg',
                                                     p_procedure_function_name => 'insert_csh_pay_type_classes');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end insert_csh_pay_type_classes_v;
  procedure insert_csh_pay_req_types(p_company_id         number,
                                     p_type_code          varchar2,
                                     p_description        varchar2,
                                     p_currency_code      varchar2,
                                     p_approve_flag       varchar2,
                                     p_enabled_flag       varchar2,
                                     p_user_id            number,
                                     p_report_name        varchar2,
                                     p_payment_method     varchar2,
                                     p_type_id            out number,
                                     p_mobile_approve     VARCHAR2 DEFAULT 'N',
                                     p_mobile_fill        VARCHAR2 DEFAULT 'N',
                                     p_app_documents_icon VARCHAR2 DEFAULT NULL,
                                     p_auto_audit_flag    VARCHAR2 DEFAULT NULL) is
    v_description_id csh_pay_req_types.description_id%type;
    v_csh_types_id   csh_pay_req_types.type_id%type;
  begin
    v_csh_types_id   := get_csh_types_id;
    v_description_id := fnd_description_pkg.get_fnd_description_id;
    INSERT INTO csh_pay_req_types
      (type_id,
       type_code,
       company_id,
       description_id,
       currency_code,
       auto_approve_flag,
       enabled_flag,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by,
       report_name,
       payment_method,
       mobile_approve,
       mobile_fill,
       app_documents_icon,
       auto_audit_flag)
    values
      (v_csh_types_id,
       p_type_code,
       p_company_id,
       v_description_id,
       p_currency_code,
       p_approve_flag,
       p_enabled_flag,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_user_id,
       p_report_name,
       p_payment_method,
       p_mobile_approve,
       p_mobile_fill,
       p_app_documents_icon,
       p_auto_audit_flag);
  
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'CSH_PAY_REQ_TYPES',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => 'CSH2010',
                                               p_created_by       => p_user_id,
                                               p_last_updated_by  => p_user_id,
                                               p_language_code    => userenv('lang'));
    p_type_id := v_csh_types_id;
  EXCEPTION
    WHEN dup_val_on_index THEN
      --弹出错误-->借款申请单重复定义！
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH2010_TYPES_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_pay_req_types_pkg',
                                                      p_procedure_function_name => 'insert_csh_pay_req_types');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_pay_req_types_pkg',
                                                     p_procedure_function_name => 'insert_csh_pay_req_types');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_csh_pay_req_types;

  PROCEDURE ins_csh_pay_ref_user_groups_v(p_type_id                    NUMBER,
                                          p_expense_user_group_id      NUMBER,
                                          p_created_by                 NUMBER,
                                          p_csh_pay_ref_user_groups_id OUT NUMBER) IS
    v_csh_pay_ref_user_groups_id csh_pay_ref_user_groups.csh_pay_ref_user_groups_id%TYPE;
    v_count                      NUMBER;
  BEGIN
    v_csh_pay_ref_user_groups_id := get_csh_pay_ref_user_groups_id;
    SELECT COUNT(1)
      INTO v_count
      FROM csh_pay_ref_user_groups cpru
     WHERE cpru.type_id = p_type_id
       AND cpru.expense_user_group_id = p_expense_user_group_id;
  
    IF v_count > 0 THEN
      RETURN;
    ELSE
      INSERT INTO csh_pay_ref_user_groups
        (csh_pay_ref_user_groups_id,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date,
         type_id,
         expense_user_group_id)
      VALUES
        (v_csh_pay_ref_user_groups_id,
         p_created_by,
         SYSDATE,
         p_created_by,
         SYSDATE,
         p_type_id,
         p_expense_user_group_id);
      p_csh_pay_ref_user_groups_id := v_csh_pay_ref_user_groups_id;
    END IF;
  EXCEPTION
    WHEN dup_val_on_index THEN
      --捕获 唯一索引错误
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_REQ_REF_USER_GROUPS_DUPLICATE',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'CSH_PAY_REQ_TYPES_PKG',
                                                      p_procedure_function_name => 'ins_csh_pay_ref_user_groups_v');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'CSH_PAY_REQ_TYPES_PKG',
                                                     p_procedure_function_name => 'ins_csh_pay_ref_user_groups_v');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END;

  --帐套级借款类型下派到公司insert
  --create by duanjian
  --2012.2.9
  PROCEDURE assign_csh_pay_req_types(p_company_id      NUMBER,
                                     p_set_of_books_id NUMBER,
                                     p_type_code       VARCHAR2,
                                     p_user_id         NUMBER) IS
    v_flag_number                NUMBER;
    v_description_id             NUMBER;
    v_description                VARCHAR2(1000);
    v_csh_pay_ref_user_groups_id NUMBER;
    v_type_id                    NUMBER;
    v_class_id                   NUMBER;
  BEGIN
    --
    v_description_id := fnd_description_pkg.get_fnd_description_id;
    --判断此帐套级下此类型是否已经分派给该公司
    BEGIN
      SELECT 1
        INTO v_flag_number
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM csh_pay_req_types c
               WHERE c.company_id = p_company_id
                 AND c.type_code = p_type_code);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    IF v_flag_number IS NULL THEN
      --  v_csh_types_id := get_csh_types_id;
      BEGIN
        SELECT a.description_text
          INTO v_description
          FROM csh_sob_pay_req_types c, fnd_descriptions a
         WHERE c.set_of_books_id = p_set_of_books_id
           AND c.type_code = p_type_code
           AND c.description_id = a.description_id;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      INSERT INTO csh_pay_req_types
        (type_id,
         type_code,
         company_id,
         description_id,
         currency_code,
         auto_approve_flag,
         report_name,
         enabled_flag,
         creation_date,
         created_by,
         last_update_date,
         last_updated_by,
         payment_method,
         mobile_approve,
         mobile_fill,
         app_documents_icon,
         auto_audit_flag)
        select get_csh_types_id,
               c.type_code,
               p_company_id,
               v_description_id,
               c.currency_code,
               c.auto_approve_flag,
               c.report_name,
               c.enabled_flag,
               SYSDATE,
               p_user_id,
               SYSDATE,
               p_user_id,
               c.payment_method,
               c.mobile_approve,
               c.mobile_fill,
               c.app_documents_icon,
               c.auto_audit_flag
          from csh_sob_pay_req_types c
         where c.set_of_books_id = p_set_of_books_id
           and c.type_code = p_type_code;
    
      FOR c_cur IN (SELECT eugh.expense_user_group_id
                      FROM exp_user_group_headers_vl   eugh,
                           csh_sob_pay_ref_user_groups o,
                           csh_sob_pay_req_types       r,
                           exp_sob_user_groups_vl      e
                     WHERE eugh.company_id = p_company_id
                       AND r.type_code = p_type_code
                       AND r.set_of_books_id = p_set_of_books_id
                       AND o.type_id = r.type_id
                       AND o.expense_user_group_id = e.user_groups_id
                       AND eugh.expense_user_group_code = e.user_groups_code) LOOP
      
        SELECT type_id
          INTO v_type_id
          FROM csh_pay_req_types cprt
         WHERE cprt.type_code = p_type_code
           AND cprt.company_id = p_company_id;
      
        ins_csh_pay_ref_user_groups_v(p_type_id                    => v_type_id,
                                      p_expense_user_group_id      => c_cur.expense_user_group_id,
                                      p_created_by                 => p_user_id,
                                      p_csh_pay_ref_user_groups_id => v_csh_pay_ref_user_groups_id);
      
      /*ins_csh_pay_ref_user_groups_v(p_type_id                    =>v_type_id,
                                                                                                                                                                                                 p_expense_user_group_id      =>c_cur.expense_user_group_id,
                                                                                                                                                                                                 p_created_by                 =>p_user_id,
                                                                                                                                                                                                 p_csh_pay_ref_user_groups_id =>v_csh_pay_ref_user_groups_id);*/
      
      END LOOP;
    
      fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                                 p_ref_table        => 'CSH_PAY_REQ_TYPES',
                                                 p_ref_field        => 'DESCRIPTION_ID',
                                                 p_description_text => v_description,
                                                 p_function_name    => 'CSH2010',
                                                 p_created_by       => p_user_id,
                                                 p_last_updated_by  => p_user_id,
                                                 p_language_code    => userenv('lang'));
    
      --分配到公司级借款申请单类型表中
      FOR c_record IN (SELECT cprtv.type_id,
                              r.class_code,
                              r.enabled_flag,
                              r.created_by,
                              r.req_required_flag
                         FROM csh_pay_req_types_vl         cprtv,
                              csh_sob_pay_req_type_classes r,
                              csh_sob_pay_req_types        s
                        WHERE cprtv.type_code = p_type_code
                          AND s.type_code = cprtv.type_code
                          AND r.pay_req_type_id = s.type_id) LOOP
      
        insert_csh_pay_type_classes_v(p_pay_req_type_id      => c_record.type_id,
                                      p_class_code           => c_record.class_code,
                                      p_enabled_flag         => c_record.enabled_flag,
                                      p_user_id              => c_record.created_by,
                                      p_req_required_flag    => c_record.req_required_flag,
                                      p_pay_req_trs_class_id => v_class_id);
      END LOOP;
    
    ELSE
      --批量增加公司时，如果存在，则改为启用
      UPDATE csh_pay_req_types c
         SET c.enabled_flag = 'Y'
       WHERE c.company_id = p_company_id
         AND c.type_code = p_type_code;
      --启用此借款类型
      UPDATE csh_sob_pay_req_types c
         SET c.enabled_flag = 'Y'
       WHERE c.set_of_books_id = p_set_of_books_id
         AND c.type_code = p_type_code;
    
    END IF;
  EXCEPTION
    WHEN dup_val_on_index THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH2011_TYPES_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_pay_req_types_pkg',
                                                      p_procedure_function_name => 'insert_csh_pay_req_types');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_pay_req_types_pkg',
                                                     p_procedure_function_name => 'insert_csh_pay_req_types');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END assign_csh_pay_req_types;

  --帐套级借款类型下派到公司update
  --create by duanjian
  PROCEDURE assign_csh_pay_req_types(p_company_id      NUMBER,
                                     p_set_of_books_id NUMBER,
                                     p_type_code       VARCHAR2,
                                     p_enabled_flag    VARCHAR2,
                                     p_user_id         NUMBER) IS
    v_head_flag VARCHAR2(1);
  BEGIN
  
    IF p_enabled_flag = 'Y' THEN
      SELECT c.enabled_flag
        INTO v_head_flag
        FROM csh_sob_pay_req_types c
       WHERE c.set_of_books_id = p_set_of_books_id
         AND c.type_code = p_type_code;
      --如果类型未启用，选择公司启用时必须启用类型
      IF v_head_flag = 'N' THEN
        UPDATE csh_sob_pay_req_types c
           SET c.enabled_flag = 'Y'
         WHERE c.set_of_books_id = p_set_of_books_id
           AND c.type_code = p_type_code;
      END IF;
    
    END IF;
    --更新公司级表
    UPDATE csh_pay_req_types c
       SET c.enabled_flag = p_enabled_flag
     WHERE c.type_code = p_type_code
       AND c.company_id = p_company_id;
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_pay_req_types_pkg',
                                                     p_procedure_function_name => 'update_csh_pay_req_types');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END assign_csh_pay_req_types;

  --帐套级借款类型下派到公司(批量添加公司)
  --create by duanjian
  PROCEDURE batch_csh_pay_req_types(p_company_code_from VARCHAR2,
                                    p_company_code_to   VARCHAR2,
                                    p_v_set_of_books_id NUMBER,
                                    p_v_type_code       VARCHAR2,
                                    p_v_user_id         NUMBER) IS
    CURSOR cur_company_id IS
      SELECT fv.company_id
        FROM fnd_companies_vl fv
       WHERE (fv.end_date_active IS NULL OR
             SYSDATE BETWEEN fv.start_date_active AND fv.end_date_active)
         AND fv.set_of_books_id = p_v_set_of_books_id
         AND fv.company_code BETWEEN p_company_code_from AND
             p_company_code_to
       ORDER BY fv.company_code;
  
    err_company_to_from EXCEPTION;
  
  BEGIN
    --保存回滚点
    SAVEPOINT csh_point_batch;
  
    IF p_company_code_from > p_company_code_to THEN
      RAISE err_company_to_from;
    END IF;
  
    FOR v_company_id IN cur_company_id LOOP
    
      assign_csh_pay_req_types(p_company_id      => v_company_id.company_id,
                               p_set_of_books_id => p_v_set_of_books_id,
                               p_type_code       => p_v_type_code,
                               p_user_id         => p_v_user_id);
    END LOOP;
  EXCEPTION
    WHEN err_company_to_from THEN
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH2011_ERR_COMPANY_TO_FROM',
                                                      p_created_by              => p_v_user_id,
                                                      p_package_name            => 'csh_pay_req_types_pkg',
                                                      p_procedure_function_name => 'batch_csh_pay_req_types');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      ROLLBACK TO csh_point_batch;
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_v_user_id,
                                                     p_package_name            => 'csh_pay_req_types_pkg',
                                                     p_procedure_function_name => 'batch_csh_pay_req_types');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END batch_csh_pay_req_types;

  --帐套级借款申请单插入
  --create by duanjian
  PROCEDURE insert_sob_csh_pay_req_types(p_set_of_books_id    NUMBER,
                                         p_type_code          VARCHAR2,
                                         p_company_id         NUMBER,
                                         p_description        VARCHAR2,
                                         p_currency_code      VARCHAR2,
                                         p_approve_flag       VARCHAR2,
                                         p_enabled_flag       VARCHAR2,
                                         p_user_id            NUMBER,
                                         p_report_name        VARCHAR2,
                                         p_payment_method     VARCHAR2,
                                         p_type_id            OUT NUMBER,
                                         p_mobile_approve     VARCHAR2 DEFAULT 'N',
                                         p_mobile_fill        VARCHAR2 DEFAULT 'N',
                                         p_app_documents_icon VARCHAR2 DEFAULT NULL,
                                         p_auto_audit_flag    VARCHAR2 DEFAULT NULL) IS
    v_description_id csh_sob_pay_req_types.description_id%TYPE;
    v_csh_types_id   csh_sob_pay_req_types.type_id%TYPE;
  BEGIN
  
    v_csh_types_id   := get_sob_csh_types_id;
    v_description_id := fnd_description_pkg.get_fnd_description_id;
  
    INSERT INTO csh_sob_pay_req_types
      (type_id,
       type_code,
       set_of_books_id,
       description_id,
       currency_code,
       auto_approve_flag,
       enabled_flag,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by,
       report_name,
       payment_method,
       mobile_approve,
       mobile_fill,
       app_documents_icon,
       auto_audit_flag)
    VALUES
      (v_csh_types_id,
       p_type_code,
       p_set_of_books_id,
       v_description_id,
       p_currency_code,
       p_approve_flag,
       p_enabled_flag,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_user_id,
       p_report_name,
       p_payment_method,
       p_mobile_approve,
       p_mobile_fill,
       p_app_documents_icon,
       p_auto_audit_flag);
  
    /*insert_csh_pay_req_types(p_company_id     => p_company_id,
                             p_type_code      => p_type_code,
                             p_description    => p_description,
                             p_currency_code  => p_currency_code,
                             p_approve_flag   => p_approve_flag,
                             p_enabled_flag   => p_enabled_flag,
                             p_user_id        => p_user_id,
                             p_report_name    => p_report_name,
                             p_payment_method => p_payment_method,
                             p_type_id        => v_csh_types_id);
    
    insert into csh_pay_req_types
    (type_id,
     type_code,
     company_id,
     description_id,
     currency_code,
     auto_approve_flag,
     enabled_flag,
     creation_date,
     created_by,
     last_update_date,
     last_updated_by,
     report_name)
    values
      (v_csh_types_id,
       p_type_code,
       p_company_id,
       v_description_id,
       p_currency_code,
       p_approve_flag,
       p_enabled_flag,
       sysdate,
       p_user_id,
       sysdate,
       p_user_id,
       p_report_name);*/
  
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'CSH_SOB_PAY_REQ_TYPES',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => 'CSH2011',
                                               p_created_by       => p_user_id,
                                               p_last_updated_by  => p_user_id,
                                               p_language_code    => userenv('lang'));
  
    /*  fnd_description_pkg.insert_fnd_descriptions(p_description_id   => v_description_id,
    p_ref_table        => 'CSH_PAY_REQ_TYPES',
    p_ref_field        => 'DESCRIPTION_ID',
    p_description_text => p_description,
    p_function_name    => 'CSH2011',
    p_created_by       => p_user_id,
    p_last_updated_by  => p_user_id,
    p_language_code    => userenv('lang'));  */
  
    p_type_id := v_csh_types_id;
  EXCEPTION
    WHEN dup_val_on_index THEN
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH2011_TYPES_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_pay_req_types_pkg',
                                                      p_procedure_function_name => 'insert_sob_csh_pay_req_types');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_pay_req_types_pkg',
                                                     p_procedure_function_name => 'insert_sob_csh_pay_req_types');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END insert_sob_csh_pay_req_types;

  procedure update_csh_pay_req_types(p_type_id            number,
                                     p_company_id         number,
                                     p_description        varchar2,
                                     p_currency_code      varchar2,
                                     p_approve_flag       varchar2,
                                     p_enabled_flag       varchar2,
                                     p_user_id            number,
                                     p_report_name        varchar2,
                                     p_payment_method     varchar2,
                                     p_mobile_approve     VARCHAR2 DEFAULT 'N',
                                     p_mobile_fill        VARCHAR2 DEFAULT 'N',
                                     p_app_documents_icon VARCHAR2 DEFAULT NULL,
                                     p_auto_audit_flag    VARCHAR2 DEFAULT NULL) is
    v_description_id csh_pay_req_types.description_id%type;
  begin
    select l.description_id
      into v_description_id
      from csh_pay_req_types l
     where l.type_id = p_type_id
       and l.company_id = p_company_id;
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'CSH_PAY_REQ_TYPES',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => 'CSH2010',
                                               p_created_by       => p_user_id,
                                               p_last_updated_by  => p_user_id,
                                               p_language_code    => userenv('lang'));
  
    update csh_pay_req_types l
       set l.enabled_flag       = p_enabled_flag,
           l.last_updated_by    = p_user_id,
           l.last_update_date   = sysdate,
           l.currency_code      = p_currency_code,
           l.auto_approve_flag  = p_approve_flag,
           l.report_name        = p_report_name,
           l.payment_method     = p_payment_method,
           l.mobile_fill        = p_mobile_fill,
           l.app_documents_icon = p_app_documents_icon,
           l.mobile_approve     = p_mobile_approve,
           l.auto_audit_flag    =p_auto_audit_flag
     where l.type_id = p_type_id;
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_pay_req_types_pkg',
                                                     p_procedure_function_name => 'update_csh_pay_req_types');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_csh_pay_req_types;

  --update帐套级借款申请单
  --create by duanjian
  PROCEDURE update_sob_csh_pay_req_types(p_type_id            NUMBER,
                                         p_type_code          VARCHAR,
                                         p_set_of_books_id    NUMBER,
                                         p_description        VARCHAR2,
                                         p_currency_code      VARCHAR2,
                                         p_approve_flag       VARCHAR2,
                                         p_enabled_flag       VARCHAR2,
                                         p_user_id            NUMBER,
                                         p_report_name        VARCHAR2,
                                         p_payment_method     VARCHAR2,
                                         p_mobile_approve     VARCHAR2 DEFAULT 'N',
                                         p_mobile_fill        VARCHAR2 DEFAULT 'N',
                                         p_app_documents_icon VARCHAR2 DEFAULT NULL,
                                         p_auto_audit_flag    VARCHAR2 DEFAULT NULL) IS
    v_description_id csh_sob_pay_req_types.description_id%TYPE;
  BEGIN
  
    SELECT l.description_id
      INTO v_description_id
      FROM csh_sob_pay_req_types l
     WHERE l.type_id = p_type_id;
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'CSH_SOB_PAY_REQ_TYPES',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => 'CSH2011',
                                               p_created_by       => p_user_id,
                                               p_last_updated_by  => p_user_id,
                                               p_language_code    => userenv('lang'));
  
    UPDATE csh_sob_pay_req_types l
       SET l.enabled_flag       = p_enabled_flag,
           l.last_updated_by    = p_user_id,
           l.last_update_date   = SYSDATE,
           l.currency_code      = p_currency_code,
           l.auto_approve_flag  = p_approve_flag,
           l.report_name        = p_report_name,
           l.payment_method     = p_payment_method,
           l.app_documents_icon = p_app_documents_icon,
           l.mobile_approve     = p_mobile_approve,
           l.mobile_fill        = p_mobile_fill,
           l.auto_audit_flag    = p_auto_audit_flag
    
     WHERE l.type_id = p_type_id
       AND l.set_of_books_id = p_set_of_books_id;
  
    FOR c_cur IN (SELECT fc.company_id
                    FROM fnd_companies_vl         fc,
                         csh_pay_req_types_vl     cpr,
                         csh_sob_pay_req_types_vl cspr
                   WHERE fc.set_of_books_id = p_set_of_books_id
                     AND cpr.type_code = p_type_code
                     AND cspr.set_of_books_id = fc.set_of_books_id
                     AND cspr.type_code = cpr.type_code
                     AND fc.company_id = cpr.company_id) LOOP
      SELECT l.description_id
        INTO v_description_id
        FROM csh_pay_req_types l
       WHERE l.type_code = p_type_code
         AND l.company_id = c_cur.company_id;
    
      fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                                 p_ref_table        => 'CSH_PAY_REQ_TYPES',
                                                 p_ref_field        => 'DESCRIPTION_ID',
                                                 p_description_text => p_description,
                                                 p_function_name    => 'CSH2011',
                                                 p_created_by       => p_user_id,
                                                 p_last_updated_by  => p_user_id,
                                                 p_language_code    => userenv('lang'));
    
      --更新原始基表
      UPDATE csh_pay_req_types c
         SET c.type_code          = p_type_code,
             c.last_updated_by    = p_user_id,
             c.last_update_date   = SYSDATE,
             c.currency_code      = p_currency_code,
             c.auto_approve_flag  = p_approve_flag,
             c.report_name        = p_report_name,
             c.payment_method     = p_payment_method,
             c.app_documents_icon = p_app_documents_icon,
             c.mobile_approve     = p_mobile_approve,
             c.mobile_fill        = p_mobile_fill,
             c.auto_audit_flag    = p_auto_audit_flag
       WHERE c.type_code = p_type_code
         AND c.company_id = c_cur.company_id;
    
      --如果不启用类型，则所有分派到此类型下的公司都不启用
      IF p_enabled_flag = 'N' THEN
        UPDATE csh_pay_req_types c
           SET c.enabled_flag = 'N'
         WHERE c.type_code = p_type_code
           AND c.enabled_flag = 'Y'
           AND EXISTS (SELECT f.company_id
                  FROM fnd_companies f
                 WHERE f.set_of_books_id = p_set_of_books_id
                   AND f.company_id = c.company_id);
      END IF;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_pay_req_types_pkg',
                                                     p_procedure_function_name => 'update_sob_csh_pay_req_types');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_sob_csh_pay_req_types;

  --员工组
  PROCEDURE insert_csh_pay_ref_user_groups(p_type_id                    NUMBER,
                                           p_expense_user_group_id      NUMBER,
                                           p_created_by                 NUMBER,
                                           p_csh_pay_ref_user_groups_id OUT NUMBER) IS
    v_csh_pay_ref_user_groups_id csh_pay_ref_user_groups.csh_pay_ref_user_groups_id%TYPE;
  BEGIN
    v_csh_pay_ref_user_groups_id := get_csh_pay_ref_user_groups_id;
    INSERT INTO csh_pay_ref_user_groups
      (csh_pay_ref_user_groups_id,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       type_id,
       expense_user_group_id)
    VALUES
      (v_csh_pay_ref_user_groups_id,
       p_created_by,
       SYSDATE,
       p_created_by,
       SYSDATE,
       p_type_id,
       p_expense_user_group_id);
    p_csh_pay_ref_user_groups_id := v_csh_pay_ref_user_groups_id;
  EXCEPTION
    WHEN dup_val_on_index THEN
      --捕获 唯一索引错误
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_REQ_REF_USER_GROUPS_DUPLICATE',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'CSH_PAY_REQ_TYPES_PKG',
                                                      p_procedure_function_name => 'insert_csh_pay_ref_user_groups');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'CSH_PAY_REQ_TYPES_PKG',
                                                     p_procedure_function_name => 'insert_csh_pay_ref_user_groups');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END;

  PROCEDURE insert_sob_pay_ref_user_groups(p_type_id                    NUMBER,
                                           p_set_of_books_id            NUMBER,
                                           p_expense_user_group_id      NUMBER,
                                           p_created_by                 NUMBER,
                                           p_csh_pay_ref_user_groups_id OUT NUMBER) IS
    v_csh_pay_ref_user_groups_id csh_pay_ref_user_groups.csh_pay_ref_user_groups_id%TYPE;
    v_cmp_user_group_id          NUMBER;
    v_cmp_pay_ref_user_groups_id NUMBER;
    v_cmp_user_group_code        VARCHAR2(30);
    v_company_name               VARCHAR2(200);
  
  BEGIN
    SELECT csh_sob_pay_ref_user_groups_s.nextval
      INTO v_csh_pay_ref_user_groups_id
      FROM dual;
    --插入帐套级员工组
    INSERT INTO csh_sob_pay_ref_user_groups
      (csh_pay_ref_user_groups_id,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       type_id,
       expense_user_group_id)
    VALUES
      (v_csh_pay_ref_user_groups_id,
       p_created_by,
       SYSDATE,
       p_created_by,
       SYSDATE,
       p_type_id,
       p_expense_user_group_id);
    p_csh_pay_ref_user_groups_id := v_csh_pay_ref_user_groups_id;
  
    --插入公司级员工组
    FOR c_record IN (SELECT cpr.*
                       FROM fnd_companies_vl         fc,
                            csh_pay_req_types_vl     cpr,
                            csh_sob_pay_req_types_vl cspr
                      WHERE fc.set_of_books_id = p_set_of_books_id
                        AND cspr.type_id = p_type_id
                        AND cspr.set_of_books_id = fc.set_of_books_id
                        AND cspr.type_code = cpr.type_code
                        AND fc.company_id = cpr.company_id) LOOP
      --从帐套级员工组id获取对应的公司级员工组id
      BEGIN
      
        IF c_record.company_id IS NOT NULL THEN
          SELECT fcv.company_short_name
            INTO v_company_name
            FROM fnd_companies_vl fcv
           WHERE fcv.company_id = c_record.company_id;
        END IF;
      
        SELECT eugh.expense_user_group_id, eugh.expense_user_group_code
          INTO v_cmp_user_group_id, v_cmp_user_group_code
          FROM exp_user_group_headers_vl eugh
         WHERE eugh.expense_user_group_code =
               (SELECT esug.user_groups_code
                  FROM exp_sob_user_groups_vl esug
                 WHERE esug.user_groups_id = p_expense_user_group_id)
           AND eugh.company_id = c_record.company_id;
      
      EXCEPTION
        WHEN no_data_found THEN
          RAISE e_cmp_user_group_id_exception;
      END;
      ins_csh_pay_ref_user_groups_v(p_type_id                    => c_record.type_id,
                                    p_expense_user_group_id      => v_cmp_user_group_id,
                                    p_created_by                 => p_created_by,
                                    p_csh_pay_ref_user_groups_id => v_cmp_pay_ref_user_groups_id);
    END LOOP;
  EXCEPTION
    WHEN e_cmp_user_group_id_exception THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_SOB_REQ_REF_USER_GROUPS_ID',
                                                      p_created_by              => p_created_by,
                                                      p_token_1                 => '#v_company_name',
                                                      p_token_value_1           => v_company_name,
                                                      p_token_2                 => '#v_cmp_user_group_code',
                                                      p_token_value_2           => v_cmp_user_group_code,
                                                      p_package_name            => 'CSH_PAY_REQ_TYPES_PKG',
                                                      p_procedure_function_name => 'insert_sob_pay_ref_user_groups');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN dup_val_on_index THEN
      --捕获 唯一索引错误
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH_REQ_REF_USER_GROUPS_DUPLICATE',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'CSH_PAY_REQ_TYPES_PKG',
                                                      p_procedure_function_name => 'insert_sob_pay_ref_user_groups');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
      --如果不存在帐套级数据就什么也不做
    WHEN no_data_found THEN
      RETURN;
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'CSH_PAY_REQ_TYPES_PKG',
                                                     p_procedure_function_name => 'insert_sob_pay_ref_user_groups');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END;

  PROCEDURE update_sob_pay_ref_user_groups(p_type_id                    NUMBER,
                                           p_set_of_books_id            NUMBER,
                                           p_expense_user_group_id      NUMBER,
                                           p_created_by                 NUMBER,
                                           p_csh_pay_ref_user_groups_id NUMBER) IS
    v_csh_pay_ref_user_groups_id csh_pay_ref_user_groups.csh_pay_ref_user_groups_id%TYPE;
    v_cmp_user_group_id          NUMBER;
    v_cmp_pay_ref_user_groups_id NUMBER;
  BEGIN
    --更新帐套级员工组id
    UPDATE csh_sob_pay_ref_user_groups csp
       SET csp.expense_user_group_id = p_expense_user_group_id
     WHERE csp.csh_pay_ref_user_groups_id = p_csh_pay_ref_user_groups_id;
  
    FOR c_record IN (SELECT cpr.*
                       FROM fnd_companies_vl         fc,
                            csh_pay_req_types_vl     cpr,
                            csh_sob_pay_req_types_vl cspr
                      WHERE fc.set_of_books_id = p_set_of_books_id
                        AND cspr.type_id = p_type_id
                        AND cspr.set_of_books_id = fc.set_of_books_id
                        AND cspr.type_code = cpr.type_code
                        AND fc.company_id = cpr.company_id) LOOP
      BEGIN
        SELECT eugh.expense_user_group_id
          INTO v_cmp_user_group_id
          FROM exp_user_group_headers_vl eugh
         WHERE eugh.expense_user_group_code =
               (SELECT esug.user_groups_code
                  FROM exp_sob_user_groups_vl esug
                 WHERE esug.user_groups_id = p_expense_user_group_id)
           AND eugh.company_id = c_record.company_id;
      EXCEPTION
        WHEN no_data_found THEN
          RAISE e_cmp_user_group_id_exception;
      END;
      UPDATE csh_pay_ref_user_groups csp
         SET csp.expense_user_group_id = v_cmp_user_group_id
       WHERE csp.type_id = p_type_id;
    END LOOP;
  
  EXCEPTION
    WHEN e_cmp_user_group_id_exception THEN
      RETURN;
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'CSH_PAY_REQ_TYPES_PKG',
                                                     p_procedure_function_name => 'update_sob_pay_ref_user_groups');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END;

  PROCEDURE delete_sob_pay_ref_user_groups(p_type_id                    NUMBER,
                                           p_set_of_books_id            NUMBER,
                                           p_expense_user_group_id      NUMBER,
                                           p_created_by                 NUMBER,
                                           p_csh_pay_ref_user_groups_id NUMBER) IS
    v_cmp_user_group_id   exp_user_group_headers_vl.expense_user_group_id%TYPE;
    v_cmp_user_group_code exp_user_group_headers_vl.expense_user_group_code%TYPE;
    v_count               NUMBER;
  BEGIN
  
    FOR c_record IN (SELECT cpr.*
                       FROM fnd_companies_vl         fc,
                            csh_pay_req_types_vl     cpr,
                            csh_sob_pay_req_types_vl cspr
                      WHERE fc.set_of_books_id = p_set_of_books_id
                        AND cspr.type_id = p_type_id
                        AND cspr.set_of_books_id = fc.set_of_books_id
                        AND cspr.type_code = cpr.type_code
                        AND fc.company_id = cpr.company_id) LOOP
      BEGIN
      
        --判断满足条件的公司级员工组是否存在
        SELECT COUNT(*)
          INTO v_count
          FROM exp_user_group_headers_vl eugh
         WHERE eugh.expense_user_group_code =
               (SELECT esug.user_groups_code
                  FROM exp_sob_user_groups_vl esug
                 WHERE esug.user_groups_id = p_expense_user_group_id)
           AND eugh.company_id = c_record.company_id;
      
        --如果满足条件的员工组存在则进行查询
        IF v_count > 0 THEN
        
          SELECT eugh.expense_user_group_id, eugh.expense_user_group_code
            INTO v_cmp_user_group_id, v_cmp_user_group_code
            FROM exp_user_group_headers_vl eugh
           WHERE eugh.expense_user_group_code =
                 (SELECT esug.user_groups_code
                    FROM exp_sob_user_groups_vl esug
                   WHERE esug.user_groups_id = p_expense_user_group_id)
             AND eugh.company_id = c_record.company_id;
        END IF;
      
      EXCEPTION
        WHEN no_data_found THEN
          RAISE e_cmp_user_group_id_exception;
      END;
      DELETE FROM csh_pay_ref_user_groups cpr
       WHERE cpr.expense_user_group_id = v_cmp_user_group_id
         AND cpr.type_id = p_type_id;
    END LOOP;
    DELETE FROM csh_sob_pay_ref_user_groups csp
     WHERE csp.csh_pay_ref_user_groups_id = p_csh_pay_ref_user_groups_id;
  
  EXCEPTION
    --如果不存在帐套级数据就什么也不做
    WHEN e_cmp_user_group_id_exception THEN
      RETURN;
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'CSH_PAY_REQ_TYPES_PKG',
                                                     p_procedure_function_name => 'update_sob_pay_ref_user_groups');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  PROCEDURE delete_csh_pay_ref_user_groups(p_csh_pay_ref_user_groups_id NUMBER) IS
  BEGIN
    DELETE FROM csh_pay_ref_user_groups
     WHERE csh_pay_ref_user_groups_id = p_csh_pay_ref_user_groups_id;
  END delete_csh_pay_ref_user_groups;

  FUNCTION get_pay_req_trs_class_id RETURN NUMBER IS
    v_csh_pay_req_trs_class_id csh_pay_req_type_trs_classes.pay_req_trs_class_id%TYPE;
  BEGIN
    SELECT csh_pay_req_type_trs_classes_s.nextval
      INTO v_csh_pay_req_trs_class_id
      FROM dual;
    RETURN v_csh_pay_req_trs_class_id;
  END get_pay_req_trs_class_id;

  FUNCTION get_sob_pay_req_trs_class_id RETURN NUMBER IS
    v_csh_sob_pay_req_trs_class_id csh_sob_pay_req_type_classes.pay_req_trs_class_id%TYPE;
  BEGIN
    SELECT csh_sob_pay_req_type_classes_s.nextval
      INTO v_csh_sob_pay_req_trs_class_id
      FROM dual;
  
    RETURN v_csh_sob_pay_req_trs_class_id;
  END get_sob_pay_req_trs_class_id;

  PROCEDURE insert_csh_pay_type_classes(p_pay_req_type_id      NUMBER,
                                        p_class_code           VARCHAR2,
                                        p_enabled_flag         VARCHAR2,
                                        p_user_id              NUMBER,
                                        p_pay_req_trs_class_id OUT NUMBER,
                                        p_req_required_flag    VARCHAR2 DEFAULT NULL) IS
  
    v_pay_req_trs_class_id csh_pay_req_type_trs_classes.pay_req_trs_class_id%TYPE;
    v_count                NUMBER;
    e_types_duplicate_error EXCEPTION;
  
  BEGIN
    v_pay_req_trs_class_id := get_pay_req_trs_class_id;
  
    SELECT COUNT(*)
      INTO v_count
      FROM csh_pay_req_type_trs_classes t
     WHERE t.pay_req_type_id = p_pay_req_type_id
       AND t.class_code = p_class_code;
  
    IF v_count > 0 THEN
      RAISE e_types_duplicate_error;
    END IF;
  
    INSERT INTO csh_pay_req_type_trs_classes
      (pay_req_trs_class_id,
       pay_req_type_id,
       class_code,
       enabled_flag,
       req_required_flag,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by)
    VALUES
      (v_pay_req_trs_class_id,
       p_pay_req_type_id,
       p_class_code,
       p_enabled_flag,
       p_req_required_flag,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_user_id);
    p_pay_req_trs_class_id := v_pay_req_trs_class_id;
  EXCEPTION
    WHEN e_types_duplicate_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH2010_TYPES_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_pay_req_types_pkg',
                                                      p_procedure_function_name => 'insert_csh_pay_type_classes');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN dup_val_on_index THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH2010_TYPES_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_pay_req_types_pkg',
                                                      p_procedure_function_name => 'insert_csh_pay_type_classes');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_pay_req_types_pkg',
                                                     p_procedure_function_name => 'insert_csh_pay_type_classes');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_csh_pay_type_classes;

  --插入帐套级借款类型
  PROCEDURE insert_sob_pay_type_classes(p_pay_req_type_id NUMBER,
                                        p_class_code      VARCHAR2,
                                        p_enabled_flag    VARCHAR2,
                                        p_user_id         NUMBER,
                                        --add by Qu yuanyuan 是否必须关联申请标志
                                        p_req_required_flag    VARCHAR2,
                                        p_pay_req_trs_class_id OUT NUMBER) IS
  
    v_pay_req_trs_class_id csh_sob_pay_req_type_classes.pay_req_trs_class_id%TYPE;
    v_count                NUMBER;
    e_types_duplicate_error EXCEPTION;
    v_class_id   NUMBER;
    v_class_coms NUMBER;
  
  BEGIN
    v_pay_req_trs_class_id := get_sob_pay_req_trs_class_id;
  
    SELECT COUNT(*)
      INTO v_count
      FROM csh_sob_pay_req_type_classes t
     WHERE t.pay_req_type_id = p_pay_req_type_id
       AND t.class_code = p_class_code;
  
    IF v_count > 0 THEN
      RAISE e_types_duplicate_error;
    END IF;
    --插入帐套级关联表
    INSERT INTO csh_sob_pay_req_type_classes
      (pay_req_trs_class_id,
       pay_req_type_id,
       class_code,
       enabled_flag,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by,
       req_required_flag)
    VALUES
      (v_pay_req_trs_class_id,
       p_pay_req_type_id,
       p_class_code,
       p_enabled_flag,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_user_id,
       p_req_required_flag);
    p_pay_req_trs_class_id := v_pay_req_trs_class_id;
  
    --分配到公司级借款申请单类型表中
    --如果此现金事务没有分配公司，则自动分配公司
    FOR c_record IN (SELECT *
                       FROM csh_pay_req_types_vl cprtv
                      WHERE cprtv.type_code =
                            (SELECT csp.type_code
                               FROM csh_sob_pay_req_types_vl csp
                              WHERE csp.type_id = p_pay_req_type_id)) LOOP
      insert_csh_pay_type_classes_v(p_pay_req_type_id      => c_record.type_id,
                                    p_class_code           => p_class_code,
                                    p_enabled_flag         => p_enabled_flag,
                                    p_user_id              => p_user_id,
                                    p_req_required_flag    => p_req_required_flag,
                                    p_pay_req_trs_class_id => v_class_id);
      csh_transaction_classes_pkg.insert_csh_company_trn_classes(p_company_id                 => c_record.company_id,
                                                                 p_csh_transaction_class_code => p_class_code,
                                                                 p_enabled_flag               => p_enabled_flag,
                                                                 p_user_id                    => p_user_id);
    END LOOP;
  
  EXCEPTION
    WHEN e_types_duplicate_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH2010_TYPES_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_pay_req_types_pkg',
                                                      p_procedure_function_name => 'insert_sob_pay_type_classes');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN dup_val_on_index THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH2010_TYPES_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_pay_req_types_pkg',
                                                      p_procedure_function_name => 'insert_sob_pay_type_classes');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_pay_req_types_pkg',
                                                     p_procedure_function_name => 'insert_sob_pay_type_classes');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_sob_pay_type_classes;

  PROCEDURE update_csh_pay_type_classes(p_pay_req_trs_class_id NUMBER,
                                        p_pay_req_type_id      NUMBER,
                                        p_class_code           VARCHAR2,
                                        p_enabled_flag         VARCHAR2,
                                        p_user_id              NUMBER,
                                        p_req_required_flag    VARCHAR2 DEFAULT NULL) IS
  
  BEGIN
    UPDATE csh_pay_req_type_trs_classes l
       SET enabled_flag        = p_enabled_flag,
           l.req_required_flag = p_req_required_flag,
           last_update_date    = SYSDATE,
           last_updated_by     = p_user_id
     WHERE l.pay_req_trs_class_id = p_pay_req_trs_class_id;
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_pay_req_types_pkg',
                                                     p_procedure_function_name => 'update_csh_pay_type_classes');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_csh_pay_type_classes;

  PROCEDURE update_sob_pay_type_classes(p_pay_req_trs_class_id NUMBER,
                                        p_pay_req_type_id      NUMBER,
                                        p_type_code            VARCHAR,
                                        p_set_of_books_id      NUMBER,
                                        p_class_code           VARCHAR2,
                                        p_enabled_flag         VARCHAR2,
                                        p_user_id              NUMBER,
                                        --add by Qu yuanyuan 是否必输关联申请
                                        p_req_required_flag VARCHAR2) IS
    v_class_code VARCHAR2(100);
    --更新帐套级数据
  BEGIN
    UPDATE csh_sob_pay_req_type_classes l
       SET enabled_flag      = p_enabled_flag,
           last_update_date  = SYSDATE,
           last_updated_by   = p_user_id,
           req_required_flag = p_req_required_flag
    
     WHERE l.pay_req_trs_class_id = p_pay_req_trs_class_id;
  
    SELECT l.class_code
      INTO v_class_code
      FROM csh_sob_pay_req_type_classes l
     WHERE l.pay_req_trs_class_id = p_pay_req_trs_class_id;
  
    --更新公司级数据
    UPDATE csh_pay_req_type_trs_classes
       SET enabled_flag      = p_enabled_flag,
           last_update_date  = SYSDATE,
           last_updated_by   = p_user_id,
           req_required_flag = p_req_required_flag
     WHERE pay_req_type_id IN
           (SELECT cpr.type_id
              FROM fnd_companies fc, csh_pay_req_types cpr
             WHERE fc.set_of_books_id = p_set_of_books_id
               AND class_code = v_class_code
               AND cpr.type_code = p_type_code
               AND fc.company_id = cpr.company_id);
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_pay_req_types_pkg',
                                                     p_procedure_function_name => 'update_sob_pay_type_classes');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_sob_pay_type_classes;
END csh_pay_req_types_pkg;
/
