import router from '@ohos.router'
import { LogIn } from '../components/LogIn'
import { formatDate, getReviewList } from '../util/Common'
import { Review, WhereRandom } from '../util/Mock'
import { ImageList } from '../util/Request'

interface Params {
  source: string
  digg_count: number
  title: string
  comment_count: number
  publish_time: number
  share_count: number
  avatar_url: string
  content: string,
  image_list: Resource[]
}

class itTmp {
  $rect: string = ''
}

@Entry
@Component
struct NewDetails {
  scroller: Scroller = new Scroller()
  rowScroller: Scroller = new Scroller()
  @State shareHeight: number = -9999
  @State isShare: boolean = false
  @State scrollTop: number = 0
  @State shareOpacity: number = 0
  @State isLogIn: boolean = false
  @State shareOverLay: string = 'share'
  @State isLoading: boolean = false
  @State source: string = '' //author
  @State diggCount: number = 0 // of Likes
  @State title: string = '' // news title
  @State commentCount: number = 0 // review
  @State publishTime: number = 0 // Release time
  @State shareCount: number = 0 // Number of shares
  @State avatarUrl: string = '' //Author profile picture
  @State content: string = '' //Article content
  @State imageList: Resource[] = []
  @State review: Review[] = []
  @State isLoadAll: boolean = false
  @State isTopMore: boolean = false
  @State isReviewY: number = 0

  aboutToAppear() {
    let params = router.getParams() as Params
    console.log('params.image_list', JSON.stringify(params.image_list))
    this.source = params.source
    this.diggCount = params.digg_count
    this.title = params.title
    this.commentCount = params.comment_count
    this.publishTime = params.publish_time
    this.shareCount = params.share_count
    this.avatarUrl = params.avatar_url
    this.content = params.content
    this.imageList = params.image_list
    if (params.comment_count >= 10) {
      this.review = getReviewList(10)
    } else {
      this.review = getReviewList(params.comment_count)
    }
    const count: number = this.content ? 200 : 180
    if (params.image_list.length) {
      this.isReviewY = this.imageList.length * 300 + (this.imageList.length - 1) * 20 + count
    } else {
      this.isReviewY = 170
    }
  }

  @Builder
  LargeOverlayNode() {
    Column()
      .height(this.isShare ? '100%' : 0)
      .width(this.isShare ? '100%' : 0)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor(Color.Grey)
      .opacity(0.2)
      .onClick(() => {
        if (this.shareOverLay == 'share') {
          this.isShare = false
          this.isTopMore = false
          animateTo({
            duration: 100,
            curve: Curve.Friction,
            iterations: 1,
            playMode: PlayMode.Alternate,
          }, () => {
            this.shareHeight = 0
            this.shareOpacity = 0
          });
        }
      })
  }

  @Builder
  OverlayNode() {
    Column()
      .height(30)
      .width(30)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor(Color.Grey)
      .opacity(0.3)
      .borderRadius(15)
  }

  @Builder
  Review() {
    Column() {
      // Comment header
      Column() {
        Flex({ justifyContent: FlexAlign.SpaceBetween }) {
          Text(`评论 ${this.commentCount}`).width('50%').id('review').fontColor(Color.Black)
          Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
            Text(`${this.diggCount} 赞`)
              .fontColor(Color.Grey)
              .fontSize(14)
            Divider()
              .strokeWidth(1)
              .color(Color.Grey)
              .vertical(true)
              .height(10)
              .margin({ left: 10, right: 10 })
            Text(`${this.shareCount} 转发`)
              .fontColor(Color.Grey)
              .fontSize(14)
          }
        }
        .width('100%')
      }

      // Comment details
      Column() {
        ForEach(this.review, (t: Review, i: number) => {
          Flex({ direction: FlexDirection.Column }) {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Row() {
                Column() {
                  Image(t.img)
                    .height(30)
                    .width(30)
                    .objectFit(ImageFit.Contain)
                    .overlay(this.OverlayNode(), { align: Alignment.Center })
                    .borderRadius(15)
                }
                .borderRadius(13)

                Column() {
                  Text(t.name)
                    .fontSize(12)
                    .width('100%')
                    .fontColor(Color.Black)
                }
                .padding({ left: 10, right: 10 })
              }

              Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
                Image($r('app.media.ic_love'))
                  .width(18)
                  .height(18)
                  .objectFit(ImageFit.Contain)
                  .margin({ right: 8 })
                Text(`${t.love ? t.love : '赞'}`)
                  .fontSize(t.love ? 14 : 12)
                  .fontColor(Color.Black)
              }
            }

            Flex({
              direction: FlexDirection.Column,
              justifyContent: FlexAlign.SpaceBetween,
              alignItems: ItemAlign.Start
            }) {
              Text(t.content)
                .fontSize(15)
                .margin({ bottom: 10 })
                .fontColor(Color.Black)
              Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                Text('回复 >')
                  .backgroundColor('#f2f3f5')
                  .fontColor('#000')
                  .fontSize(10)
                  .textAlign(TextAlign.Center)
                  .borderRadius(5)
                  .padding(5)
                  .margin({ right: 10 })
                Text(`${t.ago} · ${t.where}`)
                  .fontSize(10)
                  .fontColor(Color.Grey)
              }
            }
            .padding({ left: 40, top: 10 })
          }
        })
      }
      .width('100%')
      .padding({ top: 15 })

    }
    .padding(10)
    .width('100%')
  }

  @Builder
  ShareColumn() {
    Column() {
      Column() {
        List({ space: 20 }) {
          ListItem() {
            Column() {
              Column() {
                Image($r('app.media.toutiao'))
                  .width(30)
                  .height(30)
                  .objectFit(ImageFit.Contain)
              }
              .padding(8)
              .borderRadius(23)
              .backgroundColor(Color.White)

              Text('转发到头条')
                .fontSize(10)
                .margin({ top: 10 })
                .fontColor(Color.Black)
            }
          }

          ListItem() {
            Column() {
              Column() {
                Image($r('app.media.share_icon'))
                  .width(30)
                  .height(30)
                  .objectFit(ImageFit.Contain)
              }
              .padding(8)
              .borderRadius(23)
              .backgroundColor(Color.White)

              Text('生成分享图')
                .fontSize(10)
                .margin({ top: 10 })
                .fontColor(Color.Black)
            }
          }

          ListItem() {
            Column() {
              Column() {
                Image($r('app.media.wei_xin'))
                  .width(30)
                  .height(30)
                  .objectFit(ImageFit.Contain)
              }
              .padding(8)
              .borderRadius(23)
              .backgroundColor(Color.White)

              Text('微信')
                .fontSize(10)
                .margin({ top: 10 })
                .fontColor(Color.Black)
            }
          }

          ListItem() {
            Column() {
              Column() {
                Image($r('app.media.peng_you_quan'))
                  .width(30)
                  .height(30)
                  .objectFit(ImageFit.Contain)
              }
              .padding(8)
              .borderRadius(23)
              .backgroundColor(Color.White)

              Text('朋友圈')
                .fontSize(10)
                .margin({ top: 10 })
                .fontColor(Color.Black)
            }
          }

          ListItem() {
            Column() {
              Column() {
                Image($r('app.media.douyinhaoyou'))
                  .width(30)
                  .height(30)
                  .objectFit(ImageFit.Contain)
              }
              .padding(8)
              .borderRadius(23)
              .backgroundColor(Color.White)

              Text('抖音好友')
                .fontSize(10)
                .margin({ top: 10 })
                .fontColor(Color.Black)
            }
          }

          ListItem() {
            Column() {
              Column() {
                Image($r('app.media.douyinrichang'))
                  .width(30)
                  .height(30)
                  .objectFit(ImageFit.Contain)
              }
              .padding(8)
              .borderRadius(23)
              .backgroundColor(Color.White)

              Text('抖音日常')
                .fontSize(10)
                .margin({ top: 10 })
                .fontColor(Color.Black)
            }
          }

          ListItem() {
            Column() {
              Column() {
                Image($r('app.media.youjian'))
                  .width(30)
                  .height(30)
                  .objectFit(ImageFit.Contain)
              }
              .padding(8)
              .borderRadius(23)
              .backgroundColor(Color.White)

              Text('私信')
                .fontSize(10)
                .margin({ top: 10 })
                .fontColor(Color.Black)
            }
          }

          ListItem() {
            Column() {
              Column() {
                Image($r('app.media.xitongfenxiang'))
                  .width(30)
                  .height(30)
                  .objectFit(ImageFit.Contain)
              }
              .padding(8)
              .borderRadius(23)
              .backgroundColor(Color.White)

              Text('系统分享')
                .fontSize(10)
                .margin({ top: 10 })
                .fontColor(Color.Black)
            }
          }

          ListItem() {
            Column() {
              Column() {
                Image($r('app.media.fuzhilianjie'))
                  .width(30)
                  .height(30)
                  .objectFit(ImageFit.Contain)
              }
              .padding(8)
              .borderRadius(23)
              .backgroundColor(Color.White)

              Text('复制链接')
                .fontSize(10)
                .margin({ top: 10 })
                .fontColor(Color.Black)
            }
          }
        }
        .listDirection(Axis.Horizontal)
        .scrollBar(BarState.Off)
      }
      .backgroundColor('#f2f3f5')
      .height(110)
      .padding({ top: 20, right: 15, bottom: 12, left: 15 })

      if (this.isTopMore) {
        Column() {
          Divider()
            .strokeWidth(1)
            .color('#999')
            .width('100%')
            .opacity(0.3)
            .margin({ top: -10, bottom: 10 })
          List({ space: 20 }) {
            ListItem() {
              Column() {
                Column() {
                  Image($r('app.media.shoucang'))
                    .width(30)
                    .height(30)
                    .objectFit(ImageFit.Contain)
                }
                .padding(8)
                .borderRadius(23)
                .backgroundColor(Color.White)

                Text('收藏')
                  .fontSize(10)
                  .margin({ top: 10 })
                  .fontColor(Color.Black)
              }
            }

            ListItem() {
              Column() {
                Column() {
                  Image($r('app.media.shaohou'))
                    .width(30)
                    .height(30)
                    .objectFit(ImageFit.Contain)
                }
                .padding(8)
                .borderRadius(23)
                .backgroundColor(Color.White)

                Text('稍后再看')
                  .fontSize(10)
                  .margin({ top: 10 })
                  .fontColor(Color.Black)
              }
            }

            ListItem() {
              Column() {
                Column() {
                  Image($r('app.media.gantanhao'))
                    .width(30)
                    .height(30)
                    .objectFit(ImageFit.Contain)
                }
                .padding(8)
                .borderRadius(23)
                .backgroundColor(Color.White)

                Text('内容举报')
                  .fontSize(10)
                  .margin({ top: 10 })
                  .fontColor(Color.Black)
              }
            }

            ListItem() {
              Column() {
                Column() {
                  Image($r('app.media.fankui'))
                    .width(30)
                    .height(30)
                    .objectFit(ImageFit.Contain)
                }
                .padding(8)
                .borderRadius(23)
                .backgroundColor(Color.White)

                Text('功能反馈')
                  .fontSize(10)
                  .margin({ top: 10 })
                  .fontColor(Color.Black)
              }
            }

            ListItem() {
              Column() {
                Column() {
                  Image($r('app.media.ziti'))
                    .width(30)
                    .height(30)
                    .objectFit(ImageFit.Contain)
                }
                .padding(8)
                .borderRadius(23)
                .backgroundColor(Color.White)

                Text('字体设置')
                  .fontSize(10)
                  .margin({ top: 10 })
                  .fontColor(Color.Black)
              }
            }

            ListItem() {
              Column() {
                Column() {
                  Image($r('app.media.shense'))
                    .width(30)
                    .height(30)
                    .objectFit(ImageFit.Contain)
                }
                .padding(8)
                .borderRadius(23)
                .backgroundColor(Color.White)

                Text('深色模式')
                  .fontSize(10)
                  .margin({ top: 10 })
                  .fontColor(Color.Black)
              }
            }
          }
          .listDirection(Axis.Horizontal)
          .scrollBar(BarState.Off)
        }
        .backgroundColor('#f2f3f5')
        .height(100)
        .padding(15)
      }

      Column() {
        Text('取消').fontSize(15).fontColor('#000')
      }
      .height(30)
      .padding({ top: 10 })
      .onClick(() => {
        this.isShare = false
        this.isTopMore = false
        animateTo({
          duration: 100,
          curve: Curve.Friction,
          iterations: 1,
          playMode: PlayMode.Alternate,
        }, () => {
          this.shareHeight = 0
          this.shareOpacity = 0
        });
      })
    }
    .backgroundColor(Color.White)
    .height(this.shareHeight)
    .opacity(this.shareOpacity)
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Stack({ alignContent: Alignment.Bottom }) {
        Column() {
          Column() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Column() {
                Image($r('app.media.ic_public_arrow_left'))
                  .width(18)
                  .height(18)
                  .objectFit(ImageFit.Contain)
              }
              .padding({ right: 8 })
              .onClick(() => {
                router.back()
              })

              Search({ placeholder: '搜你想看的' })
                .height(40)
                .backgroundColor("#f1f3f4")
                .placeholderColor(Color.Grey)
                .placeholderFont({ size: 12 })
              Column() {
                Image($r('app.media.ic_device_earphone_filled'))
                  .width(21)
                  .height(18)
                  .objectFit(ImageFit.Contain)
              }
              .margin({ left: 12, right: 15 })

              Column() {
                Image($r('app.media.ic_more'))
                  .width(20)
                  .height(20)
                  .objectFit(ImageFit.Contain)
              }
              .onClick(() => {
                this.isTopMore = true
                animateTo({
                  duration: 300,
                  curve: Curve.Smooth,
                  playMode: PlayMode.Normal,
                }, () => {
                  this.shareHeight = 250
                  this.shareOpacity = 1
                });
                this.isShare = true
                this.shareOverLay = 'share'
              })
            }
          }
          .padding({ top: 20, left: 10, right: 10 })
          .height('10%')

          Column() {
            Scroll(this.scroller) {
              Column() {
                Column() {
                  Text(this.title)
                    .textAlign(TextAlign.Start)
                    .width('100%')
                    .fontWeight(FontWeight.Bold)
                    .fontSize(18)
                    .letterSpacing(2)
                    .id('textTitle')
                    .fontColor(Color.Black)
                  Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                    Row() {
                      Column() {
                        Image(this.avatarUrl)
                          .height(30)
                          .width(30)
                          .objectFit(ImageFit.Contain)
                          .overlay(this.OverlayNode(), { align: Alignment.Center })
                          .borderRadius(15)
                      }
                      .borderRadius(13)

                      Column() {
                        Text(this.source)
                          .fontSize(12)
                          .width('100%')
                          .fontColor(Color.Black)
                        Text(`${formatDate(this.publishTime)} ${WhereRandom} ${this.source}`)
                          .fontSize(10)
                          .fontColor(Color.Grey)
                          .width('100%')
                      }
                      .padding({ left: 10, right: 10 })
                    }.width('85%')

                    Button() {
                      if (this.isLoading) {
                        Image($r('app.media.loading'))
                          .height(22)
                          .width(22)
                      } else {
                        Text('关注')
                          .fontSize(12)
                          .fontColor('#fff')
                          .textAlign(TextAlign.Center)
                      }
                    }
                    .height(22)
                    .width(45)
                    .backgroundColor('#f04142')
                    .onClick(() => {
                      this.shareOverLay = 'watch'
                      this.isShare = true
                      this.isLoading = true
                      animateTo({
                        duration: 500,
                        curve: Curve.Smooth,
                        playMode: PlayMode.Normal,
                      }, () => {
                        this.isLogIn = true
                      });
                    })
                  }
                  .padding({ top: 15 })
                }
                .padding({ left: 10, right: 10, top: 15, bottom: 15 })

                Column() {
                  Text(this.content)
                    .letterSpacing(2)
                    .fontSize(16)
                    .margin({ top: 5, bottom: 5 })
                    .fontColor(Color.Black)
                  if (this.imageList.length) {
                    ForEach(this.imageList, (t: ImageList, i: number) => {
                      Column() {
                        Image(t.url).height(300).width(300)
                      }
                      .margin({ bottom: 20 })
                    })
                  }
                }

                this.Review()
                if (this.isLoadAll) {
                  Column() {
                    Text('已显示全部评论')
                      .fontColor('#999')
                      .fontSize(14)
                  }
                  .height(100)
                  .margin({ top: 20 })
                }
              }
              .width('100%')
              .padding(10)
            }
            .scrollBarWidth(3)
            .onWillScroll(() => {
              if (this.scroller.isAtEnd()) {
                let remainder = this.commentCount % 10
                if (remainder) {
                  if (this.review.length == this.commentCount) {
                    this.isLoadAll = true
                    return
                  } else {
                    if (this.review.length == (this.commentCount - remainder)) {
                      this.review = this.review.concat(getReviewList(remainder))
                    } else {
                      this.review = this.review.concat(getReviewList(10))
                    }
                  }
                } else {
                  if (this.review.length !== this.commentCount) {
                    this.review = this.review.concat(getReviewList(10))
                  } else {
                    this.isLoadAll = true
                    return
                  }
                }
              }
            })
          }
          .height('82%')

          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Image($r('app.media.ic_share'))
                .width(20)
                .height(20)
                .objectFit(ImageFit.Contain)
                .margin({ right: 8 })
              Text('分享').fontColor(Color.Black)
            }
            .onClick(() => {
              animateTo({
                duration: 300,
                curve: Curve.Smooth,
                playMode: PlayMode.Normal,
              }, () => {
                this.shareHeight = 150
                this.shareOpacity = 1
              });
              this.isShare = true
              this.shareOverLay = 'share'
            })

            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Image($r('app.media.ic_review'))
                .width(20)
                .height(20)
                .objectFit(ImageFit.Contain)
                .margin({ right: 8 })
              Text(`${this.commentCount}`).fontColor(Color.Black)
            }
            .onClick(() => {
              this.scroller.scrollTo({ xOffset: 0, yOffset: this.isReviewY, animation: {
                duration: 500,
                curve: Curve.Smooth
              } })
            })

            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Image($r('app.media.ic_love'))
                .width(20)
                .height(20)
                .objectFit(ImageFit.Contain)
                .margin({ right: 8 })
              Text(`${this.diggCount}`).fontColor(Color.Black)
            }
            .onClick(() => {
              this.shareOverLay = 'love'
              this.isShare = true
              animateTo({
                duration: 500,
                curve: Curve.Smooth,
                playMode: PlayMode.Normal,
              }, () => {
                this.isLogIn = true
              });
            })

            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Image($r('app.media.ic_collect'))
                .width(20)
                .height(20)
                .objectFit(ImageFit.Contain)
                .margin({ right: 8 })
              Text(`${this.shareCount}`).fontColor(Color.Black)
            }
            .onClick(() => {
              this.shareOverLay = 'collect'
              this.isShare = true
              animateTo({
                duration: 500,
                curve: Curve.Smooth,
                playMode: PlayMode.Normal,
              }, () => {
                this.isLogIn = true
              });
            })
          }
          .padding({ left: 10, right: 10, bottom: 10 })
          .backgroundColor(Color.White)
          .height('8%')
        }
        .overlay(this.LargeOverlayNode(), { align: Alignment.Center })
        .backgroundColor(Color.White)

        this.ShareColumn()
      }

      if (this.isLogIn) {
        LogIn({
          isLogIn: this.isLogIn,
          isShare: this.isShare,
          shareOverLay: this.shareOverLay,
          isLoading: this.isLoading
        })
      }
    }
  }
}