import { TitleBar } from '../../../common/TitleBar';

@Entry
@Component
struct SystemIcon {
  @State sliderValue: number = 100;
  @State centralDiameter: number = 12; // 中心圆直径
  @State lineWidth: number = 6; // 线条宽度
  @State touchDown: number = 0
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Down | PanDirection.Up })

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
            .width(80)
            .height(300)
            .trackThickness(80)
            .showTips(false)
            .trackColor($r('app.color.COLOR_80000000'))
            .blockColor($r('app.color.COLOR_FFFFFF'))
            .selectedColor($r('app.color.COLOR_FFFFFF'))
            .onChange((value: number, mode: SliderChangeMode) => {
              console.log('ontuchslider', value)
              this.sliderValue = value;
              if (this.sliderValue <= 30) {
                this.centralDiameter = 8;
                this.lineWidth = 1;
              } else {
                this.centralDiameter = 12;
                this.lineWidth = 6;
              }
            })

          Column() {
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
            .width(30)
            .height(30)
            .alignContent(Alignment.Center)
          }
          .offset({ x: 0, y: -60 })

          .gesture(
            PanGesture(this.panOption)
              .onActionStart((event?: GestureEvent) => {
                if (event) {
                  this.touchDown = event.offsetY
                }
              })
              .onActionUpdate((event?: GestureEvent) => {
                if (event) {
                  if (event.offsetX - this.touchDown > 0) {
                    animateTo({ duration: 500, curve: Curve.Friction }, () => {
                      this.sliderValue = (this.sliderValue - event.offsetY + this.touchDown) / 2
                    })
                  } else {
                    animateTo({ duration: 500, curve: Curve.Friction }, () => {
                      this.sliderValue = this.sliderValue - this.touchDown - event.offsetY
                    })
                  }
                }
              })
          )
          .onClick(() => {
            animateTo({ duration: 500, curve: Curve.Friction }, () => {
              this.sliderValue = 15
              this.centralDiameter = 8;
              this.lineWidth = 1;
            })
          })
        }
        .width(54)
        .height(130)
        .offset({ x: 34, y: -10 })
        .alignContent(Alignment.Bottom)
        .translate({ x: -50 })
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