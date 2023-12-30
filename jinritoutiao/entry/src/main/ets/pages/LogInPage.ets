@Component
export struct LogInPage {
  @Link showLogIn: boolean
  @Link logInHeight: string

  build() {
    Column() {
      Column() {
        Image($r('app.media.cha'))
          .height(20)
          .width(20)
          .position({ x: 0, y: -15 })
          .onClick(() => {
            animateTo({
              duration: 100,
              curve: Curve.Linear,
              onFinish: () => {
                this.showLogIn = false
              }
            }, () => {
              this.logInHeight = '0'
            })
          })
        Flex({
          direction: FlexDirection.Column,
          justifyContent: FlexAlign.SpaceBetween,
          alignItems: ItemAlign.Center
        }) {
          Column() {
            Text('登录你的头条  精彩永不丢失')
              .fontSize(18)
              .margin({ bottom: 5 })
              .fontWeight(FontWeight.Bold)

            Column() {
              Image($r('app.media.toutiao'))
                .width(50)
                .height(50)
                .objectFit(ImageFit.Contain)
            }
            .borderRadius(10)
            .border({ width: 1, color: '#c9c9c9' })
            .backgroundColor(Color.White)
            .margin({ top: 80, bottom: 80 })

            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Image($r('app.media.denglu'))
                .height(15)
                .width(15)
                .margin({ right: 10 })
              Text('一键登录')
                .fontSize(12)
                .fontColor(Color.White)

            }
            .width('100%')
            .height(36)
            .backgroundColor('#f04142')
            .margin({ bottom: 10 })

            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Checkbox()
                .width(12)
                .height(12)
                .selectedColor('#f04142')
              Text() {
                Span('已阅读并同意')
                  .fontColor('#999999')
                Span(' 用户协议')
                Span(' 和 ')
                  .fontColor('#999999')
                Span('隐私政策')
              }
              .fontSize(10)
            }
          }

          Column() {
            Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
              Text('授权后应用将获得以下权限：')
                .fontSize(10)
                .fontColor('#999')
                .margin({ bottom: 10 })
              Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                Image($r('app.media.duihao'))
                  .width(15)
                  .height(15)
                  .margin({ right: 5 })
                Text('获得你的公开信息（头像昵称、地区和性别）')
                  .fontSize(10)
                  .fontColor('#999')
              }

              Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                Image($r('app.media.duihaoyi'))
                  .width(15)
                  .height(15)
                  .margin({ right: 5 })
                Text('获得你的抖音手机号')
                  .fontSize(10)
                  .fontColor('#999')
              }
              .margin({ bottom: 10, top: 10 })

              Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                Image($r('app.media.duihaoyi'))
                  .width(15)
                  .height(15)
                  .margin({ right: 5 })
                Text('获得你的抖音互关朋友关系')
                  .fontSize(10)
                  .fontColor('#999')
              }
            }
            .height(100)

            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Column() {
                Image($r('app.media.iphone'))
              }
              .height(24)
              .width(24)
              .borderRadius(12)
              .padding(6)
              .border({ width: 0.5, color: '#999' })

              Column() {
                Image($r('app.media.apple'))
              }
              .height(24)
              .width(24)
              .borderRadius(12)
              .padding(6)
              .border({ width: 0.5, color: '#999' })
              .margin({ left: 20, right: 20 })

              Column() {
                Image($r('app.media.ic_more'))
              }
              .height(24)
              .width(24)
              .borderRadius(12)
              .padding(6)
              .border({ width: 0.5, color: '#999' })
            }
            .margin({ top: 20, bottom: 15 })

            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Text('隐私设置')
                .fontSize(12)
                .margin({ right: 15 })
              Text('遇到问题')
                .fontSize(12)
            }
          }

        }
        .backgroundColor(Color.White)
        .borderRadius(10)
        .padding({ top: 50, left: 20, right: 30, bottom: 35 })
      }
    }
    .height(this.logInHeight)
    .width('100%')
    .backgroundColor(Color.White)
    .opacity(this.showLogIn ? 1 : 0)
    .padding({ top: 30, left: 10 })
  }
}