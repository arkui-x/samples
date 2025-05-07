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

import { AttributeUpdater } from '@kit.ArkUI';

/**
 * 声明GridItem动态属性
 */
@Observed
export class GridItemModifier implements AttributeModifier<GridItemAttribute> {
  public offsetX: number = 0;
  public offsetY: number = 0;
  public opacity: number = 1;

  /**
   * 定义组件普通状态时的样式
   * @param instance
   */
  applyNormalAttribute(instance: GridItemAttribute): void {
    instance.translate({ x: this.offsetX, y: this.offsetY });
    instance.opacity(this.opacity);
  }
}

/**
 * 声明被添加的gridItem动态属性
 */
@Observed
export class TranslateItemModifier extends AttributeUpdater<ColumnAttribute> {
  /**
   * 定义组件普通状态时的样式
   * @param instance
   */
  initializeModifier(instance: ColumnAttribute): void {
    instance.translate({ x: 0, y: 0 })
      .visibility(Visibility.Visible);
  }
}