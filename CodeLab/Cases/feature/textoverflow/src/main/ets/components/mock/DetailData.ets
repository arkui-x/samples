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

import { CommentModel, CommentData } from '../model/TextFlowMode';

// 模拟评论数据
export function mockData(): CommentData {
  const commentList: CommentData = new CommentData();
  commentList.pushData(new CommentModel("1", $r('app.media.user_select'), '你若安好便是晴天', '', '', '和描述相符很喜欢，做工细致，颜色好看，原装正品', new Date('2024-11-01 23:00:00'), new CommentData()))
  commentList.pushData(new CommentModel("2", $r('app.media.user_select'), '天要下雨娘要嫁人', '', '', '我的第一双滑板鞋，摩擦摩擦', new Date('2024-11-01 23:00:00'), new CommentData()))
  commentList.pushData(new CommentModel("3", $r('app.media.user_select'), '太阳打北边出来了', '', '', '给我儿子买的，他穿上了，玩滑板再也不摔跤了', new Date('2024-11-01 23:00:00'), new CommentData()))
  commentList.pushData(new CommentModel("4", $r('app.media.user_select'), '西红柿炒鸡蛋蛋卷(特辣)', '', '', '鞋子真的不错，xx出品，必然精品', new Date('2024-11-01 23:00:00'), new CommentData()))
  commentList.pushData(new CommentModel("5", $r('app.media.user_select'), '东边有个塔玛，西边有个喇嘛', '', '', '国产鞋就是好，穿上脚也不酸了，腿也不疼了，饭都能多吃2碗', new Date('2024-11-01 23:00:00'), new CommentData()))
  commentList.pushData(new CommentModel("7", $r('app.media.user_select'), '天青色等烟雨而我在等你', '', '', '给好评是因为想让大家看到，其实很烂，大家不要买', new Date('2024-11-01 23:00:00'), new CommentData()))
  commentList.pushData(new CommentModel("8", $r('app.media.user_select'), '大事不妙了', '', '', '给好评是因为想让大家看到，其实很烂，大家不要买', new Date('2024-11-01 23:00:00'), new CommentData()))
  commentList.pushData(new CommentModel("9", $r('app.media.user_select'), '小猫带耳机', '', '', '买一双，还可以。', new Date('2024-11-01 23:00:00'), new CommentData()))
  commentList.pushData(new CommentModel("9", $r('app.media.user_select'), '小狗旺旺', '', '', '好穿，还可以。', new Date('2024-11-01 23:00:00'), new CommentData()))
  return commentList;
}

// 模拟当前用户昵称
export const curUser: string = "兔子不吃窝边草";

