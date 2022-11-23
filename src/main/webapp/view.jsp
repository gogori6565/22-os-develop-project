<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="reply.Reply" %>
<%@ page import="reply.ReplyDAO" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width" initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>소프트웨어학과 과목별 게시판</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Jua&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Gothic+A1:wght@300&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Gothic+A1:wght@600&display=swap');
body {
background-color: #F0FFFF ;
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
		String userID=null;
		if(session.getAttribute("userID")!=null){
			userID=(String)session.getAttribute("userID");
		}
		
		int bbsID=0;
		if(request.getParameter("bbsID")!=null){
			bbsID=Integer.parseInt(request.getParameter("bbsID"));
		}
		
		if(bbsID==0){
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href='bbs.jsp'");
			script.println("</script>");	
		}
		Bbs bbs=new BbsDAO().getBbs(bbsID);
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
		
		<%
			if(userID==null){
		
		%>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li class="active"><a href="main.jsp">메인</a></li>
				<li><a href="bbs.jsp">게시판</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
         		<li class="dropdown">
           			<a href="#" class="dropdown-toggle" 
                                data-toggle="dropdown" role="button" aria-haspopup="true" 
            			aria-expanded="false">접속하기 <span class="caret"></span></a>
        			<ul class="dropdown-menu">
              			<li><a href="login.jsp">로그인</a></li>
              			<li class="active"><a href="join.jsp">회원가입</a></li>
            		</ul>    
         		</li>
       		</ul>
		</div>

		<%
			}else{
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
		
	</nav>
	<div class="container">
		<div class="row">
			<table class="table table-striped" style="text-align:center; border :1px solid #dddddd" > <%-- 홀,짝 행 구분 --%>
				<thead>
					<tr>
						<th colspan="3" style="background-color : #eeeeeee; text-align:center; font-family: 'Gothic A1', sans-serif;">게시판 글 보기</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width:20%;">글 제목 </td>	
						<td colspan="2"><%= bbs.getBbsTitle() %></td>
					</tr>
					<tr>
						<td >작성자 </td>	
						<td colspan="2"><%= bbs.getUserID() %></td>
					</tr>
					<tr>
						<td >작성일자</td>	
						<td colspan="2"><%= bbs.getBbsDate().substring(0,11)+bbs.getBbsDate().substring(11,13)+"시"+bbs.getBbsDate().substring(14,16)+"분" %></td>
					</tr>
					<tr>
						<td >내용</td>	
						<td colspan="2" style="min-height:200px; text-align:left;"><%= bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>;") %></td>
					</tr>
					
					
				</tbody>
			
			
			</form>
			<br>
			<a href="bbs.jsp" class="btn btn-primary" style="color: black; background-color: #B0E0E6; font-family: 'Jua', sans-serif; font-size:15px;">목록</a>
			  
			<%
				if(userID!=null && userID.equals(bbs.getUserID())){
			%>
				<a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary" style="color: black; background-color: #B0E0E6; font-family: 'Jua', sans-serif; font-size:15px;">수정</a>
				<a onclick="return confirm('정말로 삭제하시겠습니까?')" 
				href="deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-primary" style="color: black; background-color: #B0E0E6; font-family: 'Jua', sans-serif; font-size:15px;">삭제</a>
			
			<%
			} 
			%>
		
		
	<div class="container">
				<div class="row">
					<table class="table table-striped"
						style="text-align: center; border: 1px solid #dddddd">
						<tbody>
							<tr>
								<td align="left" style="color: black; background-color: #B0E0E6; font-family: 'Jua', sans-serif; font-size:20px;" >댓글</td>
								
							</tr>
							<tr>
								<%
									ReplyDAO replyDAO = new ReplyDAO();
									ArrayList<Reply> list = replyDAO.getList(bbsID);
									for (int i = 0; i < list.size(); i++) {
								%>
								<div class="container">
									<div class="row">
										<table class="table table-striped"
											style="text-align: center; border: 1px solid #dddddd">
											<tbody>
												<tr>
													<td align="left"><%=list.get(i).getUserID()%></td>	
												</tr>
												<tr>
													<td align="left"><%=list.get(i).getReplyContent()%></td>
													<td align="right"><a
														onclick="return confirm('정말로 삭제하시겠습니까?')"
														href="replyDeleteAction.jsp?bbsID=<%=bbsID%>&replyID=<%=list.get(i).getReplyID()%>"
														class="btn btn-danger" style="color: black; background-color: #FF6347 ; font-family: 'Jua', sans-serif; font-size:15px;"">삭제</a></td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
								<%
									}
								%>
							</tr>
					</table>
				</div>
			</div>
			<br>
			<div class="container">
				<div class="row">
					<form method="post" action="submitAction.jsp?bbsID=<%=bbsID%>">
						<table class="table table-bordered"
							style="text-align: center; border: 1px solid #dddddd">
							<tbody>
								<tr>
									<td align="left"><%=userID%></td>
								</tr>
								<tr>
									<td><input type="text" class="form-control" 
										placeholder="댓글쓰기" name="replyContent" maxlength="500"></td>
								</tr>
							</tbody>
						</table>
						<input type="submit" class="btn btn-success pull-right" style="color:black; background-color:#98FB98 ; font-family: 'Jua', sans-serif; font-size:15px;"
							value="댓글쓰기">
					</form>
				</div>
			</div>
		</div>
	</div>

	<script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.3.1.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</body>
</html>