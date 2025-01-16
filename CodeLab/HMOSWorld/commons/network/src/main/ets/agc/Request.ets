/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { connection } from '@kit.NetworkKit';
import cloud, { FunctionResult } from '@hw-agconnect/cloud';
import {
  Achieve,
  HomeResources,
  LearningResource,
  Logger,
  PlatformInfo,
  PlatformTypeEnum,
  ResourcesType,
  ResponseData,
  Topic,
  TopicType,
  UserAccount,
  UserTypeEnum
} from '@ohos/utils';
import ErrorCode from '../constants/ErrorCodeConstants';
import RequestTrigger from '../constants/RequestTrigger';

const MAX_RETRIES = 3;
const TAG = '[Request]';

interface RejectError {
  code: number;
  message: string;
}

function getLoginData(): Promise<UserAccount> {
  return new Promise((resolve: (data: UserAccount) => void, reject: (() => void)) => {
    let result: UserAccount = {
      id: 'u0000001',
      username: 'developer1',
      userType: UserTypeEnum.HMOS,
      nickname: 'developer1',
      unionId: '',
      password: '123456',
      portrait: 'https://agc-storage-drcn.platform.dbankcloud.cn/v0/default-bucket-uvna9/header.png?token=15b04ff1-8efa-47e6-9e42-245b8726315b',
      description: '欢迎来到HarmonyOS世界'
    }
    resolve(result);
  });
}

function getThemeData(): Promise<Topic[]> {
  return new Promise(async (resolve: (data: Topic[]) => void, reject: (() => void)) => {
    let f001: Topic = new Topic();
    f001.id = 'f001';
    f001.name = '资讯类';
    f001.type = TopicType.FEED;
    f001.isFollowed = true;
    let t001: Topic = new Topic();
    t001.id = 't001';
    t001.name = '文章类';
    t001.type = TopicType.TOPIC;
    t001.isFollowed = false;
    let result: Topic[] = [f001, t001];
    resolve(result);
  });
}

function getHomeResources(): Promise<HomeResources> {
  return new Promise(
    (resolve: (value: HomeResources | PromiseLike<HomeResources>) => void, reject: (reason?: Object) => void) => {
      let bannerList: LearningResource[] = []
      let bannerListData = new LearningResource();
      bannerListData.id = "20000052";
      bannerListData.title = "手把手教你使用ArkTS中的canvas实现签名板功能";
      bannerListData.brief = "canvas画布通常用于实现一些画板或者图表、表格之类的功能，来尝试一下吧！";
      bannerListData.headerImageUrl =
        'https://agc-storage-drcn.platform.dbankcloud.cn/v0/hmos-world-fhyhm/20000052.png?token=d5e8edd3-62cb-4c7c-9040-51a73c90beb5';
      bannerListData.type = ResourcesType.ARTICLE;
      bannerListData.webUrl = "https://mp.weixin.qq.com/s/wDIM1MJEHwz9-WAf0Vv6mg";
      bannerListData.publishDate = new Date();
      bannerListData.topics = ["应用模型"];
      bannerListData.viewsCount = 334;
      bannerListData.collectionCount = 63;
      bannerListData.likesCount = 82;
      bannerListData.bannerSrc =
        'https://agc-storage-drcn.platform.dbankcloud.cn/v0/hmos-world-fhyhm/20000052.png?token=d5e8edd3-62cb-4c7c-9040-51a73c90beb5';
      for (let i = 0; i < 5; ++i) {
        bannerList.push(bannerListData);
      }

      let feedList: LearningResource[] = [];
      let feedListData = new LearningResource();
      feedListData.id = "10000034";
      feedListData.title = "开发者版本新特性，你期待哪些更新？#HDC.Together 2023#";
      feedListData.brief = '';
      feedListData.headerImageUrl =
        'https://mmbiz.qpic.cn/sz_mmbiz_jpg/n8IqwDEBrj9Qnphs8CZpVgaoPKyObibzUSJ9Yk1y3eicmib4MM5keeWYzF3tMfStEThazLQvE0F4U7nn9h7icaejpQ/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1&wx_co=1';
      feedListData.webUrl =
        'https://mp.weixin.qq.com/s?__biz=MzkwNDE0MzQ0Nw==&mid=2247516558&idx=1&sn=727280a87fe7fa8b0197e0394ab1eb17&chksm=c089b6b6f7fe3fa05c76556f8122670bfe85f408be6b902cfc3258334e1ec9317f44d0b61ea2&scene=178&cur_album_id=2973037233488297985#rd';
      feedListData.publishDate = new Date();
      feedListData.topics = ["活动公告"];
      feedListData.viewsCount = 1059;
      feedListData.collectionCount = 18;
      feedListData.likesCount = 25;
      feedListData.bannerSrc =
        'https://mmbiz.qpic.cn/sz_mmbiz_jpg/n8IqwDEBrj9Qnphs8CZpVgaoPKyObibzUSJ9Yk1y3eicmib4MM5keeWYzF3tMfStEThazLQvE0F4U7nn9h7icaejpQ/640?wx_fmt=jpeg&wxfrom=5&wx_lazy=1&wx_co=1';
      for (let i = 0; i < 10; ++i) {
        feedList.push(feedListData);
      }
      let feed: ResponseData<LearningResource> = {
        currentPage: 1,
        pageSize: 10,
        pageCount: 1,
        total: 10,
        hasNext: false,
        resourceList: feedList
      };


      let articleList: LearningResource[] = [];
      let articleListData = new LearningResource();
      articleListData.id = "20000005";
      articleListData.title =
        "差异化构建打包，提升多版本应用开发效率\",\"brief\":\"差异化构建打包功能，在面对多场景开发时，开发者无需创建多个工程，可以在同一个工程中，创建多个product和target，在target中通过少量代码的差异化配置处理，再打包到不同的product中，生成对应场景的APP，这样的方式可以让代码、资源文件等高效复用，从而提升多版本应用的开发效率。";
      articleListData.headerImageUrl =
        'https://agc-storage-drcn.platform.dbankcloud.cn/v0/hmos-world-fhyhm/20000020.png?token=a366c446-1e48-4de0-a432-9c8ee150a1d8';
      articleListData.type = ResourcesType.ARTICLE;
      articleListData.webUrl = 'https://mp.weixin.qq.com/s/8XtgZ-k0mGXCjKHfSXFoOg';
      articleListData.publishDate = new Date();
      articleListData.topics = ["DevEco Studio"];
      articleListData.viewsCount = 1059;
      articleListData.collectionCount = 18;
      articleListData.likesCount = 25;
      articleListData.bannerSrc =
        'https://agc-storage-drcn.platform.dbankcloud.cn/v0/hmos-world-fhyhm/20000020.png?token=a366c446-1e48-4de0-a432-9c8ee150a1d8';
      for (let i = 0; i < 10; ++i) {
        articleList.push(articleListData);
      }

      let article: ResponseData<LearningResource> = {
        currentPage: 1,
        pageSize: 10,
        pageCount: 1,
        total: 10,
        hasNext: false,
        resourceList: articleList
      };

      let result: HomeResources = {
        bannerList: bannerList,
        feedData: feed,
        articleData: article
      }
      resolve(result as HomeResources);
    });
}

function getMoreResources(): Promise<ResponseData<LearningResource>> {
  return new Promise((resolve: (value: ResponseData<LearningResource> | PromiseLike<ResponseData<LearningResource>>) => void,
    reject: (reason?: Object) => void) => {
    let articleList: LearningResource[] = [];
    let articleListData = new LearningResource();
    articleListData.id = "20000005";
    articleListData.title =
      "差异化构建打包，提升多版本应用开发效率\",\"brief\":\"差异化构建打包功能，在面对多场景开发时，开发者无需创建多个工程，可以在同一个工程中，创建多个product和target，在target中通过少量代码的差异化配置处理，再打包到不同的product中，生成对应场景的APP，这样的方式可以让代码、资源文件等高效复用，从而提升多版本应用的开发效率。";
    articleListData.headerImageUrl =
      'https://agc-storage-drcn.platform.dbankcloud.cn/v0/hmos-world-fhyhm/20000020.png?token=a366c446-1e48-4de0-a432-9c8ee150a1d8';
    articleListData.type = ResourcesType.ARTICLE;
    articleListData.webUrl = 'https://mp.weixin.qq.com/s/8XtgZ-k0mGXCjKHfSXFoOg';
    articleListData.publishDate = new Date();
    articleListData.topics = ["DevEco Studio"];
    articleListData.viewsCount = 1059;
    articleListData.collectionCount = 18;
    articleListData.likesCount = 25;
    articleListData.bannerSrc =
      'https://agc-storage-drcn.platform.dbankcloud.cn/v0/hmos-world-fhyhm/20000020.png?token=a366c446-1e48-4de0-a432-9c8ee150a1d8';
    for (let i = 0; i < 10; ++i) {
      articleList.push(articleListData);
    }
    let article: ResponseData<LearningResource> = {
      currentPage: 1,
      pageSize: 10,
      pageCount: 1,
      total: 10,
      hasNext: false,
      resourceList: articleList
    };
    resolve(article);
  });
}

function getHotList(): Promise<LearningResource[]> {
  return new Promise((resolve: (value: LearningResource[] | PromiseLike<LearningResource[]>) => void,
    reject: (reason?: Object) => void) => {
    let resourcesData: LearningResource[] = []
    let data1 = new LearningResource();
    data1.id = "10000017";
    data1.title = "【直播预告】HarmonyOS 极客松赋能直播第六期：产品创新从哪里来？";
    data1.brief =
      "本次更新包含多个功能点的新增与完善，带给您全新的体验。子控制台新增菜单栏自定义功能，操作更灵活、App Linking支持拉起元服务、云调试支持多机联动功能等";
    data1.headerImageUrl =
      "https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtyPub/011/111/111/0000000000011111111.20230607175803.26798291581054268465476792570962:50540606101310:2800:A39C70150912F40B2262094A8673EEFC67E4F40DEC072AA8FDBD95C0BE01FAE8.jpg";
    data1.webUrl = "https://mp.weixin.qq.com/s/Omja-J9VnwafdrQ2ktGtMA";
    data1.publishDate = new Date();
    data1.topics = ["精彩活动"];
    data1.viewsCount = 100005;
    data1.collectionCount = 386;
    data1.likesCount = 581;
    data1.bannerSrc =
      "https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtyPub/011/111/111/0000000000011111111.20230607175803.26798291581054268465476792570962:50540606101310:2800:A39C70150912F40B2262094A8673EEFC67E4F40DEC072AA8FDBD95C0BE01FAE8.jpg";
    data1.mediaSrc = "";

    let data2 = new LearningResource();
    data2.id = "10000018";
    data2.title = "【直播预告】HarmonyOS 极客松赋能直播第六期：产品创新从哪里来？";
    data2.brief =
      "本次更新包含多个功能点的新增与完善，带给您全新的体验。子控制台新增菜单栏自定义功能，操作更灵活、App Linking支持拉起元服务、云调试支持多机联动功能等";
    data2.headerImageUrl =
      "https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtyPub/011/111/111/0000000000011111111.20230607175803.26798291581054268465476792570962:50540606101310:2800:A39C70150912F40B2262094A8673EEFC67E4F40DEC072AA8FDBD95C0BE01FAE8.jpg";
    data2.webUrl = "https://mp.weixin.qq.com/s/Omja-J9VnwafdrQ2ktGtMA";
    data2.publishDate = new Date();
    data2.topics = ["精彩活动"];
    data2.viewsCount = 100005;
    data2.collectionCount = 386;
    data2.likesCount = 581;
    data2.bannerSrc =
      "https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtyPub/011/111/111/0000000000011111111.20230607175803.26798291581054268465476792570962:50540606101310:2800:A39C70150912F40B2262094A8673EEFC67E4F40DEC072AA8FDBD95C0BE01FAE8.jpg";
    data2.mediaSrc = "";

    resourcesData.push(data1);
    resourcesData.push(data2);
    resolve(resourcesData as LearningResource[]);
  });
}

function getSearchResult(): Promise<LearningResource[]> {
  return new Promise((resolve: (value: LearningResource[] | PromiseLike<LearningResource[]>) => void,
    reject: (reason?: Object) => void) => {
    let resourcesData: LearningResource[] = []
    let data = new LearningResource();
    data.id = "10000017";
    data.title = "【直播预告】HarmonyOS 极客松赋能直播第六期：产品创新从哪里来？";
    data.brief =
      "本次更新包含多个功能点的新增与完善，带给您全新的体验。子控制台新增菜单栏自定义功能，操作更灵活、App Linking支持拉起元服务、云调试支持多机联动功能等";
    data.headerImageUrl =
      "https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtyPub/011/111/111/0000000000011111111.20230607175803.26798291581054268465476792570962:50540606101310:2800:A39C70150912F40B2262094A8673EEFC67E4F40DEC072AA8FDBD95C0BE01FAE8.jpg";
    data.webUrl = "https://mp.weixin.qq.com/s/Omja-J9VnwafdrQ2ktGtMA";
    data.publishDate = new Date();
    data.topics = ["精彩活动"];
    data.viewsCount = 100005;
    data.collectionCount = 386;
    data.likesCount = 581;
    data.bannerSrc =
      "https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtyPub/011/111/111/0000000000011111111.20230607175803.26798291581054268465476792570962:50540606101310:2800:A39C70150912F40B2262094A8673EEFC67E4F40DEC072AA8FDBD95C0BE01FAE8.jpg";
    data.mediaSrc = "";
    for (let i = 0; i < 6; ++i) {
      resourcesData.push(new LearningResource());
    }
    resolve(resourcesData as LearningResource[]);
  });
}

function getAchievements(): Promise<Achieve[]> {
  return new Promise(
    (resolve: (value: Achieve[] | PromiseLike<Achieve[]>) => void, reject: (reason?: Object) => void) => {
      let achieves: Achieve[] = [];
      const achieve1: Achieve = new Achieve();
      achieve1.pathId = "p001";
      achieve1.isLearned = false;
      achieve1.time = new Date().toString();
      achieves.push(achieve1);

      const achieve2: Achieve = new Achieve();
      achieve2.pathId = "p002";
      achieve2.isLearned = false;
      achieve2.time = new Date().toString();
      achieves.push(achieve2);

      const achieve3: Achieve = new Achieve();
      achieve3.pathId = "p003";
      achieve3.isLearned = false;
      achieve3.time = new Date().toString();
      achieves.push(achieve3);

      const achieve4: Achieve = new Achieve();
      achieve4.pathId = "p004";
      achieve4.isLearned = false;
      achieve4.time = new Date().toString();
      achieves.push(achieve4);

      const achieve5: Achieve = new Achieve();
      achieve5.pathId = "p001";
      achieve5.isLearned = false;
      achieve5.time = new Date().toString();
      achieves.push(achieve5);

      const achieve6: Achieve = new Achieve();
      achieve6.pathId = "p001";
      achieve6.isLearned = false;
      achieve6.time = new Date().toString();
      achieves.push(achieve6);

      const achieve7: Achieve = new Achieve();
      achieve7.pathId = "p001";
      achieve7.isLearned = false;
      achieve7.time = new Date().toString();
      achieves.push(achieve7);

      const achieve8: Achieve = new Achieve();
      achieve8.pathId = "p001";
      achieve8.isLearned = false;
      achieve8.time = new Date().toString();
      achieves.push(achieve8);

      resolve(achieves as Achieve[]);
    });
}

function getCollectedResources(): Promise<LearningResource[]> {
  return new Promise((resolve: (value: LearningResource[] | PromiseLike<LearningResource[]>) => void,
    reject: (reason?: Object) => void) => {
    let resourcesData: LearningResource[] = [];
    let data = new LearningResource();
    data.id = "20000048";
    data.title =
      "收藏数据=== Stage模型HarmonyOS服务卡片开发整体说明";
    data.brief = '本文简要介绍了服务卡片的概念、架构及UI的开发方式。';
    data.headerImageUrl =
      'https://agc-storage-drcn.platform.dbankcloud.cn/v0/hmos-world-fhyhm/20000020.png?token=a366c446-1e48-4de0-a432-9c8ee150a1d8';
    data.webUrl = 'https://developer.huawei.com/consumer/cn/blog/topic/03124470717795042';
    data.publishDate = new Date();
    data.topics = ["应用模型"];
    data.viewsCount = 1059;
    data.collectionCount = 18;
    data.likesCount = 25;
    data.bannerSrc =
      'https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtyPub/011/111/111/0000000000011111111.20230619112633.90526481567331383675921189541115:50540618032747:2800:8E031274F653B57D7EEA37BB60FA0F550FA4BDE98B63B3C8F3057F98B58D2461.jpg';
    for (let i = 0; i < 5; ++i) {
      resourcesData.push(data);
    }
    resolve(resourcesData as LearningResource[]);
  });
}

function getViewedResources(): Promise<LearningResource[]> {
  return new Promise(((resolve: (value: LearningResource[] | PromiseLike<LearningResource[]>) => void,
    reject: (reason?: Object) => void) => {
    let resourcesData: LearningResource[] = [];
    let data = new LearningResource();
    data.id = "20000005";
    data.title =
      "浏览数据=== 差异化构建打包，提升多版本应用开发效率\",\"brief\":\"差异化构建打包功能，在面对多场景开发时，开发者无需创建多个工程，可以在同一个工程中，创建多个product和target，在target中通过少量代码的差异化配置处理，再打包到不同的product中，生成对应场景的APP，这样的方式可以让代码、资源文件等高效复用，从而提升多版本应用的开发效率。";
    data.headerImageUrl =
      'https://agc-storage-drcn.platform.dbankcloud.cn/v0/hmos-world-fhyhm/20000020.png?token=a366c446-1e48-4de0-a432-9c8ee150a1d8';
    data.webUrl = 'https://mp.weixin.qq.com/s/8XtgZ-k0mGXCjKHfSXFoOg';
    data.publishDate = new Date();
    data.topics = ["DevEco Studio"];
    data.viewsCount = 1059;
    data.collectionCount = 18;
    data.likesCount = 25;
    data.bannerSrc =
      'https://agc-storage-drcn.platform.dbankcloud.cn/v0/hmos-world-fhyhm/20000020.png?token=a366c446-1e48-4de0-a432-9c8ee150a1d8';
    for (let i = 0; i < 5; ++i) {
      resourcesData.push(data);
    }
    resolve(resourcesData as LearningResource[]);
  }));
}

/**
 * FuncNetwork base class
 */
class Request {
  async performRequest(trigger: string, params?: Object, times?: number): Promise<Object> {
    Logger.info(TAG, 'Request performRequest in; trigger is :' + trigger);
    return new Promise(
      (resolve: (value: Object | PromiseLike<Object>) => void, reject: ((reason?: RejectError) => void)) => {
        if (PlatformInfo.getPlatform() == PlatformTypeEnum.ANDROID ||
          PlatformInfo.getPlatform() == PlatformTypeEnum.IOS) {
          if (trigger.includes(RequestTrigger.DISCOVERY_HOME_RESOURCE)) {
            getHomeResources().then((data: HomeResources) => {
              resolve(data);
            })
          } else if (trigger.includes(RequestTrigger.DISCOVERY_RESOURCE_PAGE)) {
            getMoreResources().then((data: ResponseData<LearningResource>) => {
              resolve(data);
            })
          } else if (trigger.includes(RequestTrigger.DISCOVERY_RESOURCE_HOT)) {
            getHotList().then((data: LearningResource[]) => {
              resolve(data);
            })
          } else if (trigger.includes(RequestTrigger.DISCOVERY_RESOURCE_SEARCH)) {
            getSearchResult().then((data: LearningResource[]) => {
              resolve(data);
            })
          } else if (trigger.includes(RequestTrigger.LOGIN)) {
            getLoginData().then((data: UserAccount) => {
              resolve(data);
            })
          } else if (trigger.includes(RequestTrigger.MINE_COLLECT)) {
            getCollectedResources().then((data: LearningResource[]) => {
              resolve(data);
            })
          } else if (trigger.includes(RequestTrigger.MINE_HISTORY)) {
            getViewedResources().then((data: LearningResource[]) => {
              resolve(data);
            })
          } else if (trigger.includes(RequestTrigger.MINE_ACHIEVE)) {
            getAchievements().then((data: Achieve[]) => {
              resolve(data);
            })
          } else if (
            trigger.includes(RequestTrigger.TOPIC_TOPICS) || trigger.includes(RequestTrigger.TOPIC_TOPIC_MODIFY)) {
            getThemeData().then((data: Topic[]) => {
              resolve(data);
            })
          } else if (trigger.includes(RequestTrigger.LEARNING_MODIFY)) {
            resolve('');
          } else {
            reject();
          }
        } else if (PlatformInfo.getPlatform() == PlatformTypeEnum.HARMONYOS) {
          // use cloud.callFunction get data
          connection.hasDefaultNet((error: BusinessError, data: Object) => {
            if (!data) {
              Logger.error(TAG, 'The default data network is disconnected ' + JSON.stringify(error));
              promptAction.showToast({
                message: $r('app.string.network_error_msg')
              });
              reject({ code: ErrorCode.ERROR_NETWORK_CONNECT_FAILED, message: 'The network seems to have deserted' });
              return;
            }

            cloud.callFunction({
              name: trigger,
              version: '$latest',
              timeout: 2000,
              params: params
            }).then((functionResult: FunctionResult) => {
              Logger.info(TAG, 'Request call success--------' + trigger + ':' + JSON.stringify(functionResult));
              resolve(functionResult.getValue().data);
            }).catch((error: RejectError) => {
              if (times && times > 0) {
                Logger.error(TAG, 'retry times--------' + (MAX_RETRIES - times + 1));
                resolve(request.performRequest(trigger, params, times - 1));
              } else {
                Logger.error(TAG, 'reject error--------' + JSON.stringify(error));
                reject(error);
              }
            });
          })
        }
      });
  }

  async call(trigger: string, params?: Object): Promise<Object> {
    return await this.performRequest(trigger, params, MAX_RETRIES);
  }
}

let request = new Request();

export default request;