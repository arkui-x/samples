interface NewDetails_Params {
    scroller?: Scroller;
    rowScroller?: Scroller;
    videoController?: VideoController | undefined;
    shareHeight?: number;
    isShare?: boolean;
    scrollTop?: number;
    shareOpacity?: number;
    isLogIn?: boolean;
    shareOverLay?: string;
    isLoading?: boolean;
    source?: string;
    digg_count?: number;
    title?: string;
    comment_count?: number;
    publish_time?: number;
    share_count?: number;
    avatar_url?: string;
    content?: string;
    image_list?: ImageList[];
    review?: Review[];
    isLoadAll?: boolean;
    isTopMore?: boolean;
}
import router from "@ohos:router";
import { LogIn } from "@bundle:com.example.jinritoutiao/entry/ets/pages/components/LogIn";
import { formatDate, getReviewList, Utils } from "@bundle:com.example.jinritoutiao/entry/ets/pages/util/Common";
import { WhereRandom } from "@bundle:com.example.jinritoutiao/entry/ets/pages/util/Mock";
import type { Review } from "@bundle:com.example.jinritoutiao/entry/ets/pages/util/Mock";
import type { ImageList } from './util/Request';
interface Params {
    source: string;
    digg_count: number;
    title: string;
    comment_count: number;
    publish_time: number;
    share_count: number;
    avatar_url: string;
    content: string;
    image_list: ImageList[];
}
class NewDetails extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.scroller = new Scroller();
        this.rowScroller = new Scroller();
        this.videoController = undefined;
        this.__shareHeight = new ObservedPropertySimplePU(-9999, this, "shareHeight");
        this.__isShare = new ObservedPropertySimplePU(false, this, "isShare");
        this.__scrollTop = new ObservedPropertySimplePU(0, this, "scrollTop");
        this.__shareOpacity = new ObservedPropertySimplePU(0, this, "shareOpacity");
        this.__isLogIn = new ObservedPropertySimplePU(false, this, "isLogIn");
        this.__shareOverLay = new ObservedPropertySimplePU('share', this, "shareOverLay");
        this.__isLoading = new ObservedPropertySimplePU(false, this, "isLoading");
        this.__source = new ObservedPropertySimplePU('' //作者
        , this, "source");
        this.__digg_count = new ObservedPropertySimplePU(0 // 点赞数
        , this, "digg_count");
        this.__title = new ObservedPropertySimplePU('' // 新闻title
        , this, "title");
        this.__comment_count = new ObservedPropertySimplePU(0 //评论数
        , this, "comment_count");
        this.__publish_time = new ObservedPropertySimplePU(0 //发布时间
        , this, "publish_time");
        this.__share_count = new ObservedPropertySimplePU(0 // 分享数
        , this, "share_count");
        this.__avatar_url = new ObservedPropertySimplePU('' //作者头像
        , this, "avatar_url");
        this.__content = new ObservedPropertySimplePU('' //文章内容
        , this, "content");
        this.__image_list = new ObservedPropertyObjectPU([], this, "image_list");
        this.__review = new ObservedPropertyObjectPU([], this, "review");
        this.__isLoadAll = new ObservedPropertySimplePU(false, this, "isLoadAll");
        this.__isTopMore = new ObservedPropertySimplePU(false, this, "isTopMore");
        this.setInitiallyProvidedValue(params);
    }
    setInitiallyProvidedValue(params: NewDetails_Params) {
        if (params.scroller !== undefined) {
            this.scroller = params.scroller;
        }
        if (params.rowScroller !== undefined) {
            this.rowScroller = params.rowScroller;
        }
        if (params.videoController !== undefined) {
            this.videoController = params.videoController;
        }
        if (params.shareHeight !== undefined) {
            this.shareHeight = params.shareHeight;
        }
        if (params.isShare !== undefined) {
            this.isShare = params.isShare;
        }
        if (params.scrollTop !== undefined) {
            this.scrollTop = params.scrollTop;
        }
        if (params.shareOpacity !== undefined) {
            this.shareOpacity = params.shareOpacity;
        }
        if (params.isLogIn !== undefined) {
            this.isLogIn = params.isLogIn;
        }
        if (params.shareOverLay !== undefined) {
            this.shareOverLay = params.shareOverLay;
        }
        if (params.isLoading !== undefined) {
            this.isLoading = params.isLoading;
        }
        if (params.source !== undefined) {
            this.source = params.source;
        }
        if (params.digg_count !== undefined) {
            this.digg_count = params.digg_count;
        }
        if (params.title !== undefined) {
            this.title = params.title;
        }
        if (params.comment_count !== undefined) {
            this.comment_count = params.comment_count;
        }
        if (params.publish_time !== undefined) {
            this.publish_time = params.publish_time;
        }
        if (params.share_count !== undefined) {
            this.share_count = params.share_count;
        }
        if (params.avatar_url !== undefined) {
            this.avatar_url = params.avatar_url;
        }
        if (params.content !== undefined) {
            this.content = params.content;
        }
        if (params.image_list !== undefined) {
            this.image_list = params.image_list;
        }
        if (params.review !== undefined) {
            this.review = params.review;
        }
        if (params.isLoadAll !== undefined) {
            this.isLoadAll = params.isLoadAll;
        }
        if (params.isTopMore !== undefined) {
            this.isTopMore = params.isTopMore;
        }
    }
    updateStateVars(params: NewDetails_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__shareHeight.purgeDependencyOnElmtId(rmElmtId);
        this.__isShare.purgeDependencyOnElmtId(rmElmtId);
        this.__scrollTop.purgeDependencyOnElmtId(rmElmtId);
        this.__shareOpacity.purgeDependencyOnElmtId(rmElmtId);
        this.__isLogIn.purgeDependencyOnElmtId(rmElmtId);
        this.__shareOverLay.purgeDependencyOnElmtId(rmElmtId);
        this.__isLoading.purgeDependencyOnElmtId(rmElmtId);
        this.__source.purgeDependencyOnElmtId(rmElmtId);
        this.__digg_count.purgeDependencyOnElmtId(rmElmtId);
        this.__title.purgeDependencyOnElmtId(rmElmtId);
        this.__comment_count.purgeDependencyOnElmtId(rmElmtId);
        this.__publish_time.purgeDependencyOnElmtId(rmElmtId);
        this.__share_count.purgeDependencyOnElmtId(rmElmtId);
        this.__avatar_url.purgeDependencyOnElmtId(rmElmtId);
        this.__content.purgeDependencyOnElmtId(rmElmtId);
        this.__image_list.purgeDependencyOnElmtId(rmElmtId);
        this.__review.purgeDependencyOnElmtId(rmElmtId);
        this.__isLoadAll.purgeDependencyOnElmtId(rmElmtId);
        this.__isTopMore.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__shareHeight.aboutToBeDeleted();
        this.__isShare.aboutToBeDeleted();
        this.__scrollTop.aboutToBeDeleted();
        this.__shareOpacity.aboutToBeDeleted();
        this.__isLogIn.aboutToBeDeleted();
        this.__shareOverLay.aboutToBeDeleted();
        this.__isLoading.aboutToBeDeleted();
        this.__source.aboutToBeDeleted();
        this.__digg_count.aboutToBeDeleted();
        this.__title.aboutToBeDeleted();
        this.__comment_count.aboutToBeDeleted();
        this.__publish_time.aboutToBeDeleted();
        this.__share_count.aboutToBeDeleted();
        this.__avatar_url.aboutToBeDeleted();
        this.__content.aboutToBeDeleted();
        this.__image_list.aboutToBeDeleted();
        this.__review.aboutToBeDeleted();
        this.__isLoadAll.aboutToBeDeleted();
        this.__isTopMore.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private scroller: Scroller;
    private rowScroller: Scroller;
    private videoController: VideoController | undefined;
    private __shareHeight: ObservedPropertySimplePU<number>;
    get shareHeight() {
        return this.__shareHeight.get();
    }
    set shareHeight(newValue: number) {
        this.__shareHeight.set(newValue);
    }
    private __isShare: ObservedPropertySimplePU<boolean>;
    get isShare() {
        return this.__isShare.get();
    }
    set isShare(newValue: boolean) {
        this.__isShare.set(newValue);
    }
    private __scrollTop: ObservedPropertySimplePU<number>;
    get scrollTop() {
        return this.__scrollTop.get();
    }
    set scrollTop(newValue: number) {
        this.__scrollTop.set(newValue);
    }
    private __shareOpacity: ObservedPropertySimplePU<number>;
    get shareOpacity() {
        return this.__shareOpacity.get();
    }
    set shareOpacity(newValue: number) {
        this.__shareOpacity.set(newValue);
    }
    private __isLogIn: ObservedPropertySimplePU<boolean>;
    get isLogIn() {
        return this.__isLogIn.get();
    }
    set isLogIn(newValue: boolean) {
        this.__isLogIn.set(newValue);
    }
    private __shareOverLay: ObservedPropertySimplePU<string>;
    get shareOverLay() {
        return this.__shareOverLay.get();
    }
    set shareOverLay(newValue: string) {
        this.__shareOverLay.set(newValue);
    }
    private __isLoading: ObservedPropertySimplePU<boolean>;
    get isLoading() {
        return this.__isLoading.get();
    }
    set isLoading(newValue: boolean) {
        this.__isLoading.set(newValue);
    }
    private __source: ObservedPropertySimplePU<string>; //作者
    get source() {
        return this.__source.get();
    }
    set source(newValue: string) {
        this.__source.set(newValue);
    }
    private __digg_count: ObservedPropertySimplePU<number>; // 点赞数
    get digg_count() {
        return this.__digg_count.get();
    }
    set digg_count(newValue: number) {
        this.__digg_count.set(newValue);
    }
    private __title: ObservedPropertySimplePU<string>; // 新闻title
    get title() {
        return this.__title.get();
    }
    set title(newValue: string) {
        this.__title.set(newValue);
    }
    private __comment_count: ObservedPropertySimplePU<number>; //评论数
    get comment_count() {
        return this.__comment_count.get();
    }
    set comment_count(newValue: number) {
        this.__comment_count.set(newValue);
    }
    private __publish_time: ObservedPropertySimplePU<number>; //发布时间
    get publish_time() {
        return this.__publish_time.get();
    }
    set publish_time(newValue: number) {
        this.__publish_time.set(newValue);
    }
    private __share_count: ObservedPropertySimplePU<number>; // 分享数
    get share_count() {
        return this.__share_count.get();
    }
    set share_count(newValue: number) {
        this.__share_count.set(newValue);
    }
    private __avatar_url: ObservedPropertySimplePU<string>; //作者头像
    get avatar_url() {
        return this.__avatar_url.get();
    }
    set avatar_url(newValue: string) {
        this.__avatar_url.set(newValue);
    }
    private __content: ObservedPropertySimplePU<string>; //文章内容
    get content() {
        return this.__content.get();
    }
    set content(newValue: string) {
        this.__content.set(newValue);
    }
    private __image_list: ObservedPropertyObjectPU<ImageList[]>;
    get image_list() {
        return this.__image_list.get();
    }
    set image_list(newValue: ImageList[]) {
        this.__image_list.set(newValue);
    }
    private __review: ObservedPropertyObjectPU<Review[]>;
    get review() {
        return this.__review.get();
    }
    set review(newValue: Review[]) {
        this.__review.set(newValue);
    }
    private __isLoadAll: ObservedPropertySimplePU<boolean>;
    get isLoadAll() {
        return this.__isLoadAll.get();
    }
    set isLoadAll(newValue: boolean) {
        this.__isLoadAll.set(newValue);
    }
    private __isTopMore: ObservedPropertySimplePU<boolean>;
    get isTopMore() {
        return this.__isTopMore.get();
    }
    set isTopMore(newValue: boolean) {
        this.__isTopMore.set(newValue);
    }
    aboutToAppear() {
        let params = router.getParams() as Params;
        console.log('params.image_list', JSON.stringify(params.image_list));
        this.source = params.source;
        this.digg_count = params.digg_count;
        this.title = params.title;
        this.comment_count = params.comment_count;
        this.publish_time = params.publish_time;
        this.share_count = params.share_count;
        this.avatar_url = params.avatar_url;
        this.content = params.content;
        this.image_list = params.image_list;
        if (params.comment_count >= 10) {
            this.review = getReviewList(10);
        }
        else {
            this.review = getReviewList(params.comment_count);
        }
    }
    LargeOverlayNode(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.height(this.isShare ? '100%' : 0);
            Column.width(this.isShare ? '100%' : 0);
            Column.alignItems(HorizontalAlign.Center);
            Column.backgroundColor(Color.Grey);
            Column.opacity(0.2);
            Column.onClick(() => {
                if (this.shareOverLay == 'share') {
                    this.isShare = false;
                    this.isTopMore = false;
                    Context.animateTo({
                        duration: 100,
                        curve: Curve.Friction,
                        iterations: 1,
                        playMode: PlayMode.Alternate,
                    }, () => {
                        this.shareHeight = 0;
                        this.shareOpacity = 0;
                    });
                }
            });
        }, Column);
        Column.pop();
    }
    OverlayNode(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.height(30);
            Column.width(30);
            Column.alignItems(HorizontalAlign.Center);
            Column.backgroundColor(Color.Grey);
            Column.opacity(0.3);
            Column.borderRadius(15);
        }, Column);
        Column.pop();
    }
    Review(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.padding(10);
            Column.width('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 评论头部
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.SpaceBetween });
            Flex.width('100%');
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`评论 ${this.comment_count}`);
            Text.width('50%');
            Text.id('review');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${this.digg_count} 赞`);
            Text.fontColor(Color.Grey);
            Text.fontSize(14);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Divider.create();
            Divider.strokeWidth(1);
            Divider.color(Color.Grey);
            Divider.vertical(true);
            Divider.height(10);
            Divider.margin({ left: 10, right: 10 });
        }, Divider);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${this.share_count} 转发`);
            Text.fontColor(Color.Grey);
            Text.fontSize(14);
        }, Text);
        Text.pop();
        Flex.pop();
        Flex.pop();
        // 评论头部
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 评论详情
            Column.create();
            // 评论详情
            Column.width('100%');
            // 评论详情
            Column.padding({ top: 15 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = (_item, i: number) => {
                const t = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Flex.create({ direction: FlexDirection.Column });
                }, Flex);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Flex.create({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center });
                }, Flex);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Row.create();
                }, Row);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.borderRadius(13);
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Image.create(t.img);
                    Image.height(30);
                    Image.width(30);
                    Image.objectFit(ImageFit.Contain);
                    Image.overlay({ builder: () => {
                            this.OverlayNode.call(this);
                        } }, { align: Alignment.Center });
                    Image.borderRadius(15);
                }, Image);
                Column.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.padding({ left: 10, right: 10 });
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(t.name);
                    Text.fontSize(12);
                    Text.width('100%');
                }, Text);
                Text.pop();
                Column.pop();
                Row.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Flex.create({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center });
                }, Flex);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Image.create({ "id": 16777241, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                    Image.width(18);
                    Image.height(18);
                    Image.objectFit(ImageFit.Contain);
                    Image.margin({ right: 8 });
                }, Image);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(`${t.love ? t.love : '赞'}`);
                    Text.fontSize(t.love ? 14 : 12);
                }, Text);
                Text.pop();
                Flex.pop();
                Flex.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Flex.create({
                        direction: FlexDirection.Column,
                        justifyContent: FlexAlign.SpaceBetween,
                        alignItems: ItemAlign.Start
                    });
                    Flex.padding({ left: 40, top: 10 });
                }, Flex);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(t.content);
                    Text.fontSize(15);
                    Text.margin({ bottom: 10 });
                }, Text);
                Text.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Flex.create({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center });
                }, Flex);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create('回复 >');
                    Text.backgroundColor('#f2f3f5');
                    Text.fontColor('#000');
                    Text.fontSize(10);
                    Text.textAlign(TextAlign.Center);
                    Text.borderRadius(5);
                    Text.padding(5);
                    Text.margin({ right: 10 });
                }, Text);
                Text.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(`${t.ago} · ${t.where}`);
                    Text.fontSize(10);
                    Text.fontColor(Color.Grey);
                }, Text);
                Text.pop();
                Flex.pop();
                Flex.pop();
                Flex.pop();
            };
            this.forEachUpdateFunction(elmtId, this.review, forEachItemGenFunction, undefined, true, false);
        }, ForEach);
        ForEach.pop();
        // 评论详情
        Column.pop();
        Column.pop();
    }
    ShareColumn(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.backgroundColor(Color.White);
            Column.height(this.shareHeight);
            Column.opacity(this.shareOpacity);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.backgroundColor('#f2f3f5');
            Column.height(100);
            Column.padding({ top: 20, right: 15, bottom: 12, left: 15 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            List.create({ space: 20 });
            List.listDirection(Axis.Horizontal);
            List.scrollBar(BarState.Off);
        }, List);
        {
            const itemCreation = (elmtId, isInitialRender) => {
                ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                ListItem.create(deepRenderFunction, true);
                if (!isInitialRender) {
                    ListItem.pop();
                }
                ViewStackProcessor.StopGetAccessRecording();
            };
            const deepRenderFunction = (elmtId, isInitialRender) => {
                itemCreation(elmtId, isInitialRender);
                this.updateFuncByElmtId.set(elmtId, itemCreation);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.padding(8);
                    Column.borderRadius(23);
                    Column.backgroundColor(Color.White);
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Image.create({ "id": 16777275, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                    Image.width(30);
                    Image.height(30);
                    Image.objectFit(ImageFit.Contain);
                }, Image);
                Column.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create('转发到头条');
                    Text.fontSize(10);
                    Text.margin({ top: 10 });
                }, Text);
                Text.pop();
                Column.pop();
                ListItem.pop();
            };
            this.observeComponentCreation(itemCreation);
            ListItem.pop();
        }
        {
            const itemCreation = (elmtId, isInitialRender) => {
                ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                ListItem.create(deepRenderFunction, true);
                if (!isInitialRender) {
                    ListItem.pop();
                }
                ViewStackProcessor.StopGetAccessRecording();
            };
            const deepRenderFunction = (elmtId, isInitialRender) => {
                itemCreation(elmtId, isInitialRender);
                this.updateFuncByElmtId.set(elmtId, itemCreation);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.padding(8);
                    Column.borderRadius(23);
                    Column.backgroundColor(Color.White);
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Image.create({ "id": 16777270, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                    Image.width(30);
                    Image.height(30);
                    Image.objectFit(ImageFit.Contain);
                }, Image);
                Column.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create('生成分享图');
                    Text.fontSize(10);
                    Text.margin({ top: 10 });
                }, Text);
                Text.pop();
                Column.pop();
                ListItem.pop();
            };
            this.observeComponentCreation(itemCreation);
            ListItem.pop();
        }
        {
            const itemCreation = (elmtId, isInitialRender) => {
                ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                ListItem.create(deepRenderFunction, true);
                if (!isInitialRender) {
                    ListItem.pop();
                }
                ViewStackProcessor.StopGetAccessRecording();
            };
            const deepRenderFunction = (elmtId, isInitialRender) => {
                itemCreation(elmtId, isInitialRender);
                this.updateFuncByElmtId.set(elmtId, itemCreation);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.padding(8);
                    Column.borderRadius(23);
                    Column.backgroundColor(Color.White);
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Image.create({ "id": 16777289, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                    Image.width(30);
                    Image.height(30);
                    Image.objectFit(ImageFit.Contain);
                }, Image);
                Column.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create('微信');
                    Text.fontSize(10);
                    Text.margin({ top: 10 });
                }, Text);
                Text.pop();
                Column.pop();
                ListItem.pop();
            };
            this.observeComponentCreation(itemCreation);
            ListItem.pop();
        }
        {
            const itemCreation = (elmtId, isInitialRender) => {
                ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                ListItem.create(deepRenderFunction, true);
                if (!isInitialRender) {
                    ListItem.pop();
                }
                ViewStackProcessor.StopGetAccessRecording();
            };
            const deepRenderFunction = (elmtId, isInitialRender) => {
                itemCreation(elmtId, isInitialRender);
                this.updateFuncByElmtId.set(elmtId, itemCreation);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.padding(8);
                    Column.borderRadius(23);
                    Column.backgroundColor(Color.White);
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Image.create({ "id": 16777267, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                    Image.width(30);
                    Image.height(30);
                    Image.objectFit(ImageFit.Contain);
                }, Image);
                Column.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create('朋友圈');
                    Text.fontSize(10);
                    Text.margin({ top: 10 });
                }, Text);
                Text.pop();
                Column.pop();
                ListItem.pop();
            };
            this.observeComponentCreation(itemCreation);
            ListItem.pop();
        }
        {
            const itemCreation = (elmtId, isInitialRender) => {
                ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                ListItem.create(deepRenderFunction, true);
                if (!isInitialRender) {
                    ListItem.pop();
                }
                ViewStackProcessor.StopGetAccessRecording();
            };
            const deepRenderFunction = (elmtId, isInitialRender) => {
                itemCreation(elmtId, isInitialRender);
                this.updateFuncByElmtId.set(elmtId, itemCreation);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.padding(8);
                    Column.borderRadius(23);
                    Column.backgroundColor(Color.White);
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Image.create({ "id": 16777228, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                    Image.width(30);
                    Image.height(30);
                    Image.objectFit(ImageFit.Contain);
                }, Image);
                Column.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create('抖音好友');
                    Text.fontSize(10);
                    Text.margin({ top: 10 });
                }, Text);
                Text.pop();
                Column.pop();
                ListItem.pop();
            };
            this.observeComponentCreation(itemCreation);
            ListItem.pop();
        }
        {
            const itemCreation = (elmtId, isInitialRender) => {
                ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                ListItem.create(deepRenderFunction, true);
                if (!isInitialRender) {
                    ListItem.pop();
                }
                ViewStackProcessor.StopGetAccessRecording();
            };
            const deepRenderFunction = (elmtId, isInitialRender) => {
                itemCreation(elmtId, isInitialRender);
                this.updateFuncByElmtId.set(elmtId, itemCreation);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.padding(8);
                    Column.borderRadius(23);
                    Column.backgroundColor(Color.White);
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Image.create({ "id": 16777229, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                    Image.width(30);
                    Image.height(30);
                    Image.objectFit(ImageFit.Contain);
                }, Image);
                Column.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create('抖音日常');
                    Text.fontSize(10);
                    Text.margin({ top: 10 });
                }, Text);
                Text.pop();
                Column.pop();
                ListItem.pop();
            };
            this.observeComponentCreation(itemCreation);
            ListItem.pop();
        }
        {
            const itemCreation = (elmtId, isInitialRender) => {
                ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                ListItem.create(deepRenderFunction, true);
                if (!isInitialRender) {
                    ListItem.pop();
                }
                ViewStackProcessor.StopGetAccessRecording();
            };
            const deepRenderFunction = (elmtId, isInitialRender) => {
                itemCreation(elmtId, isInitialRender);
                this.updateFuncByElmtId.set(elmtId, itemCreation);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.padding(8);
                    Column.borderRadius(23);
                    Column.backgroundColor(Color.White);
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Image.create({ "id": 16777291, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                    Image.width(30);
                    Image.height(30);
                    Image.objectFit(ImageFit.Contain);
                }, Image);
                Column.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create('私信');
                    Text.fontSize(10);
                    Text.margin({ top: 10 });
                }, Text);
                Text.pop();
                Column.pop();
                ListItem.pop();
            };
            this.observeComponentCreation(itemCreation);
            ListItem.pop();
        }
        {
            const itemCreation = (elmtId, isInitialRender) => {
                ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                ListItem.create(deepRenderFunction, true);
                if (!isInitialRender) {
                    ListItem.pop();
                }
                ViewStackProcessor.StopGetAccessRecording();
            };
            const deepRenderFunction = (elmtId, isInitialRender) => {
                itemCreation(elmtId, isInitialRender);
                this.updateFuncByElmtId.set(elmtId, itemCreation);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.padding(8);
                    Column.borderRadius(23);
                    Column.backgroundColor(Color.White);
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Image.create({ "id": 16777290, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                    Image.width(30);
                    Image.height(30);
                    Image.objectFit(ImageFit.Contain);
                }, Image);
                Column.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create('系统分享');
                    Text.fontSize(10);
                    Text.margin({ top: 10 });
                }, Text);
                Text.pop();
                Column.pop();
                ListItem.pop();
            };
            this.observeComponentCreation(itemCreation);
            ListItem.pop();
        }
        {
            const itemCreation = (elmtId, isInitialRender) => {
                ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                ListItem.create(deepRenderFunction, true);
                if (!isInitialRender) {
                    ListItem.pop();
                }
                ViewStackProcessor.StopGetAccessRecording();
            };
            const deepRenderFunction = (elmtId, isInitialRender) => {
                itemCreation(elmtId, isInitialRender);
                this.updateFuncByElmtId.set(elmtId, itemCreation);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.padding(8);
                    Column.borderRadius(23);
                    Column.backgroundColor(Color.White);
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Image.create({ "id": 16777233, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                    Image.width(30);
                    Image.height(30);
                    Image.objectFit(ImageFit.Contain);
                }, Image);
                Column.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create('复制链接');
                    Text.fontSize(10);
                    Text.margin({ top: 10 });
                }, Text);
                Text.pop();
                Column.pop();
                ListItem.pop();
            };
            this.observeComponentCreation(itemCreation);
            ListItem.pop();
        }
        List.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.isTopMore) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.backgroundColor('#f2f3f5');
                        Column.height(100);
                        Column.padding(15);
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Divider.create();
                        Divider.strokeWidth(1);
                        Divider.color('#999');
                        Divider.width('100%');
                        Divider.opacity(0.3);
                        Divider.margin({ top: -10, bottom: 10 });
                    }, Divider);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        List.create({ space: 20 });
                        List.listDirection(Axis.Horizontal);
                        List.scrollBar(BarState.Off);
                    }, List);
                    {
                        const itemCreation = (elmtId, isInitialRender) => {
                            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                            ListItem.create(deepRenderFunction, true);
                            if (!isInitialRender) {
                                ListItem.pop();
                            }
                            ViewStackProcessor.StopGetAccessRecording();
                        };
                        const deepRenderFunction = (elmtId, isInitialRender) => {
                            itemCreation(elmtId, isInitialRender);
                            this.updateFuncByElmtId.set(elmtId, itemCreation);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Column.create();
                            }, Column);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Column.create();
                                Column.padding(8);
                                Column.borderRadius(23);
                                Column.backgroundColor(Color.White);
                            }, Column);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Image.create({ "id": 16777273, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                                Image.width(30);
                                Image.height(30);
                                Image.objectFit(ImageFit.Contain);
                            }, Image);
                            Column.pop();
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Text.create('收藏');
                                Text.fontSize(10);
                                Text.margin({ top: 10 });
                            }, Text);
                            Text.pop();
                            Column.pop();
                            ListItem.pop();
                        };
                        this.observeComponentCreation(itemCreation);
                        ListItem.pop();
                    }
                    {
                        const itemCreation = (elmtId, isInitialRender) => {
                            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                            ListItem.create(deepRenderFunction, true);
                            if (!isInitialRender) {
                                ListItem.pop();
                            }
                            ViewStackProcessor.StopGetAccessRecording();
                        };
                        const deepRenderFunction = (elmtId, isInitialRender) => {
                            itemCreation(elmtId, isInitialRender);
                            this.updateFuncByElmtId.set(elmtId, itemCreation);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Column.create();
                            }, Column);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Column.create();
                                Column.padding(8);
                                Column.borderRadius(23);
                                Column.backgroundColor(Color.White);
                            }, Column);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Image.create({ "id": 16777269, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                                Image.width(30);
                                Image.height(30);
                                Image.objectFit(ImageFit.Contain);
                            }, Image);
                            Column.pop();
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Text.create('稍后再看');
                                Text.fontSize(10);
                                Text.margin({ top: 10 });
                            }, Text);
                            Text.pop();
                            Column.pop();
                            ListItem.pop();
                        };
                        this.observeComponentCreation(itemCreation);
                        ListItem.pop();
                    }
                    {
                        const itemCreation = (elmtId, isInitialRender) => {
                            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                            ListItem.create(deepRenderFunction, true);
                            if (!isInitialRender) {
                                ListItem.pop();
                            }
                            ViewStackProcessor.StopGetAccessRecording();
                        };
                        const deepRenderFunction = (elmtId, isInitialRender) => {
                            itemCreation(elmtId, isInitialRender);
                            this.updateFuncByElmtId.set(elmtId, itemCreation);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Column.create();
                            }, Column);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Column.create();
                                Column.padding(8);
                                Column.borderRadius(23);
                                Column.backgroundColor(Color.White);
                            }, Column);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Image.create({ "id": 16777234, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                                Image.width(30);
                                Image.height(30);
                                Image.objectFit(ImageFit.Contain);
                            }, Image);
                            Column.pop();
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Text.create('内容举报');
                                Text.fontSize(10);
                                Text.margin({ top: 10 });
                            }, Text);
                            Text.pop();
                            Column.pop();
                            ListItem.pop();
                        };
                        this.observeComponentCreation(itemCreation);
                        ListItem.pop();
                    }
                    {
                        const itemCreation = (elmtId, isInitialRender) => {
                            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                            ListItem.create(deepRenderFunction, true);
                            if (!isInitialRender) {
                                ListItem.pop();
                            }
                            ViewStackProcessor.StopGetAccessRecording();
                        };
                        const deepRenderFunction = (elmtId, isInitialRender) => {
                            itemCreation(elmtId, isInitialRender);
                            this.updateFuncByElmtId.set(elmtId, itemCreation);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Column.create();
                            }, Column);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Column.create();
                                Column.padding(8);
                                Column.borderRadius(23);
                                Column.backgroundColor(Color.White);
                            }, Column);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Image.create({ "id": 16777232, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                                Image.width(30);
                                Image.height(30);
                                Image.objectFit(ImageFit.Contain);
                            }, Image);
                            Column.pop();
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Text.create('功能反馈');
                                Text.fontSize(10);
                                Text.margin({ top: 10 });
                            }, Text);
                            Text.pop();
                            Column.pop();
                            ListItem.pop();
                        };
                        this.observeComponentCreation(itemCreation);
                        ListItem.pop();
                    }
                    {
                        const itemCreation = (elmtId, isInitialRender) => {
                            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                            ListItem.create(deepRenderFunction, true);
                            if (!isInitialRender) {
                                ListItem.pop();
                            }
                            ViewStackProcessor.StopGetAccessRecording();
                        };
                        const deepRenderFunction = (elmtId, isInitialRender) => {
                            itemCreation(elmtId, isInitialRender);
                            this.updateFuncByElmtId.set(elmtId, itemCreation);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Column.create();
                            }, Column);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Column.create();
                                Column.padding(8);
                                Column.borderRadius(23);
                                Column.backgroundColor(Color.White);
                            }, Column);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Image.create({ "id": 16777292, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                                Image.width(30);
                                Image.height(30);
                                Image.objectFit(ImageFit.Contain);
                            }, Image);
                            Column.pop();
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Text.create('字体设置');
                                Text.fontSize(10);
                                Text.margin({ top: 10 });
                            }, Text);
                            Text.pop();
                            Column.pop();
                            ListItem.pop();
                        };
                        this.observeComponentCreation(itemCreation);
                        ListItem.pop();
                    }
                    {
                        const itemCreation = (elmtId, isInitialRender) => {
                            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                            ListItem.create(deepRenderFunction, true);
                            if (!isInitialRender) {
                                ListItem.pop();
                            }
                            ViewStackProcessor.StopGetAccessRecording();
                        };
                        const deepRenderFunction = (elmtId, isInitialRender) => {
                            itemCreation(elmtId, isInitialRender);
                            this.updateFuncByElmtId.set(elmtId, itemCreation);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Column.create();
                            }, Column);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Column.create();
                                Column.padding(8);
                                Column.borderRadius(23);
                                Column.backgroundColor(Color.White);
                            }, Column);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Image.create({ "id": 16777272, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                                Image.width(30);
                                Image.height(30);
                                Image.objectFit(ImageFit.Contain);
                            }, Image);
                            Column.pop();
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Text.create('深色模式');
                                Text.fontSize(10);
                                Text.margin({ top: 10 });
                            }, Text);
                            Text.pop();
                            Column.pop();
                            ListItem.pop();
                        };
                        this.observeComponentCreation(itemCreation);
                        ListItem.pop();
                    }
                    List.pop();
                    Column.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.height(30);
            Column.padding({ top: 10 });
            Column.onClick(() => {
                this.isShare = false;
                this.isTopMore = false;
                Context.animateTo({
                    duration: 100,
                    curve: Curve.Friction,
                    iterations: 1,
                    playMode: PlayMode.Alternate,
                }, () => {
                    this.shareHeight = 0;
                    this.shareOpacity = 0;
                });
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('取消');
            Text.fontSize(15);
            Text.fontColor('#000');
        }, Text);
        Text.pop();
        Column.pop();
        Column.pop();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create({ alignContent: Alignment.Center });
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create({ alignContent: Alignment.Bottom });
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.overlay({ builder: () => {
                    this.LargeOverlayNode.call(this);
                } }, { align: Alignment.Center });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.padding({ top: 20, left: 10, right: 10 });
            Column.height('10%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.padding({ right: 8 });
            Column.onClick(() => {
                router.back();
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ImageSpan.create({ "id": 16777246, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
            ImageSpan.width(18);
            ImageSpan.height(18);
            ImageSpan.objectFit(ImageFit.Contain);
        }, ImageSpan);
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Search.create({ placeholder: '搜你想看的' });
            Search.height(40);
            Search.backgroundColor("#f1f3f4");
            Search.placeholderColor(Color.Grey);
            Search.placeholderFont({ size: 12 });
        }, Search);
        Search.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.margin({ left: 12, right: 15 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ImageSpan.create({ "id": 16777236, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
            ImageSpan.width(18);
            ImageSpan.height(18);
            ImageSpan.objectFit(ImageFit.Contain);
        }, ImageSpan);
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.onClick(() => {
                this.isTopMore = true;
                Context.animateTo({
                    duration: 300,
                    curve: Curve.Smooth,
                    playMode: PlayMode.Normal,
                }, () => {
                    this.shareHeight = 250;
                    this.shareOpacity = 1;
                });
                this.isShare = true;
                this.shareOverLay = 'share';
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ImageSpan.create({ "id": 16777242, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
            ImageSpan.width(20);
            ImageSpan.height(20);
            ImageSpan.objectFit(ImageFit.Contain);
        }, ImageSpan);
        Column.pop();
        Flex.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.height('82%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Scroll.create(this.scroller);
            Scroll.scrollBarWidth(3);
            Scroll.onScroll(() => {
                if (this.scroller.isAtEnd()) {
                    let remainder = this.comment_count % 10;
                    if (remainder) {
                        if (this.review.length == this.comment_count) {
                            this.isLoadAll = true;
                            return;
                        }
                        else {
                            if (this.review.length == (this.comment_count - remainder)) {
                                this.review = this.review.concat(getReviewList(remainder));
                            }
                            else {
                                this.review = this.review.concat(getReviewList(10));
                            }
                        }
                    }
                    else {
                        if (this.review.length !== this.comment_count) {
                            this.review = this.review.concat(getReviewList(10));
                        }
                        else {
                            this.isLoadAll = true;
                            return;
                        }
                    }
                }
            });
        }, Scroll);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.padding(10);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.padding({ left: 10, right: 10, top: 15, bottom: 15 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.title);
            Text.textAlign(TextAlign.Start);
            Text.width('100%');
            Text.fontWeight(FontWeight.Bold);
            Text.fontSize(18);
            Text.letterSpacing(2);
            Text.id('textTitle');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center });
            Flex.padding({ top: 15 });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('85%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.borderRadius(13);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create(this.avatar_url);
            Image.height(30);
            Image.width(30);
            Image.objectFit(ImageFit.Contain);
            Image.overlay({ builder: () => {
                    this.OverlayNode.call(this);
                } }, { align: Alignment.Center });
            Image.borderRadius(15);
        }, Image);
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.padding({ left: 10, right: 10 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.source);
            Text.fontSize(12);
            Text.width('100%');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${formatDate(this.publish_time)} ${WhereRandom} ${this.source}`);
            Text.fontSize(10);
            Text.fontColor(Color.Grey);
            Text.width('100%');
        }, Text);
        Text.pop();
        Column.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.height(22);
            Button.width(45);
            Button.backgroundColor('#f04142');
            Button.onClick(() => {
                this.shareOverLay = 'watch';
                this.isShare = true;
                this.isLoading = true;
                Context.animateTo({
                    duration: 500,
                    curve: Curve.Smooth,
                    playMode: PlayMode.Normal,
                }, () => {
                    this.isLogIn = true;
                });
            });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.isLoading) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Image.create({ "id": 16777266, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                        Image.height(22);
                        Image.width(22);
                    }, Image);
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('关注');
                        Text.fontSize(12);
                        Text.fontColor('#fff');
                        Text.textAlign(TextAlign.Center);
                    }, Text);
                    Text.pop();
                });
            }
        }, If);
        If.pop();
        Button.pop();
        Flex.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.content);
            Text.letterSpacing(2);
            Text.fontSize(16);
            Text.margin({ top: 5, bottom: 5 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.image_list.length) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        ForEach.create();
                        const forEachItemGenFunction = (_item, i: number) => {
                            const t = _item;
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Column.create();
                                Column.margin({ bottom: 20 });
                            }, Column);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Image.create(t.url);
                                Image.height(300);
                                Image.width(300);
                            }, Image);
                            Column.pop();
                        };
                        this.forEachUpdateFunction(elmtId, this.image_list, forEachItemGenFunction, undefined, true, false);
                    }, ForEach);
                    ForEach.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        Column.pop();
        this.Review.bind(this)();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.isLoadAll) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.height(100);
                        Column.margin({ top: 20 });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('已显示全部评论');
                        Text.fontColor('#999');
                        Text.fontSize(14);
                    }, Text);
                    Text.pop();
                    Column.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        Column.pop();
        Scroll.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center });
            Flex.padding({ left: 10, right: 10, bottom: 10 });
            Flex.backgroundColor(Color.White);
            Flex.height('8%');
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center });
            Flex.onClick(() => {
                Context.animateTo({
                    duration: 300,
                    curve: Curve.Smooth,
                    playMode: PlayMode.Normal,
                }, () => {
                    this.shareHeight = 150;
                    this.shareOpacity = 1;
                });
                this.isShare = true;
                this.shareOverLay = 'share';
            });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777261, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
            Image.width(20);
            Image.height(20);
            Image.objectFit(ImageFit.Contain);
            Image.margin({ right: 8 });
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('分享');
        }, Text);
        Text.pop();
        Flex.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center });
            Flex.onClick(() => {
                let rect = Utils.getComponentRect('review');
                let rectY = rect.top + (rect.bottom - rect.top) / 2;
                let currentOffset = this.scroller.currentOffset().yOffset;
                this.scroller.scrollTo({ xOffset: 0, yOffset: rectY - currentOffset, animation: {
                        duration: 500,
                        curve: Curve.Linear
                    } });
            });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777260, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
            Image.width(20);
            Image.height(20);
            Image.objectFit(ImageFit.Contain);
            Image.margin({ right: 8 });
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${this.comment_count}`);
        }, Text);
        Text.pop();
        Flex.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center });
            Flex.onClick(() => {
                this.shareOverLay = 'love';
                this.isShare = true;
                Context.animateTo({
                    duration: 500,
                    curve: Curve.Smooth,
                    playMode: PlayMode.Normal,
                }, () => {
                    this.isLogIn = true;
                });
            });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777241, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
            Image.width(20);
            Image.height(20);
            Image.objectFit(ImageFit.Contain);
            Image.margin({ right: 8 });
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${this.digg_count}`);
        }, Text);
        Text.pop();
        Flex.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center });
            Flex.onClick(() => {
                this.shareOverLay = 'collect';
                this.isShare = true;
                Context.animateTo({
                    duration: 500,
                    curve: Curve.Smooth,
                    playMode: PlayMode.Normal,
                }, () => {
                    this.isLogIn = true;
                });
            });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777235, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
            Image.width(20);
            Image.height(20);
            Image.objectFit(ImageFit.Contain);
            Image.margin({ right: 8 });
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('556');
        }, Text);
        Text.pop();
        Flex.pop();
        Flex.pop();
        Column.pop();
        this.ShareColumn.bind(this)();
        Stack.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.isLogIn) {
                this.ifElseBranchUpdateFunction(0, () => {
                    {
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            if (isInitialRender) {
                                let paramsLambda = () => {
                                    return {
                                        isLogIn: this.isLogIn,
                                        isShare: this.isShare,
                                        shareOverLay: this.shareOverLay,
                                        isLoading: this.isLoading
                                    };
                                };
                                ViewPU.create(new LogIn(this, {
                                    isLogIn: this.__isLogIn,
                                    isShare: this.__isShare,
                                    shareOverLay: this.__shareOverLay,
                                    isLoading: this.__isLoading
                                }, undefined, elmtId, paramsLambda, { page: "entry/src/main/ets/pages/NewsDetail.ets", line: 785 }));
                            }
                            else {
                                this.updateStateVarsOfChildByElmtId(elmtId, {});
                            }
                        }, null);
                    }
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        Stack.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
ViewStackProcessor.StartGetAccessRecordingFor(ViewStackProcessor.AllocateNewElmetIdForNextComponent());
loadDocument(new NewDetails(undefined, {}));
ViewStackProcessor.StopGetAccessRecording();
