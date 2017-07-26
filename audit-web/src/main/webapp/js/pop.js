function pop(title,text,time){
    if(title==undefined)
        title = "消息提示";

    if(text==undefined)
        text = "修改成功";

    if(time==undefined)
        time = 2000;

    $("#popHead span").html(title);
    $("#popTxt").html(text) ;
    $("#pop").show(100,"linear",function(){
        setTimeout("closePop()",time);
        showTime(time);
    });
}

function showPop(txt){
    title = "消息提示";
    $("#popHead span").html(title);
    $("#popTxt").html(txt) ;
    $("#pop").show(0,"linear",function(){
    });
}

function closePop(){
    $("#pop").hide();
}

/**
 * 页面报错pop倒计时显示
 * @param time
 */


function showTime(time){
    var second = time / 1000;
    $("#showTime span").html(second);
    second--;
    time = time-1000;
    if(time >= 0){
        setTimeout(function() {
                showTime(time)
            },
            1000)
    }

}