begin
  dbms_network_acl_admin.create_acl(acl         => 'BRWebservice.xml',
                                    description => 'Network permissions for connect bpm',
                                    principal   => 'FKUSER',--数据库用户名
                                    is_grant    => TRUE,
                                    privilege   => 'connect');
end;
/
begin
 dbms_network_acl_admin.assign_acl (
 acl => 'BRWebservice.xml',
 host => '10.75.42.45',--地址
 lower_port => 7001, --地址端口
 upper_port => 7001);
end;
/
COMMIT;


