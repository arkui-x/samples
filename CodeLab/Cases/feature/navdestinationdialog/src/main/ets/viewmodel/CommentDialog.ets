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
import { logger } from 'utils';
import { Comment } from './Comment';
import Consts from '../common/Constants';
import { emitter } from '@kit.BasicServicesKit';

const TAG: string = Consts.DIALOG_PAGE_TAG;

@AppRouter({ name: "navdestinationdialog/CommentDialog" })
@Component
export struct CommentDialog {
  @LocalStorageProp('ndPageHeight') ndPageHeight: number = 0;
  @LocalStorageLink('ndDialogHeight') ndDialogHeight: number = 0;
  /** 初始（默认）的评论弹窗高度 */
  private initDialogHeight: number = 0;
  /** 是否允许手势滑动，当评论列表滑动时，不允许手势滑动 */
  @State isGesture: boolean = true;
  @State listScrollAble: boolean = true;

  aboutToAppear(): void {
    this.listenBackPress()
    this.initDialogHeight = this.ndPageHeight * Consts.COMMENT_DIALOG_SCALE;
    logger.info(TAG, `ndDialogHeight = ${this.ndDialogHeight}`);
  }

  aboutToDisappear(): void {
    // 关闭事件监听
    emitter.off(4);
  }

  listenBackPress() {
    let innerEvent: emitter.InnerEvent = {
      eventId: 4
    };
    // 收到eventId为4的事件后执行回调函数
    emitter.on(innerEvent, () => {
      animateTo({
        duration: Consts.COMMENT_DIALOG_CLOSE_DURATION,
        curve: Curve.FastOutLinearIn,
      }, () => {
        this.ndDialogHeight = 0;
      });
    });
  }

  build() {
    Column() {
      // 评论弹窗上部的蒙版，用于附加手势和确定评论弹窗高度
      Column()
        .width($r('app.string.navdialog_full_size'))
        .height(this.ndPageHeight - this.ndDialogHeight)
        .backgroundColor(Color.Transparent)
        .gesture(PanGesture({
          direction: PanDirection.Vertical,
          distance: Consts.COMMENT_PAN_GESTURE_DISTANCE
        })
          .onActionUpdate((event) => {
            if (this.ndDialogHeight <= 0) {
              return;
            }

            const curDialogHeight = this.initDialogHeight - event.offsetY;
            if (curDialogHeight < 0) {
              this.ndDialogHeight = 0;
            } else if (curDialogHeight <= this.initDialogHeight) {
              this.ndDialogHeight = curDialogHeight;
            }
          })
          .onActionEnd(() => {
            if (this.ndDialogHeight < Consts.COMMENT_DIALOG_MIN_HEIGHT) {
              this.closeDialog();
            } else {
              this.recoveryDialog();
            }
          }))

      Column() {
        Comment({
          isGesture: this.isGesture,
          listScrollAble: this.listScrollAble,
          close: () => {
            this.closeDialog();
          }
        })
      }
      .width($r('app.string.navdialog_full_size'))
      .height(this.ndDialogHeight + Consts.SHOP_BAR_HEIGHT) // 提高弹窗的高度，用以覆盖底部商店栏
      .backgroundColor(Color.White)
      .transition(
        TransitionEffect
          .move(TransitionEdge.BOTTOM)// 动画时间要比上一个页面的动画快一点，避免出现空白衔接
          .animation({ duration: Consts.COMMENT_DIALOG_TRANS_DURATION, curve: Curve.FastOutSlowIn }))
      .borderRadius({
        topLeft: $r('app.integer.navdialog_comment_dialog_radius'),
        topRight: $r('app.integer.navdialog_comment_dialog_radius')
      })
      .parallelGesture(PanGesture({ direction: PanDirection.Vertical })
        .onActionUpdate((event) => {
          if (!this.isGesture || this.ndDialogHeight <= 0) {
            return;
          }
          // 计算当前弹窗的高度
          const curDialogHeight = this.initDialogHeight - event.offsetY;
          if (curDialogHeight < 0) {
            this.ndDialogHeight = 0;
          } else if (curDialogHeight <= this.initDialogHeight) {
            this.ndDialogHeight = curDialogHeight;
          }
        })
        .onActionEnd(() => {
          if (!this.isGesture && this.ndDialogHeight === this.initDialogHeight) {
            return;
          }
          if (this.ndDialogHeight < Consts.COMMENT_DIALOG_MIN_HEIGHT) {
            this.closeDialog();
          } else {
            this.recoveryDialog();
          }
          // 手势结束后，重新允许列表滚动
          this.listScrollAble = true;
        }), GestureMask.Normal)
    }
    .width($r('app.string.navdialog_full_size'))
    .height($r('app.string.navdialog_full_size'))
  }

  /**
   * 关闭评论弹窗的回调
   */
  closeDialog() {
    logger.info(TAG, `close this dialog.`);
    animateTo({
      duration: Consts.COMMENT_DIALOG_CLOSE_DURATION,
      curve: Curve.FastOutLinearIn,
      onFinish: () => {
        DynamicsRouter.popAppRouter();
      } }, () => {
        this.ndDialogHeight = 0;
      });
  }

  /**
   * 恢复评论弹窗的回调
   */
  recoveryDialog() {
    animateTo({
      duration: Consts.COMMENT_DIALOG_RECOVERY_TIME,
      curve: Curve.Ease
    }, () => {
      this.ndDialogHeight = this.initDialogHeight;
    })
  }
}
