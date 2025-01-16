import { TitleBar } from '../../common/TitleBar';

@Entry
@Component
struct MotionPathSample {
  @State toggle: boolean = true;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.motion_path') })
      Scroll() {
        Column() {
          Button($r('app.string.motion_path_click_me'))
            .margin(50)
            .motionPath({
              path: 'Mstart.x start.y L300 200 L300 500 Lend.x end.y',
              from: 0.0,
              to: 1.0,
              rotatable: true
            })
            .onClick(() => {
              animateTo({ duration: 4000, curve: Curve.Linear }, () => {
                this.toggle = !this.toggle; // 通过this.toggle变化组件的位置
              })
            })
            .id('motion_click')
        }
        .justifyContent(FlexAlign.Center)
        .borderRadius(24)
        .backgroundColor(Color.White)
        .height('100%')
        .width('94%')
        .margin({ left: '3%', right: '3%' })
        .alignItems(this.toggle ? HorizontalAlign.Start : HorizontalAlign.Center)
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}