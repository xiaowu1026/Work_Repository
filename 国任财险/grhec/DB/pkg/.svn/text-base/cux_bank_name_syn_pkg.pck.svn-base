create or replace package cux_bank_name_syn_pkg is

  -- Author  : PENG
  -- Created : 2018/9/20 9:48:29
  -- Purpose : 

  procedure syn_brzj_bank_sch;

  --同步更新保融资金银行信息
  function syn_brzj_bank(p_event_record_id number,
                         p_event_log_id    number,
                         p_event_param     number,
                         p_user_id         number) return number;
end cux_bank_name_syn_pkg;
/
create or replace package body cux_bank_name_syn_pkg is

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

  procedure syn is
    v_log_info         BANK_INFO_SYN_LOG%rowtype;
    v_remote_last_time DATE;
    v_total_num        NUMBER := 0;
    v_count            NUMBER;
    v_index            NUMBER := 0;
    --银行大类代码
    v_head_bank_code VARCHAR2(20);
  BEGIN
    v_log_info.start_time := sysdate;
  
    -- 取最后同步时间
    SELECT MAX(remote_last_time)
      INTO v_remote_last_time
      FROM BANK_INFO_SYN_LOG;
  
    IF (v_remote_last_time IS NULL) THEN
      v_remote_last_time := TO_DATE('1970-01-01', 'yyyy-mm-dd');
    END IF;
  
    --同步循环
    FOR cur_info IN (SELECT *
                       FROM br_hfm_bank_v r
                      WHERE r.lastmodifiedon > v_remote_last_time) LOOP
    
      SELECT COUNT(1)
        INTO v_count
        FROM bcdl_bank_num jc
       WHERE jc.bank_num = cur_info.bank_branch_num;
    
      -- 更新
      IF (v_count > 0) THEN
      
        update bcdl_bank_num b
           set b.area_code         = cur_info.area_code,
               b.area_name         = cur_info.area_name,
               b.bank_name         = cur_info.bank_branch_name,
               b.belong_bank_name  = cur_info.bank_name,
               b.belong_bank_value = cur_info.bank_code,
               b.detail_bank_code  = cur_info.bank_code,
               b.detail_bank_name  = cur_info.bank_name
         where b.bank_num = cur_info.bank_branch_num;
      
        -- 插入
      ELSE
        insert into bcdl_bank_num
          (bank_num,
           bank_name,
           /* bank_type_code    VARCHAR2(50),
           bank_type_name    VARCHAR2(100),
           bank_clear_code   VARCHAR2(50),
           ccpc              VARCHAR2(100),
           prov_code         VARCHAR2(50),
           bank_clear_name   VARCHAR2(100),
           prov_name         VARCHAR2(100),*/
           created_by,
           creation_date,
           last_updated_by,
           last_update_date,
           belong_bank_value,
           belong_bank_name,
           id,
           /*city_code         VARCHAR2(50),
           city_name         VARCHAR2(200),*/
           /*head_bank_flag    VARCHAR2(1),*/
           detail_bank_code,
           detail_bank_name,
           /*routing_number    VARCHAR2(30),
           country           VARCHAR2(30),*/
           area_code,
           area_name)
        values
          (cur_info.bank_branch_num,
           cur_info.bank_branch_name,
           1,
           sysdate,
           1,
           sysdate,
           cur_info.bank_code,
           cur_info.bank_name,
           bcdl_bank_num_s.nextval,
           cur_info.bank_code,
           cur_info.bank_name,
           cur_info.area_code,
           cur_info.area_name);
      END IF;
    
      v_total_num := v_total_num + 1;
    
      --分段提交控制
      v_index := v_index + 1;
      IF v_index > 1000 THEN
        COMMIT;
        v_index := 0;
      END IF;
    
    END LOOP;
  
    -- 写日志
    IF (v_total_num > 0) THEN
      SELECT MAX(lastmodifiedon)
        INTO v_remote_last_time
        FROM br_hfm_bank_v r
       WHERE r.lastmodifiedon > v_remote_last_time;
    
      v_log_info.end_time             := sysdate;
      v_log_info.SYN_NUM              := v_total_num;
      v_log_info.REMOTE_LAST_TIME     := v_remote_last_time;
      v_log_info.BANK_INFO_SYN_LOG_ID := BANK_INFO_SYN_LOG_s.Nextval;
    
      INSERT INTO BANK_INFO_SYN_LOG VALUES v_log_info;
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      v_log_info.error_msg            := substr(sqlerrm || '--' ||
                                                dbms_utility.format_error_backtrace,
                                                1,
                                                200);
      v_log_info.BANK_INFO_SYN_LOG_ID := BANK_INFO_SYN_LOG_s.Nextval;
      INSERT INTO BANK_INFO_SYN_LOG VALUES v_log_info;
    
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => sqlerrm || '--' ||
                                                                                  dbms_utility.format_error_backtrace,
                                                     p_created_by              => 1,
                                                     p_package_name            => 'cux_bank_name_syn_pkg',
                                                     p_procedure_function_name => 'syn');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end syn;

  procedure syn_brzj_bank_sch is
    v_job_id    NUMBER;
    v_error_msg VARCHAR2(2000);
  BEGIN
    sch_log('同步更新保融资金银行信息开始 ');
    BEGIN
      syn;
    EXCEPTION
      WHEN OTHERS THEN
        sys_raise_app_error_pkg.get_sys_raise_app_error(sys_raise_app_error_pkg.g_err_line_id,
                                                        v_error_msg);
        sch_log('同步更新保融资金银行信息结束:' || v_error_msg);
    END;
    sch_log('同步更新保融资金银行信息结束');
  end syn_brzj_bank_sch;

  --同步更新保融资金银行信息
  function syn_brzj_bank(p_event_record_id number,
                         p_event_log_id    number,
                         p_event_param     number,
                         p_user_id         number) return number is
  begin
    syn();
    return 1;
  end syn_brzj_bank;
end cux_bank_name_syn_pkg;
/
