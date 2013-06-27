<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="cutils" uri="/cutils" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0"/>
<title>Statistics</title>
</head>
<body>
	<div style="color:red;padding-top:10px;font-size:20px;">总计</div>
	<div style="margin-top:5px;padding-top:5px;padding-bottom:10px;padding-left:10px;background-color:lightgray;">
		<div>
			已扫瞄数量：<c:out value="${probed }"></c:out>
		</div>
		<div>
			iMessage用户数量： <c:out value="${numOfiMessageUser }"></c:out>
		</div>
	</div>
	<div>
		<c:choose>
			<c:when test="${empty clients}">
				
			</c:when>
			<c:otherwise>
				<div style="color:red;padding-top:20px;font-size:20px;">客户端连接列表</div>
				<c:forEach items="${clients }" var="client">
					<div style="margin-top:5px;padding-top:5px;padding-bottom:10px;padding-left:10px;background-color:lightgray;">
						<div style="float:left;width=80%;">
							<div>IP地址：<c:out value="${client.ipAddress }"></c:out></div>
							<div>标记数量：<c:out value="${client.count }"></c:out></div>
							<div>成功数量：<c:out value="${client.successCount }"></c:out></div>
							<jsp:useBean id="tmpDate" class="java.util.Date"></jsp:useBean>
							<c:set target="${tmpDate }" property="time" value="${client.firstRequestTime }"></c:set>
							<div>首次连接时间：<fmt:formatDate value="${tmpDate}" pattern="yyyy-MM-dd HH:mm:ss" dateStyle="long"/></div>
							<c:set target="${tmpDate }" property="time" value="${client.lastRequestTime }"></c:set>
							<div>上次连接时间：<fmt:formatDate value="${tmpDate}" pattern="yyyy-MM-dd HH:mm:ss" dateStyle="long"/></div>
						</div>
						<div style="float:right;width=19%;background-color:clear;padding-right:20px;padding-top:30px;">
							<a href="clearStat.do?ip=${cutils:urlEncode(client.ipAddress)}">清零</a>
							<c:set var="contains" value="false" />
							<c:forEach var="item" items="${blockedIps}">
								<c:if test="${item eq client.ipAddress}">
							    	<c:set var="contains" value="true" />
							  	</c:if>
							</c:forEach>
							<c:choose>
								<c:when test="${not contains }">
									<a href="blockIp.do?ip=${cutils:urlEncode(client.ipAddress)}">屏蔽</a>
								</c:when>
								<c:otherwise>
									<a href="removeBlockIp.do?ip=${cutils:urlEncode(client.ipAddress)}">开启</a>	
								</c:otherwise>
							</c:choose>
							
						</div>
						<div style="clear:both;"></div> 
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</div>
	
</body>
</html>