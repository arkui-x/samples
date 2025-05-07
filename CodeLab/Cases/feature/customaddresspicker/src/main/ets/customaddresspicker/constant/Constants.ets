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

/**
 * 常量
 */
export default class Constants {
  // 调用changeIndex切换TabContent动画时长
  public static readonly ANIMATION_DURATION: number = 300;
  // rawfile目录下的省市区json文件
  public static readonly JSON_FILE: string = 'address.json';
  // 自定义TabBar切换tab动画分隔线宽度
  public static readonly DIVIDER_WIDTH: number = 20;
  // 字体粗细
  public static readonly FONT_WEIGHT_THREE_HUNDRED: number = 300;
  public static readonly FONT_WEIGHT_FOUR_HUNDRED: number = 400;
  public static readonly FONT_WEIGHT_FIVE_HUNDRED: number = 500;
  public static readonly SIZE_ONE: number = 1;
  // 分隔线粗细
  public static readonly STROKE_WIDTH: number = 2;
  // 顶部省市区间隔
  public static readonly AREA_SPACE: number = 12;
}