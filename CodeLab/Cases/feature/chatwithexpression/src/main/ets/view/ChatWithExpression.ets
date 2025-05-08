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
 * 实现步骤
 * 1. 使用Grid创建表情键盘组件Emojikeyboard，选中表情图片后，将表情通过imageSpan的方式加到RichEditor输入框中。
 * 2. 封装单个表情组件为EmojiDetail，通过LongPressGesture和bindPopup属性实现表情长按时弹窗显示表情明细效果。
 * 3. 使用RichEditor组件接收表情文字输入。
 * 4. 通过RichEditorController的getSpans方法，将聊天信息中ImageSpan、Span分别push到要发送的信息的spanItems中。
 * 5. 在聊天对话框中通过LazyForEach循环加载聊天信息。
 * 6. 将聊天信息的SpanItems根据spanType在Text中分别包裹为ImageSpan跟Span。
 */

import window from '@ohos.window';
import { display, KeyboardAvoidMode } from '@kit.ArkUI';
import { inputMethod } from '@kit.IMEKit';
import { EmojiData, LastEmojiData } from '../model/Emoji';
import { EmojiKeyboard } from './EmojiKeyboard'; // 表情键盘
import { FaceGridConstants, SpanType } from '../constants/ChatConstants';
import { MessageBase, SpanItem, TextDetailData } from '../model/Message'; // 聊天内容数据
import { logger } from '../utils/Logger';
import { PlatformInfo, PlatformTypeEnum } from 'utils';
import { common } from '@kit.AbilityKit';

const TAG = 'ChatWithExpression';
const DESIGN_WIDTH: number = 640; // 设计宽度
const STROKE_WIDTH: number = 2; // strokeWidth的宽度
const LAYOUT_WEIGHT: number = 1; // layoutWeight参数

// 用户信息:昵称、头像
const USER_NAME_MYSELF: string = '张三';
const USER_NAME_OTHER: string = '李四';
const HEAD_IMAGE_MYSELF: string = 'photo1.jpg';
const HEAD_IMAGE_OTHER: string = 'photo0.jpg';

// 定义聊天界面布局信息
const HEAD_IMAGE_EDGE_PADDING: number = 5; // 头像到左右两边的padding
const HEAD_IMAGE_MSG_PADDING: number = 10; // 头像到聊天信息paddding
const MSG_TOP_BOTTOM_PADDING: number = 5; // 聊天信息上下paddding
const MSG_LEFT_RIGHT_PADDING: number = 20; // 聊天信息左右paddding
const MSG_HEADIMG_SIZE: number = 50; // 用户头像尺寸

const EMOJI_RESOURCE: string = 'resource:'; // 资源前缀
const EMOJI_SUFFIX: string = '.png'; // 资源图片后缀
const EMOJI_SRC_POS: number = 19; // 图片路径在资源中的开始位置（resource://RAWFILE/01.png截为01.png）
const EMOJI_FILENAME_LEN: number = 2; // 图片名长度

const DELAY_TIME: number = 200; // 延时时间

@Component
export struct ChatWithExpressionComponent {
  // 滚动条组件
  private scroller: Scroller = new Scroller();
  // 键盘安全高度
  @StorageLink('keyboardHeight') keyboardHeight: number = 0;
  // 发送的信息条数
  @State msgNums: number = 0;
  @State isFaceDlgOpen: boolean = false; // 表情对话框打开状态
  private isFaceClick = false; // 表情按钮是否点击
  // 组件的控制器
  controllerRich: RichEditorController = new RichEditorController();
  // 聊天信息数据
  private textDetailData = new TextDetailData();
  // 最近使用表情
  @State lastEmojiData: LastEmojiData = new LastEmojiData();
  // 聊天输入框配置
  private start: number = -1;
  private end: number = -1;
  private focusKey = 'msg_input'; // 输入框焦点
  // 聊天信息参数
  private screenWidth: number = 0; // 屏幕宽度
  private msgFontSize: number = 0; // 字体
  private msgMaxWidth: number = 0; // 聊天信息最大宽度

  aboutToAppear() {
    const displayData: display.Display = display.getDefaultDisplaySync();
    this.screenWidth = px2vp(displayData.width);

    // 根据设计稿及屏幕宽度计算fontsize及行间距
    this.msgFontSize = this.screenWidth * 100 / DESIGN_WIDTH; // 100,百分比
    logger.info(TAG, 'FontSize:' + this.msgFontSize.toString());
    // 聊天信息最大宽度
    this.msgMaxWidth =
      (this.screenWidth - HEAD_IMAGE_EDGE_PADDING * 2 - HEAD_IMAGE_MSG_PADDING * 2 - MSG_HEADIMG_SIZE * 2) *
        0.95; // 2、0.95 聊天内容最大长度设为两个聊天对象之间宽度的95%

    // 预加载三条聊天信息
    const chatMsg1: string = getContext(this)
      .resourceManager
      .getStringSync($r("app.string.chat_with_expression_msg_1"));
    let msgBase1 = new MessageBase(true, USER_NAME_MYSELF, HEAD_IMAGE_MYSELF, this.msgMaxWidth);
    this.dealImageResMsg(msgBase1, chatMsg1);
    this.textDetailData.pushData(msgBase1);

    const chatMsg2: string = getContext(this)
      .resourceManager
      .getStringSync($r("app.string.chat_with_expression_msg_2"));
    let msgBase2 = new MessageBase(false, USER_NAME_OTHER, HEAD_IMAGE_OTHER, this.msgMaxWidth);
    this.dealImageResMsg(msgBase2, chatMsg2);
    this.textDetailData.pushData(msgBase2);

    const chatMsg3: string = getContext(this)
      .resourceManager
      .getStringSync($r("app.string.chat_with_expression_msg_3"));
    let msgBase3 = new MessageBase(true, USER_NAME_MYSELF, HEAD_IMAGE_MYSELF, this.msgMaxWidth);
    this.dealImageResMsg(msgBase3, chatMsg3);
    this.textDetailData.pushData(msgBase3);
    let context = getContext(this) as common.UIAbilityContext;
    context.windowStage.getMainWindowSync().getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
    window.getLastWindow(getContext(this)).then(currentWindow => {
      // 监视软键盘的弹出和收起
      currentWindow.on('avoidAreaChange', async data => {
        if (data.type !== window.AvoidAreaType.TYPE_KEYBOARD) {
          return;
        }
        const bottomAvoidArea = currentWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
          .bottomRect
          .height;
        currentWindow.on('keyboardHeightChange', (data) => {
          if (data > 0) {
            AppStorage.setOrCreate('keyboardHeight', data - bottomAvoidArea);
          } else {
            AppStorage.setOrCreate('keyboardHeight', 0);
          }
          logger.info(TAG, 'keyboardHeight data:' + data.toString() + ',bottomAvoidArea:' +
          bottomAvoidArea.toString());
        })
        // TODO 知识点：点击表情按钮之后，等待系统软键盘关闭后再延迟刷新表情键盘，避免屏幕闪烁
        if (data.area.bottomRect.height === 0 && this.isFaceClick === true) {
          // 200毫秒之后执行
          setTimeout(async () => {
            this.isFaceDlgOpen = true;
          }, DELAY_TIME)
        }
      })
    })
  }

  aboutToDisappear(): void {
    this.isFaceDlgOpen = false;
    this.isFaceClick = false;
  }

  /**
   * 将聊天信息中的文字、表情分别解析为span、imageSpan
   * @param strMessage 聊天内容, msgBase 聊天消息结构
   */
  dealImageResMsg(msgBase: MessageBase, strMessage: string): void {
    let strContent: string = ''; // 聊天内容
    // TODO 知识点：循环解析聊天信息中的表情以及文字
    let pos: number = strMessage.indexOf(EMOJI_RESOURCE);
    while (pos !== -1) {
      // 从pos后面找到.png所在位置
      const posPng = strMessage.indexOf(EMOJI_SUFFIX, pos);
      // 获取信息表情前面部分文字并插入span
      strContent += strMessage.substring(0, pos);
      if (strContent !== '') {
        // 插入span
        const spanItem: SpanItem = new SpanItem(SpanType.TEXT, strContent, '');
        msgBase.spanItems.push(spanItem);
        strContent = '';
      }
      if (posPng !== -1) {
        // 获取表情资源
        const imgSrc: string = strMessage.substring(posPng - EMOJI_FILENAME_LEN, posPng + EMOJI_SUFFIX.length);
        // 插入imageSpan
        const spanItem: SpanItem = new SpanItem(SpanType.IMAGE, '', imgSrc);
        msgBase.spanItems.push(spanItem);
        // 信息重新初始话为表情后面部分
        strMessage = strMessage.substring(posPng + EMOJI_SUFFIX.length);
      } else {
        // 没匹配到.png，显示为文字
        strContent += EMOJI_RESOURCE;
        // 插入插入span
        const spanItem: SpanItem = new SpanItem(SpanType.TEXT, strContent, '');
        msgBase.spanItems.push(spanItem);
        // 获取剩余聊天信息
        strMessage = strMessage.substring(pos + EMOJI_RESOURCE.length);
        // 清空当前span
        strContent = '';
      }
      pos = strMessage.indexOf(EMOJI_RESOURCE);
    }
    // 插入剩余聊天内容到span
    const spanItem: SpanItem = new SpanItem(SpanType.TEXT, strMessage, '');
    msgBase.spanItems.push(spanItem);
    logger.info(TAG, 'spanItem len:' + msgBase.spanItems.length.toString());
  }

  /**
   * 发送聊天消息
   */
  async sendChatMsg(): Promise<void> {
    let msgBase = new MessageBase(true, USER_NAME_MYSELF, HEAD_IMAGE_MYSELF, this.msgMaxWidth);
    // 获取发送信息
    this.controllerRich.getSpans({
      start: this.start,
      end: this.end
    }).forEach(item => {
      if (typeof (item as RichEditorImageSpanResult)['imageStyle'] !== 'undefined') {
        // TODO 知识点：处理imagespan信息
        const imageMsg: ResourceStr | undefined = (item as RichEditorImageSpanResult).valueResourceStr;
        if (imageMsg !== undefined) {
          if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
            const spanItem: SpanItem = new SpanItem(SpanType.IMAGE, '', imageMsg.toString().substring(EMOJI_SRC_POS));
            msgBase.spanItems.push(spanItem);
          } else if (PlatformInfo.isArkUIX()) {
            let sourceIndex = imageMsg.toString().lastIndexOf(".png");
            const spanItem: SpanItem = new SpanItem(SpanType.IMAGE, '',
              imageMsg.toString().substring(sourceIndex - EMOJI_FILENAME_LEN));
            msgBase.spanItems.push(spanItem);
          }
        }
      } else {
        // TODO 知识点：处理文字span信息
        const textMsg: string = (item as RichEditorTextSpanResult).value;
        const spanItem: SpanItem = new SpanItem(SpanType.TEXT, textMsg, '');
        msgBase.spanItems.push(spanItem);
      }
    })
    logger.info(TAG, 'sendChatMsg spanItems:' + msgBase.spanItems.length.toString());
    // 发送
    if (msgBase.spanItems.length !== 0) {
      this.textDetailData.pushData(msgBase);
      this.msgNums = this.textDetailData.totalCount();
      this.controllerRich.deleteSpans();
      this.controllerRich.setCaretOffset(-1);
    }
    this.scroller.scrollEdge(Edge.Bottom);
  }

  build() {
    Column() {
      // 聊天对话框
      List({
        scroller: this.scroller,
        initialIndex: this.msgNums - 1
      }) {
        // 性能知识点：使用懒加载组件渲染数据。参考资料：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-rendering-control-lazyforeach-0000001820879609
        LazyForEach(this.textDetailData, (msg: MessageBase) => {
          ListItem() {
            if (msg.isSelf) {
              MessageItemSelfView({ msg: msg });
            } else {
              MessageItemView({ msg: msg });
            }
          }
        })
      }
      .onAreaChange(() => {
        // 控制列表滚动条到底部
        this.scroller.scrollEdge(Edge.Bottom);
      })
      .alignSelf(ItemAlign.End)
      .align(Alignment.End)
      .listDirection(Axis.Vertical)
      .divider({
        strokeWidth: STROKE_WIDTH,
        color: $r('app.color.chat_with_expression_detail_divider')
      })
      .padding({
        left: $r('app.integer.chat_with_expression_list_padding_left'),
        right: $r('app.integer.chat_with_expression_list_padding_right'),
        bottom: $r('app.integer.chat_with_expression_list_padding_bottom')
      })
      .width($r('app.string.chat_with_expression_layout_100'))
      .height($r('app.string.chat_with_expression_layout_80'))
      .layoutWeight(LAYOUT_WEIGHT)

      // 底部输入框
      Row() {
        Image($r('app.media.chatting_mode_voice'))
          .id('img_voice')
          .height($r('app.integer.chat_with_expression_opt_layout_voice_image_width'))
          .margin({
            left: $r('app.integer.chat_with_expression_chat_font_size'),
            right: $r('app.integer.chat_with_expression_chat_font_size')
          })
        // 输入框
        RichEditor({ controller: this.controllerRich })
          .height($r('app.integer.chat_with_expression_chat_input_height'))
          .layoutWeight(LAYOUT_WEIGHT)
          .borderRadius($r('app.integer.chat_with_expression_chat_border_radius'))
          .backgroundColor($r('app.string.chat_with_expression_input_background'))
          .key(this.focusKey)
          .id(this.focusKey)
          .defaultFocus(false)
          .onClick(async () => {
            this.isFaceDlgOpen = false;
            this.isFaceClick = false;
          })
        // 表情功能
        Image($r('app.media.express'))
          .height($r('app.integer.chat_with_expression_chat_express_size'))
          .width($r('app.integer.chat_with_expression_chat_express_size'))
          .margin({
            top: $r('app.integer.chat_with_expression_express_margin_top'),
            left: $r('app.integer.chat_with_expression_express_margin_left')
          })
          .id('faceBtn')
          .onClick(async () => {
            logger.info(TAG, 'face onClick keyboardHeight=' + this.keyboardHeight.toString());
            // 系统软键盘关闭状态下直接打开
            if (this.keyboardHeight <= 0) {
              if (this.isFaceDlgOpen === false) {
                this.isFaceDlgOpen = true;
              } else {
                this.isFaceDlgOpen = false;
              }
            } else {
              // 系统软键盘打开状态下先关闭软键盘再延迟打开
              this.isFaceClick = true;
              const inputMethodController = inputMethod.getController();
              inputMethodController.stopInputSession();
            }
          })
        Button($r('app.string.chat_with_expression_input_button'))
          .id('btn_sendMsg')
          .height($r('app.integer.chat_with_expression_chat_input_height'))
          .borderRadius($r('app.integer.chat_with_expression_btn_border_radius'))
          .width($r('app.integer.chat_with_expression_send_button_width'))
          .margin({
            left: $r('app.integer.chat_with_expression_chat_font_size'),
            right: $r('app.integer.chat_with_expression_chat_font_size')
          })
          .fontColor(Color.White)
          .backgroundColor(Color.Green)
          .onClick(async () => {
            this.sendChatMsg();
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .borderRadius({
        topLeft: $r('app.integer.chat_with_expression_chat_border_radius'),
        topRight: $r('app.integer.chat_with_expression_chat_border_radius')
      })
      .backgroundColor(Color.White)
      .width($r('app.string.chat_with_expression_layout_100'))
      .padding({
        top: $r('app.integer.chat_with_expression_chat_outline_padding'),
        bottom: $r('app.integer.chat_with_expression_chat_outline_padding')
      })
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])

      // TODO 知识点：通过变量控制表情键盘的显示
      if (this.isFaceDlgOpen) {
        Column() {
          // 最近使用的表情
          if (this.lastEmojiData.totalCount() > 0) {
            Text($r('app.string.chat_with_expression_last_emoji')).alignSelf(ItemAlign.Start)
              .margin($r('app.integer.chat_with_expression_chat_margin_top'))
              .id('txt_last_face')
            // 表情键盘组件
            EmojiKeyboard({
              controllerRich: this.controllerRich,
              msgFontSize: this.msgFontSize,
              lastEmojiData: this.lastEmojiData,
              emojiList: this.lastEmojiData.emojiList
            })
          }
          // 全部表情
          Text($r('app.string.chat_with_expression_all_emoji')).alignSelf(ItemAlign.Start)
            .id('txt_all_face')
            .margin($r('app.integer.chat_with_expression_chat_margin_top'))
          // 表情键盘组件
          EmojiKeyboard({
            controllerRich: this.controllerRich,
            msgFontSize: this.msgFontSize,
            lastEmojiData: this.lastEmojiData,
            emojiList: EmojiData
          })
        }
      }
    }
    .onClick(() => {
      // 点击收起键盘
      inputMethod.getController().stopInputSession();
    })
    .backgroundColor($r('app.color.chat_with_expression_message_body_background'))
    .height($r('app.string.chat_with_expression_layout_100'))
  }
}

@Component
  // 性能知识点：组件复用。参考资料：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/best-practices-long-list-0000001728333749#section36781044162218
@Reusable
  // 本人单条聊天信息
export struct MessageItemSelfView {
  @State msg: MessageBase = new MessageBase(true, '', '', 0);

  aboutToReuse(params: Record<string, MessageBase>) {
    this.msg = params.msg;
  }

  build() {
    Row() {
      // 聊天信息
      Row() {
        Text(undefined) {
          // TODO: 性能知识点：使用ForEach组件循环渲染数据
          ForEach(this.msg.spanItems, (item: SpanItem) => {
            // TODO 知识点：分别使用ImageSpan、Span渲染图片、文字信息
            if (item.spanType === SpanType.IMAGE) {
              ImageSpan($rawfile(item.imgSrc as string))
                .width($r('app.integer.chat_with_expression_chat_font_size'))
                .height($r('app.integer.chat_with_expression_chat_font_size'))
                .margin(FaceGridConstants.EMOJI_MARGIN)
                .verticalAlign(ImageSpanAlignment.BOTTOM)
                .objectFit(ImageFit.Cover)
            } else if (item.spanType === SpanType.TEXT) {
              Span(item.text)
            }
          })
        }.constraintSize({
          minHeight: $r('app.integer.chat_with_expression_chat_inline_height'),
          maxWidth: this.msg.maxWidth
        })
        .textAlign(TextAlign.Start)
      }
      .constraintSize({
        minHeight: $r('app.integer.chat_with_expression_chat_inline_height'),
        minWidth: $r('app.string.chat_with_expression_layout_10'),
        maxWidth: this.msg.maxWidth
      })
      .borderRadius($r('app.integer.chat_with_expression_chat_item_border'))
      .backgroundColor($r('app.color.chat_with_expression_detail_item_message_background'))
      .padding({
        top: MSG_TOP_BOTTOM_PADDING,
        bottom: MSG_TOP_BOTTOM_PADDING,
        left: MSG_LEFT_RIGHT_PADDING,
        right: MSG_LEFT_RIGHT_PADDING
      })

      // 用户头像
      Image($rawfile(this.msg.profilePicture))
        .objectFit(ImageFit.Fill)
        .width(MSG_HEADIMG_SIZE)
        .height(MSG_HEADIMG_SIZE)
        .borderRadius($r('app.integer.chat_with_expression_chat_border_radius'))
        .margin({
          top: 0,
          left: HEAD_IMAGE_MSG_PADDING,
          right: HEAD_IMAGE_EDGE_PADDING,
        })
    }
    .width($r('app.string.chat_with_expression_layout_100'))
    .margin({
      top: $r('app.integer.chat_with_expression_chat_margin_top'),
    })
    .justifyContent(FlexAlign.End)
  }
}

@Component
  // 性能知识点：组件复用。参考资料：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/best-practices-long-list-0000001728333749#section36781044162218
@Reusable
  // 对方单条聊天信息
export struct MessageItemView {
  @State msg: MessageBase = new MessageBase(true, '', '', 0);

  aboutToReuse(params: Record<string, MessageBase>) {
    this.msg = params.msg;
  }

  build() {
    Row() {
      // 用户头像
      Image($rawfile(this.msg.profilePicture))
        .objectFit(ImageFit.Fill)
        .width(MSG_HEADIMG_SIZE)
        .height(MSG_HEADIMG_SIZE)
        .borderRadius($r('app.integer.chat_with_expression_chat_border_radius'))
        .margin({
          top: 0,
          left: HEAD_IMAGE_EDGE_PADDING,
          right: HEAD_IMAGE_MSG_PADDING,
        })
      // 聊天信息
      Row() {
        Text(undefined) {
          // TODO: 性能知识点：使用ForEach组件循环渲染数据
          ForEach(this.msg.spanItems, (item: SpanItem) => {
            // TODO 知识点：分别使用ImageSpan、Span渲染图片、文字信息
            if (item.spanType === SpanType.IMAGE) {
              ImageSpan($rawfile(item.imgSrc as string))
                .width($r('app.integer.chat_with_expression_chat_font_size'))
                .height($r('app.integer.chat_with_expression_chat_font_size'))
                .verticalAlign(ImageSpanAlignment.BOTTOM)
                .margin(FaceGridConstants.EMOJI_MARGIN)
                .objectFit(ImageFit.Cover)
            } else if (item.spanType === SpanType.TEXT) {
              Span(item.text)
            }
          })
        }.constraintSize({
          minHeight: $r('app.integer.chat_with_expression_chat_inline_height'),
          maxWidth: this.msg.maxWidth
        })
        .textAlign(TextAlign.Start)
      }
      .constraintSize({
        minHeight: $r('app.integer.chat_with_expression_chat_inline_height'),
        minWidth: $r('app.string.chat_with_expression_layout_10'),
        maxWidth: this.msg.maxWidth
      })
      .borderRadius($r('app.integer.chat_with_expression_chat_item_border'))
      .backgroundColor(Color.White)
      .padding({
        top: MSG_TOP_BOTTOM_PADDING,
        bottom: MSG_TOP_BOTTOM_PADDING,
        left: MSG_LEFT_RIGHT_PADDING,
        right: MSG_LEFT_RIGHT_PADDING
      })
    }
    .width($r('app.string.chat_with_expression_layout_100'))
    .margin({
      top: $r('app.integer.chat_with_expression_chat_margin_top'),
    })
    .justifyContent(FlexAlign.Start)
  }
}