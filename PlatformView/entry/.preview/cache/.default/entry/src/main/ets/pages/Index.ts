if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface PlatformView_Params {
}
class PlatformView extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: PlatformView_Params) {
    }
    updateStateVars(params: PlatformView_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("pages/Index.ets(21:5)");
            Column.width('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            XComponent.create({
                id: 'PlatformViewTest1',
                type: XComponentType.PLATFORM_VIEW,
            }, "com.example.platformView/entry");
            XComponent.debugLine("pages/Index.ets(24:9)");
            XComponent.width('100%');
            XComponent.backgroundColor(Color.Gray);
            XComponent.height('80%');
        }, XComponent);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777220, "type": 10003, params: [], "bundleName": "com.example.platformView", "moduleName": "entry" });
            Text.debugLine("pages/Index.ets(34:7)");
            Text.fontSize({ "id": 16777324, "type": 10002, params: [], "bundleName": "com.example.platformView", "moduleName": "entry" });
            Text.fontFamily('HarmonyHeiTi-Bold');
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor({ "id": 16777226, "type": 10001, params: [], "bundleName": "com.example.platformView", "moduleName": "entry" });
            Text.textAlign(TextAlign.Start);
        }, Text);
        Text.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
ViewStackProcessor.StartGetAccessRecordingFor(ViewStackProcessor.AllocateNewElmetIdForNextComponent());
loadDocument(new PlatformView(undefined, {}));
ViewStackProcessor.StopGetAccessRecording();
