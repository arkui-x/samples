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

import { BaseVideoPlayer, GlobalContext, StandardGSYVideoModel, } from '@ohos/gsyvideoplayer';
import window from '@ohos.window';
import display from '@ohos.display';
import { DanmakuVideoPlayer } from '../model/DanmakuVideoPlayer';
import { AppRouter } from 'routermodule';

// 当前屏幕方向
export enum Directions { HORIZONTAL, VERTICAL };

// 当前视频宽度
let screenWidth = 0;

@AppRouter({ name: 'danmakuplayer/DanmakuVideoDemo' })
@Component
export struct DanmakuVideoDemo {
  // 设置视频高度
  @State screenHeight: string | Resource = $r('app.string.danmaku_player_screen_height_vertical');
  // 实例化StandardGSYVideoModel实例
  videoModel: StandardGSYVideoModel = new StandardGSYVideoModel();
  context: Context = getContext(this);
  standardScreenWidth: number =
    this.context.resourceManager.getNumber($r('app.integer.danmaku_player_screen_width_standard'));
  @State windowClass: window.Window | undefined = undefined;
  isQuit: boolean = false; // 是否退出页面
  // 当前旋转状态，1为垂直，0为水平
  @State curDirection: Directions = Directions.HORIZONTAL;
  /*
   * 从全屏点左上角返回，视频旋转回来同时返回上一页面
   * */
  backClickListener: () => void = () => {
    if (screenWidth < this.standardScreenWidth && this.curDirection === Directions.VERTICAL) {
      this.changeOrientation();
    }
  }
  /*
   * 点击全屏按钮，旋转
   * */
  fullClickListener: () => void = () => {
    this.changeOrientation();
  }
  // 视频来源
  private videoUrl = this.context.resourceManager.getStringSync($r('app.string.danmaku_player_video_url').id);

  build() {
    Row() {
      DanmakuVideoPlayer({
        videoModel: this.videoModel,
        curDirection: this.curDirection,
        windowClass: this.windowClass,
        getDirection: this.getDirection
      })
        .height(this.screenHeight)
    }
    .width($r('app.string.danmaku_player_full_size'))
    .height($r('app.string.danmaku_player_full_size'))
  }

  async aboutToAppear() {
    window.getLastWindow(this.context).then((lastWindow) => {
      this.windowClass = lastWindow;
      // 监听窗口尺寸变化
      this.windowClass.on('windowSizeChange', (data: Size) => {
        if (this.getDirection() === 1) {
          // 设置窗口全屏模式时导航栏、状态栏不可见
          this.windowClass?.setWindowSystemBarEnable([]);
          this.screenHeight = $r('app.string.danmaku_player_screen_height_horizontal');
          this.curDirection = Directions.VERTICAL;
        } else {
          // 设置窗口退出全屏模式时导航栏、状态栏可见
          this.windowClass?.setWindowSystemBarEnable(['navigation', 'status']);
          this.screenHeight = $r('app.string.danmaku_player_screen_height_vertical');
          this.curDirection = Directions.HORIZONTAL;
          // 退出页面时注销窗口监听
          if (this.isQuit) {
            this.windowClass?.off('windowRectChange');
          }
        }
      })
    })
    this.videoModel.setUrl(this.videoUrl, false); //设置播放源
    this.videoModel.setTitle('这是测试视频的标题'); //设置标题
    this.videoModel.setBackClickListener(this.backClickListener); //设置退出全屏的回调
    this.videoModel.setFullClickListener(this.fullClickListener); //设置进入全屏的回调
    this.videoModel.setCoverImage($r('app.media.danmaku_player_cover')); //设置封面图
    this.curDirection = this.getDirection() === 0 ? Directions.HORIZONTAL : Directions.VERTICAL; //获取当前方向
    screenWidth = px2vp(display.getDefaultDisplaySync().width); //获取视频宽度
  }

  /*
   * 页面消失停止播放
   * */
  aboutToDisappear() {
    const player: BaseVideoPlayer = GlobalContext.getContext().getObject('currentPlayer') as BaseVideoPlayer;
    if (player) {
      player.stop();
    }
    this.isQuit = true;
    if (this.curDirection === Directions.VERTICAL) {
      this.changeOrientation();
    }
  }

  /*
   * 页面展示时重新播放
   * */
  onPageShow() {
    const player: BaseVideoPlayer = GlobalContext.getContext().getObject('currentPlayer') as BaseVideoPlayer;
    if (!player) {
      return;
    }
    player.resumePlay();
  }

  /*
   * 页面隐藏时播放暂停
   * */
  onPageHide() {
    const player: BaseVideoPlayer = GlobalContext.getContext().getObject('currentPlayer') as BaseVideoPlayer;
    if (!player) {
      return;
    }
    player.pause();
  }

  /*
   * 如果是全屏状态，侧滑退出时就旋转，否则暂停播放器，退出页面
   * */
  onBackPress() {
    const player: BaseVideoPlayer = GlobalContext.getContext().getObject('currentPlayer') as BaseVideoPlayer;
    if (player) {
      player.stop();
    }
    if (screenWidth < this.standardScreenWidth && this.curDirection === Directions.VERTICAL) {
      this.changeOrientation();
    }
  }

  /*
   * 获取当前旋转状态
   * */
  private getDirection(): number {
    return getContext().getApplicationContext().resourceManager.getConfigurationSync().direction;
  }

  /*
   * 旋转方法
   * */
  private changeOrientation() {
    if (screenWidth > this.standardScreenWidth) {
      if (this.curDirection === Directions.HORIZONTAL) {
        this.screenHeight = $r('app.string.danmaku_player_screen_height_horizontal');
        this.curDirection = Directions.VERTICAL;
      } else {
        this.screenHeight = $r('app.string.danmaku_player_screen_height_vertical');
        this.curDirection = Directions.HORIZONTAL;
      }
    } else {
      if (this.curDirection === Directions.HORIZONTAL) {
        // 设置窗口的显示方向属性，LANDSCAPE表示横屏显示模式
        this.windowClass?.setPreferredOrientation(window.Orientation.LANDSCAPE);
      } else {
        // 设置窗口的显示方向属性，PORTRAIT表示竖屏显示模式
        this.windowClass?.setPreferredOrientation(window.Orientation.PORTRAIT);
      }
    }
  }
}
