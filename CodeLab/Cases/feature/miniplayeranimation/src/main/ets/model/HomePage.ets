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

import Constants from '../model/Constants';
import { AnimationInfo } from '../model/AnimationInfo';
import { AnimatorResult } from '@ohos.animator';
import { PlatformInfo, PlatformTypeEnum } from 'utils';

// tabBar信息类
class TabBarInfo {
  imageUri: Resource; // tabBar未被选中时显示的图片资源
  selectedImageUri: Resource; // tabBar被选中时显示的图片资源
  name: Resource; // tabBar页签名

  constructor(imageUri: Resource, selectedImageUri: Resource, name: Resource) {
    this.imageUri = imageUri;
    this.selectedImageUri = selectedImageUri;
    this.name = name;
  }
}

// tabBar数据
const TAB_BAR_DATA: Array<TabBarInfo> = [
  new TabBarInfo($r('app.media.miniplayeranimation_home'), $r('app.media.miniplayeranimation_home_selected'),
    $r('app.string.mini_player_animation_home')),
  new TabBarInfo($r('app.media.miniplayeranimation_rank'), $r('app.media.miniplayeranimation_rank_selected'),
    $r('app.string.mini_player_animation_rank')),
  new TabBarInfo($r('app.media.miniplayeranimation_user'), $r('app.media.miniplayeranimation_user_selected'),
    $r('app.string.mini_player_animation_user'))
];

// 歌单数量，仅用于UX展示
const SONG_SHEET: number = 14;
// 设置GridItem的缓存数量，仅用于UX展示
const GRID_ITEM_CACHED_COUNT: number = 2;

// MyDataSource类实现IDataSource接口
class MyDataSource implements IDataSource {
  private dataArray: number[] = [];

  public pushData(data: number): void {
    this.dataArray.push(data);
  }

  // 数据源的数据总量
  public totalCount(): number {
    return this.dataArray.length;
  }

  // 返回指定索引位置的数据
  public getData(index: number): number {
    return this.dataArray[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
  }
}

// 性能知识点: @Reusable复用组件优化，详情请见 https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/performance/component-recycle.md/
@Reusable
@Component
struct ReusableChildComponent {
  @State item: number = 0;

  /**
   * aboutToReuse从复用缓存中加入到组件树之前调用，可在此处更新组件的状态变量以展示正确的内容。aboutToReuse参数类型已不支持any，这里使用
   * Record指定明确的数据类型。Record用于构造一个对象类型，其属性键为Keys，属性值为Type。
   */
  aboutToReuse(params: Record<string, number>) {
    this.item = params.item;
  }

  build() {
    Column() {
      Image($r('app.media.miniplayeranimation_song_sheet'))
        .borderRadius($r('app.float.mini_player_animation_song_sheet_border_radius'))
        .layoutWeight(Constants.LAYOUT_WEIGHT)
      Text(`歌单${this.item}`)
        .fontSize($r('app.float.mini_player_animation_singer_font_size'))
        .textAlign(TextAlign.Center)
    }
    .width($r('app.float.mini_player_animation_song_sheet_size'))
    .height($r('app.float.mini_player_animation_song_sheet_size'))
    .onClick(() => {
      AlertDialog.show({
        message: $r('app.string.mini_player_animation_prompt_info'),
        alignment: DialogAlignment.Center
      });
    })
  }
}

// 首页
@Component
export struct HomePage {
  private controller: TabsController = new TabsController();
  // Tabs当前页index
  @State currentIndex: number = 0;
  // 动画相关参数类
  @ObjectLink animationInfo: AnimationInfo;
  // 动画对象
  @Link animatorObject: AnimatorResult;
  // 数据源
  private data: MyDataSource = new MyDataSource();
  @StorageLink('statusHeight') statusHeight: number = 0; // 顶部状态栏高度

  // 获取tabBar选中和未选中时的图片
  getTabBarImage(index: number): Resource {
    if (this.currentIndex === index) {
      return TAB_BAR_DATA[index].selectedImageUri;
    }
    return TAB_BAR_DATA[index].imageUri;
  }

  // 添加歌单数据
  aboutToAppear() {
    // 添加歌单，仅用于UX展示
    for (let i = 1; i <= SONG_SHEET; i++) {
      this.data.pushData(i);
    }
  }

  // 自定义TabBar
  @Builder
  tabBarBuilder(index: number) {
    Column() {
      Image(this.getTabBarImage(index))
        .width($r('app.float.mini_player_animation_image_size'))
        .height($r('app.float.mini_player_animation_image_size'))
        .objectFit(ImageFit.Contain)
      Text(TAB_BAR_DATA[index].name)
        .fontSize($r('app.float.mini_player_animation_tab_bar_font_size'))
        .opacity(this.currentIndex === index ? $r('app.float.mini_player_animation_select_tab_bar_opacity') :
        $r('app.float.mini_player_animation_not_select_tab_bar_opacity'))
        .fontWeight(this.currentIndex === index ? Constants.SELECTED_FONT_WEIGHT : Constants.NOT_SELECTED_FONT_WEIGHT)
        .fontColor(this.currentIndex === index ? Color.Red : Color.Black)
    }
    .justifyContent(FlexAlign.Center)
    .width($r('app.string.mini_player_animation_full_size'))
    .height($r('app.string.mini_player_animation_full_size'))
  }

  // 自定义Mini条
  @Builder
  miniPlayer() {
    Row() {
      // 下面Image为实际显示的Mini歌曲封面图。而Mini条上歌曲封面一镜到底动画用的是另一张图，只在Mini条展开动画开始时显示，动画结束后隐藏。
      Image($r('app.media.miniplayeranimation_music_cover'))
        .height(Constants.MINI_IMG_SIZE)
        .width(Constants.MINI_IMG_SIZE)
        .borderRadius(Constants.MINI_IMG_RADIUS)
        .opacity(this.animationInfo.miniImgOpacity)
        .margin({
          left: Constants.MINI_IMG_MARGIN_LEFT + this.animationInfo.miniImgOffsetX +
          this.animationInfo.miniImgOffsetSize, // 歌曲封面缩放动画过程中，歌名和歌手信息位置同步偏移，效果更好
          right: $r('app.float.mini_player_animation_offset')
        })
      Column() {
        Text($r('app.string.mini_player_animation_song_name'))
          .fontSize($r('app.float.mini_player_animation_singer_font_size'))
        Text($r('app.string.mini_player_animation_singer'))
          .fontSize($r('app.float.mini_player_animation_font_size'))
          .opacity($r('app.float.mini_player_animation_song_opacity'))
      }.alignItems(HorizontalAlign.Start)

      Blank()
      Image($r('app.media.miniplayeranimation_pause'))
        .width($r('app.float.mini_player_animation_pause_image_size'))
        .height($r('app.float.mini_player_animation_pause_image_size'))
        .margin({ right: $r('app.float.mini_player_animation_margin_right') })
        .onClick(() => {
          AlertDialog.show({
            message: $r('app.string.mini_player_animation_prompt_info'),
            alignment: DialogAlignment.Center
          });
        })
      Image($r('app.media.miniplayeranimation_next'))
        .width($r('app.float.mini_player_animation_image_size'))
        .height($r('app.float.mini_player_animation_image_size'))
        .margin({ right: $r('app.float.mini_player_animation_margin_right') })
        .onClick(() => {
          AlertDialog.show({
            message: $r('app.string.mini_player_animation_prompt_info'),
            alignment: DialogAlignment.Center
          });
        })
      Image($r('app.media.miniplayeranimation_music_list'))
        .width($r('app.float.mini_player_animation_image_size'))
        .height($r('app.float.mini_player_animation_image_size'))
        .onClick(() => {
          AlertDialog.show({
            message: $r('app.string.mini_player_animation_prompt_info'),
            alignment: DialogAlignment.Center
          });
        })
    }
    .width($r('app.string.mini_player_animation_full_size'))
    .height(Constants.MINI_HEIGHT + this.animationInfo.miniChangeHeight)
    .backgroundColor($r('app.color.mini_player_animation_bg'))
    .opacity(this.animationInfo.miniPlayerOpacity)
    .padding({
      right: $r('app.float.mini_player_animation_offset')
    })
    .alignItems(VerticalAlign.Bottom)
    // Mini条Y轴位置=屏幕高度-Mini条高度-TabBar高度-底部非安全区域高度-顶部非安全区域高度-Mini条一镜到底动画过程中实时偏移的距离
    // .position({
    //   y: this.animationInfo.screenHeight - Constants.MINI_HEIGHT - Constants.BAR_HEIGHT -
    //   this.animationInfo.bottomUnsafeHeight - this.animationInfo.miniImgOffsetY
    // })
    .id('mini')
    .onClick(() => {
      if (this.animatorObject) {
        // 计算Mini条距离屏幕底部的高度（Mini条高度+TabBar高度+底部非安全区域高度（导航栏高度））
        this.animationInfo.miniDistanceToBottom =
          Constants.MINI_HEIGHT + Constants.BAR_HEIGHT + this.animationInfo.bottomUnsafeHeight;
        // Mini条实际歌曲封面的透明度
        this.animationInfo.miniImgOpacity = 0;
        // 用于动画的Mini条歌曲封面的透明度
        this.animationInfo.miniImgAnimateOpacity = 1;
        // TODO 知识点：通过play()启动动画。
        // 启动动画。这里为展开动画。
        this.animatorObject.play();
        this.animationInfo.isAnimating = true;
      }
    })
  }

  // 自定义音乐专栏
  @Builder
  musicColumn(columnName: Resource) {
    Row() {
      Text(columnName)
        .fontSize($r('app.float.mini_player_animation_music_column_font_size'))
        .fontWeight(FontWeight.Bold)
      Blank()
      Text($r('app.string.mini_player_animation_music_column_more'))
        .fontSize($r('app.float.mini_player_animation_music_more_font_size'))
        .opacity($r('app.float.mini_player_animation_music_column_opacity'))
        .onClick(() => {
          AlertDialog.show({
            message: $r('app.string.mini_player_animation_prompt_info'),
            alignment: DialogAlignment.Center
          });
        })
      Image($r('app.media.miniplayeranimation_arrow'))
        .opacity($r('app.float.mini_player_animation_music_column_opacity'))
        .height($r('app.string.mini_player_animation_music_column_height'))
        .onClick(() => {
          AlertDialog.show({
            message: $r('app.string.mini_player_animation_prompt_info'),
            alignment: DialogAlignment.Center
          });
        })
    }
    .height($r('app.string.mini_player_animation_music_common_height'))
    .width($r('app.string.mini_player_animation_common_width'))

    Grid() {
      // 性能知识点: LazyForEach 懒加载优化，详情请见 https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/performance/lazyforeach_optimization.md/
      LazyForEach(this.data, (item: number) => {
        GridItem() {
          // 使用可复用自定义组件
          ReusableChildComponent({ item: item })
        }
      }, (item: string) => item)
    }
    .scrollBar(BarState.Off)
    .cachedCount(GRID_ITEM_CACHED_COUNT) // 设置GridItem的缓存数量
    .rowsTemplate('1fr 1fr')
    .columnsGap($r('app.float.mini_player_animation_grid_space'))
    .rowsGap($r('app.float.mini_player_animation_grid_space'))
    .height($r('app.float.mini_player_animation_grid_height'))
  }

  // 自定义首页推荐
  @Builder
  recommendation() {
    Scroll() {
      Column() {
        Search({ placeholder: $r('app.string.mini_player_animation_search') })
          .width($r('app.string.mini_player_animation_common_width'))
          .height($r('app.string.mini_player_animation_music_common_height'))
          .backgroundColor(Color.White)
          .focusable(false)
          .onClick(() => {
            AlertDialog.show({
              message: $r('app.string.mini_player_animation_prompt_info'),
              alignment: DialogAlignment.Center
            });
          })
        Image($r('app.media.miniplayeranimation_big_img'))
          .width($r('app.string.mini_player_animation_common_width'))
          .height($r('app.string.mini_player_animation_big_image_height'))
          .borderRadius($r('app.float.mini_player_animation_border_radius'))
          .onClick(() => {
            AlertDialog.show({
              message: $r('app.string.mini_player_animation_prompt_info'),
              alignment: DialogAlignment.Center
            });
          })
        // 歌单推荐
        this.musicColumn($r('app.string.mini_player_animation_recommendation_music_sheet'))
        // 专属推荐
        this.musicColumn($r('app.string.mini_player_animation_recommendation_exclusive'))
      }.margin({ bottom: Constants.MINI_HEIGHT })
    }
    .scrollable(ScrollDirection.Vertical) // 滚动方向纵向
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, index: this.currentIndex, controller: this.controller }) {
        TabContent() {
          Column() {
            Row() {
              Text($r('app.string.mini_player_animation_recommendation'))
                .fontSize($r('app.float.mini_player_animation_recommendation_font_size'))
                .fontWeight(FontWeight.Bold)
              Blank()
            }
            .width($r('app.string.mini_player_animation_full_size'))
            .height($r('app.float.mini_player_animation_recommendation_height'))
            .padding({
              left: $r('app.float.mini_player_animation_padding_left'),
              top: this.statusHeight + 'px'
            })
            .margin({ bottom: $r('app.float.mini_player_animation_size_ten') })

            // 由于Mini条是position定位，所以为了避免推荐页面滚动到最底部时内容被Mini条挡住，这里需要再套一层Column，同时recommendation里需要加上Mini条高度的底部内边距
            Column() {
              // 推荐页面内容
              this.recommendation()
            }.layoutWeight(Constants.LAYOUT_WEIGHT)

            // Mini条
            this.miniPlayer()
          }
          .width($r('app.string.mini_player_animation_full_size'))
          .height($r('app.string.mini_player_animation_full_size'))
          .padding({ top: PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS ? 0 : 20 })
        }
        .tabBar(this.tabBarBuilder(Constants.TAB_BAR_HOME_INDEX))

        TabContent() {
          Text($r('app.string.mini_player_animation_prompt_info'))
            .width($r('app.string.mini_player_animation_full_size'))
            .height($r('app.string.mini_player_animation_full_size'))
            .textAlign(TextAlign.Center)
        }
        .tabBar(this.tabBarBuilder(Constants.TAB_BAR_RANK_INDEX))

        TabContent() {
          Text($r('app.string.mini_player_animation_prompt_info'))
            .width($r('app.string.mini_player_animation_full_size'))
            .height($r('app.string.mini_player_animation_full_size'))
            .textAlign(TextAlign.Center)
        }
        .tabBar(this.tabBarBuilder(Constants.TAB_BAR_USER_INDEX))
      }
      .vertical(false)
      .scrollable(false)
      .barHeight(Constants.BAR_HEIGHT)
      .height($r('app.string.mini_player_animation_full_size'))
      .onChange((index: number) => {
        this.currentIndex = index; // Tab页签切换后更新currentIndex
      })
    }
    .width($r('app.string.mini_player_animation_full_size'))
    .height($r('app.string.mini_player_animation_full_size'))
    .backgroundColor($r('app.color.mini_player_animation_home_page_color'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}