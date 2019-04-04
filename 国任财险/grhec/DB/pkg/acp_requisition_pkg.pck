CREATE OR REPLACE PACKAGE acp_requisition_pkg IS

  --付款申请头状态
  c_req_hd_status_generate   CONSTANT VARCHAR2(30) := 'GENERATE';
  c_req_hd_status_submitted  CONSTANT VARCHAR2(30) := 'SUBMITTED';
  c_req_hd_status_approved   CONSTANT VARCHAR2(30) := 'APPROVED';
  c_req_hd_status_rejected   CONSTANT VARCHAR2(30) := 'REJECTED';
  c_req_hd_status_closed     CONSTANT VARCHAR2(30) := 'CLOSED';
  c_req_hd_status_taken_back CONSTANT VARCHAR2(30) := 'TAKEN_BACK';

  --付款申请行状态
  c_req_ln_status_never      CONSTANT VARCHAR2(30) := 'NEVER';
  c_req_ln_status_partially  CONSTANT VARCHAR2(30) := 'PARTIALLY';
  c_req_ln_status_completely CONSTANT VARCHAR2(30) := 'COMPLETELY';

  --触发事件时的source_module值
  c_csh_payment_requisition CONSTANT VARCHAR2(30) := 'ACP_REQUISITION';

  --工作流transaction_categor，单据历史document_type
  c_payment_requisition CONSTANT VARCHAR2(30) := 'ACP_REQUISITION';

  --付款申请单头事务类型
  c_pay_req_type_business      CONSTANT VARCHAR2(30) := 'BUSINESS';
  c_pay_req_type_miscellaneous CONSTANT VARCHAR2(30) := 'MISCELLANEOUS';
  PROCEDURE reject_payment_requisition(p_payment_req_header_id NUMBER,
                                       p_user_id               NUMBER,
                                       p_update_history_flag   VARCHAR2 DEFAULT 'Y' -- add by zhanglei 增加判断，当页面审批时，需要更新单据历史表，当工作流结束调用时，无需再更新单据历史表
                                       );
  PROCEDURE update_reports_post_workflow(p_wfl_instance_id NUMBER,
                                         p_wfl_status      NUMBER,
                                         p_user_id         NUMBER);
  PROCEDURE approve_payment_requisition(p_payment_req_header_id NUMBER,
                                        p_user_id               NUMBER,
                                        p_update_history_flag   VARCHAR2 DEFAULT 'Y' -- add by zhanglei 增加判断，当页面审批时，需要更新单据历史表，当工作流结束调用时，无需再更新单据历史表
                                        );
  PROCEDURE take_back_payment_requisition(p_payment_req_header_id NUMBER,
                                          p_user_id               NUMBER,
                                          p_update_history_flag   VARCHAR2 DEFAULT 'Y' -- add by zhanglei 增加判断，当页面审批时，需要更新单据历史表，当工作流结束调用时，无需再更新单据历史表
                                          );
  FUNCTION get_acp_req_hd_number(p_document_type     VARCHAR2,
                                 p_company_id        NUMBER,
                                 p_operation_unit_id NUMBER,
                                 p_operation_date    DATE,
                                 p_user_id           NUMBER) RETURN VARCHAR2;

  PROCEDURE insert_acp_req_hd(p_acp_req_header_id OUT NUMBER,
                              p_company_id        NUMBER,
                              p_employee_id       NUMBER,
                              -- p_acp_ref_rpt_number       varchar2,
                              p_requisition_date DATE,
                              p_acp_req_type_id  NUMBER,
                              p_currency_code    VARCHAR2,
                              
                              p_description        VARCHAR2,
                              p_status             VARCHAR2,
                              p_position_id        NUMBER,
                              p_user_id            NUMBER,
                              p_source_type        VARCHAR2,
                              p_acp_ref_rpt_number VARCHAR2);

  PROCEDURE update_acp_req_hd(p_acp_req_header_id NUMBER,
                              p_operation_unit_id NUMBER,
                              p_employee_id       NUMBER,
                              p_requisition_date  DATE,
                              --    p_acp_req_type_id          number,
                              --   p_currency_code            varchar2,
                              
                              p_description VARCHAR2,
                              p_status      VARCHAR2,
                              p_position_id NUMBER,
                              p_user_id     NUMBER);

  PROCEDURE create_csh_doc_payment_company(p_pmt_req_line_id NUMBER,
                                           p_pay_company_id  NUMBER,
                                           p_user_id         NUMBER);

  PROCEDURE insert_acp_req_ln(p_acp_req_line_id          OUT NUMBER,
                              p_acp_req_header_id        NUMBER,
                              p_acp_req_line_type        VARCHAR2,
                              p_usedes_id                NUMBER,
                              p_ref_document_id          NUMBER,
                              p_ref_document_line_id     NUMBER,
                              p_amount                   NUMBER,
                              p_line_description         VARCHAR2,
                              p_payment_status           VARCHAR2,
                              p_contract_header_id       NUMBER,
                              p_payment_completed_date   DATE,
                              p_user_id                  NUMBER,
                              p_partner_category         VARCHAR2,
                              p_partner_id               NUMBER,
                              p_account_name             VARCHAR2,
                              p_account_number           VARCHAR2,
                              p_bank_code                VARCHAR2,
                              p_bank_name                VARCHAR2,
                              p_bank_location_code       VARCHAR2,
                              p_bank_location_name       VARCHAR2,
                              p_province_code            VARCHAR2,
                              p_province_name            VARCHAR2,
                              p_city_code                VARCHAR2,
                              p_city_name                VARCHAR2,
                              p_pay_com_id               NUMBER,
                              p_company_id               NUMBER,
                              p_payment_method_id        NUMBER,
                              p_payment_schedule_line_id NUMBER,
                              p_requisition_payment_date DATE,
                              p_gather_flag              VARCHAR2 DEFAULT NULL);

  PROCEDURE update_acp_req_ln(p_acp_req_line_id            NUMBER,
                              p_acp_req_line_type          VARCHAR2,
                              p_usedes_id                  NUMBER,
                              p_ref_document_id            NUMBER,
                              p_ref_document_line_id       NUMBER,
                              p_amount                     NUMBER,
                              p_line_description           VARCHAR2,
                              p_payment_status             VARCHAR2,
                              p_contract_header_id         NUMBER,
                              p_payment_completed_date     DATE,
                              p_user_id                    NUMBER,
                              p_partner_category           VARCHAR2,
                              p_partner_id                 NUMBER,
                              p_csh_transaction_class_code VARCHAR2,
                              p_account_name               VARCHAR2,
                              p_account_number             VARCHAR2,
                              p_bank_code                  VARCHAR2,
                              p_bank_name                  VARCHAR2,
                              p_bank_location_code         VARCHAR2,
                              p_bank_location_name         VARCHAR2,
                              p_province_code              VARCHAR2,
                              p_province_name              VARCHAR2,
                              p_city_code                  VARCHAR2,
                              p_city_name                  VARCHAR2,
                              p_payment_schedule_line_id   NUMBER,
                              p_company_id                 NUMBER,
                              p_requisition_payment_date   DATE,
                              p_gather_flag                VARCHAR2 DEFAULT NULL);
  PROCEDURE delete_acp_req_ln(p_acp_requisition_line_id NUMBER);
  PROCEDURE submit_acp_req(p_acp_req_header_id NUMBER,
                           /*p_status            varchar2,*/
                           p_user_id NUMBER);
  --付款申请单关闭
  PROCEDURE acp_requisition_close(p_requisition_header_id NUMBER,
                                  p_user_id               NUMBER);
  --付款申请单打开
  PROCEDURE acp_requisition_open(p_requisition_header_id NUMBER,
                                 p_user_id               NUMBER);
  FUNCTION get_acp_req_header_id RETURN NUMBER;

  PROCEDURE update_acp_ln_payee_info(p_acp_req_header_id  NUMBER,
                                     p_acp_req_line_id    NUMBER,
                                     p_account_name       VARCHAR2,
                                     p_account_number     VARCHAR2,
                                     p_bank_code          VARCHAR2,
                                     p_bank_name          VARCHAR2,
                                     p_bank_location_code VARCHAR2,
                                     p_bank_location_name VARCHAR2,
                                     p_province_code      VARCHAR2,
                                     p_province_name      VARCHAR2,
                                     p_city_code          VARCHAR2,
                                     p_city_name          VARCHAR2,
                                     p_user_id            NUMBER);
  --关联资金计划行分配金额校验逻辑
  PROCEDURE acp_req_plan_assign_chk(p_requisition_type VARCHAR2,
                                    p_acp_req_line_id  NUMBER,
                                    p_user_id          NUMBER);
  PROCEDURE delete_payment_requisition_ln(p_requisition_type    VARCHAR2,
                                          p_payment_req_line_id NUMBER,
                                          p_user_id             NUMBER);
  PROCEDURE submit_payment_requisition(p_payment_req_header_id NUMBER,
                                       p_user_id               NUMBER);
  PROCEDURE delete_payment_requisition(p_payment_req_header_id NUMBER,
                                       p_user_id               NUMBER);
  --申请单审批后调用
  PROCEDURE set_csh_pmt_req_status_by_req(p_exp_req_header_id NUMBER,
                                          p_status            VARCHAR2,
                                          p_user_id           NUMBER);
  --add by Qu yuanyuan 工作流调整付款方式及集中支付
  PROCEDURE update_acp_req_ln_adjust_pay(p_acp_requisition_line_id NUMBER,
                                         p_payment_method_id       NUMBER,
                                         p_gather_flag             VARCHAR2,
                                         p_user_id                 NUMBER);
END acp_requisition_pkg;

 
/
CREATE OR REPLACE PACKAGE BODY acp_requisition_pkg IS
  e_doc_number_error EXCEPTION;
  /*  e_lock_table exception;*/
  e_lock_table EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_lock_table, -54);
  e_ref_amount_error          EXCEPTION;
  e_plan_amount_check_error   EXCEPTION;
  e_plan_no_ref_line_error    EXCEPTION;
  e_plan_line_ref_check_error EXCEPTION;
  e_submit_amount_error       EXCEPTION;

  FUNCTION check_pmt_amount(p_acp_req_line_id      VARCHAR2,
                            p_exp_report_header_id NUMBER,
                            p_pmt_line_id          NUMBER,
                            p_amount               NUMBER) RETURN VARCHAR2 IS
    v_due_amount     NUMBER := 0;
    v_paid_amount    NUMBER := 0;
    v_applyed_amount NUMBER := 0;
  BEGIN
    SELECT nvl(s.due_amount, 0)
      INTO v_due_amount
      FROM exp_report_pmt_schedules s
     WHERE s.payment_schedule_line_id = p_pmt_line_id;
  
    SELECT nvl(SUM(csh_write_off_amount), 0)
      INTO v_paid_amount
      FROM csh_write_off o
     WHERE o.document_line_id = p_pmt_line_id
       AND o.write_off_type = 'PAYMENT_EXPENSE_REPORT';
  
    SELECT nvl(SUM(l.amount), 0)
      INTO v_applyed_amount
      FROM acp_acp_requisition_lns l, acp_acp_requisition_hds h
     WHERE ref_document_id = p_exp_report_header_id
       AND ref_document_line_id = p_pmt_line_id
       AND (p_acp_req_line_id IS NULL OR
           (p_acp_req_line_id IS NOT NULL AND
           l.acp_requisition_line_id != p_acp_req_line_id))
       AND payment_status = 'NEVER'
       AND l.acp_requisition_header_id = h.acp_requisition_header_id
       AND h.status IN ('SUBMITED', 'APPROVED');
  
    IF v_due_amount - v_paid_amount - v_applyed_amount - p_amount >= 0 THEN
      RETURN 'Y';
    ELSE
      RETURN 'N';
    END IF;
  END;

  PROCEDURE update_payment_req_hd_status(p_payment_req_header_id NUMBER,
                                         p_status                VARCHAR2,
                                         p_user_id               NUMBER,
                                         p_approval_date         DATE DEFAULT NULL,
                                         p_approved_by           NUMBER DEFAULT NULL,
                                         p_closed_date           DATE DEFAULT NULL) IS
  BEGIN
  
    UPDATE acp_acp_requisition_hds h
       SET h.status           = p_status,
           h.approval_date    = nvl(p_approval_date, h.approval_date),
           h.approved_by      = nvl(p_approved_by, h.approved_by),
           h.closed_date      = nvl(p_closed_date, h.closed_date),
           h.last_updated_by  = p_user_id,
           h.last_update_date = SYSDATE
     WHERE h.acp_requisition_header_id = p_payment_req_header_id;
  
  END update_payment_req_hd_status;

  PROCEDURE update_payment_req_ln_status(p_payment_req_line_id NUMBER,
                                         p_status              VARCHAR2,
                                         p_user_id             NUMBER) IS
  BEGIN
  
    UPDATE acp_acp_requisition_lns l
       SET l.payment_status   = p_status,
           l.last_updated_by  = p_user_id,
           l.last_update_date = SYSDATE
     WHERE l.acp_requisition_line_id = p_payment_req_line_id;
  END;

  FUNCTION get_acp_req_header_id RETURN NUMBER IS
    v_acp_req_header_id acp_acp_requisition_hds.acp_requisition_header_id%TYPE;
  BEGIN
    SELECT acp_acp_requisition_hds_s.nextval
      INTO v_acp_req_header_id
      FROM dual;
    RETURN v_acp_req_header_id;
  END get_acp_req_header_id;
  FUNCTION get_acp_req_line_id RETURN NUMBER IS
    v_acp_req_line_id acp_acp_requisition_lns.acp_requisition_line_id%TYPE;
  BEGIN
    SELECT acp_acp_requisition_lns_s.nextval
      INTO v_acp_req_line_id
      FROM dual;
    RETURN v_acp_req_line_id;
  END get_acp_req_line_id;
  FUNCTION get_pmt_req_approved_with_req(p_exp_req_header_id NUMBER)
    RETURN VARCHAR2 IS
    v_company_id NUMBER;
  BEGIN
    SELECT h.company_id
      INTO v_company_id
      FROM exp_requisition_headers h
     WHERE h.exp_requisition_header_id = p_exp_req_header_id;
  
    RETURN nvl(sys_parameter_pkg.value('PAYMENT_REQUISITION_APPROVED_WITH_REQ',
                                       '',
                                       '',
                                       v_company_id),
               'N');
  END get_pmt_req_approved_with_req;
  FUNCTION is_exist_payment_req_doc(p_document_number VARCHAR2,
                                    p_company_id      NUMBER) RETURN VARCHAR2 IS
    v_exsit VARCHAR2(1);
  BEGIN
    SELECT decode(COUNT(0), 0, 'N', 1, 'Y', 'Y')
      INTO v_exsit
      FROM csh_payment_requisition_hds t
     WHERE t.company_id = p_company_id
       AND t.requisition_number = p_document_number;
  
    RETURN v_exsit;
  END;

  PROCEDURE approve_payment_requisition(p_payment_req_header_id NUMBER,
                                        p_user_id               NUMBER,
                                        p_update_history_flag   VARCHAR2 DEFAULT 'Y' -- add by zhanglei 增加判断，当页面审批时，需要更新单据历史表，当工作流结束调用时，无需再更新单据历史表
                                        ) IS
  
  BEGIN
    FOR c_payment_req IN (SELECT *
                            FROM acp_acp_requisition_hds h
                           WHERE h.acp_requisition_header_id =
                                 p_payment_req_header_id
                             AND h.status = c_req_hd_status_submitted
                             /*FOR UPDATE NOWAIT*/) LOOP
    
      update_payment_req_hd_status(p_payment_req_header_id => p_payment_req_header_id,
                                   p_status                => c_req_hd_status_approved,
                                   p_user_id               => p_user_id,
                                   p_approval_date         => SYSDATE,
                                   p_approved_by           => p_user_id);
    
      IF p_update_history_flag = 'Y' THEN
        --单据历史
        exp_document_history_pkg.insert_exp_document_histories(p_document_type  => c_payment_requisition,
                                                               p_document_id    => p_payment_req_header_id,
                                                               p_operation_code => exp_document_history_pkg.c_approve,
                                                               p_user_id        => p_user_id,
                                                               p_operation_time => SYSDATE,
                                                               p_description    => '');
      END IF;
    
      evt_event_core_pkg.fire_event(p_event_name  => 'ACP_REQUISITION_COMPLETELY_APPROVED',
                                    p_event_param => p_payment_req_header_id,
                                    p_created_by  => p_user_id);
    END LOOP;
  
  EXCEPTION
    WHEN e_lock_table THEN
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5010_PAYMENT_REQ_LOCK_RECORD_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'approve_payment_requisition');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'ACP_REQUISITION_PKG',
                                                     p_procedure_function_name => 'approve_payment_requisition');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  FUNCTION get_acp_req_hd_number(p_document_type     VARCHAR2,
                                 p_company_id        NUMBER,
                                 p_operation_unit_id NUMBER,
                                 p_operation_date    DATE,
                                 p_user_id           NUMBER) RETURN VARCHAR2 IS
  
    c_coding_usage_code CONSTANT VARCHAR2(30) := '08';
  
    v_document_number acp_acp_requisition_hds.requisition_number%TYPE;
  
  BEGIN
  
    v_document_number := fnd_code_rule_pkg.get_rule_next_auto_num(p_document_category => c_coding_usage_code,
                                                                  p_document_type     => p_document_type,
                                                                  p_company_id        => p_company_id,
                                                                  p_operation_unit_id => p_operation_unit_id,
                                                                  p_operation_date    => p_operation_date,
                                                                  p_created_by        => p_user_id);
    IF v_document_number = fnd_code_rule_pkg.c_error THEN
      RAISE e_doc_number_error;
    END IF;
  
    IF is_exist_payment_req_doc(v_document_number, p_company_id) = 'Y' THEN
      v_document_number := get_acp_req_hd_number(p_document_type     => p_document_type,
                                                 p_company_id        => p_company_id,
                                                 p_operation_unit_id => p_operation_unit_id,
                                                 p_operation_date    => p_operation_date,
                                                 p_user_id           => p_user_id);
    END IF;
  
    RETURN v_document_number;
  
  END get_acp_req_hd_number;
  PROCEDURE reject_payment_requisition(p_payment_req_header_id NUMBER,
                                       p_user_id               NUMBER,
                                       p_update_history_flag   VARCHAR2 DEFAULT 'Y' -- add by zhanglei 增加判断，当页面审批时，需要更新单据历史表，当工作流结束调用时，无需再更新单据历史表
                                       ) IS
  
  BEGIN
    FOR c_payment_req IN (SELECT *
                            FROM acp_acp_requisition_hds h
                           WHERE h.acp_requisition_header_id =
                                 p_payment_req_header_id
                             AND h.status = c_req_hd_status_submitted
                             FOR UPDATE NOWAIT) LOOP
    
      update_payment_req_hd_status(p_payment_req_header_id => p_payment_req_header_id,
                                   p_status                => c_req_hd_status_rejected,
                                   p_user_id               => p_user_id);
    
      IF p_update_history_flag = 'Y' THEN
        --单据历史
        exp_document_history_pkg.insert_exp_document_histories(p_document_type  => c_payment_requisition,
                                                               p_document_id    => p_payment_req_header_id,
                                                               p_operation_code => exp_document_history_pkg.c_approval_reject,
                                                               p_user_id        => p_user_id,
                                                               p_operation_time => SYSDATE,
                                                               p_description    => '');
      END IF;
    END LOOP;
  
  EXCEPTION
    WHEN e_lock_table THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5010_PAYMENT_REQ_LOCK_RECORD_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'reject_payment_requisition');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'ACP_REQUISITION_PKG',
                                                     p_procedure_function_name => 'reject_payment_requisition');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  PROCEDURE take_back_payment_requisition(p_payment_req_header_id NUMBER,
                                          p_user_id               NUMBER,
                                          p_update_history_flag   VARCHAR2 DEFAULT 'Y' -- add by zhanglei 增加判断，当页面审批时，需要更新单据历史表，当工作流结束调用时，无需再更新单据历史表
                                          ) IS
  
  BEGIN
    FOR c_payment_req IN (SELECT *
                            FROM acp_acp_requisition_hds h
                           WHERE h.acp_requisition_header_id =
                                 p_payment_req_header_id
                             AND h.status = c_req_hd_status_submitted
                             FOR UPDATE NOWAIT) LOOP
    
      update_payment_req_hd_status(p_payment_req_header_id => p_payment_req_header_id,
                                   p_status                => c_req_hd_status_taken_back,
                                   p_user_id               => p_user_id);
    
      IF p_update_history_flag = 'Y' THEN
        --单据历史
        exp_document_history_pkg.insert_exp_document_histories(p_document_type  => c_payment_requisition,
                                                               p_document_id    => p_payment_req_header_id,
                                                               p_operation_code => exp_document_history_pkg.c_taken_back,
                                                               p_user_id        => p_user_id,
                                                               p_operation_time => SYSDATE,
                                                               p_description    => '');
      END IF;
    END LOOP;
  
  EXCEPTION
    WHEN e_lock_table THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5010_PAYMENT_REQ_LOCK_RECORD_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'take_back_payment_requisition');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'ACP_REQUISITION_PKG',
                                                     p_procedure_function_name => 'take_back_payment_requisition');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;
  PROCEDURE acp_req_plan_assign_chk(p_requisition_type VARCHAR2,
                                    p_acp_req_line_id  NUMBER,
                                    p_user_id          NUMBER) IS
    v_amount_tmp    NUMBER;
    v_assign_amount NUMBER;
    v_ref_count     NUMBER;
  BEGIN
  
    SELECT COUNT(1)
      INTO v_ref_count
      FROM csh_cash_plan_line_assign c
     WHERE c.document_line_id = p_acp_req_line_id
       AND c.document_type = p_requisition_type;
    IF v_ref_count <> 1 THEN
      RAISE e_plan_line_ref_check_error;
    END IF;
  
    --检验本次金额是否与申请行一致
  
    SELECT SUM(l.amount)
      INTO v_amount_tmp
      FROM acp_acp_requisition_lns l
     WHERE l.acp_requisition_line_id = p_acp_req_line_id;
  
    SELECT SUM(a.assign_amount)
      INTO v_assign_amount
      FROM csh_cash_plan_line_assign a
     WHERE a.document_line_id = p_acp_req_line_id
       AND a.document_type = p_requisition_type;
  
    IF (v_amount_tmp <> v_assign_amount) THEN
      RAISE e_plan_amount_check_error;
    END IF;
  EXCEPTION
    WHEN e_plan_line_ref_check_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'ACP5010_ACP_REQ_LINE_ONLYONE_PLAN_',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'insert_acp_req_plan_relation');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN e_plan_amount_check_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'ACP5010_ACP_REQ_PLAN_AMOUNT_CHECK',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'insert_acp_req_plan_relation');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'ACP_REQUISITION_PKG',
                                                     p_procedure_function_name => 'insert_payment_requisition_ln');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  PROCEDURE delete_check(r_payment_req acp_acp_requisition_hds%ROWTYPE,
                         p_user_id     NUMBER) IS
    e_delete_status_error EXCEPTION;
  BEGIN
    IF r_payment_req.status NOT IN
       (c_req_hd_status_generate,
        c_req_hd_status_rejected,
        c_req_hd_status_taken_back) THEN
      RAISE e_delete_status_error;
    END IF;
  EXCEPTION
    WHEN e_delete_status_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5010_PAYMENT_REQ_DELETE_STATUS_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'delete_payment_requisition');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END delete_check;
  PROCEDURE delete_payment_requisition_ln(p_requisition_type    VARCHAR2,
                                          p_payment_req_line_id NUMBER,
                                          p_user_id             NUMBER) IS
    v_csh_pmt_req_hds acp_acp_requisition_hds%ROWTYPE;
  BEGIN
    SELECT *
      INTO v_csh_pmt_req_hds
      FROM acp_acp_requisition_hds d
     WHERE d.acp_requisition_header_id =
           (SELECT l.acp_requisition_header_id
              FROM acp_acp_requisition_lns l
             WHERE l.acp_requisition_line_id = p_payment_req_line_id);
    delete_check(r_payment_req => v_csh_pmt_req_hds,
                 p_user_id     => p_user_id);
  
    --删除相关资金计划
    DELETE FROM csh_cash_plan_line_assign r
     WHERE r.document_line_id = p_payment_req_line_id
       AND r.document_type = p_requisition_type;
    --删除行
    DELETE FROM acp_acp_requisition_lns ln
     WHERE ln.acp_requisition_line_id = p_payment_req_line_id;
  
    DELETE FROM csh_doc_payment_company c
     WHERE c.document_type = 'ACP_REQUISITION'
       AND c.document_line_id = p_payment_req_line_id;
  
    /*delete from con_document_flows f
     where f.document_type =
           con_contract_maintenance_pkg.c_con_contract_hds
       and f.source_document_type =
           con_contract_maintenance_pkg.c_csh_pmy_req_lns
       and f.source_document_line_id = p_payment_req_line_id;
    
    delete from csh_payment_requisition_lns
     where payment_requisition_line_id = p_payment_req_line_id;
    
    delete from csh_doc_payment_company p
     where p.document_type = 'PAYMENT_REQUISITION'
       and p.document_line_id = p_payment_req_line_id;*/
  
  EXCEPTION
    WHEN no_data_found THEN
      NULL;
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'ACP_REQUISITION_PKG',
                                                     p_procedure_function_name => 'delete_payment_requisition_ln');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  PROCEDURE update_reports_post_workflow(p_wfl_instance_id NUMBER,
                                         p_wfl_status      NUMBER,
                                         p_user_id         NUMBER) IS
    r_instance wfl_workflow_instance%ROWTYPE;
  
  BEGIN
    SELECT *
      INTO r_instance
      FROM wfl_workflow_instance
     WHERE instance_id = p_wfl_instance_id;
  
    --审批通过
    IF p_wfl_status = wfl_core_pkg.c_workflow_finished THEN
    
      approve_payment_requisition(p_payment_req_header_id => r_instance.instance_param,
                                  p_user_id               => p_user_id,
                                  p_update_history_flag   => 'N');
    END IF;
  
    --审批拒绝
    IF p_wfl_status = wfl_core_pkg.c_workflow_terminated THEN
    
      reject_payment_requisition(p_payment_req_header_id => r_instance.instance_param,
                                 p_user_id               => p_user_id,
                                 p_update_history_flag   => 'N');
    
    END IF;
  
    --收回
    IF p_wfl_status = wfl_core_pkg.c_workflow_canceled THEN
    
      take_back_payment_requisition(p_payment_req_header_id => r_instance.instance_param,
                                    p_user_id               => p_user_id,
                                    p_update_history_flag   => 'N');
    
    END IF;
  
  END update_reports_post_workflow;

  PROCEDURE submit_check(r_payment_req acp_acp_requisition_hds%ROWTYPE,
                         p_user_id     NUMBER) IS
    --v_exists number;
    v_plan_ref_count NUMBER;
  
    v_acp_line_id NUMBER;
    v_flag        VARCHAR2(1);
  
    e_sum_req_amt_error EXCEPTION;
    e_exp_req_con_error EXCEPTION;
    --e_submit_currency_error exception;
    CURSOR cur_acp_req IS
      SELECT l.acp_requisition_line_id
        FROM acp_acp_requisition_lns l
       WHERE l.acp_requisition_header_id =
             r_payment_req.acp_requisition_header_id;
  BEGIN
    v_flag := sys_parameter_pkg.value('HCT_REQ_CASH_PLAN_RELATIONSHIP',
                                      NULL,
                                      NULL,
                                      r_payment_req.company_id);
    OPEN cur_acp_req;
    LOOP
      FETCH cur_acp_req
        INTO v_acp_line_id;
      EXIT WHEN cur_acp_req%NOTFOUND;
    
      SELECT COUNT(1)
        INTO v_plan_ref_count
        FROM csh_cash_plan_line_assign REF
       WHERE ref.document_line_id = v_acp_line_id
         AND ref.document_type = 'ACP_REQUISITION';
    
      IF v_flag = 'Y' THEN
        IF (v_plan_ref_count = 0) THEN
          RAISE e_plan_no_ref_line_error;
        END IF;
      
        acp_req_plan_assign_chk(p_requisition_type => 'ACP_REQUISITION',
                                p_acp_req_line_id  => v_acp_line_id,
                                p_user_id          => p_user_id);
      END IF;
    END LOOP;
    CLOSE cur_acp_req;
  EXCEPTION
    WHEN e_plan_no_ref_line_error THEN
      IF cur_acp_req%ISOPEN THEN
        CLOSE cur_acp_req;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'ACP5010_ACP_REQ_PLAN_NO_RELATION',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'submit_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_exp_req_con_error THEN
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5010_EXP_REQ_CON_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'submit_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END submit_check;
  FUNCTION get_auto_approve_flag(p_type_id NUMBER) RETURN VARCHAR2 IS
    v_auto_approve_flag acp_sys_acp_req_types.auto_approve_flag%TYPE;
  BEGIN
    SELECT nvl(auto_approve_flag, 'N')
      INTO v_auto_approve_flag
      FROM acp_sys_acp_req_types t
     WHERE t.acp_req_type_id = p_type_id;
    RETURN v_auto_approve_flag;
  
  EXCEPTION
    WHEN no_data_found THEN
      RETURN 'N';
  END get_auto_approve_flag;

  --提交
  PROCEDURE submit_payment_requisition(p_payment_req_header_id NUMBER,
                                       p_user_id               NUMBER) IS
  
    v_instance_id wfl_workflow_instance.instance_id%TYPE;
    v_submit_flag VARCHAR2(1);
  BEGIN
    FOR c_payment_req IN (SELECT *
                            FROM acp_acp_requisition_hds h
                           WHERE h.acp_requisition_header_id =
                                 p_payment_req_header_id
                             AND h.status IN
                                 (c_req_hd_status_generate,
                                  c_req_hd_status_rejected,
                                  c_req_hd_status_taken_back)
                             FOR UPDATE NOWAIT) LOOP
      --2011.9.7高洋修改 目的：关于付款维护中资金关联功能的影藏修改
      /*submit_check(c_payment_req, p_user_id);*/
    
      --提交时 ，插入预置事件
      csh_evt_pkg.fire_workflow_event(p_event_name            => 'ACP_REQUISITION_SUBMIT',
                                      p_payment_req_header_id => p_payment_req_header_id,
                                      p_source_module         => c_csh_payment_requisition,
                                      p_event_type            => 'ACP_REQUISITION_SUBMIT',
                                      p_user_id               => p_user_id);
    
      update_payment_req_hd_status(p_payment_req_header_id => p_payment_req_header_id,
                                   p_status                => c_req_hd_status_submitted,
                                   p_user_id               => p_user_id);
    
      FOR c_lines IN (SELECT l.acp_requisition_line_id
                        FROM acp_acp_requisition_lns l
                       WHERE l.acp_requisition_header_id =
                             p_payment_req_header_id) LOOP
        update_payment_req_ln_status(p_payment_req_line_id => c_lines.acp_requisition_line_id,
                                     p_status              => c_req_ln_status_never,
                                     p_user_id             => p_user_id);
      END LOOP;
    
      --提交历史
      exp_document_history_pkg.insert_exp_document_histories(p_document_type  => c_payment_requisition,
                                                             p_document_id    => p_payment_req_header_id,
                                                             p_operation_code => exp_document_history_pkg.c_submit,
                                                             p_user_id        => p_user_id,
                                                             p_operation_time => SYSDATE,
                                                             p_description    => '');
    
      IF get_auto_approve_flag(c_payment_req.acp_req_type_id) = 'Y' THEN
        update_payment_req_hd_status(p_payment_req_header_id => p_payment_req_header_id,
                                     p_status                => c_req_hd_status_approved,
                                     p_user_id               => p_user_id,
                                     p_approval_date         => SYSDATE,
                                     p_approved_by           => p_user_id);
      
        UPDATE acp_acp_requisition_hds h
           SET h.status           = c_req_hd_status_approved,
               h.last_updated_by  = p_user_id,
               h.last_update_date = SYSDATE
         WHERE h.acp_requisition_header_id = p_payment_req_header_id;
      
        --自审批历史
        exp_document_history_pkg.insert_exp_document_histories(p_document_type  => c_payment_requisition,
                                                               p_document_id    => p_payment_req_header_id,
                                                               p_operation_code => exp_document_history_pkg.c_approve,
                                                               p_user_id        => p_user_id,
                                                               p_operation_time => SYSDATE,
                                                               p_description    => '');
        --触发付款申请单审批通过事件
        evt_event_core_pkg.fire_event(p_event_name   => 'ACP_REQ_COMPLETELY_APPROVED',
                                      p_event_param  => p_payment_req_header_id,
                                      p_param1       => NULL,
                                      p_event_source => 'acp_req_successfully_approved',
                                      p_event_type   => 'put_document_into_pool',
                                      p_created_by   => p_user_id);
      ELSE
        --提交状态，启动工作流
        UPDATE acp_acp_requisition_hds h
           SET h.status           = 'SUBMITTED',
               h.last_updated_by  = p_user_id,
               h.last_update_date = SYSDATE
         WHERE h.acp_requisition_header_id = p_payment_req_header_id;
      
        UPDATE acp_acp_requisition_lns l
           SET l.payment_status   = 'SUBMITTED',
               l.last_updated_by  = p_user_id,
               l.last_update_date = SYSDATE
         WHERE l.acp_requisition_header_id = p_payment_req_header_id;
      
        v_instance_id := wfl_core_pkg.workflow_start(p_transaction_category => 'ACP_REQUISITION',
                                                     p_transaction_type_id  => c_payment_req.acp_req_type_id,
                                                     p_instance_param       => p_payment_req_header_id,
                                                     p_user_id              => p_user_id);
      
      END IF;
    
    END LOOP;
  
  EXCEPTION
    WHEN wfl_core_pkg.e_workflow_start_error THEN
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_lock_table THEN
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5010_PAYMENT_REQ_LOCK_RECORD_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'submit_payment_requisition');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_submit_amount_error THEN
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5010_SUBMIT_AMOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'submit_payment_requisition');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'ACP_REQUISITION_PKG',
                                                     p_procedure_function_name => 'submit_payment_requisition');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END submit_payment_requisition;
  --插入付款申请单头
  PROCEDURE insert_acp_req_hd(p_acp_req_header_id OUT NUMBER,
                              p_company_id        NUMBER,
                              p_employee_id       NUMBER,
                              -- p_acp_ref_rpt_number       varchar2,
                              p_requisition_date DATE,
                              p_acp_req_type_id  NUMBER,
                              p_currency_code    VARCHAR2,
                              
                              p_description        VARCHAR2,
                              p_status             VARCHAR2,
                              p_position_id        NUMBER,
                              p_user_id            NUMBER,
                              p_source_type        VARCHAR2,
                              p_acp_ref_rpt_number VARCHAR2) IS
    v_requisition_number csh_payment_requisition_hds.requisition_number%TYPE;
    v_unit_id            NUMBER;
  
    /**=========add business_flag========**/
    v_business_flag VARCHAR2(1);
  BEGIN
    /*依据单据类别code在编码规则取出单据编号*/
    v_requisition_number := get_acp_req_hd_number(p_document_type     => p_acp_req_type_id,
                                                  p_company_id        => p_company_id,
                                                  p_operation_unit_id => NULL,
                                                  p_operation_date    => p_requisition_date,
                                                  p_user_id           => p_user_id);
  
    IF p_position_id IS NOT NULL THEN
      SELECT unit_id
        INTO v_unit_id
        FROM exp_org_position
       WHERE position_id = p_position_id;
    END IF;
    /********add judge ‘transaction_category’**********/
    SELECT t.business_flag
      INTO v_business_flag
      FROM acp_sys_acp_req_types t
     WHERE t.acp_req_type_id = p_acp_req_type_id;
  
    /********end judge ‘transaction_category’**********/
    SELECT acp_acp_requisition_hds_s.nextval
      INTO p_acp_req_header_id
      FROM dual;
  
    INSERT INTO acp_acp_requisition_hds
      (acp_requisition_header_id,
       company_id,
       employee_id,
       requisition_number,
       --      acp_ref_rpt_number,
       requisition_date,
       acp_req_type_id,
       currency_code,
       
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
       acp_ref_rpt_number)
    VALUES
      (p_acp_req_header_id,
       p_company_id,
       p_employee_id,
       v_requisition_number,
       --    p_acp_ref_rpt_number,
       p_requisition_date,
       p_acp_req_type_id,
       p_currency_code,
       
       p_description,
       p_status,
       NULL, --approval_date,
       NULL, --approved_by,
       NULL, --closed_date,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_user_id,
       v_unit_id,
       p_position_id,
       p_source_type,
       p_acp_ref_rpt_number);
  
    exp_document_history_pkg.insert_exp_document_histories(p_document_type  => c_payment_requisition,
                                                           p_document_id    => p_acp_req_header_id,
                                                           p_operation_code => exp_document_history_pkg.c_generate,
                                                           p_user_id        => p_user_id,
                                                           p_operation_time => SYSDATE,
                                                           p_description    => p_description);
  
  EXCEPTION
    WHEN e_doc_number_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5010_PAYMENT_REQ_CODING_RULE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'insert_payment_requisition_hd');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'ACP_REQUISITION_PKG',
                                                     p_procedure_function_name => 'insert_payment_requisition_hd');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  PROCEDURE update_acp_req_hd(p_acp_req_header_id NUMBER,
                              p_operation_unit_id NUMBER,
                              p_employee_id       NUMBER,
                              p_requisition_date  DATE,
                              --   p_acp_req_type_id          number,
                              --    p_currency_code            varchar2,
                              
                              p_description VARCHAR2,
                              p_status      VARCHAR2,
                              p_position_id NUMBER,
                              p_user_id     NUMBER) IS
  
    v_unit_id NUMBER;
    CURSOR cur_lock IS
      SELECT *
        FROM acp_acp_requisition_hds h
       WHERE h.acp_requisition_header_id = p_acp_req_header_id
         FOR UPDATE NOWAIT;
  
    --p_old_contract_header_id con_document_flows.document_id%type;
  
  BEGIN
    OPEN cur_lock;
  
    IF p_position_id IS NOT NULL THEN
      SELECT unit_id
        INTO v_unit_id
        FROM exp_org_position
       WHERE position_id = p_position_id;
    END IF;
  
    UPDATE acp_acp_requisition_hds h
       SET operation_unit_id = p_operation_unit_id,
           employee_id       = p_employee_id,
           requisition_date  = p_requisition_date,
           --   acp_req_type_id          = p_acp_req_type_id,
           --     currency_code            = p_currency_code,
           
           description      = p_description,
           status           = p_status,
           position_id      = p_position_id,
           unit_id          = v_unit_id,
           last_update_date = SYSDATE,
           last_updated_by  = p_user_id
    
     WHERE acp_requisition_header_id = p_acp_req_header_id
          --0027547: 付款申请单提交问题
          
       AND h.status IN (c_req_hd_status_generate,
                        c_req_hd_status_rejected,
                        c_req_hd_status_taken_back);
    IF SQL%NOTFOUND THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5010_EXP_REQ_UPDATE_STATUS_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'update_payment_requisition_hd');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    END IF;
  
    /*    update csh_doc_payment_company a
      set a.last_update_date   = sysdate,
          a.last_updated_by    = p_user_id,
          a.payment_company_id = p_pay_com_id
    where a.document_type = 'ACP_REQUISITION'
      and a.document_id = p_acp_req_header_id;*/
  
    IF SQL%NOTFOUND THEN
      NULL;
    END IF;
  
    IF cur_lock%ISOPEN THEN
      CLOSE cur_lock;
    END IF;
  
  EXCEPTION
    WHEN e_lock_table THEN
      IF cur_lock%ISOPEN THEN
        CLOSE cur_lock;
      END IF;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5010_PAYMENT_REQ_LOCK_RECORD_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'update_payment_requisition_hd');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      IF cur_lock%ISOPEN THEN
        CLOSE cur_lock;
      END IF;
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'ACP_REQUISITION_PKG',
                                                     p_procedure_function_name => 'update_payment_requisition_hd');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;
  PROCEDURE create_csh_doc_payment_company(p_pmt_req_line_id NUMBER,
                                           p_pay_company_id  NUMBER,
                                           p_user_id         NUMBER) IS
    v_payment_company_id csh_pmt_company_mp_conds.payment_company_id%TYPE;
    v_sql                VARCHAR2(1000);
    v_payment_status     VARCHAR2(30);
    v_pay_method_code    VARCHAR2(30);
    v_count              NUMBER;
    CURSOR cur_req_pmt IS
      SELECT p.acp_requisition_line_id,
             p.acp_requisition_header_id,
             p.company_id,
             h.acp_req_type_id,
             h.operation_unit_id,
             c.payment_method_code,
             'ACP_REQUISITION' doc_category
        FROM acp_acp_requisition_lns p,
             acp_acp_requisition_hds h,
             csh_payment_methods     c
       WHERE p.acp_requisition_line_id = p_pmt_req_line_id
         AND p.acp_requisition_header_id = h.acp_requisition_header_id
         AND p.payment_method_id = c.payment_method_id;
  
    c_req_pmt cur_req_pmt%ROWTYPE;
  
    CURSOR cur_cm_conds IS
      SELECT *
        FROM csh_pmt_company_mp_conds c
       WHERE c.set_of_books_id =
             gld_common_pkg.get_set_of_books_id(c_req_pmt.company_id)
       ORDER BY c.priorty;
    c_cm_conds cur_cm_conds%ROWTYPE;
  
    e_user_exit_procedure_error EXCEPTION;
  BEGIN
  
    DELETE FROM csh_doc_payment_company p
     WHERE p.document_type = 'ACP_REQUISITION'
       AND p.document_line_id = p_pmt_req_line_id;
  
    OPEN cur_req_pmt;
    LOOP
      FETCH cur_req_pmt
        INTO c_req_pmt;
      EXIT WHEN cur_req_pmt%NOTFOUND;
    
      v_payment_company_id := p_pay_company_id;
      v_payment_status     := NULL;
    
      OPEN cur_cm_conds;
      LOOP
        FETCH cur_cm_conds
          INTO c_cm_conds;
        EXIT WHEN cur_cm_conds%NOTFOUND;
      
        IF ((c_req_pmt.company_id =
           nvl(c_cm_conds.company_id, c_req_pmt.company_id) OR
           c_cm_conds.company_id IS NULL) AND
           (c_req_pmt.doc_category =
           nvl(c_cm_conds.ducument_category, c_req_pmt.doc_category) OR
           c_cm_conds.ducument_category IS NULL) AND
           (c_req_pmt.acp_req_type_id =
           nvl(c_cm_conds.ducument_type_id, c_req_pmt.acp_req_type_id) OR
           c_cm_conds.ducument_type_id IS NULL)) THEN
        
          IF c_cm_conds.type = '10' THEN
            v_payment_company_id := c_cm_conds.payment_company_id;
          ELSIF c_cm_conds.type = '20' THEN
            v_sql := 'begin :1 := ' || c_cm_conds.user_exit_procedure ||
                     '( :2); end;';
          
            EXECUTE IMMEDIATE v_sql
              USING OUT v_payment_company_id, c_req_pmt.acp_requisition_header_id;
          END IF;
        
        END IF;
      
        IF v_payment_company_id IS NOT NULL THEN
          EXIT;
        END IF;
      END LOOP;
      CLOSE cur_cm_conds;
    
      IF v_payment_company_id IS NULL THEN
        v_payment_company_id := c_req_pmt.company_id;
      END IF;
    
      IF nvl(sys_parameter_pkg.value('DOCUMENT_PENDING_CONFIRM',
                                     '',
                                     '',
                                     c_req_pmt.company_id),
             'N') = 'N' THEN
        v_payment_status := 'ALLOWED';
      ELSE
        IF v_payment_company_id = c_req_pmt.company_id THEN
          v_payment_status := 'ALLOWED';
        ELSE
          v_payment_status := 'PENDING';
        END IF;
      END IF;
    
      /*--add by lyh 2017.5.22
      --当用户选择付款方式为营业部本级支付时，付款公司依据配置取值，
      --当付款方式为总部集中支付时，插入的付款公司为万联证券总部
      \*SELECT c.payment_method_code
       INTO v_pay_method_code
       FROM csh_payment_methods c
      WHERE c.payment_method_id = c_req_pmt.payment_method_id;*\
      SELECT COUNT(1)
        INTO v_count
        FROM sys_code_values_vl s, sys_codes s1
       WHERE s.code_id = s1.code_id
         AND s1.code = 'WLZQ_PARENT_PAYMENT'
         AND s.code_value = c_req_pmt.payment_method_code;
    
      IF v_count > 0 THEN
        --总公司就一个，级别为'10'
        SELECT f.company_id
          INTO v_payment_company_id
          FROM fnd_companies f, fnd_company_levels fs
         WHERE f.company_level_id = fs.company_level_id
           AND fs.company_level_code = '10';
      ELSE
        v_payment_company_id := c_cm_conds.payment_company_id;
      END IF;*/
      csh_doc_payment_company_pkg.insert_csh_doc_payment_company(p_document_type              => c_req_pmt.doc_category,
                                                                 p_document_id                => c_req_pmt.acp_requisition_header_id,
                                                                 p_document_line_id           => c_req_pmt.acp_requisition_line_id,
                                                                 p_document_company_id        => c_req_pmt.company_id,
                                                                 p_document_operation_unit_id => c_req_pmt.operation_unit_id,
                                                                 p_payment_company_id         => v_payment_company_id,
                                                                 p_payment_operation_unit_id  => '',
                                                                 p_payment_status             => v_payment_status,
                                                                 p_user_id                    => p_user_id);
    
    END LOOP;
    CLOSE cur_req_pmt;
  
  EXCEPTION
    WHEN OTHERS THEN
      IF cur_cm_conds%ISOPEN THEN
        CLOSE cur_cm_conds;
      END IF;
      IF cur_req_pmt%ISOPEN THEN
        CLOSE cur_req_pmt;
      END IF;
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'ACP_REQUISITION_PKG',
                                                     p_procedure_function_name => 'create_csh_doc_payment_company');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END create_csh_doc_payment_company;

  PROCEDURE insert_acp_req_ln(p_acp_req_line_id          OUT NUMBER,
                              p_acp_req_header_id        NUMBER,
                              p_acp_req_line_type        VARCHAR2,
                              p_usedes_id                NUMBER,
                              p_ref_document_id          NUMBER,
                              p_ref_document_line_id     NUMBER,
                              p_amount                   NUMBER,
                              p_line_description         VARCHAR2,
                              p_payment_status           VARCHAR2,
                              p_contract_header_id       NUMBER,
                              p_payment_completed_date   DATE,
                              p_user_id                  NUMBER,
                              p_partner_category         VARCHAR2,
                              p_partner_id               NUMBER,
                              p_account_name             VARCHAR2,
                              p_account_number           VARCHAR2,
                              p_bank_code                VARCHAR2,
                              p_bank_name                VARCHAR2,
                              p_bank_location_code       VARCHAR2,
                              p_bank_location_name       VARCHAR2,
                              p_province_code            VARCHAR2,
                              p_province_name            VARCHAR2,
                              p_city_code                VARCHAR2,
                              p_city_name                VARCHAR2,
                              p_pay_com_id               NUMBER,
                              p_company_id               NUMBER,
                              p_payment_method_id        NUMBER,
                              p_payment_schedule_line_id NUMBER,
                              p_requisition_payment_date DATE,
                              p_gather_flag              VARCHAR2 DEFAULT NULL) IS
    v_cash_flow_item_id NUMBER;
    v_check_flag        VARCHAR2(1);
    e_amount_error EXCEPTION;
  BEGIN
  
    v_check_flag := check_pmt_amount(p_acp_req_line_id,
                                     p_ref_document_id,
                                     p_ref_document_line_id,
                                     p_amount);
    IF v_check_flag = 'N' THEN
      RAISE e_amount_error;
    END IF;
    BEGIN
      SELECT cdf.cash_flow_item_id
        INTO v_cash_flow_item_id
        FROM csh_default_flowitems cdf
       WHERE cdf.default_type = 'PAYMENT_USEDES'
         AND cdf.default_code =
             (SELECT usedes_code
                FROM csh_payment_usedes
               WHERE usedes_id = p_usedes_id)
         AND cdf.enabled_flag = 'Y'
         AND cdf.default_flag = 'Y';
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    p_acp_req_line_id := get_acp_req_line_id;
    INSERT INTO acp_acp_requisition_lns
      (acp_requisition_header_id,
       acp_requisition_line_id,
       acp_requisition_line_type,
       ref_document_id,
       ref_document_line_id,
       usedes_id,
       company_id,
       partner_category,
       partner_id,
       amount,
       line_description,
       payment_status,
       contract_header_id,
       payment_completed_date,
       account_name,
       account_number,
       bank_code,
       bank_name,
       bank_location_code,
       bank_location_name,
       province_code,
       province_name,
       city_code,
       city_name,
       payment_method_id,
       payment_schedule_line_id,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by,
       cash_flow_item_id,
       requisition_payment_date,
       gather_flag)
    VALUES
      (p_acp_req_header_id,
       p_acp_req_line_id,
       p_acp_req_line_type,
       p_ref_document_id,
       p_ref_document_line_id,
       p_usedes_id,
       p_company_id,
       p_partner_category,
       p_partner_id,
       p_amount,
       p_line_description,
       p_payment_status,
       p_contract_header_id,
       p_payment_completed_date,
       p_account_name,
       p_account_number,
       p_bank_code,
       p_bank_name,
       p_bank_location_code,
       p_bank_location_name,
       p_province_code,
       p_province_name,
       p_city_code,
       p_city_name,
       p_payment_method_id,
       p_payment_schedule_line_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_user_id,
       v_cash_flow_item_id,
       p_requisition_payment_date,
       p_gather_flag);
  
    create_csh_doc_payment_company(p_pmt_req_line_id => p_acp_req_line_id,
                                   p_pay_company_id  => p_pay_com_id,
                                   p_user_id         => p_user_id);
  
  EXCEPTION
    WHEN e_amount_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'ACP_APPLY_AMOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'insert_payment_requisition_ln');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_ref_amount_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5010_REQ_AMOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'insert_payment_requisition_ln');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'ACP_REQUISITION_PKG',
                                                     p_procedure_function_name => 'insert_payment_requisition_ln');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  PROCEDURE update_acp_req_ln(p_acp_req_line_id            NUMBER,
                              p_acp_req_line_type          VARCHAR2,
                              p_usedes_id                  NUMBER,
                              p_ref_document_id            NUMBER,
                              p_ref_document_line_id       NUMBER,
                              p_amount                     NUMBER,
                              p_line_description           VARCHAR2,
                              p_payment_status             VARCHAR2,
                              p_contract_header_id         NUMBER,
                              p_payment_completed_date     DATE,
                              p_user_id                    NUMBER,
                              p_partner_category           VARCHAR2,
                              p_partner_id                 NUMBER,
                              p_csh_transaction_class_code VARCHAR2,
                              p_account_name               VARCHAR2,
                              p_account_number             VARCHAR2,
                              p_bank_code                  VARCHAR2,
                              p_bank_name                  VARCHAR2,
                              p_bank_location_code         VARCHAR2,
                              p_bank_location_name         VARCHAR2,
                              p_province_code              VARCHAR2,
                              p_province_name              VARCHAR2,
                              p_city_code                  VARCHAR2,
                              p_city_name                  VARCHAR2,
                              p_payment_schedule_line_id   NUMBER,
                              p_company_id                 NUMBER,
                              p_requisition_payment_date   DATE,
                              p_gather_flag                VARCHAR2 DEFAULT NULL) IS
    v_acp_req_header_id NUMBER;
    v_cash_flow_item_id NUMBER;
  
    v_check_flag VARCHAR2(1);
    e_amount_error EXCEPTION;
  BEGIN
  
    v_check_flag := check_pmt_amount(p_acp_req_line_id,
                                     p_ref_document_id,
                                     p_ref_document_line_id,
                                     p_amount);
    IF v_check_flag = 'N' THEN
      RAISE e_amount_error;
    END IF;
  
    SELECT l.acp_requisition_header_id
      INTO v_acp_req_header_id
      FROM acp_acp_requisition_lns l
     WHERE l.acp_requisition_line_id = p_acp_req_line_id;
    BEGIN
      SELECT cdf.cash_flow_item_id
        INTO v_cash_flow_item_id
        FROM csh_default_flowitems cdf
       WHERE cdf.default_type = 'PAYMENT_USEDES'
         AND cdf.default_code =
             (SELECT usedes_code
                FROM csh_payment_usedes
               WHERE usedes_id = p_usedes_id)
         AND cdf.enabled_flag = 'Y'
         AND cdf.default_flag = 'Y';
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    UPDATE acp_acp_requisition_lns n
       SET acp_requisition_line_type  = p_acp_req_line_type,
           ref_document_id            = p_ref_document_id,
           ref_document_line_id       = p_ref_document_line_id,
           amount                     = p_amount,
           line_description           = p_line_description,
           payment_status             = p_payment_status,
           contract_header_id         = p_contract_header_id,
           payment_completed_date     = p_payment_completed_date,
           last_update_date           = SYSDATE,
           last_updated_by            = p_user_id,
           partner_category           = p_partner_category,
           partner_id                 = p_partner_id,
           account_name               = p_account_name,
           usedes_id                  = p_usedes_id,
           account_number             = p_account_number,
           bank_code                  = p_bank_code,
           bank_name                  = p_bank_name,
           bank_location_code         = p_bank_location_code,
           bank_location_name         = p_bank_location_name,
           province_code              = p_province_code,
           province_name              = p_province_name,
           city_code                  = p_city_code,
           city_name                  = p_city_name,
           payment_schedule_line_id   = p_payment_schedule_line_id,
           csh_transaction_class_code = p_csh_transaction_class_code,
           company_id                 = p_company_id,
           cash_flow_item_id          = v_cash_flow_item_id,
           requisition_payment_date   = p_requisition_payment_date,
           gather_flag                = p_gather_flag
     WHERE n.acp_requisition_line_id = p_acp_req_line_id;
  
  EXCEPTION
    WHEN no_data_found THEN
      NULL;
    WHEN e_amount_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'ACP_APPLY_AMOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'insert_payment_requisition_ln');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN e_ref_amount_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5010_REQ_AMOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'insert_payment_requisition_ln');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'ACP_REQUISITION_PKG',
                                                     p_procedure_function_name => 'update_payment_requisition_ln');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  PROCEDURE delete_acp_req_ln(p_acp_requisition_line_id NUMBER) IS
  BEGIN
    DELETE FROM acp_acp_requisition_lns l
     WHERE l.acp_requisition_line_id = p_acp_requisition_line_id;
  END delete_acp_req_ln;

  --待付确认中修改相应收款人信息
  PROCEDURE update_acp_ln_payee_info(p_acp_req_header_id  NUMBER,
                                     p_acp_req_line_id    NUMBER,
                                     p_account_name       VARCHAR2,
                                     p_account_number     VARCHAR2,
                                     p_bank_code          VARCHAR2,
                                     p_bank_name          VARCHAR2,
                                     p_bank_location_code VARCHAR2,
                                     p_bank_location_name VARCHAR2,
                                     p_province_code      VARCHAR2,
                                     p_province_name      VARCHAR2,
                                     p_city_code          VARCHAR2,
                                     p_city_name          VARCHAR2,
                                     /*p_partner_payee         varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     p_partner_bank_branch   varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     p_partner_bank_acc      varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     p_partner_bank_acc_addr varchar2,*/
                                     p_user_id NUMBER) IS
  
  BEGIN
  
    UPDATE acp_acp_requisition_lns n
       SET account_name       = p_account_name,
           account_number     = p_account_number,
           bank_code          = p_bank_code,
           bank_name          = p_bank_name,
           bank_location_code = p_bank_location_code,
           bank_location_name = p_bank_location_name,
           province_code      = p_province_code,
           province_name      = p_province_name,
           city_code          = p_city_code,
           city_name          = p_city_name,
           /*partner_bank_acc_code    = p_partner_bank_acc,
           partner_bank_branch_code = p_partner_bank_branch,
           partner_bank_acc_addr    = p_partner_bank_acc_addr,
           partner_payee            = p_partner_payee,*/
           last_update_date = SYSDATE,
           last_updated_by  = p_user_id
     WHERE n.acp_requisition_line_id = p_acp_req_line_id
       AND n.acp_requisition_header_id = p_acp_req_header_id;
  EXCEPTION
    WHEN no_data_found THEN
      NULL;
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'ACP_REQUISITION_PKG',
                                                     p_procedure_function_name => 'update_acp_ln_payee_info');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_acp_ln_payee_info;

  --申请单提交调用
  PROCEDURE submit_acp_req(p_acp_req_header_id NUMBER,
                           /*p_status            varchar2,*/
                           p_user_id NUMBER) IS
    v_approval_date     DATE;
    v_approved_by       NUMBER;
    v_status            VARCHAR2(30);
    v_auto_approve_flag VARCHAR2(1);
    v_acp_req_type_id   NUMBER;
    v_instance_id       NUMBER;
  
    CURSOR cur_lock IS
      SELECT *
        FROM acp_acp_requisition_hds h
       WHERE h.acp_requisition_header_id = p_acp_req_header_id
         FOR UPDATE NOWAIT;
  
  BEGIN
    OPEN cur_lock;
    SELECT h.acp_req_type_id
      INTO v_acp_req_type_id
      FROM acp_acp_requisition_hds h
     WHERE h.acp_requisition_header_id = p_acp_req_header_id;
    SELECT a.auto_approve_flag
      INTO v_auto_approve_flag
      FROM acp_sys_acp_req_types a
     WHERE a.acp_req_type_id =
           (SELECT h.acp_req_type_id
              FROM acp_acp_requisition_hds h
             WHERE h.acp_requisition_header_id = p_acp_req_header_id);
    IF v_auto_approve_flag = 'Y' THEN
      v_status := c_req_hd_status_approved;
    ELSE
      v_status := c_req_hd_status_submitted;
    END IF;
    IF v_status = c_req_hd_status_approved THEN
      v_approval_date := trunc(SYSDATE);
      v_approved_by   := p_user_id;
    ELSE
      v_approval_date := '';
      v_approved_by   := '';
    END IF;
    --插入提交历史 
    exp_document_history_pkg.insert_exp_document_histories(p_document_type  => c_payment_requisition,
                                                           p_document_id    => p_acp_req_header_id,
                                                           p_operation_code => exp_document_history_pkg.c_submit,
                                                           p_user_id        => p_user_id,
                                                           p_operation_time => SYSDATE,
                                                           p_description    => '');
    --自审批
    IF v_auto_approve_flag = 'Y' THEN
      update_payment_req_hd_status(p_payment_req_header_id => p_acp_req_header_id,
                                   p_status                => v_status,
                                   p_user_id               => p_user_id,
                                   p_approval_date         => v_approval_date,
                                   p_approved_by           => v_approved_by);
    
      --申请单调用时的单据历史
      exp_document_history_pkg.insert_exp_document_histories(p_document_type  => c_payment_requisition,
                                                             p_document_id    => p_acp_req_header_id,
                                                             p_operation_code => exp_document_history_pkg.c_submit,
                                                             p_user_id        => p_user_id,
                                                             p_operation_time => SYSDATE,
                                                             p_description    => '');
    
      --触发付款申请单审批通过事件
      /*evt_event_core_pkg.fire_event(p_event_name   => 'ACP_REQ_COMPLETELY_APPROVED',
                                    p_event_param  => p_acp_req_header_id,
                                    p_param1       => NULL,
                                    p_event_source => 'acp_req_successfully_approved',
                                    p_event_type   => 'put_document_into_pool',
                                    p_created_by   => p_user_id);*/
      --审批结束，发送资金 add by pqs 20180927
        exp_evt_pkg.fire_workflow_event(p_event_name       => 'ACP_REQUISITION_COMPLETELY_APPROVED',
                                        p_document_id      => p_acp_req_header_id,
                                        p_document_line_id => NULL,
                                        p_source_module    => 'acp_requisition_successfully_approved',
                                        p_event_type       => 'PUT_ACP_REQUISITION_INTO_POOL',
                                        p_user_id          => p_user_id);                               
    ELSE
      ----提交状态 ，启动工作流
      update_payment_req_hd_status(p_payment_req_header_id => p_acp_req_header_id,
                                   p_status                => v_status,
                                   p_user_id               => p_user_id,
                                   p_approval_date         => v_approval_date,
                                   p_approved_by           => v_approved_by);
      --调用工作流流程
      BEGIN
        v_instance_id := wfl_core_pkg.workflow_start(p_transaction_category => 'ACP_REQUISITION',
                                                     p_transaction_type_id  => v_acp_req_type_id,
                                                     p_instance_param       => p_acp_req_header_id,
                                                     p_user_id              => p_user_id);
      
      END;
    END IF;
  
    IF cur_lock%ISOPEN THEN
      CLOSE cur_lock;
    END IF;
  EXCEPTION
    WHEN e_lock_table THEN
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5010_PAYMENT_REQ_LOCK_RECORD_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'submit_payment_requisition');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_submit_amount_error THEN
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5010_SUBMIT_AMOUNT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'submit_payment_requisition');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'ACP_REQUISITION_PKG',
                                                     p_procedure_function_name => 'submit_payment_requisition');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END submit_acp_req;

  --付款申请单打开
  PROCEDURE acp_requisition_open(p_requisition_header_id NUMBER,
                                 p_user_id               NUMBER) IS
  BEGIN
    UPDATE acp_acp_requisition_hds t
       SET t.status = c_req_hd_status_approved, t.closed_date = NULL
     WHERE t.acp_requisition_header_id = p_requisition_header_id;
  
    exp_document_history_pkg.insert_exp_document_histories(p_document_type  => c_payment_requisition,
                                                           p_document_id    => p_requisition_header_id,
                                                           p_operation_code => exp_document_history_pkg.c_open,
                                                           p_user_id        => p_user_id,
                                                           p_operation_time => SYSDATE,
                                                           p_description    => '');
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'ACP_REQUISITION_PKG',
                                                     p_procedure_function_name => 'acp_requisition_open');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END acp_requisition_open;

  --付款申请单关闭
  PROCEDURE acp_requisition_close(p_requisition_header_id NUMBER,
                                  p_user_id               NUMBER) IS
  BEGIN
    UPDATE acp_acp_requisition_hds t
       SET t.status = c_req_hd_status_closed, t.closed_date = SYSDATE
     WHERE t.acp_requisition_header_id = p_requisition_header_id;
  
    exp_document_history_pkg.insert_exp_document_histories(p_document_type  => c_payment_requisition,
                                                           p_document_id    => p_requisition_header_id,
                                                           p_operation_code => exp_document_history_pkg.c_close,
                                                           p_user_id        => p_user_id,
                                                           p_operation_time => SYSDATE,
                                                           p_description    => '');
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'ACP_REQUISITION_PKG',
                                                     p_procedure_function_name => 'acp_requisition_close');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END acp_requisition_close;

  PROCEDURE delete_payment_requisition(p_payment_req_header_id NUMBER,
                                       p_user_id               NUMBER) IS
  
  BEGIN
    FOR c_payment_req IN (SELECT *
                            FROM acp_acp_requisition_hds h
                           WHERE h.acp_requisition_header_id =
                                 p_payment_req_header_id
                             FOR UPDATE NOWAIT) LOOP
    
      delete_check(c_payment_req, p_user_id);
    
      --删除对应的工作流数据  --add by zhanglei 2010-11-3
      wfl_core_pkg.workflow_instance_delete(p_transaction_category => c_payment_requisition,
                                            p_instance_param       => p_payment_req_header_id);
    
      --删除相关资金计划
      DELETE FROM csh_cash_plan_line_assign r
       WHERE r.document_type = 'ACP_REQUISITION'
         AND EXISTS
       (SELECT 1
                FROM acp_acp_requisition_lns l
               WHERE l.acp_requisition_line_id = r.document_line_id
                 AND l.acp_requisition_header_id = p_payment_req_header_id);
    
      DELETE acp_acp_requisition_lns
       WHERE acp_requisition_header_id = p_payment_req_header_id;
    
      DELETE acp_acp_requisition_hds hd
       WHERE hd.acp_requisition_header_id = p_payment_req_header_id;
    
      DELETE FROM csh_doc_payment_company p
       WHERE p.document_type = 'ACP_REQUISITION'
         AND p.document_id = p_payment_req_header_id;
    
      --删除历史
      exp_document_history_pkg.delete_exp_document_histories(p_document_type => c_payment_requisition,
                                                             p_document_id   => p_payment_req_header_id);
    END LOOP;
  
  EXCEPTION
    WHEN e_lock_table THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CSH5010_PAYMENT_REQ_LOCK_RECORD_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'ACP_REQUISITION_PKG',
                                                      p_procedure_function_name => 'delete_payment_requisition');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'ACP_REQUISITION_PKG',
                                                     p_procedure_function_name => 'delete_payment_requisition');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;
  --申请单审批后调用
  PROCEDURE set_csh_pmt_req_status_by_req(p_exp_req_header_id NUMBER,
                                          p_status            VARCHAR2,
                                          p_user_id           NUMBER) IS
  BEGIN
    IF get_pmt_req_approved_with_req(p_exp_req_header_id) = 'Y' THEN
      FOR c_payment_req IN (SELECT h.acp_requisition_header_id pmt_req_header_id
                              FROM acp_acp_requisition_hds h
                             WHERE h.acp_requisition_header_id IN
                                   (SELECT pl.acp_requisition_header_id
                                      FROM acp_acp_requisition_lns pl
                                     WHERE pl.acp_requisition_line_type =
                                           'ACP_REQUISITION'
                                       AND pl.ref_document_id =
                                           p_exp_req_header_id)) LOOP
        IF p_status = c_req_hd_status_approved THEN
          approve_payment_requisition(p_payment_req_header_id => c_payment_req.pmt_req_header_id,
                                      p_user_id               => p_user_id);
        ELSIF p_status = c_req_hd_status_taken_back THEN
          take_back_payment_requisition(p_payment_req_header_id => c_payment_req.pmt_req_header_id,
                                        p_user_id               => p_user_id);
        ELSIF p_status = c_req_hd_status_rejected THEN
          reject_payment_requisition(p_payment_req_header_id => c_payment_req.pmt_req_header_id,
                                     p_user_id               => p_user_id);
        
        END IF;
      END LOOP;
    END IF;
  END set_csh_pmt_req_status_by_req;
  --add by Qu yuanyuan 工作流调整付款方式及集中支付
  PROCEDURE update_acp_req_ln_adjust_pay(p_acp_requisition_line_id NUMBER,
                                         p_payment_method_id       NUMBER,
                                         p_gather_flag             VARCHAR2,
                                         p_user_id                 NUMBER) IS
  BEGIN
    UPDATE acp_acp_requisition_lns l
       SET l.payment_method_id = p_payment_method_id,
           l.gather_flag       = p_gather_flag,
           l.last_updated_by   = p_user_id,
           l.last_update_date  = SYSDATE
     WHERE l.acp_requisition_line_id = p_acp_requisition_line_id;
  END update_acp_req_ln_adjust_pay;
  --end by Qu yuanyuan
END acp_requisition_pkg;
/
