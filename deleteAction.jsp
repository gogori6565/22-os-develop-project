<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
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
		} else{ //권한이 있는 사람이라면

				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.delete(bbsID);
				
				if(result==-1){ //데이터베이스 오류
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글 삭제에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else { //글 삭제 성공
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글 삭제에 성공했습니다.')");
					script.println("location.href = 'bbs.jsp'"); //다시 게시판 화면으로
					script.println("</script>");
				}
		}
	%>
</body>
</html>