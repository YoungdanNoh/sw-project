<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.DriverManager" %>
<%@page import="java.sql.*" %>
<%@page import="util.DatabaseUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Alternative drink</title>
<link href="https://fonts.googleapis.com/css?family=Black+Han+Sans|Do+Hyeon|Gamja+Flower&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Sunflower:300&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Gamja+Flower|Sunflower:300&display=swap" rel="stylesheet">
<style>
	.table{
		margin-left:auto;
		margin-right:auto;
	}
	.title{
		font-family: 'Gamja Flower', cursive;
		font-family: 'Black Han Sans', sans-serif;
		font-family: 'Do Hyeon', sans-serif;
	}
	.name{
		font-family: 'Sunflower', sans-serif;
	}
	.Alternative{
		font-family: 'Sunflower', sans-serif;
		font-family: 'Gamja Flower', cursive;
	}
</style>
</head>
<body>
<jsp:include page="Main_menu.jsp" flush="false"></jsp:include>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sAlternative_name=null;
	String sAlternative=null; 
	ArrayList<String> Alternative_name = new ArrayList<String>();
	ArrayList<String> Alternative = new ArrayList<String>();
	try{
		conn = DatabaseUtil.getConnection();
		String sql = "select * from Alternative";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();/*!!!!!!*/
		while(rs.next()){
			sAlternative_name =rs.getString("Alternative_name");
			Alternative_name.add(sAlternative_name);
			
			sAlternative = rs.getString("Alternative");
			Alternative.add(sAlternative);
		}	
	}finally{
		if(rs != null) rs.close();
		if(pstmt!= null) pstmt.close();
		if(conn != null) conn.close();
		
	}
%>
<br><br>
<h1 align="center" class="title"><font size="10">술을 마시지 않을 수 있는 대안</font></h1>
<table class="table">
<%
	for(int i=0; i<Alternative_name.size(); i++){%>
		<tr>
			<td align="center" style="padding-top:100px">
				<p class="name"><font size="7"><%=Alternative_name.get(i)%></font></p>
			</td>
		</tr>
		<tr>
			<td align="center"><img src = "대안//<%=Alternative_name.get(i)%>.jpg" width="500"/></td>
		</tr>
		<tr>
			<td align="center">
				<p class="Alternative"><font size="5"><%=Alternative.get(i)%></font></p>
			</td>
		</tr>
	<%}%>
</table>	
</body>
</html>