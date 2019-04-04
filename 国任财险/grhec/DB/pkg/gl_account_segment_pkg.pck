CREATE OR REPLACE PACKAGE gl_account_segment_pkg IS

  -- Author  : ZHOUHAO
  -- Created : 2012-3-22 16:12:14
  -- Purpose : 会计规则包，用于自动生成科目段值

  /*
      全局变量区
  */

  --业务类型
  g_rule_type VARCHAR2(30);

  g_rule_type_exp_report      VARCHAR2(30) := 'EXP_REPORT';
  g_rule_type_csh_transaction VARCHAR2(30) := 'CSH_TRANSACTION';
  g_rule_type_csh_write_off   VARCHAR2(30) := 'CSH_WRITE_OFF';
  g_rule_type_csh_pmt_req     VARCHAR2(30) := 'CSH_PMT_REQ';
  g_rule_type_pur_invoice     VARCHAR2(30) := 'PUR_INVOICE';
  g_rule_type_hct_fund_trans  VARCHAR2(30) := 'HCT_FUND_TRANS';
  g_rule_type_inv_transaction VARCHAR2(30) := 'INV_TRANSACTION';
  g_rule_type_pur_exp_trans   VARCHAR2(30) := 'PUR_EXP_TRANS';
  g_rule_type_ast_asset_rent  VARCHAR2(30) := 'AST_ASSET_RENT';
  g_rule_type_pur_claim       VARCHAR2(30) := 'PUR_CLAIM';
  g_rule_type_ibi_accrual     VARCHAR2(30) := 'IBI_ACCRUAL';
  g_rule_type_ibi_receipt     VARCHAR2(30) := 'IBI_RECEIPT';
  --ADDED BY GAOBO.WANG 资产类凭证
  g_rule_type_eam_req VARCHAR2(30) := 'EAM_REQUISITION';
  -- add by sunyongqing 资产折旧凭证
  g_rule_type_eam_deprn  VARCHAR2(30) := 'EAM_DEPRN';
  g_rule_type_work_order VARCHAR2(30) := 'WORK_ORDER';

  --帐套ID
  g_set_of_books_id NUMBER;
  --user_id
  g_user_id NUMBER;
  --凭证行ID
  g_je_line_id NUMBER;
  --单据头ID
  g_doc_header_id NUMBER;
  --单据行ID
  g_doc_line_id NUMBER;
  --单据分配行ID
  g_doc_dist_id NUMBER;
  --单据计划付款行ID
  g_doc_pmt_line_id NUMBER;

  --科目没有配置相应的会计规则
  g_account_rule_not_exists NUMBER := -1;

  --科目段类型
  g_segment_type_value_source   VARCHAR2(30) := 'VALUE_SOURCE';
  g_segment_type_text           VARCHAR2(30) := 'TEXT';
  g_segment_type_value_list     VARCHAR2(30) := 'VALUE_LIST';
  g_segment_type_sql_value_list VARCHAR2(30) := 'SQL_VALUE_LIST';
  g_segment_type_sql            VARCHAR2(30) := 'SQL';

  --异常区
  e_sql_query_execute_error EXCEPTION;
  e_lock_table              EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_lock_table, -54);
  e_doc_data_error          EXCEPTION;
  e_no_segment_suit_error   EXCEPTION;
  e_account_rule_not_exists EXCEPTION;

  --数据类型区

  --凭证行创建时更新segment字段
  PROCEDURE post_account_je_create(p_rule_type  VARCHAR2,
                                   p_je_line_id NUMBER,
                                   p_user_id    NUMBER);

  --凭证行更新时（更改account）更新segment字段
  PROCEDURE post_account_je_update(p_rule_type  VARCHAR2,
                                   p_je_line_id NUMBER,
                                   p_user_id    NUMBER);

END gl_account_segment_pkg;
/
CREATE OR REPLACE PACKAGE BODY gl_account_segment_pkg IS

  CURSOR cursor_exp_report IS
  
    SELECT 1
      FROM gld_segments        gs,
           gld_segments_values gsv,
           gld_segments_source gss,
           gld_rule_accounts   gra,
           gld_rule_segments   grs,
           gld_interface_rules gir,
           gld_accounts        ga,
           exp_report_accounts era
     WHERE era.exp_report_je_line_id = g_je_line_id
       AND ga.account_id = era.account_id
       AND gra.account_id = era.account_id
       AND gra.rule_id = gir.rule_id
       AND grs.rule_id = gra.rule_id
       AND gs.segment_id = grs.segment_id
       AND gsv.segment_id = gs.segment_id
       AND gss.segment_id = gs.segment_id
       FOR UPDATE NOWAIT;

  CURSOR cursor_csh_write_off IS
    SELECT 1
      FROM gld_segments           gs,
           gld_segments_values    gsv,
           gld_segments_source    gss,
           gld_rule_accounts      gra,
           gld_rule_segments      grs,
           gld_interface_rules    gir,
           gld_accounts           ga,
           csh_write_off_accounts cwo
     WHERE cwo.write_off_je_line_id = g_je_line_id
       AND ga.account_id = cwo.account_id
       AND gra.account_id = cwo.account_id
       AND gra.rule_id = gir.rule_id
       AND grs.rule_id = gra.rule_id
       AND gs.segment_id = grs.segment_id
       AND gsv.segment_id = gs.segment_id
       AND gss.segment_id = gs.segment_id
       FOR UPDATE NOWAIT;

  CURSOR cursor_csh_transaction IS
    SELECT 1
      FROM gld_segments             gs,
           gld_segments_values      gsv,
           gld_segments_source      gss,
           gld_rule_accounts        gra,
           gld_rule_segments        grs,
           gld_interface_rules      gir,
           gld_accounts             ga,
           csh_transaction_accounts cta
     WHERE cta.transaction_je_line_id = g_je_line_id
       AND ga.account_id = cta.account_id
       AND gra.account_id = cta.account_id
       AND gra.rule_id = gir.rule_id
       AND grs.rule_id = gra.rule_id
       AND gs.segment_id = grs.segment_id
       AND gsv.segment_id = gs.segment_id
       AND gss.segment_id = gs.segment_id
       FOR UPDATE NOWAIT;

  CURSOR cursor_eam_transaction IS
    SELECT 1
      FROM gld_segments             gs,
           gld_segments_values      gsv,
           gld_segments_source      gss,
           gld_rule_accounts        gra,
           gld_rule_segments        grs,
           gld_interface_rules      gir,
           gld_accounts             ga,
           eam_transaction_accounts eta
     WHERE eta.transaction_je_line_id = g_je_line_id
       AND ga.account_id = eta.account_id
       AND gra.account_id = eta.account_id
       AND gra.rule_id = gir.rule_id
       AND grs.rule_id = gra.rule_id
       AND gs.segment_id = grs.segment_id
       AND gsv.segment_id = gs.segment_id
       AND gss.segment_id = gs.segment_id
       FOR UPDATE NOWAIT;

  --获得运行环境
  FUNCTION get_execute_environment RETURN VARCHAR2 IS
    v_execute_environment VARCHAR2(2000);
  BEGIN
    SELECT 'RULE_TYPE:' || g_rule_type || ',JE_LINE_ID:' || g_je_line_id ||
           ',USER_ID:' || g_user_id
      INTO v_execute_environment
      FROM dual;
    RETURN v_execute_environment;
  END;

  PROCEDURE lock_table IS
  
  BEGIN
    IF g_rule_type = g_rule_type_exp_report THEN
      OPEN cursor_exp_report;
    END IF;
  
    IF g_rule_type = g_rule_type_csh_transaction THEN
      OPEN cursor_csh_write_off;
    END IF;
  
    IF g_rule_type = g_rule_type_csh_write_off THEN
      OPEN cursor_csh_transaction;
    END IF;
  
    --added by gaobo.wang 2013/5/22 begin
    --资产凭证
    IF g_rule_type = g_rule_type_eam_req OR
       g_rule_type = g_rule_type_eam_deprn THEN
      OPEN cursor_eam_transaction;
    END IF;
    --added by gaobo.wang 2013/5/22 end;
  EXCEPTION
    WHEN e_lock_table THEN
      gl_log_pkg.log(p_log_text        => '锁表失败',
                     p_log_environment => get_execute_environment,
                     p_user_id         => g_user_id,
                     p_rule_type       => g_rule_type,
                     p_je_line_id      => g_je_line_id,
                     p_doc_header_id   => g_doc_header_id,
                     p_package_name    => 'GL_ACCOUNT_SEGMENT_PKG',
                     p_procedure_name  => 'LOCK_TABLE');
      RAISE e_lock_table;
  END;

  PROCEDURE release_lock_table IS
  
  BEGIN
  
    IF g_rule_type = g_rule_type_exp_report AND cursor_exp_report%ISOPEN THEN
      CLOSE cursor_exp_report;
    END IF;
  
    IF g_rule_type = g_rule_type_csh_transaction AND
       cursor_csh_write_off%ISOPEN THEN
      CLOSE cursor_csh_write_off;
    END IF;
  
    IF g_rule_type = g_rule_type_csh_write_off AND
       cursor_csh_transaction%ISOPEN THEN
      CLOSE cursor_csh_transaction;
    END IF;
  
    --added by gaobo.wang 2013/5/22 begin
    --资产凭证
    IF (g_rule_type = g_rule_type_eam_req OR
       g_rule_type = g_rule_type_eam_deprn) AND
       cursor_eam_transaction%ISOPEN THEN
      CLOSE cursor_eam_transaction;
    END IF;
    --added by gaobo.wang 2013/5/22 end;
  END;

  --根据科目获得会计规则
  --如果不存在相应的组合，则返回 -1，全局变量为g_account_rule_not_exists
  FUNCTION get_rule_id_by_account(p_account_id NUMBER) RETURN NUMBER IS
    v_rule_id NUMBER;
  BEGIN
    SELECT gra.rule_id
      INTO v_rule_id
      FROM gld_rule_accounts gra, gld_interface_rules gir
     WHERE gra.account_id = p_account_id
       AND gra.rule_id = gir.rule_id
       AND gir.enabled_flag = 'Y'
       AND gra.enabled_flag = 'Y'
       AND gra.set_of_books_id = g_set_of_books_id;
  
    RETURN v_rule_id;
  EXCEPTION
    WHEN no_data_found THEN
      /*RETURN g_account_rule_not_exists;*/
      raise e_account_rule_not_exists;
  END;

  --根据凭证行ID获得会计规则
  --如果不存在相应的组合，则返回 -1，全局变量为g_account_rule_not_exists
  FUNCTION get_gl_account_rule_id RETURN NUMBER IS
    v_account_id NUMBER;
    v_rule_id    NUMBER;
  BEGIN
    IF g_rule_type = g_rule_type_exp_report THEN
      SELECT era.account_id
        INTO v_account_id
        FROM exp_report_accounts era
       WHERE era.exp_report_je_line_id = g_je_line_id;
    END IF;
    IF g_rule_type = g_rule_type_csh_transaction THEN
      SELECT cta.account_id
        INTO v_account_id
        FROM csh_transaction_accounts cta
       WHERE cta.transaction_je_line_id = g_je_line_id;
    END IF;
    IF g_rule_type = g_rule_type_csh_write_off THEN
      SELECT cwoa.account_id
        INTO v_account_id
        FROM csh_write_off_accounts cwoa
       WHERE cwoa.write_off_je_line_id = g_je_line_id;
    END IF;
    IF g_rule_type = g_rule_type_csh_pmt_req THEN
      SELECT a.account_id
        INTO v_account_id
        FROM csh_payment_req_accounts a
       WHERE a.je_line_id = g_je_line_id;
    END IF;
  
    --added by gaobo.wang 2013/5/22 begin
    --资产凭证
    IF g_rule_type = g_rule_type_eam_req OR
       g_rule_type = g_rule_type_eam_deprn THEN
      SELECT a.account_id
        INTO v_account_id
        FROM eam_transaction_accounts a
       WHERE a.transaction_je_line_id = g_je_line_id;
    END IF;
    --added by gaobo.wang 2013/5/22 end;
  
    IF g_rule_type = g_rule_type_ibi_accrual OR
       g_rule_type = g_rule_type_ibi_receipt THEN
      SELECT a.account_id
        INTO v_account_id
        FROM ibi_accounts a
       WHERE a.ibi_account_id = g_je_line_id;
    END IF;
  
    v_rule_id := get_rule_id_by_account(p_account_id => v_account_id);
  
    RETURN v_rule_id;
  END;

  PROCEDURE init_doc_ids IS
    v_exp_dist_exist_flag NUMBER;
  BEGIN
    IF g_rule_type = g_rule_type_exp_report THEN
    
      SELECT COUNT(1)
        INTO v_exp_dist_exist_flag
        FROM exp_report_accounts era
       WHERE era.exp_report_je_line_id = g_je_line_id
         AND era.exp_report_dists_id IS NOT NULL;
    
      IF v_exp_dist_exist_flag != 0 THEN
        SELECT era.exp_report_dists_id
          INTO g_doc_dist_id
          FROM exp_report_accounts era
         WHERE era.exp_report_je_line_id = g_je_line_id;
        SELECT erd.exp_report_line_id
          INTO g_doc_line_id
          FROM exp_report_dists erd
         WHERE erd.exp_report_dists_id = g_doc_dist_id;
        SELECT erl.exp_report_header_id
          INTO g_doc_header_id
          FROM exp_report_lines erl
         WHERE erl.exp_report_line_id = g_doc_line_id;
      ELSE
        SELECT era.exp_report_header_id
          INTO g_doc_header_id
          FROM exp_report_accounts era
         WHERE era.exp_report_je_line_id = g_je_line_id;
      
        g_doc_line_id := NULL;
        g_doc_dist_id := NULL;
      
      END IF;
    
    END IF;
  
    IF g_rule_type = g_rule_type_csh_transaction THEN
      SELECT cta.transaction_line_id
        INTO g_doc_line_id
        FROM csh_transaction_accounts cta
       WHERE cta.transaction_je_line_id = g_je_line_id;
      SELECT ctl.transaction_header_id
        INTO g_doc_header_id
        FROM csh_transaction_lines ctl
       WHERE ctl.transaction_line_id = g_doc_line_id;
    END IF;
  
    IF g_rule_type = g_rule_type_csh_write_off THEN
      SELECT h.transaction_header_id,
             l.transaction_line_id,
             cwoa.write_off_id
        INTO g_doc_header_id, g_doc_line_id, g_doc_dist_id
        FROM csh_write_off_accounts  cwoa,
             csh_write_off           o,
             csh_transaction_headers h,
             csh_transaction_lines   l
       WHERE cwoa.write_off_je_line_id = g_je_line_id
         AND cwoa.write_off_id = o.write_off_id
         AND o.csh_transaction_line_id = l.transaction_line_id
         AND l.transaction_header_id = h.transaction_header_id;
    END IF;
  
    --added by gaobo.wang 2013/5/22 begin
    --资产凭证
    IF g_rule_type = g_rule_type_eam_req THEN
      SELECT r.source_document_id, r.source_document_line_id, ''
        INTO g_doc_header_id, g_doc_line_id, g_doc_dist_id
        FROM eam_transaction_accounts eta, eam_document_trx_releases r
       WHERE eta.transaction_je_line_id = g_je_line_id
         AND eta.transaction_header_id = r.transaction_header_id;
    END IF;
    --added by gaobo.wang 2013/5/22 end;
  
    --add by sunyongqing@20151130
    IF g_rule_type = g_rule_type_eam_deprn THEN
      SELECT eta.transaction_header_id, '', ''
        INTO g_doc_header_id, g_doc_line_id, g_doc_dist_id
        FROM eam_transaction_accounts eta
       WHERE eta.transaction_je_line_id = g_je_line_id;
    END IF;
  
    IF g_rule_type = g_rule_type_csh_pmt_req THEN
      SELECT l.payment_requisition_header_id, l.payment_requisition_line_id
        INTO g_doc_header_id, g_doc_line_id
        FROM csh_payment_requisition_lns l, csh_payment_req_accounts a
       WHERE a.je_line_id = g_je_line_id
         AND a.payment_req_line_id = l.payment_requisition_line_id;
    END IF;
  EXCEPTION
    WHEN no_data_found THEN
      gl_log_pkg.log(p_log_text        => '凭证源单据信息错误，数据不存在,JE_LINE_ID:' ||
                                          g_je_line_id || ';DIST_ID:' ||
                                          g_doc_dist_id || ';LINE_ID:' ||
                                          g_doc_line_id || ';HEADER_ID' ||
                                          g_doc_header_id,
                     p_log_environment => get_execute_environment,
                     p_user_id         => g_user_id,
                     p_rule_type       => g_rule_type,
                     p_je_line_id      => g_je_line_id,
                     p_doc_header_id   => g_doc_header_id,
                     p_package_name    => 'GL_ACCOUNT_SEGMENT_PKG',
                     p_procedure_name  => 'INIT_DOC_IDS');
      RAISE e_doc_data_error;
  END;

  FUNCTION get_segment_sql_value(p_sql_query VARCHAR2) RETURN VARCHAR2 IS
    v_sql_query VARCHAR2(2000);
    v_sql_value VARCHAR2(200);
  BEGIN
    v_sql_query := REPLACE(p_sql_query,
                           ':RULE_TYPE',
                           '''' || g_rule_type || '''');
    v_sql_query := REPLACE(v_sql_query, ':JE_LINE_ID', g_je_line_id);
    v_sql_query := REPLACE(v_sql_query, ':DOC_HEADER_ID', g_doc_header_id);
    v_sql_query := REPLACE(v_sql_query, ':DOC_LINE_ID', g_doc_line_id);
    v_sql_query := REPLACE(v_sql_query, ':DOC_DIST_ID', g_doc_dist_id);
  
    EXECUTE IMMEDIATE v_sql_query
      INTO v_sql_value;
    RETURN v_sql_value;
  EXCEPTION
    WHEN OTHERS THEN
      gl_log_pkg.log(p_package_name    => 'GL_ACCOUNT_SEGMENT_PKG',
                     p_procedure_name  => 'GET_SEGMENT_SQL_VALUE',
                     p_log_text        => 'SQL查询执行出错！SQL语句为:' || v_sql_query,
                     p_log_environment => get_execute_environment,
                     p_user_id         => g_user_id,
                     p_rule_type       => g_rule_type,
                     p_je_line_id      => g_je_line_id);
      RAISE e_sql_query_execute_error;
  END;

  FUNCTION get_segment_value(p_rule_id NUMBER, p_segment_field VARCHAR2)
    RETURN VARCHAR2 IS
  
    v_segment_id    NUMBER;
    v_segment_type  VARCHAR2(30);
    v_sql_query     VARCHAR2(2000);
    v_default_text  VARCHAR2(200);
    v_segment_value VARCHAR2(200);
  
  BEGIN
    SELECT gs.segment_id, gs.segment_type, gs.sql_query, gs.default_text
      INTO v_segment_id, v_segment_type, v_sql_query, v_default_text
      FROM gld_rule_segments grs, gld_segments gs
     WHERE grs.rule_id = p_rule_id
       AND gs.segment_field = p_segment_field
       AND gs.segment_id = grs.segment_id
       AND gs.enabled_flag = 'Y'
       AND grs.enabled_flag = 'Y';
  
    --当该SEGMENT_FIELD 的类型为 文本时，返回默认值
    IF v_segment_type = g_segment_type_text OR
       v_segment_type = g_segment_type_value_list OR
       v_segment_type = g_segment_type_sql_value_list THEN
      RETURN v_default_text;
    END IF;
  
    --当SEGMENT_FIELD 的类型为 SQL 时，返回SQL语句执行结果
    IF v_segment_type = g_segment_type_sql THEN
      init_doc_ids;
      v_segment_value := get_segment_sql_value(v_sql_query);
      IF v_segment_value IS NULL THEN
        v_segment_value := v_default_text;
      END IF;
      RETURN v_segment_value;
    END IF;
  
    --当SEGMENT_FIELD 的类型为 取值来源时，返回取值结果
    IF v_segment_type = g_segment_type_value_source THEN
      init_doc_ids;
      v_segment_value := gl_account_seg_source_pkg.get_seg_source_value(p_rule_type       => g_rule_type,
                                                                        p_segment_id      => v_segment_id,
                                                                        p_doc_header_id   => g_doc_header_id,
                                                                        p_doc_line_id     => g_doc_line_id,
                                                                        p_doc_dist_id     => g_doc_dist_id,
                                                                        p_doc_pmt_line_id => g_doc_pmt_line_id,
                                                                        p_je_line_id      => g_je_line_id,
                                                                        p_user_id         => g_user_id);
      IF v_segment_value IS NULL THEN
        v_segment_value := v_default_text;
      END IF;
      RETURN v_segment_value;
    END IF;
  
  EXCEPTION
    WHEN no_data_found THEN
      RAISE e_no_segment_suit_error;
  END;

  PROCEDURE get_segments(p_rule_id    NUMBER,
                         p_segment1   OUT VARCHAR2,
                         p_segment2   OUT VARCHAR2,
                         p_segment3   OUT VARCHAR2,
                         p_segment4   OUT VARCHAR2,
                         p_segment5   OUT VARCHAR2,
                         p_segment6   OUT VARCHAR2,
                         p_segment7   OUT VARCHAR2,
                         p_segment8   OUT VARCHAR2,
                         p_segment9   OUT VARCHAR2,
                         p_segment10  OUT VARCHAR2,
                         p_segment11  OUT VARCHAR2,
                         p_segment12  OUT VARCHAR2,
                         p_segment13  OUT VARCHAR2,
                         p_segment14  OUT VARCHAR2,
                         p_segment15  OUT VARCHAR2,
                         p_segment16  OUT VARCHAR2,
                         p_segment17  OUT VARCHAR2,
                         p_segment18  OUT VARCHAR2,
                         p_segment19  OUT VARCHAR2,
                         p_segment20  OUT VARCHAR2,
                         p_segment_je OUT VARCHAR2) IS
    i               NUMBER;
    v_segment_temp  VARCHAR2(200);
    v_segment_field VARCHAR2(30);
    v_account_code  VARCHAR2(50);
    v_parnter_category VARCHAR2(50);
    v_parnter_id       NUMBER;
    v_amortization_accounts number;
  BEGIN   
  
   begin
    SELECT ga.account_code
      INTO v_account_code
      FROM exp_report_accounts a,gld_accounts ga
     WHERE a.exp_report_je_line_id = g_je_line_id
     and ga.account_id = a.account_id;
      -- 只要在摊销科目表中存在
      select count(*) into v_amortization_accounts 
          from exp_amortization_accounts t ,gld_accounts gl
      where gl.account_id = t.account_id
      and gl.account_code = v_account_code;
      
    exception
       when others then
         v_account_code := '';
    end;
     
    FOR i IN 1 .. 20 LOOP
      v_segment_field := 'SEGMENT' || i;
      BEGIN
        IF g_rule_type = g_rule_type_exp_report THEN
         
          /** 当科目代码为 时1221090100 时
          account_segment12 基金中心 SEGMENT2 成本中心 SEGMENT4 承诺项目 SEGMENT6 银行账号 SEGMENT7 现金流量项目 的值为null
          account_segment15 客商辅助段为 计划付款行上收款方对应的编号，如供应商对编号、员工编号
          **/
          if v_amortization_accounts > 0 then
            if v_segment_field in
               ('SEGMENT12', 'SEGMENT2', 'SEGMENT4', 'SEGMENT6', 'SEGMENT7') then
              v_segment_temp := 'NULL';
            else
              if v_segment_field = 'SEGMENT15' then                
               begin
                  select p.payee_category, p.payee_id
                  into v_parnter_category, v_parnter_id
                  from exp_report_pmt_schedules p
                 where exists
                 (select 1
                          from exp_report_accounts era
                         where era.exp_report_header_id = p.exp_report_header_id
                           and era.exp_report_je_line_id = g_je_line_id);
                   
                if v_parnter_category = 'VENDER' then
                  select t.vender_code
                    into v_segment_temp
                    from pur_system_venders t
                   where t.vender_id = v_parnter_id;
                else
                  select '16'||e.employee_code  --员工默认前面加 16 
                    into v_segment_temp
                    from exp_employees e
                   where e.employee_id = v_parnter_id;
                end if;
                   
                exception
                     when others then
                       v_segment_temp := get_segment_value(p_rule_id,
                                                    v_segment_field);
               end;
              else
                v_segment_temp := get_segment_value(p_rule_id,
                                                    v_segment_field);
              end if;
            end if;
          else
            v_segment_temp := get_segment_value(p_rule_id, v_segment_field);
          end if;
        end if;
        gl_log_pkg.log(p_log_text        => '科目段' || i || '的值为' ||
                                            v_segment_temp,
                       p_user_id         => g_user_id,
                       p_rule_type       => g_rule_type,
                       p_je_line_id      => g_je_line_id,
                       p_log_environment => get_execute_environment,
                       p_package_name    => 'GL_ACCOUNT_SEGMENT_PKG',
                       p_procedure_name  => 'GET_SEGMENTS');
      EXCEPTION
        WHEN e_no_segment_suit_error THEN
          v_segment_temp := '';
      END;
    
      IF i = 1 THEN
        p_segment1 := v_segment_temp;
      END IF;
    
      IF i = 2 THEN
        p_segment2 := v_segment_temp;
      END IF;
    
      IF i = 3 THEN
        p_segment3 := v_segment_temp;
      END IF;
    
      IF i = 4 THEN
        p_segment4 := v_segment_temp;
      END IF;
    
      IF i = 5 THEN
        p_segment5 := v_segment_temp;
      END IF;
    
      IF i = 6 THEN
        if v_segment_temp = '0' or v_segment_temp = 'null' then 
          p_segment6 := 'NULL';
        else
          p_segment6 := v_segment_temp;
        end if;
      END IF;
    
      IF i = 7 THEN
        if v_segment_temp = '0' or v_segment_temp = 'null' then 
           p_segment7 := 'NULL';
        else
          p_segment7 := v_segment_temp;
        end if;
      END IF;
    
      IF i = 8 THEN
        p_segment8 := v_segment_temp;
      END IF;
    
      IF i = 9 THEN
        p_segment9 := v_segment_temp;
      END IF;
    
      IF i = 10 THEN
        p_segment10 := v_segment_temp;
      END IF;
    
      IF i = 11 THEN
        p_segment11 := v_segment_temp;
      END IF;
    
      IF i = 12 THEN
        p_segment12 := v_segment_temp;
      END IF;
    
      IF i = 13 THEN
        p_segment13 := v_segment_temp;
      END IF;
    
      IF i = 14 THEN
        p_segment14 := v_segment_temp;
      END IF;
    
      IF i = 15 THEN
        p_segment15 := v_segment_temp;
      END IF;
    
      IF i = 16 THEN
        p_segment16 := v_segment_temp;
      END IF;
    
      IF i = 17 THEN
        p_segment17 := v_segment_temp;
      END IF;
    
      IF i = 18 THEN
        p_segment18 := v_segment_temp;
      END IF;
    
      IF i = 19 THEN
        p_segment19 := v_segment_temp;
      END IF;
    
      IF i = 20 THEN
        p_segment20 := v_segment_temp;
      END IF;
    
    END LOOP;
    BEGIN
      p_segment_je := gl_je_category_pkg.get_je_category_code(p_rule_type  => g_rule_type,
                                                              p_je_line_id => g_je_line_id);
      gl_log_pkg.log(p_log_text        => '凭证类型段的值为' || p_segment_je,
                     p_user_id         => g_user_id,
                     p_rule_type       => g_rule_type,
                     p_je_line_id      => g_je_line_id,
                     p_log_environment => get_execute_environment,
                     p_package_name    => 'GL_ACCOUNT_SEGMENT_PKG',
                     p_procedure_name  => 'GET_SEGMENTS');
    
    EXCEPTION
      WHEN e_no_segment_suit_error THEN
        p_segment_je := '';
    END;
  
  END;

  PROCEDURE set_exp_report_segments(p_segment1   VARCHAR2,
                                    p_segment2   VARCHAR2,
                                    p_segment3   VARCHAR2,
                                    p_segment4   VARCHAR2,
                                    p_segment5   VARCHAR2,
                                    p_segment6   VARCHAR2,
                                    p_segment7   VARCHAR2,
                                    p_segment8   VARCHAR2,
                                    p_segment9   VARCHAR2,
                                    p_segment10  VARCHAR2,
                                    p_segment11  VARCHAR2,
                                    p_segment12  VARCHAR2,
                                    p_segment13  VARCHAR2,
                                    p_segment14  VARCHAR2,
                                    p_segment15  VARCHAR2,
                                    p_segment16  VARCHAR2,
                                    p_segment17  VARCHAR2,
                                    p_segment18  VARCHAR2,
                                    p_segment19  VARCHAR2,
                                    p_segment20  VARCHAR2,
                                    p_segment_je VARCHAR2) IS
  
  BEGIN
    UPDATE exp_report_accounts era
       SET era.account_segment1  = p_segment1,
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
           era.account_segment12 = p_segment12,
           era.account_segment13 = p_segment13,
           era.account_segment14 = p_segment14,
           era.account_segment15 = p_segment15,
           era.account_segment16 = p_segment16,
           era.account_segment17 = p_segment17,
           era.account_segment18 = p_segment18,
           era.account_segment19 = p_segment19,
           era.account_segment20 = p_segment20,
           era.je_category_code  = p_segment_je
     WHERE era.exp_report_je_line_id = g_je_line_id;
  END;

  PROCEDURE set_csh_transaction_segments(p_segment1   VARCHAR2,
                                         p_segment2   VARCHAR2,
                                         p_segment3   VARCHAR2,
                                         p_segment4   VARCHAR2,
                                         p_segment5   VARCHAR2,
                                         p_segment6   VARCHAR2,
                                         p_segment7   VARCHAR2,
                                         p_segment8   VARCHAR2,
                                         p_segment9   VARCHAR2,
                                         p_segment10  VARCHAR2,
                                         p_segment11  VARCHAR2,
                                         p_segment12  VARCHAR2,
                                         p_segment13  VARCHAR2,
                                         p_segment14  VARCHAR2,
                                         p_segment15  VARCHAR2,
                                         p_segment16  VARCHAR2,
                                         p_segment17  VARCHAR2,
                                         p_segment18  VARCHAR2,
                                         p_segment19  VARCHAR2,
                                         p_segment20  VARCHAR2,
                                         p_segment_je VARCHAR2) IS
  
  BEGIN
    UPDATE csh_transaction_accounts cta
       SET cta.account_segment1  = p_segment1,
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
           cta.account_segment12 = p_segment12,
           cta.account_segment13 = p_segment13,
           cta.account_segment14 = p_segment14,
           cta.account_segment15 = p_segment15,
           cta.account_segment16 = p_segment16,
           cta.account_segment17 = p_segment17,
           cta.account_segment18 = p_segment18,
           cta.account_segment19 = p_segment19,
           cta.account_segment20 = p_segment20,
           cta.je_category_code  = p_segment_je
     WHERE cta.transaction_je_line_id = g_je_line_id;
  END;

  PROCEDURE set_csh_write_off_segments(p_segment1   VARCHAR2,
                                       p_segment2   VARCHAR2,
                                       p_segment3   VARCHAR2,
                                       p_segment4   VARCHAR2,
                                       p_segment5   VARCHAR2,
                                       p_segment6   VARCHAR2,
                                       p_segment7   VARCHAR2,
                                       p_segment8   VARCHAR2,
                                       p_segment9   VARCHAR2,
                                       p_segment10  VARCHAR2,
                                       p_segment11  VARCHAR2,
                                       p_segment12  VARCHAR2,
                                       p_segment13  VARCHAR2,
                                       p_segment14  VARCHAR2,
                                       p_segment15  VARCHAR2,
                                       p_segment16  VARCHAR2,
                                       p_segment17  VARCHAR2,
                                       p_segment18  VARCHAR2,
                                       p_segment19  VARCHAR2,
                                       p_segment20  VARCHAR2,
                                       p_segment_je VARCHAR2) IS
  
  BEGIN
    UPDATE csh_write_off_accounts cwoa
       SET cwoa.account_segment1  = p_segment1,
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
           cwoa.account_segment12 = p_segment12,
           cwoa.account_segment13 = p_segment13,
           cwoa.account_segment14 = p_segment14,
           cwoa.account_segment15 = p_segment15,
           cwoa.account_segment16 = p_segment16,
           cwoa.account_segment17 = p_segment17,
           cwoa.account_segment18 = p_segment18,
           cwoa.account_segment19 = p_segment19,
           cwoa.account_segment20 = p_segment20,
           cwoa.je_category_code  = p_segment_je
     WHERE cwoa.write_off_je_line_id = g_je_line_id;
  END;

  PROCEDURE set_csh_pmt_req_segments(p_segment1   VARCHAR2,
                                     p_segment2   VARCHAR2,
                                     p_segment3   VARCHAR2,
                                     p_segment4   VARCHAR2,
                                     p_segment5   VARCHAR2,
                                     p_segment6   VARCHAR2,
                                     p_segment7   VARCHAR2,
                                     p_segment8   VARCHAR2,
                                     p_segment9   VARCHAR2,
                                     p_segment10  VARCHAR2,
                                     p_segment11  VARCHAR2,
                                     p_segment12  VARCHAR2,
                                     p_segment13  VARCHAR2,
                                     p_segment14  VARCHAR2,
                                     p_segment15  VARCHAR2,
                                     p_segment16  VARCHAR2,
                                     p_segment17  VARCHAR2,
                                     p_segment18  VARCHAR2,
                                     p_segment19  VARCHAR2,
                                     p_segment20  VARCHAR2,
                                     p_segment_je VARCHAR2) IS
  
  BEGIN
    UPDATE csh_payment_req_accounts cpra
       SET cpra.account_segment1  = p_segment1,
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
           cpra.account_segment12 = p_segment12,
           cpra.account_segment13 = p_segment13,
           cpra.account_segment14 = p_segment14,
           cpra.account_segment15 = p_segment15,
           cpra.account_segment16 = p_segment16,
           cpra.account_segment17 = p_segment17,
           cpra.account_segment18 = p_segment18,
           cpra.account_segment19 = p_segment19,
           cpra.account_segment20 = p_segment20,
           cpra.je_category_code  = p_segment_je
     WHERE cpra.je_line_id = g_je_line_id;
  END;

  PROCEDURE set_eam_req_segments(p_segment1   VARCHAR2,
                                 p_segment2   VARCHAR2,
                                 p_segment3   VARCHAR2,
                                 p_segment4   VARCHAR2,
                                 p_segment5   VARCHAR2,
                                 p_segment6   VARCHAR2,
                                 p_segment7   VARCHAR2,
                                 p_segment8   VARCHAR2,
                                 p_segment9   VARCHAR2,
                                 p_segment10  VARCHAR2,
                                 p_segment11  VARCHAR2,
                                 p_segment12  VARCHAR2,
                                 p_segment13  VARCHAR2,
                                 p_segment14  VARCHAR2,
                                 p_segment15  VARCHAR2,
                                 p_segment16  VARCHAR2,
                                 p_segment17  VARCHAR2,
                                 p_segment18  VARCHAR2,
                                 p_segment19  VARCHAR2,
                                 p_segment20  VARCHAR2,
                                 p_segment_je VARCHAR2) IS
  
  BEGIN
    UPDATE eam_transaction_accounts eta
       SET eta.company_segment1  = p_segment1,
           eta.company_segment2  = p_segment2,
           eta.company_segment3  = p_segment3,
           eta.company_segment4  = p_segment4,
           eta.company_segment5  = p_segment5,
           eta.company_segment6  = p_segment6,
           eta.company_segment7  = p_segment7,
           eta.company_segment8  = p_segment8,
           eta.company_segment9  = p_segment9,
           eta.company_segment10 = p_segment10,
           eta.company_segment11 = p_segment11,
           eta.company_segment12 = p_segment12,
           eta.company_segment13 = p_segment13,
           eta.company_segment14 = p_segment14,
           eta.company_segment15 = p_segment15,
           eta.company_segment16 = p_segment16,
           eta.company_segment17 = p_segment17,
           eta.company_segment18 = p_segment18,
           eta.company_segment19 = p_segment19,
           eta.company_segment20 = p_segment20
    
    --modified by gaobo.wang 2013/6/4 beign
    --暂不更新此字段
    /*,
    eta.je_category_code  = p_segment_je*/
    --modified by gaobo.wang 2013/6/4 end;
     WHERE eta.transaction_je_line_id = g_je_line_id;
  END;

  PROCEDURE set_ibi_segments(p_segment1   VARCHAR2,
                             p_segment2   VARCHAR2,
                             p_segment3   VARCHAR2,
                             p_segment4   VARCHAR2,
                             p_segment5   VARCHAR2,
                             p_segment6   VARCHAR2,
                             p_segment7   VARCHAR2,
                             p_segment8   VARCHAR2,
                             p_segment9   VARCHAR2,
                             p_segment10  VARCHAR2,
                             p_segment11  VARCHAR2,
                             p_segment12  VARCHAR2,
                             p_segment13  VARCHAR2,
                             p_segment14  VARCHAR2,
                             p_segment15  VARCHAR2,
                             p_segment16  VARCHAR2,
                             p_segment17  VARCHAR2,
                             p_segment18  VARCHAR2,
                             p_segment19  VARCHAR2,
                             p_segment20  VARCHAR2,
                             p_segment_je VARCHAR2) IS
  
  BEGIN
    UPDATE ibi_accounts a
       SET a.account_segment1  = p_segment1,
           a.account_segment2  = p_segment2,
           a.account_segment3  = p_segment3,
           a.account_segment4  = p_segment4,
           a.account_segment5  = p_segment5,
           a.account_segment6  = p_segment6,
           a.account_segment7  = p_segment7,
           a.account_segment8  = p_segment8,
           a.account_segment9  = p_segment9,
           a.account_segment10 = p_segment10,
           a.account_segment11 = p_segment11,
           a.account_segment12 = p_segment12,
           a.account_segment13 = p_segment13,
           a.account_segment14 = p_segment14,
           a.account_segment15 = p_segment15,
           a.account_segment16 = p_segment16,
           a.account_segment17 = p_segment17,
           a.account_segment18 = p_segment18,
           a.account_segment19 = p_segment19,
           a.account_segment20 = p_segment20
     WHERE a.ibi_account_id = g_je_line_id;
  END;

  PROCEDURE set_segments(p_segment1   VARCHAR2,
                         p_segment2   VARCHAR2,
                         p_segment3   VARCHAR2,
                         p_segment4   VARCHAR2,
                         p_segment5   VARCHAR2,
                         p_segment6   VARCHAR2,
                         p_segment7   VARCHAR2,
                         p_segment8   VARCHAR2,
                         p_segment9   VARCHAR2,
                         p_segment10  VARCHAR2,
                         p_segment11  VARCHAR2,
                         p_segment12  VARCHAR2,
                         p_segment13  VARCHAR2,
                         p_segment14  VARCHAR2,
                         p_segment15  VARCHAR2,
                         p_segment16  VARCHAR2,
                         p_segment17  VARCHAR2,
                         p_segment18  VARCHAR2,
                         p_segment19  VARCHAR2,
                         p_segment20  VARCHAR2,
                         p_segment_je VARCHAR2) IS
  
  BEGIN
    IF g_rule_type = g_rule_type_exp_report THEN
      set_exp_report_segments(p_segment1,
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
                              p_segment13,
                              p_segment14,
                              p_segment15,
                              p_segment16,
                              p_segment17,
                              p_segment18,
                              p_segment19,
                              p_segment20,
                              p_segment_je);
    END IF;
    IF g_rule_type = g_rule_type_csh_transaction THEN
      set_csh_transaction_segments(p_segment1,
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
                                   p_segment13,
                                   p_segment14,
                                   p_segment15,
                                   p_segment16,
                                   p_segment17,
                                   p_segment18,
                                   p_segment19,
                                   p_segment20,
                                   p_segment_je);
    END IF;
    IF g_rule_type = g_rule_type_csh_write_off THEN
      set_csh_write_off_segments(p_segment1,
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
                                 p_segment13,
                                 p_segment14,
                                 p_segment15,
                                 p_segment16,
                                 p_segment17,
                                 p_segment18,
                                 p_segment19,
                                 p_segment20,
                                 p_segment_je);
    END IF;
    IF g_rule_type = g_rule_type_csh_pmt_req THEN
      set_csh_pmt_req_segments(p_segment1,
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
                               p_segment13,
                               p_segment14,
                               p_segment15,
                               p_segment16,
                               p_segment17,
                               p_segment18,
                               p_segment19,
                               p_segment20,
                               p_segment_je);
    END IF;
  
    --added by gaobo.wang 2013/5/22 begin
    --资产类凭证逻辑补充
    IF g_rule_type = g_rule_type_eam_req OR
       g_rule_type = g_rule_type_eam_deprn THEN
      set_eam_req_segments(p_segment1,
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
                           p_segment13,
                           p_segment14,
                           p_segment15,
                           p_segment16,
                           p_segment17,
                           p_segment18,
                           p_segment19,
                           p_segment20,
                           p_segment_je);
    END IF;
    --added by gaobo.wang 2013/5/22 end;
  
    IF g_rule_type = g_rule_type_ibi_accrual OR
       g_rule_type = g_rule_type_ibi_receipt THEN
      set_ibi_segments(p_segment1,
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
                       p_segment13,
                       p_segment14,
                       p_segment15,
                       p_segment16,
                       p_segment17,
                       p_segment18,
                       p_segment19,
                       p_segment20,
                       p_segment_je);
    
    END IF;
  END;

  --凭证行创建时更新segment字段
  PROCEDURE post_account_je_create(p_rule_type  VARCHAR2,
                                   p_je_line_id NUMBER,
                                   p_user_id    NUMBER) IS
    v_gl_account_rule_id NUMBER;
  
    v_segment1   VARCHAR2(200);
    v_segment2   VARCHAR2(200);
    v_segment3   VARCHAR2(200);
    v_segment4   VARCHAR2(200);
    v_segment5   VARCHAR2(200);
    v_segment6   VARCHAR2(200);
    v_segment7   VARCHAR2(200);
    v_segment8   VARCHAR2(200);
    v_segment9   VARCHAR2(200);
    v_segment10  VARCHAR2(200);
    v_segment11  VARCHAR2(200);
    v_segment12  VARCHAR2(200);
    v_segment13  VARCHAR2(200);
    v_segment14  VARCHAR2(200);
    v_segment15  VARCHAR2(200);
    v_segment16  VARCHAR2(200);
    v_segment17  VARCHAR2(200);
    v_segment18  VARCHAR2(200);
    v_segment19  VARCHAR2(200);
    v_segment20  VARCHAR2(200);
    v_segment_je VARCHAR2(200);
  
    v_company_id NUMBER;
    v_erp_type   VARCHAR2(30);
  
  BEGIN
    release_lock_table;
    g_rule_type  := p_rule_type;
    g_je_line_id := p_je_line_id;
    g_user_id    := p_user_id;
  
    v_company_id := gl_common_pkg.
                    get_doc_header_company_id(p_je_line_id => p_je_line_id,
                                              p_rule_type  => p_rule_type,
                                              p_user_id    => p_user_id);
  
    g_set_of_books_id := gld_common_pkg.get_set_of_books_id(p_comany_id => v_company_id);
  
    gl_log_pkg.log(p_log_text        => '获取单据头公司ID为：' || v_company_id,
                   p_user_id         => p_user_id,
                   p_rule_type       => g_rule_type,
                   p_je_line_id      => g_je_line_id,
                   p_log_environment => get_execute_environment,
                   p_package_name    => 'GL_ACCOUNT_SEGMENT_PKG',
                   p_procedure_name  => 'POST_ACCOUNT_JE_CREATE');
  
    v_erp_type := sys_parameter_pkg.value(p_parameter_code => 'SYS_INTERFACE_TYPE',
                                          p_company_id     => v_company_id);
  
    gl_log_pkg.log(p_log_text        => '获取ERP接口类型为：' || v_erp_type,
                   p_user_id         => p_user_id,
                   p_rule_type       => g_rule_type,
                   p_je_line_id      => g_je_line_id,
                   p_log_environment => get_execute_environment,
                   p_package_name    => 'GL_ACCOUNT_SEGMENT_PKG',
                   p_procedure_name  => 'POST_ACCOUNT_JE_CREATE');
  
    --if v_erp_type = 'EBS-GL' or v_erp_type = 'SAP-GL' then
    
    --锁相关表
    lock_table;
  
    gl_log_pkg.log(p_log_text        => '凭证行开始生成科目段值',
                   p_user_id         => p_user_id,
                   p_rule_type       => g_rule_type,
                   p_je_line_id      => g_je_line_id,
                   p_log_environment => get_execute_environment,
                   p_package_name    => 'GL_ACCOUNT_SEGMENT_PKG',
                   p_procedure_name  => 'POST_ACCOUNT_JE_CREATE');
  
    v_gl_account_rule_id := get_gl_account_rule_id;
  
    --获取科目段值
    get_segments(v_gl_account_rule_id,
                 v_segment1,
                 v_segment2,
                 v_segment3,
                 v_segment4,
                 v_segment5,
                 v_segment6,
                 v_segment7,
                 v_segment8,
                 v_segment9,
                 v_segment10,
                 v_segment11,
                 v_segment12,
                 v_segment13,
                 v_segment14,
                 v_segment15,
                 v_segment16,
                 v_segment17,
                 v_segment18,
                 v_segment19,
                 v_segment20,
                 v_segment_je);
  
    --当系统参数指定里面的ERP类型为EBS-GL的时候进行CCID验证
    IF v_erp_type = 'EBS-GL' THEN
      gl_common_pkg.ebs_ccid_validate(v_company_id,
                                      v_segment1,
                                      v_segment2,
                                      v_segment3,
                                      v_segment4,
                                      v_segment5,
                                      v_segment6,
                                      v_segment7,
                                      v_segment8,
                                      v_segment9,
                                      v_segment10,
                                      v_segment11,
                                      v_segment12,
                                      v_segment13,
                                      v_segment14,
                                      v_segment15,
                                      v_segment16,
                                      v_segment17,
                                      v_segment18,
                                      v_segment19,
                                      v_segment20);
    END IF;
  
    --设置科目段值
    set_segments(v_segment1,
                 v_segment2,
                 v_segment3,
                 v_segment4,
                 v_segment5,
                 v_segment6,
                 v_segment7,
                 v_segment8,
                 v_segment9,
                 v_segment10,
                 v_segment11,
                 v_segment12,
                 v_segment13,
                 v_segment14,
                 v_segment15,
                 v_segment16,
                 v_segment17,
                 v_segment18,
                 v_segment19,
                 v_segment20,
                 v_segment_je);
    --释放锁表
    release_lock_table;
  
    --end if;
  EXCEPTION
    WHEN e_sql_query_execute_error THEN
      release_lock_table;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'GL_SEG_SQL_QUERY_EXECUTE_ERROR',
                                                      p_created_by              => g_user_id,
                                                      p_package_name            => 'GL_ACCOUNT_SEGMENT_PKG',
                                                      p_procedure_function_name => 'GET_SEGMENT_SQL_VALUE');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_lock_table THEN
      release_lock_table;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'GL_LOCK_TABLE_FALIED_ERROR',
                                                      p_created_by              => g_user_id,
                                                      p_package_name            => 'GL_ACCOUNT_SEGMENT_PKG',
                                                      p_procedure_function_name => 'POST_ACCOUNT_JE_CREATE');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_doc_data_error THEN
      release_lock_table;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'GL_DOCUMENT_DATA_ERROR',
                                                      p_created_by              => g_user_id,
                                                      p_package_name            => 'GL_ACCOUNT_SEGMENT_PKG',
                                                      p_procedure_function_name => 'INIT_DOC_IDS');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN gl_common_pkg.e_no_doc_header_com_id THEN
      release_lock_table;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'GL_DOCUMENT_DATA_ERROR',
                                                      p_created_by              => g_user_id,
                                                      p_package_name            => 'GL_COMMON_PKG',
                                                      p_procedure_function_name => 'GET_DOC_HEADER_COMPANY_ID');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN gl_common_pkg.e_ebs_sob_id_null THEN
      release_lock_table;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'GL_EBS_SOB_ID_NOT_EXISTS',
                                                      p_created_by              => g_user_id,
                                                      p_package_name            => 'GL_COMMON_PKG',
                                                      p_procedure_function_name => 'EBS_CCID_VALIDATE');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN gl_common_pkg.e_ebs_ccid_null THEN
      release_lock_table;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'GL_EBS_CCID_VALIDATE_FAILED',
                                                      p_created_by              => g_user_id,
                                                      p_package_name            => 'GL_COMMON_PKG',
                                                      p_procedure_function_name => 'EBS_CCID_VALIDATE',
                                                      p_token_1                 => '#SEGMENTS',
                                                      p_token_value_1           => gl_common_pkg.g_segments);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_account_rule_not_exists THEN
      release_lock_table;
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '会计科目没有配置到会计规则定义中，请联系系统管理员!',
                                                     p_created_by              => 1,
                                                     p_package_name            => 'GL_ACCOUNT_SEGMENT_PKG',
                                                     p_procedure_function_name => 'GET_SEGMENTS');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  --凭证行更新时（更改account）更新segment字段
  PROCEDURE post_account_je_update(p_rule_type  VARCHAR2,
                                   p_je_line_id NUMBER,
                                   p_user_id    NUMBER) IS
    v_gl_account_rule_id NUMBER;
  
    v_segment1   VARCHAR2(200);
    v_segment2   VARCHAR2(200);
    v_segment3   VARCHAR2(200);
    v_segment4   VARCHAR2(200);
    v_segment5   VARCHAR2(200);
    v_segment6   VARCHAR2(200);
    v_segment7   VARCHAR2(200);
    v_segment8   VARCHAR2(200);
    v_segment9   VARCHAR2(200);
    v_segment10  VARCHAR2(200);
    v_segment11  VARCHAR2(200);
    v_segment12  VARCHAR2(200);
    v_segment13  VARCHAR2(200);
    v_segment14  VARCHAR2(200);
    v_segment15  VARCHAR2(200);
    v_segment16  VARCHAR2(200);
    v_segment17  VARCHAR2(200);
    v_segment18  VARCHAR2(200);
    v_segment19  VARCHAR2(200);
    v_segment20  VARCHAR2(200);
    v_segment_je VARCHAR2(200);
  
    v_company_id NUMBER;
    v_erp_type   VARCHAR2(30);
  BEGIN
  
    v_company_id := gl_common_pkg.
                    get_doc_header_company_id(p_je_line_id => p_je_line_id,
                                              p_rule_type  => p_rule_type,
                                              p_user_id    => p_user_id);
  
    g_set_of_books_id := gld_common_pkg.get_set_of_books_id(p_comany_id => v_company_id);
  
    v_erp_type := sys_parameter_pkg.value(p_parameter_code => 'SYS_INTERFACE_TYPE',
                                          p_company_id     => v_company_id);
  
    /*IF v_erp_type = 'EBS-GL' OR v_erp_type = 'SAP-GL' THEN*/
    g_rule_type  := p_rule_type;
    g_je_line_id := p_je_line_id;
    g_user_id    := p_user_id;
  
    --锁相关表
    lock_table;
  
    gl_log_pkg.log(p_log_text        => '凭证行开始生成科目段值',
                   p_user_id         => p_user_id,
                   p_rule_type       => g_rule_type,
                   p_je_line_id      => g_je_line_id,
                   p_log_environment => get_execute_environment,
                   p_package_name    => 'GL_ACCOUNT_SEGMENT_PKG',
                   p_procedure_name  => 'POST_ACCOUNT_JE_UPDATE');
  
    v_gl_account_rule_id := get_gl_account_rule_id;
  
    get_segments(v_gl_account_rule_id,
                 v_segment1,
                 v_segment2,
                 v_segment3,
                 v_segment4,
                 v_segment5,
                 v_segment6,
                 v_segment7,
                 v_segment8,
                 v_segment9,
                 v_segment10,
                 v_segment11,
                 v_segment12,
                 v_segment13,
                 v_segment14,
                 v_segment15,
                 v_segment16,
                 v_segment17,
                 v_segment18,
                 v_segment19,
                 v_segment20,
                 v_segment_je);
  
    --当系统参数指定里面的ERP类型为EBS-GL的时候进行CCID验证
    IF v_erp_type = 'EBS-GL' THEN
      gl_common_pkg.ebs_ccid_validate(v_company_id,
                                      v_segment1,
                                      v_segment2,
                                      v_segment3,
                                      v_segment4,
                                      v_segment5,
                                      v_segment6,
                                      v_segment7,
                                      v_segment8,
                                      v_segment9,
                                      v_segment10,
                                      v_segment11,
                                      v_segment12,
                                      v_segment13,
                                      v_segment14,
                                      v_segment15,
                                      v_segment16,
                                      v_segment17,
                                      v_segment18,
                                      v_segment19,
                                      v_segment20);
    END IF;
  
    set_segments(v_segment1,
                 v_segment2,
                 v_segment3,
                 v_segment4,
                 v_segment5,
                 v_segment6,
                 v_segment7,
                 v_segment8,
                 v_segment9,
                 v_segment10,
                 v_segment11,
                 v_segment12,
                 v_segment13,
                 v_segment14,
                 v_segment15,
                 v_segment16,
                 v_segment17,
                 v_segment18,
                 v_segment19,
                 v_segment20,
                 v_segment_je);
    --释放锁表
    release_lock_table;
    /* END IF;*/
  EXCEPTION
    WHEN e_sql_query_execute_error THEN
      release_lock_table;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'GL_SEG_SQL_QUERY_EXECUTE_ERROR',
                                                      p_created_by              => g_user_id,
                                                      p_package_name            => 'GL_ACCOUNT_SEGMENT_PKG',
                                                      p_procedure_function_name => 'GET_SEGMENT_SQL_VALUE');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_lock_table THEN
      release_lock_table;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'GL_LOCK_TABLE_FALIED_ERROR',
                                                      p_created_by              => g_user_id,
                                                      p_package_name            => 'GL_ACCOUNT_SEGMENT_PKG',
                                                      p_procedure_function_name => 'POST_ACCOUNT_JE_UPDATE');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_doc_data_error THEN
      release_lock_table;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'GL_DOCUMENT_DATA_ERROR',
                                                      p_created_by              => g_user_id,
                                                      p_package_name            => 'GL_ACCOUNT_SEGMENT_PKG',
                                                      p_procedure_function_name => 'INIT_DOC_IDS');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN gl_common_pkg.e_no_doc_header_com_id THEN
      release_lock_table;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'GL_DOCUMENT_DATA_ERROR',
                                                      p_created_by              => g_user_id,
                                                      p_package_name            => 'GL_COMMON_PKG',
                                                      p_procedure_function_name => 'GET_DOC_HEADER_COMPANY_ID');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN gl_common_pkg.e_ebs_sob_id_null THEN
      release_lock_table;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'GL_EBS_SOB_ID_NOT_EXISTS',
                                                      p_created_by              => g_user_id,
                                                      p_package_name            => 'GL_COMMON_PKG',
                                                      p_procedure_function_name => 'EBS_CCID_VALIDATE');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN gl_common_pkg.e_ebs_ccid_null THEN
      release_lock_table;
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'GL_EBS_CCID_VALIDATE_FAILED',
                                                      p_created_by              => g_user_id,
                                                      p_package_name            => 'GL_COMMON_PKG',
                                                      p_procedure_function_name => 'EBS_CCID_VALIDATE');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN e_account_rule_not_exists THEN
      release_lock_table;
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '会计科目没有配置到会计规则定义中，请联系系统管理员!',
                                                     p_created_by              => 1,
                                                     p_package_name            => 'GL_ACCOUNT_SEGMENT_PKG',
                                                     p_procedure_function_name => 'GET_SEGMENTS');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

END gl_account_segment_pkg;
/
