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

import web_webview from '@ohos.web.webview';
import pasteboard from '@ohos.pasteboard';
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { logger } from '../../utils/logger';
import webview from '@ohos.web.webview';
import { JSON } from '@kit.ArkTS';

/**
 * 功能描述：本示例介绍了给Webview页面中可点击元素（超链接/图片）绑定长按/鼠标右击时的自定义菜单的方案。
 *
 * 推荐场景：需要长按图片或链接元素来获取更多的操作选项，例如复制图片、使用浏览器打开链接、复制链接等‌
 *
 * 核心组件：
 * 1.WebCustomPressMenuComponent
 *
 * 实现思路：
 * 1. 添加Web组件，再加载HTML网页。
 * 2. 通过onContextMenuShow事件，获取当前元素的属性。
 * 3. 创建MenuItem组件，拉起自定义菜单，对当前元素创建动作，执行复制，打开等操作。
 */

const TAG = 'ContextMenu: ';
// 弹窗宽度的不同尺寸
const MENU_ITEM_WIDTH_LEVEL1: number = 100;
const MENU_ITEM_WIDTH_LEVEL2: number = 120;
const MENU_ITEM_HEIGHT: number = 50;
// 手指的偏移量，防止手指挡住弹窗
const FINGER_OFFSET_X: number = 20;
const FINGER_OFFSET_Y: number = 20;

@Component
export struct WebCustomPressMenuComponent {
  controller: web_webview.WebviewController = new web_webview.WebviewController();
  // web 长按弹窗相应事件
  private result: WebContextMenuResult | undefined = undefined;
  // web 长按弹窗相关弹窗
  private param: WebContextMenuParam | undefined = undefined;
  private context = getContext(this) as common.UIAbilityContext;
  private inputType: ContextMenuInputFieldType = ContextMenuInputFieldType.None;
  // 长按元素的链接
  @State linkUrl: string | undefined = undefined;
  // 是否打开弹窗的标志位
  @State showMenu: boolean = false;
  // 是否存在图片元素的标志位
  @State isExistImage: boolean = false;
  // 长按时手指位置
  private pressPosX: number = 0;
  private pressPosY: number = 0;
  // Web组件尺寸
  private webWidth: number = 0;
  private webHeight: number = 0;

  aboutToAppear() {
    // TODO: 高性能知识点: 提前初始化WebView内核
    webview.WebviewController.initializeWebEngine();
  }

  /**
   * 构建自定义菜单及触发功能接口。
   */
  @Builder
  menuBuilder() {
    //以垂直列表形式显示的菜单。
    Menu() {
      // 如果元素存在图片
      if (this.isExistImage) {
        MenuItem({
          content: $r('app.string.web_press_copy_image'),
        })
          .width(MENU_ITEM_WIDTH_LEVEL1)
          .height(MENU_ITEM_HEIGHT)
          .onClick(() => {
            this.result?.copyImage();
            this.showMenu = false;
          })
      }
      // 如果元素可剪切
      if (this.param?.getEditStateFlags() === ContextMenuEditStateFlags.CAN_CUT) {
        MenuItem({
          content: $r('app.string.web_press_cut'),
        })
          .width(MENU_ITEM_WIDTH_LEVEL1)
          .height(MENU_ITEM_HEIGHT)
          .onClick(() => {
            this.result?.cut();
            this.showMenu = false;
          })
      }
      // 如果元素可拷贝
      if (this.param?.getEditStateFlags() === ContextMenuEditStateFlags.CAN_COPY) {
        MenuItem({
          content: $r('app.string.web_press_copy'),
        })
          .width(MENU_ITEM_WIDTH_LEVEL1)
          .height(MENU_ITEM_HEIGHT)
          .onClick(() => {
            this.result?.copy();
            this.showMenu = false;
          })
      }
      // 如果元素可粘贴
      if (this.param?.getEditStateFlags() === ContextMenuEditStateFlags.CAN_PASTE) {
        MenuItem({
          content: $r('app.string.web_press_paste'),
        })
          .width(MENU_ITEM_WIDTH_LEVEL1)
          .height(MENU_ITEM_HEIGHT)
          .onClick(() => {
            this.result?.paste();
            this.showMenu = false;
          })
      }
      // 如果元素可全选
      if (this.param?.getEditStateFlags() === ContextMenuEditStateFlags.CAN_SELECT_ALL) {
        MenuItem({
          content: $r('app.string.web_press_select_all'),
        })
          .width(MENU_ITEM_WIDTH_LEVEL1)
          .height(MENU_ITEM_HEIGHT)
          .onClick(() => {
            this.result?.selectAll();
            this.showMenu = false;
          })
      }
      // 如果元素为链接
      if (this.linkUrl) {
        // 浏览器打开链接
        MenuItem({
          content: $r('app.string.web_press_open_link'),
        })
          .width(MENU_ITEM_WIDTH_LEVEL2)
          .height(MENU_ITEM_HEIGHT)
          .onClick(() => {
            const wantInfo: Want = {
              action: 'ohos.want.action.viewData',
              entities: ['entity.system.browsable'],
              uri: this.linkUrl
            };
            this.context.startAbility(wantInfo).then(() => {
              logger.info(TAG, 'startAbility succeed');
            }).catch((err: BusinessError) => {
              return;
            });
            this.showMenu = false;
          })
        // 复制链接
        MenuItem({
          content: $r('app.string.web_press_copy_link'),
        })
          .width(MENU_ITEM_WIDTH_LEVEL1)
          .height(MENU_ITEM_HEIGHT)
          .onClick(() => {
            const pasteData = pasteboard.createData('text/plain', this.linkUrl);
            pasteboard.getSystemPasteboard().setData(pasteData, (error) => {
              if (error) {
                logger.error(TAG, 'Failed to set PasteData. Cause: ' + error.message);
                return;
              }
              logger.info(TAG, 'Succeeded in setting PasteData.');
            });
            this.showMenu = false;
          })
      }
      // 判断是否输入框
      if (this.inputType !== ContextMenuInputFieldType.None) {
        MenuItem({
          content: $r('app.string.web_press_input_field'),
        })
          .width(MENU_ITEM_WIDTH_LEVEL1)
          .height(MENU_ITEM_HEIGHT)
          .onClick(() => {
            this.showMenu = false;
          })
      }
    }
  }

  build() {
    Column() {
      Web({ src: $rawfile('webCustomPressMenu.html'), controller: this.controller })
        .width('100%')
        .height('100%')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
        .onAreaChange((oldArea, newArea) => {
          // TODO: 性能关注点: onAreaChange为高频系统调用，不要进行冗余的操作
          this.webWidth = newArea.width as number;
          this.webHeight = newArea.height as number;
        })// TODO: 知识点: 长按或者鼠标右键触发该事件，当前只对图片、链接有效。
        .onContextMenuShow((event) => {
          if (event) {
            this.result = event.result;
            this.param = event.param;
            this.pressPosX = px2vp(event.param.x());
            this.pressPosY = px2vp(event.param.y());
            logger.debug(TAG, `x coord = ${this.pressPosX}, y coord = ${this.pressPosY}`);
            logger.info(TAG, "link url = " + event.param.getLinkUrl());
            this.linkUrl = event.param.getLinkUrl();
            this.inputType = event.param.getInputFieldType();
            this.isExistImage = event.param.existsImageContents();
          }
          this.showMenu = true;
          return true;
        })// TODO: 知识点: 通过bindPopup绑定自定义的弹窗。
        .bindPopup(this.showMenu,
          {
            builder: this.menuBuilder(),
            enableArrow: false,
            placement: Placement.TopLeft,
            mask: false,
            offset: this.getPopupPosition(),
            onStateChange: (e) => {
              if (!e.isVisible) {
                this.showMenu = false;
                this.result!.closeContextMenu();
              }
            }
          })
    }
    .width($r('app.string.web_press_full_size'))
    .height($r('app.string.web_press_full_size'))
  }

  /**
   * 计算弹窗相对手指和屏幕的偏移量。
   * @returns 弹窗的偏移量。
   */
  getPopupPosition(): Position {
    // 计算弹窗的宽高，用于计算偏移量
    let popupWidth: number = MENU_ITEM_WIDTH_LEVEL1;
    let popupHeight: number = 0;
    if (this.param?.existsImageContents()) {
      popupHeight += MENU_ITEM_HEIGHT;
    }
    switch (this.param?.getEditStateFlags()) {
      case ContextMenuEditStateFlags.CAN_CUT:
      case ContextMenuEditStateFlags.CAN_COPY:
      case ContextMenuEditStateFlags.CAN_PASTE:
      case ContextMenuEditStateFlags.CAN_SELECT_ALL:
        popupHeight += MENU_ITEM_HEIGHT;
      break;
    }
    if (this.linkUrl) {
      popupWidth = MENU_ITEM_WIDTH_LEVEL2 > popupWidth ? MENU_ITEM_WIDTH_LEVEL2 : popupWidth;
      popupHeight += MENU_ITEM_HEIGHT * 2;
    }
    if (this.inputType !== ContextMenuInputFieldType.None) {
      popupHeight += MENU_ITEM_HEIGHT;
    }
    logger.debug(TAG, `popup width: ${popupWidth}, height: ${popupHeight}`);

    /**
     * 弹窗默认居中，计算与手指按压的距离。然后再根据弹窗实际大小和手指按压位置，保持弹窗与手指平行，且不会被挡住（FINGER_SIZE）。
     * 如果按压位置在屏幕左上，则弹窗顶部与手指右侧平行；如果弹窗在屏幕左下，则弹窗底部与手指右侧平行。
     * 如果按压位置在屏幕右上，则弹窗顶部与手指左侧平行；如果弹窗在屏幕右下，则弹窗底部与手指左侧平行。
     */
    let offset: Position = { x: 0, y: 0 };
    if (this.pressPosX <= this.webWidth / 2) {
      offset.x = -(this.webWidth / 2 - this.pressPosX) + popupWidth / 2 + FINGER_OFFSET_X;
    } else {
      offset.x = -(this.webWidth / 2 - this.pressPosX) - popupWidth / 2 - FINGER_OFFSET_X;
    }
    if (this.pressPosY <= this.webHeight / 2) {
      offset.y = -(this.webHeight / 2 - this.pressPosY) + popupHeight / 2 + FINGER_OFFSET_Y;
    } else {
      offset.y = (this.pressPosY - this.webHeight / 2) - popupHeight / 2 - FINGER_OFFSET_Y;
    }
    logger.debug(TAG, `popup offset: ${offset.x}, ${offset.y}`);
    return offset;
  }
}