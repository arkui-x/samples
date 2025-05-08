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
import { CommentDataSource } from "../model/DataModel";

// 模拟List组件评论数据
export function mockData(): CommentDataSource {
  const commentData: CommentDataSource = new CommentDataSource();
  for (let j = 0; j < 18; j++) {
    commentData.pushData({
      id: j + "",
      avatar:$r("app.media.list_image_a"),
      name: "圣火喵喵叫" + j,
      commentContent: "喵喵我吗？我没有看到后续，但总有人会看到" + j,
      timeAgo: j + "小时前",
      address: "杭州",
      likeCount: j + ""
    });
  }
  return commentData;
}