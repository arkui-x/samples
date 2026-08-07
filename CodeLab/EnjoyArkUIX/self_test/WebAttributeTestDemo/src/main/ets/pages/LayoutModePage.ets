import { router } from '@kit.ArkUI';

@Entry
@Component
struct LayoutModePage {
  @State selectedLayoutMode: string = 'FIT_CONTENT';
  @State blockCount: number = 14;
  @State blockCountIndex: number = 1;
  private blockCountOptions: number[] = [9, 14, 25, 37, 38];

  // 网页总高度 = 248 + 200 * n，向下取整到整百作为展示值
  private approxHeight(n: number): number {
    return Math.floor((248 + 200 * n) / 100) * 100;
  }

  build() {
    Column({ space: 16 }) {
      Text('layoutMode属性测试')
        .id('layout_mode_page_title_text')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30 })

      Button('Back')
        .id('layout_mode_page_btn_back')
        .width(200)
        .height(50)
        .margin({ top: 5 })
        .onClick(() => {
          router.back();
        })

      Scroll() {
        Column({ space: 16 }) {
          Divider()
            .id('layout_mode_page_divider_config')
            .strokeWidth(1)

          Text('请选择 layoutMode 属性值：')
            .id('layout_mode_page_label_select')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)

          Column({ space: 10 }) {
            Button('WebLayoutMode.NONE')
              .id('layout_mode_page_btn_none')
              .width('80%')
              .height(44)
              .type(this.selectedLayoutMode === 'NONE' ? ButtonType.Capsule : ButtonType.Normal)
              .backgroundColor(this.selectedLayoutMode === 'NONE' ? '#007DFF' : '#DEDEDE')
              .fontColor(this.selectedLayoutMode === 'NONE' ? '#FFFFFF' : '#182431')
              .onClick(() => { this.selectedLayoutMode = 'NONE'; })

            Button('WebLayoutMode.FIT_CONTENT')
              .id('layout_mode_page_btn_fit_content')
              .width('80%')
              .height(44)
              .type(this.selectedLayoutMode === 'FIT_CONTENT' ? ButtonType.Capsule : ButtonType.Normal)
              .backgroundColor(this.selectedLayoutMode === 'FIT_CONTENT' ? '#007DFF' : '#DEDEDE')
              .fontColor(this.selectedLayoutMode === 'FIT_CONTENT' ? '#FFFFFF' : '#182431')
              .onClick(() => { this.selectedLayoutMode = 'FIT_CONTENT'; })

            Button('不设置（unset）')
              .id('layout_mode_page_btn_unset')
              .width('80%')
              .height(44)
              .type(this.selectedLayoutMode === 'unset' ? ButtonType.Capsule : ButtonType.Normal)
              .backgroundColor(this.selectedLayoutMode === 'unset' ? '#007DFF' : '#DEDEDE')
              .fontColor(this.selectedLayoutMode === 'unset' ? '#FFFFFF' : '#182431')
              .onClick(() => { this.selectedLayoutMode = 'unset'; })

            Button('null')
              .id('layout_mode_page_btn_null')
              .width('80%')
              .height(44)
              .type(this.selectedLayoutMode === 'null' ? ButtonType.Capsule : ButtonType.Normal)
              .backgroundColor(this.selectedLayoutMode === 'null' ? '#007DFF' : '#DEDEDE')
              .fontColor(this.selectedLayoutMode === 'null' ? '#FFFFFF' : '#182431')
              .onClick(() => { this.selectedLayoutMode = 'null'; })

            Button('undefined')
              .id('layout_mode_page_btn_undefined')
              .width('80%')
              .height(44)
              .type(this.selectedLayoutMode === 'undefined' ? ButtonType.Capsule : ButtonType.Normal)
              .backgroundColor(this.selectedLayoutMode === 'undefined' ? '#007DFF' : '#DEDEDE')
              .fontColor(this.selectedLayoutMode === 'undefined' ? '#FFFFFF' : '#182431')
              .onClick(() => { this.selectedLayoutMode = 'undefined'; })
          }
          .id('layout_mode_page_button_group')
          .width('100%')
          .alignItems(HorizontalAlign.Center)

          Divider()
            .id('layout_mode_page_divider_action')
            .strokeWidth(1)

          Text(`当前选择: layoutMode = ${this.selectedLayoutMode}`)
            .id('layout_mode_page_label_current')
            .fontSize(16)
            .fontColor('#666')

          Button('显示 Web →')
            .id('layout_mode_page_btn_show_web')
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
                  pageType: 'layoutMode',
                  pageTitle: `layoutMode = ${this.selectedLayoutMode}`,
                  src: 'layoutMode.html',
                  layoutMode: this.selectedLayoutMode
                }
              }).catch((err: Error) => {
                console.error('Navigation failed:', err);
              });
            })

          Divider()
            .id('layout_mode_page_divider_advanced')
            .strokeWidth(1)
            .margin({ top: 10 })

          Text('FIT_CONTENT 专项测试：')
            .id('layout_mode_page_label_advanced')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 6 })

          Text(`目标网页高度: 约 ${this.approxHeight(this.blockCount)} px`)
            .id('layout_mode_page_label_block_count')
            .fontSize(14)
            .fontColor('#666')

          Select(this.blockCountOptions.map((n: number): SelectOption => {
            return { value: `内容高度大约为${this.approxHeight(n)}px的网页` };
          }))
            .id('layout_mode_page_select_block_count')
            .selected(this.blockCountIndex)
            .value(`内容高度大约为${this.approxHeight(this.blockCount)}px的网页`)
            .width('80%')
            .height(44)
            .onSelect((index: number) => {
              this.blockCountIndex = index;
              this.blockCount = this.blockCountOptions[index];
            })

          Button('超长内容')
            .id('layout_mode_page_btn_fit_content_long')
            .width('80%')
            .height(50)
            .type(ButtonType.Capsule)
            .backgroundColor('#34C759')
            .fontColor('#FFFFFF')
            .fontSize(16)
            .onClick(() => {
              let src: string = 'layoutModeLong25.html';
              if (this.blockCount === 9) {
                src = 'layoutModeLong9.html';
              } else if (this.blockCount === 14) {
                src = 'layoutModeLong14.html';
              } else if (this.blockCount === 25) {
                src = 'layoutModeLong25.html';
              } else if (this.blockCount === 37) {
                src = 'layoutModeLong37.html';
              } else if (this.blockCount === 38) {
                src = 'layoutModeLong38.html';
              }
              router.pushUrl({
                url: 'pages/WebDisplayPage',
                params: {
                  pageType: 'layoutMode',
                  pageTitle: `超长内容 (约${this.approxHeight(this.blockCount)}px)`,
                  src: src,
                  layoutMode: 'FIT_CONTENT_LONG',
                  blockCount: this.blockCount
                }
              }).catch((err: Error) => {
                console.error('Navigation failed:', err);
              });
            })

          Button('瀑布流 - 百度')
            .id('layout_mode_page_btn_fit_content_waterfall')
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
                  pageType: 'layoutMode',
                  pageTitle: '瀑布流 - 百度',
                  src: 'https://www.baidu.com',
                  layoutMode: 'FIT_CONTENT_WATERFALL'
                }
              }).catch((err: Error) => {
                console.error('Navigation failed:', err);
              });
            })
        }
        .id('layout_mode_page_content_column')
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .padding({ bottom: 30 })
      }
      .id('layout_mode_page_scroll')
      .layoutWeight(1)
    }
    .id('layout_mode_page_root_column')
    .height('100%')
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
  }
}
