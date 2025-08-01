import router from '@ohos.router'
import { TitleBar } from './MainPage'

@Entry
@Component
struct Index {
  build() {

    Row() {
      Column({ space: 10 }) {
        TitleBar({title: $r('app.string.FileApi_title') })
        List({ space: 10 }) {
          ForEach(pages, (item: PageItem) => {
            ListItem() {
              RouterComponent({ pageItem: item })
            }
          })
        }
        .alignListItem(ListItemAlign.Center)
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .width("100%")
      .height("100%")
    }
  }
}

@Component
struct RouterComponent {
  public pageItem: PageItem = new PageItem("", "");

  build() {
    Button(this.pageItem.text)
      .onClick(() => {
        router.pushUrl({
          url: this.pageItem.url,
          params: {
            title: this.pageItem.text
          }
        })
      })
      .width(350)
      .height(60)
  }
}

class PageItem {
  public text: string = "";
  public url: string = "";

  constructor(text: string, url: string) {
    this.text = text;
    this.url = url;
  }
}

const pages: PageItem[] = [
  new PageItem("BaseFileInterface", "pages/BaseFileInterface"),
  new PageItem("AtomicFile&Watcher", "pages/AtomicFile_Watcher"),
  new PageItem("RandomAccess", "pages/RandomAccess"),
  new PageItem("Stream", "pages/Stream"),
  new PageItem("OtherFileInterface", "pages/OtherFileInterface"),
  new PageItem("FileHash&Statvfs", "pages/FileHash_Statvfs"),
]