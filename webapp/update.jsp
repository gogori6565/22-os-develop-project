<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
<meta name="viewport" content="width=device-width" initial-scale"="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>충북대 소프트웨어학과 과목별 게시판</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Jua&display=swap');
body {
background-color: #F0FFFF ;
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
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		if(userID == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'"); 
			script.println("</script>");
		}
		
		//수정하고자 하는 아이디값
		int bbsID = 0;
		if(request.getParameter("bbsID")!=null){ //매개변수로 넘어온 bbsID가 존재한다면
			bbsID = Integer.parseInt(request.getParameter("bbsID")); //현재 파일 변수 bbsID에 bbsID 넣어주기
		}
		if(bbsID == 0){ //유효하지 않은 글 = 아이디가 0이면
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp'"); 
			script.println("</script>");
		}
		Bbs bbs = new BbsDAO().getBbs(bbsID);
		if(!userID.equals(bbs.getUserID())){ //해당 글과 작성자가 userID와 일치하는지
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href = 'bbs.jsp'"); 
			script.println("</script>");
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
  	</div>
  </nav>
  <div class="container">
      <div class="row">
         <form method="post" action="updateAction.jsp?bbsID=<%= bbsID %> ">
            <table class="table table-striped"
               style="text-align: center; border:1px solid #B0E0E6;">
               <thead>
                  <tr>
                  <div style="height:30px;"></div>
                     <th colspan="2" style="background-color:#B0E0E6; color: #000080; font-size:20px; text-align: center;">글 수정 양식</th>
                  </tr>
               </thead>
               <tbody>
                  <tr>
                     <td><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="500" value="<%= bbs.getBbsTitle() %>" ></td>
                  </tr>
                  <tr>
                     <td><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;" ><%= bbs.getBbsContent() %></textarea></td>
                  </tr>
               </tbody>
            </table>   
            <input type="submit" class="btn btn-primary pull-right" value="글수정" style="color: #000080; background-color: #B0E0E6; font-family: 'Jua', sans-serif; font-size:20px;">
         </form>
      </div>
   </div>
  <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
  <script src="js/bootstrap.js"></script>
</body>
</html>