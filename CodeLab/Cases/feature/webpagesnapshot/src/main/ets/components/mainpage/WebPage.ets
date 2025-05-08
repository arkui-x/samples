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
import Constants from '../../common/Constants';
import { sleep } from '../../common/Utils';
import webview from '@ohos.web.webview';
import { BusinessError, emitter, print } from '@kit.BasicServicesKit';
import { componentSnapshot, display, promptAction } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { logger } from '../../utils/Logger';
import { PreviewWindowComponent } from '../viewmodel/PreviewWindowComponent';
import { PopupPosition } from '../model/PopupPosition';

/**
 * 功能描述：本示例页面由Web组件组织，实现了Web页面长截图、Web页面打印功能
 *
 * 推荐场景：Web组件组织的页面需要生成长截图或打印输出的场景
 *
 * 核心组件:
 * 1. snapShot - 生成长截图
 * 2. webPrint - 打印Web组件
 *
 * 实现步骤：
 *  1. 创建Web组件加载指定的网页，获取Web组件和网页的实际尺寸，并给Web组件绑定自定义的id
 *  2. 截图功能：创建截图函数，执行滚动截图并拼接
 *  3. 截图后预览：截图后弹出预览窗口，可以滚动查看完整的截图，并保存图片到用户相册中
 *  4. 打印功能：通过print模块调起系统弹窗，与打印机交互进行打印
 */

const TAG: string = '[WebPageSnapshot]:';

@Builder
export function WebPageBuilder(name: string, param: Object) {
  WebPageSnapshotPage()
}

@Component
export struct WebPageSnapshotPage {
  // Navigation路由栈
  pageInfos: NavPathStack = new NavPathStack()
  // 网页URL和WebviewController对象
  private webPageUrl: string = Constants.EXAMPLE_URL;
  private webviewController: webview.WebviewController = new webview.WebviewController();
  // 网页尺寸
  @State h5Width: number = 0;
  @State h5Height: number = 0;
  // Web组件尺寸
  private webWidth: number = 0;
  private webHeight: number = 0;
  // 当前网页位置
  private curXOffset: number = 0;
  private curYOffset: number = 0;
  // 备份当前网页位置
  private xOffsetBefore: number = 0;
  private yOffsetBefore: number = 0;
  // 截图过程的Web组件覆盖
  @State webMaskImage: PixelMap | undefined = undefined;
  private webMaskImageZIndex: number = -1;
  // 合并后的图片
  @State mergedImage: PixelMap | undefined = undefined;
  // 截图后小窗大小
  @State snapPopupWidth: number = Constants.SNAP_WINDOW_WIDTH;
  @State snapPopupHeight: number = Constants.SNAP_WINDOW_HEIGHT;
  @State snapPopupPosition: Position = { x: 0, y: 0 };
  // 是否显示预览窗口
  @State isShowSnapPopup: boolean = false;
  @State showPreview: boolean = false;
  //Web是否已经滚动到底部
  @State WebTouchBottom: boolean = false;
  // 屏幕尺寸
  private displayWidth: number = 0;
  private displayHeight: number = 0;

  aboutToAppear(): void {
    // TODO: 性能知识点: 提前进行Web组件动态库的加载和Web内核主进程的初始化，最终以提高启动性能，减少白屏时间
    webview.WebviewController.initializeWebEngine();
    // 预连接，对url进行DNS解析、socket建链操作，不获取主资源子资源
    webview.WebviewController.prepareForPageLoad(Constants.EXAMPLE_URL, true, 2);
    // 获取屏幕尺寸
    const displayData = display.getDefaultDisplaySync();
    this.displayWidth = px2vp(displayData.width);
    this.displayHeight = px2vp(displayData.height);

    // 注册事件返回按钮点击
    this.listenBackPress();
  }

  listenBackPress() {
    let innerEvent: emitter.InnerEvent = {
      eventId: 6
    };
    // 收到eventId为6的事件后执行回调函数
    emitter.on(innerEvent, () => {
      this.pageInfos.pop();
    });
  }

  build() {
    NavDestination(){
      Column() {
        // 标题Header栏
        Row() {
          Text($r('app.string.web_page_snap_shot_web_snap_page_title'))
            .fontSize($r('app.string.web_page_snap_shot_ohos_id_text_size_headline'))
            .fontWeight(FontWeight.Medium)
          Button($r('app.string.web_page_snap_shot_web_snap_snapshot_button_title'))
            .id('web_page_snap_shot_web_page_shot')
            .width(Constants.BUTTON_WIDTH)
            .height(Constants.BUTTON_HEIGHT)
            .onClick(() => {
              this.snapShot();
            })
          Button($r('app.string.web_page_snap_shot_web_print_button_title'))
            .width(Constants.BUTTON_WIDTH)
            .height(Constants.BUTTON_HEIGHT)
            .onClick(() => {
              this.webPrint();
            })
        }
        .width($r('app.string.web_page_snap_shot_web_snap_full_size'))
        .justifyContent(FlexAlign.SpaceEvenly)

        Stack() {
          // 截图过程的遮罩层，避免用户察觉屏幕快速滑动，提高用户体验
          Image(this.webMaskImage)
            .width($r('app.string.web_page_snap_shot_web_snap_full_size'))
            .height($r('app.string.web_page_snap_shot_web_snap_full_size'))
            .zIndex(this.webMaskImageZIndex)

          Web({
            src: this.webPageUrl,
            controller: this.webviewController
          })
            .width($r('app.string.web_page_snap_shot_web_snap_full_size'))
            .height($r('app.string.web_page_snap_shot_web_snap_full_size'))
            .id(Constants.WEB_ID)
            .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
            .onAreaChange((oldValue, newValue) => {
              // TODO: 高性能知识点: onAreaChange为高频回调，组件变动时每帧都会调用，避免冗余和耗时操作。
              this.webWidth = newValue.width as number;
              this.webHeight = newValue.height as number;
              logger.debug(TAG, `Web component width: ${this.webWidth}, height: ${this.webHeight}`);
            })
            .onPageEnd(() => {
              promptAction.showToast({
                message: Constants.FINISH_LOAD_PROMPT,
                duration: Constants.FINISH_PROMPT_DURATION
              });
            })
            .onOverScroll((event) => {
              if (event?.yOffset > 0) {
                this.WebTouchBottom = true
              } else if (event?.yOffset === 0 && this.WebTouchBottom) {
                this.WebTouchBottom = false
              }
            })
            .onScroll((event) => {
              this.curXOffset = event.xOffset;
              this.curYOffset = event.yOffset;
              logger.info(TAG, `Web page current position (x: ${event.xOffset}, y: ${event.yOffset})`);
            })
        }
        .width($r('app.string.web_page_snap_shot_web_snap_full_size'))
        .layoutWeight(1)
        .borderRadius($r('app.string.web_page_snap_shot_ohos_id_corner_radius_default_m'))
        .margin({ top: $r('app.string.web_page_snap_shot_ohos_id_corner_radius_default_m') })
        .bindContentCover($$this.isShowSnapPopup, this.previewWindowComponent(), { modalTransition: ModalTransition.NONE }
        )
      }
      .width($r('app.string.web_page_snap_shot_web_snap_full_size'))
      .height($r('app.string.web_page_snap_shot_web_snap_full_size'))
      .padding({ top: $r('app.string.web_page_snap_shot_ohos_id_card_padding_start') })
    }.title(Constants.WEB_PAGE_TITLE)
    .hideTitleBar(Constants.HIDE_TITLE_BAR)
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      logger.info('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true;
    }).onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack
    })
  }

  /**
   * 截图函数。
   */
  async snapShot() {
    // 获取Web页面尺寸
    this.getWebSize();
    // 截图前的状态初始化
    await this.beforeSnapshot();
    // TODO: 性能知识点: 使用Canvas离屏绘制在缓冲区拼接截图
    const canvasSetting: RenderingContextSettings = new RenderingContextSettings(true);
    const offCanvasCtx: OffscreenCanvasRenderingContext2D =
      new OffscreenCanvasRenderingContext2D(this.h5Width, this.h5Height, canvasSetting);
    // 前置常量
    const snipTimes = Math.ceil(this.h5Height / this.webHeight);
    logger.info(TAG, `Need to snapshot ${snipTimes} times.`);
    const lastTime = snipTimes - 1;
    const leftoverHeight = this.h5Height % this.webHeight;
    let cropLeftover: image.Region = { x: 0, y: 0, size: { height: 0, width: 0 } }
    if (this.WebTouchBottom) {
      // 这里要分两种情况，1.滚动到底部时，裁剪应该取最后一张除去重复部分以外的底部
      cropLeftover = {
        x: 0,
        y: vp2px(this.webHeight - leftoverHeight),
        size: {
          height: vp2px(leftoverHeight),
          width: vp2px(this.webWidth)
        }
      };
    } else {
      // 2.未滚动到底部时，裁剪应该取最后一张leftoverHeight的上部分
      cropLeftover = {
        x: 0,
        y: 0,
        size: {
          height: vp2px(leftoverHeight),
          width: vp2px(this.webWidth)
        }
      };
    }

    // 开始截图
    for (let i = 0; i < snipTimes; i++) {
      const curSnip = await componentSnapshot.get(Constants.WEB_ID);
      // 最后一次截图需要特殊处理，去除重复部分
      if (i === lastTime) {
        logger.info(TAG, `The last snapshot image height ${leftoverHeight}`);
        await curSnip.crop(cropLeftover);
        offCanvasCtx.drawImage(curSnip, 0, this.webHeight * i, this.webWidth, leftoverHeight);
      } else {
        offCanvasCtx.drawImage(curSnip, 0, this.webHeight * i, this.webWidth, this.webHeight);
      }
      // debug使用，否则影响性能
      logger.debug(TAG, `Screenshot ${i}: ${JSON.stringify(await curSnip.getImageInfo())}`);
      // 继续滚动
      this.webviewController.scrollBy(0, this.webHeight);
      // 延时保证滚动完成
      await sleep(Constants.SCROLL_DURATION);
    }
    // 截图后的操作
    await this.afterSnapshot();
    // 获取pixelMap
    this.mergedImage = offCanvasCtx.getPixelMap(0, 0, this.h5Width, this.h5Height);
    // 拼接之后修改可动画变量
    this.afterGeneratorImage();
  }

  /**
   * 截图前获取尺寸
   */
  getWebSize() {
    const SCRIPT = '[document.documentElement.scrollWidth, document.documentElement.scrollHeight]';
    this.webviewController.runJavaScriptExt(SCRIPT).then((result) => {
      try {
        switch (result.getType()) {
          case webview.JsMessageType.ARRAY:
            this.h5Width = (result.getArray() as number[])[0]; // 单位是vp
            this.h5Height = (result.getArray() as number[])[1];
            logger.info(TAG, `h5Width = ${this.h5Width}, h5Height = ${this.h5Height}`);
            break;
          default:
            logger.error(TAG, `Get web page size tyep error.`);
            break;
        }
      } catch (e) {
        const err = e as BusinessError;
        logger.error(TAG,
          `Run script to get web page size failed. ErrorCode: ${err.code}, Message: ${err.message}`);
      }
    });
  }

  /**
   * 截图开始前的操作。
   * - 保存网页当前位置，用于恢复状态
   * - 截图当前页面作为遮罩层，避免用户察觉组件的滚动，提高用户体验
   * - Web页面滚动到顶部，准备开始截图
   * - 设置截图后小弹窗的位置，提示用户暂时不要操作，等待截图
   * - 开启提示小弹窗
   */
  async beforeSnapshot() {
    // 保存网页当前位置，用于恢复
    this.xOffsetBefore = this.curXOffset;
    this.yOffsetBefore = this.curYOffset;
    this.h5Height = this.curYOffset + Math.ceil(this.webHeight);
    // TODO: 知识点: 使用componentSnapshot.get接口直接获取组件的渲染结果，而不需要将屏幕截图
    this.webMaskImage = await componentSnapshot.get(Constants.WEB_ID);
    this.webMaskImageZIndex = Constants.MASK_TOP_LAYER;
    this.webviewController.scrollTo(0, 0);
    promptAction.showToast({
      message: $r('app.string.web_page_snap_shot_web_snap_prompt_snapshotting'),
      duration: Constants.PROMPT_SNAPSHOT_DURATION
    });
    this.snapPopupPosition =
      PopupPosition.calculatePopupCenter(this.displayWidth, this.displayHeight, this.snapPopupWidth,
        this.snapPopupHeight)
    this.isShowSnapPopup = true;
    // 延时确保已经滚动到了顶部
    await sleep(Constants.SCROLL_DURATION);
  }

  /**
   * 截图之后的操作。
   * - 恢复web页面到截图之前的位置
   * - 取消遮罩层
   */
  async afterSnapshot() {
    this.webviewController.scrollTo(this.xOffsetBefore, this.yOffsetBefore);
    await sleep(Constants.SCROLL_DURATION);
    this.webMaskImageZIndex = -1;
    this.webMaskImage = undefined;
  }

  /**
   * 生成拼接后图片的操作。用于窗口形成移动的动画。
   */
  async afterGeneratorImage() {
    // 小窗在屏幕中间短暂停留，避免位置突变，无法形成动画
    await sleep(Constants.SCROLL_DURATION);
    // 修改弹窗位置，形成移动动画
    this.snapPopupPosition = PopupPosition.calculatePopupBottomLeft(this.displayHeight, this.snapPopupHeight)
  }

  /**
   * 通过print模块调起系统弹窗，与打印机交互进行打印。
   */
  async webPrint() {
    // TODO: 知识点：通过print模块调起系统弹窗，与打印机交互进行打印。
    try {
      let webPrintDocadapter = this.webviewController.createWebPrintDocumentAdapter('example.pdf');
      print.print('example_jobid', webPrintDocadapter, null, getContext());
    } catch (error) {
      logger.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
    }
  }

  /**
   * 截图预览小窗口。
   */
  @Builder
  previewWindowComponent() {
    Column() {
      // 截图弹窗
      PreviewWindowComponent({
        mergedImage: $mergedImage,
        snapPopupWidth: $snapPopupWidth,
        snapPopupHeight: $snapPopupHeight,
        snapPopupPosition: $snapPopupPosition,
        showPreview: $showPreview,
        isShowSnapPopup: $isShowSnapPopup,
        displayWidth: this.displayWidth,
        displayHeight: this.displayHeight,
      })
    }
  }
}