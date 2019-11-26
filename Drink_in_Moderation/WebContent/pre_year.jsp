<%@page import="util.DatabaseUtil"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%
	String cnt = request.getParameter("cnt").trim();
	int c = Integer.parseInt(cnt);
%>
<%
	boolean check=true;
	String ID = (String)session.getAttribute("ID");
	Date date = new Date();
	Calendar cal = Calendar.getInstance();
	int y = cal.get(Calendar.YEAR)+c;/* c값(음수)만큼 더해준 년도를 구한다 */

	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	ArrayList<String> Date = new ArrayList<String>();
	/* 년도별 월별 술을 마신날들의 횟수를 저장할 ArrayList */
	try{
		conn = DatabaseUtil.getConnection();
		String sql = "select count(Date) from Record where Date like ? and Consumption>0 and ID=?";
		pstmt = conn.prepareStatement(sql);
		for(int i=1; i<=12; i++){
			String month = "";
			if(i<10){
				month = "0"+i;
			}else{
				month = Integer.toString(i);
			}
			pstmt.setString(1, y+"-"+month+"%");
			pstmt.setString(2, ID);
			rs = pstmt.executeQuery();/*!!!!!!*/
			while(rs.next()){
				Date.add(rs.getString("count(Date)"));
			}
		}
	}finally{
		if(rs != null) rs.close();
		if(pstmt!= null) pstmt.close();
		if(conn != null) conn.close();
		
	}
	for(String f:Date){
		if(Integer.parseInt(f)>0){
			check = true;
			break;
		}
		check = false;
	}
%>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawChart);
	  
      function drawChart() {
		var check = <%=check%>
		var data
		if(check){
        data = google.visualization.arrayToDataTable([
			['Month', 'Drink per Month'],
			['1월',     <%=Date.get(0)%>] ,
			['2월',     <%=Date.get(1)%>],
			['3월',     <%=Date.get(2)%>],
			['4월',     <%=Date.get(3)%>],
			['5월',     <%=Date.get(4)%>],
			['6월',     <%=Date.get(5)%>],
			['7월',     <%=Date.get(6)%>],
			['8월',     <%=Date.get(7)%>],
			['9월',     <%=Date.get(8)%>],
			['10월',    <%=Date.get(9)%>],
			['11월',    <%=Date.get(10)%>],
			['12월',    <%=Date.get(11)%>]
        ]);}else{
				data = google.visualization.arrayToDataTable([
						['Month', 'Drink per Month'],
						['금주일', 365]]);
			}

        var options = {
          title: 'Drink per Month'
        };
	
        var chart = new google.visualization.PieChart(document.getElementById('piechart'));

        chart.draw(data, options); 
      }
    </script>
</head>
<body>
	<jsp:include page="Main_menu.jsp" flush="false"></jsp:include>
	<br><br><br>
	<h1><%=y %>년도 월별 술 섭취횟수</h1>
	<input type="button" value="이전년도" onclick="previous()"/>
	<input type="button" value="다음년도" onclick="After()"/>
	<div id="piechart" align="center" style="width: 900px; height: 500px;"></div>
	<%
		if(!check){
			%><h1 align="center">해당연도에 마시지 않았습니다!</h1><%
		}
	%>
</body>
<script>
	function previous(){
		  var cnt =<%=Integer.parseInt(cnt)%>-1;
		  location.href="pre_year.jsp?cnt="+cnt;
	}
	function After(){
		  var cnt =<%=Integer.parseInt(cnt)%>+1;
		  location.href="aft_year.jsp?after="+cnt;
	}
</script>
</html>