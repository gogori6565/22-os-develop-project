<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="team.Team" %>
<%@ page import="team.TeamDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
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
		//왜? 로그인이 되어있어야 글 작성이 가능하게 함
		if(userID == null){ //로그인 X
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'"); 
			script.println("</script>");
		} 
		else{ //로그인 O
			
			int bbsID = Integer.parseInt(request.getParameter("bbsID"));
			String teamuserID = request.getParameter("member");
	    	int teamCheck=1;
			
			TeamDAO teamDAO = new TeamDAO();
			int result=teamDAO.teamUpdate(bbsID, teamuserID, teamCheck);
			
			if(result==-1){ //데이터베이스 오류
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('팀영입에 실패했습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else { //글 작성 성공
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('팀영입에 성공했습니다.')");
				script.println("location.href = 'bbs.jsp'");
				script.println("</script>");
			}
		}
   %>
</body>
</html>