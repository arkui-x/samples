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
import { util } from '@kit.ArkTS';
import { AspectInfoParams, Logger } from '@ohos/utils';
import { AspectUtilInterface } from '../interface/AspectUtilInterface';
import { AspectNetFunc } from '../../service/AspectNetFunc';

const TAG = '[AspectUtilArkUIX]';

export class AspectUtilArkUIX implements AspectUtilInterface {
  private static instance: AspectUtilArkUIX;
  private funNetwork: AspectNetFunc = new AspectNetFunc();
  private versionName: string = '';
  private bridgeImpl: bridge.BridgeObject;

  private constructor() {
    this.bridgeImpl = bridge.createBridge('AspectUtil');
  }

  public static getInstance(): AspectUtilInterface {
    if (!AspectUtilArkUIX.instance) {
      AspectUtilArkUIX.instance = new AspectUtilArkUIX();
    }
    return AspectUtilArkUIX.instance;
  }

  public addBefore(methodClassName: string, targetClass: Object, methodName: string, isStatic: boolean) {
    util.Aspect.addBefore(targetClass, methodName, isStatic, (instance: Object, ...args: Object[]) => {
      const currentTime: number = (new Date()).getTime();
      const params: string = JSON.stringify([...args]);
      this.getVersionName().then((data: string) => {
        this.uploadAspectInfo({
          methodClassName: methodClassName,
          methodName: methodName,
          isStatic: isStatic,
          versionName: data,
          time: currentTime + '',
          params: params,
          type: 'start'
        } as AspectInfoParams);
      })
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
      this.getVersionName().then((data: string) => {
        this.uploadAspectInfo({
          methodClassName: methodClassName,
          methodName: methodName,
          isStatic: isStatic,
          versionName: data,
          time: currentTime + '',
          params: params,
          type: 'end'
        } as AspectInfoParams);
      })
      Logger.info(TAG,
        `method ${methodName} is called by ${JSON.stringify(typeof instance)} , end at ${currentTime}, args is ${params}.`);
      return ret;
    });
  }

  public exit(): void {
    this.bridgeImpl?.callMethod('exit');
  }

  public goToBackground(): void {
    this.bridgeImpl?.callMethod('goToBackground');
  }

  private async getVersionName(): Promise<string> {
    return new Promise((resolve: (data: string) => void, reject: (error: Resource) => void) => {
      let result: string = '';
      if (!this.versionName) {
        this.bridgeImpl?.callMethod('getVersionName').then((versionName: bridge.ResultValue) => {
          if (versionName != undefined) {
            result = versionName.toString();
          }
          resolve(result);
        });
      }
    });
  }

  private uploadAspectInfo(aspectInfo: AspectInfoParams) {
    this.funNetwork.uploadAspectInfo(aspectInfo);
  }
}