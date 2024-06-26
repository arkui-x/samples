import { TitleBar } from '../../common/TitleBar';

@Entry
@Component
struct AnimationSample {
  @State widthSize: number = 160;
  @State heightSize: number = 80;
  @State rotateAngle: number = 0;
  @State rotateAngleCurve: number = 0;
  @State rotateAngleDelay: number = 0;
  @State rotateAngleCount: number = 0;
  @State rotateAngleSpeed: number = 0;
  @State rotateAnglePlayback: number = 0;
  @State rotateAngleComplete: number = 0;
  @State flag: boolean = true;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.attribute_animation') })
      Scroll() {
        Column() {
          Button($r('app.string.attribute_animation_change_size'))
            .onClick(() => {
              if (this.flag) {
                this.heightSize = 60;
              } else {
                this.heightSize = 80;
              }
              this.flag = !this.flag;
            })
            .margin(35)
            .width(this.widthSize)
            .height(this.heightSize)
            .animation({
              duration: 2000,
              curve: Curve.EaseOut,
              iterations: 1,
              playMode: PlayMode.Normal
            })

          Button($r('app.string.attribute_animation_change_rotation'))
            .onClick(() => {
              this.rotateAngle = 90;
            })
            .width(160)
            .margin(35)
            .rotate({ angle: this.rotateAngle })
            .animation({
              duration: 1200,
              curve: Curve.Friction,
              delay: 500,
              iterations: 2,
              playMode: PlayMode.Alternate,
              onFinish: () => {
                this.rotateAngle = 0;
              }
            })

          Button($r('app.string.attribute_animation_set_curve'))
            .onClick(() => {
              this.rotateAngleCurve = 90;
            })
            .width(160)
            .rotate({ angle: this.rotateAngleCurve })
            .margin(35)
            .animation({
              duration: 1200,
              curve: Curve.Sharp,
              delay: 500,
              iterations: 2,
              playMode: PlayMode.Alternate,
              onFinish: () => {
                this.rotateAngleCurve = 0;
              }
            })

          Button($r('app.string.attribute_animation_delay'))
            .onClick(() => {
              this.rotateAngleDelay = 90;
            })
            .width(160)
            .rotate({ angle: this.rotateAngleDelay })
            .margin(35)
            .animation({
              duration: 1200,
              curve: Curve.Friction,
              delay: 3000,
              iterations: 2,
              playMode: PlayMode.Alternate,
              onFinish: () => {
                this.rotateAngleDelay = 0;
              }
            })
            .id('animation_btn_delay')

          Button($r('app.string.attribute_animation_play_count'))
            .onClick(() => {
              this.rotateAngleCount = 90;
            })
            .width(160)
            .rotate({ angle: this.rotateAngleCount })
            .margin(35)
            .animation({
              duration: 1200,
              curve: Curve.Friction,
              delay: 500,
              iterations: 4,
              playMode: PlayMode.Alternate,
              onFinish: () => {
                this.rotateAngleCount = 0;
              }
            })

          Button($r('app.string.attribute_animation_play_speed'))
            .onClick(() => {
              this.rotateAngleSpeed = 90;
            })
            .width(160)
            .rotate({ angle: this.rotateAngleSpeed })
            .margin(35)
            .animation({
              duration: 1200,
              curve: Curve.Friction,
              delay: 500,
              iterations: 2,
              playMode: PlayMode.Alternate,
              tempo: 10,
              onFinish: () => {
                this.rotateAngleSpeed = 0;
              }
            })

          Button($r('app.string.attribute_animation_unlimited_playback'))
            .onClick(() => {
              this.rotateAnglePlayback = 90;
            })
            .width(160)
            .rotate({ angle: this.rotateAnglePlayback })
            .margin(35)
            .animation({
              duration: 1200,
              curve: Curve.Friction,
              delay: 500,
              iterations: -1, // -1为无限播放
              playMode: PlayMode.Alternate,
              tempo: 10
            })
        }
        .constraintSize({ minHeight: '100%' })
        .margin({ bottom: 20 })
      }
      .borderRadius(24)
      .backgroundColor(Color.White)
      .height('90%')
      .width('100%')
      .margin({ left: 12, right: 12 })
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F1F3F5')
  }
}
