import router from '@ohos.router'
import { TitleBar } from './MainPage';

@Entry
@Component
struct Index {
  @State title: string = ''

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    console.info('router.getParams() title is ' + params.title)
    this.title = params.title
  }
  build() {
    Column({ space: 10 }) {
      TitleBar({ title: this.title }).size({ height: '10%' })
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
  new PageItem("access", "pages/Test/BaseFileInterface/accessTest"),
  new PageItem("lstat", "pages/Test/BaseFileInterface/lstatTest"),
  new PageItem("movefile", "pages/Test/BaseFileInterface/moveFileTest"),
  new PageItem("writeAndRead", "pages/Test/BaseFileInterface/writereadTest"),
  new PageItem("xattr", "pages/Test/BaseFileInterface/xattrTest"),
  new PageItem("movedir", "pages/Test/BaseFileInterface/movedirTest"),
  new PageItem("copydir", "pages/Test/BaseFileInterface/copydirTest"),
  new PageItem("mkdir", "pages/Test/BaseFileInterface/mkdirTest"),
]