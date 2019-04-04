CREATE OR REPLACE PACKAGE cux_gl_interface_pkg IS

  -- Author  : MOUSE
  -- Created : 2015/10/19 14:43:55
  -- Purpose : 总账接口包

  TYPE entry_table IS TABLE OF gl_account_entry%ROWTYPE;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/10/19 19:02:39
  -- Ver     : 1.1
  -- Purpose : 获取CCID
  -- In Para :
        p_concat_segments       组合过的segments
     Return  : ccid校验结果
  **************************************************/
  FUNCTION validate_ccid(p_concat_segments VARCHAR) RETURN VARCHAR2;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/9 15:56:13
  -- Ver     : 1.1
  -- Purpose : 获取reference4，EBS用于确认同一个单据生成同一个日记账
  -- In Para :
        p_entry_id       分录表ID
     Return  : 单据编号
  **************************************************/
  FUNCTION get_reference4(p_entry_id NUMBER) RETURN VARCHAR2;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/9 15:56:13
  -- Ver     : 1.1
  -- Purpose : 获取付款凭证的reference4，EBS用于确认同一个单据生成同一个日记账，按照SEG1，SEG9，SEG20组合拼接而成
  -- In Para :
        p_segment1       公司段
        p_segment9       现金流量段
        p_segment20      支付批次号
     Return  : 单据编号
  **************************************************/
  FUNCTION get_pay_reference4(p_segment20 VARCHAR2) RETURN VARCHAR2;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/9 19:21:00
  -- Ver     : 1.1
  -- Purpose : 获取接口ID
  -- Return  : 接口ID
  **************************************************/
  FUNCTION get_interface_id RETURN NUMBER;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/9 17:25:56
  -- Ver     : 1.1
  -- Purpose : 获取凭证类别描述
  -- In Para :
        p_entry_id       分录表ID
     Return  : 凭证类别描述
  **************************************************/
  FUNCTION get_user_je_category_name(p_entry_id NUMBER) RETURN VARCHAR2;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/10/19 19:07:12
  -- Ver     : 1.1
  -- Purpose : 将分录表中的数据导入到接口表中
  **************************************************/
  PROCEDURE import_entry_to_interface;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/10/19 19:07:12
  -- Ver     : 1.1
  -- Purpose : 凭证过总账
  **************************************************/
  PROCEDURE post_to_ebs;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/10 9:27:34
  -- Ver     : 1.1
  -- Purpose : 从EBS查询已传输的凭证的过账状态
  **************************************************/
  PROCEDURE query_from_ebs;

  PROCEDURE adjust_ebs_hec_inf_period(p_company_id      NUMBER,
                                      p_accounting_date DATE,
                                      p_period_name     OUT VARCHAR2,
                                      p_period_num      OUT VARCHAR2);

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/21 12:29:11
  -- Ver     : 1.1
  -- Purpose : 更新interface的段值
  **************************************************/
  PROCEDURE update_gl_interface(p_gl_interface_id NUMBER,
                                p_accounting_date DATE,
                                p_period_name     VARCHAR2,
                                p_period_num      VARCHAR2,
                                p_segment1        VARCHAR2,
                                p_segment2        VARCHAR2,
                                p_segment3        VARCHAR2,
                                p_segment4        VARCHAR2,
                                p_segment5        VARCHAR2,
                                p_segment6        VARCHAR2,
                                p_segment7        VARCHAR2,
                                p_segment8        VARCHAR2,
                                p_segment9        VARCHAR2,
                                p_segment10       VARCHAR2,
                                p_segment11       VARCHAR2,
                                p_user_id         NUMBER);
  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/21 12:37:39
  -- Ver     : 1.1
  -- Purpose : 传递费控接口表中的更新至EBS接口表中
  **************************************************/
  PROCEDURE post_update_to_ebs(p_batch_id   VARCHAR2,
                               p_reference4 VARCHAR2,
                               p_company_id NUMBER,
                               p_user_id    NUMBER);

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/12/17 11:25:06
  -- Ver     : 1.1
  -- Purpose : 处理小于当月的期间的所有暂挂的摊销凭证并过账
  **************************************************/
  PROCEDURE post_hold_amortization_entry;

  /*************************************************
  -- Author  : Rick
  -- Created : 2017-6-23 10:14:53
  -- Ver     : 1.1
  -- Purpose : 凭证过总账
  **************************************************/
  /*PROCEDURE post_to_wlzq_ebs(p_gl_date   VARCHAR2 DEFAULT NULL,
  p_gl_status VARCHAR2 DEFAULT NULL);*/

  /*************************************************
  -- Author  : Rick
  -- Created : 2017-6-23 10:14:53
  -- Ver     : 1.1
  -- Purpose : 总账凭证结果回传
  **************************************************/
  /*PROCEDURE load_wlzq_gl_result;*/

  /*************************************************
  -- Author  : RICK
  -- Created : 2017-10-19 14:00:50
  -- Purpose : 回传凭证编号
  **************************************************/
  /*PROCEDURE load_journal_number;*/

  FUNCTION get_je_category_name(p_transaction_type VARCHAR2,
                                p_attribute_12     VARCHAR2) RETURN VARCHAR2;

  FUNCTION import_entry_to_interface_job(p_event_record_id NUMBER,
                                         p_event_log_id    NUMBER,
                                         p_event_param     NUMBER,
                                         p_user_id         NUMBER)
    RETURN NUMBER;

  /*********************************
    同步分录至sap凭证接口表
    add by pqs 20181006
  **********************************/
  FUNCTION load_entry_to_sap_interface(p_event_record_id NUMBER,
                                       p_event_log_id    NUMBER,
                                       p_event_param     NUMBER,
                                       p_user_id         NUMBER)
    RETURN NUMBER;

  /*************************************************
  -- Author  : pqs
  -- Created : 20181006
  -- Ver     : 1.1
  -- Purpose : 从sap查询已传输的凭证的过账状态
  **************************************************/
  FUNCTION query_from_sap(p_event_record_id NUMBER,
                          p_event_log_id    NUMBER,
                          p_event_param     NUMBER,
                          p_user_id         NUMBER) RETURN NUMBER;

  /*************************************************
  -- Author  : pqs
  -- Created : 20181101
  -- Ver     : 1.1
  -- Purpose : 待传送凭证分录修改
  **************************************************/
  procedure update_account_entry(p_account_entry_id number,
                                 p_segment1         varchar2,
                                 p_segment2         varchar2,
                                 p_segment3         varchar2,
                                 p_segment4         varchar2,
                                 p_segment5         varchar2,
                                 p_segment6         varchar2,
                                 p_segment7         varchar2,
                                 p_segment8         varchar2,
                                 p_segment9         varchar2,
                                 p_segment10        varchar2,
                                 p_segment11        varchar2,
                                 p_segment12        varchar2,
                                 p_segment15        varchar2,
                                 p_user_id          number);

  /*************************************************
  -- Author  : pqs
  -- Created : 20181020
  -- Ver     : 1.1
  -- Purpose : sap过账失败凭证分录修改
  **************************************************/
  procedure update_fail_account_entry(p_account_entry_id number,
                                      p_batch_code       varchar2,
                                      p_segment1         varchar2,
                                      p_segment2         varchar2,
                                      p_segment3         varchar2,
                                      p_segment4         varchar2,
                                      p_segment5         varchar2,
                                      p_segment6         varchar2,
                                      p_segment7         varchar2,
                                      p_segment8         varchar2,
                                      p_segment9         varchar2,
                                      p_segment10        varchar2,
                                      p_segment11        varchar2,
                                      p_segment12        varchar2,
                                      p_segment15        varchar2,
                                      p_user_id          number);

  /*************************************************
  -- Author  : pqs
  -- Created : 20181022
  -- Ver     : 1.1
  -- Purpose : sap过账失败凭证分录修改
  **************************************************/
  procedure resent_entry_to_sap(p_transaction_number varchar2,
                                p_user_id            number);
END cux_gl_interface_pkg;
/
CREATE OR REPLACE PACKAGE BODY cux_gl_interface_pkg IS

  e_lock_table EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_lock_table, -54);

  CURSOR cur_entrys IS
    SELECT *
      FROM gl_account_entry e
     WHERE e.imported_flag = 'P'
       FOR UPDATE NOWAIT;

  CURSOR cur_modify_entrys(p_transaction_number varchar2) IS
    SELECT *
      FROM gl_account_entry e
     WHERE e.imported_flag = 'M'
       and e.transaction_number = p_transaction_number
       FOR UPDATE NOWAIT;

  PROCEDURE lock_entry IS
  BEGIN
    OPEN cur_entrys;
  END;

  PROCEDURE unlock_entry IS
  BEGIN
    IF cur_entrys%ISOPEN THEN
      CLOSE cur_entrys;
    END IF;
  END;

  PROCEDURE lock_modify_entry(p_transaction_number varchar2) IS
  BEGIN
    OPEN cur_modify_entrys(p_transaction_number);
  END;

  PROCEDURE unlock_modify_entry IS
  BEGIN
    IF cur_modify_entrys%ISOPEN THEN
      CLOSE cur_modify_entrys;
    END IF;
  END;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/9 15:56:13
  -- Ver     : 1.1
  -- Purpose : 获取reference4，EBS用于确认同一个单据生成同一个日记账
  -- In Para :
        p_entry_id       分录表ID
     Return  : 单据编号
  **************************************************/
  FUNCTION get_reference4(p_entry_id NUMBER) RETURN VARCHAR2 IS
    v_entry           gl_account_entry%ROWTYPE;
    v_document_number VARCHAR2(200);
    v_write_off       csh_write_off%ROWTYPE;
  BEGIN
    SELECT i.*
      INTO v_entry
      FROM gl_account_entry i
     WHERE i.account_entry_id = p_entry_id;
  
    IF v_entry.transaction_type =
       gl_account_segment_pkg.g_rule_type_exp_report THEN
      v_document_number := v_entry.transaction_number;
    ELSIF v_entry.transaction_type =
          gl_account_segment_pkg.g_rule_type_csh_transaction THEN
      v_document_number := v_entry.transaction_number;
    ELSIF v_entry.transaction_type =
          gl_account_segment_pkg.g_rule_type_csh_write_off THEN
    
      SELECT *
        INTO v_write_off
        FROM csh_write_off wo
       WHERE wo.write_off_id = v_entry.transaction_header_id;
    
      SELECT h.exp_report_number
        INTO v_document_number
        FROM exp_report_headers h, csh_write_off wo
       WHERE wo.write_off_id = v_entry.transaction_header_id
         AND wo.document_source = 'EXPENSE_REPORT'
         AND wo.write_off_type = 'PREPAYMENT_EXPENSE_REPORT'
         AND wo.document_header_id = h.exp_report_header_id;
    
      --如果是核销反冲，则单据编号增加核销信息
      IF v_write_off.csh_write_off_amount < 0 THEN
        v_document_number := 'WO' || ':' || v_write_off.write_off_id || '|' ||
                             v_document_number;
      END IF;
    
    ELSIF v_entry.transaction_type =
          gl_account_segment_pkg.g_rule_type_csh_pmt_req THEN
      v_document_number := v_entry.transaction_number;
    ELSIF v_entry.transaction_type =
          gl_account_segment_pkg.g_rule_type_work_order THEN
      v_document_number := v_entry.transaction_number;
    END IF;
  
    RETURN v_document_number;
  
  END get_reference4;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/9 15:56:13
  -- Ver     : 1.1
  -- Purpose : 获取付款凭证的reference4，EBS用于确认同一个单据生成同一个日记账，按照SEG1，SEG9，SEG20组合拼接而成
  -- In Para :
        p_segment1       公司段
        p_segment9       现金流量段
        p_segment20      支付批次号
     Return  : 单据编号
  **************************************************/
  FUNCTION get_pay_reference4(p_segment20 VARCHAR2) RETURN VARCHAR2 IS
    v_document_number VARCHAR2(200);
  BEGIN
    v_document_number := 'ZJ:' || p_segment20;
  
    RETURN v_document_number;
  END get_pay_reference4;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/9 19:21:00
  -- Ver     : 1.1
  -- Purpose : 获取接口ID
  -- Return  : 接口ID
  **************************************************/
  FUNCTION get_interface_id RETURN NUMBER IS
    v_interface_id NUMBER;
  BEGIN
    SELECT gl_journal_interface_s.nextval INTO v_interface_id FROM dual;
    RETURN v_interface_id;
  END get_interface_id;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/9 17:25:56
  -- Ver     : 1.1
  -- Purpose : 获取凭证类别描述
  -- In Para :
        p_entry_id       分录表ID
     Return  : 凭证类别描述
  **************************************************/
  FUNCTION get_user_je_category_name(p_entry_id NUMBER) RETURN VARCHAR2 IS
    v_transaction_type      VARCHAR2(30);
    v_transaction_header_id NUMBER;
    v_transaction_header_1  csh_transaction_headers%ROWTYPE;
    v_transaction_header_2  csh_transaction_headers%ROWTYPE;
    v_write_off             csh_write_off%ROWTYPE;
    v_write_off_acc_desc    VARCHAR2(2000);
  BEGIN
    SELECT transaction_type, transaction_header_id
      INTO v_transaction_type, v_transaction_header_id
      FROM gl_account_entry e
     WHERE e.account_entry_id = p_entry_id;
  
    IF v_transaction_type = gl_account_segment_pkg.g_rule_type_exp_report THEN
      RETURN '报销';
    ELSIF v_transaction_type =
          gl_account_segment_pkg.g_rule_type_csh_transaction THEN
      SELECT *
        INTO v_transaction_header_1
        FROM csh_transaction_headers h
       WHERE h.transaction_header_id = v_transaction_header_id;
    
      --现金事务头反冲标志为空或者为W(被反冲事务),直接判断该事务的状态
      IF v_transaction_header_1.reversed_flag IS NULL OR
         v_transaction_header_1.reversed_flag = 'W' THEN
        --如果单据头上的反冲状态来判断，
        --R状态说明是退款，其他状态(N\Y\C)为付款事务
        IF v_transaction_header_1.returned_flag = 'R' THEN
          RETURN '还款';
        ELSE
          RETURN '付款';
        END IF;
      ELSIF v_transaction_header_1.reversed_flag = 'R' THEN
        --如果当前事务是反冲事务，根据原事务状态来判断本事务的凭证类别
        SELECT h.*
          INTO v_transaction_header_2
          FROM csh_transaction_headers h
         WHERE h.transaction_header_id =
               v_transaction_header_1.source_header_id;
        --如果单据头上的反冲状态来判断，
        --R状态说明是退款，其他状态(N\Y\C)为付款事务
        IF v_transaction_header_2.returned_flag = 'R' THEN
          RETURN '还款';
        ELSE
          RETURN '付款';
        END IF;
      END IF;
    ELSIF v_transaction_type =
          gl_account_segment_pkg.g_rule_type_csh_write_off THEN
      SELECT *
        INTO v_write_off
        FROM csh_write_off cwo
       WHERE cwo.write_off_id = v_transaction_header_id;
    
      SELECT a.description
        INTO v_write_off_acc_desc
        FROM csh_write_off_accounts a
       WHERE a.write_off_id = v_write_off.write_off_id
         AND rownum = 1;
    
      IF v_write_off_acc_desc = '预付款核销反冲' THEN
        RETURN '核销反冲';
      ELSE
        RETURN '报销';
      END IF;
    
    ELSIF v_transaction_type =
          gl_account_segment_pkg.g_rule_type_csh_pmt_req THEN
      RETURN '借款';
    ELSIF v_transaction_type =
          gl_account_segment_pkg.g_rule_type_work_order THEN
      RETURN '核算工单';
    ELSIF v_transaction_type = gl_account_segment_pkg.g_rule_type_eam_req THEN
      RETURN '资产事务';
    ELSIF v_transaction_type = gl_account_segment_pkg.g_rule_type_eam_deprn THEN
      RETURN '资产折旧';
    END IF;
  END get_user_je_category_name;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/10/19 19:02:39
  -- Ver     : 1.1
  -- Purpose : 获取CCID
  -- In Para :
        p_concat_segments       组合过的segments
     Return  : ccid校验结果
  **************************************************/
  FUNCTION validate_ccid(p_concat_segments VARCHAR) RETURN VARCHAR2 IS
    v_error_msg  VARCHAR2(2000);
    v_ebs_sob_id NUMBER;
    e_ebs_sob_not_exists EXCEPTION;
  BEGIN
    --获取EBS的帐套ID
    /*begin
      select m.ebs_set_of_books_id
        into v_ebs_sob_id
        from ebs_set_of_books_mapping m, gld_set_of_books b
       where m.hec_set_of_books_id = b.set_of_books_id
         and b.set_of_books_code = 'JKL_ACC';
    exception
      when no_data_found then
        raise e_ebs_sob_not_exists;
    end;
    
    v_error_msg := substr(cux_gl_interface_utl.check_gl_account(p_concat_segments,
                                                                cux_gl_utl.g_coa_id(v_ebs_sob_id)),
                          1,
                          2000);*/
    RETURN v_error_msg;
  EXCEPTION
    WHEN e_ebs_sob_not_exists THEN
      v_error_msg := '[ERP]交叉验证规则调用异常:费控系统中未配置EBS帐套映射';
      RETURN v_error_msg;
    WHEN OTHERS THEN
      v_error_msg := '[ERP]交叉验证规则调用异常:' || SQLERRM || chr(10) ||
                     dbms_utility.format_error_backtrace;
      RETURN v_error_msg;
  END validate_ccid;

  FUNCTION get_batch_code RETURN VARCHAR2 IS
    v_batch_code VARCHAR2(50);
  BEGIN
  
    SELECT 'HEC' || to_char(SYSDATE, 'YYYYMMDD') ||
           to_char(cux_gl_batch_num_s.nextval, 'FM000000000')
      INTO v_batch_code
      FROM dual;
    RETURN v_batch_code;
  END;

  --将分录表中的数据导入到接口表中
  PROCEDURE import_entry_to_interface IS
    v_set_of_books_id          NUMBER;
    v_user_je_category_name    VARCHAR2(200);
    v_currency_conversion_date DATE;
    v_currency_conversion_rate NUMBER;
    v_period_name              VARCHAR2(30);
    v_accounting_period_num    NUMBER;
    v_reference4               VARCHAR2(200);
    v_interface_id             NUMBER;
    v_accounting_date          DATE;
    v_currency_code            VARCHAR2(30);
    v_currency_conversion_type VARCHAR2(30);
    v_company_id               NUMBER;
  BEGIN
    gl_log_pkg.log(p_log_text => '分录表数据传接口表-开始',
                   p_user_id  => -1);
    lock_entry;
  
    gl_log_pkg.log(p_log_text => '批量支付凭证合并', p_user_id => -1);
    --根据资金回传的支付批次号做分组，进行凭证合并
    /*FOR batch_pay_entrys IN (SELECT e.segment20
                               FROM gl_account_entry e
                              WHERE e.imported_flag = 'P'
                                AND e.transaction_type = 'CSH_TRANSACTION'
                                AND e.segment20 IS NOT NULL
                                AND e.attribute3 IS NOT NULL
                              GROUP BY e.segment20) LOOP
    
      gl_log_pkg.log(p_log_text => '资金批次号为:' || batch_pay_entrys.segment20,
                     p_user_id  => -1);
    
      v_reference4 := get_pay_reference4(batch_pay_entrys.segment20);
    
      gl_log_pkg.log(p_log_text => 'Reference4:' || v_reference4,
                     p_user_id  => -1);
      --借方按照明细行插入
      FOR entrys IN (SELECT e.account_entry_id,
                            get_interface_id AS gl_interface_id,
                            --批次ID
                            NULL AS batch_id,
                            --批次描述
                            NULL AS batch_description,
                            'NEW' AS status,
                            --帐套ID
                            (SELECT set_of_books_id
                               FROM gld_set_of_books b
                              WHERE b.set_of_books_code = e.hec_sob_code) AS set_of_books_id,
                            --凭证日期
                            e.accounting_date AS accounting_date,
                            --币种
                            e.currency_code AS currency_code,
                            --凭证类别描述
                            get_user_je_category_name(e.account_entry_id) AS user_je_category_name,
                            --来源名称,费控系统
                            --update by lyh 修改为 报账通系统
                            '报账通系统' AS user_je_source_name,
                            --汇率日期
                            e.currency_conversion_date AS currency_conversion_date,
                            --币种汇率类型
                            'USER' AS user_currency_conversion_type,
                            --汇率
                            e.currency_conversion_rate AS currency_conversion_rate,
                            --公司段代码
                            e.segment1,
                            --部门段代码
                            e.segment2,
                            --科目段代码
                            e.segment3,
                            --明细段代码
                            e.segment4,
                            --关联单位段
                            e.segment5,
                            --产品段
                            e.segment6,
                            --渠道段
                            e.segment7,
                            --资金段
                            e.segment8,
                            --现金流量
                            e.segment9,
                            --备用1
                            e.segment10,
                            --备用2
                            e.segment11,
                            --属性12
                            e.segment12,
                            --属性13
                            e.segment13,
                            --属性14
                            e.segment14,
                            --属性15
                            e.segment15,
                            --属性16
                            e.segment16,
                            --属性17
                            e.segment17,
                            --属性18
                            e.segment18,
                            --属性19
                            e.segment19,
                            --属性20
                            e.segment20,
                            --本币借方金额
                            e.entered_amount_dr AS entered_dr,
                            --本币贷方金额
                            e.entered_amount_cr AS entered_cr,
                            --借方会计科目
                            e.functional_amount_dr AS accounted_dr,
                            --贷方会计科目
                            e.functional_amount_cr AS accounted_cr,
                            --期间
                            e.period_name,
                            --组编码
                            NULL AS group_id,
                            NULL AS reference1,
                            NULL AS reference2,
                            v_reference4 AS reference4,
                            NULL AS reference5,
                            NULL AS reference6,
                            NULL AS reference7,
                            NULL AS reference8,
                            NULL AS reference9,
                            NULL AS reference10,
                            NULL AS attribute1,
                            NULL AS attribute2,
                            NULL AS attribute3,
                            NULL AS attribute4,
                            NULL AS attribute5,
                            NULL AS attribute6,
                            NULL AS attribute7,
                            NULL AS attribute8,
                            NULL AS attribute9,
                            NULL AS attribute10,
                            NULL AS attribute11,
                            NULL AS attribute12,
                            NULL AS attribute13,
                            NULL AS attribute14,
                            NULL AS attribute15,
                            NULL AS attribute16,
                            NULL AS attribute17,
                            NULL AS attribute18,
                            NULL AS attribute19,
                            NULL AS attribute20,
                            substrb(e.line_description, 1, 240) AS line_desc,
                            gld_common_pkg.get_gld_internal_period_num(e.company_id,
                                                                       e.period_name) AS accounting_period_num,
                            e.currency_conversion_type AS currency_conversion_type,
                            --分为以下种状态：
                            --N：未传送
                            --U：已导入EBS
                            --S：成功导入日记账
                            --E：错误
                            'N' AS imported_flag,
                            NULL AS gl_transfer_run_id,
                            NULL AS gl_request_id,
                            NULL AS gl_transfer_login,
                            NULL AS process_date,
                            NULL AS error_status,
                            NULL AS error_description,
                            NULL AS je_batch_id,
                            NULL AS je_header_id,
                            NULL AS je_line_num,
                            NULL AS code_combination_id,
                            SYSDATE AS creation_date,
                            1 AS created_by,
                            SYSDATE AS last_update_date,
                            1 AS last_update_by,
                            NULL AS last_update_login,
                            e.company_id AS hec_company_id
                       FROM gl_account_entry e
                      WHERE e.imported_flag = 'P'
                        AND e.segment20 = batch_pay_entrys.segment20
                        AND e.attribute3 != 'CASH_ACCOUNT') LOOP
      
        gl_log_pkg.log(p_log_text => '支付凭证非现金凭证行不进行合并,EntryId:' ||
                                     entrys.account_entry_id ||
                                     ',对应InterfaceId:' ||
                                     entrys.gl_interface_id,
                       p_user_id  => -1);
      
        --插入费控系统内接口表
        INSERT INTO ebs_hec_gl_interface
          (gl_interface_id,
           batch_id,
           batch_description,
           status,
           set_of_books_id,
           accounting_date,
           currency_code,
           user_je_category_name,
           user_je_source_name,
           currency_conversion_date,
           user_currency_conversion_type,
           currency_conversion_rate,
           segment1,
           segment2,
           segment3,
           segment4,
           segment5,
           segment6,
           segment7,
           segment8,
           segment9,
           segment10,
           segment11,
           segment12,
           segment13,
           segment14,
           segment15,
           segment16,
           segment17,
           segment18,
           segment19,
           segment20,
           entered_dr,
           entered_cr,
           accounted_dr,
           accounted_cr,
           period_name,
           group_id,
           reference1,
           reference2,
           reference4,
           reference5,
           reference6,
           reference7,
           reference8,
           reference9,
           reference10,
           attribute1,
           attribute2,
           attribute3,
           attribute4,
           attribute5,
           attribute6,
           attribute7,
           attribute8,
           attribute9,
           attribute10,
           attribute11,
           attribute12,
           attribute13,
           attribute14,
           attribute15,
           attribute16,
           attribute17,
           attribute18,
           attribute19,
           attribute20,
           line_desc,
           accounting_period_num,
           currency_conversion_type,
           imported_flag,
           gl_transfer_run_id,
           gl_request_id,
           gl_transfer_login,
           process_date,
           error_status,
           error_description,
           je_batch_id,
           je_header_id,
           je_line_num,
           code_combination_id,
           creation_date,
           created_by,
           last_update_date,
           last_update_by,
           last_update_login,
           hec_company_id)
        VALUES
          (entrys.gl_interface_id,
           entrys.batch_id,
           entrys.batch_description,
           entrys.status,
           entrys.set_of_books_id,
           entrys.accounting_date,
           entrys.currency_code,
           entrys.user_je_category_name,
           entrys.user_je_source_name,
           entrys.currency_conversion_date,
           entrys.user_currency_conversion_type,
           entrys.currency_conversion_rate,
           entrys.segment1,
           entrys.segment2,
           entrys.segment3,
           entrys.segment4,
           entrys.segment5,
           entrys.segment6,
           entrys.segment7,
           entrys.segment8,
           entrys.segment9,
           entrys.segment10,
           entrys.segment11,
           entrys.segment12,
           entrys.segment13,
           entrys.segment14,
           entrys.segment15,
           entrys.segment16,
           entrys.segment17,
           entrys.segment18,
           entrys.segment19,
           entrys.segment20,
           entrys.entered_dr,
           entrys.entered_cr,
           entrys.accounted_dr,
           entrys.accounted_cr,
           entrys.period_name,
           entrys.group_id,
           entrys.reference1,
           entrys.reference2,
           entrys.reference4,
           entrys.reference5,
           entrys.reference6,
           entrys.reference7,
           entrys.reference8,
           entrys.reference9,
           entrys.reference10,
           entrys.attribute1,
           entrys.attribute2,
           entrys.attribute3,
           entrys.attribute4,
           entrys.attribute5,
           entrys.attribute6,
           entrys.attribute7,
           entrys.attribute8,
           entrys.attribute9,
           entrys.attribute10,
           entrys.attribute11,
           entrys.attribute12,
           entrys.attribute13,
           entrys.attribute14,
           entrys.attribute15,
           entrys.attribute16,
           entrys.attribute17,
           entrys.attribute18,
           entrys.attribute19,
           entrys.attribute20,
           entrys.line_desc,
           entrys.accounting_period_num,
           entrys.currency_conversion_type,
           entrys.imported_flag,
           entrys.gl_transfer_run_id,
           entrys.gl_request_id,
           entrys.gl_transfer_login,
           entrys.process_date,
           entrys.error_status,
           entrys.error_description,
           entrys.je_batch_id,
           entrys.je_header_id,
           entrys.je_line_num,
           entrys.code_combination_id,
           entrys.creation_date,
           entrys.created_by,
           entrys.last_update_date,
           entrys.last_update_by,
           entrys.last_update_login,
           entrys.hec_company_id);
      
        --更新entry表中的导入状态
        UPDATE gl_account_entry e
           SET e.imported_flag   = 'T',
               e.gl_interface_id = entrys.gl_interface_id,
               e.import_date     = SYSDATE
         WHERE e.account_entry_id = entrys.account_entry_id;
      
      END LOOP;
    
      FOR csh_acc_entrys IN (SELECT e.segment1,
                                    e.segment3,
                                    e.segment4,
                                    e.segment9
                               FROM gl_account_entry e
                              WHERE e.segment20 = batch_pay_entrys.segment20
                                AND e.attribute3 = 'CASH_ACCOUNT'
                                AND e.imported_flag = 'P'
                              GROUP BY e.segment1,
                                       e.segment3,
                                       e.segment4,
                                       e.segment9) LOOP
      
        gl_log_pkg.log(p_log_text => '支付凭证现金凭证行按照公司段、科目段、明细段、现金流量段进行合并,Seg1:' ||
                                     csh_acc_entrys.segment1 || ',Seg3:' ||
                                     csh_acc_entrys.segment3 || ',Seg4:' ||
                                     csh_acc_entrys.segment4 || ',Seg9:' ||
                                     csh_acc_entrys.segment9,
                       p_user_id  => -1);
      
        SELECT currency_conversion_date,
               currency_conversion_rate,
               period_name,
               gld_common_pkg.get_gld_internal_period_num(e.company_id,
                                                          e.period_name),
               (SELECT set_of_books_id
                  FROM gld_set_of_books b
                 WHERE b.set_of_books_code = e.hec_sob_code),
               '付款',
               get_interface_id,
               e.accounting_date,
               e.currency_code,
               e.currency_conversion_type,
               e.company_id
          INTO v_currency_conversion_date,
               v_currency_conversion_rate,
               v_period_name,
               v_accounting_period_num,
               v_set_of_books_id,
               v_user_je_category_name,
               v_interface_id,
               v_accounting_date,
               v_currency_code,
               v_currency_conversion_type,
               v_company_id
          FROM gl_account_entry e
         WHERE e.segment1 = csh_acc_entrys.segment1
           AND e.segment3 = csh_acc_entrys.segment3
           AND e.segment4 = csh_acc_entrys.segment4
           AND e.segment9 = csh_acc_entrys.segment9
           AND e.segment20 = batch_pay_entrys.segment20
           AND e.imported_flag = 'P'
           AND rownum = 1;
      
        --其他凭证按明细插入interface表
        FOR entrys IN (SELECT v_interface_id AS gl_interface_id,
                              --批次ID
                              NULL AS batch_id,
                              --批次描述
                              NULL AS batch_description,
                              'NEW' AS status,
                              --帐套ID
                              v_set_of_books_id AS set_of_books_id,
                              --凭证日期
                              v_accounting_date AS accounting_date,
                              --币种
                              v_currency_code AS currency_code,
                              --凭证类别描述
                              v_user_je_category_name AS user_je_category_name,
                              --来源名称,费控系统
                              --update by lyh 修改为 报账通系统
                              '报账通系统' AS user_je_source_name,
                              --汇率日期
                              v_currency_conversion_date AS currency_conversion_date,
                              --币种汇率类型
                              'USER' AS user_currency_conversion_type,
                              --汇率
                              v_currency_conversion_rate AS currency_conversion_rate,
                              --公司段代码
                              e.segment1,
                              --部门段代码
                              '0' AS segment2,
                              --科目段代码
                              e.segment3,
                              --明细段代码
                              e.segment4,
                              --关联单位段
                              '0' AS segment5,
                              --产品段
                              '0' AS segment6,
                              --渠道段
                              '0' AS segment7,
                              --资金段
                              '0' AS segment8,
                              --现金流量
                              e.segment9,
                              --备用1
                              '0' AS segment10,
                              --备用2
                              '0' AS segment11,
                              --属性12
                              NULL AS segment12,
                              --属性13
                              NULL AS segment13,
                              --属性14
                              NULL AS segment14,
                              --属性15
                              NULL AS segment15,
                              --属性16
                              NULL AS segment16,
                              --属性17
                              NULL AS segment17,
                              --属性18
                              NULL AS segment18,
                              --属性19
                              NULL AS segment19,
                              --资金支付批次
                              e.segment20 AS segment20,
                              --本币借方金额
                              NULL AS entered_dr,
                              --本币贷方金额
                              SUM(nvl(e.entered_amount_cr, 0)) AS entered_cr,
                              --借方会计科目
                              NULL AS accounted_dr,
                              --贷方会计科目
                              SUM(nvl(e.functional_amount_cr, 0)) AS accounted_cr,
                              --期间
                              v_period_name AS period_name,
                              --组编码
                              NULL AS group_id,
                              NULL AS reference1,
                              NULL AS reference2,
                              v_reference4 AS reference4,
                              NULL AS reference5,
                              NULL AS reference6,
                              NULL AS reference7,
                              NULL AS reference8,
                              NULL AS reference9,
                              NULL AS reference10,
                              NULL AS attribute1,
                              NULL AS attribute2,
                              NULL AS attribute3,
                              NULL AS attribute4,
                              NULL AS attribute5,
                              NULL AS attribute6,
                              NULL AS attribute7,
                              NULL AS attribute8,
                              NULL AS attribute9,
                              NULL AS attribute10,
                              NULL AS attribute11,
                              NULL AS attribute12,
                              NULL AS attribute13,
                              NULL AS attribute14,
                              NULL AS attribute15,
                              NULL AS attribute16,
                              NULL AS attribute17,
                              NULL AS attribute18,
                              NULL AS attribute19,
                              NULL AS attribute20,
                              '资金支付' AS line_desc,
                              v_accounting_period_num AS accounting_period_num,
                              v_currency_conversion_type AS currency_conversion_type,
                              --分为以下种状态：
                              --N：未传送
                              --U：已导入EBS
                              --S：成功导入日记账
                              --E：错误
                              'N' AS imported_flag,
                              NULL AS gl_transfer_run_id,
                              NULL AS gl_request_id,
                              NULL AS gl_transfer_login,
                              NULL AS process_date,
                              NULL AS error_status,
                              NULL AS error_description,
                              NULL AS je_batch_id,
                              NULL AS je_header_id,
                              NULL AS je_line_num,
                              NULL AS code_combination_id,
                              SYSDATE AS creation_date,
                              1 AS created_by,
                              SYSDATE AS last_update_date,
                              1 AS last_update_by,
                              NULL AS last_update_login,
                              e.company_id AS hec_company_id
                         FROM gl_account_entry e
                        WHERE e.imported_flag = 'P'
                          AND e.segment1 = csh_acc_entrys.segment1
                          AND e.segment4 = csh_acc_entrys.segment4
                          AND e.segment9 = csh_acc_entrys.segment9
                          AND e.segment20 = batch_pay_entrys.segment20
                          AND e.attribute3 = 'CASH_ACCOUNT'
                        GROUP BY segment1,
                                 segment3,
                                 segment4,
                                 segment9,
                                 segment20,
                                 company_id) LOOP
        
          gl_log_pkg.log(p_log_text => '支付凭证现金凭证行合并之后的本币贷方金额:' ||
                                       entrys.entered_cr || '，原币贷方金额:' ||
                                       entrys.accounted_cr,
                         p_user_id  => -1);
        
          --插入费控系统内接口表
          INSERT INTO ebs_hec_gl_interface
            (gl_interface_id,
             batch_id,
             batch_description,
             status,
             set_of_books_id,
             accounting_date,
             currency_code,
             user_je_category_name,
             user_je_source_name,
             currency_conversion_date,
             user_currency_conversion_type,
             currency_conversion_rate,
             segment1,
             segment2,
             segment3,
             segment4,
             segment5,
             segment6,
             segment7,
             segment8,
             segment9,
             segment10,
             segment11,
             segment12,
             segment13,
             segment14,
             segment15,
             segment16,
             segment17,
             segment18,
             segment19,
             segment20,
             entered_dr,
             entered_cr,
             accounted_dr,
             accounted_cr,
             period_name,
             group_id,
             reference1,
             reference2,
             reference4,
             reference5,
             reference6,
             reference7,
             reference8,
             reference9,
             reference10,
             attribute1,
             attribute2,
             attribute3,
             attribute4,
             attribute5,
             attribute6,
             attribute7,
             attribute8,
             attribute9,
             attribute10,
             attribute11,
             attribute12,
             attribute13,
             attribute14,
             attribute15,
             attribute16,
             attribute17,
             attribute18,
             attribute19,
             attribute20,
             line_desc,
             accounting_period_num,
             currency_conversion_type,
             imported_flag,
             gl_transfer_run_id,
             gl_request_id,
             gl_transfer_login,
             process_date,
             error_status,
             error_description,
             je_batch_id,
             je_header_id,
             je_line_num,
             code_combination_id,
             creation_date,
             created_by,
             last_update_date,
             last_update_by,
             last_update_login,
             hec_company_id)
          VALUES
            (entrys.gl_interface_id,
             entrys.batch_id,
             entrys.batch_description,
             entrys.status,
             entrys.set_of_books_id,
             entrys.accounting_date,
             entrys.currency_code,
             entrys.user_je_category_name,
             entrys.user_je_source_name,
             entrys.currency_conversion_date,
             entrys.user_currency_conversion_type,
             entrys.currency_conversion_rate,
             entrys.segment1,
             entrys.segment2,
             entrys.segment3,
             entrys.segment4,
             entrys.segment5,
             entrys.segment6,
             entrys.segment7,
             entrys.segment8,
             entrys.segment9,
             entrys.segment10,
             entrys.segment11,
             entrys.segment12,
             entrys.segment13,
             entrys.segment14,
             entrys.segment15,
             entrys.segment16,
             entrys.segment17,
             entrys.segment18,
             entrys.segment19,
             entrys.segment20,
             entrys.entered_dr,
             entrys.entered_cr,
             entrys.accounted_dr,
             entrys.accounted_cr,
             entrys.period_name,
             entrys.group_id,
             entrys.reference1,
             entrys.reference2,
             entrys.reference4,
             entrys.reference5,
             entrys.reference6,
             entrys.reference7,
             entrys.reference8,
             entrys.reference9,
             entrys.reference10,
             entrys.attribute1,
             entrys.attribute2,
             entrys.attribute3,
             entrys.attribute4,
             entrys.attribute5,
             entrys.attribute6,
             entrys.attribute7,
             entrys.attribute8,
             entrys.attribute9,
             entrys.attribute10,
             entrys.attribute11,
             entrys.attribute12,
             entrys.attribute13,
             entrys.attribute14,
             entrys.attribute15,
             entrys.attribute16,
             entrys.attribute17,
             entrys.attribute18,
             entrys.attribute19,
             entrys.attribute20,
             entrys.line_desc,
             entrys.accounting_period_num,
             entrys.currency_conversion_type,
             entrys.imported_flag,
             entrys.gl_transfer_run_id,
             entrys.gl_request_id,
             entrys.gl_transfer_login,
             entrys.process_date,
             entrys.error_status,
             entrys.error_description,
             entrys.je_batch_id,
             entrys.je_header_id,
             entrys.je_line_num,
             entrys.code_combination_id,
             entrys.creation_date,
             entrys.created_by,
             entrys.last_update_date,
             entrys.last_update_by,
             entrys.last_update_login,
             entrys.hec_company_id);
        
        END LOOP;
        --更新entry表中的导入状态
        UPDATE gl_account_entry e
           SET e.imported_flag   = 'T',
               e.gl_interface_id = v_interface_id,
               e.import_date     = SYSDATE
         WHERE e.imported_flag = 'P'
           AND e.segment1 = csh_acc_entrys.segment1
           AND e.segment3 = csh_acc_entrys.segment3
           AND e.segment4 = csh_acc_entrys.segment4
           AND e.segment9 = csh_acc_entrys.segment9
           AND e.segment20 = batch_pay_entrys.segment20
           AND e.attribute3 = 'CASH_ACCOUNT'
           AND e.entered_amount_cr IS NOT NULL;
      END LOOP;
    END LOOP;*/
  
    gl_log_pkg.log(p_log_text => '非批量支付凭证按照明细过账',
                   p_user_id  => -1);
  
    --其他凭证按照
    FOR entrys IN (SELECT e.account_entry_id,
                          get_interface_id AS gl_interface_id,
                          --批次ID
                          NULL AS batch_id,
                          --批次描述
                          NULL AS batch_description,
                          'NEW' AS status,
                          --帐套ID
                          (SELECT set_of_books_id
                             FROM gld_set_of_books b
                            WHERE b.set_of_books_code = e.hec_sob_code) AS set_of_books_id,
                          --凭证日期
                          e.accounting_date AS accounting_date,
                          --币种
                          e.currency_code AS currency_code,
                          --凭证类别描述
                          get_user_je_category_name(e.account_entry_id) AS user_je_category_name,
                          --来源名称,费控系统
                          --update by lyh 修改为 报账通系统
                          '报账通系统' AS user_je_source_name,
                          --汇率日期
                          e.currency_conversion_date AS currency_conversion_date,
                          --币种汇率类型
                          'USER' AS user_currency_conversion_type,
                          --汇率
                          e.currency_conversion_rate AS currency_conversion_rate,
                          --公司段代码
                          e.segment1,
                          --部门段代码
                          e.segment2,
                          --科目段代码
                          e.segment3,
                          --明细段代码
                          e.segment4,
                          --关联单位段
                          e.segment5,
                          --产品段
                          e.segment6,
                          --渠道段
                          e.segment7,
                          --资金段
                          e.segment8,
                          --现金流量
                          e.segment9,
                          --备用1
                          e.segment10,
                          --备用2
                          e.segment11,
                          --属性12
                          e.segment12,
                          --属性13
                          e.segment13,
                          --属性14
                          e.segment14,
                          --属性15
                          e.segment15,
                          --属性16
                          e.segment16,
                          --属性17
                          e.segment17,
                          --属性18
                          e.segment18,
                          --属性19
                          e.segment19,
                          --属性20
                          e.segment20,
                          --本币借方金额
                          e.entered_amount_dr AS entered_dr,
                          --本币贷方金额
                          e.entered_amount_cr AS entered_cr,
                          --借方会计科目
                          e.functional_amount_dr AS accounted_dr,
                          --贷方会计科目
                          e.functional_amount_cr AS accounted_cr,
                          --期间
                          e.period_name,
                          --组编码
                          NULL AS group_id,
                          NULL AS reference1,
                          NULL AS reference2,
                          get_reference4(e.account_entry_id) AS reference4,
                          NULL AS reference5,
                          NULL AS reference6,
                          NULL AS reference7,
                          NULL AS reference8,
                          NULL AS reference9,
                          NULL AS reference10,
                          NULL AS attribute1,
                          NULL AS attribute2,
                          NULL AS attribute3,
                          NULL AS attribute4,
                          NULL AS attribute5,
                          NULL AS attribute6,
                          NULL AS attribute7,
                          NULL AS attribute8,
                          NULL AS attribute9,
                          NULL AS attribute10,
                          NULL AS attribute11,
                          NULL AS attribute12,
                          NULL AS attribute13,
                          NULL AS attribute14,
                          NULL AS attribute15,
                          NULL AS attribute16,
                          NULL AS attribute17,
                          NULL AS attribute18,
                          NULL AS attribute19,
                          NULL AS attribute20,
                          substrb(e.line_description, 1, 240) AS line_desc,
                          gld_common_pkg.get_gld_internal_period_num(e.company_id,
                                                                     e.period_name) AS accounting_period_num,
                          e.currency_conversion_type AS currency_conversion_type,
                          --分为以下种状态：
                          --N：未传送
                          --U：已导入EBS
                          --S：成功导入日记账
                          --E：错误
                          'N' AS imported_flag,
                          NULL AS gl_transfer_run_id,
                          NULL AS gl_request_id,
                          NULL AS gl_transfer_login,
                          NULL AS process_date,
                          NULL AS error_status,
                          NULL AS error_description,
                          NULL AS je_batch_id,
                          NULL AS je_header_id,
                          NULL AS je_line_num,
                          NULL AS code_combination_id,
                          SYSDATE AS creation_date,
                          1 AS created_by,
                          SYSDATE AS last_update_date,
                          1 AS last_update_by,
                          NULL AS last_update_login,
                          e.company_id AS hec_company_id
                     FROM gl_account_entry e
                    WHERE e.imported_flag = 'P') LOOP
    
      gl_log_pkg.log(p_log_text => 'EntryId:' || entrys.account_entry_id ||
                                   ',对应InterfaceId:' ||
                                   entrys.gl_interface_id,
                     p_user_id  => -1);
    
      --插入费控系统内接口表
      INSERT INTO ebs_hec_gl_interface
        (gl_interface_id,
         batch_id,
         batch_description,
         status,
         set_of_books_id,
         accounting_date,
         currency_code,
         user_je_category_name,
         user_je_source_name,
         currency_conversion_date,
         user_currency_conversion_type,
         currency_conversion_rate,
         segment1,
         segment2,
         segment3,
         segment4,
         segment5,
         segment6,
         segment7,
         segment8,
         segment9,
         segment10,
         segment11,
         segment12,
         segment13,
         segment14,
         segment15,
         segment16,
         segment17,
         segment18,
         segment19,
         segment20,
         entered_dr,
         entered_cr,
         accounted_dr,
         accounted_cr,
         period_name,
         group_id,
         reference1,
         reference2,
         reference4,
         reference5,
         reference6,
         reference7,
         reference8,
         reference9,
         reference10,
         attribute1,
         attribute2,
         attribute3,
         attribute4,
         attribute5,
         attribute6,
         attribute7,
         attribute8,
         attribute9,
         attribute10,
         attribute11,
         attribute12,
         attribute13,
         attribute14,
         attribute15,
         attribute16,
         attribute17,
         attribute18,
         attribute19,
         attribute20,
         line_desc,
         accounting_period_num,
         currency_conversion_type,
         imported_flag,
         gl_transfer_run_id,
         gl_request_id,
         gl_transfer_login,
         process_date,
         error_status,
         error_description,
         je_batch_id,
         je_header_id,
         je_line_num,
         code_combination_id,
         creation_date,
         created_by,
         last_update_date,
         last_update_by,
         last_update_login,
         hec_company_id)
      VALUES
        (entrys.gl_interface_id,
         entrys.batch_id,
         entrys.batch_description,
         entrys.status,
         entrys.set_of_books_id,
         entrys.accounting_date,
         entrys.currency_code,
         entrys.user_je_category_name,
         entrys.user_je_source_name,
         entrys.currency_conversion_date,
         entrys.user_currency_conversion_type,
         entrys.currency_conversion_rate,
         entrys.segment1,
         entrys.segment2,
         entrys.segment3,
         entrys.segment4,
         entrys.segment5,
         entrys.segment6,
         entrys.segment7,
         entrys.segment8,
         entrys.segment9,
         entrys.segment10,
         entrys.segment11,
         entrys.segment12,
         entrys.segment13,
         entrys.segment14,
         entrys.segment15,
         entrys.segment16,
         entrys.segment17,
         entrys.segment18,
         entrys.segment19,
         entrys.segment20,
         entrys.entered_dr,
         entrys.entered_cr,
         entrys.accounted_dr,
         entrys.accounted_cr,
         entrys.period_name,
         entrys.group_id,
         entrys.reference1,
         entrys.reference2,
         entrys.reference4,
         entrys.reference5,
         entrys.reference6,
         entrys.reference7,
         entrys.reference8,
         entrys.reference9,
         entrys.reference10,
         entrys.attribute1,
         entrys.attribute2,
         entrys.attribute3,
         entrys.attribute4,
         entrys.attribute5,
         entrys.attribute6,
         entrys.attribute7,
         entrys.attribute8,
         entrys.attribute9,
         entrys.attribute10,
         entrys.attribute11,
         entrys.attribute12,
         entrys.attribute13,
         entrys.attribute14,
         entrys.attribute15,
         entrys.attribute16,
         entrys.attribute17,
         entrys.attribute18,
         entrys.attribute19,
         entrys.attribute20,
         entrys.line_desc,
         entrys.accounting_period_num,
         entrys.currency_conversion_type,
         entrys.imported_flag,
         entrys.gl_transfer_run_id,
         entrys.gl_request_id,
         entrys.gl_transfer_login,
         entrys.process_date,
         entrys.error_status,
         entrys.error_description,
         entrys.je_batch_id,
         entrys.je_header_id,
         entrys.je_line_num,
         entrys.code_combination_id,
         entrys.creation_date,
         entrys.created_by,
         entrys.last_update_date,
         entrys.last_update_by,
         entrys.last_update_login,
         entrys.hec_company_id);
    
      --更新entry表中的导入状态
      UPDATE gl_account_entry e
         SET e.imported_flag   = 'T',
             e.gl_interface_id = entrys.gl_interface_id,
             e.import_date     = SYSDATE
       WHERE e.account_entry_id = entrys.account_entry_id;
    
    END LOOP;
  
    unlock_entry;
  
    gl_log_pkg.log(p_log_text => '分录表数据传接口表-结束',
                   p_user_id  => -1);
  EXCEPTION
    WHEN e_lock_table THEN
      NULL;
    WHEN OTHERS THEN
      unlock_entry;
      gl_log_pkg.log(p_log_text => SQLERRM || chr(10) ||
                                   dbms_utility.format_error_backtrace,
                     p_user_id  => -1);
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => SQLERRM ||
                                                                                  chr(10) ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => -1,
                                                     p_package_name            => 'cux_gl_interface_pkg',
                                                     p_procedure_function_name => 'import_entry_to_interface');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END import_entry_to_interface;

  /*************************************************
  -- Author  : Rick
  -- Created : 2017-6-23 09:45:56
  -- Ver     : 1.1
  -- Purpose : 插入EBS接口数据
  **************************************************/
  /*PROCEDURE insert_wlzq_interface(p_interface_id             NUMBER,
                                  p_je_source_name           VARCHAR2,
                                  p_je_category_name         VARCHAR2,
                                  p_status                   VARCHAR2,
                                  p_ledger_id                NUMBER,
                                  p_period_name              VARCHAR2,
                                  p_accounting_date          DATE,
                                  p_source_batch_code        VARCHAR2,
                                  p_source_line_id           NUMBER,
                                  p_segment1                 VARCHAR2,
                                  p_segment2                 VARCHAR2,
                                  p_segment3                 VARCHAR2,
                                  p_segment4                 VARCHAR2,
                                  p_segment5                 VARCHAR2,
                                  p_segment6                 VARCHAR2,
                                  p_segment7                 VARCHAR2,
                                  p_segment8                 VARCHAR2,
                                  p_segment9                 VARCHAR2,
                                  p_segment10                VARCHAR2,
                                  p_segment11                VARCHAR2,
                                  p_segment12                VARCHAR2,
                                  p_currency_code            VARCHAR2,
                                  p_functional_currency_code VARCHAR2,
                                  p_currency_conversion_date DATE,
                                  p_currency_conversion_rate NUMBER,
                                  p_currency_conversion_type VARCHAR2,
                                  p_actual_flag              VARCHAR2,
                                  p_entered_dr               NUMBER,
                                  p_entered_cr               NUMBER,
                                  p_accounted_dr             NUMBER,
                                  p_accounted_cr             NUMBER,
                                  p_send_date                DATE,
                                  p_process_date             DATE,
                                  p_process_flag             VARCHAR2,
                                  p_error_msg                VARCHAR2,
                                  p_doc_seq_num              VARCHAR2,
                                  p_request_id               NUMBER,
                                  p_group_id                 NUMBER,
                                  p_reference1               VARCHAR2,
                                  p_reference4               VARCHAR2,
                                  p_reference5               VARCHAR2,
                                  p_reference6               VARCHAR2,
                                  p_reference10              VARCHAR2,
                                  p_created_by               NUMBER,
                                  p_created_date             DATE,
                                  p_last_updated_by          NUMBER,
                                  p_last_updated_login       NUMBER,
                                  p_last_updated_date        DATE,
                                  p_je_batch_id              NUMBER,
                                  p_je_header_id             NUMBER,
                                  p_je_line_num              NUMBER,
                                  p_set_of_books_id          NUMBER,
                                  p_attribute_category       VARCHAR2,
                                  p_attribute1               VARCHAR2,
                                  p_attribute2               VARCHAR2,
                                  p_attribute3               VARCHAR2,
                                  p_attribute4               VARCHAR2,
                                  p_attribute5               VARCHAR2,
                                  p_attribute6               VARCHAR2,
                                  p_attribute7               VARCHAR2,
                                  p_attribute8               VARCHAR2,
                                  p_attribute9               VARCHAR2,
                                  p_attribute10              VARCHAR2,
                                  p_attribute11              VARCHAR2,
                                  p_attribute12              VARCHAR2,
                                  p_attribute13              VARCHAR2,
                                  p_attribute14              VARCHAR2,
                                  p_attribute15              VARCHAR2) IS
  BEGIN
    INSERT INTO cux_gl_interface_hec
      (interface_id,
       je_source_name,
       je_category_name,
       status,
       ledger_id,
       period_name,
       accounting_date,
       source_batch_code,
       source_line_id,
       segment1,
       segment2,
       segment3,
       segment4,
       segment5,
       segment6,
       segment7,
       segment8,
       segment9,
       segment10,
       segment11,
       segment12,
       currency_code,
       functional_currency_code,
       currency_conversion_date,
       currency_conversion_rate,
       user_currency_conversion_type,
       actual_flag,
       entered_dr,
       entered_cr,
       accounted_dr,
       accounted_cr,
       send_date,
       process_date,
       process_flag,
       error_msg,
       doc_seq_num,
       request_id,
       group_id,
       reference1,
       reference4,
       reference5,
       reference6,
       reference10,
       created_by,
       created_date,
       last_updated_by,
       last_updated_login,
       last_updated_date,
       je_batch_id,
       je_header_id,
       je_line_num,
       set_of_books_id,
       attribute_category,
       attribute1,
       attribute2,
       attribute3,
       attribute4,
       attribute5,
       attribute6,
       attribute7,
       attribute8,
       attribute9,
       attribute10,
       attribute11,
       attribute12,
       attribute13,
       attribute14,
       attribute15)
    VALUES
      (p_interface_id,
       p_je_source_name,
       p_je_category_name,
       p_status,
       p_ledger_id,
       p_period_name,
       p_accounting_date,
       p_source_batch_code,
       p_source_line_id,
       p_segment1,
       p_segment2,
       p_segment3,
       p_segment4,
       p_segment5,
       p_segment6,
       p_segment7,
       p_segment8,
       p_segment9,
       p_segment10,
       p_segment11,
       p_segment12,
       p_currency_code,
       p_functional_currency_code,
       p_currency_conversion_date,
       p_currency_conversion_rate,
       p_currency_conversion_type,
       p_actual_flag,
       p_entered_dr,
       p_entered_cr,
       p_accounted_dr,
       p_accounted_cr,
       p_send_date,
       p_process_date,
       p_process_flag,
       p_error_msg,
       p_doc_seq_num,
       p_request_id,
       p_group_id,
       p_reference1,
       p_reference4,
       p_reference5,
       p_reference6,
       p_reference10,
       p_created_by,
       p_created_date,
       p_last_updated_by,
       p_last_updated_login,
       p_last_updated_date,
       p_je_batch_id,
       p_je_header_id,
       p_je_line_num,
       p_set_of_books_id,
       p_attribute_category,
       p_attribute1,
       p_attribute2,
       p_attribute3,
       p_attribute4,
       p_attribute5,
       p_attribute6,
       p_attribute7,
       p_attribute8,
       p_attribute9,
       p_attribute10,
       p_attribute11,
       p_attribute12,
       p_attribute13,
       p_attribute14,
       p_attribute15);
  END insert_wlzq_interface;*/

  FUNCTION get_je_category_name(p_transaction_type VARCHAR2,
                                p_attribute_12     VARCHAR2) RETURN VARCHAR2 IS
    v_result VARCHAR2(100) := NULL;
  BEGIN
  
    IF (p_transaction_type = 'EXP_REPORT') THEN
      v_result := '费用报销';
    ELSIF (p_transaction_type = 'CSH_PMT_REQ') THEN
      v_result := '借款申请';
    ELSIF (p_transaction_type = 'CSH_WRITE_OFF') THEN
      IF (p_attribute_12 LIKE '__BX%') THEN
        v_result := '费用报销';
      END IF;
    ELSIF (p_transaction_type = 'WORK_ORDER') THEN
      v_result := '核算工单';
    ELSIF (p_transaction_type = 'CSH_TRANSACTION') THEN
      IF (p_attribute_12 LIKE '__BX%') THEN
        v_result := '费用报销';
      ELSIF (p_attribute_12 LIKE '__JK%') THEN
        v_result := '借款申请';
      ELSIF (p_attribute_12 LIKE '__FK%') THEN
        v_result := '费用报销';
      END IF;
    ELSIF (p_transaction_type = 'SPE_PAY_BANK_DETAILS') THEN
      v_result := '费用报销';
    ELSIF (p_transaction_type = 'SPE_GATHER_BANK_DETAILS') THEN
      v_result := '收入凭证';
    ELSIF (p_transaction_type = 'CAPITAL_ADJUST') THEN
      v_result := '资金调拨';
    END IF;
  
    IF (v_result IS NULL) THEN
      v_result := '其他';
    END IF;
  
    RETURN v_result;
  END get_je_category_name;

  --数据插入接口表
  /*PROCEDURE insert_into_interface(p_batch_code VARCHAR2,
                                  p_entry_data gl_account_entry%ROWTYPE) IS
    v_ledger_id   VARCHAR2(100);
    v_ledger_name VARCHAR2(100);
  BEGIN
    SELECT b.ledger_id, b.name
      INTO v_ledger_id, v_ledger_name
      FROM ebs_company_mapping m, fnd_companies_vl f, ebs_set_of_books_mv b
     WHERE m.hec_company_id = f.company_id
       AND m.ebs_set_of_books_id = b.ledger_id
       AND f.company_code = p_entry_data.segment1;
  
    insert_wlzq_interface(p_interface_id             => get_interface_id,
                          p_je_source_name           => '报账通系统',
                          p_je_category_name         => get_je_category_name(p_transaction_type => p_entry_data.transaction_type,
                                                                             p_attribute_12     => p_entry_data.attribute12),
                          p_status                   => 'NEW',
                          p_ledger_id                => v_ledger_id,
                          p_period_name              => p_entry_data.period_name,
                          p_accounting_date          => p_entry_data.accounting_date,
                          p_source_batch_code        => v_ledger_name || '_' ||
                                                        p_batch_code,
                          p_source_line_id           => p_entry_data.account_entry_id,
                          p_segment1                 => p_entry_data.segment1,
                          p_segment2                 => p_entry_data.segment2,
                          p_segment3                 => p_entry_data.segment3,
                          p_segment4                 => p_entry_data.segment4,
                          p_segment5                 => p_entry_data.segment5,
                          p_segment6                 => p_entry_data.segment6,
                          p_segment7                 => p_entry_data.segment7,
                          p_segment8                 => p_entry_data.segment8,
                          p_segment9                 => p_entry_data.segment9,
                          p_segment10                => p_entry_data.segment10,
                          p_segment11                => p_entry_data.segment11,
                          p_segment12                => p_entry_data.segment12,
                          p_currency_code            => p_entry_data.currency_code,
                          p_functional_currency_code => p_entry_data.currency_code,
                          p_currency_conversion_date => p_entry_data.currency_conversion_date,
                          p_currency_conversion_rate => p_entry_data.currency_conversion_rate,
                          p_currency_conversion_type => 'User',
                          p_actual_flag              => 'A',
                          p_entered_dr               => p_entry_data.entered_amount_dr,
                          p_entered_cr               => p_entry_data.entered_amount_cr,
                          p_accounted_dr             => p_entry_data.functional_amount_dr,
                          p_accounted_cr             => p_entry_data.functional_amount_cr,
                          p_send_date                => trunc(SYSDATE),
                          p_process_date             => NULL,
                          p_process_flag             => 'N',
                          p_error_msg                => NULL,
                          p_doc_seq_num              => NULL,
                          p_request_id               => NULL,
                          p_group_id                 => NULL,
                          p_reference1               => NULL,
                          p_reference4               => NULL,
                          p_reference5               => NULL,
                          p_reference6               => NULL,
                          p_reference10              => substrb(p_entry_data.line_description,
                                                                1,
                                                                100),
                          p_created_by               => NULL,
                          p_created_date             => SYSDATE,
                          p_last_updated_by          => NULL,
                          p_last_updated_login       => NULL,
                          p_last_updated_date        => NULL,
                          p_je_batch_id              => NULL,
                          p_je_header_id             => NULL,
                          p_je_line_num              => NULL,
                          p_set_of_books_id          => NULL,
                          p_attribute_category       => NULL,
                          p_attribute1               => p_entry_data.attribute11,
                          p_attribute2               => p_entry_data.attribute12,
                          p_attribute3               => NULL,
                          p_attribute4               => NULL,
                          p_attribute5               => NULL,
                          p_attribute6               => NULL,
                          p_attribute7               => NULL,
                          p_attribute8               => NULL,
                          p_attribute9               => NULL,
                          p_attribute10              => NULL,
                          p_attribute11              => NULL,
                          p_attribute12              => NULL,
                          p_attribute13              => NULL,
                          p_attribute14              => NULL,
                          p_attribute15              => NULL);
  
    UPDATE gl_account_entry gae
       SET gae.batch_code    = v_ledger_name || '_' || p_batch_code,
           gae.imported_flag = 'U'
     WHERE gae.account_entry_id = p_entry_data.account_entry_id;
  
  END insert_into_interface;*/

  /*************************************************
  -- Author  : Rick
  -- Created : 2017-6-23 10:14:53
  -- Ver     : 1.1
  -- Purpose : 凭证过总账
  **************************************************/
  /*PROCEDURE post_to_wlzq_ebs(p_gl_date   VARCHAR2 DEFAULT NULL,
                             p_gl_status VARCHAR2 DEFAULT NULL) IS
    v_entry_datas entry_table;
    v_batch_code  VARCHAR2(50) := to_char(SYSDATE, 'yyyymmddhh24miss');
  
    CURSOR c1 IS
      SELECT *
        FROM cp_lock_assist cl
       WHERE cl.doc_type = 'POST_GL'
         AND cl.doc_id = 1
         FOR UPDATE NOWAIT;
  
    e_locked_error EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_locked_error, -54);
  BEGIN
    -- LOCK TABLE
    cp_lock_assist_pkg.insert_lock_info(1, 'POST_GL');
    OPEN c1;
  
    SELECT * BULK COLLECT
      INTO v_entry_datas
      FROM gl_account_entry e
     WHERE to_char(e.accounting_date, 'yyyy-mm-dd') =
           nvl(p_gl_date, to_char(e.accounting_date, 'yyyy-mm-dd'))
       AND e.imported_flag = nvl(p_gl_status, 'P')
       AND (e.batch_code IS NULL OR
            (p_gl_status = 'E' AND e.batch_code IS NOT NULL))
       FOR UPDATE NOWAIT;
  
    gl_log_pkg.log(p_log_text => '凭证过账程序-开始', p_user_id => -1);
  
    IF v_entry_datas.count > 0 THEN
      FOR i IN 1 .. v_entry_datas.count LOOP
        insert_into_interface(v_batch_code, v_entry_datas(i));
      END LOOP;
    
      --
      COMMIT;
    
      --通知EBS处理数据
      \*INSERT INTO cux_hec_data_ok
        SELECT 'Y', SYSDATE FROM dual;
    *\
    END IF;
  
    gl_log_pkg.log(p_log_text => '凭证过账程序-凭证传递EBS完毕,本次传送记录数:' ||
                                 v_entry_datas.count,
                   p_user_id  => -1);
  
    CLOSE c1;
  EXCEPTION
    WHEN e_locked_error THEN
      gl_log_pkg.log(p_log_text => '当前有请求在传送凭证,请稍后再试...',
                     p_user_id  => -1);
    
  END post_to_wlzq_ebs;*/

  /*************************************************
  -- Author  : RICK
  -- Created : 2017-10-19 14:00:50
  -- Purpose : 回传凭证编号
  **************************************************/
  /*PROCEDURE load_journal_number IS
  BEGIN
    UPDATE gl_account_entry gae
       SET gae.attribute13   =
           (SELECT reference6
              FROM cux_gl_interface_hec_history gl
             WHERE gl.source_batch_code = gae.batch_code
               AND gl.source_line_id = gae.account_entry_id),
           gae.journal_number =
           (SELECT doc_seq_num
              FROM cux_gl_interface_hec_history gl
             WHERE gl.source_batch_code = gae.batch_code
               AND gl.source_line_id = gae.account_entry_id)
    
     WHERE (gae.journal_number = '已创建日记账导入' or gae.journal_number is null or
           gae.journal_number = '已过帐但未生成新凭证')
       and gae.imported_flag = 'Y';
  END load_journal_number;*/

  /*PROCEDURE load_wlzq_gl_result IS
    v_interface_info cux_gl_interface_hec_history%ROWTYPE;
  BEGIN
    gl_log_pkg.log(p_log_text => '凭证结果回传程序-开始', p_user_id => -1);
  
    FOR c_hec_gl IN (SELECT *
                       FROM gl_account_entry t
                      WHERE t.imported_flag IN ('U')
                        FOR UPDATE NOWAIT) LOOP
      BEGIN
        SELECT *
          INTO v_interface_info
          from (select *
                  FROM cux_gl_interface_hec_history gl
                 WHERE gl.source_batch_code = c_hec_gl.batch_code
                   AND gl.source_line_id = c_hec_gl.account_entry_id
                   order by gl.process_flag desc) o
         where rownum = 1;
      EXCEPTION
        WHEN no_data_found THEN
          CONTINUE;
      END;
    
      --跟新EBS单据编号
      IF (v_interface_info.doc_seq_num IS NOT NULL) THEN
        UPDATE gl_account_entry gae
           SET gae.attribute13    = v_interface_info.reference6,
               gae.journal_number = v_interface_info.doc_seq_num
         WHERE gae.account_entry_id = c_hec_gl.account_entry_id;
      END IF;
    
      IF (v_interface_info.process_flag IN ('E', 'B')) THEN
        UPDATE gl_account_entry gae
           SET gae.imported_flag = 'E',
               gae.error_message = v_interface_info.error_msg
         WHERE gae.account_entry_id = c_hec_gl.account_entry_id;
      ELSIF (v_interface_info.process_flag = 'Y' \*AND
            v_interface_info.status = 'PROCESSED'*\) THEN
        UPDATE gl_account_entry gae
           SET gae.imported_flag = 'Y',
               gae.error_message = v_interface_info.error_msg
         WHERE gae.account_entry_id = c_hec_gl.account_entry_id;
      END IF;
    END LOOP;
  
    gl_log_pkg.log(p_log_text => '凭证结果回传程序-结束', p_user_id => -1);
  END load_wlzq_gl_result;*/

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/10/19 19:06:02
  -- Ver     : 1.1
  -- Purpose : 插入EBS接口数据
  **************************************************/
  PROCEDURE insert_ebs_interface(p_interface_id             NUMBER,
                                 p_status                   VARCHAR2,
                                 p_ledger_flag              VARCHAR2,
                                 p_accounting_date          DATE,
                                 p_currency_code            VARCHAR2,
                                 p_date_created             DATE,
                                 p_actual_flag              VARCHAR2,
                                 p_source_batch_id          VARCHAR2,
                                 p_source_line_id           NUMBER,
                                 p_user_je_category_name    VARCHAR2,
                                 p_user_je_source_name      VARCHAR2,
                                 p_currency_conversion_date DATE,
                                 p_user_cur_conversion_type VARCHAR2,
                                 p_currency_conversion_rate NUMBER,
                                 p_import_flag              VARCHAR2,
                                 p_import_date              DATE,
                                 p_error_message            VARCHAR2,
                                 p_last_update_date         DATE,
                                 p_doc_seq_num              VARCHAR2,
                                 p_created_by               VARCHAR2,
                                 p_last_update_by           VARCHAR2,
                                 p_segment1                 VARCHAR2,
                                 p_segment2                 VARCHAR2,
                                 p_segment3                 VARCHAR2,
                                 p_segment4                 VARCHAR2,
                                 p_segment5                 VARCHAR2,
                                 p_segment6                 VARCHAR2,
                                 p_segment7                 VARCHAR2,
                                 p_segment8                 VARCHAR2,
                                 p_segment9                 VARCHAR2,
                                 p_segment10                VARCHAR2,
                                 p_segment11                VARCHAR2,
                                 p_entered_dr               NUMBER,
                                 p_entered_cr               NUMBER,
                                 p_accounted_dr             NUMBER,
                                 p_accounted_cr             NUMBER,
                                 p_doc_sequence_value       NUMBER,
                                 p_reference1               VARCHAR2,
                                 p_reference2               VARCHAR2,
                                 p_reference3               VARCHAR2,
                                 p_reference4               VARCHAR2,
                                 p_reference5               VARCHAR2,
                                 p_reference10              VARCHAR2,
                                 p_je_batch_id              NUMBER,
                                 p_period_name              VARCHAR2,
                                 p_je_header_id             NUMBER,
                                 p_je_line_num              NUMBER,
                                 p_chart_of_accounts_id     NUMBER,
                                 p_functional_currency_code VARCHAR2,
                                 p_warning_code             VARCHAR2,
                                 p_stat_amount              NUMBER,
                                 p_group_id                 NUMBER,
                                 p_request_id               NUMBER,
                                 p_set_of_books_id          NUMBER,
                                 p_attribute_category       VARCHAR2,
                                 p_attribute1               VARCHAR2,
                                 p_attribute2               VARCHAR2,
                                 p_attribute3               VARCHAR2,
                                 p_attribute4               VARCHAR2,
                                 p_attribute5               VARCHAR2,
                                 p_attribute6               VARCHAR2,
                                 p_attribute7               VARCHAR2,
                                 p_attribute8               VARCHAR2,
                                 p_attribute9               VARCHAR2,
                                 p_attribute10              VARCHAR2,
                                 p_attribute11              VARCHAR2,
                                 p_attribute12              VARCHAR2,
                                 p_attribute13              VARCHAR2,
                                 p_attribute14              VARCHAR2,
                                 p_attribute15              VARCHAR2) IS
  BEGIN
    /*insert into cux_gl_interface_exp
      (interface_id,
       status,
       ledger_flag,
       accounting_date,
       currency_code,
       date_created,
       actual_flag,
       source_batch_id,
       source_line_id,
       user_je_category_name,
       user_je_source_name,
       currency_conversion_date,
       user_currency_conversion_type,
       currency_conversion_rate,
       import_flag,
       import_date,
       error_message,
       last_update_date,
       doc_seq_num,
       created_by,
       last_update_by,
       segment1,
       segment2,
       segment3,
       segment4,
       segment5,
       segment6,
       segment7,
       segment8,
       segment9,
       segment10,
       segment11,
       entered_dr,
       entered_cr,
       accounted_dr,
       accounted_cr,
       doc_sequence_value,
       reference1,
       reference2,
       reference3,
       reference4,
       reference5,
       reference10,
       je_batch_id,
       period_name,
       je_header_id,
       je_line_num,
       chart_of_accounts_id,
       functional_currency_code,
       warning_code,
       stat_amount,
       group_id,
       request_id,
       set_of_books_id,
       attribute_category,
       attribute1,
       attribute2,
       attribute3,
       attribute4,
       attribute5,
       attribute6,
       attribute7,
       attribute8,
       attribute9,
       attribute10,
       attribute11,
       attribute12,
       attribute13,
       attribute14,
       attribute15)
    values
      (p_interface_id,
       p_status,
       p_ledger_flag,
       p_accounting_date,
       p_currency_code,
       p_date_created,
       p_actual_flag,
       p_source_batch_id,
       p_source_line_id,
       p_user_je_category_name,
       p_user_je_source_name,
       p_currency_conversion_date,
       p_user_cur_conversion_type,
       p_currency_conversion_rate,
       p_import_flag,
       p_import_date,
       p_error_message,
       p_last_update_date,
       p_doc_seq_num,
       p_created_by,
       p_last_update_by,
       p_segment1,
       p_segment2,
       p_segment3,
       p_segment4,
       p_segment5,
       p_segment6,
       p_segment7,
       p_segment8,
       p_segment9,
       p_segment10,
       p_segment11,
       p_entered_dr,
       p_entered_cr,
       p_accounted_dr,
       p_accounted_cr,
       p_doc_sequence_value,
       p_reference1,
       p_reference2,
       p_reference3,
       p_reference4,
       p_reference5,
       p_reference10,
       p_je_batch_id,
       p_period_name,
       p_je_header_id,
       p_je_line_num,
       p_chart_of_accounts_id,
       p_functional_currency_code,
       p_warning_code,
       p_stat_amount,
       p_group_id,
       p_request_id,
       p_set_of_books_id,
       p_attribute_category,
       p_attribute1,
       p_attribute2,
       p_attribute3,
       p_attribute4,
       p_attribute5,
       p_attribute6,
       p_attribute7,
       p_attribute8,
       p_attribute9,
       p_attribute10,
       p_attribute11,
       p_attribute12,
       p_attribute13,
       p_attribute14,
       p_attribute15);*/
    NULL;
  END insert_ebs_interface;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/10/19 19:07:12
  -- Ver     : 1.1
  -- Purpose : 凭证过总账
  **************************************************/
  PROCEDURE post_to_ebs IS
    v_gl_batch_num VARCHAR2(50);
    e_ebs_sob_not_exists EXCEPTION;
  BEGIN
    gl_log_pkg.log(p_log_text => '凭证过账程序-开始', p_user_id => -1);
    --按公司进行凭证组批
    FOR comps IN (SELECT i.segment1
                    FROM ebs_hec_gl_interface i
                   WHERE i.imported_flag = 'N'
                   GROUP BY i.segment1) LOOP
    
      gl_log_pkg.log(p_log_text => '凭证过账程序-按公司进行组批，当前公司代码为:' ||
                                   comps.segment1,
                     p_user_id  => -1);
    
      v_gl_batch_num := get_batch_code;
    
      gl_log_pkg.log(p_log_text => '凭证过账程序-按公司进行组批，当前公司批次为:' ||
                                   v_gl_batch_num,
                     p_user_id  => -1);
    
      FOR itfs IN (SELECT gi.gl_interface_id AS interface_id,
                          'NEW' AS status,
                          'N' AS ledger_flag,
                          gi.accounting_date AS accounting_date,
                          gi.currency_code AS currency_code,
                          SYSDATE AS date_created,
                          'A' AS actual_flag,
                          v_gl_batch_num AS source_batch_id,
                          gi.gl_interface_id AS source_line_id,
                          gi.user_je_category_name AS user_je_category_name,
                          gi.user_je_source_name AS user_je_source_name,
                          gi.currency_conversion_date AS currency_conversion_date,
                          gi.user_currency_conversion_type AS user_currency_conversion_type,
                          gi.currency_conversion_rate currency_conversion_rate,
                          'N' AS import_flag,
                          NULL AS import_date,
                          NULL AS error_message,
                          NULL AS last_update_date,
                          '' AS doc_seq_num,
                          -1 AS created_by,
                          NULL AS last_update_by,
                          gi.segment1 AS segment1,
                          gi.segment2 AS segment2,
                          gi.segment3 AS segment3,
                          gi.segment4 AS segment4,
                          gi.segment5 AS segment5,
                          gi.segment6 AS segment6,
                          gi.segment7 AS segment7,
                          gi.segment8 AS segment8,
                          gi.segment9 AS segment9,
                          gi.segment10 AS segment10,
                          gi.segment11 AS segment11,
                          gi.entered_dr AS entered_dr,
                          gi.entered_cr AS entered_cr,
                          gi.accounted_dr AS accounted_dr,
                          gi.accounted_cr AS accounted_cr,
                          NULL AS doc_sequence_value,
                          NULL AS reference1,
                          NULL AS reference2,
                          NULL AS reference3,
                          gi.reference4 AS reference4,
                          NULL AS reference5,
                          substrb(gi.line_desc, 1, 240) AS reference10,
                          NULL AS je_batch_id,
                          gi.period_name AS period_name,
                          NULL AS je_header_id,
                          NULL AS je_line_num,
                          NULL AS chart_of_accounts_id,
                          NULL AS functional_currency_code,
                          NULL AS warning_code,
                          NULL AS stat_amount,
                          NULL AS group_id,
                          NULL AS request_id,
                          NULL AS set_of_books_id,
                          NULL AS attribute_category,
                          NULL AS attribute1,
                          NULL AS attribute2,
                          NULL AS attribute3,
                          NULL AS attribute4,
                          NULL AS attribute5,
                          NULL AS attribute6,
                          NULL AS attribute7,
                          NULL AS attribute8,
                          NULL AS attribute9,
                          NULL AS attribute10,
                          NULL AS attribute11,
                          NULL AS attribute12,
                          NULL AS attribute13,
                          NULL AS attribute14,
                          NULL AS attribute15
                     FROM ebs_hec_gl_interface gi
                    WHERE gi.imported_flag = 'N'
                      AND gi.segment1 = comps.segment1
                      FOR UPDATE NOWAIT) LOOP
      
        gl_log_pkg.log(p_log_text => 'InterfaceId:' || itfs.interface_id,
                       p_user_id  => -1);
      
        insert_ebs_interface(p_interface_id             => itfs.interface_id,
                             p_status                   => itfs.status,
                             p_ledger_flag              => itfs.ledger_flag,
                             p_accounting_date          => itfs.accounting_date,
                             p_currency_code            => itfs.currency_code,
                             p_date_created             => itfs.date_created,
                             p_actual_flag              => itfs.actual_flag,
                             p_source_batch_id          => itfs.source_batch_id,
                             p_source_line_id           => itfs.source_line_id,
                             p_user_je_category_name    => itfs.user_je_category_name,
                             p_user_je_source_name      => itfs.user_je_source_name,
                             p_currency_conversion_date => itfs.currency_conversion_date,
                             p_user_cur_conversion_type => itfs.user_currency_conversion_type,
                             p_currency_conversion_rate => itfs.currency_conversion_rate,
                             p_import_flag              => itfs.import_flag,
                             p_import_date              => itfs.import_date,
                             p_error_message            => itfs.error_message,
                             p_last_update_date         => itfs.last_update_date,
                             p_doc_seq_num              => itfs.doc_seq_num,
                             p_created_by               => itfs.created_by,
                             p_last_update_by           => itfs.last_update_by,
                             p_segment1                 => itfs.segment1,
                             p_segment2                 => itfs.segment2,
                             p_segment3                 => itfs.segment3,
                             p_segment4                 => itfs.segment4,
                             p_segment5                 => itfs.segment5,
                             p_segment6                 => itfs.segment6,
                             p_segment7                 => itfs.segment7,
                             p_segment8                 => itfs.segment8,
                             p_segment9                 => itfs.segment9,
                             p_segment10                => itfs.segment10,
                             p_segment11                => itfs.segment11,
                             p_entered_dr               => itfs.entered_dr,
                             p_entered_cr               => itfs.entered_cr,
                             p_accounted_dr             => itfs.accounted_dr,
                             p_accounted_cr             => itfs.accounted_cr,
                             p_doc_sequence_value       => itfs.doc_sequence_value,
                             p_reference1               => itfs.reference1,
                             p_reference2               => itfs.reference2,
                             p_reference3               => itfs.reference3,
                             p_reference4               => itfs.reference4,
                             p_reference5               => itfs.reference5,
                             p_reference10              => itfs.reference10,
                             p_je_batch_id              => itfs.je_batch_id,
                             p_period_name              => itfs.period_name,
                             p_je_header_id             => itfs.je_header_id,
                             p_je_line_num              => itfs.je_line_num,
                             p_chart_of_accounts_id     => itfs.chart_of_accounts_id,
                             p_functional_currency_code => itfs.functional_currency_code,
                             p_warning_code             => itfs.warning_code,
                             p_stat_amount              => itfs.stat_amount,
                             p_group_id                 => itfs.group_id,
                             p_request_id               => itfs.request_id,
                             p_set_of_books_id          => itfs.set_of_books_id,
                             p_attribute_category       => itfs.attribute_category,
                             p_attribute1               => itfs.attribute1,
                             p_attribute2               => itfs.attribute2,
                             p_attribute3               => itfs.attribute3,
                             p_attribute4               => itfs.attribute4,
                             p_attribute5               => itfs.attribute5,
                             p_attribute6               => itfs.attribute6,
                             p_attribute7               => itfs.attribute7,
                             p_attribute8               => itfs.attribute8,
                             p_attribute9               => itfs.attribute9,
                             p_attribute10              => itfs.attribute10,
                             p_attribute11              => itfs.attribute11,
                             p_attribute12              => itfs.attribute12,
                             p_attribute13              => itfs.attribute13,
                             p_attribute14              => itfs.attribute14,
                             p_attribute15              => itfs.attribute15);
      
        UPDATE ebs_hec_gl_interface i
           SET i.imported_flag = 'U',
               i.process_date  = SYSDATE,
               i.batch_id      = v_gl_batch_num
         WHERE i.gl_interface_id = itfs.interface_id;
      
        gl_log_pkg.log(p_log_text => '凭证过账程序-InterfaceId为:' ||
                                     itfs.interface_id || '的记录传递EBS成功',
                       p_user_id  => -1);
      END LOOP;
    
      gl_log_pkg.log(p_log_text => '凭证过账程序-公司代码为:' || comps.segment1 ||
                                  
                                   '凭证传送EBS完毕',
                     p_user_id  => -1);
    END LOOP;
  
    gl_log_pkg.log(p_log_text => '凭证过账程序-凭证传递EBS完毕',
                   p_user_id  => -1);
  EXCEPTION
    WHEN e_ebs_sob_not_exists THEN
      ROLLBACK;
      gl_log_pkg.log(p_log_text => 'EBS账套无法获取', p_user_id => -1);
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => 'EBS账套无法获取',
                                                     p_created_by              => -1,
                                                     p_package_name            => 'cux_gl_interface_pkg',
                                                     p_procedure_function_name => 'gl_interface');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      ROLLBACK;
      gl_log_pkg.log(p_log_text => '同步至EBS接口表出现异常，异常信息为:' || SQLERRM ||
                                   chr(10) ||
                                   dbms_utility.format_error_backtrace,
                     p_user_id  => -1);
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '同步至EBS接口表出现异常，异常信息为:' ||
                                                                                  SQLERRM ||
                                                                                  chr(10) ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => -1,
                                                     p_package_name            => 'cux_gl_interface_pkg',
                                                     p_procedure_function_name => 'gl_interface');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END post_to_ebs;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/10 9:27:34
  -- Ver     : 1.1
  -- Purpose : 从EBS查询已传输的凭证的过账状态
  **************************************************/
  PROCEDURE query_from_ebs IS
    --v_itfs_exp cux_gl_interface_exp%rowtype;
  BEGIN
    /*gl_log_pkg.log(p_log_text => '凭证过账结果查询程序-开始',
                   p_user_id  => -1);
    for itfs in (select *
                   from ebs_hec_gl_interface i
                  where i.imported_flag in ('E', 'U')
                    for update nowait) loop
    
      gl_log_pkg.log(p_log_text => 'InterfaceId:' || itfs.gl_interface_id,
                     p_user_id  => -1);
      select *
        into v_itfs_exp
        from cux_gl_interface_exp ie
       where ie.interface_id = itfs.gl_interface_id;
    
      gl_log_pkg.log(p_log_text => 'EBS结果状态为:' || v_itfs_exp.import_flag ||
                                   ',错误信息:' || v_itfs_exp.error_message,
                     p_user_id  => -1);
    
      if v_itfs_exp.import_flag = 'Y' then
        --凭证过账成功
        update ebs_hec_gl_interface i
           set i.status            = v_itfs_exp.status,
               i.imported_flag     = 'Y',
               i.batch_description = v_itfs_exp.doc_seq_num,
               i.process_date      = v_itfs_exp.import_date,
               i.je_batch_id       = v_itfs_exp.je_batch_id,
               i.je_header_id      = v_itfs_exp.je_header_id,
               i.je_line_num       = v_itfs_exp.je_line_num,
               i.attribute1        = v_itfs_exp.attribute1,
               i.gl_request_id     = v_itfs_exp.request_id,
               i.error_description = v_itfs_exp.error_message
         where i.gl_interface_id = itfs.gl_interface_id;
    
        update gl_account_entry e
           set e.imported_flag  = 'Y',
               e.import_date    = v_itfs_exp.import_date,
               e.error_message  = v_itfs_exp.error_message,
               e.journal_number = v_itfs_exp.je_header_id,
               e.attribute1     = v_itfs_exp.attribute1
         where e.gl_interface_id = itfs.gl_interface_id;
    
      elsif v_itfs_exp.import_flag = 'E' then
        --凭证过账失败
        update ebs_hec_gl_interface i
           set i.imported_flag     = 'E',
               i.error_description = v_itfs_exp.error_message
         where i.gl_interface_id = itfs.gl_interface_id;
    
        update gl_account_entry e
           set e.error_message = v_itfs_exp.error_message
         where e.gl_interface_id = itfs.gl_interface_id;
      end if;
    end loop;
    
    gl_log_pkg.log(p_log_text => '凭证过账结果查询程序-开始',
                   p_user_id  => -1);*/
    NULL;
  EXCEPTION
    WHEN OTHERS THEN
      gl_log_pkg.log(p_log_text => SQLERRM || chr(10) ||
                                   dbms_utility.format_error_backtrace,
                     p_user_id  => -1);
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => SQLERRM ||
                                                                                  chr(10) ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => -1,
                                                     p_package_name            => 'cux_gl_interface_pkg',
                                                     p_procedure_function_name => 'query_from_ebs');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END query_from_ebs;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/21 12:29:11
  -- Ver     : 1.1
  -- Purpose : 更新interface的段值
  **************************************************/
  PROCEDURE update_gl_interface(p_gl_interface_id NUMBER,
                                p_accounting_date DATE,
                                p_period_name     VARCHAR2,
                                p_period_num      VARCHAR2,
                                p_segment1        VARCHAR2,
                                p_segment2        VARCHAR2,
                                p_segment3        VARCHAR2,
                                p_segment4        VARCHAR2,
                                p_segment5        VARCHAR2,
                                p_segment6        VARCHAR2,
                                p_segment7        VARCHAR2,
                                p_segment8        VARCHAR2,
                                p_segment9        VARCHAR2,
                                p_segment10       VARCHAR2,
                                p_segment11       VARCHAR2,
                                p_user_id         NUMBER) IS
  
    e_gl_data_status_error EXCEPTION;
  BEGIN
    UPDATE ebs_hec_gl_interface i
       SET i.accounting_date       = p_accounting_date,
           i.period_name           = p_period_name,
           i.accounting_period_num = p_period_num,
           i.segment1              = p_segment1,
           i.segment2              = p_segment2,
           i.segment3              = p_segment3,
           i.segment4              = p_segment4,
           i.segment5              = p_segment5,
           i.segment6              = p_segment6,
           i.segment7              = p_segment7,
           i.segment8              = p_segment8,
           i.segment9              = p_segment9,
           i.segment10             = p_segment10,
           i.segment11             = p_segment11,
           i.last_update_by        = p_user_id,
           i.last_update_date      = SYSDATE
     WHERE i.gl_interface_id = p_gl_interface_id
       AND i.imported_flag IN ('U', 'E');
  
    UPDATE gl_account_entry e
       SET e.accounting_date  = p_accounting_date,
           e.period_name      = p_period_name,
           e.period_num       = p_period_num,
           e.segment1         = p_segment1,
           e.segment2         = p_segment2,
           e.segment3         = p_segment3,
           e.segment4         = p_segment4,
           e.segment5         = p_segment5,
           e.segment6         = p_segment6,
           e.segment7         = p_segment7,
           e.segment8         = p_segment8,
           e.segment9         = p_segment9,
           e.segment10        = p_segment10,
           e.segment11        = p_segment11,
           e.last_updated_by  = p_user_id,
           e.last_update_date = SYSDATE
     WHERE e.gl_interface_id = p_gl_interface_id;
  
    FOR entrys IN (SELECT *
                     FROM gl_account_entry e
                    WHERE e.gl_interface_id = p_gl_interface_id) LOOP
      IF entrys.transaction_type = 'EXP_REPORT' THEN
        UPDATE exp_report_accounts era
           SET era.journal_date      = p_accounting_date,
               era.period_name       = p_period_name,
               era.account_segment1  = p_segment1,
               era.account_segment2  = p_segment2,
               era.account_segment3  = p_segment3,
               era.account_segment4  = p_segment4,
               era.account_segment5  = p_segment5,
               era.account_segment6  = p_segment6,
               era.account_segment7  = p_segment7,
               era.account_segment8  = p_segment8,
               era.account_segment9  = p_segment9,
               era.account_segment10 = p_segment10,
               era.account_segment11 = p_segment11,
               era.last_updated_by   = p_user_id,
               era.last_update_date  = SYSDATE
         WHERE era.exp_report_je_line_id = entrys.transaction_je_line_id;
      ELSIF entrys.transaction_type = 'CSH_TRANSACTION' THEN
        UPDATE csh_transaction_accounts cta
           SET cta.journal_date      = p_accounting_date,
               cta.period_name       = p_period_name,
               cta.account_segment1  = p_segment1,
               cta.account_segment2  = p_segment2,
               cta.account_segment3  = p_segment3,
               cta.account_segment4  = p_segment4,
               cta.account_segment5  = p_segment5,
               cta.account_segment6  = p_segment6,
               cta.account_segment7  = p_segment7,
               cta.account_segment8  = p_segment8,
               cta.account_segment9  = p_segment9,
               cta.account_segment10 = p_segment10,
               cta.account_segment11 = p_segment11,
               cta.last_updated_by   = p_user_id,
               cta.last_update_date  = SYSDATE
         WHERE cta.transaction_je_line_id = entrys.transaction_je_line_id;
      ELSIF entrys.transaction_type = 'CSH_PMT_REQ' THEN
        UPDATE csh_payment_req_accounts cpra
           SET cpra.journal_date      = p_accounting_date,
               cpra.period_name       = p_period_name,
               cpra.account_segment1  = p_segment1,
               cpra.account_segment2  = p_segment2,
               cpra.account_segment3  = p_segment3,
               cpra.account_segment4  = p_segment4,
               cpra.account_segment5  = p_segment5,
               cpra.account_segment6  = p_segment6,
               cpra.account_segment7  = p_segment7,
               cpra.account_segment8  = p_segment8,
               cpra.account_segment9  = p_segment9,
               cpra.account_segment10 = p_segment10,
               cpra.account_segment11 = p_segment11,
               cpra.last_updated_by   = p_user_id,
               cpra.last_update_date  = SYSDATE
         WHERE cpra.je_line_id = entrys.transaction_je_line_id;
      ELSIF entrys.transaction_type = 'WORK_ORDER' THEN
        UPDATE gld_work_order_accounts gwoa
           SET gwoa.journal_date      = p_accounting_date,
               gwoa.period_name       = p_period_name,
               gwoa.account_segment1  = p_segment1,
               gwoa.account_segment2  = p_segment2,
               gwoa.account_segment3  = p_segment3,
               gwoa.account_segment4  = p_segment4,
               gwoa.account_segment5  = p_segment5,
               gwoa.account_segment6  = p_segment6,
               gwoa.account_segment7  = p_segment7,
               gwoa.account_segment8  = p_segment8,
               gwoa.account_segment9  = p_segment9,
               gwoa.account_segment10 = p_segment10,
               gwoa.account_segment11 = p_segment11,
               gwoa.last_updated_by   = p_user_id,
               gwoa.last_update_date  = SYSDATE
         WHERE gwoa.work_order_je_line_id = entrys.transaction_je_line_id;
      ELSIF entrys.transaction_type = 'CSH_WRITE_OFF' THEN
        UPDATE csh_write_off_accounts cwoa
           SET cwoa.journal_date      = p_accounting_date,
               cwoa.period_name       = p_period_name,
               cwoa.account_segment1  = p_segment1,
               cwoa.account_segment2  = p_segment2,
               cwoa.account_segment3  = p_segment3,
               cwoa.account_segment4  = p_segment4,
               cwoa.account_segment5  = p_segment5,
               cwoa.account_segment6  = p_segment6,
               cwoa.account_segment7  = p_segment7,
               cwoa.account_segment8  = p_segment8,
               cwoa.account_segment9  = p_segment9,
               cwoa.account_segment10 = p_segment10,
               cwoa.account_segment11 = p_segment11,
               cwoa.last_updated_by   = p_user_id,
               cwoa.last_update_date  = SYSDATE
         WHERE cwoa.write_off_je_line_id = entrys.transaction_je_line_id;
      END IF;
    END LOOP;
  
    IF SQL%NOTFOUND THEN
      RAISE e_gl_data_status_error;
    END IF;
  EXCEPTION
    WHEN e_gl_data_status_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '费控接口表中的数据已经不处于等待处理或者错误状态，请确认数据是否正确！',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_gl_interface_pkg',
                                                     p_procedure_function_name => 'update_gl_interface');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_gl_interface;
  PROCEDURE adjust_ebs_hec_inf_period(p_company_id      NUMBER,
                                      p_accounting_date DATE,
                                      p_period_name     OUT VARCHAR2,
                                      p_period_num      OUT VARCHAR2) IS
  BEGIN
    p_period_name := gld_common_pkg.get_gld_period_name(p_company_id => p_company_id,
                                                        p_date       => p_accounting_date);
    p_period_num  := gld_common_pkg.get_gld_internal_period_num(p_company_id  => p_company_id,
                                                                p_period_name => p_period_name);
  END adjust_ebs_hec_inf_period;
  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/21 12:37:39
  -- Ver     : 1.1
  -- Purpose : 传递费控接口表中的更新至EBS接口表中
  **************************************************/
  PROCEDURE post_update_to_ebs(p_batch_id   VARCHAR2,
                               p_reference4 VARCHAR2,
                               p_company_id NUMBER,
                               p_user_id    NUMBER) IS
    e_ebs_data_status_error EXCEPTION;
    /*cursor ebs_interfaces is
      select e.interface_id
        from cux_gl_interface_exp e
       where e.segment1 = (select company_code
                             from fnd_companies f
                            where f.company_id = p_company_id)
         and e.reference4 = p_reference4
         and e.source_batch_id = p_batch_id;
    v_ebs_interfaces ebs_interfaces%rowtype;*/
  BEGIN
    /*open ebs_interfaces;
    loop
      fetch ebs_interfaces
        into v_ebs_interfaces;
      exit when ebs_interfaces%notfound;
    
      --更新接口表中数据状态
      update ebs_hec_gl_interface t
         set t.imported_flag    = 'U',
             t.last_update_by   = p_user_id,
             t.last_update_date = sysdate
       where t.batch_id = p_batch_id
         and t.reference4 = p_reference4
         and t.hec_company_id = p_company_id;
    
      for itfs in (select *
                     from ebs_hec_gl_interface i
                    where i.reference4 = p_reference4
                      and i.batch_id = p_batch_id
                      and i.hec_company_id = p_company_id
                      and i.imported_flag = 'U') loop
    
        update cux_gl_interface_exp e
           set e.accounting_date = itfs.accounting_date,
               e.period_name     = itfs.period_name,
               e.import_flag     = 'N',
               e.segment1        = itfs.segment1,
               e.segment2        = itfs.segment2,
               e.segment3        = itfs.segment3,
               e.segment4        = itfs.segment4,
               e.segment5        = itfs.segment5,
               e.segment6        = itfs.segment6,
               e.segment7        = itfs.segment7,
               e.segment8        = itfs.segment8,
               e.segment9        = itfs.segment9,
               e.segment10       = itfs.segment10,
               e.segment11       = itfs.segment11
         where e.interface_id = itfs.gl_interface_id
           and e.import_flag in ('E', 'N');
    
        if sql%notfound then
          raise e_ebs_data_status_error;
        end if;
      end loop;
    end loop;
    if ebs_interfaces%isopen then
      close ebs_interfaces;
    end if;*/
    NULL;
  EXCEPTION
    WHEN no_data_found THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => 'EBS中接口表中的数据已经被处理！',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_gl_interface_pkg',
                                                     p_procedure_function_name => 'post_update_to_ebs');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_ebs_data_status_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => 'EBS中接口表中的数据已经不处于等待处理或者错误状态，请确认数据是否正确！',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_gl_interface_pkg',
                                                     p_procedure_function_name => 'post_update_to_ebs');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END post_update_to_ebs;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/12/17 11:25:06
  -- Ver     : 1.1
  -- Purpose : 处理小于当月的期间的所有暂挂的摊销凭证并过账
  **************************************************/
  PROCEDURE post_hold_amortization_entry IS
    v_period_number   NUMBER;
    v_period_name     VARCHAR2(30);
    v_company_id      NUMBER;
    v_period_set_code VARCHAR2(30);
  BEGIN
  
    gl_log_pkg.log(p_log_text => '摊销凭证过账-开始', p_user_id => -1);
  
    SELECT fc.company_id, b.period_set_code
      INTO v_company_id, v_period_set_code
      FROM fnd_companies fc, fnd_company_levels fcl, gld_set_of_books b
     WHERE fc.company_level_id = fcl.company_level_id
       AND fcl.company_level_code = '10'
       AND fc.set_of_books_id = b.set_of_books_id
       AND rownum = 1;
  
    gl_log_pkg.log(p_log_text => '摊销凭证过账-总公司ID为：' || v_company_id ||
                                 ',期间集代码为：' || v_period_set_code,
                   p_user_id  => -1);
  
    --获取当前期间
    v_period_name := gld_common_pkg.get_gld_period_name(p_company_id => v_company_id,
                                                        p_date       => SYSDATE);
  
    gl_log_pkg.log(p_log_text => '期间名称为：' || v_period_name,
                   p_user_id  => -1);
  
    IF v_period_name IS NOT NULL THEN
      v_period_number := gld_common_pkg.get_gld_internal_period_num(p_company_id  => v_company_id,
                                                                    p_period_name => v_period_name);
    
      gl_log_pkg.log(p_log_text => '期间number为：' || v_period_number,
                     p_user_id  => -1);
    
      FOR entrys IN (SELECT e.account_entry_id
                       FROM gl_account_entry e, gld_periods p
                      WHERE e.period_name = p.period_name
                        AND p.period_set_code = v_period_set_code
                        AND e.attribute3 IN
                            ('EXPENSE_AMORTIZATION_CR',
                             'EXPENSE_AMORTIZATION_DR')
                        AND e.imported_flag = 'H'
                        AND p.internal_period_num <= v_period_number) LOOP
      
        UPDATE gl_account_entry e
           SET e.imported_flag    = 'P',
               e.last_update_date = SYSDATE,
               e.last_updated_by  = -1
         WHERE e.account_entry_id = entrys.account_entry_id;
      
        gl_log_pkg.log(p_log_text => 'entry_id为：' ||
                                     entrys.account_entry_id,
                       p_user_id  => -1);
      
      END LOOP;
    END IF;
  
    gl_log_pkg.log(p_log_text => '摊销凭证过账-结束', p_user_id => -1);
  END post_hold_amortization_entry;

  FUNCTION import_entry_to_interface_job(p_event_record_id NUMBER,
                                         p_event_log_id    NUMBER,
                                         p_event_param     NUMBER,
                                         p_user_id         NUMBER)
    RETURN NUMBER IS
  
  BEGIN
    import_entry_to_interface();
    RETURN 1;
  END import_entry_to_interface_job;

  FUNCTION get_sap_batch_code RETURN VARCHAR2 IS
    v_batch_code VARCHAR2(50);
    v_mount      varchar2(2);
  BEGIN
  
    --月初重置凭证号
    select substr(to_char(max(to_number(e.batch_id))), 5, 2)
      into v_mount
      from sap_hec_gl_interface e;
  
    if v_mount = to_char(sysdate, 'mm') then
      select substr(to_char(max(to_number(e.batch_id))), 7)
        into v_batch_code
        from sap_hec_gl_interface e;
    
      v_batch_code := to_char(to_number(v_batch_code) + 1, 'FM00000000000');
    else
      v_batch_code := to_char(1, 'FM00000000000');
    end if;
    RETURN v_batch_code;
  END get_sap_batch_code;

  --将凭证数据导入到sap接口表中
  procedure load_entry_to_sap(p_gl_interface_id number) is
    v_serialno                 varchar2(20);
    v_csh_cash_flow_items_code varchar2(30);
    v_company_code             varchar2(30) default null;
    v_batch_code               varchar2(50) default null;
    v_segment15                varchar2(30);
    v_fkber                    varchar2(10); --功能范围
  begin
    for c2 in (select *
                 from SAP_HEC_GL_INTERFACE s
                where s.gl_interface_id = p_gl_interface_id
                  and s.imported_flag = 'P') loop
    
      --转换现金流量项
      /*begin
        select t.csh_cash_flow_items_code
          into v_csh_cash_flow_items_code
          from CSH_CASH_FLOW_ITEMS t
         where t.cash_flow_line_number = c2.SEGMENT7;
      exception
        when no_data_found then
          v_csh_cash_flow_items_code := '';
      end;*/
    
      --系统往来公司代码取值
      for c1 in (select *
                   from gl_account_entry e
                  where e.batch_code = c2.batch_id
                    and e.attribute3 in
                        ('INTERCOMPANY_AR', 'INTERCOMPANY_AP')) loop
        v_batch_code := c1.batch_code;
      end loop;
    
      if v_batch_code is not null then
        select f.company_code
          into v_company_code
          from fnd_companies f
         where f.company_id = c2.hec_company_id;
      end if;
    
      --带其他应付款-其他科目的分录，客商辅助段不传
      /*if c2.segment3 = '2241990000' then
        v_segment15 := '';
      else*/
      v_segment15 := c2.segment15;
      --end if;
    
      --功能范围,取凭证功能范围配置
      begin
        select g.function_envelop
          into v_fkber
          from gl_account_entry_function g
         where g.commit_items_code = c2.segment4
           and g.account_code = c2.segment3;
      exception
        when no_data_found then
          v_fkber := '';
      end;
    
      v_serialno := get_batch_code;
      insert into zbx_interface
        (mandt,
         zbukr,
         zbeln,
         zbuze,
         zblar,
         zbuda,
         zwear,
         zausb,
         zhkon,
         zsgtx,
         zanfb,
         zpos,
         zdealer,
         zswrb,
         zswr1,
         zhwrb,
         zhwr1,
         zkost,
         zdivi,
         zyhzh,
         zxjxm,
         zxzbh,
         zywly,
         zxbbh,
         zcxbh,
         zjnjw,
         zlifn,
         paytype,
         fkber,
         fistl,
         fipos,
         zde10,
         zde11,
         zde12,
         zde13,
         zde14,
         zde15,
         zdate,
         ztime,
         zflag,
         zdeal,
         zreno,
         zreve,
         serialno,
         dr,
         ts)
      values
        ('800', --客户端 (主Key)
         substr(c2.segment1, 0, 4), --公司代码(主Key) 对应于核算机构
         c2.batch_id, --作为每个公司代码下标识一张凭证的唯一代码
         c2.account_entry_id, --凭证分录号 分录表id
         'Y1', -- 凭证类型  默认“Y1”
         to_char(c2.accounting_date, 'yyyymmdd'), --记账日期 凭证记账日期格式：YYYYMMDD
         'CNY', --币种
         v_company_code, --系统往来公司代码 （对应于核算单位）
         c2.segment3, --记账科目 核算科目
         nvl(substr(c2.line_desc, 0, 49), '费控分录'), --文本摘要 最长50个汉字
         '', --银行参考号
         '', --POS机终端号
         '', --报销员（报销员的中文名称）
         nvl(to_char(c2.entered_dr, 'fm99999990.09'), 0), --借方原币金额
         nvl(to_char(c2.functional_amount_dr, 'fm99999990.09'), 0), --借方本币金额
         nvl(to_char(c2.entered_cr, 'fm99999990.09'), 0), --贷方原币金额
         nvl(to_char(c2.functional_amount_cr, 'fm99999990.09'), 0), --贷方本币金额
         substr(decode(c2.segment2, 'null', '', 'NULL', '', c2.segment2),
                0,
                10), --成本中心 部门与成本中心对应关系中维护的成本中心代码，有就传，没有不传
         '', --部门  不填
         decode(c2.segment6, 'null', '', 'NULL', '', c2.segment6), --银行账户 
         decode(c2.segment7, 'null', '', 'NULL', '', c2.segment7), --现金流量项目  确认是否为货币资金类，只针对货币资金类科目做现金流量转换，填写现金流量项目代码
         decode(c2.segment8, 'null', '', 'NULL', '', c2.segment8), --险种
         decode(c2.segment11, 'null', '', 'NULL', '', c2.segment11), --业务来源
         '', --险别 不填
         '', --车型
         '', --境内境外
         decode(v_segment15, 'null', '', 'NULL', '', v_segment15), --再保/共保供应商  客商辅助段
         '', --收付类型
         v_fkber, --功能范围 
         decode(c2.segment12, 'null', '', 'NULL', '', c2.segment12), --基金中心
         decode(c2.segment4, 'null', '', 'NULL', '', c2.segment4), --承诺项目
         '', --预留字段1
         '', --预留字段2
         decode(c2.segment10, 'null', '', 'NULL', '', c2.segment10), --预留字段3   专属费用标识
         decode(c2.segment9, 'null', '', 'NULL', '', c2.segment9), --预留字段4  险类1
         decode(c2.segment5, 'null', '', 'NULL', '', c2.segment5), --预留字段5  内部订单号
         decode(v_segment15, 'null', '', 'NULL', '', v_segment15), --预留字段6 客商辅助段
         to_char(sysdate, 'yyyymmdd'), --创建日期  Yyyymmdd，写入中间表日期
         to_timestamp(to_char(sysdate, 'hh24mmss'), 'hh24mmss'), --创建时间  写入中间表时间hhmmss
         '1', --1-初始 2-主数据匹配错误 3-财务校验错误 4-校验成功记账失败或未执行回写 5 -记账成功SAP凭证号未获取 6 -记账成功SAP凭证号成功获取
         '', --出错处理标识（X 代表已重新处理） 
         '', --冲销关联报销凭证号 
         '', --冲销标志(0 冲销凭证 1 被冲销凭证) 
         v_serialno, --传输唯一流水标识号
         0, --删除标识
         to_char(sysdate, 'yyyymmdd hh:mm:ss') --时间戳
         );
    
      --更新费用sap接口表导入状态
      update SAP_HEC_GL_INTERFACE s
         set s.imported_flag    = 'T',
             s.serialno         = v_serialno,
             s.last_update_date = sysdate,
             s.last_update_by   = 1
       where s.gl_interface_id = c2.gl_interface_id;
    end loop;
  end load_entry_to_sap;

  --将分录表中的数据导入到费控sap接口表中
  PROCEDURE load_entry_to_sap_inter IS
    v_set_of_books_id          NUMBER;
    v_user_je_category_name    VARCHAR2(200);
    v_currency_conversion_date DATE;
    v_currency_conversion_rate NUMBER;
    v_period_name              VARCHAR2(30);
    v_accounting_period_num    NUMBER;
    v_reference4               VARCHAR2(200);
    v_interface_id             NUMBER;
    v_accounting_date          DATE;
    v_currency_code            VARCHAR2(30);
    v_currency_conversion_type VARCHAR2(30);
    v_company_id               NUMBER;
    V_ZBELN                    varchar2(17); --传送sap凭证号
  BEGIN
    gl_log_pkg.log(p_log_text => '分录表数据传接口表-开始',
                   p_user_id  => -1);
    lock_entry;
  
    gl_log_pkg.log(p_log_text => '按照明细过账,sap凭证接口表',
                   p_user_id  => -1);
  
    for c1 in (select e.transaction_type, e.transaction_number
                 from gl_account_entry e
                where e.imported_flag = 'P'
                group by e.transaction_type, e.transaction_number) loop
    
      --一张凭证一个凭证号  年份+月份+11位流水
      V_ZBELN := to_char(sysdate, 'yyyy') || to_char(sysdate, 'mm') ||
                 get_sap_batch_code;
    
      FOR entrys IN (SELECT e.account_entry_id,
                            get_interface_id AS gl_interface_id,
                            --传送sap凭证号
                            V_ZBELN AS batch_id,
                            --帐套ID
                            (SELECT set_of_books_id
                               FROM gld_set_of_books b
                              WHERE b.set_of_books_code = e.hec_sob_code) AS set_of_books_id,
                            --凭证日期
                            e.accounting_date AS accounting_date,
                            --币种
                            e.currency_code AS currency_code,
                            --凭证类别描述
                            get_user_je_category_name(e.account_entry_id) AS user_je_category_name,
                            --来源名称,费控系统
                            '费控系统' AS user_je_source_name,
                            --汇率日期
                            e.currency_conversion_date AS currency_conversion_date,
                            --币种汇率类型
                            'CNY' AS user_currency_conversion_type,
                            --汇率
                            e.currency_conversion_rate AS currency_conversion_rate,
                            --公司段代码
                            e.segment1,
                            --成本中心段代码
                            e.segment2,
                            --核算科目段代码
                            e.segment3,
                            -- 承诺项目段代码
                            e.segment4,
                            --内部订单段代码
                            e.segment5,
                            -- 银行账号段代码
                            e.segment6,
                            -- 现金流量项目段代码
                            e.segment7,
                            --险种段代码
                            e.segment8,
                            --险类1段代码
                            e.segment9,
                            --专属费用标识段代码
                            e.segment10,
                            --业务来源(渠道)段代码
                            e.segment11,
                            --基金中心段代码
                            e.segment12,
                            --属性13
                            e.segment13,
                            --属性14
                            e.segment14,
                            --客商辅助段段代码
                            e.segment15,
                            --属性16
                            e.segment16,
                            --属性17
                            e.segment17,
                            --属性18
                            e.segment18,
                            --属性19
                            e.segment19,
                            --属性20
                            e.segment20,
                            --原币借方金额
                            e.entered_amount_dr AS entered_dr,
                            --原币贷方金额
                            e.entered_amount_cr AS entered_cr,
                            --本币借方金额
                            e.functional_amount_dr AS functional_amount_dr,
                            --本币贷方金额
                            e.functional_amount_cr AS functional_amount_cr,
                            --期间
                            e.period_name,
                            --组编码
                            NULL AS group_id,
                            NULL AS reference1,
                            NULL AS reference2,
                            get_reference4(e.account_entry_id) AS reference4,
                            NULL AS reference5,
                            NULL AS reference6,
                            NULL AS reference7,
                            NULL AS reference8,
                            NULL AS reference9,
                            NULL AS reference10,
                            NULL AS attribute1,
                            NULL AS attribute2,
                            NULL AS attribute3,
                            NULL AS attribute4,
                            NULL AS attribute5,
                            NULL AS attribute6,
                            NULL AS attribute7,
                            NULL AS attribute8,
                            NULL AS attribute9,
                            NULL AS attribute10,
                            NULL AS attribute11,
                            NULL AS attribute12,
                            NULL AS attribute13,
                            NULL AS attribute14,
                            NULL AS attribute15,
                            NULL AS attribute16,
                            NULL AS attribute17,
                            NULL AS attribute18,
                            NULL AS attribute19,
                            NULL AS attribute20,
                            'P' AS imported_flag,
                            e.transaction_number,
                            e.transaction_je_line_id,
                            SYSDATE AS creation_date,
                            1 AS created_by,
                            SYSDATE AS last_update_date,
                            1 AS last_update_by,
                            e.company_id AS hec_company_id,
                            e.transaction_type,
                            e.description as line_desc
                       FROM gl_account_entry e
                      WHERE e.imported_flag = 'P'
                        and e.transaction_type = c1.transaction_type
                        and e.transaction_number = c1.transaction_number) LOOP
      
        gl_log_pkg.log(p_log_text => 'EntryId:' || entrys.account_entry_id ||
                                     ',对应InterfaceId:' ||
                                     entrys.gl_interface_id,
                       p_user_id  => -1);
      
        --插入费控系统内接口表
        INSERT INTO SAP_HEC_GL_INTERFACE
          (gl_interface_id,
           batch_id,
           set_of_books_id,
           accounting_date,
           currency_code,
           user_je_category_name,
           user_je_source_name,
           currency_conversion_date,
           user_currency_conversion_type,
           currency_conversion_rate,
           segment1,
           segment2,
           segment3,
           segment4,
           segment5,
           segment6,
           segment7,
           segment8,
           segment9,
           segment10,
           segment11,
           segment12,
           segment13,
           segment14,
           segment15,
           segment16,
           segment17,
           segment18,
           segment19,
           segment20,
           entered_dr,
           entered_cr,
           functional_amount_dr,
           functional_amount_cr,
           period_name,
           reference1,
           reference2,
           reference4,
           reference5,
           reference6,
           reference7,
           reference8,
           reference9,
           reference10,
           attribute1,
           attribute2,
           attribute3,
           attribute4,
           attribute5,
           attribute6,
           attribute7,
           attribute8,
           attribute9,
           attribute10,
           attribute11,
           attribute12,
           attribute13,
           attribute14,
           attribute15,
           attribute16,
           attribute17,
           attribute18,
           attribute19,
           attribute20,
           line_desc,
           accounting_period_num,
           currency_conversion_type,
           imported_flag,
           creation_date,
           created_by,
           last_update_date,
           last_update_by,
           hec_company_id,
           transaction_number,
           transaction_je_line_id,
           transaction_type,
           account_entry_id)
        VALUES
          (entrys.gl_interface_id,
           entrys.batch_id,
           entrys.set_of_books_id,
           entrys.accounting_date,
           entrys.currency_code,
           entrys.user_je_category_name,
           entrys.user_je_source_name,
           entrys.currency_conversion_date,
           entrys.user_currency_conversion_type,
           entrys.currency_conversion_rate,
           entrys.segment1,
           entrys.segment2,
           entrys.segment3,
           entrys.segment4,
           entrys.segment5,
           entrys.segment6,
           entrys.segment7,
           entrys.segment8,
           entrys.segment9,
           entrys.segment10,
           entrys.segment11,
           entrys.segment12,
           entrys.segment13,
           entrys.segment14,
           entrys.segment15,
           entrys.segment16,
           entrys.segment17,
           entrys.segment18,
           entrys.segment19,
           entrys.segment20,
           entrys.entered_dr,
           entrys.entered_cr,
           entrys.functional_amount_dr,
           entrys.functional_amount_cr,
           entrys.period_name,
           entrys.reference1,
           entrys.reference2,
           entrys.reference4,
           entrys.reference5,
           entrys.reference6,
           entrys.reference7,
           entrys.reference8,
           entrys.reference9,
           entrys.reference10,
           entrys.attribute1,
           entrys.attribute2,
           entrys.attribute3,
           entrys.attribute4,
           entrys.attribute5,
           entrys.attribute6,
           entrys.attribute7,
           entrys.attribute8,
           entrys.attribute9,
           entrys.attribute10,
           entrys.attribute11,
           entrys.attribute12,
           entrys.attribute13,
           entrys.attribute14,
           entrys.attribute15,
           entrys.attribute16,
           entrys.attribute17,
           entrys.attribute18,
           entrys.attribute19,
           entrys.attribute20,
           entrys.line_desc,
           '',
           '',
           entrys.imported_flag,
           entrys.creation_date,
           entrys.created_by,
           entrys.last_update_date,
           entrys.last_update_by,
           entrys.hec_company_id,
           entrys.transaction_number,
           entrys.transaction_je_line_id,
           entrys.transaction_type,
           entrys.account_entry_id);
      
        load_entry_to_sap(entrys.gl_interface_id);
      
        --更新entry表中的导入状态
        UPDATE gl_account_entry e
           SET e.imported_flag   = 'T',
               e.gl_interface_id = entrys.gl_interface_id,
               e.import_date     = SYSDATE,
               e.batch_code      = entrys.batch_id
         WHERE e.account_entry_id = entrys.account_entry_id;
      
      END LOOP;
    end loop;
  
    unlock_entry;
  
    gl_log_pkg.log(p_log_text => '分录表数据传接口表-结束',
                   p_user_id  => -1);
  EXCEPTION
    WHEN e_lock_table THEN
      NULL;
    WHEN OTHERS THEN
      unlock_entry;
      gl_log_pkg.log(p_log_text => SQLERRM || chr(10) ||
                                   dbms_utility.format_error_backtrace,
                     p_user_id  => -1);
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => SQLERRM ||
                                                                                  chr(10) ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => -1,
                                                     p_package_name            => 'cux_gl_interface_pkg',
                                                     p_procedure_function_name => 'import_entry_to_interface');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END load_entry_to_sap_inter;

  /*********************************
    同步分录至sap凭证接口表
    add by pqs 20181006
  **********************************/
  FUNCTION load_entry_to_sap_interface(p_event_record_id NUMBER,
                                       p_event_log_id    NUMBER,
                                       p_event_param     NUMBER,
                                       p_user_id         NUMBER)
    RETURN NUMBER IS
  
  BEGIN
    load_entry_to_sap_inter();
    RETURN 1;
  END load_entry_to_sap_interface;

  /*************************************************
  -- Author  : pqs
  -- Created : 20181006
  -- Ver     : 1.1
  -- Purpose : 从sap查询已传输的凭证的过账状态
  **************************************************/
  FUNCTION query_from_sap(p_event_record_id NUMBER,
                          p_event_log_id    NUMBER,
                          p_event_param     NUMBER,
                          p_user_id         NUMBER) RETURN NUMBER IS
    v_sap_interface zbx_interface%rowtype;
  BEGIN
    gl_log_pkg.log(p_log_text => '凭证过账结果查询程序-开始',
                   p_user_id  => -1);
  
    for itfs in (select *
                   from sap_hec_gl_interface i
                  where i.imported_flag = 'T') loop
    
      gl_log_pkg.log(p_log_text => 'InterfaceId:' || itfs.gl_interface_id,
                     p_user_id  => -1);
    
      select z.*
        into v_sap_interface
        from zbx_interface z
       where z.serialno = itfs.serialno
         and z.zbeln = itfs.batch_id;
    
      --1-初始 2-主数据匹配错误 3-财务校验错误 4-校验成功记账失败或未执行回写 
      --5 -记账成功SAP凭证号未获取 6 -记账成功SAP凭证号成功获取
    
      --过账成功
      if v_sap_interface.zflag = '6' then
        --接口表
        update sap_hec_gl_interface s
           set s.imported_flag    = 'Y',
               s.last_update_date = sysdate,
               s.last_update_by   = 1
         where s.gl_interface_id = itfs.gl_interface_id
           and s.batch_id = itfs.batch_id
           and s.imported_flag = 'T';
      
        --更新分录表
        update gl_account_entry e
           set e.imported_flag    = 'Y',
               e.import_date      = to_date(v_sap_interface.zsapd,
                                            'yyyy-mm-dd'),
               e.journal_number   = v_sap_interface.belnr,
               e.last_update_date = sysdate,
               e.last_updated_by  = 1
         where e.account_entry_id = itfs.account_entry_id
           and e.batch_code = itfs.batch_id
           and e.imported_flag = 'T';
      
        --过账失败
      elsif v_sap_interface.zflag = '2' then
        --接口表
        update sap_hec_gl_interface s
           set s.imported_flag    = 'E',
               s.last_update_date = sysdate,
               s.last_update_by   = 1
         where s.gl_interface_id = itfs.gl_interface_id
           and s.batch_id = itfs.batch_id
           and s.imported_flag = 'T';
      
        --更新分录表
        update gl_account_entry e
           set e.imported_flag    = 'E',
               e.error_message    = '主数据匹配错误',
               e.last_update_date = sysdate,
               e.last_updated_by  = 1
         where e.account_entry_id = itfs.account_entry_id
           and e.batch_code = itfs.batch_id
           and e.imported_flag = 'T';
      
        --过账失败
      elsif v_sap_interface.zflag = '3' then
        --接口表
        update sap_hec_gl_interface s
           set s.imported_flag    = 'E',
               s.last_update_date = sysdate,
               s.last_update_by   = 1
         where s.gl_interface_id = itfs.gl_interface_id
           and s.batch_id = itfs.batch_id
           and s.imported_flag = 'T';
      
        --更新分录表
        update gl_account_entry e
           set e.imported_flag    = 'E',
               e.error_message    = '财务校验错误',
               e.last_update_date = sysdate,
               e.last_updated_by  = 1
         where e.account_entry_id = itfs.account_entry_id
           and e.batch_code = itfs.batch_id
           and e.imported_flag = 'T';
      
        --其他状态暂不处理
      else
        null;
      end if;
    
    end loop;
  
    gl_log_pkg.log(p_log_text => '凭证过账结果查询程序-结束',
                   p_user_id  => -1);
    return 1;
  EXCEPTION
    WHEN OTHERS THEN
      gl_log_pkg.log(p_log_text => SQLERRM || chr(10) ||
                                   dbms_utility.format_error_backtrace,
                     p_user_id  => -1);
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => SQLERRM ||
                                                                                  chr(10) ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => -1,
                                                     p_package_name            => 'cux_gl_interface_pkg',
                                                     p_procedure_function_name => 'query_from_ebs');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END query_from_sap;

  /*************************************************
  -- Author  : pqs
  -- Created : 20181101
  -- Ver     : 1.1
  -- Purpose : 待传送凭证分录修改
  **************************************************/
  procedure update_account_entry(p_account_entry_id number,
                                 p_segment1         varchar2,
                                 p_segment2         varchar2,
                                 p_segment3         varchar2,
                                 p_segment4         varchar2,
                                 p_segment5         varchar2,
                                 p_segment6         varchar2,
                                 p_segment7         varchar2,
                                 p_segment8         varchar2,
                                 p_segment9         varchar2,
                                 p_segment10        varchar2,
                                 p_segment11        varchar2,
                                 p_segment12        varchar2,
                                 p_segment15        varchar2,
                                 p_user_id          number) is
    v_account_entry gl_account_entry%rowtype;
  begin
  
    select e.*
      into v_account_entry
      from gl_account_entry e
     where e.account_entry_id = p_account_entry_id
       for update nowait;
  
    update gl_account_entry e
       set e.segment1         = nvl(p_segment1, e.segment1),
           e.segment2         = nvl(p_segment2, e.segment2),
           e.segment3         = nvl(p_segment3, e.segment3),
           e.segment4         = nvl(p_segment4, e.segment4),
           e.segment5         = nvl(p_segment5, e.segment5),
           e.segment6         = nvl(p_segment6, e.segment6),
           e.segment7         = nvl(p_segment7, e.segment7),
           e.segment8         = nvl(p_segment8, e.segment8),
           e.segment9         = nvl(p_segment9, e.segment9),
           e.segment10        = nvl(p_segment10, e.segment10),
           e.segment11        = nvl(p_segment11, e.segment11),
           e.segment12        = nvl(p_segment12, e.segment12),
           e.segment15        = nvl(p_segment15, e.segment15),
           e.last_update_date = sysdate,
           e.last_updated_by  = p_user_id
     where e.account_entry_id = p_account_entry_id
       and e.imported_flag = 'P';
  end update_account_entry;

  /*************************************************
  -- Author  : pqs
  -- Created : 20181020
  -- Ver     : 1.1
  -- Purpose : sap过账失败凭证分录修改
  **************************************************/
  procedure update_fail_account_entry(p_account_entry_id number,
                                      p_batch_code       varchar2,
                                      p_segment1         varchar2,
                                      p_segment2         varchar2,
                                      p_segment3         varchar2,
                                      p_segment4         varchar2,
                                      p_segment5         varchar2,
                                      p_segment6         varchar2,
                                      p_segment7         varchar2,
                                      p_segment8         varchar2,
                                      p_segment9         varchar2,
                                      p_segment10        varchar2,
                                      p_segment11        varchar2,
                                      p_segment12        varchar2,
                                      p_segment15        varchar2,
                                      p_user_id          number) is
    v_account_entry gl_account_entry%rowtype;
  begin
  
    select e.*
      into v_account_entry
      from gl_account_entry e
     where e.account_entry_id = p_account_entry_id
       for update nowait;
  
    if p_batch_code is not null then
    
      update gl_account_entry e
         set e.segment1         = nvl(p_segment1, e.segment1),
             e.segment2         = nvl(p_segment2, e.segment2),
             e.segment3         = nvl(p_segment3, e.segment3),
             e.segment4         = nvl(p_segment4, e.segment4),
             e.segment5         = nvl(p_segment5, e.segment5),
             e.segment6         = nvl(p_segment6, e.segment6),
             e.segment7         = nvl(p_segment7, e.segment7),
             e.segment8         = nvl(p_segment8, e.segment8),
             e.segment9         = nvl(p_segment9, e.segment9),
             e.segment10        = nvl(p_segment10, e.segment10),
             e.segment11        = nvl(p_segment11, e.segment11),
             e.segment12        = nvl(p_segment12, e.segment12),
             e.segment15        = nvl(p_segment15, e.segment15),
             e.error_message    = '',
             e.batch_code       = '',
             e.imported_flag    = 'M', --已修改待传送
             e.import_date      = '',
             e.journal_number   = '',
             e.last_update_date = sysdate,
             e.last_updated_by  = p_user_id
       where e.account_entry_id = p_account_entry_id
         and e.batch_code = p_batch_code;
    else
      update gl_account_entry e
         set e.segment1         = nvl(p_segment1, e.segment1),
             e.segment2         = nvl(p_segment2, e.segment2),
             e.segment3         = nvl(p_segment3, e.segment3),
             e.segment4         = nvl(p_segment4, e.segment4),
             e.segment5         = nvl(p_segment5, e.segment5),
             e.segment6         = nvl(p_segment6, e.segment6),
             e.segment7         = nvl(p_segment7, e.segment7),
             e.segment8         = nvl(p_segment8, e.segment8),
             e.segment9         = nvl(p_segment9, e.segment9),
             e.segment10        = nvl(p_segment10, e.segment10),
             e.segment11        = nvl(p_segment11, e.segment11),
             e.segment12        = nvl(p_segment12, e.segment12),
             e.segment15        = nvl(p_segment15, e.segment15),
             e.error_message    = '',
             e.batch_code       = '',
             e.import_date      = '',
             e.journal_number   = '',
             e.last_update_date = sysdate,
             e.last_updated_by  = p_user_id
       where e.account_entry_id = p_account_entry_id
         and e.imported_flag = 'M';
    end if;
  end update_fail_account_entry;

  /*************************************************
  -- Author  : pqs
  -- Created : 20181022
  -- Ver     : 1.1
  -- Purpose : sap过账失败凭证分录修改
  **************************************************/
  procedure resent_entry_to_sap(p_transaction_number varchar2,
                                p_user_id            number) is
    v_set_of_books_id          NUMBER;
    v_user_je_category_name    VARCHAR2(200);
    v_currency_conversion_date DATE;
    v_currency_conversion_rate NUMBER;
    v_period_name              VARCHAR2(30);
    v_accounting_period_num    NUMBER;
    v_reference4               VARCHAR2(200);
    v_interface_id             NUMBER;
    v_accounting_date          DATE;
    v_currency_code            VARCHAR2(30);
    v_currency_conversion_type VARCHAR2(30);
    v_company_id               NUMBER;
    V_ZBELN                    varchar2(17); --传送sap凭证号
  BEGIN
    gl_log_pkg.log(p_log_text => '错误分录数据重传接口表-开始',
                   p_user_id  => -1);
  
    lock_modify_entry(p_transaction_number);
  
    gl_log_pkg.log(p_log_text => '按照明细重过账,sap凭证接口表',
                   p_user_id  => -1);
  
    for c1 in (select e.transaction_type, e.transaction_number
                 from gl_account_entry e
                where e.imported_flag = 'M'
                  and e.transaction_number = p_transaction_number) loop
    
      --一张凭证一个凭证号  年份+月份+11位流水
      V_ZBELN := to_char(sysdate, 'yyyy') || to_char(sysdate, 'mm') ||
                 get_sap_batch_code;
    
      FOR entrys IN (SELECT e.account_entry_id,
                            get_interface_id AS gl_interface_id,
                            --传送sap凭证号
                            V_ZBELN AS batch_id,
                            --帐套ID
                            (SELECT set_of_books_id
                               FROM gld_set_of_books b
                              WHERE b.set_of_books_code = e.hec_sob_code) AS set_of_books_id,
                            --凭证日期
                            e.accounting_date AS accounting_date,
                            --币种
                            e.currency_code AS currency_code,
                            --凭证类别描述
                            get_user_je_category_name(e.account_entry_id) AS user_je_category_name,
                            --来源名称,费控系统
                            '费控系统' AS user_je_source_name,
                            --汇率日期
                            e.currency_conversion_date AS currency_conversion_date,
                            --币种汇率类型
                            'CNY' AS user_currency_conversion_type,
                            --汇率
                            e.currency_conversion_rate AS currency_conversion_rate,
                            --公司段代码
                            e.segment1,
                            --成本中心段代码
                            e.segment2,
                            --核算科目段代码
                            e.segment3,
                            -- 承诺项目段代码
                            e.segment4,
                            --内部订单段代码
                            e.segment5,
                            -- 银行账号段代码
                            e.segment6,
                            -- 现金流量项目段代码
                            e.segment7,
                            --险种段代码
                            e.segment8,
                            --险类1段代码
                            e.segment9,
                            --专属费用标识段代码
                            e.segment10,
                            --业务来源(渠道)段代码
                            e.segment11,
                            --基金中心段代码
                            e.segment12,
                            --属性13
                            e.segment13,
                            --属性14
                            e.segment14,
                            --客商辅助段段代码
                            e.segment15,
                            --属性16
                            e.segment16,
                            --属性17
                            e.segment17,
                            --属性18
                            e.segment18,
                            --属性19
                            e.segment19,
                            --属性20
                            e.segment20,
                            --原币借方金额
                            e.entered_amount_dr AS entered_dr,
                            --原币贷方金额
                            e.entered_amount_cr AS entered_cr,
                            --本币借方金额
                            e.functional_amount_dr AS functional_amount_dr,
                            --本币贷方金额
                            e.functional_amount_cr AS functional_amount_cr,
                            --期间
                            e.period_name,
                            --组编码
                            NULL AS group_id,
                            NULL AS reference1,
                            NULL AS reference2,
                            get_reference4(e.account_entry_id) AS reference4,
                            NULL AS reference5,
                            NULL AS reference6,
                            NULL AS reference7,
                            NULL AS reference8,
                            NULL AS reference9,
                            NULL AS reference10,
                            NULL AS attribute1,
                            NULL AS attribute2,
                            NULL AS attribute3,
                            NULL AS attribute4,
                            NULL AS attribute5,
                            NULL AS attribute6,
                            NULL AS attribute7,
                            NULL AS attribute8,
                            NULL AS attribute9,
                            NULL AS attribute10,
                            NULL AS attribute11,
                            NULL AS attribute12,
                            NULL AS attribute13,
                            NULL AS attribute14,
                            NULL AS attribute15,
                            NULL AS attribute16,
                            NULL AS attribute17,
                            NULL AS attribute18,
                            NULL AS attribute19,
                            NULL AS attribute20,
                            'P' AS imported_flag,
                            e.transaction_number,
                            e.transaction_je_line_id,
                            SYSDATE AS creation_date,
                            1 AS created_by,
                            SYSDATE AS last_update_date,
                            1 AS last_update_by,
                            e.company_id AS hec_company_id,
                            e.transaction_type,
                            e.description as line_desc
                       FROM gl_account_entry e
                      WHERE e.imported_flag = 'M'
                        and e.transaction_type = c1.transaction_type
                        and e.transaction_number = c1.transaction_number) LOOP
      
        gl_log_pkg.log(p_log_text => 'EntryId:' || entrys.account_entry_id ||
                                     ',对应InterfaceId:' ||
                                     entrys.gl_interface_id,
                       p_user_id  => -1);
      
        --插入费控系统内接口表
        INSERT INTO SAP_HEC_GL_INTERFACE
          (gl_interface_id,
           batch_id,
           set_of_books_id,
           accounting_date,
           currency_code,
           user_je_category_name,
           user_je_source_name,
           currency_conversion_date,
           user_currency_conversion_type,
           currency_conversion_rate,
           segment1,
           segment2,
           segment3,
           segment4,
           segment5,
           segment6,
           segment7,
           segment8,
           segment9,
           segment10,
           segment11,
           segment12,
           segment13,
           segment14,
           segment15,
           segment16,
           segment17,
           segment18,
           segment19,
           segment20,
           entered_dr,
           entered_cr,
           functional_amount_dr,
           functional_amount_cr,
           period_name,
           reference1,
           reference2,
           reference4,
           reference5,
           reference6,
           reference7,
           reference8,
           reference9,
           reference10,
           attribute1,
           attribute2,
           attribute3,
           attribute4,
           attribute5,
           attribute6,
           attribute7,
           attribute8,
           attribute9,
           attribute10,
           attribute11,
           attribute12,
           attribute13,
           attribute14,
           attribute15,
           attribute16,
           attribute17,
           attribute18,
           attribute19,
           attribute20,
           line_desc,
           accounting_period_num,
           currency_conversion_type,
           imported_flag,
           creation_date,
           created_by,
           last_update_date,
           last_update_by,
           hec_company_id,
           transaction_number,
           transaction_je_line_id,
           transaction_type,
           account_entry_id)
        VALUES
          (entrys.gl_interface_id,
           entrys.batch_id,
           entrys.set_of_books_id,
           entrys.accounting_date,
           entrys.currency_code,
           entrys.user_je_category_name,
           entrys.user_je_source_name,
           entrys.currency_conversion_date,
           entrys.user_currency_conversion_type,
           entrys.currency_conversion_rate,
           entrys.segment1,
           entrys.segment2,
           entrys.segment3,
           entrys.segment4,
           entrys.segment5,
           entrys.segment6,
           entrys.segment7,
           entrys.segment8,
           entrys.segment9,
           entrys.segment10,
           entrys.segment11,
           entrys.segment12,
           entrys.segment13,
           entrys.segment14,
           entrys.segment15,
           entrys.segment16,
           entrys.segment17,
           entrys.segment18,
           entrys.segment19,
           entrys.segment20,
           entrys.entered_dr,
           entrys.entered_cr,
           entrys.functional_amount_dr,
           entrys.functional_amount_cr,
           entrys.period_name,
           entrys.reference1,
           entrys.reference2,
           entrys.reference4,
           entrys.reference5,
           entrys.reference6,
           entrys.reference7,
           entrys.reference8,
           entrys.reference9,
           entrys.reference10,
           entrys.attribute1,
           entrys.attribute2,
           entrys.attribute3,
           entrys.attribute4,
           entrys.attribute5,
           entrys.attribute6,
           entrys.attribute7,
           entrys.attribute8,
           entrys.attribute9,
           entrys.attribute10,
           entrys.attribute11,
           entrys.attribute12,
           entrys.attribute13,
           entrys.attribute14,
           entrys.attribute15,
           entrys.attribute16,
           entrys.attribute17,
           entrys.attribute18,
           entrys.attribute19,
           entrys.attribute20,
           entrys.line_desc,
           '',
           '',
           entrys.imported_flag,
           entrys.creation_date,
           entrys.created_by,
           entrys.last_update_date,
           entrys.last_update_by,
           entrys.hec_company_id,
           entrys.transaction_number,
           entrys.transaction_je_line_id,
           entrys.transaction_type,
           entrys.account_entry_id);
      
        load_entry_to_sap(entrys.gl_interface_id);
      
        --更新entry表中的导入状态
        UPDATE gl_account_entry e
           SET e.imported_flag   = 'T',
               e.gl_interface_id = entrys.gl_interface_id,
               e.import_date     = SYSDATE,
               e.batch_code      = entrys.batch_id
         WHERE e.account_entry_id = entrys.account_entry_id;
      
      END LOOP;
    end loop;
  
    unlock_modify_entry;
  
    gl_log_pkg.log(p_log_text => '错误分录数据重传接口表-结束',
                   p_user_id  => -1);
  EXCEPTION
    WHEN e_lock_table THEN
      NULL;
    WHEN OTHERS THEN
      unlock_modify_entry;
      gl_log_pkg.log(p_log_text => SQLERRM || chr(10) ||
                                   dbms_utility.format_error_backtrace,
                     p_user_id  => -1);
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => SQLERRM ||
                                                                                  chr(10) ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => -1,
                                                     p_package_name            => 'cux_gl_interface_pkg',
                                                     p_procedure_function_name => 'import_entry_to_interface');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end resent_entry_to_sap;
END cux_gl_interface_pkg;
/
