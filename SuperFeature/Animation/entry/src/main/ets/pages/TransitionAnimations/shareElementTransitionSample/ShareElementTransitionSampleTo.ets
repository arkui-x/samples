import router from '@ohos.router'

@Entry
@Component
struct ShareElementTransitionSampleTo {
  @State image: Resource | undefined = undefined
  @State sharedTransitionID: number = -1
  build() {
    Column() {
      Image(this.image)
        .objectFit(ImageFit.Contain)
        .sharedTransition(`sharedImage_${this.sharedTransitionID}`)
        .onClick(() => {
          router.back()
        }).id('test_back')
    }
    .padding(12)
    .backgroundColor(Color.Black)
    .justifyContent(FlexAlign.Center)
  }

  aboutToAppear() {
    const routerParams = router.getParams() as Record<string,Resource|number>
    this.image = routerParams.image as Resource
    this.sharedTransitionID = routerParams.id as number
  }
}