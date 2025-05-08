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

import { ComponentContent, PromptAction, promptAction } from '@kit.ArkUI';
import { DialogBuilder } from '../builder/DialogBuilder';
import { DialogOptionsFactory } from './DialogOptionsFactory';
import { DialogParam } from '../dto/DialogParam';
import { EncapsulateDialogBuilderParam } from '../dto/EncapsulateDialogBuilderParam';

export class DialogUtil {
  private static uiContext?: UIContext;
  private static compContMap: Map<string, ComponentContent<object>> = new Map();

  public static init(uiContext: UIContext) {
    DialogUtil.uiContext = uiContext;
  }

  /**
   * 弹出自定义弹窗
   *
   * @param param
   */
  public static showCustomDialog(param: DialogParam): void {
    if (!DialogUtil.uiContext) {
      return;
    }
    let promptAction = DialogUtil.uiContext.getPromptAction();
    let encapsulateParam: EncapsulateDialogBuilderParam = DialogUtil.transformDialogParamToEncapsulateDialogBuilderParam(param);
    let compCont = new ComponentContent(DialogUtil.uiContext, wrapBuilder(DialogBuilder), encapsulateParam);
    // 设置了弹窗id即可将其与弹窗关联起来，后续可凭据弹窗id关闭弹窗
    if (param.dialogId) {
      DialogUtil.compContMap.set(param.dialogId, compCont);
    }
    DialogUtil.fillCancelMethod(encapsulateParam, promptAction, compCont, param.dialogId);
    DialogUtil.fillConfirmMethod(encapsulateParam, promptAction, compCont, param.dialogId);
    compCont.update(encapsulateParam);
    let options: promptAction.BaseDialogOptions = DialogUtil.dealSlideToClose(param);
    promptAction.openCustomDialog(compCont, options);
  }

  /**
   * 根据弹窗id关闭弹窗
   * @param dialogId
   */
  public static closeCustomDialogById(dialogId: string) {
    if (!DialogUtil.uiContext) {
      return;
    }
    let promptAction = DialogUtil.uiContext.getPromptAction();
    let compCont = DialogUtil.compContMap.get(dialogId);
    if (compCont) {
      DialogUtil.compContMap.delete(dialogId);
      promptAction.closeCustomDialog(compCont);
      // 关闭弹框之后释放对应的ComponentContent
      compCont.dispose();
    }
  }

  private static dealSlideToClose(param: DialogParam) {
    param.isSlideToClose = param.isSlideToClose ?? true;
    let options: promptAction.BaseDialogOptions = DialogOptionsFactory.getOptionsByDialogType(param.dialogType);
    options.onWillDismiss = (action: DismissDialogAction) => {
      if (action.reason == DismissReason.PRESS_BACK) {
        if (param.slideCallback) {
          param.slideCallback();
        }
        if (param.isSlideToClose) {
          action.dismiss();
        }
      }
    };
    return options;
  }

  private static transformDialogParamToEncapsulateDialogBuilderParam(param: DialogParam): EncapsulateDialogBuilderParam {
    return {
      dialogType: param.dialogType,
      builder: param.builder,
      closeDialog: param.dialogBuilderParam?.closeDialog,
      onConfirm: param.dialogBuilderParam?.onConfirm,
      data: param.dialogBuilderParam?.data,
      isModalClosedByOverlayClick: param.isModalClosedByOverlayClick ?? true
    };
  }

  private static fillConfirmMethod(param: EncapsulateDialogBuilderParam, promptAction: PromptAction,
    compCont: ComponentContent<DialogParam>, dialogId: string | undefined) {
    let confirm = param.onConfirm;
    let confirmDialog = (isCloseDialog?: boolean, data?: ESObject) => {
      if (confirm) {
        confirm(isCloseDialog, data);
      }
      if (isCloseDialog) {
        if (dialogId) {
          DialogUtil.compContMap.delete(dialogId);
        }
        promptAction.closeCustomDialog(compCont);
        compCont.dispose();
      }
    };
    param.onConfirm = confirmDialog;
  }

  private static fillCancelMethod(param: EncapsulateDialogBuilderParam, promptAction: PromptAction,
    compCont: ComponentContent<DialogParam>, dialogId: string | undefined) {
    let customCancel = param.closeDialog;
    let cancelDialog = () => {
      if (customCancel) {
        customCancel();
      }
      if (dialogId) {
        DialogUtil.compContMap.delete(dialogId);
      }
      promptAction.closeCustomDialog(compCont);
      // 关闭弹框之后释放对应的ComponentContent
      compCont.dispose();
    };
    param.closeDialog = cancelDialog;
  }
}