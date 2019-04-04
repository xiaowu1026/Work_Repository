create or replace package syn_sap_data_base is

  --同步sap基础数据
  procedure syn_sap_data;

  --同步sap基础数据信息至费控
  function syn_sap_data(p_event_record_id number,
                        p_event_log_id    number,
                        p_event_param     number,
                        p_user_id         number) return number;

  --同步供应商信息至sap
  function syn_venders_to_sap(p_event_record_id number,
                              p_event_log_id    number,
                              p_event_param     number,
                              p_user_id         number) return number;
end syn_sap_data_base;
/
create or replace package body syn_sap_data_base is

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

  --同步承若项目
  procedure SYN_GTCX_COA_DEFDOC is
    v_dimension_id number;
  begin
    for c1 in (select *
                 from gl_account_interface g
                where g.basedatatype = '04'
                  and g.operationtype = 'UPDATE'
                  AND g.state = 'C0'
                  and exists
                (select 1
                         from fnd_dimension_values fv
                        where fv.dimension_id =
                              (select f.dimension_id
                                 from fnd_dimensions f
                                where f.dimension_code = 'GTCX_COA_DEFDOC')
                          and fv.dimension_value_code = g.basedatacode)) loop
      select f.dimension_id
        into v_dimension_id
        from fnd_dimensions f
       where f.dimension_code = 'GTCX_COA_DEFDOC';
      if c1.flag = 'VALID' then
        --更新维值
        fnd_dimension_values_pkg.update_fnd_dimension_values(p_dimension_value_code => c1.basedatacode,
                                                             p_description          => c1.basedataname,
                                                             p_summary_flag         => 'N',
                                                             p_enabled_flag         => 'Y',
                                                             p_last_updated_by      => 1,
                                                             p_language_code        => userenv('LANG'),
                                                             p_dimension_id         => v_dimension_id);
      else
        --失效
        UPDATE fnd_dimension_values f
           SET f.enabled_flag     = 'N',
               f.last_update_date = SYSDATE,
               f.last_updated_by  = 1
         WHERE f.dimension_value_code = c1.basedatacode
           AND f.dimension_id = v_dimension_id;
      end if;
    
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c1.pk_serialno;
    end loop;
  
    for c2 in (select *
                 from gl_account_interface g
                where g.basedatatype = '04'
                  and g.operationtype = 'CREATE'
                  and g.flag = 'VALID' --有效
                  AND g.state = 'C0'
                  and not exists
                (select 1
                         from fnd_dimension_values fv
                        where fv.dimension_id =
                              (select f.dimension_id
                                 from fnd_dimensions f
                                where f.dimension_code = 'GTCX_COA_DEFDOC')
                          and fv.dimension_value_code = g.basedatacode)) loop
    
      --新增维值    
      fnd_data_load_pkg.load_dimension_values(p_dimension_code       => 'GTCX_COA_DEFDOC',
                                              p_dimension_value_code => c2.basedatacode,
                                              p_description          => c2.basedataname,
                                              p_summary_flag         => 'N',
                                              p_enabled_flag         => 'Y');
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c2.pk_serialno;
    end loop;
  end SYN_GTCX_COA_DEFDOC;

  --同步核算科目
  PROCEDURE SYN_ACCOUNT IS
    v_account_id    number;
    v_account_type  varchar2(1);
    v_account_type1 varchar2(10);
    v_account_type2 varchar2(10);
  BEGIN
    for c1 in (select *
                 from gl_account_interface g
                where g.basedatatype = '03'
                  and g.operationtype = 'UPDATE'
                  AND g.state = 'C0'
                  and exists
                (select 1
                         from gld_accounts ga
                        where ga.account_code = g.basedatacode)) loop
    
      if c1.flag = 'VALID' then
      
        select ga.account_id, ga.account_type
          into v_account_id, v_account_type
          from gld_accounts ga
         where ga.account_code = c1.basedatacode;
      
        --更新科目
        GLD_ACCOUNT_PKG.update_gld_account(p_account_id      => v_account_id,
                                           p_description     => c1.basedataname,
                                           p_account_type    => v_account_type,
                                           p_enabled_flag    => 'Y',
                                           p_summary_flag    => 'N',
                                           p_created_by      => 1,
                                           p_last_updated_by => 1);
      else
        --失效科目
        GLD_ACCOUNT_PKG.update_gld_account(p_account_id      => v_account_id,
                                           p_description     => c1.basedataname,
                                           p_account_type    => v_account_type,
                                           p_enabled_flag    => 'N',
                                           p_summary_flag    => 'N',
                                           p_created_by      => 1,
                                           p_last_updated_by => 1);
      end if;
    
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c1.pk_serialno;
    end loop;
  
    for c2 in (select *
                 from gl_account_interface g
                where g.basedatatype = '03'
                  and g.operationtype = 'CREATE'
                  and g.flag = 'VALID' --有效
                  AND g.state = 'C0'
                  and not exists
                (select 1
                         from gld_accounts ga
                        where ga.account_code = g.basedatacode)) loop
    
      select substr(c2.basedatacode, 1, 1), substr(c2.basedatacode, 1, 2)
        into v_account_type1, v_account_type2
        from dual;
    
      if v_account_type1 = '1' then
        --资产类
        v_account_type := 'A';
      elsif v_account_type1 = '2' then
        --负债类
        v_account_type := 'L';
      elsif v_account_type1 = '4' then
        --权益类
        v_account_type := 'O';
      else
        if v_account_type2 in ('60', '61', '62', '63') then
          --收入类
          v_account_type := 'R';
        elsif v_account_type2 in ('64', '65', '66', '67', '68', '69') then
          --费用类
          v_account_type := 'E';
        end if;
      end if;
    
      --新增科目
      fnd_data_load_pkg.load_account(p_account_set_code => 'GRCX_ACCOUNT',
                                     p_account_code     => c2.basedatacode,
                                     p_description      => c2.basedataname,
                                     p_account_type     => v_account_type,
                                     p_enabled_flag     => 'Y',
                                     p_summary_flag     => 'N');
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c2.pk_serialno;
    end loop;
  END SYN_ACCOUNT;

  --同步险类1
  procedure SYN_GTCX_COA_DEFDOC01 is
    v_dimension_id number;
  begin
    for c1 in (select *
                 from gl_account_interface g
                where g.basedatatype = '09'
                  and g.operationtype = 'UPDATE'
                  AND g.state = 'C0'
                  and exists
                (select 1
                         from fnd_dimension_values fv
                        where fv.dimension_id =
                              (select f.dimension_id
                                 from fnd_dimensions f
                                where f.dimension_code = 'GTCX_COA_DEFDOC01')
                          and fv.dimension_value_code = g.basedatacode)) loop
      select f.dimension_id
        into v_dimension_id
        from fnd_dimensions f
       where f.dimension_code = 'GTCX_COA_DEFDOC01';
    
      if c1.flag = 'VALID' then
        --更新维值
        fnd_dimension_values_pkg.update_fnd_dimension_values(p_dimension_value_code => c1.basedatacode,
                                                             p_description          => c1.basedataname,
                                                             p_summary_flag         => 'N',
                                                             p_enabled_flag         => 'Y',
                                                             p_last_updated_by      => 1,
                                                             p_language_code        => userenv('LANG'),
                                                             p_dimension_id         => v_dimension_id);
      else
        --失效
        UPDATE fnd_dimension_values f
           SET f.enabled_flag     = 'N',
               f.last_update_date = SYSDATE,
               f.last_updated_by  = 1
         WHERE f.dimension_value_code = c1.basedatacode
           AND f.dimension_id = v_dimension_id;
      end if;
    
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c1.pk_serialno;
    end loop;
  
    for c2 in (select *
                 from gl_account_interface g
                where g.basedatatype = '09'
                  and g.operationtype = 'CREATE'
                  and g.flag = 'VALID' --有效
                  AND g.state = 'C0'
                  and not exists
                (select 1
                         from fnd_dimension_values fv
                        where fv.dimension_id =
                              (select f.dimension_id
                                 from fnd_dimensions f
                                where f.dimension_code = 'GTCX_COA_DEFDOC01')
                          and fv.dimension_value_code = g.basedatacode)) loop
    
      --新增维值    
      fnd_data_load_pkg.load_dimension_values(p_dimension_code       => 'GTCX_COA_DEFDOC01',
                                              p_dimension_value_code => c2.basedatacode,
                                              p_description          => c2.basedataname,
                                              p_summary_flag         => 'N',
                                              p_enabled_flag         => 'Y');
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c2.pk_serialno;
    end loop;
  end SYN_GTCX_COA_DEFDOC01;

  --同步业务来源(渠道)
  PROCEDURE SYN_GTCX_COA_BUSISOURCE IS
    v_dimension_id number;
  begin
    for c1 in (select *
                 from gl_account_interface g
                where g.basedatatype = '11'
                  and g.operationtype = 'UPDATE'
                  AND g.state = 'C0'
                  and exists
                (select 1
                         from fnd_dimension_values fv
                        where fv.dimension_id =
                              (select f.dimension_id
                                 from fnd_dimensions f
                                where f.dimension_code = 'GTCX_COA_BUSISOURCE')
                          and fv.dimension_value_code = g.basedatacode)) loop
      select f.dimension_id
        into v_dimension_id
        from fnd_dimensions f
       where f.dimension_code = 'GTCX_COA_BUSISOURCE';
    
      if c1.flag = 'VALID' then
        --更新维值
        fnd_dimension_values_pkg.update_fnd_dimension_values(p_dimension_value_code => c1.basedatacode,
                                                             p_description          => c1.basedataname,
                                                             p_summary_flag         => 'N',
                                                             p_enabled_flag         => 'Y',
                                                             p_last_updated_by      => 1,
                                                             p_language_code        => userenv('LANG'),
                                                             p_dimension_id         => v_dimension_id);
      else
        --失效
        UPDATE fnd_dimension_values f
           SET f.enabled_flag     = 'N',
               f.last_update_date = SYSDATE,
               f.last_updated_by  = 1
         WHERE f.dimension_value_code = c1.basedatacode
           AND f.dimension_id = v_dimension_id;
      end if;
    
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c1.pk_serialno;
    
    end loop;
  
    for c2 in (select *
                 from gl_account_interface g
                where g.basedatatype = '11'
                  and g.operationtype = 'CREATE'
                  and g.flag = 'VALID' --有效
                  AND g.state = 'C0'
                  and not exists
                (select 1
                         from fnd_dimension_values fv
                        where fv.dimension_id =
                              (select f.dimension_id
                                 from fnd_dimensions f
                                where f.dimension_code = 'GTCX_COA_BUSISOURCE')
                          and fv.dimension_value_code = g.basedatacode)) loop
    
      --新增维值    
      fnd_data_load_pkg.load_dimension_values(p_dimension_code       => 'GTCX_COA_BUSISOURCE',
                                              p_dimension_value_code => c2.basedatacode,
                                              p_description          => c2.basedataname,
                                              p_summary_flag         => 'N',
                                              p_enabled_flag         => 'Y');
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c2.pk_serialno;
    end loop;
  END SYN_GTCX_COA_BUSISOURCE;

  --同步基金中心
  procedure SYN_GTCX_COA_DEPTDOC02 is
    v_dimension_id number;
  begin
    for c1 in (select *
                 from gl_account_interface g
                where g.basedatatype = '12'
                  and g.operationtype = 'UPDATE'
                  AND g.state = 'C0'
                  and exists
                (select 1
                         from fnd_dimension_values fv
                        where fv.dimension_id =
                              (select f.dimension_id
                                 from fnd_dimensions f
                                where f.dimension_code = 'GTCX_COA_DEPTDOC02')
                          and fv.dimension_value_code = g.basedatacode)) loop
      select f.dimension_id
        into v_dimension_id
        from fnd_dimensions f
       where f.dimension_code = 'GTCX_COA_DEPTDOC02';
      if c1.flag = 'VALID' then
        --更新维值
        fnd_dimension_values_pkg.update_fnd_dimension_values(p_dimension_value_code => c1.basedatacode,
                                                             p_description          => c1.basedataname,
                                                             p_summary_flag         => 'N',
                                                             p_enabled_flag         => 'Y',
                                                             p_last_updated_by      => 1,
                                                             p_language_code        => userenv('LANG'),
                                                             p_dimension_id         => v_dimension_id);
      else
        --失效
        UPDATE fnd_dimension_values f
           SET f.enabled_flag     = 'N',
               f.last_update_date = SYSDATE,
               f.last_updated_by  = 1
         WHERE f.dimension_value_code = c1.basedatacode
           AND f.dimension_id = v_dimension_id;
      end if;
    
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c1.pk_serialno;
    end loop;
  
    for c2 in (select *
                 from gl_account_interface g
                where g.basedatatype = '12'
                  and g.operationtype = 'CREATE'
                  and g.flag = 'VALID' --有效
                  AND g.state = 'C0'
                  and not exists
                (select 1
                         from fnd_dimension_values fv
                        where fv.dimension_id =
                              (select f.dimension_id
                                 from fnd_dimensions f
                                where f.dimension_code = 'GTCX_COA_DEPTDOC02')
                          and fv.dimension_value_code = g.basedatacode)) loop
    
      --新增维值    
      fnd_data_load_pkg.load_dimension_values(p_dimension_code       => 'GTCX_COA_DEPTDOC02',
                                              p_dimension_value_code => c2.basedatacode,
                                              p_description          => c2.basedataname,
                                              p_summary_flag         => 'N',
                                              p_enabled_flag         => 'Y');
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c2.pk_serialno;
    end loop;
  end SYN_GTCX_COA_DEPTDOC02;

  --同步成本中心
  procedure SYN_RESP_CENTER is
    v_resp_centers fnd_set_book_resp_centers%rowtype;
  begin
    for c1 in (select *
                 from gl_account_interface g
                where g.basedatatype = '02'
                  and g.operationtype = 'UPDATE'
                  AND g.state = 'C0'
                  and exists
                (select 1
                         from fnd_set_book_resp_centers fv
                        where fv.responsibility_center_code = g.basedatacode)) loop
    
      select f.*
        into v_resp_centers
        from fnd_set_book_resp_centers f
       where f.responsibility_center_code = c1.basedatacode;
    
      if c1.flag = 'VALID' then
        --更新
        fnd_responsibility_center_pkg.update_fnd_set_book_resp_cen(p_responsibility_center_name => c1.basedataname,
                                                                   p_res_center_name_id         => v_resp_centers.responsibility_center_name_id,
                                                                   p_resp_center_type_code      => v_resp_centers.resp_center_type_code,
                                                                   p_start_date_active          => v_resp_centers.start_date_active,
                                                                   p_end_date_active            => v_resp_centers.end_date_active,
                                                                   p_created_by                 => 1,
                                                                   p_last_updated_by            => 1,
                                                                   p_responsibility_center_id   => v_resp_centers.responsibility_center_id);
      else
        --失效
        fnd_responsibility_center_pkg.update_fnd_set_book_resp_cen(p_responsibility_center_name => c1.basedataname,
                                                                   p_res_center_name_id         => v_resp_centers.responsibility_center_name_id,
                                                                   p_resp_center_type_code      => v_resp_centers.resp_center_type_code,
                                                                   p_start_date_active          => v_resp_centers.start_date_active,
                                                                   p_end_date_active            => sysdate,
                                                                   p_created_by                 => 1,
                                                                   p_last_updated_by            => 1,
                                                                   p_responsibility_center_id   => v_resp_centers.responsibility_center_id);
      end if;
    
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c1.pk_serialno;
    end loop;
  
    for c2 in (select *
                 from gl_account_interface g
                where g.basedatatype = '02'
                  and g.Operationtype = 'CREATE'
                  and g.flag = 'VALID' --有效
                  AND g.state = 'C0'
                  and not exists
                (select 1
                         from fnd_set_book_resp_centers fv
                        where fv.responsibility_center_code = g.basedatacode)) loop
    
      --新增维值    
      fnd_data_load_pkg.load_fnd_set_book_resp_cen(p_set_of_books_code          => 'GRCX_LEDGER',
                                                   p_responsibility_center_code => C2.basedatacode,
                                                   p_responsibility_center_name => C2.basedataname,
                                                   p_resp_center_type_code      => 'C',
                                                   p_start_date_active          => '2018-10-22',
                                                   p_end_date_active            => '',
                                                   p_summary_flag               => 'N');
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c2.pk_serialno;
    end loop;
  
  end SYN_RESP_CENTER;

  --同步现金流量项
  PROCEDURE SYN_CASH_FLOW_ITEMS is
    v_set_of_books_id       number;
    v_cash_flow_item_id     number;
    v_count                 number;
    v_cash_flow_line_number number;
    v_flow_items            csh_cash_flow_items%rowtype;
  begin
    for c1 in (select *
                 from gl_account_interface g
                where g.basedatatype = '07'
                  and g.operationtype = 'UPDATE'
                  AND g.state = 'C0'
                  and exists
                (select 1
                         from csh_cash_flow_items c
                        where c.csh_cash_flow_items_code = g.basedatacode)) loop
    
      select c.*
        into v_flow_items
        from csh_cash_flow_items c
       where c.csh_cash_flow_items_code = c1.basedatacode;
    
      if c1.flag = 'VALID' then
        --更新现金流量项
        csh_cash_flow_items_pkg.update_csh_cash_flow_items(p_cash_flow_line_number    => v_flow_items.cash_flow_line_number,
                                                           p_description              => c1.basedataname,
                                                           p_cash_flow_item_type      => 'ACCOUNT',
                                                           p_indent                   => '10',
                                                           p_orientation              => 'IN',
                                                           p_visible_flag             => 'Y',
                                                           p_cash_flow_item_id        => v_flow_items.cash_flow_item_id,
                                                           p_csh_cash_flow_items_code => c1.basedatacode,
                                                           p_user_id                  => 1);
      ELSE
        --失效
        UPDATE csh_cash_flow_items c
           set c.visible_flag     = 'N',
               c.last_update_date = sysdate,
               c.last_updated_by  = 1
         where c.csh_cash_flow_items_code = c1.basedatacode;
      end if;
    
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c1.pk_serialno;
    end loop;
  
    for c2 in (select *
                 from gl_account_interface g
                where g.basedatatype = '07'
                  and g.operationtype = 'CREATE'
                  and g.flag = 'VALID' --有效
                  AND g.state = 'C0'
                  and not exists
                (select 1
                         from csh_cash_flow_items c
                        where c.csh_cash_flow_items_code = g.basedatacode)) loop
    
      select gl.set_of_books_id
        into v_set_of_books_id
        FROM gld_set_of_books gl
       where gl.set_of_books_code = 'GRCX_LEDGER';
    
      select count(*) into v_count from csh_cash_flow_items;
    
      if v_count = 0 then
        v_cash_flow_line_number := 1;
      else
        select max(to_number(c.cash_flow_line_number)) + 1
          into v_cash_flow_line_number
          from csh_cash_flow_items c;
      end if;
    
      --新增现金流量项
      csh_cash_flow_items_pkg.insert_csh_cash_flow_items(p_cash_flow_line_number    => to_char(v_cash_flow_line_number),
                                                         p_description              => c2.basedataname,
                                                         p_cash_flow_item_type      => 'ACCOUNT',
                                                         p_indent                   => '10',
                                                         p_orientation              => 'IN',
                                                         p_visible_flag             => 'Y',
                                                         p_user_id                  => 1,
                                                         p_set_of_book_id           => v_set_of_books_id,
                                                         p_cash_flow_item_id        => v_cash_flow_item_id,
                                                         p_csh_cash_flow_items_code => c2.basedatacode);
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c2.pk_serialno;
    end loop;
  end SYN_CASH_FLOW_ITEMS;

  --同步险种
  PROCEDURE SYN_GTCX_COA_INSURANCEKIND is
    v_dimension_id number;
  begin
    for c1 in (select *
                 from gl_account_interface g
                where g.basedatatype = '08'
                  and g.operationtype = 'UPDATE'
                  AND g.state = 'C0'
                  and exists
                (select 1
                         from fnd_dimension_values fv
                        where fv.dimension_id =
                              (select f.dimension_id
                                 from fnd_dimensions f
                                where f.dimension_code =
                                      'GTCX_COA_INSURANCEKIND')
                          and fv.dimension_value_code = g.basedatacode)) loop
      select f.dimension_id
        into v_dimension_id
        from fnd_dimensions f
       where f.dimension_code = 'GTCX_COA_INSURANCEKIND';
    
      if c1.flag = 'VALID' then
        --更新维值
        fnd_dimension_values_pkg.update_fnd_dimension_values(p_dimension_value_code => c1.basedatacode,
                                                             p_description          => c1.basedataname,
                                                             p_summary_flag         => 'N',
                                                             p_enabled_flag         => 'Y',
                                                             p_last_updated_by      => 1,
                                                             p_language_code        => userenv('LANG'),
                                                             p_dimension_id         => v_dimension_id);
      else
        --失效
        UPDATE fnd_dimension_values f
           SET f.enabled_flag     = 'N',
               f.last_update_date = SYSDATE,
               f.last_updated_by  = 1
         WHERE f.dimension_value_code = c1.basedatacode
           AND f.dimension_id = v_dimension_id;
      end if;
    
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c1.pk_serialno;
    end loop;
  
    for c2 in (select *
                 from gl_account_interface g
                where g.basedatatype = '08'
                  and g.operationtype = 'CREATE'
                  and g.flag = 'VALID' --有效
                  AND g.state = 'C0'
                  and not exists
                (select 1
                         from fnd_dimension_values fv
                        where fv.dimension_id =
                              (select f.dimension_id
                                 from fnd_dimensions f
                                where f.dimension_code =
                                      'GTCX_COA_INSURANCEKIND')
                          and fv.dimension_value_code = g.basedatacode)) loop
    
      --新增维值    
      fnd_data_load_pkg.load_dimension_values(p_dimension_code       => 'GTCX_COA_INSURANCEKIND',
                                              p_dimension_value_code => c2.basedatacode,
                                              p_description          => c2.basedataname,
                                              p_summary_flag         => 'N',
                                              p_enabled_flag         => 'Y');
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c2.pk_serialno;
    end loop;
  end SYN_GTCX_COA_INSURANCEKIND;

  --同步专属费用标识
  PROCEDURE SYN_GTCX_COA_DEFDOC02 is
    v_dimension_id number;
  begin
    for c1 in (select *
                 from gl_account_interface g
                where g.basedatatype = '10'
                  and g.operationtype = 'UPDATE'
                  AND g.state = 'C0'
                  and exists
                (select 1
                         from fnd_dimension_values fv
                        where fv.dimension_id =
                              (select f.dimension_id
                                 from fnd_dimensions f
                                where f.dimension_code = 'GTCX_COA_DEFDOC02')
                          and fv.dimension_value_code = g.basedatacode)) loop
      select f.dimension_id
        into v_dimension_id
        from fnd_dimensions f
       where f.dimension_code = 'GTCX_COA_DEFDOC02';
    
      if c1.flag = 'VALID' then
        --更新维值
        fnd_dimension_values_pkg.update_fnd_dimension_values(p_dimension_value_code => c1.basedatacode,
                                                             p_description          => c1.basedataname,
                                                             p_summary_flag         => 'N',
                                                             p_enabled_flag         => 'Y',
                                                             p_last_updated_by      => 1,
                                                             p_language_code        => userenv('LANG'),
                                                             p_dimension_id         => v_dimension_id);
      else
        --失效
        UPDATE fnd_dimension_values f
           SET f.enabled_flag     = 'N',
               f.last_update_date = SYSDATE,
               f.last_updated_by  = 1
         WHERE f.dimension_value_code = c1.basedatacode
           AND f.dimension_id = v_dimension_id;
      end if;
    
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c1.pk_serialno;
    end loop;
  
    for c2 in (select *
                 from gl_account_interface g
                where g.basedatatype = '10'
                  and g.operationtype = 'CREATE'
                  and g.flag = 'VALID' --有效
                  AND g.state = 'C0'
                  and not exists
                (select 1
                         from fnd_dimension_values fv
                        where fv.dimension_id =
                              (select f.dimension_id
                                 from fnd_dimensions f
                                where f.dimension_code = 'GTCX_COA_DEFDOC02')
                          and fv.dimension_value_code = g.basedatacode)) loop
    
      --新增维值    
      fnd_data_load_pkg.load_dimension_values(p_dimension_code       => 'GTCX_COA_DEFDOC02',
                                              p_dimension_value_code => c2.basedatacode,
                                              p_description          => c2.basedataname,
                                              p_summary_flag         => 'N',
                                              p_enabled_flag         => 'Y');
    
      update gl_account_interface g
         set g.state = 'C9' --已处理
       where g.pk_serialno = c2.pk_serialno;
    end loop;
  end SYN_GTCX_COA_DEFDOC02;

  procedure syn_sap_data is
    v_job_id    NUMBER;
    v_error_msg VARCHAR2(2000);
  BEGIN
    sch_log('同步sap基础数据同步开始 ');
    BEGIN
    
      --同步承若项目
      SYN_GTCX_COA_DEFDOC;
    
      --同步核算科目
      SYN_ACCOUNT;
    
      --同步险类1
      SYN_GTCX_COA_DEFDOC01;
    
      --同步业务来源(渠道)
      SYN_GTCX_COA_BUSISOURCE;
    
      --同步基金中心
      SYN_GTCX_COA_DEPTDOC02;
    
      --同步成本中心
      SYN_RESP_CENTER;
    
      --同步现金流量项
      SYN_CASH_FLOW_ITEMS;
    
      --同步险种
      SYN_GTCX_COA_INSURANCEKIND;
    
      --专属费用标识
      SYN_GTCX_COA_DEFDOC02;
    EXCEPTION
      WHEN OTHERS THEN
        sys_raise_app_error_pkg.get_sys_raise_app_error(sys_raise_app_error_pkg.g_err_line_id,
                                                        v_error_msg);
        sch_log('同步sap基础数据同步出错 :' || v_error_msg);
    END;
    sch_log('同步sap基础数据同步结束');
  end syn_sap_data;

  --同步sap基础数据信息至费控
  function syn_sap_data(p_event_record_id number,
                        p_event_log_id    number,
                        p_event_param     number,
                        p_user_id         number) return number is
  begin
    --同步承若项目
    SYN_GTCX_COA_DEFDOC();
  
    --同步核算科目
    SYN_ACCOUNT();
  
    --同步险类1
    SYN_GTCX_COA_DEFDOC01();
  
    --同步业务来源(渠道)
    SYN_GTCX_COA_BUSISOURCE();
  
    --同步基金中心
    SYN_GTCX_COA_DEPTDOC02();
  
    --同步成本中心
    SYN_RESP_CENTER();
  
    --同步现金流量项
    SYN_CASH_FLOW_ITEMS();
  
    --同步险种
    SYN_GTCX_COA_INSURANCEKIND;
  
    --专属费用标识
    SYN_GTCX_COA_DEFDOC02;
    return 1;
  end syn_sap_data;

  procedure syn_venders is
    v_count number;
    v_ZLFB1 ZLFB1%rowtype;
    v_AKONT varchar2(10);
  begin
    for c1 in (select pv.*,
                      (select pvt.vender_type_code
                         from pur_vender_types pvt
                        where pvt.vender_type_id = pv.vender_type_id) vender_type_code,
                      (select a.description_text
                         from fnd_descriptions a
                        where a.description_id = pv.description_id
                          and a.language = 'ZHS') vender_name
                 from PUR_SYSTEM_VENDERS pv
               /*where pv.transstatus in ('0', '4')*/ --待传sap
               /*and not exists
               (select 1
                        from ZLFB1 z
                       where z.ktokk =
                             (select pvt.vender_type_code
                                from pur_vender_types pvt
                               where pvt.vender_type_id = pv.vender_type_id)
                         and z.LIFNR = pv.vender_code)*/
               ) loop
      if c1.vender_type_code <> 'ZV20' then
        select count(*)
          into v_count
          from ZLFB1 z
         where z.ktokk =
               (select pvt.vender_type_code
                  from pur_vender_types pvt
                 where pvt.vender_type_id = c1.vender_type_id)
           and z.LIFNR = c1.vender_code;
      
        if c1.vender_type_code = 'ZV04' then
          v_AKONT := '2241040000';
        elsif c1.vender_type_code = 'ZV10' then
          v_AKONT := '2241040000';
        elsif c1.vender_type_code = 'ZV11' then
          v_AKONT := '2241050000';
        end if;
      
        if v_count = 0 then
          insert into ZLFB1
            (MANDT,
             KTOKK,
             LIFNR,
             BUKRS,
             ANRED,
             NAME1,
             SORTL,
             NAME2,
             LAND1,
             AKONT,
             ZUAWA,
             TEL_NUMBER,
             TEL_EXTENS,
             FAX_NUMBER,
             FAX_EXTENS,
             PERNR,
             SPERR,
             LOEVM,
             REMARK,
             TRANSDATE,
             TRANSSTATUS,
             OPERDATE)
          values
            ('800', --客户端
             c1.vender_type_code, --帐户组
             c1.vender_code, --供应商代码
             '1000', --默认总公司
             decode(c1.vender_type_code,
                    'ZV04',
                    '公司',
                    'ZV10',
                    '公司',
                    'ZV11',
                    '员工'), --标题
             substrb(c1.vender_name, 1, 40), --供应商全称
             substrb(c1.vender_name, 1, 20), --供应商简称
             substrb(c1.vender_name, 40), --名称 2
             'CN', --国家代码
             v_AKONT, --统驭科目
             '012', --排序码
             '', --电话号码
             '', --分机号
             '', --传真号码
             '', --分机号
             '', --人员编号
             '', --冻结记账标识 默认为空，X为冻结
             '', --删除标识  默认为空，X为删
             '', --备注 
             to_char(sysdate, 'yyyymmdd'), --插入日期  YYYYMMDD
             '1', --数据状态
             '');
        
          update PUR_SYSTEM_VENDERS pv
             set pv.transstatus      = '1', --待接收
                 pv.last_updated_by  = 1,
                 pv.last_update_date = sysdate
           where pv.vender_id = c1.vender_id;
        else
          select z.*
            into v_ZLFB1
            from ZLFB1 z
           where z.ktokk =
                 (select pvt.vender_type_code
                    from pur_vender_types pvt
                   where pvt.vender_type_id = c1.vender_type_id)
             and z.LIFNR = c1.vender_code;
        
          if v_ZLFB1.Transstatus = '4' then
            if v_ZLFB1.LIFNR = c1.vender_code and
               v_ZLFB1.NAME1 || v_ZLFB1.name2 = c1.vender_name then
              update PUR_SYSTEM_VENDERS pv
                 set pv.transstatus      = '4', --校验错误
                     pv.remark           = v_ZLFB1.Remark,
                     pv.last_updated_by  = 1,
                     pv.last_update_date = sysdate
               where pv.vender_id = c1.vender_id;
            else
              update ZLFB1 z
                 set z.NAME1       = substrb(c1.vender_name, 1, 40),
                     z.name2       = substrb(c1.vender_name, 40),
                     z.SORTL       = substrb(c1.vender_name, 1, 20),
                     z.transdate   = to_char(sysdate, 'yyyymmdd'),
                     z.Remark      = '',
                     z.transstatus = '5' --错误校正
               where z.LIFNR = c1.vender_code;
            
              update PUR_SYSTEM_VENDERS pv
                 set pv.transstatus      = '1', --待接收
                     pv.remark           = '',
                     pv.last_updated_by  = 1,
                     pv.last_update_date = sysdate
               where pv.vender_id = c1.vender_id;
            end if;
          elsif v_ZLFB1.Transstatus = '3' then
            --成功
            update PUR_SYSTEM_VENDERS pv
               set pv.transstatus      = '3',
                   pv.remark           = v_ZLFB1.Remark,
                   pv.last_updated_by  = 1,
                   pv.last_update_date = sysdate
             where pv.vender_id = c1.vender_id;
          
          end if;
        end if;
      end if;
    end loop;
  end syn_venders;

  --同步供应商信息至sap
  function syn_venders_to_sap(p_event_record_id number,
                              p_event_log_id    number,
                              p_event_param     number,
                              p_user_id         number) return number is
  begin
    syn_venders();
    return 1;
  end syn_venders_to_sap;
end syn_sap_data_base;
/
