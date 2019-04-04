CREATE OR REPLACE PACKAGE cux_exp_policy_pkg IS

  -- Author  : Rick
  -- Created : 2017/10/17 10:55:58
  -- Purpose : 万联证券差旅费用政策

  /*  \*************************************************
  -- Author  : RICK
  -- Created : 2017-9-21 14:52:51
  -- Purpose : 新增同行人
  **************************************************\
  PROCEDURE insert_cux_exp_peers(p_exp_report_line_id NUMBER,
                                 p_employee_id        NUMBER,
                                 p_date_from          DATE,
                                 p_date_to            DATE,
                                 p_user_id            NUMBER,
                                 p_amount             NUMBER,
                                 p_employee_level     VARCHAR2);
  
  \*************************************************
  -- Author  : RICK
  -- Created : 2017-9-21 14:52:51
  -- Purpose : 修改同行人
  **************************************************\
  PROCEDURE update_cux_exp_peers(p_cux_exp_peers_id   NUMBER,
                                 p_exp_report_line_id NUMBER,
                                 p_employee_id        NUMBER,
                                 p_date_from          DATE,
                                 p_date_to            DATE,
                                 p_user_id            NUMBER,
                                 p_amount             NUMBER,
                                 p_employee_level     VARCHAR2);
  
  \*************************************************
  -- Author  : RICK
  -- Created : 2017-9-21 14:52:51
  -- Purpose : 删除同行人
  **************************************************\
  PROCEDURE delete_cux_exp_peers(p_cux_exp_peers_id NUMBER);*/

  /*=============================================
  -- 超标准时间,
  -- 相关领导审批
  --============================================*/
  FUNCTION wl_policies_op(p_event_record_id     NUMBER,
                          p_event_handle_log_id NUMBER,
                          p_event_param         NUMBER,
                          p_user_id             NUMBER,
                          p_param1              VARCHAR2 DEFAULT NULL,
                          p_param2              VARCHAR2 DEFAULT NULL)
    RETURN NUMBER;

  /*************************************************
  -- Author  : RICK
  -- Created : 2017-9-21 14:52:51
  -- Purpose : 校验费用政策
  **************************************************/
  PROCEDURE check_policy(p_exp_report_header_id NUMBER,
                         p_user_id              NUMBER,
                         p_over_flag            OUT VARCHAR2,
                         p_commit_flag          out varchar2);

  FUNCTION get_transportation(p_expense_policies_id NUMBER) RETURN VARCHAR2;

  /*************************************************
  -- Author  : RICK
  -- Created : 2017-9-21 14:52:51
  -- Purpose : 获取超标准岗位代码
  **************************************************/
  FUNCTION get_policy_position(p_exp_report_header_id NUMBER) RETURN VARCHAR2;

  /*************************************************
  -- Author  : RICK
  -- Created : 2017-9-21 14:52:51
  -- Purpose : 获取超标准员工级别
  **************************************************/
  FUNCTION get_policy_employee_levels(p_exp_report_header_id NUMBER)
    RETURN VARCHAR2;

END cux_exp_policy_pkg;
/
CREATE OR REPLACE PACKAGE BODY cux_exp_policy_pkg IS

  /* \*************************************************
  -- Author  : RICK
  -- Created : 2017-9-21 14:52:51
  -- Purpose : 新增同行人
  **************************************************\
  PROCEDURE insert_cux_exp_peers(p_exp_report_line_id NUMBER,
                                 p_employee_id        NUMBER,
                                 p_date_from          DATE,
                                 p_date_to            DATE,
                                 p_user_id            NUMBER,
                                 p_amount             NUMBER,
                                 p_employee_level     VARCHAR2) IS
  BEGIN
    INSERT INTO cux_exp_peers
      (cux_exp_peers_id,
       exp_report_line_id,
       employee_id,
       date_from,
       date_to,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       amount,
       employee_level)
    VALUES
      (cux_exp_peers_s.nextval,
       p_exp_report_line_id,
       p_employee_id,
       p_date_from,
       p_date_to,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE,
       p_amount,
       p_employee_level);
  END;
  
  \*************************************************
  -- Author  : RICK
  -- Created : 2017-9-21 14:52:51
  -- Purpose : 修改同行人
  **************************************************\
  PROCEDURE update_cux_exp_peers(p_cux_exp_peers_id   NUMBER,
                                 p_exp_report_line_id NUMBER,
                                 p_employee_id        NUMBER,
                                 p_date_from          DATE,
                                 p_date_to            DATE,
                                 p_user_id            NUMBER,
                                 p_amount             NUMBER,
                                 p_employee_level     VARCHAR2) IS
  BEGIN
    UPDATE cux_exp_peers cep
       SET cep.employee_id        = p_employee_id,
           cep.exp_report_line_id = p_exp_report_line_id,
           cep.date_from          = p_date_from,
           cep.date_to            = p_date_to,
           cep.last_updated_by    = p_user_id,
           cep.last_update_date   = SYSDATE,
           amount                 = p_amount,
           employee_level         = p_employee_level
     WHERE cep.cux_exp_peers_id = p_cux_exp_peers_id;
  END update_cux_exp_peers;
  
  \*************************************************
  -- Author  : RICK
  -- Created : 2017-9-21 14:52:51
  -- Purpose : 删除同行人
  **************************************************\
  PROCEDURE delete_cux_exp_peers(p_cux_exp_peers_id NUMBER) IS
  BEGIN
    DELETE FROM cux_exp_peers ce
     WHERE ce.cux_exp_peers_id = p_cux_exp_peers_id;
  END delete_cux_exp_peers;*/

  FUNCTION get_policy_info(p_company_id         NUMBER,
                           p_employee_id        NUMBER,
                           p_expense_item_id    NUMBER,
                           p_city               VARCHAR2,
                           p_place_type_id      NUMBER,
                           p_place_id           NUMBER,
                           p_transportation     VARCHAR2,
                           p_currency_code      VARCHAR2,
                           p_position_id        NUMBER,
                           p_rep_date           DATE,
                           p_unit_id            NUMBER,
                           p_employee_levels_id varchar2)
    RETURN exp_expense_policies%ROWTYPE IS
    v_employee_job_id      NUMBER;
    v_company_level_id     NUMBER;
    v_employee_level_id    NUMBER;
    v_exp_expense_policies exp_expense_policies%ROWTYPE;
  
    v_employee_name VARCHAR2(100);
    v_error EXCEPTION;
    v_error_msg         VARCHAR2(200);
    v_expense_item_code varchar2(30);
  BEGIN
  
    BEGIN
      SELECT fv.company_level_id
        INTO v_company_level_id
        FROM fnd_companies_vl fv
       WHERE fv.company_id = p_company_id;
    EXCEPTION
      WHEN OTHERS THEN
        v_company_level_id := NULL;
    END;
  
    SELECT ee.name
      INTO v_employee_name
      FROM exp_employees ee
     WHERE ee.employee_id = p_employee_id;
  
    BEGIN
      SELECT eo.employee_job_id
        INTO v_employee_job_id
        FROM exp_employee_assigns ea, exp_org_position eo
       WHERE ea.position_id = eo.position_id
         AND ea.employee_id = p_employee_id
         AND ea.position_id = p_position_id;
    EXCEPTION
      WHEN no_data_found THEN
        v_employee_level_id := NULL;
        v_employee_job_id   := NULL;
    END;
  
    --万联证券从岗位上获取员工级别,如果存在多岗,取级别最大的一个
    /*BEGIN
      SELECT eel.employee_levels_id
        INTO v_employee_level_id
        FROM exp_employee_levels eel
       WHERE eel.employee_levels_code =
             (SELECT MIN(eel.employee_levels_code)
                FROM exp_employee_assigns eea,
                     exp_org_position     eop,
                     exp_employee_levels  eel
               WHERE eea.employee_id = p_employee_id
                 AND eea.enabled_flag = 'Y'
                 AND eea.position_id = eop.position_id
                 AND eop.enabled_flag = 'Y'
                 AND eop.employee_levels_code = eel.employee_levels_code);
    
      IF (v_employee_level_id IS NULL) THEN
        v_error_msg := '员工:' || v_employee_name || ' 未匹配到级别,请联系管理员配置!';
        RAISE v_error;
      END IF;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;*/
  
    BEGIN
      SELECT *
        INTO v_exp_expense_policies
        FROM (SELECT *
                FROM exp_expense_policies eep
               WHERE (eep.company_level_id IS NULL OR
                     eep.company_level_id = v_company_level_id)
                 AND (eep.expense_item_id IS NULL OR
                     eep.expense_item_id = p_expense_item_id)
                 AND eep.currency_code = p_currency_code
                 AND (eep.position_id IS NULL OR
                     eep.position_id = p_position_id)
                 AND (eep.job_id IS NULL OR eep.job_id = v_employee_job_id)
                 AND (eep.employee_levels_id IS NULL OR
                     eep.employee_levels_id = p_employee_levels_id)
                 AND (eep.start_date IS NULL OR eep.start_date <= p_rep_date)
                 AND nvl(eep.end_date, p_rep_date + 1) >= p_rep_date
                 AND (eep.place_id IS NULL OR eep.place_id = p_place_id)
                 AND (eep.place_type_id IS NULL OR
                     eep.place_type_id = p_place_type_id)
                    
                    /*AND (eep.transportation IS NULL OR
                    eep.transportation = p_transportation)*/
                    
                    --1级部门投行
                 AND eep.level1_unit_id =
                     (SELECT eou1.unit_id
                        FROM exp_org_unit eou, exp_org_unit eou1
                       WHERE eou.unit_id = p_unit_id
                         AND eou.first_unit_code = eou1.unit_code)
               ORDER BY eep.priority)
       WHERE rownum = 1;
    EXCEPTION
      WHEN no_data_found THEN
        BEGIN
          SELECT *
            INTO v_exp_expense_policies
            FROM (SELECT *
                    FROM exp_expense_policies eep
                   WHERE (eep.company_level_id IS NULL OR
                         eep.company_level_id = v_company_level_id)
                     AND (eep.expense_item_id IS NULL OR
                         eep.expense_item_id = p_expense_item_id)
                     AND eep.currency_code = p_currency_code
                     AND (eep.position_id IS NULL OR
                         eep.position_id = p_position_id)
                     AND (eep.job_id IS NULL OR
                         eep.job_id = v_employee_job_id)
                     AND (eep.employee_levels_id IS NULL OR
                         eep.employee_levels_id = p_employee_levels_id)
                     AND (eep.start_date IS NULL OR
                         eep.start_date <= p_rep_date)
                     AND nvl(eep.end_date, p_rep_date + 1) >= p_rep_date
                     AND (eep.place_id IS NULL OR eep.place_id = p_place_id)
                     AND (eep.place_type_id IS NULL OR
                         eep.place_type_id = p_place_type_id)
                        /*AND (eep.transportation IS NULL OR
                        eep.transportation = p_transportation)*/
                     AND eep.level1_unit_id IS NULL
                   ORDER BY eep.priority)
           WHERE rownum = 1;
        EXCEPTION
          WHEN no_data_found THEN
            NULL;
        END;
      
    END;
    RETURN v_exp_expense_policies;
  END;

  FUNCTION get_policy_info_m(p_company_id         NUMBER,
                             p_employee_id        NUMBER,
                             p_expense_item_id    NUMBER,
                             p_city               VARCHAR2,
                             p_place_type_id      NUMBER,
                             p_place_id           NUMBER,
                             p_transportation     VARCHAR2,
                             p_currency_code      VARCHAR2,
                             p_position_id        NUMBER,
                             p_rep_date           DATE,
                             p_unit_id            NUMBER,
                             p_metting_type_code  varchar2,
                             p_employee_levels_id varchar2)
    RETURN exp_expense_policies%ROWTYPE IS
    v_employee_job_id      NUMBER;
    v_company_level_id     NUMBER;
    v_employee_level_id    NUMBER;
    v_exp_expense_policies exp_expense_policies%ROWTYPE;
  
    v_employee_name VARCHAR2(100);
    v_error EXCEPTION;
    v_error_msg         VARCHAR2(200);
    v_expense_item_code varchar2(30);
  BEGIN
  
    BEGIN
      SELECT fv.company_level_id
        INTO v_company_level_id
        FROM fnd_companies_vl fv
       WHERE fv.company_id = p_company_id;
    EXCEPTION
      WHEN OTHERS THEN
        v_company_level_id := NULL;
    END;
  
    SELECT ee.name
      INTO v_employee_name
      FROM exp_employees ee
     WHERE ee.employee_id = p_employee_id;
  
    BEGIN
      SELECT eo.employee_job_id
        INTO v_employee_job_id
        FROM exp_employee_assigns ea, exp_org_position eo
       WHERE ea.position_id = eo.position_id
         AND ea.employee_id = p_employee_id
         AND ea.position_id = p_position_id;
    EXCEPTION
      WHEN no_data_found THEN
        v_employee_level_id := NULL;
        v_employee_job_id   := NULL;
    END;
  
    --万联证券从岗位上获取员工级别,如果存在多岗,取级别最大的一个
    /*BEGIN
      SELECT eel.employee_levels_id
        INTO v_employee_level_id
        FROM exp_employee_levels eel
       WHERE eel.employee_levels_code =
             (SELECT MIN(eel.employee_levels_code)
                FROM exp_employee_assigns eea,
                     exp_org_position     eop,
                     exp_employee_levels  eel
               WHERE eea.employee_id = p_employee_id
                 AND eea.enabled_flag = 'Y'
                 AND eea.position_id = eop.position_id
                 AND eop.enabled_flag = 'Y'
                 AND eop.employee_levels_code = eel.employee_levels_code);
    
      IF (v_employee_level_id IS NULL) THEN
        v_error_msg := '员工:' || v_employee_name || ' 未匹配到级别,请联系管理员配置!';
        RAISE v_error;
      END IF;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;*/
  
    BEGIN
      SELECT *
        INTO v_exp_expense_policies
        FROM (SELECT *
                FROM exp_expense_policies eep
               WHERE (eep.company_level_id IS NULL OR
                     eep.company_level_id = v_company_level_id)
                 AND (eep.expense_item_id IS NULL OR
                     eep.expense_item_id = p_expense_item_id)
                 AND eep.currency_code = p_currency_code
                 AND (eep.position_id IS NULL OR
                     eep.position_id = p_position_id)
                 AND (eep.job_id IS NULL OR eep.job_id = v_employee_job_id)
                 AND (eep.employee_levels_id IS NULL OR
                     eep.employee_levels_id = p_employee_levels_id)
                 AND (eep.start_date IS NULL OR eep.start_date <= p_rep_date)
                 AND nvl(eep.end_date, p_rep_date + 1) >= p_rep_date
                 AND (eep.place_id IS NULL OR eep.place_id = p_place_id)
                 AND (eep.place_type_id IS NULL OR
                     eep.place_type_id = p_place_type_id)
                    
                    /*AND (eep.transportation IS NULL OR
                    eep.transportation = p_transportation)*/
                    
                    --1级部门投行
                 AND eep.level1_unit_id =
                     (SELECT eou1.unit_id
                        FROM exp_org_unit eou, exp_org_unit eou1
                       WHERE eou.unit_id = p_unit_id
                         AND eou.first_unit_code = eou1.unit_code)
                    
                    --会议类型        
                 and (eep.meeting_type is null or
                     eep.meeting_type = p_metting_type_code)
               ORDER BY eep.priority)
       WHERE rownum = 1;
    EXCEPTION
      WHEN no_data_found THEN
        BEGIN
          SELECT *
            INTO v_exp_expense_policies
            FROM (SELECT *
                    FROM exp_expense_policies eep
                   WHERE (eep.company_level_id IS NULL OR
                         eep.company_level_id = v_company_level_id)
                     AND (eep.expense_item_id IS NULL OR
                         eep.expense_item_id = p_expense_item_id)
                     AND eep.currency_code = p_currency_code
                     AND (eep.position_id IS NULL OR
                         eep.position_id = p_position_id)
                     AND (eep.job_id IS NULL OR
                         eep.job_id = v_employee_job_id)
                     AND (eep.employee_levels_id IS NULL OR
                         eep.employee_levels_id = p_employee_levels_id)
                     AND (eep.start_date IS NULL OR
                         eep.start_date <= p_rep_date)
                     AND nvl(eep.end_date, p_rep_date + 1) >= p_rep_date
                     AND (eep.place_id IS NULL OR eep.place_id = p_place_id)
                     AND (eep.place_type_id IS NULL OR
                         eep.place_type_id = p_place_type_id)
                        /* AND (eep.transportation IS NULL OR
                        eep.transportation = p_transportation)*/
                     AND eep.level1_unit_id IS NULL
                        
                        --会议类型        
                     and (eep.meeting_type is null or
                         eep.meeting_type = p_metting_type_code)
                   ORDER BY eep.priority)
           WHERE rownum = 1;
        EXCEPTION
          WHEN no_data_found THEN
            NULL;
        END;
      
    END;
    RETURN v_exp_expense_policies;
  END;

  PROCEDURE insert_expense_policies_tmp(p_expense_policies_id  NUMBER,
                                        p_exp_report_header_id NUMBER,
                                        p_line_number          NUMBER,
                                        p_msg                  VARCHAR2) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    DELETE FROM exp_expense_policies_tmp t
     WHERE t.exp_report_header_id = p_exp_report_header_id
       AND t.line_number = p_line_number;
    INSERT INTO exp_expense_policies_tmp
      (exp_expense_policies_tmp_id,
       expense_policies_id,
       exp_report_header_id,
       line_number,
       msg)
    VALUES
      (exp_expense_policies_tmp_s.nextval,
       p_expense_policies_id,
       p_exp_report_header_id,
       p_line_number,
       p_msg);
    COMMIT;
  END insert_expense_policies_tmp;

  PROCEDURE delete_expense_policies_tmp(p_exp_report_header_id NUMBER) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    DELETE FROM exp_expense_policies_tmp t
     WHERE t.exp_report_header_id = p_exp_report_header_id;
    COMMIT;
  END delete_expense_policies_tmp;

  /*=============================================
  -- 超标准时间,
  -- 相关领导审批
  --============================================*/
  FUNCTION wl_policies_op(p_event_record_id     NUMBER,
                          p_event_handle_log_id NUMBER,
                          p_event_param         NUMBER,
                          p_user_id             NUMBER,
                          p_param1              VARCHAR2 DEFAULT NULL,
                          p_param2              VARCHAR2 DEFAULT NULL)
    RETURN NUMBER IS
    v_line_number          exp_report_lines.line_number%TYPE;
    v_exp_report_header_id exp_report_lines.exp_report_header_id%TYPE;
    v_exp_expense_policies exp_expense_policies%ROWTYPE;
    v_error_msg            VARCHAR2(3000);
    v_evt_event_record     evt_event_record%ROWTYPE;
  BEGIN
  
    SELECT l.line_number, l.exp_report_header_id
      INTO v_line_number, v_exp_report_header_id
      FROM exp_report_lines l
     WHERE l.exp_report_line_id = p_event_param;
  
    SELECT *
      INTO v_evt_event_record
      FROM evt_event_record eer
     WHERE eer.record_id = p_event_record_id;
  
    SELECT *
      INTO v_exp_expense_policies
      FROM exp_expense_policies eep
     WHERE eep.expense_policies_id = v_evt_event_record.param1;
  
    v_error_msg := v_evt_event_record.param2;
  
    IF (v_exp_expense_policies.commit_flag = 'Y') THEN
      IF (v_error_msg IS NULL) THEN
        v_error_msg := '超费用标准,需相关领导审批';
      ELSE
        v_error_msg := v_error_msg || ',需相关领导审批';
      END IF;
      insert_expense_policies_tmp(p_expense_policies_id  => v_exp_expense_policies.expense_policies_id,
                                  p_exp_report_header_id => v_exp_report_header_id,
                                  p_line_number          => v_line_number,
                                  p_msg                  => v_error_msg);
    ELSE
      IF (v_error_msg IS NULL) THEN
        v_error_msg := '超费用标准,不可提交';
      ELSE
        v_error_msg := v_error_msg || ',需相关领导审批';
      END IF;
    
      --不可提交,则抛错
      insert_expense_policies_tmp(p_expense_policies_id  => v_exp_expense_policies.expense_policies_id,
                                  p_exp_report_header_id => v_exp_report_header_id,
                                  p_line_number          => v_line_number,
                                  p_msg                  => v_error_msg);
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => '行号:' ||
                                                                                  v_line_number ||
                                                                                  '超费用政策标准',
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'cux_exp_policy_pkg',
                                                     p_procedure_function_name => 'wl_policies_op');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    END IF;
  
    RETURN evt_event_core_pkg.c_return_normal;
  END wl_policies_op;

  FUNCTION get_transportation(p_expense_policies_id NUMBER) RETURN VARCHAR2 IS
    v_result VARCHAR2(3000);
  BEGIN
    FOR c1 IN (SELECT ((SELECT vt.code_value_name
                          FROM sys_code_values_vl vt, sys_codes sc
                         WHERE sc.code = 'TRANSPORTATION'
                           AND vt.code_id = sc.code_id
                           AND vt.code_value = ept.transportation)) transportation
                 FROM exp_policies_trans ept
                WHERE ept.expense_policies_id = p_expense_policies_id) LOOP
      IF (v_result IS NOT NULL) THEN
        v_result := v_result || ',';
      END IF;
      v_result := v_result || c1.transportation;
    END LOOP;
    RETURN v_result;
  END get_transportation;

  /*************************************************
  -- Author  : RICK
  -- Created : 2017-9-21 14:52:51
  -- Purpose : 校验费用政策
  **************************************************/
  PROCEDURE check_policy(p_exp_report_header_id NUMBER,
                         p_user_id              NUMBER,
                         p_over_flag            OUT VARCHAR2,
                         p_commit_flag          out varchar2) IS
    v_exp_expense_policies exp_expense_policies%ROWTYPE;
    v_exp_report_headers   exp_report_headers%ROWTYPE;
  
    v_begin_date DATE;
    v_end_date   DATE;
    --v_count             NUMBER;
    v_expense_item_code varchar2(50);
    v_days              number;
    v_sum_person_number number;
    v_sum_day_number    number;
    v_sum_report_amount number;
    v_description_text  varchar2(100);
    v_message           varchar2(100);
    v_count             number;
    v_sum_price_amount  number;
    v_report_type_code  varchar2(30);
    v_metting_type_code varchar2(30);
    v_commit_flag       varchar2(10);
    v_special_situation varchar2(10);
    v_expense_item_id   number;
    v_count1            number;
    v_sum_price_amount1 number;
    v_count2            number;
    v_sum_price_amount2 number;
  BEGIN
    -- return;
    SELECT *
      INTO v_exp_report_headers
      FROM exp_report_headers erh
     WHERE erh.exp_report_header_id = p_exp_report_header_id;
  
    delete_expense_policies_tmp(p_exp_report_header_id);
  
    FOR c1 IN (SELECT l.*
                 FROM exp_report_lines l
                WHERE l.exp_report_header_id = p_exp_report_header_id) LOOP
      --获取费用项目code
      BEGIN
        select s.expense_item_code
          into v_expense_item_code
          from EXP_EXPENSE_ITEMS s
         where s.expense_item_id = c1.expense_item_id
           and exists
         (select 1
                  from exp_company_expense_items com
                 where com.enabled_flag = 'Y'
                   and com.company_id = c1.company_id
                   and com.expense_item_id = s.expense_item_id
                   and exists
                 (select 1
                          from exp_expense_item_types
                         where expense_item_id = s.expense_item_id
                           and expense_type_id = c1.expense_type_id));
      EXCEPTION
        WHEN no_data_found then
          v_expense_item_code := NULL;
      END;
    
      select e.expense_report_type_code
        into v_report_type_code
        from exp_expense_report_types e
       where e.expense_report_type_id =
             v_exp_report_headers.exp_report_type_id;
    
      --会议费
      if v_report_type_code = 'HYBX' then
        --FIRST_LEVEL
        select h.metting_type_code
          into v_metting_type_code
          from exp_report_headers h
         where h.exp_report_header_id =
               v_exp_report_headers.exp_report_header_id;
      
        --二级会议时,公杂费费用项目按餐费费用项目标准控制
        if v_metting_type_code = 'SECOND_LEVEL' then
          select e.expense_item_code
            into v_expense_item_code
            from EXP_EXPENSE_ITEMS e
           where e.expense_item_id = c1.expense_item_id;
        
          --公杂费 FY04809 餐费 FY04806
          if v_expense_item_code = 'FY04809' then
            --对应餐费id
            select e.expense_item_id
              into v_expense_item_id
              from EXP_EXPENSE_ITEMS e
             where e.expense_item_code = 'FY04806';
          
            --公杂费 FY05010 餐费 FY05006
          elsif v_expense_item_code = 'FY05010' then
            --对应餐费id
            select e.expense_item_id
              into v_expense_item_id
              from EXP_EXPENSE_ITEMS e
             where e.expense_item_code = 'FY05006';
          else
            v_expense_item_id := c1.expense_item_id;
          end if;
        else
          v_expense_item_id := c1.expense_item_id;
        end if;
      
        --获取费用项目code
        v_exp_expense_policies := get_policy_info_m(p_company_id         => c1.company_id,
                                                    p_employee_id        => c1.employee_id,
                                                    p_expense_item_id    => v_expense_item_id,
                                                    p_city               => c1.city,
                                                    p_place_type_id      => c1.place_type_id,
                                                    p_place_id           => c1.place_id,
                                                    p_transportation     => c1.transportation,
                                                    p_currency_code      => c1.currency_code,
                                                    p_position_id        => c1.position_id,
                                                    p_rep_date           => v_exp_report_headers.report_date,
                                                    p_unit_id            => c1.unit_id,
                                                    p_metting_type_code  => v_metting_type_code,
                                                    p_employee_levels_id => c1.employee_levels_id);
      else
        --获取费用项目code
        v_exp_expense_policies := get_policy_info(p_company_id         => c1.company_id,
                                                  p_employee_id        => c1.employee_id,
                                                  p_expense_item_id    => c1.expense_item_id,
                                                  p_city               => c1.city,
                                                  p_place_type_id      => c1.place_type_id,
                                                  p_place_id           => c1.place_id,
                                                  p_transportation     => c1.transportation,
                                                  p_currency_code      => c1.currency_code,
                                                  p_position_id        => c1.position_id,
                                                  p_rep_date           => v_exp_report_headers.report_date,
                                                  p_unit_id            => c1.unit_id,
                                                  p_employee_levels_id => c1.employee_levels_id);
      end if;
    
      IF (v_exp_expense_policies.expense_policies_id IS NULL) THEN
        CONTINUE;
      END IF;
    
      --#######################如果标准金额为-1,说明该费用政策是控制交通工具 ############
      /*      IF (v_exp_expense_policies.expense_standard = -1) THEN
        SELECT COUNT(1)
          INTO v_count
          FROM exp_policies_trans ept
         WHERE ept.expense_policies_id =
               v_exp_expense_policies.expense_policies_id
           AND ept.transportation = c1.transportation;
      
        IF (v_count = 0) THEN
          evt_event_core_pkg.fire_event(p_event_name   => v_exp_expense_policies.upper_std_event_name,
                                        p_event_param  => c1.exp_report_line_id,
                                        p_param1       => v_exp_expense_policies.expense_policies_id,
                                        p_param2       => '交通工具不符',
                                        p_event_source => 'EXP_REPORT',
                                        p_event_type   => v_exp_expense_policies.upper_std_event_name,
                                        p_created_by   => p_user_id);
        END IF;
      ELSE*/
      --****************************按行控制*****************************
      IF (v_exp_expense_policies.control_type_code = 'ROW') THEN
      
        --超标准金额
        IF (c1.price > v_exp_expense_policies.expense_standard) THEN
          /*IF (v_exp_expense_policies.upper_std_event_name IS NOT NULL) THEN
            evt_event_core_pkg.fire_event(p_event_name   => v_exp_expense_policies.upper_std_event_name,
                                          p_event_param  => c1.exp_report_line_id,
                                          p_param1       => v_exp_expense_policies.expense_policies_id,
                                          p_event_source => 'EXP_REPORT',
                                          p_event_type   => v_exp_expense_policies.upper_std_event_name,
                                          p_created_by   => p_user_id);
          END IF;*/
        
          v_message := '报销金额超标准费用金额' ||
                       v_exp_expense_policies.expense_standard || '上限';
        
          --插入费用政策临时表
          insert_expense_policies_tmp(p_expense_policies_id  => v_exp_expense_policies.expense_policies_id,
                                      p_exp_report_header_id => c1.exp_report_header_id,
                                      p_line_number          => c1.line_number,
                                      p_msg                  => v_message);
        END IF;
      
        --****************************按天控制***************************** 
        --差旅报销按天控制：校验报销单上“费用项目”一样的所有报销行的单价总和/行数
        --计算结果是否超配置行上的费用标准
      ELSIF (v_exp_expense_policies.control_type_code = 'DAY') THEN
        --超标准金额
        --会议费
        if v_report_type_code = 'HYBX' then
          --二级会议时,公杂费费用项目按餐费费用项目标准控制
          if v_metting_type_code = 'SECOND_LEVEL' then
            --费用项目为公杂费 FY04809,FY05010 加上该报销单下所有对应餐费打包控 
            if v_expense_item_code in ('FY04809', 'FY05010') then
              select count(*), sum(l.price)
                into v_count1, v_sum_price_amount1
                from exp_report_lines l
               where l.exp_report_header_id = c1.exp_report_header_id
                 and l.expense_item_id = c1.expense_item_id;
            
              select count(*), nvl(sum(l.price), 0)
                into v_count2, v_sum_price_amount2
                from exp_report_lines l
               where l.exp_report_header_id = c1.exp_report_header_id
                 and l.expense_item_id = v_expense_item_id;
            
              v_count            := v_count1 + v_count2;
              v_sum_price_amount := v_sum_price_amount1 +
                                    v_sum_price_amount2;
            
              --费用项目为餐费  FY04806,FY05006,加上该报销单下所有对应公杂费打包控               
            elsif v_expense_item_code = 'FY04806' then
              select count(*), sum(l.price)
                into v_count1, v_sum_price_amount1
                from exp_report_lines l
               where l.exp_report_header_id = c1.exp_report_header_id
                 and l.expense_item_id = c1.expense_item_id;
            
              select e.expense_item_id
                into v_expense_item_id
                from EXP_EXPENSE_ITEMS e
               where e.expense_item_code = 'FY04809';
            
              select count(*), nvl(sum(l.price), 0)
                into v_count2, v_sum_price_amount2
                from exp_report_lines l
               where l.exp_report_header_id = c1.exp_report_header_id
                 and l.expense_item_id = v_expense_item_id;
            
              v_count            := v_count1 + v_count2;
              v_sum_price_amount := v_sum_price_amount1 +
                                    v_sum_price_amount2;
            
            elsif v_expense_item_code = 'FY05006' then
              select count(*), sum(l.price)
                into v_count1, v_sum_price_amount1
                from exp_report_lines l
               where l.exp_report_header_id = c1.exp_report_header_id
                 and l.expense_item_id = c1.expense_item_id;
            
              select e.expense_item_id
                into v_expense_item_id
                from EXP_EXPENSE_ITEMS e
               where e.expense_item_code = 'FY05010';
            
              select count(*), nvl(sum(l.price), 0)
                into v_count2, v_sum_price_amount2
                from exp_report_lines l
               where l.exp_report_header_id = c1.exp_report_header_id
                 and l.expense_item_id = v_expense_item_id;
            
              v_count            := v_count1 + v_count2;
              v_sum_price_amount := v_sum_price_amount1 +
                                    v_sum_price_amount2;
            
            end if;
          
          else
            select count(*), sum(l.price)
              into v_count, v_sum_price_amount
              from exp_report_lines l
             where l.exp_report_header_id = c1.exp_report_header_id
               and l.expense_item_id = c1.expense_item_id;
          end if;
        else
          select count(*), sum(l.price)
            into v_count, v_sum_price_amount
            from exp_report_lines l
           where l.exp_report_header_id = c1.exp_report_header_id
             and l.expense_item_id = c1.expense_item_id;
        end if;
      
        --标准费用金额*总申请行数小于总单价金额 
        if v_exp_expense_policies.expense_standard * v_count <
           v_sum_price_amount then
          select f.description_text
            into v_description_text
            from EXP_EXPENSE_ITEMS e, fnd_descriptions f
           where e.expense_item_id = c1.expense_item_id
             and e.description_id = f.description_id
             and rownum = 1;
        
          v_message := '该费用项目【' || v_description_text || '】下,人均报销金额超标准费用金额' ||
                       v_exp_expense_policies.expense_standard || '上限';
        
          --插入费用政策临时表
          insert_expense_policies_tmp(p_expense_policies_id  => v_exp_expense_policies.expense_policies_id,
                                      p_exp_report_header_id => c1.exp_report_header_id,
                                      p_line_number          => c1.line_number,
                                      p_msg                  => v_message);
        
        end if;
      
      ELSIF (v_exp_expense_policies.control_type_code = 'COLLECT') THEN
      
        --会议费
        if v_report_type_code = 'HYBX' then
          --二级会议时,公杂费费用项目按餐费费用项目标准控制
          if v_metting_type_code = 'SECOND_LEVEL' then
            --费用项目为公杂费
            if v_expense_item_code in ('FY04809', 'FY05010') then
              select sum(l.price)
                into v_sum_price_amount1
                from exp_report_lines l
               where l.exp_report_header_id = c1.exp_report_header_id
                 and l.expense_item_id = c1.expense_item_id;
            
              select nvl(sum(l.price), 0)
                into v_sum_price_amount2
                from exp_report_lines l
               where l.exp_report_header_id = c1.exp_report_header_id
                 and l.expense_item_id = v_expense_item_id;
            
              v_sum_price_amount := v_sum_price_amount1 +
                                    v_sum_price_amount2;
            
              --费用项目为餐费  FY04806,FY05006,加上该报销单下所有对应公杂费打包控               
            elsif v_expense_item_code = 'FY04806' then
              select sum(l.price)
                into v_sum_price_amount1
                from exp_report_lines l
               where l.exp_report_header_id = c1.exp_report_header_id
                 and l.expense_item_id = c1.expense_item_id;
            
              select e.expense_item_id
                into v_expense_item_id
                from EXP_EXPENSE_ITEMS e
               where e.expense_item_code = 'FY04809';
            
              select nvl(sum(l.price), 0)
                into v_sum_price_amount2
                from exp_report_lines l
               where l.exp_report_header_id = c1.exp_report_header_id
                 and l.expense_item_id = v_expense_item_id;
            
              v_sum_price_amount := v_sum_price_amount1 +
                                    v_sum_price_amount2;
            
            elsif v_expense_item_code = 'FY05006' then
              select sum(l.price)
                into v_sum_price_amount1
                from exp_report_lines l
               where l.exp_report_header_id = c1.exp_report_header_id
                 and l.expense_item_id = c1.expense_item_id;
            
              select e.expense_item_id
                into v_expense_item_id
                from EXP_EXPENSE_ITEMS e
               where e.expense_item_code = 'FY05010';
            
              select nvl(sum(l.price), 0)
                into v_sum_price_amount2
                from exp_report_lines l
               where l.exp_report_header_id = c1.exp_report_header_id
                 and l.expense_item_id = v_expense_item_id;
            
              v_sum_price_amount := v_sum_price_amount1 +
                                    v_sum_price_amount2;
            
            end if;
          else
            select sum(l.price)
              into v_sum_price_amount
              from exp_report_lines l
             where l.exp_report_header_id = c1.exp_report_header_id
               and l.expense_item_id = c1.expense_item_id;
          end if;
        else
          select sum(l.price)
            into v_sum_price_amount
            from exp_report_lines l
           where l.exp_report_header_id = c1.exp_report_header_id
             and l.expense_item_id = c1.expense_item_id;
        end if;
      
        --相同项目单价汇总超费用费准
        IF v_sum_price_amount > v_exp_expense_policies.expense_standard THEN
        
          select f.description_text
            into v_description_text
            from EXP_EXPENSE_ITEMS e, fnd_descriptions f
           where e.expense_item_id = c1.expense_item_id
             and e.description_id = f.description_id
             and rownum = 1;
        
          v_message := '该费用项目【' || v_description_text || '】下,人均报销金额超标准费用金额' ||
                       v_exp_expense_policies.expense_standard || '上限';
        
          --插入费用政策临时表
          insert_expense_policies_tmp(p_expense_policies_id  => v_exp_expense_policies.expense_policies_id,
                                      p_exp_report_header_id => c1.exp_report_header_id,
                                      p_line_number          => c1.line_number,
                                      p_msg                  => v_message);
        END IF;
      
        --差旅 没有配置根据报销单行上费用项目与配置的费用项目校验交通工具是否匹配
      ELSIF (v_exp_expense_policies.control_type_code IS NULL and
            v_exp_expense_policies.expense_policies_id is not null) THEN
      
        select count(*)
          into v_count
          from exp_expense_policies p
         where (p.company_level_id =
               v_exp_expense_policies.company_level_id or
               p.company_level_id is null)
           and (p.currency_code = v_exp_expense_policies.currency_code or
               p.currency_code is null)
           and (p.position_id = v_exp_expense_policies.position_id or
               p.position_id is null)
           and (p.job_id = v_exp_expense_policies.job_id or
               p.job_id is null)
           and (p.level1_unit_id = v_exp_expense_policies.level1_unit_id or
               p.level1_unit_id is null)
           and (p.expense_item_id = v_exp_expense_policies.expense_item_id or
               p.expense_item_id is null)
           and (p.employee_levels_id =
               v_exp_expense_policies.employee_levels_id or
               p.employee_levels_id is null)
           and (p.place_type_id = v_exp_expense_policies.place_type_id or
               p.place_type_id is null)
           and (p.place_id = v_exp_expense_policies.place_id or
               p.place_id is null)
           and (p.transportation = c1.transportation or
               p.transportation is null);
      
        if v_count = 0 then
          v_message := '所选择交通工具与费用政策配置不一致！';
        
          --插入费用政策临时表
          insert_expense_policies_tmp(p_expense_policies_id  => v_exp_expense_policies.expense_policies_id,
                                      p_exp_report_header_id => c1.exp_report_header_id,
                                      p_line_number          => c1.line_number,
                                      p_msg                  => v_message);
        end if;
      END IF;
    
    END LOOP;
  
    SELECT COUNT(*)
      INTO v_count
      FROM exp_expense_policies_tmp eep
     WHERE eep.exp_report_header_id = p_exp_report_header_id;
  
    IF (v_count > 0) THEN
      p_over_flag := 'Y';
    
      --报销行上特殊情况及报销政策是否提交校验
      for c2 in (SELECT eep.*
                   FROM exp_expense_policies_tmp eep
                  WHERE eep.exp_report_header_id = p_exp_report_header_id) loop
      
        select e.commit_flag
          into v_commit_flag
          from exp_expense_policies e
         where e.expense_policies_id = c2.expense_policies_id;
      
        select e.special_situation
          into v_special_situation
          from exp_report_lines e
         where e.exp_report_header_id = c2.exp_report_header_id
           and e.line_number = c2.line_number;
      
        if (v_commit_flag = 'N' and v_special_situation = 'Y') or
           (v_commit_flag = 'Y' and v_special_situation = 'N') or
           (v_commit_flag = 'Y' and v_special_situation = 'Y') then
          --允许提交
          p_commit_flag := 'Y';
        else
          p_commit_flag := 'N';
          exit;
        end if;
      end loop;
    ELSE
      p_over_flag := 'N';
    END IF;
  END check_policy;

  /*************************************************
  -- Author  : RICK
  -- Created : 2017-9-21 14:52:51
  -- Purpose : 获取超标准岗位代码
  **************************************************/
  FUNCTION get_policy_position(p_exp_report_header_id NUMBER) RETURN VARCHAR2 IS
    v_result VARCHAR2(300);
    v_count  NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM exp_expense_policies_tmp t
     WHERE t.exp_report_header_id = p_exp_report_header_id;
  
    IF (v_count > 0) THEN
      SELECT eop.position_code
        INTO v_result
        FROM exp_report_headers h, exp_org_position eop
       WHERE h.exp_report_header_id = p_exp_report_header_id
         AND h.position_id = eop.position_id;
    END IF;
  
    v_result := nvl(v_result, -1);
    RETURN v_result;
  END get_policy_position;

  /*************************************************
  -- Author  : RICK
  -- Created : 2017-9-21 14:52:51
  -- Purpose : 获取超标准员工级别
  **************************************************/
  FUNCTION get_policy_employee_levels(p_exp_report_header_id NUMBER)
    RETURN VARCHAR2 IS
    v_result VARCHAR2(300);
    v_count  NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM exp_expense_policies_tmp t
     WHERE t.exp_report_header_id = p_exp_report_header_id;
  
    IF (v_count > 0) THEN
      SELECT MIN(eel.employee_levels_code)
        INTO v_result
        FROM exp_employee_assigns eea,
             exp_org_position     eop,
             exp_employee_levels  eel,
             exp_report_headers   h
       WHERE eea.employee_id = h.employee_id
         AND eea.enabled_flag = 'Y'
         AND eea.position_id = eop.position_id
         AND eop.enabled_flag = 'Y'
         AND eop.employee_levels_code = eel.employee_levels_code
         AND h.exp_report_header_id = p_exp_report_header_id;
    END IF;
  
    v_result := nvl(v_result, '-1');
    RETURN v_result;
  END get_policy_employee_levels;
END cux_exp_policy_pkg;
/
