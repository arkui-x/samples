import Want from '@ohos.app.ability.Want'
import hilog from '@ohos.hilog'
import common from '@ohos.app.ability.common'
import window from '@ohos.window'

@Entry
@Component
struct ViewFragmentPage {
  private controller: SearchController = new SearchController()
  @State selectTips: string = ''
  @State message: string = 'ArkUI组件区域';

  build() {
    Row() {
      Scroll() {
        Column() {
          Video({
            src: 'https://video.pearvideo.com/mp4/third/20221107/cont-1774194-10703582-201045-hd.mp4'
          })
            .width('100%')
            .height('70%')
            .objectFit(ImageFit.Contain)
            .autoPlay(false)
            .onFullscreenChange((event) => {
            })

          Text(this.message)
            .id('PlatformViewPageHelloWorld')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })

          Button("Arkui跳转ANDROID_ACTIVITY")
            .onClick(() => {
              let want: Want = {
                bundleName: 'com.example.enjoyarkuix',
                moduleName: 'platformView',
                abilityName: 'Jump',
              }
              let context = getContext(this) as common.UIAbilityContext;
              context.startAbility(want, (err, data) => {
              });

            })
            .backgroundColor(Color.Grey)
            .fontColor(Color.Black)
            .margin({ top: 100, bottom: 30 })
        }
        .width('100%')
        .padding({ left: '4%', right: '4%' })
      }
    }
    .height('100%')
    .onClick(() => {
      this.controller.stopEditing()
    })
  }
}