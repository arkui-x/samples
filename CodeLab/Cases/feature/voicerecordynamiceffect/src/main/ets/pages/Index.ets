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
import common from '@ohos.app.ability.common';
import { Permissions } from '@ohos.abilityAccessCtrl';
import { CommonConstants as Const } from '../common/CommonConstants';
import { VerifyModeEnum } from '../enums/VerifyModeEnum';
import { promptAction, window } from '@kit.ArkUI';
import { Message, messageList } from '../models/Message';
import { MessageType } from '../enums/MessageType';
import { AVPlayer } from '../models/AVPlayer';
import { AudioRecorder } from '../models/AudioRecorder';
import { ButtonWithWaterRipples } from '../components/ButtonWithWaterRipples';
import { getMode, reqPermissionsFromUser } from '../utils/RecordUtil';

// 获取麦克风权限
const permissions: Array<Permissions> = ['ohos.permission.MICROPHONE'];

/**
 * 功能描述: 本示例使用AVrecord录制音频和AVrecord的getAudioCapturerMaxAmplitude接口获取振幅实现UI动效;使用AVplayer播放音频
 *
 * 推荐场景: 语音录制场景
 *
 * 核心组件:
 * 1. AudioRecorder
 *
 * 实现步骤:
 * 1. 利用AVrecord录制音频病获取音频振幅
 * 2. 利用振幅的变化，换算出column的height并加上动画效果
 * 3. 使用AVplayer播放录制的音频文件
 */
@Component
export struct GestureGroupExample {
  @State bottomHeight: number = 20; // 底部系统导航栏高度
  @State messages: Array<Message> = messageList;
  @State columnX: number = Const.COLUMN_WIDTH; // Column宽度
  @State yMax: number = Const.OPACITY_FALSE; // Column高度最大值
  @State yMin: number = Const.OPACITY_FALSE; // Column高度最小值
  @State isListening: boolean = false;
  @State count: number = Const.OPACITY_FALSE;
  @State flagUpOpacity: number = Const.OPACITY_FALSE; // 上划取消字样透明度
  @State flagInfoOpacity: number = Const.OPACITY_FALSE; // 消息条透明度
  @State maxNumber: number = Const.OPACITY_FALSE; // Column最大高度
  @State minNumber: number = Const.OPACITY_FALSE; // Column最小高度
  @State timeStart: number = Const.OPACITY_FALSE; // 初始时间戳
  @State timeEnd: number = Const.OPACITY_FALSE; // 结束时间戳
  @State timeAv: number = Const.OPACITY_FALSE; // 手势持续时间
  @State waterRipplesBg: Resource = $r("app.string.voice_record_water_ripples_bg");
  // 取消识别背景色
  @State backgroundCancel: Color = Color.Gray;
  // 取消识别字体颜色
  @State fontColorCancel: Color = Color.White;
  // 识别文字背景色
  @State backgroundWord: Color = Color.Gray;
  // 识别文字字体颜色
  @State fontColorWord: Color = Color.White;
  // 松开发送背景色
  @State backgroundVoice: Color = Color.White;
  // 松开发送字体颜色
  @State fontColorVoice: Color = Color.Black;
  textSize: Resource = $r("app.integer.voice_record_verify_text_font_size");
  // 当前模式
  @State mode: number = VerifyModeEnum.VOICE;
  avoidAreaType: number = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR;
  // 创建音频录制与播放实例
  AVRecord = new AudioRecorder();
  AVPlayer = new AVPlayer();
  @StorageLink('avoidAreaBottomToModule') avoidAreaBottomToModule: number = 0;
  private scroller: ListScroller = new ListScroller();

  aboutToAppear() {
    const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    reqPermissionsFromUser(permissions, context);
    window.getLastWindow(getContext(this)).then((window) => {
      const avoidArea = window.getWindowAvoidArea(this.avoidAreaType);
      this.bottomHeight = px2vp(avoidArea.bottomRect.height);
    });
  }

  //重置状态
  resetState(): void {
    this.backgroundCancel = Color.Gray;
    this.fontColorCancel = Color.White;
    this.backgroundWord = Color.Gray;
    this.fontColorWord = Color.White;
    this.backgroundVoice = Color.White;
    this.fontColorVoice = Color.Black;
    this.waterRipplesBg = $r("app.string.voice_record_water_ripples_bg");
    this.timeStart = Const.OPACITY_FALSE; // 初始时间戳
    this.timeEnd = Const.OPACITY_FALSE;
  }

  //根据识别模式设置不同样式
  updateStateByMode(): void {
    if (this.mode === VerifyModeEnum.VOICE) {
      // 语音识别
      this.backgroundVoice = Color.White;
      this.fontColorVoice = Color.Black;
      this.waterRipplesBg = $r("app.string.voice_record_water_ripples_bg");
      this.fontColorCancel = Color.White;
      this.backgroundCancel = Color.Gray;
      this.fontColorWord = Color.White;
      this.backgroundWord = Color.Gray;
    } else if (this.mode === VerifyModeEnum.TEXT) {
      // 转文字
      this.fontColorWord = Color.Black;
      this.backgroundWord = Color.White;
      this.waterRipplesBg = $r("app.string.voice_record_water_ripples_bg");
      this.fontColorCancel = Color.White;
      this.backgroundCancel = Color.Gray;
      this.backgroundVoice = Color.Gray;
      this.fontColorVoice = Color.White;
    } else if (this.mode === VerifyModeEnum.CANCEL) {
      // 取消
      this.fontColorCancel = Color.Black;
      this.backgroundCancel = Color.White;
      this.waterRipplesBg = $r("app.string.voice_record_water_ripples_bg_over");
      this.fontColorWord = Color.White;
      this.backgroundWord = Color.Gray;
      this.backgroundVoice = Color.Gray;
      this.fontColorVoice = Color.White;
    }
  }

  //手势结束业务
  doGestureEndBusiness(): void {
    // 发送语音，计算时间
    if (this.mode === VerifyModeEnum.VOICE) {
      this.timeEnd = Math.floor(new Date().getTime() / Const.ANIMATION_DURATION);
      this.timeAv = this.timeEnd - this.timeStart;
      let messageId: String = new String(this.messages.length + 1);
      this.messages.push({
        id: messageId.toString(),
        sender: Const.SENDER,
        avatar: "app.media.voice_record_dynamic_effect_avatar_own",
        type: 1,
        content: new String(this.timeAv).toString()
      })
    } else if (this.mode === VerifyModeEnum.TEXT) {
      let messageId: String = new String(this.messages.length + 1);
      this.messages.push({
        id: messageId.toString(),
        sender: Const.SENDER,
        avatar: "app.media.voice_record_dynamic_effect_avatar_own",
        type: 0,
        content: Const.VERIFY_TEXT
      })
    }
    this.resetState();
    clearInterval(this.count);
    this.isListening = false;
    animateTo({ duration: Const.OPACITY_FALSE }, () => {
      this.yMax = Const.OPACITY_FALSE;
      this.yMin = Const.OPACITY_FALSE;
    })
    this.flagUpOpacity = Const.OPACITY_FALSE;
    if (this.mode === VerifyModeEnum.VOICE) {
      this.flagInfoOpacity = Const.OPACITY_TRUE;
    }
    this.AVRecord.stopRecordingProcess();
    // 手势业务结束消息列表滚动到底部
    this.scroller.scrollEdge(Edge.Bottom);
  }

  @Builder
  buildMessage(message: Message) {
    Row({ space: Const.BLANK_row }) {
      if (message.sender === Const.SENDER) {
        if (message.type === MessageType.TEXT) {
          //文本消息
          Text(message.content)
            .fontSize($r("app.integer.voice_record_dynamic_effect_font_size_text"))
            .textAlign(TextAlign.Center)
            .margin($r("app.integer.voice_record_message_margin"))
            .backgroundColor($r("app.color.voice_record_dynamic_effect_color_message"))
            .padding({
              left: $r("app.integer.voice_record_dynamic_effect_margin"),
              right: $r("app.integer.voice_record_dynamic_effect_margin"),
              top: $r("app.integer.voice_record_dynamic_effect_margin"),
              bottom: $r("app.integer.voice_record_dynamic_effect_margin")
            })
            .borderRadius(Const.COLUMN_WIDTH)
        } else {
          //语音消息
          Row() {
            Image($r("app.media.voice_record_dynamic_effect_volume"))
              .id('voice_add_image')
              .width($r("app.integer.voice_record_dynamic_effect_width_image"))
              .height($r("app.integer.voice_record_dynamic_effect_height_image"))
            Text(message.content)
              .fontSize($r("app.integer.voice_record_dynamic_effect_font_size_text"))
              .margin($r("app.integer.voice_record_message_margin"))
          }
          .borderRadius(Const.COLUMN_WIDTH)
          .justifyContent(FlexAlign.End)
          .width(Number(message.content) * Const.COLUMN_WIDTH + Const.HEIGHT_MIN)
          .backgroundColor($r("app.color.voice_record_dynamic_effect_color_message"))
          .margin({ top: $r('app.integer.voice_record_dynamic_effect_margin_top') })
          .padding({
            left: $r("app.integer.voice_record_dynamic_effect_margin"),
            right: $r("app.integer.voice_record_dynamic_effect_margin")
          })
          .onClick(() => {
            this.AVPlayer.avPlayerUrlDemo();
          })
        }
        //头像
        Image($r("app.media.voice_record_dynamic_effect_avatar_own"))
          .width($r("app.integer.voice_record_dynamic_effect_width_image"))
          .height($r("app.integer.voice_record_dynamic_effect_height_image"))
      } else {
        //头像
        Image($r("app.media.voice_record_dynamic_effect_avatar_friend"))
          .width($r("app.integer.voice_record_dynamic_effect_width_image"))
          .height($r("app.integer.voice_record_dynamic_effect_height_image"))
        //文本消息
        Text(message.content)
          .fontSize($r("app.integer.voice_record_dynamic_effect_font_size_text"))
          .textAlign(TextAlign.Center)
          .margin($r("app.integer.voice_record_message_margin"))
          .backgroundColor(Color.White)
          .padding({
            left: $r("app.integer.voice_record_dynamic_effect_margin"),
            right: $r("app.integer.voice_record_dynamic_effect_margin"),
            top: $r("app.integer.voice_record_dynamic_effect_margin"),
            bottom: $r("app.integer.voice_record_dynamic_effect_margin")
          })
          .borderRadius(Const.COLUMN_WIDTH)
      }
    }
    .justifyContent(message.sender === Const.SENDER ? FlexAlign.End : FlexAlign.Start)
    .width($r('app.string.voice_record_dynamic_effect_width_full'))
    .margin({ top: $r('app.integer.voice_record_dynamic_effect_margin_top') })
    .padding({
      left: $r("app.integer.voice_record_dynamic_effect_margin"),
      right: $r("app.integer.voice_record_dynamic_effect_margin")
    })
  }

  build() {
    Stack() {
      Column() {
        Row() {
          Image($r("app.media.voice_record_dynamic_effect_left"))
            .width($r("app.integer.voice_record_dynamic_effect_width_image"))
            .height($r("app.integer.voice_record_dynamic_effect_height_image"))
          Text($r("app.string.voice_record_dynamic_effect_friend"))
            .fontSize($r("app.integer.voice_record_dynamic_effect_font_size_text"))
            .textAlign(TextAlign.Center)
          Image($r("app.media.voice_record_dynamic_effect_qmz0nuwq"))
            .width($r("app.integer.voice_record_dynamic_effect_width_image"))
            .height($r("app.integer.voice_record_dynamic_effect_height_image"))
        }
        .backgroundColor($r("app.color.voice_record_dynamic_effect_color_all"))
        .justifyContent(FlexAlign.SpaceBetween)
        .width($r('app.string.voice_record_dynamic_effect_width_full'))
        .padding($r("app.integer.voice_record_dynamic_effect_padding_row"))

        Column() {
          List({ scroller: this.scroller }) {
            ForEach(this.messages, (item: Message) => {
              ListItem() {
                this.buildMessage(item)
              }
            }, (item: Message) => item.id)
          }
          .width($r('app.string.voice_record_dynamic_effect_width_full'))
          .height($r('app.string.voice_record_dynamic_effect_width_full'))
        }
        .backgroundColor($r("app.color.voice_record_dynamic_effect_color_all"))
        .justifyContent(FlexAlign.Start)
        .width($r('app.string.voice_record_dynamic_effect_width_full'))
        .layoutWeight(1)

        //底部按钮行
        Row() {
          Image($r("app.media.voice_record_dynamic_effect_icon"))
            .width($r("app.integer.voice_record_dynamic_effect_width_image"))
            .height($r("app.integer.voice_record_dynamic_effect_height_image"))
          Button($r("app.string.voice_record_dynamic_effect_button"))
            .type(ButtonType.Normal)
            .borderRadius($r("app.integer.voice_record_border_radio"))
            .backgroundColor(Color.White)
            .width($r("app.integer.voice_record_dynamic_effect_width_button"))
            .height($r("app.integer.voice_record_dynamic_effect_height_button"))
            .fontColor(Color.Black)
            .gesture(
              GestureGroup(GestureMode.Sequence,
                LongPressGesture()
                  .onAction(() => {
                    this.mode = VerifyModeEnum.VOICE;
                    // 获取时间戳
                    this.timeStart = Math.floor(new Date().getTime() / Const.ANIMATION_DURATION);
                    this.flagInfoOpacity = Const.OPACITY_FALSE;
                    this.isListening = !this.isListening;
                    this.flagUpOpacity = Const.OPACITY_TRUE;
                    this.AVRecord.startRecordingProcess();
                    // 每隔100ms获取一次振幅
                    this.count = setInterval(() => {
                      if (this.AVRecord.maxAmplitude > Const.MIN_AMPLITUDE) {
                        this.maxNumber = (this.AVRecord.maxAmplitude) / Const.MAX_AMPLITUDE * Const.COLUMN_HEIGHT;
                        this.maxNumber = this.maxNumber >= 60 ? 60 : this.maxNumber;
                        this.minNumber = this.maxNumber - Const.HEIGHT_MIN;
                      } else {
                        this.maxNumber = Const.OPACITY_FALSE;
                        this.minNumber = Const.OPACITY_FALSE;
                      }
                      if (this.isListening) {
                        animateTo({ duration: Const.ANIMATION_DURATION, curve: Curve.EaseInOut }, () => {
                          this.yMax = Math.round(Math.random() * 60);
                          this.yMin = Math.round(Math.random() * 20);
                        })
                      }
                    }, Const.SET_INTERVAL_TIME);
                  })
                  .onActionEnd(() => {
                    clearInterval(this.count);
                    this.flagInfoOpacity = Const.OPACITY_TRUE;
                    this.yMax = Const.OPACITY_FALSE;
                    this.yMin = Const.OPACITY_FALSE;
                    this.AVRecord.stopRecordingProcess();
                  }),
                // 上划左边取消，右边转文字
                PanGesture({ direction: PanDirection.Left | PanDirection.Right | PanDirection.Up, distance: 50 })
                  .onActionStart((event: GestureEvent) => {
                    const offsetX = event.offsetX;
                    const offsetY = event.offsetY;
                    // 0=语音录制，1=转文字，2=取消
                    this.mode = getMode(offsetX, offsetY);
                    this.updateStateByMode();
                  })
                  .onActionUpdate((event: GestureEvent) => {
                    const offsetX = event.offsetX;
                    const offsetY = event.offsetY;
                    // 0=语音录制，1=转文字，2=取消
                    this.mode = getMode(offsetX, offsetY);
                    this.updateStateByMode();
                  })
                  .onActionEnd(() => {
                    this.doGestureEndBusiness();
                  })
              )
                .onCancel(() => {
                  if (this.timeStart === Const.OPACITY_FALSE) {
                    promptAction.showToast({
                      message: $r("app.string.voice_record_verify_too_short"),
                      duration: 1000
                    })
                    return;
                  }
                  this.doGestureEndBusiness();
                })
            )
          Image($r("app.media.voice_record_dynamic_effect_emoji"))
            .width($r("app.integer.voice_record_dynamic_effect_width_image"))
            .height($r("app.integer.voice_record_dynamic_effect_height_image"))
          Image($r("app.media.voice_record_dynamic_effect_add"))
            .width($r("app.integer.voice_record_dynamic_effect_width_image"))
            .height($r("app.integer.voice_record_dynamic_effect_height_image"))
        }
        .justifyContent(FlexAlign.SpaceAround)
        .width($r('app.string.voice_record_dynamic_effect_width_full'))
        .height($r("app.integer.voice_record_dynamic_effect_height_row"))
        .backgroundColor($r("app.color.voice_record_dynamic_effect_color_row"))
      }
      .backgroundColor($r("app.color.voice_record_dynamic_effect_color_row"))
      .width($r('app.string.voice_record_dynamic_effect_width_full'))
      .height($r("app.string.voice_record_dynamic_effect_height_full"))

      if (this.flagUpOpacity === 1) {
        Column() {
          Row() {
            ButtonWithWaterRipples({
              columnX: this.columnX,
              yMax: this.yMax,
              yMin: this.yMin,
              waterRipplesBg: this.waterRipplesBg,
              mode: this.mode
            });
          }
          .justifyContent(FlexAlign.Center)
          .width($r('app.string.voice_record_dynamic_effect_width_full'))
          .height($r('app.string.voice_record_water_height'))
          .margin({ bottom: $r("app.integer.voice_record_dynamic_effect_margin") })

          Row() {
            Column() {
              if (this.mode === VerifyModeEnum.CANCEL) {
                Text($r("app.string.voice_record_cancel_send"))
                  .fontSize($r("app.integer.voice_record_dynamic_effect_font_size_text"))
                  .fontColor(Color.White)
                  .textAlign(TextAlign.Center)
                  .margin({ bottom: $r("app.integer.voice_record_message_margin") })
              }
              Text('X')
                .fontSize($r("app.integer.voice_record_font_size_mode"))
                .fontColor(this.fontColorCancel)
                .textAlign(TextAlign.Center)
                .height(this.textSize)
                .width(this.textSize)
                .backgroundColor(this.backgroundCancel)
                .borderRadius($r("app.string.voice_record_border_radius_percent"))
            }.width($r('app.string.voice_record_height_mode')).justifyContent(FlexAlign.Center)

            Column() {
              if (this.mode === VerifyModeEnum.TEXT) {
                Text($r("app.string.voice_record_translate_word"))
                  .fontSize($r("app.integer.voice_record_dynamic_effect_font_size_text"))
                  .fontColor(Color.White)
                  .textAlign(TextAlign.Center)
                  .margin({ bottom: $r("app.integer.voice_record_message_margin") })
              }
              Text($r("app.string.voice_record_word"))
                .fontSize($r("app.integer.voice_record_font_size_mode"))
                .fontColor(this.fontColorWord)
                .textAlign(TextAlign.Center)
                .height(this.textSize)
                .width(this.textSize)
                .backgroundColor(this.backgroundWord)
                .borderRadius($r("app.string.voice_record_border_radius_percent"))
            }.width($r('app.string.voice_record_height_mode')).justifyContent(FlexAlign.Center)
          }
          .justifyContent(FlexAlign.SpaceAround)
          .width($r('app.string.voice_record_dynamic_effect_width_full'))
          .height($r('app.string.voice_record_mode_height'))
          .margin({ bottom: $r("app.integer.voice_record_dynamic_effect_margin") })

          Row() {
            Text($r("app.string.voice_record_dynamic_effect_send_message"))
              .fontSize($r("app.integer.voice_record_dynamic_effect_font_size_text"))
              .fontColor(this.fontColorVoice)
          }
          .justifyContent(FlexAlign.Center)
          .height(Const.HEIGHT_ST)
          .width($r('app.string.voice_record_dynamic_effect_width_full'))
          .borderRadius($r("app.integer.voice_record_dynamic_effect_radius_row"))
          .backgroundColor(this.backgroundVoice)
        }
        .justifyContent(FlexAlign.End)
        .backgroundColor($r("app.string.voice_record_dynamic_effect_color_stack"))
        .width($r('app.string.voice_record_dynamic_effect_width_full'))
        .height($r("app.string.voice_record_dynamic_effect_height_full"))
      }
    }
    .alignContent(Alignment.Bottom)
    .width($r('app.string.voice_record_dynamic_effect_width_full'))
    .height($r("app.string.voice_record_dynamic_effect_height_full"))
  }
}