import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State checked: boolean = true
  @State textInputValue: string = '高对比度输入框'
  @State textAreaValue: string = '这是一个用于观察高对比度效果的多行输入区域。'
  @State searchValue: string = '搜索内容'
  @State selectIndex: number = 1
  @State textPickerIndex: number = 1
  @State dateValue: Date = new Date(2026, 2, 31)
  private selectedTime: Date = new Date('2022-07-22T08:00:00')
  private selectOptions: string[] = ['选项一', '选项二', '选项三']
  private textPickerRange: string[] = ['Alpha', 'Beta', 'Gamma', 'Delta']

  @Builder
  menuBuilder() {
    Menu() {
      MenuItem({ content: '菜单项 A' })
      MenuItem({ content: '菜单项 B' })
      MenuItem({ content: '菜单项 C' })
    }
  }

  @Builder
  titleBlock(title: string) {
    Text(title)
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
      .fontColor('#FFF3A3')
      .margin({ bottom: 10 })
  }

  @Builder
  panelStyle() {
  }

  build() {
    Scroll() {
      Column({ space: 18 }) {
        Text('OpenHarmony 高对比度组件预览')
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFF7C2')
          .margin({ top: 20, bottom: 6 })

        Text('用于快速观察组件在高对比度主题下的边框、文本、输入态、选中态和滚动表现。')
          .fontSize(14)
          .fontColor('#D9F3FF')
          .margin({ bottom: 10 })
        Button('返回')
          .width('100%')
          .height(48)
          .backgroundColor('#111111')
          .fontColor('#FFF3A3')
          .border({ width: 2, color: '#FFD54F' })
          .onClick(() => {
            router.back();
          })
        Column({ space: 12 }) {
          this.titleBlock('Button')
          Button('主按钮')
            .width('100%')
            .height(48)
            .backgroundColor('#111111')
            .fontColor('#FFF3A3')
            .border({ width: 2, color: '#FFD54F' })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#1A1A1A')
        .borderRadius(18)
        .border({ width: 2, color: '#FFD54F' })

        Column({ space: 12 }) {
          this.titleBlock('Checkbox')
          Row({ space: 12 }) {
            Checkbox({ name: 'checkbox-demo', group: 'g1' })
              .select(this.checked)
              .selectedColor('#FFD54F')
              .onChange((value: boolean) => {
                this.checked = value
              })

            Text(this.checked ? '已选中' : '未选中')
              .fontSize(18)
              .fontColor('#EAF7FF')
          }
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#1A1A1A')
        .borderRadius(18)
        .border({ width: 2, color: '#FFD54F' })

        Column({ space: 12 }) {
          this.titleBlock('DatePicker')
          DatePicker({
            start: new Date(2020, 0, 1),
            end: new Date(2035, 11, 31),
            selected: this.dateValue
          })
            .backgroundColor('#111111')
            .onDateChange((value: Date) => {
              this.dateValue = value
            })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#1A1A1A')
        .borderRadius(18)
        .border({ width: 2, color: '#FFD54F' })

        Column({ space: 12 }) {
          this.titleBlock('Marquee')
          Marquee({
            src: '高对比度跑马灯示例：亮色文字、深色背景、清晰描边，更容易观察可读性。',
            step: 3,
            loop: -1,
            start: false,
            fromStart:true
          })
            .fontColor('#FFF3A3')
            .fontSize(18)
            .backgroundColor('#111111')
            .width('100%')
            .padding({ top: 10, bottom: 10, left: 12, right: 12 })
            .borderRadius(12)
            .border({ width: 1, color: '#FFD54F' })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#1A1A1A')
        .borderRadius(18)
        .border({ width: 2, color: '#FFD54F' })

        Column({ space: 12 }) {
          this.titleBlock('Menu')
          Button('打开菜单')
            .width('100%')
            .height(48)
            .backgroundColor('#111111')
            .fontColor('#FFF3A3')
            .border({ width: 2, color: '#FFD54F' })
            .bindMenu(this.menuBuilder)
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#1A1A1A')
        .borderRadius(18)
        .border({ width: 2, color: '#FFD54F' })
        Column({ space: 12 }) {
          this.titleBlock('Select')
          Select([{ value: '选项一'},
            { value: '选项二'},
            { value: '选项三'}])
            .selected(this.selectIndex)
            .value('Select')
            .font({ size: 18 })
            .fontColor('#FFF3A3')
            .backgroundColor('#111111')
            .onSelect((index: number) => {
              this.selectIndex = index
            })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#1A1A1A')
        .borderRadius(18)
        .border({ width: 2, color: '#FFD54F' })

        Column({ space: 12 }) {
          this.titleBlock('Span / Text')
          Text() {
            Span('Span 文本 ')
              .fontColor('#FFF3A3')
              .fontSize(22)
            Span('与普通 Text ')
              .fontColor('#7FDBFF')
              .fontSize(22)
            Span('混合显示')
              .fontColor('#FF8A65')
              .fontSize(22)
          }
          .width('100%')

          Text('这是单独的 Text 组件，用于观察正文在高对比度样式下的可读性。')
            .fontSize(18)
            .fontColor('#EAF7FF')
            .lineHeight(28)
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#1A1A1A')
        .borderRadius(18)
        .border({ width: 2, color: '#FFD54F' })

        Column({ space: 12 }) {
          this.titleBlock('TextArea')
          TextArea({ text: this.textAreaValue, placeholder: '请输入多行内容' })
            .height(120)
            .fontSize(18)
            .fontColor('#F7FBFF')
            .placeholderColor('#A7C7D8')
            .backgroundColor('#111111')
            .caretColor('#FFD54F')
            .border({ width: 2, color: '#FFD54F' })
            .onChange((value: string) => {
              this.textAreaValue = value
            })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#1A1A1A')
        .borderRadius(18)
        .border({ width: 2, color: '#FFD54F' })

        Column({ space: 12 }) {
          this.titleBlock('TextClock')
          TextClock({ timeZoneOffset: 8, controller: new TextClockController() })
            .format('yyyy-MM-dd HH:mm:ss')
            .fontSize(26)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFF3A3')
            .backgroundColor('#111111')
            .padding(12)
            .borderRadius(12)
            .border({ width: 1, color: '#FFD54F' })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#1A1A1A')
        .borderRadius(18)
        .border({ width: 2, color: '#FFD54F' })

        Column({ space: 12 }) {
          this.titleBlock('TextInput')
          TextInput({ text: this.textInputValue, placeholder: '请输入内容' })
            .height(48)
            .fontSize(18)
            .fontColor('#F7FBFF')
            .placeholderColor('#A7C7D8')
            .backgroundColor('#111111')
            .caretColor('#FFD54F')
            .border({ width: 2, color: '#FFD54F' })
            .onChange((value: string) => {
              this.textInputValue = value
            })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#1A1A1A')
        .borderRadius(18)
        .border({ width: 2, color: '#FFD54F' })

        Column({ space: 12 }) {
          this.titleBlock('TextPicker')
          TextPicker({
            range: this.textPickerRange,
            selected: this.textPickerIndex
          })
            .backgroundColor('#111111')
            .onChange((value: string | string[], index: number | number[]) => {
              // 类型收窄：判断 index 是不是 number（单选）
              if (typeof index === 'number') {
                this.textPickerIndex = index;
              } else {
                console.log('多选模式选中的索引：', index);
              }
            })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#1A1A1A')
        .borderRadius(18)
        .border({ width: 2, color: '#FFD54F' })

        Column({ space: 12 }) {
          this.titleBlock('TextTimer')
          TextTimer({
            isCountDown: false,
            count: 0
          })
            .format('HH:mm:ss.SS')
            .fontSize(26)
            .fontWeight(FontWeight.Bold)
            .fontColor('#7FDBFF')
            .backgroundColor('#111111')
            .padding(12)
            .borderRadius(12)
            .border({ width: 1, color: '#FFD54F' })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#1A1A1A')
        .borderRadius(18)
        .border({ width: 2, color: '#FFD54F' })

        Column({ space: 12 }) {
          this.titleBlock('TimerPicker')
          TimePicker({
            selected: this.selectedTime
          })
            .backgroundColor('#111111')
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#1A1A1A')
        .borderRadius(18)
        .border({ width: 2, color: '#FFD54F' })

        Column({ space: 12 }) {
          this.titleBlock('Search')
          Search({ value: this.searchValue, placeholder: '搜索组件效果' })
            .height(50)
            .fontColor('#F7FBFF')
            .placeholderColor('#A7C7D8')
            .backgroundColor('#111111')
            .border({ width: 2, color: '#FFD54F' })
            .onChange((value: string) => {
              this.searchValue = value
            })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#1A1A1A')
        .borderRadius(18)
        .border({ width: 2, color: '#FFD54F' })
        .margin({ bottom: 24 })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0B0F10')
    .scrollBar(BarState.On)
  }
}