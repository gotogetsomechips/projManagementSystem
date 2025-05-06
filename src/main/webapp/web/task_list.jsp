<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>任务管理系统</title>
    <style type="text/css">
        body {
            margin: 0;
            padding: 0;
            font-family: "宋体", Arial, sans-serif;
            font-size: 12px;
        }
        .container {
            width: 95%;
            margin: 0 auto;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .table th, .table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        .table th {
            background-color: #f2f2f2;
            cursor: pointer;
        }
        .table th:hover {
            background-color: #e6e6e6;
        }
        .table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .table tr:hover {
            background-color: #f1f1f1;
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
        .pagination {
            margin-top: 20px;
            text-align: center;
        }
        .pagination a {
            color: #333;
            padding: 6px 12px;
            text-decoration: none;
            border: 1px solid #ddd;
            margin: 0 4px;
        }
        .pagination a.active {
            background-color: #4CAF50;
            color: white;
            border: 1px solid #4CAF50;
        }
        .pagination a:hover:not(.active) {
            background-color: #ddd;
        }
        .pagination a.disabled {
            color: #ccc;
            pointer-events: none;
            cursor: default;
        }
        .search-form {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f5f5f5;
            border-radius: 4px;
        }
        .search-form input, .search-form select {
            padding: 6px;
            margin-right: 10px;
        }
        .search-form button {
            padding: 6px 12px;
            background-color: #5cb85c;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .search-form button:hover {
            background-color: #4cae4c;
        }
        .error {
            color: red;
            margin-bottom: 10px;
        }
        .success {
            color: green;
            margin-bottom: 10px;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function sortTasks(column) {
            window.location.href = "${pageContext.request.contextPath}/task/list?orderBy=" + column;
        }

        function deleteTask(id) {
            if (confirm("确定要删除这条任务吗？")) {
                $.post("${pageContext.request.contextPath}/task/delete", {id: id}, function(data) {
                    if (data.success) {
                        alert(data.message);
                        window.location.reload();
                    } else {
                        alert(data.message);
                    }
                });
            }
        }

        function batchDelete() {
            var ids = [];
            $("input[name='delid']:checked").each(function() {
                ids.push($(this).val());
            });

            if (ids.length === 0) {
                alert("请至少选择一条任务");
                return;
            }

            if (confirm("确定要删除选中的" + ids.length + "条任务吗？")) {
                $.post("${pageContext.request.contextPath}/task/batchDelete", {ids: ids}, function(data) {
                    if (data.success) {
                        alert(data.message);
                        window.location.reload();
                    } else {
                        alert(data.message);
                    }
                });
            }
        }

        function checkTitle() {
            var title = $("#title").val();
            if (title) {
                $.get("${pageContext.request.contextPath}/task/checkTitle", {title: title}, function(data) {
                    if (!data.valid) {
                        $("#titleError").text("任务标题已存在");
                    } else {
                        $("#titleError").text("");
                    }
                });
            }
        }
    </script>
</head>
<body>
<div class="container">
    <h2>任务管理系统</h2>

    <div class="search-form">
        <form action="${pageContext.request.contextPath}/task/search" method="post">
            任务标题: <input type="text" name="title" value="${condition.title}">
            创建者: <input type="text" name="creatorName" value="${condition.creatorName}">
            执行人: <input type="text" name="executorName" value="${condition.executorName}">
            优先级:
            <select name="priority">
                <option value="">全部</option>
                <option value="1" ${condition.priority == 1 ? 'selected' : ''}>紧急</option>
                <option value="2" ${condition.priority == 2 ? 'selected' : ''}>高</option>
                <option value="3" ${condition.priority == 3 ? 'selected' : ''}>普通</option>
                <option value="4" ${condition.priority == 4 ? 'selected' : ''}>低</option>
            </select>
            <button type="submit">查询</button>
            <a href="${pageContext.request.contextPath}/task/list" style="margin-left: 10px;">重置</a>
        </form>
    </div>

    <div>
        <button onclick="batchDelete()">批量删除</button>
        <a href="${pageContext.request.contextPath}/task/add" style="margin-left: 10px;">
            <button>添加任务</button>
        </a>
    </div>

    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <c:if test="${not empty success}">
        <div class="success">${success}</div>
    </c:if>

    <table class="table">
        <thead>
        <tr>
            <th width="5%"><input type="checkbox" onclick="toggleSelectAll(this)"></th>
            <th width="20%" onclick="sortTasks('title')">任务标题</th>
            <th width="15%" onclick="sortTasks('create_time')">创建时间</th>
            <th width="10%" onclick="sortTasks('creator_name')">创建者</th>
            <th width="10%" onclick="sortTasks('executor_name')">执行人</th>
            <th width="10%" onclick="sortTasks('priority')">优先级</th>
            <th width="15%">状态</th>
            <th width="15%">操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${tasks}" var="task">
            <tr>
                <td><input type="checkbox" name="delid" value="${task.id}"></td>
                <td>${task.title}</td>
                <td><fmt:formatDate value="${task.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                <td>${task.creatorName}</td>
                <td>${task.executorName}</td>
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
                <td>
                    <c:choose>
                        <c:when test="${task.status == 1}">未开始</c:when>
                        <c:when test="${task.status == 2}">进行中</c:when>
                        <c:when test="${task.status == 3}">已完成</c:when>
                        <c:when test="${task.status == 4}">已取消</c:when>
                    </c:choose>
                </td>
                <td>
                    <a href="${pageContext.request.contextPath}/task/edit?id=${task.id}">编辑</a> |
                    <a href="${pageContext.request.contextPath}/task/view?id=${task.id}">查看</a> |
                    <a href="javascript:void(0)" onclick="deleteTask(${task.id})">删除</a>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty tasks}">
            <tr>
                <td colspan="8" style="text-align: center;">暂无任务数据</td>
            </tr>
        </c:if>
        </tbody>
    </table>

    <div class="pagination">
        <a href="#" class="disabled">&laquo; 首页</a>
        <a href="#" class="disabled">上一页</a>
        <a href="#" class="active">1</a>
        <a href="#">2</a>
        <a href="#">3</a>
        <a href="#">下一页</a>
        <a href="#">尾页 &raquo;</a>
        转到 <input type="text" size="1"> 页
        <button>跳转</button>
    </div>
</div>

<script>
    function toggleSelectAll(source) {
        var checkboxes = document.getElementsByName('delid');
        for (var i = 0; i < checkboxes.length; i++) {
            checkboxes[i].checked = source.checked;
        }
    }
</script>
</body>
</html>