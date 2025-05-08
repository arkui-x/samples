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

import { AddressType, CommonAddressList, Location, Province } from "../model/AddressModel";
import Constants from "../constant/Constants";
import { JsonUtils } from "../utils/JsonUtils";
import { emitter } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';

/**
 * 自定义地址选择组件CustomAddressPicker
 *
 * 功能描述：
 * 1.提供省市区选择功能
 * 2.支持传入有效的省市区名后，拉起地址选择弹窗时，显示对应的省市区
 *
 * 实现思路
 * 1.使用getRawFileContentSync从rawfile目录下读取省市区json文件数据，使用util.TextDecoder进行解码。
 * 2.使用bindSheet绑定地址选择半模态弹窗页面。
 * 3.使用changeIndex控制省市区列表TabContent切换。
 * 4.使用组件区域变化回调onAreaChange获取选择的省市区Text组件宽度，存入textInfos数组，用于后续计算选择省市区名后下方下滑线动画水平偏移量leftMargin。
 * 5.在选择完区名后，使用JSON.parse(JSON.stringify(xxx))深拷贝选择的省市区数据，用于后续操作中需要加载上一次选择的完整省市区数据。
 *
 * 接口：
 * CustomAddressPicker({ address: AddressInfo })
 *
 * 参数：
 * @param { AddressInfo } address - 地址信息类。必选项。
 *
 * 基本用法：
 * // 不传入地址信息
 * @State noAddress: AddressInfo = new AddressInfo();
 * CustomAddressPicker({ address: this.noAddress })
 * // 传入有效的地址信息。拉起地址选择弹窗时就会根据传入的省市区名进行显示。
 * @State hasAddress: AddressInfo = new AddressInfo('浙江省', '杭州市', '余杭区');
 * CustomAddressPicker({ address: this.hasAddress })
 */
@Component
export struct CustomAddressPicker {
  // 底部导航条区域高度
  @State bottomHeight: number = 0;
  // 选择的省市区
  @State provinceCityRegion: string = '省、市、区';
  // 地址选择半模态弹窗显隐标志位
  @State @Watch('isShowChange') isShow: boolean = false;
  // 当前选择的省、市、区tab页签的index。0表示省，1表示市，2表示区
  @State currentIndex: number = AddressType.Province;
  // 调用changeIndex切换TabContent动画时长
  @State animationDuration: number = Constants.ANIMATION_DURATION;
  // 省List
  @State provinceList: CommonAddressList[] = [];
  // 市List
  @State cityList: CommonAddressList[] = [];
  // 区List
  @State regionList: CommonAddressList[] = [];
  // 记录上一次市List
  @State lastCityList: CommonAddressList[] = [];
  // 记录上一次区List
  @State lastRegionList: CommonAddressList[] = [];
  // 存放选择的省数据
  @State province: Province = new Province('', '', []);
  // 记录当前省市区选择信息
  @State currentSelectInfo: AddressInfo = new AddressInfo();
  // 记录上一次省市区选择信息
  @State lastSelectInfo: AddressInfo = new AddressInfo();
  // 选择的省市区名下方的下滑线水平偏移量
  @State leftMargin: number = 0;
  // 用于对外提供选择后的省市区信息或者传入地址信息
  @Link address: AddressInfo;
  // 存放上一次选择的省市区名下方的下滑线水平偏移量
  private lastLeftMargin: number = 0;
  // 存放选择的省市区名下方的下滑线位置信息
  private textInfos: [number, number][] = [];
  // 存放从json读取的省市区数据
  private data: Province[] = [];
  private controller: TabsController = new TabsController();

  /**
   * 监听isShow值，自动化测试用例中使用
   */
  isShowChange() {
    emitter.emit({ eventId: 0, priority: 0 }, {
      data: {
        isShow: this.isShow
      }
    })
  }

  aboutToAppear(): void {
    // 获取导航条高度，半模态弹窗内容进行避让
    window.getLastWindow(getContext(), (err, data) => {
      const avoidAreaBottom = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      this.bottomHeight = avoidAreaBottom.bottomRect.height;
    })
    // 从json文件读取省市区数据
    const addressData: Array<Province> = JsonUtils.getAddressJson(Constants.JSON_FILE);
    for (let i = 0; i < addressData.length; i++) {
      // 保存读取到的数据
      this.data.push(addressData[i]);
      this.provinceList.push(new CommonAddressList(addressData[i].code, addressData[i].name));
    }
    // 首次加载AddressPickerComponent如果传入了有效的地址信息，拉起地址选择半模态页面时，会按传入的地址信息进行显示
    this.initAddressSelect();
  }

  /**
   * 首次加载AddressPickerComponent如果传入了有效的地址信息（如'浙江省', '杭州市', '余杭区'）时，在拉起地址选择半模态页面时，会按传入的地址信息进行显示
   */
  initAddressSelect() {
    if (this.address.province !== '' && this.address.city !== '' && this.address.region !== '') {
      this.provinceCityRegion = this.address.province + this.address.city + this.address.region;
      this.currentSelectInfo.province = this.address.province;
      this.currentSelectInfo.city = this.address.city;
      this.currentSelectInfo.region = this.address.region;
      // 查找对应市，区地址数据
      this.data.forEach(province => {
        if (province.name === this.address.province) {
          this.currentSelectInfo.provinceId = province.code;
          this.address.provinceId = province.code;
          // 遍历省份下的children（市级数据）
          province.children.forEach(city => {
            // 只提取市级的code和name
            this.cityList.push(new CommonAddressList(city.code, city.name));
            if (city.name === this.address.city) {
              this.currentSelectInfo.cityId = city.code;
              this.address.cityId = city.code;
              city.children.forEach(region => {
                // 只提取区级的code和name
                this.regionList.push(new CommonAddressList(region.code, region.name));
                if (region.name === this.address.region) {
                  this.currentSelectInfo.regionId = region.code;
                  this.address.regionId = region.code;
                  // 深拷贝保存到相应的变量中
                  this.lastSelectInfo = JSON.parse(JSON.stringify(this.currentSelectInfo))
                  this.lastCityList = JSON.parse(JSON.stringify(this.cityList));
                  this.lastRegionList = JSON.parse(JSON.stringify(this.regionList));
                  this.animationDuration = 0;
                }
              });
            }
          });
        }
      });
    }
  }

  /**
   * 选择的省市区名下方的下滑线动画
   * @param duration 动画时长
   * @param leftMargin 下划线动画偏移量
   */
  startAnimateTo(duration: number, leftMargin: number) {
    animateTo({
      duration: duration, // 动画时长
      curve: Curve.Linear, // 动画曲线
      iterations: 1, // 播放次数
      playMode: PlayMode.Normal // 动画模式
    }, () => {
      this.leftMargin = leftMargin;
    })
  }

  /**
   * 获取省、市、区名需要显示的字体颜色
   * @param addressType 省/市/区类型
   * @param item 省、市、区地址项
   * @returns 需要显示的字体颜色
   */
  getFontColor(addressType: AddressType, item: CommonAddressList): Color | string | Resource {
    // 省/市/区名字体颜色
    let isSelect: boolean = false;
    if (addressType === AddressType.Province) {
      isSelect = this.currentSelectInfo.province !== '' && item.name === this.currentSelectInfo.province;
    } else if (addressType === AddressType.City) {
      isSelect = this.currentSelectInfo.city !== '' && item.name === this.currentSelectInfo.city;
    } else if (addressType === AddressType.Region) {
      isSelect = this.currentSelectInfo.region !== '' && item.name === this.currentSelectInfo.region;
    }
    return isSelect ? $r('app.color.custom_address_picker_select_font_color') : Color.Black;
  }

  /**
   * 用于显示选择的省、市、区名
   * @param params 传入要显示的省、市、区名
   */
  @Builder
  locationItem(params: Location) {
    Text(`${params.name === '' ? '请选择' : params.name}`)
      .height($r('app.string.custom_address_picker_full_size'))
      .fontSize($r('app.float.custom_address_picker_size_sixteen'))
      .fontWeight(this.currentIndex === params.index ? Constants.FONT_WEIGHT_FIVE_HUNDRED :
      Constants.FONT_WEIGHT_FOUR_HUNDRED)
      .fontColor(this.currentIndex === params.index ? $r('app.color.custom_address_picker_font_color_black') :
      $r('app.color.custom_address_picker_font_color_gray'))
      .constraintSize({ maxWidth: 'calc(33%)' })
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines(Constants.SIZE_ONE)
      .margin({ right: Constants.AREA_SPACE })
      .onClick(() => {
        // TODO 知识点：使用changeIndex控制省市区列表TabContent切换
        this.controller.changeIndex(params.index);
      })
      .id(params.index.toString())
      .onAreaChange((oldValue: Area, newValue: Area) => {
        // TODO 知识点：使用组件区域变化回调onAreaChange获取选择的省市区Text组件宽度，存入textInfos数组，用于后续计算选择省市区名后下方下滑线动画水平偏移量leftMargin
        // 组件区域变化时获取当前Text的宽度newValue.width和x轴相对位置newValue.position.x
        this.textInfos[params.index] = [newValue.position.x as number, newValue.width as number];
        if (this.currentIndex === params.index && params.index === AddressType.Province) {
          // 计算选择的省市区名下方的下滑线偏移量
          this.leftMargin = (this.textInfos[this.currentIndex][1] - Constants.DIVIDER_WIDTH) / 2;
        }
      })
  }

  /**
   * 自定义TabBar
   */
  @Builder
  customTabBar() {
    RelativeContainer() {
      Row() {
        // 选择的省名
        this.locationItem({ index: AddressType.Province, name: this.currentSelectInfo.province })
        // 选择的市名
        this.locationItem({ index: AddressType.City, name: this.currentSelectInfo.city })
        // 选择的区名
        this.locationItem({ index: AddressType.Region, name: this.currentSelectInfo.region })
      }
      .width($r('app.string.custom_address_picker_percent_eighty_five'))
      .height($r('app.string.custom_address_picker_percent_eighty'))
      .alignRules({ 'center': { 'anchor': '__container__', 'align': VerticalAlign.Center } })
      .margin({ bottom: $r('app.float.custom_address_picker_size_ten') })
      .padding({
        top: $r('app.float.custom_address_picker_size_fifteen'),
        left: $r('app.float.custom_address_picker_size_twenty')
      })

      Row() {
        // 选择的省市区名下方的下滑线
        Divider()
          .width(Constants.DIVIDER_WIDTH)
          .strokeWidth(Constants.STROKE_WIDTH)
          .color($r('app.color.custom_address_picker_divider_color'))
          .margin({ left: this.leftMargin })
      }
      .width($r('app.string.custom_address_picker_percent_eighty_five'))
      .height($r('app.string.custom_address_picker_percent_twenty'))
      .alignRules({ 'bottom': { 'anchor': '__container__', 'align': VerticalAlign.Bottom } })
      .padding({ left: $r('app.float.custom_address_picker_size_twenty') })

      Row() {
        Image($r('app.media.address_picker_close'))
          .objectFit(ImageFit.Contain)// 图片保持其原始的宽高比进行缩小或放大
          .width($r('app.float.custom_address_picker_size_fourteen'))
          .height($r('app.float.custom_address_picker_size_fourteen'))
          .margin({ left: $r('app.float.custom_address_picker_size_twenty') })
      }
      .onClick(() => {
        // 关闭半模态页面
        this.isShow = false;
      })
      .width($r('app.string.custom_address_picker_percent_fifteen'))
      .height($r('app.string.custom_address_picker_full_size'))
      .alignRules({ 'right': { 'anchor': '__container__', 'align': HorizontalAlign.End } })
    }
    .width($r('app.string.custom_address_picker_full_size'))
    .height($r('app.float.custom_address_picker_size_forty_eight'))
  }

  /**
   * 自定义省/市/区名项
   * @param addressType 省/市/区类型
   * @param item 省、市、区地址项
   */
  @Builder
  areaNameItem(addressType: AddressType, item: CommonAddressList) {
    Column() {
      Text(item.name)
        .width($r('app.string.custom_address_picker_percent_ninety'))
        .height($r('app.float.custom_address_picker_size_forty_eight'))
        .fontSize($r('app.float.custom_address_picker_size_sixteen'))
        .fontColor(this.getFontColor(addressType, item))
      Divider()
        .strokeWidth(Constants.SIZE_ONE)
        .color($r('app.color.custom_address_picker_area_name_divider_color'))
        .width($r('app.string.custom_address_picker_percent_ninety'))
    }
    .width($r('app.string.custom_address_picker_full_size'))
  }

  /**
   * 自定义Tabs
   */
  @Builder
  customTabs() {
    Tabs({ controller: this.controller }) {
      // 省列表
      TabContent() {
        List() {
          ForEach(this.provinceList, (item: CommonAddressList) => {
            ListItem() {
              this.areaNameItem(AddressType.Province, item)
            }.onClick(() => {
              // TODO: 高性能知识点：如果当前点击选择的省与之前选择一样，跳过省、市数据获取，直接调用changeIndex(AddressType.City)切换到市列表，减少冗余查询以提升性能
              if (this.currentSelectInfo.province === item.name) {
                this.controller.changeIndex(AddressType.City);
                return;
              } else {
                // 重置市和区数据
                this.currentSelectInfo.cityId = '';
                this.currentSelectInfo.city = '';
                this.currentSelectInfo.regionId = '';
                this.currentSelectInfo.region = '';
              }
              this.cityList = [];
              this.regionList = [];
              // 点击省，获取该省所有市，存入cityList
              this.data.forEach(province => {
                if (province.name === item.name) {
                  // 深拷贝一份省数据
                  this.province = JSON.parse(JSON.stringify(province));
                  // 遍历该省份下的children（市级数据）
                  province.children.forEach(city => {
                    // 只提取市级的code和name
                    this.cityList.push(new CommonAddressList(city.code, city.name));
                  });
                }
              });
              this.currentSelectInfo.provinceId = item.code;
              this.currentSelectInfo.province = item.name;
              // 跳转市TabContent
              this.controller.changeIndex(AddressType.City);
            })
          }, (item: CommonAddressList) => JSON.stringify(item))
        }
        .width($r('app.string.custom_address_picker_full_size'))
        .height($r('app.string.custom_address_picker_full_size'))
        .scrollBar(BarState.Off)
        .friction($r('app.float.custom_address_picker_friction')) // 设置摩擦系数
        .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
        .listDirection(Axis.Vertical) // 排列方向
      }

      // 市列表
      TabContent() {
        List() {
          ForEach(this.cityList, (item: CommonAddressList) => {
            ListItem() {
              this.areaNameItem(AddressType.City, item)
            }.onClick(() => {
              // 如果点击的市和上一次点击的市一样，则不用刷新，减少冗余操作以提升性能
              if (this.currentSelectInfo.city === item.name) {
                // TODO: 高性能知识点：如果当前点击选择的市与之前选择一样，跳过市、区数据获取，直接调用changeIndex(AddressType.Region)切换到区列表，减少冗余查询以提升性能
                this.controller.changeIndex(AddressType.Region);
                return;
              } else {
                // 重置区数据
                this.currentSelectInfo.regionId = '';
                this.currentSelectInfo.region = '';
              }
              this.regionList = [];
              // 点击市，获取该市所有区，存入regionList
              this.province.children.forEach(city => {
                if (city.name === item.name) {
                  city.children.forEach(region => {
                    // 只提取区级的code和name
                    this.regionList.push(new CommonAddressList(region.code, region.name));
                  });
                }
              });
              this.currentSelectInfo.cityId = item.code;
              this.currentSelectInfo.city = item.name;
              this.controller.changeIndex(AddressType.Region);
            })
          }, (item: CommonAddressList) => JSON.stringify(item))
        }
        .width($r('app.string.custom_address_picker_full_size'))
        .height($r('app.string.custom_address_picker_full_size'))
        .scrollBar(BarState.Off)
        .friction($r('app.float.custom_address_picker_friction'))
        .edgeEffect(EdgeEffect.Spring)
        .listDirection(Axis.Vertical)
      }

      // 区列表
      TabContent() {
        List() {
          ForEach(this.regionList, (item: CommonAddressList) => {
            ListItem() {
              this.areaNameItem(AddressType.Region, item)
            }.onClick(() => {
              // 记录选择的区信息
              this.currentSelectInfo.regionId = item.code;
              this.currentSelectInfo.region = item.name;
              this.provinceCityRegion =
                this.currentSelectInfo.province + this.currentSelectInfo.city + this.currentSelectInfo.region;
              // 选择区后，退出地址选择半模态弹窗页面
              this.isShow = false;
              // 将当前选中省市区信息保存到lastSelectInfo
              this.lastSelectInfo.provinceId = this.currentSelectInfo.provinceId;
              this.lastSelectInfo.province = this.currentSelectInfo.province;
              this.lastSelectInfo.cityId = this.currentSelectInfo.cityId;
              this.lastSelectInfo.city = this.currentSelectInfo.city;
              this.lastSelectInfo.regionId = this.currentSelectInfo.regionId;
              this.lastSelectInfo.region = this.currentSelectInfo.region;
              // TODO 知识点：在选择完区名后，使用JSON.parse(JSON.stringify(xxx))深拷贝选择的省市区数据，用于后续操作中需要加载上一次选择的完整省市区数据
              // 深拷贝保存到相应的变量中
              this.lastCityList = JSON.parse(JSON.stringify(this.cityList));
              this.lastRegionList = JSON.parse(JSON.stringify(this.regionList));
              this.address = JSON.parse(JSON.stringify(this.lastSelectInfo));
            })
          }, (item: CommonAddressList) => JSON.stringify(item))
        }
        .width($r('app.string.custom_address_picker_full_size'))
        .height($r('app.string.custom_address_picker_full_size'))
        .scrollBar(BarState.Off)
        .friction($r('app.float.custom_address_picker_friction'))
        .edgeEffect(EdgeEffect.Spring)
        .listDirection(Axis.Vertical)
      }
    }
    .animationDuration(this.animationDuration)
    .onAppear(() => {
      if (this.lastSelectInfo.region !== '') {
        // 上一次选择如果选择到区，再次打开半模态弹窗页面时会显示到区的TabContent
        this.currentIndex = AddressType.Region;
        if (this.cityList.length === 0 && this.regionList.length === 0) {
          // 在已经选择过省市区后，再次打开地址选择半模态弹窗页面，但是没有选择到区就关闭了半模态页面，此时如果再次打开半模态页面，需要显示之前完整选择的省区市数据
          this.currentSelectInfo.provinceId = this.lastSelectInfo.provinceId;
          this.currentSelectInfo.cityId = this.lastSelectInfo.cityId;
          this.currentSelectInfo.regionId = this.lastSelectInfo.regionId;
          this.currentSelectInfo.province = this.lastSelectInfo.province;
          this.currentSelectInfo.city = this.lastSelectInfo.city;
          this.currentSelectInfo.region = this.lastSelectInfo.region;
          this.cityList = JSON.parse(JSON.stringify(this.lastCityList));
          this.regionList = JSON.parse(JSON.stringify(this.lastRegionList));
          this.leftMargin = this.lastLeftMargin;
        } else {
          this.leftMargin =
            this.textInfos[0][1] + this.textInfos[1][1] + (this.textInfos[2][1] - Constants.DIVIDER_WIDTH) / 2 +
              Constants.AREA_SPACE * 2;
          this.lastLeftMargin = this.leftMargin;
        }
        this.controller.changeIndex(AddressType.Region);
      }
      this.animationDuration = Constants.ANIMATION_DURATION;
    })
    .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
      if (index === targetIndex) {
        return;
      }
      this.currentIndex = targetIndex;
      let leftMargin: number = 0;
      let isAnimating: boolean = false;
      if (index === AddressType.Province && targetIndex === AddressType.City) {
        // 从省切到市时，重新计算选择的省市区名下方的下滑线偏移量
        leftMargin = this.textInfos[0][1] + (this.textInfos[1][1] - Constants.DIVIDER_WIDTH) / 2 + Constants.AREA_SPACE;
        isAnimating = this.currentSelectInfo.city === '' ? false : true;
      } else if (index === AddressType.City && targetIndex === AddressType.Region) {
        // 从市切到区，重新计算选择的省市区名下方的下滑线偏移量
        leftMargin =
          this.textInfos[0][1] + this.textInfos[1][1] + (this.textInfos[2][1] - Constants.DIVIDER_WIDTH) / 2 +
            Constants.AREA_SPACE * 2;
        isAnimating = this.currentSelectInfo.region === '' ? false : true;
      } else if (index === AddressType.City && targetIndex === AddressType.Province) {
        // 从市切到省，重新计算选择的省市区名下方的下滑线偏移量
        leftMargin = (this.textInfos[0][1] - Constants.DIVIDER_WIDTH) / 2;
        isAnimating = this.currentSelectInfo.city === '' ? false : true;
      } else if (index === AddressType.Region && targetIndex === AddressType.City) {
        // 从区切到市，重新计算选择的省市区名下方的下滑线偏移量
        leftMargin = this.textInfos[0][1] + (this.textInfos[1][1] - Constants.DIVIDER_WIDTH) / 2 + Constants.AREA_SPACE;
        isAnimating = this.currentSelectInfo.region === '' ? false : true;
      } else if (index === AddressType.Region && targetIndex === AddressType.Province) {
        // 点击自定义TabBar从区切到省，重新计算选择的省市区名下方的下滑线偏移量
        leftMargin = (this.textInfos[0][1] - Constants.DIVIDER_WIDTH) / 2;
        isAnimating = this.currentSelectInfo.region === '' ? false : true;
      } else if (index === AddressType.Province && targetIndex === AddressType.Region) {
        // 点击自定义TabBar从省切到区，重新计算选择的省市区名下方的下滑线偏移量
        leftMargin =
          this.textInfos[0][1] + this.textInfos[1][1] + (this.textInfos[2][1] - Constants.DIVIDER_WIDTH) / 2 +
            Constants.AREA_SPACE * 2;
        isAnimating = this.currentSelectInfo.region === '' ? false : true;
      }
      // 只有在已经选择过的TabContent之间切换时，才会做下划线水平偏移动画
      if (isAnimating) {
        this.startAnimateTo(this.animationDuration, leftMargin);
      } else {
        this.leftMargin = leftMargin;
      }
    })
    .width($r('app.string.custom_address_picker_full_size'))
    .barHeight($r('app.float.custom_address_picker_size_zero'))
    .layoutWeight(Constants.SIZE_ONE)
  }

  /**
   * 地址选择半模态弹窗页面
   */
  @Builder
  addressSelectPage() {
    Column() {
      // 自定义TabBar
      this.customTabBar()
      Divider()
        .width($r('app.string.custom_address_picker_percent_ninety'))
        .strokeWidth(Constants.SIZE_ONE)
        .color($r('app.color.custom_address_picker_area_name_divider_color'))
      // 自定义Tabs
      this.customTabs()
    }
    .width($r('app.string.custom_address_picker_full_size'))
    .height($r('app.string.custom_address_picker_full_size'))
    .backgroundColor(Color.White)
    .padding({ bottom: this.bottomHeight + 'px' })
  }

  build() {
    Column() {
      Divider()
        .height($r('app.float.custom_address_picker_size_one'))
        .strokeWidth(Constants.SIZE_ONE)
        .color($r('app.color.custom_address_picker_area_name_divider_color'))
      Row() {
        Text($r('app.string.custom_address_picker_area'))
          .fontSize($r('app.float.custom_address_picker_size_sixteen'))
          .fontWeight(Constants.FONT_WEIGHT_FIVE_HUNDRED)
          .margin({ right: $r('app.float.custom_address_picker_size_twenty') })
        Text(this.provinceCityRegion)
          .fontSize($r('app.float.custom_address_picker_size_fifteen'))
          .fontColor(this.provinceCityRegion === '省、市、区' ? $r('app.color.custom_address_picker_name_font_color') :
          Color.Black)
          .fontWeight(Constants.FONT_WEIGHT_THREE_HUNDRED)
          .constraintSize({ maxWidth: 'calc(68%)' })
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(Constants.SIZE_ONE)
      }
      .width($r('app.string.custom_address_picker_full_size'))
      .height($r('app.float.custom_address_picker_size_forty_eight'))
      .onClick(() => {
        // 显示地址选择半模态弹窗页面
        this.isShow = true;
        this.currentIndex = AddressType.Province;
      })
      // TODO 知识点：使用bindSheet绑定地址选择半模态弹窗页面，isShow控制是否显示半模态页面
      .bindSheet($$this.isShow, this.addressSelectPage(), {
        height: $r('app.string.custom_address_picker_percent_seventy'), // 半模态弹窗高度
        showClose: false, // 设置不显示自带的关闭图标
        dragBar: false,
        onDisappear: () => {
          // 退出地址选择半模态弹窗页面时，重置相关参数
          this.animationDuration = 0;
          // 如果当前省市区没选全，则清空当前选择的地址信息
          if (this.currentSelectInfo.region === '') {
            this.currentSelectInfo.provinceId = '';
            this.currentSelectInfo.cityId = '';
            this.currentSelectInfo.regionId = '';
            this.currentSelectInfo.province = '';
            this.currentSelectInfo.city = '';
            this.currentSelectInfo.region = '';
            this.cityList = [];
            this.regionList = [];
          }
        }
      })

      Divider()
        .height($r('app.float.custom_address_picker_size_one'))
        .strokeWidth(Constants.SIZE_ONE)
        .color($r('app.color.custom_address_picker_area_name_divider_color'))
    }
    .width($r('app.string.custom_address_picker_full_size'))
    .height($r('app.float.custom_address_picker_size_fifty_four'))
    .padding($r('app.float.custom_address_picker_size_two'))
  }
}

/**
 * 地址信息类
 */
@Observed
export class AddressInfo {
  // 省id。对应address.json中第一级的code
  provinceId: string;
  // 市id。对应address.json中第二级的code
  cityId: string;
  // 区id。对应address.json中第三级的code
  regionId: string;
  // 省名。对应address.json中第一级的name
  province: string;
  // 市名。对应address.json中第二级的name
  city: string;
  // 区名。对应address.json中第三级的name
  region: string;

  constructor(province: string = '', city: string = '', region: string = '', provinceId: string = '',
    cityId: string = '', regionId: string = '') {
    this.province = province;
    this.city = city;
    this.region = region;
    this.provinceId = provinceId;
    this.cityId = cityId;
    this.regionId = regionId;
  }
}