import RichTextHome from '../richtext/pages/RichTextHome'
import { debounce } from '../richtext/utils/Utils'

@Entry
@Component
struct Index {
  // // 弹窗
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({}),
    alignment: DialogAlignment.Center,
  })

  build() {
    Stack() {
      Column() {
        // header
        Column() {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.SpaceBetween }) {
            Text('Rich Text')
            Button('!', { type: ButtonType.Capsule, stateEffect: false })
              .fontSize(25)
              .fontWeight(800)
              .fontColor(Color.Black)
              .backgroundColor(Color.Transparent)
              .onClick(() => {
                debounce(() => {
                  this.dialogController.open()
                }, 300)()

              })
          }
          .margin({ left: 20, right: 20 })
        }
        .height(50)
        .backgroundColor($r('app.color.background'))

        //
        RichTextHome()
      }
    }
  }
}

@CustomDialog
struct CustomDialogExample {
  controller: CustomDialogController

  build() {
    Column() {
      Text('About')
        .fontSize(20)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 15 })
      Text('A component that supports interactive text editing.' +
        'This component is supported starting from API Version 10.' +
        ' If there are new content added in subsequent versions, the starting version of the content will be marked separately with an upper corner marker. ' +
        'RichEditor only supports drag and drop effects such as floating through the onDragStart event.' +
        'Supports universal attributes.' +
        'Support for general events and some other events.'
      )
        .fontSize(20)
        .margin({ left: 15, right: 15, bottom: 20 })
    }
    .padding({ left: 10, right: 10 })
    .width('100%')
    .backgroundColor(Color.White)
  }
}