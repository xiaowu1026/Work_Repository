create table ZBX_INTERFACE
(
  MANDT varchar2(3)default '800',
  ZBUKR varchar2(4) not null,
  ZBELN varchar2(17) not null,
  ZBUZE varchar2(6) not null,
  ZBLAR varchar2(6) default 'Y1',
  ZBUDA varchar2(8) not null,
  ZWEAR varchar2(5) not null,
  ZAUSB varchar2(4),
  ZHKON varchar2(10) not null,
  ZSGTX varchar2(50) not null,
  ZANFB varchar2(20),
  ZPOS  varchar2(20),
  ZDealer varchar2(10),
  ZSWRB varchar2(18) not null,
  ZSWR1 varchar2(18) not null,
  ZHWRB varchar2(18) not null,
  ZHWR1 varchar2(18) not null,
  ZKOST varchar2(10),
  ZDIVI varchar2(10),
  ZYHZH varchar2(24),
  ZXJXM varchar2(6),
  ZXZBH varchar2(8),
  ZYWLY varchar2(3),
  ZXBBH varchar2(4),
  ZCXBH varchar2(6),
  ZJNJW varchar2(2),
  ZLIFN varchar2(10),
  PAYTYPE varchar2(3),
  FKBER varchar2(4),
  FISTL varchar2(16),
  FIPOS varchar2(14),
  ZDE10 varchar2(8),
  ZDE11 varchar2(8),
  ZDE12 varchar2(8),
  ZDE13 varchar2(20),
  ZDE14 varchar2(20),
  ZDE15 varchar2(20),
  ZDATE varchar2(8) not null,
  ZTIME TIMESTAMP not null,
  ZFLAG varchar2(1) default '1',
  ZSAPD varchar2(8),
  ZSAPT TIMESTAMP,
  BELNR varchar2(10),
  GJAHR varchar2(4),
  MONAT varchar2(2),
  BUDAT varchar2(8),
  ZDEAL varchar2(1),
  ZRENO varchar2(20),
  ZREVE varchar2(1),
  SerialNO varchar2(20) not null,
  DR number default 0,
  TS varchar2(19) not null
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
comment on table ZBX_INTERFACE
  is 'SAP凭证上传接口表';
-- Add comments to the columns 
comment on column ZBX_INTERFACE.MANDT
  is '客户端 (主Key) 默认800 非空';
comment on column ZBX_INTERFACE.ZBUKR
  is '公司代码(主Key) 对应于核算机构 通过核算机构转换成SAP的公司代码 非空'; 
comment on column ZBX_INTERFACE.ZBELN
  is '报销系统凭证号(主Key) 机构码+年+月+流水 作为每个公司代码下标识一张凭证的唯一代码(参考编码方式：年份（4）+月份（2）+套账（2位，此处从账套识别码出处获得）+凭证号（6）) 非空';  
comment on column ZBX_INTERFACE.ZBUZE
  is '报销系统凭证行项目号(主Key) 凭证分录号 非空';
comment on column ZBX_INTERFACE.ZBLAR
  is '凭证类型 默认“Y1”  非空';
comment on column ZBX_INTERFACE.ZBUDA
  is '记账日期 凭证记账日期 格式：YYYYMMDD 非空';  
comment on column ZBX_INTERFACE.ZWEAR
  is '币种 通过币种换换获得  非空';  
comment on column ZBX_INTERFACE.ZAUSB
  is '系统往来公司代码 （对应于核算单位）可不填 可空'; 
comment on column ZBX_INTERFACE.ZHKON
  is '记账科目 SAP科目号  非空'; 
comment on column ZBX_INTERFACE.ZSGTX
  is '文本摘要 最长50个汉字 非空'; 
comment on column ZBX_INTERFACE.ZANFB
  is '银行参考号 可不填 可空'; 
comment on column ZBX_INTERFACE.ZPOS
  is 'POS机终端号 可不填 可空';
comment on column ZBX_INTERFACE.ZDealer
  is '报销员（报销员的中文名称）可不填 可空';   
comment on column ZBX_INTERFACE.ZSWRB
  is '借方原币金额  非空'; 
comment on column ZBX_INTERFACE.ZSWR1
  is '借方本位币金额（外币要根据汇率折算，汇率取小于等于凭证日期的最近汇率），计算后金额保留两位小数，四舍五入  非空'; 
comment on column ZBX_INTERFACE.ZHWRB
  is '贷方原币金额  非空';
comment on column ZBX_INTERFACE.ZHWR1
  is '贷方本位币金额（外币要根据汇率折算，汇率取小于等于凭证日期的最近汇率），计算后金额保留两位小数，四舍五入  非空';
comment on column ZBX_INTERFACE.ZKOST
  is '成本中心（对应于基层单位）部门与成本中心对应关系中维护的成本中心代码，有就传，没有不传  可空';
comment on column ZBX_INTERFACE.ZDIVI
  is '部门 不填  可空';                
comment on column ZBX_INTERFACE.ZYHZH
  is '银行账号 根据需要填写  可空'; 
comment on column ZBX_INTERFACE.ZXJXM
  is '现金流量项目 确认是否为货币资金类，只针对货币资金类科目做现金流量转换，填写现金流量项目代码 可空'; 
comment on column ZBX_INTERFACE.ZXZBH
  is '险种 根据需要填写  可空'; 
comment on column ZBX_INTERFACE.ZYWLY
  is '业务来源 根据需要填写  可空'; 
comment on column ZBX_INTERFACE.ZXBBH
  is '险别 不填  可空'; 
comment on column ZBX_INTERFACE.ZCXBH
  is '车型 根据需要填写  可空'; 
comment on column ZBX_INTERFACE.ZJNJW
  is '境内境外 不填  可空';   
comment on column ZBX_INTERFACE.ZLIFN
  is '再保/共保供应商 根据需要填写  可空'; 
comment on column ZBX_INTERFACE.PAYTYPE
  is '收付类型 不填  可空'; 
comment on column ZBX_INTERFACE.FKBER
  is '功能范围 可不填（或默认为3000） 可空';   
comment on column ZBX_INTERFACE.FISTL
  is '基金中心 根据科目及成本中心派生规则生成，可不填 可空'; 
comment on column ZBX_INTERFACE.FIPOS
  is '承诺项目 根据科目映射及实际的的承诺项目输入 可空';   
comment on column ZBX_INTERFACE.ZDE10
  is '预留字段1';                   
comment on column ZBX_INTERFACE.ZDE11
  is '预留字段2';  
comment on column ZBX_INTERFACE.ZDE12
  is '预留字段3 根据核算内容输入专属费用标识  可空';   
comment on column ZBX_INTERFACE.ZDE13
  is '预留字段4 根据核算内容输入险类1 可空';    
comment on column ZBX_INTERFACE.ZDE14
  is '预留字段5 根据核算内容输入内部订单号 可空';  
comment on column ZBX_INTERFACE.ZDE15
  is '预留字段6';  
comment on column ZBX_INTERFACE.ZDATE
  is '创建日期(中间表) Yyyymmdd，写入中间表日期  非空';  
comment on column ZBX_INTERFACE.ZTIME
  is '创建时间(中间表) 写入中间表时间hhmmss 非空';  
comment on column ZBX_INTERFACE.ZFLAG
  is '标志位  参考《接口状态标志位的设计》，每次传输时，都将此字段默认写为1 非空';  
comment on column ZBX_INTERFACE.ZSAPD
  is 'SAP更新日期 可不填 格式：YYYYMMDD';  
comment on column ZBX_INTERFACE.ZSAPT
  is 'SAP更新时间 可不填'; 
comment on column ZBX_INTERFACE.BELNR
  is 'SAP凭证号 对账用 可空'; 
comment on column ZBX_INTERFACE.GJAHR
  is 'SAP凭证年度 对账用 可空'; 
comment on column ZBX_INTERFACE.MONAT
  is 'SAP凭证会计期间 对账用 可空';   
comment on column ZBX_INTERFACE.BUDAT
  is 'SAP凭证记账日期 对账用 格式：YYYYMMDD 可空'; 
comment on column ZBX_INTERFACE.ZDEAL
  is '出错处理标识（X 代表已重新处理） CHAR  1 可不填 ';     
comment on column ZBX_INTERFACE.GJAHR
  is 'SAP凭证年度 对账用 可空'; 
comment on column ZBX_INTERFACE.ZRENO
  is '冲销关联报销凭证号 可不填';
comment on column ZBX_INTERFACE.ZREVE
  is '冲销标志(0 冲销凭证 1 被冲销凭证) 可不填';   
comment on column ZBX_INTERFACE.SerialNO
  is '传输唯一流水标识号 报销系统必填';   
comment on column ZBX_INTERFACE.DR
  is '删除标识 默认传0  报销系统必填';
comment on column ZBX_INTERFACE.TS
  is '时间戳 Char  19  格式 YYYY-MM-DD hh:mm:ss (注意DD与hh之间有个空格) 报销系统必填';
-- Create/Recreate indexes 
create index ZBX_INTERFACE_N1 on ZBX_INTERFACE (ZBUKR)
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
create unique index ZBX_INTERFACE_U1 on ZBX_INTERFACE (SerialNO)
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
alter table ZBX_INTERFACE
  add constraint ZBX_INTERFACE_PK primary key (MANDT,ZBUKR,ZBELN,ZBUZE)
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
