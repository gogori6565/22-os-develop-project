<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="subject.Subject" %>
<%@ page import="subject.SubjectDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1" >  <!-- 반응형 웹에 사용하는 메타태그 -->
<link rel="stylesheet" href="css/bootstrap.css"> <!-- 참조  -->
<link rel="stylesheet" href="css/custom.css">
<title>소프트웨어학과 과목별 게시판</title>
<style type = "text/css">
</style>
<style>
@import url('https://fonts.googleapis.com/css2?family=Gothic+A1:wght@300&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Jua&display=swap');
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
body {
background-color: #F0FFFF ;
}
th {
font-family: 'Gothic A1', sans-serif;
}
td {
font-family: 'Gothic A1', sans-serif;
}
/* navbar */
.navbar-default {
    background-color: #F0FFFF ;
    border-color: #B0C4DE ;
}
/* title */
.navbar-default .navbar-brand {
    color: #000080;
    font-family: 'Jua', sans-serif;
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
    String userID = null;
    if (session.getAttribute("userID") != null)
    {
        userID = (String)session.getAttribute("userID");
    }
    int pageNumber = 1; 
    if (request.getParameter("pageNumber") != null)
    {
        pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
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
                if(userID == null)
                {
            %>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                <a href="#" class = "dropdown-toggle"
                    data-toggle="dropdown" role ="button" aria-haspopup="true"
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
                <a href="#" class = "dropdown-toggle"
                    data-toggle="dropdown" role ="button" aria-haspopup="true"
                    aria-expanded="false">회원관리<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="loginAction.jsp">로그아웃</a></li>
                    </ul>
                </li>
            </ul>
            <%
                }
            %>
        </div>
    </nav>
    <div class="container">
        
   <form name="Subject_Select" method="post" action = "bbs.jsp">
        <select id="Grade" onchange="optionChange();">
           <option>학년</option>
          <option value="1">1학년</option>
          <option value="2">2학년</option>
          <option value="3">3학년</option>
          <option value="4">4학년</option>
        </select>
        <select id="Subject">
          <option></option>
        </select>
     <input type="submit" value="확인">
     </form>
     <script src="//code.jquery.com/jquery-3.3.1.min.js"></script>
         <%
       SubjectDAO subjectDAO = new SubjectDAO();
       ArrayList<Subject> sublist = subjectDAO.getList();
    %>
     
    <script>
      function optionChange() {//옵션 바꾸는 함수
        //1학년 일때
        var a = ["1학년 과목", "컴퓨터시스템개론", "오픈소프트웨어 이해와 실습", "미래설계준비"];
        <%
        for(int i=0; i<sublist.size(); i++) {
           if(sublist.get(i).getGrade()==1){
           %>
           a.push("<%= sublist.get(i).getSubName() %>");
           <%
           }}
           %>
        var b = ["2학년 과목", "프로그래밍언어론", "시스템프로그래밍", "확률및통계", "알고리즘", "컴퓨터그래픽스", "오픈소스개발프로젝트", "창업탐색"];
        <%
        for(int i=0; i<sublist.size(); i++) {
           if(sublist.get(i).getGrade()==2){
           %>
           b.push("<%= sublist.get(i).getSubName() %>");
           <%
           }}
           %>
        var c = ["3학년 과목", "소프트웨어공학", "데이터베이스시스템", "인공지능", "정보보호", "펌웨어프로그래밍", "산학프로젝트(종합설계)", "창업설계"];
        <%
        for(int i=0; i<sublist.size(); i++) {
           if(sublist.get(i).getGrade()==3){
           %>
           c.push("<%= sublist.get(i).getSubName() %>");
           <%
           }}
           %>
        var d = ["4학년 과목", "창업산학초청세미나II", "정보검색", "클라우드컴퓨팅", "자연언어처리", "창업파일럿프로젝트(종합설계)", "빅데이터분석시각화", "정보,컴퓨터교육론"];
        <%
        for(int i=0; i<sublist.size(); i++) {
           if(sublist.get(i).getGrade()==4){
           %>
           d.push("<%= sublist.get(i).getSubName() %>");
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
        <div class="row">
            <table class="table table-striped" style="text-align:center; border:1px solid #dddddd">
                <thead>
                	
                    <tr>
                
                        <th style="text-align:center;">번호</th>
                        <th style="text-align:center;">제목</th>
                        <th style="text-align:center;">작성자</th>
                        <th style="text-align:center;">작성일</th>
                    </tr>
                </thead>
               
                <tbody>
                <%
                	
                    BbsDAO bbsDAO = new BbsDAO();
                    ArrayList<Bbs> list = bbsDAO.getList(pageNumber);
                	for(int i = 0; i < list.size(); i++)
                    {
                %>
                    <tr> 
                        <td style="font-family: 'Gothic A1', sans-serif;"><%=list.get(i).getBbsID() %></td>
                        <td style="font-family: 'Gothic A1', sans-serif;"><a href="view.jsp?bbsID=<%=list.get(i).getBbsID()%>" style="color:#000000; text-decoration:none;" ><%=list.get(i).getBbsTitle() %></a></td>
                        <td style="font-family: 'Gothic A1', sans-serif;"><%=list.get(i).getUserID() %></td>
                        <td style="font-family: 'Gothic A1', sans-serif;"><%=list.get(i).getBbsDate().substring(0,11) + list.get(i).getBbsDate().substring(11, 13) + "시" 
                        + list.get(i).getBbsDate().substring(14,16) + "분" %></td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
      
            
            <a href="write.jsp" class="btn btn-primary pull-right" style="color: black; background-color: #FFFFE0; font-family: 'Jua', sans-serif;">글쓰기</a>
			
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>