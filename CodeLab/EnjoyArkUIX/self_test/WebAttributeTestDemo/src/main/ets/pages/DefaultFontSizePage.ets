import { router } from '@kit.ArkUI';

@Entry
@Component
struct DefaultFontSizePage {
  @State selectedFontSizeMode: string = '16';

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Text('defaultFontSize属性测试')
          .id('default_font_size_page_title_text')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30 })

        Button('Back')
          .id('default_font_size_page_btn_back')
          .width(200)
          .height(50)
          .margin({ top: 5 })
          .onClick(() => {
            router.back();
          })

        Divider()
          .id('default_font_size_page_divider_config')
          .strokeWidth(1)

        Text('请选择 defaultFontSize 属性值：')
          .id('default_font_size_page_label_select')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)

        Column({ space: 10 }) {
          Button('16（默认）')
            .id('default_font_size_page_btn_16')
            .width('80%')
            .height(44)
            .type(this.selectedFontSizeMode === '16' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedFontSizeMode === '16' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedFontSizeMode === '16' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedFontSizeMode = '16'; })

          Button('动态改变字体')
            .id('default_font_size_page_btn_dynamic')
            .width('80%')
            .height(44)
            .type(this.selectedFontSizeMode === 'dynamic' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedFontSizeMode === 'dynamic' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedFontSizeMode === 'dynamic' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedFontSizeMode = 'dynamic'; })

          Button('最大值 2^31-1 (2147483647)')
            .id('default_font_size_page_btn_max')
            .width('80%')
            .height(44)
            .type(this.selectedFontSizeMode === 'max' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedFontSizeMode === 'max' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedFontSizeMode === 'max' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedFontSizeMode = 'max'; })

          Button('最小值 -2^31 (-2147483648)')
            .id('default_font_size_page_btn_min')
            .width('80%')
            .height(44)
            .type(this.selectedFontSizeMode === 'min' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedFontSizeMode === 'min' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedFontSizeMode === 'min' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedFontSizeMode = 'min'; })

          Button('大于最大值 (2147483648)')
            .id('default_font_size_page_btn_over_max')
            .width('80%')
            .height(44)
            .type(this.selectedFontSizeMode === 'over_max' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedFontSizeMode === 'over_max' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedFontSizeMode === 'over_max' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedFontSizeMode = 'over_max'; })

          Button('小于最小值 (-2147483649)')
            .id('default_font_size_page_btn_under_min')
            .width('80%')
            .height(44)
            .type(this.selectedFontSizeMode === 'under_min' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedFontSizeMode === 'under_min' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedFontSizeMode === 'under_min' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedFontSizeMode = 'under_min'; })

          Button('不设置（unset）')
            .id('default_font_size_page_btn_unset')
            .width('80%')
            .height(44)
            .type(this.selectedFontSizeMode === 'unset' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedFontSizeMode === 'unset' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedFontSizeMode === 'unset' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedFontSizeMode = 'unset'; })

          Button('null')
            .id('default_font_size_page_btn_null')
            .width('80%')
            .height(44)
            .type(this.selectedFontSizeMode === 'null' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedFontSizeMode === 'null' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedFontSizeMode === 'null' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedFontSizeMode = 'null'; })

          Button('undefined')
            .id('default_font_size_page_btn_undefined')
            .width('80%')
            .height(44)
            .type(this.selectedFontSizeMode === 'undefined' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedFontSizeMode === 'undefined' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedFontSizeMode === 'undefined' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedFontSizeMode = 'undefined'; })
        }
        .id('default_font_size_page_button_group')
        .width('100%')
        .alignItems(HorizontalAlign.Center)

        Divider()
          .id('default_font_size_page_divider_action')
          .strokeWidth(1)

        Text(`当前选择: defaultFontSize = ${this.selectedFontSizeMode}`)
          .id('default_font_size_page_label_current')
          .fontSize(16)
          .fontColor('#666')

        Button('显示 Web →')
          .id('default_font_size_page_btn_show_web')
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
                pageType: 'defaultFontSize',
                pageTitle: `defaultFontSize = ${this.selectedFontSizeMode}`,
                src: 'defaultFontSize.html',
                fontSizeMode: this.selectedFontSizeMode
              }
            }).catch((err: Error) => {
              console.error('Navigation failed:', err);
            });
          })

        Divider()
          .id('default_font_size_page_divider_advanced')
          .strokeWidth(1)
          .margin({ top: 10 })

        Text('defaultFontSize 专项测试：')
          .id('default_font_size_page_label_advanced')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ top: 6 })

        Button('混合字体/字号网页')
          .id('default_font_size_page_btn_special_mixed')
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
                pageType: 'defaultFontSize',
                pageTitle: 'defaultFontSize = dynamic',
                src: 'defaultFontSizeMixed.html',
                fontSizeMode: 'dynamic'
              }
            }).catch((err: Error) => {
              console.error('Navigation failed:', err);
            });
          })
      }
      .id('default_font_size_page_content_column')
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .padding({ bottom: 30 })
    }
    .id('default_font_size_page_scroll')
    .height('100%')
  }
}
