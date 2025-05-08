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

import libaki from 'libakiusepractice.so'; // 导入自定义AKI插件
import { FunctionDescription } from 'utils';
import { AppRouter } from 'routermodule';
import { emitter } from '@kit.BasicServicesKit';

/**
 * 本示例介绍使用AKI编写的C++函数实现跨线程调用JS函数场景。在ArkTS侧使用AKI的JSBind.bindFunction绑定
 * JS函数akiAccumulate，然后使用AKI调用C++函数AkiThreadsCallJs。在C++侧AkiThreadsCallJs中创建子
 * 线程去调用JS侧函数akiAccumulate，从而实现对变量value的加10操作，为开发者使用AKI提供参考。
 */

@AppRouter({ name: "akiusepractice/AkiView" })
@Component
export struct AkiView {
  @StorageLink('akiViewValue') akiViewValue: number = 0;
  // 描述标题
  @State title: Resource = $r('app.string.aki_use_practice_title');
  // 描述详情
  @State content: Resource = $r('app.string.aki_use_practice_content');
  private val: number = 0;

  aboutToAppear(): void {
    // 页面加载重置变量值
    this.akiViewValue = 0;
  }

  build() {
    Column() {
      // 场景描述
      FunctionDescription({ title: this.title, content: this.content })

      Text(this.akiViewValue.toString())
        .fontSize($r('app.integer.aki_use_practice_fontSize'))
        .fontWeight(FontWeight.Bold)
        .margin($r('app.integer.aki_use_practice_margin'))

      Button($r('app.string.aki_use_practice_page_button'))
        .width($r('app.string.aki_use_practice_button_width'))
        .height($r('app.integer.aki_use_practice_button_height'))
        .fontSize($r('app.integer.aki_use_practice_button_fontSize'))
        .id('aki')
        .onClick(() => {
          // TODO：知识点：使用AKI的JSBind.bindFunction绑定JavaScript全局函数。这里第一个参数"akiAccumulate"用于指定绑定的JavaScript函数名，用于Native索引。第二个参数是被绑定的JavaScript函数体。
          libaki.JSBind.bindFunction("akiAccumulate", (values: number) => {
            // 对变量value做加10操作，刷新Text组件的value值。
            values += 10;
            AppStorage.setOrCreate('akiViewValue', values);
            this.val = values;
            emitter.emit({ eventId: 0, priority: 0 }, {
              data: {
                val: this.val
              }
            });
          });
          // TODO：知识点：使用AKI调用C++全局函数AkiThreadsCallJs，并传入参数value。
          libaki.AkiThreadsCallJs(this.akiViewValue);
        })
    }
    .height($r('app.string.aki_use_practice_size'))
    .padding($r('app.string.ohos_id_card_padding_start'))
    .width($r('app.string.aki_use_practice_size'))

  }
}