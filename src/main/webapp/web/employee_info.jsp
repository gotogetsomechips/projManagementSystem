<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>员工详情</title>
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
    <div class="info-title">员工详细信息</div>
    <table class="info-table">
        <tr>
            <th>员工编号</th>
            <td>${vo.employeeId}</td>
        </tr>
        <tr>
            <th>员工姓名</th>
            <td>${vo.realName}</td>
        </tr>
        <tr>
            <th>职位</th>
            <td>${vo.position}</td>
        </tr>
        <tr>
            <th>员工类型</th>
            <td>${vo.employeeType}</td>
        </tr>
        <tr>
            <th>身份证号码</th>
            <td>${vo.idCard}</td>
        </tr>
        <tr>
            <th>性别</th>
            <td>${vo.gender}</td>
        </tr>
        <tr>
            <th>年龄</th>
            <td>${vo.age}</td>
        </tr>
        <tr>
            <th>出生年月</th>
            <td><fmt:formatDate value="${vo.birthDate}" pattern="yyyy-MM-dd" /></td>
        </tr>
        <tr>
            <th>联系电话</th>
            <td>${vo.phone}</td>
        </tr>
        <tr>
            <th>创建时间</th>
            <td><fmt:formatDate value="${vo.createTime}" pattern="yyyy-MM-dd HH:mm" /></td>
        </tr>
        <tr>
            <th>更新时间</th>
            <td><fmt:formatDate value="${vo.updateTime}" pattern="yyyy-MM-dd HH:mm" /></td>
        </tr>
    </table>
    <div class="button-group">
        <a href="${pageContext.request.contextPath}/employee/toEdit?id=${vo.id}" class="button button-edit">编辑</a>
        <a href="${pageContext.request.contextPath}/employee/list" class="button button-back">返回列表</a>
    </div>
</div>
</body>
</html>