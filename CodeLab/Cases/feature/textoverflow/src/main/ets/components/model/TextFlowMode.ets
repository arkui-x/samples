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
 * 评论的数据结构
 */
export class CommentModel {
  // 评论id
  public id: string;
  // 评论头像
  public url: ResourceStr;
  // 评论昵称
  public user: string;
  // 回复id
  public replyId: string;
  // 回复用户昵称
  public replyUser: string;
  // 回复文本
  public text: string;
  // 回复时间
  public commentTime: Date;
  // 评论下的回复列表
  public replyList: CommentData;

  constructor(id: string, url: ResourceStr, user: string, replyId: string, replyUser: string, text: string, commentTime: Date, replyList: CommentData) {
    this.id = id;
    this.url = url;
    this.user = user;
    this.replyId = replyId;
    this.replyUser = replyUser;
    this.text = text;
    this.commentTime = commentTime;
    this.replyList = replyList;
  }
}

// Basic implementation of IDataSource to handle data listener
class BasicDataSource implements IDataSource {
  // 数据变化监听器
  private listeners: DataChangeListener[] = [];
  // 需要进行数据迭代的数据源
  private originDataArray: CommentModel[] = [];

  // 获取数据的长度
  public totalCount(): number {
    return 0;
  }

  // 获取指定数据项
  public getData(index: number): CommentModel {
    return this.originDataArray[index];
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }
}

/**
 * 设定需要动态监听的model,以便于添加评论时，实现数据的动态监听从而进行lazyForeach懒加载。
 */
export class CommentData extends BasicDataSource {
  // 懒加载数据
  private comments: Array<CommentModel> = [];

  // 获取懒加载数据源的数据长度
  totalCount(): number {
    return this.comments.length;
  }

  // 获取指定数据项
  getData(index: number): CommentModel {
    return this.comments[index];
  }

  // 获取指定数据项
  getParentData(parentId: string): CommentModel | null {
    for (let i = 0; i < this.comments.length; i++) {
      if (this.comments[i].id === parentId) {
        return this.comments[i];
      }
    }
    return null;
  }

  // 存储数据到懒加载数据源中
  pushData(data: CommentModel): void {
    this.comments.push(data);
    // 在数组头部添加数据
    this.notifyDataAdd(this.comments.length - 1);
  }

  addDataFirst(data: CommentModel): void {
    this.comments.unshift(data);
    // 在数组头部添加数据
    this.notifyDataAdd(0);
  }
}



