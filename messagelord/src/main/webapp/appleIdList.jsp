<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>apple ids</title>
</head>
<body>
	<%@ include file="navigation.jsp" %>
	<div style="color:red;">
		<c:out value="${resultMessage }"></c:out>
	</div>
	<form action="addAppleId.do" method="get">
		AppleID：<input type="text" name="appleid" />
		密码：<input type="text" name="appleidPassword" />
		<input type="submit" value="添加" />
	</form>
	<br>
	<c:forEach items="${appleIdList}" var="appleid">
		<div>
		账号：<c:out value="${appleid.appleID}"></c:out>     密码：<c:out value="${appleid.password }"></c:out>
		<a href="deleteAppleId.do?uid=${appleid.uid }">删除</a>
		<a href="updateAppleId.do?uid=${appleid.uid }">修改</a>
		</div>
	</c:forEach>
</body>
</html>