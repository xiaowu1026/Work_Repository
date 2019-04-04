CREATE OR REPLACE PACKAGE con_contract_maintenance_pkg IS

  -- Author  : BOBO
  -- Created : 2009-7-6 12:53:37
  -- Purpose : --合同维护

  --Ver: 1.7
  --合同提交时，增加是否自审批的处理  [set_con_contract_header_status]
  --Modify by bobo

  --Ver: 1.9 2009.09.08
  --合同保存时，自动将当前公司插入合同引用授权表
  --Modify by bobo

  --Ver: 1.10
  --合同资金计划行增加p_start_date 参数
  -- (Source)Document Types for table [CON_DOCUMENT_FLOWS]
  --c_csh_pmy_req_hds       constant varchar2(30) := 'CSH_PAYMENT_REQUISITION_HDS'; --借款申请
  --c_exp_requisition_hds   constant varchar2(30) := 'EXP_REQUISITION_HEADERS'; --费用申请
  --c_exp_report_hds        constant varchar2(30) := 'EXP_REPORT_HEADERS'; --报销单
  --c_con_invoice_hds       constant varchar2(30) := 'CON_INVOICE_HEADERS'; --合同关联的发票
  --c_csh_transaction_hds   constant varchar2(30) := 'CSH_TRANSACTION_HEADERS'; --现金
  c_csh_pmy_req_lns            CONSTANT VARCHAR2(30) := 'CSH_PAYMENT_REQUISITION_LNS'; --借款申请行
  c_exp_requisition_lns        CONSTANT VARCHAR2(30) := 'EXP_REQUISITION_LINES'; --费用申请行
  c_exp_rep_pmt_schedules      CONSTANT VARCHAR2(30) := 'EXP_REPORT_PMT_SCHEDULES'; --报销单付款计划行
  c_con_contract_hds           CONSTANT VARCHAR2(30) := 'CON_CONTRACT'; --合同
  c_con_payment_schedules      CONSTANT VARCHAR2(30) := 'CON_PAYMENT_SCHEDULES'; --资金计划行
  c_source_type_exp_rpt_ln     CONSTANT VARCHAR2(30) := 'EXP_REPORT_LINES'; --费用报销单行
  c_source_type_pur_req_ln     CONSTANT VARCHAR2(30) := 'PUR_REQUISITION_LINES'; --采购申请单行
  c_source_type_pur_ord_ln     CONSTANT VARCHAR2(30) := 'PUR_ORDER_LINES'; --采购订单行
  c_source_type_acp_invoice_ln CONSTANT VARCHAR2(30) := 'ACP_INVOICE_LINES'; --应付发票行
  c_acp_invoice_pmt_schedules  CONSTANT VARCHAR2(30) := 'ACP_INVOICE_PMT_SCHEDULES'; --应付发票计划付款行

  FUNCTION get_contract_header_id RETURN NUMBER;
  FUNCTION get_con_invoice_header_id RETURN NUMBER;
  FUNCTION get_con_payment_schedule_id RETURN NUMBER; --资金计划行ID
  FUNCTION get_con_invoice_schedule_id RETURN NUMBER; --发票关联付款计划行
  FUNCTION get_contract_object_line_id RETURN NUMBER;
  FUNCTION get_contract_partner_line_id RETURN NUMBER; --合同对象
  FUNCTION get_partner_contactors_id RETURN NUMBER; --联系人
  FUNCTION get_contract_term_id RETURN NUMBER;
  FUNCTION get_contract_privileges_id RETURN NUMBER;
  FUNCTION get_contract_tax_line_id RETURN NUMBER;

  PROCEDURE insert_con_document_flows(p_document_type           VARCHAR2,
                                      p_document_id             NUMBER,
                                      p_document_line_id        NUMBER DEFAULT NULL,
                                      p_source_document_type    VARCHAR2,
                                      p_source_document_id      NUMBER,
                                      p_source_document_line_id NUMBER DEFAULT NULL,
                                      p_user_id                 NUMBER);

  --报销单、申请单更新合同关系
  PROCEDURE update_con_doc_flows_by_exp(p_document_type           VARCHAR2,
                                        p_document_id             NUMBER,
                                        p_document_line_id        NUMBER,
                                        p_source_document_type    VARCHAR2,
                                        p_source_document_id      NUMBER,
                                        p_source_document_line_id NUMBER,
                                        p_user_id                 NUMBER);

  PROCEDURE delete_con_document_flows(p_document_type        VARCHAR2,
                                      p_document_id          NUMBER,
                                      p_document_line_id     NUMBER DEFAULT NULL,
                                      p_source_document_type VARCHAR2 DEFAULT NULL,
                                      
                                      p_source_document_id      NUMBER DEFAULT NULL,
                                      p_source_document_line_id NUMBER DEFAULT NULL);

  /*--保存数据前，锁表、状态校验
  procedure update_contract_status_check(p_contract_header_id number,
                                         p_user_id            number);*/

  FUNCTION get_document_number(p_document_type     VARCHAR2,
                               p_company_id        NUMBER,
                               p_operation_unit_id NUMBER,
                               p_operation_date    DATE,
                               p_user_id           NUMBER) RETURN VARCHAR2;

  --新建合同头
  PROCEDURE insert_con_contract_headers(p_contract_header_id   OUT NUMBER,
                                        p_company_id           NUMBER,
                                        p_contract_type_id     NUMBER,
                                        p_status               VARCHAR2 DEFAULT 'GENERATE',
                                        p_document_number      VARCHAR2,
                                        p_document_desc        VARCHAR2,
                                        p_document_date        DATE,
                                        p_start_date           DATE,
                                        p_end_date             DATE,
                                        p_currency_code        VARCHAR2,
                                        p_amount               NUMBER,
                                        p_unit_id              NUMBER,
                                        p_employee_id          NUMBER,
                                        p_payment_method       VARCHAR2,
                                        p_payment_term_id      NUMBER,
                                        p_partner_category     VARCHAR2,
                                        p_partner_id           NUMBER,
                                        p_version_number       VARCHAR2,
                                        p_version_desc         VARCHAR2,
                                        p_note                 VARCHAR2,
                                        p_project_id           NUMBER,
                                        p_user_id              NUMBER,
                                        p_ass_contract         VARCHAR2 DEFAULT NULL,
                                        p_contract_id          VARCHAR2,
                                        p_invoice_sales_amount NUMBER DEFAULT NULL,
                                        p_position_id number default null);

  PROCEDURE update_con_contract_headers(p_contract_header_id   NUMBER,
                                        p_document_desc        VARCHAR2,
                                        p_start_date           DATE,
                                        p_end_date             DATE,
                                        p_amount               NUMBER,
                                        p_unit_id              NUMBER,
                                        p_employee_id          NUMBER,
                                        p_partner_id           NUMBER,
                                        p_version_number       VARCHAR2,
                                        p_version_desc         VARCHAR2,
                                        p_note                 VARCHAR2,
                                        p_project_id           NUMBER,
                                        p_user_id              NUMBER,
                                        p_ass_contract         VARCHAR2 DEFAULT NULL,
                                        p_document_number      VARCHAR2 DEFAULT NULL,
                                        p_payment_method       VARCHAR2 DEFAULT NULL,
                                        p_document_date        DATE DEFAULT NULL,
                                        p_currency_code        VARCHAR2 DEFAULT NULL,
                                        p_contract_id          VARCHAR2,
                                        p_invoice_sales_amount NUMBER DEFAULT NULL,
                                        p_position_id number default null);

  --取得资金计划行金额合计
  FUNCTION get_total_con_pmt_schedule_amt(p_contract_header_id NUMBER)
    RETURN NUMBER;

  PROCEDURE set_con_contract_header_status(p_contract_header_id NUMBER,
                                           p_status             VARCHAR2,
                                           p_user_id            NUMBER,
                                           p_reject_reason      VARCHAR2 DEFAULT NULL); --add by Quyuanyuan 拒绝原因

  --整单删除
  PROCEDURE delete_con_contract_headers(p_contract_header_id NUMBER,
                                        p_user_id            NUMBER);

  --税
  PROCEDURE insert_con_contract_tax(p_contract_header_id   NUMBER,
                                    p_tax_type_id          NUMBER,
                                    p_tax_amount           NUMBER,
                                    p_user_id              NUMBER,
                                    p_contract_tax_line_id OUT NUMBER);

  PROCEDURE update_con_contract_tax(p_contract_header_id   NUMBER,
                                    p_contract_tax_line_id NUMBER,
                                    p_tax_type_id          NUMBER,
                                    p_tax_amount           NUMBER,
                                    p_user_id              NUMBER);

  PROCEDURE delete_con_contract_tax(p_contract_header_id   NUMBER,
                                    p_contract_tax_line_id NUMBER,
                                    p_user_id              NUMBER);

  --新建资金计划行
  PROCEDURE insert_con_payment_schedules(p_contract_header_id           NUMBER,
                                         p_payment_schedule_line_number NUMBER,
                                         p_expense_type_id              NUMBER,
                                         p_req_item_id                  NUMBER,
                                         p_amount                       NUMBER,
                                         p_payment_method               VARCHAR2,
                                         p_payment_term_id              NUMBER,
                                         p_partner_category             VARCHAR2,
                                         p_partner_id                   NUMBER,
                                         p_due_date                     DATE,
                                         p_actual_date                  DATE,
                                         p_memo                         VARCHAR2,
                                         p_user_id                      NUMBER,
                                         p_currency_code                VARCHAR2,
                                         p_payment_schedule_line_id     OUT NUMBER,
                                         p_start_date                   DATE DEFAULT NULL);

  PROCEDURE update_con_payment_schedules(p_contract_header_id       NUMBER,
                                         p_payment_schedule_line_id NUMBER,
                                         p_expense_type_id          NUMBER,
                                         p_req_item_id              NUMBER,
                                         p_amount                   NUMBER,
                                         p_payment_method           VARCHAR2,
                                         p_payment_term_id          NUMBER,
                                         p_partner_category         VARCHAR2,
                                         p_partner_id               NUMBER,
                                         p_due_date                 DATE,
                                         p_actual_date              DATE,
                                         p_memo                     VARCHAR2,
                                         p_user_id                  NUMBER,
                                         p_currency_code            VARCHAR2,
                                         p_start_date               DATE DEFAULT NULL);

  --删除资金计划行
  PROCEDURE delete_con_payment_schedules(p_contract_header_id       NUMBER,
                                         p_payment_schedule_line_id NUMBER,
                                         p_user_id                  NUMBER);

  --新建： 合同交付物
  PROCEDURE insert_contract_object_lines(p_contract_header_id          NUMBER,
                                         p_contract_object_line_number NUMBER,
                                         p_object_type                 VARCHAR2,
                                         p_object_id                   NUMBER,
                                         p_quantity                    NUMBER,
                                         p_amount                      NUMBER,
                                         p_address                     VARCHAR2,
                                         p_due_date                    DATE,
                                         p_actual_date                 DATE,
                                         p_memo                        VARCHAR2,
                                         p_user_id                     NUMBER,
                                         p_contract_object_line_id     OUT NUMBER);

  PROCEDURE update_contract_object_lines(p_contract_header_id      NUMBER,
                                         p_contract_object_line_id NUMBER,
                                         p_object_type             VARCHAR2,
                                         p_object_id               NUMBER,
                                         p_quantity                NUMBER,
                                         p_amount                  NUMBER,
                                         p_address                 VARCHAR2,
                                         p_due_date                DATE,
                                         p_actual_date             DATE,
                                         p_memo                    VARCHAR2,
                                         p_user_id                 NUMBER);

  PROCEDURE delete_contract_object_lines(p_contract_header_id      NUMBER,
                                         p_contract_object_line_id NUMBER,
                                         p_user_id                 NUMBER);

  --新建：合同对象
  PROCEDURE insert_contract_partner_lines(p_contract_header_id       NUMBER,
                                          p_partner_category         VARCHAR2,
                                          p_partner_id               NUMBER,
                                          p_bank_branch_code         VARCHAR2,
                                          p_bank_account_code        VARCHAR2,
                                          p_tax_id_number            VARCHAR2,
                                          p_memo                     VARCHAR2,
                                          p_user_id                  NUMBER,
                                          p_contract_partner_line_id OUT NUMBER);

  PROCEDURE update_contract_partner_lines(p_contract_header_id       NUMBER,
                                          p_contract_partner_line_id NUMBER,
                                          p_partner_category         VARCHAR2,
                                          p_partner_id               NUMBER,
                                          p_bank_branch_code         VARCHAR2,
                                          p_bank_account_code        VARCHAR2,
                                          p_tax_id_number            VARCHAR2,
                                          p_memo                     VARCHAR2,
                                          p_user_id                  NUMBER);

  PROCEDURE delete_contract_partner_lines(p_contract_header_id       NUMBER,
                                          p_contract_partner_line_id NUMBER,
                                          p_user_id                  NUMBER);

  --新建： 合同联系人
  PROCEDURE inesert_con_partner_contactors(p_contract_partner_line_id NUMBER,
                                           p_contactor_name           VARCHAR2,
                                           p_contactor_position       VARCHAR2,
                                           p_sex                      VARCHAR2,
                                           p_phone_number             VARCHAR2,
                                           p_mobile                   VARCHAR2,
                                           p_fax                      VARCHAR2,
                                           p_email                    VARCHAR2,
                                           p_memo                     VARCHAR2,
                                           p_user_id                  NUMBER,
                                           p_partner_contactors_id    OUT NUMBER);

  PROCEDURE update_con_partner_contactors(p_contract_partner_line_id NUMBER,
                                          p_partner_contactors_id    NUMBER,
                                          p_contactor_name           VARCHAR2,
                                          p_contactor_position       VARCHAR2,
                                          p_sex                      VARCHAR2,
                                          p_phone_number             VARCHAR2,
                                          p_mobile                   VARCHAR2,
                                          p_fax                      VARCHAR2,
                                          p_email                    VARCHAR2,
                                          p_memo                     VARCHAR2,
                                          p_user_id                  NUMBER);

  PROCEDURE delete_con_partner_contactors(p_contract_partner_line_id NUMBER,
                                          p_partner_contactors_id    NUMBER,
                                          p_user_id                  NUMBER);

  --新建：合同条款
  PROCEDURE insert_con_contract_terms(p_contract_header_id NUMBER,
                                      p_contract_term_type VARCHAR2,
                                      p_contract_term_desc VARCHAR2,
                                      p_user_id            NUMBER,
                                      p_contract_term_id   OUT NUMBER);

  PROCEDURE update_con_contract_terms(p_contract_header_id NUMBER,
                                      p_contract_term_id   NUMBER,
                                      p_contract_term_desc VARCHAR2,
                                      p_user_id            NUMBER);

  PROCEDURE delete_con_contract_terms(p_contract_header_id NUMBER,
                                      p_contract_term_id   NUMBER,
                                      p_user_id            NUMBER);

  --新建：合同权限
  PROCEDURE insert_con_contract_privileges(p_contract_header_id     NUMBER,
                                           p_position_id            NUMBER,
                                           p_employee_id            NUMBER,
                                           p_contract_privilege     VARCHAR2,
                                           p_user_id                NUMBER,
                                           p_contract_privileges_id OUT NUMBER);

  PROCEDURE update_con_contract_privileges(p_contract_header_id     NUMBER,
                                           p_contract_privileges_id NUMBER,
                                           p_position_id            NUMBER,
                                           p_employee_id            NUMBER,
                                           p_contract_privilege     VARCHAR2,
                                           p_user_id                NUMBER);

  PROCEDURE delete_con_contract_privileges(p_contract_header_id     NUMBER,
                                           p_contract_privileges_id NUMBER,
                                           p_user_id                NUMBER);

  --合同发票
  PROCEDURE insert_con_invoice_headers(p_contract_header_id  NUMBER,
                                       p_invoice_type        VARCHAR2,
                                       p_invoice_number      VARCHAR2,
                                       p_invoice_amount      NUMBER,
                                       p_invoice_date        DATE,
                                       p_tax_included_flag   VARCHAR2,
                                       p_tax_type_id         NUMBER,
                                       p_tax_amount          NUMBER,
                                       p_payment_method_code VARCHAR2,
                                       p_payment_term_id     NUMBER,
                                       p_partner_category    VARCHAR2,
                                       p_partner_id          NUMBER,
                                       p_memo                VARCHAR2,
                                       p_user_id             NUMBER,
                                       p_company_id          NUMBER,
                                       p_invoice_header_id   OUT NUMBER);

  PROCEDURE update_con_invoice_headers(p_contract_header_id  NUMBER,
                                       p_invoice_header_id   NUMBER,
                                       p_invoice_type        VARCHAR2,
                                       p_invoice_amount      NUMBER,
                                       p_invoice_date        DATE,
                                       p_tax_included_flag   VARCHAR2,
                                       p_tax_type_id         NUMBER,
                                       p_tax_amount          NUMBER,
                                       p_payment_method_code VARCHAR2,
                                       p_payment_term_id     NUMBER,
                                       p_partner_category    VARCHAR2,
                                       p_partner_id          NUMBER,
                                       p_memo                VARCHAR2,
                                       p_user_id             NUMBER);

  PROCEDURE delete_con_invoice_headers(p_contract_header_id NUMBER,
                                       p_invoice_header_id  NUMBER,
                                       p_user_id            NUMBER);

  --发票关联资金计划行
  PROCEDURE inst_con_invoice_pmt_schedules(p_invoice_header_id            NUMBER,
                                           p_payment_schedule_line_id     NUMBER,
                                           p_payment_schedule_line_number NUMBER,
                                           p_amount                       NUMBER,
                                           p_user_id                      NUMBER,
                                           p_invoice_payment_schedule_id  OUT NUMBER);

  PROCEDURE updt_con_invoice_pmt_schedules(p_invoice_header_id           NUMBER,
                                           p_invoice_payment_schedule_id NUMBER,
                                           p_amount                      NUMBER,
                                           p_user_id                     NUMBER);

  PROCEDURE del_con_invoice_pmt_schedules(p_invoice_header_id        NUMBER,
                                          p_payment_schedule_line_id NUMBER,
                                          p_user_id                  NUMBER);

  /* --现金事务对应资金计划行
  procedure inst_cash_trx_pmt_schdl_lns(p_csh_transaction_line_id  number,
                                        p_payment_schedule_line_id number,
                                        p_amount                   number,
                                        p_user_id                  number);*/

  --合同变更历史
  PROCEDURE insert_con_contract_histories(p_contract_header_id NUMBER,
                                          p_operation_code     VARCHAR2,
                                          p_user_id            NUMBER,
                                          p_employee_id        NUMBER,
                                          p_description        VARCHAR2);

  --Delete by bobo 2009.08.25
  /*  --生成申请单头
  procedure create_exp_requisition_header(p_contract_header_id        number,
                                          p_exp_requisition_type_id   number,
                                          p_user_id                   number,
                                          p_exp_requisition_header_id out number);
  
  --生成申请单行
  procedure create_exp_requisiton_line(p_exp_requisition_header_id number,
                                       p_payment_schedule_line_id  number,
                                       p_user_id                   number);
  
  --重新设置申请单行号
  procedure post_create_exp_requisition(p_exp_requisition_header_id number,
                                        p_user_id                   number);*/

  /*  --资金计划生成 申请单
  procedure con_pmt_schedules_to_exp_req(p_contract_header_id       number,
                                         p_payment_schedule_line_id number,
                                         p_exp_requisition_type_id  number,
                                         p_user_id                  number);*/

  FUNCTION exist_con_authorities(p_contract_header_id NUMBER,
                                 p_employee_id        NUMBER,
                                 p_authority          VARCHAR2 DEFAULT 'MODIFY',
                                 p_user_id            NUMBER) RETURN VARCHAR2;

  FUNCTION onexist_con_authorities(p_contract_header_id NUMBER,
                                   p_employee_id        NUMBER,
                                   p_user_id            NUMBER)
    RETURN VARCHAR2;

  --2010.07.28 by bobo
  --若单据关联了合同则必须关联资金计划行
  PROCEDURE contract_schedule_check(p_source_document_type VARCHAR2,
                                    p_source_document_id   NUMBER);

  --工作流运行完毕后，设置状态
  PROCEDURE update_post_workflow(p_wfl_instance_id NUMBER,
                                 p_wfl_status      NUMBER,
                                 p_user_id         NUMBER);
  -- Author  : lyh
  -- Created : 2017/7/19 17:18:01
  -- Purpose : 合同维护的供应商，在保存后，如果公司级供应商中没有，则分配,并插入维护表
  /**************************************************/
  PROCEDURE insert_con_contracr_vender(p_partner_id NUMBER,
                                       p_company_id NUMBER,
                                       p_user_id    NUMBER);
  --校验合同
  PROCEDURE check_contract_number(p_contract_header_id VARCHAR2,
                                  p_message            OUT VARCHAR2);
  --校验OA合同是否存在
  PROCEDURE get_contract_id(p_contract_code VARCHAR2,
                            p_contract_id   OUT NUMBER,
                            p_message       OUT VARCHAR2);

  --#########################################
  -- 发送通知
  --#########################################
  FUNCTION generate_sys_notify(p_event_id    NUMBER,
                               p_log_id      NUMBER,
                               p_event_param NUMBER,
                               p_created_by  NUMBER) RETURN NUMBER;
END con_contract_maintenance_pkg;
/
CREATE OR REPLACE PACKAGE BODY con_contract_maintenance_pkg IS

  e_sub_program_error     EXCEPTION;
  e_contract_update_error EXCEPTION;
  e_lock_table            EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_lock_table, -54);

  FUNCTION get_contract_header_id RETURN NUMBER IS
    v_contract_header_id con_contract_headers.contract_header_id%TYPE;
  BEGIN
    SELECT con_contract_headers_s.nextval
      INTO v_contract_header_id
      FROM dual;
    RETURN v_contract_header_id;
  END get_contract_header_id;

  FUNCTION get_con_invoice_header_id RETURN NUMBER IS
    v_invoice_header_id con_invoice_headers.invoice_header_id%TYPE;
  BEGIN
    SELECT con_invoice_headers_s.nextval
      INTO v_invoice_header_id
      FROM dual;
    RETURN v_invoice_header_id;
  END get_con_invoice_header_id;

  --资金计划行ID
  FUNCTION get_con_payment_schedule_id RETURN NUMBER IS
    v_payment_schedule_line_id con_payment_schedules.payment_schedule_line_id%TYPE;
  BEGIN
    SELECT con_payment_schedules_s.nextval
      INTO v_payment_schedule_line_id
      FROM dual;
    RETURN v_payment_schedule_line_id;
  END get_con_payment_schedule_id;

  --发票关联付款计划行
  FUNCTION get_con_invoice_schedule_id RETURN NUMBER IS
    v_payment_schedule_line_id con_invoice_payment_schedules.payment_schedule_line_id%TYPE;
  BEGIN
    SELECT con_invoice_payment_schedule_s.nextval
      INTO v_payment_schedule_line_id
      FROM dual;
    RETURN v_payment_schedule_line_id;
  END get_con_invoice_schedule_id;

  FUNCTION get_contract_object_line_id RETURN NUMBER IS
    v_contract_object_line_id con_contract_object_lines.contract_object_line_id%TYPE;
  BEGIN
    SELECT con_contract_object_lines_s.nextval
      INTO v_contract_object_line_id
      FROM dual;
    RETURN v_contract_object_line_id;
  END get_contract_object_line_id;

  --合同对象
  FUNCTION get_contract_partner_line_id RETURN NUMBER IS
    v_contract_partner_line_id con_contract_partner_lines.contract_partner_line_id%TYPE;
  BEGIN
    SELECT con_contract_partner_lines_s.nextval
      INTO v_contract_partner_line_id
      FROM dual;
    RETURN v_contract_partner_line_id;
  END get_contract_partner_line_id;

  --联系人
  FUNCTION get_partner_contactors_id RETURN NUMBER IS
    v_partner_contactors_id con_partner_contactors.partner_contactors_id%TYPE;
  BEGIN
    SELECT con_partner_contactors_s.nextval
      INTO v_partner_contactors_id
      FROM dual;
    RETURN v_partner_contactors_id;
  END get_partner_contactors_id;

  FUNCTION get_contract_term_id RETURN NUMBER IS
    v_contract_term_id con_contract_terms.contract_term_id%TYPE;
  BEGIN
    SELECT con_contract_terms_s.nextval INTO v_contract_term_id FROM dual;
    RETURN v_contract_term_id;
  END get_contract_term_id;

  FUNCTION get_contract_privileges_id RETURN NUMBER IS
    v_contract_privileges_id con_contract_privileges.contract_privileges_id%TYPE;
  BEGIN
    SELECT con_contract_privileges_s.nextval
      INTO v_contract_privileges_id
      FROM dual;
    RETURN v_contract_privileges_id;
  END get_contract_privileges_id;

  PROCEDURE insert_con_document_flows(p_document_type           VARCHAR2,
                                      p_document_id             NUMBER,
                                      p_document_line_id        NUMBER DEFAULT NULL,
                                      p_source_document_type    VARCHAR2,
                                      p_source_document_id      NUMBER,
                                      p_source_document_line_id NUMBER DEFAULT NULL,
                                      p_user_id                 NUMBER) IS
  BEGIN
    IF p_document_id IS NULL THEN
      RETURN;
    END IF;
    INSERT INTO con_document_flows
      (document_type,
       document_id,
       document_line_id,
       source_document_type,
       source_document_id,
       source_document_line_id,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (upper(p_document_type),
       p_document_id,
       p_document_line_id,
       upper(p_source_document_type),
       p_source_document_id,
       p_source_document_line_id,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE);
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'insert_con_document_flows');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_con_document_flows;

  --报销单、申请单更新合同关系
  PROCEDURE update_con_doc_flows_by_exp(p_document_type           VARCHAR2,
                                        p_document_id             NUMBER,
                                        p_document_line_id        NUMBER,
                                        p_source_document_type    VARCHAR2,
                                        p_source_document_id      NUMBER,
                                        p_source_document_line_id NUMBER,
                                        p_user_id                 NUMBER) IS
  BEGIN
    /*if p_document_line_id is null or
    p_document_id is null then*/
    DELETE FROM con_document_flows df
     WHERE df.source_document_type = p_source_document_type
       AND df.source_document_id = p_source_document_id
       AND df.source_document_line_id = p_source_document_line_id
       AND df.document_type = p_document_type;
    /*return;
    end if;*/
  
    /*if p_document_id is not null then
    update con_document_flows df
       set df.last_updated_by  = p_user_id,
           df.last_update_date = sysdate,
           df.document_id      = p_document_id,
           df.document_line_id = p_document_line_id
     where df.source_document_type = p_source_document_type
       and df.source_document_id = p_source_document_id
       and df.source_document_line_id = p_source_document_line_id
       and df.document_type = p_document_type;
    
    if sql%notfound then*/
    insert_con_document_flows(p_document_type           => p_document_type,
                              p_document_id             => p_document_id,
                              p_document_line_id        => p_document_line_id,
                              p_source_document_type    => p_source_document_type,
                              p_source_document_id      => p_source_document_id,
                              p_source_document_line_id => p_source_document_line_id,
                              p_user_id                 => p_user_id);
    /*end if;
    end if;*/
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'update_con_doc_flows_by_exp');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_con_doc_flows_by_exp;

  PROCEDURE delete_con_document_flows(p_document_type           VARCHAR2,
                                      p_document_id             NUMBER,
                                      p_document_line_id        NUMBER DEFAULT NULL,
                                      p_source_document_type    VARCHAR2 DEFAULT NULL,
                                      p_source_document_id      NUMBER DEFAULT NULL,
                                      p_source_document_line_id NUMBER DEFAULT NULL) IS
  BEGIN
    DELETE FROM con_document_flows f
     WHERE f.document_type = nvl(upper(p_document_type), f.document_type)
       AND f.document_id = nvl(p_document_id, f.document_id)
       AND (f.document_line_id = p_document_line_id OR
           (f.document_line_id IS NULL AND p_document_line_id IS NULL))
       AND f.source_document_type =
           nvl(upper(p_source_document_type), f.source_document_type)
       AND f.source_document_id =
           nvl(p_source_document_id, f.source_document_id)
       AND (f.source_document_line_id = p_source_document_line_id OR
           (f.source_document_line_id IS NULL AND
           p_source_document_line_id IS NULL));
  END delete_con_document_flows;

  FUNCTION get_contract_tax_line_id RETURN NUMBER IS
    v_contract_tax_line_id con_contract_tax.contract_tax_line_id%TYPE;
  BEGIN
    SELECT con_contract_tax_s.nextval
      INTO v_contract_tax_line_id
      FROM dual;
    RETURN v_contract_tax_line_id;
  END get_contract_tax_line_id;

  FUNCTION get_exist_flag(p_doc_number VARCHAR2, p_company_id NUMBER)
    RETURN VARCHAR2 IS
    v_exsit VARCHAR2(1);
  BEGIN
  
    SELECT decode(COUNT(0), 0, 'N', 1, 'Y', 'Y')
      INTO v_exsit
      FROM con_contract_headers t
     WHERE t.company_id = p_company_id
       AND t.contract_number = p_doc_number;
  
    RETURN v_exsit;
  END get_exist_flag;

  FUNCTION get_document_number(p_document_type     VARCHAR2,
                               p_company_id        NUMBER,
                               p_operation_unit_id NUMBER,
                               p_operation_date    DATE,
                               p_user_id           NUMBER) RETURN VARCHAR2 IS
  
    c_coding_usage_code CONSTANT VARCHAR2(30) := '07';
    v_count NUMBER;
  
    v_start_doc_number con_contract_headers.contract_number%TYPE;
    v_document_number  con_contract_headers.contract_number%TYPE;
  BEGIN
  
    v_start_doc_number := fnd_code_rule_pkg.get_rule_next_auto_num(p_document_category => c_coding_usage_code,
                                                                   p_document_type     => p_document_type,
                                                                   p_company_id        => p_company_id,
                                                                   p_operation_unit_id => p_operation_unit_id,
                                                                   p_operation_date    => p_operation_date,
                                                                   p_created_by        => p_user_id);
    v_document_number  := v_start_doc_number;
    v_count            := 1;
  
    IF get_exist_flag(v_document_number, p_company_id) = 'Y' THEN
      LOOP
        v_document_number := fnd_code_rule_pkg.get_rule_next_auto_num(p_document_category => c_coding_usage_code,
                                                                      p_document_type     => p_document_type,
                                                                      p_company_id        => p_company_id,
                                                                      p_operation_unit_id => p_operation_unit_id,
                                                                      p_operation_date    => p_operation_date,
                                                                      p_created_by        => p_user_id);
        IF v_start_doc_number = v_document_number AND v_count > 1 THEN
          RETURN fnd_code_rule_pkg.c_error;
        END IF;
        IF get_exist_flag(v_document_number, p_company_id) = 'N' THEN
          RETURN v_document_number;
        END IF;
        v_count := v_count + 1;
      END LOOP;
    ELSE
      RETURN v_document_number;
    END IF;
  
  END get_document_number;

  PROCEDURE update_contract_status_check(p_contract_header_id NUMBER,
                                         p_user_id            NUMBER) IS
    v_contract_header_id con_contract_headers.contract_header_id%TYPE;
  BEGIN
    SELECT contract_header_id
      INTO v_contract_header_id
      FROM con_contract_headers h
     WHERE h.contract_header_id = p_contract_header_id
       AND h.status IN ('GENERATE', 'REJECTED')
       FOR UPDATE NOWAIT;
  
  EXCEPTION
    WHEN no_data_found THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_UPDATE_STATUS_CHECK_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'update_contract_status_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_lock_table THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_LOCK_RECORD_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'update_contract_status_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_contract_status_check;

  PROCEDURE delete_contract_status_check(p_contract_header_id NUMBER,
                                         p_user_id            NUMBER) IS
    v_contract_header_id con_contract_headers.contract_header_id%TYPE;
  BEGIN
    SELECT contract_header_id
      INTO v_contract_header_id
      FROM con_contract_headers h
     WHERE h.contract_header_id = p_contract_header_id
       AND h.status IN ('GENERATE', 'REJECTED')
       FOR UPDATE NOWAIT;
  
  EXCEPTION
    WHEN e_lock_table THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_LOCK_RECORD_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'delete_contract_status_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN no_data_found THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_DELETE_STATUS_CHECK_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'delete_contract_status_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END delete_contract_status_check;

  PROCEDURE get_partner_information(p_partner_category  VARCHAR2,
                                    p_partner_id        NUMBER,
                                    p_bank_branch_code  OUT VARCHAR2,
                                    p_bank_account_code OUT VARCHAR2,
                                    p_tax_id_number     OUT VARCHAR2) IS
  BEGIN
    IF p_partner_category = 'VENDER' THEN
      SELECT v.bank_location_code, v.account_number
        INTO p_bank_branch_code, p_bank_account_code
        FROM pur_vender_accounts v
       WHERE v.vender_id = p_partner_id
         AND v.primary_flag = 'Y';
    
    ELSIF p_partner_category = 'CUSTOMER' THEN
      SELECT v.bank_branch_code, v.bank_account_code, v.tax_id_number
        INTO p_bank_branch_code, p_bank_account_code, p_tax_id_number
        FROM ord_system_customers_vl v
       WHERE v.customer_id = p_partner_id;
    
    ELSIF p_partner_category = 'EMPLOYEE' THEN
      SELECT e.bank_location_code, e.account_number
        INTO p_bank_branch_code, p_bank_account_code
        FROM exp_employee_accounts e
       WHERE e.employee_id = p_partner_id
            /*add by lyh 2017.5.15*/
         AND e.primary_flag = 'Y';
    END IF;
  EXCEPTION
    WHEN no_data_found THEN
      p_bank_branch_code  := '';
      p_bank_account_code := '';
      p_tax_id_number     := '';
  END get_partner_information;

  --新建合同头
  PROCEDURE insert_con_contract_headers(p_contract_header_id OUT NUMBER,
                                        p_company_id         NUMBER,
                                        p_contract_type_id   NUMBER,
                                        p_status             VARCHAR2 DEFAULT 'GENERATE',
                                        p_document_number    VARCHAR2,
                                        p_document_desc      VARCHAR2,
                                        p_document_date      DATE,
                                        p_start_date         DATE,
                                        p_end_date           DATE,
                                        p_currency_code      VARCHAR2,
                                        p_amount             NUMBER,
                                        p_unit_id            NUMBER,
                                        p_employee_id        NUMBER,
                                        p_payment_method     VARCHAR2,
                                        p_payment_term_id    NUMBER,
                                        p_partner_category   VARCHAR2,
                                        p_partner_id         NUMBER,
                                        p_version_number     VARCHAR2,
                                        p_version_desc       VARCHAR2,
                                        p_note               VARCHAR2,
                                        p_project_id         NUMBER,
                                        p_user_id            NUMBER,
                                        p_ass_contract       VARCHAR2 default null,
                                        p_contract_id        varchar2,
                                        p_invoice_sales_amount number default null,
                                        p_position_id number default null) IS
    v_contract_number con_contract_headers.contract_number%TYPE;
  
    v_bank_branch_code  con_contract_partner_lines.bank_branch_code%TYPE;
    v_bank_account_code con_contract_partner_lines.bank_account_code%TYPE;
    v_tax_id_number     con_contract_partner_lines.tax_id_number%TYPE;
    v_ref_authority_id  con_contract_ref_authority.ref_authority_id%TYPE;
  
    e_document_number_error EXCEPTION;
    e_no_contract exception;
    v_exit varchar2(1);
  BEGIN
    begin
      select 'Y'
        into v_exit
        from con_sign_oa c
       where c.sign_id = p_contract_id;
    exception
      when no_data_found then
        raise e_no_contract;
    end;

    p_contract_header_id := get_contract_header_id;
    v_contract_number    := get_document_number(p_document_type     => p_contract_type_id,
                                                p_company_id        => p_company_id,
                                                p_operation_unit_id => '',
                                                p_operation_date    => trunc(SYSDATE),
                                                p_user_id           => p_user_id);
  
    IF v_contract_number = fnd_code_rule_pkg.c_error THEN
      RAISE e_document_number_error;
    END IF;
  
    INSERT INTO con_contract_headers
      (contract_header_id,
       company_id,
       contract_type_id,
       contract_number,
       status,
       document_number,
       document_desc,
       document_date,
       start_date,
       end_date,
       currency_code,
       amount,
       unit_id,
       employee_id,
       payment_method,
       payment_term_id,
       partner_category,
       partner_id,
       version_number,
       version_desc,
       note,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       project_id,
       ass_contract,
       contract_id,
       invoice_sales_amount,
       position_id)
    VALUES
      (p_contract_header_id,
       p_company_id,
       p_contract_type_id,
       v_contract_number,
       p_status,
       p_document_number,
       p_document_desc,
       p_document_date,
       p_start_date,
       p_end_date,
       p_currency_code,
       p_amount,
       p_unit_id,
       p_employee_id,
       p_payment_method,
       p_payment_term_id,
       p_partner_category,
       p_partner_id,
       p_version_number,
       p_version_desc,
       p_note,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_project_id,
       p_ass_contract,
       p_contract_id,
       p_invoice_sales_amount,
       p_position_id);
  
    insert_con_contract_histories(p_contract_header_id => p_contract_header_id,
                                  p_operation_code     => 'GENERATE',
                                  p_user_id            => p_user_id,
                                  p_employee_id        => '',
                                  p_description        => p_note);
  
    --默认合同对象
    IF p_partner_id IS NOT NULL THEN
      get_partner_information(p_partner_category  => p_partner_category,
                              p_partner_id        => p_partner_id,
                              p_bank_branch_code  => v_bank_branch_code,
                              p_bank_account_code => v_bank_account_code,
                              p_tax_id_number     => v_tax_id_number);
      INSERT INTO con_contract_partner_lines
        (contract_header_id,
         contract_partner_line_id,
         partner_category,
         partner_id,
         bank_branch_code,
         bank_account_code,
         tax_id_number,
         memo,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date)
        SELECT h.contract_header_id,
               get_contract_partner_line_id,
               h.partner_category,
               h.partner_id,
               v_bank_branch_code,
               v_bank_account_code,
               v_tax_id_number,
               '',
               p_user_id,
               SYSDATE,
               p_user_id,
               SYSDATE
          FROM con_contract_headers h
         WHERE h.contract_header_id = p_contract_header_id;
    END IF;
  
    --默认合同权限
    INSERT INTO con_contract_privileges
      (contract_header_id,
       contract_privileges_id,
       position_id,
       employee_id,
       contract_privilege,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
      SELECT p_contract_header_id,
             get_contract_privileges_id,
             p.position_id,
             p.employee_id,
             p.contract_privilege,
             p_user_id,
             SYSDATE,
             p_user_id,
             SYSDATE
        FROM con_contract_type_privileges p
       WHERE p.contract_type_dist_id IN
             (SELECT d.contract_type_dist_id
                FROM con_contract_type_dists d
               WHERE d.contract_type_id = p_contract_type_id
                 AND d.company_id = p_company_id
                 AND d.enabled_flag = 'Y');
  
    --用户本身对应的员工
    INSERT INTO con_contract_privileges
      (contract_header_id,
       contract_privileges_id,
       position_id,
       employee_id,
       contract_privilege,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
      SELECT p_contract_header_id,
             get_contract_privileges_id,
             '',
             p.employee_id,
             'MODIFY',
             p_user_id,
             SYSDATE,
             p_user_id,
             SYSDATE
        FROM sys_user p
       WHERE p.user_id = p_user_id
         AND p.employee_id IS NOT NULL
         AND NOT EXISTS
       (SELECT 1
                FROM con_contract_privileges c
               WHERE c.contract_header_id = p_contract_header_id
                 AND c.employee_id = p.employee_id
                 AND c.contract_privilege = 'MODIFY'
                 AND c.position_id IS NULL);
  
    --用户本身对应的员工
    INSERT INTO con_contract_privileges
      (contract_header_id,
       contract_privileges_id,
       position_id,
       employee_id,
       contract_privilege,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
      SELECT p_contract_header_id,
             get_contract_privileges_id,
             '',
             p.employee_id,
             'QUERY',
             p_user_id,
             SYSDATE,
             p_user_id,
             SYSDATE
        FROM sys_user p
       WHERE p.user_id = p_user_id
         AND p.employee_id IS NOT NULL
         AND NOT EXISTS
       (SELECT 1
                FROM con_contract_privileges c
               WHERE c.contract_header_id = p_contract_header_id
                 AND c.employee_id = p.employee_id
                 AND c.contract_privilege = 'QUERY'
                 AND c.position_id IS NULL);
  
    --2009.09.08 插入合同引用授权表
    con_contract_ref_authority_pkg.ins_contract_ref_authority(p_ref_authority_id   => v_ref_authority_id,
                                                              p_contract_header_id => p_contract_header_id,
                                                              p_company_id         => p_company_id,
                                                              p_employee_id        => '',
                                                              p_enabled_flag       => 'Y',
                                                              p_user_id            => p_user_id);
  EXCEPTION
    when e_no_contract then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                  => '您输入的OA合同编号有误，请检查！',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'insert_con_contract_headers');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_document_number_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_CODING_RULE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'insert_con_contract_headers');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'insert_con_contract_headers');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_con_contract_headers;

  PROCEDURE update_con_contract_headers(p_contract_header_id NUMBER,
                                        p_document_desc      VARCHAR2,
                                        p_start_date         DATE,
                                        p_end_date           DATE,
                                        p_amount             NUMBER,
                                        p_unit_id            NUMBER,
                                        p_employee_id        NUMBER,
                                        p_partner_id         NUMBER,
                                        p_version_number     VARCHAR2,
                                        p_version_desc       VARCHAR2,
                                        p_note               VARCHAR2,
                                        p_project_id         NUMBER,
                                        p_user_id            NUMBER,
                                        p_ass_contract       VARCHAR2 default null,
                                        p_document_number    VARCHAR2 DEFAULT NULL,
                                        p_payment_method     VARCHAR2 default null,
                                        p_document_date      DATE DEFAULT NULL,
                                        p_currency_code      VARCHAR2 DEFAULT NULL,
                                        p_contract_id        varchar2,
                                        p_invoice_sales_amount number default null,
                                        p_position_id number default null) IS
    e_no_contract exception;
    v_exit varchar2(1);
  BEGIN
    begin
    select 'Y'
        into v_exit
        from con_sign_oa c
       where c.sign_id = p_contract_id;
    exception
      when no_data_found then
      raise e_no_contract;
    end;
    update_contract_status_check(p_contract_header_id => p_contract_header_id,
                                 p_user_id            => p_user_id);
    UPDATE con_contract_headers
       SET document_desc    = p_document_desc,
           document_number  = p_document_number,
           start_date       = p_start_date,
           end_date         = p_end_date,
           amount           = p_amount,
           unit_id          = p_unit_id,
           employee_id      = p_employee_id,
           partner_id       = p_partner_id,
           version_number   = p_version_number,
           version_desc     = p_version_desc,
           note             = p_note,
           project_id       = p_project_id,
           last_updated_by  = p_user_id,
           last_update_date = SYSDATE,
           status           = decode(status, 'REJECTED', 'GENERATE', status),
           ass_contract     = p_ass_contract,
           payment_method   = p_payment_method,
           document_date    = p_document_date,
           currency_code    = p_currency_code,
           contract_id      = p_contract_id,
           invoice_sales_amount = p_invoice_sales_amount,
           position_id          = p_position_id
     WHERE contract_header_id = p_contract_header_id;
  exception
       when e_no_contract then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message            => '您输入的OA合同编号有误，请检查！',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'insert_con_contract_headers');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
                                                      
  END update_con_contract_headers;

  --取得资金计划行金额合计
  FUNCTION get_total_con_pmt_schedule_amt(p_contract_header_id NUMBER)
    RETURN NUMBER IS
    v_total_schedule_amount NUMBER;
  BEGIN
    SELECT nvl(SUM(p.amount), 0)
      INTO v_total_schedule_amount
      FROM con_payment_schedules p
     WHERE p.contract_header_id = p_contract_header_id;
    RETURN v_total_schedule_amount;
  END get_total_con_pmt_schedule_amt;

  PROCEDURE contract_amount_check(p_contract_header_id NUMBER,
                                  p_status             VARCHAR2,
                                  p_user_id            NUMBER) IS
  
    v_contract_amount       NUMBER;
    v_total_schedule_amount NUMBER;
    v_exists                NUMBER;
  
    e_total_amount_check_error EXCEPTION;
  BEGIN
    IF p_status = 'SUBMITTED' THEN
      SELECT nvl(h.amount, 0)
        INTO v_contract_amount
        FROM con_contract_headers h
       WHERE h.contract_header_id = p_contract_header_id;
    
      BEGIN
        --若无资金计划行，则不校验金额
        SELECT 1
          INTO v_exists
          FROM dual
         WHERE EXISTS
         (SELECT 1
                  FROM con_payment_schedules p
                 WHERE p.contract_header_id = p_contract_header_id);
      EXCEPTION
        WHEN no_data_found THEN
          RETURN;
      END;
    
      --获取资金计划行合计
      v_total_schedule_amount := get_total_con_pmt_schedule_amt(p_contract_header_id);
    
      IF v_total_schedule_amount <> v_contract_amount THEN
        RAISE e_total_amount_check_error;
      END IF;
    END IF;
  
  EXCEPTION
    WHEN no_data_found THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_CONTRACT_NOT_EXIST',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'contract_amount_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_total_amount_check_error THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_PMT_SCHEDULE_AMT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'contract_amount_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END contract_amount_check;
  
  --校验是否维护分摊行
  PROCEDURE con_period_check(p_contract_header_id NUMBER, p_user_id NUMBER) IS
    v_period_name                 VARCHAR2(2000);
    v_count                       NUMBER;
    v_con_contract_headers        con_contract_headers%ROWTYPE;
    v_period_invoice_sales_amount NUMBER;
    v_period_sum_amount           NUMBER;
  BEGIN
    BEGIN
      SELECT wm_concat(ccr.period_name)
        INTO v_period_name
        FROM con_contract_return_periods ccr
       WHERE ccr.contract_header_id = p_contract_header_id
         AND NOT EXISTS (SELECT 1
                FROM contract_period_allocation cpa
               WHERE ccr.contract_return_period_id =
                     cpa.contract_return_period_id);
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    IF (v_period_name IS NOT NULL) THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '受益期' ||
                                                                                  v_period_name ||
                                                                                  '未维护分摊行',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'con_period_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    END IF;
  
    --校验受益期金额
    SELECT COUNT(1)
      INTO v_count
      FROM con_contract_return_periods ccr
     WHERE ccr.contract_header_id = p_contract_header_id;
  
    SELECT *
      INTO v_con_contract_headers
      FROM con_contract_headers cch
     WHERE cch.contract_header_id = p_contract_header_id;
  
    IF (v_count > 0) THEN
      SELECT SUM(t.invoice_sales_amount), SUM(t.amount)
        INTO v_period_invoice_sales_amount, v_period_sum_amount
        FROM con_contract_return_periods t
       WHERE t.contract_header_id = p_contract_header_id;
    
      --判断受益期不含税金额与合同收益期金额是否相等
      IF (v_period_invoice_sales_amount <>
         v_con_contract_headers.invoice_sales_amount) THEN
      
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '受益期不含税金额之和不等于合同不含税金额!',
                                                       p_created_by              => p_user_id,
                                                       p_package_name            => 'con_contract_maintenance_pkg',
                                                       p_procedure_function_name => 'con_period_check');
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
      END IF;
           
      
      IF (v_period_sum_amount <> v_con_contract_headers.amount) THEN
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '受益期金额之和不等于合同金额!',
                                                       p_created_by              => p_user_id,
                                                       p_package_name            => 'con_contract_maintenance_pkg',
                                                       p_procedure_function_name => 'con_period_check1');
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
      
      END IF;
      
      
      
       --判断分摊金额
        FOR c_pe IN (SELECT *
                       FROM con_contract_return_periods t
                      WHERE EXISTS
                      (SELECT 1
                               FROM contract_period_allocation cpa
                              WHERE t.contract_return_period_id =
                                    cpa.contract_return_period_id)
                        AND t.invoice_sales_amount <>
                            (SELECT SUM(cpa.invoice_sales_amount)
                               FROM contract_period_allocation cpa
                              WHERE cpa.contract_return_period_id =
                                    t.contract_return_period_id)
                        AND t.contract_header_id = p_contract_header_id) LOOP
          sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '期间:' ||
                                                                                      c_pe.period_name ||
                                                                                      '分摊不含税金额之和不等于受益期不含税金额!',
                                                         p_created_by              => p_user_id,
                                                         p_package_name            => 'con_contract_maintenance_pkg',
                                                         p_procedure_function_name => 'con_period_check');
          raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                  sys_raise_app_error_pkg.g_err_line_id);
        END LOOP;
        
    END IF;
  END con_period_check;

  --校验合同付款计划中的收款对象是否存在于合同对象中
  PROCEDURE con_payment_schedules_check(p_contract_header_id NUMBER,
                                        p_user_id            NUMBER) IS
    v_exists NUMBER;
  BEGIN
    BEGIN
      SELECT 1
        INTO v_exists
        FROM con_payment_schedules p
       WHERE p.contract_header_id = p_contract_header_id
         AND rownum = 1;
    EXCEPTION
      WHEN no_data_found THEN
        sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_PMT_SCHEDULE_NULL',
                                                        p_created_by              => p_user_id,
                                                        p_package_name            => 'con_contract_maintenance_pkg',
                                                        p_procedure_function_name => 'con_payment_schedules_check');
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
    END;
  
    SELECT 1
      INTO v_exists
      FROM con_payment_schedules p
     WHERE p.contract_header_id = p_contract_header_id
       AND NOT EXISTS
     (SELECT 1
              FROM con_contract_partner_lines cp
             WHERE cp.partner_category = p.partner_category
               AND cp.partner_id = p.partner_id
               AND cp.contract_header_id = p.contract_header_id)
       AND rownum = 1;
    sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_PMT_SCHEDULE_PARTNER_ERROR',
                                                    p_created_by              => p_user_id,
                                                    p_package_name            => 'con_contract_maintenance_pkg',
                                                    p_procedure_function_name => 'con_payment_schedules_check');
    raise_application_error(sys_raise_app_error_pkg.c_error_number,
                            sys_raise_app_error_pkg.g_err_line_id);
  
  EXCEPTION
    WHEN no_data_found THEN
      NULL;
  END con_payment_schedules_check;

  PROCEDURE set_con_contract_header_status(p_contract_header_id NUMBER,
                                           p_status             VARCHAR2,
                                           p_user_id            NUMBER,
                                           p_reject_reason      VARCHAR2 DEFAULT NULL) --add by Quyuanyuan 拒绝原因
   IS
    v_exists           NUMBER;
    v_self_recheck     number :=0; --自审核
    v_contract_number         varchar2(100);
    v_company_id       NUMBER;
    v_contract_type_id NUMBER;
    v_instance_id      NUMBER;
    v_con_contract_headers con_contract_headers%ROWTYPE;
    v_employee_id          NUMBER;
    v_partner_id           NUMBER;
    v_partner_category     VARCHAR2(30);
    v_created_id           number;
   /* v_number number;*/
    e_lock_table EXCEPTION;    
   /* e_oa_contract exception;--增加校验*/
    PRAGMA EXCEPTION_INIT(e_lock_table, -54);
  BEGIN
    --锁定记录
    SELECT h.company_id, h.contract_type_id, h.partner_id，h.partner_category,h.contract_number,h.created_by
      INTO v_company_id, v_contract_type_id, v_partner_id, v_partner_category,v_contract_number,v_created_id
      FROM con_contract_headers h
     WHERE h.contract_header_id = p_contract_header_id
       FOR UPDATE NOWAIT;
   --校验OA编号，是否已经被使用或者正在使用
   /*begin
     --查看是否已经关联了该合同编号
     select count(*)
       into v_number
       from con_contract_headers cc
      where cc.contract_header_id in
            (select c.contract_header_id
               from con_contract_headers c
              where c.oa_contract =
                    (select c.oa_contract
                       from con_contract_headers c
                      where c.contract_header_id = p_contract_header_id))
        and cc.status not in ('GENERATE', 'CANCEL', 'REJECTED')
        and exists (select 1 from dual where p_status = 'SUBMITTED');   
     if v_number > 0 then
       raise e_oa_contract;
     end if;
     --end  add
   exception
     when e_oa_contract then
       sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '系统存在已关联同一OA合同编号的合同，请检查！',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'insert_con_contract_headers');
       raise_application_error(sys_raise_app_error_pkg.c_error_number,
                               sys_raise_app_error_pkg.g_err_line_id);
   end;*/
    contract_amount_check(p_contract_header_id => p_contract_header_id,
                          p_status             => p_status,
                          p_user_id            => p_user_id);
  
    IF p_status = 'SUBMITTED' THEN
      BEGIN
        SELECT 1
          INTO v_exists
          FROM dual
         WHERE EXISTS (SELECT *
                  FROM con_contract_headers h
                 WHERE contract_header_id = p_contract_header_id
                   AND h.status IN ('GENERATE', 'REJECTED'));
      EXCEPTION
        WHEN no_data_found THEN
          sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_DELETE_STATUS_CHECK_ERROR',
                                                          p_created_by              => p_user_id,
                                                          p_package_name            => 'con_contract_maintenance_pkg',
                                                          p_procedure_function_name => 'set_con_contract_header_status');
          raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                  sys_raise_app_error_pkg.g_err_line_id);
      END;
      
      
      
      con_payment_schedules_check(p_contract_header_id => p_contract_header_id,
                                  p_user_id            => p_user_id);
                                  
     --校验是否维护分摊行
      con_period_check(p_contract_header_id => p_contract_header_id,
                                  p_user_id            => p_user_id);
    
      insert_con_contract_histories(p_contract_header_id => p_contract_header_id,
                                    p_operation_code     => 'SUBMITTED',
                                    p_user_id            => p_user_id,
                                    p_employee_id        => '',
                                    p_description        => '');
      IF(v_partner_category = 'VENDER') THEN                            
      insert_con_contracr_vender(v_partner_id,
                                 v_company_id,
                                 p_user_id);
      END IF;
      BEGIN
        --提交时，校验是否自审核
        SELECT 1
          INTO v_self_recheck
          FROM dual
         WHERE EXISTS
         (SELECT *
                  FROM con_contract_type_dists d, con_contract_headers h
                 WHERE d.contract_type_id = h.contract_type_id
                   AND d.company_id = h.company_id
                   AND h.contract_header_id = p_contract_header_id
                   AND d.self_approval = 'Y'
                   AND d.enabled_flag = 'Y');
      
        UPDATE con_contract_headers h
           SET last_updated_by  = p_user_id,
               last_update_date = SYSDATE,
               h.status         = 'CONFIRM',
               h.reject_reason  = ''
         WHERE contract_header_id = p_contract_header_id;
      
        insert_con_contract_histories(p_contract_header_id => p_contract_header_id,
                                      p_operation_code     => 'CONFIRM',
                                      p_user_id            => p_user_id,
                                      p_employee_id        => '',
                                      p_description        => '');
      EXCEPTION
        WHEN no_data_found THEN
          UPDATE con_contract_headers h
             SET last_updated_by  = p_user_id,
                 last_update_date = SYSDATE,
                 h.status         = p_status,
                 h.reject_reason  = ''
           WHERE contract_header_id = p_contract_header_id;
          
           /**
          当合同创建人提交合同，即给相同公司下的【角色】为财务初审岗及财务复核岗推（'FINANCIAL_FIRST_REVIEW','FINANCIAL_SECOND_REVIEW'）通知。
              财务初审岗及财务复核岗点击合同编号超链接，可链接到合同审批界面。当做出审批/拒绝的动作之后，通知界面中该条合同通知则消失。
          【合同编号】取合同的头合同编号
          【合同类型 】取合同的头合同类型
          【通知人】取合同的头创建人
          【消息】如图
          【通知时间】取合同提交的时间
          **/
          for c_user in (
              select distinct t.user_id,su.employee_id 
               from sys_user_role_groups t,sys_role sr,sys_user  su
               where t.role_id = sr.role_id and t.company_id = v_company_id  
               and sr.role_code in ('FINANCIAL_FIRST_REVIEW','FINANCIAL_SECOND_REVIEW')
               and su.user_id = t.user_id) loop
                     
            INSERT INTO sys_wlzq_notify_message
                (message_id,
                 document_number,
                 document_type,
                 message,
                 doucument_owner,
                 operated_by,
                 operated_date,
                 para_1,
                 para_2)
            VALUES
              (sys_wlzq_notify_message_s.nextval,
               v_contract_number,
               'CONTRACTS_APPROVE',
               '您有合同待审批，请尽快处理!',
                c_user.user_id,
               (select su.employee_id from sys_user su where su.user_id= v_created_id),
               SYSDATE,
               p_contract_header_id,
               '');
          end loop;
          
          IF nvl(sys_parameter_pkg.value('CONTRACT_APPROVE_WORKFLOW_ENABLED',
                                         '',
                                         '',
                                         v_company_id),
                 'N') = 'Y' THEN
            --调用工作流流程
            v_instance_id := wfl_core_pkg.workflow_start(p_transaction_category => c_con_contract_hds,
                                                         p_transaction_type_id  => v_contract_type_id,
                                                         p_instance_param       => p_contract_header_id,
                                                         p_user_id              => p_user_id);
          END IF;
      END;
    
    ELSIF p_status = 'CONFIRM' THEN
      BEGIN
        SELECT 1
          INTO v_exists
          FROM dual
         WHERE EXISTS (SELECT *
                  FROM con_contract_headers h
                 WHERE contract_header_id = p_contract_header_id
                   AND h.status IN ('SUBMITTED', 'HOLD'));
      
        UPDATE con_contract_headers h
           SET last_updated_by  = p_user_id,
               last_update_date = SYSDATE,
               h.status         = p_status,
               h.reject_reason  = ''
         WHERE contract_header_id = p_contract_header_id;
      
        insert_con_contract_histories(p_contract_header_id => p_contract_header_id,
                                      p_operation_code     => p_status,
                                      p_user_id            => p_user_id,
                                      p_employee_id        => '',
                                      p_description        => '');
      
      -- 完成时，将通知关掉
      update sys_wlzq_notify_message t
             set t.done_flag = 'Y'
             where t.para_1 = p_contract_header_id
             and t.document_type='CONTRACTS_APPROVE';
      
      EXCEPTION
        WHEN no_data_found THEN
          sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5020_CONFIRM_STATUS_CHECK_ERROR',
                                                          p_created_by              => p_user_id,
                                                          p_package_name            => 'con_contract_maintenance_pkg',
                                                          p_procedure_function_name => 'set_con_contract_header_status');
          raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                  sys_raise_app_error_pkg.g_err_line_id);
      END;
    
    ELSIF p_status = 'REJECTED' THEN
     -- 拒绝时，将通知关掉
     update sys_wlzq_notify_message t
           set t.done_flag = 'Y'
           where t.para_1 = p_contract_header_id
           and t.document_type='CONTRACTS_APPROVE';
             
      BEGIN
        SELECT 1
          INTO v_exists
          FROM dual
         WHERE EXISTS (SELECT *
                  FROM con_contract_headers h
                 WHERE contract_header_id = p_contract_header_id
                   AND h.status = 'SUBMITTED');
      
        UPDATE con_contract_headers h
           SET last_updated_by  = p_user_id,
               last_update_date = SYSDATE,
               h.status         = p_status,
               h.reject_reason  = p_reject_reason --add by Quyuanyuan 拒绝原因
         WHERE contract_header_id = p_contract_header_id;
      
        insert_con_contract_histories(p_contract_header_id => p_contract_header_id,
                                      p_operation_code     => p_status,
                                      p_user_id            => p_user_id,
                                      p_employee_id        => '',
                                      p_description        => p_reject_reason);
      
      EXCEPTION
        WHEN no_data_found THEN
          sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5020_CONFIRM_STATUS_CHECK_ERROR',
                                                          p_created_by              => p_user_id,
                                                          p_package_name            => 'con_contract_maintenance_pkg',
                                                          p_procedure_function_name => 'set_con_contract_header_status');
          raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                  sys_raise_app_error_pkg.g_err_line_id);
      END;
    
    ELSE
      UPDATE con_contract_headers h
         SET last_updated_by  = p_user_id,
             last_update_date = SYSDATE,
             h.status         = p_status,
             h.reject_reason  = ''
       WHERE contract_header_id = p_contract_header_id;
    
      insert_con_contract_histories(p_contract_header_id => p_contract_header_id,
                                    p_operation_code     => p_status,
                                    p_user_id            => p_user_id,
                                    p_employee_id        => '',
                                    p_description        => '');
    END IF;
    /*if p_status in('CONFIRM','REJECTED') then
    \*合同审批插入系统通知*\
    SELECT c.*
      INTO v_con_contract_headers
      FROM con_contract_headers c
     WHERE c.contract_header_id = p_contract_header_id;
  
    SELECT ee.employee_id
      INTO v_employee_id
      FROM sys_user s, exp_employees ee
     WHERE s.employee_id = ee.employee_id
       AND s.user_id = p_user_id;
  
    INSERT INTO sys_wlzq_notify_message
      (message_id,
       document_number,
       document_type,
       message,
       doucument_owner,
       operated_by,
       operated_date,
       para_1)
    VALUES
      (sys_wlzq_notify_message_s.nextval,
       v_con_contract_headers.contract_number,
       'CONTRACTS',
       --'您提交的一笔供应商银行账户信息被' || v_employee_name || '拒绝',
       decode(p_status,'CONFIRM','审批通过','REJECTED',p_reject_reason）,
       v_con_contract_headers.created_by,
       v_employee_id,
       SYSDATE,
       p_contract_header_id);
     end if;*/
  EXCEPTION
    WHEN e_lock_table THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5020_LOCK_TABLE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'set_con_contract_header_status');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'set_con_contract_header_status');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END set_con_contract_header_status;

  --整单删除
  PROCEDURE delete_con_contract_headers(p_contract_header_id NUMBER,
                                        p_user_id            NUMBER) IS
  BEGIN
    delete_contract_status_check(p_contract_header_id, p_user_id);
  
    --删除对应的工作流数据
    wfl_core_pkg.workflow_instance_delete(p_transaction_category => c_con_contract_hds,
                                          p_instance_param       => p_contract_header_id);
  
    DELETE FROM con_contract_headers h
     WHERE h.contract_header_id = p_contract_header_id;
  
    DELETE FROM con_contract_tax t
     WHERE t.contract_header_id = p_contract_header_id;
  
    DELETE FROM con_payment_schedules
     WHERE contract_header_id = p_contract_header_id;
  
    DELETE FROM con_contract_object_lines
     WHERE contract_header_id = p_contract_header_id;
  
    DELETE FROM con_partner_contactors
     WHERE contract_partner_line_id IN
           (SELECT l.contract_partner_line_id
              FROM con_contract_partner_lines l
             WHERE l.contract_header_id = p_contract_header_id);
  
    DELETE FROM con_contract_partner_lines
     WHERE contract_header_id = p_contract_header_id;
  
    DELETE FROM con_contract_terms
     WHERE contract_header_id = p_contract_header_id;
  
    DELETE FROM con_contract_privileges
     WHERE contract_header_id = p_contract_header_id;
  
    DELETE FROM con_contract_histories
     WHERE contract_header_id = p_contract_header_id;
  
    DELETE FROM con_document_flows f
     WHERE f.document_type = 'CON_CONTRACT'
       AND f.document_id = p_contract_header_id;
    fnd_fileupload.delete_all_attachment(p_table_name => 'CON_CONTRACT_HEADERS',
                                         p_pk_value   => p_contract_header_id);
  
    --合同引用授权表 2009.09.08
    con_contract_ref_authority_pkg.del_contract_ref_authority(p_contract_header_id => p_contract_header_id);
  
  END delete_con_contract_headers;

  --税
  PROCEDURE insert_con_contract_tax(p_contract_header_id   NUMBER,
                                    p_tax_type_id          NUMBER,
                                    p_tax_amount           NUMBER,
                                    p_user_id              NUMBER,
                                    p_contract_tax_line_id OUT NUMBER) IS
  BEGIN
    update_contract_status_check(p_contract_header_id => p_contract_header_id,
                                 p_user_id            => p_user_id);
    p_contract_tax_line_id := get_contract_tax_line_id;
    INSERT INTO con_contract_tax
      (contract_header_id,
       tax_type_id,
       tax_amount,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       contract_tax_line_id)
    VALUES
      (p_contract_header_id,
       p_tax_type_id,
       p_tax_amount,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_contract_tax_line_id);
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'insert_con_contract_tax');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_con_contract_tax;

  PROCEDURE update_con_contract_tax(p_contract_header_id   NUMBER,
                                    p_contract_tax_line_id NUMBER,
                                    p_tax_type_id          NUMBER,
                                    p_tax_amount           NUMBER,
                                    p_user_id              NUMBER) IS
  BEGIN
    update_contract_status_check(p_contract_header_id => p_contract_header_id,
                                 p_user_id            => p_user_id);
    UPDATE con_contract_tax
       SET tax_type_id      = p_tax_type_id,
           tax_amount       = p_tax_amount,
           last_updated_by  = p_user_id,
           last_update_date = SYSDATE
     WHERE contract_tax_line_id = p_contract_tax_line_id;
  END update_con_contract_tax;

  PROCEDURE delete_con_contract_tax(p_contract_header_id   NUMBER,
                                    p_contract_tax_line_id NUMBER,
                                    p_user_id              NUMBER) IS
  BEGIN
    delete_contract_status_check(p_contract_header_id, p_user_id);
    DELETE FROM con_contract_tax
     WHERE contract_tax_line_id = p_contract_tax_line_id;
  END delete_con_contract_tax;

  --新建资金计划行
  PROCEDURE insert_con_payment_schedules(p_contract_header_id           NUMBER,
                                         p_payment_schedule_line_number NUMBER,
                                         p_expense_type_id              NUMBER,
                                         p_req_item_id                  NUMBER,
                                         p_amount                       NUMBER,
                                         p_payment_method               VARCHAR2,
                                         p_payment_term_id              NUMBER,
                                         p_partner_category             VARCHAR2,
                                         p_partner_id                   NUMBER,
                                         p_due_date                     DATE,
                                         p_actual_date                  DATE,
                                         p_memo                         VARCHAR2,
                                         p_user_id                      NUMBER,
                                         p_currency_code                VARCHAR2,
                                         p_payment_schedule_line_id     OUT NUMBER,
                                         p_start_date                   DATE DEFAULT NULL) IS
  BEGIN
    update_contract_status_check(p_contract_header_id => p_contract_header_id,
                                 p_user_id            => p_user_id);
    p_payment_schedule_line_id := get_con_payment_schedule_id;
    INSERT INTO con_payment_schedules
      (contract_header_id,
       payment_schedule_line_id,
       payment_schedule_line_number,
       expense_type_id,
       req_item_id,
       amount,
       payment_method,
       payment_term_id,
       partner_category,
       partner_id,
       due_date,
       actual_date,
       memo,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       currency_code,
       start_date)
    VALUES
      (p_contract_header_id,
       p_payment_schedule_line_id,
       p_payment_schedule_line_number,
       p_expense_type_id,
       p_req_item_id,
       p_amount,
       p_payment_method,
       p_payment_term_id,
       p_partner_category,
       p_partner_id,
       p_due_date,
       p_actual_date,
       p_memo,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_currency_code,
       p_start_date);
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'insert_con_payment_schedules');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_con_payment_schedules;

  PROCEDURE update_con_payment_schedules(p_contract_header_id       NUMBER,
                                         p_payment_schedule_line_id NUMBER,
                                         p_expense_type_id          NUMBER,
                                         p_req_item_id              NUMBER,
                                         p_amount                   NUMBER,
                                         p_payment_method           VARCHAR2,
                                         p_payment_term_id          NUMBER,
                                         p_partner_category         VARCHAR2,
                                         p_partner_id               NUMBER,
                                         p_due_date                 DATE,
                                         p_actual_date              DATE,
                                         p_memo                     VARCHAR2,
                                         p_user_id                  NUMBER,
                                         p_currency_code            VARCHAR2,
                                         p_start_date               DATE DEFAULT NULL) IS
  BEGIN
    update_contract_status_check(p_contract_header_id => p_contract_header_id,
                                 p_user_id            => p_user_id);
    UPDATE con_payment_schedules
       SET payment_schedule_line_id = p_payment_schedule_line_id,
           expense_type_id          = p_expense_type_id,
           req_item_id              = p_req_item_id,
           amount                   = p_amount,
           payment_method           = p_payment_method,
           payment_term_id          = p_payment_term_id,
           partner_category         = p_partner_category,
           partner_id               = p_partner_id,
           due_date                 = p_due_date,
           actual_date              = p_actual_date,
           memo                     = p_memo,
           last_updated_by          = p_user_id,
           last_update_date         = SYSDATE,
           currency_code            = p_currency_code,
           start_date               = p_start_date
     WHERE payment_schedule_line_id = p_payment_schedule_line_id;
  END update_con_payment_schedules;

  --删除资金计划行
  PROCEDURE delete_con_payment_schedules(p_contract_header_id       NUMBER,
                                         p_payment_schedule_line_id NUMBER,
                                         p_user_id                  NUMBER) IS
  BEGIN
    delete_contract_status_check(p_contract_header_id, p_user_id);
    DELETE FROM con_payment_schedules
     WHERE payment_schedule_line_id = p_payment_schedule_line_id;
  END delete_con_payment_schedules;

  --新建： 合同交付物
  PROCEDURE insert_contract_object_lines(p_contract_header_id          NUMBER,
                                         p_contract_object_line_number NUMBER,
                                         p_object_type                 VARCHAR2,
                                         p_object_id                   NUMBER,
                                         p_quantity                    NUMBER,
                                         p_amount                      NUMBER,
                                         p_address                     VARCHAR2,
                                         p_due_date                    DATE,
                                         p_actual_date                 DATE,
                                         p_memo                        VARCHAR2,
                                         p_user_id                     NUMBER,
                                         p_contract_object_line_id     OUT NUMBER) IS
  BEGIN
    update_contract_status_check(p_contract_header_id => p_contract_header_id,
                                 p_user_id            => p_user_id);
    p_contract_object_line_id := get_contract_object_line_id;
    INSERT INTO con_contract_object_lines
      (contract_header_id,
       contract_object_line_id,
       contract_object_line_number,
       object_type,
       object_id,
       quantity,
       amount,
       address,
       due_date,
       actual_date,
       memo,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (p_contract_header_id,
       p_contract_object_line_id,
       p_contract_object_line_number,
       p_object_type,
       p_object_id,
       p_quantity,
       p_amount,
       p_address,
       p_due_date,
       p_actual_date,
       p_memo,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE);
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'insert_contract_object_lines');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_contract_object_lines;

  PROCEDURE update_contract_object_lines(p_contract_header_id      NUMBER,
                                         p_contract_object_line_id NUMBER,
                                         p_object_type             VARCHAR2,
                                         p_object_id               NUMBER,
                                         p_quantity                NUMBER,
                                         p_amount                  NUMBER,
                                         p_address                 VARCHAR2,
                                         p_due_date                DATE,
                                         p_actual_date             DATE,
                                         p_memo                    VARCHAR2,
                                         p_user_id                 NUMBER) IS
    v_status VARCHAR2(30);
  BEGIN
    /*update_contract_status_check(p_contract_header_id => p_contract_header_id,
    p_user_id            => p_user_id);*/
    SELECT h.status
      INTO v_status
      FROM con_contract_headers h
     WHERE h.contract_header_id = p_contract_header_id
       FOR UPDATE NOWAIT;
  
    IF v_status IN ('GENERATE', 'REJECTED') THEN
      UPDATE con_contract_object_lines
         SET object_type      = p_object_type,
             object_id        = p_object_id,
             quantity         = p_quantity,
             amount           = p_amount,
             address          = p_address,
             due_date         = p_due_date,
             actual_date      = p_actual_date,
             memo             = p_memo,
             last_updated_by  = p_user_id,
             last_update_date = SYSDATE
       WHERE contract_object_line_id = p_contract_object_line_id;
    ELSIF v_status NOT IN ('CANCEL', 'FINISH') THEN
      UPDATE con_contract_object_lines
         SET actual_date      = p_actual_date,
             last_updated_by  = p_user_id,
             last_update_date = SYSDATE
       WHERE contract_object_line_id = p_contract_object_line_id;
    ELSE
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_UPDATE_STATUS_CHECK_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'update_contract_object_lines');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    END IF;
  
  EXCEPTION
    WHEN e_lock_table THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_LOCK_RECORD_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'update_contract_object_lines');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_contract_object_lines;

  PROCEDURE delete_contract_object_lines(p_contract_header_id      NUMBER,
                                         p_contract_object_line_id NUMBER,
                                         p_user_id                 NUMBER) IS
  BEGIN
    delete_contract_status_check(p_contract_header_id, p_user_id);
    DELETE FROM con_contract_object_lines
     WHERE contract_object_line_id = p_contract_object_line_id;
  END delete_contract_object_lines;

  --新建：合同对象
  PROCEDURE insert_contract_partner_lines(p_contract_header_id       NUMBER,
                                          p_partner_category         VARCHAR2,
                                          p_partner_id               NUMBER,
                                          p_bank_branch_code         VARCHAR2,
                                          p_bank_account_code        VARCHAR2,
                                          p_tax_id_number            VARCHAR2,
                                          p_memo                     VARCHAR2,
                                          p_user_id                  NUMBER,
                                          p_contract_partner_line_id OUT NUMBER) IS
  BEGIN
    update_contract_status_check(p_contract_header_id => p_contract_header_id,
                                 p_user_id            => p_user_id);
    p_contract_partner_line_id := get_contract_partner_line_id;
    INSERT INTO con_contract_partner_lines
      (contract_header_id,
       contract_partner_line_id,
       partner_category,
       partner_id,
       bank_branch_code,
       bank_account_code,
       tax_id_number,
       memo,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (p_contract_header_id,
       p_contract_partner_line_id,
       p_partner_category,
       p_partner_id,
       p_bank_branch_code,
       p_bank_account_code,
       p_tax_id_number,
       p_memo,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE);
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'insert_contract_partner_lines');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_contract_partner_lines;

  PROCEDURE update_contract_partner_lines(p_contract_header_id       NUMBER,
                                          p_contract_partner_line_id NUMBER,
                                          p_partner_category         VARCHAR2,
                                          p_partner_id               NUMBER,
                                          p_bank_branch_code         VARCHAR2,
                                          p_bank_account_code        VARCHAR2,
                                          p_tax_id_number            VARCHAR2,
                                          p_memo                     VARCHAR2,
                                          p_user_id                  NUMBER) IS
  BEGIN
    update_contract_status_check(p_contract_header_id => p_contract_header_id,
                                 p_user_id            => p_user_id);
    UPDATE con_contract_partner_lines
       SET partner_category  = p_partner_category,
           partner_id        = p_partner_id,
           bank_branch_code  = p_bank_branch_code,
           bank_account_code = p_bank_account_code,
           tax_id_number     = p_tax_id_number,
           memo              = p_memo,
           last_updated_by   = p_user_id,
           last_update_date  = SYSDATE
     WHERE contract_partner_line_id = p_contract_partner_line_id;
  END update_contract_partner_lines;

  PROCEDURE delete_contract_partner_lines(p_contract_header_id       NUMBER,
                                          p_contract_partner_line_id NUMBER,
                                          p_user_id                  NUMBER) IS
  
  BEGIN
    delete_contract_status_check(p_contract_header_id, p_user_id);
    DELETE FROM con_contract_partner_lines
     WHERE contract_partner_line_id = p_contract_partner_line_id;
  END delete_contract_partner_lines;

  FUNCTION get_con_head_id_by_con_partner(p_contract_partner_line_id NUMBER)
    RETURN NUMBER IS
    v_contract_header_id NUMBER;
  BEGIN
    SELECT contract_header_id
      INTO v_contract_header_id
      FROM con_contract_partner_lines
     WHERE contract_partner_line_id = p_contract_partner_line_id;
    RETURN v_contract_header_id;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN NULL;
  END get_con_head_id_by_con_partner;

  --新建： 合同联系人
  PROCEDURE inesert_con_partner_contactors(p_contract_partner_line_id NUMBER,
                                           p_contactor_name           VARCHAR2,
                                           p_contactor_position       VARCHAR2,
                                           p_sex                      VARCHAR2,
                                           p_phone_number             VARCHAR2,
                                           p_mobile                   VARCHAR2,
                                           p_fax                      VARCHAR2,
                                           p_email                    VARCHAR2,
                                           p_memo                     VARCHAR2,
                                           p_user_id                  NUMBER,
                                           p_partner_contactors_id    OUT NUMBER) IS
    v_contract_header_id con_contract_partner_lines.contract_header_id%TYPE;
  BEGIN
    v_contract_header_id := get_con_head_id_by_con_partner(p_contract_partner_line_id);
    update_contract_status_check(p_contract_header_id => v_contract_header_id,
                                 p_user_id            => p_user_id);
    p_partner_contactors_id := get_partner_contactors_id;
    INSERT INTO con_partner_contactors
      (contract_partner_line_id,
       partner_contactors_id,
       contactor_name,
       contactor_position,
       sex,
       phone_number,
       mobile,
       fax,
       email,
       memo,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (p_contract_partner_line_id,
       p_partner_contactors_id,
       p_contactor_name,
       p_contactor_position,
       p_sex,
       p_phone_number,
       p_mobile,
       p_fax,
       p_email,
       p_memo,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE);
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'inesert_con_partner_contactors');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END inesert_con_partner_contactors;

  PROCEDURE update_con_partner_contactors(p_contract_partner_line_id NUMBER,
                                          p_partner_contactors_id    NUMBER,
                                          p_contactor_name           VARCHAR2,
                                          p_contactor_position       VARCHAR2,
                                          p_sex                      VARCHAR2,
                                          p_phone_number             VARCHAR2,
                                          p_mobile                   VARCHAR2,
                                          p_fax                      VARCHAR2,
                                          p_email                    VARCHAR2,
                                          p_memo                     VARCHAR2,
                                          p_user_id                  NUMBER) IS
    v_contract_header_id con_contract_partner_lines.contract_header_id%TYPE;
  BEGIN
    v_contract_header_id := get_con_head_id_by_con_partner(p_contract_partner_line_id);
    update_contract_status_check(p_contract_header_id => v_contract_header_id,
                                 p_user_id            => p_user_id);
    UPDATE con_partner_contactors
       SET contactor_name     = p_contactor_name,
           contactor_position = p_contactor_position,
           sex                = p_sex,
           phone_number       = p_phone_number,
           mobile             = p_mobile,
           fax                = p_fax,
           email              = p_email,
           memo               = p_memo,
           last_updated_by    = p_user_id,
           last_update_date   = SYSDATE
     WHERE partner_contactors_id = p_partner_contactors_id;
  END update_con_partner_contactors;

  PROCEDURE delete_con_partner_contactors(p_contract_partner_line_id NUMBER,
                                          p_partner_contactors_id    NUMBER,
                                          p_user_id                  NUMBER) IS
    v_contract_header_id NUMBER;
  BEGIN
    v_contract_header_id := get_con_head_id_by_con_partner(p_contract_partner_line_id);
    delete_contract_status_check(v_contract_header_id, p_user_id);
    DELETE FROM con_partner_contactors
     WHERE partner_contactors_id = p_partner_contactors_id;
  END delete_con_partner_contactors;

  --新建：合同条款
  PROCEDURE insert_con_contract_terms(p_contract_header_id NUMBER,
                                      p_contract_term_type VARCHAR2,
                                      p_contract_term_desc VARCHAR2,
                                      p_user_id            NUMBER,
                                      p_contract_term_id   OUT NUMBER) IS
  BEGIN
    update_contract_status_check(p_contract_header_id => p_contract_header_id,
                                 p_user_id            => p_user_id);
    p_contract_term_id := get_contract_term_id;
    INSERT INTO con_contract_terms
      (contract_header_id,
       contract_term_id,
       contract_term_type,
       contract_term_desc,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (p_contract_header_id,
       p_contract_term_id,
       p_contract_term_type,
       p_contract_term_desc,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE);
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'insert_con_contract_terms');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_con_contract_terms;

  PROCEDURE update_con_contract_terms(p_contract_header_id NUMBER,
                                      p_contract_term_id   NUMBER,
                                      p_contract_term_desc VARCHAR2,
                                      p_user_id            NUMBER) IS
  BEGIN
    update_contract_status_check(p_contract_header_id => p_contract_header_id,
                                 p_user_id            => p_user_id);
    UPDATE con_contract_terms
       SET contract_term_desc = p_contract_term_desc,
           last_updated_by    = p_user_id,
           last_update_date   = SYSDATE
     WHERE contract_term_id = p_contract_term_id;
  END update_con_contract_terms;

  PROCEDURE delete_con_contract_terms(p_contract_header_id NUMBER,
                                      p_contract_term_id   NUMBER,
                                      p_user_id            NUMBER) IS
  BEGIN
    delete_contract_status_check(p_contract_header_id, p_user_id);
  
    DELETE FROM con_contract_terms
     WHERE contract_term_id = p_contract_term_id;
    fnd_fileupload.delete_all_attachment(p_table_name => 'CON_CONTRACT_TERMS',
                                         p_pk_value   => p_contract_term_id);
  END delete_con_contract_terms;

  --0029753: [合同维护]应用中“合同权限”tab页，修改成在合同确认后还可以进行维护
  --合同权限维护时，校验： 已经确认的也能维护
  PROCEDURE upd_con_status_chk_privilege(p_contract_header_id NUMBER,
                                         p_user_id            NUMBER,
                                         p_message_code       VARCHAR2) IS
    v_contract_header_id con_contract_headers.contract_header_id%TYPE;
  BEGIN
    SELECT contract_header_id
      INTO v_contract_header_id
      FROM con_contract_headers h
     WHERE h.contract_header_id = p_contract_header_id
       AND h.status IN ('GENERATE', 'REJECTED', 'CONFIRM')
       FOR UPDATE NOWAIT;
  
  EXCEPTION
    WHEN no_data_found THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => p_message_code, -- 'CON5010_UPDATE_STATUS_CHECK_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'upd_con_status_chk_privilege');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_lock_table THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_LOCK_RECORD_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'upd_con_status_chk_privilege');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  --新建：合同权限
  PROCEDURE insert_con_contract_privileges(p_contract_header_id     NUMBER,
                                           p_position_id            NUMBER,
                                           p_employee_id            NUMBER,
                                           p_contract_privilege     VARCHAR2,
                                           p_user_id                NUMBER,
                                           p_contract_privileges_id OUT NUMBER) IS
  BEGIN
    --0029753: [合同维护]应用中“合同权限”tab页，修改成在合同确认后还可以进行维护
    upd_con_status_chk_privilege(p_contract_header_id => p_contract_header_id,
                                 p_user_id            => p_user_id,
                                 p_message_code       => 'CON5010_UPDATE_STATUS_CHECK_ERROR');
    p_contract_privileges_id := get_contract_privileges_id;
    INSERT INTO con_contract_privileges
      (contract_header_id,
       contract_privileges_id,
       position_id,
       employee_id,
       contract_privilege,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (p_contract_header_id,
       p_contract_privileges_id,
       p_position_id,
       p_employee_id,
       p_contract_privilege,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE);
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'insert_con_contract_privileges');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_con_contract_privileges;

  PROCEDURE update_con_contract_privileges(p_contract_header_id     NUMBER,
                                           p_contract_privileges_id NUMBER,
                                           p_position_id            NUMBER,
                                           p_employee_id            NUMBER,
                                           p_contract_privilege     VARCHAR2,
                                           p_user_id                NUMBER) IS
  BEGIN
    --0029753: [合同维护]应用中“合同权限”tab页，修改成在合同确认后还可以进行维护
    upd_con_status_chk_privilege(p_contract_header_id => p_contract_header_id,
                                 p_user_id            => p_user_id,
                                 p_message_code       => 'CON5010_UPDATE_STATUS_CHECK_ERROR');
    UPDATE con_contract_privileges
       SET position_id        = p_position_id,
           employee_id        = p_employee_id,
           contract_privilege = p_contract_privilege,
           last_updated_by    = p_user_id,
           last_update_date   = SYSDATE
     WHERE contract_privileges_id = p_contract_privileges_id;
  END update_con_contract_privileges;

  PROCEDURE delete_con_contract_privileges(p_contract_header_id     NUMBER,
                                           p_contract_privileges_id NUMBER,
                                           p_user_id                NUMBER) IS
  BEGIN
    --0029753: [合同维护]应用中“合同权限”tab页，修改成在合同确认后还可以进行维护
    upd_con_status_chk_privilege(p_contract_header_id => p_contract_header_id,
                                 p_user_id            => p_user_id,
                                 p_message_code       => 'CON5010_DELETE_STATUS_CHECK_ERROR');
  
    DELETE FROM con_contract_privileges
     WHERE contract_privileges_id = p_contract_privileges_id;
  END delete_con_contract_privileges;

  PROCEDURE upd_con_invoice_status_check(p_contract_header_id NUMBER,
                                         p_user_id            NUMBER) IS
    v_contract_header_id con_contract_headers.contract_header_id%TYPE;
  BEGIN
    SELECT contract_header_id
      INTO v_contract_header_id
      FROM con_contract_headers h
     WHERE h.contract_header_id = p_contract_header_id
       AND h.status NOT IN ('FINISH', 'CANCEL')
       FOR UPDATE NOWAIT;
  
  EXCEPTION
    WHEN no_data_found THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_UPDATE_STATUS_CHECK_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'upd_con_invoice_status_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_lock_table THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_LOCK_RECORD_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'upd_con_invoice_status_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END upd_con_invoice_status_check;

  --合同发票
  PROCEDURE insert_con_invoice_headers(p_contract_header_id  NUMBER,
                                       p_invoice_type        VARCHAR2,
                                       p_invoice_number      VARCHAR2,
                                       p_invoice_amount      NUMBER,
                                       p_invoice_date        DATE,
                                       p_tax_included_flag   VARCHAR2,
                                       p_tax_type_id         NUMBER,
                                       p_tax_amount          NUMBER,
                                       p_payment_method_code VARCHAR2,
                                       p_payment_term_id     NUMBER,
                                       p_partner_category    VARCHAR2,
                                       p_partner_id          NUMBER,
                                       p_memo                VARCHAR2,
                                       p_user_id             NUMBER,
                                       p_company_id          NUMBER,
                                       p_invoice_header_id   OUT NUMBER) IS
  BEGIN
    upd_con_invoice_status_check(p_contract_header_id => p_contract_header_id,
                                 p_user_id            => p_user_id);
    p_invoice_header_id := get_con_invoice_header_id;
    INSERT INTO con_invoice_headers
      (invoice_header_id,
       invoice_type,
       invoice_number,
       invoice_amount,
       invoice_date,
       tax_included_flag,
       tax_type_id,
       tax_amount,
       payment_method_code,
       payment_term_id,
       partner_category,
       partner_id,
       memo,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       company_id)
    VALUES
      (p_invoice_header_id,
       p_invoice_type,
       p_invoice_number,
       p_invoice_amount,
       p_invoice_date,
       p_tax_included_flag,
       p_tax_type_id,
       p_tax_amount,
       p_payment_method_code,
       p_payment_term_id,
       p_partner_category,
       p_partner_id,
       p_memo,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_company_id);
  
    insert_con_document_flows(p_document_type        => 'CON_CONTRACT',
                              p_document_id          => p_contract_header_id,
                              p_source_document_type => 'CON_INVOICE_HEADERS',
                              p_source_document_id   => p_invoice_header_id,
                              p_user_id              => p_user_id);
  EXCEPTION
    WHEN dup_val_on_index THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_INVOICE_NUMBER_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'insert_con_invoice_headers');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'insert_con_invoice_headers');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_con_invoice_headers;

  PROCEDURE update_con_invoice_headers(p_contract_header_id  NUMBER,
                                       p_invoice_header_id   NUMBER,
                                       p_invoice_type        VARCHAR2,
                                       p_invoice_amount      NUMBER,
                                       p_invoice_date        DATE,
                                       p_tax_included_flag   VARCHAR2,
                                       p_tax_type_id         NUMBER,
                                       p_tax_amount          NUMBER,
                                       p_payment_method_code VARCHAR2,
                                       p_payment_term_id     NUMBER,
                                       p_partner_category    VARCHAR2,
                                       p_partner_id          NUMBER,
                                       p_memo                VARCHAR2,
                                       p_user_id             NUMBER) IS
  BEGIN
    upd_con_invoice_status_check(p_contract_header_id => p_contract_header_id,
                                 p_user_id            => p_user_id);
    UPDATE con_invoice_headers
       SET invoice_type        = p_invoice_type,
           invoice_amount      = p_invoice_amount,
           invoice_date        = p_invoice_date,
           tax_included_flag   = p_tax_included_flag,
           tax_type_id         = p_tax_type_id,
           tax_amount          = p_tax_amount,
           payment_method_code = p_payment_method_code,
           payment_term_id     = p_payment_term_id,
           partner_category    = p_partner_category,
           partner_id          = p_partner_id,
           memo                = p_memo,
           last_updated_by     = p_user_id,
           last_update_date    = SYSDATE
     WHERE invoice_header_id = p_invoice_header_id;
  END update_con_invoice_headers;

  PROCEDURE delete_con_invoice_headers(p_contract_header_id NUMBER,
                                       p_invoice_header_id  NUMBER,
                                       p_user_id            NUMBER) IS
  BEGIN
    /*delete_contract_status_check(p_contract_header_id,
    p_user_id);*/
    upd_con_invoice_status_check(p_contract_header_id => p_contract_header_id,
                                 p_user_id            => p_user_id);
    DELETE FROM con_invoice_headers
     WHERE invoice_header_id = p_invoice_header_id;
  END delete_con_invoice_headers;

  FUNCTION get_con_header_id_by_invoice(p_invoice_header_id NUMBER)
    RETURN NUMBER IS
    v_contract_header_id NUMBER;
  BEGIN
    SELECT DISTINCT h.document_id
      INTO v_contract_header_id
      FROM con_document_flows h
     WHERE h.document_type = 'CON_CONTRACT'
       AND h.source_document_type = 'CON_INVOICE_HEADERS'
       AND h.source_document_id = p_invoice_header_id;
    RETURN v_contract_header_id;
  
  EXCEPTION
    WHEN no_data_found THEN
      RETURN NULL;
  END get_con_header_id_by_invoice;

  --发票关联资金计划行
  PROCEDURE inst_con_invoice_pmt_schedules(p_invoice_header_id            NUMBER,
                                           p_payment_schedule_line_id     NUMBER,
                                           p_payment_schedule_line_number NUMBER,
                                           p_amount                       NUMBER,
                                           p_user_id                      NUMBER,
                                           p_invoice_payment_schedule_id  OUT NUMBER) IS
    v_contract_header_id con_contract_headers.contract_header_id%TYPE;
  BEGIN
    v_contract_header_id := get_con_header_id_by_invoice(p_invoice_header_id);
    update_contract_status_check(p_contract_header_id => v_contract_header_id,
                                 p_user_id            => p_user_id);
    p_invoice_payment_schedule_id := get_con_invoice_schedule_id;
    INSERT INTO con_invoice_payment_schedules
      (invoice_header_id,
       payment_schedule_line_id,
       payment_schedule_line_number,
       amount,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       invoice_payment_schedule_id)
    VALUES
      (p_invoice_header_id,
       p_payment_schedule_line_id,
       p_payment_schedule_line_number,
       p_amount,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_invoice_payment_schedule_id);
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'inst_con_invoice_pmt_schedules');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END inst_con_invoice_pmt_schedules;

  PROCEDURE updt_con_invoice_pmt_schedules(p_invoice_header_id           NUMBER,
                                           p_invoice_payment_schedule_id NUMBER,
                                           p_amount                      NUMBER,
                                           p_user_id                     NUMBER) IS
    v_contract_header_id con_contract_headers.contract_header_id%TYPE;
  BEGIN
    v_contract_header_id := get_con_header_id_by_invoice(p_invoice_header_id);
    update_contract_status_check(p_contract_header_id => v_contract_header_id,
                                 p_user_id            => p_user_id);
    UPDATE con_invoice_payment_schedules s
       SET s.last_updated_by  = p_user_id,
           s.last_update_date = SYSDATE,
           s.amount           = p_amount
     WHERE s.invoice_payment_schedule_id = p_invoice_payment_schedule_id;
  
  END updt_con_invoice_pmt_schedules;

  PROCEDURE del_con_invoice_pmt_schedules(p_invoice_header_id        NUMBER,
                                          p_payment_schedule_line_id NUMBER,
                                          p_user_id                  NUMBER) IS
    v_contract_header_id con_contract_headers.contract_header_id%TYPE;
  BEGIN
    v_contract_header_id := get_con_header_id_by_invoice(p_invoice_header_id);
    delete_contract_status_check(v_contract_header_id, p_user_id);
  
    DELETE FROM con_invoice_payment_schedules
     WHERE payment_schedule_line_id = p_payment_schedule_line_id;
  
  END del_con_invoice_pmt_schedules;

  /* --现金事务对应资金计划行
  procedure inst_cash_trx_pmt_schdl_lns(p_csh_transaction_line_id  number,
                                        p_payment_schedule_line_id number,
                                        p_amount                   number,
                                        p_user_id                  number) is
  begin
    insert into con_cash_trx_pmt_schedule_lns
      (csh_transaction_line_id,
       payment_schedule_line_id,
       amount,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    values
      (p_csh_transaction_line_id,
       p_payment_schedule_line_id,
       p_amount,
       p_user_id,
       sysdate,
       p_user_id,
       sysdate);
  
  exception
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'inst_cash_trx_pmt_schdl_lns');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end inst_cash_trx_pmt_schdl_lns;*/

  --合同变更历史
  PROCEDURE insert_con_contract_histories(p_contract_header_id NUMBER,
                                          p_operation_code     VARCHAR2,
                                          p_user_id            NUMBER,
                                          p_employee_id        NUMBER,
                                          p_description        VARCHAR2) IS
  BEGIN
  
    INSERT INTO con_contract_histories
      (contract_header_id,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       operation_code,
       user_id,
       employee_id,
       operation_time,
       description)
    VALUES
      (p_contract_header_id,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_operation_code,
       p_user_id,
       p_employee_id,
       SYSDATE,
       p_description);
  END insert_con_contract_histories;

  --Return [Y]: check success
  --Return [N]: check failure
  FUNCTION default_object_id_check(p_exp_requisition_type_id NUMBER,
                                   p_layout_position         VARCHAR2)
    RETURN VARCHAR2 IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM exp_req_ref_object_types t
     WHERE t.expense_requisition_type_id = p_exp_requisition_type_id
       AND t.default_object_id IS NULL
       AND t.layout_position = p_layout_position;
    IF v_count > 0 THEN
      RETURN 'N';
    ELSE
      RETURN 'Y';
    END IF;
  END default_object_id_check;

  --Delete by bobo 2009.08.25
  /* --生成申请单头
  procedure create_exp_requisition_header(p_contract_header_id        number,
                                          p_exp_requisition_type_id   number,
                                          p_user_id                   number,
                                          p_exp_requisition_header_id out number) is
    cursor cur_con_header is
      select company_id,
             currency_code,
             employee_id,
             partner_category,
             partner_id
        from con_contract_headers h
       where h.contract_header_id = p_contract_header_id;
    v_con_header cur_con_header%rowtype;
  
    v_sysdate                 date := trunc(sysdate);
    v_period_name             varchar2(30);
    v_exchange_rate           number;
    v_exchange_rate_quotation varchar2(30);
    v_exchange_rate_type      varchar2(30);
  
    e_default_object_null exception;
  begin
    open cur_con_header;
    loop
      fetch cur_con_header
        into v_con_header;
      exit when cur_con_header%notfound;
  
      p_exp_requisition_header_id := exp_requisition_pkg.get_exp_req_header_id;
  
      if default_object_id_check(p_exp_requisition_type_id,
                                 'DOCUMENTS_HEAD') = 'N' then
        close cur_con_header;
        raise e_default_object_null;
      else
        insert into exp_requisition_objects
          (expense_requisition_header_id,
           expense_requisition_line_id,
           expense_object_type_id,
           expense_object_id,
           created_by,
           creation_date,
           last_updated_by,
           last_update_date)
          select p_exp_requisition_header_id,
                 '',
                 a.expense_object_type_id,
                 default_object_id,
                 p_user_id,
                 sysdate,
                 p_user_id,
                 sysdate
            from exp_req_ref_object_types a
           where a.expense_requisition_type_id = p_exp_requisition_type_id
             and a.layout_position = 'DOCUMENTS_HEAD';
      end if;
      v_period_name := bgt_common_pkg.get_bgt_period_name(p_company_id => v_con_header.company_id,
                                                          p_date       => v_sysdate);
  
      v_exchange_rate_type := sys_parameter_pkg.value(p_parameter_code => 'DEFAULT_EXCHANGE_RATE_TYPE',
                                                      p_company_id     => v_con_header.company_id);
  
      gld_exchange_rate_pkg.get_exchange_rate(p_company_id              => v_con_header.company_id,
                                              p_from_currency           => gld_common_pkg.get_company_currency_code(v_con_header.company_id),
                                              p_to_currency             => v_con_header.currency_code,
                                              p_exchange_rate_type      => v_exchange_rate_type,
                                              p_exchange_date           => v_sysdate,
                                              p_exchange_period_name    => v_period_name,
                                              p_who_id                  => p_user_id,
                                              p_exchange_rate           => v_exchange_rate,
                                              p_exchange_rate_quotation => v_exchange_rate_quotation);
  
      exp_requisition_pkg.insert_exp_requisition_headers(p_exp_requisition_header_id => p_exp_requisition_header_id,
                                                         p_company_id                => v_con_header.company_id,
                                                         p_exp_requisition_barcode   => '',
                                                         p_employee_id               => v_con_header.employee_id,
                                                         p_payee_category            => v_con_header.partner_category,
                                                         p_payee_id                  => v_con_header.partner_id,
                                                         p_exp_requisition_type_id   => p_exp_requisition_type_id,
                                                         p_currency_code             => v_con_header.currency_code,
                                                         p_exchange_rate_type        => v_exchange_rate_type,
                                                         p_exchange_rate_quotation   => v_exchange_rate_quotation,
                                                         p_exchange_rate             => v_exchange_rate,
                                                         p_requisition_date          => v_sysdate,
                                                         p_period_name               => v_period_name,
                                                         p_requisition_status        => 'GENERATE',
                                                         p_description               => '',
                                                         p_user_id                   => p_user_id,
                                                         p_position_id               => '');
    end loop;
    close cur_con_header;
  
  exception
    when e_default_object_null then
      null;
    when others then
      if cur_con_header%isopen then
        close cur_con_header;
      end if;
  
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end create_exp_requisition_header;
  
  --Return [Y]: check success
  --Return [N]: check failure
  function default_dim_value_id_check(p_exp_requisition_type_id number)
    return varchar2 is
    v_count number;
  begin
    select count(1)
      into v_count
      from exp_req_ref_dimensions t
     where t.expense_requisition_type_id = p_exp_requisition_type_id
       and t.default_dim_value_id is null;
    if v_count > 0 then
      return 'N';
    else
      return 'Y';
    end if;
  end default_dim_value_id_check;
  
  --生成申请单行
  procedure create_exp_requisiton_line(p_exp_requisition_header_id number,
                                       p_payment_schedule_line_id  number,
                                       p_user_id                   number) is
    cursor cur_schedules is
      select s.*,
             h.period_name,
             --h.currency_code,
             h.exchange_rate_type,
             h.exchange_rate_quotation,
             h.exchange_rate,
             h.company_id,
             h.unit_id,
             h.position_id,
             h.employee_id,
             h.exp_requisition_type_id
        from con_payment_schedules   s,
             exp_requisition_headers h,
             con_document_flows      f
       where s.payment_schedule_line_id = p_payment_schedule_line_id
         and h.exp_requisition_header_id = p_exp_requisition_header_id
         and f.document_type = 'CON_CONTRACT'
         and f.document_id = s.contract_header_id
         and f.source_document_type = 'EXP_REQUISITION_HEADERS'
         and f.source_document_id = p_exp_requisition_header_id;
    v_line cur_schedules%rowtype;
  
    v_req_functional_amount    number;
    v_responsibility_center_id number;
    v_exp_requisition_line_id  number;
    v_sql                      varchar2(2000);
  
    e_default_dim_value_null exception;
    e_resp_center_id_null exception;
    e_default_object_null exception;
  begin
    open cur_schedules;
    loop
      fetch cur_schedules
        into v_line;
      exit when cur_schedules%notfound;
      if default_dim_value_id_check(v_line.exp_requisition_type_id) = 'N' then
        close cur_schedules;
        raise e_default_dim_value_null;
      end if;
      v_responsibility_center_id := sys_parameter_pkg.value(p_parameter_code => 'DEFAULT_RESPONSIBILITY_CENTER',
                                                            p_company_id     => v_line.company_id);
  
      if v_responsibility_center_id is null then
        close cur_schedules;
        raise e_resp_center_id_null;
      end if;
  
      exp_requisition_pkg.insert_exp_requisition_lines(p_exp_requisition_header_id => p_exp_requisition_header_id,
                                                       p_line_number               => v_line.payment_schedule_line_number,
                                                       p_city                      => '',
                                                       p_description               => '',
                                                       p_date_from                 => '',
                                                       p_date_to                   => '',
                                                       p_period_name               => v_line.period_name,
                                                       p_currency_code             => v_line.currency_code,
                                                       p_exchange_rate_type        => v_line.exchange_rate_type,
                                                       p_exchange_rate_quotation   => v_line.exchange_rate_quotation,
                                                       p_exchange_rate             => v_line.exchange_rate,
                                                       p_expense_type_id           => v_line.expense_type_id,
                                                       p_exp_req_item_id           => '',
                                                       --p_budget_item_id            => '',
                                                       p_price                    => v_line.amount,
                                                       p_primary_quantity         => 1,
                                                       p_primary_uom              => '',
                                                       p_secondary_quantity       => '',
                                                       p_secondary_uom            => '',
                                                       p_requisition_amount       => v_line.amount,
                                                       p_req_functional_amount    => v_req_functional_amount,
                                                       p_distribution_set_id      => '',
                                                       p_company_id               => v_line.company_id,
                                                       p_unit_id                  => v_line.unit_id,
                                                       p_position_id              => v_line.position_id,
                                                       p_responsibility_center_id => v_responsibility_center_id,
                                                       p_employee_id              => v_line.employee_id,
                                                       p_payee_category           => v_line.partner_category,
                                                       p_payee_id                 => v_line.partner_id,
                                                       p_partner_id               => v_line.partner_id,
                                                       p_payment_flag             => 'N',
                                                       p_requisition_status       => 'GENERATE',
                                                       p_audit_flag               => 'N',
                                                       p_attachment_num           => '',
                                                       p_dimension1_id            => '',
                                                       p_dimension2_id            => '',
                                                       p_dimension3_id            => '',
                                                       p_dimension4_id            => '',
                                                       p_dimension5_id            => '',
                                                       p_dimension6_id            => '',
                                                       p_dimension7_id            => '',
                                                       p_dimension8_id            => '',
                                                       p_dimension9_id            => '',
                                                       p_dimension10_id           => '',
                                                       p_user_id                  => p_user_id,
                                                       p_exp_requisition_line_id  => v_exp_requisition_line_id);
  
      if default_object_id_check(v_line.exp_requisition_type_id,
                                 'DOCUMENTS_LINE') = 'N' then
        close cur_schedules;
        raise e_default_object_null;
      else
        insert into exp_requisition_objects
          (expense_requisition_header_id,
           expense_requisition_line_id,
           expense_object_type_id,
           expense_object_id,
           created_by,
           creation_date,
           last_updated_by,
           last_update_date)
          select p_exp_requisition_header_id,
                 v_exp_requisition_line_id,
                 a.expense_object_type_id,
                 default_object_id,
                 p_user_id,
                 sysdate,
                 p_user_id,
                 sysdate
            from exp_req_ref_object_types a
           where a.expense_requisition_type_id =
                 v_line.exp_requisition_type_id
             and a.layout_position = 'DOCUMENTS_LINE';
      end if;
  
      --设置维值
      v_sql := 'update exp_requisition_lines set last_update_date = ' ||
               sysdate || ',';
      for v_dimension in (select d.dimension_sequence,
                                 t.default_dim_value_id
                            from exp_req_ref_dimensions t,
                                 fnd_dimensions         d
                           where t.expense_requisition_type_id =
                                 v_line.exp_requisition_type_id
                             and t.dimension_id = t.dimension_id) loop
        v_sql := v_sql || ' dimension' || v_dimension.dimension_sequence ||
                 '_id = ' || v_dimension.default_dim_value_id || ',';
      end loop;
      v_sql := v_sql || ' last_updated_by = ' || p_user_id ||
               ' where exp_requisition_line_id = ' ||
               v_exp_requisition_line_id;
      execute immediate v_sql;
  
    end loop;
    close cur_schedules;
  
  exception
    when e_default_object_null then
      null;
    when e_resp_center_id_null then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP5140_RESP_CENTER_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'create_exp_requisiton_line');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    when e_default_dim_value_null then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_DEFAULT_DIM_VALUE_NULL',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'create_exp_requisiton_line');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'create_exp_requisiton_line');
  
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end create_exp_requisiton_line;
  
  --重新设置申请单行号
  procedure post_create_exp_requisition(p_exp_requisition_header_id number,
                                        p_user_id                   number) is
  begin
    exp_requisition_pkg.resert_exp_req_line_number(p_exp_requisition_header_id => p_exp_requisition_header_id,
                                                   p_user_id                   => p_user_id);
  end post_create_exp_requisition;*/

  /*  --资金计划生成 申请单
  procedure con_pmt_schedules_to_exp_req(p_contract_header_id       number,
                                         p_payment_schedule_line_id number,
                                         p_exp_requisition_type_id  number,
                                         p_user_id                  number) is
  begin
    null;
  
  end con_pmt_schedules_to_exp_req;*/

  FUNCTION exist_con_authorities(p_contract_header_id NUMBER,
                                 p_employee_id        NUMBER,
                                 p_authority          VARCHAR2 DEFAULT 'MODIFY',
                                 p_user_id            NUMBER) RETURN VARCHAR2 IS
  
    v_exists_flag VARCHAR2(1) := 'N';
  BEGIN
    /*if (p_granted_employee_id = p_employee_id) then
      return 'Y';
    end if;*/
    BEGIN
      SELECT 'Y'
        INTO v_exists_flag
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM con_contract_privileges a
               WHERE a.contract_header_id = p_contract_header_id
                 AND a.employee_id = p_employee_id
                 AND (a.contract_privilege = p_authority OR
                     (a.contract_privilege = 'MODIFY' AND
                     p_authority = 'QUERY')));
    EXCEPTION
      WHEN no_data_found THEN
        v_exists_flag := 'N';
    END;
    RETURN v_exists_flag;
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'exist_con_authorities');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END exist_con_authorities;

  FUNCTION onexist_con_authorities(p_contract_header_id NUMBER,
                                   p_employee_id        NUMBER,
                                   p_user_id            NUMBER)
    RETURN VARCHAR2 IS
  
    v_onexist_flag VARCHAR2(1) := 'N';
  BEGIN
    BEGIN
      SELECT 'Y'
        INTO v_onexist_flag
        FROM dual
       WHERE EXISTS (SELECT 1
                FROM con_contract_privileges a
               WHERE a.contract_header_id = p_contract_header_id
                 AND a.employee_id = p_employee_id);
    EXCEPTION
      WHEN no_data_found THEN
        v_onexist_flag := 'N';
    END;
    RETURN v_onexist_flag;
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'con_contract_maintenance_pkg',
                                                     p_procedure_function_name => 'onexist_con_authorities');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END onexist_con_authorities;

  --2010.07.28 by bobo
  --校验单据是否关联合同， Y 关联，N未关联
  PROCEDURE contract_schedule_check(p_source_document_type VARCHAR2,
                                    p_source_document_id   NUMBER) IS
    v_con_number VARCHAR2(30);
  BEGIN
    SELECT h.contract_number
      INTO v_con_number
      FROM con_document_flows t, con_contract_headers h
     WHERE t.document_type = c_con_contract_hds
       AND t.source_document_type = p_source_document_type
       AND t.source_document_id = p_source_document_id
       AND h.contract_header_id = t.document_id
       AND t.document_line_id IS NULL
       AND rownum = 1;
    sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'CON5010_CON_PMT_SCHEDULE_NULL',
                                                    p_created_by              => -1,
                                                    p_token_1                 => '#CON_NUM',
                                                    p_token_value_1           => v_con_number,
                                                    p_package_name            => 'con_contract_maintenance_pkg',
                                                    p_procedure_function_name => 'contract_schedule_check');
    raise_application_error(sys_raise_app_error_pkg.c_error_number,
                            sys_raise_app_error_pkg.g_err_line_id);
  EXCEPTION
    WHEN no_data_found THEN
      NULL;
  END;

  PROCEDURE wfl_update_document_check(p_workflow_id NUMBER,
                                      p_user_id     NUMBER) IS
    v_exists NUMBER;
  BEGIN
    SELECT 1
      INTO v_exists
      FROM wfl_workflow w
     WHERE w.workflow_id = p_workflow_id
       AND w.workflow_category = c_con_contract_hds;
  EXCEPTION
    WHEN no_data_found THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'WFL_WORKFLOW_UPDATE_DOCUMENT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'con_contract_maintenance_pkg',
                                                      p_procedure_function_name => 'wfl_update_document_check');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  --工作流运行完毕后，设置状态
  PROCEDURE update_post_workflow(p_wfl_instance_id NUMBER,
                                 p_wfl_status      NUMBER,
                                 p_user_id         NUMBER) IS
    r_instance wfl_workflow_instance%ROWTYPE;
  BEGIN
    SELECT *
      INTO r_instance
      FROM wfl_workflow_instance
     WHERE instance_id = p_wfl_instance_id;
  
    --单据类型匹配校验
    wfl_update_document_check(p_workflow_id => r_instance.workflow_id,
                              p_user_id     => p_user_id);
  
    --审批通过
    IF p_wfl_status = wfl_core_pkg.c_workflow_finished THEN
    
      UPDATE con_contract_headers h
         SET last_updated_by  = p_user_id,
             last_update_date = SYSDATE,
             h.status         = 'CONFIRM'
       WHERE contract_header_id = r_instance.instance_param;
    END IF;
  
    --审批拒绝
    IF p_wfl_status = wfl_core_pkg.c_workflow_terminated THEN
    
      UPDATE con_contract_headers h
         SET last_updated_by  = p_user_id,
             last_update_date = SYSDATE,
             h.status         = 'REJECTED'
       WHERE contract_header_id = r_instance.instance_param;
    END IF;
  
    --收回
    IF p_wfl_status = wfl_core_pkg.c_workflow_canceled THEN
    
      UPDATE con_contract_headers h
         SET last_updated_by  = p_user_id,
             last_update_date = SYSDATE,
             h.status         = 'GENERATE'
       WHERE contract_header_id = r_instance.instance_param;
    END IF;
  END;
  PROCEDURE insert_con_contracr_vender(p_partner_id                 NUMBER,
                                     p_company_id               NUMBER,
                                     p_user_id                  NUMBER) IS
    v_pur_system_venders pur_system_venders%ROWTYPE;
    v_count              NUMBER;
    v_unit_id            NUMBER;
  BEGIN
    SELECT *
      INTO v_pur_system_venders
      FROM pur_system_venders p
     WHERE p.vender_id = p_partner_id;
  
    SELECT COUNT(1)
      INTO v_count
      FROM pur_company_venders pv
     WHERE pv.vender_id = v_pur_system_venders.vender_id
       AND pv.company_id = p_company_id;
    IF (v_count = 0) THEN
      pur_system_venders_pkg.assign_pur_company_venders(p_company_id           => p_company_id,
                                                        p_vender_id            => p_partner_id,
                                                        p_payment_term_id      => v_pur_system_venders.payment_term_id,
                                                        p_payment_method       => v_pur_system_venders.payment_method,
                                                        p_currency_code        => v_pur_system_venders.currency_code,
                                                        p_tax_type_id          => v_pur_system_venders.tax_type_id,
                                                        p_approved_vender_flag => v_pur_system_venders.approved_vender_flag,
                                                        p_enabled_flag         => v_pur_system_venders.enabled_flag,
                                                        p_created_by           => v_pur_system_venders.created_by);
    END IF;
    --added by lyh  2017.7.19
    --合同维护的供应商，在保存后，如果合同维护表没有，则插入
  
    SELECT eu.unit_id
      INTO v_unit_id
      FROM exp_employee_assigns sa,
           exp_org_unit_vl      eu,
           exp_org_position_vl  ep,
           sys_user             su,
           exp_employees        ee
     WHERE sa.employee_id = ee.employee_id
       AND sa.company_id = p_company_id
       AND sa.primary_position_flag = 'Y'
       AND eu.unit_id = ep.unit_id
       AND sa.position_id = ep.position_id
       AND ee.employee_id = su.employee_id
       AND su.user_id = p_user_id;
       
     SELECT COUNT(1)
       INTO v_count
       FROM pur_wlzq_venders pv
      WHERE pv.vender_code = v_pur_system_venders.vender_code
        AND pv.unit_id = v_unit_id;
    IF (v_count = 0) THEN
      --INSERT INTO pur_wlzq ;
      INSERT INTO pur_wlzq_venders
        (vender_id,
         vender_code,
         vender_type_id,
         description_id,
         address,
         artificial_person,
         tax_id_number,
         bank_branch_code,
         bank_account_code,
         payment_term_id,
         payment_method,
         currency_code,
         tax_type_id,
         tax_number,
         approved_vender_flag,
         enabled_flag,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date,
         company_id,
         unit_id)
      VALUES
        (pur_wlzq_venders_s.nextval,
         v_pur_system_venders.vender_code,
         v_pur_system_venders.vender_type_id,
         v_pur_system_venders.description_id,
         v_pur_system_venders.address,
         v_pur_system_venders.artificial_person,
         v_pur_system_venders.tax_id_number,
         v_pur_system_venders.bank_branch_code,
         v_pur_system_venders.bank_account_code,
         v_pur_system_venders.payment_term_id,
         v_pur_system_venders.payment_method,
         v_pur_system_venders.currency_code,
         v_pur_system_venders.tax_type_id,
         v_pur_system_venders.tax_id_number,
         v_pur_system_venders.approved_vender_flag,
         v_pur_system_venders.enabled_flag,
         p_user_id,
         SYSDATE,
         p_user_id,
         SYSDATE,
         p_company_id,
         v_unit_id);
    END IF;
  END;
PROCEDURE CHECK_CONTRACT_NUMBER(p_contract_header_id VARCHAR2,
                                p_message            out varchar2) IS
  v_contract_id varchar2(100);
  v_number      NUMBER;
  v_exception exception;
BEGIN
  --获取当前合同的OA合同编号
  select cc.contract_id
    into v_contract_id
    from con_contract_headers cc
   where cc.contract_header_id = p_contract_header_id;
  --在合同表中查询，看是否已经被关联（合同状态不是新建、取消、拒绝的）
  select count(1)
    into v_number
    from con_contract_headers h
   where h.contract_id = v_contract_id
     and h.status not in ('GENERATE', 'CANCEL', 'REJECTED');
  if v_number > 0 then
    raise v_exception;
  end if;
EXCEPTION
  WHEN v_exception THEN
    p_message := '系统存在已关联同一OA合同编号的合同,是否继续提交？';
END CHECK_CONTRACT_NUMBER;
PROCEDURE GET_CONTRACT_ID(p_contract_code VARCHAR2,
                          p_contract_id   out number,
                          p_message       out varchar2) IS
BEGIN
  --获取当前合同的OA合同编号的ID
  select cc.contract_id
    into p_contract_id
    from con_contract_oa cc
   where cc.contract_code = p_contract_code;
EXCEPTION
  WHEN no_data_found THEN
    p_message := '您输入的OA合同编号有误，请检查！';
END GET_CONTRACT_ID;



--#########################################
  -- 发送通知
  --#########################################
  FUNCTION generate_sys_notify(p_event_id    NUMBER,
                                   p_log_id      NUMBER,
                                   p_event_param NUMBER,
                                   p_created_by  NUMBER) RETURN NUMBER IS
                                   
                                   v_employee_id NUMBER;
  BEGIN
    for c1 in (
        select cch.contract_number , cps.payment_schedule_line_number ,cch.created_by,cps.due_date,
        cps.payment_schedule_line_id,
        cps.contract_header_id
        from con_contract_headers cch,CON_PAYMENT_SCHEDULES cps
        where cch.status = 'CONFIRM'
        and cch.contract_header_id = cps.contract_header_id
        and not exists(
            select 1
            from con_document_flows cdf,exp_report_pmt_schedules erps
             where cdf.source_document_id = erps.exp_report_header_id
                   AND cdf.source_document_line_id =
                       erps.payment_schedule_line_id 
                       and cdf.source_document_type = 'EXP_REPORT_PMT_SCHEDULES'
                       and cdf.document_id = cps.contract_header_id
                       and cdf.document_type = 'CON_CONTRACT'
                       and cdf.document_id = cps.payment_schedule_line_id
        )
        and trunc(cps.due_date) <= trunc(sysdate)
        --todo 没有发通知
        and not exists(
            select 1
            from sys_wlzq_notify_message sw
            where sw.para_2 = cps.payment_schedule_line_id
            and  sw.document_type = 'CONTRACTS_SCHEDULES'
        )
    )loop
          SELECT ee.employee_id
      INTO v_employee_id
      FROM sys_user s, exp_employees ee
     WHERE s.employee_id = ee.employee_id
       AND s.user_id = c1.created_by;
  
    INSERT INTO sys_wlzq_notify_message
      (message_id,
       document_number,
       document_type,
       message,
       doucument_owner,
       operated_by,
       operated_date,
       para_1,
       para_2)
    VALUES
      (sys_wlzq_notify_message_s.nextval,
       c1.contract_number,
       'CONTRACTS_SCHEDULES',
       '合同编号[' || c1.contract_number ||  ']计划付款日期[' || to_char(c1.due_date,'yyyy-mm-dd') || ']已到期,需要创建报销单支付!',
       c1.created_by,
       v_employee_id,
       SYSDATE,
       c1.contract_header_id,
       c1.payment_schedule_line_id);
    end loop;
    RETURN evt_event_core_pkg.c_return_normal;
  END;




END con_contract_maintenance_pkg;
/
