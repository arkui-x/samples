if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface PlatformView6_Params {
    surfaceId?: string;
    xComponentContext?: Record<string, () => void>;
    changeValue?: string;
    submitValue?: string;
    numbers?: String[];
    start?: boolean;
    fromStart?: boolean;
    step?: number;
    loop?: number;
    src?: string;
    scroller?: Scroller;
    controller?: VideoController | undefined;
    previewUris?: Resource;
    innerResource?: Resource;
}
class PlatformView6 extends ViewPU {
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
        this.fromStart = true;
        this.step = 50;
        this.loop = Number.POSITIVE_INFINITY;
        this.src = "Running Marquee starts rolling Running Marquee starts rolling Running Marquee starts rolling";
        this.scroller = new Scroller();
        this.controller = undefined;
        this.previewUris = { "id": 16777219, "type": 20000, params: [], "bundleName": "com.example.mapapp", "moduleName": "entry" };
        this.innerResource = { "id": 0, "type": 30000, params: ['videoTest.MP4'], "bundleName": "com.example.mapapp", "moduleName": "entry" };
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: PlatformView6_Params) {
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
        if (params.fromStart !== undefined) {
            this.fromStart = params.fromStart;
        }
        if (params.step !== undefined) {
            this.step = params.step;
        }
        if (params.loop !== undefined) {
            this.loop = params.loop;
        }
        if (params.src !== undefined) {
            this.src = params.src;
        }
        if (params.scroller !== undefined) {
            this.scroller = params.scroller;
        }
        if (params.controller !== undefined) {
            this.controller = params.controller;
        }
        if (params.previewUris !== undefined) {
            this.previewUris = params.previewUris;
        }
        if (params.innerResource !== undefined) {
            this.innerResource = params.innerResource;
        }
    }
    updateStateVars(params: PlatformView6_Params) {
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
    private fromStart: boolean;
    private step: number;
    private loop: number;
    private src: string;
    private scroller: Scroller;
    private controller: VideoController | undefined;
    private previewUris: Resource;
    private innerResource: Resource;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("pages/platform_view/PlatformView6.ets(41:5)");
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Scroll.create(this.scroller);
            Scroll.debugLine("pages/platform_view/PlatformView6.ets(42:9)");
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
            Column.debugLine("pages/platform_view/PlatformView6.ets(43:11)");
            Column.backgroundColor(Color.White);
            Column.width('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            XComponent.create({
                id: 'PlatformViewTest1',
                type: XComponentType.PLATFORM_VIEW,
                // controller: this.xComponentController
            }, "com.example.mapapp/entry");
            XComponent.debugLine("pages/platform_view/PlatformView6.ets(44:13)");
            XComponent.width('100%');
            XComponent.height('50%');
            XComponent.backgroundColor(Color.Gray);
        }, XComponent);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create("图文类组件-Image");
            Text.debugLine("pages/platform_view/PlatformView6.ets(53:13)");
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777219, "type": 20000, params: [], "bundleName": "com.example.mapapp", "moduleName": "entry" });
            Image.debugLine("pages/platform_view/PlatformView6.ets(54:13)");
            Image.width(60);
            Image.height(60);
            Image.margin(15);
            Image.overlay('Image', { align: Alignment.Bottom, offset: { x: 0, y: 20 } });
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create("布局类组件-Grid");
            Text.debugLine("pages/platform_view/PlatformView6.ets(58:13)");
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Grid.create();
            Grid.debugLine("pages/platform_view/PlatformView6.ets(59:13)");
            Grid.columnsTemplate('1fr 1fr 1fr');
            Grid.rowsTemplate('1fr 1fr 1fr');
            Grid.width(50);
            Grid.backgroundColor(0xFAEEE0);
            Grid.height(50);
        }, Grid);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const day = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    ForEach.create();
                    const forEachItemGenFunction = _item => {
                        const day = _item;
                        {
                            const itemCreation2 = (elmtId, isInitialRender) => {
                                GridItem.create(() => { }, false);
                                GridItem.debugLine("pages/platform_view/PlatformView6.ets(62:19)");
                            };
                            const observedDeepRender = () => {
                                this.observeComponentCreation2(itemCreation2, GridItem);
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    Text.create(day);
                                    Text.debugLine("pages/platform_view/PlatformView6.ets(63:21)");
                                    Text.fontSize(16);
                                    Text.backgroundColor(0xF9CF93);
                                    Text.width('100%');
                                    Text.height('100%');
                                    Text.textAlign(TextAlign.Center);
                                }, Text);
                                Text.pop();
                                GridItem.pop();
                            };
                            observedDeepRender();
                        }
                    };
                    this.forEachUpdateFunction(elmtId, this.numbers, forEachItemGenFunction, (day: string) => day, false, false);
                }, ForEach);
                ForEach.pop();
            };
            this.forEachUpdateFunction(elmtId, this.numbers, forEachItemGenFunction, (day: string) => day, false, false);
        }, ForEach);
        ForEach.pop();
        Grid.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create("信息展示类组件-Marquee");
            Text.debugLine("pages/platform_view/PlatformView6.ets(82:13)");
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Marquee.create({
                start: this.start,
                step: this.step,
                loop: this.loop,
                fromStart: this.fromStart,
                src: this.src
            });
            Marquee.debugLine("pages/platform_view/PlatformView6.ets(83:13)");
            Marquee.width(360);
            Marquee.height(40);
            Marquee.fontColor('#FFFFFF');
            Marquee.fontSize(16);
            Marquee.fontWeight(700);
            Marquee.backgroundColor('#182431');
            Marquee.margin({ bottom: 15 });
            Marquee.onStart(() => {
                console.info('Marquee animation complete onStart');
            });
            Marquee.onBounce(() => {
                console.info('Marquee animation complete onBounce');
            });
            Marquee.onFinish(() => {
                console.info('Marquee animation complete onFinish');
            });
        }, Marquee);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create("表单选择类组件-CheckBox");
            Text.debugLine("pages/platform_view/PlatformView6.ets(107:13)");
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Checkbox.create({ name: 'checkbox1', group: 'checkboxGroup' });
            Checkbox.debugLine("pages/platform_view/PlatformView6.ets(108:13)");
            Checkbox.select(true);
            Checkbox.selectedColor(0xed6f21);
            Checkbox.shape(CheckBoxShape.CIRCLE);
            Checkbox.onChange((value: boolean) => {
                console.info('Checkbox1 change is' + value);
            });
        }, Checkbox);
        Checkbox.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create("弹窗类组件-AlertDialog");
            Text.debugLine("pages/platform_view/PlatformView6.ets(116:13)");
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel();
            Button.debugLine("pages/platform_view/PlatformView6.ets(117:13)");
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
            Text.create("视频组件-video");
            Text.debugLine("pages/platform_view/PlatformView6.ets(134:13)");
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("pages/platform_view/PlatformView6.ets(135:13)");
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Video.create({
                src: this.innerResource,
                previewUri: this.previewUris,
                controller: this.controller
            });
            Video.debugLine("pages/platform_view/PlatformView6.ets(136:15)");
            Video.height(500);
            Video.autoPlay(true);
            Video.loop(true);
            Video.objectFit(ImageFit.Contain);
        }, Video);
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create("导航类组件-Navigator");
            Text.debugLine("pages/platform_view/PlatformView6.ets(150:13)");
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Navigator.create({ target: 'pages/Index', type: NavigationType.Back });
            Navigator.debugLine("pages/platform_view/PlatformView6.ets(151:13)");
        }, Navigator);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('back');
            Button.debugLine("pages/platform_view/PlatformView6.ets(152:15)");
            Button.fontSize(15);
            Button.margin(10);
        }, Button);
        Button.pop();
        Navigator.pop();
        Column.pop();
        Scroll.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
ViewStackProcessor.StartGetAccessRecordingFor(ViewStackProcessor.AllocateNewElmetIdForNextComponent());
loadDocument(new PlatformView6(undefined, {}));
ViewStackProcessor.StopGetAccessRecording();
