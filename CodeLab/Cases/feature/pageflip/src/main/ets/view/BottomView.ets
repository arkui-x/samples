/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { promptAction } from '@kit.ArkUI';
import { CONFIGURATION, STRINGCONFIGURATION } from '../common/Constants';
import { TextReader } from '@kit.SpeechKit';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { logger } from '../utils/Logger';

@Component
export struct BottomView {
  // TODO:知识点:@Link装饰器：父子双向同步。@Link装饰的变量与其父组件中的数据源共享相同的值。
  @Link filledName: string;
  @Link buttonClickedName: string; // 点击按钮的名称，用来判断是否已被点击。
  @Link isVisible: boolean; // 用来判断翻页方式视图是否显示。
  @Link isCommentVisible: boolean; // 用来判断评论视图是否显示。
  @Link isMenuViewVisible: boolean; // 用来判断上下菜单视图是否显示。
  @State buttonNameList: Array<string> = [STRINGCONFIGURATION.LEFTRIGHTFLIPPAGENAME, STRINGCONFIGURATION.UPDOWNFLIPPAGENAME, STRINGCONFIGURATION.COVERFLIPPAGENAME]
  @Link bgColor: string;
  @Link textSize: number;
  @State isTextReader: boolean = false;
  @State isTextSize: boolean = false;
  @State isbgColor: boolean = false;
  @Link isbgImage: boolean;
  @Link currentPageNum: number;
  // 播放文章列表
  @Prop readInfoList: TextReader.ReadInfo[] = [];
  @Prop selectedReadInfo: TextReader.ReadInfo = this.readInfoList[0];
  // 用于显示当前页的按钮状态
  @State isInit: boolean = false;

  clickAnimate(name: string) {
    animateTo({
      duration: CONFIGURATION.PAGEFLIPTOASTDURATION,
      curve: Curve.Linear,
    }, () => {
      if (this.filledName === name) {
        this.filledName = '';
        this.isCommentVisible = true;
      } else {
        promptAction.showToast({
          message: $r('app.string.pageflip_default_toast'),
          duration: CONFIGURATION.PAGEFLIPTOASTDURATION
        });
        this.filledName = name;
        this.isVisible = false;
        this.isCommentVisible = false;
      }
    })
  }

  aboutToAppear(): void {
    this.init();
  }

  // 初始化
  async init() {
    // TODO：设置朗读参数
    const readerParam: TextReader.ReaderParam = {
      isVoiceBrandVisible: true,
      businessBrandInfo: {
        panelName: STRINGCONFIGURATION.XIAOYIREADING
      }
    }
    try{
      // TODO：初始化朗读控件
      await TextReader.init(getContext(this), readerParam);
      this.isInit = true;
    } catch (err) {
      logger.error(`TextReader failed to init. Code: ${err.code}, message: ${err.message}`);
    }
  }

  // 设置事件监听
  setEventListener(){
    TextReader.on('stop', () => {
      this.isTextReader = false;
    });

    TextReader.on('stateChange', (state: TextReader.ReadState) => {
      // TODO：当前正在播放的文章播放完成
      if(state.state === CONFIGURATION.COMPLETED) {
        // 当朗读的为最后一页
        if(Number(state.id) === this.readInfoList.length) {
          this.currentPageNum = Number(state.id);
        } else {
          this.currentPageNum = Number(state.id) + 1;
        }
      }
    });

    TextReader.on('eventPanel', (pe: TextReader.PanelEvent) => {
      // TODO：点击上一条按钮
      if(pe.click === 'BPC_03') {
        this.currentPageNum = Number(pe.id);
      // TODO：点击下一条按钮
      } else if(pe.click === 'BPC_04') {
        this.currentPageNum = Number(pe.id);
      }
    });
  }

  build() {
    Column() {
      Blank()
        .backgroundColor($r('app.color.pageflip_bottom_blank_backgroundcolor'))
        .width($r('app.string.pageflip_full_size'))
        .height(CONFIGURATION.PAGEFLIPBOTTOMBLANKBEIGHT)
      Row() {
        Image($r('app.media.flippage_comments'))
          .width($r('app.string.pageflip_topview_row_image_width'))
          .height($r('app.string.pageflip_bottomview_row_text_height'))
          .objectFit(ImageFit.Contain)
          .padding({
            top: $r('app.integer.flippage_padding_small'),
            bottom: $r('app.integer.flippage_padding_small'),
            left: $r('app.integer.flippage_padding_middle'),
            right: $r('app.integer.flippage_padding_middle')
          })
        Text($r('app.string.pageflip_bottom_comment'))
          .width($r('app.string.pageflip_bottomview_row_text_width'))
          .height($r('app.string.pageflip_bottomview_row_text_height'))
      }
      .onClick(() => {
        promptAction.showToast({
          message: $r('app.string.pageflip_default_toast'),
          duration: CONFIGURATION.PAGEFLIPTOASTDURATION
        });
      })
      .visibility(this.isCommentVisible ? Visibility.Visible : Visibility.None)

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.buttonNameList, (item: string) => {
          Button(item, { type: ButtonType.Capsule })
            .backgroundColor($r('app.color.pageflip_button_backgroundcolor'))
            .fontColor(this.buttonClickedName === item ? $r('app.color.pageflip_button_click_fontcolor') : $r('app.color.pageflip_button_fontcolor'))
            .margin({ left: $r('app.integer.flippage_margin_small'),right: $r('app.integer.flippage_margin_small') })
            .borderWidth(CONFIGURATION.PAGEFLIPBORDERWIDTH)
            .onClick(() => {
              if (this.buttonClickedName !== item) {
                this.buttonClickedName = item;
                this.isMenuViewVisible = false;
                this.filledName = '';
                this.isVisible = false;
              }
            })
        }, (item: string) => item)
      }
      .margin({ top: $r('app.integer.flippage_margin_small'), bottom: $r('app.integer.flippage_margin_small') })
      .visibility(this.isVisible ? Visibility.Visible : Visibility.None)

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Button($r('app.string.pageflip_button_text_reader'), { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.pageflip_button_backgroundcolor'))
          .fontColor(this.isTextReader ? $r('app.color.pageflip_button_click_fontcolor') : $r('app.color.pageflip_button_fontcolor'))
          .margin({ left: $r('app.integer.flippage_margin_small'),right: $r('app.integer.flippage_margin_small') })
          .borderWidth(CONFIGURATION.PAGEFLIPBORDERWIDTH)
          .onClick( () => {
            this.setEventListener();
            if(!this.isTextReader) {
              // 朗读控件起播，拉起播放器面板并开始播放
              TextReader.showPanel();
              TextReader.start(this.readInfoList, this.selectedReadInfo?.id).then(() => {
                logger.info('TextReader succeeded in starting');
              }).catch((e: BusinessError) => {
                logger.error(`TextReader failed to start. Code: ${e.code}, message: ${e.message}`);
              })
            }
            else {
              // 朗读控件停止朗读，执行播放面板的关闭
              TextReader.stop().then(() => {
                logger.info(`item TextReader succeeded in stopping.`);
              }).catch((e: BusinessError) => {
                logger.error(`TextReader failed to stop. Code: ${e.code}, message: ${e.message}`);
              })
              TextReader.hidePanel();
            }
            this.isTextReader = !this.isTextReader;
            emitter.emit({ eventId: 0, priority: 0 }, {
              data: {
                isTextReader: this.isTextReader
              }
            })
            this.isMenuViewVisible = false;
            this.filledName = '';
            this.isVisible = false;
          })
          .id('textReading')
        Button($r('app.string.pageflip_button_text_size'), { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.pageflip_button_backgroundcolor'))
          .fontColor(this.isTextSize ? $r('app.color.pageflip_button_click_fontcolor') : $r('app.color.pageflip_button_fontcolor'))
          .margin({ left: $r('app.integer.flippage_margin_small'),right: $r('app.integer.flippage_margin_small') })
          .borderWidth(CONFIGURATION.PAGEFLIPBORDERWIDTH)
          .onClick(() => {
            if(this.textSize === CONFIGURATION.PAGETEXTSIZETWENTY) {
              this.textSize = CONFIGURATION.PAGETEXTSIZEFIFTEEN;
            } else {
              this.textSize = CONFIGURATION.PAGETEXTSIZETWENTY;
            }
            this.isTextSize = !this.isTextSize;
            emitter.emit({ eventId: 0, priority: 0 }, {
              data: {
                isTextSize: this.isTextSize
              }
            })
            this.isMenuViewVisible = false;
            this.filledName = '';
            this.isVisible = false;
          })
          .id('fontSize')
        Button($r('app.string.pageflip_button_text_bgcolor'), { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.pageflip_button_backgroundcolor'))
          .fontColor(this.isbgColor ? $r('app.color.pageflip_button_click_fontcolor') : $r('app.color.pageflip_button_fontcolor'))
          .margin({ left: $r('app.integer.flippage_margin_small'),right: $r('app.integer.flippage_margin_small') })
          .borderWidth(CONFIGURATION.PAGEFLIPBORDERWIDTH)
          .onClick(() => {
            if(this.bgColor === STRINGCONFIGURATION.BACKGROUNDCOLORGRAY) {
              this.bgColor = STRINGCONFIGURATION.BACKGROUNDCOLORGREEN;
            } else {
              this.bgColor = STRINGCONFIGURATION.BACKGROUNDCOLORGRAY;
            }
            this.isbgColor = !this.isbgColor;
            emitter.emit({ eventId: 0, priority: 0 }, {
              data: {
                isbgColor: this.isbgColor
              }
            })
            this.isMenuViewVisible = false;
            this.filledName = '';
            this.isVisible = false;
          })
          .id('bgColor')
      }
      .margin({ top: $r('app.integer.flippage_margin_small'), bottom: $r('app.integer.flippage_margin_small') })
      .visibility(this.isVisible ? Visibility.Visible : Visibility.None)

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Button($r('app.string.pageflip_button_text_reader_bg'), { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.pageflip_button_backgroundcolor'))
          .fontColor(this.isbgImage ? $r('app.color.pageflip_button_click_fontcolor') : $r('app.color.pageflip_button_fontcolor'))
          .margin({ left: $r('app.integer.flippage_margin_small'),right: $r('app.integer.flippage_margin_small') })
          .borderWidth(CONFIGURATION.PAGEFLIPBORDERWIDTH)
          .onClick(() => {
            this.isbgImage = !this.isbgImage;
            emitter.emit({ eventId: 0, priority: 0 }, {
              data: {
                isbgImage: this.isbgImage
              }
            })
            this.isMenuViewVisible = false;
            this.filledName = '';
            this.isVisible = false;
          })
          .id('bgImage')
      }
      .margin({ top: $r('app.integer.flippage_margin_small'), bottom: $r('app.integer.flippage_margin_small') })
      .visibility(this.isVisible ? Visibility.Visible : Visibility.None)

      Blank()
        .backgroundColor($r('app.color.pageflip_bottom_blank_backgroundcolor'))
        .width($r('app.string.pageflip_full_size'))
        .height(CONFIGURATION.PAGEFLIPBOTTOMBLANKBEIGHT)
      Row() {
        Image(this.filledName === STRINGCONFIGURATION.PAGEFLIPVIEWLIST ? $r('app.media.flippage_view_list_filled') : $r('app.media.flippage_view_list'))
          .width($r('app.string.pageflip_bottomview_row_image_width'))
          .height($r('app.string.pageflip_bottomview_row_image_height'))
          .objectFit(ImageFit.Contain)
          .padding($r('app.integer.flippage_padding_small'))
          .onClick(() => {
            this.clickAnimate(STRINGCONFIGURATION.PAGEFLIPVIEWLIST);
          })
        Image(this.filledName === STRINGCONFIGURATION.PAGEFLIPFREE ? $r('app.media.flippage_free_filled') : $r('app.media.flippage_free'))
          .width($r('app.string.pageflip_bottomview_row_image_width'))
          .height($r('app.string.pageflip_bottomview_row_image_height'))
          .objectFit(ImageFit.Contain)
          .padding($r('app.integer.flippage_padding_small'))
          .onClick(() => {
            this.clickAnimate(STRINGCONFIGURATION.PAGEFLIPFREE);
          })
        Image(this.filledName === STRINGCONFIGURATION.PAGEFLIPDISCOVER ? $r('app.media.flippage_discover_filled') : $r('app.media.flippage_discover'))
          .width($r('app.string.pageflip_bottomview_row_image_width'))
          .height($r('app.string.pageflip_bottomview_row_image_height'))
          .objectFit(ImageFit.Contain)
          .padding($r('app.integer.flippage_padding_small'))
          .onClick(() => {
            this.clickAnimate(STRINGCONFIGURATION.PAGEFLIPDISCOVER);
          })
        Image(this.filledName === STRINGCONFIGURATION.PAGEFLIPBRIGHTNESS ? $r('app.media.flippage_brightness_filled') : $r('app.media.flippage_brightness'))
          .width($r('app.string.pageflip_bottomview_row_image_width'))
          .height($r('app.string.pageflip_bottomview_row_image_height'))
          .objectFit(ImageFit.Contain)
          .padding($r('app.integer.flippage_padding_small'))
          .onClick(() => {
            this.clickAnimate(STRINGCONFIGURATION.PAGEFLIPBRIGHTNESS);
          })
        Image(this.filledName === STRINGCONFIGURATION.PAGEFLIPSETTINGS ? $r('app.media.flippage_settings_filled') : $r('app.media.flippage_settings'))
          .width($r('app.string.pageflip_bottomview_row_image_width'))
          .height($r('app.string.pageflip_bottomview_row_image_height'))
          .objectFit(ImageFit.Contain)
          .padding($r('app.integer.flippage_padding_small'))
          .onClick(() => {
            animateTo({
              duration: CONFIGURATION.PAGEFLIPTOASTDURATION,
              curve: Curve.Linear,
            }, () => {
              if (this.filledName === STRINGCONFIGURATION.PAGEFLIPSETTINGS) {
                this.filledName = '';
                this.isVisible = false;
                this.isCommentVisible = true;
              } else {
                this.filledName = STRINGCONFIGURATION.PAGEFLIPSETTINGS;
                this.isVisible = true;
                this.isCommentVisible = false;
              }
            });
          })
          .id('setting')
      }
    }
    .backgroundColor($r('app.color.pageflip_column_backgroundcolor'))
    // 扩展至所有非安全区域
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .visibility(this.isMenuViewVisible ? Visibility.Visible : Visibility.None)
  }
}