<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>用户详情</title>
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
        .status-active {
            color: green;
            font-weight: bold;
        }
        .status-inactive {
            color: red;
            font-weight: bold;
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
    <div class="info-title">用户详细信息</div>
    <table class="info-table">
        <tr>
            <th>用户名</th>
            <td>${vo.username}</td>
        </tr>
        <tr>
            <th>真实姓名</th>
            <td>${vo.realName}</td>
        </tr>
        <tr>
            <th>联系电话</th>
            <td>${vo.phone}</td>
        </tr>
        <tr>
            <th>电子邮箱</th>
            <td>${vo.email}</td>
        </tr>
        <tr>
            <th>创建时间</th>
            <td><fmt:formatDate value="${vo.createTime}" pattern="yyyy-MM-dd HH:mm" /></td>
        </tr>
        <tr>
            <th>状态</th>
            <td>
                <c:choose>
                    <c:when test="${vo.status == 0}">
                        <span class="status-active">正常</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-inactive">禁用</span>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>
    <div class="button-group">
        <a href="${pageContext.request.contextPath}/user/toEdit?id=${vo.id}" class="button button-edit">编辑</a>
        <a href="${pageContext.request.contextPath}/user/list" class="button button-back">返回列表</a>
    </div>
</div>
</body>
</html>