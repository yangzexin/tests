<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
<%@ include file="navigation.jsp" %>
<h2></h2>
<c:choose>
	<c:when test="${param.serviceStarted==true}">
		<br><br><a href="message/switchService.do">停止发送任务分发</a>
	</c:when>
	<c:otherwise>
		<br><br><a href="message/switchService.do">启动发送任务分发</a>
	</c:otherwise>
</c:choose>
<!-- <br><br><a href="message/generateTestMessages.do">Generate test messages</a> -->
<br><br><a href="message/submitMessageTask.do">上传短信任务</a>
<br><br><a href="appleid/list.do">管理apple id</a>

</body>
</html>
