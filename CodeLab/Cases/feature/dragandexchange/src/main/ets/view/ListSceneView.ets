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

import { AppInfo } from '../model/AppInfo';
import { DataSource } from '../model/DateSource';

const ICON_NUM_IN_LIST: number = 4; // 示例List中子组件数目
const LIST_SPACE: number = 30; // 列表默认间隔

@Component
export struct ListSceneView {
  @State movedItem: AppInfo = new AppInfo();
  @State dataSource: DataSource = new DataSource();

  aboutToAppear() {
    for (let index = 0; index < ICON_NUM_IN_LIST; index++) {
      this.dataSource.pushData(new AppInfo($r(`app.media.drag_and_exchange_ic_public_game${index + 1}`),
        `Item${index + 1}`, true));
    }
  }

  changeIndex(index1: number, index2: number) {
    let temp: AppInfo = this.dataSource.getData(index1);
    this.dataSource.setData(index1, this.dataSource.getData(index2));
    this.dataSource.setData(index2, temp);
  }

  build() {
    Column() {
      Text($r("app.string.drag_and_exchange_list_drag_title"))
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .fontSize($r("app.string.drag_and_exchange_opt_title_font_size"))
      Row() {
        List({ space: LIST_SPACE }) {
          LazyForEach(this.dataSource, (item: AppInfo, index) => {
            ListItem() {
              Column() {
                IconNoNameView({ app: item })
              }
            }
          }, (item: AppInfo) => item.name.toString())
        }
        .scrollBar(BarState.Off)
        .height($r("app.string.drag_and_exchange_layout_90"))
        .listDirection(Axis.Horizontal)
        .alignListItem(ListItemAlign.Center)
        .onItemDragStart((event: ItemDragInfo, itemIndex: number) => {
          this.movedItem = this.dataSource.getData(itemIndex);
          return this.itemWhileDrag();
        })
        .onItemDrop((event: ItemDragInfo, itemIndex: number, insertIndex: number, isSuccess: boolean) => {
          if (isSuccess && insertIndex < this.dataSource.totalCount()) {
            let temp: AppInfo = this.dataSource.getData(itemIndex);
            this.dataSource.setData(itemIndex, this.dataSource.getData(insertIndex));
            this.dataSource.setData(insertIndex, temp);
            this.dataSource.notifyDataReload();
          }
        })
        .enableScrollInteraction(false)
        .alignListItem(ListItemAlign.Center)
        .padding({
          top: $r("app.string.drag_and_exchange_layout_10"),
          bottom: $r("app.string.drag_and_exchange_layout_10"),
          left: $r("app.string.drag_and_exchange_layout_15"),
          right: $r("app.string.drag_and_exchange_layout_15")
        })
      }
      .justifyContent(FlexAlign.Center)
      .height($r("app.string.drag_and_exchange_layout_90"))
      .width($r("app.string.drag_and_exchange_layout_90_percent"))
      .borderRadius($r("app.string.drag_and_exchange_layout_20"))
      .opacity($r("app.string.drag_and_exchange_background_opacity"))
      .backgroundColor($r('app.color.drag_and_exchange_background_color'))
    }
    .margin({ top: $r("app.string.drag_and_exchange_layout_20") })
  }

  /**
   * 设置GridItem拖拽过程中显示的图形
   */
  @Builder
  itemWhileDrag() {
    IconNoNameView({ app: this.movedItem })
      .width($r("app.string.drag_and_exchange_icon_square_size"))
      .height($r("app.string.drag_and_exchange_icon_square_size"))
  }
}

/**
 * 无名字App自定义组件
 */
@Component
struct IconNoNameView {
  @ObjectLink app: AppInfo;

  build() {
    Column() {
      Image(this.app.icon)
        .id(`${this.app.name}`)
        .width($r("app.string.drag_and_exchange_icon_square_size"))
        .height($r("app.string.drag_and_exchange_icon_square_size"))
        .objectFit(ImageFit.Cover)
        .borderRadius($r("app.string.drag_and_exchange_layout_10"))
        .draggable(false)
      Text(this.app.name)
        .width($r("app.string.drag_and_exchange_icon_square_size"))
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .margin({ top: $r("app.string.drag_and_exchange_layout_1") })
        .fontSize($r("app.string.drag_and_exchange_app_name_font_size"))
    }
    .visibility(this.app.visible ? Visibility.Visible : Visibility.Hidden)
  }
}