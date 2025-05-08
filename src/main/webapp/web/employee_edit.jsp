<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>编辑员工</title>
    <style type="text/css">
        body {
            margin: 0;
            padding: 0;
            font-family: "Microsoft YaHei", Arial, sans-serif;
            background-color: #f5f5f5;
        }
        .container {
            width: 80%;
            margin: 20px auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .form-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 3px;
            box-sizing: border-box;
        }
        textarea.form-control {
            height: 100px;
            resize: vertical;
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
        .button-submit {
            background-color: #4CAF50;
            color: white;
        }
        .button-cancel {
            background-color: #f44336;
            color: white;
        }
        select.form-control {
            height: 34px;
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
            background-color: #f44336;
            color: white;
            padding: 5px 10px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function showErrorModal(message) {
            var modal = document.getElementById("errorModal");
            var errorMessage = document.getElementById("errorMessage");
            errorMessage.textContent = message;
            modal.style.display = "block";
        }

        $(document).ready(function() {
            // 关闭弹窗
            $(".btn-close").click(function() {
                $("#errorModal").hide();
            });

            // 点击弹窗外部关闭弹窗
            window.onclick = function(event) {
                var modal = document.getElementById("errorModal");
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }

            // 检查是否有错误需要显示
            var error = "${error}";
            if (error && error.trim() !== "") {
                showErrorModal(error);
            }
        });
    </script>
</head>
<body>
<!-- 错误弹窗 -->
<div id="errorModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h4 class="modal-title">错误提示</h4>
        </div>
        <div class="modal-body">
            <p id="errorMessage"></p>
        </div>
        <div class="modal-footer">
            <button class="btn-close">关闭</button>
        </div>
    </div>
</div>

<div class="container">
    <div class="form-title">编辑员工信息</div>

    <form action="${pageContext.request.contextPath}/employee/edit?sortField=${param.sortField}&sortDirection=${param.sortDirection}" method="post">
        <input type="hidden" name="id" value="${vo.id}" />
        <input type="hidden" name="pageNum" value="${pageNum}" />

        <div class="form-group">
            <label for="employeeId">员工编号</label>
            <input type="text" id="employeeId" name="employeeId" class="form-control" value="${vo.employeeId}" required />
        </div>

        <div class="form-group">
            <label for="realName">员工姓名</label>
            <input type="text" id="realName" name="realName" class="form-control" value="${vo.realName}" required />
        </div>

        <div class="form-group">
            <label for="position">职位</label>
            <input type="text" id="position" name="position" class="form-control" value="${vo.position}" />
        </div>

        <div class="form-group">
            <label for="employeeType">员工类型</label>
            <select id="employeeType" name="employeeType" class="form-control">
                <option value="正式员工" ${vo.employeeType == '正式员工' ? 'selected' : ''}>正式员工</option>
                <option value="临时工" ${vo.employeeType == '临时工' ? 'selected' : ''}>临时工</option>
                <option value="实习生" ${vo.employeeType == '实习生' ? 'selected' : ''}>实习生</option>
                <option value="外包员工" ${vo.employeeType == '外包员工' ? 'selected' : ''}>外包员工</option>
            </select>
        </div>

        <div class="form-group">
            <label for="idCard">身份证号码</label>
            <input type="text" id="idCard" name="idCard" class="form-control" value="${vo.idCard}" required />
        </div>

        <div class="form-group">
            <label for="gender">性别</label>
            <select id="gender" name="gender" class="form-control">
                <option value="男" ${vo.gender == '男' ? 'selected' : ''}>男</option>
                <option value="女" ${vo.gender == '女' ? 'selected' : ''}>女</option>
            </select>
        </div>

        <div class="form-group">
            <label for="birthDate">出生年月</label>
            <input type="date" id="birthDate" name="birthDate" class="form-control"
                   value="<fmt:formatDate value="${vo.birthDate}" pattern="yyyy-MM-dd" />" />
        </div>

        <div class="form-group">
            <label for="phone">联系电话</label>
            <input type="text" id="phone" name="phone" class="form-control" value="${vo.phone}" required />
        </div>

        <div class="button-group">
            <button type="submit" class="button button-submit">保存</button>
            <a href="${pageContext.request.contextPath}/employee/list?pageNum=${pageNum}" class="button button-cancel">取消</a>
        </div>
    </form>
</div>
</body>
</html>