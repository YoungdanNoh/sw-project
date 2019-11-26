<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Diary</title>
<style>
	.click:hover{
		background-color: #7A991A;
	}
</style>
</head>
<body>
<jsp:include page="Main_menu.jsp" flush="false"></jsp:include>
<%
	String cnt = request.getParameter("cnt").trim();
	int c = Integer.parseInt(cnt);
	
%>
<%
		Calendar tDay = Calendar.getInstance();
		int y = tDay.get(Calendar.YEAR);
		int m = tDay.get(Calendar.MONTH)+c;
		int d = tDay.get(Calendar.DATE);
		
		Calendar dSet = Calendar.getInstance();
		dSet.set(y, m, 1);

		int yo = dSet.get(Calendar.DAY_OF_WEEK);// 현재 요일(일요일은 1, 토요일은 7) 
		int last_day = dSet.getActualMaximum(Calendar.DAY_OF_MONTH);// 현재 월의 날짜의 마지막날 구하기
		
		int Y = dSet.get(Calendar.YEAR);
		int M = dSet.get(Calendar.MONTH);
	%>
	<table align="center" width="600" height="700" style="padding-top:150px">
		<tr>
			<td>
				<form action="DrinkPerMonth.jsp"><input type="submit" value="그래프"></form>
			</td>
		</tr>
		<tr>
			<td><input type="button" value="이전달" onclick="previous()"/></td>
			<td align="center"colspan="5"><%=Y%>년 <%=(M+1)%>월</td>
			<td><input type="button" value="다음달" onclick="After()"/></td>
		</tr>
		<tr>
			<%
				String[] a = { "sun", "mon", "tue", "wed", "thu", "fri", "sat" };
				for (int i = 0; i < 7; i++) {%>
			<td width="35"><%=a[i]%></td>
			<%}%>
		</tr>
		<tr>
			<%for (int k = 1; k < yo; k++) {%>
			<td></td><!--첫번째 주에 공백일 만들기-->
			<%}%>
			<%for (int j = 1; j <= last_day; j++) {
			%>
			<td width="50" id="<%=j%>" class="click" onClick="reply_click(this.id)"><%=j%>
				<%if ((yo+j-1) % 7 == 0) {%>
					</td></tr><tr>
				<%}}%>
		</tr> 
	</table>
	<!-- 저번달 -->
    <script>
      var year = <%=Y%>;
      var month = <%=M+1%>;
      function reply_click(clicked_id)
      {
    	  location.href="Date.jsp?id="+clicked_id+"&year="+year+"&month="+month;
      }
      function previous(){
    	  var cnt =<%=Integer.parseInt(cnt)%>-1;
    	  location.href="pre.jsp?cnt="+cnt;
      }
      function After(){
    	  var cnt =<%=Integer.parseInt(cnt)%>+1;
    	  location.href="aft.jsp?after="+cnt;
      }
    </script>
</body>
</html>