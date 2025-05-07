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

import { TimeChangeListener } from './TimeChangeListener';
import hilog from '@ohos.hilog';
import { BusinessError } from '@kit.BasicServicesKit';
import image from '@ohos.multimedia.image';
import { resourceManager } from '@kit.LocalizationKit';

// 常量定义
// 时间格式前导零
const TIME_PREFIX = '0';
// 用于判断是否需要加前导零
const TIME_DEMARCATION = 10;
const HOUR_12 = 12;
const HOUR_OFFSET_FACTOR = 0.5;
const MINUTE_OFFSET_FACTOR = 0.1;
const ANGLE_PRE_HOUR = 30;
const ANGLE_PRE_MINUTE = 6;
const ANGLE_PRE_SECOND = 6;
const CANVAS_SIZE = 250;
const CANVAS_ASPACTRADIO = 1;
const IMAGE_WIDTH = 10;
// 时钟图片名称
const CLOCK_BG_PATH = 'analog_clock_bg.png';
const CLOCK_HOUR_PATH = 'analog_clock_hour_hand.png';
const CLOCK_MINUTE_PATH = 'analog_clock_minute_hand.png';
const CLOCK_SECOND_PATH = 'analog_clock_second_hand.png';
const resourceMgs: resourceManager.ResourceManager = getContext(this).resourceManager;

/**
 * 功能描述: 本示例介绍利用Canvas和定时器setInterval实现模拟时钟功能。
 *
 * 推荐场景: 用于用户需要显示自定义模拟时钟的场景
 *
 * 核心组件:
 * 1. Canvas
 * 2. setInterval
 *
 * 实现步骤：
 * 1. 利用CanvasRenderingContext2D中的drawImage将表盘和表针绘制出来；
 * 2. 利用定时器每秒刷新一次，计算好时针、分针、秒针对应的偏移量，重新绘制表盘和表针，实现表针的转动。
 */
@Component
export struct AnalogClockComponent {
  // 当前时间
  @State time: string = '';
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private renderContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  // 画布大小
  private canvasSize: number = CANVAS_SIZE;
  private clockRadius: number = this.canvasSize / 2;
  // 时钟图片对应的PixelMap
  private clockPixelMap: image.PixelMap | null = null;
  private hourPixelMap: image.PixelMap | null = null;
  private minutePixelMap: image.PixelMap | null = null;
  private secondPixelMap: image.PixelMap | null = null;
  private timeListener: TimeChangeListener | null = null;

  aboutToAppear(): void {
    this.init();
  }

  aboutToDisappear(): void {
    if (this.timeListener) {
      this.timeListener.clearInterval();
    }
  }

  build() {
    Column() {
      Text($r("app.string.analog_clock_canvas_title"))
        .fontSize($r("app.integer.analog_clock_font_size"))
        .fontWeight(FontWeight.Bold)
        .margin($r("app.integer.analog_clock_text_margin"))
      Canvas(this.renderContext)
        .width(this.canvasSize)
        .aspectRatio(CANVAS_ASPACTRADIO)
        .onReady(() => {
          this.paintTask();
        })
      Text(this.time)
        .fontSize($r("app.integer.analog_clock_font_size"))
        .fontWeight(FontWeight.Bold)
        .margin($r("app.integer.analog_clock_text_margin"))
    }
    .width('100%')
    .height('100%')
  }

  /**
   * 初始化表盘和表针对应的变量，并首次绘制。
   */
  private init() {
    const clockBgSource = image.createImageSource(resourceMgs.getRawFdSync(CLOCK_BG_PATH));
    const hourSource = image.createImageSource((resourceMgs.getRawFdSync(CLOCK_HOUR_PATH)));
    const minuteSource = image.createImageSource((resourceMgs.getRawFdSync(CLOCK_MINUTE_PATH)));
    const secondSource = image.createImageSource((resourceMgs.getRawFdSync(CLOCK_SECOND_PATH)));

    const now = new Date();
    const currentHour = now.getHours();
    const currentMinute = now.getMinutes();
    const currentSecond = now.getSeconds();
    this.time = this.getTime(currentHour, currentMinute, currentSecond);

    // 创建表盘对应的PixelMap并绘制。
    let paintDial = clockBgSource.createPixelMap().then((pixelMap: image.PixelMap) => {
      this.clockPixelMap = pixelMap;
      this.paintDial();
    }).catch((err: BusinessError) => {
      logger.error(`[error]error at clockBgSource.createPixelMap:${err.message}`);
    });

    // 创建时针对应的PixelMap并绘制。
    hourSource.createPixelMap().then(async (pixelMap: image.PixelMap) => {
      await paintDial;
      const hourOffset = currentMinute * HOUR_OFFSET_FACTOR;
      this.paintPin(ANGLE_PRE_HOUR * currentHour + hourOffset, pixelMap);
      this.hourPixelMap = pixelMap;
    }).catch((err: BusinessError) => {
      logger.error(`[error]error at hourSource.createPixelMap:${err.message}`);
    });

    // 创建分针对应的PixelMap并绘制。
    minuteSource.createPixelMap().then(async (pixelMap: image.PixelMap) => {
      await paintDial;
      const minuteOffset = currentSecond * MINUTE_OFFSET_FACTOR;
      this.paintPin(ANGLE_PRE_MINUTE * currentMinute + minuteOffset, pixelMap);
      this.minutePixelMap = pixelMap;
    }).catch((err: BusinessError) => {
      logger.error(`[error]error at minuteSource.createPixelMap:${err.message}`);
    });

    // 创建秒针对应的PixelMap并绘制。
    secondSource.createPixelMap().then(async (pixelMap: image.PixelMap) => {
      await paintDial;
      this.paintPin(ANGLE_PRE_SECOND * currentSecond, pixelMap);
      this.secondPixelMap = pixelMap;
    }).catch((err: BusinessError) => {
      logger.error(`[error]error at secondSource.createPixelMap:${err.message}`);
    });
  }

  /**
   * 绘制模拟时钟任务
   */
  private paintTask() {
    // 1.先将绘制原点转到画布中央
    this.renderContext.translate(this.clockRadius, this.clockRadius);

    // 2.监听时间变化，每秒重新绘制一次
    this.timeListener = new TimeChangeListener(
      (hour: number, minute: number, second: number) => {
        this.renderContext.clearRect(-this.clockRadius, -this.clockRadius, this.canvasSize, this.canvasSize);
        this.paintDial();
        this.timeChanged(hour, minute, second);
        this.time = this.getTime(hour, minute, second);
      },
    );
  }

  /**
   * 时间变化回调函数
   */
  private timeChanged(newHour: number, newMinute: number, newSecond: number) {
    const hour = newHour > HOUR_12 ? newHour - HOUR_12 : newHour;
    const hourOffset = newMinute * HOUR_OFFSET_FACTOR;
    const minuteOffset = newSecond * MINUTE_OFFSET_FACTOR;

    this.paintPin(ANGLE_PRE_HOUR * hour + hourOffset, this.hourPixelMap);
    this.paintPin(ANGLE_PRE_MINUTE * newMinute + minuteOffset, this.minutePixelMap);
    this.paintPin(ANGLE_PRE_SECOND * newSecond, this.secondPixelMap);
  }

  /**
   * 绘制表盘
   */
  private paintDial() {
    this.renderContext.beginPath();
    if (this.clockPixelMap) {
      this.renderContext.drawImage(
        this.clockPixelMap,
        -this.clockRadius,
        -this.clockRadius,
        this.canvasSize,
        this.canvasSize)
    } else {
      logger.error('clockPixelMap is null!');
    }
  }

  /**
   * 绘制表针
   */
  private paintPin(degree: number, pinImgRes: image.PixelMap | null) {
    // TODO：知识点：先将当前绘制上下文保存再旋转画布，先保存旋转前的状态，避免状态混乱。
    this.renderContext.save();
    const angleToRadian = Math.PI / 180;
    let theta = degree * angleToRadian;
    this.renderContext.rotate(theta);

    this.renderContext.beginPath();
    if (pinImgRes) {
      this.renderContext.drawImage(
        pinImgRes,
        -IMAGE_WIDTH / 2,
        -this.clockRadius,
        IMAGE_WIDTH,
        this.canvasSize);
    } else {
      logger.error('PixelMap is null!');
    }
    this.renderContext.restore();
  }

  /**
   * 获取当前时间并格式化
   */
  private getTime(hour: number, minute: number, second: number): string {
    let hourPrefix = '';
    let minutePrefix = '';
    let secondPrefix = '';
    if (hour < TIME_DEMARCATION) {
      hourPrefix = TIME_PREFIX;
    }
    if (minute < TIME_DEMARCATION) {
      minutePrefix = TIME_PREFIX;
    }
    if (second < TIME_DEMARCATION) {
      secondPrefix = TIME_PREFIX;
    }
    return `${hourPrefix}${hour}:${minutePrefix}${minute}:${secondPrefix}${second}`;
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