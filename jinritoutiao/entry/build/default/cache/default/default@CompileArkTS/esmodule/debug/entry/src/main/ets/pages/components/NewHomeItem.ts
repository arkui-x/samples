interface NewHomeItem_Params {
    t?: NewsItem;
    i?: number;
}
import type { ImageList, NewsItem } from '../util/Request';
import router from "@ohos:router";
import { getTimeStr } from "@bundle:com.example.jinritoutiao/entry/ets/pages/util/Common";
export class NewHomeItem extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__t = new SynchedPropertyObjectOneWayPU(params.t, this, "t");
        this.__i = new SynchedPropertySimpleOneWayPU(params.i, this, "i");
        this.setInitiallyProvidedValue(params);
    }
    setInitiallyProvidedValue(params: NewHomeItem_Params) {
    }
    updateStateVars(params: NewHomeItem_Params) {
        this.__t.reset(params.t);
        this.__i.reset(params.i);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__t.purgeDependencyOnElmtId(rmElmtId);
        this.__i.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__t.aboutToBeDeleted();
        this.__i.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
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
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.padding({ bottom: 10 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.i < 5 && this.t.title) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Flex.create({ direction: FlexDirection.Column, alignItems: ItemAlign.Start });
                        Flex.height(45);
                        Flex.onClick(() => {
                            if (this.t.image_type === 'single') {
                                router.pushUrl({
                                    url: "pages/NewsDetail",
                                    params: {
                                        source: this.t.source,
                                        digg_count: this.t.digg_count,
                                        title: this.t.title,
                                        comment_count: this.t.comment_count,
                                        publish_time: this.t.publish_time,
                                        share_count: this.t.share_count,
                                        avatar_url: this.t.user_info.avatar_url,
                                        content: this.t.Abstract,
                                        image_list: this.t.middle_image
                                    }
                                });
                            }
                            if (this.t.image_type === 'list') {
                                router.pushUrl({
                                    url: "pages/NewsDetail",
                                    params: {
                                        source: this.t.source,
                                        digg_count: this.t.digg_count,
                                        title: this.t.title,
                                        comment_count: this.t.comment_count,
                                        publish_time: this.t.publish_time,
                                        share_count: this.t.share_count,
                                        avatar_url: this.t.user_info.avatar_url,
                                        content: this.t.Abstract,
                                        image_list: this.t.image_list
                                    }
                                });
                            }
                        });
                    }, Flex);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(this.t.title);
                        Text.fontSize(15);
                        Text.margin({ bottom: 5 });
                        Text.maxLines(1);
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Flex.create();
                    }, Flex);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('置顶');
                        Text.fontColor('#f04142');
                        Text.fontSize(12);
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(this.t.source);
                        Text.fontColor('#999999');
                        Text.fontSize(12);
                        Text.margin({ left: 10, right: 10 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(`${this.t.comment_count} 评论`);
                        Text.fontColor('#999999');
                        Text.fontSize(12);
                    }, Text);
                    Text.pop();
                    Flex.pop();
                    Flex.pop();
                    Column.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        If.create();
                        if (this.i == 4) {
                            this.ifElseBranchUpdateFunction(0, () => {
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    Divider.create();
                                    Divider.strokeWidth(1);
                                    Divider.color(Color.Grey);
                                    Divider.width('100%');
                                    Divider.opacity(0.2);
                                    Divider.margin({ top: 10 });
                                }, Divider);
                            });
                        }
                        else {
                            this.ifElseBranchUpdateFunction(1, () => {
                            });
                        }
                    }, If);
                    If.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        If.create();
                        if (this.t.title) {
                            this.ifElseBranchUpdateFunction(0, () => {
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    If.create();
                                    if (this.t.image_type === 'list') {
                                        this.ifElseBranchUpdateFunction(0, () => {
                                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                Flex.create({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Start });
                                                Flex.height(160);
                                                Flex.onClick(() => {
                                                    router.pushUrl({
                                                        url: "pages/NewsDetail",
                                                        params: {
                                                            source: this.t.source,
                                                            digg_count: this.t.digg_count,
                                                            title: this.t.title,
                                                            comment_count: this.t.comment_count,
                                                            publish_time: this.t.publish_time,
                                                            share_count: this.t.share_count,
                                                            avatar_url: this.t.user_info.avatar_url,
                                                            content: this.t.Abstract,
                                                            image_list: this.t.image_list
                                                        }
                                                    });
                                                });
                                            }, Flex);
                                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                Text.create(this.t.title);
                                                Text.fontSize(15);
                                                Text.margin({ bottom: 10 });
                                                Text.maxLines(1);
                                            }, Text);
                                            Text.pop();
                                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                Flex.create({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Start });
                                                Flex.height(90);
                                                Flex.margin({ bottom: 10 });
                                            }, Flex);
                                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                ForEach.create();
                                                const forEachItemGenFunction = (_item, i: number) => {
                                                    const t = _item;
                                                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                        Column.create();
                                                    }, Column);
                                                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                        Image.create(t.url);
                                                        Image.height(90);
                                                        Image.width(98);
                                                    }, Image);
                                                    Column.pop();
                                                };
                                                this.forEachUpdateFunction(elmtId, this.t.image_list, forEachItemGenFunction, undefined, true, false);
                                            }, ForEach);
                                            ForEach.pop();
                                            Flex.pop();
                                            this.observeComponentCreation2((elmtId, isInitialRender) => {
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
                                            Flex.pop();
                                            Flex.pop();
                                        });
                                    }
                                    else {
                                        this.ifElseBranchUpdateFunction(1, () => {
                                        });
                                    }
                                }, If);
                                If.pop();
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    If.create();
                                    if (this.t.image_type === 'single') {
                                        this.ifElseBranchUpdateFunction(0, () => {
                                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                Flex.create({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center });
                                                Flex.height(100);
                                                Flex.width('100%');
                                                Flex.onClick(() => {
                                                    router.pushUrl({
                                                        url: "pages/NewsDetail",
                                                        params: {
                                                            source: this.t.source,
                                                            digg_count: this.t.digg_count,
                                                            title: this.t.title,
                                                            comment_count: this.t.comment_count,
                                                            publish_time: this.t.publish_time,
                                                            share_count: this.t.share_count,
                                                            avatar_url: this.t.user_info.avatar_url,
                                                            content: this.t.Abstract,
                                                            image_list: [this.t.middle_image]
                                                        }
                                                    });
                                                });
                                            }, Flex);
                                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                Flex.create({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Start });
                                                Flex.width('70%');
                                                Flex.margin({ right: 10 });
                                            }, Flex);
                                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                Text.create(this.t.title);
                                                Text.fontSize(15);
                                                Text.margin({ bottom: 10 });
                                                Text.maxLines(2);
                                            }, Text);
                                            Text.pop();
                                            this.observeComponentCreation2((elmtId, isInitialRender) => {
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
                                            Flex.pop();
                                            Flex.pop();
                                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                Column.create();
                                            }, Column);
                                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                Image.create(this.t.middle_image.url);
                                                Image.height(90);
                                                Image.width(130);
                                            }, Image);
                                            Column.pop();
                                            Flex.pop();
                                        });
                                    }
                                    else {
                                        this.ifElseBranchUpdateFunction(1, () => {
                                        });
                                    }
                                }, If);
                                If.pop();
                            });
                        }
                        else {
                            this.ifElseBranchUpdateFunction(1, () => {
                            });
                        }
                    }, If);
                    If.pop();
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
