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
  is '1.	�ӿ���־̧ͷ��';
  
-- Add comments to the columns 
comment on column ZBX_LOG.MANDT
  is '*����ID';
comment on column ZBX_LOG.ZYEAR
  is '���';
comment on column ZBX_LOG.ZLGID
  is '��־��ˮ��';
comment on column ZBX_LOG.ZREPI
  is 'SAP������';
comment on column ZBX_LOG.ZBUKR
  is '��˾����';
comment on column ZBX_LOG.ZBELN
  is '����ϵͳƾ֤��';
comment on column ZBX_LOG.ZMTYP
  is '��Ϣ���� (E ����W ���� I ��Ϣ  S�ɹ�)';
comment on column ZBX_LOG.ZMESS
  is '��Ϣ�ı�';
comment on column ZBX_LOG.CDATE
  is '�������� ��ʽ��YYYYMMDD';
comment on column ZBX_LOG.CTIME
  is '����ʱ��';
               
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
