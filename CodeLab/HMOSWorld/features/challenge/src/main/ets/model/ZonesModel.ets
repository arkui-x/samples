/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import ZonesItem from './ZonesItem';

export enum TravelModeType {
  DRIVING = 0,
  WAlKING,
  CYCLING,
  TRANSIT
}

export interface TravelMode {
  mode: TravelModeType,
  title: ResourceStr,
  tagIcon: ResourceStr
}

export const TravelModes: TravelMode[] = [
  {
    mode: TravelModeType.DRIVING,
    title: $r('app.string.driving'),
    tagIcon: $r('app.media.ic_travel_driving')
  },
  {
    mode: TravelModeType.DRIVING,
    title: $r('app.string.cycling'),
    tagIcon: $r('app.media.ic_travel_cycling')
  },
  {
    mode: TravelModeType.DRIVING,
    title: $r('app.string.walking'),
    tagIcon: $r('app.media.ic_travel_working')
  },
]

export const RouteNames: Resource[] =
  [$r('app.string.recommended'), $r('app.string.option_one'), $r('app.string.option_two')]

class ZonesModel {
  getZonesList(): ZonesItem[] {
    return defaultList;
  }

  getZonesByIndex(index: number): ZonesItem {
    return defaultList[index];
  }
}

let zonesModel = new ZonesModel();

export default zonesModel as ZonesModel;

const defaultList: ZonesItem[] = [
  {
    id: 0,
    title: $r('app.string.name_f'),
    titleColor: 0xFF0A59F7,
    icon: $r('app.media.ic_point_f'),
    subTitle: $r('app.string.area_sub_name_f'),
    swiperPic: $r('app.media.ic_F'),
    createTime: $r('app.string.create_year_2015'),
    content: [$r('app.string.introduction_paragraph_first_f'),
      $r('app.string.introduction_paragraph_second_f')],
    subPicTop: $r('app.media.ic_top_f'),
    subPicMedium: $r('app.media.ic_F_photo_top'),
    subPicBottom: $r('app.media.ic_F_photo_bottom'),
    titleIcon: $r('app.media.ic_title_top_f'),
    imageList: [$r('app.media.ic_F_1'), $r('app.media.ic_F_2'), $r('app.media.ic_F_3'), $r('app.media.ic_F_4'),
      $r('app.media.ic_F_5')],
    buildingInformation: $r('app.string.build_information_f'),
    buildingPic: $r('app.media.ic_building_F'),
    geographyPics: [$r('app.media.ic_geography_dark_F'), $r('app.media.ic_location_f')],
    position: { x: '35.3%', y: '18.8%' },
    location: { longitude: 113.887634, latitude: 22.875929 },
    backgroundColor: $r('app.color.introduction_page_orange_light'),
    starLinePic: [$r('app.media.ic_star_f_lighter'), $r('app.media.ic_star_f_dark')]
  },
  {
    id: 1,
    title: $r('app.string.name_g'),
    titleColor: 0xFF0A59F7,
    icon: $r('app.media.ic_point_g'),
    subTitle: $r('app.string.area_sub_name_g'),
    swiperPic: $r('app.media.ic_G'),
    createTime: $r('app.string.create_year_2015'),
    content: [$r('app.string.introduction_paragraph_first_g'),
      $r('app.string.introduction_paragraph_second_g')],
    subPicTop: $r('app.media.ic_top_g'),
    subPicMedium: $r('app.media.ic_G_photo_top'),
    subPicBottom: $r('app.media.ic_G_photo_bottom'),
    titleIcon: $r('app.media.ic_title_top_g'),
    imageList: [$r('app.media.ic_G_1'), $r('app.media.ic_G_2'), $r('app.media.ic_G_3'), $r('app.media.ic_G_4'),
      $r('app.media.ic_G_5')],
    buildingInformation: $r('app.string.build_information_g'),
    buildingPic: $r('app.media.ic_building_G'),
    geographyPics: [$r('app.media.ic_geography_dark_G'), $r('app.media.ic_location_g')],
    position: { x: '35.9%', y: '35%' },
    location: { longitude: 113.890251, latitude: 22.877352 },
    backgroundColor: $r('app.color.introduction_page_blue'),
    starLinePic: [$r('app.media.ic_star_g_lighter'), $r('app.media.ic_star_g_dark')]
  },
  {
    id: 2,
    title: $r('app.string.name_h'),
    titleColor: 0xFF65BB5C,
    icon: $r('app.media.ic_point_h'),
    subTitle: $r('app.string.area_sub_name_h'),
    swiperPic: $r('app.media.ic_H'),
    createTime: $r('app.string.create_year_2015'),
    content: [$r('app.string.introduction_paragraph_first_h'),
      $r('app.string.introduction_paragraph_second_h')],
    subPicTop: $r('app.media.ic_top_h'),
    subPicMedium: $r('app.media.ic_H_photo_top'),
    subPicBottom: $r('app.media.ic_H_photo_bottom'),
    titleIcon: $r('app.media.ic_title_top_h'),
    imageList: [$r('app.media.ic_H_1'), $r('app.media.ic_H_2'), $r('app.media.ic_H_3'), $r('app.media.ic_H_4'),
      $r('app.media.ic_H_5')],
    buildingInformation: $r('app.string.build_information_h'),
    buildingPic: $r('app.media.ic_building_H'),
    geographyPics: [$r('app.media.ic_geography_dark_H'), $r('app.media.ic_location_h')],
    position: { x: '32.6%', y: '38.9%' },
    location: { longitude: 113.890488, latitude: 22.880936 },
    backgroundColor: $r('app.color.introduction_page_blue_light'),
    starLinePic: [$r('app.media.ic_star_h_lighter'), $r('app.media.ic_star_h_dark')]
  },
  {
    id: 3,
    title: $r('app.string.name_j'),
    titleColor: 0xFF65BB5C,
    icon: $r('app.media.ic_point_j'),
    subTitle: $r('app.string.area_sub_name_j'),
    swiperPic: $r('app.media.ic_J'),
    createTime: $r('app.string.create_year_2015'),
    content: [$r('app.string.introduction_paragraph_first_j'),
      $r('app.string.introduction_paragraph_second_j')],
    subPicTop: $r('app.media.ic_top_j'),
    subPicMedium: $r('app.media.ic_J_photo_top'),
    subPicBottom: $r('app.media.ic_J_photo_bottom'),
    titleIcon: $r('app.media.ic_title_top_j'),
    imageList: [$r('app.media.ic_J_1'), $r('app.media.ic_J_2'), $r('app.media.ic_J_3'), $r('app.media.ic_J_4'),
      $r('app.media.ic_J_5')],
    buildingInformation: $r('app.string.build_information_j'),
    buildingPic: $r('app.media.ic_building_J'),
    geographyPics: [$r('app.media.ic_geography_dark_J'), $r('app.media.ic_location_j')],
    position: { x: '33.9%', y: '50%' },
    location: { longitude: 113.889091, latitude: 22.883272 },
    backgroundColor: $r('app.color.introduction_page_red'),
    starLinePic: [$r('app.media.ic_star_j_lighter'), $r('app.media.ic_star_j_dark')]
  },
  {
    id: 4,
    title: $r('app.string.name_k'),
    titleColor: 0xFFE84429,
    icon: $r('app.media.ic_point_k'),
    subTitle: $r('app.string.area_sub_name_k'),
    swiperPic: $r('app.media.ic_K'),
    createTime: $r('app.string.create_year_2015'),
    content: [$r('app.string.introduction_paragraph_first_k'),
      $r('app.string.introduction_paragraph_second_k')],
    subPicTop: $r('app.media.ic_top_k'),
    subPicMedium: $r('app.media.ic_K_photo_top'),
    subPicBottom: $r('app.media.ic_K_photo_bottom'),
    titleIcon: $r('app.media.ic_title_top_k'),
    imageList: [$r('app.media.ic_K_1'), $r('app.media.ic_K_2'), $r('app.media.ic_K_3'), $r('app.media.ic_K_4'),
      $r('app.media.ic_K_5')],
    buildingInformation: $r('app.string.build_information_k'),
    buildingPic: $r('app.media.ic_building_K'),
    geographyPics: [$r('app.media.ic_geography_dark_K'), $r('app.media.ic_location_k')],
    position: { x: '46.1%', y: '44.4%' },
    location: { longitude: 113.88549, latitude: 22.881063 },
    backgroundColor: $r('app.color.introduction_page_blue_k'),
    starLinePic: [$r('app.media.ic_star_k_lighter'), $r('app.media.ic_star_k_drak')]
  },
  {
    id: 5,
    title: $r('app.string.name_l'),
    titleColor: 0xFFE84429,
    icon: $r('app.media.ic_point_l'),
    subTitle: $r('app.string.area_sub_name_l'),
    swiperPic: $r('app.media.ic_L'),
    createTime: $r('app.string.create_year_2015'),
    content: [$r('app.string.introduction_paragraph_first_l'),
      $r('app.string.introduction_paragraph_second_l')],
    subPicTop: $r('app.media.ic_top_l'),
    subPicMedium: $r('app.media.ic_L_photo_top'),
    subPicBottom: $r('app.media.ic_L_photo_bottom'),
    titleIcon: $r('app.media.ic_title_top_l'),
    imageList: [$r('app.media.ic_L_1'), $r('app.media.ic_L_2'), $r('app.media.ic_L_3'), $r('app.media.ic_L_4'),
      $r('app.media.ic_L_5')],
    buildingInformation: $r('app.string.build_information_l'),
    buildingPic: $r('app.media.ic_building_L'),
    geographyPics: [$r('app.media.ic_geography_dark_L'), $r('app.media.ic_location_l')],
    position: { x: '46.1%', y: '44.4%' },
    location: { longitude: 113.886642, latitude: 22.878538 },
    backgroundColor: $r('app.color.introduction_page_red_light'),
    starLinePic: [$r('app.media.ic_star_l_lighter'), $r('app.media.ic_star_l_dark')]
  }
]

