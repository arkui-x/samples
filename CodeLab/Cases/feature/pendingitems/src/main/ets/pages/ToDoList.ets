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

import { ToDo } from '../model/ToDo';
import { ToDoListItem } from './ToDoListItem';
import promptAction from '@ohos.promptAction';
import { STYLE_CONFIG } from '../model/ConstData';

@Extend(Image)
function imageStyle() {
  .aspectRatio(1)
  .width(STYLE_CONFIG.IMAGE_SIZE)
  .margin(STYLE_CONFIG.IMAGE_MARGIN)
}

/**
 * 功能描述: 本示例介绍了通过对List数据源修改实现列表项新增/删除/编辑的功能。
 *
 * 推荐场景: 待办事项管理、文件管理、备忘录的记录管理等
 *
 * 核心组件:
 * 1. ToDoListItem
 *
 * 实现步骤：
 * 1. List组件绑定@State修饰的数组变量toDoData。
 * 2. ListItem组件设置左滑动效swipeAction属性。
 * 3. 触发点击事件新增/删除列表项，更新数组变量toDoData，并同时更新List组件UI(MVVM)。
 */
@Component
export struct ToDoListComponent {
  @State toDoData: ToDo[] = []; // 待办事项
  @State achieveData: ToDo[] = []; // 已完成事项
  private availableThings: string[] = ['读书', '运动', '旅游', '听音乐', '看电影', '唱歌']; // 待办可选事项

  build() {
    Column() {
      Row({ space: STYLE_CONFIG.LIST_ITEM_GUTTER }) {
        Text($r('app.string.pendingitems_todo'))
          .fontSize($r('sys.float.ohos_id_text_size_headline7'))
        Blank()
        Image($r('app.media.pendingitems_ic_public_add_filled'))
          .id('add_items')
          .width(STYLE_CONFIG.MENU_IMAGE_SIZE)
          .aspectRatio(1)
          .onClick(() => {
            // TODO：知识点：1.根据文本选择的选择结果，向待办事项数组中添加数据
            TextPickerDialog.show({
              range: this.availableThings,
              onAccept: (value: TextPickerResult) => {
                this.toDoData.unshift(new ToDo(this.availableThings[Number(value.index)]));
              },
            })
          })
      }
      .height($r('app.string.pendingitems_title_height'))
      .width($r('app.string.pendingitems_max_size'))
      .padding({
        left: $r('sys.float.ohos_id_max_padding_start'),
        right: $r('sys.float.ohos_id_max_padding_end'),
      })
      .backgroundColor(Color.White)

      // TODO：知识点：2.待办数据显示列表组件绑定数据变量toDoData
      List({ initialIndex: 0, space: STYLE_CONFIG.LIST_ITEM_GUTTER }) {
        // 未完成列表项
        if (this.toDoData.length !== 0) {
          ListItem() {
            Text($r('app.string.pendingitems_undo'))
              .fontSize($r('sys.float.ohos_id_text_size_headline8'))
          }
        }
        // 性能知识点：ForEach主要用于循环数据量小的数据，数据量大建议使用LazyForEach
        ForEach(this.toDoData, (toDoItem: ToDo, index: number) => {
          ListItem() {
            ToDoListItem({
              toDoItem: toDoItem,
              achieveData: $achieveData,
              toDoData: $toDoData
            })
          }
          // TODO：知识点：3.设置ListItem的swipeAction属性，左滑时，显示自定义UI视图
          .swipeAction({ end: this.itemEnd(toDoItem), edgeEffect: SwipeEdgeEffect.Spring })
        }, (toDoItem: ToDo, index: number) => toDoItem.key)

        // 已完成列表项
        if (this.achieveData.length !== 0) {
          ListItem() {
            Text($r('app.string.pendingitems_done'))
              .fontSize($r('sys.float.ohos_id_text_size_headline8'))
          }
        }
        ForEach(this.achieveData, (toDoItem: ToDo, index: number) => {
          ListItem() {
            ToDoListItem({
              toDoItem: toDoItem,
              achieveData: $achieveData,
              toDoData: $toDoData
            })
          }
          .swipeAction({ end: this.itemEnd(toDoItem), edgeEffect: SwipeEdgeEffect.Spring })
        }, (toDoItem: ToDo, index: number) => toDoItem.key)
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .layoutWeight(1)
      .listDirection(Axis.Vertical)
      .edgeEffect(EdgeEffect.Spring)
      .padding({
        top: $r('sys.float.ohos_id_default_padding_top'),
        left: $r('sys.float.ohos_id_default_padding_start'),
        right: $r('sys.float.ohos_id_default_padding_end'),
      })
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .backgroundColor($r('app.color.pendingitems_pageBcColor'))
    .width($r('app.string.pendingitems_max_size'))
    .height($r('app.string.pendingitems_max_size'))
  }

  // item左滑显示工具栏
  @Builder
  itemEnd(item: ToDo) {
    Row({ space: STYLE_CONFIG.ICON_GUTTER }) {
      Image($r('app.media.pendingitems_ic_public_settings_filled')).imageStyle()
        .onClick(() => {
          promptAction.showToast({ message: $r('app.string.pendingitems_incomplete') });
        })
      Image($r('app.media.pendingitems_ic_public_detail_filled')).imageStyle()
        .onClick(() => {
          promptAction.showToast({ message: $r('app.string.pendingitems_incomplete') });
        })
      Image($r('app.media.pendingitems_ic_public_delete_filled')).imageStyle()
        .id('delete_item')
        .onClick(() => {
          this.deleteTodoItem(item);
        })
    }
    .padding(STYLE_CONFIG.OPERATION_BUTTON_PADDING)
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  /**
   * 删除待办/已完成事项
   */
  deleteTodoItem(item: ToDo) {
    if (item.isFinished) {
      this.achieveData = this.achieveData.filter(todoItem => item.key !== todoItem.key);
    } else {
      this.toDoData = this.toDoData.filter(todoItem => item.key !== todoItem.key);
    }
    promptAction.showToast({ message: $r('app.string.pendingitems_deleted') });
  }
}
