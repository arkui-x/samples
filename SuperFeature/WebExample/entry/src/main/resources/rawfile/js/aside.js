// @ts-nocheck
'use strict';
(function () {
    const aside = document.querySelector('.aside');
    const tollbar = document.querySelector('.toolbar'); // 获取控制展开、隐藏的DIV
    const menu = document.querySelector('.menu'); // 菜单栏
    const main = document.querySelector('.main'); // 展示内容区域
    const hiddenClass = 'hidden';
    const activeClass = 'actived';
    tollbar.addEventListener('click', (event) => {
        const currentShow = tollbar.children[0].classList.contains(hiddenClass);
        if (!currentShow) {
            tollbar.children[0].classList.add(hiddenClass);
            tollbar.children[1].classList.remove(hiddenClass);
            tollbar.setAttribute('title', '展开');
            aside.style.cssText = 'width: 0 !important;';
            aside.classList.remove('aside-show');
        } else {
            tollbar.children[0].classList.remove(hiddenClass);
            tollbar.children[1].classList.add(hiddenClass);
            tollbar.setAttribute('title', '隐藏');
            aside.classList.add('aside-show');
            aside.style.cssText = '';
        }
        barChartResize();
    });
    const len = menu.children.length;
    for (let index = 0; index < len; index++) {
        const el = menu.children[index];
        el.addEventListener('click', (event) => {
            main.children[index].classList.remove('hide');
            el.classList.add(activeClass); // 给当前节点添加选中样式
            for (let i = 0; i < len; i++) {
                if (i !== index) {
                    menu.children[i].classList.remove(activeClass); // 删除其余节点的选中样式
                    main.children[i].classList.add('hide');
                }
            }
            if (index === 0) {
                setTimeout(() => {
                    barChartResize();
                }, 10);
            } else if (index === 1) {
                setTimeout(() => {
                    const table = document.querySelector('.table');
                    const tbody = table.children[1];
                    tbody.style.cssText = `max-height: ${table.clientHeight - 32}px;`;
                }, 10);
            }
        });
    }
})();
