import router from '@ohos.router';
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct WebContextMenuExample {
  @State clickMenuItems: MenuItem[] = [
    { icon: '✏️', label: '编辑', action: () => console.info('编辑 clicked') },
    { icon: '📋', label: '复制', action: () => console.info('复制 clicked') },
    { icon: '✂️', label: '剪切', action: () => console.info('剪切 clicked') },
    { icon: '🗑️', label: '删除', action: () => console.info('删除 clicked') }
  ];

  @State longPressMenuItems: MenuItem[] = [
    { icon: '🔍', label: '搜索', action: () => console.info('搜索 clicked') },
    { icon: '🔗', label: '分享', action: () => console.info('分享 clicked') },
    { icon: '⭐', label: '收藏', action: () => console.info('收藏 clicked') },
    { icon: '🔔', label: '提醒', action: () => console.info('提醒 clicked') }
  ];

  // 点击触发的菜单
  @Builder ClickMenuBuilder() {
    Column() {
      ForEach(this.clickMenuItems, (item: MenuItem, index: number) => {
        Row({ space: 8 }) {
          Text(item.icon)
            .fontSize(18)
          Text(item.label)
            .fontSize(15)
            .fontColor('#333333')
        }
        .width('100%')
        .height(44)
        .padding({ left: 16, right: 16 })
        .justifyContent(FlexAlign.Start)
        .onClick(() => {
          item.action();
        })

        if (index < this.clickMenuItems.length - 1) {
          Divider()
            .strokeWidth(0.5)
            .color('#E5E5E5')
            .margin({ left: 16, right: 16 })
        }
      })
    }
    .width(150)
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .shadow({ radius: 10, color: '#20000000', offsetX: 0, offsetY: 4 })
  }

  // 长按触发的菜单
  @Builder LongPressMenuBuilder() {
    Column() {
      ForEach(this.longPressMenuItems, (item: MenuItem, index: number) => {
        Row({ space: 8 }) {
          Text(item.icon)
            .fontSize(18)
          Text(item.label)
            .fontSize(15)
            .fontColor('#333333')
        }
        .width('100%')
        .height(44)
        .padding({ left: 16, right: 16 })
        .justifyContent(FlexAlign.Start)
        .onClick(() => {
          item.action();
        })

        if (index < this.longPressMenuItems.length - 1) {
          Divider()
            .strokeWidth(0.5)
            .color('#E5E5E5')
            .margin({ left: 16, right: 16 })
        }
      })
    }
    .width(150)
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .shadow({ radius: 10, color: '#20000000', offsetX: 0, offsetY: 4 })
  }

  build() {
    Column({ space: 20 }) {
      // 顶部导航
      Row() {
        Text('←')
          .fontSize(24)
          .fontColor('#333333')
          .onClick(() => {
            router.back();
          })
        Text('Web 菜单演示')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1a1a1a')
        Blank()
        Text('')
          .width(24)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')

      // 内容区域
      Scroll() {
        Column({ space: 20 }) {

          // Web + 禁用触觉
          Column({ space: 12 }) {
            Text('🌐🔇')
              .fontSize(40)
            Text('Web + 禁用触觉')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')
            Text('点击菜单（无触觉反馈）')
              .fontSize(13)
              .fontColor('#999999')
              .textAlign(TextAlign.Center)

            Web({ src: $rawfile("index.html"), controller: new webview.WebviewController() })
              .width('100%')
              .height(150)
              .backgroundColor('#F5F5F7')
              .borderRadius(8)
              .bindMenu(this.ClickMenuBuilder, {
                hapticFeedbackMode: HapticFeedbackMode.DISABLED
              })
          }
          .width('100%')
          .padding(24)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .shadow({ radius: 8, color: '#10000000', offsetX: 0, offsetY: 2 })

          // Web + 点击菜单示例
          Column({ space: 12 }) {
            Text('🌐')
              .fontSize(40)
            Text('Web + 点击菜单')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')
            Text('在 Web 区域点击触发菜单')
              .fontSize(13)
              .fontColor('#999999')
              .textAlign(TextAlign.Center)

            Web({ src: $rawfile("index.html"), controller: new webview.WebviewController() })
              .width('100%')
              .height(150)
              .backgroundColor('#F5F5F7')
              .borderRadius(8)
              .bindMenu(this.ClickMenuBuilder, {
                hapticFeedbackMode: HapticFeedbackMode.ENABLED
              })
          }
          .width('100%')
          .padding(24)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .shadow({ radius: 8, color: '#10000000', offsetX: 0, offsetY: 2 })


          // Web + 长按菜单示例
          Column({ space: 12 }) {
            Text('🌐👆')
              .fontSize(40)
            Text('Web + 长按菜单')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')
            Text('在 Web 区域长按触发菜单')
              .fontSize(13)
              .fontColor('#999999')
              .textAlign(TextAlign.Center)

            Web({ src: $rawfile("index.html"), controller: new webview.WebviewController() })
              .width('100%')
              .height(150)
              .backgroundColor('#F5F5F7')
              .borderRadius(8)
              .bindContextMenu(this.LongPressMenuBuilder, ResponseType.LongPress, {
                hapticFeedbackMode: HapticFeedbackMode.ENABLED
              })
          }
          .width('100%')
          .padding(24)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .shadow({ radius: 8, color: '#10000000', offsetX: 0, offsetY: 2 })



          // Web + AUTO 模式
          Column({ space: 12 }) {
            Text('🌐⚙️')
              .fontSize(40)
            Text('Web + AUTO（无蒙层）')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')
            Text('点击菜单（无蒙层，不震动）')
              .fontSize(13)
              .fontColor('#999999')
              .textAlign(TextAlign.Center)

            Web({ src: $rawfile("index.html"), controller: new webview.WebviewController() })
              .width('100%')
              .height(150)
              .backgroundColor('#F5F5F7')
              .borderRadius(8)

              .bindMenu(this.ClickMenuBuilder, {
                hapticFeedbackMode: HapticFeedbackMode.AUTO
              })
          }
          .width('100%')
          .padding(24)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .shadow({ radius: 8, color: '#10000000', offsetX: 0, offsetY: 2 })


          // Web + AUTO（有蒙层）
          Column({ space: 12 }) {
            Text('🌐⚙️🔘')
              .fontSize(40)
            Text('Web + AUTO（有蒙层）')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')
            Text('点击菜单（有蒙层，会震动）')
              .fontSize(13)
              .fontColor('#999999')
              .textAlign(TextAlign.Center)

            Web({ src: $rawfile("index.html"), controller: new webview.WebviewController() })
              .width('100%')
              .height(150)
              .backgroundColor('#F5F5F7')
              .borderRadius(8)
              .bindContextMenu(this.ClickMenuBuilder, ResponseType.RightClick, {
                hapticFeedbackMode: HapticFeedbackMode.AUTO,
                mask: { color: '#80000000' }
              })
              .bindMenu(this.ClickMenuBuilder, {
                hapticFeedbackMode: HapticFeedbackMode.AUTO,
                mask: { color: '#80000000' }
              })

          }
          .width('100%')
          .padding(24)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .shadow({ radius: 8, color: '#10000000', offsetX: 0, offsetY: 2 })


          // Web + 长按 AUTO 模式
          Column({ space: 12 }) {
            Text('🌐⚙️')
              .fontSize(40)
            Text('Web + AUTO（无蒙层）')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')
            Text('长按菜单（无蒙层，不震动）')
              .fontSize(13)
              .fontColor('#999999')
              .textAlign(TextAlign.Center)

            Web({ src: $rawfile("index.html"), controller: new webview.WebviewController() })
              .width('100%')
              .height(150)
              .backgroundColor('#F5F5F7')
              .borderRadius(8)

              .bindContextMenu(this.ClickMenuBuilder, ResponseType.LongPress, {
                hapticFeedbackMode: HapticFeedbackMode.AUTO,
                mask: { color: '#80000000' }
              })
          }
          .width('100%')
          .padding(24)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .shadow({ radius: 8, color: '#10000000', offsetX: 0, offsetY: 2 })


          // Web + AUTO（有蒙层）
          Column({ space: 12 }) {
            Text('🌐⚙️🔘')
              .fontSize(40)
            Text('Web + AUTO（有蒙层）')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1a1a1a')
            Text('长按菜单（有蒙层，会震动）')
              .fontSize(13)
              .fontColor('#999999')
              .textAlign(TextAlign.Center)

            Web({ src: $rawfile("index.html"), controller: new webview.WebviewController() })
              .width('100%')
              .height(150)
              .backgroundColor('#F5F5F7')
              .borderRadius(8)
              .bindContextMenu(this.ClickMenuBuilder, ResponseType.LongPress, {
                hapticFeedbackMode: HapticFeedbackMode.AUTO,
                mask: { color: '#80000000' }
              })


          }
          .width('100%')
          .padding(24)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .shadow({ radius: 8, color: '#10000000', offsetX: 0, offsetY: 2 })






        }
        .width('100%')
        .padding(16)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundColor('#f5f5f7')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f7')
  }
}

interface MenuItem {
  icon: string;
  label: string;
  action: () => void;
}