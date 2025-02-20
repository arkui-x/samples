// @ts-nocheck
'use strict';
(function () {
    let handheld;

    let controlButtons = document.querySelector('#fx');
    let setTarget = document.querySelector('#set_target');

    let attribution = document.createElement('span');
    attribution.className = 'imageAttribution';
    
    function handleHandHeld(fx) {
        resetRotation();
        if (!handheld) {
            handheld = document.createElement('div');
            handheld.id = 'handheld';
            handheld.classList.add('hidden');
            setTarget.parentNode.insertBefore(handheld, setTarget);
            handheld.append(setTarget);
            handheld.append(attribution);
            window.setTimeout(function () {
                handheld.classList.remove('hidden');
            }, 100);
            // Disable all effects on the flutter container
            setTarget.className = '';
            setOtherFxEnabled(false);
        } else {
            handheld.classList.add('hidden');
            window.setTimeout(function () {
                handheld.parentNode.insertBefore(setTarget, handheld);
                handheld.remove();
                handheld = null;
            }, 210);
            setOtherFxEnabled(true);
        }
        window.requestAnimationFrame(function () {
            // Let the browser flush the DOM...
            setTarget.classList.toggle(fx);
        });
    }

    function handleRotation(degrees) {
        setTarget.style.transform = `perspective(1000px) rotateY(${degrees}deg)`;
    }

    function resetRotation() {
        setTarget.style = null;
    }

    function setOtherFxEnabled(enabled) {
        controlButtons.querySelectorAll('input').forEach((btn) => {
            if (btn.dataset.fx !== 'handheld') {
                btn.disabled = !enabled;
            }
        });
    }

    controlButtons.addEventListener('click', (event) => {
        let fx = event.target.dataset.fx;
        if (fx === 'handheld') {
            handleHandHeld(fx);
            return;
        }
        setTarget.classList.toggle(fx);
    });

    controlButtons.addEventListener('input', (event) => {
        if (event.target.id === 'rotation') {
            setTarget.classList.toggle('spin', false);
            handleRotation(event.target.value);
        }
    });
})();
