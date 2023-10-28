import TabsBean from '../beans/TabsBean'
import MyTabs from '../components/MyTabs'

@Component
export default struct CustomerExample {
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
    const customerTab = new TabsBean(`CustomerTab`, '')
    this.tabs.push(customerTab)
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