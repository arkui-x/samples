import router from '@ohos.router'
import { TitleBar } from '../../../common/TitleBar'

const ANIMATION_URL: string = 'pages/TransitionAnimations/pageTransitionSample/PageTransitionSampleTo'

@Extend(Text) function textStyle() {
  .height(60)
  .fontSize(20)
  .width('100%')
  .borderRadius(24)
  .margin({ top: 12 })
  .fontWeight(FontWeight.Bold)
  .textAlign(TextAlign.Center)
  .fontColor($r('app.color.font_color_shallow'))
  .backgroundColor($r('app.color.pop_up_background'))
}

@Entry
@Component
struct PageTransitionSample {
  @State zoom: number = 2
  @State angle: number = 360

  build() {
    Column() {
      TitleBar({ title: $r('app.string.page_transition') })
      Scroll() {
        Column() {
          Text($r('app.string.page_transition_top'))
            .textStyle()
            .margin({ top: 50 })
            .onClick(() => {
              router.pushUrl({
                url: ANIMATION_URL,
                params: { enterType: SlideEffect.Top, exitType: SlideEffect.Bottom }
              })
            })
          Text($r('app.string.page_transition_bottom'))
            .textStyle()
            .onClick(() => {
              router.pushUrl({
                url: ANIMATION_URL,
                params: { enterType: SlideEffect.Bottom, exitType: SlideEffect.Top }
              })
            })
          Text($r('app.string.page_transition_left'))
            .textStyle()
            .onClick(() => {
              router.pushUrl({
                url: ANIMATION_URL,
                params: { enterType: SlideEffect.Left, exitType: SlideEffect.Right }
              })
            })
          Text($r('app.string.page_transition_right'))
            .textStyle()
            .onClick(() => {
              router.pushUrl({
                url: ANIMATION_URL,
                params: { enterType: SlideEffect.Right, exitType: SlideEffect.Left }
              })
            })
          Text($r('app.string.page_transition_scale'))
            .textStyle()
            .onClick(() => {
              router.pushUrl({
                url: ANIMATION_URL,
                params: { enterType: SlideEffect.Bottom, exitType:SlideEffect.Bottom, zoom: this.zoom }
              })
            })
          Text($r('app.string.page_transition_rotate'))
            .textStyle()
            .onClick(() => {
              router.pushUrl({
                url: ANIMATION_URL,
                params: { enterType: SlideEffect.Bottom, exitType:SlideEffect.Bottom, angle: this.angle }
              })
            })
        }
        .constraintSize({ minHeight: '100%' })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}