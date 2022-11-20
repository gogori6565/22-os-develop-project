<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
<meta name="viewport" content="width=device-width" initial-scale"="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>충북대 소프트웨어학과 과목별 게시판</title>
<style type="text/css">
	a, a:hover{
		color: #000000;
		text-decoration: none;
	}
</style>
</head>
<body>
	<%
		int SubID = 0;
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		int pageNumber = 1; //기본 페이지 1
		if(request.getParameter("pageNumber") != null){
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
  		<a class="navbar-brand" href="main.jsp">충북대 소프트웨어학과 과목별 게시판</a>
  	</div>
  	<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
  		<ul class="nav navbar-nav">
  			<li><a href="main.jsp">메인</a></li>
  			<li class="active"><a href="bbs.jsp">게시판</a></li>
  		</ul>
  		<%
  			if(userID == null){ //로그인이 되어있지 않다면
  		%>
  		<ul class="nav navbar-nav navbar-right">
  			<li class="dropdown">
  				<a href="#" class="dropdown-toggle"
  					data-toggle="dropdown" role="button" aria-haspopup="true"
  					aria-expanded="false">접속하기<span class="caret"></span></a>
  				<ul class="dropdown-menu">
  					<li><a href="login.jsp">로그인</a></li>
  					<li><a href="join.jsp">회원가입</a></li>
  				</ul>
  			</li>
  		</ul>
  		<%
  			} else{ //로그인이 되어있다면
		%>
		<ul class="nav navbar-nav navbar-right">
  			<li class="dropdown">
  				<a href="#" class="dropdown-toggle"
  					data-toggle="dropdown" role="button" aria-haspopup="true"
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
  <!-- 과목 선택 -->
  <form name="SubID_send" method="post" action="bbs.jsp">
	  <select name="Subject_bbs">
	         <option value="1">오픈소스개발프로젝트</option>
	         <option value="2">과목2</option>
	         <option value="3">과목3</option>
	         <option value="4">과목4</option>
	  </select>
	  <input type="submit" value="확인">
  </form>
  <%	if(request.getParameter("Subject_bbs")!=null){
  			SubID = Integer.parseInt(request.getParameter("Subject_bbs")); 
  		}
  %>
	
  <div class="container">
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
  					ArrayList<Bbs> list = bbsDAO.getList(pageNumber); //게시글 list 반환
  					for(int i=0; i<list.size(); i++){
  						if(list.get(i).getSubject()==SubID){ //Subject 칼럼값 별로 띄우기
  				%>
  				<tr>
  					<td><%= list.get(i).getBbsID() %></td>
  					<!-- 제목 누른 경우 해당 게시글 보여주는 페이지로 이동 - view.jsp 파일로 해당 게시글 번호(bbsID)를 매개변수로 보내줌-->
  					<td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID() %>"><%=list.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>") %></a></td>
  					<td><%= list.get(i).getUserID() %></td>
  					<td><%= list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13) + "시 " + list.get(i).getBbsDate().substring(14, 16) + "분" %></td>
  				</tr>
  				<%
  						}
  					}
  				%>
  			</tbody>
  		</table>
  		<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
  	</div>
  </div>
  <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
  <script src="js/bootstrap.js"></script>
</body>
</html>