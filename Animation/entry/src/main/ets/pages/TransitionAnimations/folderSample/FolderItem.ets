import promptAction from '@ohos.promptAction'

@Component
export default struct FolderItem {
  @Link isOpen: boolean;
  @Prop img: Resource;
  @Prop name: string;

  build() {
    Stack() {
      if (!this.isOpen) {
        Image(this.img)
          .width('80%')
          .height('80%')
          .borderRadius(3)
          .geometryTransition(`shareIcon${this.name}`)
          .transition({ type: TransitionType.All, opacity: 0 })
      }

      if (this.isOpen) {
        Column() {
          Image(this.img)
            .width('80%')
            .height('80%')
            .borderRadius(10)
          Text(`APP ${this.name}`)
            .margin({ top: 3 })
        }
        .onClick(() => {
          promptAction.showToast({
            message: `click APP ${this.name}`,
            duration: 1000,
          });
        })
        .geometryTransition(`shareIcon${this.name}`)
        .transition({ type: TransitionType.All, opacity: 0 })
      }
    }
  }
}