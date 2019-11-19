<%@page import="java.sql.SQLException"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="util.DB" %>
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
/* try {
    Class.forName("com.mysql.cj.jdbc.Driver");
} catch (ClassNotFoundException ex) {
    System.out.print("gg");
}
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

ArrayList<String> test = new ArrayList<String>();
try{
	conn = DB.getConnection();
	String sql = "select * from Music_application.Member";
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();
	while(rs.next()){
		test.add(rs.getString("ID"));
	}
}catch (SQLException ex) {
	System.out.print("22");
}finally{
        if(rs != null) rs.close();
		if(pstmt!= null) pstmt.close();
		if(conn != null) conn.close();} */

%>
<%
	/* Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	ArrayList<String> test = new ArrayList<String>();
	try{
		conn = DB.getConnection();
		String sql = "select * from Music_application.Member";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		while(rs.next()){
			test.add(rs.getString("ID"));
		}	
	}finally{
		if(rs != null) rs.close();
		if(pstmt!= null) pstmt.close();
		if(conn != null) conn.close();
		
	}
	for(int i=0;i<test.size();i++){
		out.println(test.get(i));
	} */
	
	out.print("<a href='http://naver.com'>naver<a>");
%>

</body>
</html>