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
import {
  Controller,
  GuidePage,
  HighLightGuideBuilder,
  HighLightGuideComponent,
  HighLightOptionsBuilder,
  HighLightShape,
  OnGuideChangedListener,
  OnHighLightDrewListener,
  OnPageChangedListener,
  RectF
} from '@ohos/high_light_guide';
import { AnimatorOptions } from '@ohos.animator';
import { Tab } from '../model/Tabs';
import promptAction from '@ohos.promptAction';

/**
 * 功能描述：本文介绍如何使用high_light_guide三方库完成应用新版本功能导航。通过高亮区域与蒙版背景的明暗度对比，让用户快速锁定重点功能，了解版本变更和业务入口。
 *
 * 推荐场景：适用于添加新功能需要引导的所有软件
 *
 * 核心组件：
 * 1.HighLightGuideMainComponent
 *
 * 实现步骤：
 * 1.在需要使用的页面引入high_light_guide库中的引导页组件。
 * 2.初始化引导页构建类，通过addHighLight绑定对应id组件的高光。
 * 3.添加引导页布局。
 * 4.自定义Builder，分别设定基础布局和引导层内容。
 */

const DURATION = 600;
const DELAY = 0;
const ITERATIONS = 1;
const BEGIN = 0.0;
const END = 1.0;
const RADIUS = 2;
const DIFF = 10;
const START_ANGLE = 0;
const END_ANGLE = 360;

@Component
export struct HighLightGuideMainComponent {
  private builder: HighLightGuideBuilder | null = null;
  private controller: Controller | null = null;
  // 设定进入动画参数
  private enterAnimatorParam: AnimatorOptions = {
    duration: DURATION,
    easing: 'friction',
    delay: DELAY,
    fill: 'forwards',
    direction: 'normal',
    iterations: ITERATIONS,
    begin: BEGIN,
    end: END
  };
  // 设定退出动画参数
  private exitAnimatorParam: AnimatorOptions = {
    duration: DURATION,
    easing: 'friction',
    delay: DELAY,
    fill: 'forwards',
    direction: 'normal',
    iterations: ITERATIONS,
    begin: END,
    end: BEGIN
  };
  private visibleChangeListener: OnGuideChangedListener = {
    onShowed: (controller: Controller) => {
      // 此处可自定义显示后逻辑;
    },
    onRemoved: (controller: Controller) => {
      // 此处可自定义移除后逻辑;
    }
  };
  private pageChangeListener: OnPageChangedListener = {
    onPageChanged: (pageIndex: number) => {
      // 此处可添加监听逻辑;
    }
  };
  @Provide PosX: number = 0;
  @Provide PosY: number = 0;
  @State firstIndicatorHeight: number = 0;
  topRectHeight: number | undefined = AppStorage.get('statusHeight');

  aboutToAppear() {
    // 自定义高光形状
    const onDrewListener: OnHighLightDrewListener = {
      onHighLightDrew(context2d: CanvasRenderingContext2D, rectF: RectF) {
        context2d.strokeStyle = '#ffffff';
        const radius = Math.max(rectF.getWidth(), rectF.getHeight()) / RADIUS - DIFF;
        context2d.arc(rectF.getCenterX(), rectF.getCenterY(), radius, START_ANGLE, END_ANGLE, false);
        context2d.fill();
        context2d.lineWidth = RADIUS;
      }
    }
    const options = new HighLightOptionsBuilder().setOnHighLightDrewListener(onDrewListener).build();
    // 设定高光组件
    this.builder = new HighLightGuideBuilder()
      .setLabel('guide')
      .alwaysShow(true)// 总是显示，调试时可以打开
      .setOnGuideChangedListener(this.visibleChangeListener)
      .setOnPageChangedListener(this.pageChangeListener)
      .addGuidePage(GuidePage.newInstance()// 设定第一处提示
        .setEverywhereCancelable(true)// 允许点击任意处关闭
        .addHighLightWithOptions('test', HighLightShape.CIRCLE, options)
        .setHighLightIndicator(this.firstIndicator.bind(this)))
      .addGuidePage(GuidePage.newInstance()// 设定第二处提示
        .setEverywhereCancelable(false)// 要求用户点击"我知道了"才能关闭提示
        .setHighLightIndicator(this.secondIndicator))
      .addGuidePage(GuidePage.newInstance()// 设定第三处提示
        .setEverywhereCancelable(false)
        .setHighLightIndicator(this.thirdIndicator));
  }

  build() {
    Stack() {

      // 添加引导页布局
      HighLightGuideComponent({
        highLightContainer: this.highLightComponent,
        currentHLIndicator: null,
        builder: this.builder,
        onReady: (controllerParam: Controller) => {
          this.controller = controllerParam;
          this.controller.show();
        }
      })
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  highLightComponent() {
    //布局页面
    Column() {
      Tab()
    }
    .alignItems(HorizontalAlign.Center)
  }

  // 功能引导部分布局
  @Builder
  firstIndicator() {
    Column() {
      Text($r('app.string.highlightguide_new_show'))
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
        .width('70%')
        .onClick(() => {
          if (this.controller) {
            this.controller.showPage(1);
          }
        })
        .margin({ left: $r('app.integer.highlightguide_common_margin') })
      Image($r('app.media.ic_gallery_sort_order'))
        .width($r('app.integer.highlightguide_sort_order_width'))
        .height($r('app.integer.highlightguide_sort_order_width'))
        .margin({ top: $r('app.integer.highlightguide_common_margin_top') })
        .onClick(() => {
          if (this.controller) {
            this.controller.showPage(1);
          }
        })
    }
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.firstIndicatorHeight = Number(newValue.height);
    })
    .width('100%')
    // position坐标是以页面顶部中心为原点，不包括系统状态栏
    .position({ x: this.PosX, y: this.PosY - this.firstIndicatorHeight })
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  secondIndicator() {
    Column() {
      Text($r('app.string.highlightguide_custom_show'))
        .fontColor(Color.Black)
        .backgroundColor($r('app.color.highlightguide_module_back_ground'))
        .textAlign(TextAlign.Center)
        .width($r('app.integer.highlightguide_first_indicator_width'))
        .height($r('app.integer.highlightguide_first_indicator_height'))
        .borderRadius($r('app.integer.highlightguide_border_radius'))

      Text($r('app.string.highlightguide_tips'))
        .fontColor(Color.White)
        .margin($r('app.integer.highlightguide_common_margin'))
      Button($r('app.string.highlightguide_access'))
        .fontColor(Color.White)
        .fontSize($r('app.integer.highlightguide_access_font_size'))
        .backgroundColor($r('app.color.highlightguide_first_direct_background'))
        .border({ width: 1, color: Color.White })
        .width($r('app.integer.highlightguide_high_light_button_width'))
        .onClick(() => {
          if (this.controller) {
            this.controller.showPage(2);
          }
        })
    }
    .id('high_light_guide_introduction_dialog')
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  thirdIndicator() {
    Column() {
      Text($r('app.string.highlightguide_show_prompt'))
        .fontColor(Color.Black)
        .backgroundColor($r('app.color.highlightguide_module_back_ground'))
        .textAlign(TextAlign.Center)
        .width($r('app.integer.highlightguide_first_indicator_width'))
        .height($r('app.integer.highlightguide_search_height'))

      Text($r('app.string.highlightguide_agree'))
        .fontColor(Color.Black)
        .backgroundColor($r('app.color.highlightguide_module_back_ground'))
        .textAlign(TextAlign.Center)
        .width($r('app.integer.highlightguide_first_indicator_width'))
        .height($r('app.integer.highlightguide_search_height'))
        .padding({ top: $r('app.integer.highlightguide_common_margin_top') })
        .onClick(() => {
          if (this.controller) {
            this.controller.remove();
          }
        })
    }
    .id('high_light_guide_finish_dialog')
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}