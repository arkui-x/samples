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

import {TestBase} from './testbase';
import {CaseFactory} from './casefactory';
import {MyNodeController} from './myxnode';
import {Global} from './global';
import globalThis from '../utils/globalThis'
import resourceManager from '@ohos.resourceManager';
import image from '@ohos.multimedia.image';
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import fs from '@ohos.file.fs'
import { TitleBar } from './TitleBar';
import taskpool from '@ohos.taskpool'

const TAG = '[DrawingTest]';

@Entry
@Component
struct Index {
  //用来配置CanvasRenderingContext2D对象的参数，包括是否开启抗锯齿，true表明开启抗锯齿。
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  //用来创建CanvasRenderingContext2D对象，通过在canvas中调用CanvasRenderingContext2D对象来绘制。
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @State testType: string = 'arkuix';
  @State drawingType: string = 'gpu';
  @State caseNameStr: string  = 'ArkuiXMakeFromRawFileWithArgumentsTest';
  @State information: string = '';
  @State testAll: boolean = false;
  @State pause: boolean = false;
  caseNameStrBefore: string  = '';
  scroller: Scroller = new Scroller();
  caseCountStr: string = '1000';
  myNodeController = new MyNodeController();

  build() {
    Column() {
      Row() {
          NodeContainer(this.myNodeController)
            .width('100%')
            .height('100%')
            .backgroundColor('#FFFFFF')
            .onAppear(()=>{
              console.warn(TAG, 'MyNodeController onAppear');
            })
            .id('myNodeController')
      }
      .height('58%')
      TitleBar({ title: $r('app.string.Drawing_title') })
        .width('100%')
        .height('8%')
      Row() {
        Select([
          { value: 'arkuix'},
        ])
          .id('testType')
          .selected(0)
          .value(this.testType)
          .padding({left:5})
          .border({width:1})
          .width('40%')
          .onSelect((index: number, value: string)=>{
            this.testType = value;
            console.log(TAG, "select: " + this.testType);
          })

       if (this.testType == 'arkuix') {
          Select([
            { value: 'gpu' },
          ])
            .id('drawingType')
            .selected(0)
            .value('cpu')
            .padding({ left: 5 })
            .border({ width: 1 })
            .width('40%')
        }
      }
      .height('7%')
      Row() {
        Text('TestCase')
          .fontSize(14)
          .textAlign(TextAlign.End)
          .height(38)
          .margin({right:5})
        Column() {
          TextInput({ placeholder: 'ex:drawrect', text: this.caseNameStr})
            .id('caseName')
            .enterKeyType(EnterKeyType.Send)
            .placeholderFont({size: 15})
            .height(38)
            .width('60%')
            .border({width: 1, radius:10, color: '#88000000'})
            .onChange((value) => {
              if (value != "") {
                this.caseNameStr = value
              }
            })
        }
      }
      .height('7%')
      .width('80%')
      .margin({left:5})

      if (this.testType == 'arkuix'){
        Row(){
          Button("TestAll")
            .fontSize('16fp')
            .id('testAll')
            .fontWeight(500)
            .onClick(() => {
              console.log(TAG, "TestAll click");
              this.caseNameStr = "All"
              this.Draw();
            })
            .width('40%')
            .shadow(ShadowStyle.OUTER_DEFAULT_LG)
          Button("暂停")
            .fontSize('16fp')
            .id('pause')
            .fontWeight(500)
            .onClick(() => {
              console.log(TAG, "pause click");
              this.caseNameStr = "All"
              this.pause = true
            })
            .width('40%')
            .shadow(ShadowStyle.OUTER_DEFAULT_LG)
        }
        .height('7%')
      }

      Row() {
        Button("draw")
          .id('draw')
          .fontSize('16fp')
          .fontWeight(500)
          .onClick(() => {
            console.log(TAG, "Draw click");
            this.Draw();
          })
          .width('40%')
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)
        Button("继续")
          .fontSize('16fp')
          .id('continue')
          .fontWeight(500)
          .onClick(() => {
            console.log(TAG, "pause click");
            this.caseNameStr = "All"
            this.pause = false
          })
          .width('40%')
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)
      }
      .height('7%')
      Row() {
        Text(this.information)
          .fontSize(20)
          .textAlign(TextAlign.Center)
          .height(38)
          .id('infoText')
      }
      .height('7%')
    }
  }
  LogMsg(msg: string) {
    this.information = msg;
    console.log(TAG, msg);
  }
  async aboutToAppear() {
    const context : Context = getContext(this);
    try {
      const cpuPath : string = context.cacheDir + "/cpu";
      await fs.mkdir(cpuPath, true);
      const gpuPath = context.cacheDir + "/gpu";
      await fs.mkdir(gpuPath, true);
    } catch(e) {
      console.log("mkdir cpuPath or gpuPath failed " + JSON.stringify(e));
    }
    try {
      let resourceMgr: resourceManager.ResourceManager = getContext(this).resourceManager
      let imageResources: string[] = []
      imageResources.push("test_1.jpg")
      imageResources.push("test_2.jpg")
      imageResources.push("test_3.jpg")
      imageResources.push("test_4.jpg")
      for (let i = 0; i < imageResources.length; i++) {
        let imagePath = imageResources[i]
        let fileData = await resourceMgr.getRawFileContent(imagePath)
        const buffer = fileData.buffer
        const imageSource = image.createImageSource(buffer)
        imageSource.createPixelMap((err: Error, PixelMap: image.PixelMap) => {
          globalThis.getInstance().setPixelMap(imagePath, PixelMap)
          console.log("www data 0 in createPixelMap err is " + JSON.stringify(err));
        })
      }
    } catch (e) {
    }

    this.myNodeController.SetPrintCallback((str:string)=>{
      this.LogMsg(str);
    })
  }

  async Draw():Promise<void> {
    console.log(TAG, 'Drawing test start!');
    if (this.testType == 'arkuix') {
      if (this.drawingType == 'gpu') {
        return this.TestArkuixGpu(this.caseNameStr);
      }
    }
  }

  sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  async TestArkuixGpu(str: string) {
    if (str == 'All') {
      const iterator = CaseFactory.getArkuixAllCase().entries()
      let next = iterator.next()
      while (!next.done) {
        if (!this.pause) {
          let key = next.value[0]
          next = iterator.next()
          this.TestSingleArkuixGpu(key);
          if (key == 'canvasdrawimage') {
            await this.sleep(1500);
          } else {
            await this.sleep(500);
          }
        }
        await this.sleep(5000);
      }
    } else {
      this.TestSingleArkuixGpu(str);
    }
  }

  async TestSingleArkuixGpu(str: string) {
    this.myNodeController.TestArkuixGpuUpScreen(str);
    if (str == 'ArkuiXCanvasDrawImageTest') {
      await this.sleep(1000);
    } else {
      await this.sleep(50);
    }
    const context : Context = getContext(this);
    componentSnapshot.get("myNodeController", (error:Error, pixmap: image.PixelMap) => {
      if (error) {
        console.log("error:", JSON.stringify(error))
        return;
      }
      Global.savePixmap(context.cacheDir + '/gpu', str, pixmap);
    })
    this.LogMsg(str + '_end');
  }
}
