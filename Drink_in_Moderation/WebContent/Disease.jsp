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
<title>Disease</title>
<link href="https://fonts.googleapis.com/css?family=Black+Han+Sans|Do+Hyeon|Gamja+Flower&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Sunflower:300&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Gamja+Flower|Sunflower:300&display=swap" rel="stylesheet">
<style>
	.table{
		width:200px;
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
	.information{
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
	
	String sDisease_name=null;
	String sInformation=null; 
	ArrayList<String> Disease_name = new ArrayList<String>();
	ArrayList<String> Information = new ArrayList<String>();
	try{
		conn = DatabaseUtil.getConnection();
		String sql = "select * from Disease";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();/*!!!!!!*/
		while(rs.next()){
			sDisease_name =rs.getString("Disease_name");
			Disease_name.add(sDisease_name);
			
			sInformation = rs.getString("Information");
			Information.add(sInformation);
		}	
	}finally{
		if(rs != null) rs.close();
		if(pstmt!= null) pstmt.close();
		if(conn != null) conn.close();
		
	}
%>
<br><br>
<h1 class="title" align="center"><font size="10">술을 마시면 유발되는 질병의 종류</font></h1>
<table class="table">
<%
	for(int i=0; i<Disease_name.size(); i++){%>
		<tr>
			<td align="center" style="padding-top:100px">
				<p class="name"><font size="7"><%=Disease_name.get(i)%></font></p>
			</td>
		</tr>
		<tr>
			<td align="center"><img src = "질병//<%=Disease_name.get(i)%>.png"/></td>
		</tr>
		<tr>
			<td>
				<p class="information"><font size="5"><%=Information.get(i)%></font></p>
			</td>
		</tr>
	<%}%>
</table>	
</body>
</html>