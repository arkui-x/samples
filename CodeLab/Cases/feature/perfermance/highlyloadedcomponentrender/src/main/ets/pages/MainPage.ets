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
import { AppRouter, DynamicsRouter } from 'routermodule';

@AppRouter({ name: "highlyloadedcomponentrender/MainPage" })
@Component
export struct MainPage {
  build() {
    Column({space:30}) {

      Button('普通列表数据加载')
        .width('90%')
        .backgroundColor(Color.Blue)
        .fontColor(Color.White)
        .onClick(()=>{
          DynamicsRouter.pushUri('highlyloadedcomponentrender/ReusePage');
        })

      Button('通过DisplaySync优化列表数据加载')
        .width('90%')
        .backgroundColor(Color.Blue)
        .fontColor(Color.White)
        .onClick(()=>{
          DynamicsRouter.pushUri('highlyloadedcomponentrender/ReuseFramePage');
        })

    }
    .alignItems(HorizontalAlign.Center)
    .padding({
      top: 20
    })
  }
}