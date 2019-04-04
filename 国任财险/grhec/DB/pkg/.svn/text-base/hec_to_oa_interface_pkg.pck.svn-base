CREATE OR REPLACE PACKAGE hec_to_oa_interface_pkg IS

  -- Author  : Liyuhang 
  -- Created : 2018/4/9 18:56:52
  -- Purpose : HEC和OA的接口

  -- Public type declarations
  PROCEDURE insert_con_contract_oa(p_contract_code     VARCHAR2,
                                   p_contract_number   VARCHAR2,
                                   p_contract_url      VARCHAR2,
                                   p_company_code      VARCHAR2,
                                   p_company_name      VARCHAR2,
                                   p_unit_code         VARCHAR2,
                                   p_unit_name         VARCHAR2,
                                   p_contract_date     VARCHAR2,
                                   p_approve_date      VARCHAR2,
                                   p_contract_promoter VARCHAR2,
                                   p_attribute1        VARCHAR2,
                                   p_attribute2        VARCHAR2,
                                   p_attribute3        VARCHAR2,
                                   p_attribute4        VARCHAR2,
                                   p_attribute5        VARCHAR2,
                                   p_attribute6        VARCHAR2,
                                   p_attribute7        VARCHAR2,
                                   p_attribute8        VARCHAR2,
                                   p_attribute9        VARCHAR2,
                                   p_attribute10       VARCHAR2,
                                   p_result            OUT VARCHAR2);

  PROCEDURE insert_con_sign_oa(p_sig_code          VARCHAR2,
                               p_sig_number        VARCHAR2,
                               p_sign_url          VARCHAR2,
                               p_company_code      VARCHAR2 DEFAULT NULL,
                               p_unit_code         VARCHAR2 DEFAULT NULL,
                               p_oa_sign_type_code VARCHAR2 DEFAULT NULL,
                               p_oa_sign_type_desc VARCHAR2 DEFAULT NULL,
                               p_oa_sign_applyer   VARCHAR2 DEFAULT NULL,
                               p_oa_sign_email     VARCHAR2 DEFAULT NULL,
                               p_error_msg         OUT VARCHAR2,
                               p_result            OUT VARCHAR2);

  FUNCTION get_token(p_user_name VARCHAR2) RETURN VARCHAR;
  FUNCTION get_oa_con_company_id(p_contract_promoter VARCHAR2) RETURN NUMBER;

  PROCEDURE load_con_sign_oa(p_sig_code          VARCHAR2,
                             p_sig_number        VARCHAR2,
                             p_sign_url          VARCHAR2,
                             p_company_code      VARCHAR2 DEFAULT NULL,
                             p_unit_code         VARCHAR2 DEFAULT NULL,
                             p_oa_sign_type_code VARCHAR2 DEFAULT NULL,
                             p_oa_sign_type_desc VARCHAR2 DEFAULT NULL,
                             p_oa_sign_applyer   VARCHAR2 DEFAULT NULL);

  --签报授权
  procedure insert_oa_sign_authorities(p_employee_id         number,
                                       p_granted_employee_id number,
                                       p_company_id          number,
                                       p_unit_id             number,
                                       p_position_id         number,
                                       p_user_id             number,
                                       p_sign_id             number,
                                       p_enabled_flag        varchar2);
END hec_to_oa_interface_pkg;
/
CREATE OR REPLACE PACKAGE BODY hec_to_oa_interface_pkg IS

  PROCEDURE insert_con_contract_oa(p_contract_code     VARCHAR2,
                                   p_contract_number   VARCHAR2,
                                   p_contract_url      VARCHAR2,
                                   p_company_code      VARCHAR2,
                                   p_company_name      VARCHAR2,
                                   p_unit_code         VARCHAR2,
                                   p_unit_name         VARCHAR2,
                                   p_contract_date     VARCHAR2,
                                   p_approve_date      VARCHAR2,
                                   p_contract_promoter VARCHAR2,
                                   p_attribute1        VARCHAR2,
                                   p_attribute2        VARCHAR2,
                                   p_attribute3        VARCHAR2,
                                   p_attribute4        VARCHAR2,
                                   p_attribute5        VARCHAR2,
                                   p_attribute6        VARCHAR2,
                                   p_attribute7        VARCHAR2,
                                   p_attribute8        VARCHAR2,
                                   p_attribute9        VARCHAR2,
                                   p_attribute10       VARCHAR2,
                                   p_result            OUT VARCHAR2) IS
    v_result  VARCHAR2(10);
    v_user_id NUMBER;
  BEGIN
    v_result := 'OK';
    SELECT nvl(su.user_id, -1)
      INTO v_user_id
      FROM sys_user su
     WHERE su.user_name = p_contract_promoter;
    INSERT INTO con_contract_oa
      (contract_id,
       contract_code,
       contract_name,
       contract_url,
       company_code,
       company_name,
       unit_code,
       unit_name,
       contract_date,
       approve_date,
       contract_promoter,
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
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (con_contract_oa_s.nextval,
       p_contract_code,
       p_contract_number,
       p_contract_url,
       p_company_code,
       p_company_name,
       p_unit_code,
       p_unit_name,
       p_contract_date,
       p_approve_date,
       p_contract_promoter,
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
       v_user_id,
       SYSDATE,
       v_user_id,
       SYSDATE);
    p_result := v_result;
  EXCEPTION
    WHEN no_data_found THEN
      v_result := 'FAIL';
      p_result := v_result;
  END;

  PROCEDURE load_con_sign_oa(p_sig_code          VARCHAR2,
                             p_sig_number        VARCHAR2,
                             p_sign_url          VARCHAR2,
                             p_company_code      VARCHAR2 DEFAULT NULL,
                             p_unit_code         VARCHAR2 DEFAULT NULL,
                             p_oa_sign_type_code VARCHAR2 DEFAULT NULL,
                             p_oa_sign_type_desc VARCHAR2 DEFAULT NULL,
                             p_oa_sign_applyer   VARCHAR2 DEFAULT NULL) IS
    v_result        VARCHAR2(10);
    v_count         NUMBER;
    v_comp_lev      VARCHAR2(10);
    v_doc_type      VARCHAR2(100);
    v_resolve_users VARCHAR2(200);
    v_sign_id       NUMBER;
  
    v_company_code VARCHAR2(20);
    v_unit_code    VARCHAR2(20);
  BEGIN
    SELECT COUNT(1)
      INTO v_count
      FROM fnd_companies fc
     WHERE fc.sap_code = p_company_code;
  
    IF (v_count = 0) THEN
      dbms_output.put_line('没有找到公司:' || p_company_code);
      RETURN;
    END IF;
  
    SELECT COUNT(1)
      INTO v_count
      FROM con_sign_oa cso
     WHERE cso.sign_code = p_sig_code;
  
    IF (v_count > 0) THEN
      dbms_output.put_line('签报号已存在:' || p_sig_code);
      RETURN;
    END IF;
  
    SELECT COUNT(1)
      INTO v_count
      FROM exp_org_unit eou, fnd_companies fc
     WHERE eou.company_id = fc.company_id
       AND fc.sap_code = p_company_code
       AND eou.hr_code = p_unit_code
       AND eou.enabled_flag = 'Y';
  
    IF (v_count = 0) THEN
      dbms_output.put_line('费控错误:部门代码在该机构下不存在!' || p_company_code || '-' ||
                           p_unit_code);
      RETURN;
    END IF;
  
    SELECT fcv.company_level_code
      INTO v_comp_lev
      FROM fnd_companies fc, fnd_company_levels fcv
     WHERE fc.company_level_id = fcv.company_level_id
       AND fc.sap_code = p_company_code;
  
    --总公司生成报销单
    IF (v_comp_lev = '10') THEN
      v_doc_type := 'EXP_REPORT';
    ELSE
      --分公司生成申请单
      v_doc_type := 'EXP_REQUISITION';
    END IF;
  
    --处理人取部门预算岗
    FOR c1 IN (SELECT su.user_id, fc.company_code, eou.unit_code
                 FROM fnd_companies        fc,
                      exp_org_unit         eou,
                      exp_employee_assigns eea,
                      sys_user             su
                WHERE fc.company_id = eou.company_id
                  AND fc.sap_code = p_company_code
                  AND eou.hr_code = p_unit_code
                  AND eou.enabled_flag = 'Y'
                  AND eea.position_id = eou.budget_position_id
                  AND fc.company_id = eea.company_id
                  AND eea.enabled_flag = 'Y'
                     --AND eea.primary_position_flag = 'Y'
                  AND eea.employee_id = su.employee_id
                GROUP BY su.user_id, fc.company_code, eou.unit_code) LOOP
      IF (v_resolve_users IS NOT NULL) THEN
        v_resolve_users := v_resolve_users || ';';
      END IF;
      v_resolve_users := v_resolve_users || c1.user_id;
    
      v_company_code := c1.company_code;
      v_unit_code    := c1.unit_code;
    END LOOP;
  
    IF (v_resolve_users IS NULL) THEN
      dbms_output.put_line('没有找到部门预算岗:' || p_company_code || '-' ||
                           p_unit_code);
    END IF;
  
    v_sign_id := con_sign_oa_s.nextval;
  
    INSERT INTO con_sign_oa
      (sign_id,
       sign_code,
       sign_name,
       sign_url,
       company_code,
       unit_code,
       hec_doc_type,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       resolve_users,
       oa_sign_type_code,
       oa_sign_type_desc,
       oa_sign_applyer)
    VALUES
      (v_sign_id,
       p_sig_code,
       p_sig_number,
       p_sign_url,
       v_company_code,
       v_unit_code,
       v_doc_type,
       1,
       SYSDATE,
       1,
       SYSDATE,
       v_resolve_users,
       p_oa_sign_type_code,
       p_oa_sign_type_desc,
       p_oa_sign_applyer);
  END load_con_sign_oa;

  procedure oa_sign_authorities(p_sign_id number, p_oa_sign_email varchar2) is
    v_employee_id        number;
    v_company_id         number;
    v_position_id        number;
    v_unit_id            number;
    v_budget_position_id number;
    v_budget_employee_id number;
  begin
    select e.employee_id
      into v_employee_id
      from exp_employees e
     where e.email = p_oa_sign_email;
  
    --主岗位对应公司，岗位
    select e.company_id, e.position_id
      into v_company_id, v_position_id
      from exp_employee_assigns e
     where e.employee_id = v_employee_id
       and e.primary_position_flag = 'Y';
  
    select u.unit_id
      into v_unit_id
      from exp_org_position u
     where u.company_id = v_company_id
       and u.position_id = v_position_id;
  
    --预算专管员岗位id
    select ou.budget_position_id
      into v_budget_position_id
      from exp_org_unit ou
     where ou.unit_id = v_unit_id;
  
    --部门预算专管员
    for c1 in (select e.employee_id
                 from exp_employees e, exp_employee_assigns ea
                where e.employee_id = ea.employee_id
                  and ea.position_id = v_budget_position_id
                  and ea.company_id = v_company_id) loop
    
      insert into OA_SIGN_AUTHORITIES
        (oa_sign_authority_id,
         employee_id,
         granted_employee_id,
         company_id,
         unit_id,
         position_id,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date,
         sign_id,
         enabled_flag)
      values
        (oa_sign_authority_s.nextval,
         v_employee_id,
         c1.employee_id,
         v_company_id,
         v_unit_id,
         v_position_id,
         1,
         sysdate,
         1,
         sysdate,
         p_sign_id,
         'Y');
    end loop;
  end oa_sign_authorities;

  PROCEDURE insert_con_sign_oa(p_sig_code          VARCHAR2,
                               p_sig_number        VARCHAR2,
                               p_sign_url          VARCHAR2,
                               p_company_code      VARCHAR2 DEFAULT NULL,
                               p_unit_code         VARCHAR2 DEFAULT NULL,
                               p_oa_sign_type_code VARCHAR2 DEFAULT NULL,
                               p_oa_sign_type_desc VARCHAR2 DEFAULT NULL,
                               p_oa_sign_applyer   VARCHAR2 DEFAULT NULL,
                               p_oa_sign_email     VARCHAR2 DEFAULT NULL,
                               p_error_msg         OUT VARCHAR2,
                               p_result            OUT VARCHAR2) IS
    v_result             VARCHAR2(10);
    v_count              NUMBER;
    v_comp_lev           VARCHAR2(10);
    v_doc_type           VARCHAR2(100);
    v_resolve_users      VARCHAR2(200);
    v_resolve_users_name VARCHAR2(200);
    v_sign_id            NUMBER;
  
    v_company_code VARCHAR2(20);
    v_unit_code    VARCHAR2(20);
    v_logs_id      NUMBER;
  BEGIN
    v_result    := 'OK';
    p_error_msg := '调用成功';
  
    cux_oa_interface_pkg.logs(p_cux_oa_trans_logs_id => v_logs_id,
                              p_req_msg              => 'p_sig_code:[' ||
                                                        p_sig_code ||
                                                        ']p_sig_number:[' ||
                                                        p_sig_number ||
                                                        ']p_sign_url:[' ||
                                                        p_sign_url ||
                                                        ']p_company_code:[' ||
                                                        p_company_code ||
                                                        ']p_unit_code:[' ||
                                                        p_unit_code ||
                                                        ']p_company_code:[' ||
                                                        p_company_code ||
                                                        ']p_oa_sign_type_code:[' ||
                                                        p_company_code ||
                                                        ']p_oa_sign_type_desc:[' ||
                                                        p_company_code ||
                                                        ']p_oa_sign_applyer:[' ||
                                                        p_company_code ||
                                                        ']p_oa_sign_email:[' ||
                                                        p_oa_sign_email || ']',
                              p_resp_msg             => NULL,
                              p_record_id            => NULL,
                              p_type                 => 'INSERT_OA_SIGN',
                              p_doc_num              => p_sig_code);
  
    SELECT COUNT(1)
      INTO v_count
      FROM fnd_companies fc
     WHERE fc.sap_code = p_company_code;
  
    IF (v_count = 0) THEN
      p_result    := 'NOK';
      p_error_msg := '费控错误:机构代码不存在!';
      RETURN;
    END IF;
  
    SELECT COUNT(1)
      INTO v_count
      FROM con_sign_oa cso
     WHERE cso.sign_code = p_sig_code;
  
    IF (v_count > 0) THEN
      p_result    := 'NOK';
      p_error_msg := '费控错误:签报号码已经存在!';
      RETURN;
    END IF;
  
    SELECT COUNT(1)
      INTO v_count
      FROM exp_org_unit eou, fnd_companies fc
     WHERE eou.company_id = fc.company_id
       AND fc.sap_code = p_company_code
       AND eou.hr_code = p_unit_code
       AND eou.enabled_flag = 'Y';
  
    IF (v_count = 0) THEN
      p_result    := 'NOK';
      p_error_msg := '费控错误:部门代码在该机构下不存在!';
      RETURN;
    END IF;
  
    select count(*)
      into v_count
      from exp_employees e
     where e.email = p_oa_sign_email;
  
    IF (v_count = 0) THEN
      p_result    := 'NOK';
      p_error_msg := '费控错误:该邮箱未匹配到用户或邮箱在费控不存在!';
      RETURN;
    END IF;
  
    SELECT fcv.company_level_code
      INTO v_comp_lev
      FROM fnd_companies fc, fnd_company_levels fcv
     WHERE fc.company_level_id = fcv.company_level_id
       AND fc.sap_code = p_company_code;
  
    --总公司生成报销单
    IF (v_comp_lev = '10') THEN
      v_doc_type := 'EXP_REPORT';
    ELSE
      --分公司生成申请单
      v_doc_type := 'EXP_REQUISITION';
    END IF;
  
    --处理人取部门预算岗
    FOR c1 IN (SELECT su.user_id,
                      fc.company_code,
                      eou.unit_code,
                      su.user_name
                 FROM fnd_companies        fc,
                      exp_org_unit         eou,
                      exp_employee_assigns eea,
                      sys_user             su
                WHERE fc.company_id = eou.company_id
                  AND fc.sap_code = p_company_code
                  AND eou.hr_code = p_unit_code
                  AND eou.enabled_flag = 'Y'
                  AND eea.position_id = eou.budget_position_id
                  AND fc.company_id = eea.company_id
                  AND eea.enabled_flag = 'Y'
                     --AND eea.primary_position_flag = 'Y'
                  AND eea.employee_id = su.employee_id
                GROUP BY su.user_id,
                         fc.company_code,
                         eou.unit_code,
                         su.user_name) LOOP
      IF (v_resolve_users IS NOT NULL) THEN
        v_resolve_users      := v_resolve_users || ',';
        v_resolve_users_name := v_resolve_users_name || ';';
      END IF;
      v_resolve_users      := v_resolve_users || c1.user_id;
      v_resolve_users_name := v_resolve_users_name || c1.user_name;
    
      v_company_code := c1.company_code;
      v_unit_code    := c1.unit_code;
    END LOOP;
  
    IF (v_resolve_users IS NULL) THEN
      p_result    := 'NOK';
      p_error_msg := '费控错误:无法在该部门预算管理岗下找到对应的员工!';
      RETURN;
    END IF;
  
    v_sign_id := con_sign_oa_s.nextval;
  
    INSERT INTO con_sign_oa
      (sign_id,
       sign_code,
       sign_name,
       sign_url,
       company_code,
       unit_code,
       hec_doc_type,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       resolve_users,
       oa_sign_type_code,
       oa_sign_type_desc,
       oa_sign_applyer)
    VALUES
      (v_sign_id,
       p_sig_code,
       p_sig_number,
       p_sign_url,
       v_company_code,
       v_unit_code,
       v_doc_type,
       1,
       SYSDATE,
       1,
       SYSDATE,
       v_resolve_users,
       p_oa_sign_type_code,
       p_oa_sign_type_desc,
       p_oa_sign_applyer);
  
    --OA签报授权
    oa_sign_authorities(v_sign_id, p_oa_sign_email);
  
    --发送待办至OA
    cux_oa_interface_pkg.sign_send_todo_to_oa(v_sign_id);
    --发送待阅
    IF (v_resolve_users_name IS NOT NULL) THEN
      cux_oa_interface_pkg.sign_red_user_to_oa(v_sign_id,
                                               v_resolve_users_name);
    END IF;
    p_result := v_result;
  
    cux_oa_interface_pkg.logs(p_cux_oa_trans_logs_id => v_logs_id,
                              p_req_msg              => 'p_error_msg:[' ||
                                                        p_error_msg ||
                                                        ']p_result:[' ||
                                                        p_result || ']',
                              p_resp_msg             => NULL,
                              p_record_id            => NULL,
                              p_type                 => 'INSERT_OA_SIGN',
                              p_doc_num              => p_sig_code);
  EXCEPTION
    WHEN no_data_found THEN
      v_result := 'FAIL';
      p_result := v_result;
    
      cux_oa_interface_pkg.logs(p_cux_oa_trans_logs_id => v_logs_id,
                                p_req_msg              => 'p_error_msg:[' ||
                                                          p_error_msg ||
                                                          ']p_result:[' ||
                                                          p_result || ']',
                                p_resp_msg             => NULL,
                                p_record_id            => NULL,
                                p_type                 => 'INSERT_OA_SIGN',
                                p_doc_num              => p_sig_code);
  END;

  FUNCTION get_token(p_user_name VARCHAR2) RETURN VARCHAR IS
    v_user_id NUMBER;
    v_token   VARCHAR2(100);
    v_result  VARCHAR2(200);
    e_user_null_exception EXCEPTION;
  BEGIN
    BEGIN
      BEGIN
        SELECT s.user_id
          INTO v_user_id
          FROM sys_user s
         WHERE s.user_name = upper(p_user_name);
      EXCEPTION
        WHEN no_data_found THEN
          RAISE e_user_null_exception;
      END;
      BEGIN
        SELECT s.encrypted_sso_session_id
          INTO v_token
          FROM sys_sso_login_session s
         WHERE s.user_id = v_user_id
           AND s.oa_flag = 'Y';
      EXCEPTION
        WHEN no_data_found THEN
          v_token := sys_sso_login_session_pkg.create_sso_login_session(upper(p_user_name),
                                                                        'Y');
      END;
      v_result := v_token;
    EXCEPTION
      WHEN e_user_null_exception THEN
        v_result := '获取token失败，当前用户在费控系统中不存在！';
    END;
    RETURN v_result;
  END;
  FUNCTION get_oa_con_company_id(p_contract_promoter VARCHAR2) RETURN NUMBER IS
    v_result     NUMBER;
    v_level_code VARCHAR2(20);
  BEGIN
    SELECT eea.company_id
      INTO v_result
      FROM exp_employee_assigns eea
     WHERE eea.employee_id =
           (SELECT ee.employee_id
              FROM exp_employees ee
             WHERE ee.employee_code = p_contract_promoter)
       AND eea.enabled_flag = 'Y'
       AND eea.primary_position_flag = 'Y';
  
    SELECT l.company_level_code
      INTO v_level_code
      FROM fnd_company_levels l
     WHERE l.company_level_id =
           (SELECT fc.company_level_id
              FROM fnd_companies fc
             WHERE fc.company_id = v_result);
  
    IF v_level_code = '30' THEN
      --中支公司则返回上级公司id
      SELECT fc.parent_company_id
        INTO v_result
        FROM fnd_companies fc
       WHERE fc.company_id = v_result;
    END IF;
    RETURN v_result;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN - 1;
    WHEN too_many_rows THEN
      RETURN - 1;
  END get_oa_con_company_id;

  --签报授权
  procedure insert_oa_sign_authorities(p_employee_id         number,
                                       p_granted_employee_id number,
                                       p_company_id          number,
                                       p_unit_id             number,
                                       p_position_id         number,
                                       p_user_id             number,
                                       p_sign_id             number,
                                       p_enabled_flag        varchar2) is
    v_oa_sign_authority_id number;
    v_user_name            varchar2(100);
    v_logs_id              number;
    v_sign_code            varchar2(100);
  begin
    v_oa_sign_authority_id := oa_sign_authority_s.nextval;
    insert into OA_SIGN_AUTHORITIES
      (OA_SIGN_AUTHORITY_ID,
       EMPLOYEE_ID,
       GRANTED_EMPLOYEE_ID,
       COMPANY_ID,
       UNIT_ID,
       POSITION_ID,
       CREATED_BY,
       CREATION_DATE,
       LAST_UPDATED_BY,
       LAST_UPDATE_DATE,
       SIGN_ID,
       enabled_flag)
    values
      (v_oa_sign_authority_id,
       p_employee_id,
       p_granted_employee_id,
       p_company_id,
       p_unit_id,
       p_position_id,
       p_user_id,
       sysdate,
       p_user_id,
       sysdate,
       p_sign_id,
       p_enabled_flag);
  
    if p_enabled_flag = 'Y' then
      --发送待阅权限
    
      select c.sign_code
        into v_sign_code
        from con_sign_oa c
       where c.sign_id = p_sign_id;
    
      select e.user_name
        into v_user_name
        from sys_user e
       where e.employee_id = p_granted_employee_id;
    
      cux_oa_interface_pkg.logs(p_cux_oa_trans_logs_id => v_logs_id,
                                p_req_msg              => '签报手工授权--' ||
                                                          v_user_name,
                                p_resp_msg             => NULL,
                                p_record_id            => NULL,
                                p_type                 => 'OA_SIGN_AUTHORITIES',
                                p_doc_num              => v_sign_code);
    
      cux_oa_interface_pkg.sign_red_user_to_oa(p_sign_id, v_user_name);
    end if;
  end insert_oa_sign_authorities;
END hec_to_oa_interface_pkg;
/
