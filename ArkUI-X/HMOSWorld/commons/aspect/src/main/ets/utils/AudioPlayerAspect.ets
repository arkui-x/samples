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

import { Logger, PlatformInfo, PlatformTypeEnum } from '@ohos/utils';
import { AspectUtil } from './AspectUtil/AspectUtil';

const TAG: string = '[AudioPlayerAspect]';

export class AudioPlayerAspect {
  static createAspect() {
    const harName: string = '@ohos/audioplayer';
    import(harName).then((ns: ESObject) => {
      const targetClass: ESObject = PlatformInfo.getPlatform() ==
      PlatformTypeEnum.HARMONYOS ? ns.AudioPlayerServiceLocal : ns.AudioPlayerServiceArkUIX;
      const methodClassName: string = 'AudioPlayerService';
      AspectUtil.getAspectUtil().addBefore(methodClassName, targetClass, 'speak', false);
      AspectUtil.getAspectUtil().addAfter<void>(methodClassName, targetClass, 'speak', false);

      AspectUtil.getAspectUtil().addBefore(methodClassName, targetClass, 'play', false);
      AspectUtil.getAspectUtil().addAfter<void>(methodClassName, targetClass, 'play', false);

      AspectUtil.getAspectUtil().addBefore(methodClassName, targetClass, 'pause', false);
      AspectUtil.getAspectUtil().addAfter<void>(methodClassName, targetClass, 'pause', false);

      AspectUtil.getAspectUtil().addBefore(methodClassName, targetClass, 'stop', false);
      AspectUtil.getAspectUtil().addAfter<void>(methodClassName, targetClass, 'stop', false);
    }).catch((e: Error) => {
      Logger.error(TAG, `import ${harName} error, ${JSON.stringify(e)}`);
    })
  }
}