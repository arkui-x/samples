import router from '@ohos.router'

// Page title bar
@Component
export struct TitleBar {
  @Prop title: Resource

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(20)
          .height(20)
          .margin({ left: 26 })
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })
          .id('backBtn')
        Text(this.title)
          .fontSize(20)
          .layoutWeight(1)
          .margin({ left: 16 })
          .align(Alignment.Start)
        Blank()
      }
      .height(56)
      .width('100%')
    }
  }
}
export function debounce(fn:()=>void, delay:number) {
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