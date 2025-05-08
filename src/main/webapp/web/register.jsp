<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>项目管理系统 by www.865171.cn</title>
  <style type="text/css">
    <!--
    body,td,th {
      font-size: 12px;
      color: #3791cf;
    }
    body {
      margin-left: 0px;
      margin-top: 0px;
      margin-right: 0px;
      margin-bottom: 0px;
    }
    .error {
      color: red;
      font-size: 12px;
    }
    .login-link {
      color: blue;
      text-decoration: underline;
      cursor: pointer;
    }
    -->
  </style>

  <script type="text/javascript">
    function validateForm() {
      var username = document.getElementById("yhm").value;
      var realName = document.getElementById("yhxm").value;
      var password = document.getElementById("mm").value;
      var confirmPassword = document.getElementById("checkmm").value;

      if(username == "") {
        alert("用户名不能为空");
        return false;
      }

      if(realName == "") {
        alert("用户姓名不能为空");
        return false;
      }

      if(password == "") {
        alert("密码不能为空");
        return false;
      }

      // 添加密码长度验证
      if(password.length < 6) {
        alert("密码长度不能少于6位");
        return false;
      }

      if(password != confirmPassword) {
        alert("两次输入的密码不一致");
        return false;
      }

      return true;
    }

    function checkUsername() {
      var username = document.getElementById("yhm").value;
      if(username == "") {
        return;
      }

      // 使用AJAX检查用户名是否存在
      var xhr = new XMLHttpRequest();
      xhr.open("GET", "<c:url value='/checkUsername?username='/>" + username, true);
      xhr.onreadystatechange = function() {
        if(xhr.readyState == 4 && xhr.status == 200) {
          var response = xhr.responseText;
          if(response == "exist") {
            alert("用户名已存在，请选择其他用户名");
            document.getElementById("yhm").value = "";
          }
        }
      };
      xhr.send();
    }

    // 检查是否从登录页面跳转回来，并显示注册成功信息
    window.onload = function() {
      // 获取URL参数中是否有registerSuccess
      const urlParams = new URLSearchParams(window.location.search);
      const registerSuccess = urlParams.get('registerSuccess');
      if(registerSuccess === 'true') {
        alert("注册成功，请登录！");
      }
    }
  </script>

</head>

<body>
<form id="form1" name="form1" action="<c:url value='/register'/>" method="post" onsubmit="return validateForm()">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="45" valign="top"><img src="images/register_03.gif" width="45" height="386" /></td>
      <td width="623" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="images/register_04.gif" width="623" height="135" /></td>
        </tr>
      </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td background="images/register_28.gif">
              <table width="100%" height="158" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td align="center"><table width="272" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td colspan="2" class="error" align="center">
                        <c:if test="${not empty error}">${error}</c:if>
                      </td>
                    </tr>
                    <tr>
                      <td width="123" height="25" align="left"><img src="images/register_10.gif" width="79" height="17" /></td>
                      <td width="268" align="left">
                        <input name="yhm" id="yhm" type="text" onblur="checkUsername()" value="${param.yhm}" />
                      </td>
                    </tr>
                    <tr>
                      <td height="25" align="left"><img src="images/register_13.gif" width="79" height="18" /></td>
                      <td align="left"><input name="yhxm" id="yhxm" type="text" value="${param.yhxm}" /></td>
                    </tr>
                    <tr>
                      <td height="25" align="left"><img src="images/register_15.gif" width="79" height="17" /></td>
                      <td align="left"><input name="mm" id="mm" size="25" type="password" /></td>
                    </tr>
                    <tr>
                      <td height="25" align="left"><img src="images/register_17.gif" width="76" height="19" /></td>
                      <td align="left"><input name="checkmm" id="checkmm" size="25" type="password" /></td>
                    </tr>
                    <tr>
                      <td colspan="2" align="left" style="color: #666; font-size: 11px; padding-left: 123px;">
                        密码长度不能少于6位
                      </td>
                    </tr>
                  </table></td>
                  <td width="232" align="right" valign="top"><img src="images/register_08.gif" width="232" height="172" /></td>
                </tr>
              </table>
              <table width="623" height="41" border="0" cellpadding="0" cellspacing="0">
                <tr align="center">
                  <td width="201">&nbsp;</td>
                  <td width="107"><input type="submit" class="right-button01" value="注册" /></td>
                  <td width="62"><input type="button" class="right-button02" value="登录" onclick="location.href='<c:url value="/login"/>'"></td>
                  <td width="201">&nbsp;</td>
                </tr>
              </table>
              <table width="623" height="20" border="0" cellpadding="0" cellspacing="0">
                <tr align="center">
                  <td colspan="4">
                    已有账号？<span class="login-link" onclick="location.href='<c:url value="/login"/>'">立即登录</span>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="9"><img src="images/register_31.gif" width="9" height="44" /></td>
            <td background="images/register_32.gif">&nbsp;</td>
            <td width="11"><img src="images/register_34.gif" width="11" height="44" /></td>
          </tr>
        </table>
      </td>
      <td class="bg">&nbsp;</td>
    </tr>
  </table>
</form>
</body>
</html>