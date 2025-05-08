<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>薪资详情</title>
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
        .status-paid {
            color: green;
            font-weight: bold;
        }
        .status-unpaid {
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
    <div class="info-title">薪资详细信息</div>
    <table class="info-table">
        <tr>
            <th>员工姓名</th>
            <td>${vo.employeeName}</td>
        </tr>
        <tr>
            <th>年份</th>
            <td>${vo.year}年</td>
        </tr>
        <tr>
            <th>月份</th>
            <td>${vo.month}月</td>
        </tr>
        <tr>
            <th>基本工资</th>
            <td><fmt:formatNumber value="${vo.baseSalary}" pattern="#,##0.00" /></td>
        </tr>
        <tr>
            <th>奖金</th>
            <td><fmt:formatNumber value="${vo.bonus}" pattern="#,##0.00" /></td>
        </tr>
        <tr>
            <th>扣款</th>
            <td><fmt:formatNumber value="${vo.deduction}" pattern="#,##0.00" /></td>
        </tr>
        <tr>
            <th>应发工资</th>
            <td><fmt:formatNumber value="${vo.totalSalary}" pattern="#,##0.00" /></td>
        </tr>
        <tr>
            <th>实发工资</th>
            <td><fmt:formatNumber value="${vo.actualSalary}" pattern="#,##0.00" /></td>
        </tr>
        <tr>
            <th>状态</th>
            <td>
                <c:choose>
                    <c:when test="${vo.status == 1}">
                        <span class="status-paid">已发放</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-unpaid">未发放</span>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
        <tr>
            <th>发放人</th>
            <td>${vo.paymentBy}</td>
        </tr>
        <tr>
            <th>发放时间</th>
            <td><fmt:formatDate value="${vo.paymentTime}" pattern="yyyy-MM-dd HH:mm" /></td>
        </tr>
        <tr>
            <th>备注</th>
            <td>${vo.remark}</td>
        </tr>
        <tr>
            <th>创建时间</th>
            <td><fmt:formatDate value="${vo.createTime}" pattern="yyyy-MM-dd HH:mm" /></td>
        </tr>
    </table>
    <div class="button-group">
        <a href="${pageContext.request.contextPath}/salary/toEdit?id=${vo.id}" class="button button-edit">编辑</a>
        <a href="${pageContext.request.contextPath}/salary/list" class="button button-back">返回列表</a>
    </div>
</div>
</body>
</html>