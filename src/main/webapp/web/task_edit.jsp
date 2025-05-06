<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>编辑任务</title>
  <style type="text/css">
    body {
      font-family: "宋体", Arial, sans-serif;
      font-size: 14px;
      line-height: 1.5;
      color: #333;
      background-color: #f5f5f5;
      margin: 0;
      padding: 20px;
    }
    .container {
      max-width: 800px;
      margin: 0 auto;
      background: #fff;
      padding: 20px;
      border-radius: 5px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    h2 {
      margin-top: 0;
      color: #333;
      border-bottom: 1px solid #eee;
      padding-bottom: 10px;
    }
    .form-group {
      margin-bottom: 15px;
    }
    label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
    }
    input[type="text"], textarea, select {
      width: 100%;
      padding: 8px;
      border: 1px solid #ddd;
      border-radius: 4px;
      box-sizing: border-box;
    }
    textarea {
      height: 100px;
    }
    .required:after {
      content: " *";
      color: red;
    }
    .error {
      color: red;
      font-size: 12px;
      margin-top: 5px;
    }
    .btn {
      background-color: #5cb85c;
      color: white;
      padding: 10px 15px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 14px;
    }
    .btn:hover {
      background-color: #4cae4c;
    }
    .btn-back {
      background-color: #337ab7;
      margin-left: 10px;
    }
    .btn-back:hover {
      background-color: #286090;
    }
  </style>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
    function validateForm() {
      var isValid = true;

      // 验证必填项
      if ($("#title").val().trim() === "") {
        $("#titleError").text("任务标题不能为空");
        isValid = false;
      } else {
        $("#titleError").text("");
      }

      if ($("#creatorName").val().trim() === "") {
        $("#creatorNameError").text("创建者不能为空");
        isValid = false;
      } else {
        $("#creatorNameError").text("");
      }

      if ($("#executorName").val().trim() === "") {
        $("#executorNameError").text("执行人不能为空");
        isValid = false;
      } else {
        $("#executorNameError").text("");
      }

      return isValid;
    }
  </script>
</head>
<body>
<div class="container">
  <h2>编辑任务</h2>

  <c:if test="${not empty error}">
    <div class="error">${error}</div>
  </c:if>

  <form action="${pageContext.request.contextPath}/task/edit" method="post" onsubmit="return validateForm()">
    <input type="hidden" name="id" value="${task.id}">

    <div class="form-group">
      <label for="title" class="required">任务标题</label>
      <input type="text" id="title" name="title" value="${task.title}">
      <div id="titleError" class="error"></div>
    </div>

    <div class="form-group">
      <label for="content">任务内容</label>
      <textarea id="content" name="content">${task.content}</textarea>
    </div>

    <div class="form-group">
      <label for="creatorName" class="required">创建者</label>
      <input type="text" id="creatorName" name="creatorName" value="${task.creatorName}">
      <div id="creatorNameError" class="error"></div>
    </div>

    <div class="form-group">
      <label for="executorName" class="required">执行人</label>
      <input type="text" id="executorName" name="executorName" value="${task.executorName}">
      <div id="executorNameError" class="error"></div>
    </div>

    <div class="form-group">
      <label for="priority">优先级</label>
      <select id="priority" name="priority">
        <option value="1" ${task.priority == 1 ? 'selected' : ''}>紧急</option>
        <option value="2" ${task.priority == 2 ? 'selected' : ''}>高</option>
        <option value="3" ${task.priority == 3 ? 'selected' : ''}>普通</option>
        <option value="4" ${task.priority == 4 ? 'selected' : ''}>低</option>
      </select>
    </div>

    <div class="form-group">
      <label for="status">状态</label>
      <select id="status" name="status">
        <option value="1" ${task.status == 1 ? 'selected' : ''}>未开始</option>
        <option value="2" ${task.status == 2 ? 'selected' : ''}>进行中</option>
        <option value="3" ${task.status == 3 ? 'selected' : ''}>已完成</option>
        <option value="4" ${task.status == 4 ? 'selected' : ''}>已取消</option>
      </select>
    </div>

    <div class="form-group">
      <button type="submit" class="btn">保存</button>
      <a href="${pageContext.request.contextPath}/task/list" class="btn btn-back">返回</a>
    </div>
  </form>
</div>
</body>
</html>