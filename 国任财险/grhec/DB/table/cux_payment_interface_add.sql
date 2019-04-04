alter table cux_payment_interface add(check_status varchar2(2) default '0');
comment on column CUX_PAYMENT_INTERFACE.check_status
  is '重支付复核状态 0 未修改 1 保存 2 提交 3 复核 4 拒绝';
