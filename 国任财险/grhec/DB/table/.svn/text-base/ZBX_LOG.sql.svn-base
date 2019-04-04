create table ZBX_LOG
(MANDT VARCHAR2(3) NOT NULL,
ZYEAR VARCHAR2(4) NOT NULL,
ZLGID VARCHAR2(10) NOT NULL,
ZREPI VARCHAR2(40) NOT NULL,
ZBUKR VARCHAR2(4) NOT NULL,
ZBELN VARCHAR2(17) NOT NULL,
ZMTYP VARCHAR2(1) NOT NULL,
ZMESS VARCHAR2(100) NOT NULL,
CDATE VARCHAR2(8) NOT NULL,
CTIME TIMESTAMP NOT NULL
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
comment on table ZBX_LOG
  is '1.	接口日志抬头表';
  
-- Add comments to the columns 
comment on column ZBX_LOG.MANDT
  is '*主键ID';
comment on column ZBX_LOG.ZYEAR
  is '年度';
comment on column ZBX_LOG.ZLGID
  is '日志流水号';
comment on column ZBX_LOG.ZREPI
  is 'SAP程序名';
comment on column ZBX_LOG.ZBUKR
  is '公司代码';
comment on column ZBX_LOG.ZBELN
  is '报销系统凭证号';
comment on column ZBX_LOG.ZMTYP
  is '消息类型 (E 错误　W 警告 I 信息  S成功)';
comment on column ZBX_LOG.ZMESS
  is '消息文本';
comment on column ZBX_LOG.CDATE
  is '创建日期 格式：YYYYMMDD';
comment on column ZBX_LOG.CTIME
  is '创建时间';
               
-- Create/Recreate primary, unique and foreign key constraints 
alter table ZBX_LOG
  add constraint ZBX_LOG_PK primary key (MANDT,ZYEAR,ZLGID)
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
