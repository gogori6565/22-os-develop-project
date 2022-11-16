<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.User" scope="page"/>
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		/*로그인 된 사람은 로그인 페이지 접속 X*/
		String userID=null;
		if(session.getAttribute("userID") != null){ //userID란 이름으로 세션이 존재하는 회원들은
			userID = (String)session.getAttribute("userID"); //해당 세션 ID를 담을 수 있도록함
		}
		if(userID != null){ //이미 로그인이 된 경우
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어있습니다.')");
			script.println("location.href = 'main.jsp"); 
			script.println("</script>");
		}
	
		UserDAO userDAO = new UserDAO();
		int result = userDAO.login(user.getUserID(), user.getUserPassword());
		
		if(result==1){ //로그인 성공
			session.setAttribute("userID", user.getUserID()); //해당 회원의 ID를 세션 값(user.getUserID())으로 부여
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href='main.jsp'"); //로그인 성공 시 해당 페이지로 이동
			script.println("</script>");
		}
		else if(result==0){ //비밀번호 틀림
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호가 틀립니다.')");
			script.println("history.back()"); //이전 페이지(로그인 페이지)로 사용자를 돌려보냄
			script.println("</script>");
		}
		else if(result==-1){ //아이디 존재하지 않을 경우
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 아이디입니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if(result==-2){ //오류
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.')");
			script.println("history.back()"); //이전 페이지(로그인 페이지)로 사용자를 돌려보냄
			script.println("</script>");
		}
	%>
</body>
</html>