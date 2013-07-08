<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>合作用户管理中心</title>
<style>
	.common_a{
		color:blue;
		font-size:16px;
		text-decoration:underline;
	}
	.common_a:hover{
		color:red;
		text-decoration:none;
	}
</style>
</head>
<body>
	<div style="padding:10px 0px 10px 0px;">
		<a class="common_a" href="commercialCenter.do">管理中心</a>
		<a class="common_a" href="commercialReport.do">报表</a>
		<a class="common_a" href="commercialTaskManage.do">任务管理</a>
		<a class="common_a" href="commercialNumberManage.do">号码管理</a>
		<a class="common_a" href="commercialLogout.do">退出</a>
	</div>
</body>
</html>