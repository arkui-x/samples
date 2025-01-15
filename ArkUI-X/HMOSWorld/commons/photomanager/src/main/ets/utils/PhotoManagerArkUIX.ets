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

import bridge from '@arkui-x.bridge';
import { common, Want } from '@kit.AbilityKit';
import { image } from '@kit.ImageKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { FileUtil, Logger, PlatformInfo, PlatformTypeEnum } from '@ohos/utils';
import { ProfileConstants } from '../common/ProfileConstants';
import ErrorCode from '../common/ErrorCodeConstants';
import { PhotoManagerInterface } from '../interface/PhotoManagerInterface';

const TAG = '[PhotoManagerArkUIX]';

export class PhotoManagerArkUIX implements PhotoManagerInterface {
  private static instance: PhotoManagerArkUIX;
  private bridgeImpl: bridge.BridgeObject;

  private constructor() {
    this.bridgeImpl = bridge.createBridge('PhotoManager');
  }

  public static getInstance(): PhotoManagerInterface {
    if (!PhotoManagerArkUIX.instance) {
      PhotoManagerArkUIX.instance = new PhotoManagerArkUIX();
    }
    return PhotoManagerArkUIX.instance;
  }

  private routingUriForiOS(uri: string): string {
    // Intercepts everything after the keyword 'file'
    uri = uri.replace(new RegExp(`.*(${'file'})`), '$1');

    // Remove redundant escape characters
    uri = uri.replace(/\\/g, '');

    // Remove trailing redundant characters
    uri = uri.slice(0, -5);
    return uri;
  }

  public async selectPicture(): Promise<string> {
    if (PlatformInfo.getPlatform() == PlatformTypeEnum.ANDROID) {
      return new Promise((resolve: (uri: string) => void, reject: ((err: BusinessError) => void)) => {
        let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
        PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
        PhotoSelectOptions.maxSelectNumber = 1;
        let photoPicker = new photoAccessHelper.PhotoViewPicker();
        photoPicker.select(PhotoSelectOptions).then((PhotoSelectResult: photoAccessHelper.PhotoSelectResult) => {
          Logger.info(TAG,
            'PhotoViewPicker.select success, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));
          let uris: Array<string> = PhotoSelectResult.photoUris;
          if (uris.length > 0) {
            resolve(uris[0]);
          } else {
            reject({
              code: ErrorCode.GET_DATA_FAILED,
              name: 'GET_DATA_FAILED',
              message: 'Maybe image selector not selecting an image'
            });
          }
        }).catch((err: BusinessError) => {
          Logger.error(TAG, `PhotoViewPicker.select failed with err: ${err.code}, ${err.message}`);
          reject(err);
        });
      });
    } else {
      return new Promise((resolve: (uri: string) => void, reject: ((err: BusinessError) => void)) => {
        try {
          const context = getContext(this) as common.UIAbilityContext;
          let uri: string = '';
          let want: Want = {
            bundleName: 'com.ohos.photos',
            abilityName: context.abilityInfo.name,
            parameters: {
              uri: '',
            }
          };
          context.startAbilityForResult(want, (err: BusinessError, data: common.AbilityResult) => {
            uri = this.routingUriForiOS(JSON.stringify(data.want?.parameters));
            this.bridgeImpl?.callMethod(
              'copyToSandbox', uri, ProfileConstants.getInstance().LOCAL_PROFILE_NAME).then(() => {
              uri = 'file://' + context.filesDir + '/' + ProfileConstants.getInstance().LOCAL_PROFILE_NAME;
              Logger.info(TAG, 'PhotoManager selectPicture uri is ' + uri);
              resolve(uri)
            }).catch((error: BusinessError) => {
              Logger.info(TAG, 'PhotoManager savePicture failed, error is ' + JSON.stringify(error));
              reject(error);
            });
          });
        } catch (error) {
          let err: BusinessError = error as BusinessError;
          Logger.error(TAG, `PhotoManager startAbilityForResult failed with err: ${err.code}, ${err.message}`);
          reject(err)
        }
      });
    }
  }

  public async savePicture(uri: string): Promise<void> {
    if (PlatformInfo.getPlatform() == PlatformTypeEnum.ANDROID) {
      return new Promise((resolve: () => void, reject: ((err: BusinessError) => void)) => {
        //delete string 'file://' from uri
        let imaUri: string = uri.slice(7);
        FileUtil.copyFile(imaUri, ProfileConstants.getInstance().LOCAL_PROFILE_PATH);
        let imageSource: image.ImageSource = image.createImageSource(ProfileConstants.getInstance().LOCAL_PROFILE_PATH);
        imageSource.createPixelMap((err, pixelMap) => {
          if (err) {
            Logger.error(TAG, `createPixelMap error: ${err}`);
            reject(err);
          } else {
            AppStorage.setOrCreate('profilePixelMap', pixelMap);
            resolve();
          }
        });
      });
    } else {
      return new Promise((resolve: () => void, reject: ((err: BusinessError) => void)) => {
        let imageSource: image.ImageSource = image.createImageSource(ProfileConstants.getInstance().LOCAL_PROFILE_PATH);
        imageSource.createPixelMap((err, pixelMap) => {
          if (err) {
            Logger.error(TAG, `createPixelMap error: ${err}`);
            reject(err);
          } else {
            AppStorage.setOrCreate('profilePixelMap', pixelMap);
            resolve();
          }
        });
      });
    }
  }
}