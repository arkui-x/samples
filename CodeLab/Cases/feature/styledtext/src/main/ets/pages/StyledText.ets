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

import { CustomMessage, MyCustomSpan, MyCustomSpanType } from '../model/TextModel';
import { MessageListDataSource } from '../model/DataSource';
import { MESSAGES_DATA } from '../mock/MockData';
import { promptAction } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { TextAndSpanComponent } from '../components/TextAndSpanComponent';
import { StyledStringComponent } from '../components/StyledStringComponent';

/**
 * 本示例针对多行文字实现部分文本高亮和超链接的场景，提供了以下两种实现方案：
 *
 * 实现方案一
 *
 * 功能描述: Text组件中使用ForEach遍历自定义Span对象数组，根据Span类型生成不同样式和功能的Span组件，实现部分文本高亮和超链接。
 *
 * 核心组件:
 * 1. Text/Span/ContainerSpan 组件
 * 2. MyCustomSpanType 自定义Span类型枚举
 * 3. MyCustomSpan 自定义Span类
 *
 * 实现步骤：
 * 1. 初始化MyCustomSpan[]类型的数组spans。
 * 2. 定义点击回调函数，根据点击的文本超链接类型做相应处理。
 * 3. 导入并构建TextAndSpanComponent组件。
 *
 * 实现方案二
 *
 * 功能描述: 遍历自定义Span对象数组生成不同样式和功能的属性字符串，并将拼接后的属性字符串通过TextController控制器绑定到Text组件上，实现部分文本高亮和超链接。
 *
 * 核心组件:
 * 1. Text 组件
 * 2. MyCustomSpanType 自定义Span类型枚举
 * 3. MyCustomSpan 自定义Span类
 * 4. MutableStyledString 继承于StyledString的属性字符串类，用于构建属性字符串和为指定范围内容设置指定类型样式。
 * 5. TextController Text组件控制器，用于绑定或更新属性字符串。
 *
 * 实现步骤：
 * 1. 初始化MyCustomSpan[]类型的数组spans。
 * 2. 初始化视频链接图标的pixelMap。
 * 2. 定义点击回调函数，根据点击的文本超链接类型做相应处理。
 * 3. 导入并构建StyledStringComponent组件。
 */

const CACHED_COUNT: number = 0; // 消息列表懒加载数量
const LAYOUT_WEIGHT: number = 1; // 组件自动分配剩余空间
const STROKE_WIDTH: number = 2; // tab下划线线宽

/**
 * tab标签类
 */
class TabData {
  id: number; // 标签的唯一标识符
  name: string | Resource; // 标签的名称，可以是字符串或资源对象

  constructor(id: number, name: string | Resource) {
    this.id = id;
    this.name = name;
  }
}

@Component
export struct StyledTextMainPageComponent {
  @State currentIndex: number = 0; // 当前tab索引
  private imagePixelMap: image.PixelMap | undefined = undefined; // 链接图标的PixelMap值
  private mockMessages: MessageListDataSource = new MessageListDataSource(); // 消息列表数据
  private controller: TabsController = new TabsController();
  // tab标签列表
  tabData: TabData[] = [
    new TabData(0, $r('app.string.styled_text_tab_bar_one')),
    new TabData(1, $r('app.string.styled_text_tab_bar_two'))
  ];

  async aboutToAppear(): Promise<void> {
    // 获取视频链接图标的PixelMap
    await this.getPixelMapFromMedia($r('app.media.styled_text_ic_public_video'));
    // 初始化数据
    this.loadData();
  }

  /**
   * 从指定的媒体资源中获取PixelMap
   *
   * @param {Resource} resource - 要获取图像的媒体资源，包含资源的 bundle 名称、模块名称和 ID。
   */
  private async getPixelMapFromMedia(resource: Resource) {
    let unit8Array = await getContext(this).resourceManager.getMediaContent({
      bundleName: resource.bundleName,
      moduleName: resource.moduleName,
      id: resource.id
    });
    let imageSource = image.createImageSource(unit8Array.buffer.slice(0, unit8Array.buffer.byteLength));
    this.imagePixelMap = await imageSource.createPixelMap({
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888
    });
  }

  /**
   * 加载数据
   */
  loadData() {
    let totalCount: number = this.mockMessages.totalCount();
    MESSAGES_DATA.forEach((item: CustomMessage, index: number) => {
      this.mockMessages.pushData(new CustomMessage(totalCount + index, item.profile, item.userName, item.subTitle,
        item.spans, item.media));
    })
  }

  // 顶部tab
  @Builder
  tabBuilder(index: number, name: string | Resource) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? $r('app.color.styled_text_selected_tab_name') :
        $r('app.color.styled_text_tab_name'))
        .font({
          weight: this.currentIndex === index ? FontWeight.Bold : FontWeight.Regular
        })
        .lineHeight($r('app.integer.styled_text_line_height'))
        .margin({
          top: $r('app.integer.styled_text_tab_bar_margin_top'),
          bottom: $r('app.integer.styled_text_tab_bar_margin_bottom')
        })
      Divider()
        .strokeWidth(STROKE_WIDTH)
        .color($r('app.color.styled_text_selected_tab_name'))
        .visibility(this.currentIndex === index ? Visibility.Visible : Visibility.Hidden)
    }
    .width($r('app.string.styled_text_layout_full_size'))
    .onClick(() => {
      this.currentIndex = index;
      this.controller.changeIndex(index);
    })
  }

  build() {
    Tabs({
      barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller
    }) {
      ForEach(this.tabData, (item: TabData, index: number) => {
        TabContent() {
          List() {
            /**
             * 性能知识点：列表中数据较多且不确定的情况下，使用LazyForEach进行数据循环渲染。
             * 当组件滑出可视区域外时，框架会进行组件销毁回收以降低内存占用。
             * 文档参考链接：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-rendering-control-lazyforeach-V5
             */
            LazyForEach(this.mockMessages, (messageItem: CustomMessage, index: number) => {
              ListItem() {
                MessageItem({
                  currentIndex: this.currentIndex,
                  messageItem: messageItem,
                  imagePixelMap: this.imagePixelMap
                })
                  .id(this.currentIndex === 0 ? `textAndSpanItem${index}` : `styledStringItem${index}`)
              }
            }, (messageItem: CustomMessage, index: number) => {
              return messageItem.id.toString();
            })
          }
          .divider({
            strokeWidth: $r('app.integer.styled_text_list_divider_width'),
            color: $r('app.color.styled_text_list_divider_color'),
            startMargin: $r('app.string.styled_text_card_margin_start'),
            endMargin: $r('app.string.styled_text_card_margin_start')
          })
          .cachedCount(CACHED_COUNT)
          .width($r('app.string.styled_text_layout_full_size'))
          .height($r('app.string.styled_text_layout_full_size'))
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
          .onReachEnd(() => {
            this.loadData();
          })
        }
        .tabBar(this.tabBuilder(item.id, item.name))
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      }, (item: TabData, index: number) => item.id.toString())
    }
    .vertical(false)
    .barMode(BarMode.Fixed)
    .barWidth($r('app.integer.styled_text_tab_bar_width'))
    .barHeight($r('app.integer.styled_text_tab_bar_height'))
    .onAnimationStart((index: number, targetIndex: number) => {
      this.mockMessages.clearData();
      this.currentIndex = targetIndex;
    })
    .width($r('app.string.styled_text_layout_full_size'))
    .height($r('app.string.styled_text_layout_full_size'))
    .backgroundColor($r('app.color.styled_text_bar_background_color'))
    .scrollable(false)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}

// 消息组件
@Reusable
@Component
struct MessageItem {
  @State messageBackgroundColor: Color | Resource = $r('app.color.styled_text_color_background'); // 消息卡片背景色
  @State messageItem: CustomMessage = new CustomMessage(0, $r('app.media.styled_text_user_image1'), ``, ``, []);
  @State spans: MyCustomSpan[] = []; // 自定义span列表数据
  @Link currentIndex: number; // 当前选中tab索引
  private imagePixelMap: image.PixelMap | undefined; // 视频链接图标的pixelMap
  // 超链接点击回调
  private linkClickCallback: (span: MyCustomSpan) => void =
    (span: MyCustomSpan) => {
      // 根据文本超链接的类型做相应处理
      if (span.type === MyCustomSpanType.Hashtag) {
        promptAction.showToast({
          message: $r('app.string.styled_text_hashtag_toast_message')
        });
      } else if (span.type === MyCustomSpanType.Mention) {
        promptAction.showToast({
          message: $r('app.string.styled_text_user_page_toast_message')
        });
      } else if (span.type === MyCustomSpanType.VideoLink) {
        promptAction.showToast({
          message: $r('app.string.styled_text_video_function_message')
        });
      } else {
        promptAction.showToast({
          message: $r('app.string.styled_text_content_details_toast_message')
        });
      }
    };

  aboutToReuse(params: Record<string, CustomMessage>): void {
    this.messageItem = params.messageItem;
  }

  // 分享、点赞、评论UI组件
  @Builder
  otherFunction(imageStr: Resource, text: string | Resource) {
    Row() {
      Image(imageStr)
        .height($r('app.integer.styled_text_other_function_image_width'))
        .width($r('app.integer.styled_text_other_function_image_width'))
        .objectFit(ImageFit.Contain)
        .autoResize(false)
      Text(text)
        .fontSize($r('app.string.styled_text_card_margin_start'))
        .fontColor($r('app.color.styled_text_default_font_color'))
        .fontFamily('HarmonyHeiTi')
        .opacity($r('app.string.styled_text_other_function_text_opacity'))
        .margin({ left: $r('app.integer.styled_text_other_function_text_margin_left') })
    }
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      promptAction.showToast({
        message: $r('app.string.styled_text_other_function'),
      });
    })
  }

  build() {
    Column() {
      // 用户信息
      Row() {
        Image(this.messageItem.profile)
          .width($r('app.integer.styled_text_profile_image_width'))
          .height($r('app.integer.styled_text_profile_image_width'))
          .borderRadius($r('app.integer.styled_text_profile_image_radius'))
          .margin({ right: $r('app.integer.styled_text_profile_image_right') })
        Column() {
          Text(this.messageItem.userName)
            .fontSize($r('app.string.styled_text_headline_font_size'))
            .fontColor($r('app.color.styled_text_user_name_color'))
          Text(this.messageItem.subTitle)
            .fontSize($r('app.string.styled_text_font_size_default'))
            .fontColor($r('app.color.styled_text_subtitle_color'))
        }
        .layoutWeight(LAYOUT_WEIGHT)
        .height($r('app.string.styled_text_layout_full_size'))
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.Start)
      }
      .width($r('app.string.styled_text_layout_full_size'))
      .height($r('app.integer.styled_text_profile_height'))
      .margin({ bottom: $r('app.string.styled_text_card_margin_start') })

      if (this.currentIndex === 0) {
        // 实现方案一：Text组件中使用ForEach遍历自定义Span对象数组，根据Span类型生成不同样式和功能的Span组件
        /**
         * 构建TextAndSpanComponent组件
         * spans: 包含不同类型文本片段的数组（如普通文本、超链接等）
         * linkClickCallback: 超链接点击回调
         */
        TextAndSpanComponent({
          spans: this.messageItem.spans,
          linkClickCallback: this.linkClickCallback
        })
      } else {
        // 实现方案二：遍历自定义Span对象数组生成不同样式和功能的属性字符串，并将拼接后的属性字符串通过TextController控制器绑定到Text组件上
        /**
         * 构建StyledStringComponent组件
         * spans: 包含不同类型文本片段的数组（如普通文本、超链接等）
         * imagePixelMap: 视频链接图标的pixelMap
         * linkClickCallback: 超链接点击回调
         */
        StyledStringComponent({
          spans: this.messageItem.spans,
          imagePixelMap: this.imagePixelMap,
          linkClickCallback: this.linkClickCallback
        })
      }

      // 附图
      Stack() {
        if (this.messageItem.media) {
          Image(this.messageItem.media)
            .width($r('app.integer.styled_text_message_media'))
            .margin({ top: $r('app.string.styled_text_card_margin_start') })
        }
      }

      // 分享、点赞、评论组件
      Row() {
        this.otherFunction($r('app.media.styled_text_ic_share'), $r('app.string.styled_text_share'))
        this.otherFunction($r('app.media.styled_text_ic_thumbsup'), $r('app.string.styled_text_thumbsup'))
        this.otherFunction($r('app.media.styled_text_ic_message'), $r('app.string.styled_text_message'))
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width($r('app.string.styled_text_layout_full_size'))
      .margin({
        top: $r('app.integer.styled_text_other_function_margin_top')
      })
    }
    .backgroundColor(this.messageBackgroundColor)
    .padding($r('app.string.styled_text_card_padding_start'))
    .onClick(() => {
      promptAction.showToast({
        message: $r('app.string.styled_text_content_details_toast_message')
      });
    })
    .gesture(
      // 长按修改消息卡片整体背景色，可实现长按分享等功能
      LongPressGesture()
        .onAction((event?: GestureEvent) => {
          if (event) {
            this.messageBackgroundColor = $r('app.color.styled_text_long_press_background_color');
            promptAction.showToast({
              message: $r('app.string.styled_text_demo_function_message')
            });
          }
        })
        .onActionEnd(() => {
          // 长按动作结束触发
          this.messageBackgroundColor = $r('app.color.styled_text_color_background');
        })
    )
    .alignItems(HorizontalAlign.Start)
  }
}
