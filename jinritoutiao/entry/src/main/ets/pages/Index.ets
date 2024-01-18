/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { NewHomePage } from './news/NewHomePage'
import { BotItem, NavTop, TopItem } from './util/Mock'
import { LogInPage } from './LogInPage'
import { TopSearch } from './components/TopSearch'
import { VideoPage } from './video/VideoPage'

@Entry
@Component
struct Index {
  @State botSelect: number = 0
  @State topSelect: number = 1
  private topController: TabsController = new TabsController()
  private botController: TabsController = new TabsController()
  @State showLogIn: boolean = false
  @State logInHeight: string = '0'

  @Builder
  TabBotBuilder(item: BotItem, index: number) {
    Column() {
      Image(this.botSelect === index ? item.icon_selected : item.icon_normal)
        .width(22)
        .height(22)
        .objectFit(ImageFit.Contain)
      Text(item.text)
        .fontSize(12)
        .fontColor(this.botSelect === index ? '#f04142' : '#000')
        .margin({ top: 4 })
    }
    .border({ width: { top: 1 }, color: '#999' })
    .backgroundColor(Color.White)
    .onClick(() => {
      if (index !== 3) {
        this.botSelect = index
      } else {
        animateTo({
          duration: 200,
          curve: Curve.Linear
        }, () => {
          this.showLogIn = true
          this.logInHeight = '100%'
        })
      }
    })
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }

  @Builder
  TabTopBuilder(item: TopItem, index: number) {
    Column() {
      Text(item.title)
        .fontSize(16)
        .fontColor(this.topSelect === index ? '#f04142' : '#000')
      Divider()
        .strokeWidth(2)
        .color('#f04142')
        .width(20)
        .opacity(this.topSelect === index ? 1 : 0)
        .margin({ top: 3 })
      Divider()
        .strokeWidth(1)
        .color(Color.Grey)
        .width('100%')
        .opacity(0.3)
    }
    .width(50)
    .height(30)
    .backgroundColor(Color.White)
    .onClick(() => {
      this.topSelect = index
    })
  }

  @Builder
  ShopLogIn() {
    Column() {
      Image($r('app.media.anquan'))
        .height(50)
        .width(50)
      Text('您还没有登录头条账号')
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 15 })
        .fontColor(Color.Black)
      Text('登录头条账号进入商城， 可领取更多权益')
        .fontColor('#999')
        .fontSize(12)
        .margin({ bottom: 80 })
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text('立即登录').fontColor(Color.White)
          .fontSize(14)
      }
      .width('100%')
      .height(36)
      .backgroundColor('#f04142')
      .onClick(() => {
        animateTo({
          duration: 200,
          curve: Curve.Linear
        }, () => {
          this.showLogIn = true
          this.logInHeight = '100%'
        })
      })
    }
    .padding(20)
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Tabs({ barPosition: BarPosition.End, controller: this.botController, index: this.botSelect }) {
          TabContent() {
            Column() {
              TopSearch()
              Tabs({ barPosition: BarPosition.Start, controller: this.topController, index: this.topSelect, }) {
                TabContent() {
                  Column() {
                    Text('关注感兴趣的人和事')
                      .fontSize(15)
                      .fontColor('#f04142')
                  }
                }.tabBar(this.TabTopBuilder({
                  title: '关注',
                  content: '关注内容'
                }, 0))

                ForEach(NavTop, (t: TopItem, i: number) => {
                  TabContent() {
                    NewHomePage()
                  }.tabBar(this.TabTopBuilder(t, i + 1))
                }, (t: TopItem, i: number) => i.toString())
              }
              .barMode(BarMode.Scrollable)
              .onChange((index: number) => {
                this.topSelect = index
              })
            }
          }
          .tabBar(this.TabBotBuilder({
            icon_normal: $r('app.media.ic_public_view_list'),
            icon_selected: $r('app.media.ic_public_view_list_click'),
            text: '首页',
          }, 0))

          TabContent() {
            VideoPage()
          }
          .tabBar(this.TabBotBuilder({
            icon_normal: $r('app.media.ic_public_play'),
            icon_selected: $r('app.media.ic_public_play_click'),
            text: '视频',
          }, 1))

          TabContent() {
            this.ShopLogIn()
          }
          .tabBar(this.TabBotBuilder({
            icon_normal: $r('app.media.ic_public_appstore'),
            icon_selected: $r('app.media.ic_public_appstore_click'),
            text: '商城',
          }, 2))

          TabContent()
            .tabBar(
              this.TabBotBuilder({
                icon_normal: $r('app.media.ic_public_contacts'),
                icon_selected: $r('app.media.ic_public_contacts_click'),
                text: '未登录',
              }, 3)
            )
        }
        .scrollable(false)
        .onChange((index: number) => {
          this.botSelect = index
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.White)
      .padding({ bottom: 20 })

      LogInPage({ showLogIn: this.showLogIn, logInHeight: this.logInHeight })
    }
  }
}