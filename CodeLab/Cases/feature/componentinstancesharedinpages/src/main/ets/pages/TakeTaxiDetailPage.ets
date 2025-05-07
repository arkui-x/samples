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

import { TakeTaxiPageCommonConstants, CommonConstants } from '../model/CommonConstants';
import { logger } from 'utils';
import { display } from '@kit.ArkUI';
import promptAction from '@ohos.promptAction';

// 页面背景透明并设置事件穿透，用于显示及操作下层地图组件，绑定半模态用来显示内容
@Component
export struct TakeTaxiDetailPage {
  @State pageHeight: number = 0;
  @Consume pageStackForComponentSharedPages: NavPathStack;
  // 用于调整下层地图组件和上层内容的手势响应区域，跟scroll的currentOffset相关
  @Consume mapResponseRegionHeight: number;
  @State isShow: boolean = true;
  @State isCenter: boolean = true;
  @State curFoldStatus: display.FoldStatus = 0;
  private screenW: number = px2vp(display.getDefaultDisplaySync().width);
  private readonly DEVICESIZE: number = 600; // 依据Navigation的mode属性说明，如使用Auto，窗口宽度>=600vp时，采用Split模式显示；窗口宽度<600vp时，采用Stack模式显示。
  private callBack = async (curFoldStatus: display.FoldStatus) =>
  {
    // 同一个状态重复触发不做处理
    if (this.curFoldStatus === curFoldStatus) {
      return;
    }
    // 缓存当前折叠状态
    this.curFoldStatus = curFoldStatus;
    this.changePreferType(this.curFoldStatus);
  }

  aboutToAppear() {
    if (display.isFoldable()) {
      this.regDisplayListener();
    } else {
      if (this.screenW >= this.DEVICESIZE) {
        this.isCenter = true;
      } else {
        this.isCenter = false;
      }
    }
  }

  aboutToDisappear(): void {
    if (display.isFoldable()) {
      display.off('foldStatusChange', this.callBack);
    }
  }

  /**
   * 注册屏幕状态监听
   * @returns {void}
   */
  regDisplayListener(): void {
    this.changePreferType(display.getFoldStatus());
    display.on('foldStatusChange', this.callBack);
  }
  // 更改PreferType
  changePreferType(status: number): void {
    if (status === display.FoldStatus.FOLD_STATUS_FOLDED) {
      this.isCenter = false;
    } else {
      this.isCenter = true;
    }
  }

  @Builder
  taxiContentBuilder() {
    // 页面的内容区域
    Column() {
      Image($r("app.media.componentinstancesharedinpages_taxi_page_detail"))
        .margin({top:CommonConstants.titleTextMargin})
        .width('100%')
        .onClick(() => {
          // 调用Toast显示提示:此样式仅为案例展示
          promptAction.showToast({ message: $r("app.string.componentinstancesharedinpages_demo_toast_tips")});
        })
    }
    .width('100%')
  }

  build() {
    NavDestination() {
      // 空的容器设置为页面大小，默认透明用于显示地图组件
      Column() {
      }
      .height('100%')
      .width('100%')
      // 绑定上半模态页面，用于显示内容
      .bindSheet($$this.isShow, this.taxiContentBuilder(),
        {
          detents: TakeTaxiPageCommonConstants.sheetDetents,
          preferType: this.isCenter ? SheetType.CENTER : SheetType.POPUP,
          enableOutsideInteractive: true,
          dragBar: false,
          backgroundColor: TakeTaxiPageCommonConstants.backgroundColor,
          showClose: false,
          // 设置半模态高度变化过程中持续更新内容
          scrollSizeMode: ScrollSizeMode.CONTINUOUS,
          // 关闭半模态组件时直接返回上一级页面
          shouldDismiss: ()=>{
            this.isShow = false; // 系统在这块的处理有bug，返回前主动设置false，否则可能引入一些问题，已知：安全键盘无法弹出
            this.pageStackForComponentSharedPages.pop(false);
          }
        }
      )
    }
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
    .backgroundColor(Color.Transparent)
    .onAreaChange((oldValue, newValue) => {
      this.pageHeight = newValue.height as number;
      this.mapResponseRegionHeight = this.pageHeight;
    })
    .onShown(() => {
      this.mapResponseRegionHeight = this.pageHeight;
      logger.info('NavDestination is show, mapResponseRegionHeight is : ' + this.mapResponseRegionHeight);
    })
  }
}