import { debounce, TitleBar } from '../../../common/TitleBar';
@Entry
@Component
struct ComponentTransitionSample {
  @State flag: boolean = true;
  @State show: Resource = $r('app.string.component_transition_hide');
  build() {
    Column() {
      TitleBar({ title: $r('app.string.component_transition') })
      Scroll() {
        Column() {
          Row() {
            if (this.flag) {
              // Image的显示和消失配置为不同的过渡效果
              // 出现时从指定的x方向scale为0、y方向scale为1的状态变为默认的x、y方向scale都为1的状态
              // 消失时从默认的旋转角为0变为绕z轴顺时针旋转180°的状态
              Image($r('app.media.img_love'))
                .width(200)
                .height(200)
                .margin(50)
                .transition({ type: TransitionType.Insert, scale: { x: 0, y: 1.0 }, opacity: 0.7 })
                .transition({ type: TransitionType.Delete, rotate: { z: 1, angle: 180 }, opacity: 0.5 })
            }
          }
          .justifyContent(FlexAlign.Center)
          .borderRadius(24)
          .backgroundColor(Color.White)
          .height(300)
          .width('100%')
          .margin({ left: 12, right: 12 })

          Row() {
            Button(this.show)
              .width('90%')
              .margin({ top: 16 })
              .onClick(debounce(() => {
                // 点击Button控制Image的显示和消失
                if (this.flag) {
                  this.show = $r('app.string.component_transition_show');
                } else {
                  this.show = $r('app.string.component_transition_hide');
                }
                // 使用TransitionOptions指定transition时，必须配合animateTo才能产生动画
                animateTo({ duration: 1000 }, () => {
                  this.flag = !this.flag;
                })
              },800))
          }
          .justifyContent(FlexAlign.Center)
          .width('100%')
        }
        .constraintSize({ minHeight: '100%' })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}