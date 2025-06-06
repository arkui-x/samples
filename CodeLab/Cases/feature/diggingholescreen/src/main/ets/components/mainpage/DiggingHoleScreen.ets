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


import display from '@ohos.display';
import batteryInfo from '@ohos.batteryInfo';
import common from '@ohos.app.ability.common';
import window from '@ohos.window';
import hilog from '@ohos.hilog';
import prompt from '@system.prompt';

class TextMargin {
  left: number = 0; // 状态栏左偏移量
  right: number = 0; // 状态栏右偏移量
}

/**
 * 功能描述: 本示例介绍使用屏幕属性getDefaultDisplaySync、getCutoutInfo接口实现适配挖孔屏。
 *
 * 推荐场景: 用于沉浸式场景中适配挖孔屏需要规避不可用区域（如顶部状态栏时间和电量显示位置）的场景。
 *
 * 核心组件:
 * 1. getDefaultDisplaySync
 * 2. getCutoutInfo
 *
 * 实现步骤：
 * 1.通过窗口的getLastWindow接口获取到当前窗口实例用于后续对窗口设置。
 * 2.通过setWindowLayoutFullScreen、setWindowSystemBarEnable将窗口设置为全屏，并且隐藏顶部状态栏。
 * 3.通过getDefaultDisplaySync、getCutoutInfo获取窗口display对象和不可用区域的边界、宽高。
 * 4.使用获取到的信息进行计算偏移量实现对不可用区域的适配。
 */
@Component
export struct DiggingHoleScreenComponent {
  @State date: Date = new Date();
  @State currentTime: string = ''; // 顶部状态栏时间
  @State boundingRect: display.Rect[] = []; // 不可用区域数据
  @State screenWidth: number = 0; // 屏幕宽度
  @State displayClass: display.Display | null = null;
  @State topTextMargin: TextMargin = { left: 0, right: 0 }; // 顶部状态栏偏移量
  private context = getContext() as common.UIAbilityContext; // 获取UIAbilityContext

  aboutToAppear(): void {
    // 获取窗口实例
    window.getLastWindow(this.context, (err, data) => {
      if (err.code !== 0) {
        logger.error('DiggingHoleScreen', 'getLastWindow failed. error is:' + JSON.stringify(err));
        return;
      }
      // 设置窗口为全屏显示状态
      data.setWindowLayoutFullScreen(true);
      // 设置顶部状态栏为隐藏状态
      data.setWindowSystemBarEnable(['navigation']);
    });

    /**
     * TODO：知识点
     * 1.通过getDefaultDisplaySync获取窗口display对象。
     * 2.通过getCutoutInfo获取到不可用区域的边界、宽高。
     * 3.使用获取到的信息进行计算偏移量实现对不可用区域的适配。
     */
    this.displayClass = display.getDefaultDisplaySync();
    display.getDefaultDisplaySync().getCutoutInfo((err, data) => {
      if (err.code !== 0) {
        logger.error('DiggingHoleScreen', 'getCutoutInfo failed. error is:' + JSON.stringify(err));
        return;
      }
      this.boundingRect = data.boundingRects;
      this.topTextMargin = this.getBoundingRectPosition();
    });

    // 获取小时
    const hours = this.date.getHours();
    // 获取分钟
    const minutes = this.date.getMinutes();
    // 分钟小于10在前面加0
    this.currentTime = hours.toString() + ':' + (minutes < 10 ? '0' + minutes : minutes.toString());
  }

  // 退出当前页面时将窗口重新设置成初始状态
  aboutToDisappear() {
    if (this.context !== undefined) {
      window.getLastWindow(this.context, async (err, data) => {
        if (err.code !== 0) {
          logger.error('DiggingHoleScreen', 'getLastWindow failed. error is:' + JSON.stringify(err));
          return;
        }
        data.setWindowSystemBarEnable(['status', 'navigation']);
      });
    }
  }

  /**
   * TODO 知识点：通过获取到的屏幕属性和屏幕不可用区域来判断不可用区域位置
   * 1.getCutoutInfo接口获取到不可用区域的左边界、上边界、宽度、高度。
   * 2.不可用区域左边宽度即为左边界的值。
   * 3.不可用区域右边界宽度等于屏幕宽度减去不可用区域宽度和左边界。
   * 4.获取到不可用区域到左右屏幕边缘的宽度进行对比判断出不可用区域位置。
   * 5.不可用区域位于中间时，不同设备左右距离可能存在小于10的差值，判断是否在中间取去左右距离差值的绝对值进行判断。
   * @returns left：左偏移量 right：右偏移量
   */
  getBoundingRectPosition(): TextMargin {
    if (this.boundingRect !== null && this.displayClass !== null && this.boundingRect[0] !== undefined) {
      // 不可用区域右侧到屏幕右边界的距离：屏幕宽度减去左侧宽度和不可用区域宽度
      const boundingRectRight: number = this.displayClass.width - (this.boundingRect[0].left + this.boundingRect[0].width);
      // 不可用区域左侧到屏幕左边界的距离：getCutoutInfo接口可以直接获取
      const boundingRectLeft: number = this.boundingRect[0].left;
      // 部分设备不可用区域在中间时存在左右距离会有10像素以内的差距，获取到的左右距离差值绝对值小于10都按照不可用区域位于中间处理
      if (Math.abs(boundingRectLeft - boundingRectRight) <= 10) {
        return { left: 0, right: 0 };
      }
      if (boundingRectLeft > boundingRectRight) {
        // 不可用区域在右边
        return { left: 0, right: this.displayClass.width - boundingRectLeft };
      } else if (boundingRectLeft < boundingRectRight) {
        // 不可用区域在左边
        return { left: this.boundingRect[0].left + this.boundingRect[0].width, right: 0 };
      }
    }
    return { left: 0, right: 0 };
  }

  build() {
    Stack() {
      Image($r("app.media.digging_hole_screen_2048game"))
        .objectFit(ImageFit.Fill)
        .width('100%')
        .height('100%')
        .onClick(() => {
          prompt.showToast({
            message: '该功能暂未开发',
            duration: 2000
          })
        })
      Column() {
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
          Text(this.currentTime)// 时间
            .fontSize($r('app.integer.digging_hole_screen_title_font_size'))
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Regular)
            .padding({ left: $r('app.integer.digging_hole_screen_text_padding_left') })
            .margin({
              left: px2vp(this.topTextMargin.left),
              top: $r('app.integer.digging_hole_screen_text_margin_top')
            }) // 获取的偏移量单位为px需要进行转换
          Text(batteryInfo.batterySOC.toString() + '%')// 电池电量
            .fontSize($r('app.integer.digging_hole_screen_title_font_size'))
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Regular)
            .padding({ right: $r('app.integer.digging_hole_screen_text_padding_right') })
            .margin({
              right: px2vp(this.topTextMargin.right),
              top: $r('app.integer.digging_hole_screen_text_margin_top')
            }) // 获取的偏移量单位为px需要进行转换
        }
        .width('100%')
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.TopStart)
  }
}

/**
 * 日志打印类
 */
class Logger {
  private domain: number;
  private prefix: string;
  private format: string = '%{public}s, %{public}s';

  constructor(prefix: string) {
    this.prefix = prefix;
    this.domain = 0xFF00;
    this.format.toUpperCase();
  }

  debug(...args: string[]) {
    hilog.debug(this.domain, this.prefix, this.format, args);
  }

  info(...args: string[]) {
    hilog.info(this.domain, this.prefix, this.format, args);
  }

  warn(...args: string[]) {
    hilog.warn(this.domain, this.prefix, this.format, args);
  }

  error(...args: string[]) {
    hilog.error(this.domain, this.prefix, this.format, args);
  }
}

export let logger = new Logger('[CommonAppDevelopment]')
