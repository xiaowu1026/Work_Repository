alter table cux_payment_interface add(check_status varchar2(2) default '0');
comment on column CUX_PAYMENT_INTERFACE.check_status
  is '��֧������״̬ 0 δ�޸� 1 ���� 2 �ύ 3 ���� 4 �ܾ�';
