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

import { BasicDataSource } from './BasicDataSource';
import { SpanType } from '../constants/ChatConstants';

/**
 * 聊天内容item
 */
export class SpanItem {
  spanType: SpanType;
  text: string;
  imgSrc: string;
  constructor(spanType: SpanType, text: string, imgSrc: string) {
    this.spanType = spanType;
    this.text = text;
    this.imgSrc = imgSrc;
  }
}

/**
 * 聊天信息
 */
export class MessageBase {
  maxWidth: number = 0; // 最大宽度
  isSelf: boolean = true; // 是否本人发言
  userName: string = ''; // 发言人信息
  profilePicture: string = '' // 发言人头像
  spanItems: Array<SpanItem> = []; // Span、ImageSpan 信息列表
  constructor(self: boolean, userName: string, profilePicture: string, maxWidth: number) {
    this.isSelf = self;
    this.userName = userName;
    this.profilePicture = profilePicture;
    this.maxWidth = maxWidth;
  }
}

export class TextDetailData extends BasicDataSource<MessageBase> {
  msgList: Array<MessageBase> = [];

  public totalCount(): number {
    return this.msgList.length;
  }

  public getData(index: number): MessageBase {
    return this.msgList[index];
  }

  public addData(index: number, data: MessageBase): void {
    this.msgList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: MessageBase): void {
    this.msgList.push(data);
    this.notifyDataAdd(this.msgList.length - 1);
  }
}