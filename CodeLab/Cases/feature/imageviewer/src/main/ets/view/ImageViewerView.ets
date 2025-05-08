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


/**
 * 使用缩放图片组件样例
 *
 * 核心组件:
 * 1. ImageItemView
 *
 * 实现步骤:
 * 1. 使用matrix实现图片的缩放
 * 2. 使用offset实现组件的偏移
 * 3. 提前计算图片属性以便对组件属性进行设置
 * 4. Image.objectFile使用Cover以便图片能够超出其父组件显示（而不撑大父组件）——供增强需求：多张图片切换使用
 */

import { common } from '@kit.AbilityKit';
import { ImageViewerConstants } from '../constants/ImageViewerConstants';
import { CommonLazyDataSourceModel } from '../model/CommonLazyDataSourceModel';
import { ImageItemView } from './ImageItemView';

@Component
export struct ImageViewerViewComponent {
  @State isEnableSwipe: boolean = true;
  @Provide bgc: Color = Color.White;
  imageDataSource: CommonLazyDataSourceModel<string> = new CommonLazyDataSourceModel();
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  swipeController: SwiperController = new SwiperController();

  /**
   * 初始化数据源
   */
  aboutToAppear(): void {
    const resourceDir: string = this.context.resourceDir;
    this.imageDataSource.pushData(resourceDir + '/' + ImageViewerConstants.IMAGE_NAME);
  }

  build() {
    Swiper(this.swipeController) {
      // TODO：性能知识点：懒加载
      LazyForEach(this.imageDataSource, (item: string, index: number) => {
        ImageItemView({ imageUri: item, isEnableSwipe: this.isEnableSwipe })
          .width($r("app.string.imageviewer_image_item_width"))
          .height($r("app.string.imageviewer_image_item_height"))
      })
    }
    .onClick(() => {
      this.bgc = this.bgc === Color.White ? Color.Black : Color.White;
    })
    .width($r("app.string.imageviewer_full_size"))
    .height($r("app.string.imageviewer_full_size"))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .autoPlay(false)
    .disableSwipe(!this.isEnableSwipe)
    .loop(false)
    .indicator(false)
    .cachedCount(ImageViewerConstants.SWIPER_CACHE_COUNT)
  }
}