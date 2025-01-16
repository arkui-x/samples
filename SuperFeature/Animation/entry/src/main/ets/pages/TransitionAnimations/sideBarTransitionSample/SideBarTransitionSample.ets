import { TitleBar } from '../../../common/TitleBar'
@Extend(Column) function columnStyle() {
  .padding(16)
  .borderRadius(24)
  .backgroundColor(Color.White)
  .margin({ top: 20, left: 20, right: 20, bottom: 20 })
}

@Entry
@Component
struct SideBarTransitionSample {
  @State arr: number[] = [1, 2, 3]
  @State current: number = 1
  @State mShowSideBar: boolean = false
  @State mSideBarContainerType: SideBarContainerType = SideBarContainerType.Embed

  build() {
    Column() {
      TitleBar({ title: $r('app.string.side_bar_effects_title') })
      SideBarContainer(this.mSideBarContainerType) {
        Column() {
          ForEach(this.arr, (item:number) => {
            Column({ space: 5 }) {
              Image($r('app.media.icon')).width(64).height(64)
              Text(item + '')
                .fontSize(25)
                .fontColor(this.current === item ? $r('app.color.tab_bar_select') : $r('app.color.tab_bar_unselect'))
            }
            .onClick(() => {
              this.current = item
            })
          }, (item:number) => item.toString())
        }
        .visibility(this.mShowSideBar ? Visibility.Visible : Visibility.Hidden)
        .width('100%')
        .justifyContent(FlexAlign.SpaceEvenly)
        .backgroundColor($r('app.color.contentArea_background_color'))

        Column() {
          Column() {
            Button(this.mShowSideBar ? $r('app.string.hide_side_bar') : $r('app.string.show_side_bar'))
              .onClick(() => {
                animateTo({ duration: 2000 }, () => {
                  this.mShowSideBar = !this.mShowSideBar
                })
              })
              .id('hide_or_show_sideBar')
              .margin({ bottom: 5 })
          }
          .columnStyle()
        }
      }
      .showControlButton(false)
      .showSideBar(this.mShowSideBar)
      .sideBarWidth(150)
      .minSideBarWidth(50)
      .maxSideBarWidth(300)
    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}
