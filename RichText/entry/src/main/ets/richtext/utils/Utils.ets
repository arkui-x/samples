// 防抖
export function debounce(fn:Function, delay:number) {
  let timer = 0
  const _debounce = ()=> {
    // 取消上一次的定时器
    if (timer) clearTimeout(timer)
    // 延迟执行
    timer = setTimeout(() => {
      // 外部传入的真正要执行的函数
      fn()
      timer = 0
    }, delay)
  }
  return _debounce
}

