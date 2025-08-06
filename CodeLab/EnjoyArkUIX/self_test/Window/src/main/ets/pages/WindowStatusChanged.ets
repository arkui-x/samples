import window from '@ohos.window';
import { TitleBar } from './TitleBar';
import router from '@ohos.router';
import display from '@ohos.display';
import { WindowType } from '../util/WindowConst';
// import Configuration from '@system.configuration';
// import colorSpaceManager from '@ohos.graphics.colorSpaceManager';

@Entry
@Component
struct Window {
    @State message: string = "";
    @State isShowing: boolean = false;
    @State nowWindow: number = -1;
    private wm?: window.Window = undefined;
    private subWindow?: window.Window= undefined;
    private subWindow2?: window.Window= undefined
    private windowStage?: window.WindowStage = AppStorage.get("windowStage");
    private statusList:string[] = ["WINDOW_STATUS_UNDEFINED","WINDOW_STATUS_FULLSCREEN",
        "WINDOW_STATUS_MAXIMIZE","WINDOW_STATUS_MINIMIZE",
        "WINDOW_STATUS_FLOATING","WINDOW_STATUS_SPLITSCREEN"]
    private callback1:Callback<window.WindowStatusType> = (res: window.WindowStatusType) => {
        this.message += " \n 触发  WindowStatusChange callback1 " + this.getWindowStatus(res)
    }
    private callback2:Callback<window.WindowStatusType> = (res: window.WindowStatusType) => {
        this.message += " \n 触发  WindowStatusChange callback2 " + this.getWindowStatus(res)
    }
    getWindowStatus(status:window.WindowStatusType): string{

        return this.statusList[status];
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
 onBackPress(): boolean | void {

 }
    build() {
        Column() {
            Scroll() {
                Column() {
                    TitleBar({ title: $r('app.string.WindowStatusChanged_title') })
                        .width('100%')
                    Text(this.message).margin({ bottom: 10 }).width('100%')
                    Text("WindowStage 相关接口").margin({ top: 20 })
                    Button("windowStatusChanged.on 1")
                        .onClick(() => {
                            if (this.windowStage == undefined) {
                                return
                            }
                            this.wm = this.windowStage.getMainWindowSync();
                            if (this.wm == undefined) {
                                return
                            }
                            try {
                                this.wm.on('windowStatusChange', this.callback1);
                                this.message = "\n设置 windowStatusChange on 成功"
                            } catch (exception) {
                                this.message = "设置 windowStatusChange on 失败    "
                                this.message = exception
                                console.info("windowStatusChange.on: failed")
                            }
                        })
                        .margin({ top: 5 })
                    
                    Button("windowStatusChange.on 2")
                        .onClick(() => {
                            if (this.windowStage == undefined) {
                                return
                            }
                            this.wm = this.windowStage.getMainWindowSync();
                            if (this.wm == undefined) {
                                return
                            }
                            try {
                                this.wm.on('windowStatusChange', this.callback2);
                                this.message = "\n设置 windowStatusChange on 成功"
                            } catch (exception) {
                                this.message += "设置 windowStatusChange on 失败    "
                                this.message += exception
                                console.info("windowStatusChange.on: failed")
                            }
                        })
                        .margin({ top: 5 })

                    Button("subwindow.on 1")
                        .onClick(() => {
                            console.info('subwindow.on 11111');
                            try {
                                if (!this.subWindow) {
                                    this.message = '';
                                    if (this.windowStage == undefined) {
                                        return
                                    }
                                    this.windowStage.createSubWindow("subwindow", (err, data) => {
                                        this.message = "\n show subwindow "
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
                                            this.subWindow.on('windowStatusChange', (data) => {
                                                this.message += " \n 触发 subwindow on 回调监听 " + this.getWindowStatus(data)
                                                if (this.subWindow == undefined) {
                                                    return
                                                }
                                                console.info("subwindow.on: on callback " + JSON.stringify(data) + ", id = " + this.subWindow.getWindowProperties()
                                                    )
                                            });
                                            this.message += "\n subWindow on windowStatusChange 设置成功"
                                        }
                                    });
                                } else {
                                    this.message = '';
                                    if (this.subWindow == undefined) {
                                        return
                                    }
                                    this.subWindow.on('windowStatusChange', (data) => {
                                        this.message += " \n 触发subwindow on 回调监听 " + this.getWindowStatus(data)
                                        if (this.subWindow == undefined) {
                                            return
                                        }
                                        console.info("subwindow.on: on callback " + JSON.stringify(data) + ", id = " + this.subWindow.getWindowProperties()
                                            )
                                    });
                                    this.subWindow.setUIContent('pages/WindowContent1', (err) => {
                                    });
                                    this.subWindow.resize(100, 100, (err) => {
                                    });
                                }
                                this.message = "\n设置 subwindow on 成功"
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
                                this.subWindow.moveWindowTo(0, 100, () => {
                                })
                            });
                            console.info('subwindow.on 2222');
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

                    Button("windowStatusChange.off")
                        .onClick(() => {
                            try {
                                this.message = "";
                                if (this.wm == undefined) {
                                    return
                                }
                                this.wm.off('windowStatusChange');
                                this.message = "\n设置 windowStatusChange off 成功"
                            } catch (exception) {
                                this.message += "\n设置 windowStatusChange off 失败"
                                console.info("windowStatusChange.off: failed")
                            }
                        })
                        .margin({ top: 5 })
                    Button("windowStatusChange.off1")
                        .onClick(() => {
                            try {
                                this.message = "";
                                if (this.wm == undefined) {
                                    return
                                }
                                this.wm.off('windowStatusChange',this.callback1);
                                this.message = "\n设置 windowStatusChange off1 成功"
                            } catch (exception) {
                                this.message += "\n设置 windowStatusChange off1 失败"
                                console.info("windowStatusChange.off: failed")
                            }
                        })
                        .margin({ top: 5 })
                    Button("windowStatusChange.off2")
                        .onClick(() => {
                            try {
                                this.message = "";
                                if (this.wm == undefined) {
                                    return
                                }
                                this.wm.off('windowStatusChange',this.callback2);
                                this.message = "\n设置 windowStatusChange off2 成功"
                            } catch (exception) {
                                this.message += "\n设置 windowStatusChange off2 失败"
                                console.info("windowStatusChange.off: failed")
                            }
                        })
                        .margin({ top: 5 })
                    Button("subwindowStatusChange.off")
                        .onClick(() => {
                            try {
                                this.message = "";
                                if (this.subWindow == undefined) {
                                    return
                                }
                                this.subWindow.off('windowStatusChange');
                                this.message = "\n设置 subwindow windowStatusChange off 成功"
                            } catch (exception) {
                                this.message += "\n设置 windowStatusChange off 失败"
                                console.info("windowStatusChange.off: failed")
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