import { LengthMetrics } from '@kit.ArkUI';
import router from '@ohos.router';

class Bottom {
  bottom: number = 50;
}

let bott: Bottom = new Bottom();

@Entry
@Component
struct PickerTest {
  // 支持边界值测试 - 全局控制
  @State hapticValue: boolean | null | undefined | string = true;
  @State currentTestCase: string = 'true';
  // TimePicker2 独立控制
  @State tp2HapticValue: boolean | undefined = true;
  @State tp2CurrentTestCase: string = 'true';
  @State isLunar: boolean = false;
  private selectedDate: Date = new Date('2021-08-08');
  private selectedTime: Date = new Date('2022-07-22T08:00:00');
  private selectTime: Date = new Date('2020-12-25T08:30:00');
  private select: number = 1;
  private apfruits: string[] = ['apple1', 'apple2', 'apple3', 'apple4'];
  private orfruits: string[] = ['orange1', 'orange2', 'orange3', 'orange4'];
  private pefruits: string[] = ['peach1', 'peach2', 'peach3', 'peach4'];
  private multi: string[][] = [this.apfruits, this.orfruits, this.pefruits];
  private selectText: number | number[] = 0;
  private fruits: string[] = ['apple1', 'orange2', 'peach3', 'grape4', 'banana5'];
  @State selectedValue: string = '';
  private cascade: TextCascadePickerRangeContent[] = [
    {
      text: '辽宁省',
      children: [{ text: '沈阳市', children: [{ text: '沈河区' }, { text: '和平区' }, { text: '浑南区' }] },
        { text: '大连市', children: [{ text: '中山区' }, { text: '金州区' }, { text: '长海县' }] }]
    },
    {
      text: '吉林省',
      children: [{ text: '长春市', children: [{ text: '南关区' }, { text: '宽城区' }, { text: '朝阳区' }] },
        { text: '四平市', children: [{ text: '铁西区' }, { text: '铁东区' }, { text: '梨树县' }] }]
    },
    {
      text: '黑龙江省',
      children: [{ text: '哈尔滨市', children: [{ text: '道里区' }, { text: '道外区' }, { text: '南岗区' }] },
        { text: '牡丹江市', children: [{ text: '东安区' }, { text: '西安区' }, { text: '爱民区' }] }]
    }
  ];
  private singleColumnWidths: LengthMetrics[] = [
    LengthMetrics.percent(50)
  ];
  private multipleColumnWidths: LengthMetrics[] = [
    LengthMetrics.vp(100),
    LengthMetrics.vp(200),
    LengthMetrics.vp(100)
  ];
  private cascadeColumnWidths: LengthMetrics[] = [
    LengthMetrics.percent(20),
    LengthMetrics.percent(30),
    LengthMetrics.percent(50)
  ];

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
          router.back()
        })

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
        Text('Picker 组件')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1a1a1a')
          .letterSpacing(0.5)
        Text('日期时间选择器交互演示')
          .fontSize(14)
          .fontColor('#999999')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({
        left: 20,
        right: 20,
        top: 8,
        bottom: 16
      })

      // 控制按钮
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
      .padding(12)
      .margin({ left: 16, right: 16, bottom: 8 })
      .backgroundColor('#ffffff')
      .borderRadius(12)

      // 内容区域
      Scroll() {
        Column({ space: 16 }) {
          // DatePicker 卡片
          Column({ space: 12 }) {
            Row() {
              Text('01')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#007AFF')
                .opacity(0.6)
              Blank()
              Text('DatePicker')
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

            Text('日期选择器')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')

            Button(this.isLunar ? '切换为公历' : '切换为农历')
              .fontSize(13)
              .fontColor('#007AFF')
              .backgroundColor('#E6F2FF')
              .borderRadius(8)
              .height(36)
              .onClick(() => {
                this.isLunar = !this.isLunar
              })

            DatePicker({
              start: new Date('1970-1-1'),
              end: new Date('2100-1-1'),
              selected: this.selectedDate
            })
              .canLoop(true)
              .lunar(this.isLunar)
              .enableHapticFeedback(this.getHapticValue())

              .onDateChange((value: Date) => {
                this.selectedDate = value
                console.info('select current date is: ' + value.toString())
              })
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

          // TimePicker 卡片
          Column({ space: 12 }) {
            Row() {
              Text('02')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#5856D6')
                .opacity(0.6)
              Blank()
              Text('TimePicker')
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

            Text('时间选择器')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')

            TimePicker({
              selected: this.selectedTime
            })
              .enableCascade(true)
              .loop(true)
              .enableHapticFeedback(this.getHapticValue())
              .onChange((value: TimePickerResult) => {
                if (value.hour >= 0) {
                  this.selectedTime.setHours(value.hour, value.minute)
                  console.info('select current date is: ' + JSON.stringify(value))
                }
              })
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


          Column({ space: 12 }) {
            Row() {
              Text('03')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FF3B30')
                .opacity(0.6)
              Blank()
              Text('TimePicker')
                .fontSize(11)
                .fontColor('#FF3B30')
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

            Text('时间选择器（测试参数enable: Optional<boolean>）')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')

            // TimePicker2 独立测试按钮
            Column({ space: 8 }) {
              Text('enableHapticFeedback: ' + this.tp2CurrentTestCase)
                .fontSize(12)
                .fontColor('#666666')
                .width('100%')

              Row({ space: 6 }) {
                this.TP2ValueButton('true', true)
                this.TP2ValueButton('false', false)
                this.TP2ValueButton('undefined', undefined)
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
            }
            .width('100%')
            .padding(8)
            .backgroundColor('#F5F5F7')
            .borderRadius(8)

            TimePicker({
              selected: this.selectedTime
            })
              .enableCascade(true)
              .loop(true)
              .enableHapticFeedback(this.getTP2HapticValue())
              .onChange((value: TimePickerResult) => {
                if (value.hour >= 0) {
                  this.selectedTime.setHours(value.hour, value.minute)
                  console.info('TimePicker2 value:' + JSON.stringify(value))
                }
              })
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


          // TextPicker 卡片
          Column({ space: 16 }) {
            Row() {
              Text('04')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FF9500')
                .opacity(0.6)
              Blank()
              Text('TextPicker')
                .fontSize(11)
                .fontColor('#FF9500')
                .padding({
                  left: 8,
                  right: 8,
                  top: 2,
                  bottom: 2
                })
                .backgroundColor('#FFF5E6')
                .borderRadius(4)
            }
            .width('100%')

            Text('文本选择器')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')

            // 单列选择
            Column({ space: 8 }) {
              Text('单列选择')
                .fontSize(13)
                .fontColor('#666666')
              TextPicker({ range: this.apfruits, selected: this.select, columnWidths: this.singleColumnWidths })
                .onChange((value: string | string[], index: number | number[]) => {
                  console.info('Picker item changed, value: ' + value + ', index: ' + index)
                })
                .onScrollStop((value: string | string[], index: number | number[]) => {
                  console.info('Picker scroll stopped, value: ' + value + ', index: ' + index)
                })
                .onEnterSelectedArea((value: string | string[], index: number | number[]) => {
                  console.info('Picker item enter selected area, value: ' + value + ', index: ' + index)
                })
                .enableHapticFeedback(this.getHapticValue())
            }
            .width('100%')

            Divider().color('#f0f0f0').strokeWidth(1)

            // 多列选择
            Column({ space: 8 }) {
              Text('多列选择')
                .fontSize(13)
                .fontColor('#666666')
              TextPicker({ range: this.multi, columnWidths: this.multipleColumnWidths })
                .onChange((value: string | string[], index: number | number[]) => {
                  console.info('TextPicker 多列:onChange ' + JSON.stringify(value) + ', ' + 'index: ' +
                  JSON.stringify(index))
                })
                .onScrollStop((value: string | string[], index: number | number[]) => {
                  console.info('TextPicker 多列:onScrollStop ' + JSON.stringify(value) + ', ' + 'index: ' +
                  JSON.stringify(index))
                })
                .onEnterSelectedArea((value: string | string[], index: number | number[]) => {
                  console.info('TextPicker 多列:onEnterSelectedArea ' + JSON.stringify(value) + ', ' + 'index: ' +
                  JSON.stringify(index))
                })
                .enableHapticFeedback(this.getHapticValue())
            }
            .width('100%')

            Divider().color('#f0f0f0').strokeWidth(1)

            // 级联选择
            Column({ space: 8 }) {
              Text('级联选择')
                .fontSize(13)
                .fontColor('#666666')
              TextPicker({ range: this.cascade, columnWidths: this.cascadeColumnWidths })
                .onChange((value: string | string[], index: number | number[]) => {
                  console.info('TextPicker 多列联动:onChange ' + JSON.stringify(value) + ', ' + 'index: ' +
                  JSON.stringify(index))
                })
                .onScrollStop((value: string | string[], index: number | number[]) => {
                  console.info('TextPicker 多列联动:onScrollStop ' + JSON.stringify(value) + ', ' + 'index: ' +
                  JSON.stringify(index))
                })
                .onEnterSelectedArea((value: string | string[], index: number | number[]) => {
                  console.info('TextPicker 多列联动:onEnterSelectedArea ' + JSON.stringify(value) + ', ' + 'index: ' +
                  JSON.stringify(index))
                })
                .enableHapticFeedback(this.getHapticValue())
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

          // Dialog 按钮组
          Column({ space: 12 }) {
            Row() {
              Text('05')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#34C759')
                .opacity(0.6)
              Blank()
              Text('Dialog')
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

            Text('弹窗选择器')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')

            // DatePickerDialog
            Button('打开日期选择弹窗')
              .fontSize(14)
              .fontColor('#ffffff')
              .backgroundColor('#007AFF')
              .borderRadius(10)
              .width('100%')
              .height(44)
              .onClick(() => {
                this.getUIContext().showDatePickerDialog({
                  start: new Date('2000-01-01'),
                  end: new Date('2100-12-31'),
                  selected: this.selectedDate,
                  showTime: true,
                  useMilitaryTime: false,
                  dateTimeOptions: { hour: "numeric", minute: "2-digit" },
                  enableHapticFeedback: this.getHapticValue(),
                  onDateAccept: (value: Date) => {
                    this.selectedDate = value
                    console.info('DatePickerDialog:onDateAccept()' + value.toString())
                  },
                  onCancel: () => {
                    console.info('DatePickerDialog:onCancel()')
                  },
                  onDateChange: (value: Date) => {
                    console.info('DatePickerDialog:onDateChange()' + value.toString())
                  },
                  onDidAppear: () => {
                    console.info('DatePickerDialog:onDidAppear()')
                  },
                  onDidDisappear: () => {
                    console.info('DatePickerDialog:onDidDisappear()')
                  },
                  onWillAppear: () => {
                    console.info('DatePickerDialog:onWillAppear()')
                  },
                  onWillDisappear: () => {
                    console.info('DatePickerDialog:onWillDisappear()')
                  }
                })
              })

            // TimePickerDialog
            Button('打开时间选择弹窗')
              .fontSize(14)
              .fontColor('#ffffff')
              .backgroundColor('#5856D6')
              .borderRadius(10)
              .width('100%')
              .height(44)
              .onClick(() => {
                this.getUIContext().showTimePickerDialog({
                  selected: this.selectTime,
                  format: TimePickerFormat.HOUR_MINUTE,
                  useMilitaryTime: false,
                  dateTimeOptions: { hour: 'numeric', minute: '2-digit' },
                  enableHapticFeedback: this.getHapticValue(),
                  onAccept: (value: TimePickerResult) => {
                    if (value.hour != undefined && value.minute != undefined) {
                      this.selectTime.setHours(value.hour, value.minute)
                      console.info('TimePickerDialog:onAccept()' + JSON.stringify(value))
                    }
                  },
                  onCancel: () => {
                    console.info('TimePickerDialog:onCancel()')
                  },
                  onChange: (value: TimePickerResult) => {
                    console.info('TimePickerDialog:onChange()' + JSON.stringify(value))
                  },
                  onDidAppear: () => {
                    console.info('TimePickerDialog:onDidAppear()')
                  },
                  onDidDisappear: () => {
                    console.info('TimePickerDialog:onDidDisappear()')
                  },
                  onWillAppear: () => {
                    console.info('TimePickerDialog:onWillAppear()')
                  },
                  onWillDisappear: () => {
                    console.info('TimePickerDialog:onWillDisappear()')
                  }
                })
              })

            // TextPickerDialog
            Button(this.selectedValue ? `已选择: ${this.selectedValue}` : '打开文本选择弹窗')
              .fontSize(14)
              .fontColor('#ffffff')
              .backgroundColor('#FF9500')
              .borderRadius(10)
              .width('100%')
              .height(44)
              .onClick(() => {
                this.getUIContext().showTextPickerDialog({
                  range: this.fruits,
                  selected: this.selectText,
                  value: this.selectedValue,
                  defaultPickerItemHeight: 40,
                  enableHapticFeedback: this.getHapticValue(),
                  onAccept: (value: TextPickerResult) => {
                    this.selectText = value.index
                    this.selectedValue = value.value as string
                    console.info('TextPickerDialog:onAccept()' + JSON.stringify(value))
                  },
                  onCancel: () => {
                    console.info('TextPickerDialog:onCancel()')
                  },
                  onChange: (value: TextPickerResult) => {
                    console.info('TextPickerDialog:onChange()' + JSON.stringify(value))
                  },
                  onScrollStop: (value: TextPickerResult) => {
                    console.info('TextPickerDialog:onScrollStop()' + JSON.stringify(value))
                  },
                  onDidAppear: () => {
                    console.info('TextPickerDialog:onDidAppear()')
                  },
                  onDidDisappear: () => {
                    console.info('TextPickerDialog:onDidDisappear()')
                  },
                  onWillAppear: () => {
                    console.info('TextPickerDialog:onWillAppear()')
                  },
                  onWillDisappear: () => {
                    console.info('TextPickerDialog:onWillDisappear()')
                  }
                })
              })
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

  // TimePicker2 独立获取值
  private getTP2HapticValue(): boolean | undefined {
    if (this.tp2HapticValue === true) {
      return true;
    }
    if (this.tp2HapticValue === false) {
      return false;
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
  ValueButton(label: string, value: boolean | null | undefined | string) {
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

  // TimePicker2 独立测试按钮
  @Builder
  TP2ValueButton(label: string, value: boolean | undefined) {
    Button(label)
      .fontSize(10)
      .fontColor(this.tp2CurrentTestCase === label ? '#ffffff' : '#1a1a1a')
      .backgroundColor(this.tp2CurrentTestCase === label ? '#5856D6' : '#f5f5f5')
      .borderRadius(6)
      .height(26)
      .padding({ left: 6, right: 6 })
      .onClick(() => {
        this.tp2HapticValue = value;
        this.tp2CurrentTestCase = label;
      })
  }
}