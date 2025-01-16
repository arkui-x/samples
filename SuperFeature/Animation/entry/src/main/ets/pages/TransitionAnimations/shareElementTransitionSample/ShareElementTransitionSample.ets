import router from '@ohos.router'
import { TitleBar } from '../../../common/TitleBar'

@Entry
@Component
struct ShareElementTransitionSample {
  private imageArr: Resource[] =
    [
    $r('app.media.ic_scenery1'), $r('app.media.ic_scenery2'), $r('app.media.ic_scenery3'), $r('app.media.ic_scenery4'),
    $r('app.media.ic_scenery1'), $r('app.media.ic_scenery2'), $r('app.media.ic_scenery3'), $r('app.media.ic_scenery4')
    ]

  build() {
    Column() {
      TitleBar({ title: $r('app.string.share_element_transition') })
      Grid() {
        ForEach(this.imageArr, (item: Resource, index: number) => {
          GridItem() {
            Image(item)
              .height(120)
              .objectFit(ImageFit.Contain)
          }
          .sharedTransition(`sharedImage_${index}`, {
            delay: 10,
            duration: 2000,
            curve: Curve.FastOutLinearIn,
            type: SharedTransitionEffectType.Exchange,
            // Motion path information, Path is the motion path of the bit movement drawing, using the svg path string
            motionPath: {
              path: 'Mstart.x start.y L300 200 L300 500 Lend.x end.y',
              from: 0.0,
              to: 1.0,
              rotatable: true
            }
          })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/TransitionAnimations/shareElementTransitionSample/ShareElementTransitionSampleTo',
              params: { image: item, id: index }
            })
          }).id('test_grid' + index)
        })
      }
      .padding(12)
      .rowsGap(20)
      .columnsGap(20)
      .layoutWeight(1)
      .columnsTemplate('1fr 1fr 1fr')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}