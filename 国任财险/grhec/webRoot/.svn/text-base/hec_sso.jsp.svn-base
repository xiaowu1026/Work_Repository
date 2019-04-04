<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.sso.client.EKPSSOUserData" %>
<%@ page import="com.hand.db.SSOOp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>国任报销费控系统</title>
</head>
<body>
	<%
	HttpSession s = request.getSession(); 
	String sso_username = EKPSSOUserData.getInstance().getCurrentUsername();
	if(sso_username != null && !"".equals(sso_username)){
		SSOOp ssoOp = new SSOOp();
		Object tokenO = ssoOp.generateToken(sso_username);
		//Object tokenO = s.getAttribute("token");
		String sso_op = request.getParameter("sso_op");
		String record_id = request.getParameter("record_id");
		if(record_id == null){
			record_id = "0";
		}
		String company_code = request.getParameter("company_code");
		if(company_code == null){
			company_code = "0";
		}
		String unit_code = request.getParameter("unit_code");
		if(unit_code == null){
			unit_code = "0";
		}
		String sign_id = request.getParameter("sign_id");
		String token = "";
		if(tokenO != null){
			token = tokenO.toString();
			if(token != null && !"".equals(token)){
				String url = "af_sso_login.screen?token=" + token ;
				if(sso_op != null && !"".equals(sso_op)){
					url += "&sso_op=" + sso_op + "&record_id=" + record_id + "&company_code=" + company_code + "&unit_code=" + unit_code;
				}
				if (sign_id != null && !"".equals(sign_id)) {
					url = url + "&sign_id=" + sign_id;
				}
				response.sendRedirect(url.toString());
			}
		}
	}else{
		
	}
	
	
%>
</body>
<DIV><%=sso_username%></DIV>
</html>