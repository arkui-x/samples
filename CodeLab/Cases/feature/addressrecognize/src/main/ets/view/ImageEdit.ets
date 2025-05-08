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

import image from '@ohos.multimedia.image';
import { RectPosition, ActionType, Position, InitPosition } from '../models/Bean'
import fs from '@ohos.file.fs';
import { getScreenWidth } from '../utils/WindowUtil';
import { DialogBuilderParam } from '@lvnanqing/lvdialog';
import { CommonConstants } from '../common/CommonConstants';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct ImageEdit {
  @Prop param: DialogBuilderParam;
  @Provide pixelMap: image.PixelMap | undefined = undefined;
  @Provide imageInfo: image.ImageInfo | undefined = undefined;
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private settings2: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasContext2: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings2);
  private actionType: ActionType = ActionType.move;
  private screenWidth: number = getScreenWidth();
  private touchPosition: Position = {
    x: 0,
    y: 0,
  };
  private initPosition: InitPosition = {
    x: 0,
    y: 0,
    width: 0,
    height: 0,
  }
  @State @Watch('drawMask') clipRect: RectPosition = {
    x: 0,
    y: 0,
    height: 0,
    width: 0
  };

  aboutToAppear(): void {
    this.initData();
  }

  /**
   * 裁剪框位置和大小变化，初始位置为图片的初始坐标，移动的坐标
   * @param moveX
   * @param moveY
   */
  moveClipCanvas(moveX: number, moveY: number) {
    let clipRect: RectPosition = {
      x: this.clipRect.x,
      y: this.clipRect.y,
      width: this.clipRect.width,
      height: this.clipRect.height
    }
    switch (this.actionType) {
      case ActionType.move:
        clipRect.x += moveX;
        clipRect.y += moveY;
        break;
      case ActionType.topLeft:
        clipRect.x += moveX;
        clipRect.y += moveY;
        clipRect.width += -moveX;
        clipRect.height += -moveY;
        break;
      case ActionType.topRight:
        clipRect.y += moveY;
        clipRect.width += moveX;
        clipRect.height += -moveY;
        break;
      case ActionType.bottomLeft:
        clipRect.x += moveX;
        clipRect.width += -moveX;
        clipRect.height += moveY;
        break;
      case ActionType.bottomRight:
        clipRect.width += moveX;
        clipRect.height += moveY;
        break;
      default:
        break;
    }

    // 偏移坐标小于初始位置
    if (clipRect.x < this.initPosition.x) {
      clipRect.x = this.initPosition.x;
    }
    if (clipRect.y < this.initPosition.y) {
      clipRect.y = this.initPosition.y;
    }
    // 横坐标限制位置
    if (clipRect.width + clipRect.x > this.initPosition.width + this.initPosition.x) {
      if (this.actionType === ActionType.move) {
        clipRect.x = this.initPosition.width + this.initPosition.x - clipRect.width;
      } else {
        clipRect.width = this.initPosition.width + this.initPosition.x - clipRect.x;
      }
    }
    // 纵坐标限制
    if (clipRect.height + clipRect.y > this.initPosition.height + this.initPosition.y) {
      if (this.actionType === ActionType.move) {
        clipRect.y = this.initPosition.height + this.initPosition.y - clipRect.height;
      } else {
        clipRect.height = this.initPosition.height + this.initPosition.y - clipRect.y;
      }
    }
    this.clipRect = {
      x: Math.round(clipRect.x),
      y: Math.round(clipRect.y),
      width: Math.round(clipRect.width),
      height: Math.round(clipRect.height)
    };
  }

  /**
   * 取消剪切
   */
  cancel() {
    this.param.closeDialog!();
  }

  /**
   * 绘制蒙层
   */
  drawMask() {
    this.canvasContext2.clearRect(0, 0, this.imageInfo?.size.width, this.imageInfo?.size.height);
    this.canvasContext2.fillStyle = 'rgba(0,0,0,0.7)';
    this.canvasContext2.fillRect(0, 0, px2vp(this.imageInfo?.size.width), px2vp(this.imageInfo?.size.height));
    this.canvasContext2.clearRect(this.clipRect.x - this.initPosition.x, this.clipRect.y - this.initPosition.y,
      this.clipRect.width, this.clipRect.height);
  }

  /**
   * 初始化裁剪图片
   */
  async initData() {
    fs.open(this.param.data.uri, fs.OpenMode.READ_ONLY).then(async (file) => {
      const imageSource: image.ImageSource = image.createImageSource(file.fd);
      let decodingOptions: image.DecodingOptions = {
        editable: true,
        desiredPixelFormat: 3
      }
      imageSource.createPixelMap(decodingOptions).then((pixelMap) => {
        pixelMap.getImageInfo().then((imageInfo) => {
          this.imageInfo = imageInfo;
          this.pixelMap = pixelMap;
          // 裁剪框初始位置
          this.initPosition.width = px2vp(Math.round(this.imageInfo.size.width));
          this.initPosition.height = px2vp(Math.round(this.imageInfo.size.height));
          this.clipRect.height = px2vp(this.imageInfo.size.height / 4);
          this.clipRect.width = px2vp(this.screenWidth);
          this.clipRect.x = this.initPosition.x;
          this.clipRect.y = this.initPosition.y;
        })
      })
    });
  }

  /**
   * 绘制裁剪框
   */
  drawClipImage() {
    this.canvasContext.clearRect(0, 0, this.clipRect.width, this.clipRect.height);
    this.canvasContext.lineWidth = 6;
    this.canvasContext.strokeStyle = '#3299cc';
    this.canvasContext.beginPath();

    this.canvasContext.moveTo(0, 20);
    this.canvasContext.lineTo(0, 0);
    this.canvasContext.lineTo(20, 0);

    this.canvasContext.moveTo(this.clipRect.width - 20, 0);
    this.canvasContext.lineTo(this.clipRect.width, 0);
    this.canvasContext.lineTo(this.clipRect.width, 20);

    this.canvasContext.moveTo(0, this.clipRect.height - 20);
    this.canvasContext.lineTo(0, this.clipRect.height);
    this.canvasContext.lineTo(20, this.clipRect.height);

    this.canvasContext.moveTo(this.clipRect.width - 20, this.clipRect.height);
    this.canvasContext.lineTo(this.clipRect.width, this.clipRect.height);
    this.canvasContext.lineTo(this.clipRect.width, this.clipRect.height - 20);
    this.canvasContext.stroke();

    this.canvasContext.beginPath();
    this.canvasContext.lineWidth = 0.5;
    let height = Math.round(this.clipRect.height / 3);
    for (let index = 0; index <= 3; index++) {
      let y = index === 3 ? this.clipRect.height : height * index;
      this.canvasContext.moveTo(0, y);
      this.canvasContext.lineTo(this.clipRect.width, y);
    }
    let width = Math.round(this.clipRect.width / 3);
    for (let index = 0; index <= 3; index++) {
      let x = index === 3 ? this.clipRect.width : width * index;
      this.canvasContext.moveTo(x, 0);
      this.canvasContext.lineTo(x, this.clipRect.height);
    }
    this.canvasContext.stroke();
  }

  /**
   * 裁剪图片
   */
  async clipImage() {
    let x = this.clipRect.x - this.initPosition.x;
    let y = this.clipRect.y - this.initPosition.y;
    this.pixelMap?.crop({
      x: vp2px(x),
      y: vp2px(y),
      size: { height: vp2px(this.clipRect.height), width: vp2px(this.clipRect.width) }
    }).then(() => {
      this.param.onConfirm!(true, this.pixelMap);
    }).catch((error: BusinessError) => {
      if (error) {
        console.error(`Error: Image cropping failed. ErrorCode is ${error.code}, errorMessage is ${error.message}`);
      }
    })
  }

  /**
   * 判断操作类型
   * @param area
   * @param touch
   */
  isMove(area: Area, touch: TouchObject) {
    if (touch.x < 60 && touch.y < 60) {
      // 左上角
      this.actionType = ActionType.topLeft;
    } else if (touch.x < 60 && touch.y > (Number(area.height) - 60)) {
      // 左下
      this.actionType = ActionType.bottomLeft;
    } else if (touch.x > Number(area.width) - 60 && touch.y < 60) {
      // 右上
      this.actionType = ActionType.topRight;
    } else if (touch.x > Number(area.width) - 60 && touch.y > (Number(area.height) - 60)) {
      // 右下
      this.actionType = ActionType.bottomRight;
    } else {
      this.actionType = ActionType.move;
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Image(this.pixelMap)
        .width($r('app.string.addressrecognize_width_percent_full'))
        .height($r('app.string.addressrecognize_width_percent_full'))
        .objectFit(ImageFit.Contain)
      // 蒙层
      Canvas(this.canvasContext2)
        .position({
          x: this.initPosition.x,
          y: this.initPosition.y
        })
        .width(px2vp(this.imageInfo?.size.width))
        .height(px2vp(this.imageInfo?.size.height))
      // 裁剪框
      Canvas(this.canvasContext)
        .position({
          x: this.clipRect.x,
          y: this.clipRect.y
        })
        .width(this.clipRect.width)
        .height(this.clipRect.height)
        .onReady(() => {
          this.drawClipImage()
        })
        .onTouch(event => {
          if (event.type === TouchType.Down) {
            this.isMove(event.target.area, event.touches[0]);
            this.touchPosition = {
              x: event.touches[0].screenX,
              y: event.touches[0].screenY
            }
          } else if (event.type === TouchType.Move) {
            let moveX = event.changedTouches[0].screenX - this.touchPosition.x;
            let moveY = event.changedTouches[0].screenY - this.touchPosition.y;
            this.touchPosition = {
              x: event.changedTouches[0].screenX,
              y: event.changedTouches[0].screenY
            }
            this.moveClipCanvas(moveX, moveY);
          }
        })
      Row() {
        Text($r('app.string.addressrecognize_cancel_button'))
          .width($r('app.integer.addressrecognize_length_forty'))
          .height($r('app.integer.addressrecognize_length_forty'))
          .fontColor(Color.White)
          .onClick(() => {
            this.cancel();
          })
        Text($r('app.string.addressrecognize_complete_button'))
          .width($r('app.integer.addressrecognize_length_forty'))
          .height($r('app.integer.addressrecognize_length_forty'))
          .fontColor(Color.White)
          .onClick(() => {
            this.clipImage();
          })
      }
      .margin({ top: $r('app.integer.addressrecognize_length_ten') })
      .width($r('app.string.addressrecognize_width_percent_full'))
      .height($r('app.string.addressrecognize_image_edit_bottom_percent'))
      .padding({
        left: $r('app.integer.addressrecognize_length_thirty'),
        right: $r('app.integer.addressrecognize_length_thirty'),
        top: $r('app.integer.addressrecognize_length_twenty'),
        bottom: this.param.data.bottomHeight + CommonConstants.BOTTOM_MARGIN
      })
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width($r('app.string.addressrecognize_width_percent_full'))
    .height($r('app.string.addressrecognize_size_percent_ninety'))
    .backgroundColor($r('sys.color.black'))
  }
}