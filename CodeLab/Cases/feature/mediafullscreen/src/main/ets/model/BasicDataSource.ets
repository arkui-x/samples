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

import util from '@ohos.util';

abstract class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];

  public abstract totalCount(): number;

  public getData(index: number): T | void {
  };

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataReloaded();
    });
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataAdd(index);
    });
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataChange(index);
    });
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataDelete(index);
    });
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataMove(from, to);
    });
  }
}

class FlowItemContentsData extends BasicDataSource<FlowItemContent> {
  momentList: Array<FlowItemContent> = [];

  // 获取数据列表长度
  public totalCount(): number {
    return this.momentList.length;
  }

  // 根据index获取具体项
  public getData(index: number): FlowItemContent {
    return this.momentList[index];
  }

  // 向规定位置添加数据
  public addData(index: number, data: FlowItemContent): void {
    this.momentList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  // 向列表追加数据
  public pushData(data: FlowItemContent | FlowItemContent[]): void {
    if (Array.isArray(data)) {
      this.momentList.push(...data);
    } else {
      this.momentList.push(data);
    }
    this.notifyDataAdd(this.momentList.length - 1);
  }
}

class UserItem {
  userId: string;
  userName: string | Resource;
  userImage: string | Resource;

  toString(): string {
    return this.userId + '  ' + this.userName + '  ' + this.userImage;
  }

  constructor(id: string, name: string | Resource, image?: string | Resource) {
    this.userId = id;
    this.userName = name;
    this.userImage = $r("app.media.media_full_screen_profile_photo");
    if (image != null) {
      this.userImage = image;
    }
  }
}

class FlowItemContent {
  id: string;
  user: UserItem;
  text: string;
  imageList: Array<string> = [];
  media: string = ''; // media为需要获取的视频url
  mediaPreview: string = ''; // mediaPreview为需要获取的视频预览图url

  constructor(id: string, user: UserItem, text: string, media: string, mediaPreview: string) {
    this.id = id;
    this.user = user;
    this.media = media;
    this.mediaPreview = mediaPreview;
    this.text = text;
  }

  toString(): string {
    return this.id + '  ' + this.user.toString() + '  ' + this.text;
  }
}

export { FlowItemContent, UserItem, FlowItemContentsData, BasicDataSource };