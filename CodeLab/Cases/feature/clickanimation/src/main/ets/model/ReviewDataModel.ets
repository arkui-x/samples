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

/**
 * ReviewItem 评论项。
 * 包含用户名和评论内容。
 */
export class ReviewItem {
  userName: string; // 用户名
  reviewContent: string; // 评论内容

  constructor(userName: string, reviewContent: string) {
    this.userName = userName;
    this.reviewContent = reviewContent;
  }
}

/**
 * ReviewListDataSource 类继承自 BasicDataSource<ReviewItem>，处理评论列表数据源操作
 * @extends {BasicDataSource<ReviewItem>}
 */
export class ReviewListDataSource extends BasicDataSource<ReviewItem> {}