CREATE OR REPLACE PACKAGE wfl_add_approval_pkg IS
  PROCEDURE wfl_add_user(p_seq_number       NUMBER,
                         p_employee_id      NUMBER,
                         p_session_id       IN OUT NUMBER,
                         p_user_id          NUMBER,
                         p_approval_list_id IN OUT NUMBER);

  PROCEDURE wfl_add_user_ext(p_seq_number           NUMBER,
                             p_employee_id          NUMBER,
                             p_session_id           IN OUT NUMBER,
                             p_user_id              NUMBER,
                             p_approval_list_id_pre NUMBER,
                             p_approval_list_id     OUT NUMBER);

END wfl_add_approval_pkg;
/
CREATE OR REPLACE PACKAGE BODY wfl_add_approval_pkg IS
  PROCEDURE wfl_add_user(p_seq_number       NUMBER,
                         p_employee_id      NUMBER,
                         p_session_id       IN OUT NUMBER,
                         p_user_id          NUMBER,
                         p_approval_list_id IN OUT NUMBER) IS
  BEGIN
    SELECT nvl(p_approval_list_id, wfl_add_approval_list_s.nextval),
           nvl(p_session_id, sys_session_s.nextval)
      INTO p_approval_list_id, p_session_id
      FROM dual;
    INSERT INTO wfl_add_approval_list
      (approval_list_id,
       seq_number,
       employee_id,
       session_id,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (p_approval_list_id,
       p_seq_number,
       p_employee_id,
       p_session_id,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE);
  
  END;

  PROCEDURE wfl_add_user_ext(p_seq_number           NUMBER,
                             p_employee_id          NUMBER,
                             p_session_id           IN OUT NUMBER,
                             p_user_id              NUMBER,
                             p_approval_list_id_pre NUMBER,
                             p_approval_list_id     OUT NUMBER) IS
    v_count   NUMBER;
    v_user_id number;
  BEGIN
    SELECT nvl(p_approval_list_id, wfl_add_approval_list_s.nextval),
           nvl(p_session_id, sys_session_s.nextval)
      INTO p_approval_list_id, p_session_id
      FROM dual;
    p_approval_list_id := p_approval_list_id_pre;
  
    select s.user_id
      into v_user_id
      from sys_user s
     where s.employee_id = p_employee_id;
  
    SELECT COUNT(1)
      INTO v_count
      FROM wfl_add_approval_list wal
     WHERE wal.approval_list_id = p_approval_list_id_pre
       AND wal.employee_id = p_employee_id;
  
    IF (v_count > 0) THEN
      RETURN;
    END IF;
    INSERT INTO wfl_add_approval_list
      (approval_list_id,
       seq_number,
       employee_id,
       session_id,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    VALUES
      (p_approval_list_id_pre,
       p_seq_number,
       /*p_employee_id*/v_user_id,
       p_session_id,
       p_user_id,
       SYSDATE,
       p_user_id,
       SYSDATE);
  
  END;

END wfl_add_approval_pkg;
/
