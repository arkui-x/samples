import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State message: string = 'system';

  build() {
    Column() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
      Button(){
        Text("system")
          .fontSize(25)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })  // Text组件支持textOverflow
          .width('60%')
          .textAlign(TextAlign.Center)
      }
        .onClick(() =>{
          router.pushUrl({url:"pages/system"})
        })
      .width('100%')
      .height(45)
      .backgroundColor('#98FB98')
      .borderRadius(22)
      Button(){
        Text("I18NUtil")
          .fontSize(25)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })  // Text组件支持textOverflow
          .width('60%')
          .textAlign(TextAlign.Center)
      }
        .onClick(() =>{
          router.pushUrl({url:"pages/I18NUtil"})
        })
      .width('100%')
      .height(45)
      .backgroundColor('#98FB98')
      .borderRadius(22)
      Button(){
        Text("BreakIterator")
          .fontSize(25)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })  // Text组件支持textOverflow
          .width('60%')
          .textAlign(TextAlign.Center)
      }
        .onClick(() =>{
          router.pushUrl({url:"pages/BreakIterator"})
        })
      .width('100%')
      .height(45)
      .backgroundColor('#98FB98')
      .borderRadius(22)
      Button(){
        Text("Calendar")
          .fontSize(25)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })  // Text组件支持textOverflow
          .width('60%')
          .textAlign(TextAlign.Center)
      }
        .onClick(() =>{
          router.pushUrl({url:"pages/Calendar"})
        })
      .width('100%')
      .height(45)
      .backgroundColor('#98FB98')
      .borderRadius(22)
      Button(){
        Text("i18n")
          .fontSize(25)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })  // Text组件支持textOverflow
          .width('60%')
          .textAlign(TextAlign.Center)
      }
        .onClick(() =>{
          router.pushUrl({url:"pages/i18n"})
        })
      .width('100%')
      .height(45)
      .backgroundColor('#98FB98')
      .borderRadius(22)

      Button(){
        Text("TimeZone")
          .fontSize(25)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })  // Text组件支持textOverflow
          .width('60%')
          .textAlign(TextAlign.Center)
      }
        .onClick(() =>{
          router.pushUrl({url:"pages2/TimeZone"})
        })
      .width('100%')
      .height(45)
      .backgroundColor('#98FB98')
      .borderRadius(22)
      Button(){
        Text("IndexUtil")
          .fontSize(25)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })  // Text组件支持textOverflow
          .width('60%')
          .textAlign(TextAlign.Center)
      }
        .onClick(() =>{
          router.pushUrl({url:"pages2/IndexUtil"})
        })
      .width('100%')
      .height(45)
      .backgroundColor('#98FB98')
      .borderRadius(22)
      Button(){
        Text("ZoneRules")
          .fontSize(25)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })  // Text组件支持textOverflow
          .width('60%')
          .textAlign(TextAlign.Center)
      }
        .onClick(() =>{
          router.pushUrl({url:"pages2/ZoneRules"})
        })
      .width('100%')
      .height(45)
      .backgroundColor('#98FB98')
      .borderRadius(22)
      Button(){
        Text("ZoneOffsetTransition")
          .fontSize(25)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })  // Text组件支持textOverflow
          .width('60%')
          .textAlign(TextAlign.Center)
      }
        .onClick(() =>{
          router.pushUrl({url:"pages2/ZoneOffsetTransition"})
        })
      .width('100%')
      .height(45)
      .backgroundColor('#98FB98')
      .borderRadius(22)
      Button(){
        Text("Transliterator")
          .fontSize(25)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })  // Text组件支持textOverflow
          .width('60%')
          .textAlign(TextAlign.Center)
      }
        .onClick(() =>{
          router.pushUrl({url:"pages2/Transliterator"})
        })
      .width('100%')
      .height(45)
      .backgroundColor('#98FB98')
      .borderRadius(22)
      Button(){
        Text("Normalizer")
          .fontSize(25)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })  // Text组件支持textOverflow
          .width('60%')
          .textAlign(TextAlign.Center)
      }
        .onClick(() =>{
          router.pushUrl({url:"pages2/Normalizer"})
        })
      .width('100%')
      .height(45)
      .backgroundColor('#98FB98')
      .borderRadius(22)
      Button(){
        Text("HolidayManager")
          .fontSize(25)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })  // Text组件支持textOverflow
          .width('60%')
          .textAlign(TextAlign.Center)
      }
        .onClick(() =>{
          router.pushUrl({url:"pages2/HolidayManager"})
        })
      .width('100%')
      .height(45)
      .backgroundColor('#98FB98')
      .borderRadius(22)
      Button(){
        Text("EntityRecognizer")
          .fontSize(25)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })  // Text组件支持textOverflow
          .width('60%')
          .textAlign(TextAlign.Center)
      }
        .onClick(() =>{
          router.pushUrl({url:"pages3/EntityRecognizer"})
        })
      .width('100%')
      .height(45)
      .backgroundColor('#98FB98')
      .borderRadius(22)
    }
    .height('100%')
    .width('100%')
  }
}