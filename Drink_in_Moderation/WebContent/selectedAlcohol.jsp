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
<%/* 버튼을 눌렀을때 전달되는 값들을 받는다. */
	String date=request.getParameter("date");/* 선택한 날짜를 받는다. */
	String ac_name=request.getParameter("ac_name");/* 술 이름을 저장하는 변수 */
	String consumption=request.getParameter("consumption");/* 소비량을 받는다. */
%>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt2 = null;
	PreparedStatement pstmt3 = null;
	ResultSet rs = null;
	
	ArrayList<String> Date = new ArrayList<String>();
	/* Record테이블에서 날짜에 관한 정보를 저장하는 ArrayList */
	boolean exist=false;/* 현재 Record테이블에 존재하는지 조사하는 변수 */
	try{
		conn = DatabaseUtil.getConnection();
		String sql = "select * from Record";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();/*!!!!!!*/
		while(rs.next()){
			Date.add(rs.getString("Date"));
		}	
		for(String d:Date){
			if(date.equals(d)){/* 선택한 날짜와 같다면 수행한다. */
				exist=true;
			}
		}
		if(exist){/* 만일 선택한 날짜의 데이터가 존재한다면 수행한다. */
			sql="update Record set Consumption=? where Date=?";
			pstmt2 = conn.prepareStatement(sql);
			pstmt2.setString(1, consumption);
			pstmt2.setString(2, date);
			pstmt2.executeUpdate();
			
			sql="update Record set Alcohol_name=? where Date=?";
			pstmt2 = conn.prepareStatement(sql);
			pstmt2.setString(1, ac_name);
			pstmt2.setString(2, date);
			pstmt2.executeUpdate();
		}else{/* 선택한 날짜의 데이터가 존재하지 않는다면 수행한다. */
			sql = "INSERT INTO Record VALUES(?,?,?,?)";
			pstmt3 = conn.prepareStatement(sql);
			pstmt3.setString(1, "admin");
			pstmt3.setString(2, date);
			pstmt3.setString(3, consumption);
			pstmt3.setString(4, ac_name);
			pstmt3.executeUpdate();/*!!!!!!*/
		}
		
	}finally{
		if(pstmt!= null) pstmt.close();
		if(pstmt2!= null) pstmt2.close();
		if(pstmt3!= null) pstmt3.close();
		if(conn != null) conn.close();
		
	}
%>
<jsp:forward page="Record.jsp"></jsp:forward> <!-- Record.jsp로 제어를 넘긴다. -->
</body>
</html>