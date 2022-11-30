<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="subject.Subject" %>
<%@ page import="subject.SubjectDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>소프트웨어학과 과목별 게시판</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Jua&display=swap');
@import url("https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap");
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@700&display=swap');
select {
  /* 생략 */
  font-family: "Noto Sansf KR", sans-serif;
  font-size: 1.3rem;
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
body {
background-color: #F0FFFF ;
}
/* navbar */
.navbar-default {
    background-color: #F0FFFF ;
    border-color: #B0C4DE ;
    font-size : 17px;
}
/* title */
.navbar-default .navbar-brand {
    color: #000080;
    font-family: 'Jua', sans-serif;
    font-size : 20px;
    color: #4169E1;
}
.navbar-default .navbar-brand:hover,
.navbar-default .navbar-brand:focus {
    color: #5E5E5E;
}
/* link */
.navbar-default .navbar-nav > li > a {
    color: #000080;
    font-family: 'Jua', sans-serif;
}
.navbar-default .navbar-nav > li > a:hover,
.navbar-default .navbar-nav > li > a:focus {
    color: #333;
}
.navbar-default .navbar-nav > .active > a, 
.navbar-default .navbar-nav > .active > a:hover, 
.navbar-default .navbar-nav > .active > a:focus {
    color: #000080;
    background-color: #B0E0E6; //메뉴바 선택했을때
    font-family: 'Jua', sans-serif;
}
.navbar-default .navbar-nav > .open > a, 
.navbar-default .navbar-nav > .open > a:hover, 
.navbar-default .navbar-nav > .open > a:focus {
    color: #000080;
    background-color: #B0E0E6; 
}
/* caret */
.navbar-default .navbar-nav > .dropdown > a .caret {
    border-top-color: #000080;
    border-bottom-color: #000080;
}
.navbar-default .navbar-nav > .dropdown > a:hover .caret,
.navbar-default .navbar-nav > .dropdown > a:focus .caret {
    border-top-color: #000080;
    border-bottom-color: #000080;
}
.navbar-default .navbar-nav > .open > a .caret, 
.navbar-default .navbar-nav > .open > a:hover .caret, 
.navbar-default .navbar-nav > .open > a:focus .caret {
    border-top-color: #000080;
    border-bottom-color: #000080;
}
/* mobile version */
.navbar-default .navbar-toggle {
    border-color: #DDD;
}
.navbar-default .navbar-toggle:hover,
.navbar-default .navbar-toggle:focus {
    background-color: #DDD;
}
.navbar-default .navbar-toggle .icon-bar {
    background-color: #CCC;
}
.dropdown-menu {
	color: #000080;
	background-color: #B0E0E6;
	font-family: 'Jua', sans-serif; 
}
.dropdown-toggle {
	background-color:  #F0FFFF; 
}
.table table-striped{
	background-color: #ffffff;
}
@media (max-width: 767px) {
    .navbar-default .navbar-nav .open .dropdown-menu > li > a {
        color:  #000080;
    }
    .navbar-default .navbar-nav .open .dropdown-menu > li > a:hover,
    .navbar-default .navbar-nav .open .dropdown-menu > li > a:focus {
        color: #333;
    }
}
</style>
</head>
<body>
	<%
		int SubID = 0;
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
	%>

    <nav class ="navbar navbar-default">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed"
                data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
                aria-expand="false">
                <span class ="icon-bar"></span>
                <span class ="icon-bar"></span>
                <span class ="icon-bar"></span>
            </button>
            <a class ="navbar-brand" href="main.jsp">소프트웨어학과 과목별 게시판</a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li><a href="main.jsp">메인</a></li>
                <li class="active"><a href="bbs.jsp">게시판</a></li>
            </ul>
			<%
				if (userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
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
				<li class="dropdown"><a href="#" class="dropdown-toggle"
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

	<div class="container"> 
		<div class = "row">
			<form method="post" action="writeAction.jsp">
			<table class="table table-striped" style="text-align:center; border:1.5px solid #87CEFA;"> 
				<thead>
				 <div style="height:30px;"></div>
					<tr>
						<th colspan="2" style="background-color: #FFF8DC; font-family: 'Noto Sans KR', sans-serif; font-size:17px; text-align: center;">게시판 글쓰기 양식</th>
					</tr>
				</thead>
				<tbody>
				<tr>
   
    </script></tr>
					
					<tr>
					
						<td><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50"></td>
					</tr>
					<tr>
	  					<td>
	  						<div style="float:left;">
	  						글 분류 : 
	  							<select name="topic">
						          <option>글 분류 선택</option>
						          <option value="질문">질문</option>
						          <option value="과제">과제</option>
						          <option value="팀 구해요">팀 구해요</option>
						          <option value="수다">수다</option>
							     </select>
	  						</div>
	  					</td>
	  				</tr>
	  				<!-- Subject로 넘겨줄 칼럼값 선택 -->
	  				<tr>
	  					<td>
		  					<div style="float:left;">
		  					과목 : 
							  <form name="Subject_Select" method="post" action = "bbs.jsp">
							        <select id="Grade" onchange="optionChange();">
							          <option>학년 선택</option>
							          <option value="1">1학년</option>
							          <option value="2">2학년</option>
							          <option value="3">3학년</option>
							          <option value="4">4학년</option>
							        </select>
							        <select name="Subject_write" id="Subject">
							          <option>과목 선택</option>
							        </select>
							     </form>
							         <%
							       SubjectDAO subjectDAO = new SubjectDAO();
							       ArrayList<Subject> sublist = subjectDAO.getList();
							    %>
							     
							        <script>
							      function optionChange() {//옵션 바꾸는 함수
							        //1학년 일때
							        var a = ["1학년 과목 선택"];
							        <%
							        for(int i=0; i<sublist.size(); i++) {
							           if(sublist.get(i).getGrade()==1){
							           %>
							           a.push("<%= sublist.get(i).getSubName() %> - <%= sublist.get(i).getProfessor() %>");
							           <%
							           }}
							           %>
							        var b = ["2학년 과목 선택"];
							        <%
							        for(int i=0; i<sublist.size(); i++) {
							           if(sublist.get(i).getGrade()==2){
							           %>
							           b.push("<%= sublist.get(i).getSubName() %> - <%= sublist.get(i).getProfessor() %>");
							           <%
							           }}
							           %>
							        var c = ["3학년 과목 선택"];
							        <%
							        for(int i=0; i<sublist.size(); i++) {
							           if(sublist.get(i).getGrade()==3){
							           %>
							           c.push("<%= sublist.get(i).getSubName() %> - <%= sublist.get(i).getProfessor() %>");
							           <%
							           }}
							           %>
							        var d = ["4학년 과목 선택"];
							        <%
							        for(int i=0; i<sublist.size(); i++) {
							           if(sublist.get(i).getGrade()==4){
							           %>
							           d.push("<%= sublist.get(i).getSubName() %> - <%= sublist.get(i).getProfessor() %>");
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
							    </script>
							  </div>
	  					</td>
	  				</tr>
					<tr>
				
						<td><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;"></textarea></td>
					</tr>
				</tbody>
			</table>
			
				<input type="submit" class="btn btn-primary pull-right" value="글쓰기" style="color: black; background-color: #FFFFE0; font-family: 'Jua', sans-serif; font-size:17px;">
			</form>
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	
	<script src="js/bootstrap.js"></script>
</body>
</html>