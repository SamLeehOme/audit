<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>记录列表</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/page.css">
</head>
<%@ include file="../../../jslib/common/ins.jsp"%>

<body>
    <div>
        <form class="form-horizontal" role="form">
            <!-- form-horizontal。 把标签和控件放在一个带有 class .form-group 的<div> 中 -->
            <fieldset style="margin-bottom: -40px;margin-top: 16px;">
                <div class="form-group"><!--如果还有第二行的条件查询，可以放再放一个这样的div  -->
                    <label class="col-sm-1 control-label">日期查询</label>
                    <div class="col-sm-5" style="float: left;width:100px">
                        <input class="form-control" id="startTime" style="width: 100px" type="text" placeholder="start" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
                    </div>
                    <label class="col-sm-1 control-label">---至---</label>
                    <div class="col-sm-5" style="width:100px">
                        <input class="form-control" id="endTime" style="width: 100px" type="text" placeholder="end" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
                    </div>

                    <label class="col-sm-1 control-label">组织代码</label>
                    <div class="col-sm-5" style="float: left;width:200px">
                        <select class="form-control" id="orgCodeSelector">
                            <option value=''></option>
                        </select>
                    </div>
                    <label class="col-sm-1 control-label">globalId</label>
                    <div class="col-sm-5" style="float: left;width:110px">
                        <input class="form-control" id="globalIdBegin" style="width: 110px" type="text"/>
                    </div>
                    <label class="col-sm-1 control-label">---至---</label>
                    <div class="col-sm-5" style="width:110px">
                        <input class="form-control" id="globalIdEnd" style="width:110px" type="text"/>
                    </div>
                    <div class="col-sm-6" style="float: right;width:100px">
                        <button class="btn btn-default" type="button" style="margin:0px 7px;
                                            background: linear-gradient(180deg, rgba(255, 255, 255, 1) 0%,rgba(255, 255, 255, 1) 0%,rgba(204, 204, 204, 1) 100%,rgba(204, 204, 204, 1) 100%);" onclick="getData()">检索</button>
                    </div>
                </div>
            </fieldset>
            <div class="clearfix form-actions" style="text-align:center; ">
            </div>
        </form>
    </div>
    <hr/>
    <div id="showDataDiv">
        <table class="table table-bordered table-hover table-condensed" style="background-color: white" id="showData">
            <thead>
            <tr>
                <th colspan='11'>
                    <div>
                        <div style="float:left;width:300px;">
                            <div id='listName'>记录列表</div>
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

        initOrgCode();
        getData();

        onkeydown=function(){
            var e = event || window.event || arguments.callee.caller.arguments[0];
            if(13 == e.keyCode){
                getData();
            }
        }
    });
    function getData(){
        var currentPage=$("#cpageNum").val();
        var pageSize = $("#pageSize").val();
        var startTime=$("#startTime").val();
        var endTime = $("#endTime").val();
        var code = $('#orgCodeSelector').val();
        var globalIdBegin = $('#globalIdBegin').val();
        var globalIdEnd = $('#globalIdEnd').val();
        var condition={startTime:startTime, endTime:endTime,code:code,globalIdBegin:globalIdBegin,globalIdEnd:globalIdEnd};
        var param={"conditionJson":JSON.stringify(condition), "currentPage": Number(currentPage),"pageSize": Number(pageSize)};
        $.ajax({
            url:"${pageContext.request.contextPath }/idRecord/findAll",
            dataType:"json",
            data:param,
            success:function(res){deadNum=5;
                var str = "<tbody>" +
                        "<tr id='thead'><td><input type='checkbox' id='allid' onclick='selectAll(\"allid\",\"selectItem\")'/></td>全选<td style='display:none'>序号</td><td>时间</td><td>代码</td><td>开始id</td><td>结束id</td></tr>";
                for (var i = 0; i < res.length; i++){
                    var json = res[i];
                    json = eval(json.records);
                    for(var i=0; i<json.length; i++)
                    {
                        str = str + "<tr id='"+json[i].id+"'><td><input type='checkbox' name='selectItem' value='"+json[i].id+"'><input type='hidden' id='hidId' value='"+json[i].id+"'></td>";
                        str += "<td style='display:none' class='id'>"+json[i].id+"</td>";
                        str = str + "<td>" + json[i].time + "</td>";
                        str = str + "<td>" + json[i].code + "</td>";
                        str = str + "<td>" + json[i].globalIdStart + "</td>";
                        str = str + "<td>" + json[i].globalIdEnd + "</td></tr>";
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
                    $("#date_panel").html("").html(e.responseText);
                }
            }
        });
    }

    /*
     组织代码下拉菜单赋值
     */
    function initOrgCode() {
        $.ajax({
            type: "get",
            url: "${pageContext.request.contextPath }/orgCode/findAll?currentPage=0&pageSize=65535",
            dataType: "json",
            success: function (res) {
                var str = "";
                for (var i = 0; i < res.length; i++) {
                    var json = res[i];
                    json = eval(json.codes);
                    for (var i = 0; i < json.length; i++) {
                        //添加下拉菜单option值
                        str = "<option value='" + json[i].code + "'>" + json[i].name + "</option>";
                        $("#orgCodeSelector").append(str);
                    }
                }
            },
            error: function (res) {
                debugger
                pop("网络错误", "获取通道列表时发生网络错误", 3000);
            }
        });
    }
</script>
</html>
