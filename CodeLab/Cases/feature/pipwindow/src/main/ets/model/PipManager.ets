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

import { PiPWindow } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { logger } from '../util/Logger';
import { AVPlayer } from './AVPlayer';

const CONTEXT_WIDTH:number=1600;  // 设置悬浮窗宽度为1600px
const CONTEXT_HEIGHT:number=900;  // 设置悬浮窗高度为900px

/**
 * 自定义XComponentController
 */
export class CustomXComponentController extends XComponentController {
  onSurfaceCreated(surfaceId: string): void {
    if (PipManager.getInstance().player.surfaceID === surfaceId) {
      return;
    }
    // 将surfaceId设置给媒体源
    PipManager.getInstance().player.surfaceID = surfaceId;
  }
}

/**
 * PipManager 自定义画中画控制器
 */
export class PipManager {
  private static instance: PipManager = new PipManager();
  private pipController?: PiPWindow.PiPController = undefined; // 画中画控制器实例。用于启动、停止画中画以及更新回调注册等
  private mXComponentController: XComponentController; // XComponent组件的控制器
  player: AVPlayer; // 视频播放控制器对象

  public static getInstance(): PipManager {
    return PipManager.instance;
  }

  constructor() {
    this.player = new AVPlayer();
    this.mXComponentController = new CustomXComponentController();
  }

  // 监听画中画控制面板控件动作事件
  onActionEvent(control: PiPWindow.ControlEventParam) {
    switch (control.controlType) {
    // 视频播放、停止
      case PiPWindow.PiPControlType.VIDEO_PLAY_PAUSE:
        if (control.status === PiPWindow.PiPControlStatus.PAUSE) {
          // 停止视频
          PipManager.getInstance().player.isPlaying = false;
        } else if (control.status === PiPWindow.PiPControlStatus.PLAY) {
          // 播放视频
          PipManager.getInstance().player.isPlaying = true;
        }
        break;
    // 切换到下一个视频
      case PiPWindow.PiPControlType.VIDEO_NEXT:
        break;
    // 切换到上一个视频
      case PiPWindow.PiPControlType.VIDEO_PREVIOUS:
        break;
    // 视频进度快进
      case PiPWindow.PiPControlType.FAST_FORWARD:
        break;
    // 视频进度后退
      case PiPWindow.PiPControlType.FAST_BACKWARD:
        break;
      default:
        break;
    }
    logger.info('onActionEvent, controlType:' + control.controlType + ', status' + control.status);
  }

  // 监听画中画生命周期
  onStateChange(state: PiPWindow.PiPState, reason: string) {
    switch (state) {
    // 表示画中画将要启动
      case PiPWindow.PiPState.ABOUT_TO_START:
        break;
    // 表示画中画已经启动
      case PiPWindow.PiPState.STARTED:
        // 启动画中画
        PipManager.getInstance().player.isPiPWindowLoad = true;
        break;
    // 表示画中画将要停止
      case PiPWindow.PiPState.ABOUT_TO_STOP:
        // 画中画关闭
        PipManager.getInstance().player.isPiPWindowLoad = false;
        break;
    // 表示画中画已经停止
      case PiPWindow.PiPState.STOPPED:
        // 画中画关闭
        PipManager.getInstance().player.isPiPWindowLoad = false;
        // 小窗口点击关闭画中画，视频暂停播放
        if (!PipManager.getInstance().player.isPiPWindowRestore) {
          PipManager.getInstance().player.isPlaying = false;
        }
        PipManager.getInstance().player.isPiPWindowRestore = false;
        break;
    // 表示画中画将从小窗播放恢复到原始播放界面
      case PiPWindow.PiPState.ABOUT_TO_RESTORE:
        // 小窗口复原关闭画中画
        PipManager.getInstance().player.isPiPWindowLoad = false;
        // 从小窗口复原
        PipManager.getInstance().player.isPiPWindowRestore = true;
        if (!PipManager.getInstance().player.isPlaying) {
          PipManager.getInstance().player.isPlaying = true;
        }
        break;
    // 表示画中画生命周期执行过程出现了异常
      case PiPWindow.PiPState.ERROR:
        break;
      default:
        break;
    }
  }

  // 关闭生命周期监听，关闭画中画控制面板控件动作事件的监听
  unregisterPipStateChangeListener() {
    this.pipController?.off('stateChange');
    this.pipController?.off('controlEvent');
  }

  getXComponentController(): CustomXComponentController {
    return this.mXComponentController;
  }

  /**
   * 创建画中画控制器，注册生命周期事件以及控制事件回调
   * @param ctx 上下文环境
   */
  init(ctx: Context) {
    if (this.pipController !== null && this.pipController !== undefined) {
      return;
    }
    // 当前设备如若不支持画中画则退出
    if (!PiPWindow.isPiPEnabled()) {
      return;
    }

    let config: PiPWindow.PiPConfiguration = {
      context: ctx,
      // XComponent组件绑定同一个
      componentController: this.getXComponentController(),
      // 画中画媒体类型枚举，当前使用的视频播放模版
      templateType: PiPWindow.PiPTemplateType.VIDEO_PLAY,
      contentWidth: CONTEXT_WIDTH,
      contentHeight: CONTEXT_HEIGHT,
    };
    // 通过create接口创建画中画控制器实例
    let promise: Promise<PiPWindow.PiPController> = PiPWindow.create(config);
    promise.then((controller: PiPWindow.PiPController) => {
      this.pipController = controller;
      // 通过画中画控制器实例的setAutoStartEnabled接口设置是否需要在应用返回桌面时自动启动画中画
      this.pipController?.setAutoStartEnabled(true);
      // 通过画中画控制器实例的on('stateChange')接口注册生命周期事件回调
      this.pipController.on('stateChange', (state: PiPWindow.PiPState, reason: string) => {
        this.onStateChange(state, reason);
      });
      // 通过画中画控制器实例的on('controlEvent')接口注册控制事件回调
      this.pipController.on('controlEvent', (control: PiPWindow.ControlEventParam) => {
        this.onActionEvent(control);
      });
    }).catch((err: BusinessError) => {
      logger.error(`Failed to create pip controller. Cause:${err.code}, message:${err.message}`);
    });
  }

  // 启动画中画
  startPip() {
    this.pipController?.startPiP().then(() => {
      logger.info(`Succeeded in starting pip.`);
    }).catch((err: BusinessError) => {
      logger.error(`Failed to start pip. Cause:${err.code}, message:${err.message}`);
    });
  }

  /**
   * 更新媒体源尺寸信息
   * @param width 更新后视频的宽
   * @param height 更新后视频的高
   */
  updateContentSize(width: number, height: number) {
    if (this.pipController) {
      this.pipController.updateContentSize(width, height);
    }
  }

  // 关闭画中画
  stopPip() {
    if (this.pipController === null || this.pipController === undefined) {
      return;
    }
    // 停止画中画
    let promise: Promise<void> = this.pipController.stopPiP();
    promise.then(() => {
      logger.info(`Succeeded in stopping pip.`);
    }).catch((err: BusinessError) => {
      logger.error(`Failed to stop pip. Cause:${err.code}, message:${err.message}`);
    });
  }

  /**
   * 设置是否需要在返回桌面时自动启动画中画
   * @param autoStart 是否关闭的布尔值
   */
  setAutoStart(autoStart: boolean): void {
    this.pipController?.setAutoStartEnabled(autoStart);
  }

  // 更新画中画面板控件状态
  updatePiPControlStatus() {
    let controlType: PiPWindow.PiPControlType = PiPWindow.PiPControlType.VIDEO_PLAY_PAUSE; // 视频播放控制面板中播放/暂停控件。
    let status: PiPWindow.PiPControlStatus = PiPWindow.PiPControlStatus.PLAY; // 视频播放控制面板中播放/暂停控件为播放状态。
    this.pipController?.updatePiPControlStatus(controlType, status); // 更新控制面板控件功能状态
  }
}
