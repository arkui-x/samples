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

import { FileItem, FileType } from '../dto/FileItem';
import { MEMO_DATA } from '../dto/MockData';
import { DialogUtil } from '../../dialog/util/DialogUtil';
import {
  addFileDialogBuilder,
  deleteConfirmDialogBuilder,
  fileInfoDialogBuilder,
  siftFileDialogBuilder
} from '../builder/CustomBuilder';
import { DialogTypeEnum } from '../../dialog/enum/DialogTypeEnum';
import { display, window } from '@kit.ArkUI';
import { DynamicsRouter } from 'routermodule';
import { PlatformInfo, PlatformTypeEnum } from 'utils';

@Component
export struct DialogExampleView {
  @State siftFileType: FileType = FileType.UN_KNOWN;
  listScroll: Scroller = new Scroller();
  // 初始化列表数据
  @State fileList: FileItem[] = MEMO_DATA;
  // // 当前选定的列表项
  @State currentListItem: FileItem | undefined = undefined;
  @State topHeight: number = 0;
  @State bottomHeight: number = 0;
  @State screenHeight: number = 0;
  @State showPop: boolean = false;

  aboutToAppear(): void {
    DialogUtil.init(this.getUIContext());
    window.getLastWindow(getContext(), (err, windowClass) => {
      // 获取状态栏高度
      this.topHeight = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height;
      this.bottomHeight = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).bottomRect.height;
      this.screenHeight = display.getDefaultDisplaySync().height;
    })
  }

  build() {
    Column() {
      Row() {
        Image($r("app.media.encapsulation_dialog_add"))
          .width($r("app.string.encapsulation_dialog_add_icon_size"))
          .height($r("app.string.encapsulation_dialog_add_icon_size"))
          .id("add_file_button")
          .onClick(() => {
            this.addFile();
          })
        Blank()
        Text($r('app.string.encapsulation_dialog_title'))
          .fontSize($r("app.string.encapsulation_dialog_title_size"))
          .fontWeight(400)
          .fontColor(Color.Black)
        Blank()
        Image($r("app.media.encapsulation_dialog_sift"))
          .width($r("app.string.encapsulation_dialog_sift_icon_size"))
          .height($r("app.string.encapsulation_dialog_sift_icon_size"))
          .fillColor(this.siftFileType !== FileType.UN_KNOWN ? Color.Green : undefined)
          .id("sift_button")
          .onClick(() => {
            this.siftFile();
          })
      }
      .alignItems(VerticalAlign.Center)
      .height($r("app.string.encapsulation_dialog_title_bar_height"))
      .width($r("app.string.encapsulation_dialog_hundred_percent"))
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .padding({
        left: $r("app.string.encapsulation_dialog_title_bar_padding"),
        right: $r("app.string.encapsulation_dialog_title_bar_padding")
      })

      List({ scroller: this.listScroll, space: 24 }) {
        ForEach(this.fileList, (item: FileItem, index: number) => {
          if (this.siftFileType === FileType.UN_KNOWN || this.siftFileType === item.type) {
            ListItem() {
              FileItemComponent({
                fileItem: item,
              }).id("file_item")
            }
            .bindContextMenu(this.popupBuilder, ResponseType.LongPress,
              {
                backgroundColor: $r('app.color.encapsulation_dialog_color_F7F7F7'),
                backgroundBlurStyle: BlurStyle.NONE,
                borderRadius: $r('app.integer.encapsulation_dialog_integer_10'),
                onAppear: () => {
                  item.isSelected = true;
                  this.currentListItem = this.fileList[index];
                },
                onDisappear: () => {
                  item.isSelected = false;
                  this.currentListItem = undefined;
                }
              })
            .id(item.name + index)
            .width($r('app.string.encapsulation_dialog_hundred_percent'))
            .height($r('app.integer.encapsulation_dialog_integer_82'))
            .transition(TransitionEffect.OPACITY)
            .onClick(() => {
              this.showFileInfo(item);
            })
          }
        }, (item: FileItem, index) => item.name + index)
      }
      .padding({
        left: $r('app.integer.encapsulation_dialog_integer_15'),
        right: $r('app.integer.encapsulation_dialog_integer_15'),
        top: $r('app.integer.encapsulation_dialog_integer_24')
      })
      .width($r('app.string.encapsulation_dialog_hundred_percent'))
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundColor($r('app.color.encapsulation_dialog_color_F5F7FA'))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }.width($r('app.string.encapsulation_dialog_hundred_percent'))
    .height($r('app.string.encapsulation_dialog_hundred_percent'))
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .gesture(
      SwipeGesture({ direction: SwipeDirection.Horizontal })
        .onAction((event: GestureEvent) => {
          if (PlatformInfo.getPlatform() === PlatformTypeEnum.IOS) {
            if (event) {
              DynamicsRouter.popAppRouter();
            }
          }
        })
    )
  }

  @Builder
  popupBuilder() {
    Column() {
      Text($r('app.string.encapsulation_dialog_detail'))
        .fontColor($r('app.color.encapsulation_dialog_color_383838'))
        .fontSize($r('app.integer.encapsulation_dialog_integer_20'))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.showFileInfo(this.currentListItem);
        })
        .width($r('app.string.encapsulation_dialog_hundred_percent'))
        .layoutWeight(1)
      Divider().height($r('app.integer.encapsulation_dialog_integer_1'))
      Text($r('app.string.encapsulation_dialog_delete'))
        .fontColor($r('app.color.encapsulation_dialog_color_383838'))
        .fontSize($r('app.integer.encapsulation_dialog_integer_20'))
        .onClick(() => {
          this.deleteFile(this.currentListItem);
        })
        .textAlign(TextAlign.Center)
        .width($r('app.string.encapsulation_dialog_hundred_percent'))
        .layoutWeight(1)
    }
    .width($r('app.integer.encapsulation_dialog_integer_155'))
    .height($r('app.integer.encapsulation_dialog_integer_96'))
  }

  showFileInfo(item: FileItem | undefined) {
    if (item) {
      item.bottomHeight = this.bottomHeight
      item.screenHeight = this.screenHeight
      // 打开文件详情弹窗
      DialogUtil.showCustomDialog({
        builder: wrapBuilder(fileInfoDialogBuilder),
        dialogType: DialogTypeEnum.BOTTOM,
        dialogBuilderParam: {
          data: item
        }
      })
    }
  }

  siftFile() {
    let siftFileDialogParam: Record<string, ESObject> = {
      'topHeight': this.topHeight,
      'siftType': this.siftFileType
    };
    // 打开筛选弹窗
    DialogUtil.showCustomDialog({
      builder: wrapBuilder(siftFileDialogBuilder),
      dialogType: DialogTypeEnum.TOP,
      dialogBuilderParam: {
        onConfirm: (isCloseDialog?: boolean, data?: ESObject) => {
          this.siftFileType = data;
        },
        data: siftFileDialogParam
      }
    });
  }

  addFile() {
    // 打开添加文件弹窗
    DialogUtil.showCustomDialog({
      builder: wrapBuilder(addFileDialogBuilder),
      dialogType: DialogTypeEnum.CENTER,
      dialogBuilderParam: {
        onConfirm: (isCloseDialog?: boolean, data?: ESObject) => {
          this.fileList.unshift(data as FileItem);
        }
      }
    });
  }

  deleteFile(deleteItem: FileItem | undefined) {
    if (deleteItem) {
      // 打开删除文件确认弹窗
      DialogUtil.showCustomDialog({
        builder: wrapBuilder(deleteConfirmDialogBuilder),
        dialogType: DialogTypeEnum.CENTER,
        dialogBuilderParam: {
          onConfirm: (isCloseDialog?: boolean, data?: ESObject) => {
            this.fileList.forEach((item: FileItem, index: number) => {
              if (deleteItem.equal(item)) {
                this.fileList.splice(index, 1);
                return;
              }
            })
          }
        }
      })
    }
  }
}

@Component
export struct FileItemComponent {
  @ObjectLink fileItem: FileItem;

  build() {
    Row() {
      Image(this.fileItem.icon)
        .width($r('app.integer.encapsulation_dialog_integer_50'))
        .height($r('app.integer.encapsulation_dialog_integer_50'))
        .objectFit(ImageFit.Cover)
        .draggable(false)// TODO：知识点：保持默认值true时，图片有默认拖拽效果，会影响Grid子组件拖拽判断，所以修改为false
        .margin({ left: $r('app.integer.encapsulation_dialog_integer_21') })
      Column() {
        Text(this.fileItem.name)
          .fontColor(Color.Black)
          .fontSize($r('app.integer.encapsulation_dialog_integer_15'))
          .fontWeight(400)
          .textAlign(TextAlign.Start)
          .id("file_name")

        Text(this.fileItem.time)
          .fontSize($r('app.integer.encapsulation_dialog_integer_13'))
          .fontWeight(400)
          .fontColor($r('app.color.encapsulation_dialog_color_8A9095'))
          .margin({ top: $r('app.integer.encapsulation_dialog_integer_10') })
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.SpaceAround)
      .margin({ left: $r('app.integer.encapsulation_dialog_integer_15') })
      .height($r('app.integer.encapsulation_dialog_integer_50'))

      Blank()
      Text(this.fileItem.size)
        .fontSize($r('app.integer.encapsulation_dialog_integer_13'))
        .fontColor($r('app.color.encapsulation_dialog_color_8A9095'))
        .margin({
          right: $r('app.integer.encapsulation_dialog_integer_15'),
          top: $r('app.integer.encapsulation_dialog_integer_46')
        })
    }
    .borderRadius($r('app.integer.encapsulation_dialog_integer_12'))
    .width($r('app.string.encapsulation_dialog_hundred_percent'))
    .height($r('app.string.encapsulation_dialog_hundred_percent'))
    .backgroundColor(this.fileItem.isSelected ? $r('app.color.encapsulation_dialog_color_80CCCCCC') :
    $r('sys.color.white'))
  }
}