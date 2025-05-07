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
import { FaceGridConstants } from '../constants/ChatConstants';

// 表情模型类
export class EmojiModel {
  imgSrc: Resource; // 图片资源
  meaning: string = ''; // 表情所表示的含义

  constructor(imgSrc: Resource, meaning: string) {
    this.imgSrc = imgSrc;
    this.meaning = meaning;
  }
}

// 表情数据
export const EmojiData = [
  new EmojiModel($rawfile('01.png'), '大笑'),
  new EmojiModel($rawfile('02.png'), '微笑'),
  new EmojiModel($rawfile('03.png'), '亲亲'),
  new EmojiModel($rawfile('04.png'), '熬夜'),
  new EmojiModel($rawfile('05.png'), '羡慕'),
  new EmojiModel($rawfile('06.png'), '呲牙笑'),
  new EmojiModel($rawfile('07.png'), '好害羞'),
  new EmojiModel($rawfile('08.png'), '偷笑'),
  new EmojiModel($rawfile('09.png'), '见钱眼开'),
  new EmojiModel($rawfile('10.png'), '眨眼'),
  new EmojiModel($rawfile('11.png'), '坏笑'),
  new EmojiModel($rawfile('12.png'), '好害羞'),
  new EmojiModel($rawfile('13.png'), '困惑'),
  new EmojiModel($rawfile('14.png'), '鼓掌'),
  new EmojiModel($rawfile('15.png'), '可怜'),
  new EmojiModel($rawfile('16.png'), '抠鼻'),
  new EmojiModel($rawfile('17.png'), '打哈欠'),
  new EmojiModel($rawfile('18.png'), '睡觉'),
  new EmojiModel($rawfile('19.png'), '叹气'),
  new EmojiModel($rawfile('20.png'), '惊讶'),
  new EmojiModel($rawfile('21.png'), '小声点'),
  new EmojiModel($rawfile('22.png'), '吐你一身'),
  new EmojiModel($rawfile('23.png'), '闭嘴'),
  new EmojiModel($rawfile('24.png'), '打你'),
  new EmojiModel($rawfile('25.png'), '抓狂'),
  new EmojiModel($rawfile('26.png'), '好委屈'),
  new EmojiModel($rawfile('27.png'), '你好讨厌'),
  new EmojiModel($rawfile('28.png'), '我真生气了'),
  new EmojiModel($rawfile('29.png'), '翻白眼'),
  new EmojiModel($rawfile('30.png'), '伤心死了'),
  new EmojiModel($rawfile('31.png'), '难过'),
  new EmojiModel($rawfile('32.png'), '酷'),
];

/**
 *  TODO 知识点：最近使用的表情数据
 */
export class LastEmojiData extends BasicDataSource<EmojiModel> {
  emojiList: Array<EmojiModel> = [];

  public totalCount(): number {
    return this.emojiList.length;
  }

  public getData(index: number): EmojiModel {
    return this.emojiList[index];
  }

  public addData(index: number, data: EmojiModel): void {
    this.emojiList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: EmojiModel): void {
    // TODO 知识点：保存最近使用表情（最多六个）
    if (this.emojiList.length >= FaceGridConstants.GRID_MAX_COUNT) {
      this.emojiList.splice(0, 1, data);
    } else {
      this.emojiList.splice(0, 0, data);
    }
    this.notifyDataAdd(0);
  }
}