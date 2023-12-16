@Component
export struct LogIn {
  @Link isLogIn: boolean
  @Link isShare: boolean
  @Link isLoading: boolean
  @Link shareOverLay: string

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        Image($r('app.media.cha'))
          .height(20)
          .width(20)
          .position({ x: 215, y: -15 })
          .onClick(() => {
            this.isShare = false
            animateTo({
              duration: 100,
              curve: Curve.Smooth,
              playMode: PlayMode.Normal,
            }, () => {
              this.isLogIn = false
            });
            if (this.shareOverLay === 'watch') {
              this.isLoading = false
            }
          })
        Text(`登录后可${this.shareOverLay == 'love' ? '点赞' : this.shareOverLay == 'collect' ? '收藏' : '关注'}`)
          .fontSize(14)
          .margin({ bottom: 5 })
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

        Column() {
          Image($r('app.media.toutiao'))
            .width(50)
            .height(50)
            .objectFit(ImageFit.Contain)
        }
        .borderRadius(10)
        .border({ width: 1, color: '#c9c9c9' })
        .backgroundColor(Color.White)
        .margin({ top: 25, bottom: 25 })

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

        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text('其他登录方式')
            .fontSize(12)
          Text('遇到问题')
            .fontSize(12)
        }
        .margin({ bottom: 20 })

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

      }
      .backgroundColor(Color.White)
      .height(360)
      .width(250)
      .padding({ top: 20, left: 10, right: 10 })
      .borderRadius(10)
    }
  }
}