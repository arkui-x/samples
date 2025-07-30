

import display from '@ohos.display'
import { TitleBar } from './TitleBar';
@Entry
@Component
struct Index {
  @State message: string = 'Hello World test'


  build() {
    Row() {
      Column() {
        TitleBar({ title: $r('app.string.DisplayPpi_title') })
          .width('100%')
        Text("scaledDensity: " + display.getDefaultDisplaySync().scaledDensity.toString())
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("dpi: " +display.getDefaultDisplaySync().densityDPI.toString())
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("densityPixels: " + display.getDefaultDisplaySync().densityPixels.toString())
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }

  aboutToAppear() {
    this.message = '11';
    setTimeout(()=>{
      this.message = '22';
    }, 1000)
  }
}


















