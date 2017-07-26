<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>组织结构管理</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/page.css">
</head>
<%@ include file="../../../jslib/common/ins.jsp"%>

<body>
    <hr/>
    <div id="showDataDiv">
        <table class="table table-bordered table-hover table-condensed" style="background-color: white" id="showData">
            <thead>
            <tr>
                <th colspan='11'>
                    <div>
                        <div style="float:left;width:300px;">
                            <div id='listName'>组织结构管理</div>
                        </div>
                        <div style="float: right;">
                            <button class="btn btn-default" type="button" style="margin:0px 7px; background: linear-gradient(180deg, rgba(255, 255, 255, 1) 0%,rgba(255, 255, 255, 1) 0%,rgba(204, 204, 204, 1) 100%,rgba(204, 204, 204, 1) 100%);" data-toggle="modal" onclick="add()">新增</button>
                            <button class="btn btn-default" type="button" style="margin:0px 7px; background: linear-gradient(180deg, rgba(255, 255, 255, 1) 0%,rgba(255, 255, 255, 1) 0%,rgba(204, 204, 204, 1) 100%,rgba(204, 204, 204, 1) 100%);" data-toggle="modal" onclick="del()">删除</button>
                        </div>
                    </div>
                </th>
            </tr>
            </thead>
        </table>
    </div>
    <!--分页  -->
    <input type="hidden" id="cpageNum">
    <input type="hidden" id="pageSize">
    <span style="display:none" id="cpage"></span>
    <span style="display:none" id="totalPage"></span>
    <div>
        <div class="total_page" style="float: left;"></div>
        <div id="pageToolbar" style="float:right"></div>
    </div>
    <%--popup控件--%>
    <div id="pop" class="panel panel-default pop" hidden style=" margin-bottom: 150px;margin-right:500px">
        <div id="popHead" class="popHead">
            <a class="popClose" title="关闭" onclick="closePop()">关闭</a>
            <span></span>
        </div>
        <div class="errorImg"><img src="${pageContext.request.contextPath}/images/error.gif" /></div>
        <div id="popTxt" class="popContext"></div>
    </div>
</body>
<script type="text/javascript">
    var pagesize = 10;
    var deadNum = 5;
    $(document).ready(function(){
        getData();
    });
    function getData(){
        var currentPage=$("#cpageNum").val();
        var pageSize = $("#pageSize").val();
        var startTime=$("#startTime").val();
        var endTime = $("#endTime").val();
        var uploadStatus = $('#uploadStatus').val();
        var param={"currentPage": Number(currentPage),"pageSize": Number(pageSize)};
        $.ajax({
            type:"get",
            url:"${pageContext.request.contextPath }/orgCode/findAll",
            dataType:"json",
            data:param,
            success:function(res){deadNum=5;
                var str = "<tbody>" +
                        "<tr id='thead'><td><input type='checkbox' id='allid' onclick='selectAll(\"allid\",\"selectItem\")'/></td>全选<td style='display:none'>序号</td><td>类型</td><td>名称</td><td>创建时间</td><td>最后一次修改时间</td><td>操作</td></tr>";
                for (var i = 0; i < res.length; i++){
                    var json = res[i];
                    json = eval(json.codes);
                    for(var i=0; i<json.length; i++)
                    {
                        str = str + "<tr id='"+json[i].id+"'><td><input type='checkbox' name='selectItem' value='"+json[i].id+"'><input type='hidden' id='hidId' value='"+json[i].id+"'></td>";
                        str += "<td style='display:none' class='id'>"+json[i].id+"</td>";
                        str = str + "<td class='code'>" + json[i].code + "</td>";
                        str = str + "<td class='name'>" + json[i].name + "</td>";
                        str = str + "<td>" + json[i].dateCreated + "</td>";
                        str = str + "<td>" + json[i].lastModified + "</td>";
                        str = str + "<td><a href='#' onclick='update(this)'>修改</a></td></tr>";
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
            error:function(){
                if(deadNum-- > 0){
                    getData();
                } else {
                    alert("数据有误，请联系管理员！");
                }
            }
        });
    }

    function del(){
        if(!confirm("确定要删除吗？")){return false;}
        var ids="";
        $("input[name='selectItem']:checked").each(function(){
            ids+=this.value+",";
        });
        if(ids==""){
            pop("提示信息","请选择删除的数据",3000);
        }else{
            var param = {"ids" : ids};
            $.ajax({
                type:"post",
                url:"${pageContext.request.contextPath}/orgCode/batchDel",
                data:param,
                dataType:"json",
                success:function(res){
                    if(res.success){
                        getData();
                    }else{
                        showPop(res.msg);
                    }
                }
            });
        }
    }

    //添加样式
    function add(){
        var $tbody = $('#thead');
        $('.tone').remove();
        $tbody.after("<tr class='tone'><td><input type='checkbox' name='selectItem' value=''></td>" +
                "<td style='display:none'></td>" +
                "<td><input type='text'  style='width:70px'id='code'/></td>" +
                "<td><input type='text'  style='width:70px'id='name'/></td>" +
                "<td></td><td></td>" +
                "<td><input type='button' value='保存' onclick='save()'/> &nbsp &nbsp <input type='button' value='取消' onclick='removeEle()'/></tr>");
    }

    //添加事件
    function save(){
        var code=$("#code").val();
        var name=$('#name').val();
        if(code==""){
            alert("类型不允许为空");
            return;
        }
        param={"code":code,"name":name};
        $.ajax({
            type:"post",
            url:"${pageContext.request.contextPath}/orgCode/insert",
            data:param,
            dataType:"json",
            success:function(data){
                if(data.success){
                    getData();
                }
            }
        });
    }

    //取消添加样式
    function removeEle(){
        $('.tone').remove();
    }

    //取消修改样式
    function cancleStyle(){
        getData();
    }

    function update(a){
        var tr = a.parentElement.parentElement;
        $.each($(tr).children(), function(i,n){
            var val=$(n).html();
            var val1=$($(n).find('input')[0]).val();
            if(i == 0){
                $(n).html("").html("<input type='checkbox'value='"+val1+"'/>");
            } else if(i == $(tr).children().size()-1){
                $(n).html("").html("<input type='button'value='保存' onclick='edit(this.parentElement.parentElement)'> &nbsp <input type='button'value='取消' onclick='cancleStyle()'>");
            } else if(i==2) {
                $(n).html("").html("<input type='text' style='width=20px' value='"+val+"'/>");
            } else if(i==3) {
                $(n).html("").html("<input type='text' style='width=20px' value='"+val+"'/>");
            }
        });
    }

    function edit(trEle){
        param={"id":$(trEle).find(".id").text(),"code":$(trEle).find(".code input").val(),"name":$(trEle).find(".name input").val()};
        $.ajax({
            type:"post",
            url:"${pageContext.request.contextPath}/orgCode/update",
            data:param,
            dataType:"json",
            success:function(data){
                if(data.success){
                    getData();
                }
            }
        });
    }
</script>
</html>
