import { router } from '@kit.ArkUI';

@Entry
@Component
struct LayoutDarkModePage {
  @State layoutModeValue: string = '';
  @State darkModeValue: string = '';

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Text('layoutMode & darkMode 枚举值测试')
          .id('layout_dark_mode_page_title_text')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30 })

        Button('Back')
          .id('layout_dark_mode_page_btn_back')
          .width(200)
          .height(50)
          .margin({ top: 5 })
          .onClick(() => {
            router.back();
          })

        Divider()
          .id('layout_dark_mode_page_divider_layout')
          .strokeWidth(1)

        Row() {
          Text('layoutMode 枚举值：')
            .id('layout_dark_mode_page_label_select_layout')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
          Text(this.layoutModeValue)
            .id('layout_dark_mode_page_label_layout_value')
            .fontSize(18)
            .fontColor('#007DFF')
        }
        .id('layout_dark_mode_page_layout_result_row')

        Column({ space: 10 }) {
          Button('WebLayoutMode.NONE')
            .id('layout_dark_mode_page_btn_layout_none')
            .width('80%')
            .height(44)
            .onClick(() => {
              this.layoutModeValue = `${WebLayoutMode.NONE}`;
            })

          Button('WebLayoutMode.FIT_CONTENT')
            .id('layout_dark_mode_page_btn_layout_fit_content')
            .width('80%')
            .height(44)
            .onClick(() => {
              this.layoutModeValue = `${WebLayoutMode.FIT_CONTENT}`;
            })
        }
        .id('layout_dark_mode_page_layout_button_group')
        .width('100%')
        .alignItems(HorizontalAlign.Center)

        Divider()
          .id('layout_dark_mode_page_divider_dark')
          .strokeWidth(1)

        Row() {
          Text('darkMode 枚举值：')
            .id('layout_dark_mode_page_label_select_dark')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
          Text(this.darkModeValue)
            .id('layout_dark_mode_page_label_dark_value')
            .fontSize(18)
            .fontColor('#007DFF')
        }
        .id('layout_dark_mode_page_dark_result_row')

        Column({ space: 10 }) {
          Button('WebDarkMode.Off')
            .id('layout_dark_mode_page_btn_dark_off')
            .width('80%')
            .height(44)
            .onClick(() => {
              this.darkModeValue = `${WebDarkMode.Off}`;
            })

          Button('WebDarkMode.On')
            .id('layout_dark_mode_page_btn_dark_on')
            .width('80%')
            .height(44)
            .onClick(() => {
              this.darkModeValue = `${WebDarkMode.On}`;
            })

          Button('WebDarkMode.Auto')
            .id('layout_dark_mode_page_btn_dark_auto')
            .width('80%')
            .height(44)
            .onClick(() => {
              this.darkModeValue = `${WebDarkMode.Auto}`;
            })
        }
        .id('layout_dark_mode_page_dark_button_group')
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .id('layout_dark_mode_page_content_column')
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .padding({ bottom: 30 })
    }
    .id('layout_dark_mode_page_scroll')
    .height('100%')
  }
}
