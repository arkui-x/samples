/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

// 定义基础服务类
export interface IconType {
  name: string,
  icon: Resource
}

// 定义更多服务类
export interface IconListType {
  name: string,
  icon: Resource
}

// 定义基础数据类
export interface IconListsType { //
  name: string,
  num: string
}

// 基础的icon数据
export const IconList3: IconListsType[] = [
  { name: "头条", num: "0" },
  { name: "获赞", num: "0" },
  { name: "粉丝", num: "0" },
  { name: "关注", num: "0" }
]

// 基础服务的icon数据
export const IconList: IconType[] = [
  { name: "消息私信", icon: $r("app.media.naviagtion_interceptor_msg") },
  { name: "收藏", icon: $r("app.media.naviagtion_interceptor_collect") },
  { name: "浏览历史", icon: $r("app.media.naviagtion_interceptor_history") },
  { name: "下载管理", icon: $r("app.media.naviagtion_interceptor_download") }
]

// 更多服务的icon数据
export const IconList2: IconListType[] = [
  { name: "客服中心", icon: $r("app.media.naviagtion_interceptor_call") },
  { name: "钱包", icon: $r("app.media.naviagtion_interceptor_wallet") },
  { name: "广告推广", icon: $r("app.media.naviagtion_interceptor_ad") },
  { name: "免流量服务", icon: $r("app.media.naviagtion_interceptor_flow")},
  { name: "安全中心", icon: $r("app.media.naviagtion_interceptor_safe") },
  { name: "隐私设置", icon: $r("app.media.naviagtion_interceptor_privacy") },
  { name: "评论", icon: $r("app.media.naviagtion_interceptor_comment") },
  { name: "点赞", icon: $r("app.media.naviagtion_interceptor_good")},
  { name: "借钱", icon: $r("app.media.naviagtion_interceptor_borrow") },
  { name: "深色模式", icon: $r("app.media.naviagtion_interceptor_mode") },
  { name: "购物车", icon: $r("app.media.naviagtion_interceptor_shopcar") },
  { name: "订单", icon: $r("app.media.naviagtion_interceptor_order")},
]
