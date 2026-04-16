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

import { MainPageComponent } from 'effectkit';
import PlatformView, { PlatformViewAttribute } from '@arkui-x.platformview';
import { deviceInfo } from '@kit.BasicServicesKit';
import { BuilderNode, NodeController, UIContext } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State title: string = 'PlatformView MapView'
  private osFullNameInfo: string = '';
  private controller: MyNodeController = new MyNodeController();
  private gaodeController: MyNodeController = new MyNodeController();

  aboutToAppear(): void {
    this.osFullNameInfo = deviceInfo.osFullName;
    if (this.osFullNameInfo.startsWith("OpenHarmony")) {
      import ('./harmonyOSPage').then(res => {
        this.controller.node = new BuilderNode(this.getUIContext());
        this.controller.node.build(res.MapComponentBuilder);
      })
      import ('./MapShowController').then(res => {
        this.gaodeController.node = new BuilderNode(this.getUIContext());
        this.gaodeController.node.build(res.MapGaodeComponentBuilder);
      })
    }
  }

  build() {
    Row() {
      Column() {
        MainPageComponent()
        if (this.osFullNameInfo.startsWith("OpenHarmony")) {
          NodeContainer(this.gaodeController).width('100%').height('100%')
        } else if (this.osFullNameInfo.startsWith("Android") ||
                   this.osFullNameInfo.startsWith("iOS") ||
                   this.osFullNameInfo.startsWith("iPadOS")) {
          PlatformView('MapView')
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

class MyNodeController extends NodeController {
  node?: BuilderNode<[]>;

  makeNode(uiContext: UIContext): FrameNode | null {
    return this.node?.getFrameNode() ?? null;
  }
}