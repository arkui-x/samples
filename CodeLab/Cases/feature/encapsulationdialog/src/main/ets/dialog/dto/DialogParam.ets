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

import { DialogBuilderParam } from './DialogBuilderParam';
import { DialogTypeEnum } from '../enum/DialogTypeEnum';

export interface DialogParam {
  dialogId?: string; // 弹窗id
  builder: WrappedBuilder<[DialogBuilderParam]>;
  dialogType: DialogTypeEnum;
  dialogBuilderParam?: DialogBuilderParam;
  isModalClosedByOverlayClick?: boolean; // 点击蒙层是否关闭弹窗,默认为true/点击蒙层关闭弹窗
  isSlideToClose?: boolean; // 控制侧滑是否关闭弹窗，默认为true/侧滑关闭弹窗
  slideCallback?: () => void; // 侧滑回调
}