create table ZBX_LOGD
( MANDT VARCHAR2(3) NOT NULL,
  ZYEAR VARCHAR2(4) NOT NULL,
  ZLGID VARCHAR2(10) NOT NULL,
  ZITEM VARCHAR2(5) NOT NULL,
  ZBUKR VARCHAR2(4) NOT NULL,
  ZBELN VARCHAR2(17) NOT NULL,
  ZBUZE VARCHAR2(6) NOT NULL,
  ZMTYP VARCHAR2(1) NOT NULL,
  ZMESS VARCHAR2(100) NOT NULL,
  ZFIEN VARCHAR2(20),
  ZFIEV VARCHAR2(52),
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
comment on table ZBX_LOGD
  is '接口日志明细表';
  
-- Add comments to the columns 
comment on column ZBX_LOGD.MANDT
  is '*主键ID';
comment on column ZBX_LOGD.ZYEAR
  is '年度';
comment on column ZBX_LOGD.ZLGID
  is '日志流水号';
comment on column ZBX_LOGD.ZITEM
  is '日志行项目号';
comment on column ZBX_LOGD.ZBUKR
  is '公司代码';
comment on column ZBX_LOGD.ZBELN
  is '报销系统凭证号';
comment on column ZBX_LOGD.ZBUZE
  is '报销系统凭证行号';  
comment on column ZBX_LOGD.ZMTYP
  is '消息类型 (E 错误　W 警告 I 信息  S成功)';
comment on column ZBX_LOGD.ZMESS
  is '消息文本';
comment on column ZBX_LOGD.ZFIEN
  is '字段名';
comment on column ZBX_LOGD.ZFIEV
  is '字段值';
comment on column ZBX_LOGD.CDATE
  is '创建日期 格式：YYYYMMDD';
comment on column ZBX_LOGD.CTIME
  is '创建时间';
               
-- Create/Recreate primary, unique and foreign key constraints 
alter table ZBX_LOGD
  add constraint ZBX_LOGD_PK primary key (MANDT,ZYEAR,ZLGID,ZITEM)
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
