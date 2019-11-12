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
<jsp:include page="Main_menu.jsp" flush="false"></jsp:include>
<br><br>
<h1 align="center">기록하기!</h1>
<!-- 날짜정보를 Date.jsp에 보내고 그 정보를 여기서 가져와야 버튼을 눌렀을때 nullpoint에러가 뜨지않는다. -->
<%
	String date = request.getParameter("date");
%>
<h3><%=date %></h3> 
<br>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	ArrayList<String> Date = new ArrayList<String>();
	ArrayList<String> Consumption = new ArrayList<String>();
	ArrayList<String> AC_name = new ArrayList<String>();
	/* Record테이블의 값들을 저장할 ArrayList들 */
	
	String sAC_name=null;
	/* 현재 날짜에 저장되어있는 알코올의 이름을 저장할 변수 */
	
	ArrayList<String> Alcohol_name = new ArrayList<String>();
	ArrayList<String> Alcohol_content = new ArrayList<String>();
	/* Alcohol테이블에 저장되어있는 값들을 저장할 ArrayList */
	try{
		conn = DatabaseUtil.getConnection();
		String sql = "select * from Record";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();/*!!!!!!*/
		while(rs.next()){
			Date.add(rs.getString("Date"));
			
			Consumption.add(rs.getString("Consumption"));
			
			AC_name.add(rs.getString("Alcohol_name"));
		}	
		sql = "select Alcohol_name from Record where Date=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, date);
		rs = pstmt.executeQuery();/*!!!!!!*/
		while(rs.next()){
			sAC_name = rs.getString("Alcohol_name");
		}
		
		String sql2 = "select * from Alcohol";
		pstmt = conn.prepareStatement(sql2);
		rs = pstmt.executeQuery();
		while(rs.next()){
			Alcohol_name.add(rs.getString("Alcohol_name"));
			Alcohol_content.add(rs.getString("Alcohol_content"));
		}
	}finally{
		if(rs != null) rs.close();
		if(pstmt!= null) pstmt.close();
		if(conn != null) conn.close();
		
	}
%>
<form action="selectedAlcohol.jsp"><!-- 버튼을 누르면 selectedAlcohol.jsp에서 처리한다. -->
<input type="text" name="date" value=<%=date %> style="display:none"/>
<br>
<select name="ac_name">
<%
	boolean re = false;/* re는 현재 날짜에 이미 기록된것이 있는지 확인하기 위한 변수 */
	String consumption=null;/* 현재 날짜에 기록된 소비량을 저장할 변수 */
	String ac_name=null;/* 현재 날짜에 기록된 술의 이름을 저장할 변수 */
	for(String ac : Alcohol_name){/* Alcohol테이블의 술 이름을 순회한다. */
		%><option value="<%=ac %>" <% if(ac.equals(sAC_name)){%>selected<%}%>>
			<%=ac %><!-- 현재 날짜에 기록된 술이 있다면 그 술을 selected한다. -->
		  </option>
	<%} %>
</select>
&nbsp;&nbsp;섭취한 술의 양(ml) 

<input type="text" name="consumption" value=<%
	for(int i=0; i<Date.size(); i++){/* Record테이블에 저장된 날짜들을 순회한다. */
		if(Date.get(i).toString().equals(date)){/* Record에 저장된 날짜와 현재 날짜가 동일하다면 */
			re = true; consumption = Consumption.get(i); ac_name=AC_name.get(i);%>
			<%=Consumption.get(i)%><%break;
			/* consuption에 현재날짜의 소비량을 저장, ac_name에 현재날짜의 술 이름을 저장한다. */
		}
	}
%>>
<br>
<br><br>
<%
if(!re){
	%><input type="submit" value="기록"><% 
}else{
%><input type="submit" value="수정"> 
<%}%> 
</form> 
<br>
<% 
	double g=0;/* 현재날짜에서 소비한 알코올양을 저장할 변수 */
	int Goal=360;/* 임의로 지정한 목표 */
	if(re){
	for(int i=0; i<Alcohol_name.size(); i++){
		if(ac_name.equals(Alcohol_name.get(i))){
			/* 선택한 날짜의 술 이름과 Alcohol테이블의 술 이름이 동일하다면 수행한다. */
			g = Double.parseDouble(consumption) * Double.parseDouble(Alcohol_content.get(i)) * 0.785;
			/* 소비한 알코올양을 계산해준다. */
		}
	
	if(Goal < g){/* 목표량을 초과했다면 수행한다. */
		%><font color="#7401DF" size="5" style="font-weight:bold" align="center">목표량을 초과했습니다 ㅠ^ㅠ</font>
			<br>
			<jsp:include page="RandomDisease.jsp" flush="false"></jsp:include>
			<!-- RandomDisease.jsp를 include해준다. -->
		<%
	}else{/* 목표량을 초과하지 않았다면 수행한다. */
		%><font color="#7401DF" size="5" style="font-weight:bold" align="center">목표량을 지키셨어용~.~</font>
	 	<%}
	}} %>
</body>

</html>