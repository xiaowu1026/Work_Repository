create or replace package CORE_SYNC_PKG is

  -- Author  : PENG
  -- Created : 2018/11/11 15:59:14
  -- Purpose : 核心系统同步销售人员的组织架构、员工信息、预算项目、预算期间、预算金额等信息至费控

  c_return_success   CONSTANT VARCHAR2(10) := 'success'; -- 同步返回码：处理成功
  c_return_fail      CONSTANT VARCHAR2(10) := 'fail'; -- 同步返回码：处理失败
  c_return_exception CONSTANT VARCHAR2(10) := 'exception'; -- 同步返回码：处理异常

  --插入日志
  procedure insert_sync_core_logs(p_log_desc CLOB, p_title_desc varchar2);

  --核心同步
  procedure core_sync(p_request_xml  clob,
                      p_response_xml out varchar2,
                      p_success      out varchar2);
end CORE_SYNC_PKG;
/
create or replace package body CORE_SYNC_PKG is

  parent_unit_not_exist_error EXCEPTION;
  procedure insert_sync_core_logs(p_log_desc CLOB, p_title_desc varchar2) is
    PRAGMA AUTONOMOUS_TRANSACTION;
  begin
    insert into sync_core_logs
      (log_id, log_desc, title_desc, creation_date, created_by)
    values
      (sync_core_logs_s.nextval, p_log_desc, p_title_desc, sysdate, 1);
    commit;
  end insert_sync_core_logs;

  --生成预算日记账
  procedure create_bgt_journal is
    v_user_id                  number;
    v_employee_id              number;
    v_position_id              number;
    v_company_id               number;
    v_bgt_journal_headers_id   number;
    v_bgt_journal_type_id      number; --预算类型
    v_bgt_org_id               number; --预算组织
    v_budget_structure_id      number; --预算表
    v_scenario_id              number;
    v_period_year              number;
    v_quarter_num              number;
    v_period_num               number;
    v_version_id               number; --预算版本
    v_budget_item_id           number; --预算项目
    v_journal_line_id          number;
    v_dimension9_value_id      number; --专属标识
    v_dimension4_value_id      number; --渠道
    v_responsibility_center_id number;
  begin
    for c1 in (select c.batch_id, c.data_type, c.attribute1
                 from core_sync_interface c
                where c.data_type = '04' --销售费用
                  and c.read_status = '0'
                group by c.batch_id, c.data_type, c.attribute1) loop
    
      select f.company_id
        into v_company_id
        from fnd_companies f
       where f.company_code = c1.attribute1;
    
      select s.user_id, s.employee_id
        into v_user_id, v_employee_id
        from sys_user s
       where s.user_name = 'ADMIN';
    
      select e.position_id
        into v_position_id
        from exp_employee_assigns e
       where e.employee_id = v_employee_id
         and e.primary_position_flag = 'Y';
    
      select t.BGT_JOURNAL_TYPE_ID, t.BGT_ORG_ID
        into v_bgt_journal_type_id, v_bgt_org_id
        from BGT_JOURNAL_TYPES_VL t
       where t.BGT_JOURNAL_TYPE_CODE = 'BGT_40';
    
      --预算表
      select t.budget_structure_id
        into v_budget_structure_id
        from BGT_BUDGET_STRUCTURES t
       where t.budget_strc_code = 'GRCX_BGT_XS';
    
      --预算场景
      select bg.scenario_id
        into v_scenario_id
        from bgt_scenarios bg
       where bg.scenario_code = 'GRCX_BGT_SCENE';
    
      --预算版本
      select b.version_id
        into v_version_id
        from bgt_versions b
       where b.version_code = 'GRCX_BGT_VERSION';
    
      select b.bgt_period_year, b.bgt_quarter_num, b.bgt_period_num
        into v_period_year, v_quarter_num, v_period_num
        from BGT_PERIODS b
       where b.bgt_period_set_code = 'BUDGET_PERIODS'
         and b.period_name = to_char(sysdate, 'yyyy-mm');
    
      v_bgt_journal_headers_id := bgt_journal_headers_s.nextval;
    
      --插入头
      bgt_journal_pkg.insert_bgt_journal_headers(v_bgt_journal_headers_id,
                                                 v_company_id,
                                                 '',
                                                 v_bgt_org_id,
                                                 v_budget_structure_id,
                                                 v_period_year,
                                                 v_quarter_num,
                                                 to_char(sysdate, 'yyyy-mm'),
                                                 v_period_num,
                                                 '',
                                                 v_scenario_id,
                                                 v_version_id,
                                                 'APPROVED',
                                                 v_user_id,
                                                 '',
                                                 '',
                                                 '',
                                                 v_bgt_journal_type_id,
                                                 v_employee_id,
                                                 v_position_id);
    
      for c2 in (select c.*
                   from core_sync_interface c
                  where c.data_type = '04' --销售费用
                    and c.read_status = '0'
                    and c.batch_id = c1.batch_id
                    and c.attribute1 = c1.attribute1) loop
      
        select b.bgt_period_year, b.bgt_quarter_num, b.bgt_period_num
          into v_period_year, v_quarter_num, v_period_num
          from BGT_PERIODS b
         where b.bgt_period_set_code = 'BUDGET_PERIODS'
           and b.period_name = c2.attribute5;
      
        select f.company_id
          into v_company_id
          from fnd_companies f
         where f.company_code = c2.attribute2;
      
        select u.responsibility_center_id
          into v_responsibility_center_id
          from exp_org_unit u
         where u.unit_code = c2.attribute3;
      
        select i.budget_item_id
          into v_budget_item_id
          from bgt_budget_items i
         where i.budget_item_code = c2.attribute4;
      
        --专属标识
        select fv.dimension_value_id
          into v_dimension9_value_id
          from fnd_dimension_values fv, fnd_dimensions fd
         where fv.dimension_id = fd.dimension_id
           and fv.dimension_value_code = c2.attribute7
           and fd.dimension_code = 'GTCX_COA_DEFDOC02';
      
        --渠道
        select fv.dimension_value_id
          into v_dimension4_value_id
          from fnd_dimension_values fv, fnd_dimensions fd
         where fv.dimension_id = fd.dimension_id
           and fv.dimension_value_code = c2.attribute8
           and fd.dimension_code = 'GTCX_COA_BANKDOC01';
      
        --插入行
        bgt_journal_pkg.insert_bgt_journal_lines(v_bgt_journal_headers_id,
                                                 v_responsibility_center_id,
                                                 v_budget_item_id,
                                                 v_budget_structure_id,
                                                 c2.attribute5,
                                                 v_quarter_num,
                                                 v_period_year,
                                                 v_period_num,
                                                 'CNY',
                                                 '',
                                                 '',
                                                 1,
                                                 to_number(c2.attribute6),
                                                 to_number(c2.attribute6),
                                                 1,
                                                 '',
                                                 v_company_id,
                                                 null,
                                                 null,
                                                 null,
                                                 null,
                                                 '',
                                                 v_user_id,
                                                 null,
                                                 null,
                                                 null,
                                                 v_dimension4_value_id,
                                                 null,
                                                 null,
                                                 null,
                                                 null,
                                                 v_dimension9_value_id,
                                                 null,
                                                 v_company_id,
                                                 v_journal_line_id);
        --更新接口表                                           
        update core_sync_interface c
           set c.read_status      = '1',
               c.last_update_date = sysdate,
               c.last_updated_by  = 1
         where c.id = c2.id;
      end loop;
    
      --预算日记账生效
      bgt_journal_pkg.set_bgt_journal_status_2(p_journal_header_id => v_bgt_journal_headers_id,
                                               p_status            => 'POSTED',
                                               p_user_id           => v_user_id);
    end loop;
  end create_bgt_journal;

  procedure renew_company is
    v_companies fnd_companies%rowtype;
  begin
    for c1 in (select *
                 from core_sync_interface c
                where c.data_type = '01' --机构
                  and c.read_status = '0'
                  and exists
                (select 1
                         from fnd_companies f
                        where f.company_code = c.attribute1)) loop
    
      update fnd_companies f
         set f.core_company_code = c1.attribute2,
             f.last_update_date  = sysdate,
             f.last_updated_by   = 1
       where f.company_code = c1.attribute1;
    
      update core_sync_interface c
         set c.read_status      = '1',
             c.last_update_date = sysdate,
             c.last_updated_by  = 1
       where c.id = c1.id;
    end loop;
  end renew_company;

  function get_position_code(p_company_id number default null) return varchar is
    v_code_number number;
  begin
    select max(to_number(substr(eop.position_code, 3)))
      into v_code_number
      from exp_org_position eop
     where eop.position_code like 'GW%'
       and eop.company_id = p_company_id;
    v_code_number := v_code_number + 1;
    return 'GW' || v_code_number;
  end get_position_code;

  --新建部门，新建岗位
  procedure insert_unit is
  
    v_responsibility_id  number;
    v_company_id         number;
    v_unit_id            number;
    v_parent_unit_id     number := null;
    v_leader_employee_id number := null;
    v_position_code      varchar2(30);
    p_position_id        number;
  begin
    for c1 in (select *
                 from core_sync_interface c
                where c.data_type = '02' --部门
                  and c.read_status = '0'
                  and not exists
                (select 1
                         from exp_org_unit eou, fnd_companies fc
                        where eou.company_id = fc.company_id
                          and fc.company_code = c.attribute1
                          and eou.unit_code = c.attribute5)) loop
    
      select frc.responsibility_center_id, fc.company_id
        into v_responsibility_id, v_company_id
        from fnd_responsibility_centers frc, fnd_companies fc
       where frc.company_id = fc.company_id
         and fc.company_code = c1.attribute1
         and frc.responsibility_center_code = c1.attribute5;
    
      --父部门
      begin
        if c1.attribute4 is not null then
          select eou.unit_id
            into v_parent_unit_id
            from exp_org_unit eou, fnd_companies fc
           where eou.company_id = fc.company_id
             and eou.unit_code = c1.attribute4
             and fc.company_code = c1.attribute1;
        end if;
      EXCEPTION
        when no_data_found then
          insert_sync_core_logs('-------',
                                '批次【' || c1.batch_id || '】||明细序列号【' ||
                                c1.seq_id || '】下部门代码' || c1.attribute4 ||
                                '在费控不存在');
        
          exit;
      end;
      if c1.attribute6 is not null then
        select e.employee_id
          into v_leader_employee_id
          from exp_employees e
         where e.employee_code = c1.attribute6;
      end if;
    
      --创建部门
      exp_org_unit_pkg.insert_org_unit(p_unit_code                => c1.attribute5,
                                       p_description              => c1.attribute3,
                                       p_company_id               => v_company_id,
                                       p_responsibility_center_id => v_responsibility_id,
                                       p_parent_unit_id           => v_parent_unit_id,
                                       p_leader_employee_id       => v_leader_employee_id,
                                       p_operate_unit_id          => null,
                                       p_enabled_flag             => 'Y',
                                       p_created_by               => 1,
                                       p_chief_position_id        => null,
                                       p_org_unit_level_id        => null,
                                       p_unit_type_id             => null,
                                       p_hr_code                  => c1.attribute2);
    
      select eou.unit_id
        into v_unit_id
        from exp_org_unit eou
       where eou.company_id = v_company_id
         and eou.unit_code = c1.attribute5;
    
      v_position_code := get_position_code(v_company_id);
      exp_org_position_pkg.insert_org_position(p_unit_id            => v_unit_id,
                                               p_position_code      => v_position_code,
                                               p_description        => c1.attribute3 ||
                                                                       '普通员工',
                                               p_parent_position_id => null,
                                               p_company_id         => v_company_id,
                                               p_enabled_flag       => 'Y',
                                               p_created_by         => 1,
                                               p_employee_job_id    => null,
                                               p_position_id        => p_position_id);
      update core_sync_interface c
         set c.read_status      = '1',
             c.last_update_date = sysdate,
             c.last_updated_by  = 1
       where c.id = c1.id;
    end loop;
  end insert_unit;

  --新增员工
  procedure insert_employees is
    v_company_id          number;
    v_unit_id             number;
    v_position_id         number;
    v_employee_type_id    number;
    v_employee_id         number;
    v_employees_assign_id number;
    v_line_number         number;
    v_vcdl_bank_num       bcdl_bank_num%rowtype;
    -- v_user_id  number;
  begin
    for c1 in (select *
                 from core_sync_interface c
                where c.data_type = '03' --销售人员
                  and c.read_status = '0'
                  and not exists
                (select 1
                         from exp_employees e
                        where e.employee_code = c.attribute1)) loop
    
      select fc.company_id
        into v_company_id
        from fnd_companies fc
       where fc.company_code = c1.attribute8;
    
      select eou.unit_id
        into v_unit_id
        from exp_org_unit eou
       where eou.company_id = v_company_id;
    
      select eop.position_id
        into v_position_id
        from exp_org_position eop
       where eop.unit_id = v_unit_id
         and eop.company_id = v_company_id;
    
      select eet.employee_type_id
        into v_employee_type_id
        from exp_employee_types eet
       where eet.employee_type_code = '20'; --销售人员代码
    
      exp_employees_pkg.insert_employees(p_employee_code    => c1.attribute1,
                                         p_name             => c1.attribute2,
                                         p_email            => c1.attribute3,
                                         p_mobil            => null,
                                         p_phone            => c1.attribute4,
                                         p_enabled_flag     => 'Y',
                                         p_created_by       => 1,
                                         p_employee_type_id => v_employee_type_id,
                                         p_employee_id      => v_employee_id);
    
      exp_employees_pkg.insert_exp_employee_assigns(p_employee_id           => v_employee_id,
                                                    p_company_id            => v_company_id,
                                                    p_position_id           => v_position_id,
                                                    p_employee_job_id       => null,
                                                    p_employee_levels_id    => null,
                                                    p_primary_position_flag => 'Y',
                                                    p_enabled_flag          => 'Y',
                                                    p_user_id               => 1,
                                                    p_employees_assign_id   => v_employees_assign_id);
    
      --员工银行表行号
      begin
        select max(eea.line_number)
          into v_line_number
          from exp_employee_accounts eea
         where eea.employee_id = v_employee_id;
        if v_line_number is not null then
          v_line_number := v_line_number + 10;
        end if;
      EXCEPTION
        when no_data_found then
          v_line_number := 5;
      end;
    
      select *
        into v_vcdl_bank_num
        from bcdl_bank_num bbn
       where bbn.bank_num = c1.attribute5;
    
      exp_employees_pkg.insert_exp_bank_assigns(p_employee_id        => v_employee_id,
                                                p_line_number        => v_line_number,
                                                p_bank_code          => v_vcdl_bank_num.belong_bank_value,
                                                p_bank_name          => v_vcdl_bank_num.belong_bank_name,
                                                p_bank_location_code => v_vcdl_bank_num.bank_num,
                                                p_bank_location      => v_vcdl_bank_num.bank_name,
                                                p_province_code      => v_vcdl_bank_num.prov_code,
                                                p_province_name      => v_vcdl_bank_num.prov_name,
                                                p_city_code          => v_vcdl_bank_num.city_code,
                                                p_city_name          => v_vcdl_bank_num.city_name,
                                                p_account_number     => c1.attribute7,
                                                p_account_name       => c1.attribute6,
                                                p_notes              => null,
                                                p_primary_flag       => 'Y',
                                                p_enabled_flag       => 'Y',
                                                p_user_id            => 1,
                                                p_sparticipantbankno => c1.attribute5,
                                                p_account_flag       => '20' --对私
                                                );
      /*
      INSERT INTO sys_user
        (user_id,
         user_name,
         encrypted_foundation_password,
         encrypted_user_password,
         start_date,
         end_date,
         last_logon_date,
         description,
         password_lifespan_days,
         password_lifespan_access,
         employee_id,
         frozen_flag,
         frozen_date,
         password_start_date,
         menu_type,
         CREATED_BY,
         CREATION_DATE,
         LAST_UPDATED_BY,
         LAST_UPDATE_DATE)
      VALUES
        (v_user_id,
         c1.attribute1,
         sys_login_pkg.md5(c1.attribute2),
         sys_login_pkg.md5(c1.attribute2),
         sys_date,
         null,
         null,
         c1.attribute3,
         null,
         null,
         v_employee_id,
         'N',
         null,
         null,
         null,
         1,
         sysdate,
         1,
         sysdate);
         */
    
      update core_sync_interface c
         set c.read_status      = '1',
             c.last_update_date = sysdate,
             c.last_updated_by  = 1
       where c.id = c1.id;
    end loop;
  end insert_employees;

  --插入同步接口表
  procedure load_core_sync_interface(p_batch_id    varchar2,
                                     p_seq_id      varchar2,
                                     p_data_type   varchar2,
                                     p_attribute1  varchar2,
                                     p_attribute2  varchar2,
                                     p_attribute3  varchar2,
                                     p_attribute4  varchar2,
                                     p_attribute5  varchar2,
                                     p_attribute6  varchar2,
                                     p_attribute7  varchar2,
                                     p_attribute8  varchar2,
                                     p_attribute9  varchar2,
                                     p_attribute10 varchar2,
                                     p_attribute11 varchar2,
                                     p_attribute12 varchar2) is
  begin
    insert into core_sync_interface
      (id,
       batch_id,
       seq_id,
       data_type,
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
       attribute11,
       attribute12,
       read_status,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by)
    values
      (core_sync_interface_s.nextval,
       p_batch_id,
       p_seq_id,
       p_data_type,
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
       p_attribute11,
       p_attribute12,
       '0',
       sysdate,
       1,
       sysdate,
       1);
  end;

  --销售费用同步
  procedure sync_marketing_expense(p_request_xml       sys.xmltype,
                                   p_batch_id          varchar2,
                                   p_head_company_code varchar2,
                                   p_reqseqid          out varchar2,
                                   p_syn_status        out varchar2,
                                   p_messaeg           out varchar2) is
    e_null      exception;
    e_no_exists exception;
  
    v_company_code  varchar2(30);
    v_unit_code     varchar2(30);
    v_period_name   varchar2(10);
    v_amount        number;
    v_value_code    varchar2(30);
    v_employee_code varchar2(10);
  begin
  
    insert_sync_core_logs('-------', '销售费用同步明细解析开始');
  
    --头机构校验
    if p_head_company_code is null then
      raise e_null;
    else
      begin
        select f.company_code
          into v_company_code
          from fnd_companies f
         where f.company_code = p_head_company_code;
      exception
        when no_data_found then
          raise e_no_exists;
      end;
    end if;
  
    FOR c_result IN (SELECT extractvalue(t.column_value, '/RD/ReqSeqID') reqseqid,
                            extractvalue(t.column_value,
                                         '/RD/LineCompanyCode') line_company_code,
                            extractvalue(t.column_value, '/RD/UnitCode') unit_code,
                            extractvalue(t.column_value, '/RD/BudgetCode') budget_code,
                            extractvalue(t.column_value, '/RD/Period') period_name,
                            extractvalue(t.column_value, '/RD/Amount') amount,
                            extractvalue(t.column_value,
                                         '/RD/GtcxCoaDefdoco2') GtcxCoaDefdoco2, --专属标识
                            extractvalue(t.column_value,
                                         '/RD/GtcxCoaBankdoco2') GtcxCoaBankdoco2, --渠道
                            extractvalue(t.column_value, '/RD/EmployeeCode') employee_code
                       FROM TABLE(xmlsequence(p_request_xml.extract('/HEC/IN/RD'))) t) LOOP
    
      if c_result.reqseqid is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,存在明细序列号【ReqSeqID】为空';
        exit;
      end if;
    
      if c_result.line_company_code is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,行机构代码【LineCompanyCode】为空';
        exit;
      else
        begin
          select f.company_code
            into v_company_code
            from fnd_companies f
           where f.company_code = c_result.line_company_code;
        exception
          when no_data_found then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                            '】下,行机构代码值【' || c_result.line_company_code ||
                            '】在费控系统不错在！';
            exit;
        end;
      end if;
    
      if c_result.unit_code is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,部门代码【UnitCode】为空';
        exit;
      else
        begin
          select f.unit_code
            into v_unit_code
            from exp_org_unit f
           where f.unit_code = c_result.unit_code;
        exception
          when no_data_found then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                            '】下,部门代码值【' || c_result.unit_code ||
                            '】在费控系统不错在！';
            exit;
        end;
      end if;
    
      if c_result.budget_code is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,部门代码【BudgetCode】为空';
        exit;
      else
        /*begin
          select f.unit_code
            into v_unit_code
            from exp_org_unit f
           where f.unit_code = c_result.budget_code;
        exception
          when no_data_found then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                            '】下,预算项目代码值【' || c_result.budget_code ||
                            '】在费控系统不存在！';
            exit;
        end;*/
      
        --客户支持费
        if c_result.budget_code <> 'YS06801' then
          p_syn_status := 'fail';
          p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                          '】下,预算项目代码值需固定为【YS06801】';
          exit;
        end if;
      end if;
    
      if c_result.period_name is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,期间【Period】为空';
        exit;
      else
        begin
          select v.period_name
            into v_period_name
            from gld_period_status_v v
           where v.adjustment_flag = 'N'
             and v.period_set_code =
                 (select b.period_set_code
                    from gld_set_of_books b
                   where b.set_of_books_id =
                         (select f.set_of_books_id
                            from fnd_companies f
                           where f.company_code = p_head_company_code))
             and v.PERIOD_NAME = c_result.period_name
             and v.company_id =
                 (select f.company_id
                    from fnd_companies f
                   where f.company_code = p_head_company_code)
             and v.period_status_code = 'O';
        exception
          when no_data_found then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid || '】下,期间值【' ||
                            c_result.period_name || '】在费控系统不存在或者未打开！';
            exit;
        end;
      end if;
    
      if c_result.amount is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,金额【Amount】为空';
        exit;
      else
        begin
          v_amount := to_number(c_result.amount);
        exception
          when INVALID_NUMBER then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid || '】下,金额值【' ||
                            c_result.amount || '】非数字！';
            exit;
          when others then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid || '】下,金额值【' ||
                            c_result.amount || '】异常！';
            exit;
        end;
      end if;
    
      --专属标识
      if c_result.GtcxCoaDefdoco2 is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,专属标识代码【GtcxCoaDefdoco2】为空';
        exit;
      else
        begin
          select fv.dimension_value_code
            into v_value_code
            from fnd_dimension_values fv, fnd_dimensions fd
           where fv.dimension_id = fd.dimension_id
             and fv.dimension_value_code = c_result.GtcxCoaDefdoco2
             and fd.dimension_code = 'GTCX_COA_DEFDOC02';
        exception
          when no_data_found then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                            '】下,专属标识代码值【' || c_result.GtcxCoaDefdoco2 ||
                            '】在费控系统不错在！';
            exit;
        end;
      end if;
    
      --渠道
      if c_result.GtcxCoaBankdoco2 is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,渠道代码【GtcxCoaBankdoco2】为空';
        exit;
      else
        begin
          select fv.dimension_value_code
            into v_value_code
            from fnd_dimension_values fv, fnd_dimensions fd
           where fv.dimension_id = fd.dimension_id
             and fv.dimension_value_code = c_result.GtcxCoaBankdoco2
             and fd.dimension_code = 'GTCX_COA_BANKDOC01';
        exception
          when no_data_found then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                            '】下,渠道代码值【' || c_result.GtcxCoaBankdoco2 ||
                            '】在费控系统不错在！';
            exit;
        end;
      end if;
    
      --销售人员
      if c_result.employee_code is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,销售人员代码【EmployeeCode】为空';
        exit;
      else
        begin
          select e.employee_code
            into v_employee_code
            from exp_employees e
           where e.employee_code = c_result.employee_code;
        exception
          when no_data_found then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                            '】下,销售人员代码值【' || c_result.employee_code ||
                            '】在费控系统不错在！';
            exit;
        end;
      end if;
    
      --插入接口表
      load_core_sync_interface(p_batch_id    => p_batch_id,
                               p_seq_id      => c_result.reqseqid,
                               p_data_type   => '04', --销售费用
                               p_attribute1  => p_head_company_code,
                               p_attribute2  => c_result.line_company_code,
                               p_attribute3  => c_result.unit_code,
                               p_attribute4  => c_result.budget_code,
                               p_attribute5  => c_result.period_name,
                               p_attribute6  => c_result.amount,
                               p_attribute7  => c_result.GtcxCoaDefdoco2,
                               p_attribute8  => c_result.GtcxCoaBankdoco2,
                               p_attribute9  => c_result.employee_code,
                               p_attribute10 => '',
                               p_attribute11 => '',
                               p_attribute12 => '');
    
    END LOOP;
    insert_sync_core_logs('-------', '销售费用同步明细解析结束');
  exception
    when e_null then
      p_syn_status := 'fail';
      p_messaeg    := '同步失败,批次【' || p_batch_id ||
                      '】下,头机构【HeadCompanyCode】值为空！';
    when e_no_exists then
      p_syn_status := 'fail';
      p_messaeg    := '同步失败,批次【' || p_batch_id || '】下,头机构值【' ||
                      p_head_company_code || '】在费控系统不存在！';
    when others then
      insert_sync_core_logs('-------',
                            '批次【' || p_batch_id || '】同步异常,异常错误为:' ||
                            dbms_utility.format_error_backtrace || ' ' ||
                            SQLERRM);
      p_syn_status := 'exception';
      p_messaeg    := '同步失败,批次【' || p_batch_id || '】同步异常！';
  end sync_marketing_expense;

  --销售人员同步
  procedure sync_employee(p_request_xml sys.xmltype,
                          p_batch_id    varchar2,
                          p_reqseqid    out varchar2,
                          p_syn_status  out varchar2,
                          p_messaeg     out varchar2) is
  
    v_employee_code varchar2(30);
    v_unit_code     varchar2(30);
    v_company_code  varchar2(30);
    v_vcdl_bank_num varchar2(30);
  begin
    insert_sync_core_logs('-------', '销售人员同步明细解析开始');
  
    FOR c_result IN (SELECT extractvalue(t.column_value, '/RD/ReqSeqID') reqseqid,
                            extractvalue(t.column_value, '/RD/EmployeeCode') employee_code,
                            extractvalue(t.column_value, '/RD/EmployeeName') employee_name,
                            extractvalue(t.column_value, '/RD/EmployeeEmail') email,
                            extractvalue(t.column_value, '/RD/EmployeePhone') phone,
                            extractvalue(t.column_value,
                                         '/RD/BankLocationCode') bank_location_code,
                            extractvalue(t.column_value, '/RD/AccountName') account_name,
                            extractvalue(t.column_value, '/RD/AccountNum') account_number,
                            extractvalue(t.column_value, '/RD/CompanyCode') company_code,
                            extractvalue(t.column_value, '/RD/UnitCode') unit_code, --成本中心代码
                            extractvalue(t.column_value, '/HEC/IN/RD/State') enabled_flag
                       FROM TABLE(xmlsequence(p_request_xml.extract('/HEC/IN/RD'))) t) LOOP
    
      if c_result.reqseqid is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,存在明细序列号【ReqSeqID】为空';
        exit;
      end if;
    
      if c_result.employee_code is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,员工代码【EmployeeCode】为空';
        exit;
      else
        begin
          select e.employee_code
            into v_employee_code
            from exp_employees e
           where e.employee_code = c_result.employee_code;
          if v_employee_code is not null then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                            '】下,员工代码【' || c_result.employee_code || '】已存在';
            exit;
          end if;
        EXCEPTION
          when no_data_found then
            null;
        end;
      end if;
      if c_result.employee_name is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,员工姓名【EmployeeName】为空';
        exit;
      end if;
      if c_result.email is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,员工邮箱【EmployeeMail】为空';
        exit;
      end if;
      /*if c_result.phone is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,员工电话【EmployeePhone】为空';
        exit;
      end if;*/
      if c_result.bank_location_code is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,银行联行号【BankLocationCode】为空';
        exit;
      else
        begin
          select bbn.bank_num
            into v_vcdl_bank_num
            from bcdl_bank_num bbn
           where bbn.bank_num = c_result.bank_location_code;
        EXCEPTION
          when no_data_found then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                            '】下,银行联行号【BankLocationCode】不存在';
            exit;
        end;
      end if;
      if c_result.account_name is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,银行账户【AccountName】为空';
        exit;
      end if;
      if c_result.account_number is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,银行账号【AccountNum】为空';
        exit;
      end if;
      if c_result.company_code is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,机构代码【CompanyCode】为空';
        exit;
      else
        begin
          select f.company_code
            into v_company_code
            from fnd_companies f
           where f.company_code = c_result.company_code;
        EXCEPTION
          when no_data_found then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                            '】下,机构代码【' || c_result.company_code || '】,不存在';
            exit;
        end;
      end if;
      if c_result.unit_code is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,部门代码【UnitCode】为空';
        exit;
      else
        begin
          select eou.unit_code
            into v_unit_code
            from exp_org_unit eou, fnd_companies fc
           where eou.unit_code = c_result.unit_code
             and eou.company_id = fc.company_id
             and fc.company_code = c_result.company_code;
        EXCEPTION
          when no_data_found then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                            '】下,机构代码【' || c_result.company_code ||
                            '】的部门代码【' || c_result.unit_code || '】不存在';
            exit;
        end;
      end if;
      if c_result.enabled_flag is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,启用状态【Status】为空';
        exit;
      end if;
    
      --插入接口表
      load_core_sync_interface(p_batch_id    => p_batch_id,
                               p_seq_id      => c_result.reqseqid,
                               p_data_type   => '03', --销售人员
                               p_attribute1  => c_result.employee_code,
                               p_attribute2  => c_result.employee_name,
                               p_attribute3  => c_result.email,
                               p_attribute4  => c_result.phone,
                               p_attribute5  => c_result.bank_location_code,
                               p_attribute6  => c_result.account_name,
                               p_attribute7  => c_result.account_number,
                               p_attribute8  => c_result.company_code,
                               p_attribute9  => c_result.unit_code,
                               p_attribute10 => c_result.enabled_flag,
                               p_attribute11 => '',
                               p_attribute12 => '');
    
    END LOOP;
    insert_sync_core_logs('-------', '销售人员同步明细解析结束');
  exception
    when others then
      insert_sync_core_logs('-------',
                            '批次【' || p_batch_id || '】同步异常,异常错误为:' ||
                            dbms_utility.format_error_backtrace || ' ' ||
                            SQLERRM);
      p_syn_status := 'exception';
      p_messaeg    := '同步失败,批次【' || p_batch_id || '】同步异常！';
  end sync_employee;

  --部门同步
  procedure sync_unit(p_request_xml sys.xmltype,
                      p_batch_id    varchar2,
                      p_reqseqid    out varchar2,
                      p_syn_status  out varchar2,
                      p_messaeg     out varchar2) is
    v_company_code               number;
    v_unit_code                  varchar2(30);
    v_hr_code                    varchar2(30);
    v_responsibility_center_code varchar2(30);
    v_employee_code              varchar2(30);
  
  begin
    insert_sync_core_logs('-------', '部门同步明细解析开始');
  
    FOR c_result IN (SELECT extractvalue(t.column_value, '/RD/ReqSeqID') reqseqid,
                            extractvalue(t.column_value, '/RD/CompanyCode') company_code,
                            extractvalue(t.column_value, '/RD/UnitCode') unit_code,
                            extractvalue(t.column_value, '/RD/UnitName') unit_name,
                            extractvalue(t.column_value,
                                         '/RD/ParentUnitCode') parent_unit_code,
                            extractvalue(t.column_value,
                                         '/RD/ResponsilityCenterCode') responsility_center_code,
                            extractvalue(t.column_value,
                                         '/RD/LeaderEmployee') leader_employee_code
                       FROM TABLE(xmlsequence(p_request_xml.extract('/HEC/IN/RD'))) t) LOOP
    
      if c_result.reqseqid is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,存在明细序列号【ReqSeqID】为空';
        exit;
      end if;
    
      if c_result.company_code is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,机构代码【CompanyCode】为空';
        exit;
      else
        begin
          select f.core_company_code
            into v_company_code
            from fnd_companies f
           where f.company_code = c_result.company_code;
        exception
          when no_data_found then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid || '】下,机构代码' ||
                            c_result.company_code || '在费控不存在';
            exit;
        end;
      end if;
    
      if c_result.unit_code is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,部门代码【UnitCode】为空';
        exit;
      else
        begin
          select eou.hr_code
            into v_hr_code
            from exp_org_unit eou, fnd_companies fc
           where eou.hr_code = c_result.unit_code
             and eou.company_id = fc.company_id
             and fc.company_code = c_result.company_code;
          if v_hr_code is not null then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                            '】下,机构代码【' || c_result.company_code ||
                            '】的部门代码【' || c_result.unit_code || '】已存在';
            exit;
          end if;
        EXCEPTION
          when no_data_found then
            null;
        end;
      end if;
    
      if c_result.unit_name is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,部门名称【UnitName】为空';
        exit;
      end if;
    
      if c_result.parent_unit_code is not null then
        begin
          select unit_code
            into v_unit_code
            from exp_org_unit eou, fnd_companies fc
           where eou.unit_code = c_result.parent_unit_code
             and eou.company_id = fc.company_id
             and fc.company_code = c_result.company_code;
        EXCEPTION
          when no_data_found then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                            '】下,上级部门代码【ParentUnitCode】不存在';
            exit;
        end;
      end if;
    
      if c_result.leader_employee_code is not null then
        begin
          select e.employee_code
            into v_employee_code
            from exp_employees e
           where e.employee_code = c_result.leader_employee_code;
        EXCEPTION
          when no_data_found then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                            '】下,分管领导代码【LeaderEmployee】不存在';
            exit;
        end;
      end if;
    
      if c_result.responsility_center_code is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,成本中心代码【ResponsilityCenterCode】为空';
        exit;
      elsif c_result.responsility_center_code is not null then
        begin
          select eou.unit_code
            into v_unit_code
            from exp_org_unit eou, fnd_companies fc
           where eou.unit_code = c_result.responsility_center_code
             and eou.company_id = fc.company_id
             and fc.company_code = c_result.company_code;
          if v_unit_code is not null then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                            '】下,机构代码【' || c_result.company_code ||
                            '】的成本中心代码（对应HEC的部门代码）【' ||
                            c_result.responsility_center_code || '】已存在';
            exit;
          end if;
        EXCEPTION
          when no_data_found then
            null;
        end;
      else
        begin
          select frc.responsibility_center_code
            into v_responsibility_center_code
            from fnd_responsibility_centers frc, fnd_companies fc
           where frc.company_id = fc.company_id
             and fc.company_code = c_result.company_code
             and frc.responsibility_center_code =
                 c_result.responsility_center_code;
        EXCEPTION
          when no_data_found then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                            '】下,机构代码【' || c_result.company_code ||
                            '】的成本中心代码（对应HEC的公司级成本中心代码）【' ||
                            c_result.responsility_center_code || '】不存在';
            exit;
        end;
      end if;
      --插入接口表
      load_core_sync_interface(p_batch_id    => p_batch_id,
                               p_seq_id      => c_result.reqseqid,
                               p_data_type   => '02', --部门
                               p_attribute1  => c_result.company_code,
                               p_attribute2  => c_result.unit_code,
                               p_attribute3  => c_result.unit_name,
                               p_attribute4  => c_result.parent_unit_code,
                               p_attribute5  => c_result.responsility_center_code,
                               p_attribute6  => c_result.leader_employee_code,
                               p_attribute7  => '',
                               p_attribute8  => '',
                               p_attribute9  => '',
                               p_attribute10 => '',
                               p_attribute11 => '',
                               p_attribute12 => '');
    
    END LOOP;
  
    insert_sync_core_logs('-------', '部门同步明细解析结束');
  exception
    when others then
      insert_sync_core_logs('-------',
                            '批次【' || p_batch_id || '】同步异常,异常错误为:' ||
                            dbms_utility.format_error_backtrace || ' ' ||
                            SQLERRM);
      p_syn_status := 'exception';
      p_messaeg    := '同步失败,批次【' || p_batch_id || '】同步异常！';
  end sync_unit;

  --同步机构
  procedure sync_company(p_request_xml sys.xmltype,
                         p_batch_id    varchar2,
                         p_reqseqid    out varchar2,
                         p_syn_status  out varchar2,
                         p_messaeg     out varchar2) is
    v_company_code varchar2(30);
  begin
  
    insert_sync_core_logs('-------', '机构同步明细解析开始');
  
    --解析机构明细，插入接口表
    FOR c_result IN (SELECT extractvalue(t.column_value, '/RD/ReqSeqID') reqseqid,
                            extractvalue(t.column_value, '/RD/CompanyCode') company_code,
                            extractvalue(t.column_value,
                                         '/RD/CoreCompanyCode') core_company_code
                       FROM TABLE(xmlsequence(p_request_xml.extract('/HEC/IN/RD'))) t) LOOP
    
      if c_result.reqseqid is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,存在明细序列号【ReqSeqID】为空';
        exit;
      elsif c_result.company_code is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,机构代码【CompanyCode】为空';
        exit;
      elsif c_result.company_code is not null then
        begin
          select f.core_company_code
            into v_company_code
            from fnd_companies f
           where f.company_code = c_result.company_code;
        
          if v_company_code is not null then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                            '】下,机构代码【' || c_result.company_code ||
                            '】,已存在对应核心机构';
            exit;
          end if;
        exception
          when no_data_found then
            if c_result.core_company_code is null then
              p_syn_status := 'fail';
              p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                              '】下,核心机构代码【core_company_code】为空';
              exit;
            end if;
        end;
      elsif c_result.core_company_code is null then
        p_syn_status := 'fail';
        p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                        '】下,核心机构代码【core_company_code】为空';
        exit;
      elsif c_result.core_company_code is not null then
        begin
          select f.company_code
            into v_company_code
            from fnd_companies f
           where f.company_code = c_result.core_company_code;
        
          if v_company_code is not null then
            p_syn_status := 'fail';
            p_messaeg    := '同步失败,明细序列号【' || c_result.reqseqid ||
                            '】下,核心机构代码【' || c_result.core_company_code ||
                            '】,已存在！';
            exit;
          end if;
        exception
          when no_data_found then
            null;
        end;
      end if;
    
      --插入接口表
      load_core_sync_interface(p_batch_id    => p_batch_id,
                               p_seq_id      => c_result.reqseqid,
                               p_data_type   => '01', --机构
                               p_attribute1  => c_result.company_code,
                               p_attribute2  => c_result.core_company_code,
                               p_attribute3  => '',
                               p_attribute4  => '',
                               p_attribute5  => '',
                               p_attribute6  => '',
                               p_attribute7  => '',
                               p_attribute8  => '',
                               p_attribute9  => '',
                               p_attribute10 => '',
                               p_attribute11 => '',
                               p_attribute12 => '');
    END LOOP;
  
    insert_sync_core_logs('-------', '机构同步明细解析结束');
  exception
    when others then
      insert_sync_core_logs('-------',
                            '批次【' || p_batch_id || '】同步异常,异常错误为:' ||
                            dbms_utility.format_error_backtrace || ' ' ||
                            SQLERRM);
      p_syn_status := 'exception';
      p_messaeg    := '同步失败,批次【' || p_batch_id || '】同步异常！';
  end sync_company;

  --核心同步
  procedure core_sync(p_request_xml  clob,
                      p_response_xml out varchar2,
                      p_success      out varchar2) is
    v_input_xml sys.xmltype;
    v_node_pub  sys.xmlsequencetype;
    v_node_out  sys.xmlsequencetype;
  
    v_systemsource      varchar2(10);
    v_syninterfacecode  varchar2(10);
    v_syndate           varchar2(10);
    v_syntime           varchar2(10);
    v_synseq            varchar2(20);
    v_output_xml        VARCHAR2(1000);
    v_messae            varchar2(400);
    v_reqseqid          varchar2(30);
    v_syn_status        varchar2(10);
    v_RtnCode           varchar2(10);
    v_RtnMsg            varchar2(10);
    v_head_company_code varchar2(30);
  begin
  
    insert_sync_core_logs(p_request_xml, '同步请求开始XML');
  
    v_input_xml := xmltype(p_request_xml);
  
    SELECT extractvalue(v_input_xml, '/HEC/PUB/SystemSource'),
           extractvalue(v_input_xml, '/HEC/PUB/SynInterfaceCode'),
           extractvalue(v_input_xml, '/HEC/PUB/SynDate'),
           extractvalue(v_input_xml, '/HEC/PUB/SynTime'),
           extractvalue(v_input_xml, '/HEC/PUB/SynSeq')
      INTO v_systemsource,
           v_syninterfacecode,
           v_syndate,
           v_syntime,
           v_synseq
      FROM dual;
  
    --公司同步
    if v_syninterfacecode = 'SYNC_COMPANY' then
      insert_sync_core_logs(p_request_xml, '机构同步开始');
    
      sync_company(p_request_xml => v_input_xml,
                   p_batch_id    => v_synseq, -- 批次号
                   p_reqseqid    => v_reqseqid,
                   p_syn_status  => v_syn_status, --明细同步状态
                   p_messaeg     => v_messae);
    
      insert_sync_core_logs(p_request_xml, '机构同步结束');
      --部门同步  
    elsif v_syninterfacecode = 'SYNC_UNIT' then
      insert_sync_core_logs(p_request_xml, '部门同步开始');
    
      sync_unit(p_request_xml => v_input_xml,
                p_batch_id    => v_synseq, -- 批次号
                p_reqseqid    => v_reqseqid,
                p_syn_status  => v_syn_status, --明细同步状态
                p_messaeg     => v_messae);
    
      insert_sync_core_logs(p_request_xml, '部门同步结束');
      --销售人员同步  
    elsif v_syninterfacecode = 'SYNC_EMPLOYEE' then
      insert_sync_core_logs(p_request_xml, '销售人员同步开始');
    
      sync_employee(p_request_xml => v_input_xml,
                    p_batch_id    => v_synseq, -- 批次号
                    p_reqseqid    => v_reqseqid,
                    p_syn_status  => v_syn_status, --明细同步状态
                    p_messaeg     => v_messae);
    
      insert_sync_core_logs(p_request_xml, '销售人员同步结束');
      --销售费用
    elsif v_syninterfacecode = 'SYNC_MARKETING_EXPENSE' then
      insert_sync_core_logs(p_request_xml, '销售费用同步开始');
    
      SELECT extractvalue(v_input_xml, '/HEC/IN/HeadCompanyCode')
        INTO v_head_company_code
        FROM dual;
    
      sync_marketing_expense(p_request_xml       => v_input_xml,
                             p_batch_id          => v_synseq, -- 批次号
                             p_head_company_code => v_head_company_code, --头机构
                             p_reqseqid          => v_reqseqid,
                             p_syn_status        => v_syn_status, --明细同步状态
                             p_messaeg           => v_messae);
    
      insert_sync_core_logs(p_request_xml, '销售费用同步结束');
    end if;
  
    if v_syn_status = 'success' then
      v_RtnCode := v_syn_status;
      v_RtnMsg  := '同步成功';
    else
      v_RtnCode := v_syn_status;
      v_RtnMsg  := '同步失败，查看失败明细！';
    end if;
  
    --获取返回节点序列
    SELECT xmlsequencetype(xmlelement("SystemSource", v_systemsource),
                           xmlelement("SynInterfaceCode", v_syninterfacecode),
                           xmlelement("SynDate", v_syndate),
                           xmlelement("SynTime", v_syntime),
                           xmlelement("SynSeq", v_synseq),
                           xmlelement("RtnCode", v_RtnCode),
                           xmlelement("RtnMsg", v_RtnMsg)),
           xmlsequencetype(xmlelement("ReqSeqID", v_reqseqid),
                           xmlelement("ResponseMsg", v_messae))
      INTO v_node_pub, v_node_out
      FROM dual;
  
    --节点拼接
    SELECT '<?xml version="1.0" encoding="utf-8"?>' || xmlelement("HEC", xmlelement("PUB", xmlconcat(v_node_pub)), xmlelement("OUT", xmlconcat(v_node_out)))
           .getstringval()
      INTO v_output_xml
      FROM dual;
  
    --转义字符处理
    v_output_xml   := REPLACE(v_output_xml, '&lt;', '<');
    v_output_xml   := REPLACE(v_output_xml, '&gt;', '>');
    p_response_xml := v_output_xml;
    p_success      := 'OK';
  
    insert_sync_core_logs(p_request_xml, '同步请求结束返回XML');
  
  EXCEPTION
    WHEN OTHERS THEN
      insert_sync_core_logs(p_request_xml,
                            '同步异常,异常错误为:' ||
                            dbms_utility.format_error_backtrace || ' ' ||
                            SQLERRM);
      p_success := 'NOK';
  end core_sync;
end CORE_SYNC_PKG;
/
