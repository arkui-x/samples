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

import { MessageType } from '../enums/MessageType';

//消息体
export interface Message {
  id: string;
  //发送者
  sender: string;
  //头像
  avatar: string;
  //消息类型
  type: number;
  //消息内容
  content: string;
}

//构造模拟消息列表数据
export const messageList: Array<Message> = [
  {
    id: "1",
    sender: "friend",
    avatar: "app.media.voice_record_dynamic_effect_avatar_friend",
    type: MessageType.TEXT,
    content: "你在干嘛"
  },
  {
    id: "2",
    sender: "friend",
    avatar: "app.media.voice_record_dynamic_effect_avatar_friend",
    type: MessageType.TEXT,
    content: "？？？"
  },
  {
    id: "3",
    sender: "friend",
    avatar: "app.media.voice_record_dynamic_effect_avatar_friend",
    type: MessageType.TEXT,
    content: "要不要出去玩，好多人一起"
  },
  {
    id: "4",
    sender: "friend",
    avatar: "app.media.voice_record_dynamic_effect_avatar_friend",
    type: MessageType.TEXT,
    content: "有时间吗"
  },
  {
    id: "5",
    sender: "me",
    avatar: "app.media.voice_record_dynamic_effect_avatar_own",
    type: MessageType.TEXT,
    content: "去哪里玩"
  },{
    id: "6",
    sender: "friend",
    avatar: "app.media.voice_record_dynamic_effect_avatar_friend",
    type: MessageType.TEXT,
    content: "自驾周边游"
  }
];
