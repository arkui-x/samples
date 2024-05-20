if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface PlatformView2_Params {
    surfaceId?: string;
    xComponentContext?: Record<string, () => void>;
    changeValue?: string;
    submitValue?: string;
    controller?: SearchController;
}
class PlatformView2 extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.surfaceId = '';
        this.xComponentContext = {};
        this.__changeValue = new ObservedPropertySimplePU('', this, "changeValue");
        this.__submitValue = new ObservedPropertySimplePU('', this, "submitValue");
        this.controller = new SearchController();
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: PlatformView2_Params) {
        if (params.surfaceId !== undefined) {
            this.surfaceId = params.surfaceId;
        }
        if (params.xComponentContext !== undefined) {
            this.xComponentContext = params.xComponentContext;
        }
        if (params.changeValue !== undefined) {
            this.changeValue = params.changeValue;
        }
        if (params.submitValue !== undefined) {
            this.submitValue = params.submitValue;
        }
        if (params.controller !== undefined) {
            this.controller = params.controller;
        }
    }
    updateStateVars(params: PlatformView2_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__changeValue.purgeDependencyOnElmtId(rmElmtId);
        this.__submitValue.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__changeValue.aboutToBeDeleted();
        this.__submitValue.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private surfaceId: string;
    private xComponentContext: Record<string, () => void>;
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
    private controller: SearchController;
    // xComponentController: XComponentController = new XComponentController()
    // xComponentController2: XComponentController = new XComponentController()
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("pages/platform_view/PlatformView2.ets(28:5)");
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("pages/platform_view/PlatformView2.ets(29:7)");
            Column.backgroundColor(Color.Gray);
            Column.height('80%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            XComponent.create({
                id: 'PlatformViewTest1',
                type: XComponentType.PLATFORM_VIEW,
                // controller: this.xComponentController
            }, "com.example.mapapp/entry");
            XComponent.debugLine("pages/platform_view/PlatformView2.ets(31:9)");
            XComponent.width('100%');
            XComponent.height('50%');
            XComponent.backgroundColor(Color.Gray);
        }, XComponent);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            XComponent.create({
                id: 'PlatformViewTest2',
                type: XComponentType.PLATFORM_VIEW,
                // controller: this.xComponentController2
            }, "com.example.mapapp/entry");
            XComponent.debugLine("pages/platform_view/PlatformView2.ets(41:9)");
            XComponent.width('100%');
            XComponent.height('50%');
            XComponent.backgroundColor(Color.Gray);
        }, XComponent);
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Navigator.create({ target: 'pages/Index', type: NavigationType.Back });
            Navigator.debugLine("pages/platform_view/PlatformView2.ets(55:7)");
        }, Navigator);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('back');
            Button.debugLine("pages/platform_view/PlatformView2.ets(56:9)");
            Button.fontSize(15);
            Button.margin(10);
        }, Button);
        Button.pop();
        Navigator.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
ViewStackProcessor.StartGetAccessRecordingFor(ViewStackProcessor.AllocateNewElmetIdForNextComponent());
loadDocument(new PlatformView2(undefined, {}));
ViewStackProcessor.StopGetAccessRecording();
