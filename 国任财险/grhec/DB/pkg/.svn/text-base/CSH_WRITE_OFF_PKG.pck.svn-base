CREATE OR REPLACE PACKAGE "CSH_WRITE_OFF_PKG" IS

  -- Author  : RAZGRIZ
  -- Created : 2009-6-9
  -- Purpose : 现金事务核销

  --Ver: 1.35 Bobo
  --1.get_last_write_off_date函数放到包头申明
  --2.execute_csh_trx_write_off过程中，增加ACP发票处理

  -- Public constant declarations
  -- 报销单核销标志
  c_exp_rep_write_off_status_y CONSTANT VARCHAR2(1) := 'Y'; -- 部分核销
  c_exp_rep_write_off_status_n CONSTANT VARCHAR2(1) := 'N'; -- 未核销
  c_exp_rep_write_off_status_c CONSTANT VARCHAR2(1) := 'C'; -- 完全核销

  -- gld_interface_flag
  c_gld_interface_flag_y CONSTANT VARCHAR2(1) := 'Y';
  c_gld_interface_flag_p CONSTANT VARCHAR2(1) := 'P';
  c_gld_interface_flag_n CONSTANT VARCHAR2(1) := 'N';

  -- Public function and procedure declarations
  FUNCTION get_csh_write_off_id RETURN NUMBER;

  FUNCTION get_csh_write_off_je_line_id RETURN NUMBER;

  FUNCTION get_exp_rep_batch_id RETURN NUMBER;

  PROCEDURE insert_csh_write_off(p_write_off_id              NUMBER,
                                 p_write_off_type            VARCHAR2,
                                 p_csh_transaction_line_id   NUMBER,
                                 p_csh_write_off_amount      NUMBER,
                                 p_document_source           VARCHAR2,
                                 p_document_header_id        NUMBER,
                                 p_document_line_id          NUMBER,
                                 p_document_write_off_amount NUMBER,
                                 p_write_off_date            DATE,
                                 p_period_name               VARCHAR2,
                                 p_source_csh_trx_line_id    NUMBER,
                                 p_source_write_off_amount   NUMBER,
                                 p_gld_interface_flag        VARCHAR2,
                                 p_user_id                   NUMBER);

  PROCEDURE insert_csh_write_off_accounts(p_write_off_id             NUMBER,
                                          p_write_off_je_line_id     NUMBER,
                                          p_description              VARCHAR2,
                                          p_period_name              VARCHAR2,
                                          p_source_code              VARCHAR2,
                                          p_company_id               NUMBER,
                                          p_responsibility_center_id NUMBER,
                                          p_account_id               NUMBER,
                                          p_currency_code            VARCHAR2,
                                          p_exchange_rate_type       VARCHAR2,
                                          p_exchange_rate            NUMBER,
                                          p_entered_amount_dr        NUMBER,
                                          p_entered_amount_cr        NUMBER,
                                          p_functional_amount_dr     NUMBER,
                                          p_functional_amount_cr     NUMBER,
                                          p_cash_clearing_flag       VARCHAR2,
                                          p_journal_date             DATE,
                                          p_gld_interface_flag       VARCHAR2,
                                          p_usage_code               VARCHAR2,
                                          p_user_id                  NUMBER);

  /**
  * 插付款事务核销过账时待处理数据临时表
  */
  PROCEDURE insert_csh_write_off_tmp(p_session_id                  NUMBER,
                                     p_write_off_type              VARCHAR2,
                                     p_transaction_class           VARCHAR2,
                                     p_payment_requisition_line_id NUMBER,
                                     p_contract_header_id          NUMBER,
                                     p_payment_schedule_line_id    NUMBER,
                                     p_write_off_date              DATE,
                                     p_write_off_amount            NUMBER,
                                     p_company_id                  NUMBER,
                                     p_document_id                 NUMBER,
                                     p_user_id                     NUMBER);

  PROCEDURE delete_csh_write_off_tmp(p_session_id NUMBER, p_user_id NUMBER);

  /**
  * 插预付款核销反冲时待处理数据临时表
  */
  PROCEDURE insert_csh_write_off_rev_tmp(p_session_id   NUMBER,
                                         p_write_off_id NUMBER,
                                         p_user_id      NUMBER);

  PROCEDURE delete_csh_write_off_rev_tmp(p_session_id NUMBER,
                                         p_user_id    NUMBER);

  /**
  * 插付款事务退款过账时待处理数据临时表
  */
  PROCEDURE insert_csh_trx_rtn_tmp(p_session_id    NUMBER,
                                   p_source_type   VARCHAR2,
                                   p_source_id     NUMBER,
                                   p_return_amount NUMBER,
                                   p_user_id       NUMBER);

  PROCEDURE delete_csh_trx_rtn_tmp(p_session_id NUMBER, p_user_id NUMBER);

  /**
  * 校验本次核销金额与报销单未核销金额
  * return:
  *     success:null
  *     failure:message_code
  */
  FUNCTION check_payment_amount(p_exp_report_header_id     NUMBER,
                                p_payment_schedule_line_id NUMBER,
                                p_payment_amount           NUMBER)
    RETURN VARCHAR2;

  /**
  * 更新报销单核销状态
  */
  PROCEDURE set_exp_rep_write_off_status(p_exp_report_header_id NUMBER,
                                         p_user_id              NUMBER);
  /**
  * 更新现金事务核销状态
  */
  PROCEDURE set_csh_trx_write_off_status(p_transaction_header_id NUMBER,
                                         p_transaction_line_id   NUMBER,
                                         p_transaction_type      VARCHAR2,
                                         p_user_id               NUMBER);

  FUNCTION get_last_write_off_date(p_document_source    VARCHAR2,
                                   p_document_header_id NUMBER) RETURN DATE;

  PROCEDURE delete_csh_trx_error_logs(p_batch_id NUMBER);

  --报销单支付反冲 by bobo
  PROCEDURE reverse_expense_report_payment(p_batch_id          NUMBER,
                                           p_csh_trx_header_id NUMBER,
                                           p_transaction_date  DATE,
                                           p_period_name       VARCHAR2,
                                           p_user_id           NUMBER);

  /**
  * 处理现金事务核销
  * 只支持一条现金事务的处理，暂不支持批量处理
  * 需要将待处理的数据先插入csh_write_off_tmp表
  * 根据不同的核销类型进行不同的处理方法
  * 更新现金事务的核销状态
  * 删除待处理数据
  */
  PROCEDURE execute_csh_trx_write_off(p_session_id            NUMBER,
                                      p_transaction_header_id NUMBER,
                                      p_transaction_line_id   NUMBER,
                                      p_user_id               NUMBER);

  /**
  * 处理现金事务退款核销
  * 只支持一条现金事务的处理，暂不支持批量处理
  * 需要将待处理的数据先插入 csh_transaction_return_tmp 表
  * 根据不同的核销类型进行不同的处理方法
  */
  PROCEDURE return_csh_trx_write_off(p_session_id            NUMBER,
                                     p_transaction_header_id NUMBER,
                                     p_transaction_line_id   NUMBER,
                                     p_source_trx_header     csh_transaction_headers%ROWTYPE,
                                     p_user_id               NUMBER);

  /**
  * 处理预付款核销反冲业务
  */
  PROCEDURE reverse_prepayment_write_off(p_session_id            NUMBER,
                                         p_transaction_header_id NUMBER, -- 预付款事务头id
                                         p_transaction_line_id   NUMBER, -- 预付款事务行id
                                         p_reverse_date          DATE,
                                         p_user_id               NUMBER);

END csh_write_off_pkg;
/
CREATE OR REPLACE PACKAGE BODY "CSH_WRITE_OFF_PKG" IS
  -- Private variable declarations
  e_bank_accounts_error         EXCEPTION;
  e_default_resp_error          EXCEPTION;
  e_trx_header_error            EXCEPTION;
  e_exp_clearing_accounts_error EXCEPTION;

  PROCEDURE error_log(p_batch_id      NUMBER,
                      p_trx_header_id NUMBER,
                      p_trx_line_id   NUMBER,
                      p_message       VARCHAR2,
                      p_user_id       NUMBER) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO csh_transaction_error_logs t
      (batch_id,
       trx_header_id,
       trx_line_id,
       message,
       message_date,
       created_by)
    VALUES
      (p_batch_id,
       p_trx_header_id,
       p_trx_line_id,
       p_message,
       SYSDATE,
       p_user_id);
    COMMIT;
  END error_log;

  FUNCTION get_csh_write_off_id RETURN NUMBER IS
    v_write_off_id NUMBER;
  BEGIN
    SELECT csh_write_off_s.nextval INTO v_write_off_id FROM dual;
    RETURN v_write_off_id;
  END get_csh_write_off_id;

  FUNCTION get_csh_write_off_je_line_id RETURN NUMBER IS
    v_write_off_je_line_id NUMBER;
  BEGIN
    SELECT csh_write_off_accounts_s.nextval
      INTO v_write_off_je_line_id
      FROM dual;
    RETURN v_write_off_je_line_id;
  END get_csh_write_off_je_line_id;

  -- 获取报销单支付的batch_id
  FUNCTION get_exp_rep_batch_id RETURN NUMBER IS
    v_batch_id NUMBER;
  BEGIN
    SELECT exp_report_payment_tmp_s.nextval INTO v_batch_id FROM dual;
    RETURN v_batch_id;
  END;

  FUNCTION get_last_write_off_date(p_document_source    VARCHAR2,
                                   p_document_header_id NUMBER) RETURN DATE IS
    v_last_write_off_date DATE;
  BEGIN
    SELECT MAX(w.write_off_date)
      INTO v_last_write_off_date
      FROM csh_write_off w
     WHERE w.document_source = p_document_source
       AND w.document_header_id = p_document_header_id;
  
    RETURN v_last_write_off_date;
  END get_last_write_off_date;

  FUNCTION get_last_write_off_date(p_transaction_line_id NUMBER) RETURN DATE IS
    v_last_write_off_date DATE;
  BEGIN
    SELECT MAX(w.write_off_date)
      INTO v_last_write_off_date
      FROM csh_write_off w
     WHERE w.csh_transaction_line_id = p_transaction_line_id;
  
    RETURN v_last_write_off_date;
  END get_last_write_off_date;

  -- 插核销记录
  PROCEDURE insert_csh_write_off(p_write_off_id              NUMBER,
                                 p_write_off_type            VARCHAR2,
                                 p_csh_transaction_line_id   NUMBER,
                                 p_csh_write_off_amount      NUMBER,
                                 p_document_source           VARCHAR2,
                                 p_document_header_id        NUMBER,
                                 p_document_line_id          NUMBER,
                                 p_document_write_off_amount NUMBER,
                                 p_write_off_date            DATE,
                                 p_period_name               VARCHAR2,
                                 p_source_csh_trx_line_id    NUMBER,
                                 p_source_write_off_amount   NUMBER,
                                 p_gld_interface_flag        VARCHAR2,
                                 p_user_id                   NUMBER) IS
  BEGIN
    INSERT INTO csh_write_off
      (write_off_id,
       write_off_type,
       csh_transaction_line_id,
       csh_write_off_amount,
       document_source,
       document_header_id,
       document_line_id,
       document_write_off_amount,
       write_off_date,
       period_name,
       source_csh_trx_line_id,
       source_write_off_amount,
       gld_interface_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (p_write_off_id,
       p_write_off_type,
       p_csh_transaction_line_id,
       p_csh_write_off_amount,
       p_document_source,
       p_document_header_id,
       p_document_line_id,
       p_document_write_off_amount,
       p_write_off_date,
       p_period_name,
       p_source_csh_trx_line_id,
       p_source_write_off_amount,
       p_gld_interface_flag,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE);
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                     p_procedure_function_name => 'INSERT_CSH_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_csh_write_off;

  PROCEDURE insert_csh_write_off_accounts(p_write_off_id             NUMBER,
                                          p_write_off_je_line_id     NUMBER,
                                          p_description              VARCHAR2,
                                          p_period_name              VARCHAR2,
                                          p_source_code              VARCHAR2,
                                          p_company_id               NUMBER,
                                          p_responsibility_center_id NUMBER,
                                          p_account_id               NUMBER,
                                          p_currency_code            VARCHAR2,
                                          p_exchange_rate_type       VARCHAR2,
                                          p_exchange_rate            NUMBER,
                                          p_entered_amount_dr        NUMBER,
                                          p_entered_amount_cr        NUMBER,
                                          p_functional_amount_dr     NUMBER,
                                          p_functional_amount_cr     NUMBER,
                                          p_cash_clearing_flag       VARCHAR2,
                                          p_journal_date             DATE,
                                          p_gld_interface_flag       VARCHAR2,
                                          p_usage_code               VARCHAR2,
                                          p_user_id                  NUMBER) IS
  BEGIN
    INSERT INTO csh_write_off_accounts
      (write_off_id,
       write_off_je_line_id,
       description,
       period_name,
       source_code,
       company_id,
       responsibility_center_id,
       account_id,
       currency_code,
       exchange_rate_type,
       exchange_rate,
       entered_amount_dr,
       entered_amount_cr,
       functional_amount_dr,
       functional_amount_cr,
       cash_clearing_flag,
       journal_date,
       gld_interface_flag,
       usage_code,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (p_write_off_id,
       p_write_off_je_line_id,
       p_description,
       p_period_name,
       p_source_code,
       p_company_id,
       p_responsibility_center_id,
       p_account_id,
       p_currency_code,
       p_exchange_rate_type,
       p_exchange_rate,
       p_entered_amount_dr,
       p_entered_amount_cr,
       p_functional_amount_dr,
       p_functional_amount_cr,
       p_cash_clearing_flag,
       p_journal_date,
       p_gld_interface_flag,
       p_usage_code,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE);
  
    -- 生成凭证后，插入预置事件
    csh_evt_pkg.fire_workflow_event(p_event_name          => 'CREATE_CSH_WRITE_OFF_ACCOUNTS',
                                    p_transaction_line_id => '',
                                    p_trx_je_line_id      => p_write_off_je_line_id,
                                    p_source_module       => 'CSH_WRITE_OFF_ACCOUNTS',
                                    p_event_type          => 'CREATE_CSH_WRITE_OFF_ACCOUNTS',
                                    p_user_id             => p_user_id);
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                     p_procedure_function_name => 'INSERT_CSH_WRITE_OFF_ACCOUNTS');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_csh_write_off_accounts;

  PROCEDURE insert_csh_write_off_tmp(p_session_id                  NUMBER,
                                     p_write_off_type              VARCHAR2,
                                     p_transaction_class           VARCHAR2,
                                     p_payment_requisition_line_id NUMBER,
                                     p_contract_header_id          NUMBER,
                                     p_payment_schedule_line_id    NUMBER,
                                     p_write_off_date              DATE,
                                     p_write_off_amount            NUMBER,
                                     p_company_id                  NUMBER,
                                     p_document_id                 NUMBER,
                                     p_user_id                     NUMBER) IS
  BEGIN
  
    INSERT INTO csh_write_off_tmp
      (session_id,
       write_off_type,
       transaction_class,
       payment_requisition_line_id,
       contract_header_id,
       payment_schedule_line_id,
       write_off_date,
       write_off_amount,
       company_id,
       document_id,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by)
    VALUES
      (p_session_id,
       p_write_off_type,
       p_transaction_class,
       p_payment_requisition_line_id,
       p_contract_header_id,
       p_payment_schedule_line_id,
       p_write_off_date,
       p_write_off_amount,
       p_company_id,
       p_document_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_user_id);
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                     p_procedure_function_name => 'INSERT_CSH_WRITE_OFF_TMP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_csh_write_off_tmp;

  PROCEDURE delete_csh_write_off_tmp(p_session_id NUMBER, p_user_id NUMBER) IS
  BEGIN
    DELETE FROM csh_write_off_tmp WHERE session_id = p_session_id;
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                     p_procedure_function_name => 'DELETE_CSH_WRITE_OFF_TMP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END delete_csh_write_off_tmp;

  PROCEDURE insert_csh_write_off_rev_tmp(p_session_id   NUMBER,
                                         p_write_off_id NUMBER,
                                         p_user_id      NUMBER) IS
  BEGIN
    INSERT INTO csh_write_off_reverse_tmp
      (session_id,
       write_off_id,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by)
    VALUES
      (p_session_id,
       p_write_off_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_user_id);
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                     p_procedure_function_name => 'INSERT_CSH_WRITE_OFF_REV_TMP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_csh_write_off_rev_tmp;

  PROCEDURE delete_csh_write_off_rev_tmp(p_session_id NUMBER,
                                         p_user_id    NUMBER) IS
  BEGIN
    DELETE FROM csh_write_off_reverse_tmp WHERE session_id = p_session_id;
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                     p_procedure_function_name => 'DELETE_CSH_WRITE_OFF_REV_TMP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END delete_csh_write_off_rev_tmp;

  PROCEDURE insert_csh_trx_rtn_tmp(p_session_id    NUMBER,
                                   p_source_type   VARCHAR2,
                                   p_source_id     NUMBER,
                                   p_return_amount NUMBER,
                                   p_user_id       NUMBER) IS
  BEGIN
    IF nvl(p_return_amount, 0) = 0 THEN
      RETURN;
    END IF;
    INSERT INTO csh_transaction_return_tmp
      (session_id,
       source_type,
       source_id,
       return_amount,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by)
    VALUES
      (p_session_id,
       p_source_type,
       p_source_id,
       p_return_amount,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_user_id);
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                     p_procedure_function_name => 'INSERT_CSH_TRX_RTN_TMP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_csh_trx_rtn_tmp;

  PROCEDURE delete_csh_trx_rtn_tmp(p_session_id NUMBER, p_user_id NUMBER) IS
  BEGIN
    DELETE FROM csh_transaction_return_tmp WHERE session_id = p_session_id;
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                     p_procedure_function_name => 'DELETE_CSH_TRX_RTN_TMP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END delete_csh_trx_rtn_tmp;

  FUNCTION check_payment_amount(p_exp_report_header_id     NUMBER,
                                p_payment_schedule_line_id NUMBER,
                                p_payment_amount           NUMBER)
    RETURN VARCHAR2 IS
    v_due_amount       NUMBER;
    v_write_off_amount NUMBER;
  BEGIN
    -- 校验本次付款金额是否大于零
    IF p_payment_amount <= 0 THEN
      RETURN 'EXP5200_NEGATIVE_AMOUNT_ERROR';
    END IF;
  
    SELECT nvl(s.due_amount, 0) -- 计划付款金额
      INTO v_due_amount
      FROM exp_report_pmt_schedules s
     WHERE s.payment_schedule_line_id = p_payment_schedule_line_id;
    BEGIN
      --已付金额
      SELECT nvl(SUM(w.document_write_off_amount), 0)
        INTO v_write_off_amount
        FROM csh_write_off w
       WHERE w.document_source = 'EXPENSE_REPORT'
         AND w.document_header_id = p_exp_report_header_id
         AND w.document_line_id = p_payment_schedule_line_id;
    EXCEPTION
      WHEN no_data_found THEN
        v_write_off_amount := 0;
    END;
  
    IF v_due_amount = v_write_off_amount THEN
      -- 已完全支付
      RETURN 'EXP5200_WRITE_OFF_COMPLETE_ERROR';
    ELSIF p_payment_amount > (v_due_amount - v_write_off_amount) THEN
      --本次付款金额大于未付金额
      RETURN 'EXP5200_PAYMENT_AMOUNT_ERROR';
    END IF;
  
    RETURN NULL;
  END check_payment_amount;

  /**
  * 校验核销行的退款金额
  * parm:
  * return: null or error_code
  **/
  FUNCTION check_return_write_off_amt(p_write_off_id  NUMBER,
                                      p_return_amount NUMBER,
                                      p_csh_write_off OUT csh_write_off%ROWTYPE)
    RETURN VARCHAR2 IS
    v_max_return_amount        NUMBER;
    v_prepayment_amount        NUMBER;
    v_source_header_id         NUMBER;
    v_prepayment_write_off_amt NUMBER;
    v_prepayment_returned_amt  NUMBER;
  BEGIN
    -- 原核销记录
    SELECT w.*
      INTO p_csh_write_off
      FROM csh_write_off w
     WHERE w.write_off_id = p_write_off_id;
  
    IF p_csh_write_off.write_off_type = 'PAYMENT_EXPENSE_REPORT' THEN
      -- 最大可退金额
      SELECT nvl(SUM(w.csh_write_off_amount), 0)
        INTO v_max_return_amount
        FROM csh_write_off w
       WHERE w.csh_transaction_line_id =
             p_csh_write_off.csh_transaction_line_id
         AND w.document_line_id = p_csh_write_off.document_line_id;
    ELSIF p_csh_write_off.write_off_type = 'PAYMENT_PREPAYMENT' THEN
      -- 预付款事务
      SELECT l.transaction_amount, l.transaction_header_id
        INTO v_prepayment_amount, v_source_header_id
        FROM csh_transaction_lines l
       WHERE l.transaction_line_id = p_csh_write_off.source_csh_trx_line_id;
      -- 预付款已核销报销单部分
      SELECT nvl(SUM(w.csh_write_off_amount), 0)
        INTO v_prepayment_write_off_amt
        FROM csh_write_off w
       WHERE w.csh_transaction_line_id =
             p_csh_write_off.source_csh_trx_line_id;
      -- 预付款已退款部分
      SELECT nvl(SUM(l.transaction_amount), 0)
        INTO v_prepayment_returned_amt
        FROM csh_transaction_headers h, csh_transaction_lines l
       WHERE h.transaction_header_id = l.transaction_header_id
         AND h.returned_flag = csh_transaction_pkg.c_trans_return_flag_rev
         AND h.source_header_id = v_source_header_id
         AND h.reversed_flag IS NULL;
      v_max_return_amount := v_prepayment_amount -
                             v_prepayment_write_off_amt -
                             v_prepayment_returned_amt;
    END IF;
    IF p_return_amount > v_max_return_amount THEN
      RETURN 'CSH5240_RETURN_AMOUNT_ERROR';
    END IF;
    RETURN NULL;
  END check_return_write_off_amt;

  /**
  * 校验核销记录是否已被反冲
  * parm:
  * return: null or error_code
  **/
  FUNCTION check_write_off_reversed(p_csh_write_off csh_write_off%ROWTYPE)
    RETURN VARCHAR2 IS
    v_sum_write_off_amount NUMBER;
  BEGIN
    SELECT nvl(SUM(w.csh_write_off_amount), 0)
      INTO v_sum_write_off_amount
      FROM csh_write_off w
     WHERE w.csh_transaction_line_id =
           p_csh_write_off.csh_transaction_line_id
       AND w.document_line_id = p_csh_write_off.document_line_id;
    IF v_sum_write_off_amount = 0 THEN
      RETURN 'CSH5250_REVERSED_ERROR';
    END IF;
    RETURN NULL;
  END check_write_off_reversed;

  PROCEDURE set_exp_rep_write_off_status(p_exp_report_header_id NUMBER,
                                         p_user_id              NUMBER) IS
    v_diff                NUMBER;
    v_sum                 NUMBER;
    v_last_write_off_date DATE;
  BEGIN
    -- 获取此报销单总核销金额
    SELECT nvl(SUM(w.document_write_off_amount), 0)
      INTO v_sum
      FROM csh_write_off w
     WHERE w.document_header_id = p_exp_report_header_id
       AND w.document_source = 'EXPENSE_REPORT';
  
    IF v_sum = 0 THEN
      -- 未核销
      UPDATE exp_report_headers h
         SET h.write_off_status         = c_exp_rep_write_off_status_n,
             h.write_off_completed_date = NULL,
             h.last_update_date         = SYSDATE,
             h.last_updated_by          = p_user_id
       WHERE h.exp_report_header_id = p_exp_report_header_id;
    ELSE
      SELECT nvl(SUM(s.due_amount), 0) - v_sum
        INTO v_diff
        FROM exp_report_pmt_schedules s
       WHERE s.exp_report_header_id = p_exp_report_header_id;
      IF v_diff <= 0 THEN
        v_last_write_off_date := get_last_write_off_date(p_document_source    => 'EXPENSE_REPORT',
                                                         p_document_header_id => p_exp_report_header_id);
        -- 完全核销
        UPDATE exp_report_headers h
           SET h.write_off_status         = c_exp_rep_write_off_status_c,
               h.write_off_completed_date = v_last_write_off_date,
               h.last_update_date         = SYSDATE,
               h.last_updated_by          = p_user_id
         WHERE h.exp_report_header_id = p_exp_report_header_id;
      ELSE
        -- 部分核销
        UPDATE exp_report_headers h
           SET h.write_off_status         = c_exp_rep_write_off_status_y,
               h.write_off_completed_date = NULL,
               h.last_update_date         = SYSDATE,
               h.last_updated_by          = p_user_id
         WHERE h.exp_report_header_id = p_exp_report_header_id;
      END IF;
    END IF;
  END set_exp_rep_write_off_status;

  PROCEDURE set_csh_trx_write_off_status(p_transaction_header_id NUMBER,
                                         p_transaction_line_id   NUMBER,
                                         p_transaction_type      VARCHAR2,
                                         p_user_id               NUMBER) IS
    v_sum_write_off_amt   NUMBER;
    v_transaction_amount  NUMBER;
    v_last_write_off_date DATE;
  
    e_write_off_amount_error EXCEPTION;
  BEGIN
    IF p_transaction_type = 'PAYMENT' THEN
      SELECT nvl(SUM(w.csh_write_off_amount), 0)
        INTO v_sum_write_off_amt
        FROM csh_write_off w
       WHERE w.csh_transaction_line_id = p_transaction_line_id;
    ELSIF p_transaction_type = 'PREPAYMENT' THEN
      SELECT nvl(SUM(w.csh_write_off_amount), 0)
        INTO v_sum_write_off_amt
        FROM csh_write_off w
       WHERE w.csh_transaction_line_id = p_transaction_line_id
         AND w.source_csh_trx_line_id IS NULL;
    END IF;
  
    IF v_sum_write_off_amt = 0 THEN
      UPDATE csh_transaction_headers h
         SET h.write_off_flag           = csh_transaction_pkg.c_trans_write_off_flag_n,
             h.write_off_completed_date = NULL,
             h.last_update_date         = SYSDATE,
             h.last_updated_by          = p_user_id
       WHERE h.transaction_header_id = p_transaction_header_id;
    ELSE
      SELECT l.transaction_amount
        INTO v_transaction_amount
        FROM csh_transaction_lines l
       WHERE l.transaction_line_id = p_transaction_line_id;
    
      IF v_transaction_amount > v_sum_write_off_amt THEN
        UPDATE csh_transaction_headers h
           SET h.write_off_flag           = csh_transaction_pkg.c_trans_write_off_flag_yes,
               h.write_off_completed_date = NULL,
               h.last_update_date         = SYSDATE,
               h.last_updated_by          = p_user_id
         WHERE h.transaction_header_id = p_transaction_header_id;
      ELSIF v_transaction_amount <= v_sum_write_off_amt THEN
        v_last_write_off_date := get_last_write_off_date(p_transaction_line_id => p_transaction_line_id);
        UPDATE csh_transaction_headers h
           SET h.write_off_flag           = csh_transaction_pkg.c_trans_write_off_flag_c,
               h.write_off_completed_date = v_last_write_off_date,
               h.last_update_date         = SYSDATE,
               h.last_updated_by          = p_user_id
         WHERE h.transaction_header_id = p_transaction_header_id;
      ELSE
        RAISE e_write_off_amount_error;
      END IF;
    END IF;
  EXCEPTION
    WHEN e_write_off_amount_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_WRITE_OFF_AMOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'SET_CSH_TRX_WRITE_OFF_STATUS');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END set_csh_trx_write_off_status;

  PROCEDURE reverse_lock(p_csh_trx_header_id NUMBER) IS
    v_exp_report_header_id exp_report_headers.exp_report_header_id%TYPE;
  BEGIN
    SELECT source_header_id
      INTO v_exp_report_header_id
      FROM csh_transaction_headers h
     WHERE h.transaction_header_id = p_csh_trx_header_id
       AND h.reversed_flag IS NULL
       AND h.returned_flag IS NULL
       AND EXISTS
     (SELECT *
              FROM csh_write_off o, csh_transaction_lines l
             WHERE o.write_off_type = 'EXPENSE_REPORT_PAYMENT'
               AND o.document_source = 'EXPENSE_REPORT'
               AND o.csh_transaction_line_id = l.transaction_line_id
               AND l.transaction_header_id = p_csh_trx_header_id)
       FOR UPDATE NOWAIT;
  
    SELECT exp_report_header_id
      INTO v_exp_report_header_id
      FROM exp_report_headers h
     WHERE h.exp_report_header_id = v_exp_report_header_id
       FOR UPDATE NOWAIT;
  END reverse_lock;

  PROCEDURE get_source_csh_trx(p_csh_trx_header_id NUMBER,
                               p_trx_date          OUT DATE,
                               p_company_id        OUT NUMBER) IS
  BEGIN
    SELECT transaction_date, h.company_id
      INTO p_trx_date, p_company_id
      FROM csh_transaction_headers h
     WHERE h.transaction_header_id = p_csh_trx_header_id;
  END get_source_csh_trx;

  FUNCTION get_error_message(p_app_error_line_id NUMBER) RETURN VARCHAR2 IS
    v_message sys_raise_app_errors.message%TYPE;
  BEGIN
    SELECT e.message
      INTO v_message
      FROM sys_raise_app_errors e
     WHERE e.app_error_line_id = p_app_error_line_id;
    RETURN v_message;
  END get_error_message;

  PROCEDURE delete_csh_trx_error_logs(p_batch_id NUMBER) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    DELETE FROM csh_transaction_error_logs l WHERE l.batch_id = p_batch_id;
    COMMIT;
  END delete_csh_trx_error_logs;

  FUNCTION get_source_exp_rep_header_id(p_csh_trx_header_id NUMBER)
    RETURN NUMBER IS
    v_doc_header_id NUMBER;
  BEGIN
    SELECT o.document_header_id
      INTO v_doc_header_id
      FROM csh_write_off o
     WHERE o.document_source = 'EXPENSE_REPORT'
       AND o.write_off_type = 'EXPENSE_REPORT_PAYMENT'
       AND o.csh_transaction_line_id IN
           (SELECT l.transaction_line_id
              FROM csh_transaction_lines l
             WHERE l.transaction_header_id = p_csh_trx_header_id)
     GROUP BY document_header_id;
    RETURN v_doc_header_id;
  END get_source_exp_rep_header_id;

  FUNCTION get_csh_write_off_amount(p_document_header_id NUMBER)
    RETURN NUMBER IS
    v_amount NUMBER;
  BEGIN
    SELECT nvl(SUM(w.document_write_off_amount), 0)
      INTO v_amount
      FROM csh_write_off w
     WHERE w.document_header_id = p_document_header_id;
    RETURN v_amount;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN 0;
  END get_csh_write_off_amount;

  --报销单支付反冲 by bobo
  PROCEDURE reverse_expense_report_payment(p_batch_id          NUMBER,
                                           p_csh_trx_header_id NUMBER,
                                           p_transaction_date  DATE,
                                           p_period_name       VARCHAR2,
                                           p_user_id           NUMBER) IS
    e_trx_date_error         EXCEPTION;
    e_locked_error           EXCEPTION;
    e_post_transaction_error EXCEPTION;
    e_period_closed          EXCEPTION;
    e_trx_num_error          EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_locked_error, -54);
  BEGIN
    csh_transaction_pkg.post_reverse_transaction(p_transaction_header_id => p_csh_trx_header_id,
                                                 p_reverse_date          => p_transaction_date,
                                                 p_user_id               => p_user_id);
  EXCEPTION
    WHEN e_period_closed THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5210_PERIOD_CLOSED',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'REVERSE_EXPENSE_REPORT_PAYMENT');
      error_log(p_batch_id      => p_batch_id,
                p_trx_header_id => p_csh_trx_header_id,
                p_trx_line_id   => '',
                p_message       => get_error_message(sys_raise_app_error_pkg.g_err_line_id),
                p_user_id       => p_user_id);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_post_transaction_error THEN
      error_log(p_batch_id      => p_batch_id,
                p_trx_header_id => p_csh_trx_header_id,
                p_trx_line_id   => '',
                p_message       => get_error_message(sys_raise_app_error_pkg.g_err_line_id),
                p_user_id       => p_user_id);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_trx_num_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5210_CODING_RULE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'REVERSE_EXPENSE_REPORT_PAYMENT');
      error_log(p_batch_id      => p_batch_id,
                p_trx_header_id => p_csh_trx_header_id,
                p_trx_line_id   => '',
                p_message       => get_error_message(sys_raise_app_error_pkg.g_err_line_id),
                p_user_id       => p_user_id);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_trx_date_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5210_REVERSE_DATE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'REVERSE_EXPENSE_REPORT_PAYMENT');
      error_log(p_batch_id      => p_batch_id,
                p_trx_header_id => p_csh_trx_header_id,
                p_trx_line_id   => '',
                p_message       => get_error_message(sys_raise_app_error_pkg.g_err_line_id),
                p_user_id       => p_user_id);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_locked_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_LOCKED_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'REVERSE_EXPENSE_REPORT_PAYMENT');
      error_log(p_batch_id      => p_batch_id,
                p_trx_header_id => p_csh_trx_header_id,
                p_trx_line_id   => '',
                p_message       => get_error_message(sys_raise_app_error_pkg.g_err_line_id),
                p_user_id       => p_user_id);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                     p_procedure_function_name => 'REVERSE_EXPENSE_REPORT_PAYMENT');
      error_log(p_batch_id      => p_batch_id,
                p_trx_header_id => p_csh_trx_header_id,
                p_trx_line_id   => '',
                p_message       => get_error_message(sys_raise_app_error_pkg.g_err_line_id),
                p_user_id       => p_user_id);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END reverse_expense_report_payment;

  PROCEDURE execute_payment_exp_rep(p_rec_csh_write_off        csh_write_off_tmp%ROWTYPE,
                                    p_transaction_header_id    NUMBER,
                                    p_transaction_line_id      NUMBER,
                                    p_functional_currency_code VARCHAR2,
                                    p_set_of_books_id          NUMBER,
                                    p_user_id                  NUMBER) IS
    v_exp_report_header           exp_report_headers%ROWTYPE;
    v_transaction_header          csh_transaction_headers%ROWTYPE;
    v_transaction_line            csh_transaction_lines%ROWTYPE;
    v_contract_header_id          NUMBER;
    v_payment_schedule_line_id    NUMBER;
    v_trx_pmt_schedule_line_id    NUMBER;
    v_write_off_id                NUMBER;
    v_company_id                  NUMBER;
    v_responsibility_center_id    NUMBER;
    v_account_id                  NUMBER;
    v_write_off_amount            NUMBER;
    v_entered_amount              NUMBER;
    v_functional_amount           NUMBER;
    v_exchange_rate_type          gld_exchange_rates.type_code%TYPE;
    v_exchange_rate               NUMBER;
    v_exchange_rate_quotation     gld_exchange_rates.exchange_rate_quotation%TYPE;
    v_error_code                  VARCHAR2(200);
    v_count                       NUMBER;
    v_transaction_je_line_id      NUMBER;
    v_exp_exchange_rate_type      VARCHAR2(30);
    v_exp_exchange_rate_quotation VARCHAR2(30);
    v_exp_exchange_rate           NUMBER;
    v_revaluation                 NUMBER;
    v_employee_name               varchar2(50);
  
    v_description VARCHAR2(500); --modify by wxq 20180418
  
    e_payment_amount_check_error EXCEPTION;
    e_bank_account_error         EXCEPTION;
    e_default_resp_error1        EXCEPTION;
    e_exp_report_account_error   EXCEPTION;
    e_intercompany_ar_account    EXCEPTION;
    e_default_resp_error2        EXCEPTION;
    e_intercompany_ap_account    EXCEPTION;
    e_exchange_rate_type_error   EXCEPTION;
    e_revaluation_account_error  EXCEPTION;
    e_locked_error               EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_locked_error, -54);
  BEGIN
    SELECT h.*
      INTO v_exp_report_header
      FROM exp_report_headers h, exp_report_pmt_schedules s
     WHERE s.exp_report_header_id = h.exp_report_header_id
       AND s.payment_schedule_line_id = p_rec_csh_write_off.document_id
       FOR UPDATE NOWAIT;
  
    SELECT s.company_id
      INTO v_company_id
      FROM exp_report_pmt_schedules s
     WHERE s.payment_schedule_line_id = p_rec_csh_write_off.document_id;
  
    -- 校验核销金额与报销单未核销金额
    v_error_code := check_payment_amount(p_exp_report_header_id     => v_exp_report_header.exp_report_header_id,
                                         p_payment_schedule_line_id => p_rec_csh_write_off.document_id,
                                         p_payment_amount           => p_rec_csh_write_off.write_off_amount);
    IF v_error_code IS NOT NULL THEN
      RAISE e_payment_amount_check_error;
    END IF;
  
    SELECT *
      INTO v_transaction_header
      FROM csh_transaction_headers h
     WHERE h.transaction_header_id = p_transaction_header_id;
  
    SELECT *
      INTO v_transaction_line
      FROM csh_transaction_lines l
     WHERE l.transaction_line_id = p_transaction_line_id;
  
    BEGIN
      SELECT a.exchange_rate_type,
             a.exchange_rate_quotation,
             a.exchange_rate,
             a.description
        INTO v_exp_exchange_rate_type,
             v_exp_exchange_rate_quotation,
             v_exp_exchange_rate,
             v_description --modify by wxq 20180418
        FROM exp_report_accounts a
       WHERE EXISTS (SELECT 1
                FROM exp_report_dists d, exp_report_lines l
               WHERE d.exp_report_dists_id = a.exp_report_dists_id
                 AND d.exp_report_line_id = l.exp_report_line_id
                 AND l.exp_report_header_id =
                     v_exp_report_header.exp_report_header_id)
         AND a.currency_code = v_transaction_line.currency_code
         AND rownum = 1
       GROUP BY a.exchange_rate_type,
                a.exchange_rate_quotation,
                a.exchange_rate,
                a.description;
      --摘要取第一行
      select description
        into v_description
        from (select a.description, l.line_number
                from exp_report_accounts a,
                     exp_report_dists    d,
                     exp_report_lines    l
               where a.exp_report_header_id =
                     v_exp_report_header.exp_report_header_id
                 and a.exp_report_dists_id = d.exp_report_dists_id
                 and l.exp_report_line_id = d.exp_report_line_id
               order by l.line_number)
       where rownum = 1;
    EXCEPTION
      WHEN no_data_found THEN
        v_exp_exchange_rate_type      := v_transaction_line.exchange_rate_type;
        v_exp_exchange_rate_quotation := v_transaction_line.exchange_rate_quotation;
        v_exp_exchange_rate           := v_transaction_line.exchange_rate;
    END;
  
    SELECT e.name
      INTO v_employee_name
      FROM exp_employees e
     WHERE e.employee_id = v_exp_report_header.employee_id;
  
    v_description := '支付【' || v_employee_name || '】报销';
  
    -- 核销金额精度
    v_write_off_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => v_transaction_line.currency_code,
                                                             p_amount          => p_rec_csh_write_off.write_off_amount,
                                                             p_set_of_books_id => p_set_of_books_id);
    v_write_off_id     := get_csh_write_off_id;
    -- 创建核销记录
    insert_csh_write_off(p_write_off_id              => v_write_off_id,
                         p_write_off_type            => p_rec_csh_write_off.write_off_type,
                         p_csh_transaction_line_id   => p_transaction_line_id,
                         p_csh_write_off_amount      => v_write_off_amount,
                         p_document_source           => 'EXPENSE_REPORT',
                         p_document_header_id        => v_exp_report_header.exp_report_header_id,
                         p_document_line_id          => p_rec_csh_write_off.document_id,
                         p_document_write_off_amount => v_write_off_amount,
                         p_write_off_date            => v_transaction_header.transaction_date,
                         p_period_name               => v_transaction_header.period_name,
                         p_source_csh_trx_line_id    => NULL,
                         p_source_write_off_amount   => NULL,
                         p_gld_interface_flag        => c_gld_interface_flag_p,
                         p_user_id                   => p_user_id);
    -- 更新报销单核销状态
    set_exp_rep_write_off_status(p_exp_report_header_id => v_exp_report_header.exp_report_header_id,
                                 p_user_id              => p_user_id);
    -- 更新报销单支付状态
    UPDATE csh_doc_payment_company t
       SET t.payment_status   = 'PAID',
           t.last_update_date = SYSDATE,
           t.last_updated_by  = p_user_id
     WHERE t.document_type = 'EXP_REPORT'
       AND t.document_id = v_exp_report_header.exp_report_header_id
       AND t.document_line_id = p_rec_csh_write_off.document_id;
    -- 插入'跟踪单据'信息
  
    exp_document_history_pkg.insert_exp_document_histories(p_document_type  => exp_report_pkg.c_exp_report, --'EXP_REPORT',
                                                           p_document_id    => v_exp_report_header.exp_report_header_id,
                                                           p_operation_code => exp_document_history_pkg.c_pay, --'PAY',
                                                           p_user_id        => p_user_id,
                                                           p_operation_time => SYSDATE,
                                                           p_description    => '付款交易编号[' ||
                                                                               v_transaction_header.transaction_num ||
                                                                               ']，金额' ||
                                                                               v_write_off_amount);
    -- 关联合同或合同资金计划行
    IF p_rec_csh_write_off.contract_header_id IS NOT NULL THEN
      csh_transaction_pkg.insert_trx_pmt_schedule_line(p_trx_pmt_schedule_line_id => v_trx_pmt_schedule_line_id,
                                                       p_csh_transaction_line_id  => p_transaction_line_id,
                                                       p_payment_schedule_line_id => p_rec_csh_write_off.payment_schedule_line_id,
                                                       p_amount                   => v_write_off_amount,
                                                       p_user_id                  => p_user_id,
                                                       p_contract_header_id       => p_rec_csh_write_off.contract_header_id,
                                                       p_write_off_id             => v_write_off_id);
    ELSE
      BEGIN
        SELECT f.document_id, f.document_line_id
          INTO v_contract_header_id, v_payment_schedule_line_id
          FROM con_document_flows f
         WHERE f.document_type = 'CON_CONTRACT'
           AND f.source_document_type = 'EXP_REPORT_PMT_SCHEDULES'
           AND f.source_document_id =
               v_exp_report_header.exp_report_header_id
           AND f.source_document_line_id = p_rec_csh_write_off.document_id;
        -- 创建con_cash_trx_pmt_schedule_lns记录
        csh_transaction_pkg.insert_trx_pmt_schedule_line(p_trx_pmt_schedule_line_id => v_trx_pmt_schedule_line_id,
                                                         p_csh_transaction_line_id  => p_transaction_line_id,
                                                         p_payment_schedule_line_id => v_payment_schedule_line_id,
                                                         p_amount                   => v_write_off_amount,
                                                         p_user_id                  => p_user_id,
                                                         p_contract_header_id       => v_contract_header_id,
                                                         p_write_off_id             => v_write_off_id);
      EXCEPTION
        WHEN no_data_found THEN
          NULL;
      END;
    END IF;
    -- 判断当前公司贷方凭证是否存在（对应银行存款账户的凭证）
    SELECT COUNT(a.transaction_je_line_id)
      INTO v_count
      FROM csh_transaction_accounts a
     WHERE a.transaction_line_id = p_transaction_line_id
       AND a.company_id = v_transaction_header.company_id
       AND a.entered_amount_dr IS NULL
       AND a.functional_amount_dr IS NULL;
    -- 当前公司贷方凭证不存在
    --IF v_count = 0 THEN
    IF v_transaction_header.company_id = v_company_id THEN
      --获得银行帐户的责任中心，科目
      csh_transaction_pkg.get_bank_acc_and_resp(p_transaction_line_id      => p_transaction_line_id,
                                                p_responsibility_center_id => v_responsibility_center_id,
                                                p_account_id               => v_account_id);
      IF v_responsibility_center_id IS NULL OR v_account_id IS NULL THEN
        RAISE e_bank_account_error;
      END IF;
      -- 原币精度
      v_entered_amount := v_transaction_line.transaction_amount;
      -- 计算本位币金额
      IF v_transaction_line.exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount *
                               v_transaction_line.exchange_rate;
      ELSIF v_transaction_line.exchange_rate_quotation =
            'INDIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount *
                               (1 / v_transaction_line.exchange_rate);
      ELSE
        v_functional_amount := v_entered_amount *
                               v_transaction_line.exchange_rate;
      END IF;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建贷方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq 20180418--v_transaction_line.description,
                                                         p_period_name              => v_transaction_header.period_name,
                                                         p_company_id               => v_transaction_header.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => NULL,
                                                         p_entered_amount_cr        => v_entered_amount,
                                                         p_functional_amount_dr     => NULL,
                                                         p_functional_amount_cr     => v_functional_amount,
                                                         p_exchange_rate_type       => v_transaction_line.exchange_rate_type,
                                                         p_exchange_rate            => v_transaction_line.exchange_rate,
                                                         p_currency_code            => v_transaction_line.currency_code,
                                                         p_journal_date             => v_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => 'Y',
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => NULL,
                                                         p_usage_code               => 'CASH_ACCOUNT',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
      --END IF;
    
      -- 非跨公司
      -- 借方责任中心和科目
      v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => v_transaction_header.company_id);
      IF v_responsibility_center_id IS NULL THEN
        RAISE e_default_resp_error1;
      END IF;
      v_account_id := csh_transaction_pkg.get_exp_report_account(p_payment_schedule_line_id => p_rec_csh_write_off.document_id,
                                                                 p_user_id                  => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_exp_report_account_error;
      END IF;
      -- 原币精度
      v_entered_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => v_transaction_line.currency_code,
                                                             p_amount          => p_rec_csh_write_off.write_off_amount,
                                                             p_set_of_books_id => p_set_of_books_id);
      -- 计算本位币金额
      IF v_exp_exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_exp_exchange_rate;
      ELSIF v_exp_exchange_rate_quotation = 'INDIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               (1 / v_exp_exchange_rate);
      ELSE
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_exp_exchange_rate;
      END IF;
      -- 汇率差异
      IF v_transaction_line.exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_revaluation := p_rec_csh_write_off.write_off_amount *
                         v_transaction_line.exchange_rate;
      ELSIF v_transaction_line.exchange_rate_quotation =
            'INDIRECT QUOTATION' THEN
        v_revaluation := p_rec_csh_write_off.write_off_amount *
                         (1 / v_transaction_line.exchange_rate);
      ELSE
        v_revaluation := p_rec_csh_write_off.write_off_amount *
                         v_transaction_line.exchange_rate;
      END IF;
      v_revaluation := v_revaluation - v_functional_amount;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建借方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq 20180418--v_transaction_line.description,
                                                         p_period_name              => v_transaction_header.period_name,
                                                         p_company_id               => v_transaction_header.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => v_entered_amount,
                                                         p_entered_amount_cr        => NULL,
                                                         p_functional_amount_dr     => v_functional_amount,
                                                         p_functional_amount_cr     => NULL,
                                                         p_exchange_rate_type       => v_exp_exchange_rate_type,
                                                         p_exchange_rate            => v_exp_exchange_rate,
                                                         p_currency_code            => v_transaction_line.currency_code,
                                                         p_journal_date             => v_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'EMPLOYEE_EXPENSE_WRITE_OFF',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
      v_revaluation := 0;
      IF v_revaluation > 0 THEN
        v_account_id := csh_transaction_pkg.get_revaluation_account(p_company_id    => v_transaction_header.company_id,
                                                                    p_currency_code => v_transaction_line.currency_code,
                                                                    p_user_id       => p_user_id);
        IF v_account_id IS NULL THEN
          RAISE e_revaluation_account_error;
        END IF;
        -- 汇率差异精度
        v_revaluation := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                            p_amount          => v_revaluation,
                                                            p_set_of_books_id => p_set_of_books_id);
        -- 创建汇率差异凭证
        csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                           p_distribution_line_id     => NULL,
                                                           p_source_code              => 'CSH_PAYMENT',
                                                           p_description              => v_description,
                                                           p_period_name              => v_transaction_header.period_name,
                                                           p_company_id               => v_transaction_header.company_id,
                                                           p_responsibility_center_id => v_responsibility_center_id,
                                                           p_account_id               => v_account_id,
                                                           p_entered_amount_dr        => 0,
                                                           p_entered_amount_cr        => NULL,
                                                           p_functional_amount_dr     => v_revaluation,
                                                           p_functional_amount_cr     => NULL,
                                                           p_exchange_rate_type       => v_transaction_line.exchange_rate_type,
                                                           p_exchange_rate            => v_transaction_line.exchange_rate,
                                                           p_currency_code            => v_transaction_line.currency_code,
                                                           p_journal_date             => v_transaction_header.transaction_date,
                                                           p_cash_clearing_flag       => NULL,
                                                           p_bank_account_flag        => NULL,
                                                           p_gld_interface_flag       => c_gld_interface_flag_p,
                                                           p_write_off_id             => v_write_off_id,
                                                           p_usage_code               => 'REVALUATION',
                                                           p_user_id                  => p_user_id,
                                                           p_transaction_je_line_id   => v_transaction_je_line_id);
      ELSIF v_revaluation < 0 THEN
        v_account_id := csh_transaction_pkg.get_revaluation_account(p_company_id    => v_transaction_header.company_id,
                                                                    p_currency_code => v_transaction_line.currency_code,
                                                                    p_user_id       => p_user_id);
        IF v_account_id IS NULL THEN
          RAISE e_revaluation_account_error;
        END IF;
        -- 汇率差异精度
        v_revaluation := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                            p_amount          => -1 *
                                                                                 v_revaluation,
                                                            p_set_of_books_id => p_set_of_books_id);
        -- 创建汇率差异凭证
        csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                           p_distribution_line_id     => NULL,
                                                           p_source_code              => 'CSH_PAYMENT',
                                                           p_description              => v_description,
                                                           p_period_name              => v_transaction_header.period_name,
                                                           p_company_id               => v_transaction_header.company_id,
                                                           p_responsibility_center_id => v_responsibility_center_id,
                                                           p_account_id               => v_account_id,
                                                           p_entered_amount_dr        => NULL,
                                                           p_entered_amount_cr        => 0,
                                                           p_functional_amount_dr     => NULL,
                                                           p_functional_amount_cr     => v_revaluation,
                                                           p_exchange_rate_type       => v_transaction_line.exchange_rate_type,
                                                           p_exchange_rate            => v_transaction_line.exchange_rate,
                                                           p_currency_code            => v_transaction_line.currency_code,
                                                           p_journal_date             => v_transaction_header.transaction_date,
                                                           p_cash_clearing_flag       => NULL,
                                                           p_bank_account_flag        => NULL,
                                                           p_gld_interface_flag       => c_gld_interface_flag_p,
                                                           p_write_off_id             => v_write_off_id,
                                                           p_usage_code               => 'REVALUATION',
                                                           p_user_id                  => p_user_id,
                                                           p_transaction_je_line_id   => v_transaction_je_line_id);
      END IF;
    ELSE
      -- 跨公司
      -- 当前公司贷方
      --获得银行帐户的责任中心，科目
      csh_transaction_pkg.get_bank_acc_and_resp(p_transaction_line_id      => p_transaction_line_id,
                                                p_responsibility_center_id => v_responsibility_center_id,
                                                p_account_id               => v_account_id);
      IF v_responsibility_center_id IS NULL OR v_account_id IS NULL THEN
        RAISE e_bank_account_error;
      END IF;
      -- 原币精度
      v_entered_amount := v_transaction_line.transaction_amount;
      -- 计算本位币金额
      IF v_transaction_line.exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount *
                               v_transaction_line.exchange_rate;
      ELSIF v_transaction_line.exchange_rate_quotation =
            'INDIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount *
                               (1 / v_transaction_line.exchange_rate);
      ELSE
        v_functional_amount := v_entered_amount *
                               v_transaction_line.exchange_rate;
      END IF;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建贷方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq 20180418--v_transaction_line.description,
                                                         p_period_name              => v_transaction_header.period_name,
                                                         p_company_id               => v_transaction_header.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => NULL,
                                                         p_entered_amount_cr        => v_entered_amount,
                                                         p_functional_amount_dr     => NULL,
                                                         p_functional_amount_cr     => v_functional_amount,
                                                         p_exchange_rate_type       => v_transaction_line.exchange_rate_type,
                                                         p_exchange_rate            => v_transaction_line.exchange_rate,
                                                         p_currency_code            => v_transaction_line.currency_code,
                                                         p_journal_date             => v_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => 'Y',
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => NULL,
                                                         p_usage_code               => 'CASH_ACCOUNT',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
    
      -- 创建借方凭证
      v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => v_company_id);
      IF v_responsibility_center_id IS NULL THEN
        RAISE e_default_resp_error1;
      END IF;
      v_account_id := csh_transaction_pkg.get_exp_report_account(p_payment_schedule_line_id => p_rec_csh_write_off.document_id,
                                                                 p_user_id                  => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_exp_report_account_error;
      END IF;
      -- 原币精度
      v_entered_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => v_transaction_line.currency_code,
                                                             p_amount          => p_rec_csh_write_off.write_off_amount,
                                                             p_set_of_books_id => p_set_of_books_id);
      -- 计算本位币金额
      IF v_exp_exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_exp_exchange_rate;
      ELSIF v_exp_exchange_rate_quotation = 'INDIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               (1 / v_exp_exchange_rate);
      ELSE
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_exp_exchange_rate;
      END IF;
    
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq 20180418--v_transaction_line.description,
                                                         p_period_name              => v_transaction_header.period_name,
                                                         p_company_id               => v_company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => v_entered_amount,
                                                         p_entered_amount_cr        => NULL,
                                                         p_functional_amount_dr     => v_functional_amount,
                                                         p_functional_amount_cr     => NULL,
                                                         p_exchange_rate_type       => v_exp_exchange_rate_type,
                                                         p_exchange_rate            => v_exp_exchange_rate,
                                                         p_currency_code            => v_transaction_line.currency_code,
                                                         p_journal_date             => v_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'EMPLOYEE_EXPENSE_WRITE_OFF',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
    
      --往来凭证
      /*-- 当前公司借方
      v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => v_transaction_header.company_id);
      IF v_responsibility_center_id IS NULL THEN
        RAISE e_default_resp_error1;
      END IF;
      -- 取内部往来应收科目
      v_account_id := csh_transaction_pkg.get_intercompany_ar_account(p_company_id       => v_transaction_header.company_id,
                                                                      p_opposite_company => v_company_id,
                                                                      p_currency_code    => v_transaction_line.currency_code,
                                                                      p_user_id          => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_intercompany_ar_account;
      END IF;
      -- 原币精度
      v_entered_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => v_transaction_line.currency_code,
                                                             p_amount          => p_rec_csh_write_off.write_off_amount,
                                                             p_set_of_books_id => p_set_of_books_id);
      -- 计算本位币金额
      IF v_transaction_line.exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_transaction_line.exchange_rate;
      ELSIF v_transaction_line.exchange_rate_quotation =
            'INDIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               (1 / v_transaction_line.exchange_rate);
      ELSE
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_transaction_line.exchange_rate;
      END IF;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建借方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq 20180418--v_transaction_line.description,
                                                         p_period_name              => v_transaction_header.period_name,
                                                         p_company_id               => v_transaction_header.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => v_entered_amount,
                                                         p_entered_amount_cr        => NULL,
                                                         p_functional_amount_dr     => v_functional_amount,
                                                         p_functional_amount_cr     => NULL,
                                                         p_exchange_rate_type       => v_transaction_line.exchange_rate_type,
                                                         p_exchange_rate            => v_transaction_line.exchange_rate,
                                                         p_currency_code            => v_transaction_line.currency_code,
                                                         p_journal_date             => v_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'CSH_INTERCOMPANY_AR',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);*/
      -- 对方公司借方
      v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => v_transaction_header.company_id);
      IF v_responsibility_center_id IS NULL THEN
        RAISE e_default_resp_error2;
      END IF;
      -- 取内部往来应收科目
      v_account_id := csh_transaction_pkg.get_intercompany_ar_account(p_company_id       => v_company_id,
                                                                      p_opposite_company => v_transaction_header.company_id,
                                                                      p_currency_code    => v_transaction_line.currency_code,
                                                                      p_user_id          => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_intercompany_ar_account;
      END IF;
      IF v_transaction_line.currency_code = p_functional_currency_code THEN
        v_exchange_rate_type      := NULL;
        v_exchange_rate_quotation := NULL;
        v_exchange_rate           := 1;
      ELSE
        -- 取对方公司默认汇率
        v_exchange_rate_type := sys_parameter_pkg.value(p_parameter_code => 'DEFAULT_EXCHANGE_RATE_TYPE',
                                                        p_company_id     => v_company_id);
        IF v_exchange_rate_type IS NULL THEN
          RAISE e_exchange_rate_type_error;
        END IF;
        gld_exchange_rate_pkg.get_exchange_rate(p_company_id              => v_company_id,
                                                p_from_currency           => p_functional_currency_code,
                                                p_to_currency             => v_transaction_line.currency_code,
                                                p_exchange_rate_type      => v_exchange_rate_type,
                                                p_exchange_date           => v_transaction_header.transaction_date,
                                                p_exchange_period_name    => v_transaction_header.period_name,
                                                p_who_id                  => p_user_id,
                                                p_exchange_rate           => v_exchange_rate,
                                                p_exchange_rate_quotation => v_exchange_rate_quotation);
      END IF;
      -- 计算本位币金额
      IF v_exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_exchange_rate;
      ELSIF v_exchange_rate_quotation = 'INDIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               (1 / v_exchange_rate);
      ELSE
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_exchange_rate;
      END IF;
      -- 汇率差异
      v_revaluation := v_functional_amount;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建对方公司借方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq 20180418--v_transaction_line.description,
                                                         p_period_name              => v_transaction_header.period_name,
                                                         p_company_id               => v_transaction_header.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => v_entered_amount,
                                                         p_entered_amount_cr        => NULL,
                                                         p_functional_amount_dr     => v_functional_amount,
                                                         p_functional_amount_cr     => NULL,
                                                         p_exchange_rate_type       => v_exchange_rate_type,
                                                         p_exchange_rate            => v_exchange_rate,
                                                         p_currency_code            => v_transaction_line.currency_code,
                                                         p_journal_date             => v_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'CSH_INTERCOMPANY_AR',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
    
      ---------------------------------------------往来贷方----------------------------------------
      /*--机构取付款账户机构
      SELECT t.company_id
        into v_company_id
        FROM csh_bank_accounts t, csh_transaction_lines l
       WHERE t.bank_account_id = l.bank_account_id
         AND l.transaction_line_id = v_transaction_line.transaction_line_id;*/
      v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => v_company_id);
      IF v_responsibility_center_id IS NULL THEN
        RAISE e_default_resp_error2;
      END IF;
      -- 取内部往来应付科目
      v_account_id := csh_transaction_pkg.get_intercompany_ap_account(p_company_id       => v_company_id,
                                                                      p_opposite_company => v_transaction_header.company_id,
                                                                      p_currency_code    => v_transaction_line.currency_code,
                                                                      p_user_id          => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_intercompany_ap_account;
      END IF;
      IF v_transaction_line.currency_code = p_functional_currency_code THEN
        v_exchange_rate_type      := NULL;
        v_exchange_rate_quotation := NULL;
        v_exchange_rate           := 1;
      ELSE
        -- 取对方公司默认汇率
        v_exchange_rate_type := sys_parameter_pkg.value(p_parameter_code => 'DEFAULT_EXCHANGE_RATE_TYPE',
                                                        p_company_id     => v_company_id);
        IF v_exchange_rate_type IS NULL THEN
          RAISE e_exchange_rate_type_error;
        END IF;
        gld_exchange_rate_pkg.get_exchange_rate(p_company_id              => v_company_id,
                                                p_from_currency           => p_functional_currency_code,
                                                p_to_currency             => v_transaction_line.currency_code,
                                                p_exchange_rate_type      => v_exchange_rate_type,
                                                p_exchange_date           => v_transaction_header.transaction_date,
                                                p_exchange_period_name    => v_transaction_header.period_name,
                                                p_who_id                  => p_user_id,
                                                p_exchange_rate           => v_exchange_rate,
                                                p_exchange_rate_quotation => v_exchange_rate_quotation);
      END IF;
      -- 计算本位币金额
      IF v_exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_exchange_rate;
      ELSIF v_exchange_rate_quotation = 'INDIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               (1 / v_exchange_rate);
      ELSE
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_exchange_rate;
      END IF;
      -- 汇率差异
      v_revaluation := v_functional_amount;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建贷方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq 20180418--v_transaction_line.description,
                                                         p_period_name              => v_transaction_header.period_name,
                                                         p_company_id               => v_company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => NULL,
                                                         p_entered_amount_cr        => v_entered_amount,
                                                         p_functional_amount_dr     => NULL,
                                                         p_functional_amount_cr     => v_functional_amount,
                                                         p_exchange_rate_type       => v_exchange_rate_type,
                                                         p_exchange_rate            => v_exchange_rate,
                                                         p_currency_code            => v_transaction_line.currency_code,
                                                         p_journal_date             => v_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'CSH_INTERCOMPANY_AP',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
      ---------------------------------------------往来贷方----------------------------------------
      -- 对方公司借方
      /*v_account_id := csh_transaction_pkg.get_exp_report_account(p_payment_schedule_line_id => p_rec_csh_write_off.document_id,
                                                                 p_user_id                  => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_exp_report_account_error;
      END IF;
      -- 计算本位币金额
      IF v_exp_exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_exp_exchange_rate;
      ELSIF v_exp_exchange_rate_quotation = 'INDIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               (1 / v_exp_exchange_rate);
      ELSE
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_exp_exchange_rate;
      END IF;
      -- 汇率差异
      v_revaluation := v_revaluation - v_functional_amount;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建对方公司借方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq 20180418--v_transaction_line.description,
                                                         p_period_name              => v_transaction_header.period_name,
                                                         p_company_id               => v_company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => v_entered_amount,
                                                         p_entered_amount_cr        => NULL,
                                                         p_functional_amount_dr     => v_functional_amount,
                                                         p_functional_amount_cr     => NULL,
                                                         p_exchange_rate_type       => v_exp_exchange_rate_type,
                                                         p_exchange_rate            => v_exp_exchange_rate,
                                                         p_currency_code            => v_transaction_line.currency_code,
                                                         p_journal_date             => v_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'EMPLOYEE_EXPENSE_WRITE_OFF',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);*/
      v_revaluation := 0;
      IF v_revaluation > 0 THEN
        v_account_id := csh_transaction_pkg.get_revaluation_account(p_company_id    => v_company_id,
                                                                    p_currency_code => v_transaction_line.currency_code,
                                                                    p_user_id       => p_user_id);
        IF v_account_id IS NULL THEN
          RAISE e_revaluation_account_error;
        END IF;
        -- 汇率差异精度
        v_revaluation := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                            p_amount          => v_revaluation,
                                                            p_set_of_books_id => p_set_of_books_id);
        -- 创建汇率差异凭证
        csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                           p_distribution_line_id     => NULL,
                                                           p_source_code              => 'CSH_PAYMENT',
                                                           p_description              => v_transaction_line.description,
                                                           p_period_name              => v_transaction_header.period_name,
                                                           p_company_id               => v_company_id,
                                                           p_responsibility_center_id => v_responsibility_center_id,
                                                           p_account_id               => v_account_id,
                                                           p_entered_amount_dr        => 0,
                                                           p_entered_amount_cr        => NULL,
                                                           p_functional_amount_dr     => v_revaluation,
                                                           p_functional_amount_cr     => NULL,
                                                           p_exchange_rate_type       => v_transaction_line.exchange_rate_type,
                                                           p_exchange_rate            => v_transaction_line.exchange_rate,
                                                           p_currency_code            => v_transaction_line.currency_code,
                                                           p_journal_date             => v_transaction_header.transaction_date,
                                                           p_cash_clearing_flag       => NULL,
                                                           p_bank_account_flag        => NULL,
                                                           p_gld_interface_flag       => c_gld_interface_flag_p,
                                                           p_write_off_id             => v_write_off_id,
                                                           p_usage_code               => 'REVALUATION',
                                                           p_user_id                  => p_user_id,
                                                           p_transaction_je_line_id   => v_transaction_je_line_id);
      ELSIF v_revaluation < 0 THEN
        v_account_id := csh_transaction_pkg.get_revaluation_account(p_company_id    => v_company_id,
                                                                    p_currency_code => v_transaction_line.currency_code,
                                                                    p_user_id       => p_user_id);
        IF v_account_id IS NULL THEN
          RAISE e_revaluation_account_error;
        END IF;
        -- 汇率差异精度
        v_revaluation := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                            p_amount          => -1 *
                                                                                 v_revaluation,
                                                            p_set_of_books_id => p_set_of_books_id);
        -- 创建汇率差异凭证
        csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                           p_distribution_line_id     => NULL,
                                                           p_source_code              => 'CSH_PAYMENT',
                                                           p_description              => v_transaction_line.description,
                                                           p_period_name              => v_transaction_header.period_name,
                                                           p_company_id               => v_company_id,
                                                           p_responsibility_center_id => v_responsibility_center_id,
                                                           p_account_id               => v_account_id,
                                                           p_entered_amount_dr        => NULL,
                                                           p_entered_amount_cr        => 0,
                                                           p_functional_amount_dr     => NULL,
                                                           p_functional_amount_cr     => v_revaluation,
                                                           p_exchange_rate_type       => v_transaction_line.exchange_rate_type,
                                                           p_exchange_rate            => v_transaction_line.exchange_rate,
                                                           p_currency_code            => v_transaction_line.currency_code,
                                                           p_journal_date             => v_transaction_header.transaction_date,
                                                           p_cash_clearing_flag       => NULL,
                                                           p_bank_account_flag        => NULL,
                                                           p_gld_interface_flag       => c_gld_interface_flag_p,
                                                           p_write_off_id             => v_write_off_id,
                                                           p_usage_code               => 'REVALUATION',
                                                           p_user_id                  => p_user_id,
                                                           p_transaction_je_line_id   => v_transaction_je_line_id);
      END IF;
    END IF;
    -- 调整尾差
    csh_transaction_pkg.set_balance(p_transaction_line_id => p_transaction_line_id);
    /*-- 生成凭证后，插入预置事件
    csh_evt_pkg.fire_workflow_event(p_event_name          => 'CSH_PAYMENT_CREATE_ACCOUNTS',
                                    p_transaction_line_id => p_transaction_line_id,
                                    p_write_off_id        => v_write_off_id,
                                    p_source_module       => 'CSH_PAYMENT',
                                    p_event_type          => 'CSH_PAYMENT_CREATE_ACCOUNTS',
                                    p_user_id             => p_user_id);*/
  EXCEPTION
    WHEN e_locked_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_LOCKED_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_payment_amount_check_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_error_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_bank_account_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_BANK_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_default_resp_error1 THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_DEFAULT_RESP_ERROR1',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_exp_report_account_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_EXP_REPORT_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_intercompany_ar_account THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_INTERCOMPANY_AR_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_default_resp_error2 THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_DEFAULT_RESP_ERROR2',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_intercompany_ap_account THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_INTERCOMPANY_AP_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_exchange_rate_type_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_EXCHANGE_RATE_TYPE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_revaluation_account_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_REVALUATION_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END execute_payment_exp_rep;

  PROCEDURE execute_payment_prepayment(p_rec_csh_write_off        csh_write_off_tmp%ROWTYPE,
                                       p_transaction_header_id    NUMBER,
                                       p_transaction_line_id      NUMBER,
                                       p_functional_currency_code VARCHAR2,
                                       p_set_of_books_id          NUMBER,
                                       p_user_id                  NUMBER) IS
    v_transaction_header         csh_transaction_headers%ROWTYPE;
    v_transaction_line           csh_transaction_lines%ROWTYPE;
    v_trx_pmt_schedule_line_id   NUMBER;
    v_write_off_id               NUMBER;
    v_payment_requisition_ref_id NUMBER;
    v_enabled_write_off_flag     VARCHAR2(1);
    v_contract_header_id         NUMBER;
    v_transaction_header_id      NUMBER;
    v_transaction_line_id        NUMBER;
    v_responsibility_center_id   NUMBER;
    v_account_id                 NUMBER;
    v_transaction_amount         NUMBER;
    v_entered_amount             NUMBER;
    v_functional_amount          NUMBER;
    v_exchange_rate_type         gld_exchange_rates.type_code%TYPE;
    v_exchange_rate              NUMBER;
    v_exchange_rate_quotation    gld_exchange_rates.exchange_rate_quotation%TYPE;
    v_count                      NUMBER;
    v_transaction_je_line_id     NUMBER;
    v_payment_req_header_id      NUMBER;
  
    v_description   VARCHAR2(200);
    v_employee_name VARCHAR2(200);
    v_line_desc     VARCHAR2(240);
    v_company_id    number;
  
    e_bank_account_error       EXCEPTION;
    e_default_resp_error1      EXCEPTION;
    e_prepayment_account_error EXCEPTION;
    e_intercompany_ar_account  EXCEPTION;
    e_default_resp_error2      EXCEPTION;
    e_intercompany_ap_account  EXCEPTION;
    e_exchange_rate_type_error EXCEPTION;
  BEGIN
    SELECT *
      INTO v_transaction_header
      FROM csh_transaction_headers h
     WHERE h.transaction_header_id = p_transaction_header_id;
  
    SELECT *
      INTO v_transaction_line
      FROM csh_transaction_lines l
     WHERE l.transaction_line_id = p_transaction_line_id;
  
    SELECT c.enabled_write_off_flag
      INTO v_enabled_write_off_flag
      FROM csh_transaction_classes c
     WHERE c.csh_transaction_class_code =
           p_rec_csh_write_off.transaction_class;
  
    v_contract_header_id := NULL;
    -- 生成预付款现金事务
    v_transaction_header_id := csh_transaction_pkg.get_csh_transaction_header_id;
    v_transaction_line_id   := csh_transaction_pkg.get_csh_transaction_line_id;
    -- 预付款事务金额等于核销金额
    v_transaction_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => v_transaction_line.currency_code,
                                                               p_amount          => p_rec_csh_write_off.write_off_amount,
                                                               p_set_of_books_id => p_set_of_books_id);
    -- 创建事务头
    csh_transaction_pkg.insert_csh_transaction_header(p_company_id               => p_rec_csh_write_off.company_id,
                                                      p_transaction_header_id    => v_transaction_header_id,
                                                      p_transaction_type         => 'PREPAYMENT',
                                                      p_transaction_date         => v_transaction_header.transaction_date,
                                                      p_period_name              => v_transaction_header.period_name,
                                                      p_payment_method_id        => v_transaction_header.payment_method_id,
                                                      p_transaction_category     => v_transaction_header.transaction_category,
                                                      p_posted_flag              => csh_transaction_pkg.c_trans_posted_flag_yes,
                                                      p_reversed_flag            => NULL,
                                                      p_reversed_date            => NULL,
                                                      p_returned_flag            => csh_transaction_pkg.c_trans_return_flag_no,
                                                      p_write_off_flag           => csh_transaction_pkg.c_trans_write_off_flag_n,
                                                      p_write_off_completed_date => NULL,
                                                      p_source_header_id         => NULL,
                                                      p_gld_interface_flag       => c_gld_interface_flag_p,
                                                      p_transaction_class        => p_rec_csh_write_off.transaction_class,
                                                      p_enabled_write_off_flag   => v_enabled_write_off_flag,
                                                      p_contract_header_id       => v_contract_header_id,
                                                      p_user_id                  => p_user_id,
                                                      p_source_payment_header_id => p_transaction_header_id);
    -- 创建事务行
    csh_transaction_pkg.insert_csh_transaction_line(p_transaction_header_id   => v_transaction_header_id,
                                                    p_transaction_line_id     => v_transaction_line_id,
                                                    p_transaction_amount      => v_transaction_amount,
                                                    p_currency_code           => v_transaction_line.currency_code,
                                                    p_exchange_rate_type      => v_transaction_line.exchange_rate_type,
                                                    p_exchange_rate           => v_transaction_line.exchange_rate,
                                                    p_bank_account_id         => v_transaction_line.bank_account_id,
                                                    p_document_num            => v_transaction_line.document_num,
                                                    p_partner_category        => v_transaction_line.partner_category,
                                                    p_partner_id              => v_transaction_line.partner_id,
                                                    p_partner_bank_account_id => v_transaction_line.partner_bank_account_id,
                                                    p_description             => v_transaction_line.description,
                                                    p_handling_charge         => v_transaction_line.handling_charge,
                                                    p_exchange_rate_quotation => v_transaction_line.exchange_rate_quotation,
                                                    p_agent_employee_id       => v_transaction_line.agent_employee_id,
                                                    p_user_id                 => p_user_id);
    v_write_off_id := get_csh_write_off_id;
    -- 创建核销记录
    insert_csh_write_off(p_write_off_id              => v_write_off_id,
                         p_write_off_type            => p_rec_csh_write_off.write_off_type,
                         p_csh_transaction_line_id   => p_transaction_line_id,
                         p_csh_write_off_amount      => v_transaction_amount,
                         p_document_source           => NULL,
                         p_document_header_id        => NULL,
                         p_document_line_id          => NULL,
                         p_document_write_off_amount => NULL,
                         p_write_off_date            => v_transaction_header.transaction_date,
                         p_period_name               => v_transaction_header.period_name,
                         p_source_csh_trx_line_id    => v_transaction_line_id,
                         p_source_write_off_amount   => v_transaction_amount,
                         p_gld_interface_flag        => c_gld_interface_flag_p,
                         p_user_id                   => p_user_id);
    -- 借款申请
    IF p_rec_csh_write_off.payment_requisition_line_id IS NOT NULL THEN
      csh_transaction_pkg.insert_csh_payment_req_refs(p_payment_requisition_ref_id  => v_payment_requisition_ref_id,
                                                      p_payment_requisition_line_id => p_rec_csh_write_off.payment_requisition_line_id,
                                                      p_csh_transaction_line_id     => p_transaction_line_id,
                                                      p_write_off_flag              => NULL,
                                                      p_write_off_id                => v_write_off_id,
                                                      p_amount                      => v_transaction_amount,
                                                      p_description                 => NULL,
                                                      p_user_id                     => p_user_id);
    
      -- 插入'跟踪单据'信息
      SELECT l.payment_requisition_header_id
        INTO v_payment_req_header_id
        FROM csh_payment_requisition_lns l
       WHERE l.payment_requisition_line_id =
             p_rec_csh_write_off.payment_requisition_line_id;
    
      --借款凭证行摘取：借款人+‘预支’+行说明 modify by wxq 20180419
      SELECT e.name, l.description
        INTO v_employee_name, v_line_desc
        FROM csh_payment_requisition_lns l,
             csh_payment_requisition_hds h,
             exp_employees               e
       WHERE l.payment_requisition_line_id =
             p_rec_csh_write_off.payment_requisition_line_id
         AND l.payment_requisition_header_id =
             h.payment_requisition_header_id
         AND h.employee_id = e.employee_id;
      v_description := '支付【' || v_employee_name || '】借款';
    
      exp_document_history_pkg.insert_exp_document_histories(p_document_type  => csh_payment_requisition_pkg.c_payment_requisition, --'PAYMENT_REQUISITION',
                                                             p_document_id    => v_payment_req_header_id,
                                                             p_operation_code => exp_document_history_pkg.c_pay, --'PAY',
                                                             p_user_id        => p_user_id,
                                                             p_operation_time => SYSDATE,
                                                             p_description    => '现金事务编号[' ||
                                                                                 v_transaction_header.transaction_num ||
                                                                                 '],金额:' ||
                                                                                 v_transaction_amount ||
                                                                                 ' 借款申请单行ID:' ||
                                                                                 p_rec_csh_write_off.payment_requisition_line_id);
    END IF;
    -- 合同资金计划行
    IF p_rec_csh_write_off.contract_header_id IS NOT NULL THEN
      csh_transaction_pkg.insert_trx_pmt_schedule_line(p_trx_pmt_schedule_line_id => v_trx_pmt_schedule_line_id,
                                                       p_csh_transaction_line_id  => p_transaction_line_id,
                                                       p_payment_schedule_line_id => p_rec_csh_write_off.payment_schedule_line_id,
                                                       p_amount                   => v_transaction_amount,
                                                       p_user_id                  => p_user_id,
                                                       p_contract_header_id       => p_rec_csh_write_off.contract_header_id,
                                                       p_write_off_id             => v_write_off_id);
    END IF;
  
    -- 判断当前公司贷方凭证是否存在（对应银行存款账户的凭证）
    SELECT COUNT(a.transaction_je_line_id)
      INTO v_count
      FROM csh_transaction_accounts a
     WHERE a.transaction_line_id = p_transaction_line_id
       AND a.company_id = v_transaction_header.company_id
       AND a.entered_amount_dr IS NULL
       AND a.functional_amount_dr IS NULL;
    -- 当前公司贷方凭证不存在
    IF v_count = 0 THEN
      --获得银行帐户的责任中心，科目
      csh_transaction_pkg.get_bank_acc_and_resp(p_transaction_line_id      => p_transaction_line_id,
                                                p_responsibility_center_id => v_responsibility_center_id,
                                                p_account_id               => v_account_id);
      IF v_responsibility_center_id IS NULL OR v_account_id IS NULL THEN
        RAISE e_bank_account_error;
      END IF;
      -- 原币精度
      v_entered_amount := v_transaction_line.transaction_amount;
      -- 计算本位币金额
      IF v_transaction_line.exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount *
                               v_transaction_line.exchange_rate;
      ELSIF v_transaction_line.exchange_rate_quotation =
            'INDIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount *
                               (1 / v_transaction_line.exchange_rate);
      ELSE
        v_functional_amount := v_entered_amount *
                               v_transaction_line.exchange_rate;
      END IF;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建贷方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq 20180419 --v_transaction_line.description,
                                                         p_period_name              => v_transaction_header.period_name,
                                                         p_company_id               => v_transaction_header.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => NULL,
                                                         p_entered_amount_cr        => v_entered_amount,
                                                         p_functional_amount_dr     => NULL,
                                                         p_functional_amount_cr     => v_functional_amount,
                                                         p_exchange_rate_type       => v_transaction_line.exchange_rate_type,
                                                         p_exchange_rate            => v_transaction_line.exchange_rate,
                                                         p_currency_code            => v_transaction_line.currency_code,
                                                         p_journal_date             => v_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => 'Y',
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => NULL,
                                                         p_usage_code               => 'CASH_ACCOUNT',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
    END IF;
    IF v_transaction_header.company_id = p_rec_csh_write_off.company_id THEN
      -- 非跨公司
      -- 借方责任中心和科目
      v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => v_transaction_header.company_id);
      IF v_responsibility_center_id IS NULL THEN
        RAISE e_default_resp_error1;
      END IF; --get_clearing_account
      /*v_account_id := csh_transaction_pkg.get_prepayment_account(p_transaction_line_id => v_transaction_line_id,
      p_user_id             => p_user_id);*/
      v_account_id := csh_transaction_pkg.get_clearing_account(p_transaction_line_id => v_transaction_line_id,
                                                               p_user_id             => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_prepayment_account_error; -- 未能取到借款单清算科目
      END IF;
      -- 原币精度
      v_entered_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => v_transaction_line.currency_code,
                                                             p_amount          => p_rec_csh_write_off.write_off_amount,
                                                             p_set_of_books_id => p_set_of_books_id);
      -- 计算本位币金额
      IF v_transaction_line.exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_transaction_line.exchange_rate;
      ELSIF v_transaction_line.exchange_rate_quotation =
            'INDIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               (1 / v_transaction_line.exchange_rate);
      ELSE
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_transaction_line.exchange_rate;
      END IF;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建借方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq 20180419 --v_transaction_line.description,
                                                         p_period_name              => v_transaction_header.period_name,
                                                         p_company_id               => v_transaction_header.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => v_entered_amount,
                                                         p_entered_amount_cr        => NULL,
                                                         p_functional_amount_dr     => v_functional_amount,
                                                         p_functional_amount_cr     => NULL,
                                                         p_exchange_rate_type       => v_transaction_line.exchange_rate_type,
                                                         p_exchange_rate            => v_transaction_line.exchange_rate,
                                                         p_currency_code            => v_transaction_line.currency_code,
                                                         p_journal_date             => v_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'PREPAYMENT',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
    ELSE
      -- 跨公司
      -- 当前公司借方
      /*v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => v_transaction_header.company_id);
      IF v_responsibility_center_id IS NULL THEN
        RAISE e_default_resp_error1;
      END IF;
      -- 取内部往来应收科目
      v_account_id := csh_transaction_pkg.get_intercompany_ar_account(p_company_id       => v_transaction_header.company_id,
                                                                      p_opposite_company => p_rec_csh_write_off.company_id,
                                                                      p_currency_code    => v_transaction_line.currency_code,
                                                                      p_user_id          => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_intercompany_ar_account;
      END IF;
      -- 原币精度
      v_entered_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => v_transaction_line.currency_code,
                                                             p_amount          => p_rec_csh_write_off.write_off_amount,
                                                             p_set_of_books_id => p_set_of_books_id);
      -- 计算本位币金额
      IF v_transaction_line.exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_transaction_line.exchange_rate;
      ELSIF v_transaction_line.exchange_rate_quotation =
            'INDIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               (1 / v_transaction_line.exchange_rate);
      ELSE
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_transaction_line.exchange_rate;
      END IF;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建借方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq 20180419 --v_transaction_line.description,
                                                         p_period_name              => v_transaction_header.period_name,
                                                         p_company_id               => v_transaction_header.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => v_entered_amount,
                                                         p_entered_amount_cr        => NULL,
                                                         p_functional_amount_dr     => v_functional_amount,
                                                         p_functional_amount_cr     => NULL,
                                                         p_exchange_rate_type       => v_transaction_line.exchange_rate_type,
                                                         p_exchange_rate            => v_transaction_line.exchange_rate,
                                                         p_currency_code            => v_transaction_line.currency_code,
                                                         p_journal_date             => v_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'CSH_INTERCOMPANY_AR',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);*/
    
      -- 借方责任中心和科目
      v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => p_rec_csh_write_off.company_id);
      IF v_responsibility_center_id IS NULL THEN
        RAISE e_default_resp_error1;
      END IF;
      v_account_id := csh_transaction_pkg.get_clearing_account(p_transaction_line_id => v_transaction_line_id,
                                                               p_user_id             => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_prepayment_account_error; -- 未能取到借款单清算科目
      END IF;
    
      -- 原币精度
      v_entered_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => v_transaction_line.currency_code,
                                                             p_amount          => p_rec_csh_write_off.write_off_amount,
                                                             p_set_of_books_id => p_set_of_books_id);
      -- 计算本位币金额
      IF v_transaction_line.exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_transaction_line.exchange_rate;
      ELSIF v_transaction_line.exchange_rate_quotation =
            'INDIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               (1 / v_transaction_line.exchange_rate);
      ELSE
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_transaction_line.exchange_rate;
      END IF;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建借方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq 20180419 --v_transaction_line.description,
                                                         p_period_name              => v_transaction_header.period_name,
                                                         p_company_id               => p_rec_csh_write_off.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => v_entered_amount,
                                                         p_entered_amount_cr        => NULL,
                                                         p_functional_amount_dr     => v_functional_amount,
                                                         p_functional_amount_cr     => NULL,
                                                         p_exchange_rate_type       => v_transaction_line.exchange_rate_type,
                                                         p_exchange_rate            => v_transaction_line.exchange_rate,
                                                         p_currency_code            => v_transaction_line.currency_code,
                                                         p_journal_date             => v_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'PREPAYMENT',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
    
      ----------------------------------往借贷方------------------------------------------
      --机构取付款账户机构
      /* SELECT t.company_id
       into v_company_id
       FROM csh_bank_accounts t, csh_transaction_lines l
      WHERE t.bank_account_id = l.bank_account_id
        AND l.transaction_line_id = v_transaction_line.transaction_line_id;*/
      v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => v_transaction_header.company_id);
      IF v_responsibility_center_id IS NULL THEN
        RAISE e_default_resp_error2;
      END IF;
      -- 取内部往来应付科目
      v_account_id := csh_transaction_pkg.get_intercompany_ar_account(p_company_id       => p_rec_csh_write_off.company_id,
                                                                      p_opposite_company => v_transaction_header.company_id,
                                                                      p_currency_code    => v_transaction_line.currency_code,
                                                                      p_user_id          => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_intercompany_ar_account;
      END IF;
      IF v_transaction_line.currency_code = p_functional_currency_code THEN
        v_exchange_rate_type      := NULL;
        v_exchange_rate_quotation := NULL;
        v_exchange_rate           := 1;
      ELSE
        -- 取对方公司默认汇率
        v_exchange_rate_type := sys_parameter_pkg.value(p_parameter_code => 'DEFAULT_EXCHANGE_RATE_TYPE',
                                                        p_company_id     => v_transaction_header.company_id);
        IF v_exchange_rate_type IS NULL THEN
          RAISE e_exchange_rate_type_error;
        END IF;
        gld_exchange_rate_pkg.get_exchange_rate(p_company_id              => p_rec_csh_write_off.company_id,
                                                p_from_currency           => p_functional_currency_code,
                                                p_to_currency             => v_transaction_line.currency_code,
                                                p_exchange_rate_type      => v_exchange_rate_type,
                                                p_exchange_date           => v_transaction_header.transaction_date,
                                                p_exchange_period_name    => v_transaction_header.period_name,
                                                p_who_id                  => p_user_id,
                                                p_exchange_rate           => v_exchange_rate,
                                                p_exchange_rate_quotation => v_exchange_rate_quotation);
      END IF;
      -- 计算本位币金额
      IF v_exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_exchange_rate;
      ELSIF v_exchange_rate_quotation = 'INDIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               (1 / v_exchange_rate);
      ELSE
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_exchange_rate;
      END IF;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建借方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq 20180419 --v_transaction_line.description,
                                                         p_period_name              => v_transaction_header.period_name,
                                                         p_company_id               => v_transaction_header.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => v_entered_amount,
                                                         p_entered_amount_cr        => NULL,
                                                         p_functional_amount_dr     => v_functional_amount,
                                                         p_functional_amount_cr     => NULL,
                                                         p_exchange_rate_type       => v_exchange_rate_type,
                                                         p_exchange_rate            => v_exchange_rate,
                                                         p_currency_code            => v_transaction_line.currency_code,
                                                         p_journal_date             => v_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'CSH_INTERCOMPANY_AR',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
      -------------------------------------往来贷方---------------------------------------
    
      -- 收方公司贷方
      v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => p_rec_csh_write_off.company_id);
      IF v_responsibility_center_id IS NULL THEN
        RAISE e_default_resp_error2;
      END IF;
      -- 取内部往来应付科目
      v_account_id := csh_transaction_pkg.get_intercompany_ap_account(p_company_id       => p_rec_csh_write_off.company_id,
                                                                      p_opposite_company => v_transaction_header.company_id,
                                                                      p_currency_code    => v_transaction_line.currency_code,
                                                                      p_user_id          => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_intercompany_ap_account;
      END IF;
      IF v_transaction_line.currency_code = p_functional_currency_code THEN
        v_exchange_rate_type      := NULL;
        v_exchange_rate_quotation := NULL;
        v_exchange_rate           := 1;
      ELSE
        -- 取对方公司默认汇率
        v_exchange_rate_type := sys_parameter_pkg.value(p_parameter_code => 'DEFAULT_EXCHANGE_RATE_TYPE',
                                                        p_company_id     => p_rec_csh_write_off.company_id);
        IF v_exchange_rate_type IS NULL THEN
          RAISE e_exchange_rate_type_error;
        END IF;
        gld_exchange_rate_pkg.get_exchange_rate(p_company_id              => p_rec_csh_write_off.company_id,
                                                p_from_currency           => p_functional_currency_code,
                                                p_to_currency             => v_transaction_line.currency_code,
                                                p_exchange_rate_type      => v_exchange_rate_type,
                                                p_exchange_date           => v_transaction_header.transaction_date,
                                                p_exchange_period_name    => v_transaction_header.period_name,
                                                p_who_id                  => p_user_id,
                                                p_exchange_rate           => v_exchange_rate,
                                                p_exchange_rate_quotation => v_exchange_rate_quotation);
      END IF;
      -- 计算本位币金额
      IF v_exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_exchange_rate;
      ELSIF v_exchange_rate_quotation = 'INDIRECT QUOTATION' THEN
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               (1 / v_exchange_rate);
      ELSE
        v_functional_amount := p_rec_csh_write_off.write_off_amount *
                               v_exchange_rate;
      END IF;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建对方公司贷方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq 20180419 --v_transaction_line.description,
                                                         p_period_name              => v_transaction_header.period_name,
                                                         p_company_id               => p_rec_csh_write_off.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => NULL,
                                                         p_entered_amount_cr        => v_entered_amount,
                                                         p_functional_amount_dr     => NULL,
                                                         p_functional_amount_cr     => v_functional_amount,
                                                         p_exchange_rate_type       => v_exchange_rate_type,
                                                         p_exchange_rate            => v_exchange_rate,
                                                         p_currency_code            => v_transaction_line.currency_code,
                                                         p_journal_date             => v_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'CSH_INTERCOMPANY_AP',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
      /*-- 对方公司借方
      v_account_id := csh_transaction_pkg.get_prepayment_account(p_transaction_line_id => v_transaction_line_id,
                                                                 p_user_id             => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_prepayment_account_error; -- 未能取到预付款科目
      END IF;
      -- 创建对方公司借方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq 20180419 --v_transaction_line.description,
                                                         p_period_name              => v_transaction_header.period_name,
                                                         p_company_id               => p_rec_csh_write_off.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => v_entered_amount,
                                                         p_entered_amount_cr        => NULL,
                                                         p_functional_amount_dr     => v_functional_amount,
                                                         p_functional_amount_cr     => NULL,
                                                         p_exchange_rate_type       => v_exchange_rate_type,
                                                         p_exchange_rate            => v_exchange_rate,
                                                         p_currency_code            => v_transaction_line.currency_code,
                                                         p_journal_date             => v_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'PREPAYMENT',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);*/
    END IF;
    -- 调整尾差
    csh_transaction_pkg.set_balance(p_transaction_line_id => p_transaction_line_id);
    -- 生成凭证后，插入预置事件
    /*csh_evt_pkg.fire_workflow_event(p_event_name          => 'CSH_PAYMENT_CREATE_ACCOUNTS',
    p_transaction_line_id => p_transaction_line_id,
    p_write_off_id        => v_write_off_id,
    p_source_module       => 'CSH_PAYMENT',
    p_event_type          => 'CSH_PAYMENT_CREATE_ACCOUNTS',
    p_user_id             => p_user_id);*/
  EXCEPTION
    WHEN e_bank_account_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_BANK_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PAYMENT_PREPAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_default_resp_error1 THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_DEFAULT_RESP_ERROR1',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PAYMENT_PREPAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_prepayment_account_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_PREPAYMENT_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PAYMENT_PREPAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_intercompany_ar_account THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_INTERCOMPANY_AR_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PAYMENT_PREPAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_default_resp_error2 THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_DEFAULT_RESP_ERROR2',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PAYMENT_PREPAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_intercompany_ap_account THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_INTERCOMPANY_AP_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PAYMENT_PREPAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_exchange_rate_type_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_EXCHANGE_RATE_TYPE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PAYMENT_PREPAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END execute_payment_prepayment;

  PROCEDURE execute_prepayment_exp_rep(p_rec_csh_write_off        csh_write_off_tmp%ROWTYPE,
                                       p_transaction_header_id    NUMBER,
                                       p_transaction_line_id      NUMBER,
                                       p_functional_currency_code VARCHAR2,
                                       p_set_of_books_id          NUMBER,
                                       p_user_id                  NUMBER) IS
    v_exp_report_header           exp_report_headers%ROWTYPE;
    v_transaction_header          csh_transaction_headers%ROWTYPE;
    v_transaction_line            csh_transaction_lines%ROWTYPE;
    v_write_off_id                NUMBER;
    v_responsibility_center_id    NUMBER;
    v_account_id                  NUMBER;
    v_write_off_amount            NUMBER;
    v_entered_amount              NUMBER;
    v_functional_amount           NUMBER;
    v_period_name                 gld_periods.period_name%TYPE;
    v_error_code                  VARCHAR2(200);
    v_gld_interface_flag          VARCHAR2(1);
    v_write_off_je_line_id        NUMBER;
    v_exp_exchange_rate_type      VARCHAR2(30);
    v_exp_exchange_rate_quotation VARCHAR2(30);
    v_exp_exchange_rate           NUMBER;
    v_revaluation                 NUMBER;
    v_pay_req_je_line_id          NUMBER;
    v_exp_rep_je_line_id          NUMBER;
    v_pay_req_account             csh_payment_req_accounts%ROWTYPE;
    v_exp_rep_account             exp_report_accounts%ROWTYPE;
    v_description                 exp_report_accounts.description%TYPE;
  
    v_payment_req_line_id NUMBER;
    v_company_id          number;
  
    v_related_transactions       VARCHAR2(30);
    v_responsibility_center_code VARCHAR2(30);
    v_company_code               VARCHAR2(30);
    v_employee_name              VARCHAR2(50);
  
    e_payment_amount_check_error EXCEPTION;
    e_period_error               EXCEPTION;
    e_default_resp_error         EXCEPTION;
    e_exp_report_account_error   EXCEPTION;
    e_prepayment_account_error   EXCEPTION;
    e_revaluation_account_error  EXCEPTION;
    e_locked_error               EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_locked_error, -54);
  BEGIN
    SELECT h.*
      INTO v_exp_report_header
      FROM exp_report_headers h, exp_report_pmt_schedules s
     WHERE s.exp_report_header_id = h.exp_report_header_id
       AND s.payment_schedule_line_id = p_rec_csh_write_off.document_id
       FOR UPDATE NOWAIT;
  
    IF v_exp_report_header.audit_flag = 'Y' THEN
      v_gld_interface_flag := c_gld_interface_flag_p;
    ELSE
      v_gld_interface_flag := c_gld_interface_flag_n;
    END IF;
  
    -- 校验核销金额与报销单未核销金额
    v_error_code := check_payment_amount(p_exp_report_header_id     => v_exp_report_header.exp_report_header_id,
                                         p_payment_schedule_line_id => p_rec_csh_write_off.document_id,
                                         p_payment_amount           => p_rec_csh_write_off.write_off_amount);
    IF v_error_code IS NOT NULL THEN
      RAISE e_payment_amount_check_error;
    END IF;
  
    SELECT *
      INTO v_transaction_header
      FROM csh_transaction_headers h
     WHERE h.transaction_header_id = p_transaction_header_id;
  
    SELECT *
      INTO v_transaction_line
      FROM csh_transaction_lines l
     WHERE l.transaction_line_id = p_transaction_line_id;
  
    BEGIN
      SELECT a.exchange_rate_type,
             a.exchange_rate_quotation,
             a.exchange_rate
        INTO v_exp_exchange_rate_type,
             v_exp_exchange_rate_quotation,
             v_exp_exchange_rate
        FROM exp_report_accounts a
       WHERE EXISTS (SELECT 1
                FROM exp_report_dists d, exp_report_lines l
               WHERE d.exp_report_dists_id = a.exp_report_dists_id
                 AND d.exp_report_line_id = l.exp_report_line_id
                 AND l.exp_report_header_id =
                     v_exp_report_header.exp_report_header_id)
         AND a.currency_code = v_transaction_line.currency_code
         AND rownum = 1
       GROUP BY a.exchange_rate_type,
                a.exchange_rate_quotation,
                a.exchange_rate;
    EXCEPTION
      WHEN no_data_found THEN
        v_exp_exchange_rate_type      := v_transaction_line.exchange_rate_type;
        v_exp_exchange_rate_quotation := v_transaction_line.exchange_rate_quotation;
        v_exp_exchange_rate           := v_transaction_line.exchange_rate;
    END;
  
    -- 期间
    v_period_name := gld_common_pkg.get_gld_period_name(p_company_id => v_transaction_header.company_id,
                                                        p_date       => p_rec_csh_write_off.write_off_date);
    IF v_period_name IS NULL THEN
      RAISE e_period_error;
    END IF;
  
    -- 核销金额精度
    v_write_off_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => v_transaction_line.currency_code,
                                                             p_amount          => p_rec_csh_write_off.write_off_amount,
                                                             p_set_of_books_id => p_set_of_books_id);
  
    v_write_off_id := get_csh_write_off_id;
    -- 创建核销记录
    insert_csh_write_off(p_write_off_id              => v_write_off_id,
                         p_write_off_type            => p_rec_csh_write_off.write_off_type,
                         p_csh_transaction_line_id   => p_transaction_line_id,
                         p_csh_write_off_amount      => v_write_off_amount,
                         p_document_source           => 'EXPENSE_REPORT',
                         p_document_header_id        => v_exp_report_header.exp_report_header_id,
                         p_document_line_id          => p_rec_csh_write_off.document_id,
                         p_document_write_off_amount => v_write_off_amount,
                         p_write_off_date            => p_rec_csh_write_off.write_off_date,
                         p_period_name               => v_period_name,
                         p_source_csh_trx_line_id    => NULL,
                         p_source_write_off_amount   => NULL,
                         p_gld_interface_flag        => v_gld_interface_flag,
                         p_user_id                   => p_user_id);
    -- 更新报销单核销状态
    set_exp_rep_write_off_status(p_exp_report_header_id => v_exp_report_header.exp_report_header_id,
                                 p_user_id              => p_user_id);
    -- 更新报销单支付状态
    -- mantis:0029277 不更新报销单的待付状态
    /*update csh_doc_payment_company t
      set t.payment_status   = 'PAID',
          t.last_update_date = sysdate,
          t.last_updated_by  = p_user_id
    where t.document_type = 'EXP_REPORT'
      and t.document_id = v_exp_report_header.exp_report_header_id
      and t.document_line_id = p_rec_csh_write_off.document_id;*/
    -- 插入'跟踪单据'信息
    exp_document_history_pkg.insert_exp_document_histories(p_document_type  => exp_report_pkg.c_exp_report, --'EXP_REPORT',
                                                           p_document_id    => v_exp_report_header.exp_report_header_id,
                                                           p_operation_code => exp_document_history_pkg.c_pay, --'PAY',
                                                           p_user_id        => p_user_id,
                                                           p_operation_time => SYSDATE,
                                                           p_description    => '付款交易编号[' ||
                                                                               v_transaction_header.transaction_num ||
                                                                               ']，金额' ||
                                                                               v_write_off_amount);
  
    SELECT e.name
      INTO v_employee_name
      FROM exp_employees e
     WHERE e.employee_id =
           (select s.employee_id from sys_user s where s.user_id = p_user_id);
  
    v_description := v_employee_name || '报销核销';
  
    -- 生成凭证
    -- 原币金额
    v_entered_amount := v_write_off_amount;
    -- 贷方
    -- 计算本位币金额
    IF v_transaction_line.exchange_rate_quotation = 'DIRECT QUOTATION' THEN
      v_functional_amount := p_rec_csh_write_off.write_off_amount *
                             v_transaction_line.exchange_rate;
    ELSIF v_transaction_line.exchange_rate_quotation = 'INDIRECT QUOTATION' THEN
      v_functional_amount := p_rec_csh_write_off.write_off_amount *
                             (1 / v_transaction_line.exchange_rate);
    ELSE
      v_functional_amount := p_rec_csh_write_off.write_off_amount *
                             v_transaction_line.exchange_rate;
    END IF;
    -- 汇率差异
    v_revaluation := v_functional_amount;
    -- 本位币精度
    v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                              p_amount          => v_functional_amount,
                                                              p_set_of_books_id => p_set_of_books_id);
    -- 贷方责任中心
    v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => v_transaction_header.company_id);
    IF v_responsibility_center_id IS NULL THEN
      RAISE e_default_resp_error;
    END IF;
    -- 贷方科目  modify by wxq  按照借款单凭证的逻辑获取
    v_account_id := csh_transaction_pkg.get_prepmt_write_off_account(p_transaction_line_id => p_transaction_line_id,
                                                                     p_user_id             => p_user_id,
                                                                     p_pay_req_je_line_id  => v_pay_req_je_line_id);
    IF v_account_id IS NULL THEN
      RAISE e_prepayment_account_error; -- 未能取到预付款科目
    END IF;
    -- 创建贷方凭证
    v_write_off_je_line_id := get_csh_write_off_je_line_id;
    insert_csh_write_off_accounts(p_write_off_id             => v_write_off_id,
                                  p_write_off_je_line_id     => v_write_off_je_line_id,
                                  p_description              => v_description,
                                  p_period_name              => v_period_name,
                                  p_source_code              => 'PREPAYMENT_EXPENSE_REPORT',
                                  p_company_id               => v_exp_report_header.company_id,
                                  p_responsibility_center_id => v_responsibility_center_id,
                                  p_account_id               => v_account_id,
                                  p_currency_code            => v_transaction_line.currency_code,
                                  p_exchange_rate_type       => v_transaction_line.exchange_rate_type,
                                  p_exchange_rate            => v_transaction_line.exchange_rate,
                                  p_entered_amount_dr        => NULL,
                                  p_entered_amount_cr        => v_entered_amount,
                                  p_functional_amount_dr     => NULL,
                                  p_functional_amount_cr     => v_functional_amount,
                                  p_cash_clearing_flag       => NULL,
                                  p_journal_date             => p_rec_csh_write_off.write_off_date,
                                  p_gld_interface_flag       => v_gld_interface_flag,
                                  p_usage_code               => 'PREPAYMENT_WRITE_OFF',
                                  p_user_id                  => p_user_id);
    -- 生成凭证后，插入预置事件
    csh_evt_pkg.fire_workflow_event(p_event_name          => 'CSH_PREPAYMENT_CREATE_ACCOUNTS',
                                    p_transaction_line_id => p_transaction_line_id,
                                    p_trx_je_line_id      => v_write_off_je_line_id,
                                    p_source_module       => 'CSH_PREPAYMENT',
                                    p_event_type          => 'CSH_PREPAYMENT_CREATE_ACCOUNTS',
                                    p_user_id             => p_user_id);
  
    /*************************************************
    -- Author  : MOUSE
    -- Created : 2015/11/24 13:57:39
    -- Ver     : 1.1
    -- Purpose : 核销的借方凭证取原借款凭证的借款凭证
    **************************************************/
    /* SELECT *
     INTO v_pay_req_account
     FROM csh_payment_req_accounts a
    WHERE a.je_line_id = v_pay_req_je_line_id;*/
    --由于借款单不生成审核凭证，关联借款单，科目段信息等无法从原凭证获取 
    SELECT a.payment_requisition_line_id
      INTO v_payment_req_line_id
      FROM csh_payment_requisition_refs a
     WHERE a.csh_transaction_line_id =
           (SELECT b.transaction_line_id
              FROM csh_transaction_lines b
             WHERE b.transaction_header_id =
                   v_transaction_header.source_payment_header_id)
       AND rownum = 1;
    --add by lyh 
    --核销凭证的借、贷方摘要形如，核销JK100000017080012
    --借款在费用报销核销时产生的核销凭证行摘要借贷方都取：借款人+‘预支’+行说明 modify by wxq 20180419
    SELECT h.related_transactions, l.company_id --'核销' || h.requisition_number
      INTO v_related_transactions, v_company_id
      FROM csh_payment_requisition_hds h,
           csh_payment_requisition_lns l,
           exp_employees               e
     WHERE h.payment_requisition_header_id =
           l.payment_requisition_header_id
       AND l.payment_requisition_line_id = v_payment_req_line_id
       AND h.employee_id = e.employee_id;
  
    SELECT f.company_code
      INTO v_company_code
      FROM fnd_companies f
     WHERE f.company_id = v_company_id;
    v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(v_company_id);
    IF v_responsibility_center_id IS NULL THEN
      RAISE e_default_resp_error;
    END IF;
    SELECT frc.responsibility_center_code
      INTO v_responsibility_center_code
      FROM fnd_responsibility_centers frc
     WHERE frc.responsibility_center_id = v_responsibility_center_id;
    --SEGMENT1  公司段
    --SEGMENT2  成本中心
    --SEGMENT9 （借款单审核凭证此字段取值为csh_payment_requisition_hds表中related_transactions字段）
    --SEGMENT13 SEGMENT14  取值参照cux_gl_account_get_segment_pkg.get_segment13_value_jxrs  get_segment14_value_jxrs
    --modify by pqs 20181015
    /*UPDATE csh_write_off_accounts a
       SET a.account_segment1 = v_company_code,
           a.account_segment2 = v_responsibility_center_code,
           \*a.account_segment9  = v_related_transactions,*\
           a.account_segment13 = substr(v_company_code, 3, 6) ||
                                 substr(v_company_code, 10, 1),
           a.account_segment14 = 'PA' || substr(v_company_code, 5, 2),
           a.description       = v_description
     WHERE a.write_off_je_line_id = v_write_off_je_line_id;
    UPDATE gl_account_entry e
       SET e.segment1 = v_company_code,
           e.segment2 = v_responsibility_center_code,
           \* e.segment9         = v_related_transactions,*\
           e.segment13        = substr(v_company_code, 3, 6) ||
                                substr(v_company_code, 10, 1),
           e.segment14        = 'PA' || substr(v_company_code, 5, 2),
           e.line_description = v_description
     WHERE e.transaction_type = 'CSH_WRITE_OFF'
       AND e.transaction_je_line_id = v_write_off_je_line_id;*/
    /* UPDATE csh_write_off_accounts a
      SET a.account_segment1  = v_pay_req_account.account_segment1,
          a.account_segment2  = v_pay_req_account.account_segment2,
          a.account_segment3  = v_pay_req_account.account_segment3,
          a.account_segment4  = v_pay_req_account.account_segment4,
          a.account_segment5  = v_pay_req_account.account_segment5,
          a.account_segment6  = v_pay_req_account.account_segment6,
          a.account_segment7  = v_pay_req_account.account_segment7,
          a.account_segment8  = v_pay_req_account.account_segment8,
          a.account_segment9  = v_pay_req_account.account_segment9,
          a.account_segment10 = v_pay_req_account.account_segment10,
          a.account_segment11 = v_pay_req_account.account_segment11,
          a.description       = v_description
    WHERE a.write_off_je_line_id = v_write_off_je_line_id;*/
  
    /* UPDATE gl_account_entry e
      SET e.account_id       = v_pay_req_account.account_id,
          e.account_code     = v_pay_req_account.account_segment3,
          e.segment1         = v_pay_req_account.account_segment1,
          e.segment2         = v_pay_req_account.account_segment2,
          e.segment3         = v_pay_req_account.account_segment3,
          e.segment4         = v_pay_req_account.account_segment4,
          e.segment5         = v_pay_req_account.account_segment5,
          e.segment6         = v_pay_req_account.account_segment6,
          e.segment7         = v_pay_req_account.account_segment7,
          e.segment8         = v_pay_req_account.account_segment8,
          e.segment9         = v_pay_req_account.account_segment9,
          e.segment10        = v_pay_req_account.account_segment10,
          e.segment11        = v_pay_req_account.account_segment11,
          e.line_description = v_description
    WHERE e.transaction_type = 'CSH_WRITE_OFF'
      AND e.transaction_je_line_id = v_write_off_je_line_id;*/
  
    gl_log_pkg.log(p_log_text => '核销凭证的贷方从借款单借方凭证带出，借款单凭证行为：' ||
                                 v_pay_req_je_line_id || '，凭证科目段为：' ||
                                 v_pay_req_account.account_segment1 || '.' ||
                                 v_pay_req_account.account_segment2 || '.' ||
                                 v_pay_req_account.account_segment3 || '.' ||
                                 v_pay_req_account.account_segment4 || '.' ||
                                 v_pay_req_account.account_segment5 || '.' ||
                                 v_pay_req_account.account_segment6 || '.' ||
                                 v_pay_req_account.account_segment7 || '.' ||
                                 v_pay_req_account.account_segment8 || '.' ||
                                 v_pay_req_account.account_segment9 || '.' ||
                                 v_pay_req_account.account_segment10 || '.' ||
                                 v_pay_req_account.account_segment11,
                   p_user_id  => p_user_id);
  
    /*************************************************/
  
    -- 借方
    -- 计算本位币金额
    IF v_exp_exchange_rate_quotation = 'DIRECT QUOTATION' THEN
      v_functional_amount := p_rec_csh_write_off.write_off_amount *
                             v_exp_exchange_rate;
    ELSIF v_exp_exchange_rate_quotation = 'INDIRECT QUOTATION' THEN
      v_functional_amount := p_rec_csh_write_off.write_off_amount *
                             (1 / v_exp_exchange_rate);
    ELSE
      v_functional_amount := p_rec_csh_write_off.write_off_amount *
                             v_exp_exchange_rate;
    END IF;
    -- 汇率差异
    v_revaluation := v_revaluation - v_functional_amount;
    -- 本位币精度
    v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                              p_amount          => v_functional_amount,
                                                              p_set_of_books_id => p_set_of_books_id);
    -- 借方责任中心和科目
    v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => v_exp_report_header.company_id);
    IF v_responsibility_center_id IS NULL THEN
      RAISE e_default_resp_error;
    END IF;
    v_account_id := csh_transaction_pkg.get_exp_report_account(p_payment_schedule_line_id => p_rec_csh_write_off.document_id,
                                                               p_user_id                  => p_user_id);
    wbc_log_pkg.log(1, 2, p_rec_csh_write_off.document_id, 4, 3);
    IF v_account_id IS NULL THEN
      RAISE e_exp_report_account_error;
    END IF;
    -- 创建借方凭证
    v_write_off_je_line_id := get_csh_write_off_je_line_id;
    insert_csh_write_off_accounts(p_write_off_id             => v_write_off_id,
                                  p_write_off_je_line_id     => v_write_off_je_line_id,
                                  p_description              => v_description, --add by lyh 
                                  p_period_name              => v_period_name,
                                  p_source_code              => 'PREPAYMENT_EXPENSE_REPORT',
                                  p_company_id               => v_exp_report_header.company_id,
                                  p_responsibility_center_id => v_responsibility_center_id,
                                  p_account_id               => v_account_id,
                                  p_currency_code            => v_transaction_line.currency_code,
                                  p_exchange_rate_type       => v_exp_exchange_rate_type,
                                  p_exchange_rate            => v_exp_exchange_rate,
                                  p_entered_amount_dr        => v_entered_amount,
                                  p_entered_amount_cr        => NULL,
                                  p_functional_amount_dr     => v_functional_amount,
                                  p_functional_amount_cr     => NULL,
                                  p_cash_clearing_flag       => NULL,
                                  p_journal_date             => p_rec_csh_write_off.write_off_date,
                                  p_gld_interface_flag       => v_gld_interface_flag,
                                  p_usage_code               => 'EMPLOYEE_EXPENSE_WRITE_OFF',
                                  p_user_id                  => p_user_id);
    --add by lyh 
    --修改摘要                             
    /*UPDATE gl_account_entry e
      SET e.line_description = v_description
    WHERE e.transaction_line_id = v_write_off_je_line_id;*/
    -- 生成凭证后，插入预置事件
    csh_evt_pkg.fire_workflow_event(p_event_name          => 'CSH_PREPAYMENT_CREATE_ACCOUNTS',
                                    p_transaction_line_id => p_transaction_line_id,
                                    p_trx_je_line_id      => v_write_off_je_line_id,
                                    p_source_module       => 'CSH_PREPAYMENT',
                                    p_event_type          => 'CSH_PREPAYMENT_CREATE_ACCOUNTS',
                                    p_user_id             => p_user_id);
  
    v_revaluation := 0;
  
    IF v_revaluation > 0 THEN
      v_account_id := csh_transaction_pkg.get_revaluation_account(p_company_id    => v_transaction_header.company_id,
                                                                  p_currency_code => v_transaction_line.currency_code,
                                                                  p_user_id       => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_revaluation_account_error;
      END IF;
      -- 汇率差异精度
      v_revaluation := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                          p_amount          => v_revaluation,
                                                          p_set_of_books_id => p_set_of_books_id);
      -- 创建汇率差异凭证
      v_write_off_je_line_id := get_csh_write_off_je_line_id;
      insert_csh_write_off_accounts(p_write_off_id             => v_write_off_id,
                                    p_write_off_je_line_id     => v_write_off_je_line_id,
                                    p_description              => NULL,
                                    p_period_name              => v_period_name,
                                    p_source_code              => 'PREPAYMENT_EXPENSE_REPORT',
                                    p_company_id               => v_exp_report_header.company_id,
                                    p_responsibility_center_id => v_responsibility_center_id,
                                    p_account_id               => v_account_id,
                                    p_currency_code            => v_transaction_line.currency_code,
                                    p_exchange_rate_type       => v_transaction_line.exchange_rate_type,
                                    p_exchange_rate            => v_transaction_line.exchange_rate,
                                    p_entered_amount_dr        => 0,
                                    p_entered_amount_cr        => NULL,
                                    p_functional_amount_dr     => v_revaluation,
                                    p_functional_amount_cr     => NULL,
                                    p_cash_clearing_flag       => NULL,
                                    p_journal_date             => p_rec_csh_write_off.write_off_date,
                                    p_gld_interface_flag       => v_gld_interface_flag,
                                    p_usage_code               => 'REVALUATION',
                                    p_user_id                  => p_user_id);
    ELSIF v_revaluation < 0 THEN
      v_account_id := csh_transaction_pkg.get_revaluation_account(p_company_id    => v_transaction_header.company_id,
                                                                  p_currency_code => v_transaction_line.currency_code,
                                                                  p_user_id       => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_revaluation_account_error;
      END IF;
      -- 汇率差异精度
      v_revaluation := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                          p_amount          => -1 *
                                                                               v_revaluation,
                                                          p_set_of_books_id => p_set_of_books_id);
      -- 创建汇率差异凭证
      v_write_off_je_line_id := get_csh_write_off_je_line_id;
      insert_csh_write_off_accounts(p_write_off_id             => v_write_off_id,
                                    p_write_off_je_line_id     => v_write_off_je_line_id,
                                    p_description              => NULL,
                                    p_period_name              => v_period_name,
                                    p_source_code              => 'PREPAYMENT_EXPENSE_REPORT',
                                    p_company_id               => v_exp_report_header.company_id,
                                    p_responsibility_center_id => v_responsibility_center_id,
                                    p_account_id               => v_account_id,
                                    p_currency_code            => v_transaction_line.currency_code,
                                    p_exchange_rate_type       => v_transaction_line.exchange_rate_type,
                                    p_exchange_rate            => v_transaction_line.exchange_rate,
                                    p_entered_amount_dr        => NULL,
                                    p_entered_amount_cr        => 0,
                                    p_functional_amount_dr     => NULL,
                                    p_functional_amount_cr     => v_revaluation,
                                    p_cash_clearing_flag       => NULL,
                                    p_journal_date             => p_rec_csh_write_off.write_off_date,
                                    p_gld_interface_flag       => v_gld_interface_flag,
                                    p_usage_code               => 'REVALUATION',
                                    p_user_id                  => p_user_id);
    END IF;
  EXCEPTION
    WHEN e_locked_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_LOCKED_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PREPAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_payment_amount_check_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_error_code,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PREPAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_period_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_PERIOD_NOT_OPEN_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PREPAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_default_resp_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_DEFAULT_RESP_ERROR1',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PREPAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_exp_report_account_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_EXP_REPORT_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PREPAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_prepayment_account_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_PREPMT_WRITE_OFF_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PREPAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_revaluation_account_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_REVALUATION_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_PREPAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END execute_prepayment_exp_rep;

  PROCEDURE execute_csh_trx_write_off(p_session_id            NUMBER,
                                      p_transaction_header_id NUMBER,
                                      p_transaction_line_id   NUMBER,
                                      p_user_id               NUMBER) IS
    v_functional_currency_code gld_set_of_books.functional_currency_code%TYPE;
    v_set_of_books_id          gld_set_of_books.set_of_books_id%TYPE;
    rec_transaction_header     csh_transaction_headers%ROWTYPE;
    rec_transaction_line       csh_transaction_lines%ROWTYPE;
    v_sum_write_off_amount     NUMBER;
  
    CURSOR cur_csh_write_off IS
      SELECT * FROM csh_write_off_tmp t WHERE t.session_id = p_session_id;
    rec_csh_write_off cur_csh_write_off%ROWTYPE;
  
    e_sum_write_off_amount_error EXCEPTION;
    e_functional_currency_error  EXCEPTION;
    e_set_of_books_error         EXCEPTION;
    e_write_off_type_error       EXCEPTION;
  BEGIN
    SELECT *
      INTO rec_transaction_header
      FROM csh_transaction_headers h
     WHERE h.transaction_header_id = p_transaction_header_id;
  
    SELECT *
      INTO rec_transaction_line
      FROM csh_transaction_lines l
     WHERE l.transaction_line_id = p_transaction_line_id;
  
    -- 取公司本位币
    v_functional_currency_code := gld_common_pkg.get_company_currency_code(p_company_id => rec_transaction_header.company_id);
    IF v_functional_currency_code IS NULL THEN
      RAISE e_functional_currency_error;
    END IF;
    -- 取帐套
    v_set_of_books_id := gld_common_pkg.get_set_of_books_id(p_comany_id => rec_transaction_header.company_id);
    IF v_set_of_books_id IS NULL THEN
      RAISE e_set_of_books_error;
    END IF;
  
    OPEN cur_csh_write_off;
    LOOP
      FETCH cur_csh_write_off
        INTO rec_csh_write_off;
      EXIT WHEN cur_csh_write_off%NOTFOUND;
      IF rec_transaction_header.transaction_type = 'PAYMENT' AND
         rec_transaction_header.enabled_write_off_flag = 'Y' AND
         rec_csh_write_off.write_off_type = 'PAYMENT_EXPENSE_REPORT' THEN
        SELECT SUM(t.write_off_amount)
          INTO v_sum_write_off_amount
          FROM csh_write_off_tmp t
         WHERE t.session_id = p_session_id;
        -- 校验核销总金额与现金事务金额
        IF v_sum_write_off_amount <>
           rec_transaction_line.transaction_amount THEN
          RAISE e_sum_write_off_amount_error;
        END IF;
        --付款核销报销单
        execute_payment_exp_rep(p_rec_csh_write_off        => rec_csh_write_off,
                                p_transaction_header_id    => p_transaction_header_id,
                                p_transaction_line_id      => p_transaction_line_id,
                                p_functional_currency_code => v_functional_currency_code,
                                p_set_of_books_id          => v_set_of_books_id,
                                p_user_id                  => p_user_id);
      ELSIF rec_transaction_header.transaction_type = 'PAYMENT' AND
            rec_transaction_header.enabled_write_off_flag = 'Y' AND
            rec_csh_write_off.write_off_type = 'PAYMENT_PREPAYMENT' AND
            rec_csh_write_off.transaction_class IS NOT NULL THEN
        SELECT SUM(t.write_off_amount)
          INTO v_sum_write_off_amount
          FROM csh_write_off_tmp t
         WHERE t.session_id = p_session_id;
        -- 校验核销总金额与现金事务金额
        IF v_sum_write_off_amount <>
           rec_transaction_line.transaction_amount THEN
          RAISE e_sum_write_off_amount_error;
        END IF;
        --付款核销预付款
        execute_payment_prepayment(p_rec_csh_write_off        => rec_csh_write_off,
                                   p_transaction_header_id    => p_transaction_header_id,
                                   p_transaction_line_id      => p_transaction_line_id,
                                   p_functional_currency_code => v_functional_currency_code,
                                   p_set_of_books_id          => v_set_of_books_id,
                                   p_user_id                  => p_user_id);
      ELSIF rec_transaction_header.transaction_type = 'PREPAYMENT' AND
            rec_transaction_header.enabled_write_off_flag = 'Y' AND
            rec_csh_write_off.write_off_type = 'PREPAYMENT_EXPENSE_REPORT' THEN
        --预付款核销报销单
        execute_prepayment_exp_rep(p_rec_csh_write_off        => rec_csh_write_off,
                                   p_transaction_header_id    => p_transaction_header_id,
                                   p_transaction_line_id      => p_transaction_line_id,
                                   p_functional_currency_code => v_functional_currency_code,
                                   p_set_of_books_id          => v_set_of_books_id,
                                   p_user_id                  => p_user_id);
      ELSIF rec_transaction_header.transaction_type = 'PAYMENT' AND
            rec_transaction_header.enabled_write_off_flag = 'Y' AND
            rec_csh_write_off.write_off_type = 'ACP_INVOICE_PAYMENT' THEN
        --应付发票支付
        SELECT SUM(t.write_off_amount)
          INTO v_sum_write_off_amount
          FROM csh_write_off_tmp t
         WHERE t.session_id = p_session_id;
        -- 校验核销总金额与现金事务金额
        IF v_sum_write_off_amount <>
           rec_transaction_line.transaction_amount THEN
          RAISE e_sum_write_off_amount_error;
        END IF;
      
        acp_invoice_payment_pkg.execute_acp_invoice_payment(p_rec_csh_write_off        => rec_csh_write_off,
                                                            p_transaction_header_id    => p_transaction_header_id,
                                                            p_transaction_line_id      => p_transaction_line_id,
                                                            p_functional_currency_code => v_functional_currency_code,
                                                            p_set_of_books_id          => v_set_of_books_id,
                                                            p_user_id                  => p_user_id);
      ELSE
        RAISE e_write_off_type_error;
      END IF;
    END LOOP;
    -- 更新现金事务核销状态
    set_csh_trx_write_off_status(p_transaction_header_id => p_transaction_header_id,
                                 p_transaction_line_id   => p_transaction_line_id,
                                 p_transaction_type      => rec_transaction_header.transaction_type,
                                 p_user_id               => p_user_id);
    CLOSE cur_csh_write_off;
    -- 删除待处理数据
    delete_csh_write_off_tmp(p_session_id => p_session_id,
                             p_user_id    => p_user_id);
  EXCEPTION
    WHEN e_sum_write_off_amount_error THEN
      IF cur_csh_write_off%ISOPEN THEN
        CLOSE cur_csh_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5210_SUM_WRITE_OFF_AMOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_CSH_TRX_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_functional_currency_error THEN
      IF cur_csh_write_off%ISOPEN THEN
        CLOSE cur_csh_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5210_FUNCTIONAL_CURRENCY_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_CSH_TRX_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_set_of_books_error THEN
      IF cur_csh_write_off%ISOPEN THEN
        CLOSE cur_csh_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5210_SET_OF_BOOKS_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_CSH_TRX_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_write_off_type_error THEN
      IF cur_csh_write_off%ISOPEN THEN
        CLOSE cur_csh_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_WRITE_OFF_TYPE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'EXECUTE_CSH_TRX_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      IF cur_csh_write_off%ISOPEN THEN
        CLOSE cur_csh_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                     p_procedure_function_name => 'EXECUTE_CSH_TRX_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END execute_csh_trx_write_off;

  PROCEDURE return_payment_exp_rep(p_rec_csh_write_off        csh_write_off%ROWTYPE,
                                   p_transaction_header       csh_transaction_headers%ROWTYPE, -- 退款事务头
                                   p_transaction_line         csh_transaction_lines%ROWTYPE, -- 退款事务行
                                   p_source_trx_header        csh_transaction_headers%ROWTYPE, -- 原付款事务头
                                   p_return_amount            NUMBER,
                                   p_functional_currency_code VARCHAR2,
                                   p_set_of_books_id          NUMBER,
                                   p_user_id                  NUMBER) IS
    v_exp_report_header           exp_report_headers%ROWTYPE;
    v_csh_transaction_line_id     NUMBER;
    v_contract_header_id          NUMBER;
    v_payment_schedule_line_id    NUMBER;
    v_trx_pmt_schedule_line_id    NUMBER;
    v_write_off_id                NUMBER;
    v_company_id                  NUMBER;
    v_responsibility_center_id    NUMBER;
    v_account_id                  NUMBER;
    v_return_amount               NUMBER;
    v_entered_amount              NUMBER;
    v_functional_amount           NUMBER;
    v_exchange_rate_type          gld_exchange_rates.type_code%TYPE;
    v_exchange_rate               NUMBER;
    v_exchange_rate_quotation     gld_exchange_rates.exchange_rate_quotation%TYPE;
    v_count                       NUMBER;
    v_sum                         NUMBER;
    v_transaction_je_line_id      NUMBER;
    v_exp_exchange_rate_type      VARCHAR2(30);
    v_exp_exchange_rate_quotation VARCHAR2(30);
    v_exp_exchange_rate           NUMBER;
    v_revaluation                 NUMBER;
  
    v_acp_req_ref                acp_acp_requisition_refs%ROWTYPE;
    v_payment_requisition_ref_id NUMBER;
  
    e_bank_account_error        EXCEPTION;
    e_default_resp_error1       EXCEPTION;
    e_exp_report_account_error  EXCEPTION;
    e_intercompany_ar_account   EXCEPTION;
    e_default_resp_error2       EXCEPTION;
    e_intercompany_ap_account   EXCEPTION;
    e_exchange_rate_type_error  EXCEPTION;
    e_revaluation_account_error EXCEPTION;
    e_locked_error              EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_locked_error, -54);
  BEGIN
    SELECT h.*
      INTO v_exp_report_header
      FROM exp_report_headers h, exp_report_pmt_schedules s
     WHERE s.exp_report_header_id = h.exp_report_header_id
       AND s.payment_schedule_line_id =
           p_rec_csh_write_off.document_line_id
       FOR UPDATE NOWAIT;
  
    SELECT s.company_id
      INTO v_company_id
      FROM exp_report_pmt_schedules s
     WHERE s.payment_schedule_line_id =
           p_rec_csh_write_off.document_line_id;
  
    BEGIN
      SELECT a.exchange_rate_type,
             a.exchange_rate_quotation,
             a.exchange_rate
        INTO v_exp_exchange_rate_type,
             v_exp_exchange_rate_quotation,
             v_exp_exchange_rate
        FROM exp_report_accounts a
       WHERE EXISTS (SELECT 1
                FROM exp_report_dists d, exp_report_lines l
               WHERE d.exp_report_dists_id = a.exp_report_dists_id
                 AND d.exp_report_line_id = l.exp_report_line_id
                 AND l.exp_report_header_id =
                     v_exp_report_header.exp_report_header_id)
         AND a.currency_code = p_transaction_line.currency_code
         AND rownum = 1
       GROUP BY a.exchange_rate_type,
                a.exchange_rate_quotation,
                a.exchange_rate;
    EXCEPTION
      WHEN no_data_found THEN
        v_exp_exchange_rate_type      := p_transaction_line.exchange_rate_type;
        v_exp_exchange_rate_quotation := p_transaction_line.exchange_rate_quotation;
        v_exp_exchange_rate           := p_transaction_line.exchange_rate;
    END;
  
    -- 退款金额取精度
    v_return_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_transaction_line.currency_code,
                                                          p_amount          => p_return_amount,
                                                          p_set_of_books_id => p_set_of_books_id);
    v_write_off_id  := get_csh_write_off_id;
    -- 生成退款核销记录
    insert_csh_write_off(p_write_off_id              => v_write_off_id,
                         p_write_off_type            => p_rec_csh_write_off.write_off_type,
                         p_csh_transaction_line_id   => p_rec_csh_write_off.csh_transaction_line_id,
                         p_csh_write_off_amount      => -1 * v_return_amount,
                         p_document_source           => p_rec_csh_write_off.document_source,
                         p_document_header_id        => p_rec_csh_write_off.document_header_id,
                         p_document_line_id          => p_rec_csh_write_off.document_line_id,
                         p_document_write_off_amount => -1 * v_return_amount,
                         p_write_off_date            => p_transaction_header.transaction_date,
                         p_period_name               => p_transaction_header.period_name,
                         p_source_csh_trx_line_id    => p_transaction_line.transaction_line_id,
                         p_source_write_off_amount   => -1 * v_return_amount,
                         p_gld_interface_flag        => c_gld_interface_flag_p,
                         p_user_id                   => p_user_id);
    -- 更新报销单核销状态
    set_exp_rep_write_off_status(p_exp_report_header_id => p_rec_csh_write_off.document_header_id,
                                 p_user_id              => p_user_id);
    -- 更新报销单支付状态
    SELECT nvl(SUM(w.document_write_off_amount), 0)
      INTO v_sum
      FROM csh_write_off w
     WHERE w.document_header_id = p_rec_csh_write_off.document_header_id
       AND w.document_source = 'EXPENSE_REPORT';
    IF v_sum = 0 THEN
      UPDATE csh_doc_payment_company t
         SET t.payment_status   = 'ALLOWED',
             t.last_update_date = SYSDATE,
             t.last_updated_by  = p_user_id
       WHERE t.document_type = 'EXP_REPORT'
         AND t.document_id = p_rec_csh_write_off.document_header_id
         AND t.document_line_id = p_rec_csh_write_off.document_line_id;
    END IF;
  
    BEGIN
      SELECT *
        INTO v_acp_req_ref
        FROM acp_acp_requisition_refs r
       WHERE r.write_off_id = p_rec_csh_write_off.write_off_id
         AND r.amount > 0;
    
      csh_payment_transaction_pkg.insert_csh_payment_req_refs(p_payment_requisition_ref_id  => v_payment_requisition_ref_id,
                                                              p_payment_requisition_line_id => v_acp_req_ref.acp_requisition_line_id,
                                                              p_csh_transaction_line_id     => v_acp_req_ref.csh_transaction_line_id,
                                                              p_write_off_flag              => NULL,
                                                              p_write_off_id                => v_write_off_id,
                                                              p_amount                      => -1 *
                                                                                               p_return_amount,
                                                              p_description                 => NULL,
                                                              p_user_id                     => p_user_id);
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    -- 插入'跟踪单据'信息
    exp_document_history_pkg.insert_exp_document_histories(p_document_type  => exp_report_pkg.c_exp_report, --'EXP_REPORT',
                                                           p_document_id    => p_rec_csh_write_off.document_header_id,
                                                           p_operation_code => exp_document_history_pkg.c_pay, --'PAY',
                                                           p_user_id        => p_user_id,
                                                           p_operation_time => SYSDATE,
                                                           p_description    => '退款交易编号[' ||
                                                                               p_transaction_header.transaction_num ||
                                                                               '],金额:' || -1 *
                                                                               v_return_amount);
    -- 关联合同或合同资金计划行
    BEGIN
      SELECT t.csh_transaction_line_id,
             t.payment_schedule_line_id,
             t.contract_header_id
        INTO v_csh_transaction_line_id,
             v_payment_schedule_line_id,
             v_contract_header_id
        FROM con_cash_trx_pmt_schedule_lns t
       WHERE t.write_off_id = p_rec_csh_write_off.write_off_id
         AND t.amount > 0;
    
      csh_transaction_pkg.insert_trx_pmt_schedule_line(p_trx_pmt_schedule_line_id => v_trx_pmt_schedule_line_id,
                                                       p_csh_transaction_line_id  => v_csh_transaction_line_id,
                                                       p_payment_schedule_line_id => v_payment_schedule_line_id,
                                                       p_amount                   => -1 *
                                                                                     v_return_amount,
                                                       p_user_id                  => p_user_id,
                                                       p_contract_header_id       => v_contract_header_id,
                                                       p_write_off_id             => v_write_off_id);
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    -- 判断当前公司借方凭证是否存在（对应银行存款账户的凭证）
    SELECT COUNT(a.transaction_je_line_id)
      INTO v_count
      FROM csh_transaction_accounts a
     WHERE a.transaction_line_id = p_transaction_line.transaction_line_id
       AND a.company_id = p_transaction_header.company_id
       AND a.entered_amount_cr IS NULL
       AND a.functional_amount_cr IS NULL;
    -- 当前公司借方凭证不存在
    IF v_count = 0 THEN
      --获得银行帐户的责任中心，科目
      csh_transaction_pkg.get_bank_acc_and_resp(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                p_responsibility_center_id => v_responsibility_center_id,
                                                p_account_id               => v_account_id);
      IF v_responsibility_center_id IS NULL OR v_account_id IS NULL THEN
        RAISE e_bank_account_error;
      END IF;
      -- 原币金额
      v_entered_amount := p_transaction_line.transaction_amount;
      -- 计算本位币金额
      IF p_transaction_line.exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount *
                               p_transaction_line.exchange_rate;
      ELSIF p_transaction_line.exchange_rate_quotation =
            'INDIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount *
                               (1 / p_transaction_line.exchange_rate);
      ELSE
        v_functional_amount := v_entered_amount *
                               p_transaction_line.exchange_rate;
      END IF;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建当前公司借方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => '退款 ' ||
                                                                                       p_source_trx_header.transaction_num,
                                                         p_period_name              => p_transaction_header.period_name,
                                                         p_company_id               => p_transaction_header.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => v_entered_amount,
                                                         p_entered_amount_cr        => NULL,
                                                         p_functional_amount_dr     => v_functional_amount,
                                                         p_functional_amount_cr     => NULL,
                                                         p_exchange_rate_type       => p_transaction_line.exchange_rate_type,
                                                         p_exchange_rate            => p_transaction_line.exchange_rate,
                                                         p_currency_code            => p_transaction_line.currency_code,
                                                         p_journal_date             => p_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => 'Y',
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => NULL,
                                                         p_usage_code               => 'CASH_ACCOUNT',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
    END IF;
    IF p_transaction_header.company_id = v_company_id THEN
      -- 非跨公司
      -- 当前公司贷方责任中心和科目
      v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => p_transaction_header.company_id);
      IF v_responsibility_center_id IS NULL THEN
        RAISE e_default_resp_error1;
      END IF;
      v_account_id := csh_transaction_pkg.get_exp_report_account(p_payment_schedule_line_id => p_rec_csh_write_off.document_line_id,
                                                                 p_user_id                  => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_exp_report_account_error;
      END IF;
      -- 原币精度
      v_entered_amount := v_return_amount;
      -- 计算本位币金额
      IF v_exp_exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount * v_exp_exchange_rate;
      ELSIF v_exp_exchange_rate_quotation = 'INDIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount * (1 / v_exp_exchange_rate);
      ELSE
        v_functional_amount := v_entered_amount * v_exp_exchange_rate;
      END IF;
      -- 汇率差异
      IF p_transaction_line.exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_revaluation := v_entered_amount *
                         p_transaction_line.exchange_rate;
      ELSIF p_transaction_line.exchange_rate_quotation =
            'INDIRECT QUOTATION' THEN
        v_revaluation := v_entered_amount *
                         (1 / p_transaction_line.exchange_rate);
      ELSE
        v_revaluation := v_entered_amount *
                         p_transaction_line.exchange_rate;
      END IF;
      v_revaluation := v_revaluation - v_functional_amount;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建当前公司贷方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => '退款 ' ||
                                                                                       p_source_trx_header.transaction_num,
                                                         p_period_name              => p_transaction_header.period_name,
                                                         p_company_id               => p_transaction_header.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => NULL,
                                                         p_entered_amount_cr        => v_entered_amount,
                                                         p_functional_amount_dr     => NULL,
                                                         p_functional_amount_cr     => v_functional_amount,
                                                         p_exchange_rate_type       => v_exp_exchange_rate_type,
                                                         p_exchange_rate            => v_exp_exchange_rate,
                                                         p_currency_code            => p_transaction_line.currency_code,
                                                         p_journal_date             => p_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'EMPLOYEE_EXPENSE_WRITE_OFF',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
      IF v_revaluation > 0 THEN
        v_account_id := csh_transaction_pkg.get_revaluation_account(p_company_id    => p_transaction_header.company_id,
                                                                    p_currency_code => p_transaction_line.currency_code,
                                                                    p_user_id       => p_user_id);
        IF v_account_id IS NULL THEN
          RAISE e_revaluation_account_error;
        END IF;
        -- 汇率差异精度
        v_revaluation := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                            p_amount          => v_revaluation,
                                                            p_set_of_books_id => p_set_of_books_id);
        -- 创建汇率差异凭证
        csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                           p_distribution_line_id     => NULL,
                                                           p_source_code              => 'CSH_PAYMENT',
                                                           p_description              => '退款 ' ||
                                                                                         p_source_trx_header.transaction_num,
                                                           p_period_name              => p_transaction_header.period_name,
                                                           p_company_id               => p_transaction_header.company_id,
                                                           p_responsibility_center_id => v_responsibility_center_id,
                                                           p_account_id               => v_account_id,
                                                           p_entered_amount_dr        => NULL,
                                                           p_entered_amount_cr        => 0,
                                                           p_functional_amount_dr     => NULL,
                                                           p_functional_amount_cr     => v_revaluation,
                                                           p_exchange_rate_type       => p_transaction_line.exchange_rate_type,
                                                           p_exchange_rate            => p_transaction_line.exchange_rate,
                                                           p_currency_code            => p_transaction_line.currency_code,
                                                           p_journal_date             => p_transaction_header.transaction_date,
                                                           p_cash_clearing_flag       => NULL,
                                                           p_bank_account_flag        => NULL,
                                                           p_gld_interface_flag       => c_gld_interface_flag_p,
                                                           p_write_off_id             => v_write_off_id,
                                                           p_usage_code               => 'REVALUATION',
                                                           p_user_id                  => p_user_id,
                                                           p_transaction_je_line_id   => v_transaction_je_line_id);
      ELSIF v_revaluation < 0 THEN
        v_account_id := csh_transaction_pkg.get_revaluation_account(p_company_id    => p_transaction_header.company_id,
                                                                    p_currency_code => p_transaction_line.currency_code,
                                                                    p_user_id       => p_user_id);
        IF v_account_id IS NULL THEN
          RAISE e_revaluation_account_error;
        END IF;
        -- 汇率差异精度
        v_revaluation := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                            p_amount          => -1 *
                                                                                 v_revaluation,
                                                            p_set_of_books_id => p_set_of_books_id);
        -- 创建汇率差异凭证
        csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                           p_distribution_line_id     => NULL,
                                                           p_source_code              => 'CSH_PAYMENT',
                                                           p_description              => '退款 ' ||
                                                                                         p_source_trx_header.transaction_num,
                                                           p_period_name              => p_transaction_header.period_name,
                                                           p_company_id               => p_transaction_header.company_id,
                                                           p_responsibility_center_id => v_responsibility_center_id,
                                                           p_account_id               => v_account_id,
                                                           p_entered_amount_dr        => 0,
                                                           p_entered_amount_cr        => NULL,
                                                           p_functional_amount_dr     => v_revaluation,
                                                           p_functional_amount_cr     => NULL,
                                                           p_exchange_rate_type       => p_transaction_line.exchange_rate_type,
                                                           p_exchange_rate            => p_transaction_line.exchange_rate,
                                                           p_currency_code            => p_transaction_line.currency_code,
                                                           p_journal_date             => p_transaction_header.transaction_date,
                                                           p_cash_clearing_flag       => NULL,
                                                           p_bank_account_flag        => NULL,
                                                           p_gld_interface_flag       => c_gld_interface_flag_p,
                                                           p_write_off_id             => v_write_off_id,
                                                           p_usage_code               => 'REVALUATION',
                                                           p_user_id                  => p_user_id,
                                                           p_transaction_je_line_id   => v_transaction_je_line_id);
      END IF;
    ELSE
      -- 跨公司
      -- 当前公司贷方
      v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => p_transaction_header.company_id);
      IF v_responsibility_center_id IS NULL THEN
        RAISE e_default_resp_error1;
      END IF;
      -- 取内部往来应收科目
      v_account_id := csh_transaction_pkg.get_intercompany_ar_account(p_company_id       => p_transaction_header.company_id,
                                                                      p_opposite_company => v_company_id,
                                                                      p_currency_code    => p_transaction_line.currency_code,
                                                                      p_user_id          => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_intercompany_ar_account;
      END IF;
      -- 原币精度
      v_entered_amount := v_return_amount;
      -- 计算本位币金额
      IF p_transaction_line.exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount *
                               p_transaction_line.exchange_rate;
      ELSIF p_transaction_line.exchange_rate_quotation =
            'INDIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount *
                               (1 / p_transaction_line.exchange_rate);
      ELSE
        v_functional_amount := v_entered_amount *
                               p_transaction_line.exchange_rate;
      END IF;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建当前公司贷方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => '退款 ' ||
                                                                                       p_source_trx_header.transaction_num,
                                                         p_period_name              => p_transaction_header.period_name,
                                                         p_company_id               => p_transaction_header.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => NULL,
                                                         p_entered_amount_cr        => v_entered_amount,
                                                         p_functional_amount_dr     => NULL,
                                                         p_functional_amount_cr     => v_functional_amount,
                                                         p_exchange_rate_type       => p_transaction_line.exchange_rate_type,
                                                         p_exchange_rate            => p_transaction_line.exchange_rate,
                                                         p_currency_code            => p_transaction_line.currency_code,
                                                         p_journal_date             => p_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'CSH_INTERCOMPANY_AR',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
      -- 对方公司借方
      v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => v_company_id);
      IF v_responsibility_center_id IS NULL THEN
        RAISE e_default_resp_error2;
      END IF;
      -- 取内部往来应付科目
      v_account_id := csh_transaction_pkg.get_intercompany_ap_account(p_company_id       => v_company_id,
                                                                      p_opposite_company => p_transaction_header.company_id,
                                                                      p_currency_code    => p_transaction_line.currency_code,
                                                                      p_user_id          => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_intercompany_ap_account;
      END IF;
      IF p_transaction_line.currency_code = p_functional_currency_code THEN
        v_exchange_rate_type      := NULL;
        v_exchange_rate_quotation := NULL;
        v_exchange_rate           := 1;
      ELSE
        -- 取对方公司默认汇率
        v_exchange_rate_type := sys_parameter_pkg.value(p_parameter_code => 'DEFAULT_EXCHANGE_RATE_TYPE',
                                                        p_company_id     => v_exp_report_header.company_id);
        IF v_exchange_rate_type IS NULL THEN
          RAISE e_exchange_rate_type_error;
        END IF;
        gld_exchange_rate_pkg.get_exchange_rate(p_company_id              => v_company_id,
                                                p_from_currency           => p_functional_currency_code,
                                                p_to_currency             => p_transaction_line.currency_code,
                                                p_exchange_rate_type      => v_exchange_rate_type,
                                                p_exchange_date           => p_transaction_header.transaction_date,
                                                p_exchange_period_name    => p_transaction_header.period_name,
                                                p_who_id                  => p_user_id,
                                                p_exchange_rate           => v_exchange_rate,
                                                p_exchange_rate_quotation => v_exchange_rate_quotation);
      END IF;
      -- 计算本位币金额
      IF v_exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount * v_exchange_rate;
      ELSIF v_exchange_rate_quotation = 'INDIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount * (1 / v_exchange_rate);
      ELSE
        v_functional_amount := v_entered_amount * v_exchange_rate;
      END IF;
      -- 汇率差异
      v_revaluation := v_functional_amount;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建对方公司借方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => '退款 ' ||
                                                                                       p_source_trx_header.transaction_num,
                                                         p_period_name              => p_transaction_header.period_name,
                                                         p_company_id               => v_company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => v_entered_amount,
                                                         p_entered_amount_cr        => NULL,
                                                         p_functional_amount_dr     => v_functional_amount,
                                                         p_functional_amount_cr     => NULL,
                                                         p_exchange_rate_type       => v_exchange_rate_type,
                                                         p_exchange_rate            => v_exchange_rate,
                                                         p_currency_code            => p_transaction_line.currency_code,
                                                         p_journal_date             => p_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'CSH_INTERCOMPANY_AP',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
      -- 对方公司贷方
      v_account_id := csh_transaction_pkg.get_exp_report_account(p_payment_schedule_line_id => p_rec_csh_write_off.document_line_id,
                                                                 p_user_id                  => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_exp_report_account_error;
      END IF;
      -- 计算本位币金额
      IF v_exp_exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount * v_exp_exchange_rate;
      ELSIF v_exp_exchange_rate_quotation = 'INDIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount * (1 / v_exp_exchange_rate);
      ELSE
        v_functional_amount := v_entered_amount * v_exp_exchange_rate;
      END IF;
      -- 汇率差异
      v_revaluation := v_revaluation - v_functional_amount;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建对方公司贷方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => '退款 ' ||
                                                                                       p_source_trx_header.transaction_num,
                                                         p_period_name              => p_transaction_header.period_name,
                                                         p_company_id               => v_company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => NULL,
                                                         p_entered_amount_cr        => v_entered_amount,
                                                         p_functional_amount_dr     => NULL,
                                                         p_functional_amount_cr     => v_functional_amount,
                                                         p_exchange_rate_type       => v_exp_exchange_rate_type,
                                                         p_exchange_rate            => v_exp_exchange_rate,
                                                         p_currency_code            => p_transaction_line.currency_code,
                                                         p_journal_date             => p_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'EMPLOYEE_EXPENSE_WRITE_OFF',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
      IF v_revaluation > 0 THEN
        v_account_id := csh_transaction_pkg.get_revaluation_account(p_company_id    => v_company_id,
                                                                    p_currency_code => p_transaction_line.currency_code,
                                                                    p_user_id       => p_user_id);
        IF v_account_id IS NULL THEN
          RAISE e_revaluation_account_error;
        END IF;
        -- 汇率差异精度
        v_revaluation := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                            p_amount          => v_revaluation,
                                                            p_set_of_books_id => p_set_of_books_id);
        -- 创建汇率差异凭证
        csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                           p_distribution_line_id     => NULL,
                                                           p_source_code              => 'CSH_PAYMENT',
                                                           p_description              => '退款 ' ||
                                                                                         p_source_trx_header.transaction_num,
                                                           p_period_name              => p_transaction_header.period_name,
                                                           p_company_id               => p_transaction_header.company_id,
                                                           p_responsibility_center_id => v_responsibility_center_id,
                                                           p_account_id               => v_account_id,
                                                           p_entered_amount_dr        => NULL,
                                                           p_entered_amount_cr        => 0,
                                                           p_functional_amount_dr     => NULL,
                                                           p_functional_amount_cr     => v_revaluation,
                                                           p_exchange_rate_type       => p_transaction_line.exchange_rate_type,
                                                           p_exchange_rate            => p_transaction_line.exchange_rate,
                                                           p_currency_code            => p_transaction_line.currency_code,
                                                           p_journal_date             => p_transaction_header.transaction_date,
                                                           p_cash_clearing_flag       => NULL,
                                                           p_bank_account_flag        => NULL,
                                                           p_gld_interface_flag       => c_gld_interface_flag_p,
                                                           p_write_off_id             => v_write_off_id,
                                                           p_usage_code               => 'REVALUATION',
                                                           p_user_id                  => p_user_id,
                                                           p_transaction_je_line_id   => v_transaction_je_line_id);
      ELSIF v_revaluation < 0 THEN
        v_account_id := csh_transaction_pkg.get_revaluation_account(p_company_id    => v_company_id,
                                                                    p_currency_code => p_transaction_line.currency_code,
                                                                    p_user_id       => p_user_id);
        IF v_account_id IS NULL THEN
          RAISE e_revaluation_account_error;
        END IF;
        -- 汇率差异精度
        v_revaluation := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                            p_amount          => -1 *
                                                                                 v_revaluation,
                                                            p_set_of_books_id => p_set_of_books_id);
        -- 创建汇率差异凭证
        csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                           p_distribution_line_id     => NULL,
                                                           p_source_code              => 'CSH_PAYMENT',
                                                           p_description              => '退款 ' ||
                                                                                         p_source_trx_header.transaction_num,
                                                           p_period_name              => p_transaction_header.period_name,
                                                           p_company_id               => p_transaction_header.company_id,
                                                           p_responsibility_center_id => v_responsibility_center_id,
                                                           p_account_id               => v_account_id,
                                                           p_entered_amount_dr        => 0,
                                                           p_entered_amount_cr        => NULL,
                                                           p_functional_amount_dr     => v_revaluation,
                                                           p_functional_amount_cr     => NULL,
                                                           p_exchange_rate_type       => p_transaction_line.exchange_rate_type,
                                                           p_exchange_rate            => p_transaction_line.exchange_rate,
                                                           p_currency_code            => p_transaction_line.currency_code,
                                                           p_journal_date             => p_transaction_header.transaction_date,
                                                           p_cash_clearing_flag       => NULL,
                                                           p_bank_account_flag        => NULL,
                                                           p_gld_interface_flag       => c_gld_interface_flag_p,
                                                           p_write_off_id             => v_write_off_id,
                                                           p_usage_code               => 'REVALUATION',
                                                           p_user_id                  => p_user_id,
                                                           p_transaction_je_line_id   => v_transaction_je_line_id);
      END IF;
    END IF;
    -- 调整尾差
    csh_transaction_pkg.set_balance(p_transaction_line_id => p_transaction_line.transaction_line_id);
    /*-- 生成凭证后，插入预置事件
    csh_evt_pkg.fire_workflow_event(p_event_name          => 'CSH_PAYMENT_CREATE_ACCOUNTS',
                                    p_transaction_line_id => p_transaction_line.transaction_line_id,
                                    p_write_off_id        => v_write_off_id,
                                    p_source_module       => 'CSH_PAYMENT_RETURN',
                                    p_event_type          => 'CSH_PAYMENT_CREATE_ACCOUNTS',
                                    p_user_id             => p_user_id);*/
  EXCEPTION
    WHEN e_locked_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_LOCKED_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_bank_account_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_BANK_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_default_resp_error1 THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_DEFAULT_RESP_ERROR1',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_exp_report_account_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_EXP_REPORT_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_intercompany_ar_account THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_INTERCOMPANY_AR_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_default_resp_error2 THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_DEFAULT_RESP_ERROR2',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_intercompany_ap_account THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_INTERCOMPANY_AP_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_exchange_rate_type_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_EXCHANGE_RATE_TYPE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_revaluation_account_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_REVALUATION_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_EXP_REP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END return_payment_exp_rep;

  PROCEDURE return_payment_prepayment(p_rec_csh_write_off        csh_write_off%ROWTYPE,
                                      p_transaction_header       csh_transaction_headers%ROWTYPE, -- 退款事务头
                                      p_transaction_line         csh_transaction_lines%ROWTYPE, -- 退款事务行
                                      p_source_trx_header        csh_transaction_headers%ROWTYPE, -- 原付款事务头
                                      p_return_amount            NUMBER,
                                      p_functional_currency_code VARCHAR2,
                                      p_set_of_books_id          NUMBER,
                                      p_user_id                  NUMBER) IS
    v_prepayment_trx_header       csh_transaction_headers%ROWTYPE;
    v_trx_pmt_schedule_line_id    NUMBER;
    v_payment_requisition_ref_id  NUMBER;
    v_payment_requisition_line_id NUMBER;
    v_payment_schedule_line_id    NUMBER;
    v_csh_transaction_line_id     NUMBER;
    v_write_off_id                NUMBER;
    v_return_amount               NUMBER;
    v_contract_header_id          NUMBER;
    v_transaction_header_id       NUMBER;
    v_transaction_line_id         NUMBER;
    v_responsibility_center_id    NUMBER;
    v_account_id                  NUMBER;
    v_entered_amount              NUMBER;
    v_functional_amount           NUMBER;
    v_exchange_rate_type          gld_exchange_rates.type_code%TYPE;
    v_exchange_rate               NUMBER;
    v_exchange_rate_quotation     gld_exchange_rates.exchange_rate_quotation%TYPE;
    v_count                       NUMBER;
    v_transaction_je_line_id      NUMBER;
    v_pre_exchange_rate_type      VARCHAR2(30);
    v_pre_exchange_rate_quotation VARCHAR2(30);
    v_pre_exchange_rate           NUMBER;
    v_revaluation                 NUMBER;
    v_payment_req_header_id       NUMBER;
    v_pay_req_account             csh_payment_req_accounts%ROWTYPE;
    v_segment9                    VARCHAR2(200);
  
    e_bank_account_error        EXCEPTION;
    e_default_resp_error1       EXCEPTION;
    e_prepayment_account_error  EXCEPTION;
    e_intercompany_ar_account   EXCEPTION;
    e_default_resp_error2       EXCEPTION;
    e_intercompany_ap_account   EXCEPTION;
    e_exchange_rate_type_error  EXCEPTION;
    e_revaluation_account_error EXCEPTION;
  
    v_credit_account_id NUMBER;
    v_csh_pay_req_id    NUMBER; --借款单ID
    v_rd_count          NUMBER; --是否借款单还款
  
    v_description   VARCHAR2(200);
    v_employee_name VARCHAR2(200);
    v_employee_id   number;
    e_locked_error EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_locked_error, -54);
  BEGIN
    --RAISE e_locked_error;
  
    --是否是借款还款产生的付款退款
    SELECT COUNT(1)
      INTO v_rd_count
      FROM csh_repayment_register_dists cr
     WHERE cr.repayment_pay_trx_line_id =
           p_transaction_line.transaction_line_id;
  
    IF (v_rd_count > 0) THEN
      --万联证券贷方科目取原借款单应收科目 
      FOR c1 IN (SELECT l.*,
                        (SELECT DISTINCT t.partner_type_id
                           FROM csh_partner_v t
                          WHERE t.partner_category = l.partner_category
                            AND t.company_id = l.company_id
                            AND t.partner_id = l.partner_id) partner_type_id
                   FROM csh_payment_requisition_lns  l,
                        csh_payment_requisition_refs ef,
                        csh_transaction_v            ct
                  WHERE ef.payment_requisition_line_id =
                        l.payment_requisition_line_id
                    AND ef.csh_transaction_line_id = ct.transaction_line_id
                    AND ct.transaction_header_id =
                        p_source_trx_header.transaction_header_id) LOOP
        acc_build_payment_req_pkg.set_process_id(p_company_id => c1.company_id,
                                                 p_user_id    => p_user_id);
        acc_build_payment_req_pkg.create_mapping_conditions(p_partner_category      => c1.partner_category,
                                                            p_partner_id            => c1.partner_id,
                                                            p_csh_transaction_class => c1.csh_transaction_class_code,
                                                            p_partner_type_id       => c1.partner_type_id);
      
        v_credit_account_id := acc_build_payment_req_pkg.get_account;
        v_csh_pay_req_id    := c1.payment_requisition_line_id;
      END LOOP;
    
      SELECT h.employee_id
        into v_employee_id
        FROM csh_repayment_register_dists c,
             csh_repayment_register_lns   l,
             csh_repayment_register_hds   h
       WHERE c.repayment_pay_trx_line_id =
             p_transaction_line.transaction_line_id
         and c.register_line_id = l.register_line_id
         and l.register_header_id = h.register_header_id
         and rownum = 1;
    
      select e.name
        into v_employee_name
        from exp_employees e
       where e.employee_id = v_employee_id;
    
      v_description := v_employee_name || '归还借款';
    
    END IF;
  
    SELECT h.*
      INTO v_prepayment_trx_header
      FROM csh_transaction_headers h
     WHERE EXISTS (SELECT 1
              FROM csh_transaction_lines l
             WHERE l.transaction_header_id = h.transaction_header_id
               AND l.transaction_line_id =
                   p_rec_csh_write_off.source_csh_trx_line_id)
       FOR UPDATE NOWAIT;
  
    SELECT l.exchange_rate_type, l.exchange_rate_quotation, l.exchange_rate
      INTO v_pre_exchange_rate_type,
           v_pre_exchange_rate_quotation,
           v_pre_exchange_rate
      FROM csh_transaction_lines l
     WHERE l.transaction_header_id =
           v_prepayment_trx_header.transaction_header_id;
  
    v_contract_header_id := NULL;
    -- 生成预付款退款现金事务
    v_transaction_header_id := csh_transaction_pkg.get_csh_transaction_header_id;
    v_transaction_line_id   := csh_transaction_pkg.get_csh_transaction_line_id;
    -- 预付款退款事务金额等于退款金额
    v_return_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_transaction_line.currency_code,
                                                          p_amount          => p_return_amount,
                                                          p_set_of_books_id => p_set_of_books_id);
    -- 创建事务头
    csh_transaction_pkg.insert_csh_transaction_header(p_company_id               => v_prepayment_trx_header.company_id,
                                                      p_transaction_header_id    => v_transaction_header_id,
                                                      p_transaction_type         => 'PREPAYMENT',
                                                      p_transaction_date         => p_transaction_header.transaction_date,
                                                      p_period_name              => p_transaction_header.period_name,
                                                      p_payment_method_id        => p_transaction_header.payment_method_id,
                                                      p_transaction_category     => p_transaction_header.transaction_category,
                                                      p_posted_flag              => csh_transaction_pkg.c_trans_posted_flag_yes,
                                                      p_reversed_flag            => NULL,
                                                      p_reversed_date            => NULL,
                                                      p_returned_flag            => csh_transaction_pkg.c_trans_return_flag_rev,
                                                      p_write_off_flag           => csh_transaction_pkg.c_trans_write_off_flag_n,
                                                      p_write_off_completed_date => NULL,
                                                      p_source_header_id         => v_prepayment_trx_header.transaction_header_id,
                                                      p_gld_interface_flag       => c_gld_interface_flag_p,
                                                      p_transaction_class        => v_prepayment_trx_header.transaction_class,
                                                      p_enabled_write_off_flag   => v_prepayment_trx_header.enabled_write_off_flag,
                                                      p_contract_header_id       => v_contract_header_id,
                                                      p_user_id                  => p_user_id,
                                                      p_source_payment_header_id => p_transaction_header.transaction_header_id);
    -- 创建事务行
    csh_transaction_pkg.insert_csh_transaction_line(p_transaction_header_id   => v_transaction_header_id,
                                                    p_transaction_line_id     => v_transaction_line_id,
                                                    p_transaction_amount      => v_return_amount,
                                                    p_currency_code           => p_transaction_line.currency_code,
                                                    p_exchange_rate_type      => p_transaction_line.exchange_rate_type,
                                                    p_exchange_rate           => p_transaction_line.exchange_rate,
                                                    p_bank_account_id         => p_transaction_line.bank_account_id,
                                                    p_document_num            => p_transaction_line.document_num,
                                                    p_partner_category        => p_transaction_line.partner_category,
                                                    p_partner_id              => p_transaction_line.partner_id,
                                                    p_partner_bank_account_id => p_transaction_line.partner_bank_account_id,
                                                    p_description             => p_transaction_line.description,
                                                    p_handling_charge         => p_transaction_line.handling_charge,
                                                    p_exchange_rate_quotation => p_transaction_line.exchange_rate_quotation,
                                                    p_agent_employee_id       => p_transaction_line.agent_employee_id,
                                                    p_user_id                 => p_user_id);
    v_write_off_id := get_csh_write_off_id;
    -- 创建核销记录
    insert_csh_write_off(p_write_off_id              => v_write_off_id,
                         p_write_off_type            => p_rec_csh_write_off.write_off_type,
                         p_csh_transaction_line_id   => p_rec_csh_write_off.csh_transaction_line_id,
                         p_csh_write_off_amount      => -1 * v_return_amount,
                         p_document_source           => NULL,
                         p_document_header_id        => NULL,
                         p_document_line_id          => NULL,
                         p_document_write_off_amount => NULL,
                         p_write_off_date            => p_transaction_header.transaction_date,
                         p_period_name               => p_transaction_header.period_name,
                         p_source_csh_trx_line_id    => v_transaction_line_id,
                         p_source_write_off_amount   => -1 * v_return_amount,
                         p_gld_interface_flag        => c_gld_interface_flag_p,
                         p_user_id                   => p_user_id);
  
    -- 更新预付款事务退款标志
    csh_transaction_pkg.set_trx_return_status(p_transaction_header_id => v_prepayment_trx_header.transaction_header_id,
                                              p_user_id               => p_user_id);
  
    --v_description := '退款 ' || p_source_trx_header.transaction_num;
    -- 借款申请
    BEGIN
      SELECT t.payment_requisition_line_id, t.csh_transaction_line_id
        INTO v_payment_requisition_line_id, v_csh_transaction_line_id
        FROM csh_payment_requisition_refs t
       WHERE t.write_off_id = p_rec_csh_write_off.write_off_id
         AND t.amount > 0;
    
      csh_transaction_pkg.insert_csh_payment_req_refs(p_payment_requisition_ref_id  => v_payment_requisition_ref_id,
                                                      p_payment_requisition_line_id => v_payment_requisition_line_id,
                                                      p_csh_transaction_line_id     => v_csh_transaction_line_id,
                                                      p_write_off_flag              => NULL,
                                                      p_write_off_id                => v_write_off_id,
                                                      p_amount                      => -1 *
                                                                                       v_return_amount,
                                                      p_description                 => NULL,
                                                      p_user_id                     => p_user_id);
    
      SELECT l.payment_requisition_header_id
        INTO v_payment_req_header_id
        FROM csh_payment_requisition_lns l
       WHERE l.payment_requisition_line_id = v_payment_requisition_line_id;
    
      --modify by wxq 20180420 修改v_description
      SELECT l.payment_requisition_header_id /*, l.description*/
        INTO v_payment_req_header_id /*, v_description*/
        FROM csh_payment_requisition_lns l
       WHERE l.payment_requisition_line_id = v_payment_requisition_line_id;
      SELECT e.name
        INTO v_employee_name
        FROM csh_payment_requisition_hds h, exp_employees e
       WHERE h.payment_requisition_header_id = v_payment_req_header_id
         AND h.employee_id = e.employee_id;
    
      --v_description := v_employee_name || '预支' || v_description;
    
      exp_document_history_pkg.insert_exp_document_histories(p_document_type  => csh_payment_requisition_pkg.c_payment_requisition, --'PAYMENT_REQUISITION',
                                                             p_document_id    => v_payment_req_header_id,
                                                             p_operation_code => exp_document_history_pkg.c_refund, --'REFUND',
                                                             p_user_id        => p_user_id,
                                                             p_operation_time => SYSDATE,
                                                             p_description    => '退款事务编号[' ||
                                                                                 p_transaction_header.transaction_num ||
                                                                                 '],金额:' || -1 *
                                                                                 v_return_amount ||
                                                                                 ' 借款申请单行ID:' ||
                                                                                 v_payment_requisition_line_id);
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    -- 关联合同或合同资金计划行
    BEGIN
      SELECT t.csh_transaction_line_id,
             t.payment_schedule_line_id,
             t.contract_header_id
        INTO v_csh_transaction_line_id,
             v_payment_schedule_line_id,
             v_contract_header_id
        FROM con_cash_trx_pmt_schedule_lns t
       WHERE t.write_off_id = p_rec_csh_write_off.write_off_id
         AND t.amount > 0;
    
      csh_transaction_pkg.insert_trx_pmt_schedule_line(p_trx_pmt_schedule_line_id => v_trx_pmt_schedule_line_id,
                                                       p_csh_transaction_line_id  => v_csh_transaction_line_id,
                                                       p_payment_schedule_line_id => v_payment_schedule_line_id,
                                                       p_amount                   => -1 *
                                                                                     v_return_amount,
                                                       p_user_id                  => p_user_id,
                                                       p_contract_header_id       => v_contract_header_id,
                                                       p_write_off_id             => v_write_off_id);
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    -- 判断当前公司借方凭证是否存在（对应银行存款账户的凭证）
    SELECT COUNT(a.transaction_je_line_id)
      INTO v_count
      FROM csh_transaction_accounts a
     WHERE a.transaction_line_id = p_transaction_line.transaction_line_id
       AND a.company_id = p_transaction_header.company_id
       AND a.entered_amount_cr IS NULL
       AND a.functional_amount_cr IS NULL;
    -- 当前公司借方凭证不存在
    IF v_count = 0 THEN
      --获得银行帐户的责任中心，科目
      csh_transaction_pkg.get_bank_acc_and_resp(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                p_responsibility_center_id => v_responsibility_center_id,
                                                p_account_id               => v_account_id);
      IF v_responsibility_center_id IS NULL OR v_account_id IS NULL THEN
        -- modified by majianjian at 2015-03-16
        -- purpose: 这个异常在头上有定义，但从来没有被捕获过，参考了其他相似的过程，
        --          得出：这个异常应该是写错了，正确的异常是e_bank_account_error,
        --          故做此修改。
        -- raise e_bank_accounts_error;
        RAISE e_bank_account_error;
      END IF;
      -- 原币精度
      v_entered_amount := p_transaction_line.transaction_amount;
      -- 计算本位币金额
      IF p_transaction_line.exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount *
                               p_transaction_line.exchange_rate;
      ELSIF p_transaction_line.exchange_rate_quotation =
            'INDIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount *
                               (1 / p_transaction_line.exchange_rate);
      ELSE
        v_functional_amount := v_entered_amount *
                               p_transaction_line.exchange_rate;
      END IF;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建当前公司借方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq  20180420 修改摘要 --'退款 ' ||p_source_trx_header.transaction_num,
                                                         p_period_name              => p_transaction_header.period_name,
                                                         p_company_id               => p_transaction_header.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => v_entered_amount,
                                                         p_entered_amount_cr        => NULL,
                                                         p_functional_amount_dr     => v_functional_amount,
                                                         p_functional_amount_cr     => NULL,
                                                         p_exchange_rate_type       => p_transaction_line.exchange_rate_type,
                                                         p_exchange_rate            => p_transaction_line.exchange_rate,
                                                         p_currency_code            => p_transaction_line.currency_code,
                                                         p_journal_date             => p_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => 'Y',
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => NULL,
                                                         p_usage_code               => 'CASH_ACCOUNT',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
    
      /*************************************************
      -- Author  : MOUSE
      -- Created : 2015/11/24 22:06:11
      -- Ver     : 1.1
      -- Purpose : 付款退款，现金凭证行,流量项从csh_transaction_pkg.g_cash_flow_item_id带出
      **************************************************/
      /*      select i.cash_flow_line_number
        into v_segment9
        from csh_cash_flow_items i
       where i.cash_flow_item_id = csh_transaction_pkg.g_cash_flow_item_id;
      
      update csh_transaction_accounts a
         set a.account_segment9 = v_segment9
       where a.transaction_je_line_id = v_transaction_je_line_id;
      
      update gl_account_entry e
         set e.segment9 = v_segment9
       where e.transaction_type = 'CSH_TRANSACTION'
             and e.transaction_je_line_id = v_transaction_je_line_id;
      
      gl_log_pkg.log(p_log_text => '退款凭证的借方的现金流量从页面选择的现金流量项带出，退款凭证行ID：' ||
                                   v_transaction_je_line_id || '，现金流量项段为：' ||
                                   v_segment9,
                     p_user_id  => p_user_id);*/
    
      /*************************************************/
    
    END IF;
    IF p_transaction_header.company_id = v_prepayment_trx_header.company_id THEN
      -- 贷方责任中心
      v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => p_transaction_header.company_id);
      IF v_responsibility_center_id IS NULL THEN
        RAISE e_default_resp_error1;
      END IF;
      -- 贷方科目
      v_account_id := csh_transaction_pkg.get_prepayment_account(p_transaction_line_id => v_transaction_line_id,
                                                                 p_user_id             => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_prepayment_account_error; -- 未能取到预付款科目
      END IF;
    
      --万联证券贷方科目取原借款单应收科目
      /*IF (v_rd_count > 0) THEN
        v_account_id := v_credit_account_id;
      END IF;*/
    
      -- 原币
      v_entered_amount := v_return_amount;
      -- 计算本位币金额
      IF v_pre_exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount * v_pre_exchange_rate;
      ELSIF v_pre_exchange_rate_quotation = 'INDIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount * (1 / v_pre_exchange_rate);
      ELSE
        v_functional_amount := v_entered_amount * v_pre_exchange_rate;
      END IF;
      -- 汇率差异
      IF p_transaction_line.exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_revaluation := v_entered_amount *
                         p_transaction_line.exchange_rate;
      ELSIF p_transaction_line.exchange_rate_quotation =
            'INDIRECT QUOTATION' THEN
        v_revaluation := v_entered_amount *
                         (1 / p_transaction_line.exchange_rate);
      ELSE
        v_revaluation := v_entered_amount *
                         p_transaction_line.exchange_rate;
      END IF;
      v_revaluation := v_revaluation - v_functional_amount;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建贷方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq  20180420 修改摘要 --'退款 ' ||p_source_trx_header.transaction_num,
                                                         p_period_name              => p_transaction_header.period_name,
                                                         p_company_id               => p_transaction_header.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => NULL,
                                                         p_entered_amount_cr        => v_entered_amount,
                                                         p_functional_amount_dr     => NULL,
                                                         p_functional_amount_cr     => v_functional_amount,
                                                         p_exchange_rate_type       => p_transaction_line.exchange_rate_type,
                                                         p_exchange_rate            => p_transaction_line.exchange_rate,
                                                         p_currency_code            => p_transaction_line.currency_code,
                                                         p_journal_date             => p_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'PREPAYMENT',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
    
      --万联证券成本中心有特殊逻辑,取借款单应收凭证成本中心
      /*IF (v_rd_count > 0) THEN
        UPDATE csh_transaction_accounts ca
           SET ca.responsibility_center_id =
               (SELECT cp.responsibility_center_id
                  FROM csh_payment_req_accounts cp
                 WHERE cp.usage_code = 'PAYMENT_REQUISITION'
                   AND cp.payment_req_line_id = v_csh_pay_req_id),
               ca.account_segment2        =
               (SELECT cp.account_segment2
                  FROM csh_payment_req_accounts cp
                 WHERE cp.usage_code = 'PAYMENT_REQUISITION'
                   AND cp.payment_req_line_id = v_csh_pay_req_id)
         WHERE ca.transaction_je_line_id = v_transaction_je_line_id;
      
        UPDATE gl_account_entry e
           SET e.segment2 =
               (SELECT cp.account_segment2
                  FROM csh_payment_req_accounts cp
                 WHERE cp.usage_code = 'PAYMENT_REQUISITION'
                   AND cp.payment_req_line_id = v_csh_pay_req_id)
         WHERE e.transaction_type = 'CSH_TRANSACTION'
           AND e.transaction_je_line_id = v_transaction_je_line_id;
      END IF;*/
    
      /*************************************************
      -- Author  : MOUSE
      -- Created : 2015/11/24 18:00:30
      -- Ver     : 1.1
      -- Purpose : 付款退款，贷方凭证取原借款单的借方科目与科目段
      **************************************************/
      /*SELECT *
        INTO v_pay_req_account
        FROM csh_payment_req_accounts a
       WHERE a.payment_req_line_id = v_payment_requisition_line_id
         AND a.usage_code = 'PAYMENT_REQUISITION';
      
        update csh_transaction_accounts a
         set a.account_id        = v_pay_req_account.account_id,
             a.account_segment1  = v_pay_req_account.account_segment1,
             a.account_segment2  = v_pay_req_account.account_segment2,
             a.account_segment3  = v_pay_req_account.account_segment3,
             a.account_segment4  = v_pay_req_account.account_segment4,
             a.account_segment5  = v_pay_req_account.account_segment5,
             a.account_segment6  = v_pay_req_account.account_segment6,
             a.account_segment7  = v_pay_req_account.account_segment7,
             a.account_segment8  = v_pay_req_account.account_segment8,
             a.account_segment9  = v_pay_req_account.account_segment9,
             a.account_segment10 = v_pay_req_account.account_segment10,
             a.account_segment11 = v_pay_req_account.account_segment11
       where a.transaction_je_line_id = v_transaction_je_line_id;
      
      update gl_account_entry e
         set e.account_id   = v_pay_req_account.account_id,
             e.account_code = v_pay_req_account.account_segment3,
             e.segment1     = v_pay_req_account.account_segment1,
             e.segment2     = v_pay_req_account.account_segment2,
             e.segment3     = v_pay_req_account.account_segment3,
             e.segment4     = v_pay_req_account.account_segment4,
             e.segment5     = v_pay_req_account.account_segment5,
             e.segment6     = v_pay_req_account.account_segment6,
             e.segment7     = v_pay_req_account.account_segment7,
             e.segment8     = v_pay_req_account.account_segment8,
             e.segment9     = v_pay_req_account.account_segment9,
             e.segment10    = v_pay_req_account.account_segment10,
             e.segment11    = v_pay_req_account.account_segment11
       where e.transaction_type = 'CSH_TRANSACTION'
             and e.transaction_je_line_id = v_transaction_je_line_id;
      
      gl_log_pkg.log(p_log_text => '退款凭证的贷方从原借款单凭证借方带出，借款单凭证行ID：' ||
                                   v_pay_req_account.je_line_id || '，凭证科目段为：' ||
                                   v_pay_req_account.account_segment1 || '.' ||
                                   v_pay_req_account.account_segment2 || '.' ||
                                   v_pay_req_account.account_segment3 || '.' ||
                                   v_pay_req_account.account_segment4 || '.' ||
                                   v_pay_req_account.account_segment5 || '.' ||
                                   v_pay_req_account.account_segment6 || '.' ||
                                   v_pay_req_account.account_segment7 || '.' ||
                                   v_pay_req_account.account_segment8 || '.' ||
                                   v_pay_req_account.account_segment9 || '.' ||
                                   v_pay_req_account.account_segment10 || '.' ||
                                   v_pay_req_account.account_segment11,
                     p_user_id  => p_user_id);*/
    
      /*************************************************/
      v_revaluation := 0;
      IF v_revaluation > 0 THEN
        v_account_id := csh_transaction_pkg.get_revaluation_account(p_company_id    => p_transaction_header.company_id,
                                                                    p_currency_code => p_transaction_line.currency_code,
                                                                    p_user_id       => p_user_id);
        IF v_account_id IS NULL THEN
          RAISE e_revaluation_account_error;
        END IF;
        -- 汇率差异精度
        v_revaluation := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                            p_amount          => v_revaluation,
                                                            p_set_of_books_id => p_set_of_books_id);
        -- 创建汇率差异凭证
        csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                           p_distribution_line_id     => NULL,
                                                           p_source_code              => 'CSH_PAYMENT',
                                                           p_description              => v_description, --modify by wxq  20180420 修改摘要 --'退款 ' ||p_source_trx_header.transaction_num,
                                                           p_period_name              => p_transaction_header.period_name,
                                                           p_company_id               => p_transaction_header.company_id,
                                                           p_responsibility_center_id => v_responsibility_center_id,
                                                           p_account_id               => v_account_id,
                                                           p_entered_amount_dr        => NULL,
                                                           p_entered_amount_cr        => 0,
                                                           p_functional_amount_dr     => NULL,
                                                           p_functional_amount_cr     => v_revaluation,
                                                           p_exchange_rate_type       => p_transaction_line.exchange_rate_type,
                                                           p_exchange_rate            => p_transaction_line.exchange_rate,
                                                           p_currency_code            => p_transaction_line.currency_code,
                                                           p_journal_date             => p_transaction_header.transaction_date,
                                                           p_cash_clearing_flag       => NULL,
                                                           p_bank_account_flag        => NULL,
                                                           p_gld_interface_flag       => c_gld_interface_flag_p,
                                                           p_write_off_id             => v_write_off_id,
                                                           p_usage_code               => 'REVALUATION',
                                                           p_user_id                  => p_user_id,
                                                           p_transaction_je_line_id   => v_transaction_je_line_id);
      ELSIF v_revaluation < 0 THEN
        v_account_id := csh_transaction_pkg.get_revaluation_account(p_company_id    => p_transaction_header.company_id,
                                                                    p_currency_code => p_transaction_line.currency_code,
                                                                    p_user_id       => p_user_id);
        IF v_account_id IS NULL THEN
          RAISE e_revaluation_account_error;
        END IF;
        -- 汇率差异精度
        v_revaluation := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                            p_amount          => -1 *
                                                                                 v_revaluation,
                                                            p_set_of_books_id => p_set_of_books_id);
        -- 创建汇率差异凭证
        csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                           p_distribution_line_id     => NULL,
                                                           p_source_code              => 'CSH_PAYMENT',
                                                           p_description              => v_description, --modify by wxq  20180420 修改摘要 --'退款 ' ||p_source_trx_header.transaction_num,
                                                           p_period_name              => p_transaction_header.period_name,
                                                           p_company_id               => p_transaction_header.company_id,
                                                           p_responsibility_center_id => v_responsibility_center_id,
                                                           p_account_id               => v_account_id,
                                                           p_entered_amount_dr        => 0,
                                                           p_entered_amount_cr        => NULL,
                                                           p_functional_amount_dr     => v_revaluation,
                                                           p_functional_amount_cr     => NULL,
                                                           p_exchange_rate_type       => p_transaction_line.exchange_rate_type,
                                                           p_exchange_rate            => p_transaction_line.exchange_rate,
                                                           p_currency_code            => p_transaction_line.currency_code,
                                                           p_journal_date             => p_transaction_header.transaction_date,
                                                           p_cash_clearing_flag       => NULL,
                                                           p_bank_account_flag        => NULL,
                                                           p_gld_interface_flag       => c_gld_interface_flag_p,
                                                           p_write_off_id             => v_write_off_id,
                                                           p_usage_code               => 'REVALUATION',
                                                           p_user_id                  => p_user_id,
                                                           p_transaction_je_line_id   => v_transaction_je_line_id);
      END IF;
    ELSE
      -- 跨公司
      -- 当前公司贷方
      v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => p_transaction_header.company_id);
      IF v_responsibility_center_id IS NULL THEN
        RAISE e_default_resp_error1;
      END IF;
      -- 取内部往来应收科目
      v_account_id := csh_transaction_pkg.get_intercompany_ar_account(p_company_id       => p_transaction_header.company_id,
                                                                      p_opposite_company => v_prepayment_trx_header.company_id,
                                                                      p_currency_code    => p_transaction_line.currency_code,
                                                                      p_user_id          => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_intercompany_ar_account;
      END IF;
      -- 原币精度
      v_entered_amount := v_return_amount;
      -- 计算本位币金额
      IF p_transaction_line.exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount *
                               p_transaction_line.exchange_rate;
      ELSIF p_transaction_line.exchange_rate_quotation =
            'INDIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount *
                               (1 / p_transaction_line.exchange_rate);
      ELSE
        v_functional_amount := v_entered_amount *
                               p_transaction_line.exchange_rate;
      END IF;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建当前公司贷方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq  20180420 修改摘要 --'退款 ' ||p_source_trx_header.transaction_num,
                                                         p_period_name              => p_transaction_header.period_name,
                                                         p_company_id               => p_transaction_header.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => NULL,
                                                         p_entered_amount_cr        => v_entered_amount,
                                                         p_functional_amount_dr     => NULL,
                                                         p_functional_amount_cr     => v_functional_amount,
                                                         p_exchange_rate_type       => p_transaction_line.exchange_rate_type,
                                                         p_exchange_rate            => p_transaction_line.exchange_rate,
                                                         p_currency_code            => p_transaction_line.currency_code,
                                                         p_journal_date             => p_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'CSH_INTERCOMPANY_AR',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
      -- 对方公司借方
      v_responsibility_center_id := gld_common_pkg.get_default_resp_center_id(p_company_id => v_prepayment_trx_header.company_id);
      IF v_responsibility_center_id IS NULL THEN
        RAISE e_default_resp_error2;
      END IF;
      -- 取内部往来应付科目
      v_account_id := csh_transaction_pkg.get_intercompany_ap_account(p_company_id       => v_prepayment_trx_header.company_id,
                                                                      p_opposite_company => p_transaction_header.company_id,
                                                                      p_currency_code    => p_transaction_line.currency_code,
                                                                      p_user_id          => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_intercompany_ap_account;
      END IF;
      IF p_transaction_line.currency_code = p_functional_currency_code THEN
        v_exchange_rate_type      := NULL;
        v_exchange_rate_quotation := NULL;
        v_exchange_rate           := 1;
      ELSE
        -- 取对方公司默认汇率
        v_exchange_rate_type := sys_parameter_pkg.value(p_parameter_code => 'DEFAULT_EXCHANGE_RATE_TYPE',
                                                        p_company_id     => v_prepayment_trx_header.company_id);
        IF v_exchange_rate_type IS NULL THEN
          RAISE e_exchange_rate_type_error;
        END IF;
        gld_exchange_rate_pkg.get_exchange_rate(p_company_id              => v_prepayment_trx_header.company_id,
                                                p_from_currency           => p_functional_currency_code,
                                                p_to_currency             => p_transaction_line.currency_code,
                                                p_exchange_rate_type      => v_exchange_rate_type,
                                                p_exchange_date           => p_transaction_header.transaction_date,
                                                p_exchange_period_name    => p_transaction_header.period_name,
                                                p_who_id                  => p_user_id,
                                                p_exchange_rate           => v_exchange_rate,
                                                p_exchange_rate_quotation => v_exchange_rate_quotation);
      END IF;
      -- 计算本位币金额
      IF v_exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount * v_exchange_rate;
      ELSIF v_exchange_rate_quotation = 'INDIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount * (1 / v_exchange_rate);
      ELSE
        v_functional_amount := v_entered_amount * v_exchange_rate;
      END IF;
      -- 汇率差异
      v_revaluation := v_functional_amount;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建对方公司借方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq  20180420 修改摘要 --'退款 ' ||p_source_trx_header.transaction_num,
                                                         p_period_name              => p_transaction_header.period_name,
                                                         p_company_id               => v_prepayment_trx_header.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => v_entered_amount,
                                                         p_entered_amount_cr        => NULL,
                                                         p_functional_amount_dr     => v_functional_amount,
                                                         p_functional_amount_cr     => NULL,
                                                         p_exchange_rate_type       => v_exchange_rate_type,
                                                         p_exchange_rate            => v_exchange_rate,
                                                         p_currency_code            => p_transaction_line.currency_code,
                                                         p_journal_date             => p_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'CSH_INTERCOMPANY_AP',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
      -- 对方公司贷方
      v_account_id := csh_transaction_pkg.get_prepayment_account(p_transaction_line_id => v_transaction_line_id,
                                                                 p_user_id             => p_user_id);
      IF v_account_id IS NULL THEN
        RAISE e_prepayment_account_error; -- 未能取到预付款科目
      END IF;
      -- modified by majianjian at 2015-03-17
      -- purpose: 当涉及到跨公司退款时，生成目标公司的贷方，实际上跟支付公司的汇率无关，因此下面的汇率需要使用目标公司的汇率
      --          而不是支付时的汇率。因此修改以下逻辑。
      -- 计算本位币金额
      /*if v_pre_exchange_rate_quotation = 'DIRECT QUOTATION' then
        v_functional_amount := v_entered_amount * v_pre_exchange_rate;
      elsif v_pre_exchange_rate_quotation = 'INDIRECT QUOTATION' then
        v_functional_amount := v_entered_amount * (1 / v_pre_exchange_rate);
      else
        v_functional_amount := v_entered_amount * v_pre_exchange_rate;
      end if;*/
      IF v_exchange_rate_quotation = 'DIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount * v_exchange_rate;
      ELSIF v_exchange_rate_quotation = 'INDIRECT QUOTATION' THEN
        v_functional_amount := v_entered_amount * (1 / v_exchange_rate);
      ELSE
        v_functional_amount := v_entered_amount * v_exchange_rate;
      END IF;
      --end modifed.
      -- 汇率差异
      v_revaluation := v_revaluation - v_functional_amount;
      -- 本位币精度
      v_functional_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                                p_amount          => v_functional_amount,
                                                                p_set_of_books_id => p_set_of_books_id);
      -- 创建对方公司贷方凭证
      csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                         p_distribution_line_id     => NULL,
                                                         p_source_code              => 'CSH_PAYMENT',
                                                         p_description              => v_description, --modify by wxq  20180420 修改摘要 --'退款 ' ||p_source_trx_header.transaction_num,
                                                         p_period_name              => p_transaction_header.period_name,
                                                         p_company_id               => v_prepayment_trx_header.company_id,
                                                         p_responsibility_center_id => v_responsibility_center_id,
                                                         p_account_id               => v_account_id,
                                                         p_entered_amount_dr        => NULL,
                                                         p_entered_amount_cr        => v_entered_amount,
                                                         p_functional_amount_dr     => NULL,
                                                         p_functional_amount_cr     => v_functional_amount,
                                                         p_exchange_rate_type       => v_exchange_rate_type,
                                                         p_exchange_rate            => v_exchange_rate,
                                                         p_currency_code            => p_transaction_line.currency_code,
                                                         p_journal_date             => p_transaction_header.transaction_date,
                                                         p_cash_clearing_flag       => NULL,
                                                         p_bank_account_flag        => NULL,
                                                         p_gld_interface_flag       => c_gld_interface_flag_p,
                                                         p_write_off_id             => v_write_off_id,
                                                         p_usage_code               => 'PREPAYMENT',
                                                         p_user_id                  => p_user_id,
                                                         p_transaction_je_line_id   => v_transaction_je_line_id);
    
      /*************************************************
      -- Author  : MOUSE
      -- Created : 2015/11/24 18:00:30
      -- Ver     : 1.1
      -- Purpose : 付款退款，贷方凭证取原借款单的借方科目与科目段
      **************************************************/
      SELECT *
        INTO v_pay_req_account
        FROM csh_payment_req_accounts a
       WHERE a.payment_req_line_id = v_payment_requisition_line_id
         AND a.usage_code = 'PAYMENT_REQUISITION';
    
      /*  update csh_transaction_accounts a
         set a.account_id        = v_pay_req_account.account_id,
             a.account_segment1  = v_pay_req_account.account_segment1,
             a.account_segment2  = v_pay_req_account.account_segment2,
             a.account_segment3  = v_pay_req_account.account_segment3,
             a.account_segment4  = v_pay_req_account.account_segment4,
             a.account_segment5  = v_pay_req_account.account_segment5,
             a.account_segment6  = v_pay_req_account.account_segment6,
             a.account_segment7  = v_pay_req_account.account_segment7,
             a.account_segment8  = v_pay_req_account.account_segment8,
             a.account_segment9  = v_pay_req_account.account_segment9,
             a.account_segment10 = v_pay_req_account.account_segment10,
             a.account_segment11 = v_pay_req_account.account_segment11
       where a.transaction_je_line_id = v_transaction_je_line_id;
      
      update gl_account_entry e
         set e.account_id   = v_pay_req_account.account_id,
             e.account_code = v_pay_req_account.account_segment3,
             e.segment1     = v_pay_req_account.account_segment1,
             e.segment2     = v_pay_req_account.account_segment2,
             e.segment3     = v_pay_req_account.account_segment3,
             e.segment4     = v_pay_req_account.account_segment4,
             e.segment5     = v_pay_req_account.account_segment5,
             e.segment6     = v_pay_req_account.account_segment6,
             e.segment7     = v_pay_req_account.account_segment7,
             e.segment8     = v_pay_req_account.account_segment8,
             e.segment9     = v_pay_req_account.account_segment9,
             e.segment10    = v_pay_req_account.account_segment10,
             e.segment11    = v_pay_req_account.account_segment11
       where e.transaction_type = 'CSH_TRANSACTION'
             and e.transaction_je_line_id = v_transaction_je_line_id;
      
      gl_log_pkg.log(p_log_text => '退款凭证的贷方从原借款单凭证借方带出，借款单凭证行ID：' ||
                                   v_pay_req_account.je_line_id || '，凭证科目段为：' ||
                                   v_pay_req_account.account_segment1 || '.' ||
                                   v_pay_req_account.account_segment2 || '.' ||
                                   v_pay_req_account.account_segment3 || '.' ||
                                   v_pay_req_account.account_segment4 || '.' ||
                                   v_pay_req_account.account_segment5 || '.' ||
                                   v_pay_req_account.account_segment6 || '.' ||
                                   v_pay_req_account.account_segment7 || '.' ||
                                   v_pay_req_account.account_segment8 || '.' ||
                                   v_pay_req_account.account_segment9 || '.' ||
                                   v_pay_req_account.account_segment10 || '.' ||
                                   v_pay_req_account.account_segment11,
                     p_user_id  => p_user_id);*/
    
      /*************************************************/
      v_revaluation := 0;
      IF v_revaluation > 0 THEN
        v_account_id := csh_transaction_pkg.get_revaluation_account(p_company_id    => v_prepayment_trx_header.company_id,
                                                                    p_currency_code => p_transaction_line.currency_code,
                                                                    p_user_id       => p_user_id);
        IF v_account_id IS NULL THEN
          RAISE e_revaluation_account_error;
        END IF;
        -- 汇率差异精度
        v_revaluation := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                            p_amount          => v_revaluation,
                                                            p_set_of_books_id => p_set_of_books_id);
        -- 创建汇率差异凭证
        csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                           p_distribution_line_id     => NULL,
                                                           p_source_code              => 'CSH_PAYMENT',
                                                           p_description              => v_description, --modify by wxq  20180420 修改摘要 --'退款 ' ||p_source_trx_header.transaction_num,
                                                           p_period_name              => p_transaction_header.period_name,
                                                           p_company_id               => v_prepayment_trx_header.company_id,
                                                           p_responsibility_center_id => v_responsibility_center_id,
                                                           p_account_id               => v_account_id,
                                                           p_entered_amount_dr        => NULL,
                                                           p_entered_amount_cr        => 0,
                                                           p_functional_amount_dr     => NULL,
                                                           p_functional_amount_cr     => v_revaluation,
                                                           p_exchange_rate_type       => p_transaction_line.exchange_rate_type,
                                                           p_exchange_rate            => p_transaction_line.exchange_rate,
                                                           p_currency_code            => p_transaction_line.currency_code,
                                                           p_journal_date             => p_transaction_header.transaction_date,
                                                           p_cash_clearing_flag       => NULL,
                                                           p_bank_account_flag        => NULL,
                                                           p_gld_interface_flag       => c_gld_interface_flag_p,
                                                           p_write_off_id             => v_write_off_id,
                                                           p_usage_code               => 'REVALUATION',
                                                           p_user_id                  => p_user_id,
                                                           p_transaction_je_line_id   => v_transaction_je_line_id);
      ELSIF v_revaluation < 0 THEN
        v_account_id := csh_transaction_pkg.get_revaluation_account(p_company_id    => v_prepayment_trx_header.company_id,
                                                                    p_currency_code => p_transaction_line.currency_code,
                                                                    p_user_id       => p_user_id);
        IF v_account_id IS NULL THEN
          RAISE e_revaluation_account_error;
        END IF;
        -- 汇率差异精度
        v_revaluation := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_functional_currency_code,
                                                            p_amount          => -1 *
                                                                                 v_revaluation,
                                                            p_set_of_books_id => p_set_of_books_id);
        -- 创建汇率差异凭证
        csh_transaction_pkg.insert_csh_transaction_account(p_transaction_line_id      => p_transaction_line.transaction_line_id,
                                                           p_distribution_line_id     => NULL,
                                                           p_source_code              => 'CSH_PAYMENT',
                                                           p_description              => v_description, --modify by wxq  20180420 修改摘要 --'退款 ' ||p_source_trx_header.transaction_num,
                                                           p_period_name              => p_transaction_header.period_name,
                                                           p_company_id               => v_prepayment_trx_header.company_id,
                                                           p_responsibility_center_id => v_responsibility_center_id,
                                                           p_account_id               => v_account_id,
                                                           p_entered_amount_dr        => 0,
                                                           p_entered_amount_cr        => NULL,
                                                           p_functional_amount_dr     => v_revaluation,
                                                           p_functional_amount_cr     => NULL,
                                                           p_exchange_rate_type       => p_transaction_line.exchange_rate_type,
                                                           p_exchange_rate            => p_transaction_line.exchange_rate,
                                                           p_currency_code            => p_transaction_line.currency_code,
                                                           p_journal_date             => p_transaction_header.transaction_date,
                                                           p_cash_clearing_flag       => NULL,
                                                           p_bank_account_flag        => NULL,
                                                           p_gld_interface_flag       => c_gld_interface_flag_p,
                                                           p_write_off_id             => v_write_off_id,
                                                           p_usage_code               => 'REVALUATION',
                                                           p_user_id                  => p_user_id,
                                                           p_transaction_je_line_id   => v_transaction_je_line_id);
      END IF;
    END IF;
    -- 调整尾差
    csh_transaction_pkg.set_balance(p_transaction_line_id => p_transaction_line.transaction_line_id);
    /* -- 生成凭证后，插入预置事件
    csh_evt_pkg.fire_workflow_event(p_event_name          => 'CSH_PAYMENT_CREATE_ACCOUNTS',
                                    p_transaction_line_id => p_transaction_line.transaction_line_id,
                                    p_write_off_id        => v_write_off_id,
                                    p_source_module       => 'CSH_PAYMENT_RETURN',
                                    p_event_type          => 'CSH_PAYMENT_CREATE_ACCOUNTS',
                                    p_user_id             => p_user_id);*/
  EXCEPTION
    WHEN e_locked_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5240_LOCK_SOURCE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_PREPAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_bank_account_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_BANK_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_PREPAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_default_resp_error1 THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_DEFAULT_RESP_ERROR1',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_PREPAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_prepayment_account_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_PREPAYMENT_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_PREPAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_intercompany_ar_account THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_INTERCOMPANY_AR_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_PREPAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_default_resp_error2 THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_DEFAULT_RESP_ERROR2',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_PREPAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_intercompany_ap_account THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_INTERCOMPANY_AP_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_PREPAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_exchange_rate_type_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_EXCHANGE_RATE_TYPE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_PREPAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_revaluation_account_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_REVALUATION_ACCOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_PAYMENT_PREPAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END return_payment_prepayment;

  PROCEDURE return_csh_trx_write_off(p_session_id            NUMBER,
                                     p_transaction_header_id NUMBER, -- 退款事务头id
                                     p_transaction_line_id   NUMBER, -- 退款事务行id
                                     p_source_trx_header     csh_transaction_headers%ROWTYPE, -- 原付款事务头
                                     p_user_id               NUMBER) IS
    v_csh_write_off            csh_write_off%ROWTYPE;
    v_functional_currency_code gld_set_of_books.functional_currency_code%TYPE;
    v_set_of_books_id          gld_set_of_books.set_of_books_id%TYPE;
    rec_transaction_header     csh_transaction_headers%ROWTYPE;
    rec_transaction_line       csh_transaction_lines%ROWTYPE;
    v_sum_return_amount        NUMBER;
    v_return                   VARCHAR2(200);
  
    CURSOR cur_return_write_off IS
      SELECT t.*
        FROM csh_transaction_return_tmp t
       WHERE t.session_id = p_session_id
         AND t.source_type = 'CSH_WRITE_OFF';
    rec_csh_write_off cur_return_write_off%ROWTYPE;
  
    e_sum_return_amount_error   EXCEPTION;
    e_functional_currency_error EXCEPTION;
    e_set_of_books_error        EXCEPTION;
    e_return_error              EXCEPTION;
    e_write_off_type_error      EXCEPTION;
  BEGIN
    SELECT *
      INTO rec_transaction_header
      FROM csh_transaction_headers h
     WHERE h.transaction_header_id = p_transaction_header_id;
  
    SELECT *
      INTO rec_transaction_line
      FROM csh_transaction_lines l
     WHERE l.transaction_line_id = p_transaction_line_id;
  
    SELECT SUM(t.return_amount)
      INTO v_sum_return_amount
      FROM csh_transaction_return_tmp t
     WHERE t.session_id = p_session_id
       AND t.source_type = 'CSH_WRITE_OFF';
    -- 校验核销行退款金额合计是否等于退款总金额
    IF v_sum_return_amount <> rec_transaction_line.transaction_amount THEN
      RAISE e_sum_return_amount_error;
    END IF;
  
    -- 取公司本位币
    v_functional_currency_code := gld_common_pkg.get_company_currency_code(p_company_id => rec_transaction_header.company_id);
    IF v_functional_currency_code IS NULL THEN
      RAISE e_functional_currency_error;
    END IF;
    -- 取帐套
    v_set_of_books_id := gld_common_pkg.get_set_of_books_id(p_comany_id => rec_transaction_header.company_id);
    IF v_set_of_books_id IS NULL THEN
      RAISE e_set_of_books_error;
    END IF;
  
    OPEN cur_return_write_off;
    LOOP
      FETCH cur_return_write_off
        INTO rec_csh_write_off;
      EXIT WHEN cur_return_write_off%NOTFOUND;
      -- 校验退款金额 同时返回原核销记录
      v_return := check_return_write_off_amt(p_write_off_id  => rec_csh_write_off.source_id,
                                             p_return_amount => rec_csh_write_off.return_amount,
                                             p_csh_write_off => v_csh_write_off);
      IF v_return IS NOT NULL THEN
        RAISE e_return_error;
      END IF;
    
      IF rec_transaction_header.transaction_type = 'PAYMENT' AND
         v_csh_write_off.write_off_type = 'PAYMENT_EXPENSE_REPORT' THEN
        --付款核销报销单
        return_payment_exp_rep(p_rec_csh_write_off        => v_csh_write_off,
                               p_transaction_header       => rec_transaction_header,
                               p_transaction_line         => rec_transaction_line,
                               p_source_trx_header        => p_source_trx_header,
                               p_return_amount            => rec_csh_write_off.return_amount,
                               p_functional_currency_code => v_functional_currency_code,
                               p_set_of_books_id          => v_set_of_books_id,
                               p_user_id                  => p_user_id);
      ELSIF rec_transaction_header.transaction_type = 'PAYMENT' AND
            v_csh_write_off.write_off_type = 'PAYMENT_PREPAYMENT' THEN
        --付款核销预付款
        return_payment_prepayment(p_rec_csh_write_off        => v_csh_write_off,
                                  p_transaction_header       => rec_transaction_header,
                                  p_transaction_line         => rec_transaction_line,
                                  p_source_trx_header        => p_source_trx_header,
                                  p_return_amount            => rec_csh_write_off.return_amount,
                                  p_functional_currency_code => v_functional_currency_code,
                                  p_set_of_books_id          => v_set_of_books_id,
                                  p_user_id                  => p_user_id);
      ELSE
        RAISE e_write_off_type_error;
      END IF;
    END LOOP;
    CLOSE cur_return_write_off;
  EXCEPTION
    WHEN e_return_error THEN
      IF cur_return_write_off%ISOPEN THEN
        CLOSE cur_return_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => v_return,
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_CSH_TRX_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_sum_return_amount_error THEN
      IF cur_return_write_off%ISOPEN THEN
        CLOSE cur_return_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5240_SUM_RETURN_AMOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_CSH_TRX_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_functional_currency_error THEN
      IF cur_return_write_off%ISOPEN THEN
        CLOSE cur_return_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5210_FUNCTIONAL_CURRENCY_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_CSH_TRX_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_set_of_books_error THEN
      IF cur_return_write_off%ISOPEN THEN
        CLOSE cur_return_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5210_SET_OF_BOOKS_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_CSH_TRX_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_write_off_type_error THEN
      IF cur_return_write_off%ISOPEN THEN
        CLOSE cur_return_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5220_WRITE_OFF_TYPE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'RETURN_CSH_TRX_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      IF cur_return_write_off%ISOPEN THEN
        CLOSE cur_return_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                     p_procedure_function_name => 'RETURN_CSH_TRX_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END return_csh_trx_write_off;

  PROCEDURE reverse_prepayment_write_off(p_session_id            NUMBER,
                                         p_transaction_header_id NUMBER, -- 预付款事务头id
                                         p_transaction_line_id   NUMBER, -- 预付款事务行id
                                         p_reverse_date          DATE,
                                         p_user_id               NUMBER) IS
    rec_transaction_header csh_transaction_headers%ROWTYPE;
    rec_write_off          csh_write_off%ROWTYPE;
    v_period_name          gld_periods.period_name%TYPE;
    v_source_write_off_id  NUMBER;
    v_write_off_id         NUMBER;
    v_return               VARCHAR2(200);
    v_write_off_je_line_id NUMBER;
    v_audit_flag           VARCHAR2(1);
    v_write_off_account    csh_write_off_accounts%ROWTYPE;
  
    CURSOR cur_reverse_write_off IS
      SELECT t.write_off_id
        FROM csh_write_off_reverse_tmp t
       WHERE t.session_id = p_session_id;
  
    e_write_off_reversed_completed EXCEPTION;
    e_period_not_open              EXCEPTION;
    e_reverse_date_error           EXCEPTION;
    e_write_off_reversed           EXCEPTION;
    e_locked_error                 EXCEPTION;
    e_expense_report_audit_error   EXCEPTION;
    v_report_num VARCHAR2(200);
    PRAGMA EXCEPTION_INIT(e_locked_error, -54);
  
    v_sum_csh_write_off_amount NUMBER;
    v_transaction_amount       NUMBER;
  BEGIN
    SELECT h.*
      INTO rec_transaction_header
      FROM csh_transaction_headers h
     WHERE h.transaction_header_id = p_transaction_header_id
       FOR UPDATE NOWAIT;
  
    /*    if rec_transaction_header.write_off_flag =
       csh_transaction_pkg.c_trans_write_off_flag_n then
      raise e_write_off_reversed_completed;
    end if;*/
    -- 期间
    v_period_name := gld_common_pkg.get_gld_period_name(p_company_id => rec_transaction_header.company_id,
                                                        p_date       => p_reverse_date);
    IF v_period_name IS NULL THEN
      RAISE e_period_not_open;
    END IF;
  
    OPEN cur_reverse_write_off;
    LOOP
      FETCH cur_reverse_write_off
        INTO v_source_write_off_id;
      EXIT WHEN cur_reverse_write_off%NOTFOUND;
    
      SELECT w.*
        INTO rec_write_off
        FROM csh_write_off w
       WHERE w.write_off_id = v_source_write_off_id;
      --校验可否反冲
      SELECT h.audit_flag, h.exp_report_number
        INTO v_audit_flag, v_report_num
        FROM exp_report_headers h, exp_report_pmt_schedules s
       WHERE h.exp_report_header_id = s.exp_report_header_id
         AND s.payment_schedule_line_id = rec_write_off.document_line_id
         AND s.exp_report_header_id = rec_write_off.document_header_id;
      IF v_audit_flag <> 'Y' THEN
        RAISE e_expense_report_audit_error;
      END IF;
    
      IF (rec_write_off.csh_write_off_amount < 0) THEN
        RAISE e_write_off_reversed_completed;
      END IF;
    
      SELECT SUM(c.csh_write_off_amount)
        INTO v_sum_csh_write_off_amount
        FROM csh_write_off c, csh_write_off s
       WHERE c.write_off_type = 'PREPAYMENT_EXPENSE_REPORT'
         AND c.document_source = 'EXPENSE_REPORT'
         AND c.csh_transaction_line_id = s.csh_transaction_line_id
         AND c.document_header_id = s.document_header_id
         AND c.document_line_id = s.document_line_id
         AND s.write_off_id = v_source_write_off_id
         AND c.write_off_id <> v_source_write_off_id;
    
      IF (v_sum_csh_write_off_amount < 0) THEN
        RAISE e_write_off_reversed_completed;
      END IF;
    
      -- 校验反冲日期
      IF trunc(p_reverse_date) < rec_write_off.write_off_date THEN
        RAISE e_reverse_date_error;
      END IF;
      -- 校验核销记录是否已被反冲
      v_return := check_write_off_reversed(p_csh_write_off => rec_write_off);
      IF v_return IS NOT NULL THEN
        RAISE e_write_off_reversed;
      END IF;
    
      v_write_off_id := get_csh_write_off_id;
      -- 生成核销反冲记录
      insert_csh_write_off(p_write_off_id              => v_write_off_id,
                           p_write_off_type            => rec_write_off.write_off_type,
                           p_csh_transaction_line_id   => rec_write_off.csh_transaction_line_id,
                           p_csh_write_off_amount      => -1 *
                                                          rec_write_off.csh_write_off_amount,
                           p_document_source           => rec_write_off.document_source,
                           p_document_header_id        => rec_write_off.document_header_id,
                           p_document_line_id          => rec_write_off.document_line_id,
                           p_document_write_off_amount => -1 *
                                                          rec_write_off.document_write_off_amount,
                           p_write_off_date            => p_reverse_date,
                           p_period_name               => v_period_name,
                           p_source_csh_trx_line_id    => NULL,
                           p_source_write_off_amount   => NULL,
                           p_gld_interface_flag        => c_gld_interface_flag_p,
                           p_user_id                   => p_user_id);
      -- 生成反冲凭证
      FOR rec_write_off_account IN (SELECT *
                                      FROM csh_write_off_accounts a
                                     WHERE a.write_off_id =
                                           v_source_write_off_id) LOOP
        v_write_off_je_line_id := get_csh_write_off_je_line_id;
        insert_csh_write_off_accounts(p_write_off_id             => v_write_off_id,
                                      p_write_off_je_line_id     => v_write_off_je_line_id,
                                      p_description              => '预付款核销反冲',
                                      p_period_name              => v_period_name,
                                      p_source_code              => rec_write_off_account.source_code,
                                      p_company_id               => rec_write_off_account.company_id,
                                      p_responsibility_center_id => rec_write_off_account.responsibility_center_id,
                                      p_account_id               => rec_write_off_account.account_id,
                                      p_currency_code            => rec_write_off_account.currency_code,
                                      p_exchange_rate_type       => rec_write_off_account.exchange_rate_type,
                                      p_exchange_rate            => rec_write_off_account.exchange_rate,
                                      p_entered_amount_dr        => -1 *
                                                                    rec_write_off_account.entered_amount_dr,
                                      p_entered_amount_cr        => -1 *
                                                                    rec_write_off_account.entered_amount_cr,
                                      p_functional_amount_dr     => -1 *
                                                                    rec_write_off_account.functional_amount_dr,
                                      p_functional_amount_cr     => -1 *
                                                                    rec_write_off_account.functional_amount_cr,
                                      p_cash_clearing_flag       => rec_write_off_account.cash_clearing_flag,
                                      p_journal_date             => p_reverse_date,
                                      p_gld_interface_flag       => c_gld_interface_flag_p,
                                      p_usage_code               => rec_write_off_account.usage_code,
                                      p_user_id                  => p_user_id);
        -- 生成凭证后，插入预置事件
        csh_evt_pkg.fire_workflow_event(p_event_name          => 'CSH_PREPAYMENT_CREATE_ACCOUNTS',
                                        p_transaction_line_id => rec_write_off.csh_transaction_line_id,
                                        p_trx_je_line_id      => v_write_off_je_line_id,
                                        p_source_module       => 'CSH_PREPAYMENT_REVERSE',
                                        p_event_type          => 'CSH_PREPAYMENT_CREATE_ACCOUNTS',
                                        p_user_id             => p_user_id);
      
        /*************************************************
        -- Author  : MOUSE
        -- Created : 2015/11/24 13:57:39
        -- Ver     : 1.1
        -- Purpose : 核销凭证反冲凭证从原凭证带出SEGMENT段
        **************************************************/
        SELECT *
          INTO v_write_off_account
          FROM csh_write_off_accounts a
         WHERE a.write_off_je_line_id =
               rec_write_off_account.write_off_je_line_id;
      
        UPDATE csh_write_off_accounts a
           SET a.account_segment1  = v_write_off_account.account_segment1,
               a.account_segment2  = v_write_off_account.account_segment2,
               a.account_segment3  = v_write_off_account.account_segment3,
               a.account_segment4  = v_write_off_account.account_segment4,
               a.account_segment5  = v_write_off_account.account_segment5,
               a.account_segment6  = v_write_off_account.account_segment6,
               a.account_segment7  = v_write_off_account.account_segment7,
               a.account_segment8  = v_write_off_account.account_segment8,
               a.account_segment9  = v_write_off_account.account_segment9,
               a.account_segment10 = v_write_off_account.account_segment10,
               a.account_segment11 = v_write_off_account.account_segment11
         WHERE a.write_off_je_line_id = v_write_off_je_line_id;
      
        UPDATE gl_account_entry e
           SET e.account_id   = v_write_off_account.account_id,
               e.account_code = v_write_off_account.account_segment3,
               e.segment1     = v_write_off_account.account_segment1,
               e.segment2     = v_write_off_account.account_segment2,
               e.segment3     = v_write_off_account.account_segment3,
               e.segment4     = v_write_off_account.account_segment4,
               e.segment5     = v_write_off_account.account_segment5,
               e.segment6     = v_write_off_account.account_segment6,
               e.segment7     = v_write_off_account.account_segment7,
               e.segment8     = v_write_off_account.account_segment8,
               e.segment9     = v_write_off_account.account_segment9,
               e.segment10    = v_write_off_account.account_segment10,
               e.segment11    = v_write_off_account.account_segment11,
               e.attribute12  = v_report_num ---预付款核销反冲凭证，增加来源单据编号  add by Shen Jinan 20171228
         WHERE e.transaction_type = 'CSH_WRITE_OFF'
           AND e.transaction_je_line_id = v_write_off_je_line_id;
      
        gl_log_pkg.log(p_log_text => '核销凭证的反冲凭证从原凭证带出，原凭证行ID为：' ||
                                     rec_write_off_account.write_off_je_line_id ||
                                     '，凭证科目段为：' ||
                                     v_write_off_account.account_segment1 || '.' ||
                                     v_write_off_account.account_segment2 || '.' ||
                                     v_write_off_account.account_segment3 || '.' ||
                                     v_write_off_account.account_segment4 || '.' ||
                                     v_write_off_account.account_segment5 || '.' ||
                                     v_write_off_account.account_segment6 || '.' ||
                                     v_write_off_account.account_segment7 || '.' ||
                                     v_write_off_account.account_segment8 || '.' ||
                                     v_write_off_account.account_segment9 || '.' ||
                                     v_write_off_account.account_segment10 || '.' ||
                                     v_write_off_account.account_segment11,
                       p_user_id  => p_user_id);
      
      /*************************************************/
      END LOOP;
      -- 更新报销单核销状态
      set_exp_rep_write_off_status(p_exp_report_header_id => rec_write_off.document_header_id,
                                   p_user_id              => p_user_id);
      -- 更新报销单支付状态
      UPDATE csh_doc_payment_company t
         SET t.payment_status   = 'ALLOWED',
             t.last_update_date = SYSDATE,
             t.last_updated_by  = p_user_id
       WHERE t.document_type = 'EXP_REPORT'
         AND t.document_id = rec_write_off.document_header_id
         AND t.document_line_id = rec_write_off.document_line_id;
      -- 插入'跟踪单据'信息
    
      exp_document_history_pkg.insert_exp_document_histories(p_document_type  => exp_report_pkg.c_exp_report, --'EXP_REPORT',
                                                             p_document_id    => rec_write_off.document_header_id,
                                                             p_operation_code => exp_document_history_pkg.c_pay, --'PAY',
                                                             p_user_id        => p_user_id,
                                                             p_operation_time => SYSDATE,
                                                             p_description    => '核销反冲交易编号[' ||
                                                                                 rec_transaction_header.transaction_num ||
                                                                                 '],金额:' || -1 *
                                                                                 rec_write_off.document_write_off_amount);
    END LOOP;
    -- 更新现金事务核销状态
    set_csh_trx_write_off_status(p_transaction_header_id => p_transaction_header_id,
                                 p_transaction_line_id   => p_transaction_line_id,
                                 p_transaction_type      => rec_transaction_header.transaction_type,
                                 p_user_id               => p_user_id);
    CLOSE cur_reverse_write_off;
    -- 删除临时数据
    delete_csh_write_off_rev_tmp(p_session_id => p_session_id,
                                 p_user_id    => p_user_id);
    -- 生成凭证后，按头ID插入预置事件 zhangjie 2009-10-07
    csh_evt_pkg.fire_workflow_event(p_event_name          => 'CSH_PREPAYMENT_CREATE_HEADER_ACCOUNTS',
                                    p_transaction_line_id => p_transaction_header_id,
                                    p_trx_je_line_id      => '',
                                    p_source_module       => 'REVERSE_PREPAYMENT_WRITE_OFF',
                                    p_event_type          => 'CSH_PREPAYMENT_CREATE_HEADER_ACCOUNTS',
                                    p_user_id             => p_user_id);
  EXCEPTION
    WHEN e_locked_error THEN
      IF cur_reverse_write_off%ISOPEN THEN
        CLOSE cur_reverse_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5250_LOCK_SOURCE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'REVERSE_PREPAYMENT_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_write_off_reversed_completed THEN
      IF cur_reverse_write_off%ISOPEN THEN
        CLOSE cur_reverse_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5250_REVERSED_COMPLETED_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'REVERSE_PREPAYMENT_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_period_not_open THEN
      IF cur_reverse_write_off%ISOPEN THEN
        CLOSE cur_reverse_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5210_PERIOD_NOT_OPEN_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'REVERSE_PREPAYMENT_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_reverse_date_error THEN
      IF cur_reverse_write_off%ISOPEN THEN
        CLOSE cur_reverse_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5250_REVERSE_DATE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'REVERSE_PREPAYMENT_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_write_off_reversed THEN
      IF cur_reverse_write_off%ISOPEN THEN
        CLOSE cur_reverse_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5250_REVERSED_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'REVERSE_PREPAYMENT_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_expense_report_audit_error THEN
      IF cur_reverse_write_off%ISOPEN THEN
        CLOSE cur_reverse_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5250_EXPENSE_REPORT_AUDIT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                      p_procedure_function_name => 'REVERSE_PREPAYMENT_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      IF cur_reverse_write_off%ISOPEN THEN
        CLOSE cur_reverse_write_off;
      END IF;
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CSH_WRITE_OFF_PKG',
                                                     p_procedure_function_name => 'REVERSE_PREPAYMENT_WRITE_OFF');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END reverse_prepayment_write_off;

END csh_write_off_pkg;
/
