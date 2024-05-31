@Component
export struct TopSearch {
  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Search({ placeholder: '杭州调整住房限购范围' })
        .height(40)
        .backgroundColor("#fff")
        .placeholderColor('#000')
        .placeholderFont({ size: 15 })
        .focusable(false)
      Column() {
        Column() {
          Image($r('app.media.ic_public_add_filled'))
            .autoResize(true)
            .padding(5)
        }
        .backgroundColor('#fff')
        .width(24)
        .height(24)
        .borderRadius(12)

        Text('发布')
          .fontColor('#fff')
          .fontSize(10)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 3 })
      }
      .margin({ left: 15 })
    }
    .backgroundColor('#f04142')
    .padding({ top: 20, left: 15, right: 15 })
    .height('10%')
  }
}