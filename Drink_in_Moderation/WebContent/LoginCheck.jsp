<%@page import="java.util.ArrayList"%>
<%@page import="util.DatabaseUtil"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>LoginCheck</title>
</head>
<body>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	ArrayList<String> id = new ArrayList<String>();
	ArrayList<String> pwd = new ArrayList<String>();
	/* Profile테이블에서 ID와 Password에 관한 정보를 저장하는 ArrayList */
	try{
		conn = DatabaseUtil.getConnection();
		String sql = "select ID, Password from Profile";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();/*!!!!!!*/
		while(rs.next()){
			id.add(rs.getString("ID"));
			/* ID에 관한 정보를 id에 넣어준다. */
			pwd.add(rs.getString("Password"));
			/* ID에 관한 정보를 pwd에 넣어준다. */
		}	
		
	}finally{
		if(rs != null) rs.close();
		if(pstmt!= null) pstmt.close();
		if(conn != null) conn.close();
	}
%>
<%/* 버튼을 눌렀을때 전달되는 값들을 받는다. */
	String ID=request.getParameter("ID");/* 입력된 ID값을 받는다. */
	String Password=request.getParameter("Password");/* 입력된 Password값을 받는다. */
	for(int i=0; i<id.size(); i++){/* Profile테이블에 있는 ID의 갯수만큼 실행한다. */
		if(ID.equals(id.get(i)) && Password.equals(pwd.get(i))){
			/* Profile테이블에 있는 값과 사용자가 입력한 ID, Password와 일치하다면 실행한다. */
			session.setAttribute("ID", ID);/* session속성명이 ID인 속성에 ID값을 저장한다. */
			session.setAttribute("PW", Password);/* session속성명이 PW인 속성에 Password값을 저장한다. */
			%><script type="text/javascript">
				alert("로그인에 성공하였습니다.");
				location.href = "Main.jsp";/* Main.jsp로 페이지를 이동한다. */
				</script><%
		}
	}
%>
<script type="text/javascript">/* 등록된 회원이 아니라면 수행 */
	alert("아이디 또는 비밀번호가 일치하지 않습니다.");
	history.go(-1);/* Login.jsp로 페이지를 이동한다. */
</script>
</body>
</html>