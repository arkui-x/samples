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

import { display, promptAction } from '@kit.ArkUI';
import { connection } from '@kit.NetworkKit';
import { DynamicsRouter, FoldableRouter } from 'routermodule';
import { getNWeb, getNWebEx, PlatformInfo, PlatformTypeEnum } from 'utils';
import { CollapseMenu } from 'collapsemenu';
import { SceneModuleInfo } from './model/SceneModuleInfo';
import { WaterFlowDataSource } from './model/WaterFlowDataSource';
import { TAB_DATA, TabDataModel } from './model/TabsData';

/**
 * 瀑布流列表项组件布局
 *
 * @param listData 组件列表信息
 *
 * TODO:知识点：
 * 1.@Reusable标识自定义组件具备可复用的能力，它可以被添加到任意的自定义组件上。
 * 2.复用自定义组件时避免一切可能改变自定义组件的组件树结构和可能使可复用组件中产生重新布局的操作以将组件复用的性能提升到最高。
 */
@Reusable
@Component
struct methodPoints {
  @Consume itemWidth: number;
  @State listData: SceneModuleInfo = new SceneModuleInfo
  ($r("app.media.functional_scenes_address_exchange"), '地址交换动画', 'addressexchange/AddressExchangeView', '动效', 1)
  @State helperUrl: string = 'about://blank';
  @State screenW: number = px2vp(display.getDefaultDisplaySync().width);
  @State isNeedClear: boolean = false;
  @State @Watch("onShowReadMeChange") isShowReadMe: boolean = false;
  /*
   * 依据Navigation的mode属性说明，如使用Auto，窗口宽度>=600vp时，采用Split模式显示；窗口宽度<600vp时，采用Stack模式显示。
   * */
  private deviceSize: number = 600;

  aboutToAppear(): void {
    if (this.screenW >= this.deviceSize) {
      this.isNeedClear = true;
    } else {
      this.isNeedClear = false;
    }
  }

  /**
   * 组件的生命周期回调，在可复用组件从复用缓存中加入到组件树之前调用
   * @param params：组件更新时所需参数
   */
  aboutToReuse(params: Record<string, SceneModuleInfo>): void {
    this.listData = params.listData as SceneModuleInfo;
  }

  onShowReadMeChange(): void {
    if (!this.isShowReadMe) {
      // 半模态弹窗关闭时，加载空白页面，防止主页瀑布流源码页面显示混乱
      if (PlatformInfo.getPlatform() == PlatformTypeEnum.HARMONYOS) {
        getNWeb('about://blank')
      } else if (PlatformInfo.isArkUIX()) {
        getNWebEx('about://blank', this.getUIContext());
      }
    }
  }

  changeHelpUrl(): void {
    this.helperUrl = this.listData.helperUrl;
  }

  /*
   * 帮助功能：半模态弹窗显示对应案例README
   * */
  @Builder
  buildReadMeSheet(): void {
    Column() {
      Row() {
        Row() {
          Text(this.listData.name)
            .textOverflow({ overflow: TextOverflow.Clip })
            .fontColor(Color.White)
            .fontWeight(700)
            .fontSize($r('app.integer.nav_destination_title_text_size'))
        }
        .width($r('app.integer.readme_sheet_text_size'))

        Column() {
          Stack() {
            Column() {
            }
            .width($r('app.integer.readme_sheet_size'))
            .height($r('app.integer.readme_sheet_size'))
            .borderRadius($r('app.integer.nav_destination_title_image_border_radius'))
            .backgroundColor(Color.White)
            .opacity(0.05)

            Image($r('app.media.ic_public_cancel'))
              .fillColor(Color.White)
              .width($r('app.integer.readme_sheet_cancel_image_width'))
          }
        }
        .onClick(() => {
          this.isShowReadMe = false;
        })
        .justifyContent(FlexAlign.Center)
        .width($r('app.integer.readme_sheet_size'))
        .height($r('app.integer.readme_sheet_size'))
        .borderRadius($r('app.integer.nav_destination_title_image_border_radius'))
      }
      .padding({ left: $r('app.integer.readme_sheet_padding'), right: $r('app.integer.readme_sheet_padding') })
      .margin({ top: $r('app.integer.readme_sheet_margin'), })
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      NodeContainer(
        PlatformInfo.getPlatform() == PlatformTypeEnum.HARMONYOS ?
        getNWeb(this.helperUrl) : getNWebEx(this.helperUrl, this.getUIContext())
      )
        .width('100%')
        .height('100%')
        .onAppear(() => {
          this.changeHelpUrl();
        })
    }
    .width('100%')
    .height('100%')
  }

  build() {
    Column() {
      Image(this.listData.imageSrc)
        .borderRadius({
          topLeft: $r('app.string.functional_scenes_main_page_list_borderRadius'),
          topRight: $r('app.string.functional_scenes_main_page_list_borderRadius'),
          bottomLeft: 0,
          bottomRight: 0
        })
        .objectFit(ImageFit.Contain)
        .width('100%')
      Text(this.listData.serialNumber.toString() + '. ' + this.listData.name)
        .padding({
          left: $r('app.string.functional_scenes_main_page_padding6'),
          right: $r('app.string.functional_scenes_main_page_padding6')
        })
        .width('100%')
        .fontColor(Color.Black)
        .textAlign(TextAlign.Start)
        .maxLines(2)
        .fontSize($r('app.string.ohos_id_text_size_body1'))
        .margin({
          top: $r('app.string.functional_scenes_main_page_margin1'),
          bottom: $r('app.string.functional_scenes_main_page_margin1')
        })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Row() {
        if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
          Button() {
            Text($r('app.string.functional_scenes_readme'))
              .fontSize($r('app.integer.functional_scenes_readme_font_size'))
              .fontColor(Color.White)
          }
          .height($r('app.integer.functional_scenes_readme_height'))
          .width($r('app.integer.functional_scenes_readme_width'))
          .margin({ right: 10 })
          .gesture(
            GestureGroup(
              GestureMode.Exclusive,
              TapGesture({ fingers: 1, count: 1 })
                .onAction(() => {
                  connection.hasDefaultNet().then((res: boolean) => {
                    if (res) {
                      this.isShowReadMe = !this.isShowReadMe;
                    } else {
                      promptAction.showToast({ message: $r("app.string.functional_scenes_network_message") });
                    }
                  });
                })
            )
          )
          .bindSheet($$this.isShowReadMe, this.buildReadMeSheet(), {
            detents: [SheetSize.MEDIUM, SheetSize.LARGE],
            showClose: false,
            dragBar: true,
            backgroundColor: $r("app.color.helper_bindsheet_bgc"),
            preferType: SheetType.CENTER,
            // 设置为false时不允许与背景页面交互，显示蒙层
            enableOutsideInteractive: false,
            // 设置半模态高度变化过程中持续更新内容
            scrollSizeMode: ScrollSizeMode.CONTINUOUS
          })
        }

        Text($r('app.string.functional_scenes_difficulty'))
          .fontColor(Color.Black)
          .opacity(0.6)
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .height($r('app.string.functional_scenes_main_page_text_height'))
          .fontSize($r('app.string.functional_scenes_main_page_text_font_size'))
          .width($r('app.string.functional_scenes_main_page_text_width'))
        Rating({
          rating: this.listData.ratingNumber,
          indicator: true
        })
          .stars(5)
          .width($r('app.integer.functional_scenes_rating_width'))
      }
      .padding({ left: 6 })
      .margin({ bottom: $r('app.string.functional_scenes_main_page_padding6') })
      .width($r('app.string.functional_scenes_full_size'))
      .justifyContent(FlexAlign.Start)
    }
    .shadow(ShadowStyle.OUTER_DEFAULT_XS)
    .backgroundColor(Color.White)
    .width(this.itemWidth)
    .borderRadius($r('app.string.functional_scenes_main_page_list_borderRadius'))
    .margin({
      top: $r('app.string.functional_scenes_item_gap_half'),
      bottom: $r('app.string.functional_scenes_item_gap_half')
    })
    .onClick(() => {
      // 判断当前路由栈最后一个路由是否与当前跳转路由相同,相同则不跳转
      if (DynamicsRouter.appRouterStack.slice(-1)[0].name === this.listData.appUri) {
        return;
      }
      // 平板采用点击切换案例，需要pop，手机则不需要，左滑时已pop。
      if (this.isNeedClear) {
        DynamicsRouter.clear();
      }
      if (this.listData !== undefined) {
        // 点击瀑布流Item时，根据点击的模块信息，将页面放入路由栈
        FoldableRouter.pushUri(this.listData.appUri, this.listData.param);
      }
    })
  }
}

/**
 * 主页瀑布流列表
 */
@Component
export struct FunctionalScenes {
  @Link listData: SceneModuleInfo[];
  dataSource: WaterFlowDataSource = new WaterFlowDataSource(this.listData);
  @State tabsIndex: number = 0;
  @State tabColumns: string = '1fr 1fr';
  tabsController: TabsController = new TabsController();
  private scrollController: Scroller = new Scroller();
  isFoldable: boolean | undefined = AppStorage.get('isFoldable');
  @Provide itemWidth: number = 0

  aboutToAppear(): void {
    // 34为左右边距+两个瀑布流中间的距离
    this.itemWidth = (AppStorage.get('windowsWidth') as number - 34) / 2
  }

  @Builder
  tabBuilder(index: number, name: string | undefined) {
    Stack() {
      Column() {
      }
      .width(this.tabsIndex === index ? $r('app.integer.functional_scenes_tab_bar_background_width1') :
      $r('app.integer.functional_scenes_tab_bar_background_width2'))
      .backgroundColor(this.tabsIndex === index ? '#0A59F7' : '#000000')
      .opacity(this.tabsIndex === index ? 1 : 0.05)
      .height($r('app.integer.functional_scenes_tab_bar_background_height'))
      .borderRadius($r('app.integer.functional_scenes_tab_bar_background_border_radius'))

      Text(name)
        .fontSize($r('app.string.ohos_id_text_size_body1'))
        .fontColor(this.tabsIndex === index ? Color.White : Color.Black)
        .opacity(this.tabsIndex === index ? 1 : 0.8)
        .height('100%')
        .id('section')
    }
    .margin(index !== 0 && index !== TAB_DATA.length ? { left: $r('app.integer.functional_scenes_tab_bar_margin') } : {
      left: 0,
      right: 0
    })
    .align(Alignment.Center)
    .onClick(() => {
      this.tabsIndex = index;
      this.tabsController.changeIndex(index);
    })
  }

  @Builder
  tabsMenu() {
    Menu() {
      ForEach(TAB_DATA, (item: TabDataModel) => {
        MenuItem({ content: item.navData })
          .onClick(() => {
            this.tabsIndex = item.id;
            this.tabsController.changeIndex(item.id);
          })
          .id('menu_item')
      })
    }
  }

  /**
   * 主页通过瀑布流和LazyForeach加载
   * WaterFlow+LazyForEach详细用法可参考性能范例：
   * https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/performance/waterflow_optimization.md/
   */
  build() {
    Column() {
      Row() {
        Stack() {
          List({ scroller: this.scrollController }) {
            ForEach(TAB_DATA, (tabItem: TabDataModel) => {
              ListItem() {
                this.tabBuilder(tabItem.id, tabItem.navData);
              }
            })
          }
          .id("MainList")
          .margin({ top: $r('app.integer.functional_scenes_tab_bar_list_margin') })
          .height($r('app.integer.functional_scenes_tab_bar_list_height'))
          .listDirection(Axis.Horizontal)
          .padding({ right: $r('app.integer.functional_scenes_tab_bar_list_padding') })
          .scrollBar(BarState.Off)

          Row() {
            Row() {
              Image($r('app.media.ic_public_more'))
                .width($r('app.integer.functional_scenes_tab_bar_image_more'))
                .id('mainPageTabsImage')
            }
            .bindMenu(this.tabsMenu)
            .justifyContent(FlexAlign.Center)
            .width($r('app.integer.functional_scenes_tab_bar_image_more_background_size'))
            .height($r('app.integer.functional_scenes_tab_bar_image_more_background_size'))
            .borderRadius($r('app.integer.functional_scenes_tab_bar_image_more_border_radius'))
            .backgroundColor('#D8D8D8')
            .id('menu_button')
          }
          .linearGradient({
            angle: 90,
            colors: [['rgba(241, 241, 241, 0)', 0], ['#F1F3F5', 0.2], ['#F1F3F5', 1]]
          })
          .justifyContent(FlexAlign.End)
          .width($r('app.integer.functional_scenes_tab_bar_image_more_row_width'))
          .height($r('app.integer.functional_scenes_tab_bar_image_more_row_height'))
        }
        .alignContent(Alignment.TopEnd)
      }
      .padding({
        left: $r('app.integer.functional_scenes_tab_bar_image_more_row_padding'),
        right: $r('app.integer.functional_scenes_tab_bar_image_more_row_padding')
      })
      .margin({ top: $r('app.integer.functional_scenes_tab_bar_image_more_row_margin') })

      Tabs({ controller: this.tabsController }) {
        ForEach(TAB_DATA, (tabItem: TabDataModel) => {
          TabContent() {
            if (tabItem.navData !== '性能文章') {
              WaterFlow() {
                LazyForEach(this.dataSource, (waterFlowItem: SceneModuleInfo) => {
                  FlowItem() {
                    if (tabItem.navData === '全部' || tabItem.navData === waterFlowItem.category) {
                      methodPoints({ listData: waterFlowItem })
                    }
                  }
                }, (waterFlowItem: SceneModuleInfo) => JSON.stringify(waterFlowItem))
              }
              .nestedScroll({
                scrollForward: NestedScrollMode.PARENT_FIRST,
                scrollBackward: NestedScrollMode.SELF_FIRST
              })
              .cachedCount(1)
              .columnsTemplate(this.tabColumns)
              .columnsGap($r('app.string.functional_scenes_main_page_water_flow_gap'))
              .width('100%')
              .clip(false)
              .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
              .padding({ bottom: $r('app.integer.functional_scenes_water_flow_padding_bottom') })
            } else {
              Scroll() {
                CollapseMenu()
              }
              .nestedScroll({
                scrollForward: NestedScrollMode.PARENT_FIRST,
                scrollBackward: NestedScrollMode.SELF_FIRST
              })
              .scrollBar(BarState.Off)
              .clip(false)
              .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
              .padding({ bottom: $r('app.integer.functional_scenes_water_flow_padding_bottom') })
            }
          }
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
          .align(Alignment.TopStart)
          .alignSelf(ItemAlign.Start)
        })
      }
      .margin({ top: $r('app.integer.functional_scenes_tab_bar_image_more_row_margin') })
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .padding({
        left: $r('app.integer.functional_scenes_tab_bar_image_more_row_padding'),
        right: $r('app.integer.functional_scenes_tab_bar_image_more_row_padding')
      })
      .height('100%')
      .barWidth(0)
      .barHeight(0)
      .onAnimationStart((index: number, targetIndex: number) => {
        this.tabsIndex = targetIndex;
        this.scrollController.scrollToIndex(targetIndex, true, ScrollAlign.START);
      })
      .onAreaChange((_oldValue: Area, newValue: Area) => {
        if (_oldValue.width === newValue.width) {
          return;
        }
        /*
         * TODO：知识点：组件区域变化后根据窗口宽度计算瀑布流展示item列数
         * 根据屏幕宽度计算展示item列数
         * */
        let itemWidth = 177
        try {
          itemWidth = getContext(this).resourceManager.getNumber($r('app.integer.functional_scenes_item_width'));
        } catch (e) {
          console.log("resourceManager.getNumber error")
        }
        let maxItemCount = Math.floor(Number(newValue.width) / itemWidth);
        this.tabColumns = '1fr' + ' 1fr'.repeat(maxItemCount - 1);
      })
    }
    .height('100%')
    .backgroundColor("#F1F1F1")
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}

