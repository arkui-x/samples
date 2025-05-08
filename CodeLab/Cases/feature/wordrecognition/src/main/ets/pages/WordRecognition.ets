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

import { BasicDataSource } from '../viewModel/BasicDataSource';
import { window, KeyboardAvoidMode } from '@kit.ArkUI';
import { inputMethod } from '@kit.IMEKit';
import { common } from '@kit.AbilityKit';

const STROKE_WIDTH: number = 2; // strokeWidth的宽度
const LAYOUT_WEIGHT: number = 1; // layoutWeight参数
const PHONE_NUMBER: number = 0; // 识别电话号码的枚举数
const URL: number = 1; // 识别链接的枚举数
const EMAIL: number = 2; // 识别邮箱的枚举数
const ADDRESS: number = 3; // 识别地址的枚举数
const TYPES: TextDataDetectorType[] = [PHONE_NUMBER, URL, EMAIL, ADDRESS]; // 允许识别的文本类型

/**
 * 功能描述: 本示例介绍使用text组件的enableDataDetector属性实现文本特殊文字识别。
 *
 * 推荐场景: 文本特殊文字识别场景
 *
 * 核心组件:
 * 1. enableDataDetector
 * 2. dataDetectorConfig
 *
 * 实现步骤：
 * 1. 使用text组件的enableDataDetector属性实现文本特定文字识别。
 * 2. 使用text组件的dataDetectorConfig属性设置允许识别的类型。
 */
@Component
export struct WordRecognitionComponent {
  // 键盘安全高度
  @State keyboardHeight: number = 0;
  private scrollerForLiftUp: Scroller = new Scroller();
  // 滚动条组件
  private scroller: Scroller = new Scroller();
  private textDetailData = new TextDetailData();
  // TextArea组件的控制器
  textAreaController: TextAreaController = new TextAreaController();
  // 输入的文本信息
  @State keyboardStr: string = '';
  // 发送的信息条数
  @State msgLength: number = 0;
  @StorageLink('avoidAreaBottomToModule') avoidAreaBottomToModule: number = 0;

  aboutToAppear(): void {
    // 虚拟键盘抬起时，页面的避让模式设置为RESIZE模式
    let context = getContext(this) as common.UIAbilityContext;
    context.windowStage.getMainWindowSync().getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
    window.getLastWindow(getContext(this)).then(currentWindow => {
      currentWindow.on('keyboardHeightChange', (data: number) => {
        this.keyboardHeight = px2vp(data);
      })
    })
    // 设定预设信息内容
    this.textDetailData.pushData(new MessageBase($r('app.string.recognition_text_content_one')));
    this.textDetailData.pushData(new MessageBase($r('app.string.recognition_text_content_two')));
    focusControl.requestFocus('searchInput');
  }

  build() {
    Column() {
      Text($r('app.string.word_recognition_title_content'))
        .fontSize($r('app.integer.recognition_title_font_size'))
        .fontColor($r('app.color.recognition_title_font_color'))
        .fontWeight(FontWeight.Bold)
        .width($r('app.string.recognition_layout_100'))
        .height($r('app.integer.recognition_title_height'))
        .lineHeight($r('app.integer.recognition_title_line_height'))
        .textAlign(TextAlign.Start)
        .padding({
          left: $r('app.integer.recognition_title_margin')
        })
        .backgroundColor($r('app.color.recognition_message_body_background'))
      Scroll(this.scrollerForLiftUp) {
        Column() {
          List({
            scroller: this.scroller,
            initialIndex: this.msgLength - 1
          }) {
            // 性能知识点：使用懒加载组件渲染数据。参考资料：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-rendering-control-lazyforeach-0000001820879609
            LazyForEach(this.textDetailData, (msg: MessageBase) => {
              ListItem() {
                MessageItemView({ msg: msg });
              }
            })
          }
          .cachedCount(10)
          .onAreaChange(() => {
            // 控制列表滚动条到底部
            this.scroller.scrollEdge(Edge.Bottom);
          })
          .listDirection(Axis.Vertical)
          .divider({
            strokeWidth: STROKE_WIDTH,
            color: $r('app.color.recognition_detail_divider')
          })
          .padding({
            left: $r('app.integer.recognition_list_padding_left'),
            right: $r('app.integer.recognition_list_padding_right'),
            bottom: $r('app.integer.recognition_list_padding_bottom')
          })
          .width($r('app.string.recognition_layout_100'))
          .layoutWeight(LAYOUT_WEIGHT)
        }
      }
      .scrollBar(BarState.Off)
      .layoutWeight(LAYOUT_WEIGHT)
      .backgroundColor($r('app.color.recognition_message_body_background'))

      // 底部输入框
      Column(){
        Row() {
          Image($r("app.media.recognition_chatting_mode_voice"))
            .height($r('app.integer.recognition_voice_image_height'))
            .margin({
              left: $r('app.integer.recognition_search_font_size'),
              right: $r('app.integer.recognition_search_font_size')
            })
          TextInput({ placeholder: '', text: this.keyboardStr })
            .id('searchInput')
            .height($r('app.integer.recognition_input_height'))
            .layoutWeight(LAYOUT_WEIGHT)
            .borderRadius($r('app.integer.recognition_input_border_radius'))
            .backgroundColor($r('app.string.recognition_input_background'))
            .enterKeyType(EnterKeyType.Send)
            .onChange((value: string) => {
              this.keyboardStr = value;
            })
            .defaultFocus(false)
            .onSubmit(() => {
              if (this.keyboardStr) {
                let msgBody = new MessageBase(this.keyboardStr);
                this.textDetailData.pushData(msgBody);
                this.msgLength = this.textDetailData.totalCount();
                this.keyboardStr = '';
                // 退出编辑态
                this.textAreaController.stopEditing();
              }
            })
          Button($r('app.string.recognition_input_button'))
            .height($r('app.integer.recognition_input_height'))
            .borderRadius($r('app.integer.recognition_input_border_radius'))
            .width($r('app.integer.recognition_input_button_width'))
            .margin({
              left: $r('app.integer.recognition_search_font_size'),
              right: $r('app.integer.recognition_search_font_size')
            })
            .fontColor(Color.White)
            .backgroundColor(Color.Green)
            .onClick(() => {
              if (this.keyboardStr) {
                let msgBody = new MessageBase(this.keyboardStr);
                this.textDetailData.pushData(msgBody);
                this.msgLength = this.textDetailData.totalCount();
                // 控制列表滚动条到底部
                this.scroller.scrollEdge(Edge.Bottom);
                this.keyboardStr = '';
                // 退出编辑态
                this.textAreaController.stopEditing();
              }
            })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .borderRadius({
          topLeft: $r('app.integer.recognition_search_border_radius'),
          topRight: $r('app.integer.recognition_search_border_radius')
        })
        .backgroundColor(Color.White)
        .width($r('app.string.recognition_layout_100'))
        .height($r('app.integer.recognition_outline_height'))
      }.backgroundColor($r('app.color.recognition_message_body_background'))
    }
    .onClick(() => {
      // 点击收起键盘
      inputMethod.getController().stopInputSession();
    })
    .backgroundColor(Color.White)
    .height($r('app.string.recognition_layout_100'))
    .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.BOTTOM])
  }
}

@Component
// 性能知识点：组件复用。参考资料：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/best-practices-long-list-0000001728333749#section36781044162218
@Reusable
// 对话框
export struct MessageItemView {
  @State msg: MessageBase = new MessageBase('');

  aboutToReuse(params: Record<string, MessageBase>) {
    this.msg = params.msg;
  }

  build() {
    // 聊天列表
    Row() {
      Text(this.msg.msgBody)
        .lineHeight($r('app.integer.recognition_message_text_height'))
        .constraintSize({
          minHeight: $r('app.integer.recognition_message_inline_height')
        })
        .fontSize($r('app.integer.recognition_search_font_size'))
        .fontColor($r('app.color.recognition_top_bar_font_color'))
        .backgroundColor($r('app.color.recognition_detail_item_message_background'))
        .padding({
          top: $r('app.integer.recognition_message_item_padding_top'),
          left: $r('app.integer.recognition_message_item_padding_left'),
          bottom: $r('app.integer.recognition_message_item_padding_bottom'),
          right: $r('app.integer.recognition_message_item_padding_right')
        })
        .borderRadius($r('app.integer.recognition_message_item_border'))
        // TODO: 知识点：开启文本识别。设置enableDataDetector为true，打开文本识别功能。
        .enableDataDetector(true)
        // 设置dataDetectorConfig属性，传入TextDataDetectorType类型的数组，设定需要识别的文本类型。
        .dataDetectorConfig({
          types: TYPES
        })
        // 设置copyOption属性不为none，否则文本识别功能将失效
        .copyOption(CopyOptions.InApp)
    }
    .direction(Direction.Rtl)
    .width($r('app.string.recognition_layout_100'))
    .alignItems(VerticalAlign.Top)
    .margin({
      top: $r('app.integer.recognition_message_item_margin_top')
    })
    .padding({
      left: $r('app.integer.recognition_message_item_padding'),
      right: $r('app.integer.recognition_message_item_padding')
    })
  }
}

// 聊天信息
export class MessageBase {
  msgBody: string | Resource

  constructor(msg: string | Resource) {
    this.msgBody = msg;
  }

  toString(): string {
    return this.msgBody + '  ';
  }
}

class TextDetailData extends BasicDataSource<MessageBase> {
  msgList: Array<MessageBase> = [];

  public totalCount(): number {
    return this.msgList.length;
  }

  public getData(index: number): MessageBase {
    return this.msgList[index];
  }

  public addData(index: number, data: MessageBase): void {
    this.msgList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: MessageBase): void {
    this.msgList.push(data);
    this.notifyDataAdd(this.msgList.length - 1);
  }
}
