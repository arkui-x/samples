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
    private windowArray:window.Window[] = [];
    private windowId = 0;
    @State message: string = "";
    @State isShowing: boolean = false;
    @State nowWindow: number = -1;
    private colorChangeFlag = true;
    private systemBarFlag = 0;
    private preferredOrientationFlag = 0;
    private brightnessFlag = 0.1;
    private isKeepScreenOnFlag = true;
    private setWindowBackgroundColorFlag = 0;
    private wm?: window.Window = undefined;
    private subWindow?: window.Window= undefined;
    private subWindow2?: window.Window= undefined
    private windowStage?: window.WindowStage = AppStorage.get("windowStage");

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
                    TitleBar({ title: $r('app.string.WindowEvent_title') })
                        .width('100%')
                    Text(this.message).margin({ bottom: 10 }).width('100%')
                    Text("WindowStage 相关接口").margin({ top: 20 })
                    Button("windowEvent.on 1")
                        .onClick(() => {
                            if (this.windowStage == undefined) {
                                return
                            }
                            this.wm = this.windowStage.getMainWindowSync();
                            if (this.wm == undefined) {
                                return
                            }
                            // try {
                            //     this.wm.on('touchOutside', (data) => {
                            //         this.message += " \n 触发 1 windowEvent on 回调监听 " + JSON.stringify(data)
                            //         if (this.wm == undefined) {
                            //             return
                            //         }
                            //         console.info("windowEvent.on: on callback " + JSON.stringify(data) + ", id = " + this.wm.getWindowProperties()
                            //            )
                            //     });
                            //     this.message += "\n设置 windowEvent on 成功"
                            // } catch (exception) {
                            //     this.message = "设置 windowEvent on 失败    "
                            //     this.message = exception
                            //     console.info("windowEvent.on: failed")
                            // }
                        })
                        .margin({ top: 5 })

                    Button("windowStage.on")
                        .onClick(() => {
                            try {
                                this.message = ''
                                if (this.windowStage == undefined) {
                                    return
                                }
                                this.windowStage.on('windowStageEvent', (data) => {
                                    this.message += "\n触发 windowStageEvent 监听 " + JSON.stringify(data)
                                });
                                this.message += "\n设置 windowStageEvent 监听 成功"
                            } catch (exception) {
                                this.message += "\n设置 windowStageEvent 监听 失败"
                            }
                        })
                        .margin({ top: 5 })
                    Button("windowEvent.on 2")
                        .onClick(() => {
                            if (this.windowStage == undefined) {
                                return
                            }
                            this.wm = this.windowStage.getMainWindowSync();
                            if (this.wm == undefined) {
                                return
                            }
                            try {
                                this.wm.on('windowEvent', (data) => {
                                    this.message += " \n 触发2 windowEvent on 回调监听 " + JSON.stringify(data)
                                    if (this.wm == undefined) {
                                        return
                                    }
                                    console.info("windowEvent.on: on callback " + JSON.stringify(data) + ", id = " + this.wm.getWindowProperties()
                                       )
                                });
                                this.message += "\n设置 windowEvent on 成功"
                            } catch (exception) {
                                this.message += "设置 windowEvent on 失败    "
                                this.message += exception
                                console.info("windowEvent.on: failed")
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
                                            this.subWindow.on('windowEvent', (data) => {
                                                this.message += " \n 触发 subwindow on 回调监听 " + JSON.stringify(data)
                                                if (this.subWindow == undefined) {
                                                    return
                                                }
                                                console.info("subwindow.on: on callback " + JSON.stringify(data) + ", id = " + this.subWindow.getWindowProperties()
                                                    )
                                            });
                                            // this.subWindow.setUIContent('pages/WindowContent1', (err) => {
                                            // });
                                        }
                                    });
                                } else {
                                    this.message = '';
                                    if (this.subWindow == undefined) {
                                        return
                                    }
                                    this.subWindow.on('windowEvent', (data) => {
                                        this.message += " \n 触发subwindow on 回调监听 " + JSON.stringify(data)
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
                                this.subWindow.moveWindowTo(0, 100, () => {
                                })
                            });
                            console.info('subwindow.on 2222');
                        }).margin({ top: 5 })

                    Button("subwindow.on 2")
                        .onClick(() => {
                            console.info('subwindow.on 2222');
                            try {
                                if (!this.subWindow2) {
                                    this.message = '';
                                    if (this.windowStage == undefined) {
                                        return
                                    }
                                    this.windowStage.createSubWindow("subwindow2", (err, data) => {
                                        this.message += "\n show subwindow2 "
                                        if (err && err.code) {
                                            this.message += " \n 触发1 createSubWindow 2 error " + JSON.stringify(data)
                                            console.info("subwindow2.failed")
                                        } else {
                                            this.message += " \n 触发2 createSubWindow 2 success " + JSON.stringify(data)
                                            console.info("subwindow2.success")
                                            this.subWindow2 = data

                                            // this.subWindow.setWindowBackgroundColor('#ff0000')
                                            this.subWindow2.setUIContent('pages/WindowContent2', (err) => {
                                            });
                                            this.subWindow2.resize(100, 100, (err) => {
                                            });
                                            this.subWindow2.on('windowEvent', (data) => {
                                                this.message += " \n 触发 subwindow2 on 回调监听 " + JSON.stringify(data)
                                                if (this.subWindow == undefined) {
                                                    return
                                                }
                                                console.info("subwindow2.on: on callback " + JSON.stringify(data) + ", id = " + this.subWindow.getWindowProperties()
                                                    )
                                            });
                                            // this.subWindow.setUIContent('pages/WindowContent1', (err) => {
                                            // });
                                        }
                                    });
                                } else {
                                    this.message = '';
                                    if (this.subWindow2 == undefined) {
                                        return
                                    }
                                    this.subWindow2.on('windowEvent', (data) => {
                                        this.message += " \n 触发subwindow on 回调监听 " + JSON.stringify(data)
                                        if (this.subWindow == undefined) {
                                            return
                                        }
                                        console.info("subwindow.on: on callback " + JSON.stringify(data) + ", id = " + this.subWindow.getWindowProperties()
                                            )
                                    });
                                    this.subWindow2.setUIContent('pages/WindowContent1', (err) => {
                                    });
                                    this.subWindow2.resize(100, 100, (err) => {
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
                    Button("subwindow2 show")
                        .onClick(() => {
                            if (this.subWindow2 == undefined) {
                                return
                            }
                            this.subWindow2.setUIContent('pages/WindowContent1', (err) => {
                            });
                            if (this.subWindow == undefined) {
                                return
                            }
                            this.subWindow.setWindowColorSpace(window.ColorSpace.WIDE_GAMUT, (data)=>{
                                console.info('Succeeded setWindowColorSpace in subwindow2 window.');
                            })
                            this.subWindow2.showWindow((err) => {
                                if (err.code) {
                                    console.error('Failed to show the window. Cause: ' + JSON.stringify(err));
                                    return;
                                }
                                console.info('Succeeded in showing the window.');
                            });
                            if (this.subWindow2 == undefined) {
                                return
                            }
                            this.subWindow2.moveWindowTo(0, 200, () => {
                            })
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

                    Button("windowEvent.off")
                        .onClick(() => {
                            try {
                                this.message = "";
                                if (this.wm == undefined) {
                                    return
                                }
                                this.wm.off('windowEvent');
                                this.message += "\n设置 windowEvent off 成功"
                            } catch (exception) {
                                this.message += "\n设置 windowEvent off 失败"
                                console.info("windowEvent.off: failed")
                            }
                        })
                        .margin({ top: 5 })
                    Button("subwindowEvent1.off")
                        .onClick(() => {
                            try {
                                this.message = "";
                                if (this.subWindow == undefined) {
                                    return
                                }
                                this.subWindow.off('windowEvent');
                                this.message += "\n设置 windowEvent off 成功"
                            } catch (exception) {
                                this.message += "\n设置 windowEvent off 失败"
                                console.info("windowEvent.off: failed")
                            }
                        })
                        .margin({ top: 5 })
                    Button("subwindowEvent2.off")
                        .onClick(() => {
                            try {
                                this.message = "";
                                if (this.subWindow2 == undefined) {
                                    return
                                }
                                this.subWindow2.off('windowEvent');
                                this.message += "\n设置 windowEvent off 成功"
                            } catch (exception) {
                                this.message += "\n设置 windowEvent off 失败"
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