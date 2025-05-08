<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>薪资管理系统</title>
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
        .status-paid {
            color: green;
        }
        .status-unpaid {
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
                        displayMessage = "薪资记录添加成功！";
                        break;
                    case "edit_success":
                        displayMessage = "薪资记录修改成功！";
                        break;
                    case "delete_success":
                        displayMessage = "薪资记录删除成功！";
                        break;
                    case "delete_fail":
                        displayMessage = "薪资记录删除失败！";
                        break;
                    case "pay_success":
                        displayMessage = "薪资发放成功！";
                        break;
                    case "pay_fail":
                        displayMessage = "薪资发放失败！";
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
                showModal("请选择要删除的薪资记录");
                return;
            }

            if (confirm("确定要删除选中的薪资记录吗？")) {
                // 创建隐藏表单提交
                var form = document.createElement("form");
                form.method = "post";
                form.action = "${pageContext.request.contextPath}/salary/batchDelete";

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

                document.body.appendChild(form);
                form.submit();
            }
        }

        function batchPay() {
            var ids = [];
            var checkboxes = document.getElementsByName("delid");
            for (var i = 0; i < checkboxes.length; i++) {
                if (checkboxes[i].checked) {
                    ids.push(checkboxes[i].value);
                }
            }

            if (ids.length === 0) {
                showModal("请选择要发放的薪资记录");
                return;
            }

            if (confirm("确定要发放选中的薪资记录吗？")) {
                // 创建隐藏表单提交
                var form = document.createElement("form");
                form.method = "post";
                form.action = "${pageContext.request.contextPath}/salary/batchPay";

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

                document.body.appendChild(form);
                form.submit();
            }
        }

        function addSalary() {
            window.location.href = "${pageContext.request.contextPath}/salary/toAdd";
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

            // 获取所有薪资行
            var rows = $('tr.bgcolor').get();

            // 根据字段和方向进行排序
            rows.sort(function(a, b) {
                var A, B;

                // 获取对应字段的单元格内容
                if (field === 'employeeName') {
                    A = $(a).find('td:eq(1)').text().trim().toLowerCase();
                    B = $(b).find('td:eq(1)').text().trim().toLowerCase();
                } else if (field === 'year') {
                    A = parseInt($(a).find('td:eq(2)').text().trim());
                    B = parseInt($(b).find('td:eq(2)').text().trim());
                } else if (field === 'month') {
                    A = parseInt($(a).find('td:eq(3)').text().trim());
                    B = parseInt($(b).find('td:eq(3)').text().trim());
                } else if (field === 'totalSalary') {
                    A = parseFloat($(a).find('td:eq(4)').text().trim());
                    B = parseFloat($(b).find('td:eq(4)').text().trim());
                } else if (field === 'actualSalary') {
                    A = parseFloat($(a).find('td:eq(6)').text().trim());
                    B = parseFloat($(b).find('td:eq(6)').text().trim());
                } else if (field === 'status') {
                    // 提取状态文本（不含HTML标记）
                    A = $(a).find('td:eq(7)').text().trim().toLowerCase();
                    B = $(b).find('td:eq(7)').text().trim().toLowerCase();

                    // 自定义排序顺序：已发放>未发放
                    var statusOrder = {'已发放': 2, '未发放': 1};
                    A = statusOrder[A] || 0;
                    B = statusOrder[B] || 0;
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
            var url = "${pageContext.request.contextPath}/salary/list?pageNum=" + pageNum;

            // 添加搜索条件（如果有）
            var searchColumn = "${searchColumn}";
            var keyword = "${keyword}";
            var year = "${year}";
            var month = "${month}";

            if (searchColumn && keyword) {
                url += "&searchColumn=" + searchColumn + "&keyword=" + keyword;
            }
            if (year) {
                url += "&year=" + year;
            }
            if (month) {
                url += "&month=" + month;
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
            if (confirm('确定要删除此薪资记录吗？')) {
                var url = '${pageContext.request.contextPath}/salary/delete?id=' + id + '&pageNum=${pageNum}';
                if (sortField && sortDirection) {
                    url += '&sortField=' + sortField + '&sortDirection=' + sortDirection;
                }
                window.location.href = url;
            }
        }

        function confirmPay(id, sortField, sortDirection) {
            if (confirm('确定要发放此薪资记录吗？')) {
                var url = '${pageContext.request.contextPath}/salary/pay?id=' + id + '&pageNum=${pageNum}';
                if (sortField && sortDirection) {
                    url += '&sortField=' + sortField + '&sortDirection=' + sortDirection;
                }
                window.location.href = url;
            }
        }

        function searchSalaries() {
            var searchColumn = document.getElementById("searchColumn").value;
            var keyword = document.getElementById("keyword").value;
            var year = document.getElementById("year").value;
            var month = document.getElementById("month").value;

            window.location.href = "${pageContext.request.contextPath}/salary/list?searchColumn=" + searchColumn +
                "&keyword=" + keyword + "&year=" + year + "&month=" + month +
                "&sortField=" + currentSort.field + "&sortDirection=" + currentSort.direction;
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
                                                <option value="employeeName" ${searchColumn == 'employeeName' ? 'selected' : ''}>按员工姓名</option>
                                            </select>
                                            <input id="keyword" name="keyword" type="text" value="${keyword}" placeholder="请输入关键词" />

                                            <select id="year" name="year">
                                                <option value="">选择年份</option>
                                                <c:forEach var="y" begin="2020" end="2030">
                                                    <option value="${y}" ${year == y ? 'selected' : ''}>${y}年</option>
                                                </c:forEach>
                                            </select>

                                            <select id="month" name="month">
                                                <option value="">选择月份</option>
                                                <c:forEach var="m" begin="1" end="12">
                                                    <option value="${m}" ${month == m ? 'selected' : ''}>${m}月</option>
                                                </c:forEach>
                                            </select>

                                            <button type="button" class="right-button02" onclick="searchSalaries()">搜索</button>
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
                                        <input name="batchDeleteBtn" type="button" class="right-button08" value="删除所选记录" onclick="batchDelete();" />
                                        <input name="batchPayBtn" type="button" class="right-button08" value="发放所选薪资" onclick="batchPay();" />
                                        <input name="addSalaryBtn" type="button" class="right-button08" value="添加薪资记录" onclick="addSalary();" />
                                    </td>
                                </tr>
                                <tr>
                                    <td height="40" class="font42">
                                        <table width="100%" border="0" cellpadding="4" cellspacing="1" bgcolor="#464646" class="newfont03">
                                            <tr class="CTitle">
                                                <td height="22" colspan="10" align="center" style="font-size:16px">薪资详细列表</td>
                                            </tr>
                                            <tr bgcolor="#EEEEEE">
                                                <td width="4%" align="center" height="30">选择</td>
                                                <td width="15%" class="sortable employeeName-sortable" onclick="sort('employeeName')">员工姓名</td>
                                                <td width="8%">年份</td>
                                                <td width="8%">月份</td>
                                                <td width="10%">应发工资</td>
                                                <td width="10%">奖金</td>
                                                <td width="10%">实发工资</td>
                                                <td width="8%">状态</td>
                                                <td width="10%">发放人</td>
                                                <td width="15%">操作</td>
                                            </tr>
                                            <c:choose>
                                                <c:when test="${empty list}">
                                                    <tr bgcolor="#FFFFFF">
                                                        <td colspan="10" align="center">暂无薪资数据</td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach items="${list}" var="salary">
                                                        <tr bgcolor="#FFFFFF" class="bgcolor">
                                                            <td height="20"><input type="checkbox" name="delid" value="${salary.id}" /></td>
                                                            <td>${salary.employeeName}</td>
                                                            <td>${salary.year}年</td>
                                                            <td>${salary.month}月</td>
                                                            <td><fmt:formatNumber value="${salary.totalSalary}" pattern="#,##0.00" /></td>
                                                            <td><fmt:formatNumber value="${salary.bonus}" pattern="#,##0.00" /></td>
                                                            <td><fmt:formatNumber value="${salary.actualSalary}" pattern="#,##0.00" /></td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${salary.status == 1}">
                                                                        <span class="status-paid">已发放</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="status-unpaid">未发放</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>${salary.paymentBy}</td>
                                                            <td>
                                                                <a href="${pageContext.request.contextPath}/salary/toEdit?id=${salary.id}&pageNum=${pageNum}">编辑</a> |
                                                                <a href="${pageContext.request.contextPath}/salary/info?id=${salary.id}">详情</a> |
                                                                <a href="javascript:void(0);" onclick="confirmDelete(${salary.id}, '${sortField}', '${sortDirection}')">删除</a>
                                                                <c:if test="${salary.status == 0}">
                                                                    | <a href="javascript:void(0);" onclick="confirmPay(${salary.id}, '${sortField}', '${sortDirection}')">发放</a>
                                                                </c:if>
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