<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>任务详情</title>
    <style type="text/css">
        body {
            margin: 0;
            padding: 0;
            font-family: "Microsoft YaHei", Arial, sans-serif;
        }
        .container {
            width: 90%;
            margin: 20px auto;
        }
        .info-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
        }
        .info-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        .info-table th, .info-table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        .info-table th {
            background-color: #f5f5f5;
            width: 20%;
        }
        .info-table td {
            background-color: #fff;
        }
        .priority-high {
            color: red;
            font-weight: bold;
        }
        .priority-medium {
            color: orange;
            font-weight: bold;
        }
        .priority-low {
            color: green;
            font-weight: bold;
        }
        .status-not-started {
            color: #666;
        }
        .status-in-progress {
            color: #1E90FF;
        }
        .status-completed {
            color: green;
        }
        .status-cancelled {
            color: red;
        }
        .button-group {
            margin-top: 20px;
            text-align: center;
        }
        .button {
            padding: 8px 15px;
            margin: 0 5px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }
        .button-edit {
            background-color: #4CAF50;
            color: white;
        }
        .button-back {
            background-color: #f44336;
            color: white;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="info-title">任务详细信息</div>
    <table class="info-table">
        <tr>
            <th>任务标题</th>
            <td>${vo.title}</td>
        </tr>
        <tr>
            <th>任务内容</th>
            <td>${vo.content}</td>
        </tr>
        <tr>
            <th>创建时间</th>
            <td><fmt:formatDate value="${vo.createTime}" pattern="yyyy-MM-dd HH:mm" /></td>
        </tr>
        <tr>
            <th>创建者</th>
            <td>${vo.creator}</td>
        </tr>
        <tr>
            <th>执行人</th>
            <td>${vo.executor}</td>
        </tr>
        <tr>
            <th>优先级</th>
            <td>
                <c:choose>
                    <c:when test="${vo.priority == '高'}">
                        <span class="priority-high">${vo.priority}</span>
                    </c:when>
                    <c:when test="${vo.priority == '中'}">
                        <span class="priority-medium">${vo.priority}</span>
                    </c:when>
                    <c:otherwise>
                        <span class="priority-low">${vo.priority}</span>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
        <tr>
            <th>状态</th>
            <td>
                <c:choose>
                    <c:when test="${vo.status == '未开始'}">
                        <span class="status-not-started">${vo.status}</span>
                    </c:when>
                    <c:when test="${vo.status == '进行中'}">
                        <span class="status-in-progress">${vo.status}</span>
                    </c:when>
                    <c:when test="${vo.status == '已完成'}">
                        <span class="status-completed">${vo.status}</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-cancelled">${vo.status}</span>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>
    <div class="button-group">
        <a href="${pageContext.request.contextPath}/task/toEdit?id=${vo.id}" class="button button-edit">编辑</a>
        <a href="${pageContext.request.contextPath}/task/list" class="button button-back">返回列表</a>
    </div>
</div>
</body>
</html>