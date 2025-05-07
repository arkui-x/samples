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
import { MyGridItem, MySwiperItem, MyTabItem } from '../model/DataModel';

/**
 * 功能图标网格数据
 */
export const GRID_ITEMS: MyGridItem[] = [
  { icon: $r('app.media.cube_animation_gallery_blur_filled'), title: '模块1' },
  { icon: $r('app.media.cube_animation_discover'), title: '模块2' },
  { icon: $r('app.media.cube_animation_favorite'), title: '模块3' },
  { icon: $r('app.media.cube_animation_gallery'), title: '模块4' },
  { icon: $r('app.media.cube_animation_desktop_widgets'), title: '模块5' },
  { icon: $r('app.media.cube_animation_cloud_browse'), title: '模块6' },
  { icon: $r('app.media.cube_animation_presentation_drive'), title: '模块7' },
  { icon: $r('app.media.cube_animation_spreadsheet_drive'), title: '模块8' }
];

/**
 * Tab标签数据
 */
export const TAB_ITEMS: MyTabItem[] = [
  {
    icon: $r('app.media.cube_animation_main_normal'),
    selectedIcon: $r('app.media.cube_animation_main_select'),
    title: $r('app.string.cube_animation_main')
  },
  {
    icon: $r('app.media.cube_animation_hot_normal'),
    selectedIcon: $r('app.media.cube_animation_hot_select'),
    title: $r('app.string.cube_animation_hot')
  },
  {
    icon: $r('app.media.cube_animation_find_normal'),
    selectedIcon: $r('app.media.cube_animation_find_select'),
    title: $r('app.string.cube_animation_find')
  },
  {
    icon: $r('app.media.cube_animation_my_normal'),
    selectedIcon: $r('app.media.cube_animation_my_select'),
    title: $r('app.string.cube_animation_my')
  }
];

/**
 * 图片数据
 */
export const IMAGES: Resource[] = [
  $r('app.media.cube_animation_picture1'),
  $r('app.media.cube_animation_picture2'),
  $r('app.media.cube_animation_picture3'),
  $r('app.media.cube_animation_picture4')
];

/**
 * 3D立方体旋转动画Swiper数据
 */
export const SWIPER_LIST: MySwiperItem[][] = [
  [new MySwiperItem('农业资讯', '最新农业政策信息', $r('app.media.cube_animation_picture1')),
    new MySwiperItem('生活服务', '便民服务一站式办理', $r('app.media.cube_animation_picture2')),
    new MySwiperItem('健康养老', '智慧医疗养老服务', $r('app.media.cube_animation_picture3')),
    new MySwiperItem('文化活动', '丰富多彩文化生活', $r('app.media.cube_animation_picture4'))],
  [new MySwiperItem('生活服务', '便民服务一站式办理', $r('app.media.cube_animation_picture2')),
    new MySwiperItem('健康养老', '智慧医疗养老服务', $r('app.media.cube_animation_picture3'))],
  [new MySwiperItem('健康养老', '智慧医疗养老服务', $r('app.media.cube_animation_picture3')),
    new MySwiperItem('文化活动', '丰富多彩文化生活', $r('app.media.cube_animation_picture4'))]
]