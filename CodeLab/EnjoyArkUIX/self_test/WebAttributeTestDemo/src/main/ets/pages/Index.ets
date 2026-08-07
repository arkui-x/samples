import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Text('【ArkWeb】【渲染引擎】web组件overviewModeAccess、layoutMode、darkMode、forceDarkAccess、defaultFontSize适配跨平台')
        .id('index_title_text')
        .fontSize(28)

      Scroll() {
        Column({ space: 20 }) {

          Button('overviewModeAccess')
            .id('index_btn_overview_mode_access')
            .width('80%')
            .height(50)
            .onClick(() => {
              router.pushUrl({ url: 'pages/OverviewModePage' }).catch((err: Error) => {
                console.error('Navigation failed:', err);
              });
            })

          Button('layoutMode')
            .id('index_btn_layout_mode')
            .width('80%')
            .height(50)
            .onClick(() => {
              router.pushUrl({ url: 'pages/LayoutModePage' }).catch((err: Error) => {
                console.error('Navigation failed:', err);
              });
            })

          Button('darkMode')
            .id('index_btn_dark_mode')
            .width('80%')
            .height(50)
            .onClick(() => {
              router.pushUrl({ url: 'pages/DarkModePage' }).catch((err: Error) => {
                console.error('Navigation failed:', err);
              });
            })

          Button('forceDarkAccess')
            .id('index_btn_force_dark_access')
            .width('80%')
            .height(50)
            .onClick(() => {
              router.pushUrl({ url: 'pages/ForceDarkAccessPage' }).catch((err: Error) => {
                console.error('Navigation failed:', err);
              });
            })

          Button('defaultFontSize')
            .id('index_btn_default_font_size')
            .width('80%')
            .height(50)
            .onClick(() => {
              router.pushUrl({ url: 'pages/DefaultFontSizePage' }).catch((err: Error) => {
                console.error('Navigation failed:', err);
              });
            })

          Button('枚举值测试')
            .id('index_btn_layout_dark_mode')
            .width('80%')
            .height(50)
            .onClick(() => {
              router.pushUrl({ url: 'pages/LayoutDarkModePage' }).catch((err: Error) => {
                console.error('Navigation failed:', err);
              });
            })
        }
        .width('100%')
        .padding(20)
      }
      .id('index_scroll')
      .layoutWeight(1)
    }
    .id('index_root_column')
    .height('100%')
  }
}
