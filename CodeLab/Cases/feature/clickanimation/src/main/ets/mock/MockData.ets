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
import { ReviewItem } from '../model/ReviewDataModel';

/**
 * 用户评论列表mock数据
 */
export const REVIEW_DATA: Array<ReviewItem> = [
  new ReviewItem('用户1', '主播介绍得好详细，产品看起来很棒，已下单！'),
  new ReviewItem('用户2', '这个直播间的优惠力度真的大，爱了爱了。')
];

/**
 * 点击图标种类列表mock数据
 */
export const ICON_LIST: Array<Resource> =
  [$r('app.media.click_animation_heart'), $r('app.media.click_animation_flower'), $r('app.media.click_animation_pear'),
    $r('app.media.click_animation_cherries'), $r('app.media.click_animation_banana')];