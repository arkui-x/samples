/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
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

import router from '@ohos.router';

@CustomDialog
struct CustomDialogExample {
  controller: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({}),
  })

  build() {
    Column() {
      Text('弹出窗口')
        .fontSize(20)
        .margin({ top: 10, bottom: 10 })
    }
  }
}

@Entry
@Component
struct CommonComponent1 {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample(),
  })
  @State bShow: boolean = true;

  build() {
    Row() {
      Scroll() {
        Column() {
          Button('按钮', { type: ButtonType.Normal, stateEffect: true })
            .borderRadius(8)
            .backgroundColor(0x317aff)
            .width(100)
            .height(40)
            .margin(10)
            .onClick(() => {
              this.bShow = !this.bShow
            })

          if (this.bShow) {
            Button('按钮Test', { type: ButtonType.Normal, stateEffect: true })
              .borderRadius(8)
              .backgroundColor(0x317aff)
              .width(100)
              .height(40)
              .margin(10)
          }

          Button("再下一页").onClick(() => {
            router.pushUrl({
              url: 'pages/common/CommonComponent4'
            });
          }).width('100%').margin(10)

          Row() {
            Radio({ value: 'Radio1', group: 'radioGroup' })
              .checked(true)
            Text("单选框A")
              .fontSize(30)
              .fontWeight(FontWeight.Normal)
            Radio({ value: 'Radio2', group: 'radioGroup' })
              .checked(false)
            Text("单选框B")
              .fontSize(30)
              .fontWeight(FontWeight.Normal)
          }.margin(10)


          Row() {
            Toggle({ type: ToggleType.Switch, isOn: false })
            Text("切换按钮")
              .fontSize(30)
              .fontWeight(FontWeight.Normal)
          }.margin(10)

          Row() {
            Text("进度条")
              .fontSize(30)
              .fontWeight(FontWeight.Normal)
            Progress({ value: 24, total: 100, type: ProgressType.Linear })
          }.margin(10)

          Text("文本显示")
            .fontSize(30)
            .border({ width: 2 })
            .fontWeight(FontWeight.Normal)
            .margin(10)

          TextInput()
            .fontSize(30)
            .border({ width: 2 })
            .fontWeight(FontWeight.Normal)
            .margin(10)


          TextArea()
            .fontSize(30)
            .border({ width: 2 })
            .fontWeight(FontWeight.Normal)
            .margin(10)

          Image($r('app.media.icon'))
            .width(200)
            .height(200)
            .margin(10)
            .focusable(true)

          Button('弹窗')
            .onClick(() => {
              this.dialogController.open()
            })
            .width(200)

        }
        .width('100%')
      }
    }
    .height('100%')
  }
}
