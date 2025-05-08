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

import { SelectPictures } from './SelectPictures';
import { SaveNetWorkPictures } from './SaveNetWorkPictures';
import { SavePictureFromWeb } from './SavePictureFromWeb';

/**
 * 使用图片选择和下载保存样例
 *
 * 核心组件:
 * 1. SaveNetWorkPictures
 * 2. SelectPictures
 * 3. SavePictureFromWeb
 *
 * 实现步骤：
 * 1. 通过photoViewPicker.select()拉起图库界面，用户可以预览并选择一个或多个文件，即可实现拉起手机相册并进行图片的预览与选择
 * 2. 通过http中request方法获取在线图片数据，使用createPixelMap方法将获取到的图片数据转换成pixelmap展示到页面中，将图片保存到图库或者用户选择的路径
 * 3. 通过Web.onContextMenuShow长按图片获取图片链接，通过request.download将图片下载到沙箱路径，使用phAccessHelper.showAssetsCreationDialog获取将图片写入相册的权限，
 * 将沙箱路径下的图片转为buffer，写入路径
 */

@Component
export struct PictureManagerComponent {
  @State currentIndex: number = 0;
  private controller: TabsController = new TabsController();

  @Builder
  TabBuilder(index: number, name: string | Resource) {
    Column() {
      Text(name)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontSize(16)
        .fontColor(this.currentIndex === index ? '#007DFF' : '#182431')
        .lineHeight(30)
        .fontWeight(this.currentIndex === index ? 500 : 400)
        .margin({ bottom: 7 })
        .opacity(this.currentIndex === index ? 1 : 0.6)
        .textOverflow({ overflow: TextOverflow.MARQUEE })
      Divider()
        .strokeWidth(2)
        .width(48)
        .borderRadius(1)
        .color('#007DFF')
        .opacity(this.currentIndex === index ? 1 : 0)
        .margin({ bottom: 8 })
    }
  }

  build() {
    Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
      TabContent() {
        // 下载网络图片并保存到图库或用户指定文件
        SaveNetWorkPictures();
      }
      .tabBar(this.TabBuilder(0, "下载保存图片"))

      TabContent() {
        // 图片选择模块
        SelectPictures();
      }.tabBar(this.TabBuilder(1, "选择图片"))

      TabContent() {
        // 从web页面下载保存图片
        SavePictureFromWeb();
      }.tabBar(this.TabBuilder(2, "从web页面下载保存图片"))
      .id('downloadFromWeb')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])

    }
    .onChange((index: number) => {
      this.currentIndex = index
    })
    .barWidth($r('app.string.photo_pick_and_save_tab_width'))
    .barHeight($r('app.string.photo_pick_and_save_tab_height'))
  }
}