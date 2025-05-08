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

import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';
import { curUser, mockData } from '../mock/NewsDetailData';
import { CommonConstants } from '../common/CommonConstants';
import { CommentInputDialog } from './CommentInputDialog';
import { CommentPage } from './CommentPage';
import { logger } from '../utils/Logger';
import { MyScroller } from './Scroller';
import { NewsCommentData, NewsCommentModel } from '../model/NewsCommentModel';
import util from '@ohos.util';
import { PlatformTypeEnum, PlatformInfo } from 'utils'

const SEARCH_BUTTON: string = '搜索'; // 搜索按钮文字

/**
 * 功能描述: 本示例适用于Scroll容器嵌套多组件事件处理场景：当需要一个父容器Scroll内嵌套web、List，当父子的滚动手势冲突时，此时希望父容器的滚动优先级最高，
 * 即实现子组件的偏移量都由父容器统一派发，实现滚动任一子组件流畅滚动到父容器顶/底的效果。
 * 例如本案例的新闻浏览界面，父组件Scroll嵌套了新闻内容与评论区（Web实现新闻内容，List实现评论区），
 * 通过禁用web和list组件滚动手势，再由父组件Scroll统一计算派发偏移量，达到一种web的滚动和list组件滚动能无缝衔接，像同一个滚动组件滚动效果。
 *
 * 推荐场景: 当需要一个父容器Scroll内嵌套web、List，父子的滑动手势冲突时，此时希望父容器的滑动优先级最高，
 * 即实现子组件的偏移量都由父容器统一派发，实现滑动任一子组件流畅滑动到父容器顶/底的效果。
 *
 * 核心组件:
 * MyScroller：父容器Scroll组件统一派发子组件的偏移量
 *
 * 实现步骤：
 * 1. 禁用web滚动手势
 * @example
 * webviewController.setScrollable();
 * 2. 禁用web组件上的鼠标滚动
 * Web.onGestureRecognizerJudgeBegin(()=>{ return GestureJudgeResult.REJECT });
 * 3. 禁用List组件的手势
 * @example
 * List.enableScrollInteraction(false);
 * 4. 封装公共组件MyScroll：
 * 将Web组件和List组件传递到MyScroll,并将Web和List的scrollWeb和scrollList回调函数传递到MyScroll。
 * @example
 * MyScroller({
     webBuilder: ()=>{ this.webBuilder() }, // web组件（新闻内容）
     listBuilder: ()=>{ this.listBuilder() }, // list（评论内容）
     titleBuilder: ()=>{ this.CommentTitle() }, // 评论总数标题
     isWebAtEnd: $isWebAtEnd, // 传递Web组件是否滚动到下边界
     getWebScrollEnd: ()=>{ this.getWebScrollEnd() }, // 刷新web组件偏移量
     scrollWeb:(offset:number)=>{ this.scrollWeb(offset) }, // MyScroller组件滑动web
     scrollList: (offset:number)=>{ this.scrollList(offset) }, // MyScroller组件滑动list
     getListOffset: ():number=>{ return this.getListOffset() },// MyScroller刷新list组件的yOffset
 })
 * 5. MyScroll在滚动时调用getWebScrollEnd()检测web组件是否滚动到边界:
 * Web中通过webviewController.getPageHeight()获取Web组件总高度，当Web组件滚动偏移量 + Web组件自身高度 ≥ Web组件可视内容高度时，即Web组件滚动到边界。
 * @example
 * getWebScrollEnd() {
 *   this.webviewController.runJavaScriptExt('document.documentElement.scrollTop || document.body.scrollTop',(error, result) => {
 *     if (this.scrollTop + this.webHeight >= pageHeight) { // 当web组件滚动偏移量 + web组件高度 ≥ web组件内容高度（web组件高度固定，内容可以很长）
         this.isWebAtEnd = true;
 *     }
 *   })
 * }
 * 6. MyScroll对子组件进行偏移量派发: MyScroll使用Scroll.onScrollFrameBegin()中返回的offset滑动量判断页面上划/下划，进而通过this.scrollWeb(offset)派发给web偏移量，
 * 通过this.scrollList(offset)派发给List偏移量，从而实现web的滚动和list组件滚动能无缝衔接，像同一个滚动组件滚动效果。
 * @example
 * Scroll.onScrollFrameBegin((offset: number, state: ScrollState) => {
 * if (offset > 0) { // 当页面下滑
 *   if (!this.isWebAtEnd) { // 还没触到Web底部
 *     this.webviewController.scrollBy(0, offset); // 通过调用Web的WebController.scrollBy接口，滚动偏移派发给Web（水平方向滚动距离为0，竖直方向滚动距离为offset）
 *     return { offsetRemain: 0 } // 将Scroll剩余滚动偏移量返回0，scroll就不会滚动，也不会停止惯性滚动动画
 *  }}
 * }
 */
@Component
export struct NewsDetailPage {
  webviewController: webview.WebviewController = new webview.WebviewController(); // 初始化WebviewController
  @State changeValue: string = ''; // 搜索框关键词
  private listScroller: Scroller = new Scroller(); // 初始化listScroller
  @State commentList: NewsCommentData = new NewsCommentData(); // 评论列表
  @State curUser: string = curUser; // 当前用户
  @State replyUser: string = ""; // 被回复人昵称
  @State replyId: string = ""; // 被回复人id
  @State textInComment: string = ""; // 评论中的文字
  @LocalStorageLink('currentBreakPoint') currentBreakPoint: string = 'sm';
  private scrollTop: number = 0; // Web组件滚动偏移量
  @State isLargeDevice: boolean = false;
  private controllerSearch: SearchController = new SearchController(); // 初始化SearchController
  @State webHeight: number = 0; // Web组件高度
  @State isWebAtEnd: boolean = false; // web组件是否滚动到底部，ture到Web底部，false还未到底部。
  @State commentState: boolean = false;
  @StorageLink('avoidAreaTopToModule') avoidAreaTopToModule: number = 0;
  // 评论输入弹窗
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CommentInputDialog({
      textInComment: $textInComment,
      commentState: $commentState,
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

  /**
   * 发布评论
   */
  publishComment(): void {
    // 生成评论id
    const uuid: string = util.generateRandomUUID();
    // 添加一条评论，包含评论id、头像、昵称、回复id、回复昵称、回复文本
    const comment: NewsCommentModel =
      new NewsCommentModel(uuid, $r('app.media.news_user_select'), this.curUser, this.replyId, this.replyUser,
        this.textInComment, new Date(), new NewsCommentData());
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
    this.listScroller.scrollToIndex(0, true, ScrollAlign.START);
  }

  /**
   * MyScroller组件滑动Web
   */
  scrollWeb(offset: number) {
    if (PlatformInfo.isArkUIX()) {
      if (Math.abs(offset) > 0.8) {
        return;
      }
    }
    this.webviewController.scrollBy(0, offset);
  }

  /**
   * MyScroller组件滑动List
   */
  scrollList(offset: number) {
    this.listScroller.scrollBy(0, offset);
  }

  /**
   * MyScroller获取List组件的yOffset
   */
  getListOffset(): number {
    return this.listScroller.currentOffset().yOffset;
  }

  /**
   * 获取Web组件高度
   */
  getWebHeight() {
    try {
      this.webviewController?.runJavaScriptExt('window.innerHeight', (error, result) => {
        if (error || !result) {
          return;
        }
        let type = result.getType();
        if (type === webview.JsMessageType.STRING) {
          this.webHeight = parseInt(result.getString());
        } else if (type === webview.JsMessageType.NUMBER) {
          this.webHeight = result.getNumber();
        }
      })
    } catch (error) {
      logger.error('error' + error);
    }
  }

  /**
   * 检测web组件是否滚动到边界
   * isWebAtEnd：true  滚动到Web底部
   * isWebAtEnd：false 还未滚动到Web底部
   */
  getWebScrollEnd() {
    try {
      // 获取web组件滚动偏移量
      this.webviewController.runJavaScriptExt('document.documentElement.scrollTop || document.body.scrollTop', (error, result) => {
        if (error || !result) {
          return;
        }
        let type = result.getType();
        // web组件内容高度
        let pageHeight = this.webviewController.getPageHeight();
        if (type === webview.JsMessageType.STRING) {
          this.scrollTop = parseInt(result.getString());
        } else if (type === webview.JsMessageType.NUMBER) {
          this.scrollTop = result.getNumber();
        }
        this.isWebAtEnd = false;
        if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
          if (this.scrollTop + this.webHeight >= pageHeight) {
            this.isWebAtEnd = true;
          }
        } else if (PlatformInfo.isArkUIX()) {
          if (this.scrollTop + this.webHeight + 1 >= pageHeight) {
            this.isWebAtEnd = true;
          }
        }
      });
    } catch (error) {
      logger.error('error' + error);
    }
  }

  /**
   * 弹窗函数
   */
  showToast() {
    promptAction.showToast({
      message: $r('app.string.container_nested_only_show_for_ux')
    })
  }

  aboutToAppear() {
    // 添加模拟数据
    this.commentList = mockData();
    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      // TODO: 高性能知识点: 提前初始化WebView内核
      webview.WebviewController.initializeWebEngine();
    }
  }

  aboutToDisappear() {
    // 将dialogController置空
    this.dialogController = null;
  }

  // 新闻内容
  @Builder
  webBuilder() {
    Web({ src: $rawfile("news.html"), controller: this.webviewController })
      .javaScriptAccess(true)// Web网页加载完成时，禁用Web手势生成的滚动
      .verticalScrollBarAccess(false)// 关闭Web的纵向滚动条
      .onPageEnd(e => {
        if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
          // TODO：知识点：设置禁用Web手势生成的滚动
          this.webviewController.setScrollable(false, webview.ScrollType.EVENT);
        }
        // 获取Web组件高度
        this.getWebHeight();
      })// 禁用Web的pan手势，即鼠标滚轮和触摸板的双指滑动。
      .onGestureRecognizerJudgeBegin((event: BaseGestureEvent, current: GestureRecognizer, others: Array<GestureRecognizer>) => {
        if (current.isBuiltIn() && current.getType() == GestureControl.GestureType.PAN_GESTURE) {
          // TODO：知识点：使用onGestureRecognizerJudgeBegin方法，禁用web自带的pan手势触发即鼠标滚轮和触摸板的双指滑动操作。
          return GestureJudgeResult.REJECT; // 禁用Web的鼠标滚轮和触摸板的双指滑动操作
        }
        return GestureJudgeResult.CONTINUE;
      })
      .onAppear(() => {
        try {
          if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
            // TODO：知识点：预加载图片资源，加快页面加载速度。
            this.webviewController.prefetchPage('https://bpic.588ku.com/back_origin_min_pic/21/04/07/23c8806be022255931d5dcb04c762f37.jpg');
          }
        } catch (error) {
          console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
        }
      })
      .onClick(() => {
        this.showToast();
      })
  }

  // 评论区内容
  @Builder
  listBuilder() {
    List({ scroller: this.listScroller }) {
      LazyForEach(this.commentList, (item: NewsCommentModel) => {
        ListItem() {
          CommentPage({
            commonData: item,
            replyId: $replyId,
            replyUser: $replyUser,
            curUser: this.curUser,
            dialogController: this.dialogController,
            commentState: $commentState,
          })
        }
      }, (item: NewsCommentModel) => item.id.toString())
    }
    .alignListItem(ListItemAlign.Center)
    .scrollBar(BarState.Off)
    .maintainVisibleContentPosition(false) // false: 显示区域上方插入或删除数据时可见内容位置会跟随变化。
    .enableScrollInteraction(false) // TODO：知识点：禁用List组件的手势
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('app.color.container_nested_note_nested_list_bgc_color'))
    .id('commentList')
  }

  build() {
    RelativeContainer() {
      this.title()
      /**
       * 向MyScroller组件里传入子组件Web（新闻内容）、list（评论内容）等
       *
       * @param webBuilder：web组件（新闻内容）
       * @param listBuilder：List（评论内容）
       * @param titleBuilder：评论总数标题
       * @param isWebAtEnd：传递Web组件是否滚动到下边界
       * @param getWebScrollEnd：刷新web组件偏移量
       * @param scrollWeb：刷新web组件偏移量
       * @param scrollList：MyScroller组件滑动List
       * @param getListOffset：MyScroller刷新List组件的yOffset
       */
      MyScroller({
        // Web组件（新闻内容）
        webBuilder: () => {
          this.webBuilder()
        },
        // List（评论内容）
        listBuilder: () => {
          this.listBuilder()
        },
        // 评论总数标题
        titleBuilder: () => {
          this.CommentTitle()
        },
        // 传递Web组件是否滚动到下边界
        isWebAtEnd: $isWebAtEnd,
        // 刷新web组件偏移量
        getWebScrollEnd: () => {
          this.getWebScrollEnd()
        },
        // MyScroller组件滑动Web
        scrollWeb: (offset: number) => {
          this.scrollWeb(offset)
        },
        // MyScroller组件滑动List
        scrollList: (offset: number) => {
          this.scrollList(offset)
        },
        // MyScroller刷新List组件的yOffset
        getListOffset: (): number => {
          return this.getListOffset()
        },
      })
      Column() {
        Text($r('app.string.container_nested_publish_comment'))
          .width(CommonConstants.FULL_PERCENT)
          .height(CommonConstants.TEXT3_HEIGHT)
          .borderRadius(CommonConstants.BORDER_RADIUS_TWO)
          .backgroundColor(Color.White)
          .border({
            width: $r('app.integer.container_nested_text_input_hint_border_width'),
            color: $r('app.color.container_nested_color_comment_text_border')
          })
          .padding({ left: CommonConstants.PADDING_FIFTEEN })
          .onClick(() => {
            if (this.dialogController !== null) {
              this.textInComment = "";
              this.replyId = "";
              this.replyUser = "";
              // 打开评论输入弹窗
              this.dialogController.open();
            }
          })
          .id('publishComment')
        PublishView();
      }
      .id('relative_publish')
      .width(CommonConstants.FULL_PERCENT)
      .padding({ left: CommonConstants.PADDING_LEFT_THREE, right: CommonConstants.PADDING_TEN, top: CommonConstants.PADDING_TEN })
      .height(CommonConstants.COLUMN_HEIGHT)
      .alignRules({
        bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
        middle: { anchor: "__container__", align: HorizontalAlign.Center }
      })
    }
    .padding({ top: px2vp(this.avoidAreaTopToModule) })
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
  }

  // 标题行
  @Builder
  title() {
    Row() {
      Image($r('app.media.news_batman'))
        .height(CommonConstants.ICON_WIDTH)
        .width(CommonConstants.ICON_HEIGHT)
        .borderRadius(CommonConstants.BORDER_RADIUS_TWO)
        .id('pic')
        .autoResize(true)
        .onClick(() => {
          this.showToast();
        })
      Row() {
        Text($r('app.string.container_nested_follow'))
          .fontColor($r('app.color.container_nested_note_follow_font_color'))
          .fontSize(CommonConstants.FOLLOW_FONTSIZE)
          .borderRadius(CommonConstants.BORDER_RADIUS_THREE)
          .height(CommonConstants.ICON1_HEIGHT)
          .width(CommonConstants.ICON2_WIDTH)
          .backgroundColor($r('app.color.container_nested_note_nested_follow_bgc_color'))
          .textAlign(TextAlign.Center)
          .alignRules({
            top: { anchor: 'pic', align: VerticalAlign.Bottom },
            left: { anchor: 'pic', align: HorizontalAlign.Start }
          })
          .id('follow')
          .onClick(() => {
            this.showToast();
          })
      }
      .margin({ left: CommonConstants.MARGIN_NEGATIVE_FOUR_TY, bottom: CommonConstants.MARGIN_NEGATIVE_THIRTY })
      .alignRules({
        top: { anchor: 'pic', align: VerticalAlign.Bottom },
        left: { anchor: 'pic', align: HorizontalAlign.Start }
      })
      .id('follow')

      Search({
        value: this.changeValue,
        placeholder: $r('app.string.container_nested_search_value'),
        controller: this.controllerSearch
      })
        .enableKeyboardOnFocus(false)
        .searchButton(SEARCH_BUTTON)
        .width('60%')
        .margin({ left: CommonConstants.MARGIN_FIFTEEN })
        .height(CommonConstants.SEVENTY_FIVE_PERCENT)
        .backgroundColor(Color.White)
        .placeholderColor(Color.Grey)
        .placeholderFont({
          size: CommonConstants.FOUR_TEEN_FONTSIZE,
          weight: CommonConstants.PLACE_HOLDER_FONT_WEIGHT
        })
        .onSubmit((value: string) => {
          this.showToast();
        })
        .onChange((value: string) => {
          this.changeValue = value;
        })
      Row() {
        Text($r('app.string.container_nested_listen'))
          .fontSize(CommonConstants.FONTSIZE_EIGHTEEN)
          .margin({ left: CommonConstants.MARGIN_FIFTEEN })

        Image($r('app.media.news_more'))
          .height(CommonConstants.THIRTY_WIDTH)
          .width(CommonConstants.THIRTY_WIDTH)
          .margin({ left: CommonConstants.MARGIN_FIFTEEN })
      }
      .alignRules({
        left: { anchor: "__container__", align: HorizontalAlign.Start }
      })
      .width('20%')
      .onClick(() => {
        this.showToast();
      })
    }
    .justifyContent(FlexAlign.Start)
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.HEIGHT_FIFTY)
    .padding({ left: CommonConstants.PADDING_TEN, right: CommonConstants.PADDING_TEN })
    .id("row_title")
    .alignRules({
      top: { anchor: "__container__", align: VerticalAlign.Top }
    })
  }

  // 评论标题行
  @Builder
  CommentTitle() {
    Row() {
      Text($r('app.string.container_nested_comment_text'))
        .fontSize(CommonConstants.FONTSIZE_TWENTY)
        .fontWeight(FontWeight.Bold)

      Blank()

      Text($r('app.string.container_nested_comment1_text'))
        .fontSize(CommonConstants.FOUR_TEEN_FONTSIZE)
        .fontWeight(FontWeight.Bold)
    }
    .width(CommonConstants.NINETY_FIVE_PERCENT)
    .height(CommonConstants.ROW_HEIGHT)
    .onClick(() => {
      this.showToast();
    })
  }
}

// 页面底部分享组件
@Component
export struct PublishView {
  @StorageLink('avoidAreaBottomToModule') avoidAreaBottomToModule: number = 0;

  build() {
    Row() {
      Text() {
        ImageSpan($r('app.media.news_share'))
          .width(CommonConstants.ICON3_WIDTH)
          .height(CommonConstants.ICON3_WIDTH)
          .objectFit(ImageFit.Fill)
          .verticalAlign(ImageSpanAlignment.CENTER)
          .margin({ left: CommonConstants.MARGIN_LEFT, right: CommonConstants.MARGIN_RIGHT })
        Span($r('app.string.container_nested_share_text'))
      }.width($r('app.string.container_nested_publish_width'))

      Text() {
        ImageSpan($r('app.media.news_comment'))
          .width(CommonConstants.ICON3_WIDTH)
          .height(CommonConstants.ICON3_WIDTH)
          .objectFit(ImageFit.Fill)
          .verticalAlign(ImageSpanAlignment.CENTER)
          .margin({ left: CommonConstants.MARGIN_LEFT_TWO, right: CommonConstants.MARGIN_RIGHT_TWO })
        Span($r('app.string.container_nested_comment3_text'))
      }.width($r('app.string.container_nested_publish_width'))

      Text() {
        ImageSpan($r('app.media.news_follow'))
          .width(CommonConstants.ICON3_WIDTH)
          .height(CommonConstants.ICON3_WIDTH)
          .verticalAlign(ImageSpanAlignment.CENTER)
          .margin({ left: CommonConstants.MARGIN_LEFT_TWO, right: CommonConstants.MARGIN_RIGHT_TWO })
        Span($r('app.string.container_nested_star_text'))
      }.width($r('app.string.container_nested_publish_width'))

      Text() {
        ImageSpan($r('app.media.news_star'))
          .width(CommonConstants.ICON3_WIDTH)
          .height(CommonConstants.ICON3_WIDTH)
          .verticalAlign(ImageSpanAlignment.CENTER)
          .margin({ left: CommonConstants.MARGIN_LEFT_TWO, right: CommonConstants.MARGIN_RIGHT_TWO })
        Span($r('app.string.container_nested_collect_text'))
      }.width($r('app.string.container_nested_publish_width'))
    }
    .padding({ bottom: px2vp(this.avoidAreaBottomToModule) })
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.SIXTY_HEIGHT)
    .onClick(() => {
      promptAction.showToast({ message: $r('app.string.container_nested_only_show_for_ux') });
    })
  }
}