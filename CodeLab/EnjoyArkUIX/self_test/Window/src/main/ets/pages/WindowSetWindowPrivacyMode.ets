import window from '@ohos.window';
import { TitleBar } from './TitleBar';
import { BusinessError, Callback } from '@kit.BasicServicesKit';

@Entry
@Component
struct Window {
  @State message: string = "";
  @State isShowing: boolean = false;
  @State isPrivacyMode: boolean = false;
  @State nowWindow: number = -1;

  private wm?: window.Window = undefined;
  private subWindow?: window.Window= undefined;
  private windowStage?: window.WindowStage = AppStorage.get("windowStage");
  onBackPress(): boolean | void {
    return false
  }
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
          TitleBar({ title: $r('app.string.WindowSetPrivacyMode_title') })
            .width('100%')
          Text(this.message).margin({ bottom: 10 }).width('100%')
          Text("WindowStage 相关接口").margin({ top: 20 })
          Button("SetWindowPrivacyMode promise")
            .onClick(() => {
              if (this.windowStage == undefined) {
                return
              }
              this.wm = this.windowStage.getMainWindowSync();
              if (this.wm == undefined) {
                return
              }
              try {
                this.isPrivacyMode = !this.isPrivacyMode;
                this.wm.setWindowPrivacyMode(this.isPrivacyMode)
                this.message = "\nsetWindowPrivacyMode=" + this.isPrivacyMode + "成功"

              } catch (exception) {
                this.message = "setWindowPrivacyMode 失败    "
                this.message = exception
                console.info("setWindowPrivacyMode: failed")
              }
            })
            .margin({ top: 5 })

          Button("SetWindowPrivacyMode callback")
            .onClick(() => {
              if (this.windowStage == undefined) {
                return
              }
              this.wm = this.windowStage.getMainWindowSync();
              if (this.wm == undefined) {
                return
              }
              try {
                this.isPrivacyMode = !this.isPrivacyMode;
                this.wm.setWindowPrivacyMode(this.isPrivacyMode, (err, data) => {
                  if (err.code) {
                    console.error('Failed setWindowPrivacyMode. Cause: ' + JSON.stringify(err));
                  } else {
                    this.message += "\nsetWindowPrivacyMode=" + this.isPrivacyMode + "成功"
                  }

                })

              } catch (exception) {
                this.message += "setWindowPrivacyMode 失败    "
                this.message += exception
                console.info("setWindowPrivacyMode: failed")
              }
            })
            .margin({ top: 5 })

          Button("subwindow create")
            .onClick(() => {
              console.info('subwindow create');
              try {
                if (!this.subWindow) {
                  this.message = '';
                  if (this.windowStage == undefined) {
                    return
                  }
                  this.windowStage.createSubWindow("subwindow", (err, data) => {
                    if (err && err.code) {
                      //this.message += " \n 触发1 createSubWindow 1 error " + JSON.stringify(data)
                      console.info("subwindow.failed")
                    } else {
                      //  this.message += " \n 触发2 createSubWindow 1 success " + JSON.stringify(data)
                      console.info("subwindow.success")
                      this.subWindow = data
                      // this.subWindow.setWindowFocusable(false);
                      // this.subWindow.setWindowBackgroundColor('#ff0000')
                      this.subWindow.setUIContent('pages/WindowContent1', (err) => {
                      });
                      this.subWindow.resize(100, 100, (err) => {
                      });
                      // this.subWindow.setUIContent('pages/WindowContent1', (err) => {
                      // });
                    }
                  });
                } else {
                  this.message += "subwindow 已存在"
                }
              } catch (exception) {
                this.message += "设置 subwindow on 失败    "
                this.message += exception
                console.info("subwindow.on: failed")
              }
            })
            .margin({ top: 5 })
          Button("subwindow show")
            .onClick(() => {
              this.message += "\n show subwindow "
              if (this.subWindow == undefined) {
                this.message = "请先创建subwindow"
                return
              }
              this.subWindow.setUIContent('pages/WindowContent1');
              this.subWindow.setWindowBackgroundColor('#ff0000FF')
              this.subWindow.showWindow((err) => {
                if (err.code) {
                  console.error('Failed to show the window. Cause: ' + JSON.stringify(err));
                  return;
                }
                console.info('Succeeded in showing the window.');
                if (this.subWindow == undefined) {
                  return
                }
                this.subWindow.moveWindowTo(0, 100, () => {
                })
              });
              console.info('subwindow.on 2222');
            }).margin({ top: 5 })
          Button("subwindow SetWindowPrivacyMode promise")
            .onClick(() => {
              if (this.subWindow == undefined) {
                this.message = "\n请先创建subwindow"
                return
              }
              try {
                this.isPrivacyMode = !this.isPrivacyMode;
                this.subWindow.setWindowPrivacyMode(this.isPrivacyMode)
                this.message += "\nsetWindowPrivacyMode=" + this.isPrivacyMode + "成功"

              } catch (exception) {
                this.message = "setWindowPrivacyMode 失败    "
                this.message = exception
                console.info("setWindowPrivacyMode: failed")
              }
            })
            .margin({ top: 5 })

          Button("subwindow SetWindowPrivacyMode callback")
            .onClick(() => {
              if (this.subWindow == undefined) {
                this.message = "\n请先创建subwindow"
                return
              }
              try {
                this.isPrivacyMode = !this.isPrivacyMode;
                this.subWindow.setWindowPrivacyMode(this.isPrivacyMode, (err, data) => {
                  if (err.code) {
                    console.error('Failed setWindowPrivacyMode. Cause: ' + JSON.stringify(err));
                  } else {
                    this.message += "\nsetWindowPrivacyMode=" + this.isPrivacyMode + "成功"
                  }

                })

              } catch (exception) {
                this.message += "setWindowPrivacyMode 失败    "
                this.message += exception
                console.info("setWindowPrivacyMode: failed")
              }
            })
            .margin({ top: 5 })
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