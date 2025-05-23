// @ts-nocheck
'use strict';
(function () {
    const screenSelector = document.querySelector('#screen-selector'); // JS Interop 下拉框
    const valueField = document.querySelector('#value'); // JS Interop计数框的值
    const incrementButton = document.querySelector('#increment'); // JS Interop点击按钮
    const counter = document.querySelector('#counter'); // counter中的计数值
    const counterBtn = document.querySelector('#countBtn'); // counter中的计数值
    const textField = document.querySelector('#textField'); // textfield
    const custom = document.querySelector('#custom'); // customer app
    const counterIncrement = document.querySelector('#counter_increment'); // counter中的点击按钮
    valueField.setAttribute('value', 0);
    /* 设置下拉框变更事件 */
    screenSelector.addEventListener('change', (event) => {
        const enabled = event.target.value === 'counter';
        valueField.disabled = !enabled;
        incrementButton.disabled = !enabled;
        switch (event.target.value) {
            case 'counter':
                counter.classList.remove('hide');
                textField.classList.add('hide');
                custom.classList.add('hide');
                break;
            case 'textField':
                counter.classList.add('hide');
                textField.classList.remove('hide');
                custom.classList.add('hide');
                break;
            case 'custom':
                counter.classList.add('hide');
                textField.classList.add('hide');
                custom.classList.remove('hide');
                break;
            default:
                break;
        }
    });
    /* 设置JS Interop计数按钮点击事件 */
    incrementButton.addEventListener('click', (event) => {
        let value = valueField.getAttribute('value');
        valueField.setAttribute('value', ++value);
        counterBtn.innerHTML = value;
    });
    /* 设置counter内计数按钮点击事件 */
    counterIncrement.addEventListener('click', (event) => {
        let value = valueField.getAttribute('value');
        valueField.setAttribute('value', ++value);
        counterBtn.innerHTML = value;
    });

    // 监听文本域输入，高度自动变化
    function makeExpandingArea(el) {
        let timer = null;
        const setStyle = function (elInner, auto) {
            const parentHeight = elInner.parentElement.clientHeight;
            if (parentHeight === 0) {
                return;
            }
            if (auto) {
                elInner.style.height = 'auto';
            }
            elInner.style.cssText = `height: ${elInner.scrollHeight}px;max-height: ${
                parentHeight - 20
            }px;`;
            if (elInner.scrollHeight > parentHeight) {
                elInner.style.cssText += 'overflow-y: scroll;';
            }
        };
        const delayedResize = function (elInner) {
            if (timer) {
                clearTimeout(timer);
                timer = null;
            }
            timer = setTimeout(() => {
                setStyle(elInner);
            }, 200);
        };
        if (el.addEventListener) {
            el.addEventListener(
                'input',
                () => {
                    setStyle(el, 1);
                },
                false
            );
            setStyle(el);
        } else if (el.attachEvent) {
            el.attachEvent('onpropertychange', () => {
                setStyle(el);
            });
            setStyle(el);
        }
        if (window.VBArray && window.addEventListener) {
            // IE9
            el.attachEvent('onkeydown', () => {
                const key = window.event.keyCode;
                if (key === 8 || key === 46) {
                    delayedResize(el);
                }
            });
            el.attachEvent('oncut', () => {
                delayedResize(el);
            }); // 处理粘贴
        }
    }

    // 监听文本换行
    function exeTextLine(obj) {
        if (obj === '') {
            const textareaList = document.getElementsByClassName('my-text-area');
            for (let i = 0; i < textareaList.length; i++) {
                makeExpandingArea(textareaList[i]);
            }
        } else {
            makeExpandingArea(obj);
        }
    }
    exeTextLine('');
})();
function customerOnInput(value) {
    const customerInput = document.getElementById('customerInput');
    customerInput.innerHTML = value.length;
}

function resetCustomerInput(e) {
    e.target.previousElementSibling.value = '';
    e.target.parentElement.previousElementSibling.children[1].children[0].innerHTML = 0;
}
