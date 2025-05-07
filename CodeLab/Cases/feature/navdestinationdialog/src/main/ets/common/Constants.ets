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

export default class Consts {
  /** 告警toast弹窗持续时长 */
  public static readonly WARN_TOAST_DURATION: number = 800;
  /** 测试用评论数量 */
  public static readonly TEST_COMMENTS_COUNT: number = 10;
  /** 测试用评论列表预加载数量 */
  public static readonly COMMENTS_LIST_CACHE: number = 5;
  /** 测试评论的默认用户名 */
  public static readonly COMMENTS_DEFAULT_USERNAME: string = '买家';
  /** 商店栏元素间距 */
  public static readonly SHOP_BAR_SPACE: number = 8;
  /** 商店栏图标大小 */
  public static readonly SHOP_BAR_ICON_SIZE: number = 25;
  /** 商店图标大小 */
  public static readonly SHOP_ICON_SIZE: number = 40;
  /** 评论条目之间的间距 */
  public static readonly COMMENT_SPACE: number = 10;
  /** 评论条目具体头像和内容之间的间距 */
  public static readonly COMMENT_ITEM_SPACE: number = 8;
  /** 评论内容之间的间距 */
  public static readonly COMMENT_CONTENT_SPACE: number = 5;
  /** 评论弹窗高度占屏幕的比例 */
  public static readonly COMMENT_DIALOG_SCALE: number = 0.67;
  /** 关闭评论弹窗回调的动画时长 */
  public static readonly COMMENT_DIALOG_CLOSE_DURATION: number = 300;
  /** 评论弹窗的转场动画时长 */
  public static readonly COMMENT_DIALOG_TRANS_DURATION: number = 300;
  /** 评论弹窗的最小高度（触发关闭弹窗,vp） */
  public static readonly COMMENT_DIALOG_MIN_HEIGHT: number = 250;
  /** 评论弹窗恢复高度的动画时长 */
  public static readonly COMMENT_DIALOG_RECOVERY_TIME: number = 400;
  /** 滑动手势最小识别距离 */
  public static readonly COMMENT_PAN_GESTURE_DISTANCE: number = 20;
  /** 主页底部弹窗的高度 */
  public static readonly SHOP_BAR_HEIGHT: number = 60;
  /** 主页日志打印的TAG */
  public static readonly MAIN_PAGE_TAG: string = '[NavDialogMainPage]';
  /** 弹窗日志打印的TAG */
  public static readonly DIALOG_PAGE_TAG: string = this.MAIN_PAGE_TAG + '[DialogPage]';
  /** 评论页面名 */
  public static readonly DIALOG_PAGE_NAME: string = 'CommentDialog';
  /** 顶部页面标题高度 */
  public static readonly TOP_TITLE_HEIGHT: number = 64;
}