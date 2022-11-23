<%@page import="user.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>소프트웨어학과 과목별 게시판</title>
</head>
<body>
	<%	
		session.invalidate();		
		%>
		<script>
			
			location.href= 'main.jsp';
		</script>
</body>
</html>