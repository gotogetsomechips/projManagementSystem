<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
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
	background-image: url(images/left.gif);
}
-->
</style>
<link href="css/css.css" rel="stylesheet" type="text/css" />
</head>
<SCRIPT language=JavaScript>
function tupian(idt){
    var nametu="xiaotu"+idt;
    var tp = document.getElementById(nametu);
    tp.src="images/ico05.gif";//图片ico04为白色的正方形

	for(var i=1;i<30;i++)
	{

	  var nametu2="xiaotu"+i;
	  if(i!=idt*1)
	  {
	    var tp2=document.getElementById('xiaotu'+i);
		if(tp2!=undefined)
	    {tp2.src="images/ico06.gif";}//图片ico06为蓝色的正方形
	  }
	}
}

function list(idstr){
	var name1="subtree"+idstr;
	var name2="img"+idstr;
	var objectobj=document.all(name1);
	var imgobj=document.all(name2);


	//alert(imgobj);

	if(objectobj.style.display=="none"){
		for(i=1;i<10;i++){
			var name3="img"+i;
			var name="subtree"+i;
			var o=document.all(name);
			if(o!=undefined){
				o.style.display="none";
				var image=document.all(name3);
				//alert(image);
				image.src="images/ico04.gif";
			}
		}
		objectobj.style.display="";
		imgobj.src="images/ico03.gif";
	}
	else{
		objectobj.style.display="none";
		imgobj.src="images/ico04.gif";
	}
}

</SCRIPT>

<body>
<table width="198" border="0" cellpadding="0" cellspacing="0" class="left-table01">
  <tr>
    <TD>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
		  <tr>
			<td width="207" height="55" background="images/nav01.gif">
				<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
				  <tr>
					<td width="25%" rowspan="2"><img src="images/ico02.gif" width="35" height="35" /></td>
					<td width="75%" height="22" class="left-font01">欢迎您，<span class="left-font02">${currentUser.realName}</span></td>
				  </tr>
				  <tr>
                      <td height="22" class="left-font01">
                          [&nbsp;<a href="<c:url value='/logout'/>" target="_top" class="left-font01">退出</a>&nbsp;]
                      </td>
				  </tr>
				</table>
			</td>
		  </tr>
		</table>



		<!--  任务系统开始    -->
		<TABLE width="100%" border="0" cellpadding="0" cellspacing="0" class="left-table03">
          <tr>
            <td height="29">
				<table width="85%" border="0" align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td width="8%"><img name="img8" id="img8" src="images/ico04.gif" width="8" height="11" /></td>
						<td width="92%">
								<a href="javascript:" target="mainFrame" class="left-font03" onClick="list('8');" >任务管理</a></td>
					</tr>
				</table>
			</td>
          </tr>
        </TABLE>
		<table id="subtree8" style="DISPLAY: none" width="80%" border="0" align="center" cellpadding="0"
				cellspacing="0" class="left-table02">
				<tr>
				  <td width="9%" height="21" ><img id="xiaotu21" src="images/ico06.gif" width="8" height="12" /></td>
				  <td width="91%"><a href="task/list" target="mainFrame" class="left-font03" onClick="tupian('21');">任务信息查看</a></td>
				</tr>
      </table>
		<!--  任务系统结束    -->



	  <!--  用户系统开始    -->
	  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="left-table03">
          <tr>
            <td height="29"><table width="85%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="8%" height="12"><img name="img2" id="img2" src="images/ico04.gif" width="8" height="11" /></td>
                  <td width="92%"><a href="javascript:" target="mainFrame" class="left-font03" onClick="list('2');" >用户系统</a></td>
                </tr>
            </table></td>
          </tr>
      </table>

	  <table id="subtree2" style="DISPLAY: none" width="80%" border="0" align="center" cellpadding="0" cellspacing="0" class="left-table02">

		<tr>
          <td width="9%" height="20" ><img id="xiaotu7" src="images/ico06.gif" width="8" height="12" /></td>
          <td width="91%"><a href="user/list" target="mainFrame" class="left-font03" onClick="tupian('7');">用户信息查看</a></td>
        </tr>
      </table>

	  <!--  用户系统结束    -->
    <!--  消息系统开始    -->
    <TABLE width="100%" border="0" cellpadding="0" cellspacing="0" class="left-table03">
    <tr>
    <td height="29">
    <table width="85%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
    <td width="8%"><img name="img7" id="img7" src="images/ico04.gif" width="8" height="11" /></td>
    <td width="92%">
    <a href="javascript:" target="mainFrame" class="left-font03" onClick="list('7');" >消息管理</a></td>
    </tr>
    </table>
    </td>
    </tr>
    </TABLE>
    <table id="subtree7" style="DISPLAY: none" width="80%" border="0" align="center" cellpadding="0"
    cellspacing="0" class="left-table02">
    <tr>
    <td width="9%" height="20" ><img id="xiaotu24" src="../images/ico06.gif" width="8" height="12" /></td>
    <td width="91%">
    <a href="message/list" target="mainFrame" class="left-font03" onClick="tupian('24');">消息信息列表
    </a></td>
    </tr>
    </table>
    <!--  消息系统结束    -->
	   <!--  考勤系统开始    -->
	   <table width="100%" border="0" cellpadding="0" cellspacing="0" class="left-table03">
          <tr>
            <td height="29"><table width="85%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="8%" height="12"><img name="img4" id="img4" src="images/ico04.gif" width="8" height="11" /></td>
                  <td width="92%"><a href="javascript:" target="mainFrame" class="left-font03" onClick="list('4');" >考勤系统</a></td>
                </tr>
            </table></td>
          </tr>
      </table>

	  <table id="subtree4" style="DISPLAY: none" width="80%" border="0" align="center" cellpadding="0" cellspacing="0" class="left-table02">
	  	<tr>
          <td width="9%" height="20" ><img id="xiaotu12" src="images/ico06.gif" width="8" height="12" /></td>
          <td width="91%"><a href="salary/list" target="mainFrame" class="left-font03" onClick="tupian('12');">员工考勤信息查看</a></td>
        </tr>
      </table>

      <!--  考勤系统结束    -->


	  </TD>
  </tr>
  
</table>
</body>
</html>
