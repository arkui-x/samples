/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { CommonConstants as Const, TrainsLine } from '@ohos/utils';
import { TrainsMap } from '../viewmodel/TrainsMap';
import { PositionList } from '../viewmodel/TrainsMapModel';
import TrainsTrack from './TrainsTrack';

@Component
export struct Trains {
  @State trainsMapData: TrainsMap[] = PositionList;
  @StorageLink("showLineOne") showLineOne: boolean = false;
  @StorageLink("showLineTwo") showLineTwo: boolean = false;
  @StorageLink("showLineThree") showLineThree: boolean = false;

  /**
   * Determine whether the small train is in operation.
   *
   * @param line route.
   * @returns boolean
   */
  isOperating(line: number): boolean {
    let ret: boolean;
    switch (line) {
      case TrainsLine.LINE_ONE:
        ret = this.checkTime(Const.LINE_ONE_START_TIME, Const.LINE_ONE_END_TIME);
        break;
      case TrainsLine.LINE_TWO:
        ret = this.checkTime(Const.LINE_TWO_START_TIME, Const.LINE_TWO_END_TIME) && !this.checkWeekend();
        break;
      case TrainsLine.LINE_THREE:
        ret = (this.checkTime(Const.LINE_THREE_START_TIME, Const.LINE_THREE_END_TIME) &&
          !this.checkWeekend()) ||
          (this.checkTime(Const.LINE_THREE_WEEKEND_START_TIME, Const.LINE_THREE_WEEKEND_END_TIME) &&
          this.checkWeekend());
        break;
      default:
        ret = true;
    }
    return ret;
  }

  /**
   * Determine if it is within the time period.
   *
   * @param startTime and endTime.
   * @returns boolean
   */
  checkTime(startTime: string, endTime: string): boolean {
    const date = new Date();
    const dateStr = `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()} `;
    const startDate = new Date(dateStr + startTime).getTime();
    const endDate = new Date(dateStr + endTime).getTime();
    const currentDate = date.getTime();
    return currentDate >= startDate && currentDate <= endDate;
  }

  checkWeekend(): boolean {
    const date = new Date();
    const weekday = date.getDay();
    return weekday === 0 || weekday === 6;
  }

  changeShowMap(line: number) {
    switch (line) {
      case TrainsLine.LINE_ONE:
        this.showLineOne = !this.showLineOne;
        break;
      case TrainsLine.LINE_TWO:
        this.showLineTwo = !this.showLineTwo;
        break;
      case TrainsLine.LINE_THREE:
        this.showLineThree = !this.showLineThree;
        break;
    }
  }

  fetchShowMap(line: number): boolean {
    let ret: boolean;
    switch (line) {
      case TrainsLine.LINE_ONE:
        ret = this.showLineOne;
        break;
      case TrainsLine.LINE_TWO:
        ret = this.showLineTwo;
        break;
      case TrainsLine.LINE_THREE:
        ret = this.showLineThree;
        break;
      default:
        ret = false;
    }
    return ret;
  }

  build() {
    Row() {
      Scroll() {
        Column({ space: Const.TRAIN_SPACE }) {
          Text(Const.TRAIN_TITLE)
            .fontSize(35)
            .fontWeight(FontWeight.Bold)
          Image($r('app.media.ic_train_map'))
            .aspectRatio(Const.TRAIN_ASPECT_RATIO)
            .objectFit(ImageFit.Cover)
            .borderRadius(Const.TRAIN_BORDER_RADIUS)
            .width(Const.FULL_SIZE)
          Flex({ direction: FlexDirection.Column }) {
            ForEach(this.trainsMapData, (item: TrainsMap, index: number) => {
              Column({ space: Const.TRAIN_SPACE }) {
                Row() {
                  Text() {
                    Span($r("app.string.line", `${index + 1}`))
                    Span(this.isOperating(index) ? $r("app.string.in_operation") : $r("app.string.non_operational"))
                      .fontColor(this.isOperating(index) ? $r("app.color.in_operation") :
                      $r("app.color.non_operational"))
                      .fontSize($r("app.float.operation_font_size"))
                      .fontWeight(Const.OPERATION_FONT_WEIGHT)
                  }
                  .fontSize($r("app.float.line_font_size"))
                  .fontWeight(Const.OPERATION_FONT_WEIGHT)
                  .margin({ left: 10 })

                  Text($r("app.string.train_interval", item.interval.toString()))
                    .fontColor($r("app.color.train_interval"))
                    .fontSize($r("app.float.operation_font_size"))
                    .fontWeight(Const.INTERVAL_FONT_WEIGHT)
                    .margin({ right: 10 })
                }
                .width(Const.FULL_SIZE)
                .justifyContent(FlexAlign.SpaceBetween)
                .alignItems(VerticalAlign.Center)
                .onClick(() => {
                  this.changeShowMap(index);
                  this.trainsMapData = this.trainsMapData.slice(0);
                })

                if (this.fetchShowMap(index) && this.isOperating(index)) {
                  TrainsTrack({ trainsInfo: this.trainsMapData[index], trainLine: index })
                }
              }
              .width(Const.FULL_SIZE)
              .borderRadius(Const.TRAIN_BORDER_RADIUS)
              .padding({
                top: Const.TRAIN_PADDING_TOP,
                bottom: Const.TRAIN_PADDING_BOTTOM,
              }).backgroundColor($r("app.color.train_list_background"))

              Blank().height(10)
            }, (item: TrainsMap) => JSON.stringify(item.interval))
          }.width(Const.FULL_SIZE)
        }
        .width(Const.FULL_SIZE)
        .padding({ left: Const.TRAIN_PADDING_LEFT, right: Const.TRAIN_PADDING_RIGHT })
      }.scrollBar(BarState.Off)
    }.height(Const.FULL_SIZE)
    .backgroundColor($r("app.color.train_background"))
  }
}