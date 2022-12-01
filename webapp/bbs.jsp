<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="subject.Subject" %>
<%@ page import="subject.SubjectDAO" %>
<%@ page import="java.util.ArrayList" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1" > 
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>소프트웨어학과 과목별 게시판</title>
<style type = "text/css">
</style>
<style>
@import url('https://fonts.googleapis.com/css2?family=Gothic+A1:wght@300&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Jua&display=swap');
@import url("https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap");
@import url('https://fonts.googleapis.com/css2?family=Jua&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Nanum+Gothic+Coding&display=swap');
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
th {
font-family: 'Gothic A1', sans-serif;
font-size : 20px;
}
td {
font-family: 'Nanum Gothic Coding', monospace;
font-size : 17px;
}
/* navbar */
.navbar-default {
    background-color: #F0FFFF ;
    border-color: #F0FFFF;
    font-size : 20px;
    padding:20px;
}
/* title */
.navbar-default .navbar-brand {
    color: #000080;
    font-family: 'Jua', sans-serif;
    font-size : 25px;
    color: #000080;
    padding-top :10px;
    padding-bottom : 10px;
    padding-right: 30px;
}
.navbar-default .navbar-brand:hover,
.navbar-default .navbar-brand:focus {
    color: #5E5E5E;
}
/* link */
.navbar-default .navbar-nav > li > a {
    color: #000080;
    font-family: 'Jua', sans-serif;
    padding-top :10px;
    padding-bottom : 10px;
    padding-right: 20px;
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
   	padding:10px;
}
.navbar-default .navbar-nav > .open > a, 
.navbar-default .navbar-nav > .open > a:hover, 
.navbar-default .navbar-nav > .open > a:focus {
    color: #000080;
    background-color: #B0E0E6; 
    padding:10px;
   
}
/* caret */
.navbar-default .navbar-nav > .dropdown > a .caret {
    border-top-color: #000080;
    border-bottom-color: #000080;
    font-size : 17px;
    
}
.navbar-default .navbar-nav > .dropdown > a:hover .caret,
.navbar-default .navbar-nav > .dropdown > a:focus .caret {
    border-top-color: #000080;
    border-bottom-color: #000080;
    font-size : 17px;
}
.navbar-default .navbar-nav > .open > a .caret, 
.navbar-default .navbar-nav > .open > a:hover .caret, 
.navbar-default .navbar-nav > .open > a:focus .caret {
    border-top-color: #000080;
    border-bottom-color: #000080;
    font-size : 17px;
}
 table {
    width: 100%;
    border-top: 1px solid #444444;
    border-collapse: collapse;
    background-color: #FFFAFA; 
   
   
  }
  th, td {
    border-bottom: 1px solid #B0E0E6;
    padding: 10px;
    text-align: center;
    height: 45px;
  }
  thead tr {
    background-color:#B0E0E6;
    color: black;
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
  <div style="height:20px;"></div>
  <div class = "container">
  <form name="Subject_Select" method="post" action = "bbs.jsp">
        <select id="Grade" onchange="optionChange();">
          <option>학년 선택</option>
          <option value="1">1학년</option>
          <option value="2">2학년</option>
          <option value="3">3학년</option>
          <option value="4">4학년</option>
        </select>
        <select name="Subject_bbs" id="Subject" onchange="optionChange2();">
          <option>과목 선택</option>
        </select>
      <input type="submit" value="확인" style="text-align : center; font-family: 'Jua', sans-serif; font-size:20px; background-color:#FA8072; border-color:#FA8072; border-radius:5px;">
     </form>
     <div style ="display:inline; font-family: 'Jua', sans-serif; font-size:18px;" class="pull-right">수업시간 및 강의실 : </div>
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
      function optionChange2() {//옵션 바꾸는 함수
          var value = parseInt($('#Subject').val())-1;
            var classTime = [];
          <%
           for(int i=0; i<sublist.size(); i++) {
              
              %>
              classTime.push('<%= sublist.get(i).getClassTime() %>');
              <%
              }
              %>
          $( '#ClassTime' ).empty();
          $( '#ClassTime' ).append( '<p>' + classTime[value]+ '</p>' );
       }

    </script>
  <%	if(request.getParameter("Subject_bbs")!=null){
  			SubID = Integer.parseInt(request.getParameter("Subject_bbs")); 
  		}
  %>
  </div>
	
	<div style="height:15px;"></div>
          <div class ="container">
        <div class="row">
            <table class="table" style="text-align:center; border:1.7px solid  #F0FFFF;">
                <thead>
                    <tr>
                        <th style="text-align:center;">글 분류</th>
                        <th style="text-align:center;">제목</th>
                        <th style="text-align:center;">작성자</th>
                        <th style="text-align:center;">작성일</th>
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
  					<td style="font-family: 'Gothic A1', sans-serif; color:red; font-weight: bold;"><%=list.get(i).getTopic() %></td>
                        <td style="font-family: 'Gothic A1', sans-serif;"><a href="view.jsp?bbsID=<%=list.get(i).getBbsID()%>" style="color:#000000; text-decoration:none;" ><%=list.get(i).getBbsTitle() %></a></td>
                        <td style="font-family: 'Gothic A1', sans-serif;"><%=list.get(i).getUserID() %></td>
                        <td style="font-family: 'Gothic A1', sans-serif;"><%=list.get(i).getBbsDate().substring(0,11) + list.get(i).getBbsDate().substring(11, 13) + "시" 
                        + list.get(i).getBbsDate().substring(14,16) + "분" %></td>
  				</tr>
  				<%
  						}
  					}
  				%>
  			</tbody>
  		</table>
  		<a href="write.jsp" class="btn btn-primary pull-right" style="color: black; background-color: #B0E0E6; font-family: 'Jua', sans-serif; font-size:18px">글쓰기</a>
  	</div>
  </div>
  <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
  <script src="js/bootstrap.js"></script>
</body>
</html>