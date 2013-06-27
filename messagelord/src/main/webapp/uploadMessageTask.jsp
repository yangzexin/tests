<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>上传短信任务</title>
</head>
<body>
<%@ include file="navigation.jsp" %>
<div>
	<div>txt短信任务：<span style="color:red;">每行一个号码</span></div>
	
	<form action="doUploadMessageTask.do" method="post"  enctype="multipart/form-data">
		<div style="padding-top:20px;">
			短信内容:<br>
			<textarea name="messageContent" style="height:120px;width:300px;"></textarea>
		</div>
		<div style="padding-top:5px;">
			<input type="file" name="txtFile" />
			<input type="submit" value="上传"/>
		</div>
	</form>
</div>
</body>
</html>