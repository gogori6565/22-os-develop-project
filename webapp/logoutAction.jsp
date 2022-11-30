<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
<title>충북대 소프트웨어학과 과목별 게시판</title>
</head>
<body>
	<%
		session.invalidate(); //현재 이 페이지에 접속한 회원이 session을 빼앗기도록 해 로그아웃 시킴
	%>
	<script>
		location.href = 'main.jsp';
	</script>
</body>
</html>