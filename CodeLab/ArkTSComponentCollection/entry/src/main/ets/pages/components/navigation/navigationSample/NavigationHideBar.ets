/*
 * Copyright (c) 2025 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import { TitleBar } from '../../../../common/TitleBar';

class Pages {
  names: string = "";
  values: NavPathStack | null = null;
  listIndex: number = 0;
}

@Entry
@Component
struct NavigationHideBar {
  navarray: number[] = [1, 2, 3];
  contentarray: number[] = [1, 2, 3, 4];
  @State expand: boolean = false;
  @State selectnav: number = -1;
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  private context: Context = getContext(this);
  @State hide: boolean = false;

  @Builder
  PageMap(name: string, param: number) {
    this.pageList({ names: name, values: this.pageInfos, listIndex: param });
  }

  @Builder
  pageList(info: Pages) {
    NavDestination() {
      List() {
        ForEach(this.contentarray, (contentidx: number) => {
          ListItem() {
            Row() {
              Text($r('app.string.navigation_navcontent_list', contentidx))
                .fontSize(16)
              Blank()
              Image($r('app.media.ic_right_arrow'))
                .objectFit(ImageFit.ScaleDown)
                .height(22)
            }
            .height(48)
            .padding({ top: 13, bottom: 13 })
            .width('100%')
          }
        })
      }
      .borderRadius('24')
      .backgroundColor(Color.White)
      .width('95%')
      .padding(12)
    }
    .title(this.context.resourceManager.getStringSync($r('app.string.navigation_navbar_list_nopara')) + info.listIndex)
    .backgroundColor($r('app.color.background_shallow_grey'))
    .onBackPressed(() => {
      let stack: NavPathStack = info.values as NavPathStack;
      stack.pop();
      this.selectnav = stack.getParamByIndex(stack.size() - 1) as number;
      return true;
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Navigation(this.pageInfos) {
        TitleBar({ title: $r('app.string.navigation_split_title') })
        Column() {
          ForEach(this.navarray, (navidx: number) => {
            Row() {
              Text($r('app.string.navigation_navbar_list', navidx))
                .fontSize(16)
              Blank()
              Image($r('app.media.ic_right_arrow'))
                .objectFit(ImageFit.ScaleDown)
                .height(22)
            }
            .height(48)
            .padding(13)
            .width('90%')
            .borderRadius(24)
            .backgroundColor(this.selectnav === navidx ? 0x007DFF : Color.Transparent)
            .onClick(() => {
              this.selectnav = navidx;
              this.pageInfos.pushPath({ name: `List${navidx}`, param: navidx });
            })
            .id(`nav${navidx}`)
          })
        }
        .backgroundColor(Color.White)
        .borderRadius(24)
        .padding(5)
        .id('navbar')
      }
      .hideTitleBar(true)
      .navDestination(this.PageMap)
      .mode(NavigationMode.Split)
      .width('100%')
      .height('90%')
      .hideNavBar(this.hide)

      Row() {
        Image($r('app.media.ic_navigation_hidebar'))
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.hide = !this.hide;
          })
          .id('hide')
      }
      .height(56)
      .padding({ right: 26 })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}