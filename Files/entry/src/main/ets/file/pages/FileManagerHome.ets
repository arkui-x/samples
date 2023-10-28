import router from '@ohos.router';

class MainListItemModel {
  image: Resource = $r('app.media.document')
  title: Resource = $r('app.string.document')
  routerUrl: string = 'file/pages/document/DocumentFileList'
}

const MAIN_LIST_ITEMS: MainListItemModel[] = [
  {
    image: $r('app.media.document'),
    title: $r('app.string.document'),
    routerUrl: 'file/pages/document/DocumentFileList'
  },
]

@Component
struct MainListItemComponent {
  private mainListItem: MainListItemModel = {
    image: $r('app.media.document'),
    title: $r('app.string.document'),
    routerUrl: 'file/pages/document/DocumentFileList'
  };

  build() {
    Row() {
      Image(this.mainListItem.image)
        .width(24)
        .height(24)
        .margin({ left: 20 })
        .objectFit(ImageFit.Fill)

      Text(this.mainListItem.title)
        .fontSize(16)
        .margin({ left: 16 })
        .fontColor($r('app.color.black'))

      Blank()

      Image($r('app.media.right_arrow'))
        .width(12)
        .height(24)
        .margin({ right: 6 })
    }
    .height(56)
    .width('100%')
    .borderRadius(24)
    .backgroundColor($r('app.color.white'))
    .margin({ top: 10 })
    .onClick(() => {
      router.pushUrl({ url: this.mainListItem.routerUrl })
    })
  }
}

@Component
export default struct FileManagerHome {
  build() {
    Column() {
      Text($r('app.string.file_manager'))
        .fontSize(24)
        .margin({ left: 20, top: 10, bottom: 20 })
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.black'))
        .alignSelf(ItemAlign.Start)
      List() {
        ForEach(MAIN_LIST_ITEMS, (listItem: MainListItemModel, no: number) => {
          ListItem() {
            MainListItemComponent({ mainListItem: listItem });
          }
          .id('ListItem' + no)
        })
      }
      .width('100%')
      .height('100%')
    }
    .height('100%')
    .backgroundColor($r('app.color.background'))
    .padding(20)
  }
}
