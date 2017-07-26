<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Global ID 管理系统</title>
    <meta name="Login-Page" content="true"/>
    <link rel="icon" href="./images/fav.ico">
    <link type="text/css" rel="stylesheet" href="./css/login.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/jslib/jquery-2.1.1.min.js" charset="utf-8"></script>
</head>
<body class="login_bj">
<div class="zhuce_body">
    <div class="logo"><a href="#"><img src="${pageContext.request.contextPath}/images/logo.png" width="114" height="54" border="0"></a></div>
    <div class="zhuce_kong login_kuang" id="loginPage">
        <div class="zc">
            <div class="bj_right">
                <img src="${pageContext.request.contextPath}/images/bj_left.gif" width="173" height="276" border="0">
            </div>
            <div class="bj_bai">
                <h3>登录</h3>
                <form action="${pageContext.request.contextPath}/login" method="post">
                    <input name="username" id="username" type="text" class="kuang_txt" placeholder="请输入用户名">
                    <input name="password" id="userpwd" type="password" class="kuang_txt" placeholder="请输入密码">
                    <input name="登录" type="submit" id="button" class="btn_zhuce" value="登录">
                </form>
            </div>
        </div>
    </div>
</div>
</body>
<script>
    $(function(){
        onkeydown=function(){
            var e = event || window.event || arguments.callee.caller.arguments[0];
            if(13 == e.keyCode){
                $('#button').submit();
            }
        }
    });
</script>
</html>