import router from '@ohos.router';

@Entry
@Component
struct UIPickerComponentAttrsExample {
  private dataArray: string[] = [];
  @State loop: boolean = true;
  // 支持边界值测试
  @State hapticValue: boolean | null | undefined | string = true;
  @State currentTestCase: string = 'true';

  aboutToAppear(): void {
    // 构造选项数据 1-10
    for (let i = 1; i <= 10; i++) {
      this.dataArray.push(i.toString());
    }
  }

  build() {
    Column({ space: 0 }) {
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

        Text('UI Picker')
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
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#ffffff')

      // 标题区域
      Column({ space: 8 }) {
        Text('UI Picker')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1a1a1a')
          .letterSpacing(0.5)
        Text('轻量级选择器组件')
          .fontSize(14)
          .fontColor('#999999')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({
        left: 20,
        right: 20,
        top: 16,
        bottom: 20
      })
      .backgroundColor('#ffffff')

      // 内容区域
      Scroll() {
        Column({ space: 16 }) {
          // Picker 展示卡片
          Column({ space: 16 }) {
            Row() {
              Text('01')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#AF52DE')
                .opacity(0.6)
              Blank()
              Text('UIPicker')
                .fontSize(11)
                .fontColor('#AF52DE')
                .padding({
                  left: 8,
                  right: 8,
                  top: 2,
                  bottom: 2
                })
                .backgroundColor('#F5E8FF')
                .borderRadius(4)
            }
            .width('100%')

            Text('数字选择器')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')

            // Picker 组件
            UIPickerComponent() {
              ForEach(this.dataArray, (item: string) => {
                Text(item)
                  .fontSize(20)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#AF52DE')
                  .height(40)
              }, (item: string) => item)
            }
            .canLoop(this.loop)
            .enableHapticFeedback(this.getHapticValue())
            .width('100%')
            .height(200)
            .backgroundColor('#f8f9fa')
            .borderRadius(12)

            // 当前选中值展示
            Row() {
              Text('当前选择范围')
                .fontSize(13)
                .fontColor('#666666')
              Blank()
              Text('1 - 10')
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#AF52DE')
            }
            .width('100%')
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#ffffff')
          .borderRadius(16)
          .shadow({
            radius: 8,
            color: '#ffffff',
            offsetX: 0,
            offsetY: 2
          })

          // 设置选项卡片
          Column({ space: 16 }) {
            Row() {
              Text('02')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#5856D6')
                .opacity(0.6)
              Blank()
              Text('Settings')
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

            Text('组件设置')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')

            // 循环滚动开关
            Row() {
              Column({ space: 4 }) {
                Text('循环滚动')
                  .fontSize(15)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#1a1a1a')
                Text('开启后选择器可无限循环滚动')
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .alignItems(HorizontalAlign.Start)

              Blank()

              Toggle({ type: ToggleType.Switch, isOn: this.loop })
                .selectedColor('#5856D6')
                .onChange((isOn: boolean) => {
                  this.loop = isOn;
                })
            }
            .width('100%')

            Divider().color('#f0f0f0').strokeWidth(1)

            // 边界值测试按钮
            Column({ space: 8 }) {
              Text('enableHapticFeedback 参数测试')
                .fontSize(14)
                .fontColor('#666666')
                .width('100%')

              Row({ space: 6 }) {
                this.ValueButton('true', true)
                this.ValueButton('false', false)
                this.ValueButton('null', null)
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)

              Row({ space: 6 }) {
                this.ValueButton('undefined', undefined)
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)

              // 当前值显示
              Row() {
                Text('当前: ' + this.currentTestCase)
                  .fontSize(13)
                  .fontColor('#007AFF')
                Blank()
              }
              .width('100%')
              .padding({ top: 4 })
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
        .padding({ left: 16, right: 16, top: 8 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundColor('#f5f5f7')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f7')
  }

  /**
   * 获取触觉反馈值 - 处理 Optional<boolean> 类型
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
   * 获取用于显示的状态值
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
      .fontSize(12)
      .fontColor(this.currentTestCase === label ? '#ffffff' : '#1a1a1a')
      .backgroundColor(this.currentTestCase === label ? '#5856D6' : '#f5f5f5')
      .borderRadius(6)
      .height(32)
      .padding({ left: 10, right: 10 })
      .onClick(() => {
        this.hapticValue = value;
        this.currentTestCase = label;
      })
  }
}


