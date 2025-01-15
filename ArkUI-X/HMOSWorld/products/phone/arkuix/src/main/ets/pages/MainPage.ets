/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
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

import { common, ConfigurationConstant } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';
import { fileIo } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';
import { ProfileConstants } from '@ohos/photomanager';
import { DiscoverView } from '@ohos/discover';
import { LearningView } from '@ohos/learning';
import {
  BreakpointSystem,
  BreakpointTypeEnum,
  ContinueModel,
  DarkModeUtil,
  FileUtil,
  GlobalContext,
  LearningResource,
  Logger,
  PlatformInfo,
  PlatformTypeEnum,
  ResourcesType,
  WebUtil,
  WindowUtil
} from '@ohos/utils';
import { AppConstants } from '@ohos/main';
import { MineView, UserData, UserModel } from '@ohos/mine';
import { AspectUtil } from '@ohos/aspect';
import { ConferenceView } from '@ohos/conference';
import { CustomTabBar } from '../common/components/CustomTabBar';
import { TabBarType } from '../common/model/TabBarModel';

const TAG = '[MainPage]';
const context = (getContext(this) as common.UIAbilityContext);

@Entry
@Component
struct MainPage {
  @State currentIndex: TabBarType = TabBarType.DISCOVER;
  @State webViewController?: WebviewController = undefined;
  @State learnedId: string = '';
  @StorageLink('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  @State updateNodeFlag: boolean = false;
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();

  dynamicLoading(): void {
    try {
      import('@ohos/mine/src/main/ets/views/DiscoverArticleDetailView');
    } catch (err) {
      Logger.error(TAG, 'dynamicLoading error:' + err);
    }
  }

  aboutToAppear() {
    this.dynamicLoading();
    WebUtil.setUiContext(this.getUIContext());
    this.breakpointSystem.register();
    WindowUtil.getWindowUtil().setMissionContinueActive(context, true);

    if (ContinueModel.getInstance().isContinue) {
      let userData: UserData = ContinueModel.getInstance().data.userData as UserData;
      this.currentIndex = ContinueModel.getInstance().data.mainTabIndex as number;
      UserModel.getInstance().saveDistributedUserData(userData);
    }
    this.createProfile()
  }

  async createProfile() {
    let isDisProfileAccess = fileIo.accessSync(ProfileConstants.getInstance().DISTRIBUTED_PROFILE_PATH);
    Logger.info(TAG, 'isDisProfileAccess:' + isDisProfileAccess);
    if (isDisProfileAccess) {
      FileUtil.copyFile(ProfileConstants.getInstance().DISTRIBUTED_PROFILE_PATH,
        ProfileConstants.getInstance().LOCAL_PROFILE_PATH)
    }
    let isLocalProfileAccess = fileIo.accessSync(ProfileConstants.getInstance().LOCAL_PROFILE_PATH);
    Logger.info(TAG, 'isLocalProfileAccess:' + isLocalProfileAccess);
    if (isLocalProfileAccess) {
      let imageSource: image.ImageSource = image.createImageSource(ProfileConstants.getInstance().LOCAL_PROFILE_PATH);
      imageSource.createPixelMap((err, pixelMap) => {
        if (!err) {
          AppStorage.setOrCreate('profilePixelMap', pixelMap);
        }
        Logger.error(TAG, `LOCAL_PROFILE_PATH : ${JSON.stringify(err)}`);
      });
    }
  }

  aboutToDisappear() {
    this.breakpointSystem.unregister();
    WindowUtil.getWindowUtil().setMissionContinueActive(context, false);
  }

  onPageShow() {
    if (router.getParams() != undefined) {
      let params = router.getParams() as Record<string, string>;
      this.learnedId = params.learningItemId as string;
    }
    DarkModeUtil.getDarkModeUtil().checkDarkModeSetting();
    let jumpArticleId: string = GlobalContext.getContext().getObject('articleId') as string;
    if (jumpArticleId) {
      GlobalContext.getContext().deleteObject('articleId');
      let article: LearningResource = new LearningResource();
      article.id = jumpArticleId;
      article.webUrl = GlobalContext.getContext().getObject('webUrl') as string;
      article.type = GlobalContext.getContext().getObject('type') as ResourcesType;
      router.pushNamedRoute({
        name: 'DiscoverArticleDetailView',
        params: new Object({
          articleDetail: article,
        })
      })
    }
    if (this.currentIndex === TabBarType.MINE) {
      WindowUtil.getWindowUtil().updateStatusBarColor(getContext(this), true);
    } else {
      WindowUtil.getWindowUtil().updateStatusBarColor(getContext(this),
        AppStorage.get('currentColorMode') === ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
    }
    Logger.info(TAG, 'onPageShow');
    if (AppStorage.get<boolean>('getHomeResource')) {
      this.currentIndex = TabBarType.DISCOVER;
    }
  }

  onBackPress(): boolean | void {
    if (this.currentIndex === TabBarType.ACTIVITY) {
      let webview = WebUtil.getController(WebUtil.WebUrls.ACTIVITY_URL);
      if (webview?.accessBackward()) {
        webview.backward();
      }
      return true;
    }
    if (PlatformInfo.getPlatform() === PlatformTypeEnum.ANDROID) {
      AspectUtil.getAspectUtil().goToBackground();
    }
    return true;
  }

  build() {
    Navigation() {
      Stack() {
        if (this.currentBreakpoint === BreakpointTypeEnum.LG) {
          Image($r('app.media.ic_user_bg'))
            .width(AppConstants.FULL_PERCENT)
            .height(AppConstants.FULL_PERCENT)
        }

        Flex({
          direction: this.currentBreakpoint === BreakpointTypeEnum.LG ? FlexDirection.RowReverse : FlexDirection.Column,
        }) {
          Tabs({ index: this.currentIndex }) {
            TabContent() {
              DiscoverView()
            }

            TabContent() {
              LearningView({ learnedId: $learnedId })
            }

            TabContent() {
              ConferenceView({ updateNodeFlag: $updateNodeFlag })
            }

            TabContent() {
              MineView()
            }
          }
          .layoutWeight(1)
          .barHeight(0)
          .scrollable(false)
          .onChange((index) => {
            this.currentIndex = index;
            this.updateNodeFlag = this.currentIndex == TabBarType.ACTIVITY ? true : false;
            ContinueModel.getInstance().data.mainTabIndex = index;
          })

          CustomTabBar({ currentIndex: $currentIndex })
        }
        .width(AppConstants.FULL_PERCENT)
        .height(AppConstants.FULL_PERCENT)
        .backgroundColor((this.currentBreakpoint === BreakpointTypeEnum.LG && this.currentIndex === TabBarType.MINE) ?
        $r('app.color.clear_color') : $r('sys.color.ohos_id_color_sub_background'))
      }
    }
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }
}