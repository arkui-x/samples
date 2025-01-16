import { SecondaryCategory, TertiaryCategory } from '../model/CategoricalDataType'
import { ANIMATION_CATEGORIES } from './AnimationData'
import router from '@ohos.router'

@Styles
function CommonStyle() {
  .width('100%')
  .backgroundColor($r('app.color.white'))
  .borderRadius(24)
  .padding({ left: 24 })
}

@Entry
@Component
struct Index {
  @State upLoad: boolean = false

  @Builder
  ImageText(image: Resource, title: Resource) {
    Image(image)
      .width(24)
      .height(24)
      .objectFit(ImageFit.Fill)
    Text(title)
      .height(50)
      .fontSize(16)
      .textAlign(TextAlign.Start)
      .fontFamily('HarmonyHeiTi-Medium')
      .fontColor($r('app.color.font_color_shallow'))
      .padding({ bottom: 4, top: 4, left: 15 })
  }

  build() {
    Column() {
      Text($r('app.string.Animation_samples'))
        .height('8%')
        .width('100%')
        .backgroundColor($r('app.color.white'))
        .fontWeight(FontWeight.Bold)
        .padding({ left: 15 })
        .fontSize(20)
      Column() {
        List({ space: 30 }) {
          ForEach(ANIMATION_CATEGORIES, (category: TertiaryCategory, categoryIndex: number) => {
            ListItem() {
              Column() {
                if (category.childNodes) {
                  Column() {
                    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
                      Row() {
                        this.ImageText(category.image, category.title)
                      }

                      Row() {
                        Image(this.upLoad ? $r('app.media.ic_down_arrow') : $r('app.media.ic_right_arrow'))
                          .width(24)
                          .height(20)
                          .objectFit(ImageFit.Fill)
                          .margin({ right: 10 })
                      }
                    }
                    .onClick(() => {
                      this.upLoad = !this.upLoad
                    })

                    if (this.upLoad) {
                      Column() {
                        ForEach(category.childNodes, (category: SecondaryCategory, navigationIndex: number) => {
                          NavigationItem({ category, navigationIndex })
                        })
                      }
                      .padding({ left: 8, bottom: 4, top: 4 })
                    }
                  }
                  .CommonStyle()
                } else {
                  Row() {
                    this.ImageText(category.image, category.title)
                  }
                  .CommonStyle()
                  .onClick(() => {
                    router.pushUrl({ url: `${category.url}` })
                  })
                }
              }
            }
            .id('ListItem' + categoryIndex)
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16, top: 4 })
        .id('list_001')

        Blank()
      }
      .padding({ top: 20, bottom: 20 })
      .height('92%')
      .backgroundColor($r('app.color.light_grey'))
    }
  }
}

@Component
struct NavigationItem {
  @Prop category: SecondaryCategory
  @Prop navigationIndex: number;

  build() {
    Column() {
      Divider()
        .height(1)
        .opacity(0.2)
        .margin({ left: 42, right: 8 })
        .color($r('app.color.font_color_dark'))
      Row() {
        Image(this.category.image)
          .width(24)
          .height(24)
          .objectFit(ImageFit.Fill)
        Text(this.category.title)
          .fontSize(16)
          .margin({ left: 16 })
          .fontFamily('HarmonyHeiTi-Medium')
          .fontColor($r('app.color.font_color_dark'))
        Blank()
      }
      .height(56)
      .width('100%')
      .onClick(() => {
        router.pushUrl({
          url: this.category.url
        })
      })
    }
    .id(`secondLevelMenu${this.navigationIndex}`)
  }
}