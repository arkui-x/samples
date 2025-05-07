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
import window from '@ohos.window';
import { AppRouter, DynamicsRouter } from 'routermodule';
import bluetoothViewModel from '../viewmodel/BluetoothClientModel';
import HeartRateGraph from '../uicomponents/HeartRateGraph';
import Log from '../utils/Log';
import NavigationBar from '../uicomponents/NavigationBar';
import StyleConstants from '../constants/StyleConstants';

const TAG = '[Sample_BluetoothManager]';

const HEIGHT_NAVIGATION_BAR = StyleConstants.HEIGHT_NAVIGATION_BAR;
const HEIGHT_TOP_ROW = 40;
const MARGIN_HORIZONTAL = 60;
const HEART_RATE_TOO_LOW = 50;
const HEART_RATE_TOO_HIGH = 100;
const HEIGHT_TOP_HELP = -64; // 隐藏顶部帮助栏

@AppRouter({ name: "bluetooth/HeartRate" })
@Component
export struct HeartRate {
  @StorageLink('heartRate') @Watch('onHeartRate') heartRate: number = 0;
  @StorageLink('windowSize') @Watch('onWindowSizeChange') windowSize: window.Size = {
    width: display.getDefaultDisplaySync().width,
    height: display.getDefaultDisplaySync().height
  }
  @State heartRateTop: number = 0;
  @State heartRateBottom: number = 0;
  @State heartRateAverage: number = 0;
  @State graphWidth: number = this.windowSize.width - vp2px(MARGIN_HORIZONTAL) * 2;
  @State graphHeight: number = this.windowSize.height - vp2px(HEIGHT_NAVIGATION_BAR) - vp2px(HEIGHT_TOP_ROW * 3);

  /**
   * 心率变动事件
   */
  onHeartRate(): void {
    Log.showInfo(TAG, `onHeartRate: heartRate = ${this.heartRate}`);
    this.heartRateTop = this.heartRateTop < this.heartRate ? this.heartRate : this.heartRateTop;
    this.heartRateBottom = (this.heartRateBottom === 0) ? this.heartRate :
      (this.heartRateBottom > this.heartRate) ? this.heartRate : this.heartRateBottom;
    this.heartRateAverage = (this.heartRateAverage + this.heartRate) / 2;
  }

  onWindowSizeChange(): void {
    Log.showInfo(TAG, `onWindowSizeChange: windowSize = ${JSON.stringify(this.windowSize)}`);
    this.graphWidth = this.windowSize.width - vp2px(MARGIN_HORIZONTAL) * 2;
    this.graphHeight = this.windowSize.height - vp2px(HEIGHT_NAVIGATION_BAR) - vp2px(HEIGHT_TOP_ROW * 3);
  }

  /**
   * 心率异常警告
   */
  showWarningReminder(): boolean {
    return this.tooHigh() || this.tooLow();
  }

  /**
   * 心率过高
   */
  tooHigh(): boolean {
    return this.heartRate > HEART_RATE_TOO_HIGH;
  }

  /**
   * 心率过低
   */
  tooLow(): boolean {
    return this.heartRate < HEART_RATE_TOO_LOW;
  }

  warningReminderIcon(): Resource | undefined {
    if (this.tooHigh()) {
      return $r('app.media.ic_red_arrow_up');
    }
    if (this.tooLow()) {
      return $r('app.media.ic_red_arrow_down');
    }
    return undefined;
  }

  async aboutToAppear() {
    Log.showInfo(TAG, `HeartRate aboutToAppear`);
     // 横屏展示心率波动界面
    await globalThis.setOrientation(window.Orientation.AUTO_ROTATION_LANDSCAPE);
    let mWindow: window.Window;
    let windowStage: window.WindowStage;
    mWindow = windowStage!.getMainWindowSync();
    mWindow.on('windowSizeChange', (size: window.Size) => {
      Log.showInfo(TAG, `onWindowSizeChange: size = ${JSON.stringify(size)}`);
      AppStorage.setOrCreate('windowSize', size);
    });
  }

  build() {
    Column() {
      NavigationBar({
        title: $r('app.string.ble_title_heart_rate'), actions: [{
          id: 'btn_disconnect',
          name: $r('app.string.ble_btn_disconnect'),
          event: async () => {
            bluetoothViewModel.disconnect();
            // 返回到主页竖屏显示
            await globalThis.setOrientation(window.Orientation.UNSPECIFIED);
            DynamicsRouter.navPathStack.pop(true);
          }
        }]
      })
        .height(HEIGHT_NAVIGATION_BAR)

      Row() {
        Text($r('app.string.ble_tv_heart_rate_top_and_bottom', this.heartRateTop, this.heartRateBottom))
          .fontColor($r('app.color.ble_text_color_primary'))
          .fontSize($r('app.float.ble_text_size_medium'))

        Row() {
          Text($r('app.string.ble_tv_heart_rate_average_current', this.heartRateAverage, this.heartRate))
            .id('Realtime_heart_rate')
            .fontColor($r('app.color.ble_text_color_primary'))
            .fontSize($r('app.float.ble_text_size_medium'))

          Image(this.warningReminderIcon())
            .width($r('app.integer.ble_icon_width'))
            .aspectRatio(1)
            .margin({ left: $r('app.integer.ble_image_margin_left') })
            .visibility(this.showWarningReminder() ? Visibility.Visible : Visibility.Hidden)
        }
      }
      .width('100%')
      .height(HEIGHT_TOP_ROW)
      .padding({ left: MARGIN_HORIZONTAL, right: MARGIN_HORIZONTAL })
      .justifyContent(FlexAlign.SpaceBetween)
      // 心率波动图页面
      HeartRateGraph({
        viewWidth: px2vp(this.graphWidth),
        viewHeight: px2vp(this.graphHeight)
      })
    }
    .margin({ top: HEIGHT_TOP_HELP })
    .backgroundColor($r('app.color.ble_bg_white'))
  }
}