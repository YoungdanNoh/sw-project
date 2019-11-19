<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Logout</title>
</head>
<body>
<%
	session.invalidate();/* 세션에 저장된 모든 값을 삭제한다. */
	response.sendRedirect("Main.jsp");/* Main.jsp페이지로 이동한다. */
%>
</body>
</html>