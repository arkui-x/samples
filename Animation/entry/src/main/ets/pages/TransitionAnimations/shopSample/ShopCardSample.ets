import { TitleBar } from '../../../common/TitleBar';

@Entry
@Component
struct ShopCardSample {
  @State isUnfold: boolean = false;

  build() {
    Row() {
      Column() {
        TitleBar({ title: $r('app.string.Shop_card_expansion') })
        Stack() {
          Row() {
            Text($r('app.string.Today'))
              .margin({ left: 24 })
              .fontSize(30)
              .fontColor($r('app.color.sub_title_color'))
              .fontFamily($r('app.string.Font_family_medium'))
            Blank()
            Image($r('app.media.ic_user'))
              .width(40)
              .height(40)
              .margin({ right: 24 })
              .objectFit(ImageFit.Contain)
          }
          .width('100%')
          .height(80)

          if (!this.isUnfold) {
            Image($r('app.media.img_test_5'))
              .id('shopCardUnexpanded')
              .width('90%')
              .height('80%')
              .borderRadius(24)
              .zIndex(0)
              .margin({ top: 80 })
              .geometryTransition('sharedImage')
              .transition({ type: TransitionType.Insert })
              .transition({ type: TransitionType.Delete })
              .onClick(e => {
                // 使用TransitionOptions指定transition时，必须配合animateTo才能产生动画
                animateTo({ duration: 350 }, () => {
                  this.isUnfold = true;
                })
              })
          }
          if (this.isUnfold) {
            Image($r('app.media.img_test_5'))
              .id('shopCardExpanded')
              .width('100%')
              .height('100%')
              .zIndex(1)
              .geometryTransition('sharedImage')
              .transition({ type: TransitionType.Insert, translate: { y: 0 } })
              .transition({ type: TransitionType.Delete })
              .onClick(e => {
                // 使用TransitionOptions指定transition时，必须配合animateTo才能产生动画
                animateTo({ duration: 350 }, () => {
                  this.isUnfold = false;
                })
              })
          }
        }
        .width('100%')
        .height('70%')
        .alignContent(Alignment.Top)
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.background_shallow_grey'))
    }
    .width('100%')
    .height('100%')
  }
}