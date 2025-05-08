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

/**
 * 自定义Message类
 */
export class CustomMessage {
  id: number | string;
  profile: string | Resource; // 头像
  userName: string; // 用户名
  subTitle: string; // 副标题
  spans: MyCustomSpan[]; // Text组件中展示的 Span 列表
  media?: Resource; // 内容

  constructor(id: number | string, profile: string | Resource, userName: string, subTitle: string, spans: MyCustomSpan[], media?: Resource) {
    this.id = id;
    this.profile = profile;
    this.userName = userName;
    this.subTitle = subTitle;
    this.spans = spans;
    if (media) {
      this.media = media;
    }
  }
}

/**
 * 自定义Span类
 */
export class MyCustomSpan {
  id: number | string; // 文本id
  type: MyCustomSpanType; // 文本类型
  content: string; // 文本内容
  url?: string; // 跳转的链接地址

  constructor(id: number | string, type: MyCustomSpanType = MyCustomSpanType.Normal, content: string, url?: string) {
    this.id = id;
    this.type = type;
    this.content = content;
    if (url) {
      this.url = url;
    }
  }
}

/**
 * 定义Span类型的枚举
 */
export enum MyCustomSpanType {
  Normal, // 普通文本，不含任何特殊格式或标记
  Mention, // @提及
  Hashtag, // 话题标签
  VideoLink, // 视频链接
  DetailLink // 正文详情
}