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

import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { preferences } from '@kit.ArkData';
import { Want } from '@kit.AbilityKit';
import { Logger } from '@ohos/utils';
import { CardList } from '../card/CardListModel';

const TAG = 'EntryFormAbility';

interface FormDataInterface {
  imageResource: Resource,
  zoneID: number
}

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want) {
    // Called to return a FormBindingData object.
    let formData: FormDataInterface = {
      imageResource: $r('app.media.ic_card_A'),
      zoneID: 0
    };
    return formBindingData.createFormBindingData(formData);
  }

  onCastToNormalForm(formId: string) {
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
  }

  onUpdateForm(formId: string) {
    preferences.getPreferences(this.context, 'store', (err: Error, value: preferences.Preferences) => {
      if (err) {
        Logger.error(TAG, `getPreferences failed, error = ${JSON.stringify(err)}`);
        return;
      }
      let store: preferences.Preferences = value;
      let index = 0;
      store.get('index', 1,
        (err: Error, getValue) => {
          if (err) {
            Logger.error(TAG, `getValue failed, error = ${JSON.stringify(err)}`);
            return;
          }
          index = getValue as number;
          let formData: FormDataInterface = {
            imageResource: CardList[index],
            zoneID: index
          };
          let formInfo = formBindingData.createFormBindingData(formData);
          formProvider.updateForm(formId, formInfo).then((data) => {
            Logger.info(TAG, 'updateForm success: ' + JSON.stringify(data));
          }).catch((err: Error) => {
            Logger.error(TAG, `updateForm failed, error = ${JSON.stringify(err)}`);
          });
          store.put('index', index + 1 > 11 ? 0 : index + 1).then(() => {
            store.flush().then(() => {
              Logger.info(TAG, `flush success.`);
            });
          });
        });
    });
  }

  onChangeFormVisibility(newStatus: Record<string, number>) {
    // Called when the form provider receives form events from the system.
  }

  onFormEvent(formId: string, message: string) {
    // Called when a specified message event defined by the form provider is triggered.
  }

  onRemoveForm(formId: string) {
    // Called to notify the form provider that a specified form has been destroyed.
  }

  onAcquireFormState(want: Want) {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
};