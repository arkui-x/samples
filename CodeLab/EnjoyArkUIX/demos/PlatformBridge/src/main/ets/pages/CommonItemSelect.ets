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

@Component
export struct CommonItemSelect {
  public name: ResourceStr = ''
  public selects: ResourceStr[] = []
  public callback: (index: number, value: string) => void = (index: number, value: string) => {
  }
  private selectOption: SelectOption[] = []
  private selectIndex: number = 0

  aboutToAppear() {
    this.selects.forEach((selects, index) => {
      this.selectOption[index] = { value: selects }
    })
  }

  build() {
    Row() {
      Text(this.name)
        .fontWeight(FontWeight.Medium)
        .maxLines(2)
        .constraintSize({ maxWidth: '65%' })
        .textOverflow({ overflow: TextOverflow.MARQUEE })
        .margin({
          left: 12,
          right: 12,
        })
      Select(this.selectOption)
        .width(120)
        .height(50)
        .value('请选择')
        .backgroundColor(Color.White)
        .borderRadius(19)
        .selected(this.selectIndex)
        .font({ size: 15, weight: FontWeight.Medium })
        .optionFont({ size: 15, weight: FontWeight.Medium })
        .menuAlign(MenuAlignType.START)
        .onSelect((index, value) => {
          this.callback(index, value)
          this.selectIndex = index
        })
    }
    .width('95%')
    .constraintSize({ minHeight: 40 })
    .padding({
      left: 12,
      right: 12,
      top: 8,
      bottom: 8
    })
    .borderRadius(24)
    .backgroundColor('#48b1a4a4')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}
