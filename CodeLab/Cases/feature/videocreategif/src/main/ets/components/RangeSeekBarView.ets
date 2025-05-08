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

import { logger } from '../util/Logger';
import { getTimeString } from '../util/TimeTools';

export interface RangeSeekBarListener {
  onRangeSeekBarValuesChanged: (minValue: number, maxValue: number) => void;
}

enum TouchType {
  NONE,
  TouchLeftThumb,
  TouchRightThumb,
  TouchMiddleThumb
}

/**
 * 时间轴选中框
 */
@Component
export struct RangeSeekBarView {
  /************************ 必传参数 *********************************/
  @Watch('watchProgress') @Link progress: number;  // 播放进度
  private maxTime: number = 10;                    // 最大时间间隔，单位秒
  private minTime: number = 5;                     // 最小时间间隔，单位秒
  private startTime: number = 0;                   // 开始时间，单位毫秒
  private currentStartTime: number = 0;            // 当前选取的开始时间，单位毫秒
  private currentEndTime: number = 0;              // 当前选取的结束时间，单位毫秒
  private countRange: number = 0;                  // 可选取的片段数
  private thumbWidth: number = 12;                 // 可滑动条状物的宽度
  private rangeSeekBarListener?: RangeSeekBarListener;
  /*******************************************************************/

  private leftThumbWidth: number = 12;       // 左侧可滑动条状物的宽度
  private rightThumbWidth: number = 12;      // 右侧可滑动条状物的宽度
  private topPaddingWidth: number = 5;       // 顶部间距宽度
  private bottomPaddingWidth: number = 5;    // 底部间距宽度

  @State transparentWidth: number = 0;       // 左侧可滑动条状物的右端和右侧可滑动条状物的左端的间距
  @State seekCompWidth: number = 0;          // 可滑动区域的宽度
  @State seekCompHeight: number = 0;         // 可滑动区域的高度
  private componentMaxWidth: number = 0;     // 组件的最大宽度
  private componentMaxHeight: number = 0;    // 组件的最大高度

  @State componentRect: number[] = [];       // 组件的区域，数组的值分别代表左上右下
  @State leftThumbRect: number[] = [];       // 左侧可滑动条状物的区域，数组的值分别代表左上右下
  @State rightThumbRect: number[] = [];      // 右侧可滑动条状物的区域，数组的值分别代表左上右下

  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Left | PanDirection.Right });
  private touchType: TouchType = TouchType.NONE;  // 触摸触发的类型
  private touchXOld = 0;                                    // 记录前一次触摸的x位置

  @State leftThumbPosition: Position = { x: 0, y: 0 };     // 左边可滑动条状物的位置
  @State rightThumbPosition: Position = { x: 0, y: 0 };    // 右边可滑动条状物的位置
  @State middenPosition: Position = { x: 0, y: 0 };        // 左右滑动之间部分的位置
  @State progressLinePosition: Position = { x: 0, y: 0 };  // 进度线的位置

  private leftPadding = 0;          // 左边可滑动条状物的左边间距
  private rightPadding = 0;         // 右边可滑动条状物的右边间距
  private minLeftRightPadding = 0;  // 左右可滑动条状物之间的最小间距
  private maxLeftRightPadding = 0;  // 左右可滑动条状物之间的最大间距

  private widthPerSecond: number = 0;  // 1秒钟所占的vp宽度

  @State leftText: string = '00:00:00';      // 左边可滑动条状物对应的时间
  @State rightText: string = '00:00:00';     // 右边可滑动条状物对应的时间
  @State leftTextPosition: Position = { x: 0, y: 0 };  // 左边可滑动条状物对应的时间的位置
  @State rightTextPosition: Position = { x: 0, y: 0 }; // 右边可滑动条状物对应的时间的位置
  private leftTextWidth: number = 60;        // 左边可滑动条状物对应的时间组件的宽度
  private rightTextWidth: number = 60;       // 右边可滑动条状物对应的时间组件的宽度

  watchProgress() {
    this.progressLinePosition = {
      x: this.leftThumbRect[2] + this.transparentWidth * this.progress,
      y: this.topPaddingWidth
    };
  }

  aboutToAppear() {
    this.leftThumbWidth = this.thumbWidth;
    this.rightThumbWidth = this.thumbWidth;
  }

  build() {
    Column() {
      Stack() {
        Text(this.leftText)
          .width(this.leftTextWidth)
          .height($r('app.string.video_create_gif_full_width'))
          .textAlign(TextAlign.Start)
          .position(this.leftTextPosition)
          .fontSize($r('app.integer.video_create_gif_small_font_size'))
          .fontColor(Color.White)

        Text(this.rightText)
          .width(this.rightTextWidth)
          .height($r('app.string.video_create_gif_full_width'))
          .textAlign(TextAlign.End)
          .position(this.rightTextPosition)
          .fontSize($r('app.integer.video_create_gif_small_font_size'))
          .fontColor(Color.White)
      }
      .width(this.seekCompWidth)
      .height($r('app.integer.video_create_gif_select_gif_time_seek_bar_time_height'))

      Stack() {
        Flex({
          justifyContent: FlexAlign.SpaceBetween,
          direction: FlexDirection.Column
        }) {
          Row() {

          }
          .width($r('app.string.video_create_gif_full_width'))
          .height(this.topPaddingWidth)
          .backgroundColor(Color.White)

          Row() {

          }
          .width($r('app.string.video_create_gif_full_width'))
          .height(this.bottomPaddingWidth)
          .backgroundColor(Color.White)
        }
        .width(this.transparentWidth)
        .height($r('app.string.video_create_gif_full_width'))
        .backgroundColor(Color.Transparent)
        .position(this.middenPosition)

        // 播放进度线
        Divider()
        .vertical(true)
        .strokeWidth(2)
        .height(this.seekCompHeight - this.topPaddingWidth - this.bottomPaddingWidth)
        .backgroundColor(Color.Green)
        .position(this.progressLinePosition)

        Image($r("app.media.video_create_gif_thumb_handle"))
          .objectFit(ImageFit.Fill)
          .width(this.leftThumbWidth)
          .height($r('app.string.video_create_gif_full_width'))
          .position(this.leftThumbPosition)
          .id("left_gif_thumb_handle")

        Image($r("app.media.video_create_gif_thumb_handle"))
          .objectFit(ImageFit.Fill)
          .width(this.leftThumbWidth)
          .height($r('app.string.video_create_gif_full_width'))
          .position(this.rightThumbPosition)
          .id("right_gif_thumb_handle")

        // 左侧阴影蒙层
        Row() {

        }
        .width(this.leftThumbPosition.x)
        .position({x: 0, y: 0})
        .height($r('app.string.video_create_gif_full_width'))
        .backgroundColor($r('app.color.video_create_gif_button_background_color'))

        // 右侧阴影蒙层
        Row() {

        }
        .width(this.componentMaxWidth - (this.rightThumbPosition.x as number) - this.rightThumbWidth)
        .position({x: (this.rightThumbPosition.x as number) + this.rightThumbWidth, y: 0})
        .height($r('app.string.video_create_gif_full_width'))
        .backgroundColor($r('app.color.video_create_gif_button_background_color'))
      }
      .width(this.seekCompWidth)
      .layoutWeight(1)
      .onAreaChange((oldValue, newValue) => {
        this.seekCompHeight = newValue.height as number;
      })
    }
    .width($r('app.string.video_create_gif_full_width'))
    .height($r('app.string.video_create_gif_full_width'))
    .onAreaChange((oldValue, newValue) => {
      this.componentMaxWidth = newValue.width as number;
      this.componentMaxHeight = newValue.height as number;
      this.initUIRange();
    })
    .parallelGesture(
      PanGesture(this.panOption)
        .onActionStart((event?: GestureEvent) => {
          if (this.touchInThumb(event)) {
            if (this.touchInLeftThumb(event)) {
              this.touchType = TouchType.TouchLeftThumb;
            } else if (this.touchInRightThumb(event)) {
              this.touchType = TouchType.TouchRightThumb;
            } else if (this.touchInMiddleThumb(event)) {
              this.touchType = TouchType.TouchMiddleThumb;
            }
          }

          this.touchXOld = this.clearUndefined(event?.offsetX);
        })
        .onActionUpdate((event?: GestureEvent) => {
          let touchXNew:number = this.clearUndefined(event?.offsetX);
          let deltaX:number = touchXNew - this.touchXOld;
          if (this.touchType == TouchType.TouchLeftThumb) {
            this.leftThumbUpdate(deltaX);
            this.onRangeValueChanged();
          } else if (this.touchType == TouchType.TouchRightThumb) {
            this.rightThumbUpdate(deltaX);
            this.onRangeValueChanged();
          } else if (this.touchType == TouchType.TouchMiddleThumb) {
            if ((deltaX < 0 && this.leftThumbRect[0] > 0)
                  || (deltaX > 0 && this.rightThumbRect[2] < this.componentMaxWidth)) {
              this.leftThumbUpdate(deltaX);
              this.rightThumbUpdate(deltaX);
              this.onRangeValueChanged();
            }
          }

          this.touchXOld = this.clearUndefined(event?.offsetX);
        })
        .onActionEnd((event?: GestureEvent) => {
          this.touchType = TouchType.NONE;
        })
    )
  }

  /**
   * 左边条状物被滑动时的位置处理
   * @param deltaX
   */
  leftThumbUpdate(deltaX: number) {
    let deltaPx = deltaX;
    // 左边距
    if (deltaPx <= 0 && ((this.leftThumbRect[0] + deltaPx) <= this.leftPadding)) {
      deltaPx = this.leftPadding - this.leftThumbRect[0];
    }

    // 右边距
    if (deltaPx >= 0 && ((this.leftThumbRect[2] + deltaPx) >= (this.rightThumbRect[0] - this.minLeftRightPadding))) {
      deltaPx = (this.rightThumbRect[0] - this.minLeftRightPadding) - this.leftThumbRect[2];
    }

    // 左边界 新增与右thumb的最大边距
    if (deltaPx <= 0 && ((this.leftThumbRect[2] + deltaPx) <= (this.rightThumbRect[0] - this.maxLeftRightPadding))) {
      deltaPx = (this.rightThumbRect[0] - this.maxLeftRightPadding) - this.leftThumbRect[2];
    }

    let newArea = [(this.leftThumbRect[0] + deltaPx), this.leftThumbRect[1], (this.leftThumbRect[2] + deltaPx),
                      this.leftThumbRect[3]];

    this.leftThumbRect = newArea;
    this.leftThumbPosition = { x: newArea[0], y: newArea[1] };
    this.leftTextPosition = { x: newArea[0], y: newArea[1] };

    this.middenPosition = { x: this.leftThumbRect[2], y: this.leftThumbRect[1] };
    this.transparentWidth = this.rightThumbRect[0] - this.leftThumbRect[2];
  }

  /**
   * 设置条状物对应的时间
   * @param time
   * @returns
   */
  showThumbText(time: number): string {
    return getTimeString(time);
  }

  /**
   * 选取范围改变回调处理
   */
  onRangeValueChanged() {
    let start:number = this.leftThumbRect[2] - this.leftThumbWidth;

    if (start < 0) {
      start = 0;
    }
    let end:number = start + this.transparentWidth;

    let startTime:number = start * 1000 / this.widthPerSecond;
    this.leftText = this.showThumbText(startTime + this.startTime);
    let endTime:number = end * 1000 / this.widthPerSecond;
    this.rightText = this.showThumbText(endTime + this.startTime);

    if (this.rangeSeekBarListener) {
      this.rangeSeekBarListener.onRangeSeekBarValuesChanged(startTime + this.startTime, endTime + this.startTime);
    }
  }

  /**
   * 右边条状物被滑动时的位置处理
   * @param deltaX
   */
  rightThumbUpdate(deltaX: number) {
    let deltaPx = deltaX;

    // 右边距
    if (deltaPx >= 0 && ((this.rightThumbRect[2] + deltaPx) >= this.componentMaxWidth - this.rightPadding)) {
      deltaPx = this.componentMaxWidth - this.rightPadding - this.rightThumbRect[2];
    }

    // 左边距
    if (deltaPx <= 0 && ((this.rightThumbRect[0] + deltaPx) <= (this.leftThumbRect[2] + this.minLeftRightPadding))) {
      deltaPx = (this.leftThumbRect[2] + this.minLeftRightPadding) - this.rightThumbRect[0];
    }
    // 右边距 新增 与leftThumb最大距离
    if (deltaPx >= 0 && ((this.rightThumbRect[0] + deltaPx) >= (this.leftThumbRect[2] + this.maxLeftRightPadding))) {
      deltaPx = (this.leftThumbRect[2] + this.maxLeftRightPadding) - this.rightThumbRect[0];
    }

    let newArea = [(this.rightThumbRect[0] + deltaPx), this.rightThumbRect[1], (this.rightThumbRect[2] + deltaPx),
                      this.rightThumbRect[3]];

    this.rightThumbRect = newArea;
    this.rightThumbPosition = { x: newArea[0], y: newArea[1] };
    this.rightTextPosition = { x: newArea[2] - this.rightTextWidth, y: newArea[1] };

    this.middenPosition = { x: this.leftThumbRect[2], y: this.leftThumbRect[1] };
    this.transparentWidth = this.rightThumbRect[0] - this.leftThumbRect[2];
  }

  /**
   * 是否触摸在选取框内
   * @param event
   * @returns
   */
  touchInThumb(event?: GestureEvent): boolean {
    if (this.touchInLeftThumb(event)
      || this.touchInRightThumb(event)
      || this.touchInMiddleThumb(event)) {

      return true;
    } else {

      return false;
    }
  }

  /**
   * 是否触摸在左边的条状物
   * @param event
   * @returns
   */
  touchInLeftThumb(event?: GestureEvent): boolean {
    let pointX:number = this.clearUndefined(event?.fingerList[0].localX);
    let pointY:number = this.clearUndefined(event?.fingerList[0].localY);

    return this.pointInArea(pointX, pointY, this.leftThumbRect);
  }

  /**
   * 是否触摸在右边的条状物
   * @param event
   * @returns
   */
  touchInRightThumb(event?: GestureEvent): boolean {
    logger.info('touchInRightThumb');
    let pointX:number = this.clearUndefined(event?.fingerList[0].localX);
    let pointY:number = this.clearUndefined(event?.fingerList[0].localY);

    return this.pointInArea(pointX, pointY, this.rightThumbRect);
  }

  /**
   * 某个点是否在某个范围内
   * @param x
   * @param y
   * @param area
   * @returns
   */
  pointInArea(x: number, y: number, area: Array<number>): boolean {
    if (area.length === 4) {
      if (x >= (area[0] - 10) && x <= (area[2] + 10)) {

        return true;
      } else {

        return false;
      }
    } else {

      return false;
    }
  }

  /**
   * 是否触摸在选取框的中间
   * @param event
   * @returns
   */
  touchInMiddleThumb(event?: GestureEvent): boolean {
    let pointX: number = this.clearUndefined(event?.fingerList[0].localX);

    if (pointX >= (this.leftThumbRect[2] + 10)
        && pointX <= (this.rightThumbRect[0] - 10)) {

      return true;
    } else {

      return false;
    }
  }

  /**
   * 初始化界面
   */
  initUIRange(){
    this.componentRect = [0, 0, this.componentMaxWidth, this.componentMaxHeight];

    this.widthPerSecond = ((this.componentMaxWidth - (this.leftThumbWidth + this.rightThumbWidth))) / this.countRange;
    this.maxLeftRightPadding = ((this.maxTime * 1.0) / this.countRange) * (this.componentMaxWidth - (this.leftThumbWidth + this.rightThumbWidth));
    this.minLeftRightPadding = ((this.minTime * 1.0) / this.countRange) * (this.componentMaxWidth - (this.leftThumbWidth + this.rightThumbWidth));

    let leftThumbOffX = (this.currentStartTime - this.startTime) / 1000 * this.widthPerSecond;
    this.leftThumbRect = [leftThumbOffX, 0, leftThumbOffX + this.leftThumbWidth, this.componentMaxHeight];
    this.leftThumbPosition = { x: this.leftThumbRect[0], y: this.leftThumbRect[1] };
    this.leftTextPosition = { x: this.leftThumbRect[0], y: this.leftThumbRect[1] };

    let rightThumbOffX = (this.currentEndTime - this.startTime) / 1000 * this.widthPerSecond;
    this.rightThumbRect = [rightThumbOffX, 0, rightThumbOffX + this.rightThumbWidth, this.componentMaxHeight];
    this.rightThumbPosition = { x: this.rightThumbRect[0], y: this.rightThumbRect[1] };
    this.rightTextPosition = { x: this.rightThumbRect[2] - this.rightTextWidth, y: this.rightThumbRect[1] };

    this.seekCompWidth = this.componentMaxWidth;
    this.middenPosition = { x: this.leftThumbRect[2], y: this.leftThumbRect[1] };

    this.transparentWidth = rightThumbOffX - leftThumbOffX;

    this.leftText = this.showThumbText(this.currentStartTime);
    this.rightText = this.showThumbText(this.currentEndTime);
  }

  clearUndefined(num: number | undefined) {
    if (num === undefined) {

      return 0;
    }

    return num;
  }

}