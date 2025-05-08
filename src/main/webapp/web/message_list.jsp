<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>消息管理系统</title>
    <style type="text/css">
        body {
            margin-left: 0px;
            margin-top: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
            font-family: "Microsoft YaHei", Arial, sans-serif;
        }
        .tabfont01 {
            font-size: 9px;
            color: #555555;
            text-decoration: none;
            text-align: center;
        }
        .font051 {
            font-size: 12px;
            color: #333333;
            text-decoration: none;
            line-height: 20px;
        }
        .font201 {
            font-size: 12px;
            color: #FF0000;
            text-decoration: none;
        }
        .button {
            font-size: 14px;
            height: 37px;
        }
        html { overflow-x: auto; overflow-y: auto; border:0;}
        a {
            text-decoration: none;
            color: #1E90FF;
        }
        a:hover {
            text-decoration: underline;
            color: #FF4500;
        }
        .search-box {
            margin: 10px 0;
            display: flex;
            align-items: center;
        }
        .search-box select, .search-box input {
            padding: 5px;
            margin-right: 5px;
            border: 1px solid #ddd;
            border-radius: 3px;
        }
        .search-box button {
            padding: 5px 10px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        th.sortable {
            cursor: pointer;
        }
        th.sortable:hover {
            background-color: #f1f1f1;
        }
        .sort-icon::after {
            content: "↕";
            margin-left: 5px;
            font-size: 12px;
        }
        .sort-asc::after {
            content: "↑";
            margin-left: 5px;
            font-size: 12px;
        }
        .sort-desc::after {
            content: "↓";
            margin-left: 5px;
            font-size: 12px;
        }
        /* 弹窗样式 */
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 400px;
            border-radius: 5px;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
        }
        .modal-header {
            padding: 10px 0;
            border-bottom: 1px solid #eee;
            margin-bottom: 15px;
        }
        .modal-title {
            font-weight: bold;
            color: #333;
        }
        .modal-body {
            padding: 10px 0;
        }
        .modal-footer {
            padding: 10px 0;
            border-top: 1px solid #eee;
            margin-top: 15px;
            text-align: right;
        }
        .btn-close {
            background-color: #4CAF50;
            color: white;
            padding: 5px 10px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        .status-active {
            color: green;
        }
        .status-inactive {
            color: red;
        }
    </style>
    <link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        // 初始化排序状态，从URL参数获取
        var currentSort = {
            field: "${sortField}" || "id",
            direction: "${sortDirection}" || "DESC"
        };

        // 弹窗显示函数
        function showModal(message) {
            var modal = document.getElementById("messageModal");
            var messageContent = document.getElementById("messageContent");
            messageContent.textContent = message;
            modal.style.display = "block";
        }

        // 关闭弹窗
        function closeModal() {
            document.getElementById("messageModal").style.display = "none";
        }

        // 页面加载时设置排序指示器和处理消息
        $(document).ready(function() {
            updateSortIndicators();

            // 检查URL参数中的消息
            const urlParams = new URLSearchParams(window.location.search);
            const message = urlParams.get('message');

            if (message) {
                let displayMessage = "";

                // 根据消息类型设置显示内容
                switch(message) {
                    case "add_success":
                        displayMessage = "消息添加成功！";
                        break;
                    case "edit_success":
                        displayMessage = "消息修改成功！";
                        break;
                    case "delete_success":
                        displayMessage = "消息删除成功！";
                        break;
                    case "delete_fail":
                        displayMessage = "消息删除失败！";
                        break;
                    default:
                        displayMessage = message;
                }

                // 显示弹窗
                showModal(displayMessage);

                // 移除message参数避免重复提示
                const newUrl = window.location.pathname +
                    window.location.search.replace(/[?&]message=[^&]*/, '').replace(/^&/, '?');
                window.history.replaceState({}, document.title, newUrl);
            }

            // 点击弹窗外部关闭弹窗
            window.onclick = function(event) {
                var modal = document.getElementById("messageModal");
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }
        });

        function selectAll() {
            var obj = document.fom.elements;
            for (var i = 0; i < obj.length; i++) {
                if (obj[i].name == "delid") {
                    obj[i].checked = true;
                }
            }
        }

        function unselectAll() {
            var obj = document.fom.elements;
            for (var i = 0; i < obj.length; i++) {
                if (obj[i].name == "delid") {
                    if (obj[i].checked == true) obj[i].checked = false;
                    else obj[i].checked = true;
                }
            }
        }

        function batchDelete() {
            var ids = [];
            var checkboxes = document.getElementsByName("delid");
            for (var i = 0; i < checkboxes.length; i++) {
                if (checkboxes[i].checked) {
                    ids.push(checkboxes[i].value);
                }
            }

            if (ids.length === 0) {
                showModal("请选择要删除的消息");
                return;
            }

            if (confirm("确定要删除选中的消息吗？")) {
                // 创建隐藏表单提交
                var form = document.createElement("form");
                form.method = "post";
                form.action = "${pageContext.request.contextPath}/message/batchDelete";

                // 添加ids参数
                ids.forEach(function(id) {
                    var input = document.createElement("input");
                    input.type = "hidden";
                    input.name = "ids";
                    input.value = id;
                    form.appendChild(input);
                });

                // 添加排序参数（如果需要）
                var sortFieldInput = document.createElement("input");
                sortFieldInput.type = "hidden";
                sortFieldInput.name = "sortField";
                sortFieldInput.value = currentSort.field;
                form.appendChild(sortFieldInput);

                var sortDirectionInput = document.createElement("input");
                sortDirectionInput.type = "hidden";
                sortDirectionInput.name = "sortDirection";
                sortDirectionInput.value = currentSort.direction;
                form.appendChild(sortDirectionInput);

                // 添加页码参数
                var pageNumInput = document.createElement("input");
                pageNumInput.type = "hidden";
                pageNumInput.name = "pageNum";
                pageNumInput.value = "${pageNum}";
                form.appendChild(pageNumInput);

                document.body.appendChild(form);
                form.submit();
            }
        }

        function addMessage() {
            window.location.href = "${pageContext.request.contextPath}/message/toAdd";
        }

        function sort(field) {
            // 获取当前排序状态
            if (currentSort.field === field) {
                currentSort.direction = currentSort.direction === "ASC" ? "DESC" : "ASC";
            } else {
                currentSort.field = field;
                currentSort.direction = "ASC";
            }

            // 更新排序指示器
            updateSortIndicators();

            // 获取所有消息行
            var rows = $('tr.bgcolor').get();

            // 根据字段和方向进行排序
            rows.sort(function(a, b) {
                var A, B;

                // 获取对应字段的单元格内容
                if (field === 'title') {
                    A = $(a).find('td:eq(1)').text().trim().toLowerCase();
                    B = $(b).find('td:eq(1)').text().trim().toLowerCase();
                } else {
                    // 默认按ID排序
                    A = $(a).find('input[name="delid"]').val();
                    B = $(b).find('input[name="delid"]').val();
                    // 确保数值比较
                    A = parseInt(A);
                    B = parseInt(B);
                }

                // 排序规则
                var result = 0;
                if (A < B) {
                    result = -1;
                } else if (A > B) {
                    result = 1;
                }

                // 根据排序方向调整结果
                return currentSort.direction === "ASC" ? result : -result;
            });

            // 重新添加排序后的行到表格中
            $.each(rows, function(index, row) {
                $(row).detach().appendTo('table.newfont03 tbody');
            });
        }

        function updateSortIndicators() {
            // 清除所有排序指示器
            $(".sortable").removeClass("sort-asc sort-desc sort-icon").addClass("sort-icon");

            // 设置当前排序字段的指示器
            if (currentSort.field) {
                var selector = "." + currentSort.field + "-sortable";
                $(selector).removeClass("sort-icon").addClass(currentSort.direction === "ASC" ? "sort-asc" : "sort-desc");
            }
        }

        function goToPage(pageNum) {
            var url = "${pageContext.request.contextPath}/message/list?pageNum=" + pageNum;

            // 添加搜索条件（如果有）
            var searchColumn = "${searchColumn}";
            var keyword = "${keyword}";
            if (searchColumn && keyword) {
                url += "&searchColumn=" + searchColumn + "&keyword=" + keyword;
            }

            // 添加排序条件
            if (currentSort.field) {
                url += "&sortField=" + currentSort.field + "&sortDirection=" + currentSort.direction;
            }

            window.location.href = url;
        }

        function jumpToPage() {
            var pageNum = document.getElementById("jumpPageNum").value;
            var totalPages = ${totalPages};

            // 验证输入的页码是否在合理范围内
            if (pageNum < 1 || pageNum > totalPages) {
                showModal("请输入1到" + totalPages + "之间的页码！");
                document.getElementById("jumpPageNum").value = ${pageNum};
                return;
            }

            goToPage(pageNum);
        }

        function confirmDelete(id, sortField, sortDirection) {
            if (confirm('确定要删除此消息吗？')) {
                var url = '${pageContext.request.contextPath}/message/delete?id=' + id + '&pageNum=${pageNum}';
                if (sortField && sortDirection) {
                    url += '&sortField=' + sortField + '&sortDirection=' + sortDirection;
                }
                window.location.href = url;
            }
        }

        function searchMessages() {
            var searchColumn = document.getElementById("searchColumn").value;
            var keyword = document.getElementById("keyword").value;

            window.location.href = "${pageContext.request.contextPath}/message/list?searchColumn=" + searchColumn +
                "&keyword=" + keyword + "&sortField=" + currentSort.field + "&sortDirection=" + currentSort.direction;
        }
    </script>
</head>
<body>
<!-- 消息弹窗 -->
<div id="messageModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h4 class="modal-title">系统提示</h4>
        </div>
        <div class="modal-body">
            <p id="messageContent"></p>
        </div>
        <div class="modal-footer">
            <button class="btn-close" onclick="closeModal()">确定</button>
        </div>
    </div>
</div>

<form name="fom" id="fom" method="post" action="">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td height="30">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td height="62" background="${pageContext.request.contextPath}/images/nav04.gif">
                            <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="21"><img src="${pageContext.request.contextPath}/images/ico07.gif" width="20" height="18" /></td>
                                    <td>
                                        <div class="search-box">
                                            <select id="searchColumn" name="searchColumn">
                                                <option value="title" ${searchColumn == 'title' ? 'selected' : ''}>按标题</option>
                                                <option value="sender" ${searchColumn == 'sender' ? 'selected' : ''}>按发送人</option>
                                                <option value="receiver" ${searchColumn == 'receiver' ? 'selected' : ''}>按接收人</option>
                                            </select>
                                            <input id="keyword" name="keyword" type="text" value="${keyword}" placeholder="请输入关键词" />
                                            <button type="button" class="right-button02" onclick="searchMessages()">搜索</button>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table id="subtree1" style="DISPLAY: " width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td>
                            <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td height="20">
                                            <span class="font051">选择：
                                                <a href="#" class="right-font08" onclick="selectAll();">全选</a>-
                                                <a href="#" class="right-font08" onclick="unselectAll();">反选</a>
                                            </span>
                                        <input name="batchDeleteBtn" type="button" class="right-button08" value="删除所选消息" onclick="batchDelete();" />
                                        <input name="addMessageBtn" type="button" class="right-button08" value="添加消息" onclick="addMessage();" />
                                    </td>
                                </tr>
                                <tr>
                                    <td height="40" class="font42">
                                        <table width="100%" border="0" cellpadding="4" cellspacing="1" bgcolor="#464646" class="newfont03">
                                            <tr class="CTitle">
                                                <td height="22" colspan="7" align="center" style="font-size:16px">消息详细列表</td>
                                            </tr>
                                            <tr bgcolor="#EEEEEE">
                                                <td width="4%" align="center" height="30">选择</td>
                                                <td width="20%" class="sortable title-sortable" onclick="sort('title')">标题</td>
                                                <td width="15%">发送人</td>
                                                <td width="15%">接收人</td>
                                                <td width="20%">发送时间</td>
                                                <td width="8%">状态</td>
                                                <td width="15%">操作</td>
                                            </tr>
                                            <c:choose>
                                                <c:when test="${empty list}">
                                                    <tr bgcolor="#FFFFFF">
                                                        <td colspan="7" align="center">暂无消息数据</td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach items="${list}" var="message">
                                                        <tr bgcolor="#FFFFFF" class="bgcolor">
                                                            <td height="20"><input type="checkbox" name="delid" value="${message.id}" /></td>
                                                            <td>${message.title}</td>
                                                            <td>${message.sender}</td>
                                                            <td>${message.receiver}</td>
                                                            <td><fmt:formatDate value="${message.sendTime}" pattern="yyyy-MM-dd HH:mm" /></td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${message.status == 0}">
                                                                        <span class="status-active">已读</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="status-inactive">未读</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <a href="${pageContext.request.contextPath}/message/toEdit?id=${message.id}&pageNum=${pageNum}">编辑</a> |
                                                                <a href="${pageContext.request.contextPath}/message/info?id=${message.id}">详情</a> |
                                                                <a href="javascript:void(0);" onclick="confirmDelete(${message.id}, '${sortField}', '${sortDirection}')">删除</a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <!-- 分页区域 -->
                            <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td height="6"><img src="${pageContext.request.contextPath}/images/spacer.gif" width="1" height="1" /></td>
                                </tr>
                                <tr>
                                    <td height="33">
                                        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="right-font08">
                                            <tr>
                                                <td width="40%">
                                                    共 <span class="right-text09">${totalCount}</span> 条记录 |
                                                    共 <span class="right-text09">${totalPages}</span> 页 |
                                                    当前第 <span class="right-text09">${pageNum}</span> 页
                                                </td>
                                                <td width="60%" align="right">
                                                    [
                                                    <c:choose>
                                                        <c:when test="${pageNum > 1}">
                                                            <a href="javascript:void(0)" onclick="goToPage(1)" class="right-font08">首页</a> |
                                                            <a href="javascript:void(0)" onclick="goToPage(${pageNum-1})" class="right-font08">上一页</a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="right-font08">首页</span> |
                                                            <span class="right-font08">上一页</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    |
                                                    <c:choose>
                                                        <c:when test="${pageNum < totalPages}">
                                                            <a href="javascript:void(0)" onclick="goToPage(${pageNum+1})" class="right-font08">下一页</a> |
                                                            <a href="javascript:void(0)" onclick="goToPage(${totalPages})" class="right-font08">末页</a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="right-font08">下一页</span> |
                                                            <span class="right-font08">末页</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    ] 转至：
                                                    <input id="jumpPageNum" type="text" class="right-textfield03" size="2" value="${pageNum}" />
                                                    <input name="goPage" type="button" class="right-button06" value=" " onclick="jumpToPage()" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</form>
</body>
</html>