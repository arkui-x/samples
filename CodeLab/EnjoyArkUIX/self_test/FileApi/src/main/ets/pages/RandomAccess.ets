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
import router from '@ohos.router'
import { TitleBar } from './MainPage';

@Entry
@Component
struct Index {
  @State title: string = ''

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    console.info('router.getParams() title is ' + params.title)
    this.title = params.title
  }
  build() {
    Column({ space: 10 }) {
      TitleBar({ title: this.title }).size({ height: '10%' })
      List({ space: 10 }) {
        ForEach(pages, (item: PageItem) => {
          ListItem() {
            RouterComponent({ pageItem: item })
          }
        })
      }
      .alignListItem(ListItemAlign.Center)
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width("100%")
    .height("100%")
  }
}

@Component
struct RouterComponent {
  public pageItem: PageItem = new PageItem("", "");
  build() {
    Button(this.pageItem.text)
      .onClick(() => {
        router.pushUrl({
          url: this.pageItem.url,
          params: {
            title: this.pageItem.text
          }
        })
      })
      .width(350)
      .height(60)
  }
}

class PageItem {
  public text: string = "";
  public url: string = "";

  constructor(text: string, url: string) {
    this.text = text;
    this.url = url;
  }
}

const pages: PageItem[] = [
  new PageItem("createRandomAccessFile", "pages/Test/RandomAccess/RandomAccess_file"),
  new PageItem("Read&Write", "pages/Test/RandomAccess/RandomAccess_rw"),
]