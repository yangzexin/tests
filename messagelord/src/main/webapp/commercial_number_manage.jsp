<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>号码管理</title>
<script type="text/javascript">
	function selectAddToGroup(){
		var selectGroupDiv = document.getElementById("selectGroupDiv");
		selectGroupDiv.style.display = "block";
	}
	function cancelSelectAddToGroup(){
		var selectGroupDiv = document.getElementById("selectGroupDiv");
		selectGroupDiv.style.display = "none";
	}
	function addToGroup(groupId){
		document.getElementById("appendGroupId").value = groupId;
		document.getElementById("submitTxtFileForm").submit();
	}
	
</script>
</head>
<body>
	<%@ include file="commercial_navigation.jsp" %>
	<div style="padding-top:10px;padding-bottom:10px;">
		<div style="color:red;">
			txt号码列表上传需知：上传的txt文件编码为UTF－8编码，每行一个号码
		</div>
		<form id="submitTxtFileForm" action="doCommercialUploadNumber.do" method="POST" enctype="multipart/form-data">
			标题：<input type="text" name="title" /><br/><br/>
			txt文件：<input type="file" name="txtFile" /><br/><br/>
			<input type="hidden" id="appendGroupId" name="groupId" />
			<input type="submit" value="添加新分组" />
		</form>
		<button onclick="selectAddToGroup()">添加到已有分组..</button>
	</div>
	<div style="background-color:lightgray;padding:10px 10px 10px 10px;">号码分组列表</div>
	<div>
		<table style="width:100%;">
		<tr style="background-color:lightgray;">
			<td>标题</td>
			<td>数量</td>
			<td>操作</td>
		</tr>
		<c:forEach items="${numberGroupList }" var="numberGroup">
			<tr>
				<td><c:out value="${numberGroup.title }"></c:out></td>
				<td><c:out value="${numberGroup.numberOfNumbers }"></c:out></td>
				<td>
					<a href="commercialNumberGroupEdit.do?groupId=${numberGroup.uid }">编辑</a>
					<a href="commercialNumberGroupDelete.do?groupId=${numberGroup.uid }">删除</a>
				</td>
			</tr>
		</c:forEach>
		</table>
	</div>
	
	<div style="position:absolute;left:10px;top:100px;width:600px;height:auto;background-color:white;border:2px solid;border-color:darkgray;display:none;" id="selectGroupDiv">
		<div style="background-color:darkgray;padding:10px 5px 10px 5px;text-align:center;cursor:hand;">添加到分组..</div>
		<table style="width:100%;">
		<c:forEach items="${numberGroupList }" var="numberGroup">
			<tr>
				<td><c:out value="${numberGroup.title }"></c:out></td>
				<td><button onclick="addToGroup(${numberGroup.uid})">添加到该分组</button></td>
			</tr>
		</c:forEach>
		</table>
		<button style="width:100%;height:30px;" onclick="cancelSelectAddToGroup()">取消</button>
	</div>
</body>
</html>