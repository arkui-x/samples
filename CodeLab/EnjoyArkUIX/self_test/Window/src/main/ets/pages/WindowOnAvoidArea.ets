import window from '@ohos.window';
import { TitleBar } from './TitleBar';
import router from '@ohos.router';
import display from '@ohos.display';
import { WindowType } from '../util/WindowConst';
import { BusinessError, Callback } from '@kit.BasicServicesKit';
import { Rect } from '@ohos.application.AccessibilityExtensionAbility';

// import Configuration from '@system.configuration';
// import colorSpaceManager from '@ohos.graphics.colorSpaceManager';

@Entry
@Component
struct Window {
    private windowArray:window.Window[] = [];
    private windowId = 0;
    @State message: string = "";
    @State subWindowRect: window.Rect = {top:0,left:0,width:100,height:100};
    @State isShowing: boolean = false;
    @State nowWindow: number = -1;
    @State topPadding: number = 0;
    private systemBarFlag = 0;
    private wm?: window.Window = undefined;
    private subWindow?: window.Window= undefined;
    private subWindow2?: window.Window= undefined
    private windowStage?: window.WindowStage = AppStorage.get("windowStage");
    private callback1:Callback<window.AvoidAreaOptions> = (res: window.AvoidAreaOptions) => {
        this.message += " \n 触发  avoidAreaChange callback1 " + this.getAvoidArea(res)
    }
    private callback2:Callback<window.AvoidAreaOptions> = (res: window.AvoidAreaOptions) => {
        this.message += " \n 触发  avoidAreaChange callback2 " + this.getAvoidArea(res)
    }
    getAvoidArea(avoidArea:window.AvoidAreaOptions):string {
       let type = ["TYPE_SYSTEM","TYPE_CUTOUT","TYPE_SYSTEM_GESTURE","TYPE_KEYBOARD","TYPE_NAVIGATION_INDICATOR"];
       return type[avoidArea.type] + JSON.stringify(avoidArea.area);
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
                    TitleBar({ title: $r('app.string.WindowAvoidArea_title') })
                        .width('100%')
                    Text(this.message).margin({ bottom: 10 }).width('100%').backgroundColor(0xFF0000FF)
                    Text("WindowStage 相关接口").margin({ top: 20 })
                    Button("AvoidAreaChanged.on 1")
                        .onClick(() => {
                            if (this.windowStage == undefined) {
                                return
                            }
                            this.wm = this.windowStage.getMainWindowSync();
                            if (this.wm == undefined) {
                                return
                            }
                            try {
                                // this.wm.on('windowSizeChange', (res: window.AvoidAreaOptions) => {})
                                this.wm.on('avoidAreaChange', this.callback1);
                                this.message += "\n设置 avoidAreaChange on 成功"
                            } catch (exception) {
                                this.message = "设置 avoidAreaChange on 失败    "
                                this.message = exception
                                console.info("avoidAreaChange.on: failed")
                            }
                        })
                        .margin({ top: 5 })

                    Button("avoidAreaChange.on 2")
                        .onClick(() => {
                            if (this.windowStage == undefined) {
                                return
                            }
                            this.wm = this.windowStage.getMainWindowSync();
                            if (this.wm == undefined) {
                                return
                            }
                            try {
                                this.wm.on('avoidAreaChange', this.callback2);
                                this.message += "\n设置 avoidAreaChange on 成功"
                            } catch (exception) {
                                this.message += "设置 avoidAreaChange on 失败    "
                                this.message += exception
                                console.info("avoidAreaChange.on: failed")
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
                                            this.subWindow.resize(this.subWindowRect.width, this.subWindowRect.height, (err) => {
                                            });
                                            this.subWindow.on('avoidAreaChange', (data) => {
                                                this.message += " \n 触发 subwindow on 回调监听 " + this.getAvoidArea(data)
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
                                    this.subWindow.off('avoidAreaChange',this.callback1);

                                    this.subWindow.on('avoidAreaChange', (data) => {
                                        this.message += " \n 触发subwindow on 回调监听 " + this.getAvoidArea(data)
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


                                // this.wm.setWindowSystemBarEnable(names, (err) => {
                                //     if (err.code) {
                                //         this.message += '\nsetWindowSystemBarEnable Error code:' + err.code
                                //         return;
                                //     }
                                //     this.systemBarFlag = (this.systemBarFlag == 3) ? 0 : (this.systemBarFlag + 1);
                                //     this.message += '\nsetWindowSystemBarEnable Success'
                                // });
                            } catch (exception) {
                                this.message += '\nsetWindowSystemBarEnable catch'
                            }
                        })
                        .margin({ top: 10 })
                    TextInput({ placeholder: '请输入子窗口坐标例如:0,0,100,200' }).margin({ top: 20 })
                        .onSubmit((EnterKeyType,event) => {
                               let res = event.text.split(",");
                               let i = 0;
                               for (let item  of res) {
                                   console.info("number=" + item);
                                   let number = Number(item)
                                   console.info("number=" + number + "index=" +i);
                                   if (i ==0) {
                                       this.subWindowRect.left = number;
                                   } else if (i == 1) {
                                       this.subWindowRect.top = number;
                                   } else if (i == 2) {
                                       this.subWindowRect.width = number;
                                   } else if (i == 3) {
                                       this.subWindowRect.height = number;
                                   }
                                   i++;
                               }
                            console.info(EnterKeyType + '输入法回车键的类型值');

                        });
                    Button("setWindowRect").onClick(() => {
                        if (this.subWindow == undefined) {
                            return
                        }
                        this.subWindow.moveWindowTo(this.subWindowRect.left, this.subWindowRect.top)
                        this.subWindow.resize(this.subWindowRect.width, this.subWindowRect.height)
                    })

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

                    Button("avoidAreaChange.off")
                        .onClick(() => {
                            try {
                                this.message = "";
                                if (this.wm == undefined) {
                                    return
                                }
                                this.wm.off('avoidAreaChange');
                                this.message += "\n设置 avoidAreaChange off 成功"
                            } catch (exception) {
                                this.message += "\n设置 avoidAreaChange off 失败"
                                console.info("avoidAreaChange.off: failed")
                            }
                        })
                        .margin({ top: 5 })
                    Button("avoidAreaChange.off1")
                        .onClick(() => {
                            try {
                                this.message = "";
                                if (this.wm == undefined) {
                                    return
                                }
                                this.wm.off('avoidAreaChange',this.callback1);
                                this.message += "\n设置 avoidAreaChange off 成功"
                            } catch (exception) {
                                this.message += "\n设置 avoidAreaChange off 失败"
                                console.info("avoidAreaChange.off: failed")
                            }
                        })
                        .margin({ top: 5 })
                    Button("avoidAreaChange.off2")
                        .onClick(() => {
                            try {
                                this.message = "";
                                if (this.wm == undefined) {
                                    return
                                }
                                this.wm.off('avoidAreaChange',this.callback2);
                                this.message += "\n设置 avoidAreaChange off 成功"
                            } catch (exception) {
                                this.message += "\n设置 avoidAreaChange off 失败"
                                console.info("avoidAreaChange.off: failed")
                            }
                        })
                        .margin({ top: 5 })
                    Button("subavoidAreaChange1.off")
                        .onClick(() => {
                            try {
                                this.message = "";
                                if (this.subWindow == undefined) {
                                    return
                                }
                                this.subWindow.off('avoidAreaChange');
                                this.message += "\n设置 avoidAreaChange off 成功"
                            } catch (exception) {
                                this.message += "\n设置 avoidAreaChange off 失败"
                                console.info("avoidAreaChange.off: failed")
                            }
                        })
                        .margin({ top: 5 })
                }
                .width('100%')
                // .height('100%')
                .justifyContent(FlexAlign.Start)
                .alignItems(HorizontalAlign.Center)
            }.padding({top:px2vp(this.topPadding)})
            .height(this.isShowing ? '50%' : '90%')

            //.height(this.getShowingCount() > 0 ? '50%' : '90%')

        }
    }
}