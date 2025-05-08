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

import { Address, Label } from '../model/Address';
import { promptAction } from '@kit.ArkUI';
import { ADDRESS_LABEL } from '../common/CommonConstants';
import CommonConstants from '../common/CommonConstants'
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';
import { Cascade } from '../model/Cascade';
import { TextPickerView } from '../utils/TextPickerView'
import { PlatformTypeEnum, PlatformInfo } from 'utils'

const PHONE_NUMBER_LENGTH = 11; // 最大输入字符数

/**
 * 功能描述: 本示例通过使用TextPicker滑动选择文本内容组件实现三级联动选择省市区，并回填到输入框
 *
 * 推荐场景: 需要填写地址的场景，如：快递收获地址选择等
 *
 * 核心组件:
 * 1. TextPickerView 滑动选择文本内容组件
 *
 * 实现步骤：
 * 1. 初始化textPicker标题。
 *
 * @example
 * title: string | Resource = $r('app.string.editaddress_bind_sheet_title');
 *
 * 2. 读取文件中的省市区json数据。
 *
 * @example
 * async loadRegion(): Promise<void> {
 *   try {
 *     // 通过getRawFileContent()获取resources/rawfile目录下对应的文件内容，得到一个字节数组
 *     getContext(this).resourceManager.getRawFileContent(this.fileName, (error: BusinessError, value: Uint8Array) => {
 *       let rawFile = value;
 *       let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
 *       let retStr =
 *         textDecoder.decodeToString(rawFile, { stream: false }); // 再用@ohos.util (util工具函数)的TextDecoder给它解析出来
 *       this.cascade = JSON.parse(retStr);
 *       console.log('pqz' + this.cascade)
 *     })
 *   } catch (error) {
 *     let code = (error as BusinessError).code;
 *     let message = (error as BusinessError).message;
 *     console.error(`callback getRawFileContent failed, error code: ${code}, message: ${message}.`);
 *   }
 * }
 *
 * 3.构建TextPickerView视图组件
 *
 *  @example
 *  @Builder
 *  textPickerBuild(cascade: Array<Cascade>,
 *    selectHandle: (selectArr: number | number []) => void,
 *    cancelHandle: () => void,
 *    indexArr: number | number [], title: string | Resource) {
 *    Column() {
 *      TextPickerView({
 *        cascade,
 *        selectHandle,
 *        cancelHandle,
 *        indexArr,
 *        title
 *      });
 *    }
 *  }
 *
 *  4.将组件绑定在半模态
 *
 *  @example
 *  .bindSheet($$this.isPresent,
 *    this.textPickerBuild(this.cascade,
 *      (selectArr: number | number []) => {
 *        this.getSelectedPlace(selectArr);
 *        this.isPresent = false;
 *        this.isTextViewClicked = false;
 *      }, () => {
 *        this.isPresent = false;
 *        this.isTextViewClicked = false;
 *      }, this.addressForm.provinceArr, this.title), {
 *      // TextInput绑定半模态转场
 *      height: this.sheetHeight, // 半模态高度
 *      dragBar: this.showDragBar, // 是否显示控制条
 *      // 平板或折叠屏展开态在中间显示
 *      preferType: this.isCenter ? SheetType.CENTER : SheetType.POPUP,
 *      backgroundColor: $r('app.color.editaddress_btn_bgc'),
 *      showClose: false, // 是否显示关闭图标
 *      shouldDismiss: ((sheetDismiss: SheetDismiss) => { // 半模态页面交互式关闭回调函数
 *        sheetDismiss.dismiss();
 *      })
 *    })
 */
@Component
export struct EditAddressView {
  @StorageLink('keyboardHeight') keyboardHeight: number = 0;
  // 收件人输入框是否被选中
  @State isClicked: boolean = false;
  // 手机号输入框是否被选中
  @State isClicked1: boolean = false;
  // 所在地区输入框是否被选中
  @State isTextViewClicked?: boolean = false;
  // 详细地址输入框是否被选中
  @State isClicked3: boolean = false;
  // 地址标签是否被选中
  @State isChecked: boolean = false;
  // 智能填写输入框默认值
  @State pasteString: string = "";
  // 智能框输入值
  @State addressString: string = "";
  // 省市区数据
  @State addressForm: Address = new Address("", "", [0, 0, 0], "", "", "");
  // 标识是否需要软键盘避让
  @State flag: boolean = false;
  // 是否显示半屏模态页面
  @State isPresent: boolean = false;
  // 半模态高度
  @State sheetHeight: number = 300;
  // 是否显示控制条
  @State showDragBar: boolean = true;
  // 平板或折叠屏展开态在中间显示
  @State isCenter: boolean = true;
  // 省市区数据存放文件地址
  fileName: string = 'regionsdata.json';
  @StorageLink('avoidAreaBottomToModule') avoidAreaBottomToModule: number = 0;
  // 存放省市区数据
  @State cascade: Array<Cascade> = [];
  // 滚动控制器
  scroller: ListScroller = new ListScroller();
  // textPicker标题
  title: string | Resource = $r('app.string.editaddress_bind_sheet_title');

  aboutToAppear(): void {
    this.loadRegion();
  }

  /**
   * 从文件中读取省市区json数据
   */
  async loadRegion(): Promise<void> {
    try {
      // 通过getRawFileContent()获取resources/rawfile目录下对应的文件内容，得到一个字节数组
      getContext(this).resourceManager.getRawFileContent(this.fileName, (error: BusinessError, value: Uint8Array) => {
        let rawFile = value;
        let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
        let retStr =
          textDecoder.decodeToString(rawFile, { stream: false }); // 再用@ohos.util (util工具函数)的TextDecoder给它解析出来
        this.cascade = JSON.parse(retStr);
      })
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      console.error(`callback getRawFileContent failed, error code: ${code}, message: ${message}.`);
    }
  }

  /**
   * 保存时，校验表单从上到下每项必填的方法
   */
  validForm(): boolean {
    if (!this.addressForm.name) {
      promptAction.showToast({ message: $r('app.string.editaddress_name_judge') });
      return false;
    }
    if (!this.addressForm.phone) {
      promptAction.showToast({ message: $r('app.string.editaddress_phone_judge') });
      return false;
    }
    if (this.addressForm.phone.length < 11) {
      promptAction.showToast({ message: $r('app.string.editaddress_phone_judge_less_eleven') });
      return false;
    }
    if (!this.addressForm.areaName) {
      promptAction.showToast({ message: $r('app.string.editaddress_place_judge') });
      return false;
    }
    if (!this.addressForm.area) {
      promptAction.showToast({ message: $r('app.string.editaddress_detail_address_judge') });
      return false;
    }
    return true;
  }

  /**
   * 从TextPicker返回选中的数据中逐级查找省、市、区的名称，并将其组合成一个完整的地址字符串。
   */
  getSelectedPlace(selectArr: number | number []) {
    if (selectArr instanceof Array) {
      let province = this.cascade[selectArr[0]]; // 获取省信息
      let areaName = ""; // 存储最终构建的省市区名称
      if (province) {
        areaName += this.cascade[selectArr[0]].text; // 省的名称添加到容器里
        if (province.children) { // 检查是否有市的信息
          let city = province.children[selectArr[1]]; // 市的名称添加到容器里
          if (city) {
            areaName += city.text;
            if (city.children) { // 检查是否有区的信息
              areaName += city.children[selectArr[2]].text; // 区的名称添加到容器里
            }
          }
        }
      }
      this.addressForm.areaName = areaName; // 将取出的省市区拼接的字符串回填给TextInput
      return;
    }
  }

  /**
   * TextPickerView视图
   *
   * @param {Array<Cascade>} cascade - 联动资源属性
   * @param {void} selectHandle - 点击确定逻辑
   * @param {void} cancelHandle - 点击取消逻辑
   * @param {number | number []} indexArr - 默认选中项在数组中的索引值
   * @param {string | Resource} title - TextPickerView标题
   */
  @Builder
  textPickerBuild(cascade: Array<Cascade>,
    selectHandle: (selectArr: number | number []) => void,
    cancelHandle: () => void,
    indexArr: number | number [], title: string | Resource) {
    Column() {
      TextPickerView({
        cascade,
        selectHandle,
        cancelHandle,
        indexArr,
        title
      });
    }
  }

  build() {
    Column() {
      List({ scroller: this.scroller }) {
        ListItem() {
          Column() {
            Text($r('app.string.editaddress_address_msg'))
              .fontColor(Color.Black)
              .fontSize(CommonConstants.TEXT_FONTSIZE)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
              .width($r('app.string.editaddress_address_width'))
              .height(CommonConstants.TEXT_HEIGHT)
              .padding({ top: CommonConstants.PADDING_TOP_TWO })

            Row() {
              label({ labelName: $r('app.string.editaddress_receiver') })

              TextInput({ placeholder: $r('app.string.editaddress_receiver_name'), text: this.addressForm.name })
                .margin({ left: CommonConstants.MARGIN_LEFT_TWO, right: CommonConstants.MARGIN_RIGHT_TWO })
                .width($r('app.string.editaddress_textInput_width'))
                .backgroundColor($r('app.color.editaddress_textInput_bgc_color'))
                .borderRadius(CommonConstants.BUBBLE_BORDER_RADIUS_TWO)
                .borderWidth(1)
                .enterKeyType(EnterKeyType.Done)
                .borderColor(this.isClicked ? $r('app.color.editaddress_editaddress_save_bgc_color') :
                Color.Transparent)
                .placeholderFont({
                  size: CommonConstants.PLACE_HOLDER_FONTSIZE,
                  weight: CommonConstants.PLACE_HOLDER_FONT_WEIGHT
                })
                .onChange((value: string) => {
                  this.addressForm.name = value;
                })
                .onEditChange(() => {
                  this.isClicked = !this.isClicked;
                })
                .id('recipient')
            }
            .width(CommonConstants.FULL_PERCENT)
            .height(CommonConstants.LIST_ITEM_ROW_HEIGHT)
            .margin({ top: CommonConstants.MARGIN_TOP_TWO })

            Row() {
              label({ labelName: $r('app.string.editaddress_phone_number') })

              Row() {
                Text($r('app.string.editaddress_86'))
                  .fontSize(CommonConstants.LABEL_FONTSIZE)
                  .padding({ left: CommonConstants.PADDING_LEFT })
                  .onClick(() => {
                    // 调用Toast显示提示:此样式仅为案例展示
                    promptAction.showToast({ message: $r('app.string.editaddress_only_show_ui') });
                  })
                Image($r('app.media.editaddress_down'))
                  .aspectRatio(1)
                  .width(15)
                  .padding({ left: CommonConstants.PADDING_LEFT_TWO })
                  .onClick(() => {
                    // 调用Toast显示提示:此样式仅为案例展示
                    promptAction.showToast({ message: $r('app.string.editaddress_only_show_ui') });
                  })

                TextInput({ placeholder: $r('app.string.editaddress_phone_number'), text: this.addressForm.phone })
                  .enterKeyType(EnterKeyType.Done)
                  .backgroundColor(Color.Transparent)
                  .width($r('app.string.editaddress_textInput_width'))
                  .placeholderFont({
                    size: CommonConstants.PLACE_HOLDER_FONTSIZE,
                    weight: CommonConstants.PLACE_HOLDER_FONT_WEIGHT
                  })
                  .onChange((value: string) => {
                    this.addressForm.phone = value;
                    if (value.length > PHONE_NUMBER_LENGTH) {
                      this.addressForm.phone = value.substring(0, PHONE_NUMBER_LENGTH)
                      promptAction.showToast({
                        // 设置最大输入手机号不能超过11位
                        message: $r('app.string.editaddress_phone_judge_more_eleven')
                      })
                    }
                  })
                  .onEditChange(() => {
                    this.isClicked1 = !this.isClicked1;
                  })
                  .id('phoneNumber')
              }
              .border({
                color: this.isClicked1 ? $r('app.color.editaddress_editaddress_save_bgc_color') : Color.Transparent,
                width: 1,
                radius: CommonConstants.BORDER_RADIUS_THREE
              })
              .width($r('app.string.editaddress_textInput_width'))
              .margin({ left: CommonConstants.MARGIN_LEFT_TWO })
              .backgroundColor($r('app.color.editaddress_textInput_bgc_color'))
            }
            .width(CommonConstants.FULL_PERCENT)
            .height(CommonConstants.ROW_HEIGHT_FOUR)
            .margin({ top: CommonConstants.MARGIN_TOP_TWO })

            Row() {
              label({ labelName: $r('app.string.editaddress_local') })

              Stack({ alignContent: Alignment.End }) {
                Text(this.addressForm.areaName === '' ? $r('app.string.editaddress_pca') : this.addressForm.areaName)
                  .width(CommonConstants.FULL_PERCENT)
                  .textIndent(15)
                  .bindSheet($$this.isPresent, this.textPickerBuild(this.cascade, (selectArr: number | number []) => {
                    this.getSelectedPlace(selectArr);
                    this.isPresent = false;
                    this.isTextViewClicked = false;
                  }, () => {
                    this.isPresent = false;
                    this.isTextViewClicked = false;
                  }, this.addressForm.provinceArr, this.title), {
                    // TextInput绑定半模态转场
                    height: this.sheetHeight, // 半模态高度
                    dragBar: this.showDragBar, // 是否显示控制条
                    // 平板或折叠屏展开态在中间显示
                    preferType: this.isCenter ? SheetType.CENTER : SheetType.POPUP,
                    backgroundColor: $r('app.color.editaddress_btn_bgc'),
                    showClose: false, // 是否显示关闭图标
                    shouldDismiss: ((sheetDismiss: SheetDismiss) => { // 半模态页面交互式关闭回调函数
                      sheetDismiss.dismiss();
                    })
                  })
                  .onClick(() => {
                    this.isPresent = true;
                    this.isTextViewClicked = true;
                  })
                  .id('selectAddress')

                Image($r('app.media.editaddress_right'))
                  .aspectRatio(1)
                  .width(CommonConstants.IMAGE_HEIGHT)
                  .padding({ right: CommonConstants.PADDING_RIGHT })
                  .onClick(() => {
                    this.isPresent = true;
                  })
              }
              .width($r('app.string.editaddress_textInput_width'))
              .height(CommonConstants.STACK_HEIGHT_TWO)
              .margin({ left: CommonConstants.MARGIN_LEFT })
              .border({
                color: this.isTextViewClicked ? $r('app.color.editaddress_editaddress_save_bgc_color') :
                Color.Transparent,
                width: 1,
                radius: CommonConstants.BUBBLE_BORDER_RADIUS_TWO
              })
              .backgroundColor($r('app.color.editaddress_textInput_bgc_color'))
              .borderRadius(CommonConstants.BORDER_RADIUS_THREE)

            }
            .width(CommonConstants.FULL_PERCENT)
            .height(CommonConstants.ROW_HEIGHT_FOUR)
            .margin({ top: CommonConstants.MARGIN_TOP_TWO })

            Row() {
              label({ labelName: $r('app.string.editaddress_detail_address') })

              Stack({ alignContent: Alignment.End }) {
                TextArea({ placeholder: $r('app.string.editaddress_detail_msg'), text: this.addressForm.area })
                  .width(CommonConstants.FULL_PERCENT)
                  .backgroundColor($r('app.color.editaddress_textInput_bgc_color'))
                  .borderRadius(CommonConstants.BUBBLE_BORDER_RADIUS_TWO)
                  .height(CommonConstants.TEXT_INPUT_HEIGHT)
                  .contentType(ContentType.FULL_STREET_ADDRESS)
                  .enableAutoFill(true)
                  .enterKeyType(EnterKeyType.Done)
                  .placeholderFont({
                    size: CommonConstants.PLACE_HOLDER_FONTSIZE,
                    weight: CommonConstants.PLACE_HOLDER_FONT_WEIGHT
                  })
                  .onChange((value: string) => {
                    this.addressForm.area = value;
                  })
                  .onEditChange(() => {
                    this.isClicked3 = !this.isClicked3;
                  })
                  .id('detailAddress')
                Image($r('app.media.editaddres_loaction'))
                  .aspectRatio(1)
                  .width(CommonConstants.IMAGE_HEIGHT_TWO)
                  .onClick(() => {
                    // 调用Toast显示提示:此样式仅为案例展示
                    promptAction.showToast({ message: $r('app.string.editaddress_only_show_ui') });
                  })
              }
              .width($r('app.string.editaddress_stack_width'))
              .height(CommonConstants.STACK_HEIGHT)
              .margin({ left: CommonConstants.MARGIN_LEFT, top: CommonConstants.MARGIN_TOP_THREE })
              .border({
                color: this.isClicked3 ? $r('app.color.editaddress_editaddress_save_bgc_color') : Color.Transparent,
                width: 1,
                radius: CommonConstants.BUBBLE_BORDER_RADIUS_TWO
              })
            }
            .width(CommonConstants.FULL_PERCENT)
            .height(CommonConstants.ROW_HEIGHT_THREE)
            .margin({ top: CommonConstants.MARGIN_TOP_TWO })

            Row() {
              Text($r('app.string.editaddress_address_tag'))
                .fontColor(Color.Black)
                .fontSize(CommonConstants.LABEL_NAME_FONTSIZE)
                .fontWeight(CommonConstants.LABEL_FONT_WEIGHT)
                .textAlign(TextAlign.Start)
              Row() {
                ForEach(ADDRESS_LABEL, (item: number) => {
                  Stack({ alignContent: Alignment.TopEnd }) {
                    Text('' + item)
                      .width(CommonConstants.BUBBLE_AREA_HEIGHT)
                      .height(CommonConstants.BUBBLE_AREA_HEIGHT)
                      .fontSize(CommonConstants.BUBBLE_FONTSIZE)
                      .fontColor(Color.White)
                      .fontWeight(CommonConstants.LABEL_BUBBLE_FONT_WEIGHT)
                      .textAlign(TextAlign.Center)
                      .borderRadius(CommonConstants.BUBBLE_BORDER_RADIUS)
                      .onClick(() => {
                        this.addressForm.tag = '' + item;
                      })
                      .backgroundColor($r('app.color.editaddress_editaddress_save_bgc_color'))
                      .margin({ left: CommonConstants.MARGIN_LEFT_THREE })

                    if (this.addressForm.tag === '' + item) { // 如果被选中，该地址标签打勾
                      Text("√")
                        .fontSize(CommonConstants.BUBBLE_CHECK_FONTSIZE)
                        .fontWeight(FontWeight.Bold)
                        .width(CommonConstants.BUBBLE_CHECK_HEIGHT)
                        .height(CommonConstants.BUBBLE_CHECK_HEIGHT)
                        .fontColor(Color.White)
                        .backgroundColor($r('app.color.editaddress_editaddress_save_bgc_color'))
                        .textAlign(TextAlign.Center)
                        .border({
                          width: 2,
                          color: Color.White,
                          radius: 55
                        })
                        .margin({ top: $r('app.string.editaddress_label_check') })
                    }
                  }
                }, (item: string) => item)
              }
              .margin({ left: CommonConstants.BUBBLE_CHECK_FONTSIZE })
            }
            .width(CommonConstants.FULL_PERCENT)
            .height(CommonConstants.ROW_HEIGHT_FOUR)
            .margin({ top: CommonConstants.MARGIN_TOP_FOUR })
          }
          .margin({ left: CommonConstants.MARGIN_LEFT, right: CommonConstants.MARGIN_RIGHT })
        }
        .backgroundColor(Color.White)
        .borderRadius(CommonConstants.BORDER_RADIUS)
        .height(CommonConstants.LIST_ITEM_HEIGHT)

        ListItem() {
          Column() {
            Text($r('app.string.editaddress_AI_write'))
              .fontSize(CommonConstants.TEXT_FONTSIZE)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
              .width(CommonConstants.FULL_PERCENT)
              .height(CommonConstants.TEXT_HEIGHT)
              .padding({ top: CommonConstants.PADDING_TOP_TWO, bottom: CommonConstants.PADDING_BOTTOM })

            TextArea({ placeholder: $r('app.string.editaddress_AI_write_msg'), text: this.pasteString })
              .backgroundColor(Color.Transparent)
              .contentType(ContentType.FULL_STREET_ADDRESS)
              .enableAutoFill(true)
              .placeholderFont({
                size: CommonConstants.PLACE_HOLDER_FONTSIZE,
                weight: CommonConstants.PLACE_HOLDER_FONT_WEIGHT
              })
              .enterKeyType(EnterKeyType.Done)
              .padding({ left: 0, top: 12 })// 此处left：0表示光标顶格输入
              .height(CommonConstants.TEXT_AREA_HEIGHT)
              .onDidInsert((info: InsertValue) => {
                this.addressString = info.insertValue;
              })
              .onFocus(() => {
                this.flag = true; // 获得焦点时，标识需要键盘避让
              })
              .onBlur(() => {
                this.flag = false; // 失去焦点时，标识不需要键盘避让
              })

            Row() {
              /*
               * TODO:知识点：已正式上架的应用，可使用智能填充服务进行地址识别。
               * 详见：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/scenario-fusion-intelligentfilling-autocomplete-V5
               */
              Text($r('app.string.editaddress_paste'))
                .fontColor($r('app.color.editaddress_editaddress_save_bgc_color'))
                .fontSize(CommonConstants.LABEL_FONTSIZE)
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.End)
                .width(CommonConstants.FULL_PERCENT)
                .onClick(() => {
                  promptAction.showToast({ message: $r('app.string.editaddress_only_show_ui') });
                })
            }
            .height(CommonConstants.ROW_HEIGHT_TWO)
            .width($r('app.string.editaddress_row_width'))
          }.margin({ left: CommonConstants.MARGIN_LEFT, right: CommonConstants.MARGIN_RIGHT })
        }
        .backgroundColor(Color.White)
        .borderRadius(CommonConstants.BORDER_RADIUS)
        .height(CommonConstants.LIST_ITEM_HEIGHT_TWO)
        .margin({ top: CommonConstants.MARGIN_TOP })
      }
      .onAreaChange(() => {
        // 控制列表滚动条到底部
        this.scroller.scrollEdge(Edge.Bottom);
      })
      .width($r('app.string.editaddress_list_width'))
      // 列表高度-（键盘高度-底部row组件高度）即为键盘避让模式下列表的高度，再通过List.onAreaChange(){this.scroller.scrollEdge(Edge.Bottom);}
      // 控制列表高度变化时使滚动条到达底部，从而实现类似键盘避让的效果。
      .height(PlatformInfo.isArkUIX() ? "75%" :
        (this.flag ? px2vp(CommonConstants.LIST_HEIGHT - (this.keyboardHeight - CommonConstants.AVOID_AREA_HEIGHT)) :
        px2vp(CommonConstants.LIST_HEIGHT)))
      .scrollBar(BarState.Off)

      Blank()

      Row() {
        Button($r('app.string.editaddress_save'))
          .borderRadius(CommonConstants.BORDER_RADIUS_TWO)
          .fontWeight(FontWeight.Bold)
          .foregroundColor(Color.White)
          .height(CommonConstants.BUTTON_HEIGHT)
          .width($r('app.string.editaddress_button_width'))
          .backgroundColor($r('app.color.editaddress_editaddress_save_bgc_color'))
          .expandSafeArea([SafeAreaType.KEYBOARD])
          .onClick(() => {
            if (this.validForm()) {
              promptAction.showToast({ message: $r('app.string.editaddress_save_success') });
            }
          })
      }
      .alignItems(VerticalAlign.Bottom)
      .justifyContent(FlexAlign.Center)
      .height(CommonConstants.ROW_HEIGHT)
      .width($r('app.string.editaddress_row_width'))
      .margin({ bottom: 20 })
    }
    .padding({ bottom: px2vp(this.avoidAreaBottomToModule) })
    .width($r('app.string.editaddress_column_width'))
    .height($r('app.string.editaddress_column_height'))
    .backgroundColor($r('app.color.editaddress_column_bgc_color'))
  }
}

/**
 * 地址信息模块每条输入框的标签名
 * 格式：收件人*,手机号*
 */
@Builder
function label(params: Label) {
  Text() {
    Span(params.labelName)
      .fontColor(Color.Black)
      .fontSize(CommonConstants.LABEL_NAME_FONTSIZE)
      .fontWeight(CommonConstants.LABEL_FONT_WEIGHT)
    Span("*")
      .fontColor($r('app.color.editaddress_editaddress_save_bgc_color'))
      .fontSize(CommonConstants.LABEL_FONTSIZE)
  }.textAlign(TextAlign.Start)
}
