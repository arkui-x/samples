import { debounce } from '../utils/Utils'

// 提示信息数组类型
interface MainListItem {
  content: string;
  offset: Array<number>;
  offsetInSpan: Array<number>,
  isInsert?: boolean,
  isDelete?: boolean,
  isSelect?: boolean
}

@Component
export default struct RichTextHome {
  // 弹窗
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({}),
  })

  build() {
    Column() {
      RichTextContent()
    }
  }
}

// 按钮
@Extend(Button)
function fancyButton() {
  .fontSize(13)
  .fontColor(Color.Black)
  .fontWeight(600)
  .borderStyle({ right: 0 })
}

// Delta
@Extend(Text)
function fancyTextDelta(fontSize: number) {
  .decoration({ type: TextDecorationType.Underline, color: Color.Black })
  .fontSize(fontSize)
  .fontColor(Color.Black)
  .textAlign(TextAlign.Center)
  .fontWeight(800)

}

// Info
@Extend(Text)
function fancyTextInfo() {
  .fontSize(13)
  .textAlign(TextAlign.Center)
}

@Component
struct RichTextContent {
  //  RichEditorController
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  // 滚动
  private scroller: Scroller = new Scroller()
  // 提示信息数组
  @State mainList: MainListItem[] = [{
    content: '',
    offset: [],
    offsetInSpan: []
  }]
  @State content: string = "" // 内容
  @State isFontWeight: boolean = false // 是否加粗
  @State isFontStyleItalic: boolean = false //是否斜体
  @State isFontUnderline: boolean = false //是否下划线
  @State isBoldEnable: boolean = true //是否显示粗体按钮按下样式
  @State isItalicEnable: boolean = true //是否显示斜体按钮按下样式
  @State isUnderlineEnable: boolean = true //是否显示下划线按钮按下样式
  @State clickKey: string = ''

  //按钮公共样式
  @Styles
  buttonStyleCss() {
    .backgroundColor(Color.White)
    .border({
      width: { left: 1, right: 1, top: 1, bottom: 1 },
      color: '#CCCCCC',
      radius: 1,
      style: BorderStyle.Solid
    })
  }

  // 提示信息公共样式
  @Styles
  infoStyle() {
    .backgroundColor(Color.White)
    .width('20%')
  }

  // item项公共样式
  @Styles
  itemStyle() {
    .width('20%')
  }

  // 按钮按压样式
  @Styles
  buttonBoldPressedStyles() {
    .backgroundColor(Color.Green)
    .borderRadius(10)
  }

  @Styles
  buttonItalicPressedStyles() {
    .backgroundColor(Color.Green)
    .borderRadius(10)
  }

  @Styles
  buttonUnderlinePressedStyles() {
    .backgroundColor(Color.Green)
    .borderRadius(10)
  }

  // Info
  @Styles
  fancyArrayItem() {
    .padding(6)
    .borderRadius(5)
    .margin({ top: 5 })
  }

  build() {
    Column() {
      // 粗体、斜体、下划线按钮
      Row() {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.Center }) {
          Button('粗体', { type: ButtonType.Normal, stateEffect: false })
            .fancyButton()
            .buttonStyleCss()
            .backgroundColor(this.clickKey == '0' ? Color.Green : Color.White)
            .onClick(debounce(() => {
              this.clickKey = '0'
              this.controller.setTypingStyle({
                fontWeight: FontWeight.Bold,
                fontStyle: FontStyle.Normal,
                decoration: {
                  type: TextDecorationType.None,
                }
              })
            }, 300))
          Button('斜体', { type: ButtonType.Normal, stateEffect: false })
            .fancyButton()
            .buttonStyleCss()
            .backgroundColor(this.clickKey == '1' ? Color.Green : Color.White)
            .onClick(debounce(() => {
              this.clickKey = '1'
              this.controller.setTypingStyle({
                fontStyle: FontStyle.Italic,
                fontWeight: FontWeight.Normal,
                decoration: {
                  type: TextDecorationType.None,
                }
              })
            }, 300))

          Button('下划线', { type: ButtonType.Normal, stateEffect: false })
            .fancyButton()
            .buttonStyleCss()
            .backgroundColor(this.clickKey == '2' ? Color.Green : Color.White)
            .border({ width: 1, color: '#CCCCCC', radius: 1, style: BorderStyle.Solid })
            .onClick(debounce(() => {
              this.clickKey = '2'
              this.controller.setTypingStyle({
                decoration: {
                  type: TextDecorationType.Underline,
                },
                fontWeight: FontWeight.Normal,
                fontStyle: FontStyle.Normal,
              })
            }, 300))
        }
      }
      .margin({
        top: 30,
        bottom: 10
      })

      // 文本编辑器
      Column() {
        // RichEditor
        Column() {
          RichEditor(this.options)
            .onSelect((value: RichEditorSelection) => {
              let selectContent: string = value.spans[0] && (value.spans[0] as RichEditorTextSpanResult).value.slice(value.spans[0].offsetInSpan[0], value.spans[0].offsetInSpan[1])
              if (selectContent) {
                this.mainList.unshift({
                  content: selectContent,
                  offset: [-1, -1],
                  offsetInSpan: [value.spans[0].offsetInSpan[1], value.spans[0].offsetInSpan[1]],
                  isSelect: true
                })
              }
            })
            .onIMEInputComplete((value: RichEditorTextSpanResult) => {
              this.mainList.unshift({
                content: value.value.slice(value.offsetInSpan[0], value.offsetInSpan[1]),
                offset: [value.offsetInSpan[0], value.offsetInSpan[0]],
                offsetInSpan: [value.offsetInSpan[1], value.offsetInSpan[1]],
                isInsert: true
              })
            })
            .aboutToDelete((value: RichEditorDeleteValue) => {
              let deleteContent: string = value.richEditorDeleteSpans[0]['value'].slice(value.richEditorDeleteSpans[0].offsetInSpan[0], value.richEditorDeleteSpans[0].offsetInSpan[1])
              this.mainList.unshift({
                content: deleteContent,
                offset: value.richEditorDeleteSpans[0].offsetInSpan,
                offsetInSpan: [0, value.richEditorDeleteSpans[0].offsetInSpan[0]],
                isDelete: true
              })
              return true;
            })
            .borderWidth(1)
            .width("100%")
            .height("20%")
        }
        .borderWidth(1)
        .borderColor('#FFFFCC')
        .margin({
          bottom: 10
        })

        //提示信息
        Column() {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.SpaceBetween }) {
            Text('Delta Type')
              .fancyTextDelta(12)
              .infoStyle()
            Text('Delta Text')
              .fancyTextDelta(12)
              .infoStyle()
            Text('Delta Offset')
              .fancyTextDelta(12)
              .infoStyle()
            Text('Delta Selection')
              .fancyTextDelta(11)
              .infoStyle()
            Text('Delta Composing')
              .fancyTextDelta(10)
              .infoStyle()
          }
        }
        .margin({
          bottom: 20
        })

        // item项
        Stack({ alignContent: Alignment.TopStart }) {
          Scroll(this.scroller) {
            Column() {
              ForEach(this.mainList, (item: MainListItem) => {
                if (item.isInsert) {
                  Row() {
                    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center,
                      justifyContent: FlexAlign.SpaceBetween }) {
                      Text('Insertion')
                        .fancyTextInfo()
                        .itemStyle()
                      Text(item.content)
                        .fancyTextInfo()
                        .itemStyle()
                      Text('(' + item.offset[0] + ',' + item.offset[1] + ')')
                        .fancyTextInfo()
                        .itemStyle()
                      Text('(' + item.offsetInSpan[0] + ',' + item.offsetInSpan[1] + ')')
                        .fancyTextInfo()
                        .itemStyle()
                      Text('(-1,-1)')
                        .fancyTextInfo()
                        .itemStyle()
                    }
                  }
                  .fancyArrayItem()
                  .backgroundColor(Color.Orange)
                }

                if (item.isDelete) {
                  Row() {
                    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center,
                      justifyContent: FlexAlign.SpaceBetween }) {
                      Text('delete')
                        .fancyTextInfo()
                        .itemStyle()
                      Text(item.content)
                        .fancyTextInfo()
                        .itemStyle()
                      Text('(' + item.offset[0] + ',' + item.offset[1] + ')')
                        .fancyTextInfo()
                        .itemStyle()
                      Text('(' + item.offsetInSpan[0] + ',' + item.offsetInSpan[1] + ')')
                        .fancyTextInfo()
                        .itemStyle()
                      Text('(-1,-1)')
                        .fancyTextInfo()
                        .itemStyle()
                    }
                  }
                  .fancyArrayItem()
                  .backgroundColor(Color.Pink)
                }
                if (item.isSelect) {
                  Row() {
                    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center,
                      justifyContent: FlexAlign.SpaceBetween }) {
                      Text('select')
                        .fancyTextInfo()
                        .itemStyle()
                      Text(item.content)
                        .fancyTextInfo()
                        .itemStyle()
                      Text('(' + item.offset[0] + ',' + item.offset[1] + ')')
                        .fancyTextInfo()
                        .itemStyle()
                      Text('(' + item.offsetInSpan[0] + ',' + item.offsetInSpan[1] + ')')
                        .fancyTextInfo()
                        .itemStyle()
                      Text('(-1,-1)')
                        .fancyTextInfo()
                        .itemStyle()
                    }
                  }
                  .fancyArrayItem()
                  .backgroundColor(Color.Gray)
                }
              })
            }.width('100%')
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBarWidth(0.5)
          .friction(0.6)
          .edgeEffect(EdgeEffect.None)
        }.width('100%').height('280')
      }
      .padding({ left: 40, right: 40 })
    }
  }
}

@CustomDialog
struct CustomDialogExample {
  controller: CustomDialogController

  build() {
    Flex({ alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center }) {
      Column() {
        Text('About')
          .fontSize(20)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 15 })
        Text('A component that supports interactive text editing.This component is supported starting from API Version 10. If there are new content added in subsequent versions, the starting version of the content will be marked separately with an upper corner marker. RichEditor only supports drag and drop effects such as floating through the onDragStart event.')
          .fontSize(17)
          .margin({ left: 5, right: 5, bottom: 20 })
      }
      .padding({ left: 10, right: 10 })
      .width('100%')
      .backgroundColor(Color.Gray)
      .opacity(0.3)
    }
  }
}
