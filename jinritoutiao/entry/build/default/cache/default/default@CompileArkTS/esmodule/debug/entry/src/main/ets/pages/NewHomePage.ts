interface NewHomePage_Params {
    scroller?: Scroller;
    news?: NewsSource;
    isShow?: boolean;
    isLoading?: boolean;
    touchOld?: number;
}
import { NewHomeItem } from "@bundle:com.example.jinritoutiao/entry/ets/pages/components/NewHomeItem";
import { homePageRequest } from "@bundle:com.example.jinritoutiao/entry/ets/pages/util/Request";
import type { NewsItem } from "@bundle:com.example.jinritoutiao/entry/ets/pages/util/Request";
import promptAction from "@ohos:promptAction";
import { NewsSource } from "@bundle:com.example.jinritoutiao/entry/ets/pages/util/NewsLazy";
import { OfflinePage } from "@bundle:com.example.jinritoutiao/entry/ets/pages/components/OfflinePage";
export class NewHomePage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.scroller = new Scroller();
        this.__news = new ObservedPropertyObjectPU(new NewsSource(), this, "news");
        this.__isShow = new ObservedPropertySimplePU(false, this, "isShow");
        this.__isLoading = new ObservedPropertySimplePU(false, this, "isLoading");
        this.__touchOld = new ObservedPropertySimplePU(0, this, "touchOld");
        this.setInitiallyProvidedValue(params);
        this.declareWatch("isShow", this.getNews);
    }
    setInitiallyProvidedValue(params: NewHomePage_Params) {
        if (params.scroller !== undefined) {
            this.scroller = params.scroller;
        }
        if (params.news !== undefined) {
            this.news = params.news;
        }
        if (params.isShow !== undefined) {
            this.isShow = params.isShow;
        }
        if (params.isLoading !== undefined) {
            this.isLoading = params.isLoading;
        }
        if (params.touchOld !== undefined) {
            this.touchOld = params.touchOld;
        }
    }
    updateStateVars(params: NewHomePage_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__news.purgeDependencyOnElmtId(rmElmtId);
        this.__isShow.purgeDependencyOnElmtId(rmElmtId);
        this.__isLoading.purgeDependencyOnElmtId(rmElmtId);
        this.__touchOld.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__news.aboutToBeDeleted();
        this.__isShow.aboutToBeDeleted();
        this.__isLoading.aboutToBeDeleted();
        this.__touchOld.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private scroller: Scroller;
    private __news: ObservedPropertyObjectPU<NewsSource>;
    get news() {
        return this.__news.get();
    }
    set news(newValue: NewsSource) {
        this.__news.set(newValue);
    }
    private __isShow: ObservedPropertySimplePU<boolean>;
    get isShow() {
        return this.__isShow.get();
    }
    set isShow(newValue: boolean) {
        this.__isShow.set(newValue);
    }
    private __isLoading: ObservedPropertySimplePU<boolean>;
    get isLoading() {
        return this.__isLoading.get();
    }
    set isLoading(newValue: boolean) {
        this.__isLoading.set(newValue);
    }
    private __touchOld: ObservedPropertySimplePU<number>;
    get touchOld() {
        return this.__touchOld.get();
    }
    set touchOld(newValue: number) {
        this.__touchOld.set(newValue);
    }
    aboutToAppear() {
        homePageRequest().then(res => {
            this.news.news = res;
        }).catch(() => {
            promptAction.showToast({ message: '请连接网络或者更换url' });
            this.isShow = false;
        });
    }
    getNews() {
        if (this.isShow) {
            homePageRequest().then(res => {
                this.news.news = res;
                this.isShow = false;
            }).catch(() => {
                promptAction.showToast({ message: '请连接网络或者更换url' });
                this.isShow = false;
            });
        }
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.height('88%');
            Column.margin({ bottom: 70 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.news.totalCount() == 0) {
                this.ifElseBranchUpdateFunction(0, () => {
                    {
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            if (isInitialRender) {
                                let paramsLambda = () => {
                                    return {
                                        isShow: this.isShow
                                    };
                                };
                                ViewPU.create(new OfflinePage(this, { isShow: this.__isShow }, undefined, elmtId, paramsLambda, { page: "entry/src/main/ets/pages/NewHomePage.ets", line: 39 }));
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
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        List.create({ scroller: this.scroller });
                        List.edgeEffect(EdgeEffect.None);
                        List.onScrollIndex((first: number, last: number) => {
                            let total: number = this.news.totalCount() - 2;
                            if (last > total) {
                                homePageRequest().then(res => {
                                    this.news.addBatchData(res);
                                }).catch(() => {
                                    promptAction.showToast({ message: '请连接网络或者更换url' });
                                });
                            }
                        });
                    }, List);
                    {
                        const __lazyForEachItemGenFunction = (_item, i: number) => {
                            const t = _item;
                            {
                                const itemCreation = (elmtId, isInitialRender) => {
                                    ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                                    ListItem.create(() => { }, false);
                                    ListItem.padding({ left: 15, right: 15 });
                                    if (!isInitialRender) {
                                        ListItem.pop();
                                    }
                                    ViewStackProcessor.StopGetAccessRecording();
                                };
                                const observedDeepRender = () => {
                                    this.observeComponentCreation(itemCreation);
                                    {
                                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                                            if (isInitialRender) {
                                                let paramsLambda = () => {
                                                    return {
                                                        t: t,
                                                        i: i
                                                    };
                                                };
                                                ViewPU.create(new NewHomeItem(this, { t: t, i: i }, undefined, elmtId, paramsLambda, { page: "entry/src/main/ets/pages/NewHomePage.ets", line: 44 }));
                                            }
                                            else {
                                                this.updateStateVarsOfChildByElmtId(elmtId, {
                                                    t: t, i: i
                                                });
                                            }
                                        }, null);
                                    }
                                    ListItem.pop();
                                };
                                observedDeepRender();
                            }
                        };
                        LazyForEach.create("1", this, this.news, __lazyForEachItemGenFunction);
                        LazyForEach.pop();
                    }
                    List.pop();
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
