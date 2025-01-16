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

import { bundleManager } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import { AspectInfoParams, Logger } from '@ohos/utils';
import { AspectUtilInterface } from '../interface/AspectUtilInterface';
import { AspectNetFunc } from '../../service/AspectNetFunc';

const TAG = '[AspectUtilLocal]';

export class AspectUtilLocal implements AspectUtilInterface {
  private static instance: AspectUtilLocal;
  private funNetwork: AspectNetFunc = new AspectNetFunc();
  private versionName: string = '';

  public static getInstance(): AspectUtilInterface {
    if (!AspectUtilLocal.instance) {
      AspectUtilLocal.instance = new AspectUtilLocal();
    }
    return AspectUtilLocal.instance;
  }

  public addBefore(methodClassName: string, targetClass: Object, methodName: string, isStatic: boolean) {
    util.Aspect.addBefore(targetClass, methodName, isStatic, (instance: Object, ...args: Object[]) => {
      const currentTime: number = (new Date()).getTime();
      const params: string = JSON.stringify([...args]);
      this.uploadAspectInfo({
        methodClassName: methodClassName,
        methodName: methodName,
        isStatic: isStatic,
        versionName: this.getVersionName(),
        time: currentTime + '',
        params: params,
        type: 'start'
      } as AspectInfoParams);
      Logger.info(TAG,
        `method ${methodName} is called by ${JSON.stringify(typeof instance)} , start at ${currentTime}, args is ${params}.`);
    });
  }

  public replace(targetClass: Object, methodName: string, isStatic: boolean,
    replaceFun?: Function) {
    util.Aspect.replace(targetClass, methodName, isStatic, replaceFun);
  }

  public addAfter<T>(methodClassName: string, targetClass: Object, methodName: string, isStatic: boolean,
    afterFunc?: Function) {
    util.Aspect.addAfter(targetClass, methodName, isStatic, (instance: Object, ret: T, ...args: Object[]): T => {
      afterFunc && afterFunc(...args);
      const currentTime: number = (new Date()).getTime();
      const params: string = JSON.stringify([...args]);
      this.uploadAspectInfo({
        methodClassName: methodClassName,
        methodName: methodName,
        isStatic: isStatic,
        versionName: this.getVersionName(),
        time: currentTime + '',
        params: params,
        type: 'end'
      } as AspectInfoParams);
      Logger.info(TAG,
        `method ${methodName} is called by ${JSON.stringify(typeof instance)} , end at ${currentTime}, args is ${params}.`);
      return ret;
    });
  }

  public exit(): void {
    Logger.warn(TAG, 'Not Support');
  }

  public goToBackground(): void {
    Logger.warn(TAG, 'Not Support');
  }

  private getVersionName(): string {
    if (!this.versionName) {
      const bundleInfo: bundleManager.BundleInfo =
        bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
      this.versionName = bundleInfo.versionName;
    }
    return this.versionName;
  }

  private uploadAspectInfo(aspectInfo: AspectInfoParams) {
    this.funNetwork.uploadAspectInfo(aspectInfo);
  }
}