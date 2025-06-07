import router from '@ohos.router';
import {common} from '@kit.AbilityKit'

// Page title bar
@Component
export struct TitleBar {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(40)
          .height(40)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.context.terminateSelf()
          })
        Text('PlatformView')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.font_color_black'))
          .margin({ left: 8, right: 8 })
      }
      .height(56)
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
  }
}