import TabsBean from '../beans/TabsBean'
import JSONParseContent from './JSONParseContent'
import JSONStrContent from './JSONStrContent'

@Component
export default struct MyTabs {
  @Prop tabs: Array<TabsBean> = [] // 父组件传入tabs的内容
  @Prop scrollable: boolean = true // 页签是否可以通过滑动页面进行页面切换
  @Prop vertical: boolean = false // 页签是否垂直
  @State currentIndex: number = 0 // 当前显示的页签
  @State barPosition: BarPosition = BarPosition.Start // 页签的位置
  @State showFormat: boolean = false // 显示反序列化内容
  @State showStr: boolean = false // 显示序列化内容
  @State formatContent: string = '' // 反序列化内容
  @State strContent: string = '' // 序列化内容
  private controller: TabsController = new TabsController() // 页签组件控制
  private scroller: Scroller = new Scroller() // 滚动控制

  /**
   * 根据页签下标和页签名构造页签头组件
   * @param index
   * @param name
   */
  @Builder
  TabBuilder(index: number, name: string) {
    Text(name)
      .fontColor(this.currentIndex === index ? '#007DFF' : '#333333')
      .fontSize(14)
      .fontWeight(this.currentIndex === index ? FontWeight.Bold : 400)
      .lineHeight(30)
      .padding({
        left: 20,
        bottom: 0
      })
      .onClick(() => {
        if (this.currentIndex === index) return
        this.showFormat = false
        this.showStr = false
        this.formatContent = this.tabs[index].getTabContent()
        this.strContent = this.tabs[index].getTabContent()
        this.currentIndex = index
        this.controller.changeIndex(index)
      })
  }

  aboutToAppear() {
    setTimeout(() => {
      this.formatContent = this.tabs[0].getTabContent()
      this.strContent = this.tabs[0].getTabContent()
    }, 350)
  }

  build() {
    Tabs({ barPosition: this.barPosition, controller: this.controller }) {
      if (this.tabs.length > 0) {
        ForEach(this.tabs, (item: TabsBean, index) => {
          TabContent() {
            Column() {
              TextArea({
                text: item.getTabContent().length > 0 ? `"${item.getTabContent()}"` : item.getTabContent()
              }).height('25%')
                .onChange((value) => {
                  if (null !== index && undefined !== index) {
                    this.tabs[index].setTabContent(value) // 修改文本框内容时同步修改tabContent
                    this.formatContent = value
                    this.strContent = value
                  }
                })
              Flex({ justifyContent: FlexAlign.SpaceAround }) {
                Button('序列化')
                  .onClick(() => {
                    console.log('11', this.strContent)
                    // if (this.strContent === '') return
                    this.showFormat = false
                    if (this.showStr) {
                      this.showStr = false
                      setTimeout(() => {
                        this.showStr = true
                      }, 350)
                    } else {
                      this.showStr = true
                    }
                  })
                Button('反序列化')
                  .onClick(() => {
                    // if (this.formatContent === '') return
                    this.showStr = false
                    if (this.showFormat) {
                      this.showFormat = false
                      setTimeout(() => {
                        this.showFormat = true
                      }, 350)
                    } else {
                      this.showFormat = true
                    }
                  })
              }
              .padding(10)

              Scroll(this.scroller) {
                if (this.showFormat) {
                  JSONParseContent({ innerContent: this.formatContent })
                }
                if (this.showStr) {
                  JSONStrContent({ innerContent: this.strContent })
                }
              }
              .height('65%')
              .edgeEffect(EdgeEffect.Fade)
            }
          }
          .padding(20)
          .borderWidth({
            top: 1
          })
          .backgroundColor(Color.White)
          .align(Alignment.TopStart)
          .tabBar(this.TabBuilder(index, item.getTabName()))
        }, (index: number) => index.toString())
      }
    }
    .width('100%')
    .height('100%')
    .fadingEdge(false)
    .vertical(this.vertical)
    .scrollable(this.scrollable)
    .barMode(BarMode.Scrollable)
    .barHeight(50)
    .barWidth('100%')
    .animationDuration(400)
    .onChange((index: number) => {
      this.showFormat = false
      this.showStr = false
      // 获取tabContent，并赋值给序列号/反序列化内容
      this.formatContent = this.tabs[index].getTabContent()
      this.strContent = this.tabs[index].getTabContent()
      this.currentIndex = index
    })
  }
}