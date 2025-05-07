/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import promptAction from '@ohos.promptAction';
import { ItemPart } from '../components/ItemPart';

const SEARCH_BUTTON: string = '搜索'; // 搜索按钮文字

// 单条信息对象
class ItemData {
  profileImg: Resource = $r('app.media.text_expand_img1');
  rawTitle: Resource = $r('app.string.text_expand_long_title');
  imgUrlList: Resource[] | string[] = [
    $r('app.media.text_expand_img2'),
    $r('app.media.text_expand_img3'),
    $r('app.media.text_expand_img4')
  ];
}

// TabContent对象
class TabData {
  id: number;
  name: string | Resource;
  ItemList: ItemData[] = [
    new ItemData(),
    new ItemData(),
    new ItemData()
  ];

  constructor(id: number, name: string | Resource) {
    this.id = id;
    this.name = name
  }
}

/**
 *
 * 功能描述：本示例介绍了使用@ohos.measure组件接口实现文字段落展开收起的功能，且同时介绍了如何解决图文混排的问题。该场景多用于等。
 *
 * 推荐场景：文字内容过多的场景
 *
 * 核心组件：TextExpandView
 *
 * 实现步骤：
 * 1.设置TextSectionAttribute属性，可以设置文本的最大行数、字体颜色、字体大小、行高以及文本行所占宽度。
 * @example
 * class TextSectionAttribute {
 *     maxLines: number;
 *     fontColor: ResourceStr;
 *     fontSize: Resource | number | string;
 *     lineHeight:number;
 *     constraintWidth: Resource | number | string;
 *
 *     constructor(maxLines: number = 2, fontColor: ResourceStr = '#000',
 *       fontSize: Resource | number | string = '16vp', lineHeight: number = 16,
 *       constraintWidth: Resource | number | string = 350) {
 *       this.maxLines = maxLines;
 *       this.fontColor = fontColor;
 *       this.fontSize = fontSize;
 *       this.lineHeight = lineHeight;
 *       this.constraintWidth = constraintWidth;
 *     }
 *   }
 *
 * 2.设置控制文本段落展开和收齐的文本或者图片属性。参数有文本或者图片的字符所占数、类型(0代表文本，1代表图片)、内容、字体大小或者图片大小、字体颜色
 *   @example
 *   class LastSpanAttribute {
 *     lastSpanType: number;
 *     charactersNumber: number;
 *     content: ResourceStr[];
 *     size: ResourceStr | number;
 *     color: ResourceStr | Color;
 *
 *     constructor(lastSpanType: number, charactersNumber: number = 1,
 *       content: ResourceStr[], size: ResourceStr | number, color: ResourceStr | Color = Color.Orange) {
 *       this.lastSpanType = lastSpanType;
 *       this.charactersNumber = charactersNumber;
 *       this.content = content;
 *       this.size = size;
 *       this.color = color;
 *     }
 *   }
 *
 * 3.引用文本展开收起组件。
 * @example
 *
 * TextExpandView({
 *   rawTitle: this.rawTitle,
 *   textSectionAttribute: this.tabItemIndex % 2 === 0 ? new TextSectionAttribute() :
 *     new TextSectionAttribute(),
 *   lastSpanAttribute: this.tabItemIndex % 2 === 0 ? new LastSpanAttribute(0, 2,
 *     [$r('app.string.text_expand_expand_title'), $r('app.string.text_expand_collapse_title')], 16,
 *     Color.Orange) :
 *     new LastSpanAttribute(1, 1, [$r("app.media.text_expand_arrow_down"), $r('app.media.text_expand_arrow_right')],
 *       16, Color.Orange)
 * }).id(`textClick${this.index}`)
 */

@Component
export struct TextExpand {
  @State currentIndex: number = 0; // 当前索引
  @State changeValue: string = ''; // 搜索框关键词
  private controller: TabsController = new TabsController();
  private controllerSearch: SearchController = new SearchController();
  tabData: TabData[] = [
    new TabData(0, $r('app.string.text_expand_tab_name_main_page')),
    new TabData(1, $r('app.string.text_expand_tab_name_hot')),
    new TabData(2, $r('app.string.text_expand_tab_name_same_city')),
    new TabData(3, $r('app.string.text_expand_tab_name_else'))
  ];

  @Builder
  tabBuilder(index: number, name: string | Resource) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? $r('app.color.text_expand_selected_tab_name') :
        $r('app.color.text_expand_tab_name'))
        .font({
          size: $r('app.integer.text_expand_text_font_size'),
          weight: this.currentIndex === index ? 500 : 400
        })
        .lineHeight($r('app.integer.text_expand_text_line_height'))
        .margin({
          top: $r('app.integer.text_expand_text_margin_top'),
          bottom: $r('app.integer.text_expand_text_margin_bottom')
        })
      Divider()
        .strokeWidth(2)
        .color($r('app.color.text_expand_divider_color'))
        .opacity(this.currentIndex === index ? $r('app.integer.text_expand_divider_opacity_1') :
        $r('app.integer.text_expand_divider_opacity_0'))
    }
    .width($r('app.string.text_expand_layout_100'))
  }

  build() {
    Column() {
      Row() {
        Image($r("app.media.text_expand_search"))
          .width($r("app.integer.text_expand_search_image_width"))
          .aspectRatio(1)
          .margin({ left: $r("app.integer.text_expand_search_margin_left") })
        Text($r("app.string.text_expand_search_placeholder"))
          .opacity(0.6)
          .fontColor($r("app.color.text_expand_black_font_color"))
          .margin({ left: $r("app.integer.text_expand_search_margin_left") })
      }
      .width($r('app.string.text_expand_layout_95'))
      .height($r('app.integer.text_expand_search_height'))
      .backgroundColor($r("app.color.text_expand_search_bg_color"))
      .backgroundColor($r('app.color.text_expand_search_background_color'))

      Tabs({
        barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller
      }) {
        ForEach(this.tabData, (item: TabData, index: number) => {
          TabContent() {
            Column() {
              List({ space: 20, initialIndex: 0 }) {
                ForEach(item.ItemList, (itemData: ItemData, index2: number) => {
                  ItemPart({
                    index: `${index}${index2}`,
                    profileImg: itemData.profileImg,
                    imgUrlList: itemData.imgUrlList,
                    rawTitle: itemData.rawTitle,
                    tabItemIndex: index
                  })
                }, (itemData: ItemData, index2: number) => index2.toString())
              }
              .layoutWeight(1)
              .divider({
                strokeWidth: $r('app.integer.text_expand_divider_stroke_width'),
                color: $r('app.color.text_expand_divider_0c_color')
              })
              .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
            }
            .width($r('app.string.text_expand_layout_100'))
            .height($r('app.string.text_expand_layout_100'))
          }
          .tabBar(this.tabBuilder(item.id, item.name))
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
        }, (item: TabData, index: number) => index.toString())
      }
      .vertical(false)
      .barMode(BarMode.Fixed)
      .barWidth($r('app.integer.text_expand_tab_bar_width'))
      .barHeight($r('app.integer.text_expand_tab_bar_height'))
      .animationDuration(400)
      .onChange((index: number) => {
        // 变更时修改当前索引
        this.currentIndex = index;
      })
      .width($r('app.string.text_expand_layout_100'))
      .layoutWeight(1)
      .backgroundColor($r('app.color.text_expand_bar_background_color'))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .width($r('app.string.text_expand_layout_100'))
    .height($r('app.string.text_expand_layout_100'))
  }
}
