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

import { PathShape } from '@kit.ArkUI';
import { TabItemSelectType } from '../../types/RaisedCircleTypes';
import { SURPLUSRADIUS } from '../../utils/CircleClass';

// TODO: 渲染选中时凸起圆
@Builder
export function TabsRaisedCircleSelect(TabItemSelectOptions: TabItemSelectType) {
  RelativeContainer() {
    // 选中时凸起的圆
    Column()
      .aspectRatio(1)
      .height(TabItemSelectOptions.chamfer.circleDiameter)
      .borderRadius(TabItemSelectOptions.chamfer.circleRadius)
      .borderWidth(TabItemSelectOptions.chamfer.circleDiameter * 0.1)
      .borderColor(TabItemSelectOptions.tabsBgColor)
      .radialGradient({
        center: [TabItemSelectOptions.chamfer.circleRadius, TabItemSelectOptions.chamfer.circleRadius],
        radius: TabItemSelectOptions.chamfer.circleRadius,
        colors: [[TabItemSelectOptions.tabsSelectBgColor,
          (TabItemSelectOptions.chamfer.circleDiameter - SURPLUSRADIUS) / TabItemSelectOptions.chamfer.circleDiameter],
          [Color.Transparent,
            (TabItemSelectOptions.chamfer.circleDiameter - SURPLUSRADIUS) /
            TabItemSelectOptions.chamfer.circleDiameter]]
      })
      .id(TabItemSelectOptions.selectBodyId)
    if (TabItemSelectOptions.chamfer) {
      // 凸起圆 左边 的圆滑过度
      // TODO：知识点：通过裁切+渐变色制作一个平滑的过渡
      Column()
        .width(TabItemSelectOptions.chamfer.chamferXY[0])
        .height(TabItemSelectOptions.chamfer.chamferXY[1])
        .radialGradient({
          center: [0, 0],
          radius: TabItemSelectOptions.chamfer.chamferRadius,
          colors: [[Color.Transparent, 0.0], [Color.Transparent, 1], [TabItemSelectOptions.tabsBgColor, 1]]
        })
        .clipShape(new PathShape({
          commands: `M0 0 L0 ${vp2px(TabItemSelectOptions.chamfer.chamferXY[1])}   L${vp2px(TabItemSelectOptions.chamfer.chamferXY[0])} ${vp2px(TabItemSelectOptions.chamfer.chamferXY[1])} Z`
        }))
        .zIndex(-1)
        .alignRules({
          'right': { 'anchor': TabItemSelectOptions.selectBodyId, 'align': HorizontalAlign.Center },
          "bottom": { 'anchor': TabItemSelectOptions.selectBodyId, 'align': VerticalAlign.Center }
        })
      // 凸起圆 右边 的圆滑过度
      // TODO：知识点：通过裁切+渐变色制作一个平滑的过渡
      Column()
        .width(TabItemSelectOptions.chamfer.chamferXY[0])
        .height(TabItemSelectOptions.chamfer.chamferXY[1])
        .radialGradient({
          center: [TabItemSelectOptions.chamfer.chamferXY[0], 0],
          radius: TabItemSelectOptions.chamfer.chamferRadius,
          colors: [[Color.Transparent, 0.0], [Color.Transparent, 1], [TabItemSelectOptions.tabsBgColor, 1]]
        })
        .clipShape(new PathShape({
          commands: `M0 ${vp2px(TabItemSelectOptions.chamfer.chamferXY[1])}  L${vp2px(TabItemSelectOptions.chamfer.chamferXY[0])} 0 L${vp2px(TabItemSelectOptions.chamfer.chamferXY[0])} ${vp2px(TabItemSelectOptions.chamfer.chamferXY[1])} Z`
        }))
        .zIndex(-1)
        .alignRules({
          'left': { 'anchor': TabItemSelectOptions.selectBodyId, 'align': HorizontalAlign.Center },
          "bottom": { 'anchor': TabItemSelectOptions.selectBodyId, 'align': VerticalAlign.Center }
        })
    }
  }
  .width("auto")
  .offset({
    x: -TabItemSelectOptions.chamfer.circleOffsetX,
    y: -TabItemSelectOptions.chamfer.circleOffsetY
  })
  .zIndex(-1)
  .alignRules({
    'left': {
      'anchor': `${TabItemSelectOptions.tabItemId}${TabItemSelectOptions.selectIndex}`,
      'align': HorizontalAlign.Center
    }
  })
}