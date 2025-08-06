

import display from '@ohos.display'
@Entry
@Component
struct quadraticCurveToDemo {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context1: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  @State message: string = 'Hello World test'


  build() {
   Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center, justifyContent: FlexAlign.Center}) {
     Button("11111")
    Canvas(this.context1)
      .width('100%')
      .height('50%')
      .backgroundColor('#ffff00')
      .onReady(() => {
        let ctx1 = this.context1
        ctx1.beginPath()
        ctx1.moveTo(20, 50)
        ctx1.quadraticCurveTo(200, 100, 200, 20)
        ctx1.stroke()
      })
   }
   .width('100%')

    .height('100%')
  }


}


















