import router from '@ohos.router';

@Entry
@Component
struct SliderExample {
  @State outSetValueOne: number = 40;
  @State inSetValueOne: number = 40;
  @State noneValueOne: number = 40;
  @State outSetValueTwo: number = 40;
  @State inSetValueTwo: number = 40;
  @State vOutSetValueOne: number = 40;
  @State vInSetValueOne: number = 40;
  @State vOutSetValueTwo: number = 40;
  @State vInSetValueTwo: number = 40;
  // 支持边界值测试
  @State hapticValue: boolean | null | undefined | string = true;
  @State currentTestCase: string = 'true';

  build() {
    Column({ space: 16 }) {
      // 顶部导航栏
      Row() {
        Button({ type: ButtonType.Circle }) {
          Image($r('app.media.ic_back'))
            .width(20)
            .height(20)
            .fillColor('#666666')
        }
        .width(40)
        .height(40)
        .backgroundColor('#f5f5f5')
        .onClick(() => {
          router.back();
        })

        Blank()

        Text('Slider 组件')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1a1a1a')

        Blank()

        // 状态指示器
        Row({ space: 6 }) {
          Circle()
            .width(8)
            .height(8)
            .fill(this.getStatusColor())
          Text(this.getStatusText())
            .fontSize(12)
            .fontColor('#666666')
        }
        .padding({
          left: 10,
          right: 10,
          top: 4,
          bottom: 4
        })
        .backgroundColor('#f5f5f5')
        .borderRadius(12)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#ffffff')

      // 标题区域
      Column({ space: 8 }) {
        Text('Slider 滑动条')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1a1a1a')
          .letterSpacing(0.5)
        Text('滑动选择与数值调节')
          .fontSize(14)
          .fontColor('#999999')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({
        left: 20,
        right: 20,
        top: 8,
        bottom: 12
      })

      // 边界值测试控制
      Column({ space: 8 }) {
        Text('enableHapticFeedback 参数: ')
          .fontSize(13)
          .fontColor('#666666')
          .width('100%')

        Row({ space: 6 }) {
          this.ValueButton('true', true)
          this.ValueButton('false', false)
          this.ValueButton('null', null)
          this.ValueButton('undefined', undefined)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 8 })

      // 内容区域
      Scroll() {
        Column({ space: 16 }) {
          // OutSet 样式卡片
          Column({ space: 16 }) {
            Row() {
              Text('01')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#007AFF')
                .opacity(0.6)
              Blank()
              Text('OutSet')
                .fontSize(11)
                .fontColor('#007AFF')
                .padding({
                  left: 8,
                  right: 8,
                  top: 2,
                  bottom: 2
                })
                .backgroundColor('#E6F2FF')
                .borderRadius(4)
            }
            .width('100%')

            Text('外置滑块样式')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')

            // 基础滑块
            Column({ space: 8 }) {
              Row() {
                Text('基础滑块')
                  .fontSize(13)
                  .fontColor('#666666')
                Blank()
                Text(this.outSetValueOne.toFixed(0))
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#007AFF')
                  .width(40)
                  .textAlign(TextAlign.End)
              }
              .width('100%')

              Slider({
                value: this.outSetValueOne,
                min: 0,
                max: 100,
                style: SliderStyle.OutSet
              })
                .width('100%')
                .showTips(true)
                .enableHapticFeedback(this.getHapticValue())
                .onChange((value: number, mode: SliderChangeMode) => {
                  this.outSetValueOne = value;
                  console.info('value:' + value + 'mode:' + mode.toString());
                })
            }
            .width('100%')

            Divider().color('#f0f0f0').strokeWidth(1)

            // 带刻度滑块
            Column({ space: 8 }) {
              Row() {
                Text('刻度步进')
                  .fontSize(13)
                  .fontColor('#666666')
                Blank()
                Text(this.outSetValueTwo.toFixed(0))
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#007AFF')
                  .width(40)
                  .textAlign(TextAlign.End)
              }
              .width('100%')

              Slider({
                value: this.outSetValueTwo,
                step: 10,
                style: SliderStyle.OutSet
              })
                .width('100%')
                .showSteps(true)
                .enableHapticFeedback(this.getHapticValue())
                .onChange((value: number, mode: SliderChangeMode) => {
                  this.outSetValueTwo = value;
                  console.info('value:' + value + 'mode:' + mode.toString());
                })
            }
            .width('100%')
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#ffffff')
          .borderRadius(16)
          .shadow({
            radius: 8,
            color: '#00000008',
            offsetX: 0,
            offsetY: 2
          })

          // InSet 样式卡片
          Column({ space: 16 }) {
            Row() {
              Text('02')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#5856D6')
                .opacity(0.6)
              Blank()
              Text('InSet')
                .fontSize(11)
                .fontColor('#5856D6')
                .padding({
                  left: 8,
                  right: 8,
                  top: 2,
                  bottom: 2
                })
                .backgroundColor('#F0EFFF')
                .borderRadius(4)
            }
            .width('100%')

            Text('内置滑块样式')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')

            // 基础滑块
            Column({ space: 8 }) {
              Row() {
                Text('自定义颜色')
                  .fontSize(13)
                  .fontColor('#666666')
                Blank()
                Text(this.inSetValueOne.toFixed(0))
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#5856D6')
                  .width(40)
                  .textAlign(TextAlign.End)
              }
              .width('100%')

              Slider({
                value: this.inSetValueOne,
                min: 0,
                max: 100,
                style: SliderStyle.InSet
              })
                .width('100%')
                .blockColor('#5856D6')
                .trackColor('#E8E8F0')
                .selectedColor('#5856D6')
                .showTips(true)
                .enableHapticFeedback(this.getHapticValue())
                .onChange((value: number, mode: SliderChangeMode) => {
                  this.inSetValueOne = value;
                  console.info('value:' + value + 'mode:' + mode.toString());
                })
            }
            .width('100%')

            Divider().color('#f0f0f0').strokeWidth(1)

            // 带刻度滑块
            Column({ space: 8 }) {
              Row() {
                Text('刻度步进')
                  .fontSize(13)
                  .fontColor('#666666')
                Blank()
                Text(this.inSetValueTwo.toFixed(0))
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#5856D6')
                  .width(40)
                  .textAlign(TextAlign.End)
              }
              .width('100%')

              Slider({
                value: this.inSetValueTwo,
                step: 10,
                style: SliderStyle.InSet
              })
                .width('100%')
                .blockColor('#5856D6')
                .trackColor('#E8E8F0')
                .selectedColor('#5856D6')
                .showSteps(true)
                .enableHapticFeedback(this.getHapticValue())
                .onChange((value: number, mode: SliderChangeMode) => {
                  this.inSetValueTwo = value;
                  console.info('value:' + value + 'mode:' + mode.toString());
                })
            }
            .width('100%')
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#ffffff')
          .borderRadius(16)
          .shadow({
            radius: 8,
            color: '#00000008',
            offsetX: 0,
            offsetY: 2
          })

          // 垂直滑块卡片
          Column({ space: 16 }) {
            Row() {
              Text('03')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#34C759')
                .opacity(0.6)
              Blank()
              Text('Vertical')
                .fontSize(11)
                .fontColor('#34C759')
                .padding({
                  left: 8,
                  right: 8,
                  top: 2,
                  bottom: 2
                })
                .backgroundColor('#E8F5E9')
                .borderRadius(4)
            }
            .width('100%')

            Text('垂直方向')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')

            // 垂直滑块区域 - 使用固定高度
            Column({ space: 16 }) {
              // 外置样式组
              Column({ space: 8 }) {
                Text('外置样式')
                  .fontSize(13)
                  .fontColor('#666666')

                Row({ space: 40 }) {
                  // 第一个垂直滑块
                  Column({ space: 8 }) {
                    Slider({
                      value: this.vOutSetValueOne,
                      style: SliderStyle.OutSet,
                      direction: Axis.Vertical
                    })
                      .width(40)
                      .height(150)
                      .blockColor('#34C759')
                      .trackColor('#E8F5E9')
                      .selectedColor('#34C759')
                      .showTips(true)
                      .enableHapticFeedback(this.getHapticValue())
                      .onChange((value: number, mode: SliderChangeMode) => {
                        this.vOutSetValueOne = value;
                        console.info('value:' + value + 'mode:' + mode.toString());
                      })
                    Text(this.vOutSetValueOne.toFixed(0))
                      .fontSize(14)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#34C759')
                  }

                  // 第二个垂直滑块（带刻度）
                  Column({ space: 8 }) {
                    Slider({
                      value: this.vOutSetValueTwo,
                      step: 10,
                      style: SliderStyle.OutSet,
                      direction: Axis.Vertical
                    })
                      .width(40)
                      .height(150)
                      .blockColor('#34C759')
                      .trackColor('#E8F5E9')
                      .selectedColor('#34C759')
                      .showSteps(true)
                      .enableHapticFeedback(this.getHapticValue())
                      .onChange((value: number, mode: SliderChangeMode) => {
                        this.vOutSetValueTwo = value;
                        console.info('value:' + value + 'mode:' + mode.toString());
                      })
                    Text(this.vOutSetValueTwo.toFixed(0))
                      .fontSize(14)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#34C759')
                  }
                }
                .width('100%')
                .justifyContent(FlexAlign.Center)
              }
              .width('100%')

              Divider().color('#f0f0f0').strokeWidth(1)

              // 内置样式组
              Column({ space: 8 }) {
                Text('内置样式')
                  .fontSize(13)
                  .fontColor('#666666')

                Row({ space: 40 }) {
                  // 第三个垂直滑块
                  Column({ space: 8 }) {
                    Slider({
                      value: this.vInSetValueOne,
                      style: SliderStyle.InSet,
                      direction: Axis.Vertical,
                      reverse: true
                    })
                      .width(40)
                      .height(150)
                      .showTips(true)
                      .enableHapticFeedback(this.getHapticValue())
                      .onChange((value: number, mode: SliderChangeMode) => {
                        this.vInSetValueOne = value;
                        console.info('value:' + value + 'mode:' + mode.toString());
                      })
                    Text(this.vInSetValueOne.toFixed(0))
                      .fontSize(14)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#666666')
                  }

                  // 第四个垂直滑块（带刻度）
                  Column({ space: 8 }) {
                    Slider({
                      value: this.vInSetValueTwo,
                      step: 10,
                      style: SliderStyle.InSet,
                      direction: Axis.Vertical,
                      reverse: true
                    })
                      .width(40)
                      .height(150)
                      .showSteps(true)
                      .enableHapticFeedback(this.getHapticValue())
                      .onChange((value: number, mode: SliderChangeMode) => {
                        this.vInSetValueTwo = value;
                        console.info('value:' + value + 'mode:' + mode.toString());
                      })
                    Text(this.vInSetValueTwo.toFixed(0))
                      .fontSize(14)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#666666')
                  }
                }
                .width('100%')
                .justifyContent(FlexAlign.Center)
              }
              .width('100%')
            }
            .width('100%')
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#ffffff')
          .borderRadius(16)
          .shadow({
            radius: 8,
            color: '#00000008',
            offsetX: 0,
            offsetY: 2
          })

          // 底部留白
          Blank().height(20)
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f7')
  }

  /**
   * 获取触觉反馈值 - 处理 Optional<boolean> 类型
   * 规则：
   * - true / 'true' (字符串) → true (开启震动)
   * - false → false (关闭震动)
   * - null / undefined / '' → undefined (使用组件默认值)
   */
  private getHapticValue(): boolean | undefined | null {
    if (this.hapticValue === true) {
      return true;
    }
    if (this.hapticValue === false) {
      return false;
    }
    if (this.hapticValue === null) {
      return null;
    }
    return undefined;
  }

  /**
   * 获取用于显示的状态值（将 undefined 视为 false 用于显示）
   */
  private getDisplayStatus(): boolean {
    const val = this.getHapticValue();
    return val === true;
  }

  // 获取状态颜色
  private getStatusColor(): string {
    return this.getDisplayStatus() ? '#34C759' : '#FF3B30';
  }

  // 获取状态文本
  private getStatusText(): string {
    const val = this.hapticValue;
    if (val === null) {
      return '触感默认(true)';
    }
    if (val === undefined) {
      return '触感默认(true)';
    }
    return this.getDisplayStatus() ? '触感开启' : '触感关闭';
  }

  @Builder
  ValueButton(label: string, value: boolean | null | undefined) {
    Button(label)
      .fontSize(11)
      .fontColor(this.currentTestCase === label ? '#ffffff' : '#1a1a1a')
      .backgroundColor(this.currentTestCase === label ? '#007AFF' : '#f5f5f5')
      .borderRadius(6)
      .height(28)
      .padding({ left: 8, right: 8 })
      .onClick(() => {
        this.hapticValue = value;
        this.currentTestCase = label;
      })
  }
}