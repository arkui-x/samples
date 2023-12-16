interface LogIn_Params {
    isLogIn?: boolean;
    isShare?: boolean;
    isLoading?: boolean;
    shareOverLay?: string;
}
export class LogIn extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__isLogIn = new SynchedPropertySimpleTwoWayPU(params.isLogIn, this, "isLogIn");
        this.__isShare = new SynchedPropertySimpleTwoWayPU(params.isShare, this, "isShare");
        this.__isLoading = new SynchedPropertySimpleTwoWayPU(params.isLoading, this, "isLoading");
        this.__shareOverLay = new SynchedPropertySimpleTwoWayPU(params.shareOverLay, this, "shareOverLay");
        this.setInitiallyProvidedValue(params);
    }
    setInitiallyProvidedValue(params: LogIn_Params) {
    }
    updateStateVars(params: LogIn_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__isLogIn.purgeDependencyOnElmtId(rmElmtId);
        this.__isShare.purgeDependencyOnElmtId(rmElmtId);
        this.__isLoading.purgeDependencyOnElmtId(rmElmtId);
        this.__shareOverLay.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__isLogIn.aboutToBeDeleted();
        this.__isShare.aboutToBeDeleted();
        this.__isLoading.aboutToBeDeleted();
        this.__shareOverLay.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __isLogIn: SynchedPropertySimpleTwoWayPU<boolean>;
    get isLogIn() {
        return this.__isLogIn.get();
    }
    set isLogIn(newValue: boolean) {
        this.__isLogIn.set(newValue);
    }
    private __isShare: SynchedPropertySimpleTwoWayPU<boolean>;
    get isShare() {
        return this.__isShare.get();
    }
    set isShare(newValue: boolean) {
        this.__isShare.set(newValue);
    }
    private __isLoading: SynchedPropertySimpleTwoWayPU<boolean>;
    get isLoading() {
        return this.__isLoading.get();
    }
    set isLoading(newValue: boolean) {
        this.__isLoading.set(newValue);
    }
    private __shareOverLay: SynchedPropertySimpleTwoWayPU<string>;
    get shareOverLay() {
        return this.__shareOverLay.get();
    }
    set shareOverLay(newValue: string) {
        this.__shareOverLay.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ direction: FlexDirection.Column, alignItems: ItemAlign.Center });
            Flex.backgroundColor(Color.White);
            Flex.height(360);
            Flex.width(250);
            Flex.padding({ top: 20, left: 10, right: 10 });
            Flex.borderRadius(10);
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777226, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
            Image.height(20);
            Image.width(20);
            Image.position({ x: 215, y: -15 });
            Image.onClick(() => {
                this.isShare = false;
                Context.animateTo({
                    duration: 100,
                    curve: Curve.Smooth,
                    playMode: PlayMode.Normal,
                }, () => {
                    this.isLogIn = false;
                });
                if (this.shareOverLay === 'watch') {
                    this.isLoading = false;
                }
            });
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('登录后可点赞');
            Text.fontSize(14);
            Text.margin({ bottom: 5 });
        }, Text);
        Text.pop();
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
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.borderRadius(10);
            Column.border({ width: 1, color: '#c9c9c9' });
            Column.backgroundColor(Color.White);
            Column.margin({ top: 25, bottom: 25 });
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
            Flex.create({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center });
            Flex.margin({ bottom: 20 });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('其他登录方式');
            Text.fontSize(12);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('遇到问题');
            Text.fontSize(12);
        }, Text);
        Text.pop();
        Flex.pop();
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
        Flex.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
