CREATE OR REPLACE PACKAGE "PUR_SYSTEM_VENDERS_PKG" IS

  -- Author  : BOBO
  -- Created : 2009-5-12 15:02:20
  -- Purpose : 供应商主文件定义

  --系统级 供应商 新建(失效)
  PROCEDURE insert_pur_system_venders(p_vender_code       VARCHAR2,
                                      p_description       VARCHAR2,
                                      p_address           VARCHAR2,
                                      p_artificial_person VARCHAR2,
                                      p_tax_id_number     VARCHAR2,
                                      p_bank_branch_code  VARCHAR2,
                                      p_bank_account_code VARCHAR2,
                                      p_enabled_flag      VARCHAR2,
                                      p_created_by        NUMBER,
                                      p_vender_type_id    NUMBER,
                                      p_payment_term_id   NUMBER,
                                      p_payment_method    VARCHAR2,
                                      p_vender_id         OUT NUMBER);

  --期初导入系统级供应商
  PROCEDURE load_pur_system_venders(p_vender_code          VARCHAR2,
                                    p_description          VARCHAR2,
                                    p_address              VARCHAR2,
                                    p_artificial_person    VARCHAR2,
                                    p_tax_id_number        VARCHAR2,
                                    p_bank_branch_code     VARCHAR2,
                                    p_bank_account_code    VARCHAR2,
                                    p_enabled_flag         VARCHAR2,
                                    p_created_by           NUMBER,
                                    p_company_id           NUMBER,
                                    p_vender_type_id       NUMBER,
                                    p_payment_term_id      NUMBER,
                                    p_payment_method       VARCHAR2,
                                    p_vender_id            OUT NUMBER,
                                    p_currency_code        VARCHAR2,
                                    p_tax_type_id          NUMBER,
                                    p_approved_vender_flag VARCHAR2);

  --系统级 供应商 新建(增加税种、币种、合格供应商字段)
  PROCEDURE insert_pur_system_venders(p_vender_code          VARCHAR2,
                                      p_description          VARCHAR2,
                                      p_address              VARCHAR2,
                                      p_artificial_person    VARCHAR2,
                                      p_tax_id_number        VARCHAR2,
                                      p_bank_branch_code     VARCHAR2,
                                      p_bank_account_code    VARCHAR2,
                                      p_enabled_flag         VARCHAR2,
                                      p_created_by           NUMBER,
                                      p_company_id           NUMBER,
                                      p_vender_type_id       NUMBER,
                                      p_payment_term_id      NUMBER,
                                      p_payment_method       VARCHAR2,
                                      p_vender_id            OUT NUMBER,
                                      p_currency_code        VARCHAR2,
                                      p_tax_type_id          NUMBER,
                                      p_approved_vender_flag VARCHAR2);

  --系统级 供应商 更新(失效)
  PROCEDURE update_pur_system_venders(p_vender_id         NUMBER,
                                      p_description       VARCHAR2,
                                      p_address           VARCHAR2,
                                      p_artificial_person VARCHAR2,
                                      p_tax_id_number     VARCHAR2,
                                      p_bank_branch_code  VARCHAR2,
                                      p_bank_account_code VARCHAR2,
                                      p_enabled_flag      VARCHAR2,
                                      p_payment_term_id   NUMBER,
                                      p_payment_method    VARCHAR2,
                                      p_last_updated_by   NUMBER);
  PROCEDURE update_company_venders_avf(p_vender_id            NUMBER,
                                       p_approved_vender_flag VARCHAR2,
                                       p_last_updated_by      NUMBER);
  --系统级 供应商 更新（增加税种、币种、合格供应商字段 ）
  PROCEDURE update_pur_system_venders(p_vender_id            NUMBER,
                                      p_description          VARCHAR2,
                                      p_address              VARCHAR2,
                                      p_artificial_person    VARCHAR2,
                                      p_tax_id_number        VARCHAR2,
                                      p_bank_branch_code     VARCHAR2,
                                      p_bank_account_code    VARCHAR2,
                                      p_payment_term_id      NUMBER,
                                      p_payment_method       VARCHAR2,
                                      p_currency_code        VARCHAR2,
                                      p_tax_type_id          NUMBER,
                                      p_approved_vender_flag VARCHAR2,
                                      p_enabled_flag         VARCHAR2,
                                      p_last_updated_by      NUMBER);

  PROCEDURE delete_pur_system_venders(p_vender_id  NUMBER,
                                      p_created_by NUMBER);

  --系统级供应商分配给公司
  PROCEDURE assign_pur_company_venders(p_company_id           NUMBER,
                                       p_vender_id            NUMBER,
                                       p_payment_term_id      NUMBER,
                                       p_payment_method       VARCHAR2,
                                       p_currency_code        VARCHAR2,
                                       p_tax_type_id          NUMBER,
                                       p_approved_vender_flag VARCHAR2,
                                       p_enabled_flag         VARCHAR2,
                                       p_created_by           NUMBER);

  --系统级供应商批量分配给公司 add by ronghui.xu
  PROCEDURE batch_ass_pur_company_venders(p_company_id           NUMBER,
                                          p_vender_id            NUMBER,
                                          p_payment_term_id      NUMBER,
                                          p_payment_method       VARCHAR2,
                                          p_currency_code        VARCHAR2,
                                          p_tax_type_id          NUMBER,
                                          p_approved_vender_flag VARCHAR2,
                                          p_enabled_flag         VARCHAR2,
                                          p_created_by           NUMBER);

  --批量分配公司
  PROCEDURE sel_assign_pur_company_venders(p_company_code_from VARCHAR2,
                                           p_company_code_to   VARCHAR2,
                                           p_vender_id         NUMBER,
                                           p_created_by        NUMBER);

  --分配给所有公司
  PROCEDURE all_assign_pur_company_venders(p_vender_id  NUMBER,
                                           p_created_by NUMBER);

  --系统级，批量更新公司启用、失效
  PROCEDURE update_pur_company_venders(p_company_id      NUMBER,
                                       p_vender_id       NUMBER,
                                       p_enabled_flag    VARCHAR2,
                                       p_last_updated_by NUMBER);

  --公司级客户 更新(失效)
  PROCEDURE update_pur_company_venders(p_company_id      NUMBER,
                                       p_vender_id       NUMBER,
                                       p_account_id      NUMBER,
                                       p_enabled_flag    VARCHAR2,
                                       p_last_updated_by NUMBER);

  --公司级客户 更新（增加税种、币种、合格供应商字段）
  PROCEDURE update_pur_company_venders(p_company_id           NUMBER,
                                       p_vender_id            NUMBER,
                                       p_payment_term_id      NUMBER,
                                       p_payment_method       VARCHAR2,
                                       p_currency_code        VARCHAR2,
                                       p_tax_type_id          NUMBER,
                                       p_approved_vender_flag VARCHAR2,
                                       p_enabled_flag         VARCHAR2,
                                       p_last_updated_by      NUMBER);

  PROCEDURE import_pur_company_venders(p_company_code_from VARCHAR2,
                                       p_company_code_to   VARCHAR2,
                                       p_vender_id         NUMBER,
                                       p_company_code_like VARCHAR2,
                                       p_created_by        NUMBER);

  --从界面选择公司批量分配
  PROCEDURE del_fnd_sys_vend_asgn_company(p_session_id       NUMBER,
                                          p_application_code VARCHAR2);

  PROCEDURE ins_fnd_sys_vend_asgn_company(p_session_id       NUMBER,
                                          p_application_code VARCHAR2,
                                          p_vender_id        NUMBER,
                                          p_user_id          NUMBER);

  PROCEDURE batch_import_com_fnd_sys_vend(p_company_id       NUMBER,
                                          p_set_of_books_id  NUMBER,
                                          p_session_id       NUMBER,
                                          p_application_code VARCHAR2,
                                          p_user_id          NUMBER);

  --********************HCT*****************************************

  PROCEDURE hct_ins_pur_system_venders(p_vender_code         VARCHAR2,
                                       p_description         VARCHAR2,
                                       p_address             VARCHAR2,
                                       p_artificial_person   VARCHAR2,
                                       p_tax_id_number       VARCHAR2,
                                       p_bank_branch_code    VARCHAR2,
                                       p_bank_account_code   VARCHAR2,
                                       p_enabled_flag        VARCHAR2,
                                       p_user_id             NUMBER,
                                       p_vender_type_id      NUMBER,
                                       p_payment_term_id     NUMBER,
                                       p_payment_method      VARCHAR2,
                                       p_maintain_company_id NUMBER,
                                       p_vender_id           OUT NUMBER);

  PROCEDURE hct_upd_pur_system_venders(p_vender_id          NUMBER,
                                       p_description        VARCHAR2,
                                       p_address            VARCHAR2,
                                       p_artificial_person  VARCHAR2,
                                       p_tax_id_number      VARCHAR2,
                                       p_bank_branch_code   VARCHAR2,
                                       p_bank_account_code  VARCHAR2,
                                       p_enabled_flag       VARCHAR2,
                                       p_payment_term_id    NUMBER,
                                       p_payment_method     VARCHAR2,
                                       p_user_id            NUMBER,
                                       p_current_company_id NUMBER);

  PROCEDURE hct_insert_pur_company_venders(p_company_id   NUMBER,
                                           p_vender_id    NUMBER,
                                           p_enabled_flag VARCHAR2,
                                           p_user_id      NUMBER,
                                           p_rowid        OUT VARCHAR2);

  PROCEDURE hct_update_pur_company_venders(p_rowid        VARCHAR2,
                                           p_company_id   NUMBER,
                                           p_vender_id    NUMBER,
                                           p_enabled_flag VARCHAR2,
                                           p_user_id      NUMBER);

  --批量分配
  PROCEDURE hct_batch_assign_com_venders(p_company_code_from   VARCHAR2,
                                         p_company_code_to     VARCHAR2,
                                         p_vender_id           NUMBER,
                                         p_company_code_like   VARCHAR2,
                                         p_user_id             NUMBER,
                                         p_maintain_company_id NUMBER);
  --导入系统级供应商分配给公司
  PROCEDURE load_assign_pur_com_venders(p_company_code VARCHAR2,
                                        p_vender_code  VARCHAR2);

END pur_system_venders_pkg;
/
CREATE OR REPLACE PACKAGE BODY "PUR_SYSTEM_VENDERS_PKG" IS

  e_vender_disabled_error EXCEPTION;

  e_comp_vender_enabled_error EXCEPTION;

  FUNCTION get_vender_id RETURN NUMBER IS
    v_vender_id pur_system_venders.vender_id%TYPE;
  BEGIN
    SELECT pur_system_venders_s.nextval INTO v_vender_id FROM dual;
    RETURN v_vender_id;
  END get_vender_id;

  PROCEDURE hec_pur_system_vender_unique(p_vender_code VARCHAR2,
                                         p_user_id     NUMBER) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM pur_system_venders i
     WHERE i.vender_code = p_vender_code;
  
    IF v_count > 1 THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PUR_VENDER_CODE_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'pur_system_venders_pkg',
                                                      p_procedure_function_name => 'hec_pur_system_vender_unique');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    END IF;
  END hec_pur_system_vender_unique;

  --系统级 供应商 新建
  PROCEDURE insert_pur_system_venders(p_vender_code       VARCHAR2,
                                      p_description       VARCHAR2,
                                      p_address           VARCHAR2,
                                      p_artificial_person VARCHAR2,
                                      p_tax_id_number     VARCHAR2,
                                      p_bank_branch_code  VARCHAR2,
                                      p_bank_account_code VARCHAR2,
                                      p_enabled_flag      VARCHAR2,
                                      p_created_by        NUMBER,
                                      p_vender_type_id    NUMBER,
                                      p_payment_term_id   NUMBER,
                                      p_payment_method    VARCHAR2,
                                      p_vender_id         OUT NUMBER) IS
    v_description_id pur_system_venders.description_id%TYPE;
    v_vender_id      pur_system_venders.vender_id%TYPE;
    v_count          number;
    e_description exception;
  BEGIN
    select count(1)
      into v_count
      from fnd_descriptions f
     where f.ref_table = 'PUR_SYSTEM_VENDERS'
       and f.description_text = p_description
       and f.language = 'ZHS';
    if v_count > 0 then
      raise e_description;
    end if;
    v_description_id := fnd_description_pkg.get_fnd_description_id;
    v_vender_id      := get_vender_id;
    INSERT INTO pur_system_venders
      (vender_id,
       vender_code,
       description_id,
       address,
       artificial_person,
       tax_id_number,
       bank_branch_code,
       bank_account_code,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       vender_type_id,
       payment_term_id,
       payment_method)
    VALUES
      (v_vender_id,
       p_vender_code,
       v_description_id,
       p_address,
       p_artificial_person,
       p_tax_id_number,
       p_bank_branch_code,
       p_bank_account_code,
       p_enabled_flag,
       p_created_by,
       SYSDATE,
       p_created_by,
       SYSDATE,
       p_vender_type_id,
       p_payment_term_id,
       p_payment_method);
  
    hec_pur_system_vender_unique(p_vender_code => p_vender_code,
                                 p_user_id     => p_created_by);
  
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'PUR_SYSTEM_VENDERS',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => '',
                                               p_created_by       => p_created_by,
                                               p_last_updated_by  => p_created_by,
                                               p_language_code    => userenv('lang'));
  
    p_vender_id := v_vender_id;
  EXCEPTION
    /* when dup_val_on_index then
    --捕获 唯一索引错误
    sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PUR_VENDER_CODE_DUPLICATE',
                                                    p_created_by              => p_created_by,
                                                    p_package_name            => 'pur_system_venders_pkg',
                                                    p_procedure_function_name => 'insert_pur_system_venders');
    raise_application_error(sys_raise_app_error_pkg.c_error_number,
                            sys_raise_app_error_pkg.g_err_line_id);*/
    WHEN e_description THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => p_description ||
                                                                                  '供应商名称不允许重复！请修改后再保存！',
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'pur_system_venders_pkg',
                                                     p_procedure_function_name => 'insert_pur_system_venders');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'pur_system_venders_pkg',
                                                     p_procedure_function_name => 'insert_pur_system_venders');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_pur_system_venders;

  --期初导入系统级供应商
  PROCEDURE load_pur_system_venders(p_vender_code          VARCHAR2,
                                    p_description          VARCHAR2,
                                    p_address              VARCHAR2,
                                    p_artificial_person    VARCHAR2,
                                    p_tax_id_number        VARCHAR2,
                                    p_bank_branch_code     VARCHAR2,
                                    p_bank_account_code    VARCHAR2,
                                    p_enabled_flag         VARCHAR2,
                                    p_created_by           NUMBER,
                                    p_company_id           NUMBER,
                                    p_vender_type_id       NUMBER,
                                    p_payment_term_id      NUMBER,
                                    p_payment_method       VARCHAR2,
                                    p_vender_id            OUT NUMBER,
                                    p_currency_code        VARCHAR2,
                                    p_tax_type_id          NUMBER,
                                    p_approved_vender_flag VARCHAR2) IS
    v_description_id pur_system_venders.description_id%TYPE;
    v_vender_id      pur_system_venders.vender_id%TYPE;
    v_count          number;
    e_description exception;
    v_error_message    varchar2(1000);
    v_vender_type_code varchar2(30);
    v_vender_code      varchar2(30);
  BEGIN
    /*select count(1)
      into v_count
      from fnd_descriptions f
     where f.ref_table = 'PUR_SYSTEM_VENDERS'
       and f.description_text = p_description
       and f.language = 'ZHS';
    if v_count > 0 then
      v_error_message := '供应商名称不允许重复！请修改后再保存！';
      raise e_description;
    end if;*/
  
    select pt.vender_type_code
      into v_vender_type_code
      from PUR_VENDER_TYPES pt
     where pt.vender_type_id = p_vender_type_id;
  
    /*begin
      select p.vender_code
        into v_vender_code
        from pur_system_venders p
       where p.vender_id =
             (select max(v.vender_id)
                from pur_system_venders v
               where v.vender_type_id = p_vender_type_id)
         and p.vender_type_id = p_vender_type_id;
    exception
      when no_data_found then
        v_vender_code := '0';
    end;
    
    if v_vender_type_code = 'ZV04' then
      if v_vender_code <> '0' then
        v_vender_code := to_char(to_number(v_vender_code) + 1);
      else
        v_vender_code := to_char(1300000001 + to_number(v_vender_code));
      end if;
    elsif v_vender_type_code = 'ZV10' then
      if v_vender_code <> '0' then
        v_vender_code := to_char(to_number(v_vender_code) + 1);
      else
        v_vender_code := to_char(1000000001 + to_number(v_vender_code));
      end if;
    elsif v_vender_type_code = 'ZV11' then
      if v_vender_code <> '0' then
        v_vender_code := to_char(to_number(v_vender_code) + 1);
      else
        v_vender_code := to_char(1600000001 + to_number(v_vender_code));
      end if;
    end if;*/
  
    v_vender_code    := p_vender_code;
    v_description_id := fnd_description_pkg.get_fnd_description_id;
    v_vender_id      := get_vender_id;
    INSERT INTO pur_system_venders v
      (vender_id,
       vender_code,
       description_id,
       address,
       artificial_person,
       tax_id_number,
       bank_branch_code,
       bank_account_code,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       vender_type_id,
       payment_term_id,
       payment_method,
       currency_code,
       tax_type_id,
       approved_vender_flag,
       transstatus)
    VALUES
      (v_vender_id,
       /*p_vender_code*/
       v_vender_code,
       v_description_id,
       p_address,
       p_artificial_person,
       p_tax_id_number,
       p_bank_branch_code,
       p_bank_account_code,
       p_enabled_flag,
       p_created_by,
       SYSDATE,
       p_created_by,
       SYSDATE,
       p_vender_type_id,
       p_payment_term_id,
       p_payment_method,
       p_currency_code,
       p_tax_type_id,
       p_approved_vender_flag,
       '0');
  
    hec_pur_system_vender_unique(p_vender_code => v_vender_code,
                                 p_user_id     => p_created_by);
  
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'PUR_SYSTEM_VENDERS',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => '',
                                               p_created_by       => p_created_by,
                                               p_last_updated_by  => p_created_by,
                                               p_language_code    => userenv('lang'));
  
    p_vender_id := v_vender_id;
  
    IF (p_company_id IS NOT NULL) THEN
      assign_pur_company_venders(p_company_id           => p_company_id,
                                 p_vender_id            => p_vender_id,
                                 p_payment_term_id      => p_payment_term_id,
                                 p_payment_method       => p_payment_method,
                                 p_currency_code        => p_currency_code,
                                 p_tax_type_id          => p_tax_type_id,
                                 p_approved_vender_flag => p_approved_vender_flag,
                                 p_enabled_flag         => p_enabled_flag,
                                 p_created_by           => p_created_by);
    END IF;
  
  EXCEPTION
    /* when dup_val_on_index then
    --捕获 唯一索引错误
    sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PUR_VENDER_CODE_DUPLICATE',
                                                    p_created_by              => p_created_by,
                                                    p_package_name            => 'pur_system_venders_pkg',
                                                    p_procedure_function_name => 'insert_pur_system_venders');
    raise_application_error(sys_raise_app_error_pkg.c_error_number,
                            sys_raise_app_error_pkg.g_err_line_id);*/
    WHEN e_description THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => v_error_message,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'pur_system_venders_pkg',
                                                     p_procedure_function_name => 'insert_pur_system_venders');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'pur_system_venders_pkg',
                                                     p_procedure_function_name => 'insert_pur_system_venders');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END load_pur_system_venders;

  --系统级 供应商 新建(增加税种、币种、合格供应商字段)
  PROCEDURE insert_pur_system_venders(p_vender_code          VARCHAR2,
                                      p_description          VARCHAR2,
                                      p_address              VARCHAR2,
                                      p_artificial_person    VARCHAR2,
                                      p_tax_id_number        VARCHAR2,
                                      p_bank_branch_code     VARCHAR2,
                                      p_bank_account_code    VARCHAR2,
                                      p_enabled_flag         VARCHAR2,
                                      p_created_by           NUMBER,
                                      p_company_id           NUMBER,
                                      p_vender_type_id       NUMBER,
                                      p_payment_term_id      NUMBER,
                                      p_payment_method       VARCHAR2,
                                      p_vender_id            OUT NUMBER,
                                      p_currency_code        VARCHAR2,
                                      p_tax_type_id          NUMBER,
                                      p_approved_vender_flag VARCHAR2) IS
    v_description_id pur_system_venders.description_id%TYPE;
    v_vender_id      pur_system_venders.vender_id%TYPE;
    v_count          number;
    e_description exception;
    v_error_message    varchar2(1000);
    v_vender_type_code varchar2(30);
    v_vender_code      varchar2(30);
  BEGIN
    select count(1)
      into v_count
      from fnd_descriptions f
     where f.ref_table = 'PUR_SYSTEM_VENDERS'
       and f.description_text = p_description
       and f.language = 'ZHS';
    if v_count > 0 then
      v_error_message := '供应商名称不允许重复！请修改后再保存！';
      raise e_description;
    end if;
  
    select pt.vender_type_code
      into v_vender_type_code
      from PUR_VENDER_TYPES pt
     where pt.vender_type_id = p_vender_type_id;
  
    begin
      select p.vender_code
        into v_vender_code
        from pur_system_venders p
       where p.vender_id =
             (select max(v.vender_id)
                from pur_system_venders v
               where v.vender_type_id = p_vender_type_id)
         and p.vender_type_id = p_vender_type_id;
    exception
      when no_data_found then
        v_vender_code := '0';
    end;
  
    if v_vender_type_code = 'ZV04' then
      if v_vender_code <> '0' then
        v_vender_code := to_char(to_number(v_vender_code) + 1);
      else
        v_vender_code := to_char(1300000001 + to_number(v_vender_code));
      end if;
    elsif v_vender_type_code = 'ZV10' then
      if v_vender_code <> '0' then
        v_vender_code := to_char(to_number(v_vender_code) + 1);
      else
        v_vender_code := to_char(1000000001 + to_number(v_vender_code));
      end if;
    elsif v_vender_type_code = 'ZV11' then
      if v_vender_code <> '0' then
        v_vender_code := to_char(to_number(v_vender_code) + 1);
      else
        v_vender_code := to_char(1600000001 + to_number(v_vender_code));
      end if;
    end if;
  
    v_description_id := fnd_description_pkg.get_fnd_description_id;
    v_vender_id      := get_vender_id;
    INSERT INTO pur_system_venders v
      (vender_id,
       vender_code,
       description_id,
       address,
       artificial_person,
       tax_id_number,
       bank_branch_code,
       bank_account_code,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       vender_type_id,
       payment_term_id,
       payment_method,
       currency_code,
       tax_type_id,
       approved_vender_flag,
       transstatus)
    VALUES
      (v_vender_id,
       /*p_vender_code*/
       v_vender_code,
       v_description_id,
       p_address,
       p_artificial_person,
       p_tax_id_number,
       p_bank_branch_code,
       p_bank_account_code,
       p_enabled_flag,
       p_created_by,
       SYSDATE,
       p_created_by,
       SYSDATE,
       p_vender_type_id,
       p_payment_term_id,
       p_payment_method,
       p_currency_code,
       p_tax_type_id,
       p_approved_vender_flag,
       '0');
  
    hec_pur_system_vender_unique(p_vender_code => v_vender_code,
                                 p_user_id     => p_created_by);
  
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'PUR_SYSTEM_VENDERS',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => '',
                                               p_created_by       => p_created_by,
                                               p_last_updated_by  => p_created_by,
                                               p_language_code    => userenv('lang'));
  
    p_vender_id := v_vender_id;
  
    IF (p_company_id IS NOT NULL) THEN
      assign_pur_company_venders(p_company_id           => p_company_id,
                                 p_vender_id            => p_vender_id,
                                 p_payment_term_id      => p_payment_term_id,
                                 p_payment_method       => p_payment_method,
                                 p_currency_code        => p_currency_code,
                                 p_tax_type_id          => p_tax_type_id,
                                 p_approved_vender_flag => p_approved_vender_flag,
                                 p_enabled_flag         => p_enabled_flag,
                                 p_created_by           => p_created_by);
    END IF;
  
  EXCEPTION
    /* when dup_val_on_index then
    --捕获 唯一索引错误
    sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PUR_VENDER_CODE_DUPLICATE',
                                                    p_created_by              => p_created_by,
                                                    p_package_name            => 'pur_system_venders_pkg',
                                                    p_procedure_function_name => 'insert_pur_system_venders');
    raise_application_error(sys_raise_app_error_pkg.c_error_number,
                            sys_raise_app_error_pkg.g_err_line_id);*/
    WHEN e_description THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => v_error_message,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'pur_system_venders_pkg',
                                                     p_procedure_function_name => 'insert_pur_system_venders');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'pur_system_venders_pkg',
                                                     p_procedure_function_name => 'insert_pur_system_venders');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_pur_system_venders;
  --系统级 供应商 更新
  PROCEDURE update_pur_system_venders(p_vender_id         NUMBER,
                                      p_description       VARCHAR2,
                                      p_address           VARCHAR2,
                                      p_artificial_person VARCHAR2,
                                      p_tax_id_number     VARCHAR2,
                                      p_bank_branch_code  VARCHAR2,
                                      p_bank_account_code VARCHAR2,
                                      p_enabled_flag      VARCHAR2,
                                      p_payment_term_id   NUMBER,
                                      p_payment_method    VARCHAR2,
                                      p_last_updated_by   NUMBER) IS
    v_description_id pur_system_venders.description_id%TYPE;
    v_disabled_flag  VARCHAR2(1) := 'N';
  BEGIN
  
    IF (nvl(p_enabled_flag, 'N') = 'N') THEN
      BEGIN
        SELECT 'N'
          INTO v_disabled_flag
          FROM dual
         WHERE EXISTS (SELECT 1
                  FROM pur_company_venders t
                 WHERE t.vender_id = p_vender_id
                   AND t.enabled_flag = 'Y');
      EXCEPTION
        WHEN no_data_found THEN
          v_disabled_flag := 'Y';
      END;
      IF (v_disabled_flag = 'N') THEN
        RAISE e_vender_disabled_error;
      END IF;
    END IF;
  
    SELECT description_id
      INTO v_description_id
      FROM pur_system_venders p
     WHERE p.vender_id = p_vender_id;
  
    UPDATE pur_system_venders p
       SET p.last_updated_by   = p_last_updated_by,
           p.last_update_date  = SYSDATE,
           p.artificial_person = p_artificial_person,
           p.tax_id_number     = p_tax_id_number,
           p.bank_branch_code  = p_bank_branch_code,
           p.bank_account_code = p_bank_account_code,
           p.enabled_flag      = p_enabled_flag,
           p.address           = p_address,
           payment_term_id     = p_payment_term_id,
           payment_method      = p_payment_method,
           transstatus         = '0'
     WHERE p.vender_id = p_vender_id;
  
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'PUR_SYSTEM_VENDERS',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => '',
                                               p_created_by       => p_last_updated_by,
                                               p_last_updated_by  => p_last_updated_by,
                                               p_language_code    => userenv('lang'));
  
  EXCEPTION
    WHEN e_vender_disabled_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PUR_VENDER_DISABLED_ERROR',
                                                      p_created_by              => p_last_updated_by,
                                                      p_package_name            => 'pur_system_venders_pkg',
                                                      p_procedure_function_name => 'update_pur_system_venders');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_last_updated_by,
                                                     p_package_name            => 'pur_system_venders_pkg',
                                                     p_procedure_function_name => 'update_pur_system_venders');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END update_pur_system_venders;

  PROCEDURE update_company_venders_avf(p_vender_id            NUMBER,
                                       p_approved_vender_flag VARCHAR2,
                                       p_last_updated_by      NUMBER) IS
  BEGIN
    FOR cur IN (SELECT v.company_id
                  FROM pur_company_venders v
                 WHERE v.vender_id = p_vender_id) LOOP
      UPDATE pur_company_venders v
         SET v.approved_vender_flag = p_approved_vender_flag,
             v.last_updated_by      = p_last_updated_by
       WHERE v.company_id = cur.company_id
         AND v.vender_id = p_vender_id;
    END LOOP;
  END update_company_venders_avf;
  --系统级 供应商 更新（增加税种、币种、合格供应商字段 ）
  PROCEDURE update_pur_system_venders(p_vender_id            NUMBER,
                                      p_description          VARCHAR2,
                                      p_address              VARCHAR2,
                                      p_artificial_person    VARCHAR2,
                                      p_tax_id_number        VARCHAR2,
                                      p_bank_branch_code     VARCHAR2,
                                      p_bank_account_code    VARCHAR2,
                                      p_payment_term_id      NUMBER,
                                      p_payment_method       VARCHAR2,
                                      p_currency_code        VARCHAR2,
                                      p_tax_type_id          NUMBER,
                                      p_approved_vender_flag VARCHAR2,
                                      p_enabled_flag         VARCHAR2,
                                      p_last_updated_by      NUMBER) IS
    v_description_id pur_system_venders.description_id%TYPE;
    v_disabled_flag  VARCHAR2(1) := 'N';
  BEGIN
    IF (nvl(p_enabled_flag, 'N') = 'N') THEN
      BEGIN
        SELECT 'N'
          INTO v_disabled_flag
          FROM dual
         WHERE EXISTS (SELECT 1
                  FROM pur_company_venders t
                 WHERE t.vender_id = p_vender_id
                   AND t.enabled_flag = 'Y');
      EXCEPTION
        WHEN no_data_found THEN
          v_disabled_flag := 'Y';
      END;
      IF (v_disabled_flag = 'N') THEN
        RAISE e_vender_disabled_error;
      END IF;
    END IF;
  
    SELECT description_id
      INTO v_description_id
      FROM pur_system_venders p
     WHERE p.vender_id = p_vender_id;
  
    UPDATE pur_system_venders p
       SET p.last_updated_by      = p_last_updated_by,
           p.last_update_date     = SYSDATE,
           p.artificial_person    = p_artificial_person,
           p.tax_id_number        = p_tax_id_number,
           p.bank_branch_code     = p_bank_branch_code,
           p.bank_account_code    = p_bank_account_code,
           p.enabled_flag         = p_enabled_flag,
           p.address              = p_address,
           payment_term_id        = p_payment_term_id,
           payment_method         = p_payment_method,
           p.currency_code        = p_currency_code,
           p.tax_type_id          = p_tax_type_id,
           p.approved_vender_flag = p_approved_vender_flag
     WHERE p.vender_id = p_vender_id;
  
    update_company_venders_avf(p_vender_id,
                               p_approved_vender_flag,
                               p_last_updated_by);
  
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'PUR_SYSTEM_VENDERS',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => '',
                                               p_created_by       => p_last_updated_by,
                                               p_last_updated_by  => p_last_updated_by,
                                               p_language_code    => userenv('lang'));
  
  EXCEPTION
    WHEN e_vender_disabled_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PUR_VENDER_DISABLED_ERROR',
                                                      p_created_by              => p_last_updated_by,
                                                      p_package_name            => 'pur_system_venders_pkg',
                                                      p_procedure_function_name => 'update_pur_system_venders');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_last_updated_by,
                                                     p_package_name            => 'pur_system_venders_pkg',
                                                     p_procedure_function_name => 'update_pur_system_venders');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END update_pur_system_venders;

  PROCEDURE delete_pur_system_venders(p_vender_id  NUMBER,
                                      p_created_by NUMBER) IS
    v_exists NUMBER;
  
  BEGIN
    SELECT 1
      INTO v_exists
      FROM dual
     WHERE NOT EXISTS (SELECT 1
              FROM pur_company_venders c
             WHERE c.vender_id = p_vender_id);
  
    DELETE FROM pur_system_venders i WHERE i.vender_id = p_vender_id;
  EXCEPTION
    WHEN no_data_found THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PUR_VENDER_DELETE_ERROR',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'pur_system_venders_pkg',
                                                      p_procedure_function_name => 'delete_pur_system_venders');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END delete_pur_system_venders;

  --系统级供应商分配给公司
  PROCEDURE assign_pur_company_venders(p_company_id           NUMBER,
                                       p_vender_id            NUMBER,
                                       p_payment_term_id      NUMBER,
                                       p_payment_method       VARCHAR2,
                                       p_currency_code        VARCHAR2,
                                       p_tax_type_id          NUMBER,
                                       p_approved_vender_flag VARCHAR2,
                                       p_enabled_flag         VARCHAR2,
                                       p_created_by           NUMBER) IS
    v_enabled_flag VARCHAR2(1) := 'Y';
  BEGIN
    BEGIN
      SELECT 'Y'
        INTO v_enabled_flag
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM pur_system_venders t
               WHERE t.vender_id = p_vender_id
                 AND t.enabled_flag = 'Y');
    EXCEPTION
      WHEN no_data_found THEN
        v_enabled_flag := 'N';
    END;
    IF (v_enabled_flag = 'N') THEN
      RAISE e_comp_vender_enabled_error;
    END IF;
  
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
      (p_company_id,
       p_vender_id,
       p_payment_term_id,
       p_payment_method,
       p_currency_code,
       p_tax_type_id,
       p_approved_vender_flag,
       p_enabled_flag,
       p_created_by,
       SYSDATE,
       p_created_by,
       SYSDATE);
  
  EXCEPTION
    WHEN e_comp_vender_enabled_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PUR_COMP_VENDER_ENABLED_ERROR',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'pur_system_venders_pkg',
                                                      p_procedure_function_name => 'assign_pur_company_venders');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN dup_val_on_index THEN
      --捕获 唯一索引错误
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PUR_VENDER_APPOINTED_COMPANIES_DUPLICATE',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'pur_system_venders_pkg',
                                                      p_procedure_function_name => 'assign_pur_company_venders');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'pur_system_venders_pkg',
                                                     p_procedure_function_name => 'assign_pur_company_venders');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END assign_pur_company_venders;

  --供应商批量分配到公司 不是根据公司code从->到的方式 add by ronghui.xu
  PROCEDURE batch_ass_pur_company_venders(p_company_id           NUMBER,
                                          p_vender_id            NUMBER,
                                          p_payment_term_id      NUMBER,
                                          p_payment_method       VARCHAR2,
                                          p_currency_code        VARCHAR2,
                                          p_tax_type_id          NUMBER,
                                          p_approved_vender_flag VARCHAR2,
                                          p_enabled_flag         VARCHAR2,
                                          p_created_by           NUMBER) IS
    v_enabled_flag VARCHAR2(1) := 'Y';
  BEGIN
    BEGIN
      SELECT 'Y'
        INTO v_enabled_flag
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM pur_system_venders t
               WHERE t.vender_id = p_vender_id
                 AND t.enabled_flag = 'Y');
    EXCEPTION
      WHEN no_data_found THEN
        v_enabled_flag := 'N';
    END;
    IF (v_enabled_flag = 'N') THEN
      RAISE e_comp_vender_enabled_error;
    END IF;
  
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
      SELECT p_company_id,
             p_vender_id,
             p_payment_term_id,
             p_payment_method,
             p_currency_code,
             p_tax_type_id,
             p_approved_vender_flag,
             p_enabled_flag,
             p_created_by,
             SYSDATE,
             p_created_by,
             SYSDATE
        FROM dual
       WHERE NOT EXISTS (SELECT 1
                FROM pur_company_venders pcv
               WHERE pcv.company_id = p_company_id
                 AND pcv.vender_id = p_vender_id);
  
  EXCEPTION
    WHEN e_comp_vender_enabled_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PUR_COMP_VENDER_ENABLED_ERROR',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'pur_system_venders_pkg',
                                                      p_procedure_function_name => 'assign_pur_company_venders');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN dup_val_on_index THEN
      --捕获 唯一索引错误
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PUR_VENDER_APPOINTED_COMPANIES_DUPLICATE',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'pur_system_venders_pkg',
                                                      p_procedure_function_name => 'assign_pur_company_venders');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'pur_system_venders_pkg',
                                                     p_procedure_function_name => 'assign_pur_company_venders');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END batch_ass_pur_company_venders;

  --批量分配公司
  PROCEDURE sel_assign_pur_company_venders(p_company_code_from VARCHAR2,
                                           p_company_code_to   VARCHAR2,
                                           p_vender_id         NUMBER,
                                           p_created_by        NUMBER) IS
    v_sysdate DATE := trunc(SYSDATE);
  BEGIN
    INSERT INTO pur_company_venders
      (company_id,
       vender_id,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
      SELECT f.company_id,
             p_vender_id,
             'Y',
             p_created_by,
             SYSDATE,
             p_created_by,
             SYSDATE
        FROM fnd_companies f
       WHERE f.company_code >= p_company_code_from
         AND f.company_code <= p_company_code_to
         AND f.company_type = '1'
         AND f.start_date_active <= v_sysdate
         AND (f.end_date_active >= v_sysdate OR f.end_date_active IS NULL)
         AND NOT EXISTS (SELECT 1
                FROM pur_company_venders i
               WHERE i.company_id = f.company_id
                 AND i.vender_id = p_vender_id);
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'pur_system_venders_pkg',
                                                     p_procedure_function_name => 'sel_assign_pur_company_venders');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END sel_assign_pur_company_venders;

  --分配给所有公司
  PROCEDURE all_assign_pur_company_venders(p_vender_id  NUMBER,
                                           p_created_by NUMBER) IS
    v_sysdate      DATE := trunc(SYSDATE);
    v_enabled_flag VARCHAR2(1) := 'Y';
  BEGIN
    BEGIN
      SELECT 'Y'
        INTO v_enabled_flag
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM pur_system_venders t
               WHERE t.vender_id = p_vender_id
                 AND t.enabled_flag = 'Y');
    EXCEPTION
      WHEN no_data_found THEN
        v_enabled_flag := 'N';
    END;
    IF (v_enabled_flag = 'N') THEN
      RAISE e_comp_vender_enabled_error;
    END IF;
  
    INSERT INTO pur_company_venders
      (company_id,
       vender_id,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
      SELECT f.company_id,
             p_vender_id,
             'Y',
             p_created_by,
             SYSDATE,
             p_created_by,
             SYSDATE
        FROM fnd_companies f
       WHERE f.company_type = '1'
         AND f.start_date_active <= v_sysdate
         AND (f.end_date_active >= v_sysdate OR f.end_date_active IS NULL)
         AND NOT EXISTS (SELECT 1
                FROM pur_company_venders i
               WHERE i.company_id = f.company_id
                 AND i.vender_id = p_vender_id);
  
  EXCEPTION
    WHEN e_comp_vender_enabled_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PUR_COMP_VENDER_ENABLED_ERROR',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'pur_system_venders_pkg',
                                                      p_procedure_function_name => 'all_assign_pur_company_venders');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'pur_system_venders_pkg',
                                                     p_procedure_function_name => 'all_assign_pur_company_venders');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END all_assign_pur_company_venders;

  --系统级，批量更新公司启用、失效
  PROCEDURE update_pur_company_venders(p_company_id      NUMBER,
                                       p_vender_id       NUMBER,
                                       p_enabled_flag    VARCHAR2,
                                       p_last_updated_by NUMBER) IS
    v_enabled_flag VARCHAR2(1) := 'Y';
  BEGIN
    IF (nvl(p_enabled_flag, 'N') = 'Y') THEN
      BEGIN
        SELECT 'Y'
          INTO v_enabled_flag
          FROM dual
         WHERE EXISTS (SELECT 1
                  FROM pur_system_venders t
                 WHERE t.vender_id = p_vender_id
                   AND t.enabled_flag = 'Y');
      EXCEPTION
        WHEN no_data_found THEN
          v_enabled_flag := 'N';
      END;
      IF (v_enabled_flag = 'N') THEN
        RAISE e_comp_vender_enabled_error;
      END IF;
    END IF;
  
    UPDATE pur_company_venders i
       SET i.enabled_flag     = p_enabled_flag,
           i.last_update_date = SYSDATE,
           i.last_updated_by  = p_last_updated_by
     WHERE i.company_id = p_company_id
       AND i.vender_id = p_vender_id;
  EXCEPTION
    WHEN e_comp_vender_enabled_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PUR_COMP_VENDER_ENABLED_ERROR',
                                                      p_created_by              => p_last_updated_by,
                                                      p_package_name            => 'pur_system_venders_pkg',
                                                      p_procedure_function_name => 'update_pur_system_venders');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_pur_company_venders;

  --公司级客户 更新
  PROCEDURE update_pur_company_venders(p_company_id      NUMBER,
                                       p_vender_id       NUMBER,
                                       p_account_id      NUMBER,
                                       p_enabled_flag    VARCHAR2,
                                       p_last_updated_by NUMBER) IS
    v_enabled_flag VARCHAR2(1) := 'Y';
  BEGIN
    IF (nvl(p_enabled_flag, 'N') = 'Y') THEN
      BEGIN
        SELECT 'Y'
          INTO v_enabled_flag
          FROM dual
         WHERE EXISTS (SELECT 1
                  FROM pur_system_venders t
                 WHERE t.vender_id = p_vender_id
                   AND t.enabled_flag = 'Y');
      EXCEPTION
        WHEN no_data_found THEN
          v_enabled_flag := 'N';
      END;
      IF (v_enabled_flag = 'N') THEN
        RAISE e_comp_vender_enabled_error;
      END IF;
    END IF;
  
    UPDATE pur_company_venders i
       SET i.enabled_flag     = p_enabled_flag,
           i.account_id       = p_account_id,
           i.last_update_date = SYSDATE,
           i.last_updated_by  = p_last_updated_by
     WHERE i.company_id = p_company_id
       AND i.vender_id = p_vender_id;
  EXCEPTION
    WHEN e_comp_vender_enabled_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PUR_COMP_VENDER_ENABLED_ERROR',
                                                      p_created_by              => p_last_updated_by,
                                                      p_package_name            => 'pur_system_venders_pkg',
                                                      p_procedure_function_name => 'update_pur_system_venders');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_pur_company_venders;

  --公司级客户 更新（增加税种、币种、合格供应商字段）
  PROCEDURE update_pur_company_venders(p_company_id           NUMBER,
                                       p_vender_id            NUMBER,
                                       p_payment_term_id      NUMBER,
                                       p_payment_method       VARCHAR2,
                                       p_currency_code        VARCHAR2,
                                       p_tax_type_id          NUMBER,
                                       p_approved_vender_flag VARCHAR2,
                                       p_enabled_flag         VARCHAR2,
                                       p_last_updated_by      NUMBER) IS
    v_enabled_flag VARCHAR2(1) := 'Y';
  BEGIN
    IF (nvl(p_enabled_flag, 'N') = 'Y') THEN
      BEGIN
        SELECT 'Y'
          INTO v_enabled_flag
          FROM dual
         WHERE EXISTS (SELECT 1
                  FROM pur_system_venders t
                 WHERE t.vender_id = p_vender_id
                   AND t.enabled_flag = 'Y');
      EXCEPTION
        WHEN no_data_found THEN
          v_enabled_flag := 'N';
      END;
      IF (v_enabled_flag = 'N') THEN
        RAISE e_comp_vender_enabled_error;
      END IF;
    END IF;
  
    UPDATE pur_company_venders i
       SET i.payment_term_id      = p_payment_term_id,
           i.payment_method       = p_payment_method,
           i.currency_code        = p_currency_code,
           i.tax_type_id          = p_tax_type_id,
           i.approved_vender_flag = p_approved_vender_flag,
           i.enabled_flag         = p_enabled_flag,
           i.last_update_date     = SYSDATE,
           i.last_updated_by      = p_last_updated_by
     WHERE i.company_id = p_company_id
       AND i.vender_id = p_vender_id;
  EXCEPTION
    WHEN e_comp_vender_enabled_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PUR_COMP_VENDER_ENABLED_ERROR',
                                                      p_created_by              => p_last_updated_by,
                                                      p_package_name            => 'pur_system_venders_pkg',
                                                      p_procedure_function_name => 'update_pur_system_venders');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_pur_company_venders;

  PROCEDURE import_pur_company_venders(p_company_code_from VARCHAR2,
                                       p_company_code_to   VARCHAR2,
                                       p_vender_id         NUMBER,
                                       p_company_code_like VARCHAR2,
                                       p_created_by        NUMBER) IS
    v_sysdate              DATE := trunc(SYSDATE);
    v_from_to_flag         VARCHAR2(1) := 'N';
    v_like_flag            VARCHAR2(1) := 'N';
    v_enabled_flag         VARCHAR2(1);
    v_approved_vender_flag VARCHAR2(1);
    v_payment_term_id      NUMBER;
    v_payment_method       VARCHAR2(30);
    v_currency_code        VARCHAR2(30);
    v_tax_type_id          NUMBER;
  BEGIN
    BEGIN
      /*      select 'Y'
       into v_enabled_flag
       from dual
      where exists (select 1
               from pur_system_venders t
              where t.vender_id = p_vender_id
                and t.enabled_flag = 'Y');*/
      SELECT nvl(t.enabled_flag, 'Y'), nvl(t.approved_vender_flag, 'N')
        INTO v_enabled_flag, v_approved_vender_flag
        FROM pur_system_venders t
       WHERE t.vender_id = p_vender_id
         AND t.enabled_flag = 'Y';
    EXCEPTION
      WHEN no_data_found THEN
        v_enabled_flag := 'N';
    END;
    BEGIN
      SELECT cp.payment_term_id
        INTO v_payment_term_id
        FROM pur_system_venders_vl pv, csh_payment_terms_vl cp
       WHERE pv.payment_term_id = cp.payment_term_id(+)
         AND pv.vender_id = p_vender_id;
      SELECT cp.payment_method_code
        INTO v_payment_method
        FROM pur_system_venders_vl pv
       RIGHT OUTER JOIN csh_payment_methods_vl cp
          ON pv.payment_method = cp.payment_method_code
       WHERE pv.vender_id = p_vender_id;
      SELECT t.currency_code
        INTO v_currency_code
        FROM pur_system_venders_vl t
       WHERE t.vender_id = p_vender_id;
      SELECT pv.tax_type_id
        INTO v_tax_type_id
        FROM pur_system_venders_vl pv
       WHERE pv.vender_id = p_vender_id;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    IF (v_enabled_flag = 'N') THEN
      RAISE e_comp_vender_enabled_error;
    END IF;
  
    IF (p_company_code_like IS NOT NULL) THEN
      v_like_flag := 'Y';
    END IF;
    IF (p_company_code_from IS NOT NULL OR p_company_code_to IS NOT NULL) THEN
      v_from_to_flag := 'Y';
    END IF;
    IF (v_like_flag = 'N' AND v_from_to_flag = 'N') THEN
      RETURN;
    END IF;
  
    IF v_from_to_flag = 'N' THEN
      INSERT INTO pur_company_venders
        (company_id,
         vender_id,
         approved_vender_flag,
         enabled_flag,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date,
         payment_term_id,
         payment_method,
         currency_code,
         tax_type_id)
        SELECT c.company_id,
               p_vender_id,
               v_approved_vender_flag,
               'Y',
               p_created_by,
               SYSDATE,
               p_created_by,
               SYSDATE,
               v_payment_term_id      payment_term_id,
               v_payment_method       payment_method,
               v_currency_code        currency_code,
               v_tax_type_id          tax_type_id
          FROM fnd_companies c
         WHERE c.company_code LIKE p_company_code_like
           AND c.company_type = '1'
           AND c.start_date_active <= v_sysdate
           AND (c.end_date_active >= v_sysdate OR c.end_date_active IS NULL)
           AND NOT EXISTS (SELECT 1
                  FROM pur_company_venders v
                 WHERE v.vender_id = p_vender_id
                   AND v.company_id = c.company_id);
    ELSIF (v_like_flag = 'N') THEN
      INSERT INTO pur_company_venders
        (company_id,
         vender_id,
         approved_vender_flag,
         enabled_flag,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date,
         payment_term_id,
         payment_method,
         currency_code,
         tax_type_id)
        SELECT c.company_id,
               p_vender_id,
               v_approved_vender_flag,
               'Y',
               p_created_by,
               SYSDATE,
               p_created_by,
               SYSDATE,
               v_payment_term_id      payment_term_id,
               v_payment_method       payment_method,
               v_currency_code        currency_code,
               v_tax_type_id          tax_type_id
          FROM fnd_companies c
         WHERE c.company_type = '1'
           AND c.start_date_active <= v_sysdate
           AND (c.end_date_active >= v_sysdate OR c.end_date_active IS NULL)
           AND NOT EXISTS
         (SELECT 1
                  FROM pur_company_venders v
                 WHERE v.vender_id = p_vender_id
                   AND v.company_id = c.company_id)
           AND ((c.company_code >= nvl(p_company_code_from, company_code)) AND
               (c.company_code <= nvl(p_company_code_to, company_code)));
    ELSE
      INSERT INTO pur_company_venders
        (company_id,
         vender_id,
         approved_vender_flag,
         enabled_flag,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date,
         payment_term_id,
         payment_method,
         currency_code,
         tax_type_id)
        SELECT c.company_id,
               p_vender_id,
               v_approved_vender_flag,
               'Y',
               p_created_by,
               SYSDATE,
               p_created_by,
               SYSDATE,
               v_payment_term_id      payment_term_id,
               v_payment_method       payment_method,
               v_currency_code        currency_code,
               v_tax_type_id          tax_type_id
          FROM fnd_companies c
         WHERE c.company_type = '1'
           AND c.start_date_active <= v_sysdate
           AND (c.end_date_active >= v_sysdate OR c.end_date_active IS NULL)
           AND NOT EXISTS
         (SELECT 1
                  FROM pur_company_venders v
                 WHERE v.vender_id = p_vender_id
                   AND v.company_id = c.company_id)
           AND ((c.company_code LIKE p_company_code_like) AND
               ((c.company_code >= nvl(p_company_code_from, company_code)) AND
               (c.company_code <= nvl(p_company_code_to, company_code))));
    END IF;
  EXCEPTION
    WHEN e_comp_vender_enabled_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'PUR_COMP_VENDER_ENABLED_ERROR',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'pur_system_venders_pkg',
                                                      p_procedure_function_name => 'import_pur_company_venders');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'bgt_versions_pkg',
                                                     p_procedure_function_name => 'import_bgt_company_versions');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END import_pur_company_venders;

  PROCEDURE del_fnd_sys_vend_asgn_company(p_session_id       NUMBER,
                                          p_application_code VARCHAR2) IS
  BEGIN
    DELETE FROM fnd_sys_vender_asgn_cm_tmp t
     WHERE t.session_id = p_session_id
       AND t.application_code = p_application_code;
  END del_fnd_sys_vend_asgn_company;

  PROCEDURE ins_fnd_sys_vend_asgn_company(p_session_id       NUMBER,
                                          p_application_code VARCHAR2,
                                          p_vender_id        NUMBER,
                                          p_user_id          NUMBER) IS
  BEGIN
    INSERT INTO fnd_sys_vender_asgn_cm_tmp
      (session_id, application_code, vender_id, creation_date, created_by)
    VALUES
      (p_session_id, p_application_code, p_vender_id, SYSDATE, p_user_id);
  END ins_fnd_sys_vend_asgn_company;

  PROCEDURE batch_import_com_fnd_sys_vend(p_company_id       NUMBER,
                                          p_set_of_books_id  NUMBER,
                                          p_session_id       NUMBER,
                                          p_application_code VARCHAR2,
                                          p_user_id          NUMBER) IS
  BEGIN
    INSERT INTO pur_company_venders
      (company_id,
       vender_id,
       approved_vender_flag,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
      SELECT c.company_id,
             t.vender_id,
             nvl(psv.approved_vender_flag, 'N'),
             psv.enabled_flag,
             p_user_id,
             SYSDATE,
             p_user_id,
             SYSDATE
        FROM fnd_companies              c,
             fnd_sys_vender_asgn_cm_tmp t,
             pur_system_venders         psv
       WHERE psv.vender_id = t.vender_id
         AND c.company_id = p_company_id
         AND (c.set_of_books_id = nvl(p_set_of_books_id, c.set_of_books_id))
         AND t.session_id = p_session_id
         AND t.application_code = p_application_code
         AND NOT EXISTS (SELECT 1
                FROM pur_company_venders v
               WHERE v.vender_id = t.vender_id
                 AND v.company_id = c.company_id);
  END batch_import_com_fnd_sys_vend;

  --********************HCT*****************************************

  PROCEDURE hct_ins_pur_vender_management(p_vender_id           NUMBER,
                                          p_maintain_company_id NUMBER,
                                          p_user_id             NUMBER) IS
  BEGIN
    INSERT INTO pur_vender_management
      (vender_id,
       maintain_company_id,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (p_vender_id,
       p_maintain_company_id,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE);
  END hct_ins_pur_vender_management;

  --自动分发
  PROCEDURE hct_auto_distribute(p_vender_id           NUMBER,
                                p_user_id             NUMBER,
                                p_maintain_company_id NUMBER) IS
    v_auto_distribute VARCHAR2(1);
  BEGIN
    v_auto_distribute := sys_parameter_pkg.value(p_parameter_code => 'FND_MASTER_DATA_AUTO_DISTRIBUTE');
    IF v_auto_distribute = 'Y' THEN
      INSERT INTO pur_company_venders
        (vender_id,
         company_id,
         enabled_flag,
         creation_date,
         created_by,
         last_update_date,
         last_updated_by)
        SELECT p_vender_id,
               f.company_id,
               (SELECT t.enabled_flag
                  FROM pur_company_venders t
                 WHERE t.company_id = p_maintain_company_id
                   AND t.vender_id = p_vender_id),
               SYSDATE,
               p_user_id,
               SYSDATE,
               p_user_id
          FROM (SELECT t.company_id
                  FROM fnd_company_hierarchy_detail t
                CONNECT BY PRIOR t.company_id = t.parent_company_id
                 START WITH t.parent_company_id = p_maintain_company_id) f
         WHERE NOT EXISTS (SELECT 1
                  FROM pur_company_venders i
                 WHERE i.vender_id = p_vender_id
                   AND i.company_id = f.company_id);
    
    END IF;
  END hct_auto_distribute;

  --物品代码唯一性校验
  PROCEDURE vender_code_unique_check(p_vender_code         VARCHAR2,
                                     p_user_id             NUMBER,
                                     p_maintain_company_id NUMBER) IS
    v_exists NUMBER;
    e_vender_code_unique EXCEPTION;
  BEGIN
    BEGIN
      --上级公司是否重复
      SELECT 1
        INTO v_exists
        FROM dual
       WHERE EXISTS
       (SELECT a.*
                FROM pur_company_venders a
               WHERE a.vender_id IN
                     (SELECT isit.vender_id
                        FROM pur_system_venders isit
                       WHERE isit.vender_code = p_vender_code)
                 AND a.company_id IN
                     (SELECT t.parent_company_id
                        FROM fnd_company_hierarchy_detail t
                      CONNECT BY t.company_id = PRIOR t.parent_company_id
                       START WITH t.company_id = p_maintain_company_id));
      RAISE e_vender_code_unique;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    BEGIN
      --下级公司是否重复
      SELECT 1
        INTO v_exists
        FROM dual
       WHERE EXISTS
       (SELECT a.*
                FROM pur_company_venders a
               WHERE a.vender_id IN
                     (SELECT isit.vender_id
                        FROM pur_system_venders isit
                       WHERE isit.vender_code = p_vender_code)
                 AND company_id <> p_maintain_company_id
                 AND a.company_id IN
                     (SELECT t.company_id
                        FROM fnd_company_hierarchy_detail t
                      CONNECT BY PRIOR t.company_id = t.parent_company_id
                       START WITH t.parent_company_id = p_maintain_company_id));
      RAISE e_vender_code_unique;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
  EXCEPTION
    WHEN e_vender_code_unique THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'FND2415_VENDER_CODE_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'pur_system_venders_pkg',
                                                      p_procedure_function_name => 'vender_code_unique_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END vender_code_unique_check;

  PROCEDURE hct_ins_pur_system_venders(p_vender_code         VARCHAR2,
                                       p_description         VARCHAR2,
                                       p_address             VARCHAR2,
                                       p_artificial_person   VARCHAR2,
                                       p_tax_id_number       VARCHAR2,
                                       p_bank_branch_code    VARCHAR2,
                                       p_bank_account_code   VARCHAR2,
                                       p_enabled_flag        VARCHAR2,
                                       p_user_id             NUMBER,
                                       p_vender_type_id      NUMBER,
                                       p_payment_term_id     NUMBER,
                                       p_payment_method      VARCHAR2,
                                       p_maintain_company_id NUMBER,
                                       p_vender_id           OUT NUMBER) IS
    v_description_id pur_system_venders.description_id%TYPE;
    v_rowid          VARCHAR2(30);
  BEGIN
    v_description_id := fnd_description_pkg.get_fnd_description_id;
    p_vender_id      := get_vender_id;
    INSERT INTO pur_system_venders
      (vender_id,
       vender_code,
       description_id,
       address,
       artificial_person,
       tax_id_number,
       bank_branch_code,
       bank_account_code,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       vender_type_id,
       payment_term_id,
       payment_method)
    VALUES
      (p_vender_id,
       p_vender_code,
       v_description_id,
       p_address,
       p_artificial_person,
       p_tax_id_number,
       p_bank_branch_code,
       p_bank_account_code,
       p_enabled_flag,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_vender_type_id,
       p_payment_term_id,
       p_payment_method);
  
    vender_code_unique_check(p_vender_code         => p_vender_code,
                             p_user_id             => p_user_id,
                             p_maintain_company_id => p_maintain_company_id);
  
    hct_ins_pur_vender_management(p_vender_id           => p_vender_id,
                                  p_maintain_company_id => p_maintain_company_id,
                                  p_user_id             => p_user_id);
  
    hct_insert_pur_company_venders(p_company_id   => p_maintain_company_id,
                                   p_vender_id    => p_vender_id,
                                   p_enabled_flag => p_enabled_flag,
                                   p_user_id      => p_user_id,
                                   p_rowid        => v_rowid);
  
    hct_auto_distribute(p_vender_id           => p_vender_id,
                        p_user_id             => p_user_id,
                        p_maintain_company_id => p_maintain_company_id);
  
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'PUR_SYSTEM_VENDERS',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => 'FND2415',
                                               p_created_by       => p_user_id,
                                               p_last_updated_by  => p_user_id,
                                               p_language_code    => userenv('lang'));
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'pur_system_venders_pkg',
                                                     p_procedure_function_name => 'hct_ins_pur_system_venders');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END hct_ins_pur_system_venders;

  FUNCTION get_maintain_company_id(p_vender_id NUMBER) RETURN NUMBER IS
    v_maintain_company_id NUMBER;
  BEGIN
    SELECT i.maintain_company_id
      INTO v_maintain_company_id
      FROM pur_vender_management i
     WHERE i.vender_id = p_vender_id;
    RETURN v_maintain_company_id;
  END get_maintain_company_id;

  PROCEDURE maintain_company_enabled_check(p_vender_id           NUMBER,
                                           p_maintain_company_id NUMBER,
                                           p_user_id             NUMBER) IS
    v_exists NUMBER;
  BEGIN
    SELECT 1
      INTO v_exists
      FROM dual
     WHERE EXISTS (SELECT *
              FROM pur_company_venders a
             WHERE a.vender_id = p_vender_id
               AND a.enabled_flag = 'Y'
               AND a.company_id = p_maintain_company_id);
  EXCEPTION
    WHEN no_data_found THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'FND2415_VENDER_ENABLED_FIRST',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'pur_system_venders_pkg',
                                                      p_procedure_function_name => 'maintain_company_enabled_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END maintain_company_enabled_check;

  PROCEDURE hct_upd_pur_system_venders(p_vender_id          NUMBER,
                                       p_description        VARCHAR2,
                                       p_address            VARCHAR2,
                                       p_artificial_person  VARCHAR2,
                                       p_tax_id_number      VARCHAR2,
                                       p_bank_branch_code   VARCHAR2,
                                       p_bank_account_code  VARCHAR2,
                                       p_enabled_flag       VARCHAR2,
                                       p_payment_term_id    NUMBER,
                                       p_payment_method     VARCHAR2,
                                       p_user_id            NUMBER,
                                       p_current_company_id NUMBER) IS
    v_description_id      pur_system_venders.description_id%TYPE;
    v_maintain_company_id NUMBER;
    v_exists              NUMBER;
  BEGIN
  
    v_maintain_company_id := get_maintain_company_id(p_vender_id);
    IF p_current_company_id = v_maintain_company_id THEN
      IF p_enabled_flag = 'N' THEN
        BEGIN
          SELECT 1
            INTO v_exists
            FROM dual
           WHERE EXISTS
           (SELECT *
                    FROM pur_company_venders a
                   WHERE a.vender_id = p_vender_id
                     AND a.enabled_flag = 'Y'
                     AND a.company_id IN
                         ((SELECT t.company_id
                            FROM fnd_company_hierarchy_detail t
                          CONNECT BY PRIOR t.company_id = t.parent_company_id
                           START WITH t.parent_company_id =
                                      v_maintain_company_id))
                     AND a.company_id <> v_maintain_company_id);
        
          sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'FND2415_VENDER_IN_USE',
                                                          p_created_by              => p_user_id,
                                                          p_package_name            => 'pur_system_venders_pkg',
                                                          p_procedure_function_name => 'hct_update_pur_system_venders');
          raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                  sys_raise_app_error_pkg.g_err_line_id);
        EXCEPTION
          WHEN no_data_found THEN
            NULL;
        END;
      END IF;
    
      SELECT description_id
        INTO v_description_id
        FROM pur_system_venders p
       WHERE p.vender_id = p_vender_id;
    
      UPDATE pur_system_venders p
         SET p.last_updated_by   = p_user_id,
             p.last_update_date  = SYSDATE,
             p.artificial_person = p_artificial_person,
             p.tax_id_number     = p_tax_id_number,
             p.bank_branch_code  = p_bank_branch_code,
             p.bank_account_code = p_bank_account_code,
             p.enabled_flag      = p_enabled_flag,
             p.address           = p_address,
             payment_term_id     = p_payment_term_id,
             payment_method      = p_payment_method
       WHERE p.vender_id = p_vender_id;
    
      fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                                 p_ref_table        => 'PUR_SYSTEM_VENDERS',
                                                 p_ref_field        => 'DESCRIPTION_ID',
                                                 p_description_text => p_description,
                                                 p_function_name    => 'FND2415',
                                                 p_created_by       => p_user_id,
                                                 p_last_updated_by  => p_user_id,
                                                 p_language_code    => userenv('lang'));
    
      hct_auto_distribute(p_vender_id           => p_vender_id,
                          p_user_id             => p_user_id,
                          p_maintain_company_id => v_maintain_company_id);
    ELSE
      IF p_enabled_flag = 'Y' THEN
        maintain_company_enabled_check(p_vender_id           => p_vender_id,
                                       p_maintain_company_id => v_maintain_company_id,
                                       p_user_id             => p_user_id);
      END IF;
    END IF;
  
    UPDATE pur_company_venders a
       SET a.last_updated_by  = p_user_id,
           a.last_update_date = SYSDATE,
           a.enabled_flag     = p_enabled_flag
     WHERE a.company_id = p_current_company_id
       AND a.vender_id = p_vender_id;
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'pur_system_venders_pkg',
                                                     p_procedure_function_name => 'hct_upd_pur_system_venders');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END hct_upd_pur_system_venders;

  PROCEDURE hct_insert_pur_company_venders(p_company_id   NUMBER,
                                           p_vender_id    NUMBER,
                                           p_enabled_flag VARCHAR2,
                                           p_user_id      NUMBER,
                                           p_rowid        OUT VARCHAR2) IS
    v_maintain_company_id NUMBER;
  BEGIN
    v_maintain_company_id := get_maintain_company_id(p_vender_id);
    IF p_enabled_flag = 'Y' AND p_company_id <> v_maintain_company_id THEN
      maintain_company_enabled_check(p_vender_id           => p_vender_id,
                                     p_maintain_company_id => v_maintain_company_id,
                                     p_user_id             => p_user_id);
    END IF;
  
    INSERT INTO pur_company_venders
      (company_id,
       vender_id,
       enabled_flag,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by)
    VALUES
      (p_company_id,
       p_vender_id,
       p_enabled_flag,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_user_id)
    RETURNING ROWID INTO p_rowid;
  
  EXCEPTION
    WHEN dup_val_on_index THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'FND2415_VENDER_APPOINTED_COMPANIES_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'pur_system_venders_pkg',
                                                      p_procedure_function_name => 'hct_insert_pur_company_venders');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'pur_system_venders_pkg',
                                                     p_procedure_function_name => 'hct_insert_pur_company_venders');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END hct_insert_pur_company_venders;

  PROCEDURE hct_update_pur_company_venders(p_rowid        VARCHAR2,
                                           p_company_id   NUMBER,
                                           p_vender_id    NUMBER,
                                           p_enabled_flag VARCHAR2,
                                           p_user_id      NUMBER) IS
    v_maintain_company_id NUMBER;
  BEGIN
    v_maintain_company_id := get_maintain_company_id(p_vender_id);
    IF p_enabled_flag = 'Y' AND v_maintain_company_id <> p_company_id THEN
      maintain_company_enabled_check(p_vender_id           => p_vender_id,
                                     p_maintain_company_id => v_maintain_company_id,
                                     p_user_id             => p_user_id);
    END IF;
  
    UPDATE pur_company_venders ci
       SET ci.last_update_date = SYSDATE,
           ci.last_updated_by  = p_user_id,
           ci.company_id       = p_company_id,
           ci.enabled_flag     = p_enabled_flag
     WHERE ci.rowid = p_rowid;
  
  EXCEPTION
    WHEN dup_val_on_index THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'FND2415_VENDER_APPOINTED_COMPANIES_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'pur_system_venders_pkg',
                                                      p_procedure_function_name => 'hct_update_pur_company_venders');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'pur_system_venders_pkg',
                                                     p_procedure_function_name => 'hct_insert_pur_company_venders');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END hct_update_pur_company_venders;

  --批量分配
  PROCEDURE hct_batch_assign_com_venders(p_company_code_from   VARCHAR2,
                                         p_company_code_to     VARCHAR2,
                                         p_vender_id           NUMBER,
                                         p_company_code_like   VARCHAR2,
                                         p_user_id             NUMBER,
                                         p_maintain_company_id NUMBER) IS
    v_sysdate DATE := trunc(SYSDATE);
  BEGIN
    INSERT INTO pur_company_venders
      (vender_id,
       company_id,
       enabled_flag,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by)
      SELECT p_vender_id,
             f.company_id,
             (SELECT t.enabled_flag
                FROM pur_company_venders t
               WHERE t.vender_id = p_vender_id
                 AND t.company_id = p_maintain_company_id),
             SYSDATE,
             p_user_id,
             SYSDATE,
             p_user_id
        FROM fnd_companies f
       WHERE f.company_code >= nvl(p_company_code_from, f.company_code)
         AND f.company_code <= nvl(p_company_code_to, f.company_code)
         AND ((f.company_code LIKE p_company_code_like AND
             p_company_code_like IS NOT NULL) OR
             (p_company_code_like IS NULL))
         AND f.company_type IN (1, 2)
         AND f.start_date_active <= v_sysdate
         AND (f.end_date_active >= v_sysdate OR f.end_date_active IS NULL)
         AND NOT EXISTS
       (SELECT 1
                FROM pur_company_venders i
               WHERE i.vender_id = p_vender_id
                 AND i.company_id = f.company_id)
         AND f.company_id IN
             (SELECT t.company_id
                FROM fnd_company_hierarchy_detail t
              CONNECT BY PRIOR t.company_id = t.parent_company_id
               START WITH t.parent_company_id = p_maintain_company_id);
  END hct_batch_assign_com_venders;
  --导入系统级供应商分配给公司
  PROCEDURE load_assign_pur_com_venders(p_company_code VARCHAR2,
                                        p_vender_code  VARCHAR2) IS
  
    v_company_id  NUMBER;
    r_sys_venders pur_system_venders%ROWTYPE;
  BEGIN
    SELECT company_id
      INTO v_company_id
      FROM fnd_companies_vl f
     WHERE f.company_code = p_company_code;
    SELECT p.*
      INTO r_sys_venders
      FROM pur_system_venders p
     WHERE p.vender_code = p_vender_code;
    assign_pur_company_venders(p_company_id           => v_company_id,
                               p_vender_id            => r_sys_venders.vender_id,
                               p_payment_term_id      => r_sys_venders.payment_term_id,
                               p_payment_method       => r_sys_venders.payment_method,
                               p_currency_code        => r_sys_venders.currency_code,
                               p_tax_type_id          => r_sys_venders.tax_type_id,
                               p_approved_vender_flag => r_sys_venders.approved_vender_flag,
                               p_enabled_flag         => r_sys_venders.enabled_flag,
                               p_created_by           => -1);
  END;
END pur_system_venders_pkg;
/
