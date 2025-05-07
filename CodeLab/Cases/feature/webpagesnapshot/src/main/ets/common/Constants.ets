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

export default class Constant {
  // 隐藏 titleBar
  public static readonly HIDE_TITLE_BAR: boolean = true;
  // 页面 title
  public static readonly WEB_PAGE_TITLE: string = 'Web页面长截图';
  public static readonly COMPONENT_PAGE_TITLE: string = '滚动组件页面长截图';
  // 屏幕与内容的外边距
  public static readonly CARD_MARGIN_START: number = 12;
  // 截图小预览浮窗的尺寸
  public static readonly SNAP_WINDOW_WIDTH: number = 100;
  public static readonly SNAP_WINDOW_HEIGHT: number = 200;
  // 截图大预览浮窗尺寸
  public static readonly SNAP_LARGE_WINDOW_WIDTH: number = 300;
  public static readonly SNAP_LARGE_WINDOW_HEIGHT: number = 500;
  // 网页加载完成提示词及持续时间
  public static readonly FINISH_LOAD_PROMPT: ResourceStr = $r('app.string.web_page_snap_shot_web_snap_finish_load_prompt');
  public static readonly FINISH_PROMPT_DURATION: number = 800;
  // Web组件的id
  public static readonly WEB_ID: string = 'WebPage';
  // 卡片弹窗的圆角弧度
  public static readonly BORDER_RADIUS: number = 12;
  // 卡片弹窗的边框宽度
  public static readonly BORDER_WIDTH: number = 4;
  // 卡片弹窗的边框颜色
  public static readonly BORDER_COLOR: string = '#ffb8b8b8';
  // 示例URL
  public static readonly EXAMPLE_URL: string = 'https://developer.huawei.com/consumer/cn/next';
  // 截图遮罩层制定zindex
  public static readonly MASK_TOP_LAYER: number = 2;
  // 正在截图的提示时长
  public static readonly PROMPT_SNAPSHOT_DURATION: number = 2000;
  // 保证滚动完成的延时
  public static readonly SCROLL_DURATION: number = 200;
  // 正在生成截图的提示时长
  public static readonly GENERATING_IMAGE_PROMPT_DURATION: number = 600;
  // 已保存至相册的提示时长
  public static readonly SAVED_TO_ALBUM_PROMPT_DURATION: number = 1800;
  // 截图弹窗距离底部的距离
  public static readonly POPUP_MARGIN_BOTTOM: number = 40;
  // 截图弹窗距离左边的距离
  public static readonly POPUP_MARGIN_LEFT: number = 20;
  // 保存图片的质量
  public static readonly SAVE_IMAGE_QUALITY: number = 100;
  // 保存图片的格式
  public static readonly SAVE_IMAGE_FORMAT: string = 'image/png';
  // 通用动画时长
  public static readonly ANIMATE_DURATION: number = 800;
  // 浮窗保存按钮的宽
  public static readonly SAVE_BUTTON_WIDTH: number = 90;
  // 浮窗取消按钮的宽
  public static readonly BUTTON_WIDTH: number = 80;
  // 浮窗取消按钮的高
  public static readonly BUTTON_HEIGHT: number = 30;
  // 浮窗保存按钮栏的高
  public static readonly BUTTON_BAR_HEIGHT: number = 45;
  // 浮窗保存按钮的上下内边距
  public static readonly SAVE_BUTTON_BAR_PADDING: number = 8;
  // 浮窗取消按钮的上下内边距
  public static readonly BUTTON_BAR_PADDING: number = 5;
  // 浮窗保存按钮的字体大小
  public static readonly BUTTON_BAR_FONTSIZE: number = 15;
  // 浮窗保存按钮的转场的缩放效果
  public static readonly BUTTON_BAR_SCALE: number = 0.4;
  // 浮窗右滑距离最大值（避免滑动生硬）
  public static readonly POPUP_RIGHT_PAN_GESTURE: number = 30;
  // 浮窗左滑消失的阈值
  public static readonly POPUP_LEFT_PAN_GESTURE: number = -65;
  // 浮窗左滑消失效果（浮窗完整离开当前屏幕即可）
  public static readonly POPUP_LEFT_SCREEN: number = -150;
  // "正在截图"弹窗组件尺寸
  public static readonly TEXT_POPUP_WIDTH: number = 90;
  public static readonly TEXT_POPUP_HEIGHT: number = 80;
  public static readonly TEXT_POPUP_PADDING: number = 10;
  // 滚动组件List数据
  public static readonly LIST_INFO: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
  // 滚动组件List行间隔
  public static readonly LIST_ELEMENT_VERTICAL_SPACE: number = 20;
  // 滚动组件ID
  public static readonly COMPONENT_ID: string = 'List_Page';
  // 滚动组件页面背景色
  public static readonly BACKGROUND_COLOR: string = '#ffdcdcdc';
  // 滚动组件背景色
  public static readonly LIST_COLOR: string = '#ffffffff';
  // 滚动组件评论间隔
  public static readonly LIST_COMMENT_SPACE: number = 5;
  // 滚动组件评论最大行数
  public static readonly LIST_COMMENT_LINE: number = 2;
}
