create or replace view fnd_dimension_values_v as
select v.company_id,
       h.dimension_id,
       h.dimension_code,
       t.dimension_value_id,
       t.dimension_value_code,
       t.description,
       decode(t.enabled_flag, 'Y', v.enabled_flag, t.enabled_flag) enabled_flag,
       t.project_type,
       t.project_status
  from fnd_dimensions               h,
       fnd_dimension_values_vl      t,
       fnd_company_dimension_values v
 where t.dimension_value_id = v.dimension_value_id
   and h.dimension_id = t.dimension_id
      --and h.company_level ='Y'
   and t.summary_flag = 'N'
   and h.system_flag = 'N'
union
select f.company_id,
       t.dimension_id,
       t.dimension_code,
       fc.COMPANY_ID,
       fc.COMPANY_CODE,
       fc.COMPANY_SHORT_NAME,
       decode(decode(fc.start_date_active,
                     null,
                     'N',
                     decode(sign(fc.start_date_active - sysdate),
                            1,
                            'N',
                            -1,
                            'Y')),
              'Y',
              decode(fc.end_date_active,
                     null,
                     'Y',
                     decode(sign(fc.end_date_active - sysdate), -1, 'N', 'Y')),
              'N') enabled_flag,
         null,
         null
  from fnd_dimensions t, fnd_companies_vl fc, fnd_companies f
 where t.dimension_code = 'COMPANY'
union
select e.company_id,
       t.dimension_id,
       t.dimension_code,
       e.unit_id,
       e.unit_code,
       e.DESCRIPTION,
       e.ENABLED_FLAG,
       null,
       null
  from fnd_dimensions t, exp_org_unit_vl e
 where t.dimension_code = 'UNIT'
union
select e.company_id,
       t.dimension_id,
       t.dimension_code,
       e.operation_unit_id,
       e.operation_unit_code,
       e.description,
       e.enabled_flag,
       null,
       null
  from fnd_dimensions t, fnd_operation_units_vl e
 where t.dimension_code = 'OPERATION_UNIT'
union
select e.company_id,
       t.dimension_id,
       t.dimension_code,
       e.POSITION_ID,
       e.POSITION_CODE,
       e.description,
       e.enabled_flag,
       null,
       null
  from fnd_dimensions t, exp_org_position_vl e
 where t.dimension_code = 'POSITION'
union
select e.company_id,
       t.dimension_id,
       t.dimension_code,
       e.employee_id,
       e.employee_code,
       e.name,
       e.employee_enabled_flag as enabled_flag,
       null,
       null
  from fnd_dimensions t, exp_company_employees_v e
 where t.dimension_code = 'EMPLOYEE' and exists(select 1 from 
 exp_employees ee where ee.employee_id=e.employee_id and ee.employee_type_id=(select employee_type_id
 from exp_employee_types eet where eet.employee_type_code='SALESMAN') )
;
