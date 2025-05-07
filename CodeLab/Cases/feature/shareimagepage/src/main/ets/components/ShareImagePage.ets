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
import { AppRouter } from 'routermodule';
import { ListDataSource } from './ListDataSource';
import { promptAction, window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

// 聊天item数据类型
export interface textDetailData {
  userId: number,
  profilePicture: ResourceStr, // 头像
  shareImageUri?: string | undefined, // 分享的图片
  content?: ResourceStr // 聊天text内容
}

/**
 * 图片分享实现思路
 * 1.通过systemShare分享API获取从图库分享过来的图片地址，使用AppStorage存储。
 * 2.将取到的图片路径传入lazyforeach的dataSource中进行渲染
 */
@AppRouter({ name: "shareimagepage/ShareImagePage" })
@Component
export struct ShareImagePage {
  // 聊天item数据数组
  @State textDetailData: textDetailData[] = [{
    userId: 0,
    profilePicture: $r('app.media.photo0'),
    shareImageUri: '',
    content: $r('app.string.share_image_page_text_detail_data0')
  }, {
    userId: 1,
    profilePicture: $r('app.media.photo1'),
    shareImageUri: '',
    content: $r('app.string.share_image_page_text_detail_data1')
  }];
  @StorageLink('imageUri') @Watch('shareImageDataChange') shareImageUri: string | undefined = ''; //分享的图片路径
  private dataSource: ListDataSource = new ListDataSource(this.textDetailData); // lazyForeach控制器
  listScroller: ListScroller = new ListScroller();
  // toast弹窗时长
  private toastDuration: number = 2000;

  shareImageDataChange() {
    if (AppStorage.get('imageUri') && AppStorage.get('imageUri') !== '') {
      this.shareImageUri = AppStorage.get('imageUri');
      this.textDetailData.push({
        userId: 0,
        profilePicture: $r('app.media.photo0'),
        shareImageUri: this.shareImageUri,
        content: ''
      });
      // 通知lazyForeach重新加载数据
      this.dataSource.modifyAllData(this.textDetailData);
      // 数据更新后，滚动到列表底部
      this.listScroller.scrollEdge(Edge.Bottom);
    }
  }

  aboutToAppear() {
    let context = getContext() as common.UIAbilityContext;
    context.windowStage.getMainWindowSync().getUIContext().setKeyboardAvoidMode(1);
    this.shareImageDataChange();
  }

  aboutToDisappear(): void {
    // 退出时情况数据防止路由二次跳转
    AppStorage.set('imageUri', undefined);
  }

  /**
   * 聊天item
   * @param data 聊天item数据
   * @param index item的索引值
   */
  @Builder
  chatItem(data: textDetailData, index: number) {
    Flex({
      direction: data.userId === 1 ? FlexDirection.Row : FlexDirection.RowReverse,
      alignItems: ItemAlign.Center
    }) {
      // 用户头像
      Image(data.profilePicture)
        .objectFit(ImageFit.Fill)
        .width($r('app.integer.share_image_page_user_image_width_height'))
        .height($r('app.integer.share_image_page_user_image_width_height'))
        .borderRadius($r('app.integer.share_image_page_user_image_border_radius'))
        .margin({
          left: $r('app.integer.share_image_page_user_image_margin_left'),
          right: $r('app.integer.share_image_page_user_image_margin_right'),
        })

      // 文本内容
      Column() {
        Text(data.content)
      }
      .visibility(data.content === '' ? Visibility.None : Visibility.Visible)
      .borderRadius($r('app.integer.share_image_page_user_text_column_border_radius'))
      .backgroundColor(Color.Green)
      .opacity(0.8)
      .padding($r('app.integer.share_image_page_user_text_column_padding'))

      // 分享的图片
      Image(data.shareImageUri)
        .id('shared_image')
        .height($r('app.integer.share_image_page_user_share_image_height'))
        .objectFit(ImageFit.Contain)
        .visibility(data.shareImageUri === '' ? Visibility.None : Visibility.Visible)
    }
    .width($r('app.string.share_image_page_width'))
    .margin({
      top: $r('app.integer.share_image_page_chat_item_margin_top')
    })
  }

  build() {
    Column() {
      List({ scroller: this.listScroller }) {
        // 性能知识点：使用懒加载组件渲染数据。参考资料：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-rendering-control-lazyforeach-V5
        LazyForEach(this.dataSource, (data: textDetailData, index: number) => {
          ListItem() {
            this.chatItem(data, index);
          }
        })
      }
      .listDirection(Axis.Vertical)
      .divider({
        strokeWidth: $r('app.integer.share_image_page_list_divider_stroke_width'),
        color: $r('app.string.share_image_page_divider_color')
      })
      .padding({
        left: $r('app.integer.share_image_page_list_padding'),
        right: $r('app.integer.share_image_page_list_padding'),
        bottom: $r('app.integer.share_image_page_list_padding')
      })
      .width($r('app.string.share_image_page_width'))
      .height($r('app.string.share_image_page_list_height'))

      // 底部输入框
      Row() {
        Image($r('app.media.chatting_mode_voice'))
          .height($r('app.integer.share_image_page_input_image_left_height'))
          .margin({
            left: $r('app.integer.share_image_page_input_image_left_margin'),
            right: $r('app.integer.share_image_page_input_image_left_margin')
          })
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.share_image_page_other_function'),
              duration: this.toastDuration
            });
          })

        TextInput()
          .focusable(false)
          .width($r('app.integer.share_image_page_input_text_input_width'))
          .height($r('app.integer.share_image_page_input_text_input_height'))
          .borderRadius($r('app.integer.share_image_page_input_text_input_border_radius'))
          .backgroundColor($r('app.string.share_image_page_input_text_input_background_color'))
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.share_image_page_other_function'),
              duration: this.toastDuration
            });
          })

        Button($r('app.string.share_image_page_send_button'))
          .height($r('app.integer.share_image_page_input_button_height'))
          .borderRadius($r('app.integer.share_image_page_input_button_border_radius'))
          .width($r('app.integer.share_image_page_input_button_width'))
          .margin({
            left: $r('app.integer.share_image_page_input_button_margin'),
            right: $r('app.integer.share_image_page_input_button_margin')
          })
          .fontColor(Color.White)
          .backgroundColor(Color.Green)
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.share_image_page_other_function'),
              duration: this.toastDuration
            });
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .borderRadius({
        topLeft: $r('app.integer.share_image_page_input_text_input_border_radius'),
        topRight: $r('app.integer.share_image_page_input_text_input_border_radius')
      })
      .padding({
        top: $r('app.integer.share_image_page_column_padding'),
        bottom: $r('app.integer.share_image_page_column_padding')
      })
      .backgroundColor(Color.White)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .width($r('app.string.share_image_page_width'))
    }
    .width($r('app.string.share_image_page_width'))
    .height($r('app.string.share_image_page_width'))
    .justifyContent(FlexAlign.SpaceBetween)
  }
}
