<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>编辑薪资</title>
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
        /* 校验提示样式 */
        .validation-message {
            font-size: 12px;
            margin-top: 5px;
            height: 18px;
        }
        .error {
            color: #f44336;
        }
        .success {
            color: #4CAF50;
        }
        .required-field::after {
            content: " *";
            color: red;
        }
        .error-input {
            border-color: #f44336 !important;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            function showErrorModal(message) {
                var modal = document.getElementById("errorModal");
                var errorMessage = document.getElementById("errorMessage");
                errorMessage.textContent = message;
                modal.style.display = "block";
            }

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

            // 员工姓名校验
            $("#employeeName").on("blur", function() {
                var employeeName = $(this).val();
                var $message = $(this).next(".validation-message");

                if (!employeeName) {
                    $(this).addClass("error-input");
                    $message.text("员工姓名不能为空").removeClass("success").addClass("error");
                } else {
                    // 检查员工是否存在
                    $.post("${pageContext.request.contextPath}/salary/checkEmployee",
                        {employeeName: employeeName},
                        function(data) {
                            if (data === "true") {
                                $(this).addClass("error-input");
                                $message.text("员工已存在").removeClass("success").addClass("error");
                            } else {
                                $(this).removeClass("error-input");
                                $message.text("员工可用").removeClass("error").addClass("success");
                            }
                        }.bind(this)
                    );
                }
            });

            // 年份校验
            $("#year").on("blur", function() {
                var year = $(this).val();
                var $message = $(this).next(".validation-message");

                if (!year) {
                    $(this).addClass("error-input");
                    $message.text("年份不能为空").removeClass("success").addClass("error");
                } else if (year < 2000 || year > 2100) {
                    $(this).addClass("error-input");
                    $message.text("年份必须在2000-2100之间").removeClass("success").addClass("error");
                } else {
                    $(this).removeClass("error-input");
                    $message.text("").removeClass("error").removeClass("success");
                }
            });

            // 月份校验
            $("#month").on("blur", function() {
                var month = $(this).val();
                var $message = $(this).next(".validation-message");

                if (!month) {
                    $(this).addClass("error-input");
                    $message.text("月份不能为空").removeClass("success").addClass("error");
                } else if (month < 1 || month > 12) {
                    $(this).addClass("error-input");
                    $message.text("月份必须在1-12之间").removeClass("success").addClass("error");
                } else {
                    $(this).removeClass("error-input");
                    $message.text("").removeClass("error").removeClass("success");
                }
            });

            // 基本工资校验
            $("#baseSalary").on("blur", function() {
                var baseSalary = $(this).val();
                var $message = $(this).next(".validation-message");

                if (!baseSalary) {
                    $(this).addClass("error-input");
                    $message.text("基本工资不能为空").removeClass("success").addClass("error");
                } else if (isNaN(baseSalary) || parseFloat(baseSalary) <= 0) {
                    $(this).addClass("error-input");
                    $message.text("基本工资必须大于0").removeClass("success").addClass("error");
                } else {
                    $(this).removeClass("error-input");
                    $message.text("").removeClass("error").removeClass("success");
                }
            });

            // 奖金校验
            $("#bonus").on("blur", function() {
                var bonus = $(this).val();
                var $message = $(this).next(".validation-message");

                if (bonus && (isNaN(bonus) || parseFloat(bonus) < 0)) {
                    $(this).addClass("error-input");
                    $message.text("奖金不能为负数").removeClass("success").addClass("error");
                } else {
                    $(this).removeClass("error-input");
                    $message.text("").removeClass("error").removeClass("success");
                }
            });

            // 扣款校验
            $("#deduction").on("blur", function() {
                var deduction = $(this).val();
                var $message = $(this).next(".validation-message");

                if (deduction && (isNaN(deduction) || parseFloat(deduction) < 0)) {
                    $(this).addClass("error-input");
                    $message.text("扣款不能为负数").removeClass("success").addClass("error");
                } else {
                    $(this).removeClass("error-input");
                    $message.text("").removeClass("error").removeClass("success");
                }
            });

            // 发放人校验
            $("#paymentBy").on("blur", function() {
                var paymentBy = $(this).val();
                var $message = $(this).next(".validation-message");

                if (!paymentBy) {
                    $(this).addClass("error-input");
                    $message.text("发放人不能为空").removeClass("success").addClass("error");
                } else {
                    $(this).removeClass("error-input");
                    $message.text("").removeClass("error").removeClass("success");
                }
            });

            // 表单提交验证
            $("form").submit(function(e) {
                var isValid = true;
                var errorMsg = "";

                // 触发所有必填字段的blur事件以确保验证
                $("[required]").trigger("blur");

                // 检查是否有错误
                $("[required]").each(function() {
                    var $message = $(this).next(".validation-message");
                    if ($message.hasClass("error") || $(this).hasClass("error-input")) {
                        isValid = false;
                        var fieldName = $(this).prev("label").text().replace("*", "").trim();
                        errorMsg += fieldName + "验证失败\n";
                    }
                });

                if (!isValid) {
                    showErrorModal(errorMsg);
                    e.preventDefault();
                    return false;
                }

                return true;
            });
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
    <div class="form-title">编辑薪资记录</div>

    <form action="${pageContext.request.contextPath}/salary/edit?sortField=${param.sortField}&sortDirection=${param.sortDirection}" method="post">
        <input type="hidden" name="id" value="${vo.id}" />
        <input type="hidden" name="pageNum" value="${pageNum}" />

        <div class="form-group">
            <label for="employeeName" class="required-field">员工姓名</label>
            <input type="text" id="employeeName" name="employeeName" class="form-control" value="${vo.employeeName}" required />
            <div class="validation-message"></div>
        </div>

        <div class="form-group">
            <label for="year" class="required-field">年份</label>
            <input type="number" id="year" name="year" class="form-control" value="${vo.year}" required />
            <div class="validation-message"></div>
        </div>

        <div class="form-group">
            <label for="month" class="required-field">月份</label>
            <input type="number" id="month" name="month" class="form-control" value="${vo.month}" required />
            <div class="validation-message"></div>
        </div>

        <div class="form-group">
            <label for="baseSalary" class="required-field">基本工资</label>
            <input type="number" id="baseSalary" name="baseSalary" class="form-control" min="0" step="0.01" value="${vo.baseSalary}" required />
            <div class="validation-message"></div>
        </div>

        <div class="form-group">
            <label for="bonus" class="required-field">奖金</label>
            <input type="number" id="bonus" name="bonus" class="form-control" min="0" step="0.01" value="${vo.bonus}" required />
            <div class="validation-message"></div>
        </div>

        <div class="form-group">
            <label for="deduction" class="required-field">扣款</label>
            <input type="number" id="deduction" name="deduction" class="form-control" min="0" step="0.01" value="${vo.deduction}" required />
            <div class="validation-message"></div>
        </div>

        <div class="form-group">
            <label for="paymentBy" class="required-field">发放人</label>
            <input type="text" id="paymentBy" name="paymentBy" class="form-control" value="${vo.paymentBy}" required />
            <div class="validation-message"></div>
        </div>

        <div class="form-group">
            <label for="remark">备注</label>
            <textarea id="remark" name="remark" class="form-control">${vo.remark}</textarea>
            <div class="validation-message"></div>
        </div>

        <div class="button-group">
            <button type="submit" class="button button-submit">保存</button>
            <a href="${pageContext.request.contextPath}/salary/list?pageNum=${pageNum}" class="button button-cancel">取消</a>
        </div>
    </form>
</div>
</body>
</html>