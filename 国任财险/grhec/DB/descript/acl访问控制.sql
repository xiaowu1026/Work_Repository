begin
  dbms_network_acl_admin.create_acl(acl         => 'BRWebservice.xml',
                                    description => 'Network permissions for connect bpm',
                                    principal   => 'FKUSER',--���ݿ��û���
                                    is_grant    => TRUE,
                                    privilege   => 'connect');
end;
/
begin
 dbms_network_acl_admin.assign_acl (
 acl => 'BRWebservice.xml',
 host => '10.75.42.45',--��ַ
 lower_port => 7001, --��ַ�˿�
 upper_port => 7001);
end;
/
COMMIT;


