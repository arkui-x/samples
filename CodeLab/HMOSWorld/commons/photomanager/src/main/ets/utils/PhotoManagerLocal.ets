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

import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { FileUtil, Logger } from '@ohos/utils';
import { PhotoManagerInterface } from '../interface/PhotoManagerInterface';
import { ProfileConstants } from '../common/ProfileConstants';

const TAG = '[PhotoManagerLocal]';

export class PhotoManagerLocal implements PhotoManagerInterface {
  private static instance: PhotoManagerLocal;

  public static getInstance(): PhotoManagerInterface {
    if (!PhotoManagerLocal.instance) {
      PhotoManagerLocal.instance = new PhotoManagerLocal();
    }
    return PhotoManagerLocal.instance;
  }

  public async selectPicture(): Promise<string> {
    return new Promise((resolve: (uri: string) => void, reject: ((err: BusinessError) => void)) => {
      let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
      PhotoSelectOptions.maxSelectNumber = 1;
      let photoPicker = new photoAccessHelper.PhotoViewPicker();
      photoPicker.select(PhotoSelectOptions).then((PhotoSelectResult: photoAccessHelper.PhotoSelectResult) => {
        Logger.info(TAG, 'PhotoViewPicker.select success, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));
        let uris: Array<string> = PhotoSelectResult.photoUris;
        if (uris.length > 0) {
          resolve(uris[0]);
        }
      }).catch((err: BusinessError) => {
        Logger.error(TAG, `PhotoViewPicker.select failed with err: ${err.code}, ${err.message}`);
        reject(err);
      });
    });
  }

  public async savePicture(uri: string): Promise<void> {
    return new Promise((resolve: () => void, reject: ((err: BusinessError) => void)) => {
      FileUtil.copyFile(uri, ProfileConstants.getInstance().LOCAL_PROFILE_PATH);
      FileUtil.copyFile(uri, ProfileConstants.getInstance().DISTRIBUTED_PROFILE_PATH);
      let imageSource: image.ImageSource = image.createImageSource(ProfileConstants.getInstance().LOCAL_PROFILE_PATH);
      imageSource.createPixelMap((err, pixelMap) => {
        if (err) {
          Logger.error(TAG, `createPixelMap error: ${err}`)
          reject(err)
        } else {
          AppStorage.setOrCreate('profilePixelMap', pixelMap);
          resolve()
        }
      });
    });
  }
}