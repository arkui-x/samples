import window from '@ohos.window';
import { TitleBar } from './TitleBar';
import router from '@ohos.router';
import display from '@ohos.display';
import { WindowType } from '../util/WindowConst';
import { BusinessError, Callback } from '@kit.BasicServicesKit';

// import Configuration from '@system.configuration';
// import colorSpaceManager from '@ohos.graphics.colorSpaceManager';

@Entry
@Component
struct WindowSetSystemBarProperty {
  private windowArray:window.Window[] = [];
  private windowId = 0;
  @State message: string = "";
  @State isShowing: boolean = false;
  @State nowWindow: number = -1;

  private systemBarFlag = 0;
  private mainView?: window.Window = undefined;
  private wm?: window.Window = undefined;
  private subWindow?: window.Window = undefined;

  private statusBarColors:string[] = ['#ff0000','#00ff00','#0000ff'];
  private navigationBarColors:string[] = ['#ff0000','#00ff00','#0000ff'];
  private statusBarColorIndex: number = 0;
  private navigationBarColorIndex: number = 0;
  //以下两个属性从API Version8开始支持
  // statusBarContentColor: '#ffffff',
  // navigationBarContentColor: '#00ffff',
  private isStatusBarLightIcon:boolean = false;
  private isNavigationBarLightIcon:boolean = false;
  private enableStatusBarAnimation:boolean = false;
  private enableNavigationBarAnimation:boolean = false;

  @State systemBarProperties: window.SystemBarProperties = {
    statusBarColor: this.statusBarColors[this.statusBarColorIndex%3],
    navigationBarColor: this.statusBarColors[this.navigationBarColorIndex%3],
    isStatusBarLightIcon: this.isStatusBarLightIcon,
    isNavigationBarLightIcon: this.isNavigationBarLightIcon,
    enableStatusBarAnimation: this.enableStatusBarAnimation,
  };


  private windowStage?: window.WindowStage = AppStorage.get("windowStage");
  private callback1:Callback<window.AvoidAreaOptions> = (res: window.AvoidAreaOptions) => {
    this.message += " \n 触发  avoidAreaChange callback1 " + JSON.stringify(res)
  }
  private callback2:Callback<window.AvoidAreaOptions> = (res: window.AvoidAreaOptions) => {
    this.message += " \n 触发  avoidAreaChange callback2 " + JSON.stringify(res)
  }
  onPageShow() {
    window.getLastWindow(AppStorage.get("context"), (err, data) => {
      if (err.code) {
        this.message += '\ngetLastWindow Error code:' + err.code
        return;
      }
      this.mainView = data;
      this.wm = this.mainView;
      this.wm.setWindowBackgroundColor("#FF00FF")
      this.message += '\ngetLastWindow Success '
    });
  }




  build() {
    Column() {
      Scroll() {
        Column() {
          TitleBar({ title: $r('app.string.WindowSetSystmBarProperty_title') })
            .width('100%')
          Text(this.message).margin({ bottom: 10 }).width('100%')
          Text("WindowStage 相关接口").margin({ top: 20 })
          Button("setWindowSystemBarProperties statusBarColor")
            .onClick(() => {
              try {
                this.message = ''

                if (this.wm == null) {
                  this.message += '\nWindow is null, please getLastWindow first';
                  return;
                }
                this.statusBarColorIndex = ++this.statusBarColorIndex%3;
                this.systemBarProperties.statusBarColor = this.statusBarColors[this.statusBarColorIndex]
                let promise = this.wm.setWindowSystemBarProperties(this.systemBarProperties);
                this.message += "\n设置 setWindowSystemBarProperties statusBarColor=" + this.statusBarColors[this.statusBarColorIndex]
              } catch (exception) {
                this.message += "设置 setWindowSystemBarProperties 失败"
                this.message += exception
                console.info("subwindow.setWindowSystemBarProperties: failed")
              }
            })
            .margin({ top: 5 })
          Button("setWindowSystemBarProperties navigationBarColors")
            .onClick(() => {
              try {
                this.message = ''

                if (this.wm == null) {
                  this.message += '\nWindow is null, please getLastWindow first';
                  return;
                }
                this.navigationBarColorIndex = ++this.navigationBarColorIndex%3;
                this.systemBarProperties.navigationBarColor = this.navigationBarColors[this.navigationBarColorIndex]
                let promise = this.wm.setWindowSystemBarProperties(this.systemBarProperties);
                this.message += "\n设置 setWindowSystemBarProperties navigationBarColor=" + this.navigationBarColors[this.navigationBarColorIndex]
              } catch (exception) {
                this.message += "设置 setWindowSystemBarProperties 失败"
                this.message += exception
                console.info("subwindow.setWindowSystemBarProperties: failed")
              }
            })
            .margin({ top: 5 })
          Button("setWindowSystemBarProperties isNavigationBarLightIcon")
            .onClick(() => {
              try {
                this.message = ''

                if (this.wm == null) {
                  this.message += '\nWindow is null, please getLastWindow first';
                  return;
                }
                this.isNavigationBarLightIcon = !this.isNavigationBarLightIcon;
                this.systemBarProperties.isNavigationBarLightIcon = this.isNavigationBarLightIcon
                let promise = this.wm.setWindowSystemBarProperties(this.systemBarProperties);
                this.message += "\n设置 setWindowSystemBarProperties isNavigationBarLightIcon =" + this.isNavigationBarLightIcon
              } catch (exception) {
                this.message += "设置 setWindowSystemBarProperties 失败"
                this.message += exception
                console.info("subwindow.setWindowSystemBarProperties: failed")
              }
            })
            .margin({ top: 5 })
          Button("setWindowSystemBarProperties isStatusBarLightIcon")
            .onClick(() => {
              try {
                this.message = ''

                if (this.wm == null) {
                  this.message += '\nWindow is null, please getLastWindow first';
                  return;
                }
                this.isStatusBarLightIcon = !this.isStatusBarLightIcon;
                this.systemBarProperties.isStatusBarLightIcon = this.isStatusBarLightIcon
                let promise = this.wm.setWindowSystemBarProperties(this.systemBarProperties);
                this.message += "\n设置 setWindowSystemBarProperties isStatusBarLightIcon = " + this.isStatusBarLightIcon
              } catch (exception) {
                this.message += "设置 setWindowSystemBarProperties 失败"
                this.message += exception
                console.info("subwindow.setWindowSystemBarProperties: failed")
              }
            })
            .margin({ top: 5 })
          Button("setWindowSystemBarProperties enableStatusBarAnimation")
            .onClick(() => {
              try {
                this.message = ''

                if (this.wm == null) {
                  this.message += '\nWindow is null, please getLastWindow first';
                  return;
                }
                this.enableStatusBarAnimation = !this.enableStatusBarAnimation;
                this.systemBarProperties.enableStatusBarAnimation = this.enableStatusBarAnimation
                let promise = this.wm.setWindowSystemBarProperties(this.systemBarProperties);
                this.message = "\n设置 setWindowSystemBarProperties enableStatusBarAnimation=" + this.enableStatusBarAnimation + "成功"
              } catch (exception) {
                this.message += "设置 setWindowSystemBarProperties 失败"
                this.message += exception
                console.info("subwindow.setWindowSystemBarProperties: failed")
              }
            })
            .margin({ top: 5 })




          Button("subwindow.create")
            .onClick(() => {
              console.info('subwindow.on 11111');
              try {
                if (!this.subWindow) {
                  this.message = '';
                  if (this.windowStage == undefined) {
                    return
                  }
                  this.windowStage.createSubWindow("subwindow", (err, data) => {
                    this.message += "\n show subwindow "
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
                    }
                  });
                }
                this.message += "\n设置 subwindow on 成功"
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
                return
              }
              this.subWindow.setUIContent('pages/WindowContent1', (err) => {
              });
              this.subWindow.showWindow((err) => {
                if (err.code) {
                  console.error('Failed to show the window. Cause: ' + JSON.stringify(err));
                  return;
                }
                console.info('Succeeded in showing the window.');
                if (this.subWindow == undefined) {
                  return
                }
                this.subWindow.moveWindowTo(100, 100, () => {
                })
              });
              console.info('subwindow show');
            }).margin({ top: 5 })
          Button("switch window")
            .onClick(() => {
              if (this.wm == this.mainView) {
                this.wm = this.subWindow
                this.message = "current window is subWindow"
              } else {
                this.wm = this.mainView
                this.message = "current window is mainView"
              }
              if (this.wm ==undefined) {
                this.message = "current window is undefined, please switch to mainWindow or create subwindow"
              }

            }).margin({ top: 5 })

          Button("setWindowSystemBarEnable")
            .onClick(() => {
              // 此处以不显示导航栏、状态栏为例
              let names:window.SpecificSystemBar = 'status';
              if (this.systemBarFlag%3 == 0) {
                names = 'status';
              } else if (this.systemBarFlag%3 == 1) {
                names = 'navigation';
              } else if (this.systemBarFlag%3 == 2) {
                names = 'navigationIndicator';
              }
              this.message = '';
              try {
                if (this.windowStage == undefined) {
                  return
                }
                this.wm = this.windowStage.getMainWindowSync();
                if (this.wm == undefined) {
                  return
                }
                this.message += 'enable = ' + JSON.stringify(this.systemBarFlag %2 == 0);
                this.message += ';systemBarType = ' + JSON.stringify(names);
                this.wm.setSpecificSystemBarEnabled(names,this.systemBarFlag %2 == 0).then(data=>{
                  this.systemBarFlag = (this.systemBarFlag == 6) ? 0 : (this.systemBarFlag + 1);
                  this.message += '\nsetWindowSystemBarEnable Success'
                }).catch((error:BusinessError) => {
                  this.message += '\nsetWindowSystemBarEnable Error code:' + error.code
                });

              } catch (exception) {
                this.message += '\nsetWindowSystemBarEnable catch'
              }
            })
            .margin({ top: 10 })
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