<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	String day = request.getParameter("id").trim();
	String year = request.getParameter("year").trim();
	String month = request.getParameter("month").trim();
	if(Integer.parseInt(month)<10){
		month = "0"+month;
	}
	if(Integer.parseInt(day)<10){
		day = "0"+day;
	}
	String date = year+"-"+month+"-"+day;
%>
<jsp:forward page="/Record.jsp">
	<jsp:param value="<%=date %>" name="date"/>
</jsp:forward>
</body>
</html>