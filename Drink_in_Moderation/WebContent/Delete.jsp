<%@page import="util.DatabaseUtil"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Delete</title>
</head>
<body>
<%
	String ID = (String)session.getAttribute("ID");/* ID속성명의 session값을 받는다. */
	String date = request.getParameter("date");/* 선택한 날짜를 받는다. */
	String ac_name = request.getParameter("ac_name");/* 삭제하려는 술의 이름을 받는다. */
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try{
		conn = DatabaseUtil.getConnection();
		String sql = "delete from Record where ID=? and Date=? and Alcohol_name=?";
		/* 로그인한 사용자의 선택한 날짜에 해당하는 술에 대한 기록을 삭제한다. */
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, ID);
		pstmt.setString(2, date);
		pstmt.setString(3, ac_name);
		pstmt.executeUpdate();
	}finally{
		if(pstmt!= null) pstmt.close();
		if(conn != null) conn.close();
		
	}
%>
<jsp:forward page="Record.jsp"></jsp:forward><!-- Record.jsp로 이동한다. -->
</body>
</html>