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

import { CustomMessage, MyCustomSpan, MyCustomSpanType } from '../model/TextModel';

/**
 * 消息列表mock数据
 */
export const MESSAGES_DATA: Array<CustomMessage> = [
  new CustomMessage(0,$r('app.media.styled_text_user_image1'), '央视新闻', '2小时前', [
    new MyCustomSpan(0, MyCustomSpanType.Normal, '【准备回家！'),
    new MyCustomSpan(1, MyCustomSpanType.Hashtag, '#神十七乘组4月30日回地球#'),
    new MyCustomSpan(2, MyCustomSpanType.Normal, '】'),
    new MyCustomSpan(3, MyCustomSpanType.Hashtag, '#神十八太空过国庆节#'),
    new MyCustomSpan(4, MyCustomSpanType.Normal, '\n按计划，在轨驻留期间，神十八乘组将迎来天舟八号货运飞船、神舟十九号载人飞船的来访，计划于今年10月下旬返回东风着陆场。\n祝一切顺利！'),
    new MyCustomSpan(5, MyCustomSpanType.Hashtag, '#神十八新闻发布会#'),
    new MyCustomSpan(6, MyCustomSpanType.Normal, '\n神十七乘组在与神十八乘组完成在轨轮换后，计划于本月30日返回东风着陆场。\n祝一切顺利！'),
  ], $r("app.media.styled_text_user_image1")),

  new CustomMessage(1,$r("app.media.styled_text_user_image2"), '河南消防', '昨天 16:07', [
    new MyCustomSpan(0, MyCustomSpanType.Normal, '【'),
    new MyCustomSpan(1, MyCustomSpanType.Hashtag, '#消防员作证这娃真是从石缝钻出来的#'),
    new MyCustomSpan(2, MyCustomSpanType.Normal, '】近日，河南郑州，男童在碎石堆上玩耍，脚下一滑不慎掉进石缝中，刚好被牢牢卡住无法出来。'),
    new MyCustomSpan(3, MyCustomSpanType.Mention, '@郑州消防'),
    new MyCustomSpan(4, MyCustomSpanType.Normal, ' 赶赴，利用撬棍支撑固定石块，搬开压在男孩身上的石头将其成功救出，并飞奔送上救护车。'),
    new MyCustomSpan(5, MyCustomSpanType.VideoLink, '中国消防的视频')
  ], $r("app.media.styled_text_user_image2")),

  new CustomMessage(2,$r('app.media.styled_text_user_image1'), '央视新闻', '4-22 18:51', [
    new MyCustomSpan(0, MyCustomSpanType.Hashtag, '#5岁孩子淡定打手势配合老爸抓逃犯#'),
    new MyCustomSpan(1, MyCustomSpanType.Normal, '【'),
    new MyCustomSpan(2, MyCustomSpanType.Hashtag, '#民警老爸抓逃犯5岁儿子神助攻#'),
    new MyCustomSpan(3, MyCustomSpanType.Normal, '】近日，江西德安，一民警下班后带着孩子到餐馆吃饭，却发现餐厅内一男子正是他在侦查的诈骗案嫌疑人。为避免打草惊蛇，他先联系了同事支援，又示意儿子到餐厅门口“接应”。5岁的儿子“秒懂”，看到支援民警赶来，他淡定地给父亲打了个手势↓↓随后，民警迅速将嫌疑人控制住。为这对默契的父子点赞!'),
  ])
];