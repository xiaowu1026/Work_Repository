CREATE OR REPLACE PACKAGE exp_employees_pkg IS

  -- Author  : xiaoguojun
  -- Created : 2009-4-16 15:08:24
  -- Purpose :

  PROCEDURE insert_employees_with_check( p_employee_code    VARCHAR2 DEFAULT NULL,
                                         p_name             VARCHAR2 DEFAULT NULL,
                                         p_email            VARCHAR2 DEFAULT NULL,
                                         p_mobil            VARCHAR2 DEFAULT NULL,
                                         p_phone            VARCHAR2 DEFAULT NULL,
                                         p_enabled_flag     VARCHAR2 DEFAULT NULL,
                                         p_created_by       NUMBER   DEFAULT NULL,
                                         p_bank_of_deposit  VARCHAR2 DEFAULT NULL,
                                         p_bank_account     VARCHAR2 DEFAULT NULL,
                                         p_employee_type_id NUMBER   DEFAULT NULL,
                                         p_id_type          VARCHAR2 DEFAULT NULL,
                                         p_id_code          VARCHAR2 DEFAULT NULL,
                                         p_notes            VARCHAR2 DEFAULT NULL,
                                         p_city_name        VARCHAR2 DEFAULT NULL,
                                         p_approve_code     VARCHAR2 DEFAULT NULL,
                                         p_approve_name     VARCHAR2 DEFAULT NULL,
                                         p_employee_id      OUT NUMBER ,
                                         p_sex              VARCHAR2 DEFAULT NULL,
                                         p_edit_flag        VARCHAR2 DEFAULT NULL);
                                         
                                         


  PROCEDURE insert_employees(p_employee_code    VARCHAR2 DEFAULT NULL,
                             p_name             VARCHAR2 DEFAULT NULL,
                             p_email            VARCHAR2 DEFAULT NULL,
                             p_mobil            VARCHAR2 DEFAULT NULL,
                             p_phone            VARCHAR2 DEFAULT NULL,
                             p_enabled_flag     VARCHAR2 DEFAULT NULL,
                             p_created_by       NUMBER   DEFAULT NULL,
                             p_bank_of_deposit  VARCHAR2 DEFAULT NULL,
                             p_bank_account     VARCHAR2 DEFAULT NULL,
                             p_employee_type_id NUMBER   DEFAULT NULL,
                             p_id_type          VARCHAR2 DEFAULT NULL,
                             p_id_code          VARCHAR2 DEFAULT NULL,
                             p_notes            VARCHAR2 DEFAULT NULL,
                             p_city_name        VARCHAR2 DEFAULT NULL,
                             p_approve_code     VARCHAR2 DEFAULT NULL,
                             p_approve_name     VARCHAR2 DEFAULT NULL,
                             p_employee_id      OUT NUMBER  ,
                             p_sex              VARCHAR2 DEFAULT NULL,
                             p_edit_flag        VARCHAR2 DEFAULT NULL);

  PROCEDURE delete_employees(p_employee_id NUMBER);

  PROCEDURE update_employees(p_employee_id     NUMBER,
                             p_name            VARCHAR2,
                             p_email           VARCHAR2,
                             p_mobil           VARCHAR2,
                             p_phone           VARCHAR2,
                             p_enabled_flag    VARCHAR2,
                             p_created_by      NUMBER,
                             p_bank_of_deposit VARCHAR2,
                             p_bank_account    VARCHAR2,
                             p_id_type         VARCHAR2,
                             p_id_code         VARCHAR2,
                             p_notes           VARCHAR2,
                             p_city_name       VARCHAR2 DEFAULT NULL,
                             p_approve_code    VARCHAR2 DEFAULT NULL,
                             p_approve_name    VARCHAR2 DEFAULT NULL,
                             p_sex             VARCHAR2 DEFAULT NULL);

  FUNCTION get_employee_assigns_id RETURN NUMBER;

  PROCEDURE primary_position_flag_check(p_employee_id NUMBER,
                                        p_user_id     NUMBER);

  --分配员工
  PROCEDURE insert_exp_employee_assigns(p_employee_id           NUMBER,
                                        p_company_id            NUMBER,
                                        p_position_id           NUMBER,
                                        p_employee_job_id       NUMBER,
                                        p_employee_levels_id    NUMBER,
                                        p_primary_position_flag VARCHAR2,
                                        p_enabled_flag          VARCHAR2,
                                        p_user_id               NUMBER,
                                        p_employees_assign_id   OUT NUMBER);

  PROCEDURE update_exp_employee_assigns(p_employees_assign_id   NUMBER,
                                        p_employee_id           NUMBER,
                                        p_company_id            NUMBER,
                                        p_position_id           NUMBER,
                                        p_employee_job_id       NUMBER,
                                        p_employee_levels_id    NUMBER,
                                        p_primary_position_flag VARCHAR2,
                                        p_enabled_flag          VARCHAR2,
                                        p_user_id               NUMBER);

  --银行账户
  PROCEDURE insert_exp_bank_assigns(p_employee_id        NUMBER,
                                    p_line_number        NUMBER,
                                    p_bank_code          VARCHAR2,
                                    p_bank_name          VARCHAR2,
                                    p_bank_location_code VARCHAR2,
                                    p_bank_location      VARCHAR2,
                                    p_province_code      VARCHAR2,
                                    p_province_name      VARCHAR2,
                                    p_city_code          VARCHAR2,
                                    p_city_name          VARCHAR2,
                                    p_account_number     VARCHAR2,
                                    p_account_name       VARCHAR2,
                                    p_notes              VARCHAR2,
                                    p_primary_flag       VARCHAR2,
                                    p_enabled_flag       VARCHAR2,
                                    p_user_id            NUMBER,
                                    p_sparticipantbankno VARCHAR2,
                                    p_account_flag       VARCHAR2,
                                    p_edit_flag          VARCHAR2 default null,
                                    p_same_city_flag     VARCHAR2 default null,
                                    p_same_bank_flag     VARCHAR2 default null);

  PROCEDURE update_exp_bank_assigns(p_employee_id        NUMBER,
                                    p_line_number        NUMBER,
                                    p_bank_code          VARCHAR2,
                                    p_bank_name          VARCHAR2,
                                    p_bank_location_code VARCHAR2,
                                    p_bank_location      VARCHAR2,
                                    p_province_code      VARCHAR2,
                                    p_province_name      VARCHAR2,
                                    p_city_code          VARCHAR2,
                                    p_city_name          VARCHAR2,
                                    p_account_number     VARCHAR2,
                                    p_account_name       VARCHAR2,
                                    p_notes              VARCHAR2,
                                    p_primary_flag       VARCHAR2,
                                    p_enabled_flag       VARCHAR2,
                                    p_user_id            NUMBER,
                                    p_sparticipantbankno VARCHAR2,
                                    p_account_flag       VARCHAR2,
                                    p_same_city_flag     VARCHAR2 default null,
                                    p_same_bank_flag     VARCHAR2 default null);

  PROCEDURE delete_exp_bank_assigns(p_employee_id NUMBER,
                                    p_line_number NUMBER);

  FUNCTION get_accounts_max_line_number(p_employee_id NUMBER) RETURN NUMBER;

END exp_employees_pkg;


 
/
CREATE OR REPLACE PACKAGE BODY exp_employees_pkg IS

  e_company_position_error EXCEPTION;
  e_primary_flag_error     EXCEPTION;

  PROCEDURE insert_employees_with_check(p_employee_code    VARCHAR2 DEFAULT NULL,
                                        p_name             VARCHAR2 DEFAULT NULL,
                                        p_email            VARCHAR2 DEFAULT NULL,
                                        p_mobil            VARCHAR2 DEFAULT NULL,
                                        p_phone            VARCHAR2 DEFAULT NULL,
                                        p_enabled_flag     VARCHAR2 DEFAULT NULL,
                                        p_created_by       NUMBER DEFAULT NULL,
                                        p_bank_of_deposit  VARCHAR2 DEFAULT NULL,
                                        p_bank_account     VARCHAR2 DEFAULT NULL,
                                        p_employee_type_id NUMBER DEFAULT NULL,
                                        p_id_type          VARCHAR2 DEFAULT NULL,
                                        p_id_code          VARCHAR2 DEFAULT NULL,
                                        p_notes            VARCHAR2 DEFAULT NULL,
                                        p_city_name        VARCHAR2 DEFAULT NULL,
                                        p_approve_code     VARCHAR2 DEFAULT NULL,
                                        p_approve_name     VARCHAR2 DEFAULT NULL,
                                        p_employee_id      OUT NUMBER,
                                        p_sex              VARCHAR2 DEFAULT NULL,
                                        p_edit_flag        VARCHAR2 DEFAULT NULL) IS
    v_emp_code_count  number;
    v_emp_email_count number;
  begin
    select count(1)
      into v_emp_code_count
      from exp_employees e
     where e.employee_code = p_employee_code;
    select count(1)
      into v_emp_email_count
      from exp_employees e
     where e.email = p_email;
    if v_emp_code_count > 0 then
      --若有员工代码或者邮箱重复，抛错
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP_EMPLOYEE_CODE_UNIQUE_ERROR', --
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'EXP_EMPLOYEES_PKG',
                                                      p_procedure_function_name => 'INSERT_EMPLOYEES');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    else
      if v_emp_email_count > 0 then
        sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP_EMPLOYEE_EMAIL_UNIQUE_ERROR', --
                                                        p_created_by              => p_created_by,
                                                        p_package_name            => 'EXP_EMPLOYEES_PKG',
                                                        p_procedure_function_name => 'INSERT_EMPLOYEES');
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
      else
        insert_employees(p_employee_code,
                         p_name,
                         p_email,
                         p_mobil,
                         p_phone,
                         p_enabled_flag,
                         p_created_by,
                         p_bank_of_deposit,
                         p_bank_account,
                         p_employee_type_id,
                         p_id_type,
                         p_id_code,
                         p_notes,
                         p_city_name,
                         p_approve_code,
                         p_approve_name,
                         p_employee_id,
                         p_sex,
                         p_edit_flag);
      
      end if;
    end if;
  
  END;

  PROCEDURE insert_employees(p_employee_code    VARCHAR2 DEFAULT NULL,
                             p_name             VARCHAR2 DEFAULT NULL,
                             p_email            VARCHAR2 DEFAULT NULL,
                             p_mobil            VARCHAR2 DEFAULT NULL,
                             p_phone            VARCHAR2 DEFAULT NULL,
                             p_enabled_flag     VARCHAR2 DEFAULT NULL,
                             p_created_by       NUMBER DEFAULT NULL,
                             p_bank_of_deposit  VARCHAR2 DEFAULT NULL,
                             p_bank_account     VARCHAR2 DEFAULT NULL,
                             p_employee_type_id NUMBER DEFAULT NULL,
                             p_id_type          VARCHAR2 DEFAULT NULL,
                             p_id_code          VARCHAR2 DEFAULT NULL,
                             p_notes            VARCHAR2 DEFAULT NULL,
                             p_city_name        VARCHAR2 DEFAULT NULL,
                             p_approve_code     VARCHAR2 DEFAULT NULL,
                             p_approve_name     VARCHAR2 DEFAULT NULL,
                             p_employee_id      OUT NUMBER,
                             p_sex              VARCHAR2 DEFAULT NULL,
                             p_edit_flag        VARCHAR2 DEFAULT NULL) IS
    v_employee_id exp_employees.employee_id%TYPE;
  BEGIN
    SELECT exp_employees_s.nextval INTO v_employee_id FROM dual;
    INSERT INTO exp_employees
      (employee_id,
       employee_code,
       NAME,
       email,
       mobil,
       phone,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       bank_of_deposit,
       bank_account,
       employee_type_id,
       id_type,
       id_code,
       notes,
       approve_code,
       approve_name,
       sex,
       edit_flag)
    VALUES
      (v_employee_id,
       upper(p_employee_code),
       p_name,
       p_email,
       p_mobil,
       p_phone,
       p_enabled_flag,
       p_created_by,
       SYSDATE,
       p_created_by,
       SYSDATE,
       p_bank_of_deposit,
       p_bank_account,
       p_employee_type_id,
       p_id_type,
       p_id_code,
       p_notes,
       p_approve_code,
       p_approve_name,
       p_sex,
       p_edit_flag);
    p_employee_id := v_employee_id;
  
    --新建员工的时候默认给他一个普通员工的门户角色
    ptl_announcement_pkg.ptl_normal_user_role_assign(p_employee_id => v_employee_id,
                                                     p_user_id     => p_created_by);
  
    --插入系统级供应商，作为员工供应商
    exp_data_load_pkg.load_venders(p_company_code       => '1000',
                                   p_vender_type_code   => 'ZV11',
                                   p_vender_code        => p_employee_code,
                                   p_vender_name        => p_name,
                                   p_vender_description => p_name,
                                   p_enabled_flag       => 'Y');
  EXCEPTION
    WHEN dup_val_on_index THEN
      --若有insert 表，捕获 唯一索引错误
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP_EMPLOYEES_UNIQUE_ERROR', --
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'EXP_EMPLOYEES_PKG',
                                                      p_procedure_function_name => 'INSERT_EMPLOYEES');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'EXP_EMPLOYEES_PKG',
                                                     p_procedure_function_name => 'INSERT_EMPLOYEES');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END insert_employees;

  PROCEDURE delete_employees(p_employee_id NUMBER) IS
  BEGIN
    DELETE exp_employees t WHERE t.employee_id = p_employee_id;
  END delete_employees;

  PROCEDURE update_employees(p_employee_id     NUMBER,
                             p_name            VARCHAR2,
                             p_email           VARCHAR2,
                             p_mobil           VARCHAR2,
                             p_phone           VARCHAR2,
                             p_enabled_flag    VARCHAR2,
                             p_created_by      NUMBER,
                             p_bank_of_deposit VARCHAR2,
                             p_bank_account    VARCHAR2,
                             p_id_type         VARCHAR2,
                             p_id_code         VARCHAR2,
                             p_notes           VARCHAR2,
                             p_city_name       VARCHAR2 DEFAULT NULL,
                             p_approve_code    VARCHAR2 DEFAULT NULL,
                             p_approve_name    VARCHAR2 DEFAULT NULL,
                             p_sex             VARCHAR2 DEFAULT NULL) IS
  
  BEGIN
    UPDATE exp_employees t
       SET NAME             = p_name,
           email            = p_email,
           mobil            = p_mobil,
           phone            = p_phone,
           enabled_flag     = p_enabled_flag,
           last_updated_by  = p_created_by,
           last_update_date = SYSDATE,
           bank_of_deposit  = p_bank_of_deposit,
           bank_account     = p_bank_account,
           id_type          = nvl(p_id_type, id_type),
           id_code          = nvl(p_id_code, id_code),
           notes            = nvl(p_notes, notes),
           approve_code     = p_approve_code,
           approve_name     = p_approve_name， sex = nvl(p_sex, sex)
     WHERE t.employee_id = p_employee_id;
  
    /* 如果员工失效，那么该员工 的分配都失效*/
  
    IF p_enabled_flag = 'N' THEN
      UPDATE exp_employee_assigns a
         SET a.enabled_flag     = p_enabled_flag,
             a.last_update_date = SYSDATE,
             a.last_updated_by  = p_created_by
       WHERE a.employee_id = p_employee_id;
    END IF;
  
  END update_employees;

  FUNCTION get_employee_assigns_id RETURN NUMBER IS
    v_employees_assign_id exp_employee_assigns.employees_assign_id%TYPE;
  BEGIN
    SELECT exp_employee_assigns_s.nextval
      INTO v_employees_assign_id
      FROM dual;
    RETURN v_employees_assign_id;
  END get_employee_assigns_id;

  PROCEDURE primary_position_flag_check(p_employee_id NUMBER,
                                        p_user_id     NUMBER) IS
    v_count NUMBER;
  
    e_primary_flag_null         EXCEPTION;
    e_enabled_primary_flag_null EXCEPTION;
    e_primary_position_flag     EXCEPTION;
  
    CURSOR cur_company IS
      SELECT DISTINCT a.company_id, b.company_code
        FROM exp_employee_assigns a, fnd_companies b
       WHERE a.employee_id = p_employee_id
         AND a.company_id = b.company_id;
  
    v_company cur_company%ROWTYPE;
  BEGIN
    OPEN cur_company;
    LOOP
      FETCH cur_company
        INTO v_company;
      EXIT WHEN cur_company%NOTFOUND;
    
      SELECT COUNT(1)
        INTO v_count
        FROM exp_employee_assigns a
       WHERE a.employee_id = p_employee_id
         AND a.company_id = v_company.company_id
         AND a.primary_position_flag = 'Y'
         AND a.enabled_flag = 'Y'; --add wgf 2013/1/16
    
      IF v_count > 1 THEN
        RAISE e_primary_position_flag;
        /*elsif v_count = 0 then
        raise e_primary_flag_null;*/
      END IF;
    
      --有启用的公司
      SELECT COUNT(1)
        INTO v_count
        FROM exp_employee_assigns a
       WHERE a.employee_id = p_employee_id
         AND a.company_id = v_company.company_id
         AND a.enabled_flag = 'Y';
      IF v_count > 0 THEN
        --主岗位必须启用
        SELECT COUNT(1)
          INTO v_count
          FROM exp_employee_assigns a
         WHERE a.employee_id = p_employee_id
           AND a.company_id = v_company.company_id
           AND a.primary_position_flag = 'Y'
           AND a.enabled_flag = 'Y';
        IF v_count = 0 THEN
          RAISE e_enabled_primary_flag_null;
        END IF;
      END IF;
    
    END LOOP;
    CLOSE cur_company;
  EXCEPTION
    WHEN e_primary_position_flag THEN
      IF cur_company%ISOPEN THEN
        CLOSE cur_company;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP1050_PRIMARY_POSITION_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_EMPLOYEES_PKG',
                                                      p_procedure_function_name => 'UPDATE_exp_employee_assigns',
                                                      p_token_1                 => '#COMPANY_CODE',
                                                      p_token_value_1           => v_company.company_code);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_primary_flag_null THEN
      IF cur_company%ISOPEN THEN
        CLOSE cur_company;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP1050_PRIMARY_POSITION_NULL',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_EMPLOYEES_PKG',
                                                      p_procedure_function_name => 'primary_position_flag_check',
                                                      p_token_1                 => '#COMPANY_CODE',
                                                      p_token_value_1           => v_company.company_code);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_enabled_primary_flag_null THEN
      IF cur_company%ISOPEN THEN
        CLOSE cur_company;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP1050_ENABLED_PRIMARY_POSITION_NULL',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_EMPLOYEES_PKG',
                                                      p_procedure_function_name => 'primary_position_flag_check',
                                                      p_token_1                 => '#COMPANY_CODE',
                                                      p_token_value_1           => v_company.company_code);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END primary_position_flag_check;

  PROCEDURE company_position_check(p_employee_id NUMBER,
                                   p_company_id  NUMBER,
                                   p_position_id NUMBER) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM exp_employee_assigns a
     WHERE a.employee_id = p_employee_id
       AND a.company_id = p_company_id
       AND a.position_id = p_position_id;
  
    IF v_count > 1 THEN
      RAISE e_company_position_error;
    END IF;
  END company_position_check;

  --分配员工
  PROCEDURE insert_exp_employee_assigns(p_employee_id           NUMBER,
                                        p_company_id            NUMBER,
                                        p_position_id           NUMBER,
                                        p_employee_job_id       NUMBER,
                                        p_employee_levels_id    NUMBER,
                                        p_primary_position_flag VARCHAR2,
                                        p_enabled_flag          VARCHAR2,
                                        p_user_id               NUMBER,
                                        p_employees_assign_id   OUT NUMBER) IS
  
  BEGIN
    p_employees_assign_id := get_employee_assigns_id;
    INSERT INTO exp_employee_assigns
      (employees_assign_id,
       employee_id,
       company_id,
       position_id,
       employee_job_id,
       employee_levels_id,
       primary_position_flag,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (p_employees_assign_id,
       p_employee_id,
       p_company_id,
       p_position_id,
       p_employee_job_id,
       p_employee_levels_id,
       p_primary_position_flag,
       p_enabled_flag,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE);
    /*primary_position_flag_check(p_employee_id => p_employee_id,
    p_company_id  => p_company_id,
    p_user_id     => p_user_id);*/
    company_position_check(p_employee_id => p_employee_id,
                           p_company_id  => p_company_id,
                           p_position_id => p_position_id);
  EXCEPTION
    WHEN e_company_position_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP1050_COMPANY_POSITION_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_EMPLOYEES_PKG',
                                                      p_procedure_function_name => 'UPDATE_exp_employee_assigns');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN dup_val_on_index THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP1050_EMPLOYEES_ASSIGNS_DUPLICATE', --
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_EMPLOYEES_PKG',
                                                      p_procedure_function_name => 'INSERT_exp_employee_assigns');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'EXP_EMPLOYEES_PKG',
                                                     p_procedure_function_name => 'INSERT_exp_employee_assigns');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_exp_employee_assigns;

  PROCEDURE update_exp_employee_assigns(p_employees_assign_id   NUMBER,
                                        p_employee_id           NUMBER,
                                        p_company_id            NUMBER,
                                        p_position_id           NUMBER,
                                        p_employee_job_id       NUMBER,
                                        p_employee_levels_id    NUMBER,
                                        p_primary_position_flag VARCHAR2,
                                        p_enabled_flag          VARCHAR2,
                                        p_user_id               NUMBER) IS
  BEGIN
    UPDATE exp_employee_assigns a
       SET a.last_updated_by       = p_user_id,
           a.last_update_date      = SYSDATE,
           a.company_id            = p_company_id,
           a.position_id           = p_position_id,
           a.employee_job_id       = nvl(p_employee_job_id, employee_job_id),
           a.employee_levels_id    = nvl(p_employee_levels_id,
                                         employee_levels_id),
           a.primary_position_flag = p_primary_position_flag,
           a.enabled_flag          = p_enabled_flag
     WHERE a.employees_assign_id = p_employees_assign_id;
  
    /*primary_position_flag_check(p_employee_id => p_employee_id,
    p_company_id  => p_company_id,
    p_user_id     => p_user_id);*/
    company_position_check(p_employee_id => p_employee_id,
                           p_company_id  => p_company_id,
                           p_position_id => p_position_id);
  EXCEPTION
  
    WHEN e_company_position_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP1050_COMPANY_POSITION_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_EMPLOYEES_PKG',
                                                      p_procedure_function_name => 'UPDATE_exp_employee_assigns');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN dup_val_on_index THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP1050_EMPLOYEES_ASSIGNS_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_EMPLOYEES_PKG',
                                                      p_procedure_function_name => 'UPDATE_exp_employee_assigns');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_exp_employee_assigns;

  --一个员工只能有一个主账号
  PROCEDURE primary_flag_check(p_employee_id NUMBER) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM exp_employee_accounts e
     WHERE e.employee_id = p_employee_id
       AND e.primary_flag = 'Y';
  
    IF v_count > 0 THEN
      RAISE e_primary_flag_error;
    END IF;
  END primary_flag_check;

  --银行账户
  PROCEDURE insert_exp_bank_assigns(p_employee_id        NUMBER,
                                    p_line_number        NUMBER,
                                    p_bank_code          VARCHAR2,
                                    p_bank_name          VARCHAR2,
                                    p_bank_location_code VARCHAR2,
                                    p_bank_location      VARCHAR2,
                                    p_province_code      VARCHAR2,
                                    p_province_name      VARCHAR2,
                                    p_city_code          VARCHAR2,
                                    p_city_name          VARCHAR2,
                                    p_account_number     VARCHAR2,
                                    p_account_name       VARCHAR2,
                                    p_notes              VARCHAR2,
                                    p_primary_flag       VARCHAR2,
                                    p_enabled_flag       VARCHAR2,
                                    p_user_id            NUMBER,
                                    p_sparticipantbankno VARCHAR2,
                                    p_account_flag       VARCHAR2,
                                    p_edit_flag          VARCHAR2 default null,
                                    p_same_city_flag     VARCHAR2 default null,
                                    p_same_bank_flag     VARCHAR2 default null) IS
  BEGIN
    --若插入信息的主账号为Y时，检查是否唯一
    IF p_primary_flag = 'Y' THEN
      primary_flag_check(p_employee_id => p_employee_id);
    END IF;
  
    INSERT INTO exp_employee_accounts
      (employee_id,
       line_number,
       bank_code,
       bank_name,
       bank_location_code,
       bank_location,
       province_code,
       province_name,
       city_code,
       city_name,
       account_number,
       account_name,
       notes,
       primary_flag,
       enabled_flag,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by,
       sparticipantbankno,
       account_flag,
       edit_flag,
       same_city_flag,
       same_bank_flag)
    VALUES
      (p_employee_id,
       p_line_number,
       p_bank_code,
       p_bank_name,
       p_bank_location_code,
       p_bank_location,
       p_province_code,
       p_province_name,
       p_city_code,
       p_city_name,
       p_account_number,
       p_account_name,
       p_notes,
       p_primary_flag,
       p_enabled_flag,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_user_id,
       p_sparticipantbankno,
       p_account_flag,
       p_edit_flag,
       p_same_city_flag,
       p_same_bank_flag);
  
  EXCEPTION
    WHEN e_primary_flag_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP1050_PRIMARY_FLAG_CHECK_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_EMPLOYEES_PKG',
                                                      p_procedure_function_name => 'insert_exp_bank_assigns');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN dup_val_on_index THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP1050_BANK_ASSIGNS_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_EMPLOYEES_PKG',
                                                      p_procedure_function_name => 'insert_exp_bank_assigns');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END insert_exp_bank_assigns;

  PROCEDURE update_exp_bank_assigns(p_employee_id        NUMBER,
                                    p_line_number        NUMBER,
                                    p_bank_code          VARCHAR2,
                                    p_bank_name          VARCHAR2,
                                    p_bank_location_code VARCHAR2,
                                    p_bank_location      VARCHAR2,
                                    p_province_code      VARCHAR2,
                                    p_province_name      VARCHAR2,
                                    p_city_code          VARCHAR2,
                                    p_city_name          VARCHAR2,
                                    p_account_number     VARCHAR2,
                                    p_account_name       VARCHAR2,
                                    p_notes              VARCHAR2,
                                    p_primary_flag       VARCHAR2,
                                    p_enabled_flag       VARCHAR2,
                                    p_user_id            NUMBER,
                                    p_sparticipantbankno VARCHAR2,
                                    p_account_flag       VARCHAR2,
                                    p_same_city_flag     VARCHAR2 default null,
                                    p_same_bank_flag     VARCHAR2 default null) IS
  BEGIN
    IF p_primary_flag = 'Y' THEN
      FOR v_record IN (SELECT *
                         FROM exp_employee_accounts eea
                        WHERE eea.employee_id = p_employee_id
                          AND eea.primary_flag = 'Y') LOOP
        UPDATE exp_employee_accounts a
           SET a.primary_flag = 'N'
         WHERE a.employee_id = v_record.employee_id
           AND a.line_number = v_record.line_number;
      END LOOP;
    END IF;
  
    UPDATE exp_employee_accounts
       SET employee_id        = p_employee_id,
           line_number        = p_line_number,
           bank_code          = nvl(p_bank_code, bank_code),
           bank_name          = nvl(p_bank_name, bank_name),
           bank_location_code = nvl(p_bank_location_code, bank_location_code),
           bank_location      = nvl(p_bank_location, bank_location),
           province_code      = nvl(p_province_code, province_code),
           province_name      = nvl(p_province_name, province_name),
           city_code          = nvl(p_city_code, city_code),
           city_name          = nvl(p_city_name, city_name),
           account_number     = p_account_number,
           account_name       = p_account_name,
           notes              = p_notes,
           primary_flag       = nvl(p_primary_flag, primary_flag),
           enabled_flag       = nvl(p_enabled_flag, enabled_flag),
           creation_date      = SYSDATE,
           created_by         = p_user_id,
           last_update_date   = SYSDATE,
           last_updated_by    = p_user_id,
           sparticipantbankno = nvl(p_sparticipantbankno, sparticipantbankno),
           account_flag       = p_account_flag,
           same_city_flag     = p_same_city_flag,
           same_bank_flag     = p_same_bank_flag
     WHERE employee_id = p_employee_id
       AND line_number = p_line_number;
  
  EXCEPTION
    WHEN dup_val_on_index THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP1050_BANK_ASSIGNS_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_EMPLOYEES_PKG',
                                                      p_procedure_function_name => 'insert_exp_bank_assigns');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END update_exp_bank_assigns;

  PROCEDURE delete_exp_bank_assigns(p_employee_id NUMBER,
                                    p_line_number NUMBER) IS
  BEGIN
    DELETE exp_employee_accounts a
     WHERE a.employee_id = p_employee_id
       AND a.line_number = p_line_number;
  END delete_exp_bank_assigns;

  FUNCTION get_accounts_max_line_number(p_employee_id NUMBER) RETURN NUMBER IS
    v_line_number NUMBER;
  BEGIN
    SELECT MAX(eea.line_number)
      INTO v_line_number
      FROM exp_employee_accounts eea
     WHERE eea.employee_id = p_employee_id;
  
    IF v_line_number IS NULL THEN
      v_line_number := 0;
    END IF;
    RETURN v_line_number;
  
  END get_accounts_max_line_number;

END exp_employees_pkg;
/
