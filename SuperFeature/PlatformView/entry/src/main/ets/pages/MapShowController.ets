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

import {
  AMap,
  CameraPosition,
  CustomMapStyleOptions,
  LatLng,
  MapType,
  MapView,
  MapViewComponent,
  MapViewCreateCallback,
  MapViewManager,
  OnCameraChangeListener,
  Poi,
  VirtualEarthProjection,
  MapsInitializer
} from '@amap/amap_lbs_map3d'
import hilog from '@ohos.hilog';
import { Constants } from './Constants';
import { Context } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { picker } from '@kit.CoreFileKit';
import { JSON } from '@kit.ArkTS';
import { AMapPrivacyInfoStatus, AMapPrivacyShowStatus } from '@amap/amap_lbs_common';
import { AMapPrivacyAgreeStatus } from '@amap/amap_lbs_common';
const key = "此处替换官网申请的Key";

@Component
export struct MapShowController {
  private mapView?: MapView;
  private aMap?: AMap;
  private aId: number = 0;
  @StorageLink("STORAGE_KEY_NAVI_PAGE_HIDE") @Watch('onHideStateChanged') isPageHide: boolean = false
  private mapStyleOptions: CustomMapStyleOptions = new CustomMapStyleOptions();
  @State selectedStyleDataPath: string = ""
  @State selectedStyleExtraPath: string = ""
  @State selectedStyleTexturePath: string = ""

  onHideStateChanged() {
    if (this.isPageHide === true) {
      this.handleMapPause();
    } else {
      this.handleMapResume();
    }
  }

  handleMapResume(): void {
    if (this.mapView) {
      this.mapView?.onResume();
    }
  }

  handleMapPause(): void {
    this.mapView?.onPause();
  }

  //显示地图
  @Builder
  buildMapShow() {
    Stack() {
      MapViewComponent({ mapViewName: Constants.MAP_SHOW_FUNC }).zIndex(0)
      Column() {
        Row() {
          Radio({ value: "标准模式", group: 'mapType' })
            .checked(true)
            .radioStyle({
              checkedBackgroundColor: Color.Pink
            })
            .onChange((checked: boolean) => {
              let amap = this.aMap;
              if (amap) {
                if (checked) {
                  amap.setMapType(MapType.MAP_TYPE_NORMAL);
                }
              }
            })
          Text("标准模式")
        }

        Divider().strokeWidth(2).color('#ff030303')

        Row() {
          Radio({ value: "卫星模式", group: 'mapType' })
            .checked(false)
            .radioStyle({
              checkedBackgroundColor: Color.Pink
            })
            .onChange((checked: boolean) => {
              let amap = this.aMap;
              if (amap) {
                if (checked) {
                  amap.setMapType(MapType.MAP_TYPE_SATELLITE);
                } else {
                  amap.setMapType(MapType.MAP_TYPE_NORMAL);
                }
              }
            })
          Text("卫星模式")
        }

        Divider().strokeWidth(2).color('#ff030303')

        Row() {
          Radio({ value: "夜间模式", group: 'mapType' })
            .checked(false)
            .radioStyle({
              checkedBackgroundColor: Color.Pink
            })
            .onChange((checked: boolean) => {
              let amap = this.aMap;
              if (amap) {
                if (checked) {
                  amap.setMapType(MapType.MAP_TYPE_NIGHT);
                } else {
                  amap.setMapType(MapType.MAP_TYPE_NORMAL);
                }
              }
            })
          Text("夜间模式")
        }

        Divider().strokeWidth(2).color('#ff030303')

        Row() {
          Radio({ value: "导航模式", group: 'mapType' })
            .checked(false)
            .radioStyle({
              checkedBackgroundColor: Color.Pink
            })
            .onChange((checked: boolean) => {
              let amap = this.aMap;
              if (amap) {
                if (checked) {
                  amap.setMapType(MapType.MAP_TYPE_NAVI);
                } else {
                  amap.setMapType(MapType.MAP_TYPE_NORMAL);
                }
              }
            })
          Text("导航模式")
        }

        Divider().strokeWidth(2).color('#ff030303')

        Row() {
          Radio({ value: "导航夜间模式", group: 'mapType' })
            .checked(false)
            .radioStyle({
              checkedBackgroundColor: Color.Pink
            })
            .onChange((checked: boolean) => {
              let amap = this.aMap;
              if (amap) {
                if (checked) {
                  amap.setMapType(MapType.MAP_TYPE_NAVI_NIGHT);
                } else {
                  amap.setMapType(MapType.MAP_TYPE_NORMAL);
                }
              }
            })
          Text("导航夜间模式")
        }

        Divider().strokeWidth(2).color('#ff030303')

        Row() {
          Radio({ value: "公交模式", group: 'mapType' })
            .checked(false)
            .radioStyle({
              checkedBackgroundColor: Color.Pink
            })
            .onChange((checked: boolean) => {
              let amap = this.aMap;
              if (amap) {
                if (checked) {
                  amap.setMapType(MapType.MAP_TYPE_BUS);
                } else {
                  amap.setMapType(MapType.MAP_TYPE_NORMAL);
                }
              }
            })
          Text("公交模式")
        }

      }
      .position({ x: 10, y: 10 })
      .backgroundColor("#ccbebebe")
      .align(Alignment.TopStart)
      .alignItems(HorizontalAlign.Start)
      .width('40%')

      Column() {
        Row() {
          Checkbox()
            .onChange((checked: boolean) => {
              if (this.mapStyleOptions) {
                //设置自定义样式
                this.mapStyleOptions.setEnable(checked);
                //todo 在线样式  此处替换官网申请的Key
                //使用选择公共目录样式  用到
                this.aMap?.setCustomMapStyle(this.mapStyleOptions, (errorCode: number, errorMsg: string) => {
                  //鉴权 失败回调
                  console.error("鉴权失败回调")
                })
              }
            })
          Text("开启个性化地图")
        }

        Button("选择公共目录样式文件")
          .fontSize(14)
          .onClick(async () => {
            this.example10(getContext())
          })
      }.position({ top: 10, right: 10 })
      .backgroundColor("#ccbebebe")

    }.width('100%')
    .height('100%')
    .backgroundColor(Color.Transparent)
  }

  /**
   * 选择公共目录样式文件
   * 使用选择可以 的到文件的临时 访问权限
   */
  example10(context: Context) { // 需确保 context 由 UIAbilityContext 转换而来
    try {
      let documentPicker = new picker.DocumentViewPicker(context);
      documentPicker.select((err: BusinessError, documentSelectResult: Array<string>) => {
        if (err) {
          console.error('DocumentViewPicker.select failed with err: ' + JSON.stringify(err));
          return;
        }
        console.info('DocumentViewPicker.select successfully, documentSelectResult uri: ' +
        JSON.stringify(documentSelectResult));
        documentSelectResult?.forEach(element => {
          let tempArray = element.split("/")
          if (tempArray[tempArray.length-1] == "style.data") {
            this.selectedStyleDataPath = element
          } else if (tempArray[tempArray.length-1] == "style_extra.data") {
            this.selectedStyleExtraPath = element
          } else if (tempArray[tempArray.length-1] == "textures.zip") {
            this.selectedStyleTexturePath = element
          }
        })
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error('DocumentViewPicker failed with err: ' + JSON.stringify(err));
    }
  }

  private mapViewCreateCallback: MapViewCreateCallback = (mapview?: MapView, mapViewName?: string) => {
    if (!mapview || this.mapView) {
      return;
    }

    if (mapViewName != Constants.MAP_SHOW_FUNC) {
      return;
    }

    this.mapView = mapview;

    this.mapView.onCreate();
    this.mapView.getMapAsync((map) => {
      this.aMap = map;

      hilog.info(0xff, Constants.MAP_SHOW_FUNC, 'get map ' + this.aMap?.getCameraPosition()?.zoom);

      this.aMap?.setOnMapClickListener((point: LatLng) => {
        hilog.info(0xff, Constants.MAP_SHOW_FUNC, `map click ${point.longitude} ${point.latitude}`);
      });

      this.aMap?.setOnCameraChangeListener(new OnCameraChangeListener(
        (position: CameraPosition) => {
          hilog.info(0xff, Constants.MAP_SHOW_FUNC,
            `map change ${position.target.longitude} ${position.target.latitude}`);

          let viewMatrix = map.getViewMatrix()
          let projectionMatrix = map.getProjectionMatrix()
          hilog.info(0xff, Constants.MAP_SHOW_FUNC, `map viewMatrix ${viewMatrix}`);
          hilog.info(0xff, Constants.MAP_SHOW_FUNC, `map projectionMatrix ${projectionMatrix}`);

          let pos = VirtualEarthProjection.latLongToPixels(position.target.latitude, position.target.longitude, 20)
          hilog.info(0xff, Constants.MAP_SHOW_FUNC,
            `map latLongToPixels ${pos}`);
        },
        (position: CameraPosition) => {
          hilog.info(0xff, Constants.MAP_SHOW_FUNC,
            `map finish ${position.target.longitude} ${position.target.latitude}`);
        }));

      this.aMap?.setOnMapTouchListener((event: TouchEvent) => {
        hilog.info(0xff, Constants.MAP_SHOW_FUNC, `map touch ${event.touches[0].x} ${event.touches[0].y}`);
      });

      this.aMap?.setAMapGestureListener((event: GestureEvent) => {
        hilog.info(0xff, Constants.MAP_SHOW_FUNC, `map gesture ${event.offsetX} ${event.offsetY}`);
      });

      this.aMap?.setOnMapLongClickListener((point: LatLng) => {
        hilog.info(0xff, Constants.MAP_SHOW_FUNC, `map long click ${point.longitude} ${point.latitude}`);
      });

      this.aMap?.addOnPOIClickListener((poi: Poi) => {
        hilog.info(0xff, Constants.MAP_SHOW_FUNC,
          `map poi click ${poi.getName()}  ${poi.getPoiId()}  ${poi.getCoordinate()!
            .longitude} ${poi.getCoordinate()!.latitude}`);
      });

      let approvalNumber = this.aMap?.getMapContentApprovalNumber();
      let satelliteImageApprovalNumber = this.aMap?.getSatelliteImageApprovalNumber();
      hilog.info(0xff, Constants.MAP_SHOW_FUNC,
        `getMapContentApprovalNumber ${approvalNumber} satelliteImageApprovalNumber ${satelliteImageApprovalNumber}`);
      this.aMap?.getUiSettings()?.setZoomControlsEnabled(true)
    })

  }

  aboutToAppear(): void {
    MapsInitializer.updatePrivacyShow(AMapPrivacyShowStatus.DidShow, AMapPrivacyInfoStatus.DidContain, getContext())
    MapsInitializer.updatePrivacyAgree(AMapPrivacyAgreeStatus.DidAgree, getContext())
    MapsInitializer.setApiKey(key);
    MapViewManager.getInstance().registerMapViewCreatedCallback(this.mapViewCreateCallback);
    this.setMapCustomStyleFile();
    this.setMapCustomStyleExtraFile();
    this.setMapCustomStyleTexturesFile();
    hilog.info(0xff, Constants.MAP_SHOW_FUNC, "aboutToAppear");
  }

  aboutToDisappear(): void {
    if (this.mapViewCreateCallback) {
      MapViewManager.getInstance().unregisterMapViewCreatedCallback(this.mapViewCreateCallback);
    }

    if (this.mapView) {
      this.mapView.onDestroy();
      this.mapView = undefined;
      this.aMap = undefined;
      hilog.info(0xff, Constants.MAP_SHOW_FUNC, "aboutToDisappear");
    }
  }

  build() {
    NavDestination() {
      this.buildMapShow();
    }
    .title(Constants.MAP_SHOW_FUNC)
    .onBackPressed(() => {
      return true;
    })

  }

  setMapCustomStyleFile() {
    let styleName: string = "style.data";
    try {
      let style: Uint8Array = getContext(this).resourceManager.getRawFileContentSync(styleName);
      this.mapStyleOptions?.setStyleData(style)
    } catch (error) {
      console.error(`getRawFileContentSync failed, error : ${error}`);
    }
  }

  setMapCustomStyleExtraFile() {
    let styleName: string = "style_extra.data";
    try {
      let style: Uint8Array = getContext(this).resourceManager.getRawFileContentSync(styleName);
      this.mapStyleOptions?.setStyleExtraData(style)
    } catch (error) {
      console.error(`getRawFileContentSync failed, error : ${error}`);
    }
  }

  setMapCustomStyleTexturesFile() {
    let styleName: string = "textures.zip";
    try {
      let style: Uint8Array = getContext(this).resourceManager.getRawFileContentSync(styleName);
      this.mapStyleOptions?.setStyleTextureData(style)
    } catch (error) {
      console.error(`getRawFileContentSync failed, error : ${error}`);
    }
  }
}

@Builder
function builder() {
  MapShowController()
}

export const MapGaodeComponentBuilder = wrapBuilder(builder);

