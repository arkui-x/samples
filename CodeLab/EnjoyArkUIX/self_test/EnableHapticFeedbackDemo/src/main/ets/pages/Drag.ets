import router from '@ohos.router';

@Entry
@Component
struct DragPreviewDemo {
  // 支持边界值测试
  @State hapticValue: boolean | null | undefined | string = true;
  @State currentTestCase: string = 'true';
  @State isDragging: boolean = false;

  @Builder
  MenuBuilder() {
    Column({ space: 0 }) {
      Text('保存图片')
        .fontSize(15)
        .fontColor('#1a1a1a')
        .width('100%')
        .height(48)
        .textAlign(TextAlign.Center)
      Divider().height(0.5).color('#e0e0e0')
      Text('分享图片')
        .fontSize(15)
        .fontColor('#1a1a1a')
        .width('100%')
        .height(48)
        .textAlign(TextAlign.Center)
      Divider().height(0.5).color('#e0e0e0')
      Text('删除图片')
        .fontSize(15)
        .fontColor('#FF3B30')
        .width('100%')
        .height(48)
        .textAlign(TextAlign.Center)
    }
    .width(140)
    .backgroundColor('#ffffff')
    .borderRadius(12)
    .shadow({
      radius: 8,
      color: '#00000020',
      offsetX: 0,
      offsetY: 4
    })
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

        Text('Drag')
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
        Text('拖拽组件')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1a1a1a')
          .letterSpacing(0.5)
        Text('长按拖拽与触控反馈演示')
          .fontSize(14)
          .fontColor('#999999')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({
        left: 20,
        right: 20,
        top: 16,
        bottom: 12
      })
      .backgroundColor('#ffffff')

      // 边界值测试控制
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

        Row() {
          Text('当前: ' + this.currentTestCase)
            .fontSize(13)
            .fontColor('#5AC8FA')
          Blank()
          Text('实际: ' + (this.getHapticValue() ? '开启' : '关闭'))
            .fontSize(13)
            .fontColor(this.getHapticValue() ? '#34C759' : '#FF3B30')
        }
        .width('100%')
        .padding({ top: 4 })
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#f5f5f7')

      // 内容区域
      Scroll() {
        Column({ space: 16 }) {
          // 拖拽演示卡片
          Column({ space: 16 }) {
            Row() {
              Text('01')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#5AC8FA')
                .opacity(0.6)
              Blank()
              Text('Drag')
                .fontSize(11)
                .fontColor('#5AC8FA')
                .padding({
                  left: 8,
                  right: 8,
                  top: 2,
                  bottom: 2
                })
                .backgroundColor('#E8F8FF')
                .borderRadius(4)
            }
            .width('100%')

            Text('图片拖拽')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')

            // 可拖拽图片区域
            Column({ space: 12 }) {
              Stack() {
                Column()
                  .width('100%')
                  .height(200)
                  .backgroundColor(this.isDragging ? '#E8F8FF' : '#f5f5f7')
                  .borderRadius(16)
                  .border({
                    width: this.isDragging ? 2 : 1,
                    color: this.isDragging ? '#5AC8FA' : '#e0e0e0',
                    style: BorderStyle.Dashed
                  })

                Column({ space: 8 }) {
                  Image($r('app.media.startIcon'))
                    .width(80)
                    .height(80)
                    .borderRadius(12)
                    .shadow({
                      radius: 8,
                      color: '#00000020',
                      offsetX: 0,
                      offsetY: 4
                    })
                    .draggable(true)
                    .dragPreviewOptions({}, {
                      isMultiSelectionEnabled: true,
                      defaultAnimationBeforeLifting: true,
                      enableHapticFeedback: this.getHapticValue()
                      // enableHapticFeedback:true
                    })
                    .bindContextMenu(this.MenuBuilder, ResponseType.LongPress)
                    .onDragStart(() => {
                      this.isDragging = true;
                      console.info('Image onDragStart');
                    })
                    .onDragEnd(() => {
                      this.isDragging = false;
                      console.info('Image onDragEnd');
                    })

                  Text('长按或拖拽我')
                    .fontSize(13)
                    .fontColor('#999999')
                }
              }
              .width('100%')
              .height(200)
            }
            .width('100%')

            // 操作提示
            Row({ space: 8 }) {
              Text('💡')
                .fontSize(14)
              Text('长按图片显示菜单，拖拽图片移动')
                .fontSize(13)
                .fontColor('#666666')
            }
            .width('100%')
            .padding(12)
            .backgroundColor('#f8f9fa')
            .borderRadius(8)
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

          // 功能说明卡片
          Column({ space: 16 }) {
            Row() {
              Text('02')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FF9500')
                .opacity(0.6)
              Blank()
              Text('Features')
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

            Text('功能特性')
              .fontSize(17)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')

            Column({ space: 12 }) {
              FeatureItem({ icon: '✋', title: '拖拽操作', desc: '支持图片拖拽移动' })
              FeatureItem({ icon: '📳', title: '触觉反馈', desc: '拖拽时提供震动反馈' })
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
      return '触感默认(false)';
    }
    if (val === undefined) {
      return '触感默认(false)';
    }

    return this.getDisplayStatus() ? '触感开启' : '触感关闭';
  }

  @Builder
  ValueButton(label: string, value: boolean | null | undefined) {
    Button(label)
      .fontSize(12)
      .fontColor(this.currentTestCase === label ? '#ffffff' : '#1a1a1a')
      .backgroundColor(this.currentTestCase === label ? '#5AC8FA' : '#f5f5f5')
      .borderRadius(6)
      .height(32)
      .padding({ left: 10, right: 10 })
      .onClick(() => {
        this.hapticValue = value;
        this.currentTestCase = label;
      })
  }
}

// 功能特性项组件
@Component
struct FeatureItem {
  private icon: string = '';
  private title: string = '';
  private desc: string = '';

  build() {
    Row({ space: 12 }) {
      Text(this.icon)
        .fontSize(24)

      Column({ space: 2 }) {
        Text(this.title)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1a1a1a')
        Text(this.desc)
          .fontSize(12)
          .fontColor('#999999')
      }
      .alignItems(HorizontalAlign.Start)

      Blank()
    }
    .width('100%')
    .padding({ top: 8, bottom: 8 })
  }
}
