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
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { componentSnapshot, display, promptAction } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { logger } from '../../utils/Logger';
import { PreviewWindowComponent } from '../viewmodel/PreviewWindowComponent';
import { PopupPosition } from '../model/PopupPosition';
import { Comment, CommentDataSource } from '../model/DataModel';
import { CommentView } from '../viewmodel/CommentView';
import { mockData } from '../mock/ListCommentData';

/**
 * 功能说明：本示例以List组件为例，实现可滚动组件截图、拼接生成长截图功能
 *
 * 推荐场景：可滚动组件需要长截图整个页面、截图至当前位置的场景
 *
 * 核心组件:
 * 1. snapShot - 一键截图，无论滑动到任何为止，均将整个页面截图
 * 2. snapShotToOffset - 滚动截图，实现方式与Web组件截图相同，截图至当前滑到的位置
 *
 * 实现步骤：
 *  1. 滚动截图：实现方式与Web组件截图相同
 *  2. 一键截图：创建截图函数，执行循环滚动截图并拼接
 *  3. 截图后预览：截图后弹出预览窗口，可以滚动查看完整的截图，并保存图片到用户相册中
 *
 */

@Builder
export function ScrollableComponentPageBuilder(name: string, param: Object) {
  ScrollableComponentSnapshotPage()
}

const TAG: string = '[ScrollableComponentSnapshot]:';

@Component
export struct ScrollableComponentSnapshotPage {
  // Navigation路由栈
  pageInfos: NavPathStack = new NavPathStack()
  // List组件展示元素
  private commentData: CommentDataSource = new CommentDataSource();
  private commentArray: Comment[] = [];
  // list长截图尺寸
  @State snapWidth: number = 0;
  @State snapHeight: number = 0;
  // List组件尺寸 单位: vp
  private listComponentWidth: number = 0;
  private listComponentHeight: number = 0;
  // List组件尺寸 单位: px
  private listWidth: number = 0;
  private listHeight: number = 0;
  // 当前List组件位置
  private curXOffset: number = 0;
  private curYOffset: number = 0;
  // 屏幕尺寸
  densityPixels: number = 0; //屏幕像素密度 px = density * vp;
  private displayWidth: number = 0;
  private displayHeight: number = 0;
  // 备份截图前组件位置
  private xOffsetBefore: number = 0;
  private yOffsetBefore: number = 0;
  // 拼接后图片
  @State mergedImage: PixelMap | undefined = undefined;
  // 待拼接图片
  tempPixelMap: PixelMap | undefined = undefined;
  // 截图过程中组件覆盖
  @State componentMaskImage: PixelMap | undefined = undefined;
  private componentMaskImageZIndex: number = -1;
  // 截图后小窗大小
  @State snapPopupWidth: number = Constants.SNAP_WINDOW_WIDTH;
  @State snapPopupHeight: number = Constants.SNAP_WINDOW_HEIGHT;
  @State snapPopupPosition: Position = { x: 0, y: 0 };
  // 是否显示预览窗口
  @State isShowSnapPopup: boolean = false;
  @State showPreview: boolean = false;
  // 指定区域内图片的数据跨距
  private stride: number = 0
  // 滚动组件
  scroller: Scroller = new Scroller();
  // 一键截图滚动过程缓存
  private areaArray: image.PositionArea[] = [];
  // 一键截图滚动过程中每页List组件y方向偏移量
  private scrollOffsets: number[] = [];

  aboutToAppear(): void {
    // 获取屏幕尺寸
    const displayData = display.getDefaultDisplaySync();
    this.densityPixels = displayData.densityPixels;
    this.displayWidth = px2vp(displayData.width);
    this.displayHeight = px2vp(displayData.height);

    // 初始化List组件数据
    this.commentData = mockData();
    this.commentArray = this.commentData.getDataArray();

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
    NavDestination() {
      Column() {
        Row() {
          Text($r('app.string.web_page_snap_shot_scrollable_component_snap_page_title'))
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
          Button($r('app.string.web_page_snap_shot_snapshot_button_title'))
            .width(Constants.BUTTON_WIDTH)
            .height(Constants.BUTTON_HEIGHT)
            .onClick(() => {
              this.snapShot();
            })
          Button($r('app.string.web_page_snap_shot_scrollable_component_snapshot_button_title'))
            .width(Constants.BUTTON_WIDTH)
            .height(Constants.BUTTON_HEIGHT)
            .onClick(() => {
              this.snapShotToOffset();
            })
        }
        .width($r('app.string.web_page_snap_shot_web_snap_full_size'))
        .justifyContent(FlexAlign.SpaceEvenly)

        Stack() {
          // 截图过程的遮罩层，避免用户察觉屏幕快速滑动，提高用户体验
          Image(this.componentMaskImage)
            .width($r('app.string.web_page_snap_shot_web_snap_full_size'))
            .height($r('app.string.web_page_snap_shot_web_snap_full_size'))
            .zIndex(this.componentMaskImageZIndex)
            .visibility(this.componentMaskImage === undefined ? Visibility.None : Visibility.Visible)
            .backgroundColor($r('app.string.web_page_snap_shot_scrollable_component_background_color'))

          List({
            space: Constants.LIST_ELEMENT_VERTICAL_SPACE,
            scroller: this.scroller
          }) {
            /*
            * TODO 性能知识点：列表中数据较多且不确定的情况下，使用LazyForEach进行数据循环渲染。
            * 当组件滑出可视区域外时，框架会进行组件销毁回收以降低内存占用。
            * 文档参考链接：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/arkts-rendering-control-lazyforeach-0000001524417213-V2
            * 案例中使用：ForEach(this.commentArray, (item: Comment) => { ... } 实际业务中建议使用LazyForEach获取迭代数据：LazyForEach(this.commentData, (item: Comment) => { ... }
            */
            ForEach(this.commentArray, (item: Comment) => {
              ListItem() {
                CommentView({ comment: item })
                  .backgroundColor($r('app.string.web_page_snap_shot_list_background_color'))
              }
            }, (item: Comment) => item.id)
          }
          .id(Constants.COMPONENT_ID)
          .listDirection(Axis.Vertical)
          .scrollBar(BarState.Off)
          .friction($r('app.string.web_page_snap_shot_list_scroll_friction'))
          .divider({
            strokeWidth: $r('app.string.web_page_snap_shot_list_divider_stroke_width'),
            color: $r('app.string.web_page_snap_shot_list_background_color'),
            startMargin: $r('app.string.web_page_snap_shot_list_divider_start_end_margin'),
            endMargin: $r('app.string.web_page_snap_shot_list_divider_start_end_margin'),
          }) // List组件分割线配置
          .edgeEffect(EdgeEffect.Spring)
          .width($r('app.string.web_page_snap_shot_web_snap_full_size'))
          .height($r('app.string.web_page_snap_shot_web_snap_full_size'))
          .backgroundColor($r('app.string.web_page_snap_shot_scrollable_component_background_color'))
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
          .onDidScroll(() => {
            this.curYOffset = this.scroller.currentOffset().yOffset;
          })
          .onAreaChange((oldValue, newValue) => {
            // TODO: 高性能知识点: onAreaChange为高频回调，组件变动时每帧都会调用，避免冗余和耗时操作。
            this.listComponentWidth = newValue.width as number; // 单位: vp
            this.listComponentHeight = newValue.height as number; // 单位: vp
            // 初始化长截图宽高
            this.snapWidth = this.listComponentWidth;
            this.snapHeight = this.listComponentHeight
          })
        }
        .width($r('app.string.web_page_snap_shot_web_snap_full_size'))
        .layoutWeight(1)
        .borderRadius($r('app.string.web_page_snap_shot_ohos_id_corner_radius_default_m'))
        .margin({ top: $r('app.string.web_page_snap_shot_ohos_id_corner_radius_default_m') })
        .bindContentCover($$this.isShowSnapPopup, this.previewWindowComponent(), { modalTransition: ModalTransition.NONE })
      }
      .backgroundColor($r('app.string.web_page_snap_shot_scrollable_component_background_color'))
      .alignItems(HorizontalAlign.Center)
      .padding({
        top: $r('app.string.web_page_snap_shot_ohos_id_card_padding_start'),
        left: $r('app.string.web_page_snap_shot_ohos_id_card_padding_start'),
        right: $r('app.string.web_page_snap_shot_ohos_id_card_padding_start')
      })
      .width($r('app.string.web_page_snap_shot_web_snap_full_size'))
      .height($r('app.string.web_page_snap_shot_web_snap_full_size'))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }.title(Constants.COMPONENT_PAGE_TITLE)
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
   * 一键截图。
   */
  async snapShot() {
    // 截图前状态初始化
    await this.beforeSnapshot();
    // 执行循环滚动截图
    this.getPixelMapData();
    // 拼接之后修改可动画变量
    this.afterGeneratorImage();
  }

  /**
   * 一键截图循环滚动截图。
   */
  async getPixelMapData() {
    // 记录滚动量数组
    this.scrollOffsets.push(this.scroller.currentOffset().yOffset);
    // 调用组件截图接口获取当前截图
    componentSnapshot.get(Constants.COMPONENT_ID, async (error: Error, pixmap: PixelMap) => {
      if (this.listWidth === 0) {
        let imageInfo = pixmap.getImageInfoSync();
        this.listWidth = imageInfo.size.width;
        this.listHeight = imageInfo.size.height;
        this.stride = pixmap.getBytesNumberPerRow();
      }
      let bytesNumber = pixmap.getPixelBytesNumber();
      let buffer: ArrayBuffer = new ArrayBuffer(bytesNumber);
      let area: image.PositionArea = {
        pixels: buffer,
        offset: 0,
        stride: this.stride,
        region: { size: { width: this.listWidth, height: this.listHeight }, x: 0, y: 0 }
      }
      // TODO: 知识点: readPixels、readPixelsSync均使用BGRA_8888像素格式，需搭配writePixels、writePixelsSync使用。
      pixmap.readPixelsSync(area);
      this.areaArray.push(area);

      // 循环过程中判断是否到达底部
      if (!this.scroller.isAtEnd()) {
        this.scroller.scrollPage({ next: true });
        await sleep(Constants.SCROLL_DURATION);
        await this.getPixelMapData();
      } else { // 滚动到底部后，通过每轮滚动获取的buffer，拼接生成长截图
        this.gitPixelMap();
        await this.afterSnapshot();
      }
    })
  }

  /**
   * 一键截图拼接函数。
   */
  gitPixelMap() {
    let opts: image.InitializationOptions = {
      editable: true,
      pixelFormat: 4,
      size: {
        width: this.listWidth,
        height: this.scrollOffsets[this.scrollOffsets.length - 1] * this.densityPixels + this.listHeight
      }
    };
    this.mergedImage = image.createPixelMapSync(opts);
    this.tempPixelMap = image.createPixelMapSync(opts);
    for (let i = 0; i < this.areaArray.length; i++) {
      let area: image.PositionArea = {
        pixels: this.areaArray[i].pixels,
        offset: 0,
        stride: this.stride,
        region: {
          size: {
            width: this.listWidth,
            height: this.listHeight
          },
          x: 0,
          y: this.scrollOffsets[i] * this.densityPixels
        }
      }
      this.tempPixelMap?.writePixels(area, (error: BusinessError) => {
        if (error) {
          logger.error('Error: ' + JSON.stringify(error));
        } else {
          logger.info('There is no error when writing image pixel data to the specified area of the PixelMap');
        }
      })
    }
    this.mergedImage = this.tempPixelMap;
  }

  /**
   * 滚动截图。
   */
  async snapShotToOffset() {
    // 记录截图前是否滚动到底部
    const scrollerTouchBottom: boolean = this.scroller.isAtEnd();
    // 截图前状态初始化
    await this.beforeSnapshot();
    // TODO: 性能知识点: 使用Canvas离屏绘制在缓冲区拼接截图
    const canvasSetting: RenderingContextSettings = new RenderingContextSettings(true);
    const offCanvasCtx: OffscreenCanvasRenderingContext2D =
      new OffscreenCanvasRenderingContext2D(this.snapWidth, this.snapHeight, canvasSetting);
    // 前置常量
    // 滚动截图次数
    const snipTimes = Math.ceil(this.snapHeight / this.listComponentHeight);
    logger.info(TAG, `Need to snapshot ${snipTimes} times.`);
    const lastTime = snipTimes - 1;
    // 最后一次截图时的截取高度
    const leftoverHeight = this.snapHeight % this.listComponentHeight;
    // 最后一次截图时的截取区域
    let cropLeftover: image.Region = { x: 0, y: 0, size: { height: 0, width: 0 } }
    if (scrollerTouchBottom) {
      // 这里要分两种情况，1.滚动到底部时，裁剪应该取最后一张除去重复部分以外的底部
      cropLeftover = {
        x: 0,
        y: vp2px(this.listComponentHeight - leftoverHeight),
        size: {
          height: vp2px(leftoverHeight),
          width: vp2px(this.listComponentWidth)
        }
      };
    } else {
      // 2.未滚动到底部时，裁剪应该取最后一张leftoverHeight的上部分
      cropLeftover = {
        x: 0,
        y: 0,
        size: {
          height: vp2px(leftoverHeight),
          width: vp2px(this.listComponentWidth)
        }
      };
    }

    // 开始截图
    for (let i = 0; i < snipTimes; i++) {
      const curSnip = await componentSnapshot.get(Constants.COMPONENT_ID);
      // 最后一次截图需要特殊处理，去除重复部分
      if (i === lastTime) {
        await curSnip.crop(cropLeftover);
        offCanvasCtx.drawImage(curSnip, 0, this.listComponentHeight * i, this.listComponentWidth, leftoverHeight);
      } else {
        offCanvasCtx.drawImage(curSnip, 0, this.listComponentHeight * i, this.listComponentWidth, this.listComponentHeight);
      }
      // debug使用，否则影响性能
      logger.debug(TAG, `Screenshot ${i}: ${JSON.stringify(await curSnip.getImageInfo())}`);
      // 继续滚动
      this.scroller.scrollBy(0, this.listComponentHeight);
      // 延时保证滚动完成
      await sleep(Constants.SCROLL_DURATION);
      // 可滚动组件在最后一次滚动截图时触底，并且开始截图时未触底，需单独处理
      if (this.scroller.isAtEnd() && !scrollerTouchBottom) {
        cropLeftover.y = vp2px(this.listComponentHeight - leftoverHeight - (this.curYOffset - this.yOffsetBefore));
        logger.debug(TAG, `cropLeftover y ${cropLeftover.y}`);
      }
    }
    // 截图后的操作
    await this.afterSnapshot();
    // 获取pixelMap
    this.mergedImage = offCanvasCtx.getPixelMap(0, 0, this.snapWidth, this.snapHeight);
    // 拼接之后修改可动画变量
    this.afterGeneratorImage();
  }

  /**
   * 截图开始前的操作。
   * - 保存滚动组件当前位置，用于恢复状态
   * - 截图当前页面作为遮罩层，避免用户察觉组件的滚动，提高用户体验
   * - 滚动组件页面滚动到顶部，准备开始截图
   * - 设置截图后小弹窗的位置，提示用户暂时不要操作，等待截图
   * - 开启提示小弹窗
   */
  async beforeSnapshot() {
    // 保存组件当前位置，用于恢复
    this.xOffsetBefore = this.curXOffset;
    this.yOffsetBefore = this.curYOffset;
    this.snapHeight = this.curYOffset + Math.ceil(this.listComponentHeight);

    // TODO: 知识点: 使用componentSnapshot.get接口直接获取组件的渲染结果，而不需要将屏幕截图
    this.componentMaskImage = await componentSnapshot.get(Constants.COMPONENT_ID);
    this.componentMaskImageZIndex = Constants.MASK_TOP_LAYER;
    this.scroller.scrollTo({ xOffset: 0, yOffset: 0 });
    // 底部提示条
    promptAction.showToast({
      message: $r('app.string.web_page_snap_shot_web_snap_prompt_snapshotting'),
      duration: Constants.PROMPT_SNAPSHOT_DURATION
    });
    // 设置提示弹窗位置为居中
    this.snapPopupPosition =
      PopupPosition.calculatePopupCenter(this.displayWidth, this.displayHeight, this.snapPopupWidth,
        this.snapPopupHeight)
    // 开启提示弹窗
    this.isShowSnapPopup = true;
    // 延时确保已经滚动到了顶部
    await sleep(Constants.SCROLL_DURATION);
  }

  /**
   * 截图之后的操作。
   * - 恢复滚动组件页面到截图之前的位置
   * - 取消遮罩层
   */
  async afterSnapshot() {
    this.scroller.scrollTo({ xOffset: this.xOffsetBefore, yOffset: this.yOffsetBefore });
    await sleep(Constants.SCROLL_DURATION);
    this.componentMaskImageZIndex = -1;
    this.componentMaskImage = undefined;
  }

  /**
   * 生成拼接后图片的操作。用于窗口形成移动的动画。
   */
  async afterGeneratorImage() {
    // 小窗在屏幕中间短暂停留，避免位置突变，无法形成动画
    await sleep(Constants.SCROLL_DURATION);
    // 修改弹窗位置为左下，形成移动动画
    this.snapPopupPosition = PopupPosition.calculatePopupBottomLeft(this.displayHeight, this.snapPopupHeight)
  }

  /**
   * 截图预览小窗口。
   */
  @Builder
  previewWindowComponent() {
    Column() {
      // 预览小窗组件
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