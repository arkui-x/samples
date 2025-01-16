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
import { BusinessError, deviceInfo } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import {
  CollaborationServiceFilter,
  CollaborationServiceStateDialog,
  createCollaborationServiceMenuItems
} from '@kit.ServiceCollaborationKit';
import { PhotoManager, ProfileConstants } from '@ohos/photoManager';
import {
  BreakpointType,
  BreakpointTypeEnum,
  CommonConstants,
  FileUtil,
  Logger,
  PlatformInfo,
  PlatformTypeEnum,
  UserAccount
} from '@ohos/utils';
import Constants from '../constants/Constants';

let breakpointType: BreakpointType<string> = new BreakpointType<string>({
  sm: Constants.IMAGE_RATIO_PHONE,
  md: Constants.IMAGE_RATIO_FOLD,
  lg: Constants.IMAGE_RATIO_PAD
})

const TAG = '[PhotoView]';

@Entry({ routeName: 'PhotoView' })
@Component
export struct PhotoView {
  @StorageProp('user') account: UserAccount | null = null;
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  @StorageProp('profilePixelMap') profilePixelMap: PixelMap | null = null;
  private isPadOr2in1: boolean = (deviceInfo.deviceType === '2in1' || deviceInfo.deviceType === 'tablet');
  private isArkuiX: boolean =
    (PlatformInfo.getPlatform() === PlatformTypeEnum.ANDROID || PlatformInfo.getPlatform() === PlatformTypeEnum.IOS);

  dynamicLoading(): void {
    try {
      import('./ConfirmView');
    } catch (err) {
      Logger.error(TAG, 'dynamicLoading error:' + err);
    }
  }

  aboutToAppear(): void {
    this.dynamicLoading();
  }

  @Builder
  MenuBuilder() {
    Text($r('app.string.use_local_device'))
      .fontColor('#99000000')
      .fontSize($r('app.float.menu_font_size'))
      .padding({ left: $r('app.float.menu_padding') })
      .height($r('app.float.menu_height'))
  }

  @Builder
  SelectProfileMenu() {
    Menu() {
      MenuItem(this.MenuBuilder())
      MenuItem({ content: $r('app.string.select_from_gallery'), startIcon: $r('sys.media.ohos_ic_public_albums') })
        .padding({ left: $r('app.float.menu_padding') })
        .onClick(async () => {
          await PhotoManager.getPhotoManager().selectPicture().then((uri: string) => {
            Logger.info(TAG, 'selectPicture success');
            router.pushNamedRoute({ name: 'ConfirmView', params: new Object({ uri: uri }) });
          }).catch((error: BusinessError) => {
            Logger.info(TAG, 'selectPicture failed, error is ' + JSON.stringify(error));
          });
        })
    }

    Menu() {
      createCollaborationServiceMenuItems([CollaborationServiceFilter.ALL])
    }
  }

  doSavePicture(stateCode: number, _bufferType: string, buffer: ArrayBuffer): void {
    if (stateCode === 0) {
      let imageSource = image.createImageSource(buffer);
      FileUtil.saveBuffer2File(ProfileConstants.getInstance().LOCAL_PROFILE_PATH, buffer);
      FileUtil.saveBuffer2File(ProfileConstants.getInstance().DISTRIBUTED_PROFILE_PATH, buffer);
      imageSource.createPixelMap().then((pixelMap) => {
        AppStorage.setOrCreate('profilePixelMap', pixelMap);
      })
    }
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Image($r('app.media.ic_public_cancel'))
            .height($r('app.float.normal_icon_size'))
            .width($r('app.float.normal_icon_size'))
            .fillColor(Color.Blue)
            .onClick(() => {
              router.back();
            })
        }
        .padding({ top: $r('app.float.md_padding_margin') })
        .justifyContent(FlexAlign.Start)
        .width(CommonConstants.FULL_PERCENT)

        Row() {
          Image(this.profilePixelMap !== null ? AppStorage.get<PixelMap>('profilePixelMap') : this.account?.portrait)
            .aspectRatio(1)
            .clipShape(new Circle({ height: Constants.CLIP_RATIO, width: Constants.CLIP_WIDTH })
              .position({
                y: Constants.CIRCLE_RATIO_Y,
                x: Constants.CLIP_MARGIN
              })
            )
        }
        .height(breakpointType.getValue(this.currentBreakpoint))

        if (PlatformInfo.getPlatform() == PlatformTypeEnum.HARMONYOS) {
          CollaborationServiceStateDialog({
            onState: (stateCode: number, bufferType: string, buffer: ArrayBuffer): void => this.doSavePicture(stateCode,
              bufferType, buffer)
          })
        }

        Row() {
          Button($r('app.string.editPhoto'))
            .backgroundColor($r('app.color.back_color'))
            .fontColor($r('app.color.font_color'))
            .type(ButtonType.Capsule)
            .size({
              width: $r('app.float.button_change_width'),
              height: $r('app.float.button_height')
            })
            .margin({ top: $r('app.float.tab_big_img_width') })
            .bindMenu((this.isPadOr2in1 && !this.isArkuiX) ? this.SelectProfileMenu() : undefined)
            .onClick(async () => {
              if (!this.isPadOr2in1) {
                await PhotoManager.getPhotoManager().selectPicture().then((uri: string) => {
                  Logger.info(TAG, 'selectPicture success, uri is ' + uri);
                  router.pushNamedRoute({ name: 'ConfirmView', params: new Object({ uri: uri }) });
                }).catch((error: BusinessError) => {
                  Logger.info(TAG, 'selectPicture failed, error is ' + JSON.stringify(error));
                });
              }
            })
        }
      }
      .backgroundColor(Color.White)
      .height(CommonConstants.FULL_PERCENT)
      .padding({
        top: AppStorage.get<number>('statusBarHeight'),
        bottom: (AppStorage.get<number>('naviIndicatorHeight') || 0) + Constants.PHOTO_PADDING_BOTTOM
      })
    }
    .hideTitleBar(true)
  }
}