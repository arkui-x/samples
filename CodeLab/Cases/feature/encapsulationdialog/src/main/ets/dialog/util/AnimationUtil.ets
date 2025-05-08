/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

export class AnimationUtil {
  /**
   * 顶部弹出动画
   * @param duration 动画时间
   * @returns
   */
  static transitionFromUp(duration: number = 200): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({ duration: duration }).combine(
        TransitionEffect.move(TransitionEdge.TOP).animation({ duration: duration })),
      TransitionEffect.OPACITY.animation({ delay: duration, duration: duration }).combine(
        TransitionEffect.move(TransitionEdge.TOP).animation({ duration: duration }))
    )
  }

  /**
   * 底部弹出动画
   * @param duration 动画时间
   * @returns
   */
  static transitionFromDown(duration: number = 200): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({ duration: duration }).combine(
        TransitionEffect.move(TransitionEdge.BOTTOM).animation({ duration: duration })),
      TransitionEffect.OPACITY.animation({ delay: duration, duration: duration }).combine(
        TransitionEffect.move(TransitionEdge.BOTTOM).animation({ duration: duration }))
    )
  }

  /**
   * 左侧弹出动画
   * @param duration 动画时间
   * @returns
   */
  static transitionFromLeft(duration: number = 200): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({ duration: duration }).combine(
        TransitionEffect.move(TransitionEdge.START).animation({ duration: duration })),
      TransitionEffect.OPACITY.animation({ delay: duration, duration: duration }).combine(
        TransitionEffect.move(TransitionEdge.START).animation({ duration: duration }))
    )
  }


  /**
   * 右侧弹出动画
   * @param duration 动画时间
   * @returns
   */
  static transitionFromRight(duration: number = 200): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({ duration: duration }).combine(
        TransitionEffect.move(TransitionEdge.END).animation({ duration: duration })),
      TransitionEffect.OPACITY.animation({ delay: duration, duration: duration }).combine(
        TransitionEffect.move(TransitionEdge.END).animation({ duration: duration }))
    )
  }

  /**
   * 中间弹出动画
   * @param duration 动画时间
   * @returns
   */
  static transitionFromCenter(duration: number = 200): TransitionEffect {
    return TransitionEffect.OPACITY.animation({ duration: duration });
  }
}