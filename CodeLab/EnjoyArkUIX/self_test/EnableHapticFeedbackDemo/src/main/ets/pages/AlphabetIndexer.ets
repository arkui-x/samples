import router from '@ohos.router';

// 联系人数据结构
interface ContactGroup {
  letter: string;
  contacts: string[];
}

@Entry
@Component
struct AlphabetIndexerSample {
  // 支持边界值测试
  @State hapticValue: boolean | null | undefined | string = true;
  @State currentTestCase: string = 'true';
  private contactGroups: ContactGroup[] = [
    { letter: 'A', contacts: ['安'] },
    { letter: 'B', contacts: ['卜', '白', '包', '毕', '丙'] },
    { letter: 'C', contacts: ['曹', '成', '陈', '催'] },
    { letter: 'L', contacts: ['刘', '李', '楼', '梁', '雷', '吕', '柳', '卢'] }
  ];
  private indexLetters: string[] = ['#', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

  private getContactsByIndex(index: number): string[] {
    const letter = this.indexLetters[index];
    const group = this.contactGroups.find(g => g.letter === letter);
    return group ? group.contacts : [];
  }

  private getTotalCount(): number {
    return this.contactGroups.reduce((sum, group) => sum + group.contacts.length, 0);
  }

  private getAvatarColor(name: string): string {
    const colors = ['#007AFF', '#5856D6', '#FF9500', '#FF2D55', '#34C759', '#5AC8FA', '#AF52DE'];
    let hash = 0;
    for (let i = 0; i < name.length; i++) {
      hash = name.charCodeAt(i) + ((hash << 5) - hash);
    }
    return colors[Math.abs(hash) % colors.length];
  }

  @Builder
  ContactItem(name: string) {
    Row() {
      Column() {
        Text(name.substring(0, 1))
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#ffffff')
      }
      .width(44)
      .height(44)
      .backgroundColor(this.getAvatarColor(name))
      .borderRadius(22)
      .justifyContent(FlexAlign.Center)

      Text(name)
        .fontSize(16)
        .fontColor('#1a1a1a')
        .margin({ left: 12 })

      Blank()

      Text('›')
        .fontSize(20)
        .fontColor('#cccccc')
    }
    .width('100%')
    .height(64)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#ffffff')
  }

  build() {
    Column() {
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

        Text('AlphabetIndexer')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1a1a1a')

        Blank()

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

      // 触觉反馈开关
      Row() {
        Row({ space: 8 }) {
          Text('📳')
            .fontSize(18)
          Column({ space: 2 }) {
            Text('触觉反馈')
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')
            Text(this.getHapticValue() ? '已开启震动' : '已关闭震动')
              .fontSize(12)
              .fontColor('#999999')
          }
          .alignItems(HorizontalAlign.Start)
        }

        Blank()

        // 边界值测试按钮
        Row({ space: 6 }) {
          this.ValueButton('true', true)
          this.ValueButton('false', false)
          this.ValueButton('null', null)
        }

        Row({ space: 6 }) {
          this.ValueButton('undefined', undefined)
        }
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .margin({ left: 16, right: 16, bottom: 8 })
      .backgroundColor('#ffffff')
      .borderRadius(12)
      .shadow({
        radius: 4,
        color: '#00000008',
        offsetX: 0,
        offsetY: 2
      })


      // 内容区域：左侧列表 + 右侧索引
      Row() {
        // 左侧联系人列表
        List({ space: 0 }) {
          ForEach(this.contactGroups, (group: ContactGroup) => {
            ListItem() {
              Text(group.letter)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#666666')
                .width('100%')
                .height(28)
                .padding({ left: 16 })
                .backgroundColor('#f5f5f7')
            }

            ForEach(group.contacts, (contact: string) => {
              ListItem() {
                this.ContactItem(contact);
              }
            }, (contact: string) => contact)
          }, (group: ContactGroup) => group.letter)
        }
        .layoutWeight(1)
        .height('100%')
        .divider({ strokeWidth: 0.5, color: '#f0f0f0' })

        // 分隔线
        Divider()
          .vertical(true)
          .height('100%')
          .color('#e0e0e0')
          .strokeWidth(1)

        // 右侧字母索引
        AlphabetIndexer({ arrayValue: this.indexLetters, selected: 0 })
          .autoCollapse(true)
          .enableHapticFeedback(this.getHapticValue())
          .selectedColor('#007AFF')
          .popupColor('#ffffff')
          .selectedBackgroundColor('#E6F2FF')
          .popupBackground('#007AFF')
          .usingPopup(true)
          .selectedFont({ size: 16, weight: FontWeight.Bold })
          .popupFont({ size: 56, weight: FontWeight.Bold })
          .itemSize(28)
          .alignStyle(IndexerAlign.Right)
          .popupItemBorderRadius(12)
          .itemBorderRadius(14)
          .popupBackgroundBlurStyle(BlurStyle.Thin)
          .popupTitleBackground('#007AFF')
          .popupSelectedColor('#ffffff')
          .popupUnselectedColor('#ffffff')
          .popupItemFont({ size: 18, weight: FontWeight.Medium })
          .popupItemBackgroundColor('rgba(0, 122, 255, 0.9)')
          .width(40)
          .height('100%')
          .onSelect((index: number) => {
            console.info(this.indexLetters[index] + ' Selected!');
          })
          .onRequestPopupData((index: number): string[] => {
            const data = this.getContactsByIndex(index);
            return data.length > 0 ? data : [this.indexLetters[index]];
          })
          .onPopupSelect((index: number) => {
            console.info('onPopupSelected:' + index);
          })
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#ffffff')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffff')
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
