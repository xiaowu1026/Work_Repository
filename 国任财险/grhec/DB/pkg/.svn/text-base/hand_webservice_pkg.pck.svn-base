CREATE OR REPLACE PACKAGE hand_webservice_pkg IS

  /*接口使用规范：
      
      1. 参数均为IN OUT VARCHAR2类型，如有日期，请转换
      50个参数中，最后两个参数（p_field_49，p_field_50）是用于状态和消息返回的字段，已经被占用，
      其他字段，均可根据实际需要赋值。可根据p_field_01字段的值来区分不同的接口
      如：p_field_01的值
                LOGIN：代表是 登录接口
                EXP_REPORT_SAVE：代表报销单保存的接口（头行分配行等都一起保存）
                EXP_REPORT_SUBMIT：代表报销单提交的方法
                EXP_REPORT_DELETE_ALL：代表报销单整单删除的方法 
                EXP_REPORT_DELETE_LINE：代表报销单删除行的方法
       
                
       p_field_49 ： 返回消息
       p_field_50 ： 返回代码  OK 表示成功，NOK 表示失败
  */

  PROCEDURE hand_webservice(p_field_01 IN OUT VARCHAR2,
                            p_field_02 IN OUT VARCHAR2,
                            p_field_03 IN OUT VARCHAR2,
                            p_field_04 IN OUT VARCHAR2,
                            p_field_05 IN OUT VARCHAR2,
                            p_field_06 IN OUT VARCHAR2,
                            p_field_07 IN OUT VARCHAR2,
                            p_field_08 IN OUT VARCHAR2,
                            p_field_09 IN OUT VARCHAR2,
                            p_field_10 IN OUT VARCHAR2,
                            p_field_11 IN OUT VARCHAR2,
                            p_field_12 IN OUT VARCHAR2,
                            p_field_13 IN OUT VARCHAR2,
                            p_field_14 IN OUT VARCHAR2,
                            p_field_15 IN OUT VARCHAR2,
                            p_field_16 IN OUT VARCHAR2,
                            p_field_17 IN OUT VARCHAR2,
                            p_field_18 IN OUT VARCHAR2,
                            p_field_19 IN OUT VARCHAR2,
                            p_field_20 IN OUT VARCHAR2,
                            p_field_21 IN OUT VARCHAR2,
                            p_field_22 IN OUT VARCHAR2,
                            p_field_23 IN OUT VARCHAR2,
                            p_field_24 IN OUT VARCHAR2,
                            p_field_25 IN OUT VARCHAR2,
                            p_field_26 IN OUT VARCHAR2,
                            p_field_27 IN OUT VARCHAR2,
                            p_field_28 IN OUT VARCHAR2,
                            p_field_29 IN OUT VARCHAR2,
                            p_field_30 IN OUT VARCHAR2,
                            p_field_31 IN OUT VARCHAR2,
                            p_field_32 IN OUT VARCHAR2,
                            p_field_33 IN OUT VARCHAR2,
                            p_field_34 IN OUT VARCHAR2,
                            p_field_35 IN OUT VARCHAR2,
                            p_field_36 IN OUT VARCHAR2,
                            p_field_37 IN OUT VARCHAR2,
                            p_field_38 IN OUT VARCHAR2,
                            p_field_39 IN OUT VARCHAR2,
                            p_field_40 IN OUT VARCHAR2,
                            p_field_41 IN OUT VARCHAR2,
                            p_field_42 IN OUT VARCHAR2,
                            p_field_43 IN OUT VARCHAR2,
                            p_field_44 IN OUT VARCHAR2,
                            p_field_45 IN OUT VARCHAR2,
                            p_field_46 IN OUT VARCHAR2,
                            p_field_47 IN OUT VARCHAR2,
                            p_field_48 IN OUT VARCHAR2,
                            p_field_49 IN OUT VARCHAR2,
                            p_field_50 IN OUT VARCHAR2);

END hand_webservice_pkg;
/
CREATE OR REPLACE PACKAGE BODY hand_webservice_pkg IS

  /*接口使用规范：
      
      1. 参数均为IN OUT VARCHAR2类型，如有日期，请转换
      50个参数中，最后两个参数（p_field_49，p_field_50）是用于状态和消息返回的字段，已经被占用，
      其他字段，均可根据实际需要赋值。可根据p_field_01字段的值来区分不同的接口
      如：p_field_01的值
                LOGIN：代表是 登录接口
                EXP_REPORT_SAVE：代表报销单保存的接口（头行分配行等都一起保存）
                EXP_REPORT_SUBMIT：代表报销单提交的方法
                EXP_REPORT_DELETE_ALL：代表报销单整单删除的方法 
                EXP_REPORT_DELETE_LINE：代表报销单删除行的方法
       
                
       p_field_49 ： 返回消息
       p_field_50 ： 返回代码  OK 表示成功，NOK 表示失败
  */

  PROCEDURE hand_webservice(p_field_01 IN OUT VARCHAR2, -- 用于区分不同方法
                            p_field_02 IN OUT VARCHAR2,
                            p_field_03 IN OUT VARCHAR2,
                            p_field_04 IN OUT VARCHAR2,
                            p_field_05 IN OUT VARCHAR2,
                            p_field_06 IN OUT VARCHAR2,
                            p_field_07 IN OUT VARCHAR2,
                            p_field_08 IN OUT VARCHAR2,
                            p_field_09 IN OUT VARCHAR2,
                            p_field_10 IN OUT VARCHAR2,
                            p_field_11 IN OUT VARCHAR2,
                            p_field_12 IN OUT VARCHAR2,
                            p_field_13 IN OUT VARCHAR2,
                            p_field_14 IN OUT VARCHAR2,
                            p_field_15 IN OUT VARCHAR2,
                            p_field_16 IN OUT VARCHAR2,
                            p_field_17 IN OUT VARCHAR2,
                            p_field_18 IN OUT VARCHAR2,
                            p_field_19 IN OUT VARCHAR2,
                            p_field_20 IN OUT VARCHAR2,
                            p_field_21 IN OUT VARCHAR2,
                            p_field_22 IN OUT VARCHAR2,
                            p_field_23 IN OUT VARCHAR2,
                            p_field_24 IN OUT VARCHAR2,
                            p_field_25 IN OUT VARCHAR2,
                            p_field_26 IN OUT VARCHAR2,
                            p_field_27 IN OUT VARCHAR2,
                            p_field_28 IN OUT VARCHAR2,
                            p_field_29 IN OUT VARCHAR2,
                            p_field_30 IN OUT VARCHAR2,
                            p_field_31 IN OUT VARCHAR2,
                            p_field_32 IN OUT VARCHAR2,
                            p_field_33 IN OUT VARCHAR2,
                            p_field_34 IN OUT VARCHAR2,
                            p_field_35 IN OUT VARCHAR2,
                            p_field_36 IN OUT VARCHAR2,
                            p_field_37 IN OUT VARCHAR2,
                            p_field_38 IN OUT VARCHAR2,
                            p_field_39 IN OUT VARCHAR2,
                            p_field_40 IN OUT VARCHAR2,
                            p_field_41 IN OUT VARCHAR2,
                            p_field_42 IN OUT VARCHAR2,
                            p_field_43 IN OUT VARCHAR2,
                            p_field_44 IN OUT VARCHAR2,
                            p_field_45 IN OUT VARCHAR2,
                            p_field_46 IN OUT VARCHAR2,
                            p_field_47 IN OUT VARCHAR2,
                            p_field_48 IN OUT VARCHAR2,
                            p_field_49 IN OUT VARCHAR2, -- 返回消息
                            p_field_50 IN OUT VARCHAR2 -- 返回状态 OK 表示成功，NOK 表示失败
                            ) IS
    v_session_id          NUMBER;
    v_encryted_session_id VARCHAR2(512);
    v_user_id             NUMBER;
    v_error_message       VARCHAR2(4000) := '';
    v_temp_count          NUMBER;
    v_company_id          NUMBER;
    v_role_id             NUMBER;
    v_result              VARCHAR2(500);
    v_flag                VARCHAR2(1);
    v_flag_c              NUMBER;
    v_con_code            VARCHAR2(150);
  BEGIN
  
    --保融资金支付结果返回
    IF p_field_01 = 'PAYRESULTBACK' THEN
    
      cux_payment_gr_pkg.ws_get_result_zj(p_input_xml  => p_field_02,
                                          p_output_xml => p_field_03,
                                          p_success    => v_error_message);
    
      IF (v_error_message <> 'OK') THEN
        p_field_49 := '调用接口失败';
        p_field_50 := 'NOK';
      ELSE
        p_field_49 := '调用接口成功';
        p_field_50 := 'OK';
      END IF;
    
      --审批通过,拒绝
    ELSIF p_field_01 = 'AGREE' OR p_field_01 = 'REFUSE' THEN
    
      cux_mobile_wfl_pkg.oa_approve_op(p_record_id    => p_field_02,
                                       p_node_id      => p_field_03,
                                       p_comment_text => p_field_04,
                                       p_user_name    => p_field_05,
                                       p_approve_type => p_field_01,
                                       p_result       => v_error_message);
    
      IF (v_error_message <> 'OK') THEN
        p_field_49 := v_error_message;
        p_field_50 := 'NOK';
      ELSE
        p_field_49 := nvl(v_error_message, '调用成功');
        p_field_50 := 'OK';
      END IF;
      --转交
    ELSIF p_field_01 = 'COMMISSION' THEN
      cux_mobile_wfl_pkg.workflow_commission(p_record_id   => p_field_02,
                                             p_employee_id => p_field_03,
                                             p_comment     => p_field_04);
      p_field_49 := nvl(v_error_message, '转交成功');
      p_field_50 := 'OK';
      --添加审批人
    ELSIF p_field_01 = 'ADD_APPROVER' THEN
      cux_mobile_wfl_pkg.workflow_add_approver(p_record_id    => p_field_02,
                                               p_employee_ids => p_field_03,
                                               p_comment      => p_field_04,
                                               p_user_name    => p_field_05);
      p_field_49 := nvl(v_error_message, '添加审批人成功');
      p_field_50 := 'OK';
      --登录校验
    ELSIF p_field_01 = 'LOGIN_CHECK' THEN
      cux_mobile_wfl_pkg.chec_login(p_user_name => p_field_02,
                                    p_password  => p_field_03,
                                    p_result    => v_error_message);
      IF (v_error_message = 'OK') THEN
        p_field_49 := '调用成功';
        p_field_50 := 'OK';
      ELSE
        p_field_49 := '调用失败';
        p_field_50 := 'NOK';
      END IF;
      --获取影像参数
    ELSIF p_field_01 = 'GET_IMG_PARAM' THEN
      cux_mobile_wfl_pkg.get_img_param(p_document_number => p_field_02,
                                       p_result          => v_result,
                                       p_error_msg       => v_error_message);
      IF (v_error_message = 'OK') THEN
        p_field_49 := v_result;
        p_field_50 := 'OK';
      ELSE
        p_field_49 := '调用失败';
        p_field_50 := 'NOK';
      END IF;
    ELSIF p_field_01 = 'OA_CONTRACT_INFO' THEN
      /*BEGIN
        
        SELECT 'Y'
          INTO v_flag
          FROM con_contract_oa co
         WHERE co.contract_code = p_field_02
         AND   co.contract_name = p_field_03;
      EXCEPTION
        WHEN no_data_found THEN
          hec_to_oa_interface_pkg.insert_con_contract_oa(p_contract_code   => p_field_02,
                                                         p_contract_number => p_field_03,
                                                         p_contract_url    => p_field_04,
                                                         p_result          => v_error_message);
      END;*/
      IF p_field_02 IS NULL OR p_field_02 = '' THEN
        v_con_code := fnd_code_rule_pkg.get_rule_next_auto_num(p_document_category => 'OA_CON_CODE',
                                                               p_document_type     => NULL,
                                                               p_company_id        => 835,
                                                               p_operation_unit_id => NULL,
                                                               p_operation_date    => SYSDATE,
                                                               p_created_by        => 1);
      
        hec_to_oa_interface_pkg.insert_con_contract_oa(p_contract_code     => v_con_code,
                                                       p_contract_number   => p_field_03,
                                                       p_contract_url      => p_field_04,
                                                       p_company_code      => p_field_05,
                                                       p_company_name      => p_field_06,
                                                       p_unit_code         => p_field_07,
                                                       p_unit_name         => p_field_08,
                                                       p_contract_date     => p_field_09,
                                                       p_approve_date      => p_field_10,
                                                       p_contract_promoter => p_field_11,
                                                       p_attribute1        => p_field_12,
                                                       p_attribute2        => p_field_13,
                                                       p_attribute3        => p_field_14,
                                                       p_attribute4        => p_field_15,
                                                       p_attribute5        => p_field_16,
                                                       p_attribute6        => p_field_17,
                                                       p_attribute7        => p_field_18,
                                                       p_attribute8        => p_field_19,
                                                       p_attribute9        => p_field_20,
                                                       p_attribute10       => p_field_21,
                                                       p_result            => v_error_message);
      ELSE
        SELECT COUNT(1)
          INTO v_flag_c
          FROM con_contract_oa cc
         WHERE cc.contract_name = p_field_03
           AND cc.contract_url = p_field_04;
        IF v_flag_c = 0 THEN
          hec_to_oa_interface_pkg.insert_con_contract_oa(p_contract_code     => p_field_02,
                                                         p_contract_number   => p_field_03,
                                                         p_contract_url      => p_field_04,
                                                         p_company_code      => p_field_05,
                                                         p_company_name      => p_field_06,
                                                         p_unit_code         => p_field_07,
                                                         p_unit_name         => p_field_08,
                                                         p_contract_date     => p_field_09,
                                                         p_approve_date      => p_field_10,
                                                         p_contract_promoter => p_field_11,
                                                         p_attribute1        => p_field_12,
                                                         p_attribute2        => p_field_13,
                                                         p_attribute3        => p_field_14,
                                                         p_attribute4        => p_field_15,
                                                         p_attribute5        => p_field_16,
                                                         p_attribute6        => p_field_17,
                                                         p_attribute7        => p_field_18,
                                                         p_attribute8        => p_field_19,
                                                         p_attribute9        => p_field_20,
                                                         p_attribute10       => p_field_21,
                                                         p_result            => v_error_message);
        END IF;
      END IF;
      IF (v_error_message = 'OK') THEN
        p_field_49 := v_error_message;
        p_field_50 := 'OK';
      ELSE
        p_field_49 := '调用失败';
        p_field_50 := 'NOK';
      END IF;
    ELSIF p_field_01 = 'OA_SIGN_INFO' THEN
      hec_to_oa_interface_pkg.insert_con_sign_oa(p_sig_code   => p_field_02,
                                                 p_sig_number => p_field_03,
                                                 p_sign_url   => p_field_04,
                                                 p_result     => v_error_message);
      IF (v_error_message = 'OK') THEN
        p_field_49 := v_error_message;
        p_field_50 := 'OK';
      ELSE
        p_field_49 := '调用失败';
        p_field_50 := 'NOK';
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      --从sys_raise_app_errors 表取错误信息
      SELECT r.message
        INTO p_field_49
        FROM sys_raise_app_errors r
       WHERE r.app_error_line_id = sys_raise_app_error_pkg.g_err_line_id;
    
      p_field_49 := '异常错误' || p_field_49;
      p_field_50 := 'NOK';
      sys_raise_app_error_pkg.raise_sys_others_error(dbms_utility.format_error_backtrace || ' ' ||
                                                     SQLERRM,
                                                     p_created_by => 1,
                                                     p_package_name => 'hand_webservice_pkg',
                                                     p_procedure_function_name => 'hand_webservice');
    
    /* 不能添加这个处理，不然前端接口获取不到数据
    raise_application_error(sys_raise_app_error_pkg.c_error_number,
                             sys_raise_app_error_pkg.g_err_line_id);*/
  END hand_webservice;

END hand_webservice_pkg;
/
