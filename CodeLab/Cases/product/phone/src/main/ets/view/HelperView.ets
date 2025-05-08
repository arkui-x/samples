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

import { connection } from '@kit.NetworkKit';
import { HashMap } from '@kit.ArkTS';
import { promptAction, window } from '@kit.ArkUI';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { createNWeb, getNWebEx, getNWeb, logger, PlatformInfo, PlatformTypeEnum, PreferenceManager, clearHelperWeb } from 'utils';
import { SceneModuleInfo } from 'functionalscenes';
import { ShareButton } from 'sharebutton';
import { HelperConstants } from '../constants/HelperConstants';
import { getwaterFlowData } from '../data/WaterFlowData';
import { PanPositionModel } from '../model/PanPositionModel';

const TAG: string = '[HelperView] ';

@Component
export struct HelperView {
  @Consume('pageStack') @Watch("onPageStackChange") pageStack: NavPathStack;
  @Consume homeOptionPluginButtonClicked: boolean;
  @State isShowReadMe: boolean = false;
  @State helperIconOffset: PanPositionModel = new PanPositionModel();
  @State textInfoMap: HashMap<string, ESObject> | undefined = undefined;
  @State @Watch("onHelperUrlChange") helperUrl: string = HelperConstants.HELPER_URL_HOME;
  windowSize: window.Size = { width: 0, height: 0 };
  private name: string = '';
  private currentSceneModuleInfo: SceneModuleInfo | undefined;
  private preferenceManager: PreferenceManager = PreferenceManager.getInstance();

  aboutToAppear(): void {
    this.preferenceManager.getValue<boolean>('homeOptionPluginButtonClicked').then((data: boolean | null) => {
      if (data != null) {
        this.homeOptionPluginButtonClicked = data
      }
    }).catch((err: BusinessError) => {
      logger.error('get homeOptionPluginButtonClicked Failed, err: ' + err);
    });
    this.initText();
    this.currentSceneModuleInfo = this.getModuleInfo(this.name)
    this.changeHelpUrl();
    window.getLastWindow(getContext(this), (err: BusinessError, data: window.Window) => {
      let rect: window.Rect = data.getWindowProperties().windowRect;
      this.windowSize.width = px2vp(rect.width);
      this.windowSize.height = px2vp(rect.height);
    })
  }

  aboutToDisappear(): void {
    // 页面销毁时，加载空白页面，防止主页瀑布流源码页面显示混乱
    if (PlatformInfo.getPlatform() == PlatformTypeEnum.HARMONYOS) {
      getNWeb('about://blank')
    } else if (PlatformInfo.isArkUIX()) {
      getNWebEx('about://blank', this.getUIContext());
    }
  }

  onPageStackChange(): void {
    if (this.pageStack.size()) {
      this.changeHelpUrl();
    }
  }

  onHelperUrlChange(): void {
    logger.info(TAG + 'onHelperUrlChange this.helperUrl is ' + this.helperUrl);
    if (PlatformInfo.getPlatform() == PlatformTypeEnum.HARMONYOS) {
      createNWeb(this.helperUrl, this.getUIContext());
    }
  }

  changeHelpUrl(): void {
    const size: number = this.pageStack.size();
    if (size === 0) {
      this.helperUrl = HelperConstants.IDE_PLUGIN_URL;
      return;
    }
    let moduleName: string = this.pageStack.getAllPathName()[size-1].split('/')[0];
    if (this.currentSceneModuleInfo?.category.includes('性能示例') &&
      this.currentSceneModuleInfo?.name !== '解决相机预览花屏案例') {
      this.helperUrl = HelperConstants.HELPER_URL_PROTOTYPE_PERFERMANCE.replace("{placeholder}", moduleName);
    } else {
      this.helperUrl = HelperConstants.HELPER_URL_PROTOTYPE.replace("{placeholder}", moduleName);
    }
  }

  initText() {
    if (!this.textInfoMap) {
      this.textInfoMap = new HashMap<string, ESObject>();
      this.textInfoMap.set('text', '源码网页');
      this.textInfoMap.set('fontColor', Color.Black);
      this.textInfoMap.set('backgroundColor', $r('app.color.nav_destination_title_image_background_color'));
      this.textInfoMap.set('width', 72);
    }
  }

  getModuleInfo(name: string): SceneModuleInfo | undefined {
    let waterFlowData = getwaterFlowData();
    for (let index = 0; index < waterFlowData.length; index++) {
      if (waterFlowData[index].appUri.split("/")[0] === name.split("/")[0]) {
        return waterFlowData[index];
      }
    }
    return undefined;
  }

  /*
   * 帮助功能：半模态弹窗显示对应案例README
   * */
  @Builder
  buildReadMeSheet(): void {
    Column() {
      Row() {
        Row() {
          Text(this.currentSceneModuleInfo?.name)
            .textOverflow({ overflow: TextOverflow.MARQUEE })
            .fontColor(Color.White)
            .fontWeight(700)
            .fontSize($r('app.integer.nav_destination_title_text_size'))
        }
        .layoutWeight(1)

        Row() {
          if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
            ShareButton({
              url: this.helperUrl,
              linkTitle: this.currentSceneModuleInfo?.name
            })
              .id("share_button")
              .width($r('app.integer.readme_sheet_size'))
              .height($r('app.integer.readme_sheet_size'))
              .margin($r('app.integer.readme_sheet_button_margin'))
          }

          Column() {
            Stack() {
              Column() {
              }
              .width($r('app.integer.readme_sheet_size'))
              .height($r('app.integer.readme_sheet_size'))
              .borderRadius($r('app.integer.nav_destination_title_image_border_radius'))
              .backgroundColor(Color.White)
              .opacity(0.05)

              Image($r('app.media.ic_public_cancel'))
                .fillColor(Color.White)
                .width($r('app.integer.readme_sheet_cancel_image_width'))
            }
          }
          .onClick(() => {
            this.isShowReadMe = false;
          })
          .justifyContent(FlexAlign.Center)
          .width($r('app.integer.readme_sheet_size'))
          .height($r('app.integer.readme_sheet_size'))
          .borderRadius($r('app.integer.nav_destination_title_image_border_radius'))
        }
      }
      .padding({
        bottom: $r('app.integer.readme_sheet_padding_top_bottom'),
        left: $r('app.integer.readme_sheet_padding'),
        right: $r('app.integer.readme_sheet_padding')
      })
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({
        top: $r('app.integer.readme_sheet_margin_bottom'),
        bottom: $r('app.integer.readme_sheet_margin_bottom')
      })
      .width('100%')

      NodeContainer(PlatformInfo.getPlatform() == PlatformTypeEnum.HARMONYOS ?
      getNWeb(this.helperUrl) : getNWebEx(this.helperUrl, this.getUIContext()))
        .width('100%')
        .height('100%')
        .onAppear(() => {
          this.changeHelpUrl();
        })
        .onDetach(() => {
          if (PlatformInfo.isArkUIX()) {
            clearHelperWeb();
          }
        })
    }
    .width('100%')
    .height('100%')
  }

  build() {
    if (this.homeOptionPluginButtonClicked) {
      Column() {
        Text(this.textInfoMap?.get('text'))
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.textInfoMap?.get('fontColor'))
          .textAlign(TextAlign.Center)
          .width(this.textInfoMap?.get('width'))
          .margin($r("sys.float.ohos_id_card_margin_start"))
          .offset({ x: this.helperIconOffset.currentX, y: this.helperIconOffset.currentY })
          .gesture(
            GestureGroup(
              GestureMode.Exclusive,
              TapGesture({ fingers: 1, count: 1 })
                .onAction(() => {
                  connection.hasDefaultNet().then((res: boolean) => {
                    if (res) {
                      this.isShowReadMe = !this.isShowReadMe;
                      this.homeOptionPluginButtonClicked = true;
                      this.preferenceManager.setValue<boolean>('homeOptionPluginButtonClicked', true);
                    } else {
                      promptAction.showToast({ message: $r("app.string.no_network_prompt_msg") });
                    }
                  });
                })
            )
          )
          .bindSheet($$this.isShowReadMe, this.buildReadMeSheet(), {
            detents: ["80%", SheetSize.MEDIUM, SheetSize.LARGE],
            showClose: false,
            dragBar: true,
            backgroundColor: $r("app.color.helper_bindsheet_bgc"),
            preferType: SheetType.CENTER,
            enableOutsideInteractive: false,
            // 设置半模态高度变化过程中持续更新内容
            scrollSizeMode: ScrollSizeMode.CONTINUOUS
          })
      }
      .backgroundColor(this.textInfoMap?.get('backgroundColor'))
      .borderRadius($r('app.integer.helper_border_radius'))
    } else {
      Badge({
        value: '',
        style: { badgeSize: 10, badgeColor: $r('app.color.home_option_badge_color') },
      }) {
        Column() {
          Text(this.textInfoMap?.get('text'))
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.textInfoMap?.get('fontColor'))
            .textAlign(TextAlign.Center)
            .width(this.textInfoMap?.get('width'))
            .margin($r("sys.float.ohos_id_card_margin_start"))
            .offset({ x: this.helperIconOffset.currentX, y: this.helperIconOffset.currentY })
            .gesture(
              GestureGroup(
                GestureMode.Exclusive,
                TapGesture({ fingers: 1, count: 1 })
                  .onAction(() => {
                    connection.hasDefaultNet().then((res: boolean) => {
                      if (res) {
                        this.isShowReadMe = !this.isShowReadMe;
                        if (this.helperUrl === HelperConstants.IDE_PLUGIN_URL) {
                          emitter.emit('pluginClicked');
                        }
                        this.homeOptionPluginButtonClicked = true;
                        this.preferenceManager.setValue<boolean>('homeOptionPluginButtonClicked', true);
                      } else {
                        promptAction.showToast({ message: $r("app.string.no_network_prompt_msg") });
                      }
                    });
                  })
              )
            )
            .bindSheet($$this.isShowReadMe, this.buildReadMeSheet(), {
              detents: ["80%", SheetSize.MEDIUM, SheetSize.LARGE],
              showClose: false,
              dragBar: true,
              backgroundColor: $r("app.color.helper_bindsheet_bgc"),
              preferType: SheetType.CENTER,
              enableOutsideInteractive: false,
              // 设置半模态高度变化过程中持续更新内容
              scrollSizeMode: ScrollSizeMode.CONTINUOUS
            })
        }
        .backgroundColor(this.textInfoMap?.get('backgroundColor'))
        .borderRadius($r('app.integer.helper_border_radius'))
      }
    }
  }
}