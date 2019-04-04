--1.赋予用户执行java权限
grant javauserpriv to FKUSER;

--2.在执行如下语句
begin
   dbms_java.grant_permission('FKUSER', 'SYS:java.net.SocketPermission', '10.75.42.45:7001', 'listen,resolve' );
   dbms_java.grant_permission('FKUSER', 'SYS:java.net.SocketPermission', '10.75.42.45:7001', 'connect,resolve' );
   dbms_java.grant_permission('FKUSER','SYS:java.io.FilePermission','*','READ,WRITE');
   dbms_java.grant_permission('FKUSER', 'SYS:java.lang.RuntimePermission', 'writeFileDescriptor', '');
   dbms_java.grant_permission('FKUSER', 'SYS:java.lang.RuntimePermission', 'readFileDescriptor', '');
   dbms_java.grant_permission('FKUSER', 'SYS:java.io.FilePermission', '<<ALL FILES>>', 'execute' );
   dbms_java.grant_permission('FKUSER', 'SYS:java.util.PropertyPermission','file.encoding','write');
end;

