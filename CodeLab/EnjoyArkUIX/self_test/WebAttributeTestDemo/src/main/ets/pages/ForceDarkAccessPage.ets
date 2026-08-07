import { router } from '@kit.ArkUI';

@Entry
@Component
struct ForceDarkAccessPage {
  @State selectedDarkMode: string = 'Off';
  @State selectedForceDarkAccess: string = 'false';

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Text('forceDarkAccess属性测试')
          .id('force_dark_page_title_text')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30 })

        Button('Back')
          .id('force_dark_page_btn_back')
          .width(200)
          .height(50)
          .margin({ top: 5 })
          .onClick(() => {
            router.back();
          })

        Divider()
          .id('force_dark_page_divider_config')
          .strokeWidth(1)

        // darkMode selection
        Text('1. 选择 darkMode 属性值：')
          .id('force_dark_page_label_dark_mode')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)

        Column({ space: 8 }) {
          Button('WebDarkMode.Off')
            .id('force_dark_page_btn_dark_off')
            .width('80%')
            .height(40)
            .type(this.selectedDarkMode === 'Off' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedDarkMode === 'Off' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedDarkMode === 'Off' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedDarkMode = 'Off'; })

          Button('WebDarkMode.On')
            .id('force_dark_page_btn_dark_on')
            .width('80%')
            .height(40)
            .type(this.selectedDarkMode === 'On' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedDarkMode === 'On' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedDarkMode === 'On' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedDarkMode = 'On'; })

          Button('WebDarkMode.Auto')
            .id('force_dark_page_btn_dark_auto')
            .width('80%')
            .height(40)
            .type(this.selectedDarkMode === 'Auto' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedDarkMode === 'Auto' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedDarkMode === 'Auto' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedDarkMode = 'Auto'; })

          Button('不设置 darkMode')
            .id('force_dark_page_btn_dark_unset')
            .width('80%')
            .height(40)
            .type(this.selectedDarkMode === 'unset' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedDarkMode === 'unset' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedDarkMode === 'unset' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedDarkMode = 'unset'; })
        }
        .id('force_dark_page_dark_mode_group')
        .width('100%')
        .alignItems(HorizontalAlign.Center)

        Divider()
          .id('force_dark_page_divider_dark_mode')
          .strokeWidth(1)

        // forceDarkAccess selection
        Text('2. 选择 forceDarkAccess 属性值：')
          .id('force_dark_page_label_force')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)

        Column({ space: 8 }) {
          Button('false')
            .id('force_dark_page_btn_force_false')
            .width('80%')
            .height(40)
            .type(this.selectedForceDarkAccess === 'false' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedForceDarkAccess === 'false' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedForceDarkAccess === 'false' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedForceDarkAccess = 'false'; })

          Button('true')
            .id('force_dark_page_btn_force_true')
            .width('80%')
            .height(40)
            .type(this.selectedForceDarkAccess === 'true' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedForceDarkAccess === 'true' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedForceDarkAccess === 'true' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedForceDarkAccess = 'true'; })

          Button('不设置 forceDarkAccess')
            .id('force_dark_page_btn_force_unset')
            .width('80%')
            .height(40)
            .type(this.selectedForceDarkAccess === 'unset' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedForceDarkAccess === 'unset' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedForceDarkAccess === 'unset' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedForceDarkAccess = 'unset'; })

          Button('null')
            .id('force_dark_page_btn_force_null')
            .width('80%')
            .height(40)
            .type(this.selectedForceDarkAccess === 'null' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedForceDarkAccess === 'null' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedForceDarkAccess === 'null' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedForceDarkAccess = 'null'; })

          Button('undefined')
            .id('force_dark_page_btn_force_undefined')
            .width('80%')
            .height(40)
            .type(this.selectedForceDarkAccess === 'undefined' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedForceDarkAccess === 'undefined' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedForceDarkAccess === 'undefined' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedForceDarkAccess = 'undefined'; })
        }
        .id('force_dark_page_force_group')
        .width('100%')
        .alignItems(HorizontalAlign.Center)

        Divider()
          .id('force_dark_page_divider_action')
          .strokeWidth(1)

        Text(`当前选择: darkMode = ${this.selectedDarkMode}, forceDarkAccess = ${this.selectedForceDarkAccess}`)
          .id('force_dark_page_label_current')
          .fontSize(16)
          .fontColor('#666')

        Button('显示 Web →')
          .id('force_dark_page_btn_show_web')
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
                pageType: 'forceDarkAccess',
                pageTitle: `darkMode=${this.selectedDarkMode}, forceDarkAccess=${this.selectedForceDarkAccess}`,
                src: 'darkMode.html',
                darkMode: this.selectedDarkMode,
                forceDarkAccess: this.selectedForceDarkAccess
              }
            }).catch((err: Error) => {
              console.error('Navigation failed:', err);
            });
          })

        Divider()
          .id('force_dark_page_divider_advanced')
          .strokeWidth(1)
          .margin({ top: 10 })

        Text('forceDarkAccess 专项测试：')
          .id('force_dark_page_label_advanced')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ top: 6 })

        Button('未支持深色模式网页')
          .id('force_dark_page_btn_special_unsupported')
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
                pageType: 'forceDarkAccess',
                pageTitle: 'darkMode=On, forceDarkAccess=true - 未支持深色模式网页',
                src: 'darkModeNoSupport.html',
                darkMode: 'On',
                forceDarkAccess: 'true'
              }
            }).catch((err: Error) => {
              console.error('Navigation failed:', err);
            });
          })
      }
      .id('force_dark_page_content_column')
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .padding({ bottom: 30 })
    }
    .id('force_dark_page_scroll')
    .height('100%')
  }
}
