/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { Configuration, Want } from '@kit.AbilityKit';
import { http } from '@kit.NetworkKit';
import { logger } from 'utils';
import { CommonConstants } from '../constants/CommonConstants';
import { CASES, CaseCardUtils } from '../widget/utils/CaseCardUtils';

const TAG: string = '[PhoneFormAbility] ';

export default class PhoneFormAbility extends FormExtensionAbility {
  // 卡片对象集合
  onAddForm(want: Want): formBindingData.FormBindingData {
    logger.info(TAG, 'PhoneFormAbility onAddForm');
    logger.info(TAG, want.parameters?.[formInfo.FormParam.NAME_KEY] as string);
    let isLongCard: boolean = true;
    if ((want.parameters?.[formInfo.FormParam.WIDTH_KEY] as number) /
      (want.parameters?.[formInfo.FormParam.HEIGHT_KEY] as number) > 0.666) {
      isLongCard = false;
    }
    // 使用方创建卡片时触发，提供方需要返回卡片数据绑定类
    let obj: Record<string, string | boolean> = {
      'title': 'titleOnAddForm',
      'isLongCard': isLongCard
    };
    let formData: formBindingData.FormBindingData = formBindingData.createFormBindingData(obj);
    return formData;
  }

  // 网络获取README数据并利用formProvider.updateForm更新到卡片
  async getData(formId: string) {
    let detail: CASES[] = [];
    let httpRequest = http.createHttp();
    let webData: http.HttpResponse = await httpRequest.request(CommonConstants.CASE_URL);
    if (webData?.responseCode === http.ResponseCode.OK) {
      try {
        detail = CaseCardUtils.formatData(webData.result.toString());
        logger.info(TAG, 'PhoneFormAbility onFormEvent' + 'webData.result:' + webData.result);

        class FormDataClass {
          detail: CASES[] = detail;
        }

        let formData = new FormDataClass();
        let formInfo = formBindingData.createFormBindingData(formData);
        await formProvider.updateForm(formId, formInfo);
        logger.info(TAG, '%{public}s', 'FormAbility updateForm success.');
      } catch (error) {
        logger.error(TAG, `FormAbility updateForm failed: ${JSON.stringify(error)}`);
      }
    } else {
      logger.error(TAG, `ArkTSCard download task failed`);
      let param: Record<string, string> = {
        'text': '刷新失败'
      };
      let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(param);
      formProvider.updateForm(formId, formInfo);
    }
    httpRequest.destroy();
  }

  onCastToNormalForm(formId: string): void {
    // 使用方将临时卡片转换为常态卡片触发，提供方需要做相应的处理
    logger.info(TAG, 'PhoneFormAbility onCastToNormalForm' + formId);
  }

  async onUpdateForm(formId: string): Promise<void> {
    // 若卡片支持定时更新/定点更新/卡片使用方主动请求更新功能，则提供方需要重写该方法以支持数据更新
    logger.info(TAG, 'PhoneFormAbility onUpdateForm');
    this.getData(formId);
  }

  onChangeFormVisibility(newStatus: Record<string, number>): void {
    // 使用方发起可见或者不可见通知触发，提供方需要做相应的处理，仅系统应用生效
    logger.info(TAG, 'PhoneFormAbility onChangeFormVisibility');
  }


  async onFormEvent(formId: string, message: string): Promise<void> {
    this.getData(formId);
  }

  onRemoveForm(formId: string): void {
    // 删除卡片实例数据
    logger.info(TAG, 'PhoneFormAbility onRemoveForm');
    // 删除之前持久化的卡片实例数据
    // 此接口请根据实际情况实现，具体请参考：FormExtAbility Stage模型卡片实例
  }

  onConfigurationUpdate(config: Configuration) {
    // 当前formExtensionAbility存活时更新系统配置信息时触发的回调。
    // 需注意：formExtensionAbility创建后10秒内无操作将会被清理。
    logger.info(TAG, 'PhoneFormAbility onConfigurationUpdate:' + JSON.stringify(config));
  }

  onAcquireFormState(want: Want) {
    // 卡片提供方接收查询卡片状态通知接口，默认返回卡片初始状态。
    return formInfo.FormState.READY;
  }
}
