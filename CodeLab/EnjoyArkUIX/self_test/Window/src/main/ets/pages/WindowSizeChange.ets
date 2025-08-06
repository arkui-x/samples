import window from '@ohos.window';
import { TitleBar } from './TitleBar';
import router from '@ohos.router';
import display from '@ohos.display';
import { WindowType } from '../util/WindowConst';
import { BusinessError, Callback } from '@ohos.base';
import font from '@ohos.font';

// import Configuration from '@system.configuration';
// import colorSpaceManager from '@ohos.graphics.colorSpaceManager';

@Entry
@Component
struct Window {
  private windowArray:window.Window[] = [];
  private windowId = 0;
  @State message: string = "";
  @State isShowing: boolean = false;
  @State nowWindow: number = -1;
  @State windowHeight:number = 100;
  @State windowWidth:number = 100;
  @State windowX:number = 100;
  @State windowY:number = 100;
  private preferredOrientationFlag = 0;
  private brightnessFlag = 0.1;
  private isKeepScreenOnFlag = true;
  private setWindowBackgroundColorFlag = 0;
  private wm?: window.Window = undefined;
  private subWindow?: window.Window= undefined;
  private subWindow2?: window.Window= undefined
  private windowStage?: window.WindowStage = AppStorage.get("windowStage");
  private windowCallback1: Callback<window.Size> = ((data) => {
    this.message += " \n 触发 windowSizeChange callback1 on 回调监听 " + JSON.stringify(data)
    if (this.wm == undefined) {
      return
    }
    console.info("windowSizeChange.on: on callback " + JSON.stringify(data))
  });
  private windowCallback2: Callback<window.Size> = ((data) => {
    this.message += " \n 触发 windowSizeChange callback2 on 回调监听 " + JSON.stringify(data)
    if (this.wm == undefined) {
      return
    }
    console.info("windowSizeChange.on: on callback " + JSON.stringify(data))
  });
  private subWindowCallback1: Callback<window.Size> = ((data) => {
    this.message += " \n 触发 subWindowSizeChange callback1 on 回调监听 " + JSON.stringify(data)
    if (this.wm == undefined) {
      return
    }
    console.info("windowSizeChange.on: on callback " + JSON.stringify(data))
  });
  private subWindowCallback2: Callback<window.Size> = ((data) => {
    this.message += " \n 触发 subWindowSizeChange callback2 on 回调监听 " + JSON.stringify(data)
    if (this.wm == undefined) {
      return
    }
    console.info("windowSizeChange.on: on callback " + JSON.stringify(data))
  });
  onPageShow() {
    window.getLastWindow(AppStorage.get("context"), (err, data) => {
      if (err.code) {
        this.message += '\ngetLastWindow Error code:' + err.code
        return;
      }
      this.message += '\ngetLastWindow Success '
    });
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          TitleBar({ title: $r('app.string.WindowSizeChange_title') })
            .width('100%')
          Text(this.message).margin({ bottom: 10 }).width('100%')
          Text("WindowStage 相关接口").margin({ top: 20 })
          Button("on windowSizeChange1")
            .onClick(() => {
              if (this.windowStage == undefined) {
                return
              }
              this.wm = this.windowStage.getMainWindowSync();
              if (this.wm == undefined) {
                return
              }
              try {
                this.wm.on('windowSizeChange', this.windowCallback1);
                this.message += "\n设置 windowSizeChange on 成功"
              } catch (exception) {
                this.message = "设置 windowSizeChange on 失败    "
                this.message = exception
                console.info("windowSizeChange.on: failed")
              }
            })
            .margin({ top: 5 })

          Button("on windowSizeChange2")
            .onClick(() => {
              if (this.windowStage == undefined) {
                return
              }
              this.wm = this.windowStage.getMainWindowSync();
              if (this.wm == undefined) {
                return
              }
              try {
                this.wm.on('windowSizeChange', this.windowCallback2);
                this.message += "\n设置 windowSizeChange on 成功"
              } catch (exception) {
                this.message = "设置 windowSizeChange on 失败    "
                this.message = exception
                console.info("windowSizeChange.on: failed")
              }
            })
            .margin({ top: 5 })
          Button("subwindow.on windowSizeChange1")
            .onClick(() => {
              console.info('subwindow.on windowSizeChange');
              try {

                (async()=>{
                  if (!this.subWindow) {
                    this.message = '';
                    if (this.windowStage == undefined) {
                      return
                    }
                    await this.windowStage.createSubWindow("subwindow").then ((data) => {
                      this.subWindow = data;
                    }).catch((error:BusinessError)=>{

                      this.message += " \n 触发1 createSubWindow 1 error " + JSON.stringify(error.message)
                    });

                  }

                  if (!this.subWindow) {
                    return;
                  }
                  await this.subWindow.setUIContent('pages/WindowContent1').then ((data) => {
                  }).catch((error:BusinessError)=>{
                  });
                  await this.subWindow.setWindowBackgroundColor('#ff0000');
                  await this.subWindow.on('windowSizeChange', this.subWindowCallback1);
                })();

              } catch (exception) {
                this.message += "\n设置 windowSizeChange on 失败"
                console.info("windowSizeChange.on: failed")
              }
            })
            .margin({ top: 5 })
          Button("subwindow.on windowSizeChange2")
            .onClick(() => {
              console.info('subwindow.on windowSizeChange2');
              try {

                (async()=>{
                  if (!this.subWindow) {
                    this.message = '';
                    if (this.windowStage == undefined) {
                      return
                    }
                    await this.windowStage.createSubWindow("subwindow").then ((data) => {
                      this.subWindow = data;
                    }).catch((error:BusinessError)=>{

                      this.message += " \n 触发1 createSubWindow 1 error " + JSON.stringify(error.message)
                    });

                  }

                  if (!this.subWindow) {
                    return;
                  }
                  await this.subWindow.setUIContent('pages/WindowSizeChange').then ((data) => {
                  }).catch((error:BusinessError)=>{
                  });
                  await this.subWindow.setWindowBackgroundColor('#ff0000');
                  await this.subWindow.on('windowSizeChange', this.subWindowCallback2);
                })();

              } catch (exception) {
                this.message += "\n设置 windowSizeChange on 失败"
                console.info("windowSizeChange.on: failed")
              }
            })
            .margin({ top: 5 })
          Button("subwindow resize")
            .onClick(() => {
              if (this.subWindow == undefined) {
                return
              }
              this.subWindow.resize(this.windowWidth+=1, this.windowHeight+=1, () => {
              });
              console.info('subwindow.on 2222');
            }).margin({ top: 5 })

          Button("subwindow move")
            .onClick(() => {
              console.info('subwindow.on 2222');
              try {
                if (!this.subWindow) {
                  this.message = '';
                  return
                }
                this.subWindow.moveWindowTo(this.windowX+=1, this.windowY+=1, () => {

                });
                this.message += "\nsubwindow move 成功"
              } catch (exception) {
                this.message += "subwindow move 失败    "
                this.message += exception
                console.info("subwindow move: failed")
              }
            })
            .margin({ top: 5 })
          Button("subwindow2 show")
            .onClick(() => {
              if (this.subWindow == undefined) {
                return
              }

              this.subWindow.showWindow((err) => {
                if (err.code) {
                  console.error('Failed to show the window. Cause: ' + JSON.stringify(err));
                  return;
                }
                console.info('Succeeded in showing the window.');
              });
              console.info('subwindow show');
            }).margin({ top: 5 })
          Button("subwindow.destroyWindow")
            .onClick(() => {
              if (this.subWindow) {
                this.subWindow.destroyWindow((data) => {
                  this.message += "\n设置 subwindow destroyWindow 成功"
                  this.subWindow = undefined;
                })
              }
            })
            .margin({ top: 5 })

          Button("windowSizeChange.offAll")
            .onClick(() => {
              try {
                this.message = "";
                if (this.wm == undefined) {
                  return
                }
                this.wm.off('windowSizeChange');
                this.message += "\n设置 windowSizeChange off 成功"
              } catch (exception) {
                this.message += "\n设置 windowSizeChange off 失败"
                console.info("windowSizeChange.off: failed")
              }
            })
            .margin({ top: 5 })
          Button("windowSizeChange.off1")
            .onClick(() => {
              try {
                this.message = "";
                if (this.wm == undefined) {
                  return
                }
                this.wm.off('windowSizeChange',this.windowCallback1);
                this.message += "\n设置 windowSizeChange off 成功"
              } catch (exception) {
                this.message += "\n设置 windowSizeChange off 失败"
                console.info("windowSizeChange.off: failed")
              }
            })
            .margin({ top: 5 })
          Button("subWindow windowSizeChange .off")
            .onClick(() => {
              try {
                this.message = "";
                if (this.subWindow == undefined) {
                  return
                }
                this.subWindow.off('windowSizeChange');
                this.message += "\n设置 windowSizeChange off 成功"
              } catch (exception) {
                this.message += "\n设置 windowSizeChange off 失败"
                console.info("windowEvent.off: failed")
              }
            })
            .margin({ top: 5 })
          Button("subWindow windowSizeChange .off1")
            .onClick(() => {
              try {
                this.message = "";
                if (this.subWindow == undefined) {
                  return
                }
                this.subWindow.off('windowSizeChange',this.subWindowCallback1);
                this.message += "\n设置 windowSizeChange off 成功"
              } catch (exception) {
                this.message += "\n设置 windowSizeChange off 失败"
                console.info("windowEvent.off: failed")
              }
            })
            .margin({ top: 5 })
        }
        .width('100%')
        // .height('100%')
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Center)
      }
      .height(this.isShowing ? '50%' : '90%')

      //.height(this.getShowingCount() > 0 ? '50%' : '90%')

    }
  }
}