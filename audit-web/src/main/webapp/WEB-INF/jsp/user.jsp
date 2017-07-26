<%--
  Created by IntelliJ IDEA.
  User: admi
  Date: 2017/3/13
  Time: 11:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>user</title>
</head>
   <%@ include file="../../jslib/common/ins.jsp"%>
    <style>
        span{
            display: block;
            width: 150px;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }
    </style>
    <script type="text/javascript">
        var pagesize=10;
        var deadNum = 5;
        $(document).ready(function(){
            getData();
        });
        function getData(){
            var currentPage=$("#cpageNum").val();
            var pageSize = $("#pageSize").val();
            var param={"currentPage": Number(currentPage),"pageSize": Number(pageSize)};
            $.ajax({
                url:"${pageContext.request.contextPath }/user/getAllUser",
                dataType:"json",
                data:param,
                success:function(res){deadNum=5;
                    var thead = "<thead>"+$('thead').html()+"</thead>";
                    $('#showData').html("").html(thead);
                    var str = "<tbody>" +
                            "<tr id='thead'><td><input type='checkbox' id='allid' onclick='selectAll(\"allid\",\"selectItem\")'/></td>全选<td>序号</td><td>用户名</td><td>删除状态</td><td>锁定状态</td>" +
                            "<td>创建时间</td><td>操作</td></tr>";
                    for (var i = 0; i < res.length; i++){
                        var json = res[i];
                        json = eval(json.users)
                        for(var i=0; i<json.length; i++)
                        {
                            str = str + "<tr id='"+json[i].id+"'><td><input type='checkbox' name='selectItem' value='"+json[i].id+"'><input type='hidden' id='hidId' value='"+json[i].id+"'></td>";
                            str += "<td>"+json[i].id+"</td>";
                            str = str + "<td>" + json[i].username + "</td>";
                            str = str + "<td>" + json[i].deleted + "</td>";
                            str = str + "<td>" + json[i].locked + "</td>";
                            str = str + "<td>" + new Date(json[i].dateCreated.time).toDateString() + "</td>";
                            str = str + "<td class='czu'><a href='javascript:' onclick='update(this)'><font color='#5f9ea0'>修改密码</font></a></td></tr>";
                        }
                    }
                    str = str + "</tbody>";
                    var thead = "<thead>"+$('thead').html()+"</thead>";
                    $('#showData').html("").html(thead + str);
                    $("#cpage").html(res[0].currentPage);
                    $("#totalPage").html(res[0].totalPage);
                    $("#totalCount").html(res[0].totalSize);
                    $('#pageToolbar').html("").Paging({pagesize:pagesize,count:res[0].totalSize,toolbar:true,current:res[0].currentPage});
                    $('.ui-select-pagesize').change(function(){
                        pagesize=this.value;
                    });
                    $('.total_page').html("共<font color='darkorange'>"+res[0].totalSize+"</font>条");
                    if($('body').find($('.ui-paging-container')).size()>1){
                        $.each($('body').find($('.ui-paging-container')), function(i,n){
                            if(i !=0){
                                $(n).remove();
                            }
                        });
                    }
                    $('td').each(function(i, e){
                        if($(e).text() == 'null'){
                            $(e).text('');
                        }
                    });
                },
                error:function(e){
                    if(deadNum-- > 0){
                        getData();
                    } else {
                        alert("数据有误，请联系管理员！");
                    }
                }
            });
        }
    </script>
<body>
    <div style="margin-top: 10px" id="showDataDiv">
        <table  style='background:white;' class="table table-bordered table-hover table-condensed" id="showData">
            <thead>
            <tr>
                <th colspan='18'>
                    <div>
                        <div style="float:left;width:300px;">
                            <%--<div style="float:left;padding:2px 15px;">
                                <img id="imgList" src="/web/images/list.png">
                                <div style="margin-top: -25px;font-size:small; ">icon</div>
                            </div>--%>
                            <div id='listName'>用户列表</div>
                        </div>
                        <div style="float: right;">
                            <button class="btn btn-default" type="button" style="margin:0px 7px; background: linear-gradient(180deg, rgba(255, 255, 255, 1) 0%,rgba(255, 255, 255, 1) 0%,rgba(204, 204, 204, 1) 100%,rgba(204, 204, 204, 1) 100%);" data-toggle="modal" onclick="add()">新增</button>
                            <button id="del_btn1" class="btn btn-default" type="button" style="margin:0px 7px; background: linear-gradient(180deg, rgba(255, 255, 255, 1) 0%,rgba(255, 255, 255, 1) 0%,rgba(204, 204, 204, 1) 100%,rgba(204, 204, 204, 1) 100%);" data-toggle="modal" onclick="delAll()">删除</button>
                        </div>
                    </div>
                </th>
            </tr>
            </thead>
        </table>
    </div>

    <%--分页--%>
    <input type="hidden" id="cpageNum">
    <input type="hidden" id="pageSize">
    <span style="display:none" id="cpage"></span>
    <span style="display:none" id="totalPage"></span>
    <div>
        <div class="total_page" style="float: left;"></div>
        <div id="pageToolbar" style="float:right"></div>
    </div>

</body>
<script>
    //添加样式
    function add(){
        var targ = false;
        var $tbody = $('#thead').next();
        if($tbody.length == 0){
            targ = true;
            $tbody = $('thead').next();
        }
        $('.tone').remove();
        var str = "<tr class='tone'><td><input type='checkbox' name='selectItem' value=''></td>" +
                "<td class='uid'></td>" +
                "<td class='usr'><input type='text' maxlength='20' style='width:70px' class='userName' placeholder='用户名'/></td>" +
                "<td class='pid'><input type='password' maxlength='20' style='width:70px' class='userPassword' placeholder='密码'/></td>";
        str+="<td class='czu'><input type='button' value='保存' onclick='save(this)'/> &nbsp &nbsp <input type='button' value='取消' onclick='removeEle()'/></tr>";
        if(targ){
            $tbody.append(str);
        } else {
            $tbody.before(str);
        }

    }

    function cancleStyle(){
        getData();
    }

    //添加事件
    function save(ele){
        var $p = $(ele).parent().parent();
        var userName=trim($p.find('.userName').val());
        var userPwd =trim($p.find('.userPassword').val());
        $.ajax({
            type:"post",
            url:"${pageContext.request.contextPath}/user/adduser",
            dataType:"json",
            data:{"username":userName,"password":userPwd},
            success:function(data){
                if(data.success){
                    alert('添加成功');
                    $("#userName").val("");
                    $("#userPassword").val("");
                    getData();
                } else {
                    alert(data.msg);
                }
            }
        });
    }

    function delAll(){
        if(!confirm("确定要删除吗？")){
            return false;
        }
        var ids="";
        var id_=$('#id_').val();
        if(id_){
            ids = id_;
        } else {
            $("input[name='selectItem']:checked").each(function(){
                ids+=this.value+",";
            });
        }
        if(ids==""){
            alert("请选择要删除的数据");
        }else{
            var param = {"ids" : ids};
            $.ajax({
                type:"post",
                url:"${pageContext.request.contextPath}/user/delusers",
                data:param,
                dataType:"json",
                success:function(res){
                    if(res.success){
                        alert("删除成功");
                        getData();
                    }
                },
                error:function(){
                    getData();
                }
            });
        }
    }

    //修改样式
    function update(a){
        var $p = $(a).parent().parent();
        $p.html("<td class='uid'>"+$($p.children()[1]).text()+"</td>" +
                "<td colspan='5'><input type='text' placeholder='请输入密码' maxlength=20 class='userPassword' style='width=20px'/></td>" +
                "<td><input type='button'value='保存' onclick='edit(this)'> &nbsp <input type='button'value='取消' onclick='cancleStyle()'></td>");
    }

    function edit(ele){
        var $p = $(ele).parent().parent();
        var uid = trim($p.find('.uid').text());
        var userPwd =trim($p.find('.userPassword').val());
        var param={"uid":uid, "password":userPwd};
        $.ajax({
            type:"post",
            url:"${pageContext.request.contextPath}/user/modiuser",
            dataType:"json",
            data:param,
            success:function(data){
                if(data.success){
                    alert('修改成功');
                    getData();
                }
            },error:function(e){
                alert('修改成功');
                getData();
            }
        });

    }
</script>
</html>
