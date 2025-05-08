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

import { CommonConstants } from '../common/CommonConstants';
import { ArticleLoadingSkeleton } from './ArticleLoadingSkeleton';
import { SkeletonData, SkeletonType } from '../common/CommonConstants';

@Component
export struct LoadingView {
  @State columnBgColor: Color = Color.Gray;
  @State listOpacity: number = 1;

  // 骨架屏的闪烁动画
  startAnimation(): void {
    // TODO: 知识点：显式动画animateTo(value: AnimateParam, event: () => void): void接口可以给状态变化添加过渡动画。同属性动画，布局类改变宽高的动画，内容都是直接到终点状态。
    animateTo(CommonConstants.SKELETON_ANIMATION, () => {
      // 动态修改骨架屏的透明度
      this.listOpacity = CommonConstants.HALF_OPACITY;
    });
  }

  build() {
    Row() {
      List({ space: CommonConstants.SPACE_12 }) {
        ForEach(SkeletonData, (item: SkeletonType) => {
          ListItem() {
            // 骨架屏布局
            ArticleLoadingSkeleton({ isMine: item.isMine })
          }
        })
      }
      .id('skeleton_diagram')
      .layoutWeight(CommonConstants.LAYOUT_WEIGHT)
      .scrollBar(BarState.Off)
      .padding({
        left: $r("app.float.ske_md_padding_margin"),
        right: $r("app.float.ske_md_padding_margin")
      })
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .alignItems(VerticalAlign.Top)
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
    .opacity(this.listOpacity)
    // 组件挂载显示后触发此回调，调用动画接口给组件添加动画。
    .onAppear(() => {
      this.startAnimation();
    })
  }
}