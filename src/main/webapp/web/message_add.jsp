<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <title>添加消息</title>
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
  <script type="text/javascript">
    $(document).ready(function() {
      $("#errorModal").hide();

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

      // 标题校验
      $("#title").on("blur", function() {
        var title = $(this).val();
        var $message = $(this).next(".validation-message");

        if (!title) {
          $message.text("标题不能为空").removeClass("success").addClass("error");
          return;
        }

        // 检查标题是否已存在
        $.post("${pageContext.request.contextPath}/message/checkTitle", {title: title}, function(data) {
          if (data.exists) {
            $message.text("标题已存在").removeClass("success").addClass("error");
          } else {
            $message.text("标题可用").removeClass("error").addClass("success");
          }
        }).fail(function() {
          $message.text("验证失败，请重试").removeClass("success").addClass("error");
        });
      });

      // 发送人校验
      $("#sender").on("blur", function() {
        var sender = $(this).val();
        var $message = $(this).next(".validation-message");

        if (!sender) {
          $message.text("发送人不能为空").removeClass("success").addClass("error");
        } else {
          $message.text("").removeClass("error").removeClass("success");
        }
      });

      // 接收人校验
      $("#receiver").on("blur", function() {
        var receiver = $(this).val();
        var $message = $(this).next(".validation-message");

        if (!receiver) {
          $message.text("接收人不能为空").removeClass("success").addClass("error");
        } else {
          $message.text("").removeClass("error").removeClass("success");
        }
      });

      // 内容校验
      $("#content").on("blur", function() {
        var content = $(this).val();
        var $message = $(this).next(".validation-message");

        if (!content) {
          $message.text("消息内容不能为空").removeClass("success").addClass("error");
        } else {
          $message.text("").removeClass("error").removeClass("success");
        }
      });

      // 表单提交验证
      $("form").submit(function(e) {
        var isValid = true;
        var errorMsg = "";

        // 检查所有必填字段
        $("[required]").each(function() {
          if ($(this).val() === "") {
            var fieldName = $(this).prev("label").text().replace("*", "").trim();
            errorMsg += fieldName + "不能为空\n";
            isValid = false;
            $(this).next(".validation-message").text(fieldName + "不能为空").removeClass("success").addClass("error");
          }
        });

        // 检查标题是否重复
        var title = $("#title").val();
        var titleValidation = $("#title").next(".validation-message").text();
        if (title && titleValidation === "标题已存在") {
          errorMsg += "标题已存在，请修改\n";
          isValid = false;
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
  <div class="form-title">添加新消息</div>

  <form action="${pageContext.request.contextPath}/message/add?sortField=${param.sortField}&sortDirection=${param.sortDirection}" method="post">
    <div class="form-group">
      <label for="title">标题 <span style="color:red;">*</span></label>
      <input type="text" id="title" name="title" class="form-control" required />
      <div class="validation-message"></div>
    </div>

    <div class="form-group">
      <label for="sender">发送人 <span style="color:red;">*</span></label>
      <input type="text" id="sender" name="sender" class="form-control" required />
      <div class="validation-message"></div>
    </div>

    <div class="form-group">
      <label for="receiver">接收人 <span style="color:red;">*</span></label>
      <input type="text" id="receiver" name="receiver" class="form-control" required />
      <div class="validation-message"></div>
    </div>

    <div class="form-group">
      <label for="content">消息内容 <span style="color:red;">*</span></label>
      <textarea id="content" name="content" class="form-control" required></textarea>
      <div class="validation-message"></div>
    </div>

    <div class="button-group">
      <button type="submit" class="button button-submit">添加</button>
      <a href="${pageContext.request.contextPath}/message/list" class="button button-cancel">取消</a>
    </div>
  </form>
</div>
</body>
</html>