import router from '@ohos.router';
import { systemDateTime } from '@kit.BasicServicesKit';

@Entry
@Component
struct PlaybackRateTest {
  private controller: VideoController = new VideoController();
  private enumOptions: SelectOption[] = [
    { value: '未设置' },
    { value: 'SPEED_FORWARD_0_50_X' },
    { value: 'SPEED_FORWARD_1_50_X' },
    { value: 'SPEED_FORWARD_3_00_X' },
    { value: 'SPEED_FORWARD_0_25_X' },
    { value: 'SPEED_FORWARD_0_125_X' }
  ];
  private numberOptions: SelectOption[] = [
    { value: '未设置' },
    { value: '0.5' },
    { value: '1.5' },
    { value: '3' },
    { value: '0.25' },
    { value: '0.125' },
    { value: '5' }
  ];
  private stringOptions: SelectOption[] = [
    { value: '未设置' },
    { value: '"0.5"' },
    { value: '"1.5"' },
    { value: '"3"' },
    { value: '"0.25"' },
    { value: '"0.125"' },
    { value: '"abc"' }
  ];

  @State currentVideo: Resource = $rawfile('test1.mp4');
  @State playerVersion: number = 0;
  @State currentTime: number = 0;
  @State duration: number = 0;
  @State rateInputType: number = 0;
  @State enumRate: PlaybackSpeed = PlaybackSpeed.Speed_Forward_1_00_X;
  @State numberRate: number = 1;
  @State stringRate: string = '1';
  @State enumSelected: number = 0;
  @State numberSelected: number = 0;
  @State stringSelected: number = 0;
  @State currentRateLabel: string = '未设置';
  @State currentRateExpected: string = '默认按 1 倍速播放';
  @State statusText: string = '未播放';
  @State lastEvent: string = '等待操作';
  @State startTime: number = 0;
  @State endTime: number = 0;
  @State realRate: number = 1;

  private buildVideoOptions(): VideoOptions {
    let options: VideoOptions = {
      src: this.currentVideo,
      controller: this.controller
    };

    if (this.rateInputType === 1) {
      options.currentProgressRate = this.enumRate;
    } else if (this.rateInputType === 2) {
      options.currentProgressRate = this.numberRate;
    } else if (this.rateInputType === 3) {
      options.currentProgressRate = this.stringRate;
    }

    return options;
  }

  private reloadPlayer(): void {
    this.controller.stop();
    this.controller = new VideoController();
    this.currentTime = 0;
    this.duration = 0;
    this.statusText = '已重新装载视频';
    this.realRate = 0;
    this.playerVersion = this.playerVersion + 1;
  }

  private applyEnumRate(rate: PlaybackSpeed, label: string, expected: string): void {
    this.rateInputType = 1;
    this.enumRate = rate;
    this.numberSelected = 0;
    this.stringSelected = 0;
    this.currentRateLabel = label;
    this.currentRateExpected = expected;
    this.realRate = 0;
    this.lastEvent = '已设置倍速输入: ' + label;
    this.reloadPlayer();
  }

  private applyNumberRate(rate: number, label: string, expected: string): void {
    this.rateInputType = 2;
    this.numberRate = rate;
    this.enumSelected = 0;
    this.stringSelected = 0;
    this.currentRateLabel = label;
    this.currentRateExpected = expected;
    this.realRate = 0;
    this.lastEvent = '已设置倍速输入: ' + label;
    this.reloadPlayer();
  }

  private applyStringRate(rate: string, label: string, expected: string): void {
    this.rateInputType = 3;
    this.stringRate = rate;
    this.enumSelected = 0;
    this.numberSelected = 0;
    this.currentRateLabel = label;
    this.currentRateExpected = expected;
    this.realRate = 0;
    this.lastEvent = '已设置倍速输入: ' + label;
    this.reloadPlayer();
  }

  private clearRateCase(): void {
    this.rateInputType = 0;
    this.enumSelected = 0;
    this.numberSelected = 0;
    this.stringSelected = 0;
    this.currentRateLabel = '未设置';
    this.currentRateExpected = '默认按 1 倍速播放';
    this.lastEvent = '已清空 currentProgressRate';
    this.reloadPlayer();
  }

  private onEnumSelect(index: number): void {
    this.enumSelected = index;
    if (index === 0) {
      this.clearRateCase();
    } else if (index === 1) {
      this.applyEnumRate(PlaybackSpeed.SPEED_FORWARD_0_50_X, 'PlaybackSpeed.SPEED_FORWARD_0_50_X', '视频按 0.5 倍速播放');
    } else if (index === 2) {
      this.applyEnumRate(PlaybackSpeed.SPEED_FORWARD_1_50_X, 'PlaybackSpeed.SPEED_FORWARD_1_50_X', '视频按 1.5 倍速播放');
    } else if (index === 3) {
      this.applyEnumRate(PlaybackSpeed.SPEED_FORWARD_3_00_X, 'PlaybackSpeed.SPEED_FORWARD_3_00_X', '视频按 3.0 倍速播放');
    } else if (index === 4) {
      this.applyEnumRate(PlaybackSpeed.SPEED_FORWARD_0_25_X, 'PlaybackSpeed.SPEED_FORWARD_0_25_X', '视频按 0.25 倍速播放');
    } else {
      this.applyEnumRate(PlaybackSpeed.SPEED_FORWARD_0_125_X, 'PlaybackSpeed.SPEED_FORWARD_0_125_X', '视频按 0.125 倍速播放');
    }
  }

  private onNumberSelect(index: number): void {
    this.numberSelected = index;
    if (index === 0) {
      this.clearRateCase();
    } else if (index === 1) {
      this.applyNumberRate(0.5, '0.5', '视频按 0.5 倍速播放');
    } else if (index === 2) {
      this.applyNumberRate(1.5, '1.5', '视频按 1.5 倍速播放');
    } else if (index === 3) {
      this.applyNumberRate(3, '3', '视频按 3.0 倍速播放');
    } else if (index === 4) {
      this.applyNumberRate(0.25, '0.25', '视频按 0.25 倍速播放');
    } else if (index === 5) {
      this.applyNumberRate(0.125, '0.125', '视频按 0.125 倍速播放');
    } else {
      this.applyNumberRate(5, '5', '视频按默认 1 倍速播放');
    }
  }

  private onStringSelect(index: number): void {
    this.stringSelected = index;
    if (index === 0) {
      this.clearRateCase();
    } else if (index === 1) {
      this.applyStringRate('0.5', '"0.5"', '视频按 0.5 倍速播放');
    } else if (index === 2) {
      this.applyStringRate('1.5', '"1.5"', '视频按 1.5 倍速播放');
    } else if (index === 3) {
      this.applyStringRate('3', '"3"', '视频按 3.0 倍速播放');
    } else if (index === 4) {
      this.applyStringRate('0.25', '"0.25"', '视频按 0.25 倍速播放');
    } else if (index === 5) {
      this.applyStringRate('0.125', '"0.125"', '视频按 0.125 倍速播放');
    } else {
      this.applyStringRate('abc', '"abc"', '异常值应按 1 倍速播放');
    }
  }

  private formatDuration(value: number): string {
    let totalSeconds: number = Math.max(0, Math.floor(value));
    let minutes: number = Math.floor(totalSeconds / 60);
    let seconds: number = totalSeconds % 60;
    let secondText: string = seconds < 10 ? '0' + seconds : '' + seconds;
    return '' + minutes + ':' + secondText;
  }

  @Builder
  private buildVideoPlayer() {
    if (this.playerVersion % 2 === 0) {
      Video(this.buildVideoOptions())
        .controls(true)
        .width('100%')
        .height(260)
        .backgroundColor('#000000')
        .borderRadius(20)
        .onPrepared((event) => {
          if (event) {
            this.duration = event.duration;
          }
          this.statusText = '视频已就绪';
          this.lastEvent = '触发 onPrepared';
        })
        .onUpdate((event) => {
          if (event) {
            this.currentTime = event.time;
            this.endTime = systemDateTime.getTime();
            this.realRate = ((this.currentTime*1000)/(this.endTime - this.startTime));
          }
        })
        .onStart(() => {
          this.statusText = '播放中';
          this.startTime = systemDateTime.getTime();
          this.endTime = systemDateTime.getTime();
        })
        .onPause(() => {
          this.statusText = '已暂停';
          this.endTime = systemDateTime.getTime();
          this.realRate = ((this.currentTime*1000)/(this.endTime - this.startTime));
          this.startTime = systemDateTime.getTime();
        })
        .onFinish(() => {
          this.statusText = '已完成';
          this.endTime = systemDateTime.getTime();
          this.realRate = ((this.currentTime*1000)/(this.endTime - this.startTime));
        })
    } else {
      Video(this.buildVideoOptions())
        .controls(true)
        .width('100%')
        .height(260)
        .backgroundColor('#000000')
        .borderRadius(20)
        .onPrepared((event) => {
          if (event) {
            this.duration = event.duration;
          }
          this.statusText = '视频已就绪';
          this.lastEvent = '触发 onPrepared';
        })
        .onUpdate((event) => {
          if (event) {
            this.currentTime = event.time;
            this.endTime = systemDateTime.getTime();
            this.realRate = ((this.currentTime*1000)/(this.endTime - this.startTime));
          }
        })
        .onStart(() => {
          this.statusText = '播放中';
          this.startTime = systemDateTime.getTime();
          this.endTime = systemDateTime.getTime();
        })
        .onPause(() => {
          this.statusText = '已暂停';
          this.endTime = systemDateTime.getTime();
          this.realRate = ((this.currentTime*1000)/(this.endTime - this.startTime));
        })
        .onFinish(() => {
          this.statusText = '已完成';
          this.endTime = systemDateTime.getTime();
          this.realRate = ((this.currentTime*1000)/(this.endTime - this.startTime));
        })
    }
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Row({ space: 12 }) {
          Button('返回上一级')
            .onClick(() => {
              router.back();
            })

          Text('倍率播放测试')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#F3F4F6')
        }
        .width('100%')

        Text('本页只验证 currentProgressRate。点击不同输入后重新装载视频，再播放观察实际倍速。')
          .fontSize(14)
          .fontColor('#B8C3D1')
          .width('100%')

        // Text('当前测试视频: test1.mp4')
        //   .fontSize(14)
        //   .fontColor('#F8D66D')
        //   .width('100%')

        Column({ space: 12 }) {
          this.buildVideoPlayer()

          Text('状态: ' + this.statusText)
            .fontSize(14)
            .fontColor('#E5E7EB')
            .width('100%')

          Text('时间: ' + this.formatDuration(this.currentTime) + ' / ' + this.formatDuration(this.duration))
            .fontSize(14)
            .fontColor('#E5E7EB')
            .width('100%')

          Text('当前输入: ' + this.currentRateLabel)
            .fontSize(14)
            .fontColor('#E5E7EB')
            .width('100%')

          Text('预期结果: ' + this.currentRateExpected)
            .fontSize(14)
            .fontColor('#F8D66D')
            .width('100%')

          // Text('实际结果: ' + this.realRate.toFixed(3) + " 倍速")
          //   .fontSize(14)
          //   .fontColor('#F8D66D')
          //   .width('100%')
        }
        .padding(20)
        .backgroundColor('#101923')
        .borderRadius(24)

        Row({ space: 10 }) {
          Button('播放').onClick(() => { this.controller.start(); })
          Button('暂停').onClick(() => { this.controller.pause(); })
          Button('重新装载').onClick(() => { this.reloadPlayer(); })
        }
        .width('100%')

        Row({ space: 8 }) {
          Column({ space: 6 }) {
            Text('枚举值')
              .fontSize(14)
              .fontColor('#F8D66D')
              .width('100%')

            Select(this.enumOptions)
              .selected(this.enumSelected)
              .value(this.enumOptions[this.enumSelected].value)
              .fontColor('#0B1220')
              .backgroundColor('#F3F4F6')
              .onSelect((index: number) => {
                this.onEnumSelect(index);
              })
              .width('100%')
          }
          .layoutWeight(1)
          .padding(10)
          .backgroundColor('#1B2838')
          .borderRadius(16)
          .alignItems(HorizontalAlign.Start)

          Column({ space: 6 }) {
            Text('数字')
              .fontSize(14)
              .fontColor('#F8D66D')
              .width('100%')

            Select(this.numberOptions)
              .selected(this.numberSelected)
              .value(this.numberOptions[this.numberSelected].value)
              .fontColor('#0B1220')
              .backgroundColor('#F3F4F6')
              .onSelect((index: number) => {
                this.onNumberSelect(index);
              })
              .width('100%')
          }
          .layoutWeight(1)
          .padding(10)
          .backgroundColor('#1B2838')
          .borderRadius(16)
          .alignItems(HorizontalAlign.Start)

          Column({ space: 6 }) {
            Text('字符串')
              .fontSize(14)
              .fontColor('#F8D66D')
              .width('100%')

            Select(this.stringOptions)
              .selected(this.stringSelected)
              .value(this.stringOptions[this.stringSelected].value)
              .fontColor('#0B1220')
              .backgroundColor('#F3F4F6')
              .onSelect((index: number) => {
                this.onStringSelect(index);
              })
              .width('100%')
          }
          .layoutWeight(1)
          .padding(10)
          .backgroundColor('#1B2838')
          .borderRadius(16)
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')

        Text('最近事件: ' + this.lastEvent)
          .fontSize(14)
          .fontColor('#B8C3D1')
          .width('100%')
      }
      .width('100%')
      .padding(20)
    }
    .scrollBar(BarState.Auto)
    .width('100%')
    .height('100%')
    .backgroundColor('#09111A')
  }
}
