import router from '@ohos.router'

const ANIMATION_TIME: number = 500
const ANIMATION_PROGRESS: number = -600

@Entry
@Component
struct PageTransitionSampleTo {
  @State topY: number = 0
  @State zoom: number = 0
  @State angle: number = 1
  @State leftX: number = 0
  @State rightX: number = 0
  @State bottomY: number = 0
  @State progress: number = 0
  @State transitionType: SlideEffect = SlideEffect.Left

  build() {
    Column() {
      Text('PAGE TRANSITIONS')
        .fontSize(50)
        .opacity(0.4)
      Text($r('app.string.page_transition_back'))
        .height(70)
        .fontSize(30)
        .borderRadius(24)
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Bold)
        .padding({ left: 12, right: 12 })
        .fontColor($r('app.color.font_color_shallow'))
        .backgroundColor($r('app.color.pop_up_background'))
        .onClick(() => {
          router.back()
        })
        .margin({ top: 100 })
    }
    .width('100%')
    .height('100%')
    .opacity(this.progress)
    .backgroundColor($r('app.color.background_shallow_grey'))
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .rotate({ z: 1, angle: this.progress * this.angle })
    .scale({ x: this.progress * this.zoom / 2, y: this.progress * this.zoom / 2, centerY: '50%', centerX: '50%' })
  }
  aboutToAppear() {
    const routerParams = router.getParams() as Record<string,SlideEffect|number>
    this.transitionType = routerParams.type as SlideEffect
    this.angle = routerParams.angle as number
    this.zoom = routerParams.zoom as number
  }

  pageTransition() {
    // Entry animation
    PageTransitionEnter({ duration: ANIMATION_TIME, curve: Curve.Linear })
      .slide(this.transitionType)
      .onEnter((type: RouteType, progress: number) => {
        this.topY = (-progress + 1) * this.topY
        this.bottomY = (-progress + 1) * this.bottomY
        this.leftX = (-progress + 1) * this.leftX
        this.rightX = (-progress + 1) * this.rightX
        this.progress = progress
      })

    // Exit animation
    PageTransitionExit({ duration: ANIMATION_TIME, curve: Curve.Ease })
      .slide(this.transitionType)
      .onExit((type: RouteType, progress: number) => {
        this.topY = -ANIMATION_PROGRESS * progress
        this.bottomY = ANIMATION_PROGRESS * progress
        this.leftX = -ANIMATION_PROGRESS * progress
        this.rightX = ANIMATION_PROGRESS * progress
        this.progress = progress
      })
  }
}

