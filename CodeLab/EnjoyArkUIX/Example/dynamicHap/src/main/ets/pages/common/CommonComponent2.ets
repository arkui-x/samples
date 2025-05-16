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
struct CommonComponent2 {
  private controller: VideoController | undefined;
  private previewUris: Resource = $r('app.media.icon');

  @State handlePopup: boolean = false
  richEdController: RichEditorController = new RichEditorController();
  richEdoptions: RichEditorOptions = { controller: this.richEdController };

  @Builder
  myMenu(){
    Menu(){
      MenuItem({content: '编译 Hap(s)'})
      MenuItem({content: '编译 APP(s)'})
    }
  }
  @Builder
  subMenu(){
    Menu(){
      MenuItemGroup({header: '构建'}){
        MenuItem({content: '编译Hap(s)/APP(s)',builder:():void=> this.myMenu()})
        MenuItem({content: '清理项目'})
      }
    }
  }

  build() {
    Row() {
      Column() {

        //暂时不适配跨平台
/*        RichEditor(this.richEdoptions)
          .onReady(() => {
            this.richEdController.addTextSpan('创建字符串构建的RichEditor组件。', {
              style: {
                fontColor: Color.Red,
                fontSize: 15
              }
            })
          })
          .width('100%')
          .margin(20)*/


        Button('气泡提示')
          .onClick(() => {
            this.handlePopup = !this.handlePopup
          })
          .bindPopup(this.handlePopup, {
            message: 'This is a popup with PopupOptions',
            primaryButton: {
              value: 'confirm',
              action: () => {
                this.handlePopup = !this.handlePopup
                console.info('confirm Button click')
              }
            },
            // 第二个按钮
            secondaryButton: {
              value: 'cancel',
              action: () => {
                this.handlePopup = !this.handlePopup
                console.info('cancel Button click')
              }
            },
          }).margin(10)
          .width('100%')

        Button('菜单')
          .bindMenu(this.subMenu())
      }
      .width('100%')
    }
    .height('100%')
  }
}
