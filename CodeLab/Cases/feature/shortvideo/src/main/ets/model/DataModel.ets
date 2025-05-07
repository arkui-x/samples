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
import { image } from '@kit.ImageKit';

// 视频数据结构
export interface VideoData {
  video: VideoCompData;
  videoMask: VideoMaskData;
}
// 视频组件数据
export interface VideoCompData {
  videoUrl: ResourceStr;
  duration: number; // 视频时长
  previewUri: ResourceStr | image.PixelMap, // 视频预览图
}
// 视频遮罩层数据
export interface VideoMaskData {
  name: string; // 博主名称
  description: string; // 视频描述
  time: string; // 视频日期
  head: ResourceStr; // 头像路径
  likeCount: string; // 点赞数量
  commentCount: string; // 评论数量
  favoriteCount: string; // 收藏数量
  shareCount: string; // 分享次数
  hotspot: string; // 热点
  commentDataSource: CommentDataSource; // 评论数据
}

/**
 * 视频视图模块
 * @param {videoData} data - 视图内容数据
 * @param {WrappedBuilder<[VideoData]>} - 视图框架UI
 */
export class VideoBuilder {
  data: VideoData;
  contentBuilder: WrappedBuilder<[VideoData]>;

  constructor(data: VideoData, contentBuilder: WrappedBuilder<[VideoData]>) {
    this.data = data;
    this.contentBuilder = contentBuilder;
  }
}

// 继承自BasicDataSource的子类，重写了方法
export class TopTabContent extends BasicDataSource {
  private tabContent: string[] = ['关注', '精选', '推荐', '放映厅'];

  // 获取数组长度
  public totalCount(): number {
    return this.tabContent.length;
  }

  // 获取指定索引数据
  public getData(index: number): string {
    return this.tabContent[index];
  }

  // 改变单个数据
  public addData(index: number, data: string): void {
    this.tabContent.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  // 添加数据
  public pushData(data: string): void {
    this.tabContent.push(data);
    this.notifyDataAdd(this.tabContent.length - 1);
  }
}

/**
 * 评论属性
 */
@Observed
export class Comment {
  id?: string; // 评论id
  avatar?: ResourceStr; // 评论人头像
  name?: string; // 评论人昵称
  commentContent?: string; // 评论内容
  timeAgo?: string; // 评论时间
  address?: string; // 评论地址
  likeCount?: string; // 评论的点赞人数
}

/**
 * 评论数据源
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
}

export const VIDEO_DATA: Array<VideoData> = [
  {
    video: {
      videoUrl: $r("app.media.shortvideo_short_video1"),
      duration: 0,
      previewUri: $r("app.media.shortvideo_photo33"),
    },
    videoMask: {
      name: '@北大是只猫',
      description: '欢迎来到霍格莫德村',
      time: '2024-1-3 14:52',
      head: $r("app.media.shortvideo_photo33"),
      likeCount: '1234',
      commentCount: '2234',
      favoriteCount: '3234',
      shareCount: '4234',
      hotspot: '猫长藓要多晒太阳',
      commentDataSource: new CommentDataSource()
    }

  },
  {
    video: {
      videoUrl: $r("app.media.shortvideo_short_video2"),
      duration: 0,
      previewUri: $r("app.media.shortvideo_photo33"),
    },
    videoMask: {
      name: '@谭 雪',
      description: '#栈桥',
      time: '2024-1-2 10:52',
      head: $r("app.media.shortvideo_photo35"),
      likeCount: '7890',
      commentCount: '8890',
      favoriteCount: '9990',
      shareCount: '9991',
      hotspot: '栈桥海鸥',
      commentDataSource: new CommentDataSource()
    }
  },
  {
    video: {
      videoUrl: $r("app.media.shortvideo_short_video3"),
      duration: 0,
      previewUri: $r("app.media.shortvideo_photo33"),
    },
    videoMask: {
      name: '@刘格格',
      description: '生活不止眼前的苟且，还有诗和远方',
      time: '2024-1-2 16:03',
      head: $r("app.media.shortvideo_photo37"),
      likeCount: '4567',
      commentCount: '5567',
      favoriteCount: '6667',
      shareCount: '7667',
      hotspot: '社恐',
      commentDataSource: new CommentDataSource()
    }
  }
];