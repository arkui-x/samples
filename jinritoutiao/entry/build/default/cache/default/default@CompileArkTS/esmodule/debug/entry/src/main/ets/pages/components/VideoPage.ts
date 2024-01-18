interface VideoPage_Params {
    videoList?: NewsItem[];
    scroller?: Scroller;
    isShow?: boolean;
}
import { homePageRequest } from "@bundle:com.example.jinritoutiao/entry/ets/pages/util/Request";
import type { NewsItem } from "@bundle:com.example.jinritoutiao/entry/ets/pages/util/Request";
import { TopSearch } from "@bundle:com.example.jinritoutiao/entry/ets/pages/components/TopSearch";
import promptAction from "@ohos:promptAction";
import { VideoItem } from "@bundle:com.example.jinritoutiao/entry/ets/pages/components/VideoItem";
import { OfflinePage } from "@bundle:com.example.jinritoutiao/entry/ets/pages/components/OfflinePage";
export class VideoPage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__videoList = new ObservedPropertyObjectPU([], this, "videoList");
        this.scroller = new Scroller();
        this.__isShow = new ObservedPropertySimplePU(false, this, "isShow");
        this.setInitiallyProvidedValue(params);
        this.declareWatch("isShow", this.getNews);
    }
    setInitiallyProvidedValue(params: VideoPage_Params) {
        if (params.videoList !== undefined) {
            this.videoList = params.videoList;
        }
        if (params.scroller !== undefined) {
            this.scroller = params.scroller;
        }
        if (params.isShow !== undefined) {
            this.isShow = params.isShow;
        }
    }
    updateStateVars(params: VideoPage_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__videoList.purgeDependencyOnElmtId(rmElmtId);
        this.__isShow.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__videoList.aboutToBeDeleted();
        this.__isShow.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __videoList: ObservedPropertyObjectPU<NewsItem[]>;
    get videoList() {
        return this.__videoList.get();
    }
    set videoList(newValue: NewsItem[]) {
        this.__videoList.set(newValue);
    }
    private scroller: Scroller;
    private __isShow: ObservedPropertySimplePU<boolean>;
    get isShow() {
        return this.__isShow.get();
    }
    set isShow(newValue: boolean) {
        this.__isShow.set(newValue);
    }
    getNews() {
        if (this.isShow) {
            homePageRequest('video').then(res => {
                this.videoList = res;
                this.isShow = false;
                console.log('isShow', '请求中');
            }).catch(() => {
                promptAction.showToast({ message: '请连接网络或者更换url' });
                console.log('isShow', '请求失败');
                this.isShow = false;
            });
        }
    }
    aboutToAppear() {
        homePageRequest('video').then(res => {
            this.videoList = res;
            this.isShow = false;
        }).catch(() => {
            promptAction.showToast({ message: '请连接网络或者更换url' });
            this.isShow = false;
        });
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.height('100%');
        }, Column);
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let paramsLambda = () => {
                        return {};
                    };
                    ViewPU.create(new TopSearch(this, {}, undefined, elmtId, paramsLambda, { page: "entry/src/main/ets/pages/components/VideoPage.ets", line: 39 }));
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {});
                }
            }, null);
        }
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.videoList.length == 0) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.margin({ top: 50 });
                    }, Column);
                    {
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            if (isInitialRender) {
                                let paramsLambda = () => {
                                    return {
                                        isShow: this.isShow
                                    };
                                };
                                ViewPU.create(new OfflinePage(this, { isShow: this.__isShow }, undefined, elmtId, paramsLambda, { page: "entry/src/main/ets/pages/components/VideoPage.ets", line: 42 }));
                            }
                            else {
                                this.updateStateVarsOfChildByElmtId(elmtId, {});
                            }
                        }, null);
                    }
                    Column.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        List.create({ scroller: this.scroller, space: 15 });
                        List.edgeEffect(EdgeEffect.None);
                        List.height('90%');
                        List.padding({ top: 15 });
                    }, List);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        ForEach.create();
                        const forEachItemGenFunction = (_item, i: number) => {
                            const t = _item;
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                If.create();
                                if (t.has_video) {
                                    this.ifElseBranchUpdateFunction(0, () => {
                                        {
                                            const itemCreation = (elmtId, isInitialRender) => {
                                                ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                                                ListItem.create(deepRenderFunction, true);
                                                ListItem.padding({ left: 15, right: 15 });
                                                if (!isInitialRender) {
                                                    ListItem.pop();
                                                }
                                                ViewStackProcessor.StopGetAccessRecording();
                                            };
                                            const deepRenderFunction = (elmtId, isInitialRender) => {
                                                itemCreation(elmtId, isInitialRender);
                                                this.updateFuncByElmtId.set(elmtId, itemCreation);
                                                {
                                                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                        if (isInitialRender) {
                                                            let paramsLambda = () => {
                                                                return {
                                                                    t: t,
                                                                    i: i
                                                                };
                                                            };
                                                            ViewPU.create(new VideoItem(this, {
                                                                t: t,
                                                                i: i,
                                                            }, undefined, elmtId, paramsLambda, { page: "entry/src/main/ets/pages/components/VideoPage.ets", line: 50 }));
                                                        }
                                                        else {
                                                            this.updateStateVarsOfChildByElmtId(elmtId, {
                                                                t: t,
                                                                i: i
                                                            });
                                                        }
                                                    }, null);
                                                }
                                                ListItem.pop();
                                            };
                                            this.observeComponentCreation(itemCreation);
                                            ListItem.pop();
                                        }
                                    });
                                }
                                else {
                                    this.ifElseBranchUpdateFunction(1, () => {
                                    });
                                }
                            }, If);
                            If.pop();
                        };
                        this.forEachUpdateFunction(elmtId, this.videoList, forEachItemGenFunction, (t: NewsItem, i: number) => i.toString(), true, true);
                    }, ForEach);
                    ForEach.pop();
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
