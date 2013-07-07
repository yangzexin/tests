<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>注册合作用户</title>
</head>
<body>
	<div style="color:red;">
		<c:out value="${errorMsg }"></c:out>
	</div>
	<div>
		<form action="doCommercialUserRegister.do" method="post">
			帐号： <input type="text" name="username" /> <br/>
			密码：<input type="password" name="password1" /> <br/>
			确认密码：<input type="password" name="password2" /> <br/>
			<input type="submit" value="注册" />
		</form>
	</div>
</body>
</html>