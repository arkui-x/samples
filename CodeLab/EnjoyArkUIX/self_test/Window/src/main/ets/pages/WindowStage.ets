import window from '@ohos.window';
import router from '@ohos.router';
import { BusinessError } from '@ohos.base';
import * as WindowContent2 from './WindowContent2';
import { TitleBar } from './TitleBar';
import { ErrorCode } from '@ohos.ability.errorCode';

@Entry
@Component
struct WindowStage {
    private subWindow?:window.Window = undefined;
    readonly subWindowName = "subWindow"
    @State message: string = "";
    private lastWindow?:window.Window = undefined;
    private windowStage? : window.WindowStage = AppStorage.get("windowStage");
    onPageShow() {

    }

    build() {
        Column() {
            Scroll() {
                Column() {
                    TitleBar({ title: $r('app.string.WindowStage_title') })
                        .width('100%')
                    Text(this.message).margin({ bottom: 10 })
                    Text("WindowStage 相关接口")
                        .margin({ top: 20 })

                    Button("getMainWindow")
                        .onClick(() => {
                            this.message = ''
                            if (this.windowStage == undefined) {
                                return
                            }
                            this.windowStage.getMainWindow((err, data) => {
                                console.info("getMainWindow");
                                if (err.code) {
                                    this.message += "\ngetMainWindow 失败 code:" + err.code
                                    return;
                                }
                                this.message += "\ngetMainWindow 成功 "
                                this.printWindowProperties(data)
                            });
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

                    Button("windowStage.off")
                        .onClick(() => {
                            try {
                                this.message = ''

                                if (this.windowStage == undefined) {
                                    return
                                }
                                this.windowStage.off('windowStageEvent');
                                this.message += "\n 取消 windowStageEvent 监听 成功"
                            } catch (exception) {
                                this.message += "\n 取消 windowStageEvent 监听 失败"
                            }
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
                    Button("windowStage.loadContentByName")
                        .onClick(() => {
                            try {
                                this.message = ''
                                if (this.windowStage == undefined) {
                                    return
                                }
                                this.windowStage.loadContentByName(WindowContent2.entryName, (error, data) => {
                                    // this.message += "\n触发 windowStage loadContentByName " + JSON.stringify(data)
                                });
                                this.message += "\n设置 loadContentByName 成功"
                            } catch (exception) {
                                this.message += "\n设置 loadContentByName 失败"
                            }
                        })
                        .margin({ top: 5 })
                    Button("windowStage.loadContentByName")
                        .onClick(() => {
                            try {
                                this.message = ''
                                if (this.windowStage == undefined) {
                                    return
                                }

                                this.windowStage.loadContentByName(WindowContent2.entryName, (error:BusinessError,data) => {
                                    this.message += "\n触发 windowStage loadContentByName " + JSON.stringify(data)
                                });
                                this.message += "\n设置 loadContentByName 成功"
                            } catch (exception) {
                                this.message += "\n设置 loadContentByName 失败"
                            }
                        })
                        .margin({ top: 5 })
                    Button("windowStage.loadContentByName")
                        .onClick(() => {
                            try {
                                this.message = ''
                                if (this.windowStage == undefined) {
                                    return
                                }
                                this.windowStage.loadContentByName(WindowContent2.entryName, LocalStorage.getShared()).then(data=>{
                                this.message += "\n触发 windowStage loadContentByName " + JSON.stringify(data)
                                }).catch((error:BusinessError) => {
                                    this.message += "\n设置 loadContentByName 失败"
                                });
                            } catch (exception) {
                                this.message += "\n设置 loadContentByName 失败"
                            }
                        })
                        .margin({ top: 5 })

                    Button("windowStage.off")
                        .onClick(() => {
                            try {
                                this.message = ''

                                if (this.windowStage == undefined) {
                                    return
                                }
                                this.windowStage.off('windowStageEvent');
                                this.message += "\n 取消 windowStageEvent 监听 成功"
                            } catch (exception) {
                                this.message += "\n 取消 windowStageEvent 监听 失败"
                            }
                        })
                        .margin({ top: 5 })

                    Button("createSubWindow")
                        .onClick(() => {
                            try {
                                this.message = ''
                                if (this.windowStage == undefined) {
                                    return
                                }
                                this.windowStage.createSubWindow(this.subWindowName, (err, data) => {
                                    if (err.code) {
                                        this.message += "\n createSubWindow 失败 code:" + err.code
                                        return;
                                    }
                                    this.subWindow = data;
                                    this.message += "\n createSubWindow 成功 "
                                    this.printWindowProperties(this.subWindow)
                                });
                            } catch (exception) {
                                this.message += "\n createSubWindow 异常 "
                            }
                        })
                        .margin({ top: 5 })

                    Button("deleteSubWindow")
                        .onClick(() => {
                            try {
                                if (this.subWindow) {
                                    this.subWindow.destroyWindow((err:BusinessError,data) => {
                                        if (err.code) {
                                            this.message += "\n destroyWindow 失败 code:" + err.code
                                            return;
                                        }
                                        this.message += "\n destroyWindow 成功 "
                                        this.subWindow = undefined;
                                    });
                                }
                            } catch (exception) {
                                this.message += "\n deleteSubWindow 异常 "
                            }
                        })
                        .margin({ top: 5 })

                    Button("getSubWindow")
                        .onClick(() => {
                            this.message = ''
                            if (this.windowStage == undefined) {
                                return
                            }
                                this.windowStage.getSubWindow((err, data) => {
                                if (err.code) {
                                    this.message += "\n getSubWindow 失败 code:" + err.code
                                    return;
                                }
                                this.message += "\n getSubWindow 成功 "
                                for (let i of data) {
                                    this.printWindowProperties(i)
                                }
                            });
                        })
                        .margin({ top: 5 })

                }
                .width('100%')
                //.height('100%')
                .justifyContent(FlexAlign.Start)
                .alignItems(HorizontalAlign.Center)
            }
            .height('90%')

            Column() {
                Row() {
                    Button("Window")
                        .onClick(() => {
                            router.pushUrl({ url: "pages/Window" })
                        })

                    Button('主页')
                        .onClick(() => {
                            router.pushUrl({ url: 'pages/EnterPage' })
                        })
                }.margin({ top: 5 })
            }
            .height('10%')
        }
        .height('100%')
    }

    private printWindowProperties(window:window.Window) {
        try {
            let properties = window.getWindowProperties();
            this.message += "\n windowRect:" + JSON.stringify(properties.windowRect) + ",windowType:" + ",brightness" + properties.brightness + ",isKeepScreenOn:" + properties.isKeepScreenOn
        } catch (exception) {
            this.message += "\n打印窗口属性失败";
        }
    }
}