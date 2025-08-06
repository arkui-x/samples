

import display from '@ohos.display'
import { TitleBar } from './TitleBar';
@Entry
@Component
struct Index {
  @State message: string = 'Hello World test'
  @State isFoldable: string = ''
  @State foldStatus: string = ''
  @State foldDisplayMode: string = 'Hello World test'

  private displayAddCallback1: Callback<number> = ((data) => {
    this.message += " \n displayCallback1 displayId = " + JSON.stringify(data)
    console.info("addcallback displayId========== " + JSON.stringify(data))
  });
  private displayAddCallback2: Callback<number> = ((data) => {
    this.message += " \n displayCallback1 displayId = " + JSON.stringify(data)
    console.info("addcallback displayId========== " + JSON.stringify(data))
  });

  private displayRemoveCallback: Callback<number> = ((data) => {
    this.message += " \n removecallback displayId = " + JSON.stringify(data)
    console.info("removecallback displayId========== " + JSON.stringify(data))
  });

  private displayChangeCallback1: Callback<number> = ((data) => {
    this.message += " \n changecallback1 displayId = " + JSON.stringify(data)
    console.info("changecallback displayId========== " + JSON.stringify(data))
  });
  private displayChangeCallback2: Callback<number> = ((data) => {
    this.message += " \n changecallback2 displayId = " + JSON.stringify(data)
    console.info("changecallback displayId========== " + JSON.stringify(data))
  });

  private foldStatusCallback1: Callback<number> = ((data) => {
    this.message += " \n foldStatusCallback1 foldStatus = " + JSON.stringify(data)
    console.info("foldStatusCallback.on: on callback displayId========== " + JSON.stringify(data))
  });

  private foldStatusCallback2: Callback<number> = ((data) => {
    this.message += " \n foldStatusCallback2 foldStatus = " + JSON.stringify(data)
    console.info("foldStatusCallback.on: on callback displayId========== " + JSON.stringify(data))
  });


  build() {
    Row() {
      Column() {
        Scroll() {
          Column() {
            TitleBar({ title: $r('app.string.WindowDisplay_title') })
              .width('100%')
            Text(this.message)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
            Text("scaledDensity: " + display.getDefaultDisplaySync().scaledDensity.toString())
              .fontSize(20)
              .fontWeight(FontWeight.Bold)

            Text("dpi: " +display.getDefaultDisplaySync().densityDPI.toString())
              .fontSize(20)
              .fontWeight(FontWeight.Bold)

            Text("densityPixels: " + display.getDefaultDisplaySync().densityPixels.toString())
              .fontSize(20)
              .fontWeight(FontWeight.Bold)

            Text("densityDPI: " + display.getDefaultDisplaySync().densityDPI.toString())
              .fontSize(20)
              .fontWeight(FontWeight.Bold)

            Text("xDPI: " + display.getDefaultDisplaySync().xDPI.toString())
              .fontSize(20)
              .fontWeight(FontWeight.Bold)

            Text("yDPI: " + display.getDefaultDisplaySync().yDPI.toString())
              .fontSize(20)
              .fontWeight(FontWeight.Bold)

            Button("isFoldable:" + this.isFoldable)
              .onClick(() => {
                this.isFoldable = display.isFoldable().toString()
              })
            Button("getFoldStatus:" + this.foldStatus)
              .onClick(() => {
                this.foldStatus = display.getFoldStatus().toString()
                // setTimeout(() => {
                //   this.foldStatus = display.getFoldStatus().toString()
                // }, 5000);
              })
            Button("displayListener.on1")
              .onClick(() => {
                try {
                  // display.on('add', this.displayAddCallback)
                  // display.on('remove', this.displayRemoveCallback)
                  display.on('change', this.displayChangeCallback1)
                  this.message = "设置displayListener1 监听 成功"
                } catch (exception) {
                  this.message = "设置 displayListener 监听 失败"
                }
              })
              .margin({ top: 5 })
            Button("displayListener.on2")
              .onClick(() => {
                try {
                  // display.on('add', this.displayAddCallback)
                  // display.on('remove', this.displayRemoveCallback)
                  display.on('change', this.displayChangeCallback2)
                  this.message = "设置displayListener2 监听 成功"
                } catch (exception) {
                  this.message = "设置displayListener2 监听 失败"
                }
              })
              .margin({ top: 5 })
            Button("displayListener.off")
              .onClick(() => {
                try {
                  // display.off('add', this.displayAddCallback)
                  // display.off('remove', this.displayRemoveCallback)
                  display.off('change')
                  this.message = "删除 displayListener 监听 成功"
                } catch (exception) {
                  this.message = "删除 displayListener 监听 失败"
                }
              })
              .margin({ top: 5 })
            Button("displayListener.off1")
              .onClick(() => {
                try {
                  // display.off('add', this.displayAddCallback)
                  // display.off('remove', this.displayRemoveCallback)
                  display.off('change',this.displayChangeCallback1)
                  this.message = "删除 displayListener1 监听 成功"
                } catch (exception) {
                  this.message = "删除 displayListener1 监听 失败"
                }
              })
              .margin({ top: 5 })

            Button("foldStatusListener.on1")
              .onClick(() => {
                try {
                  display.on('foldStatusChange', this.foldStatusCallback1)
                  this.message = "设置foldStatusChange1 监听 成功"
                } catch (exception) {
                  this.message = "删除foldStatusChange 监听 失败"
                }
              })
              .margin({ top: 5 })
            Button("foldStatusListener.on2")
              .onClick(() => {
                try {
                  display.on('foldStatusChange', this.foldStatusCallback2)
                  this.message = "设置foldStatusChange2 监听 成功"
                } catch (exception) {
                  this.message = "删除foldStatusChange 监听 失败"
                }
              })
              .margin({ top: 5 })
            Button("foldStatusListener.off")
              .onClick(() => {
                try {
                  display.off('foldStatusChange')
                  this.message = "删除foldStatusChange 监听 成功"
                } catch (exception) {
                  this.message = "删除foldStatusChange 监听 失败"
                }
              })
              .margin({ top: 5 })
            Button("foldStatusListener.off1")
              .onClick(() => {
                try {
                  display.off('foldStatusChange', this.foldStatusCallback1)
                  this.message = "删除foldStatusCallback1 监听 成功"
                } catch (exception) {
                  this.message = "删除foldStatusChange 监听 失败"
                }
              })
              .margin({ top: 5,bottom:50 })

          }
        }
      }
      .width('100%')
    }
    .height('100%')
  }

  aboutToAppear() {
    this.message = '11';
    setTimeout(()=>{
      this.message = '22';
    }, 1000)
  }
}


















