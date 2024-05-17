if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface PlatformView5_Params {
    surfaceId?: string;
    xComponentContext?: Record<string, () => void>;
    fontColor?: string;
    changeValue?: string;
    submitValue?: string;
    selectedFontColor?: string;
    currentIndex?: number;
    controller?: SearchController;
    Tabcontroller?: TabsController;
    xComponentController?: XComponentController;
    xComponentController2?: XComponentController;
}
class PlatformView5 extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.surfaceId = '';
        this.xComponentContext = {};
        this.__fontColor = new ObservedPropertySimplePU('#182431', this, "fontColor");
        this.__changeValue = new ObservedPropertySimplePU('', this, "changeValue");
        this.__submitValue = new ObservedPropertySimplePU('', this, "submitValue");
        this.__selectedFontColor = new ObservedPropertySimplePU('#007DFF', this, "selectedFontColor");
        this.__currentIndex = new ObservedPropertySimplePU(0, this, "currentIndex");
        this.controller = new SearchController();
        this.Tabcontroller = new TabsController();
        this.xComponentController = new XComponentController();
        this.xComponentController2 = new XComponentController();
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: PlatformView5_Params) {
        if (params.surfaceId !== undefined) {
            this.surfaceId = params.surfaceId;
        }
        if (params.xComponentContext !== undefined) {
            this.xComponentContext = params.xComponentContext;
        }
        if (params.fontColor !== undefined) {
            this.fontColor = params.fontColor;
        }
        if (params.changeValue !== undefined) {
            this.changeValue = params.changeValue;
        }
        if (params.submitValue !== undefined) {
            this.submitValue = params.submitValue;
        }
        if (params.selectedFontColor !== undefined) {
            this.selectedFontColor = params.selectedFontColor;
        }
        if (params.currentIndex !== undefined) {
            this.currentIndex = params.currentIndex;
        }
        if (params.controller !== undefined) {
            this.controller = params.controller;
        }
        if (params.Tabcontroller !== undefined) {
            this.Tabcontroller = params.Tabcontroller;
        }
        if (params.xComponentController !== undefined) {
            this.xComponentController = params.xComponentController;
        }
        if (params.xComponentController2 !== undefined) {
            this.xComponentController2 = params.xComponentController2;
        }
    }
    updateStateVars(params: PlatformView5_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__fontColor.purgeDependencyOnElmtId(rmElmtId);
        this.__changeValue.purgeDependencyOnElmtId(rmElmtId);
        this.__submitValue.purgeDependencyOnElmtId(rmElmtId);
        this.__selectedFontColor.purgeDependencyOnElmtId(rmElmtId);
        this.__currentIndex.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__fontColor.aboutToBeDeleted();
        this.__changeValue.aboutToBeDeleted();
        this.__submitValue.aboutToBeDeleted();
        this.__selectedFontColor.aboutToBeDeleted();
        this.__currentIndex.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private surfaceId: string;
    private xComponentContext: Record<string, () => void>;
    private __fontColor: ObservedPropertySimplePU<string>;
    get fontColor() {
        return this.__fontColor.get();
    }
    set fontColor(newValue: string) {
        this.__fontColor.set(newValue);
    }
    private __changeValue: ObservedPropertySimplePU<string>;
    get changeValue() {
        return this.__changeValue.get();
    }
    set changeValue(newValue: string) {
        this.__changeValue.set(newValue);
    }
    private __submitValue: ObservedPropertySimplePU<string>;
    get submitValue() {
        return this.__submitValue.get();
    }
    set submitValue(newValue: string) {
        this.__submitValue.set(newValue);
    }
    private __selectedFontColor: ObservedPropertySimplePU<string>;
    get selectedFontColor() {
        return this.__selectedFontColor.get();
    }
    set selectedFontColor(newValue: string) {
        this.__selectedFontColor.set(newValue);
    }
    private __currentIndex: ObservedPropertySimplePU<number>;
    get currentIndex() {
        return this.__currentIndex.get();
    }
    set currentIndex(newValue: number) {
        this.__currentIndex.set(newValue);
    }
    private controller: SearchController;
    private Tabcontroller: TabsController;
    private xComponentController: XComponentController;
    private xComponentController2: XComponentController;
    tabBuilder(index: number, name: string, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("pages/platform_view/PlatformView5.ets(36:5)");
            Column.width('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(name);
            Text.debugLine("pages/platform_view/PlatformView5.ets(37:7)");
            Text.fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor);
            Text.fontSize(16);
            Text.fontWeight(this.currentIndex === index ? 500 : 400);
            Text.lineHeight(22);
            Text.margin({ top: 17, bottom: 7 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Divider.create();
            Divider.debugLine("pages/platform_view/PlatformView5.ets(43:7)");
            Divider.strokeWidth(2);
            Divider.color('#007DFF');
            Divider.opacity(this.currentIndex === index ? 1 : 0);
        }, Divider);
        Column.pop();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("pages/platform_view/PlatformView5.ets(51:5)");
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Navigator.create({ target: 'pages/Index', type: NavigationType.Back });
            Navigator.debugLine("pages/platform_view/PlatformView5.ets(52:7)");
        }, Navigator);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('back');
            Button.debugLine("pages/platform_view/PlatformView5.ets(53:9)");
            Button.fontSize(15);
            Button.margin(10);
        }, Button);
        Button.pop();
        Navigator.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("pages/platform_view/PlatformView5.ets(55:7)");
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Tabs.create({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.Tabcontroller });
            Tabs.debugLine("pages/platform_view/PlatformView5.ets(56:9)");
            Tabs.vertical(false);
            Tabs.animationDuration(400);
            Tabs.onChange((index: number) => {
                this.currentIndex = index;
            });
            Tabs.width('100%');
            Tabs.height('100%');
            Tabs.margin({ top: 52 });
            Tabs.backgroundColor('#F1F3F5');
        }, Tabs);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TabContent.create(() => {
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    XComponent.create({
                        id: 'PlatformViewTest1',
                        type: XComponentType.PLATFORM_VIEW,
                    }, "com.example.mapapp/entry");
                    XComponent.debugLine("pages/platform_view/PlatformView5.ets(58:13)");
                    XComponent.width('100%');
                    XComponent.height('50%');
                    XComponent.backgroundColor(Color.Gray);
                }, XComponent);
            });
            TabContent.tabBar({ builder: () => {
                    this.tabBuilder.call(this, 0, 'platformView1');
                } });
            TabContent.debugLine("pages/platform_view/PlatformView5.ets(57:11)");
        }, TabContent);
        TabContent.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TabContent.create(() => {
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    XComponent.create({
                        id: 'PlatformViewTest2',
                        type: XComponentType.PLATFORM_VIEW,
                    }, "com.example.mapapp/entry");
                    XComponent.debugLine("pages/platform_view/PlatformView5.ets(69:13)");
                    XComponent.width('100%');
                    XComponent.height('50%');
                    XComponent.backgroundColor(Color.Gray);
                }, XComponent);
            });
            TabContent.tabBar({ builder: () => {
                    this.tabBuilder.call(this, 1, 'platformView2');
                } });
            TabContent.debugLine("pages/platform_view/PlatformView5.ets(68:11)");
        }, TabContent);
        TabContent.pop();
        Tabs.pop();
        Column.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
ViewStackProcessor.StartGetAccessRecordingFor(ViewStackProcessor.AllocateNewElmetIdForNextComponent());
loadDocument(new PlatformView5(undefined, {}));
ViewStackProcessor.StopGetAccessRecording();
