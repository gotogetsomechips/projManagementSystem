<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>消息详情</title>
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
    <div class="info-title">消息详细信息</div>
    <table class="info-table">
        <tr>
            <th>标题</th>
            <td>${vo.title}</td>
        </tr>
        <tr>
            <th>发送人</th>
            <td>${vo.sender}</td>
        </tr>
        <tr>
            <th>接收人</th>
            <td>${vo.receiver}</td>
        </tr>
        <tr>
            <th>发送时间</th>
            <td><fmt:formatDate value="${vo.sendTime}" pattern="yyyy-MM-dd HH:mm" /></td>
        </tr>
        <tr>
            <th>消息内容</th>
            <td>${vo.content}</td>
        </tr>
        <tr>
            <th>创建时间</th>
            <td><fmt:formatDate value="${vo.createTime}" pattern="yyyy-MM-dd HH:mm" /></td>
        </tr>
    </table>
    <div class="button-group">
        <a href="${pageContext.request.contextPath}/message/toEdit?id=${vo.id}" class="button button-edit">编辑</a>
        <a href="${pageContext.request.contextPath}/message/list" class="button button-back">返回列表</a>
    </div>
</div>
</body>
</html>