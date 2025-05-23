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
import { ArticleCardView, FeedCardView, UserModel } from '@ohos/mine';
import { LoadingFailedView, LoadingView, NoneContentView } from '@ohos/uicomponents';
import {
  BreakpointType,
  BreakpointTypeEnum,
  CommonConstants,
  EventTypeEnum,
  LazyDataSource,
  LearningResource,
  LoadingStatus,
  Logger,
  ObservedArray,
  ResourcesType
} from '@ohos/utils';
import { DiscoverModel } from '../model/DiscoverModel';
import { SearchBar } from '../components/SearchBar';

const TAG = '[SearchResultView]';
const context = (getContext(this) as common.UIAbilityContext);

@Entry({ routeName: 'SearchResultView' })
@Component
export struct SearchResultView {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  @State searchValue: string = '';
  @State userModel: UserModel = UserModel.getInstance();
  @State discoverModel: DiscoverModel = DiscoverModel.getInstance();
  @State @Watch('userOperationChanged') collectedIds: ObservedArray<string> = this.userModel.collectedIds;
  @State @Watch('userOperationChanged') likedIds: ObservedArray<string> = this.userModel.likedIds;
  @State isFocus: boolean = false;
  @State @Watch('userOperationChanged') searchList: LazyDataSource<LearningResource> =
    this.discoverModel.techArticleDataSource;

  dynamicLoading(): void {
    try {
      import('./SearchView');
      import('@ohos/mine/src/main/ets/views/DiscoverArticleDetailView');
    } catch (err) {
      Logger.error(TAG, 'dynamicLoading error:' + err);
    }
  }

  aboutToAppear() {
    this.dynamicLoading();
  }

  // After a user likes and collects favorites, the article list data needs to be updated.
  userOperationChanged() {
    this.searchList.dataArray.forEach((item: LearningResource) => {
      item.isCollected = this.collectedIds.some((id: string) => id === item.id);
      item.isLiked = this.likedIds.some((id: string) => id === item.id);
    });
  }

  handleSearch(item: string): void {
    this.searchValue = item;
    this.discoverModel.search(item);
  }

  jumpDetail(item: LearningResource): void {
    router.pushNamedRoute({
      name: 'DiscoverArticleDetailView',
      params:
      new Object({
        articleDetail: item,
        onDestinationBack: () => {
          router.back();
          return false;
        }
      })
    });
  }

  @Builder
  ResultList() {
    List({ space: CommonConstants.SPACE_12 }) {
      LazyForEach(this.searchList, (content: LearningResource) => {
        ListItem() {
          if (content.type === ResourcesType.ARTICLE) {
            ArticleCardView({
              articleItem: content,
              onCollected: (articleItem: LearningResource) => {
                context.eventHub.emit(EventTypeEnum.COLLECTED, {
                  resourceId: articleItem.id,
                  resourceType: articleItem.type,
                  actionValue: !articleItem.isCollected
                })
              },
              onLiked: (articleItem: LearningResource) => {
                context.eventHub.emit(EventTypeEnum.LIKED, {
                  resourceId: articleItem.id,
                  resourceType: articleItem.type,
                  actionValue: !articleItem.isLiked
                })
              },
            })
              .reuseId('article')
          } else {
            FeedCardView({
              articleItem: content
            })
              .reuseId('feed')
          }
        }
        .borderRadius($r('app.float.xxl_border_radius'))
        .margin({ right: this.currentBreakpoint === BreakpointTypeEnum.SM ? 0 : $r('app.float.md_padding_margin') })
        .onClick(() => this.jumpDetail(content))
      }, (item: LearningResource) => item.id)
    }
    .cachedCount(3)
    .padding({
      left: $r('app.float.lg_padding_margin'),
      right: $r('app.float.lg_padding_margin'),
    })
    .margin({
      bottom: $r('app.float.lg_padding_margin')
    })
    .lanes(new BreakpointType({
      sm: CommonConstants.SM_COLUMN_COUNT,
      md: CommonConstants.MD_COLUMN_COUNT,
      lg: CommonConstants.LG_COLUMN_COUNT
    }).getValue(this.currentBreakpoint))
    .width(CommonConstants.FULL_PERCENT)
    .layoutWeight(1)
    .scrollBar(BarState.Off)
  }

  build() {
    NavDestination() {
      Column() {
        SearchBar({
          enableKeyboardOnFocus: false,
          searchValue: this.searchValue,
          onSearch: (value) => this.handleSearch(value),
          onBack: () => {
            router.replaceNamedRoute({ name: 'SearchView' });
          }
        })
          .padding({
            left: $r('app.float.lg_padding_margin'),
            right: $r('app.float.lg_padding_margin')
          })

        if (this.discoverModel.searchLoadingStatus === LoadingStatus.LOADING) {
          LoadingView()
        } else if (this.discoverModel.searchLoadingStatus === LoadingStatus.FAILED) {
          LoadingFailedView(() => this.handleSearch(this.searchValue))
        } else if (this.discoverModel.searchLoadingStatus === LoadingStatus.SUCCESS
          && this.discoverModel.searchResultDataSource.totalCount() === 0) {
          NoneContentView($r('app.media.ic_search_empty'), $r('app.string.no_search_result'))
        } else {
          this.ResultList()
        }
      }
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      .padding({
        top: AppStorage.get<number>('statusBarHeight'),
      })
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
    .hideTitleBar(true)
    .onReady((cxt: NavDestinationContext) => {
      let params = router.getParams() as Record<string, string>;
      this.searchValue = params.searchValue as string;
    })
    .onBackPressed(() => {
      router.replaceNamedRoute({ name: 'SearchView' });
      return true;
    })
  }
}