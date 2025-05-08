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
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import fs from '@ohos.file.fs';
import { logger } from '../../utils/Logger';
import { PopupPosition } from '../model/PopupPosition';

const TAG: string = '[PreviewWindowComponent]:';

/**
 * 预览小窗口组件。
 */
@Component
export struct PreviewWindowComponent {
  private context: Context = getContext(this);
  // 截图后生成的图片，与父组件双向同步
  @Link mergedImage: PixelMap | undefined;
  // 截图后小窗大小，与父组件双向同步
  @Link snapPopupWidth: number;
  @Link snapPopupHeight: number;
  @Link snapPopupPosition: Position;
  // 是否显示预览窗口，与父组件双向同步
  @Link @Watch('onShowChanged') isShowSnapPopup: boolean;
  @Link showPreview: boolean;
  // 屏幕尺寸
  displayWidth: number = 0;
  displayHeight: number = 0;
  // 侧滑手势
  private panOption: PanGestureOptions = new PanGestureOptions({
    direction: PanDirection.Left | PanDirection.Right,
    distance: 5
  });
  // 保存侧滑前的位置信息
  private xPositionBefore: number = 0;
  // 预览浮窗 Scroll 控制器
  private previewerScroller: Scroller = new Scroller();
  private previewerScrollYOffset: number = 0;

  build() {
    this.screenShotPopup();
  }

  /**
   * 截图时预览小窗口弹窗。
   */
  @Builder
  screenShotPopup() {
    Column() {
      // 长截图未生成前显示提示语，生成后显示预览窗格
      if (this.mergedImage) {
        this.previewWindow();
      } else {
        // 提示截图中的弹窗
        Text($r('app.string.web_page_snap_shot_web_snap_popup_prompt_snapshotting'))
          .backgroundColor($r('app.string.web_page_snap_shot_web_snap_text_popup_backgroundcolor'))
          .borderRadius(Constants.BORDER_RADIUS)
          .width(Constants.TEXT_POPUP_WIDTH)
          .height(Constants.TEXT_POPUP_HEIGHT)
          .padding(Constants.TEXT_POPUP_PADDING)
      }
    }
    .width($r('app.string.web_page_snap_shot_web_snap_full_size'))
    .height(($r('app.string.web_page_snap_shot_web_snap_full_size')))
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      // 点击弹窗周围，缩小中间预览大窗到左下角
      if (this.showPreview) {
        this.snapPopupWidth = Constants.SNAP_WINDOW_WIDTH;
        this.snapPopupHeight = Constants.SNAP_WINDOW_HEIGHT;
        this.snapPopupPosition = PopupPosition.calculatePopupBottomLeft(this.displayHeight, this.snapPopupHeight)
        this.previewerScroller.scrollTo({
          xOffset: 0,
          yOffset: this.previewerScrollYOffset *= (Constants.SNAP_WINDOW_WIDTH / Constants.SNAP_LARGE_WINDOW_WIDTH)
        });
        this.showPreview = false;
      }
    })
  }

  /**
   * 截图后的预览窗口。
   */
  @Builder
  previewWindow() {
    Stack({ alignContent: Alignment.Bottom }) {
      // 预览图片小窗
      this.previewSnapshot();
      // 保存按钮，预览大图时才显示
      this.buttonBar();
    }
    .width(this.snapPopupWidth)
    .height(this.snapPopupHeight)
    .position(this.snapPopupPosition)
    .border({
      width: Constants.BORDER_WIDTH,
      color: Constants.BORDER_COLOR,
      radius: Constants.BORDER_RADIUS
    })
    .animation({
      duration: Constants.ANIMATE_DURATION,
      curve: Curve.Friction
    })
    .gesture(
      PanGesture(this.panOption)
        .onActionStart(() => {
          this.xPositionBefore = this.snapPopupPosition.x as number;
        })
        .onActionUpdate((event) => {
          logger.debug(TAG, `Pan gesture offsetX: ${event.offsetX}.`);
          // 左滑弹窗关闭，但允许向右滑动一小部分，形成弹性效果，提升操作手感
          if (event.offsetX < Constants.POPUP_RIGHT_PAN_GESTURE) {
            this.snapPopupPosition.x = this.xPositionBefore + event.offsetX;
          }
        })
        .onActionEnd((event) => {
          // 左滑超过一定阈值才会触发关闭弹窗，提升用户体验
          if (event.offsetX < Constants.POPUP_LEFT_PAN_GESTURE && !this.showPreview) {
            logger.debug(TAG, `Colse popup offsetX: ${event.offsetX}.`);
            // 避免瞬间消失，而是平移动画后消失
            this.snapPopupPosition.x = Constants.POPUP_LEFT_SCREEN;
            sleep(Constants.ANIMATE_DURATION).then(() => {
              this.isShowSnapPopup = false;
            })
          } else if (!this.showPreview) {
            // 小窗预览时，右滑或者左滑没有达到阈值时恢复弹窗位置，结合动画属性形成弹性效果
            this.snapPopupPosition = PopupPosition.calculatePopupBottomLeft(this.displayHeight, this.snapPopupHeight)
          }
        })
    )
  }

  /**
   * 滚动查看图片的组件。
   */
  @Builder
  previewSnapshot() {
    Scroll(this.previewerScroller) {
      Column() {
        Image(this.mergedImage)
          .objectFit(ImageFit.Auto)
          .width(this.snapPopupWidth)
          .borderRadius(Constants.BORDER_RADIUS)
          .animation({
            duration: Constants.ANIMATE_DURATION,
            curve: Curve.Friction
          })
          .id('web_page_snap_shot_preview_component')
          .onClick(() => {
            // 点击打开预览大窗
            if (!this.showPreview) {
              this.snapPopupWidth = Constants.SNAP_LARGE_WINDOW_WIDTH;
              this.snapPopupHeight = Constants.SNAP_LARGE_WINDOW_HEIGHT;
              this.snapPopupPosition =
                PopupPosition.calculatePopupCenter(this.displayWidth, this.displayHeight, this.snapPopupWidth,
                  this.snapPopupHeight)
              this.previewerScroller.scrollTo({
                xOffset: 0,
                yOffset: this.previewerScrollYOffset *= (Constants.SNAP_LARGE_WINDOW_WIDTH /
                Constants.SNAP_WINDOW_WIDTH)
              });
              this.showPreview = true;
            }
          })
      }
      .borderRadius(Constants.BORDER_RADIUS)
    }
    .width($r('app.string.web_page_snap_shot_web_snap_full_size'))
    .height($r('app.string.web_page_snap_shot_web_snap_full_size'))
    .padding({ bottom: Constants.BUTTON_BAR_HEIGHT })
    .scrollBar(BarState.Off)
    .onWillScroll(() => {
      this.previewerScrollYOffset = this.previewerScroller.currentOffset().yOffset;
    })
  }

  /**
   * 保存或取消保存的操作栏。
   */
  @Builder
  buttonBar() {
    Row() {
      SaveButton({
        icon: SaveIconStyle.FULL_FILLED,
        text: SaveDescription.SAVE_IMAGE,
        buttonType: ButtonType.Capsule
      })
        .onClick(async (event, result) => {
          this.saveSnapshot(result);
        })
        .padding({
          left: Constants.BUTTON_BAR_PADDING,
          right: Constants.BUTTON_BAR_PADDING
        })
        .width(Constants.SAVE_BUTTON_WIDTH)

      Button($r('app.string.web_page_snap_shot_web_snap_cancel'))
        .width(Constants.BUTTON_WIDTH)
        .onClick(() => {
          // 恢复一切状态
          this.closeSnapPopup();
        })
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .width(this.snapPopupWidth)
    .height(Constants.BUTTON_BAR_HEIGHT)
    .padding({
      top: Constants.BUTTON_BAR_PADDING,
      bottom: Constants.BUTTON_BAR_PADDING
    })
    .backgroundColor($r('app.string.web_page_snap_shot_web_snap_window_bottom_backgrounp_color'))
    .animation({
      duration: Constants.ANIMATE_DURATION,
      curve: Curve.Friction
    })
    .borderRadius({
      bottomLeft: Constants.BORDER_RADIUS,
      bottomRight: Constants.BORDER_RADIUS
    })
    .transition(TransitionEffect.OPACITY.animation({
      duration: Constants.ANIMATE_DURATION,
      curve: Curve.Ease
    })
      .combine(TransitionEffect.scale({ y: Constants.BUTTON_BAR_SCALE }))
    )
    .visibility(this.showPreview ? Visibility.Visible : Visibility.Hidden)
  }

  /**
   * 保存图片到相册。
   */
  async saveSnapshot(result: SaveButtonOnClickResult) {
    // TODO: 知识点：使用SaveButton组件可以免申请权限，用户点击后，临时将文件存入系统目录
    if (result === SaveButtonOnClickResult.SUCCESS) {
      const helper = photoAccessHelper.getPhotoAccessHelper(this.context);
      // 使用保存控件
      try {
        // onClick触发后10秒内通过createAsset接口创建图片文件，10秒后createAsset权限收回。
        const uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'png');
        // 使用uri打开文件，可以持续写入内容，写入过程不受时间限制
        const file = await fs.open(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        const imagePackerApi: image.ImagePacker = image.createImagePacker();
        const packOpts: image.PackingOption = {
          format: Constants.SAVE_IMAGE_FORMAT,
          quality: Constants.SAVE_IMAGE_QUALITY,
        };
        imagePackerApi.packing(this.mergedImage, packOpts).then((data) => {
          fs.writeSync(file.fd, data);
          fs.closeSync(file.fd);
          logger.info(TAG, `Succeeded in packToFile`);
          promptAction.showToast({
            message: $r('app.string.web_page_snap_shot_web_snap_saved_to_album'),
            duration: Constants.SAVED_TO_ALBUM_PROMPT_DURATION
          })
        }).catch((error: BusinessError) => {
          logger.error(TAG, `Failed to packToFile. Error code is ${error.code}, message is ${error.message}`);
        });
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        logger.error(TAG, `Failed to save photo. Error code is ${err.code}, message is ${err.message}`);
      }
    } else {
      // 设置权限失败
      promptAction.showToast({
        message: $r('app.string.web_page_snap_shot_web_snap_saved_to_album_fail')
      })
    }
    this.closeSnapPopup();
  }

  /**
   * 关闭截图弹窗，恢复状态。
   */
  closeSnapPopup() {
    this.isShowSnapPopup = false; // 关闭模态窗口
    this.mergedImage = undefined; // 清除合并的图片
    this.snapPopupWidth = Constants.SNAP_WINDOW_WIDTH; // 恢复窗口大小
    this.snapPopupHeight = Constants.SNAP_WINDOW_HEIGHT;
    this.snapPopupPosition =
      PopupPosition.calculatePopupCenter(this.displayWidth, this.displayHeight, this.snapPopupWidth,
        this.snapPopupHeight); // 窗口归位居中
    this.showPreview = false; // 缩小弹窗下，关闭按钮
  }

  /**
   * 当侧滑返回时，恢复初始状态。
   * 全屏模态窗口无法捕获返回键/右滑返回的事件，
   * 所以监听全屏模态窗口显隐flag捕获返回事件
   */
  onShowChanged() {
    if (this.isShowSnapPopup === false) {
      this.closeSnapPopup();
    }
  }
}