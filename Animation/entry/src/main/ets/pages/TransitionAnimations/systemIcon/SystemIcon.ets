import { TitleBar } from '../../../common/TitleBar';

@Entry
@Component
struct SystemIcon {
  @State sliderValue: number = 100;
  @State centralDiameter: number = 12; // 中心圆直径
  @State lineWidth: number = 6; // 线条宽度

  build() {
    Column() {
      TitleBar({ title: $r('app.string.System_icon') })
      Stack() {
        // 亮度调节组件
        Stack() {
          Slider({
            value: this.sliderValue,
            style: SliderStyle.InSet,
            direction: Axis.Vertical,
            reverse: true
          })
            .id('systemIcons_slider')
            .width(54)
            .height(130)
            .trackThickness(54)
            .showTips(false)
            .trackColor($r('app.color.COLOR_80000000'))
            .blockColor($r('app.color.COLOR_FFFFFF'))
            .selectedColor($r('app.color.COLOR_FFFFFF'))
            // .blockSize({ width: 0.1, height: 0.1 })
            // .trackBorderRadius(12)
            .onChange((value: number, mode: SliderChangeMode) => {
              this.sliderValue = value;
              if (this.sliderValue <= 50) {
                this.centralDiameter = 8;
                this.lineWidth = 1;
              } else {
                this.centralDiameter = 12;
                this.lineWidth = 6;
              }
            })

          // 亮度图标
          Stack() {
            // 中心圆
            Text()
              .width(this.centralDiameter)
              .height(this.centralDiameter)
              .animation({ duration: 500, curve: "ease" })
              .borderRadius(8)
              .backgroundColor($r('app.color.COLOR_8C9BA2'))

            this.lineComponent(0)
            this.lineComponent(45)
            this.lineComponent(90)
            this.lineComponent(-45)
          }
          .width(48)
          .height(48)
          .margin({ bottom: 8 })
          .alignContent(Alignment.Center)
        }
        .width(54)
        .height(130)
        .offset({ x: 34, y: -10 })
        .alignContent(Alignment.Bottom)
        .translate({x:-50})
      }
      .width(340)
      .height(640)
    }
    .height('100%')
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.background_shallow_grey'))
  }

  // 线条组件
  @Builder
  lineComponent(angle: number) {
    Row({ space: 20 }) {
      Text()
        .width(this.lineWidth)
        .width(this.lineWidth)
        .animation({ duration: 500, curve: "ease" })
        .height(1)
        .backgroundColor($r('app.color.COLOR_8C9BA2'))
      Text()
        .width(this.lineWidth)
        .animation({ duration: 500, curve: "ease" })
        .height(1)
        .backgroundColor($r('app.color.COLOR_8C9BA2'))
    }
    .width(36)
    .height(2)
    .rotate({ angle: angle })
    .justifyContent(FlexAlign.Center)
  }
}