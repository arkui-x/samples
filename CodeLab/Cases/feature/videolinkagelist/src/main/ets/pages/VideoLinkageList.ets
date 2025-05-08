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
import { Constants } from '../common/Constants';
import { NEWS_LIST_DATA } from '../mock/NewsListData';
import { NewsItem } from '../model/NewsItemModel';
import { NewsListDataSource } from '../model/NewsListDataSource';
import { promptAction } from '@kit.ArkUI';
import { PlatformInfo } from 'utils'

/**
 * 功能描述: 本示例使用Scroll和List组件嵌套，通过List组件的滚动控制器和nestedScroll属性实现了视频卡片和列表区域的联动滚动场景
 *
 * 推荐场景: 视频与列表联动场景
 *
 * 核心组件:
 * 1. Scroll
 *
 * 实现步骤：
 * 1.初始化新闻列表数据 NEWS_LIST_DATA，通过状态变量currentPlayNews和currentIndex跟踪当前播放的新闻
 * 2.为了解决新闻列表与外层Scroll容器嵌套时的滚动冲突问题，给新闻列表List设置 nestedScroll 属性，指定列表向末尾端和起始端滚动时与外层Scroll的嵌套滚动方式
 * 3.为了实现视频卡片的吸顶效果， Scroll 容器的内容高度使用 calc 计算属性设置为 Scroll 容器高度和视频高度的和，使 Scroll 滚动到尾部边缘时，视频隐藏，视频卡片吸顶
 * 4.新闻列表组件设置 layoutWeight 为1，使列表自动占满 Scroll 内容的剩余空间，当视频卡片吸顶时新闻列表可以完全显示，并且当新闻标题改变导致卡片高度发生变化时，新闻列表组件高度也相应变化
 * 5.通过状态变量isHideVideo修改视频的高度实现显隐，Scroll滚动到末尾时隐藏视频，视频已隐藏情况下, Scroll向下滚动时显示视频
 * 6.在状态变量isHideVideo的监听回调中，根据视频的显隐状态修改视频卡片的上边距保持Scroll内容高度不变，避免滚动混乱
 * 7.在视频卡片中上一条、下一条按钮的点击回调中修改currentIndex和currentPlayNews
 * 8.在新闻列表组件中监听状态变量currentIndex，根据选中项的索引值计算列表的滚动偏移
 */

@Component
export struct VideoLinkageListView {
  // 当前播放的新闻
  @State currentPlayNews: NewsItem = new NewsItem('', '');
  // 当前播放的新闻在列表中的下标
  @State currentIndex: number = 0;
  // 是否隐藏视频区域
  @State @Watch('onIsHideVideoChange') isHideVideo: boolean = false;
  // 视频卡片上边距
  @State videoMarginTop: number = Constants.VIDEO_CARD_MARGIN_TOP;
  // 当前选中的tab，默认为1，用于UX展示
  @State selectTabIndex: number = 1;
  // 新闻数据
  private newsList: NewsListDataSource = new NewsListDataSource();
  private scroller: Scroller = new Scroller();
  private controller: TabsController = new TabsController();

  async aboutToAppear() {
    // 新闻列表数据初始化
    NEWS_LIST_DATA.forEach((news: NewsItem) => {
      this.newsList.pushData(news);
    })
    this.currentPlayNews = this.newsList.getData(this.currentIndex);
  }

  // TODO：知识点：根据视频显隐状态修改边距，使用边距代替video占位，使Scroll容器内容高度不变，可以向下滚动显示视频，并且避免滚动混乱
  onIsHideVideoChange() {
    if (!this.isHideVideo) {
      // 视频显示，视频卡片上边距减去视频高度
      this.videoMarginTop -= Constants.VIDEO_HEIGHT;
    } else {
      // 视频隐藏，视频卡片上边距加上视频高度
      this.videoMarginTop += Constants.VIDEO_HEIGHT;
    }
  }

  // tabbar布局，仅用于UX显示
  @Builder
  tabBuilder(index: number, tabBar: Resource, icon: Resource) {
    Column() {
      Image(icon)
        .width($r('app.integer.video_linkage_list_tabbar_icon_size'))
        .height($r('app.integer.video_linkage_list_tabbar_icon_size'))
        .margin({ bottom: $r('app.integer.video_linkage_list_tabbar_icon_margin_bottom') })
        .fillColor(this.selectTabIndex === index ? $r('app.color.video_linkage_list_tabbar_selected') :
        $r('app.color.video_linkage_list_tabbar_default'))
      Text(tabBar)
        .fontColor(this.selectTabIndex === index ? $r('app.color.video_linkage_list_tabbar_selected') :
        $r('app.color.video_linkage_list_tabbar_default'))
        .fontSize($r('app.integer.video_linkage_list_tabbar_text_font_size'))
        .fontWeight(FontWeight.Medium)
        .lineHeight($r('app.integer.video_linkage_list_tabbar_text_line_height'))
    }
    .width($r('app.string.video_linkage_list_full_size'))
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.controller, index: this.selectTabIndex }) {
      TabContent() {
        Column() {
          Column() {
            Text($r('app.string.video_linkage_list_discover_title'))
              .fontSize($r('app.integer.video_linkage_list_discover_title_font_size'))
              .fontWeight(FontWeight.Bolder)
            Row()
              .width($r('app.integer.video_linkage_list_discover_title_line_width'))
              .height($r('app.integer.video_linkage_list_discover_title_line_height'))
              .backgroundColor(Color.Red)
              .margin({ top: $r('app.integer.video_linkage_list_discover_title_line_margin') })
          }
          .height($r('app.integer.video_linkage_list_title_height'))
          .justifyContent(FlexAlign.End)

          Scroll(this.scroller) {
            Column() {
              NewsVideoView({
                currentPlayNews: this.currentPlayNews,
                currentIndex: this.currentIndex,
                newsList: this.newsList,
                isHideVideo: this.isHideVideo
              })
                .margin({ top: this.videoMarginTop, bottom: $r('app.integer.video_linkage_list_video_card_margin_bottom') })
              NewsListView({
                currentPlayNews: this.currentPlayNews,
                currentIndex: this.currentIndex,
                newsList: this.newsList,
                isHideVideo: this.isHideVideo
              })
            }
            .height(`calc(${Constants.VIDEO_HEIGHT}vp + 100%)`)
          }
          .id('videoLinkageListScroll')
          .width($r('app.string.video_linkage_list_full_size'))
          .layoutWeight(Constants.LAYOUT_WEIGHT)
          .scrollBar(BarState.Off)
          // 去除回弹效果，避免回弹时重复触发onReachEnd
          .edgeEffect(EdgeEffect.None)
          // TODO: 性能知识点：onWillScroll属于频繁回调接口，应该避免在内部进行冗余和耗时操作，例如避免打印日志
          .onWillScroll((xOffset: number, yOffset: number) => {
            // 视频已隐藏情况下, Scroll向下滚动时显示视频
            if (yOffset < 0 && this.isHideVideo) {
              this.isHideVideo = false;
            }
          })
          .onReachEnd(() => {
            // Scroll滚动到末尾时隐藏视频
            this.isHideVideo = true;
          })
        }
        .width($r('app.string.video_linkage_list_full_size'))
        .height($r('app.string.video_linkage_list_full_size'))
        .linearGradient({
          direction: GradientDirection.Right, // 渐变方向
          repeating: false, // 渐变颜色是否重复
          colors: [[$r('app.color.video_linkage_list_linear_gradient_start'), 0],
            [$r('app.color.video_linkage_list_linear_gradient_end'), 1]] // 数组末尾元素占比小于1时满足重复着色效果
        })
      }
      .tabBar(this.tabBuilder(1, $r('app.string.video_linkage_list_discover'),
        $r('app.media.video_linkage_list_discover')))
    }
    .vertical(false)
    .barHeight($r('app.integer.video_linkage_list_tabbar_height'))
    .onChange((index: number) => {
      this.selectTabIndex = index
    })
    .width($r('app.string.video_linkage_list_full_size'))
    .height($r('app.string.video_linkage_list_full_size'))
    .divider({ strokeWidth: Constants.STROKE_WIDTH })
    .barBackgroundColor($r('app.color.video_linkage_color_background'))
    .backgroundColor($r('app.color.video_linkage_color_background'))
  }
}

// 视频卡片组件
@Component
struct NewsVideoView {
  @Link currentPlayNews: NewsItem; // 当前播放的新闻
  @Link currentIndex: number; // 当前播放的新闻下标
  @Link isHideVideo: boolean; // 是否隐藏视频区域
  @State currentTime: number = 0; // 视频播放进度
  @State videoDuration: number = 0; // 视频时长
  @State isPlaying: boolean = false; // 是否正在播放
  controller: VideoController = new VideoController();
  newsList: NewsListDataSource = new NewsListDataSource();

  // 视频进度条时间格式化为 00:00
  timeFormat(time: number): string {
    const minutes = Math.floor(time / Constants.SECONDS_PER_MINUTE);
    const seconds = Math.floor(time % Constants.SECONDS_PER_MINUTE);

    let minutesStr = minutes.toString();
    let secondsStr = seconds.toString();

    if (minutesStr.length === 1) {
      minutesStr = '0' + minutesStr;
    }
    if (secondsStr.length === 1) {
      secondsStr = '0' + secondsStr;
    }
    return `${minutesStr}:${secondsStr}`;
  }

  build() {
    Column() {
      if (!this.isHideVideo) {
        Stack({ alignContent: Alignment.Bottom }) {
          Video({
            src: this.currentPlayNews.newsVideoSrc,
            controller: this.controller
          })
            .id('videoLinkageListVideo')
            .controls(false)
            .autoPlay(true)
            .height($r('app.string.video_linkage_list_full_size'))
            .borderRadius({
              topLeft: $r('app.string.video_linkage_corner_radius_default_l'),
              topRight: $r('app.string.video_linkage_corner_radius_default_l')
            })
            .onPrepared((event: Record<string, number>) => {
              this.videoDuration = event.duration;
            })
            .onStart(() => {
              // 视频初始化播放时暂停，解决黑屏问题
              if (!this.isPlaying) {
                this.controller.pause();
              }
            })
            .onUpdate((event: Record<string, number>) => {
              this.currentTime = event.time;
            })
            .onFinish(() => {
              this.isPlaying = false;
              if (PlatformInfo.isArkUIX()) {
                this.currentTime = this.videoDuration
              }
            })
          Row() {
            Text(this.timeFormat(this.currentTime))
              .fontColor($r('app.color.video_linkage_color_background'))
              .id('currentTime')
            Progress({ value: this.currentTime, total: this.videoDuration, type: ProgressType.Linear })
              .style({
                strokeWidth: $r('app.integer.video_linkage_list_progress_stroke_width'),
                enableSmoothEffect: false
              })
              .layoutWeight(Constants.LAYOUT_WEIGHT)
              .color($r('app.color.video_linkage_color_background'))
              .backgroundColor($r('app.color.video_linkage_list_progress_background'))
              .padding({
                left: $r('app.string.video_linkage_card_padding_start'),
                right: $r('app.string.video_linkage_card_padding_start')
              })
            Text(this.timeFormat(this.videoDuration))
              .fontColor($r('app.color.video_linkage_color_background'))
          }
          .width($r('app.string.video_linkage_list_full_size'))
          .padding({
            left: $r('app.string.video_linkage_card_padding_start'),
            right: $r('app.string.video_linkage_card_padding_start')
          })
          .margin({ bottom: $r('app.string.video_linkage_card_margin_start') })
        }
        .width($r('app.string.video_linkage_list_full_size'))
        // 修改视频的高度实现显隐控制
        .height(Constants.VIDEO_HEIGHT)
      }
      // 新闻标题
      Text(this.currentPlayNews.newsName)
        .id('newsName')
        .width($r('app.string.video_linkage_list_full_size'))
        .fontSize($r('app.string.video_linkage_text_size_headline'))
        .fontWeight(FontWeight.Bolder)
        .padding($r('app.integer.video_linkage_list_news_name_padding'))
      // 播放控制
      Row() {
        // 倍速
        Text($r('app.string.video_linkage_list_rate'))
          .fontColor($r('app.color.video_linkage_list_default_color'))
          .borderRadius($r('app.integer.video_linkage_list_control_rate_border_radius'))
          .height($r('app.integer.video_linkage_list_control_rate_height'))
          .width($r('app.integer.video_linkage_list_control_rate_width'))
          .textAlign(TextAlign.Center)
          .backgroundColor($r('app.color.video_linkage_list_rate_background'))
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.video_linkage_list_function_toast')
            });
          })
        Row() {
          // 上一条
          Image($r('app.media.video_linkage_list_play_previous'))
            .id('prev')
            .height($r('app.integer.video_linkage_list_control_previous_next_height'))
            .onClick(() => {
              // 如果不是第一条，切换至上一条
              if (this.currentIndex > 0) {
                this.currentIndex--;
                this.currentPlayNews = this.newsList.getData(this.currentIndex);
              } else {
                promptAction.showToast({
                  message: $r('app.string.video_linkage_list_first_data_toast')
                });
              }
            })
          // 暂停/播放
          if (this.isPlaying) {
            Image($r('app.media.video_linkage_list_pause_norm'))
              .id('pause')
              .width($r('app.integer.video_linkage_list_control_play_size'))
              .height($r('app.integer.video_linkage_list_control_play_size'))
              .onClick(() => {
                // 切换播放状态
                this.controller.pause();
                this.isPlaying = false;
              })
          } else {
            Image($r('app.media.video_linkage_list_play_norm'))
              .id('play')
              .width($r('app.integer.video_linkage_list_control_play_size'))
              .height($r('app.integer.video_linkage_list_control_play_size'))
              .onClick(() => {
                this.controller.start();
                this.isPlaying = true;
              })
          }

          // 下一条
          Image($r('app.media.video_linkage_list_play_next'))
            .id('next')
            .height($r('app.integer.video_linkage_list_control_previous_next_height'))
            .onClick(() => {
              // 如果不是最后一条，切换至下一条
              if (this.currentIndex < this.newsList.totalCount() - 1) {
                this.currentIndex++;
                this.currentPlayNews = this.newsList.getData(this.currentIndex);
                this.currentTime = 0;
              } else {
                promptAction.showToast({
                  message: $r('app.string.video_linkage_list_last_data_toast')
                });
              }
            })
        }
        .width($r('app.integer.video_linkage_list_control_buttons_width'))
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({
          left: $r('app.integer.video_linkage_list_control_buttons_margin'),
          right: $r('app.integer.video_linkage_list_control_buttons_margin')
        })

        // 定时，仅用于UX展示
        Image($r('app.media.video_linkage_list_alarm'))
          .height($r('app.integer.video_linkage_list_control_alarm_height'))
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.video_linkage_list_function_toast')
            });
          })
      }
      .width($r('app.string.video_linkage_list_full_size'))
      .height($r('app.integer.video_linkage_list_control_height'))
      .padding({
        left: $r('app.integer.video_linkage_list_control_padding'),
        right: $r('app.integer.video_linkage_list_control_padding'),
        bottom: $r('app.integer.video_linkage_list_control_padding')
      })
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width($r('app.string.video_linkage_list_video_card_width'))
    .borderRadius($r('app.string.video_linkage_corner_radius_default_l'))
    .backgroundColor($r('app.color.video_linkage_color_background'))
    .id('newsVideoView')
  }
}

// 新闻列表组件
@Component
struct NewsListView {
  @Link currentPlayNews: NewsItem; // 当前播放的新闻
  @Link @Watch('onCurrentIndexChange') currentIndex: number; // 当前播放的新闻在列表中的下标
  @Link isHideVideo: boolean; // 是否已滚动到顶部，隐藏视频区域
  scroller: ListScroller = new ListScroller();
  newsList: NewsListDataSource = new NewsListDataSource();

  // TODO：知识点：监听currentIndex的变化，视频播放卡片切换新闻和点击列表项切换新闻时修改currentIndex,根据下标计算列表的滚动偏移
  onCurrentIndexChange() {
    // 选中的列表项下标大于3时，列表向上滚动，滚动到与列表显示区域内上方间隔3个列表项或列表尾部时停止。
    if (this.currentIndex > Constants.NEWS_LIST_SCROLL_TO_INDEX) {
      this.scroller.scrollTo({
        yOffset: Constants.NEWS_LIST_ITEM_HEIGHT * (this.currentIndex - Constants.NEWS_LIST_SCROLL_TO_INDEX),
        xOffset: 0
      });
    } else {
      // 选中的列表项下标小于等于3时，列表滚动至头部
      this.scroller.scrollTo({ yOffset: 0, xOffset: 0 });
    }
  }

  build() {
    List({ scroller: this.scroller }) {
      /**
       * 性能知识点：列表中数据较多且不确定的情况下，使用LazyForEach进行数据循环渲染。
       * 当组件滑出可视区域外时，框架会进行组件销毁回收以降低内存占用。
       * 文档参考链接：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/arkts-rendering-control-lazyforeach-0000001524417213-V2
       */
      LazyForEach(this.newsList, (news: NewsItem, index: number) => {
        ListItem() {
          Row() {
            Image(this.currentIndex === index ? $r('app.media.video_linkage_list_play_selected') : $r('app.media.video_linkage_list_play'))
              .height($r('app.integer.video_linkage_list_item_name_height'))
              .margin({ right: $r('app.integer.video_linkage_list_item_icon_margin') })
            Text(news.newsName)
              .layoutWeight(Constants.LAYOUT_WEIGHT)// 内容超出文本宽度显示省略号，当前处于选中状态时在一行内滚动
              .maxLines(Constants.MAX_LINES)
              .textOverflow({ overflow: this.currentIndex === index ? TextOverflow.MARQUEE : TextOverflow.Ellipsis })
              .fontColor(this.currentIndex === index ? $r('app.color.video_linkage_list_item_selected') :
              $r('app.color.video_linkage_color_foreground'))
          }
          .alignSelf(ItemAlign.Center)
          .onClick(() => {
            this.currentIndex = index;
            this.currentPlayNews = news;
          })
        }
        .id(`videoLinkageListItem${index}`)
        .height(Constants.NEWS_LIST_ITEM_HEIGHT)
      })
    }
    .id('videoLinkageListList')
    .width($r('app.string.video_linkage_list_full_size'))
    .layoutWeight(Constants.LAYOUT_WEIGHT)
    .padding($r('app.integer.video_linkage_list_news_list_padding'))
    .scrollBar(BarState.Off)
    // 去除回弹效果，避免回弹时重复触发onReachEnd
    .edgeEffect(EdgeEffect.None)
    .backgroundColor($r('app.color.video_linkage_color_background'))
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST, // 可滚动组件往末尾端滚动时的嵌套滚动选项,父组件先滚动，父组件滚动到边缘以后自身滚动。
      scrollBackward: NestedScrollMode.SELF_FIRST // 可滚动组件往起始端滚动时的嵌套滚动选项,自身先滚动，自身滚动到边缘以后父组件滚动。
    })
    .onReachEnd(()=>{
      // 列表触底加载数据
      NEWS_LIST_DATA.forEach((news: NewsItem) => {
        this.newsList.pushData(news);
      })
    })
  }
}
