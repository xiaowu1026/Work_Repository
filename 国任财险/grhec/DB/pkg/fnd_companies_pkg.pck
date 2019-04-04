CREATE OR REPLACE PACKAGE fnd_companies_pkg IS

  -- Author  : xiaoguojun
  -- Created : 2009-4-16 9:39:39
  -- Purpose :
  PROCEDURE insert_fnd_companies(p_company_code       VARCHAR2,
                                 p_company_type       VARCHAR2,
                                 p_company_short_name VARCHAR2,
                                 p_company_full_name  VARCHAR2,
                                 -- p_company_icon       blob,
                                 p_set_of_books_id        NUMBER,
                                 p_company_level_id       NUMBER,
                                 p_chief_position_id      NUMBER,
                                 p_parent_company_id      NUMBER,
                                 p_address                VARCHAR2,
                                 p_start_date_active      DATE,
                                 p_end_date_active        DATE,
                                 p_created_by             NUMBER,
                                 p_language_code          VARCHAR2,
                                 p_company_low_level_id   NUMBER DEFAULT NULL,
                                 p_no_tax_sd_flag         VARCHAR2 DEFAULT 'N',
                                 p_taxpayer_flag          VARCHAR2 DEFAULT 'N',
                                 p_t3_value               VARCHAR2 DEFAULT NULL,
                                 p_db_code                VARCHAR2 DEFAULT NULL,
                                 p_fina_audit_position_id NUMBER DEFAULT NULL,
                                 p_fina_resp_position_id  NUMBER DEFAULT NULL,
                                 p_hr_head_position_id    NUMBER DEFAULT NULL,
                                 p_fina_head_position_id  NUMBER DEFAULT NULL,
                                 p_budget_position_id     number default null,
                                 p_parent_com_charge_man  NUMBER DEFAULT NULL,
                                 p_exec_vice_president    NUMBER DEFAULT NULL,
                                 p_sap_code               VARCHAR2 DEFAULT NULL);

  PROCEDURE insert_fnd_companies(p_company_code       VARCHAR2,
                                 p_company_type       VARCHAR2,
                                 p_company_short_name VARCHAR2,
                                 p_company_full_name  VARCHAR2,
                                 -- p_company_icon       blob,
                                 p_set_of_books_id   NUMBER,
                                 p_company_level_id  NUMBER,
                                 p_chief_position_id NUMBER,
                                 p_parent_company_id NUMBER,
                                 p_address           VARCHAR2,
                                 p_start_date_active DATE,
                                 p_end_date_active   DATE,
                                 p_created_by        NUMBER,
                                 p_no_tax_sd_flag    VARCHAR2 DEFAULT 'N',
                                 p_taxpayer_flag     VARCHAR2 DEFAULT 'N');

  PROCEDURE update_fnd_companies(p_company_code       VARCHAR2,
                                 p_company_type       VARCHAR2,
                                 p_company_short_name VARCHAR2,
                                 p_company_full_name  VARCHAR2,
                                 -- p_company_icon       blob,
                                 p_set_of_books_id        NUMBER,
                                 p_company_level_id       NUMBER,
                                 p_chief_position_id      NUMBER,
                                 p_parent_company_id      NUMBER,
                                 p_address                VARCHAR2,
                                 p_start_date_active      DATE,
                                 p_end_date_active        DATE,
                                 p_created_by             NUMBER,
                                 p_language_code          VARCHAR2,
                                 p_company_low_level_id   NUMBER DEFAULT NULL,
                                 p_no_tax_sd_flag         VARCHAR2 DEFAULT 'N',
                                 p_taxpayer_flag          VARCHAR2 DEFAULT 'N',
                                 p_t3_value               VARCHAR2 DEFAULT NULL,
                                 p_db_code                VARCHAR2 DEFAULT NULL,
                                 p_fina_audit_position_id NUMBER DEFAULT NULL,
                                 p_fina_resp_position_id  NUMBER DEFAULT NULL,
                                 p_hr_head_position_id    NUMBER DEFAULT NULL,
                                 p_fina_head_position_id  NUMBER DEFAULT NULL,
                                 p_budget_position_id     number default null,
                                 p_parent_com_charge_man  NUMBER DEFAULT NULL,
                                 p_exec_vice_president    NUMBER DEFAULT NULL,
                                 p_sap_code               VARCHAR2 DEFAULT NULL);

  PROCEDURE update_fnd_companies(p_company_code       VARCHAR2,
                                 p_company_type       VARCHAR2,
                                 p_company_short_name VARCHAR2,
                                 p_company_full_name  VARCHAR2,
                                 --  p_company_icon       blob,
                                 p_set_of_books_id   NUMBER,
                                 p_company_level_id  NUMBER,
                                 p_chief_position_id NUMBER,
                                 p_parent_company_id NUMBER,
                                 p_address           VARCHAR2,
                                 p_start_date_active DATE,
                                 p_end_date_active   DATE,
                                 p_created_by        NUMBER,
                                 p_no_tax_sd_flag    VARCHAR2 DEFAULT 'N',
                                 p_taxpayer_flag     VARCHAR2 DEFAULT 'N');
  PROCEDURE delete_fnd_companies(p_company_code VARCHAR2);
END fnd_companies_pkg;
/
CREATE OR REPLACE PACKAGE BODY fnd_companies_pkg IS
  e_end_date_error EXCEPTION;

  PROCEDURE insert_fnd_companies(p_company_code       VARCHAR2,
                                 p_company_type       VARCHAR2,
                                 p_company_short_name VARCHAR2,
                                 p_company_full_name  VARCHAR2,
                                 --p_company_icon       blob,
                                 p_set_of_books_id        NUMBER,
                                 p_company_level_id       NUMBER,
                                 p_chief_position_id      NUMBER,
                                 p_parent_company_id      NUMBER,
                                 p_address                VARCHAR2,
                                 p_start_date_active      DATE,
                                 p_end_date_active        DATE,
                                 p_created_by             NUMBER,
                                 p_language_code          VARCHAR2,
                                 p_company_low_level_id   NUMBER DEFAULT NULL,
                                 p_no_tax_sd_flag         VARCHAR2 DEFAULT 'N',
                                 p_taxpayer_flag          VARCHAR2 DEFAULT 'N',
                                 p_t3_value               VARCHAR2 DEFAULT NULL,
                                 p_db_code                VARCHAR2 DEFAULT NULL,
                                 p_fina_audit_position_id NUMBER DEFAULT NULL,
                                 p_fina_resp_position_id  NUMBER DEFAULT NULL,
                                 p_hr_head_position_id    NUMBER DEFAULT NULL,
                                 p_fina_head_position_id  NUMBER DEFAULT NULL,
                                 p_budget_position_id     number default null,
                                 p_parent_com_charge_man  NUMBER DEFAULT NULL,
                                 p_exec_vice_president    NUMBER DEFAULT NULL,
                                 p_sap_code               VARCHAR2 DEFAULT NULL) IS
    v_company_short_name_id NUMBER;
    v_company_full_name_id  NUMBER;
    v_company_id            NUMBER;
  
    v_start_period_name gld_periods.period_name%TYPE;
    v_end_period_name   gld_periods.period_name%TYPE;
    v_start_period_num  gld_periods.internal_period_num%TYPE;
    v_end_period_num    gld_periods.internal_period_num%TYPE;
  BEGIN
    IF p_start_date_active > nvl(p_end_date_active, p_start_date_active) THEN
      RAISE e_end_date_error;
    END IF;
    v_company_short_name_id := fnd_description_pkg.get_fnd_description_id;
    v_company_full_name_id  := fnd_description_pkg.get_fnd_description_id;
    SELECT fnd_companies_s.nextval INTO v_company_id FROM dual;
    INSERT INTO fnd_companies
      (company_id,
       company_code,
       company_type,
       company_short_name_id,
       company_full_name_id,
       -- company_icon,
       set_of_books_id,
       company_level_id,
       chief_position_id,
       parent_company_id,
       address,
       start_date_active,
       end_date_active,
       last_update_date,
       last_updated_by,
       creation_date,
       created_by,
       company_low_level_id,
       no_tax_sd_flag,
       taxpayer_flag,
       t3_value,
       db_code,
       fina_audit_position_id,
       fina_resp_position_id,
       hr_head_position_id,
       fina_head_position_id,
       budget_position_id,
       parent_com_charge_man,
       exec_vice_president,
       sap_code)
    VALUES
      (v_company_id,
       upper(p_company_code),
       p_company_type,
       v_company_short_name_id,
       v_company_full_name_id,
       --p_company_icon,
       p_set_of_books_id,
       p_company_level_id,
       p_chief_position_id,
       p_parent_company_id,
       p_address,
       p_start_date_active,
       p_end_date_active,
       SYSDATE,
       p_created_by,
       SYSDATE,
       p_created_by,
       p_company_low_level_id,
       p_no_tax_sd_flag,
       p_taxpayer_flag,
       p_t3_value,
       p_db_code,
       p_fina_audit_position_id,
       p_fina_resp_position_id,
       p_hr_head_position_id,
       p_fina_head_position_id,
       p_budget_position_id,
       p_parent_com_charge_man,
       p_exec_vice_president,
       p_sap_code);
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_company_short_name_id,
                                               p_ref_table        => 'FND_COMPANIES',
                                               p_ref_field        => 'COMPANY_SHORT_NAME_ID',
                                               p_description_text => p_company_short_name,
                                               p_created_by       => p_created_by,
                                               p_last_updated_by  => p_created_by,
                                               p_language_code    => p_language_code);
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_company_full_name_id,
                                               p_ref_table        => 'FND_COMPANIES',
                                               p_ref_field        => 'COMPANY_FULL_NAME_ID',
                                               p_description_text => p_company_full_name,
                                               p_created_by       => p_created_by,
                                               p_last_updated_by  => p_created_by,
                                               p_language_code    => p_language_code);
  
    --新增公司的时候，从当前期间开始到帐套级打开的最大期间位置，插入到公司级会计期间控制表
    --如果当前期间没有打开，就不插入任何期间控制信息
    --新增公司的时候，从当前期间开始到帐套级打开的最大期间位置，插入到公司级会计期间控制表
    --如果当前期间没有打开，就不插入任何期间控制信息
    BEGIN
      v_start_period_name := gld_common_pkg.get_period_name(p_company_id => v_company_id,
                                                            p_date       => SYSDATE);
      IF v_start_period_name IS NOT NULL THEN
        v_start_period_num := gld_common_pkg.get_gld_internal_period_num(p_company_id  => v_company_id,
                                                                         p_period_name => v_start_period_name);
      
        SELECT v.period_name, v.internal_period_num
          INTO v_end_period_name, v_end_period_num
          FROM (SELECT *
                  FROM fnd_sob_period_status sps
                 WHERE sps.set_of_books_id = p_set_of_books_id
                 ORDER BY sps.internal_period_num DESC) v
         WHERE rownum = 1;
        IF v_end_period_num >= v_start_period_num THEN
          FOR periods IN (SELECT *
                            FROM fnd_sob_period_status sps
                           WHERE sps.set_of_books_id = p_set_of_books_id
                             AND sps.internal_period_num >=
                                 v_start_period_num
                             AND sps.internal_period_num <= v_end_period_num
                           ORDER BY sps.internal_period_num) LOOP
            INSERT INTO gld_period_status
              (period_set_code,
               company_id,
               period_name,
               internal_period_num,
               period_status_code,
               creation_date,
               created_by,
               last_update_date,
               last_updated_by)
            VALUES
              (periods.period_set_code,
               v_company_id,
               periods.period_name,
               periods.internal_period_num,
               periods.period_status_code,
               SYSDATE,
               p_created_by,
               SYSDATE,
               p_created_by);
          END LOOP;
        END IF;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  EXCEPTION
    WHEN e_end_date_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_COMPANIES_END_DATE_ERROR',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'FND_COMPANIES_PKG',
                                                      p_procedure_function_name => 'INSERT_FND_COMPANIES');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN dup_val_on_index THEN
      --若有insert 表，捕获 唯一索引错误
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'FND_COMPANIES_UNIQUE_ERROR', --
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'FND_COMPANIES_PKG',
                                                      p_procedure_function_name => 'INSERT_FND_COMPANIES');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'FND_COMPANIES_PKG',
                                                     p_procedure_function_name => 'INSERT_FND_COMPANIES');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END insert_fnd_companies;

  PROCEDURE insert_fnd_companies(p_company_code       VARCHAR2,
                                 p_company_type       VARCHAR2,
                                 p_company_short_name VARCHAR2,
                                 p_company_full_name  VARCHAR2,
                                 --    p_company_icon       blob,
                                 p_set_of_books_id   NUMBER,
                                 p_company_level_id  NUMBER,
                                 p_chief_position_id NUMBER,
                                 p_parent_company_id NUMBER,
                                 p_address           VARCHAR2,
                                 p_start_date_active DATE,
                                 p_end_date_active   DATE,
                                 p_created_by        NUMBER,
                                 p_no_tax_sd_flag    VARCHAR2 DEFAULT 'N',
                                 p_taxpayer_flag     VARCHAR2 DEFAULT 'N') IS
  BEGIN
    insert_fnd_companies(p_company_code       => p_company_code,
                         p_company_type       => p_company_type,
                         p_company_short_name => p_company_short_name,
                         p_company_full_name  => p_company_full_name,
                         --  p_company_icon       => p_company_icon,
                         p_set_of_books_id   => p_set_of_books_id,
                         p_company_level_id  => p_company_level_id,
                         p_chief_position_id => p_chief_position_id,
                         p_parent_company_id => p_parent_company_id,
                         p_address           => p_address,
                         p_start_date_active => p_start_date_active,
                         p_end_date_active   => p_end_date_active,
                         p_created_by        => p_created_by,
                         p_language_code     => userenv('LANG'),
                         p_no_tax_sd_flag    => p_no_tax_sd_flag,
                         p_taxpayer_flag     => p_taxpayer_flag);
  END insert_fnd_companies;

  PROCEDURE delete_fnd_companies(p_company_code VARCHAR2) IS
  BEGIN
    DELETE fnd_descriptions b
     WHERE b.ref_table = 'FND_COMPANIES'
       AND b.ref_field = 'COMPANY_SHORT_NAME_ID'
       AND EXISTS (SELECT 1
              FROM fnd_companies a
             WHERE a.company_short_name_id = b.description_id
               AND a.company_code = p_company_code);
    DELETE fnd_descriptions b
     WHERE b.ref_table = 'FND_COMPANIES'
       AND b.ref_field = 'COMPANY_FULL_NAME_ID'
       AND EXISTS (SELECT 1
              FROM fnd_companies a
             WHERE a.company_full_name_id = b.description_id
               AND a.company_code = p_company_code);
  
    DELETE fnd_companies WHERE company_code = p_company_code;
  
  END delete_fnd_companies;

  PROCEDURE update_fnd_companies(p_company_code       VARCHAR2,
                                 p_company_type       VARCHAR2,
                                 p_company_short_name VARCHAR2,
                                 p_company_full_name  VARCHAR2,
                                 --  p_company_icon       blob,
                                 p_set_of_books_id        NUMBER,
                                 p_company_level_id       NUMBER,
                                 p_chief_position_id      NUMBER,
                                 p_parent_company_id      NUMBER,
                                 p_address                VARCHAR2,
                                 p_start_date_active      DATE,
                                 p_end_date_active        DATE,
                                 p_created_by             NUMBER,
                                 p_language_code          VARCHAR2,
                                 p_company_low_level_id   NUMBER DEFAULT NULL,
                                 p_no_tax_sd_flag         VARCHAR2 DEFAULT 'N',
                                 p_taxpayer_flag          VARCHAR2 DEFAULT 'N',
                                 p_t3_value               VARCHAR2 DEFAULT NULL,
                                 p_db_code                VARCHAR2 DEFAULT NULL,
                                 p_fina_audit_position_id NUMBER DEFAULT NULL,
                                 p_fina_resp_position_id  NUMBER DEFAULT NULL,
                                 p_hr_head_position_id    NUMBER DEFAULT NULL,
                                 p_fina_head_position_id  NUMBER DEFAULT NULL,
                                 p_budget_position_id     number default null,
                                 p_parent_com_charge_man  NUMBER DEFAULT NULL,
                                 p_exec_vice_president    NUMBER DEFAULT NULL,
                                 p_sap_code               VARCHAR2 DEFAULT NULL) IS
    v_company_short_name_id NUMBER;
    v_company_full_name_id  NUMBER;
  BEGIN
  
    IF p_start_date_active > nvl(p_end_date_active, p_start_date_active) THEN
      RAISE e_end_date_error;
    END IF;
  
    BEGIN
      SELECT t.company_short_name_id, t.company_full_name_id
        INTO v_company_short_name_id, v_company_full_name_id
        FROM fnd_companies t
       WHERE t.company_code = p_company_code;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    IF v_company_short_name_id IS NULL THEN
      v_company_short_name_id := fnd_description_pkg.get_fnd_description_id;
    END IF;
    IF v_company_full_name_id IS NULL THEN
      v_company_full_name_id := fnd_description_pkg.get_fnd_description_id;
    END IF;
    UPDATE fnd_companies t
       SET t.company_type          = p_company_type,
           t.company_short_name_id = v_company_short_name_id,
           t.company_full_name_id  = v_company_full_name_id,
           -- t.company_icon          = p_company_icon,
           t.set_of_books_id        = p_set_of_books_id,
           t.company_level_id       = p_company_level_id,
           t.chief_position_id      = p_chief_position_id,
           t.parent_company_id      = p_parent_company_id,
           t.address                = p_address,
           t.start_date_active      = p_start_date_active,
           t.end_date_active        = p_end_date_active,
           t.last_update_date       = SYSDATE,
           t.last_updated_by        = p_created_by,
           t.company_low_level_id   = p_company_low_level_id, --add by Qu yuanyuan 公司级次
           t.no_tax_sd_flag         = nvl(p_no_tax_sd_flag, t.no_tax_sd_flag),
           t.taxpayer_flag          = nvl(p_taxpayer_flag, t.taxpayer_flag),
           t.t3_value               = p_t3_value,
           t.db_code                = p_db_code,
           t.fina_audit_position_id = p_fina_audit_position_id,
           t.fina_resp_position_id  = p_fina_resp_position_id,
           t.fina_head_position_id  = p_fina_head_position_id,
           t.hr_head_position_id    = p_hr_head_position_id,
           t.budget_position_id     = p_budget_position_id,
           t.parent_com_charge_man  = p_parent_com_charge_man,
           t.exec_vice_president    = p_exec_vice_president,
           t.sap_code               = p_sap_code
     WHERE t.company_code = p_company_code;
  
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_company_short_name_id,
                                               p_ref_table        => 'FND_COMPANIES',
                                               p_ref_field        => 'COMPANY_SHORT_NAME_ID',
                                               p_description_text => p_company_short_name,
                                               p_created_by       => p_created_by,
                                               p_last_updated_by  => p_created_by,
                                               p_language_code    => p_language_code);
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_company_full_name_id,
                                               p_ref_table        => 'FND_COMPANIES',
                                               p_ref_field        => 'COMPANY_FULL_NAME_ID',
                                               p_description_text => p_company_full_name,
                                               p_created_by       => p_created_by,
                                               p_last_updated_by  => p_created_by,
                                               p_language_code    => p_language_code);
  
  EXCEPTION
    WHEN e_end_date_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_COMPANIES_END_DATE_ERROR',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'FND_COMPANIES_PKG',
                                                      p_procedure_function_name => 'UPDATE_FND_COMPANIES');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'FND_COMPANIES_PKG',
                                                     p_procedure_function_name => 'UPDATE_FND_COMPANIES');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_fnd_companies;

  PROCEDURE update_fnd_companies(p_company_code       VARCHAR2,
                                 p_company_type       VARCHAR2,
                                 p_company_short_name VARCHAR2,
                                 p_company_full_name  VARCHAR2,
                                 --  p_company_icon       blob,
                                 p_set_of_books_id   NUMBER,
                                 p_company_level_id  NUMBER,
                                 p_chief_position_id NUMBER,
                                 p_parent_company_id NUMBER,
                                 p_address           VARCHAR2,
                                 p_start_date_active DATE,
                                 p_end_date_active   DATE,
                                 p_created_by        NUMBER,
                                 p_no_tax_sd_flag    VARCHAR2 DEFAULT 'N',
                                 p_taxpayer_flag     VARCHAR2 DEFAULT 'N') IS
  BEGIN
    update_fnd_companies(p_company_code       => p_company_code,
                         p_company_type       => p_company_type,
                         p_company_short_name => p_company_short_name,
                         p_company_full_name  => p_company_full_name,
                         -- p_company_icon       => p_company_icon,
                         p_set_of_books_id   => p_set_of_books_id,
                         p_company_level_id  => p_company_level_id,
                         p_chief_position_id => p_chief_position_id,
                         p_parent_company_id => p_parent_company_id,
                         p_address           => p_address,
                         p_start_date_active => p_start_date_active,
                         p_end_date_active   => p_end_date_active,
                         p_created_by        => p_created_by,
                         p_language_code     => userenv('LANG'),
                         p_no_tax_sd_flag    => p_no_tax_sd_flag,
                         p_taxpayer_flag     => p_taxpayer_flag);
  END update_fnd_companies;

END fnd_companies_pkg;
/
