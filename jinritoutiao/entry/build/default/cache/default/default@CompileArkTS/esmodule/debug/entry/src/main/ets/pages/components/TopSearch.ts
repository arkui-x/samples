interface TopSearch_Params {
}
export class TopSearch extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.setInitiallyProvidedValue(params);
    }
    setInitiallyProvidedValue(params: TopSearch_Params) {
    }
    updateStateVars(params: TopSearch_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center });
            Flex.backgroundColor('#f04142');
            Flex.padding({ top: 20, left: 15, right: 15 });
            Flex.height('10%');
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Search.create({ placeholder: '杭州调整住房限购范围' });
            Search.height(40);
            Search.backgroundColor("#fff");
            Search.placeholderColor('#000');
            Search.placeholderFont({ size: 15 });
        }, Search);
        Search.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.margin({ left: 15 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.backgroundColor('#fff');
            Column.width(24);
            Column.height(24);
            Column.borderRadius(12);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777243, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
            Image.autoResize(true);
            Image.padding(5);
        }, Image);
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('发布');
            Text.fontColor('#fff');
            Text.fontSize(10);
            Text.fontWeight(FontWeight.Bold);
            Text.margin({ top: 3 });
        }, Text);
        Text.pop();
        Column.pop();
        Flex.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
