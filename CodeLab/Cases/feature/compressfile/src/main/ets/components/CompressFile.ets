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

import { CompressFileComponent } from './CompressFileComponent';
import { fileIo as fs } from '@kit.CoreFileKit';
import { logger } from '../utils/Logger';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'compressFileComponent';
const LINEAR_GRADIENT_START = 0; // 颜色渐变起始位置
const LINEAR_GRADIENT_END = 1; // 颜色渐变结束位置

/**
 * 功能描述：本示例主要介绍在worker子线程中使用@ohos.zlib模块提供的zlib.compressFile接口对沙箱目录中的文件进行压缩操作，压缩成功后将压缩包所在路径返回主线程，获取压缩文件列表。
 *
 * 推荐场景：文件管理中压缩文件时使用
 *
 * 核心组件：
 * 1.CompressFileComponent: 向子线程发送信息，进行压缩
 *
 * 实现步骤：
 * 1. 目录名称配置：指定压缩成功后压缩包路径
 * @example
 * @State compressZipDir: string = 'bundlefile/compress_file.zip';
 * 2. 目录名称配置：指定待压缩文件在rawfile下和应用沙箱目录下（https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/app-sandbox-directory-V5）所处目录名
 * @example
 * @State beCompressFileDir: string = 'compressfile';
 * 3. 数据存放配置：压缩后的压缩包存放变量
 * @example
 * @State compressBundleName: string = '';
 * 4.构建压缩组件
 * @example
 * CompressFileComponent({
 compressBundleName: this.compressBundleName,
 beCompressFileDir: this.beCompressFileDir,
 compressZipPath: this.compressZipDir,
 })
 */
@Component
export struct CompressFileViewComponent {
  @State beCompressFiles: Array<string> = []; // rawfile下所有待压缩文件
  @State compressBundleName: string = ''; // 压缩成功后压缩包名字
  @State compressZipDir: string = 'bundlefile/compress_file.zip'; // 压缩成功后压缩包文件路径
  @State beCompressFileDir: string = 'compressfile'; // 待压缩文件所在目录名
  private context: Context = getContext(this);

  aboutToAppear(): void {
    this.beCompressFiles = this.context.resourceManager.getRawFileListSync(this.beCompressFileDir);
  }

  build() {
    Column() {
      Row() {
        Column() {
          Text($r("app.string.compress_file_message"))
            .fontColor($r('app.color.compress_file_message_color'))
            .fontWeight(FontWeight.Bolder)
            .fontSize($r('app.string.compress_file_message_font_size'))
          Text($r('app.string.compress_file_title_message'))
            .fontColor($r('app.color.compress_file_message_color'))
        }
        .width($r('app.string.compress_file_title_message_container_width'))
        .alignItems(HorizontalAlign.Start)

        Image($r('app.media.compress_file_ic_files_compress'))
          .width($r('app.string.compress_file_top_bar_icon_width'))
          .height($r('app.string.compress_file_top_bar_icon_height'))
      }
      .padding($r('app.string.compress_file_top_bar_padding_size'))
      .width($r('app.string.compress_file_container_width'))
      .height($r('app.string.compress_file_top_bar_container_height'))
      .borderRadius($r('app.string.compress_file_top_bar_container_border_radius'))
      .justifyContent(FlexAlign.SpaceBetween)
      .linearGradient({
        direction: GradientDirection.Top, // 渐变方向
        repeating: true, // 渐变颜色是否重复
        colors: [[$r('app.color.compress_file_linear_gradient_start'), LINEAR_GRADIENT_START],
          [$r('app.color.compress_file_linear_gradient_end'), LINEAR_GRADIENT_END]] // 数组末尾元素占比小于1时满足重复着色效果
      })

      Row() {
        Text($r('app.string.compress_file_be_compress_title_message'))
          .fontWeight(FontWeight.Bold)
          .fontSize($r('app.string.compress_file_title_font_size'))
          .fontColor($r('app.color.compress_file_message_color'))
        /**
         * 构建压缩组件
         * compressBundleName: 压缩成功后压缩包的名字
         * beCompressFileDir: 待压缩文件所在目录名
         * compressZipPath: 压缩成功后压缩包路径
         */
        CompressFileComponent({
          compressBundleName: this.compressBundleName,
          beCompressFileDir: this.beCompressFileDir,
          compressZipPath: this.compressZipDir,
        })
      }
      .borderRadius($r('app.string.compress_file_top_bar_container_border_radius'))
      .width($r('app.string.compress_file_container_width'))
      .backgroundColor($r('app.color.compress_file_title_bar_background_color'))
      .padding($r('app.string.compress_file_title_padding_size'))
      .margin($r('app.string.compress_file_title_margin_size'))
      .justifyContent(FlexAlign.SpaceBetween)

      CompressFileList({ fileNames: this.beCompressFiles, iconName: 'app.media.compressed_file_ic_files_documents' })

      Text($r('app.string.compress_file_compress_result_message'))
        .fontWeight(FontWeight.Bold)
        .fontSize($r('app.string.compress_file_title_font_size'))
        .textAlign(TextAlign.Start)
        .width($r('app.string.compress_file_container_width'))
        .padding($r('app.string.compress_file_title_padding_size'))
        .fontWeight(FontWeight.Bold)
        .backgroundColor($r('app.color.compress_file_title_bar_background_color'))
        .fontColor($r('app.color.compress_file_message_color'))
        .borderRadius($r('app.string.compress_file_top_bar_container_border_radius'))

      if (this.compressBundleName) {
        Row() {
          Image($r('app.media.compress_file_ic_files_compress'))
            .width($r('app.string.compress_file_icon_width'))
            .height($r('app.string.compress_file_icon_height'))
            .margin({ right: $r('app.string.compress_file_icon_margin_size') })
          Text(this.compressBundleName)
            .fontSize($r('app.string.compress_file_name_font_size'))
        }
        .id('compressZip')
        .justifyContent(FlexAlign.Start)
        .width($r('app.string.compress_file_container_width'))
        .height($r('app.string.compress_file_list_item_height'))
      }
    }
    .padding($r('app.string.compress_file_container_padding_size'))
  }
}

/**
 * 待压缩文件和压缩成功的压缩包
 */
@Component
struct CompressFileList {
  // 文件列表
  @Prop fileNames: Array<string> = [];
  // 文件图标
  @State iconName: string = '';

  build() {
    Column() {
      List() {
        // TODO:性能知识点：此处数据量较小，使用ForEach加载数据，如需动态加载数据可以使用LazyForEach遍历数据，降低内存占用和渲染开销。https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-rendering-control-lazyforeach-V5
        ForEach(this.fileNames, (item: string, index: number) => {
          ListItem() {
            Row() {
              Image($r(this.iconName))
                .width($r('app.string.compress_file_icon_width'))
                .height($r('app.string.compress_file_icon_height'))
                .margin({ right: $r('app.string.compress_file_icon_margin_size') })
              Text(item)
                .fontSize($r('app.string.compress_file_name_font_size'))
            }
            .height($r('app.string.compress_file_list_item_height'))
          }
        }, (item: string, index: number) => item)
      }
      .width($r('app.string.compress_file_container_width'))
      .height($r('app.string.compress_file_list_height_size'))
      .divider({ strokeWidth: 1, color: $r('app.color.compress_file_list_item_divider_color') })
    }
    .width($r('app.string.compress_file_container_width'))
  }
}