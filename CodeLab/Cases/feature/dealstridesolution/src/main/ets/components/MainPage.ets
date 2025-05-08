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

import CameraService from '../model/CameraService';
import CameraServiceCrop from '../model/CameraServiceCrop';
import CameraServiceUint from '../model/CameraServiceUint';
import { ImageViewCrop } from './ImageViewCrop';
import { ImageViewUint } from './ImageViewUint';
import { PublishView, XComponentView } from './XComponentView';
import { abilityAccessCtrl, common, PermissionRequestResult } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import { Constants } from '../common/Constants';

const FONT_WEIGHT_CHANGE = 500; // 选中的字体宽度
const FONT_WEIGHT = 400; // 未选中的字体宽度
const OPACITY_CHANGE = 1; // 选中的透明度
const OPACITY = 0.6; // 未选中的透明度
const DIVIDER_OPACITY = 0; // 分割器未选中的透明度
const STROKE_WIDTH = 5; // 边框宽度
const BACKGROUND_COLOR = '#99000000'; // 改变的前的背景色
const BACKGROUND_COLOR_CHANGE = '#00000000'; // 改变的后的背景色

/**
 * 功能描述：本示例用于开发者在使用相机服务时，如果仅用于预览流展示，通常使用XComponent组件实现，如果需要获取每帧图像做二次处理（例如获取每帧图像完成二维码识别或人脸识别场景），可以通过ImageReceiver中imageArrival事件监听预览流每帧数据，解析图像内容。在解析图像内容时，如果未考虑stride，直接通过使用width*height读取图像内容去解析图像，会导致相机预览异常，从而出现相机预览花屏的现象。
 *
 * 推荐场景：使用相机服务用于处理图像时出现花屏情况。
 *
 * 核心组件：
 * 1.ImageViewCrop 使用cropSync方法裁剪掉多余的像素处理图像
 * 2.ImageViewUint 使用新建的width和height直接创建pixelMap处理图像
 * 3.XComponentView 使用createPreviewOutput创建预览输出对象直接输出图像
 *
 * 实现步骤：
 * 1.设置Tab组件当前选中index值。
 * @example
 * @State currentIndex: number = 0; // 当前tab组件的index值
 * 2.设置渲染相机的宽度。
 * @example
 * @State imageWidth: number = 1920; // 渲染相机的宽度
 * 3.设置渲染相机的高度。
 * @example
 * @State imageHeight: number = 1080; // 渲染相机的高度
 * 4.设置相机设备索引。
 * @example
 * @State cameraDeviceIndex: number = 0; // 相机设备索引
 * 5.构建Tabs组件的控制器。
 * @example
 *  private controller: TabsController = new TabsController(); // 构建Tabs组件的控制器
 * 6.构建使用cropSync方法裁剪掉多余的像素处理图像组件。
 * @example
 *  ImageViewCrop();
 * 6.构使用新建的width和height直接创建pixelMap处理图像组件。
 * @example
 *  ImageViewUint();
 * 7.构建使用createPreviewOutput创建预览输出对象直接输出图像组件。
 * @example
 *  XComponentView();
 * 8.构建在页面共享组件。
 * @example
 *  PublishView();
 *
 */
@Component
export struct DealStrideSolutionComponent {
  @State imageWidth: number = 1920; // 渲染相机的宽度
  @State imageHeight: number = 1080; // 渲染相机的高度
  @State currentIndex: number = 0; // 当前tab组件的index值
  @State cameraDeviceIndex: number = 0; // 相机设备索引
  @State isShow: boolean = false; // 方案说明是否展示
  private controller: TabsController = new TabsController(); // 构建Tabs组件的控制器

  async aboutToAppear(): Promise<void> {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let result = await atManager.requestPermissionsFromUser(getContext(this), ['ohos.permission.CAMERA'])
    if (result.authResults[0] === 0) {
      CameraServiceCrop.initCamera(this.cameraDeviceIndex);
    } else {
      promptAction.showDialog({
        title: $r('app.string.deal_stride_solution_prompt_title'),
        message: $r('app.string.deal_stride_solution_prompt_message')
      })
    }
  }

  aboutToDisappear(): void {
    CameraService.releaseCamera();
    CameraServiceUint.releaseCamera();
    CameraServiceCrop.releaseCamera();
  }

  build() {
    Column() {
      Stack() {
        Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
          TabContent() {
            Stack({ alignContent: Alignment.Top }) {
              this.textStyle($r('app.string.deal_stride_solution_image_view_crop_text'), Constants.CROP_SYNC_DES)
              /**
               * 使用cropSync方法裁剪掉多余的像素处理图像组件
               */
              ImageViewCrop()
                .zIndex(0)
              /**
               * 页面共享组件
               * imageWidth：组件宽度
               * imageHeight：组件高度
               * isShow：网格是否显示
               */
              PublishView({ imageWidth: this.imageWidth, imageHeight: this.imageHeight, isShow: this.isShow })
                .zIndex(1)
                .backgroundColor(this.isShow ? BACKGROUND_COLOR : BACKGROUND_COLOR_CHANGE)
            }

          }
          .tabBar(this.TabBuilder(0, $r('app.string.deal_stride_solution_image_view_crop')))

          TabContent() {
            Stack({ alignContent: Alignment.Top }) {
              this.textStyle($r('app.string.deal_stride_solution_image_view_uint_text'), Constants.UINT_ARRAY_DES)
              /**
               * 使用新建的width和height直接创建pixelMap处理图像组件
               */
              ImageViewUint()
                .zIndex(0)
              PublishView({ imageWidth: this.imageWidth, imageHeight: this.imageHeight, isShow: this.isShow })
                .zIndex(1)
                .backgroundColor(this.isShow ? BACKGROUND_COLOR : BACKGROUND_COLOR_CHANGE)
            }

          }.tabBar(this.TabBuilder(1, $r('app.string.deal_stride_solution_image_view_uint')))

          TabContent() {
            Stack({ alignContent: Alignment.Top }) {
              this.textStyle($r('app.string.deal_stride_solution_component_view_text'), Constants.X_COMPONENT_DES)
              /**
               * 使用createPreviewOutput创建预览输出对象直接输出图像组件
               */
              XComponentView()
              PublishView({ imageWidth: this.imageWidth, imageHeight: this.imageHeight, isShow: this.isShow })
                .zIndex(1)
                .backgroundColor(this.isShow ? BACKGROUND_COLOR : BACKGROUND_COLOR_CHANGE)
            }
          }.tabBar(this.TabBuilder(2, $r('app.string.deal_stride_solution_component_view')))

        }
        .barBackgroundColor(Color.Black)
        .barBackgroundBlurStyle(BlurStyle.Thin)
        .onChange((index: number) => {
          this.currentIndex = index;
        })
        .zIndex(2)
        .width(px2vp(this.imageHeight))
      }
      .width(px2vp(this.imageHeight))
      .height(px2vp(this.imageWidth))

    }
    .justifyContent(FlexAlign.Center)
    .height($r('app.string.deal_stride_solution_all_percentage'))
    .width($r('app.string.deal_stride_solution_all_percentage'))
    .id('DealStrideSolutionComponent')
  }

  @Builder
  TabBuilder(index: number, name: string | Resource) {
    Column() {
      Text(name)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontSize($r('app.integer.deal_stride_solution_tab_font'))
        .fontColor(Color.White)
        .lineHeight($r('app.integer.deal_stride_solution_tab_line'))
        .fontWeight(this.currentIndex === index ? FONT_WEIGHT_CHANGE : FONT_WEIGHT)
        .margin({ bottom: $r('app.integer.deal_stride_solution_tab_margin') })
        .opacity(this.currentIndex === index ? OPACITY_CHANGE : OPACITY)
        .textOverflow({ overflow: TextOverflow.MARQUEE })
      Divider()
        .strokeWidth(STROKE_WIDTH)
        .width($r('app.integer.deal_stride_solution_tab_divider_width'))
        .borderRadius($r('app.integer.deal_stride_solution_tab_divider_width'))
        .clip(true)
        .color(Color.Red)
        .opacity(this.currentIndex === index ? OPACITY_CHANGE : DIVIDER_OPACITY)
        .margin({ bottom: $r('app.integer.deal_stride_solution_tab_divider_margin') })
    }
  }

  @Builder
  textStyle(text: ResourceStr, description: ResourceStr) {
    Column() {
      Row() {
        Blank()
          .width($r('app.integer.deal_stride_solution_tab_text_blank'))
        Text(text)
          .fontSize($r('app.integer.deal_stride_solution_tab_text'))
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .fontStyle(FontStyle.Italic)
          .fontWeight(FontWeight.Bold)
        Text($r('app.string.deal_stride_solution_tab_description'))
          .width($r('app.integer.deal_stride_solution_tab_description_width'))
          .fontColor(Color.White)
          .borderWidth($r('app.integer.deal_stride_solution_tab_description_border_width'))
          .borderColor(Color.White)
          .borderRadius($r('app.integer.deal_stride_solution_tab_description_border_radius'))
          .padding($r('app.integer.deal_stride_solution_tab_description_padding'))
          .margin($r('app.integer.deal_stride_solution_tab_description_margin'))
          .onClick(() => {
            this.isShow = !this.isShow;
          })
      }
      .width($r('app.string.deal_stride_solution_all_percentage'))
      .justifyContent(FlexAlign.SpaceBetween)

      if (this.isShow) {
        Text(description)
          .fontColor(Color.White)
          .margin($r('app.integer.deal_stride_solution_tab_description_margin'))
          .fontSize($r('app.integer.deal_stride_solution_tab_description_font'))
          .lineHeight($r('app.integer.deal_stride_solution_tab_description_line'))
      }
    }
    .zIndex(2)
  }
}