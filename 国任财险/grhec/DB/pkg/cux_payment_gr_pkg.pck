CREATE OR REPLACE PACKAGE cux_payment_gr_pkg IS

  -- Author  : PENG
  -- Created : 2018/9/20 12:05:55
  -- Purpose : 

  c_datastatus_hec_saved CONSTANT NUMBER := 0;
  c_datastatus_saved     CONSTANT NUMBER := 1;
  c_datastatus_passed    CONSTANT NUMBER := 2;
  c_datastatus_error     CONSTANT NUMBER := 3;
  c_datastatus_canceled  CONSTANT NUMBER := 4;
  c_datastatus_success   CONSTANT NUMBER := 5;
  c_datastatus_refund    CONSTANT NUMBER := 6;
  c_datastatus_fail      CONSTANT NUMBER := 7;

  /*************************AMA安盟财险新增部分******************
  AMA安盟财险使用的是Webservice形式，有收付款和支付撤回的接口
  */
  c_type_value       CONSTANT CHAR(1) := '1'; --默认收付款报文类型代码
  c_source           CONSTANT CHAR(3) := 'HEC'; --交易来源
  c_pay_code         CONSTANT CHAR(4) := '1988'; --批量代付交易编码
  c_gather_code      CONSTANT CHAR(4) := '9188'; --批量代收交易编码
  c_pay_re_code      CONSTANT CHAR(4) := '1998'; --批量代付结果通知代码
  c_gather_re_code   CONSTANT CHAR(4) := '9198'; --批量代收结果通知编码
  c_bx_doc_type      CONSTANT CHAR(2) := 'BX'; --支付类型：报销
  c_jk_doc_type      CONSTANT CHAR(2) := 'JK'; --支付类型：借款
  c_hk_doc_type      CONSTANT CHAR(2) := 'HK'; --还款类型
  c_return_success   CONSTANT VARCHAR2(10) := 'success'; --交易返回码：处理成功
  c_return_fail      CONSTANT VARCHAR2(10) := 'fail'; --交易返回码：处理失败
  c_return_exception CONSTANT VARCHAR2(10) := 'exception'; --交易返回码：处理异常
  c_return_duplicate CONSTANT VARCHAR2(10) := 'duplicate'; --交易返回码：批次已存在

  g_ws_url          CONSTANT VARCHAR2(300) := sys_parameter_pkg.value('ZJ_INTERFACE_WS_URL');
  g_ws_enabled_flag CONSTANT VARCHAR2(10) := sys_parameter_pkg.value('ZJ_INTERFACE_ENABLED');
  -- Public type declarationszj_recor
  --资金收付记录类型
  TYPE zj_record IS RECORD(
    csh_transaction_number VARCHAR2(30),
    doc_header_id          NUMBER,
    head_serial_num        VARCHAR2(30),
    doc_line_id            NUMBER,
    doc_number             VARCHAR2(30),
    total_amount           NUMBER, --交易总金额
    audit_date             DATE, --复核日期
    company_code           VARCHAR2(30),
    doc_type               VARCHAR2(50), --报销c_bx_pay_type 或者借款c_jk_pay_type
    payee_account          VARCHAR2(100), --交易方账户
    payee_name             VARCHAR2(1000), --交易方户名
    pay_area_code          VARCHAR2(10), --区域编码
    pay_bank_code          VARCHAR2(30), --银行编码
    pay_bank_desc          VARCHAR2(100), --银行描述
    pay_bank_name          VARCHAR2(1000), --开户行名称
    pay_bank_num           VARCHAR2(30), --联行号代码
    currency_code          VARCHAR2(10), --币种编码
    amount                 NUMBER, --交易金额
    pay_type               VARCHAR2(10), --公私标志
    description            VARCHAR2(4000), ---头说明
    user_id                NUMBER,
    useds                  VARCHAR2(10), --付款用途
    pmt_summary            VARCHAR2(2000), --计划付款行摘要
    partner_category       VARCHAR2(100), --交易方类型
    settlement_mode        VARCHAR2(1), --结算方式
    purpose                VARCHAR2(200), --用途
    corpact                VARCHAR2(30),
    source_business_number VARCHAR2(30), --
    paytype                VARCHAR2(10)); --业务类型 

  --资金结果通知记录类型
  TYPE zj_result_record IS RECORD(
    transsource  VARCHAR2(10),
    transcode    VARCHAR2(100),
    transdate    VARCHAR2(30),
    transtime    VARCHAR2(30),
    transseq     VARCHAR2(100),
    rtncode      VARCHAR2(30),
    rtnmsg       VARCHAR2(3000),
    reqseqid     VARCHAR2(30),
    rdseq        VARCHAR2(30),
    begindate    VARCHAR2(10),
    corpact      VARCHAR2(100),
    corpentity   VARCHAR2(100),
    corpbank     VARCHAR2(100),
    oppact       VARCHAR2(100),
    transstate   VARCHAR2(10),
    payinfocode  VARCHAR2(30),
    payinfo      VARCHAR2(300),
    failtype     VARCHAR2(10),
    paymadedate  VARCHAR2(30),
    abstract     VARCHAR2(30),
    reqreserved3 VARCHAR2(100),
    reqreserved4 VARCHAR2(100));

  --付款报文模板
  c_pay_xml VARCHAR2(3000) := '<?xml version="1.0" encoding="utf-8"?><ATS>' ||
                              '<PUB>' ||
                              '<TransSource>#TransSource#</TransSource>' ||
                              '<TransCode>#TransCodeP#</TransCode>' ||
                              '<TransDate>#TransDate#</TransDate>' ||
                              '<TransTime>#TransTime#</TransTime>' ||
                              '<TransSeq>#TransSeq#</TransSeq>' || '</PUB>' ||
                              '<IN>' || '<ReqSeqID>#ReqSeqID#</ReqSeqID>' ||
                              '<TotalCount>#TotalCount#</TotalCount>' ||
                              '<TotalAmount>#TotalAmount#</TotalAmount>' ||
                              '<RD>' || '<RdSeq>#RdSeq#</RdSeq>' ||
                              '<PayDate>#PayDate#</PayDate>' ||
                              '<ApplyEntity>#ApplyEntity#</ApplyEntity>' ||
                              '<PayType>#PayType#</PayType>' ||
                              '<SettlementMode>#SettlementMode#</SettlementMode>' ||
                              '<CorpAct>#CorpAct#</CorpAct>' ||
                              '<OppAct>#OppAct#</OppAct>' ||
                              '<OppActName>#OppActName#</OppActName>' ||
                              '<OppAreaCode>#OppAreaCode#</OppAreaCode>' ||
                              '<OppBankCode>#OppBankCode#</OppBankCode>' ||
                              '<OppBankLocation>#OppBankLocation#</OppBankLocation>' ||
                              '<CNAPSCode>#CNAPSCode#</CNAPSCode>' ||
                              '<Cur>#Cur#</Cur>' ||
                              '<Amount>#Amount#</Amount>' ||
                              '<PrivateFlag>#PrivateFlag#</PrivateFlag>' ||
                              '<Purpose>#Purpose#</Purpose>' ||
                              '<Memo>#Memo#</Memo>' ||
                              '<Description>#Description#</Description>' ||
                              '<CardType>#CardType#</CardType>' ||
                              '<CertType>#CertType#</CertType>' ||
                              '<CertNumber>#CertNumber#</CertNumber>' ||
                              '<SourceNoteCode>#SourceNoteCode#</SourceNoteCode>' ||
                              '<PaymentCode>#PaymentCode#</PaymentCode>' ||
                             /*'<AuditPerson>#AuditPerson#</AuditPerson>' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               '<AuditTime>#AuditTime#</AuditTime>' ||*/
                              '<ReqReserved3>#ReqReserved3#</ReqReserved3>' ||
                              '<ReqReserved4>#ReqReserved4#</ReqReserved4>' ||
                              '<ReqReserved5>#ReqReserved5#</ReqReserved5>' ||
                              '</RD></IN></ATS>';

  --收款报文模板
  c_gather_xml VARCHAR2(3000) := '<?xml version="1.0" encoding="utf-8"?><ATS>' ||
                                 '<PUB>' ||
                                 '<TransSource>#TransSource#</TransSource>' ||
                                 '<TransCode>#TransCodeG#</TransCode>' ||
                                 '<TransDate>#TransDate#</TransDate>' ||
                                 '<TransTime>#TransTime#</TransTime>' ||
                                 '<TransSeq>#TransSeq#</TransSeq>' ||
                                 '</PUB>' || '<IN>' ||
                                 '<ReqSeqID>#ReqSeqID#</ReqSeqID>' ||
                                 '<TotalCount>#TotalCount#</TotalCount>' ||
                                 '<TotalAmount>#TotalAmount#</TotalAmount>' ||
                                 '<RD>' || '<RdSeq>#RdSeq#</RdSeq>' ||
                                 '<PayDate>#PayDate#</PayDate>' ||
                                 '<ApplyEntity>#ApplyEntity#</ApplyEntity>' ||
                                 '<PayType>#PayType#</PayType>' ||
                                 '<SettlementMode>#SettlementMode#</SettlementMode>' ||
                                 '<CorpAct>#CorpAct#</CorpAct>' ||
                                 '<OppAct>#OppAct#</OppAct>' ||
                                 '<OppActName>#OppActName#</OppActName>' ||
                                 '<OppAreaCode>#OppAreaCode#</OppAreaCode>' ||
                                 '<OppBankCode>#OppBankCode#</OppBankCode>' ||
                                 '<OppBankLocation>#OppBankLocation#</OppBankLocation>' ||
                                 '<CNAPSCode>#CNAPSCode#</CNAPSCode>' ||
                                 '<Cur>#Cur#</Cur>' ||
                                 '<Amount>#Amount#</Amount>' ||
                                 '<PrivateFlag>#PrivateFlag#</PrivateFlag>' ||
                                 '<Purpose>#Purpose#</Purpose>' ||
                                 '<Memo>#Memo#</Memo>' ||
                                 '<Description>#Description#</Description>' ||
                                 '<CardType>#CardType#</CardType>' ||
                                 '<CertType>#CertType#</CertType>' ||
                                 '<CertNumber>#CertNumber#</CertNumber>' ||
                                 '<SourceNoteCode>#SourceNoteCode#</SourceNoteCode>' ||
                                 '<ReqReserved3>#ReqReserved3#</ReqReserved3>' ||
                                 '</RD></IN></ATS>';

  /*************************************************
  -- Author  : HM
  -- Created : 2016/11/23 15:01:06
  -- Purpose : 资金收付接口主程序
  **************************************************/
  PROCEDURE ws_post_zj(p_interface_id NUMBER,
                       p_user_id      NUMBER,
                       p_csh_type     VARCHAR2);

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/12 11:53:47
  -- Ver     : 1.1
  -- Purpose : 插入报销单计付行单据信息
  -- In Para : 
        p_event_record_id 事件记录ID
        p_event_log_id    事件日志ID
        p_event_param     事件参数,报销单头ID
        p_user_id         用户ID
  **************************************************/
  FUNCTION post_exp_rep_to_zj(p_event_record_id NUMBER,
                              p_event_log_id    NUMBER,
                              p_event_param     NUMBER,
                              p_user_id         NUMBER) RETURN NUMBER;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/12 18:44:27
  -- Ver     : 1.1
  -- Purpose : 插入借款单行支付信息
  -- In Para : 
        p_event_record_id 事件记录ID
        p_event_log_id    事件日志ID
        p_event_param     事件参数,借款单头ID
        p_user_id         用户ID
  **************************************************/
  FUNCTION post_csh_pay_req_to_zj(p_event_record_id NUMBER,
                                  p_event_log_id    NUMBER,
                                  p_event_param     NUMBER,
                                  p_user_id         NUMBER) RETURN NUMBER;

  /*************************************************
   -- Author  : MOUSE
   -- Created : 2015/11/30 13:56:12
   -- Ver     : 1.1
  -- Purpose : 插入付款申请单支付信息
  -- In Para : 
        p_event_record_id 事件记录ID
        p_event_log_id    事件日志ID
        p_event_param     事件参数,借款单头ID
        p_user_id         用户ID
   **************************************************/
  FUNCTION post_acp_req_to_zj(p_event_record_id NUMBER,
                              p_event_log_id    NUMBER,
                              p_event_param     NUMBER,
                              p_user_id         NUMBER) RETURN NUMBER;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/13 10:36:59
  -- Ver     : 1.1
  -- Purpose : 从资金系统查询支付结果
  -- In Para : 
        p_event_record_id 事件记录ID
        p_event_log_id    事件日志ID
        p_event_param     事件参数,报销单头ID
        p_user_id         用户ID
  **************************************************/
  FUNCTION query_from_zj(p_event_record_id NUMBER,
                         p_event_log_id    NUMBER,
                         p_event_param     NUMBER,
                         p_user_id         NUMBER) RETURN NUMBER;

  /*************************************************
  -- Author  : HM
  -- Created : 2016/11/24 16:24:44
  -- Purpose : 资金结果通知WS服务端程序
  **************************************************/
  PROCEDURE ws_get_result_zj(p_input_xml  IN OUT CLOB,
                             p_output_xml OUT VARCHAR2,
                             p_success    OUT VARCHAR2);

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/26 19:11:31
  -- Ver     : 1.1
  -- Purpose : 修改收款信息并重传资金
  **************************************************/
  PROCEDURE update_payee_info_resend(p_info_id        NUMBER,
                                     p_payee_category VARCHAR2,
                                     --p_payee_id             number,
                                     p_payee_account_number VARCHAR2,
                                     p_payment_method_id    NUMBER,
                                     p_gather_flag          VARCHAR2,
                                     p_user_id              NUMBER);

  --重新支付
  PROCEDURE resend_to_zj(p_inter_id NUMBER, p_user_id NUMBER);

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/26 14:18:34
  -- Ver     : 1.1
  -- Purpose : 确认退票并重传资金接口
  **************************************************/
  PROCEDURE confirm_refund_cancel_to_zj(p_info_id NUMBER, p_user_id NUMBER);

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/26 14:18:34
  -- Ver     : 1.1
  -- Purpose : 确认并取消资金接口
  **************************************************/
  PROCEDURE confirm_cancel_to_zj(p_inter_id NUMBER, p_user_id NUMBER);

  /*************************************************
  -- Author  : Rick
  -- Created : 2018-10-10 19:41:59
  -- Ver     : 1.1
  -- Purpose : 报销单支付
  **************************************************/
  PROCEDURE gr_post_exp_rep(p_exp_report_header_id NUMBER,
                            p_user_id              NUMBER);

END cux_payment_gr_pkg;
/
CREATE OR REPLACE PACKAGE BODY cux_payment_gr_pkg IS

  e_lock_table EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_lock_table, -54);
  e_user_error                   EXCEPTION;
  e_bank_account_not_found_error EXCEPTION;
  g_rtnmsg VARCHAR2(3000);

  c_seq_sn NUMBER := 0;

  PROCEDURE do_bank_return_exception(p_error_messages VARCHAR2) IS
  BEGIN
    sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => p_error_messages,
                                                   p_created_by              => -1,
                                                   p_package_name            => 'cux_payment_pkg',
                                                   p_procedure_function_name => 'do_bank_return_exception');
    --RAISE cp_payment_interface.g_bank_return_exception;
    raise_application_error(sys_raise_app_error_pkg.c_error_number,
                            p_error_messages);
  END;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/26 14:18:34
  -- Ver     : 1.1
  -- Purpose : 备份失败的资金接口数据
  **************************************************/
  PROCEDURE backup_failed_zj_info(p_info_id NUMBER) IS
    --PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    --归档单据信息
    INSERT INTO cux_payment_doc_info_his
      SELECT *
        FROM cux_payment_doc_info i
       WHERE i.interface_id = p_info_id;
  
    --归档接口信息
    INSERT INTO cux_payment_interface_his
      SELECT *
        FROM cux_payment_interface i
       WHERE i.id = (SELECT di.interface_id
                       FROM cux_payment_doc_info di
                      WHERE di.interface_id = p_info_id);
  
    --删除接口信息
    DELETE FROM cux_payment_interface i
     WHERE i.id = (SELECT di.interface_id
                     FROM cux_payment_doc_info di
                    WHERE di.interface_id = p_info_id);
  
    --删除单据信息
    DELETE FROM cux_payment_doc_info i WHERE i.interface_id = p_info_id;
    --commit;
  END backup_failed_zj_info;

  FUNCTION payment_head_serial_num(p_doc_type                 VARCHAR2,
                                   p_document_payment_line_id NUMBER,
                                   p_payment_interface_id     NUMBER,
                                   p_urid                     NUMBER)
    RETURN VARCHAR2 IS
    v_result        VARCHAR2(50);
    v_old_urid      NUMBER;
    v_repament_flag NUMBER;
  BEGIN
    --判断是否是重新支付  如果为重新支付的 重新生成流水号
    SELECT COUNT(*)
      INTO v_repament_flag
      FROM jx_ats_pay_trans_interface j
     WHERE j.urid = (SELECT jpi.old_urid
                       FROM jx_ats_pay_trans_interface jpi
                      WHERE jpi.urid = p_urid)
       AND j.hec_status = 9;
  
    BEGIN
      SELECT doc_head_serial_num
        INTO v_result
        FROM cp_payment_data_interface cpdi
       WHERE --cpdi.doc_head_id = p_head_id
      --AND 
       cpdi.doc_type = p_doc_type
      --AND cpdi.doc_line_id = p_line_id
       AND cpdi.document_payment_line_id = p_document_payment_line_id
       AND v_repament_flag = 0
       AND rownum = 1;
    
    EXCEPTION
      WHEN no_data_found THEN
        --报销
        IF (p_doc_type = 'EXP_REPORT') THEN
          v_result := 'P07' || 'BX' || to_char(SYSDATE, 'yyyymmddhhmiss') ||
                      zj_serial_number_s.nextval;
          --借款
        ELSIF (p_doc_type = 'PAYMENT_REQUISITION') THEN
          v_result := 'P07' || 'JK' || to_char(SYSDATE, 'yyyymmddhhmiss') ||
                      zj_serial_number_s.nextval;
          --付款单
        ELSE
          v_result := 'P07' || 'FK' || to_char(SYSDATE, 'yyyymmddhhmiss') ||
                      zj_serial_number_s.nextval;
        
        END IF;
    END;
  
    RETURN v_result;
  END payment_head_serial_num;

  /*************************************************
  -- Author  : HM
  -- Created : 2016/11/23 11:40:57
  -- Purpose : 获取交易流水号
  **************************************************/
  FUNCTION get_seq_sn RETURN VARCHAR2 IS
    v_seq_sn VARCHAR2(10);
  BEGIN
    c_seq_sn := c_seq_sn + 1;
    v_seq_sn := to_char(c_seq_sn, 'FM0000000000');
    v_seq_sn := substr(v_seq_sn, 7, 4);
    RETURN v_seq_sn;
  END get_seq_sn;

  /*************************************************
  -- Author  : HM
  -- Created : 2016/11/21 16:20:15
  -- Purpose : 报文处理
  **************************************************/
  FUNCTION get_request_xml(p_src_xml VARCHAR2, p_param zj_record)
    RETURN VARCHAR2 IS
    v_request_xml  VARCHAR2(6000) := TRIM(p_src_xml);
    v_seq_sn       VARCHAR2(10) := get_seq_sn; --交易流水号的最后4位流水，默认4位
    v_sysdate      DATE := SYSDATE; --当前日期时间
    v_pay_code_pre NUMBER;
  BEGIN
    --支付相关字段
    v_request_xml := REPLACE(v_request_xml, '#TransSource#', c_source); --交易来源：固定值P01
    v_request_xml := REPLACE(v_request_xml, '#TransCodeP#', c_pay_code); --交易编码：批量代付
    v_request_xml := REPLACE(v_request_xml, '#TransCodeG#', c_gather_code); --交易编码：批量代收
    v_request_xml := REPLACE(v_request_xml,
                             '#TransDate#',
                             to_char(v_sysdate, 'yyyymmdd')); --交易日期：当前日期
    v_request_xml := REPLACE(v_request_xml,
                             '#TransTime#',
                             to_char(v_sysdate, 'hh24miss')); --交易时间：当前时间
    v_request_xml := REPLACE(v_request_xml,
                             '#TransSeq#',
                             to_char(v_sysdate, 'yyyymmddhh24miss') ||
                             v_seq_sn); --交易流水号:年月日流水号
    v_request_xml := REPLACE(v_request_xml,
                             '#ReqSeqID#',
                             p_param.head_serial_num); --交易批号：H1交易来源+全局唯一的付款流水号
    v_request_xml := REPLACE(v_request_xml, '#TotalCount#', '1'); --总笔数：固定值1
    v_request_xml := REPLACE(v_request_xml,
                             '#TotalAmount#',
                             p_param.total_amount); --总金额（无正负号）
    v_request_xml := REPLACE(v_request_xml,
                             '#RdSeq#',
                             p_param.head_serial_num); --指令顺序号：H1交易来源+全局唯一的付款流水号
    v_request_xml := REPLACE(v_request_xml,
                             '#PayDate#',
                             to_char(p_param.audit_date, 'yyyymmdd')); --支付日期：取复核日期
    v_request_xml := REPLACE(v_request_xml,
                             '#ApplyEntity#',
                             p_param.company_code); --申请组织
    --v_request_xml := REPLACE(v_request_xml, '#PayType#', p_param.useds); --付款用途 计划付款行
    v_request_xml := REPLACE(v_request_xml, '#PayType#', p_param.paytype);
    v_request_xml := REPLACE(v_request_xml,
                             '#SettlementMode#',
                             p_param.settlement_mode); --结算方式：固定值转账   1-直联 2-网银 3-支票 4-虚拟付款 5-外币 9-其他非直联
    v_request_xml := REPLACE(v_request_xml, '#CorpAct#', p_param.corpact); --结算账号：不填写
    v_request_xml := REPLACE(v_request_xml,
                             '#OppAct#',
                             p_param.payee_account); --交易方账户：收款方账户
    v_request_xml := REPLACE(v_request_xml,
                             '#OppActName#',
                             p_param.payee_name); --交易方户名：收款方户名
    v_request_xml := REPLACE(v_request_xml,
                             '#OppAreaCode#',
                             p_param.pay_area_code); --交易方区域编码
    v_request_xml := REPLACE(v_request_xml,
                             '#OppBankCode#',
                             p_param.pay_bank_code); --交易方银行编码：大行编号3位
    v_request_xml := REPLACE(v_request_xml,
                             '#OppBankLocation#',
                             p_param.pay_bank_name); --交易方开户行名称
    v_request_xml := REPLACE(v_request_xml,
                             '#CNAPSCode#',
                             p_param.pay_bank_num); --交易方联行号代码
    v_request_xml := REPLACE(v_request_xml, '#Cur#', p_param.currency_code); --币种
    v_request_xml := REPLACE(v_request_xml, '#Amount#', p_param.amount); --金额
    v_request_xml := REPLACE(v_request_xml,
                             '#PrivateFlag#',
                             p_param.pay_type); --公私标志
    v_request_xml := REPLACE(v_request_xml, '#Purpose#', p_param.purpose); --用途
    v_request_xml := REPLACE(v_request_xml, '#Memo#', ''); --备注
    v_request_xml := REPLACE(v_request_xml,
                             '#Description#',
                             substrb(p_param.pmt_summary, 0, 256)); --计划付款行摘要
    v_request_xml := REPLACE(v_request_xml, '#CardType#', '2'); --卡折标志：固定值借记卡2
    v_request_xml := REPLACE(v_request_xml, '#CertType#', ''); --证件类型：空
    v_request_xml := REPLACE(v_request_xml, '#CertNumber#', ''); --证件号码：空
    v_request_xml := REPLACE(v_request_xml,
                             '#SourceNoteCode#',
                             p_param.csh_transaction_number); --来源系统单据号码
    v_request_xml := REPLACE(v_request_xml,
                             '#PaymentCode#',
                             p_param.source_business_number); --来源系统单据号码：业务编号                      
    /* v_request_xml := REPLACE(v_request_xml,
                             '#AuditPerson#',
                             p_param.audit_person); --稽核人
    v_request_xml := REPLACE(v_request_xml,
                             '#AuditTime#',
                             to_char(p_param.audit_time, 'yyyymmddhh24miss'));*/
    v_request_xml := REPLACE(v_request_xml,
                             '#ReqReserved3#',
                             p_param.doc_number);
    v_request_xml := REPLACE(v_request_xml,
                             '#ReqReserved4#',
                             p_param.doc_type);
    v_request_xml := REPLACE(v_request_xml,
                             '#ReqReserved5#',
                             p_param.partner_category);
  
    --v_request_xml := REPLACE(v_request_xml, '#Description#', ''); --空
    RETURN v_request_xml;
  END;

  FUNCTION zj_xml_packing(p_xml VARCHAR2) RETURN VARCHAR2 IS
    v_xml     sys.xmltype;
    v_xml_str VARCHAR2(6000);
  BEGIN
    --构建xml结构
    SELECT xmlelement("soapenv:Envelope",
                      xmlattributes(soapenv AS "xmlns:soapenv",
                                    ser AS "xmlns:ser",
                                    dto AS "xmlns:dto"),
                      xmlelement("soapenv:Header"),
                      xmlelement("soapenv:Body",
                                 xmlelement("ser:getMsg",
                                            xmlelement("ser:in0",
                                                       xmlelement("dto:type",
                                                                  type_value),
                                                       xmlelement("dto:xml",
                                                                  xml_value))))) requext_xml
      INTO v_xml
      FROM (SELECT 'http://schemas.xmlsoap.org/soap/envelope/' AS soapenv,
                   'http://service.hundsun.com' AS ser,
                   'http://dto.hundsun.com' AS dto,
                   c_type_value type_value,
                   '<![CDATA[' || p_xml || ']]>' xml_value
              FROM dual);
    v_xml_str := v_xml.getstringval();
    v_xml_str := REPLACE(v_xml_str, '&lt;', '<');
    v_xml_str := REPLACE(v_xml_str, '&gt;', '>');
    v_xml_str := REPLACE(v_xml_str, '&quot;', '"');
  
    csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                          p_log_desc  => '组装支付报文：' || v_xml_str,
                          p_ref_table => '',
                          p_ref_field => '',
                          p_ref_id    => 1,
                          p_user_id   => 1);
  
    RETURN v_xml_str;
  END;

  FUNCTION zj_xml_unpacking(p_clob CLOB) RETURN sys.xmltype IS
    v_result_str VARCHAR2(6000);
    v_xml        sys.xmltype;
    v_result_xml sys.xmltype;
  BEGIN
    /*v_result_str := p_xml.extract('/soap:Envelope/soap:Body/ns1:getMsgResponse/ns1:out/xml')
    .getstringval();*/
    v_result_str := v_xml.getstringval();
  
    v_result_str := REPLACE(v_result_str, '<![CDATA[', '');
    v_result_str := REPLACE(v_result_str, ']]>', '');
  
    v_result_str := REPLACE(v_result_str, '&lt;', '<');
    v_result_str := REPLACE(v_result_str, '&gt;', '>');
  
    v_result_xml := sys.xmltype.createxml(v_result_str);
  
    RETURN v_result_xml;
  END;

  PROCEDURE insert_payment_interface_data(p_interface_id             OUT NUMBER,
                                          p_doc_head_id              NUMBER,
                                          p_doc_head_num             VARCHAR2,
                                          p_doc_head_serial_num      VARCHAR2,
                                          p_doc_line_id              NUMBER,
                                          p_doc_line_serial_num      VARCHAR2,
                                          p_doc_type                 VARCHAR2,
                                          p_currency                 VARCHAR2,
                                          p_gather_account           VARCHAR2,
                                          p_gather_account_name      VARCHAR2,
                                          p_gather_branch_bank_num   VARCHAR2,
                                          p_gather_branch_bank_name  VARCHAR2,
                                          p_gather_bank_num          VARCHAR2,
                                          p_gather_bank_name         VARCHAR2,
                                          p_gather_book_card         VARCHAR2,
                                          p_amount                   NUMBER,
                                          p_prop_flag                VARCHAR2,
                                          p_union_flag               VARCHAR2,
                                          p_gather_province_code     VARCHAR2,
                                          p_gather_province_name     VARCHAR2,
                                          p_gather_city_code         VARCHAR2,
                                          p_gather_city_name         VARCHAR2,
                                          p_pay_status               VARCHAR2,
                                          p_creation_date            DATE,
                                          p_created_by               NUMBER,
                                          p_last_update_date         DATE,
                                          p_last_updated_by          NUMBER,
                                          p_memo                     VARCHAR2,
                                          p_urid                     NUMBER,
                                          p_document_payment_line_id NUMBER,
                                          p_payment_interface_id     NUMBER) IS
    v_count                        NUMBER;
    v_cp_payment_data_interface_id NUMBER;
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM cp_payment_data_interface cpdi
     WHERE cpdi.document_payment_line_id = p_document_payment_line_id
       AND cpdi.payment_interface_id = p_payment_interface_id
       AND cpdi.doc_type = p_doc_type;
  
    IF (v_count = 0) THEN
      SELECT cp_payment_data_interface_s.nextval
        INTO v_cp_payment_data_interface_id
        FROM dual;
      p_interface_id := v_cp_payment_data_interface_id;
    
      INSERT INTO cp_payment_data_interface
        (cp_payment_data_interface_id,
         doc_head_id,
         doc_head_num,
         doc_head_serial_num,
         doc_line_id,
         doc_line_serial_num,
         doc_type,
         currency,
         gather_account,
         gather_account_name,
         gather_branch_bank_num,
         gather_branch_bank_name,
         gather_bank_num,
         gather_bank_name,
         gather_book_card,
         amount,
         prop_flag,
         union_flag,
         gather_province_code,
         gather_province_name,
         gather_city_code,
         gather_city_name,
         pay_status,
         creation_date,
         created_by,
         last_update_date,
         last_updated_by,
         send_time,
         memo,
         source_urid,
         document_payment_line_id,
         payment_interface_id)
      VALUES
        (v_cp_payment_data_interface_id,
         p_doc_head_id,
         p_doc_head_num,
         p_doc_head_serial_num,
         p_doc_line_id,
         p_doc_line_serial_num,
         p_doc_type,
         p_currency,
         p_gather_account,
         p_gather_account_name,
         p_gather_branch_bank_num,
         p_gather_branch_bank_name,
         p_gather_bank_num,
         p_gather_bank_name,
         p_gather_book_card,
         p_amount,
         p_prop_flag,
         p_union_flag,
         p_gather_province_code,
         p_gather_province_name,
         p_gather_city_code,
         p_gather_city_name,
         p_pay_status,
         p_creation_date,
         p_created_by,
         p_last_update_date,
         p_last_updated_by,
         SYSDATE,
         p_memo,
         p_urid,
         p_document_payment_line_id,
         p_payment_interface_id);
    END IF;
  
    COMMIT;
  END insert_payment_interface_data;

  /*************************************************
  -- Author  : HM
  -- Created : 2016/11/24 11:10:30
  -- Purpose : 解析资金返回信息
  **************************************************/
  PROCEDURE resolve_zj_response_xml(p_xml             CLOB,
                                    p_interface_id    NUMBER,
                                    p_urid            NUMBER,
                                    p_user_id         NUMBER,
                                    p_document_number VARCHAR2) IS
    v_result              sys.xmltype;
    v_trade_source        VARCHAR2(100);
    v_trade_seq           VARCHAR2(100);
    v_trade_code          VARCHAR2(10);
    v_return_code         VARCHAR2(30);
    v_return_msg          VARCHAR2(3000);
    v_req_seq_id          VARCHAR2(100);
    v_pay_trans_interface jx_ats_pay_trans_interface%ROWTYPE;
  BEGIN
  
    SELECT j.*
      INTO v_pay_trans_interface
      FROM jx_ats_pay_trans_interface j
     WHERE j.urid = p_urid;
  
    --接口表状态 0-待发送  1-支付中 4-支付成功  3-支付失败  5-退票 6-暂挂 7-导入失败 8-取消付款 9-重新支付
    csh_ebank_log_pkg.log(p_level           => csh_ebank_log_pkg.c_log_level_info,
                          p_log_desc        => '正在解析返回报文,报文内容：' || p_xml,
                          p_ref_table       => '',
                          p_ref_field       => '',
                          p_ref_id          => p_interface_id,
                          p_user_id         => p_user_id,
                          p_document_number => p_document_number);
  
    v_result := sys.xmltype.createxml(p_xml);
  
    SELECT extractvalue(v_result, '/ATS/PUB/TransSource'),
           extractvalue(v_result, '/ATS/PUB/TransSeq'),
           extractvalue(v_result, '/ATS/PUB/TransCode'),
           extractvalue(v_result, '/ATS/PUB/RtnCode'),
           extractvalue(v_result, '/ATS/PUB/RtnMsg'),
           extractvalue(v_result, '/ATS/OUT/ReqSeqID')
      INTO v_trade_source,
           v_trade_seq,
           v_trade_code,
           v_return_code,
           v_return_msg,
           v_req_seq_id
      FROM dual;
    --代付 
    IF v_trade_code = c_pay_code THEN
      --资金接收成功
      IF v_return_code = c_return_success THEN
        csh_ebank_log_pkg.log(p_level           => csh_ebank_log_pkg.c_log_level_info,
                              p_log_desc        => '资金系统返回信息：' ||
                                                   v_return_code || ' - ' ||
                                                   v_return_msg,
                              p_ref_table       => 'CP_PAYMENT_DATA_INTERFACE',
                              p_ref_field       => 'cp_payment_data_interface_id',
                              p_ref_id          => p_interface_id,
                              p_user_id         => p_user_id,
                              p_document_number => p_document_number);
      
        UPDATE jx_ats_pay_trans_interface i
           SET i.hec_status   = 1, --支付中
               i.pay_state    = 1,
               i.serialnumber = v_req_seq_id --更新交易流水号
         WHERE i.urid = p_urid;
      
        /*UPDATE cp_payment_data_interface cpi
          SET cpi.pay_status = 1
        WHERE cpi.cp_payment_data_interface_id = p_interface_id;*/
      
        /****************更新费控支付接口表 ******************/
        --收付费应付接口表
        UPDATE cux_payment_interface c
           SET c.datastatus = '2', c.batchno = v_req_seq_id, c.isreturn = 1
         WHERE c.id = v_pay_trans_interface.payment_interface_id;
      
        --资金接口_单据资金信息表
        UPDATE cux_payment_doc_info di
           SET di.zj_import_date = SYSDATE,
               di.zj_deal_date   = SYSDATE,
               di.datastatus     = '2',
               di.zj_error_msg   = '资金引入成功，结果为：' || v_return_msg
         WHERE di.interface_id = v_pay_trans_interface.payment_interface_id;
      
        /****************更新费控支付接口表******************/
      
        --资金数据校验，报错
      ELSIF v_return_code = c_return_duplicate THEN
        csh_ebank_log_pkg.log(p_level           => csh_ebank_log_pkg.c_log_level_info,
                              p_log_desc        => '资金系统返回信息：' ||
                                                   v_return_code || ' - ' ||
                                                   v_return_msg || '，ID为:' ||
                                                   p_interface_id,
                              p_ref_table       => 'CP_PAYMENT_DATA_INTERFACE',
                              p_ref_field       => 'cp_payment_data_interface_id',
                              p_ref_id          => p_interface_id,
                              p_user_id         => p_user_id,
                              p_document_number => p_document_number);
        --当作支付失败处理
        UPDATE jx_ats_pay_trans_interface i
           SET i.hec_status   = 3, --支付失败
               i.pay_state    = 3,
               i.serialnumber = v_req_seq_id --更新交易流水号
         WHERE i.urid = p_urid;
      
        /*UPDATE cp_payment_data_interface cpi
          SET cpi.pay_status = 3
        WHERE cpi.cp_payment_data_interface_id = p_interface_id;*/
      
        /****************更新费控支付接口表 ******************/
        --收付费应付接口表
        UPDATE cux_payment_interface c
           SET c.datastatus = '3', c.isreturn = 1, c.batchno = v_req_seq_id
         WHERE c.id = v_pay_trans_interface.payment_interface_id;
      
        --资金接口_单据资金信息表
        UPDATE cux_payment_doc_info di
           SET di.zj_import_date = SYSDATE,
               di.zj_deal_date   = SYSDATE,
               di.datastatus     = '3',
               di.zj_error_msg   = '资金引入失败，结果为：' || v_return_msg
         WHERE di.interface_id = v_pay_trans_interface.payment_interface_id;
      
        /****************更新费控支付接口表******************/
      
      ELSE
        csh_ebank_log_pkg.log(p_level           => csh_ebank_log_pkg.c_log_level_error,
                              p_log_desc        => '资金系统返回信息：' ||
                                                   v_return_code || ' - ' ||
                                                   v_return_msg || '，ID为:' ||
                                                   p_interface_id,
                              p_ref_table       => 'CP_PAYMENT_DATA_INTERFACE',
                              p_ref_field       => 'cp_payment_data_interface_id',
                              p_ref_id          => p_interface_id,
                              p_user_id         => p_user_id,
                              p_document_number => p_document_number);
      
        do_bank_return_exception('资金系统数据接收失败' || v_return_msg);
      END IF;
    ELSE
      NULL;
      /* if v_return_code = c_return_success then
        csh_ebank_log_pkg.log(p_level           => csh_ebank_log_pkg.c_log_level_info,
                              p_log_desc        => '资金系统返回信息：' ||
                                                   v_return_code || ' - ' ||
                                                   v_return_msg || '，ID为:' ||
                                                   p_interface_id,
                              p_ref_table       => 'CP_GATHER_DATA_INTERFACE',
                              p_ref_field       => 'cp_gather_data_interface_id',
                              p_ref_id          => p_interface_id,
                              p_user_id         => p_user_id,
                              p_document_number => p_document_number);
      
        \*        update JX_ATS_PAY_TRANS_INTERFACE i
          set i.hec_status   = 1, --支付中
              i.serialnumber = v_req_seq_id --更新交易流水号
        where i.urid = p_urid;*\
      
        update CP_GATHER_DATA_INTERFACE cpi
           set cpi.gather_status = 'U'
         where cpi.cp_gather_data_interface_id = p_interface_id;
      
        --资金数据校验，报错
      else
        \*csh_ebank_log_pkg.log(p_level           => csh_ebank_log_pkg.c_log_level_error,
                              p_log_desc        => '资金系统返回信息：' ||
                                                   v_return_code || ' - ' ||
                                                   v_return_msg || '，ID为:' ||
                                                   p_interface_id,
                              p_ref_table       => 'CP_GATHER_DATA_INTERFACE',
                              p_ref_field       => 'cp_gather_data_interface_id',
                              p_ref_id          => p_interface_id,
                              p_user_id         => p_user_id,
                              p_document_number => p_document_number);*\
      
        --邮件提醒
       \* send_mail(p_document_number => p_document_number,
                  p_error_msg       => v_return_msg);*\
      
        do_bank_return_exception('资金系统数据接收失败' || v_return_msg);
      
      end if;*/
    END IF;
  END resolve_zj_response_xml;

  /*************************************************
  -- Author  : HM
  -- Created : 2016/11/23 15:01:06
  -- Purpose : 资金收付接口主程序
  **************************************************/
  PROCEDURE ws_post_zj(p_interface_id NUMBER,
                       p_user_id      NUMBER,
                       p_csh_type     VARCHAR2) IS
    CURSOR c1 IS
      SELECT *
        FROM jx_ats_pay_trans_interface jpi
       WHERE jpi.urid = p_interface_id
         AND p_csh_type = 'pay'
         FOR UPDATE NOWAIT;
  
    /*CURSOR c2 IS
    SELECT *
      FROM csh_repayment_requisition crr
     WHERE crr.csh_repayment_requisition_id = p_interface_id
       and p_csh_type = 'gather'
       FOR UPDATE NOWAIT;*/
  
    v_request_xml     CLOB;
    v_result          CLOB;
    v_request_id      NUMBER;
    v_doc_line_id     NUMBER;
    v_open_bank       VARCHAR2(10);
    v_bank            VARCHAR2(10);
    v_open_bank_name  VARCHAR2(200);
    v_interface_id    NUMBER;
    v_head_serial_num VARCHAR2(50);
    v_error_msg       VARCHAR2(500);
    v_area_code       VARCHAR2(50);
    v_area_name       VARCHAR2(200);
    v_company_code    VARCHAR2(50);
    v_document_number VARCHAR2(50);
    v_gather_account  VARCHAR2(50);
    v_paytype         VARCHAR2(10);
    v_payment_record  zj_record;
    v_gather_record   zj_record;
    v_doc_info        cux_payment_doc_info%ROWTYPE;
    v_interface_msg   jx_ats_pay_trans_interface%ROWTYPE;
    --v_gather_interface_msg  csh_repayment_requisition%rowtype;
    v_exp_employee_accounts exp_employee_accounts%ROWTYPE;
    --v_line_info             repayment_ref_refund_amount%rowtype;
    e_locked_error  EXCEPTION;
    e_account_error EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_locked_error, -54);
  
  BEGIN
  
    IF p_csh_type = 'pay' THEN
      -- LOCK TABLE
      OPEN c1;
      --------------------------------------付款数据准备------------------------------------
      --支付行信息
      SELECT *
        INTO v_interface_msg
        FROM jx_ats_pay_trans_interface jpi
       WHERE jpi.urid = p_interface_id;
    
      --支付数据明细
      SELECT c.*
        INTO v_doc_info
        FROM cux_payment_doc_info c
       WHERE c.interface_id = v_interface_msg.payment_interface_id;
    
      v_document_number := v_interface_msg.source_notecode;
      --获取支付头流水
      v_head_serial_num := payment_head_serial_num(p_doc_type                 => v_doc_info.document_category,
                                                   p_document_payment_line_id => v_interface_msg.document_payment_line_id,
                                                   p_payment_interface_id     => v_interface_msg.payment_interface_id,
                                                   p_urid                     => v_interface_msg.urid);
    
      --业务类型 
      IF v_doc_info.document_category = 'EXP_REPORT' THEN
        SELECT t.expense_report_type_code
          INTO v_paytype
          FROM exp_expense_report_types_vl t
         WHERE t.expense_report_type_id =
               (SELECT h.exp_report_type_id
                  FROM exp_report_headers h
                 WHERE h.exp_report_header_id = v_doc_info.document_id);
      
      ELSIF v_doc_info.document_category = 'PAYMENT_REQUISITION' THEN
        SELECT t.type_code
          INTO v_paytype
          FROM csh_pay_req_types_vl t
         WHERE t.type_id = (SELECT h.payment_req_type_id
                              FROM csh_payment_requisition_hds h
                             WHERE h.payment_requisition_header_id =
                                   v_doc_info.document_id);
      
      ELSIF v_doc_info.document_category = 'ACP_REQUISITION' THEN
        SELECT t.acp_req_type_code
          INTO v_paytype
          FROM acp_sys_acp_req_types t
         WHERE t.acp_req_type_id =
               (SELECT h.acp_req_type_id
                  FROM acp_acp_requisition_hds h
                 WHERE h.acp_requisition_header_id = v_doc_info.document_id);
      END IF;
    
      --获取银行大类和描述
      SELECT v.bank_code, v.bank_name, v.area_code, v.area_name
        INTO v_open_bank, v_open_bank_name, v_area_code, v_area_name
        FROM br_hfm_bank_v v
       WHERE v.bank_branch_num = v_interface_msg.rec_bank;
    
      --银行大类转换英文简称
      SELECT t.code
        INTO v_bank
        FROM ZJ_BR_BANKS t
       WHERE t.directbankcode = v_open_bank
         and rownum = 1;
    
      --整理数据
      SELECT v_interface_msg.origin_note, --现金事务编号
             v_interface_msg.csh_transaction_header_id, --现金事务头id
             v_head_serial_num, --头流水
             v_interface_msg.csh_transaction_line_id, --现金事务行id
             v_interface_msg.sourcebusinessno, --原单据编号
             v_interface_msg.bank_money,
             v_interface_msg.pay_date,
             v_interface_msg.apply_entity_code,
             v_doc_info.document_category, --来源类型
             v_interface_msg.rec_account,
             v_interface_msg.rec_account_name,
             v_area_code,
             v_bank,
             v_open_bank_name,
             v_interface_msg.rec_bank_locations,
             v_interface_msg.rec_bank,
             v_interface_msg.rec_currency,
             v_interface_msg.rec_money,
             v_interface_msg.isprivate,
             v_interface_msg.memo,
             p_user_id,
             v_interface_msg.usedes,
             v_interface_msg.summary,
             v_interface_msg.partner_category,
             v_interface_msg.settlement_mode, --计算方式
             v_interface_msg.purpose, --用途,
             /*v_interface_msg.audit_person, --稽核人
             v_interface_msg.audit_time, --稽核时间，*/
             NULL, --付款时，企业付款账号不传
             v_interface_msg.source_notecode,
             v_paytype
        INTO v_payment_record
        FROM dual;
      --处理报文
      v_request_xml := get_request_xml(c_pay_xml, v_payment_record);
      --封装报文
      v_request_xml := zj_xml_packing(v_request_xml);
    
      csh_ebank_log_pkg.log(p_level           => csh_ebank_log_pkg.c_log_level_info,
                            p_log_desc        => substr('支付报文处理完毕，报文内容为：' ||
                                                        v_request_xml ||
                                                        '，正在发送，INFO_ID为:' ||
                                                        v_interface_id,
                                                        1,
                                                        4000),
                            p_ref_table       => '',
                            p_ref_field       => '',
                            p_ref_id          => '',
                            p_user_id         => p_user_id,
                            p_document_number => v_interface_msg.source_notecode);
    
      --插入付款接口表
      insert_payment_interface_data(p_interface_id             => v_interface_id,
                                    p_doc_head_id              => v_interface_msg.csh_transaction_header_id, --现金事务头id
                                    p_doc_head_num             => v_interface_msg.origin_note, --现金事务编号
                                    p_doc_head_serial_num      => v_head_serial_num,
                                    p_doc_line_id              => v_interface_msg.csh_transaction_line_id,
                                    p_doc_line_serial_num      => '',
                                    p_doc_type                 => v_doc_info.document_category,
                                    p_currency                 => v_interface_msg.rec_currency,
                                    p_gather_account           => v_interface_msg.rec_account,
                                    p_gather_account_name      => v_interface_msg.rec_account_name,
                                    p_gather_branch_bank_num   => v_interface_msg.rec_bank,
                                    p_gather_branch_bank_name  => v_interface_msg.rec_bank_locations,
                                    p_gather_bank_num          => v_open_bank,
                                    p_gather_bank_name         => v_open_bank_name,
                                    p_gather_book_card         => 2, --卡折标识 1：存折 2借记卡
                                    p_amount                   => v_interface_msg.rec_money,
                                    p_prop_flag                => v_interface_msg.isprivate,
                                    p_union_flag               => '',
                                    p_gather_province_code     => '',
                                    p_gather_province_name     => '',
                                    p_gather_city_code         => substr(TRIM(v_interface_msg.rec_bank_area),
                                                                         0,
                                                                         4),
                                    p_gather_city_name         => '',
                                    p_pay_status               => '0', --未支付
                                    p_creation_date            => SYSDATE,
                                    p_created_by               => p_user_id,
                                    p_last_update_date         => SYSDATE,
                                    p_last_updated_by          => p_user_id,
                                    p_memo                     => v_interface_msg.memo,
                                    p_urid                     => v_interface_msg.urid,
                                    p_document_payment_line_id => v_interface_msg.document_payment_line_id,
                                    p_payment_interface_id     => v_interface_msg.payment_interface_id);
    
      --发送并获取返回报文
      v_result := cux_ws_request_pkg.call_web_service_zj(p_ws_url          => g_ws_url,
                                                         p_request_body    => v_request_xml,
                                                         p_document_number => v_document_number,
                                                         p_inner_root_name => 'xml',
                                                         p_request_id      => v_request_id);
    
      ---------------------------------付款数据准备完成------------------------------
      -- CLOSE CURSOR
      CLOSE c1;
      /*elsif p_csh_type = 'gather' then
      -- LOCK TABLE
      OPEN c2;
      ---------------------------------收款数据准备--------------------------------------
      --收款行信息
      SELECT *
        into v_gather_interface_msg
        FROM csh_repayment_requisition crr
       WHERE crr.csh_repayment_requisition_id = p_interface_id;
      
      v_document_number := v_gather_interface_msg.csh_repayment_req_number;
      --机构代码
      select fc.company_code
        into v_company_code
        from fnd_companies fc
       where fc.company_id = v_gather_interface_msg.company_id;
      
      --企业收款账号
      select cba.bank_account_num
        into v_gather_account
        from csh_bank_accounts_vl cba
       where cba.bank_account_id = v_gather_interface_msg.bank_account_id;
      
      --获取支付头流水
      v_head_serial_num := gather_head_serial_num(p_doc_type => v_gather_interface_msg.return_type,
                                                  p_head_id  => v_gather_interface_msg.csh_repayment_requisition_id);
      
      -- 付款账号为新增人的主账号
      BEGIN
        SELECT eea.*
          INTO v_exp_employee_accounts
          FROM exp_employee_accounts eea, sys_user u
         where eea.employee_id = u.Employee_Id
           AND u.user_id = v_gather_interface_msg.created_by
           AND eea.primary_flag = 'Y'
           AND eea.enabled_flag = 'Y';
      EXCEPTION
        WHEN OTHERS THEN
          v_error_msg := '未找到当前员工的主账号';
          RAISE e_account_error;
      END;
      
      -- 行
      SELECT *
        INTO v_line_info
        FROM repayment_ref_refund_amount rf
       WHERE rf.csh_repayment_req_id = p_interface_id
         AND rf.transaction_line_id =
             (SELECT l.transaction_line_id
                FROM csh_transaction_lines l
               WHERE l.transaction_header_id =
                     v_gather_interface_msg.transaction_header_id);
      
      --获取银行大类和描述
      select v.ats_bank_dcode,
             v.ats_bank_name,
             v.ats_area_code,
             v.ats_area_name
        into v_open_bank, v_open_bank_name, v_area_code, v_area_name
        from bcdl_bank_num_v v
       where v.ats_cnaps_code = v_exp_employee_accounts.bank_location_code;
      
      --准备收款数据
      select v_gather_interface_msg.csh_repayment_req_number,
             v_gather_interface_msg.csh_repayment_requisition_id,
             v_head_serial_num,
             '',
             v_gather_interface_msg.csh_repayment_req_number,
             v_line_info.refund_amont,
             v_gather_interface_msg.return_date, --还款日期
             v_company_code, --机构
             v_gather_interface_msg.return_type,
             v_exp_employee_accounts.account_number,
             v_exp_employee_accounts.account_name,
             v_area_code,
             v_open_bank,
             v_open_bank_name,
             v_exp_employee_accounts.bank_location,
             v_exp_employee_accounts.bank_location_code,
             'CNY',
             v_line_info.refund_amont,
             '1',
             v_gather_interface_msg.descrpition,
             p_user_id,
             '还款', --付款用途
             '',
             '员工',
             '4', --收款结算方式全部未 虚拟支付
             '', --收款单用途 传空
             '', --收款无稽核人
             '', --收款无稽核时间
             v_gather_account --企业收款账户
        into v_gather_record
        from dual;
      
      --处理报文
      v_request_xml := get_request_xml(c_gather_xml, v_gather_record);
      --封装报文
      v_request_xml := zj_xml_packing(v_request_xml);
      
      csh_ebank_log_pkg.log(p_level           => csh_ebank_log_pkg.c_log_level_info,
                            p_log_desc        => substr('收款报文处理完毕，报文内容为：' ||
                                                        v_request_xml ||
                                                        '，正在发送，INFO_ID为:' ||
                                                        v_interface_id,
                                                        1,
                                                        4000),
                            p_ref_table       => '',
                            p_ref_field       => '',
                            p_ref_id          => '',
                            p_user_id         => p_user_id,
                            p_document_number => v_gather_interface_msg.csh_repayment_req_number);
      
      --插入收款接口表
      insert_gather_interface_data(p_interface_id             => v_interface_id,
                                   p_doc_head_id              => v_gather_interface_msg.csh_repayment_requisition_id,
                                   p_doc_head_num             => v_gather_interface_msg.csh_repayment_req_number,
                                   p_doc_head_serial_num      => v_head_serial_num,
                                   p_doc_line_id              => v_gather_interface_msg.csh_repayment_requisition_id, --还款单没有行id
                                   p_doc_line_serial_num      => '',
                                   p_doc_type                 => v_gather_interface_msg.return_type,
                                   p_currency                 => 'CNY',
                                   p_payment_account          => v_exp_employee_accounts.account_number,
                                   p_payment_account_name     => v_exp_employee_accounts.account_name,
                                   p_payment_branch_bank_num  => v_exp_employee_accounts.bank_location_code,
                                   p_payment_branch_bank_name => v_exp_employee_accounts.bank_location,
                                   p_payment_bank_num         => v_open_bank,
                                   p_payment_bank_name        => v_open_bank_name,
                                   p_payment_book_card        => 2,
                                   p_amount                   => v_line_info.refund_amont,
                                   p_prop_flag                => 1, --公私标志 1 对私，2对公
                                   p_union_flag               => '',
                                   p_payment_area_code        => v_area_code,
                                   p_payment_area_name        => v_area_name,
                                   p_payment_status           => 'P', --收款状态
                                   p_creation_date            => sysdate,
                                   p_created_by               => p_user_id,
                                   p_last_update_date         => sysdate,
                                   p_last_updated_by          => p_user_id,
                                   p_memo                     => v_gather_interface_msg.descrpition,
                                   p_gather_account           => v_gather_account);
      
      --发送并获取返回报文
      v_result := cux_ws_request_pkg.call_web_service_zj(p_ws_url          => g_ws_url,
                                                         p_request_body    => v_request_xml,
                                                         p_document_number => v_document_number,
                                                         p_inner_root_name => 'xml',
                                                         p_request_id      => v_request_id);
      ---------------------------------收款数据准备完成------------------------------------ 
      CLOSE c2;*/
    END IF;
  
    resolve_zj_response_xml(p_xml             => v_result,
                            p_interface_id    => v_interface_id,
                            p_urid            => v_interface_msg.urid,
                            p_user_id         => p_user_id,
                            p_document_number => v_document_number);
  
  EXCEPTION
    WHEN e_account_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '员工未维护主账号' ||
                                                                                  SQLERRM || '-' ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CUX_PAYMENT_PKG',
                                                     p_procedure_function_name => 'WS_POST_ZJ');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      csh_ebank_log_pkg.log(p_level           => csh_ebank_log_pkg.c_log_level_error,
                            p_log_desc        => '报文发送或接收失败' || SQLERRM ||
                                                 chr(10) ||
                                                 dbms_utility.format_error_backtrace,
                            p_ref_table       => '',
                            p_ref_field       => '',
                            p_ref_id          => NULL,
                            p_user_id         => p_user_id,
                            p_document_number => v_document_number);
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '报文发送或接收失败' ||
                                                                                  SQLERRM || '-' ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CUX_PAYMENT_PKG',
                                                     p_procedure_function_name => 'WS_POST_ZJ');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END ws_post_zj;

  PROCEDURE insert_exp_pay_trans_interface(p_trans_interface_id       NUMBER,
                                           p_source_doc_num           VARCHAR2,
                                           p_company_code             VARCHAR2,
                                           p_pay_type_code            VARCHAR2, --付款方式 
                                           p_partner_category         VARCHAR2, --收款方类型
                                           p_partner_code             VARCHAR2, -- 收款方代码
                                           p_payee_city_code          VARCHAR2, -- 收方银行区域代码
                                           p_payee_bank_location_code VARCHAR2, --收方银行开户行联行号
                                           p_payee_bank_location      VARCHAR2, ----收方银行开户行
                                           p_gather_account           VARCHAR2, --收款账号
                                           p_usedes_code              VARCHAR2, --用途
                                           p_source_doc_des           VARCHAR2, --备注,报销单头上备注
                                           p_isprivate                VARCHAR2, --公私标志
                                           p_card_book_flag           VARCHAR2, --卡折标志
                                           p_settlement_mode          VARCHAR2, --结算方式
                                           p_amount                   NUMBER,
                                           p_user_id                  NUMBER, --
                                           p_cash_flow_code           VARCHAR2, --现金流量代码
                                           p_exp_report_pmt_line_id   NUMBER,
                                           p_payment_interface_id     NUMBER) IS
    v_interface_id    NUMBER;
    v_hec_status      NUMBER;
    v_old_urid        NUMBER;
    v_pmt_schedules   exp_report_pmt_schedules%ROWTYPE;
    v_report_headers  exp_report_headers%ROWTYPE;
    v_doc_info        cux_payment_doc_info%ROWTYPE;
    v_trans_interface jx_ats_pay_trans_interface%ROWTYPE;
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
  
    SELECT s.*
      INTO v_pmt_schedules
      FROM exp_report_pmt_schedules s
     WHERE s.payment_schedule_line_id = p_exp_report_pmt_line_id;
  
    SELECT h.*
      INTO v_report_headers
      FROM exp_report_headers h
     WHERE h.exp_report_header_id = v_pmt_schedules.exp_report_header_id;
  
    --判断是否为重新支付
    BEGIN
      --从历史单据信息表中获取已处理的最新id
      SELECT MAX(h.interface_id)
        INTO v_interface_id
        FROM cux_payment_doc_info_his h
       WHERE h.document_line_id = p_exp_report_pmt_line_id
         AND h.datastatus = '3' --支付失败
         AND h.document_category = 'EXP_REPORT'
         AND h.interface_id <> p_payment_interface_id;
    
      SELECT j.*
        INTO v_trans_interface
        FROM jx_ats_pay_trans_interface j
       WHERE j.payment_interface_id = v_interface_id;
    
      --之前已作导入失败或支付失败处理
      IF v_trans_interface.hec_status IN (7, 3) AND
         v_trans_interface.pay_state IN (7, 3) THEN
      
        UPDATE jx_ats_pay_trans_interface j
           SET j.hec_status       = 9, --重新支付
               j.last_updated_by  = 1,
               j.last_update_date = SYSDATE
         WHERE j.urid = v_trans_interface.urid;
      
        v_old_urid := v_trans_interface.urid;
      END IF;
    EXCEPTION
      WHEN no_data_found THEN
        v_hec_status := 0; --未导入
    END;
  
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
       post_flag,
       document_payment_line_id,
       payment_interface_id,
       old_urid)
    VALUES
      (p_trans_interface_id,
       'FPM',
       p_source_doc_num, -- 单据编号
       v_report_headers.exp_report_number, -- 来源单据编号,取报销单编号
       p_company_code, -- 机构
       '',
       SYSDATE, -- 付款时间
       to_char(SYSDATE, 'yyyy-mm-dd'), -- 计划付款时间 (待开发)
       p_settlement_mode, --结算方式
       p_pay_type_code, --付款方式 
       '', --资金类别
       '', --资金子类别
       '', --计划项目
       '', --付方组织
       '', --付方银行
       '', --付方账户
       /*p_partner_category*/
       0, --收款方类型
       p_partner_code, -- 收款方代码
       p_payee_city_code, -- 收方银行区域字段待确认
       p_payee_bank_location_code, --收方银行
       p_payee_bank_location, --收方银行开户行
       p_gather_account,
       --v_payment_record.account_number, --收方账户
       v_pmt_schedules.account_name, --收方户名
       'CNY', --货币
       p_amount, --交易金额
       p_amount, --实付金额
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
       NULL,
       v_pmt_schedules.payee_category,
       v_pmt_schedules.payee_id,
       NULL,
       NULL,
       NULL,
       NULL,
       nvl(v_hec_status, 0),
       NULL,
       NULL,
       p_cash_flow_code, -- 现金流量代码
       NULL,
       '',
       v_report_headers.description,
       'N',
       'N',
       p_exp_report_pmt_line_id,
       p_payment_interface_id,
       v_old_urid);
    COMMIT;
  END;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/26 10:12:10
  -- Ver     : 1.1
    -- Purpose : 插入费控系统资金接口表
  **************************************************/
  PROCEDURE insert_exp_pay_interface(p_id                     NUMBER,
                                     p_billcode               VARCHAR2,
                                     p_datasource             VARCHAR2,
                                     p_inputdate              TIMESTAMP,
                                     p_batchno                VARCHAR2,
                                     p_settlermentdate        DATE,
                                     p_transferdate           DATE,
                                     p_orgcode                VARCHAR2,
                                     p_transfercode           VARCHAR2,
                                     p_paytype                VARCHAR2,
                                     p_abstracts              VARCHAR2,
                                     p_payorgcode             VARCHAR2,
                                     p_payorgname             VARCHAR2,
                                     p_payaccountno           VARCHAR2,
                                     p_payaccountname         VARCHAR2,
                                     p_paybankname            VARCHAR2,
                                     p_payprovince            VARCHAR2,
                                     p_payareanameofcity      VARCHAR2,
                                     p_recorgcode             VARCHAR2,
                                     p_recorgname             VARCHAR2,
                                     p_recaccountno           VARCHAR2,
                                     p_recaccountname         VARCHAR2,
                                     p_recbankname            VARCHAR2,
                                     p_recprovince            VARCHAR2,
                                     p_recareanameofcity      VARCHAR2,
                                     p_bankcodeofrec          VARCHAR2,
                                     p_bankexccodeofrec       VARCHAR2,
                                     p_cnapsofrec             VARCHAR2,
                                     p_paymentno              VARCHAR2,
                                     p_agreementno            VARCHAR2,
                                     p_bankpaytype            VARCHAR2,
                                     p_currencycode           VARCHAR2,
                                     p_amount                 NUMBER,
                                     p_datastatus             CHAR,
                                     p_result                 VARCHAR2,
                                     p_isread                 NUMBER,
                                     p_isreturn               NUMBER,
                                     p_bankerrcode            VARCHAR2,
                                     p_bankerrdesc            VARCHAR2,
                                     p_errcode                VARCHAR2,
                                     p_errdescription         VARCHAR2,
                                     p_transferid             VARCHAR2,
                                     p_instructionid          VARCHAR2,
                                     p_free1                  VARCHAR2,
                                     p_free2                  VARCHAR2,
                                     p_exp_report_pmt_line_id NUMBER) IS
  
    v_trans_interface_id NUMBER;
    v_settlement_mode    VARCHAR2(10);
    v_partner_code       VARCHAR2(30);
    v_partner_name       VARCHAR2(100);
    v_area_code          VARCHAR2(30);
    v_isprivate          VARCHAR2(10);
    v_error_msg          VARCHAR2(300);
    v_bank_location_code VARCHAR2(30);
    v_bank_location      VARCHAR2(100);
    v_pmt_schedules      exp_report_pmt_schedules%ROWTYPE;
  BEGIN
  
    SELECT p.*
      INTO v_pmt_schedules
      FROM exp_report_pmt_schedules p
     WHERE p.payment_schedule_line_id = p_exp_report_pmt_line_id;
  
    INSERT INTO cux_payment_interface
      (id,
       billcode,
       datasource,
       inputdate,
       batchno,
       settlermentdate,
       transferdate,
       orgcode,
       transfercode,
       paytype,
       abstracts,
       payorgcode,
       payorgname,
       payaccountno,
       payaccountname,
       paybankname,
       payprovince,
       payareanameofcity,
       recorgcode,
       recorgname,
       recaccountno,
       recaccountname,
       recbankname,
       recprovince,
       recareanameofcity,
       bankcodeofrec,
       bankexccodeofrec,
       cnapsofrec,
       paymentno,
       agreementno,
       bankpaytype,
       currencycode,
       amount,
       datastatus,
       RESULT,
       isread,
       isreturn,
       bankerrcode,
       bankerrdesc,
       errcode,
       errdescription,
       transferid,
       instructionid,
       free1,
       free2,
       payee_category)
    VALUES
      (p_id,
       p_billcode,
       p_datasource,
       p_inputdate,
       p_batchno,
       p_settlermentdate,
       p_transferdate,
       p_orgcode,
       p_transfercode,
       p_paytype,
       p_abstracts,
       p_payorgcode,
       p_payorgname,
       p_payaccountno,
       p_payaccountname,
       p_paybankname,
       p_payprovince,
       p_payareanameofcity,
       p_recorgcode,
       p_recorgname,
       p_recaccountno,
       p_recaccountname,
       p_recbankname,
       p_recprovince,
       p_recareanameofcity,
       p_bankcodeofrec,
       p_bankexccodeofrec,
       p_cnapsofrec,
       p_paymentno,
       p_agreementno,
       p_bankpaytype,
       p_currencycode,
       p_amount,
       c_datastatus_saved,
       p_result,
       p_isread,
       p_isreturn,
       p_bankerrcode,
       p_bankerrdesc,
       p_errcode,
       p_errdescription,
       p_transferid,
       p_instructionid,
       p_free1,
       p_free2,
       v_pmt_schedules.payee_category);
  
    --获取主键ID编号
    SELECT jx_ats_pay_trans_interface_s.nextval
      INTO v_trans_interface_id
      FROM dual;
  
    -- 结算方式
    /*SELECT decode(m.description, '银企直联', '1', '9')
     INTO v_settlement_mode
     FROM csh_payment_methods_vl m
    WHERE m.payment_method_id = p_paytype;*/
  
    --获取收款方代码及名称
    BEGIN
      IF v_pmt_schedules.payee_category = 'EMPLOYEE' THEN
        SELECT ee.employee_code, ee.name, '1'
          INTO v_partner_code, v_partner_name, v_isprivate
          FROM exp_employees ee
         WHERE ee.employee_id = v_pmt_schedules.payee_id;
      
        SELECT a.bank_location_code, a.bank_location
          INTO v_bank_location_code, v_bank_location
          FROM exp_employee_accounts a
         WHERE a.employee_id = v_pmt_schedules.payee_id
           AND a.account_number = v_pmt_schedules.account_number;
      
      ELSIF v_pmt_schedules.payee_category = 'VENDER' THEN
        SELECT psv.vender_code, psv.description, '2'
          INTO v_partner_code, v_partner_name, v_isprivate
          FROM pur_system_venders_vl psv
         WHERE psv.vender_id = v_pmt_schedules.payee_id;
      
        SELECT a.bank_location_code, a.bank_location
          INTO v_bank_location_code, v_bank_location
          FROM pur_vender_accounts a
         WHERE a.vender_id = v_pmt_schedules.payee_id
           AND a.account_number = v_pmt_schedules.account_number;
      
      ELSE
        SELECT osc.customer_code, osc.description, '2'
          INTO v_partner_code, v_partner_name, v_isprivate
          FROM ord_system_customers_vl osc
         WHERE osc.customer_id = v_pmt_schedules.payee_id;
      
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '收款方银行账户主数据存在错误,请联系管理员维护!',
                                                       p_created_by              => 1,
                                                       p_package_name            => 'cux_payment_pkg',
                                                       p_procedure_function_name => 'insert_exp_pay_interface');
      
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
    END;
  
    --地区代码
    SELECT b.area_code
      INTO v_area_code
      FROM br_hfm_bank_v b
     WHERE b.bank_branch_num = v_bank_location_code;
  
    --插入资金待支付表
    insert_exp_pay_trans_interface(p_trans_interface_id       => v_trans_interface_id,
                                   p_source_doc_num           => p_billcode,
                                   p_company_code             => p_orgcode,
                                   p_pay_type_code            => p_paytype, ----付款方式 
                                   p_partner_category         => v_partner_name, --收款方类型
                                   p_partner_code             => v_partner_code, --收款方类型
                                   p_payee_city_code          => v_area_code, -- 收方银行区域代码
                                   p_payee_bank_location_code => v_bank_location_code, --收方银行开户行联行号
                                   p_payee_bank_location      => v_bank_location, --收方银行开户行
                                   p_gather_account           => p_recaccountno, --收方账号
                                   p_usedes_code              => v_pmt_schedules.usedes, --用途
                                   p_source_doc_des           => v_pmt_schedules.description, --备注,报销单行上备注
                                   p_isprivate                => v_isprivate, --公私标志 必输
                                   p_card_book_flag           => '', --卡折标志  必输
                                   p_settlement_mode          => /*v_settlement_mode*/ p_paytype, --结算方式 必输
                                   p_amount                   => v_pmt_schedules.due_amount,
                                   p_user_id                  => 1,
                                   p_cash_flow_code           => v_pmt_schedules.cash_flow_code, --现金流量代码
                                   p_payment_interface_id     => p_id,
                                   p_exp_report_pmt_line_id   => p_exp_report_pmt_line_id);
  
    --调用资金收付过程 
    BEGIN
      ws_post_zj(p_interface_id => v_trans_interface_id,
                 p_user_id      => 1,
                 p_csh_type     => 'pay');
    EXCEPTION
      WHEN OTHERS THEN
        v_error_msg := SQLERRM || dbms_utility.format_error_backtrace;
        UPDATE jx_ats_pay_trans_interface jpi
           SET jpi.error_message = v_error_msg,
               jpi.hec_status    = '7', --导入失败
               jpi.pay_state     = '7'
         WHERE jpi.urid = v_trans_interface_id;
      
        --收付费应付接口表
        UPDATE cux_payment_interface c
           SET c.datastatus     = '3',
               c.isreturn       = 1,
               c.batchno        = '',
               c.errdescription = '资金接收或支付失败'
         WHERE c.id = p_id;
      
        --资金接口_单据资金信息表
        UPDATE cux_payment_doc_info di
           SET di.zj_import_date = SYSDATE,
               di.zj_deal_date   = SYSDATE,
               di.datastatus     = '3',
               di.zj_error_msg   = '资金接收或支付失败'
         WHERE di.interface_id = p_id;
      
    END;
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => 1,
                                                     p_package_name            => 'cux_payment_gr_pkg',
                                                     p_procedure_function_name => 'insert_exp_pay_interface');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_exp_pay_interface;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/26 14:51:51
  -- Ver     : 1.1
  -- Purpose : 按计划付款行将报销单待支付信息插入到费控资金接口表
  **************************************************/
  PROCEDURE post_exp_rep_by_pmt(p_exp_report_pmt_line_id NUMBER,
                                p_info_id                OUT NUMBER,
                                p_user_id                NUMBER) IS
    v_exp_report_header_id   NUMBER;
    v_exp_report_pmt_line_id NUMBER;
    v_exp_report_number      VARCHAR2(200);
    v_audit_date             DATE;
    v_currency_code          VARCHAR2(30);
    v_company_code           VARCHAR2(200);
    v_payment_method_code    VARCHAR2(10);
    v_payee_account_number   VARCHAR2(200);
    v_payee_account_name     VARCHAR2(200);
    v_payee_bank_code        VARCHAR2(200);
    v_payee_bank_name        VARCHAR2(200);
    v_sparticipantbankno     VARCHAR2(200);
    v_payee_location_name    VARCHAR2(200);
    v_payee_bank_province    VARCHAR2(200);
    v_payee_bank_city        VARCHAR2(200);
    v_account_flag           VARCHAR2(30);
    v_info_id                NUMBER;
    v_interface_id           NUMBER;
    v_billcode               VARCHAR2(50);
    v_gather_flag            VARCHAR2(10);
    v_company_id             NUMBER;
    v_doc_company_id         NUMBER;
  BEGIN
  
    SELECT cux_payment_doc_info_s.nextval INTO v_info_id FROM dual;
  
    SELECT doc_info_s.nextval INTO v_interface_id FROM dual;
    --add by Qu yuanyuan 公司层级中第一个公司
    /*select f.company_id
     into v_company_id
     from fnd_companies f, fnd_company_levels l
    where f.company_level_id = l.company_level_id
      and l.company_level_code = '10'
      and rownum = 1;*/
    /*    v_billcode := 'HEC' || to_char(v_info_id,
    rpad('FM',
         27,
         '0'));*/
  
    SELECT s.company_id
      INTO v_company_id
      FROM exp_report_pmt_schedules s
     WHERE s.payment_schedule_line_id = p_exp_report_pmt_line_id;
  
    v_billcode := fnd_code_rule_pkg.get_rule_next_auto_num(p_document_category => '51',
                                                           p_document_type     => '',
                                                           p_company_id        => v_company_id,
                                                           p_operation_unit_id => '',
                                                           p_operation_date    => SYSDATE,
                                                           p_created_by        => p_user_id);
    --end by Qu yuanyuan
  
    csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                          p_log_desc  => '生成INFO_ID为:' || v_info_id ||
                                         ',接口ID为:' || v_interface_id ||
                                         ',资金编码为' || v_billcode,
                          p_ref_table => 'EXP_REPORT_PMT_SCHEDULES',
                          p_ref_field => 'PAYMENT_SCHEDULE_LINE_ID',
                          p_ref_id    => p_exp_report_pmt_line_id,
                          p_user_id   => p_user_id);
  
    SELECT s.exp_report_header_id,
           s.payment_schedule_line_id,
           h.exp_report_number,
           h.audit_date,
           (SELECT fc.company_code
              FROM fnd_companies fc
             WHERE fc.company_id = h.company_id) AS company_code,
           (CASE (SELECT m.payment_method_code
                FROM csh_payment_methods m
               WHERE m.payment_method_id = s.payment_type_id)
             WHEN '10' THEN
              '1'
             WHEN '20' THEN
              '9'
             WHEN '30' THEN
              '9'
           END) AS payment_method_code,
           (CASE s.payee_category
             WHEN 'VENDER' THEN
              (SELECT v.account_number
                 FROM pur_vender_accounts v
                WHERE v.vender_id = s.payee_id
                  AND v.account_number = s.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.account_number
                 FROM exp_employee_accounts a
                WHERE a.employee_id = s.payee_id
                  AND a.account_number = s.account_number)
           END) AS account_number,
           (CASE s.payee_category
             WHEN 'VENDER' THEN
              (SELECT v.account_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = s.payee_id
                  AND v.account_number = s.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.account_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = s.payee_id
                  AND a.account_number = s.account_number)
           END) AS account_name,
           (CASE s.payee_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_code
                 FROM pur_vender_accounts v
                WHERE v.vender_id = s.payee_id
                  AND v.account_number = s.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_code
                 FROM exp_employee_accounts a
                WHERE a.employee_id = s.payee_id
                  AND a.account_number = s.account_number)
           END) AS bank_code,
           (CASE s.payee_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = s.payee_id
                  AND v.account_number = s.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = s.payee_id
                  AND a.account_number = s.account_number)
           END) AS bank_name,
           (CASE s.payee_category
             WHEN 'VENDER' THEN
              (SELECT v.sparticipantbankno
                 FROM pur_vender_accounts v
                WHERE v.vender_id = s.payee_id
                  AND v.account_number = s.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.sparticipantbankno
                 FROM exp_employee_accounts a
                WHERE a.employee_id = s.payee_id
                  AND a.account_number = s.account_number)
           END) AS sparticipantbankno,
           (CASE s.payee_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_location
                 FROM pur_vender_accounts v
                WHERE v.vender_id = s.payee_id
                  AND v.account_number = s.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_location
                 FROM exp_employee_accounts a
                WHERE a.employee_id = s.payee_id
                  AND a.account_number = s.account_number)
           END) AS bank_location_name,
           (CASE s.payee_category
             WHEN 'VENDER' THEN
              (SELECT v.province_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = s.payee_id
                  AND v.account_number = s.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.province_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = s.payee_id
                  AND a.account_number = s.account_number)
           END) AS province_name,
           (CASE s.payee_category
             WHEN 'VENDER' THEN
              (SELECT v.city_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = s.payee_id
                  AND v.account_number = s.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.city_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = s.payee_id
                  AND a.account_number = s.account_number)
           END) AS city_name,
           CASE (CASE s.payee_category
              WHEN 'VENDER' THEN
               (SELECT v.account_flag
                  FROM pur_vender_accounts v
                 WHERE v.vender_id = s.payee_id
                   AND v.account_number = s.account_number)
              WHEN 'EMPLOYEE' THEN
               (SELECT a.account_flag
                  FROM exp_employee_accounts a
                 WHERE a.employee_id = s.payee_id
                   AND a.account_number = s.account_number)
            END)
             WHEN '10' THEN
              '1'
             WHEN '20' THEN
              '2'
           END,
           h.currency_code,
           s.gather_flag,
           h.company_id
      INTO v_exp_report_header_id,
           v_exp_report_pmt_line_id,
           v_exp_report_number,
           v_audit_date,
           v_company_code,
           v_payment_method_code,
           v_payee_account_number,
           v_payee_account_name,
           v_payee_bank_code,
           v_payee_bank_name,
           v_sparticipantbankno,
           v_payee_location_name,
           v_payee_bank_province,
           v_payee_bank_city,
           v_account_flag,
           v_currency_code,
           v_gather_flag,
           v_doc_company_id
      FROM exp_report_pmt_schedules s, exp_report_headers h
     WHERE s.payment_schedule_line_id = p_exp_report_pmt_line_id
       AND s.exp_report_header_id = h.exp_report_header_id
       FOR UPDATE NOWAIT;
  
    csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                          p_log_desc  => '报销单头ID为:' ||
                                         v_exp_report_header_id ||
                                         ',报销单计划付款行ID为:' ||
                                         v_exp_report_pmt_line_id ||
                                         ',报销单编号为:' || v_exp_report_number ||
                                         ',审核日期为:' ||
                                         to_char(v_audit_date, 'YYYY-MM-DD') ||
                                         ',公司代码为:' || v_company_code ||
                                         ',付款方式为:' || v_payment_method_code ||
                                         ',收款方银行账户为:' ||
                                         v_payee_account_number ||
                                         ',收款方银行户名为:' ||
                                         v_payee_account_name ||
                                         ',收款方银行代码为:' || v_payee_bank_code ||
                                         ',收款方银行名称为:' || v_payee_bank_name ||
                                         ',收款方联行号为:' || v_sparticipantbankno ||
                                         ',收款方开户行为:' ||
                                         v_payee_location_name ||
                                         ',收款方开户行省份为:' ||
                                         v_payee_bank_province ||
                                         ',收款方开户行城市为:' || v_payee_bank_city ||
                                         ',收款方银行公、私类型为:' || v_account_flag ||
                                         ',收款方银行币种为:' || v_currency_code ||
                                         ',集中标志位:' || v_gather_flag,
                          p_ref_table => 'EXP_REPORT_PMT_SCHEDULES',
                          p_ref_field => 'PAYMENT_SCHEDULE_LINE_ID',
                          p_ref_id    => p_exp_report_pmt_line_id,
                          p_user_id   => p_user_id);
  
    INSERT INTO cux_payment_doc_info i
      (info_id,
       document_category,
       document_id,
       document_line_id,
       interface_id,
       datastatus,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       post_zj_date,
       zj_deal_date,
       zj_refund_date,
       zj_import_date,
       zj_error_msg,
       bank_pay_date,
       billcode,
       hec_refund_flag,
       hec_refund_date,
       pay_transaction_line_id,
       refund_transaction_line_id,
       document_company_id)
    VALUES
      (v_info_id,
       'EXP_REPORT',
       v_exp_report_header_id,
       v_exp_report_pmt_line_id,
       v_interface_id,
       c_datastatus_saved,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       SYSDATE,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       v_billcode,
       'N',
       NULL,
       NULL,
       NULL,
       v_doc_company_id);
  
    FOR itfs IN (SELECT v_interface_id AS id,
                        v_billcode AS billcode,
                        '2' AS datasource,
                        systimestamp AS inputdate,
                        NULL AS batchno,
                        NULL AS settlermentdate,
                        v_audit_date AS transferdate,
                        v_company_code AS orgcode,
                        '1003' AS transfercode,
                        v_payment_method_code AS paytype,
                        substr(s.description, 1, 30) AS abstracts,
                        NULL AS payorgcode,
                        NULL AS payorgname,
                        NULL AS payaccountno,
                        NULL AS payaccountname,
                        NULL AS paybankname,
                        NULL AS payprovince,
                        NULL AS payareanameofcity,
                        NULL AS recorgcode,
                        NULL AS recorgname,
                        v_payee_account_number AS recaccountno,
                        v_payee_account_name AS recaccountname,
                        v_payee_location_name recbankname,
                        v_payee_bank_province AS recprovince,
                        v_payee_bank_city AS recareanameofcity,
                        NULL AS bankcodeofrec,
                        NULL AS bankexccodeofrec,
                        v_sparticipantbankno AS cnapsofrec,
                        NULL AS paymentno,
                        NULL AS agreementno,
                        v_account_flag AS bankpaytype,
                        v_currency_code AS currencycode,
                        (s.due_amount -
                        (SELECT nvl(SUM(w.csh_write_off_amount), 0)
                            FROM csh_write_off w
                           WHERE w.document_source = 'EXPENSE_REPORT'
                             AND w.document_header_id =
                                 s.exp_report_header_id
                             AND w.document_line_id =
                                 s.payment_schedule_line_id)) AS amount,
                        c_datastatus_hec_saved AS datastatus,
                        NULL AS RESULT,
                        0 AS isread,
                        0 AS isreturn,
                        NULL AS bankerrcode,
                        NULL AS bankerrdesc,
                        NULL AS errcode,
                        NULL AS errdescription,
                        NULL AS transferid,
                        NULL AS instructionid,
                        v_payee_bank_code AS free1,
                        --默认为集中支付
                        nvl(v_gather_flag, 1) AS free2
                   FROM exp_report_pmt_schedules s
                  WHERE s.payment_schedule_line_id =
                        v_exp_report_pmt_line_id) LOOP
      insert_exp_pay_interface(p_id                     => itfs.id,
                               p_billcode               => itfs.billcode,
                               p_datasource             => itfs.datasource,
                               p_inputdate              => itfs.inputdate,
                               p_batchno                => itfs.batchno,
                               p_settlermentdate        => itfs.settlermentdate,
                               p_transferdate           => itfs.transferdate,
                               p_orgcode                => itfs.orgcode,
                               p_transfercode           => itfs.transfercode,
                               p_paytype                => itfs.paytype,
                               p_abstracts              => itfs.abstracts,
                               p_payorgcode             => itfs.payorgcode,
                               p_payorgname             => itfs.payorgname,
                               p_payaccountno           => itfs.payaccountno,
                               p_payaccountname         => itfs.payaccountname,
                               p_paybankname            => itfs.paybankname,
                               p_payprovince            => itfs.payprovince,
                               p_payareanameofcity      => itfs.payareanameofcity,
                               p_recorgcode             => itfs.recorgcode,
                               p_recorgname             => itfs.recorgname,
                               p_recaccountno           => itfs.recaccountno,
                               p_recaccountname         => itfs.recaccountname,
                               p_recbankname            => itfs.recbankname,
                               p_recprovince            => itfs.recprovince,
                               p_recareanameofcity      => itfs.recareanameofcity,
                               p_bankcodeofrec          => itfs.bankcodeofrec,
                               p_bankexccodeofrec       => itfs.bankexccodeofrec,
                               p_cnapsofrec             => itfs.cnapsofrec,
                               p_paymentno              => itfs.paymentno,
                               p_agreementno            => itfs.agreementno,
                               p_bankpaytype            => itfs.bankpaytype,
                               p_currencycode           => itfs.currencycode,
                               p_amount                 => itfs.amount,
                               p_datastatus             => itfs.datastatus,
                               p_result                 => itfs.result,
                               p_isread                 => itfs.isread,
                               p_isreturn               => itfs.isreturn,
                               p_bankerrcode            => itfs.bankerrcode,
                               p_bankerrdesc            => itfs.bankerrdesc,
                               p_errcode                => itfs.errcode,
                               p_errdescription         => itfs.errdescription,
                               p_transferid             => itfs.transferid,
                               p_instructionid          => itfs.instructionid,
                               p_free1                  => itfs.free1,
                               p_free2                  => itfs.free2,
                               p_exp_report_pmt_line_id => v_exp_report_pmt_line_id);
    END LOOP;
  
  END post_exp_rep_by_pmt;

  PROCEDURE gr_insert_exp_pay_trans_inter(p_trans_interface_id       NUMBER,
                                          p_source_doc_num           VARCHAR2,
                                          p_company_code             VARCHAR2,
                                          p_pay_type_code            VARCHAR2, --付款方式 
                                          p_partner_category         VARCHAR2, --收款方类型
                                          p_partner_code             VARCHAR2, -- 收款方代码
                                          p_payee_city_code          VARCHAR2, -- 收方银行区域代码
                                          p_payee_bank_location_code VARCHAR2, --收方银行开户行联行号
                                          p_payee_bank_location      VARCHAR2, ----收方银行开户行
                                          p_gather_account           VARCHAR2, --收款账号
                                          p_usedes_code              VARCHAR2, --用途
                                          p_source_doc_des           VARCHAR2, --备注,报销单头上备注
                                          p_isprivate                VARCHAR2, --公私标志
                                          p_card_book_flag           VARCHAR2, --卡折标志
                                          p_settlement_mode          VARCHAR2, --结算方式
                                          p_amount                   NUMBER,
                                          p_user_id                  NUMBER, --
                                          p_cash_flow_code           VARCHAR2, --现金流量代码
                                          p_document_category        VARCHAR2,
                                          p_document_line_id         NUMBER,
                                          p_payment_interface_id     NUMBER,
                                          p_doc_serial_num           VARCHAR2) IS
    v_interface_id    NUMBER;
    v_hec_status      NUMBER;
    v_old_urid        NUMBER;
    v_doc_info        cux_payment_doc_info%ROWTYPE;
    v_trans_interface jx_ats_pay_trans_interface%ROWTYPE;
  
    v_account_name    VARCHAR2(100);
    v_document_number VARCHAR2(100);
    v_description     VARCHAR2(2000);
    v_payee_category  VARCHAR2(100);
    v_payee_id        NUMBER;
  BEGIN
  
    IF (p_document_category = 'EXP_REPORT') THEN
      SELECT s.account_name,
             erh.exp_report_number,
             erh.description,
             s.payee_category,
             s.payee_id
        INTO v_account_name,
             v_document_number,
             v_description,
             v_payee_category,
             v_payee_id
        FROM exp_report_pmt_schedules s, exp_report_headers erh
       WHERE s.exp_report_header_id = erh.exp_report_header_id
         AND s.payment_schedule_line_id = p_document_line_id;
    
    ELSIF (p_document_category = 'PAYMENT_REQUISITION') THEN
    
      SELECT l.account_name,
             h.requisition_number,
             h.description,
             l.partner_category,
             l.partner_id
        INTO v_account_name,
             v_document_number,
             v_description,
             v_payee_category,
             v_payee_id
        FROM csh_payment_requisition_lns l, csh_payment_requisition_hds h
       WHERE h.payment_requisition_header_id =
             l.payment_requisition_header_id
         AND l.payment_requisition_line_id = p_document_line_id;
    
    ELSIF (p_document_category = 'ACP_REQUISITION') THEN
      SELECT l.account_name,
             h.requisition_number,
             h.description,
             l.partner_category,
             l.partner_id
        INTO v_account_name,
             v_document_number,
             v_description,
             v_payee_category,
             v_payee_id
        FROM acp_acp_requisition_hds h, acp_acp_requisition_lns l
       WHERE h.acp_requisition_header_id = l.acp_requisition_header_id
         AND l.acp_requisition_line_id = p_document_line_id;
    END IF;
  
    --判断是否为重新支付
    BEGIN
      --从历史单据信息表中获取已处理的最新id
      SELECT MAX(h.interface_id)
        INTO v_interface_id
        FROM cux_payment_doc_info_his h
       WHERE h.document_line_id = p_document_line_id
         AND h.datastatus = '3' --支付失败
         AND h.document_category = p_document_category
         AND h.interface_id <> p_payment_interface_id;
    
      SELECT j.*
        INTO v_trans_interface
        FROM jx_ats_pay_trans_interface j
       WHERE j.payment_interface_id = v_interface_id;
    
      --之前已作导入失败或支付失败处理
      IF v_trans_interface.hec_status IN (7, 3) AND
         v_trans_interface.pay_state IN (7, 3) THEN
      
        UPDATE jx_ats_pay_trans_interface j
           SET j.hec_status       = 9, --重新支付
               j.last_updated_by  = 1,
               j.last_update_date = SYSDATE
         WHERE j.urid = v_trans_interface.urid;
      
        v_old_urid := v_trans_interface.urid;
      END IF;
    EXCEPTION
      WHEN no_data_found THEN
        v_hec_status := 0; --未导入
    END;
  
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
       post_flag,
       document_payment_line_id,
       payment_interface_id,
       old_urid,
       doc_serial_num)
    VALUES
      (p_trans_interface_id,
       'FPM',
       p_source_doc_num, -- 单据编号
       v_document_number, -- 来源单据编号,取报销单编号
       p_company_code, -- 机构
       '',
       SYSDATE, -- 付款时间
       to_char(SYSDATE, 'yyyy-mm-dd'), -- 计划付款时间 (待开发)
       p_settlement_mode, --结算方式
       p_pay_type_code, --付款方式 
       '', --资金类别
       '', --资金子类别
       '', --计划项目
       '', --付方组织
       '', --付方银行
       '', --付方账户
       /*p_partner_category*/
       0, --收款方类型
       p_partner_code, -- 收款方代码
       p_payee_city_code, -- 收方银行区域字段待确认
       p_payee_bank_location_code, --收方银行
       p_payee_bank_location, --收方银行开户行
       p_gather_account,
       --v_payment_record.account_number, --收方账户
       v_account_name, --收方户名
       'CNY', --货币
       p_amount, --交易金额
       p_amount, --实付金额
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
       NULL,
       v_payee_category,
       v_payee_id,
       NULL,
       NULL,
       NULL,
       NULL,
       nvl(v_hec_status, 0),
       NULL,
       NULL,
       p_cash_flow_code, -- 现金流量代码
       NULL,
       '',
       v_description,
       'N',
       'N',
       p_document_line_id,
       p_payment_interface_id,
       v_old_urid,
       p_doc_serial_num);
  END gr_insert_exp_pay_trans_inter;

  /*************************************************
  -- Author  : Rick
  -- Created : 2018-10-10 22:10:58
  -- Purpose : 资金收付接口主程序
  **************************************************/
  PROCEDURE gr_ws_post_zj(p_interface_id NUMBER,
                          p_user_id      NUMBER,
                          p_csh_type     VARCHAR2) IS
  
    v_request_xml     CLOB;
    v_result          CLOB;
    v_request_id      NUMBER;
    v_doc_line_id     NUMBER;
    v_open_bank       VARCHAR2(10);
    v_open_bank_name  VARCHAR2(200);
    v_interface_id    NUMBER;
    v_head_serial_num VARCHAR2(50);
    v_error_msg       VARCHAR2(500);
    v_area_code       VARCHAR2(50);
    v_area_name       VARCHAR2(200);
    v_company_code    VARCHAR2(50);
    v_document_number VARCHAR2(50);
    v_gather_account  VARCHAR2(50);
    v_paytype         VARCHAR2(10);
    v_payment_record  zj_record;
    v_gather_record   zj_record;
    v_doc_info        cux_payment_doc_info%ROWTYPE;
    v_interface_msg   jx_ats_pay_trans_interface%ROWTYPE;
    --v_gather_interface_msg  csh_repayment_requisition%rowtype;
    v_exp_employee_accounts exp_employee_accounts%ROWTYPE;
    --v_line_info             repayment_ref_refund_amount%rowtype;
    e_locked_error  EXCEPTION;
    e_account_error EXCEPTION;
    v_bank VARCHAR2(10);
    PRAGMA EXCEPTION_INIT(e_locked_error, -54);
  
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
  
    IF p_csh_type = 'pay' THEN
      --------------------------------------付款数据准备------------------------------------
      --支付行信息
      SELECT *
        INTO v_interface_msg
        FROM jx_ats_pay_trans_interface jpi
       WHERE jpi.urid = p_interface_id;
    
      --支付数据明细
      SELECT c.*
        INTO v_doc_info
        FROM cux_payment_doc_info c
       WHERE c.interface_id = v_interface_msg.payment_interface_id;
    
      v_document_number := v_interface_msg.source_notecode;
      --获取支付头流水
      /*      v_head_serial_num := payment_head_serial_num(p_doc_type                 => v_doc_info.document_category,
      p_document_payment_line_id => v_interface_msg.document_payment_line_id,
      p_payment_interface_id     => v_interface_msg.payment_interface_id,
      p_urid                     => v_interface_msg.urid);*/
    
      v_head_serial_num := v_interface_msg.doc_serial_num;
    
      --业务类型 
      IF v_doc_info.document_category = 'EXP_REPORT' THEN
        SELECT t.expense_report_type_code
          INTO v_paytype
          FROM exp_expense_report_types_vl t
         WHERE t.expense_report_type_id =
               (SELECT h.exp_report_type_id
                  FROM exp_report_headers h
                 WHERE h.exp_report_header_id = v_doc_info.document_id);
      
      ELSIF v_doc_info.document_category = 'PAYMENT_REQUISITION' THEN
        SELECT t.type_code
          INTO v_paytype
          FROM csh_pay_req_types_vl t
         WHERE t.type_id = (SELECT h.payment_req_type_id
                              FROM csh_payment_requisition_hds h
                             WHERE h.payment_requisition_header_id =
                                   v_doc_info.document_id);
      
      ELSIF v_doc_info.document_category = 'ACP_REQUISITION' THEN
        --付款单传关联报销单单据类型
        SELECT t.expense_report_type_code
          INTO v_paytype
          FROM exp_expense_report_types_vl t
         WHERE t.expense_report_type_id =
               (SELECT h.exp_report_type_id
                  FROM exp_report_headers h
                 WHERE h.exp_report_header_id =
                       (SELECT l.ref_document_id
                          FROM acp_acp_requisition_lns l
                         WHERE l.acp_requisition_header_id =
                               v_doc_info.document_id
                           AND rownum = 1));
      
        /*SELECT t.acp_req_type_code
         INTO v_paytype
         FROM acp_sys_acp_req_types t
        WHERE t.acp_req_type_id =
              (SELECT h.acp_req_type_id
                 FROM acp_acp_requisition_hds h
                WHERE h.acp_requisition_header_id = v_doc_info.document_id);*/
      END IF;
    
      --获取银行大类和描述
      SELECT v.bank_code, v.bank_name, v.area_code, v.area_name
        INTO v_open_bank, v_open_bank_name, v_area_code, v_area_name
        FROM br_hfm_bank_v v
       WHERE v.bank_branch_num = v_interface_msg.rec_bank;
    
      --银行大类英文简称
      SELECT t.code
        INTO v_bank
        FROM zj_br_banks t
       WHERE t.directbankcode = v_open_bank
         AND rownum = 1;
    
      --整理数据
      SELECT v_interface_msg.origin_note, --现金事务编号
             v_interface_msg.csh_transaction_header_id, --现金事务头id
             v_head_serial_num, --头流水
             v_interface_msg.csh_transaction_line_id, --现金事务行id
             v_interface_msg.sourcebusinessno, --原单据编号
             v_interface_msg.bank_money,
             v_interface_msg.pay_date,
             v_interface_msg.apply_entity_code,
             v_doc_info.document_category, --来源类型
             v_interface_msg.rec_account,
             v_interface_msg.rec_account_name,
             v_area_code,
             v_bank,
             v_open_bank_name,
             v_interface_msg.rec_bank_locations,
             v_interface_msg.rec_bank,
             v_interface_msg.rec_currency,
             v_interface_msg.rec_money,
             v_interface_msg.isprivate,
             v_interface_msg.memo,
             p_user_id,
             v_interface_msg.usedes,
             v_interface_msg.summary,
             v_interface_msg.partner_category,
             v_interface_msg.settlement_mode, --计算方式
             v_interface_msg.purpose, --用途,
             /*v_interface_msg.audit_person, --稽核人
             v_interface_msg.audit_time, --稽核时间，*/
             NULL, --付款时，企业付款账号不传
             v_interface_msg.source_notecode,
             v_paytype
        INTO v_payment_record
        FROM dual;
      --处理报文
      v_request_xml := get_request_xml(c_pay_xml, v_payment_record);
      --封装报文
      v_request_xml := zj_xml_packing(v_request_xml);
    
      csh_ebank_log_pkg.log(p_level           => csh_ebank_log_pkg.c_log_level_info,
                            p_log_desc        => substr('支付报文处理完毕，报文内容为：' ||
                                                        v_request_xml ||
                                                        '，正在发送，INFO_ID为:' ||
                                                        v_interface_id,
                                                        1,
                                                        4000),
                            p_ref_table       => '',
                            p_ref_field       => '',
                            p_ref_id          => '',
                            p_user_id         => p_user_id,
                            p_document_number => v_interface_msg.source_notecode);
    
      --发送并获取返回报文
      v_result := cux_ws_request_pkg.call_web_service_zj(p_ws_url          => g_ws_url,
                                                         p_request_body    => v_request_xml,
                                                         p_document_number => v_document_number,
                                                         p_inner_root_name => 'xml',
                                                         p_request_id      => v_request_id);
    
    END IF;
  
    resolve_zj_response_xml(p_xml             => v_result,
                            p_interface_id    => v_interface_id,
                            p_urid            => v_interface_msg.urid,
                            p_user_id         => p_user_id,
                            p_document_number => v_document_number);
  
    COMMIT;
  
  EXCEPTION
    WHEN e_account_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '员工未维护主账号' ||
                                                                                  SQLERRM || '-' ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CUX_PAYMENT_PKG',
                                                     p_procedure_function_name => 'WS_POST_ZJ');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      csh_ebank_log_pkg.log(p_level           => csh_ebank_log_pkg.c_log_level_error,
                            p_log_desc        => '报文发送或接收失败' || SQLERRM ||
                                                 chr(10) ||
                                                 dbms_utility.format_error_backtrace,
                            p_ref_table       => '',
                            p_ref_field       => '',
                            p_ref_id          => NULL,
                            p_user_id         => p_user_id,
                            p_document_number => v_document_number);
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '报文发送或接收失败' ||
                                                                                  SQLERRM || '-' ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'CUX_PAYMENT_PKG',
                                                     p_procedure_function_name => 'WS_POST_ZJ');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END gr_ws_post_zj;

  /*************************************************
  -- Author  : Rick
  -- Created : 2018-10-10 19:41:59
  -- Ver     : 1.1
  -- Purpose : 推送资金
  **************************************************/
  PROCEDURE gr_post_data_zj(p_document_id       NUMBER,
                            p_document_category VARCHAR2,
                            p_user_id           NUMBER) IS
    v_error_msg VARCHAR2(100);
  BEGIN
    FOR c_inter IN (SELECT jap.*
                      FROM cux_payment_doc_info       inf,
                           cux_payment_interface      cpi,
                           jx_ats_pay_trans_interface jap
                     WHERE inf.document_id = p_document_id
                       AND inf.document_category = p_document_category
                       AND inf.interface_id = cpi.id
                       AND cpi.id = jap.payment_interface_id
                       AND cpi.datastatus = c_datastatus_saved) LOOP
    
      --发送资金支付 
      BEGIN
        gr_ws_post_zj(p_interface_id => c_inter.urid,
                      p_user_id      => 1,
                      p_csh_type     => 'pay');
      EXCEPTION
        WHEN OTHERS THEN
          v_error_msg := SQLERRM || dbms_utility.format_error_backtrace;
          --支付异常更新
          UPDATE jx_ats_pay_trans_interface jpi
             SET jpi.error_message = v_error_msg,
                 jpi.hec_status    = '7', --导入失败
                 jpi.pay_state     = '7'
           WHERE jpi.urid = c_inter.urid;
        
          --收付费应付接口表
          UPDATE cux_payment_interface c
             SET c.datastatus     = '3',
                 c.isreturn       = 1,
                 c.batchno        = '',
                 c.errdescription = '资金接收或支付失败'
           WHERE c.id = c_inter.payment_interface_id;
        
          --资金接口_单据资金信息表
          UPDATE cux_payment_doc_info di
             SET di.zj_import_date = SYSDATE,
                 di.zj_deal_date   = SYSDATE,
                 di.datastatus     = '3',
                 di.zj_error_msg   = '资金接收或支付失败'
           WHERE di.interface_id = c_inter.payment_interface_id;
        
      END;
    
      COMMIT;
    END LOOP;
  END gr_post_data_zj;

  /*************************************************
  -- Author  : Rick
  -- Created : 2018-10-10 19:41:59
  -- Ver     : 1.1
  -- Purpose : 宝融资金数据准备表
  **************************************************/
  PROCEDURE gr_insert_br_data(p_interface_id NUMBER) IS
    v_cux_payment_interface cux_payment_interface%ROWTYPE;
    v_cux_payment_doc_info  cux_payment_doc_info%ROWTYPE;
  
    v_payee_category VARCHAR2(30);
    v_payee_id       NUMBER;
  
    v_partner_code       VARCHAR2(30);
    v_partner_name       VARCHAR2(100);
    v_area_code          VARCHAR2(30);
    v_isprivate          VARCHAR2(10);
    v_usedes_code        VARCHAR2(100);
    v_description        VARCHAR2(2000);
    v_cash_flow_code     VARCHAR2(100);
    v_bank_location_code VARCHAR2(30);
    v_bank_location      VARCHAR2(100);
  BEGIN
    SELECT *
      INTO v_cux_payment_interface
      FROM cux_payment_interface cpi
     WHERE cpi.id = p_interface_id;
  
    SELECT *
      INTO v_cux_payment_doc_info
      FROM cux_payment_doc_info cpi
     WHERE cpi.interface_id = p_interface_id;
  
    IF (v_cux_payment_doc_info.document_category = 'EXP_REPORT') THEN
    
      SELECT s.payee_category,
             s.payee_id,
             s.usedes,
             s.description,
             s.cash_flow_code
        INTO v_payee_category,
             v_payee_id,
             v_usedes_code,
             v_description,
             v_cash_flow_code
        FROM exp_report_pmt_schedules s, exp_report_headers erh
       WHERE s.exp_report_header_id = erh.exp_report_header_id
         AND s.payment_schedule_line_id =
             v_cux_payment_doc_info.document_line_id;
    
    ELSIF (v_cux_payment_doc_info.document_category = 'PAYMENT_REQUISITION') THEN
    
      SELECT l.partner_category,
             l.partner_id,
             l.description,
             l.cash_flow_code
        INTO v_payee_category, v_payee_id, v_description, v_cash_flow_code
        FROM csh_payment_requisition_lns l, csh_payment_requisition_hds h
       WHERE h.payment_requisition_header_id =
             l.payment_requisition_header_id
         AND l.payment_requisition_line_id =
             v_cux_payment_doc_info.document_line_id;
    
    ELSIF (v_cux_payment_doc_info.document_category = 'ACP_REQUISITION') THEN
      SELECT l.partner_category,
             l.partner_id,
             l.line_description,
             l.cash_flow_item_id
        INTO v_payee_category, v_payee_id, v_description, v_cash_flow_code
        FROM acp_acp_requisition_hds h, acp_acp_requisition_lns l
       WHERE h.acp_requisition_header_id = l.acp_requisition_header_id
         AND l.acp_requisition_line_id =
             v_cux_payment_doc_info.document_line_id;
    END IF;
  
    BEGIN
      IF v_payee_category = 'EMPLOYEE' THEN
        SELECT ee.employee_code, ee.name, '1'
          INTO v_partner_code, v_partner_name, v_isprivate
          FROM exp_employees ee
         WHERE ee.employee_id = v_payee_id;
      
        SELECT a.bank_location_code, a.bank_location
          INTO v_bank_location_code, v_bank_location
          FROM exp_employee_accounts a
         WHERE a.employee_id = v_payee_id
           AND a.account_number = v_cux_payment_interface.recaccountno;
      
      ELSIF v_payee_category = 'VENDER' THEN
        SELECT psv.vender_code, psv.description, '2'
          INTO v_partner_code, v_partner_name, v_isprivate
          FROM pur_system_venders_vl psv
         WHERE psv.vender_id = v_payee_id;
      
        SELECT a.bank_location_code, a.bank_location
          INTO v_bank_location_code, v_bank_location
          FROM pur_vender_accounts a
         WHERE a.vender_id = v_payee_id
           AND a.account_number = v_cux_payment_interface.recaccountno;
      
      ELSE
        SELECT osc.customer_code, osc.description, '2'
          INTO v_partner_code, v_partner_name, v_isprivate
          FROM ord_system_customers_vl osc
         WHERE osc.customer_id = v_payee_id;
      
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '收款方银行账户主数据存在错误,请联系管理员维护!',
                                                       p_created_by              => 1,
                                                       p_package_name            => 'cux_payment_pkg',
                                                       p_procedure_function_name => 'insert_exp_pay_interface');
      
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
    END;
  
    BEGIN
      --地区代码
      SELECT b.area_code
        INTO v_area_code
        FROM br_hfm_bank_v b
       WHERE b.bank_branch_num = v_bank_location_code;
      null;
    EXCEPTION
      WHEN no_data_found THEN
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '根据联行号' ||
                                                                                    v_bank_location_code || '
                                                                                      未找到对应地区代码',
                                                       p_created_by              => 1,
                                                       p_package_name            => 'cux_payment_gr_pkg',
                                                       p_procedure_function_name => 'gr_insert_br_data');
      
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
    END;
  
    gr_insert_exp_pay_trans_inter(p_trans_interface_id       => jx_ats_pay_trans_interface_s.nextval,
                                  p_source_doc_num           => v_cux_payment_interface.billcode,
                                  p_company_code             => v_cux_payment_interface.orgcode,
                                  p_pay_type_code            => v_cux_payment_interface.paytype, --付款方式 
                                  p_partner_category         => v_partner_name, --收款方类型
                                  p_partner_code             => v_partner_code, --收款方类型
                                  p_payee_city_code          => v_area_code, -- 收方银行区域代码
                                  p_payee_bank_location_code => v_bank_location_code, --收方银行开户行联行号
                                  p_payee_bank_location      => v_bank_location, --收方银行开户行
                                  p_gather_account           => v_cux_payment_interface.recaccountno, --收款账号
                                  p_usedes_code              => v_usedes_code, --用途
                                  p_source_doc_des           => v_description, --备注,报销单头上备注
                                  p_isprivate                => v_isprivate, --公私标志
                                  p_card_book_flag           => NULL, --卡折标志
                                  p_settlement_mode          => v_cux_payment_interface.paytype, --结算方式
                                  p_amount                   => v_cux_payment_interface.amount,
                                  p_user_id                  => v_cux_payment_doc_info.created_by, --
                                  p_cash_flow_code           => v_cash_flow_code, --现金流量代码
                                  p_document_category        => v_cux_payment_doc_info.document_category,
                                  p_document_line_id         => v_cux_payment_doc_info.document_line_id,
                                  p_payment_interface_id     => v_cux_payment_interface.id,
                                  p_doc_serial_num           => v_cux_payment_interface.doc_serial_num);
  
  END gr_insert_br_data;

  /*************************************************
  -- Author  : Rick
  -- Created : 2018-10-10 19:41:59
  -- Ver     : 1.1
  -- Purpose : 自制事物,插入接口表
  -- 首先插入资金接口表 cux_payment_doc_info 和  cux_payment_interface
  -- 然后插入数据准备表 jx_ats_pay_trans_interface
  -- 三张表一一对应  cux_payment_doc_info.interface_id = cux_payment_interface.id = jx_ats_pay_trans_interface.payment_interface_id
  **************************************************/
  PROCEDURE gr_insert_zj_interface(p_exp_report_pmt_line_id NUMBER,
                                   p_user_id                NUMBER,
                                   p_interface_id           NUMBER DEFAULT NULL) IS
  
    v_count NUMBER;
  
    v_exp_report_header_id   NUMBER;
    v_exp_report_pmt_line_id NUMBER;
    v_exp_report_number      VARCHAR2(200);
    v_audit_date             DATE;
    v_currency_code          VARCHAR2(30);
    v_company_code           VARCHAR2(200);
    v_payment_method_code    VARCHAR2(10);
    v_payee_account_number   VARCHAR2(200);
    v_payee_account_name     VARCHAR2(200);
    v_payee_bank_code        VARCHAR2(200);
    v_payee_bank_name        VARCHAR2(200);
    v_sparticipantbankno     VARCHAR2(200);
    v_payee_location_name    VARCHAR2(200);
    v_payee_bank_province    VARCHAR2(200);
    v_payee_bank_city        VARCHAR2(200);
    v_account_flag           VARCHAR2(30);
    v_info_id                NUMBER;
    v_interface_id           NUMBER;
    v_billcode               VARCHAR2(50);
    v_gather_flag            VARCHAR2(10);
    v_company_id             NUMBER;
    v_doc_company_id         NUMBER;
  
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
  
    --备份失败的资金接口数据
    IF p_interface_id IS NOT NULL THEN
      backup_failed_zj_info(p_info_id => p_interface_id);
    END IF;
  
    SELECT cux_payment_doc_info_s.nextval INTO v_info_id FROM dual;
    SELECT doc_info_s.nextval INTO v_interface_id FROM dual;
  
    SELECT s.company_id
      INTO v_company_id
      FROM exp_report_pmt_schedules s
     WHERE s.payment_schedule_line_id = p_exp_report_pmt_line_id;
  
    v_billcode := fnd_code_rule_pkg.get_rule_next_auto_num(p_document_category => '51',
                                                           p_document_type     => '',
                                                           p_company_id        => v_company_id,
                                                           p_operation_unit_id => '',
                                                           p_operation_date    => SYSDATE,
                                                           p_created_by        => p_user_id);
  
    SELECT COUNT(1)
      INTO v_count
      FROM cux_payment_doc_info inf
     WHERE inf.document_category = 'EXP_REPORT'
       AND inf.document_line_id = p_exp_report_pmt_line_id;
  
    IF (v_count > 0) THEN
      RETURN;
    END IF;
  
    SELECT s.exp_report_header_id,
           s.payment_schedule_line_id,
           h.exp_report_number,
           h.audit_date,
           (SELECT fc.company_code
              FROM fnd_companies fc
             WHERE fc.company_id = h.company_id) AS company_code,
           (CASE (SELECT m.payment_method_code
                FROM csh_payment_methods m
               WHERE m.payment_method_id = s.payment_type_id)
             WHEN '10' THEN
              '1'
             WHEN '20' THEN
              '9'
             WHEN '30' THEN
              '9'
           END) AS payment_method_code,
           (CASE s.payee_category
             WHEN 'VENDER' THEN
              (SELECT v.account_number
                 FROM pur_vender_accounts v
                WHERE v.vender_id = s.payee_id
                  AND v.account_number = s.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.account_number
                 FROM exp_employee_accounts a
                WHERE a.employee_id = s.payee_id
                  AND a.account_number = s.account_number)
           END) AS account_number,
           (CASE s.payee_category
             WHEN 'VENDER' THEN
              (SELECT v.account_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = s.payee_id
                  AND v.account_number = s.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.account_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = s.payee_id
                  AND a.account_number = s.account_number)
           END) AS account_name,
           (CASE s.payee_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_code
                 FROM pur_vender_accounts v
                WHERE v.vender_id = s.payee_id
                  AND v.account_number = s.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_code
                 FROM exp_employee_accounts a
                WHERE a.employee_id = s.payee_id
                  AND a.account_number = s.account_number)
           END) AS bank_code,
           (CASE s.payee_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = s.payee_id
                  AND v.account_number = s.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = s.payee_id
                  AND a.account_number = s.account_number)
           END) AS bank_name,
           (CASE s.payee_category
             WHEN 'VENDER' THEN
              (SELECT v.sparticipantbankno
                 FROM pur_vender_accounts v
                WHERE v.vender_id = s.payee_id
                  AND v.account_number = s.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.sparticipantbankno
                 FROM exp_employee_accounts a
                WHERE a.employee_id = s.payee_id
                  AND a.account_number = s.account_number)
           END) AS sparticipantbankno,
           (CASE s.payee_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_location
                 FROM pur_vender_accounts v
                WHERE v.vender_id = s.payee_id
                  AND v.account_number = s.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_location
                 FROM exp_employee_accounts a
                WHERE a.employee_id = s.payee_id
                  AND a.account_number = s.account_number)
           END) AS bank_location_name,
           (CASE s.payee_category
             WHEN 'VENDER' THEN
              (SELECT v.province_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = s.payee_id
                  AND v.account_number = s.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.province_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = s.payee_id
                  AND a.account_number = s.account_number)
           END) AS province_name,
           (CASE s.payee_category
             WHEN 'VENDER' THEN
              (SELECT v.city_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = s.payee_id
                  AND v.account_number = s.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.city_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = s.payee_id
                  AND a.account_number = s.account_number)
           END) AS city_name,
           CASE (CASE s.payee_category
              WHEN 'VENDER' THEN
               (SELECT v.account_flag
                  FROM pur_vender_accounts v
                 WHERE v.vender_id = s.payee_id
                   AND v.account_number = s.account_number)
              WHEN 'EMPLOYEE' THEN
               (SELECT a.account_flag
                  FROM exp_employee_accounts a
                 WHERE a.employee_id = s.payee_id
                   AND a.account_number = s.account_number)
            END)
             WHEN '10' THEN
              '1'
             WHEN '20' THEN
              '2'
           END,
           h.currency_code,
           s.gather_flag,
           h.company_id
      INTO v_exp_report_header_id,
           v_exp_report_pmt_line_id,
           v_exp_report_number,
           v_audit_date,
           v_company_code,
           v_payment_method_code,
           v_payee_account_number,
           v_payee_account_name,
           v_payee_bank_code,
           v_payee_bank_name,
           v_sparticipantbankno,
           v_payee_location_name,
           v_payee_bank_province,
           v_payee_bank_city,
           v_account_flag,
           v_currency_code,
           v_gather_flag,
           v_doc_company_id
      FROM exp_report_pmt_schedules s, exp_report_headers h
     WHERE s.payment_schedule_line_id = p_exp_report_pmt_line_id
       AND s.exp_report_header_id = h.exp_report_header_id;
  
    --- ################单据信息表################################
    FOR c_doc_info IN (SELECT s.exp_report_header_id,
                              s.payment_schedule_line_id,
                              h.company_id
                         FROM exp_report_pmt_schedules s,
                              exp_report_headers       h
                        WHERE s.payment_schedule_line_id =
                              p_exp_report_pmt_line_id
                          AND s.exp_report_header_id =
                              h.exp_report_header_id) LOOP
      INSERT INTO cux_payment_doc_info i
        (info_id,
         document_category,
         document_id,
         document_line_id,
         interface_id,
         datastatus,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date,
         post_zj_date,
         zj_deal_date,
         zj_refund_date,
         zj_import_date,
         zj_error_msg,
         bank_pay_date,
         billcode,
         hec_refund_flag,
         hec_refund_date,
         pay_transaction_line_id,
         refund_transaction_line_id,
         document_company_id)
      VALUES
        (v_info_id,
         'EXP_REPORT',
         c_doc_info.exp_report_header_id,
         c_doc_info.payment_schedule_line_id,
         v_interface_id,
         c_datastatus_saved,
         p_user_id,
         SYSDATE,
         p_user_id,
         SYSDATE,
         SYSDATE,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         v_billcode,
         'N',
         NULL,
         NULL,
         NULL,
         c_doc_info.company_id);
    END LOOP;
  
    --- ################支付接口表################################
    FOR itfs IN (SELECT v_interface_id AS id,
                        v_billcode AS billcode,
                        '2' AS datasource,
                        systimestamp AS inputdate,
                        NULL AS batchno,
                        NULL AS settlermentdate,
                        v_audit_date AS transferdate,
                        v_company_code AS orgcode,
                        '1003' AS transfercode,
                        v_payment_method_code AS paytype,
                        substr(s.description, 1, 30) AS abstracts,
                        NULL AS payorgcode,
                        NULL AS payorgname,
                        NULL AS payaccountno,
                        NULL AS payaccountname,
                        NULL AS paybankname,
                        NULL AS payprovince,
                        NULL AS payareanameofcity,
                        NULL AS recorgcode,
                        NULL AS recorgname,
                        v_payee_account_number AS recaccountno,
                        v_payee_account_name AS recaccountname,
                        v_payee_location_name recbankname,
                        v_payee_bank_province AS recprovince,
                        v_payee_bank_city AS recareanameofcity,
                        NULL AS bankcodeofrec,
                        NULL AS bankexccodeofrec,
                        v_sparticipantbankno AS cnapsofrec,
                        NULL AS paymentno,
                        NULL AS agreementno,
                        v_account_flag AS bankpaytype,
                        v_currency_code AS currencycode,
                        (s.due_amount -
                        (SELECT nvl(SUM(w.csh_write_off_amount), 0)
                            FROM csh_write_off w
                           WHERE w.document_source = 'EXPENSE_REPORT'
                             AND w.document_header_id =
                                 s.exp_report_header_id
                             AND w.document_line_id =
                                 s.payment_schedule_line_id)) AS amount,
                        c_datastatus_hec_saved AS datastatus,
                        NULL AS RESULT,
                        0 AS isread,
                        0 AS isreturn,
                        NULL AS bankerrcode,
                        NULL AS bankerrdesc,
                        NULL AS errcode,
                        NULL AS errdescription,
                        NULL AS transferid,
                        NULL AS instructionid,
                        v_payee_bank_code AS free1,
                        --默认为集中支付
                        nvl(v_gather_flag, 1) AS free2,
                        s.payee_category
                   FROM exp_report_pmt_schedules s
                  WHERE s.payment_schedule_line_id =
                        p_exp_report_pmt_line_id) LOOP
    
      INSERT INTO cux_payment_interface
        (id,
         billcode,
         datasource,
         inputdate,
         batchno,
         settlermentdate,
         transferdate,
         orgcode,
         transfercode,
         paytype,
         abstracts,
         payorgcode,
         payorgname,
         payaccountno,
         payaccountname,
         paybankname,
         payprovince,
         payareanameofcity,
         recorgcode,
         recorgname,
         recaccountno,
         recaccountname,
         recbankname,
         recprovince,
         recareanameofcity,
         bankcodeofrec,
         bankexccodeofrec,
         cnapsofrec,
         paymentno,
         agreementno,
         bankpaytype,
         currencycode,
         amount,
         datastatus,
         RESULT,
         isread,
         isreturn,
         bankerrcode,
         bankerrdesc,
         errcode,
         errdescription,
         transferid,
         instructionid,
         free1,
         free2,
         payee_category,
         doc_serial_num)
      VALUES
        (itfs.id,
         itfs.billcode,
         itfs.datasource,
         itfs.inputdate,
         itfs.batchno,
         itfs.settlermentdate,
         itfs.transferdate,
         itfs.orgcode,
         itfs.transfercode,
         itfs.paytype,
         itfs.abstracts,
         itfs.payorgcode,
         itfs.payorgname,
         itfs.payaccountno,
         itfs.payaccountname,
         itfs.paybankname,
         itfs.payprovince,
         itfs.payareanameofcity,
         itfs.recorgcode,
         itfs.recorgname,
         itfs.recaccountno,
         itfs.recaccountname,
         itfs.recbankname,
         itfs.recprovince,
         itfs.recareanameofcity,
         itfs.bankcodeofrec,
         itfs.bankexccodeofrec,
         itfs.cnapsofrec,
         itfs.paymentno,
         itfs.agreementno,
         itfs.bankpaytype,
         itfs.currencycode,
         itfs.amount,
         c_datastatus_saved,
         itfs.result,
         itfs.isread,
         itfs.isreturn,
         itfs.bankerrcode,
         itfs.bankerrdesc,
         itfs.errcode,
         itfs.errdescription,
         itfs.transferid,
         itfs.instructionid,
         itfs.free1,
         itfs.free2,
         itfs.payee_category,
         'GP' || lpad(itfs.id, 15, '0')) --支付流水
      ;
    
      --插入数据准备表
      gr_insert_br_data(p_interface_id => itfs.id);
    
    END LOOP;
  
    COMMIT;
  END gr_insert_zj_interface;

  /*************************************************
  -- Author  : Rick
  -- Created : 2018-10-10 19:41:59
  -- Ver     : 1.1
  -- Purpose : 报销单支付
  **************************************************/
  PROCEDURE gr_post_exp_rep(p_exp_report_header_id NUMBER,
                            p_user_id              NUMBER) IS
    CURSOR c1 IS
      SELECT *
        FROM cp_lock_assist cl
       WHERE cl.doc_type = 'EXP_REPORT_PAYMENT'
         AND cl.doc_id = p_exp_report_header_id
         FOR UPDATE NOWAIT;
    e_locked_error EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_locked_error, -54);
  BEGIN
    -- LOCK TABLE
    cp_lock_assist_pkg.insert_lock_info(p_exp_report_header_id,
                                        'EXP_REPORT_PAYMENT');
    OPEN c1;
  
    --插入接口表及宝融资金数据准备表
    FOR exp_pmt_lines IN (SELECT s.payment_schedule_line_id
                            FROM exp_report_pmt_schedules s
                           WHERE s.exp_report_header_id =
                                 p_exp_report_header_id
                             AND s.frozen_flag = 'N'
                             AND (SELECT nvl(SUM(w.csh_write_off_amount), 0)
                                    FROM csh_write_off w
                                   WHERE w.document_source = 'EXPENSE_REPORT'
                                     AND w.document_header_id =
                                         s.exp_report_header_id
                                     AND w.document_line_id =
                                         s.payment_schedule_line_id) !=
                                 s.due_amount) LOOP
      gr_insert_zj_interface(p_exp_report_pmt_line_id => exp_pmt_lines.payment_schedule_line_id,
                             p_user_id                => p_user_id);
    
    END LOOP;
  
    BEGIN
      --发送资金
      gr_post_data_zj(p_document_id       => p_exp_report_header_id,
                      p_document_category => 'EXP_REPORT',
                      p_user_id           => 1);
    END;
    -- CLOSE CURSOR
    CLOSE c1;
  EXCEPTION
    WHEN e_locked_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '单据正在处理，请稍等...',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_gr_pkg',
                                                     p_procedure_function_name => 'gr_post_exp_rep');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      IF c1%ISOPEN THEN
        CLOSE c1;
      END IF;
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => SQLERRM ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_gr_pkg',
                                                     p_procedure_function_name => 'gr_post_exp_rep');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END gr_post_exp_rep;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/26 14:51:51
  -- Ver     : 1.1
  -- Purpose : 将报销单待支付信息插入到费控资金接口表
  **************************************************/
  PROCEDURE post_exp_rep(p_exp_report_header_id NUMBER, p_user_id NUMBER) IS
    v_info_id NUMBER;
  BEGIN
  
    FOR exp_pmt_lines IN (SELECT s.payment_schedule_line_id
                            FROM exp_report_pmt_schedules s
                           WHERE s.exp_report_header_id =
                                 p_exp_report_header_id
                             AND s.frozen_flag = 'N'
                             AND (SELECT nvl(SUM(w.csh_write_off_amount), 0)
                                    FROM csh_write_off w
                                   WHERE w.document_source = 'EXPENSE_REPORT'
                                     AND w.document_header_id =
                                         s.exp_report_header_id
                                     AND w.document_line_id =
                                         s.payment_schedule_line_id) !=
                                 s.due_amount
                             FOR UPDATE NOWAIT) LOOP
      csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                            p_log_desc  => '循环当前报销单未被冻结的计划付款行，当前行ID为:' ||
                                           exp_pmt_lines.payment_schedule_line_id,
                            p_ref_table => 'EXP_REPORT_PMT_SCHEDULES',
                            p_ref_field => 'PAYMENT_SCHEDULE_LINE_ID',
                            p_ref_id    => exp_pmt_lines.payment_schedule_line_id,
                            p_user_id   => p_user_id);
      post_exp_rep_by_pmt(p_exp_report_pmt_line_id => exp_pmt_lines.payment_schedule_line_id,
                          p_info_id                => v_info_id,
                          p_user_id                => p_user_id);
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => SQLERRM ||
                                                                                  chr(10) ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => 1,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'post_exp_rep');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END post_exp_rep;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/12 11:53:47
  -- Ver     : 1.1
  -- Purpose : 插入报销单计付行单据信息
  -- In Para : 
        p_event_record_id 事件记录ID
        p_event_log_id    事件日志ID
        p_event_param     事件参数,报销单头ID
        p_user_id         用户ID
  **************************************************/
  FUNCTION post_exp_rep_to_zj(p_event_record_id NUMBER,
                              p_event_log_id    NUMBER,
                              p_event_param     NUMBER,
                              p_user_id         NUMBER) RETURN NUMBER IS
    v_payment_flag        VARCHAR2(10);
    v_payment_method_code VARCHAR2(30);
  BEGIN
    csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                          p_log_desc  => '报销单插入计划付款行付款信息',
                          p_ref_table => 'EXP_REPORT_HEADERS',
                          p_ref_field => 'EXP_REPORT_HEADER_ID',
                          p_ref_id    => p_event_param,
                          p_user_id   => p_user_id);
  
    --获取支付类型             
    /*select t.payment_flag
     into v_payment_flag
     from exp_expense_report_types t, exp_report_headers h
    where t.expense_report_type_id = h.exp_report_type_id
      and h.exp_report_header_id = p_event_param;*/
  
    SELECT c.payment_method_code
      INTO v_payment_method_code
      FROM exp_report_headers e, csh_payment_methods c
     WHERE e.payment_method_id = c.payment_method_id
       AND e.exp_report_header_id = p_event_param;
  
    IF v_payment_method_code = '30' THEN
      csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                            p_log_desc  => '当前报销单为无需支付，无需传递资金进行支付',
                            p_ref_table => 'EXP_REPORT_HEADERS',
                            p_ref_field => 'EXP_REPORT_HEADER_ID',
                            p_ref_id    => p_event_param,
                            p_user_id   => p_user_id);
    ELSE
      /*post_exp_rep(p_exp_report_header_id => p_event_param,
      p_user_id              => p_user_id);*/
    
      gr_post_exp_rep(p_exp_report_header_id => p_event_param,
                      p_user_id              => p_user_id);
    
    END IF;
  
    RETURN 1;
  END post_exp_rep_to_zj;

  PROCEDURE insert_csh_pay_trans_interface(p_trans_interface_id       NUMBER,
                                           p_source_doc_num           VARCHAR2,
                                           p_company_code             VARCHAR2,
                                           p_pay_type_code            VARCHAR2, --付款方式 
                                           p_partner_category         VARCHAR2, --收款方类型
                                           p_partner_code             VARCHAR2, -- 收款方代码
                                           p_payee_city_code          VARCHAR2, -- 收方银行区域代码
                                           p_payee_bank_location_code VARCHAR2, --收方银行开户行联行号
                                           p_payee_bank_location      VARCHAR2, ----收方银行开户行
                                           p_gather_account           VARCHAR2, --收款账号
                                           p_usedes_code              VARCHAR2, --用途
                                           p_source_doc_des           VARCHAR2, --备注,报销单头上备注
                                           p_isprivate                VARCHAR2, --公私标志
                                           p_card_book_flag           VARCHAR2, --卡折标志
                                           p_settlement_mode          VARCHAR2, --结算方式
                                           p_amount                   NUMBER,
                                           p_user_id                  NUMBER, --
                                           p_cash_flow_code           VARCHAR2, --现金流量代码
                                           p_csh_payment_req_line_id  NUMBER,
                                           p_payment_interface_id     NUMBER) IS
    v_trans_interface_id NUMBER;
    v_interface_id       NUMBER;
    v_hec_status         NUMBER;
    v_old_urid           NUMBER;
    v_trans_interface    jx_ats_pay_trans_interface%ROWTYPE;
    v_requisition_lns    csh_payment_requisition_lns%ROWTYPE;
    v_requisition_hds    csh_payment_requisition_hds%ROWTYPE;
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
  
    SELECT l.*
      INTO v_requisition_lns
      FROM csh_payment_requisition_lns l
     WHERE l.payment_requisition_line_id = p_csh_payment_req_line_id;
  
    SELECT h.*
      INTO v_requisition_hds
      FROM csh_payment_requisition_hds h
     WHERE h.payment_requisition_header_id =
           v_requisition_lns.payment_requisition_header_id;
  
    --判断是否重新支付
    BEGIN
      --从历史单据信息表中获取已处理的最新id
      SELECT MAX(h.interface_id)
        INTO v_interface_id
        FROM cux_payment_doc_info_his h
       WHERE h.document_line_id = p_csh_payment_req_line_id
         AND h.datastatus = '3' --支付失败
         AND h.document_category = 'PAYMENT_REQUISITION'
         AND h.interface_id <> p_payment_interface_id;
    
      SELECT j.*
        INTO v_trans_interface
        FROM jx_ats_pay_trans_interface j
       WHERE j.payment_interface_id = v_interface_id;
    
      --之前已作导入失败或支付失败处理
      IF v_trans_interface.hec_status IN (7, 3) AND
         v_trans_interface.pay_state IN (7, 3) THEN
      
        UPDATE jx_ats_pay_trans_interface j
           SET j.hec_status       = 9, --重新支付
               j.last_updated_by  = 1,
               j.last_update_date = SYSDATE
         WHERE j.urid = v_trans_interface.urid;
      
        v_old_urid := v_trans_interface.urid;
      END IF;
    EXCEPTION
      WHEN no_data_found THEN
        v_hec_status := 0; --未导入
    END;
  
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
       post_flag,
       document_payment_line_id,
       payment_interface_id,
       old_urid)
    VALUES
      (p_trans_interface_id,
       'FPM',
       p_source_doc_num, -- 单据编号
       v_requisition_hds.requisition_number, -- 来源单据编号
       p_company_code, -- 机构
       '',
       SYSDATE, -- 付款时间
       to_char(SYSDATE, 'yyyy-mm-dd'), -- 计划付款时间 (待开发)
       p_settlement_mode, --结算方式
       p_pay_type_code, --付款方式 
       '', --资金类别
       '', --资金子类别
       '', --计划项目
       '', --付方组织
       '', --付方银行
       '', --付方账户
       /*p_partner_category*/
       0, --收款方类型
       p_partner_code, -- 收款方代码
       p_payee_city_code, -- 收方银行区域字段待确认
       p_payee_bank_location_code, --收方银行
       p_payee_bank_location, --收方银行开户行
       p_gather_account,
       --v_payment_record.account_number, --收方账户
       v_requisition_lns.account_name, --收方户名
       'CNY', --货币
       p_amount, --交易金额
       p_amount, --实付金额
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
       NULL,
       v_requisition_lns.partner_category,
       v_requisition_lns.partner_id,
       NULL,
       NULL,
       NULL,
       NULL,
       nvl(v_hec_status, 0),
       NULL,
       NULL,
       p_cash_flow_code, -- 现金流量代码
       NULL,
       '',
       v_requisition_hds.description,
       'N',
       'N',
       p_csh_payment_req_line_id,
       p_payment_interface_id,
       v_old_urid);
    COMMIT;
  END;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/26 10:12:10
  -- Ver     : 1.1
    -- Purpose : 插入费控系统资金接口表
  **************************************************/
  PROCEDURE insert_csh_pay_interface(p_id                      NUMBER,
                                     p_billcode                VARCHAR2,
                                     p_datasource              VARCHAR2,
                                     p_inputdate               TIMESTAMP,
                                     p_batchno                 VARCHAR2,
                                     p_settlermentdate         DATE,
                                     p_transferdate            DATE,
                                     p_orgcode                 VARCHAR2,
                                     p_transfercode            VARCHAR2,
                                     p_paytype                 VARCHAR2,
                                     p_abstracts               VARCHAR2,
                                     p_payorgcode              VARCHAR2,
                                     p_payorgname              VARCHAR2,
                                     p_payaccountno            VARCHAR2,
                                     p_payaccountname          VARCHAR2,
                                     p_paybankname             VARCHAR2,
                                     p_payprovince             VARCHAR2,
                                     p_payareanameofcity       VARCHAR2,
                                     p_recorgcode              VARCHAR2,
                                     p_recorgname              VARCHAR2,
                                     p_recaccountno            VARCHAR2,
                                     p_recaccountname          VARCHAR2,
                                     p_recbankname             VARCHAR2,
                                     p_recprovince             VARCHAR2,
                                     p_recareanameofcity       VARCHAR2,
                                     p_bankcodeofrec           VARCHAR2,
                                     p_bankexccodeofrec        VARCHAR2,
                                     p_cnapsofrec              VARCHAR2,
                                     p_paymentno               VARCHAR2,
                                     p_agreementno             VARCHAR2,
                                     p_bankpaytype             VARCHAR2,
                                     p_currencycode            VARCHAR2,
                                     p_amount                  NUMBER,
                                     p_datastatus              CHAR,
                                     p_result                  VARCHAR2,
                                     p_isread                  NUMBER,
                                     p_isreturn                NUMBER,
                                     p_bankerrcode             VARCHAR2,
                                     p_bankerrdesc             VARCHAR2,
                                     p_errcode                 VARCHAR2,
                                     p_errdescription          VARCHAR2,
                                     p_transferid              VARCHAR2,
                                     p_instructionid           VARCHAR2,
                                     p_free1                   VARCHAR2,
                                     p_free2                   VARCHAR2,
                                     p_csh_payment_req_line_id NUMBER) IS
    v_trans_interface_id NUMBER;
    v_partner_code       VARCHAR2(10);
    v_partner_name       VARCHAR2(100);
    v_isprivate          VARCHAR2(10);
    v_settlement_mode    VARCHAR2(10);
    v_error_msg          VARCHAR2(300);
    v_area_code          VARCHAR2(30);
    v_bank_location_code VARCHAR2(30);
    v_bank_location      VARCHAR2(100);
    v_requisition_lns    csh_payment_requisition_lns%ROWTYPE;
  BEGIN
  
    SELECT l.*
      INTO v_requisition_lns
      FROM csh_payment_requisition_lns l
     WHERE l.payment_requisition_line_id = p_csh_payment_req_line_id;
  
    INSERT INTO cux_payment_interface
      (id,
       billcode,
       datasource,
       inputdate,
       batchno,
       settlermentdate,
       transferdate,
       orgcode,
       transfercode,
       paytype,
       abstracts,
       payorgcode,
       payorgname,
       payaccountno,
       payaccountname,
       paybankname,
       payprovince,
       payareanameofcity,
       recorgcode,
       recorgname,
       recaccountno,
       recaccountname,
       recbankname,
       recprovince,
       recareanameofcity,
       bankcodeofrec,
       bankexccodeofrec,
       cnapsofrec,
       paymentno,
       agreementno,
       bankpaytype,
       currencycode,
       amount,
       datastatus,
       RESULT,
       isread,
       isreturn,
       bankerrcode,
       bankerrdesc,
       errcode,
       errdescription,
       transferid,
       instructionid,
       free1,
       free2,
       payee_category)
    VALUES
      (p_id,
       p_billcode,
       p_datasource,
       p_inputdate,
       p_batchno,
       p_settlermentdate,
       p_transferdate,
       p_orgcode,
       p_transfercode,
       p_paytype,
       p_abstracts,
       p_payorgcode,
       p_payorgname,
       p_payaccountno,
       p_payaccountname,
       p_paybankname,
       p_payprovince,
       p_payareanameofcity,
       p_recorgcode,
       p_recorgname,
       p_recaccountno,
       p_recaccountname,
       p_recbankname,
       p_recprovince,
       p_recareanameofcity,
       p_bankcodeofrec,
       p_bankexccodeofrec,
       p_cnapsofrec,
       p_paymentno,
       p_agreementno,
       p_bankpaytype,
       p_currencycode,
       p_amount,
       c_datastatus_saved,
       p_result,
       p_isread,
       p_isreturn,
       p_bankerrcode,
       p_bankerrdesc,
       p_errcode,
       p_errdescription,
       p_transferid,
       p_instructionid,
       p_free1,
       p_free2,
       v_requisition_lns.partner_category);
  
    --获取主键ID编号
    SELECT jx_ats_pay_trans_interface_s.nextval
      INTO v_trans_interface_id
      FROM dual;
  
    -- 结算方式
    SELECT decode(m.description, '银企直联', '1', '9')
      INTO v_settlement_mode
      FROM csh_payment_methods_vl m
     WHERE m.payment_method_id = p_paytype;
  
    --获取收款方代码及名称  
    BEGIN
      IF v_requisition_lns.partner_category = 'EMPLOYEE' THEN
        SELECT ee.employee_code, ee.name, '1'
          INTO v_partner_code, v_partner_name, v_isprivate
          FROM exp_employees ee
         WHERE ee.employee_id = v_requisition_lns.partner_id;
      
        SELECT a.bank_location_code, a.bank_location
          INTO v_bank_location_code, v_bank_location
          FROM exp_employee_accounts a
         WHERE a.employee_id = v_requisition_lns.partner_id
           AND a.account_number = v_requisition_lns.account_number;
      
      ELSIF v_requisition_lns.partner_category = 'VENDER' THEN
        SELECT psv.vender_code, psv.description, '2'
          INTO v_partner_code, v_partner_name, v_isprivate
          FROM pur_system_venders_vl psv
         WHERE psv.vender_id = v_requisition_lns.partner_id;
      
        SELECT a.bank_location_code, a.bank_location
          INTO v_bank_location_code, v_bank_location
          FROM pur_vender_accounts a
         WHERE a.vender_id = v_requisition_lns.partner_id
           AND a.account_number = v_requisition_lns.account_number;
      
      ELSE
        SELECT osc.customer_code, osc.description, '2'
          INTO v_partner_code, v_partner_name, v_isprivate
          FROM ord_system_customers_vl osc
         WHERE osc.customer_id = v_requisition_lns.partner_id;
      
      END IF;
    END;
  
    --地区代码
    SELECT b.area_code
      INTO v_area_code
      FROM br_hfm_bank_v b
     WHERE b.bank_branch_num = v_bank_location_code;
    null;
    --插入资金待支付表
    insert_csh_pay_trans_interface(p_trans_interface_id       => v_trans_interface_id,
                                   p_source_doc_num           => p_billcode,
                                   p_company_code             => p_orgcode,
                                   p_pay_type_code            => p_paytype, ----付款方式 
                                   p_partner_category         => v_partner_name, --收款方类型
                                   p_partner_code             => v_partner_code, --收款方类型
                                   p_payee_city_code          => v_area_code, -- 收方银行区域代码
                                   p_payee_bank_location_code => v_bank_location_code, --收方银行开户行联行号
                                   p_payee_bank_location      => v_bank_location, --收方银行开户行
                                   p_gather_account           => p_recaccountno, --收方账号
                                   p_usedes_code              => '', --用途
                                   p_source_doc_des           => v_requisition_lns.description, --备注,报销单行上备注
                                   p_isprivate                => v_isprivate, --公私标志 必输
                                   p_card_book_flag           => '', --卡折标志  必输
                                   p_settlement_mode          => /*v_settlement_mode*/ p_paytype, --结算方式 必输
                                   p_amount                   => v_requisition_lns.amount,
                                   p_user_id                  => 1,
                                   p_cash_flow_code           => v_requisition_lns.cash_flow_code, --现金流量代码
                                   p_payment_interface_id     => p_id,
                                   p_csh_payment_req_line_id  => p_csh_payment_req_line_id);
  
    --调用资金收付过程 
    BEGIN
      ws_post_zj(p_interface_id => v_trans_interface_id,
                 p_user_id      => 1,
                 p_csh_type     => 'pay');
    EXCEPTION
      WHEN OTHERS THEN
        v_error_msg := SQLERRM || dbms_utility.format_error_backtrace;
        UPDATE jx_ats_pay_trans_interface jpi
           SET jpi.error_message = v_error_msg,
               jpi.hec_status    = '7', --导入失败
               jpi.pay_state     = '7'
         WHERE jpi.urid = v_trans_interface_id;
      
        --收付费应付接口表
        UPDATE cux_payment_interface c
           SET c.datastatus     = '3',
               c.isreturn       = 1,
               c.batchno        = '',
               c.errdescription = '传输资金失败'
         WHERE c.id = p_id;
      
        --资金接口_单据资金信息表
        UPDATE cux_payment_doc_info di
           SET di.zj_import_date = SYSDATE,
               di.zj_deal_date   = SYSDATE,
               di.datastatus     = '3',
               di.zj_error_msg   = '传输资金失败'
         WHERE di.interface_id = p_id;
    END;
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '收款方银行账户主数据存在错误,请联系管理员维护!',
                                                     p_created_by              => 1,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'insert_csh_pay_interface');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_csh_pay_interface;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/26 15:05:44
  -- Ver     : 1.1
  -- Purpose :  按行将借款单待支付信息插入到费控资金接口表
  **************************************************/
  PROCEDURE post_csh_pay_req_by_ln(p_csh_payment_req_line_id NUMBER,
                                   p_info_id                 OUT NUMBER,
                                   p_user_id                 NUMBER) IS
    v_csh_payment_req_header_id NUMBER;
    v_csh_payment_req_line_id   NUMBER;
    v_csh_payment_req_number    VARCHAR2(200);
    v_audit_date                DATE;
    v_currency_code             VARCHAR2(30);
    v_company_code              VARCHAR2(200);
    v_payment_method_code       VARCHAR2(10);
    v_payee_account_number      VARCHAR2(200);
    v_payee_account_name        VARCHAR2(200);
    v_payee_bank_code           VARCHAR2(200);
    v_payee_bank_name           VARCHAR2(200);
    v_sparticipantbankno        VARCHAR2(200);
    v_payee_location_name       VARCHAR2(200);
    v_payee_bank_province       VARCHAR2(200);
    v_payee_bank_city           VARCHAR2(200);
    v_account_flag              VARCHAR2(30);
    v_info_id                   NUMBER;
    v_interface_id              NUMBER;
    v_billcode                  VARCHAR2(50);
    v_gather_flag               VARCHAR2(10);
    v_company_id                NUMBER;
    v_doc_company_id            NUMBER;
  BEGIN
  
    SELECT cux_payment_doc_info_s.nextval INTO v_info_id FROM dual;
  
    SELECT doc_info_s.nextval INTO v_interface_id FROM dual;
  
    --add by Qu yuanyuan 公司层级中第一个公司
    SELECT f.company_id
      INTO v_company_id
      FROM fnd_companies f, fnd_company_levels l
     WHERE f.company_level_id = l.company_level_id
       AND l.company_level_code = '10'
       AND rownum = 1;
    /*    v_billcode := 'HEC' || to_char(v_info_id,
    rpad('FM',
         27,
         '0'));*/
    v_billcode := fnd_code_rule_pkg.get_rule_next_auto_num(p_document_category => '51',
                                                           p_document_type     => '',
                                                           p_company_id        => v_company_id,
                                                           p_operation_unit_id => '',
                                                           p_operation_date    => SYSDATE,
                                                           p_created_by        => p_user_id);
    --end by Qu yuanyuan
  
    csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                          p_log_desc  => '生成INFO_ID为:' || v_info_id ||
                                         ',接口ID为:' || v_interface_id ||
                                         ',资金编码为' || v_billcode,
                          p_ref_table => 'CSH_PAYMENT_REQUISITION_LNS',
                          p_ref_field => 'PAYMENT_REQUISITION_LINE_ID',
                          p_ref_id    => p_csh_payment_req_line_id,
                          p_user_id   => p_user_id);
  
    SELECT h.payment_requisition_header_id,
           l.payment_requisition_line_id,
           h.requisition_number,
           h.audit_date,
           (SELECT fc.company_code
              FROM fnd_companies fc
             WHERE fc.company_id = h.company_id) AS company_code,
           (CASE (SELECT m.payment_method_code
                FROM csh_payment_methods m
               WHERE m.payment_method_id = l.payment_method)
             WHEN '10' THEN
              '1'
             WHEN '20' THEN
              '9'
             WHEN '30' THEN
              '9'
           END) AS payment_method_code,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.account_number
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.account_number
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS account_number,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.account_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.account_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS account_name,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_code
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_code
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS bank_code,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS bank_name,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.sparticipantbankno
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.sparticipantbankno
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS sparticipantbankno,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_location
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_location
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS bank_location_name,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.province_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.province_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS province_name,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.city_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.city_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS city_name,
           CASE (CASE l.partner_category
              WHEN 'VENDER' THEN
               (SELECT v.account_flag
                  FROM pur_vender_accounts v
                 WHERE v.vender_id = l.partner_id
                   AND v.account_number = l.account_number
                   AND v.enabled_flag = 'Y'
                   AND rownum = 1)
              WHEN 'EMPLOYEE' THEN
               (SELECT a.account_flag
                  FROM exp_employee_accounts a
                 WHERE a.employee_id = l.partner_id
                   AND a.account_number = l.account_number
                   AND a.enabled_flag = 'Y'
                   AND rownum = 1)
            END)
             WHEN '10' THEN
              '1'
             WHEN '20' THEN
              '2'
           END,
           h.currency_code,
           l.gather_flag,
           h.company_id
      INTO v_csh_payment_req_header_id,
           v_csh_payment_req_line_id,
           v_csh_payment_req_number,
           v_audit_date,
           v_company_code,
           v_payment_method_code,
           v_payee_account_number,
           v_payee_account_name,
           v_payee_bank_code,
           v_payee_bank_name,
           v_sparticipantbankno,
           v_payee_location_name,
           v_payee_bank_province,
           v_payee_bank_city,
           v_account_flag,
           v_currency_code,
           v_gather_flag,
           v_doc_company_id
      FROM csh_payment_requisition_hds h, csh_payment_requisition_lns l
     WHERE l.payment_requisition_header_id =
           h.payment_requisition_header_id
       AND l.payment_requisition_line_id = p_csh_payment_req_line_id
       FOR UPDATE NOWAIT;
  
    csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                          p_log_desc  => '借款单ID为:' ||
                                         v_csh_payment_req_header_id ||
                                         ',借款单行ID为:' ||
                                         v_csh_payment_req_line_id ||
                                         ',借款单编号为:' ||
                                         v_csh_payment_req_number ||
                                         ',审核日期为:' ||
                                         to_char(v_audit_date, 'YYYY-MM-DD') ||
                                         ',公司代码为:' || v_company_code ||
                                         ',付款方式为:' || v_payment_method_code ||
                                         ',收款方银行账户为:' ||
                                         v_payee_account_number ||
                                         ',收款方银行户名为:' ||
                                         v_payee_account_name ||
                                         ',收款方银行代码为:' || v_payee_bank_code ||
                                         ',收款方银行名称为:' || v_payee_bank_name ||
                                         ',收款方联行号为:' || v_sparticipantbankno ||
                                         ',收款方开户行为:' ||
                                         v_payee_location_name ||
                                         ',收款方开户行省份为:' ||
                                         v_payee_bank_province ||
                                         ',收款方开户行城市为:' || v_payee_bank_city ||
                                         ',收款方银行公、私类型为:' || v_account_flag ||
                                         ',收款方银行币种为:' || v_currency_code ||
                                         ',集中标志位:' || v_gather_flag,
                          p_ref_table => 'CSH_PAYMENT_REQUISITION_LNS',
                          p_ref_field => 'PAYMENT_REQUISITION_LINE_ID',
                          p_ref_id    => p_csh_payment_req_line_id,
                          p_user_id   => p_user_id);
  
    INSERT INTO cux_payment_doc_info i
      (info_id,
       document_category,
       document_id,
       document_line_id,
       interface_id,
       datastatus,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       post_zj_date,
       zj_deal_date,
       zj_refund_date,
       zj_import_date,
       zj_error_msg,
       bank_pay_date,
       billcode,
       hec_refund_flag,
       hec_refund_date,
       pay_transaction_line_id,
       refund_transaction_line_id,
       document_company_id)
    VALUES
      (v_info_id,
       'PAYMENT_REQUISITION',
       v_csh_payment_req_header_id,
       v_csh_payment_req_line_id,
       v_interface_id,
       c_datastatus_saved,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       SYSDATE,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       v_billcode,
       'N',
       NULL,
       NULL,
       NULL,
       v_doc_company_id);
  
    FOR itfs IN (SELECT v_interface_id AS id,
                        v_billcode AS billcode,
                        '2' AS datasource,
                        systimestamp AS inputdate,
                        NULL AS batchno,
                        NULL AS settlermentdate,
                        v_audit_date AS transferdate,
                        v_company_code AS orgcode,
                        '1003' AS transfercode,
                        v_payment_method_code AS paytype,
                        substr(l.description, 1, 30) AS abstracts,
                        NULL AS payorgcode,
                        NULL AS payorgname,
                        NULL AS payaccountno,
                        NULL AS payaccountname,
                        NULL AS paybankname,
                        NULL AS payprovince,
                        NULL AS payareanameofcity,
                        NULL AS recorgcode,
                        NULL AS recorgname,
                        v_payee_account_number AS recaccountno,
                        v_payee_account_name AS recaccountname,
                        v_payee_location_name recbankname,
                        v_payee_bank_province AS recprovince,
                        v_payee_bank_city AS recareanameofcity,
                        NULL AS bankcodeofrec,
                        NULL AS bankexccodeofrec,
                        v_sparticipantbankno AS cnapsofrec,
                        NULL AS paymentno,
                        NULL AS agreementno,
                        v_account_flag AS bankpaytype,
                        v_currency_code AS currencycode,
                        l.amount AS amount,
                        c_datastatus_hec_saved AS datastatus,
                        NULL AS RESULT,
                        0 AS isread,
                        0 AS isreturn,
                        NULL AS bankerrcode,
                        NULL AS bankerrdesc,
                        NULL AS errcode,
                        NULL AS errdescription,
                        NULL AS transferid,
                        NULL AS instructionid,
                        v_payee_bank_code AS free1,
                        --默认为集中支付
                        nvl(v_gather_flag, 1) AS free2
                   FROM csh_payment_requisition_lns l
                  WHERE l.payment_requisition_line_id =
                        v_csh_payment_req_line_id) LOOP
      insert_csh_pay_interface(p_id                      => itfs.id,
                               p_billcode                => itfs.billcode,
                               p_datasource              => itfs.datasource,
                               p_inputdate               => itfs.inputdate,
                               p_batchno                 => itfs.batchno,
                               p_settlermentdate         => itfs.settlermentdate,
                               p_transferdate            => itfs.transferdate,
                               p_orgcode                 => itfs.orgcode,
                               p_transfercode            => itfs.transfercode,
                               p_paytype                 => itfs.paytype,
                               p_abstracts               => itfs.abstracts,
                               p_payorgcode              => itfs.payorgcode,
                               p_payorgname              => itfs.payorgname,
                               p_payaccountno            => itfs.payaccountno,
                               p_payaccountname          => itfs.payaccountname,
                               p_paybankname             => itfs.paybankname,
                               p_payprovince             => itfs.payprovince,
                               p_payareanameofcity       => itfs.payareanameofcity,
                               p_recorgcode              => itfs.recorgcode,
                               p_recorgname              => itfs.recorgname,
                               p_recaccountno            => itfs.recaccountno,
                               p_recaccountname          => itfs.recaccountname,
                               p_recbankname             => itfs.recbankname,
                               p_recprovince             => itfs.recprovince,
                               p_recareanameofcity       => itfs.recareanameofcity,
                               p_bankcodeofrec           => itfs.bankcodeofrec,
                               p_bankexccodeofrec        => itfs.bankexccodeofrec,
                               p_cnapsofrec              => itfs.cnapsofrec,
                               p_paymentno               => itfs.paymentno,
                               p_agreementno             => itfs.agreementno,
                               p_bankpaytype             => itfs.bankpaytype,
                               p_currencycode            => itfs.currencycode,
                               p_amount                  => itfs.amount,
                               p_datastatus              => itfs.datastatus,
                               p_result                  => itfs.result,
                               p_isread                  => itfs.isread,
                               p_isreturn                => itfs.isreturn,
                               p_bankerrcode             => itfs.bankerrcode,
                               p_bankerrdesc             => itfs.bankerrdesc,
                               p_errcode                 => itfs.errcode,
                               p_errdescription          => itfs.errdescription,
                               p_transferid              => itfs.transferid,
                               p_instructionid           => itfs.instructionid,
                               p_free1                   => itfs.free1,
                               p_free2                   => itfs.free2,
                               p_csh_payment_req_line_id => v_csh_payment_req_line_id);
    END LOOP;
  
    p_info_id := v_info_id;
  END post_csh_pay_req_by_ln;

  /*************************************************
  -- Author  : Rick
  -- Created : 2018-10-10 19:41:59
  -- Ver     : 1.1
  -- Purpose : 自制事物,插入接口表
  -- 首先插入资金接口表 cux_payment_doc_info 和  cux_payment_interface
  -- 然后插入数据准备表 jx_ats_pay_trans_interface
  -- 三张表一一对应  cux_payment_doc_info.interface_id = cux_payment_interface.id = jx_ats_pay_trans_interface.payment_interface_id
  **************************************************/
  PROCEDURE gr_post_csh_pay_req_by_ln(p_csh_payment_req_line_id NUMBER,
                                      p_user_id                 NUMBER,
                                      p_interface_id            NUMBER DEFAULT NULL) IS
    v_count NUMBER;
  
    v_csh_payment_req_header_id NUMBER;
    v_csh_payment_req_line_id   NUMBER;
    v_csh_payment_req_number    VARCHAR2(200);
    v_audit_date                DATE;
    v_currency_code             VARCHAR2(30);
    v_company_code              VARCHAR2(200);
    v_payment_method_code       VARCHAR2(10);
    v_payee_account_number      VARCHAR2(200);
    v_payee_account_name        VARCHAR2(200);
    v_payee_bank_code           VARCHAR2(200);
    v_payee_bank_name           VARCHAR2(200);
    v_sparticipantbankno        VARCHAR2(200);
    v_payee_location_name       VARCHAR2(200);
    v_payee_bank_province       VARCHAR2(200);
    v_payee_bank_city           VARCHAR2(200);
    v_account_flag              VARCHAR2(30);
    v_info_id                   NUMBER;
    v_interface_id              NUMBER;
    v_billcode                  VARCHAR2(50);
    v_gather_flag               VARCHAR2(10);
    v_company_id                NUMBER;
    v_doc_company_id            NUMBER;
  
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
  
    --备份失败的资金接口数据
    IF p_interface_id IS NOT NULL THEN
      backup_failed_zj_info(p_info_id => p_interface_id);
    END IF;
  
    SELECT cux_payment_doc_info_s.nextval INTO v_info_id FROM dual;
    SELECT doc_info_s.nextval INTO v_interface_id FROM dual;
  
    SELECT h.company_id
      INTO v_company_id
      FROM csh_payment_requisition_hds h, csh_payment_requisition_lns l
     WHERE h.payment_requisition_header_id =
           l.payment_requisition_header_id
       AND l.payment_requisition_line_id = p_csh_payment_req_line_id;
  
    v_billcode := fnd_code_rule_pkg.get_rule_next_auto_num(p_document_category => '51',
                                                           p_document_type     => '',
                                                           p_company_id        => v_company_id,
                                                           p_operation_unit_id => '',
                                                           p_operation_date    => SYSDATE,
                                                           p_created_by        => p_user_id);
  
    SELECT COUNT(1)
      INTO v_count
      FROM cux_payment_doc_info inf
     WHERE inf.document_category = 'PAYMENT_REQUISITION'
       AND inf.document_line_id = p_csh_payment_req_line_id;
  
    IF (v_count > 0) THEN
      RETURN;
    END IF;
  
    SELECT h.payment_requisition_header_id,
           l.payment_requisition_line_id,
           h.requisition_number,
           h.audit_date,
           (SELECT fc.company_code
              FROM fnd_companies fc
             WHERE fc.company_id = h.company_id) AS company_code,
           (CASE (SELECT m.payment_method_code
                FROM csh_payment_methods m
               WHERE m.payment_method_id = l.payment_method)
             WHEN '10' THEN
              '1'
             WHEN '20' THEN
              '9'
             WHEN '30' THEN
              '9'
           END) AS payment_method_code,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.account_number
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.account_number
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS account_number,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.account_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.account_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS account_name,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_code
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_code
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS bank_code,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS bank_name,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.sparticipantbankno
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.sparticipantbankno
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS sparticipantbankno,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_location
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_location
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS bank_location_name,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.province_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.province_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS province_name,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.city_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.city_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS city_name,
           CASE (CASE l.partner_category
              WHEN 'VENDER' THEN
               (SELECT v.account_flag
                  FROM pur_vender_accounts v
                 WHERE v.vender_id = l.partner_id
                   AND v.account_number = l.account_number
                   AND v.enabled_flag = 'Y'
                   AND rownum = 1)
              WHEN 'EMPLOYEE' THEN
               (SELECT a.account_flag
                  FROM exp_employee_accounts a
                 WHERE a.employee_id = l.partner_id
                   AND a.account_number = l.account_number
                   AND a.enabled_flag = 'Y'
                   AND rownum = 1)
            END)
             WHEN '10' THEN
              '1'
             WHEN '20' THEN
              '2'
           END,
           h.currency_code,
           l.gather_flag,
           h.company_id
      INTO v_csh_payment_req_header_id,
           v_csh_payment_req_line_id,
           v_csh_payment_req_number,
           v_audit_date,
           v_company_code,
           v_payment_method_code,
           v_payee_account_number,
           v_payee_account_name,
           v_payee_bank_code,
           v_payee_bank_name,
           v_sparticipantbankno,
           v_payee_location_name,
           v_payee_bank_province,
           v_payee_bank_city,
           v_account_flag,
           v_currency_code,
           v_gather_flag,
           v_doc_company_id
      FROM csh_payment_requisition_hds h, csh_payment_requisition_lns l
     WHERE l.payment_requisition_header_id =
           h.payment_requisition_header_id
       AND l.payment_requisition_line_id = p_csh_payment_req_line_id;
  
    --- ################单据信息表################################
    FOR c_doc_info IN (SELECT s.payment_requisition_header_id,
                              s.payment_requisition_line_id,
                              h.company_id
                         FROM csh_payment_requisition_lns s,
                              csh_payment_requisition_hds h
                        WHERE s.payment_requisition_line_id =
                              p_csh_payment_req_line_id
                          AND s.payment_requisition_header_id =
                              h.payment_requisition_header_id) LOOP
      INSERT INTO cux_payment_doc_info i
        (info_id,
         document_category,
         document_id,
         document_line_id,
         interface_id,
         datastatus,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date,
         post_zj_date,
         zj_deal_date,
         zj_refund_date,
         zj_import_date,
         zj_error_msg,
         bank_pay_date,
         billcode,
         hec_refund_flag,
         hec_refund_date,
         pay_transaction_line_id,
         refund_transaction_line_id,
         document_company_id)
      VALUES
        (v_info_id,
         'PAYMENT_REQUISITION',
         c_doc_info.payment_requisition_header_id,
         c_doc_info.payment_requisition_line_id,
         v_interface_id,
         c_datastatus_saved,
         p_user_id,
         SYSDATE,
         p_user_id,
         SYSDATE,
         SYSDATE,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         v_billcode,
         'N',
         NULL,
         NULL,
         NULL,
         c_doc_info.company_id);
    END LOOP;
  
    --- ################支付接口表################################
    FOR itfs IN (SELECT v_interface_id AS id,
                        v_billcode AS billcode,
                        '2' AS datasource,
                        systimestamp AS inputdate,
                        NULL AS batchno,
                        NULL AS settlermentdate,
                        v_audit_date AS transferdate,
                        v_company_code AS orgcode,
                        '1003' AS transfercode,
                        v_payment_method_code AS paytype,
                        substr(l.description, 1, 30) AS abstracts,
                        NULL AS payorgcode,
                        NULL AS payorgname,
                        NULL AS payaccountno,
                        NULL AS payaccountname,
                        NULL AS paybankname,
                        NULL AS payprovince,
                        NULL AS payareanameofcity,
                        NULL AS recorgcode,
                        NULL AS recorgname,
                        v_payee_account_number AS recaccountno,
                        v_payee_account_name AS recaccountname,
                        v_payee_location_name recbankname,
                        v_payee_bank_province AS recprovince,
                        v_payee_bank_city AS recareanameofcity,
                        NULL AS bankcodeofrec,
                        NULL AS bankexccodeofrec,
                        v_sparticipantbankno AS cnapsofrec,
                        NULL AS paymentno,
                        NULL AS agreementno,
                        v_account_flag AS bankpaytype,
                        v_currency_code AS currencycode,
                        l.amount AS amount,
                        c_datastatus_hec_saved AS datastatus,
                        NULL AS RESULT,
                        0 AS isread,
                        0 AS isreturn,
                        NULL AS bankerrcode,
                        NULL AS bankerrdesc,
                        NULL AS errcode,
                        NULL AS errdescription,
                        NULL AS transferid,
                        NULL AS instructionid,
                        v_payee_bank_code AS free1,
                        --默认为集中支付
                        nvl(v_gather_flag, 1) AS free2,
                        l.partner_category payee_category
                   FROM csh_payment_requisition_lns l
                  WHERE l.payment_requisition_line_id =
                        v_csh_payment_req_line_id) LOOP
    
      INSERT INTO cux_payment_interface
        (id,
         billcode,
         datasource,
         inputdate,
         batchno,
         settlermentdate,
         transferdate,
         orgcode,
         transfercode,
         paytype,
         abstracts,
         payorgcode,
         payorgname,
         payaccountno,
         payaccountname,
         paybankname,
         payprovince,
         payareanameofcity,
         recorgcode,
         recorgname,
         recaccountno,
         recaccountname,
         recbankname,
         recprovince,
         recareanameofcity,
         bankcodeofrec,
         bankexccodeofrec,
         cnapsofrec,
         paymentno,
         agreementno,
         bankpaytype,
         currencycode,
         amount,
         datastatus,
         RESULT,
         isread,
         isreturn,
         bankerrcode,
         bankerrdesc,
         errcode,
         errdescription,
         transferid,
         instructionid,
         free1,
         free2,
         payee_category,
         doc_serial_num)
      VALUES
        (itfs.id,
         itfs.billcode,
         itfs.datasource,
         itfs.inputdate,
         itfs.batchno,
         itfs.settlermentdate,
         itfs.transferdate,
         itfs.orgcode,
         itfs.transfercode,
         itfs.paytype,
         itfs.abstracts,
         itfs.payorgcode,
         itfs.payorgname,
         itfs.payaccountno,
         itfs.payaccountname,
         itfs.paybankname,
         itfs.payprovince,
         itfs.payareanameofcity,
         itfs.recorgcode,
         itfs.recorgname,
         itfs.recaccountno,
         itfs.recaccountname,
         itfs.recbankname,
         itfs.recprovince,
         itfs.recareanameofcity,
         itfs.bankcodeofrec,
         itfs.bankexccodeofrec,
         itfs.cnapsofrec,
         itfs.paymentno,
         itfs.agreementno,
         itfs.bankpaytype,
         itfs.currencycode,
         itfs.amount,
         c_datastatus_saved,
         itfs.result,
         itfs.isread,
         itfs.isreturn,
         itfs.bankerrcode,
         itfs.bankerrdesc,
         itfs.errcode,
         itfs.errdescription,
         itfs.transferid,
         itfs.instructionid,
         itfs.free1,
         itfs.free2,
         itfs.payee_category,
         'GJ' || lpad(itfs.id, 15, '0')) --支付流水
      ;
    
      --插入数据准备表
      gr_insert_br_data(p_interface_id => itfs.id);
    
    END LOOP;
  
    COMMIT;
  END gr_post_csh_pay_req_by_ln;

  /*************************************************
  -- Author  : Rick
  -- Created : 2018-10-10 19:41:59
  -- Ver     : 1.1
  -- Purpose : 借款单支付
  **************************************************/
  PROCEDURE gr_post_csh_pay_req(p_csh_payment_req_header_id NUMBER,
                                p_user_id                   NUMBER) IS
    CURSOR c1 IS
      SELECT *
        FROM cp_lock_assist cl
       WHERE cl.doc_type = 'PAYMENT_REQUISITION'
         AND cl.doc_id = p_csh_payment_req_header_id
         FOR UPDATE NOWAIT;
    e_locked_error EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_locked_error, -54);
  BEGIN
    -- LOCK TABLE
    cp_lock_assist_pkg.insert_lock_info(p_csh_payment_req_header_id,
                                        'PAYMENT_REQUISITION');
    OPEN c1;
  
    FOR csh_pay_req_lines IN (SELECT s.payment_requisition_line_id
                                FROM csh_payment_requisition_lns s
                               WHERE s.payment_requisition_header_id =
                                     p_csh_payment_req_header_id) LOOP
      csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                            p_log_desc  => '循环当前借款单的行，当前行ID为:' ||
                                           csh_pay_req_lines.payment_requisition_line_id,
                            p_ref_table => 'CSH_PAYMENT_REQUISITION_LNS',
                            p_ref_field => 'PAYMENT_REQUISITION_LINE_ID',
                            p_ref_id    => csh_pay_req_lines.payment_requisition_line_id,
                            p_user_id   => p_user_id);
      gr_post_csh_pay_req_by_ln(p_csh_payment_req_line_id => csh_pay_req_lines.payment_requisition_line_id,
                                p_user_id                 => p_user_id);
    END LOOP;
  
    --发送资金
    gr_post_data_zj(p_document_id       => p_csh_payment_req_header_id,
                    p_document_category => 'PAYMENT_REQUISITION',
                    p_user_id           => 1);
  
    -- CLOSE CURSOR
    CLOSE c1;
  EXCEPTION
    WHEN e_locked_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '单据正在处理，请稍等...',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_gr_pkg',
                                                     p_procedure_function_name => 'gr_post_csh_pay_req');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      IF c1%ISOPEN THEN
        CLOSE c1;
      END IF;
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => SQLERRM ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_gr_pkg',
                                                     p_procedure_function_name => 'gr_post_csh_pay_req');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END gr_post_csh_pay_req;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/26 15:05:44
  -- Ver     : 1.1
  -- Purpose :  将借款单待支付信息插入到费控资金接口表
  **************************************************/
  PROCEDURE post_csh_pay_req(p_csh_payment_req_header_id NUMBER,
                             p_user_id                   NUMBER) IS
    v_info_id NUMBER;
  BEGIN
  
    FOR csh_pay_req_lines IN (SELECT s.payment_requisition_line_id
                                FROM csh_payment_requisition_lns s
                               WHERE s.payment_requisition_header_id =
                                     p_csh_payment_req_header_id
                                 FOR UPDATE NOWAIT) LOOP
      csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                            p_log_desc  => '循环当前借款单的行，当前行ID为:' ||
                                           csh_pay_req_lines.payment_requisition_line_id,
                            p_ref_table => 'CSH_PAYMENT_REQUISITION_LNS',
                            p_ref_field => 'PAYMENT_REQUISITION_LINE_ID',
                            p_ref_id    => csh_pay_req_lines.payment_requisition_line_id,
                            p_user_id   => p_user_id);
      post_csh_pay_req_by_ln(p_csh_payment_req_line_id => csh_pay_req_lines.payment_requisition_line_id,
                             p_info_id                 => v_info_id,
                             p_user_id                 => p_user_id);
    END LOOP;
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => SQLERRM ||
                                                                                  chr(10) ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => 1,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'post_csh_pay_req');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END post_csh_pay_req;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/12 18:44:27
  -- Ver     : 1.1
  -- Purpose : 插入借款单行支付信息
  -- In Para : 
        p_event_record_id 事件记录ID
        p_event_log_id    事件日志ID
        p_event_param     事件参数,借款单头ID
        p_user_id         用户ID
  **************************************************/
  FUNCTION post_csh_pay_req_to_zj(p_event_record_id NUMBER,
                                  p_event_log_id    NUMBER,
                                  p_event_param     NUMBER,
                                  p_user_id         NUMBER) RETURN NUMBER IS
    v_payment_method_code VARCHAR2(30);
  BEGIN
    csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                          p_log_desc  => '借款单插入行信息',
                          p_ref_table => 'CSH_PAYMENT_REQUISITION_HDS',
                          p_ref_field => 'PAYMENT_REQUISITION_HEADER_ID',
                          p_ref_id    => p_event_param,
                          p_user_id   => p_user_id);
  
    SELECT c.payment_method_code
      INTO v_payment_method_code
      FROM csh_payment_requisition_hds e, csh_payment_methods c
     WHERE e.payment_method_id = c.payment_method_id
       AND e.payment_requisition_header_id = p_event_param;
  
    IF v_payment_method_code = '30' THEN
      csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                            p_log_desc  => '当前借款单为无需支付，无需传递资金进行支付',
                            p_ref_table => 'CSH_PAYMENT_REQUISITION_HDS',
                            p_ref_field => 'PAYMENT_REQUISITION_HEADER_ID',
                            p_ref_id    => p_event_param,
                            p_user_id   => p_user_id);
    ELSE
      /*      post_csh_pay_req(p_csh_payment_req_header_id => p_event_param,
      p_user_id                   => p_user_id);*/
      gr_post_csh_pay_req(p_csh_payment_req_header_id => p_event_param,
                          p_user_id                   => p_user_id);
    END IF;
    RETURN 1;
  END post_csh_pay_req_to_zj;

  /*=============================================
  --更新资金通知的交易结果
  =============================================*/
  PROCEDURE update_pay_gather_message(p_interface_id NUMBER,
                                      p_record       zj_result_record) IS
    v_pay_state           VARCHAR2(5);
    v_hfm_pay_type        VARCHAR2(30);
    v_hfm_pay_type_name   VARCHAR2(50);
    v_batch_number        VARCHAR2(50);
    v_pay_made_date       DATE;
    v_serial_number       NUMBER;
    v_serial_num          NUMBER;
    v_company_code        VARCHAR2(30);
    v_pay_trans_interface jx_ats_pay_trans_interface%ROWTYPE;
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
  
    SELECT j.*
      INTO v_pay_trans_interface
      FROM jx_ats_pay_trans_interface j
     WHERE j.urid = p_interface_id;
  
    --付款
    IF p_record.transcode = c_pay_re_code THEN
      --转化支付状态
      SELECT decode(p_record.transstate, '2', '4', '3', '3', '6', '5')
        INTO v_pay_state
        FROM dual;
      --转化交易方式
      SELECT p_record.reqreserved4,
             decode(p_record.reqreserved4, '1', '单笔', 2, '批量')
        INTO v_hfm_pay_type, v_hfm_pay_type_name
        FROM dual;
      --生成流水号
      BEGIN
        IF v_hfm_pay_type = '1' THEN
          --单笔,按照支付时间加四位流水（流水号生成逻辑：同一天内，流水号相同，隔天+1）
          SELECT REPLACE(p_record.corpentity, 'S', '')
            INTO v_company_code
            FROM dual;
          v_batch_number := to_char(to_date(p_record.paymadedate,
                                            'yyyy-mm-dd'),
                                    'yyyymmdd');
          BEGIN
            SELECT serial_number
              INTO v_serial_number
              FROM (SELECT to_number(substr(jpi.hfm_batch_number, -4, 4)) serial_number
                      FROM jx_ats_pay_trans_interface jpi
                     WHERE to_char(jpi.receive_date, 'yyyy-mm-dd') <
                           to_char(SYSDATE, 'yyyy-mm-dd')
                       AND jpi.receive_date IS NOT NULL
                       AND jpi.hfm_pay_type = '1'
                       AND jpi.pay_made_date =
                           to_date(p_record.paymadedate, 'yyyy-mm-dd')
                     ORDER BY hfm_batch_number DESC)
             WHERE rownum = 1;
            v_serial_number := v_serial_number + 1;
          EXCEPTION
            WHEN no_data_found THEN
              v_serial_number := 1;
          END;
        
          v_batch_number := v_batch_number || lpad(v_serial_number, 4, 0) ||
                            v_company_code;
        ELSIF v_hfm_pay_type = '2' THEN
          --批量，对账码生成批次号
          v_batch_number := p_record.abstract;
        ELSE
          v_batch_number := '';
        END IF;
      END;
    
      IF v_pay_state <> '5' THEN
        --非退票
        UPDATE jx_ats_pay_trans_interface jpi
           SET jpi.hfm_batch_number  = v_batch_number, --交易批号
               jpi.abstract          = p_record.abstract, --对账码
               jpi.pay_made_date     = to_date(p_record.paymadedate,
                                               'yyyy-mm-dd'), --yyyymmddhhmmss
               jpi.pay_state         = v_pay_state,
               jpi.hec_status        = v_pay_state,
               jpi.payment_account   = p_record.corpact, --资金付款账号
               jpi.hfm_payment_org   = p_record.corpentity, --资金付款机构
               jpi.pay_info          = p_record.payinfo,
               jpi.hfm_pay_type      = v_hfm_pay_type, --交易类型
               jpi.hfm_pay_type_desc = v_hfm_pay_type_name,
               jpi.receive_date      = SYSDATE,
               jpi.error_message     = ''
         WHERE jpi.urid = p_interface_id;
      
        --支付成功
        IF v_pay_state = '4' THEN
        
          /****************更新费控支付接口表 ******************/
          --收付费应付接口表
          UPDATE cux_payment_interface c
             SET c.datastatus     = '5',
                 c.payaccountno   = p_record.corpact,
                 c.payorgcode     = p_record.corpentity,
                 c.abstract       = p_record.abstract,
                 c.errdescription = p_record.payinfo,
                 c.payment_date   = to_date(p_record.paymadedate,
                                            'yyyy-mm-dd'),
                 c.isread         = 1
           WHERE c.id = v_pay_trans_interface.payment_interface_id;
          /****************更新费控支付接口表******************/
        
        ELSE
          --支付失败
          /****************更新费控支付接口表 ******************/
          --收付费应付接口表
          UPDATE cux_payment_interface c
             SET c.datastatus     = '3',
                 c.errdescription = p_record.payinfo,
                 c.isread         = 1
           WHERE c.id = v_pay_trans_interface.payment_interface_id;
          /****************更新费控支付接口表******************/
        END IF;
      ELSE
        --退票，更新退票信息
        UPDATE jx_ats_pay_trans_interface jpi
           SET jpi.refund_state = 2,
               jpi.refund_info  = p_record.payinfo,
               jpi.refund_time  = to_date(p_record.paymadedate, 'yyyy-mm-dd'),
               jpi.read_flag    = 'N',
               jpi.receive_date = SYSDATE
         WHERE jpi.urid = p_interface_id;
      
        /****************更新费控支付接口表 ******************/
        --收付费应付接口表
        UPDATE cux_payment_interface c
           SET c.datastatus    = '6',
               c.refund_status = '2',
               c.refund_info   = p_record.payinfo,
               c.refund_date   = to_date(p_record.paymadedate, 'yyyy-mm-dd')
         WHERE c.id = v_pay_trans_interface.payment_interface_id;
      
        --资金接口_单据资金信息表
        UPDATE cux_payment_doc_info di
           SET di.bank_pay_date = to_date(p_record.paymadedate, 'yyyy-mm-dd'),
               di.zj_deal_date  = SYSDATE,
               di.datastatus    = '6',
               di.zj_error_msg  = '资金退票，结果为：' || p_record.payinfo
         WHERE di.interface_id = v_pay_trans_interface.payment_interface_id;
      
        /****************更新费控支付接口表******************/
      END IF;
    ELSE
      NULL;
      /*--收款
      select decode(p_record.transstate, '2', 'Y', '3', 'E','E')
        into v_pay_state
        from dual;
      update cp_gather_data_interface cgi
         set cgi.gather_status  = v_pay_state,
             cgi.bank_back_info = p_record.payinfo,
             cgi.last_update_date = sysdate
       where cgi.cp_gather_data_interface_id = p_interface_id;*/
    END IF;
    COMMIT;
  END;

  PROCEDURE insert_acp_pay_trans_interface(p_trans_interface_id       NUMBER,
                                           p_source_doc_num           VARCHAR2,
                                           p_company_code             VARCHAR2,
                                           p_pay_type_code            VARCHAR2, --付款方式 
                                           p_partner_category         VARCHAR2, --收款方类型
                                           p_partner_code             VARCHAR2, -- 收款方代码
                                           p_payee_city_code          VARCHAR2, -- 收方银行区域代码
                                           p_payee_bank_location_code VARCHAR2, --收方银行开户行联行号
                                           p_payee_bank_location      VARCHAR2, ----收方银行开户行
                                           p_gather_account           VARCHAR2, --收款账号
                                           p_usedes_code              VARCHAR2, --用途
                                           p_source_doc_des           VARCHAR2, --备注,报销单头上备注
                                           p_isprivate                VARCHAR2, --公私标志
                                           p_card_book_flag           VARCHAR2, --卡折标志
                                           p_settlement_mode          VARCHAR2, --结算方式
                                           p_amount                   NUMBER,
                                           p_user_id                  NUMBER, --
                                           p_cash_flow_code           VARCHAR2, --现金流量代码
                                           p_acp_requisition_line_id  NUMBER,
                                           p_payment_interface_id     NUMBER) IS
    v_trans_interface_id NUMBER;
    v_interface_id       NUMBER;
    v_hec_status         NUMBER;
    v_old_urid           NUMBER;
    v_trans_interface    jx_ats_pay_trans_interface%ROWTYPE;
    v_requisition_lns    acp_acp_requisition_lns%ROWTYPE;
    v_requisition_hds    acp_acp_requisition_hds%ROWTYPE;
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
  
    SELECT l.*
      INTO v_requisition_lns
      FROM acp_acp_requisition_lns l
     WHERE l.acp_requisition_line_id = p_acp_requisition_line_id;
  
    SELECT a.*
      INTO v_requisition_hds
      FROM acp_acp_requisition_hds a
     WHERE a.acp_requisition_header_id =
           v_requisition_lns.acp_requisition_header_id;
  
    --判断是否重新支付
    BEGIN
      --从历史单据信息表中获取已处理的最新id
      SELECT MAX(h.interface_id)
        INTO v_interface_id
        FROM cux_payment_doc_info_his h
       WHERE h.document_line_id = p_acp_requisition_line_id
         AND h.datastatus = '3' --支付失败
         AND h.document_category = 'ACP_REQUISITION'
         AND h.interface_id <> p_payment_interface_id;
    
      SELECT j.*
        INTO v_trans_interface
        FROM jx_ats_pay_trans_interface j
       WHERE j.payment_interface_id = v_interface_id;
    
      --之前已作导入失败或支付失败处理
      IF v_trans_interface.hec_status IN (7, 3) AND
         v_trans_interface.pay_state IN (7, 3) THEN
      
        UPDATE jx_ats_pay_trans_interface j
           SET j.hec_status       = 9, --重新支付
               j.last_updated_by  = 1,
               j.last_update_date = SYSDATE
         WHERE j.urid = v_trans_interface.urid;
      
        v_old_urid := v_trans_interface.urid;
      END IF;
    EXCEPTION
      WHEN no_data_found THEN
        v_hec_status := 0; --未导入
    END;
  
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
       post_flag,
       document_payment_line_id,
       payment_interface_id,
       old_urid)
    VALUES
      (p_trans_interface_id,
       'FPM',
       p_source_doc_num, -- 单据编号
       v_requisition_hds.requisition_number, -- 来源单据编号
       p_company_code, -- 机构
       '',
       SYSDATE, -- 付款时间
       to_char(SYSDATE, 'yyyy-mm-dd'), -- 计划付款时间 (待开发)
       p_settlement_mode, --结算方式
       p_pay_type_code, --付款方式 
       '', --资金类别
       '', --资金子类别
       '', --计划项目
       '', --付方组织
       '', --付方银行
       '', --付方账户
       /*p_partner_category*/
       0, --收款方类型
       p_partner_code, -- 收款方代码
       p_payee_city_code, -- 收方银行区域字段待确认
       p_payee_bank_location_code, --收方银行
       p_payee_bank_location, --收方银行开户行
       p_gather_account,
       --v_payment_record.account_number, --收方账户
       v_requisition_lns.account_name, --收方户名
       'CNY', --货币
       p_amount, --交易金额
       p_amount, --实付金额
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
       NULL,
       v_requisition_lns.partner_category,
       v_requisition_lns.partner_id,
       NULL,
       NULL,
       NULL,
       NULL,
       nvl(v_hec_status, 0),
       NULL,
       NULL,
       p_cash_flow_code, -- 现金流量代码
       NULL,
       '',
       v_requisition_hds.description,
       'N',
       'N',
       p_acp_requisition_line_id,
       p_payment_interface_id,
       v_old_urid);
    COMMIT;
  END;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/26 10:12:10
  -- Ver     : 1.1
    -- Purpose : 插入费控系统资金接口表
  **************************************************/
  PROCEDURE insert_pay_interface(p_id                      NUMBER,
                                 p_billcode                VARCHAR2,
                                 p_datasource              VARCHAR2,
                                 p_inputdate               TIMESTAMP,
                                 p_batchno                 VARCHAR2,
                                 p_settlermentdate         DATE,
                                 p_transferdate            DATE,
                                 p_orgcode                 VARCHAR2,
                                 p_transfercode            VARCHAR2,
                                 p_paytype                 VARCHAR2,
                                 p_abstracts               VARCHAR2,
                                 p_payorgcode              VARCHAR2,
                                 p_payorgname              VARCHAR2,
                                 p_payaccountno            VARCHAR2,
                                 p_payaccountname          VARCHAR2,
                                 p_paybankname             VARCHAR2,
                                 p_payprovince             VARCHAR2,
                                 p_payareanameofcity       VARCHAR2,
                                 p_recorgcode              VARCHAR2,
                                 p_recorgname              VARCHAR2,
                                 p_recaccountno            VARCHAR2,
                                 p_recaccountname          VARCHAR2,
                                 p_recbankname             VARCHAR2,
                                 p_recprovince             VARCHAR2,
                                 p_recareanameofcity       VARCHAR2,
                                 p_bankcodeofrec           VARCHAR2,
                                 p_bankexccodeofrec        VARCHAR2,
                                 p_cnapsofrec              VARCHAR2,
                                 p_paymentno               VARCHAR2,
                                 p_agreementno             VARCHAR2,
                                 p_bankpaytype             VARCHAR2,
                                 p_currencycode            VARCHAR2,
                                 p_amount                  NUMBER,
                                 p_datastatus              CHAR,
                                 p_result                  VARCHAR2,
                                 p_isread                  NUMBER,
                                 p_isreturn                NUMBER,
                                 p_bankerrcode             VARCHAR2,
                                 p_bankerrdesc             VARCHAR2,
                                 p_errcode                 VARCHAR2,
                                 p_errdescription          VARCHAR2,
                                 p_transferid              VARCHAR2,
                                 p_instructionid           VARCHAR2,
                                 p_free1                   VARCHAR2,
                                 p_free2                   VARCHAR2,
                                 p_acp_requisition_line_id NUMBER) IS
  
    v_trans_interface_id NUMBER;
    v_partner_code       VARCHAR2(10);
    v_partner_name       VARCHAR2(100);
    v_isprivate          VARCHAR2(10);
    v_settlement_mode    VARCHAR2(10);
    v_error_msg          VARCHAR2(300);
    v_area_code          VARCHAR2(30);
    v_bank_location_code VARCHAR2(30);
    v_bank_location      VARCHAR2(100);
    v_requisition_lns    acp_acp_requisition_lns%ROWTYPE;
  BEGIN
  
    SELECT l.*
      INTO v_requisition_lns
      FROM acp_acp_requisition_lns l
     WHERE l.acp_requisition_line_id = p_acp_requisition_line_id;
  
    INSERT INTO cux_payment_interface
      (id,
       billcode,
       datasource,
       inputdate,
       batchno,
       settlermentdate,
       transferdate,
       orgcode,
       transfercode,
       paytype,
       abstracts,
       payorgcode,
       payorgname,
       payaccountno,
       payaccountname,
       paybankname,
       payprovince,
       payareanameofcity,
       recorgcode,
       recorgname,
       recaccountno,
       recaccountname,
       recbankname,
       recprovince,
       recareanameofcity,
       bankcodeofrec,
       bankexccodeofrec,
       cnapsofrec,
       paymentno,
       agreementno,
       bankpaytype,
       currencycode,
       amount,
       datastatus,
       RESULT,
       isread,
       isreturn,
       bankerrcode,
       bankerrdesc,
       errcode,
       errdescription,
       transferid,
       instructionid,
       free1,
       free2,
       payee_category)
    VALUES
      (p_id,
       p_billcode,
       p_datasource,
       p_inputdate,
       p_batchno,
       p_settlermentdate,
       p_transferdate,
       p_orgcode,
       p_transfercode,
       p_paytype,
       p_abstracts,
       p_payorgcode,
       p_payorgname,
       p_payaccountno,
       p_payaccountname,
       p_paybankname,
       p_payprovince,
       p_payareanameofcity,
       p_recorgcode,
       p_recorgname,
       p_recaccountno,
       p_recaccountname,
       p_recbankname,
       p_recprovince,
       p_recareanameofcity,
       p_bankcodeofrec,
       p_bankexccodeofrec,
       p_cnapsofrec,
       p_paymentno,
       p_agreementno,
       p_bankpaytype,
       p_currencycode,
       p_amount,
       c_datastatus_saved,
       p_result,
       p_isread,
       p_isreturn,
       p_bankerrcode,
       p_bankerrdesc,
       p_errcode,
       p_errdescription,
       p_transferid,
       p_instructionid,
       p_free1,
       p_free2,
       v_requisition_lns.partner_category);
  
    --获取主键ID编号
    SELECT jx_ats_pay_trans_interface_s.nextval
      INTO v_trans_interface_id
      FROM dual;
  
    -- 结算方式
    SELECT decode(m.description, '银企直联', '1', '9')
      INTO v_settlement_mode
      FROM csh_payment_methods_vl m
     WHERE m.payment_method_id = p_paytype;
  
    --获取收款方代码及名称
    BEGIN
      IF v_requisition_lns.partner_category = 'EMPLOYEE' THEN
        SELECT ee.employee_code, ee.name, '1'
          INTO v_partner_code, v_partner_name, v_isprivate
          FROM exp_employees ee
         WHERE ee.employee_id = v_requisition_lns.partner_id;
      
        SELECT a.bank_location_code, a.bank_location
          INTO v_bank_location_code, v_bank_location
          FROM exp_employee_accounts a
         WHERE a.employee_id = v_requisition_lns.partner_id
           AND a.account_number = v_requisition_lns.account_number;
      
      ELSIF v_requisition_lns.partner_category = 'VENDER' THEN
        SELECT psv.vender_code, psv.description, '2'
          INTO v_partner_code, v_partner_name, v_isprivate
          FROM pur_system_venders_vl psv
         WHERE psv.vender_id = v_requisition_lns.partner_id;
      
        SELECT a.bank_location_code, a.bank_location
          INTO v_bank_location_code, v_bank_location
          FROM pur_vender_accounts a
         WHERE a.vender_id = v_requisition_lns.partner_id
           AND a.account_number = v_requisition_lns.account_number;
      
      ELSE
        SELECT osc.customer_code, osc.description, '2'
          INTO v_partner_code, v_partner_name, v_isprivate
          FROM ord_system_customers_vl osc
         WHERE osc.customer_id = v_requisition_lns.partner_id;
      
      END IF;
    END;
  
    --地区代码
    SELECT b.area_code
      INTO v_area_code
      FROM br_hfm_bank_v b
     WHERE b.bank_branch_num = v_bank_location_code;
    --插入资金待支付表
    insert_acp_pay_trans_interface(p_trans_interface_id       => v_trans_interface_id,
                                   p_source_doc_num           => p_billcode,
                                   p_company_code             => p_orgcode,
                                   p_pay_type_code            => p_paytype, ----付款方式 
                                   p_partner_category         => v_partner_name, --收款方类型
                                   p_partner_code             => v_partner_code, --收款方类型
                                   p_payee_city_code          => v_area_code, -- 收方银行区域代码
                                   p_payee_bank_location_code => v_bank_location_code, --收方银行开户行联行号
                                   p_payee_bank_location      => v_bank_location, --收方银行开户行
                                   p_gather_account           => p_recaccountno, --收方账号
                                   p_usedes_code              => '', --用途
                                   p_source_doc_des           => v_requisition_lns.line_description, --备注,报销单行上备注
                                   p_isprivate                => v_isprivate, --公私标志 必输
                                   p_card_book_flag           => '', --卡折标志  必输
                                   p_settlement_mode          => /*v_settlement_mode*/ p_paytype, --结算方式 必输
                                   p_amount                   => v_requisition_lns.amount,
                                   p_user_id                  => 1,
                                   p_cash_flow_code           => v_requisition_lns.cash_flow_item_id, --现金流量代码
                                   p_payment_interface_id     => p_id,
                                   p_acp_requisition_line_id  => p_acp_requisition_line_id);
  
    --调用资金收付过程 
    BEGIN
      ws_post_zj(p_interface_id => v_trans_interface_id,
                 p_user_id      => 1,
                 p_csh_type     => 'pay');
    EXCEPTION
      WHEN OTHERS THEN
        v_error_msg := SQLERRM || dbms_utility.format_error_backtrace;
        UPDATE jx_ats_pay_trans_interface jpi
           SET jpi.error_message = v_error_msg,
               jpi.hec_status    = '7', --导入失败
               jpi.pay_state     = '7'
         WHERE jpi.urid = v_trans_interface_id;
      
        --收付费应付接口表
        UPDATE cux_payment_interface c
           SET c.datastatus     = '3',
               c.isreturn       = 1,
               c.batchno        = '',
               c.errdescription = '传输资金失败'
         WHERE c.id = p_id;
      
        --资金接口_单据资金信息表
        UPDATE cux_payment_doc_info di
           SET di.zj_import_date = SYSDATE,
               di.zj_deal_date   = SYSDATE,
               di.datastatus     = '3',
               di.zj_error_msg   = '传输资金失败'
         WHERE di.interface_id = p_id;
    END;
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '收款方银行账户主数据存在错误,请联系管理员维护!',
                                                     p_created_by              => 1,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'insert_pay_interface');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_pay_interface;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/30 13:57:35
  -- Ver     : 1.1
  -- Purpose : 插入付款申请单支付信息
  -- In Para : 
        p_acp_requisition_line_id              number
        p_user_id                              number
  **************************************************/
  PROCEDURE post_acp_req_by_ln(p_acp_requisition_line_id NUMBER,
                               p_info_id                 OUT NUMBER,
                               p_user_id                 NUMBER) IS
    v_acp_requisition_header_id NUMBER;
    v_acp_requisition_line_id   NUMBER;
    v_acp_requisition_number    VARCHAR2(200);
    v_approve_date              DATE;
    v_currency_code             VARCHAR2(30);
    v_company_code              VARCHAR2(200);
    v_payment_method_code       VARCHAR2(10);
    v_payee_account_number      VARCHAR2(200);
    v_payee_account_name        VARCHAR2(200);
    v_payee_bank_code           VARCHAR2(200);
    v_payee_bank_name           VARCHAR2(200);
    v_sparticipantbankno        VARCHAR2(200);
    v_payee_location_name       VARCHAR2(200);
    v_payee_bank_province       VARCHAR2(200);
    v_payee_bank_city           VARCHAR2(200);
    v_account_flag              VARCHAR2(30);
    v_info_id                   NUMBER;
    v_interface_id              NUMBER;
    v_billcode                  VARCHAR2(50);
    v_gather_flag               VARCHAR2(10);
    v_company_id                NUMBER;
    v_doc_company_id            NUMBER;
  BEGIN
  
    SELECT cux_payment_doc_info_s.nextval INTO v_info_id FROM dual;
  
    SELECT doc_info_s.nextval INTO v_interface_id FROM dual;
  
    --add by Qu yuanyuan 公司层级中第一个公司
    SELECT f.company_id
      INTO v_company_id
      FROM fnd_companies f, fnd_company_levels l
     WHERE f.company_level_id = l.company_level_id
       AND l.company_level_code = '10'
       AND rownum = 1;
    /*    v_billcode := 'HEC' || to_char(v_info_id,
    rpad('FM',
         27,
         '0'));*/
    v_billcode := fnd_code_rule_pkg.get_rule_next_auto_num(p_document_category => '51',
                                                           p_document_type     => '',
                                                           p_company_id        => v_company_id,
                                                           p_operation_unit_id => '',
                                                           p_operation_date    => SYSDATE,
                                                           p_created_by        => p_user_id);
    --end by Qu yuanyuan
  
    csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                          p_log_desc  => '生成INFO_ID为:' || v_info_id ||
                                         ',接口ID为:' || v_interface_id ||
                                         ',资金编码为' || v_billcode,
                          p_ref_table => 'ACP_ACP_REQUISITION_HDS',
                          p_ref_field => 'ACP_REQUISITION_HEADER_ID',
                          p_ref_id    => p_acp_requisition_line_id,
                          p_user_id   => p_user_id);
  
    SELECT h.acp_requisition_header_id,
           l.acp_requisition_line_id,
           h.requisition_number,
           h.approval_date,
           (SELECT fc.company_code
              FROM fnd_companies fc
             WHERE fc.company_id = h.company_id) AS company_code,
           (CASE (SELECT m.payment_method_code
                FROM csh_payment_methods m
               WHERE m.payment_method_id = l.payment_method_id)
             WHEN '10' THEN
              '1'
             WHEN '20' THEN
              '9'
             WHEN '30' THEN
              '9'
           END) AS payment_method_code,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.account_number
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.account_number
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS account_number,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.account_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.account_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS account_name,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_code
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_code
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS bank_code,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS bank_name,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.sparticipantbankno
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.sparticipantbankno
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS sparticipantbankno,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_location
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_location
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS bank_location_name,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.province_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.province_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS province_name,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.city_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.city_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS city_name,
           CASE (CASE l.partner_category
              WHEN 'VENDER' THEN
               (SELECT v.account_flag
                  FROM pur_vender_accounts v
                 WHERE v.vender_id = l.partner_id
                   AND v.account_number = l.account_number
                   AND v.enabled_flag = 'Y'
                   AND rownum = 1)
              WHEN 'EMPLOYEE' THEN
               (SELECT a.account_flag
                  FROM exp_employee_accounts a
                 WHERE a.employee_id = l.partner_id
                   AND a.account_number = l.account_number
                   AND a.enabled_flag = 'Y'
                   AND rownum = 1)
            END)
             WHEN '10' THEN
              '1'
             WHEN '20' THEN
              '2'
           END,
           h.currency_code,
           --默认为非集中支付
           nvl((SELECT gather_flag
                 FROM exp_report_pmt_schedules s
                WHERE s.payment_schedule_line_id = l.ref_document_line_id),
               0) AS gather_flag,
           h.company_id
      INTO v_acp_requisition_header_id,
           v_acp_requisition_line_id,
           v_acp_requisition_number,
           v_approve_date,
           v_company_code,
           v_payment_method_code,
           v_payee_account_number,
           v_payee_account_name,
           v_payee_bank_code,
           v_payee_bank_name,
           v_sparticipantbankno,
           v_payee_location_name,
           v_payee_bank_province,
           v_payee_bank_city,
           v_account_flag,
           v_currency_code,
           v_gather_flag,
           v_doc_company_id
      FROM acp_acp_requisition_hds h, acp_acp_requisition_lns l
     WHERE l.acp_requisition_header_id = h.acp_requisition_header_id
       AND l.acp_requisition_line_id = p_acp_requisition_line_id
       FOR UPDATE NOWAIT;
  
    csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                          p_log_desc  => '付款申请单ID为:' ||
                                         v_acp_requisition_header_id ||
                                         ',付款申请单行ID为:' ||
                                         v_acp_requisition_line_id ||
                                         ',付款申请单编号为:' ||
                                         v_acp_requisition_number ||
                                         ',审批日期为:' ||
                                         to_char(v_approve_date,
                                                 'YYYY-MM-DD') || ',公司代码为:' ||
                                         v_company_code || ',付款方式为:' ||
                                         v_payment_method_code ||
                                         ',收款方银行账户为:' ||
                                         v_payee_account_number ||
                                         ',收款方银行户名为:' ||
                                         v_payee_account_name ||
                                         ',收款方银行代码为:' || v_payee_bank_code ||
                                         ',收款方银行名称为:' || v_payee_bank_name ||
                                         ',收款方联行号为:' || v_sparticipantbankno ||
                                         ',收款方开户行为:' ||
                                         v_payee_location_name ||
                                         ',收款方开户行省份为:' ||
                                         v_payee_bank_province ||
                                         ',收款方开户行城市为:' || v_payee_bank_city ||
                                         ',收款方银行公、私类型为:' || v_account_flag ||
                                         ',收款方银行币种为:' || v_currency_code ||
                                         ',集中标志位:' || v_gather_flag,
                          p_ref_table => 'ACP_ACP_REQUISITION_LNS',
                          p_ref_field => 'ACP_REQUISITION_LINE_ID',
                          p_ref_id    => p_acp_requisition_line_id,
                          p_user_id   => p_user_id);
  
    INSERT INTO cux_payment_doc_info i
      (info_id,
       document_category,
       document_id,
       document_line_id,
       interface_id,
       datastatus,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       post_zj_date,
       zj_deal_date,
       zj_refund_date,
       zj_import_date,
       zj_error_msg,
       bank_pay_date,
       billcode,
       hec_refund_flag,
       hec_refund_date,
       pay_transaction_line_id,
       refund_transaction_line_id,
       document_company_id)
    VALUES
      (v_info_id,
       'ACP_REQUISITION',
       v_acp_requisition_header_id,
       v_acp_requisition_line_id,
       v_interface_id,
       c_datastatus_saved,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       SYSDATE,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       v_billcode,
       'N',
       NULL,
       NULL,
       NULL,
       v_doc_company_id);
  
    FOR itfs IN (SELECT v_interface_id AS id,
                        v_billcode AS billcode,
                        '2' AS datasource,
                        systimestamp AS inputdate,
                        NULL AS batchno,
                        NULL AS settlermentdate,
                        v_approve_date AS transferdate,
                        v_company_code AS orgcode,
                        '1003' AS transfercode,
                        v_payment_method_code AS paytype,
                        (SELECT substr(p.description, 1, 30)
                           FROM exp_report_pmt_schedules p
                          WHERE p.exp_report_header_id = l.ref_document_id
                            AND p.payment_schedule_line_id =
                                l.ref_document_line_id) AS abstracts,
                        NULL AS payorgcode,
                        NULL AS payorgname,
                        NULL AS payaccountno,
                        NULL AS payaccountname,
                        NULL AS paybankname,
                        NULL AS payprovince,
                        NULL AS payareanameofcity,
                        NULL AS recorgcode,
                        NULL AS recorgname,
                        v_payee_account_number AS recaccountno,
                        v_payee_account_name AS recaccountname,
                        v_payee_location_name recbankname,
                        v_payee_bank_province AS recprovince,
                        v_payee_bank_city AS recareanameofcity,
                        NULL AS bankcodeofrec,
                        NULL AS bankexccodeofrec,
                        v_sparticipantbankno AS cnapsofrec,
                        NULL AS paymentno,
                        NULL AS agreementno,
                        v_account_flag AS bankpaytype,
                        v_currency_code AS currencycode,
                        l.amount AS amount,
                        c_datastatus_hec_saved AS datastatus,
                        NULL AS RESULT,
                        0 AS isread,
                        0 AS isreturn,
                        NULL AS bankerrcode,
                        NULL AS bankerrdesc,
                        NULL AS errcode,
                        NULL AS errdescription,
                        NULL AS transferid,
                        NULL AS instructionid,
                        v_payee_bank_code AS free1,
                        --默认集中支付
                        nvl(v_gather_flag, 1) AS free2
                   FROM acp_acp_requisition_lns l
                  WHERE l.acp_requisition_line_id =
                        v_acp_requisition_line_id) LOOP
      insert_pay_interface(p_id                      => itfs.id,
                           p_billcode                => itfs.billcode,
                           p_datasource              => itfs.datasource,
                           p_inputdate               => itfs.inputdate,
                           p_batchno                 => itfs.batchno,
                           p_settlermentdate         => itfs.settlermentdate,
                           p_transferdate            => itfs.transferdate,
                           p_orgcode                 => itfs.orgcode,
                           p_transfercode            => itfs.transfercode,
                           p_paytype                 => itfs.paytype,
                           p_abstracts               => itfs.abstracts,
                           p_payorgcode              => itfs.payorgcode,
                           p_payorgname              => itfs.payorgname,
                           p_payaccountno            => itfs.payaccountno,
                           p_payaccountname          => itfs.payaccountname,
                           p_paybankname             => itfs.paybankname,
                           p_payprovince             => itfs.payprovince,
                           p_payareanameofcity       => itfs.payareanameofcity,
                           p_recorgcode              => itfs.recorgcode,
                           p_recorgname              => itfs.recorgname,
                           p_recaccountno            => itfs.recaccountno,
                           p_recaccountname          => itfs.recaccountname,
                           p_recbankname             => itfs.recbankname,
                           p_recprovince             => itfs.recprovince,
                           p_recareanameofcity       => itfs.recareanameofcity,
                           p_bankcodeofrec           => itfs.bankcodeofrec,
                           p_bankexccodeofrec        => itfs.bankexccodeofrec,
                           p_cnapsofrec              => itfs.cnapsofrec,
                           p_paymentno               => itfs.paymentno,
                           p_agreementno             => itfs.agreementno,
                           p_bankpaytype             => itfs.bankpaytype,
                           p_currencycode            => itfs.currencycode,
                           p_amount                  => itfs.amount,
                           p_datastatus              => itfs.datastatus,
                           p_result                  => itfs.result,
                           p_isread                  => itfs.isread,
                           p_isreturn                => itfs.isreturn,
                           p_bankerrcode             => itfs.bankerrcode,
                           p_bankerrdesc             => itfs.bankerrdesc,
                           p_errcode                 => itfs.errcode,
                           p_errdescription          => itfs.errdescription,
                           p_transferid              => itfs.transferid,
                           p_instructionid           => itfs.instructionid,
                           p_free1                   => itfs.free1,
                           p_free2                   => itfs.free2,
                           p_acp_requisition_line_id => v_acp_requisition_line_id);
    END LOOP;
  
    p_info_id := v_info_id;
  END post_acp_req_by_ln;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/30 13:57:35
  -- Ver     : 1.1
  -- Purpose : 插入付款申请单支付信息
  -- In Para : 
        p_acp_requisition_header_id              number
        p_user_id                                number
  **************************************************/
  PROCEDURE post_acp_req(p_acp_requisition_header_id NUMBER,
                         p_user_id                   NUMBER) IS
    v_info_id NUMBER;
  BEGIN
    FOR lns IN (SELECT *
                  FROM acp_acp_requisition_lns l
                 WHERE l.acp_requisition_header_id =
                       p_acp_requisition_header_id) LOOP
      csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                            p_log_desc  => '循环当前付款申请单的行，当前行ID为:' ||
                                           lns.acp_requisition_line_id,
                            p_ref_table => 'ACP_ACP_REQUISITION_LNS',
                            p_ref_field => 'ACP_REQUISITION_LINE_ID',
                            p_ref_id    => lns.acp_requisition_line_id,
                            p_user_id   => p_user_id);
      post_acp_req_by_ln(p_acp_requisition_line_id => lns.acp_requisition_line_id,
                         p_info_id                 => v_info_id,
                         p_user_id                 => p_user_id);
    END LOOP;
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => SQLERRM ||
                                                                                  chr(10) ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => 1,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'post_acp_req');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END post_acp_req;

  PROCEDURE gr_post_acp_req_by_ln(p_acp_requisition_line_id NUMBER,
                                  p_user_id                 NUMBER,
                                  p_interface_id            NUMBER DEFAULT NULL) IS
    v_acp_requisition_header_id NUMBER;
    v_acp_requisition_line_id   NUMBER;
    v_acp_requisition_number    VARCHAR2(200);
    v_approve_date              DATE;
    v_currency_code             VARCHAR2(30);
    v_company_code              VARCHAR2(200);
    v_payment_method_code       VARCHAR2(10);
    v_payee_account_number      VARCHAR2(200);
    v_payee_account_name        VARCHAR2(200);
    v_payee_bank_code           VARCHAR2(200);
    v_payee_bank_name           VARCHAR2(200);
    v_sparticipantbankno        VARCHAR2(200);
    v_payee_location_name       VARCHAR2(200);
    v_payee_bank_province       VARCHAR2(200);
    v_payee_bank_city           VARCHAR2(200);
    v_account_flag              VARCHAR2(30);
    v_info_id                   NUMBER;
    v_interface_id              NUMBER;
    v_billcode                  VARCHAR2(50);
    v_gather_flag               VARCHAR2(10);
    v_company_id                NUMBER;
    v_doc_company_id            NUMBER;
    v_count                     NUMBER;
    --PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
  
    --备份失败的资金接口数据
    IF p_interface_id IS NOT NULL THEN
      backup_failed_zj_info(p_info_id => p_interface_id);
    END IF;
  
    SELECT cux_payment_doc_info_s.nextval INTO v_info_id FROM dual;
    SELECT doc_info_s.nextval INTO v_interface_id FROM dual;
  
    SELECT h.company_id
      INTO v_company_id
      FROM acp_acp_requisition_hds h
     WHERE h.acp_requisition_header_id =
           (SELECT l.acp_requisition_header_id
              FROM acp_acp_requisition_lns l
             WHERE l.acp_requisition_line_id = p_acp_requisition_line_id);
  
    v_billcode := fnd_code_rule_pkg.get_rule_next_auto_num(p_document_category => '51',
                                                           p_document_type     => '',
                                                           p_company_id        => v_company_id,
                                                           p_operation_unit_id => '',
                                                           p_operation_date    => SYSDATE,
                                                           p_created_by        => p_user_id);
  
    csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                          p_log_desc  => '生成INFO_ID为:' || v_info_id ||
                                         ',接口ID为:' || v_interface_id ||
                                         ',资金编码为' || v_billcode,
                          p_ref_table => 'ACP_ACP_REQUISITION_HDS',
                          p_ref_field => 'ACP_REQUISITION_HEADER_ID',
                          p_ref_id    => p_acp_requisition_line_id,
                          p_user_id   => p_user_id);
  
    SELECT COUNT(1)
      INTO v_count
      FROM cux_payment_doc_info inf
     WHERE inf.document_category = 'ACP_REQUISITION'
       AND inf.document_line_id = p_acp_requisition_line_id
       AND inf.datastatus <> '3'; --失败状态
  
    IF (v_count > 0) THEN
      RETURN;
    END IF;
  
    SELECT h.acp_requisition_header_id,
           l.acp_requisition_line_id,
           h.requisition_number,
           h.approval_date,
           (SELECT fc.company_code
              FROM fnd_companies fc
             WHERE fc.company_id = h.company_id) AS company_code,
           (CASE (SELECT m.payment_method_code
                FROM csh_payment_methods m
               WHERE m.payment_method_id = l.payment_method_id)
             WHEN '10' THEN
              '1'
             WHEN '20' THEN
              '9'
             WHEN '30' THEN
              '9'
           END) AS payment_method_code,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.account_number
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.account_number
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS account_number,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.account_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.account_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS account_name,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_code
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_code
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS bank_code,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS bank_name,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.sparticipantbankno
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.sparticipantbankno
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS sparticipantbankno,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.bank_location
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.bank_location
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS bank_location_name,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.province_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.province_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS province_name,
           (CASE l.partner_category
             WHEN 'VENDER' THEN
              (SELECT v.city_name
                 FROM pur_vender_accounts v
                WHERE v.vender_id = l.partner_id
                  AND v.account_number = l.account_number)
             WHEN 'EMPLOYEE' THEN
              (SELECT a.city_name
                 FROM exp_employee_accounts a
                WHERE a.employee_id = l.partner_id
                  AND a.account_number = l.account_number)
           END) AS city_name,
           CASE (CASE l.partner_category
              WHEN 'VENDER' THEN
               (SELECT v.account_flag
                  FROM pur_vender_accounts v
                 WHERE v.vender_id = l.partner_id
                   AND v.account_number = l.account_number
                   AND v.enabled_flag = 'Y'
                   AND rownum = 1)
              WHEN 'EMPLOYEE' THEN
               (SELECT a.account_flag
                  FROM exp_employee_accounts a
                 WHERE a.employee_id = l.partner_id
                   AND a.account_number = l.account_number
                   AND a.enabled_flag = 'Y'
                   AND rownum = 1)
            END)
             WHEN '10' THEN
              '1'
             WHEN '20' THEN
              '2'
           END,
           h.currency_code,
           --默认为非集中支付
           nvl((SELECT gather_flag
                 FROM exp_report_pmt_schedules s
                WHERE s.payment_schedule_line_id = l.ref_document_line_id),
               0) AS gather_flag,
           h.company_id
      INTO v_acp_requisition_header_id,
           v_acp_requisition_line_id,
           v_acp_requisition_number,
           v_approve_date,
           v_company_code,
           v_payment_method_code,
           v_payee_account_number,
           v_payee_account_name,
           v_payee_bank_code,
           v_payee_bank_name,
           v_sparticipantbankno,
           v_payee_location_name,
           v_payee_bank_province,
           v_payee_bank_city,
           v_account_flag,
           v_currency_code,
           v_gather_flag,
           v_doc_company_id
      FROM acp_acp_requisition_hds h, acp_acp_requisition_lns l
     WHERE l.acp_requisition_header_id = h.acp_requisition_header_id
       AND l.acp_requisition_line_id = p_acp_requisition_line_id
       FOR UPDATE NOWAIT;
  
    csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                          p_log_desc  => '付款申请单ID为:' ||
                                         v_acp_requisition_header_id ||
                                         ',付款申请单行ID为:' ||
                                         v_acp_requisition_line_id ||
                                         ',付款申请单编号为:' ||
                                         v_acp_requisition_number ||
                                         ',审批日期为:' ||
                                         to_char(v_approve_date,
                                                 'YYYY-MM-DD') || ',公司代码为:' ||
                                         v_company_code || ',付款方式为:' ||
                                         v_payment_method_code ||
                                         ',收款方银行账户为:' ||
                                         v_payee_account_number ||
                                         ',收款方银行户名为:' ||
                                         v_payee_account_name ||
                                         ',收款方银行代码为:' || v_payee_bank_code ||
                                         ',收款方银行名称为:' || v_payee_bank_name ||
                                         ',收款方联行号为:' || v_sparticipantbankno ||
                                         ',收款方开户行为:' ||
                                         v_payee_location_name ||
                                         ',收款方开户行省份为:' ||
                                         v_payee_bank_province ||
                                         ',收款方开户行城市为:' || v_payee_bank_city ||
                                         ',收款方银行公、私类型为:' || v_account_flag ||
                                         ',收款方银行币种为:' || v_currency_code ||
                                         ',集中标志位:' || v_gather_flag,
                          p_ref_table => 'ACP_ACP_REQUISITION_LNS',
                          p_ref_field => 'ACP_REQUISITION_LINE_ID',
                          p_ref_id    => p_acp_requisition_line_id,
                          p_user_id   => p_user_id);
  
    --- ################单据信息表################################
    FOR c_doc_info IN (SELECT l.acp_requisition_header_id,
                              l.acp_requisition_line_id,
                              h.company_id
                         FROM acp_acp_requisition_lns l,
                              acp_acp_requisition_hds h
                        WHERE l.acp_requisition_line_id =
                              p_acp_requisition_line_id
                          AND l.acp_requisition_header_id =
                              h.acp_requisition_header_id) LOOP
    
      INSERT INTO cux_payment_doc_info i
        (info_id,
         document_category,
         document_id,
         document_line_id,
         interface_id,
         datastatus,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date,
         post_zj_date,
         zj_deal_date,
         zj_refund_date,
         zj_import_date,
         zj_error_msg,
         bank_pay_date,
         billcode,
         hec_refund_flag,
         hec_refund_date,
         pay_transaction_line_id,
         refund_transaction_line_id,
         document_company_id)
      VALUES
        (v_info_id,
         'ACP_REQUISITION',
         v_acp_requisition_header_id,
         v_acp_requisition_line_id,
         v_interface_id,
         c_datastatus_saved,
         p_user_id,
         SYSDATE,
         p_user_id,
         SYSDATE,
         SYSDATE,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         v_billcode,
         'N',
         NULL,
         NULL,
         NULL,
         v_doc_company_id);
    END LOOP;
  
    FOR itfs IN (SELECT v_interface_id AS id,
                        v_billcode AS billcode,
                        '2' AS datasource,
                        systimestamp AS inputdate,
                        NULL AS batchno,
                        NULL AS settlermentdate,
                        v_approve_date AS transferdate,
                        v_company_code AS orgcode,
                        '1003' AS transfercode,
                        v_payment_method_code AS paytype,
                        (SELECT substr(p.description, 1, 30)
                           FROM exp_report_pmt_schedules p
                          WHERE p.exp_report_header_id = l.ref_document_id
                            AND p.payment_schedule_line_id =
                                l.ref_document_line_id) AS abstracts,
                        NULL AS payorgcode,
                        NULL AS payorgname,
                        NULL AS payaccountno,
                        NULL AS payaccountname,
                        NULL AS paybankname,
                        NULL AS payprovince,
                        NULL AS payareanameofcity,
                        NULL AS recorgcode,
                        NULL AS recorgname,
                        v_payee_account_number AS recaccountno,
                        v_payee_account_name AS recaccountname,
                        v_payee_location_name recbankname,
                        v_payee_bank_province AS recprovince,
                        v_payee_bank_city AS recareanameofcity,
                        NULL AS bankcodeofrec,
                        NULL AS bankexccodeofrec,
                        v_sparticipantbankno AS cnapsofrec,
                        NULL AS paymentno,
                        NULL AS agreementno,
                        v_account_flag AS bankpaytype,
                        v_currency_code AS currencycode,
                        l.amount AS amount,
                        c_datastatus_hec_saved AS datastatus,
                        NULL AS RESULT,
                        0 AS isread,
                        0 AS isreturn,
                        NULL AS bankerrcode,
                        NULL AS bankerrdesc,
                        NULL AS errcode,
                        NULL AS errdescription,
                        NULL AS transferid,
                        NULL AS instructionid,
                        v_payee_bank_code AS free1,
                        --默认集中支付
                        nvl(v_gather_flag, 1) AS free2,
                        l.partner_category payee_category
                   FROM acp_acp_requisition_lns l
                  WHERE l.acp_requisition_line_id =
                        v_acp_requisition_line_id) LOOP
      INSERT INTO cux_payment_interface
        (id,
         billcode,
         datasource,
         inputdate,
         batchno,
         settlermentdate,
         transferdate,
         orgcode,
         transfercode,
         paytype,
         abstracts,
         payorgcode,
         payorgname,
         payaccountno,
         payaccountname,
         paybankname,
         payprovince,
         payareanameofcity,
         recorgcode,
         recorgname,
         recaccountno,
         recaccountname,
         recbankname,
         recprovince,
         recareanameofcity,
         bankcodeofrec,
         bankexccodeofrec,
         cnapsofrec,
         paymentno,
         agreementno,
         bankpaytype,
         currencycode,
         amount,
         datastatus,
         RESULT,
         isread,
         isreturn,
         bankerrcode,
         bankerrdesc,
         errcode,
         errdescription,
         transferid,
         instructionid,
         free1,
         free2,
         payee_category,
         doc_serial_num)
      VALUES
        (itfs.id,
         itfs.billcode,
         itfs.datasource,
         itfs.inputdate,
         itfs.batchno,
         itfs.settlermentdate,
         itfs.transferdate,
         itfs.orgcode,
         itfs.transfercode,
         itfs.paytype,
         itfs.abstracts,
         itfs.payorgcode,
         itfs.payorgname,
         itfs.payaccountno,
         itfs.payaccountname,
         itfs.paybankname,
         itfs.payprovince,
         itfs.payareanameofcity,
         itfs.recorgcode,
         itfs.recorgname,
         itfs.recaccountno,
         itfs.recaccountname,
         itfs.recbankname,
         itfs.recprovince,
         itfs.recareanameofcity,
         itfs.bankcodeofrec,
         itfs.bankexccodeofrec,
         itfs.cnapsofrec,
         itfs.paymentno,
         itfs.agreementno,
         itfs.bankpaytype,
         itfs.currencycode,
         itfs.amount,
         c_datastatus_saved,
         itfs.result,
         itfs.isread,
         itfs.isreturn,
         itfs.bankerrcode,
         itfs.bankerrdesc,
         itfs.errcode,
         itfs.errdescription,
         itfs.transferid,
         itfs.instructionid,
         itfs.free1,
         itfs.free2,
         itfs.payee_category,
         'GF' || lpad(itfs.id, 15, '0')) --支付流水
      ;
    
      --插入数据准备表
      gr_insert_br_data(p_interface_id => itfs.id);
    END LOOP;
    COMMIT;
  END gr_post_acp_req_by_ln;

  PROCEDURE gr_post_acp_req(p_acp_requisition_header_id NUMBER,
                            p_user_id                   NUMBER) IS
    CURSOR c1 IS
      SELECT *
        FROM cp_lock_assist cl
       WHERE cl.doc_type = 'ACP_REQUISITION'
         AND cl.doc_id = p_acp_requisition_header_id
         FOR UPDATE NOWAIT;
    e_locked_error EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_locked_error, -54);
  BEGIN
    -- LOCK TABLE
    cp_lock_assist_pkg.insert_lock_info(p_acp_requisition_header_id,
                                        'ACP_REQUISITION');
    OPEN c1;
  
    FOR lns IN (SELECT l.acp_requisition_line_id
                  FROM acp_acp_requisition_lns l
                 WHERE l.acp_requisition_header_id =
                       p_acp_requisition_header_id) LOOP
      csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                            p_log_desc  => '循环当前付款申请单的行，当前行ID为:' ||
                                           lns.acp_requisition_line_id,
                            p_ref_table => 'ACP_ACP_REQUISITION_LNS',
                            p_ref_field => 'ACP_REQUISITION_LINE_ID',
                            p_ref_id    => lns.acp_requisition_line_id,
                            p_user_id   => p_user_id);
      gr_post_acp_req_by_ln(p_acp_requisition_line_id => lns.acp_requisition_line_id,
                            p_user_id                 => p_user_id);
    END LOOP;
  
    --发送资金
    gr_post_data_zj(p_document_id       => p_acp_requisition_header_id,
                    p_document_category => 'ACP_REQUISITION',
                    p_user_id           => 1);
  
    -- CLOSE CURSOR
    CLOSE c1;
  EXCEPTION
    WHEN e_locked_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '单据正在处理，请稍等...',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_gr_pkg',
                                                     p_procedure_function_name => 'gr_post_acp_req');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      IF c1%ISOPEN THEN
        CLOSE c1;
      END IF;
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => SQLERRM ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_gr_pkg',
                                                     p_procedure_function_name => 'gr_post_acp_req');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END gr_post_acp_req;

  /*************************************************
   -- Author  : MOUSE
   -- Created : 2015/11/30 13:56:12
   -- Ver     : 1.1
  -- Purpose : 插入付款申请单支付信息
  -- In Para : 
        p_event_record_id 事件记录ID
        p_event_log_id    事件日志ID
        p_event_param     事件参数,借款单头ID
        p_user_id         用户ID
   **************************************************/
  FUNCTION post_acp_req_to_zj(p_event_record_id NUMBER,
                              p_event_log_id    NUMBER,
                              p_event_param     NUMBER,
                              p_user_id         NUMBER) RETURN NUMBER IS
  
  BEGIN
    csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                          p_log_desc  => '付款申请单插入行信息',
                          p_ref_table => 'ACP_ACP_REQUISITION_HDS',
                          p_ref_field => 'ACP_REQUISITION_HEADER_ID',
                          p_ref_id    => p_event_param,
                          p_user_id   => p_user_id);
  
    /*post_acp_req(p_acp_requisition_header_id => p_event_param,
    p_user_id                   => p_user_id);*/
    gr_post_acp_req(p_acp_requisition_header_id => p_event_param,
                    p_user_id                   => p_user_id);
    RETURN 1;
  END post_acp_req_to_zj;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/13 15:49:01
  -- Ver     : 1.1
  -- Purpose : 
  -- In Para : 
         p_info_id        单据付款信息表ID       
  **************************************************/
  PROCEDURE pay_success(p_info_id NUMBER) IS
    v_session_id            NUMBER := -9999999999;
    v_company_id            NUMBER;
    v_bank_account_id       NUMBER;
    v_doc_info              cux_payment_doc_info%ROWTYPE;
    v_pay_interface         cux_payment_interface%ROWTYPE;
    v_exp_pmt_line          exp_report_pmt_schedules%ROWTYPE;
    v_csh_pay_req_line      csh_payment_requisition_lns%ROWTYPE;
    v_acp_req_line          acp_acp_requisition_lns%ROWTYPE;
    v_transaction_header_id NUMBER;
    v_transaction_line_id   NUMBER;
    v_write_off_id          NUMBER;
    v_batch_id              NUMBER;
    v_doc_number            VARCHAR2(30);
  BEGIN
    SELECT *
      INTO v_doc_info
      FROM cux_payment_doc_info i
     WHERE i.info_id = p_info_id
       AND i.datastatus = '5'
       FOR UPDATE NOWAIT;
  
    SELECT *
      INTO v_pay_interface
      FROM cux_payment_interface i
     WHERE i.billcode = v_doc_info.billcode;
  
    csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                          p_log_desc  => 'INFO_ID为:' || v_doc_info.info_id ||
                                         ',BILLCODE为:' ||
                                         v_doc_info.billcode ||
                                         '的资金接口数据支付成功',
                          p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                          p_ref_field => 'INFO_ID',
                          p_ref_id    => v_doc_info.info_id,
                          p_user_id   => -1);
  
    /*************************************************
    -- Author  : MOUSE
    -- Created : 2015/12/4 11:00:24
    -- Ver     : 1.1
    -- Purpose : 资金系统说只需要公司代码与银行账号进行匹配，无需银行户名匹配
    **************************************************/
    SELECT a.bank_account_id
      INTO v_bank_account_id
      FROM csh_bank_accounts_vl a, fnd_companies fc
     WHERE a.bank_account_num = v_pay_interface.payaccountno
          --and a.bank_account_name = v_pay_interface.payaccountname
       AND fc.company_code = v_pay_interface.payorgcode
       AND fc.company_id = a.company_id
       AND a.enabled_flag = 'Y';
  
    csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                          p_log_desc  => '资金回传的付款账号为:' ||
                                         v_pay_interface.payaccountno ||
                                         ',付款公司为:' ||
                                         v_pay_interface.payorgcode,
                          p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                          p_ref_field => 'INFO_ID',
                          p_ref_id    => v_doc_info.info_id,
                          p_user_id   => -1);
  
    IF v_doc_info.document_category = 'EXP_REPORT' THEN
    
      csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                            p_log_desc  => '该笔支付为报销单支付',
                            p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                            p_ref_field => 'INFO_ID',
                            p_ref_id    => v_doc_info.info_id,
                            p_user_id   => -1);
    
      SELECT *
        INTO v_exp_pmt_line
        FROM exp_report_pmt_schedules s
       WHERE s.payment_schedule_line_id = v_doc_info.document_line_id;
    
      SELECT erh.exp_report_number
        INTO v_doc_number
        FROM exp_report_headers erh
       WHERE erh.exp_report_header_id = v_exp_pmt_line.exp_report_header_id;
    
      SELECT company_id
        INTO v_company_id
        FROM fnd_companies fc
       WHERE fc.company_code = v_pay_interface.payorgcode;
    
      exp_report_payment_pkg.delete_exp_report_payment_tmp(p_session_id => v_session_id,
                                                           p_user_id    => -1);
    
      exp_report_payment_pkg.insert_exp_report_payment_tmp(p_session_id               => v_session_id,
                                                           p_payment_schedule_line_id => v_doc_info.document_line_id,
                                                           p_payment_amount           => v_pay_interface.amount,
                                                           p_user_id                  => -1);
    
      exp_report_payment_pkg.execute_exp_report_payment(p_session_id              => v_session_id,
                                                        p_company_id              => v_company_id,
                                                        p_payment_date            => trunc(SYSDATE),
                                                        p_currency_code           => 'CNY',
                                                        p_exchange_rate_type      => '',
                                                        p_exchange_rate_quotation => '',
                                                        p_exchange_rate           => 1,
                                                        p_bank_account_id         => v_bank_account_id,
                                                        p_description             => v_exp_pmt_line.description,
                                                        p_cash_flow_item_id       => v_exp_pmt_line.cash_flow_item_code,
                                                        p_payment_method_id       => v_exp_pmt_line.payment_type_id,
                                                        p_user_id                 => -1);
    
      csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                            p_log_desc  => '系统内报销单支付成功',
                            p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                            p_ref_field => 'INFO_ID',
                            p_ref_id    => v_doc_info.info_id,
                            p_user_id   => -1);
    
      --更新现金事物为支付成功状态                     
      UPDATE csh_transaction_headers h
         SET h.pay_status_desc = 0
       WHERE h.transaction_header_id =
             (SELECT l.transaction_header_id
                FROM csh_transaction_lines l
               WHERE l.transaction_line_id =
                     (SELECT MAX(wo.csh_transaction_line_id)
                        FROM csh_write_off wo
                       WHERE wo.write_off_type = 'PAYMENT_EXPENSE_REPORT'
                         AND wo.document_source = 'EXPENSE_REPORT'
                         AND wo.document_line_id =
                             v_exp_pmt_line.payment_schedule_line_id));
    
      --根据报销单ID找到对应的现金事务凭证，更新SEGMENT20为支付批次号
      UPDATE csh_transaction_accounts a
         SET a.account_segment20 = v_pay_interface.batchno
       WHERE a.transaction_line_id IN
             (SELECT wo.csh_transaction_line_id
                FROM csh_write_off wo
               WHERE wo.write_off_type = 'PAYMENT_EXPENSE_REPORT'
                 AND wo.document_source = 'EXPENSE_REPORT'
                 AND wo.document_line_id =
                     v_exp_pmt_line.payment_schedule_line_id);
    
      --根据报销单ID找到对应的ENTRY，更新SEGMENT20为支付批次号
      UPDATE gl_account_entry e
         SET e.segment20   = v_pay_interface.batchno,
             e.attribute12 = v_doc_number
       WHERE e.transaction_type = 'CSH_TRANSACTION'
         AND e.transaction_line_id IN
             (SELECT wo.csh_transaction_line_id
                FROM csh_write_off wo
               WHERE wo.write_off_type = 'PAYMENT_EXPENSE_REPORT'
                 AND wo.document_source = 'EXPENSE_REPORT'
                 AND wo.document_line_id =
                     v_exp_pmt_line.payment_schedule_line_id);
    
      --记录生成的现金事务行信息至cux_payment_doc_info表中
      UPDATE cux_payment_doc_info i
         SET i.pay_transaction_line_id =
             (SELECT MAX(wo.csh_transaction_line_id)
                FROM csh_write_off wo
               WHERE wo.write_off_type = 'PAYMENT_EXPENSE_REPORT'
                 AND wo.document_source = 'EXPENSE_REPORT'
                 AND wo.document_line_id =
                     v_exp_pmt_line.payment_schedule_line_id)
       WHERE i.info_id = v_doc_info.info_id;
    
      --更新现金事物编号至资金接口表
      UPDATE cux_payment_interface i
         SET i.pay_csh_number =
             (SELECT e.transaction_number
                FROM gl_account_entry e
               WHERE e.transaction_type = 'CSH_TRANSACTION'
                 AND e.transaction_line_id IN
                     (SELECT wo.csh_transaction_line_id
                        FROM csh_write_off wo
                       WHERE wo.write_off_type = 'PAYMENT_EXPENSE_REPORT'
                         AND wo.document_source = 'EXPENSE_REPORT'
                         AND wo.document_line_id =
                             v_exp_pmt_line.payment_schedule_line_id)
                 AND rownum = 1)
       WHERE i.id = v_doc_info.interface_id;
    
      csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                            p_log_desc  => '修改系统内凭证信息完成',
                            p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                            p_ref_field => 'INFO_ID',
                            p_ref_id    => v_doc_info.info_id,
                            p_user_id   => -1);
    
    ELSIF v_doc_info.document_category = 'PAYMENT_REQUISITION' THEN
      csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                            p_log_desc  => '该笔支付为借款单支付',
                            p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                            p_ref_field => 'INFO_ID',
                            p_ref_id    => v_doc_info.info_id,
                            p_user_id   => -1);
    
      SELECT *
        INTO v_csh_pay_req_line
        FROM csh_payment_requisition_lns l
       WHERE l.payment_requisition_line_id = v_doc_info.document_line_id;
    
      SELECT cph.requisition_number
        INTO v_doc_number
        FROM csh_payment_requisition_hds cph
       WHERE cph.payment_requisition_header_id =
             v_csh_pay_req_line.payment_requisition_header_id;
    
      SELECT company_id
        INTO v_company_id
        FROM fnd_companies fc
       WHERE fc.company_code = v_pay_interface.payorgcode;
    
      csh_payment_req_payment_pkg.delete_payment_req_payment_tmp(p_session_id => v_session_id,
                                                                 p_user_id    => -1);
    
      csh_payment_req_payment_pkg.insert_payment_req_payment_tmp(p_session_id                  => v_session_id,
                                                                 p_payment_requisition_line_id => v_csh_pay_req_line.payment_requisition_line_id,
                                                                 p_payment_amount              => v_pay_interface.amount,
                                                                 p_user_id                     => -1);
    
      csh_payment_req_payment_pkg.execute_payment_req_payment(p_session_id              => v_session_id,
                                                              p_company_id              => v_company_id,
                                                              p_payment_date            => trunc(SYSDATE),
                                                              p_currency_code           => 'CNY',
                                                              p_exchange_rate_type      => '',
                                                              p_exchange_rate_quotation => '',
                                                              p_exchange_rate           => 1,
                                                              p_bank_account_id         => v_bank_account_id,
                                                              p_description             => v_csh_pay_req_line.description,
                                                              p_cash_flow_item_id       => v_csh_pay_req_line.cash_flow_code,
                                                              p_payment_method_id       => v_csh_pay_req_line.payment_method,
                                                              p_user_id                 => -1);
    
      csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                            p_log_desc  => '系统内借款单支付成功',
                            p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                            p_ref_field => 'INFO_ID',
                            p_ref_id    => v_doc_info.info_id,
                            p_user_id   => -1);
    
      --更新现金事物为支付成功状态                     
      UPDATE csh_transaction_headers h
         SET h.pay_status_desc = 0
       WHERE h.transaction_header_id =
             (SELECT l.transaction_header_id
                FROM csh_transaction_lines l
               WHERE l.transaction_line_id =
                     (SELECT r.csh_transaction_line_id
                        FROM csh_payment_requisition_refs r,
                             csh_transaction_headers      h,
                             csh_transaction_lines        l
                       WHERE r.payment_requisition_line_id =
                             v_csh_pay_req_line.payment_requisition_line_id
                         AND r.csh_transaction_line_id =
                             l.transaction_line_id
                         AND h.transaction_header_id =
                             l.transaction_header_id
                         AND nvl(h.reversed_flag, 'N') = 'N'));
    
      --根据借款单ID找到对应的现金事务凭证，修改SEGMENT20为支付批次号
      UPDATE csh_transaction_accounts a
         SET a.account_segment20 = v_pay_interface.batchno
       WHERE a.transaction_line_id IN
             (SELECT r.csh_transaction_line_id
                FROM csh_payment_requisition_refs r
               WHERE r.payment_requisition_line_id =
                     v_csh_pay_req_line.payment_requisition_line_id);
    
      --根据借款单ID找到对应的ENTRY，修改SEGMENT20为支付批次号
      UPDATE gl_account_entry e
         SET e.segment20   = v_pay_interface.batchno,
             e.attribute12 = v_doc_number
       WHERE e.transaction_type = 'CSH_TRANSACTION'
         AND e.transaction_line_id IN
             (SELECT r.csh_transaction_line_id
                FROM csh_payment_requisition_refs r
               WHERE r.payment_requisition_line_id =
                     v_csh_pay_req_line.payment_requisition_line_id);
    
      --记录生成的现金事务行信息至cux_payment_doc_info表中
      UPDATE cux_payment_doc_info i
         SET i.pay_transaction_line_id =
             (SELECT r.csh_transaction_line_id
                FROM csh_payment_requisition_refs r,
                     csh_transaction_headers      h,
                     csh_transaction_lines        l
               WHERE r.payment_requisition_line_id =
                     v_csh_pay_req_line.payment_requisition_line_id
                 AND r.csh_transaction_line_id = l.transaction_line_id
                 AND h.transaction_header_id = l.transaction_header_id
                 AND nvl(h.reversed_flag, 'N') = 'N')
       WHERE i.info_id = v_doc_info.info_id;
    
      --更新现金事物编号至资金接口表
      UPDATE cux_payment_interface i
         SET i.pay_csh_number =
             (SELECT e.transaction_number
                FROM gl_account_entry e
               WHERE e.transaction_type = 'CSH_TRANSACTION'
                 AND e.transaction_line_id IN
                     (SELECT r.csh_transaction_line_id
                        FROM csh_payment_requisition_refs r
                       WHERE r.payment_requisition_line_id =
                             v_csh_pay_req_line.payment_requisition_line_id)
                 AND rownum = 1)
       WHERE i.id = v_doc_info.interface_id;
    
      csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                            p_log_desc  => '修改系统内凭证信息完成',
                            p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                            p_ref_field => 'INFO_ID',
                            p_ref_id    => v_doc_info.info_id,
                            p_user_id   => -1);
    ELSIF v_doc_info.document_category = 'ACP_REQUISITION' THEN
      csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                            p_log_desc  => '该笔支付为付款申请单支付',
                            p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                            p_ref_field => 'INFO_ID',
                            p_ref_id    => v_doc_info.info_id,
                            p_user_id   => -1);
    
      SELECT *
        INTO v_acp_req_line
        FROM acp_acp_requisition_lns l
       WHERE l.acp_requisition_line_id = v_doc_info.document_line_id;
    
      SELECT *
        INTO v_exp_pmt_line
        FROM exp_report_pmt_schedules s
       WHERE s.payment_schedule_line_id =
             v_acp_req_line.ref_document_line_id;
    
      SELECT company_id
        INTO v_company_id
        FROM fnd_companies fc
       WHERE fc.company_code = v_pay_interface.payorgcode;
    
      acp_payment_req_payment_pkg.delete_payment_req_payment_tmp(p_session_id => v_session_id,
                                                                 p_user_id    => -1);
    
      exp_report_payment_pkg.insert_exp_report_payment_tmp(p_session_id               => v_session_id,
                                                           p_payment_schedule_line_id => /*v_doc_info.document_line_id*/ v_exp_pmt_line.payment_schedule_line_id,
                                                           p_payment_amount           => v_pay_interface.amount,
                                                           p_user_id                  => -1);
    
      acp_payment_req_payment_pkg.insert_payment_req_payment_tmp(p_session_id              => v_session_id,
                                                                 p_acp_requisition_line_id => v_doc_info.document_line_id,
                                                                 p_payment_amount          => v_pay_interface.amount,
                                                                 p_user_id                 => -1);
    
      exp_report_payment_pkg.execute_exp_rep_pay_from_acp(p_session_id              => v_session_id,
                                                          p_acp_requisition_line_id => v_doc_info.document_line_id,
                                                          p_payment_amount          => v_pay_interface.amount,
                                                          p_company_id              => v_company_id,
                                                          p_payment_date            => trunc(SYSDATE),
                                                          p_currency_code           => 'CNY',
                                                          p_exchange_rate_type      => '',
                                                          p_exchange_rate_quotation => '',
                                                          p_exchange_rate           => 1,
                                                          p_bank_account_id         => v_bank_account_id,
                                                          p_description             => v_exp_pmt_line.description,
                                                          p_cash_flow_item_id       => v_acp_req_line.cash_flow_item_id,
                                                          p_payment_method_id       => v_acp_req_line.payment_method_id,
                                                          p_user_id                 => -1,
                                                          p_transaction_header_id   => v_transaction_header_id,
                                                          p_transaction_line_id     => v_transaction_line_id,
                                                          p_write_off_id            => v_write_off_id,
                                                          p_batch_id                => v_batch_id);
    
      csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                            p_log_desc  => '系统内付款申请单支付成功',
                            p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                            p_ref_field => 'INFO_ID',
                            p_ref_id    => v_doc_info.info_id,
                            p_user_id   => -1);
    
      --更新现金事物为支付成功状态                     
      UPDATE csh_transaction_headers h
         SET h.pay_status_desc = 0
       WHERE h.transaction_header_id =
             (SELECT l.transaction_header_id
                FROM csh_transaction_lines l
               WHERE l.transaction_line_id = v_transaction_line_id);
    
      --根据现金事务行ID找到对应的现金事务凭证，更新SEGMENT20为支付批次号
      UPDATE csh_transaction_accounts a
         SET a.account_segment20 = v_pay_interface.batchno
       WHERE a.transaction_line_id = v_transaction_line_id;
    
      --根据现金事务行ID找到对应的ENTRY，更新SEGMENT20为支付批次号
      UPDATE gl_account_entry e
         SET e.segment20 = v_pay_interface.batchno
       WHERE e.transaction_type = 'CSH_TRANSACTION'
         AND e.transaction_line_id = v_transaction_line_id;
    
      --记录生成的现金事务行信息至cux_payment_doc_info表中
      UPDATE cux_payment_doc_info i
         SET i.pay_transaction_line_id = v_transaction_line_id
       WHERE i.info_id = v_doc_info.info_id;
    
      --更新现金事物编号至资金接口表
      UPDATE cux_payment_interface i
         SET i.pay_csh_number =
             (SELECT e.transaction_number
                FROM gl_account_entry e
               WHERE e.transaction_type = 'CSH_TRANSACTION'
                 AND e.transaction_line_id = v_transaction_line_id
                 AND rownum = 1)
       WHERE i.id = v_doc_info.interface_id;
    
      csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                            p_log_desc  => '修改系统内凭证信息完成',
                            p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                            p_ref_field => 'INFO_ID',
                            p_ref_id    => v_doc_info.info_id,
                            p_user_id   => -1);
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_error,
                            p_log_desc  => '支付成功处理出现异常，异常信息为:' || SQLERRM ||
                                           chr(10) ||
                                           dbms_utility.format_error_backtrace,
                            p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                            p_ref_field => 'INFO_ID',
                            p_ref_id    => v_doc_info.info_id,
                            p_user_id   => -1);
    
      RAISE e_user_error;
  END pay_success;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/13 10:36:59
  -- Ver     : 1.1
  -- Purpose : 从资金系统查询支付结果
  -- In Para : 
        p_event_record_id 事件记录ID
        p_event_log_id    事件日志ID
        p_event_param     事件参数,报销单头ID
        p_user_id         用户ID
  **************************************************/
  FUNCTION query_from_zj(p_event_record_id NUMBER,
                         p_event_log_id    NUMBER,
                         p_event_param     NUMBER,
                         p_user_id         NUMBER) RETURN NUMBER IS
    v_zj_itf               cux_payment_interface%ROWTYPE;
    v_zj_refund_query_days NUMBER;
  
    e_pay_exception EXCEPTION;
  BEGIN
    csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                          p_log_desc  => '从资金系统查询支付结果',
                          p_ref_table => '',
                          p_ref_field => '',
                          p_ref_id    => NULL,
                          p_user_id   => -1);
    --锁表
    --查询费控系统内支付传送未支付成功的
    FOR paying_doc_lines IN (SELECT *
                               FROM cux_payment_doc_info i
                              WHERE i.datastatus IN ('1', '2', '3')
                             --and i.interface_id = 296
                             --and i.document_id = 131
                                FOR UPDATE NOWAIT) LOOP
      BEGIN
        --保存点，用于执行过程中出现异常，进行回滚操作
        SAVEPOINT spt01;
      
        csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                              p_log_desc  => '查询资金系统内处于已传送、已接受、接受异常的数据，当前INFO_ID为:' ||
                                             paying_doc_lines.info_id,
                              p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                              p_ref_field => 'INFO_ID',
                              p_ref_id    => paying_doc_lines.info_id,
                              p_user_id   => -1);
        SELECT *
          INTO v_zj_itf
          FROM cux_payment_interface i
         WHERE i.id = paying_doc_lines.interface_id;
        /*
        1：已保存 （费控传）
        2：引入成功（资金传）
        3：引入失败（资金传）
        4：支付撤销 （资金传）
        5：支付成功 （资金传）
        6: 退票（资金传）
        7：支付失败(资金传）*/
        IF v_zj_itf.datastatus = '2' THEN
          csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                                p_log_desc  => '当前付款状态为:2，引入成功' || ',描述为:' ||
                                               v_zj_itf.errdescription,
                                p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                                p_ref_field => 'INFO_ID',
                                p_ref_id    => paying_doc_lines.info_id,
                                p_user_id   => -1);
        
          --引入成功状态，修改本地接口表信息
          IF paying_doc_lines.datastatus = '1' THEN
            csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                                  p_log_desc  => '原单据状态为:1，已传送，修改cux_payment_doc_info表里的状态信息',
                                  p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                                  p_ref_field => 'INFO_ID',
                                  p_ref_id    => paying_doc_lines.info_id,
                                  p_user_id   => -1);
            --原状态为已保存
            UPDATE cux_payment_doc_info di
               SET di.zj_import_date = SYSDATE,
                   di.datastatus     = '2',
                   di.zj_error_msg   = '资金引入成功，结果为：' ||
                                       v_zj_itf.errdescription
             WHERE di.interface_id = paying_doc_lines.interface_id;
          END IF;
        
          /*update cux_payment_interface i
            set i.id                = v_zj_itf.id,
                i.datasource        = v_zj_itf.datasource,
                i.inputdate         = v_zj_itf.inputdate,
                i.batchno           = v_zj_itf.batchno,
                i.settlermentdate   = v_zj_itf.settlermentdate,
                i.transferdate      = v_zj_itf.transferdate,
                i.orgcode           = v_zj_itf.orgcode,
                i.transfercode      = v_zj_itf.transfercode,
                i.paytype           = v_zj_itf.paytype,
                i.abstracts         = v_zj_itf.abstracts,
                i.payorgcode        = v_zj_itf.payorgcode,
                i.payorgname        = v_zj_itf.payorgname,
                i.payaccountno      = v_zj_itf.payaccountno,
                i.payaccountname    = v_zj_itf.payaccountname,
                i.paybankname       = v_zj_itf.paybankname,
                i.payprovince       = v_zj_itf.payprovince,
                i.payareanameofcity = v_zj_itf.payareanameofcity,
                i.recorgcode        = v_zj_itf.recorgcode,
                i.recorgname        = v_zj_itf.recorgname,
                i.recaccountno      = v_zj_itf.recaccountno,
                i.recaccountname    = v_zj_itf.recaccountname,
                i.recbankname       = v_zj_itf.recbankname,
                i.recprovince       = v_zj_itf.recprovince,
                i.recareanameofcity = v_zj_itf.recareanameofcity,
                i.bankcodeofrec     = v_zj_itf.bankcodeofrec,
                i.bankexccodeofrec  = v_zj_itf.bankexccodeofrec,
                i.cnapsofrec        = v_zj_itf.cnapsofrec,
                i.paymentno         = v_zj_itf.paymentno,
                i.agreementno       = v_zj_itf.agreementno,
                i.bankpaytype       = v_zj_itf.bankpaytype,
                i.currencycode      = v_zj_itf.currencycode,
                i.amount            = v_zj_itf.amount,
                i.datastatus        = v_zj_itf.datastatus,
                i.result            = v_zj_itf.result,
                i.isread            = v_zj_itf.isread,
                i.isreturn          = v_zj_itf.isreturn,
                i.bankerrcode       = v_zj_itf.bankerrcode,
                i.bankerrdesc       = v_zj_itf.bankerrdesc,
                i.errcode           = v_zj_itf.errcode,
                i.errdescription    = v_zj_itf.errdescription,
                i.transferid        = v_zj_itf.transferid,
                i.instructionid     = v_zj_itf.instructionid,
                i.free1             = v_zj_itf.free1,
                i.free2             = v_zj_itf.free2
          where i.id = paying_doc_lines.interface_id;*/
        
        ELSIF v_zj_itf.datastatus = '3' THEN
        
          csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                                p_log_desc  => '当前付款状态为:3，资金支付失败' || ',描述为:' ||
                                               v_zj_itf.errdescription,
                                p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                                p_ref_field => 'INFO_ID',
                                p_ref_id    => paying_doc_lines.info_id,
                                p_user_id   => -1);
        
          --引入失败状态，修改
          UPDATE cux_payment_doc_info di
             SET di.zj_import_date = nvl(di.zj_import_date, SYSDATE),
                 di.zj_deal_date   = SYSDATE,
                 di.datastatus     = '3',
                 di.zj_error_msg   = '资金支付失败，错误消息为：' ||
                                     v_zj_itf.errdescription
           WHERE di.interface_id = paying_doc_lines.interface_id;
        
          /*update cux_payment_interface i
            set i.billcode          = v_zj_itf.billcode,
                i.datasource        = v_zj_itf.datasource,
                i.inputdate         = v_zj_itf.inputdate,
                i.batchno           = v_zj_itf.batchno,
                i.settlermentdate   = v_zj_itf.settlermentdate,
                i.transferdate      = v_zj_itf.transferdate,
                i.orgcode           = v_zj_itf.orgcode,
                i.transfercode      = v_zj_itf.transfercode,
                i.paytype           = v_zj_itf.paytype,
                i.abstracts         = v_zj_itf.abstracts,
                i.payorgcode        = v_zj_itf.payorgcode,
                i.payorgname        = v_zj_itf.payorgname,
                i.payaccountno      = v_zj_itf.payaccountno,
                i.payaccountname    = v_zj_itf.payaccountname,
                i.paybankname       = v_zj_itf.paybankname,
                i.payprovince       = v_zj_itf.payprovince,
                i.payareanameofcity = v_zj_itf.payareanameofcity,
                i.recorgcode        = v_zj_itf.recorgcode,
                i.recorgname        = v_zj_itf.recorgname,
                i.recaccountno      = v_zj_itf.recaccountno,
                i.recaccountname    = v_zj_itf.recaccountname,
                i.recbankname       = v_zj_itf.recbankname,
                i.recprovince       = v_zj_itf.recprovince,
                i.recareanameofcity = v_zj_itf.recareanameofcity,
                i.bankcodeofrec     = v_zj_itf.bankcodeofrec,
                i.bankexccodeofrec  = v_zj_itf.bankexccodeofrec,
                i.cnapsofrec        = v_zj_itf.cnapsofrec,
                i.paymentno         = v_zj_itf.paymentno,
                i.agreementno       = v_zj_itf.agreementno,
                i.bankpaytype       = v_zj_itf.bankpaytype,
                i.currencycode      = v_zj_itf.currencycode,
                i.amount            = v_zj_itf.amount,
                i.datastatus        = v_zj_itf.datastatus,
                i.result            = v_zj_itf.result,
                i.isread            = v_zj_itf.isread,
                i.isreturn          = v_zj_itf.isreturn,
                i.bankerrcode       = v_zj_itf.bankerrcode,
                i.bankerrdesc       = v_zj_itf.bankerrdesc,
                i.errcode           = v_zj_itf.errcode,
                i.errdescription    = v_zj_itf.errdescription,
                i.transferid        = v_zj_itf.transferid,
                i.instructionid     = v_zj_itf.instructionid,
                i.free1             = v_zj_itf.free1,
                i.free2             = v_zj_itf.free2
          where i.id = paying_doc_lines.interface_id;*/
        ELSIF v_zj_itf.datastatus = '4' THEN
          csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                                p_log_desc  => '当前付款状态为:4，支付撤销' || ',描述为:' ||
                                               v_zj_itf.errdescription,
                                p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                                p_ref_field => 'INFO_ID',
                                p_ref_id    => paying_doc_lines.info_id,
                                p_user_id   => -1);
        
          --支付撤销状态，修改
          UPDATE cux_payment_doc_info di
             SET di.zj_import_date = nvl(di.zj_import_date, SYSDATE),
                 di.zj_deal_date   = SYSDATE,
                 di.datastatus     = '4',
                 di.zj_error_msg   = '资金支付撤销，撤销原因为：' ||
                                     v_zj_itf.errdescription
           WHERE di.interface_id = paying_doc_lines.interface_id;
        
          /*update cux_payment_interface i
            set i.billcode          = v_zj_itf.billcode,
                i.datasource        = v_zj_itf.datasource,
                i.inputdate         = v_zj_itf.inputdate,
                i.batchno           = v_zj_itf.batchno,
                i.settlermentdate   = v_zj_itf.settlermentdate,
                i.transferdate      = v_zj_itf.transferdate,
                i.orgcode           = v_zj_itf.orgcode,
                i.transfercode      = v_zj_itf.transfercode,
                i.paytype           = v_zj_itf.paytype,
                i.abstracts         = v_zj_itf.abstracts,
                i.payorgcode        = v_zj_itf.payorgcode,
                i.payorgname        = v_zj_itf.payorgname,
                i.payaccountno      = v_zj_itf.payaccountno,
                i.payaccountname    = v_zj_itf.payaccountname,
                i.paybankname       = v_zj_itf.paybankname,
                i.payprovince       = v_zj_itf.payprovince,
                i.payareanameofcity = v_zj_itf.payareanameofcity,
                i.recorgcode        = v_zj_itf.recorgcode,
                i.recorgname        = v_zj_itf.recorgname,
                i.recaccountno      = v_zj_itf.recaccountno,
                i.recaccountname    = v_zj_itf.recaccountname,
                i.recbankname       = v_zj_itf.recbankname,
                i.recprovince       = v_zj_itf.recprovince,
                i.recareanameofcity = v_zj_itf.recareanameofcity,
                i.bankcodeofrec     = v_zj_itf.bankcodeofrec,
                i.bankexccodeofrec  = v_zj_itf.bankexccodeofrec,
                i.cnapsofrec        = v_zj_itf.cnapsofrec,
                i.paymentno         = v_zj_itf.paymentno,
                i.agreementno       = v_zj_itf.agreementno,
                i.bankpaytype       = v_zj_itf.bankpaytype,
                i.currencycode      = v_zj_itf.currencycode,
                i.amount            = v_zj_itf.amount,
                i.datastatus        = v_zj_itf.datastatus,
                i.result            = v_zj_itf.result,
                i.isread            = v_zj_itf.isread,
                i.isreturn          = v_zj_itf.isreturn,
                i.bankerrcode       = v_zj_itf.bankerrcode,
                i.bankerrdesc       = v_zj_itf.bankerrdesc,
                i.errcode           = v_zj_itf.errcode,
                i.errdescription    = v_zj_itf.errdescription,
                i.transferid        = v_zj_itf.transferid,
                i.instructionid     = v_zj_itf.instructionid,
                i.free1             = v_zj_itf.free1,
                i.free2             = v_zj_itf.free2
          where i.id = paying_doc_lines.interface_id;*/
        ELSIF v_zj_itf.datastatus = '7' THEN
          csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                                p_log_desc  => '当前付款状态为:7，支付撤销' || ',描述为:' ||
                                               v_zj_itf.errdescription,
                                p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                                p_ref_field => 'INFO_ID',
                                p_ref_id    => paying_doc_lines.info_id,
                                p_user_id   => -1);
        
          --支付失败状态，修改
          UPDATE cux_payment_doc_info di
             SET di.zj_import_date = nvl(di.zj_import_date, SYSDATE),
                 di.zj_deal_date   = SYSDATE,
                 di.datastatus     = '7',
                 di.zj_error_msg   = '资金支付失败，失败原因为：' ||
                                     v_zj_itf.errdescription
           WHERE di.interface_id = paying_doc_lines.interface_id;
        
          /*update cux_payment_interface i
            set i.billcode          = v_zj_itf.billcode,
                i.datasource        = v_zj_itf.datasource,
                i.inputdate         = v_zj_itf.inputdate,
                i.batchno           = v_zj_itf.batchno,
                i.settlermentdate   = v_zj_itf.settlermentdate,
                i.transferdate      = v_zj_itf.transferdate,
                i.orgcode           = v_zj_itf.orgcode,
                i.transfercode      = v_zj_itf.transfercode,
                i.paytype           = v_zj_itf.paytype,
                i.abstracts         = v_zj_itf.abstracts,
                i.payorgcode        = v_zj_itf.payorgcode,
                i.payorgname        = v_zj_itf.payorgname,
                i.payaccountno      = v_zj_itf.payaccountno,
                i.payaccountname    = v_zj_itf.payaccountname,
                i.paybankname       = v_zj_itf.paybankname,
                i.payprovince       = v_zj_itf.payprovince,
                i.payareanameofcity = v_zj_itf.payareanameofcity,
                i.recorgcode        = v_zj_itf.recorgcode,
                i.recorgname        = v_zj_itf.recorgname,
                i.recaccountno      = v_zj_itf.recaccountno,
                i.recaccountname    = v_zj_itf.recaccountname,
                i.recbankname       = v_zj_itf.recbankname,
                i.recprovince       = v_zj_itf.recprovince,
                i.recareanameofcity = v_zj_itf.recareanameofcity,
                i.bankcodeofrec     = v_zj_itf.bankcodeofrec,
                i.bankexccodeofrec  = v_zj_itf.bankexccodeofrec,
                i.cnapsofrec        = v_zj_itf.cnapsofrec,
                i.paymentno         = v_zj_itf.paymentno,
                i.agreementno       = v_zj_itf.agreementno,
                i.bankpaytype       = v_zj_itf.bankpaytype,
                i.currencycode      = v_zj_itf.currencycode,
                i.amount            = v_zj_itf.amount,
                i.datastatus        = v_zj_itf.datastatus,
                i.result            = v_zj_itf.result,
                i.isread            = v_zj_itf.isread,
                i.isreturn          = v_zj_itf.isreturn,
                i.bankerrcode       = v_zj_itf.bankerrcode,
                i.bankerrdesc       = v_zj_itf.bankerrdesc,
                i.errcode           = v_zj_itf.errcode,
                i.errdescription    = v_zj_itf.errdescription,
                i.transferid        = v_zj_itf.transferid,
                i.instructionid     = v_zj_itf.instructionid,
                i.free1             = v_zj_itf.free1,
                i.free2             = v_zj_itf.free2
          where i.id = paying_doc_lines.interface_id;*/
        ELSIF v_zj_itf.datastatus = '5' THEN
          csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                                p_log_desc  => '当前付款状态为:5，支付成功' || ',描述为:' ||
                                               v_zj_itf.errdescription,
                                p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                                p_ref_field => 'INFO_ID',
                                p_ref_id    => paying_doc_lines.info_id,
                                p_user_id   => -1);
        
          --支付成功状态，修改
          UPDATE cux_payment_doc_info di
             SET di.zj_import_date = nvl(di.zj_import_date, SYSDATE),
                 di.zj_deal_date   = SYSDATE,
                 di.bank_pay_date  = v_zj_itf.settlermentdate,
                 di.datastatus     = '5',
                 di.zj_error_msg   = '资金支付成功，结果为：' ||
                                     v_zj_itf.errdescription
           WHERE di.interface_id = paying_doc_lines.interface_id;
        
          /*update cux_payment_interface i
            set i.billcode          = v_zj_itf.billcode,
                i.datasource        = v_zj_itf.datasource,
                i.inputdate         = v_zj_itf.inputdate,
                i.batchno           = v_zj_itf.batchno,
                i.settlermentdate   = v_zj_itf.settlermentdate,
                i.transferdate      = v_zj_itf.transferdate,
                i.orgcode           = v_zj_itf.orgcode,
                i.transfercode      = v_zj_itf.transfercode,
                i.paytype           = v_zj_itf.paytype,
                i.abstracts         = v_zj_itf.abstracts,
                i.payorgcode        = v_zj_itf.payorgcode,
                i.payorgname        = v_zj_itf.payorgname,
                i.payaccountno      = v_zj_itf.payaccountno,
                i.payaccountname    = v_zj_itf.payaccountname,
                i.paybankname       = v_zj_itf.paybankname,
                i.payprovince       = v_zj_itf.payprovince,
                i.payareanameofcity = v_zj_itf.payareanameofcity,
                i.recorgcode        = v_zj_itf.recorgcode,
                i.recorgname        = v_zj_itf.recorgname,
                i.recaccountno      = v_zj_itf.recaccountno,
                i.recaccountname    = v_zj_itf.recaccountname,
                i.recbankname       = v_zj_itf.recbankname,
                i.recprovince       = v_zj_itf.recprovince,
                i.recareanameofcity = v_zj_itf.recareanameofcity,
                i.bankcodeofrec     = v_zj_itf.bankcodeofrec,
                i.bankexccodeofrec  = v_zj_itf.bankexccodeofrec,
                i.cnapsofrec        = v_zj_itf.cnapsofrec,
                i.paymentno         = v_zj_itf.paymentno,
                i.agreementno       = v_zj_itf.agreementno,
                i.bankpaytype       = v_zj_itf.bankpaytype,
                i.currencycode      = v_zj_itf.currencycode,
                i.amount            = v_zj_itf.amount,
                i.datastatus        = v_zj_itf.datastatus,
                i.result            = v_zj_itf.result,
                i.isread            = v_zj_itf.isread,
                i.isreturn          = v_zj_itf.isreturn,
                i.bankerrcode       = v_zj_itf.bankerrcode,
                i.bankerrdesc       = v_zj_itf.bankerrdesc,
                i.errcode           = v_zj_itf.errcode,
                i.errdescription    = v_zj_itf.errdescription,
                i.transferid        = v_zj_itf.transferid,
                i.instructionid     = v_zj_itf.instructionid,
                i.free1             = v_zj_itf.free1,
                i.free2             = v_zj_itf.free2
          where i.id = paying_doc_lines.interface_id;*/
        
          BEGIN
            pay_success(p_info_id => paying_doc_lines.info_id);
          EXCEPTION
            WHEN OTHERS THEN
              csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                                    p_log_desc  => '支付成功处理出现异常，SYS_RAISE_APP_ERROR的ID为:' ||
                                                   sys_raise_app_error_pkg.g_err_line_id,
                                    p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                                    p_ref_field => 'INFO_ID',
                                    p_ref_id    => paying_doc_lines.info_id,
                                    p_user_id   => -1);
            
              --抛出异常，进入回滚操作
              RAISE e_pay_exception;
          END;
        
        ELSIF v_zj_itf.datastatus = '6' THEN
          csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                                p_log_desc  => '当前付款状态为:6，支付退票' || ',描述为:' ||
                                               v_zj_itf.errdescription,
                                p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                                p_ref_field => 'INFO_ID',
                                p_ref_id    => paying_doc_lines.info_id,
                                p_user_id   => -1);
        
          --如果从1、2状态直接获取到6退票状态，则按照支付失败7进行处理
          UPDATE cux_payment_doc_info di
             SET di.zj_import_date = nvl(di.zj_import_date, SYSDATE),
                 di.zj_deal_date   = SYSDATE,
                 di.datastatus     = '7',
                 di.zj_error_msg   = '资金支付退票，由于未生成凭证过账，按照支付失败进行处理，失败原因为：' ||
                                     v_zj_itf.errdescription
           WHERE di.interface_id = paying_doc_lines.interface_id;
        
          /*update cux_payment_interface i
            set i.billcode          = v_zj_itf.billcode,
                i.datasource        = v_zj_itf.datasource,
                i.inputdate         = v_zj_itf.inputdate,
                i.batchno           = v_zj_itf.batchno,
                i.settlermentdate   = v_zj_itf.settlermentdate,
                i.transferdate      = v_zj_itf.transferdate,
                i.orgcode           = v_zj_itf.orgcode,
                i.transfercode      = v_zj_itf.transfercode,
                i.paytype           = v_zj_itf.paytype,
                i.abstracts         = v_zj_itf.abstracts,
                i.payorgcode        = v_zj_itf.payorgcode,
                i.payorgname        = v_zj_itf.payorgname,
                i.payaccountno      = v_zj_itf.payaccountno,
                i.payaccountname    = v_zj_itf.payaccountname,
                i.paybankname       = v_zj_itf.paybankname,
                i.payprovince       = v_zj_itf.payprovince,
                i.payareanameofcity = v_zj_itf.payareanameofcity,
                i.recorgcode        = v_zj_itf.recorgcode,
                i.recorgname        = v_zj_itf.recorgname,
                i.recaccountno      = v_zj_itf.recaccountno,
                i.recaccountname    = v_zj_itf.recaccountname,
                i.recbankname       = v_zj_itf.recbankname,
                i.recprovince       = v_zj_itf.recprovince,
                i.recareanameofcity = v_zj_itf.recareanameofcity,
                i.bankcodeofrec     = v_zj_itf.bankcodeofrec,
                i.bankexccodeofrec  = v_zj_itf.bankexccodeofrec,
                i.cnapsofrec        = v_zj_itf.cnapsofrec,
                i.paymentno         = v_zj_itf.paymentno,
                i.agreementno       = v_zj_itf.agreementno,
                i.bankpaytype       = v_zj_itf.bankpaytype,
                i.currencycode      = v_zj_itf.currencycode,
                i.amount            = v_zj_itf.amount,
                i.datastatus        = '7',
                i.result            = v_zj_itf.result,
                i.isread            = v_zj_itf.isread,
                i.isreturn          = v_zj_itf.isreturn,
                i.bankerrcode       = v_zj_itf.bankerrcode,
                i.bankerrdesc       = v_zj_itf.bankerrdesc,
                i.errcode           = v_zj_itf.errcode,
                i.errdescription    = v_zj_itf.errdescription,
                i.transferid        = v_zj_itf.transferid,
                i.instructionid     = v_zj_itf.instructionid,
                i.free1             = v_zj_itf.free1,
                i.free2             = v_zj_itf.free2
          where i.id = paying_doc_lines.interface_id;*/
        END IF;
      
      EXCEPTION
        WHEN e_pay_exception THEN
          ROLLBACK TO spt01;
          sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '支付处理出现异常，回滚本条记录修改，具体错误信息请查看资金接口日志',
                                                         p_created_by              => -1,
                                                         p_package_name            => 'cux_payment_pkg',
                                                         p_procedure_function_name => 'query_from_zj');
        WHEN OTHERS THEN
          ROLLBACK TO spt01;
          sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => SQLERRM ||
                                                                                      chr(10) ||
                                                                                      dbms_utility.format_error_backtrace,
                                                         p_created_by              => -1,
                                                         p_package_name            => 'cux_payment_pkg',
                                                         p_procedure_function_name => 'query_from_zj');
      END;
    END LOOP;
  
    v_zj_refund_query_days := sys_parameter_pkg.value(p_parameter_code => 'ZJ_REFUND_QUERY_DAYS');
    --查询费控系统内数日之内查询成功的，去资金系统接口表查询是否被退票
    FOR paying_doc_lines IN (SELECT *
                               FROM cux_payment_doc_info i
                              WHERE i.datastatus = '5'
                                AND i.zj_deal_date >
                                    trunc(SYSDATE - v_zj_refund_query_days)
                                FOR UPDATE NOWAIT) LOOP
      BEGIN
        --保存点，用于执行过程中出现异常，进行回滚操作
        SAVEPOINT spt02;
      
        --找到对应单据在资金系统接口表的数据，并且状态为退票中的
        SELECT *
          INTO v_zj_itf
          FROM cux_payment_interface i
         WHERE i.billcode = paying_doc_lines.billcode
           AND i.datastatus = '6';
      
        csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                              p_log_desc  => '当前付款状态为:6，支付退票，原来的付款状态为:5，' ||
                                             ',描述为:' ||
                                             v_zj_itf.errdescription,
                              p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                              p_ref_field => 'INFO_ID',
                              p_ref_id    => paying_doc_lines.info_id,
                              p_user_id   => -1);
      
        --支付退票状态，修改
        UPDATE cux_payment_doc_info di
           SET di.zj_import_date = nvl(di.zj_import_date, SYSDATE),
               di.zj_deal_date   = nvl(di.zj_deal_date, SYSDATE),
               di.zj_refund_date = SYSDATE,
               di.bank_pay_date  = v_zj_itf.settlermentdate,
               di.datastatus     = '6',
               di.zj_error_msg   = '资金退票，退票原因为：' || v_zj_itf.errdescription
         WHERE di.interface_id = paying_doc_lines.interface_id;
      
        /*update cux_payment_interface i
          set i.billcode          = v_zj_itf.billcode,
              i.datasource        = v_zj_itf.datasource,
              i.inputdate         = v_zj_itf.inputdate,
              i.batchno           = v_zj_itf.batchno,
              i.settlermentdate   = v_zj_itf.settlermentdate,
              i.transferdate      = v_zj_itf.transferdate,
              i.orgcode           = v_zj_itf.orgcode,
              i.transfercode      = v_zj_itf.transfercode,
              i.paytype           = v_zj_itf.paytype,
              i.abstracts         = v_zj_itf.abstracts,
              i.payorgcode        = v_zj_itf.payorgcode,
              i.payorgname        = v_zj_itf.payorgname,
              i.payaccountno      = v_zj_itf.payaccountno,
              i.payaccountname    = v_zj_itf.payaccountname,
              i.paybankname       = v_zj_itf.paybankname,
              i.payprovince       = v_zj_itf.payprovince,
              i.payareanameofcity = v_zj_itf.payareanameofcity,
              i.recorgcode        = v_zj_itf.recorgcode,
              i.recorgname        = v_zj_itf.recorgname,
              i.recaccountno      = v_zj_itf.recaccountno,
              i.recaccountname    = v_zj_itf.recaccountname,
              i.recbankname       = v_zj_itf.recbankname,
              i.recprovince       = v_zj_itf.recprovince,
              i.recareanameofcity = v_zj_itf.recareanameofcity,
              i.bankcodeofrec     = v_zj_itf.bankcodeofrec,
              i.bankexccodeofrec  = v_zj_itf.bankexccodeofrec,
              i.cnapsofrec        = v_zj_itf.cnapsofrec,
              i.paymentno         = v_zj_itf.paymentno,
              i.agreementno       = v_zj_itf.agreementno,
              i.bankpaytype       = v_zj_itf.bankpaytype,
              i.currencycode      = v_zj_itf.currencycode,
              i.amount            = v_zj_itf.amount,
              i.datastatus        = v_zj_itf.datastatus,
              i.result            = v_zj_itf.result,
              i.isread            = v_zj_itf.isread,
              i.isreturn          = v_zj_itf.isreturn,
              i.bankerrcode       = v_zj_itf.bankerrcode,
              i.bankerrdesc       = v_zj_itf.bankerrdesc,
              i.errcode           = v_zj_itf.errcode,
              i.errdescription    = v_zj_itf.errdescription,
              i.transferid        = v_zj_itf.transferid,
              i.instructionid     = v_zj_itf.instructionid,
              i.free1             = v_zj_itf.free1,
              i.free2             = v_zj_itf.free2
        where i.id = paying_doc_lines.interface_id;*/
      
      EXCEPTION
        WHEN no_data_found THEN
          --如果无法找到对应的数据，说明该单据不在退票中，不进行处理
          NULL;
        WHEN OTHERS THEN
          --如果抛出其他错误，记录错误信息，并回滚本次执行
          csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_debug,
                                p_log_desc  => '退票处理过程出现异常，异常信息为:' ||
                                               SQLERRM || chr(10) ||
                                               dbms_utility.format_error_backtrace,
                                p_ref_table => 'CUX_PAYMENT_DOC_INFO',
                                p_ref_field => 'INFO_ID',
                                p_ref_id    => paying_doc_lines.info_id,
                                p_user_id   => -1);
        
          ROLLBACK TO spt02;
      END;
    END LOOP;
  
    COMMIT;
    RETURN 1;
  END query_from_zj;

  /*************************************************
  -- Author  : HM
  -- Created : 2016/11/29 17:32:52
  -- Purpose : 资金结果通知回写程序
  **************************************************/
  PROCEDURE rewrite_zj_result(p_record IN OUT zj_result_record) IS
    e_pay_exception       EXCEPTION;
    e_returned_error      EXCEPTION;
    e_return_trans_error  EXCEPTION;
    e_reversed_error      EXCEPTION;
    e_reverse_trans_error EXCEPTION;
    e_pay_doc_not_exists  EXCEPTION;
    v_error_msg  VARCHAR(4000);
    v_pay_state  VARCHAR2(10);
    v_req_number NUMBER := 0;
    v_post_flag  VARCHAR2(1);
  BEGIN
    v_req_number := 0;
    IF p_record.transcode = c_pay_re_code THEN
      --转化支付状态
      SELECT decode(p_record.transstate, '2', '4', '3', '3', '6', '5')
        INTO v_pay_state
        FROM dual;
    
      FOR c_itf IN (SELECT t.urid,
                           t.serialnumber,
                           t.hec_status,
                           t.source_notecode,
                           t.origin_note
                      FROM jx_ats_pay_trans_interface t
                     WHERE t.serialnumber = p_record.reqseqid) LOOP
        v_req_number := v_req_number + 1;
      
        --如果费控状态和资金通知状态不一样则修改状态
        IF v_pay_state <> c_itf.hec_status THEN
        
          --自治事务，更新资金支付结果
          update_pay_gather_message(p_interface_id => c_itf.urid,
                                    p_record       => p_record);
        
        END IF;
      
      END LOOP;
    ELSIF p_record.transcode = c_gather_re_code THEN
      NULL;
    ELSE
      csh_ebank_log_pkg.log(p_level           => csh_ebank_log_pkg.c_log_level_error,
                            p_log_desc        => '无法解析当前交易类型！交易类型为:Transcode:' ||
                                                 p_record.transcode,
                            p_ref_table       => '',
                            p_ref_field       => '',
                            p_ref_id          => '',
                            p_user_id         => -1,
                            p_document_number => p_record.reqreserved3);
    END IF;
  
    IF v_req_number = 0 THEN
      p_record.rtncode := 'fail';
      p_record.rtnmsg  := '费控系统无该笔流水号';
    END IF;
  
  EXCEPTION
    WHEN e_bank_account_not_found_error THEN
      p_record.rtncode := 'exception';
      p_record.rtnmsg  := '资金结果回写发生错误：找到付款银行账户，请在费控中维护好银行账户后再进行回写！';
      RETURN;
    WHEN OTHERS THEN
    
      p_record.rtncode := 'exception';
      p_record.rtnmsg  := SQLERRM || dbms_utility.format_error_backtrace;
      v_error_msg      := SQLERRM || dbms_utility.format_error_backtrace;
    
      UPDATE jx_ats_pay_trans_interface japti
         SET japti.error_message = v_error_msg
       WHERE japti.serialnumber = p_record.reqseqid;
    
  END rewrite_zj_result;

  /*************************************************
  -- Author  : HM
  -- Created : 2016/11/24 16:24:44
  -- Purpose : 资金结果通知WS服务端程序
  **************************************************/
  PROCEDURE ws_get_result_zj(p_input_xml  IN OUT CLOB,
                             p_output_xml OUT VARCHAR2,
                             p_success    OUT VARCHAR2) IS
    v_input_xml     sys.xmltype;
    v_output_xml    VARCHAR2(6000);
    v_rtnseq        VARCHAR2(30);
    v_success       VARCHAR2(10);
    v_node_pub      sys.xmlsequencetype;
    v_node_out      sys.xmlsequencetype;
    v_result_record zj_result_record;
  BEGIN
    /*csh_ebank_log_pkg.log(p_level     => csh_ebank_log_pkg.c_log_level_info,
    p_log_desc  => '资金结果通知WS服务-接收，接收初始报文为:' ||
                   p_input_xml,
    p_ref_table => '',
    p_ref_field => '',
    p_ref_id    => null,
    p_user_id   => -1);*/
  
    v_input_xml := xmltype(p_input_xml);
  
    SELECT substr(extractvalue(v_input_xml, '/ATS/PUB/TransSource'), 1, 10),
           substr(extractvalue(v_input_xml, '/ATS/PUB/TransCode'), 1, 100),
           substr(extractvalue(v_input_xml, '/ATS/PUB/TransDate'), 1, 30),
           substr(extractvalue(v_input_xml, '/ATS/PUB/TransTime'), 1, 30),
           substr(extractvalue(v_input_xml, '/ATS/PUB/TransSeq'), 1, 100),
           c_return_success,
           '通知成功'
      INTO v_result_record.transsource,
           v_result_record.transcode,
           v_result_record.transdate,
           v_result_record.transtime,
           v_result_record.transseq,
           v_result_record.rtncode,
           v_result_record.rtnmsg
      FROM dual;
  
    FOR c_result IN (SELECT substr(extractvalue(t.column_value,
                                                '/RD/ReqSeqID'),
                                   1,
                                   30) reqseqid,
                            substr(extractvalue(t.column_value, '/RD/RdSeq'),
                                   1,
                                   30) rdseq,
                            substr(extractvalue(t.column_value,
                                                '/RD/BeginDate'),
                                   1,
                                   10) begindate,
                            substr(extractvalue(t.column_value,
                                                '/RD/CorpAct'),
                                   1,
                                   100) corpact,
                            substr(extractvalue(t.column_value,
                                                '/RD/CorpEntity'),
                                   1,
                                   100) corpentity,
                            substr(extractvalue(t.column_value,
                                                '/RD/CorpBank'),
                                   1,
                                   100) corpbank,
                            substr(extractvalue(t.column_value, '/RD/OppAct'),
                                   1,
                                   100) oppact,
                            substr(extractvalue(t.column_value,
                                                '/RD/TransState'),
                                   1,
                                   10) transstate,
                            substr(extractvalue(t.column_value,
                                                '/RD/PayInfoCode'),
                                   1,
                                   30) payinfocode,
                            substr(extractvalue(t.column_value,
                                                '/RD/PayInfo'),
                                   1,
                                   300) payinfo,
                            substr(extractvalue(t.column_value,
                                                '/RD/FailType'),
                                   1,
                                   10) failtype,
                            substr(extractvalue(t.column_value,
                                                '/RD/PayMadeDate'),
                                   1,
                                   30) paymadedate,
                            substr(extractvalue(t.column_value,
                                                '/RD/Abstract'),
                                   1,
                                   30) abstract,
                            substr(extractvalue(t.column_value,
                                                '/RD/ReqReserved3'),
                                   1,
                                   100) reqreserved3,
                            substr(extractvalue(t.column_value,
                                                '/RD/ReqReserved4'),
                                   1,
                                   100) reqreserved4
                       FROM TABLE(xmlsequence(v_input_xml.extract('/ATS/IN/RD'))) t) LOOP
    
      SELECT c_result.reqseqid,
             c_result.rdseq,
             c_result.begindate,
             c_result.corpact,
             c_result.corpentity,
             c_result.corpbank,
             c_result.oppact,
             c_result.transstate,
             c_result.payinfocode,
             c_result.payinfo,
             c_result.failtype,
             to_char(to_date(substr(c_result.paymadedate, 0, 8),
                             'yyyy-mm-dd'),
                     'yyyy-mm-dd'), --paymadedate
             c_result.abstract,
             c_result.reqreserved3,
             c_result.reqreserved4
        INTO v_result_record.reqseqid,
             v_result_record.rdseq,
             v_result_record.begindate,
             v_result_record.corpact,
             v_result_record.corpentity,
             v_result_record.corpbank,
             v_result_record.oppact,
             v_result_record.transstate,
             v_result_record.payinfocode,
             v_result_record.payinfo,
             v_result_record.failtype,
             v_result_record.paymadedate,
             v_result_record.abstract,
             v_result_record.reqreserved3, --业务单据号
             v_result_record.reqreserved4 --交易类型 1：单笔 2：批量
        FROM dual;
    
      --获取单据业务号  
      csh_ebank_log_pkg.log(p_level           => csh_ebank_log_pkg.c_log_level_info,
                            p_log_desc        => '资金结果通知WS服务-接收，接收报文为:' ||
                                                 p_input_xml,
                            p_ref_table       => '',
                            p_ref_field       => '',
                            p_ref_id          => NULL,
                            p_user_id         => -1,
                            p_document_number => v_result_record.reqreserved3);
    
      /*回写记录*/
      rewrite_zj_result(v_result_record);
      IF v_result_record.rtncode <> 'success' THEN
        EXIT;
      END IF;
    END LOOP;
  
    --回传流水
    SELECT to_char(SYSDATE, 'yyyymmddhh24miss') INTO v_rtnseq FROM dual;
    v_rtnseq := 'HEC' || v_rtnseq;
    --获取返回节点序列
    SELECT xmlsequencetype(xmlelement("TransSource",
                                      v_result_record.transsource),
                           xmlelement("TransCode", v_result_record.transcode),
                           xmlelement("TransDate", v_result_record.transdate),
                           xmlelement("TransTime", v_result_record.transtime),
                           xmlelement("TransSeq", v_result_record.transseq),
                           xmlelement("RtnSeq", v_rtnseq), --回传流水号
                           xmlelement("RtnCode", v_result_record.rtncode),
                           xmlelement("RtnMsg", v_result_record.rtnmsg)),
           xmlsequencetype(xmlelement("ReqSeqID", v_result_record.reqseqid),
                           xmlelement("ReqReserved1", ''),
                           xmlelement("ReqReserved2", ''))
      INTO v_node_pub, v_node_out
      FROM dual;
  
    --节点拼接
    SELECT '<?xml version="1.0" encoding="utf-8"?>' || xmlelement("ATS", xmlelement("PUB", xmlconcat(v_node_pub)), xmlelement("OUT", xmlconcat(v_node_out)))
           .getstringval()
      INTO v_output_xml
      FROM dual;
  
    --转义字符处理
    v_output_xml := REPLACE(v_output_xml, '&lt;', '<');
    v_output_xml := REPLACE(v_output_xml, '&gt;', '>');
  
    csh_ebank_log_pkg.log(p_level           => csh_ebank_log_pkg.c_log_level_info,
                          p_log_desc        => substr('资金结果通知WS服务-返回，返回报文为:' ||
                                                      v_output_xml,
                                                      1,
                                                      4000),
                          p_ref_table       => '',
                          p_ref_field       => '',
                          p_ref_id          => NULL,
                          p_user_id         => -1,
                          p_document_number => v_result_record.reqreserved3);
  
    p_output_xml := v_output_xml;
    p_input_xml  := '1';
    p_success    := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      p_input_xml := '0';
      p_success   := 'NOK';
  END ws_get_result_zj;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/26 14:18:34
  -- Ver     : 1.1
  -- Purpose : 确认并重传资金接口
  **************************************************/
  PROCEDURE confirm_resend_to_zj(p_info_id NUMBER, p_user_id NUMBER) IS
    v_payment_doc_info cux_payment_doc_info%ROWTYPE;
    v_document_line_id NUMBER;
    v_document_head_id NUMBER;
    e_pay_doc_not_exists EXCEPTION;
  BEGIN
    BEGIN
      SELECT *
        INTO v_payment_doc_info
        FROM cux_payment_doc_info i
       WHERE i.interface_id = p_info_id
         AND i.datastatus = '3';
      --FOR UPDATE NOWAIT;
    EXCEPTION
      WHEN no_data_found THEN
        RAISE e_pay_doc_not_exists;
    END;
  
    v_document_head_id := v_payment_doc_info.document_id;
    v_document_line_id := v_payment_doc_info.document_line_id;
  
    --备份失败的资金接口数据
    --backup_failed_zj_info(p_info_id => p_info_id);
  
    --重新生成资金接口数据
    IF v_payment_doc_info.document_category = 'EXP_REPORT' THEN
      /*post_exp_rep_by_pmt(p_exp_report_pmt_line_id => v_document_line_id,
      p_info_id                => v_new_info_id,
      p_user_id                => p_user_id);*/
      gr_insert_zj_interface(p_exp_report_pmt_line_id => v_document_line_id,
                             p_user_id                => p_user_id,
                             p_interface_id           => p_info_id);
    
      --发送资金
      gr_post_data_zj(p_document_id       => v_document_head_id,
                      p_document_category => 'EXP_REPORT',
                      p_user_id           => 1);
    ELSIF v_payment_doc_info.document_category = 'PAYMENT_REQUISITION' THEN
      /*post_csh_pay_req_by_ln(p_csh_payment_req_line_id => v_document_line_id,
      p_info_id                 => v_new_info_id,
      p_user_id                 => p_user_id);*/
      gr_post_csh_pay_req_by_ln(p_csh_payment_req_line_id => v_document_line_id,
                                p_user_id                 => p_user_id,
                                p_interface_id            => p_info_id);
      --发送资金
      gr_post_data_zj(p_document_id       => v_document_head_id,
                      p_document_category => 'PAYMENT_REQUISITION',
                      p_user_id           => 1);
    ELSIF v_payment_doc_info.document_category = 'ACP_REQUISITION' THEN
      /*post_acp_req_by_ln(p_acp_requisition_line_id => v_document_line_id,
      p_info_id                 => v_new_info_id,
      p_user_id                 => p_user_id);*/
      gr_post_acp_req_by_ln(p_acp_requisition_line_id => v_document_line_id,
                            p_user_id                 => p_user_id,
                            p_interface_id            => p_info_id);
      --发送资金
      gr_post_data_zj(p_document_id       => v_document_head_id,
                      p_document_category => 'ACP_REQUISITION',
                      p_user_id           => 1);
    END IF;
  
  EXCEPTION
    WHEN e_lock_table THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '当前该笔支付信息正在处理中，请勿重复处理！',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'confirm_resend_to_zj');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_pay_doc_not_exists THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '当前支付信息已经不存在或者不是支付失败或者取消状态',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'confirm_resend_to_zj');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END confirm_resend_to_zj;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/26 14:18:34
  -- Ver     : 1.1
  -- Purpose : 修改资金接口数据
  **************************************************/
  PROCEDURE update_payee_account(p_info_id        NUMBER,
                                 p_payee_category VARCHAR2,
                                 --p_payee_id             number,
                                 p_payee_account_number VARCHAR2,
                                 p_payment_method_id    NUMBER,
                                 p_gather_flag          VARCHAR2,
                                 p_user_id              NUMBER) IS
    v_payment_doc_info   cux_payment_doc_info%ROWTYPE;
    v_interface_info     cux_payment_interface%ROWTYPE;
    v_account_number     VARCHAR2(200);
    v_account_name       VARCHAR2(200);
    v_bank_code          VARCHAR2(200);
    v_bank_name          VARCHAR2(200);
    v_bank_location_code VARCHAR2(200);
    v_bank_location_name VARCHAR2(200);
    v_province_code      VARCHAR2(200);
    v_province_name      VARCHAR2(200);
    v_city_code          VARCHAR2(200);
    v_city_name          VARCHAR2(200);
    v_payee_id           NUMBER;
  
    e_payee_category_error EXCEPTION;
  BEGIN
    SELECT *
      INTO v_interface_info
      FROM cux_payment_interface i
     WHERE i.id = p_info_id
       FOR UPDATE NOWAIT;
  
    SELECT d.*
      INTO v_payment_doc_info
      FROM cux_payment_doc_info d
     WHERE d.interface_id = v_interface_info.id;
  
    IF v_payment_doc_info.document_category = 'EXP_REPORT' THEN
      SELECT s.payee_id
        INTO v_payee_id
        FROM exp_report_pmt_schedules s
       WHERE s.payment_schedule_line_id =
             v_payment_doc_info.document_line_id;
    ELSIF v_payment_doc_info.document_category = 'PAYMENT_REQUISITION' THEN
      SELECT l.partner_id
        INTO v_payee_id
        FROM csh_payment_requisition_lns l
       WHERE l.payment_requisition_line_id =
             v_payment_doc_info.document_line_id;
    ELSIF v_payment_doc_info.document_category = 'ACP_REQUISITION' THEN
      SELECT l.partner_id
        INTO v_payee_id
        FROM acp_acp_requisition_lns l
       WHERE l.acp_requisition_line_id =
             v_payment_doc_info.document_line_id;
    END IF;
  
    IF p_payee_category = 'EMPLOYEE' THEN
      SELECT a.account_number,
             a.account_name,
             a.bank_code,
             a.bank_name,
             a.bank_location_code,
             a.bank_location,
             a.province_code,
             a.province_name,
             a.city_code,
             a.city_name
        INTO v_account_number,
             v_account_name,
             v_bank_code,
             v_bank_name,
             v_bank_location_code,
             v_bank_location_name,
             v_province_code,
             v_province_name,
             v_city_code,
             v_city_name
        FROM exp_employee_accounts a
       WHERE a.employee_id = v_payee_id
         AND a.account_number = p_payee_account_number;
    ELSIF p_payee_category = 'VENDER' THEN
      SELECT a.account_number,
             a.account_name,
             a.bank_code,
             a.bank_name,
             a.bank_location_code,
             a.bank_location,
             a.province_code,
             a.province_name,
             a.city_code,
             a.city_name
        INTO v_account_number,
             v_account_name,
             v_bank_code,
             v_bank_name,
             v_bank_location_code,
             v_bank_location_name,
             v_province_code,
             v_province_name,
             v_city_code,
             v_city_name
        FROM pur_vender_accounts a
       WHERE a.vender_id = v_payee_id
         AND a.account_number = p_payee_account_number;
    ELSE
      RAISE e_payee_category_error;
    END IF;
  
    IF v_payment_doc_info.document_category = 'EXP_REPORT' THEN
      UPDATE exp_report_pmt_schedules s
         SET s.account_number     = v_account_number,
             s.account_name       = v_account_name,
             s.bank_code          = v_bank_code,
             s.bank_name          = v_bank_name,
             s.bank_location_code = v_bank_location_code,
             s.bank_location_name = v_bank_location_name,
             s.province_code      = v_province_code,
             s.province_name      = v_province_name,
             s.city_code          = v_city_code,
             s.city_name          = v_city_name,
             s.last_updated_by    = p_user_id,
             s.last_update_date   = SYSDATE,
             --s.payment_type_id    = p_payment_method_id,
             s.gather_flag = nvl(p_gather_flag, gather_flag)
       WHERE s.exp_report_header_id = v_payment_doc_info.document_id
         AND s.payment_schedule_line_id =
             v_payment_doc_info.document_line_id;
    ELSIF v_payment_doc_info.document_category = 'PAYMENT_REQUISITION' THEN
      UPDATE csh_payment_requisition_lns s
         SET s.account_number     = v_account_number,
             s.account_name       = v_account_name,
             s.bank_code          = v_bank_code,
             s.bank_name          = v_bank_name,
             s.bank_location_code = v_bank_location_code,
             s.bank_location_name = v_bank_location_name,
             s.province_code      = v_province_code,
             s.province_name      = v_province_name,
             s.city_code          = v_city_code,
             s.city_name          = v_city_name,
             s.last_updated_by    = p_user_id,
             s.last_update_date   = SYSDATE,
             --s.payment_method     = p_payment_method_id,
             s.gather_flag = nvl(p_gather_flag, gather_flag)
       WHERE s.payment_requisition_header_id =
             v_payment_doc_info.document_id
         AND s.payment_requisition_line_id =
             v_payment_doc_info.document_line_id;
    ELSIF v_payment_doc_info.document_category = 'ACP_REQUISITION' THEN
      UPDATE acp_acp_requisition_lns l
         SET l.account_number     = v_account_number,
             l.account_name       = v_account_name,
             l.bank_code          = v_bank_code,
             l.bank_name          = v_bank_name,
             l.bank_location_code = v_bank_location_code,
             l.bank_location_name = v_bank_location_name,
             l.province_code      = v_province_code,
             l.province_name      = v_province_name,
             l.city_code          = v_city_code,
             l.city_name          = v_city_name,
             l.last_updated_by    = p_user_id,
             l.last_update_date   = SYSDATE,
             --l.payment_method_id  = p_payment_method_id,
             l.gather_flag = nvl(p_gather_flag, gather_flag)
       WHERE l.acp_requisition_header_id = v_payment_doc_info.document_id
         AND l.acp_requisition_line_id =
             v_payment_doc_info.document_line_id;
    END IF;
  
    --更新费控付款接口表
    update cux_payment_interface c
       set c.recaccountno      = v_account_number,
           c.recaccountname    = v_account_name,
           c.recbankname       = v_bank_location_name,
           c.recprovince       = v_province_code,
           c.recareanameofcity = v_bank_location_code
     where c.id = p_info_id;
  EXCEPTION
    WHEN e_payee_category_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '收款方类别错误，目前只支持员工和供应商!',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'update_payee_account');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN no_data_found THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '该收款方没有对应的银行账号，请确认主数据是否正确!',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'update_payee_account');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END update_payee_account;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/26 19:11:31
  -- Ver     : 1.1
  -- Purpose : 修改收款信息并重传资金
  **************************************************/
  PROCEDURE update_payee_info_resend(p_info_id        NUMBER,
                                     p_payee_category VARCHAR2,
                                     --p_payee_id             number,
                                     p_payee_account_number VARCHAR2,
                                     p_payment_method_id    NUMBER,
                                     p_gather_flag          VARCHAR2,
                                     p_user_id              NUMBER) IS
  
  BEGIN
    update_payee_account(p_info_id        => p_info_id,
                         p_payee_category => p_payee_category,
                         --p_payee_id             => p_payee_id,
                         p_payee_account_number => p_payee_account_number,
                         p_payment_method_id    => p_payment_method_id,
                         p_gather_flag          => p_gather_flag,
                         p_user_id              => p_user_id);
  
    UPDATE cux_payment_interface i
       SET i.check_status = '1'
     WHERE i.id = p_info_id;
  
  END update_payee_info_resend;

  --重新支付
  PROCEDURE resend_to_zj(p_inter_id NUMBER, p_user_id NUMBER) IS
    v_payment_interface cux_payment_interface%ROWTYPE;
    CURSOR c1 IS
      SELECT *
        FROM cp_lock_assist cl
       WHERE cl.doc_type = 'PAYMENT_INTERFACE'
         AND cl.doc_id = p_inter_id
         FOR UPDATE NOWAIT;
    e_locked_error EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_locked_error, -54);
  BEGIN
    -- LOCK TABLE
    cp_lock_assist_pkg.insert_lock_info(p_inter_id, 'PAYMENT_INTERFACE');
    OPEN c1;
  
    --重新生成待付数据，发送支付
    confirm_resend_to_zj(p_info_id => p_inter_id, p_user_id => p_user_id);
  
    CLOSE c1;
  EXCEPTION
    WHEN e_locked_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '单据正在处理，请稍等...',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_gr_pkg',
                                                     p_procedure_function_name => 'resend_to_zj');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      IF c1%ISOPEN THEN
        CLOSE c1;
      END IF;
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => SQLERRM ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_gr_pkg',
                                                     p_procedure_function_name => 'resend_to_zj');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END resend_to_zj;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/26 14:18:34
  -- Ver     : 1.1
  -- Purpose : 确认退票并重传资金接口
  **************************************************/
  PROCEDURE confirm_refund_cancel_to_zj(p_info_id NUMBER, p_user_id NUMBER) IS
    v_payment_doc_info       cux_payment_doc_info%ROWTYPE;
    v_new_info_id            NUMBER;
    v_info                   cux_payment_doc_info%ROWTYPE;
    v_transaction_header_id  NUMBER;
    v_reversed_trans_line_id NUMBER;
    v_returned_flag          VARCHAR2(30);
    v_reversed_flag          VARCHAR2(30);
  
    e_returned_error      EXCEPTION;
    e_return_trans_error  EXCEPTION;
    e_reversed_error      EXCEPTION;
    e_reverse_trans_error EXCEPTION;
    e_pay_doc_not_exists  EXCEPTION;
  BEGIN
    --支付被退票，找到原现金事务进行反冲
    BEGIN
      SELECT *
        INTO v_info
        FROM cux_payment_doc_info i
       WHERE i.interface_id = p_info_id
         AND i.datastatus = '6'
         FOR UPDATE NOWAIT;
    EXCEPTION
      WHEN no_data_found THEN
        RAISE e_pay_doc_not_exists;
    END;
  
    SELECT h.transaction_header_id, h.returned_flag, h.reversed_flag
      INTO v_transaction_header_id, v_returned_flag, v_reversed_flag
      FROM csh_transaction_headers h, csh_transaction_lines l
     WHERE h.transaction_header_id = l.transaction_header_id
       AND l.transaction_line_id = v_info.pay_transaction_line_id;
  
    --判断当前现金事务是否被退款
    IF v_returned_flag = 'C' OR v_returned_flag = 'Y' THEN
      RAISE e_returned_error;
    ELSIF v_returned_flag = 'R' THEN
      RAISE e_return_trans_error;
    END IF;
  
    --判断当前现金事务是否被反冲
    IF v_reversed_flag = 'W' THEN
      RAISE e_reversed_error;
    ELSIF v_reversed_flag = 'R' THEN
      RAISE e_reverse_trans_error;
    END IF;
  
    --调用反冲逻辑生成反冲事务，并记录反冲事务编号
    --退票生成负数凭证，修改refund_reverse_flag为N
    csh_transaction_pkg.set_refund_reverse_flag(p_refund_reverse_flag => 'N');
  
    csh_transaction_pkg.post_reverse_transaction(p_transaction_header_id => v_transaction_header_id,
                                                 p_reverse_date          => SYSDATE,
                                                 p_user_id               => p_user_id);
  
    SELECT l.transaction_line_id
      INTO v_reversed_trans_line_id
      FROM csh_transaction_headers h, csh_transaction_lines l
     WHERE h.source_header_id = v_transaction_header_id
       AND h.transaction_header_id = l.transaction_header_id
       AND h.reversed_flag = 'R';
  
    --将原接口数据置为失败，可重新支付
    UPDATE cux_payment_doc_info i
       SET i.refund_transaction_line_id = v_reversed_trans_line_id,
           i.datastatus                 = '3'
     WHERE i.info_id = v_info.info_id;
  
    UPDATE cux_payment_interface c
       SET c.datastatus = '3'
     WHERE c.id = v_info.interface_id;
  
    --更新原现金事物为支付失败状态                     
    UPDATE csh_transaction_headers h
       SET h.pay_status_desc = 3
     WHERE h.transaction_header_id = v_transaction_header_id;
  
    --备份失败的资金接口数据
    --backup_failed_zj_info(p_info_id => p_info_id);
  
  EXCEPTION
    WHEN e_lock_table THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '当前该笔支付信息正在处理中，请勿重复处理！',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'confirm_refund_cancel_to_zj');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_returned_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '当前付款事务已被' ||
                                                                                  (CASE
                                                                                   v_returned_flag
                                                                                    WHEN 'C' THEN
                                                                                     '完全'
                                                                                    WHEN 'Y' THEN
                                                                                     '部分'
                                                                                  END) ||
                                                                                  '退款，请检查退款状况',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'confirm_refund_cancel_to_zj');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_return_trans_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '当前付款事务为退款事务，请联系管理员确认数据！',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'confirm_refund_cancel_to_zj');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_reversed_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '当前付款事务已被反冲，请使用【已反冲付款退票确认】按钮进行操作！',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'confirm_refund_cancel_to_zj');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_reverse_trans_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '当前付款事务为反冲事务，请联系管理员确认数据！',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'confirm_refund_cancel_to_zj');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_pay_doc_not_exists THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '当前支付信息已经不存在或者不是支付退票状态',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'confirm_refund_cancel_to_zj');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => SQLERRM ||
                                                                                  chr(10) ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'confirm_refund_cancel_to_zj');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END confirm_refund_cancel_to_zj;

  /*************************************************
  -- Author  : MOUSE
  -- Created : 2015/11/26 14:18:34
  -- Ver     : 1.1
  -- Purpose : 确认并取消资金接口
  **************************************************/
  PROCEDURE confirm_cancel_to_zj(p_inter_id NUMBER, p_user_id NUMBER) IS
    v_payment_doc_info cux_payment_doc_info%ROWTYPE;
    v_interface_info   cux_payment_interface%ROWTYPE;
    e_pay_doc_not_exists EXCEPTION;
  BEGIN
    /*select *
     into v_payment_doc_info
     from cux_payment_doc_info i
    where i.info_id = p_info_id
      and i.datastatus = '3'
      for update nowait;*/
  
    SELECT *
      INTO v_interface_info
      FROM cux_payment_interface i
     WHERE i.id = p_inter_id
       FOR UPDATE NOWAIT;
  
    SELECT d.*
      INTO v_payment_doc_info
      FROM cux_payment_doc_info d
     WHERE d.interface_id = v_interface_info.id;
  
    --备份失败的资金接口数据
    backup_failed_zj_info(p_info_id => p_inter_id);
  
  EXCEPTION
    WHEN e_lock_table THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '当前该笔支付信息正在处理中，请勿重复处理！',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'confirm_resend_to_zj');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_pay_doc_not_exists THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '当前支付信息已经不存在或者不是支付失败或者取消状态',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_payment_pkg',
                                                     p_procedure_function_name => 'confirm_resend_to_zj');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END confirm_cancel_to_zj;

END cux_payment_gr_pkg;
/
