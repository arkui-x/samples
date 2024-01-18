interface Index_Params {
    botSelect?: number;
    topSelect?: number;
    topController?: TabsController;
    botController?: TabsController;
    showLogIn?: boolean;
    logInHeight?: string;
}
import { NewHomePage } from "@bundle:com.example.jinritoutiao/entry/ets/pages/NewHomePage";
import { NavTop } from "@bundle:com.example.jinritoutiao/entry/ets/pages/util/Mock";
import type { BotItem, TopItem } from "@bundle:com.example.jinritoutiao/entry/ets/pages/util/Mock";
import { LogInPage } from "@bundle:com.example.jinritoutiao/entry/ets/pages/LogInPage";
import { TopSearch } from "@bundle:com.example.jinritoutiao/entry/ets/pages/components/TopSearch";
import { VideoPage } from "@bundle:com.example.jinritoutiao/entry/ets/pages/components/VideoPage";
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__botSelect = new ObservedPropertySimplePU(0, this, "botSelect");
        this.__topSelect = new ObservedPropertySimplePU(1, this, "topSelect");
        this.topController = new TabsController();
        this.botController = new TabsController();
        this.__showLogIn = new ObservedPropertySimplePU(false, this, "showLogIn");
        this.__logInHeight = new ObservedPropertySimplePU('0', this, "logInHeight");
        this.setInitiallyProvidedValue(params);
    }
    setInitiallyProvidedValue(params: Index_Params) {
        if (params.botSelect !== undefined) {
            this.botSelect = params.botSelect;
        }
        if (params.topSelect !== undefined) {
            this.topSelect = params.topSelect;
        }
        if (params.topController !== undefined) {
            this.topController = params.topController;
        }
        if (params.botController !== undefined) {
            this.botController = params.botController;
        }
        if (params.showLogIn !== undefined) {
            this.showLogIn = params.showLogIn;
        }
        if (params.logInHeight !== undefined) {
            this.logInHeight = params.logInHeight;
        }
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__botSelect.purgeDependencyOnElmtId(rmElmtId);
        this.__topSelect.purgeDependencyOnElmtId(rmElmtId);
        this.__showLogIn.purgeDependencyOnElmtId(rmElmtId);
        this.__logInHeight.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__botSelect.aboutToBeDeleted();
        this.__topSelect.aboutToBeDeleted();
        this.__showLogIn.aboutToBeDeleted();
        this.__logInHeight.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __botSelect: ObservedPropertySimplePU<number>;
    get botSelect() {
        return this.__botSelect.get();
    }
    set botSelect(newValue: number) {
        this.__botSelect.set(newValue);
    }
    private __topSelect: ObservedPropertySimplePU<number>;
    get topSelect() {
        return this.__topSelect.get();
    }
    set topSelect(newValue: number) {
        this.__topSelect.set(newValue);
    }
    private topController: TabsController;
    private botController: TabsController;
    private __showLogIn: ObservedPropertySimplePU<boolean>;
    get showLogIn() {
        return this.__showLogIn.get();
    }
    set showLogIn(newValue: boolean) {
        this.__showLogIn.set(newValue);
    }
    private __logInHeight: ObservedPropertySimplePU<string>;
    get logInHeight() {
        return this.__logInHeight.get();
    }
    set logInHeight(newValue: string) {
        this.__logInHeight.set(newValue);
    }
    TabBotBuilder(item: BotItem, index: number, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.border({ width: { top: 1 }, color: '#999' });
            Column.onClick(() => {
                if (index !== 3) {
                    this.botSelect = index;
                }
                else {
                    Context.animateTo({
                        duration: 200,
                        curve: Curve.Linear
                    }, () => {
                        this.showLogIn = true;
                        this.logInHeight = '100%';
                    });
                }
            });
            Column.justifyContent(FlexAlign.Center);
            Column.width('100%');
            Column.height('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create(this.botSelect === index ? item.icon_selected : item.icon_normal);
            Image.width(22);
            Image.height(22);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(item.text);
            Text.fontSize(12);
            Text.fontColor(this.botSelect === index ? '#f04142' : '#000');
            Text.margin({ top: 4 });
        }, Text);
        Text.pop();
        Column.pop();
    }
    TabTopBuilder(item: TopItem, index: number, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width(50);
            Column.height(30);
            Column.onClick(() => {
                this.topSelect = index;
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(item.title);
            Text.fontSize(16);
            Text.fontColor(this.topSelect === index ? '#f04142' : '#000');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Divider.create();
            Divider.strokeWidth(2);
            Divider.color('#f04142');
            Divider.width(20);
            Divider.opacity(this.topSelect === index ? 1 : 0);
            Divider.margin({ top: 3 });
        }, Divider);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Divider.create();
            Divider.strokeWidth(1);
            Divider.color(Color.Grey);
            Divider.width('100%');
            Divider.opacity(0.3);
        }, Divider);
        Column.pop();
    }
    ShopLogIn(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.padding(20);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777223, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
            Image.height(50);
            Image.width(50);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('您还没有登录头条账号');
            Text.fontWeight(FontWeight.Bold);
            Text.margin({ top: 20, bottom: 15 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('登录头条账号进入商城， 可领取更多权益');
            Text.fontColor('#999');
            Text.fontSize(12);
            Text.margin({ bottom: 80 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center });
            Flex.width('100%');
            Flex.height(36);
            Flex.backgroundColor('#f04142');
            Flex.onClick(() => {
                Context.animateTo({
                    duration: 200,
                    curve: Curve.Linear
                }, () => {
                    this.showLogIn = true;
                    this.logInHeight = '100%';
                });
            });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('立即登录');
            Text.fontColor(Color.White);
            Text.fontSize(14);
        }, Text);
        Text.pop();
        Flex.pop();
        Column.pop();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create({ alignContent: Alignment.Bottom });
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
            Column.padding({ bottom: 20 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Tabs.create({ barPosition: BarPosition.End, controller: this.botController, index: this.botSelect });
            Tabs.scrollable(false);
            Tabs.onChange((index: number) => {
                this.botSelect = index;
            });
        }, Tabs);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TabContent.create(() => {
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                }, Column);
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let paramsLambda = () => {
                                return {};
                            };
                            ViewPU.create(new TopSearch(this, {}, undefined, elmtId, paramsLambda, { page: "entry/src/main/ets/pages/Index.ets", line: 126 }));
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {});
                        }
                    }, null);
                }
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Tabs.create({ barPosition: BarPosition.Start, controller: this.topController, index: this.topSelect, });
                    Tabs.barMode(BarMode.Scrollable);
                    Tabs.onChange((index: number) => {
                        this.topSelect = index;
                    });
                }, Tabs);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    TabContent.create(() => {
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Column.create();
                        }, Column);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Text.create('关注感兴趣的人和事');
                            Text.fontSize(15);
                            Text.fontColor('#f04142');
                        }, Text);
                        Text.pop();
                        Column.pop();
                    });
                    TabContent.tabBar({ builder: () => {
                            this.TabTopBuilder.call(this, {
                                title: '关注',
                                content: '关注内容'
                            }, 0);
                        } });
                }, TabContent);
                TabContent.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    ForEach.create();
                    const forEachItemGenFunction = (_item, i: number) => {
                        const t = _item;
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            TabContent.create(() => {
                                {
                                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                                        if (isInitialRender) {
                                            let paramsLambda = () => {
                                                return {};
                                            };
                                            ViewPU.create(new NewHomePage(this, {}, undefined, elmtId, paramsLambda, { page: "entry/src/main/ets/pages/Index.ets", line: 141 }));
                                        }
                                        else {
                                            this.updateStateVarsOfChildByElmtId(elmtId, {});
                                        }
                                    }, null);
                                }
                            });
                            TabContent.tabBar({ builder: () => {
                                    this.TabTopBuilder.call(this, t, i + 1);
                                } });
                        }, TabContent);
                        TabContent.pop();
                    };
                    this.forEachUpdateFunction(elmtId, NavTop, forEachItemGenFunction, (t: TopItem, i: number) => i.toString(), true, true);
                }, ForEach);
                ForEach.pop();
                Tabs.pop();
                Column.pop();
            });
            TabContent.tabBar({ builder: () => {
                    this.TabBotBuilder.call(this, {
                        icon_normal: { "id": 16777255, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" },
                        icon_selected: { "id": 16777256, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" },
                        text: '首页',
                    }, 0);
                } });
        }, TabContent);
        TabContent.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TabContent.create(() => {
                {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        if (isInitialRender) {
                            let paramsLambda = () => {
                                return {};
                            };
                            ViewPU.create(new VideoPage(this, {}, undefined, elmtId, paramsLambda, { page: "entry/src/main/ets/pages/Index.ets", line: 158 }));
                        }
                        else {
                            this.updateStateVarsOfChildByElmtId(elmtId, {});
                        }
                    }, null);
                }
            });
            TabContent.tabBar({ builder: () => {
                    this.TabBotBuilder.call(this, {
                        icon_normal: { "id": 16777252, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" },
                        icon_selected: { "id": 16777253, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" },
                        text: '视频',
                    }, 1);
                } });
        }, TabContent);
        TabContent.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TabContent.create(() => {
                this.ShopLogIn.bind(this)();
            });
            TabContent.tabBar({ builder: () => {
                    this.TabBotBuilder.call(this, {
                        icon_normal: { "id": 16777244, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" },
                        icon_selected: { "id": 16777245, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" },
                        text: '商城',
                    }, 2);
                } });
        }, TabContent);
        TabContent.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TabContent.create();
            TabContent.tabBar({ builder: () => {
                    this.TabBotBuilder.call(this, {
                        icon_normal: { "id": 16777248, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" },
                        icon_selected: { "id": 16777249, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" },
                        text: '未登录',
                    }, 3);
                } });
        }, TabContent);
        TabContent.pop();
        Tabs.pop();
        Column.pop();
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let paramsLambda = () => {
                        return {
                            showLogIn: this.showLogIn,
                            logInHeight: this.logInHeight
                        };
                    };
                    ViewPU.create(new LogInPage(this, { showLogIn: this.__showLogIn, logInHeight: this.__logInHeight }, undefined, elmtId, paramsLambda, { page: "entry/src/main/ets/pages/Index.ets", line: 193 }));
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {});
                }
            }, null);
        }
        Stack.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
ViewStackProcessor.StartGetAccessRecordingFor(ViewStackProcessor.AllocateNewElmetIdForNextComponent());
loadDocument(new Index(undefined, {}));
ViewStackProcessor.StopGetAccessRecording();
