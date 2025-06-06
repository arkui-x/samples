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

/**
 * 使用napi封装arkTS组件样例
 *
 * 核心组件:
 * 1. mockDocumentViewPickerSelectJSThread
 * 2. mockDocumentViewPickerSelectPThread
 *
 * 实现步骤:
 * 1. 将封装后的ets方法注册到Native侧，并创建线程安全函数
 * 2. 将Native侧调用时传入的参数封装为一个完整的对象，并通过callJSSelect的data参数传入，通过对象包装将该对象实例封装为对应的js对象
 * 3. 通过UIContext.runScopedTask确保cpp侧调用的方法在正确的窗口内执行
 */

import {
  addUIContext,
  EVENT_ID,
  generateAbilityID,
  mockDocumentViewPickerSelectJSThread,
    mockDocumentViewPickerSelectPThread,
  registryDocumentViewPickerFn
} from '../wrapper/wrapper';
import { emitter } from '@kit.BasicServicesKit';
import { FunctionDescription } from './FunctionDescription';
import { window } from '@kit.ArkUI';
import etswrapper from 'libetswrapper.so';

/**
 * TODO：需求：
 * 在2in1多实例情况下，当突然点击失焦窗口中的按钮时，由于事件的流程原因，可能导致在错误的窗口内拉起picker：
 * 多模事件输入->窗口管理->焦点切换->on事件分发
 *               |->arkui->button事件触发
 * 时序上得不到保证
 */

registryDocumentViewPickerFn(); // napi封装ets
let abilityID: string = generateAbilityID();

@Component
export struct MockNativeCallPickerViewComponent {
  @State selectedContent: string = "";
  @State clickedBtnTitle: Resource = $r("app.string.etswrapper_mock_btn_js_info")

  async aboutToAppear(): Promise<void> {
    let windowClass: window.Window = await window.getLastWindow(getContext());
    addUIContext(abilityID, windowClass); // napi封装ets
    if (etswrapper !== undefined && etswrapper.setTopAbilityID !== undefined) {
      etswrapper.setTopAbilityID(abilityID);
    }
    // 注意：仅供UI展示使用
    emitter.on({
      eventId: EVENT_ID
    }, (eventData: emitter.EventData): void => {
      const data = eventData.data as Record<string, string>;
      this.selectedContent = "";
      this.selectedContent = data.content.replace(',', '\n');
    })
  }

  aboutToDisappear(): void {
    emitter.off(EVENT_ID);
  }

  build() {
    Column() {
      FunctionDescription({
        title: $r("app.string.etswrapper_func_desc_title"),
        content: $r("app.string.etswrapper_func_desc_content")
      })
      Button($r("app.string.etswrapper_mock_btn_js_info"))
        .margin({ top: $r("sys.float.ohos_id_card_margin_start") })
        .onClick(() => {
          mockDocumentViewPickerSelectJSThread();
          this.clickedBtnTitle = $r("app.string.etswrapper_mock_btn_js_info")
        })
      Button($r("app.string.etswrapper_mock_btn_p_info"))
        .margin({ top: $r("sys.float.ohos_id_card_margin_start") })
        .onClick(() => {
          mockDocumentViewPickerSelectPThread();
          this.clickedBtnTitle = $r("app.string.etswrapper_mock_btn_p_info")
        })
      Stack() {
        if (this.selectedContent) {
          Column() {
            Text(this.clickedBtnTitle)
            Text(this.selectedContent)
              .padding($r("sys.float.ohos_id_card_margin_start"))
              .wordBreak(WordBreak.BREAK_ALL)
              .border({ radius: $r("sys.float.ohos_id_corner_radius_default_m") })
              .backgroundColor($r("sys.color.ohos_id_color_sub_background"))
              .width($r("app.string.etswrapper_full_size"))
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ top: $r("sys.float.ohos_id_card_margin_start") })
          .width($r("app.string.etswrapper_full_size"))
        }
      }
    }
    .padding($r("sys.float.ohos_id_card_margin_start"))
    .size({
      width: $r("app.string.etswrapper_full_size"),
      height: $r("app.string.etswrapper_full_size")
    })
  }
}