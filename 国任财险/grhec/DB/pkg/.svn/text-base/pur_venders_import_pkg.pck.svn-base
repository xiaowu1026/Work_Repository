CREATE OR REPLACE PACKAGE pur_venders_import_pkg IS

  -- Author  : Qu yuanyuan
  -- Created : 2016/1/20 10:39:27
  -- Purpose : 供应商导入pkg

  g_enable_log VARCHAR2(100) := 'Y'; --是否启用日志
  FUNCTION get_batch_id RETURN NUMBER;

  --校验接口表数据,校验无误后更新接口表数据
  PROCEDURE check_pur_venders_import_inf(p_batch_id NUMBER,
                                         p_user_id  NUMBER);
  --提交按钮，插入正式表数据
  PROCEDURE load_pur_venders_import(p_batch_id NUMBER, p_user_id NUMBER);

  --插入接口表
  PROCEDURE insert_pur_venders_import_inf(p_batch_id         NUMBER,
                                          p_seq_num          NUMBER,
                                          p_vender_code      VARCHAR2,
                                          p_vender_type_code VARCHAR2,
                                          p_description      VARCHAR2,
                                          p_tax_number       VARCHAR2,
                                          p_address          VARCHAR2,
                                          --p_artificial_person    varchar2,
                                          --p_tax_id_number        varchar2,
                                          --p_payment_term_code    varchar2,
                                          --p_payment_method       varchar2,
                                          --p_currency_code        varchar2,
                                          --p_approved_vender_flag varchar2,
                                          p_enabled_flag        VARCHAR2,
                                          p_line_number         NUMBER,
                                          p_bank_code           VARCHAR2,
                                          p_account_number      VARCHAR2,
                                          p_account_name        VARCHAR2,
                                          p_notes               VARCHAR2,
                                          p_primary_flag        VARCHAR2,
                                          p_account_enable_flag VARCHAR2,
                                          p_sparticipantbankno  VARCHAR2,
                                          --p_account_flag        varchar2,
                                          p_user_id    NUMBER,
                                          p_company_id NUMBER);

  PROCEDURE insert_pur_venders_import(p_batch_id         NUMBER,
                                      p_seq_num          NUMBER,
                                      p_vender_code      VARCHAR2,
                                      p_vender_type_code VARCHAR2,
                                      p_description      VARCHAR2,
                                      p_address          VARCHAR2,
                                      --p_artificial_person    varchar2,
                                      --p_tax_id_number        varchar2,
                                      --p_payment_term_code    varchar2,
                                      --p_payment_method       varchar2,
                                      --p_currency_code        varchar2,
                                      --p_approved_vender_flag varchar2,
                                      p_enabled_flag        VARCHAR2,
                                      p_line_number         NUMBER,
                                      p_bank_code           VARCHAR2,
                                      p_account_number      VARCHAR2,
                                      p_account_name        VARCHAR2,
                                      p_notes               VARCHAR2,
                                      p_primary_flag        VARCHAR2,
                                      p_account_enable_flag VARCHAR2,
                                      p_sparticipantbankno  VARCHAR2,
                                      --p_account_flag        varchar2,
                                      p_user_id    NUMBER,
                                      p_company_id NUMBER);

  --校验导入供应商数据
  PROCEDURE check_pur_venders_import(p_batch_id NUMBER, p_user_id NUMBER);

  --供应商导入提交按钮，插入正式表数据
  PROCEDURE commit_pur_venders_import(p_batch_id NUMBER, p_user_id NUMBER);

END pur_venders_import_pkg;
/
CREATE OR REPLACE PACKAGE BODY pur_venders_import_pkg IS
  g_error_flag         VARCHAR2(1) DEFAULT 'N';
  g_batch_id           NUMBER; --全局变量导入批次
  g_batch_line_num     NUMBER; --序号
  g_user_id            NUMBER; --用户ID
  g_error_message_code VARCHAR2(200); --错误代码
  g_this_package_name  VARCHAR2(30) := 'pur_venders_import_pkg';

  v_vender_type_code_error    VARCHAR2(200) := '供应商类型代码不存在';
  v_bank_error                VARCHAR2(200) := '联行号不存在';
  v_payment_term_code_error   VARCHAR2(200) := '付款条款不存在';
  v_check_error               VARCHAR2(30) := '校验失败!';
  v_vender_error              VARCHAR2(50) := '该供应商已存在,请手工维护银行信息!';
  v_vender_name_account_error VARCHAR2(50) := '供应商名称和银行户名不一致';
  e_check_error EXCEPTION;
  PROCEDURE txn_log(p_log_text IN VARCHAR2) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
  
    IF g_enable_log = 'Y' THEN
      INSERT INTO pur_venders_import_err_logs
        (batch_id, batch_line_num, message, message_date)
      VALUES
        (g_batch_id, g_batch_line_num, p_log_text, SYSDATE);
      COMMIT;
    END IF;
  END txn_log;

  --v1.6  记录错误日志
  --==========================================================
  PROCEDURE txn_log2(p_log_code IN VARCHAR2, p_seq_num IN NUMBER) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    v_message VARCHAR2(300);
  BEGIN
  
    IF g_enable_log = 'Y' THEN
      BEGIN
        SELECT e.message
          INTO v_message
          FROM sys_messages e
         WHERE message_code = p_log_code
           AND e.language = 'ZHS';
      EXCEPTION
        WHEN no_data_found THEN
          v_message := p_log_code;
      END;
    
      INSERT INTO pur_venders_import_err_logs
        (batch_id, batch_line_num, message, message_date)
      VALUES
        (g_batch_id, p_seq_num, v_message, SYSDATE);
      COMMIT;
    END IF;
  END txn_log2;

  --==========================================================
  --procedure Name  : DELETE_ERROR_LOGS
  --Description     : 删除错误日志表
  --Note            :
  --Parameter       :

  --==========================================================
  PROCEDURE delete_error_logs IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    DELETE FROM pur_venders_import_err_logs a
     WHERE NOT EXISTS (SELECT 1
              FROM pur_venders_import_inf b
             WHERE a.batch_id = b.batch_id);
  
    DELETE FROM pur_venders_import_err_logs a
     WHERE NOT EXISTS
     (SELECT 1 FROM pur_venders_import c WHERE a.batch_id = c.batch_id);
  
    DELETE FROM pur_venders_import_err_logs a
     WHERE a.batch_id = g_batch_id;
  
    COMMIT;
  END delete_error_logs;

  --获得导入批次
  FUNCTION get_batch_id RETURN NUMBER IS
    v_batch_id NUMBER;
  BEGIN
    SELECT pur_venders_import_inf_s.nextval INTO v_batch_id FROM dual;
    RETURN v_batch_id;
  END get_batch_id;

  --获取供应商类型ID
  PROCEDURE get_vender_type_id(p_vender_type_code VARCHAR2,
                               p_seq_num          NUMBER,
                               p_vender_type_id   OUT NUMBER) IS
  BEGIN
    SELECT f.vender_type_id
      INTO p_vender_type_id
      FROM pur_vender_types_vl f
     WHERE f.vender_type_code = p_vender_type_code;
  
  EXCEPTION
    WHEN no_data_found THEN
      g_error_message_code := v_vender_type_code_error;
      g_error_flag         := 'Y';
      txn_log2(g_error_message_code, p_seq_num);
  END get_vender_type_id;
  --获取付款条款ID
  PROCEDURE get_payment_term_id(p_payment_term_code VARCHAR2,
                                p_seq_num           NUMBER,
                                p_payment_term_id   OUT NUMBER) IS
  BEGIN
    IF p_payment_term_code IS NOT NULL THEN
      SELECT f.payment_term_id
        INTO p_payment_term_id
        FROM csh_payment_terms_vl f
       WHERE f.payment_term_code = p_payment_term_code;
    END IF;
  
  EXCEPTION
    WHEN no_data_found THEN
      g_error_message_code := v_payment_term_code_error;
      g_error_flag         := 'Y';
      txn_log2(g_error_message_code, p_seq_num);
  END get_payment_term_id;

  --校验供应商名称和银行户名是否一致
  PROCEDURE check_vender_name_and_account(p_vender_name    VARCHAR2,
                                          p_vender_account VARCHAR2,
                                          p_seq_num        NUMBER) IS
  BEGIN
    if p_vender_name != p_vender_account then
      g_error_message_code := v_vender_name_account_error;
      g_error_flag         := 'Y';
      txn_log2(g_error_message_code, p_seq_num);
    end if;
  END;

  --获取银行大类和联行号对应的银行信息
  PROCEDURE get_bank(p_sparticipantbankno VARCHAR2,
                     p_bank_code          VARCHAR2,
                     p_seq_num            NUMBER,
                     p_bank_name          OUT VARCHAR2,
                     p_bank_location_code OUT VARCHAR2,
                     p_bank_location      OUT VARCHAR2,
                     p_province_code      OUT VARCHAR2,
                     p_province_name      OUT VARCHAR2,
                     p_city_code          OUT VARCHAR2,
                     p_city_name          OUT VARCHAR2) IS
  BEGIN
  
    /*SELECT v.bank_name
     INTO p_bank_name
     FROM csh_banks_vl v
    WHERE v.bank_code = p_bank_code;*/
  
    /*SELECT c.sparticipantfullname, c.province, c.city
     INTO p_bank_location, p_province_name, p_city_name
     FROM cux_banks c
    WHERE c.sparticipantbankno = p_sparticipantbankno
      AND c.ssortcode = p_bank_code;*/
  
    SELECT b.belong_bank_name,
           b.bank_name,
           b.prov_code,
           b.prov_name,
           b.city_code,
           b.city_name
      INTO p_bank_name,
           p_bank_location,
           p_province_code,
           p_province_name,
           p_city_code,
           p_city_name
      FROM bcdl_bank_num b
     WHERE b.bank_num = p_sparticipantbankno
       AND b.detail_bank_code = p_bank_code;
    p_bank_location_code := p_sparticipantbankno;
  
    /*--获取省市
    SELECT v.region_code
      INTO p_province_code
      FROM fnd_region_code_vl v
     WHERE v.description = p_province_name;
    
    SELECT v.region_code
      INTO p_city_code
      FROM fnd_region_code_vl v
     WHERE v.description = p_city_name;*/
  
  EXCEPTION
    WHEN no_data_found THEN
      g_error_message_code := v_bank_error;
      g_error_flag         := 'Y';
      txn_log2(g_error_message_code, p_seq_num);
  END get_bank;
  --插入接口表
  PROCEDURE insert_pur_venders_import_inf(p_batch_id         NUMBER,
                                          p_seq_num          NUMBER,
                                          p_vender_code      VARCHAR2,
                                          p_vender_type_code VARCHAR2,
                                          p_description      VARCHAR2,
                                          p_tax_number       VARCHAR2,
                                          p_address          VARCHAR2,
                                          --p_artificial_person    varchar2,
                                          --p_tax_id_number        varchar2,
                                          --p_payment_term_code    varchar2,
                                          --p_payment_method       varchar2,
                                          --p_currency_code        varchar2,
                                          --p_approved_vender_flag varchar2,
                                          p_enabled_flag        VARCHAR2,
                                          p_line_number         NUMBER,
                                          p_bank_code           VARCHAR2,
                                          p_account_number      VARCHAR2,
                                          p_account_name        VARCHAR2,
                                          p_notes               VARCHAR2,
                                          p_primary_flag        VARCHAR2,
                                          p_account_enable_flag VARCHAR2,
                                          p_sparticipantbankno  VARCHAR2,
                                          --p_account_flag        varchar2,
                                          p_user_id    NUMBER,
                                          p_company_id NUMBER) IS
  BEGIN
    g_batch_line_num := p_seq_num;
    g_user_id        := p_user_id;
    INSERT INTO pur_venders_import_inf
      (batch_id,
       seq_num,
       vender_code,
       vender_type_code,
       description,
       address,
       --artificial_person,
       --tax_id_number,
       --payment_term_code,
       --payment_method,
       --currency_code,
       approved_vender_flag,
       enabled_flag,
       line_number,
       bank_code,
       account_number,
       account_name,
       notes,
       primary_flag,
       account_enable_flag,
       sparticipantbankno,
       account_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       company_id,
       tax_number)
    VALUES
      (p_batch_id,
       p_seq_num,
       p_vender_code,
       p_vender_type_code,
       p_description,
       p_address,
       --p_artificial_person,
       --p_tax_id_number,
       --p_payment_term_code,
       --p_payment_method,
       --p_currency_code,
       'Y',
       p_enabled_flag,
       p_line_number,
       p_bank_code,
       p_account_number,
       p_account_name,
       p_notes,
       p_primary_flag,
       p_account_enable_flag,
       p_sparticipantbankno,
       '10',
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_company_id,
       p_tax_number);
  END;
  --更新供应商导入接口表数据
  PROCEDURE update_pur_venders_import_inf(p_rowid             ROWID,
                                          p_ref_interface_row pur_venders_import_inf%ROWTYPE) IS
  BEGIN
    UPDATE pur_venders_import_inf t
       SET t.vender_type_id     = p_ref_interface_row.vender_type_id,
           t.payment_term_id    = p_ref_interface_row.payment_term_id,
           t.bank_name          = p_ref_interface_row.bank_name,
           t.bank_location_code = p_ref_interface_row.bank_location_code,
           t.bank_location      = p_ref_interface_row.bank_location,
           t.province_code      = p_ref_interface_row.province_code,
           t.province_name      = p_ref_interface_row.province_name,
           t.city_code          = p_ref_interface_row.city_code,
           t.city_name          = p_ref_interface_row.city_name
     WHERE t.rowid = p_rowid;
  END update_pur_venders_import_inf;
  --删除供应商导入接口表数据
  PROCEDURE delete_pur_venders_import_inf(p_batch_id NUMBER) IS
  BEGIN
    DELETE FROM pur_venders_import_inf t WHERE t.batch_id = p_batch_id;
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => g_user_id,
                                                     p_package_name            => g_this_package_name,
                                                     p_procedure_function_name => 'delete_pur_venders_import_inf');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END delete_pur_venders_import_inf;
  --校验接口表数据,校验无误后更新接口表数据
  PROCEDURE check_pur_venders_import_inf(p_batch_id NUMBER,
                                         p_user_id  NUMBER) IS
    CURSOR c_pur_venders_imp_inf_rowids IS
      SELECT t.rowid
        FROM pur_venders_import_inf t
       WHERE t.batch_id = nvl(p_batch_id, t.batch_id);
    v_rep_interface_row pur_venders_import_inf%ROWTYPE; --接口表记录
    v_error_message     sys_raise_app_errors.message%TYPE; --错误代码信息描述
  
  BEGIN
    g_batch_id := p_batch_id;
    g_user_id  := p_user_id;
    --删除之前错误信息
    delete_error_logs;
  
    FOR c_pur_venders_imp_inf_rowid IN c_pur_venders_imp_inf_rowids LOOP
      SELECT a.*
        INTO v_rep_interface_row
        FROM pur_venders_import_inf a
       WHERE a.rowid = c_pur_venders_imp_inf_rowid.rowid;
    
      if v_rep_interface_row.description <> v_rep_interface_row.bank_name then
        g_error_message_code := '供应商名称与银行账户名称不一致！';
        g_error_flag         := 'Y';
        txn_log2(g_error_message_code, v_rep_interface_row.seq_num);
      end if;
    
      --供应商类型
      get_vender_type_id(p_vender_type_code => v_rep_interface_row.vender_type_code,
                         p_seq_num          => v_rep_interface_row.seq_num,
                         p_vender_type_id   => v_rep_interface_row.vender_type_id);
      --银行和联行号信息
      get_bank(p_sparticipantbankno => v_rep_interface_row.sparticipantbankno,
               p_bank_code          => v_rep_interface_row.bank_code,
               p_seq_num            => v_rep_interface_row.seq_num,
               p_bank_name          => v_rep_interface_row.bank_name,
               p_bank_location_code => v_rep_interface_row.bank_location_code,
               p_bank_location      => v_rep_interface_row.bank_location,
               p_province_code      => v_rep_interface_row.province_code,
               p_province_name      => v_rep_interface_row.province_name,
               p_city_code          => v_rep_interface_row.city_code,
               p_city_name          => v_rep_interface_row.city_name);
      --付款条款
      get_payment_term_id(p_payment_term_code => v_rep_interface_row.payment_term_code,
                          p_seq_num           => v_rep_interface_row.seq_num,
                          p_payment_term_id   => v_rep_interface_row.payment_term_id);
    
      --更新接口表数据
      update_pur_venders_import_inf(c_pur_venders_imp_inf_rowid.rowid,
                                    v_rep_interface_row);
    END LOOP;
    IF g_error_flag = 'Y' THEN
      g_error_message_code := v_check_error;
      RAISE e_check_error;
    END IF;
  
  EXCEPTION
  
    WHEN e_check_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => v_check_error,
                                                     p_created_by              => g_user_id,
                                                     p_package_name            => g_this_package_name,
                                                     p_procedure_function_name => 'check_pur_venders_import_inf');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => g_user_id,
                                                     p_package_name            => g_this_package_name,
                                                     p_procedure_function_name => 'check_pur_venders_import_inf');
    
      sys_raise_app_error_pkg.get_sys_raise_app_error(p_app_error_line_id => sys_raise_app_error_pkg.g_err_line_id,
                                                      p_message           => v_error_message);
      txn_log(v_error_message);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END check_pur_venders_import_inf;

  --保存至正式表
  PROCEDURE save_pur_venders_gr(p_batch_id NUMBER, p_user_id NUMBER) IS
    v_vender_id NUMBER;
    e_vender_error EXCEPTION;
    v_pur_wlzq_venders pur_wlzq_venders%rowtype;
    v_count            number;
  BEGIN
    FOR c_pur_venders_imp_inf_rowid IN (SELECT seq_num,
                                               company_id,
                                               vender_code,
                                               vender_type_id,
                                               description,
                                               description_id,
                                               address,
                                               artificial_person,
                                               tax_id_number,
                                               bank_branch_code,
                                               bank_account_code,
                                               payment_term_id,
                                               payment_method,
                                               currency_code,
                                               approved_vender_flag,
                                               enabled_flag,
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
                                               account_enable_flag,
                                               sparticipantbankno,
                                               account_flag,
                                               vender_type_code,
                                               payment_term_code,
                                               tax_number
                                          FROM pur_venders_import_inf t
                                         WHERE t.batch_id =
                                               nvl(p_batch_id, t.batch_id)) LOOP
      BEGIN
        g_batch_line_num := c_pur_venders_imp_inf_rowid.seq_num;
      
        select count(*)
          into v_count
          FROM pur_wlzq_venders p, fnd_descriptions f
         WHERE p.description_id = f.description_id
           AND f.description_text = c_pur_venders_imp_inf_rowid.description
           AND f.ref_table = 'PUR_WLZQ_VENDERS'
           AND f.language = 'ZHS'
           and p.vender_type_id =
               c_pur_venders_imp_inf_rowid.vender_type_id;
      
        if v_count = 0 then
          pur_wlzq_vender_pkg.insert_pur_wlzq_vender(p_vender_type_id       => c_pur_venders_imp_inf_rowid.vender_type_id,
                                                     p_description          => c_pur_venders_imp_inf_rowid.description,
                                                     p_address              => c_pur_venders_imp_inf_rowid.address,
                                                     p_artificial_person    => c_pur_venders_imp_inf_rowid.artificial_person,
                                                     p_tax_id_number        => c_pur_venders_imp_inf_rowid.tax_id_number,
                                                     p_bank_branch_code     => c_pur_venders_imp_inf_rowid.bank_branch_code,
                                                     p_bank_account_code    => c_pur_venders_imp_inf_rowid.bank_account_code,
                                                     p_payment_term_id      => c_pur_venders_imp_inf_rowid.payment_term_id,
                                                     p_payment_method       => c_pur_venders_imp_inf_rowid.payment_method,
                                                     p_currency_code        => c_pur_venders_imp_inf_rowid.currency_code,
                                                     p_tax_type_id          => null,
                                                     p_tax_number           => c_pur_venders_imp_inf_rowid.tax_number,
                                                     p_approved_vender_flag => c_pur_venders_imp_inf_rowid.approved_vender_flag,
                                                     p_enabled_flag         => c_pur_venders_imp_inf_rowid.enabled_flag,
                                                     p_user_id              => p_user_id,
                                                     p_company_id           => c_pur_venders_imp_inf_rowid.company_id,
                                                     p_vender_id            => v_vender_id);
        
          pur_wlzq_vender_pkg.insert_vender_bank_assigns(p_vender_id          => v_vender_id,
                                                         p_line_number        => c_pur_venders_imp_inf_rowid.line_number,
                                                         p_bank_code          => c_pur_venders_imp_inf_rowid.bank_code,
                                                         p_bank_name          => c_pur_venders_imp_inf_rowid.bank_name,
                                                         p_bank_location_code => c_pur_venders_imp_inf_rowid.bank_location_code,
                                                         p_bank_location      => c_pur_venders_imp_inf_rowid.bank_location,
                                                         p_province_code      => c_pur_venders_imp_inf_rowid.province_code,
                                                         p_province_name      => c_pur_venders_imp_inf_rowid.province_name,
                                                         p_city_code          => c_pur_venders_imp_inf_rowid.city_code,
                                                         p_city_name          => c_pur_venders_imp_inf_rowid.city_name,
                                                         p_account_number     => c_pur_venders_imp_inf_rowid.account_number,
                                                         p_account_name       => c_pur_venders_imp_inf_rowid.account_name,
                                                         p_notes              => c_pur_venders_imp_inf_rowid.notes,
                                                         p_primary_flag       => c_pur_venders_imp_inf_rowid.primary_flag,
                                                         p_enabled_flag       => c_pur_venders_imp_inf_rowid.enabled_flag,
                                                         p_user_id            => p_user_id,
                                                         p_sparticipantbankno => c_pur_venders_imp_inf_rowid.sparticipantbankno,
                                                         p_account_flag       => c_pur_venders_imp_inf_rowid.account_flag);
        else
          select p.*
            into v_pur_wlzq_venders
            FROM pur_wlzq_venders p, fnd_descriptions f
           WHERE p.description_id = f.description_id
             AND f.description_text =
                 c_pur_venders_imp_inf_rowid.description
             AND f.ref_table = 'PUR_WLZQ_VENDERS'
             AND f.language = 'ZHS'
             and p.vender_type_id =
                 c_pur_venders_imp_inf_rowid.vender_type_id;
        
          pur_wlzq_vender_pkg.update_pur_wlzq_vender(p_vender_id            => v_pur_wlzq_venders.vender_id,
                                                     p_vender_type_id       => v_pur_wlzq_venders.vender_type_id,
                                                     p_description          => c_pur_venders_imp_inf_rowid.description,
                                                     p_address              => c_pur_venders_imp_inf_rowid.address,
                                                     p_artificial_person    => c_pur_venders_imp_inf_rowid.artificial_person,
                                                     p_tax_id_number        => c_pur_venders_imp_inf_rowid.tax_id_number,
                                                     p_bank_branch_code     => c_pur_venders_imp_inf_rowid.bank_branch_code,
                                                     p_bank_account_code    => c_pur_venders_imp_inf_rowid.bank_account_code,
                                                     p_payment_term_id      => c_pur_venders_imp_inf_rowid.payment_term_id,
                                                     p_payment_method       => c_pur_venders_imp_inf_rowid.payment_method,
                                                     p_currency_code        => c_pur_venders_imp_inf_rowid.currency_code,
                                                     p_tax_type_id          => null,
                                                     p_tax_number           => c_pur_venders_imp_inf_rowid.tax_number,
                                                     p_approved_vender_flag => c_pur_venders_imp_inf_rowid.approved_vender_flag,
                                                     p_enabled_flag         => c_pur_venders_imp_inf_rowid.enabled_flag,
                                                     p_user_id              => p_user_id,
                                                     p_company_id           => c_pur_venders_imp_inf_rowid.company_id);
          SELECT count(*)
            into v_count
            FROM pur_wlzq_ve_accounts pva
           WHERE pva.vender_id = v_pur_wlzq_venders.vender_id
             and pva.account_number =
                 c_pur_venders_imp_inf_rowid.account_number
             and pva.account_name =
                 c_pur_venders_imp_inf_rowid.account_name;
        
          if v_count = 0 then
            pur_wlzq_vender_pkg.insert_vender_bank_assigns(p_vender_id          => v_pur_wlzq_venders.vender_id,
                                                           p_line_number        => c_pur_venders_imp_inf_rowid.line_number,
                                                           p_bank_code          => c_pur_venders_imp_inf_rowid.bank_code,
                                                           p_bank_name          => c_pur_venders_imp_inf_rowid.bank_name,
                                                           p_bank_location_code => c_pur_venders_imp_inf_rowid.bank_location_code,
                                                           p_bank_location      => c_pur_venders_imp_inf_rowid.bank_location,
                                                           p_province_code      => c_pur_venders_imp_inf_rowid.province_code,
                                                           p_province_name      => c_pur_venders_imp_inf_rowid.province_name,
                                                           p_city_code          => c_pur_venders_imp_inf_rowid.city_code,
                                                           p_city_name          => c_pur_venders_imp_inf_rowid.city_name,
                                                           p_account_number     => c_pur_venders_imp_inf_rowid.account_number,
                                                           p_account_name       => c_pur_venders_imp_inf_rowid.account_name,
                                                           p_notes              => c_pur_venders_imp_inf_rowid.notes,
                                                           p_primary_flag       => c_pur_venders_imp_inf_rowid.primary_flag,
                                                           p_enabled_flag       => c_pur_venders_imp_inf_rowid.enabled_flag,
                                                           p_user_id            => p_user_id,
                                                           p_sparticipantbankno => c_pur_venders_imp_inf_rowid.sparticipantbankno,
                                                           p_account_flag       => c_pur_venders_imp_inf_rowid.account_flag);
          else
            pur_wlzq_vender_pkg.update_vender_bank_assigns(p_vender_id          => v_pur_wlzq_venders.vender_id,
                                                           p_line_number        => c_pur_venders_imp_inf_rowid.line_number,
                                                           p_bank_code          => c_pur_venders_imp_inf_rowid.bank_code,
                                                           p_bank_name          => c_pur_venders_imp_inf_rowid.bank_name,
                                                           p_bank_location_code => c_pur_venders_imp_inf_rowid.bank_location_code,
                                                           p_bank_location      => c_pur_venders_imp_inf_rowid.bank_location,
                                                           p_province_code      => c_pur_venders_imp_inf_rowid.province_code,
                                                           p_province_name      => c_pur_venders_imp_inf_rowid.province_name,
                                                           p_city_code          => c_pur_venders_imp_inf_rowid.city_code,
                                                           p_city_name          => c_pur_venders_imp_inf_rowid.city_name,
                                                           p_account_number     => c_pur_venders_imp_inf_rowid.account_number,
                                                           p_account_name       => c_pur_venders_imp_inf_rowid.account_name,
                                                           p_notes              => c_pur_venders_imp_inf_rowid.notes,
                                                           p_primary_flag       => c_pur_venders_imp_inf_rowid.primary_flag,
                                                           p_enabled_flag       => c_pur_venders_imp_inf_rowid.enabled_flag,
                                                           p_user_id            => p_user_id,
                                                           p_sparticipantbankno => c_pur_venders_imp_inf_rowid.sparticipantbankno,
                                                           p_account_flag       => c_pur_venders_imp_inf_rowid.account_flag);
          end if;
        end if;
      end;
    END LOOP;
  END save_pur_venders_gr;

  --保存至正式表
  PROCEDURE save_pur_venders(p_batch_id NUMBER, p_user_id NUMBER) IS
    v_vender_id NUMBER;
    e_vender_error EXCEPTION;
  BEGIN
    FOR c_pur_venders_imp_inf_rowid IN (SELECT seq_num,
                                               company_id,
                                               vender_code,
                                               vender_type_id,
                                               description,
                                               description_id,
                                               address,
                                               artificial_person,
                                               tax_id_number,
                                               bank_branch_code,
                                               bank_account_code,
                                               payment_term_id,
                                               payment_method,
                                               currency_code,
                                               approved_vender_flag,
                                               enabled_flag,
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
                                               account_enable_flag,
                                               sparticipantbankno,
                                               account_flag,
                                               vender_type_code,
                                               payment_term_code
                                          FROM pur_venders_import_inf t
                                         WHERE t.batch_id =
                                               nvl(p_batch_id, t.batch_id)) LOOP
      BEGIN
        g_batch_line_num := c_pur_venders_imp_inf_rowid.seq_num;
        SELECT p.vender_id
          INTO v_vender_id
          FROM pur_system_venders_vl p
         WHERE p.vender_code = c_pur_venders_imp_inf_rowid.vender_code;
      
        --插入供应商银行账号
        pur_vender_items_pkg.insert_vender_bank_assigns(p_vender_id          => v_vender_id,
                                                        p_line_number        => c_pur_venders_imp_inf_rowid.line_number,
                                                        p_bank_code          => c_pur_venders_imp_inf_rowid.bank_code,
                                                        p_bank_name          => c_pur_venders_imp_inf_rowid.bank_name,
                                                        p_bank_location_code => c_pur_venders_imp_inf_rowid.bank_location_code,
                                                        p_bank_location      => c_pur_venders_imp_inf_rowid.bank_location,
                                                        p_province_code      => c_pur_venders_imp_inf_rowid.province_code,
                                                        p_province_name      => c_pur_venders_imp_inf_rowid.province_name,
                                                        p_city_code          => c_pur_venders_imp_inf_rowid.city_code,
                                                        p_city_name          => c_pur_venders_imp_inf_rowid.city_name,
                                                        p_account_number     => c_pur_venders_imp_inf_rowid.account_number,
                                                        p_account_name       => c_pur_venders_imp_inf_rowid.account_name,
                                                        p_notes              => c_pur_venders_imp_inf_rowid.notes,
                                                        p_primary_flag       => c_pur_venders_imp_inf_rowid.primary_flag,
                                                        p_enabled_flag       => c_pur_venders_imp_inf_rowid.account_enable_flag,
                                                        p_user_id            => g_user_id,
                                                        p_sparticipantbankno => c_pur_venders_imp_inf_rowid.sparticipantbankno,
                                                        p_account_flag       => c_pur_venders_imp_inf_rowid.account_flag);
      
        RAISE e_vender_error;
      
        --插入
      EXCEPTION
        WHEN no_data_found THEN
          --调用原有的供应商插入过程
          pur_system_venders_pkg.insert_pur_system_venders(p_vender_code          => c_pur_venders_imp_inf_rowid.vender_code,
                                                           p_description          => c_pur_venders_imp_inf_rowid.description,
                                                           p_address              => c_pur_venders_imp_inf_rowid.address,
                                                           p_artificial_person    => c_pur_venders_imp_inf_rowid.artificial_person,
                                                           p_tax_id_number        => c_pur_venders_imp_inf_rowid.tax_id_number,
                                                           p_bank_branch_code     => c_pur_venders_imp_inf_rowid.bank_branch_code,
                                                           p_bank_account_code    => c_pur_venders_imp_inf_rowid.bank_account_code,
                                                           p_enabled_flag         => c_pur_venders_imp_inf_rowid.enabled_flag,
                                                           p_created_by           => p_user_id,
                                                           p_company_id           => c_pur_venders_imp_inf_rowid.company_id,
                                                           p_vender_type_id       => c_pur_venders_imp_inf_rowid.vender_type_id,
                                                           p_payment_term_id      => c_pur_venders_imp_inf_rowid.payment_term_id,
                                                           p_payment_method       => c_pur_venders_imp_inf_rowid.payment_method,
                                                           p_vender_id            => v_vender_id,
                                                           p_currency_code        => c_pur_venders_imp_inf_rowid.currency_code,
                                                           p_tax_type_id          => NULL,
                                                           p_approved_vender_flag => c_pur_venders_imp_inf_rowid.approved_vender_flag);
          --插入供应商银行账号
          pur_vender_items_pkg.insert_vender_bank_assigns(p_vender_id          => v_vender_id,
                                                          p_line_number        => c_pur_venders_imp_inf_rowid.line_number,
                                                          p_bank_code          => c_pur_venders_imp_inf_rowid.bank_code,
                                                          p_bank_name          => c_pur_venders_imp_inf_rowid.bank_name,
                                                          p_bank_location_code => c_pur_venders_imp_inf_rowid.bank_location_code,
                                                          p_bank_location      => c_pur_venders_imp_inf_rowid.bank_location,
                                                          p_province_code      => c_pur_venders_imp_inf_rowid.province_code,
                                                          p_province_name      => c_pur_venders_imp_inf_rowid.province_name,
                                                          p_city_code          => c_pur_venders_imp_inf_rowid.city_code,
                                                          p_city_name          => c_pur_venders_imp_inf_rowid.city_name,
                                                          p_account_number     => c_pur_venders_imp_inf_rowid.account_number,
                                                          p_account_name       => c_pur_venders_imp_inf_rowid.account_name,
                                                          p_notes              => c_pur_venders_imp_inf_rowid.notes,
                                                          p_primary_flag       => c_pur_venders_imp_inf_rowid.primary_flag,
                                                          p_enabled_flag       => c_pur_venders_imp_inf_rowid.account_enable_flag,
                                                          p_user_id            => g_user_id,
                                                          p_sparticipantbankno => c_pur_venders_imp_inf_rowid.sparticipantbankno,
                                                          p_account_flag       => c_pur_venders_imp_inf_rowid.account_flag);
      END;
    
    END LOOP;
  EXCEPTION
    WHEN e_vender_error THEN
      g_error_message_code := v_vender_error;
      g_error_flag         := 'Y';
      txn_log2(g_error_message_code, g_batch_line_num);
  END save_pur_venders;
  --提交按钮，插入正式表数据
  PROCEDURE load_pur_venders_import(p_batch_id NUMBER, p_user_id NUMBER) IS
    v_rowislocked EXCEPTION;
    PRAGMA EXCEPTION_INIT(v_rowislocked, -54);
  
    v_error_message sys_raise_app_errors.message%TYPE; --错误代码描述
  
  BEGIN
  
    g_batch_id := p_batch_id; --全局变量批次获取值
    g_user_id  := p_user_id; --全局变量用户ID
  
    delete_error_logs;
  
    BEGIN
      check_pur_venders_import_inf(p_batch_id => p_batch_id,
                                   p_user_id  => p_user_id);
    EXCEPTION
      WHEN OTHERS THEN
        RAISE e_check_error;
    END;
  
    LOCK TABLE pur_venders_import_inf IN SHARE MODE NOWAIT;
  
    --save_pur_venders(p_batch_id => p_batch_id, p_user_id => p_user_id);
    save_pur_venders_gr(p_batch_id => p_batch_id, p_user_id => p_user_id);
    DELETE FROM pur_venders_import_inf t WHERE t.batch_id = p_batch_id;
  EXCEPTION
    WHEN e_check_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => v_check_error,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => g_this_package_name,
                                                     p_procedure_function_name => 'load_pur_venders_import');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => g_this_package_name,
                                                     p_procedure_function_name => 'load_pur_venders_import');
      sys_raise_app_error_pkg.get_sys_raise_app_error(p_app_error_line_id => sys_raise_app_error_pkg.g_err_line_id,
                                                      p_message           => v_error_message);
      txn_log(v_error_message);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END load_pur_venders_import;

  --插入供应商导入表
  PROCEDURE insert_pur_venders_import(p_batch_id         NUMBER,
                                      p_seq_num          NUMBER,
                                      p_vender_code      VARCHAR2,
                                      p_vender_type_code VARCHAR2,
                                      p_description      VARCHAR2,
                                      p_address          VARCHAR2,
                                      --p_artificial_person    varchar2,
                                      --p_tax_id_number        varchar2,
                                      --p_payment_term_code    varchar2,
                                      --p_payment_method       varchar2,
                                      --p_currency_code        varchar2,
                                      --p_approved_vender_flag varchar2,
                                      p_enabled_flag        VARCHAR2,
                                      p_line_number         NUMBER,
                                      p_bank_code           VARCHAR2,
                                      p_account_number      VARCHAR2,
                                      p_account_name        VARCHAR2,
                                      p_notes               VARCHAR2,
                                      p_primary_flag        VARCHAR2,
                                      p_account_enable_flag VARCHAR2,
                                      p_sparticipantbankno  VARCHAR2,
                                      --p_account_flag        varchar2,
                                      p_user_id    NUMBER,
                                      p_company_id NUMBER) IS
  BEGIN
    g_batch_line_num := p_seq_num;
    g_user_id        := p_user_id;
    INSERT INTO pur_venders_import
      (batch_id,
       seq_num,
       vender_code,
       vender_type_code,
       description,
       address,
       --artificial_person,
       --tax_id_number,
       --payment_term_code,
       --payment_method,
       --currency_code,
       approved_vender_flag,
       enabled_flag,
       line_number,
       bank_code,
       account_number,
       account_name,
       notes,
       primary_flag,
       account_enable_flag,
       sparticipantbankno,
       account_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       company_id)
    VALUES
      (p_batch_id,
       p_seq_num,
       p_vender_code,
       p_vender_type_code,
       p_description,
       p_address,
       --p_artificial_person,
       --p_tax_id_number,
       --p_payment_term_code,
       --p_payment_method,
       --p_currency_code,
       'Y',
       p_enabled_flag,
       p_line_number,
       p_bank_code,
       p_account_number,
       p_account_name,
       p_notes,
       p_primary_flag,
       p_account_enable_flag,
       p_sparticipantbankno,
       '10',
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_company_id);
  END;

  --更新供应商导入表数据
  PROCEDURE update_pur_venders_import(p_rowid             ROWID,
                                      p_ref_interface_row pur_venders_import%ROWTYPE) IS
  BEGIN
    UPDATE PUR_VENDERS_IMPORT t
       SET t.vender_type_id     = p_ref_interface_row.vender_type_id,
           t.payment_term_id    = p_ref_interface_row.payment_term_id,
           t.bank_name          = p_ref_interface_row.bank_name,
           t.bank_location_code = p_ref_interface_row.bank_location_code,
           t.bank_location      = p_ref_interface_row.bank_location,
           t.province_code      = p_ref_interface_row.province_code,
           t.province_name      = p_ref_interface_row.province_name,
           t.city_code          = p_ref_interface_row.city_code,
           t.city_name          = p_ref_interface_row.city_name
     WHERE t.rowid = p_rowid;
  END update_pur_venders_import;

  --校验导入供应商数据
  PROCEDURE check_pur_venders_import(p_batch_id NUMBER, p_user_id NUMBER) IS
    CURSOR c_pur_venders_imp_rowids IS
      SELECT t.rowid
        FROM PUR_VENDERS_IMPORT t
       WHERE t.batch_id = nvl(p_batch_id, t.batch_id);
    v_rep_interface_row pur_venders_import%ROWTYPE; --供应商导入表记录
    v_error_message     sys_raise_app_errors.message%TYPE; --错误代码信息描述
  
  BEGIN
    g_batch_id := p_batch_id;
    g_user_id  := p_user_id;
    --删除之前错误信息
    delete_error_logs;
  
    FOR c_pur_venders_imp_rowid IN c_pur_venders_imp_rowids LOOP
      SELECT a.*
        INTO v_rep_interface_row
        FROM PUR_VENDERS_IMPORT a
       WHERE a.rowid = c_pur_venders_imp_rowid.rowid;
    
      --供应商类型
      get_vender_type_id(p_vender_type_code => v_rep_interface_row.vender_type_code,
                         p_seq_num          => v_rep_interface_row.seq_num,
                         p_vender_type_id   => v_rep_interface_row.vender_type_id);
    
      --校验供应商名称和银行户名
      check_vender_name_and_account(p_vender_name    => v_rep_interface_row.description,
                                    p_vender_account => v_rep_interface_row.account_name,
                                    p_seq_num        => v_rep_interface_row.seq_num);
    
      --银行和联行号信息
      get_bank(p_sparticipantbankno => v_rep_interface_row.sparticipantbankno,
               p_bank_code          => v_rep_interface_row.bank_code,
               p_seq_num            => v_rep_interface_row.seq_num,
               p_bank_name          => v_rep_interface_row.bank_name,
               p_bank_location_code => v_rep_interface_row.bank_location_code,
               p_bank_location      => v_rep_interface_row.bank_location,
               p_province_code      => v_rep_interface_row.province_code,
               p_province_name      => v_rep_interface_row.province_name,
               p_city_code          => v_rep_interface_row.city_code,
               p_city_name          => v_rep_interface_row.city_name);
      --付款条款
      get_payment_term_id(p_payment_term_code => v_rep_interface_row.payment_term_code,
                          p_seq_num           => v_rep_interface_row.seq_num,
                          p_payment_term_id   => v_rep_interface_row.payment_term_id);
    
      --更新供应商导入表数据
      update_pur_venders_import(c_pur_venders_imp_rowid.rowid,
                                v_rep_interface_row);
    END LOOP;
    IF g_error_flag = 'Y' THEN
      g_error_message_code := v_check_error;
      RAISE e_check_error;
    END IF;
  
  EXCEPTION
  
    WHEN e_check_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => v_check_error,
                                                     p_created_by              => g_user_id,
                                                     p_package_name            => g_this_package_name,
                                                     p_procedure_function_name => 'check_pur_venders_import');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => g_user_id,
                                                     p_package_name            => g_this_package_name,
                                                     p_procedure_function_name => 'check_pur_venders_import');
    
      sys_raise_app_error_pkg.get_sys_raise_app_error(p_app_error_line_id => sys_raise_app_error_pkg.g_err_line_id,
                                                      p_message           => v_error_message);
      txn_log(v_error_message);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END check_pur_venders_import;

  --保存至正式表
  PROCEDURE commit_pur_venders(p_batch_id NUMBER, p_user_id NUMBER) IS
    v_vender_id NUMBER;
    e_vender_error EXCEPTION;
  BEGIN
    FOR c_pur_venders_imp_rowid IN (SELECT seq_num,
                                           company_id,
                                           vender_code,
                                           vender_type_id,
                                           description,
                                           description_id,
                                           address,
                                           artificial_person,
                                           tax_id_number,
                                           bank_branch_code,
                                           bank_account_code,
                                           payment_term_id,
                                           payment_method,
                                           currency_code,
                                           approved_vender_flag,
                                           enabled_flag,
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
                                           account_enable_flag,
                                           sparticipantbankno,
                                           account_flag,
                                           vender_type_code,
                                           payment_term_code
                                      FROM pur_venders_import t
                                     WHERE t.batch_id =
                                           nvl(p_batch_id, t.batch_id)) LOOP
      BEGIN
        g_batch_line_num := c_pur_venders_imp_rowid.seq_num;
        SELECT p.vender_id
          INTO v_vender_id
          FROM pur_system_venders_vl p
         WHERE p.vender_code = c_pur_venders_imp_rowid.vender_code;
      
        --插入供应商银行账号
        pur_vender_items_pkg.insert_vender_bank_assigns(p_vender_id          => v_vender_id,
                                                        p_line_number        => c_pur_venders_imp_rowid.line_number,
                                                        p_bank_code          => c_pur_venders_imp_rowid.bank_code,
                                                        p_bank_name          => c_pur_venders_imp_rowid.bank_name,
                                                        p_bank_location_code => c_pur_venders_imp_rowid.bank_location_code,
                                                        p_bank_location      => c_pur_venders_imp_rowid.bank_location,
                                                        p_province_code      => c_pur_venders_imp_rowid.province_code,
                                                        p_province_name      => c_pur_venders_imp_rowid.province_name,
                                                        p_city_code          => c_pur_venders_imp_rowid.city_code,
                                                        p_city_name          => c_pur_venders_imp_rowid.city_name,
                                                        p_account_number     => c_pur_venders_imp_rowid.account_number,
                                                        p_account_name       => c_pur_venders_imp_rowid.account_name,
                                                        p_notes              => c_pur_venders_imp_rowid.notes,
                                                        p_primary_flag       => c_pur_venders_imp_rowid.primary_flag,
                                                        p_enabled_flag       => c_pur_venders_imp_rowid.account_enable_flag,
                                                        p_user_id            => g_user_id,
                                                        p_sparticipantbankno => c_pur_venders_imp_rowid.sparticipantbankno,
                                                        p_account_flag       => c_pur_venders_imp_rowid.account_flag);
      
        RAISE e_vender_error;
      
        --插入
      EXCEPTION
        WHEN no_data_found THEN
          --调用原有的供应商插入过程
          pur_system_venders_pkg.insert_pur_system_venders(p_vender_code          => c_pur_venders_imp_rowid.vender_code,
                                                           p_description          => c_pur_venders_imp_rowid.description,
                                                           p_address              => c_pur_venders_imp_rowid.address,
                                                           p_artificial_person    => c_pur_venders_imp_rowid.artificial_person,
                                                           p_tax_id_number        => c_pur_venders_imp_rowid.tax_id_number,
                                                           p_bank_branch_code     => c_pur_venders_imp_rowid.bank_branch_code,
                                                           p_bank_account_code    => c_pur_venders_imp_rowid.bank_account_code,
                                                           p_enabled_flag         => c_pur_venders_imp_rowid.enabled_flag,
                                                           p_created_by           => p_user_id,
                                                           p_company_id           => c_pur_venders_imp_rowid.company_id,
                                                           p_vender_type_id       => c_pur_venders_imp_rowid.vender_type_id,
                                                           p_payment_term_id      => c_pur_venders_imp_rowid.payment_term_id,
                                                           p_payment_method       => c_pur_venders_imp_rowid.payment_method,
                                                           p_vender_id            => v_vender_id,
                                                           p_currency_code        => c_pur_venders_imp_rowid.currency_code,
                                                           p_tax_type_id          => NULL,
                                                           p_approved_vender_flag => c_pur_venders_imp_rowid.approved_vender_flag);
          --插入供应商银行账号
          pur_vender_items_pkg.insert_vender_bank_assigns(p_vender_id          => v_vender_id,
                                                          p_line_number        => c_pur_venders_imp_rowid.line_number,
                                                          p_bank_code          => c_pur_venders_imp_rowid.bank_code,
                                                          p_bank_name          => c_pur_venders_imp_rowid.bank_name,
                                                          p_bank_location_code => c_pur_venders_imp_rowid.bank_location_code,
                                                          p_bank_location      => c_pur_venders_imp_rowid.bank_location,
                                                          p_province_code      => c_pur_venders_imp_rowid.province_code,
                                                          p_province_name      => c_pur_venders_imp_rowid.province_name,
                                                          p_city_code          => c_pur_venders_imp_rowid.city_code,
                                                          p_city_name          => c_pur_venders_imp_rowid.city_name,
                                                          p_account_number     => c_pur_venders_imp_rowid.account_number,
                                                          p_account_name       => c_pur_venders_imp_rowid.account_name,
                                                          p_notes              => c_pur_venders_imp_rowid.notes,
                                                          p_primary_flag       => c_pur_venders_imp_rowid.primary_flag,
                                                          p_enabled_flag       => c_pur_venders_imp_rowid.account_enable_flag,
                                                          p_user_id            => g_user_id,
                                                          p_sparticipantbankno => c_pur_venders_imp_rowid.sparticipantbankno,
                                                          p_account_flag       => c_pur_venders_imp_rowid.account_flag);
      END;
    
    END LOOP;
  EXCEPTION
    WHEN e_vender_error THEN
      g_error_message_code := v_vender_error;
      g_error_flag         := 'Y';
      txn_log2(g_error_message_code, g_batch_line_num);
  END commit_pur_venders;

  --供应商导入提交按钮，插入正式表数据
  PROCEDURE commit_pur_venders_import(p_batch_id NUMBER, p_user_id NUMBER) IS
    v_rowislocked EXCEPTION;
    PRAGMA EXCEPTION_INIT(v_rowislocked, -54);
  
    v_error_message sys_raise_app_errors.message%TYPE; --错误代码描述
  
  BEGIN
  
    g_batch_id := p_batch_id; --全局变量批次获取值
    g_user_id  := p_user_id; --全局变量用户ID
  
    delete_error_logs;
  
    BEGIN
      check_pur_venders_import(p_batch_id => p_batch_id,
                               p_user_id  => p_user_id);
    EXCEPTION
      WHEN OTHERS THEN
        RAISE e_check_error;
    END;
  
    LOCK TABLE pur_venders_import IN SHARE MODE NOWAIT;
  
    commit_pur_venders(p_batch_id => p_batch_id, p_user_id => p_user_id);
  
    DELETE FROM pur_venders_import t WHERE t.batch_id = p_batch_id;
  EXCEPTION
    WHEN e_check_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => v_check_error,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => g_this_package_name,
                                                     p_procedure_function_name => 'commit_pur_venders_import');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => g_this_package_name,
                                                     p_procedure_function_name => 'commit_pur_venders_import');
      sys_raise_app_error_pkg.get_sys_raise_app_error(p_app_error_line_id => sys_raise_app_error_pkg.g_err_line_id,
                                                      p_message           => v_error_message);
      txn_log(v_error_message);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END commit_pur_venders_import;
END pur_venders_import_pkg;
/
