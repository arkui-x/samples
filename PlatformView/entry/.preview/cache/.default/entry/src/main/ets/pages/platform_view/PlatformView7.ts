if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface PlatformView7_Params {
    surfaceId?: string;
    xComponentContext?: Record<string, () => void>;
    changeValue?: string;
    submitValue?: string;
    numbers?: String[];
    start?: boolean;
    controller?: web_webview.WebviewController;
    scroller?: Scroller;
}
import web_webview from "@ohos:web.webview";
import type business_error from "@ohos:base";
class PlatformView7 extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.surfaceId = '';
        this.xComponentContext = {};
        this.__changeValue = new ObservedPropertySimplePU('', this, "changeValue");
        this.__submitValue = new ObservedPropertySimplePU('', this, "submitValue");
        this.__numbers = new ObservedPropertyObjectPU(['0', '1', '2'], this, "numbers");
        this.__start = new ObservedPropertySimplePU(true, this, "start");
        this.controller = new web_webview.WebviewController();
        this.scroller = new Scroller();
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: PlatformView7_Params) {
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
        if (params.numbers !== undefined) {
            this.numbers = params.numbers;
        }
        if (params.start !== undefined) {
            this.start = params.start;
        }
        if (params.controller !== undefined) {
            this.controller = params.controller;
        }
        if (params.scroller !== undefined) {
            this.scroller = params.scroller;
        }
    }
    updateStateVars(params: PlatformView7_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__changeValue.purgeDependencyOnElmtId(rmElmtId);
        this.__submitValue.purgeDependencyOnElmtId(rmElmtId);
        this.__numbers.purgeDependencyOnElmtId(rmElmtId);
        this.__start.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__changeValue.aboutToBeDeleted();
        this.__submitValue.aboutToBeDeleted();
        this.__numbers.aboutToBeDeleted();
        this.__start.aboutToBeDeleted();
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
    private __numbers: ObservedPropertyObjectPU<String[]>;
    get numbers() {
        return this.__numbers.get();
    }
    set numbers(newValue: String[]) {
        this.__numbers.set(newValue);
    }
    private __start: ObservedPropertySimplePU<boolean>;
    get start() {
        return this.__start.get();
    }
    set start(newValue: boolean) {
        this.__start.set(newValue);
    }
    private controller: web_webview.WebviewController;
    private scroller: Scroller;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Scroll.create(this.scroller);
            Scroll.debugLine("pages/platform_view/PlatformView7.ets(35:5)");
            Scroll.width('100%');
            Scroll.height('100%');
            Scroll.scrollable(ScrollDirection.Vertical);
            Scroll.scrollBar(BarState.On);
            Scroll.scrollBarColor(Color.Gray);
            Scroll.scrollBarWidth(10);
            Scroll.edgeEffect(EdgeEffect.None);
            Scroll.onScroll((xOffset: number, yOffset: number) => {
                console.info(xOffset + ' ' + yOffset);
            });
        }, Scroll);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("pages/platform_view/PlatformView7.ets(37:7)");
            Column.backgroundColor(Color.White);
            Column.width(300);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('loadUrl');
            Button.debugLine("pages/platform_view/PlatformView7.ets(40:13)");
            Button.onClick(() => {
                try {
                    // 需要加载的URL是string类型。
                    this.controller.loadUrl('https://www.baidu.com');
                }
                catch (error) {
                    let e: business_error.BusinessError = error as business_error.BusinessError;
                    console.error(`ErrorCode: ${e.code},  Message: ${e.message}`);
                }
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Web.create({ src: 'https://www.baidu.com', controller: this.controller });
            Web.debugLine("pages/platform_view/PlatformView7.ets(50:13)");
            Web.backgroundColor(Color.Grey);
            Web.height("500");
        }, Web);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create("弹窗类组件-AlertDialog");
            Text.debugLine("pages/platform_view/PlatformView7.ets(52:13)");
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel();
            Button.debugLine("pages/platform_view/PlatformView7.ets(53:13)");
            Button.onClick(() => {
                AlertDialog.show({
                    title: 'title',
                    subtitle: 'subtitle',
                    message: 'text',
                    autoCancel: true,
                    alignment: DialogAlignment.Bottom,
                    gridCount: 4,
                    offset: { dx: 0, dy: -350 },
                    buttonDirection: DialogButtonDirection.HORIZONTAL,
                });
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create("导航类组件-Navigator");
            Text.debugLine("pages/platform_view/PlatformView7.ets(70:13)");
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Navigator.create({ target: 'pages/Index', type: NavigationType.Back });
            Navigator.debugLine("pages/platform_view/PlatformView7.ets(71:13)");
        }, Navigator);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('back');
            Button.debugLine("pages/platform_view/PlatformView7.ets(72:15)");
            Button.fontSize(15);
            Button.margin(10);
        }, Button);
        Button.pop();
        Navigator.pop();
        Column.pop();
        Scroll.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
ViewStackProcessor.StartGetAccessRecordingFor(ViewStackProcessor.AllocateNewElmetIdForNextComponent());
loadDocument(new PlatformView7(undefined, {}));
ViewStackProcessor.StopGetAccessRecording();
