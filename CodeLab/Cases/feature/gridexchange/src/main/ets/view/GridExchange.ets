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
import { APP_LIST_DATA, FIRST_APP_LIST_DATA, SECOND_APP_LIST_DATA } from '../model/MockData';
import { GridItemAddCtrl, GridItemDeletionCtrl, AddStatus, DeletionStatus } from '../model/GridItemDeletionCtrl';
import promptAction from '@ohos.promptAction';
import { logger } from '../utils/Logger';

const SHOW_TIME: number = 2000; // 弹窗展示时间
const ANIMATION_DURATION: number = 1000; // 动画总时长200ms

/**
 * 功能描述: 本示例直接进行交换和删除元素会给用户带来不好的体验效果，因此需要在此过程中注入一些特色的动画来提升体验效果，本案例通过Grid组件、
 * attributeModifier、以及animateTo函数实现了拖拽动画，删除动画和添加时的位移动画。
 *
 * 推荐场景: 在进行交换和删除元素时注入一些特色的动画来提升体验效果
 *
 * 核心组件:
 * 1. onAreaChange
 * 2. onTouch
 *
 * 实现步骤：
 * 1. 本示例主要通过attributeModifier、supportAnimation、animateTo等实现了删除动画，以及长按拖拽动画。
 * 2. attributeModifier绑定自定义属性对象，控制每个网格元素的属性更新。执行删除操作时，通过animateTo去更新offset值，以及opacity等属性，执行添加操作时，通过animateTo去更新translate偏移量和visibility等属性。
 * 3. supportAnimation设置为true，支持GridItem拖拽动画，在onItemDragStart开始拖拽网格元素时触发，onItemDragStart可以返回一个@Builder修饰的自定义组件，这样在拖拽的时候，能够显示目标元素。
 * 4. onItemDrop在网格元素内停止拖拽时触发。此时执行元素位置的切换功能。
 * 5. 通过数组appNameList控制应用类别1和应用类别2里的应用是否展示添加标识，在应用类别1和应用类别2被点击时，通过将appInfo添加到appInfoList实现添加功能， 通过transition实现应用被添加到首页应用时的动画效果。
 */

@Component
export struct GridExchangeComponent {
  @Provide isEdit: boolean = false;
  @Provide @Watch('monitoringData') appInfoList: AppInfo[] = APP_LIST_DATA;
  @Provide firstAppInfoList: AppInfo[] = FIRST_APP_LIST_DATA;
  @Provide secondAppInfoList: AppInfo[] = SECOND_APP_LIST_DATA;
  @State movedItem: AppInfo = new AppInfo();
  @Provide appNameList: Array<string> = []; // 存放首页应用的appName
  @Provide originalAppNameList: Array<string> = []; // 存放首页应用的appName初始值
  private originAppInfoList: AppInfo[] = [];
  @Provide GridItemDeletion: GridItemDeletionCtrl<AppInfo> =
    new GridItemDeletionCtrl<AppInfo>(this.appInfoList); // gridItem删除管理类
  @Provide FirstGridItemAdd: GridItemAddCtrl<AppInfo> =
    new GridItemAddCtrl<AppInfo>(this.firstAppInfoList); // gridItem添加管理类
  @Provide SecondGridItemAdd: GridItemAddCtrl<AppInfo> =
    new GridItemAddCtrl<AppInfo>(this.secondAppInfoList); // gridItem添加管理类
  @StorageLink('addStatus') addStatus: AddStatus = AddStatus.FINISH; // 向首页应用添加应用的动画状态
  @StorageLink('deletionStatus') deletionStatus: DeletionStatus = DeletionStatus.FINISH; // 首页应用删除应用的动画状态
  private itemAreaWidth: number = 0;
  private isChange: boolean = false;

  aboutToAppear(): void {
    this.appInfoList.forEach((item: AppInfo) => {
      this.appNameList.push(JSON.stringify(item.name));
    });
  }

  /**
   * 拖拽过程中展示的样式
   */
  @Builder
  pixelMapBuilder() {
    IconWithNameView({ app: this.movedItem })
      .width($r('app.string.grid_exchange_builder_width'))
  }

  /**
   * 应用类别里每一个应用和位移动画过程中的展示样式
   * @param data app信息和首页应用里的appName
   */
  @Builder
  appItemWithNameView(data: AddedIconWithNameViewMode) {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image(data.app.icon)
        .width($r('app.string.grid_exchange_icon_size'))
        .height($r('app.string.grid_exchange_icon_size'))
        .interpolation(ImageInterpolation.High)
        .syncLoad(true)
        .draggable(false) // TODO：知识点：保持默认值true时，图片有默认拖拽效果，会影响Grid子组件拖拽判断，所以修改为false
      // 不在首页应用里的app才会展示添加标识
      if (this.isEdit && !data.homeAppNames.includes(JSON.stringify(data.app.name))) {
        Image($r('app.media.ic_public_list_add_light'))
          .width($r('app.string.grid_exchange_remove_icon_size'))
          .height($r('app.string.grid_exchange_remove_icon_size'))
          .markAnchor({
            x: $r('app.string.grid_exchange_add_sign_x_size'),
            y: $r('app.string.grid_exchange_add_sign_y_size')
          })
          .id('add_button')
      }
    }

    Text(data.app.name)
      .width($r('app.string.grid_exchange_app_name_width'))
      .fontSize($r('app.string.grid_exchange_app_name_font_size'))
      .maxLines(1)
      .fontColor(Color.Black)
      .textAlign(TextAlign.Center)
      .margin({ top: $r('app.string.grid_exchange_app_name_margin_top_size') })
  }

  /**
   * 应用类别中每一个应用模块
   * @param data app信息和首页应用里的appName
   */
  @Builder
  addedIconWithNameView(data: AddedIconWithNameViewMode) {
    Column() {
      this.appItemWithNameView({ app: data.app, homeAppNames: data.homeAppNames });
    }
    .id(data.app.name.toString()) // 绑定id信息，可通过id获取组件坐标
    .width($r('app.string.grid_exchange_grid_item_width'))
    .height($r('app.string.grid_exchange_grid_item_height'))
    .justifyContent(FlexAlign.Center)
  }

  /**
   * 用于位移动画的应用样式
   * @param data app信息，首页应用里的appName和gridItem添加管理类
   */
  @Builder
  translateIconWithNameView(data: TranslateItemWithNameViewMode) {
    Column() {
      this.appItemWithNameView({ app: data.app, homeAppNames: data.homeAppNames });
    }
    // TODO:知识点:动态绑定属性信息
    .attributeModifier(data.translateItemModifier.getModifier(data.app))
    .width($r('app.string.grid_exchange_grid_item_width'))
    .height($r('app.string.grid_exchange_grid_item_height'))
    .justifyContent(FlexAlign.Center)
  }

  /**
   * 用于展示应用类别1和应用类别2
   * @param data app标题和appInfo所在数组
   */
  @Builder
  sortIconWithNameView(data: SortIconWithNameView) {
    Column() {
      Text($r(data.title))
        .textAlign(TextAlign.Start)
        .width($r('app.string.grid_exchange_container_size'))
        .height($r('app.string.grid_exchange_title_height'))
        .padding({
          left: $r('app.string.ohos_id_card_padding_start'),
          right: $r('app.string.ohos_id_card_padding_start')
        })
      // TODO:性能知识点: 使用了flex布局会对应用功耗产生较大影响，请结合实际情况谨慎使用。此处使用flex布局是因为位移动画所需。
      Flex() {
        // TODO:性能知识点:动态加载数据场景可以使用LazyForEach遍历数据。https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/arkts-rendering-control-lazyforeach-0000001524417213-V3
        ForEach(data.appInfoList, (item: AppInfo) => {
          Stack() {
            this.translateIconWithNameView({
              app: item,
              homeAppNames: this.appNameList,
              translateItemModifier: data.translateItemModifier
            });
            this.addedIconWithNameView({ app: item, homeAppNames: this.appNameList });
          }
          .width($r('app.string.grid_exchange_sort_item_width'))
          .onClick(() => {
            if (!this.isEdit) {
              return;
            }
            if (this.appNameList.includes(JSON.stringify(item.name))) {
              promptAction.showToast({
                message: $r('app.string.grid_exchange_repeat_app_message'),
                duration: SHOW_TIME,
              })
              return;
            }
            // 上一个动画处于完成状态，再去执行下一个动画
            if (this.addStatus === AddStatus.FINISH) {
              this.addStatus = AddStatus.IDLE;
              this.appNameList.push(JSON.stringify(item.name));
              data.translateItemModifier.addGridItem(item, this.appInfoList);

              // 动画执行结束后向首页应用里添加被点击应用
              setTimeout(() => {
                this.appInfoList.push(item);
              }, ANIMATION_DURATION)
            }
          })
        }, (item: AppInfo) => JSON.stringify(item))
      }
      .width($r('app.string.grid_exchange_container_size'))
      .layoutWeight(1)
    }
    .id('flexContainer')
    .height($r('app.string.grid_exchange_first_app_container_height'))
    .borderRadius($r('app.string.grid_exchange_app_container_border_radius'))
    .margin({
      left: $r('app.string.grid_exchange_app_container_margin_size'),
      right: $r('app.string.grid_exchange_app_container_margin_size'),
      top: $r('app.string.grid_exchange_app_container_margin_top_size')
    })
    .backgroundColor(Color.White)
  }

  /**
   * 交换应用位置函数
   * @param itemIndex 目标网格元素的index
   * @param insertIndex 被切换网格元素的index
   */
  changeIndex(itemIndex: number, insertIndex: number): void {
    this.appInfoList.splice(insertIndex, 0, this.appInfoList.splice(itemIndex, 1)[0]);
  }

  // 监听数据变化函数
  monitoringData(): void {
    this.isChange = true;
    this.GridItemDeletion = new GridItemDeletionCtrl<AppInfo>(this.appInfoList);
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.grid_exchange_cancel'))
          .fontColor($r('app.string.grid_exchange_color1'))
          .onClick(() => {
            if (!this.isEdit) {
              return;
            }
            if (!this.isChange) {
              this.isEdit = false;
              return;
            }
            promptAction.showDialog({
              message: $r('app.string.grid_exchange_toast_message'),
              alignment: DialogAlignment.Center,
              buttons: [
                {
                  text: $r('app.string.grid_exchange_cancel'),
                  color: $r('app.string.grid_exchange_color1'),
                },
                {
                  text: $r('app.string.grid_exchange_save'),
                  color: $r('app.string.grid_exchange_color1'),
                }
              ],
            })
              .then(data => {
                if (data.index === 0) {
                  this.appInfoList = [...this.originAppInfoList];
                  // 将appName初始值数组赋值给appNameList
                  this.appNameList = [...this.originalAppNameList];
                  this.GridItemDeletion = new GridItemDeletionCtrl(this.appInfoList);
                  this.isEdit = false;
                  this.isChange = false;
                } else {
                  this.isEdit = false;
                  this.isChange = false;
                }
              })
              .catch((err: Error) => {
                logger.info(`showDialog error: ${JSON.stringify(err)}`);
              })
          })

        Text($r('app.string.grid_exchange_management_applications'))
          .fontSize($r('app.string.grid_exchange_title_name_font_size'))

        Button({ type: ButtonType.Normal }) {
          Text(this.isEdit ? $r('app.string.grid_exchange_save') : $r('app.string.grid_exchange_edit'))
            .fontColor(Color.White)
        }
        .width($r('app.string.grid_exchange_button_width'))
        .height($r('app.string.grid_exchange_button_height'))
        .borderRadius($r('app.string.grid_exchange_button_border_radius'))
        .backgroundColor($r('app.string.grid_exchange_color1'))
        .onClick(() => {
          this.isEdit = !this.isEdit;
          // 编辑和保存的情况下都会重新赋值初始值所在数组
          this.originAppInfoList = [...this.appInfoList];
          this.originalAppNameList = [...this.appNameList];
        })
      }
      .padding({
        left: $r('app.string.grid_exchange_title_bar_padding_left'),
        right: $r('app.string.grid_exchange_title_bar_padding_right'),
        top: $r('app.string.grid_exchange_title_bar_padding_top')
      })
      .width($r('app.string.grid_exchange_container_size'))
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

      Text(this.isEdit ? $r('app.string.grid_exchange_operation_message') : $r('app.string.grid_exchange_edit_message'))
        .fontColor(Color.Grey)
        .fontSize($r('app.string.grid_exchange_edit_message_font_size'))
        .margin({
          top: $r('app.string.ohos_id_elements_margin_vertical_l'),
          bottom: $r('app.string.ohos_id_elements_margin_vertical_m')
        })

      Column() {
        Text($r('app.string.grid_exchange_title_message'))
          .textAlign(TextAlign.Start)
          .width($r('app.string.grid_exchange_container_size'))
          .textAlign(TextAlign.Start)
          .height($r('app.string.grid_exchange_title_height'))
          .padding({
            left: $r('app.string.ohos_id_card_padding_start'),
            right: $r('app.string.ohos_id_card_padding_start')
          })
        Grid() {
          // 性能知识点:动态加载数据场景可以使用LazyForEach遍历数据。https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/arkts-rendering-control-lazyforeach-0000001524417213-V3
          ForEach(this.appInfoList, (item: AppInfo, index: number) => {
            GridItem() {
              IconWithNameView({ app: item })
            }
            .id(`${item.name.toString()}InHome`) // 绑定id信息，可通过id获取组件坐标
            /**
             * 性能知识点:此函数在区域发生大小变化的时候会进行调用，由于删除操作或者网格元素的交互都能够触发区域函数的使用，操作频繁，
             * 建议此处减少日志的打印、复用函数逻辑来降低性能的内耗。
             * 参考链接:https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V2/ts-universal-component-area-change-event-0000001478061665-V2
             */
            .onAreaChange((oldValue: Area, newValue: Area) => {
              this.itemAreaWidth = Number(newValue.width);
            })
            /**
             * 性能知识点:此函数进行手势操作的时候会进行多次调用，建议此处减少日志的打印、复用函数逻辑来降低性能的内耗。
             * 参考链接:https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V2/ts-universal-events-touch-0000001427902424-V2
             */
            .onTouch((event: TouchEvent) => {
              if (event.type === TouchType.Down) {
                this.movedItem = this.appInfoList[index];
              }
            })
            // TODO:知识点:动态绑定属性信息
            .attributeModifier(this.GridItemDeletion.getModifier(item))
            .onClick(() => {
              if (!this.isEdit) {
                return;
              }
              // 上一个动画处于完成状态，再去执行下一个动画
              if (this.deletionStatus === DeletionStatus.FINISH) {
                this.deletionStatus = DeletionStatus.IDLE;
                this.GridItemDeletion.deleteGridItem(item, this.itemAreaWidth);
                this.appNameList.splice(this.appNameList.indexOf(JSON.stringify(item.name)), 1);
              }
            })
          }, (item: AppInfo) => JSON.stringify(item))
        }
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
        .width($r('app.string.grid_exchange_container_size'))
        .layoutWeight(1)
        // TODO:知识点:支持GridItem拖拽动画。
        .supportAnimation(true)
        .editMode(this.isEdit)
        .onItemDragStart((event: ItemDragInfo, itemIndex: number) => {
          // TODO:知识点:在onItemDragStart函数返回自定义组件，可在拖拽过程中显示此自定义组件。
          return this.pixelMapBuilder();
        })
        .onItemDrop((event: ItemDragInfo, itemIndex: number, insertIndex: number, isSuccess: boolean) => {
          // TODO:知识点:执行gridItem切换操作
          if (isSuccess && insertIndex < this.appInfoList.length) {
            this.changeIndex(itemIndex, insertIndex);
          }
        })
      }
      .id('gridContainer')
      .height($r('app.string.grid_exchange_app_container_height'))
      .borderRadius($r('app.string.grid_exchange_app_container_border_radius'))
      .margin({
        left: $r('app.string.grid_exchange_app_container_margin_size'),
        right: $r('app.string.grid_exchange_app_container_margin_size')
      })
      .backgroundColor(Color.White)

      this.sortIconWithNameView({
        title: 'app.string.grid_exchange_first_title_message',
        appInfoList: this.firstAppInfoList,
        translateItemModifier: this.FirstGridItemAdd
      });

      this.sortIconWithNameView({
        title: 'app.string.grid_exchange_second_title_message',
        appInfoList: this.secondAppInfoList,
        translateItemModifier: this.SecondGridItemAdd
      });
    }
    .height($r('app.string.grid_exchange_container_size'))
    .backgroundColor($r('app.color.grid_exchange_grid_background_color'))
    .alignItems(HorizontalAlign.Center)
  }
}

/**
 * App自定义组件
 */
@Component
struct IconWithNameView {
  private app: AppInfo = new AppInfo();
  @Consume isEdit: boolean;

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopEnd }) {
        Image(this.app.icon)
          .width($r('app.string.grid_exchange_icon_size'))
          .height($r('app.string.grid_exchange_icon_size'))
          .interpolation(ImageInterpolation.High)
          .syncLoad(true)
          .draggable(false) // TODO：知识点：保持默认值true时，图片有默认拖拽效果，会影响Grid子组件拖拽判断，所以修改为false
        if (this.isEdit) {
          Image($r('app.media.ic_public_remove_filled'))
            .width($r('app.string.grid_exchange_remove_icon_size'))
            .height($r('app.string.grid_exchange_remove_icon_size'))
            .markAnchor({ x: '-40%', y: '40%' })
            .draggable(false)
            .id('delete_button')
        }
      }

      Text(this.app.name)
        .width($r('app.string.grid_exchange_app_name_width'))
        .fontSize($r('app.string.grid_exchange_app_name_font_size'))
        .maxLines(1)
        .fontColor(Color.Black)
        .textAlign(TextAlign.Center)
        .margin({ top: 1 })
    }
    .width($r('app.string.grid_exchange_grid_item_width'))
    .height($r('app.string.grid_exchange_grid_item_height'))
    .justifyContent(FlexAlign.Center)
  }
}

/**
 * 应用类别中每一个GridItem元素模块传参所用类型
 */
interface AddedIconWithNameViewMode {
  // app信息
  app: AppInfo,

  // 首页应用里的app名所在数组
  homeAppNames: Array<string>,
}

/**
 * 用于位移动画的每一个GridItem元素传参所用类型
 */
interface TranslateItemWithNameViewMode {
  // app信息
  app: AppInfo,

  // 首页应用里的app名所在数组
  homeAppNames: Array<string>,

  // gridItem添加管理类
  translateItemModifier: GridItemAddCtrl<AppInfo>
}

/**
 * 应用类别模块传参所用类型
 */
interface SortIconWithNameView {
  // 标题
  title: string,

  // appInfo所在数组
  appInfoList: Array<AppInfo>,

  // gridItem添加管理类
  translateItemModifier: GridItemAddCtrl<AppInfo>
}