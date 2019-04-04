CREATE OR REPLACE PACKAGE csh_payment_req_audit_pkg IS

  -- Author  : BOBO
  -- Created : 2010-04-13 13:46:54
  -- Purpose : 借款申请单审核

  --modify by daibo
  --line:875 修改v_je_creation_status的取值 避免je_creation_status值为空的情况

  FUNCTION get_je_line_id RETURN NUMBER;

  PROCEDURE del_csh_pmt_req_accounts_tmp(p_session_id NUMBER);

  --创建选择单据临时表
  PROCEDURE ins_csh_pmt_req_accounts_tmp(p_session_id            NUMBER,
                                         p_payment_req_header_id NUMBER);

  --创建凭证时需要的临时表
  PROCEDURE create_currency_code_tmp(p_session_id NUMBER,
                                     p_company_id NUMBER,
                                     p_user_id    NUMBER);

  PROCEDURE update_currency_code_tmp(p_session_id              NUMBER,
                                     p_currency_code           VARCHAR2,
                                     p_exchange_rate_type      VARCHAR2,
                                     p_exchange_rate           NUMBER,
                                     p_exchange_rate_quotation VARCHAR2);

  --开始创建借款申请单凭证
  PROCEDURE create_csh_pmt_req_account(p_session_id   NUMBER,
                                       p_journal_date DATE,
                                       p_company_id   NUMBER,
                                       p_user_id      NUMBER);

  --审核拒绝
  PROCEDURE audit_reject_csh_pmt_req(p_pmt_req_header_id NUMBER,
                                     p_user_id           NUMBER,
                                     p_description       VARCHAR2);

  -- 审核
  PROCEDURE audit_csh_pmt_req(p_pmt_req_header_id NUMBER,
                              p_user_id           NUMBER,
                              p_journal_date      varchar2,
                              p_audit_opinion     VARCHAR2 DEFAULT NULL);

  --复核
  PROCEDURE audit_csh_pmt_req_recheck(p_pmt_req_header_id NUMBER,
                                      p_user_id           NUMBER,
                                      p_recheck_opinion   VARCHAR2 DEFAULT NULL);

  --借款申请反冲
  PROCEDURE reverse_csh_panyment_req(p_pmt_req_header_id NUMBER,
                                     p_reverse_date      DATE,
                                     p_user_id           NUMBER);

  --借款申请凭证调整
  PROCEDURE update_csh_pnt_req_accounts(p_je_line_id               NUMBER,
                                        p_description              VARCHAR2,
                                        p_company_id               NUMBER,
                                        p_responsibility_center_id NUMBER,
                                        p_account_id               NUMBER,
                                        p_entered_amount_dr        NUMBER,
                                        p_entered_amount_cr        NUMBER,
                                        p_functional_amount_dr     NUMBER,
                                        p_functional_amount_cr     NUMBER,
                                        p_account_segment2         VARCHAR2,
                                        p_account_segment3         VARCHAR2,
                                        p_user_id                  NUMBER);

  FUNCTION execute_csh_pmt_req_account(p_pmt_req_header_id NUMBER,
                                       p_journal_date      DATE,
                                       p_session_id        NUMBER,
                                       p_period_name       VARCHAR2)
    RETURN VARCHAR2;

  FUNCTION set_g_user_id(p_user_id NUMBER) RETURN NUMBER;
END csh_payment_req_audit_pkg;
/
CREATE OR REPLACE PACKAGE BODY csh_payment_req_audit_pkg IS

  g_user_id             NUMBER;
  g_session_id          NUMBER;
  g_requisition_number  VARCHAR2(30);
  g_payment_req_line_id NUMBER;

  FUNCTION get_je_line_id RETURN NUMBER IS
    v_je_line_id NUMBER;
  BEGIN
    SELECT csh_payment_req_accounts_s.nextval INTO v_je_line_id FROM dual;
    RETURN v_je_line_id;
  END;

  PROCEDURE delete_error_log IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    RAISE no_data_found;
    DELETE FROM csh_pmt_req_audit_error_logs t
     WHERE t.session_id = g_session_id;
    COMMIT;
  EXCEPTION
    WHEN no_data_found THEN
      NULL;
  END delete_error_log;

  PROCEDURE error_log(p_log_text_code VARCHAR2) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO csh_pmt_req_audit_error_logs t
      (session_id,
       requisition_number,
       payment_req_line_id,
       message,
       created_by,
       creation_date)
    VALUES
      (g_session_id,
       g_requisition_number,
       g_payment_req_line_id,
       p_log_text_code,
       g_user_id,
       SYSDATE);
    COMMIT;
  END error_log;

  PROCEDURE del_csh_pmt_req_accounts_tmp(p_session_id NUMBER) IS
  BEGIN
    DELETE FROM csh_payment_req_accounts_tmp a
     WHERE a.session_id = p_session_id;
  END;

  --创建选择单据临时表
  PROCEDURE ins_csh_pmt_req_accounts_tmp(p_session_id            NUMBER,
                                         p_payment_req_header_id NUMBER) IS
  BEGIN
    INSERT INTO csh_payment_req_accounts_tmp
      (session_id, payment_req_header_id, creation_date)
    VALUES
      (p_session_id, p_payment_req_header_id, SYSDATE);
  END;

  PROCEDURE del_csh_pmt_req_currency_tmp(p_session_id NUMBER) IS
  BEGIN
    DELETE FROM csh_pmt_req_currency_tmp t
     WHERE t.session_id = p_session_id;
  END;

  --创建凭证时需要的临时表
  PROCEDURE create_currency_code_tmp(p_session_id NUMBER,
                                     p_company_id NUMBER,
                                     p_user_id    NUMBER) IS
    --取所有非本位币
    CURSOR cur_currency IS
      SELECT h.currency_code
        FROM csh_payment_requisition_hds h, csh_payment_req_accounts_tmp t
       WHERE h.payment_requisition_header_id = t.payment_req_header_id
         AND t.session_id = p_session_id
       GROUP BY h.currency_code;
  
    v_company_currency_code      VARCHAR2(30);
    v_default_exchange_rate_type VARCHAR2(30);
    v_period_name                VARCHAR(30);
    v_journal_date               DATE;
    v_exchange_rate              NUMBER;
    v_exchange_rate_quotation    gld_exchange_rates.exchange_rate_quotation%TYPE;
  BEGIN
  
    del_csh_pmt_req_currency_tmp(p_session_id);
  
    FOR c_currency IN cur_currency LOOP
      v_company_currency_code := gld_common_pkg.get_company_currency_code(p_company_id => p_company_id);
      v_period_name           := gld_common_pkg.get_gld_period_name(p_company_id => p_company_id,
                                                                    p_date       => SYSDATE);
    
      --当sysdate的期间取不到时,取打开期间的最后一天
      IF v_period_name IS NULL THEN
        BEGIN
          SELECT MAX(t.end_date)
            INTO v_journal_date
            FROM gld_period_open_v t, gld_set_of_books v
           WHERE t.period_set_code = v.period_set_code
             AND v.set_of_books_id =
                 gld_common_pkg.get_set_of_books_id(p_company_id)
             AND t.adjustment_flag = 'N'
             AND t.period_status_code = 'O'
             AND t.company_id = p_company_id;
          v_period_name := gld_common_pkg.get_gld_period_name(p_company_id => p_company_id,
                                                              p_date       => v_journal_date);
        
        EXCEPTION
          WHEN no_data_found THEN
            NULL;
        END;
      ELSE
        v_journal_date := trunc(SYSDATE);
      END IF;
    
      IF c_currency.currency_code <> v_company_currency_code THEN
        IF v_period_name IS NOT NULL THEN
          v_default_exchange_rate_type := sys_parameter_pkg.value(p_parameter_code => 'DEFAULT_EXCHANGE_RATE_TYPE',
                                                                  p_company_id     => p_company_id);
        
          BEGIN
            IF v_default_exchange_rate_type IS NOT NULL THEN
              gld_exchange_rate_pkg.get_exchange_rate(p_company_id              => p_company_id,
                                                      p_from_currency           => v_company_currency_code,
                                                      p_to_currency             => c_currency.currency_code,
                                                      p_exchange_rate_type      => v_default_exchange_rate_type,
                                                      p_exchange_date           => v_journal_date,
                                                      p_exchange_period_name    => v_period_name,
                                                      p_who_id                  => p_user_id,
                                                      p_exchange_rate           => v_exchange_rate,
                                                      p_exchange_rate_quotation => v_exchange_rate_quotation);
            END IF;
          EXCEPTION
            WHEN OTHERS THEN
              v_exchange_rate           := NULL;
              v_exchange_rate_quotation := NULL;
          END;
        
          INSERT INTO csh_pmt_req_currency_tmp
            (session_id,
             currency_code,
             exchange_rate_type,
             exchange_rate,
             exchange_rate_quotation,
             creation_date)
          VALUES
            (p_session_id,
             c_currency.currency_code,
             v_default_exchange_rate_type,
             v_exchange_rate,
             v_exchange_rate_quotation,
             SYSDATE);
        ELSE
          INSERT INTO csh_pmt_req_currency_tmp
            (session_id, currency_code, creation_date)
          VALUES
            (p_session_id, c_currency.currency_code, SYSDATE);
        END IF;
      
      ELSE
        INSERT INTO csh_pmt_req_currency_tmp
          (session_id, currency_code, creation_date, exchange_rate)
        VALUES
          (p_session_id, c_currency.currency_code, SYSDATE, 1);
      END IF;
    
    END LOOP;
  
  END create_currency_code_tmp;

  PROCEDURE update_currency_code_tmp(p_session_id              NUMBER,
                                     p_currency_code           VARCHAR2,
                                     p_exchange_rate_type      VARCHAR2,
                                     p_exchange_rate           NUMBER,
                                     p_exchange_rate_quotation VARCHAR2) IS
  BEGIN
    UPDATE csh_pmt_req_currency_tmp t
       SET t.exchange_rate_type      = p_exchange_rate_type,
           t.exchange_rate           = p_exchange_rate,
           t.exchange_rate_quotation = p_exchange_rate_quotation
     WHERE t.session_id = p_session_id
       AND t.currency_code = p_currency_code;
  END update_currency_code_tmp;

  FUNCTION get_functional_amount(p_currency_code           VARCHAR2,
                                 p_standard_currency       VARCHAR2,
                                 p_amount                  NUMBER,
                                 p_session_id              NUMBER,
                                 p_company_id              NUMBER,
                                 p_exchange_rate_type      OUT VARCHAR2,
                                 p_exchange_rate_quotation OUT VARCHAR2,
                                 p_exchange_rate           OUT NUMBER)
    RETURN NUMBER IS
    v_amount                  NUMBER;
    v_exchange_rate_quotation csh_pmt_req_currency_tmp.exchange_rate_quotation%TYPE;
    v_exchange_rate           csh_pmt_req_currency_tmp.exchange_rate%TYPE;
    v_exchange_rate_type      csh_pmt_req_currency_tmp.exchange_rate_type%TYPE;
  BEGIN
    v_amount := p_amount;
  
    SELECT t.exchange_rate_quotation, t.exchange_rate, t.exchange_rate_type
      INTO v_exchange_rate_quotation, v_exchange_rate, v_exchange_rate_type
      FROM csh_pmt_req_currency_tmp t
     WHERE t.currency_code = p_currency_code
       AND t.session_id = p_session_id;
  
    IF p_currency_code = p_standard_currency THEN
      v_exchange_rate      := 1;
      v_exchange_rate_type := NULL;
      v_amount             := p_amount;
    ELSE
      v_amount := gld_exchange_rate_pkg.get_currency_exchange(p_amount                  => p_amount,
                                                              p_exchange_rate           => v_exchange_rate,
                                                              p_exchange_rate_quotation => v_exchange_rate_quotation);
    END IF;
  
    v_amount := fnd_format_mask_pkg.get_gld_amount(p_standard_currency,
                                                   v_amount,
                                                   gld_common_pkg.get_set_of_books_id(p_company_id));
  
    p_exchange_rate_type      := v_exchange_rate_type;
    p_exchange_rate           := v_exchange_rate;
    p_exchange_rate_quotation := v_exchange_rate_quotation;
    RETURN v_amount;
  
  END get_functional_amount;

  PROCEDURE ins_csh_payment_req_accounts(p_payment_req_line_id      NUMBER,
                                         p_je_line_id               NUMBER,
                                         p_description              VARCHAR2,
                                         p_journal_date             DATE,
                                         p_period_name              VARCHAR2,
                                         p_company_id               NUMBER,
                                         p_responsibility_center_id NUMBER,
                                         p_account_id               NUMBER,
                                         p_currency_code            VARCHAR2,
                                         p_exchange_rate_type       VARCHAR2,
                                         p_exchange_rate_quotation  VARCHAR2,
                                         p_exchange_rate            NUMBER,
                                         p_entered_amount_dr        NUMBER,
                                         p_entered_amount_cr        NUMBER,
                                         p_functional_amount_dr     NUMBER,
                                         p_functional_amount_cr     NUMBER,
                                         p_usage_code               VARCHAR2) IS
  BEGIN
    INSERT INTO csh_payment_req_accounts
      (payment_req_line_id,
       je_line_id,
       description,
       journal_date,
       period_name,
       cancel_flag,
       company_id,
       responsibility_center_id,
       account_id,
       currency_code,
       exchange_rate_type,
       exchange_rate_quotation,
       exchange_rate,
       entered_amount_dr,
       entered_amount_cr,
       functional_amount_dr,
       functional_amount_cr,
       interface_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       usage_code)
    VALUES
      (p_payment_req_line_id,
       p_je_line_id,
       p_description,
       p_journal_date,
       p_period_name,
       'N', --p_cancel_flag,
       p_company_id,
       p_responsibility_center_id,
       p_account_id,
       p_currency_code,
       p_exchange_rate_type,
       p_exchange_rate_quotation,
       p_exchange_rate,
       p_entered_amount_dr,
       p_entered_amount_cr,
       p_functional_amount_dr,
       p_functional_amount_cr,
       'N', --interface_flag,
       g_user_id,
       SYSDATE,
       g_user_id,
       SYSDATE,
       p_usage_code);
  
    evt_event_core_pkg.fire_event(p_event_name  => 'CSH_PMT_REQ_CREATE_ACCOUNTS',
                                  p_event_param => p_je_line_id,
                                  p_created_by  => g_user_id);
  
  END;

  FUNCTION execute_csh_pmt_req_account(p_pmt_req_header_id NUMBER,
                                       p_journal_date      DATE,
                                       p_session_id        NUMBER,
                                       p_period_name       VARCHAR2)
    RETURN VARCHAR2 IS
    CURSOR cur_line IS
      SELECT l.*,
             h.payment_req_type_id,
             h.employee_id,
             h.description h_desc,
             h.currency_code,
             h.requisition_number, --add by lyh 2017.8.5
             h.unit_id,
             (SELECT DISTINCT t.partner_type_id
                FROM csh_partner_v t
               WHERE t.partner_category = l.partner_category
                 AND t.company_id = l.company_id
                 AND t.partner_id = l.partner_id) partner_type_id
        FROM csh_payment_requisition_lns l, csh_payment_requisition_hds h
       WHERE l.payment_requisition_header_id = p_pmt_req_header_id
         AND l.payment_requisition_header_id =
             h.payment_requisition_header_id;
  
    v_csh_pmt_req     cur_line%ROWTYPE;
    v_csh_pmt_req_acc csh_payment_req_accounts%ROWTYPE;
  
    v_exchange_rate      csh_pmt_req_currency_tmp.exchange_rate%TYPE;
    v_exchange_rate_type csh_pmt_req_currency_tmp.exchange_rate_type%TYPE;
    v_standard_currency  VARCHAR2(30); --本位币
  
    v_requisition_number csh_payment_requisition_hds.requisition_number%TYPE;
  
    v_account_id               gld_accounts.account_id%TYPE;
    v_responsibility_center_id csh_payment_req_accounts.responsibility_center_id%TYPE;
  
    v_employee_name  VARCHAR2(50);
    v_req_items_name VARCHAR2(50);
  BEGIN
    v_csh_pmt_req_acc.journal_date := p_journal_date;
    v_csh_pmt_req_acc.period_name  := p_period_name;
  
    OPEN cur_line;
    LOOP
      FETCH cur_line
        INTO v_csh_pmt_req;
      EXIT WHEN cur_line%NOTFOUND;
      DELETE FROM csh_payment_req_accounts t
       WHERE t.payment_req_line_id =
             v_csh_pmt_req.payment_requisition_line_id;
    
      g_payment_req_line_id        := v_csh_pmt_req.payment_requisition_line_id;
      v_csh_pmt_req_acc.company_id := v_csh_pmt_req.company_id;
      v_requisition_number         := v_csh_pmt_req.requisition_number;
      v_standard_currency          := gld_common_pkg.get_company_currency_code(v_csh_pmt_req.company_id);
      ----------------借方 -------------
      -- 摘要 取报销单头说明
    
      SELECT e.name
        INTO v_employee_name
        FROM exp_employees e
       WHERE e.employee_id = v_csh_pmt_req.employee_id;
    
      SELECT t.description
        INTO v_req_items_name
        FROM csh_pay_req_types_vl t
       WHERE t.type_id = v_csh_pmt_req.payment_req_type_id;
    
      v_csh_pmt_req_acc.description := v_employee_name || '借支【' ||
                                       v_req_items_name || '】';
    
      acc_build_payment_req_pkg.set_process_id(p_company_id => v_csh_pmt_req.company_id,
                                               p_user_id    => g_user_id);
      acc_build_payment_req_pkg.create_mapping_conditions(p_partner_category      => v_csh_pmt_req.partner_category,
                                                          p_partner_id            => v_csh_pmt_req.partner_id,
                                                          p_csh_transaction_class => v_csh_pmt_req.csh_transaction_class_code,
                                                          p_partner_type_id       => v_csh_pmt_req.partner_type_id);
      v_csh_pmt_req_acc.account_id := acc_build_payment_req_pkg.get_account;
      IF v_csh_pmt_req_acc.account_id = -1 THEN
        CLOSE cur_line;
        RETURN 'CSH5070_GET_PAYMENT_REQUISITION_ERROR';
      END IF;
    
      --取默认责任中心
      --add by liyuhang 2017.06.02
      --部门科目需要搭配成本中心，成本中心取借款单头上的部门对应的成本中心
      /* BEGIN
        SELECT g.account_id
          INTO v_account_id
          FROM gld_accounts_vl g
         WHERE g.account_id = v_csh_pmt_req_acc.account_id
           AND g.description IN
               (SELECT sc.code_value_name
                  FROM sys_codes s, sys_code_values_vl sc
                 WHERE s.code_id = sc.code_id
                   AND s.code = 'WLZQ_PAY_RESPONSIBILITY');
      EXCEPTION
        WHEN no_data_found THEN
          v_csh_pmt_req_acc.responsibility_center_id := gld_common_pkg.get_default_resp_center_id(v_csh_pmt_req.company_id);
      END;
      IF v_account_id IS NOT NULL THEN
        SELECT e.responsibility_center_id
          INTO v_responsibility_center_id
          FROM exp_org_unit e
         WHERE e.unit_id = v_csh_pmt_req.unit_id;
        v_csh_pmt_req_acc.responsibility_center_id := v_responsibility_center_id;
      END IF;
      IF v_csh_pmt_req_acc.responsibility_center_id IS NULL THEN
        CLOSE cur_line;
        RETURN 'EXP5140_RESP_CENTER_ERROR';
      END IF;*/
    
      SELECT e.responsibility_center_id
        INTO v_responsibility_center_id
        FROM exp_org_unit e
       WHERE e.unit_id = v_csh_pmt_req.unit_id;
    
      --取默认责任中心
      v_csh_pmt_req_acc.responsibility_center_id := gld_common_pkg.get_default_resp_center_id(v_csh_pmt_req.company_id);
      --v_csh_pmt_req_acc.responsibility_center_id := v_responsibility_center_id;
      IF v_csh_pmt_req_acc.responsibility_center_id IS NULL THEN
        CLOSE cur_line;
        RETURN 'EXP5140_RESP_CENTER_ERROR';
      END IF;
    
      v_csh_pmt_req_acc.entered_amount_dr    := v_csh_pmt_req.amount;
      v_csh_pmt_req_acc.functional_amount_dr := get_functional_amount(p_currency_code           => v_csh_pmt_req.currency_code,
                                                                      p_amount                  => v_csh_pmt_req_acc.entered_amount_dr,
                                                                      p_session_id              => p_session_id,
                                                                      p_company_id              => v_csh_pmt_req.company_id,
                                                                      p_exchange_rate_type      => v_exchange_rate_type,
                                                                      p_exchange_rate_quotation => v_csh_pmt_req_acc.exchange_rate_quotation,
                                                                      p_exchange_rate           => v_exchange_rate,
                                                                      p_standard_currency       => v_standard_currency);
    
      v_csh_pmt_req_acc.exchange_rate_type := v_exchange_rate_type;
      v_csh_pmt_req_acc.exchange_rate      := v_exchange_rate;
      v_csh_pmt_req_acc.currency_code      := v_csh_pmt_req.currency_code;
      v_csh_pmt_req_acc.je_line_id         := get_je_line_id;
    
      ins_csh_payment_req_accounts(p_payment_req_line_id      => v_csh_pmt_req.payment_requisition_line_id,
                                   p_je_line_id               => v_csh_pmt_req_acc.je_line_id,
                                   p_description              => v_csh_pmt_req_acc.description,
                                   p_journal_date             => v_csh_pmt_req_acc.journal_date,
                                   p_period_name              => v_csh_pmt_req_acc.period_name,
                                   p_company_id               => v_csh_pmt_req_acc.company_id,
                                   p_responsibility_center_id => v_csh_pmt_req_acc.responsibility_center_id,
                                   p_account_id               => v_csh_pmt_req_acc.account_id,
                                   p_currency_code            => v_csh_pmt_req_acc.currency_code,
                                   p_exchange_rate_type       => v_csh_pmt_req_acc.exchange_rate_type,
                                   p_exchange_rate_quotation  => v_csh_pmt_req_acc.exchange_rate_quotation,
                                   p_exchange_rate            => v_csh_pmt_req_acc.exchange_rate,
                                   p_entered_amount_dr        => v_csh_pmt_req_acc.entered_amount_dr,
                                   p_entered_amount_cr        => '',
                                   p_functional_amount_dr     => v_csh_pmt_req_acc.functional_amount_dr,
                                   p_functional_amount_cr     => '',
                                   p_usage_code               => 'PAYMENT_REQUISITION');
    
      -----------贷方---------
      --v_csh_pmt_req_acc.description := v_csh_pmt_req.description;
    
      acc_build_payment_req_clr_pkg.set_process_id(v_csh_pmt_req.company_id,
                                                   g_user_id);
      acc_build_payment_req_clr_pkg.create_mapping_conditions(p_partner_category      => v_csh_pmt_req.partner_category,
                                                              p_partner_id            => v_csh_pmt_req.partner_id,
                                                              p_csh_transaction_class => v_csh_pmt_req.csh_transaction_class_code,
                                                              p_partner_type_id       => v_csh_pmt_req.partner_type_id);
    
      v_csh_pmt_req_acc.account_id := acc_build_payment_req_clr_pkg.get_account;
      IF v_csh_pmt_req_acc.account_id = -1 THEN
        CLOSE cur_line;
        RETURN 'CSH5070_GET_PAYMENT_REQ_CLEARING_ERROR';
      END IF;
      v_csh_pmt_req_acc.responsibility_center_id := gld_common_pkg.get_default_resp_center_id(v_csh_pmt_req.company_id);
      IF v_csh_pmt_req_acc.responsibility_center_id IS NULL THEN
        CLOSE cur_line;
        RETURN 'EXP5140_RESP_CENTER_ERROR';
      END IF;
    
      v_csh_pmt_req_acc.entered_amount_cr := v_csh_pmt_req.amount;
    
      v_csh_pmt_req_acc.functional_amount_cr := get_functional_amount(p_currency_code           => v_csh_pmt_req.currency_code,
                                                                      p_amount                  => v_csh_pmt_req_acc.entered_amount_cr,
                                                                      p_session_id              => p_session_id,
                                                                      p_company_id              => v_csh_pmt_req_acc.company_id,
                                                                      p_exchange_rate_type      => v_exchange_rate_type,
                                                                      p_exchange_rate_quotation => v_csh_pmt_req_acc.exchange_rate_quotation,
                                                                      p_exchange_rate           => v_exchange_rate,
                                                                      p_standard_currency       => v_standard_currency);
    
      v_csh_pmt_req_acc.exchange_rate_type := v_exchange_rate_type;
      v_csh_pmt_req_acc.exchange_rate      := v_exchange_rate;
      v_csh_pmt_req_acc.currency_code      := v_csh_pmt_req.currency_code;
      v_csh_pmt_req_acc.je_line_id         := get_je_line_id;
      --add by lyh 2017.8.5
      --摘要取单据编号
      --v_csh_pmt_req_acc.description := v_requisition_number;
      ins_csh_payment_req_accounts(p_payment_req_line_id      => v_csh_pmt_req.payment_requisition_line_id,
                                   p_je_line_id               => v_csh_pmt_req_acc.je_line_id,
                                   p_description              => v_csh_pmt_req_acc.description,
                                   p_journal_date             => v_csh_pmt_req_acc.journal_date,
                                   p_period_name              => v_csh_pmt_req_acc.period_name,
                                   p_company_id               => v_csh_pmt_req_acc.company_id,
                                   p_responsibility_center_id => v_csh_pmt_req_acc.responsibility_center_id,
                                   p_account_id               => v_csh_pmt_req_acc.account_id,
                                   p_currency_code            => v_csh_pmt_req_acc.currency_code,
                                   p_exchange_rate_type       => v_csh_pmt_req_acc.exchange_rate_type,
                                   p_exchange_rate_quotation  => v_csh_pmt_req_acc.exchange_rate_quotation,
                                   p_exchange_rate            => v_csh_pmt_req_acc.exchange_rate,
                                   p_entered_amount_dr        => '',
                                   p_entered_amount_cr        => v_csh_pmt_req_acc.entered_amount_cr,
                                   p_functional_amount_dr     => '',
                                   p_functional_amount_cr     => v_csh_pmt_req_acc.functional_amount_cr,
                                   p_usage_code               => 'PAYMENT_REQUISITION_CLEARING');
    
    END LOOP;
    CLOSE cur_line;
  
    UPDATE csh_payment_requisition_hds t
       SET t.je_creation_status = 'SUCCESS',
           t.last_updated_by    = g_user_id,
           t.last_update_date   = SYSDATE
     WHERE t.payment_requisition_header_id = p_pmt_req_header_id;
  
    RETURN NULL;
  END execute_csh_pmt_req_account;

  --开始创建借款申请单凭证
  PROCEDURE create_csh_pmt_req_account(p_session_id   NUMBER,
                                       p_journal_date DATE,
                                       p_company_id   NUMBER,
                                       p_user_id      NUMBER) IS
    v_count    NUMBER;
    v_err_code sys_messages.message_code%TYPE;
  
    v_period_name        csh_payment_req_accounts.period_name%TYPE;
    v_pmt_req_header_id  csh_payment_requisition_hds.payment_requisition_header_id%TYPE;
    v_requisition_number csh_payment_requisition_hds.requisition_number%TYPE;
  
    CURSOR cur_headers IS
      SELECT h.payment_requisition_header_id, h.requisition_number
        FROM csh_payment_requisition_hds h, csh_payment_req_accounts_tmp t
       WHERE t.payment_req_header_id = h.payment_requisition_header_id
         AND t.session_id = p_session_id
         AND h.status =
             csh_payment_requisition_pkg.c_req_hd_status_approved --已全部审批
         AND (h.audit_flag IS NULL OR h.audit_flag IN ('N', 'R')) --未审核
         AND h.closed_date IS NULL --未关闭
      ;
  
    e_need_exchange_rate    EXCEPTION;
    e_period_name           EXCEPTION;
    e_create_accounts_error EXCEPTION;
  
    e_lock_table EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_lock_table, -54);
  BEGIN
    g_session_id := p_session_id;
    g_user_id    := p_user_id;
    delete_error_log;
  
    SELECT COUNT(1)
      INTO v_count
      FROM csh_pmt_req_currency_tmp t
     WHERE (t.exchange_rate IS NULL OR t.exchange_rate_quotation IS NULL)
       AND t.session_id = p_session_id
       AND t.currency_code <>
           gld_common_pkg.get_company_currency_code(p_company_id);
    IF v_count > 0 THEN
      RAISE e_need_exchange_rate;
    END IF;
  
    v_period_name := gld_common_pkg.get_gld_period_name(p_company_id => p_company_id,
                                                        p_date       => p_journal_date);
    IF v_period_name IS NULL THEN
      RAISE e_period_name;
    END IF;
  
    OPEN cur_headers;
    LOOP
      FETCH cur_headers
        INTO v_pmt_req_header_id, v_requisition_number;
      EXIT WHEN cur_headers%NOTFOUND;
    
      --删除之前生成的凭证
      DELETE FROM csh_payment_req_accounts a
       WHERE a.payment_req_line_id IN
             (SELECT l.payment_requisition_line_id
                FROM csh_payment_requisition_lns l
               WHERE l.payment_requisition_header_id = v_pmt_req_header_id);
    
      g_requisition_number := v_requisition_number;
    
      BEGIN
        --锁定记录
        SELECT payment_requisition_header_id
          INTO v_pmt_req_header_id
          FROM csh_payment_requisition_hds h
         WHERE h.payment_requisition_header_id = v_pmt_req_header_id
           AND h.status =
               csh_payment_requisition_pkg.c_req_hd_status_approved
           AND (h.audit_flag IS NULL OR h.audit_flag IN ('N', 'R'))
           FOR UPDATE NOWAIT;
      
        v_err_code := execute_csh_pmt_req_account(p_pmt_req_header_id => v_pmt_req_header_id,
                                                  p_journal_date      => p_journal_date,
                                                  p_session_id        => p_session_id,
                                                  p_period_name       => v_period_name);
      
        IF v_err_code IS NOT NULL THEN
          error_log(sys_message_pkg.get_string(v_err_code));
          RAISE e_create_accounts_error;
        END IF;
      
      EXCEPTION
        WHEN no_data_found THEN
          NULL;
        WHEN e_lock_table THEN
          error_log(sys_message_pkg.get_string('CSH5070_CONCURRENT_ERROR'));
      END;
    
    END LOOP;
    CLOSE cur_headers;
  
    del_csh_pmt_req_accounts_tmp(p_session_id);
    del_csh_pmt_req_currency_tmp(p_session_id);
  
  EXCEPTION
    WHEN e_period_name THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5070_JOURNAL_DATE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'create_expense_report_account');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_create_accounts_error THEN
      IF cur_headers%ISOPEN THEN
        CLOSE cur_headers;
      END IF;
      /*del_csh_pmt_req_accounts_tmp(p_session_id);
      del_csh_pmt_req_currency_tmp(p_session_id);*/
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_err_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'create_expense_report_account');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_need_exchange_rate THEN
      /*del_csh_pmt_req_accounts_tmp(p_session_id);
      del_csh_pmt_req_currency_tmp(p_session_id);*/
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5140_NEED_EXCHANGE_RATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'create_expense_report_account');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      IF cur_headers%ISOPEN THEN
        CLOSE cur_headers;
      END IF;
      /*del_csh_pmt_req_accounts_tmp(p_session_id);
      del_csh_pmt_req_currency_tmp(p_session_id);*/
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_payment_req_audit_pkg',
                                                     p_procedure_function_name => 'create_expense_report_account');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  FUNCTION reject_csh_pmy_req_check(p_pmt_req_header_id NUMBER,
                                    p_user_id           NUMBER) RETURN NUMBER IS
    v_company_id      NUMBER;
    v_submit_flag     VARCHAR2(1);
    v_exists          NUMBER;
    v_ref_document_id NUMBER;
  BEGIN
    SELECT h.company_id
      INTO v_company_id
      FROM csh_payment_requisition_hds h
     WHERE h.payment_requisition_header_id = p_pmt_req_header_id
       AND h.source_type = 'EXP_REQUISITION';
  
    --判断系统参数【借款申请根据费用申请审批】是否启用
    SELECT nvl(sys_parameter_pkg.value('PAYMENT_REQUISITION_APPROVED_WITH_REQ',
                                       '',
                                       '',
                                       v_company_id),
               'N')
      INTO v_submit_flag
      FROM dual;
  
    IF v_submit_flag = 'Y' THEN
      FOR cur_req IN (SELECT l.ref_document_id
                        FROM csh_payment_requisition_lns l
                       WHERE l.payment_requisition_header_id =
                             p_pmt_req_header_id) LOOP
        v_ref_document_id := cur_req.ref_document_id;
        BEGIN
          --判断申请单是否已经核销
          SELECT 1
            INTO v_exists
            FROM exp_requisition_headers rh,
                 exp_requisition_lines   rl,
                 exp_requisition_dists   rd
           WHERE rh.exp_requisition_header_id = cur_req.ref_document_id
             AND rh.exp_requisition_header_id =
                 rl.exp_requisition_header_id
             AND rl.exp_requisition_line_id = rd.exp_requisition_line_id
             AND nvl(rd.released_status, 'N') <> 'N'
             AND rownum = 1;
          sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5070_REF_EXP_REQUISITION_RELEASED',
                                                          p_created_by              => p_user_id,
                                                          p_package_name            => 'csh_payment_req_audit_pkg',
                                                          p_procedure_function_name => 'reject_csh_pmy_req_check');
          raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                  sys_raise_app_error_pkg.g_err_line_id);
        EXCEPTION
          WHEN no_data_found THEN
            BEGIN
              --关联的申请单已经关闭
              SELECT 1
                INTO v_exists
                FROM exp_requisition_headers rh,
                     exp_requisition_lines   rl,
                     exp_requisition_dists   rd
               WHERE rh.exp_requisition_header_id = cur_req.ref_document_id
                 AND rh.exp_requisition_header_id =
                     rl.exp_requisition_header_id
                 AND rl.exp_requisition_line_id =
                     rd.exp_requisition_line_id
                 AND rd.close_flag = 'Y'
                 AND rownum = 1;
              sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5070_REF_EXP_REQUISITION_CLOSED',
                                                              p_created_by              => p_user_id,
                                                              p_package_name            => 'csh_payment_req_audit_pkg',
                                                              p_procedure_function_name => 'reject_csh_pmy_req_check');
              raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                      sys_raise_app_error_pkg.g_err_line_id);
            EXCEPTION
              WHEN no_data_found THEN
                NULL;
            END;
        END;
      END LOOP;
    END IF;
  
    --返回对应的申请单
    RETURN v_ref_document_id;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN v_ref_document_id;
  END;

  --设置借款申请单状态为拒绝
  PROCEDURE set_csh_pmt_req_reject(p_pmt_req_header_id NUMBER,
                                   p_user_id           NUMBER,
                                   p_description       VARCHAR2) IS
  BEGIN
    --拒绝，修改申请单审核
    UPDATE csh_payment_requisition_hds v
       SET v.status             = csh_payment_requisition_pkg.c_req_hd_status_rejected,
           v.je_creation_status = 'N',
           v.audit_flag         = 'N',
           v.last_updated_by    = p_user_id,
           v.last_update_date   = SYSDATE
     WHERE v.payment_requisition_header_id = p_pmt_req_header_id;
  
    --提交历史
    exp_document_history_pkg.insert_exp_document_histories(p_document_type  => csh_payment_requisition_pkg.c_payment_requisition,
                                                           p_document_id    => p_pmt_req_header_id,
                                                           p_operation_code => exp_document_history_pkg.c_audit_reject,
                                                           p_user_id        => p_user_id,
                                                           p_operation_time => SYSDATE,
                                                           p_description    => p_description);
  END;

  --拒绝申请单
  PROCEDURE rejecte_exp_requisition(p_exp_req_header_id NUMBER,
                                    p_user_id           NUMBER) IS
  BEGIN
    UPDATE bgt_budget_reserves r
       SET r.status           = 'N',
           r.last_update_date = SYSDATE,
           r.last_updated_by  = p_user_id
     WHERE r.business_type = 'EXP_REQUISITION'
       AND r.document_id = p_exp_req_header_id;
  
    UPDATE exp_requisition_headers h
       SET h.requisition_status = exp_requisition_pkg.c_req_hd_status_rejected,
           h.last_updated_by    = p_user_id,
           h.last_update_date   = SYSDATE
     WHERE h.exp_requisition_header_id = p_exp_req_header_id;
  
    UPDATE exp_requisition_lines l
       SET l.requisition_status = exp_requisition_pkg.c_req_hd_status_rejected,
           l.last_updated_by    = p_user_id,
           l.last_update_date   = SYSDATE
     WHERE l.exp_requisition_header_id = p_exp_req_header_id;
  
    UPDATE exp_requisition_dists d
       SET d.requisition_status = exp_requisition_pkg.c_req_hd_status_rejected,
           d.last_updated_by    = p_user_id,
           d.last_update_date   = SYSDATE
     WHERE d.exp_requisition_line_id IN
           (SELECT l.exp_requisition_line_id
              FROM exp_requisition_lines l
             WHERE l.exp_requisition_header_id = p_exp_req_header_id);
  END;

  --审核拒绝
  PROCEDURE audit_reject_csh_pmt_req(p_pmt_req_header_id NUMBER,
                                     p_user_id           NUMBER,
                                     p_description       VARCHAR2) IS
    v_audit_flag        csh_payment_requisition_hds.audit_flag%TYPE;
    v_ref_req_header_id NUMBER;
  
    e_lock_table EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_lock_table, -54);
  BEGIN
  
    SELECT t.audit_flag
      INTO v_audit_flag
      FROM csh_payment_requisition_hds t
     WHERE t.payment_requisition_header_id = p_pmt_req_header_id
       AND t.status = csh_payment_requisition_pkg.c_req_hd_status_approved
       AND nvl(t.audit_flag, 'N') IN ('N', 'R')
       FOR UPDATE NOWAIT;
  
    IF v_audit_flag = 'R' THEN
      --复核拒绝，修改单据的审核状态
      UPDATE csh_payment_requisition_hds h
         SET h.audit_flag       = 'N',
             h.last_updated_by  = p_user_id,
             h.last_update_date = SYSDATE
       WHERE h.payment_requisition_header_id = p_pmt_req_header_id;
      --创建报销单历史
      exp_document_history_pkg.insert_exp_document_histories(p_document_type  => csh_payment_requisition_pkg.c_payment_requisition,
                                                             p_document_id    => p_pmt_req_header_id,
                                                             p_operation_code => exp_document_history_pkg.c_recheck_reject, --'REAUDIT_REJECT',
                                                             p_user_id        => p_user_id,
                                                             p_operation_time => SYSDATE,
                                                             p_description    => p_description);
    ELSE
      --审核拒绝校验
      v_ref_req_header_id := reject_csh_pmy_req_check(p_pmt_req_header_id => p_pmt_req_header_id,
                                                      p_user_id           => p_user_id);
    
      IF v_ref_req_header_id IS NOT NULL THEN
        rejecte_exp_requisition(p_exp_req_header_id => v_ref_req_header_id,
                                p_user_id           => p_user_id);
        set_csh_pmt_req_reject(p_pmt_req_header_id => p_pmt_req_header_id,
                               p_user_id           => p_user_id,
                               p_description       => p_description);
      ELSE
        set_csh_pmt_req_reject(p_pmt_req_header_id => p_pmt_req_header_id,
                               p_user_id           => p_user_id,
                               p_description       => p_description);
      END IF;
    
      DELETE FROM csh_payment_req_accounts a
       WHERE a.payment_req_line_id IN
             (SELECT t.payment_requisition_line_id
                FROM csh_payment_requisition_lns t
               WHERE t.payment_requisition_header_id = p_pmt_req_header_id);
    
      --创建报销单历史
      exp_document_history_pkg.insert_exp_document_histories(p_document_type  => csh_payment_requisition_pkg.c_payment_requisition,
                                                             p_document_id    => p_pmt_req_header_id,
                                                             p_operation_code => exp_document_history_pkg.c_audit_reject, --'AUDIT_REJECT',
                                                             p_user_id        => p_user_id,
                                                             p_operation_time => SYSDATE,
                                                             p_description    => p_description);
    END IF;
  
  EXCEPTION
    WHEN no_data_found THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5070_AUDIT_CHECK_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'audit_reject_csh_pmt_req');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_lock_table THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5070_CONCURRENT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'audit_reject_csh_pmt_req');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  --借代平衡校验
  PROCEDURE csh_pmt_req_balance_check(p_pmt_req_header_id NUMBER,
                                      p_user_id           NUMBER) IS
    CURSOR cur_pmt_req IS
      SELECT d.payment_requisition_line_id, e.company_id
        FROM csh_payment_requisition_lns d, csh_payment_req_accounts e
       WHERE d.payment_requisition_header_id = p_pmt_req_header_id
         AND d.payment_requisition_line_id = e.payment_req_line_id
       GROUP BY d.payment_requisition_line_id, e.company_id;
    v_pmt_req cur_pmt_req%ROWTYPE;
  
    v_entered_amount    NUMBER;
    v_functional_amount NUMBER;
    e_amount_balance_error EXCEPTION;
  BEGIN
    OPEN cur_pmt_req;
    LOOP
      FETCH cur_pmt_req
        INTO v_pmt_req;
      EXIT WHEN cur_pmt_req%NOTFOUND;
    
      SELECT SUM(a.entered_amount_dr) - SUM(a.entered_amount_cr),
             SUM(a.functional_amount_dr) - SUM(a.functional_amount_cr)
        INTO v_entered_amount, v_functional_amount
        FROM csh_payment_req_accounts a
       WHERE a. payment_req_line_id = v_pmt_req.payment_requisition_line_id
         AND a.company_id = v_pmt_req.company_id;
    
      IF v_entered_amount <> 0 OR v_functional_amount <> 0 THEN
        RAISE e_amount_balance_error;
      END IF;
    
    END LOOP;
    CLOSE cur_pmt_req;
  
  EXCEPTION
    WHEN e_amount_balance_error THEN
      IF cur_pmt_req%ISOPEN THEN
        CLOSE cur_pmt_req;
      END IF;
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP_REP_ACCOUNT_AMOUNT_BALANCE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'csh_pmt_req_balance_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  -- 审核
  PROCEDURE audit_csh_pmt_req(p_pmt_req_header_id NUMBER,
                              p_user_id           NUMBER,
                              p_journal_date      varchar2,
                              p_audit_opinion     VARCHAR2 DEFAULT NULL) IS
    v_je_creation_status       csh_payment_requisition_hds.je_creation_status%TYPE;
    v_audit_date               csh_payment_requisition_hds.audit_date%TYPE := trunc(SYSDATE);
    v_period_name              gld_periods.period_name%TYPE;
    v_payment_req_recheck_flag VARCHAR2(30);
    v_concat_segments          VARCHAR2(2000);
    v_error_message            VARCHAR2(4000);
    v_company_id               number;
  
    e_ccid_error        EXCEPTION;
    e_je_creation_first EXCEPTION;
    e_lock_table        EXCEPTION;
    e_period_not_open   EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_lock_table, -54);
  BEGIN
    /*************************************************
    -- Author  : MOUSE
    -- Created : 2015/12/17 18:10:13
    -- Ver     : 1.1
    -- Purpose : 借款单审核节点，验证CCID
    **************************************************/
    FOR je_lines IN (SELECT a.*
                       FROM csh_payment_req_accounts    a,
                            csh_payment_requisition_lns l
                      WHERE a.payment_req_line_id =
                            l.payment_requisition_line_id
                        AND l.payment_requisition_header_id =
                            p_pmt_req_header_id) LOOP
    
      gl_log_pkg.log(p_log_text => 'ccid为:' || je_lines.account_segment1 || '.' ||
                                   je_lines.account_segment2 || '.' ||
                                   je_lines.account_segment3 || '.' ||
                                   je_lines.account_segment4 || '.' ||
                                   je_lines.account_segment5 || '.' ||
                                   je_lines.account_segment6 || '.' ||
                                   je_lines.account_segment7 || '.' ||
                                   je_lines.account_segment8 || '.' ||
                                   je_lines.account_segment9 || '.' ||
                                   je_lines.account_segment10 || '.' ||
                                   je_lines.account_segment11,
                     p_user_id  => -1);
    
      /*v_error_message := cux_gl_interface_pkg.validate_ccid(p_concat_segments => je_lines.account_segment1 || '.' ||
      je_lines.account_segment2 || '.' ||
      je_lines.account_segment3 || '.' ||
      je_lines.account_segment4 || '.' ||
      je_lines.account_segment5 || '.' ||
      je_lines.account_segment6 || '.' ||
      je_lines.account_segment7 || '.' ||
      je_lines.account_segment8 || '.' ||
      je_lines.account_segment9 || '.' ||
      je_lines.account_segment10 || '.' ||
      je_lines.account_segment11);*/
    
      IF v_error_message IS NOT NULL THEN
        RAISE e_ccid_error;
      END IF;
    END LOOP;
  
    v_payment_req_recheck_flag := nvl(sys_parameter_pkg.value(p_parameter_code => 'CSH_PAYMENT_REQUISITION_RECHECK'),
                                      'N');
  
    SELECT nvl(t.je_creation_status, 'N'), t.company_id
      INTO v_je_creation_status, v_company_id
      FROM csh_payment_requisition_hds t
     WHERE t.payment_requisition_header_id = p_pmt_req_header_id
       AND t.status = csh_payment_requisition_pkg.c_req_hd_status_approved
       AND nvl(t.audit_flag, 'N') = 'N'
       FOR UPDATE NOWAIT;
  
    IF v_je_creation_status != 'SUCCESS' THEN
      RAISE e_je_creation_first;
    END IF;
  
    if to_date(p_journal_date, 'yyyy-mm-dd') = trunc(sysdate) then
      v_audit_date := to_date(p_journal_date, 'yyyy-mm-dd');
    else
      v_audit_date := trunc(sysdate);
    end if;
  
    -- 期间
    v_period_name := gld_common_pkg.get_gld_period_name(p_company_id => v_company_id,
                                                        p_date       => v_audit_date);
    IF v_period_name IS NULL THEN
      RAISE e_period_not_open;
    END IF;
  
    --借代平衡校验
    csh_pmt_req_balance_check(p_pmt_req_header_id => p_pmt_req_header_id,
                              p_user_id           => p_user_id);
  
    IF v_payment_req_recheck_flag = 'N' THEN
      UPDATE csh_payment_requisition_hds t
         SET t.audit_flag       = 'Y',
             t.audit_date       = v_audit_date,
             t.last_updated_by  = p_user_id,
             t.last_update_date = SYSDATE
       WHERE t.payment_requisition_header_id = p_pmt_req_header_id;
    
      UPDATE csh_payment_req_accounts a
         SET a.interface_flag   = 'P',
             a.period_name      = v_period_name,
             a.journal_date     = v_audit_date,
             a.last_updated_by  = p_user_id,
             a.last_update_date = SYSDATE
       WHERE a.payment_req_line_id IN
             (SELECT l.payment_requisition_line_id
                FROM csh_payment_requisition_lns l
               WHERE l.payment_requisition_header_id = p_pmt_req_header_id);
    
      --报销单审核，触发事件
      exp_evt_pkg.fire_workflow_event(p_event_name       => 'CSH_PAYMENT_REQ_POST_AUDIT',
                                      p_document_id      => p_pmt_req_header_id,
                                      p_document_line_id => '',
                                      p_source_module    => csh_payment_requisition_pkg.c_payment_requisition,
                                      p_event_type       => 'CSH_PAYMENT_REQ_POST_AUDIT',
                                      p_user_id          => p_user_id);
    
      -- 凭证写来源单据编号
      UPDATE gl_account_entry gae
         SET gae.accounting_date = v_audit_date,
             gae.period_name     = v_period_name,
             gae.attribute12    =
             (SELECT cpr.requisition_number
                FROM csh_payment_requisition_hds cpr
               WHERE cpr.payment_requisition_header_id = p_pmt_req_header_id)
       WHERE gae.transaction_header_id = p_pmt_req_header_id
         AND gae.transaction_type = 'CSH_PMT_REQ';
    
    ELSIF v_payment_req_recheck_flag = 'Y' THEN
      UPDATE csh_payment_requisition_hds t
         SET t.audit_flag       = 'R',
             t.audit_date       = v_audit_date,
             t.last_updated_by  = p_user_id,
             t.last_update_date = SYSDATE
       WHERE t.payment_requisition_header_id = p_pmt_req_header_id;
    END IF;
  
    --审核历史
    exp_document_history_pkg.insert_exp_document_histories(p_document_type  => csh_payment_requisition_pkg.c_payment_requisition,
                                                           p_document_id    => p_pmt_req_header_id,
                                                           p_operation_code => exp_document_history_pkg.c_audit,
                                                           p_user_id        => p_user_id,
                                                           p_operation_time => SYSDATE,
                                                           p_description    => p_audit_opinion);
  
    commit;
  EXCEPTION
    WHEN e_ccid_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => v_error_message,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_payment_req_audit_pkg',
                                                     p_procedure_function_name => 'audit_csh_pmt_req');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_period_not_open THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5140_PERIOD_NOT_OPEN',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'audit_csh_pmt_req');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);                          
    WHEN no_data_found THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5070_AUDIT_CHECK_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'audit_csh_pmt_req');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_je_creation_first THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5140_JE_CREATION_FIRST',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'audit_csh_pmt_req');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_lock_table THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5070_CONCURRENT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'audit_csh_pmt_req');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_payment_req_audit_pkg',
                                                     p_procedure_function_name => 'audit_csh_pmt_req');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  --复核
  PROCEDURE audit_csh_pmt_req_recheck(p_pmt_req_header_id NUMBER,
                                      p_user_id           NUMBER,
                                      p_recheck_opinion   VARCHAR2 DEFAULT NULL) IS
    v_je_creation_status       csh_payment_requisition_hds.je_creation_status%TYPE;
    v_audit_date               csh_payment_requisition_hds.audit_date%TYPE := trunc(SYSDATE);
    v_payment_req_recheck_flag VARCHAR2(30);
    v_audit_flag               VARCHAR2(30);
  
    e_je_creation_first  EXCEPTION;
    e_lock_table         EXCEPTION;
    e_not_need_recheck   EXCEPTION;
    e_audit_status_error EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_lock_table, -54);
  BEGIN
    v_payment_req_recheck_flag := nvl(sys_parameter_pkg.value(p_parameter_code => 'CSH_PAYMENT_REQUISITION_RECHECK'),
                                      'N');
  
    IF v_payment_req_recheck_flag != 'Y' THEN
      RAISE e_not_need_recheck;
    END IF;
  
    SELECT nvl(t.je_creation_status, 'N')
      INTO v_je_creation_status
      FROM csh_payment_requisition_hds t
     WHERE t.payment_requisition_header_id = p_pmt_req_header_id
       AND t.status = csh_payment_requisition_pkg.c_req_hd_status_approved
       AND nvl(t.audit_flag, 'N') = 'R'
       FOR UPDATE NOWAIT;
  
    IF v_je_creation_status != 'SUCCESS' THEN
      RAISE e_je_creation_first;
    END IF;
  
    SELECT h.audit_flag
      INTO v_audit_flag
      FROM csh_payment_requisition_hds h
     WHERE h.payment_requisition_header_id = p_pmt_req_header_id;
  
    IF v_audit_flag != 'R' THEN
      RAISE e_audit_status_error;
    END IF;
  
    --借代平衡校验
    csh_pmt_req_balance_check(p_pmt_req_header_id => p_pmt_req_header_id,
                              p_user_id           => p_user_id);
  
    UPDATE csh_payment_requisition_hds t
       SET t.audit_flag       = 'Y',
           t.audit_date       = v_audit_date,
           t.last_updated_by  = p_user_id,
           t.last_update_date = SYSDATE
     WHERE t.payment_requisition_header_id = p_pmt_req_header_id;
  
    --万联证券暂挂凭证
    UPDATE csh_payment_req_accounts a
    -- SET a.interface_flag   = 'P',
       SET a.interface_flag   = 'G',
           a.last_updated_by  = p_user_id,
           a.last_update_date = SYSDATE
     WHERE a.payment_req_line_id IN
           (SELECT l.payment_requisition_line_id
              FROM csh_payment_requisition_lns l
             WHERE l.payment_requisition_header_id = p_pmt_req_header_id);
  
    --报销单审核，触发事件
    exp_evt_pkg.fire_workflow_event(p_event_name       => 'CSH_PAYMENT_REQ_POST_AUDIT',
                                    p_document_id      => p_pmt_req_header_id,
                                    p_document_line_id => '',
                                    p_source_module    => csh_payment_requisition_pkg.c_payment_requisition,
                                    p_event_type       => 'CSH_PAYMENT_REQ_POST_AUDIT',
                                    p_user_id          => p_user_id);
  
    -- 万联证券凭证写来源单据编号
    UPDATE gl_account_entry gae
       SET gae.attribute12 =
           (SELECT cpr.requisition_number
              FROM csh_payment_requisition_hds cpr
             WHERE cpr.payment_requisition_header_id = p_pmt_req_header_id)
     WHERE gae.transaction_header_id = p_pmt_req_header_id
       AND gae.transaction_type = 'CSH_PMT_REQ';
  
    --审核历史
    exp_document_history_pkg.insert_exp_document_histories(p_document_type  => csh_payment_requisition_pkg.c_payment_requisition,
                                                           p_document_id    => p_pmt_req_header_id,
                                                           p_operation_code => exp_document_history_pkg.c_recheck,
                                                           p_user_id        => p_user_id,
                                                           p_operation_time => SYSDATE,
                                                           p_description    => p_recheck_opinion);
  EXCEPTION
    WHEN e_audit_status_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '当前借款单不处于待复核状态，请确认单据状态!',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_payment_req_audit_pkg',
                                                     p_procedure_function_name => 'audit_csh_pmt_req_recheck');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_not_need_recheck THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '系统配置借款单无需符合，请联系管理员!',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_payment_req_audit_pkg',
                                                     p_procedure_function_name => 'audit_csh_pmt_req_recheck');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN no_data_found THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5070_AUDIT_CHECK_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'audit_csh_pmt_req_recheck');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_je_creation_first THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5140_JE_CREATION_FIRST',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'audit_csh_pmt_req_recheck');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_lock_table THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5070_CONCURRENT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'audit_csh_pmt_req_recheck');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_payment_req_audit_pkg',
                                                     p_procedure_function_name => 'audit_csh_pmt_req_recheck');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  PROCEDURE reverse_csh_payment_req_hds(p_old_csh_pmt_req_header_id NUMBER,
                                        p_new_csh_pmt_req_header_id NUMBER,
                                        p_requisition_number        VARCHAR2,
                                        p_user_id                   NUMBER,
                                        p_reverse_date              DATE) IS
  BEGIN
    INSERT INTO csh_payment_requisition_hds
      (payment_requisition_header_id,
       company_id,
       operation_unit_id,
       employee_id,
       requisition_number,
       requisition_date,
       payment_req_type_id,
       transaction_category,
       distribution_set_id,
       payment_method_id,
       partner_category,
       partner_id,
       amount,
       currency_code,
       requisition_payment_date,
       description,
       status,
       approval_date,
       approved_by,
       closed_date,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by,
       unit_id,
       position_id,
       source_type,
       audit_flag,
       reversed_flag,
       source_pmt_req_header_id,
       je_creation_status,
       audit_date)
      SELECT p_new_csh_pmt_req_header_id,
             company_id,
             operation_unit_id,
             employee_id,
             p_requisition_number, -- requisition_number,
             p_reverse_date, --requisition_date,
             payment_req_type_id,
             transaction_category,
             distribution_set_id,
             payment_method_id,
             partner_category,
             partner_id,
             -1 * amount,
             currency_code,
             '', --requisition_payment_date,
             description,
             status,
             approval_date,
             approved_by,
             closed_date,
             SYSDATE, --creation_date,
             p_user_id, --created_by,
             SYSDATE, --last_update_date,
             p_user_id, --last_updated_by,
             unit_id,
             position_id,
             source_type,
             audit_flag,
             'R', -- reversed_flag,
             p_old_csh_pmt_req_header_id, --source_pmt_req_header_id,
             je_creation_status,
             p_reverse_date --audit_date
        FROM csh_payment_requisition_hds a
       WHERE a.payment_requisition_header_id = p_old_csh_pmt_req_header_id;
  
    UPDATE csh_payment_requisition_hds t
       SET t.reversed_flag    = 'W',
           t.last_updated_by  = p_user_id,
           t.last_update_date = SYSDATE
     WHERE t.payment_requisition_header_id = p_old_csh_pmt_req_header_id;
  END;

  --反冲科目
  PROCEDURE reverse_csh_pmt_req_accounts(p_old_csh_pmt_req_line_id NUMBER,
                                         p_new_csh_pmt_req_line_id NUMBER,
                                         p_user_id                 NUMBER,
                                         p_reverse_date            DATE,
                                         p_period_name             VARCHAR2) IS
    CURSOR cur_accounts IS
      SELECT *
        FROM csh_payment_req_accounts a
       WHERE a.payment_req_line_id = p_old_csh_pmt_req_line_id
       ORDER BY a.je_line_id;
    v_pmt_req_acc csh_payment_req_accounts%ROWTYPE;
  BEGIN
    OPEN cur_accounts;
    LOOP
      FETCH cur_accounts
        INTO v_pmt_req_acc;
      EXIT WHEN cur_accounts%NOTFOUND;
      v_pmt_req_acc.created_by           := p_user_id;
      v_pmt_req_acc.creation_date        := SYSDATE;
      v_pmt_req_acc.last_updated_by      := p_user_id;
      v_pmt_req_acc.last_update_date     := SYSDATE;
      v_pmt_req_acc.journal_date         := p_reverse_date;
      v_pmt_req_acc.period_name          := p_period_name;
      v_pmt_req_acc.entered_amount_dr    := -1 *
                                            v_pmt_req_acc.entered_amount_dr;
      v_pmt_req_acc.entered_amount_cr    := -1 *
                                            v_pmt_req_acc.entered_amount_cr;
      v_pmt_req_acc.functional_amount_dr := -1 *
                                            v_pmt_req_acc.functional_amount_dr;
      v_pmt_req_acc.functional_amount_cr := -1 *
                                            v_pmt_req_acc.functional_amount_cr;
      v_pmt_req_acc.je_line_id           := get_je_line_id;
      v_pmt_req_acc.payment_req_line_id  := p_new_csh_pmt_req_line_id;
      --v_pmt_req_acc.interface_flag       := 'N';
      --modify by zhaofan
      v_pmt_req_acc.interface_flag := 'P';
    
      INSERT INTO csh_payment_req_accounts VALUES v_pmt_req_acc;
    
      evt_event_core_pkg.fire_event(p_event_name  => 'CSH_PMT_REQ_REVERSE_ACCOUNTS_',
                                    p_event_param => v_pmt_req_acc.je_line_id,
                                    p_created_by  => p_user_id);
    END LOOP;
    CLOSE cur_accounts;
  END;

  ---------反冲行
  PROCEDURE reverse_csh_panyment_req_lines(p_old_header_id NUMBER,
                                           p_new_header_id NUMBER,
                                           p_user_id       NUMBER,
                                           p_reverse_date  DATE,
                                           p_period_name   VARCHAR2) IS
    CURSOR c_line IS
      SELECT *
        FROM csh_payment_requisition_lns l
       WHERE l.payment_requisition_header_id = p_old_header_id
       ORDER BY l.payment_requisition_line_id;
  
    v_lines csh_payment_requisition_lns%ROWTYPE;
  
    v_old_csh_pmt_req_line_id NUMBER;
  BEGIN
    OPEN c_line;
    LOOP
      FETCH c_line
        INTO v_lines;
      EXIT WHEN c_line%NOTFOUND;
      v_old_csh_pmt_req_line_id := v_lines.payment_requisition_line_id;
    
      v_lines.payment_requisition_header_id := p_new_header_id;
      v_lines.payment_requisition_line_id   := csh_payment_requisition_pkg.get_csh_payment_req_line_id;
      v_lines.amount                        := -1 * v_lines.amount;
      v_lines.creation_date                 := SYSDATE;
      v_lines.created_by                    := p_user_id;
      v_lines.last_update_date              := SYSDATE;
      v_lines.last_updated_by               := p_user_id;
      v_lines.payment_completed_date        := '';
    
      INSERT INTO csh_payment_requisition_lns VALUES v_lines;
    
      reverse_csh_pmt_req_accounts(p_old_csh_pmt_req_line_id => v_old_csh_pmt_req_line_id,
                                   p_new_csh_pmt_req_line_id => v_lines.payment_requisition_line_id,
                                   p_user_id                 => p_user_id,
                                   p_reverse_date            => p_reverse_date,
                                   p_period_name             => p_period_name);
    END LOOP;
    CLOSE c_line;
  END;

  --借款申请反冲
  PROCEDURE reverse_csh_panyment_req(p_pmt_req_header_id NUMBER,
                                     p_reverse_date      DATE,
                                     p_user_id           NUMBER) IS
    v_period_name             gld_period_status.period_name%TYPE;
    v_reversed_flag           csh_payment_requisition_hds.reversed_flag%TYPE;
    v_requisition_number      csh_payment_requisition_hds.requisition_number%TYPE;
    v_payment_req_type_id     csh_payment_requisition_hds.payment_req_type_id%TYPE;
    v_operation_unit_id       csh_payment_requisition_hds.operation_unit_id%TYPE;
    v_company_id              NUMBER;
    v_audit_flag              VARCHAR2(1);
    v_new_pmt_req_header_id   NUMBER;
    v_pay_trans_line_id       NUMBER;
    v_pay_trans_header_id     NUMBER;
    v_pay_trans_reversed_flag VARCHAR2(10);
    v_pay_trans_return_flag   VARCHAR2(20);
  
    e_reverse_date_error EXCEPTION;
    e_reverse_flag_error EXCEPTION;
    e_audit_flag_error   EXCEPTION;
    e_doc_number_error   EXCEPTION;
    e_lock_table         EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_lock_table, -54);
    e_pay_sent_error            EXCEPTION;
    e_pay_success_error         EXCEPTION;
    e_pay_error_error           EXCEPTION;
    e_pay_refund_error          EXCEPTION;
    e_pay_trans_unreverse_error EXCEPTION;
  BEGIN
    /*************************************************
    -- Author  : MOUSE
    -- Created : 2015/12/1 22:06:14
    -- Ver     : 1.1
    -- Purpose : 借款单反冲时检查是否存在正在处理中的资金系统接口
    **************************************************/
    FOR pmt_info_lns IN (SELECT *
                           FROM cux_payment_doc_info i
                          WHERE i.document_id = p_pmt_req_header_id
                            AND i.document_category = 'PAYMENT_REQUISITION') LOOP
      IF pmt_info_lns.datastatus = '0' THEN
        --如果当前存在未传送资金的接口数据，备份并删除info和interface数据
        INSERT INTO cux_payment_interface_his h
          SELECT *
            FROM cux_payment_interface pi
           WHERE pi.id = pmt_info_lns.interface_id;
      
        DELETE FROM cux_payment_interface pi
         WHERE pi.id = pmt_info_lns.interface_id;
      
        INSERT INTO cux_payment_doc_info_his
          SELECT *
            FROM cux_payment_doc_info di
           WHERE di.info_id = pmt_info_lns.info_id;
      
        DELETE FROM cux_payment_doc_info di
         WHERE di.info_id = pmt_info_lns.info_id;
      ELSIF pmt_info_lns.datastatus IN ('1', '2', '3') THEN
        --如果当前存在已传送资金的接口数据，但是还未处理，提示错误信息，不允许反冲
        RAISE e_pay_sent_error;
      ELSIF pmt_info_lns.datastatus IN ('4', '7') THEN
        --如果当前存在支付失败，需要提示：支付失败，请先
        RAISE e_pay_error_error;
      ELSIF pmt_info_lns.datastatus = '5' THEN
        --如果当前存在支付成功，需要提示：已支付成功，首先进行付款反冲
        RAISE e_pay_success_error;
      ELSIF pmt_info_lns.datastatus = '7' THEN
        --如果当前存在支付退票，需要提示：支付退票，请先确认支付退票
        RAISE e_pay_refund_error;
      END IF;
    END LOOP;
  
    SELECT t.reversed_flag,
           t.operation_unit_id,
           t.company_id,
           payment_req_type_id,
           nvl(t.audit_flag, 'Y')
      INTO v_reversed_flag,
           v_operation_unit_id,
           v_company_id,
           v_payment_req_type_id,
           v_audit_flag
      FROM csh_payment_requisition_hds t
     WHERE t.payment_requisition_header_id = p_pmt_req_header_id
       FOR UPDATE NOWAIT;
  
    IF v_reversed_flag IS NOT NULL THEN
      RAISE e_reverse_flag_error;
    END IF;
    IF v_audit_flag <> 'Y' THEN
      RAISE e_audit_flag_error;
    END IF;
  
    v_period_name := gld_common_pkg.get_gld_period_name(p_company_id => v_company_id,
                                                        p_date       => p_reverse_date);
    IF v_period_name IS NULL THEN
      RAISE e_reverse_date_error;
    END IF;
  
    --判断当前借款单是否被支付，如果被支付，其付款事务是否已被反冲，如果未被反冲，不允许进行借款单反冲操作
    FOR lns IN (SELECT *
                  FROM csh_payment_requisition_lns l
                 WHERE l.payment_requisition_header_id = p_pmt_req_header_id) LOOP
      BEGIN
        --找到当前借款单行对应的预付款行信息
        SELECT r.csh_transaction_line_id
          INTO v_pay_trans_line_id
          FROM csh_payment_requisition_refs r
         WHERE r.payment_requisition_line_id =
               lns.payment_requisition_line_id
         GROUP BY csh_transaction_line_id;
      EXCEPTION
        WHEN no_data_found THEN
          GOTO next_lns;
      END;
    
      --根据预付款行信息找到付款行信息，该付款信息必须反冲才可以进行借款反冲
      SELECT h.reversed_flag, h.returned_flag
        INTO v_pay_trans_reversed_flag, v_pay_trans_return_flag
        FROM csh_transaction_headers h, csh_transaction_lines l
       WHERE h.transaction_header_id = l.transaction_header_id
         AND l.transaction_line_id = v_pay_trans_line_id;
    
      --万联添加退票也可以反冲
      IF nvl(v_pay_trans_reversed_flag, 'N') != 'W' AND
         nvl(v_pay_trans_return_flag, '-') <> 'C' THEN
        RAISE e_pay_trans_unreverse_error;
      END IF;
    
      <<next_lns>>
      NULL;
    END LOOP;
  
    -----插入借款申请单头
    v_new_pmt_req_header_id := csh_payment_requisition_pkg.get_csh_payment_req_header_id;
    v_requisition_number    := csh_payment_requisition_pkg.get_csh_payment_req_number(p_document_type     => v_payment_req_type_id,
                                                                                      p_company_id        => v_company_id,
                                                                                      p_operation_unit_id => v_operation_unit_id,
                                                                                      p_operation_date    => p_reverse_date,
                                                                                      p_user_id           => p_user_id);
    IF v_requisition_number = fnd_code_rule_pkg.c_error THEN
      RAISE e_doc_number_error;
    END IF;
  
    reverse_csh_payment_req_hds(p_old_csh_pmt_req_header_id => p_pmt_req_header_id,
                                p_new_csh_pmt_req_header_id => v_new_pmt_req_header_id,
                                p_requisition_number        => v_requisition_number,
                                p_user_id                   => p_user_id,
                                p_reverse_date              => p_reverse_date);
  
    ---------反冲行
    reverse_csh_panyment_req_lines(p_old_header_id => p_pmt_req_header_id,
                                   p_new_header_id => v_new_pmt_req_header_id,
                                   p_user_id       => p_user_id,
                                   p_reverse_date  => p_reverse_date,
                                   p_period_name   => v_period_name);
  
    --插入反冲借款申请单历史
    exp_document_history_pkg.insert_exp_document_histories(p_document_type  => csh_payment_requisition_pkg.c_payment_requisition,
                                                           p_document_id    => v_new_pmt_req_header_id,
                                                           p_operation_code => exp_document_history_pkg.c_generate, --'GENERATE',
                                                           p_user_id        => p_user_id,
                                                           p_operation_time => SYSDATE,
                                                           p_description    => '');
  
    exp_document_history_pkg.insert_exp_document_histories(p_document_type  => csh_payment_requisition_pkg.c_payment_requisition,
                                                           p_document_id    => v_new_pmt_req_header_id,
                                                           p_operation_code => exp_document_history_pkg.c_audit, --'AUDIT',
                                                           p_user_id        => p_user_id,
                                                           p_operation_time => SYSDATE,
                                                           p_description    => '');
  
    --插入被反冲借款申请单的历史
    exp_document_history_pkg.insert_exp_document_histories(p_document_type  => csh_payment_requisition_pkg.c_payment_requisition,
                                                           p_document_id    => p_pmt_req_header_id,
                                                           p_operation_code => exp_document_history_pkg.c_reverse, --'REVERSED',
                                                           p_user_id        => p_user_id,
                                                           p_operation_time => SYSDATE,
                                                           p_description    => '');
  
    --反冲借款申请单事件
    exp_evt_pkg.fire_workflow_event(p_event_name       => 'CSH_PAYMENT_REQUISITION_REVERSE',
                                    p_document_id      => v_new_pmt_req_header_id,
                                    p_document_line_id => '',
                                    p_source_module    => csh_payment_requisition_pkg.c_payment_requisition,
                                    p_event_type       => 'CSH_PAYMENT_REQUISITION_REVERSE',
                                    p_user_id          => p_user_id);
  
    -- 万联证券填写来源单据编号
    /*UPDATE gl_account_entry gae
       SET gae.attribute12 = v_requisition_number
     WHERE gae.transaction_type = 'CSH_PMT_REQ'
       AND gae.transaction_header_id = v_new_pmt_req_header_id;
    
    -- 万联证券更改凭证状态
    UPDATE gl_account_entry gae
       SET gae.imported_flag = 'G'
     WHERE gae.transaction_type = 'CSH_PMT_REQ'
       AND gae.transaction_header_id = v_new_pmt_req_header_id
       AND EXISTS
     (SELECT 1
              FROM gl_account_entry gae
             WHERE gae.transaction_type = 'CSH_PMT_REQ'
               AND gae.transaction_header_id = p_pmt_req_header_id
               AND gae.imported_flag = 'G');*/
  
  EXCEPTION
    WHEN e_pay_trans_unreverse_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '请先反冲付款！',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'exp_report_pkg',
                                                     p_procedure_function_name => 'reverse_expense_report');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_pay_sent_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '当前单据已经传送资金接口，请等待资金系统处理完毕！',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'exp_report_pkg',
                                                     p_procedure_function_name => 'reverse_expense_report');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_pay_success_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '当前单据已经支付成功，请先反冲付款事务！',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'exp_report_pkg',
                                                     p_procedure_function_name => 'reverse_expense_report');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_pay_error_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '当前单据支付失败，请进入《失败数据确认》功能进行确认！',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'exp_report_pkg',
                                                     p_procedure_function_name => 'reverse_expense_report');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_pay_refund_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '当前单据已经支付退票，请进入《退票数据确认》功能进行确认！',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'exp_report_pkg',
                                                     p_procedure_function_name => 'reverse_expense_report');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_audit_flag_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5080_AUDIT_FLAG_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'reverse_csh_panyment_req');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_doc_number_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5010_PAYMENT_REQ_CODING_RULE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'reverse_csh_panyment_req');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_reverse_date_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5150_REVERSE_DATE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'reverse_csh_panyment_req');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_reverse_flag_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5080_REVERSE_FLAG_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'reverse_csh_panyment_req');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_lock_table THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5070_CONCURRENT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'reverse_csh_panyment_req');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_payment_req_audit_pkg',
                                                     p_procedure_function_name => 'reverse_csh_panyment_req');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END reverse_csh_panyment_req;

  --借款申请凭证调整
  PROCEDURE update_csh_pnt_req_accounts(p_je_line_id               NUMBER,
                                        p_description              VARCHAR2,
                                        p_company_id               NUMBER,
                                        p_responsibility_center_id NUMBER,
                                        p_account_id               NUMBER,
                                        p_entered_amount_dr        NUMBER,
                                        p_entered_amount_cr        NUMBER,
                                        p_functional_amount_dr     NUMBER,
                                        p_functional_amount_cr     NUMBER,
                                        p_account_segment2         VARCHAR2,
                                        p_account_segment3         VARCHAR2,
                                        p_user_id                  NUMBER) IS
    e_amout_null_error    EXCEPTION;
    e_amount_double_error EXCEPTION;
  BEGIN
    IF (p_entered_amount_dr IS NULL AND p_entered_amount_cr IS NULL) OR
       (p_functional_amount_dr IS NULL AND p_functional_amount_cr IS NULL) THEN
      RAISE e_amout_null_error;
    ELSIF (p_entered_amount_dr IS NOT NULL AND
          p_entered_amount_cr IS NOT NULL) OR
          (p_functional_amount_dr IS NOT NULL AND
          p_functional_amount_cr IS NOT NULL) THEN
      RAISE e_amount_double_error;
    END IF;
  
    UPDATE csh_payment_req_accounts a
       SET a.company_id               = p_company_id,
           a.responsibility_center_id = p_responsibility_center_id,
           a.account_id               = p_account_id,
           a.entered_amount_dr        = p_entered_amount_dr,
           a.entered_amount_cr        = p_entered_amount_cr,
           a.functional_amount_dr     = p_functional_amount_dr,
           a.functional_amount_cr     = p_functional_amount_cr,
           a.last_updated_by          = p_user_id,
           a.last_update_date         = SYSDATE,
           a.description              = p_description,
           a.account_segment2         = p_account_segment2,
           a.account_segment3         = p_account_segment3
     WHERE a.je_line_id = p_je_line_id;
  
    evt_event_core_pkg.fire_event(p_event_name  => 'CSH_PAY_REQ_JE_LINE_UPDATE_ACCOUNT',
                                  p_event_param => p_je_line_id,
                                  p_created_by  => p_user_id);
  
  EXCEPTION
    WHEN e_amount_double_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP_REP_ACCOUNT_AMOUNT_DOUBLE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'update_csh_pnt_req_accounts');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_amout_null_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP_REP_ACCOUNT_AMOUNT_NULL',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'csh_payment_req_audit_pkg',
                                                      p_procedure_function_name => 'update_csh_pnt_req_accounts');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'csh_payment_req_audit_pkg',
                                                     p_procedure_function_name => 'update_csh_pnt_req_accounts');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  FUNCTION set_g_user_id(p_user_id NUMBER) RETURN NUMBER IS
  BEGIN
    g_user_id := p_user_id;
  
    RETURN NULL;
  END;
END csh_payment_req_audit_pkg;
/
