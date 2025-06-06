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
import { InteractiveAreaView, TopNavigationView } from '@ohos/uicomponents';
import {
  ColumnEnum,
  CommonConstants,
  ContinueModel,
  EventTypeEnum,
  LearningResource,
  Logger,
  ObservedArray,
  OffsetEnum,
  ResourcesType,
  RouterNameEnum,
  SpanEnum,
  WebUtil
} from '@ohos/utils';
import { UserModel } from '../model/UserModel';

const TAG = '[DiscoverArticleDetailView]';
let continueModel = ContinueModel.getInstance();

@Entry({ routeName: "DiscoverArticleDetailView" })
@Component
export struct DiscoverArticleDetailView {
  @State articleDetail: LearningResource = new LearningResource();
  @State userModel: UserModel = UserModel.getInstance();
  @State collectedIds: ObservedArray<string> = this.userModel.collectedIds;
  @State likedIds: ObservedArray<string> = this.userModel.likedIds;
  @State showInteractiveArea: boolean = true;
  private eventHub: common.EventHub = (getContext(this) as common.UIAbilityContext).eventHub;

  aboutToDisappear(): void {
    let routerName = continueModel.geRouterName();
    Logger.info(TAG + 'aboutToDisappear routerName is:' + routerName);
    if (this.articleDetail.from) {
      continueModel.setRouterName(RouterNameEnum.DISCOVER_FEED_WATER_FLOW);
    } else {
      continueModel.resetContinue();
    }
  }

  isCollected(): boolean {
    return this.collectedIds.some((id: string) => id === this.articleDetail?.id);
  }

  isLiked(): boolean {
    return this.likedIds.some((id: string) => id === this.articleDetail?.id);
  }

  onBackPress(): boolean | void {
    return this.back();
  }

  onBackPressBack(): boolean {
    return this.back();
  }

  back() {
    let webController = WebUtil.getController(this.articleDetail.webUrl);
    if (webController?.accessBackward()) {
      webController?.backward();
      return true;
    }
    WebUtil.deleteNode(this.articleDetail.webUrl);
    router.back();
    return true;
  }

  setContinue(): void {
    let routerName = continueModel.geRouterName();

    Logger.info(TAG + 'aboutToAppear routerName is:' + routerName);
    if (routerName === RouterNameEnum.DISCOVER_FEED_WATER_FLOW) {
      this.articleDetail.from = ResourcesType.FEED;
    }
    continueModel.setData(RouterNameEnum.DISCOVER_ARTICLE_VIEW, this.articleDetail);
  }

  build() {
    NavDestination() {
      Column() {
        TopNavigationView({
          title: this.articleDetail.type === ResourcesType.FEED ? $r('app.string.feed') : $r('app.string.article'),
          onBackClick: () => {
            this.onBackPressBack();
          }
        })
        Stack({ alignContent: Alignment.Bottom }) {
          GridRow({
            columns: {
              xs: ColumnEnum.SM,
              sm: ColumnEnum.SM,
              md: ColumnEnum.MD,
              lg: ColumnEnum.LG
            },
            gutter: {
              x: {
                xs: $r('app.float.xxl_padding_margin'),
                sm: $r('app.float.xxl_padding_margin'),
                md: $r('app.float.md_padding_margin'),
                lg: $r('app.float.md_padding_margin')
              }
            },
            breakpoints: { reference: BreakpointsReference.ComponentSize }
          }) {
            GridCol({
              span: {
                xs: SpanEnum.SM,
                sm: SpanEnum.SM,
                md: SpanEnum.MD,
                lg: SpanEnum.LG
              },
              offset: {
                xs: OffsetEnum.SM,
                sm: OffsetEnum.SM,
                md: OffsetEnum.MD,
                lg: OffsetEnum.LG
              }
            }) {
              NodeContainer(WebUtil.getNWeb(this.articleDetail.webUrl))
                .width(CommonConstants.FULL_PERCENT)
                .height(CommonConstants.FULL_PERCENT)
            }
          }
          .padding({
            left: $r('app.float.md_padding_margin'),
            right: $r('app.float.md_padding_margin')
          })

          if (this.showInteractiveArea) {
            InteractiveAreaView({
              isLiked: this.isLiked(),
              isCollected: this.isCollected(),
              onCollected: () => {
                this.eventHub.emit(EventTypeEnum.COLLECTED, {
                  resourceId: this.articleDetail.id,
                  resourceType: this.articleDetail.type,
                  actionValue: !this.isCollected()
                })
              },
              onLiked: () => {
                this.eventHub.emit(EventTypeEnum.LIKED, {
                  resourceId: this.articleDetail.id,
                  resourceType: this.articleDetail.type,
                  actionValue: !this.isLiked()
                })
              }
            })
              .margin({ bottom: $r('app.float.top_navigation_height') })
          }
        }
      }
      .padding({ top: AppStorage.get<number>('statusBarHeight') })
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .onReady((cxt: NavDestinationContext) => {
      let params = router.getParams() as Record<string, object>;
      this.articleDetail = params.articleDetail as LearningResource;
      WebUtil.createNWeb(this.articleDetail.webUrl);
      WebUtil.setOnPageEndAction(this.articleDetail.webUrl, () => {
        let webController = WebUtil.getController(this.articleDetail.webUrl);
        if (webController?.accessBackward()) {
          this.showInteractiveArea = false;
        } else {
          this.showInteractiveArea = true;
        }
      });
      this.setContinue();
      this.eventHub.emit(EventTypeEnum.VIEW, {
        resourceId: this.articleDetail.id,
        resourceType: this.articleDetail.type,
        actionValue: false
      });
    })
    .onBackPressed(() => this.onBackPressBack())
  }
}