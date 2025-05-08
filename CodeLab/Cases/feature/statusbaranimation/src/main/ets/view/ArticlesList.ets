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

import { promptAction } from '@kit.ArkUI';
import { Constants } from '../contants/Constants';
import LazyDataSource from '../model/LazyDataSource';
import { Model } from '../model/Model';
import { CardType } from '../contants/Enums';

@Component
export struct ArticlesList {
  @Link listData: LazyDataSource<Model>;
  @State selectedId: number = -1; // 刚加载完成无选中状态
  @Link @Watch('scrollToTop') isTop: boolean; // 是否通过按钮点击回到顶部
  @StorageLink('bottomHeight') bottomHeight: number = 0; // 底部导航栏高度
  private listScroller = new ListScroller(); // list滚动控制器

  scrollToTop() {
    if (this.isTop) {
      // 点击回顶部按钮列表回滚到顶部
      this.listScroller.scrollTo({
        xOffset: Constants.MAIN_SCROLLER_OFFSET_X,
        yOffset: Constants.MAIN_SCROLLER_OFFSET_Y,
        animation: {
          duration: Constants.ANIMATION_DURATION1,
          curve: Curve.FastOutLinearIn
        }
      });
      this.isTop = false;
    }
  }

  build() {
    Column() {
      List({ space: Constants.ARTICLES_LIST_SPACE, scroller: this.listScroller }) {
        LazyForEach(this.listData, (item: Model) => {
          ListItem() {
            ItemView({ item: item, isSelected: this.selectedId === item.id });
          }
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.status_bar_animation_prompt_text')
            });
          })
        }, (item: Model) => item.id.toString())
      }
      // 隐藏滚动条
      .scrollBar(BarState.Off)
      .cachedCount(Constants.CACHE_COUNT)
      .backgroundColor($r('app.color.status_bar_animation_articles_list_background_color'))
      .padding({
        left: $r('app.integer.status_bar_animation_articles_list_padding_left'),
        right: $r('app.integer.status_bar_animation_articles_list_padding_right'),
        bottom: this.bottomHeight + 'px'
      })
      .width(Constants.FULL_PERCENT)
      .height(Constants.FULL_PERCENT)
      .nestedScroll({
        scrollForward: NestedScrollMode.PARENT_FIRST,
        scrollBackward: NestedScrollMode.SELF_FIRST
      })
    }
  }
}

@Component
struct ItemView {
  @Prop item: Model;
  @Prop isSelected: boolean = false;

  @Builder
  viewsBuilder() {
    Row() {
      Image($r("app.media.status_bar_animation_eye_open"))
        .fillColor($r('sys.color.ohos_id_color_text_secondary'))
        .width($r("app.integer.status_bar_animation_eye_iamge_width"))
        .aspectRatio(Constants.ASPECT_RATIO_ONE)
        .margin({
          right: $r("app.integer.status_bar_animation_eye_iamge_margin_right")
        })
      Text(`${this.item.views}`)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontSize($r("app.integer.status_bar_animation_eye_text_font"))
        .width($r("app.integer.status_bar_animation_eye_iamge_width"))
        .opacity(Constants.SECOND_LEVEL_OPACITY)
    }
  }

  @Builder
  likesBuilder() {
    Row() {
      Image(this.item.isLike ? $r("app.media.status_bar_animation_good_on") :
            $r("app.media.status_bar_animation_good_off"))
        .fillColor($r('sys.color.ohos_id_color_text_secondary'))
        .width($r("app.integer.status_bar_animation_good_iamge_width"))
        .aspectRatio(Constants.ASPECT_RATIO_ONE)
        .margin({
          right: $r("app.integer.status_bar_animation_good_iamge_margin_right")
        })
      Text(`${this.item.likes}`)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontSize($r("app.integer.status_bar_animation_good_text_font"))
        .width($r("app.integer.status_bar_animation_good_width"))
        .opacity(Constants.SECOND_LEVEL_OPACITY)
    }
  }

  @Builder
  collectBuilder() {
    Row() {
      Image(this.item.isCollection ? $r("app.media.status_bar_animation_collect_on") :
            $r("app.media.status_bar_animation_collect_off"))
        .fillColor($r('sys.color.ohos_id_color_text_secondary'))
        .width($r("app.integer.status_bar_animation_collect_iamge_width"))
        .aspectRatio(Constants.ASPECT_RATIO_ONE)
        .margin({
          right: $r("app.integer.status_bar_animation_collect_iamge_margin_right")
        })
      Text(`${this.item.collections}`)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontSize($r("app.integer.status_bar_animation_collect_text_font"))
        .width($r("app.integer.status_bar_animation_collect_width"))
        .opacity(Constants.SECOND_LEVEL_OPACITY)
    }
  }

  @Builder
  typeBuilder() {
    Text($r('app.string.status_bar_animation_photography_works'))
      .fontSize($r('app.integer.status_bar_animation_photography_works_font_size'))
      .fontColor($r('app.color.status_bar_animation_photography_works_font_color'))
      .textAlign(TextAlign.Center)
      .fontWeight(FontWeight.Medium)
      .fontFamily(Constants.HARMONY_HEI_TI_MEDIUM_FONT_FAMILY)
      .borderRadius(Constants.TYPE_BORDER_RADIUS)
      .backgroundColor($r('app.color.status_bar_animation_photography_works_background_color'))
      .padding({
        left: $r('app.integer.status_bar_animation_photography_works_padding_left'),
        right: $r('app.integer.status_bar_animation_photography_works_padding_right'),
        top: $r('app.integer.status_bar_animation_photography_works_padding_top'),
        bottom: $r('app.integer.status_bar_animation_photography_works_padding_bottom')
      })
  }

  @Builder
  tagBuilder() {
    Text($r('app.string.status_bar_animation_natural_scenery'))
      .fontSize($r('app.integer.status_bar_animation_natural_scenery_font_size'))
      .fontColor($r('app.color.status_bar_animation_natural_scenery_font_color'))
      .textAlign(TextAlign.Center)
      .fontWeight(FontWeight.Medium)
      .fontFamily(Constants.HARMONY_HEI_TI_MEDIUM_FONT_FAMILY)
      .borderRadius(Constants.TYPE_BORDER_RADIUS)
      .backgroundColor($r('app.color.status_bar_animation_natural_scenery_background_color'))
      .padding({
        left: $r('app.integer.status_bar_animation_natural_scenery_padding_left'),
        right: $r('app.integer.status_bar_animation_natural_scenery_padding_right'),
        top: $r('app.integer.status_bar_animation_natural_scenery_padding_top'),
        bottom: $r('app.integer.status_bar_animation_natural_scenery_padding_bottom')
      })
  }

  build() {
    // TODO: 知识点：相对布局组件，用于复杂场景中元素对齐的布局，容器内子组件区分水平方向，垂直方向子组件可以将容器或者其他子组件设为锚点。
    RelativeContainer() {
      Row() {
        Column() {
          // 标题
          Text(this.item.title)
            .fontSize($r('app.integer.status_bar_animation_item_title_font_size'))
            .fontFamily(Constants.HARMONY_HEI_TI_FONT_FAMILY)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .opacity(Constants.FIRST_LEVEL_OPACITY)
            .width(Constants.FULL_PERCENT)
            .maxLines(Constants.MAX_LINES_ONE)
            .alignRules({
              top: { anchor: "__container__", align: VerticalAlign.Top },
              left: { anchor: "__container__", align: HorizontalAlign.Start }
            })
            .id("title")
          // 内容
          Text(this.item.content)
            .fontSize($r('app.integer.status_bar_animation_item_content_font_size'))
            .fontFamily(Constants.HARMONY_HEI_TI_FONT_FAMILY)
            .opacity(Constants.SECOND_LEVEL_OPACITY)
            .maxLines(Constants.MAX_LINES_TWO)
            .width(Constants.FULL_PERCENT)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Start)
            .alignRules({
              left: { anchor: "title", align: HorizontalAlign.Start },
              top: { anchor: "title", align: VerticalAlign.Bottom }
            })
            .margin({
              top: $r('app.integer.status_bar_animation_item_content_margin_top')
            })
            .id("content")


          if (this.item.type === CardType.OTHER) {
            Row() {
              // 浏览量
              this.viewsBuilder();
              // 点赞数
              this.likesBuilder();
              // 收藏量
              this.collectBuilder();
            }
            .width(Constants.FULL_PERCENT)
            .height($r('app.integer.status_bar_animation_item_function_height'))
            .alignRules({
              left: { anchor: "content", align: HorizontalAlign.Start },
              top: { anchor: "content", align: VerticalAlign.Bottom }
            })
            .justifyContent(FlexAlign.SpaceBetween)
          } else {
            Row({ space: Constants.ARTICLES_LABEL_SPACE }) {
              // 摄影作品标签
              this.typeBuilder();
              // 自然风光标签
              this.tagBuilder();
            }
            .width(Constants.FULL_PERCENT)
            .height($r('app.integer.status_bar_animation_item_label_height'))
            .padding({
              left: $r('app.integer.status_bar_animation_item_label_margin_left'),
              right: $r('app.integer.status_bar_animation_item_label_margin_right')
            })
            .alignRules({
              left: { anchor: "content", align: HorizontalAlign.Start },
              top: { anchor: "content", align: VerticalAlign.Bottom }
            })
            .justifyContent(FlexAlign.Start)
          }
        }
        .padding($r('app.integer.status_bar_animation_function_padding'))
        .height(Constants.FULL_PERCENT)
        .layoutWeight(Constants.LAYOUT_WEIGHT)

        // 图片
        Image(this.item.uri)
          .height($r('app.integer.status_bar_animation_item_image_width'))
          .backgroundColor($r("app.color.status_bar_animation_background_white"))
          .aspectRatio(Constants.ASPECT_RATIO_SECOND)
          .objectFit(ImageFit.Cover)
          .borderRadius(Constants.ITEM_IMAGE_BORDER_RADIUS)
          .alignRules({
            center: { anchor: "__container__", align: VerticalAlign.Center },
            right: { anchor: "__container__", align: HorizontalAlign.End }
          })
          .margin({
            right: $r('app.integer.status_bar_animation_item_image_margin_right')
          })
          .id("image")
      }
    }
    .backgroundColor(Color.White)
    .borderRadius(Constants.ITEM_BORDER_RADIUS)
    .width(Constants.FULL_PERCENT)
    .height($r('app.integer.status_bar_animation_item_height'))
    // item选中时的背景渐变色
    .linearGradient(this.isSelected ? {
      angle: Constants.ITEM_LINEAR_GRADIENT_ANGLE,
      colors: [[Constants.ITEM_LINEAR_GRADIENT_START_COLOR, Constants.ITEM_LINEAR_GRADIENT_START],
        [Constants.ITEM_LINEAR_GRADIENT_END_COLOR, Constants.ITEM_LINEAR_GRADIENT_END]]
    } : { colors: [] })
  }
}
