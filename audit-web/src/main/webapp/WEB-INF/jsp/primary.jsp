<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<html>
<link rel="stylesheet" href="${pageContext.request.contextPath }/jslib/bootstrap-3.3.6/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/jslib/bootstrap-3.3.6/dist/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/css/hyperlink.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/css/menu.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/pop.css">
<script type="text/javascript" src="${pageContext.request.contextPath }/jslib/jquery-2.1.1.min.js"
        charset="utf-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/jslib/bootstrap-3.3.6/dist/js/bootstrap.min.js"
        charset="utf-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/pop.js"></script>
<head>
    <title>Global ID 管理系统</title>
    <link rel="icon" href="./images/fav.ico">
    <style>
        #showDataDiv{
            overflow:auto;
            height: 81%;
        }
    </style>
</head>
<style>
    .pingmu {
        width: 100%;
        height: auto;
        overflow: auto;
    }

    .table td, .table > tbody > tr > td, .table > tbody > tr > th, .table > tfoot > tr > td, .table > tfoot > tr > th, .table > thead > tr > td, .table > thead > tr > th {
        padding: 8px !important;
    }
</style>

<body style="overflow:hidden">
<div class="navbar-duomi navbar-static-top" role="navigation" style="width:100%;height: 12%;background: white;">
    <div class="">
        <div class="pfhead">
            <img src="${pageContext.request.contextPath}/images/u319.png" class="yglogo"/>
            <img src="${pageContext.request.contextPath}/images/u323.png" class="vline">
            <span onclick="signOutModel(event)"><a href="${pageContext.request.contextPath}/logout"
                                                   class="Sign_out_css">退出</a></span>
            <span style="width:18px;margin-left: 48px;">｜</span>
            <span>欢迎您，<shiro:principal/></span>
        </div>
    </div>
</div>
<div style="height:88%">
    <div class="col-md-2" style="background-color: #36648B;height:100%">

        <ul id="main-nav" class="nav nav-tabs nav-stacked" style="border-bottom: 0px;padding-top: 20px;">

            <li class="nav-item" onclick="redirectSys('homePage')">
                <a href="#" class="nav-header collapsed" data-toggle="collapse">
                    <i class="glyphicon glyphicon-th-large"></i>
                    首页
                </a>
            </li>

            <shiro:hasRole name="admin">
                <li class="nav-item" onclick="redirectSys('user')">
                    <a id="user" class="nav-header collapsed" data-toggle="collapse">
                        <i class="glyphicon glyphicon-th-large"></i>
                        用户管理
                    </a>
                </li>
                <li class="nav-item" onclick="redirectSys('orgCode')">
                    <a class="nav-header collapsed" data-toggle="collapse">
                        <i class="glyphicon glyphicon-th-large"></i>
                        组织代码管理
                    </a>
                </li>
            </shiro:hasRole>

            <li class="nav-item" onclick="redirectSys('idRecord')">
                <a id="idRecord" class="nav-header collapsed" data-toggle="collapse">
                    <i class="glyphicon glyphicon-th-large"></i>
                    记录列表
                </a>
            </li>
        </ul>
    </div>

    <div class="col-md-10" id="date_panel" style="height:100%;">

    </div>
</div>
<!-- 退出操作模态框（Modal） -->
<div class="modal fade" id="signOutModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog delDialog" style="width:220px">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="delModalLabel">
                    退出
                </h4>
            </div>
            <div class="modal-body">
                确定退出吗？
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消
                </button>
                <button type="button" onclick="logout()" class="btn btn-danger">
                    退出
                </button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>
<%--popup控件--%>
<div id="pop" class="panel panel-default pop" hidden style=" margin-bottom: 150px;margin-right:500px">
    <div id="popHead" class="popHead">
        <a class="popClose" title="关闭" onclick="closePop()">关闭</a>
        <span></span>
    </div>
    <div id="showTime"><span class="secondFont"></span>秒之后自动关闭</div>
    <div class="errorImg"><img src="${pageContext.request.contextPath}/images/error.gif"/></div>
    <div id="popTxt" class="popContext"></div>
</div>

</body>
<script type="text/javascript">
    var listData = "";
    $(document).ready(function () {
    });

    function redirectSys(type) {
        $("#date_panel").val("");
        $.ajax({
            url: "${pageContext.request.contextPath }/" + type + "/redirectSys",
            success: function (htmlCode) {
                if(htmlCode.indexOf('meta name="Login-Page"') != -1) {
                    window.location.href = htmlCode.redirect;
                } else {
                    $("#date_panel").html("").html(htmlCode);
                }
            },
        });
    }
</script>
</html>