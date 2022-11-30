<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.User" scope="page"/>
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<jsp:setProperty name="user" property="userName" />
<jsp:setProperty name="user" property="userGender" />
<jsp:setProperty name="user" property="userEmail" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
<title>충북대 소프트웨어학과 과목별 게시판</title>
</head>
<body>
	<%
		/*로그인 된 사람은 회원가입 페이지 접속 X*/
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
		if(user.getUserID()==null || user.getUserPassword()==null || user.getUserName()==null ||
			user.getUserGender()==null || user.getUserEmail()==null ){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안 된 사항이 있습니다.')");
			script.println("history.back()"); //이전 페이지(회원가입 페이지)로 사용자를 돌려보냄
			script.println("</script>");
		} 
		else {
			UserDAO userDAO = new UserDAO();
			int result = userDAO.join(user); //위에서 jsp:setProperty로 속성값들을 받은 하나의 객체 user를 userDAO.join함수에 넘겨줌
			
			if(result==-1){ //회원가입 실패
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 존재하는 아이디입니다.')"); //PRIMARY KEY(userID) 이므로 ID가 중복되지 않음. 따라서 -1 반환
				script.println("history.back()"); //이전 페이지(회원가입 페이지)로 사용자를 돌려보냄
				script.println("</script>");
			}
			else { //회원가입 성공
				session.setAttribute("userID", user.getUserID());
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('회원가입을 성공했습니다.')");
				script.println("location.href = 'main.jsp'"); //회원가입이 되면 메인페이지로 이동
				script.println("</script>");
			}
		}
	%>
</body>
</html>