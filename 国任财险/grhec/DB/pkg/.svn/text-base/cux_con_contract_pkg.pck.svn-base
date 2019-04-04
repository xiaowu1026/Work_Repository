CREATE OR REPLACE PACKAGE cux_con_contract_pkg IS

  -- Author  : CARLOS
  -- Created : 2013/3/26 17:51:50
  -- Purpose :

  c_preextract_account_code CONSTANT VARCHAR2(200) := '2241070000';

  --合同授益期批量分配
  PROCEDURE execute_add_return_period(p_contract_header_id NUMBER,
                                      p_period_from        VARCHAR2,
                                      p_period_to          VARCHAR2,
                                      p_user_id            NUMBER);

  /*  procedure delete_contract_hds_assign_tmp(p_session_id number);
  
  procedure insert_contract_hds_assign_tmp(p_session_id         number,
                                           p_contract_header_id number);
  
  procedure insert_contract_hds_assign(p_session_id number,
                                       p_company_id number,
                                       p_user_id    number);*/

  /*************************************************
  -- Author  : RICK
  -- Created : 2018-9-13 19:41:44
  -- Purpose : 合同受益期分摊校验
  **************************************************/
  PROCEDURE check_anotation(p_contract_return_period_id NUMBER,
                            p_user_id                   NUMBER);

  /*************************************************
  -- Author  : RICK
  -- Created : 2018-9-13 19:41:44
  -- Purpose : 合同受益期删除
  **************************************************/
  PROCEDURE delete_anotation(p_contract_return_period_id NUMBER,
                             p_user_id                   NUMBER);

  /*************************************************
  -- Author  : RICK
  -- Created : 2018-9-13 19:41:44
  -- Purpose : 合同受益期分摊插入
  **************************************************/
  PROCEDURE insert_anotation(p_contract_return_period_id NUMBER,
                             p_company_id                NUMBER,
                             p_unit_id                   NUMBER,
                             p_expense_item_id           NUMBER,
                             p_invoice_sales_amount      NUMBER,
                             p_user_id                   NUMBER,
                             p_responsibility_center_id  NUMBER);

  /*************************************************
  -- Author  : RICK
  -- Created : 2018-9-13 19:41:44
  -- Purpose : 合同预提
  **************************************************/
  PROCEDURE preextract_contract(p_con_preextract_accounts_h_id OUT NUMBER,
                                p_contract_header_id           NUMBER,
                                p_contract_return_period_ids   VARCHAR2,
                                p_user_id                      NUMBER);

  FUNCTION get_return_periods(p_contract_return_period_ids VARCHAR2)
    RETURN VARCHAR2;

  /*************************************************
  -- Author  : RICK
  -- Created : 2018-9-13 19:41:44
  -- Purpose : 修改预提凭证状态
  **************************************************/
  PROCEDURE set_preextract_accounts_status(p_con_preextract_accounts_h_id NUMBER,
                                           p_status                       VARCHAR2,
                                           p_user_id                      NUMBER);

END cux_con_contract_pkg;
/
CREATE OR REPLACE PACKAGE BODY cux_con_contract_pkg IS

  FUNCTION get_contract_return_period_id RETURN NUMBER IS
    v_contract_return_period_id con_contract_return_periods.contract_return_period_id%TYPE;
  BEGIN
    SELECT con_contract_return_periods_s.nextval
      INTO v_contract_return_period_id
      FROM dual;
    RETURN v_contract_return_period_id;
  END get_contract_return_period_id;

  --合同授益期批量分配
  PROCEDURE execute_add_return_period(p_contract_header_id NUMBER,
                                      p_period_from        VARCHAR2,
                                      p_period_to          VARCHAR2,
                                      p_user_id            NUMBER) IS
    v_company_id                NUMBER;
    v_period_set_code           VARCHAR2(30);
    v_max_line_num              NUMBER;
    v_exists                    NUMBER;
    v_contract_return_period_id con_contract_return_periods.contract_return_period_id%TYPE;
  
    v_total_amount       NUMBER;
    v_period_count       NUMBER;
    v_total_sales_amount NUMBER;
  BEGIN
  
    IF p_period_from IS NOT NULL AND p_period_to IS NOT NULL THEN
      SELECT h.company_id
        INTO v_company_id
        FROM con_contract_headers h
       WHERE h.contract_header_id = p_contract_header_id;
    
      SELECT b.period_set_code
        INTO v_period_set_code
        FROM fnd_companies a, gld_set_of_books b
       WHERE a.company_id = v_company_id
         AND a.set_of_books_id = b.set_of_books_id;
    
      SELECT MAX(cp.line_num)
        INTO v_max_line_num
        FROM con_contract_return_periods cp
       WHERE cp.contract_header_id = p_contract_header_id;
    
      IF v_max_line_num IS NULL THEN
        v_max_line_num := 0;
      END IF;
    
      FOR c_gld_periods IN (SELECT *
                              FROM gld_periods t
                             WHERE t.period_set_code = v_period_set_code
                               AND t.adjustment_flag = 'N'
                               AND t.period_name >= p_period_from
                               AND t.period_name <= p_period_to) LOOP
        BEGIN
          SELECT 1
            INTO v_exists
            FROM con_contract_return_periods cp
           WHERE cp.contract_header_id = p_contract_header_id
             AND cp.period_name = c_gld_periods.period_name;
        EXCEPTION
          WHEN no_data_found THEN
          
            v_contract_return_period_id := get_contract_return_period_id;
          
            INSERT INTO con_contract_return_periods
              (contract_header_id,
               contract_return_period_id,
               line_num,
               period_year,
               period_num,
               period_name,
               quarter_num,
               created_by,
               creation_date,
               last_updated_by,
               last_update_date)
            VALUES
              (p_contract_header_id,
               v_contract_return_period_id,
               v_max_line_num + 10,
               c_gld_periods.period_year,
               c_gld_periods.period_num,
               c_gld_periods.period_name,
               c_gld_periods.quarter_num,
               p_user_id,
               SYSDATE,
               p_user_id,
               SYSDATE);
            v_max_line_num := v_max_line_num + 10;
        END;
      END LOOP;
    END IF;
  
    --金额平均分配
    SELECT t.amount, t.invoice_sales_amount
      INTO v_total_amount, v_total_sales_amount
      FROM con_contract_headers t
     WHERE t.contract_header_id = p_contract_header_id;
  
    SELECT COUNT(1)
      INTO v_period_count
      FROM con_contract_return_periods t
     WHERE t.contract_header_id = p_contract_header_id;
    IF v_period_count <> 0 THEN
      IF v_period_count = 1 THEN
        UPDATE con_contract_return_periods p
           SET p.amount               = v_total_amount,
               p.invoice_sales_amount = v_total_sales_amount
         WHERE p.contract_header_id = p_contract_header_id;
      ELSE
        UPDATE con_contract_return_periods p
           SET p.amount               = round(v_total_amount /
                                              v_period_count,
                                              2),
               p.invoice_sales_amount = round(v_total_sales_amount /
                                              v_period_count,
                                              2)
         WHERE p.contract_header_id = p_contract_header_id;
      
        UPDATE con_contract_return_periods p
           SET p.amount               = v_total_amount -
                                        (round(v_total_amount /
                                               v_period_count,
                                               2) * (v_period_count - 1)),
               p.invoice_sales_amount = v_total_sales_amount -
                                        (round(v_total_sales_amount /
                                               v_period_count,
                                               2) * (v_period_count - 1))
         WHERE p.contract_header_id = p_contract_header_id
           AND p.period_name =
               (SELECT MAX(t.period_name)
                  FROM con_contract_return_periods t
                 WHERE t.contract_header_id = p_contract_header_id);
      END IF;
    END IF;
  
  END execute_add_return_period;

  /*  procedure delete_contract_hds_assign_tmp(p_session_id number) is
    begin
      delete from con_contract_hds_assign_tmp t where t.session_id = p_session_id;
    end delete_contract_hds_assign_tmp;
  
    procedure insert_contract_hds_assign_tmp(p_session_id         number,
                                             p_contract_header_id number) is
    begin
      insert into con_contract_hds_assign_tmp
        (session_id,
         contract_header_id)
      values
        (p_session_id,
         p_contract_header_id);
    exception
      when others then
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                    sqlerrm,
                                                       p_created_by              => 1,
                                                       p_package_name            => 'CUX_CON_CONTRACT_PKG',
                                                       p_procedure_function_name => 'INSERT_FND_DIM_VALUE_TMP');
  
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
    end insert_contract_hds_assign_tmp;
  
    procedure insert_contract_hds_assign(p_session_id number,
                                         p_company_id number,
                                         p_user_id    number) is
      v_sysdate          date default trunc(sysdate);
      v_ref_authority_id number;
      v_enabled_flag     varchar2(1);
  
      cursor dim_com_cur is
        select tmp.dimension_value_id from fnd_dim_value_com_tmp tmp where tmp.session_id = p_session_id;
    begin
  
      for c_con_contract_hds in (select * from con_contract_hds_assign_tmp t where t.session_id = p_session_id) loop
        begin
          select a.ref_authority_id,
                 a.enabled_flag
            into v_ref_authority_id,
                 v_enabled_flag
            from con_contract_ref_authority a
           where a.contract_header_id = c_con_contract_hds.contract_header_id
             and a.company_id = p_company_id;
  
          if v_enabled_flag = 'N' then
            update con_contract_ref_authority t
               set t.enabled_flag     = 'Y',
                   t.last_updated_by  = p_user_id,
                   t.last_update_date = sysdate
             where t.ref_authority_id = v_ref_authority_id;
          end if;
        exception
          when no_data_found then
            insert into con_contract_ref_authority
              (ref_authority_id,
               contract_header_id,
               company_id,
               employee_id,
               enabled_flag,
               created_by,
               creation_date,
               last_updated_by,
               last_update_date)
            values
              (con_contract_ref_authority_s.nextval,
               c_con_contract_hds.contract_header_id,
               p_company_id,
               '',
               'Y',
               p_user_id,
               sysdate,
               p_user_id,
               sysdate);
        end;
      end loop;
    exception
      when others then
        sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                    sqlerrm,
                                                       p_created_by              => p_user_id,
                                                       p_package_name            => 'cux_con_contract_pkg',
                                                       p_procedure_function_name => 'insert_contract_hds_assign');
  
        raise_application_error(sys_raise_app_error_pkg.c_error_number,
                                sys_raise_app_error_pkg.g_err_line_id);
    end insert_contract_hds_assign;
  */

  /*************************************************
  -- Author  : RICK
  -- Created : 2018-9-13 19:41:44
  -- Purpose : 合同受益期分摊校验
  **************************************************/
  PROCEDURE check_anotation(p_contract_return_period_id NUMBER,
                            p_user_id                   NUMBER) IS
    v_total_amount     NUMBER;
    v_anotation_amount NUMBER;
  BEGIN
    SELECT ccr.invoice_sales_amount
      INTO v_total_amount
      FROM con_contract_return_periods ccr
     WHERE ccr.contract_return_period_id = p_contract_return_period_id;
  
    SELECT SUM(cca.invoice_sales_amount)
      INTO v_anotation_amount
      FROM contract_period_allocation cca
     WHERE cca.contract_return_period_id = p_contract_return_period_id;
  
    IF (v_total_amount <> v_anotation_amount) THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '分摊金额之和不等于受益期不含税金额!',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_con_contract_pkg',
                                                     p_procedure_function_name => 'check_anotation');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    END IF;
  END check_anotation;

  /*************************************************
  -- Author  : RICK
  -- Created : 2018-9-13 19:41:44
  -- Purpose : 合同受益期删除
  **************************************************/
  PROCEDURE delete_anotation(p_contract_return_period_id NUMBER,
                             p_user_id                   NUMBER) IS
  BEGIN
    DELETE FROM contract_period_allocation cpa
     WHERE cpa.contract_return_period_id = p_contract_return_period_id;
  END delete_anotation;

  /*************************************************
  -- Author  : RICK
  -- Created : 2018-9-13 19:41:44
  -- Purpose : 合同受益期分摊插入
  **************************************************/
  PROCEDURE insert_anotation(p_contract_return_period_id NUMBER,
                             p_company_id                NUMBER,
                             p_unit_id                   NUMBER,
                             p_expense_item_id           NUMBER,
                             p_invoice_sales_amount      NUMBER,
                             p_user_id                   NUMBER,
                             p_responsibility_center_id  NUMBER) IS
  BEGIN
    INSERT INTO contract_period_allocation
      (contract_period_allocation_id,
       contract_return_period_id,
       company_id,
       unit_id,
       expense_item_id,
       invoice_sales_amount,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by,
       responsibility_center_id)
    VALUES
      (contract_period_allocation_s.nextval,
       p_contract_return_period_id,
       p_company_id,
       p_unit_id,
       p_expense_item_id,
       p_invoice_sales_amount,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_user_id,
       p_responsibility_center_id);
  END insert_anotation;

  /*************************************************
  -- Author  : RICK
  -- Created : 2018-9-13 19:41:44
  -- Purpose : 预提凭证头新增
  **************************************************/
  PROCEDURE insert_preextract_head(p_con_preextract_accounts_h_id OUT NUMBER,
                                   p_contract_header_id           NUMBER,
                                   p_contract_number              VARCHAR2,
                                   p_status                       VARCHAR2 DEFAULT 'GENERATE',
                                   p_contract_return_period_ids   VARCHAR2,
                                   p_user_id                      NUMBER) IS
  BEGIN
    p_con_preextract_accounts_h_id := con_preextract_accounts_h_s.nextval;
    INSERT INTO con_preextract_accounts_h
      (con_preextract_accounts_h_id,
       contract_header_id,
       contract_number,
       status,
       contract_return_period_ids,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (p_con_preextract_accounts_h_id,
       p_contract_header_id,
       p_contract_number,
       p_status,
       p_contract_return_period_ids,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE);
  END insert_preextract_head;

  /*************************************************
  -- Author  : RICK
  -- Created : 2018-9-13 19:41:44
  -- Purpose : 预提凭证行新增
  **************************************************/
  PROCEDURE insert_preextract_lines(p_con_preextract_accounts_h_id NUMBER,
                                    p_line_number                  NUMBER,
                                    p_period_name                  VARCHAR2,
                                    p_description                  VARCHAR2,
                                    p_transaction_date             DATE,
                                    p_accounting_date              DATE,
                                    p_entered_amount_dr            NUMBER,
                                    p_entered_amount_cr            NUMBER,
                                    p_segment1                     VARCHAR2,
                                    p_segment2                     VARCHAR2,
                                    p_segment3                     VARCHAR2,
                                    p_segment4                     VARCHAR2,
                                    p_segment5                     VARCHAR2,
                                    p_segment6                     VARCHAR2,
                                    p_segment7                     VARCHAR2,
                                    p_segment8                     VARCHAR2,
                                    p_segment9                     VARCHAR2,
                                    p_segment10                    VARCHAR2,
                                    p_segment11                    VARCHAR2 DEFAULT 'null',
                                    p_segment12                    VARCHAR2 DEFAULT 'null',
                                    p_segment13                    VARCHAR2 DEFAULT 'null',
                                    p_segment14                    VARCHAR2 DEFAULT 'null',
                                    p_segment15                    VARCHAR2 DEFAULT 'null',
                                    p_segment16                    VARCHAR2 DEFAULT 'null',
                                    p_segment17                    VARCHAR2 DEFAULT 'null',
                                    p_segment18                    VARCHAR2 DEFAULT 'null',
                                    p_segment19                    VARCHAR2 DEFAULT 'null',
                                    p_segment20                    VARCHAR2 DEFAULT 'null',
                                    p_segment_desc1                VARCHAR2,
                                    p_segment_desc2                VARCHAR2,
                                    p_segment_desc3                VARCHAR2,
                                    p_segment_desc4                VARCHAR2,
                                    p_segment_desc5                VARCHAR2,
                                    p_segment_desc6                VARCHAR2,
                                    p_segment_desc7                VARCHAR2,
                                    p_segment_desc8                VARCHAR2,
                                    p_segment_desc9                VARCHAR2,
                                    p_segment_desc10               VARCHAR2,
                                    p_segment_desc11               VARCHAR2 DEFAULT '缺省',
                                    p_segment_desc12               VARCHAR2 DEFAULT '缺省',
                                    p_segment_desc13               VARCHAR2 DEFAULT '缺省',
                                    p_segment_desc14               VARCHAR2 DEFAULT '缺省',
                                    p_segment_desc15               VARCHAR2 DEFAULT '缺省',
                                    p_segment_desc16               VARCHAR2 DEFAULT '缺省',
                                    p_segment_desc17               VARCHAR2 DEFAULT '缺省',
                                    p_segment_desc18               VARCHAR2 DEFAULT '缺省',
                                    p_segment_desc19               VARCHAR2 DEFAULT '缺省',
                                    p_segment_desc20               VARCHAR2 DEFAULT '缺省',
                                    p_user_id                      NUMBER,
                                    p_company_id                   NUMBER,
                                    p_account_id                   NUMBER,
                                    p_budget_item_id               NUMBER DEFAULT NULL,
                                    p_unit_id                      NUMBER,
                                    p_expense_item_id              NUMBER DEFAULT NULL) IS
  BEGIN
    INSERT INTO con_preextract_accounts_l
      (con_preextract_accounts_l_id,
       con_preextract_accounts_h_id,
       line_number,
       period_name,
       description,
       transaction_date,
       accounting_date,
       entered_amount_dr,
       entered_amount_cr,
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
       segment_desc1,
       segment_desc2,
       segment_desc3,
       segment_desc4,
       segment_desc5,
       segment_desc6,
       segment_desc7,
       segment_desc8,
       segment_desc9,
       segment_desc10,
       segment_desc11,
       segment_desc12,
       segment_desc13,
       segment_desc14,
       segment_desc15,
       segment_desc16,
       segment_desc17,
       segment_desc18,
       segment_desc19,
       segment_desc20,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by,
       company_id,
       account_id,
       budget_item_id,
       unit_id,
       expense_item_id)
    VALUES
      (con_preextract_accounts_l_s.nextval,
       p_con_preextract_accounts_h_id,
       p_line_number,
       p_period_name,
       p_description,
       p_transaction_date,
       p_accounting_date,
       p_entered_amount_dr,
       p_entered_amount_cr,
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
       p_segment13,
       p_segment14,
       p_segment15,
       p_segment16,
       p_segment17,
       p_segment18,
       p_segment19,
       p_segment20,
       p_segment_desc1,
       p_segment_desc2,
       p_segment_desc3,
       p_segment_desc4,
       p_segment_desc5,
       p_segment_desc6,
       p_segment_desc7,
       p_segment_desc8,
       p_segment_desc9,
       p_segment_desc10,
       p_segment_desc11,
       p_segment_desc12,
       p_segment_desc13,
       p_segment_desc14,
       p_segment_desc15,
       p_segment_desc16,
       p_segment_desc17,
       p_segment_desc18,
       p_segment_desc19,
       p_segment_desc20,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_user_id,
       p_company_id,
       p_account_id,
       p_budget_item_id,
       p_unit_id,
       p_expense_item_id);
  END insert_preextract_lines;

  PROCEDURE insert_bgt_budget_reserves(p_con_preextract_accounts_h_id NUMBER,
                                       p_user_id                      NUMBER) IS
    v_bgt_org_id             NUMBER;
    v_dimension_value_id     NUMBER;
    v_period_name            VARCHAR2(30);
    v_period_year            VARCHAR2(30);
    v_period_num             VARCHAR2(30);
    v_hec_sob_code           VARCHAR2(30);
    v_segment20              VARCHAR2(30);
    v_journal_category       VARCHAR2(30);
    v_bgt_reserve            VARCHAR2(2);
    v_ebs_gl_flag            VARCHAR2(2);
    v_import_flag            VARCHAR2(2);
    v_budget_reserve_line_id NUMBER;
  BEGIN
    FOR c_cur IN (SELECT l.*,
                         cc.company_id h_company_id,
                         (SELECT fc.company_code
                            FROM fnd_companies fc
                           WHERE fc.company_id = cc.company_id) h_company_code,
                         '合同计提:' || cc.contract_number || '[' ||
                         get_return_periods(h.contract_return_period_ids) || ']' h_title,
                         cc.contract_number,
                         (SELECT fcv.responsibility_center_id
                            FROM fnd_responsibility_centers_vl fcv
                           WHERE fcv.company_id = l.company_id
                             AND fcv.responsibility_center_code = l.segment2) responsibility_center_id
                    FROM con_preextract_accounts_h h,
                         con_preextract_accounts_l l,
                         con_contract_headers      cc
                   WHERE h.con_preextract_accounts_h_id =
                         l.con_preextract_accounts_h_id
                     AND h.con_preextract_accounts_h_id =
                         p_con_preextract_accounts_h_id
                     AND h.contract_header_id = cc.contract_header_id) LOOP
      BEGIN
        SELECT s.set_of_books_code
          INTO v_hec_sob_code
          FROM gld_set_of_books s
         WHERE s.set_of_books_id =
               gld_common_pkg.get_set_of_books_id(c_cur.h_company_id);
      EXCEPTION
        WHEN no_data_found THEN
          gl_log_pkg.log(p_package_name   => 'CUX_GLD_JOUR_PKG',
                         p_procedure_name => 'GLD_JOUR',
                         p_log_type       => gl_log_pkg.g_log_type_error,
                         p_log_text       => '帐套数据错误，该帐套ID的帐套数据不存在,帐套ID为:' ||
                                             gld_common_pkg.get_set_of_books_id(c_cur.h_company_id),
                         p_user_id        => p_user_id,
                         p_rule_type      => 'GLD_JOUR',
                         p_je_line_id     => c_cur.con_preextract_accounts_l_id);
      END;
    
      v_period_name := gld_common_pkg.get_period_name(p_company_id => c_cur.h_company_id,
                                                      p_date       => c_cur.accounting_date);
      v_period_year := gld_common_pkg.get_period_year(p_company_id  => c_cur.h_company_id,
                                                      p_period_name => v_period_name);
      v_period_num  := gld_common_pkg.get_period_num(p_company_id  => c_cur.h_company_id,
                                                     p_period_name => v_period_name);
    
      --总账凭证头公司所属帐套对应的预算组织
      SELECT b.bgt_org_id
        INTO v_bgt_org_id
        FROM fnd_companies fc, bgt_organizations_vl b
       WHERE fc.set_of_books_id = b.set_of_books_id
         AND fc.company_id = c_cur.company_id;
    
      /*      SELECT fv.dimension_value_id
       INTO v_dimension_value_id
       FROM fnd_dimension_values_vl fv, fnd_dimensions_vl fs
      WHERE fv.dimension_id = fs.dimension_id
        AND fs.dimension_code = 'CHANNEL'
        AND fv.dimension_value_code = '0';*/
    
      IF (c_cur.budget_item_id IS NOT NULL AND
         c_cur.entered_amount_dr IS NOT NULL) THEN
        bgt_budget_reserves_pkg.insert_bgt_budget_reserves(p_reserve_company_id        => c_cur.company_id,
                                                           p_reserve_operation_unit_id => NULL,
                                                           p_bgt_org_id                => v_bgt_org_id,
                                                           p_period_name               => v_period_name,
                                                           p_business_type             => 'CON_EXTRACT',
                                                           p_reserve_flag              => 'U',
                                                           p_status                    => 'P',
                                                           p_document_id               => c_cur.con_preextract_accounts_h_id,
                                                           p_document_line_id          => c_cur.con_preextract_accounts_l_id,
                                                           p_currency                  => 'CNY',
                                                           p_budget_item_id            => c_cur.budget_item_id,
                                                           p_responsibility_center_id  => c_cur.responsibility_center_id,
                                                           p_exchange_rate_type        => NULL,
                                                           p_exchange_rate_quotation   => NULL,
                                                           p_exchange_rate             => 1,
                                                           p_amount                    => c_cur.entered_amount_dr,
                                                           p_functional_amount         => c_cur.entered_amount_dr,
                                                           p_quantity                  => NULL,
                                                           p_uom                       => NULL,
                                                           p_company_id                => c_cur.company_id,
                                                           p_operation_unit_id         => NULL,
                                                           p_unit_id                   => c_cur.unit_id,
                                                           p_position_id               => NULL,
                                                           p_employee_id               => NULL,
                                                           p_dimension1_id             => NULL,
                                                           p_dimension2_id             => NULL,
                                                           p_dimension3_id             => NULL, --todo
                                                           p_dimension4_id             => NULL,
                                                           p_dimension5_id             => NULL,
                                                           p_dimension6_id             => NULL,
                                                           p_dimension7_id             => NULL,
                                                           p_dimension8_id             => NULL,
                                                           p_dimension9_id             => NULL,
                                                           p_dimension10_id            => NULL,
                                                           p_created_by                => p_user_id,
                                                           p_release_id                => NULL,
                                                           p_budget_reserve_line_id    => v_budget_reserve_line_id,
                                                           p_source_type               => NULL,
                                                           p_manual_flag               => 'Y');
      
        bgt_budget_reserves_pkg.insert_bgt_budget_reserves(p_reserve_company_id        => c_cur.company_id,
                                                           p_reserve_operation_unit_id => NULL,
                                                           p_bgt_org_id                => v_bgt_org_id,
                                                           p_period_name               => v_period_name,
                                                           p_business_type             => 'CON_EXTRACT',
                                                           p_reserve_flag              => 'R',
                                                           p_status                    => 'P',
                                                           p_document_id               => c_cur.con_preextract_accounts_h_id,
                                                           p_document_line_id          => c_cur.con_preextract_accounts_l_id,
                                                           p_currency                  => 'CNY',
                                                           p_budget_item_id            => c_cur.budget_item_id,
                                                           p_responsibility_center_id  => c_cur.responsibility_center_id,
                                                           p_exchange_rate_type        => NULL,
                                                           p_exchange_rate_quotation   => NULL,
                                                           p_exchange_rate             => 1,
                                                           p_amount                    => c_cur.entered_amount_dr * -1,
                                                           p_functional_amount         => c_cur.entered_amount_dr * -1,
                                                           p_quantity                  => NULL,
                                                           p_uom                       => NULL,
                                                           p_company_id                => c_cur.company_id,
                                                           p_operation_unit_id         => NULL,
                                                           p_unit_id                   => c_cur.unit_id,
                                                           p_position_id               => NULL,
                                                           p_employee_id               => NULL,
                                                           p_dimension1_id             => NULL,
                                                           p_dimension2_id             => NULL,
                                                           p_dimension3_id             => NULL, --todo
                                                           p_dimension4_id             => NULL,
                                                           p_dimension5_id             => NULL,
                                                           p_dimension6_id             => NULL,
                                                           p_dimension7_id             => NULL,
                                                           p_dimension8_id             => NULL,
                                                           p_dimension9_id             => NULL,
                                                           p_dimension10_id            => NULL,
                                                           p_created_by                => p_user_id,
                                                           p_release_id                => NULL,
                                                           p_budget_reserve_line_id    => v_budget_reserve_line_id,
                                                           p_source_type               => NULL,
                                                           p_manual_flag               => 'Y');
      
      END IF;
    END LOOP;
  END insert_bgt_budget_reserves;

  PROCEDURE insert_gl_account_entry(p_con_preextract_accounts_h_id NUMBER,
                                    p_user_id                      NUMBER) IS
    v_period_name      VARCHAR2(30);
    v_period_year      VARCHAR2(30);
    v_period_num       VARCHAR2(30);
    v_hec_sob_code     VARCHAR2(30);
    v_segment20        VARCHAR2(30);
    v_journal_category VARCHAR2(30);
    v_bgt_reserve      VARCHAR2(2);
    v_ebs_gl_flag      VARCHAR2(2);
    v_import_flag      VARCHAR2(2);
  
  BEGIN
    FOR c_cur IN (SELECT l.*,
                         cc.company_id h_company_id,
                         (SELECT fc.company_code
                            FROM fnd_companies fc
                           WHERE fc.company_id = cc.company_id) h_company_code,
                         '合同计提:' || cc.contract_number || '[' ||
                         get_return_periods(h.contract_return_period_ids) || ']' h_title,
                         cc.contract_number,
                         (SELECT eou.unit_code
                            FROM exp_org_unit eou
                           WHERE eou.unit_id = l.unit_id) unit_code,
                         (SELECT eei.commitment_item_code
                            FROM exp_expense_items eei
                           WHERE l.expense_item_id = eei.expense_item_id) commitment_item_code
                    FROM con_preextract_accounts_h h,
                         con_preextract_accounts_l l,
                         con_contract_headers      cc
                   WHERE h.con_preextract_accounts_h_id =
                         l.con_preextract_accounts_h_id
                     AND h.con_preextract_accounts_h_id =
                         p_con_preextract_accounts_h_id
                     AND h.contract_header_id = cc.contract_header_id) LOOP
      BEGIN
        SELECT s.set_of_books_code
          INTO v_hec_sob_code
          FROM gld_set_of_books s
         WHERE s.set_of_books_id =
               gld_common_pkg.get_set_of_books_id(c_cur.h_company_id);
      EXCEPTION
        WHEN no_data_found THEN
          gl_log_pkg.log(p_package_name   => 'CUX_GLD_JOUR_PKG',
                         p_procedure_name => 'GLD_JOUR',
                         p_log_type       => gl_log_pkg.g_log_type_error,
                         p_log_text       => '帐套数据错误，该帐套ID的帐套数据不存在,帐套ID为:' ||
                                             gld_common_pkg.get_set_of_books_id(c_cur.h_company_id),
                         p_user_id        => p_user_id,
                         p_rule_type      => 'GLD_JOUR',
                         p_je_line_id     => c_cur.con_preextract_accounts_l_id);
      END;
    
      v_period_name := gld_common_pkg.get_period_name(p_company_id => c_cur.h_company_id,
                                                      p_date       => c_cur.accounting_date);
      v_period_year := gld_common_pkg.get_period_year(p_company_id  => c_cur.h_company_id,
                                                      p_period_name => v_period_name);
      v_period_num  := gld_common_pkg.get_period_num(p_company_id  => c_cur.h_company_id,
                                                     p_period_name => v_period_name);
    
      /*      SELECT t.je_category_code
       INTO v_journal_category
       FROM gl_je_categories t
      WHERE t.rule_type = 'GLD_JOUR';*/
    
      v_import_flag := 'P';
    
      gl_account_entry_pkg.insert_gl_account_entry(p_hec_sob_code             => v_hec_sob_code,
                                                   p_company_id               => c_cur.h_company_id,
                                                   p_company_code             => c_cur.h_company_code,
                                                   p_transaction_type         => 'CON_EXTRACT',
                                                   p_transaction_header_id    => c_cur.con_preextract_accounts_h_id,
                                                   p_transaction_line_id      => c_cur.con_preextract_accounts_l_id,
                                                   p_transaction_dist_id      => NULL,
                                                   p_transaction_je_line_id   => c_cur.con_preextract_accounts_l_id,
                                                   p_transaction_number       => c_cur.contract_number,
                                                   p_journal_category         => v_journal_category,
                                                   p_period_name              => v_period_name,
                                                   p_period_year              => v_period_year,
                                                   p_period_num               => v_period_num,
                                                   p_description              => c_cur.h_title,
                                                   p_transaction_date         => c_cur.transaction_date,
                                                   p_accounting_date          => c_cur.accounting_date,
                                                   p_attachment_num           => NULL,
                                                   p_line_description         => c_cur.h_title,
                                                   p_account_id               => c_cur.account_id,
                                                   p_account_code             => c_cur.segment3,
                                                   p_entered_amount_dr        => c_cur.entered_amount_dr,
                                                   p_entered_amount_cr        => c_cur.entered_amount_cr,
                                                   p_functional_amount_dr     => c_cur.entered_amount_dr,
                                                   p_functional_amount_cr     => c_cur.entered_amount_cr,
                                                   p_currency_code            => 'CNY',
                                                   p_currency_conversion_date => trunc(SYSDATE),
                                                   p_currency_conversion_rate => 1,
                                                   p_currency_conversion_type => NULL,
                                                   p_reverse_flag             => 'N',
                                                   p_reverse_transaction_id   => NULL,
                                                   p_segment1                 => c_cur.segment1,
                                                   p_segment2                 => c_cur.segment2,
                                                   p_segment3                 => c_cur.segment3,
                                                   p_segment4                 => c_cur.segment4,
                                                   p_segment5                 => c_cur.segment5,
                                                   p_segment6                 => c_cur.segment6,
                                                   p_segment7                 => c_cur.segment7,
                                                   p_segment8                 => c_cur.segment8,
                                                   p_segment9                 => c_cur.segment9,
                                                   p_segment10                => c_cur.segment10,
                                                   p_segment11                => c_cur.segment11,
                                                   p_segment12                => c_cur.segment12,
                                                   p_segment13                => c_cur.segment13,
                                                   p_segment14                => c_cur.segment14,
                                                   p_segment15                => c_cur.segment15,
                                                   p_segment16                => c_cur.segment16,
                                                   p_segment17                => c_cur.segment17,
                                                   p_segment18                => c_cur.segment18,
                                                   p_segment19                => c_cur.segment19,
                                                   p_segment20                => c_cur.segment20,
                                                   
                                                   p_segment_desc1    => c_cur.segment_desc1,
                                                   p_segment_desc2    => c_cur.segment_desc2,
                                                   p_segment_desc3    => c_cur.segment_desc3,
                                                   p_segment_desc4    => c_cur.segment_desc4,
                                                   p_segment_desc5    => c_cur.segment_desc5,
                                                   p_segment_desc6    => c_cur.segment_desc6,
                                                   p_segment_desc7    => c_cur.segment_desc7,
                                                   p_segment_desc8    => c_cur.segment_desc8,
                                                   p_attribute11      => NULL,
                                                   p_batch_code       => NULL,
                                                   p_gl_interface_id  => NULL,
                                                   p_imported_flag    => v_import_flag,
                                                   p_import_date      => NULL,
                                                   p_journal_number   => NULL,
                                                   p_error_code       => NULL,
                                                   p_error_message    => NULL,
                                                   p_query_batch_code => NULL,
                                                   p_user_id          => p_user_id);
    END LOOP;
  
  END insert_gl_account_entry;

  /*************************************************
  -- Author  : RICK
  -- Created : 2018-9-13 19:41:44
  -- Purpose : 修改预提凭证状态
  **************************************************/
  PROCEDURE set_preextract_accounts_status(p_con_preextract_accounts_h_id NUMBER,
                                           p_status                       VARCHAR2,
                                           p_user_id                      NUMBER) IS
  
    v_error EXCEPTION;
    v_error_msg VARCHAR2(4000);
  
    v_preextract_account con_preextract_accounts_h%ROWTYPE;
  BEGIN
    SELECT *
      INTO v_preextract_account
      FROM con_preextract_accounts_h h
     WHERE h.con_preextract_accounts_h_id = p_con_preextract_accounts_h_id;
  
    --提交
    IF (p_status = 'SUBMITTED') THEN
    
      IF (v_preextract_account.status NOT IN ('REJECTED', 'GENERATE')) THEN
        v_error_msg := '该单据不是可提交的状态';
        RAISE v_error;
      END IF;
    
      UPDATE con_preextract_accounts_h h
         SET h.status           = 'SUBMITTED',
             h.last_update_date = SYSDATE,
             h.last_updated_by  = p_user_id
       WHERE h.con_preextract_accounts_h_id =
             p_con_preextract_accounts_h_id;
    
    ELSIF (p_status = 'AUDIT') THEN
      --审核
      IF (v_preextract_account.status NOT IN ('SUBMITTED')) THEN
        v_error_msg := '提交状态才可以审核';
        RAISE v_error;
      END IF;
    
      UPDATE con_preextract_accounts_h h
         SET h.status           = 'AUDIT',
             h.last_update_date = SYSDATE,
             h.last_updated_by  = p_user_id
       WHERE h.con_preextract_accounts_h_id =
             p_con_preextract_accounts_h_id;
    
      --预算占用
      insert_bgt_budget_reserves(p_con_preextract_accounts_h_id => p_con_preextract_accounts_h_id,
                                 p_user_id                      => p_user_id);
      --凭证
      insert_gl_account_entry(p_con_preextract_accounts_h_id => p_con_preextract_accounts_h_id,
                              p_user_id                      => p_user_id);
    
    ELSIF (p_status = 'REJECTED') THEN
      --审核
      IF (v_preextract_account.status NOT IN ('SUBMITTED')) THEN
        v_error_msg := '提交状态才可以审核拒绝';
        RAISE v_error;
      END IF;
    
      UPDATE con_preextract_accounts_h h
         SET h.status           = 'REJECTED',
             h.last_update_date = SYSDATE,
             h.last_updated_by  = p_user_id
       WHERE h.con_preextract_accounts_h_id =
             p_con_preextract_accounts_h_id;
    END IF;
  
  EXCEPTION
    WHEN v_error THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => v_error_msg,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_con_contract_pkg',
                                                     p_procedure_function_name => 'set_preextract_accounts_status');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  END set_preextract_accounts_status;

  /*************************************************
  -- Author  : RICK
  -- Created : 2018-9-13 19:41:44
  -- Purpose : 合同预提
  **************************************************/
  PROCEDURE preextract_contract(p_con_preextract_accounts_h_id OUT NUMBER,
                                p_contract_header_id           NUMBER,
                                p_contract_return_period_ids   VARCHAR2,
                                p_user_id                      NUMBER) IS
    v_con_contract_headers con_contract_headers%ROWTYPE;
    v_dr_account           gld_accounts_vl%ROWTYPE;
    v_cr_account           gld_accounts_vl%ROWTYPE;
  
    v_cur_last_day   DATE;
    v_next_month_day DATE;
    v_cur_period     VARCHAR2(30);
  
    v_off NUMBER := 0;
  
    v_error_pre EXCEPTION;
    v_error_msg VARCHAR2(4000);
  
    v_count NUMBER;
  
    v_result  VARCHAR2(30);
    v_message VARCHAR2(4000);
    e_ebs_ccid_null EXCEPTION;
  BEGIN
    v_cur_last_day   := last_day(trunc(SYSDATE));
    v_next_month_day := v_cur_last_day + 1;
    v_cur_period     := to_char(SYSDATE, 'yyyy-mm');
  
    SELECT COUNT(1)
      INTO v_count
      FROM con_preextract_accounts_h h
     WHERE h.contract_header_id = p_contract_header_id
       AND h.contract_return_period_ids = p_contract_return_period_ids
       AND h.status IN ('SUBMITTED', 'AUDIT');
  
    IF (v_count > 0) THEN
      v_error_msg := get_return_periods(p_contract_return_period_ids);
      v_error_msg := v_error_msg || '已预提,无需重复预提!';
      RAISE v_error_pre;
    END IF;
  
    BEGIN
      SELECT ccrp.period_name
        INTO v_error_msg
        FROM con_contract_return_periods ccrp
       WHERE ccrp.contract_return_period_id IN
             (SELECT *
                FROM TABLE(sys_sql_util_pkg.split(p_contract_return_period_ids,
                                                  ',')))
         AND ccrp.period_name > v_cur_period
         AND rownum = 1;
    
      v_error_msg := '当前及以前期间的受益期才允许预提!';
      RAISE v_error_pre;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    FOR c_period IN (SELECT ccrp.period_name,
                            nvl(cux_exp_report_pkg.get_contract_period_exp_amount(ccrp.contract_header_id,
                                                                                  ccrp.contract_return_period_id),
                                0) report_amount
                       FROM con_contract_return_periods ccrp
                      WHERE ccrp.contract_return_period_id IN
                            (SELECT *
                               FROM TABLE(sys_sql_util_pkg.split(p_contract_return_period_ids,
                                                                 ',')))) LOOP
      IF (c_period.report_amount > 0) THEN
        v_error_msg := '期间:' || c_period.period_name || '已报销,无法预提';
        RAISE v_error_pre;
      END IF;
    
    END LOOP;
  
    BEGIN
      SELECT ccrp.period_name
        INTO v_error_msg
        FROM con_contract_return_periods ccrp
       WHERE ccrp.contract_header_id = p_contract_header_id
         AND ccrp.contract_return_period_id NOT IN
             (SELECT *
                FROM TABLE(sys_sql_util_pkg.split(p_contract_return_period_ids,
                                                  ',')))
         AND nvl(cux_exp_report_pkg.get_contract_period_exp_amount(ccrp.contract_header_id,
                                                                   ccrp.contract_return_period_id),
                 0) = 0
         AND ccrp.period_name <= v_cur_period
         AND rownum = 1;
      v_error_msg := '期间:' || v_error_msg || '需预提';
      RAISE v_error_pre;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    --删除未提交的数据
    DELETE FROM con_preextract_accounts_l l
     WHERE EXISTS (SELECT 1
              FROM con_preextract_accounts_h h
             WHERE h.con_preextract_accounts_h_id =
                   l.con_preextract_accounts_h_id
               AND h.contract_header_id = p_contract_header_id
               AND h.status IN ('GENERATE', 'REJECTED'));
  
    DELETE FROM con_preextract_accounts_h h
     WHERE h.contract_header_id = p_contract_header_id
       AND h.status IN ('GENERATE', 'REJECTED');
  
    SELECT *
      INTO v_con_contract_headers
      FROM con_contract_headers h
     WHERE h.contract_header_id = p_contract_header_id;
  
    IF (v_con_contract_headers.status <> 'CONFIRM') THEN
      v_error_msg := '已确认的合同才允许预提!';
      RAISE v_error_pre;
    END IF;
  
    --插入头
    insert_preextract_head(p_con_preextract_accounts_h_id => p_con_preextract_accounts_h_id,
                           p_contract_header_id           => p_contract_header_id,
                           p_contract_number              => v_con_contract_headers.contract_number,
                           p_contract_return_period_ids   => p_contract_return_period_ids,
                           p_user_id                      => p_user_id);
  
    FOR c1 IN (SELECT cpa.company_id,
                      (SELECT fcv.company_code
                         FROM fnd_companies_vl fcv
                        WHERE fcv.company_id = cpa.company_id) company_code,
                      (SELECT fcv.company_short_name
                         FROM fnd_companies_vl fcv
                        WHERE fcv.company_id = cpa.company_id) company_name,
                      /* (SELECT frcv.responsibility_center_code
                         FROM fnd_responsibility_centers_vl frcv,
                              exp_org_unit                  eou
                        WHERE frcv.responsibility_center_id =
                              eou.responsibility_center_id
                          AND eou.unit_id = cpa.unit_id) responsibility_center_code,
                      (SELECT frcv.responsibility_center_name
                         FROM fnd_responsibility_centers_vl frcv,
                              exp_org_unit                  eou
                        WHERE frcv.responsibility_center_id =
                              eou.responsibility_center_id
                          AND eou.unit_id = cpa.unit_id) responsibility_center_name,*/
                      (SELECT frcv.responsibility_center_code
                         FROM fnd_responsibility_centers_vl frcv
                        WHERE frcv.responsibility_center_id =
                              cpa.responsibility_center_id) responsibility_center_code,
                      (SELECT frcv.responsibility_center_name
                         FROM fnd_responsibility_centers_vl frcv
                        WHERE frcv.responsibility_center_id =
                              cpa.responsibility_center_id) responsibility_center_name,
                      cpa.unit_id,
                      (SELECT eou.unit_code
                         FROM exp_org_unit eou
                        WHERE eou.unit_id = cpa.unit_id) unit_code,
                      cpa.expense_item_id,
                      (SELECT eei.budget_item_id
                         FROM exp_expense_items eei
                        WHERE eei.expense_item_id = cpa.expense_item_id) budget_item_id,
                      (SELECT bbi.budget_item_code
                         FROM exp_expense_items eei, bgt_budget_items_vl bbi
                        WHERE eei.expense_item_id = cpa.expense_item_id
                          AND eei.budget_item_id = bbi.budget_item_id) budget_item_code,
                      (SELECT bbi.description
                         FROM exp_expense_items eei, bgt_budget_items_vl bbi
                        WHERE eei.expense_item_id = cpa.expense_item_id
                          AND eei.budget_item_id = bbi.budget_item_id) budget_item_name,
                      
                      SUM(cpa.invoice_sales_amount) invoice_sales_amount,
                      (SELECT eei.commitment_item_code
                         FROM exp_expense_items eei
                        WHERE cpa.expense_item_id = eei.expense_item_id) commitment_item_code
                 FROM contract_period_allocation  cpa,
                      con_contract_return_periods ccrp
                WHERE ccrp.contract_return_period_id =
                      cpa.contract_return_period_id
                  AND ccrp.contract_return_period_id IN
                      (SELECT *
                         FROM TABLE(sys_sql_util_pkg.split(p_contract_return_period_ids,
                                                           ',')))
                GROUP BY cpa.company_id,
                         cpa.unit_id,
                         cpa.expense_item_id,
                         cpa.responsibility_center_id) LOOP
      --借方科目
      acc_builder_employee_exp_pkg.set_process_id(p_company_id => c1.company_id,
                                                  p_user_id    => p_user_id);
      acc_builder_employee_exp_pkg.create_mapping_conditions(p_employee_id            => v_con_contract_headers.employee_id,
                                                             p_expense_user_group_id  => NULL,
                                                             p_expense_report_type_id => NULL, -- v_expense_report_type_id,
                                                             p_currency_code          => 'CNY',
                                                             p_expense_item_id        => c1.expense_item_id,
                                                             p_expense_type_id        => NULL,
                                                             p_period_comparison      => 'IN',
                                                             p_employee_type_id       => NULL,
                                                             p_org_unit               => NULL,
                                                             p_du_id                  => NULL);
    
      v_dr_account.account_id := acc_builder_employee_exp_pkg.get_account;
      SELECT *
        INTO v_dr_account
        FROM gld_accounts_vl gav
       WHERE gav.account_id = v_dr_account.account_id;
    
      --当月借方
      v_off := v_off + 1;
      insert_preextract_lines(p_con_preextract_accounts_h_id => p_con_preextract_accounts_h_id,
                              p_line_number                  => v_off * 10,
                              p_period_name                  => to_char(v_cur_last_day,
                                                                        'yyyy-mm'),
                              p_description                  => '合同预提',
                              p_transaction_date             => trunc(SYSDATE),
                              p_accounting_date              => v_cur_last_day,
                              p_entered_amount_dr            => c1.invoice_sales_amount,
                              p_entered_amount_cr            => NULL,
                              p_segment1                     => c1.company_code,
                              p_segment2                     => c1.responsibility_center_code,
                              p_segment3                     => v_dr_account.account_code,
                              p_segment4                     => c1.commitment_item_code,
                              p_segment5                     => 'null',
                              p_segment6                     => 'null',
                              p_segment7                     => 'null',
                              p_segment8                     => 'null',
                              p_segment9                     => 'null',
                              p_segment10                    => 'null',
                              p_segment12                    => c1.unit_code,
                              p_segment_desc1                => c1.company_name,
                              p_segment_desc2                => c1.responsibility_center_name,
                              p_segment_desc3                => v_dr_account.description,
                              p_segment_desc4                => c1.commitment_item_code,
                              p_segment_desc5                => '缺省',
                              p_segment_desc6                => '缺省',
                              p_segment_desc7                => '缺省',
                              p_segment_desc8                => '缺省',
                              p_segment_desc9                => '缺省',
                              p_segment_desc10               => '缺省',
                              p_user_id                      => p_user_id,
                              p_company_id                   => c1.company_id,
                              p_account_id                   => v_dr_account.account_id,
                              p_budget_item_id               => c1.budget_item_id,
                              p_unit_id                      => c1.unit_id);
    
      --当月贷方  
      SELECT *
        INTO v_cr_account
        FROM gld_accounts_vl gav
       WHERE gav.account_code = c_preextract_account_code;
      v_off := v_off + 1;
      insert_preextract_lines(p_con_preextract_accounts_h_id => p_con_preextract_accounts_h_id,
                              p_line_number                  => v_off * 10,
                              p_period_name                  => to_char(v_cur_last_day,
                                                                        'yyyy-mm'),
                              p_description                  => '合同预提',
                              p_transaction_date             => trunc(SYSDATE),
                              p_accounting_date              => v_cur_last_day,
                              p_entered_amount_dr            => NULL,
                              p_entered_amount_cr            => c1.invoice_sales_amount,
                              p_segment1                     => c1.company_code,
                              p_segment2                     => c1.responsibility_center_code,
                              p_segment3                     => v_cr_account.account_code,
                              p_segment4                     => 'null',
                              p_segment5                     => 'null',
                              p_segment6                     => 'null',
                              p_segment7                     => 'null',
                              p_segment8                     => 'null',
                              p_segment9                     => 'null',
                              p_segment10                    => 'null',
                              p_segment12                    => 'null',
                              p_segment_desc1                => c1.company_name,
                              p_segment_desc2                => c1.responsibility_center_name,
                              p_segment_desc3                => v_cr_account.description,
                              p_segment_desc4                => '缺省',
                              p_segment_desc5                => '缺省',
                              p_segment_desc6                => '缺省',
                              p_segment_desc7                => '缺省',
                              p_segment_desc8                => '缺省',
                              p_segment_desc9                => '缺省',
                              p_segment_desc10               => '缺省',
                              p_user_id                      => p_user_id,
                              p_company_id                   => c1.company_id,
                              p_account_id                   => v_cr_account.account_id,
                              p_budget_item_id               => NULL,
                              p_unit_id                      => c1.unit_id);
    
      --次月借方
      v_off := v_off + 1;
      insert_preextract_lines(p_con_preextract_accounts_h_id => p_con_preextract_accounts_h_id,
                              p_line_number                  => v_off * 10,
                              p_period_name                  => to_char(v_next_month_day,
                                                                        'yyyy-mm'),
                              p_description                  => '合同预提',
                              p_transaction_date             => trunc(SYSDATE),
                              p_accounting_date              => v_next_month_day,
                              p_entered_amount_dr            => c1.invoice_sales_amount * -1,
                              p_entered_amount_cr            => NULL,
                              p_segment1                     => c1.company_code,
                              p_segment2                     => c1.responsibility_center_code,
                              p_segment3                     => v_dr_account.account_code,
                              p_segment4                     => c1.commitment_item_code,
                              p_segment5                     => 'null',
                              p_segment6                     => 'null',
                              p_segment7                     => 'null',
                              p_segment8                     => 'null',
                              p_segment9                     => 'null',
                              p_segment10                    => 'null',
                              p_segment12                    => c1.unit_code,
                              p_segment_desc1                => c1.company_name,
                              p_segment_desc2                => c1.responsibility_center_name,
                              p_segment_desc3                => v_dr_account.description,
                              p_segment_desc4                => '缺省',
                              p_segment_desc5                => '缺省',
                              p_segment_desc6                => '缺省',
                              p_segment_desc7                => '缺省',
                              p_segment_desc8                => '缺省',
                              p_segment_desc9                => '缺省',
                              p_segment_desc10               => '缺省',
                              p_user_id                      => p_user_id,
                              p_company_id                   => c1.company_id,
                              p_account_id                   => v_dr_account.account_id,
                              p_budget_item_id               => c1.budget_item_id,
                              p_unit_id                      => c1.unit_id);
      --次月贷方
      v_off := v_off + 1;
      insert_preextract_lines(p_con_preextract_accounts_h_id => p_con_preextract_accounts_h_id,
                              p_line_number                  => v_off * 10,
                              p_period_name                  => to_char(v_next_month_day,
                                                                        'yyyy-mm'),
                              p_description                  => '合同预提',
                              p_transaction_date             => trunc(SYSDATE),
                              p_accounting_date              => v_next_month_day,
                              p_entered_amount_dr            => NULL,
                              p_entered_amount_cr            => c1.invoice_sales_amount * -1,
                              p_segment1                     => c1.company_code,
                              p_segment2                     => c1.responsibility_center_code,
                              p_segment3                     => v_cr_account.account_code,
                              p_segment4                     => 'null',
                              p_segment5                     => 'null',
                              p_segment6                     => 'null',
                              p_segment7                     => 'null',
                              p_segment8                     => 'null',
                              p_segment9                     => 'null',
                              p_segment10                    => 'null',
                              p_segment12                    => 'null',
                              p_segment_desc1                => c1.company_name,
                              p_segment_desc2                => c1.responsibility_center_name,
                              p_segment_desc3                => v_cr_account.description,
                              p_segment_desc4                => '缺省',
                              p_segment_desc5                => '缺省',
                              p_segment_desc6                => '缺省',
                              p_segment_desc7                => '缺省',
                              p_segment_desc8                => '缺省',
                              p_segment_desc9                => '缺省',
                              p_segment_desc10               => '缺省',
                              p_user_id                      => p_user_id,
                              p_company_id                   => c1.company_id,
                              p_account_id                   => v_cr_account.account_id,
                              p_budget_item_id               => NULL,
                              p_unit_id                      => c1.unit_id);
    END LOOP;
  
  EXCEPTION
    WHEN v_error_pre THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => v_error_msg,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_con_contract_pkg',
                                                     p_procedure_function_name => 'preextract_contract');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN e_ebs_ccid_null THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => v_message,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_con_contract_pkg',
                                                     p_procedure_function_name => 'preextract_contract');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END preextract_contract;

  FUNCTION get_return_periods(p_contract_return_period_ids VARCHAR2)
    RETURN VARCHAR2 IS
    v_result VARCHAR2(4000);
  BEGIN
    FOR c1 IN (SELECT ccrp.period_name
                 FROM con_contract_return_periods ccrp
                WHERE ccrp.contract_return_period_id IN
                      (SELECT *
                         FROM TABLE(sys_sql_util_pkg.split(p_contract_return_period_ids,
                                                           ',')))) LOOP
      IF (v_result IS NOT NULL) THEN
        v_result := v_result || ',';
      END IF;
      v_result := v_result || c1.period_name;
    END LOOP;
    RETURN v_result;
  END get_return_periods;
END cux_con_contract_pkg;
/
