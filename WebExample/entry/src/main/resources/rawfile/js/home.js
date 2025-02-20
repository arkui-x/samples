// @ts-nocheck
'use strict';
var barchart_1Opts = null;
var barchart_2Opts = null;
var barchart_3Opts = null;

function init() {
    const barchart_1 = document.getElementById('barchart_1');
    const barchart_2 = document.getElementById('barchart_2');
    const barchart_3 = document.getElementById('barchart_3');
    const option_1 = {
        color: ['#52894e'],
        grid: {
            left: '20%',
            right: '20%',
        },
        xAxis: {
            type: 'category',
            data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        },
        yAxis: {
            type: 'value',
            alignTicks: true,
            axisLine: {
                show: true,
            },
        },
        // 柱图数据
        series: [
            {
                // 图形样式：柱图
                type: 'bar',
                data: [120, 199, 150, 180, 70, 110, 130],
                showBackground: true,
            },
        ],
    };
    const option_2 = {
        color: ['#1c68d4'],
        grid: {
            left: '20%',
            right: '20%',
        },
        // x轴数据
        xAxis: {
            type: 'category',
            data: ['1月', '2月', '3月', '4月', '5月', '6月', '7月'],
        },
        yAxis: {
            type: 'value',
            alignTicks: true,
            axisLine: {
                show: true,
            },
        },
        // 柱图数据
        series: [
            {
                // 图形样式：柱图
                type: 'bar',
                data: [1213, 30, 150, 80, 70, 910, 630],
                showBackground: true,
            },
        ],
    };
    const option_3 = {
        grid: {
            left: '20%',
            right: '20%',
        },
        // x轴数据
        xAxis: {
            type: 'category',
            data: ['A', 'B', 'C', 'D', 'E', 'F', 'G'],
        },
        yAxis: {
            type: 'value',
            alignTicks: true,
            axisLine: {
                show: true,
            },
        },
        // 柱图数据
        series: [
            {
                // 图形样式：柱图
                type: 'bar',
                data: [0.01, 0.2, 0.05, 0.07, 0.04, 0.13, 0.9],
                showBackground: true,
            },
        ],
    };
    barchart_1Opts = echarts.init(barchart_1);
    barchart_2Opts = echarts.init(barchart_2);
    barchart_3Opts = echarts.init(barchart_3);

    barchart_1Opts.setOption(option_1);
    barchart_2Opts.setOption(option_2);
    barchart_3Opts.setOption(option_3);

    window.addEventListener('resize', (event) => {
        barchart_1Opts.resize();
        barchart_2Opts.resize();
        barchart_3Opts.resize();
    });
}

function barChartResize() {
    barchart_1Opts.resize();
    barchart_2Opts.resize();
    barchart_3Opts.resize();
}

(function () {
    init();
})();
