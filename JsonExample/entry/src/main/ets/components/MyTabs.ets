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
  @Prop editable: boolean = false // 是否可修改
  @State timestamp: number = 0;

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
              if (this.editable) {
                TextArea({
                  text: item.getTabContent().length > 0 ? `"${item.getTabContent()}"` : item.getTabContent()
                })
                  .height('25%')
                  .onChange((value) => {
                    if (null !== index && undefined !== index) {
                      this.tabs[index].setTabContent(value) // 修改文本框内容时同步修改tabContent
                      this.formatContent = value
                      this.strContent = value
                    }
                  })
              } else {
                Scroll(this.scroller) {
                  Text((item.getTabContent().length > 0 ? `"${item.getTabContent()}"` : item.getTabContent()))
                    .width('100%')
                }
                .height('25%')
                .backgroundColor('#f1f1f1')
                .borderRadius(12)
                .padding(8)
                .align(Alignment.TopStart)
              }
              Flex({ justifyContent: FlexAlign.SpaceAround }) {
                Button('序列化')
                  .onClick((event) => {
                    const now: number = new Date().getTime()
                    if (this.timestamp === 0) {
                      this.timestamp = now
                    } else {
                      const count: number = now - this.timestamp
                      if (count <= 500) {
                        return
                      } else {
                        this.timestamp = now
                      }
                    }
                    this.showFormat = false
                    if (this.showStr) {
                      if (this.editable) {
                        this.showStr = false
                        setTimeout(() => {
                          this.showStr = true
                        }, 350)
                      } else {
                        return
                      }
                    } else {
                      this.showStr = true
                    }
                  })
                Button('反序列化')
                  .onClick((event) => {
                    const now: number = new Date().getTime()
                    if (this.timestamp === 0) {
                      this.timestamp = now
                    } else {
                      const count: number = now - this.timestamp
                      if (count <= 500) {
                        return
                      } else {
                        this.timestamp = now
                      }
                    }
                    this.showStr = false
                    if (this.showFormat) {
                      if (this.editable) {
                        this.showFormat = false
                        setTimeout(() => {
                          this.showFormat = true
                        }, 350)
                      } else {
                        return
                      }
                    } else {
                      this.showFormat = true
                    }
                  })
              }
              .padding(10)

              Scroll(this.scroller) {
                if (this.editable) {
                  if (this.currentIndex === index) {
                    if (this.showFormat) {
                      JSONParseContent({ innerContent: this.formatContent })
                    }
                    if (this.showStr) {
                      JSONStrContent({ innerContent: this.strContent })
                    }
                  }
                } else {
                  if (this.showFormat) {
                    JSONParseContent({ innerContent: this.tabs[index].getTabContent() })
                  }
                  if (this.showStr) {
                    JSONStrContent({ innerContent: this.tabs[index].getTabContent() })
                  }
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
    .animationDuration(300)
    .onChange((index: number) => {
      // 获取tabContent，并赋值给序列号/反序列化内容
      this.formatContent = this.tabs[index].getTabContent()
      this.strContent = this.tabs[index].getTabContent()
      this.currentIndex = index
    })
  }
}