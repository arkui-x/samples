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

import { NewsCommentModel, NewsCommentData } from '../model/NewsCommentModel';

// 模拟评论数据
export function mockData(): NewsCommentData {
  const commentList: NewsCommentData = new NewsCommentData();
  commentList.pushData(new NewsCommentModel("1", $r("app.media.news_image_1"), '你若安好便是晴天', '', '', '国足加油！国足必胜！', new Date('2024-11-01 23:00:00'),new NewsCommentData()))
  commentList.pushData(new NewsCommentModel("2", $r("app.media.news_image_2"), '天要下雨娘要嫁人', '', '', '来点信心，加油加油~', new Date('2024-11-01 23:00:00'), new NewsCommentData()))
  commentList.pushData(new NewsCommentModel("3", $r("app.media.news_image_3"), '太阳打北边出来了', '', '', '下一场什么时候，有直播吗', new Date('2024-11-01 23:00:00'), new NewsCommentData()))
  commentList.pushData(new NewsCommentModel("4", $r("app.media.news_image_4"), '西红柿炒鸡蛋蛋卷(特辣)', '', '', '教练组的战术调整值得肯定，尤其是在中场控制方面有所改善。', new Date('2024-11-01 23:00:00'), new NewsCommentData()))
  commentList.pushData(new NewsCommentModel("5", $r("app.media.news_image_6"), '东边有个塔玛，西边有个喇嘛', '', '', '期待他们在未来的比赛中继续进步！', new Date('2024-11-01 23:00:00'),new NewsCommentData()))
  commentList.pushData(new NewsCommentModel("7", $r("app.media.news_image_7"), '天青色等烟雨而我在等你', '', '', '希望他们能在接下来的比赛中继续发挥，成为球队的中坚力量。',new Date('2024-11-01 23:00:00'), new NewsCommentData()))
  commentList.pushData(new NewsCommentModel("8", $r("app.media.news_image_8"), '大事不妙了', '', '', '与世界强队的差距依然显著，继续努力吧。', new Date('2024-11-01 23:00:00'), new NewsCommentData()))
  commentList.pushData(new NewsCommentModel("9", $r("app.media.news_image_6"), '小猫带耳机', '', '', '国足必胜，加油加油。', new Date('2024-11-01 23:00:00'), new NewsCommentData()))
  return commentList;
}

// 模拟当前用户昵称
export const curUser: string = "兔子不吃窝边草";

