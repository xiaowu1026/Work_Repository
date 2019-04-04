-- Create table
create table CSH_EBANK_LOGS
(
  log_id          NUMBER not null,
  log_level       VARCHAR2(30),
  log_desc        VARCHAR2(4000),
  creation_date   DATE not null,
  created_by      NUMBER not null,
  ref_table       VARCHAR2(30),
  ref_field       VARCHAR2(30),
  ref_id          NUMBER,
  document_number VARCHAR2(30)
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
comment on table CSH_EBANK_LOGS
  is '网银接口日志表';
-- Add comments to the columns 
comment on column CSH_EBANK_LOGS.log_id
  is 'pk';
comment on column CSH_EBANK_LOGS.log_level
  is '日志级别';
comment on column CSH_EBANK_LOGS.log_desc
  is '日志内容';
comment on column CSH_EBANK_LOGS.creation_date
  is '创建时间';
comment on column CSH_EBANK_LOGS.created_by
  is '创建人';
comment on column CSH_EBANK_LOGS.ref_table
  is '关联表';
comment on column CSH_EBANK_LOGS.ref_field
  is '关联字段';
comment on column CSH_EBANK_LOGS.ref_id
  is '关联ID';
comment on column CSH_EBANK_LOGS.document_number
  is '单据编号';
-- Create/Recreate primary, unique and foreign key constraints 
alter table CSH_EBANK_LOGS
  add constraint CSH_EBANK_LOGS_PK primary key (LOG_ID)
  using index 
  tablespace FKRL_DATA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
  
-- Create sequence 
create sequence CSH_EBANK_LOGS_S
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;
