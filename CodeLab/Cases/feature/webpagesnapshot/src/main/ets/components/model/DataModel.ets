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
import { BasicDataSource } from "./BasicDataSource";

/**
 * List子项评论属性
 */
@Observed
export class Comment {
  id?: string; // 评论id
  avatar?: Resource; // 评论人头像
  name?: string; // 评论人昵称
  commentContent?: string; // 评论内容
  timeAgo?: string; // 评论时间
  address?: string; // 评论地址
  likeCount?: string; // 评论的点赞人数
}

/**
 * List子项评论数据源
 */
@Observed
export class CommentDataSource extends BasicDataSource {
  private commentArray: Comment[] = [];

  public totalCount(): number {
    return this.commentArray.length;
  }

  /**
   * 获取指定索引数据
   * @param index
   * @returns
   */
  public getData(index: number): Comment {
    return this.commentArray[index];
  }

  /**
   * 改变单个数据
   * @param index
   * @param data
   */
  public addData(index: number, data: Comment): void {
    this.commentArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  /**
   * 添加数据
   * @param data
   */
  public pushData(data: Comment): void {
    this.commentArray.push(data);
    this.notifyDataAdd(this.commentArray.length - 1);
  }

  /**
   * 获取commentArray
   */
  public getDataArray(): Comment[] {
    return this.commentArray;
  }
}