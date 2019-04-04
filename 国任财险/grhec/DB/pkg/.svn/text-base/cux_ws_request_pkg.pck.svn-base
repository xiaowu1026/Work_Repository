create or replace package cux_ws_request_pkg is

  -- Author  : PENG
  -- Created : 2018/9/20 14:58:42
  -- Purpose : 

  FUNCTION call_web_service_zj(p_ws_url          VARCHAR2,
                               p_function_name   VARCHAR2 DEFAULT NULL,
                               p_soapaction      VARCHAR2 DEFAULT NULL,
                               p_request_body    clob,
                               p_document_number VARCHAR2 DEFAULT NULL,
                               p_company_code    VARCHAR2 DEFAULT NULL,
                               p_serial_number   VARCHAR2 DEFAULT NULL,
                               p_user_name       VARCHAR2 DEFAULT NULL,
                               p_user_id         NUMBER DEFAULT 1,
                               p_inner_root_name VARCHAR2 DEFAULT NULL,
                               p_request_id      OUT NUMBER) RETURN clob;

end cux_ws_request_pkg;
/
create or replace package body cux_ws_request_pkg is

  PROCEDURE cux_ws_requests_log(x_request_id       IN OUT NUMBER,
                                p_function_name    IN VARCHAR2 DEFAULT NULL,
                                p_request_wsdl_url IN VARCHAR2 DEFAULT NULL,
                                p_responsed_date   IN DATE DEFAULT NULL,
                                p_return_status    IN VARCHAR2 DEFAULT NULL,
                                p_status_code      IN VARCHAR2 DEFAULT NULL,
                                p_status_date      IN DATE DEFAULT NULL,
                                p_request_xml      IN sys.xmltype DEFAULT NULL,
                                p_response_xml     IN sys.xmltype DEFAULT NULL,
                                p_document_number  IN VARCHAR2 DEFAULT NULL,
                                p_company_code     IN VARCHAR2 DEFAULT NULL,
                                p_serial_nuber     IN VARCHAR2 DEFAULT NULL,
                                p_user_name        IN VARCHAR2 DEFAULT NULL,
                                p_user_id          IN NUMBER) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_request_rec cux_ws_requests%ROWTYPE;
  BEGIN
    l_request_rec := NULL;
    IF x_request_id IS NULL THEN
      SELECT hls_ws_requests_s.nextval
        INTO l_request_rec.request_id
        FROM dual;
      l_request_rec.function_name    := p_function_name;
      l_request_rec.request_date     := SYSDATE;
      l_request_rec.request_wsdl_url := p_request_wsdl_url;
      l_request_rec.responsed_date   := p_responsed_date;
      l_request_rec.return_status    := p_return_status;
      l_request_rec.status_code      := p_status_code;
      l_request_rec.status_date      := p_status_date;
      l_request_rec.request_xml      := p_request_xml;
      l_request_rec.company_code     := p_company_code;
      l_request_rec.document_number  := p_document_number;
      l_request_rec.ws_serial_number := p_serial_nuber;
      l_request_rec.user_id          := p_user_id;
      l_request_rec.user_name        := p_user_name;
      INSERT INTO cux_ws_requests VALUES l_request_rec;
      x_request_id := l_request_rec.request_id;
    ELSE
      UPDATE cux_ws_requests s
         SET s.responsed_date = p_responsed_date,
             s.response_xml   = p_response_xml,
             s.return_status  = p_return_status,
             s.status_code    = 2
       WHERE s.request_id = x_request_id;
    END IF;
  
    COMMIT;
  END cux_ws_requests_log;  

  FUNCTION call_web_service_zj(p_ws_url          VARCHAR2,
                               p_function_name   VARCHAR2 DEFAULT NULL,
                               p_soapaction      VARCHAR2 DEFAULT NULL,
                               p_request_body    clob,
                               p_document_number VARCHAR2 DEFAULT NULL,
                               p_company_code    VARCHAR2 DEFAULT NULL,
                               p_serial_number   VARCHAR2 DEFAULT NULL,
                               p_user_name       VARCHAR2 DEFAULT NULL,
                               p_user_id         NUMBER DEFAULT 1,
                               p_inner_root_name VARCHAR2 DEFAULT NULL,
                               p_request_id      OUT NUMBER) RETURN clob IS
    req            utl_http.req;
    resp           utl_http.resp;
    x_response_xml sys.xmltype;
    v_url          VARCHAR2(300);
    v_value        VARCHAR2(32767);
    v_data         VARCHAR2(4000);
    v_read_text    CLOB;
    v_tmp          CLOB;
  
    v_content_length NUMBER;
  BEGIN
    dbms_lob.createtemporary(v_read_text, FALSE, dbms_lob.session);
  
    /*v_read_text    := call_http_java(p_request_body,
                                     p_ws_url,
                                     p_document_number);*/
    x_response_xml := xmltype(v_read_text);
  
    cux_ws_requests_log(x_request_id       => p_request_id,
                        p_function_name    => p_function_name,
                        p_request_wsdl_url => p_ws_url,
                        p_responsed_date   => NULL,
                        p_status_code      => '1', --已发送
                        p_status_date      => SYSDATE,
                        p_request_xml      => x_response_xml,
                        p_response_xml     => NULL,
                        p_document_number  => p_document_number,
                        p_company_code     => p_company_code,
                        p_serial_nuber     => p_serial_number,
                        p_user_name        => p_user_name,
                        p_user_id          => p_user_id);
  
    RETURN v_read_text;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              '网络通讯错误,请联系系统管理员' || SQLERRM);
  END call_web_service_zj;
end cux_ws_request_pkg;
/
