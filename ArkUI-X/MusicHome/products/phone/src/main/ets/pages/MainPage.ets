/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import { BreakpointConstants, HomeConstants, StyleConstants } from '@ohos/constantsCommon';
import { IndexItemData, IndexViewModel, Logger } from '@ohos/mediaCommon';

@Entry
@Component
struct MainPage {
  @State indexItemList: IndexItemData[] = IndexViewModel.getIndexItemList();

  dynamicLoading(): void {
    try {
      import('@ohos/live/src/main/ets/view/LivePage');
      import('@ohos/musicList/src/main/ets/view/MusicListPage');
      import('@ohos/musicComment/src/main/ets/view/MusicCommentPage');
    } catch (err) {
      Logger.error('dynamicLoading error:' + err);
    }
  }

  aboutToAppear() {
    this.dynamicLoading();
  }

  build() {
    Navigation() {
      Scroll() {
        GridRow({
          breakpoints: {
            value: BreakpointConstants.BREAKPOINT_VALUE,
            reference: BreakpointsReference.WindowSize
          },
          columns: {
            sm: BreakpointConstants.COLUMN_SM,
            md: BreakpointConstants.COLUMN_MD,
            lg: BreakpointConstants.COLUMN_LG
          },
          gutter: { x: BreakpointConstants.GUTTER_X },
          direction: GridRowDirection.Row
        }) {
          GridCol({
            span: {
              sm: BreakpointConstants.SPAN_SM,
              md: BreakpointConstants.SPAN_MD,
              lg: BreakpointConstants.SPAN_LG
            },
            offset: {
              md: BreakpointConstants.OFFSET_MD,
              lg: BreakpointConstants.OFFSET_LG
            }
          }) {
            Column({ space: HomeConstants.COLUMN_SPACE }) {
              ForEach(this.indexItemList, (item: IndexItemData) => {
                Column() {
                  Text(item.title)
                    .fontSize($r('app.float.title_font_size'))
                    .fontColor(Color.White)
                  Text(item.description)
                    .fontSize($r('app.float.description_font_size'))
                    .opacity(HomeConstants.TEXT_OPACITY)
                    .fontColor(Color.White)
                    .margin({
                      top: $r('app.float.description_margin_top')
                    })
                  Blank()
                  Column() {
                    Button() {
                      Text(item.button)
                        .fontSize($r('app.float.button_font_size'))
                        .fontColor(Color.White)
                    }
                    .backgroundColor($r('app.color.button_background_color'))
                    .borderRadius($r('app.float.button_border_radius'))
                    .width($r('app.float.button_width'))
                    .height($r('app.float.button_height'))
                    .onClick(() => {
                      router.pushNamedRoute({
                        name: item.url,
                        params: null
                      })
                    })
                  }
                  .alignItems(HorizontalAlign.End)
                  .width(StyleConstants.FULL_PERCENT)
                }
                .width(StyleConstants.FULL_PERCENT)
                .height($r('app.float.item_height'))
                .backgroundImage(item.icon)
                .backgroundImageSize({
                  width: StyleConstants.FULL_PERCENT,
                  height: $r('app.float.item_height')
                })
                .borderRadius($r('app.float.item_border_radius'))
                .padding($r('app.float.item_padding'))
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.SpaceBetween)
              }, (item: IndexItemData, index?: number) => index + JSON.stringify(item.url))
            }
          }
        }
        .padding({
          top: $r('app.float.column_padding_top'),
          bottom: $r('app.float.column_padding_top'),
          left: $r('app.float.column_padding_left'),
          right: $r('app.float.column_padding_right')
        })
      }.scrollBar(BarState.Off)
    }
    .mode(NavigationMode.Stack)
    .height(StyleConstants.FULL_PERCENT)
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}