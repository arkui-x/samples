import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import { unifiedDataChannel } from '@kit.ArkData';

@Entry
@Component
struct TextTest {
  // 支持 boolean 和边界值测试
  @State hapticValue: boolean | null | undefined | string = true;
  @State currentTestCase: string = 'true';
  @State inputValue: string = ''
  @State textAreaValue: string = ''
  @State richEditorValue: string = ''
  @State searchValue: string = ''
  @State richTextValue: string = '富文本编辑器内容'
  @State isFocused: boolean = false
  @State start: number = 0;
  @State end: number = 20;
  @State onCopy: string = '';
  controller: RichEditorController = new RichEditorController();
  @State text: string =
    'This is set selection to Selection text content This is set selection to Selection text content.';

  @Builder
  CustomKeyboardBuilder() {
    Column() {
      Grid() {
        ForEach(['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'], (item: string) => {
          GridItem() {
            Button(item).width(110).onClick(() => {
              this.controller.addTextSpan(item + '', {
                offset: this.controller.getCaretOffset(),
                style:
                {
                  fontColor: Color.Orange,
                  fontSize: 30
                }
              })
            })
          }
        })
      }.maxCount(3).columnsGap(10).rowsGap(10).padding(5)
    }.backgroundColor(Color.Gray)
  }

  getDataFromUdmfRetry(event: DragEvent, callback: (data: DragEvent) => void) {
    try {
      let data: UnifiedData = event.getData();
      if (!data) {
        return false;
      }
      let records: Array<unifiedDataChannel.UnifiedRecord> = data.getRecords();
      if (!records || records.length <= 0) {
        return false;
      }
      callback(event);
      return true;
    } catch (e) {
      console.log("getData failed, code = " + (e as BusinessError).code + ", message = " +
      (e as BusinessError).message);
      return false;
    }
  }

  getDataFromUdmf(event: DragEvent, callback: (data: DragEvent) => void) {
    if (this.getDataFromUdmfRetry(event, callback)) {
      return;
    }
    setTimeout(() => {
      this.getDataFromUdmfRetry(event, callback);
    }, 1500);
  }

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
        Text('Text 组件')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1a1a1a')
          .letterSpacing(0.5)
        Text('触控反馈交互演示')
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

      // 边界值测试控制区
      Column({ space: 8 }) {
        Text('选择 enableHapticFeedback 参数值')
          .fontSize(14)
          .fontColor('#666666')
          .width('100%')
          .textAlign(TextAlign.Center)

        // 参数值选择按钮行
        Row({ space: 8 }) {
          this.ValueButton('true', true)
          this.ValueButton('false', false)
          this.ValueButton('null', null)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)

        Row({ space: 8 }) {
          this.ValueButton('undefined', undefined)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)

        // 当前值显示
        Row() {
          Text('当前参数: ')
            .fontSize(14)
            .fontColor('#666666')
          Text(this.currentTestCase)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor('#007AFF')
          Blank()
          Text('实际效果: ' + this.getActualEffect())
            .fontSize(14)
            .fontColor(this.getActualEffect() === '开启' ? '#34C759' : '#FF3B30')
        }
        .width('100%')
        .padding({ top: 8 })
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#ffffff')
      .borderRadius(12)
      .margin({ left: 16, right: 16 })

      // 内容区域
      Scroll() {
        Column({ space: 16 }) {
          // Text组件卡片
          Column({ space: 12 }) {
            Row() {
              Text('01')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#007AFF')
                .opacity(0.6)
              Blank()
              Text('Text')
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

            Text('长按文本组件')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')

            Text(this.text)
              .fontSize(24)
              .border({ width: 1 })
              .lineHeight(20)
              .margin(30)
              .copyOption(CopyOptions.InApp)
              .selection(this.start, this.end)
              .onCopy((value: string) => {
                this.onCopy = value;
              })
              .caretColor(Color.Red)
              .selectedBackgroundColor(Color.Grey)
              .enableHapticFeedback(this.getHapticValue())
              .draggable(true)
              .onDrop((dragEvent?: DragEvent) => {
                this.getDataFromUdmf((dragEvent as DragEvent), (event: DragEvent) => {
                  let records: Array<unifiedDataChannel.UnifiedRecord> = event.getData().getRecords();
                  let plainText: unifiedDataChannel.PlainText = records[0] as unifiedDataChannel.PlainText;
                  this.text += plainText.textContent;
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

          // TextInput组件卡片
          Column({ space: 12 }) {
            Row() {
              Text('02')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#5856D6')
                .opacity(0.6)
              Blank()
              Text('TextInput')
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

            Text('TextInput文本组件')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')

            TextInput({
              text: this.inputValue,
              placeholder: '请输入内容...',
            })
              .width('100%')
              .height(44)
              .backgroundColor('#f8f9fa')
              .borderRadius(10)
              .padding({ left: 12, right: 12 })
              .placeholderColor('#c0c0c0')
              .fontColor('#1a1a1a')
              .enableHapticFeedback(this.getHapticValue())
              .onChange((value: string) => {
                this.inputValue = value
              })
              .draggable(true)
              .onDrop((dragEvent?: DragEvent) => {
                this.getDataFromUdmf((dragEvent as DragEvent), (event: DragEvent) => {
                  let records: Array<unifiedDataChannel.UnifiedRecord> = event.getData().getRecords();
                  let plainText: unifiedDataChannel.PlainText = records[0] as unifiedDataChannel.PlainText;
                  this.inputValue += plainText.textContent;
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

          // TextArea组件卡片
          Column({ space: 12 }) {
            Row() {
              Text('03')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FF9500')
                .opacity(0.6)
              Blank()
              Text('TextArea')
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

            Text('TextArea文本组件')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')

            TextArea({
              text: this.textAreaValue,
              placeholder: '在此输入多行文本内容...'
            })
              .width('100%')
              .height(100)
              .backgroundColor('#f8f9fa')
              .borderRadius(10)
              .padding(12)
              .placeholderColor('#c0c0c0')
              .fontColor('#1a1a1a')
              .enableHapticFeedback(this.getHapticValue())
              .onChange((value: string) => {
                this.textAreaValue = value
              })
              .draggable(true)
              .onDrop((dragEvent?: DragEvent) => {
                this.getDataFromUdmf((dragEvent as DragEvent), (event: DragEvent) => {
                  let records: Array<unifiedDataChannel.UnifiedRecord> = event.getData().getRecords();
                  let plainText: unifiedDataChannel.PlainText = records[0] as unifiedDataChannel.PlainText;
                  this.textAreaValue += plainText.textContent;
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

          // Search组件卡片
          Column({ space: 12 }) {
            Row() {
              Text('04')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#34C759')
                .opacity(0.6)
              Blank()
              Text('Search')
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

            Text('Search组件')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')

            Search({
              value: this.searchValue,
              placeholder: '搜索关键词...'
            })
              .width('100%')
              .height(44)
              .backgroundColor('#f8f9fa')
              .borderRadius(10)
              .placeholderColor('#c0c0c0')
              .fontColor('#1a1a1a')
              .enableHapticFeedback(this.getHapticValue())
              .onSubmit((value: string) => {
                this.searchValue = value
                promptAction.showToast({ message: `搜索: ${value}` })
              })
              .draggable(true)
              .onDrop((dragEvent?: DragEvent) => {
                this.getDataFromUdmf((dragEvent as DragEvent), (event: DragEvent) => {
                  let records: Array<unifiedDataChannel.UnifiedRecord> = event.getData().getRecords();
                  let plainText: unifiedDataChannel.PlainText = records[0] as unifiedDataChannel.PlainText;
                  this.searchValue += plainText.textContent;
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

          // RichEditor组件卡片
          Column({ space: 12 }) {
            Row() {
              Text('05')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FF2D55')
                .opacity(0.6)
              Blank()
              Text('RichEditor')
                .fontSize(11)
                .fontColor('#FF2D55')
                .padding({
                  left: 8,
                  right: 8,
                  top: 2,
                  bottom: 2
                })
                .backgroundColor('#FFE8ED')
                .borderRadius(4)
            }
            .width('100%')

            Text('富文本编辑器')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')

            RichEditor({ controller: this.controller })
              .width('100%')
              .height(180)
              .backgroundColor('#f8f9fa')
              .borderRadius(10)
              .border({ width: 1, color: '#e0e0e0' })
              .padding(12)
              .enableHapticFeedback(this.getHapticValue())
              .draggable(true)
              .onDrop((dragEvent?: DragEvent) => {
                this.getDataFromUdmf((dragEvent as DragEvent), (event: DragEvent) => {
                  let records: Array<unifiedDataChannel.UnifiedRecord> = event.getData().getRecords();
                  let plainText: unifiedDataChannel.PlainText = records[0] as unifiedDataChannel.PlainText;
                  this.richEditorValue = plainText.textContent;
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
   * 获取用于显示的状态值
   */
  private getDisplayStatus(): boolean {
    const val = this.getHapticValue();
    return val === true;
  }

  // 获取状态指示器颜色
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

  // 获取实际效果描述
  private getActualEffect(): string {
    const val = this.getHapticValue();
    if (val === undefined || val === null) {
      return '默认';
    }
    return val ? '开启' : '关闭';
  }

  @Builder
  ValueButton(label: string, value: boolean | null | undefined) {
    Button(label)
      .fontSize(13)
      .fontWeight(FontWeight.Medium)
      .fontColor(this.currentTestCase === label ? '#ffffff' : '#1a1a1a')
      .backgroundColor(this.currentTestCase === label ? '#007AFF' : '#f5f5f5')
      .borderRadius(8)
      .height(36)
      .padding({ left: 12, right: 12 })
      .onClick(() => {
        this.hapticValue = value;
        this.currentTestCase = label;
      })
  }
}