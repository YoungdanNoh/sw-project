<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager" %>
<%@page import="java.sql.*" %>
<%@page import="util.DatabaseUtil" %>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기록</title>
</head>
<body>
<h1 align="center">기록하기!</h1>
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
<h3><%=date %></h3>
<br>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sDate=null;
	ArrayList<String> Date = new ArrayList<String>();
	String sConsumption=null;
	ArrayList<String> Consumption = new ArrayList<String>();
	try{
		conn = DatabaseUtil.getConnection();
		String sql = "select * from Record";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();/*!!!!!!*/
		while(rs.next()){
			sDate =rs.getString("Date");
			Date.add(sDate);
			
			sConsumption =rs.getString("Consumption");
			Consumption.add(sConsumption);
		}	
	}finally{
		if(rs != null) rs.close();
		if(pstmt!= null) pstmt.close();
		if(conn != null) conn.close();
		
	}
%>
섭취한 음주량 
<input type="text" value=<%
	for(int i=0; i<Date.size(); i++){
		if(Date.get(i).toString().equals(date)){
			%><%=Consumption.get(i)%><%break;
		}else{
			%>""<%
		}
	}
%>>
<br>
</body>
</html>