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
<title>Goal</title>
</head>
<body>
<%
	double Goal = Double.parseDouble(request.getParameter("Goal"));
	/* 사용자가 입력한 목표량을 받는다. */
	String ID = (String)session.getAttribute("ID");
	/* ID속성명의 session값을 받는다. */

	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	try{
		conn = DatabaseUtil.getConnection();
		String sql="update Profile set Goal=? where ID=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setDouble(1, Goal);
		pstmt.setString(2, ID);
		pstmt.executeUpdate();
		/* 사용자가 입력한 목표량으로 update해준다. */
		%>
		<script type="text/javascript">
				alert("등록되었습니다!");
				history.go(-1);
				/* 등록되었다는 알림을 띄우고 Setting.jsp페이지로 이동한다. */
		</script>
		<% 
	
	}finally{
		if(pstmt!= null) pstmt.close();
		if(conn != null) conn.close();
	
	}
%>
</body>
</html>