if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface PlatformView3_Params {
    surfaceId?: string;
    xComponentContext?: Record<string, () => void>;
    xComponentController?: XComponentController;
}
class PlatformView3 extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.surfaceId = '';
        this.xComponentContext = {};
        this.xComponentController = new XComponentController();
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: PlatformView3_Params) {
        if (params.surfaceId !== undefined) {
            this.surfaceId = params.surfaceId;
        }
        if (params.xComponentContext !== undefined) {
            this.xComponentContext = params.xComponentContext;
        }
        if (params.xComponentController !== undefined) {
            this.xComponentController = params.xComponentController;
        }
    }
    updateStateVars(params: PlatformView3_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // 创建平台桥接对象
    // private bridgeCodec = bridge.createBridge('Bridge');
    // bridgeCodec: BridgeObject = bridge.createBridge('Bridge');
    // @State helloArkUI: string = '';
    // @State nativeResponse: string = '';
    private surfaceId: string;
    private xComponentContext: Record<string, () => void>;
    private xComponentController: XComponentController;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("pages/platform_view/PlatformView3.ets(35:5)");
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("pages/platform_view/PlatformView3.ets(36:7)");
            Column.backgroundColor(Color.Gray);
            Column.height('80%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Navigator.create({ target: 'pages/Index', type: NavigationType.Back });
            Navigator.debugLine("pages/platform_view/PlatformView3.ets(39:9)");
        }, Navigator);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('back');
            Button.debugLine("pages/platform_view/PlatformView3.ets(40:11)");
            Button.fontSize(15);
            Button.margin(10);
        }, Button);
        Button.pop();
        Navigator.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            XComponent.create({
                id: 'PlatformViewTest1',
                type: XComponentType.PLATFORM_VIEW,
                controller: this.xComponentController
            }, "com.example.mapapp/entry");
            XComponent.debugLine("pages/platform_view/PlatformView3.ets(43:9)");
            XComponent.width('100%');
            XComponent.height('100%');
            XComponent.backgroundColor(Color.Gray);
        }, XComponent);
        Column.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
ViewStackProcessor.StartGetAccessRecordingFor(ViewStackProcessor.AllocateNewElmetIdForNextComponent());
loadDocument(new PlatformView3(undefined, {}));
ViewStackProcessor.StopGetAccessRecording();
