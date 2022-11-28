<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>  
<%@ page import="bbs.BbsDAO" %>  
<%@ page import="bbs.Bbs" %>
<%@ page import="subject.Subject" %>
<%@ page import="subject.SubjectDAO" %>
<%@ page import="java.util.ArrayList" %>  
  

<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>JSP 게시판 웹사이트</title>
<style type="text/css">
	a, a:hover {
		color: #000000;
		text-decoration: none;
	}
	
	@import url("https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap");

select {
  /* 생략 */
  font-family: "Noto Sansf KR", sans-serif;
  font-size: 1rem;
  font-weight: 400;
  line-height: 1.5;

  color: #444;
  background-color: #fff;

  padding: 0.6em 1.4em 0.5em 0.8em;
  margin: 0;

  border: 1px solid #aaa;
  border-radius: 0.5em;
  box-shadow: 0 1px 0 1px rgba(0, 0, 0, 0.04);
}

</style>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		int pageNumber = 1;
		if (request.getParameter("pageNumber") != null) {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">소프트웨어학과 과목별 게시판</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse=1">
 			<ul class="nav navbar-nav">
 				<li><a href="main.jsp">메인</a></li>
 				<li class="active"><a href="bbs.jsp">게시판</a></li>
 			</ul>
 			<%
 				if(userID == null) {
 			%>
 			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
				<a href="#" class="dropdown-toggle"
					data-toggle="dropdown"	role="button" aria-haspopup="true"
					aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
 			<%
 				} else {
 			%>
 			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
				<a href="#" class="dropdown-toggle"
					data-toggle="dropdown"	role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
 			<%
 				}
 			%>
		</div>
	</nav>
	
        
	<div class = "container">
	<form name="Subject_Select" method="post" action = "bbs.jsp">
        <select id="Grade" onchange="optionChange();">
        	<option>학년</option>
          <option value="1">1학년</option>
          <option value="2">2학년</option>
          <option value="3">3학년</option>
          <option value="4">4학년</option>
        </select>
        <select id="Subject" onchange="optionChange2();">
          <option></option>
        </select>
     <input type="submit" value="확인">
     </form>
     <p id="ClassTime">수업 시간 및 강의실</p>
     <script src="//code.jquery.com/jquery-3.3.1.min.js"></script>
         <%
       SubjectDAO subjectDAO = new SubjectDAO();
       ArrayList<Subject> sublist = subjectDAO.getList();
    %>
     
    <script>
      function optionChange() {//옵션 바꾸는 함수
        //1학년 일때
        var classTime = [];
        var a = ["1학년 과목"];
        <%
        for(int i=0; i<sublist.size(); i++) {
        	if(sublist.get(i).getGrade()==1){
        	%>
        	a.push("<%= sublist.get(i).getSubName() %>"+" - "+"<%=sublist.get(i).getProfessor() %>");
        	classTime.push("<%= sublist.get(i).getClassTime() %>");
        	<%
        	}}
        	%>
        var b = ["2학년 과목"];
        <%
        for(int i=0; i<sublist.size(); i++) {
        	if(sublist.get(i).getGrade()==2){
        	%>
        	b.push("<%= sublist.get(i).getSubName() %>"+" - "+"<%=sublist.get(i).getProfessor() %>");
        	classTime.push("<%= sublist.get(i).getClassTime() %>");
        	<%
        	}}
        	%>
        var c = ["3학년 과목"];
        <%
        for(int i=0; i<sublist.size(); i++) {
        	if(sublist.get(i).getGrade()==3){
        	%>
        	c.push("<%= sublist.get(i).getSubName() %>"+" - "+"<%=sublist.get(i).getProfessor() %>");
        	classTime.push("<%= sublist.get(i).getClassTime() %>");
        	<%
        	}}
        	%>
        var d = ["4학년 과목"];
        <%
        for(int i=0; i<sublist.size(); i++) {
        	if(sublist.get(i).getGrade()==4){
        	%>
        	d.push("<%= sublist.get(i).getSubName() %>"+" - "+"<%=sublist.get(i).getProfessor() %>");
        	classTime.push("<%= sublist.get(i).getClassTime() %>");
        	<%
        	}}
        	%>
        var v = $( '#Grade' ).val(); //학년 value 저장
        var o;
        if ( v == '1' ) {
          o = a;
        } else if ( v == '2' ) {
          o = b;
        } else if ( v == '3' ) {
          o = c;
        } else if ( v == '4') {
           o = d;
        } else {
           o = [];
        }
	        $( '#Subject' ).empty();
	        for ( var i = 0; i < o.length; i++ ) {
	              
	                if(v=='1'){
	                	var ID = String(i);
	                	$( '#Subject' ).append( '<option value='+ID+'>' + o[ i ] + '</option>' );
		                
		              }
		              if(v=='2'){
		            	  
		            	  var ID = String(i+a.length);
		            	  $( '#Subject' ).append( '<option value='+ID+'>' + o[ i ] + '</option>' );
			          }
		              if(v=='3'){
		            	  var ID = String(i+a.length+b.length);
		             
		            	  $( '#Subject' ).append( '<option value='+ID+'>' + o[ i ] + '</option>' );
			                		              }
		              if(v=='4'){
		            	  var ID = String(i+a.length+b.length+c.length);
		              
		            	  $( '#Subject' ).append( '<option value='+ID+'>' + o[ i ] + '</option>' );
			              }

	        }
      }
      function optionChange2() {//옵션 바꾸는 함수
    	  var value = parseInt($('#Subject').val());
      	$( '#ClassTime' ).append( '<p>' + classTime[value]+ '</p>' );
      }
    </script>
    
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">번호</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody>
					<%
						BbsDAO bbsDAO = new BbsDAO();
						ArrayList<Bbs> list = bbsDAO.getList(pageNumber);
						for(int i=0; i<list.size(); i++) {
					%>
					<tr>
						<td><%= list.get(i).getBbsID() %></td>
						<td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></td>
						<td><%= list.get(i).getUserID() %></td>
						<td><%= list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13) + "시" + list.get(i).getBbsDate().substring(14,16) + "분" %></td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
			<%
				if(pageNumber != 1) {
			%>
				<a href="bbs.jsp?pageNumber=<%= pageNumber - 1 %>" class="btn btn-success btn-arraw-left">이전</a>
			<%
				} if(bbsDAO.nextPage(pageNumber + 1)) {
			%>
				<a href="bbs.jsp?pageNumber=<%= pageNumber + 1 %>" class="btn btn-success btn-arraw-left">다음</a>
				
			<%
				}
			%>
				
				
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>