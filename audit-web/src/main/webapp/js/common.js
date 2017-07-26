/**
 * 用于checkbox全选
 * @param allId checkbox全选id
 * @param childName
 */
function selectAll(allId, childName){
    var status=document.getElementById(allId).checked;
    var all=document.getElementsByName(childName);
    for(var i=0; i<all.length; i++){
        all[i].checked=status;
    }
}

/**
 *
 * @param e 传递element
 * @param panelId 模态框的id
 */
function del(e, id){
    var e = e||window.event;
    var scrollx = window.scrollX|| document.documentElement.scrollLeft;
    var scrolly = window.scrollY|| document.documentElement.scrollTop;
    var x = parseFloat(e.clientX) + parseFloat(scrollx) ;
    var y = parseFloat(e.clientY) + parseFloat(scrolly);
    $('.delDialog').css('position', 'absolute');
    $('.delDialog').css('top', y+'px');
    $('.delDialog').css('left', (x-$('.delDialog').width())+'px');
    $('#delModal').find($('#id_')).val(id);
    $('#delModal').modal('show');
}

function rollbackItem(id){
    $('#'+id).html("").html('<td colspan="12">已删除本条产品代码，若操作失误请 <a href="#" onclick="rollbackTr('+id+')">撤消删除</a></td>');
}

function removeEle(){
    $('.tone').remove();
}

/**
 * 异步传输
 * @param method 传输方式get post
 * @param url 传输的地址
 * @param param 传输的参数
 */
function ajaxTemplate(method, url, param, callback){
    if(method == ""){method="get"}
    $.ajax({
        type:method,
        url:url,
        data:param,
        dataType:"json",
        success:function(res){
            
        },
        error:function(){
            alert("发生网络错误");
        }
    });

}

function showTxt(ele){
    $(ele).css({'white-space':'normal'});
}

function hideTxt(ele){
    $(ele).css({'white-space':'nowrap'});
}

function trim(str){
    return $.trim(str);
}

function showDelMouse(ele){
    $(ele).css({'color':'red'});
}

function hideMouse(ele){
    $(ele).css({'color':''});
}

function showUpdateMouse(ele){
    $(ele).css({'color':'orange'});
}
