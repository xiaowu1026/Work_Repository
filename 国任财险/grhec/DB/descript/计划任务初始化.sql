DECLARE
  v_queue_table_name VARCHAR2(100) := USER||'.'||'SCH_JOB_QUEUE_TABLE';
  --v_queue_name       VARCHAR2(100) := USER||'.'||'SCH_JOB_QUEUE';
BEGIN
  --停止队列，删除队列，删除队列表
  --dbms_aqadm.stop_queue(queue_name => v_queue_name);
  --dbms_aqadm.drop_queue(queue_name => v_queue_name);
  dbms_aqadm.drop_queue_table(queue_table => v_queue_table_name);
END;


DECLARE
  v_queue_table_name VARCHAR2(100) := USER||'.'||'SCH_JOB_QUEUE_TABLE1';
  v_queue_name       VARCHAR2(100) := USER||'.'||'SCH_JOB_QUEUE';
  v_payload_type     VARCHAR2(100) := USER||'.'||'SCH_JOB_OBJ';
BEGIN
  --创建对列表，创建队列，启动队列
  dbms_aqadm.create_queue_table(queue_table        => v_queue_table_name,
                                queue_payload_type => v_payload_type,
                                multiple_consumers => TRUE);

  dbms_aqadm.create_queue(queue_name  => v_queue_name,
                          queue_table => v_queue_table_name,
                          retry_delay => 1);

  dbms_aqadm.start_queue(queue_name => v_queue_name);
END;



DECLARE
  v_queue_name      VARCHAR2(100) := USER||'.'||'SCH_JOB_QUEUE';
  v_subscriber_name VARCHAR2(100) := 'SCH_JOB_SUBSCRIBER';
  v_callback        VARCHAR2(100) := USER||'.'||'SCH_ENQUEUE_NOTIFY';
  v_reginfolist     sys.aq$_reg_info_list;
BEGIN
  -- 删除观察者
  BEGIN
    dbms_aqadm.remove_subscriber(queue_name => v_queue_name,
                                 subscriber => sys.aq$_agent(v_subscriber_name,
                                                             NULL,
                                                             NULL));
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  -- 添加观察者
  dbms_aqadm.add_subscriber(queue_name => v_queue_name,
                            subscriber => sys.aq$_agent(v_subscriber_name,
                                                        NULL,
                                                        NULL));

  --注册回调
  dbms_aq.register(sys.aq$_reg_info_list(sys.aq$_reg_info(v_queue_name || ':' ||
                                                          v_subscriber_name,
                                                          dbms_aq.namespace_aq,
                                                          'plsql://' ||
                                                          v_callback ||
                                                          '?PR=0',
                                                          NULL)),
                   1);
END;


DECLARE
  v_queue_name VARCHAR2(100) := USER||'.'||'SCH_JOB_QUEUE';
BEGIN
  insert into sch_concurrent_job
  (
  JOB_ID,
  DESCRIPTION,
  CREATED_BY,
  CREATION_DATE,
  LAST_UPDATED_BY,
  LAST_UPDATE_DATE,
  QUEUE_NAME
  )
 values
  (
  0,
  '系统初始化',
  0,
  sysdate,
  0,
  sysdate,
  v_queue_name
  );
  commit;
END;

