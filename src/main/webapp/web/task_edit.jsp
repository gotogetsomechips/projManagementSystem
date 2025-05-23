<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <title>编辑任务</title>
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
      // 任务标题异步校验
      $("#title").on("blur", function() {
        var title = $(this).val();
        var originalTitle = "${vo.title}";
        var $message = $(this).next(".validation-message");

        if (!title) {
          $message.text("任务标题不能为空").removeClass("success").addClass("error");
          return;
        }

        // 如果任务标题有修改才检查是否已存在
        if (title !== originalTitle) {
          $.post("${pageContext.request.contextPath}/task/checkTitle", {title: title}, function(data) {
            if (data === "false") {
              $message.text("任务标题已存在").removeClass("success").addClass("error");
            } else {
              $message.text("任务标题可用").removeClass("error").addClass("success");
            }
          });
        } else {
          $message.text("").removeClass("error").removeClass("success");
        }
      });

      // 任务内容校验
      $("#content").on("blur", function() {
        var content = $(this).val();
        var $message = $(this).next(".validation-message");

        if (!content) {
          $message.text("任务内容不能为空").removeClass("success").addClass("error");
        } else {
          $message.text("").removeClass("error").removeClass("success");
        }
      });

// 为所有必填字段添加校验逻辑
      $("#creator, #executor").on("blur", function() {
        var value = $(this).val();
        var $message = $(this).next(".validation-message");
        if (!value) {
          $message.text("该字段不能为空").removeClass("success").addClass("error");
        } else {
          $message.text("").removeClass("error").removeClass("success");
        }
      });

      $("#priority, #status").on("change", function() {
        var value = $(this).val();
        var $message = $(this).next(".validation-message");
        if (!value) {
          $message.text("请选择选项").removeClass("success").addClass("error");
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

        if (!isValid) {
          showErrorModal(errorMsg);
          e.preventDefault();
          return false;
        }

        return true;
      });
      })
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
  <div class="form-title">编辑任务</div>

  <form action="${pageContext.request.contextPath}/task/edit?sortField=${param.sortField}&sortDirection=${param.sortDirection}" method="post">
    <input type="hidden" name="id" value="${vo.id}" />
    <input type="hidden" name="pageNum" value="${pageNum}" />

    <div class="form-group">
      <label for="title">任务标题 <span style="color:red;">*</span></label>
      <input type="text" id="title" name="title" class="form-control" value="${vo.title}" required />
      <div class="validation-message"></div>
    </div>

    <div class="form-group">
      <label for="content">任务内容 <span style="color:red;">*</span></label>
      <textarea id="content" name="content" class="form-control" required>${vo.content}</textarea>
      <div class="validation-message"></div>
    </div>

    <div class="form-group">
      <label for="creator">创建者 <span style="color:red;">*</span></label>
      <input type="text" id="creator" name="creator" class="form-control" value="${vo.creator}" required />
      <div class="validation-message"></div>
    </div>

    <div class="form-group">
      <label for="executor">执行人 <span style="color:red;">*</span></label>
      <input type="text" id="executor" name="executor" class="form-control" value="${vo.executor}" required />
      <div class="validation-message"></div>
    </div>

    <div class="form-group">
      <label for="priority">优先级 <span style="color:red;">*</span></label>
      <select id="priority" name="priority" class="form-control" required>
        <option value="">--请选择--</option>
        <option value="高" ${vo.priority == '高' ? 'selected' : ''}>高</option>
        <option value="中" ${vo.priority == '中' ? 'selected' : ''}>中</option>
        <option value="低" ${vo.priority == '低' ? 'selected' : ''}>低</option>
      </select>
      <div class="validation-message"></div>
    </div>

    <div class="form-group">
      <label for="status">状态 <span style="color:red;">*</span></label>
      <select id="status" name="status" class="form-control" required>
        <option value="">--请选择--</option>
        <option value="未开始" ${vo.status == '未开始' ? 'selected' : ''}>未开始</option>
        <option value="进行中" ${vo.status == '进行中' ? 'selected' : ''}>进行中</option>
        <option value="已完成" ${vo.status == '已完成' ? 'selected' : ''}>已完成</option>
        <option value="已取消" ${vo.status == '已取消' ? 'selected' : ''}>已取消</option>
      </select>
      <div class="validation-message"></div>
    </div>

    <div class="button-group">
      <button type="submit" class="button button-submit">保存</button>
      <a href="${pageContext.request.contextPath}/task/list?pageNum=${pageNum}" class="button button-cancel">取消</a>
    </div>
  </form>
</div>
</body>
</html>