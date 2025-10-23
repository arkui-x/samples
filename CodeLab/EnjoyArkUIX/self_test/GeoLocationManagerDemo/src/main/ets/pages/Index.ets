import { geoLocationManager } from '@kit.LocationKit';
import { abilityAccessCtrl, common, PermissionRequestResult, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { notificationManager } from '@kit.NotificationKit';
import btAccess from '@ohos.bluetooth.access';

const LOCATION_PERMISSIONS: Permissions[] = ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION','ohos.permission.ACCESS_BLUETOOTH']

@Entry
@Component
struct Index {
  private currentLocation: geoLocationManager.Location | undefined;
  private fenceId: number | undefined;
  private Id: number | undefined;
  @State message: string = 'Hello World';
  @State isShow: boolean = true;
  @State cityInfo: string = '当前位置';
  @State inputCityInfo: string = '';
  @State countryCode: string = '';
  @State WIFIInfo: string = '';
  @State GeofenceSupportedCoordTypes: string = '';
  @State onCurrentLocationInfo: string = ''
  @State locationEnableFlag: boolean = false;
  @State satelliteStatusFlag: boolean = false;
  @State bluetoothScanFlag: boolean = false;
  @State distance: number = 0;
  @State satelliteStatusInfoText: string = '';
  @State locationErrorInfo: string = '';
  @State nmeaMessageText: string = '';
  @State bluetoothScanResultText: string = '';
  @State lastLocationInfo: string = '';
  @State geofenceTransitionInfo: string = '';
  @State fenceIdText: string = '';
  @State geocodeText: string = '';
  @State reverseGeocodeText: string = '';
  @State removeGnssGeofenceText: string = ''

  /**
   * 移除地理围栏
   */
  private removeGnssGeofence() {
    if (this.fenceId) {
      try {
        geoLocationManager.removeGnssGeofence(this.fenceId).then(() => {
          this.removeGnssGeofenceText = ' FenceId = ' + JSON.stringify(this.fenceId);
          // this.fenceMapInstance && this.aMapInstance?.clear()
        }).catch((error: BusinessError) => {
          console.error("removeGnssGeofence: error=" + JSON.stringify(error));
        });
      } catch (error) {
        console.error("removeGnssGeofence: error=" + JSON.stringify(error));
      }
    }
  }

  private removeGnssGeofenceByid() {
    if (this.fenceId) {
      try {
        geoLocationManager.removeGnssGeofence(this.Id).then(() => {
          // this.fenceMapInstance && this.aMapInstance?.clear()
        }).catch((error: BusinessError) => {
          console.error("removeGnssGeofence: error=" + JSON.stringify(error));
        });
      } catch (error) {
        console.error("removeGnssGeofence: error=" + JSON.stringify(error));
      }
    }
  }

  /**
   * 调用逆地理编码服务，将坐标转换为地理描述，使用callback异步回调
   * param point: LatLng
   */
  private getAddressesFromLocation() {
    // console.log(`getAddressesFromLocation ： ${JSON.stringify(point)}`);
    // 判断地理编码与逆地理编码服务状态
    if (!geoLocationManager.isGeocoderAvailable()) {
      return
    }
    let reverseGeocodeRequest: geoLocationManager.ReverseGeoCodeRequest =
      {
        "latitude": this.currentLocation?.latitude ?? 0,
        "longitude": this.currentLocation?.longitude ?? 0,
        "maxItems": 1
      };
    try {
      geoLocationManager.getAddressesFromLocation(reverseGeocodeRequest, (err, data) => {
        if (err) {
          console.error('getAddressesFromLocation: err=' + JSON.stringify(err));
        }
        if (data) {
          console.info('getAddressesFromLocation: data=' + JSON.stringify(data));
          this.cityInfo = data?.[0]?.locality ?? '';
          this.reverseGeocodeText = JSON.stringify(data);
        }
      });
    } catch (err) {
      console.error("getAddressesFromLocation errCode:" + err.code + ", message:" + err.message);
    }
  }

  /**
   * 获取当前位置
   */
  private getCurrentLocation() {
    // 1. 检查权限与定位开关
    if (!this.requestPermissions() || !geoLocationManager.isLocationEnabled() || !this.locationEnableFlag) {
      console.error('权限或定位开关未开启');
      return;
    }

    // 2. 配置请求参数
    let requestInfo: geoLocationManager.SingleLocationRequest =
      { 'locatingTimeoutMs': 10000, 'locatingPriority': geoLocationManager.LocatingPriority.PRIORITY_ACCURACY };
    let locationChange = (err: BusinessError, location: geoLocationManager.Location): void => {
      if (err) {
        console.error('locationChange: err=' + JSON.stringify(err));
      }
      if (location) {
        this.currentLocation = location;
        // { latitude: location.latitude, longitude: location.longitude } as LatLng
        this.getAddressesFromLocation()
        console.info('locationChange: location=' + JSON.stringify(location));
        // let options: MarkerOptions = new MarkerOptions();
        // options.setPosition(new LatLng(location.latitude, location.longitude));
        // let marker = this.aMapInstance?.addMarker(options);
        // marker?.setTitle('我的位置');
      }
    };

    try {
      geoLocationManager.getCurrentLocation(locationChange);
    } catch (err) {
      console.error("errCode:" + err.code + ", message:" + err.message);
    }
  }

  /**
   * 动态申请权限
   * @returns
   */
  private async requestPermissions(): Promise<PermissionRequestResult | boolean> {
    // 访问控制管理：创建程序访问控制管理的实例对象
    const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    try {
      let context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      const permissionResult = await atManager.requestPermissionsFromUser(context, LOCATION_PERMISSIONS);
      console.info(`requestPermissionsFromUser success, result: ${JSON.stringify(permissionResult)}`);
      if (permissionResult && permissionResult?.['permissions']) {
        return JSON.stringify(permissionResult['permissions']) === JSON.stringify(LOCATION_PERMISSIONS)
      }
      return false;
    } catch (err) {
      console.error('权限申请失败:', err);
      return false
    }
  }

  /**
   * 添加一个GNSS地理围栏，并订阅地理围栏事件
   */
  private addGnssGeofence() {
    const RADIUS: number = 10000;
    this.requestPermissions();
    // 创建围栏
    let geofence: geoLocationManager.Geofence = {
      "latitude": this.currentLocation?.latitude ?? 34.12,
      "longitude": this.currentLocation?.longitude ?? 124.11,
      "radius": RADIUS, //表示圆形围栏的半径。单位是米，取值范围为大于0。
      "expiration": 10000.0 //围栏存活的时间，单位是毫秒。取值范围为大于0
    }
    // 指定APP需要监听的地理围栏事件类型，这里表示需要监听进入围栏和退出围栏事件
    let transitionStatusList: Array<geoLocationManager.GeofenceTransitionEvent> = [
      geoLocationManager.GeofenceTransitionEvent.GEOFENCE_TRANSITION_EVENT_ENTER,
      geoLocationManager.GeofenceTransitionEvent.GEOFENCE_TRANSITION_EVENT_EXIT,
    ];
    // 创建GEOFENCE_TRANSITION_EVENT_ENTER事件对应的通知对象
    let notificationRequest1: notificationManager.NotificationRequest = {
      id: 1,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: "围栏通知",
          text: "围栏进入",
          additionalText: ""
        }
      }
    };
    // 创建GEOFENCE_TRANSITION_EVENT_EXIT事件对应的通知对象
    let notificationRequest2: notificationManager.NotificationRequest = {
      id: 2,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: '围栏通知',
          text: '围栏退出',
          additionalText: ""
        }
      }
    };
    // 把创建的通知对象存入Array中，存入顺序与transitionStatusList一致
    let notificationRequestList: Array<notificationManager.NotificationRequest> =
      [notificationRequest1, notificationRequest2];
    // 构造GNSS地理围栏请求对象gnssGeofenceRequest
    let gnssGeofenceRequest: geoLocationManager.GnssGeofenceRequest = {
      // 围栏属性，包含圆心和半径等信息
      geofence: geofence,
      // 指定APP需要监听的地理围栏事件类型
      monitorTransitionEvents: transitionStatusList,
      // 地理围栏事件对应的通知对象，该参数为可选
      notifications: notificationRequestList,
      // 用于监听围栏事件的callback
      geofenceTransitionCallback: (err: BusinessError, transition: geoLocationManager.GeofenceTransition) => {
        if (err) {
          console.error('geofenceTransitionCallback: err=' + JSON.stringify(err));
        }
        if (transition) {
          console.info("GeofenceTransition: %{public}s", JSON.stringify(transition));
        }
      }
    }
    try {
      // 添加围栏
      geoLocationManager.addGnssGeofence(gnssGeofenceRequest).then((id) => {
        // 围栏添加成功后返回围栏ID
        console.info("addGnssGeofence success, fence id: " + id);

        // let circleOptions: CircleOptions = new CircleOptions();
        // circleOptions.setRadius(RADIUS); //设置圆的半径，单位:米
        // circleOptions.setCenter(new LatLng(this.currentLocation?.latitude ?? 34.12,
        //   this.currentLocation?.longitude ?? 124.11)); //设置圆心经纬度坐标
        // circleOptions.setFillColor(0xffff0000); //设置圆的填充颜色
        // circleOptions.setStrokeColor(0xff00ff00); //设置圆的边框颜色
        // this.fenceMapInstance = this.aMapInstance?.addCircle(circleOptions);
        this.fenceId = id;
        this.fenceIdText = 'fenceId=' + id;
      }).catch((err: BusinessError) => {
        console.error("addGnssGeofence failed, promise errCode:" + (err as BusinessError).code +
          ",errMessage:" + (err as BusinessError).message);
      });
    } catch (error) {
      console.error("addGnssGeofence failed, err:" + JSON.stringify(error));
    }
  }

  /**
   * 调用地理编码服务，将地理描述转换为具体坐标
   */
  private getAddressesFromLocationName() {
    // 判断地理编码与逆地理编码服务状态
    if (!geoLocationManager.isGeocoderAvailable()) {
      return
    }
    console.log(`getAddressesFromLocationName inputCityInfo:${this.inputCityInfo}`);
    let geocodeRequest: geoLocationManager.GeoCodeRequest =
      {
        "locale": 'zh',
        "country": 'CN',
        "description": this.inputCityInfo,
        "maxItems": 1
      };
    try {
      geoLocationManager.getAddressesFromLocationName(geocodeRequest, (err, data) => {
        if (err) {
          console.error('getAddressesFromLocationName: err=' + JSON.stringify(err));
        }
        if (data) {
          console.info('getAddressesFromLocationName: data=' + JSON.stringify(data));
          this.geocodeText = JSON.stringify(data);

        }
      });
    } catch (err) {
      console.error("errCode:" + err.code + ", message:" + err.message);
    }
  }

  /**
   * 获取连接的Wi-Fi AP（Access Point）的Bssid（Basic Service Set Identifier）信息
   */
  private getCurrentWifiBssidForLocating() {
    try {
      let bssid: string = geoLocationManager.getCurrentWifiBssidForLocating();
      this.WIFIInfo = bssid;
      console.info("get wifi bssid:" + bssid);
    } catch (error) {
      console.error("getCurrentWifiBssidForLocating: errCode" + error.code + ", errMessage" + error.message);
    }
  }

  /**
   * 订阅位置服务状态变化
   */
  private onLocationEnabledChange() {
    let locationEnabledChange = (state: boolean): void => {
      console.info('locationEnabledChange: on' + JSON.stringify(state));
      this.locationEnableFlag = state;
    }
    try {
      geoLocationManager.on('locationEnabledChange', locationEnabledChange);
    } catch (err) {
      console.error("errCode:" + err.code + ", message:" + err.message);
    }
  }

  /**
   * 订阅位置服务状态变化
   */
  private offLocationEnabledChange() {
    let locationEnabledChange = (state: boolean): void => {
      console.info('locationEnabledChange: off:' + JSON.stringify(state));
    }
    try {
      geoLocationManager.off('locationEnabledChange', locationEnabledChange);
    } catch (err) {
      console.error("errCode:" + err.code + ", message:" + err.message);
    }
  }

  /**
   * 订阅GNSS卫星状态信息上报事件
   */
  private onSatelliteStatusChange() {
    let gnssStatusCb = (satelliteStatusInfo: geoLocationManager.SatelliteStatusInfo): void => {
      console.info('satelliteStatusChange: ' + JSON.stringify(satelliteStatusInfo));
      // 表示卫星个数
      this.satelliteStatusInfoText = JSON.stringify(satelliteStatusInfo);
      this.satelliteStatusFlag = satelliteStatusInfo.satellitesNumber > 0;
      let totalNumber: number = satelliteStatusInfo.satellitesNumber;
      let satelliteIds: Array<number> = satelliteStatusInfo.satelliteIds;
      let carrierToNoiseDensitys: Array<number> = satelliteStatusInfo.carrierToNoiseDensitys;
      let altitudes: Array<number> = satelliteStatusInfo.altitudes;
      let azimuths: Array<number> = satelliteStatusInfo.azimuths;
      let carrierFrequencies: Array<number> = satelliteStatusInfo.carrierFrequencies;
      let satelliteConstellations: Array<geoLocationManager.SatelliteConstellationCategory> | undefined =
        satelliteStatusInfo.satelliteConstellation;
      let satelliteAdditionalInfos: Array<number> | undefined = satelliteStatusInfo.satelliteAdditionalInfo;
      for (let i = 0; i < totalNumber; i++) {
        // 卫星的ID
        let satelliteId: Number = satelliteIds[i];
        // 表示卫星的ID为 ${satelliteId} 的卫星的载波噪声功率谱密度比
        let carrierToNoiseDensity: Number = carrierToNoiseDensitys[i];
        // 表示卫星的ID为 ${satelliteId} 的卫星的高度角信息
        let altitude: Number = altitudes[i];
        // 表示卫星的ID为 ${satelliteId} 的卫星的方位角
        let azimuth: Number = azimuths[i];
        // 表示卫星的ID为 ${satelliteId} 的卫星的载波频率
        let carrierFrequencie: Number = carrierFrequencies[i];
        if (satelliteConstellations != undefined) {
          // 表示卫星的ID为 ${satelliteId} 的卫星的星座类型
          let satelliteConstellation: geoLocationManager.SatelliteConstellationCategory = satelliteConstellations[i];
        }
        if (satelliteAdditionalInfos != undefined) {
          // 表示卫星的ID为 ${satelliteId} 的卫星的附加信息；表示是否在最新的位置解算中使用了本卫星，是否具有星历数据，是否具有年历数据，是否具有载波频率信息等。
          let satelliteAdditionalInfo: Number = satelliteAdditionalInfos[i];
        }
      }
    }

    try {
      geoLocationManager.on('satelliteStatusChange', gnssStatusCb);
    } catch (err) {
      console.error("errCode:" + err.code + ", message:" + err.message);
    }
  }

  /**
   * 取消订阅GNSS卫星状态信息上报事件
   */
  private offSatelliteStatusChange() {
    try {
      geoLocationManager.off('satelliteStatusChange');
      this.satelliteStatusInfoText = "";
    } catch (err) {
      console.error("errCode:" + err.code + ", message:" + err.message);
    }
  }

  /**
   * 开启位置变化订阅，并发起定位请求
   */
  private onLocationChange() {
    // 1. 检查权限与定位开关
    if (!this.requestPermissions() || !geoLocationManager.isLocationEnabled()) {
      console.error('权限或定位开关未开启');
      return;
    }
    // 表示优先级信息。当scenario取值为UNSET时，priority参数生效，否则priority参数不生效；当scenario和priority均取值为UNSET时，无法发起定位请求。
    const request: geoLocationManager.LocationRequest = {
      'priority': geoLocationManager.LocationRequestPriority.FIRST_FIX, //表示快速获取位置优先，如果应用希望快速拿到一个位置，可以将优先级设置为该字段。
      'scenario': geoLocationManager.LocationRequestScenario.UNSET,
      'timeInterval': 2, //表示上报位置信息的时间间隔，单位为秒
      'distanceInterval': 0, //	表示上报位置信息的距离间隔。单位是米，默认值为0
      'maxAccuracy': 0 // 应用向系统请求位置信息时要求的精度值，单位为米
    };
    let locationChange = (location: geoLocationManager.Location): void => {
      console.log('locationChange: data: ' + JSON.stringify(location));
      this.onCurrentLocationInfo = JSON.stringify(location)
    };
    geoLocationManager.on('locationChange', request, locationChange)
    this.offBluetoothScanResultChange()
  }

  /**
   *查询当前的国家码
   */
  private getCountryCode() {
    try {
      geoLocationManager.getCountryCode((err, result) => {
        if (err) {
          console.error('getCountryCode: err=' + JSON.stringify(err));
        }
        if (result) {
          console.info('getCountryCode: result=' + JSON.stringify(result));
          this.countryCode = JSON.stringify(result)
        }
      });
    } catch (err) {
      console.error("errCode:" + err.code + ", message:" + err.message);
    }
  }

  /**
   * 关闭位置变化订阅，并删除对应的定位请求。
   */
  private offLocationChange() {
    geoLocationManager.off('locationChange')
    this.onCurrentLocationInfo = ''
  }

  /**
   * 获取地理围栏功能支持的坐标系列表
   */
  private getGeofenceSupportedCoordTypes() {
    try {
      let supportedCoordTypes: Array<geoLocationManager.CoordinateSystemType> =
        geoLocationManager.getGeofenceSupportedCoordTypes();
      console.info("getGeofenceSupportedCoordTypes return:" + JSON.stringify(supportedCoordTypes));
      this.GeofenceSupportedCoordTypes = JSON.stringify(supportedCoordTypes)
    } catch (error) {
      console.error("getGeofenceSupportedCoordTypes: error=" + JSON.stringify(error));
    }
  }

  /**
   * 订阅持续定位过程中的错误码
   */
  private onLocationError() {
    let locationErrorChange = (errcode: geoLocationManager.LocationError): void => {
      console.info('locationErrorChange: data: ' + JSON.stringify(errcode));
      this.locationErrorInfo = JSON.stringify(errcode);
    };
    try {
      geoLocationManager.on('locationError', locationErrorChange);
    } catch (err) {
      console.error("errCode:" + err.code + ", message:" + err.message);
    }
  }

  /**
   * 取消订阅持续定位过程中的错误码
   */
  private offLocationError() {
    let locationErrorChange = (errcode: geoLocationManager.LocationError): void => {
      console.info('locationErrorChange: data: ' + JSON.stringify(errcode));
    };
    try {
      geoLocationManager.off('locationError', locationErrorChange);
    } catch (err) {
      console.error("errCode:" + err.code + ", message:" + err.message);
    }
  }

  /**
   * 订阅国家码信息变化事件
   */
  private onCountryCodeChange() {
    let callback = (code: geoLocationManager.CountryCode): void => {
      console.info('countryCodeChange: ' + JSON.stringify(code));
      this.countryCode = JSON.stringify(code);
    }

    try {
      geoLocationManager.on('countryCodeChange', callback);
    } catch (err) {
      console.error("errCode:" + err.code + ", message:" + err.message);
    }
  }

  /**
   * 取消订阅国家码变化事件
   */
  private offCountryCodeChange() {
    let callback = (code: geoLocationManager.CountryCode): void => {
      console.info('countryCodeChange: ' + JSON.stringify(code));
    }

    try {
      geoLocationManager.off('countryCodeChange', callback);
    } catch (err) {
      console.error("errCode:" + err.code + ", message:" + err.message);
    }
  }

  /**
   * 订阅GNSS NMEA信息上报事件
   */
  private onNmeaMessage() {
    let nmeaCb = (str: string): void => {
      console.info('nmeaMessage: ' + JSON.stringify(str));
      this.nmeaMessageText = str;
    }

    try {
      geoLocationManager.on('nmeaMessage', nmeaCb);
    } catch (err) {
      console.error("errCode:" + err.code + ", message:" + err.message);
    }
  }

  /**
   * 取消订阅GNSS NMEA信息上报事件
   */
  private offNmeaMessage() {
    let nmeaCb = (str: string): void => {
      console.info('nmeaMessage: ' + JSON.stringify(str));
    }

    try {
      geoLocationManager.off('nmeaMessage', nmeaCb);
    } catch (err) {
      console.error("errCode:" + err.code + ", message:" + err.message);
    }
  }

  /**
   * 订阅蓝牙扫描信息上报事件
   */
  private onBluetoothScanResultChange() {
    let callback = (result: geoLocationManager.BluetoothScanResult): void => {
      console.info('bluetoothScanResultChange: ' + JSON.stringify(result));
      this.bluetoothScanResultText = JSON.stringify(result);
    };
    try {
      geoLocationManager.on('bluetoothScanResultChange', callback);
    } catch (err) {
      console.error("errCode:" + err.code + ", message:" + err.message);
    }
  }

  /**
   * 取消订阅蓝牙扫描信息上报事件
   */
  private offBluetoothScanResultChange() {
    try {
      geoLocationManager.off('bluetoothScanResultChange');
    } catch (err) {
      console.error("errCode:" + err.code + ", message:" + err.message);
    }
  }

  private getLastLocation() {
    try {
      let location = geoLocationManager.getLastLocation();
      if (location) {
        this.lastLocationInfo = JSON.stringify(location);
      }
    } catch (err) {
      console.error("errCode:" + err.code + ", message:" + err.message);
    }
  }

  private switchSatelliteStatusChange()
  {
    if (this.satelliteStatusFlag) {
      this.onSatelliteStatusChange()
      console.log("卫星功能已开启");
    } else {
      this.offSatelliteStatusChange()
      console.log("卫星功能已关闭");
    }

  }



  private switchBluetoothScanResultChange()
  {
    if (this.bluetoothScanFlag) {
      this.onBluetoothScanResultChange()
      console.log("蓝牙功能已开启");
    } else {
      this.offBluetoothScanResultChange()
      console.log("蓝牙功能已关闭");
    }

  }

  aboutToAppear() {
    this.Id = 0
    this.removeGnssGeofenceByid()
    this.Id = 1
    this.removeGnssGeofenceByid()
    this.Id = 2
    this.removeGnssGeofenceByid()
    this.Id = 3
    this.removeGnssGeofenceByid()
    this.Id = 4
    this.removeGnssGeofenceByid()
    this.Id = 5
    this.removeGnssGeofenceByid()
    this.Id = 6
    this.removeGnssGeofenceByid()
    this.Id = 7
    this.removeGnssGeofenceByid()
    this.Id = 8
    this.removeGnssGeofenceByid()
    this.Id = 9
    this.removeGnssGeofenceByid()
    this.Id = 10
    this.removeGnssGeofenceByid()
    this.Id = 11
    this.removeGnssGeofenceByid()
    this.onLocationEnabledChange()
    this.onLocationError()
    this.onCountryCodeChange()
    this.onNmeaMessage()
    this.onBluetoothScanResultChange()
    this.getLastLocation()
    this.locationEnableFlag = geoLocationManager.isLocationEnabled()

  }

  aboutToDisappear(): void {
    this.offLocationChange()
    this.offLocationEnabledChange()
    this.offLocationError()
    this.offCountryCodeChange()
    this.offNmeaMessage()
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {

      }.zIndex(1)

      Column() {
        if (this.countryCode) {
          Text("国家码：" + this.countryCode).fontColor(Color.Red).fontSize(20)
        }
        if (this.WIFIInfo) {
          Text("WIFI:" + this.WIFIInfo).fontColor(Color.Red).fontSize(20)
        }

        if (this.GeofenceSupportedCoordTypes) {
          Text("地理围栏功能支持的坐标系列表:" + this.GeofenceSupportedCoordTypes).fontColor(Color.Red).fontSize(20)
        }
        if (this.fenceIdText) {
          Text('添加围栏' + this.fenceIdText).fontColor(Color.Red).fontSize(20)
        }
        if (this.removeGnssGeofenceText) {
          Text('移除围栏' + this.removeGnssGeofenceText).fontColor(Color.Red).fontSize(20)
        }
        if (this.satelliteStatusInfoText) {
          Text('卫星状态:' + this.satelliteStatusInfoText).fontSize(12).margin({ top: 6 })
        }
        if (this.locationErrorInfo) {
          Text('定位错误:' + this.locationErrorInfo).fontSize(12).margin({ top: 6 })
        }
        if (this.lastLocationInfo) {
          Text('上次位置:' + this.lastLocationInfo).fontSize(12).margin({ top: 6 })
        }
        if (this.geofenceTransitionInfo) {
          Text('围栏事件:' + this.geofenceTransitionInfo).fontSize(12).margin({ top: 6 })
        }
        if (this.nmeaMessageText) {
          Text('NMEA:' + this.nmeaMessageText).fontSize(12).margin({ top: 6 })
        }
        if (this.bluetoothScanFlag) {
          Text('蓝牙扫描:' + this.bluetoothScanResultText).fontSize(12).margin({ top: 6 })
        }
        if(this.countryCode) {
          Text('countrycodeChange' + this.countryCode).fontSize(12).margin({ top: 6 })
        }
        if (this.onCurrentLocationInfo) {
            Text("onLocationChange:" + this.onCurrentLocationInfo)
              .margin({ top: 20 })
              .borderRadius(20)
              .borderWidth(1)
              .padding(10)
          }
          if (this.reverseGeocodeText) {
            Text("getAddressesFromLocation:" + this.reverseGeocodeText)
              .margin({ top: 12 })
              .borderRadius(20)
              .borderWidth(1)
              .padding(10)
          }
          if (this.geocodeText) {
            Text("getAddressesFromLocationName:" + this.geocodeText)
              .margin({ top: 12 })
              .borderRadius(20)
              .borderWidth(1)
              .padding(10)
          }
      }.margin({
        top: 20,
        left: 10
      })

      Panel(this.isShow) {
        Column() {
          Search({ value: $$this.inputCityInfo, placeholder: '搜地点' })
            .searchButton('搜索')
            .enableKeyboardOnFocus(false)
            .onSubmit(() => {
              this.getAddressesFromLocationName()
            })

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Row() {
              Image(this.locationEnableFlag ? $r("app.media.location") : $r("app.media.location_gray"))
                .width(22)
                .height(22)
                .aspectRatio(1)
                .padding({ left: 4 })
              Text(this.cityInfo)
                .fontSize(14)
                .fontColor(this.locationEnableFlag ? '#E92F4F' : Color.Gray)
                .margin({ left: 10, right: 10 })
            }
            .alignSelf(ItemAlign.Start)
            .justifyContent(FlexAlign.Center)
            .height(32)
            .borderRadius(20)
            .borderWidth(1)
            .borderColor(this.locationEnableFlag ? '#E92F4F' : Color.Gray)
            .onClick(() => {
              this.getCurrentLocation()
            })
            .margin({ top: 8 })

            Column() {
              Row() {
                Image(this.bluetoothScanFlag ? $r("app.media.bluetoothon") : $r("app.media.bluetoothoff"))
                  .width(30)
                  .height(30)
                  .aspectRatio(1)
                  .onClick(() => {
                    this.bluetoothScanFlag = !this.bluetoothScanFlag;
                    this.switchBluetoothScanResultChange()
                  })

                Image(this.satelliteStatusFlag ? $r("app.media.gnss") : $r("app.media.gnss_gray"))
                  .width(30)
                  .height(30)
                  .aspectRatio(1)
                  .onClick(() => {
                    this.satelliteStatusFlag = !this.satelliteStatusFlag;
                    this.switchSatelliteStatusChange()
                  })
                  .margin({ left: 14 })
                Image($r("app.media.begin"))
                  .width(26)
                  .height(26)
                  .aspectRatio(1)
                  .onClick(() => {
                    this.onLocationChange()
                  })
                  .margin({ left: 14 })

                Image($r("app.media.stop"))
                  .width(30)
                  .height(30)
                  .aspectRatio(1)
                  .onClick(() => {
                    this.offLocationChange()
                  })
                  .margin({ left: 14 })
              }
            }
          }


          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Column() {
              Image($r("app.media.GIS"))
                .width(26)
                .height(26)
                .aspectRatio(1)

              Text('地理信息').fontSize(10).margin({ top: 6 })
            }.onClick(() => {
              // this.setOnMapLongClickListener()
            })

            Column() {
              Image($r("app.media.geofence"))
                .width(26)
                .height(26)
                .aspectRatio(1)

              Text('地理围栏').fontSize(10).margin({ top: 6 })
            }.onClick(() => {
              this.addGnssGeofence()
            })

            Column() {
              Image($r("app.media.nogeofence"))
                .width(26)
                .height(26)
                .aspectRatio(1)

              Text('移除围栏').fontSize(10).margin({ top: 6 })
            }.onClick(() => {
              this.removeGnssGeofence()
            })

            Column() {
              Image($r("app.media.countrycode"))
                .width(26)
                .height(26)
                .aspectRatio(1)

              Text('国家码').fontSize(10).margin({ top: 6 })
            }.onClick(() => {
              this.getCountryCode()
            })

            Column() {
              Image($r("app.media.coordtypes"))
                .width(26)
                .height(26)
                .aspectRatio(1)

              Text('获取坐标系').fontSize(10).margin({ top: 6 })
            }.onClick(() => {
              this.getGeofenceSupportedCoordTypes()
            })

            Column() {
              Image($r("app.media.wifi"))
                .width(26)
                .height(26)
                .aspectRatio(1)

              Text('WIFI信息').fontSize(10).margin({ top: 6 })
            }.onClick(() => {
              this.getCurrentWifiBssidForLocating()
            })

            Column() {
              Image($r("app.media.reset"))
                .width(28)
                .height(28)
                .aspectRatio(1)

              Text('reset').fontSize(10).margin({ top: 6 })
            }.onClick(() => {
              this.countryCode = ''
              this.WIFIInfo = ''
              this.GeofenceSupportedCoordTypes = ''
              this.fenceIdText = ''
              this.removeGnssGeofenceText = ''

            })
          }.margin({ top: 18 })


          if (this.onCurrentLocationInfo) {
            Text("onLocationChange:" + this.onCurrentLocationInfo)
              .margin({ top: 20 })
              .borderRadius(20)
              .borderWidth(1)
              .padding(10)
          }
        }.margin({ left: 16, right: 16 })

      }.zIndex(2).hitTestBehavior(HitTestMode.Transparent)
    }
  }
}