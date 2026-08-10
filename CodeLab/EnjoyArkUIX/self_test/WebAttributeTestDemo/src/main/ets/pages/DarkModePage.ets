import { router } from '@kit.ArkUI';

@Entry
@Component
struct DarkModePage {
  @State selectedDarkMode: string = 'Off';

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Text('darkMode属性测试')
          .id('dark_mode_page_title_text')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30 })

        Button('Back')
          .id('dark_mode_page_btn_back')
          .width(200)
          .height(50)
          .margin({ top: 5 })
          .onClick(() => {
            router.back();
          })

        Divider()
          .id('dark_mode_page_divider_config')
          .strokeWidth(1)

        Text('请选择 darkMode 属性值：')
          .id('dark_mode_page_label_select')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)

        Column({ space: 10 }) {
          Button('WebDarkMode.Off')
            .id('dark_mode_page_btn_off')
            .width('80%')
            .height(44)
            .type(this.selectedDarkMode === 'Off' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedDarkMode === 'Off' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedDarkMode === 'Off' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedDarkMode = 'Off'; })

          Button('WebDarkMode.On')
            .id('dark_mode_page_btn_on')
            .width('80%')
            .height(44)
            .type(this.selectedDarkMode === 'On' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedDarkMode === 'On' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedDarkMode === 'On' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedDarkMode = 'On'; })

          Button('WebDarkMode.Auto')
            .id('dark_mode_page_btn_auto')
            .width('80%')
            .height(44)
            .type(this.selectedDarkMode === 'Auto' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedDarkMode === 'Auto' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedDarkMode === 'Auto' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedDarkMode = 'Auto'; })

          Button('不设置（unset）')
            .id('dark_mode_page_btn_unset')
            .width('80%')
            .height(44)
            .type(this.selectedDarkMode === 'unset' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedDarkMode === 'unset' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedDarkMode === 'unset' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedDarkMode = 'unset'; })

          Button('null')
            .id('dark_mode_page_btn_null')
            .width('80%')
            .height(44)
            .type(this.selectedDarkMode === 'null' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedDarkMode === 'null' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedDarkMode === 'null' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedDarkMode = 'null'; })

          Button('undefined')
            .id('dark_mode_page_btn_undefined')
            .width('80%')
            .height(44)
            .type(this.selectedDarkMode === 'undefined' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedDarkMode === 'undefined' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedDarkMode === 'undefined' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedDarkMode = 'undefined'; })
        }
        .id('dark_mode_page_button_group')
        .width('100%')
        .alignItems(HorizontalAlign.Center)

        Divider()
          .id('dark_mode_page_divider_action')
          .strokeWidth(1)

        Text(`当前选择: darkMode = ${this.selectedDarkMode}`)
          .id('dark_mode_page_label_current')
          .fontSize(16)
          .fontColor('#666')

        Button('显示 Web →')
          .id('dark_mode_page_btn_show_web')
          .width('80%')
          .height(50)
          .type(ButtonType.Capsule)
          .backgroundColor('#007DFF')
          .fontColor('#FFFFFF')
          .fontSize(18)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/WebDisplayPage',
              params: {
                pageType: 'darkMode',
                pageTitle: `darkMode = ${this.selectedDarkMode}`,
                src: 'darkMode.html',
                darkMode: this.selectedDarkMode
              }
            }).catch((err: Error) => {
              console.error('Navigation failed:', err);
            });
          })

        Divider()
          .id('dark_mode_page_divider_advanced')
          .strokeWidth(1)
          .margin({ top: 10 })

        Text('WebDarkMode.On 专项测试：')
          .id('dark_mode_page_label_advanced')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ top: 6 })

        Button('未支持深色模式网页')
          .id('dark_mode_page_btn_special_unsupported')
          .width('80%')
          .height(50)
          .type(ButtonType.Capsule)
          .backgroundColor('#34C759')
          .fontColor('#FFFFFF')
          .fontSize(16)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/WebDisplayPage',
              params: {
                pageType: 'darkMode',
                pageTitle: 'WebDarkMode.On - 未支持深色模式网页',
                src: 'darkModeNoSupport.html',
                darkMode: 'On'
              }
            }).catch((err: Error) => {
              console.error('Navigation failed:', err);
            });
          })
      }
      .id('dark_mode_page_content_column')
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .padding({ bottom: 30 })
    }
    .id('dark_mode_page_scroll')
    .height('100%')
  }
}
