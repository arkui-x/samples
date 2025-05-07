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

import { MapComponent, mapCommon, map } from '@kit.MapKit';
import { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { geoLocationManager } from '@kit.LocationKit';
import { image } from '@kit.ImageKit';
import { ClockInController } from '../model/ClockInModel';
import { Constants } from '../utils/Constants';
import { logger } from '../utils/Logger';

const TAG = 'ClockInComponent';

/**
 * 功能描述: 提供定位打卡组件，能够在地图上绘制打卡范围和显示用户当前位置标记，可以判断用户是否在打卡范围内，并显示详细的地理位置信息。同时支持动态更新用户位置，实时调整标记位置和打卡状态。
 *
 * 实现原理：
 * 1. 使用MapComponent组件初始化地图，并使用地图控制器的addCircle接口绘制打卡范围。
 * 2. 使用getCurrentLocation接口获取用户的当前位置，并使用地图控制器的addMarker在地图上添加标记。
 * 3. 根据calculateDistance计算用户位置和打卡中心点的距离，判断用户是否在打卡范围内，保存结果。
 * 4. 使用getAddressesFromLocation接口根据经纬度获取用户的地理位置信息，使用自定义信息窗customInfoWindowBuilder展示。
 * 5. 监听用户位置变化，实时更新标记的位置，并重新判断用户是否在打卡范围内。
 *
 * @param {boolean} isInArea - 是否在打卡范围内，用于决定是否允许打卡。(必需)
 * @param {ClockInController} [clockInController] - 打卡组件控制器，用于父组件与子组件之间通信，执行打卡逻辑。
 * @param {boolean} [isLocationButtonVisible] - 是否显示右下角定位按钮，默认为true。
 * @param {Position | Edges | LocalizedEdges} [locationButtonPosition] - 定位按钮位置，默认在右下角。
 * @param {boolean} isAddLocationListener - 是否开启定位监听，默认为false。
 * @param {number} [locationTimeInterval] - 监听位置变化的时间间隔，单位为秒，默认间隔为3秒。
 * @param {MapOptions} [mapOptions] - 地图初始化参数。
 * @param {MapCircleOptions} [mapCircleOptions] - 圆形打卡区域参数。
 * @param {Padding} [mapPadding] - 设置地图和边界的距离来定义地图的可见区域，默认左边距0，底边距600，单位px。
 * @param {number} [duration] - 移动相机和位置标记的动画持续时间，默认为100毫秒。
 * @param {(mapController: MapComponentController) => void} [getMapController] - 获取地图控制器的方法。
 * @param {(markerDelegate: MarkerDelegate) => void} [customInfoWindowSlotParam] - 自定义信息窗口插槽参数，可自定义窗口内容。
 */
@Component
export struct ClockInComponent {
  // 是否在打卡区域内
  @Link isInArea: boolean;
  // 设置定位按钮位置，默认在右下角
  @Prop locationButtonPosition?: Position | Edges | LocalizedEdges = {
    right: getContext().resourceManager.getNumber($r('app.integer.clock_in_location_button_right').id),
    bottom: getContext().resourceManager.getNumber($r('app.integer.clock_in_location_button_bottom').id)
  };
  // 用户当前位置（GCJ02）
  private myPositionGCJ02: mapCommon.LatLng = {
    latitude: 39.9,
    longitude: 116.4
  };
  // 用户当前位置（WGS84）
  private myPositionWGS84?: mapCommon.LatLng;
  // 圆形打卡区域参数，用于在地图上绘制打卡区域
  mapCircleOptions?: mapCommon.MapCircleOptions;
  // 地图初始化参数，设置地图中心点坐标及层级
  mapOptions: mapCommon.MapOptions = {
    position: {
      target: {
        latitude: 39.9,
        longitude: 116.4
      },
      zoom: 14
    }
  };
  // 设置地图和边界的距离来定义地图的可见区域
  mapPadding: mapCommon.Padding = {
    left: 0,
    bottom: 600
  };
  // 设置动画持续时间
  duration: number = 100;
  // 设置定位按钮是否可见，默认为true
  isLocationButtonVisible: boolean = true;
  // 是否开启定位监听
  isAddLocationListener: boolean = false;
  // 监听位置变化的时间间隔，单位为秒，默认间隔为3秒
  locationTimeInterval: number = Constants.DEFAULT_LOCATION_TIME_INTERVAL;
  // 设置用户位置标记图标
  markerIcon: string | image.PixelMap | Resource = $r('app.media.clock_in_local');
  // 标记对象
  private marker?: map.Marker;
  // 地图控制器对象
  private mapController?: map.MapComponentController;
  // 地图事件管理对象
  private mapEventManager?: map.MapEventManager;
  // 地图初始化回调
  private mapCallback?: AsyncCallback<map.MapComponentController>;
  // 获取地图控制器的方法
  private getMapController?: (mapController: map.MapComponentController) => void;
  // 打卡组件控制器对象
  clockInController?: ClockInController;

  aboutToAppear(): void {
    // 初始化地图
    this.initMap();
    if (this.clockInController) {
      this.clockInController.getAddress = this.getAddress;
    }
  }

  aboutToDisappear(): void {
    this.removeLocationListener();
  }

  /**
   * 获取当前位置地址。
   * @returns {string} 当前位置的地址字符串。
   */
  private getAddress = () => {
    if (this.marker) {
      return this.marker.getTitle();
    }
    return '';
  }

  /**
   * 初始化地图并设置相关回调。
   */
  initMap() {
    // 地图初始化的回调
    this.mapCallback = async (err, mapController) => {
      if (!err) {
        // 获取地图控制器，用来操作地图
        this.mapController = mapController;
        if (this.getMapController) {
          this.getMapController(this.mapController);
        }
        // 获取地图监听事件管理器
        this.mapEventManager = this.mapController.getEventManager();
        // 隐藏缩放控件
        this.mapController.setZoomControlsEnabled(false);
        // 设置地图和边界的距离
        this.mapController.setPadding(this.mapPadding);
        let callback = () => {
          // 验证用户是否授予定位权限，无权限则在首次启动时弹出权限申请对话框
          this.reqPermissionFromUser().then(async (grantStatus) => {
            if (grantStatus) {
              // 获取用户位置
              await this.getUserCurrentLocation();
              // 动画方式移动相机到用户位置，动画过程中设置显示标记信息窗会失效，需要等待动画结束
              await this.animateMoveCamera(this.myPositionGCJ02, this.duration);
              // 添加圆形打卡区域
              await this.addCircle();
              if (this.mapCircleOptions) {
                this.isUserInCircle(this.myPositionGCJ02, this.mapCircleOptions.center, this.mapCircleOptions.radius);
              }
              // 添加用户位置标记
              this.marker = await this.mapController?.addMarker({
                icon: this.markerIcon,
                position: this.myPositionGCJ02,
                draggable: false,
                visible: true,
                clickable: true, // 要显示信息窗口必须为true
                zIndex: 15,
                alpha: 1,
                anchorU: 0.5,
                anchorV: 1,
                rotation: 0
              });
              // 获取用户位置的地理信息并用marker的信息窗口展示
              this.setMarkerInfo();
              if (this.isAddLocationListener) {
                this.addLocationListener();
              }
            }
          }).catch((err: BusinessError) => {
            logger.error(TAG, `permission request failed, error message: ${err.message}, error code: ${err.code}`);
          });
        }
        // 监听地图加载完成事件
        this.mapEventManager.on('mapLoad', callback);
      } else {
        logger.error(TAG, `mapcomponent init failed, error message: ${err.message}, error code: ${err.code}`);
      }
    };
  }

  /**
   * 请求用户位置权限。
   * @returns {Promise<boolean>} 返回权限申请结果。
   */
  async reqPermissionFromUser() {
    const permissions: Array<Permissions> = ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION'];
    const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    const atManager = abilityAccessCtrl.createAtManager();
    const data = await atManager.requestPermissionsFromUser(context, permissions);
    return data.authResults.every((value: abilityAccessCtrl.GrantStatus) => value ===
    abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED);
  }

  /**
   * 获取用户当前位置。
   */
  async getUserCurrentLocation() {
    // TODO：知识点：getCurrentLocation获取用户当前位置，获取到的坐标在Map中使用时，需要将WGS84坐标转换为GCJ02坐标
    this.myPositionWGS84 = await geoLocationManager.getCurrentLocation();
    this.myPositionGCJ02 =
      map.convertCoordinateSync(mapCommon.CoordinateType.WGS84, mapCommon.CoordinateType.GCJ02, this.myPositionWGS84);
  }

  /**
   * 添加圆形打卡区域。
   */
  async addCircle() {
    // 组件未接收到打卡区域参数，则使用默认打卡区域
    let defaultMapCircleOptions: mapCommon.MapCircleOptions = {
      center: this.myPositionGCJ02,
      radius: 500,
      clickable: false,
      fillColor: 0x66007DFF,
      strokeWidth: 0,
      visible: true,
      zIndex: 15
    };
    if (this.mapCircleOptions !== undefined) {
      defaultMapCircleOptions = this.mapCircleOptions;
    } else {
      this.mapCircleOptions = defaultMapCircleOptions;
    }
    await this.mapController?.addCircle(defaultMapCircleOptions);
  }

  /**
   * 设置标记信息。
   */
  setMarkerInfo() {
    // TODO：知识点：逆地址解析，将坐标转换为地理描述，并展示在标记的信息窗口中
    if (this.myPositionWGS84) {
      let reverseGeocodeRequest: geoLocationManager.ReverseGeoCodeRequest = {
        latitude: this.myPositionWGS84.latitude,
        longitude: this.myPositionWGS84.longitude,
        maxItems: 1 // 获取最近的一个地址
      };
      // 将坐标转换为地理描述
      geoLocationManager.getAddressesFromLocation(reverseGeocodeRequest).then((data) => {
        if (this.marker && data[0].placeName) {
          // 显示marker信息窗
          this.marker.setTitle(data[0].placeName);
          this.marker.setInfoWindowVisible(true);
        }
      }).catch((err: BusinessError) => {
        logger.error(TAG, `addresser get failed, error message: ${err.message}, error code: ${err.code}`);
      });
    }
  }

  /**
   * 动画方式移动摄像机。
   * @param {LatLng} target - 摄像机目标位置。
   * @param {number} [duration=100] - 动画持续时间，默认为100毫秒。
   * @returns {Promise<map.AnimateResult | undefined>} 返回动画执行结果。
   */
  async animateMoveCamera(target: mapCommon.LatLng, duration: number = 100) {
    const cameraPosition: mapCommon.CameraPosition = {
      target: target,
      zoom: 15
    };
    const cameraUpdate: map.CameraUpdate = map.newCameraPosition(cameraPosition);
    return await this.mapController?.animateCameraStatus(cameraUpdate);
  }

  /**
   * 动画方式移动标记。
   * @param {Marker} marker - 需要移动的标记对象。
   * @param {LatLng} target - 标记的目标位置。
   * @param {number} [duration=100] - 动画持续时间，默认为100毫秒。
   * @returns {Promise<void>} 返回动画执行结果。
   */
  async animateMoveMarker(marker: map.Marker, target: mapCommon.LatLng, duration: number = 100) {
    // TODO：知识点：marker位置更新时添加平移动画，使其平滑移动到目标位置
    const animation: map.TranslateAnimation = new map.TranslateAnimation(target);
    animation.setDuration(duration);
    let callbackEnd = () => {
      this.setMarkerInfo();
    }
    animation.on('animationEnd', callbackEnd);
    marker.setAnimation(animation);
    marker.startAnimation();
  }

  /**
   * 添加用户位置监听。
   */
  addLocationListener() {
    let requestInfo: geoLocationManager.LocationRequest = {
      priority: geoLocationManager.LocationRequestPriority.ACCURACY,
      scenario: geoLocationManager.LocationRequestScenario.UNSET,
      timeInterval: this.locationTimeInterval,
      distanceInterval: 0,
      maxAccuracy: 0
    };
    let locationChange = (location: geoLocationManager.Location): void => {
      this.myPositionWGS84 = location;
      this.myPositionGCJ02 =
        map.convertCoordinateSync(mapCommon.CoordinateType.WGS84, mapCommon.CoordinateType.GCJ02, location);
      if (this.marker) {
        this.animateMoveMarker(this.marker, this.myPositionGCJ02, this.duration);
      }
      // 位置变动时再次判断用户是否在打卡范围内
      if (this.mapCircleOptions) {
        this.isUserInCircle(this.myPositionGCJ02, this.mapCircleOptions.center, this.mapCircleOptions.radius);
      }
    };
    geoLocationManager.on('locationChange', requestInfo, locationChange);
  }

  /**
   * 移除用户位置监听。
   */
  removeLocationListener() {
    geoLocationManager.off('locationChange');
  }

  /**
   * 判断用户是否在圆圈内。
   * @param {LatLng} pos1 - 用户位置。
   * @param {LatLng} pos2 - 圆心位置。
   * @param {number} radius - 圆半径，单位为米。
   */
  isUserInCircle(pos1: mapCommon.LatLng, pos2: mapCommon.LatLng, radius: number) {
    // TODO：知识点：通过计算两点之间的距离与圆半径的关系来判断用户是否在打卡圆圈内
    const distance = map.calculateDistance(pos1, pos2);
    this.isInArea = distance <= radius;
  }

  /**
   * 自定义信息窗口插槽。
   * @param {Marker} marker - 标记对象。
   */
  @Builder
  customInfoWindowSlot(marker: map.Marker) {
    Text(marker.getTitle())
      .lineHeight($r('app.integer.clock_in_line_height'))
      .textAlign(TextAlign.Center)
      .fontColor(Color.Black)
      .font({ size: $r('app.integer.clock_in_font_size'), weight: FontWeight.Bold })
  }

  @BuilderParam customInfoWindowSlotParam: (marker: map.Marker) => void = this.customInfoWindowSlot;

  // 自定义信息窗口
  @Builder
  customInfoWindowBuilder($$: map.MarkerDelegate) {
    if ($$.marker) {
      RelativeContainer() {
        Row() {
          // 通过自定义信息窗口插槽函数自定义内容
          this.customInfoWindowSlotParam($$.marker)
        }
        .padding($r('app.integer.clock_in_padding'))
        .borderRadius($r('app.integer.clock_in_border_radius'))
        .backgroundColor(Color.White)
        .alignRules({
          bottom: { anchor: 'polygon', align: VerticalAlign.Top },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })

        Polygon({ width: Constants.TRIANGLE_WIDTH, height: Constants.TRIANGLE_HEIGHT })
          .id('polygon')
          .points([[0, 0], [Constants.TRIANGLE_WIDTH / 2, Constants.TRIANGLE_HEIGHT], [Constants.TRIANGLE_WIDTH, 0]])
          .fill(Color.White)
          .alignRules({
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .id('customInfoWindowContainer')
      .height($r('app.integer.clock_in_height'))
      .constraintSize({
        maxWidth: $r('app.integer.clock_in_max_width')
      })
    }
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      // 使用MapComponent组件初始化地图
      MapComponent({
        mapOptions: this.mapOptions,
        mapCallback: this.mapCallback,
        customInfoWindow: (markerDelegate: map.MarkerDelegate) => {
          this.customInfoWindowBuilder(markerDelegate);
        }
      })
        .id('map')
        .width($r('app.string.clock_in_full_size'))
        .height($r('app.string.clock_in_full_size'))
      // 右下角定位按钮
      if (this.isLocationButtonVisible) {
        Image($r('app.media.clock_in_position'))
          .id('locatingButton')
          .width($r('app.integer.clock_in_image_width'))
          .height($r('app.integer.clock_in_image_height'))
          .objectFit(ImageFit.Contain)
          .padding($r('app.integer.clock_in_image_padding'))
          .backgroundColor(Color.White)
          .borderRadius($r('app.integer.clock_in_image_radius'))
          .position(this.locationButtonPosition || {
            right: getContext().resourceManager.getNumber($r('app.integer.clock_in_location_button_right').id),
            bottom: getContext().resourceManager.getNumber($r('app.integer.clock_in_location_button_bottom').id)
          })
          .onClick(async () => {
            await this.getUserCurrentLocation();
            this.animateMoveCamera(this.myPositionGCJ02, this.duration);
            if (this.marker) {
              this.animateMoveMarker(this.marker, this.myPositionGCJ02, this.duration);
            }
            if (this.mapCircleOptions) {
              this.isUserInCircle(this.myPositionGCJ02, this.mapCircleOptions.center, this.mapCircleOptions.radius);
            }
          })
      }
    }
    .width($r('app.string.clock_in_full_size'))
    .height($r('app.string.clock_in_full_size'))
  }
}