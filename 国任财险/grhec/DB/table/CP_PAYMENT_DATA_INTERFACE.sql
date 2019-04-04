-- Create table
create table CP_PAYMENT_DATA_INTERFACE
(
  cp_payment_data_interface_id NUMBER not null,
  doc_head_id                  NUMBER,
  doc_head_num                 VARCHAR2(30),
  doc_head_serial_num          VARCHAR2(50),
  doc_line_id                  NUMBER,
  doc_line_serial_num          VARCHAR2(50),
  doc_type                     VARCHAR2(50),
  currency                     VARCHAR2(10),
  gather_account               VARCHAR2(30),
  gather_account_name          VARCHAR2(100),
  gather_branch_bank_num       VARCHAR2(12),
  gather_branch_bank_name      VARCHAR2(200),
  gather_bank_num              VARCHAR2(30),
  gather_bank_name             VARCHAR2(100),
  gather_book_card             VARCHAR2(10),
  amount                       NUMBER(13,2),
  prop_flag                    VARCHAR2(10),
  union_flag                   VARCHAR2(10),
  gather_province_code         VARCHAR2(30),
  gather_province_name         VARCHAR2(150),
  gather_city_code             VARCHAR2(30),
  gather_city_name             VARCHAR2(200),
  pay_status                   VARCHAR2(1),
  creation_date                DATE,
  created_by                   NUMBER,
  last_update_date             DATE,
  last_updated_by              NUMBER,
  send_time                    DATE,
  bank_back_info               VARCHAR2(2000),
  memo                         VARCHAR2(500),
  source_urid                  NUMBER,
  read_flag                    VARCHAR2(1)
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
comment on table CP_PAYMENT_DATA_INTERFACE
  is '֧�����ݽӿڱ�';
-- Add comments to the columns 
comment on column CP_PAYMENT_DATA_INTERFACE.cp_payment_data_interface_id
  is 'id';
comment on column CP_PAYMENT_DATA_INTERFACE.doc_head_id
  is 'ͷID';
comment on column CP_PAYMENT_DATA_INTERFACE.doc_head_num
  is 'ͷ���ݺ�,��ͷ������һ��';
comment on column CP_PAYMENT_DATA_INTERFACE.doc_head_serial_num
  is 'ͷ��ˮ��';
comment on column CP_PAYMENT_DATA_INTERFACE.doc_line_id
  is '������ID';
comment on column CP_PAYMENT_DATA_INTERFACE.doc_line_serial_num
  is '����ˮ��';
comment on column CP_PAYMENT_DATA_INTERFACE.doc_type
  is '�е������� EXP_REPORT ������ PAYMENT_REQUISITION ���뵥';
comment on column CP_PAYMENT_DATA_INTERFACE.currency
  is '����';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_account
  is '�տ��˺�';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_account_name
  is '�տ��';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_branch_bank_num
  is '�տ����к�  12λ';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_branch_bank_name
  is '�տ��������';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_bank_num
  is '�տ�����  �� 102';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_bank_name
  is '�տ��������';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_book_card
  is '�տ�۱�־';
comment on column CP_PAYMENT_DATA_INTERFACE.amount
  is '���';
comment on column CP_PAYMENT_DATA_INTERFACE.prop_flag
  is '��˽��־ 1:���� 2;���п�';
comment on column CP_PAYMENT_DATA_INTERFACE.union_flag
  is '���б�־ Y������ת�ˣ�N������ת��';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_province_code
  is '�տ�ʡ����';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_province_name
  is '�տ�ʡ����';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_city_code
  is '�տ���д���';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_city_name
  is '�տ��������';
comment on column CP_PAYMENT_DATA_INTERFACE.pay_status
  is '����״̬ 0-δ֧��  1-֧���� 4-֧���ɹ�  3-֧��ʧ��  5-��Ʊ 6-״̬δ֪ 7-����ʧ�� 8-ȡ������ 9-����֧��';
comment on column CP_PAYMENT_DATA_INTERFACE.creation_date
  is '��������';
comment on column CP_PAYMENT_DATA_INTERFACE.created_by
  is '�����û�ID';
comment on column CP_PAYMENT_DATA_INTERFACE.last_update_date
  is '����������';
comment on column CP_PAYMENT_DATA_INTERFACE.last_updated_by
  is '�������û�ID';
comment on column CP_PAYMENT_DATA_INTERFACE.send_time
  is '����ʱ��';
comment on column CP_PAYMENT_DATA_INTERFACE.bank_back_info
  is '���з�����Ϣ';
comment on column CP_PAYMENT_DATA_INTERFACE.memo
  is 'ժҪ';
comment on column CP_PAYMENT_DATA_INTERFACE.source_urid
  is 'JX_ATS_PAY_TRANS_INTERFACE��urid';
comment on column CP_PAYMENT_DATA_INTERFACE.read_flag
  is '��ȡ״̬��Y:�Ѷ�ȡ N:δ��ȡ';
-- Create/Recreate indexes 
create index CP_PAYMENT_DATA_INTERFACE_N1 on CP_PAYMENT_DATA_INTERFACE (DOC_HEAD_ID)
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
-- Create/Recreate primary, unique and foreign key constraints 
alter table CP_PAYMENT_DATA_INTERFACE
  add constraint CP_PAYMENT_DATA_INTERFACE_PK primary key (CP_PAYMENT_DATA_INTERFACE_ID)
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
create sequence CP_PAYMENT_DATA_INTERFACE_S
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;
