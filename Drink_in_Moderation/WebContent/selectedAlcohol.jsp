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
	String ID = (String)session.getAttribute("ID");/* 속성명이 ID인 session의 값을 ID변수에 저장 */
%>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt2 = null;
	PreparedStatement pstmt3 = null;
	ResultSet rs = null;
	
	ArrayList<String> Date = new ArrayList<String>();
	ArrayList<String> AC_name = new ArrayList<String>();
	/* Record테이블에서 로그인한 사용자에 관한 정보를 저장하는 ArrayList */
	boolean exist=false;/* 로그인한 사용자가 특정 술에대한 기록을 했는지 안했는지 검사하는 변수 */
	try{
		conn = DatabaseUtil.getConnection();
		String sql = "select Date, Alcohol_name from Record where ID=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, ID);
		rs = pstmt.executeQuery();/*!!!!!!*/
		while(rs.next()){
			Date.add(rs.getString("Date"));
			AC_name.add(rs.getString("Alcohol_name"));
		}	
		for(int i=0; i<Date.size(); i++){
			if(date.equals(Date.get(i)) && ac_name.equals(AC_name.get(i))){
				/* 선택한 날짜와 기록된 날짜가 같고 
				   선택한 술 이름과 Record테이블에 있는 술 이름과 같다면 수행한다. */
				exist=true;
			}
		}
		if(exist){/* 만일 특정 술에대한 기록이 되어있다면 update를 한다. */
			sql="update Record set Consumption=? where Date=? and Alcohol_name=? and ID=?";
			pstmt2 = conn.prepareStatement(sql);
			pstmt2.setString(1, consumption);
			pstmt2.setString(2, date);
			pstmt2.setString(3, ac_name);
			pstmt2.setString(4, ID);
			pstmt2.executeUpdate();
		}else{/* 특정 술에대한 기록이 되어있지 않다면 insert를 해준다. */
			sql = "INSERT INTO Record VALUES(?,?,?,?)";
			pstmt3 = conn.prepareStatement(sql);
			pstmt3.setString(1, ID);
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
<jsp:forward page="Record.jsp"></jsp:forward><!-- Record.jsp로 제어를 넘긴다. -->
</body>
</html>