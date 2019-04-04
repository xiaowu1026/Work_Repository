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
  is '支付数据接口表';
-- Add comments to the columns 
comment on column CP_PAYMENT_DATA_INTERFACE.cp_payment_data_interface_id
  is 'id';
comment on column CP_PAYMENT_DATA_INTERFACE.doc_head_id
  is '头ID';
comment on column CP_PAYMENT_DATA_INTERFACE.doc_head_num
  is '头单据号,无头则与行一致';
comment on column CP_PAYMENT_DATA_INTERFACE.doc_head_serial_num
  is '头流水号';
comment on column CP_PAYMENT_DATA_INTERFACE.doc_line_id
  is '付款行ID';
comment on column CP_PAYMENT_DATA_INTERFACE.doc_line_serial_num
  is '行流水号';
comment on column CP_PAYMENT_DATA_INTERFACE.doc_type
  is '行单据类型 EXP_REPORT 报销单 PAYMENT_REQUISITION 申请单';
comment on column CP_PAYMENT_DATA_INTERFACE.currency
  is '币种';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_account
  is '收款账号';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_account_name
  is '收款户名';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_branch_bank_num
  is '收款联行号  12位';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_branch_bank_name
  is '收款分行名称';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_bank_num
  is '收款银行  如 102';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_bank_name
  is '收款分行名称';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_book_card
  is '收款卡折标志';
comment on column CP_PAYMENT_DATA_INTERFACE.amount
  is '金额';
comment on column CP_PAYMENT_DATA_INTERFACE.prop_flag
  is '公私标志 1:存折 2;银行卡';
comment on column CP_PAYMENT_DATA_INTERFACE.union_flag
  is '跨行标志 Y：行内转账，N：跨行转账';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_province_code
  is '收款省代码';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_province_name
  is '收款省名称';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_city_code
  is '收款城市代码';
comment on column CP_PAYMENT_DATA_INTERFACE.gather_city_name
  is '收款城市名称';
comment on column CP_PAYMENT_DATA_INTERFACE.pay_status
  is '付款状态 0-未支付  1-支付中 4-支付成功  3-支付失败  5-退票 6-状态未知 7-导入失败 8-取消付款 9-重新支付';
comment on column CP_PAYMENT_DATA_INTERFACE.creation_date
  is '创建日期';
comment on column CP_PAYMENT_DATA_INTERFACE.created_by
  is '创建用户ID';
comment on column CP_PAYMENT_DATA_INTERFACE.last_update_date
  is '最后更新日期';
comment on column CP_PAYMENT_DATA_INTERFACE.last_updated_by
  is '最后更新用户ID';
comment on column CP_PAYMENT_DATA_INTERFACE.send_time
  is '发送时间';
comment on column CP_PAYMENT_DATA_INTERFACE.bank_back_info
  is '银行返回信息';
comment on column CP_PAYMENT_DATA_INTERFACE.memo
  is '摘要';
comment on column CP_PAYMENT_DATA_INTERFACE.source_urid
  is 'JX_ATS_PAY_TRANS_INTERFACE中urid';
comment on column CP_PAYMENT_DATA_INTERFACE.read_flag
  is '读取状态，Y:已读取 N:未读取';
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
