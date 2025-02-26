// @ts-nocheck
'use strict';
let barChart1Opts = null;
let barChart2Opts = null;
let barChart3Opts = null;

function init() {
    const barChart1 = document.getElementById('barchart_1');
    const barChart2 = document.getElementById('barchart_2');
    const barChart3 = document.getElementById('barchart_3');
    const option1 = {
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
    const option2 = {
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
    const option3 = {
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
    barChart1Opts = echarts.init(barChart1);
    barChart2Opts = echarts.init(barChart2);
    barChart3Opts = echarts.init(barChart3);

    barChart1Opts.setOption(option1);
    barChart2Opts.setOption(option2);
    barChart3Opts.setOption(option3);

    window.addEventListener('resize', (event) => {
        barChart1Opts.resize();
        barChart2Opts.resize();
        barChart3Opts.resize();
    });
}

function barChartResize() {
    barChart1Opts.resize();
    barChart2Opts.resize();
    barChart3Opts.resize();
}

(function () {
    init();
})();
