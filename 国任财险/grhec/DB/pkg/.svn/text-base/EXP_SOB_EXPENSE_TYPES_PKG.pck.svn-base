CREATE OR REPLACE PACKAGE "EXP_SOB_EXPENSE_TYPES_PKG" IS

  -- Author  : HYB
  -- Created : 2011/9/22 13:34:06
  -- Purpose :
  --------------------------------------------------------------------------------------
  --add：20130122   update_sob_expense_items  ,update_sob_exp_req_items
  --Purpose：帐套级报销类型定义 费用项目和申请项目失效后 删除对应公司级的关联关系
  FUNCTION get_expense_type_id RETURN NUMBER;
  FUNCTION get_company_id(p_enabled_flag      VARCHAR2,
                          p_expense_type_code VARCHAR2) RETURN NUMBER;
  PROCEDURE insert_exp_expense_types(p_company_id        NUMBER,
                                     p_expense_type_code VARCHAR2,
                                     p_description       VARCHAR2,
                                     p_enabled_flag      VARCHAR2,
                                     p_created_by        NUMBER,
                                     p_cashflow_code     VARCHAR2 DEFAULT NULL,
                                     p_meetting_flag     VARCHAR2 DEFAULT NULL,
                                     p_line_desc_flag    VARCHAR2 DEFAULT NULL,
                                     p_oa_sign_flag      VARCHAR2 DEFAULT NULL);
  PROCEDURE insert_exp_types_use_flag(p_company_id             NUMBER,
                                      p_expense_type_code      VARCHAR2,
                                      p_other_company_use_flag VARCHAR2,
                                      p_user_id                NUMBER);

  PROCEDURE insert_sob_expense_items(p_expense_type_code VARCHAR2,
                                     p_expense_item_id   NUMBER,
                                     p_set_of_books_id   NUMBER,
                                     p_enabled_flag      VARCHAR2,
                                     p_description       VARCHAR2,
                                     p_user_id           NUMBER);
  --Purpose：帐套级报销类型定义 费用项目和申请项目失效后 删除对应公司级的关联关系
  PROCEDURE update_sob_expense_items(p_exp_sob_type_item_id VARCHAR2,
                                     p_expense_type_code    VARCHAR2,
                                     p_expense_item_id      NUMBER,
                                     p_set_of_books_id      NUMBER,
                                     p_enabled_flag         VARCHAR2,
                                     p_description          VARCHAR2,
                                     p_user_id              NUMBER);

  PROCEDURE insert_sob_exp_req_items(p_expense_type_code VARCHAR2,
                                     p_exp_req_item_id   NUMBER,
                                     p_set_of_books_id   NUMBER,
                                     p_enabled_flag      VARCHAR2,
                                     p_description       VARCHAR2,
                                     p_user_id           NUMBER);

  --add by luqiang
  --purpose:账套级报销类型分配影像类型                                  
  PROCEDURE insert_sob_image_type(p_expense_type_code VARCHAR2,
                                  p_image_type_id     NUMBER,
                                  p_set_of_books_id   NUMBER,
                                  p_enabled_flag      VARCHAR2,
                                  p_user_id           NUMBER);
  
  PROCEDURE update_sob_image_type(p_exp_sob_image_type_id NUMBER,
                                  p_expense_type_code     VARCHAR2,
                                  p_image_type_id         NUMBER,
                                  p_set_of_books_id       NUMBER,
                                  p_enabled_flag          VARCHAR2,
                                  p_user_id               NUMBER);

  
  
  
  --Purpose：帐套级报销类型定义 费用项目和申请项目失效后 删除对应公司级的关联关系
  PROCEDURE update_sob_exp_req_items(p_exp_sob_type_req_item_id VARCHAR2,
                                     p_expense_type_code        VARCHAR2,
                                     p_exp_req_item_id          NUMBER,
                                     p_set_of_books_id          NUMBER,
                                     p_enabled_flag             VARCHAR2,
                                     --  p_description          varchar2,
                                     p_user_id NUMBER);

  PROCEDURE insert_exp_sob_expense_types(p_set_books_id           NUMBER,
                                         p_expense_type_code      VARCHAR2,
                                         p_description            VARCHAR2,
                                         p_enabled_flag           VARCHAR2,
                                         p_created_by             NUMBER,
                                         p_other_company_use_flag VARCHAR2,
                                         p_expense_type_id        OUT NUMBER,
                                         p_cashflow_code          VARCHAR2 DEFAULT NULL,
                                         p_meetting_flag          VARCHAR2 DEFAULT NULL,
                                         p_line_desc_flag         VARCHAR2 DEFAULT NULL,
                                         p_oa_sign_flag           VARCHAR2 DEFAULT NULL);

  PROCEDURE update_exp_sob_expense_types(p_set_books_id           NUMBER,
                                         p_expense_type_code      VARCHAR2,
                                         p_description_id         NUMBER,
                                         p_description            VARCHAR2,
                                         p_enabled_flag           VARCHAR2,
                                         p_last_updated_by        NUMBER,
                                         p_other_company_use_flag VARCHAR2,
                                         p_cashflow_code          VARCHAR2 DEFAULT NULL,
                                         p_meetting_flag          VARCHAR2 DEFAULT NULL,
                                         p_line_desc_flag         VARCHAR2 DEFAULT NULL,
                                         p_oa_sign_flag           VARCHAR2 DEFAULT NULL);
  --
  PROCEDURE assign_company_expense_types(p_company_id             NUMBER,
                                         p_expense_type_code      VARCHAR2,
                                         p_description            VARCHAR2,
                                         p_enabled_flag           VARCHAR2,
                                         p_other_company_use_flag VARCHAR2,
                                         p_user_id                NUMBER,
                                         p_sob_id                 NUMBER DEFAULT NULL);
  PROCEDURE update_company_expense_types(p_company_id             NUMBER,
                                         p_expense_type_code      VARCHAR2,
                                         p_description            VARCHAR2,
                                         p_enabled_flag           VARCHAR2,
                                         p_other_company_use_flag VARCHAR2,
                                         p_user_id                NUMBER);
  PROCEDURE exp_types_companies_select(p_set_of_books_id   NUMBER,
                                       p_company_id        NUMBER,
                                       p_expense_type_code VARCHAR2,
                                       p_user_id           NUMBER);
  PROCEDURE exp_types_select_company(p_company_id             NUMBER,
                                     p_expense_type_code      VARCHAR2,
                                     p_description            VARCHAR2,
                                     p_enabled_flag           VARCHAR2,
                                     p_user_id                NUMBER,
                                     p_other_company_use_flag VARCHAR2,
                                     p_sob_id                 NUMBER);
  /*为type增加分配item的时候，更新到已经分配的公司
  add by wyd 2012-12-24*/
  PROCEDURE activate_assigned_company(p_expense_type_code VARCHAR2,
                                      p_expense_item_id   NUMBER,
                                      p_exp_req_item_id   NUMBER,
                                      p_set_of_books_id   NUMBER,
                                      p_description       VARCHAR2,
                                      p_enabled_flag      VARCHAR2,
                                      p_user_id           NUMBER);

END exp_sob_expense_types_pkg;
/
CREATE OR REPLACE PACKAGE BODY "EXP_SOB_EXPENSE_TYPES_PKG" IS
  /*通过exp_expense_types_s序列获取费用类型id*/

  FUNCTION get_expense_type_id RETURN NUMBER IS
    v_expense_type_id exp_expense_types.expense_type_id%TYPE;
  BEGIN
    SELECT exp_expense_types_s.nextval INTO v_expense_type_id FROM dual;
    RETURN v_expense_type_id;
  END get_expense_type_id;

  --
  FUNCTION get_company_id(p_enabled_flag      VARCHAR2,
                          p_expense_type_code VARCHAR2) RETURN NUMBER IS
    v_company_id exp_expense_types.company_id%TYPE;
  BEGIN
    IF (p_enabled_flag = 'Y') THEN
      SELECT company_id
        INTO v_company_id
        FROM exp_expense_types_vl e
       WHERE e.expense_type_code = p_expense_type_code;
    
    ELSIF (p_enabled_flag = 'N') THEN
      SELECT company_id
        INTO v_company_id
        FROM fnd_companies
       WHERE company_id NOT IN
             (SELECT company_id
                FROM exp_expense_types_vl e
               WHERE e.expense_type_code = p_expense_type_code);
    END IF;
    RETURN v_company_id;
  END get_company_id;

  /*删除费用类型*/
  PROCEDURE delete_expense_types(p_expense_type_code VARCHAR2,
                                 p_company_id        NUMBER) IS
  BEGIN
    DELETE fnd_descriptions b
     WHERE EXISTS (SELECT 1
              FROM exp_expense_types a
             WHERE a.description_id = b.description_id
               AND a.expense_type_code = p_expense_type_code
               AND a.company_id = p_company_id);
  
    DELETE exp_expense_types a
     WHERE a.expense_type_code = p_expense_type_code
       AND a.company_id = p_company_id;
  END;
  /*获取费用类型的记录条数*/
  FUNCTION expense_types_count(p_expense_type_code VARCHAR2,
                               p_company_id        NUMBER) RETURN NUMBER IS
    n_count NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO n_count
      FROM exp_expense_types a
     WHERE a.expense_type_code = p_expense_type_code
       AND a.company_id = p_company_id;
    RETURN n_count;
  END;
  /*更新费用类型表*/
  PROCEDURE update_exp_expense_types(p_company_id        NUMBER,
                                     p_expense_type_code VARCHAR2,
                                     p_description       VARCHAR2,
                                     p_enabled_flag      VARCHAR2,
                                     p_last_updated_by   NUMBER,
                                     p_cashflow_code     VARCHAR2 DEFAULT NULL,
                                     p_meetting_flag     VARCHAR2 DEFAULT NULL,
                                     p_line_desc_flag    VARCHAR2 DEFAULT NULL,
                                     p_oa_sign_flag      VARCHAR2 DEFAULT NULL) IS
    v_description_id exp_expense_types.description_id%TYPE;
  BEGIN
    SELECT e.description_id
      INTO v_description_id
      FROM exp_expense_types e
     WHERE e.expense_type_code = p_expense_type_code
       AND e.company_id = p_company_id;
  
    UPDATE exp_expense_types e
       SET e.enabled_flag     = p_enabled_flag,
           e.last_updated_by  = p_last_updated_by,
           e.last_update_date = SYSDATE,
           e.cashflow_code    = p_cashflow_code,
           e.meetting_flag    = p_meetting_flag,
           e.line_desc_flag   = p_line_desc_flag,
           e.oa_sign_flag     = p_oa_sign_flag 
     WHERE e.expense_type_code = p_expense_type_code
       AND e.company_id = p_company_id;
  
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'EXP_EXPENSE_TYPES',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => '',
                                               p_created_by       => p_last_updated_by,
                                               p_last_updated_by  => p_last_updated_by,
                                               p_language_code    => userenv('lang'));
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_last_updated_by,
                                                     p_package_name            => 'EXP_SOB_EXPENSE_TYPES_PKG',
                                                     p_procedure_function_name => 'update_exp_expense_types');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END update_exp_expense_types;

  /*增加或删除帐套内全部公司公司级费用类型*/
  PROCEDURE exp_types_companies_select(p_set_of_books_id   NUMBER,
                                       p_company_id        NUMBER,
                                       p_expense_type_code VARCHAR2,
                                       p_user_id           NUMBER) IS
    --n_count number;
    e_company_select_error EXCEPTION;
    v_exp_sob_expense_types exp_sob_expense_types_vl%ROWTYPE;
  BEGIN
  
    SELECT *
      INTO v_exp_sob_expense_types
      FROM exp_sob_expense_types_vl e
     WHERE e.expense_type_code = p_expense_type_code
       AND e.set_of_books_id = p_set_of_books_id;
    exp_types_select_company(p_company_id             => p_company_id,
                             p_expense_type_code      => v_exp_sob_expense_types.expense_type_code,
                             p_description            => v_exp_sob_expense_types.description,
                             p_enabled_flag           => v_exp_sob_expense_types.enabled_flag,
                             p_user_id                => p_user_id,
                             p_other_company_use_flag => v_exp_sob_expense_types.other_company_use_flag,
                             p_sob_id                 => p_set_of_books_id);
  EXCEPTION
    WHEN e_company_select_error THEN
      --若有insert 表，捕获 唯一索引错误
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP_COMP_SELECT_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_SOB_EXPENSE_TYPES_PKG',
                                                      p_procedure_function_name => 'exp_types_companies_select');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'EXP_SOB_EXPENSE_TYPES_PKG',
                                                     p_procedure_function_name => 'exp_types_companies_select');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  /*增加或删除帐套内全部公司公司级费用类型*/
  PROCEDURE exp_types_company_select(p_set_of_books_id        NUMBER,
                                     p_expense_type_code      VARCHAR2,
                                     p_description            VARCHAR2,
                                     p_enabled_flag           VARCHAR2,
                                     p_user_id                NUMBER,
                                     p_other_company_use_flag VARCHAR2) IS
    n_count NUMBER;
  
  BEGIN
    FOR c_cur IN (SELECT t.company_id
                    FROM fnd_companies t
                   WHERE t.set_of_books_id = p_set_of_books_id
                     AND t.company_type = 1) LOOP
      IF p_enabled_flag = 'N' THEN
        delete_expense_types(p_expense_type_code, c_cur.company_id);
      ELSE
        n_count := expense_types_count(p_expense_type_code,
                                       c_cur.company_id);
        IF n_count > 0 THEN
          update_exp_expense_types(p_company_id        => c_cur.company_id,
                                   p_expense_type_code => p_expense_type_code,
                                   p_description       => p_description,
                                   p_enabled_flag      => 'Y',
                                   p_last_updated_by   => p_user_id);
        
          insert_exp_types_use_flag(p_company_id             => c_cur.company_id,
                                    p_expense_type_code      => p_expense_type_code,
                                    p_other_company_use_flag => p_other_company_use_flag,
                                    p_user_id                => p_user_id);
        ELSE
          insert_exp_expense_types(p_company_id        => c_cur.company_id,
                                   p_expense_type_code => p_expense_type_code,
                                   p_description       => p_description,
                                   p_enabled_flag      => 'Y',
                                   p_created_by        => p_user_id);
        
          insert_exp_types_use_flag(p_company_id             => c_cur.company_id,
                                    p_expense_type_code      => p_expense_type_code,
                                    p_other_company_use_flag => p_other_company_use_flag,
                                    p_user_id                => p_user_id);
        END IF;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'EXP_SOB_EXPENSE_TYPES_PKG',
                                                     p_procedure_function_name => 'exp_types_company_select');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  /*增加或删除公司级费用类型*/
  PROCEDURE exp_types_select_company(p_company_id             NUMBER,
                                     p_expense_type_code      VARCHAR2,
                                     p_description            VARCHAR2,
                                     p_enabled_flag           VARCHAR2,
                                     p_user_id                NUMBER,
                                     p_other_company_use_flag VARCHAR2,
                                     p_sob_id                 NUMBER) IS
    n_count NUMBER;
  
    e_comp_enabled_error EXCEPTION;
    v_expense_type_id NUMBER;
    v_exist           NUMBER;
    v_enabled_flag    VARCHAR2(2);
    v_cashflow_code   VARCHAR2(100);
  BEGIN
    n_count := expense_types_count(p_expense_type_code, p_company_id);
    BEGIN
      SELECT et.cashflow_code
        INTO v_cashflow_code
        FROM exp_sob_expense_types et
       WHERE et.expense_type_code = p_expense_type_code
         AND et.set_of_books_id = p_sob_id;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    IF n_count > 0 THEN
      update_exp_expense_types(p_company_id        => p_company_id,
                               p_expense_type_code => p_expense_type_code,
                               p_description       => p_description,
                               p_enabled_flag      => p_enabled_flag,
                               p_last_updated_by   => p_user_id,
                               p_cashflow_code     => v_cashflow_code);
    
      insert_exp_types_use_flag(p_company_id             => p_company_id,
                                p_expense_type_code      => p_expense_type_code,
                                p_other_company_use_flag => p_other_company_use_flag,
                                p_user_id                => p_user_id);
    ELSE
      insert_exp_expense_types(p_company_id        => p_company_id,
                               p_expense_type_code => p_expense_type_code,
                               p_description       => p_description,
                               p_enabled_flag      => p_enabled_flag,
                               p_created_by        => p_user_id,
                               p_cashflow_code     => v_cashflow_code);
    
      insert_exp_types_use_flag(p_company_id             => p_company_id,
                                p_expense_type_code      => p_expense_type_code,
                                p_other_company_use_flag => p_other_company_use_flag,
                                p_user_id                => p_user_id);
    
    END IF;
    --20130201  sqh 批量分配报销类型给公司时 同时分配费用项目和申请项目
  
    IF p_sob_id IS NOT NULL THEN
      --如果传递账套进行处理
      --分配 费用项目
    
      FOR v_item IN (SELECT *
                       FROM exp_sob_type_expense_items eei
                      WHERE eei.set_of_books_id = p_sob_id
                        AND eei.expense_type_code = p_expense_type_code) LOOP
        --判断是否所在公司的该费用项目启用
        BEGIN
          SELECT ecei.enabled_flag
            INTO v_enabled_flag
            FROM exp_company_expense_items ecei
           WHERE ecei.company_id = p_company_id
             AND ecei.expense_item_id = v_item.expense_item_id;
        
        EXCEPTION
          WHEN no_data_found THEN
            /*为该公司分配新的费用项目
            add by wyd 2012-12-23*/
            exp_expense_items_pkg.insert_company_expense_items(v_item.expense_item_id,
                                                               p_company_id,
                                                               v_item.enabled_flag,
                                                               p_user_id);
          
            --第一次分配费用项目
            SELECT a.expense_type_id
              INTO v_expense_type_id
              FROM exp_expense_types a
             WHERE a.expense_type_code = p_expense_type_code
               AND a.company_id = p_company_id;
            exp_expense_items_pkg.insert_exp_expense_item_types(p_expense_item_id => v_item.expense_item_id,
                                                                p_expense_type_id => v_expense_type_id,
                                                                p_created_by      => p_user_id,
                                                                p_last_updated_by => p_user_id);
          
        END;
      
        IF v_enabled_flag = 'Y' THEN
        
          SELECT a.expense_type_id
            INTO v_expense_type_id
            FROM exp_expense_types a
           WHERE a.expense_type_code = p_expense_type_code
             AND a.company_id = p_company_id;
          --查看是否已经存在分配了的费用项目指定报销类型
          BEGIN
            SELECT 1
              INTO v_exist
              FROM dual
             WHERE EXISTS
             (SELECT 1
                      FROM exp_expense_item_types a
                     WHERE a.expense_item_id = v_item.expense_item_id
                       AND a.expense_type_id = v_expense_type_id);
            --如果不存在数据进行分配费用项目
          EXCEPTION
            WHEN no_data_found THEN
              exp_expense_items_pkg.insert_exp_expense_item_types(p_expense_item_id => v_item.expense_item_id,
                                                                  p_expense_type_id => v_expense_type_id,
                                                                  p_created_by      => p_user_id,
                                                                  p_last_updated_by => p_user_id);
          END;
        
        END IF;
      
      END LOOP;
    
      --分配 申请项目
      FOR v_req_item IN (SELECT *
                           FROM exp_sob_type_req_items eri
                          WHERE eri.set_of_books_id = p_sob_id
                            AND eri.expense_type_code = p_expense_type_code) LOOP
        --判断是否所在公司的该申请项目启用
        BEGIN
          SELECT ecri.enabled_flag
            INTO v_enabled_flag
            FROM exp_company_req_items ecri
           WHERE ecri.company_id = p_company_id
             AND ecri.req_item_id = v_req_item.req_item_id;
        EXCEPTION
          WHEN no_data_found THEN
            /*为该公司分配新的费用项目
            add by wyd 2012-12-23*/
          
            exp_req_items_pkg.insert_exp_company_req_items(v_req_item.exp_sob_type_req_item_id,
                                                           p_company_id,
                                                           v_req_item.enabled_flag,
                                                           p_user_id);
            --第一次分配申请项目
            SELECT a.expense_type_id
              INTO v_expense_type_id
              FROM exp_expense_types a
             WHERE a.expense_type_code = p_expense_type_code
               AND a.company_id = p_company_id;
          
            exp_req_items_pkg.insert_exp_req_item_types(p_req_item_id     => v_req_item.exp_sob_type_req_item_id,
                                                        p_expense_type_id => v_expense_type_id,
                                                        p_created_by      => p_user_id);
          
        END;
        IF v_enabled_flag = 'Y' THEN
          SELECT a.expense_type_id
            INTO v_expense_type_id
            FROM exp_expense_types a
           WHERE a.expense_type_code = p_expense_type_code
             AND a.company_id = p_company_id;
          --查看是否已经存在分配了的申请项目指定报销类型
          BEGIN
            SELECT 1
              INTO v_exist
              FROM dual
             WHERE EXISTS
             (SELECT 1
                      FROM exp_req_item_types a
                     WHERE a.req_item_id = v_req_item.req_item_id
                       AND a.expense_type_id = v_expense_type_id);
            --如果不存在数据进行分配申请项目
          EXCEPTION
            WHEN no_data_found THEN
              exp_req_items_pkg.insert_exp_req_item_types(p_req_item_id     => v_req_item.req_item_id,
                                                          p_expense_type_id => v_expense_type_id,
                                                          p_created_by      => p_user_id);
          END;
        END IF;
      END LOOP;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'EXP_SOB_EXPENSE_TYPES_PKG',
                                                     p_procedure_function_name => 'exp_types_select_company');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  /*增加或更新公司级费用类型是否跨公司使用*/
  PROCEDURE insert_exp_types_use_flag(p_company_id             NUMBER,
                                      p_expense_type_code      VARCHAR2,
                                      p_other_company_use_flag VARCHAR2,
                                      p_user_id                NUMBER) IS
    n_expense_type_id NUMBER;
  BEGIN
    SELECT expense_type_id
      INTO n_expense_type_id
      FROM exp_expense_types
     WHERE expense_type_code = p_expense_type_code
       AND company_id = p_company_id;
  
    UPDATE exp_types_use_flag t
       SET t.other_company_use_flag = p_other_company_use_flag
     WHERE t.expense_type_id = n_expense_type_id;
    IF SQL%NOTFOUND THEN
      INSERT INTO exp_types_use_flag
        (expense_type_id,
         other_company_use_flag,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date)
      VALUES
        (n_expense_type_id,
         p_other_company_use_flag,
         p_user_id,
         SYSDATE,
         p_user_id,
         SYSDATE);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'EXP_SOB_EXPENSE_TYPES_PKG',
                                                     p_procedure_function_name => 'insert_exp_types_use_flag');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

   PROCEDURE insert_sob_image_type(p_expense_type_code VARCHAR2,
                                  p_image_type_id     NUMBER,
                                  p_set_of_books_id   NUMBER,
                                  p_enabled_flag      VARCHAR2,
                                  p_user_id           NUMBER) IS
  
  v_count number;   
  v_count1 number;   
  v_exp_image_type_id exp_expense_types.expense_type_id%type;                         
  BEGIN
    --同一个报销类型配置相同影像分类校验
    select count(*)
      into v_count
      from exp_sob_image_types es
     where es.expense_type_code = p_expense_type_code
       and es.image_type_id = p_image_type_id;
    
     if v_count > 0  then 
      
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'IMAGE_TYPES_UNIQUE_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'exp_sob_expense_types_pkg',
                                                      p_procedure_function_name => 'insert_sob_image_type');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  else
  
  insert into exp_sob_image_types
    (exp_sob_image_type_id,
     set_of_books_id,
     image_type_id,
     enabled_flag,
     created_by,
     creation_date,
     last_updated_by,
     last_update_date,
     expense_type_code)
  values
    (exp_sob_image_types_s.nextval,
     p_set_of_books_id,
     p_image_type_id,
     p_enabled_flag,
     p_user_id,
     sysdate,
     p_user_id,
     sysdate,
     p_expense_type_code);
  end if;
  
  
   --级联公司插入影像
   FOR c_cur IN (SELECT eet.expense_type_id
                    FROM fnd_companies         fc,
                         exp_expense_types     eet
                   WHERE fc.set_of_books_id = p_set_of_books_id
                     AND eet.expense_type_code =p_expense_type_code
                     AND eet.company_id = fc.company_id )LOOP
                --如果公司级有则更新  
                select  count(1)
                into v_count1 
                from exp_image_types ei
                where ei.expense_type_id=c_cur.expense_type_id
                     and ei.image_type_id=p_image_type_id;
                if v_count1>0 then
                  select ei.exp_image_type_id 
                  into v_exp_image_type_id
                  from exp_image_types ei
                  where ei.expense_type_id=c_cur.expense_type_id
                     and ei.image_type_id=p_image_type_id;
                   exp_expense_types_pkg.update_exp_image_types( v_exp_image_type_id,
                                                         p_image_type_id,
                                                         p_enabled_flag,
                                                         p_user_id ) ;   
              else
             exp_expense_types_pkg.insert_exp_image_types( c_cur.expense_type_id,
                                                           p_image_type_id,
                                                           p_enabled_flag,
                                                           p_user_id);
                                                           
              end if;                                                     
         END LOOP;
  
   END;
  
  PROCEDURE update_sob_image_type(p_exp_sob_image_type_id NUMBER,
                                  p_expense_type_code   VARCHAR2,
                                  p_image_type_id       NUMBER,
                                  p_set_of_books_id     NUMBER,
                                  p_enabled_flag        VARCHAR2,
                                  p_user_id             NUMBER) IS
  BEGIN
    
  update exp_sob_image_types es
     set es.expense_type_code =  p_expense_type_code,
         es.image_type_id     = p_image_type_id,
         es.set_of_books_id   = p_set_of_books_id,
         es.enabled_flag      = p_enabled_flag,
         es.last_update_date  = sysdate,
         es.last_updated_by   = p_user_id
   where es.exp_sob_image_type_id = p_exp_sob_image_type_id;
   --级联更新公司级报销类型
   For c_cur in(select eit.exp_image_type_id
                         from fnd_companies fc,
                         exp_expense_types eet,
                         exp_image_types eit
                         where fc.set_of_books_id=p_set_of_books_id
                         and eet.company_id=fc.company_id
                         and eet.expense_type_code=p_expense_type_code
                         and eit.expense_type_id=eet.expense_type_id
                         and eit.image_type_id=p_image_type_id) LOOP
                         
           exp_expense_types_pkg.update_exp_image_types( c_cur.exp_image_type_id,
                                                         p_image_type_id,
                                                         p_enabled_flag,
                                                         p_user_id ) ;    
                        
   END LOOP;
    
  END;


  PROCEDURE insert_sob_expense_items(p_expense_type_code VARCHAR2,
                                     p_expense_item_id   NUMBER,
                                     p_set_of_books_id   NUMBER,
                                     p_enabled_flag      VARCHAR2,
                                     p_description       VARCHAR2,
                                     p_user_id           NUMBER) IS
  
  BEGIN
    INSERT INTO exp_sob_type_expense_items
      (exp_sob_type_item_id,
       set_of_books_id,
       expense_type_code,
       expense_item_id,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (exp_sob_type_expense_items_s.nextval,
       p_set_of_books_id,
       p_expense_type_code,
       p_expense_item_id,
       p_enabled_flag,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE);
  
    activate_assigned_company(p_expense_type_code => p_expense_type_code,
                              p_expense_item_id   => p_expense_item_id,
                              p_exp_req_item_id   => NULL,
                              p_set_of_books_id   => p_set_of_books_id,
                              p_description       => p_description,
                              p_enabled_flag      => p_enabled_flag,
                              p_user_id           => p_user_id);
  
  EXCEPTION
    WHEN dup_val_on_index THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXPENSE_TYPE_ITEM_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_SOB_EXPENSE_TYPES_PKG',
                                                      p_procedure_function_name => 'insert_sob_expense_items');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;
  --20130122
  --帐套级报销类型定义 费用项目和申请项目失效后 删除对应公司级的关联关系
  PROCEDURE update_sob_expense_items(p_exp_sob_type_item_id VARCHAR2,
                                     p_expense_type_code    VARCHAR2,
                                     p_expense_item_id      NUMBER,
                                     p_set_of_books_id      NUMBER,
                                     p_enabled_flag         VARCHAR2,
                                     p_description          VARCHAR2,
                                     p_user_id              NUMBER) IS
    v_expense_type_id         VARCHAR2(100);
    v_expense_item_id         NUMBER;
    v_company_expense_item_id NUMBER;
  BEGIN
    UPDATE exp_sob_type_expense_items t1
       SET t1.set_of_books_id   = p_set_of_books_id,
           t1.expense_type_code = p_expense_type_code,
           t1.expense_item_id   = p_expense_item_id,
           t1.enabled_flag      = p_enabled_flag,
           t1.last_updated_by   = p_user_id,
           t1.last_update_date  = SYSDATE
     WHERE t1.exp_sob_type_item_id = p_exp_sob_type_item_id;
    /*
     select eet.expense_type_id
        into v_expense_type_id
        from exp_expense_types eet
       where eet.expense_type_code = p_expense_type_code;
    */
    --当p_enabled_flag='N' 时候 删除 exp_company_expense_items 表中启用的公司对应的公司的关联关系
    IF p_enabled_flag = 'N' THEN
      --报销类型分配给了哪些公司
      FOR cur_companys IN (SELECT t.company_id, t.expense_type_id
                             FROM exp_expense_types t, fnd_companies fc
                            WHERE t.expense_type_code = p_expense_type_code
                              AND t.company_id = fc.company_id
                              AND fc.set_of_books_id = p_set_of_books_id) LOOP
      
        FOR cur_expense_item_ids IN (SELECT t.expense_item_id
                                       FROM exp_sob_type_expense_items t
                                      WHERE t.set_of_books_id =
                                            p_set_of_books_id
                                        AND t.expense_type_code =
                                            p_expense_type_code
                                        AND t.expense_item_id =
                                            p_expense_item_id) LOOP
          --公司级费用项目表  费用项目id(引用的是帐套级里面的费用项目id)：expense_item_id 和company_id ()；找出expense_item_id在分配表exp_expense_item_types中使用
          SELECT t.expense_item_id
            INTO v_company_expense_item_id
            FROM exp_company_expense_items t
           WHERE t.expense_item_id = cur_expense_item_ids.expense_item_id
             AND t.company_id = cur_companys.company_id
             AND t.enabled_flag = 'Y';
        
          --删除公司级的费用报销项目分配报销类型 关联关系表 这里的 expense_type_id 是取自 公司级报销类型表 exp_expense_types
          DELETE FROM exp_expense_item_types eeit
           WHERE eeit.expense_item_id = v_company_expense_item_id
             AND eeit.expense_type_id = cur_companys.expense_type_id;
        END LOOP;
      END LOOP;
      /*
      for cur_companys in (select t.company_id, t.expense_type_id
                             from exp_expense_types t, fnd_companies fc
                            where t.expense_type_code = p_expense_type_code
                              and t.company_id = fc.company_id
                              and fc.set_of_books_id = p_set_of_books_id) loop
      
        --需要过滤帐套
        for cur_expense_item_id in (SELECT eeit.expense_item_id
                                      FROM exp_expense_item_types eeit
                                     where eeit.expense_type_id =
                                           cur_companys.expense_type_id) loop
          delete from exp_company_expense_items t
           where t.expense_item_id = cur_expense_item_id.expense_item_id
             and t.company_id = cur_companys.company_id
             and t.enabled_flag = 'Y';
        end loop;
      end loop;
      */
      --当p_enabled_flag='Y' 时候  插入 exp_company_expense_items 表中启用的公司对应的公司的关联关系
    ELSIF p_enabled_flag = 'Y' THEN
      FOR cur_companys IN (SELECT t.company_id, t.expense_type_id
                             FROM exp_expense_types t, fnd_companies fc
                            WHERE t.expense_type_code = p_expense_type_code
                              AND t.company_id = fc.company_id
                              AND fc.set_of_books_id = p_set_of_books_id) LOOP
        --需要过滤帐套
        FOR cur_expense_item_ids IN (SELECT t.expense_item_id
                                       FROM exp_sob_type_expense_items t
                                      WHERE t.set_of_books_id =
                                            p_set_of_books_id
                                        AND t.expense_type_code =
                                            p_expense_type_code
                                        AND t.expense_item_id =
                                            p_expense_item_id) LOOP
          --插入之前 先删除
          DELETE FROM exp_expense_item_types eeit
           WHERE eeit.expense_item_id =
                 cur_expense_item_ids.expense_item_id
             AND eeit.expense_type_id = cur_companys.expense_type_id;
          INSERT INTO exp_expense_item_types
            (expense_item_types_id,
             created_by,
             creation_date,
             last_updated_by,
             last_update_date,
             expense_item_id,
             expense_type_id)
          VALUES
            (exp_expense_item_types_s.nextval,
             p_user_id,
             SYSDATE,
             p_user_id,
             SYSDATE,
             cur_expense_item_ids.expense_item_id,
             cur_companys.expense_type_id);
        END LOOP;
      END LOOP;
    END IF;
  
  EXCEPTION
    WHEN dup_val_on_index THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXPENSE_TYPE_ITEM_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_SOB_EXPENSE_TYPES_PKG',
                                                      p_procedure_function_name => 'insert_sob_expense_items');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  PROCEDURE insert_sob_exp_req_items(p_expense_type_code VARCHAR2,
                                     p_exp_req_item_id   NUMBER,
                                     p_set_of_books_id   NUMBER,
                                     p_enabled_flag      VARCHAR2,
                                     p_description       VARCHAR2,
                                     p_user_id           NUMBER) IS
  
  BEGIN
    INSERT INTO exp_sob_type_req_items
      (exp_sob_type_req_item_id,
       set_of_books_id,
       expense_type_code,
       req_item_id,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (exp_sob_type_req_items_s.nextval,
       p_set_of_books_id,
       p_expense_type_code,
       p_exp_req_item_id,
       p_enabled_flag,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE);
  
    activate_assigned_company(p_expense_type_code => p_expense_type_code,
                              p_expense_item_id   => NULL,
                              p_exp_req_item_id   => p_exp_req_item_id,
                              p_set_of_books_id   => p_set_of_books_id,
                              p_description       => p_description,
                              p_enabled_flag      => p_enabled_flag,
                              p_user_id           => p_user_id);
  
  EXCEPTION
    WHEN dup_val_on_index THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXPENSE_TYPE_REQ_ITEM_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_SOB_EXPENSE_TYPES_PKG',
                                                      p_procedure_function_name => 'insert_sob_exp_req_items');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;
  
 
  
  --add：20130122   update_sob_expense_items  ,update_sob_exp_req_items
  --Purpose：帐套级报销类型定义 费用项目和申请项目失效后 删除对应公司级的关联关系

  PROCEDURE update_sob_exp_req_items(p_exp_sob_type_req_item_id VARCHAR2,
                                     p_expense_type_code        VARCHAR2,
                                     p_exp_req_item_id          NUMBER,
                                     p_set_of_books_id          NUMBER,
                                     p_enabled_flag             VARCHAR2,
                                     -- p_description          varchar2,
                                     p_user_id NUMBER) IS
    v_company_req_item_id NUMBER;
  
  BEGIN
    UPDATE exp_sob_type_req_items t1
       SET t1.set_of_books_id   = p_set_of_books_id,
           t1.expense_type_code = p_expense_type_code,
           t1.req_item_id       = p_exp_req_item_id,
           t1.enabled_flag      = p_enabled_flag,
           t1.last_updated_by   = p_user_id,
           t1.last_update_date  = SYSDATE
     WHERE t1.exp_sob_type_req_item_id = p_exp_sob_type_req_item_id;
  
    --当p_enabled_flag='N' 时候 删除 exp_company_expense_items 表中启用的公司对应的公司的关联关系
    --需要过滤帐套
    IF p_enabled_flag = 'N' THEN
      --报销类型分配给了哪些公司
      FOR cur_companys IN (SELECT t.company_id, t.expense_type_id
                             FROM exp_expense_types t, fnd_companies fc
                            WHERE t.expense_type_code = p_expense_type_code
                              AND t.company_id = fc.company_id
                              AND fc.set_of_books_id = p_set_of_books_id) LOOP
        --帐套级报销类型关联的申请项目
        FOR cur_req_item_ids IN (SELECT t.req_item_id
                                   FROM exp_sob_type_req_items t
                                  WHERE t.set_of_books_id =
                                        p_set_of_books_id
                                    AND t.expense_type_code =
                                        p_expense_type_code
                                    AND t.req_item_id = p_exp_req_item_id) LOOP
          --公司级费用项目表  费用项目id(引用的是帐套级里面的费用项目id)：expense_item_id 和company_id ()；找出expense_item_id在分配表exp_expense_item_types中使用
          BEGIN
            SELECT t.req_item_id
              INTO v_company_req_item_id
              FROM exp_company_req_items t
             WHERE t.req_item_id = cur_req_item_ids.req_item_id
               AND t.company_id = cur_companys.company_id
               AND t.enabled_flag = 'Y';
          
            --删除公司级的费用项目分配报销类型 关联关系表
            DELETE FROM exp_req_item_types eeit
             WHERE eeit.req_item_id = v_company_req_item_id
               AND eeit.expense_type_id = cur_companys.expense_type_id;
          EXCEPTION
            WHEN no_data_found THEN
              NULL;
          END;
        END LOOP;
      END LOOP;
      --当p_enabled_flag='Y' 时候  插入 exp_req_item_types 表中启用的报销类型和申请项目对应的关联关系
    ELSIF p_enabled_flag = 'Y' THEN
      --报销类型分配给了哪些公司
      FOR cur_companys IN (SELECT t.company_id, t.expense_type_id
                             FROM exp_expense_types t, fnd_companies fc
                            WHERE t.expense_type_code = p_expense_type_code
                              AND t.company_id = fc.company_id
                              AND fc.set_of_books_id = p_set_of_books_id) LOOP
        --帐套级报销类型关联的申请项目
        FOR cur_req_item_ids IN (SELECT t.req_item_id
                                   FROM exp_sob_type_req_items t
                                  WHERE t.set_of_books_id =
                                        p_set_of_books_id
                                    AND t.expense_type_code =
                                        p_expense_type_code
                                    AND t.req_item_id = p_exp_req_item_id) LOOP
          DELETE FROM exp_req_item_types erit
           WHERE erit.req_item_id = cur_req_item_ids.req_item_id
             AND erit.expense_type_id = cur_companys.expense_type_id;
          INSERT INTO exp_req_item_types t
            (req_item_types_id,
             req_item_id,
             expense_type_id,
             created_by,
             creation_date,
             last_updated_by,
             last_update_date)
          VALUES
            (exp_req_item_types_s.nextval,
             cur_req_item_ids.req_item_id,
             cur_companys.expense_type_id,
             p_user_id,
             SYSDATE,
             p_user_id,
             SYSDATE);
        END LOOP;
      END LOOP;
    END IF;
    /*
    
      for cur_companys in (select t.company_id, t.expense_type_id
                             from exp_expense_types t, fnd_companies fc
                            where t.expense_type_code = p_expense_type_code
                              and t.company_id = fc.company_id
                              and fc.set_of_books_id = p_set_of_books_id) loop
    
        for cur_req_item_id in (SELECT erit.req_item_id
                                  FROM exp_req_item_types erit
                                 where erit.expense_type_id =
                                       cur_companys.expense_type_id) loop
          delete from exp_company_req_items t
           where t.req_item_id = cur_req_item_id.req_item_id
             and t.company_id = cur_companys.company_id
             and t.enabled_flag = 'Y';
        end loop;
      end loop;
      --当p_enabled_flag='Y' 时候  插入 exp_company_expense_items 表中启用的公司对应的公司的关联关系
    
    elsif p_enabled_flag = 'Y' then
      for cur_companys in (select t.company_id, t.expense_type_id
                             from exp_expense_types t, fnd_companies fc
                            where t.expense_type_code = p_expense_type_code
                              and t.company_id = fc.company_id
                              and fc.set_of_books_id = p_set_of_books_id) loop
    
        for cur_req_item_id in (SELECT erit.req_item_id
                                  FROM exp_req_item_types erit
                                 where erit.expense_type_id =
                                       cur_companys.expense_type_id) loop
          insert into exp_company_req_items t
            (req_item_id,
             company_id,
             enabled_flag,
             created_by,
             creation_date,
             last_updated_by,
             last_update_date)
          values
            (cur_req_item_id.req_item_id,
             cur_companys.company_id,
             'Y',
             p_user_id,
             sysdate,
             p_user_id,
             sysdate);
        end loop;
      end loop;
      end if;*/
  
  EXCEPTION
    WHEN dup_val_on_index THEN
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXPENSE_TYPE_REQ_ITEM_DUPLICATE',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_SOB_EXPENSE_TYPES_PKG',
                                                      p_procedure_function_name => 'insert_sob_exp_req_items');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  /*增加帐套级费用类型*/
  PROCEDURE insert_exp_sob_expense_types(p_set_books_id           NUMBER,
                                         p_expense_type_code      VARCHAR2,
                                         p_description            VARCHAR2,
                                         p_enabled_flag           VARCHAR2,
                                         p_created_by             NUMBER,
                                         p_other_company_use_flag VARCHAR2,
                                         p_expense_type_id        OUT NUMBER,
                                         p_cashflow_code          VARCHAR2 DEFAULT NULL,
                                         p_meetting_flag          VARCHAR2 DEFAULT NULL,
                                         p_line_desc_flag         VARCHAR2 DEFAULT NULL,
                                         p_oa_sign_flag           VARCHAR2 DEFAULT NULL) IS
    v_expense_type_id exp_expense_types.expense_type_id%TYPE;
    v_description_id  NUMBER;
  BEGIN
    v_expense_type_id := get_expense_type_id;
    v_description_id  := fnd_description_pkg.get_fnd_description_id;
  
    INSERT INTO exp_sob_expense_types
      (expense_type_id,
       set_of_books_id,
       expense_type_code,
       description_id,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       other_company_use_flag,
       cashflow_code,
       meetting_flag,
       line_desc_flag,
       oa_sign_flag)
    VALUES
      (v_expense_type_id,
       p_set_books_id,
       upper(p_expense_type_code),
       v_description_id,
       p_enabled_flag,
       p_created_by,
       SYSDATE,
       p_created_by,
       SYSDATE,
       p_other_company_use_flag,
       p_cashflow_code,
       p_meetting_flag,
       p_line_desc_flag,
       p_oa_sign_flag);
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'EXP_SOB_EXPENSE_TYPES',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => '',
                                               p_created_by       => p_created_by,
                                               p_last_updated_by  => p_created_by,
                                               p_language_code    => userenv('lang'));
    /*    delete fnd_descriptions b
     where exists (select 1
              from exp_expense_types a
             where a.description_id = b.description_id
               and a.expense_type_code = p_expense_type_code);
    
    delete exp_expense_types a
     where a.expense_type_code = p_expense_type_code;*/
    --不自动下派
    /*exp_types_company_select(p_set_of_books_id        => p_set_books_id,
    p_expense_type_code      => p_expense_type_code,
    p_description            => p_description,
    p_enabled_flag           => p_enabled_flag,
    p_user_id                => p_created_by,
    p_other_company_use_flag => p_other_company_use_flag);*/
    p_expense_type_id := v_expense_type_id;
  
  EXCEPTION
    WHEN dup_val_on_index THEN
      --若有insert 表，捕获 唯一索引错误
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXPENSE_TYPE_CODE_DUPLICATE',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'EXP_SOB_EXPENSE_TYPES_PKG',
                                                      p_procedure_function_name => 'insert_exp_sob_expense_types');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'EXP_SOB_EXPENSE_TYPES_PKG',
                                                     p_procedure_function_name => 'insert_exp_expense_types');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;
  PROCEDURE update_company_expense_types(p_company_id             NUMBER,
                                         p_expense_type_code      VARCHAR2,
                                         p_description            VARCHAR2,
                                         p_enabled_flag           VARCHAR2,
                                         p_other_company_use_flag VARCHAR2,
                                         p_user_id                NUMBER) IS
  
    n_count NUMBER;
  BEGIN
    n_count := expense_types_count(p_expense_type_code, p_company_id);
    IF n_count > 0 THEN
      update_exp_expense_types(p_company_id        => p_company_id,
                               p_expense_type_code => p_expense_type_code,
                               p_description       => p_description,
                               p_enabled_flag      => p_enabled_flag,
                               p_last_updated_by   => p_user_id);
    
      insert_exp_types_use_flag(p_company_id             => p_company_id,
                                p_expense_type_code      => p_expense_type_code,
                                p_other_company_use_flag => p_other_company_use_flag,
                                p_user_id                => p_user_id);
    ELSE
      insert_exp_expense_types(p_company_id        => p_company_id,
                               p_expense_type_code => p_expense_type_code,
                               p_description       => p_description,
                               p_enabled_flag      => p_enabled_flag,
                               p_created_by        => p_user_id);
    
      insert_exp_types_use_flag(p_company_id             => p_company_id,
                                p_expense_type_code      => p_expense_type_code,
                                p_other_company_use_flag => p_other_company_use_flag,
                                p_user_id                => p_user_id);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'EXP_SOB_EXPENSE_TYPES_PKG',
                                                     p_procedure_function_name => 'update_company_expense_types');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;
  /**/
  PROCEDURE assign_company_expense_types(p_company_id             NUMBER,
                                         p_expense_type_code      VARCHAR2,
                                         p_description            VARCHAR2,
                                         p_enabled_flag           VARCHAR2,
                                         p_other_company_use_flag VARCHAR2,
                                         p_user_id                NUMBER,
                                         p_sob_id                 NUMBER DEFAULT NULL) IS
    --v_enabled_flag varchar2(1);
    n_count NUMBER;
    e_comp_enabled_error EXCEPTION;
    v_expense_type_id NUMBER;
    v_exist           NUMBER;
    v_enabled_flag    VARCHAR2(2);
    v_cashflow_code   VARCHAR2(100);
    v_meetting_flag   VARCHAR2(1);
    v_line_desc_flag  VARCHAR2(1);
    v_oa_sign_flag    VARCHAR2(1);
  BEGIN
    /*begin
      select 'Y'
        into v_enabled_flag
        from dual
       where exists
       (select 1
                from exp_expense_types t
               where t.company_id = p_company_id
                 and t.expense_type_code = p_expense_type_code);
    exception
      when no_data_found then
        v_enabled_flag := 'N';
    end;
    if (v_enabled_flag = 'Y') then
      raise e_comp_enabled_error;
    end if;*/
    BEGIN
      SELECT et.cashflow_code, et.meetting_flag, et.line_desc_flag,et.oa_sign_flag
        INTO v_cashflow_code, v_meetting_flag, v_line_desc_flag,v_oa_sign_flag
        FROM exp_sob_expense_types et
       WHERE et.expense_type_code = p_expense_type_code
         AND et.set_of_books_id = p_sob_id;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
  
    n_count := expense_types_count(p_expense_type_code, p_company_id);
    IF n_count > 0 THEN
      update_exp_expense_types(p_company_id        => p_company_id,
                               p_expense_type_code => p_expense_type_code,
                               p_description       => p_description,
                               p_enabled_flag      => p_enabled_flag,
                               p_last_updated_by   => p_user_id,
                               p_cashflow_code     => v_cashflow_code,
                               p_meetting_flag     => v_meetting_flag,
                               p_line_desc_flag    => v_line_desc_flag,
                               p_oa_sign_flag      => v_oa_sign_flag);
    
      insert_exp_types_use_flag(p_company_id             => p_company_id,
                                p_expense_type_code      => p_expense_type_code,
                                p_other_company_use_flag => p_other_company_use_flag,
                                p_user_id                => p_user_id);
    ELSE
      insert_exp_expense_types(p_company_id        => p_company_id,
                               p_expense_type_code => p_expense_type_code,
                               p_description       => p_description,
                               p_enabled_flag      => p_enabled_flag,
                               p_created_by        => p_user_id,
                               p_cashflow_code     => v_cashflow_code,
                               p_meetting_flag     => v_meetting_flag,
                               p_line_desc_flag    => v_line_desc_flag,
                               p_oa_sign_flag      => v_oa_sign_flag);
    
      insert_exp_types_use_flag(p_company_id             => p_company_id,
                                p_expense_type_code      => p_expense_type_code,
                                p_other_company_use_flag => p_other_company_use_flag,
                                p_user_id                => p_user_id);
      /*
        add by xuls 2012-11-28
      */
    END IF;
    IF p_sob_id IS NOT NULL THEN
      --如果传递账套进行处理
      --分配 费用项目
    
      FOR v_item IN (SELECT *
                       FROM exp_sob_type_expense_items eei
                      WHERE eei.set_of_books_id = p_sob_id
                        AND eei.expense_type_code = p_expense_type_code) LOOP
        --判断是否所在公司的该费用项目启用
        BEGIN
          SELECT ecei.enabled_flag
            INTO v_enabled_flag
            FROM exp_company_expense_items ecei
           WHERE ecei.company_id = p_company_id
             AND ecei.expense_item_id = v_item.expense_item_id;
        
        EXCEPTION
          WHEN no_data_found THEN
            /*为该公司分配新的费用项目
            add by wyd 2012-12-23*/
            exp_expense_items_pkg.insert_company_expense_items(v_item.expense_item_id,
                                                               p_company_id,
                                                               v_item.enabled_flag,
                                                               p_user_id);
          
            --第一次分配费用项目
            SELECT a.expense_type_id
              INTO v_expense_type_id
              FROM exp_expense_types a
             WHERE a.expense_type_code = p_expense_type_code
               AND a.company_id = p_company_id;
            exp_expense_items_pkg.insert_exp_expense_item_types(p_expense_item_id => v_item.expense_item_id,
                                                                p_expense_type_id => v_expense_type_id,
                                                                p_created_by      => p_user_id,
                                                                p_last_updated_by => p_user_id);
          
        END;
      
        IF v_enabled_flag = 'Y' THEN
        
          SELECT a.expense_type_id
            INTO v_expense_type_id
            FROM exp_expense_types a
           WHERE a.expense_type_code = p_expense_type_code
             AND a.company_id = p_company_id;
          --查看是否已经存在分配了的费用项目指定报销类型
          BEGIN
            SELECT 1
              INTO v_exist
              FROM dual
             WHERE EXISTS
             (SELECT 1
                      FROM exp_expense_item_types a
                     WHERE a.expense_item_id = v_item.expense_item_id
                       AND a.expense_type_id = v_expense_type_id);
            --如果不存在数据进行分配费用项目
          EXCEPTION
            WHEN no_data_found THEN
              exp_expense_items_pkg.insert_exp_expense_item_types(p_expense_item_id => v_item.expense_item_id,
                                                                  p_expense_type_id => v_expense_type_id,
                                                                  p_created_by      => p_user_id,
                                                                  p_last_updated_by => p_user_id);
          END;
        
        END IF;
      
      END LOOP;
    
      --分配 申请项目
      FOR v_req_item IN (SELECT *
                           FROM exp_sob_type_req_items eri
                          WHERE eri.set_of_books_id = p_sob_id
                            AND eri.expense_type_code = p_expense_type_code) LOOP
        --判断是否所在公司的该申请项目启用
        BEGIN
          SELECT ecri.enabled_flag
            INTO v_enabled_flag
            FROM exp_company_req_items ecri
           WHERE ecri.company_id = p_company_id
             AND ecri.req_item_id = v_req_item.req_item_id;
        EXCEPTION
          WHEN no_data_found THEN
            /*为该公司分配新的费用项目
            add by wyd 2012-12-23*/
            exp_req_items_pkg.insert_exp_company_req_items(v_req_item.req_item_id,
                                                           p_company_id,
                                                           v_req_item.enabled_flag,
                                                           p_user_id);
            --第一次分配申请项目
            SELECT a.expense_type_id
              INTO v_expense_type_id
              FROM exp_expense_types a
             WHERE a.expense_type_code = p_expense_type_code
               AND a.company_id = p_company_id;
          
            exp_req_items_pkg.insert_exp_req_item_types(p_req_item_id     => v_req_item.req_item_id,
                                                        p_expense_type_id => v_expense_type_id,
                                                        p_created_by      => p_user_id);
          
        END;
        IF v_enabled_flag = 'Y' THEN
          SELECT a.expense_type_id
            INTO v_expense_type_id
            FROM exp_expense_types a
           WHERE a.expense_type_code = p_expense_type_code
             AND a.company_id = p_company_id;
          --查看是否已经存在分配了的申请项目指定报销类型
          BEGIN
            SELECT 1
              INTO v_exist
              FROM dual
             WHERE EXISTS
             (SELECT 1
                      FROM exp_req_item_types a
                     WHERE a.req_item_id = v_req_item.req_item_id
                       AND a.expense_type_id = v_expense_type_id);
            --如果不存在数据进行分配申请项目
          EXCEPTION
            WHEN no_data_found THEN
              exp_req_items_pkg.insert_exp_req_item_types(p_req_item_id     => v_req_item.req_item_id,
                                                          p_expense_type_id => v_expense_type_id,
                                                          p_created_by      => p_user_id);
          END;
        END IF;
      END LOOP;
    END IF;
  
    /*
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
       p_created_by,
       sysdate);
    
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'EXP_EXPENSE_TYPES',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => '',
                                               p_created_by       => p_created_by,
                                               p_last_updated_by  => p_created_by,
                                               p_language_code    => userenv('lang'));*/
  EXCEPTION
    WHEN e_comp_enabled_error THEN
      --若有insert 表，捕获 唯一索引错误
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXP_COMP_ENABLED_ERROR',
                                                      p_created_by              => p_user_id,
                                                      p_package_name            => 'EXP_SOB_EXPENSE_TYPES_PKG',
                                                      p_procedure_function_name => 'assign_company_expense_types');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_user_id,
                                                     p_package_name            => 'EXP_SOB_EXPENSE_TYPES_PKG',
                                                     p_procedure_function_name => 'assign_company_expense_types');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;
  /*增加公司级费用类型*/
  PROCEDURE insert_exp_expense_types(p_company_id        NUMBER,
                                     p_expense_type_code VARCHAR2,
                                     p_description       VARCHAR2,
                                     p_enabled_flag      VARCHAR2,
                                     p_created_by        NUMBER,
                                     p_cashflow_code     VARCHAR2 DEFAULT NULL,
                                     p_meetting_flag     VARCHAR2 DEFAULT NULL,
                                     p_line_desc_flag    VARCHAR2 DEFAULT NULL,
                                     p_oa_sign_flag      VARCHAR2 DEFAULT NULL) IS
    v_expense_type_id exp_expense_types.expense_type_id%TYPE;
    v_description_id  exp_expense_types.description_id%TYPE;
  BEGIN
    v_expense_type_id := get_expense_type_id;
    v_description_id  := fnd_description_pkg.get_fnd_description_id;
  
    INSERT INTO exp_expense_types
      (expense_type_id,
       company_id,
       expense_type_code,
       description_id,
       enabled_flag,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       cashflow_code,
       meetting_flag,
       line_desc_flag,
       oa_sign_flag)
    VALUES
      (v_expense_type_id,
       p_company_id,
       upper(p_expense_type_code),
       v_description_id,
       p_enabled_flag,
       p_created_by,
       SYSDATE,
       p_created_by,
       SYSDATE,
       p_cashflow_code,
       p_meetting_flag,
       p_line_desc_flag,
       p_oa_sign_flag);
  
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => v_description_id,
                                               p_ref_table        => 'EXP_EXPENSE_TYPES',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => '',
                                               p_created_by       => p_created_by,
                                               p_last_updated_by  => p_created_by,
                                               p_language_code    => userenv('lang'));
  
  EXCEPTION
    WHEN dup_val_on_index THEN
      --若有insert 表，捕获 唯一索引错误
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'EXPENSE_TYPE_CODE_DUPLICATE',
                                                      p_created_by              => p_created_by,
                                                      p_package_name            => 'cux_exp_sob_expense_types_pkg',
                                                      p_procedure_function_name => 'insert_exp_expense_types');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_created_by,
                                                     p_package_name            => 'cux_exp_sob_expense_types_pkg',
                                                     p_procedure_function_name => 'insert_exp_expense_types');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END insert_exp_expense_types;
  /*更新帐套级费用类型*/
  PROCEDURE update_exp_sob_expense_types(p_set_books_id           NUMBER,
                                         p_expense_type_code      VARCHAR2,
                                         p_description_id         NUMBER,
                                         p_description            VARCHAR2,
                                         p_enabled_flag           VARCHAR2,
                                         p_last_updated_by        NUMBER,
                                         p_other_company_use_flag VARCHAR2,
                                         p_cashflow_code          VARCHAR2 DEFAULT NULL,
                                         p_meetting_flag          VARCHAR2 DEFAULT NULL,
                                         p_line_desc_flag         VARCHAR2 DEFAULT NULL,
                                         p_oa_sign_flag           VARCHAR2 DEFAULT NULL) IS
  BEGIN
  
    UPDATE exp_sob_expense_types e
       SET e.enabled_flag           = p_enabled_flag,
           e.last_updated_by        = p_last_updated_by,
           e.last_update_date       = SYSDATE,
           e.other_company_use_flag = p_other_company_use_flag,
           e.cashflow_code          = p_cashflow_code,
           e.meetting_flag          = p_meetting_flag,
           e.line_desc_flag         = p_line_desc_flag,
           e.oa_sign_flag           = p_oa_sign_flag
           
     WHERE e.expense_type_code = p_expense_type_code
       AND e.set_of_books_id = p_set_books_id;
  
    fnd_description_pkg.reset_fnd_descriptions(p_description_id   => p_description_id,
                                               p_ref_table        => 'EXP_SOB_EXPENSE_TYPES',
                                               p_ref_field        => 'DESCRIPTION_ID',
                                               p_description_text => p_description,
                                               p_function_name    => '',
                                               p_created_by       => p_last_updated_by,
                                               p_last_updated_by  => p_last_updated_by,
                                               p_language_code    => userenv('lang'));
    FOR c_cur IN (SELECT fc.company_id
                    FROM fnd_companies_vl         fc,
                         exp_sob_expense_types_vl ese,
                         exp_expense_types_vl     eet
                   WHERE fc.set_of_books_id = p_set_books_id
                     AND ese.set_of_books_id = fc.set_of_books_id
                     AND eet.expense_type_code = ese.expense_type_code
                     AND eet.company_id = fc.company_id
                     AND ese.expense_type_code = p_expense_type_code) LOOP
    
      update_exp_expense_types(p_company_id        => c_cur.company_id,
                               p_expense_type_code => p_expense_type_code,
                               p_description       => p_description,
                               p_enabled_flag      => p_enabled_flag,
                               p_last_updated_by   => p_last_updated_by,
                               p_cashflow_code     => p_cashflow_code,
                               p_meetting_flag     => p_meetting_flag,
                               p_line_desc_flag    => p_line_desc_flag,
                               p_oa_sign_flag      => p_oa_sign_flag);
    
    END LOOP;
  
  EXCEPTION
    WHEN OTHERS THEN
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  SQLERRM,
                                                     p_created_by              => p_last_updated_by,
                                                     p_package_name            => 'EXP_SOB_EXPENSE_TYPES_PKG',
                                                     p_procedure_function_name => 'update_exp_expense_types');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  END;

  PROCEDURE activate_assigned_company(p_expense_type_code VARCHAR2,
                                      p_expense_item_id   NUMBER,
                                      p_exp_req_item_id   NUMBER,
                                      p_set_of_books_id   NUMBER,
                                      p_description       VARCHAR2,
                                      p_enabled_flag      VARCHAR2,
                                      p_user_id           NUMBER) IS
    v_count NUMBER;
  BEGIN
  
    SELECT COUNT(*)
      INTO v_count
      FROM exp_expense_types t
     WHERE t.expense_type_code = p_expense_type_code;
  
    IF v_count = 0 THEN
      RETURN;
    END IF;
  
    FOR v_item IN (SELECT t.*
                     FROM exp_expense_types t, fnd_companies fc
                    WHERE t.expense_type_code = p_expense_type_code
                      AND fc.company_id = t.company_id
                      AND fc.set_of_books_id = p_set_of_books_id) LOOP
      assign_company_expense_types(v_item.company_id,
                                   p_expense_type_code,
                                   p_description,
                                   p_enabled_flag,
                                   NULL,
                                   p_user_id,
                                   p_set_of_books_id);
    
    END LOOP;
  
    IF p_expense_item_id IS NOT NULL THEN
      FOR v_item IN (SELECT t.*
                       FROM exp_expense_types t, fnd_companies fc
                      WHERE t.expense_type_code = p_expense_type_code
                        AND fc.company_id = t.company_id
                        AND fc.set_of_books_id = p_set_of_books_id) LOOP
      
        SELECT COUNT(*)
          INTO v_count
          FROM exp_expense_item_types t1
         WHERE t1.expense_type_id = v_item.expense_type_id
           AND t1.expense_item_id = p_expense_item_id
           AND EXISTS
         (SELECT 1
                  FROM exp_company_expense_items ei
                 WHERE ei.expense_item_id = p_expense_item_id
                   AND ei.company_id = v_item.company_id);
        IF v_count = 0 THEN
          exp_expense_items_pkg.insert_exp_expense_item_types(p_expense_item_id,
                                                              v_item.expense_type_id,
                                                              p_user_id,
                                                              p_user_id);
        END IF;
      END LOOP;
    END IF;
  
    IF p_exp_req_item_id IS NOT NULL THEN
      FOR v_item IN (SELECT t.*
                       FROM exp_expense_types t, fnd_companies fc
                      WHERE t.expense_type_code = p_expense_type_code
                        AND fc.company_id = t.company_id
                        AND fc.set_of_books_id = p_set_of_books_id) LOOP
      
        SELECT COUNT(*)
          INTO v_count
          FROM exp_req_item_types t1
         WHERE t1.expense_type_id = v_item.expense_type_id
           AND t1.req_item_id = p_exp_req_item_id
           AND EXISTS
         (SELECT 1
                  FROM exp_company_req_items ei
                 WHERE ei.req_item_id = p_exp_req_item_id
                   AND ei.company_id = v_item.company_id);
        IF v_count = 0 THEN
          exp_req_items_pkg.insert_exp_req_item_types(p_req_item_id     => p_exp_req_item_id,
                                                      p_expense_type_id => v_item.expense_type_id,
                                                      p_created_by      => p_user_id);
        END IF;
      END LOOP;
    END IF;
  
  END activate_assigned_company;

END exp_sob_expense_types_pkg;
/
