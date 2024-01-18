interface LogInPage_Params {
    showLogIn?: boolean;
    logInHeight?: string;
}
export class LogInPage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__showLogIn = new SynchedPropertySimpleTwoWayPU(params.showLogIn, this, "showLogIn");
        this.__logInHeight = new SynchedPropertySimpleTwoWayPU(params.logInHeight, this, "logInHeight");
        this.setInitiallyProvidedValue(params);
    }
    setInitiallyProvidedValue(params: LogInPage_Params) {
    }
    updateStateVars(params: LogInPage_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__showLogIn.purgeDependencyOnElmtId(rmElmtId);
        this.__logInHeight.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__showLogIn.aboutToBeDeleted();
        this.__logInHeight.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __showLogIn: SynchedPropertySimpleTwoWayPU<boolean>;
    get showLogIn() {
        return this.__showLogIn.get();
    }
    set showLogIn(newValue: boolean) {
        this.__showLogIn.set(newValue);
    }
    private __logInHeight: SynchedPropertySimpleTwoWayPU<string>;
    get logInHeight() {
        return this.__logInHeight.get();
    }
    set logInHeight(newValue: string) {
        this.__logInHeight.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.height(this.logInHeight);
            Column.width('100%');
            Column.backgroundColor(Color.White);
            Column.opacity(this.showLogIn ? 1 : 0);
            Column.padding({ top: 30, left: 10 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777226, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
            Image.height(20);
            Image.width(20);
            Image.position({ x: 0, y: -15 });
            Image.onClick(() => {
                Context.animateTo({
                    duration: 100,
                    curve: Curve.Linear,
                    onFinish: () => {
                        this.showLogIn = false;
                    }
                }, () => {
                    this.logInHeight = '0';
                });
            });
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({
                direction: FlexDirection.Column,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
            });
            Flex.backgroundColor(Color.White);
            Flex.borderRadius(10);
            Flex.padding({ top: 50, left: 20, right: 30, bottom: 35 });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('登录你的头条  精彩永不丢失');
            Text.fontSize(18);
            Text.margin({ bottom: 5 });
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.borderRadius(10);
            Column.border({ width: 1, color: '#c9c9c9' });
            Column.backgroundColor(Color.White);
            Column.margin({ top: 80, bottom: 80 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777275, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
            Image.width(50);
            Image.height(50);
            Image.objectFit(ImageFit.Contain);
        }, Image);
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center });
            Flex.width('100%');
            Flex.height(36);
            Flex.backgroundColor('#f04142');
            Flex.margin({ bottom: 10 });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777227, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
            Image.height(15);
            Image.width(15);
            Image.margin({ right: 10 });
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('一键登录');
            Text.fontSize(12);
            Text.fontColor(Color.White);
        }, Text);
        Text.pop();
        Flex.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Checkbox.create();
            Checkbox.width(12);
            Checkbox.height(12);
            Checkbox.selectedColor('#f04142');
        }, Checkbox);
        Checkbox.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create();
            Text.fontSize(10);
        }, Text);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Span.create('已阅读并同意');
            Span.fontColor('#999999');
        }, Span);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Span.create(' 用户协议');
        }, Span);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Span.create(' 和 ');
            Span.fontColor('#999999');
        }, Span);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Span.create('隐私政策');
        }, Span);
        Text.pop();
        Flex.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start });
            Flex.height(100);
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('授权后应用将获得以下权限：');
            Text.fontSize(10);
            Text.fontColor('#999');
            Text.margin({ bottom: 10 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777230, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
            Image.width(15);
            Image.height(15);
            Image.margin({ right: 5 });
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('获得你的公开信息（头像昵称、地区和性别）');
            Text.fontSize(10);
            Text.fontColor('#999');
        }, Text);
        Text.pop();
        Flex.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center });
            Flex.margin({ bottom: 10, top: 10 });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777231, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
            Image.width(15);
            Image.height(15);
            Image.margin({ right: 5 });
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('获得你的抖音手机号');
            Text.fontSize(10);
            Text.fontColor('#999');
        }, Text);
        Text.pop();
        Flex.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777231, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
            Image.width(15);
            Image.height(15);
            Image.margin({ right: 5 });
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('获得你的抖音互关朋友关系');
            Text.fontSize(10);
            Text.fontColor('#999');
        }, Text);
        Text.pop();
        Flex.pop();
        Flex.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center });
            Flex.margin({ top: 20, bottom: 15 });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.height(24);
            Column.width(24);
            Column.borderRadius(12);
            Column.padding(6);
            Column.border({ width: 0.5, color: '#999' });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777264, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
        }, Image);
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.height(24);
            Column.width(24);
            Column.borderRadius(12);
            Column.padding(6);
            Column.border({ width: 0.5, color: '#999' });
            Column.margin({ left: 20, right: 20 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777224, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
        }, Image);
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.height(24);
            Column.width(24);
            Column.borderRadius(12);
            Column.padding(6);
            Column.border({ width: 0.5, color: '#999' });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777242, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
        }, Image);
        Column.pop();
        Flex.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('隐私设置');
            Text.fontSize(12);
            Text.margin({ right: 15 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('遇到问题');
            Text.fontSize(12);
        }, Text);
        Text.pop();
        Flex.pop();
        Column.pop();
        Flex.pop();
        Column.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
