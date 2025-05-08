<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <title>编辑用户</title>
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

      // 用户名异步校验
      $("#username").on("blur", function() {
        var username = $(this).val();
        var originalUsername = "${vo.username}";
        var $message = $(this).next(".validation-message");

        if (!username) {
          $message.text("用户名不能为空").removeClass("success").addClass("error");
          return;
        }

        // 如果用户名有修改才检查是否已存在
        if (username !== originalUsername) {
          $.post("${pageContext.request.contextPath}/user/checkUsername", {username: username}, function(data) {
            if (data === "false") {
              $message.text("用户名已存在").removeClass("success").addClass("error");
            } else {
              $message.text("用户名可用").removeClass("error").addClass("success");
            }
          });
        } else {
          $message.text("").removeClass("error").removeClass("success");
        }
      });

      // 密码校验
      $("#password").on("blur", function() {
        var password = $(this).val();
        var $message = $(this).next(".validation-message");

        if (!password) {
          $message.text("密码不能为空").removeClass("success").addClass("error");
        } else if (password.length < 6) {
          $message.text("密码长度至少6位").removeClass("success").addClass("error");
        } else {
          $message.text("密码格式正确").removeClass("error").addClass("success");
        }
      });

      // 手机号校验
      $("#phone").on("blur", function() {
        var phone = $(this).val();
        var $message = $(this).next(".validation-message");

        if (phone && !/^1[3-9]\d{9}$/.test(phone)) {
          $message.text("手机号格式不正确，请输入11位有效手机号").removeClass("success").addClass("error");
        } else {
          $message.text("手机号格式正确").removeClass("error").addClass("success");
        }
      });

      // 邮箱校验
      $("#email").on("blur", function() {
        var email = $(this).val();
        var $message = $(this).next(".validation-message");

        if (email && !/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(email)) {
          $message.text("邮箱格式不正确，请输入有效的邮箱地址").removeClass("success").addClass("error");
        } else if (email) {
          $message.text("邮箱格式正确").removeClass("error").addClass("success");
        } else {
          $message.text("").removeClass("error").removeClass("success");
        }
      });

      // 表单提交验证
      $("form").submit(function(e) {
        var isValid = true;
        var errorMsg = "";

        // 检查必填字段
        if ($("#username").val() === "") {
          errorMsg += "用户名不能为空\n";
          isValid = false;
          $("#username").next(".validation-message").text("用户名不能为空").removeClass("success").addClass("error");
        }

        if ($("#password").val() === "") {
          errorMsg += "密码不能为空\n";
          isValid = false;
          $("#password").next(".validation-message").text("密码不能为空").removeClass("success").addClass("error");
        }

        // 手机号验证
        var phone = $("#phone").val();
        if (phone && !/^1[3-9]\d{9}$/.test(phone)) {
          errorMsg += "手机号格式不正确，请输入11位有效手机号\n";
          isValid = false;
          $("#phone").next(".validation-message").text("手机号格式不正确，请输入11位有效手机号").removeClass("success").addClass("error");
        }

        // 邮箱验证
        var email = $("#email").val();
        if (email && !/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(email)) {
          errorMsg += "邮箱格式不正确，请输入有效的邮箱地址\n";
          isValid = false;
          $("#email").next(".validation-message").text("邮箱格式不正确，请输入有效的邮箱地址").removeClass("success").addClass("error");
        }

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
  <div class="form-title">编辑用户</div>

  <form action="${pageContext.request.contextPath}/user/edit?sortField=${param.sortField}&sortDirection=${param.sortDirection}" method="post">
    <input type="hidden" name="id" value="${vo.id}" />
    <input type="hidden" name="pageNum" value="${pageNum}" />

    <div class="form-group">
      <label for="username">用户名</label>
      <input type="text" id="username" name="username" class="form-control" value="${vo.username}" required />
      <div class="validation-message"></div>
    </div>

    <div class="form-group">
      <label for="password">密码</label>
      <input type="password" id="password" name="password" class="form-control" value="${vo.password}" required />
      <div class="validation-message"></div>
    </div>

    <div class="form-group">
      <label for="realName">真实姓名</label>
      <input type="text" id="realName" name="realName" class="form-control" value="${vo.realName}" />
      <div class="validation-message"></div>
    </div>

    <div class="form-group">
      <label for="phone">联系电话</label>
      <input type="text" id="phone" name="phone" class="form-control" value="${vo.phone}" />
      <div class="validation-message"></div>
    </div>

    <div class="form-group">
      <label for="email">电子邮箱</label>
      <input type="email" id="email" name="email" class="form-control" value="${vo.email}" />
      <div class="validation-message"></div>
    </div>

    <div class="form-group">
      <label for="status">状态</label>
      <select id="status" name="status" class="form-control">
        <option value="0" ${vo.status == 0 ? 'selected' : ''}>正常</option>
        <option value="1" ${vo.status == 1 ? 'selected' : ''}>禁用</option>
      </select>
      <div class="validation-message"></div>
    </div>

    <div class="button-group">
      <button type="submit" class="button button-submit">保存</button>
      <a href="${pageContext.request.contextPath}/user/list?pageNum=${pageNum}" class="button button-cancel">取消</a>
    </div>
  </form>
</div>
</body>
</html>