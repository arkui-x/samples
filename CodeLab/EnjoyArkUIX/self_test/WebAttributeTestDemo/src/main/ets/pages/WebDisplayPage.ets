import { router } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';

interface WebDisplayParams {
  pageType: string;
  pageTitle: string;
  src: string;
  darkMode?: string;
  forceDarkAccess?: string;
  fontSizeMode?: string;
  layoutMode?: string;
  overviewModeAccess?: string;
  targetHeight?: number;
  blockCount?: number;
}

@Entry
@Component
struct WebDisplayPage {
  controller: webview.WebviewController = new webview.WebviewController();
  params: WebDisplayParams = router.getParams() as WebDisplayParams;
  @State dynamicFontSize: number = 24;
  @State webComponentHeight: number = 0;

  getSrc(): Resource {
    const s: string = this.params.src;
    if (s === 'darkMode.html') {
      return $rawfile('darkMode.html');
    }
    if (s === 'darkModeNoSupport.html') {
      return $rawfile('darkModeNoSupport.html');
    }
    if (s === 'defaultFontSize.html') {
      return $rawfile('defaultFontSize.html');
    }
    if (s === 'defaultFontSizeMixed.html') {
      return $rawfile('defaultFontSizeMixed.html');
    }
    if (s === 'layoutMode.html') {
      return $rawfile('layoutMode.html');
    }
    if (s === 'layoutModeLong9.html') {
      return $rawfile('layoutModeLong9.html');
    }
    if (s === 'layoutModeLong14.html') {
      return $rawfile('layoutModeLong14.html');
    }
    if (s === 'layoutModeLong25.html') {
      return $rawfile('layoutModeLong25.html');
    }
    if (s === 'layoutModeLong37.html') {
      return $rawfile('layoutModeLong37.html');
    }
    if (s === 'layoutModeLong38.html') {
      return $rawfile('layoutModeLong38.html');
    }
    if (s === 'overviewMode.html') {
      return $rawfile('overviewMode.html');
    }
    return $rawfile('darkMode.html');
  }

  @Builder
  buildDarkModeWeb() {
    if (this.params.darkMode === 'Off') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_dark_mode_off')
        .darkMode(WebDarkMode.Off).width('100%').height('100%')
    } else if (this.params.darkMode === 'On') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_dark_mode_on')
        .darkMode(WebDarkMode.On).width('100%').height('100%')
    } else if (this.params.darkMode === 'Auto') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_dark_mode_auto')
        .darkMode(WebDarkMode.Auto).width('100%').height('100%')
    } else if (this.params.darkMode === 'null') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_dark_mode_null')
        .darkMode(null).width('100%').height('100%')
    } else if (this.params.darkMode === 'undefined') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_dark_mode_undefined')
        .darkMode(undefined).width('100%').height('100%')
    } else {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_dark_mode_unset')
        .width('100%').height('100%')
    }
  }

  @Builder
  buildForceDarkWeb() {
    if (this.params.darkMode === 'Off') {
      if (this.params.forceDarkAccess === 'false') {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_off_false')
          .darkMode(WebDarkMode.Off).forceDarkAccess(false).width('100%').height('100%')
      } else if (this.params.forceDarkAccess === 'true') {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_off_true')
          .darkMode(WebDarkMode.Off).forceDarkAccess(true).width('100%').height('100%')
      } else if (this.params.forceDarkAccess === 'null') {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_off_null')
          .darkMode(WebDarkMode.Off).forceDarkAccess(null).width('100%').height('100%')
      } else if (this.params.forceDarkAccess === 'undefined') {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_off_undefined')
          .darkMode(WebDarkMode.Off).forceDarkAccess(undefined).width('100%').height('100%')
      } else {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_off_unset')
          .darkMode(WebDarkMode.Off).width('100%').height('100%')
      }
    } else if (this.params.darkMode === 'On') {
      if (this.params.forceDarkAccess === 'false') {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_on_false')
          .darkMode(WebDarkMode.On).forceDarkAccess(false).width('100%').height('100%')
      } else if (this.params.forceDarkAccess === 'true') {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_on_true')
          .forceDarkAccess(true).darkMode(WebDarkMode.On).width('100%').height('100%')
      } else if (this.params.forceDarkAccess === 'null') {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_on_null')
          .darkMode(WebDarkMode.On).forceDarkAccess(null).width('100%').height('100%')
      } else if (this.params.forceDarkAccess === 'undefined') {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_on_undefined')
          .darkMode(WebDarkMode.On).forceDarkAccess(undefined).width('100%').height('100%')
      } else {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_on_unset')
          .darkMode(WebDarkMode.On).width('100%').height('100%')
      }
    } else if (this.params.darkMode === 'Auto') {
      if (this.params.forceDarkAccess === 'false') {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_auto_false')
          .darkMode(WebDarkMode.Auto).forceDarkAccess(false).width('100%').height('100%')
      } else if (this.params.forceDarkAccess === 'true') {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_auto_true')
          .darkMode(WebDarkMode.Auto).forceDarkAccess(true).width('100%').height('100%')
      } else if (this.params.forceDarkAccess === 'null') {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_auto_null')
          .darkMode(WebDarkMode.Auto).forceDarkAccess(null).width('100%').height('100%')
      } else if (this.params.forceDarkAccess === 'undefined') {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_auto_undefined')
          .darkMode(WebDarkMode.Auto).forceDarkAccess(undefined).width('100%').height('100%')
      } else {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_auto_unset')
          .darkMode(WebDarkMode.Auto).width('100%').height('100%')
      }
    } else {
      if (this.params.forceDarkAccess === 'false') {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_unset_false')
          .forceDarkAccess(false).width('100%').height('100%')
      } else if (this.params.forceDarkAccess === 'true') {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_unset_true')
          .forceDarkAccess(true).width('100%').height('100%')
      } else if (this.params.forceDarkAccess === 'null') {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_unset_null')
          .forceDarkAccess(null).width('100%').height('100%')
      } else if (this.params.forceDarkAccess === 'undefined') {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_unset_undefined')
          .forceDarkAccess(undefined).width('100%').height('100%')
      } else {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_force_dark_unset_unset')
          .width('100%').height('100%')
      }
    }
  }

  @Builder
  buildDefaultFontSizeWeb() {
    if (this.params.fontSizeMode === '16') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_font_size_16')
        .defaultFontSize(16).width('100%').height('100%')
    } else if (this.params.fontSizeMode === 'dynamic') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_font_size_dynamic')
        .defaultFontSize(this.dynamicFontSize).width('100%').height('100%')
    } else if (this.params.fontSizeMode === 'max') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_font_size_max')
        .defaultFontSize(2147483647).width('100%').height('100%')
    } else if (this.params.fontSizeMode === 'min') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_font_size_min')
        .defaultFontSize(-2147483648).width('100%').height('100%')
    } else if (this.params.fontSizeMode === 'over_max') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_font_size_over_max')
        .defaultFontSize(2147483648).width('100%').height('100%')
    } else if (this.params.fontSizeMode === 'under_min') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_font_size_under_min')
        .defaultFontSize(-2147483649).width('100%').height('100%')
    } else if (this.params.fontSizeMode === 'null') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_font_size_null')
        .defaultFontSize((null as number | null) as number).width('100%').height('100%')
    } else if (this.params.fontSizeMode === 'undefined') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_font_size_undefined')
        .defaultFontSize((undefined as number | undefined) as number).width('100%').height('100%')
    } else {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_font_size_unset')
        .width('100%').height('100%')
    }
  }

  @Builder
  buildLayoutModeWeb() {
    if (this.params.layoutMode === 'NONE') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_layout_mode_none')
        .layoutMode(WebLayoutMode.NONE).width('100%').height(300)
    } else if (this.params.layoutMode === 'FIT_CONTENT') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_layout_mode_fit_content')
        .nestedScroll({
          scrollForward: NestedScrollMode.PARENT_FIRST,
          scrollBackward: NestedScrollMode.PARENT_FIRST,
        })
        .layoutMode(WebLayoutMode.FIT_CONTENT).width('100%').height(300)
    } else if (this.params.layoutMode === 'null') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_layout_mode_null')
        .layoutMode(null).width('100%').height(300)
    } else if (this.params.layoutMode === 'undefined') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_layout_mode_undefined')
        .layoutMode(undefined).width('100%').height(300)
    } else if (this.params.layoutMode === 'FIT_CONTENT_LONG') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_layout_mode_fit_content_long')
        .nestedScroll({
          scrollForward: NestedScrollMode.PARENT_FIRST,
          scrollBackward: NestedScrollMode.PARENT_FIRST,
        })
        .layoutMode(WebLayoutMode.FIT_CONTENT).width('100%')
        .onAreaChange((_oldValue: Area, newValue: Area) => {
          this.webComponentHeight = Number(newValue.height);
        })
    } else if (this.params.layoutMode === 'FIT_CONTENT_WATERFALL') {
      Web({ src: 'https://www.baidu.com', controller: this.controller })
        .id('web_display_layout_mode_fit_content_waterfall')
        .nestedScroll({
          scrollForward: NestedScrollMode.PARENT_FIRST,
          scrollBackward: NestedScrollMode.PARENT_FIRST,
        })
        .layoutMode(WebLayoutMode.FIT_CONTENT).width('100%')
        .onAreaChange((_oldValue: Area, newValue: Area) => {
          this.webComponentHeight = Number(newValue.height);
        })
    } else {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_layout_mode_unset')
        .width('100%').height(300)
    }
  }

  @Builder
  buildOverviewModeWeb() {
    if (this.params.overviewModeAccess === 'false') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_overview_mode_false')
        .overviewModeAccess(false).width('100%').height('100%')
    } else if (this.params.overviewModeAccess === 'true') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_overview_mode_true')
        .overviewModeAccess(true).width('100%').height('100%')
    } else if (this.params.overviewModeAccess === 'null') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_overview_mode_null')
        .overviewModeAccess(null).width('100%').height('100%')
    } else if (this.params.overviewModeAccess === 'undefined') {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_overview_mode_undefined')
        .overviewModeAccess(undefined).width('100%').height('100%')
    } else {
      Web({ src: this.getSrc(), controller: this.controller })
        .id('web_display_overview_mode_unset')
        .width('100%').height('100%')
    }
  }

  build() {
    Column() {
      Row() {
        Button('← 返回')
          .id('web_display_btn_back')
          .fontSize(16)
          .height(44)
          .onClick(() => {
            router.back();
          })

        Text(this.params.pageTitle)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .id('web_display_title_row')
      .width('100%')
      .padding({ left: 12, right: 12, top: 8, bottom: 8 })

      Divider()
        .id('web_display_divider_title')
        .strokeWidth(1)

      if (this.params.pageType === 'darkMode') {
        this.buildDarkModeWeb()
      } else if (this.params.pageType === 'forceDarkAccess') {
        this.buildForceDarkWeb()
      } else if (this.params.pageType === 'defaultFontSize') {
        if (this.params.fontSizeMode === 'dynamic') {
          // 动态改变字体模式：显示切换按钮
          Row({ space: 12 }) {
            Button('设置字体 16')
              .id('web_display_btn_font_16')
              .fontSize(14)
              .height(40)
              .type(this.dynamicFontSize === 16 ? ButtonType.Capsule : ButtonType.Normal)
              .backgroundColor(this.dynamicFontSize === 16 ? '#007DFF' : '#DEDEDE')
              .fontColor(this.dynamicFontSize === 16 ? '#FFFFFF' : '#182431')
              .onClick(() => { this.dynamicFontSize = 16; })

            Button('设置字体 24')
              .id('web_display_btn_font_24')
              .fontSize(14)
              .height(40)
              .type(this.dynamicFontSize === 24 ? ButtonType.Capsule : ButtonType.Normal)
              .backgroundColor(this.dynamicFontSize === 24 ? '#007DFF' : '#DEDEDE')
              .fontColor(this.dynamicFontSize === 24 ? '#FFFFFF' : '#182431')
              .onClick(() => { this.dynamicFontSize = 24; })
          }
          .id('web_display_font_switch_row')
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .padding({ top: 8, bottom: 8 })

          Text(`当前字体: ${this.dynamicFontSize}`)
            .id('web_display_font_current_label')
            .fontSize(14)
            .fontColor('#666')
            .padding({ bottom: 4 })

          this.buildDefaultFontSizeWeb()
        } else {
          this.buildDefaultFontSizeWeb()
        }
      } else if (this.params.pageType === 'layoutMode') {
        if (this.params.layoutMode === 'FIT_CONTENT_LONG' || this.params.layoutMode === 'FIT_CONTENT_WATERFALL') {
          Text(`Web 组件自适应高度: ${this.webComponentHeight} px`)
            .id('web_display_layout_web_height_text')
            .fontSize(16)
            .fontColor('#007DFF')
            .padding({ top: 8, bottom: 8 })
        }
        Scroll() {
          Column() {
            this.buildLayoutModeWeb()

            Text(`这是scroll底部Text组件`)
              .id('web_display_layout_attr©_text')
              .fontSize(24)
              .fontColor('#333')
              .padding(16)
              .width('100%')
              .textAlign(TextAlign.Center)
          }
          .id('web_display_layout_content_column')
          .width('100%')
        }
        .id('web_display_layout_scroll')
        .layoutWeight(1)
        .height(9000)
      } else if (this.params.pageType === 'overviewModeAccess') {
        this.buildOverviewModeWeb()
      } else {
        Web({ src: this.getSrc(), controller: this.controller })
          .id('web_display_default')
          .width('100%').height('100%')
      }
    }
    .id('web_display_root_column')
    .width('100%').height('100%')
  }
}
