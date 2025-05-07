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

import { CustomAddressPicker, AddressInfo } from '../customaddresspicker/view/CustomAddressPicker';
import { emitter } from '@kit.BasicServicesKit';

const SPACE = 20;
const FONT_WEIGHT = 600;

/**
 * 功能描述：本示例介绍如何使用bindSheet，changeIndex，onAreaChange实现带切换动效的自定义地址选择组件。
 *
 * 推荐场景：需要弹窗选择省市区的地址选择场景。如常见的收货地址编辑页面中的'所在地区'选择
 *
 * 核心组件：
 * 1.CustomAddressPicker
 *
 * 实现步骤：
 *  1.创建AddressInfo对象（可以不传入省市区名，也可以传入有效的省市区名），然后作为参数传入自定义地址选择组件CustomAddressPicker
 *  2.CustomAddressPicker中通过getRawFileContentSync从rawfile目录下读取省市区json文件数据，使用util.TextDecoder进行解码。
 *  3.CustomAddressPicker中通过bindSheet绑定地址选择半模态弹窗页面。
 *  4.CustomAddressPicker中通过changeIndex控制省市区列表TabContent切换。
 *  5.CustomAddressPicker中通过组件区域变化回调onAreaChange获取选择的省市区Text组件宽度，存入textInfos数组，用于后续计算选择省市区名后下
 *  方下滑线动画水平偏移量leftMargin。
 *  6.CustomAddressPicker中在选择完区名后，使用JSON.parse(JSON.stringify(xxx))深拷贝选择的省市区数据，用于后续操作中需要加载上一次选择
 *  的完整省市区数据。
 */
@Component
export struct AddressPickerSamplePage {
  @State noAddress: AddressInfo = new AddressInfo(); // 不传入地址信息
  @State hasAddress: AddressInfo = new AddressInfo('浙江省', '杭州市', '余杭区'); // 传入有效的地址信息
  private addressInfo: string = '';

  build() {
    Column({ space: SPACE }) {
      Column({ space: SPACE }) {
        Text($r('app.string.custom_address_picker_scenario_one'))
          .width($r('app.string.custom_address_picker_full_size'))
          .fontSize($r('app.float.custom_address_picker_size_sixteen'))
          .fontWeight(FONT_WEIGHT)
        CustomAddressPicker({ address: this.noAddress }).id('scenarioOne')
        Button($r('app.string.custom_address_picker_get_address_info'))
          .width($r('app.string.custom_address_picker_percent_ninety'))
          .height($r('app.float.custom_address_picker_size_forty'))
          .id('scenarioOneBtn')
          .onClick(() => {
            this.addressInfo = JSON.stringify(this.noAddress);
            emitter.emit({ eventId: 0, priority: 0 }, {
              data: {
                addressInfo: this.addressInfo
              }
            })
            AlertDialog.show({
              message: this.addressInfo,
              alignment: DialogAlignment.Center
            });
          })
      }
      .backgroundColor(Color.White)
      .borderRadius($r('app.float.custom_address_picker_size_twenty_four'))
      .padding({
        left: $r('app.float.custom_address_picker_size_fifteen'),
        right: $r('app.float.custom_address_picker_size_fifteen'),
        top: $r('app.float.custom_address_picker_size_thirty'),
        bottom: $r('app.float.custom_address_picker_size_thirty')
      })

      Column({ space: SPACE }) {
        Text($r('app.string.custom_address_picker_scenario_two'))
          .width($r('app.string.custom_address_picker_full_size'))
          .fontWeight(FONT_WEIGHT)
          .fontSize($r('app.float.custom_address_picker_size_sixteen'))
        CustomAddressPicker({ address: this.hasAddress }).id('scenarioTwo')
        Button($r('app.string.custom_address_picker_get_address_info'))
          .width($r('app.string.custom_address_picker_percent_ninety'))
          .height($r('app.float.custom_address_picker_size_forty'))
          .id('scenarioTwoBtn')
          .onClick(() => {
            this.addressInfo = JSON.stringify(this.hasAddress);
            emitter.emit({ eventId: 0, priority: 0 }, {
              data: {
                addressInfo: this.addressInfo
              }
            })
            AlertDialog.show({
              message: this.addressInfo,
              alignment: DialogAlignment.Center
            });
          })
      }
      .backgroundColor(Color.White)
      .borderRadius($r('app.float.custom_address_picker_size_twenty_four'))
      .padding({
        left: $r('app.float.custom_address_picker_size_fifteen'),
        right: $r('app.float.custom_address_picker_size_fifteen'),
        top: $r('app.float.custom_address_picker_size_thirty'),
        bottom: $r('app.float.custom_address_picker_size_thirty')
      })
    }
    .backgroundColor($r('app.color.custom_address_picker_bg'))
    .padding($r('app.float.custom_address_picker_size_fifteen'))
    .width($r('app.string.custom_address_picker_full_size'))
    .height($r('app.string.custom_address_picker_full_size'))
  }
}