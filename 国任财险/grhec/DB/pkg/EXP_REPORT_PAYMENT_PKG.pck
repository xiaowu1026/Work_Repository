CREATE OR REPLACE PACKAGE "EXP_REPORT_PAYMENT_PKG" IS

  -- Author  : Razgriz.Tang
  -- Created : 2009-7-20
  -- Purpose : 报销单支付
  /** *************** Update:
      version：  update by   date         rote
       v1.01     zl1966      05-20-2010   解决mantis 0029734: 报销单反冲后还可以支付；
                                          在insert_exp_report_payment_tmp()中
                                          对支付的单据增加是否已被反冲的校验
  *********************/

  --Ver:1.10
  --Modify by huyunbo 2012-4-19
  --在insert_exp_report_payment_tmp过程中增加了资金支付接口事件

  --全局变量
  g_pay_from_acp_flag     VARCHAR2(1) := 'N';
  g_transaction_header_id NUMBER;
  g_transaction_line_id   NUMBER;

  -- Public function and procedure declarations
  PROCEDURE insert_exp_report_payment_tmp(p_session_id               NUMBER,
                                          p_payment_schedule_line_id NUMBER,
                                          p_payment_amount           NUMBER,
                                          p_user_id                  NUMBER);

  PROCEDURE delete_exp_report_payment_tmp(p_session_id NUMBER,
                                          p_user_id    NUMBER);

  --===========================================
  -- 万联证券,报销单支付
  -- 收款方相同时,不合并支付
  --===========================================
  PROCEDURE execute_exp_report_pay_wlzq(p_session_id              NUMBER,
                                        p_company_id              NUMBER,
                                        p_payment_date            DATE,
                                        p_currency_code           VARCHAR2,
                                        p_exchange_rate_type      VARCHAR2,
                                        p_exchange_rate_quotation VARCHAR2,
                                        p_exchange_rate           NUMBER,
                                        p_bank_account_id         NUMBER,
                                        p_description             VARCHAR2,
                                        p_cash_flow_item_id       NUMBER,
                                        p_payment_method_id       NUMBER,
                                        p_user_id                 NUMBER,
                                        p_acp_equisition_number   VARCHAR2 DEFAULT NULL,
                                        p_batch_id                IN OUT NUMBER);

  /**
  * 处理报销单支付业务
  */
  PROCEDURE execute_exp_report_payment(p_session_id              NUMBER,
                                       p_company_id              NUMBER,
                                       p_payment_date            DATE,
                                       p_currency_code           VARCHAR2,
                                       p_exchange_rate_type      VARCHAR2,
                                       p_exchange_rate_quotation VARCHAR2,
                                       p_exchange_rate           NUMBER,
                                       p_bank_account_id         NUMBER,
                                       p_description             VARCHAR2,
                                       p_cash_flow_item_id       NUMBER,
                                       p_payment_method_id       NUMBER,
                                       p_user_id                 NUMBER);

  /**
    处理报销单从付款申请单支付
  **/
  PROCEDURE execute_exp_rep_pay_from_acp(p_session_id              NUMBER,
                                         p_acp_requisition_line_id NUMBER,
                                         p_payment_amount          NUMBER,
                                         p_company_id              NUMBER,
                                         p_payment_date            DATE,
                                         p_currency_code           VARCHAR2,
                                         p_exchange_rate_type      VARCHAR2,
                                         p_exchange_rate_quotation VARCHAR2,
                                         p_exchange_rate           NUMBER,
                                         p_bank_account_id         NUMBER,
                                         p_description             VARCHAR2,
                                         p_cash_flow_item_id       NUMBER,
                                         p_payment_method_id       NUMBER,
                                         p_user_id                 NUMBER,
                                         p_transaction_header_id   OUT NUMBER,
                                         p_transaction_line_id     OUT NUMBER,
                                         p_write_off_id            OUT NUMBER,
                                         p_batch_id                IN OUT NUMBER);

  --获取插入csh_payment_messages表里面的line_id
  FUNCTION get_csh_payment_messages_id(p_exp_report_header_id     NUMBER,
                                       p_payment_schedule_line_id NUMBER,
                                       p_payment_method_id        NUMBER,
                                       p_user_id                  NUMBER)
    RETURN NUMBER;

  --插入现金支付信息表
  PROCEDURE insert_csh_payment_messages(p_line_id          OUT NUMBER,
                                        p_company_id       NUMBER,
                                        p_currency         VARCHAR2,
                                        p_payee_category   VARCHAR2,
                                        p_payee_id         NUMBER,
                                        p_payee_date       DATE,
                                        p_due_amount       NUMBER,
                                        p_description      VARCHAR2,
                                        p_payment_type_id  VARCHAR2,
                                        p_account_name     VARCHAR2,
                                        p_account_number   VARCHAR2,
                                        p_document_type    VARCHAR2,
                                        p_document_id      VARCHAR2,
                                        p_document_number  VARCHAR2,
                                        p_document_line_id NUMBER,
                                        p_user_id          NUMBER);

  FUNCTION insert_csh_transaction_details(p_event_record_id     NUMBER,
                                          p_event_handle_log_id NUMBER,
                                          p_event_param         NUMBER,
                                          p_user_id             NUMBER)
    RETURN NUMBER;

END exp_report_payment_pkg;
/
CREATE OR REPLACE PACKAGE BODY "EXP_REPORT_PAYMENT_PKG" IS
  e_reverse_flag_error EXCEPTION;
  g_acp_requisition_line_id NUMBER;
  -- Function and procedure implementations
  PROCEDURE insert_exp_report_payment_tmp(p_session_id               NUMBER,
                                          p_payment_schedule_line_id NUMBER,
                                          p_payment_amount           NUMBER,
                                          p_user_id                  NUMBER) IS
    v_reversed_flag exp_report_headers.reversed_flag%TYPE;
  BEGIN
    SELECT t.reversed_flag
      INTO v_reversed_flag
      FROM exp_report_headers t, exp_report_pmt_schedules s
     WHERE t.exp_report_header_id = s.exp_report_header_id
       AND s.payment_schedule_line_id = p_payment_schedule_line_id
       FOR UPDATE NOWAIT;
  
    IF v_reversed_flag IS NOT NULL THEN
      RAISE e_reverse_flag_error;
    END IF;
  
    INSERT INTO exp_report_payment_tmp
      (session_id,
       payment_schedule_line_id,
       payment_amount,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by)
    VALUES
      (p_session_id,
       p_payment_schedule_line_id,
       p_payment_amount,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_user_id);
  
  EXCEPTION
    WHEN e_reverse_flag_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5150_REVERSE_FLAG_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'exp_report_payment_pkg',
                                                      p_procedure_function_name => 'insert_exp_report_payment_tmp');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                     p_procedure_function_name => 'INSERT_EXP_REPORT_PAYMENT_TMP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_exp_report_payment_tmp;

  PROCEDURE delete_exp_report_payment_tmp(p_session_id NUMBER,
                                          p_user_id    NUMBER) IS
  BEGIN
    DELETE FROM exp_report_payment_tmp WHERE session_id = p_session_id;
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                     p_procedure_function_name => 'DELETE_EXP_REPORT_PAYMENT_TMP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END delete_exp_report_payment_tmp;

  /*************************************************
  -- Author  : Rick
  -- Created : 
  -- Ver     : 1.0
  -- Purpose : 往支付接口表中插入数据
  **************************************************/
  PROCEDURE insert_payment_details_wlzq(p_csh_msg_line_id           NUMBER, --收款行信息
                                        p_csh_transaction_header_id NUMBER,
                                        p_csh_transaction_line_id   NUMBER,
                                        p_cash_flow_item_id         NUMBER, --现金流
                                        p_user_id                   NUMBER,
                                        p_document_type             VARCHAR2,
                                        p_document_head_id          NUMBER,
                                        p_write_tmp_session_id      NUMBER,
                                        p_acp_equisition_number     VARCHAR2 DEFAULT NULL) IS
    v_payment_record      csh_payment_messages%ROWTYPE;
    v_trans_header_record csh_transaction_headers%ROWTYPE;
    v_trans_line_record   csh_transaction_lines%ROWTYPE;
    v_company_code        fnd_companies.company_code%TYPE;
    v_partner_code        VARCHAR2(100);
    v_partner_name        VARCHAR2(100);
  
    v_payee_bank_code          exp_employee_accounts.bank_code%TYPE;
    v_payee_bank_name          exp_employee_accounts.bank_name%TYPE;
    v_payee_bank_location_code exp_employee_accounts.bank_location_code%TYPE;
    v_payee_bank_location      exp_employee_accounts.bank_location%TYPE;
    v_payee_province_code      exp_employee_accounts.province_code%TYPE;
    v_payee_province_name      exp_employee_accounts.province_name%TYPE;
    v_payee_city_code          exp_employee_accounts.city_code%TYPE;
    v_payee_city_name          exp_employee_accounts.city_name%TYPE;
    v_payee_account_type       csh_transaction_details.payee_account_type%TYPE;
  
    v_csh_payment_methods      csh_payment_methods%ROWTYPE;
    v_exp_report_pmt_schedules exp_report_pmt_schedules%ROWTYPE;
    v_csh_bank_accounts        csh_bank_accounts_vl%ROWTYPE;
  
    v_exp_report_number        VARCHAR2(100);
    v_cux_pay_trans_details_id NUMBER;
    v_error                EXCEPTION;
    e_gather_bank_num_null EXCEPTION;
    v_summary VARCHAR2(200);
  BEGIN
    v_cux_pay_trans_details_id := cux_pay_trans_details_s.nextval;
  
    --获取交易事务（付款）头信息
    SELECT *
      INTO v_trans_header_record
      FROM csh_transaction_headers cth
     WHERE cth.transaction_header_id = p_csh_transaction_header_id;
    --获取交易事务（付款）行信息
    SELECT *
      INTO v_trans_line_record
      FROM csh_transaction_lines ctl
     WHERE ctl.transaction_header_id = p_csh_transaction_header_id
       AND ctl.transaction_line_id = p_csh_transaction_line_id;
    --付款账号
    SELECT *
      INTO v_csh_bank_accounts
      FROM csh_bank_accounts_vl cb
     WHERE cb.bank_account_id = v_trans_line_record.bank_account_id;
  
    -- 付款方式
    SELECT *
      INTO v_csh_payment_methods
      FROM csh_payment_methods c
     WHERE c.payment_method_id = v_trans_header_record.payment_method_id;
    --获取收款行信息
    SELECT *
      INTO v_payment_record
      FROM csh_payment_messages cpm
     WHERE cpm.line_id = p_csh_msg_line_id;
  
    IF g_acp_requisition_line_id IS NOT NULL THEN
      -- 付款单支付
      SELECT erps.*
        INTO v_exp_report_pmt_schedules
        FROM acp_acp_requisition_lns l, exp_report_pmt_schedules erps
       WHERE l.ref_document_line_id = erps.payment_schedule_line_id
         AND l.acp_requisition_line_id = v_payment_record.document_line_id;
    ELSE
      --计划付款行
      SELECT *
        INTO v_exp_report_pmt_schedules
        FROM exp_report_pmt_schedules erps
       WHERE erps.payment_schedule_line_id =
             v_payment_record.document_line_id;
    END IF;
  
    SELECT h.exp_report_number
      INTO v_exp_report_number
      FROM exp_report_headers h
     WHERE h.exp_report_header_id =
           v_exp_report_pmt_schedules.exp_report_header_id;
  
    --获取company_code
    SELECT fc.company_code
      INTO v_company_code
      FROM fnd_companies fc
     WHERE fc.company_id = v_payment_record.company_id;
  
    --获取收款方代码及名称
    BEGIN
      IF v_payment_record.payee_category = 'EMPLOYEE' THEN
        SELECT ee.employee_code, ee.name
          INTO v_partner_code, v_partner_name
          FROM exp_employees ee
         WHERE ee.employee_id = v_payment_record.payee_id;
      
      ELSIF v_payment_record.payee_category = 'VENDER' THEN
        SELECT psv.vender_code, psv.description
          INTO v_partner_code, v_partner_name
          FROM pur_system_venders_vl psv
         WHERE psv.vender_id = v_payment_record.payee_id;
      
      ELSE
        SELECT osc.customer_code, osc.description
          INTO v_partner_code, v_partner_name
          FROM ord_system_customers_vl osc
         WHERE osc.customer_id = v_payment_record.payee_id;
      
      END IF;
    
    EXCEPTION
      WHEN OTHERS THEN
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '获取收款方代码及名称时发生错误!\n' ||
                                                                                    dbms_utility.format_error_stack,
                                                       p_created_by              => p_user_id,
                                                       p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                       p_procedure_function_name => 'insert_csh_transaction_details');
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
      
    END;
  
    --获取收款人银行信息
    BEGIN
      IF v_payment_record.payee_category = 'EMPLOYEE' THEN
        SELECT eea.bank_code,
               eea.bank_name,
               eea.bank_location_code,
               eea.bank_location,
               eea.province_code,
               eea.province_name,
               eea.city_code,
               eea.city_name,
               eea.account_flag
          INTO v_payee_bank_code,
               v_payee_bank_name,
               v_payee_bank_location_code,
               v_payee_bank_location,
               v_payee_province_code,
               v_payee_province_name,
               v_payee_city_code,
               v_payee_city_name,
               v_payee_account_type
          FROM exp_employee_accounts eea
         WHERE eea.employee_id = v_payment_record.payee_id
           AND eea.account_number = v_payment_record.account_number
           AND eea.enabled_flag = 'Y';
        --AND eea.account_name = v_payment_record.account_name;
      
      ELSIF v_payment_record.payee_category = 'VENDER' THEN
        SELECT pva.bank_code,
               pva.bank_name,
               --pva.bank_location_code,
               nvl(pva.sparticipantbankno, pva.bank_location_code),
               pva.bank_location,
               pva.province_code,
               pva.province_name,
               pva.city_code,
               pva.city_name,
               pva.account_flag
          INTO v_payee_bank_code,
               v_payee_bank_name,
               v_payee_bank_location_code,
               v_payee_bank_location,
               v_payee_province_code,
               v_payee_province_name,
               v_payee_city_code,
               v_payee_city_name,
               v_payee_account_type
          FROM pur_vender_accounts pva
         WHERE pva.vender_id = v_payment_record.payee_id
           AND pva.account_number = v_payment_record.account_number
           AND pva.enabled_flag = 'Y';
        --AND pva.account_name = v_payment_record.account_name;
      
      ELSE
        SELECT oca.bank_code,
               oca.bank_name,
               oca.bank_location_code,
               oca.bank_location,
               oca.province_code,
               oca.province_name,
               oca.city_code,
               oca.city_name
          INTO v_payee_bank_code,
               v_payee_bank_name,
               v_payee_bank_location_code,
               v_payee_bank_location,
               v_payee_province_code,
               v_payee_province_name,
               v_payee_city_code,
               v_payee_city_name
          FROM ord_customer_accounts oca
         WHERE oca.customer_id = v_payment_record.payee_id
           AND oca.account_number = v_payment_record.account_number;
        --AND oca.account_name = v_payment_record.account_name;
      END IF;
      --检验银行账号是否包含空格和回车
      IF (instr(v_payment_record.account_number, chr(10)) > 0 OR
         instr(v_payment_record.account_number, ' ') > 0 OR
         instr(v_payment_record.account_number, chr(13)) > 0) THEN
        RAISE v_error;
      END IF;
    
      --add by lyh 2017.7.28
      --如果银行联行号为空，抛异常
      IF (v_payee_bank_location_code IS NULL) THEN
        RAISE e_gather_bank_num_null;
      END IF;
    EXCEPTION
      WHEN v_error THEN
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '收款方银行账号存在空格或回车符，请检查！',
                                                       p_created_by              => p_user_id,
                                                       p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                       p_procedure_function_name => 'insert_csh_transaction_details');
      WHEN no_data_found THEN
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '收款方银行信息不存在，请配置!\n' ||
                                                                                    dbms_utility.format_error_stack,
                                                       p_created_by              => p_user_id,
                                                       p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                       p_procedure_function_name => 'insert_csh_transaction_details');
        ----add by wulei:校验员工账户信息与预设值是否一致,不需要这个校验
      /*raise_application_error(sys_raise_app_error_pkg.c_error_number,
      sys_raise_app_error_pkg.g_err_line_id);*/
      WHEN too_many_rows THEN
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '该收款方银行信息同时存在多个，请修改!\n' ||
                                                                                    dbms_utility.format_error_stack,
                                                       p_created_by              => p_user_id,
                                                       p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                       p_procedure_function_name => 'insert_csh_transaction_details');
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
      
      WHEN e_gather_bank_num_null THEN
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '收款方的银行联行号为空，请维护！',
                                                       p_created_by              => p_user_id,
                                                       p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                       p_procedure_function_name => 'insert_csh_transaction_details');
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
      WHEN OTHERS THEN
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '获取收款方银行信息时发生错误!\n' ||
                                                                                    dbms_utility.format_error_stack,
                                                       p_created_by              => p_user_id,
                                                       p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                       p_procedure_function_name => 'insert_csh_transaction_details');
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
      
    END;
  
    SELECT decode(v_payee_account_type, '10', '0', '1')
      INTO v_payee_account_type
      FROM dual;
  
    IF (v_trans_line_record.transaction_amount = 0) THEN
      RETURN;
    END IF;
  
    -- 摘要
    IF (v_payee_account_type = '0') THEN
      v_summary := '付款';
    ELSE
      v_summary := '报销款';
    END IF;
  
    INSERT INTO cux_pay_trans_details
      (cux_pay_trans_details_id,
       bill_number,
       trade_code,
       csh_transaction_line_id,
       csh_transaction_header_id,
       document_type,
       document_head_id,
       payment_method_code,
       gather_account_name,
       gather_account,
       gather_bank_class,
       gather_bank_number,
       gather_bank_name,
       gather_province,
       gather_city,
       account_type,
       account_prop,
       amount,
       currency,
       summary,
       plan_pay_date,
       inter_status,
       payment_account,
       payment_account_name,
       pay_flag,
       payment_date,
       serial_number,
       error_message,
       refund_status,
       refund_info,
       refund_date,
       creation_date,
       created_by,
       cash_flow_id,
       write_tmp_session_id,
       payee_category,
       payee_id,
       gather_province_name,
       gather_city_name,
       company_code,
       description,
       source_doc_line_id,
       acp_equisition_number)
    VALUES
      (v_cux_pay_trans_details_id,
       --v_payment_record.document_number,
       v_exp_report_number,
       v_trans_header_record.transaction_num,
       p_csh_transaction_line_id,
       p_csh_transaction_header_id,
       p_document_type,
       p_document_head_id,
       v_csh_payment_methods.payment_method_code,
       v_payment_record.account_name,
       v_payment_record.account_number,
       v_payee_bank_code,
       v_payee_bank_location_code,
       v_payee_bank_location,
       v_payee_province_code,
       v_payee_city_code,
       '0', -- 卡折标志
       v_payee_account_type, --公私标志
       v_trans_line_record.transaction_amount, --金额
       v_exp_report_pmt_schedules.currency,
       --substrb(v_exp_report_pmt_schedules.description, 1, 100), --摘要
       v_summary,
       trunc(SYSDATE),
       '0', --接口状态
       v_csh_bank_accounts.bank_account_num, --付款账号
       v_csh_bank_accounts.bank_account_name, --付款户名
       '9', --未支付
       NULL, --支付日期
       NULL,
       NULL,
       '1',
       NULL,
       NULL,
       SYSDATE,
       p_user_id,
       p_cash_flow_item_id,
       p_write_tmp_session_id,
       v_payment_record.payee_category,
       v_payment_record.payee_id,
       v_payee_province_name,
       v_payee_city_name,
       v_company_code,
       v_exp_report_pmt_schedules.description,
       v_exp_report_pmt_schedules.payment_schedule_line_id,
       p_acp_equisition_number);
  
  END insert_payment_details_wlzq;

  -- 取来源单据编号
  FUNCTION get_source_document_number(p_payment_schedule_line_id NUMBER)
    RETURN VARCHAR2 IS
    v_pmt_info exp_report_pmt_schedules%ROWTYPE;
    v_result   VARCHAR2(50);
  BEGIN
    SELECT *
      INTO v_pmt_info
      FROM exp_report_pmt_schedules erps
     WHERE erps.payment_schedule_line_id = p_payment_schedule_line_id;
  
    --冻结的,需要取付款单单据编号
    IF (v_pmt_info.frozen_flag = 'Y') THEN
      SELECT aah.requisition_number
        INTO v_result
        FROM acp_acp_requisition_lns aal, acp_acp_requisition_hds aah
       WHERE aah.acp_requisition_header_id = aal.acp_requisition_header_id
         AND aal.ref_document_line_id = p_payment_schedule_line_id;
    
    ELSE
      SELECT h.exp_report_number
        INTO v_result
        FROM exp_report_headers h
       WHERE h.exp_report_header_id = v_pmt_info.exp_report_header_id;
    END IF;
  
    RETURN v_result;
  
  END get_source_document_number;

  --===========================================
  -- 万联证券,报销单支付
  -- 收款方相同时,不合并支付
  --===========================================
  PROCEDURE execute_exp_report_pay_wlzq(p_session_id              NUMBER,
                                        p_company_id              NUMBER,
                                        p_payment_date            DATE,
                                        p_currency_code           VARCHAR2,
                                        p_exchange_rate_type      VARCHAR2,
                                        p_exchange_rate_quotation VARCHAR2,
                                        p_exchange_rate           NUMBER,
                                        p_bank_account_id         NUMBER,
                                        p_description             VARCHAR2,
                                        p_cash_flow_item_id       NUMBER,
                                        p_payment_method_id       NUMBER,
                                        p_user_id                 NUMBER,
                                        p_acp_equisition_number   VARCHAR2 DEFAULT NULL,
                                        p_batch_id                IN OUT NUMBER) IS
    v_period_name     gld_periods.period_name%TYPE;
    v_set_of_books_id NUMBER;
    v_company_id      NUMBER;
    v_payee_category  VARCHAR2(30);
    v_payee_id        NUMBER;
    v_account_name    exp_report_pmt_schedules.account_name%TYPE;
    v_account_number  exp_report_pmt_schedules.account_number%TYPE;
    v_payment_type_id exp_report_pmt_schedules.payment_type_id%TYPE;
  
    v_group_amount             NUMBER;
    v_exp_report_header_id     NUMBER;
    v_exp_report_number        VARCHAR2(30);
    v_payment_schedule_line_id NUMBER;
    v_currency                 VARCHAR2(10);
    v_payment_amount           NUMBER;
    v_contract_header_id       NUMBER;
    v_transaction_header_id    NUMBER;
    v_transaction_line_id      NUMBER;
    v_reversed_flag            VARCHAR2(30);
    v_write_off_status         VARCHAR2(30);
    v_cash_flow_item_id        NUMBER;
    --Modify by hyb
    v_ebanking_flag VARCHAR2(1);
    TYPE line_id_array IS TABLE OF csh_payment_messages.line_id%TYPE INDEX BY BINARY_INTEGER;
    line_array line_id_array;
    v_line_id  NUMBER;
    i          NUMBER := 1;
  
    CURSOR cur_lock_data IS
      SELECT t.payment_schedule_line_id
        FROM exp_report_payment_tmp t
       WHERE t.session_id = p_session_id
         FOR UPDATE NOWAIT;
  
    --万联证券添加
    v_psl_id NUMBER; --计划付款行ID
  
    --Modify：另加上账户名、银行账户和支付方式三个条件，进行分组
    CURSOR cur_payment_group IS -- 根据计划付款行公司、收款对象类型、收款方分组、报销单id
      SELECT s.company_id,
             s.payee_category,
             s.payee_id,
             s.account_name,
             s.account_number,
             s.payment_type_id,
             h.exp_report_header_id,
             SUM(t.payment_amount),
             s.cash_flow_code,
             s.payment_schedule_line_id,
             h.exp_report_number
        FROM exp_report_pmt_schedules s,
             exp_report_payment_tmp   t,
             exp_report_headers       h
       WHERE t.payment_schedule_line_id = s.payment_schedule_line_id
         AND t.session_id = p_session_id
         AND h.exp_report_header_id = s.exp_report_header_id
       GROUP BY s.company_id,
                s.payee_category,
                s.payee_id,
                s.account_name,
                s.account_number,
                h.exp_report_header_id,
                s.payment_type_id,
                s.cash_flow_code,
                s.payment_schedule_line_id,
                h.exp_report_number;
  
    CURSOR cur_exp_report IS -- 获取基本数据，并锁表
      SELECT h.exp_report_header_id,
             s.payment_schedule_line_id,
             s.currency,
             t.payment_amount,
             h.reversed_flag,
             h.write_off_status
        FROM exp_report_headers       h,
             exp_report_pmt_schedules s,
             exp_report_payment_tmp   t
       WHERE h.exp_report_header_id = s.exp_report_header_id
         AND t.payment_schedule_line_id = s.payment_schedule_line_id
         AND t.session_id = p_session_id
         AND s.company_id = v_company_id
         AND s.payee_category = v_payee_category
         AND s.payee_id = v_payee_id
         AND s.account_name = v_account_name
         AND s.account_number = v_account_number
         AND s.payment_type_id = v_payment_type_id
         AND h.exp_report_header_id = v_exp_report_header_id
         AND s.payment_schedule_line_id = v_psl_id
      
         FOR UPDATE NOWAIT;
  
    e_period_not_open    EXCEPTION;
    e_set_of_books_error EXCEPTION;
    e_currency_not_equal EXCEPTION;
    e_locked_error       EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_locked_error, -54);
    e_reverse_error      EXCEPTION;
    e_write_off_error    EXCEPTION;
    e_payment_data_error EXCEPTION;
  
    v_source_document_number VARCHAR2(50); --来源单据编号
    v_batch_id               NUMBER; --批号
    v_job_id                 NUMBER;
  
    v_bank_account_id         NUMBER;
    v_bank_account_company_id NUMBER; --付款账号所属公司
    v_payment_company_id      NUMBER;
    v_currency_code           VARCHAR2(30);
  
    v_description VARCHAR2(200);
  BEGIN
    OPEN cur_lock_data;
  
    /*  -- 期间
    v_period_name := gld_common_pkg.get_gld_period_name(p_company_id => p_company_id,
                                                        p_date       => p_payment_date);
    IF v_period_name IS NULL THEN
      RAISE e_period_not_open;
    END IF;
    
    v_batch_id := cux_pay_trans_details_s.nextval;
    
    -- 取帐套
    v_set_of_books_id := gld_common_pkg.get_set_of_books_id(p_comany_id => p_company_id);
    IF v_set_of_books_id IS NULL THEN
      RAISE e_set_of_books_error;
    END IF;*/
    IF (p_batch_id IS NOT NULL) THEN
      v_batch_id := p_batch_id;
    ELSE
      v_batch_id := cux_pay_trans_details_s.nextval;
    END IF;
  
    IF (p_currency_code IS NOT NULL) THEN
      v_currency_code := p_currency_code;
    ELSE
      v_currency_code := 'CNY';
    END IF;
  
    OPEN cur_payment_group;
    LOOP
      FETCH cur_payment_group
        INTO v_company_id,
             v_payee_category,
             v_payee_id,
             v_account_name,
             v_account_number,
             v_payment_type_id,
             v_exp_report_header_id,
             v_group_amount,
             v_cash_flow_item_id,
             v_psl_id,
             v_exp_report_number;
      EXIT WHEN cur_payment_group%NOTFOUND;
    
      IF (v_company_id IS NULL) OR (v_payee_category IS NULL) OR
         (v_payee_id IS NULL) OR (v_account_name IS NULL) OR
         (v_account_number IS NULL) OR (v_payment_type_id IS NULL) THEN
        RAISE e_payment_data_error;
      END IF;
    
      -- ********************* 取付款公司 ***********************
      IF (p_acp_equisition_number IS NULL) THEN
        SELECT cdpc.payment_company_id
          INTO v_payment_company_id
          FROM csh_doc_payment_company cdpc
         WHERE cdpc.document_line_id = v_psl_id
           AND cdpc.document_type = 'EXP_REPORT';
      ELSE
        v_payment_company_id := p_company_id;
      END IF;
    
      -- ********************* 取默认付款账号 ***********************
      IF (p_bank_account_id IS NOT NULL) THEN
        v_bank_account_id := p_bank_account_id;
      ELSE
        -- 取默认付款账号
        SELECT cb.bank_account_id
          INTO v_bank_account_id
          FROM csh_bank_accounts_vl cb
         WHERE cb.bank_account_num =
               cux_wlzq_payment_pkg.get_payment_bank_account(p_payment_company_id  => v_payment_company_id,
                                                             p_document_company_id => v_company_id);
      END IF;
      SELECT cb.company_id
        INTO v_bank_account_company_id
        FROM csh_bank_accounts_vl cb
       WHERE cb.bank_account_id = v_bank_account_id;
    
      -- 如果付款公司与银行账号公司不一致,取银行账号公司作为付款公司
      IF (v_payment_company_id <> v_bank_account_company_id) THEN
        v_payment_company_id := v_bank_account_company_id;
      END IF;
    
      v_period_name := gld_common_pkg.get_gld_period_name(p_company_id => v_payment_company_id,
                                                          p_date       => p_payment_date);
      IF v_period_name IS NULL THEN
        RAISE e_period_not_open;
      END IF;
    
      -- 取帐套
      v_set_of_books_id := gld_common_pkg.get_set_of_books_id(p_comany_id => v_payment_company_id);
      IF v_set_of_books_id IS NULL THEN
        RAISE e_set_of_books_error;
      END IF;
    
      --检查付款方式是否选择网银
      SELECT c.ebanking_flag
        INTO v_ebanking_flag
        FROM csh_payment_methods c
       WHERE c.payment_method_id = p_payment_method_id;
    
      -- 精度
      v_group_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => v_currency_code,
                                                           p_amount          => v_group_amount,
                                                           p_set_of_books_id => v_set_of_books_id);
      -- 逻辑更改 合同不与现金事务头关联 为减少程序修改量 做如下处理
      -- 报销单关联的合同
      BEGIN
        SELECT f.document_id
          INTO v_contract_header_id
          FROM con_document_flows f
         WHERE f.document_type = 'CON_CONTRACT_HEADERS'
           AND f.source_document_type = 'EXP_REPORT_HEADERS'
           AND f.source_document_id = v_exp_report_header_id;
      EXCEPTION
        WHEN OTHERS THEN
          v_contract_header_id := NULL;
      END;
    
      v_contract_header_id := NULL;
      -- 生成现金事务
      v_transaction_header_id := csh_transaction_pkg.get_csh_transaction_header_id;
      v_transaction_line_id   := csh_transaction_pkg.get_csh_transaction_line_id;
    
      IF g_pay_from_acp_flag = 'Y' THEN
        g_transaction_header_id := v_transaction_header_id;
        g_transaction_line_id   := v_transaction_line_id;
      END IF;
    
      v_description := '支付' || v_exp_report_number || '款项';
    
      csh_transaction_pkg.insert_csh_transaction_header(p_company_id               => v_payment_company_id,
                                                        p_transaction_header_id    => v_transaction_header_id,
                                                        p_transaction_type         => 'PAYMENT',
                                                        p_transaction_date         => p_payment_date,
                                                        p_period_name              => v_period_name,
                                                        p_payment_method_id        => p_payment_method_id,
                                                        p_transaction_category     => 'BUSINESS',
                                                        p_posted_flag              => csh_transaction_pkg.c_trans_posted_flag_no,
                                                        p_reversed_flag            => NULL,
                                                        p_reversed_date            => NULL,
                                                        p_returned_flag            => csh_transaction_pkg.c_trans_return_flag_no,
                                                        p_write_off_flag           => csh_transaction_pkg.c_trans_write_off_flag_n,
                                                        p_write_off_completed_date => NULL,
                                                        p_source_header_id         => NULL,
                                                        p_gld_interface_flag       => csh_write_off_pkg.c_gld_interface_flag_n,
                                                        p_transaction_class        => NULL,
                                                        p_enabled_write_off_flag   => 'Y',
                                                        p_contract_header_id       => v_contract_header_id,
                                                        p_user_id                  => p_user_id,
                                                        p_source_payment_header_id => NULL);
      csh_transaction_pkg.insert_csh_transaction_line(p_transaction_header_id   => v_transaction_header_id,
                                                      p_transaction_line_id     => v_transaction_line_id,
                                                      p_transaction_amount      => v_group_amount,
                                                      p_currency_code           => v_currency_code,
                                                      p_exchange_rate_type      => p_exchange_rate_type,
                                                      p_exchange_rate           => p_exchange_rate,
                                                      p_bank_account_id         => v_bank_account_id,
                                                      p_document_num            => NULL,
                                                      p_partner_category        => v_payee_category,
                                                      p_partner_id              => v_payee_id,
                                                      p_partner_bank_account_id => NULL,
                                                      p_description             => v_description,
                                                      p_handling_charge         => NULL,
                                                      p_exchange_rate_quotation => p_exchange_rate_quotation,
                                                      p_agent_employee_id       => NULL,
                                                      p_user_id                 => p_user_id);
      csh_write_off_pkg.delete_csh_write_off_tmp(p_session_id => p_session_id,
                                                 p_user_id    => p_user_id);
      OPEN cur_exp_report;
      LOOP
        FETCH cur_exp_report
          INTO v_exp_report_header_id,
               v_payment_schedule_line_id,
               v_currency,
               v_payment_amount,
               v_reversed_flag,
               v_write_off_status;
        EXIT WHEN cur_exp_report%NOTFOUND;
        IF v_currency <> v_currency_code THEN
          RAISE e_currency_not_equal;
        END IF;
      
        IF v_reversed_flag IS NOT NULL THEN
          RAISE e_reverse_error;
        END IF;
      
        IF v_write_off_status = 'C' THEN
          RAISE e_write_off_error;
        END IF;
      
        -- 精度
        v_payment_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => v_currency_code,
                                                               p_amount          => v_payment_amount,
                                                               p_set_of_books_id => v_set_of_books_id);
        -- 插入待核销临时数据
        csh_write_off_pkg.insert_csh_write_off_tmp(p_session_id                  => p_session_id,
                                                   p_write_off_type              => 'PAYMENT_EXPENSE_REPORT',
                                                   p_transaction_class           => NULL,
                                                   p_payment_requisition_line_id => NULL,
                                                   p_contract_header_id          => NULL,
                                                   p_payment_schedule_line_id    => NULL,
                                                   p_write_off_date              => NULL,
                                                   p_write_off_amount            => v_payment_amount,
                                                   p_company_id                  => NULL,
                                                   p_document_id                 => v_payment_schedule_line_id,
                                                   p_user_id                     => p_user_id);
        --Modify by hyb
        IF (v_ebanking_flag = 'Y') THEN
          line_array(i) := get_csh_payment_messages_id(p_exp_report_header_id     => v_exp_report_header_id,
                                                       p_payment_schedule_line_id => v_payment_schedule_line_id,
                                                       p_payment_method_id        => p_payment_method_id,
                                                       p_user_id                  => p_user_id);
          i := i + 1;
        END IF;
      
      END LOOP;
    
      CLOSE cur_exp_report;
      -- 调用现金过账程序进行处理
      csh_transaction_pkg.post_transaction(p_transaction_header_id => v_transaction_header_id,
                                           p_user_id               => p_user_id,
                                           p_session_id            => p_session_id,
                                           p_cash_flow_item_id     => v_cash_flow_item_id);
    
      --修改来源单据编号
      IF (p_acp_equisition_number IS NULL) THEN
        v_source_document_number := get_source_document_number(v_psl_id);
      ELSE
        v_source_document_number := p_acp_equisition_number;
      END IF;
    
      UPDATE gl_account_entry ae
         SET ae.attribute12 = v_source_document_number
       WHERE ae.transaction_header_id = v_transaction_header_id
         AND ae.transaction_type = 'CSH_TRANSACTION';
    
      --Modify by hyb,添加资金支付接口事件
      IF (v_ebanking_flag = 'Y') THEN
        IF i != 1 THEN
          null;
          v_line_id := line_array(1);
        
          --暂挂现金事物和凭证                                  
          UPDATE gl_account_entry ae
             SET ae.imported_flag = 'G'
           WHERE ae.transaction_header_id = v_transaction_header_id
             AND ae.transaction_type = 'CSH_TRANSACTION';
        
          UPDATE csh_transaction_headers th
             SET th.posted_flag      = 'G',
                 th.last_update_date = SYSDATE,
                 th.last_updated_by  = p_user_id
           WHERE th.transaction_header_id = v_transaction_header_id;
        
          insert_payment_details_wlzq(p_csh_msg_line_id           => v_line_id, --收款行信息
                                      p_csh_transaction_header_id => v_transaction_header_id,
                                      p_csh_transaction_line_id   => v_transaction_line_id,
                                      p_cash_flow_item_id         => v_cash_flow_item_id, --现金流
                                      p_user_id                   => p_user_id,
                                      p_document_type             => 'EXP_REPORT',
                                      p_document_head_id          => v_exp_report_header_id,
                                      p_write_tmp_session_id      => v_batch_id,
                                      p_acp_equisition_number     => p_acp_equisition_number);
        
          evt_event_core_pkg.fire_event(p_event_name   => 'CSH_TRANSACTION_DETAIL_EDIT',
                                        p_event_param  => v_line_id,
                                        p_param1       => v_transaction_header_id,
                                        p_param2       => v_transaction_line_id,
                                        p_param3       => v_cash_flow_item_id,
                                        p_created_by   => p_user_id,
                                        p_event_type   => 'CSH_TRANSACTION_DETAIL_EDIT',
                                        p_event_source => 'EXP_REPORT_PAYMENT_PKG.insert_exp_report_payment_tmp');
        END IF;
      
        i := 1;
      ELSE
        -- 修改凭证状态                                
        cux_wlzq_payment_pkg.update_exp_gl_status(p_exp_report_head_id => v_exp_report_header_id,
                                                  p_user_id            => p_user_id);
      END IF;
    
    END LOOP;
  
    CLOSE cur_payment_group;
  
    -- 删除临时数据
    csh_write_off_pkg.delete_csh_write_off_tmp(p_session_id => p_session_id,
                                               p_user_id    => p_user_id);
    delete_exp_report_payment_tmp(p_session_id => p_session_id,
                                  p_user_id    => p_user_id);
  
    IF (p_acp_equisition_number IS NULL) THEN
      --提交,异步支付
      -- COMMIT;
      --万联证券支付
      /*v_job_id := sch_concurrent_job_pkg.job_submit(p_task_code   => 'CP_BANK_PAY',
      p_description => '银企直连支付',
      p_company_id  => 1,
      p_role_id     => 1,
      p_user_id     => 1,
      p_parameter_1 => v_batch_id,
      p_parameter_2 => p_user_id);*/
      null;
    END IF;
  
    p_batch_id := v_batch_id;
  
    CLOSE cur_lock_data;
  EXCEPTION
    WHEN e_locked_error THEN
      IF cur_lock_data%ISOPEN THEN
        CLOSE cur_lock_data;
      END IF;
    
      IF cur_exp_report%ISOPEN THEN
        CLOSE cur_exp_report;
      END IF;
    
      IF cur_payment_group%ISOPEN THEN
        CLOSE cur_payment_group;
      END IF;
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_LOCKED_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                      p_procedure_function_name => 'EXECUTE_EXP_REPORT_PAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_period_not_open THEN
      IF cur_lock_data%ISOPEN THEN
        CLOSE cur_lock_data;
      END IF;
    
      IF cur_exp_report%ISOPEN THEN
        CLOSE cur_exp_report;
      END IF;
    
      IF cur_payment_group%ISOPEN THEN
        CLOSE cur_payment_group;
      END IF;
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_PERIOD_NOT_OPEN_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                      p_procedure_function_name => 'EXECUTE_EXP_REPORT_PAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN e_set_of_books_error THEN
      IF cur_lock_data%ISOPEN THEN
        CLOSE cur_lock_data;
      END IF;
    
      IF cur_exp_report%ISOPEN THEN
        CLOSE cur_exp_report;
      END IF;
    
      IF cur_payment_group%ISOPEN THEN
        CLOSE cur_payment_group;
      END IF;
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_SET_OF_BOOKS_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                      p_procedure_function_name => 'EXECUTE_EXP_REPORT_PAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN e_payment_data_error THEN
      IF cur_lock_data%ISOPEN THEN
        CLOSE cur_lock_data;
      END IF;
      IF cur_exp_report%ISOPEN THEN
        CLOSE cur_exp_report;
      END IF;
      IF cur_payment_group%ISOPEN THEN
        CLOSE cur_payment_group;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_PAYMENT_DATA_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                      p_procedure_function_name => 'EXECUTE_EXP_REPORT_PAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_currency_not_equal THEN
      IF cur_lock_data%ISOPEN THEN
        CLOSE cur_lock_data;
      END IF;
    
      IF cur_exp_report%ISOPEN THEN
        CLOSE cur_exp_report;
      END IF;
    
      IF cur_payment_group%ISOPEN THEN
        CLOSE cur_payment_group;
      END IF;
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_CURRENCY_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                      p_procedure_function_name => 'EXECUTE_EXP_REPORT_PAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN e_reverse_error THEN
      IF cur_lock_data%ISOPEN THEN
        CLOSE cur_lock_data;
      END IF;
    
      IF cur_exp_report%ISOPEN THEN
        CLOSE cur_exp_report;
      END IF;
    
      IF cur_payment_group%ISOPEN THEN
        CLOSE cur_payment_group;
      END IF;
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_REVERSED_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                      p_procedure_function_name => 'EXECUTE_EXP_REPORT_PAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN e_write_off_error THEN
      IF cur_lock_data%ISOPEN THEN
        CLOSE cur_lock_data;
      END IF;
    
      IF cur_exp_report%ISOPEN THEN
        CLOSE cur_exp_report;
      END IF;
    
      IF cur_payment_group%ISOPEN THEN
        CLOSE cur_payment_group;
      END IF;
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_WRITE_OFF_COMPLETE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                      p_procedure_function_name => 'EXECUTE_EXP_REPORT_PAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      IF cur_lock_data%ISOPEN THEN
        CLOSE cur_lock_data;
      END IF;
    
      IF cur_exp_report%ISOPEN THEN
        CLOSE cur_exp_report;
      END IF;
    
      IF cur_payment_group%ISOPEN THEN
        CLOSE cur_payment_group;
      END IF;
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                     p_procedure_function_name => 'EXECUTE_EXP_REPORT_PAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END execute_exp_report_pay_wlzq;

  PROCEDURE execute_exp_report_payment(p_session_id              NUMBER,
                                       p_company_id              NUMBER,
                                       p_payment_date            DATE,
                                       p_currency_code           VARCHAR2,
                                       p_exchange_rate_type      VARCHAR2,
                                       p_exchange_rate_quotation VARCHAR2,
                                       p_exchange_rate           NUMBER,
                                       p_bank_account_id         NUMBER,
                                       p_description             VARCHAR2,
                                       p_cash_flow_item_id       NUMBER,
                                       p_payment_method_id       NUMBER,
                                       p_user_id                 NUMBER) IS
    v_period_name     gld_periods.period_name%TYPE;
    v_set_of_books_id NUMBER;
    v_company_id      NUMBER;
    v_payee_category  VARCHAR2(30);
    v_payee_id        NUMBER;
    v_account_name    exp_report_pmt_schedules.account_name%TYPE;
    v_account_number  exp_report_pmt_schedules.account_number%TYPE;
    v_payment_type_id exp_report_pmt_schedules.payment_type_id%TYPE;
  
    v_group_amount             NUMBER;
    v_exp_report_header_id     NUMBER;
    v_payment_schedule_line_id NUMBER;
    v_currency                 VARCHAR2(10);
    v_payment_amount           NUMBER;
    v_contract_header_id       NUMBER;
    v_transaction_header_id    NUMBER;
    v_transaction_line_id      NUMBER;
    v_reversed_flag            VARCHAR2(30);
    v_write_off_status         VARCHAR2(30);
    v_cash_flow_item_id        NUMBER;
    --Modify by hyb
    v_ebanking_flag VARCHAR2(1);
    TYPE line_id_array IS TABLE OF csh_payment_messages.line_id%TYPE INDEX BY BINARY_INTEGER;
    line_array line_id_array;
    v_line_id  NUMBER;
    i          NUMBER := 1;
  
    -- added by majianjian at 2015-02-10
    v_merge_to_pay_flag VARCHAR2(1);
  
    CURSOR cur_lock_data IS
      SELECT t.payment_schedule_line_id
        FROM exp_report_payment_tmp t
       WHERE t.session_id = p_session_id
         FOR UPDATE NOWAIT;
  
    -- added by mjianjian at 2015-02-10
    -- purpose: 添加游标参数来控制是否合并支付
    --Modify：另加上账户名、银行账户和支付方式三个条件，进行分组
    CURSOR cur_payment_group(p_merge_to_pay_flag VARCHAR2) IS -- 根据计划付款行公司、收款对象类型、收款方分组、报销单id
    -- 不合并支付
      SELECT s.company_id,
             s.payee_category,
             s.payee_id,
             s.account_name,
             s.account_number,
             s.payment_type_id,
             h.exp_report_header_id,
             SUM(t.payment_amount),
             s.cash_flow_code
        FROM exp_report_pmt_schedules s,
             exp_report_payment_tmp   t,
             exp_report_headers       h
       WHERE t.payment_schedule_line_id = s.payment_schedule_line_id
         AND t.session_id = p_session_id
         AND h.exp_report_header_id = s.exp_report_header_id
         AND nvl(p_merge_to_pay_flag, 'N') = 'N'
       GROUP BY s.company_id,
                s.payee_category,
                s.payee_id,
                s.account_name,
                s.account_number,
                h.exp_report_header_id, -- 按单据分组
                s.payment_type_id,
                s.cash_flow_code
      UNION
      -- 合并支付，不按单据分组
      SELECT s.company_id,
             s.payee_category,
             s.payee_id,
             s.account_name,
             s.account_number,
             NULL, --s.payment_type_id,
             NULL exp_report_header_id,
             SUM(t.payment_amount),
             s.cash_flow_code
        FROM exp_report_pmt_schedules s, exp_report_payment_tmp t
       WHERE t.payment_schedule_line_id = s.payment_schedule_line_id
         AND t.session_id = p_session_id
         AND nvl(p_merge_to_pay_flag, 'N') = 'Y'
       GROUP BY s.company_id,
                s.payee_category,
                s.payee_id,
                s.account_name,
                s.account_number,
                --s.payment_type_id,
                s.cash_flow_code;
    -- added by majianjian at 2015-02-10
    -- purpose: 添加对合并支付和不合并支付的支持，详见游标中的注释  
    CURSOR cur_exp_report IS -- 获取基本数据，并锁表
      SELECT h.exp_report_header_id,
             s.payment_schedule_line_id,
             s.currency,
             t.payment_amount,
             h.reversed_flag,
             h.write_off_status
        FROM exp_report_headers       h,
             exp_report_pmt_schedules s,
             exp_report_payment_tmp   t
       WHERE h.exp_report_header_id = s.exp_report_header_id
         AND t.payment_schedule_line_id = s.payment_schedule_line_id
         AND t.session_id = p_session_id
         AND s.company_id = v_company_id
         AND s.payee_category = v_payee_category
         AND s.payee_id = v_payee_id
         AND s.account_name = v_account_name
         AND s.account_number = v_account_number
            --and s.payment_type_id = v_payment_type_id
         AND h.exp_report_header_id =
             nvl(v_exp_report_header_id, h.exp_report_header_id)
            -- 上面nvl的使用，当合并支付时，v_exp_report_header_id的值为空，因此该条件失效，
            -- 当不合并时，v_exp_report_header_id的值不为空，条件生效
         AND nvl(s.cash_flow_code, -1) = nvl(v_cash_flow_item_id, -1)
         FOR UPDATE NOWAIT;
  
    e_period_not_open    EXCEPTION;
    e_set_of_books_error EXCEPTION;
    e_currency_not_equal EXCEPTION;
    e_locked_error       EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_locked_error, -54);
    e_reverse_error      EXCEPTION;
    e_write_off_error    EXCEPTION;
    e_payment_data_error EXCEPTION;
  
  BEGIN
    OPEN cur_lock_data;
    -- 期间
    v_period_name := gld_common_pkg.get_gld_period_name(p_company_id => p_company_id,
                                                        p_date       => p_payment_date);
    IF v_period_name IS NULL THEN
      RAISE e_period_not_open;
    END IF;
  
    -- 取帐套
    v_set_of_books_id := gld_common_pkg.get_set_of_books_id(p_comany_id => p_company_id);
    IF v_set_of_books_id IS NULL THEN
      RAISE e_set_of_books_error;
    END IF;
  
    -- added by majianjian at 2015-02-10
    -- 获取合并支付标志
    v_merge_to_pay_flag := sys_parameter_pkg.value(p_parameter_code => 'CSH_PAYMENT_MERGE');
  
    IF nvl(v_merge_to_pay_flag, 'N') != 'Y' THEN
      v_merge_to_pay_flag := 'N';
    END IF;
  
    OPEN cur_payment_group(v_merge_to_pay_flag);
    LOOP
      FETCH cur_payment_group
        INTO v_company_id,
             v_payee_category,
             v_payee_id,
             v_account_name,
             v_account_number,
             v_payment_type_id,
             v_exp_report_header_id,
             v_group_amount,
             v_cash_flow_item_id;
      EXIT WHEN cur_payment_group%NOTFOUND;
    
      IF (v_company_id IS NULL) OR (v_payee_category IS NULL) OR
         (v_payee_id IS NULL) OR (v_account_name IS NULL) OR
         (v_account_number IS NULL) OR (v_payment_type_id IS NULL) THEN
        RAISE e_payment_data_error;
      END IF;
    
      --检查付款方式是否选择网银
      SELECT c.ebanking_flag
        INTO v_ebanking_flag
        FROM csh_payment_methods c
       WHERE c.payment_method_id = p_payment_method_id;
    
      -- 精度
      v_group_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_currency_code,
                                                           p_amount          => v_group_amount,
                                                           p_set_of_books_id => v_set_of_books_id);
      -- 逻辑更改 合同不与现金事务头关联 为减少程序修改量 做如下处理
      /*-- 报销单关联的合同
      begin
        select f.document_id
          into v_contract_header_id
          from con_document_flows f
         where f.document_type = 'CON_CONTRACT_HEADERS'
           and f.source_document_type = 'EXP_REPORT_HEADERS'
           and f.source_document_id = v_exp_report_header_id;
      exception
        when others then
          v_contract_header_id := null;
      end;*/
    
      v_contract_header_id := NULL;
      -- 生成现金事务
      v_transaction_header_id := csh_transaction_pkg.get_csh_transaction_header_id;
      v_transaction_line_id   := csh_transaction_pkg.get_csh_transaction_line_id;
    
      IF g_pay_from_acp_flag = 'Y' THEN
        g_transaction_header_id := v_transaction_header_id;
        g_transaction_line_id   := v_transaction_line_id;
      END IF;
    
      csh_transaction_pkg.insert_csh_transaction_header(p_company_id               => p_company_id,
                                                        p_transaction_header_id    => v_transaction_header_id,
                                                        p_transaction_type         => 'PAYMENT',
                                                        p_transaction_date         => p_payment_date,
                                                        p_period_name              => v_period_name,
                                                        p_payment_method_id        => p_payment_method_id,
                                                        p_transaction_category     => 'BUSINESS',
                                                        p_posted_flag              => csh_transaction_pkg.c_trans_posted_flag_no,
                                                        p_reversed_flag            => NULL,
                                                        p_reversed_date            => NULL,
                                                        p_returned_flag            => csh_transaction_pkg.c_trans_return_flag_no,
                                                        p_write_off_flag           => csh_transaction_pkg.c_trans_write_off_flag_n,
                                                        p_write_off_completed_date => NULL,
                                                        p_source_header_id         => NULL,
                                                        p_gld_interface_flag       => csh_write_off_pkg.c_gld_interface_flag_n,
                                                        p_transaction_class        => NULL,
                                                        p_enabled_write_off_flag   => 'Y',
                                                        p_contract_header_id       => v_contract_header_id,
                                                        p_user_id                  => p_user_id,
                                                        p_source_payment_header_id => NULL);
      csh_transaction_pkg.insert_csh_transaction_line(p_transaction_header_id   => v_transaction_header_id,
                                                      p_transaction_line_id     => v_transaction_line_id,
                                                      p_transaction_amount      => v_group_amount,
                                                      p_currency_code           => p_currency_code,
                                                      p_exchange_rate_type      => p_exchange_rate_type,
                                                      p_exchange_rate           => p_exchange_rate,
                                                      p_bank_account_id         => p_bank_account_id,
                                                      p_document_num            => NULL,
                                                      p_partner_category        => v_payee_category,
                                                      p_partner_id              => v_payee_id,
                                                      p_partner_bank_account_id => NULL,
                                                      p_description             => p_description,
                                                      p_handling_charge         => NULL,
                                                      p_exchange_rate_quotation => p_exchange_rate_quotation,
                                                      p_agent_employee_id       => NULL,
                                                      p_user_id                 => p_user_id);
      csh_write_off_pkg.delete_csh_write_off_tmp(p_session_id => p_session_id,
                                                 p_user_id    => p_user_id);
      OPEN cur_exp_report;
      LOOP
        FETCH cur_exp_report
          INTO v_exp_report_header_id,
               v_payment_schedule_line_id,
               v_currency,
               v_payment_amount,
               v_reversed_flag,
               v_write_off_status;
        EXIT WHEN cur_exp_report%NOTFOUND;
        IF v_currency <> p_currency_code THEN
          RAISE e_currency_not_equal;
        END IF;
      
        IF v_reversed_flag IS NOT NULL THEN
          RAISE e_reverse_error;
        END IF;
      
        IF v_write_off_status = 'C' THEN
          RAISE e_write_off_error;
        END IF;
      
        -- 精度
        v_payment_amount := fnd_format_mask_pkg.get_gld_amount(p_currency_code   => p_currency_code,
                                                               p_amount          => v_payment_amount,
                                                               p_set_of_books_id => v_set_of_books_id);
        -- 插入待核销临时数据
        csh_write_off_pkg.insert_csh_write_off_tmp(p_session_id                  => p_session_id,
                                                   p_write_off_type              => 'PAYMENT_EXPENSE_REPORT',
                                                   p_transaction_class           => NULL,
                                                   p_payment_requisition_line_id => NULL,
                                                   p_contract_header_id          => NULL,
                                                   p_payment_schedule_line_id    => NULL,
                                                   p_write_off_date              => NULL,
                                                   p_write_off_amount            => v_payment_amount,
                                                   p_company_id                  => NULL,
                                                   p_document_id                 => v_payment_schedule_line_id,
                                                   p_user_id                     => p_user_id);
      
        /*************************************************
        -- Author  : MOUSE
        -- Created : 2015/12/7 11:34:50
        -- Ver     : 1.1
        -- Purpose : 君康的资金系统方案不一样，取消原来的资金接口程序
        **************************************************/
        --Modify by hyb
        /*if (v_ebanking_flag = 'Y') then
          line_array(i) := get_csh_payment_messages_id(p_exp_report_header_id     => v_exp_report_header_id,
                                                       p_payment_schedule_line_id => v_payment_schedule_line_id,
                                                       p_payment_method_id        => p_payment_method_id,
                                                       p_user_id                  => p_user_id);
          i := i + 1;
        end if;*/
      
      END LOOP;
    
      CLOSE cur_exp_report;
      -- 调用现金过账程序进行处理
      csh_transaction_pkg.post_transaction(p_transaction_header_id => v_transaction_header_id,
                                           p_user_id               => p_user_id,
                                           p_session_id            => p_session_id,
                                           p_cash_flow_item_id     => v_cash_flow_item_id);
    
      --Modify by pqs,添加资金支付接口事件
      /* if (v_ebanking_flag = 'Y') then
        if i != 1 then
          v_line_id := line_array(1);
        
          --修改分录表import状态为H暂挂状态，避免过账
          update gl_account_entry ae
             set ae.imported_flag = 'H'
           where ae.transaction_header_id = v_transaction_header_id
             and ae.transaction_type = 'CSH_TRANSACTION';
        
          --修改付款事务头POSTED_FLAG为H暂挂状态
          update csh_transaction_headers th
             set th.posted_flag      = 'H',
                 th.last_update_date = sysdate,
                 th.last_updated_by  = p_user_id
           where th.transaction_header_id = v_transaction_header_id;
        
          --修改资金凭证表gld_interface_flag为H暂挂状态，避免过账
          update csh_transaction_accounts a
             set a.gld_interface_flag = 'H',
                 a.last_update_date   = sysdate,
                 a.last_updated_by    = p_user_id
           where a.transaction_line_id = v_transaction_line_id;
        
          --插入资金支付接口，推送保融资金支付
          evt_event_core_pkg.fire_event(p_event_name  => 'CSH_TRANSACTION_DETAIL_EDIT',
                                        p_event_param => v_line_id,
                                        p_param1      => v_transaction_header_id,
                                        p_param2      => v_transaction_line_id,
                                        p_param3      => v_cash_flow_item_id,
                                        p_param4      => p_session_id,
                                        
                                        p_created_by   => p_user_id,
                                        p_event_type   => 'CSH_TRANSACTION_DETAIL_EDIT',
                                        p_event_source => 'EXP_REPORT_PAYMENT_PKG.execute_exp_report_payment');
        end if;
      
        i := 1;
      end if;*/
    
      /*************************************************
      -- Author  : MOUSE
      -- Created : 2015/12/7 11:34:50
      -- Ver     : 1.1
      -- Purpose : 君康的资金系统方案不一样，取消原来的资金接口程序
      **************************************************/
      --如果当前是银企直连支付，需要等接口返回支付状态再进行过账处理
      /*if v_ebanking_flag = 'Y' then
        --修改分录表import状态为H暂挂状态，避免过账
        update gl_account_entry ae
           set ae.imported_flag = 'H'
         where ae.transaction_header_id = v_transaction_header_id
               and ae.transaction_type = 'CSH_TRANSACTION';
      
        --修改付款事务头POSTED_FLAG为H暂挂状态
        update csh_transaction_headers th
           set th.posted_flag      = 'H',
               th.last_update_date = sysdate,
               th.last_updated_by  = p_user_id
         where th.transaction_header_id = v_transaction_header_id;
      
        --修改资金凭证表gld_interface_flag为H暂挂状态，避免过账
        update csh_transaction_accounts a
           set a.gld_interface_flag = 'H',
               a.last_update_date   = sysdate,
               a.last_updated_by    = p_user_id
         where a.transaction_line_id = v_transaction_line_id;
      end if;*/
    
    END LOOP;
  
    CLOSE cur_payment_group;
    -- 删除临时数据
    csh_write_off_pkg.delete_csh_write_off_tmp(p_session_id => p_session_id,
                                               p_user_id    => p_user_id);
    delete_exp_report_payment_tmp(p_session_id => p_session_id,
                                  p_user_id    => p_user_id);
    CLOSE cur_lock_data;
  EXCEPTION
    WHEN e_locked_error THEN
      IF cur_lock_data%ISOPEN THEN
        CLOSE cur_lock_data;
      END IF;
    
      IF cur_exp_report%ISOPEN THEN
        CLOSE cur_exp_report;
      END IF;
    
      IF cur_payment_group%ISOPEN THEN
        CLOSE cur_payment_group;
      END IF;
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_LOCKED_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                      p_procedure_function_name => 'EXECUTE_EXP_REPORT_PAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_period_not_open THEN
      IF cur_lock_data%ISOPEN THEN
        CLOSE cur_lock_data;
      END IF;
    
      IF cur_exp_report%ISOPEN THEN
        CLOSE cur_exp_report;
      END IF;
    
      IF cur_payment_group%ISOPEN THEN
        CLOSE cur_payment_group;
      END IF;
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_PERIOD_NOT_OPEN_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                      p_procedure_function_name => 'EXECUTE_EXP_REPORT_PAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN e_set_of_books_error THEN
      IF cur_lock_data%ISOPEN THEN
        CLOSE cur_lock_data;
      END IF;
    
      IF cur_exp_report%ISOPEN THEN
        CLOSE cur_exp_report;
      END IF;
    
      IF cur_payment_group%ISOPEN THEN
        CLOSE cur_payment_group;
      END IF;
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_SET_OF_BOOKS_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                      p_procedure_function_name => 'EXECUTE_EXP_REPORT_PAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN e_payment_data_error THEN
      IF cur_lock_data%ISOPEN THEN
        CLOSE cur_lock_data;
      END IF;
      IF cur_exp_report%ISOPEN THEN
        CLOSE cur_exp_report;
      END IF;
      IF cur_payment_group%ISOPEN THEN
        CLOSE cur_payment_group;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_PAYMENT_DATA_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                      p_procedure_function_name => 'EXECUTE_EXP_REPORT_PAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_currency_not_equal THEN
      IF cur_lock_data%ISOPEN THEN
        CLOSE cur_lock_data;
      END IF;
    
      IF cur_exp_report%ISOPEN THEN
        CLOSE cur_exp_report;
      END IF;
    
      IF cur_payment_group%ISOPEN THEN
        CLOSE cur_payment_group;
      END IF;
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_CURRENCY_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                      p_procedure_function_name => 'EXECUTE_EXP_REPORT_PAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN e_reverse_error THEN
      IF cur_lock_data%ISOPEN THEN
        CLOSE cur_lock_data;
      END IF;
    
      IF cur_exp_report%ISOPEN THEN
        CLOSE cur_exp_report;
      END IF;
    
      IF cur_payment_group%ISOPEN THEN
        CLOSE cur_payment_group;
      END IF;
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_REVERSED_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                      p_procedure_function_name => 'EXECUTE_EXP_REPORT_PAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN e_write_off_error THEN
      IF cur_lock_data%ISOPEN THEN
        CLOSE cur_lock_data;
      END IF;
    
      IF cur_exp_report%ISOPEN THEN
        CLOSE cur_exp_report;
      END IF;
    
      IF cur_payment_group%ISOPEN THEN
        CLOSE cur_payment_group;
      END IF;
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5200_WRITE_OFF_COMPLETE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                      p_procedure_function_name => 'EXECUTE_EXP_REPORT_PAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      IF cur_lock_data%ISOPEN THEN
        CLOSE cur_lock_data;
      END IF;
    
      IF cur_exp_report%ISOPEN THEN
        CLOSE cur_exp_report;
      END IF;
    
      IF cur_payment_group%ISOPEN THEN
        CLOSE cur_payment_group;
      END IF;
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                     p_procedure_function_name => 'EXECUTE_EXP_REPORT_PAYMENT');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END execute_exp_report_payment;

  PROCEDURE execute_exp_rep_pay_from_acp(p_session_id              NUMBER,
                                         p_acp_requisition_line_id NUMBER, -- added by majianjian at 2015-02-12 需要支付的付款申请单行id
                                         p_payment_amount          NUMBER, -- added by majianjian at 2015-02-12 本次支付的金额
                                         p_company_id              NUMBER,
                                         p_payment_date            DATE,
                                         p_currency_code           VARCHAR2,
                                         p_exchange_rate_type      VARCHAR2,
                                         p_exchange_rate_quotation VARCHAR2,
                                         p_exchange_rate           NUMBER,
                                         p_bank_account_id         NUMBER,
                                         p_description             VARCHAR2,
                                         p_cash_flow_item_id       NUMBER,
                                         p_payment_method_id       NUMBER,
                                         p_user_id                 NUMBER,
                                         p_transaction_header_id   OUT NUMBER,
                                         p_transaction_line_id     OUT NUMBER,
                                         p_write_off_id            OUT NUMBER,
                                         p_batch_id                IN OUT NUMBER) IS
    e_is_not_exp_report_ref EXCEPTION;
    v_payment_schedule_line_id NUMBER;
    v_requisition_number       VARCHAR2(100);
  BEGIN
    g_pay_from_acp_flag       := 'Y';
    g_acp_requisition_line_id := p_acp_requisition_line_id;
  
    BEGIN
      SELECT aarl.ref_document_line_id, aarh.requisition_number
        INTO v_payment_schedule_line_id, v_requisition_number
        FROM acp_acp_requisition_hds aarh,
             acp_acp_requisition_lns aarl,
             acp_sys_acp_req_types   asart
       WHERE aarh.acp_requisition_header_id =
             aarl.acp_requisition_header_id
         AND aarh.acp_req_type_id = asart.acp_req_type_id
         AND nvl(asart.report_refs_flag, 'N') = 'Y'
         AND aarh.acp_requisition_header_id =
             aarl.acp_requisition_header_id
         AND aarl.acp_requisition_line_id = p_acp_requisition_line_id
         AND aarl.ref_document_line_id IS NOT NULL;
    EXCEPTION
      WHEN no_data_found THEN
        RAISE e_is_not_exp_report_ref;
    END;
  
    -- 删除报销单支付临时表中的当前session数据
    DELETE FROM exp_report_payment_tmp t WHERE t.session_id = p_session_id;
  
    -- 插入本次支付信息到报销单支付临时表中
    INSERT INTO exp_report_payment_tmp
      (session_id,
       payment_schedule_line_id,
       payment_amount,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by)
    VALUES
      (p_session_id,
       v_payment_schedule_line_id,
       p_payment_amount,
       p_payment_date,
       p_user_id,
       p_payment_date,
       p_user_id);
  
    -- 支付的具体逻辑
    execute_exp_report_pay_wlzq(p_session_id              => p_session_id,
                                p_company_id              => p_company_id,
                                p_payment_date            => p_payment_date,
                                p_currency_code           => p_currency_code,
                                p_exchange_rate_type      => p_exchange_rate_type,
                                p_exchange_rate_quotation => p_exchange_rate_quotation,
                                p_exchange_rate           => p_exchange_rate,
                                p_bank_account_id         => p_bank_account_id,
                                p_description             => p_description,
                                p_cash_flow_item_id       => p_cash_flow_item_id,
                                p_payment_method_id       => p_payment_method_id,
                                p_user_id                 => p_user_id,
                                p_acp_equisition_number   => v_requisition_number,
                                p_batch_id                => p_batch_id);
  
    -- 删除报销单支付临时表中的当前session数据
    DELETE FROM exp_report_payment_tmp t WHERE t.session_id = p_session_id;
  
    p_transaction_header_id := g_transaction_header_id;
    p_transaction_line_id   := g_transaction_line_id;
    SELECT wo.write_off_id
      INTO p_write_off_id
      FROM csh_write_off wo
     WHERE wo.csh_transaction_line_id = p_transaction_line_id;
    g_pay_from_acp_flag     := 'N';
    g_transaction_header_id := NULL;
    g_transaction_line_id   := NULL;
  EXCEPTION
    WHEN e_is_not_exp_report_ref THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'ACP_REQ_IS_NOT_EXP_REPORT_REF',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                      p_procedure_function_name => 'EXECUTE_EXP_REP_PAY_FROM_ACP');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  --获取插入csh_payment_messages表里面的line_id
  FUNCTION get_csh_payment_messages_id(p_exp_report_header_id     NUMBER,
                                       p_payment_schedule_line_id NUMBER,
                                       p_payment_method_id        NUMBER,
                                       p_user_id                  NUMBER)
    RETURN NUMBER IS
    v_line_id           NUMBER;
    v_schedule_record   exp_report_pmt_schedules%ROWTYPE;
    v_acp_req_record    acp_acp_requisition_lns%ROWTYPE;
    v_acp_req_header_id NUMBER;
    v_currency_code     VARCHAR2(30);
    v_document_number   VARCHAR2(200);
  BEGIN
  
    IF g_acp_requisition_line_id IS NOT NULL THEN
      SELECT h.requisition_number,
             h.acp_requisition_header_id,
             h.currency_code
        INTO v_document_number, v_acp_req_header_id, v_currency_code
        FROM acp_acp_requisition_hds h, acp_acp_requisition_lns l
       WHERE h.acp_requisition_header_id = l.acp_requisition_header_id
         AND l.acp_requisition_line_id = g_acp_requisition_line_id;
    
      SELECT *
        INTO v_acp_req_record
        FROM acp_acp_requisition_lns l
       WHERE l.acp_requisition_line_id = g_acp_requisition_line_id;
    
      insert_csh_payment_messages(p_line_id          => v_line_id,
                                  p_company_id       => v_acp_req_record.company_id,
                                  p_currency         => v_currency_code,
                                  p_payee_category   => v_acp_req_record.partner_category,
                                  p_payee_id         => v_acp_req_record.partner_id,
                                  p_payee_date       => SYSDATE,
                                  p_due_amount       => v_acp_req_record.amount,
                                  p_description      => NULL,
                                  p_payment_type_id  => p_payment_method_id,
                                  p_account_name     => v_acp_req_record.account_name,
                                  p_account_number   => v_acp_req_record.account_number,
                                  p_document_type    => 'ACP_REQUISITION',
                                  p_document_id      => v_acp_req_header_id,
                                  p_document_number  => v_document_number,
                                  p_document_line_id => g_acp_requisition_line_id,
                                  p_user_id          => p_user_id);
    ELSE
      SELECT h.exp_report_number
        INTO v_document_number　from exp_report_headers h
       WHERE h.exp_report_header_id = p_exp_report_header_id;
    
      SELECT *
        INTO v_schedule_record
        FROM exp_report_pmt_schedules s
       WHERE s.exp_report_header_id = p_exp_report_header_id
         AND s.payment_schedule_line_id = p_payment_schedule_line_id;
    
      insert_csh_payment_messages(p_line_id          => v_line_id,
                                  p_company_id       => v_schedule_record.company_id,
                                  p_currency         => v_schedule_record.currency,
                                  p_payee_category   => v_schedule_record.payee_category,
                                  p_payee_id         => v_schedule_record.payee_id,
                                  p_payee_date       => SYSDATE,
                                  p_due_amount       => v_schedule_record.due_amount,
                                  p_description      => v_schedule_record.description,
                                  p_payment_type_id  => p_payment_method_id,
                                  p_account_name     => v_schedule_record.account_name,
                                  p_account_number   => v_schedule_record.account_number,
                                  p_document_type    => 'EXP_REPORT',
                                  p_document_id      => p_exp_report_header_id,
                                  p_document_number  => v_document_number,
                                  p_document_line_id => p_payment_schedule_line_id,
                                  p_user_id          => p_user_id);
    END IF;
  
    RETURN v_line_id;
  END get_csh_payment_messages_id;

  --插入现金支付信息表
  PROCEDURE insert_csh_payment_messages(p_line_id          OUT NUMBER,
                                        p_company_id       NUMBER,
                                        p_currency         VARCHAR2,
                                        p_payee_category   VARCHAR2,
                                        p_payee_id         NUMBER,
                                        p_payee_date       DATE,
                                        p_due_amount       NUMBER,
                                        p_description      VARCHAR2,
                                        p_payment_type_id  VARCHAR2,
                                        p_account_name     VARCHAR2,
                                        p_account_number   VARCHAR2,
                                        p_document_type    VARCHAR2,
                                        p_document_id      VARCHAR2,
                                        p_document_number  VARCHAR2,
                                        p_document_line_id NUMBER,
                                        p_user_id          NUMBER) IS
  BEGIN
    SELECT csh_payment_messages_s.nextval INTO p_line_id FROM dual;
  
    INSERT INTO csh_payment_messages
      (line_id,
       company_id,
       currency,
       payee_category,
       payee_id,
       payee_date,
       due_amount,
       description,
       payment_type_id,
       account_name,
       account_number,
       document_type,
       document_id,
       document_number,
       document_line_id,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by)
    VALUES
      (p_line_id,
       p_company_id,
       p_currency,
       p_payee_category,
       p_payee_id,
       p_payee_date,
       p_due_amount,
       p_description,
       p_payment_type_id,
       p_account_name,
       p_account_number,
       p_document_type,
       p_document_id,
       p_document_number,
       p_document_line_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_user_id);
  
  END insert_csh_payment_messages;

  PROCEDURE insert_pay_trans_interface(p_trans_interface_id       OUT NUMBER,
                                       p_source_doc_num           VARCHAR2,
                                       p_company_code             VARCHAR2,
                                       p_pay_type_code            VARCHAR2, ----付款方式 
                                       p_partner_category         VARCHAR2,
                                       p_partner_code             VARCHAR2,
                                       p_payee_city_code          VARCHAR2,
                                       p_payee_bank_location_code VARCHAR2, --收方银行
                                       p_payee_bank_location      VARCHAR2,
                                       p_gather_account           VARCHAR2,
                                       p_usedes_code              VARCHAR2, --用途
                                       p_source_doc_des           VARCHAR2, --备注,报销单头上备注
                                       p_isprivate                VARCHAR2, --公私标志
                                       p_card_book_flag           VARCHAR2, --卡折标志
                                       p_settlement_mode          VARCHAR2,
                                       p_user_id                  NUMBER,
                                       p_cash_flow_code           VARCHAR2, --现金流量代码
                                       p_csh_write_tmp_session_id NUMBER,
                                       p_trans_header_record      csh_transaction_headers%ROWTYPE,
                                       p_trans_line_record        csh_transaction_lines%ROWTYPE,
                                       p_payment_record           csh_payment_messages%ROWTYPE) IS
    v_trans_interface_id NUMBER;
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
  
    --获取主键ID编号
    SELECT jx_ats_pay_trans_interface_s.nextval
      INTO v_trans_interface_id
      FROM dual;
  
    p_trans_interface_id := v_trans_interface_id;
    --数据准备
    INSERT INTO jx_ats_pay_trans_interface
      (urid,
       source_name,
       origin_note,
       source_notecode,
       apply_entity_code,
       apply_dept_code,
       pay_date,
       plan_pay_date,
       settlement_mode,
       pay_type_code,
       category_code,
       sub_category_code,
       budget_item_code,
       pay_entity_code,
       pay_bank,
       pay_account,
       rec_object_type,
       rec_name,
       rec_bank_area,
       rec_bank,
       rec_bank_locations,
       rec_account,
       rec_account_name,
       rec_currency,
       rec_money,
       bank_money,
       purpose,
       memo,
       description,
       vendor_code,
       isprivate,
       card_flag,
       fast_flag,
       credentials,
       id_card,
       cvv_code,
       valid_date,
       ats_dealstate,
       ats_dealdate,
       ats_dealerrorinfo,
       ats_returnstate,
       ats_returndate,
       ats_returninfo,
       pay_state,
       pay_made_date,
       pay_info,
       fail_type,
       abstract,
       checkbatchno,
       billtype,
       billcode,
       refund_state,
       refund_info,
       refund_time,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       recordsource_batno,
       sourcebusinessno,
       partner_category,
       parent_id,
       transaction_num,
       csh_transaction_header_id,
       csh_transaction_line_id,
       sourcetype,
       hec_status,
       source_id,
       company_id,
       cash_flow_code,
       write_tmp_session_id,
       usedes,
       summary,
       read_flag,
       post_flag)
    VALUES
      (v_trans_interface_id,
       'FPM',
       p_trans_header_record.transaction_num, -- 单据编号
       p_source_doc_num, -- 来源单据编号,取报销单编号
       p_company_code, -- 机构
       '',
       p_trans_header_record.transaction_date, -- 付款时间
       to_char(p_trans_header_record.transaction_date, 'yyyy-mm-dd'), -- 计划付款时间 (待开发)
       p_settlement_mode, --结算方式
       p_pay_type_code, --付款方式 
       '', --资金类别
       '', --资金子类别
       '', --计划项目
       '', --付方组织
       '', --付方银行
       '', --付方账户
       p_partner_category, --收款方类型
       p_partner_code, -- 收款方代码
       p_payee_city_code, -- 收方银行区域字段待确认
       p_payee_bank_location_code, --收方银行
       p_payee_bank_location, --收方银行开户行
       p_gather_account,
       --v_payment_record.account_number, --收方账户
       p_payment_record.account_name, --收方户名
       'CNY', --货币
       p_trans_line_record.transaction_amount, --交易金额
       p_trans_line_record.transaction_amount, --实付金额
       p_usedes_code, --用途
       p_source_doc_des, --备注,报销单头上备注
       '', --注释
       '',
       p_isprivate, --公私标志
       p_card_book_flag, --卡折标志
       '', --加急标志
       '',
       '',
       '',
       '',
       1, --抽档状态，默认1
       '',
       '',
       1, --返盘状态
       '',
       '',
       1, --支付状态
       '',
       '',
       0, --支付失败原因
       '',
       '',
       '',
       '',
       1, --退票状态
       '',
       '',
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       '', --批次号，资金回传
       p_payment_record.document_number,
       p_payment_record.payee_category,
       p_payment_record.payee_id,
       p_trans_header_record.transaction_num,
       p_trans_header_record.transaction_header_id,
       p_trans_line_record.transaction_line_id,
       p_payment_record.document_type,
       0,
       p_payment_record.document_id,
       p_payment_record.company_id,
       p_cash_flow_code, -- 现金流量代码
       p_csh_write_tmp_session_id,
       '',
       '',
       'N',
       'N');
    COMMIT;
  END;

  --往资金交易接口表里面插入数据
  FUNCTION insert_csh_transaction_details(p_event_record_id     NUMBER,
                                          p_event_handle_log_id NUMBER,
                                          p_event_param         NUMBER,
                                          p_user_id             NUMBER)
    RETURN NUMBER IS
    v_detail_id                 NUMBER;
    v_payment_record            csh_payment_messages%ROWTYPE;
    v_event_record              evt_event_record%ROWTYPE;
    v_csh_transaction_header_id NUMBER;
    v_csh_transaction_line_id   NUMBER;
    v_trans_header_record       csh_transaction_headers%ROWTYPE;
    v_trans_line_record         csh_transaction_lines%ROWTYPE;
    v_cash_flow_item_id         NUMBER;
    v_company_code              fnd_companies.company_code%TYPE;
    v_partner_code              VARCHAR2(100);
    v_partner_name              VARCHAR2(100);
  
    v_drawee_bank_code          exp_employee_accounts.bank_code%TYPE;
    v_drawee_bank_name          exp_employee_accounts.bank_name%TYPE;
    v_drawee_bank_location_code exp_employee_accounts.bank_location_code%TYPE;
    v_drawee_bank_location      exp_employee_accounts.bank_location%TYPE;
    v_drawee_province_code      exp_employee_accounts.province_code%TYPE;
    v_drawee_province_name      exp_employee_accounts.province_name%TYPE;
    v_drawee_city_code          exp_employee_accounts.city_code%TYPE;
    v_drawee_city_name          exp_employee_accounts.city_name%TYPE;
    v_drawee_account_number     exp_employee_accounts.account_number%TYPE;
    v_drawee_account_name       exp_employee_accounts.account_name%TYPE;
  
    v_company_full_name_id NUMBER;
  
    v_payee_bank_code          exp_employee_accounts.bank_code%TYPE;
    v_payee_bank_name          exp_employee_accounts.bank_name%TYPE;
    v_payee_bank_location_code exp_employee_accounts.bank_location_code%TYPE;
    v_payee_bank_location      exp_employee_accounts.bank_location%TYPE;
    v_payee_province_code      exp_employee_accounts.province_code%TYPE;
    v_payee_province_name      exp_employee_accounts.province_name%TYPE;
    v_payee_city_code          exp_employee_accounts.city_code%TYPE;
    v_payee_city_name          exp_employee_accounts.city_name%TYPE;
  
    v_trans_interface_id       number;
    v_isprivate                varchar2(10);
    v_settlement_mode          varchar2(10);
    v_csh_write_tmp_session_id number;
    v_error_msg                varchar2(200);
  BEGIN
    SELECT csh_transaction_details_s.nextval INTO v_detail_id FROM dual;
  
    --获取事件行信息
    SELECT *
      INTO v_event_record
      FROM evt_event_record eer
     WHERE eer.record_id = p_event_record_id;
  
    v_csh_transaction_header_id := v_event_record.param1;
    v_csh_transaction_line_id   := v_event_record.param2;
    v_cash_flow_item_id         := v_event_record.param3;
    v_csh_write_tmp_session_id  := v_event_record.param4;
  
    --获取交易事务（付款）头信息
    SELECT *
      INTO v_trans_header_record
      FROM csh_transaction_headers cth
     WHERE cth.transaction_header_id = v_csh_transaction_header_id;
  
    --获取交易事务（付款）行信息
    SELECT *
      INTO v_trans_line_record
      FROM csh_transaction_lines ctl
     WHERE ctl.transaction_header_id = v_csh_transaction_header_id
       AND ctl.transaction_line_id = v_csh_transaction_line_id;
  
    --获取收款行信息
    SELECT *
      INTO v_payment_record
      FROM csh_payment_messages cpm
     WHERE cpm.line_id = p_event_param;
  
    --获取company_code
    SELECT fc.company_code
      INTO v_company_code
      FROM fnd_companies fc
     WHERE fc.company_id = v_payment_record.company_id;
  
    --获取收款方代码及名称
    BEGIN
      IF v_payment_record.payee_category = 'EMPLOYEE' THEN
        SELECT ee.employee_code, ee.name
          INTO v_partner_code, v_partner_name
          FROM exp_employees ee
         WHERE ee.employee_id = v_payment_record.payee_id;
      
      ELSIF v_payment_record.payee_category = 'VENDER' THEN
        SELECT psv.vender_code, psv.description
          INTO v_partner_code, v_partner_name
          FROM pur_system_venders_vl psv
         WHERE psv.vender_id = v_payment_record.payee_id;
      
      ELSE
        SELECT osc.customer_code, osc.description
          INTO v_partner_code, v_partner_name
          FROM ord_system_customers_vl osc
         WHERE osc.customer_id = v_payment_record.payee_id;
      
      END IF;
    
    EXCEPTION
      WHEN OTHERS THEN
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '获取收款方代码及名称时发生错误!\n' ||
                                                                                    dbms_utility.format_error_stack,
                                                       p_created_by              => p_user_id,
                                                       p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                       p_procedure_function_name => 'insert_csh_transaction_details');
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
      
    END;
  
    --获取付款人银行信息
    BEGIN
      SELECT (SELECT cbb.bank_code
                FROM csh_bank_branches_vl cbb
               WHERE cbb.bank_branch_id = cba.bank_branch_id) bank_code,
             NULL,
             NULL,
             NULL,
             NULL,
             NULL,
             NULL,
             cba.bank_account_num,
             (SELECT fc.company_full_name_id
                FROM fnd_companies fc
               WHERE fc.company_id = cba.company_id) company_full_name_id
        INTO v_drawee_bank_code,
             v_drawee_bank_location_code,
             v_drawee_bank_location,
             v_drawee_province_code,
             v_drawee_province_name,
             v_drawee_city_code,
             v_drawee_city_name,
             v_drawee_account_number,
             v_company_full_name_id
        FROM csh_bank_accounts_vl cba
       WHERE cba.bank_account_id = v_trans_line_record.bank_account_id;
    
      --找到支行上级的银行，为付款方银行
      SELECT (SELECT fd.description_text
                FROM fnd_descriptions fd
               WHERE fd.description_id = cb.bank_name_id
                 AND fd.language = 'ZHS')
        INTO v_drawee_bank_name
        FROM csh_banks cb
       WHERE cb.bank_code = v_drawee_bank_code;
    
      --账号名称为公司全称
      SELECT fd.description_text
        INTO v_drawee_account_name　from fnd_descriptions fd
       WHERE fd.description_id = v_company_full_name_id
         AND fd.language = 'ZHS';
    
    EXCEPTION
      WHEN OTHERS THEN
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '获取付款方银行信息错误!\n' ||
                                                                                    dbms_utility.format_error_stack,
                                                       p_created_by              => p_user_id,
                                                       p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                       p_procedure_function_name => 'insert_csh_transaction_details');
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
      
    END;
  
    --获取收款人银行信息
    BEGIN
      IF v_payment_record.payee_category = 'EMPLOYEE' THEN
        SELECT eea.bank_code,
               eea.bank_name,
               eea.bank_location_code,
               eea.bank_location,
               eea.province_code,
               eea.province_name,
               eea.city_code,
               eea.city_name,
               '1'
          INTO v_payee_bank_code,
               v_payee_bank_name,
               v_payee_bank_location_code,
               v_payee_bank_location,
               v_payee_province_code,
               v_payee_province_name,
               v_payee_city_code,
               v_payee_city_name,
               v_isprivate
          FROM exp_employee_accounts eea
         WHERE eea.employee_id = v_payment_record.payee_id
           AND eea.account_number = v_payment_record.account_number
           AND eea.account_name = v_payment_record.account_name;
      
      ELSIF v_payment_record.payee_category = 'VENDER' THEN
        SELECT pva.bank_code,
               pva.bank_name,
               pva.bank_location_code,
               pva.bank_location,
               pva.province_code,
               pva.province_name,
               pva.city_code,
               pva.city_name,
               '2'
          INTO v_payee_bank_code,
               v_payee_bank_name,
               v_payee_bank_location_code,
               v_payee_bank_location,
               v_payee_province_code,
               v_payee_province_name,
               v_payee_city_code,
               v_payee_city_name,
               v_isprivate
          FROM pur_vender_accounts pva
         WHERE pva.vender_id = v_payment_record.payee_id
           AND pva.account_number = v_payment_record.account_number
           AND pva.account_name = v_payment_record.account_name;
      
      ELSE
        SELECT oca.bank_code,
               oca.bank_name,
               oca.bank_location_code,
               oca.bank_location,
               oca.province_code,
               oca.province_name,
               oca.city_code,
               oca.city_name,
               '2'
          INTO v_payee_bank_code,
               v_payee_bank_name,
               v_payee_bank_location_code,
               v_payee_bank_location,
               v_payee_province_code,
               v_payee_province_name,
               v_payee_city_code,
               v_payee_city_name,
               v_isprivate
          FROM ord_customer_accounts oca
         WHERE oca.customer_id = v_payment_record.payee_id
           AND oca.account_number = v_payment_record.account_number
           AND oca.account_name = v_payment_record.account_name;
      
      END IF;
    
    EXCEPTION
      WHEN no_data_found THEN
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '收款方银行信息不存在，请配置!\n' ||
                                                                                    dbms_utility.format_error_stack,
                                                       p_created_by              => p_user_id,
                                                       p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                       p_procedure_function_name => 'insert_csh_transaction_details');
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
      WHEN too_many_rows THEN
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '该收款方银行信息同时存在多个，请修改!\n' ||
                                                                                    dbms_utility.format_error_stack,
                                                       p_created_by              => p_user_id,
                                                       p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                       p_procedure_function_name => 'insert_csh_transaction_details');
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
      
      WHEN OTHERS THEN
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '获取收款方银行信息时发生错误!\n' ||
                                                                                    dbms_utility.format_error_stack,
                                                       p_created_by              => p_user_id,
                                                       p_package_name            => 'EXP_REPORT_PAYMENT_PKG',
                                                       p_procedure_function_name => 'insert_csh_transaction_details');
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
      
    END;
  
    INSERT INTO csh_transaction_details
      (csh_transaction_line_id,
       detail_id,
       source_code,
       company_id,
       company_code,
       document_type,
       document_id,
       document_number,
       document_line_id,
       description,
       payment_method,
       pay_date,
       request_time,
       actual_pay_date,
       payment_status,
       interface_status,
       refund_time,
       cash_flow_code,
       partner_category,
       partner_id,
       partner_code,
       partner_name,
       usedes,
       currency,
       amount,
       encryption_amount,
       encryption_version,
       drawee_bank_code,
       drawee_bank_name,
       drawee_bank_location_code,
       drawee_bank_location,
       drawee_province_code,
       drawee_province_name,
       drawee_city_code,
       drawee_city_name,
       drawee_account_number,
       drawee_account_name,
       payee_bank_code,
       payee_bank_name,
       payee_bank_location_code,
       payee_bank_location,
       payee_province_code,
       payee_province_name,
       payee_city_code,
       payee_city_name,
       payee_account_number,
       payee_account_name,
       status_desc,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by,
       drawee_id)
    VALUES
      (v_csh_transaction_line_id,
       v_detail_id,
       'HEC',
       v_trans_header_record.company_id,
       v_company_code,
       '',
       v_trans_header_record.transaction_header_id,
       v_trans_header_record.transaction_num,
       v_trans_line_record.transaction_line_id,
       v_trans_line_record.description,
       v_payment_record.payment_type_id,
       v_trans_header_record.transaction_date,
       NULL,
       NULL,
       'WAITING_SEND',
       'UNSENT',
       NULL,
       v_cash_flow_item_id,
       v_payment_record.payee_category,
       v_payment_record.payee_id,
       v_partner_code,
       v_partner_name,
       v_trans_line_record.description,
       v_trans_line_record.currency_code,
       v_trans_line_record.transaction_amount,
       NULL,
       NULL,
       v_drawee_bank_code,
       v_drawee_bank_name,
       v_drawee_bank_location_code,
       v_drawee_bank_location,
       v_drawee_province_code,
       v_drawee_province_name,
       v_drawee_city_code,
       v_drawee_city_name,
       v_drawee_account_number,
       v_drawee_account_name,
       v_payee_bank_code,
       v_payee_bank_name,
       v_payee_bank_location_code,
       v_payee_bank_location,
       v_payee_province_code,
       v_payee_province_name,
       v_payee_city_code,
       v_payee_city_name,
       v_payment_record.account_number,
       v_payment_record.account_name,
       NULL,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_user_id,
       p_user_id);
  
    --获取主键ID编号
    SELECT jx_ats_pay_trans_interface_s.nextval
      INTO v_trans_interface_id
      FROM dual;
  
    -- 付款方式
    SELECT decode(m.description, '银企直联', '1', '9')
      INTO v_settlement_mode
      FROM csh_payment_methods_vl m
     WHERE m.payment_method_id = v_trans_header_record.payment_method_id;
  
    --插入资金待支付表
    insert_pay_trans_interface(p_trans_interface_id       => v_trans_interface_id,
                               p_source_doc_num           => v_trans_header_record.transaction_num,
                               p_company_code             => v_company_code,
                               p_pay_type_code            => v_payment_record.payment_type_id, ----付款方式 
                               p_partner_category         => v_partner_name,
                               p_partner_code             => v_partner_code,
                               p_payee_city_code          => v_payee_city_code,
                               p_payee_bank_location_code => v_payee_bank_location_code, --收方银行
                               p_payee_bank_location      => v_payee_bank_location,
                               p_gather_account           => v_payment_record.account_number, --收方账号
                               p_usedes_code              => v_trans_line_record.description, --用途
                               p_source_doc_des           => v_trans_line_record.description, --备注,报销单行上备注
                               p_isprivate                => v_isprivate, --公私标志 必输
                               p_card_book_flag           => '', --卡折标志  必输
                               p_settlement_mode          => v_settlement_mode, --结算方式 必输
                               p_user_id                  => p_user_id,
                               p_cash_flow_code           => v_cash_flow_item_id, --现金流量代码
                               p_csh_write_tmp_session_id => v_csh_write_tmp_session_id,
                               p_trans_header_record      => v_trans_header_record,
                               p_trans_line_record        => v_trans_line_record,
                               p_payment_record           => v_payment_record);
  
    --调用资金收付过程 
    BEGIN
      cux_payment_gr_pkg.ws_post_zj(p_interface_id => v_trans_interface_id,
                                    p_user_id      => p_user_id,
                                    p_csh_type     => 'pay');
    EXCEPTION
      WHEN OTHERS THEN
        v_error_msg := SQLERRM || dbms_utility.format_error_backtrace;
        UPDATE jx_ats_pay_trans_interface jpi
           SET jpi.error_message = v_error_msg,
               jpi.hec_status    = '7', --导入失败
               jpi.pay_state     = '7'
         WHERE jpi.urid = v_trans_interface_id;
    END;
  
    RETURN 1;
  
  END insert_csh_transaction_details;

BEGIN
  g_acp_requisition_line_id := NULL;
END exp_report_payment_pkg;
/
