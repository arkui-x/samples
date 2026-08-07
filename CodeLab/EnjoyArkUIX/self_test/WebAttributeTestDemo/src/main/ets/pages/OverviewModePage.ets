import { router } from '@kit.ArkUI';

@Entry
@Component
struct OverviewModePage {
  @State selectedOverviewMode: string = 'false';

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Text('overviewModeAccess属性测试')
          .id('overview_mode_page_title_text')
          .fontSize(28)

        Button('Back')
          .id('overview_mode_page_btn_back')
          .width(200)
          .height(50)
          .margin({ top: 5 })
          .onClick(() => {
            router.back();
          })

        Text('请选择 overviewModeAccess 属性值：')
          .id('overview_mode_page_label_select')
          .fontSize(18)


        Column({ space: 10 }) {
          Button('false')
            .id('overview_mode_page_btn_false')
            .width('80%')
            .height(44)
            .type(this.selectedOverviewMode === 'false' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedOverviewMode === 'false' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedOverviewMode === 'false' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedOverviewMode = 'false'; })

          Button('true')
            .id('overview_mode_page_btn_true')
            .width('80%')
            .height(44)
            .type(this.selectedOverviewMode === 'true' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedOverviewMode === 'true' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedOverviewMode === 'true' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedOverviewMode = 'true'; })

          Button('不设置（unset）')
            .id('overview_mode_page_btn_unset')
            .width('80%')
            .height(44)
            .type(this.selectedOverviewMode === 'unset' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedOverviewMode === 'unset' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedOverviewMode === 'unset' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedOverviewMode = 'unset'; })

          Button('null')
            .id('overview_mode_page_btn_null')
            .width('80%')
            .height(44)
            .type(this.selectedOverviewMode === 'null' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedOverviewMode === 'null' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedOverviewMode === 'null' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedOverviewMode = 'null'; })

          Button('undefined')
            .id('overview_mode_page_btn_undefined')
            .width('80%')
            .height(44)
            .type(this.selectedOverviewMode === 'undefined' ? ButtonType.Capsule : ButtonType.Normal)
            .backgroundColor(this.selectedOverviewMode === 'undefined' ? '#007DFF' : '#DEDEDE')
            .fontColor(this.selectedOverviewMode === 'undefined' ? '#FFFFFF' : '#182431')
            .onClick(() => { this.selectedOverviewMode = 'undefined'; })
        }
        .id('overview_mode_page_button_group')
        .width('100%')
        .alignItems(HorizontalAlign.Center)


        Text(`当前选择: overviewModeAccess = ${this.selectedOverviewMode}`)
          .id('overview_mode_page_label_current')
          .fontSize(16)
          .fontColor('#666')

        Button('显示 Web →')
          .id('overview_mode_page_btn_show_web')
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
                pageType: 'overviewModeAccess',
                pageTitle: `overviewModeAccess = ${this.selectedOverviewMode}`,
                src: 'overviewMode.html',
                overviewModeAccess: this.selectedOverviewMode
              }
            }).catch((err: Error) => {
              console.error('Navigation failed:', err);
            });
          })
      }
      .id('overview_mode_page_content_column')
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .padding({ bottom: 30 })
    }
    .id('overview_mode_page_scroll')
    .height('100%')
  }
}
