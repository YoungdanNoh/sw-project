<%@page import="util.DatabaseUtil"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>목표 설정</title>
<style>
	.underline{
  		font-size:18px;
  		padding:10px 10px 10px 5px;
  		display:block;
  		width:300px;
  		border:none;
  		border-bottom:1px solid #757575;
  		text-align:center;
	}
	.button{
  		width: 315px;
    	font-size: 14px;
    	color: white;
    	background-color: #1BBC9B;
    	padding: 10px;/* 내용과 border사이의 공간을 지정한다. */
    	border-radius: 5px;/* 테두리를 둥글게 만들어준다. */
  	}
  	.table {
    	width: 400px;
    	height: 100px;
    	margin-left: auto;/* 정중앙에 위치시키기 위해 auto로 해준다. */
    	margin-right: auto;/* 정중앙에 위치시키기 위해 auto로 해준다. 자연스럽게 좌우 여백은 균등하게 배분된다. */
  	}
</style>
</head>
<body>
<jsp:include page="Main_menu.jsp" flush="false"></jsp:include>
<%
	String ID = (String)session.getAttribute("ID");
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	double Goal=0;/* 로그인한 사용자의 목표량을 저장할 변수 */
	try{
		conn = DatabaseUtil.getConnection();
		String sql = "select * from Profile where ID=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, ID);
		rs = pstmt.executeQuery();/*!!!!!!*/
		while(rs.next()){
			Goal = rs.getDouble("Goal");
			/* 로그인한 사용자의 목표량을 검색해서 Goal변수에 넣어준다. */
		}
	}finally{
		if(pstmt!= null) pstmt.close();
		if(conn != null) conn.close();
		
	}
%>
<br><br><br><br><br>
<h1 align="center">하루 알코올 권장량은 얼마일까?</h1>
<br>
<h2 align="center">세계보건기구(WHO)에서</h2>
<h2 align="center">순수 알코올 섭취량으로 보았을 때의 권장량 입니다.</h2>
<p style="text-align:center;font-size:20px">👩‍💼여자는 하루 20g(약 소주 2잔) 미만 권장</p>
<p style="text-align:center;font-size:20px">👨‍💼남자는 하루 40g(약 소주 3잔) 미만 권장</p>
<br><br>
<h1 align="center">당신은 하루에 알코올을 얼마만큼 섭취하시겠습니까?(g단위로 입력)</h1>
<table class="table">
	<tr align="center"><td>
		<form action="Goal.jsp"><!-- 버튼을 누르면 Goal.jsp에서 처리한다. -->
			<input type="text" value=<%=Goal %> class="underline" name="Goal">
			<br>
			<input type="submit" value="등록" class="button">
		</form>
	</td></tr>
</table>
</body>
</html>