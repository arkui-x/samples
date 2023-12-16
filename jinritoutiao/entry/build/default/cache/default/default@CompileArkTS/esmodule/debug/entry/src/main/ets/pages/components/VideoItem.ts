interface VideoItem_Params {
    controller?: VideoController;
    t?: NewsItem;
    i?: number;
    isPlay?: boolean;
}
import { getTimeStr, getVideoRandom } from "@bundle:com.example.jinritoutiao/entry/ets/pages/util/Common";
import type { NewsItem } from '../util/Request';
export class VideoItem extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.controller = new VideoController();
        this.__t = new SynchedPropertyObjectOneWayPU(params.t, this, "t");
        this.__i = new SynchedPropertySimpleOneWayPU(params.i, this, "i");
        this.__isPlay = new ObservedPropertySimplePU(false, this, "isPlay");
        this.setInitiallyProvidedValue(params);
    }
    setInitiallyProvidedValue(params: VideoItem_Params) {
        if (params.controller !== undefined) {
            this.controller = params.controller;
        }
        if (params.isPlay !== undefined) {
            this.isPlay = params.isPlay;
        }
    }
    updateStateVars(params: VideoItem_Params) {
        this.__t.reset(params.t);
        this.__i.reset(params.i);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__t.purgeDependencyOnElmtId(rmElmtId);
        this.__i.purgeDependencyOnElmtId(rmElmtId);
        this.__isPlay.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__t.aboutToBeDeleted();
        this.__i.aboutToBeDeleted();
        this.__isPlay.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private controller: VideoController;
    private __t: SynchedPropertySimpleOneWayPU<NewsItem>;
    get t() {
        return this.__t.get();
    }
    set t(newValue: NewsItem) {
        this.__t.set(newValue);
    }
    private __i: SynchedPropertySimpleOneWayPU<number>;
    get i() {
        return this.__i.get();
    }
    set i(newValue: number) {
        this.__i.set(newValue);
    }
    private __isPlay: ObservedPropertySimplePU<boolean>;
    get isPlay() {
        return this.__isPlay.get();
    }
    set isPlay(newValue: boolean) {
        this.__isPlay.set(newValue);
    }
    VideoOverlay(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.height('80%');
            Column.width('90%');
            Column.alignItems(HorizontalAlign.Center);
            Column.onClick(() => {
                this.isPlay = false;
                this.controller.pause();
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (!this.isPlay) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.position({ x: '50%', y: '50%' });
                        Column.translate({ x: '-50%', y: '-50%' });
                        Column.onClick(() => {
                            this.isPlay = true;
                            this.controller.start();
                        });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Image.create({ "id": 16777225, "type": 20000, params: [], "bundleName": "com.example.jinritoutiao", "moduleName": "entry" });
                        Image.height(30);
                        Image.width(30);
                    }, Image);
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
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 20 });
            Column.height(365);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center });
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
            Image.create(this.t.user_info.avatar_url);
            Image.height(30);
            Image.width(30);
            Image.objectFit(ImageFit.Contain);
            Image.borderRadius(15);
        }, Image);
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.padding({ left: 10, right: 10 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.t.source);
            Text.fontSize(12);
            Text.width('100%');
        }, Text);
        Text.pop();
        Column.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.height(22);
            Button.width(50);
            Button.backgroundColor(Color.White);
            Button.border({ width: 1, color: '#999' });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('关注');
            Text.fontSize(12);
            Text.fontColor(Color.Black);
            Text.textAlign(TextAlign.Center);
        }, Text);
        Text.pop();
        Button.pop();
        Flex.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ direction: FlexDirection.Column, alignItems: ItemAlign.Start });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // title
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.t.title);
            Text.fontSize(15);
            Text.maxLines(2);
        }, Text);
        Text.pop();
        // title
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            //video
            Column.create();
            //video
            Column.height(240);
            //video
            Column.width('100%');
            //video
            Column.overlay({ builder: () => {
                    this.VideoOverlay.call(this);
                } });
            //video
            Column.margin({ top: 15, bottom: 15 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Video.create({
                src: getVideoRandom('src'),
                previewUri: getVideoRandom('uri'),
                controller: this.controller
            });
            Video.height(240);
            Video.width('100%');
            Video.objectFit(ImageFit.Cover);
            Video.controls(false);
        }, Video);
        //video
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 来源
            Flex.create();
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.t.source);
            Text.fontColor('#999999');
            Text.fontSize(12);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${this.t.comment_count} 评论`);
            Text.fontColor('#999999');
            Text.fontSize(12);
            Text.margin({ left: 10, right: 10 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(getTimeStr(this.t.behot_time - this.t.publish_time));
            Text.fontColor('#999999');
            Text.fontSize(12);
        }, Text);
        Text.pop();
        // 来源
        Flex.pop();
        Flex.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
