create or replace package image_types_pkg is

  -- Author  : LUQIANG
  -- Created : 2018/9/28 10:07:46
  -- Purpose : 影项类型操作包

  --影像类型插入
  procedure insert_image_type(p_image_type_code        number,
                              p_image_type_description varchar2,
                              p_enable_flag            varchar,
                              p_create_user_id         number);

  --影像类型更新                           
  procedure update_image_type(p_iamge_type_id          number,
                              p_image_type_code        number,
                              p_image_type_description varchar2,
                              p_enable_flag            varchar,
                              p_update_user_id         number);

  --查询类型ID序列
  function get_image_type_seq return number;
end image_types_pkg;
/
create or replace package body image_types_pkg is

  procedure insert_image_type(p_image_type_code        number,
                              p_image_type_description varchar2,
                              p_enable_flag            varchar,
                              p_create_user_id         number) is
    v_image_type_id number;
  begin
     v_image_type_id:=get_image_type_seq;
     
     insert into image_types
       (image_type_id,
        image_type_code,
        image_type_description,
        enable_flag,
        creation_date,
        created_by,
        last_update_date,
        last_updated_by)
     values
       (v_image_type_id,
        p_image_type_code,
        p_image_type_description,
        p_enable_flag,
        sysdate,
        p_create_user_id,
        sysdate,
        p_create_user_id);
  end;

   procedure update_image_type(p_iamge_type_id          number,
                               p_image_type_code        number,
                               p_image_type_description varchar2,
                               p_enable_flag            varchar,
                               p_update_user_id         number) is
   
   begin
     update image_types i
        set i.image_type_code        = p_image_type_code,
            i.image_type_description = p_image_type_description,
            i.enable_flag            = p_enable_flag,
            i.last_update_date       = sysdate,
            i.last_updated_by        = p_update_user_id
      where i.image_type_id = p_iamge_type_id;
   end;



  function get_image_type_seq  return number is
       v_image_type_id number;
    begin
      select image_type_seq.nextval 
      into v_image_type_id
      from dual;
      
      return v_image_type_id;
      
    end;
end image_types_pkg;
/
