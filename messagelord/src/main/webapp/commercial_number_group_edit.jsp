<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>修改号码分组</title>
</head>
<body>
	<%@ include file="commercial_navigation.jsp" %>
	<form action="doCommercialNumberGroupEdit.do" method="post">
		<input type="text" name="groupName" value="${group.title }" />
		<input type="submit" value="修改" />
	</form>
</body>
</html>