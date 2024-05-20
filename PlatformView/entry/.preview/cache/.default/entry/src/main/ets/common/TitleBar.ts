if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface TitleBar_Params {
    name?: string;
}
export class TitleBar extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.name = "";
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: TitleBar_Params) {
        if (params.name !== undefined) {
            this.name = params.name;
        }
    }
    updateStateVars(params: TitleBar_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private name: string;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("common/TitleBar.ets(6:5)");
            Row.width('100%');
            Row.height('8%');
            Row.padding({ left: 15 });
            Row.backgroundColor('#0D9FFB');
            Row.constraintSize({ minHeight: 50 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.name);
            Text.debugLine("common/TitleBar.ets(7:7)");
            Text.fontSize(30);
            Text.layoutWeight(1);
            Text.fontColor(Color.White);
        }, Text);
        Text.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
