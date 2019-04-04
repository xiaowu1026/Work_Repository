-- Create table
create table SAP_HEC_GL_INTERFACE
(
  gl_interface_id               NUMBER,
  account_entry_id              number,
  batch_id                      VARCHAR2(50),
  serialno                      VARCHAR2(20),
  hec_company_id                NUMBER,
  transaction_type              VARCHAR2(30),
  transaction_number            VARCHAR2(30),
  transaction_je_line_id        NUMBER,
  set_of_books_id               NUMBER,
  accounting_date               DATE,
  currency_code                 VARCHAR2(15),
  user_je_category_name         VARCHAR2(250),
  user_je_source_name           VARCHAR2(250),
  currency_conversion_date      DATE,
  user_currency_conversion_type VARCHAR2(300),
  currency_conversion_rate      NUMBER,
  segment1                      VARCHAR2(250),
  segment2                      VARCHAR2(250),
  segment3                      VARCHAR2(250),
  segment4                      VARCHAR2(250),
  segment5                      VARCHAR2(250),
  segment6                      VARCHAR2(250),
  segment7                      VARCHAR2(250),
  segment8                      VARCHAR2(250),
  segment9                      VARCHAR2(250),
  segment10                     VARCHAR2(250),
  segment11                     VARCHAR2(250),
  segment12                     VARCHAR2(250),
  segment13                     VARCHAR2(250),
  segment14                     VARCHAR2(250),
  segment15                     VARCHAR2(250),
  segment16                     VARCHAR2(250),
  segment17                     VARCHAR2(250),
  segment18                     VARCHAR2(250),
  segment19                     VARCHAR2(250),
  segment20                     VARCHAR2(250),
  entered_dr                    NUMBER,
  entered_cr                    NUMBER,
  functional_amount_dr                  NUMBER,
  functional_amount_cr                  NUMBER,
  period_name                   VARCHAR2(15),
  reference1                    VARCHAR2(100),
  reference2                    VARCHAR2(240),
  reference4                    VARCHAR2(100),
  reference5                    VARCHAR2(240),
  reference6                    VARCHAR2(100),
  reference7                    VARCHAR2(100),
  reference8                    VARCHAR2(100),
  reference9                    VARCHAR2(100),
  reference10                   VARCHAR2(240),
  attribute1                    VARCHAR2(150),
  attribute2                    VARCHAR2(150),
  attribute3                    VARCHAR2(150),
  attribute4                    VARCHAR2(150),
  attribute5                    VARCHAR2(150),
  attribute6                    VARCHAR2(150),
  attribute7                    VARCHAR2(150),
  attribute8                    VARCHAR2(150),
  attribute9                    VARCHAR2(150),
  attribute10                   VARCHAR2(150),
  attribute11                   VARCHAR2(150),
  attribute12                   VARCHAR2(150),
  attribute13                   VARCHAR2(150),
  attribute14                   VARCHAR2(150),
  attribute15                   VARCHAR2(150),
  attribute16                   VARCHAR2(150),
  attribute17                   VARCHAR2(150),
  attribute18                   VARCHAR2(150),
  attribute19                   VARCHAR2(150),
  attribute20                   VARCHAR2(150),
  line_desc                     VARCHAR2(240),
  accounting_period_num         VARCHAR2(15),
  currency_conversion_type      VARCHAR2(30),
  imported_flag                 VARCHAR2(1),
  creation_date                 DATE,
  created_by                    NUMBER,
  last_update_date              DATE,
  last_update_by                VARCHAR2(30)
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
comment on table SAP_HEC_GL_INTERFACE
  is 'HEC传SAP接口表';
-- Add comments to the columns 
comment on column SAP_HEC_GL_INTERFACE.gl_interface_id
  is '总账对应id';
comment on column SAP_HEC_GL_INTERFACE.batch_id
  is 'sap凭证号';
comment on column SAP_HEC_GL_INTERFACE.serialno
  is 'sap唯一流水标识号';  
comment on column SAP_HEC_GL_INTERFACE.set_of_books_id
  is '帐套id';
comment on column SAP_HEC_GL_INTERFACE.accounting_date
  is '凭证日期';
comment on column SAP_HEC_GL_INTERFACE.currency_code
  is '币种';
comment on column SAP_HEC_GL_INTERFACE.user_je_category_name
  is '凭证类别描述';
comment on column SAP_HEC_GL_INTERFACE.user_je_source_name
  is '来源名称';
comment on column SAP_HEC_GL_INTERFACE.currency_conversion_date
  is '汇率日期';
comment on column SAP_HEC_GL_INTERFACE.user_currency_conversion_type
  is '币种汇率类型';
comment on column SAP_HEC_GL_INTERFACE.currency_conversion_rate
  is '汇率日期';
comment on column SAP_HEC_GL_INTERFACE.segment1
  is '公司段';
comment on column SAP_HEC_GL_INTERFACE.segment2
  is '成本中心段';
comment on column SAP_HEC_GL_INTERFACE.segment3
  is ' 核算科目段';
comment on column SAP_HEC_GL_INTERFACE.segment4
  is ' 承诺项目段';
comment on column SAP_HEC_GL_INTERFACE.segment5
  is '内部订单段';
comment on column SAP_HEC_GL_INTERFACE.segment6
  is '银行账号段';
comment on column SAP_HEC_GL_INTERFACE.segment7
  is '现金流量项目段';
comment on column SAP_HEC_GL_INTERFACE.segment8
  is '险种段';
comment on column SAP_HEC_GL_INTERFACE.segment9
  is '险类1段';
comment on column SAP_HEC_GL_INTERFACE.segment10
  is '专属费用标识段';
comment on column SAP_HEC_GL_INTERFACE.segment11
  is '业务来源(渠道)段';
comment on column SAP_HEC_GL_INTERFACE.segment12
  is '基金中心段';
comment on column SAP_HEC_GL_INTERFACE.segment13
  is '属性13';
comment on column SAP_HEC_GL_INTERFACE.segment14
  is '属性14';
comment on column SAP_HEC_GL_INTERFACE.segment15
  is '客商辅助段';
comment on column SAP_HEC_GL_INTERFACE.segment16
  is '属性16';
comment on column SAP_HEC_GL_INTERFACE.segment17
  is '属性17';
comment on column SAP_HEC_GL_INTERFACE.segment18
  is '属性18';
comment on column SAP_HEC_GL_INTERFACE.segment19
  is '属性19';
comment on column SAP_HEC_GL_INTERFACE.segment20
  is '属性20';
comment on column SAP_HEC_GL_INTERFACE.entered_dr
  is '原币借方金额';
comment on column SAP_HEC_GL_INTERFACE.entered_cr
  is '原币贷方金额';
comment on column SAP_HEC_GL_INTERFACE.functional_amount_dr
  is '本币借方金额';
comment on column SAP_HEC_GL_INTERFACE.functional_amount_cr
  is '本币贷方金额';
comment on column SAP_HEC_GL_INTERFACE.period_name
  is '期间';
comment on column SAP_HEC_GL_INTERFACE.reference1
  is '参照1';
comment on column SAP_HEC_GL_INTERFACE.reference2
  is '参照2';
comment on column SAP_HEC_GL_INTERFACE.reference4
  is '参照4';
comment on column SAP_HEC_GL_INTERFACE.reference5
  is '参照5';
comment on column SAP_HEC_GL_INTERFACE.reference6
  is '参照6';
comment on column SAP_HEC_GL_INTERFACE.reference7
  is '参照7';
comment on column SAP_HEC_GL_INTERFACE.reference8
  is '参照8';
comment on column SAP_HEC_GL_INTERFACE.reference9
  is '参照9';
comment on column SAP_HEC_GL_INTERFACE.reference10
  is '参照10';
comment on column SAP_HEC_GL_INTERFACE.attribute1
  is '字段1';
comment on column SAP_HEC_GL_INTERFACE.attribute2
  is '字段2';
comment on column SAP_HEC_GL_INTERFACE.attribute3
  is '字段3';
comment on column SAP_HEC_GL_INTERFACE.attribute4
  is '字段4';
comment on column SAP_HEC_GL_INTERFACE.attribute5
  is '字段5';
comment on column SAP_HEC_GL_INTERFACE.attribute6
  is '字段6';
comment on column SAP_HEC_GL_INTERFACE.attribute7
  is '字段7';
comment on column SAP_HEC_GL_INTERFACE.attribute8
  is '字段8';
comment on column SAP_HEC_GL_INTERFACE.attribute9
  is '字段9';
comment on column SAP_HEC_GL_INTERFACE.attribute10
  is '字段10';
comment on column SAP_HEC_GL_INTERFACE.attribute11
  is '字段11';
comment on column SAP_HEC_GL_INTERFACE.attribute12
  is '字段12';
comment on column SAP_HEC_GL_INTERFACE.attribute13
  is '字段13';
comment on column SAP_HEC_GL_INTERFACE.attribute14
  is '字段14';
comment on column SAP_HEC_GL_INTERFACE.attribute15
  is '字段15';
comment on column SAP_HEC_GL_INTERFACE.attribute16
  is '字段16';
comment on column SAP_HEC_GL_INTERFACE.attribute17
  is '字段17';
comment on column SAP_HEC_GL_INTERFACE.attribute18
  is '字段18';
comment on column SAP_HEC_GL_INTERFACE.attribute19
  is '字段19';
comment on column SAP_HEC_GL_INTERFACE.attribute20
  is '字段20';
comment on column SAP_HEC_GL_INTERFACE.line_desc
  is '行描述';
comment on column SAP_HEC_GL_INTERFACE.accounting_period_num
  is '期间编码';
comment on column SAP_HEC_GL_INTERFACE.currency_conversion_type
  is '币种汇率类型';
comment on column SAP_HEC_GL_INTERFACE.imported_flag
  is '流入标识,N：未传送
T：已导入SAP
Y：成功导入日记账
E：错误';
comment on column SAP_HEC_GL_INTERFACE.creation_date
  is '创建日期';
comment on column SAP_HEC_GL_INTERFACE.created_by
  is '创建用户ID';
comment on column SAP_HEC_GL_INTERFACE.last_update_date
  is '最后更新日期';
comment on column SAP_HEC_GL_INTERFACE.last_update_by
  is '最后更新用户ID';
comment on column SAP_HEC_GL_INTERFACE.hec_company_id
  is 'HEC公司id';
comment on column SAP_HEC_GL_INTERFACE.transaction_type
  is '事务类型';
-- Create/Recreate indexes 
create index SAP_HEC_GL_INTERFACE_N1 on SAP_HEC_GL_INTERFACE (BATCH_ID, GL_INTERFACE_ID)
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
create index SAP_HEC_GL_INTERFACE_N2 on SAP_HEC_GL_INTERFACE (HEC_COMPANY_ID, IMPORTED_FLAG)
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
create index SAP_HEC_GL_INTERFACE_N3 on SAP_HEC_GL_INTERFACE (SET_OF_BOOKS_ID, IMPORTED_FLAG)
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
create unique index SAP_HEC_GL_INTERFACE_PK on SAP_HEC_GL_INTERFACE (GL_INTERFACE_ID)
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
