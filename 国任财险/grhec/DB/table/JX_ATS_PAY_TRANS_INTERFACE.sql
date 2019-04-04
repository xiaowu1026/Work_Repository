-- Create table
create table JX_ATS_PAY_TRANS_INTERFACE
(
  urid                      NUMBER not null,
  source_name               VARCHAR2(32),
  origin_note               VARCHAR2(32),
  source_notecode           VARCHAR2(32),
  apply_entity_code         VARCHAR2(20),
  apply_dept_code           VARCHAR2(20),
  pay_date                  DATE,
  settlement_mode           VARCHAR2(20),
  pay_type_code             VARCHAR2(20),
  category_code             VARCHAR2(20),
  sub_category_code         VARCHAR2(20),
  budget_item_code          VARCHAR2(20),
  pay_entity_code           VARCHAR2(20),
  pay_bank                  VARCHAR2(64),
  pay_account               VARCHAR2(64),
  rec_object_type           NUMBER,
  rec_name                  VARCHAR2(128),
  rec_bank_area             VARCHAR2(64),
  rec_bank                  VARCHAR2(64),
  rec_bank_locations        VARCHAR2(128),
  rec_account               VARCHAR2(64),
  rec_account_name          VARCHAR2(256),
  rec_currency              VARCHAR2(20),
  rec_money                 NUMBER(18,2),
  bank_money                NUMBER(18,2),
  purpose                   VARCHAR2(128),
  memo                      VARCHAR2(2000),
  description               VARCHAR2(512),
  vendor_code               VARCHAR2(20),
  isprivate                 VARCHAR2(2),
  card_flag                 VARCHAR2(2),
  fast_flag                 VARCHAR2(2),
  credentials               NUMBER(2),
  id_card                   VARCHAR2(64),
  cvv_code                  VARCHAR2(20) default '***',
  valid_date                VARCHAR2(20),
  ats_dealstate             NUMBER default 1,
  ats_dealdate              DATE,
  ats_dealerrorinfo         VARCHAR2(256),
  ats_returnstate           NUMBER default 1,
  ats_returndate            DATE,
  ats_returninfo            VARCHAR2(256),
  pay_state                 NUMBER default 1,
  pay_made_date             DATE,
  pay_info                  VARCHAR2(3000),
  fail_type                 NUMBER default 0,
  abstract                  VARCHAR2(40),
  checkbatchno              VARCHAR2(40),
  billtype                  VARCHAR2(32),
  billcode                  VARCHAR2(32),
  refund_state              NUMBER default 1,
  refund_info               VARCHAR2(128),
  refund_time               DATE,
  created_by                NUMBER,
  creation_date             DATE,
  last_updated_by           NUMBER,
  last_update_date          DATE,
  recordsource_batno        VARCHAR2(32),
  sourcebusinessno          VARCHAR2(32),
  partner_category          VARCHAR2(32),
  parent_id                 NUMBER,
  transaction_num           VARCHAR2(32),
  csh_transaction_header_id NUMBER,
  csh_transaction_line_id   NUMBER,
  sourcetype                VARCHAR2(100),
  hec_status                NUMBER,
  source_id                 NUMBER,
  company_id                NUMBER,
  inputdate                 DATE,
  plan_pay_date             VARCHAR2(10),
  cash_flow_code            VARCHAR2(20),
  payment_account           VARCHAR2(30),
  hfm_batch_number          VARCHAR2(50),
  old_urid                  NUMBER,
  write_tmp_session_id      NUMBER,
  audit_status              VARCHAR2(10),
  audit_info                VARCHAR2(200),
  hfm_payment_org           VARCHAR2(30),
  hfm_pay_type_desc         VARCHAR2(30),
  hfm_pay_type              VARCHAR2(30),
  serialnumber              VARCHAR2(50),
  error_message             VARCHAR2(3000),
  usedes                    VARCHAR2(10),
  summary                   VARCHAR2(2000),
  audit_time                DATE,
  read_flag                 VARCHAR2(1),
  audit_person              VARCHAR2(100),
  receive_date              DATE,
  post_flag                 VARCHAR2(1),
  document_payment_line_id  NUMBER
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
-- Add comments to the columns 
comment on column JX_ATS_PAY_TRANS_INTERFACE.urid
  is '*主键ID';
comment on column JX_ATS_PAY_TRANS_INTERFACE.source_name
  is '*系统来源[FPM]';
comment on column JX_ATS_PAY_TRANS_INTERFACE.origin_note
  is '*单据编号';
comment on column JX_ATS_PAY_TRANS_INTERFACE.source_notecode
  is '*来源单据编号';
comment on column JX_ATS_PAY_TRANS_INTERFACE.apply_entity_code
  is '*机构号';
comment on column JX_ATS_PAY_TRANS_INTERFACE.apply_dept_code
  is '单位号';
comment on column JX_ATS_PAY_TRANS_INTERFACE.pay_date
  is '支付日期';
comment on column JX_ATS_PAY_TRANS_INTERFACE.settlement_mode
  is '结算方式';
comment on column JX_ATS_PAY_TRANS_INTERFACE.pay_type_code
  is '交易类型/付款方式    转账,自动扣款补录';
comment on column JX_ATS_PAY_TRANS_INTERFACE.category_code
  is '资金类别';
comment on column JX_ATS_PAY_TRANS_INTERFACE.sub_category_code
  is '资金子类别';
comment on column JX_ATS_PAY_TRANS_INTERFACE.budget_item_code
  is '*计划项目';
comment on column JX_ATS_PAY_TRANS_INTERFACE.pay_entity_code
  is '收方组织';
comment on column JX_ATS_PAY_TRANS_INTERFACE.pay_bank
  is '收方银行';
comment on column JX_ATS_PAY_TRANS_INTERFACE.pay_account
  is '收方帐号';
comment on column JX_ATS_PAY_TRANS_INTERFACE.rec_object_type
  is '*收款方类型';
comment on column JX_ATS_PAY_TRANS_INTERFACE.rec_name
  is '*收款方名称';
comment on column JX_ATS_PAY_TRANS_INTERFACE.rec_bank_area
  is '*收方银行区域';
comment on column JX_ATS_PAY_TRANS_INTERFACE.rec_bank
  is '*收方银行代码(银行大类代码)';
comment on column JX_ATS_PAY_TRANS_INTERFACE.rec_bank_locations
  is '*收方银行开户行(联行号)';
comment on column JX_ATS_PAY_TRANS_INTERFACE.rec_account
  is '*收方账户';
comment on column JX_ATS_PAY_TRANS_INTERFACE.rec_account_name
  is '*收方户名';
comment on column JX_ATS_PAY_TRANS_INTERFACE.rec_currency
  is '*币种';
comment on column JX_ATS_PAY_TRANS_INTERFACE.rec_money
  is '*交易金额';
comment on column JX_ATS_PAY_TRANS_INTERFACE.bank_money
  is '*实付金额';
comment on column JX_ATS_PAY_TRANS_INTERFACE.purpose
  is '用途';
comment on column JX_ATS_PAY_TRANS_INTERFACE.memo
  is '*备注';
comment on column JX_ATS_PAY_TRANS_INTERFACE.description
  is '描述';
comment on column JX_ATS_PAY_TRANS_INTERFACE.vendor_code
  is '工号';
comment on column JX_ATS_PAY_TRANS_INTERFACE.isprivate
  is '*公私标志';
comment on column JX_ATS_PAY_TRANS_INTERFACE.card_flag
  is '*卡则标志';
comment on column JX_ATS_PAY_TRANS_INTERFACE.fast_flag
  is '*加急标志';
comment on column JX_ATS_PAY_TRANS_INTERFACE.credentials
  is '证件类型';
comment on column JX_ATS_PAY_TRANS_INTERFACE.id_card
  is '证件号码';
comment on column JX_ATS_PAY_TRANS_INTERFACE.cvv_code
  is '信用卡CVV码';
comment on column JX_ATS_PAY_TRANS_INTERFACE.valid_date
  is '信用卡有效期';
comment on column JX_ATS_PAY_TRANS_INTERFACE.ats_dealstate
  is '资金抽档状态';
comment on column JX_ATS_PAY_TRANS_INTERFACE.ats_dealdate
  is '资金抽档时间';
comment on column JX_ATS_PAY_TRANS_INTERFACE.ats_dealerrorinfo
  is '资金系统错误处理信息';
comment on column JX_ATS_PAY_TRANS_INTERFACE.ats_returnstate
  is '资金系统返盘状态';
comment on column JX_ATS_PAY_TRANS_INTERFACE.ats_returndate
  is '资金系统返盘时间';
comment on column JX_ATS_PAY_TRANS_INTERFACE.ats_returninfo
  is '资金系统返盘信息';
comment on column JX_ATS_PAY_TRANS_INTERFACE.pay_state
  is '支付状态';
comment on column JX_ATS_PAY_TRANS_INTERFACE.pay_made_date
  is '支付成功日期';
comment on column JX_ATS_PAY_TRANS_INTERFACE.pay_info
  is '交易支付信息';
comment on column JX_ATS_PAY_TRANS_INTERFACE.fail_type
  is '错误类型';
comment on column JX_ATS_PAY_TRANS_INTERFACE.abstract
  is '对账码';
comment on column JX_ATS_PAY_TRANS_INTERFACE.checkbatchno
  is '核对批号';
comment on column JX_ATS_PAY_TRANS_INTERFACE.billtype
  is '票据类型';
comment on column JX_ATS_PAY_TRANS_INTERFACE.billcode
  is '票据号';
comment on column JX_ATS_PAY_TRANS_INTERFACE.refund_state
  is '退票状态';
comment on column JX_ATS_PAY_TRANS_INTERFACE.refund_info
  is '退票信息';
comment on column JX_ATS_PAY_TRANS_INTERFACE.refund_time
  is '退票日期';
comment on column JX_ATS_PAY_TRANS_INTERFACE.recordsource_batno
  is '批次号';
comment on column JX_ATS_PAY_TRANS_INTERFACE.hec_status
  is '接口表状态 0-未导入  1-已导入 4-支付成功  3-支付失败  5-退票 6-暂挂 7-导入失败 8-取消付款 9-重新支付';
comment on column JX_ATS_PAY_TRANS_INTERFACE.inputdate
  is '导入接口表时间';
comment on column JX_ATS_PAY_TRANS_INTERFACE.plan_pay_date
  is '*计划付款时间';
comment on column JX_ATS_PAY_TRANS_INTERFACE.cash_flow_code
  is '*现金流量代码';
comment on column JX_ATS_PAY_TRANS_INTERFACE.payment_account
  is '资金付款账号';
comment on column JX_ATS_PAY_TRANS_INTERFACE.hfm_batch_number
  is '资金付款批次号';
comment on column JX_ATS_PAY_TRANS_INTERFACE.old_urid
  is '重新发送时,原接口ID';
comment on column JX_ATS_PAY_TRANS_INTERFACE.write_tmp_session_id
  is '核销临时表session_id';
comment on column JX_ATS_PAY_TRANS_INTERFACE.audit_status
  is '稽核状态  [SUBMIT]: 提交  [AUDITED] :稽核完成  [REJECTED] : 拒绝';
comment on column JX_ATS_PAY_TRANS_INTERFACE.audit_info
  is '稽核信息';
comment on column JX_ATS_PAY_TRANS_INTERFACE.hfm_payment_org
  is '资金付款机构';
comment on column JX_ATS_PAY_TRANS_INTERFACE.hfm_pay_type_desc
  is '资金付款方式';
comment on column JX_ATS_PAY_TRANS_INTERFACE.hfm_pay_type
  is '资金付款方式';
comment on column JX_ATS_PAY_TRANS_INTERFACE.serialnumber
  is '发送资金交易流水号';
comment on column JX_ATS_PAY_TRANS_INTERFACE.error_message
  is '错误信息,主要记录系统内过账错误';
comment on column JX_ATS_PAY_TRANS_INTERFACE.usedes
  is '报销计划付款行 付款用途';
comment on column JX_ATS_PAY_TRANS_INTERFACE.summary
  is '报销计划付款行 摘要';
comment on column JX_ATS_PAY_TRANS_INTERFACE.audit_time
  is '稽核时间';
comment on column JX_ATS_PAY_TRANS_INTERFACE.read_flag
  is '读取状态 Y：已读  N：未读';
comment on column JX_ATS_PAY_TRANS_INTERFACE.audit_person
  is '稽核人';
comment on column JX_ATS_PAY_TRANS_INTERFACE.receive_date
  is '接收资金回传时间';
comment on column JX_ATS_PAY_TRANS_INTERFACE.post_flag
  is '是否过账 Y：是 N：否';
comment on column JX_ATS_PAY_TRANS_INTERFACE.document_payment_line_id
  is '计划付款行ID';
-- Create/Recreate primary, unique and foreign key constraints 
alter table JX_ATS_PAY_TRANS_INTERFACE
  add constraint PK_JX_ATS_PAY_TRANS_URID primary key (URID)
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
create sequence JX_ATS_PAY_TRANS_INTERFACE_S
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 10;
