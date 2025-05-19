import { UIAbility, Want, common, wantConstant } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import router from '@ohos.router';
import window from '@ohos.window';

@Entry
@Component
struct dynamicIndex {
  private startIcon: Resource = $rawfile('setting.jpeg');
  private icon: Resource = $r('app.media.ic_camera_master_ai_leaf');
  @State src: Resource = this.icon;

  build() {
    Row() {
      Scroll() {
        Column() {
          Text("DynamicOneAbility")
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .margin(10)
          Image(this.src)
            .width(110)
            .height(110)
            .margin(15)
            .overlay('jpg', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
          Button("切换图片")
            .onClick(() => {
              this.src = this.startIcon;
            })
            .width('100%')
            .margin(10)
        }
        .width('100%')
      }
    }
    .height('100%')
  }
}