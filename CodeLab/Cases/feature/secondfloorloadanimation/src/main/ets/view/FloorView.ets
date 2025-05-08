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

import { display, promptAction, Scale } from '@kit.ArkUI';
import { Animator as animator, AnimatorResult } from '@kit.ArkUI';
import { AppInfo } from '../model/AppInfo';
import { logger } from '../utils/Logger';

const ICON_NUM_IN_RECENTLY: number = 8; // 示例中最近使用小程序数目
const ICON_NUM_IN_USEFULNESS: number = 2; // 示例中实用小程序数目
const TRIGGER_HEIGHT: number = 200; // 触发动画高度或者动效消失高度
const FLING_FACTOR: number = 1.5; // 阻尼系数，可根据不同设备摩擦系数设置
const TOUCH_SLOP: number = 2; // 可滑动的最小距离
const OFFSET_STEP: number = 30; // 用于计算下拉距离不够自动收起的常量
const EXPAND_FLOOR_INTERVAL_TIME: number = 50; // 二楼滑动触发距离


@Component
export struct FloorView {
  @Link mainPageOffsetY: number; // Y轴偏移量，下拉的距离
  @State floorHeight: number = getScreenHeight(); // 二楼高度（初始值设置为屏幕高度）
  @Link immediatelyScale: Scale; // 设置动效组件缩放
  @Link animationXLeft: number; // 左圆点平移距离
  @Link animationXRight: number; // 右圆点平移距离
  @Link roundSize: number; // 中心圆点大小
  @Link onShow: boolean; // 动画是否显示
  @Link miniAppScale: Scale; //小程序缩放
  @State packUpFloorTriggerDistance: number = 150; // 二楼滑动触发距离
  private lastY: number = 0; // Y轴的值
  private downY: number = 0; // 两次Y轴差值
  private dragging: boolean = false; // 是否在拉拽
  @Consume @Watch("startPackUp") startPackUpFloor: boolean; // 调用开始收起方法
  @StorageLink('statusHeight') topRectHeight: number | undefined = AppStorage.get('statusHeight'); // 顶部系统导航栏高度
  @State appInfoList: AppInfo[] = []; // 实用小程序数组
  @State miniAppInfoList: AppInfo[] = []; // 最近使用小程序数组
  private backAnimator: AnimatorResult | undefined = undefined;

  aboutToAppear() {
    // 将实用小程序图片、名称推入空数组
    for (let index = 1; index <= ICON_NUM_IN_USEFULNESS; index++) {
      this.appInfoList.push(new AppInfo($r(`app.media.second_floor_ic_public_app${index}`), `App${index}`));
    }
    // 将最近使用小程序图片、名称推入空数组
    for (let index = 1; index <= ICON_NUM_IN_RECENTLY; index++) {
      this.miniAppInfoList.push(new AppInfo($r(`app.media.second_floor_ic_public_app${index}`), `App${index}`));
    }
  }

  /**
   * 收起方法，与startPackUp绑定
   */
  private startPackUp(): void {
    if (this.startPackUpFloor) {
      this.packUpFloor();
      this.startPackUpFloor = false;
    }
  }

  build() {
    Column() {
      this.floorViewBuilder();
    }
    .id('floorView')
    .width($r('app.string.second_floor_full_size'))
    .height(this.floorHeight)
    // 固定二楼刚开始位置
    .position({
      x: 0,
      y: this.mainPageOffsetY
    })
    .onTouch((event) => {
      if (event.touches.length !== 1) {
        event.stopPropagation();
        return
      }
      switch (event.type) {
        case TouchType.Down:
          this.secondFloorTouchDown(event);
          break;
        case TouchType.Move:
          this.secondFloorTouchMove(event);
          break;
        case TouchType.Up:
        case TouchType.Cancel:
          this.secondFloorTouchUp(event);
          break;
      }
      event.stopPropagation(); // 阻止冒泡
    })
  }

  /**
   * 按下事件、获取按下事件的位置
   * @param event 触屏事件
   */
  private secondFloorTouchDown(event: TouchEvent): void {
    this.onShow = false;
    this.lastY = event.touches[0].windowY;
    this.downY = this.lastY;
    this.dragging = false;
  }

  /**
   * 二楼触摸事件移动
   * @param event 触屏事件
   */
  private secondFloorTouchMove(event: TouchEvent): void {
    let currentY = event.touches[0].windowY;
    let deltaY = currentY - this.lastY;
    if (this.dragging) {
      // deltaY值为负值，指的是二楼向上滑动的距离
      if (deltaY < 0) {
        if (this.floorHeight - Math.abs(this.mainPageOffsetY) <= TRIGGER_HEIGHT) {
          this.onShow = true;
        }
        // this.mainPageOffsetY 值为0 ，this.floorHeight值为760
        if (this.mainPageOffsetY > -this.floorHeight) {
          this.mainPageOffsetY = this.mainPageOffsetY + px2vp(deltaY) * FLING_FACTOR;
        } else {
          this.mainPageOffsetY = -this.floorHeight;
          this.downY = this.lastY;
        }
      } else {
        if (this.mainPageOffsetY < 0 && px2vp(deltaY) * FLING_FACTOR < -this.mainPageOffsetY) {
          this.mainPageOffsetY = this.mainPageOffsetY + px2vp(deltaY) * FLING_FACTOR;
        } else {
          this.mainPageOffsetY = 0
        }
      }
      this.lastY = currentY;
    } else {
      if (Math.abs(deltaY) > TOUCH_SLOP) {
        if (deltaY < 0) {
          this.dragging = true;
          this.lastY = currentY;
        }
      }
    }
  }

  /**
   * 回收二楼，回收动画
   */
  private packUpFloor(): void {
    this.backAnimator = animator.create({
      duration: 500,
      easing: "linear",
      // 动画延时播放
      delay: 0,
      // 动画结束后保持结束状态
      fill: "forwards",
      direction: "normal",
      // 播放次数
      iterations: 1,
      begin: this.mainPageOffsetY,
      end: -this.floorHeight
    })
    this.backAnimator.onFrame = (value: number) => {
      this.mainPageOffsetY = value;
    }
    this.backAnimator.play()
  }

  /**
   * 二楼触摸抬起或取消触摸事件
   * @param event 触屏事件
   */
  private secondFloorTouchUp(event: TouchEvent): void {
    if (this.dragging) {
      // Y轴像上滑动距离是否达到触发收回距离
      if (Math.abs(this.mainPageOffsetY) > this.packUpFloorTriggerDistance) {
        this.onShow = true;
        // 滑动高度大于限定高度展示首页
        this.packUpFloor();
      } else {
        // 二楼未触发限定高度
        this.scrollByBottom();
      }
    }
  }

  /**
   * 二楼向上滑动未达到触发距离滚动回到底部
   */
  private scrollByBottom(): void {
    if (this.mainPageOffsetY < 0) {
      animateTo({
        duration: 500,
        curve: Curve.EaseOut,
        iterations: 1,
        playMode: PlayMode.Normal,
        onFinish: () => {
          this.onShow = false;
        },
      }, () => {
        this.mainPageOffsetY = 0;
      });
    }
  }

  /**
   * 二楼视图
   */
  @Builder
  floorViewBuilder() {
    Column() {
      Column() {
        Blank()
          .width($r('app.string.second_floor_full_size'))
          .height(px2vp(this.topRectHeight))
        // 二楼标题
        this.secondFloorTitle();
        // 二楼中间小程序
        this.secondFloorCenter();
      }
      .scale(this.miniAppScale)
    }
    .backgroundImage($r('app.media.second_floor_bg_blurry'))
  }

  /**
   * 二楼标题
   */
  @Builder
  secondFloorTitle() {
    Row() {
      Blank()
        .width($r('app.integer.second_floor_main_page_title_blank_width'))
      Text($r('app.string.second_floor_recently'))
        .fontSize($r('app.integer.second_floor_main_page_title_blank_font_size'))
        .fontColor(Color.White)
      Row() {
        Image($r('app.media.second_floor_search'))
          .width($r('app.integer.second_floor_second_floor_title_image'))
          .height($r('app.integer.second_floor_second_floor_title_image'))
        Text($r('app.string.second_floor_search'))
          .width($r('app.integer.second_floor_second_floor_title_text_width'))
          .height($r('app.integer.second_floor_second_floor_title_image'))
          .fontSize($r('app.integer.second_floor_second_floor_title_text_font_size'))
          .padding({
            left: $r('app.integer.second_floor_second_floor_title_text_padding'),
            top: 0,
            bottom: 0,
            right: 0
          })
      }
      .backgroundColor($r('app.color.second_floor_second_floor_title_color'))
      .opacity(0.6)
      .padding({
        left: $r('app.integer.second_floor_second_floor_title_padding_left'),
        right: $r('app.integer.second_floor_second_floor_title_padding_left'),
        top: $r('app.integer.second_floor_second_floor_title_padding_top'),
        bottom: $r('app.integer.second_floor_second_floor_title_padding_top')
      })
      .borderRadius($r('app.integer.second_floor_second_floor_title_border_radius'))
      .border({ width: 1.5, color: $r('app.color.second_floor_chat_view_border_color') })
      .margin({ left: $r('app.integer.second_floor_second_floor_title_margin_left') })
      .onClick(() => {
        // 调用Toast显示提示:此样式仅为案例展示
        promptAction.showToast({ message: $r("app.string.second_floor_toast_tips") });
      })
    }
    .scale(this.miniAppScale)
    .width($r('app.string.second_floor_full_size'))
    .height($r('app.string.second_floor_second_floor_title_height'))
    .justifyContent(FlexAlign.SpaceAround)
    .margin({ bottom: $r('app.integer.second_floor_second_floor_title_margin') })
  }

  /**
   * 二楼中间小程序
   */
  @Builder
  secondFloorCenter() {
    Column() {
      // 实用小程序
      this.usefulnessMiniApps();
      // 最近使用
      this.recentlyUsedMiniApps();
    }
    .height($r('app.integer.second_floor_second_floor_center_height'))
    .width($r('app.string.second_floor_full_size'))
    .layoutWeight(1)
  }

  /**
   * 实用小程序
   */
  @Builder
  usefulnessMiniApps() {
    Column() {
      // 标题
      Text($r('app.string.second_floor_usefulness_mini_apps_title'))
        .fontSize($r('app.integer.second_floor_usefulness_mini_apps_font_size'))
        .textAlign(TextAlign.Start)
        .width($r('app.string.second_floor_usefulness_mini_apps_width'))
        .margin({ bottom: $r('app.integer.second_floor_usefulness_mini_apps_text_margin') })
        .fontColor($r('app.color.second_floor_screen_color'))

      // 图标
      Row() {
        // 性能关注点：本例首次进入页面就需要全部加载且数据不大就不需要使用LazyForeach懒加载。如果是数据过大超过可视区域就需要使用LazyForEach进行数据懒加载，List布局时会根据可视区域按需创建组件，并在组件滑出可视区域外时销毁以降低内存占用。
        ForEach(this.appInfoList, (item: AppInfo) => {
          this.secondFloorComp(item);
        })
        // 最近播放
        this.recentlyPlayed();
      }
      .justifyContent(FlexAlign.SpaceAround)
      .width($r('app.string.second_floor_full_size'))
    }
    .padding({
      left: $r('app.integer.second_floor_usefulness_mini_apps_padding'),
      right: $r('app.integer.second_floor_usefulness_mini_apps_padding')
    })
    .margin({ bottom: $r('app.integer.second_floor_usefulness_mini_apps_margin') })
  }

  /**
   * 小程序组件布局
   */
  @Builder
  secondFloorComp(app: AppInfo) {
    Row() {
      Column() {
        Image(app.icon)
          .height($r('app.integer.second_floor_chat_view_image'))
          .width($r('app.integer.second_floor_chat_view_image'))
          .borderRadius($r('app.integer.second_floor_second_floor_comp_border_radius'))
        Text(app.name)
          .fontSize($r('app.integer.second_floor_chat_view_userinfo_name_font_size'))
          .fontColor(Color.White)
      }
    }
    .margin({ left: $r('app.integer.second_floor_second_floor_comp_margin') })
    .onClick(() => {
      // 调用Toast显示提示:此样式仅为案例展示
      promptAction.showToast({ message: $r("app.string.second_floor_toast_tips") });
    })
  }

  /**
   * 最近播放
   */
  @Builder
  recentlyPlayed() {
    Column() {
      Row() {
        Image($r('app.media.second_floor_play'))
          .width($r('app.integer.second_floor_recently_played_image_width'))
          .height($r('app.integer.second_floor_recently_played_image_width'))
        Text($r('app.string.second_floor_recently_played_content'))
          .width($r('app.string.second_floor_recently_played_content'))
          .height($r('app.integer.second_floor_recently_played_text_input_width'))
          .padding({
            left: $r('app.integer.second_floor_recently_played_text_input_padding'),
            top: 0,
            bottom: 0,
            right: 0
          })
          .fontSize($r('app.integer.second_floor_recently_played_text_font_size'))
      }
      .opacity(0.6)
      .backgroundColor($r('app.color.second_floor_second_floor_title_color'))
      .height($r('app.integer.second_floor_recently_played_row_height'))
      .width($r('app.integer.second_floor_recently_played_row_width'))
      .padding({
        left: $r('app.integer.second_floor_recently_played_row_padding_left'),
        right: $r('app.integer.second_floor_recently_played_row_padding_right'),
        top: $r('app.integer.second_floor_recently_played_row_padding_top'),
        bottom: $r('app.integer.second_floor_recently_played_row_padding_top')
      })
      .borderRadius($r('app.integer.second_floor_recently_played_row_border_radius'))
      .border({ width: 1.5, color: $r('app.color.second_floor_chat_view_border_color') })
      .margin({ bottom: $r('app.integer.second_floor_recently_played_row_margin') })
      .onClick(() => {
        // 调用Toast显示提示:此样式仅为案例展示
        promptAction.showToast({ message: $r("app.string.second_floor_toast_tips") });
      })

      Text($r('app.string.second_floor_recently_played'))
        .fontSize($r('app.integer.second_floor_recently_played_text_font_size'))
        .fontColor(Color.White)
    }
    .margin({ right: $r('app.integer.second_floor_recently_played_margin') })
  }

  /**
   * 最近使用
   */
  @Builder
  recentlyUsedMiniApps() {
    Column() {
      // 标题
      Row() {
        Text($r('app.string.second_floor_recently_used_mini_apps'))
          .fontSize($r('app.integer.second_floor_usefulness_mini_apps_font_size'))
          .fontColor($r('app.color.second_floor_screen_color'))
        Row() {
          Text($r('app.string.second_floor_more'))
            .fontSize($r('app.integer.second_floor_usefulness_mini_apps_font_size'))
            .fontColor($r('app.color.second_floor_screen_color'))
          Image($r('app.media.second_floor_right'))
            .width($r('app.integer.second_floor_recently_played_image_width'))
            .height($r('app.integer.second_floor_recently_played_image_width'))
        }
        .onClick(() => {
          // 调用Toast显示提示:此样式仅为案例展示
          promptAction.showToast({ message: $r("app.string.second_floor_toast_tips") });
        })
      }
      .width($r('app.string.second_floor_usefulness_mini_apps_width'))
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({
        bottom: $r('app.integer.second_floor_usefulness_mini_apps_row_margin'),
        right: $r('app.integer.second_floor_usefulness_mini_apps_row_margin'),
        left: $r('app.integer.second_floor_usefulness_mini_apps_row_margin')
      })

      // 常用小程序
      Column() {
        GridRow({
          columns: 4,
          gutter: { x: 5, y: 10 },
          breakpoints: {
            reference: BreakpointsReference.WindowSize
          },
          direction: GridRowDirection.Row
        }) {
          // 性能关注点：本例首次进入页面就需要全部加载且数据不大就不需要使用LazyForeach懒加载。如果是数据过大超过可视区域就需要使用LazyForEach进行数据懒加载，List布局时会根据可视区域按需创建组件，并在组件滑出可视区域外时销毁以降低内存占用。
          ForEach(this.miniAppInfoList, (item: AppInfo) => {
            GridCol({
              span: {
                xs: 1,
                sm: 1,
                md: 1,
                lg: 1
              },
              offset: 0,
              order: 0
            }) {
              this.secondFloorComp(item);
            }
          })
        }

      }
      .width($r('app.string.second_floor_recently_used_mini_apps_width'))
      .height($r('app.integer.second_floor_recently_used_mini_apps_height'))
      .margin({
        bottom: $r('app.integer.second_floor_recently_used_mini_apps_margin'),
        right: $r('app.integer.second_floor_recently_used_mini_apps_margin'),
        left: $r('app.integer.second_floor_recently_used_mini_apps_margin')
      })
    }
  }
}

/**
 * 获取屏幕高度
 */
export function getScreenHeight(): number {
  try {
    let displayClass = display.getDefaultDisplaySync();
    return px2vp(displayClass.height);
  } catch (exception) {
    logger.error('Failed to obtain the default display object. Code: ' + JSON.stringify(exception));
  }
  return 0;
}





