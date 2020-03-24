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
	boolean check=true;/* 해당연도에 술을 마신 기록이 있는지 확인하는 변수 */
	String ID = (String)session.getAttribute("ID");/*현재 로그인한 사용자의 ID를 가져온다.*/
	Date date = new Date();
	Calendar cal = Calendar.getInstance();
	int y = cal.get(Calendar.YEAR);/* 현재의 년도를 y라는 변수에 넣어준다 */

	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	ArrayList<String> Date = new ArrayList<String>(); 
	/* 년도별 월별 술을 마신날들의 횟수를 저장할 ArrayList */
	ArrayList<String> Consumption = new ArrayList<String>();
	ArrayList<String> pre_Consumption = new ArrayList<String>();
	/*년도별 월별 술을 마신 소비량을 저장할 ArrayList*/
	try{
		conn = DatabaseUtil.getConnection();
		String sql = "select count(Date) from Record where Date like ? and Consumption>0 and ID=?";
		/* 현재 로그인한 사용자의 월별로 소비량이 0초과인 날들의 횟수를 센다 */
		pstmt = conn.prepareStatement(sql);
		for(int i=1; i<=12; i++){
			String month = "";
			if(i<10){
				month = "0"+i;/* 1,2월 같은 한 자릿수 월에 앞에 0이라는 문자열을 더해준다 */
			}else{
				month = Integer.toString(i);
			}
			pstmt.setString(1, y+"-"+month+"%");
			pstmt.setString(2, ID);
			rs = pstmt.executeQuery();/*!!!!!!*/
			while(rs.next()){
				Date.add(rs.getString("count(Date)"));
				/* Date에 추가해준다 */
			}
		}
		
 
		sql = "select sum(Consumption) from Record where Date like ? and ID=?";
		/* 현재 사용자의 월별 술 소비량을 합해서 구해준다 */
		pstmt = conn.prepareStatement(sql);
		for(int i=1; i<=12; i++){
			String month = "";
			if(i<10){
				month = "0"+i;/* 1,2월 같은 한 자릿수 월에 앞에 0이라는 문자열을 더해준다 */
			}else{
				month = Integer.toString(i);
			}
			pstmt.setString(1, y+"-"+month+"%");
			pstmt.setString(2, ID);
			rs = pstmt.executeQuery();/*!!!!!!*/
			while(rs.next()){
				if(rs.getString("sum(Consumption)")==null){
					/* 만일 해당월에 마신 기록이 없다면 수행한다. */
					Consumption.add(Integer.toString(0));
				}else{
					Consumption.add(rs.getString("sum(Consumption)"));
				}
			}
		}
		sql = "select sum(Consumption) from Record where Date like ? and ID=?";
		/* 현재 사용자의 월별 술 소비량을 합해서 구해준다 */
		pstmt = conn.prepareStatement(sql);
		for(int i=1; i<=12; i++){
			String month = "";
			if(i<10){
				month = "0"+i;/* 1,2월 같은 한 자릿수 월에 앞에 0이라는 문자열을 더해준다 */
			}else{
				month = Integer.toString(i);
			}
			pstmt.setString(1, (y-1)+"-"+month+"%");/*현재 년도의 바로 이전년도의 기록을 찾는다.*/
			pstmt.setString(2, ID);
			rs = pstmt.executeQuery();/*!!!!!!*/
			while(rs.next()){
				if(rs.getString("sum(Consumption)")==null){
					/* 만일 해당월에 마신 기록이 없다면 수행한다. */
					pre_Consumption.add(Integer.toString(0));
				}else{
					pre_Consumption.add(rs.getString("sum(Consumption)"));
				}
			}
		}
	}finally{
		if(rs != null) rs.close();
		if(pstmt!= null) pstmt.close();
		if(conn != null) conn.close();
		
	}
	for(String f:Date){
		if(Integer.parseInt(f)>0){
			check = true;/* 해당연도에 마신기록이 있다면 true로 바꿔준다 */
			break;
		}
		check = false;/* 그렇지 않다면 false를 넣어준다 */
	}
%>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
 	<script type="text/javascript">
      google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawChart);
	  /* 구글차트의 라이브러리를 로드한다. */
	  
      function drawChart() {
		var check = <%=check%>/* check값을 가져온다 */
		var data
		if(check){
        data = google.visualization.arrayToDataTable([
			/* 구글차트를 그릴 때 사용할 데이터를 넣어준다 */
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
        };/* 차트의 타이틀을 설정한다 */
	
        var chart = new google.visualization.PieChart(document.getElementById('piechart'));
        chart.draw(data, options);
		/* chart 변수에서 원하는 chart 종류에 맞게 매칭 시킨 후 chart.draw() 함수로 차트를 그려준다 */
      }
    </script>
	<script type="text/javascript">
      google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Month', '전년도', '선택년도'],
          ['1월',  <%=pre_Consumption.get(0)%>, <%=Consumption.get(0)%>],
          ['2월',  <%=pre_Consumption.get(1)%>, <%=Consumption.get(1)%>],
          ['3월',  <%=pre_Consumption.get(2)%>, <%=Consumption.get(2)%>],
          ['4월',  <%=pre_Consumption.get(3)%>, <%=Consumption.get(3)%>],
          ['5월',  <%=pre_Consumption.get(4)%>, <%=Consumption.get(4)%>],
          ['6월',  <%=pre_Consumption.get(5)%>, <%=Consumption.get(5)%>],
          ['7월',  <%=pre_Consumption.get(6)%>, <%=Consumption.get(6)%>],
          ['8월',  <%=pre_Consumption.get(7)%>, <%=Consumption.get(7)%>],
          ['9월',  <%=pre_Consumption.get(8)%>, <%=Consumption.get(8)%>],
          ['10월', <%=pre_Consumption.get(9)%>, <%=Consumption.get(9)%>],
          ['11월', <%=pre_Consumption.get(10)%>, <%=Consumption.get(10)%>],
          ['12월', <%=pre_Consumption.get(11)%>, <%=Consumption.get(11)%>]
        ]);

        var options = {
          title: 'Monthly consumption',
          curveType: 'function',
          legend: { position: 'bottom' }
        };

        var chart = new google.visualization.LineChart(document.getElementById('curve_chart'));

        chart.draw(data, options);
      }
 	</script>
</head>
<body>
	<div><jsp:include page="Main_menu.jsp" flush="false"></jsp:include></div>
	<table align="center">
		<tr><td><h1><%=y %>년도 월별 술 섭취횟수</h1></td></tr>
		<tr>
			<td><input type="button" value="이전년도" onclick="previous()"/>
			<input type="button" value="다음년도" onclick="After()"/></td>
		</tr>
		<tr>
			<td colspan="2">
				<div id="piechart" style="width: 900px; height: 500px;"></div>
				<%
					if(!check){
						%><h1 align="center">해당연도에 마시지 않았습니다!</h1><%
					}
				%>
			</td>
		</tr>
		<tr>
			<td><h1>전년도와 현재의 술 소비량 비교</h1></td>
		</tr>
		<tr>
			<td><div id="curve_chart" style="width: 800px; height: 500px;"></div></td>
		</tr>
	</table>
</body>
<script>
	var cnt=0;
	var after=0;
	function previous(){/* 이전년도 버튼클릭 시 cnt값과 함께 pre_year.jsp로 이동한다 */
		  cnt--;
		  location.href="pre_year.jsp?cnt="+cnt;
	}
	function After(){/* 다음년도 버튼클릭 시 after값과 함께 aft_year.jsp로 이동한다 */
		  after++;
		  location.href="aft_year.jsp?after="+after;
	}
</script>
</html>