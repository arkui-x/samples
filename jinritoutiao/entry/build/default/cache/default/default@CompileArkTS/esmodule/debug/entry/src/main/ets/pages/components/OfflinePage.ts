interface OfflinePage_Params {
    isShow?: boolean;
}
export class OfflinePage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__isShow = new SynchedPropertySimpleTwoWayPU(params.isShow, this, "isShow");
        this.setInitiallyProvidedValue(params);
    }
    setInitiallyProvidedValue(params: OfflinePage_Params) {
    }
    updateStateVars(params: OfflinePage_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__isShow.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__isShow.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __isShow: SynchedPropertySimpleTwoWayPU<boolean>;
    get isShow() {
        return this.__isShow.get();
    }
    set isShow(newValue: boolean) {
        this.__isShow.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.margin({ top: 100 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.isShow) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Image.create({ "id": 16777265, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                        Image.height(50);
                        Image.width(50);
                        Image.margin({ bottom: 20 });
                    }, Image);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('加载中，请稍等待...');
                        Text.fontColor('#999');
                    }, Text);
                    Text.pop();
                    Column.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Image.create({ "id": 16777271, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                        Image.height(80);
                        Image.width(80);
                    }, Image);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('网络不给力');
                        Text.fontColor('#999');
                        Text.margin({ top: 20, bottom: 20 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.padding({ top: 8, right: 20, bottom: 8, left: 20 });
                        Column.border({ width: 1, color: '#f04142' });
                        Column.borderRadius(8);
                        Column.onClick(() => {
                            this.isShow = true;
                        });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('重试');
                        Text.fontColor('#f04142');
                    }, Text);
                    Text.pop();
                    Column.pop();
                });
            }
        }, If);
        If.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
