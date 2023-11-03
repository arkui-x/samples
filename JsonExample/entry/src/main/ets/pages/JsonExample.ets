import TabsBean from '../beans/TabsBean'
import MyTabs from '../components/MyTabs'
import BASIC_DATA_STR from '../datasource/BasicData'
import { COMPLICATED_DATA_LIST_STR, COMPLICATED_JSON_STR } from '../datasource/ComplicatedData'
import { SIMPLE_OBJECT_STR, SIMPLE_JSON_STR } from '../datasource/SimpleData'

@Component
export default struct JsonParseExample {
  @Consume currentPage: string;
  @Consume deserialize: string;
  private tabs: Array<TabsBean> = []

  aboutToAppear() {
    this.initTabs()
  }

  /**
   * 初始化tab组件的页签数据
   */
  initTabs(): void {
    const basicTab = new TabsBean(`basic JSON`, BASIC_DATA_STR)
    const simpleTab = new TabsBean(`simple JSON`, SIMPLE_JSON_STR)
    const complicatedTab = new TabsBean(`complicated JSON`, COMPLICATED_JSON_STR)
    const simpleDataTab = new TabsBean(`SimpleObj JSON`, SIMPLE_OBJECT_STR)
    const complexDataTab = new TabsBean(`ComplicatedObj JSON`, COMPLICATED_DATA_LIST_STR)
    const parseErrorTab = new TabsBean(`Parse Error Tab`, '{a: 1}')
    this.tabs.push(basicTab)
    this.tabs.push(simpleTab)
    this.tabs.push(complicatedTab)
    this.tabs.push(simpleDataTab)
    this.tabs.push(complexDataTab)
    this.tabs.push(parseErrorTab)
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text(`返回首页`)
          .fontColor('#FFFFFF')
          .onClick(() => {
            this.currentPage = 'index'
          })
        Text(`${this.deserialize === 'gson' ? 'GSON' : '原生JS'}`)
          .fontColor('#FFFFFF')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
      }
      .height('5%')
      .width('100%')
      .backgroundColor('#007DFF')
      .borderWidth({
        bottom: 1
      })
      .padding({
        top: 0,
        left: 20,
        right: 20,
        bottom: 0
      })

      // 页签组件
      MyTabs({ tabs: this.tabs })
        .width('100%')
        .height('95%')
        .backgroundColor(Color.White)
    }
    .width('100%')
    .height('100%')
  }
}