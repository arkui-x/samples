/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { LatLng } from '@amap/amap_lbs_map3d';

export class Constants {
  public static ERROR = 1001; // 网络异常
  public static ROUTE_START_SEARCH = 2000;
  public static ROUTE_END_SEARCH = 2001;
  public static ROUTE_BUS_RESULT = 2002; // 路径规划中公交模式
  public static ROUTE_DRIVING_RESULT = 2003; // 路径规划中驾车模式
  public static ROUTE_WALK_RESULT = 2004; // 路径规划中步行模式
  public static ROUTE_NO_RESULT = 2005; // 路径规划没有搜索到结果

  public static GEOCODER_RESULT = 3000; // 地理编码或者逆地理编码成功
  public static GEOCODER_NO_RESULT = 3001; // 地理编码或者逆地理编码没有数据

  public static POISEARCH = 4000; // poi搜索到结果
  public static POISEARCH_NO_RESULT = 4001; // poi没有搜索到结果
  public static POISEARCH_NEXT = 5000; // poi搜索下一页

  public static BUSLINE_LINE_RESULT = 6001; // 公交线路查询
  public static BUSLINE_id_RESULT = 6002; // 公交id查询
  public static BUSLINE_NO_RESULT = 6003; // 异常情况

  public static BEIJING = new LatLng(39.90403, 116.407525); // 北京市经纬度
  public static ZHONGGUANCUN = new LatLng(39.983456, 116.3154950); // 北京市中关村经纬度
  public static SHANGHAI = new LatLng(31.238068, 121.501654); // 上海市经纬度
  public static FANGHENG = new LatLng(39.989614, 116.481763); // 方恒国际中心经纬度
  public static CHENGDU = new LatLng(30.679879, 104.064855); // 成都市经纬度
  public static XIAN = new LatLng(34.341568, 108.940174); // 西安市经纬度
  public static ZHENGZHOU = new LatLng(34.7466, 113.625367); // 郑州市经纬度
  public static MAP_SHOW_FUNC = '显示地图';
  public static MAP_SETTING_SWITCH_FUNC = '设置开关'
  public static MAP_MULTI_FUNC = '地图多实例';
  public static MAP_BOUND_LIMIT_FUNC = '限制显示区域';
  public static MAP_INDOOR_FUNC = '室内地图功能';
  public static MAP_OVERLAY_ZINDEX_FUNC = '覆盖物层级功能';
  public static MAP_EN_LANGUAGE_FUNC = '英文地图功能';
  public static MAP_MARKER_FUNC = 'Marker功能';
  public static MAP_INFOWINDOW_FUNC = 'infowindow功能';
  public static MAP_POLYLINE_FUNC = 'Polyline功能';
  public static MAP_MARKER_ANIMATION_FUNC = 'Marker动画功能';
  public static MAP_MARKER_CLICK_FUNC = 'Marker点击回调';
  public static MAP_MARKER_CUSTOM_FUNC = '自定义Marker';
  public static MAP_POLYGON_FUNC = 'Polygon功能';
  public static MAP_CIRCLE_FUNC = 'Circle功能';
  public static MAP_GL3DMODEL_FUNC = 'GL3DModel功能';
  public static MAP_MYLOCATION_FUNC = 'MyLocation功能';
  public static MAP_UISETTINGS_FUNC = 'UiSettings功能';
  public static MAP_GESTURE_FUNC = '手势功能';
  public static MAP_LAYER_FUNC = 'Layer图层功能';
  public static MAP_PROJECTION_FUNC = 'projection功能';
  public static MAP_CAMERA_UPDATE_FUNC = 'CamerUpdate功能';
  public static MAP_WEATHER_SEARCH_FUNC = '天气查询功能';
  public static MAP_ROUTEDRIVE_FUNC = '驾车路线规划功能';
  public static MAP_ROUTEDRIVEV2_FUNC = '驾车路线规划功能V2';
  public static MAP_ROUTEDRIVE_DETAIL_FUNC = '驾车路线规划详情页';
  public static MAP_ROUTEDRIVE_DETAILV2_FUNC = '驾车路线规划详情页V2';
  public static MAP_ROUTEDRIVE_PLAN_FUNC = '计划驾车路线规划功能';
  public static MAP_ROUTERIDE_FUNC = '骑行路线规划功能'
  public static MAP_ROUTEWALK_FUNC = '步行路线规划功能';
  public static MAP_ROUTEWALKV2_FUNC = '步行路线规划功能V2';
  public static MAP_ROUTEWALK_DETAIL_FUNC = '步行路线规划详情页';
  public static MAP_ROUTERIDE2_FUNC = '骑行路线规划功能V2'
  public static MAP_ROUTERIDE_DETAIL_FUNC = '骑行路线规划详情页';
  public static MAP_GEOCODE_FUNC = '地理编码';
  public static MAP_REGEOCODE_FUNC = '逆地理编码';
  public static MAP_POI_KEYWORD_SEARCH_FUNC = 'poi关键字搜索';
  public static MAP_POI_AROUND_SEARCH_FUNC = 'poi周边搜索';
  public static MAP_POI_ID_SEARCH_FUNC = 'poiID搜索';
  public static MAP_ROUTEPOI_FUNC = '道路沿途搜索';
  public static MAP_INPUT_TIPS_FUNC = '输入内容自动提示';
  public static MAP_OFFLINEMAP_FUNC = '离线地图功能（组件包含UI）';
  public static MAP_ROUTEDISTANCE_FUNC = '距离测量';
  public static MAP_ROUTETRUCK_FUNC = '货车路线规划功能'
  public static MAP_ROUTETRUCK_DETAIL_FUNC = '货车路线规划详情页'
  public static MAP_MULTIPOINTOVERLAY_FUNC = '海量点显示'
  public static MAP_SCREENSHOT_FUNC = '地图截图功能';
  public static MAP_HEAT_PICTURES = '热力图';
  public static MAP_HEAT_HONEY = '蜂窝热力图';
  public static MAP_DISTRICT_FUNC = '行政区划查询';
  public static MAP_DISTRICT_WITH_BOUNDARY_FUNC = '行政区划边界查询';
  public static MAP_GROUNDOVERLAY_FUNC = '绘制自定义图层';
  public static MAP_SMOOTHMOVING_FUNC = '平滑移动';
  public static MAP_ARC_FUNC = '绘制弧线';
  public static MAP_ROUTEBUS_FUNC = '公交路线规划功能';
  public static MAP_ROUTEBUSV2_FUNC = '公交路线规划功能V2';
  public static MAP_ROUTEBUS_DETAIL_FUNC = '公交路线详情';
  public static MAP_CALCULATEDISTANCE_FUNC = '两点间距离';
  public static MAP_BUSSTATIONQUERY_FUNC = '公交站点查询';
  public static MAP_BUS_LINE_QUERY_FUNC = 'Busline公交查询';
  public static MAP_TOOLSCOORDCONVER_FUNC = '坐标系转换'
  public static MAP_TRACE_FUNC = '轨迹纠偏功能';
  public static MAP_TRACE_SIMPLE_FUNC = '轨迹纠偏功能_便捷版';

  public static rgbaStringToArgbInt(rgbaString: string): number {
    const match = rgbaString.match(/^rgba\((\d+(\.\d+)?),\s*(\d+(\.\d+)?),\s*(\d+(\.\d+)?)\s*,\s*(\d+(\.\d+)?)\)$/);
    if (!match) {
      throw new Error("Invalid RGBA string");
    }

    const r = Math.round(parseFloat(match[1]) * 255);
    const g = Math.round(parseFloat(match[3]) * 255);
    const b = Math.round(parseFloat(match[5]) * 255);
    const a = Math.round(parseFloat(match[7]) * 255);

    return ((a & 0xFF) << 24) | ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF);
  }
}