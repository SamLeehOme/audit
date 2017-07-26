<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../../../jslib/common/ins.jsp" %>
<html>
<head>
    <title></title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/homePage.css">
</head>
<body style="text-align: center;">
<div class="divFloat">
    <div class="div1" id="main1"></div>
    <div class="div2" id="main3"></div>
</div>
<div class="divFloat1">
    <div class="div3" id="main2"></div>
    <div class="div4" id="main4"></div>
</div>


<script type="text/javascript">
    $(function () {
        var LastWeekCodeUsageName = new Array();
        var LastWeekCodeUsageData = new Array();
        var currentUsageName = new Array();
        var currentUsageData = new Array();
        var LastDayHourlyUsageName = new Array();
        var LastDayHourlyUsageData = new Array();
        var LastMonthDailyUsageName = new Array();
        var LastMonthDailyUsageData = new Array();
        $.ajax({
            url: "${pageContext.request.contextPath}/idRecord/statisticalCodeUsage",
            dataType: "json",
            async: false,
            success: function (res) {

                var date = new Date;
                var hour = date.getHours();
                var day = date.getDate();

                for (var i = 0; i < 24; i++) {
                    LastDayHourlyUsageName.push((hour + i) % 24 + "");
                    LastDayHourlyUsageData.push(0);
                }
                for (var i = 0; i < 30; i++) {
                    LastMonthDailyUsageName.push((day + i) % 30 + 1 + "");
                    LastMonthDailyUsageData.push(0);
                }
                debugger

                for (var i in res) {
                    if (res[i][2] == 'LastWeekCodeUsage') {
                        LastWeekCodeUsageName.push(res[i][0]);
                        var data = {"value": res[i][1], "name": res[i][0]};
                        LastWeekCodeUsageData.push(data);
                    } else if (res[i][2] == "CurrentUsage") {
                        currentUsageName.push(res[i][0]);
                        currentUsageData.push(res[i][1]);
                    } else if (res[i][2] == "LastDayHourlyUsage") {
                        var index = LastDayHourlyUsageName.indexOf(res[i][0]);
                        if (index != -1) {
                            LastDayHourlyUsageData[index] = res[i][1];
                        }
                    } else if (res[i][2] == "LastMonthDailyUsage") {
                        var index = LastMonthDailyUsageName.indexOf(res[i][0]);
                        if (index != -1) {
                            LastMonthDailyUsageData[index] = res[i][1];
                        }
                    }
                }
            }
        });


        // 基于准备好的dom，初始化echarts实例
        var myChart1 = echarts.init(document.getElementById('main1'));
        var myChart2 = echarts.init(document.getElementById('main2'));
        var myChart3 = echarts.init(document.getElementById('main3'));
        var myChart4 = echarts.init(document.getElementById('main4'));



        //饼状图样式
        var option1 = {
            backgroundColor: '#F8F8FF',
            title: {
                text: '本周代码比例分布',
                x: 'center'
            },
            tooltip: {
                trigger: 'item',
                formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            legend: {
                orient: 'vertical',
                left: 'left',
                data: LastWeekCodeUsageName
            },
            series: [
                {
                    name: '代码使用情况统计',
                    type: 'pie',
                    radius: '55%',
                    center: ['50%', '60%'],
                    data: LastWeekCodeUsageData,
                    itemStyle: {
                        emphasis: {
                            shadowBlur: 10,
                            shadowOffsetX: 0,
                            shadowColor: 'rgba(0, 0, 0, 0.5)'
                        }
                    }
                }
            ]
        };

        //柱状图样式
        var option2 = {
            backgroundColor: '#F8F8FF',
            title: {
                text: '24小时使用情况',
                x: 'center'
            },
            color: ['#3398DB'],
            tooltip: {
                trigger: 'axis',
                axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                    type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                }
            },
            grid: {
                left: '3%',
                bottom: '3%',
                containLabel: true
            },
            xAxis: [
                {
                    type: 'category',
                    data: LastDayHourlyUsageName,
                    axisTick: {
                        alignWithLabel: true,
                    },
                    axisLabel: {
                        interval: 0,
                        margin: 2,
                        textStyle: {
                            color: "#222"
                        }
                    }
                }
            ],
            yAxis: [
                {
                    type: 'value',
                    min: 0,
                    minInterval: 1
                }
            ],
            series: [
                {
                    name: '使用次数',
                    type: 'bar',
                    barWidth: '60%',
                    data: LastDayHourlyUsageData
                }
            ]
        };

        var option3 = {
            backgroundColor: '#F8F8FF',
            title: {
                text: '本日使用情况',
                x: "center"
            },
            tooltip: {
                trigger: 'axis',
                axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                    type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                }
            },
            xAxis: {
                data: currentUsageName
            },
            yAxis: {},
            series: [{
                name: '本日使用情况',
                type: 'bar',
                data: currentUsageData
            }]
        };

        var option4 = {
            backgroundColor: '#F8F8FF',
            title: {
                text: '30天使用情况',
                x: "center"
            },
            tooltip: {
                trigger: 'axis',
                axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                    type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                }
            },
            grid: {
                right: '3%',
                bottom: '3%',
                containLabel: true
            },
            xAxis: {
                data: LastMonthDailyUsageName
            },
            yAxis: {},
            series: [{
                name: '本日用量',
                type: 'bar',
                data: LastMonthDailyUsageData
            }]
        };
        //使用指定的配置项和数据显示图表。
        myChart1.setOption(option1);
        myChart2.setOption(option2);
        myChart3.setOption(option3);
        myChart4.setOption(option4);
    })
</script>
</body>
</html>
