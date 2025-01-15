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

import { common } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';
import { UserModel } from '@ohos/mine';
import { LoadingFailedView, LoadingMore, NoMore } from '@ohos/uicomponents';
import {
  BreakpointType,
  BreakpointTypeEnum,
  CommonConstants,
  ContinueModel,
  EventTypeEnum,
  LazyDataSource,
  LearningResource,
  LoadingStatus,
  Logger,
  ObservedArray,
  RouterNameEnum
} from '@ohos/utils';
import { DiscoverModel } from '../model/DiscoverModel';
import { ArticleCardView } from '../components/ArticleCardView';
import { DiscoverSkeletonView } from './DiscoverSkeletonView';
import { FeedFlowItem } from '../components/FeedFlowItem';

const FEEDS_VISIBLE_LENGTH = 6;
const FEED_CARD_WIDTH_SM = '43.4%';
const FEED_CARD_WIDTH_MD = '21.6%';
const FEED_CARD_WIDTH_LG = '15%';
const SWIPER_ASPECT_RATIO = 2.4;
const SWIPER_MARGIN_MD = 220;
const SWIPER_MARGIN_LG = 100;
const COUNT_TWO = 2;
const COUNT_THREE = 3;

const TAG = '[DiscoverView]';
let continueModel = ContinueModel.getInstance();

@Entry({ routeName: 'DiscoverView' })
@Component
export struct DiscoverView {
  @State userModel: UserModel = UserModel.getInstance();
  @State discoverModel: DiscoverModel = DiscoverModel.getInstance();
  @State hotFeedList: ObservedArray<LearningResource> = this.discoverModel.feedArticleDataSource.dataArray;
  @State isListReachEnd: boolean = false;
  @StorageLink('getHomeResource') @Watch('handleGetHomeResourceChanged') getHomeResource: boolean = false;
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  @State loadingStatus: LoadingStatus = LoadingStatus.OFF;
  @State techArticleDataSource: LazyDataSource<LearningResource> = this.discoverModel.techArticleDataSource;

  dynamicLoading(): void {
    try {
      import('./FeedWaterFlowView');
      import('./SearchView');
      import('@ohos/mine/src/main/ets/views/DiscoverArticleDetailView');
    } catch (err) {
      Logger.error(TAG, 'dynamicLoading error:' + err);
    }
  }

  aboutToAppear() {
    this.dynamicLoading();
    this.userModel.getUserData();
    this.loadResources();
    this.discoverModel.getHotList();

    let routerName = continueModel.geRouterName();
    Logger.info(TAG, 'aboutToAppear routerName is:' + routerName);

    if (continueModel.isContinue && routerName === RouterNameEnum.DISCOVER_ARTICLE_VIEW) {
      let learningResource: LearningResource = continueModel.data?.itemData as LearningResource;
      if (learningResource.from) {
        this.jumpList();
      }
      this.jumpDetail(learningResource);
      continueModel.resetContinue();
    }

    if (continueModel.isContinue && routerName === RouterNameEnum.DISCOVER_FEED_WATER_FLOW) {
      this.jumpList();
      continueModel.resetContinue();
    }
  }

  loadResources(): void {
    this.loadingStatus = LoadingStatus.LOADING;
    this.discoverModel.getHomeResources().then(() => {
      this.loadingStatus = LoadingStatus.SUCCESS;
      AppStorage.setOrCreate('getHomeResource', false);
    }).catch(() => {
      this.loadingStatus = LoadingStatus.FAILED;
    });
  }

  handleGetHomeResourceChanged(): void {
    if (!this.getHomeResource) {
      return;
    }
    this.loadResources();
  }

  jumpDetail(item: LearningResource): void {
    router.pushNamedRoute({
      name: 'DiscoverArticleDetailView',
      params: new Object({
        articleDetail: item,
      })
    });
  }

  jumpList(): void {
    router.pushNamedRoute({
      name: "FeedWaterFlowView"
    });
  }

  @Builder
  feedTitleBuilder() {
    Row() {
      Text($r('app.string.hot_feeds'))
        .padding({
          left: this.currentBreakpoint === BreakpointTypeEnum.SM ? $r('app.float.md_padding_margin') : 0,
        })
        .fontColor($r('app.color.theme_font_color'))
        .fontSize($r('app.float.lg_font_size'))
        .fontWeight(FontWeight.Medium)
        .fontFamily(CommonConstants.HARMONY_HEITI_MEDIUM_FONT_FAMILY)
      Row() {
        Text($r('app.string.more'))
          .fontSize($r('app.float.md_font_size'))
          .fontColor($r('sys.color.ohos_id_color_foreground'))
          .opacity(CommonConstants.SECOND_LEVEL_OPACITY)

        Image($r('app.media.symbol_chevron_right'))
          .width('24fp')
          .height('24fp')
          .margin({ right: 5 })
      }
      .onClick(() => this.jumpList())
    }
    .alignItems(VerticalAlign.Center)
    .padding({
      right: new BreakpointType({
        sm: $r('app.float.md_padding_margin'),
        md: $r('app.float.xxl_padding_margin'),
        lg: $r('app.float.xxl_padding_margin')
      }).getValue(this.currentBreakpoint),
      left: new BreakpointType({
        sm: $r('app.float.md_padding_margin'),
        md: $r('app.float.xxl_padding_margin'),
        lg: $r('app.float.xxl_padding_margin')
      }).getValue(this.currentBreakpoint),
      top: $r('app.float.sm_padding_margin'),
      bottom: $r('app.float.sm_padding_margin')
    })
    .width(CommonConstants.FULL_PERCENT)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  articleTitleBuilder() {
    Text($r('app.string.technical_articles'))
      .margin({
        left: this.currentBreakpoint === BreakpointTypeEnum.SM ? $r('app.float.md_padding_margin') : 0,
      })
      .fontSize($r('app.float.lg_font_size'))
      .width(CommonConstants.FULL_PERCENT)
      .fontFamily(CommonConstants.HARMONY_HEITI_MEDIUM_FONT_FAMILY)
      .fontWeight(FontWeight.Medium)
      .padding({
        right: new BreakpointType({
          sm: $r('app.float.md_padding_margin'),
          md: $r('app.float.xxl_padding_margin'),
          lg: $r('app.float.xxl_padding_margin')
        }).getValue(this.currentBreakpoint),
        left: new BreakpointType({
          sm: $r('app.float.md_padding_margin'),
          md: $r('app.float.xxl_padding_margin'),
          lg: $r('app.float.xxl_padding_margin')
        }).getValue(this.currentBreakpoint),
        top: $r('app.float.sm_padding_margin'),
        bottom: $r('app.float.sm_padding_margin')
      })
  }

  build() {
    Navigation() {
      Column() {
        Row() {
          Text($r('app.string.discover'))
            .fontSize($r('app.float.header_font_size'))
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .fontFamily(CommonConstants.HARMONY_HEITI_BOLD_FONT_FAMILY)
            .margin({ right: $r('app.float.sm_padding_margin') })

          Search({ placeholder: 'Search' })
            .focusable(false)
            .textFont({ size: $r('app.float.large_text_size') })
            .width($r('app.float.search_width'))
            .height($r('app.float.search_height'))
            .searchIcon({
              src: $r('app.media.seach')
            })
            .cancelButton({
              style: CancelButtonStyle.CONSTANT,
              icon: {
                src: $r('app.media.cancel')
              }
            })
            .onClick(() => {
              router.pushNamedRoute({ name: 'SearchView' });
            })
        }
        .padding({ left: $r('app.float.xxl_padding_margin'), right: $r('app.float.lg_padding_margin') })
        .justifyContent(FlexAlign.SpaceBetween)
        .width(CommonConstants.FULL_PERCENT)
        .height($r('app.float.top_navigation_height'))

        if (this.loadingStatus === LoadingStatus.LOADING) {
          DiscoverSkeletonView()
        }
        if (this.loadingStatus === LoadingStatus.FAILED) {
          LoadingFailedView(() => this.loadResources())
        }
        if (this.loadingStatus === LoadingStatus.SUCCESS) {
          List({ space: CommonConstants.SPACE_16 }) {
            ListItem() {
              Banner({
                swiperData: this.discoverModel.swiperData,
                handleClick: (item: LearningResource) => this.jumpDetail(item)
              })
            }

            ListItemGroup({ header: this.feedTitleBuilder() }) {
              HotFeeds({
                hotFeedList: this.hotFeedList,
                handleClick: (item: LearningResource) => this.jumpDetail(item)
              })
            }

            ListItemGroup({ header: this.articleTitleBuilder() }) {
              TechArticles({
                articlesDataSource: this.techArticleDataSource,
                handleClick: (item: LearningResource) => this.jumpDetail(item),
                discoverModel: this.discoverModel
              })
            }
          }
          .scrollBar(BarState.Off)
          .layoutWeight(1)
          .height(CommonConstants.FULL_PERCENT)
          .width(CommonConstants.FULL_PERCENT)
        }
      }
      .padding({
        top: AppStorage.get<number>('statusBarHeight')
      })
      .height(CommonConstants.FULL_PERCENT)
      .width(CommonConstants.FULL_PERCENT)
    }
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }
}

@Component
struct Banner {
  @Prop swiperData: LearningResource[];
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  @State showPrevMargin: boolean = false;
  @State imgHeight: Length = 0;
  private swiperController: SwiperController = new SwiperController();
  handleClick: (item: LearningResource) => void = () => {
  };

  build() {
    Stack() {
      Swiper(this.swiperController) {
        ForEach(this.swiperData, (item: LearningResource, index: number) => {
          Row() {
            Image(item.bannerSrc)
              .width(CommonConstants.FULL_PERCENT)
              .height(CommonConstants.FULL_PERCENT)
              .borderRadius($r('app.float.lg_border_radius'))
              .onClick(() => this.handleClick(item))
          }
          .aspectRatio(SWIPER_ASPECT_RATIO)
          .onAreaChange((oldValue: Area, newValue: Area) => {
            if (index === 0 && !this.showPrevMargin) {
              this.imgHeight = newValue.height;
            }
          })
          .onAppear(() => {
            if (index === 0 && this.currentBreakpoint !== BreakpointTypeEnum.SM) {
              setTimeout(() => {
                this.showPrevMargin = true;
              }, 3000)
            }
          })
          .padding({
            left: $r('app.float.md_padding_margin'),
          })
        }, (item: LearningResource) => item.id)
      }
      .width(CommonConstants.FULL_PERCENT)
      .displayCount(new BreakpointType({ sm: 1, md: 1, lg: COUNT_TWO }).getValue(this.currentBreakpoint))
      .nextMargin(new BreakpointType<Length>({
        sm: $r('app.float.md_padding_margin'),
        md: SWIPER_MARGIN_MD,
        lg: SWIPER_MARGIN_LG
      }).getValue(this.currentBreakpoint))
      .prevMargin(this.currentBreakpoint === BreakpointTypeEnum.SM ? 0 : $r('app.float.md_padding_margin'))
      .width(CommonConstants.FULL_PERCENT)
      .indicator(this.currentBreakpoint === BreakpointTypeEnum.SM ? Indicator.dot()
        .color($r('app.color.swiper_indicator_color'))
        .selectedColor($r('app.color.theme_blue_color')) : false)
      .autoPlay(true)
      .loop(true)

      Column()
        .height(this.imgHeight)
        .width($r('app.float.md_padding_margin'))
        .backgroundColor($r('app.color.common_background_color'))
        .visibility((this.showPrevMargin || this.currentBreakpoint === BreakpointTypeEnum.SM) ? Visibility.Hidden :
        Visibility.Visible)
    }
    .alignContent(Alignment.Start)
  }
}

@Component
struct HotFeeds {
  @ObjectLink hotFeedList: ObservedArray<LearningResource>;
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  handleClick: (item: LearningResource) => void = () => {
  };

  build() {
    Column({ space: CommonConstants.SPACE_8 }) {
      List() {
        ForEach(this.hotFeedList.slice(0, FEEDS_VISIBLE_LENGTH), (item: LearningResource, index: number) => {
          ListItem() {
            FeedFlowItem({ feedItem: item })
              .onClick(() => this.handleClick(item))
          }
          .margin({
            left: index === 0 ? new BreakpointType({
              sm: $r('app.float.md_padding_margin'),
              md: $r('app.float.xxl_padding_margin'),
              lg: $r('app.float.xxl_padding_margin')
            }).getValue(this.currentBreakpoint) : 0,
            right: (this.currentBreakpoint !== BreakpointTypeEnum.SM && index === FEEDS_VISIBLE_LENGTH - 1)
              ? $r('app.float.xxl_padding_margin') : $r('app.float.md_padding_margin')
          })
          .width(new BreakpointType<ResourceStr>({
            sm: FEED_CARD_WIDTH_SM,
            md: FEED_CARD_WIDTH_MD,
            lg: FEED_CARD_WIDTH_LG
          }).getValue(this.currentBreakpoint))
        }, (item: LearningResource) => item.id)
      }
      .edgeEffect(EdgeEffect.None)
      .scrollBar(BarState.Off)
      .listDirection(Axis.Horizontal)
    }
  }
}

@Component
export struct TechArticles {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  @State userModel: UserModel = UserModel.getInstance();
  @State @Watch('userOperationChanged') collectedIds: ObservedArray<string> = this.userModel.collectedIds;
  @State @Watch('userOperationChanged') likedIds: ObservedArray<string> = this.userModel.likedIds;
  @ObjectLink @Watch('userOperationChanged') articlesDataSource: LazyDataSource<LearningResource>;
  @State isListReachEnd: boolean = false;
  @Link discoverModel: DiscoverModel;
  private eventHub: common.EventHub = (getContext(this) as common.UIAbilityContext).eventHub;
  handleClick: (item: LearningResource) => void = () => {
  };

  aboutToAppear(): void {
    this.userOperationChanged();
  }

  // After a user likes and collects favorites, the article list data needs to be updated.
  userOperationChanged() {
    this.articlesDataSource.dataArray.forEach((item: LearningResource) => {
      item.isCollected = this.collectedIds.some((id: string) => id === item.id);
      item.isLiked = this.likedIds.some((id: string) => id === item.id);
    });
  }

  build() {
    Column() {
      List({ space: CommonConstants.SPACE_12 }) {
        LazyForEach(this.articlesDataSource, (item: LearningResource, index: number) => {
          ListItem() {
            ArticleCardView({
              articleItem: item,
              onCollected: (articleItem: LearningResource) => {
                this.eventHub.emit(EventTypeEnum.COLLECTED, {
                  resourceId: articleItem.id,
                  resourceType: articleItem.type,
                  actionValue: !articleItem.isCollected
                });
              },
              onLiked: (articleItem: LearningResource) => {
                this.eventHub.emit(EventTypeEnum.LIKED, {
                  resourceId: articleItem.id,
                  resourceType: articleItem.type,
                  actionValue: !articleItem.isLiked
                });
              }
            })
              .onClick(() => this.handleClick(item))
              .reuseId('article')
          }
          .onAppear(() => {
            if (this.discoverModel.loadingArticleStatus !== LoadingStatus.LOADING &&
            this.discoverModel.hasNextArticle && index + 3 === this.articlesDataSource.dataArray.length) {
              this.discoverModel.loadMoreArticle().then(() => {
                this.userOperationChanged();
              });
            }
          })
          .padding({ right: $r('app.float.md_padding_margin') })
        }, (item: LearningResource, index: number) => JSON.stringify(item) + index)

        if (this.discoverModel.loadingArticleStatus === LoadingStatus.LOADING) {
          ListItemGroup({ header: LoadingMore() }) {
          }
        }
        if (!this.discoverModel.hasNextArticle) {
          ListItemGroup({ header: NoMore() }) {
          }
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .nestedScroll({
        scrollForward: NestedScrollMode.PARENT_FIRST,
        scrollBackward: NestedScrollMode.SELF_FIRST
      })
      .lanes(new BreakpointType({ sm: 1, md: COUNT_TWO, lg: COUNT_THREE }).getValue(this.currentBreakpoint))
    }
    .padding({
      left: this.currentBreakpoint === BreakpointTypeEnum.SM ? $r('app.float.md_padding_margin') :
      $r('app.float.xxl_padding_margin'),
      right: this.currentBreakpoint === BreakpointTypeEnum.SM ? 0 : $r('app.float.md_padding_margin')
    })
  }
}
