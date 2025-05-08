<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
  <title>项目管理系统 by www.865171.cn</title>
  <style type="text/css">
    <!--
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
    -->
  </style>
  <link href="css/css.css" rel="stylesheet" type="text/css" />
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="147" background="images/top02.gif"><img src="images/top03.gif" width="776" height="147" /></td>
  </tr>
</table>
<table width="562" border="0" align="center" cellpadding="0" cellspacing="0" class="right-table03">
  <tr>
    <td width="221"><table width="95%" border="0" cellpadding="0" cellspacing="0" class="login-text01">

      <tr>
        <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="login-text01">
          <tr>
            <td align="center"><img src="images/ico13.gif" width="107" height="97" /></td>
          </tr>
          <tr>
            <td height="40" align="center">&nbsp;</td>
          </tr>

        </table></td>
        <td><img src="images/line01.gif" width="5" height="292" /></td>
      </tr>
    </table></td>
    <td>
      <form action="<c:url value='/login'/>" method="post">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2" class="error">
              <c:if test="${not empty error}">${error}</c:if>
            </td>
          </tr>
          <tr>
            <td width="31%" height="35" class="login-text02">用户名称：<br /></td>
            <td width="69%"><input name="username" type="text" size="30" value="${username}" /></td>
          </tr>
          <tr>
            <td height="35" class="login-text02">密　码：<br /></td>
            <td><input name="password" type="password" size="33" /></td>
          </tr>
          <c:if test="${showCaptcha}">
            <tr>
              <td height="35" class="login-text02">验证图片：<br /></td>
              <td>
                <img src="<c:url value='/captcha'/>" width="109" height="40" id="captchaImage" />
                <a href="javascript:refreshCaptcha()" class="login-text03">看不清楚，换张图片</a>
              </td>
            </tr>
            <tr>
              <td height="35" class="login-text02">请输入验证码：</td>
              <td><input name="captcha" type="text" size="30" /></td>
            </tr>
          </c:if>
          <tr>
            <td height="35">&nbsp;</td>
            <td>
              <input type="submit" class="right-button01" value="确认登陆" />
              <input type="reset" class="right-button02" value="重 置" />
            </td>
          </tr>
        </table>
      </form>
    </td>
  </tr>
</table>

<script type="text/javascript">
  function refreshCaptcha() {
    var captchaImage = document.getElementById('captchaImage');
    captchaImage.src = '<c:url value="/captcha"/>?t=' + new Date().getTime();
  }
</script>
</body>
</html>