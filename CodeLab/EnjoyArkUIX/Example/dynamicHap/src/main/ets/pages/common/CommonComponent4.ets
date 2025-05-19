/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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


@Entry
@Component
struct CommonComponent4 {
  @State isLunar: boolean = false
  private selectedDate: Date = new Date('2021-08-08')
  private data: Array<string> = [
    '砍价活动',
    '拼团活动',
    '限时秒杀',
    '砍价活动',
    '拼团活动',
    '限时秒杀',
    '砍价活动',
    '拼团活动',
    '限时秒杀',
    '砍价活动',
    '拼团活动',
    '限时秒杀',
    '热销榜单'
  ];

  build() {
    Scroll() {
      Column() {
        Navigation() {
          DatePicker({
            start: new Date('1970-1-1'),
            end: new Date('2100-1-1'),
            selected: this.selectedDate
          })
            .disappearTextStyle({ color: Color.Gray, font: { size: '16fp', weight: FontWeight.Bold } })
            .textStyle({ color: '#ff182431', font: { size: '18fp', weight: FontWeight.Normal } })
            .selectedTextStyle({ color: '#ff0000FF', font: { size: '26fp', weight: FontWeight.Regular } })
            .lunar(this.isLunar)
            .onDateChange((value: Date) => {
              this.selectedDate = value
            })

          WaterFlow() {
            ForEach(this.data, (item: string, index: number) => {
              FlowItem() {
                Column() {
                  Text(item).fontSize(36).height('100%').focusable(true)
                }
              }
              .width('100%')
              .height('20%')
              .backgroundColor("#808080")
            })
          }
          .columnsTemplate("1fr 1fr")
          .columnsGap(10)
          .rowsGap(5)
          .backgroundColor("#D3D3D3")
          .width('100%')
          .height('100%')
          .margin(10)
        }
        .titleMode(NavigationTitleMode.Mini)
        .title('主标题')

      }
      .width('100%')
    }
    .height('100%')
  }
}
