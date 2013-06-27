<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Edit AppleID:<c:out value="${appleid.appleID}"></c:out></title>
</head>
<body>
	<%@ include file="navigation.jsp" %>
	<div style="color:red;">
		<c:out value="${resultMessage }"></c:out>
	</div>
	<div>
		<form action="doUpdateAppleId.do" method="post">
		<input type="hidden" value="${appleid.uid }" name="uid" />
		账号：<input type="text" value="${appleid.appleID }" name="appleId" />
		<br>
		密码：<input type="text" value="${appleid.password }" name="password" />
		<input type="submit" value="修改" />
		</form>
	</div>
</body>
</html>