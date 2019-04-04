CREATE OR REPLACE PACKAGE cux_coa_pkg IS

  -- Author  : MOUSE
  -- Created : 2015/11/11 13:44:11
  -- Purpose : coa段值pkg

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/11 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取现金流量项
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 现金流量项
  **************************************************/
  FUNCTION get_cash_flow_item(p_rule_type VARCHAR2, p_je_line_id VARCHAR2)
    RETURN VARCHAR2;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015年11月19日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取明细段，SEGMENT4
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 明细段
  **************************************************/
  FUNCTION get_detail(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015年11月19日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取关联单位段，SEGMENT5
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 关联单位段
  **************************************************/
  FUNCTION get_related(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015年11月19日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取产品段，SEGMENT6
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 产品段
  **************************************************/
  FUNCTION get_product(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015年11月19日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取渠道段，SEGMENT7
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 渠道段
  **************************************************/
  /*************************************************
  -- Author  : Qu yuanyuan
  -- Created : 2015/12/21 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取成本中心,SEGMENT2
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 成本中心
  **************************************************/
  FUNCTION get_resp_center(p_rule_type VARCHAR2, p_je_line_id VARCHAR2)
    RETURN VARCHAR2;
  FUNCTION get_channel(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2;
  /*************************************************
  -- Author  : Qu yuanyuan
  -- Created : 2015年12月29日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取3个备用段，SEGMENT8,segment10,segment11
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 渠道段
  **************************************************/
  FUNCTION get_fut(p_rule_type VARCHAR2, p_je_line_id NUMBER) RETURN VARCHAR2;
  FUNCTION get_fut1(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2;
  FUNCTION get_fut2(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2;

  /*************************************************
  -- Author  : pqs
  -- Created : 2018年09月14日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取核算科目段，SEGMENT3
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 核算科目段
  **************************************************/
  FUNCTION get_account_subject(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2;

  /*************************************************
  -- Author  : pqs
  -- Created : 2018年09月14日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取银行账号段，SEGMENT3
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 银行账号段
  **************************************************/
  function get_bank_account(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2;

  /*************************************************
  -- Author  : pqs
  -- Created : 2018年09月14日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取基金中心段，SEGMENT12
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 基金中心段
  **************************************************/
  function get_funding_center(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/11 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取现金流量项,SEGMENT7
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 现金流量项
  **************************************************/
  FUNCTION get_cash_flow_item_gr(p_rule_type  VARCHAR2,
                                 p_je_line_id VARCHAR2) RETURN VARCHAR2;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/11 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取险类,SEGMENT9
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 险类
  **************************************************/
  function get_insurance_code(p_rule_type VARCHAR2, p_je_line_id VARCHAR2)
    RETURN VARCHAR2;

  /*************************************************
  -- Author  : pqs
  -- Created : 2018/09/19 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取公司段,SEGMENT1
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 公司段
  **************************************************/
  function get_company_code(p_rule_type VARCHAR2, p_je_line_id VARCHAR2)
    RETURN VARCHAR2;

  /*************************************************
  -- Author  : pqs
  -- Created : 2018/09/19 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取成本中心段,SEGMENT2
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 成本中心段
  **************************************************/
  function get_cost_center(p_rule_type VARCHAR2, p_je_line_id VARCHAR2)
    return varchar2;

  /*************************************************
  -- Author  : pqs
  -- Created : 2018/09/19 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取客商辅助段,SEGMENT15
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 获取客商辅助段
  **************************************************/
  function get_travel_trader_code(p_rule_type  VARCHAR2,
                                  p_je_line_id VARCHAR2) return varchar2;

  /*************************************************
  -- Author  : pqs
  -- Created : 2018/09/19 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取承诺项目段,SEGMENT4
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 获取承诺项目段
  **************************************************/
  function get_commitment_item(p_rule_type VARCHAR2, p_je_line_id VARCHAR2)
    return varchar2;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/11 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取险种段,SEGMENT8
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 获取险种段
  **************************************************/
  function get_insurance_code1(p_rule_type VARCHAR2, p_je_line_id VARCHAR2)
    RETURN VARCHAR2;

  /*************************************************
  -- Author  : pqs
  -- Created : 2018.11.18
  -- Ver     : 1.1
  -- Purpose : 获取渠道段，SEGMENT4
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 渠道段
  **************************************************/
  FUNCTION get_channel_segment4(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2;
END cux_coa_pkg;
/
CREATE OR REPLACE PACKAGE BODY cux_coa_pkg IS

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/11 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取现金流量项,SEGMENT9
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 现金流量项
  **************************************************/
  FUNCTION get_cash_flow_item(p_rule_type VARCHAR2, p_je_line_id VARCHAR2)
    RETURN VARCHAR2 IS
    v_usage_code                  VARCHAR2(200);
    v_line_id                     NUMBER;
    v_header_id                   NUMBER;
    v_page_type                   VARCHAR2(30);
    v_cash_flow_item              VARCHAR2(200) := 0;
    v_write_off_type              VARCHAR2(200);
    v_write_off_id                NUMBER;
    v_pmt_line_id                 NUMBER;
    v_pay_req_line_id             NUMBER;
    v_trans_line_id               NUMBER;
    v_current_trans_header        csh_transaction_headers%ROWTYPE;
    v_reverse_source_trans_header csh_transaction_headers%ROWTYPE;
    v_return_source_trans_header  csh_transaction_headers%ROWTYPE;
    v_source_trans_header         csh_transaction_headers%ROWTYPE;
    v_returned_flag               VARCHAR2(30) := 'N';
    v_source_trans_line_id        NUMBER;
    v_work_order_line_id          NUMBER;
    v_work_order_type_id          NUMBER;
    v_cash_flow_ref_field_seq     NUMBER;
  BEGIN
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_exp_report THEN
      --报销单业务类别
      SELECT usage_code, a.payment_schedule_line_id, a.exp_report_header_id
        INTO v_usage_code, v_line_id, v_header_id
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      SELECT t.document_page_type
        INTO v_page_type
        FROM exp_report_headers h, exp_expense_report_types t
       WHERE h.exp_report_type_id = t.expense_report_type_id
         AND h.exp_report_header_id = v_header_id;
    
      --报销单清算行
      IF v_usage_code = 'EMPLOYEE_EXPENSE_CLEARING' AND
         v_page_type = 'COLLECTION' THEN
        SELECT i.cash_flow_line_number
          INTO v_cash_flow_item
          FROM exp_report_pmt_schedules s, csh_cash_flow_items i
         WHERE s.payment_schedule_line_id = v_line_id
           AND s.cash_flow_code = i.cash_flow_item_id;
      END IF;
    ELSIF p_rule_type = gl_account_segment_pkg.g_rule_type_csh_transaction THEN
    
      SELECT usage_code, a.transaction_line_id
        INTO v_usage_code, v_trans_line_id
        FROM csh_transaction_accounts a
       WHERE a.transaction_je_line_id = p_je_line_id;
    
      --现金科目行
      IF v_usage_code = 'CASH_ACCOUNT' THEN
      
        SELECT h.*
          INTO v_current_trans_header
          FROM csh_transaction_headers h, csh_transaction_lines l
         WHERE h.transaction_header_id = l.transaction_header_id
           AND l.transaction_line_id = v_trans_line_id;
      
        IF nvl(v_current_trans_header.reversed_flag, 'N') != 'R' AND
           v_current_trans_header.returned_flag != 'R' THEN
          v_source_trans_header := v_current_trans_header;
        END IF;
      
        --如果当前事务是退款事务，则找到原事务
        IF v_current_trans_header.returned_flag = 'R' THEN
          v_returned_flag := 'Y';
          SELECT *
            INTO v_source_trans_header
            FROM csh_transaction_headers h
           WHERE h.transaction_header_id =
                 v_current_trans_header.source_header_id;
        END IF;
      
        --如果当前事务是反冲事务，则找到原事务
        IF nvl(v_current_trans_header.reversed_flag, 'N') = 'R' THEN
          SELECT *
            INTO v_reverse_source_trans_header
            FROM csh_transaction_headers h
           WHERE h.transaction_header_id =
                 v_current_trans_header.source_header_id;
        
          --取原事务的退款状态，来判断是否退款
          IF v_reverse_source_trans_header.returned_flag = 'R' THEN
            v_returned_flag := 'Y';
          
            SELECT *
              INTO v_source_trans_header
              FROM csh_transaction_headers h
             WHERE h.transaction_header_id =
                   v_reverse_source_trans_header.source_header_id;
          ELSE
            v_source_trans_header := v_reverse_source_trans_header;
          END IF;
        END IF;
      
        SELECT l.transaction_line_id
          INTO v_source_trans_line_id
          FROM csh_transaction_lines l
         WHERE l.transaction_header_id =
               v_source_trans_header.transaction_header_id;
      
        SELECT fi.cash_flow_line_number
          INTO v_cash_flow_item
          FROM (SELECT s.cash_flow_code
                  FROM csh_write_off wo, exp_report_pmt_schedules s
                 WHERE wo.write_off_type = 'PAYMENT_EXPENSE_REPORT'
                   AND wo.document_line_id = s.payment_schedule_line_id
                   AND wo.csh_transaction_line_id = v_source_trans_line_id
                UNION ALL
                SELECT l.cash_flow_code
                  FROM csh_write_off                wo,
                       csh_payment_requisition_refs r,
                       csh_payment_requisition_lns  l
                 WHERE wo.csh_transaction_line_id = v_source_trans_line_id
                   AND wo.write_off_type = 'PAYMENT_PREPAYMENT'
                   AND wo.write_off_id = r.write_off_id
                   AND r.payment_requisition_line_id =
                       l.payment_requisition_line_id) vv,
               csh_cash_flow_items fi
         WHERE fi.cash_flow_item_id = vv.cash_flow_code
           AND rownum = 1;
      
      END IF;
    ELSIF p_rule_type = gl_account_segment_pkg.g_rule_type_work_order THEN
      SELECT h.work_order_type_id, a.work_order_line_id
        INTO v_work_order_type_id, v_work_order_line_id
        FROM gld_work_order_accounts a, gld_work_order_headers h
       WHERE a.work_order_je_line_id = p_je_line_id
         AND a.work_order_header_id = h.work_order_header_id;
      BEGIN
        SELECT rf.field_sequence
          INTO v_cash_flow_ref_field_seq
          FROM gld_sob_wo_type_ref_fields    f,
               gld_sob_work_order_ref_fields rf
         WHERE f.work_order_type_id = v_work_order_type_id
           AND f.field_id = rf.field_id
           AND rf.segment_code = 'SEGMENT9';
      
        EXECUTE IMMEDIATE 'select reference' || v_cash_flow_ref_field_seq ||
                          '_code from gld_work_order_lines l where l.work_order_line_id = ' ||
                          v_work_order_line_id
          INTO v_cash_flow_item;
      
      EXCEPTION
        WHEN no_data_found THEN
          NULL;
      END;
    END IF;
  
    RETURN v_cash_flow_item;
  EXCEPTION
    WHEN OTHERS THEN
      gl_log_pkg.log(p_log_text => SQLERRM || chr(10) ||
                                   dbms_utility.format_error_backtrace,
                     p_user_id  => -1);
    
      raise_application_error(-20000,
                              SQLERRM || chr(10) ||
                              dbms_utility.format_error_backtrace);
  END get_cash_flow_item;

  /*************************************************
  -- Author  : Qu yuanyuan
  -- Created : 2015/12/21 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取成本中心,SEGMENT2
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 成本中心
  **************************************************/
  FUNCTION get_resp_center(p_rule_type VARCHAR2, p_je_line_id VARCHAR2)
    RETURN VARCHAR2 IS
    v_usage_code       VARCHAR2(200);
    v_line_id          NUMBER;
    v_header_id        NUMBER;
    v_resp_center_code VARCHAR2(200) := 0;
    v_account_code     gld_accounts.account_code%TYPE;
  BEGIN
    --报销单：如果是费用行，并且行上的科目为6开头，成本中心取code_v,否则取0;
    --其他单据取code_v
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_exp_report THEN
      --报销单业务类别
      SELECT usage_code, a.payment_schedule_line_id, a.exp_report_header_id
        INTO v_usage_code, v_line_id, v_header_id
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      --报销单费用行
      IF v_usage_code = 'EMPLOYEE_EXPENSE' THEN
        SELECT a.account_code
          INTO v_account_code
          FROM exp_report_accounts ea, gld_accounts a
         WHERE a.account_id = ea.account_id
           AND a.account_set_id =
               (SELECT b.set_of_books_id
                  FROM fnd_companies b
                 WHERE b.company_id = ea.company_id)
           AND ea.exp_report_je_line_id = p_je_line_id;
        IF substr(v_account_code, 0, 1) = '6' OR
           v_account_code IN
           ('2221100201', '2221100202', '2221100203', '2221100204') THEN
          SELECT v.responsibility_center_code
            INTO v_resp_center_code
            FROM exp_report_accounts_code_v v
           WHERE v.exp_report_je_line_id = p_je_line_id;
        ELSE
          v_resp_center_code := 0;
        END IF;
      ELSE
        SELECT v.responsibility_center_code
          INTO v_resp_center_code
          FROM exp_report_accounts_code_v v
         WHERE v.exp_report_je_line_id = p_je_line_id;
      END IF;
      --现金事务
    ELSIF p_rule_type = gl_account_segment_pkg.g_rule_type_csh_transaction THEN
      SELECT t.responsibility_center_code
        INTO v_resp_center_code
        FROM csh_transaction_acc_code_v t
       WHERE t.transaction_je_line_id = p_je_line_id;
      --现金事务核销
    ELSIF p_rule_type = gl_account_segment_pkg.g_rule_type_csh_write_off THEN
      SELECT t.responsibility_center_code
        INTO v_resp_center_code
        FROM csh_write_off_accounts_code_v t
       WHERE t.write_off_je_line_id = p_je_line_id;
      --借款申请
    ELSIF p_rule_type = gl_account_segment_pkg.g_rule_type_csh_pmt_req THEN
      SELECT f.responsibility_center_code
        INTO v_resp_center_code
        FROM csh_payment_req_accounts a, fnd_responsibility_centers f
       WHERE a.je_line_id = p_je_line_id
         AND a.responsibility_center_id = f.responsibility_center_id;
    
      --核算工单
    ELSIF p_rule_type = gl_account_segment_pkg.g_rule_type_work_order THEN
      SELECT a.responsibility_center_code
        INTO v_resp_center_code
        FROM gld_work_order_accounts_code_v a
       WHERE a.work_order_je_line_id = p_je_line_id;
    
    END IF;
  
    RETURN v_resp_center_code;
  EXCEPTION
    WHEN OTHERS THEN
      gl_log_pkg.log(p_log_text => SQLERRM || chr(10) ||
                                   dbms_utility.format_error_backtrace,
                     p_user_id  => -1);
    
      raise_application_error(-20000,
                              SQLERRM || chr(10) ||
                              dbms_utility.format_error_backtrace);
  END get_resp_center;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015年11月19日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取明细段，SEGMENT4
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 明细段
  **************************************************/
  FUNCTION get_detail(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2 IS
    v_usage_code                  VARCHAR2(30);
    v_rep_header_id               NUMBER;
    v_rep_dist_id                 NUMBER;
    v_rep_pmt_id                  NUMBER;
    v_detail                      VARCHAR2(200) := '0';
    v_page_type                   VARCHAR2(30);
    v_trans_line_id               NUMBER;
    v_current_trans_header        csh_transaction_headers%ROWTYPE;
    v_reverse_source_trans_header csh_transaction_headers%ROWTYPE;
    v_return_source_trans_header  csh_transaction_headers%ROWTYPE;
    v_source_trans_header         csh_transaction_headers%ROWTYPE;
    v_returned_flag               VARCHAR2(30) := 'N';
    v_doc_company_code            VARCHAR2(200);
    v_pay_company_code            VARCHAR2(200);
    v_source_trans_line_id        NUMBER;
    v_write_off_type              VARCHAR2(30);
    v_bank_account_id             NUMBER;
    v_work_order_line_id          NUMBER;
    v_work_order_type_id          NUMBER;
    v_detail_ref_field_seq        NUMBER;
    v_sql                         VARCHAR2(3000);
    v_sequence                    NUMBER;
    v_account_code                VARCHAR2(30);
  BEGIN
    --明细段规则：
    --往来凭证:C加取对方公司代码  
    --报销单托收计付行:托收银行账户的银行代码
    --支付凭证现金行:付款账户的银行代码 
    --工单凭证:取SEGMENT4对应的关联字段对应的CODE
  
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_exp_report THEN
      v_detail := '0';
      /* SELECT a.usage_code,
             a.exp_report_dists_id,
             a.payment_schedule_line_id,
             a.exp_report_header_id
        INTO v_usage_code, v_rep_dist_id, v_rep_pmt_id, v_rep_header_id
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
      
      --如果当前用途代码为：费用内部往来-应收，取行上公司的C+公司代码
      IF v_usage_code = 'INTERCOMPANY_AR' THEN
        SELECT 'C' || (SELECT fc.company_code
                         FROM fnd_companies fc
                        WHERE fc.company_id = l.company_id)
          INTO v_detail
          FROM exp_report_lines l, exp_report_dists d
         WHERE l.exp_report_line_id = d.exp_report_line_id
           AND d.exp_report_dists_id = v_rep_dist_id;
      ELSIF v_usage_code = 'INTERCOMPANY_AP' THEN
        --如果当前用途代码为：费用内部往来-应付，取头上公司的C+公司代码
        SELECT 'C' || (SELECT fc.company_code
                         FROM fnd_companies fc
                        WHERE fc.company_id = h.company_id)
          INTO v_detail
          FROM exp_report_headers h
         WHERE h.exp_report_header_id = v_rep_header_id;
      ELSIF v_usage_code = 'EMPLOYEE_EXPENSE_CLEARING' THEN
        --如果当前用途代码为:费用清算，单据类型对应的页面类型为:托收，取对应托收账户的银行账户代码
        SELECT t.document_page_type
          INTO v_page_type
          FROM exp_report_headers h, exp_expense_report_types t
         WHERE h.exp_report_header_id = v_rep_header_id
           AND h.exp_report_type_id = t.expense_report_type_id;
      
        IF v_page_type = 'COLLECTION' THEN
          SELECT a.bank_account_code
            INTO v_detail
            FROM exp_report_pmt_schedules s, csh_bank_accounts a
           WHERE s.payment_schedule_line_id = v_rep_pmt_id
             AND s.collection_account_id = a.bank_account_id;
        END IF;
      END IF;*/
    
    ELSIF p_rule_type = gl_account_segment_pkg.g_rule_type_csh_transaction THEN
      SELECT a.usage_code, a.transaction_line_id, a.account_code
        INTO v_usage_code, v_trans_line_id, v_account_code
        FROM csh_transaction_acc_code_v a
       WHERE a.transaction_je_line_id = p_je_line_id;
      --add by lyh
      --内部往来-代收代付科目 无需搭配明细段，明细段取默认值即可
      IF (v_account_code <> '3003030100') THEN
        --如果当前用途代码为内部往来应收\应付
        IF v_usage_code IN ('CSH_INTERCOMPANY_AP', 'CSH_INTERCOMPANY_AR') THEN
        
          SELECT h.*
            INTO v_current_trans_header
            FROM csh_transaction_headers h, csh_transaction_lines l
           WHERE h.transaction_header_id = l.transaction_header_id
             AND l.transaction_line_id = v_trans_line_id;
        
          IF nvl(v_current_trans_header.reversed_flag, 'N') != 'R' AND
             v_current_trans_header.returned_flag != 'R' THEN
            v_source_trans_header := v_current_trans_header;
          END IF;
        
          --如果当前事务是退款事务，则找到原事务
          IF v_current_trans_header.returned_flag = 'R' THEN
            v_returned_flag := 'Y';
            SELECT *
              INTO v_source_trans_header
              FROM csh_transaction_headers h
             WHERE h.transaction_header_id =
                   v_current_trans_header.source_header_id;
          END IF;
        
          --如果当前事务是反冲事务，则找到原事务
          IF nvl(v_current_trans_header.reversed_flag, 'N') = 'R' THEN
            SELECT *
              INTO v_reverse_source_trans_header
              FROM csh_transaction_headers h
             WHERE h.transaction_header_id =
                   v_current_trans_header.source_header_id;
          
            --取原事务的退款状态，来判断是否退款
            IF v_reverse_source_trans_header.returned_flag = 'R' THEN
              v_returned_flag := 'Y';
            
              SELECT *
                INTO v_source_trans_header
                FROM csh_transaction_headers h
               WHERE h.transaction_header_id =
                     v_reverse_source_trans_header.source_header_id;
            ELSE
              v_source_trans_header := v_reverse_source_trans_header;
            END IF;
          END IF;
        
          SELECT l.transaction_line_id
            INTO v_source_trans_line_id
            FROM csh_transaction_lines l
           WHERE l.transaction_header_id =
                 v_source_trans_header.transaction_header_id;
        
          SELECT 'C' || fc.company_code
            INTO v_doc_company_code
            FROM (SELECT h.company_id
                    FROM csh_write_off wo, exp_report_headers h
                   WHERE wo.write_off_type = 'PAYMENT_EXPENSE_REPORT'
                     AND wo.document_header_id = h.exp_report_header_id
                     AND wo.csh_transaction_line_id = v_source_trans_line_id
                  UNION ALL
                  SELECT h.company_id
                    FROM csh_write_off                wo,
                         csh_payment_requisition_refs r,
                         csh_payment_requisition_lns  l,
                         csh_payment_requisition_hds  h
                   WHERE wo.csh_transaction_line_id = v_source_trans_line_id
                     AND wo.write_off_type = 'PAYMENT_PREPAYMENT'
                     AND wo.write_off_id = r.write_off_id
                     AND r.payment_requisition_line_id =
                         l.payment_requisition_line_id
                     AND l.payment_requisition_header_id =
                         h.payment_requisition_header_id) vv,
                 fnd_companies fc
           WHERE fc.company_id = vv.company_id
             AND rownum = 1;
        
          SELECT 'C' || fc.company_code
            INTO v_pay_company_code
            FROM fnd_companies fc
           WHERE fc.company_id = v_source_trans_header.company_id;
        
          IF v_usage_code = 'CSH_INTERCOMPANY_AP' THEN
            --AP取C+现金事务头公司
            v_detail := v_pay_company_code;
          ELSIF v_usage_code = 'CSH_INTERCOMPANY_AR' THEN
            --AR取C+单据头公司
            v_detail := v_doc_company_code;
          END IF;
        ELSIF v_usage_code = 'CASH_ACCOUNT' THEN
          SELECT l.bank_account_id
            INTO v_bank_account_id
            FROM csh_transaction_lines l
           WHERE l.transaction_line_id = v_trans_line_id;
        
          SELECT a.bank_account_code
            INTO v_detail
            FROM csh_bank_accounts a
           WHERE a.bank_account_id = v_bank_account_id;
        END IF;
      END IF;
    ELSIF p_rule_type = gl_account_segment_pkg.g_rule_type_work_order THEN
      SELECT h.work_order_type_id, a.work_order_line_id
        INTO v_work_order_type_id, v_work_order_line_id
        FROM gld_work_order_accounts a, gld_work_order_headers h
       WHERE a.work_order_je_line_id = p_je_line_id
         AND a.work_order_header_id = h.work_order_header_id;
      BEGIN
        -- 核算工单
        SELECT d.dimension_sequence
          INTO v_sequence
          FROM fnd_dimensions d
         WHERE d.dimension_code = 'DETAIL';
      
        v_sql := 'SELECT dv.dimension_value_code
          FROM fnd_dimension_values_vl dv, gld_work_order_lines gwol
         WHERE dv.dimension_value_id = gwol.dimension' ||
                 v_sequence || '_id
           AND gwol.work_order_line_id = ' ||
                 v_work_order_line_id;
      
        EXECUTE IMMEDIATE v_sql
          INTO v_detail;
      
        /*SELECT rf.field_sequence
          INTO v_detail_ref_field_seq
          FROM gld_sob_wo_type_ref_fields    f,
               gld_sob_work_order_ref_fields rf
         WHERE f.work_order_type_id = v_work_order_type_id
           AND f.field_id = rf.field_id
           AND rf.segment_code = 'SEGMENT4';
        
        EXECUTE IMMEDIATE 'select reference' || v_detail_ref_field_seq ||
                          '_code from gld_work_order_lines l where l.work_order_line_id = ' ||
                          v_work_order_line_id
          INTO v_detail;*/
      
      EXCEPTION
        WHEN no_data_found THEN
          NULL;
      END;
    END IF;
  
    IF (v_detail IS NULL) THEN
      v_detail := '0';
    END IF;
  
    RETURN v_detail;
  EXCEPTION
    WHEN OTHERS THEN
      gl_log_pkg.log(p_log_text => SQLERRM || chr(10) ||
                                   dbms_utility.format_error_backtrace,
                     p_user_id  => -1);
    
      raise_application_error(-20000,
                              SQLERRM || chr(10) ||
                              dbms_utility.format_error_backtrace);
  END get_detail;

  /*************************************************
  -- Author  : Qu yuanyuan
  -- Created : 2015年12月29日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取备用段，SEGMENT8
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 备用段
  **************************************************/
  FUNCTION get_fut(p_rule_type VARCHAR2, p_je_line_id NUMBER) RETURN VARCHAR2 IS
    v_fut                VARCHAR2(200) := '0';
    v_work_order_line_id NUMBER;
  BEGIN
    --备用段规则：
    --工单凭证:取工单行reference3对应的CODE
    --其他凭证:取0
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_work_order THEN
      SELECT a.work_order_line_id
        INTO v_work_order_line_id
        FROM gld_work_order_accounts a, gld_work_order_headers h
       WHERE a.work_order_je_line_id = p_je_line_id
         AND a.work_order_header_id = h.work_order_header_id;
      BEGIN
        SELECT reference3_code
          INTO v_fut
          FROM gld_work_order_lines l
         WHERE l.work_order_line_id = v_work_order_line_id;
      
      EXCEPTION
        WHEN no_data_found THEN
          NULL;
      END;
    END IF;
  
    RETURN v_fut;
  EXCEPTION
    WHEN OTHERS THEN
      gl_log_pkg.log(p_log_text => SQLERRM || chr(10) ||
                                   dbms_utility.format_error_backtrace,
                     p_user_id  => -1);
    
      raise_application_error(-20000,
                              SQLERRM || chr(10) ||
                              dbms_utility.format_error_backtrace);
  END get_fut;
  /*************************************************
  -- Author  : Qu yuanyuan
  -- Created : 2015年12月29日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取备用段1，SEGMENT10
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 备用段1
  **************************************************/
  FUNCTION get_fut1(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2 IS
    v_fut                VARCHAR2(200) := '0';
    v_work_order_line_id NUMBER;
  BEGIN
    --备用段1规则：
    --工单凭证:取工单行reference4对应的CODE
    --其他凭证:取0
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_work_order THEN
      SELECT a.work_order_line_id
        INTO v_work_order_line_id
        FROM gld_work_order_accounts a, gld_work_order_headers h
       WHERE a.work_order_je_line_id = p_je_line_id
         AND a.work_order_header_id = h.work_order_header_id;
      BEGIN
        SELECT reference4_code
          INTO v_fut
          FROM gld_work_order_lines l
         WHERE l.work_order_line_id = v_work_order_line_id;
      
      EXCEPTION
        WHEN no_data_found THEN
          NULL;
      END;
    END IF;
  
    RETURN v_fut;
  EXCEPTION
    WHEN OTHERS THEN
      gl_log_pkg.log(p_log_text => SQLERRM || chr(10) ||
                                   dbms_utility.format_error_backtrace,
                     p_user_id  => -1);
    
      raise_application_error(-20000,
                              SQLERRM || chr(10) ||
                              dbms_utility.format_error_backtrace);
  END get_fut1;
  /*************************************************
  -- Author  : Qu yuanyuan
  -- Created : 2015年12月29日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取备用段，SEGMENT11
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 备用段2
  **************************************************/
  FUNCTION get_fut2(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2 IS
    v_fut                VARCHAR2(200) := '0';
    v_work_order_line_id NUMBER;
  BEGIN
    --备用段2规则：
    --工单凭证:取工单行reference5对应的CODE
    --其他凭证:取0
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_work_order THEN
      SELECT a.work_order_line_id
        INTO v_work_order_line_id
        FROM gld_work_order_accounts a, gld_work_order_headers h
       WHERE a.work_order_je_line_id = p_je_line_id
         AND a.work_order_header_id = h.work_order_header_id;
      BEGIN
        SELECT reference5_code
          INTO v_fut
          FROM gld_work_order_lines l
         WHERE l.work_order_line_id = v_work_order_line_id;
      
      EXCEPTION
        WHEN no_data_found THEN
          NULL;
      END;
    END IF;
  
    RETURN v_fut;
  EXCEPTION
    WHEN OTHERS THEN
      gl_log_pkg.log(p_log_text => SQLERRM || chr(10) ||
                                   dbms_utility.format_error_backtrace,
                     p_user_id  => -1);
    
      raise_application_error(-20000,
                              SQLERRM || chr(10) ||
                              dbms_utility.format_error_backtrace);
  END get_fut2;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015年11月19日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取关联单位段，SEGMENT5
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 关联单位段
  **************************************************/
  FUNCTION get_related(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2 IS
    v_usage_code         VARCHAR2(30);
    v_related            VARCHAR2(200) := '0';
    v_pmt_line_id        NUMBER;
    v_pay_req_line_id    NUMBER;
    v_work_order_line_id NUMBER;
    v_related_code       VARCHAR2(200) := '0';
  BEGIN
  
    --目前未使用，默认取0
    RETURN '0';
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_exp_report THEN
      SELECT usage_code, a.payment_schedule_line_id
        INTO v_usage_code, v_pmt_line_id
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
      IF v_usage_code = 'EMPLOYEE_EXPENSE_CLEARING' THEN
        SELECT CASE s.payee_category
                 WHEN 'VENDER' THEN
                  (SELECT v.vender_code
                     FROM pur_system_venders v
                    WHERE v.vender_id = s.payee_id)
                 WHEN 'EMPLOYEE' THEN
                  (SELECT ee.employee_code
                     FROM exp_employees ee
                    WHERE ee.employee_id = s.payee_id)
               END
          INTO v_related_code
          FROM exp_report_pmt_schedules s
         WHERE s.payment_schedule_line_id = v_pmt_line_id;
      END IF;
    
    ELSIF p_rule_type = gl_account_segment_pkg.g_rule_type_work_order THEN
      SELECT a.work_order_line_id
        INTO v_work_order_line_id
        FROM gld_work_order_accounts a, gld_work_order_headers h
       WHERE a.work_order_je_line_id = p_je_line_id
         AND a.work_order_header_id = h.work_order_header_id;
      BEGIN
        SELECT f.dimension_value_code
          INTO v_related_code
          FROM gld_work_order_lines    l,
               fnd_dimension_values_vl f,
               fnd_dimensions_vl       b
         WHERE l.work_order_line_id = v_work_order_line_id
           AND f.dimension_id = b.dimension_id
           AND b.dimension_code = 'RELATED'
           AND l.dimension4_id = f.dimension_value_id;
      
      EXCEPTION
        WHEN no_data_found THEN
          NULL;
      END;
    
    ELSIF p_rule_type = gl_account_segment_pkg.g_rule_type_csh_pmt_req THEN
      SELECT usage_code, a.payment_req_line_id
        INTO v_usage_code, v_pay_req_line_id
        FROM csh_payment_req_accounts a
       WHERE a.je_line_id = p_je_line_id;
    
      IF v_usage_code = 'PAYMENT_REQUISITION_CLEARING' THEN
        SELECT CASE l.partner_category
                 WHEN 'VENDER' THEN
                  (SELECT v.vender_code
                     FROM pur_system_venders v
                    WHERE v.vender_id = l.partner_id)
                 WHEN 'EMPLOYEE' THEN
                  (SELECT ee.employee_code
                     FROM exp_employees ee
                    WHERE ee.employee_id = l.partner_id)
               END
          INTO v_related_code
          FROM csh_payment_requisition_lns l
         WHERE l.payment_requisition_line_id = v_pay_req_line_id;
      
      END IF;
    END IF;
    --return v_related_code;
  EXCEPTION
    WHEN OTHERS THEN
      gl_log_pkg.log(p_log_text => SQLERRM || chr(10) ||
                                   dbms_utility.format_error_backtrace,
                     p_user_id  => -1);
    
      raise_application_error(-20000,
                              SQLERRM || chr(10) ||
                              dbms_utility.format_error_backtrace);
  END get_related;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015年11月19日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取产品段，SEGMENT6
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 产品段
  **************************************************/
  FUNCTION get_product(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2 IS
    v_usage_code         VARCHAR2(30);
    v_dist_id            NUMBER;
    v_work_order_line_id NUMBER;
    v_product_code       VARCHAR2(200) := '0';
    v_account_id         NUMBER;
    v_account_code       VARCHAR2(300);
  BEGIN
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_exp_report THEN
      SELECT usage_code, exp_report_dists_id, a.account_id
        INTO v_usage_code, v_dist_id, v_account_id
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      SELECT t.account_code
        INTO v_account_code
        FROM gld_accounts_vl t
       WHERE t.account_id = v_account_id;
      IF v_usage_code = 'EMPLOYEE_EXPENSE' OR v_account_code = '2221100204' THEN
        SELECT v.dimension2_code
          INTO v_product_code
          FROM exp_report_lines_code_v v, exp_report_dists d
         WHERE v.exp_report_line_id = d.exp_report_line_id
           AND d.exp_report_dists_id = v_dist_id;
      END IF;
    END IF;
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_work_order THEN
      SELECT a.work_order_line_id
        INTO v_work_order_line_id
        FROM gld_work_order_accounts a, gld_work_order_headers h
       WHERE a.work_order_je_line_id = p_je_line_id
         AND a.work_order_header_id = h.work_order_header_id;
      BEGIN
        SELECT f.dimension_value_code
          INTO v_product_code
          FROM gld_work_order_lines    l,
               fnd_dimension_values_vl f,
               fnd_dimensions_vl       b
         WHERE l.work_order_line_id = v_work_order_line_id
           AND f.dimension_id = b.dimension_id
           AND b.dimension_code = 'PRODUCT'
           AND l.dimension2_id = f.dimension_value_id;
      
      EXCEPTION
        WHEN no_data_found THEN
          NULL;
      END;
    END IF;
    RETURN v_product_code;
  EXCEPTION
    WHEN OTHERS THEN
      gl_log_pkg.log(p_log_text => SQLERRM || chr(10) ||
                                   dbms_utility.format_error_backtrace,
                     p_user_id  => -1);
    
      raise_application_error(-20000,
                              SQLERRM || chr(10) ||
                              dbms_utility.format_error_backtrace);
  END get_product;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015年11月19日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取业务来源段，SEGMENT7
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 业务来源段
  **************************************************/
  FUNCTION get_channel(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2 IS
    v_usage_code      VARCHAR2(30);
    v_dist_id         NUMBER;
    v_channel_code    VARCHAR2(200) := 'null';
    v_report_accounts exp_report_accounts%rowtype;
    v_report_lines    exp_report_lines%rowtype;
  BEGIN
    return 'null';
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_exp_report THEN
      SELECT usage_code, exp_report_dists_id
        INTO v_usage_code, v_dist_id
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      SELECT a.*
        INTO v_report_accounts
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      --报销单费用行
      IF v_usage_code = 'EMPLOYEE_EXPENSE' THEN
        select e.*
          into v_report_lines
          from exp_report_lines e
         where e.exp_report_line_id =
               (select d.exp_report_line_id
                  from exp_report_dists d
                 where d.exp_report_dists_id = v_dist_id);
      
        --取值报销行上业务来源
        --if v_report_lines.sale_amount = v_report_accounts.entered_amount_dr then
        SELECT decode(v.dimension7_code,
                      '0',
                      'null',
                      '',
                      'null',
                      v.dimension7_code)
          INTO v_channel_code
          FROM exp_report_lines_code_v v, exp_report_dists d
         WHERE v.exp_report_line_id = d.exp_report_line_id
           AND d.exp_report_dists_id = v_dist_id;
      else
        v_channel_code := 'null';
        /*end if;*/
      end if;
    else
      v_channel_code := 'null';
    end if;
    RETURN v_channel_code;
  EXCEPTION
    WHEN OTHERS THEN
      gl_log_pkg.log(p_log_text => SQLERRM || chr(10) ||
                                   dbms_utility.format_error_backtrace,
                     p_user_id  => -1);
    
      raise_application_error(-20000,
                              SQLERRM || chr(10) ||
                              dbms_utility.format_error_backtrace);
  END get_channel;

  /*************************************************
  -- Author  : pqs
  -- Created : 2018年09月14日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取核算科目段，SEGMENT3
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 核算科目段
  **************************************************/
  FUNCTION get_account_subject(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2 IS
    v_usage_code           VARCHAR2(30);
    v_account_subject_code VARCHAR2(200) := 'NULL';
    v_line_id              number;
    v_trans_line_id        number;
    v_account_id           number;
    v_write_off_id         number;
    v_account_code         varchar2(100);
  begin
  
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_exp_report THEN
      --报销单业务类别
      SELECT usage_code
        INTO v_usage_code
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      --报销单费用行
      IF v_usage_code = 'EMPLOYEE_EXPENSE' THEN
      
        SELECT a.account_code
          INTO v_account_subject_code
          FROM exp_report_accounts ea, gld_accounts a
         WHERE a.account_id = ea.account_id
           AND ea.exp_report_je_line_id = p_je_line_id;
      
      elsif v_usage_code in ('INTERCOMPANY_AP', 'INTERCOMPANY_AR') then
        v_account_subject_code := '1161010000';
        --增值税
      elsif v_usage_code = 'EMPLOYEE_EXPENSE_TAX' then
        SELECT a.account_code
          INTO v_account_subject_code
          FROM exp_report_accounts ea, gld_accounts a
         WHERE a.account_id = ea.account_id
           AND ea.exp_report_je_line_id = p_je_line_id;
        --进项转出
      elsif v_usage_code = 'EMPLOYEE_EXPENSE_ROLL_OUT' then
        SELECT a.account_code
          INTO v_account_subject_code
          FROM exp_report_accounts ea, gld_accounts a
         WHERE a.account_id = ea.account_id
           AND ea.exp_report_je_line_id = p_je_line_id;
      else
        SELECT a.account_code
          INTO v_account_subject_code
          FROM exp_report_accounts ea, gld_accounts a
         WHERE a.account_id = ea.account_id
           AND ea.exp_report_je_line_id = p_je_line_id;
      end if;
    
      --借款申请
    ELSIF p_rule_type = gl_account_segment_pkg.g_rule_type_csh_pmt_req THEN
      SELECT a.usage_code,
             a.payment_req_line_id,
             a.account_id,
             g.account_code
        into v_usage_code, v_line_id, v_account_id, v_account_code
        FROM csh_payment_req_accounts a, gld_accounts g
       WHERE a.je_line_id = p_je_line_id
         and a.account_id = g.account_id;
    
      if v_usage_code = 'PAYMENT_REQUISITION' then
        v_account_subject_code := v_account_code;
      elsif v_usage_code = 'PAYMENT_REQUISITION_CLEARING' then
        v_account_subject_code := v_account_code;
      else
        v_account_subject_code := 'NULL';
      end if;
      --现金事务核销
    elsif p_rule_type = gl_account_segment_pkg.g_rule_type_csh_write_off then
      SELECT t.usage_code, t.write_off_id, t.account_code
        INTO v_usage_code, v_write_off_id, v_account_code
        FROM csh_write_off_accounts_code_v t
       WHERE t.write_off_je_line_id = p_je_line_id;
    
      if v_usage_code = 'EMPLOYEE_EXPENSE_WRITE_OFF' then
        v_account_subject_code := v_account_code;
      elsif v_usage_code = 'PREPAYMENT_WRITE_OFF' then
        v_account_subject_code := v_account_code;
      end if;
    
      --现金事物凭证
    elsif p_rule_type = gl_account_segment_pkg.g_rule_type_csh_transaction THEN
      SELECT usage_code, a.transaction_line_id, a.account_id
        INTO v_usage_code, v_trans_line_id, v_account_id
        FROM csh_transaction_accounts a
       WHERE a.transaction_je_line_id = p_je_line_id;
    
      --报销单现金事物
      if v_usage_code = 'EMPLOYEE_EXPENSE_WRITE_OFF' then
        select g.account_code
          into v_account_subject_code
          from gld_accounts g
         where g.account_id = v_account_id;
      
        --借款现金事物   
      elsif v_usage_code = 'PREPAYMENT' then
        select g.account_code
          into v_account_subject_code
          from gld_accounts g
         where g.account_id = v_account_id;
      
      elsif v_usage_code = 'CSH_INTERCOMPANY_AP' then
        v_account_subject_code := '1161010000'; --现金内部往来应付科目
      elsif v_usage_code = 'CSH_INTERCOMPANY_AR' then
        v_account_subject_code := '1161010000'; --现金内部往来应付科目  
        --银行           
      elsif v_usage_code = 'CASH_ACCOUNT' then
        SELECT (select g.account_code
                  from gld_accounts g
                 where g.account_id = t.cash_account_id)
          into v_account_subject_code
          FROM csh_bank_accounts t, csh_transaction_lines l
         WHERE t.bank_account_id = l.bank_account_id
           AND l.transaction_line_id = v_trans_line_id;
      end if;
    else
      v_account_subject_code := 'NULL';
    end if;
    return v_account_subject_code;
  end get_account_subject;

  /*************************************************
  -- Author  : pqs
  -- Created : 2018年09月14日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取银行账号段，SEGMENT6
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 银行账号段
  **************************************************/
  function get_bank_account(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2 IS
    v_usage_code        VARCHAR2(30);
    v_bank_account_code VARCHAR2(200) := 'NULL';
    v_trans_line_id     NUMBER;
    v_bank_account_id   number;
  begin
    --支付凭证取银存科目
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_csh_transaction THEN
      SELECT a.usage_code, a.transaction_line_id
        INTO v_usage_code, v_trans_line_id
        FROM csh_transaction_acc_code_v a
       WHERE a.transaction_je_line_id = p_je_line_id;
    
      --报销
      if v_usage_code = 'EMPLOYEE_EXPENSE_WRITE_OFF' then
        v_bank_account_code := 'NULL';
      
        --借款
      elsif v_usage_code = 'PREPAYMENT' then
        v_bank_account_code := 'NULL';
        --银行           
      elsif v_usage_code = 'CASH_ACCOUNT' then
        SELECT t.bank_account_num
          into v_bank_account_code
          FROM csh_bank_accounts t, csh_transaction_lines l
         WHERE t.bank_account_id = l.bank_account_id
           AND l.transaction_line_id = v_trans_line_id;
      end if;
    end if;
    return v_bank_account_code;
  end get_bank_account;

  /*************************************************
  -- Author  : pqs
  -- Created : 2018年09月14日09:39:19
  -- Ver     : 1.1
  -- Purpose : 获取基金中心段，SEGMENT12
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 基金中心段
  **************************************************/
  function get_funding_center(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2 IS
    v_usage_code          VARCHAR2(30);
    v_dist_id             NUMBER;
    v_funding_center_code VARCHAR2(200) := 'NULL';
    v_report_lines        exp_report_lines%rowtype;
    v_report_accounts     exp_report_accounts%rowtype;
  begin
    --费用凭证
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_exp_report THEN
      SELECT usage_code, exp_report_dists_id
        INTO v_usage_code, v_dist_id
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      SELECT a.*
        INTO v_report_accounts
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      --报销单费用行
      IF v_usage_code = 'EMPLOYEE_EXPENSE' THEN
        /*select e.*
            into v_report_lines
            from exp_report_lines e
           where e.exp_report_line_id =
                 (select d.exp_report_line_id
                    from exp_report_dists d
                   where d.exp_report_dists_id = v_dist_id);
        */
        --取值报销行上预算部门字段 
        --if v_report_lines.sale_amount = v_report_accounts.entered_amount_dr then
        SELECT v.unit_code
          INTO v_funding_center_code
          FROM exp_report_lines_code_v v, exp_report_dists d
         WHERE v.exp_report_line_id = d.exp_report_line_id
           AND d.exp_report_dists_id = v_dist_id;
      else
        v_funding_center_code := 'NULL';
      end if;
      --end if;
    else
      v_funding_center_code := 'NULL';
    end if;
    RETURN v_funding_center_code;
  end get_funding_center;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/11 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取现金流量项,SEGMENT7
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 现金流量项
  **************************************************/
  FUNCTION get_cash_flow_item_gr(p_rule_type  VARCHAR2,
                                 p_je_line_id VARCHAR2) RETURN VARCHAR2 IS
    v_usage_code                  VARCHAR2(30);
    v_cash_flow_item_code         VARCHAR2(200) := 'NULL';
    v_trans_line_id               NUMBER;
    v_source_trans_line_id        number;
    v_bank_account_id             number;
    v_current_trans_header        csh_transaction_headers%rowtype;
    v_source_trans_header         csh_transaction_headers%rowtype;
    v_reverse_source_trans_header csh_transaction_headers%rowtype;
    v_returned_flag               varchar2(10);
  begin
    --支付凭证取银存科目
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_csh_transaction THEN
      SELECT usage_code, a.transaction_line_id
        INTO v_usage_code, v_trans_line_id
        FROM csh_transaction_accounts a
       WHERE a.transaction_je_line_id = p_je_line_id;
    
      --现金科目行
      IF v_usage_code = 'CASH_ACCOUNT' THEN
      
        SELECT h.*
          INTO v_current_trans_header
          FROM csh_transaction_headers h, csh_transaction_lines l
         WHERE h.transaction_header_id = l.transaction_header_id
           AND l.transaction_line_id = v_trans_line_id;
      
        IF nvl(v_current_trans_header.reversed_flag, 'N') != 'R' AND
           v_current_trans_header.returned_flag != 'R' THEN
          v_source_trans_header := v_current_trans_header;
        END IF;
      
        --如果当前事务是退款事务，则找到原事务
        IF v_current_trans_header.returned_flag = 'R' THEN
          v_returned_flag := 'Y';
          SELECT *
            INTO v_source_trans_header
            FROM csh_transaction_headers h
           WHERE h.transaction_header_id =
                 v_current_trans_header.source_header_id;
        END IF;
      
        --如果当前事务是反冲事务，则找到原事务
        IF nvl(v_current_trans_header.reversed_flag, 'N') = 'R' THEN
          SELECT *
            INTO v_reverse_source_trans_header
            FROM csh_transaction_headers h
           WHERE h.transaction_header_id =
                 v_current_trans_header.source_header_id;
        
          --取原事务的退款状态，来判断是否退款
          IF v_reverse_source_trans_header.returned_flag = 'R' THEN
            v_returned_flag := 'Y';
          
            SELECT *
              INTO v_source_trans_header
              FROM csh_transaction_headers h
             WHERE h.transaction_header_id =
                   v_reverse_source_trans_header.source_header_id;
          ELSE
            v_source_trans_header := v_reverse_source_trans_header;
          END IF;
        END IF;
      
        SELECT l.transaction_line_id
          INTO v_source_trans_line_id
          FROM csh_transaction_lines l
         WHERE l.transaction_header_id =
               v_source_trans_header.transaction_header_id;
      
        SELECT fi.cash_flow_line_number
          INTO v_cash_flow_item_code
          FROM (SELECT s.cash_flow_code
                  FROM csh_write_off wo, exp_report_pmt_schedules s
                 WHERE wo.write_off_type = 'PAYMENT_EXPENSE_REPORT'
                   AND wo.document_line_id = s.payment_schedule_line_id
                   AND wo.csh_transaction_line_id = v_source_trans_line_id
                   and rownum = 1
                UNION ALL
                SELECT l.cash_flow_code
                  FROM csh_write_off                wo,
                       csh_payment_requisition_refs r,
                       csh_payment_requisition_lns  l
                 WHERE wo.csh_transaction_line_id = v_source_trans_line_id
                   AND wo.write_off_type = 'PAYMENT_PREPAYMENT'
                   AND wo.write_off_id = r.write_off_id
                   AND r.payment_requisition_line_id =
                       l.payment_requisition_line_id) vv,
               csh_cash_flow_items fi
         WHERE fi.cash_flow_item_id = vv.cash_flow_code
           AND rownum = 1;
      
        --转换现金流量项代码
        select t.csh_cash_flow_items_code
          into v_cash_flow_item_code
          from CSH_CASH_FLOW_ITEMS t
         where t.cash_flow_line_number = v_cash_flow_item_code;
      else
        v_cash_flow_item_code := 'NULL';
      END IF;
    else
      v_cash_flow_item_code := 'NULL';
    end if;
    return v_cash_flow_item_code;
  end get_cash_flow_item_gr;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/11 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取险类,SEGMENT9
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 险类
  **************************************************/
  function get_insurance_code(p_rule_type VARCHAR2, p_je_line_id VARCHAR2)
    RETURN VARCHAR2 IS
    v_usage_code      VARCHAR2(30);
    v_dist_id         NUMBER;
    v_report_lines    exp_report_lines%rowtype;
    v_report_accounts exp_report_accounts%rowtype;
    v_insurance_code  VARCHAR2(200) := 'NULL';
  begin
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_exp_report THEN
    
      SELECT usage_code, exp_report_dists_id
        INTO v_usage_code, v_dist_id
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      SELECT a.*
        INTO v_report_accounts
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      --报销单费用行
      IF v_usage_code = 'EMPLOYEE_EXPENSE' THEN
        select e.*
          into v_report_lines
          from exp_report_lines e
         where e.exp_report_line_id =
               (select d.exp_report_line_id
                  from exp_report_dists d
                 where d.exp_report_dists_id = v_dist_id);
      
        --取值报销行上险类字段 
        --if v_report_lines.sale_amount = v_report_accounts.entered_amount_dr then
        SELECT decode(v.dimension6_code,
                      '0',
                      'NULL',
                      '',
                      'NULL',
                      v.dimension6_code)
          INTO v_insurance_code
          FROM exp_report_lines_code_v v, exp_report_dists d
         WHERE v.exp_report_line_id = d.exp_report_line_id
           AND d.exp_report_dists_id = v_dist_id;
      else
        v_insurance_code := 'NULL';
        /*end if;*/
      end if;
    else
      v_insurance_code := 'NULL';
    end if;
    RETURN v_insurance_code;
  end get_insurance_code;

  /*************************************************
  -- Author  : pqs
  -- Created : 2018/09/19 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取公司段,SEGMENT1
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 公司段
  **************************************************/
  function get_company_code(p_rule_type VARCHAR2, p_je_line_id VARCHAR2)
    RETURN VARCHAR2 IS
    v_usage_code          VARCHAR2(200);
    v_line_id             NUMBER;
    v_header_id           NUMBER;
    v_dists_id            number;
    v_payment_req_line_id number;
    v_write_off_id        number;
    v_trans_line_id       number;
    v_write_off_type      varchar2(30);
    v_company_code        varchar2(30) := 'NULL';
    v_count               number;
    v_transaction_headers csh_transaction_headers%rowtype;
  BEGIN
    --费用凭证公司取报销行上预算机构（借） 头机构（贷）
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_exp_report THEN
      --报销单业务类别
      SELECT a.usage_code,
             a.payment_schedule_line_id,
             a.exp_report_header_id,
             a.exp_report_dists_id
        INTO v_usage_code, v_line_id, v_header_id, v_dists_id
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      --报销单费用行
      IF v_usage_code = 'EMPLOYEE_EXPENSE' THEN
        SELECT v.company_code
          into v_company_code
          FROM exp_report_lines_code_v v, exp_report_dists d
         WHERE v.exp_report_line_id = d.exp_report_line_id
           AND d.exp_report_dists_id = v_dists_id;
      elsif v_usage_code = 'EMPLOYEE_EXPENSE_CLEARING' then
        SELECT v.company_code
          into v_company_code
          FROM exp_report_headers_code_v v
         where v.exp_report_header_id = v_header_id;
      elsif v_usage_code = 'INTERCOMPANY_AP' then
        SELECT v.company_code
          into v_company_code
          FROM exp_report_lines_code_v v, exp_report_dists d
         WHERE v.exp_report_line_id = d.exp_report_line_id
           AND d.exp_report_dists_id = v_dists_id;
      elsif v_usage_code = 'INTERCOMPANY_AR' then
        SELECT v.company_code
          into v_company_code
          FROM exp_report_headers_code_v v
         where v.exp_report_header_id = v_header_id;
        --增值税   
      elsif v_usage_code = 'EMPLOYEE_EXPENSE_TAX' then
        SELECT v.company_code
          into v_company_code
          FROM exp_report_lines_code_v v, exp_report_dists d
         WHERE v.exp_report_line_id = d.exp_report_line_id
           AND d.exp_report_dists_id = v_dists_id;
        --进项转出
      elsif v_usage_code = 'EMPLOYEE_EXPENSE_ROLL_OUT' then
        SELECT v.company_code
          into v_company_code
          FROM exp_report_lines_code_v v, exp_report_dists d
         WHERE v.exp_report_line_id = d.exp_report_line_id
           AND d.exp_report_dists_id = v_dists_id;
      elsif v_usage_code = 'EMPLOYEE_EXPENSE_SALES' then
        SELECT v.company_code
          into v_company_code
          FROM exp_report_lines_code_v v, exp_report_dists d
         WHERE v.exp_report_line_id = d.exp_report_line_id
           AND d.exp_report_dists_id = v_dists_id;
      elsif v_usage_code = 'EMPLOYEE_EXPENSE_LOW_PRICE' then
        SELECT v.company_code
          into v_company_code
          FROM exp_report_lines_code_v v, exp_report_dists d
         WHERE v.exp_report_line_id = d.exp_report_line_id
           AND d.exp_report_dists_id = v_dists_id;
      else
        v_company_code := 'NULL';
      end if;
    
      --借款申请 头机构
    ELSIF p_rule_type = gl_account_segment_pkg.g_rule_type_csh_pmt_req THEN
      SELECT a.usage_code, a.payment_req_line_id
        into v_usage_code, v_line_id
        FROM csh_payment_req_accounts a
       WHERE a.je_line_id = p_je_line_id;
    
      select f.company_code
        into v_company_code
        from fnd_companies_vl f
       where f.company_id =
             (select h.company_id
                from csh_payment_requisition_hds h
               where h.payment_requisition_header_id =
                     (select l.payment_requisition_header_id
                        from csh_payment_requisition_lns l
                       where l.payment_requisition_line_id = v_line_id));
    
      --现金事务核销
    elsif p_rule_type = gl_account_segment_pkg.g_rule_type_csh_write_off then
      SELECT t.usage_code, t.write_off_id
        INTO v_usage_code, v_write_off_id
        FROM csh_write_off_accounts_code_v t
       WHERE t.write_off_je_line_id = p_je_line_id;
    
      select h.*
        into v_transaction_headers
        from csh_transaction_headers h
       where h.transaction_header_id =
             (select l.transaction_header_id
                from csh_transaction_lines l
               where l.transaction_line_id =
                     (select c.csh_transaction_line_id
                        from csh_write_off c
                       where c.write_off_id = v_write_off_id));
    
      SELECT a.payment_requisition_line_id
        INTO v_payment_req_line_id
        FROM csh_payment_requisition_refs a
       WHERE a.csh_transaction_line_id =
             (SELECT b.transaction_line_id
                FROM csh_transaction_lines b
               WHERE b.transaction_header_id =
                     v_transaction_headers.source_payment_header_id)
         AND rownum = 1;
    
      select f.company_code
        into v_company_code
        from fnd_companies_vl f
       where f.company_id =
             (select l.company_id
                from csh_payment_requisition_lns l
               where l.payment_requisition_line_id = v_payment_req_line_id);
    
      --现金事物凭证
    elsif p_rule_type = gl_account_segment_pkg.g_rule_type_csh_transaction THEN
      SELECT usage_code, a.transaction_line_id, a.write_off_id
        INTO v_usage_code, v_trans_line_id, v_write_off_id
        FROM csh_transaction_accounts a
       WHERE a.transaction_je_line_id = p_je_line_id;
    
      --报销单现金事物
      if v_usage_code = 'EMPLOYEE_EXPENSE_WRITE_OFF' then
        select v.company_code
          into v_company_code
          from exp_report_headers_code_v v
         where v.exp_report_header_id =
               (select c.document_header_id
                  from csh_write_off c
                 where c.csh_transaction_line_id = v_trans_line_id);
      
        /*  --借款申请现金事物          
        elsif v_usage_code = 'CSH_INTERCOMPANY_AR' then
        
          SELECT (select f.company_code
                    from fnd_companies f
                   where f.company_id =
                         (select h.company_id
                            from csh_payment_requisition_hds h
                           where h.payment_requisition_header_id =
                                 l.payment_requisition_header_id))
            into v_company_code
            FROM csh_write_off                wo,
                 csh_payment_requisition_refs r,
                 csh_payment_requisition_lns  l
           WHERE wo.csh_transaction_line_id = v_trans_line_id
             AND wo.write_off_type = 'PAYMENT_PREPAYMENT'
             AND wo.write_off_id = r.write_off_id
             AND r.payment_requisition_line_id =
                 l.payment_requisition_line_id;*/
      
      elsif v_usage_code = 'PREPAYMENT' then
      
        SELECT count(*)
          into v_count
          FROM csh_repayment_register_dists cr
         WHERE cr.repayment_pay_trx_line_id = v_trans_line_id;
      
        --还款单取还款单头机构
        if v_count <> 0 then
          SELECT (select f.company_code
                    from fnd_companies f
                   where f.company_id = h.company_id)
            into v_company_code
            FROM csh_repayment_register_dists c,
                 csh_repayment_register_lns   l,
                 csh_repayment_register_hds   h
           WHERE l.register_line_id = c.register_line_id
             and l.register_header_id = h.register_header_id
             and c.repayment_pay_trx_line_id = v_trans_line_id;
        else
          SELECT (select f.company_code
                    from fnd_companies f
                   where f.company_id = h.company_id)
            into v_company_code
            FROM csh_write_off                wo,
                 csh_payment_requisition_refs r,
                 csh_payment_requisition_lns  l,
                 csh_payment_requisition_hds  h
           WHERE wo.write_off_type = 'PAYMENT_PREPAYMENT'
             AND wo.write_off_id = v_write_off_id
             and wo.write_off_id = r.write_off_id
             AND r.payment_requisition_line_id =
                 l.payment_requisition_line_id
             and h.payment_requisition_header_id =
                 l.payment_requisition_header_id;
        end if;
        --现金事物往来
      elsif v_usage_code = 'CSH_INTERCOMPANY_AP' then
      
        select wo.write_off_type
          into v_write_off_type
          FROM csh_write_off wo
         WHERE wo.csh_transaction_line_id = v_trans_line_id;
        --借款
        if v_write_off_type = 'PAYMENT_PREPAYMENT' then
          SELECT (select f.company_code
                    from fnd_companies f
                   where f.company_id = h.company_id)
            into v_company_code
            FROM csh_write_off                wo,
                 csh_payment_requisition_refs r,
                 csh_payment_requisition_lns  l,
                 csh_payment_requisition_hds  h
           WHERE wo.write_off_type = 'PAYMENT_PREPAYMENT'
             AND wo.write_off_id = v_write_off_id
             and wo.write_off_id = r.write_off_id
             AND r.payment_requisition_line_id =
                 l.payment_requisition_line_id
             and h.payment_requisition_header_id =
                 l.payment_requisition_header_id;
        else
          --报销
          select v.company_code
            into v_company_code
            from exp_report_headers_code_v v
           where v.exp_report_header_id =
                 (select c.document_header_id
                    from csh_write_off c
                   where c.csh_transaction_line_id = v_trans_line_id);
        end if;
      elsif v_usage_code = 'CSH_INTERCOMPANY_AR' then
        select wo.write_off_type
          into v_write_off_type
          FROM csh_write_off wo
         WHERE wo.csh_transaction_line_id = v_trans_line_id;
        --借款
        if v_write_off_type = 'PAYMENT_PREPAYMENT' then
          SELECT (select f.company_code
                    from fnd_companies f
                   where f.company_id = h.company_id)
            into v_company_code
            FROM csh_write_off                wo,
                 csh_payment_requisition_refs r,
                 csh_payment_requisition_lns  l,
                 csh_payment_requisition_hds  h
           WHERE wo.write_off_type = 'PAYMENT_PREPAYMENT'
             AND wo.write_off_id = v_write_off_id
             and wo.write_off_id = r.write_off_id
             AND r.payment_requisition_line_id =
                 l.payment_requisition_line_id
             and h.payment_requisition_header_id =
                 l.payment_requisition_header_id;
        else
          --报销
          select v.company_code
            into v_company_code
            from exp_report_headers_code_v v
           where v.exp_report_header_id =
                 (select c.document_header_id
                    from csh_write_off c
                   where c.csh_transaction_line_id = v_trans_line_id);
        end if;
      
        --银行           
      elsif v_usage_code = 'CASH_ACCOUNT' then
      
        SELECT count(*)
          into v_count
          FROM csh_repayment_register_dists cr
         WHERE cr.repayment_pay_trx_line_id = v_trans_line_id;
      
        --还款单取借款单头机构
        if v_count <> 0 then
        
          SELECT (select f.company_code
                    from fnd_companies f
                   where f.company_id = h.company_id)
            into v_company_code
            FROM csh_repayment_register_dists c,
                 csh_repayment_register_lns   l,
                 csh_payment_requisition_lns  cl,
                 csh_payment_requisition_hds  h
           WHERE h.payment_requisition_header_id =
                 cl.payment_requisition_header_id
             and l.requisition_line_id = cl.payment_requisition_line_id
             and l.register_line_id = c.register_line_id
             and c.repayment_pay_trx_line_id = v_trans_line_id;
        
        else
          SELECT (select f.company_code
                    from fnd_companies_vl f
                   where f.company_id = t.company_id)
            INTO v_company_code
            FROM csh_bank_accounts t, csh_transaction_lines l
           WHERE t.bank_account_id = l.bank_account_id
             AND l.transaction_line_id = v_trans_line_id;
        end if;
      end if;
    else
      v_company_code := 'NULL';
    end if;
    return v_company_code;
  end get_company_code;

  /*************************************************
  -- Author  : pqs
  -- Created : 2018/09/19 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取成本中心段,SEGMENT2
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 成本中心段
  **************************************************/
  function get_cost_center(p_rule_type VARCHAR2, p_je_line_id VARCHAR2)
    return varchar2 is
    v_usage_code       VARCHAR2(200);
    v_line_id          NUMBER;
    v_header_id        NUMBER;
    v_dists_id         number;
    v_count            number;
    v_account_id       number;
    v_account_code     varchar2(30);
    v_cost_center_code varchar2(30) := 'NULL';
  BEGIN
    --费用凭证成本中心取报销行上成本中心（借）
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_exp_report THEN
      --报销单业务类别
      SELECT a.usage_code,
             a.payment_schedule_line_id,
             a.exp_report_header_id,
             a.exp_report_dists_id,
             a.account_id
        INTO v_usage_code, v_line_id, v_header_id, v_dists_id, v_account_id
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      --报销单费用行
      IF v_usage_code = 'EMPLOYEE_EXPENSE' THEN
      
        select g.account_code
          into v_account_code
          from gld_accounts g
         where g.account_id = v_account_id;
      
        --系统参数定义费用科目，不带成本中心
        select count(*)
          into v_count
          from sys_codes s, sys_code_values sv
         where s.code_id = sv.code_id
           and s.code = 'PRL_ASSET_TRANSFER_EXPENSE_ACCOUNT'
           and sv.code_value = v_account_code
           and sv.enabled_flag = 'Y';
      
        if v_count = 0 then
          SELECT v.responsibility_center_code
            into v_cost_center_code
            FROM exp_report_lines_code_v v, exp_report_dists d
           WHERE v.exp_report_line_id = d.exp_report_line_id
             AND d.exp_report_dists_id = v_dists_id;
        else
          v_cost_center_code := 'NULL';
        end if;
      elsif v_usage_code = 'EMPLOYEE_EXPENSE_TAX' then
        SELECT v.responsibility_center_code
          into v_cost_center_code
          FROM exp_report_lines_code_v v, exp_report_dists d
         WHERE v.exp_report_line_id = d.exp_report_line_id
           AND d.exp_report_dists_id = v_dists_id;
        --进项转出
      elsif v_usage_code = 'EMPLOYEE_EXPENSE_ROLL_OUT' then
        SELECT v.responsibility_center_code
          into v_cost_center_code
          FROM exp_report_lines_code_v v, exp_report_dists d
         WHERE v.exp_report_line_id = d.exp_report_line_id
           AND d.exp_report_dists_id = v_dists_id;
      elsif v_usage_code = 'EMPLOYEE_EXPENSE_SALES' then
        SELECT v.responsibility_center_code
          into v_cost_center_code
          FROM exp_report_lines_code_v v, exp_report_dists d
         WHERE v.exp_report_line_id = d.exp_report_line_id
           AND d.exp_report_dists_id = v_dists_id;
      elsif v_usage_code = 'EMPLOYEE_EXPENSE_LOW_PRICE' then
        v_cost_center_code := 'NULL';
      else
        v_cost_center_code := 'NULL';
      end if;
    else
      v_cost_center_code := 'NULL';
    end if;
    return v_cost_center_code;
  end get_cost_center;

  /*************************************************
  -- Author  : pqs
  -- Created : 2018/09/19 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取客商辅助段,SEGMENT15
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 获取客商辅助段
  **************************************************/
  function get_travel_trader_code(p_rule_type  VARCHAR2,
                                  p_je_line_id VARCHAR2) return varchar2 is
    v_usage_code                  VARCHAR2(200);
    v_line_id                     NUMBER;
    v_header_id                   NUMBER;
    v_dists_id                    number;
    v_payee_category              varchar2(30);
    v_payee_id                    number;
    v_code                        varchar2(10);
    v_write_off_id                number;
    v_account_code                varchar2(30);
    v_payment_req_line_id         number;
    v_trans_line_id               number;
    v_transaction_headers         csh_transaction_headers%rowtype;
    v_travel_trader_code          varchar2(30) := 'NULL';
    v_source_trans_line_id        number;
    v_bank_account_id             number;
    v_write_off_type              varchar2(30);
    v_document_header_id          number;
    v_source_csh_trx_line_id      number;
    v_count                       number;
    v_current_trans_header        csh_transaction_headers%rowtype;
    v_source_trans_header         csh_transaction_headers%rowtype;
    v_reverse_source_trans_header csh_transaction_headers%rowtype;
    v_returned_flag               varchar2(10);
  BEGIN
    --费用凭证 
    /*报销行上费用项目字段
    EMPLOYEE_EXPENSE 报销单费用 EMPLOYEE_EXPENSE_10 报销单费用项目
    报销行上报销类型字段
    EMPLOYEE_EXPENSE 报销单费用
    EMPLOYEE_EXPENSE_20 报销单类型+进项税科目
    计划付款行上付款用途字段
    EMPLOYEE_EXPENSE_CLEARING 报销单费用清算 EMPLOYEE_EXPENSE_CLEARING_10 付款用途匹配组*/
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_exp_report THEN
      --报销单业务类别
      SELECT a.usage_code,
             a.payment_schedule_line_id,
             a.exp_report_header_id,
             a.exp_report_dists_id
        INTO v_usage_code, v_line_id, v_header_id, v_dists_id
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      --报销单费用行
      IF v_usage_code = 'EMPLOYEE_EXPENSE' THEN
        v_travel_trader_code := 'null';
        --增值税
      elsif v_usage_code = 'EMPLOYEE_EXPENSE_TAX' THEN
        v_travel_trader_code := 'NULL';
        --低值易耗  
      elsif v_usage_code = 'EMPLOYEE_EXPENSE_LOW_PRICE' then
        v_travel_trader_code := 'null';
      elsif v_usage_code = 'INTERCOMPANY_AP' then
        /*SELECT 'N' || v.company_code
         into v_travel_trader_code
         FROM exp_report_lines_code_v v, exp_report_dists d
        WHERE v.exp_report_line_id = d.exp_report_line_id
          AND d.exp_report_dists_id = v_dists_id;*/
      
        select 'N' || (select f.company_code
                         from fnd_companies f
                        where f.company_id = h.company_id)
          into v_travel_trader_code
          from exp_report_headers h
         where h.exp_report_header_id = v_header_id;
      
      elsif v_usage_code = 'INTERCOMPANY_AR' then
        SELECT 'N' || v.company_code
          into v_travel_trader_code
          FROM exp_report_lines_code_v v, exp_report_dists d
         WHERE v.exp_report_line_id = d.exp_report_line_id
           AND d.exp_report_dists_id = v_dists_id;
      else
        select e.payee_category, e.payee_id
          into v_payee_category, v_payee_id
          from exp_report_pmt_schedules e
         where e.payment_schedule_line_id = v_line_id;
      
        if v_payee_category = 'EMPLOYEE' then
          select '16' || e.employee_code
            into v_travel_trader_code
            from exp_employees e
           where e.employee_id = v_payee_id;
        else
          select p.vender_code
            into v_travel_trader_code
            from pur_system_venders p
           where p.vender_id = v_payee_id;
        end if;
      end if;
      --借款申请
    ELSIF p_rule_type = gl_account_segment_pkg.g_rule_type_csh_pmt_req THEN
      SELECT a.usage_code, a.payment_req_line_id
        into v_usage_code, v_line_id
        FROM csh_payment_req_accounts a, gld_accounts g
       WHERE a.je_line_id = p_je_line_id
         and a.account_id = g.account_id;
    
      select l.partner_category, l.partner_id
        into v_payee_category, v_payee_id
        from csh_payment_requisition_lns l
       where l.payment_requisition_line_id = v_line_id;
    
      if v_payee_category = 'EMPLOYEE' then
        select '16' || e.employee_code
          into v_code
          from exp_employees e
         where e.employee_id = v_payee_id;
      else
        select p.vender_code
          into v_code
          from pur_system_venders p
         where p.vender_id = v_payee_id;
      end if;
    
      if v_usage_code = 'PAYMENT_REQUISITION' then
        v_travel_trader_code := v_code;
      elsif v_usage_code = 'PAYMENT_REQUISITION_CLEARING' then
        v_travel_trader_code := v_code;
      else
        v_travel_trader_code := 'NULL';
      end if;
      --现金事务核销
    elsif p_rule_type = gl_account_segment_pkg.g_rule_type_csh_write_off then
      SELECT t.usage_code, t.write_off_id, t.account_code
        INTO v_usage_code, v_write_off_id, v_account_code
        FROM csh_write_off_accounts_code_v t
       WHERE t.write_off_je_line_id = p_je_line_id;
    
      select h.*
        into v_transaction_headers
        from csh_transaction_headers h
       where h.transaction_header_id =
             (select l.transaction_header_id
                from csh_transaction_lines l
               where l.transaction_line_id =
                     (select c.csh_transaction_line_id
                        from csh_write_off c
                       where c.write_off_id = v_write_off_id));
    
      SELECT a.payment_requisition_line_id
        INTO v_payment_req_line_id
        FROM csh_payment_requisition_refs a
       WHERE a.csh_transaction_line_id =
             (SELECT b.transaction_line_id
                FROM csh_transaction_lines b
               WHERE b.transaction_header_id =
                     v_transaction_headers.source_payment_header_id)
         AND rownum = 1;
    
      select l.partner_category, l.partner_id
        into v_payee_category, v_payee_id
        from csh_payment_requisition_lns l
       where l.payment_requisition_line_id = v_payment_req_line_id;
    
      if v_payee_category = 'EMPLOYEE' then
        select '16' || e.employee_code
          into v_code
          from exp_employees e
         where e.employee_id = v_payee_id;
      else
        select p.vender_code
          into v_code
          from pur_system_venders p
         where p.vender_id = v_payee_id;
      end if;
    
      if v_usage_code = 'EMPLOYEE_EXPENSE_WRITE_OFF' then
        v_travel_trader_code := v_code;
      elsif v_usage_code = 'PREPAYMENT_WRITE_OFF' then
        v_travel_trader_code := v_code;
      end if;
      --现金事物凭证
    elsif p_rule_type = gl_account_segment_pkg.g_rule_type_csh_transaction THEN
      SELECT usage_code, a.transaction_line_id
        INTO v_usage_code, v_trans_line_id
        FROM csh_transaction_accounts a
       WHERE a.transaction_je_line_id = p_je_line_id;
    
      SELECT h.*
        INTO v_current_trans_header
        FROM csh_transaction_headers h, csh_transaction_lines l
       WHERE h.transaction_header_id = l.transaction_header_id
         AND l.transaction_line_id = v_trans_line_id;
    
      IF nvl(v_current_trans_header.reversed_flag, 'N') != 'R' AND
         v_current_trans_header.returned_flag != 'R' THEN
        v_source_trans_header := v_current_trans_header;
      END IF;
    
      --如果当前事务是退款事务，则找到原事务
      IF v_current_trans_header.returned_flag = 'R' THEN
        v_returned_flag := 'Y';
        SELECT *
          INTO v_source_trans_header
          FROM csh_transaction_headers h
         WHERE h.transaction_header_id =
               v_current_trans_header.source_header_id;
      END IF;
    
      --如果当前事务是反冲事务，则找到原事务
      IF nvl(v_current_trans_header.reversed_flag, 'N') = 'R' THEN
        SELECT *
          INTO v_reverse_source_trans_header
          FROM csh_transaction_headers h
         WHERE h.transaction_header_id =
               v_current_trans_header.source_header_id;
      
        --取原事务的退款状态，来判断是否退款
        IF v_reverse_source_trans_header.returned_flag = 'R' THEN
          v_returned_flag := 'Y';
        
          SELECT *
            INTO v_source_trans_header
            FROM csh_transaction_headers h
           WHERE h.transaction_header_id =
                 v_reverse_source_trans_header.source_header_id;
        ELSE
          v_source_trans_header := v_reverse_source_trans_header;
        END IF;
      END IF;
    
      SELECT l.transaction_line_id
        INTO v_source_trans_line_id
        FROM csh_transaction_lines l
       WHERE l.transaction_header_id =
             v_source_trans_header.transaction_header_id;
    
      --报销单现金事物
      if v_usage_code = 'EMPLOYEE_EXPENSE_WRITE_OFF' then
      
        SELECT s.payee_category, s.payee_id
          into v_payee_category, v_payee_id
          FROM csh_write_off wo, exp_report_pmt_schedules s
         WHERE wo.write_off_type = 'PAYMENT_EXPENSE_REPORT'
           AND wo.document_line_id = s.payment_schedule_line_id
           AND wo.csh_transaction_line_id = v_source_trans_line_id
           and rownum = 1;
      
        if v_payee_category = 'EMPLOYEE' then
          select '16' || e.employee_code
            into v_travel_trader_code
            from exp_employees e
           where e.employee_id = v_payee_id;
        else
          select p.vender_code
            into v_travel_trader_code
            from pur_system_venders p
           where p.vender_id = v_payee_id;
        end if;
      
        --借款现金事物
      elsif v_usage_code = 'PREPAYMENT' then
        SELECT l.partner_category, l.partner_id
          into v_payee_category, v_payee_id
          FROM csh_write_off                wo,
               csh_payment_requisition_refs r,
               csh_payment_requisition_lns  l
         WHERE wo.csh_transaction_line_id = v_source_trans_line_id
           AND wo.write_off_type = 'PAYMENT_PREPAYMENT'
           AND wo.write_off_id = r.write_off_id
           AND r.payment_requisition_line_id =
               l.payment_requisition_line_id
           and rownum = 1;
      
        if v_payee_category = 'EMPLOYEE' then
          select '16' || e.employee_code
            into v_travel_trader_code
            from exp_employees e
           where e.employee_id = v_payee_id;
        else
          select p.vender_code
            into v_travel_trader_code
            from pur_system_venders p
           where p.vender_id = v_payee_id;
        end if;
      
        --现金事物往来  
      elsif v_usage_code = 'CSH_INTERCOMPANY_AP' then
      
        select w.write_off_type,
               w.document_header_id,
               w.source_csh_trx_line_id
          into v_write_off_type,
               v_document_header_id,
               v_source_csh_trx_line_id
          from csh_write_off w
         where w.csh_transaction_line_id = v_source_trans_line_id
           and rownum = 1;
      
        /*select count(*)
         into v_count
         from csh_transaction_accounts c
        where c.transaction_line_id = v_source_trans_line_id
          and c.company_id =
              (SELECT t.company_id
                 FROM csh_bank_accounts t, csh_transaction_lines l
                WHERE t.bank_account_id = l.bank_account_id
                  AND l.transaction_line_id = v_trans_line_id);*/
      
        /*if v_count = 0 then*/
        SELECT 'N' || (select f.company_code
                         from fnd_companies_vl f
                        where f.company_id = t.company_id)
          INTO v_travel_trader_code
          FROM csh_bank_accounts t, csh_transaction_lines l
         WHERE t.bank_account_id = l.bank_account_id
           AND l.transaction_line_id = v_trans_line_id;
        /*else*/
      elsif v_usage_code = 'CSH_INTERCOMPANY_AR' then
        select 'N' || h.company_code
          into v_travel_trader_code
          from csh_transaction_headers_code_v h, csh_transaction_lines l
         where h.transaction_header_id = l.transaction_header_id
           and l.transaction_line_id = v_trans_line_id;
        --银行           
      elsif v_usage_code = 'CASH_ACCOUNT' then
        v_travel_trader_code := 'NULL';
      end if;
    else
      v_travel_trader_code := 'NULL';
    end if;
    return v_travel_trader_code;
  end get_travel_trader_code;

  /*************************************************
  -- Author  : pqs
  -- Created : 2018/09/19 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取承诺项目段,SEGMENT4
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 获取承诺项目段
  **************************************************/
  function get_commitment_item(p_rule_type VARCHAR2, p_je_line_id VARCHAR2)
    return varchar2 is
    v_usage_code           VARCHAR2(200);
    v_line_id              NUMBER;
    v_header_id            NUMBER;
    v_dists_id             number;
    v_expense_item_code    varchar2(30);
    v_report_lines         exp_report_lines%rowtype;
    v_report_accounts      exp_report_accounts%rowtype;
    v_commitment_item_code varchar2(30) := 'NULL';
  BEGIN
    --费用凭证成本中心取报销行上成本中心（借）
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_exp_report THEN
      --报销单业务类别
      SELECT a.usage_code,
             a.payment_schedule_line_id,
             a.exp_report_header_id,
             a.exp_report_dists_id
        INTO v_usage_code, v_line_id, v_header_id, v_dists_id
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      SELECT a.*
        INTO v_report_accounts
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      --报销单费用行
      IF v_usage_code = 'EMPLOYEE_EXPENSE' THEN
        select e.*
          into v_report_lines
          from exp_report_lines e
         where e.exp_report_line_id =
               (select d.exp_report_line_id
                  from exp_report_dists d
                 where d.exp_report_dists_id = v_dists_id);
      
        --取值报销行上费用项目对应的承诺项目代码  
        --if v_report_lines.sale_amount = v_report_accounts.entered_amount_dr then
        /*select b.budget_item_code
         into v_commitment_item_code
         from bgt_budget_items_vl b
        where b.budget_item_id =
              (select v.budget_item_id
                 from exp_expense_items_vl v
                where v.expense_item_id = v_report_lines.expense_item_id);*/
        select v.commitment_item_code
          into v_commitment_item_code
          from exp_expense_items_vl v
         where v.expense_item_id = v_report_lines.expense_item_id;
        /*else
          v_commitment_item_code := 'null';
        end if;*/
      else
        v_commitment_item_code := 'NULL';
      end if;
    else
      v_commitment_item_code := 'NULL';
    end if;
    return v_commitment_item_code;
  end get_commitment_item;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/11 13:50:26
  -- Ver     : 1.1
  -- Purpose : 获取险种段,SEGMENT8
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 获取险种段
  **************************************************/
  function get_insurance_code1(p_rule_type VARCHAR2, p_je_line_id VARCHAR2)
    RETURN VARCHAR2 IS
    v_usage_code      VARCHAR2(30);
    v_dist_id         NUMBER;
    v_report_lines    exp_report_lines%rowtype;
    v_report_accounts exp_report_accounts%rowtype;
    v_insurance_code  VARCHAR2(200) := 'NULL';
  begin
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_exp_report THEN
    
      SELECT usage_code, exp_report_dists_id
        INTO v_usage_code, v_dist_id
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      SELECT a.*
        INTO v_report_accounts
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      --报销单费用行
      IF v_usage_code = 'EMPLOYEE_EXPENSE' THEN
        select e.*
          into v_report_lines
          from exp_report_lines e
         where e.exp_report_line_id =
               (select d.exp_report_line_id
                  from exp_report_dists d
                 where d.exp_report_dists_id = v_dist_id);
      
        --取值报销行上险种字段 
        --if v_report_lines.sale_amount = v_report_accounts.entered_amount_dr then
        SELECT decode(v.dimension5_code,
                      '0',
                      'NULL',
                      '',
                      'NULL',
                      v.dimension5_code)
          INTO v_insurance_code
          FROM exp_report_lines_code_v v, exp_report_dists d
         WHERE v.exp_report_line_id = d.exp_report_line_id
           AND d.exp_report_dists_id = v_dist_id;
      else
        v_insurance_code := 'NULL';
        /*end if;*/
      end if;
    else
      v_insurance_code := 'NULL';
    end if;
    RETURN v_insurance_code;
  end get_insurance_code1;

  /*************************************************
  -- Author  : pqs
  -- Created : 2018.11.18
  -- Ver     : 1.1
  -- Purpose : 获取渠道段，SEGMENT4
  -- In Para : 
        p_rule_type       业务类别
        p_je_line_id      凭证行ID
     Return  : 渠道段
  **************************************************/
  FUNCTION get_channel_segment4(p_rule_type VARCHAR2, p_je_line_id NUMBER)
    RETURN VARCHAR2 IS
    v_usage_code      VARCHAR2(30);
    v_dist_id         NUMBER;
    v_channel_code    VARCHAR2(200) := 'null';
    v_report_accounts exp_report_accounts%rowtype;
    v_report_lines    exp_report_lines%rowtype;
  BEGIN
    return 'null';
    IF p_rule_type = gl_account_segment_pkg.g_rule_type_exp_report THEN
      SELECT usage_code, exp_report_dists_id
        INTO v_usage_code, v_dist_id
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      SELECT a.*
        INTO v_report_accounts
        FROM exp_report_accounts a
       WHERE a.exp_report_je_line_id = p_je_line_id;
    
      --报销单费用行
      --IF v_usage_code = 'EMPLOYEE_EXPENSE' THEN
      select e.*
        into v_report_lines
        from exp_report_lines e
       where e.exp_report_line_id =
             (select d.exp_report_line_id
                from exp_report_dists d
               where d.exp_report_dists_id = v_dist_id);
    
      --取值报销行上渠道
      SELECT decode(v.dimension4_code,
                    '0',
                    'null',
                    '',
                    'null',
                    v.dimension4_code)
        INTO v_channel_code
        FROM exp_report_lines_code_v v, exp_report_dists d
       WHERE v.exp_report_line_id = d.exp_report_line_id
         AND d.exp_report_dists_id = v_dist_id;
      /*else
        v_channel_code := 'null';
      end if;*/
    else
      v_channel_code := 'null';
    end if;
    RETURN v_channel_code;
  EXCEPTION
    WHEN OTHERS THEN
      gl_log_pkg.log(p_log_text => SQLERRM || chr(10) ||
                                   dbms_utility.format_error_backtrace,
                     p_user_id  => -1);
    
      raise_application_error(-20000,
                              SQLERRM || chr(10) ||
                              dbms_utility.format_error_backtrace);
  END get_channel_segment4;

END cux_coa_pkg;
/
