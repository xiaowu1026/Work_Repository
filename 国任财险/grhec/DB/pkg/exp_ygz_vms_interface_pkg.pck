create or replace package exp_ygz_vms_interface_pkg is

  -- Author  : HM
  -- Created : 2016/6/21 15:42:34
  -- Purpose : 营改增-增值税平台接口包

  -- Public constant declarations
  g_ws_url       constant varchar2(300) := sys_parameter_pkg.value('VMS_INTERFACE_WS_URL') ||
                                           '/nc.itf.yyitf.synchdata.IPfxxWs';
  g_ws_query_url constant varchar2(300) := sys_parameter_pkg.value('VMS_INTERFACE_WS_URL') ||
                                           '/IExoSysStandardQuery';

  g_enabled_flag constant char(1) := sys_parameter_pkg.value('VMS_INTERFACE_ENABLED');

  g_user constant varchar2(20) := '';

  -- Public type declarations
  type vat_record is record(
    doc_header_id              number,
    doc_line_id                number,
    doc_number                 varchar2(30),
    doc_date                   varchar2(10),
    company_code               varchar2(100),
    invoice_type               number,
    invoice_number             varchar2(100),
    invoice_code               varchar2(100),
    invoice_date               varchar2(30),
    report_amount              number,
    tax_amount                 number,
    no_tax_amount              number,
    tax_rate                   number,
    input_tax_structure_detail varchar2(20),
    usage_type                 varchar2(20),
    dkstatus                   number,
    isaofaset                  char(1),
    issale                     char(1),
    journal_date               date,
    creator_id                 number,
    creator_name               varchar2(30),
    description                varchar2(3000),
    subject                    varchar2(20),
    segment1                   varchar2(20),
    segment2                   varchar2(20),
    segment3                   varchar2(20),
    segment4                   varchar2(20),
    segment5                   varchar2(20),
    segment6                   varchar2(20),
    segment7                   varchar2(20),
    segment8                   varchar2(20),
    segment9                   varchar2(20),
    segment10                  varchar2(20),
    segment11                  varchar2(20),
    usage_type_origin          varchar2(20),
    line_number                number,
    returnitem                 varchar2(10));

  -- Public variable declarations
  -- 进项税票接口报文
  c_inv_vat_xml varchar2(10000) := '<?xml version="1.0" encoding="UTF-8"?>
<ufinterface account="shrs" billtype="HQIB" filename="" groupcode="" sender="lis">
    <bill id="#billnum##billcode#">
      <billhead> 
        <pk_inibillmage></pk_inibillmage>
        <pk_group>#pk_group#</pk_group>
        <pk_org>#pk_org#</pk_org>
        <pk_org_v></pk_org_v>
        <vperiod>#vperiod#</vperiod>
        <taxperiod>#taxperiod#</taxperiod>
        <taxbilltype>#taxbilltype#</taxbilltype>
        <pk_taxorgtally>#pk_taxorgtally#</pk_taxorgtally>
        <billnum>#billnum#</billnum>
        <billcode>#billcode#</billcode>
        <opendate>#opendate#</opendate>
        <pk_supplier></pk_supplier>
        <outtaxno></outtaxno>
        <outname>#outname#</outname>
        <localamt>#localamt#</localamt>
        <localtax>#localtax#</localtax>
        <gstype>#gstype#</gstype>
        <indetail>#indetail#</indetail>
        <decrange>#decrange#</decrange>
        <dkstatus>#dkstatus#</dkstatus>
        <returnitem>#returnitem#</returnitem>
        <dectype>#dectype#</dectype>
        <billstatus>#billstatus#</billstatus>
        <accstatus>#accstatus#</accstatus>
        <authstatus>#authstatus#</authstatus>
        <authdate></authdate>
        <isaofaset>#isaofaset#</isaofaset>
        <isreturn>#isreturn#</isreturn>
        <issale>#issale#</issale>
        <isback></isback>
        <islost></islost>
        <creator>#creator#</creator>
        <creationtime>#creationtime#</creationtime>
        <modifier></modifier>
        <modifiedtime></modifiedtime>
        <remark>#remark#</remark>
        <billno>#billno#</billno>
        <billdate>#billdate#</billdate>
        <busitype>#busitype#</busitype>
        <billmaker>#billmaker#</billmaker>
        <approver></approver>
        <approvedate></approvedate>
        <approvestatus>#approvestatus#</approvestatus>
        <approvenote></approvenote>
        <transtype></transtype>
        <billtype></billtype>
        <transtypepk></transtypepk>
        <srcbilltype></srcbilltype>
        <srcbillid>#srcbillid#</srcbillid>
        <emendenum>#emendenum#</emendenum>
        <billversionpk></billversionpk>
        <vdef1></vdef1>
        <vdef2></vdef2>
        <vdef3></vdef3>
        <vdef4></vdef4>
        <vdef5></vdef5>
        <def1></def1>
        <def2></def2>
        <def3></def3>
        <def4></def4>
        <def5></def5>
        <def6></def6>
        <def7></def7>
        <def8></def8>
        <def9></def9>
        <def10></def10>
        <def11></def11>
        <def12></def12>
        <def13></def13>
        <def14></def14>
        <def15></def15>
        <def16></def16>
        <def17></def17>
        <def18></def18>
        <def19></def19>
        <def20></def20>
        <id_vtinibillmagenewvob>
            <item>
                <pk_inibillmage_b></pk_inibillmage_b>
                <pk_inibillmage></pk_inibillmage>
                <pk_taxitem>#pk_taxitem#</pk_taxitem>
                <model></model>
                <company></company>
                <price></price>
                <vnum></vnum>
                <localamt>#localamt#</localamt>
                <taxrate>#taxrate#</taxrate>
                <localtax>#localtax#</localtax>
                <remark>#remark#</remark>
                <rowno></rowno>
                <indetail>#indetail#</indetail>
                <decrange>#decrange#</decrange>
                <dectype>#dectype#</dectype>
                <dkstatus>#dkstatus#</dkstatus>
                <returnitem>#returnitem#</returnitem>
                <voucherid></voucherid>
                <subject>#subject#</subject>
                <account></account>
                <srcflag>#srcflag#</srcflag>
                <vdef1></vdef1>
                <vdef2></vdef2>
                <vdef3></vdef3>
                <vdef4></vdef4>
                <vdef5></vdef5>
                <def1>#def1#</def1>
                <def2>#def2#</def2>
                <def3>#def3#</def3>
                <def4>#def4#</def4>
                <def5>#def5#</def5>
                <def6>#def6#</def6>
                <def7>#def7#</def7>
                <def8>#def8#</def8>
                <def9>#def9#</def9>
                <def10>#def10#</def10>
                <def11>#def11#</def11>
                <def12></def12>
                <def13></def13>
                <def14></def14>
                <def15></def15>
                <def16></def16>
                <def17></def17>
                <def18></def18>
                <def19></def19>
                <def20></def20>
                <voucherno></voucherno>
                <detail></detail>
                <busipk>#busipk#</busipk>
              </item>
       </id_vtinibillmagenewvob>
      </billhead>
    </bill>
</ufinterface>';

  --进项税转出接口报文  
  /*c_inv_roll_out_xml varchar2(10000) := '<?xml version="1.0" encoding="UTF-8"?>
  <ufinterface account="shrs" billtype="HQID" filename="" groupcode="" sender="lis">
      <bill id="#billnum##billcode#">
          <billhead>
              <pk_intrundetail></pk_intrundetail>
              <pk_group>#pk_group#</pk_group>
              <pk_org>#pk_org#</pk_org>
              <pk_org_v></pk_org_v>
              <pk_taxorgtally>#pk_taxorgtally#</pk_taxorgtally>
              <vperiod>#vperiod#</vperiod>
              <taxperiod>#taxperiod#</taxperiod>
              <returnperiod>#returnperiod#</returnperiod>
              <busireason></busireason>
              <returnitem>#returnitem#</returnitem>
              <returnamt>#returnamt#</returnamt>
              <returnrate>#returnrate#</returnrate>
              <localtax>#localtax#</localtax>
              <taxrate>#taxrate_r#</taxrate>
              <decrange>#decrange#</decrange>
              <dectype>#dectype#</dectype>
              <voucherid></voucherid>
              <subject></subject>
              <account></account>
              <billnum>#billnum#</billnum>
              <billcode>#billcode#</billcode>
              <indetail>#indetail#</indetail>
              <returntax>#returntax#</returntax>
              <isback></isback>
              <dkstatus></dkstatus>
              <srcflag>#srcflag_r#</srcflag>
              <srcbillid></srcbillid>
              <srcbillbid></srcbillbid>
              <srcbilltype></srcbilltype>
              <creator>#creator#</creator>
              <creationtime>#creationtime#</creationtime>
              <modifier></modifier>
              <modifiedtime></modifiedtime>
              <remark></remark>
              <billdate>#billdate#</billdate>
              <billno>#billno#</billno>
              <busitype></busitype>
              <billmaker></billmaker>
              <approver></approver>
              <approvedate></approvedate>
              <approvestatus>#approvestatus#</approvestatus>
              <approvenote></approvenote>
              <transtype></transtype>
              <billtype></billtype>
              <transtypepk></transtypepk>
              <emendenum></emendenum>
              <billversionpk></billversionpk>
              <def1></def1>
              <def2></def2>
              <def3></def3>
              <def4></def4>
              <def5></def5>
              <busipk>#busipk#</busipk>
          </billhead>
      </bill>
  </ufinterface>';*/

  --发票认证查询接口报文
  c_inv_query_xml varchar2(5000) := '<?xml version="1.0" encoding="UTF-8"?>
<ufinterface querycode="JXCX001" sender="lis"><bill id="#billnum##billcode#"><billhead><billnum>#billnum#</billnum><billcode>#billcode#</billcode></billhead></bill></ufinterface>';

  --视同销售接口报文
  /*c_inv_deemed_sales_xml varchar2(10000) := '<?xml version="1.0" encoding="UTF-8"?>
  <ufinterface account="shrs" billtype="HQIE" filename="" groupcode="" sender="lis">
      <bill id="#billnum##billcode#">
          <billhead>
              <pk_assale></pk_assale>
              <pk_group>#pk_group#</pk_group>
              <pk_org>#pk_org#</pk_org>
              <pk_org_v></pk_org_v>
              <pk_taxorgtally>#pk_taxorgtally#</pk_taxorgtally>
              <vperiod>#vperiod#</vperiod>
              <taxperiod>#taxperiod#</taxperiod>
              <busireason></busireason>
              <taxcate>#taxcate#</taxcate>
              <salerate>#salerate#</salerate>
              <saleamt>#saleamt#</saleamt>
              <salemoney>#salemoney#</salemoney>
              <saletax>#saletax#</saletax>
              <areatype>#areatype#</areatype>
              <drawback></drawback>
              <voucherid></voucherid>
              <subject></subject>
              <account></account>
              <billnum>#billnum#</billnum>
              <billcode>#billcode#</billcode>
              <indetail>#indetail#</indetail>
              <taxrate>#taxrate#</taxrate>
              <dkstatus>#dkstatus#</dkstatus>
              <srcflag>#srcflag_r#</srcflag>
              <decperiod></decperiod>
              <creationtime>#creationtime#</creationtime>
              <modifiedtime></modifiedtime>
              <creator>#creator#</creator>
              <modifier></modifier>
              <emendenum></emendenum>
              <transtypepk></transtypepk>
              <billtype></billtype>
              <transtype></transtype>
              <approvenote></approvenote>
              <approvestatus>#approvestatus#</approvestatus>
              <approvedate></approvedate>
              <approver></approver>
              <billmaker></billmaker>
              <busitype></busitype>
              <billno>#billno#</billno>
              <billdate>#billdate#</billdate>
              <billversionpk></billversionpk>
              <srcbillid></srcbillid>
              <srcbillbid></srcbillbid>
              <srcbilltype></srcbilltype>
              <vdef1></vdef1>
              <vdef2></vdef2>
              <vdef3></vdef3>
              <vdef4></vdef4>
              <vdef5></vdef5>
              <def1></def1>
              <def2></def2>
              <def3></def3>
              <def4></def4>
              <def5></def5>
              <busipk>#busipk#</busipk>
          </billhead>
      </bill>
  </ufinterface>';*/

  -- Public function and procedure declarations

  --进项税票接口
  procedure inv_vat(p_exp_report_line_id number);

  --进项税转出接口
  /*procedure inv_roll_out(p_exp_report_line_id number);*/

  --发票认证查询接口
  procedure inv_query(p_exp_report_line_id number);

  --视同销售接口
  /*procedure inv_deemed_sales(p_exp_report_line_id number);*/

  --报销单复核事件——调用进项税票接口
  function exp_inv_vat_post_vms_event(p_event_record_id number,
                                      p_log_id          number,
                                      p_event_param     number,
                                      p_created_by      number) return number;

  --转出复核事件——调用进项税转出接口
  /*function exp_roll_out_post_vms_event(p_event_record_id number,
                                     p_log_id          number,
                                     p_event_param     number,
                                     p_created_by      number)
  return number;*/

  --审批事件——调用发票接口
  function exp_inv_query_vms_event(p_event_record_id number,
                                   p_log_id          number,
                                   p_event_param     number,
                                   p_created_by      number) return number;

  --君康人寿-节点后过程-执行发票验证
  function jk_exp_inv_query_vms(p_instance_id number,
                                p_node_id     number,
                                p_result      out varchar2) return varchar2;

  --君康人寿请求-全部审核和提交单据，调用进项税票接口
  procedure jk_exp_inv_query_all_vms;
end exp_ygz_vms_interface_pkg;
/
create or replace package body exp_ygz_vms_interface_pkg is

  -- Function and procedure implementations

  FUNCTION get_request_xml(p_src_xml VARCHAR2, p_param vat_record)
    RETURN VARCHAR2 IS
    v_request_xml VARCHAR2(10000);
  BEGIN
  
    v_request_xml := REPLACE(p_src_xml, '#pk_group#', '01'); --空
    v_request_xml := REPLACE(v_request_xml,
                             '#pk_org#',
                             p_param.company_code);
    v_request_xml := REPLACE(v_request_xml,
                             '#vperiod#',
                             to_char(p_param.journal_date, 'yyyy-mm'));
    v_request_xml := REPLACE(v_request_xml,
                             '#taxperiod#',
                             to_char(p_param.journal_date, 'yyyy-mm') ||
                             '-01');
    v_request_xml := REPLACE(v_request_xml,
                             '#taxbilltype#',
                             p_param.invoice_type);
    v_request_xml := REPLACE(v_request_xml,
                             '#pk_taxorgtally#',
                             p_param.company_code);
    v_request_xml := REPLACE(v_request_xml, '#pk_taxitem#', '1'); --应税产品
    v_request_xml := REPLACE(v_request_xml,
                             '#billnum#',
                             p_param.invoice_number);
    v_request_xml := REPLACE(v_request_xml,
                             '#billcode#',
                             p_param.invoice_code);
    v_request_xml := REPLACE(v_request_xml,
                             '#opendate#',
                             p_param.invoice_date);
    v_request_xml := REPLACE(v_request_xml, '#gstype#', '0'); --归属类型：财务发票
    v_request_xml := REPLACE(v_request_xml, '#outname#', '测试集团');
    v_request_xml := REPLACE(v_request_xml,
                             '#localamt#',
                             trim(to_char(p_param.no_tax_amount,
                                          '99999999999990.99')));
    v_request_xml := REPLACE(v_request_xml,
                             '#taxrate#',
                             trim(to_char(p_param.tax_rate, '0.99')));
    v_request_xml := REPLACE(v_request_xml,
                             '#localtax#',
                             trim(to_char(p_param.tax_amount,
                                          '99999999999990.99')));
    v_request_xml := REPLACE(v_request_xml,
                             '#indetail#',
                             p_param.input_tax_structure_detail);
    v_request_xml := REPLACE(v_request_xml, '#decrange#', '1'); --申报范围：属地申报
    v_request_xml := REPLACE(v_request_xml, '#dectype#', p_param.usage_type);
    v_request_xml := REPLACE(v_request_xml, '#billstatus#', '2'); --发票状态：正常
    v_request_xml := REPLACE(v_request_xml, '#dkstatus#', p_param.dkstatus); --抵扣类型
    v_request_xml := REPLACE(v_request_xml,
                             '#returnitem#',
                             p_param.returnitem);
    v_request_xml := REPLACE(v_request_xml, '#accstatus#', '2'); --记账状态：已记账
    v_request_xml := REPLACE(v_request_xml, '#authstatus#', '0'); --认证状态：未认证
    v_request_xml := REPLACE(v_request_xml,
                             '#billno#',
                             p_param.doc_number || p_param.line_number);
    v_request_xml := REPLACE(v_request_xml, '#billdate#', p_param.doc_date);
    v_request_xml := REPLACE(v_request_xml,
                             '#busitype#',
                             p_param.usage_type_origin);
    v_request_xml := REPLACE(v_request_xml,
                             '#isaofaset#',
                             p_param.isaofaset);
    v_request_xml := REPLACE(v_request_xml, '#isreturn#', 'N'); --转出状态：未转出
    v_request_xml := REPLACE(v_request_xml, '#issale#', p_param.issale);
    v_request_xml := REPLACE(v_request_xml, '#srcflag#', '02'); --固定值02
    v_request_xml := REPLACE(v_request_xml,
                             '#approvestatus#',
                             '' --'-1'
                             ); --审批状态
    v_request_xml := REPLACE(v_request_xml,
                             '#creator#',
                             p_param.creator_name);
    v_request_xml := REPLACE(v_request_xml,
                             '#creationtime#',
                             to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
    v_request_xml := REPLACE(v_request_xml,
                             '#billmaker#',
                             p_param.creator_id);
    v_request_xml := REPLACE(v_request_xml,
                             '#srcbillid#',
                             p_param.doc_header_id);
    v_request_xml := REPLACE(v_request_xml, '#remark#', p_param.description);
    v_request_xml := REPLACE(v_request_xml, '#subject#', p_param.subject);
    v_request_xml := REPLACE(v_request_xml, '#def1#', p_param.segment1);
    v_request_xml := REPLACE(v_request_xml, '#def2#', p_param.segment2);
    v_request_xml := REPLACE(v_request_xml, '#def3#', p_param.segment3);
    v_request_xml := REPLACE(v_request_xml, '#def4#', p_param.segment4);
    v_request_xml := REPLACE(v_request_xml, '#def5#', p_param.segment5);
    v_request_xml := REPLACE(v_request_xml, '#def6#', p_param.segment6);
    v_request_xml := REPLACE(v_request_xml, '#def7#', p_param.segment7);
    v_request_xml := REPLACE(v_request_xml, '#def8#', p_param.segment8);
    v_request_xml := REPLACE(v_request_xml, '#def9#', p_param.segment9);
    v_request_xml := REPLACE(v_request_xml, '#def10#', p_param.segment10);
    v_request_xml := REPLACE(v_request_xml, '#def11#', p_param.segment11);
    v_request_xml := REPLACE(v_request_xml,
                             '#busipk#',
                             --fnd_code_rule_pkg.get_rule_next_auto_num(p_document_category => 'VMS_BUSINESS',
                             --                                         p_document_type     => null,
                             --                                         p_company_id        => '',
                             --                                         p_operation_unit_id => '',
                             --                                         p_operation_date    => SYSDATE,
                             --                                         p_created_by        => 1)
                             p_param.doc_number || p_param.line_number);
    v_request_xml := REPLACE(v_request_xml, '#emendenum#', '0');
  
    /*v_request_xml := REPLACE(v_request_xml,
                             '#returnperiod#',
                             to_char(p_param.journal_date, 'yyyy-mm'));
    v_request_xml := REPLACE(v_request_xml,
                             '#returnamt#',
                             trim(to_char(p_param.no_tax_amount,
                                          '99999999999990.99')));
    v_request_xml := REPLACE(v_request_xml,
                             '#returnrate#',
                             trim(to_char(p_param.roll_out_amount,
                                          '99999999999990.99')));
    v_request_xml := REPLACE(v_request_xml,
                             '#returntax#',
                             trim(to_char(p_param.tax_rate, '0.99')));
    v_request_xml := REPLACE(v_request_xml,
                             '#taxrate_r#',
                             trim(to_char(p_param.roll_out_per, '0.99')));
    v_request_xml := REPLACE(v_request_xml, '#areatype#', '1');
    v_request_xml := REPLACE(v_request_xml, '#srcflag_r#', '1');
    
    v_request_xml := REPLACE(v_request_xml, '#taxcate#', '306');
    v_request_xml := REPLACE(v_request_xml,
                             '#salemoney#',
                             trim(to_char(p_param.no_tax_amount,
                                          '99999999999990.99')));
    v_request_xml := REPLACE(v_request_xml,
                             '#salerate#',
                             trim(to_char(p_param.tax_rate, '0.99')));
    v_request_xml := REPLACE(v_request_xml, '#saletax#', p_param.tax_amount);
    v_request_xml := REPLACE(v_request_xml,
                             '#saleamt#',
                             trim(to_char(p_param.report_amount,
                                          '99999999999990.99')));*/
    RETURN v_request_xml;
  END;

  function get_company(p_company_code varchar2) return varchar2 is
    v_company varchar2(30);
  begin
    /*case substr(p_company_code, 0, 8)
      when '1100000' then
        v_company := '86000000';
      when '1111000' then
        v_company := '86110000';
      when '11230000' then
        v_company := '86230000';
      when '11230200' then
        v_company := '86230200';
      when '11230300' then
        v_company := '86230300';
      when '11230400' then
        v_company := '86230400';
      when '11230600' then
        v_company := '86230600';
      when '11230800' then
        v_company := '86230800';
      when '11231000' then
        v_company := '86231000';
      when '11231100' then
        v_company := '86231100';
      when '11231200' then
        v_company := '86231200';
      when '11310000' then
        v_company := '86310000';
      when '11320000' then
        v_company := '86320000';
      when '11320200' then
        v_company := '86320200';
      when '11320300' then
        v_company := '86320300';
      when '11320600' then
        v_company := '86320600';
      when '11320700' then
        v_company := '86320700';
      when '11320900' then
        v_company := '86320900';
      when '11321000' then
        v_company := '86321000';
      when '11321100' then
        v_company := '86321100';
      when '11330000' then
        v_company := '86330000';
      when '11330400' then
        v_company := '86330400';
      when '11330800' then
        v_company := '86330800';
      when '11331000' then
        v_company := '86331000';
      else
        v_company := '';
    end case;*/
  
    select '86' || substr(fc.company_code, 3, 6)
      into v_company
      from fnd_companies fc
     where fc.company_code = p_company_code;
  
    return v_company;
  exception
    when others then
      return '';
  end;

  function inv_xml_packing(p_xml varchar2) return varchar2 is
    v_begin_xml varchar2(1000) := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ipf="http://synchdata.yyitf.itf.nc/IPfxxWs">
   <soapenv:Header/>
   <soapenv:Body>
      <ipf:synchronizeData>
         <string><![CDATA[
         ';
    v_end_xml   varchar2(1000) := '
    ]]></string>
      </ipf:synchronizeData>
   </soapenv:Body>
</soapenv:Envelope>';
  begin
    return v_begin_xml || p_xml || v_end_xml;
  end;

  function inv_xml_unpacking(p_xml sys.xmltype) return sys.xmltype is
    v_result_str varchar2(10000);
    v_result_xml sys.xmltype;
  begin
    v_result_str := p_xml.extract('/soap:Envelope/soap:Body/ns1:synchronizeDataResponse/return')
                    .getstringval();
  
    v_result_str := REPLACE(v_result_str, '<![CDATA[', '');
    v_result_str := REPLACE(v_result_str, ']]>', '');
  
    v_result_str := REPLACE(v_result_str, '&lt;', '<');
    v_result_str := REPLACE(v_result_str, '&gt;', '>');
  
    v_result_xml := sys.xmltype.createXML(v_result_str);
  
    return v_result_xml;
  end;

  function inv_query_xml_packing(p_xml varchar2) return varchar2 is
    v_begin_xml varchar2(1000) := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:iex="http://querydata.yyitf.itf.nc/IExoSysStandardQuery">
   <soapenv:Header/>
   <soapenv:Body>
      <iex:exoSysQuery>
         <!--Optional:-->
         <string><![CDATA[
         ';
    v_end_xml   varchar2(1000) := '
    ]]></string>
      </iex:exoSysQuery>
   </soapenv:Body>
</soapenv:Envelope>';
  begin
    return v_begin_xml || p_xml || v_end_xml;
  end;

  function inv_query_xml_unpacking(p_xml sys.xmltype) return sys.xmltype is
    v_result_str varchar2(10000);
    v_result_xml sys.xmltype;
  begin
  
    v_result_str := REPLACE(v_result_str, '<![CDATA[', '');
    v_result_str := REPLACE(v_result_str, ']]>', '');
  
    v_result_str := REPLACE(v_result_str, '&lt;', '<');
    v_result_str := REPLACE(v_result_str, '&gt;', '>');
    v_result_str := REPLACE(v_result_str, '&quot;', '"');
  
    v_result_xml := xmltype(v_result_str);
  
    return v_result_xml;
  end;

  --获取报销行信息
  function get_report_line(p_exp_report_line_id number) return vat_record is
    v_record       vat_record;
    v_company_id   fnd_companies.company_id%type;
    v_company_code fnd_companies.company_code%type;
    v_usage_type   exp_report_lines.usage_type%type;
    v_dkstatus     number;
    v_returnitem   varchar2(10);
  begin
  
    select fc.company_id, fc.company_code, l.usage_type
      into v_company_id, v_company_code, v_usage_type
      from fnd_companies fc, exp_report_lines l
     where fc.company_id = l.company_id
       and l.exp_report_line_id = p_exp_report_line_id;
  
    v_company_code := get_company(v_company_code);
  
    --抵扣类型
    if v_usage_type = 'YT005' then
      --视同销售
      v_dkstatus := 3;
    elsif v_usage_type IN ('YT002', 'YT003', 'YT004', 'YT008', 'YT009') then
      --不可抵扣
      v_dkstatus := 1;
    elsif v_usage_type IN ('YT001', 'YT006', 'YT007') then
      --可抵扣
      v_dkstatus := 0;
    elsif v_usage_type = 'YT888' or v_usage_type is null then
      --无法划分
      v_dkstatus := 2;
    end if;
  
    --转出原因
    if v_usage_type in ('YT002', 'YT888') then
      v_returnitem := '01';
    elsif v_usage_type in ('YT003', 'YT004') then
      v_returnitem := '02';
    elsif v_usage_type = 'YT999' then
      v_returnitem := '07';
    else
      v_returnitem := '';
    end if;
  
    select l.exp_report_header_id,
           l.exp_report_line_id,
           (select erh.exp_report_number
              from exp_report_headers erh
             where erh.exp_report_header_id = l.exp_report_header_id),
           (select to_char(erh.report_date, 'yyyy-mm-dd')
              from exp_report_headers erh
             where erh.exp_report_header_id = l.exp_report_header_id),
           v_company_code, --公司映射
           /*(select nvl(yit.vms_value, '3')
            from exp_ygz_invoice_types yit
           where yit.type_code = l.invoice_type)*/
           case
             when l.invoice_type = '10' then
             --增值税专用发票
              '0'
             when l.invoice_type = '20' then
             --普通发票
              ''
             when l.invoice_type = '30' then
             --其他可抵扣发票
              '3'
             when l.invoice_type = '40' then
             --海关进口增值税专用缴款书
              '1'
             when l.invoice_type = '50' then
             --农产品收购发票
              '4'
             when l.invoice_type = '60' then
             --电子增值税专用发票
              '5'
             when l.invoice_type = '70' then
             --电子普通发票
              ''
             else
              ''
           end, --发票类型映射
           trim(l.invoice_number),
           trim(l.invoice_code),
           to_char(l.invoice_date, 'yyyy-mm-dd'),
           l.report_amount,
           l.tax_amount,
           l.sale_amount,
           round(l.tax_rate, 2) tax_rate,
           (select nvl(yitsd.vms_value, yitsd.type_code)
              from exp_ygz_input_tax_struc_dtl yitsd
             where yitsd.type_code = l.input_tax_structure_detail),
           (select nvl(yut.vms_value, yut.type_code)
              from exp_ygz_usage_types yut
             where yut.type_code = l.usage_type),
           v_dkstatus,
           'N', --decode(l.usage_type, 'YT008', 'Y', 'N'),
           'N', --decode(v_dkstatus, '3', 'Y', 'N'),
           (select era.journal_date
              from exp_report_dists erd, exp_report_accounts era
             where erd.exp_report_line_id = l.exp_report_line_id
               and erd.exp_report_dists_id = era.exp_report_dists_id
               and rownum = 1) journal_date,
           l.created_by,
           (select su.user_name
              from sys_user su
             where su.user_id = l.created_by),
           substr(l.description, 0, 256),
           (select ga.account_code
              from exp_report_dists    d,
                   exp_report_accounts a,
                   gld_accounts        ga
             where d.exp_report_line_id = l.exp_report_line_id
               and d.exp_report_dists_id = a.exp_report_dists_id
               and ga.account_id = a.account_id
               and a.source_code = 'EXPENSE_REPORT_AUDIT'
               and a.entered_amount_dr is not null
               and rownum = 1),
           (select a.account_segment1
              from exp_report_dists d, exp_report_accounts a
             where d.exp_report_line_id = l.exp_report_line_id
               and d.exp_report_dists_id = a.exp_report_dists_id
               and a.source_code = 'EXPENSE_REPORT_AUDIT'
               and a.entered_amount_dr is not null
               and rownum = 1),
           (select a.account_segment2
              from exp_report_dists d, exp_report_accounts a
             where d.exp_report_line_id = l.exp_report_line_id
               and d.exp_report_dists_id = a.exp_report_dists_id
               and a.source_code = 'EXPENSE_REPORT_AUDIT'
               and a.entered_amount_dr is not null
               and rownum = 1),
           (select a.account_segment3
              from exp_report_dists d, exp_report_accounts a
             where d.exp_report_line_id = l.exp_report_line_id
               and d.exp_report_dists_id = a.exp_report_dists_id
               and a.source_code = 'EXPENSE_REPORT_AUDIT'
               and a.entered_amount_dr is not null
               and rownum = 1),
           (select a.account_segment4
              from exp_report_dists d, exp_report_accounts a
             where d.exp_report_line_id = l.exp_report_line_id
               and d.exp_report_dists_id = a.exp_report_dists_id
               and a.source_code = 'EXPENSE_REPORT_AUDIT'
               and a.entered_amount_dr is not null
               and rownum = 1),
           (select a.account_segment5
              from exp_report_dists d, exp_report_accounts a
             where d.exp_report_line_id = l.exp_report_line_id
               and d.exp_report_dists_id = a.exp_report_dists_id
               and a.source_code = 'EXPENSE_REPORT_AUDIT'
               and a.entered_amount_dr is not null
               and rownum = 1),
           (select a.account_segment6
              from exp_report_dists d, exp_report_accounts a
             where d.exp_report_line_id = l.exp_report_line_id
               and d.exp_report_dists_id = a.exp_report_dists_id
               and a.source_code = 'EXPENSE_REPORT_AUDIT'
               and a.entered_amount_dr is not null
               and rownum = 1),
           (select a.account_segment7
              from exp_report_dists d, exp_report_accounts a
             where d.exp_report_line_id = l.exp_report_line_id
               and d.exp_report_dists_id = a.exp_report_dists_id
               and a.source_code = 'EXPENSE_REPORT_AUDIT'
               and a.entered_amount_dr is not null
               and rownum = 1),
           (select a.account_segment8
              from exp_report_dists d, exp_report_accounts a
             where d.exp_report_line_id = l.exp_report_line_id
               and d.exp_report_dists_id = a.exp_report_dists_id
               and a.source_code = 'EXPENSE_REPORT_AUDIT'
               and a.entered_amount_dr is not null
               and rownum = 1),
           (select a.account_segment9
              from exp_report_dists d, exp_report_accounts a
             where d.exp_report_line_id = l.exp_report_line_id
               and d.exp_report_dists_id = a.exp_report_dists_id
               and a.source_code = 'EXPENSE_REPORT_AUDIT'
               and a.entered_amount_dr is not null
               and rownum = 1),
           (select a.account_segment10
              from exp_report_dists d, exp_report_accounts a
             where d.exp_report_line_id = l.exp_report_line_id
               and d.exp_report_dists_id = a.exp_report_dists_id
               and a.source_code = 'EXPENSE_REPORT_AUDIT'
               and a.entered_amount_dr is not null
               and rownum = 1),
           (select a.account_segment11
              from exp_report_dists d, exp_report_accounts a
             where d.exp_report_line_id = l.exp_report_line_id
               and d.exp_report_dists_id = a.exp_report_dists_id
               and a.source_code = 'EXPENSE_REPORT_AUDIT'
               and a.entered_amount_dr is not null
               and rownum = 1),
           l.usage_type,
           l.line_number,
           v_returnitem
      into v_record.doc_header_id,
           v_record.doc_line_id,
           v_record.doc_number,
           v_record.doc_date,
           v_record.company_code,
           v_record.invoice_type,
           v_record.invoice_number,
           v_record.invoice_code,
           v_record.invoice_date,
           v_record.report_amount,
           v_record.tax_amount,
           v_record.no_tax_amount,
           v_record.tax_rate,
           v_record.input_tax_structure_detail,
           v_record.usage_type,
           v_record.dkstatus,
           v_record.isaofaset,
           v_record.issale,
           v_record.journal_date,
           v_record.creator_id,
           v_record.creator_name,
           v_record.description,
           v_record.subject,
           v_record.segment1,
           v_record.segment2,
           v_record.segment3,
           v_record.segment4,
           v_record.segment5,
           v_record.segment6,
           v_record.segment7,
           v_record.segment8,
           v_record.segment9,
           v_record.segment10,
           v_record.segment11,
           v_record.usage_type_origin,
           v_record.line_number,
           v_record.returnitem
      from exp_report_lines l
     where l.exp_report_line_id = p_exp_report_line_id;
  
    return v_record;
  
  exception
    when others then
      return null;
  end;

  --进项税票接口webservice调用
  function ws_post(p_param vat_record, p_xml varchar2) return sys.xmltype is
    v_request_xml varchar2(10000);
    v_result      sys.xmltype;
    --v_resultcode  varchar2(10);
  begin
    if g_enabled_flag = 'Y' then
      v_request_xml := get_request_xml(p_xml, p_param);
    
      v_request_xml := inv_xml_packing(v_request_xml);
    
      /*v_result := cux_ws_request_pkg.call_web_service_vms(p_ws_url       => g_ws_url,
      p_request_body => v_request_xml);*/
    
      --v_result := inv_xml_unpacking(v_result);
      /*v_resultcode := v_result.extract('/ufinterface/sendresult/resultcode/text()')
      .getstringval();*/
    end if;
    return v_result;
  end;

  --进项税票接口webservice调用（查询用）
  function ws_query_post(p_param vat_record, p_xml varchar2)
    return sys.xmltype is
    v_request_xml varchar2(10000);
    v_result      sys.xmltype;
    --v_resultcode  varchar2(10);
  begin
    if g_enabled_flag = 'Y' then
      v_request_xml := get_request_xml(p_xml, p_param);
    
      v_request_xml := inv_query_xml_packing(v_request_xml);
    
      /*v_result := cux_ws_request_pkg.call_web_service_vms(p_ws_url       => g_ws_query_url,
      p_request_body => v_request_xml);*/
    
      --v_result := inv_query_xml_unpacking(v_result);
      /*v_resultcode := v_result.extract('/ufinterface/sendresult/resultcode/text()')
      .getstringval();*/
    end if;
    return v_result;
  end;

  --进项税票接口
  procedure inv_vat(p_exp_report_line_id number) is
    v_record vat_record;
    v_result sys.xmltype;
  begin
  
    v_record := get_report_line(p_exp_report_line_id);
  
    v_result := ws_post(v_record, c_inv_vat_xml);
  
  exception
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_created_by              => 1,
                                                     p_package_name            => 'exp_ygz_vms_interface_pkg',
                                                     p_procedure_function_name => 'inv_roll_out');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  --进项税转出接口
  /*procedure inv_roll_out(p_exp_report_line_id number) is
    v_record            vat_record;
    v_result            sys.xmltype;
    v_post_vat_platform exp_ygz_invoice_types.post_vat_platform%type;
  begin
    v_record := get_report_line(p_exp_report_line_id);
    select yit.post_vat_platform
      into v_post_vat_platform
      from exp_ygz_invoice_types yit
     where yit.type_code = v_record.invoice_type;
    if v_post_vat_platform = 'Y' then
      v_result := ws_post(v_record, c_inv_roll_out_xml);
    end if;
  
  exception
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_created_by              => 1,
                                                     p_package_name            => 'exp_ygz_vms_interface_pkg',
                                                     p_procedure_function_name => 'inv_roll_out');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;*/

  --发票认证查询接口
  procedure inv_query(p_exp_report_line_id number) is
    v_record      vat_record;
    v_result      sys.xmltype;
    v_authstatus  varchar2(30);
    v_authdate    date := sysdate;
    v_request_xml varchar2(10000);
  begin
    --获取当前报销单行信息
    v_record := get_report_line(p_exp_report_line_id);
    --获取报文返回结果
    v_result := ws_query_post(v_record, c_inv_query_xml);
  
    --截取认证结果
    select decode(v_result.extract('/ufinterface/bill/billhead[1]/billstatus/text()')
                  .getstringval(),
                  '0',
                  '20',
                  '2',
                  '30',
                  '40')
      into v_authstatus
      from dual;
    --截取认证日期
    if v_authstatus = '30' then
      v_authdate := to_date(v_result.extract('/ufinterface/bill/billhead[1]/opendate/text()')
                            .getstringval(),
                            'yyyy-mm-dd hh24:mi:ss');
    else
      v_authdate := null;
    end if;
    --若返回已认证或验证失败，回写至报销单行表
    if v_authstatus in ('30', '40') then
      update exp_report_lines l
         set l.invoice_status      = v_authstatus,
             l.authentication_time = v_authdate,
             l.last_updated_by     = 1,
             l.last_update_date    = sysdate
       where l.exp_report_line_id = p_exp_report_line_id;
    end if;
  
  exception
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_created_by              => 1,
                                                     p_package_name            => 'exp_ygz_vms_interface_pkg',
                                                     p_procedure_function_name => 'inv_query');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;

  --视同销售接口
  /*procedure inv_deemed_sales(p_exp_report_line_id number) is
    v_record            vat_record;
    v_result            sys.xmltype;
    v_post_vat_platform exp_ygz_invoice_types.post_vat_platform%type;
  begin
    v_record := get_report_line(p_exp_report_line_id);
    select yit.post_vat_platform
      into v_post_vat_platform
      from exp_ygz_invoice_types yit
     where yit.type_code = v_record.invoice_type;
    if v_post_vat_platform = 'Y' then
      v_result := ws_post(v_record, c_inv_deemed_sales_xml);
    end if;
  exception
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_created_by              => 1,
                                                     p_package_name            => 'exp_ygz_vms_interface_pkg',
                                                     p_procedure_function_name => 'inv_deemed_sales');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
  end;*/

  --报销单复核事件——调用进项税票接口
  --上海人寿改为转出复核事件
  function exp_inv_vat_post_vms_event(p_event_record_id number,
                                      p_log_id          number,
                                      p_event_param     number, --改为报销单行ID /*以前为报销单头ID*/
                                      p_created_by      number) return number is
    v_event_record evt_event_record%rowtype;
  begin
    select *
      into v_event_record
      from evt_event_record eer
     where eer.record_id = p_event_record_id;
  
    --按报销单头
    /*for c_line in (select l.exp_report_line_id
                     from exp_report_lines l
                    where l.exp_report_header_id = p_event_param
                      and l.invoice_type in
                          (select yit.type_code
                             from exp_ygz_invoice_types yit
                            where yit.special_invoice = 'Y')
                      and l.invoice_status in (exp_report_pkg.c_authenticating, --待认证
                                               exp_report_pkg.c_authentication_failed --认证失败
                                               )) loop
    
      --调用进项税票接口
      inv_vat(p_exp_report_line_id => c_line.exp_report_line_id);
    
    end loop;*/
  
    --按报销单行
    inv_vat(p_exp_report_line_id => p_event_param);
  
    evt_event_core_pkg.set_handle_success(p_log_id  => p_log_id,
                                          p_success => evt_event_core_pkg.c_evt_return_success);
  
    return evt_event_core_pkg.c_return_normal;
  
  exception
    when others then
      evt_event_core_pkg.set_handle_message(p_log_id => p_log_id,
                                            p_msg    => '发生错误:' ||
                                                        dbms_utility.format_error_backtrace || ' ' ||
                                                        sqlerrm);
      return evt_event_core_pkg.c_return_normal;
  end;

  --转出复核事件——调用进项税转出接口
  /*function exp_roll_out_post_vms_event(p_event_record_id number,
                                       p_log_id          number,
                                       p_event_param     number, --报销单行ID
                                       p_created_by      number)
    return number is
    v_event_record evt_event_record%rowtype;
    v_usage_type   exp_report_lines.usage_type%type;
  begin
    select *
      into v_event_record
      from evt_event_record eer
     where eer.record_id = p_event_record_id;
  
    --获取发票行用途代码和
    select l.usage_type
      into v_usage_type
      from exp_report_lines l
     where l.exp_report_line_id = p_event_param;
  
    --若用途类型为视同销售
    if v_usage_type = 'YT001' then
      --调用视同专票接口
      inv_deemed_sales(p_exp_report_line_id => p_event_param);
    elsif v_usage_type = 'YT008' then
      --不动产不调用转出接口
      null;
    else
      --调用进项转出接口
      inv_roll_out(p_exp_report_line_id => p_event_param);
    end if;
  
    evt_event_core_pkg.set_handle_success(p_log_id  => p_log_id,
                                          p_success => evt_event_core_pkg.c_evt_return_success);
  
    return evt_event_core_pkg.c_return_normal;
  
  exception
    when others then
      evt_event_core_pkg.set_handle_message(p_log_id => p_log_id,
                                            p_msg    => '发生错误:' ||
                                                        dbms_utility.format_error_backtrace || ' ' ||
                                                        sqlerrm);
      return evt_event_core_pkg.c_return_normal;
  end;*/

  --审批事件——调用发票接口
  function exp_inv_query_vms_event(p_event_record_id number,
                                   p_log_id          number,
                                   p_event_param     number, --报销单头ID
                                   p_created_by      number) return number is
    v_event_record evt_event_record%rowtype;
  begin
    select *
      into v_event_record
      from evt_event_record eer
     where eer.record_id = p_event_record_id;
  
    for c_line in (select l.exp_report_line_id
                     from exp_report_lines l
                    where l.exp_report_header_id = p_event_param
                      and exp_ygz_common_pkg.check_special_invoice(l.invoice_type) = 'Y'
                      and l.invoice_status in ('20', --待认证
                                               '40' --认证失败
                                               )) loop
      --调用发票验证接口
      inv_query(p_exp_report_line_id => c_line.exp_report_line_id);
    end loop;
    evt_event_core_pkg.set_handle_success(p_log_id  => p_log_id,
                                          p_success => evt_event_core_pkg.c_evt_return_success);
  
    return evt_event_core_pkg.c_return_normal;
  
  exception
    when others then
      evt_event_core_pkg.set_handle_message(p_log_id => p_log_id,
                                            p_msg    => '发生错误:' ||
                                                        dbms_utility.format_error_backtrace || ' ' ||
                                                        sqlerrm);
      return evt_event_core_pkg.c_return_normal;
  end;

  --君康人寿-节点后过程-执行发票验证
  function jk_exp_inv_query_vms(p_instance_id number,
                                p_node_id     number,
                                p_result      out varchar2) return varchar2 is
    v_exp_report_header_id number;
  begin
    select v.instance_param
      into v_exp_report_header_id
      from wfl_workflow_instance v
     where v.instance_id = p_instance_id;
  
    for c_line in (select l.exp_report_line_id
                     from exp_report_lines l
                    where l.exp_report_header_id = v_exp_report_header_id
                      and exp_ygz_common_pkg.check_special_invoice(l.invoice_type) = 'Y'
                      and l.invoice_status in ('20', --待认证
                                               '40' --认证失败
                                               )) loop
      --调用发票验证接口
      inv_query(p_exp_report_line_id => c_line.exp_report_line_id);
    end loop;
  
    p_result := 'Y';
    return p_result;
  exception
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(p_message                 => dbms_utility.format_error_backtrace || ' ' ||
                                                                                  sqlerrm,
                                                     p_created_by              => 1,
                                                     p_package_name            => 'exp_ygz_vms_interface_pkg',
                                                     p_procedure_function_name => 'jk_exp_inv_query_vms');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
      return 'N';
  end;

  --君康人寿请求-全部审核和提交单据，调用进项税票接口
  procedure jk_exp_inv_query_all_vms is
  begin
    for c_line in (select l.exp_report_line_id
                     from exp_report_lines l, exp_report_headers h
                    where l.exp_report_header_id = h.exp_report_header_id
                      and h.report_status in
                          ('SUBMITTED', 'COMPLETELY_APPROVED')
                      and exp_ygz_common_pkg.check_special_invoice(l.invoice_type) = 'Y'
                      and l.invoice_status in ('20', --待认证
                                               '40' --认证失败
                                               )) loop
      --调用发票验证接口
      inv_query(p_exp_report_line_id => c_line.exp_report_line_id);
    end loop;
  
  exception
    when others then
      sch_concurrent_job_pkg.create_log(p_log_desc      => '全量发票认证请求出现错误',
                                        p_error_message => dbms_utility.format_error_backtrace || ' ' ||
                                                           sqlerrm);
  end;

  PROCEDURE sch_log(p_log_text VARCHAR2) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    v_job_id NUMBER;
  BEGIN
    v_job_id := sch_global_pkg.jobid_get;
    IF v_job_id IS NOT NULL THEN
      sch_concurrent_job_pkg.create_log(p_log_desc      => gl_log_pkg.g_log_type_debug,
                                        p_error_message => substr(p_log_text,
                                                                  1,
                                                                  2000));
    END IF;
    COMMIT;
  END;

  procedure syn_info is
    v_count number;
  begin
  
    for c1 in (select v.bill_code, --发票代码
                      v.bill_no, --发票号码
                      v.bill_date, --开票日期
                      v.identify_date, --认证通过日期
                      v.vendor_name, --销方纳税人名称
                      v.amt_sum, --合计金额
                      v.tax_amt_sum, --合计税额
                      --sum_amt;--价税合计
                      v.datastatus, --状态 1-已扫描未认证2-认证未收到回执3-首次认证通过4-首次认证未通过5-再次认证通过6-再次认证未通过7-税务局当场认证通过8-税务局当场认证未通过9-票退回10-已抵扣11-不可抵扣 14-已红冲  
                      v.vendor_taxno, --销方纳税人识别号
                      v.fapiao_type, --发票类型0-增值税专用发票 1-增值税普通发票
                      v.import_status --导入数据状态    1、正常   2、红冲  3、作废  4、其它
                 from vmss_ist.vms_input_invoice_info@vat_link v
               /*where not exists (select 1
                from exp_invoice_info e
               where e.invoice_code = v.bill_code
                 and e.invoice_number = v.bill_no)*/
               ) loop
      select count(*)
        into v_count
        from exp_invoice_info e
       where e.invoice_code = c1.bill_code
         and e.invoice_number = c1.bill_no;
    
      if v_count = 0 then
        insert into exp_invoice_info
          (exp_invoice_info_id,
           invoice_code,
           invoice_number,
           import_date,
           invoice_date,
           authentic_date,
           sales_name,
           amount,
           tax_amount,
           authentic_status,
           created_by,
           creation_time,
           last_update_by,
           last_update_time,
           sales_code,
           invoice_type,
           invoice_status,
           company_code)
        values
          (exp_invoice_info_s.nextval,
           c1.bill_code,
           c1.bill_no,
           sysdate,
           c1.bill_date,
           c1.identify_date,
           c1.vendor_name,
           c1.amt_sum,
           c1.tax_amt_sum,
           c1.datastatus,
           1,
           sysdate,
           1,
           sysdate,
           c1.vendor_taxno,
           c1.fapiao_type,
           c1.import_status,
           '');
      else
        update exp_invoice_info e
           set e.invoice_date     = c1.bill_date,
               e.authentic_date   = c1.identify_date,
               e.sales_name       = c1.vendor_name,
               e.amount           = c1.amt_sum,
               e.tax_amount       = c1.tax_amt_sum,
               e.authentic_status = c1.datastatus,
               last_update_by     = 1,
               last_update_time   = sysdate,
               sales_code         = c1.vendor_taxno,
               invoice_type       = c1.fapiao_type,
               invoice_status     = c1.import_status,
               company_code       = ''
         where e.invoice_code = c1.bill_code
           and e.invoice_number = c1.bill_no;
      end if;
    end loop;
    --select * from exp_invoice_info;
  end syn_info;

  procedure syn_invoice_info is
    v_job_id    NUMBER;
    v_error_msg VARCHAR2(2000);
  BEGIN
    sch_log('同步更新增值税发票信息开始 ');
    BEGIN
      syn_info;
    EXCEPTION
      WHEN OTHERS THEN
        sys_raise_app_error_pkg.get_sys_raise_app_error(sys_raise_app_error_pkg.g_err_line_id,
                                                        v_error_msg);
        sch_log('同步更新增值税发票信息结束:' || v_error_msg);
    END;
    sch_log('同步更新增值税发票信息结束');
  end syn_invoice_info;
end exp_ygz_vms_interface_pkg;
/
