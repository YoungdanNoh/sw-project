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
<link href="https://fonts.googleapis.com/css?family=Gamja+Flower&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Inconsolata|Pacifico&display=swap" rel="stylesheet">
<!-- 구글 폰트를 가져왔다. -->
<style>
	.table {
    	margin-left: auto;/* 정중앙에 위치시키기 위해 auto로 해준다. */
    	margin-right: auto;/* 정중앙에 위치시키기 위해 auto로 해준다. 자연스럽게 좌우 여백은 균등하게 배분된다. */
  	}
	.font{
		font-family: 'Gamja Flower', cursive;
	}
	.font2{
		font-family: 'Inconsolata', monospace;
		font-family: 'Pacifico', cursive;
		margin-bottom:0px;
	}
</style>
</head>
<body>
<jsp:include page="Main_menu.jsp" flush="false"></jsp:include>
<br><br>
<h1 align="center" class="font">기록하기!</h1>
<!-- <h1 align="center">기록하기!</h1> -->
<!-- 날짜정보를 Date.jsp에 보내고 그 정보를 여기서 가져와야 버튼을 눌렀을때 nullpoint에러가 뜨지않는다. -->
<%
	String date = request.getParameter("date");
	String ID = (String)session.getAttribute("ID");
	/* 속성명이 ID인 세션에 저장된 값을 변수 ID에 저장한다.*/
%>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	ArrayList<String> Consumption = new ArrayList<String>();
	ArrayList<String> AC_name = new ArrayList<String>();
	/* Record테이블의 값들을 저장할 ArrayList들 */
	
	ArrayList<String> Alcohol_name = new ArrayList<String>();
	ArrayList<String> Alcohol_content = new ArrayList<String>();
	/* Alcohol테이블에 저장되어있는 값들을 저장할 ArrayList */
	double Goal=0;
	try{
		conn = DatabaseUtil.getConnection();
		String sql = "select * from Record where ID=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, ID);
		rs = pstmt.executeQuery();/*!!!!!!*/
		while(rs.next()){
			if(date.equals(rs.getString("Date"))){
				/* 선택한 날짜와 기록된 내용의 날짜가 동일하다면 수행한다. */
				Consumption.add(rs.getString("Consumption"));
				AC_name.add(rs.getString("Alcohol_name"));	
			}
		}
		
		String sql2 = "select * from Alcohol";
		pstmt = conn.prepareStatement(sql2);
		rs = pstmt.executeQuery();
		while(rs.next()){
			Alcohol_name.add(rs.getString("Alcohol_name"));
			Alcohol_content.add(rs.getString("Alcohol_content"));
		}
		
		String sql3 = "select Goal from Profile where ID=?";
		pstmt = conn.prepareStatement(sql3);
		pstmt.setString(1, ID);
		rs = pstmt.executeQuery();
		while(rs.next()){
			Goal = rs.getDouble("Goal");
		}
	}finally{
		if(rs != null) rs.close();
		if(pstmt!= null) pstmt.close();
		if(conn != null) conn.close();
		
	}
%>
<table class="table">
<tr><td><h3 align="center"><%=date %></h3> </td></tr>
<tr align="center"><td>
<form action="selectedAlcohol.jsp"><!-- 버튼을 누르면 selectedAlcohol.jsp에서 처리한다. -->
	<input type="text" name="date" value=<%=date %> style="display:none"/>
	<!-- 단순히 날짜정보를 넘겨주기 위한것으로 display를 none으로 설정해주었다. -->
	<select name="ac_name">
	<%
		for(String ac : Alcohol_name){/* Alcohol테이블에 있는 술 이름들을 순회한다. */
			%><option value="<%=ac %>">
				<%=ac %><!-- Alcohol테이블에 있는 술 이름들을 option에 추가한다. -->
		  	</option>
		<%} %>
	</select>
	&nbsp;&nbsp;섭취한 술의 양(ml) 

	<input type="text" name="consumption"><!-- 섭취한 술의 양을 입력하는 곳이다. -->
	<input type="submit" value="기록 or 수정">
</form> 
</td></tr>
<%
	boolean exist = false;/* 선택한 날짜에 기록된 것이 있는지 확인하는 boolean값이다. */
	if(!AC_name.isEmpty()){exist=true;/* 선택한 날짜에 기록된 것이 있을 때 수행한다. */
		%><tr>
			<td width="50px">
				<h2 class="font2">Recorded Content</h2>
			</td>
		</tr>
<% }%>
<tr>
	<td>
		<%for(int i=0; i<AC_name.size(); i++){%>
			<!-- Record테이블의 로그인한 사용자가 기록한 술 이름들을 순회한다. -->
			<!-- 선택한 날짜에 기록된 내용들을 출력해준다. -->
			<p style="margin-bottom:0px;margin-top:2px;">
				술 이름 : <%=AC_name.get(i)%>, 소비량 : <%=Consumption.get(i)%>ml
				<form action="Delete.jsp">
				<input type="text" name="date" value=<%=date %> style="display:none">
				<input type="text" name="ac_name" value="<%=AC_name.get(i)%>" style="display:none">
				<!-- 단순히 정보를 넘겨주기 위한것으로 display를 none으로 설정해주었다. -->
				<input type="submit" value="삭제">
				</form>
			</p>
			<%}%>
	</td>
</tr>
<%if(!AC_name.isEmpty()){%><!-- 로그인한 사용자가 기록한 것이 있다면 수행한다. -->
	<tr>
		<td>
			<form action="Reset.jsp"><!-- 버튼을 누르면 Reset.jsp에서 처리한다. -->
			<input type="text" name="date" value=<%=date %> style="display:none"/>
			<!-- 단순히 정보를 넘겨주기 위한것으로 display를 none으로 설정해주었다. -->
			<input type="submit" value="초기화">
			</form>
		</td>
	</tr><%}%>
<tr><td><p style="margin-bottom:2px;">설정한 목표 알코올 섭취량 : <%=Goal %>g</p></td></tr>
<!-- Setting페이지에서 설정한 목표량을 출력해준다. -->
<%
	double C=0;/* 알코올 섭취량을 계산해 그 값을 넣어줄 변수 */
	for(int j=0; j<Alcohol_name.size(); j++){/* Alcohol테이블에있는 술 이름의 갯수만큼 수행 */
		for(int k=0; k<AC_name.size(); k++){/* Record테이블의 사용자가 기록한 술 이름의 갯수만큼 수행한다. */
		if(Alcohol_name.get(j).equals(AC_name.get(k))){
			/* Alcohol테이블의 술 이름과 기록된 술의 이름이 동일하다면 알코올 섭취량을 계산한다. */
			C += Double.parseDouble(Consumption.get(k)) * Double.parseDouble(Alcohol_content.get(j)) * 0.785;
			}
		}
	}
	if(Goal<C && exist){/* 목표량을 초과했고 기록이 되어있다면 수행한다. */
		%><tr><td><p style="margin-top:0px;">섭취한 알코올 양 : <%=C %>g</p></td></tr>
			<tr><td><font color="#7401DF" size="5" style="font-weight:bold">목표량을 초과했습니다 ㅠ^ㅠ</font>
			<jsp:include page="RandomDisease.jsp" flush="false"></jsp:include></td></tr>
			<!-- RandomDisease.jsp를 include해준다. -->
	<%
	}else if(exist){/* 기록이 되어있고 목표량을 넘지 않았다면 수행한다. */
		%><tr><td><p style="margin-top:0px;">섭취한 알코올 양 : <%=C %>g</p></td></tr>
		  <tr>
			<td>
				<font color="#7401DF" size="5" style="font-weight:bold">목표량을 지키셨어용~.~</font>
		  	</td>
		  </tr>
		  <tr><td><img src = "Good.jpg"/></td></tr><%
	}else{/* 기록이 되어있지 않을때 수행한다. */
		%><tr>
			<td>
				<font size="5" style="font-weight:bold">기록이 되어있지 않네용 기록해주세요!</font>
		  	</td>
		  </tr><%
	}
%>
</table>
</body>
</html>