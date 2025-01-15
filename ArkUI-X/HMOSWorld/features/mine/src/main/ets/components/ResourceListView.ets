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

import { router } from '@kit.ArkUI';
import { common, ConfigurationConstant } from '@kit.AbilityKit';
import {
  BreakpointType,
  BreakpointTypeEnum,
  CommonConstants,
  ContinueModel,
  EventTypeEnum,
  LazyDataSource,
  LearningResource,
  Logger,
  ResourcesType,
  WindowUtil
} from '@ohos/utils';
import { NoMore } from '@ohos/uicomponents';
import { ArticleCardView } from './ArticleCardView';
import { FeedCardView } from './FeedCardView';
import Constants from '../constants/Constants';

const TAG = '[ResourceListView]';
let continueModel = ContinueModel.getInstance();

@Component
export struct ResourceListView {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  scrollerForScroll?: Scroller;
  scrollerForList?: Scroller;
  @State selectedId: string = '';
  @Link resDataSource: LazyDataSource<LearningResource>;
  private eventHub: common.EventHub = (getContext() as common.UIAbilityContext).eventHub;

  dynamicLoading(): void {
    try {
      import('../views/DiscoverArticleDetailView');
    } catch (err) {
      Logger.error(TAG, 'dynamicLoading error:' + err);
    }
  }

  aboutToAppear() {
    this.dynamicLoading();
    let routerName = continueModel.geRouterName();
    Logger.info(TAG, 'aboutToAppear routerName is:' + routerName);

    let learningResource: LearningResource = this.resDataSource.dataArray[0];
    if (this.currentBreakpoint === BreakpointTypeEnum.LG || continueModel.isContinue) {
      if (continueModel.isContinue && continueModel.data.itemData) {
        learningResource = continueModel.data.itemData as LearningResource;
      }
      this.jumpDetail(learningResource);
    }
    this.eventHub.on(EventTypeEnum.MINE_REFRESH, () => {
      if (this.resDataSource.dataArray.length > 0) {
        this.jumpDetail(this.resDataSource.dataArray[0]);
        this.scrollerForList?.scrollEdge(Edge.Start);
      }
    });
  }

  jumpDetail(item: LearningResource) {
    WindowUtil.getWindowUtil().updateStatusBarColor(getContext(this),
      AppStorage.get('currentColorMode') === ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
    router.pushNamedRoute({
      name: "DiscoverArticleDetailView",
      params: new Object({
        articleDetail: item,
      })
    });
  }

  build() {
    Navigation() {
      List({ space: CommonConstants.SPACE_12, scroller: this.scrollerForList }) {
        LazyForEach(this.resDataSource, (content: LearningResource) => {
          ListItem() {
            if (content.type === ResourcesType.ARTICLE) {
              ArticleCardView({
                articleItem: content,
                isSelected: this.currentBreakpoint === BreakpointTypeEnum.LG && this.selectedId === content.id,
                onCollected: (articleItem: LearningResource) => {
                  this.eventHub.emit(EventTypeEnum.COLLECTED, {
                    resourceId: articleItem.id,
                    resourceType: articleItem.type,
                    actionValue: !articleItem.isCollected
                  })
                },
                onLiked: (articleItem: LearningResource) => {
                  this.eventHub.emit(EventTypeEnum.LIKED, {
                    resourceId: articleItem.id,
                    resourceType: articleItem.type,
                    actionValue: !articleItem.isLiked
                  })
                }
              })
                .reuseId('mineArticle')
            } else {
              FeedCardView({
                isSelected: this.currentBreakpoint === BreakpointTypeEnum.LG && this.selectedId == content.id,
                articleItem: content
              })
                .reuseId('mineFeed')
            }
          }
          .borderRadius($r('app.float.xxl_border_radius'))
          .margin({ right: $r('app.float.md_padding_margin') })
          .onClick(() => this.jumpDetail(content))
        }, (item: LearningResource, index: number) => JSON.stringify(item) + index)
        ListItem() {
          NoMore()
        }
      }
      .cachedCount(3)
      .padding({
        left: new BreakpointType({
          sm: $r('app.float.md_padding_margin'),
          md: $r('app.float.xxl_padding_margin'),
          lg: $r('app.float.xxl_padding_margin')
        }).getValue(this.currentBreakpoint),
        right: new BreakpointType<Length>({
          sm: 0,
          md: $r('app.float.md_padding_margin'),
          lg: 0
        }).getValue(this.currentBreakpoint)
      })
      .lanes(new BreakpointType({ sm: 1, md: Constants.COUNT_TWO, lg: 1 }).getValue(this.currentBreakpoint))
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None)
      .nestedScroll({
        scrollForward: NestedScrollMode.PARENT_FIRST,
        scrollBackward: NestedScrollMode.SELF_FIRST
      })
    }
    .navBarWidth(CommonConstants.NAVI_BAR_WIDTH)
    .mode(this.currentBreakpoint === BreakpointTypeEnum.LG ? NavigationMode.Split : NavigationMode.Stack)
    .hideTitleBar(true)
  }
}