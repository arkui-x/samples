import window from '@ohos.window';
import router from '@ohos.router';
import display from '@ohos.display';
import { WindowType } from '../util/WindowConst';
import * as WindowContent2 from './WindowContent2';
import { BusinessError } from '@ohos.base';
import { TitleBar } from './TitleBar';

// import Configuration from '@system.configuration';


export default class WindowObj {
    public name: string = "";
    public window:window.Window;
    public isShowing: boolean = false;
    constructor(name: string, window:window.Window, isShowing: boolean) {
        this.name = name;
        this.window = window;
        this.isShowing = isShowing;
    }
};
@Entry
@Component
struct Window {
     private windowArray:WindowObj[] = [];
    private windowId = 0;
    @State message: string = "";
    @State isShowing: boolean = false;
    @State nowWindow: number = -1;
    private lastWindow?:window.Window = undefined;
    private colorChangeFlag = true;
    private systemBarFlag = 0;
    private preferredOrientationFlag = 0;
    private brightnessFlag = 0.1;
    private isKeepScreenOnFlag = true;
    private setWindowBackgroundColorFlag = 0;
    private windowStage? : window.WindowStage = AppStorage.get("windowStage");

    onPageShow() {
        window.getLastWindow(AppStorage.get("context"), (err, data) => {
            if (err.code) {
                this.message += '\ngetLastWindow Error code:' + err.code
                return;
            }
            this.lastWindow = data;
            this.message += '\ngetLastWindow Success '
            this.printWindowProperties(this.lastWindow)
        });
    }

    build() {
        Column() {
            Scroll() {
                Column() {
                    TitleBar({ title: $r('app.string.window_title') })
                        .width('100%')

                    Text(this.message).margin({ bottom: 10 }).width('100%')

                    Button("创建多窗口")
                        .onClick(() => {
                            this.message = '';
                            if (this.windowArray.length >= 10) {
                                this.message += '\n窗口创建数量已达上限：max=10'
                                return;
                            }
                            let windowName = 'Window' + this.windowId;
                            this.windowId++;
                            if (this.windowStage == undefined) {
                                return
                            }
                                this.windowStage.createSubWindow(windowName, (err, data) => {
                                if (err.code) {
                                    this.message += '\n创建' + windowName + '失败 code:' + err.code
                                    return;
                                }
                                //this.windowNameArray.push(windowName);
                                // 参数：windowName，window，isShowing

                                this.windowArray.push(new WindowObj(windowName, data, false));
                                this.nowWindow = this.windowArray.length - 1;
                                // this.message += '\nnowWindow=' + this.nowWindow;
                                this.message += '\nCreate ' + windowName + ' Success'
                                this.resizeWindow(data, 100, 100);
                                this.message += '\nResize ' + windowName + ' (100, 100) Success'
                                this.moveWindow(data, 0, 0);
                                this.message += '\nMove ' + windowName + ' (0, 0) Success'
                            });
                        })
                    Button("windowEvent")
                        .onClick(() => {
                            router.pushUrl({ url: "pages/WindowEvent" })
                    }).margin({ top: 5 })
                    Button("windowSizeChange")
                        .onClick(() => {
                            router.pushUrl({ url: "pages/WindowSizeChange" })
                        }).margin({ top: 5 })
                    Button("windowAvoidArea")
                        .onClick(() => {
                            router.pushUrl({ url: "pages/WindowOnAvoidArea" })
                        }).margin({ top: 5 })
                    Button("windowSetSystemBarProperty")
                        .onClick(() => {
                            router.pushUrl({ url: "pages/WindowSetSystemBarProperty" })
                        }).margin({ top: 5 })
                    Button("windowStatusChanged")
                        .onClick(() => {
                            router.pushUrl({ url: "pages/WindowStatusChanged" })
                        }).margin({ top: 5 })
                    Button("windowSetWindowPrivacyMode")
                        .onClick(() => {
                            router.pushUrl({ url: "pages/WindowSetWindowPrivacyMode" })
                        }).margin({ top: 5 })
                   Button("displayPpi等接口")
                    .onClick(() => {
                        router.pushUrl({ url: "pages/WindowDisplay" })
                    }).margin({ top: 5 })

                    Button("find window")
                        .onClick(() => {
                            this.message = ''
                            for (let windowItem of this.windowArray) {
                                try {
                                    let resultWindow = window.findWindow(windowItem.name);
                                    this.message += '\nfind ' + windowItem.name + ' 成功'
                                    this.printWindowProperties(resultWindow)
                                } catch (exception) {
                                    this.message += '\nfind ' + windowItem.name + ' 错误'
                                }
                            }
                        })
                        .margin({ top: 10 })

                    Button("setUIContent")
                        .onClick(() => {
                            this.message = '';
                            if (this.windowArray.length == 0) {
                                this.message += '\n窗口未创建，请创建窗口';
                                return;
                            }
                            let w  = this.windowArray[this.nowWindow];
                            if (w.window == null) {
                                this.message += '\n' + w.name + ' 未创建';
                            } else {
                                w.window.setUIContent('pages/WindowContent1', (err) => {
                                    if (err.code) {
                                        this.message += '\n' + w.name + ' setUIContent 失败 code:' + err.code;
                                        return;
                                    }
                                    this.message += '\n' + w.name + ' setUIContent 成功';
                                });
                            }
                        })
                        .margin({ top: 10 })

                    Button("loadContent")
                        .onClick(() => {
                            this.message = '';
                            if (this.windowArray.length == 0) {
                                this.message += '\n窗口未创建，请创建窗口';
                                return;
                            }
                            let w  = this.windowArray[this.nowWindow];
                            if (w.window == null) {
                                this.message += '\n' + w.name + ' 未创建';
                            } else {
                                
                                // w.window.loadContent('pages/WindowContent1',LocalStorage.getShared() , (err) => {
                                //     if (err.code) {
                                //         this.message += '\n' + w.name + ' loadContent 失败 code:' + err.code;
                                //         return;
                                //     }
                                //     this.message += '\n' + w.name + ' loadContent 成功';
                                // });
                                w.window.getUIContext();
                            }
                        })
                        .margin({ top: 10 })
                    Button("loadContentByName")
                        .onClick(() => {
                            this.message = '';
                            if (this.windowArray.length == 0) {
                                this.message += '\n窗口未创建，请创建窗口';
                                return;
                            }
                            let w  = this.windowArray[this.nowWindow];
                            if (w.window == null) {
                                this.message += '\n' + w.name + ' 未创建';
                            } else {

                                w.window.loadContentByName(WindowContent2.entryName, (err) => {
                                    if (err.code) {
                                        this.message += '\n' + w.name + ' loadContent 失败 code:' + err.code;
                                        return;
                                    }
                                    this.message += '\n' + w.name + ' loadContent 成功';
                                });
                            }
                        })
                        .margin({ top: 5 })
                    Button("loadContentByName")
                        .onClick(() => {
                            this.message = '';
                            if (this.windowArray.length == 0) {
                                this.message += '\n窗口未创建，请创建窗口';
                                return;
                            }
                            let w  = this.windowArray[this.nowWindow];
                            if (w.window == null) {
                                this.message += '\n' + w.name + ' 未创建';
                            } else {

                                w.window.loadContentByName('WindowContent2',LocalStorage.getShared() , (err) => {
                                    if (err.code) {
                                        this.message += '\n' + w.name + ' loadContent 失败 code:' + err.code;
                                        return;
                                    }
                                    this.message += '\n' + w.name + ' loadContent 成功';
                                });
                            }
                        })
                        .margin({ top: 5 })
                    Button("loadContentByName")
                        .onClick(() => {
                            try {
                                this.message = '';
                                if (this.windowArray.length == 0) {
                                    this.message += '\n窗口未创建，请创建窗口';
                                    return;
                                }
                                let w  = this.windowArray[this.nowWindow];
                            if (w.window == null) {
                                this.message += '\n' + w.name + ' 未创建';
                                return;
                            }
                                w.window.loadContentByName('WindowContent2',LocalStorage.getShared()).then(data=>{
                                    this.message += '\n' + w.name + ' loadContentByName 成功';
                                }).catch((error:BusinessError) => {
                                    this.message += "\n设置 loadContentByName 失败"
                                });
                            } catch (exception) {
                                this.message += "\n设置 loadContentByName 失败"
                            }
                        })
                        .margin({ top: 5 })

                    Button("setWindowBackgroundColor")
                        .onClick(() => {
                            this.message = '';
                            let color = '#ff0000';
                            if (this.setWindowBackgroundColorFlag == 0) {
                                color = '#ff0000';
                            } else if (this.setWindowBackgroundColorFlag == 1) {
                                color = '#00ff00';
                            } else if (this.setWindowBackgroundColorFlag == 2) {
                                color = '#0000ff';
                            }
                            this.setWindowBackgroundColorFlag++;
                            if (this.setWindowBackgroundColorFlag > 2) {
                                this.setWindowBackgroundColorFlag = 0;
                            }
                            if (this.windowArray.length == 0) {
                                this.message += '\n窗口未创建，请创建窗口';
                                return;
                            }
                            let w  = this.windowArray[this.nowWindow];
                            try {
                                w.window.setWindowBackgroundColor(color);
                                this.message += '\n' + w.name + ' setWindowBackgroundColor 成功 [' + this.setWindowBackgroundColorFlag + ']' + color;
                            } catch (exception) {
                                this.message += '\n' + w.name + ' setWindowBackgroundColor 失败 [' + this.setWindowBackgroundColorFlag + ']' + color;
                            }
                        })
                        .margin({ top: 10 })

                    Button("show window")
                        .onClick(() => {
                            this.message = '';
                            // this.message += '\nnowWindow=' + this.nowWindow;
                            // this.message += '\windowArray.length=' + this.windowArray.length;
                            if (this.windowArray.length == 0) {
                                this.message += '\n窗口未创建，请创建窗口';
                                return;
                            }
                            if (this.nowWindow >= this.windowArray.length) {
                                this.message += '\nnowWindow索引异常：' + this.nowWindow;
                                return;
                            }
                            let w  = this.windowArray[this.nowWindow];
                            if (w.window == null) {
                                this.message += '\n' + w.name + ' 未创建';
                            } else {
                                w.window.showWindow((err) => {
                                    if (err.code) {
                                        this.message += '\n' + w.name + ' show 失败 code:' + err.code;
                                        return;
                                    }
                                    w.isShowing = true;   // isShowing
                                    this.isShowing = this.getShowingCount() > 0 ? true : false;
                                    this.message += '\n' + w.name + ' show 成功';
                                });
                            }
                        })
                        .margin({ top: 10 })

                    Button("getLastWindow")
                        .onClick(() => {
                            console.info('Button getLastWindow onClick');
                            this.message = ''
                            let color = this.colorChangeFlag ? "#f8e71c" : "#7ed321";
                            this.colorChangeFlag = !this.colorChangeFlag;
                            window.getLastWindow(AppStorage.get("context"), (err, data) => {
                                console.info('call window.getLastWindow');
                                if (err.code) {
                                    this.message += '\ngetLastWindow Error code:' + err.code;
                                    console.error('Failed to get last window. Cause:' + JSON.stringify(err));
                                    return;
                                }
                                this.lastWindow = data;
                                this.lastWindow.setWindowBackgroundColor(color);
                                this.message += '\ngetLastWindow Success ';
                                console.info('Succeeded in getting last window.');
                                this.printWindowProperties(this.lastWindow)
                            });
                        })
                        .margin({ top: 10 })

                    Button("setWindowSystemBarEnable")
                        .onClick(() => {
                            // 此处以不显示导航栏、状态栏为例
                            let names:Array<'status' | 'navigation'> = [];
                            if (this.systemBarFlag == 0) {
                                names = [];
                            } else if (this.systemBarFlag == 1) {
                                names = ['status'];
                            } else if (this.systemBarFlag == 2) {
                                names = ['navigation'];
                            } else if (this.systemBarFlag == 3) {
                                names = ['status', 'navigation'];
                            }
                            this.message = '';
                            try {
                                if (this.lastWindow == null) {
                                    this.message += '\nWindow is null, please getLastWindow first';
                                    return;
                                }
                                this.message += '\nsystemBarFlag = ' + JSON.stringify(this.systemBarFlag);
                                this.message += '\nsystemBarType = ' + JSON.stringify(names);
                                this.lastWindow.setWindowSystemBarEnable(names, (err) => {
                                    if (err.code) {
                                        this.message += '\nsetWindowSystemBarEnable Error code:' + err.code
                                        return;
                                    }
                                    this.systemBarFlag = (this.systemBarFlag == 3) ? 0 : (this.systemBarFlag + 1);
                                    this.message += '\nsetWindowSystemBarEnable Success'
                                });
                            } catch (exception) {
                                this.message += '\nsetWindowSystemBarEnable catch'
                            }
                        })
                        .margin({ top: 10 })
                    
                    Button("setWindowSystemBarProperties")
                        .onClick(() => {
                            try {
                                this.message = ''

                                if (this.lastWindow == null) {
                                    this.message += '\nWindow is null, please getLastWindow first';
                                    return;
                                }
                                let SystemBarProperties: window.SystemBarProperties = {
                                    statusBarColor: '#ff00ff',
                                    navigationBarColor: '#00ff00',
                                    //以下两个属性从API Version8开始支持
                                    // statusBarContentColor: '#ffffff',
                                    // navigationBarContentColor: '#00ffff',
                                    isStatusBarLightIcon: false,
                                    isNavigationBarLightIcon: false,
                                    enableStatusBarAnimation: false,
                                    enableNavigationBarAnimation: false
                                };
                                let promise = this.lastWindow.setWindowSystemBarProperties(SystemBarProperties);
                                this.message += "\n设置 setWindowSystemBarProperties 成功"
                            } catch (exception) {
                                this.message += "设置 setWindowSystemBarProperties 失败"
                                this.message += exception
                                console.info("subwindow.setWindowSystemBarProperties: failed")
                            }
                        })
                        .margin({ top: 5 })

                    Button("setPreferredOrientation")
                        .onClick(() => {
                            this.message = '';
                            try {
                                if (this.lastWindow == null) {
                                    this.message += '\nWindow is null, please getLastWindow first';
                                    return;
                                }
                                this.message += '\preferredOrientationFlag = ' + JSON.stringify(this.preferredOrientationFlag);



                                this.lastWindow.setPreferredOrientation(this.preferredOrientationFlag, (err) => {
                                    if (err.code) {
                                        this.message += '\nsetPreferredOrientation Error code:' + err.code;
                                        return;
                                    }
                                    this.preferredOrientationFlag = (this.preferredOrientationFlag == 10) ? 0 : (this.preferredOrientationFlag + 1);
                                    this.message += '\nsetPreferredOrientation Success';
                                });
                            } catch (exception) {
                                this.message += '\nsetPreferredOrientation catch'
                            }
                        })
                        .margin({ top: 10 })

                    Button("setWindowBrightness")
                        .onClick(() => {
                            this.message = '';
                            //let brightness = 0.1;
                            try {
                                if (this.lastWindow == null) {
                                    this.message += '\nWindow is null, please getLastWindow first';
                                    return;
                                }
                                this.message += '\nbrightnessFlag = ' + JSON.stringify(this.brightnessFlag);
                                this.lastWindow.setWindowBrightness(this.brightnessFlag, (err) => {
                                    if (err.code) {
                                        this.message += '\nsetWindowBrightness Error code:' + err.code
                                        return;
                                    }
                                    this.brightnessFlag = (this.brightnessFlag >= 1.0) ? 0.1 : (this.brightnessFlag + 0.1);
                                    this.message += '\nsetWindowBrightness Success'
                                });
                            } catch (exception) {
                                this.message += '\nsetWindowBrightness catch'
                            }
                        })
                        .margin({ top: 10 })

                    Button("setWindowKeepScreenOn")
                        .onClick(() => {
                            this.message = ''
                            //let isKeepScreenOn = true;
                            try {
                                if (this.lastWindow == null) {
                                    this.message += '\nWindow is null, please getLastWindow first';
                                    return;
                                }
                                this.message += '\nisKeepScreenOnFlag = ' + JSON.stringify(this.isKeepScreenOnFlag);
                                this.lastWindow.setWindowKeepScreenOn(this.isKeepScreenOnFlag, (err) => {
                                    if (err.code) {
                                        this.message += '\nsetWindowKeepScreenOn Error code:' + err.code
                                        return;
                                    }
                                    this.isKeepScreenOnFlag = !this.isKeepScreenOnFlag;
                                    this.message += '\nsetWindowKeepScreenOn Success'
                                });
                            } catch (exception) {
                                this.message += '\nsetWindowKeepScreenOn catch'
                            }
                        })
                        .margin({ top: 10 })

                    Button("getDefaultDisplaySync")
                        .onClick(() => {
                            this.message = ''
                            let data = display.getDefaultDisplaySync();
                            this.message = 'getDefaultDisplaySync Success \n data = '+JSON.stringify(data)
                        })
                        .margin({ top: 10 })
                }
                .width('100%')
                // .height('100%')
                .justifyContent(FlexAlign.Start)
                .alignItems(HorizontalAlign.Center)
            }
            .height(this.isShowing ? '50%' : '90%')
            //.height(this.getShowingCount() > 0 ? '50%' : '90%')

            Column() {
                Row() {
                    Text("当前控制的是" + this.getNowWindowName())
                }
                .width('100%').height('20%')

                Row() {
                    Button("切换")
                        .onClick(() => {
                            this.message = '';
                            this.message += '切换前：nowWindow=' + this.nowWindow;
                            //this.nowWindow = this.nowWindow >= this.windowArray.length ? 0 : this.nowWindow + 1
                            if (this.windowArray.length == 0) {
                                this.nowWindow = -1;
                            } else {
                                this.nowWindow++;
                                if (this.nowWindow >= this.windowArray.length) {
                                    this.nowWindow = 0;
                                }
                            }
                            this.message += '切换后：nowWindow=' + this.nowWindow;
                        })
                    Button("destroy")
                        .onClick(() => {
                            this.destroyWindow();
                            // this.message = '';
                            // // this.message += '\nnowWindow=' + this.nowWindow;
                            // // this.message += '\windowArray.length=' + this.windowArray.length;
                            // if (this.windowArray.length == 0) {
                            //     this.message += '\nAll window destroyed';
                            //     return;
                            // }
                            // if (this.nowWindow >= this.windowArray.length) {
                            //     this.message += '\nnowWindow索引异常：' + this.nowWindow;
                            //     return;
                            // }
                            // let w = this.windowArray[this.nowWindow];
                            // w.window.destroyWindow((err) => {
                            //     if (err.code) {
                            //         this.message += '\nDestroy window ' + w.name + ' 错误';
                            //         console.error('Failed to destroy the window. Cause:' + JSON.stringify(err));
                            //         return;
                            //     }
                            //     this.windowArray.splice(this.windowArray.indexOf(w), 1);   // 移除
                            //     this.isShowing = this.getShowingCount() > 0 ? true : false;
                            //     // this.message += "\nDestroy window " + w.name + " 成功";
                            //     // this.message += '\n更新nowWindow，更新前：' + this.nowWindow;
                            //     if (this.windowArray.length == 0) {
                            //         this.nowWindow = -1;
                            //     } else {
                            //         if (this.nowWindow >= this.windowArray.length) {
                            //             this.nowWindow = 0;
                            //         } else {
                            //             this.nowWindow = this.nowWindow;
                            //         }
                            //     }
                            //     // this.message += '\n更新nowWindow，更新后：' + this.nowWindow;
                            //     console.info('Succeeded in destroying the window.');
                            // });
                        })
                    Button("destroy all")
                        .onClick(() => {
                            this.destroyAllWindow();
                            // this.message = '';
                            // // this.message += '\nnowWindow=' + this.nowWindow;
                            // // this.message += '\windowArray.length=' + this.windowArray.length;
                            // if (this.windowArray.length == 0) {
                            //     this.message += '\nAll window destroyed';
                            //     return;
                            // }
                            // if (this.nowWindow >= this.windowArray.length) {
                            //     this.message += '\nnowWindow索引异常：' + this.nowWindow;
                            //     return;
                            // }
                            // // let flag = true;
                            // while(this.windowArray.length > 0)
                            // {
                            //     // if (flag) {
                            //     //     flag = false;
                            //     //     this.message += '\nwindowArray.length=' + this.windowArray.length;
                            //         let w = (this.windowArray.splice(0, 1))[0];    // splice返回的是array，所以要加[0]
                            //         w.window.destroyWindow((err) => {
                            //             if (err.code) {
                            //                 this.message += '\nDestroy Window ' + w.name + ' 错误';
                            //                 console.error('Failed to destroy the window. Cause:' + JSON.stringify(err));
                            //                 return;
                            //             }
                            //             this.isShowing = this.getShowingCount() > 0 ? true : false;
                            //             this.message += '\nDestroy Window ' + w.name + ' 成功';
                            //             // this.message += '\n更新nowWindow，更新前：' + this.nowWindow;
                            //             // if (this.windowArray.length == 0) {
                            //             //     this.nowWindow = -1;
                            //             // } else {
                            //             //     if (this.nowWindow >= this.windowArray.length) {
                            //             //         this.nowWindow = 0;
                            //             //     }
                            //             // }
                            //             // this.message += '\n更新nowWindow，更新后：' + this.nowWindow;
                            //             console.info('Succeeded in destroying the window.');
                            //             // flag = true;
                            //         });
                            //     // }
                            // }
                            // this.nowWindow = -1;
                        })
                }
                .width('100%').height('25%')
                .margin({ top: 5 })

                Row() {
                    Button("上")
                        .onClick(() => {
                            this.moveNowWindow(0)
                        })
                    Button("下")
                        .onClick(() => {
                            this.moveNowWindow(1)
                        })
                    Button("左")
                        .onClick(() => {
                            this.moveNowWindow(2)
                        })
                    Button("右")
                        .onClick(() => {
                            this.moveNowWindow(3)
                        })
                    Button("变大")
                        .onClick(() => {
                            this.resizeNowWindow(true)
                        })
                    Button("变小")
                        .onClick(() => {
                            this.resizeNowWindow(false)
                        })
                }
                .width('100%').height('25%')
                .margin({ top: 5 })

                Row() {
                    Button("isWindowShowing")
                        .onClick(() => {
                            try {
                                this.message = ''
                                let window = this.getNowWindow()
                                if (window == undefined) {
                                    return
                                }
                                let data = window.isWindowShowing();
                                this.message += "\n window " + this.getNowWindowName() + " isShowing " + data
                            } catch (exception) {
                                this.message += "\n window " + this.getNowWindowName() + " isShowing catch"
                            }
                        })
                }
                .width('100%').height('25%')
                .margin({ top: 5 })
            }
            .alignItems(HorizontalAlign.Center)
            .height(this.isShowing ? '40%' : '0%')

            Column() {
                Row() {
                    Button("WindowStage")
                        .onClick(() => {
                            this.destroyAllWindow();
                            router.pushUrl({ url: "pages/WindowStage" })
                        })

                    Button('主页')
                        .onClick(() => {
//                            this.destroyAllWindow();
                            router.pushUrl({ url: 'pages/EnterPage' })
                        })
                }.margin({ top: 5 })
            }
            .alignItems(HorizontalAlign.Center)
            .height('10%')
        }.height('100%')
    }

    private destroyWindow() {
        this.message = '';
        // this.message += '\nnowWindow=' + this.nowWindow;
        // this.message += '\windowArray.length=' + this.windowArray.length;
        if (this.windowArray.length == 0) {
            this.message += '\nAll window destroyed';
            return;
        }
        if (this.nowWindow >= this.windowArray.length) {
            this.message += '\nnowWindow索引异常：' + this.nowWindow;
            return;
        }
        let w = this.windowArray[this.nowWindow];
        w.window.destroyWindow((err) => {
            if (err.code) {
                this.message += '\nDestroy window ' + w.name + ' 错误';
                console.error('Failed to destroy the window. Cause:' + JSON.stringify(err));
                return;
            }
            this.windowArray.splice(this.windowArray.indexOf(w), 1);   // 移除
            this.isShowing = this.getShowingCount() > 0 ? true : false;
            // this.message += "\nDestroy window " + w.name + " 成功";
            // this.message += '\n更新nowWindow，更新前：' + this.nowWindow;
            if (this.windowArray.length == 0) {
                this.nowWindow = -1;
            } else {
                if (this.nowWindow >= this.windowArray.length) {
                    this.nowWindow = 0;
                } else {
                    this.nowWindow = this.nowWindow;
                }
            }
            // this.message += '\n更新nowWindow，更新后：' + this.nowWindow;
            console.info('Succeeded in destroying the window.');
        });
    }

    private destroyAllWindow() {
        this.message = '';
        // this.message += '\nnowWindow=' + this.nowWindow;
        // this.message += '\windowArray.length=' + this.windowArray.length;
        if (this.windowArray.length == 0) {
            this.message += '\nAll window destroyed';
            return;
        }
        if (this.nowWindow >= this.windowArray.length) {
            this.message += '\nnowWindow索引异常：' + this.nowWindow;
            return;
        }
        // let flag = true;
        while(this.windowArray.length > 0)
        {
            // if (flag) {
            //     flag = false;
            //     this.message += '\nwindowArray.length=' + this.windowArray.length;
            let w = (this.windowArray.splice(0, 1))[0];    // splice返回的是array，所以要加[0]
            w.window.destroyWindow((err) => {
                if (err.code) {
                    this.message += '\nDestroy Window ' + w.name + ' 错误';
                    console.error('Failed to destroy the window. Cause:' + JSON.stringify(err));
                    return;
                }
                this.isShowing = this.getShowingCount() > 0 ? true : false;
                this.message += '\nDestroy Window ' + w.name + ' 成功';
                // this.message += '\n更新nowWindow，更新前：' + this.nowWindow;
                // if (this.windowArray.length == 0) {
                //     this.nowWindow = -1;
                // } else {
                //     if (this.nowWindow >= this.windowArray.length) {
                //         this.nowWindow = 0;
                //     }
                // }
                // this.message += '\n更新nowWindow，更新后：' + this.nowWindow;
                console.info('Succeeded in destroying the window.');
                // flag = true;
            });
            // }
        }
        this.nowWindow = -1;
    }

    private getNowWindowName() {
        if (this.nowWindow >= 0) {
            if (this.nowWindow >= this.windowArray.length) {
                return "null"
            } else {
                return this.windowArray[this.nowWindow].name;
            }
        } else {
            return "null";
        }
        // if (this.windowArray.length == 0) {
        //     this.nowWindow = -1;
        //     return "null";
        // }
        // if (this.nowWindow >= this.windowArray.length) {
        //     this.nowWindow = 0;
        // }
        // return this.windowArray[this.nowWindow][0];
    }
    // private getNowWindowName() {
    //     switch (this.nowWindow) {
    //         case 0:
    //             return this.windowName1
    //         case 1:
    //             return this.windowName2
    //         case 2:
    //             return this.windowName3
    //     }
    // }

    private getNowWindow() {
        if (this.nowWindow >= 0) {
            if (this.nowWindow >= this.windowArray.length) {
                return null;
            } else {
                return this.windowArray[this.nowWindow].window;
            }
        } else {
            return null;
        }
    }
    // private getNowWindow() {
    //     switch (this.nowWindow) {
    //         case 0:
    //             return this.window1
    //         case 1:
    //             return this.window2
    //         case 2:
    //             return this.window3
    //         default:
    //             return null;
    //     }
    // }

    private getShowingCount() {
        let count = 0;
        for (let w of this.windowArray) {
            if (w.isShowing) {
                count++;
            }
        }
        return count;
    }

    private getWindow(nowWindow:number) {
        if (this.windowArray.length == 0) {
            return null;
        }
        if (nowWindow >= this.windowArray.length) {
            return null;
        }
        return this.windowArray[nowWindow].window;
    }
    // private getWindow(nowWindow) {
    //     switch (nowWindow) {
    //         case 0:
    //             return this.window1
    //         case 1:
    //             return this.window2
    //         case 2:
    //             return this.window3
    //         default:
    //             return null;
    //     }
    // }

    private resizeNowWindow(isAdd:boolean) {
        let window = this.getNowWindow()
        if (window == undefined) {
            return
        }
        let rect = window.getWindowProperties().windowRect
        let msg = 'Before Resize: ' + JSON.stringify(rect);
        try {
            window.resize(isAdd ? rect.width + 80 : rect.width - 80, isAdd ? rect.height + 50 : rect.height - 50, (err) => {
                if (err.code) {
                    console.error('Failed to change the window size. Cause:' + JSON.stringify(err));
                    return;
                }
                if (window == undefined) {
                    return
                }
                rect = window.getWindowProperties().windowRect
                msg += '\nAfter Resize: ' + JSON.stringify(rect);
                this.message = msg;
                console.info('Succeeded in changing the window size.');
            });
        } catch (error) {
            if (error.code) {
                this.message += "resize failed, " + JSON.stringify(error);
                // console.error('Failed to change the window size. Cause:' + JSON.stringify(err));
                return;
            }
        }

    }

    private resizeWindow(window:window.Window, widthSize:number, heightSize:number) {
        let rect = window.getWindowProperties().windowRect
        //let msg = 'Before Resize: ' + JSON.stringify(rect);
        console.error('Call resize: width=' + JSON.stringify(rect.width + widthSize) + ', height=' + JSON.stringify(rect.height + heightSize));
        window.resize(rect.width + widthSize, rect.height + heightSize, (err) => {
            if (err.code) {
                console.error('Failed to change the window size. Cause:' + JSON.stringify(err));
                return;
            }
            rect = window.getWindowProperties().windowRect
        //    msg += '\nAfter Resize: ' + JSON.stringify(rect);
        //    this.message = msg;
            console.info('Succeeded in changing the window size.');
        });
    }

    private moveNowWindow(type:number) {
        let window = this.getNowWindow()
        if (window == undefined) {
            return
        }
        let rect = window.getWindowProperties().windowRect
        let msg = 'Before Move: ' + JSON.stringify(rect);
        switch (type) {
            case 0:
                rect.top -= 20
                break
            case 1:
                rect.top += 20
                break
            case 2:
                rect.left -= 20
                break
            case 3:
                rect.left += 20
                break
        }
        if (window == undefined) {
            return
        }
        window.moveWindowTo(rect.left, rect.top, (err) => {
            if (err.code) {
                console.error('Failed to move the window. Cause:' + JSON.stringify(err));
                return;
            }
            if (window == undefined) {
                return
            }
            rect = window.getWindowProperties().windowRect
            msg += '\nAfter Move: ' + JSON.stringify(rect);
            this.message = msg;
            console.info('Succeeded in moving the window.');
        });
    }

    private moveWindow(window:window.Window, x:number, y:number) {
        let rect = window.getWindowProperties().windowRect
        //let msg = 'Before Move: ' + JSON.stringify(rect);
        window.moveWindowTo(x, y, (err) => {
            if (err.code) {
                console.error('Failed to move the window. Cause:' + JSON.stringify(err));
                return;
            }
            rect = window.getWindowProperties().windowRect
        //    msg += '\nAfter Move: ' + JSON.stringify(rect);
        //    this.message = msg;
            console.info('Succeeded in moving the window.');
        });
    }

    private printWindowProperties(window:window.Window) {
        try {
            let properties = window.getWindowProperties();
            this.message += "\nwindowId:" + properties + "windowRect:" + JSON.stringify(properties.windowRect) + ",windowType:" +  ",brightness:" + properties.brightness + ",isKeepScreenOn:" + properties.isKeepScreenOn
        } catch (exception) {
            this.message += "\n打印窗口属性失败"
        }
    }
}