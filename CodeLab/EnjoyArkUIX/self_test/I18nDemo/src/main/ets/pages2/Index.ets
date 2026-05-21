import router from "@ohos.router"

export class TestListOption {
  title: string = ''
  url: string = ''
  key: string = ''
}

const testList: TestListOption[] = [
  { title: 'i18n', url: 'pages/i18n', key: 'i18n' },
  { title: 'IndexUtil', url: 'pages/IndexUtil', key: 'IndexUtil' },
  { title: 'TimeZone', url: 'pages/TimeZone', key: 'TimeZone' },
  { title: 'ZoneRules', url: 'pages/ZoneRules', key: 'ZoneRules' },
  { title: 'ZoneOffsetTransition', url: 'pages/ZoneOffsetTransition', key: 'ZoneOffsetTransition' },
  { title: 'Transliterator', url: 'pages/Transliterator', key: 'Transliterator' },
  { title: 'Normalizer', url: 'pages/Normalizer', key: 'Normalizer' },
  { title: 'HolidayManager', url: 'pages/HolidayManager', key: 'HolidayManager' },

]

@Entry
@Component
struct Index {
  scroll: Scroller = new Scroller()

  build() {
    Column() {
      Scroll(this.scroll) {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          ForEach(testList, (item: TestListOption) => {
            Button(item.title)
              .width(300)
              .height(50)
              .margin(10)
              .padding({ top: 5, bottom: 5 })
              .onClick(() => {
                this.getUIContext().getRouter().pushUrl({ url: item.url }, router.RouterMode.Single)
              })
          }, (item: TestListOption) => item.title)
        }
        .width('100%')
      }
    }
  }
}