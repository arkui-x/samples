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
import { FunctionDescription } from 'utils';
import { AppRouter } from 'routermodule';
import { display } from '@kit.ArkUI';

@AppRouter({ name: "eventpropagation/EventPropagation" })
@Component
export struct EventPropagation {
  // 初始化控制使能开关变量
  @Provide isEnabled: boolean = true;

  build() {
    Column() {
      // 场景描述组件
      FunctionDescription({
        title: $r('app.string.event_propagation'),
        content: $r('app.string.event_propagation_event_content')
      })
      Row() {
        // 阻塞事件冒泡使能开关
        Text($r('app.string.event_propagation_control_enable_toggle'))

        Toggle({ type: ToggleType.Switch, isOn: this.isEnabled })
          .selectedColor($r('app.color.event_propagation_toggle_selectedColor'))
          .switchPointColor($r('app.color.event_propagation_toggle_switchpointColor'))
          .onChange((isOn: boolean) => {
            this.isEnabled = isOn;
          })
      }.width($r('app.string.event_propagation_common_container_width'))
      .height($r('app.integer.event_propagation_enable_toggle_module_height'))
      .margin({ top: $r('app.string.ohos_id_elements_margin_vertical_l') })
      .justifyContent(FlexAlign.SpaceBetween)

      // 点击事件组件
      ClickEvent()
        .id('click_event')
      // 触摸事件组件
      TouchEvent()
        .id('touch_event')
    }.padding($r('app.string.ohos_id_card_padding_start'))
  }
}

/**
 * 场景描述：
 * enabled的值为false时，点击Button按钮，会导致父组件的点击事件触发。这时需要对Button组件包裹一层容器组件，
 并设置hitTestBehavior属性，属性值设置为HitTestMode.Block，可阻止事件的透传。(enabled：控制组件是否可交互，可交互状态下响应点击事件、触摸事件、拖拽事件、按键事件、焦点事件和鼠标事件。)
 此方案同样可以使用于自定义组件场景。
 enabled参考文档：
 https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/reference/arkui-ts/ts-universal-attributes-enable.md/
 hitTestBehavior参考文档：
 https://developer.harmonyos.com/cn/docs/documentation/doc-references-V4/ts-universal-attributes-hit-test-behavior-0000001630146313-V4
 */
@Component
struct ClickEvent {
  // 初始化控制使能开关变量
  @Consume isEnabled: boolean;
  // 父组件响应次数
  @State parentCompResponseTimes: number = 0;
  // 获取当前窗口的宽度
  private screenW: number = px2vp(display.getDefaultDisplaySync().width);
  // 当前窗口宽度>=600vp时更改相关组件高度
  private readonly DEVICESIZE: number = 600;

  build() {
    Column() {
      Text($r('app.string.event_propagation_click_event_title'))
        .width($r('app.string.event_propagation_common_container_width'))
        .textAlign(TextAlign.Start)
      Column() {
        Text($r('app.string.event_propagation_parent_component_text'))
          .margin($r('app.string.ohos_id_elements_margin_vertical_m'))
        // 父组件响应次数
        Row() {
          Text($r('app.string.event_propagation_parent_component_response_times_text'))
          Text(`${this.parentCompResponseTimes}`)
            .id('click_parent_result')
        }
        .margin({
          top: $r('app.string.ohos_id_elements_margin_vertical_m'),
          bottom: $r('app.string.ohos_id_elements_margin_vertical_m')
        })

        Column() {
          Button($r('app.string.event_propagation_child_component_response'))
            .width($r('app.integer.event_propagation_button_width_size'))
            .height($r('app.integer.event_propagation_button_height_size'))
            .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
            .enabled(false)
            .onClick(() => {
            })
        }
        /*
         TODO：知识点：在onClick事件里，需要将Button按钮包裹一层容器组件，在此容器组件通过使用hitTestBehavior来阻止事件冒泡(子组件向父组件透传onClick事件)，
          hitTestBehavior的属性值设置为HitTestMode.Block。
         */
        .hitTestBehavior(this.isEnabled ? HitTestMode.Block : HitTestMode.Default)
      }
      .width($r('app.string.event_propagation_common_container_width'))
      .height(this.screenW >= this.DEVICESIZE ? $r('app.integer.event_propagation_button_click_event_area_height_fold') : $r('app.integer.event_propagation_button_click_event_area_height'))
      .backgroundColor($r('app.color.ohos_id_color_sub_background'))
      .alignItems(HorizontalAlign.Center)
      .onClick(() => {
        // 冒泡事件发生时，该回调不会触发
        this.parentCompResponseTimes++;
      })
      .margin({ top: $r('app.string.ohos_id_elements_margin_vertical_m') })
      .borderRadius($r('app.string.ohos_id_corner_radius_default_m'))
    }.margin({ top: $r('app.string.ohos_id_elements_margin_vertical_l') })
  }
}

/**
 * 场景描述：
 * 触摸事件中，当子组件触发触摸事件的时候，父组件如果设置触摸事件的话，也会触发。
 这时需要在onTouch函数中执行event.stopPropagation()可阻止事件的透传。
 */
@Component
struct TouchEvent {
  // 初始化控制使能开关变量
  @Consume isEnabled: boolean;
  // 父组件响应次数
  @State parentCompResponseTimes: number = 0;
  // 子组件响应次数
  @State childCompResponseTimes: number = 0;
  // 获取当前窗口的宽度
  private screenW: number = px2vp(display.getDefaultDisplaySync().width);
  // 当前窗口宽度>=600vp时更改相关组件高度
  private readonly DEVICESIZE: number = 600;

  build() {
    Column() {
      Text($r('app.string.event_propagation_touch_event_title'))
        .width($r('app.string.event_propagation_common_container_width'))
        .textAlign(TextAlign.Start)
      Column() {
        Text($r('app.string.event_propagation_parent_component_text_touch'))
          .margin($r('app.string.ohos_id_elements_margin_vertical_m'))
        // 父组件响应次数
        Row() {
          Text($r('app.string.event_propagation_parent_component_response_times_text'))
          Text(`${this.parentCompResponseTimes}`)
            .id('touch_parent_result')
        }
        .margin({
          top: $r('app.string.ohos_id_elements_margin_vertical_m'),
          bottom: $r('app.string.ohos_id_elements_margin_vertical_m')
        })

        // 子组件响应次数
        Row() {
          Text($r('app.string.event_propagation_child_component_response_times_text'))
          Text(`${this.childCompResponseTimes}`)
            .id('touch_child_result')
        }.margin({ bottom: $r('app.string.ohos_id_elements_margin_vertical_m') })

        Text($r('app.string.event_propagation_child_touch_component_response'))
          .width($r('app.integer.event_propagation_button_width_size'))
          .height($r('app.integer.event_propagation_button_height_size'))
          .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .backgroundColor($r('sys.color.ohos_id_color_focused_bg'))
          .onTouch((event) => {
            if (event.type === TouchType.Down) {
              if (this.isEnabled) {
                // TODO：知识点：在onTouch事件里，通过调用event.stopPropagation()阻止事件冒泡(子组件向父组件透传Touch事件)
                event.stopPropagation();
              }
              this.childCompResponseTimes++;
            }
          })
      }
      .width($r('app.string.event_propagation_common_container_width'))
      .height(this.screenW >= this.DEVICESIZE ? $r('app.integer.event_propagation_button_click_event_area_height_fold') : $r('app.integer.event_propagation_button_click_event_area_height'))
      .margin({ top: $r('app.string.ohos_id_elements_margin_vertical_m') })
      .backgroundColor($r('app.color.ohos_id_color_sub_background'))
      .borderRadius($r('app.string.ohos_id_corner_radius_default_m'))
      .alignItems(HorizontalAlign.Center)
      .onTouch((event) => {
        if (event.type === TouchType.Down) {
          // 冒泡事件发生时，该回调不会触发
          this.parentCompResponseTimes++;
        }
      })
    }.margin({ top: $r('app.string.ohos_id_elements_margin_vertical_l') })
  }
}

