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
import { image } from '@kit.ImageKit';

/**
 * 群头像数据结构
 */
export interface GroupAvatarModel {
  src: ResourceStr | image.PixelMap;
  width: number;
  height: number;
}

/**
 * 好友数据结构
 */
export interface PersonData {
  wid: string; // 用户wid
  headImg: ResourceStr | image.PixelMap // 头像
  name: string // 用户昵称
}


/**
 * 会话数据结构
 */
export interface SessionData {
  wid: string; // 用户wid
  headImg: ResourceStr | image.PixelMap; // 头像
  name: string; // 用户昵称
  lastMsg: string; // 最后一条消息简要内容
}

/**
 * 底部Tab栏数据结构
 */
export interface TabItem{
  imgSrcNomral: ResourceStr;
  imgSrcPress: ResourceStr;
  tabText: ResourceStr;
}
