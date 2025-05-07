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

import { curUser, mockData } from '../mock/DetailData';
import { CommentData, CommentModel } from '../model/TextFlowMode';
import { CommentInputDialog } from './CommentInputDialog';
import { CommentPage } from './CommentPage';
import { emitter } from '@kit.BasicServicesKit';
import promptAction from '@ohos.promptAction';
import util from '@ohos.util';

const FONT_WEIGHT_FIVE_HUNDRED = 500; // 字体粗细
const FONT_WEIGHT_FOUR_HUNDRED = 400; // 字体粗细

/**
 * 功能描述: 本示例实现了回复评论时，当回复人的昵称与被回复人的昵称长度都过长时，使用textOverflow和maxLines()实现昵称的长文本省略展示的功能。
 *
 * 推荐场景: 长文本需要省略展示的场景
 *
 * 核心组件:
 * 1. textOverflow
 * 2. maxLines()
 *
 * 实现步骤：
 * 1、定义评论数据结构CommentModel，其中有id该条评论标识，url该评论用户头像，user该评论的用户，replyId该条评论回复的id，replyUser该条评论回复的人，text该条评论回复的文本，replyList该条评分被回复的列表;
 * 2、定义CommentData继承BasicDataSource，因为BasicDataSource实现了IDataSource,在BasicDataSources设定需要动态监听的model,以便于添加评论时，实现数据的动态监听从而进行lazyForeach懒加载。
 * 3、CommentData中定义comments评论数组和totalCount()、pushData()、getParentData()等函数，以进行评论的添加和获取展示。
 * 4、页面组件TextOverflowPage中编写评论页面，分为三个关键部分：评论内容、底部评论框、评论弹窗。
 * 5、评论内容中使用list通过lazyForeach生成listItem，每一个listItem是一个父评论卡片，所有的对该父评论的回复通过lazyForeach动态展示在此卡片上，即回复列表。
 * 6、当点击底部评论框，此时没有指定回复人，因此算作父评论，会展示在父评论列表，即listItem。
 * 7、当点击父评论下的回复时，此时弹出评论框，并显示父评论的用户，该条回复将作为父评论下的子评论进行展示。
 * 8、子回复列表的展示样式xxxxxx>xxxxx，设定回复人和被回复人昵称的文本属性.maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }),如果回复人和被回复人的昵称超出设定的长度则会以省略号展示。从而实现长文本overflow。
 */
@Component
export struct TextOverflowPageComponent {
  // 创建Scroller对象
  private scrollerContainer: Scroller = new Scroller();
  // 创建List的Scroller对象
  private scroller: Scroller = new Scroller();
  // 评论列表
  @State commentList: CommentData = new CommentData();
  // 评论中的文字
  @State textInComment: string = "";
  // 被回复人id
  @State replyId: string = "";
  // 被回复人昵称
  @State replyUser: string = "";
  // 当前用户
  @State curUser: string = curUser;
  @StorageLink('avoidAreaBottomToModule') avoidAreaBottomToModule: number = 0;
  // 评论输入弹窗
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CommentInputDialog({
      textInComment: $textInComment,
      placeholder: '@' + this.replyUser, // 回复样式为：@回复人昵称
      publish: () => this.publishComment()
    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    offset: {
      dx: 0,
      dy: -20
    }
  });

  // 发布评论
  publishComment(): void {
    // 生成评论id
    const uuid: string = util.generateRandomUUID();
    // 添加一条评论，包含评论id、头像、昵称、回复id、回复昵称、回复文本
    const comment: CommentModel =
      new CommentModel(uuid, $r('app.media.user_select'), this.curUser, this.replyId, this.replyUser,
        this.textInComment, new Date(), new CommentData());
    // 通过回复id获取该评论的父评论
    const parentComment = this.commentList.getParentData(this.replyId);
    // 如果获取到了父评论，则将该评论加到父评论下
    if (parentComment) {
      parentComment.replyList.addDataFirst(comment);
    } else {
      // 否则自己作为父评论
      this.commentList.addDataFirst(comment);
    }
    // 评论完成将回复人信息置空
    this.replyId = "";
    this.replyUser = "";
    // 滑动置顶
    this.scroller.scrollToIndex(0, true, ScrollAlign.START);
    let newId = this.commentList.getData(0).id;
    let newId2 = uuid;
    emitter.emit({ eventId: 0, priority: 0 }, {
      data: {
        newId: newId,
        newId2: newId2
      }
    })
  }

  aboutToAppear(): void {
    // 添加模拟数据
    this.commentList = mockData();
  }

  aboutToDisappear() {
    // 将dialogController置空
    this.dialogController = null;
  }

  build() {
    RelativeContainer() {
      Row() {
        Text($r('app.string.text_flow_color_evaluate'))
          .fontSize($r('app.integer.text_flow_text_sixteen'))
          .fontWeight(FONT_WEIGHT_FIVE_HUNDRED)
          .onClick(() => {
            promptAction.showToast({ message: $r('app.string.text_flow_prompt_text') })
          })
          .padding({ left: 15 })
        Blank()
        Text($r('app.string.text_flow_color_ninety_nine_percent'))
          .fontSize($r('app.integer.text_flow_font_size'))
          .fontWeight(FONT_WEIGHT_FOUR_HUNDRED)
          .fontColor($r('app.color.text_flow_color_red'))
          .onClick(() => {
            promptAction.showToast({ message: $r('app.string.text_flow_prompt_text') })
          })
        Text($r('app.string.text_flow_color_praise'))
          .fontSize($r('app.integer.text_flow_font_size'))
          .fontWeight(FONT_WEIGHT_FOUR_HUNDRED)
          .fontColor($r('app.color.text_flow_color_blank'))
          .onClick(() => {
            promptAction.showToast({ message: $r('app.string.text_flow_prompt_text') })
          })
        Image($r('app.media.right'))
          .width($r('app.integer.text_flow_img_width'))
          .height($r('app.integer.text_flow_img_height'))
          .onClick(() => {
            promptAction.showToast({ message: $r('app.string.text_flow_prompt_text') })
          })
          .padding({ right: 15 })
      }
      .backgroundColor(Color.White)
      .width('100%')
      .height(20)
      .margin({ bottom: $r('app.integer.text_flow_row_margin_bottom') })
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top }, // 以父容器为锚点，竖直方向顶头对齐
        left: { anchor: '__container__', align: HorizontalAlign.Start } //以父容器为锚点，水平方向开头对齐
      })
      .id('title')

      Scroll(this.scrollerContainer) {
        List({ scroller: this.scroller }) {
          // TODO：知识点：使用LazyForEach加载评论列表，可以按需加载，解决一次性加载全部列表数据引起的卡顿问题，提高页面响应速度
          LazyForEach(this.commentList, (item: CommentModel) => {
            ListItem() {
              CommentPage({
                commonData: item,
                replyId: $replyId,
                replyUser: $replyUser,
                curUser: this.curUser,
                dialogController: this.dialogController
              })
            }
          }, (item: CommentModel) => JSON.stringify(item))
        }
        .width('100%')
        .height('90%')
        .alignListItem(ListItemAlign.Center)
        .listDirection(Axis.Vertical) // 排列方向
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
        .backgroundColor('#ffffff')
      }
      .scrollable(ScrollDirection.Vertical)
      .width('100%')
      .scrollBar(BarState.Off)
      .id('scroll_content')
      .alignRules({
        top: { anchor: "title", align: VerticalAlign.Bottom },
        middle: { anchor: "__container__", align: HorizontalAlign.Center },
      })
      .margin({ bottom: 15 })

      Column() {
        Text($r('app.string.text_flow_text_input_hint'))
          .borderRadius($r('app.integer.text_flow_text_input_hint_border_radius'))
          .width('100%')
          .height(40)
          .padding({ left: $r('app.integer.text_flow_text_input_hint_padding_left') })
          .backgroundColor(Color.White)
          .border({
            width: $r('app.integer.text_flow_text_input_hint_border_width'),
            color: $r('app.color.text_flow_color_comment_text_border')
          })
          .onClick(() => {
            if (this.dialogController !== null) {
              this.textInComment = "";
              this.replyId = "";
              this.replyUser = "";
              // 打开评论输入弹窗
              this.dialogController.open();
            }
          })
          .id('inputComment')
      }
      .width($r('app.string.text_flow_percent_100'))
      .height($r('app.integer.text_flow_row_input_hint_height'))
      .alignRules({
        bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
        middle: { anchor: "__container__", align: HorizontalAlign.Center }
      })
      .offset({ y: -15 })
      .padding({
        top: 5,
        right: 10,
        left: 10
      })
      .backgroundColor($r('app.color.text_flow_color_comment_text_background'))
    }
    .padding({ bottom: px2vp(this.avoidAreaBottomToModule) })
    .width('100%')
    .height('100%')
  }
}

