if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface UserButton_Params {
    name?: string;
    page?: string;
}
import router from "@ohos:router";
export class UserButton extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.name = "";
        this.page = "";
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: UserButton_Params) {
        if (params.name !== undefined) {
            this.name = params.name;
        }
        if (params.page !== undefined) {
            this.page = params.page;
        }
    }
    updateStateVars(params: UserButton_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private name: string;
    private page: string;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("common/UserButton.ets(9:5)");
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("common/UserButton.ets(10:7)");
            Row.justifyContent(FlexAlign.SpaceAround);
            Row.margin({ top: 5 });
            Row.width('100%');
            Row.height(50);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel(this.name);
            Button.debugLine("common/UserButton.ets(11:9)");
            Button.margin(10);
            Button.width('90%');
            Button.height(45);
            Button.fontSize(15);
            Button.fontColor(Color.White);
            Button.type(ButtonType.Capsule);
            Button.stateEffect(true);
            Button.onClick(() => {
                router.pushUrl({
                    url: 'pages/' + this.page
                });
            });
        }, Button);
        Button.pop();
        Row.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
