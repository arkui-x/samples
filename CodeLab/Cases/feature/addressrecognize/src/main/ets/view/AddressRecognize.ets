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

import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { LengthMetrics, LengthUnit, promptAction, window } from '@kit.ArkUI';
import { EntityType, textProcessing } from '@kit.NaturalLanguageKit';
import { textRecognition } from '@kit.CoreVisionKit';
import { loading, clearLoading } from '../components/loading/Loading';
import { GlobalContext } from '../components/loading/GlobalContext';
import { common } from '@kit.AbilityKit';
import { ImageEditParam } from '../models/ImageEditParam';
import { ImageEdit } from './ImageEdit';
import { image } from '@kit.ImageKit';
import { DialogUtil, DialogBuilderParam, DialogTypeEnum } from '@lvnanqing/lvdialog';
import { cameraPicker } from '@kit.CameraKit';
import { camera } from '@kit.CameraKit';
import { CommonConstants } from '../common/CommonConstants';
import { Address, MOCK_ADDRESS_DATA, Tag, MOCK_TAG_DATA } from '../models/Address';

@Builder
function imageEditDialogBuilder(param: DialogBuilderParam) {
  ImageEdit({ param: param })
}

/**
 * 场景描述: 本示例使用CoreVisionKit智能识别图片中的文字，并使用NaturalLanguageKit自然语言处理工具集将识别的文字智能转换为姓名、手机、地址等信息
 *
 * 推荐场景: 扫描图片获取图片内文字场景，如：文本扫描、快递地址识别等
 *
 * 核心组件:
 * 1. AddressRecognize.addressPanel
 *
 * 实现步骤:
 * 1. 点击【从相册选择】打开图库，选择一张带有地址信息的照片，选择完照片打开照片裁剪弹窗界面。也可以选择拍照获取带地址的图片
 * 2. 加载选择的图片，使用Cavas绘制蒙层、裁剪框等
 * 3. 点击完成。调用pixelMap.crop完成图片裁剪，将裁剪后的pixelMap返回到主页面进行识别
 * 4. 调用AI接口智能将文本内容转换为姓名、电话、地址等信息，填充到联系人信息
 */
@Component
export struct AddressRecognize {
  @State bottomHeight: number = 0; // 底部系统导航栏高度
  context: common.UIAbilityContext | undefined = (getContext(this) as common.UIAbilityContext);
  savePath: string = getContext().filesDir;
  dialogId: string = '1';
  //显示
  @State showMenu: boolean = false;
  loadingId: number = -1;
  @State phone: string = "";
  //识别文本
  @State recognizeText: string = "";
  @State name: string = "";
  @State textError: string = ''
  @State address: string = "";
  @State isDefault: boolean = false;
  avoidAreaType: number = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR;
  @State isShowPanel: boolean = false;
  //地址列表
  @State myAddressList: Array<Address> = MOCK_ADDRESS_DATA;
  @State myTagList: Array<Tag> = MOCK_TAG_DATA;
  selectTagIndex: number = -1;

  aboutToAppear(): void {
    DialogUtil.setUIContext(this.getUIContext());
    GlobalContext.getContext().setObject('UIContext', this);
    window.getLastWindow(getContext(this)).then((window) => {
      const avoidArea = window.getWindowAvoidArea(this.avoidAreaType);
      this.bottomHeight = px2vp(avoidArea.bottomRect.height);
    });
  }

  @Builder
  builderMenus() {
    Column() {
      Text($r('app.string.addressrecognize_take_photo_button'))
        .margin($r('app.integer.addressrecognize_length_ten'))
        .fontSize($r('app.integer.addressrecognize_font_size_16'))
        .onClick(() => {
          this.showMenu = false;
          this.takePhoto();
        })

      Divider().height(CommonConstants.DIVIDER_HEIGHT).color($r('app.color.addressrecognize_divider_color'));

      Text($r('app.string.addressrecognize_picker_button'))
        .margin($r('app.integer.addressrecognize_length_ten'))
        .fontSize($r('app.integer.addressrecognize_font_size_16'))
        .onClick(() => {
          this.showMenu = false;
          this.imagePicker();
        })

      Divider().height(CommonConstants.DIVIDER_HEIGHT).color($r('app.color.addressrecognize_divider_color'));

      Text($r('app.string.addressrecognize_cancel_button'))
        .margin($r('app.integer.addressrecognize_length_ten'))
        .fontSize($r('app.integer.addressrecognize_font_size_16'))
        .onClick(() => {
          this.showMenu = false;
        })

      Divider().height(CommonConstants.DIVIDER_HEIGHT).color($r('app.color.addressrecognize_divider_color'));
    }
    .width($r('app.string.addressrecognize_width_percent_full'))
    .height($r('app.integer.addressrecognize_menu_height'))
  }

  // 重置默认地址
  resetIsDefault() {
    const addressList: Address[] = [];
    this.myAddressList.forEach((address: Address) => {
      if (address.defaultFlag) {
        address.defaultFlag = false;
      }
      addressList.push(address);
    });
    this.myAddressList = addressList;
  }

  /**
   * 保存地址
   */
  saveAddress(): void {
    if (!this.name || this.name === '') {
      promptAction.showToast({
        message: $r('app.string.addressrecognize_name_null_msg'),
        duration: CommonConstants.TOAST_DURATION,
        textColor: Color.Red
      });
      return;
    }
    if (!this.phone || this.phone === '') {
      promptAction.showToast({
        message: $r('app.string.addressrecognize_tel_null_msg'),
        duration: CommonConstants.TOAST_DURATION,
        textColor: Color.Red
      });
      return;
    }
    if (!this.address || this.address === '') {
      promptAction.showToast({
        message: $r('app.string.addressrecognize_address_null_msg'),
        duration: CommonConstants.TOAST_DURATION,
        textColor: Color.Red
      });
      return;
    }
    let tag = this.selectTagIndex === -1 ? "" : this.myTagList[this.selectTagIndex].label;
    let newAddress: Address = new Address(this.name, this.phone, this.address, tag, this.isDefault);
    // 当新增默认地址时，将原有默认地址改为非默认
    if (this.isDefault) {
      this.resetIsDefault();
    }
    this.myAddressList.push(newAddress);
    promptAction.showToast({
      message: $r('app.string.addressrecognize_save_success'),
      duration: CommonConstants.TOAST_DURATION,
      textColor: Color.Green
    });
    this.clearHistoryData();
    this.isShowPanel = false;
  }

  /**
   * 智能识别
   */
  doEntityRecognition(): void {
    textProcessing.getEntity(this.recognizeText, {
      entityTypes: [EntityType.NAME, EntityType.PHONE_NO, EntityType.LOCATION]
    }).then(result => {
      this.formatEntityResult(result);
    }).catch((err: BusinessError) => {
      console.error(`getEntity errorCode: ${err.code} errorMessage: ${err.message}`);
      promptAction.showToast({
        message: $r('app.string.addressrecognize_recognize_fail_text'),
        duration: CommonConstants.TOAST_DURATION
      });
      //清除loading
      clearLoading(this.loadingId);
    })
  }

  /**
   * 识别图片转文字
   * @param pixelMap
   */
  recognizeImageToText(pixelMap: image.PixelMap) {
    if (!pixelMap) {
      promptAction.showToast({
        message: $r('app.string.addressrecognize_recognize_image_fail_text'),
        duration: CommonConstants.TOAST_DURATION
      });
      // 清除loading
      clearLoading(this.loadingId);
      return;
    }
    // 调用文本识别接口
    let visionInfo: textRecognition.VisionInfo = {
      pixelMap: pixelMap
    };
    let textConfiguration: textRecognition.TextRecognitionConfiguration = {
      isDirectionDetectionSupported: false
    };
    setTimeout(() => {
      try {
        textRecognition.recognizeText(visionInfo, textConfiguration,
          (error: BusinessError, data: textRecognition.TextRecognitionResult) => {
            // 识别成功，获取对应的结果
            if (error?.code == 0) {
              // 将结果更新到Text中显示
              this.recognizeText = data.value;
            }
          });
      } catch (e) {
        promptAction.showToast({
          message: $r('app.string.addressrecognize_recognize_fail_text'),
          duration: CommonConstants.TOAST_DURATION
        });
      } finally {
        // 清除loading
        clearLoading(this.loadingId);
      }
    }, CommonConstants.TOAST_DURATION);
  }

  /**
   * 打开图片裁剪弹窗
   * @param uri
   */
  openSnapshotEditDialog(uri: string): void {
    DialogUtil.showCustomDialog({
      dialogId: this.dialogId,
      builder: wrapBuilder(imageEditDialogBuilder),
      dialogType: DialogTypeEnum.BOTTOM,
      dialogBuilderParam: {
        onConfirm: (isCloseDialog?: boolean, data?: ESObject) => {
          if (isCloseDialog) {
            DialogUtil.closeCustomDialogById(this.dialogId);
            loading($r('app.string.addressrecognize_recognize_text')).then((loadingId) => {
              this.loadingId = loadingId;
              this.recognizeImageToText(data);
            });
          } else {
            promptAction.showToast({
              message: data,
              duration: CommonConstants.TOAST_DURATION
            });
          }
        },
        data: new ImageEditParam(uri, this.bottomHeight)
      },
      isSlideToClose: false,
      isModalClosedByOverlayClick: false
    });
  }

  /**
   * 拍摄照片
   * @returns
   */
  async takePhoto(): Promise<void> {
    // 拉起拍照功能
    if (this.context) {
      let pickerProfile: cameraPicker.PickerProfile = {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
      };
      let pickerResult: cameraPicker.PickerResult = await cameraPicker.pick(this.context,
        [cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO], pickerProfile);
      if (pickerResult.resultCode === CommonConstants.CAMERA_PICKER_RESULT_CODE_FAILURE) {
        // 当进入拍照页面点击X，直接返回原页面
        return;
      } else if (pickerResult.resultCode === CommonConstants.CAMERA_PICKER_RESULT_CODE_SUCCESS) {
        // 打开照片裁剪弹窗
        this.openSnapshotEditDialog(pickerResult.resultUri);
      }
    }
  }

  /**
   * 格式化识别结果
   * @param entities
   */
  formatEntityResult(entities: textProcessing.Entity[]): void {
    if (!entities || !entities.length) {
      // 清除loading
      setTimeout(() => {
        promptAction.showToast({
          message: $r('app.string.addressrecognize_recognize_fail_text'),
          duration: CommonConstants.TOAST_DURATION
        });
        clearLoading(this.loadingId);
      }, CommonConstants.TOAST_DURATION)
      return;
    }
    for (let i = 0; i < entities.length; i++) {
      let entity = entities[i];
      if (entity.type === EntityType.NAME) {
        // 姓名
        this.name = entity.text;
      } else if (entity.type === EntityType.PHONE_NO) {
        // 电话
        this.phone = entity.text;
      } else if (entity.type === EntityType.LOCATION) {
        // 地址
        this.address = entity.text;
      }
    }
    //定时2秒清除loading，模拟下识别等待，不然刷新loading太快
    setTimeout(() => {
      clearLoading(this.loadingId);
    }, CommonConstants.TOAST_DURATION)
  }

  /**
   * 选择图库照片
   */
  imagePicker(): void {
    // 选择选项
    const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    // 过滤选择媒体文件类型为IMAGE
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    // 选择媒体文件的最大数目
    photoSelectOptions.maxSelectNumber = 1;
    const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
    photoViewPicker.select(photoSelectOptions).then((photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
      let uris = photoSelectResult.photoUris;
      if (uris.length > 0) {
        // 打开照片裁剪弹窗
        this.openSnapshotEditDialog(uris[0]);
      }
    }).catch((err: BusinessError) => {
      console.error(`Invoke photoViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
    })
  }

  /**
   * 识别文本
   */
  recognizeAddress(): void {
    this.clearHistoryData();
    // 当未输入时，默认使用占位文字进行识别
    if (!this.recognizeText) {
      this.recognizeText = CommonConstants.DEFAULT_TEXT;
    }
    loading($r('app.string.addressrecognize_recognize_text')).then((loadingId) => {
      this.loadingId = loadingId;
      this.doEntityRecognition();
    });
  }

  /**
   * 清除历史识别数据
   */
  clearHistoryData() {
    this.name = '';
    this.phone = '';
    this.address = '';
    this.myTagList = MOCK_TAG_DATA;
    this.isDefault = false;
  }

  build() {
    Column() {
      TitleBar({ isShowPanel: $isShowPanel })
        .height($r('app.integer.addressrecognize_title_bar_height'))
      List() {
        ForEach(this.myAddressList, (item: Address) => {
          AddressItem({ item: item })
        }, (_item: Address, index: number) => index.toString())
      }
      .width($r('app.string.addressrecognize_width_percent_full'))
      .height($r('app.string.addressrecognize_width_percent_full'))
      .padding({
        left: $r('app.integer.addressrecognize_length_twenty'),
        right: $r('app.integer.addressrecognize_length_twenty')
      })
    }
    .width($r('app.string.addressrecognize_width_percent_full'))
    .height($r('app.string.addressrecognize_width_percent_full'))
    .bindSheet($$this.isShowPanel, this.addressPanel())
  }

  @Builder
  addressPanel() {
    Column() {
      Column({ space: CommonConstants.SPACE_GAP_24 }) {
        //标题行
        Row() {
          Text($r('app.string.addressrecognize_page_title'))
            .width($r('app.string.addressrecognize_width_percent_full'))
            .fontSize($r('app.integer.addressrecognize_font_size_16'))
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Medium)
        }
        .width($r('app.string.addressrecognize_width_percent_full'))
        .height($r('app.integer.addressrecognize_title_height'))
        .backgroundColor(Color.White)

        // 输入、识别地址
        Column({ space: CommonConstants.SPACE_GAP_8 }) {
          // subtitle
          Row({ space: CommonConstants.SPACE_GAP_4 }) {
            Image($r('app.media.ic_public_text'))
              .fillColor($r('app.color.addressrecognize_orange'))
              .width($r('app.integer.addressrecognize_icon_size_lg'))
              .aspectRatio(1)
            Text($r('app.string.addressrecognize_copy'))
              .fontSize($r('app.integer.addressrecognize_font_size_12'))
              .fontColor($r('app.color.addressrecognize_orange'))
          }
          .width($r('app.string.addressrecognize_width_percent_full'))

          Column() {
            TextArea({ text: this.recognizeText, placeholder: $r('app.string.addressrecognize_address_placeholder') })
              .id("addressTextArea")
              .placeholderFont({ size: $r('app.integer.addressrecognize_font_size_12') })
              .fontSize($r('app.integer.addressrecognize_font_size_12'))
              .maxLength(CommonConstants.ADDRESS_MAX_LENGTH)
              .height($r('app.integer.addressrecognize_address_text_area_height'))
              .width($r('app.string.addressrecognize_width_percent_full'))
              .padding($r('app.integer.addressrecognize_padding_6'))
              .backgroundColor(Color.White)
              .onChange((value: string) => {
                this.recognizeText = value;
              })

            Row() {
              Button() {
                Row({ space: CommonConstants.SPACE_GAP_2 }) {
                  Image($r('app.media.ic_public_camera'))
                    .width($r('app.integer.addressrecognize_icon_size_md'))
                    .aspectRatio(1)
                  Text($r('app.string.addressrecognize_recognize_image_button'))
                    .fontSize($r('app.integer.addressrecognize_font_size_12'))
                    .fontColor(Color.Black)
                }
                .padding({
                  left: $r('app.integer.addressrecognize_padding_6'),
                  right: $r('app.integer.addressrecognize_padding_6')
                })
                .height($r('app.integer.addressrecognize_recognize_button_height'))

              }
              .id("btnImageSelect")
              .type(ButtonType.Normal)
              .backgroundColor($r('app.color.addressrecognize_secondary'))
              .borderColor($r('app.color.addressrecognize_recognize_background'))
              .onClick(() => {
                this.showMenu = true;
              })
              .borderWidth(CommonConstants.MIN_BORDER_WIDTH)
              .borderRadius($r('app.integer.addressrecognize_border_radius_sm'))
              .bindSheet($$this.showMenu, this.builderMenus(), {
                height: $r('app.integer.addressrecognize_bind_sheet_height'),
                backgroundColor: Color.White,
                showClose: false
              })

              Button($r('app.string.addressrecognize_transfer_address_button'))
                .id("btnRecognizeToAddress")
                .height($r('app.integer.addressrecognize_recognize_button_height'))
                .fontSize($r('app.integer.addressrecognize_font_size_12'))
                .type(ButtonType.Normal)
                .fontColor(Color.White)
                .backgroundColor($r('app.color.addressrecognize_orange'))
                .borderRadius($r('app.integer.addressrecognize_border_radius_sm'))
                .onClick(() => {
                  this.recognizeAddress();
                })
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width($r('app.string.addressrecognize_width_percent_full'))
          }
          .borderRadius($r('app.integer.addressrecognize_border_radius_md'))
          .borderWidth(1)
          .borderColor($r('app.color.addressrecognize_orange'))
          .padding($r('app.integer.addressrecognize_padding_12'))
        }

        // 地址详情
        Column() {
          Column() {
            UserInfoTextInput({
              componentId: "inputName",
              text: this.name,
              contentType: ContentType.PERSON_FULL_NAME,
              label: $r('app.string.addressrecognize_input_placeholder_name'),
              index: 0
            })
            Divider().height(CommonConstants.DIVIDER_HEIGHT).color($r('app.color.addressrecognize_divider_color'));
          }

          Column() {
            UserInfoTextInput({
              componentId: "inputPhone",
              text: this.phone,
              contentType: ContentType.PHONE_NUMBER,
              label: $r('app.string.addressrecognize_input_placeholder_tel'),
              index: 1
            })
            Divider().height(CommonConstants.DIVIDER_HEIGHT).color($r('app.color.addressrecognize_divider_color'));
          }

          Column() {
            UserInfoTextInput({
              componentId: "inputAddress",
              text: this.address,
              contentType: ContentType.FORMAT_ADDRESS,
              label: $r('app.string.addressrecognize_input_placeholder_address'),
              index: 2
            })
            Divider().height(CommonConstants.DIVIDER_HEIGHT).color($r('app.color.addressrecognize_divider_color'));
          }

          //地址标签
          Column() {
            Row() {
              Text($r('app.string.addressrecognize_tag'))
                .fontSize($r('app.integer.addressrecognize_font_size_14'))
            }
            .width($r('app.string.addressrecognize_width_percent_full'))
            .justifyContent(FlexAlign.Start)
            .padding({ left: $r('app.integer.addressrecognize_padding_12') })

            Row({ space: CommonConstants.SPACE_GAP_10 }) {
              ForEach(this.myTagList, (item: Tag, index: number) => {
                TagText({
                  tagInfo: item
                })
                  .onClick(() => {
                    this.selectTagIndex = index;
                    item.fontColor = $r('app.color.addressrecognize_orange');
                    item.bgColor = $r('app.color.addressrecognize_tag_bg');
                    this.myTagList.forEach((tag, i) => {
                      if (i !== index) {
                        tag.bgColor = $r('app.color.addressrecognize_secondary');
                        tag.fontColor = $r('app.color.addressrecognize_default_fon_color');
                      }
                    })
                  })
              }, (_item: Tag) => _item.label)

            }
            .width($r('app.string.addressrecognize_width_percent_full'))
            .margin({ top: $r('app.integer.addressrecognize_length_ten') })
            .padding({ left: $r('app.integer.addressrecognize_padding_12') })
            .justifyContent(FlexAlign.Start)

            //默认地址
            Row() {
              Text($r('app.string.addressrecognize_default_address'))
              Checkbox({
                name: 'checkbox1',
                group: 'checkboxGroup'
              })
                .select(this.isDefault)
                .selectedColor(0xed6f21)
                .shape(CheckBoxShape.CIRCLE)
                .onChange((isChecked: boolean) => {
                  this.isDefault = isChecked;
                })
            }
            .width($r('app.string.addressrecognize_width_percent_full'))
            .margin({ top: $r('app.integer.addressrecognize_length_ten') })
            .padding({ left: $r('app.integer.addressrecognize_padding_12') })
            .justifyContent(FlexAlign.Start)

            Divider()
              .height(CommonConstants.DIVIDER_HEIGHT)
              .color($r('app.color.addressrecognize_divider_color'))
              .margin({ top: $r('app.integer.addressrecognize_length_ten') })
          }
          .height($r('app.integer.addressrecognize_tag_height'))
          .padding({
            top: $r('app.integer.addressrecognize_length_ten'),
          })
        }
        .width($r('app.string.addressrecognize_width_percent_full'))
        .borderRadius($r('app.integer.addressrecognize_length_ten'))
        .backgroundColor(Color.White)
      }
      .height($r('app.string.addressrecognize_size_percent_eighty'))

      Blank()

      // 底部
      Column() {
        // 保存按钮
        Row() {
          Button($r('app.string.addressrecognize_ok_button'))
            .id("btnSaveAddress")
            .width($r('app.integer.addressrecognize_bottom_button_width'))
            .backgroundColor(Color.Red)
            .onClick(() => {
              this.saveAddress();
            })
        }
        .width($r('app.string.addressrecognize_width_percent_full'))
        .height($r('app.integer.addressrecognize_bottom_row_height'))
        .backgroundColor(Color.White)
        .margin({ top: $r('app.integer.addressrecognize_length_twenty') })
        .justifyContent(FlexAlign.Center)
      }
      .justifyContent(FlexAlign.End)
    }
    .padding({
      left: $r('app.integer.addressrecognize_padding_24'),
      right: $r('app.integer.addressrecognize_padding_24'),
      bottom: $r('app.integer.addressrecognize_padding_24')
    })
    .backgroundColor(Color.White)
    .height($r('app.string.addressrecognize_width_percent_full'))
  }
}

@Component
struct TagText {
  @ObjectLink tagInfo: Tag;

  build() {
    Text(this.tagInfo.label)
      .fontSize(14)
      .backgroundColor(this.tagInfo.bgColor)
      .fontColor(this.tagInfo.fontColor)
      .borderRadius(7)
      .padding({
        left: 12,
        right: 12,
        top: 7,
        bottom: 7
      })
  }
}

@Component
struct AddressItem {
  @ObjectLink item: Address;

  build() {
    ListItem() {
      Column() {
        Row() {
          Text(this.item.address)
            .fontSize($r('app.integer.addressrecognize_font_size_14'))
          Image($r('app.media.ic_public_edit'))
            .width($r('app.integer.addressrecognize_icon_size_lg'))
            .aspectRatio(1)
            .onClick(() => {
              promptAction.showToast({ message: $r('app.string.addressrecognize_undeveloped_feature') });
            })
        }
        .width($r('app.string.addressrecognize_width_percent_full'))
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Text(this.item.name)
            .fontSize($r('app.integer.addressrecognize_font_size_14'))
          Text(this.item.phone)
            .fontSize($r('app.integer.addressrecognize_font_size_14'))
            .margin({ left: $r('app.integer.addressrecognize_length_ten') })
          Text(this.item.tag)
            .fontSize($r('app.integer.addressrecognize_font_size_14'))
            .fontColor(Color.Red)
            .backgroundColor(Color.Pink)
            .margin({ left: $r('app.integer.addressrecognize_length_ten') })
            .padding({
              top: $r('app.integer.addressrecognize_tag_padding'),
              bottom: $r('app.integer.addressrecognize_tag_padding'),
              left: $r('app.integer.addressrecognize_length_five'),
              right: $r('app.integer.addressrecognize_length_five')
            })
            .borderRadius($r('app.integer.addressrecognize_tag_radius'))
            .visibility(this.item.tag ? Visibility.Visible : Visibility.Hidden)
          Text($r('app.string.addressrecognize_default'))
            .fontSize($r('app.integer.addressrecognize_font_size_14'))
            .fontColor(Color.Red)
            .backgroundColor(Color.Pink)
            .margin({ left: $r('app.integer.addressrecognize_length_ten') })
            .padding({
              top: $r('app.integer.addressrecognize_tag_padding'),
              bottom: $r('app.integer.addressrecognize_tag_padding'),
              left: $r('app.integer.addressrecognize_length_five'),
              right: $r('app.integer.addressrecognize_length_five')
            })
            .borderRadius($r('app.integer.addressrecognize_tag_radius'))
            .visibility(this.item.defaultFlag ? Visibility.Visible : Visibility.Hidden)
        }
        .width($r('app.string.addressrecognize_width_percent_full'))
        .margin({ top: $r('app.integer.addressrecognize_length_seven') })
        .justifyContent(FlexAlign.Start)

        Divider()
          .width($r('app.string.addressrecognize_width_percent_full'))
          .margin({ top: $r('app.integer.addressrecognize_length_fifteen') })
      }
      .width($r('app.string.addressrecognize_width_percent_full'))
      .height($r('app.integer.addressrecognize_item_height'))
      .margin({ top: 10 })
    }
  }
}

@Component
struct UserInfoTextInput {
  componentId: string = "";
  @Link text: string;
  contentType: ContentType | undefined = undefined;
  label: Resource | undefined = undefined;
  index: number = -1;
  @State scaleTimes: number = 1;
  @State currentIndex: number = -1;

  build() {
    Stack({ alignContent: Alignment.Center }) {
      TextInput({ text: this.text })
        .id(this.componentId)
        .width($r('app.string.addressrecognize_width_percent_full'))
        .backgroundColor(Color.White)
        .contentType(this.contentType)
        .padding({ left: $r('app.integer.addressrecognize_padding_12'), top: 0, bottom: 0 })
        .selectionMenuHidden(true)
        .onChange((value: string) => {
          this.text = value;
          if (value === '') {
            this.scaleTimes = 1;
          } else {
            this.scaleTimes = 0.75;
          }
        })
        .onFocus(() => {
          this.scaleTimes = 0.75;
          this.currentIndex = this.index;
        })
        .onBlur(() => {
          if (this.text === '') {
            this.scaleTimes = 1;
          }
        })
      Text() {
        Span('*')
          .fontColor($r('app.color.addressrecognize_orange'))
          .baselineOffset(new LengthMetrics(-2, LengthUnit.VP))
        Span(this.label)
          .baselineOffset(new LengthMetrics(0, LengthUnit.VP))
      }
      .scale(this.index === this.currentIndex || this.text !== '' ? {
        x: this.scaleTimes,
        y: this.scaleTimes,
        centerX: 0,
        centerY: -80
      } : {
        x: 1,
        y: 1,
        centerX: 0,
        centerY: -80
      })
      .animation({ duration: CommonConstants.ANIMATION_DURATION })
      .height(this.index === this.currentIndex ? $r('app.integer.addressrecognize_recognize_button_height') : undefined)
      .width($r('app.string.addressrecognize_width_percent_full'))
      .hitTestBehavior(HitTestMode.Transparent)
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .padding({ left: $r('app.integer.addressrecognize_padding_12') })
    }.height($r('app.integer.addressrecognize_textinput_height'))
  }
}

@Component
struct TitleBar {
  @Link isShowPanel: boolean

  @Builder
  labelText(id: string, src: Resource, desc: Resource, click?: () => void) {
    Row() {
      Image(src)
        .width($r('app.integer.addressrecognize_icon_size_lg'))
        .aspectRatio(1)
        .fillColor($r('app.color.addressrecognize_orange'))
      Text(desc)
        .fontSize($r('app.integer.addressrecognize_font_size_16'))
        .fontColor($r('app.color.addressrecognize_orange'))
    }
    .id(id)
    .onClick(click)
  }

  build() {
    Row({ space: CommonConstants.SPACE_GAP_12 }) {
      Text($r('app.string.addressrecognize_deliveryAddress'))
        .fontSize($r('app.integer.addressrecognize_font_size_16'))
        .fontWeight(FontWeight.Medium)
      Blank()
      this.labelText("toolbarManage", $r('app.media.ic_public_edit'), $r('app.string.addressrecognize_editAddress'),)
      this.labelText("toolbarAdd", $r('app.media.ic_public_add'), $r('app.string.addressrecognize_addAddress'), () => {
        this.isShowPanel = true;
      })
    }
    .width($r('app.string.addressrecognize_width_percent_full'))
    .padding({
      left: $r('app.integer.addressrecognize_padding_12'),
      right: $r('app.integer.addressrecognize_padding_12')
    })
  }
}
