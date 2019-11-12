<%@page import="util.DatabaseUtil"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.Random"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	.table {
		width : 750px;
    	margin-left: auto;/* 정중앙에 위치시키기 위해 auto로 해준다. */
    	margin-right: auto;/* 정중앙에 위치시키기 위해 auto로 해준다. 자연스럽게 좌우 여백은 균등하게 배분된다. */
  	}
</style>
</head>
<body>
<%
	Random r = new Random(); 
	int i = r.nextInt(5);/* 0~4사이의 난수를 생성한다. */
%>
<br>
<br>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	ArrayList<String> Disease_name = new ArrayList<String>();
	/* Disease테이블에 있는 질병의 이름들을 저장할 ArrayList */
	ArrayList<String> Information = new ArrayList<String>();
	/* Disease테이블에 있는 질병의 정보들을 저장할 ArrayList */
	try{
		conn = DatabaseUtil.getConnection();
		String sql = "select * from Disease";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();/*!!!!!!*/
		while(rs.next()){
			Disease_name.add(rs.getString("Disease_name"));
			
			Information.add(rs.getString("Information"));
		}	
	}finally{
		if(rs != null) rs.close();
		if(pstmt!= null) pstmt.close();
		if(conn != null) conn.close();
		
	}
%> 
<table class="table">
	<tr><td><font color="#8A0808" size="6" style="font-weight:bold">술을 많이 마시면 다음과 같은 질병이 유발될 수 있습니다!</font></td></tr>
	<tr>
		<td style="padding-top:10px" align="center">
			<p><font size="7"><%=Disease_name.get(i)%></font></p>
			<!-- 랜덤숫자인 i의 위치에있는 질병이름을 저장한 ArrayList의 값을 출력한다. -->
		</td>
	</tr>
	<tr>
		<td align="center"><img src = "질병//<%=Disease_name.get(i)%>.png"/></td>
		<!-- 질병이름에 해당하는 질병의 사진을 출력한다. -->
	</tr>
	<tr>
		<td>
			<p><font size="5"><%=Information.get(i)%></font></p>
			<!-- 랜덤숫자인 i의 위치에있는 질병정보를 저장한 ArrayList의 값을 출력한다. -->
		</td>
	</tr>
</table> 
</body>
</html>