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

export interface AspectUtilInterface {
  /**
   * Insert some logic before the method.
   * @param methodClassName - The name of the operated class.
   * @param targetClass - The operated class
   * @param methodName- The name of the operated method.
   * @param isStatic - The flag whether the method is static.
   * @param beforeFun - The logic inserted before the method.
   * @param insteadFun - The logic replaced with the method.
   */
  addBefore(methodClassName: string, targetClass: Object, methodName: string, isStatic: boolean): void;

  /**
   * Replace the original method with a new function.
   * @param targetClass - The operated class
   * @param methodName- The name of the operated method.
   * @param isStatic - The flag whether the method is static.
   * @param replaceFun - The logic replaced with the method.
   */
  replace(targetClass: Object, methodName: string, isStatic: boolean, replaceFun?: Function): void;

  /**
   * Insert some logic after the method.
   * @param methodClassName - The name of the operated class.
   * @param targetClass - The operated class
   * @param methodName- The name of the operated method.
   * @param isStatic - The flag whether the method is static.
   * @param afterFun - The logic inserted after the method
   */
  addAfter<T>(methodClassName: string, targetClass: Object, methodName: string, isStatic: boolean,
    afterFunc?: Function): void;

  /**
   * Application Exit.
   * WARNINGS: Only arkuix is allowed use ！！！
   */
  exit(): void;

  /**
   * Application cut to background running.
   * WARNINGS: Only arkuix is allowed use ！！！
   */
  goToBackground(): void;
}
