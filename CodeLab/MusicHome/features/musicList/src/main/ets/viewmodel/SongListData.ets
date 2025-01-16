/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { router } from '@kit.ArkUI';
import { RouterUrlConstants } from '@ohos/constantsCommon';
import { SongItem } from '@ohos/mediaCommon';

const songList: SongItem[] = [
  {
    id: 1,
    title: '春夏秋冬',
    singer: '易水',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_dream'),
    src: 'boisterous.wav',
    index: 0,
    lyric: ''
  },
  {
    id: 2,
    title: '不知道',
    singer: '张三-你好我好都好',
    mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar2'),
    src: 'boisterous.wav',
    index: 1,
    lyric: ''
  },
  {
    id: 3,
    title: '还是歌名',
    singer: '不知道你是谁',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar16'),
    src: 'boisterous.wav',
    index: 2,
    lyric: ''
  },
  {
    id: 4,
    title: 'AIUHGVNHK',
    singer: 'Gwyu-Hjjiyabn',
    mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar4'),
    src: 'boisterous.wav',
    index: 3,
    lyric: ''
  },
  {
    id: 5,
    title: '可可不喜欢',
    singer: '名佚',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar5'),
    src: 'boisterous.wav',
    index: 4,
    lyric: ''
  },
  {
    id: 6,
    title: '我是UOUYGBJ',
    singer: '我是小树',
    mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar6'),
    src: 'boisterous.wav',
    index: 5,
    lyric: ''
  },
  {
    id: 7,
    title: '好好学习',
    singer: '全村最帅',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar17'),
    src: 'boisterous.wav',
    index: 6,
    lyric: ''
  },
  {
    id: 8,
    title: '安心安心',
    singer: '小安安',
    mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar8'),
    src: 'boisterous.wav',
    index: 7,
    lyric: ''
  },
  {
    id: 9,
    title: 'HBNJGHJHB',
    singer: '我是小树',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar9'),
    src: 'boisterous.wav',
    index: 8,
    lyric: ''
  },
  {
    id: 10,
    title: '天天向上',
    singer: '靓仔',
    mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar10'),
    src: 'boisterous.wav',
    index: 9,
    lyric: ''
  },
  {
    id: 11,
    title: 'Notebook',
    singer: '小安安',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar11'),
    src: 'boisterous.wav',
    index: 10,
    lyric: ''
  },
  {
    id: 12,
    title: '我是谁',
    singer: '小碗你好',
    mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar12'),
    src: 'boisterous.wav',
    index: 11,
    lyric: ''
  },
  {
    id: 13,
    title: '你好吗',
    singer: '张三-你好我好都好',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar13'),
    src: 'boisterous.wav',
    index: 12,
    lyric: ''
  },
  {
    id: 14,
    title: '你在哪',
    singer: '不知道你是谁',
    mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar14'),
    src: 'boisterous.wav',
    index: 13,
    lyric: ''
  },
  {
    id: 15,
    title: 'lovely',
    singer: 'Gwyu-Hjjiyabn',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar15'),
    src: 'boisterous.wav',
    index: 14,
    lyric: ''
  },
  {
    id: 16,
    title: '谢谢你',
    singer: '名佚',
    mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar16'),
    src: 'boisterous.wav',
    index: 15,
    lyric: ''
  },
  {
    id: 17,
    title: '我是靓仔',
    singer: '我是小树',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar17'),
    src: 'boisterous.wav',
    index: 16,
    lyric: ''
  },
  {
    id: 18,
    title: '听我说',
    singer: '全村最帅',
    mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar1'),
    src: 'boisterous.wav',
    index: 17,
    lyric: ''
  },
  {
    id: 19,
    title: '没什么大不了',
    singer: '小安安',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar2'),
    src: 'boisterous.wav',
    index: 18,
    lyric: ''
  },
  {
    id: 20,
    title: '其实也一样',
    singer: '我是小树',
    mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar13'),
    src: 'boisterous.wav',
    index: 19,
    lyric: ''
  },
  {
    id: 21,
    title: '想明白',
    singer: '小安安',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar4'),
    src: 'boisterous.wav',
    index: 20,
    lyric: ''
  },
  {
    id: 22,
    title: '你懂的',
    singer: '小安安',
    mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar5'),
    src: 'boisterous.wav',
    index: 21,
    lyric: ''
  },
  {
    id: 23,
    title: '谁了解',
    singer: '小安安',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar6'),
    src: 'boisterous.wav',
    index: 22,
    lyric: ''
  },
  {
    id: 24,
    title: '白天',
    singer: '小安安',
    mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar17'),
    src: 'boisterous.wav',
    index: 23,
    lyric: ''
  },
  {
    id: 25,
    title: '黑夜',
    singer: 'Gwyu-Hjjiyabn',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar15'),
    src: 'boisterous.wav',
    index: 24,
    lyric: ''
  },
  {
    id: 26,
    title: '春夏秋冬',
    singer: '名佚',
    mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar16'),
    src: 'boisterous.wav',
    index: 25,
    lyric: ''
  },
  {
    id: 27,
    title: '一年四季',
    singer: '我是小树',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar17'),
    src: 'boisterous.wav',
    index: 26,
    lyric: ''
  },
  {
    id: 28,
    title: '朝雪',
    singer: '全村最帅',
    mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar12'),
    src: 'boisterous.wav',
    index: 27,
    lyric: ''
  },
  {
    id: 29,
    title: '暮色',
    singer: '小安安',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar13'),
    src: 'boisterous.wav',
    index: 28,
    lyric: ''
  },
  {
    id: 30,
    title: '天下',
    singer: '我是小树',
    mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar14'),
    src: 'boisterous.wav',
    index: 29,
    lyric: ''
  },
  {
    id: 31,
    title: '勇敢',
    singer: '小安安',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar15'),
    src: 'boisterous.wav',
    index: 30,
    lyric: ''
  },
  {
    id: 32,
    title: '安明',
    singer: '小安安',
    mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar16'),
    src: 'boisterous.wav',
    index: 31,
    lyric: ''
  },
  {
    id: 33,
    title: '心安',
    singer: '小安安',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_avatar17'),
    src: 'boisterous.wav',
    index: 32,
    lyric: ''
  },
  {
    id: 34,
    title: '无归',
    singer: '小安安',
    mark: $r('app.media.ic_sq'),
    label: $r('app.media.ic_avatar11'),
    src: 'boisterous.wav',
    index: 33,
    lyric: ''
  }
]

const optionList: OptionItem[] = [
  { image: $r('app.media.ic_collect'), text: $r('app.string.collect') },
  { image: $r('app.media.ic_download'), text: $r('app.string.download') },
  {
    image: $r('app.media.ic_comments'),
    text: $r('app.string.comment'),
    action: () => {
      router.pushNamedRoute({
        name: RouterUrlConstants.MUSIC_COMMENT,
        params: null
      })
    }
  },
  { image: $r('app.media.ic_share'), text: $r('app.string.share') }
]

class OptionItem {
  image: Resource = $r('app.media.ic_collect');
  text?: Resource;
  action?: () => void;
}

export { optionList, OptionItem, songList }