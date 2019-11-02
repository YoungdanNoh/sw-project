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
	out.print(year+" "+month+" "+day);
%>
</body>
</html>