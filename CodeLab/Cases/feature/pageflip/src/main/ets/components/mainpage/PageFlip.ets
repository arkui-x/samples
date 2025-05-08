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
import { CONFIGURATION, STRINGCONFIGURATION } from '../../common/Constants';
import { BottomView } from '../../view/BottomView';
import { CoverFlipPage } from '../../view/CoverFlipPage';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { LeftRightPlipPage } from '../../view/LeftRightFlipPage';
import { UpDownFlipPage } from '../../view/UpDownFlipPage';
import { common } from '@kit.AbilityKit';
import { promptAction, window } from '@kit.ArkUI';
import { TextReader } from '@kit.SpeechKit';
import { textReaderInfo } from '../../datasource/BasicDataSource';
import { logger } from '../../utils/Logger';

/**
 * 功能描述: 本示例展示手机阅读时左右翻页，上下翻页，覆盖翻页的功能。
 *
 * 推荐场景: 多用于电子书阅读场景
 *
 * 核心组件:
 * 1. Swiper/List
 * 2. LazyForEach
 * 3. CacheCount
 * 4. Stack
 *
 * 实现步骤:
 * 场景一: 左右翻页方式通过`swiper`+`lazyforeach`+`cachecount`实现按需加载。
 *    1. 在`aboutToAppear()`方法中通过`pushItem`向后加载数据，`addItem`向前加载数据。
 *    2. 使用`Swiper`组件和`LazyForEach`将数据源中的每条数据存放于Text组件中，`Swiper`向左或向右滑动的效果就是左右翻页的效果。
 *    3. 需要网络加载时可在`BasicDataSource`的`getData`方法中进行。当index等于0向前申请网络数据，当`index`等于this.totalCount() - 1时向后请求网络数据。
 *    4. 请求完数据后可通过`push`方法将数据插入到队尾，通过`unshift`插入到队头，具体可参考`BasicDataSource`的`pushItem`和`addItem`方法。
 * 场景二: 上下翻页方式通过`list`+`lazyforeach`+`cachecount`实现按需加载。
 *    1. 在`aboutToAppear()`方法中通过`pushItem`向后加载数据，`addItem`向前加载数据。
 *    2. 使用`List`组件和`LazyForEach`将数据源中的每条数据存放于Text组件中，`List`向上或向下滑动的效果就是上下翻页的效果。
 *    3. 需要网络加载时可在`BasicDataSource`的`getData`方法中进行。当index等于0向前申请网络数据，当`index`等于this.totalCount() - 1时向后请求网络数据。
 *    4. 请求完数据后可通过`push`方法将数据插入到队尾，通过`unshift`插入到队头，具体可参考`BasicDataSource`的`pushItem`和`addItem`方法。
 * 场景三: 覆盖翻页方式通过三个`Stack`组件通过滑动+动画+改变组件内容实现效果。
 *    1. 在`Stack`组件中布局三个`ReaderPage`，`midPage`位于中间可以根据this.offsetX实时translate自己的位置。
 *    2. 当this.offsetX<0时,translate的x为this.offsetX，midPage向左移动，显现`rightPage`。
 *    3. 当this.offsetX>0,translate的x为0，midPage不动，`leftPage`向右滑动。
 *    4. 将滑动翻页的动画和点击翻页的动画封装在一个闭包中，由`isClick`来判断是点击翻页还是滑动翻页，由`isLeft`来判断点击翻页中是向左翻页还是向右翻页。
 *    5. 确定翻页时将this.offsetX设置为this.screenW或者-this.screenW。translate移动加上动画效果就会产生覆盖翻页的效果。
 *    6. 最终滑动动画结束时this.offsetX都会被置为0，leftPage和midPage回归原位。
 *    7. 当动画结束时由于翻页会让`this.currentPageNum`加一或减一，根据相应的页数来加载三个`content`相应的内容。
 */
@Component
export struct PageFlipComponent {
  popPage: (() => void) | undefined = undefined;
  @State isMenuViewVisible: boolean = false; // 用来判断上下菜单视图是否显示。
  @State buttonClickedName: string = '左右翻页'; // 点击按钮的名称。
  @State filledName: string = '';
  @State isVisible: boolean = false; // 用来判断翻页方式视图是否显示。
  @State isCommentVisible: boolean = false; // 用来判断评论视图是否显示。
  @State currentPageNum: number = 1; // 书籍在第几页。
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  // 背景颜色
  @State bgColor: string = '#FFEFEFEF';
  // 文字字体大小
  @State textSize: number = 20;
  // 是否显示阅读背景
  @State isbgImage: boolean = false;
  // 播放文章列表
  @State readInfoList: TextReader.ReadInfo[] = [];
  @State selectedReadInfo: TextReader.ReadInfo = this.readInfoList[0];

  setSystemBarHidden() {
    window.getLastWindow(this.context).then((data: window.Window) => {
      let windowClass = data;
      // 设置沉浸式全屏
      windowClass.setWindowLayoutFullScreen(true)
        .then(() => {
          // 设置导航栏，状态栏不可见
          windowClass.setWindowSystemBarEnable([]);
          this.registerEmitter(windowClass);
        })
    });
  }

  /*
   * 添加事件订阅
   */
  registerEmitter(windowClass: window.Window) {
    // 定义返回主页时发送的事件id
    let innerEvent: emitter.InnerEvent = { eventId: 2 };
    emitter.on(innerEvent, (data: emitter.EventData) => {
      // 收到返回事件，显示状态栏和导航栏，退出全屏模式，再返回主页
      if (data?.data?.backPressed) {
        windowClass.setWindowSystemBarEnable(['status', 'navigation'])
          .then(() => {
            if (this.popPage) {
              this.popPage();
            } else {
              // 未传入返回接口时给出弹框提示
              promptAction.showToast({
                message: $r('app.string.pageflip_back_error_message'),
                duration: 1000
              })
            }
          });
      }
    })
  }

  /*
   * 取消事件订阅
   */
  deleteEmitter() {
    emitter.off(1);
  }

  aboutToAppear(): void {
    this.setSystemBarHidden();
    this.initResourceData();
  }

  aboutToDisappear(): void {
    this.deleteEmitter();
  }

  // 初始化播放文章列表
  initResourceData() {
    const context: Context = getContext(this);
    // 读取string.json中文章的数据
    try {
      let str = '';
      for(let i = CONFIGURATION.PAGEFLIPPAGESTART; i <= CONFIGURATION.PAGEFLIPPAGEEND; i++) {
        str = context.resourceManager.getStringByNameSync(STRINGCONFIGURATION.PAGEINFO + i.toString());
        // 将数据存入列表
        this.readInfoList.push(textReaderInfo(String(i), str));
      }
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      logger.error(`callback getStringByName failed, error code: ${code}, message: ${message}.`);
    }
    if(this.currentPageNum) {
      this.selectedReadInfo = this.readInfoList[this.currentPageNum - CONFIGURATION.PAGEFLIPPAGECOUNT];
    }
  }

  build() {
    /**
     * 创建一个Stack组件，上下菜单通过zIndex在阅读页面之上。
     * 通过底部点击的按钮名来确定翻页方式，创建翻页组件。
     */
    Stack() {
      if (this.buttonClickedName === STRINGCONFIGURATION.LEFTRIGHTFLIPPAGENAME) {
        LeftRightPlipPage({
          isMenuViewVisible: this.isMenuViewVisible,
          isCommentVisible: this.isCommentVisible,
          currentPageNum: this.currentPageNum,
          bgColor: this.bgColor,
          isbgImage: this.isbgImage,
          textSize: this.textSize,
          readInfoList: this.readInfoList,
          selectedReadInfo: this.selectedReadInfo
        });
      } else if (this.buttonClickedName === STRINGCONFIGURATION.UPDOWNFLIPPAGENAME) {
        UpDownFlipPage({
          isMenuViewVisible: this.isMenuViewVisible,
          isCommentVisible: this.isCommentVisible,
          currentPageNum: this.currentPageNum,
          bgColor: this.bgColor,
          isbgImage: this.isbgImage,
          textSize: this.textSize,
          readInfoList: this.readInfoList,
          selectedReadInfo: this.selectedReadInfo
        });
      } else {
        CoverFlipPage({
          isMenuViewVisible: this.isMenuViewVisible,
          isCommentVisible: this.isCommentVisible,
          currentPageNum: this.currentPageNum,
          bgColor: this.bgColor,
          isbgImage: this.isbgImage,
          textSize: this.textSize,
          readInfoList: this.readInfoList,
          selectedReadInfo: this.selectedReadInfo
        });
      }
      Column() {
        BottomView({
          isMenuViewVisible: this.isMenuViewVisible,
          buttonClickedName: this.buttonClickedName,
          filledName: this.filledName,
          isVisible: this.isVisible,
          isCommentVisible: this.isCommentVisible,
          bgColor: this.bgColor,
          isbgImage: this.isbgImage,
          textSize: this.textSize,
          readInfoList: this.readInfoList,
          selectedReadInfo: this.selectedReadInfo,
          currentPageNum: this.currentPageNum
        })
          .zIndex(CONFIGURATION.FLIPPAGEZINDEX)
      }
      .height($r('app.string.pageflip_full_size'))
      .justifyContent(FlexAlign.End)
      .onClick(() => {
        /**
         * 弹出上下菜单视图时，由于Column中间无组件，
         * 点击事件会被下一层的LeftRightPlipPage或UpDownFlipPage或CoverFlipPage的点击事件取代。
         */
        this.isMenuViewVisible = false;
        this.filledName = '';
        this.isVisible = false;
      })
    }
  }
}
