import Curves from '@ohos.curves'
import { IntroductionTitle } from '../../common/IntroductionTitle'
import { TitleBar } from '../../common/TitleBar'

const ANIMATION_TIME: number = 2000

@Extend(Text)
function textStyle(customWidth: string) {
  .height(50)
  .width(customWidth)
  .margin({ left: 12 })
  .alignSelf(ItemAlign.Start)
}

@Entry
@Component
struct InterpolationCalculation {
  @State customWidth: string = '15%'
  @State isAnimationStart: boolean = false
  private initCurve: ICurve = Curves.initCurve(Curve.EaseIn)
  private stepsCurve: ICurve = Curves.stepsCurve(9, true)
  private cubicBezierCurve: ICurve = Curves.cubicBezierCurve(0.1, 0.0, 0.1, 1.0)
  private springCurve: ICurve = Curves.springCurve(10, 1, 228, 30)

  build() {
    Column() {
      TitleBar({ title: $r('app.string.interpolation_calculation') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.interpolation_calculation_init_curve') })
          Text()
            .textStyle(this.customWidth)
            .backgroundColor($r('app.color.curve_init'))
            .animation({ duration: ANIMATION_TIME, curve: this.initCurve })

          IntroductionTitle({ introduction: $r('app.string.interpolation_calculation_steps_curve') })
          Text()
            .textStyle(this.customWidth)
            .backgroundColor($r('app.color.curve_steps'))
            .animation({ duration: ANIMATION_TIME, curve: this.stepsCurve })

          IntroductionTitle({ introduction: $r('app.string.interpolation_calculation_cubic_bezier_curve') })
          Text()
            .textStyle(this.customWidth)
            .backgroundColor($r('app.color.curve_bezier'))
            .animation({ duration: ANIMATION_TIME, curve: this.cubicBezierCurve })

          IntroductionTitle({ introduction: $r('app.string.interpolation_calculation_spring') })
          Text()
            .textStyle(this.customWidth)
            .backgroundColor($r('app.color.curve_spring'))
            .animation({ duration: ANIMATION_TIME, curve: this.springCurve })

          Button('Go!')
            .height(50)
            .fontSize(32)
            .borderRadius(24)
            .margin({ top: 20 })
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bolder)
            .onClick(() => {
              this.customWidth = this.isAnimationStart ? '15%' : '95%'
              this.isAnimationStart = !this.isAnimationStart
            })
            .id('test_goButton')
        }
        .constraintSize({ minHeight: '100%' })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}