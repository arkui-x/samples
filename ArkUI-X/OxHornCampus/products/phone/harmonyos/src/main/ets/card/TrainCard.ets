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

@Entry
@Component
struct TrainCard {
  /*
   * The action type.
   */
  readonly ACTION_TYPE: string = 'router';
  /*
   * The ability name.
   */
  readonly ABILITY_NAME: string = 'EntryAbility';
  /*
   * The with percentage setting.
   */
  readonly FULL_WIDTH_PERCENT: string = '100%';
  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';
  /*
   * The with percentage setting.
   */
  readonly THIRD_WIDTH_PERCENT: string = '33.33%';
  /*
   * The image height.
   */
  readonly IMAGE_HEIGHT: number = 24;
  /*
   * The image width.
   */
  readonly IMAGE_WIDTH: number = 24;
  /*
   * The text container height.
   */
  readonly TEXT_HEIGHT: number = 48;
  /*
   * The trains map data.
   */
  readonly TRAINS_MAP: TrainsMapModel[] = [new TrainsMapModel(), new TrainsMapModel(), new TrainsMapModel()];

  build() {
    Column() {
      List() {
        ForEach(this.TRAINS_MAP, (item: TrainsMapModel, index: number) => {
          ListItem() {
            Row({ space: 4 }) {
              Image(item.icon)
                .width(this.IMAGE_WIDTH)
                .height(this.IMAGE_HEIGHT)
              Text($r("app.string.line_widget", (index + 1).toString()))
                .fontSize($r("app.float.widget_train_text"))
                .fontColor($r("app.color.widget_train_text"))
            }
            .width(this.FULL_WIDTH_PERCENT)
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .border({
              width: { right: index === this.TRAINS_MAP.length - 1 ? 0 : 1 },
              color: $r("app.color.widget_train_text")
            })
          }
          .width(this.THIRD_WIDTH_PERCENT)
          .height(this.FULL_HEIGHT_PERCENT)
          .onClick(() => {
            postCardAction(this, {
              "action": this.ACTION_TYPE,
              "abilityName": this.ABILITY_NAME,
              "params": {
                url: "train",
                lineIndex: index,
                bottomTabIndex: 2
              }
            });
          })
        }, (item: TrainsMapModel) => JSON.stringify(item))
      }
      .width(this.FULL_WIDTH_PERCENT)
      .height(this.TEXT_HEIGHT)
      .listDirection(Axis.Horizontal)
    }
    .height(this.FULL_HEIGHT_PERCENT)
    .justifyContent(FlexAlign.End)
    .backgroundImage($r("app.media.ic_widget_train_map"), ImageRepeat.NoRepeat)
    .backgroundImageSize({ width: this.FULL_WIDTH_PERCENT, height: this.FULL_HEIGHT_PERCENT })
  }
}

class TrainsMapModel {
  icon: Resource = $r("app.media.ic_widget_train");
}