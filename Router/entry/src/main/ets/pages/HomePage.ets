import router from '@ohos.router'
import ListModelPopular from '../component/ListModelPopular'
import ListModelNew from '../component/ListModelNew'
import ListModelAll from '../component/ListModelAll'
import { AuthorPage, SettingsPage } from './ContentPage'


@Entry
@Component
struct HomePage {
  // @State bottomSelectIndex: number = 0
  // @State topSelectIndex: number = 0
  @StorageLink('routerObj') routerObj: router.RouterOptions = {
    url:'pages/loginPage'
  };
  @StorageLink('homeTabBottomIndex') homeTabBottomIndex: number = 0;
  @StorageLink('homeTabTopIndex') homeTabTopIndex: number = 0;

  topController: TabsController = new TabsController()
  bottomController: TabsController = new TabsController()

  aboutToAppear() {
    router.clear();
    // this.bottomSelectIndex = this.homeTabBottomIndex;
    // this.topSelectIndex = this.homeTabTopIndex;
  }

  @Builder
  TabBuilder(title: string, index: number, normalImg: Resource, selectImg: Resource) {
    Column() {
      Image(this.homeTabBottomIndex == index ? selectImg : normalImg)
        .height(20)
        .height(20)
      Text(title)
        .fontSize(15)
        .fontColor(this.homeTabBottomIndex == index ? Color.Black : Color.Gray)
    }
    .onClick(() => {
      this.homeTabBottomIndex = index
      this.bottomController.changeIndex(index)
    }
    )
  }

  @Builder
  TabBuilderStart(title: string, index: number, normalImg: Resource, selectImg: Resource) {
    Column() {
      Image(this.homeTabTopIndex === index ? selectImg : normalImg)
        .height(20)
        .height(20)
        .margin({ bottom: 10 })
      Text(title)
        .fontSize(15)
        .fontColor(this.homeTabTopIndex === index ? Color.Black : Color.Gray)
      Divider()
        .strokeWidth(2)
        .color(Color.Black)
        .width(40)
        .opacity(this.homeTabTopIndex === index ? 1 : 0)
        .margin({ top: 8 })
    }
    .height(60)
    .backgroundColor('#B6C5D1').width('100%')
    .onClick(() => {
      this.homeTabTopIndex = index
      this.topController.changeIndex(index)
    }
    )
  }

  build() {
    Column() {
      Tabs({
        barPosition: BarPosition.End,
        controller: this.bottomController,
        index:this.homeTabBottomIndex
      }) {
        TabContent() {
          Column() {
            Text('Books')
              .fontSize(30)
              .backgroundColor('#B6C5D1')
              .width('100%')
              .height('12%')
              .padding({ left: 15 })
            Tabs({
              barPosition: BarPosition.Start,
              controller: this.topController,
              index:this.homeTabTopIndex
            }) {
              TabContent() {
                ListModelPopular()
              }
              .tabBar(this.TabBuilderStart('Popular', 0, $r('app.media.popular'), $r('app.media.sel_popular')))

              TabContent() {
                ListModelNew()
              }
              .tabBar(this.TabBuilderStart('New', 1, $r('app.media.new'), $r('app.media.sel_new')))

              TabContent() {
                ListModelAll()
              }
              .tabBar(this.TabBuilderStart('All', 2, $r('app.media.all'), $r('app.media.sel_all')))
            }
            .barHeight(70)
            .margin({ top: -8 })
            .scrollable(true)
            .onChange((index) => {
              // this.topSelectIndex = index;
              this.homeTabTopIndex = index;
            })
          }
        }
        .tabBar(this.TabBuilder('Book', 0, $r('app.media.books'), $r('app.media.sel_books')))

        TabContent() {
          AuthorPage()
        }
        .tabBar(this.TabBuilder('Authors', 1, $r('app.media.authors'), $r('app.media.sel_authors')))

        TabContent() {
          SettingsPage()
        }
        .tabBar(this.TabBuilder('Settings', 2, $r('app.media.settings'), $r('app.media.sel_settings')))
      }
      .scrollable(false)
      .onChange((index) => {
        // this.bottomSelectIndex = index;
        this.homeTabBottomIndex = index;
      })
    }
  }
}



