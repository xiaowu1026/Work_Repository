create or replace package exp_interface_pkg is

  -- Author  : Majianjian
  -- Created : 2013/7/26 15:53:11
  -- Purpose : 报销单行导入

  -- Public type declarations

  -- Public constant declarations

  -- Public variable declarations
  is_debug boolean := false;

  is_enable_log boolean := true;

  -- Public function and procedure declarations
  -- 检查数据完整性。
  function check_exp_expense_interface(p_header_id number) return number;

  -- 删除batch_id垃圾数据
  procedure delete_interface(p_batch_id in number, p_user_id in number);

  -- 插入导入的记录到显示表
  procedure insert_interface(p_header_id in number,
                             p_batch_id  in number,
                             p_user_id   in number);

  function get_dimension_value_id(p_exp_report_type_id number, --报销单类型
                                  p_company_id         number, --投机构
                                  p_unit_id            number, --行部门
                                  p_dimension_sequence number) return number;

  -- 核对数据
  /*  procedure check_line_interface(p_batch_id in number, p_user_id in number);*/
  procedure check_interface(p_batch_id             in number,
                            p_exp_report_header_id in number,
                            p_user_id              in number,
                            p_return_status        out varchar2);

  procedure insert_error_log(p_message in varchar2, p_user_id in number);
  -- 导入报销单行
  procedure load_expense_reports(p_batch_id             in number,
                                 p_exp_report_header_id in number,
                                 p_user_id              in number,
                                 p_load_status          out varchar2);
end exp_interface_pkg;
/
create or replace package body exp_interface_pkg is

  g_batch_id number;

  g_batch_line_id number;

  g_line_number number;

  -- 行号已存在异常
  e_line_number_already_exists exception;

  e_error_header               varchar2(30) := '行号为: ';
  e_exp_report_number_is_null  varchar2(300) := ' 的报销单编号为空';
  e_exp_report_number_error    varchar2(300) := ' 的报销单编号错误，无法获取报销单头ID';
  e_place_code_error           varchar2(300) := ' 的地点代码错误';
  e_place_type_code_error      varchar2(300) := ' 的地点类型代码错误';
  e_company_code_is_null       varchar2(300) := ' 的公司代码为空';
  e_company_code_error         varchar2(300) := ' 的公司代码无效';
  e_period_name_is_null        varchar2(300) := ' 的期间为空';
  e_period_name_error          varchar2(300) := ' 的期间名称错误';
  e_expense_type_code_is_null  varchar2(300) := ' 的报销类型为空';
  e_expense_type_code_error    varchar2(300) := ' 的报销类型代码无效，报销类型代码错误或者报销单未分配该报销类型';
  e_expense_item_cdoe_is_null  varchar2(300) := ' 的费用项目代码为空';
  e_expense_item_code_error    varchar2(300) := ' 的费用项目代码无效，代码错误或者代码不在报销类型中';
  e_budget_item_code_error     varchar2(300) := ' 的预算项代码无效，预算项代码错误或者已被失效';
  e_price_error                varchar2(300) := ' 的单价无效';
  e_primary_quantity_error     varchar2(300) := ' 的数量无效';
  e_unit_code_error            varchar2(300) := ' 的部门代码无效，部门代码错误或者不属于当前公司或者已被失效';
  e_position_code_error        varchar2(300) := ' 的岗位无效，岗位代码错误或者不属于当前部门或者已被失效';
  e_resp_center_code_is_null   varchar2(300) := ' 的责任中心代码为空';
  e_resp_center_code_error     varchar2(300) := ' 的责任中心代码无效，代码错误或已被失效';
  e_employee_code_error        varchar2(300) := ' 的员工代码无效，员工代码错误或者该公司的该岗位未分配给当前员工';
  e_invoice_type_error         varchar2(300) := ' 的发票类型无效，发票类型错误或者该发票类型未启用';
  e_d3_error                   varchar2(300) := ' 的预算专项无效，预算专项错误或者改预算专项未启用';
  e_type_error                 varchar2(300) := ' 的发票类型为非专票时，税额、进项分类、抵扣规则不可以填写';
  e_d3_null_error              varchar2(300) := ' 的预算专项无效，预算专项不能为空值';
  e_exp_report_type_code_null  varchar2(300) := ' 的报销单类型为空';
  e_exp_report_type_code_error varchar2(300) := ' 的报销单类型无效';

  /*  type t_dimension_id_array is table of number;*/

  -- Private type declarations

  -- Private constant declarations

  -- Private variable declarations

  -- Function and procedure implementations
  /**********************************************************************
  * check_exp_expense_interface ：检查导入的数据是否完整。 *** UNUSED ***
  *   parameters:
  *               p_header_id : 存储的header_id
  *   return:
  *               1 : 完整
  *               0 ：不完整
  **********************************************************************/
  function check_exp_expense_interface(p_header_id number) return number is
    v_import_flag number := 1;
    cursor c_fnd_interface_lines is
      select *
        from fnd_interface_lines a
       where a.header_id = p_header_id
         and a.line_number >= 1;
  begin
    for c_fnd_interface_data in c_fnd_interface_lines loop
      if c_fnd_interface_data.attribute_1 is null or
         c_fnd_interface_data.attribute_2 is null or
         c_fnd_interface_data.attribute_3 is null or
         c_fnd_interface_data.attribute_4 is null or
         c_fnd_interface_data.attribute_5 is null or
         c_fnd_interface_data.attribute_6 is null or
         c_fnd_interface_data.attribute_7 is null or
         c_fnd_interface_data.attribute_8 is null or
         c_fnd_interface_data.attribute_9 is null or
         c_fnd_interface_data.attribute_10 is null then
        v_import_flag := 0;
      end if;
    end loop;
    return v_import_flag;
  end;

  /***********************************************************************
  * delete_interface : 删除exp_rep_line_interface表中的batch_id垃圾
  *       parameters :
  *             p_batch_id : 垃圾batch_id
  *             p_user_id :  垃圾user_id
  *
  ***********************************************************************/
  procedure delete_interface(p_batch_id in number, p_user_id in number) is
  begin
    delete from exp_rep_line_interface e where e.batch_id = p_batch_id;
  exception
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_procedure_function_name => 'delete_inferface');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;
  -- 格式化代码
  function format_code(p_code in varchar2) return varchar2 is
    v_code varchar2(200);
    v_pos  number;
  begin
    v_code := p_code;
    select instr(p_code, '.') into v_pos from dual;
    if v_pos > 0 then
      select substr(p_code, 0, instr(p_code, '.') - 1)
        into v_code
        from dual;
    end if;
    return v_code;
  exception
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_created_by              => 1,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_procedure_function_name => 'format_code');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  /**********************************************************************
  *  insert_interface : 将临时表fnd_interface_lines中的内容导入到exp_rep_line_interface表中
  *    parameters:
  *        p_header_id : 用来检索fnd_interface_lines表中的内容
  *        p_batch_id : 本次插入的批次
  *        p_user_id : user_id
  *********************************************************************/
  procedure insert_interface(p_header_id in number,
                             p_batch_id  in number,
                             p_user_id   in number) is
    cursor c_fnd_lines_datas is
      select *
        from fnd_interface_lines a
       where a.header_id = p_header_id
         and a.line_number >= 1;
  begin
    for v_fnd_lines_data in c_fnd_lines_datas loop
      v_fnd_lines_data.attribute_2  := format_code(v_fnd_lines_data.attribute_2); --报销单类型码
      v_fnd_lines_data.attribute_4  := format_code(v_fnd_lines_data.attribute_4); --
      v_fnd_lines_data.attribute_5  := format_code(v_fnd_lines_data.attribute_5);
      v_fnd_lines_data.attribute_6  := format_code(v_fnd_lines_data.attribute_6);
      v_fnd_lines_data.attribute_7  := format_code(v_fnd_lines_data.attribute_7);
      v_fnd_lines_data.attribute_10 := format_code(v_fnd_lines_data.attribute_10);
      v_fnd_lines_data.attribute_11 := format_code(v_fnd_lines_data.attribute_11);
      v_fnd_lines_data.attribute_12 := format_code(v_fnd_lines_data.attribute_12);
      v_fnd_lines_data.attribute_13 := format_code(v_fnd_lines_data.attribute_13);
      v_fnd_lines_data.attribute_16 := format_code(v_fnd_lines_data.attribute_16);
    
      insert into exp_rep_line_interface
        (batch_id,
         import_flag,
         /* batch_line_id, */
         line_number,
         company_code,
         unit_code,
         expense_type_code,
         expense_item_code,
         invoice_type_desc,
         invoice_code,
         invoice_number,
         invoice_check_code,
         invoice_date,
         report_amount,
         invoice_sum_amount,
         invoice_sales_amount,
         tax_rate,
         tax_amount,
         sale_amount,
         invoice_tax_amount_bak,
         /*input_tax_structure_detail,*/
         usage_type,
         
         description,
         date_from,
         date_to,
         place_from,
         place_to,
         employee_levels_code,
         transport_code,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date)
      values
        (p_batch_id,
         'Y',
         v_fnd_lines_data.attribute_1,
         v_fnd_lines_data.attribute_2,
         v_fnd_lines_data.attribute_3,
         v_fnd_lines_data.attribute_4,
         v_fnd_lines_data.attribute_5,
         v_fnd_lines_data.attribute_6,
         v_fnd_lines_data.attribute_7,
         v_fnd_lines_data.attribute_8,
         v_fnd_lines_data.attribute_9,
         to_date(v_fnd_lines_data.attribute_10, 'yyyy-mm-dd'),
         v_fnd_lines_data.attribute_11,
         v_fnd_lines_data.attribute_12,
         v_fnd_lines_data.attribute_13,
         v_fnd_lines_data.attribute_14,
         v_fnd_lines_data.attribute_15,
         v_fnd_lines_data.attribute_16,
         v_fnd_lines_data.attribute_17,
         v_fnd_lines_data.attribute_18,
         v_fnd_lines_data.attribute_19,
         to_date(v_fnd_lines_data.attribute_20, 'yyyy-mm-dd'),
         to_date(v_fnd_lines_data.attribute_21, 'yyyy-mm-dd'),
         v_fnd_lines_data.attribute_22,
         v_fnd_lines_data.attribute_23,
         v_fnd_lines_data.attribute_24,
         v_fnd_lines_data.attribute_25,
         p_user_id,
         sysdate,
         p_user_id,
         sysdate);
    end loop;
  exception
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_procedure_function_name => 'insert_interface');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  -- 删除当前batch_id对应的错误信息
  procedure delete_error_logs is
    pragma autonomous_transaction;
  begin
    delete from exp_rep_line_int_logs a
     where not exists (select 1
              from exp_rep_line_interface b
             where a.batch_id = b.batch_id);
  
    delete from exp_rep_line_int_logs a where a.batch_id = g_batch_id;
  
    commit;
  exception
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_created_by              => 1,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_procedure_function_name => 'delete_error_logs');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  -- 插入错误信息到日志
  procedure insert_error_log(p_message in varchar2, p_user_id in number) is
    pragma autonomous_transaction;
  begin
    if is_enable_log then
      insert into exp_rep_line_int_logs
        (batch_id,
         batch_line_id,
         line_number,
         message,
         message_date,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date)
      values
        (g_batch_id,
         g_batch_line_id,
         g_line_number,
         p_message,
         sysdate,
         p_user_id,
         sysdate,
         p_user_id,
         sysdate);
    end if;
    commit;
  exception
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_created_by              => 1,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_procedure_function_name => 'insert_error_log');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  -- 检验报销单行编号
  function get_exp_report_header_id(p_exp_report_number in varchar2,
                                    p_user_id           in number)
    return number is
    v_header_id number;
  begin
    if p_exp_report_number is null then
      insert_error_log(e_error_header || g_line_number ||
                       e_exp_report_number_is_null,
                       p_user_id);
      return null;
    else
      select exp_report_header_id
        into v_header_id
        from exp_report_headers h
       where h.exp_report_number = p_exp_report_number;
      return v_header_id;
    end if;
  exception
    when no_data_found then
      insert_error_log(e_error_header || g_line_number ||
                       e_exp_report_number_error,
                       p_user_id);
    
      return null;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'get_expense_type_id');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  -- 检验地点代码
  function get_place_id(p_place_code in varchar2, p_user_id in number)
    return number is
    v_place_id number;
  begin
    if p_place_code is not null then
      select place_id
        into v_place_id
        from exp_policy_places p
       where p.place_code = p_place_code;
      return v_place_id;
    end if;
    return null;
  exception
    when no_data_found then
      insert_error_log(e_error_header || g_line_number ||
                       e_place_code_error,
                       p_user_id);
      return null;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'get_place_id');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  --校验员工级别代码
  function get_employee_levels_id(p_employee_levels_code varchar2,
                                  p_user_id              number)
    return number is
    v_employee_levels_id number;
  begin
    select eel.employee_levels_id
      into v_employee_levels_id
      from exp_employee_levels eel
     where eel.employee_levels_code = p_employee_levels_code;
    return v_employee_levels_id;
  exception
    when no_data_found then
      insert_error_log(e_error_header || g_line_number || '员工级别代码不存在',
                       p_user_id);
      return null;
  end;

  --校验交通工具代码
  function check_transport_code(p_transport_code varchar2,
                                p_user_id        number) return number is
    v_exists number;
  begin
    select count(1)
      into v_exists
      from sys_codes_vl sc, sys_code_values_vl s
     where s.code_id = sc.code_id
       and sc.code = 'TRANSPORTATION'
       and s.code_value = p_transport_code;
  
    if v_exists = 0 then
      insert_error_log(e_error_header || g_line_number || '交通工具代码系统不存在',
                       p_user_id);
    end if;
    return v_exists;
  end;
  -- 检验地点类型代码
  function get_place_type_id(p_place_type_code varchar2,
                             p_user_id         in number) return number is
    v_place_type_id number;
  begin
    if p_place_type_code is not null then
      select place_type_id
        into v_place_type_id
        from exp_policy_place_types t
       where t.place_type_code = p_place_type_code;
      return v_place_type_id;
    end if;
    return null;
  exception
    when no_data_found then
      insert_error_log(e_error_header || g_line_number ||
                       e_place_type_code_error,
                       p_user_id);
      return null;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'get_place_type_id');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  -- 日期转换辅助工具
  function to_date_or_null(p_date_string   in varchar2,
                           p_format_string in varchar2) return date is
    v_date date;
  begin
    v_date := to_date(p_date_string, p_format_string);
    return v_date;
  exception
    when others then
      return null;
  end;

  -- 检查日期
  function check_date(p_date_from date,
                      p_date_to   date,
                      p_user_id   in number) return number is
    v_date_from date;
    v_date_to   date;
    v_flag      number := 1;
  begin
    if p_date_from is null and p_date_to is null then
      return v_flag;
    elsif p_date_from is not null and p_date_to is null then
    
      insert_error_log('行号为: ' || g_line_number || ' 的日期到为空',
                       p_user_id);
      v_flag := 0;
      return v_flag;
    
    elsif p_date_from is null and p_date_to is not null then
    
      insert_error_log('行号为: ' || g_line_number || ' 的日期从为空',
                       p_user_id);
      v_flag := 0;
      return v_flag;
    
      if p_date_from > p_date_to then
        insert_error_log('行号为: ' || g_line_number || ' 的日期从大于日期到',
                         p_user_id);
        v_flag := 0;
        return v_flag;
      else
        v_flag := 1;
        return v_flag;
      end if;
    end if;
    return v_flag;
  exception
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'check_date');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;
  --检查报销单类型
  function get_exp_report_type_id(p_company_id           number,
                                  p_exp_report_type_code varchar2,
                                  p_user_id              in number)
    return number is
    v_exp_report_type_id number;
  begin
    if p_exp_report_type_code is null then
      insert_error_log(e_error_header || g_line_number ||
                       e_exp_report_type_code_null,
                       p_user_id);
      return null;
    else
      select expense_report_type_id
        into v_exp_report_type_id
        from exp_expense_report_types e
       where e.expense_report_type_code = p_exp_report_type_code
         and e.company_id = p_company_id;
      return v_exp_report_type_id;
    end if;
  exception
    when no_data_found then
      insert_error_log(e_error_header || g_line_number ||
                       e_company_code_error,
                       p_user_id);
      return null;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'get_exp_report_type_id');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  --检查公司代码
  function get_company_id(p_company_code varchar2, p_user_id in number)
    return number is
    v_company_id number;
  begin
    if p_company_code is null then
      insert_error_log(e_error_header || g_line_number ||
                       e_company_code_is_null,
                       p_user_id);
      return null;
    else
      select company_id
        into v_company_id
        from fnd_companies fc
       where fc.company_code = p_company_code
         and fc.start_date_active <= trunc(sysdate)
         and (fc.end_date_active is null or
             fc.end_date_active >= trunc(sysdate));
      return v_company_id;
    end if;
  exception
    when no_data_found then
      insert_error_log(e_error_header || g_line_number ||
                       e_company_code_error,
                       p_user_id);
      return null;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'get_company_id');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  -- 检查期间
  function check_period_name(p_company_id  in number,
                             p_period_name in varchar2,
                             p_user_id     in number) return number is
    v_flag number;
  begin
    if p_period_name is null then
      insert_error_log(e_error_header || g_line_number ||
                       e_period_name_is_null,
                       p_user_id);
      return null;
    else
      select 1
        into v_flag
        from gld_period_status_v v
       where v.period_name = p_period_name
         and v.adjustment_flag = 'N'
         and v.period_set_code =
             (select b.period_set_code
                from gld_set_of_books b
               where b.set_of_books_id =
                     (select f.set_of_books_id
                        from fnd_companies f
                       where f.company_id = p_company_id))
         and v.company_id = p_company_id
         and v.period_status_code = 'O';
      return v_flag;
    end if;
  exception
    when no_data_found then
      insert_error_log(e_error_header || g_line_number ||
                       e_period_name_error,
                       p_user_id);
      return null;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'check_period_name');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;
  -- 检验报销类型代码
  function get_expense_type_id(p_exp_report_header_id in number,
                               p_company_id           in number,
                               p_expense_type_code    varchar2,
                               p_user_id              in number)
    return number is
    v_expense_type_id number;
  begin
    if p_expense_type_code is null then
      insert_error_log(e_error_header || g_line_number ||
                       e_expense_type_code_is_null,
                       p_user_id);
      return null;
    else
      select expense_type_id
        into v_expense_type_id
        from exp_expense_types t
       where t.expense_type_code = p_expense_type_code
         and t.company_id = p_company_id
         and t.expense_type_id in
             (select rt.expense_type_id
                from exp_report_ref_types rt
               where rt.expense_report_type_id =
                     (select h.exp_report_type_id
                        from exp_report_headers h
                       where h.exp_report_header_id = p_exp_report_header_id));
      return v_expense_type_id;
    end if;
  exception
    when no_data_found then
      insert_error_log(e_error_header || g_line_number ||
                       e_expense_type_code_error,
                       p_user_id);
      return null;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'get_expense_type_id');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  -- 检验费用项目代码
  function get_expense_item_id(p_company_id        in number,
                               p_expense_type_id   in number,
                               p_expense_item_code in varchar2,
                               p_user_id           in number) return number is
    v_expense_item_id number;
  begin
    if p_expense_item_code is null then
      insert_error_log(e_error_header || g_line_number ||
                       e_expense_item_cdoe_is_null,
                       p_user_id => p_user_id);
      return null;
    else
      select i.expense_item_id
        into v_expense_item_id
        from exp_expense_items i
       where i.expense_item_code = p_expense_item_code
         and i.set_of_books_id =
             (select set_of_books_id
                from fnd_companies fc
               where fc.company_id = p_company_id)
         and i.expense_item_id in
             (select it.expense_item_id
                from exp_expense_item_types it
               where it.expense_type_id = p_expense_type_id);
      return v_expense_item_id;
    end if;
  exception
    when no_data_found then
      insert_error_log(e_error_header || g_line_number ||
                       e_expense_item_code_error,
                       p_user_id => p_user_id);
      return null;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'get_expense_item_id');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  -- 检验预算项代码
  function get_bgt_item_id(p_company_id       in number,
                           p_budget_item_code in varchar2,
                           p_user_id          in number) return number is
    v_bgt_item_id number;
  begin
    if p_budget_item_code is not null then
      select i.budget_item_id
        into v_bgt_item_id
        from bgt_budget_items i
       where i.budget_item_code = p_budget_item_code
         and i.enabled_flag = 'Y'
         and i.budget_org_id =
             (select o.bgt_org_id
                from bgt_organizations o
               where o.set_of_books_id =
                     (select set_of_books_id
                        from fnd_companies fc
                       where fc.company_id = p_company_id));
      return v_bgt_item_id;
    end if;
    return null;
  exception
    when no_data_found then
      insert_error_log(e_error_header || g_line_number ||
                       e_budget_item_code_error,
                       p_user_id => p_user_id);
      return null;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'get_bgt_item_id');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  -- 检验价格
  function check_price(p_price in number, p_user_id in number) return number is
    v_price_flag number := 0;
    v_price      number;
  begin
    if p_price is null then
      insert_error_log(e_error_header || g_line_number || e_price_error,
                       p_user_id => p_user_id);
      return v_price_flag;
    else
      select to_number(p_price) into v_price from dual;
      v_price_flag := 1;
      return v_price_flag;
    end if;
  exception
    when value_error then
      v_price_flag := 0;
      insert_error_log(e_error_header || g_line_number || e_price_error,
                       p_user_id => p_user_id);
      return v_price_flag;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'check_price');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  -- 检验数量
  function check_primary_quantity(p_primary_quantity in number,
                                  p_user_id          in number) return number is
    v_quantity_flag number := 0;
    v_quantity      number;
  begin
    if p_primary_quantity is null then
      insert_error_log(e_error_header || g_line_number ||
                       e_primary_quantity_error,
                       p_user_id => p_user_id);
      return v_quantity_flag;
    else
      select to_number(p_primary_quantity) into v_quantity from dual;
      v_quantity_flag := 1;
      return v_quantity_flag;
    end if;
  exception
    when value_error then
      insert_error_log(e_error_header || g_line_number ||
                       e_primary_quantity_error,
                       p_user_id => p_user_id);
      v_quantity_flag := 0;
      return v_quantity_flag;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'check_primary_quantity');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  --税率代码校验
  function get_tax_rate(p_tax_rate_code varchar, p_user_id in number)
    return number is
  begin
    for c_result in (select s.code_value
                       from sys_code_values_vl s, sys_codes_vl s1
                      where s.code_id = s1.code_id
                        and s1.code = 'TAX_RATE_VALUE'
                        and s.enabled_flag = 'Y') loop
      if p_tax_rate_code = c_result.code_value then
        return case p_tax_rate_code when 'VAT1.5' then '0.015' when 'VAT10' then '0.01' when 'VAT11' then '0.11' when 'VAT13' then '0.13' when 'VAT16' then '0.16' when 'VAT17' then '0.17' when 'VAT3' then '0.03' when 'VAT5' then '0.05' when 'VAT6' then '0.06' when 'VAT0' then '0' end;
      end if;
    end loop;
    insert_error_log(e_error_header || g_line_number || '税率代码系统未定义',
                     p_user_id => p_user_id);
    return null;
  end;

  function get_dimension_value_id(p_exp_report_type_id number, --报销单类型
                                  p_company_id         number, --投机构
                                  p_unit_id            number, --行部门
                                  p_dimension_sequence number) return number is
    v_default_dimension_value_id number;
    --序列值
    --根据公司，报销单类型找出配置的维度
  begin
    for c_report_dims in (select fdv.dimension_sequence, --维度序列号                   
                                 --t.expense_report_type_id,
                                 t.dimension_id,
                                 --fdv.dimension_code,
                                 t.default_dim_value_id
                          -- fdvv.dimension_value_code,
                            from exp_rep_ref_dimensions t,
                                 fnd_dimensions_vl fdv,
                                 (select *
                                    from fnd_dimension_values_v fdvv
                                   where fdvv.company_id = p_company_id) fdvv
                           where t.dimension_id = fdv.dimension_id(+)
                             and t.default_dim_value_id =
                                 fdvv.dimension_value_id(+)
                             and t.dimension_id = fdvv.dimension_id(+)
                             and t.expense_report_type_id =
                                 p_exp_report_type_id) loop
    
      if c_report_dims.dimension_sequence = p_dimension_sequence then
        begin
          select fud.default_dimension_value_id
            into v_default_dimension_value_id
            from FND_UNIT_DIM_ASSIGN_VL fud
           where fud.dimension_id = c_report_dims.dimension_id
             and fud.unit_id = p_unit_id;
          if v_default_dimension_value_id is not null then
            return v_default_dimension_value_id;
          end if;
        exception
          when no_data_found then
            return c_report_dims.default_dim_value_id;
        end;
      end if;
    end loop;
    return null;
  end;
  -- 检验部门代码
  function get_unit_id(p_company_id in number,
                       p_unit_code  in varchar2,
                       p_user_id    in number) return number is
    v_unit_id number;
  begin
    if p_unit_code is not null then
      select u.unit_id
        into v_unit_id
        from exp_org_unit u
       where u.unit_code = p_unit_code
         and u.company_id = p_company_id
         and u.enabled_flag = 'Y';
      return v_unit_id;
    end if;
    return null;
  exception
    when no_data_found then
      insert_error_log(e_error_header || g_line_number ||
                       e_unit_code_error,
                       p_user_id => p_user_id);
      return null;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'get_unit_id');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  --检验发票类型是否存在
  function get_invoice_type_desc(p_invoice_type_desc in varchar2,
                                 p_user_id           in number)
    return varchar2 is
    v_invoice_type_desc varchar2(30);
  begin
    if p_invoice_type_desc is not null then
      select t.type_code
        into v_invoice_type_desc
        from EXP_YGZ_INVOICE_TYPES t
       where t.type_code = p_invoice_type_desc
         and t.enabled_flag = 'Y';
      return v_invoice_type_desc;
    end if;
    return null;
  exception
    when no_data_found then
      insert_error_log(e_error_header || g_line_number ||
                       e_invoice_type_error,
                       p_user_id => p_user_id);
      return null;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'get_invoice_type_desc');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  --检验预算专项
  function get_d3(p_d3            in varchar2,
                  p_user_id       in number,
                  p_expre_type_id in number) return number is
    v_d3 number;
  begin
    if p_d3 is not null then
      begin
        SELECT fdvv.dimension_value_id
          INTO v_d3
          FROM fnd_dimensions_vl fdv, fnd_dimension_values_vl fdvv
         WHERE fdv.dimension_id = fdvv.dimension_id
           AND fdvv.enabled_flag = 'Y'
           AND fdv.dimension_code = 'SPECIAL_BUDGET'
           AND fdvv.dimension_value_code = p_d3;
      exception
        when no_data_found then
        
          SELECT fdvv.dimension_value_id
            INTO v_d3
            FROM fnd_dimensions_vl fdv, fnd_dimension_values_vl fdvv
           WHERE fdv.dimension_id = fdvv.dimension_id
             AND fdvv.enabled_flag = 'Y'
             AND fdv.dimension_code in
                 (SELECT fdv.dimension_code
                    FROM exp_rep_ref_dimensions t, fnd_dimensions_vl fdv
                   where t.expense_report_type_id = p_expre_type_id
                     and t.layout_position = 'DOCUMENTS_LINE'
                     and fdv.dimension_id = t.dimension_id)
             AND fdvv.dimension_value_code = p_d3;
        
      end;
      return v_d3;
    end if;
    return null;
  exception
    when no_data_found then
      insert_error_log(e_error_header || g_line_number || e_d3_error,
                       p_user_id => p_user_id);
      return null;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'get_d3');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  -- 检验岗位代码
  function get_position_id(p_company_id    in number,
                           p_unit_id       in number,
                           p_position_code in varchar2,
                           p_user_id       in number) return number is
    v_position_id number;
  begin
    if p_position_code is not null then
      select p.position_id
        into v_position_id
        from exp_org_position p
       where p.position_code = p_position_code
         and p.unit_id = p_unit_id
         and p.company_id = p_company_id
         and p.enabled_flag = 'Y';
      return v_position_id;
    end if;
    return null;
  exception
    when no_data_found then
      insert_error_log(e_error_header || g_line_number ||
                       e_position_code_error,
                       p_user_id => p_user_id);
      return null;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'get_position_id');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  -- 检查责任中心代码
  function get_resp_center_id(p_company_id       in number,
                              p_resp_center_code in varchar2,
                              p_user_id          in number) return number is
    v_resp_center_id number;
  begin
    if p_resp_center_code is null then
      insert_error_log(e_error_header || g_line_number ||
                       e_resp_center_code_is_null,
                       p_user_id => p_user_id);
      return null;
    else
      select c.responsibility_center_id
        into v_resp_center_id
        from fnd_responsibility_centers c
       where c.responsibility_center_code = p_resp_center_code
         and c.company_id = p_company_id
         and c.start_date_active <= trunc(sysdate)
         and (c.end_date_active is null or
             c.end_date_active >= trunc(sysdate));
      return v_resp_center_id;
    end if;
  exception
    when no_data_found then
      insert_error_log(e_error_header || g_line_number ||
                       e_resp_center_code_error,
                       p_user_id => p_user_id);
      return null;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'get_resp_center_id');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  -- 检验员工代码
  function get_employee_id(p_company_id    in number,
                           p_position_id   in number,
                           p_employee_code in varchar2,
                           p_user_id       in number) return number is
    v_employee_id number;
  begin
    if p_employee_code is not null then
      select e.employee_id
        into v_employee_id
        from exp_employees e
       where e.employee_code = p_employee_code
         and e.enabled_flag = 'Y'
         and exists (select 1
                from exp_employee_assigns a
               where a.employee_id = e.employee_id
                 and a.company_id = p_company_id
                 and a.position_id = p_position_id
                 and a.enabled_flag = 'Y');
      return v_employee_id;
    elsif p_employee_code is null then
      select ee.employee_id
        into v_employee_id
        from sys_user su, exp_employees ee
       where su.employee_id = ee.employee_id
         and su.user_id = p_user_id;
      return v_employee_id;
    end if;
  exception
    when no_data_found then
      insert_error_log(e_error_header || g_line_number ||
                       e_employee_code_error,
                       p_user_id => p_user_id);
      return null;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'get_employee_id');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  -- 检验维度信息
  function get_dimension_id(p_exp_report_header_id in number,
                            p_dimension_code       in varchar2,
                            p_x                    in number,
                            p_user_id              in number,
                            p_status               out number) return number is
    v_dimension_id number;
  begin
    p_status := 0;
    select *
      into v_dimension_id
      from (select null
              from dual
             where not exists
             (select 1
                      from exp_rep_ref_dimensions d
                     where d.expense_report_type_id =
                           (select exp_report_type_id
                              from exp_report_headers h
                             where h.exp_report_header_id =
                                   p_exp_report_header_id)
                       and d.dimension_id =
                           (select fd.dimension_id
                              from fnd_dimensions fd
                             where fd.dimension_sequence = p_x))
            union all
            select v.dimension_value_id
              from fnd_dimension_values v
             where v.dimension_value_code = p_dimension_code
               and v.dimension_id =
                   (select di.dimension_id
                      from fnd_dimensions di
                     where di.dimension_sequence = p_x)
               and exists
             (select 1
                      from exp_rep_ref_dimensions d
                     where d.expense_report_type_id =
                           (select exp_report_type_id
                              from exp_report_headers h
                             where h.exp_report_header_id =
                                   p_exp_report_header_id)
                       and d.dimension_id =
                           (select fd.dimension_id
                              from fnd_dimensions fd
                             where fd.dimension_sequence = p_x)));
    if v_dimension_id is null then
      p_status := 1;
    else
      p_status := 1;
    end if;
    return v_dimension_id;
  exception
    when no_data_found then
      p_status := 0;
      insert_error_log('行号为: ' || g_line_number || '维度' || p_x || '代码有误',
                       p_user_id => p_user_id);
      return null;
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_created_by              => p_user_id,
                                                     p_procedure_function_name => 'get_dimension_id');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  /**************************************************************
  *  check_interface : 校验接口表
  *    parameters :
  *      batch_id : 批次
  *      p_user_id : 用户
  *      p_return_status : 执行结果
  *        'SUCCESS' : 成功
  *        'FAILED' : 失败
  **************************************************************/
  procedure check_interface(p_batch_id             in number,
                            p_exp_report_header_id in number,
                            p_user_id              in number,
                            p_return_status        out varchar2) is
    type code_array is table of varchar2(30);
    type number_array is table of number;
  
    cursor c_exp_report_interface is
      select *
        from exp_rep_line_interface a
       where a.batch_id = p_batch_id
         and a.import_flag = 'Y';
    v_line                 exp_rep_line_interface%rowtype;
    v_header_line          exp_report_headers%rowtype;
    v_exp_report_header_id number;
    v_place_from_id        number; --地点从id
    v_place_to_id          number; --地点到id
    v_place_type_id        number;
    v_check_date_flag      number;
    v_company_id           number;
    v_period_name_flag     number;
    v_expense_type_id      number;
    v_expense_item_id      number;
    v_bgt_item_id          number;
    v_price_flag           number;
    v_quantity_flag        number;
    v_unit_id              number;
    v_position_id          number;
    v_resp_center_id       number;
    v_employee_id          number;
    v_d3                   number;
    v_invoice_type_desc    varchar2(30);
    v_special_invoice      varchar2(30);
    v_exp_report_type_code varchar2(30);
    v_dimension_code_array code_array;
    v_dimension_id_array   number_array;
    v_status               number;
    v_exp_report_type_id   number;
    v_company_flag         varchar2(2); --跨机构标志
    v_head_company_id      number;
    v_count                number;
    v_tax_rate             number; --税额
    v_date_flag            varchar2(2);
    v_where_flag           varchar2(2);
    v_emp_level_flag       varchar2(2);
    v_transport_flag       varchar2(2);
    v_document_page_type   varchar2(30);
    v_employee_levels_id   number;
  begin
    g_batch_id      := p_batch_id;
    p_return_status := 'SUCCESS';
    -- 清除垃圾错误信息
    delete_error_logs;
  
    --校验报销单类型
    /*    select exp_report_type_code
          into v_exp_report_type_code
          from exp_rep_line_interface
         where rownum = 1
    */
    open c_exp_report_interface;
    loop
      <<next>>
      fetch c_exp_report_interface
        into v_line;
      exit when c_exp_report_interface%notfound;
    
      g_batch_id      := v_line.batch_id;
      g_batch_line_id := v_line.batch_line_id;
      g_line_number   := v_line.line_number;
    
      dbms_output.put_line(' -------- ');
      dbms_output.put_line('[New Line]');
      dbms_output.put_line(' -------- ');
    
      -- 校验报销单编号
      /*v_exp_report_header_id := get_exp_report_header_id(p_exp_report_number => v_line.exp_report_number,
                                                         p_user_id           => p_user_id);
      
      if v_exp_report_header_id is null then
        p_return_status := 'FAILED';
        goto next;
      end if;*/
    
      -- 校验地点从代码
      if v_line.place_from is not null then
        v_place_from_id := get_place_id(p_place_code => v_line.place_from,
                                        p_user_id    => p_user_id);
        if v_place_from_id is null then
          p_return_status := 'FAILED';
          goto next;
        end if;
      end if;
    
      -- 校验地点到代码
      if v_line.place_to is not null then
        v_place_to_id := get_place_id(p_place_code => v_line.place_to,
                                      p_user_id    => p_user_id);
        if v_place_to_id is null then
          p_return_status := 'FAILED';
          goto next;
        end if;
      end if;
    
      -- 校验地点类型代码
      /*if v_line.place_type_code is not null then
        v_place_type_id := get_place_type_id(p_place_type_code => v_line.place_type_code,
                                             p_user_id         => p_user_id);
        if v_place_type_id is null then
          p_return_status := 'FAILED';
          goto next;
        end if;
      end if;*/
    
      -- 校验日期
      if v_line.date_from is not null or v_line.date_to is not null then
        v_check_date_flag := check_date(p_date_from => v_line.date_from,
                                        p_date_to   => v_line.date_to,
                                        p_user_id   => p_user_id);
        if v_check_date_flag != 1 then
          p_return_status := 'FAILED';
          goto next;
        end if;
      end if;
    
      if p_exp_report_header_id is not null then
        select *
          into v_header_line
          from exp_report_headers h
         where h.exp_report_header_id = p_exp_report_header_id;
      end if;
    
      -- 校验公司代码
      v_company_id := get_company_id(p_company_code => v_line.company_code,
                                     p_user_id      => p_user_id);
      if v_company_id is null then
        p_return_status := 'FAILED';
        goto next;
      else
        if p_exp_report_header_id is not null then
          --报销单头id不为空，对公司进行跨机构校验
          --头机构
          select company_id
            into v_head_company_id
            from exp_report_headers h
           where h.exp_report_header_id = p_exp_report_header_id;
        
          select nvl(e.company_flag, 'N')
            into v_company_flag
            from exp_expense_report_types e
           where e.expense_report_type_id =
                 v_header_line.exp_report_type_id
             and e.company_id = v_header_line.company_id;
        
          if v_company_flag = 'Y' then
            --校验行机构是否是头机构及其下级机构
            select count(1)
              into v_count
              from fnd_companies fc
             where fc.company_id = v_company_id
               and (fc.company_id = v_header_line.company_id or
                   fc.parent_company_id = v_header_line.company_id);
          
            if v_count = 0 then
              insert_error_log(e_error_header || g_line_number ||
                               '报销单行机构不是头机构及其下级机构',
                               p_user_id);
              p_return_status := 'FAILED';
              goto next;
            end if;
          else
            if v_company_flag = 'N' then
              if v_company_id != v_header_line.company_id then
                insert_error_log(e_error_header || g_line_number ||
                                 '报销单不允许跨机构',
                                 p_user_id);
                p_return_status := 'FAILED';
                goto next;
              end if;
            end if;
          end if;
        end if;
      end if;
    
      --校验报销单类型码
      /*v_exp_report_type_id:=get_exp_report_type_id(p_exp_report_type_code=>v_line.exp_report_type_code,
                                                  p_company_id=>v_company_id,
                                                  p_user_id =>p_user_id);
      if v_exp_report_type_id is null then
        p_return_status := 'FAILED';
        goto next;
      end if;*/
    
      -- 校验期间
      /*v_period_name_flag := check_period_name(p_company_id  => v_company_id,
                                              p_period_name => v_line.period_name,
                                              p_user_id     => p_user_id);
      if v_period_name_flag is null then
        p_return_status := 'FAILED';
        goto next;
      end if;*/
      -- 校验报销类型代码
      v_expense_type_id := get_expense_type_id(p_exp_report_header_id => p_exp_report_header_id,
                                               p_company_id           => v_company_id,
                                               p_expense_type_code    => v_line.expense_type_code,
                                               p_user_id              => p_user_id);
      if v_expense_type_id is null then
        p_return_status := 'FAILED';
        goto next;
      end if;
    
      -- 校验费用项目代码
      v_expense_item_id := get_expense_item_id(p_company_id        => v_company_id,
                                               p_expense_type_id   => v_expense_type_id,
                                               p_expense_item_code => v_line.expense_item_code,
                                               p_user_id           => p_user_id);
      if v_expense_item_id is null then
        p_return_status := 'FAILED';
        goto next;
      else
        --差旅页面校验日期，地点，交通工具，员工级别
        select es.document_page_type
          into v_document_page_type
          from exp_report_headers h, exp_expense_report_types es
         where es.expense_report_type_id = h.exp_report_type_id;
        if upper(v_document_page_type) = 'TRAVEL' then
          select e.item_date_flag,
                 e.item_where_flag,
                 e.item_emp_level_flag,
                 e.item_transport_flag
            into v_date_flag,
                 v_where_flag,
                 v_emp_level_flag,
                 v_transport_flag
            from exp_company_expense_items e
           where e.company_id = v_company_id
             and e.expense_item_id = v_expense_item_id;
          if v_date_flag = 'Y' then
            if v_line.date_from is null or v_line.date_to is null then
              insert_error_log(e_error_header || g_line_number ||
                               '该费用项目下，日期从/到必输',
                               p_user_id);
              p_return_status := 'FAILED';
              goto next;
            end if;
          end if;
          if v_where_flag = 'Y' then
            if v_line.place_from is null or v_line.place_to is null then
              insert_error_log(e_error_header || g_line_number ||
                               '该费用项目下，地点从/到必输',
                               p_user_id);
              p_return_status := 'FAILED';
              goto next;
            end if;
          end if;
          if v_emp_level_flag = 'Y' then
            if v_line.employee_levels_code is null then
              insert_error_log(e_error_header || g_line_number ||
                               '该费用项目下，员工级别代码必输',
                               p_user_id);
              p_return_status := 'FAILED';
              goto next;
            else
              v_employee_levels_id := get_employee_levels_id(v_line.employee_levels_code,
                                                             p_user_id);
              if v_employee_levels_id is null then
                p_return_status := 'FAILED';
                goto next;
              end if;
            end if;
          end if;
          if v_transport_flag = 'Y' then
            if v_line.transport_code is null then
              insert_error_log(e_error_header || g_line_number ||
                               '该费用项目下，交通工具代码必输',
                               p_user_id);
              p_return_status := 'FAILED';
              goto next;
            else
              v_count := check_transport_code(v_line.transport_code,
                                              p_user_id);
              if v_count = 0 then
                p_return_status := 'FAILED';
                goto next;
              end if;
            end if;
          end if;
        end if;
      end if;
    
      -- 检验预算项代码
      /*if v_line.budget_item_code is not null then
        v_bgt_item_id := get_bgt_item_id(p_company_id       => v_company_id,
                                         p_budget_item_code => v_line.budget_item_code,
                                         p_user_id          => p_user_id);
        if v_bgt_item_id is null then
          p_return_status := 'FAILED';
          goto next;
        end if;
      end if;*/
    
      -- 检验单价
      v_price_flag := check_price(p_price   => v_line.report_amount,
                                  p_user_id => p_user_id);
      if v_price_flag != 1 then
        p_return_status := 'FAILED';
        goto next;
      end if;
    
      -- 校验数量
      /*v_quantity_flag := check_primary_quantity(p_primary_quantity => v_line.primary_quantity,
                                                p_user_id          => p_user_id);
      if v_quantity_flag != 1 then
        p_return_status := 'FAILED';
        goto next;
      end if;*/
    
      -- 校验部门代码
      if v_line.unit_code is not null then
        v_unit_id := get_unit_id(p_company_id => v_company_id,
                                 p_unit_code  => v_line.unit_code,
                                 p_user_id    => p_user_id);
        if v_unit_id is null then
          p_return_status := 'FAILED';
          goto next;
        end if;
      end if;
    
      -- 校验发票类型
      if v_line.invoice_type_desc is not null then
        v_invoice_type_desc := get_invoice_type_desc(p_invoice_type_desc => v_line.invoice_type_desc,
                                                     p_user_id           => p_user_id);
      
        if v_invoice_type_desc is null then
          p_return_status := 'FAILED';
          goto next;
        end if;
      end if;
    
      --校验报销金额
      if v_line.report_amount is null then
        insert_error_log(e_error_header || g_line_number || ' 报销金额为空',
                         p_user_id => p_user_id);
        p_return_status := 'FAILED';
        goto next;
      end if;
    
      --检验税率是否维护在费控系统中
      if v_line.tax_rate is not null then
        v_tax_rate := get_tax_rate(p_tax_rate_code => v_line.tax_rate,
                                   p_user_id       => p_user_id);
        if v_tax_rate is null then
          p_return_status := 'FAILED';
          goto next;
          --税率不为空校验税额是否为空
        else
          if v_line.tax_amount is null then
            insert_error_log(e_error_header || g_line_number || '报销税额为空',
                             p_user_id => p_user_id);
            p_return_status := 'FAILED';
            goto next;
          else
            --税率不为空校验税额是否等于（报销金额税率+-0.06）
            if v_line.tax_amount > v_line.report_amount * v_tax_rate + 0.06 or
               v_line.tax_amount < v_line.report_amount * v_tax_rate - 0.06 then
              insert_error_log(e_error_header || g_line_number ||
                               '报销税额不在[报销金额*税率-0.06,报销金额*税率+0.06]',
                               p_user_id => p_user_id);
              p_return_status := 'FAILED';
              goto next;
            else
              --校验报销不含税金额=报销金额-报销税额
              if v_line.sale_amount !=
                 v_line.report_amount - v_line.tax_amount then
              
                insert_error_log(e_error_header || g_line_number ||
                                 '报销不含税金额不等于报销金额减去报销税额',
                                 p_user_id => p_user_id);
                p_return_status := 'FAILED';
                goto next;
              end if;
            end if;
            --校验发票税额是否等于发票总金额*税率
            if v_line.invoice_tax_amount_bak !=
               v_line.invoice_sum_amount * v_tax_rate then
              insert_error_log(e_error_header || g_line_number ||
                               '发票税额不等于发票总金额减*税率',
                               p_user_id => p_user_id);
              p_return_status := 'FAILED';
              goto next;
            end if;
          end if;
        end if;
      end if;
    
      --发票的发票代码 号码 校验码 税率 税额 不含税金额 不含税发票金额
      --1.增值税专用发票或者视同专票
      /*  if v_line.v_invoice_type_desc = 'INV001' or v_special_invoice = 'Y' then
      
        if v_line.v_invoice_type_desc != 'INV005' and
           v_line.invoice_code is null or length(v_line.invoice_code) != 10 then
          insert_error_log(e_error_header || g_line_number ||
                           ' 专票发票代码为空或长度不为10位',
                           p_user_id => p_user_id);
          p_return_status := 'FAILED';
          goto next;
        else
          if v_line.invoice_check_code is null or
             length(v_line.invoice_check_code) != 6 then
            insert_error_log(e_error_header || g_line_number ||
                             ' 专票发票校验码为空或长度不为6位',
                             p_user_id => p_user_id);
            p_return_status := 'FAILED';
            goto next;
          end if;
        else
          if v_line.invoice_sum_amount is null then
            insert_error_log(e_error_header || g_line_number ||
                             ' 专票发票发票总金额为空',
                             p_user_id => p_user_id);
            p_return_status := 'FAILED';
            goto next;
          end if;
        else
          if v_line.invoice_date is null then
            insert_error_log(e_error_header || g_line_number ||
                             ' 专票发票发票日期为空',
                             p_user_id => p_user_id);
            p_return_status := 'FAILED';
            goto next;
          end if;
        else
          if v_line.taxe_rate is null then
            insert_error_log(e_error_header || g_line_number || ' 专票税率为空',
                             p_user_id => p_user_id);
            p_return_status := 'FAILED';
            goto next;
          end if;
        else
          if v_line.tax_rate is not null then
            v_tax_rate := get_tax_rate(v_line.taxe_rate, p_user_id);
            if v_tax_rate is null then
              p_return_status := 'FAILED';
              goto next;
            end if;
          end if;
        else
          if v_line.invoice_number is null or
             length(v_line.invoice_number) != 8 then
            insert_error_log(e_error_header || g_line_number ||
                             ' 专票发票号码为空或长度不为8位',
                             p_user_id => p_user_id);
            p_return_status := 'FAILED';
            goto next;
          end if;
        else
          if v_line.invoice_check_code is null or
             length(v_line.invoice_check_code) != 6 then
            insert_error_log(e_error_header || g_line_number ||
                             ' 专票发票校验码为空或长度不为6位',
                             p_user_id => p_user_id);
            p_return_status := 'FAILED';
            goto next;
          end if;
        else
          if v_line.invoice_sum_amount is null then
            insert_error_log(e_error_header || g_line_number ||
                             ' 专票发票发票总金额为空',
                             p_user_id => p_user_id);
            p_return_status := 'FAILED';
            goto next;
          end if;
        else
          if v_line.invoice_date is null then
            insert_error_log(e_error_header || g_line_number ||
                             ' 专票发票发票日期为空',
                             p_user_id => p_user_id);
            p_return_status := 'FAILED';
            goto next;
          
          end if;
        else
          if v_line.taxe_rate is null then
            insert_error_log(e_error_header || g_line_number || ' 专票税率为空',
                             p_user_id => p_user_id);
            p_return_status := 'FAILED';
            goto next;
          end if;
        else
          if v_line.tax_rate is not null then
            v_tax_rate := get_tax_rate(v_line.taxe_rate, p_user_id);
            if v_tax_rate is null then
              p_return_status := 'FAILED';
              goto next;
            end if;
          end if;
        end if;
      end if;
      
      --校验说明字段
      if v_line.description is null then
        insert_error_log(e_error_header || g_line_number || ' 说明字段不能为空',
                         p_user_id => p_user_id);
        p_return_status := 'FAILED';
        goto next;
      end if;*/
    
      --检验预算专项
      /*if v_line.d3 is not null then
        v_d3 := get_d3(p_d3            => v_line.d3,
                       p_user_id       => p_user_id,
                       p_expre_type_id => v_header_line.exp_report_type_id);
      
        if v_d3 is null then
          p_return_status := 'FAILED';
          goto next;
        end if;
      else
        insert_error_log(e_error_header || g_line_number ||
                         e_d3_null_error,
                         p_user_id => p_user_id);
        p_return_status := 'FAILED';
      end if;*/
    
      --校验非专票状态下，进项分类，抵扣规则，税额不能填写值，否则报错。
    
      select t.special_invoice
        into v_special_invoice
        from EXP_YGZ_INVOICE_TYPES t
       where t.type_code = v_line.invoice_type_desc
         and t.enabled_flag = 'Y';
    
      if v_special_invoice = 'N' then
        if v_line.tax_amount <> '' or
           v_line.input_tax_structure_detail <> '' or v_line.d3 <> '' then
          insert_error_log(e_error_header || g_line_number || e_type_error,
                           p_user_id => p_user_id);
          p_return_status := 'FAILED';
        end if;
      
      end if;
    
      -- 校验岗位代码
      /*if v_line.position_code is not null then
        v_position_id := get_position_id(p_company_id    => v_company_id,
                                         p_unit_id       => v_unit_id,
                                         p_position_code => v_line.position_code,
                                         p_user_id       => p_user_id);
        if v_position_id is null then
          p_return_status := 'FAILED';
          goto next;
        end if;
      end if;*/
    
      -- 校验责任中心代码
      /*v_resp_center_id := get_resp_center_id(p_company_id       => v_company_id,
                                             p_resp_center_code => v_line.resp_center_code,
                                             p_user_id          => p_user_id);
      if v_resp_center_id is null then
        p_return_status := 'FAILED';
        goto next;
      end if;*/
    
      -- 校验员工代码
    
      /*if v_line.employee_code is not null then
        v_employee_id := get_employee_id(p_company_id    => v_company_id,
                                         p_position_id   => v_position_id,
                                         p_employee_code => v_line.employee_code,
                                         p_user_id       => p_user_id);
        if v_employee_id is null then
          p_return_status := 'FAILED';
          goto next;
        end if;
      end if;*/
    
      -- 校验维度
      /*v_dimension_code_array := code_array(v_line.dimension1_code,
                                           v_line.dimension2_code,
                                           v_line.dimension3_code,
                                           v_line.dimension4_code,
                                           v_line.dimension5_code,
                                           v_line.dimension6_code,
                                           v_line.dimension7_code,
                                           v_line.dimension8_code,
                                           v_line.dimension9_code,
                                           v_line.dimension10_code);
      v_dimension_id_array   := number_array(null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null);
      for i in 1 .. v_dimension_code_array.count loop
        v_dimension_id_array(i) := get_dimension_id(p_exp_report_header_id => v_exp_report_header_id,
                                                    p_dimension_code       => v_dimension_code_array(i),
                                                    p_x                    => i,
                                                    p_status               => v_status,
                                                    p_user_id              => p_user_id);
        if v_status = 0 then
          p_return_status := 'FAILED';
          goto next;
        end if;
        dbms_output.put_line('dimension' || i || ' : ' ||
                             v_dimension_id_array(i));
      end loop;*/
    end loop;
    if c_exp_report_interface%isopen then
      close c_exp_report_interface;
    end if;
  exception
    when others then
      if c_exp_report_interface%isopen then
        close c_exp_report_interface;
      end if;
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_procedure_function_name => 'check_interface');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  -- 插入报销单行数据
  /*procedure insert_exp_report_lines(p_exp_report_header_id     number,
                                    p_line_number              number,
                                    p_city                     varchar2,
                                    p_description              varchar2,
                                    p_date_from                date,
                                    p_date_to                  date,
                                    p_period_name              varchar2,
                                    p_currency_code            varchar2,
                                    p_exchange_rate_type       varchar2,
                                    p_exchange_rate_quotation  varchar2,
                                    p_exchange_rate            number,
                                    p_expense_type_id          number,
                                    p_expense_item_id          number,
                                    p_budget_item_id           number,
                                    p_price                    number,
                                    p_primary_quantity         number,
                                    p_primary_uom              varchar2,
                                    p_secondary_quantity       number,
                                    p_secondary_uom            varchar2,
                                    p_report_amount            number,
                                    p_report_functional_amount number,
                                    p_distribution_set_id      number,
                                    p_company_id               number,
                                    p_unit_id                  number,
                                    p_position_id              number,
                                    p_responsibility_center_id number,
                                    p_employee_id              number,
                                    p_payee_category           varchar2,
                                    p_payee_id                 number,
                                    p_partner_id               number,
                                    p_payment_flag             varchar2,
                                    p_report_status            varchar2,
                                    p_write_off_status         varchar2,
                                    p_write_off_comleted_date  date,
                                    p_attachment_num           number,
                                    p_dimension1_id            number,
                                    p_dimension2_id            number,
                                    p_dimension3_id            number,
                                    p_dimension4_id            number,
                                    p_dimension5_id            number,
                                    p_dimension6_id            number,
                                    p_dimension7_id            number,
                                    p_dimension8_id            number,
                                    p_dimension9_id            number,
                                    p_dimension10_id           number,
                                    p_account_name             varchar2,
                                    p_account_number           varchar2,
                                    p_payment_type_id          number,
                                    p_payment_type             varchar2,
                                    p_created_by               number,
                                    p_exp_report_line_id       out number,
                                    p_place_type_id            number,
                                    p_place_id                 number,
                                    p_batch_line_id            number) is
  begin
    select exp_report_lines_s.nextval
      into p_exp_report_line_id
      from dual;
  
    insert into exp_report_lines
      (exp_report_header_id,
       exp_report_line_id,
       line_number,
       city,
       place_type_id,
       place_id,
       description,
       date_from,
       date_to,
       period_name,
       currency_code,
       exchange_rate_type,
       exchange_rate_quotation,
       exchange_rate,
       expense_type_id,
       expense_item_id,
       budget_item_id,
       price,
       primary_quantity,
       primary_uom,
       secondary_quantity,
       secondary_uom,
       report_amount,
       report_functional_amount,
       distribution_set_id,
       company_id,
       unit_id,
       position_id,
       responsibility_center_id,
       employee_id,
       payee_category,
       payee_id,
       partner_id,
       payment_flag,
       report_status,
       write_off_status,
       write_off_comleted_date,
       attachment_num,
       dimension1_id,
       dimension2_id,
       dimension3_id,
       dimension4_id,
       dimension5_id,
       dimension6_id,
       dimension7_id,
       dimension8_id,
       dimension9_id,
       dimension10_id,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       account_name,
       account_number,
       payment_type_id,
       payment_type)
    values
      (p_exp_report_header_id,
       p_exp_report_line_id,
       p_line_number,
       p_city,
       p_place_type_id,
       p_place_id,
       p_description,
       p_date_from,
       p_date_to,
       p_period_name,
       p_currency_code,
       p_exchange_rate_type,
       p_exchange_rate_quotation,
       p_exchange_rate,
       p_expense_type_id,
       p_expense_item_id,
       p_budget_item_id,
       p_price,
       p_primary_quantity,
       p_primary_uom,
       p_secondary_quantity,
       p_secondary_uom,
       p_report_amount,
       p_report_functional_amount,
       p_distribution_set_id,
       p_company_id,
       p_unit_id,
       p_position_id,
       p_responsibility_center_id,
       p_employee_id,
       p_payee_category,
       p_payee_id,
       p_partner_id,
       p_payment_flag,
       p_report_status,
       p_write_off_status,
       p_write_off_comleted_date,
       p_attachment_num,
       p_dimension1_id,
       p_dimension2_id,
       p_dimension3_id,
       p_dimension4_id,
       p_dimension5_id,
       p_dimension6_id,
       p_dimension7_id,
       p_dimension8_id,
       p_dimension9_id,
       p_dimension10_id,
       p_created_by,
       sysdate,
       p_created_by,
       sysdate,
       p_account_name,
       p_account_number,
       p_payment_type_id,
       p_payment_type);
  
  exception
    when dup_val_on_index then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP7010_LINE_NUMBER_EXISTS',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'EXP_INTERFACE_PKG',
                                                      p_procedure_function_name => 'insert_exp_report_lines',
                                                      p_token_1                 => '#SEQUENCE',
                                                      p_token_value_1           => p_batch_line_id,
                                                      p_token_2                 => '#LINE_NUMBER',
                                                      p_token_value_2           => p_line_number);
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_procedure_function_name => 'insert_exp_report_lines');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;*/
  /**************************************************************************
  *  load_expense_roports : 将接口表中的数据导入到exp_report_lines表中
  *    parameters ：
  *      p_batch_id : 导入批次
  *      p_user_id : 用户
  *      p_load_status : 执行结果
  *        'SUCCESS' : 导入成功
  *        'DATA_ERROR' : 数据错误
  *        'FAILED' : 数据错误之外的导入错误
  **************************************************************************/
  procedure load_expense_reports(p_batch_id             in number,
                                 p_exp_report_header_id in number,
                                 p_user_id              in number,
                                 p_load_status          out varchar2) is
    type code_array is table of varchar2(30);
    type number_array is table of number;
    cursor c_interface_datas is
      select *
        from exp_rep_line_interface a
       where a.batch_id = p_batch_id
         and a.import_flag = 'Y'
         for update nowait;
    v_check_flag               varchar2(30);
    v_header_line              exp_report_headers%rowtype;
    v_exp_report_header_id     number;
    v_company_id               number;
    v_expense_type_id          number;
    v_expense_item_id          number;
    v_budget_item_id           number;
    v_report_amount            number;
    v_report_functional_amount number;
    v_unit_id                  number;
    v_position_id              number;
    v_employee_id              number;
    v_responsibility_center_id number;
    v_exp_report_line_id       number;
    v_place_type_id            number;
    v_place_from_id            number;
    v_place_to_id              number;
    v_dimension_code_array     code_array;
    v_dimension_id_array       number_array;
    v_status                   number;
    v_period_name              varchar2(30);
    v_invoice_status           varchar2(30);
    v_sale_amount              number;
    v_tax_rate                 number;
    v_tax_amount               number;
    v_special_invoice          varchar2(30);
    v_d3                       number;
    v_employee_levels_id       number;
  
  begin
  
    check_interface(p_batch_id             => p_batch_id,
                    p_exp_report_header_id => p_exp_report_header_id,
                    p_user_id              => p_user_id,
                    p_return_status        => v_check_flag);
    if v_check_flag != 'SUCCESS' then
      p_load_status := 'DATA_ERROR';
      return;
    end if;
  
    for v_line in c_interface_datas loop
      /*v_exp_report_header_id := get_exp_report_header_id(p_exp_report_number => v_line.exp_report_number,
      p_user_id           => p_user_id);*/
      if p_exp_report_header_id is not null then
        select *
          into v_header_line
          from exp_report_headers h
         where h.exp_report_header_id = p_exp_report_header_id;
      end if;
    
      v_company_id := get_company_id(p_company_code => v_line.company_code,
                                     p_user_id      => p_user_id);
    
      v_expense_type_id := get_expense_type_id(p_exp_report_header_id => p_exp_report_header_id,
                                               p_company_id           => v_company_id,
                                               p_expense_type_code    => v_line.expense_type_code,
                                               p_user_id              => p_user_id);
    
      v_expense_item_id := get_expense_item_id(p_company_id        => v_company_id,
                                               p_expense_type_id   => v_expense_type_id,
                                               p_expense_item_code => v_line.expense_item_code,
                                               p_user_id           => p_user_id);
    
      /*v_budget_item_id := get_bgt_item_id(p_company_id       => v_company_id,
      p_budget_item_code => v_line.budget_item_code,
      p_user_id          => p_user_id);*/
    
      /*v_report_amount := v_line.price * v_line.primary_quantity;*/
    
      /*if v_header_line.exchange_rate_quotation = 'DIRECT QUOTATION' then
        v_report_functional_amount := v_report_amount *
                                      v_header_line.exchange_rate;
      else
        v_report_functional_amount := v_report_amount /
                                      v_header_line.exchange_rate;
      end if;*/
    
      v_unit_id := get_unit_id(p_company_id => v_company_id,
                               p_unit_code  => v_line.unit_code,
                               p_user_id    => p_user_id);
    
      /*v_position_id := get_position_id(p_company_id    => v_company_id,
      p_unit_id       => v_unit_id,
      p_position_code => v_line.position_code,
      p_user_id       => p_user_id);*/
    
      /*v_responsibility_center_id := get_resp_center_id(p_company_id       => v_company_id,
      p_resp_center_code => v_line.resp_center_code,
      p_user_id          => p_user_id);*/
    
      select eou.responsibility_center_id
        into v_responsibility_center_id
        from EXP_ORG_UNIT eou
       where eou.unit_id = v_unit_id;
    
      ---期间
      select h.period_name
        into v_period_name
        from exp_report_headers h
       where h.exp_report_header_id = p_exp_report_header_id;
    
      --岗位
      select h.position_id
        into v_position_id
        from exp_report_headers h
       where h.exp_report_header_id = p_exp_report_header_id;
    
      --发票验真状态  
      select t.special_invoice
        into v_special_invoice
        from EXP_YGZ_INVOICE_TYPES t
       where t.type_code = v_line.invoice_type_desc
         and t.enabled_flag = 'Y';
    
      if v_special_invoice = 'Y' then
        v_invoice_status := 20;
      else
        v_invoice_status := 10;
      end if;
    
      --税额      
      /* if v_line.tax_amount is null then
        v_tax_amount := 0;
      else
        v_tax_amount := v_line.tax_amount;
      end if;*/
    
      --不含税金额       
      /*  v_sale_amount := v_line.report_amount - v_tax_amount;*/
    
      --税率
      v_tax_rate := get_tax_rate(v_line.tax_rate, p_user_id);
      /* if v_special_invoice = 'Y' then
        if v_sale_amount is not null and v_sale_amount <> 0 then
          v_tax_rate := round(v_tax_amount / v_sale_amount, 2);
        else
          v_tax_rate := 0;
        end if;
      end if;*/
    
      /*   v_d3 := get_d3(p_d3            => v_line.d3,
      p_user_id       => p_user_id,
      p_expre_type_id => v_header_line.exp_report_type_id);*/
    
      /*v_employee_id := get_employee_id(p_company_id    => v_company_id,
      p_position_id   => v_position_id,
      p_employee_code => v_line.employee_code,
      p_user_id       => p_user_id);*/
    
      v_place_type_id := get_place_type_id(p_place_type_code => v_line.place_to,
                                           p_user_id         => p_user_id);
    
      v_place_from_id      := get_place_id(p_place_code => v_line.place_from,
                                           p_user_id    => p_user_id);
      v_place_to_id        := get_place_id(p_place_code => v_line.place_to,
                                           p_user_id    => p_user_id);
      v_employee_levels_id := get_employee_levels_id(p_employee_levels_code => v_line.employee_levels_code,
                                                     p_user_id              => p_user_id);
    
      /*v_dimension_code_array := code_array(v_line.dimension1_code,
                                           v_line.dimension2_code,
                                           v_line.dimension3_code,
                                           v_line.dimension4_code,
                                           v_line.dimension5_code,
                                           v_line.dimension6_code,
                                           v_line.dimension7_code,
                                           v_line.dimension8_code,
                                           v_line.dimension9_code,
                                           v_line.dimension10_code);
      v_dimension_id_array   := number_array(null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null,
                                             null);*\
      
      for i in 1 .. v_dimension_code_array.count loop
        v_dimension_id_array(i) := get_dimension_id(p_exp_report_header_id => p_exp_report_header_id,
                                                    p_dimension_code       => v_dimension_code_array(i),
                                                    p_x                    => i,
                                                    p_status               => v_status,
                                                    p_user_id              => p_user_id);
      
      end loop;*/
      /*调用已有的插入过程*/
      exp_report_pkg.insert_exp_report_lines(p_exp_report_header_id     => p_exp_report_header_id,
                                             p_line_number              => v_line.line_number,
                                             p_city                     => null,
                                             p_description              => v_line.description,
                                             p_date_from                => v_line.date_from,
                                             p_date_to                  => v_line.date_to,
                                             p_period_name              => v_period_name,
                                             p_currency_code            => 'CNY', ----币种
                                             p_exchange_rate_type       => null,
                                             p_exchange_rate_quotation  => null,
                                             p_exchange_rate            => 1, ----汇率
                                             p_expense_type_id          => v_expense_type_id,
                                             p_expense_item_id          => v_expense_item_id,
                                             p_budget_item_id           => null,
                                             p_price                    => null,
                                             p_primary_quantity         => 1, --数量
                                             p_primary_uom              => null,
                                             p_secondary_quantity       => null,
                                             p_secondary_uom            => null,
                                             p_report_amount            => v_line.report_amount,
                                             p_report_functional_amount => v_line.report_amount, ----本币金额
                                             p_distribution_set_id      => null,
                                             p_company_id               => v_company_id,
                                             --p_operation_unit_id        number,
                                             p_unit_id                  => v_unit_id,
                                             p_position_id              => v_position_id,
                                             p_responsibility_center_id => v_responsibility_center_id, -----责任中心id
                                             p_employee_id              => null,
                                             p_payee_category           => null,
                                             p_payee_id                 => null,
                                             p_partner_id               => null,
                                             p_payment_flag             => null,
                                             p_report_status            => null,
                                             --p_audit_flag               varchar2,
                                             --p_audit_date               date,
                                             p_write_off_status            => null,
                                             p_write_off_comleted_date     => null,
                                             p_attachment_num              => null,
                                             p_dimension1_id               => null,
                                             p_dimension2_id               => null,
                                             p_dimension3_id               => null,
                                             p_dimension4_id               => get_dimension_value_id(v_header_line.exp_report_type_id, --报销单类型
                                                                                                     v_header_line.company_id, --投机构
                                                                                                     v_unit_id, --行部门
                                                                                                     4),
                                             p_dimension5_id               => null,
                                             p_dimension6_id               => get_dimension_value_id(v_header_line.exp_report_type_id, --报销单类型
                                                                                                     v_header_line.company_id, --投机构
                                                                                                     v_unit_id, --行部门
                                                                                                     6),
                                             p_dimension7_id               => null,
                                             p_dimension8_id               => null,
                                             p_dimension9_id               => get_dimension_value_id(v_header_line.exp_report_type_id, --报销单类型
                                                                                                     v_header_line.company_id, --投机构
                                                                                                     v_unit_id, --行部门
                                                                                                     9),
                                             p_dimension10_id              => null,
                                             p_account_name                => null,
                                             p_account_number              => null,
                                             p_payment_type_id             => null,
                                             p_payment_type                => null,
                                             p_created_by                  => p_user_id,
                                             p_exp_report_line_id          => v_exp_report_line_id,
                                             p_place_type_id               => exp_policy_place_relation_pkg.get_place_type_id(v_company_id,
                                                                                                                              v_place_to_id),
                                             p_place_id                    => v_place_from_id,
                                             p_tax_type_id                 => null,
                                             p_transportation              => v_line.transport_code,
                                             p_place_to_id                 => v_place_to_id,
                                             p_invoice_type                => v_line.invoice_type_desc,
                                             p_invoice_number              => v_line.invoice_number,
                                             p_invoice_status              => v_invoice_status,
                                             p_tax_amount                  => v_line.tax_amount,
                                             p_sale_amount                 => v_line.sale_amount,
                                             p_tax_rate                    => v_tax_rate,
                                             p_usage_type                  => v_line.usage_type,
                                             p_invoice_code                => v_line.invoice_code,
                                             p_invoice_date                => v_line.invoice_date,
                                             p_input_tax_structure_detail  => v_line.input_tax_structure_detail,
                                             p_ref_pay_num                 => null,
                                             p_ref_gather_num              => null,
                                             p_invoice_item                => null,
                                             p_deduction_rules             => null,
                                             p_adjusted_full_deductions    => null,
                                             p_adjusted_partial_deductions => null,
                                             p_adjustable_tax_deductible   => null,
                                             p_invoice_amount              => null,
                                             p_invoice_tax_amount          => null,
                                             p_associated_oasign           => null,
                                             p_invoice_sum_amount          => v_line.invoice_sum_amount,
                                             p_invoice_check_code          => v_line.invoice_check_code,
                                             p_invoice_sales_amount        => v_line.invoice_sales_amount,
                                             p_invoice_tax_amount_bak      => v_line.invoice_tax_amount_bak,
                                             p_employee_levels_id          => v_employee_levels_id);
    
      /*insert_exp_report_lines(v_exp_report_header_id,
      v_line.line_number,
      v_line.city,
      v_line.description,
      to_date_or_null(v_line.date_from,
                      'YYYY-MM-DD'),
      to_date_or_null(v_line.date_to, 'YYYY-MM-DD'),
      v_line.period_name,
      v_header_line.currency_code,
      v_header_line.exchange_rate_type,
      v_header_line.exchange_rate_quotation,
      v_header_line.exchange_rate,
      v_expense_type_id,
      v_expense_item_id,
      v_budget_item_id,
      v_line.price,
      v_line.primary_quantity,
      null,
      null,
      null,
      v_report_amount,
      v_report_functional_amount,
      null,
      v_company_id,
      v_unit_id,
      v_position_id,
      v_responsibility_center_id,
      v_employee_id,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      v_dimension_id_array(1),
      v_dimension_id_array(2),
      v_dimension_id_array(3),
      v_dimension_id_array(4),
      v_dimension_id_array(5),
      v_dimension_id_array(6),
      v_dimension_id_array(7),
      v_dimension_id_array(8),
      v_dimension_id_array(9),
      v_dimension_id_array(10),
      null,
      null,
      null,
      null,
      p_user_id,
      v_exp_report_line_id,
      v_place_type_id,
      v_place_id,
      v_line.batch_line_id); */
    
      update exp_rep_line_interface a
         set a.import_flag = 'N'
       where a.batch_id = v_line.batch_id
      /* and a.batch_line_id = v_line.batch_line_id*/
      ;
    end loop;
    p_load_status := 'SUCCESS';
  exception
    when others then
      p_load_status := 'FAILED';
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'EXP_INTERFACE_PKG',
                                                     p_procedure_function_name => 'load_expense_reports');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;
begin
  -- Initialization
  null;
end exp_interface_pkg;
/
