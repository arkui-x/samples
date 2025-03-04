// @ts-nocheck
'use strict';
(function () {
    const table = document.querySelector('.table');
    const tbody = table.querySelector('tbody');
    const tableData = [];
    const [date, name, city, district, address, postcode] = [
        '2016-05-03',
        '王小虎',
        '上海',
        '普陀区',
        '上海市普陀区金沙江路 1518 弄',
        200333,
    ];
    for (let index = 0; index < 40; index++) {
        tableData.push([date, name, city, district, address, postcode]);
    }
    tableData.forEach((item) => {
        const tr = document.createElement('tr');
        item.forEach((value) => {
            const td = document.createElement('td');
            const div = document.createElement('div');
            div.innerHTML = value;
            td.appendChild(div);
            tr.appendChild(td);
        });
        tbody.appendChild(tr);
    });
    tbody.style.maxHeight = `${table.clientHeight}px`;
})();