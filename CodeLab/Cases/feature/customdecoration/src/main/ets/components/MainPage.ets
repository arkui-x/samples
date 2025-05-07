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

import { AutoAddInspector } from './AutoAddInspector';
import { inspector } from '@kit.ArkUI';

/**
 * 实现思路：
 * 1. 添加自定义装饰器，并设置需要添加的方法名和绑定的组件ID
 * 2. 编译工程，自动添加代码
 */
@AutoAddInspector({
  onDraw: 'onDraw',
  onLayout: 'onLayout',
  offDraw: 'offDraw',
  offLayout: 'offLayout',
  bindId: 'text'
})
@Component
export struct MainPage {
  build() {
    Column() {
      Text("Hello World")
        .id('text')
    }
  }

  textListener: inspector.ComponentObserver = inspector.createComponentObserver('text');

  aboutToAppear(): void {
    this.textListener.on('draw', this.onDraw);
    this.textListener.on('layout', this.onLayout);
  }

  onDraw(): void {
    console.log('This is onDraw');
  }

  onLayout(): void {
    console.log('This is onLayout');
  }

  offDraw(): void {
    console.log('This is offDraw');
  }

  offLayout(): void {
    console.log('This is offLayout');
  }

}