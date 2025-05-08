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

/**
 * 功能描述：本示例介绍使用TextInput组件与Swiper组件实现搜索框内热搜词自动切换。
 *
 * 推荐场景：需要实现搜索框中有热词循环展示的场景，如新闻搜索页、热搜等
 *
 * 核心组件：
 * 1.SearchSwiperComponent
 *
 * 实现步骤:
 * 1. 使用Swiper组件显示热搜关键字并自动切换。
 * 2. 使用TextInput搜索框组件，根据搜索框是否有内容控制Swiper组件显隐，根据搜索框是否处于编辑态控制Swiper组件开始和暂停滚动。
 * 3. 使用Stack组件堆叠Swiper和TextInput。
 */

import promptAction from '@ohos.promptAction';

const LIST_SPACE: number = 0; // 列表默认间隔
const LAYOUT_WEIGHT: number = 1; // 自动分配剩余空间
const LIST_INITIAL_INDEX: number = 0;
const LIST_LENGTH: number = 5;
const MAX_LINE: number = 1;
const TEXT_OPACITY: number = 0.6;
const SWIPER_INTERVAL: number = 2000;
const SEARCH_TEXT_ID: string = 'searchText'; // 热搜词文本ID
const SEARCH_SWIPER_ID: string = 'searchSwiper'; // swiper组件ID
const SEARCH_INPUT_ID: string = 'searchInput'; // 搜索框ID

class SearchTextModel {
  id: number;
  searchText: Resource;

  constructor(id: number, searchText: Resource) {
    this.id = id;
    this.searchText = searchText;
  }
}

const FIND_SEARCH_TEXT_DATA: Array<SearchTextModel> = [
  new SearchTextModel(0, $r('app.string.search_swiper_text_data_search_text')),
  new SearchTextModel(1, $r('app.string.search_swiper_text_data_searchTex')),
  new SearchTextModel(2, $r('app.string.search_swiper_text_data_searchTe'))
]

// 列表结构对象
@Observed
export class ListConstruction {
  public id: number; // 唯一id
  public title: string; // 列表标题
  public content: string; // 列表内容

  constructor(id: number, title: string, content: string) {
    this.id = id;
    this.title = title;
    this.content = content;
  }
}

@Component
export struct SearchSwiperComponent {
  @State listData: Array<ListConstruction> = [];
  // 搜索框内容
  @State textData: string = '';
  // 当前搜索关键字
  @State swiperText: string = '';
  // swiper组件当前索引值
  @State swiperIndex: number = 0;
  // swiper组件是否自动播放
  @State isAutoPlay: boolean = true;
  controller: TextInputController = new TextInputController();

  aboutToAppear(): void {
    // 构造list数据
    for (let index = 0; index < LIST_LENGTH; index++) {
      const temDate: ListConstruction = new ListConstruction((index + 1), `新闻标题${index + 1}`, `新闻内容${index + 1}`);
      this.listData.push(temDate)
    }
  }

  build() {
    Column() {

      // 搜索框
      Row() {
        Stack() {
          // TODO: 知识点：使用Stack堆叠Swiper和TextInput组件。
          Swiper() {
            // 性能知识点：使用ForEach组件循环搜索关键字数据
            ForEach(FIND_SEARCH_TEXT_DATA, (item: SearchTextModel) => {
              Text(item.searchText)
                .opacity(TEXT_OPACITY)
                .fontColor($r('app.color.search_swiper_blank'))
                .fontSize($r('app.integer.search_swiper_size'))
                .fontFamily('HarmonyHeiTi')
                .textAlign(TextAlign.Start)
                .width($r('app.string.search_swiper_full_width'))
                .id(SEARCH_TEXT_ID)
            }, (item: SearchTextModel) => item.id.toString())
          }
          .id(SEARCH_SWIPER_ID)
          .displayMode(SwiperDisplayMode.STRETCH)
          // 根据搜索框是否有内容控制显示隐藏
          .visibility(this.textData ? Visibility.Hidden : Visibility.Visible)
          .loop(true)
          .autoPlay(this.isAutoPlay)
          .vertical(true)
          .indicator(false)
          .interval(SWIPER_INTERVAL)
          .margin($r('app.integer.search_swiper_margin'))
          .onChange((index) => {
            this.swiperIndex = index;
          })

          TextInput({ text: this.textData, controller: this.controller })
            .onChange((data) => {
              this.textData = data;
            })
            .onEditChange((isEditing) => {
              // 通过判断编辑态控制Swiper组件开始和暂停滚动
              if (!isEditing) {
                this.isAutoPlay = true
              } else {
                this.isAutoPlay = false
              }
            })
            .id(SEARCH_INPUT_ID)
            .maxLines(MAX_LINE)
            .width($r('app.string.search_swiper_full_width'))
            .height($r('app.integer.search_swiper_input_height'))
        }
        .layoutWeight(LAYOUT_WEIGHT)
        .height($r('app.integer.search_swiper_stack_height'))

        Button($r('app.string.search_swiper_button'))
          .width($r('app.integer.search_swiper_button_width'))
          .margin({ left: $r('app.integer.search_swiper_button_left') })
          .height($r('app.integer.search_swiper_input_height'))
          .fontSize($r('app.integer.search_swiper_button_size'))
          .onClick(() => {
            // 可选择在此时通过判断搜索框是否有内容来选择提交搜索框内容或当前热搜关键字。
            if (!this.textData) {
              this.swiperText = FIND_SEARCH_TEXT_DATA[this.swiperIndex].searchText.toString();
            }
            promptAction.showToast({ message: $r('app.string.search_swiper_only_show') });
          })
      }
      .padding({
        left: $r('app.integer.search_swiper_padding_left'),
        right: $r('app.integer.search_swiper_padding_right')
      })

      List({ space: LIST_SPACE, initialIndex: LIST_INITIAL_INDEX }) {
        // 性能知识点：使用ForEach组件循环列表
        ForEach(this.listData, (item: ListConstruction) => {
          ListItem() {
            this.NewsItemView(item);
          }
          .alignSelf(ItemAlign.Center)
        }, (item: ListConstruction) => JSON.stringify(item))
      }
      .padding({
        left: $r('app.integer.search_swiper_padding_left'),
        right: $r('app.integer.search_swiper_padding_right')
      })
    }
  }

  // 新闻list布局样式
  @Builder
  NewsItemView(listData: ListConstruction) {
    RelativeContainer() {
      Image($r('app.media.strawberry'))
        .objectFit(ImageFit.Contain)
        .width($r('app.string.search_swiper_image_width'))
        .height($r('app.integer.search_swiper_image_height'))
        .backgroundColor($r('app.color.search_swiper_background'))
        .borderRadius($r('app.integer.search_swiper_image_radius'))
        .id('image')
        .alignRules({
          'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
          'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
        })

      Text(listData.title)
        .fontSize($r('app.integer.search_swiper_title_size'))
        .fontColor(Color.Black)
        .id('videoName')
        .margin({ left: $r('app.integer.search_swiper_title_left') })
        .alignRules({
          'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
          'left': { 'anchor': 'image', 'align': HorizontalAlign.End }
        })

      Text(listData.content)
        .fontSize($r('app.integer.search_swiper_content_size'))
        .fontColor(Color.Gray)
        .id('authorName')
        .margin({
          left: $r('app.integer.search_swiper_content_left'),
          top: $r('app.integer.search_swiper_content_top')
        })
        .alignRules({
          'top': { 'anchor': 'videoName', 'align': VerticalAlign.Bottom },
          'left': { 'anchor': 'image', 'align': HorizontalAlign.End }
        })
    }
    .width($r('app.string.search_swiper_full_width'))
    .height($r('app.integer.search_swiper_relative_height'))
  }
}
