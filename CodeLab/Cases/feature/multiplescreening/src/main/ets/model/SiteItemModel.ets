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

/**
 * 套餐信息，包括时间、套餐名称、套餐价格、套餐类型
 */
export declare class TimeList {
  time: string; // 套餐时间
  name?: ResourceStr; // 套餐名称
  price?: ResourceStr; // 套餐价格
  type: string; // 套餐类型
}

/**
 * 场地信息，包括场地图片、场地名称、场地地址、场地折扣、场地套餐
 */
export class SiteItem {
  siteImage: ResourceStr; // 场地图片
  siteName: string; // 场地名称
  siteAddress: string; // 场地地址
  siteDiscount: string; // 场地折扣
  siteBale: Array<TimeList>; // 场地套餐

  constructor(siteImage: ResourceStr, siteName: string, siteAddress: string, siteDiscount: string,
    siteBale: Array<TimeList>) {
    this.siteImage = siteImage;
    this.siteName = siteName;
    this.siteAddress = siteAddress;
    this.siteDiscount = siteDiscount;
    this.siteBale = siteBale;
  }
}

export const SITE_LIST_DATA = [
  new SiteItem('https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/backgroundblur/src/main/resources/base/media/background_pic_1.png',
    '易鹏工业园区停车场', '252米 | 翠幽路易鹏工业园', '满120立减15',
    [{
      time: '白天',
      name: '全天套餐（1月）',
      price: '￥150.00',
      type: '月套餐'
    },
      {
        time: '夜间',
        name: '夜间套餐（1夜）',
        price: '￥100.00',
        type: '日套餐'
      }]),
  new SiteItem('https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/backgroundblur/src/main/resources/base/media/background_pic_2.png',
    '创新科技园停车场', '733米 | 创新科技园', '满500立减50',
    [{
      time: '全天',
      name: '全天套餐（1年）',
      price: '￥4500.00',
      type: '年套餐'
    },
      {
        time: '白天',
        name: '全天套餐（1月）',
        price: '￥450.00',
        type: '月套餐'
      }]),
  new SiteItem('https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/backgroundblur/src/main/resources/base/media/background_pic_3.png',
    '南堡服装城停车场', '668米 | 南堡服装城停车场', '满250立减50',
    [{
      time: '夜间',
      name: '夜间套餐（1月）',
      price: '￥600.00',
      type: '月套餐'
    }]),
  new SiteItem('https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/pipwindow/src/main/resources/base/media/pip_window_preview1.jpg',
    '顺景创新中心停车场', '1.5公里 | 顺景创新中心停车场', '新用户劵',
    [{
      time: '夜间',
      name: '夜间套餐（1年）',
      price: '￥2200.00',
      type: '年套餐'
    },
      {
        time: '夜间',
        name: '夜间套餐（1季）',
        price: '￥580.00',
        type: '季套餐'
      },
      {
        time: '夜间',
        name: '夜间套餐（1月）',
        price: '￥200.00',
        type: ''
      }]),
  new SiteItem('https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/pipwindow/src/main/resources/base/media/pip_window_preview2.jpg',
    '凤凰小镇易创创意大厦', '1.2公里 | 凤凰小镇易创创意大厦', '满500立减10',
    [{
      time: '夜间',
      name: '夜间套餐（1月）',
      price: '￥380.00',
      type: '月套餐'
    },
      {
        time: '全天',
        name: '夜间套餐（1月）',
        price: '￥700.00',
        type: '月套餐'
      },
      {
        time: '夜间',
        name: '夜间套餐（1夜）',
        price: '￥38.00',
        type: '日套餐'
      }]),
  new SiteItem('https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/pipwindow/src/main/resources/base/media/pip_window_preview3.jpg',
    '新南大厦停车场', '1.5公里 | 新南大厦停车场', '领20元立减劵',
    [{
      time: '全天',
      name: '全天套餐（1月）',
      price: '￥800.00',
      type: '月套餐'
    },
      {
        time: '夜间',
        name: '夜间套餐（1月）',
        price: '￥450.00',
        type: '月套餐'
      },
      {
        time: '白天',
        name: '白天套餐（1月）',
        price: '￥600.00',
        type: '月套餐'
      }]),
  new SiteItem('https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/pipwindow/src/main/resources/base/media/pip_window_preview4.jpg',
    '裕同智创园停车场', '1.8公里 | 裕同智创园停车场', '满10减9',
    [{
      time: '夜间',
      name: '夜间套餐B（1月）',
      price: '￥150.00',
      type: '月套餐'
    },
      {
        time: '白天',
        name: '白天套餐（1次）',
        price: '￥30.00',
        type: '次套餐'
      },
      {
        time: '夜间',
        name: '夜间套餐（30天2次）',
        price: '￥50.00',
        type: '次套餐'
      }]),
  new SiteItem('https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/backgroundblur/src/main/resources/base/media/background_pic_1.png',
    '榕湖名座停车场', '2.1公里 | 榕湖名座停车场', '满120立减15',
    [{
      time: '夜间',
      name: '夜间套餐（1月）',
      price: '￥350.00',
      type: '月套餐'
    },
      {
        time: '夜间',
        name: '夜间套餐（1季）',
        price: '￥1050.00',
        type: '季套餐'
      }]),
  new SiteItem('https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/backgroundblur/src/main/resources/base/media/background_pic_2.png',
    '建材装饰城停车场', '2.3公里 | 建材装饰城停车场', '满500立减50',
    [{
      time: '全天',
      name: '全天套餐（1年）',
      price: '￥450.00',
      type: '年套餐'
    }]),
  new SiteItem('https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/backgroundblur/src/main/resources/base/media/background_pic_3.png',
    '冰雪大世界停车场', '2.4公里 | 冰雪大世界停车场', '满250立减50',
    [{
      time: '夜间',
      name: '夜间套餐（7天2次）',
      price: '￥23.92',
      type: '次套餐'
    },
      {
        time: '夜间',
        name: '夜间套餐（30天5次）',
        price: '￥39.92',
        type: '次套餐'
      },
      {
        time: '白天',
        name: '白天套餐（1次）',
        price: '￥10.00',
        type: '次套餐'
      }]),
  new SiteItem('https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/pipwindow/src/main/resources/base/media/pip_window_preview1.jpg',
    '维也纳停车场', '2.9公里 | 维也纳停车场', '新用户劵',
    [{
      time: '全天',
      name: '全天套餐（1月）',
      price: '￥300.00',
      type: '月套餐'
    }]),
  new SiteItem('https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/pipwindow/src/main/resources/base/media/pip_window_preview2.jpg',
    '绿城农贸市场停车场', '4.1公里 | 绿城农贸市场停车场', '满500立减10',
    [{
      time: '夜间',
      name: '夜间套餐（1月）',
      price: '￥99.00',
      type: '月套餐'
    }]),
  new SiteItem('https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/pipwindow/src/main/resources/base/media/pip_window_preview3.jpg',
    '清湾外围停车场', '4.3公里 | 清湾外围停车场', '领20元立减劵',
    [{
      time: '夜间',
      name: '夜间套餐（1夜）',
      price: '￥20.00',
      type: '日套餐'
    },
      {
        time: '白天',
        name: '周末上午套餐（1天1次）',
        price: '￥10.00',
        type: '次套餐'
      },
      {
        time: '白天',
        name: '周末套餐（1天1次）',
        price: '￥20.00',
        type: '次套餐'
      }]),
  new SiteItem('https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/pipwindow/src/main/resources/base/media/pip_window_preview4.jpg',
    '七星岩街道停车场', '5.1公里 | 七星岩街道停车场', '满10减9',
    [{
      time: '夜间',
      name: '夜间套餐（1次）',
      price: '￥80.00',
      type: '次套餐'
    }]),
  new SiteItem('https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/backgroundblur/src/main/resources/base/media/background_pic_1.png',
    '新都汇停车场', '6.2公里 | 新都汇停车场', '满250立减50',
    [{
      time: '夜间',
      name: '夜间套餐（1月）',
      price: '￥400.00',
      type: '月套餐'
    },
      {
        time: '白天',
        name: '白天套餐（1月）',
        price: '￥550.00',
        type: '月套餐'
      }])
]
