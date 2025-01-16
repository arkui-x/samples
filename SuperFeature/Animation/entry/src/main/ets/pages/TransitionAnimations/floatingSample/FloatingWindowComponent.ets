@Component
export default struct FloatingWindowComponent {
  private res: Resource = $r('app.media.ic_call_green');
  private tips?: Resource = $r('app.string.Tips_call');

  build() {
    Column() {
      Image(this.res)
        .objectFit(ImageFit.Contain)
        .width('40%')
        .height('40%')
        
      Text(this.tips)
        .fontSize(12)
        .fontColor($r('app.color.background_green'))
        .fontWeight(FontWeight.Regular)
        .fontFamily($r('app.string.Font_family_regular'))
    }
    .width(80)
    .height(80)
    .backgroundColor($r('app.color.white'))
    .borderRadius(16)
    .shadow({ radius: 15, color: $r('app.color.btn_border_color') })
    .justifyContent(FlexAlign.SpaceAround)
    .margin({ bottom: 50 })
  }
}