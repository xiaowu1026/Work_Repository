CREATE OR REPLACE PACKAGE cux_oa_interface_pkg IS

  -- Author  : Rick
  -- Created : 2017/4/18 14:12:02
  -- Purpose : OA接口

  FUNCTION convert_unicode(p_msg CLOB) RETURN CLOB AS
    LANGUAGE JAVA NAME 'convert_unicode.convert_fun(oracle.sql.CLOB) return  oracle.sql.CLOB';

  --发送至OA及APP 
  PROCEDURE send_toto(p_instance_id NUMBER);

  --#########################################
  --发送至OA 
  --#########################################
  PROCEDURE sign_send_todo_to_oa(p_sign_id NUMBER);

  --设为已办
  PROCEDURE set_todo_done(p_instance_id NUMBER);

  --设为已办
  PROCEDURE sign_set_todo_done_oa(p_sign_id NUMBER);

  --#########################################
  --删除待办
  --#########################################
  PROCEDURE delete_todo(p_instance_id NUMBER);

  --#########################################
  --处理未成功发送至OA的待办和已办
  --#########################################
  PROCEDURE oa_error_and_log_op_sch;

  PROCEDURE oa_error_and_log_op;

  c_oa_hec_webservice_url      CONSTANT VARCHAR2(200) := sys_parameter_pkg.value('GR_OA_WS_URL');
  c_oa_hec_webservice_username CONSTANT VARCHAR2(200) := sys_parameter_pkg.value('GR_OA_WEBSERVICE_USERNAME');
  c_oa_hec_webservice_password CONSTANT VARCHAR2(200) := sys_parameter_pkg.value('GR_OA_WEBSERVICE_PASSWORD');
  c_hec_sso_login_url          CONSTANT VARCHAR2(200) := sys_parameter_pkg.value('GR_HEC_SSO_URL');

  --#########################################
  --处理未成功发送至OA的待办和已办
  --#########################################
  FUNCTION oa_error_and_log_op_evt(p_event_id    NUMBER,
                                   p_log_id      NUMBER,
                                   p_event_param NUMBER,
                                   p_created_by  NUMBER) RETURN NUMBER;

  FUNCTION get_title(p_record_id NUMBER) RETURN VARCHAR2;

END cux_oa_interface_pkg;
/
CREATE OR REPLACE PACKAGE BODY cux_oa_interface_pkg IS

  c_biz_oa_todo        CONSTANT VARCHAR2(30) := 'OA_TODO'; -- OA待办
  c_biz_oa_todo_done   CONSTANT VARCHAR2(30) := 'OA_TODO_DONE'; -- OA已办
  c_biz_oa_todo_delete CONSTANT VARCHAR2(30) := 'OA_TODO_DELETE'; -- OA已办删除

  FUNCTION get_validate_info RETURN VARCHAR2 IS
    v_result VARCHAR2(4000);
  BEGIN
    v_result := '<tns:RequestSOAPHeader xmlns:tns="http://sys.webservice.client"><tns:user>' ||
                c_oa_hec_webservice_username || '</tns:user><tns:password>' ||
                c_oa_hec_webservice_password ||
                '</tns:password></tns:RequestSOAPHeader>';
    RETURN v_result;
  END get_validate_info;

  FUNCTION get_doc_num(p_record_id NUMBER) RETURN VARCHAR2 IS
    v_doc_num VARCHAR2(30);
  BEGIN
    BEGIN
      SELECT t.document_number
        INTO v_doc_num
        FROM cux_wfl_instance_node_v t
       WHERE t.record_id = p_record_id;
    EXCEPTION
      WHEN no_data_found THEN
        SELECT t.document_number
          INTO v_doc_num
          FROM cux_wfl_instance_node_ht_v t
         WHERE t.record_id = p_record_id;
    END;
    RETURN v_doc_num;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END get_doc_num;

  PROCEDURE logs(p_cux_oa_trans_logs_id IN OUT NUMBER,
                 p_req_msg              VARCHAR2 DEFAULT NULL,
                 p_resp_msg             VARCHAR2 DEFAULT NULL,
                 p_record_id            NUMBER DEFAULT NULL,
                 p_type                 VARCHAR2,
                 p_error_msg            VARCHAR2 DEFAULT NULL,
                 p_doc_num              VARCHAR2) IS
    v_error_msg VARCHAR2(500);
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    IF (p_cux_oa_trans_logs_id IS NULL) THEN
      p_cux_oa_trans_logs_id := cux_oa_trans_logs_s.nextval;
    
      INSERT INTO cux_oa_trans_logs
        (cux_oa_trans_logs_id,
         req_msg,
         record_id,
         doc_number,
         creation_date,
         last_update_date,
         TYPE,
         error_msg)
      VALUES
        (p_cux_oa_trans_logs_id,
         p_req_msg,
         p_record_id,
         p_doc_num,
         SYSDATE,
         SYSDATE,
         p_type,
         p_error_msg);
    ELSE
      UPDATE cux_oa_trans_logs l
         SET l.last_update_date = SYSDATE,
             l.resp_msg         = nvl(p_resp_msg, l.resp_msg),
             l.error_msg        = nvl(substrb(p_error_msg, 1, 400),
                                      l.error_msg)
       WHERE l.cux_oa_trans_logs_id = p_cux_oa_trans_logs_id;
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      v_error_msg := SQLERRM || dbms_utility.format_error_backtrace;
      IF (p_cux_oa_trans_logs_id IS NOT NULL) THEN
      
        UPDATE cux_oa_trans_logs l
           SET l.last_update_date = SYSDATE,
               l.resp_msg         = nvl(p_resp_msg, l.resp_msg),
               l.req_msg          = nvl(p_req_msg, l.req_msg),
               l.error_msg        = substrb(v_error_msg, 1, 450)
         WHERE l.cux_oa_trans_logs_id = p_cux_oa_trans_logs_id;
      ELSE
        INSERT INTO cux_oa_trans_logs
          (cux_oa_trans_logs_id,
           req_msg,
           record_id,
           doc_number,
           creation_date,
           last_update_date,
           TYPE,
           error_msg)
        VALUES
          (p_cux_oa_trans_logs_id,
           p_req_msg,
           p_record_id,
           p_doc_num,
           SYSDATE,
           SYSDATE,
           p_type,
           substrb(v_error_msg, 1, 450));
      END IF;
    
  END logs;

  --推送报文
  PROCEDURE call_webservice(p_request_object CLOB,
                            p_soap_action    VARCHAR2,
                            p_res            OUT VARCHAR2) IS
  
    v_service_url   VARCHAR2(2000);
    l_http_request  utl_http.req;
    l_http_response utl_http.resp;
    v_resp_line     VARCHAR2(4000);
    l_clob          CLOB;
    l_req_blob      BLOB;
  
    v_length NUMBER;
    ---------------- Used by clob2blob ---------------------------------
    l_lang        NUMBER := dbms_lob.default_lang_ctx;
    i_dest_offset NUMBER := 1;
    i_src_offset  NUMBER := 1;
    l_warning     NUMBER;
    --------------------------------------------------------------------
  
    v_amt_to_read       INTEGER := 1;
    v_offset            INTEGER := 1;
    l_raw_data          RAW(512);
    v_request_record_id NUMBER;
  BEGIN
    v_service_url  := c_oa_hec_webservice_url;
    l_http_request := utl_http.begin_request(v_service_url,
                                             'POST',
                                             utl_http.http_version_1_1);
    utl_http.set_header(l_http_request,
                        'content-type',
                        'application/xml;charset=gbk');
    --utl_http.set_header(l_http_request, 'SOAPAction', p_soap_action);
    dbms_lob.createtemporary(lob_loc => l_clob, cache => TRUE);
    l_clob := p_request_object;
    dbms_lob.createtemporary(lob_loc => l_req_blob, cache => TRUE);
  
    --将clob转成blob
    dbms_lob.converttoblob(l_req_blob,
                           l_clob,
                           dbms_lob.lobmaxsize,
                           i_dest_offset,
                           i_src_offset,
                           dbms_lob.default_csid,
                           l_lang,
                           l_warning);
    v_length := lengthb(l_req_blob);
    utl_http.set_header(l_http_request, 'Content-Length', v_length);
  
    ---------------------Write Msg ---------------------
    <<request_loop>>
    FOR i IN 0 .. ceil(v_length / 512) - 1 LOOP
      BEGIN
        v_amt_to_read := 512; -- Set it all the time. DBMS_LOB.read() may overwrite.
        v_offset      := i * 512 + 1;
        -- Read bytes into the raw buffer
        dbms_lob.read(l_req_blob, v_amt_to_read, v_offset, l_raw_data);
        utl_http.write_raw(r => l_http_request, data => l_raw_data);
      EXCEPTION
        WHEN no_data_found THEN
          EXIT request_loop;
      END;
    END LOOP request_loop;
  
    ---------------------Read Msg ---------------------
    l_http_response := utl_http.get_response(l_http_request);
    utl_http.set_body_charset(l_http_response, '');
    BEGIN
      LOOP
        utl_http.read_text(l_http_response, v_resp_line, 4000);
        dbms_output.put_line(v_resp_line);
        p_res := p_res || v_resp_line;
      END LOOP;
    EXCEPTION
      WHEN utl_http.end_of_body THEN
        NULL;
    END;
  
    --p_res := convert_unicode(p_res);
    p_res := REPLACE(p_res,
                     'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"',
                     '');
    p_res := REPLACE(p_res,
                     'xmlns:ns1="http://webservice.notify.sys.kmss.landray.com/"',
                     '');
    p_res := REPLACE(p_res, '<soap:', '<');
    p_res := REPLACE(p_res, '<ns1:', '<');
    p_res := REPLACE(p_res, '</soap:', '</');
    p_res := REPLACE(p_res, '</ns1:', '</');
  
    --close connection
    utl_http.end_response(l_http_response);
  EXCEPTION
    WHEN OTHERS THEN
      utl_http.end_response(l_http_response);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              SQLERRM ||
                              dbms_utility.format_error_backtrace);
  END call_webservice;

  FUNCTION get_exp_link(p_sign_id NUMBER) RETURN VARCHAR2 IS
    v_result VARCHAR2(300);
  BEGIN
    v_result := c_hec_sso_login_url || --
                '?sso_op=EXP_REPORT&sign_id=' || p_sign_id;
  
    v_result := '<![CDATA[' || v_result || ']]>';
    RETURN v_result;
  END get_exp_link;

  FUNCTION get_link(p_record_id NUMBER) RETURN VARCHAR2 IS
    v_order_doc_type     VARCHAR2(50);
    v_document_page_type VARCHAR2(50);
    v_document_number    VARCHAR2(50);
    v_page_code          VARCHAR2(50);
    v_result             VARCHAR2(300);
    v_instance_id        NUMBER;
  BEGIN
    v_page_code := 'list-detail';
    SELECT wwi.document_number,
           ww.workflow_category,
           (SELECT eert.document_page_type
              FROM exp_report_headers erh, exp_expense_report_types_vl eert
             WHERE ww.workflow_category = 'EXP_REPORT'
               AND erh.exp_report_header_id = wwi.instance_param
               AND erh.exp_report_type_id = eert.expense_report_type_id),
           wwi.instance_id
      INTO v_document_number,
           v_order_doc_type,
           v_document_page_type,
           v_instance_id
      FROM wfl_instance_node_recipient t,
           wfl_workflow_instance       wwi,
           wfl_workflow                ww
     WHERE wwi.instance_id = t.instance_id
       AND ww.workflow_id = wwi.workflow_id
       AND t.record_id = p_record_id;
  
    IF (v_document_page_type IS NULL) THEN
      v_document_page_type := '0';
    END IF;
  
    v_result := c_hec_sso_login_url || --
                '?sso_op=wfl&record_id=' || p_record_id || --
                '&order_doc_type=' || v_order_doc_type || --
                '&document_number=' || v_document_number || --
                '&page_code=' || v_page_code || --
                '&document_page_type=' || v_document_page_type || --
                '&instance_id=' || v_instance_id;
  
    v_result := '<![CDATA[' || v_result || ']]>';
  
    RETURN v_result;
  END get_link;

  --#########################################
  --发送至OA 
  --#########################################
  PROCEDURE sign_send_todo_to_oa(p_sign_id NUMBER) IS
    v_send_msg      VARCHAR2(32767);
    v_back_msg      VARCHAR2(32767);
    v_logs_id       NUMBER;
    v_returnstate   VARCHAR2(20);
    v_message       VARCHAR2(32767);
    v_response_xml  sys.xmltype;
    v_token         VARCHAR2(100);
    v_link          VARCHAR2(1000);
    v_validate_info VARCHAR2(4000);
    v_sign_code     VARCHAR2(100);
    v_hec_doc_type  VARCHAR2(50);
    v_doc_desc      VARCHAR2(100);
    v_title         VARCHAR2(300);
  BEGIN
    v_validate_info := get_validate_info;
  
    SELECT cso.sign_code, cso.hec_doc_type
      INTO v_sign_code, v_hec_doc_type
      FROM con_sign_oa cso
     WHERE cso.sign_id = p_sign_id;
  
    IF (v_hec_doc_type = 'EXP_REPORT') THEN
      v_link     := get_exp_link(p_sign_id);
      v_doc_desc := '报销单';
    END IF;
  
    FOR rcpts IN (SELECT cso.sign_id,
                         cso.sign_code,
                         su.user_name,
                         cso.creation_date,
                         su.user_id,
                         cso.oa_sign_applyer,
                         cso.oa_sign_type_desc,
                         decode(cso.oa_sign_type_code,
                                '166534b702087e3f9a6335c4d86960fc',
                                '公司签报',
                                '流程') oa_wfl_desc
                    FROM con_sign_oa cso, sys_user su
                   WHERE cso.sign_id = p_sign_id
                     AND cso.hec_doc_type = 'EXP_REPORT'
                     AND su.user_id IN
                         (SELECT *
                            FROM TABLE(sys_sql_util_pkg.split(cso.resolve_users,
                                                              ',')))) LOOP
      /*v_title    := rcpts.oa_sign_applyer || '提交了OA' ||
      rcpts.oa_sign_type_desc || rcpts.sign_code ||
      ',请尽快提交费用报销单';*/
      v_title    := rcpts.oa_sign_applyer || '提交了' || rcpts.sign_code ||
                    rcpts.oa_wfl_desc || ',请尽快提交费用报销单';
      v_send_msg := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.notify.sys.kmss.landray.com/">' || --
                    '<soapenv:Header>' || v_validate_info ||
                    '</soapenv:Header>' || --
                    '<soapenv:Body>' || --
                    '<web:sendTodo>' || --
                    '<arg0>' || --
                    '<appName>HEC</appName>' || --
                    '<createTime>' ||
                    to_char(rcpts.creation_date, 'yyyy-mm-dd hh24:mi:ss') ||
                    '</createTime>' || --
                    '<key>' || (rcpts.user_id * 10000000000 + p_sign_id) ||
                    '</key>' || --
                    '<link>' || v_link || '</link>' || --
                    '<modelId>' ||
                    (rcpts.user_id * 10000000000 + p_sign_id) ||
                    '</modelId>' || --
                    '<modelName>OA签报创建' || v_doc_desc || '</modelName>' || --
                    '<param1></param1>' || --
                    '<param2></param2>' || --
                    '<subject>' || v_title || '</subject>' || --
                    '<targets>{"LoginName":"' || rcpts.user_name ||
                    '"}</targets>' || --
                    '<type>1</type>' || --
                    '</arg0>' || --
                    '</web:sendTodo>' || --
                    '</soapenv:Body>' || --
                    '</soapenv:Envelope>';
    
      logs(p_cux_oa_trans_logs_id => v_logs_id,
           p_req_msg              => v_send_msg,
           p_resp_msg             => NULL,
           p_record_id            => p_sign_id,
           p_type                 => c_biz_oa_todo,
           p_doc_num              => rcpts.sign_code);
    
      call_webservice(p_request_object => v_send_msg,
                      p_soap_action    => 'sendTodo',
                      p_res            => v_back_msg);
    
      logs(p_cux_oa_trans_logs_id => v_logs_id,
           p_req_msg              => NULL,
           p_resp_msg             => v_back_msg,
           p_record_id            => p_sign_id,
           p_type                 => c_biz_oa_todo,
           p_doc_num              => rcpts.sign_code);
      v_response_xml := sys.xmltype.createxml(v_back_msg);
      SELECT extractvalue(v_response_xml,
                          '/Envelope/Body/sendTodoResponse/return/message'),
             extractvalue(v_response_xml,
                          '/Envelope/Body/sendTodoResponse/return/returnState')
        INTO v_message, v_returnstate
        FROM dual;
    
      IF (v_returnstate = '2') THEN
        NULL;
      ELSE
        logs(p_cux_oa_trans_logs_id => v_logs_id,
             p_req_msg              => NULL,
             p_resp_msg             => NULL,
             p_record_id            => p_sign_id,
             p_type                 => c_biz_oa_todo,
             p_error_msg            => v_message,
             p_doc_num              => rcpts.sign_code);
      END IF;
    
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
    
      logs(p_cux_oa_trans_logs_id => v_logs_id,
           p_req_msg              => NULL,
           p_resp_msg             => NULL,
           p_record_id            => p_sign_id,
           p_type                 => c_biz_oa_todo,
           p_error_msg            => SQLERRM ||
                                     dbms_utility.format_error_backtrace,
           p_doc_num              => v_sign_code);
  END sign_send_todo_to_oa;

  FUNCTION get_title(p_record_id NUMBER) RETURN VARCHAR2 IS
    v_result            VARCHAR2(300);
    v_workflow_category VARCHAR2(100);
    v_document_id       NUMBER;
  BEGIN
    SELECT ww.workflow_category, wwi.instance_param
      INTO v_workflow_category, v_document_id
      FROM wfl_instance_node_recipient_oa wro,
           wfl_workflow_instance          wwi,
           wfl_workflow                   ww
     WHERE wro.instance_id = wwi.instance_id
       AND wro.record_id = p_record_id
       AND wwi.workflow_id = ww.workflow_id;
  
    IF (v_workflow_category = 'EXP_REPORT') THEN
      SELECT '【费控待办】' || ee.name || '报销' ||
             REPLACE(eerp.description, '报销单', '') || '费用' ||
             (SELECT to_char(SUM(erl.report_amount),
                             'fm99,999,999,999,990.00') || '元'
                FROM exp_report_lines erl
               WHERE erh.exp_report_header_id = erl.exp_report_header_id)
        INTO v_result
        FROM exp_report_headers          erh,
             sys_user                    su,
             exp_employees               ee,
             exp_expense_report_types_vl eerp
       WHERE erh.exp_report_header_id = v_document_id
         AND erh.created_by = su.user_id
         AND su.employee_id = ee.employee_id
         AND erh.exp_report_type_id = eerp.expense_report_type_id;
    
    ELSIF (v_workflow_category = 'PAYMENT_REQUISITION') THEN
      SELECT '【费控待办】' || ee.name || '借支' || cprt.description ||
             
             (SELECT to_char(SUM(erl.amount), 'fm99,999,999,999,990.00') || '元'
                FROM csh_payment_requisition_lns erl
               WHERE erl.payment_requisition_header_id =
                     epr.payment_requisition_header_id)
        INTO v_result
        FROM csh_payment_requisition_hds epr,
             sys_user                    su,
             exp_employees               ee,
             csh_pay_req_types_vl        cprt
       WHERE epr.payment_requisition_header_id = v_document_id
         AND epr.created_by = su.user_id
         AND su.employee_id = ee.employee_id
         AND epr.payment_req_type_id = cprt.type_id;
    END IF;
    RETURN v_result;
  END get_title;

  --#########################################
  --发送至OA 
  --#########################################
  PROCEDURE send_todo_to_oa(p_record_id NUMBER) IS
    v_send_msg      VARCHAR2(32767);
    v_back_msg      VARCHAR2(32767);
    v_logs_id       NUMBER;
    v_returnstate   VARCHAR2(20);
    v_message       VARCHAR2(32767);
    v_response_xml  sys.xmltype;
    v_token         VARCHAR2(100);
    v_link          VARCHAR2(1000);
    v_validate_info VARCHAR2(4000);
    v_title         VARCHAR2(300);
  BEGIN
    v_validate_info := get_validate_info;
    v_title         := get_title(p_record_id);
    FOR rcpts IN (SELECT t.*,
                         wwi.instance_desc,
                         (SELECT wdr.document_desc
                            FROM wfl_document_reference_vl wdr
                           WHERE ww.workflow_category = wdr.workflow_category) AS order_type,
                         su.user_name
                    FROM wfl_instance_node_recipient_oa t,
                         wfl_workflow_instance          wwi,
                         wfl_workflow                   ww,
                         sys_user                       su
                   WHERE wwi.instance_id = t.instance_id
                     AND ww.workflow_id = wwi.workflow_id
                     AND t.record_id = p_record_id
                     AND t.user_id = su.user_id) LOOP
      /*v_link := '<![CDATA[' || c_hec_sso_login_url ||
      '?sso_op=wfl&record_id=' || p_record_id || ']]>';*/
    
      v_link := get_link(p_record_id);
    
      v_send_msg := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.notify.sys.kmss.landray.com/">' || --
                    '<soapenv:Header>' || v_validate_info ||
                    '</soapenv:Header>' || --
                    '<soapenv:Body>' || --
                    '<web:sendTodo>' || --
                    '<arg0>' || --
                    '<appName>HEC</appName>' || --
                    '<createTime>' ||
                    to_char(rcpts.creation_date, 'yyyy-mm-dd hh24:mi:ss') ||
                    '</createTime>' || --
                    '<key>' || p_record_id || '</key>' || --
                    '<link>' || v_link || '</link>' || --
                    '<modelId>' || p_record_id || '</modelId>' || --
                    '<modelName>' || rcpts.order_type || '</modelName>' || --
                    '<param1></param1>' || --
                    '<param2></param2>' || --
                    '<subject>' || v_title || '</subject>' || --
                    '<targets>{"LoginName":"' || rcpts.user_name ||
                    '"}</targets>' || --
                    '<type>1</type>' || --
                    '</arg0>' || --
                    '</web:sendTodo>' || --
                    '</soapenv:Body>' || --
                    '</soapenv:Envelope>';
    
      logs(p_cux_oa_trans_logs_id => v_logs_id,
           p_req_msg              => v_send_msg,
           p_resp_msg             => NULL,
           p_record_id            => p_record_id,
           p_type                 => c_biz_oa_todo,
           p_doc_num              => get_doc_num(p_record_id));
    
      call_webservice(p_request_object => v_send_msg,
                      p_soap_action    => 'sendTodo',
                      p_res            => v_back_msg);
    
      logs(p_cux_oa_trans_logs_id => v_logs_id,
           p_req_msg              => NULL,
           p_resp_msg             => v_back_msg,
           p_record_id            => p_record_id,
           p_type                 => c_biz_oa_todo,
           p_doc_num              => get_doc_num(p_record_id));
      v_response_xml := sys.xmltype.createxml(v_back_msg);
      SELECT extractvalue(v_response_xml,
                          '/Envelope/Body/sendTodoResponse/return/message'),
             extractvalue(v_response_xml,
                          '/Envelope/Body/sendTodoResponse/return/returnState')
        INTO v_message, v_returnstate
        FROM dual;
    
      IF (v_returnstate = '2') THEN
        UPDATE wfl_instance_node_recipient_oa r
           SET r.oa_sync_flag = 'Y'
         WHERE r.record_id = p_record_id;
      
        /*        BEGIN
          INSERT INTO cux_oa_token
            (record_id, token)
          VALUES
            (p_record_id, v_token);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;*/
      ELSE
        logs(p_cux_oa_trans_logs_id => v_logs_id,
             p_req_msg              => NULL,
             p_resp_msg             => NULL,
             p_record_id            => p_record_id,
             p_type                 => c_biz_oa_todo,
             p_error_msg            => v_message,
             p_doc_num              => get_doc_num(p_record_id));
      END IF;
    
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
    
      logs(p_cux_oa_trans_logs_id => v_logs_id,
           p_req_msg              => NULL,
           p_resp_msg             => NULL,
           p_record_id            => p_record_id,
           p_type                 => c_biz_oa_todo,
           p_error_msg            => SQLERRM ||
                                     dbms_utility.format_error_backtrace,
           p_doc_num              => get_doc_num(p_record_id));
  END send_todo_to_oa;

  --#########################################
  --写入发送备份表
  --#########################################
  PROCEDURE insert_oa_records(p_instance_id NUMBER) IS
  BEGIN
    FOR c1 IN (SELECT wi.*
                 FROM wfl_instance_node_recipient wi
                WHERE wi.instance_id = p_instance_id
                  AND NOT EXISTS (SELECT 1
                         FROM wfl_instance_node_recipient_oa wo
                        WHERE wi.record_id = wo.record_id)
                  AND EXISTS
                (SELECT 1
                         FROM wfl_workflow_instance wwi, wfl_workflow ww
                        WHERE wwi.instance_id = wi.instance_id
                          AND wwi.workflow_id = ww.workflow_id
                             --国任只发送报销和借款
                          AND ww.workflow_category IN
                              ('EXP_REPORT', 'PAYMENT_REQUISITION'))) LOOP
      INSERT INTO wfl_instance_node_recipient_oa
        (instance_id,
         node_id,
         seq_number,
         user_id,
         date_limit,
         record_id,
         commision_by,
         commision_desc,
         last_notify_date,
         attachment_id,
         hierarchy_record_id,
         creation_date,
         created_by,
         last_update_date,
         last_updated_by,
         oa_sync_flag,
         oa_done_sync_flag)
      VALUES
        (c1.instance_id,
         c1.node_id,
         c1.seq_number,
         c1.user_id,
         c1.date_limit,
         c1.record_id,
         c1.commision_by,
         c1.commision_desc,
         c1.last_notify_date,
         c1.attachment_id,
         c1.hierarchy_record_id,
         SYSDATE,
         c1.created_by,
         SYSDATE,
         c1.last_updated_by,
         c1.oa_sync_flag,
         'N');
    END LOOP;
  END insert_oa_records;

  --#########################################
  --发送至OA及APP 
  --#########################################
  PROCEDURE send_toto(p_instance_id NUMBER) IS
  BEGIN
    insert_oa_records(p_instance_id);
    -- 发送待办
    FOR c1 IN (SELECT *
                 FROM wfl_instance_node_recipient_oa wi
                WHERE wi.instance_id = p_instance_id
                  AND nvl(wi.oa_sync_flag, 'N') = 'N'
                  AND EXISTS
                (SELECT 1
                         FROM wfl_instance_node_recipient wo
                        WHERE wi.record_id = wo.record_id)) LOOP
      send_todo_to_oa(c1.record_id);
    END LOOP;
  
    --发送至手机端
    --cux_mobile_wfl_pkg.send_toto(p_instance_id);
  END send_toto;

  --设为已办
  PROCEDURE sign_set_todo_done_oa(p_sign_id NUMBER) IS
    v_send_msg      VARCHAR2(32767);
    v_back_msg      VARCHAR2(32767);
    v_logs_id       NUMBER;
    v_returnstate   VARCHAR2(20);
    v_message       VARCHAR2(32767);
    v_response_xml  sys.xmltype;
    v_validate_info VARCHAR2(4000);
    v_sign_code     VARCHAR2(100);
  BEGIN
    v_validate_info := get_validate_info;
  
    SELECT cso.sign_code
      INTO v_sign_code
      FROM con_sign_oa cso
     WHERE cso.sign_id = p_sign_id;
  
    FOR rcpts IN (SELECT cso.sign_id,
                         cso.sign_code,
                         su.user_name,
                         cso.creation_date,
                         su.user_id
                    FROM con_sign_oa cso, sys_user su
                   WHERE cso.sign_id = p_sign_id
                     AND su.user_id IN
                         (SELECT *
                            FROM TABLE(sys_sql_util_pkg.split(cso.resolve_users,
                                                              ',')))) LOOP
      v_send_msg := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.notify.sys.kmss.landray.com/">' || --
                    '<soapenv:Header>' || v_validate_info ||
                    '</soapenv:Header>' || --
                    '<soapenv:Body>' || --
                    '<web:deleteTodo>' || --
                    '<arg0>' || --
                    '<appName>HEC</appName>' || --
                    '<key>' || (rcpts.user_id * 10000000000 + p_sign_id) ||
                    '</key>' || --
                    '<modelId>' ||
                    (rcpts.user_id * 10000000000 + p_sign_id) ||
                    '</modelId>' || --
                    '<modelName>OA签报创建报销单</modelName>' || --
                    '<param1></param1>' || --
                    '<param2></param2>' || --
                    '<targets>{"LoginName":"' || rcpts.user_name ||
                    '"}</targets>' || --
                    '<optType>1</optType>' || --
                    '</arg0>' || --
                    ' </web:deleteTodo>' || --
                    '</soapenv:Body>' || --
                    '</soapenv:Envelope>';
    
      logs(p_cux_oa_trans_logs_id => v_logs_id,
           p_req_msg              => v_send_msg,
           p_resp_msg             => NULL,
           p_record_id            => p_sign_id,
           p_type                 => c_biz_oa_todo_done,
           p_doc_num              => v_sign_code);
    
      call_webservice(p_request_object => v_send_msg,
                      p_soap_action    => 'sendTodo',
                      p_res            => v_back_msg);
    
      logs(p_cux_oa_trans_logs_id => v_logs_id,
           p_req_msg              => NULL,
           p_resp_msg             => v_back_msg,
           p_record_id            => p_sign_id,
           p_type                 => c_biz_oa_todo_done,
           p_doc_num              => v_sign_code);
    
      v_response_xml := sys.xmltype.createxml(v_back_msg);
      SELECT extractvalue(v_response_xml,
                          '/Envelope/Body/setTodoDoneResponse/return/message'),
             extractvalue(v_response_xml,
                          '/Envelope/Body/setTodoDoneResponse/return/returnState')
        INTO v_message, v_returnstate
        FROM dual;
    
      IF (v_returnstate = '2') THEN
        NULL;
      ELSE
        logs(p_cux_oa_trans_logs_id => v_logs_id,
             p_req_msg              => NULL,
             p_resp_msg             => NULL,
             p_record_id            => p_sign_id,
             p_type                 => c_biz_oa_todo_done,
             p_error_msg            => v_message,
             p_doc_num              => v_sign_code);
      END IF;
    
    END LOOP;
  
  EXCEPTION
    WHEN OTHERS THEN
    
      logs(p_cux_oa_trans_logs_id => v_logs_id,
           p_req_msg              => NULL,
           p_resp_msg             => NULL,
           p_record_id            => p_sign_id,
           p_type                 => c_biz_oa_todo,
           p_error_msg            => SQLERRM ||
                                     dbms_utility.format_error_backtrace,
           p_doc_num              => v_sign_code);
    
  END sign_set_todo_done_oa;

  --设为已办
  PROCEDURE set_todo_done_oa(p_record_id NUMBER) IS
    v_send_msg      VARCHAR2(32767);
    v_back_msg      VARCHAR2(32767);
    v_logs_id       NUMBER;
    v_returnstate   VARCHAR2(20);
    v_message       VARCHAR2(32767);
    v_response_xml  sys.xmltype;
    v_validate_info VARCHAR2(4000);
  BEGIN
    v_validate_info := get_validate_info;
    FOR rcpts IN (SELECT t.*,
                         wwi.instance_desc,
                         (SELECT wdr.document_desc
                            FROM wfl_document_reference_vl wdr
                           WHERE ww.workflow_category = wdr.workflow_category) AS order_type,
                         su.user_name
                    FROM wfl_instance_node_recipient_oa t,
                         wfl_workflow_instance          wwi,
                         wfl_workflow                   ww,
                         sys_user                       su
                   WHERE wwi.instance_id = t.instance_id
                     AND ww.workflow_id = wwi.workflow_id
                     AND t.record_id = p_record_id
                     AND t.user_id = su.user_id) LOOP
      v_send_msg := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.notify.sys.kmss.landray.com/">' || --
                    '<soapenv:Header>' || v_validate_info ||
                    '</soapenv:Header>' || --
                    '<soapenv:Body>' || --
                    '<web:setTodoDone>' || --
                    '<arg0>' || --
                    '<appName>HEC</appName>' || --
                    '<key>' || p_record_id || '</key>' || --
                    '<modelId>' || p_record_id || '</modelId>' || --
                    '<modelName>' || rcpts.order_type || '</modelName>' || --
                    '<param1></param1>' || --
                    '<param2></param2>' || --
                    '<targets>{"LoginName":"' || rcpts.user_name ||
                    '"}</targets>' || --
                    '<optType>1</optType>' || --
                    '</arg0>' || --
                    ' </web:setTodoDone>' || --
                    '</soapenv:Body>' || --
                    '</soapenv:Envelope>';
    
      logs(p_cux_oa_trans_logs_id => v_logs_id,
           p_req_msg              => v_send_msg,
           p_resp_msg             => NULL,
           p_record_id            => p_record_id,
           p_type                 => c_biz_oa_todo_done,
           p_doc_num              => get_doc_num(p_record_id));
    
      call_webservice(p_request_object => v_send_msg,
                      p_soap_action    => 'sendTodo',
                      p_res            => v_back_msg);
    
      logs(p_cux_oa_trans_logs_id => v_logs_id,
           p_req_msg              => NULL,
           p_resp_msg             => v_back_msg,
           p_record_id            => p_record_id,
           p_type                 => c_biz_oa_todo_done,
           p_doc_num              => get_doc_num(p_record_id));
    
      v_response_xml := sys.xmltype.createxml(v_back_msg);
      SELECT extractvalue(v_response_xml,
                          '/Envelope/Body/setTodoDoneResponse/return/message'),
             extractvalue(v_response_xml,
                          '/Envelope/Body/setTodoDoneResponse/return/returnState')
        INTO v_message, v_returnstate
        FROM dual;
    
      IF (v_returnstate = '2') THEN
        UPDATE wfl_instance_node_recipient_oa r
           SET r.oa_done_sync_flag = 'Y'
         WHERE r.record_id = p_record_id;
      
        --DELETE FROM cux_oa_token c WHERE c.record_id = p_record_id;
      ELSE
        logs(p_cux_oa_trans_logs_id => v_logs_id,
             p_req_msg              => NULL,
             p_resp_msg             => NULL,
             p_record_id            => p_record_id,
             p_type                 => c_biz_oa_todo_done,
             p_error_msg            => v_message,
             p_doc_num              => get_doc_num(p_record_id));
      END IF;
    
    END LOOP;
  
  EXCEPTION
    WHEN OTHERS THEN
    
      logs(p_cux_oa_trans_logs_id => v_logs_id,
           p_req_msg              => NULL,
           p_resp_msg             => NULL,
           p_record_id            => p_record_id,
           p_type                 => c_biz_oa_todo,
           p_error_msg            => SQLERRM ||
                                     dbms_utility.format_error_backtrace,
           p_doc_num              => get_doc_num(p_record_id));
    
  END set_todo_done_oa;

  --#########################################
  --设为已办
  --#########################################
  PROCEDURE set_todo_done(p_instance_id NUMBER) IS
  BEGIN
    FOR rcpts IN (SELECT t.*
                    FROM wfl_instance_node_recipient_oa t
                   WHERE t.instance_id = p_instance_id
                     AND nvl(t.oa_sync_flag, 'N') = 'Y'
                     AND nvl(t.oa_done_sync_flag, 'N') = 'N'
                     AND EXISTS (SELECT 1
                            FROM wfl_approve_record wi
                           WHERE t.record_id = wi.rcpt_record_id)
                     AND NOT EXISTS
                   (SELECT 1
                            FROM wfl_instance_node_recipient wi
                           WHERE t.record_id = wi.record_id)) LOOP
      set_todo_done_oa(rcpts.record_id);
    END LOOP;
  
  END set_todo_done;

  --#########################################
  --删除待办
  --#########################################
  PROCEDURE delete_todo_oa(p_record_id NUMBER) IS
    v_send_msg      VARCHAR2(32767);
    v_back_msg      VARCHAR2(32767);
    v_logs_id       NUMBER;
    v_returnstate   VARCHAR2(20);
    v_message       VARCHAR2(32767);
    v_response_xml  sys.xmltype;
    v_validate_info VARCHAR2(4000);
  BEGIN
    v_validate_info := get_validate_info;
    FOR rcpts IN (SELECT t.*,
                         wwi.instance_desc,
                         (SELECT wdr.document_desc
                            FROM wfl_document_reference_vl wdr
                           WHERE ww.workflow_category = wdr.workflow_category) AS order_type,
                         su.user_name
                    FROM wfl_instance_node_recipient_oa t,
                         wfl_workflow_instance          wwi,
                         wfl_workflow                   ww,
                         sys_user                       su
                   WHERE wwi.instance_id = t.instance_id
                     AND ww.workflow_id = wwi.workflow_id
                     AND t.record_id = p_record_id
                     AND t.user_id = su.user_id) LOOP
      v_send_msg := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://webservice.notify.sys.kmss.landray.com/">' || --
                    '<soapenv:Header>' || v_validate_info ||
                    '</soapenv:Header>' || --
                    '<soapenv:Body>' || --
                    '<web:deleteTodo>' || --
                    '<arg0>' || --
                    '<appName>HEC</appName>' || --
                    '<key>' || p_record_id || '</key>' || --
                    '<modelId>' || p_record_id || '</modelId>' || --
                    '<modelName>' || rcpts.order_type || '</modelName>' || --
                    '<param1></param1>' || --
                    '<param2></param2>' || --
                    '<targets>{"LoginName":"' || rcpts.user_name ||
                    '"}</targets>' || --
                    '<optType>1</optType>' || --
                    '</arg0>' || --
                    ' </web:deleteTodo>' || --
                    '</soapenv:Body>' || --
                    '</soapenv:Envelope>';
    
      logs(p_cux_oa_trans_logs_id => v_logs_id,
           p_req_msg              => v_send_msg,
           p_resp_msg             => NULL,
           p_record_id            => p_record_id,
           p_type                 => c_biz_oa_todo_delete,
           p_doc_num              => get_doc_num(p_record_id));
    
      call_webservice(p_request_object => v_send_msg,
                      p_soap_action    => 'deleteTodo',
                      p_res            => v_back_msg);
    
      logs(p_cux_oa_trans_logs_id => v_logs_id,
           p_req_msg              => NULL,
           p_resp_msg             => v_back_msg,
           p_record_id            => p_record_id,
           p_type                 => c_biz_oa_todo_delete,
           p_doc_num              => get_doc_num(p_record_id));
    
      v_response_xml := sys.xmltype.createxml(v_back_msg);
      SELECT extractvalue(v_response_xml,
                          '/Envelope/Body/deleteTodoResponse/return/message'),
             extractvalue(v_response_xml,
                          '/Envelope/Body/deleteTodoResponse/return/returnState')
        INTO v_message, v_returnstate
        FROM dual;
    
      IF (v_returnstate = '2') THEN
        UPDATE wfl_instance_node_recipient_oa r
           SET r.oa_done_sync_flag = 'Y'
         WHERE r.record_id = p_record_id;
      
        --DELETE FROM cux_oa_token c WHERE c.record_id = p_record_id;
      ELSE
        logs(p_cux_oa_trans_logs_id => v_logs_id,
             p_req_msg              => NULL,
             p_resp_msg             => NULL,
             p_record_id            => p_record_id,
             p_type                 => c_biz_oa_todo_delete,
             p_error_msg            => v_message,
             p_doc_num              => get_doc_num(p_record_id));
      END IF;
    
    END LOOP;
  
  EXCEPTION
    WHEN OTHERS THEN
    
      logs(p_cux_oa_trans_logs_id => v_logs_id,
           p_req_msg              => NULL,
           p_resp_msg             => NULL,
           p_record_id            => p_record_id,
           p_type                 => c_biz_oa_todo_delete,
           p_error_msg            => SQLERRM ||
                                     dbms_utility.format_error_backtrace,
           p_doc_num              => get_doc_num(p_record_id));
  END delete_todo_oa;

  --#########################################
  --删除待办
  --#########################################
  PROCEDURE delete_todo(p_instance_id NUMBER) IS
  BEGIN
    set_todo_done(p_instance_id);
    FOR rcpts IN (SELECT t.*
                    FROM wfl_instance_node_recipient_oa t
                   WHERE t.instance_id = p_instance_id
                     AND nvl(t.oa_sync_flag, 'N') = 'Y'
                     AND nvl(t.oa_done_sync_flag, 'N') = 'N'
                     AND NOT EXISTS
                   (SELECT 1
                            FROM wfl_approve_record wi
                           WHERE t.record_id = wi.rcpt_record_id)
                     AND NOT EXISTS
                   (SELECT 1
                            FROM wfl_instance_node_recipient wi
                           WHERE t.record_id = wi.record_id)) LOOP
      delete_todo_oa(rcpts.record_id);
    END LOOP;
  END;

  PROCEDURE sch_log(p_log_text VARCHAR2) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    v_job_id NUMBER;
  BEGIN
    v_job_id := sch_global_pkg.jobid_get;
    IF v_job_id IS NOT NULL THEN
      sch_concurrent_job_pkg.create_log(p_log_desc      => gl_log_pkg.g_log_type_debug,
                                        p_error_message => substr(p_log_text,
                                                                  1,
                                                                  2000));
    END IF;
    COMMIT;
  END;

  PROCEDURE oa_error_and_log_op IS
    CURSOR c1 IS
      SELECT *
        FROM cp_lock_assist cl
       WHERE cl.doc_type = 'OA_ERROR_AND_LOG_O'
         AND cl.doc_id = 1
         FOR UPDATE NOWAIT;
    e_locked_error EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_locked_error, -54);
  BEGIN
    -- LOCK TABLE
    cp_lock_assist_pkg.insert_lock_info(1, 'OA_ERROR_AND_LOG_O');
    OPEN c1;
    -- 发送待办
    FOR c1 IN (SELECT *
                 FROM wfl_instance_node_recipient_oa wi
                WHERE nvl(wi.oa_sync_flag, 'N') = 'N'
                  AND EXISTS (SELECT 1
                         FROM wfl_instance_node_recipient r
                        WHERE wi.record_id = r.record_id)) LOOP
      send_todo_to_oa(c1.record_id);
    END LOOP;
  
    --手机消息
    --cux_mobile_wfl_pkg.error_op;
  
    --发送已办
    FOR rcpts IN (SELECT t.*
                    FROM wfl_instance_node_recipient_oa t
                   WHERE nvl(t.oa_sync_flag, 'N') = 'Y'
                     AND nvl(t.oa_done_sync_flag, 'N') = 'N'
                     AND EXISTS (SELECT 1
                            FROM wfl_approve_record wi
                           WHERE t.record_id = wi.rcpt_record_id)
                     AND NOT EXISTS
                   (SELECT 1
                            FROM wfl_instance_node_recipient wi
                           WHERE t.record_id = wi.record_id)) LOOP
      set_todo_done_oa(rcpts.record_id);
    END LOOP;
  
    --删除代办
    FOR rcpts IN (SELECT t.*
                    FROM wfl_instance_node_recipient_oa t
                   WHERE nvl(t.oa_sync_flag, 'N') = 'Y'
                     AND nvl(t.oa_done_sync_flag, 'N') = 'N'
                     AND NOT EXISTS
                   (SELECT 1
                            FROM wfl_approve_record wi
                           WHERE t.record_id = wi.rcpt_record_id)
                     AND NOT EXISTS
                   (SELECT 1
                            FROM wfl_instance_node_recipient wi
                           WHERE t.record_id = wi.record_id)) LOOP
      delete_todo_oa(rcpts.record_id);
    END LOOP;
  
    -- 删除OA签报待办
    FOR c_oa IN (SELECT *
                   FROM con_sign_oa cso
                  WHERE EXISTS (SELECT 1
                           FROM cux_oa_exp_ref cr
                          WHERE cr.sign_code = cso.sign_code)
                    AND NOT EXISTS
                  (SELECT 1
                           FROM cux_oa_trans_logs cot
                          WHERE cso.sign_code = cot.doc_number
                            AND cot.type = 'OA_TODO_DONE')) LOOP
      sign_set_todo_done_oa(p_sign_id => c_oa.sign_id);
    END LOOP;
  
    --清除日志
    DELETE FROM cux_oa_trans_logs t
     WHERE (t.creation_date + 300) < SYSDATE
       AND NOT EXISTS
     (SELECT 1 FROM con_sign_oa cso WHERE t.doc_number = cso.sign_code);
  
    CLOSE c1;
  EXCEPTION
    WHEN e_locked_error THEN
      RETURN;
    WHEN OTHERS THEN
      IF c1%ISOPEN THEN
        CLOSE c1;
      END IF;
  END oa_error_and_log_op;

  --#########################################
  --处理未成功发送至OA的待办和已办
  --#########################################
  PROCEDURE oa_error_and_log_op_sch IS
  BEGIN
    /*    sch_log('清理OA待办webservice日志开始 ......');
    DELETE FROM cux_oa_trans_logs t WHERE (t.creation_date + 7) < SYSDATE;
    sch_log('清理OA待办webservice日志结束');*/
  
    sch_log('重新发送出错的待办开始.....');
    -- 发送待办
    FOR c1 IN (SELECT *
                 FROM wfl_instance_node_recipient_oa wi
                WHERE nvl(wi.oa_sync_flag, 'N') = 'N'
                  AND EXISTS (SELECT 1
                         FROM wfl_instance_node_recipient r
                        WHERE wi.record_id = r.record_id)) LOOP
      send_todo_to_oa(c1.record_id);
    END LOOP;
    sch_log('重新发送出错的待办结束');
  
    -- 待办删除
    sch_log('删除未删除的待办开始.....');
    FOR rcpts IN (SELECT t.*
                    FROM wfl_instance_node_recipient_oa t
                   WHERE nvl(t.oa_sync_flag, 'N') = 'Y'
                     AND nvl(t.oa_done_sync_flag, 'N') = 'N'
                     AND NOT EXISTS
                   (SELECT 1
                            FROM wfl_instance_node_recipient wi
                           WHERE t.record_id = wi.record_id)) LOOP
      delete_todo_oa(rcpts.record_id);
    END LOOP;
    sch_log('删除未删除的待办结束');
  
    sch_log('删除日志,保留一个月');
    DELETE FROM cux_oa_trans_logs l
     WHERE (SYSDATE - trunc(l.creation_date)) > 30;
  
    sch_log('删除手机端webservice 日志');
    DELETE FROM cp_oa_trans_logs l
     WHERE (SYSDATE - trunc(l.creation_date)) > 30;
  
    sch_log('删除token');
  
    DELETE FROM sys_sso_login_session sse
     WHERE
    --万联证券,工作流待办单点登录
    --只有当待办失效时，才删除令牌
     NOT EXISTS (SELECT 1
        FROM cux_oa_token c
       WHERE c.token = sse.encrypted_sso_session_id)
     AND (SYSDATE - trunc(sse.creation_date)) > 1;
  END oa_error_and_log_op_sch;

  --#########################################
  --处理未成功发送至OA的待办和已办
  --#########################################
  FUNCTION oa_error_and_log_op_evt(p_event_id    NUMBER,
                                   p_log_id      NUMBER,
                                   p_event_param NUMBER,
                                   p_created_by  NUMBER) RETURN NUMBER IS
  BEGIN
    oa_error_and_log_op;
    RETURN evt_event_core_pkg.c_return_normal;
  END;

END cux_oa_interface_pkg;
/
