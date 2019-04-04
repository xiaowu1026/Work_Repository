-- Create table
create table BANK_INFO_SYN_LOG
(
  bank_info_syn_log_id NUMBER,
  start_time           DATE,
  end_time             DATE,
  syn_num              NUMBER,
  remote_last_time     DATE,
  error_msg            VARCHAR2(200)
)
tablespace FKRL_DATA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table BANK_INFO_SYN_LOG
  is '银行信息同步日志';
-- Add comments to the columns 
comment on column BANK_INFO_SYN_LOG.start_time
  is '开始同步时间';
comment on column BANK_INFO_SYN_LOG.end_time
  is '结束同步时间';
comment on column BANK_INFO_SYN_LOG.syn_num
  is '同步数据条数';
comment on column BANK_INFO_SYN_LOG.remote_last_time
  is '远程最后时间快照';
comment on column BANK_INFO_SYN_LOG.error_msg
  is '错误信息';
  
-- Create sequence 
create sequence BANK_INFO_SYN_LOG_s
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 10;
