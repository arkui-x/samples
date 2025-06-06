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

import { CONFIGURATION } from '../common/Constants';
import { TabDataModel } from '../model/DragToSwitchPicturesModule';
import { WaterFlowModule } from '../model/DragToSwitchPicturesModule';

/**
 * Tabs组件数据
 */
export const TAB_DATA: Array<TabDataModel> = [
  new TabDataModel(CONFIGURATION.TABS_TABBAR_INDEX0, $r('app.string.dragtoswitchpictures_recommendation')),
  new TabDataModel(CONFIGURATION.TABS_TABBAR_INDEX1, $r('app.string.dragtoswitchpictures_second_hand_house')),
  new TabDataModel(CONFIGURATION.TABS_TABBAR_INDEX2, $r('app.string.dragtoswitchpictures_new_house')),
  new TabDataModel(CONFIGURATION.TABS_TABBAR_INDEX3, $r('app.string.dragtoswitchpictures_renting')),
  new TabDataModel(CONFIGURATION.TABS_TABBAR_INDEX4, $r('app.string.dragtoswitchpictures_decoration')),
]

/**
 * WaterFlow组件数据
 */
export const waterFlowData: WaterFlowModule[] = [
  new WaterFlowModule($r("app.media.dragtoswitchpictures_WaterFlow1"), '地铁口 精装带地暖三房 满二唯一 夹边套 南北通', '3室2厅 | 88.78㎡ | 南 北'),
  new WaterFlowModule($r("app.media.dragtoswitchpictures_WaterFlow2"), '精装花了两百多万，小区距地铁近，交通出行都很方便', '5室2厅 | 256.86㎡ | 南'),
  new WaterFlowModule($r("app.media.dragtoswitchpictures_WaterFlow3"), '靠东白马湖 高楼层视野开阔 房子采光无遮挡 环境优美', '3室2厅 | 88.86㎡ | 南'),
  new WaterFlowModule($r("app.media.dragtoswitchpictures_WaterFlow4"), '万科映月华庭 满两年 夹边套 3房1卫 高楼层 诚售', '3室2厅 | 81.72㎡ | 东 南'),
  new WaterFlowModule($r("app.media.dragtoswitchpictures_WaterFlow5"), '乐虹湾三房精装修，地暖，中央空调，高楼层采光好', '3室2厅 | 88.86㎡ | 南'),
  new WaterFlowModule($r("app.media.dragtoswitchpictures_WaterFlow6"), '湘湖地铁口，次新小区，楼幢位置，视野好', '3室2厅 | 88.86㎡ | 南'),
  new WaterFlowModule($r("app.media.dragtoswitchpictures_WaterFlow7"), '白马湖畔 三千余户的小区 滨江品质 精装地暖 自主中', '3室2厅 | 88.86㎡ | 南'),
  new WaterFlowModule($r("app.media.dragtoswitchpictures_WaterFlow8"), '开发商精装，面对花园，三房二厅二卫，自住15w软装', '3室2厅 | 89.71㎡ | 南'),
]
