import router from '@ohos.router';

@Entry
@Component
struct Index {
  build() {
    Scroll() {
      Column({ space: 18 }) {
        Column({ space: 10 }) {
          Text('Video 手动测试导航')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor('#F3F4F6')
            .width('100%')

          Text('每个功能单独一个页面，便于逐项执行手动测试。所有视频资源均来自 rawfile 目录。')
            .fontSize(14)
            .fontColor('#B8C3D1')
            .width('100%')
        }
        .alignItems(HorizontalAlign.Start)
        .padding({ top: 24, left: 20, right: 20 })

        Column({ space: 14 }) {
          Button('1. 倍率播放测试')
            .width('100%')
            .height(52)
            .onClick(() => {
              router.pushUrl({ url: 'pages/PlaybackRateTest' });
            })

          Button('2. 首帧送显测试')
            .width('100%')
            .height(52)
            .onClick(() => {
              router.pushUrl({ url: 'pages/PosterOptionsTest' });
            })

          Button('3. 快捷键测试')
            .width('100%')
            .height(52)
            .onClick(() => {
              router.pushUrl({ url: 'pages/ShortcutKeyTest' });
            })

          Button('4. reset 测试')
            .width('100%')
            .height(52)
            .onClick(() => {
              router.pushUrl({ url: 'pages/ResetTest' });
            })

          Button('5. fullscreen 测试')
            .width('100%')
            .height(52)
            .onClick(() => {
              router.pushUrl({ url: 'pages/FullScreenTest' });
            })
        }
        .padding(20)
        .backgroundColor('#101923')
        .borderRadius(24)

        Column({ space: 10 }) {
          Text('测试说明')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor('#F9FAFB')
            .width('100%')

          Text('1. 倍率播放页覆盖枚举、数字、字符串和未设置场景。')
            .fontSize(14)
            .fontColor('#B8C3D1')
            .width('100%')

          Text('2. 首帧送显页覆盖 showFirstFrame=true、false 和未设置。')
            .fontSize(14)
            .fontColor('#B8C3D1')
            .width('100%')

          Text('3. 快捷键页聚焦 enableShortcutKey 和组件焦点。')
            .fontSize(14)
            .fontColor('#B8C3D1')
            .width('100%')

          Text('4. reset 页用于验证 reset 后暂停、显示当前帧及重新播放行为。')
            .fontSize(14)
            .fontColor('#B8C3D1')
            .width('100%')

          Text('5. fullscreen 页用于验证 全屏缩放 的行为。')
            .fontSize(14)
            .fontColor('#B8C3D1')
            .width('100%')
        }
        .padding(20)
        .backgroundColor('#101923')
        .borderRadius(24)
        .margin({ bottom: 24 })
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 24 })
    }
    .scrollBar(BarState.Auto)
    .width('100%')
    .height('100%')
    .backgroundColor('#09111A')
  }
}
