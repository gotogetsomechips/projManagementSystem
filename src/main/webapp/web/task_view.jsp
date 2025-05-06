<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>查看任务</title>
    <style type="text/css">
        body {
            font-family: "宋体", Arial, sans-serif;
            font-size: 14px;
            line-height: 1.5;
            color: #333;
            background-color: #f5f5f5;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            margin-top: 0;
            color: #333;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .detail-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .detail-table th, .detail-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        .detail-table th {
            width: 20%;
            background-color: #f2f2f2;
        }
        .priority-high {
            color: red;
            font-weight: bold;
        }
        .priority-normal {
            color: orange;
        }
        .priority-low {
            color: green;
        }
        .btn-back {
            display: inline-block;
            background-color: #337ab7;
            color: white;
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 4px;
            margin-top: 20px;
        }
        .btn-back:hover {
            background-color: #286090;
        }
        .content-cell {
            white-space: pre-wrap;
            word-wrap: break-word;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>任务详情</h2>

    <table class="detail-table">
        <tr>
            <th>任务标题</th>
            <td>${task.title}</td>
        </tr>
        <tr>
            <th>任务内容</th>
            <td class="content-cell">${task.content}</td>
        </tr>
        <tr>
            <th>创建时间</th>
            <td><fmt:formatDate value="${task.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
        </tr>
        <tr>
            <th>创建者</th>
            <td>${task.creatorName}</td>
        </tr>
        <tr>
            <th>执行人</th>
            <td>${task.executorName}</td>
        </tr>
        <tr>
            <th>优先级</th>
            <td>
                <c:choose>
                    <c:when test="${task.priority == 1}">
                        <span class="priority-high">紧急</span>
                    </c:when>
                    <c:when test="${task.priority == 2}">
                        <span class="priority-high">高</span>
                    </c:when>
                    <c:when test="${task.priority == 3}">
                        <span class="priority-normal">普通</span>
                    </c:when>
                    <c:when test="${task.priority == 4}">
                        <span class="priority-low">低</span>
                    </c:when>
                </c:choose>
            </td>
        </tr>
        <tr>
            <th>状态</th>
            <td>
                <c:choose>
                    <c:when test="${task.status == 1}">未开始</c:when>
                    <c:when test="${task.status == 2}">进行中</c:when>
                    <c:when test="${task.status == 3}">已完成</c:when>
                    <c:when test="${task.status == 4}">已取消</c:when>
                </c:choose>
            </td>
        </tr>
        <tr>
            <th>开始时间</th>
            <td><fmt:formatDate value="${task.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
        </tr>
        <tr>
            <th>结束时间</th>
            <td><fmt:formatDate value="${task.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
        </tr>
        <tr>
            <th>更新时间</th>
            <td><fmt:formatDate value="${task.updateTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
        </tr>
    </table>

    <a href="${pageContext.request.contextPath}/task/list" class="btn-back">返回列表</a>
</div>
</body>
</html>