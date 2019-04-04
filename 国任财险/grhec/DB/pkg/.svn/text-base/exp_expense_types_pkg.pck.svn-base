create or replace package exp_expense_types_pkg is

  -- Author  : BOBO
  -- Created : 2009-4-20 16:49:20
  -- Purpose :

  function get_expense_type_id return number;

  procedure insert_exp_expense_types(p_company_id        number,
                                     p_expense_type_code varchar2,
                                     p_description       varchar2,
                                     p_enabled_flag      varchar2,
                                     p_created_by        number,
                                     p_last_updated_by   number,
                                     p_expense_type_id   out number);

  procedure update_exp_expense_types(p_expense_type_id number,
                                     p_description     varchar2,
                                     p_enabled_flag    varchar2,
                                     p_last_updated_by number);
                                       
  --公司级影像类型插入操作
  procedure insert_exp_image_types(  p_expense_type_id   NUMBER DEFAULT NULL,
                                     p_image_type_id NUMBER DEFAULT NULL,
                                     p_enabled_flag      VARCHAR2 DEFAULT NULL,
                                     p_user_id           NUMBER DEFAULT NULL);
 --公司及影像类型更新操作
  procedure update_exp_image_types(  p_exp_image_type_id NUMBER DEFAULT NULL,
                                     p_image_type_id NUMBER DEFAULT NULL,
                                     p_enabled_flag      VARCHAR2 DEFAULT NULL,
                                     p_user_id           NUMBER DEFAULT NULL);
end exp_expense_types_pkg;
 
 
/
create or replace package body exp_expense_types_pkg is

  function get_expense_type_id return number is
    v_expense_type_id exp_expense_types.expense_type_id%type;
  begin
    select exp_expense_types_s.nextval into v_expense_type_id from dual;
    return v_expense_type_id;
  end get_expense_type_id;


  procedure insert_exp_expense_types(p_company_id        number,
                                     p_expense_type_code varchar2,
                                     p_description       varchar2,
                                     p_enabled_flag      varchar2,
                                     p_created_by        number,
                                     p_last_updated_by   number,
                                     p_expense_type_id   out number) is
    v_expense_type_id exp_expense_types.expense_type_id%type;
    v_description_id  exp_expense_types.description_id%type;
  begin
    v_expense_type_id := get_expense_type_id;
    v_description_id  := fnd_description_pkg.get_fnd_description_id;

    insert into exp_expense_types
      (expense_type_id,
       company_id,
       expense_type_code,
       description_id,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    values
      (v_expense_type_id,
       p_company_id,
       upper(p_expense_type_code),
       v_description_id,
       p_enabled_flag,
       p_created_by,
       sysdate,
       p_last_updated_by,
       sysdate);

    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'EXP_EXPENSE_TYPES',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => '',
                                               p_created_by       => p_created_by,
                                               p_last_updated_by  => p_last_updated_by,
                                               p_language_code    => userenv('lang'));

    p_expense_type_id := v_expense_type_id;

  exception
    when dup_val_on_index then
      --若有insert 表，捕获 唯一索引错误
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXPENSE_TYPE_CODE_DUPLICATE',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'exp_expense_types_pkg',
                                                      p_procedure_function_name => 'insert_exp_expense_types');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_created_by              => p_last_updated_by,
                                                     p_package_name            => 'exp_expense_types_pkg',
                                                     p_procedure_function_name => 'insert_exp_expense_types');

      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end insert_exp_expense_types;

  procedure update_exp_expense_types(p_expense_type_id number,
                                     p_description     varchar2,
                                     p_enabled_flag    varchar2,
                                     p_last_updated_by number) is
    v_description_id exp_expense_types.description_id%type;
  begin
    select e.description_id
      into v_description_id
      from exp_expense_types e
     where e.expense_type_id = p_expense_type_id;

    update exp_expense_types e
       set e.enabled_flag     = p_enabled_flag,
           e.last_updated_by  = p_last_updated_by,
           e.last_update_date = sysdate
     where e.expense_type_id = p_expense_type_id;

    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'EXP_EXPENSE_TYPES',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => '',
                                               p_created_by       => p_last_updated_by,
                                               p_last_updated_by  => p_last_updated_by,
                                               p_language_code    => userenv('lang'));
  exception
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_created_by              => p_last_updated_by,
                                                     p_package_name            => 'exp_expense_types_pkg',
                                                     p_procedure_function_name => 'update_exp_expense_types');

      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end update_exp_expense_types;
  
 
   --公司级影像类型
  procedure insert_exp_image_types(   p_expense_type_id  NUMBER DEFAULT NULL,--exp_expense_types的主键
                                      p_image_type_id NUMBER DEFAULT NULL,
                                      p_enabled_flag      VARCHAR2 DEFAULT NULL,
                                      p_user_id           NUMBER DEFAULT NULL) IS 
    v_count number;
    begin
       select count(*)
      into v_count
      from exp_image_types es
     where es.expense_type_id = p_expense_type_id
       and es.image_type_id = p_image_type_id;
    
     if v_count > 0  then 
      
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'IMAGE_TYPES_UNIQUE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'exp_expense_types_pkg',
                                                      p_procedure_function_name => 'insert_exp_image_types');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  else
      insert into
      exp_image_types(
      exp_image_type_id,
      expense_type_id,
      image_type_id,
      enabled_flag,
      created_by,
      creation_date,
      last_updated_by,
      last_update_date
      )values(
      exp_image_type_s.nextval,
      p_expense_type_id,
      p_image_type_id,
      p_enabled_flag,
      p_user_id,
      sysdate,
      p_user_id,
      sysdate
      );
     end if; 
    end insert_exp_image_types;
    
    
     procedure update_exp_image_types(  p_exp_image_type_id  NUMBER DEFAULT NULL,
                                        p_image_type_id      NUMBER DEFAULT NULL,
                                        p_enabled_flag       VARCHAR2 DEFAULT NULL,
                                        p_user_id            NUMBER DEFAULT NULL) IS
      BEGIN
          update exp_image_types e
          set e.image_type_id=p_image_type_id,
              e.enabled_flag=p_enabled_flag,
              e.last_updated_by=p_user_id,
              e.last_update_date=sysdate
          where e.exp_image_type_id=p_exp_image_type_id;
      END;
          
end exp_expense_types_pkg;
/
