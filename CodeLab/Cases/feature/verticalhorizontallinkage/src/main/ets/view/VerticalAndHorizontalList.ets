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

import { ShowData, PartInfo, CarTypeData } from '../datasource/ShowData'; // 展示数据的数据类型
import { BasicDataSource } from '../datasource/DataSource';
import { Context } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import { LengthMetrics, promptAction } from '@kit.ArkUI';
import { PlatformInfo } from 'utils';

const CALCULATED_SIZE = 'calc(100% - 100vp)'; // 顶部list的宽度和底部list的高度
const LIST_PRElOAD_NUMBER = 3; // 列表中ListItem预加载个数
const LIST_ITEM_WIDTH = 155.6; // listItem的宽度

/**
 * 功能描述: 本示例主要通过List组件绑定Scroller滚动控制器和LazyForEach数据懒加载来实现纵向横向列表联动。
 *
 * 推荐场景: 汽车参数对比，股票信息查看
 *
 * 核心组件:
 * 1. List
 * 2. Scroller
 * 3. LazyForEach
 *
 * 实现步骤:
 * 1. 顶部List0：存放列标题，车型，底部左侧List1：存放行标题，车辆参数信息，底部右侧List3：存放不同车型对应的不同参数信息，List3里每一行内容对应一个List，不同List绑定不同的Scroller对象。
 * 2. List0和List3里每一行内容对应的List的滚动偏移量保持一致，实现横向列表联动。
 * 3. List1和List3的滚动偏移量保持一致，实现纵向列表联动。
 */
@Component
export struct VerticalAndHorizontalListComponent {
  private carType: string[] = ['车型1', '车型2', '车型3', '车型4', '车型5', '车型6', '车型7', '车型8']; // 顶部List内容，列标题
  topListScroller: Scroller = new Scroller(); // 顶部列表（列标题）的滚动控制器
  private bottomLeftListScroller: Scroller = new Scroller(); // 底部列表左侧（行标题）的滚动控制器
  private bottomRightListScroller: Scroller = new Scroller(); // 底部列表右侧（展示内容）的滚动控制器
  private showDataArray: Array<ShowData> = []; // 存储list内容，参数名（行标题）和不同车型的参数信息
  private dataSource: BasicDataSource<ShowData> = new BasicDataSource();
  private carTypeData: BasicDataSource<string> = new BasicDataSource();
  private topListItemIndex: number = 0; // 顶部列表滚动到的第一个listItem索引号
  private scrollerIndex: number = 0; // 右下列表横向滚动到的第一个listItem索引号

  aboutToAppear(): void {
    // 加载数据
    this.loadShowData();
  }

  /**
   * 读取car.json里的数据，用于展示行标题
   */
  loadShowData(): void {
    this.carTypeData.setData(this.carType);
    const context: Context = getContext(this);
    // 读取car.json里的数据
    let jsonData: Uint8Array = context.resourceManager.getRawFileContentSync('car.json');
    // 将数据解码，转成字符串
    let stringData: string = util.TextDecoder.create('utf-8').decodeToString(jsonData);
    let data: [] = JSON.parse(stringData) as [];
    for (let i = 0; i < data.length; i++) {
      const dataItem = data[i] as CarTypeData;
      let showData: ShowData = new ShowData();
      showData.sticky = dataItem.sticky;
      showData.sub.setData(dataItem.sub)
      // 保存Scroller数组，与左侧标题一一对应
      showData.sub.getAllData().forEach((element: PartInfo) => {
        let scroller: Scroller = new Scroller();
        showData.scrollerArray.push(scroller);
      })
      this.showDataArray.push(showData);
    }
    this.dataSource.setData(this.showDataArray);
  }

  build() {
    Column() {
      this.topComponent();
      Row() {
        this.bottomLeftComponent();
        this.bottomRightComponent();
      }
      .layoutWeight(1)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
  }

  /**
   * 顶部横向滚动列表，用于展示列标题：车型
   */
  @Builder
  topComponent() {
    Row() {
      Column() {
        Text($r('app.string.vertical_horizontal_linkage_top_left_text_message'))
          .fontColor(Color.Black)
          .fontSize($r('app.string.vertical_horizontal_linkage_top_left_message_font_size'))
          .fontWeight(FontWeight.Bold)
      }
      .padding($r('app.string.vertical_horizontal_linkage_vertical_horizontal_container_padding_size'))
      .height($r('app.string.vertical_horizontal_linkage_list_item_height'))
      .width($r('app.string.vertical_horizontal_linkage_list_item_width'))
      .justifyContent(FlexAlign.Center)

      // 分隔线
      Line()
        .height($r('app.string.vertical_horizontal_linkage_list_item_height'))
        .width($r('app.string.vertical_horizontal_linkage_vertical_divider_line_width'))
        .backgroundColor($r('app.color.vertical_horizontal_linkage_list_item_divider_line_color'))

      List({ scroller: this.topListScroller }) {
        LazyForEach(this.carTypeData, (item: string, index: number) => {
          ListItem() {
            CarTypeInfoItem({ info: item });
          }
          .id(`topListItem${index}`)
        }, (item: string, index: number) => item);
      }
      .cachedCount(LIST_PRElOAD_NUMBER)
      .edgeEffect(EdgeEffect.None) // 将边缘滑动效果设置为无
      .listDirection(Axis.Horizontal) // 设置滚动方向为横向滚动
      .divider({ strokeWidth: 0.5, color: $r('app.color.vertical_horizontal_linkage_list_item_divider_line_color') })
      .scrollBar(BarState.Off)
      .width(CALCULATED_SIZE)
      .height($r('app.string.vertical_horizontal_linkage_top_List_height_size'))
      .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
        this.topListItemIndex = firstIndex;
      })
      .onScrollFrameBegin((offset: number, state: ScrollState) => {
        // list列表滚动到指定index后的额外偏移量
        let scrollerOffset: number =
          this.topListScroller.currentOffset().xOffset + offset - this.topListItemIndex * LIST_ITEM_WIDTH;
        if (this.topListScroller.currentOffset().xOffset === 0) {
          scrollerOffset = 0;
        }
        // 顶部列标题列表滚动时，让每一行的滚动控制器保持同步滚动，实现联动
        this.showDataArray.forEach((showData: ShowData) => {
          showData.scrollerArray.forEach((scroller: Scroller) => {
            // 和顶部列表的listItem索引号保持一致
            scroller.scrollToIndex(this.topListItemIndex, false, ScrollAlign.START,
              { extraOffset: LengthMetrics.vp(scrollerOffset) });
          });
        });
        return { offsetRemain: offset };
      })
    }
    .height($r('app.string.vertical_horizontal_linkage_list_item_height'))
  }

  /**
   * 下部分左侧纵向滚动列表里的每一个行标题
   * @param item 展示的数据
   */
  @Builder
  bottomLeftList(item: ShowData) {
    // TODO:性能知识点：数据量较大，使用了[LazyForEach](https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-rendering-control-lazyforeach-V5) 进行数据懒加载优化，以降低内存占用和渲染开销
    LazyForEach(item.sub, (partInfo: PartInfo, index: number) => {
      ListItem() {
        bottomLeftListItem({ partInfo: partInfo });
      }
      .id(`bottomLeftListItem${index}`)
    }, (partInfo: PartInfo, index: number) => partInfo.part);
  }

  /**
   * 下部分左侧纵向滚动列表，用于展示行标题
   */
  @Builder
  bottomLeftComponent() {
    List({ scroller: this.bottomLeftListScroller }) {
      // TODO:性能知识点：数据量较大，使用了[LazyForEach](https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-rendering-control-lazyforeach-V5) 进行数据懒加载优化，以降低内存占用和渲染开销
      LazyForEach(this.dataSource, (item: ShowData, index: number) => {
        ListItemGroup({ header: this.leftFixedTitle(item.sticky) }) {
          this.bottomLeftList(item);

        }
        .border({
          width: { right: '2px' },
          color: $r('app.color.vertical_horizontal_linkage_list_item_divider_line_color'),
          style: BorderStyle.Solid
        })
      }, (item: ShowData, index: number) => item.sticky + index);
    }
    .onScrollFrameBegin((offset: number, state: ScrollState) => {
      // 通过控制右下列表的滚动控制器来保持和左下列表的联动
      this.bottomRightListScroller.scrollTo({
        xOffset: 0,
        // 滚动偏移量为左下列表滚动控制器的当前偏移量+本次滚动的的偏移量
        yOffset: this.bottomLeftListScroller.currentOffset().yOffset + offset
      });
      return { offsetRemain: offset };
    })
    .cachedCount(LIST_PRElOAD_NUMBER) // TODO:性能知识点: 列表较长，设置预加载数量减少性能消耗
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.None) // 将边缘滑动效果设置为无，避免列表划动到底部后出现左右列表不联动问题
    .listDirection(Axis.Vertical) // 设置滚动方向为纵向滚动
    .sticky(StickyStyle.Header) // 设置ListItemGroup标题的吸顶效果
    .width($r('app.string.vertical_horizontal_linkage_list_item_width'))
    .height($r('app.string.vertical_horizontal_linkage_bottom_left_list_height_size'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  /**
   * 下部分右侧纵向滚动列表里的每一行参数信息
   * @param item 展示数据
   */
  @Builder
  bottomRightListItem(item: ShowData) {
    // TODO:性能知识点：数据量较大，使用了[LazyForEach](https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-rendering-control-lazyforeach-V5) 进行数据懒加载优化，以降低内存占用和渲染开销
    LazyForEach(item.sub, (partInfo: PartInfo, key: number) => {
      ListItem() {
        ItemComponent({
          listContent: partInfo.info,
          scroller: item.scrollerArray[key],
          // 展示内容横向滚动时，控制顶部标题的滚动控制器和每一行内容的滚动控制器，保持联动
          scrollCallback: (value) => {
            // 顶部车型列表保持联动
            this.topListScroller.scrollTo({ xOffset: value, yOffset: 0 });
            // list列表滚动到指定index后的额外偏移量
            let offsetX = value - this.scrollerIndex * LIST_ITEM_WIDTH;
            if (item.scrollerArray[key].currentOffset().xOffset === 0) {
              offsetX = 0;
            }
            this.showDataArray.forEach((showData: ShowData) => {
              // 通过scroller数组保持联动
              showData.scrollerArray.forEach((scroller: Scroller) => {
                if (scroller !== item.scrollerArray[key]) {
                  // 其余List与当前正在滑动的List的索引号和额外偏移量保持一致
                  scroller.scrollToIndex(this.scrollerIndex, false, ScrollAlign.START,
                    { extraOffset: LengthMetrics.vp(offsetX) });
                }
              })
            })
          },
          // 展示内容横向滚动时，实时传回滚动偏移量
          remainOffsetCallback: (index) => {
            this.scrollerIndex = index;
          }
        });
      }
      .id(`bottomRightListItem${key}`)
    }, (partInfo: PartInfo, key: number) => partInfo.part + key);
  }

  /**
   * 下部分右侧纵向滚动列表，用于展示车型信息
   */
  @Builder
  bottomRightComponent() {
    List({ scroller: this.bottomRightListScroller }) {
      // TODO:性能知识点：数据量较大，使用了[LazyForEach](https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-rendering-control-lazyforeach-V5) 进行数据懒加载优化，以降低内存占用和渲染开销
      LazyForEach(this.dataSource, (item: ShowData, index: number) => {
        ListItemGroup({ header: this.rightFixedTitle(index) }) {
          this.bottomRightListItem(item);
        };
      }, (item: ShowData, index: number) => item.sticky + index);
    }
    .onScrollFrameBegin((offset: number, state: ScrollState) => {
      // 下方左侧行标题列表与下方右侧列表的滚动偏移量保持一致
      this.bottomLeftListScroller.scrollTo({
        xOffset: 0,
        // 滚动偏移量为右下列表滚动控制器的当前偏移量+本次滚动的的偏移量
        yOffset: this.bottomRightListScroller.currentOffset().yOffset + offset
      });
      return { offsetRemain: offset };
    })
    .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
      // 行标题列表纵向滚动时，计算额外偏移量
      let xOffset: number = this.topListScroller.currentOffset().xOffset - this.scrollerIndex * LIST_ITEM_WIDTH;
      this.showDataArray.forEach((showData: ShowData) => {
        showData.scrollerArray.forEach((scroller: Scroller) => {
          // 行标题列表纵向滚动时，下方右侧的每一行展示内容的索引号和横向偏移量保持一致
          scroller.scrollToIndex(this.scrollerIndex, false, ScrollAlign.START,
            { extraOffset: LengthMetrics.vp(xOffset) });
        })
      });
    })
    .cachedCount(LIST_PRElOAD_NUMBER) // TODO:性能知识点: 列表较长，设置预加载数量减少性能消耗
    .width(CALCULATED_SIZE)
    .height($r('app.string.vertical_horizontal_linkage_bottom_left_list_height_size'))
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.None) // 将边缘滑动效果设置为无
    .listDirection(Axis.Vertical) // 设置滚动方向为纵向滚动
    .sticky(StickyStyle.Header) // 设置ListItemGroup标题的吸顶效果
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  /**
   * 底部左侧纵向滚动列表的标题
   * @param title 标题名
   */
  @Builder
  leftFixedTitle(title: string) {
    Column() {
      Text(title)
        .fontWeight(FontWeight.Bold)
        .height($r('app.string.vertical_horizontal_linkage_fixed_title_height_size'))
        .textAlign(TextAlign.Start)
        .padding($r('app.string.vertical_horizontal_linkage_vertical_horizontal_container_padding_size'))
    }
    .width($r('app.string.vertical_horizontal_linkage_list_item_width'))
    .backgroundColor($r('app.color.vertical_horizontal_linkage_bottom_list_title_background_color'))

  }

  /**
   * 底部右侧纵向滚动的标题
   * @param index 索引值
   */
  @Builder
  rightFixedTitle(index: number) {
    Text(index === 0 ? $r('app.string.vertical_horizontal_linkage_bottom_right_title_initial_content') :
    $r('app.string.vertical_horizontal_linkage_bottom_right_title_content'))
      .fontWeight(FontWeight.Bold)
      .height($r('app.string.vertical_horizontal_linkage_fixed_title_height_size'))
      .textAlign(TextAlign.End)
      .padding($r('app.string.vertical_horizontal_linkage_vertical_horizontal_container_padding_size'))
      .backgroundColor($r('app.color.vertical_horizontal_linkage_bottom_list_title_background_color'))
      .width(PlatformInfo.isArkUIX() ?
        "100%" : $r('app.string.vertical_horizontal_linkage_bottom_right_title_width_size'))
      .onClick(() => {
        promptAction.showToast({
          message: $r('app.string.vertical_horizontal_linkage_bottom_right_title_click_content')
        });
      })
  }
}


/**
 * 展示车型/详细参数信息
 * TODO:知识点：
 * 1.@Reusable标识自定义组件具备可复用的能力，它可以被添加到任意的自定义组件上。
 * 2.复用自定义组件时避免一切可能改变自定义组件的组件树结构和可能使可复用组件中产生重新布局的操作以将组件复用的性能提升到最高。
 */
@Reusable
@Component
struct CarTypeInfoItem {
  @Prop info: string = '';

  aboutToReuse(params: Record<string, string>): void {
    this.info = params.info as string;
  }

  build() {
    Text(this.info)
      .height($r('app.string.vertical_horizontal_linkage_list_item_height'))
      .width($r('app.string.vertical_horizontal_linkage_right_List_Item_width'))
      .textAlign(TextAlign.Center)
      .align(Alignment.Center)
      .padding($r('app.string.vertical_horizontal_linkage_vertical_horizontal_container_padding_size'));
  }
}

/**
 * 用于展示每一行内容
 * TODO:知识点：
 * 1.@Reusable标识自定义组件具备可复用的能力，它可以被添加到任意的自定义组件上。
 * 2.复用自定义组件时避免一切可能改变自定义组件的组件树结构和可能使可复用组件中产生重新布局的操作以将组件复用的性能提升到最高。
 */
@Component
@Reusable
struct ItemComponent {
  @Prop title: string = '';
  @State dataSource: BasicDataSource<string> = new BasicDataSource();
  @State listContent: string[] = [];
  private scroller: Scroller | undefined = undefined;
  private scrollCallback?: (param: number) => void;
  private remainOffsetCallback?: (index: number) => void;
  private scrollIndex: number = 0; // 滚动后出现在视图中第一个listItem索引号

  aboutToAppear(): void {
    this.dataSource.setData(this.listContent);
  }

  aboutToReuse(params: Record<string, ESObject>) {
    this.listContent = params.listContent as string[];
    this.dataSource.setData(this.listContent);
    // 更新视图
    this.dataSource.notifyDataReload();
  }

  build() {
    Column() {
      List({ scroller: this.scroller }) {
        LazyForEach(this.dataSource, (item: string, index: number) => {
          ListItem() {
            CarTypeInfoItem({ info: item });
          }
          .id(`everyLineListItem${index}`)
        }, (item: string, index: number) => item);

      }
      .height($r('app.string.vertical_horizontal_linkage_bottom_left_title_height_size'))
      .width($r('app.string.vertical_horizontal_linkage_bottom_right_single_List_width'))
      .onScrollFrameBegin((offset: number, scrollState: ScrollState) => {
        if (this.scrollCallback) {
          // 传递滚动偏移量
          this.scrollCallback(this.scroller!.currentOffset().xOffset + offset);
        }
        return { offsetRemain: offset };
      })
      .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
        if (this.remainOffsetCallback) {
          
          // 更新滚动索引号
          this.remainOffsetCallback(this.scrollIndex);
        }
      })
      .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
        this.scrollIndex = firstIndex;
      })
      .cachedCount(LIST_PRElOAD_NUMBER)
      .edgeEffect(EdgeEffect.None) // 将边缘滑动效果设置为无
      .listDirection(Axis.Horizontal)
      .scrollBar(BarState.Off)
      .divider({
        strokeWidth: $r('app.string.vertical_horizontal_linkage_vertical_divider_line_width'),
        color: $r('app.color.vertical_horizontal_linkage_list_item_divider_line_color')
      })

      // 分隔线
      Line()
        .height($r('app.string.vertical_horizontal_linkage_vertical_divider_line_width'))
        .width($r('app.string.vertical_horizontal_linkage_horizontal_divider_line_width'))
        .backgroundColor($r('app.color.vertical_horizontal_linkage_list_item_divider_line_color'))
    }
  }
}

/**
 * 展示车型参数名字
 * TODO:知识点：
 * 1.@Reusable标识自定义组件具备可复用的能力，它可以被添加到任意的自定义组件上。
 * 2.复用自定义组件时避免一切可能改变自定义组件的组件树结构和可能使可复用组件中产生重新布局的操作以将组件复用的性能提升到最高。
 */
@Reusable
@Component
struct bottomLeftListItem {
  @State partInfo: PartInfo = new PartInfo();

  aboutToReuse(params: Record<string, PartInfo>): void {
    this.partInfo = params.partInfo as PartInfo;
  }

  build() {
    Column() {
      Text(this.partInfo.part)
        .height($r('app.string.vertical_horizontal_linkage_bottom_left_title_height_size'))
        .width($r('app.string.vertical_horizontal_linkage_list_item_width'))
        .textAlign(TextAlign.Center)
        .align(Alignment.Center)
        .padding($r('app.string.vertical_horizontal_linkage_vertical_horizontal_container_padding_size'))
      // 分隔线
      Line()
        .height($r('app.string.vertical_horizontal_linkage_vertical_divider_line_width'))
        .width($r('app.string.vertical_horizontal_linkage_bottom_left_list_height_size'))
        .backgroundColor($r('app.color.vertical_horizontal_linkage_list_item_divider_line_color'))
    }
  }
}

