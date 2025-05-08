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
import { IconAndDescription, Size } from '../model/Util';

const Y_OFFSET130 = 130;
const Y_OFFSET_TOP = 70;
const Y_OFFSET60 = 60;
const Y_OFFSET50 = 50;
const Y_OFFSET40 = 40;
const Y_OFFSET20 = 20;
const FULL_SIZE = 100;
const RACE = 1.5;
const BORDER_RADIUS = 8;
const CARD_WIDTH = 150;
const CARD_HEIGHT = 200;
const SETTING_WIDTH = 24;
const HIT_TEST_BLOCK_THRESHOLD = 0.2;

/**
 * 滑动页面改变顶部个人信息栏显示效果
 * 效果：上滑页面，用户头像逐渐缩小并移动到返回文字的后方，原本展示的用户名/选择身份/设置/客服的文本和图标渐隐，顶部用户名文本渐显
 * 下滑页面，用户头像逐渐放大并向下移动，顶部用户名文本渐隐，下方用户名/选择身份/设置/客服的文本和图标渐显
 */

@Component
export struct SlideToHideAndDisplaceComponent {
  // 用户头像图片后方个人信息相关组件(用户名/选择身份/满意度调查)的透明度
  @State userRowOpacity: number = 1;
  // 返回文字后方的用户名的透明度(进入页面时处于隐藏状态)
  @State userNameOpacity: number = 0;
  // 用户头像图片高度
  @State userImageHeight: number = 50;
  // Scroll组件顶部与上方Row组件(个人信息栏)的上边距
  @State scrollMarginTop: number = 0;
  // 用户头像图片顶部与父组件Row的上边距
  @State userImageMarginTop: number = 0;
  // 用户头像图片左侧与父组件Row的左边距
  @State userImageMarginLeft: number = 0;
  // 订单相关的图标和描述的数据列表
  ordersInfo: IconAndDescription[] = [
    new IconAndDescription($r("app.media.slidetohideanddisplace_payment"),
      $r('app.string.slidetohideanddisplace_payment')),
    new IconAndDescription($r("app.media.slidetohideanddisplace_receiving"),
      $r('app.string.slidetohideanddisplace_receiving')),
    new IconAndDescription($r("app.media.slidetohideanddisplace_comments"),
      $r('app.string.slidetohideanddisplace_comments')),
    new IconAndDescription($r("app.media.slidetohideanddisplace_more"),
      $r('app.string.slidetohideanddisplace_more'))
  ]
  // 粉丝/收藏/关注/历史相关的栏目的图标和描述的数据列表
  interactionInfo: IconAndDescription[] = [
    new IconAndDescription($r("app.media.slidetohideanddisplace_fans"),
      $r('app.string.slidetohideanddisplace_fans')),
    new IconAndDescription($r("app.media.slidetohideanddisplace_favorites"),
      $r('app.string.slidetohideanddisplace_favorites')),
    new IconAndDescription($r("app.media.slidetohideanddisplace_follow"),
      $r('app.string.slidetohideanddisplace_follow')),
    new IconAndDescription($r("app.media.slidetohideanddisplace_history"),
      $r('app.string.slidetohideanddisplace_history'))
  ]
  // 商品会场的图标和描述的数据列表
  merchandiseVenue: IconAndDescription[] = [
    new IconAndDescription($r("app.media.slidetohideanddisplace_arc_of_light"),
      $r('app.string.slidetohideanddisplace_focus_on_hot_topics')),
    new IconAndDescription($r("app.media.slidetohideanddisplace_arc_of_light"),
      $r('app.string.slidetohideanddisplace_recommended_by_friends')),
    new IconAndDescription($r("app.media.slidetohideanddisplace_arc_of_light"),
      $r('app.string.slidetohideanddisplace_news_directly_arrived')),
    new IconAndDescription($r("app.media.slidetohideanddisplace_arc_of_light"),
      $r('app.string.slidetohideanddisplace_photography_sharing')),
  ]
  // 可滑动容器组件的控制器
  scroller: Scroller = new Scroller();
  // 处理onclick事件的方法
  handleClick: (() => void) | undefined = undefined;

  // 自定义构建函数，将重复使用的UI元素抽象成一个方法。此处样式为：上方图标下方文字
  @Builder
  iconAndDescription(icon: Resource, description: string | Resource, iconSize?: Size, radius?: number,
    handleClick?: () => void) {
    Column() {
      Image(icon)
        .size(iconSize === undefined ? {
          height: $r('app.integer.slidetohideanddisplace_icon_default_height'),
          width: $r('app.integer.slidetohideanddisplace_icon_default_height')
        } : iconSize)
        .borderRadius(radius)
      Text(description)
        .margin({ top: $r('app.integer.slidetohideanddisplace_margin_between_icon_and_description') })
    }
    .onClick(() => {
      // 修改的主要目的是为了让开发者方便找到业务代码，然后修改成自己的业务
      if (handleClick) {
        promptAction.showToast({ message: description });
      }
    })
  }

  // 订单与互动栏的通用样式
  @Styles
  rowStyles() {
    .width($r('app.string.slidetohideanddisplace_size_full'))
    .padding($r('app.integer.slidetohideanddisplace_padding_small'))
    .margin({ top: $r('app.integer.slidetohideanddisplace_margin_small') })
    .backgroundColor($r('app.color.slidetohideanddisplace_color_transparent_aa'))
    .borderRadius($r('app.integer.slidetohideanddisplace_border_radius'))
  }

  // 自定义构建函数。此处样式为在Row组件中横向排列订单相关的标签：待支付，待收货，待评价，更多
  @Builder
  orders() {
    Row() {
      // 性能知识点：此处在Row中横向排列组件，列表项确定、数量较少，且需要一次性加载，因此使用ForEach。在列表项多的情况下，推荐使用LazyForEach
      ForEach(this.ordersInfo, (item: IconAndDescription) => {
        Column() {
          this.iconAndDescription(item.icon, item.description, undefined, 0, () => {
          })
        }
        .width($r("app.string.slidetohideanddisplace_width_of_elements_in_orders"))
      })
    }
    .rowStyles()
    .justifyContent(FlexAlign.SpaceAround)
  }

  // 自定义构建函数。此处样式为在Row组件中横向排列互动相关的标签：粉丝，收藏，关注，历史
  @Builder
  interaction() {
    Row() {
      ForEach(this.interactionInfo, (item: IconAndDescription) => {
        Column() {
          this.iconAndDescription(item.icon, item.description, undefined, 0, () => {
          })
        }
        .width($r("app.string.slidetohideanddisplace_width_of_elements_in_interaction"))
      })
    }
    .rowStyles()
  }

  // 会员和权益中心栏目
  @Builder
  memberBanner() {
    Row() {
      Column() {
        Text($r('app.string.slidetohideanddisplace_member'))
          .fontSize($r('app.integer.slidetohideanddisplace_font_size_mid'))
          .fontColor($r('app.color.slidetohideanddisplace_member1'))
        Text($r('app.string.slidetohideanddisplace_get_off_your_purchases'))
          .margin({ top: $r('app.integer.slidetohideanddisplace_margin_between_icon_and_description') })
          .fontColor($r('app.color.slidetohideanddisplace_member2'))
      }
      .alignItems(HorizontalAlign.Start)
      .padding($r('app.integer.slidetohideanddisplace_padding_small'))

      Blank() // 在容器主轴方向上自动填充容器空余部分

      Column() {
        Image($r("app.media.slidetohideanddisplace_crown"))
          .size({
            width: $r('app.integer.slidetohideanddisplace_icon_default_height'),
            height: $r('app.integer.slidetohideanddisplace_icon_default_height')
          })
        Text($r('app.string.slidetohideanddisplace_center_of_right'))
          .margin({ top: $r('app.integer.slidetohideanddisplace_margin_between_icon_and_description') })
          .fontColor($r('app.color.slidetohideanddisplace_member3'))
      }
      .padding($r('app.integer.slidetohideanddisplace_padding_small'))
    }
    .height($r('app.integer.slidetohideanddisplace_height_eighty'))
    .width($r('app.string.slidetohideanddisplace_size_full'))
    .borderRadius($r('app.integer.slidetohideanddisplace_border_radius'))
    .linearGradient({
      angle: 45, // 设置颜色渐变起始角度为顺时针方向45°
      colors: [[0x30fa908a, 0.0], [0x44aaaaa, 0.5], [0x30c2b1fa, 1.0]]
    })
    .onClick(() => {
      promptAction.showToast({ message: $r('app.string.slidetohideanddisplace_member_services') });
    })
  }

  @Builder
  shoppingVenue() {
    Column() {
      Text($r("app.string.slidetohideanddisplace_guess_your_like"))
        .fontSize($r('app.integer.slidetohideanddisplace_margin_mid'))
        .fontColor($r('app.color.slidetohideanddisplace_shopping'))
        .width($r('app.string.slidetohideanddisplace_size_full'))
        .margin({
          left: $r('app.integer.slidetohideanddisplace_margin_small'),
          top: $r('app.integer.slidetohideanddisplace_margin_small')
        })

      Grid() {
        ForEach(this.merchandiseVenue, (item: IconAndDescription) => {
          GridItem() {
            // 调用自定义构建函数，传入图标/描述/图标尺寸/图片圆角半径
            this.iconAndDescription(item.icon, item.description, new Size(CARD_HEIGHT, CARD_WIDTH),
              BORDER_RADIUS, () => {
              })
          }
        })
      }
      .columnsTemplate('1fr 1fr') // 将父组件均分为2列
      .rowsGap($r('app.integer.slidetohideanddisplace_margin_small'))
      .width($r('app.string.slidetohideanddisplace_size_full'))
      .height($r('app.integer.slidetohideanddisplace_grid_height'))
      .margin({ top: $r('app.integer.slidetohideanddisplace_margin_small') })
    }
    .backgroundColor($r('app.color.slidetohideanddisplace_color_transparent_55'))
    .margin({
      top: $r('app.integer.slidetohideanddisplace_margin_small'),
      bottom: $r('app.integer.slidetohideanddisplace_margin_small')
    })
    .borderRadius($r('app.integer.slidetohideanddisplace_border_radius'))
  }

  /**
   * 创建一个Row组件，用来显示用户信息，然后在下面创建一个Scroll组件，用来显示其他内容，
   * 当Scroll滑动时，Row组件隐藏且里面的子组件渐隐
   */
  build() {
    Column() {
      Row() {
        Text($r('app.string.slidetohideanddisplace_vip'))
          .onClick(() => {
            promptAction.showToast({ message: $r('app.string.slidetohideanddisplace_vip') });
          })
          .fontWeight(FontWeight.Bolder)
          .fontSize($r('app.integer.slidetohideanddisplace_vip_font_size'))
          .fontColor($r('app.color.slidetohideanddisplace_member2'))
        Text($r("app.string.slidetohideanddisplace_user_name"))
          .margin({ left: $r('app.integer.slidetohideanddisplace_margin_large') })
          .opacity(this.userNameOpacity) // userNameOpacity控制顶部用户名的透明度
        Blank()
        Text($r('app.string.slidetohideanddisplace_settings'))
          .opacity(this.userNameOpacity)// 设置的文字透明度与顶部用户名相同
          .onClick(() => {
            // 当组件的不透明度大于阈值时，响应点击事件，显示文本提示框
            if (this.userNameOpacity > HIT_TEST_BLOCK_THRESHOLD) {
              promptAction.showToast({ message: $r('app.string.slidetohideanddisplace_settings') });
            }
          })
        Text($r('app.string.slidetohideanddisplace_customer_service'))
          .margin({
            left: $r('app.integer.slidetohideanddisplace_margin_small'),
            right: $r('app.integer.slidetohideanddisplace_margin_small')
          })
          .opacity(this.userNameOpacity)// 客服的文字透明度与顶部用户名相同
          .onClick(() => {
            // 当组件的不透明度大于阈值时，响应点击事件，显示文本提示框
            if (this.userNameOpacity > HIT_TEST_BLOCK_THRESHOLD) {
              promptAction.showToast({ message: $r('app.string.slidetohideanddisplace_customer_service') });
            }
          })
      }
      .width($r('app.string.slidetohideanddisplace_size_full'))
      .alignItems(VerticalAlign.Center)

      Row() {
        Image($r("app.media.slidetohideanddisplace_batman"))
          .width(this.userImageHeight)
          .height(this.userImageHeight)// userImageHeight控制头像尺寸
            // userImageMarginTop和userImageMarginLeft控制头像在父容器内的位置
          .margin({ top: this.userImageMarginTop, left: this.userImageMarginLeft })
          .id('slidetohanddisplace_batman_id')

        Column() {
          Text($r("app.string.slidetohideanddisplace_user_name"))
          Button($r('app.string.slidetohideanddisplace_choose_identity'))
            .height($r('app.integer.slidetohideanddisplace_button_height'))
            .width($r('app.integer.slidetohideanddisplace_button_width'))
            .fontColor(Color.White)
            .margin({ top: $r('app.integer.slidetohideanddisplace_margin_between_icon_and_description') })
            .onClick(() => {
              promptAction.showToast({ message: $r('app.string.slidetohideanddisplace_choose_identity') });
            })
        }
        .alignItems(HorizontalAlign.Start)
        .opacity(this.userRowOpacity) // 控制Row组件的透明度
        .padding($r('app.integer.slidetohideanddisplace_padding_small'))

        Blank() // 在容器主轴方向上自动填充容器空余部分

        Row() {
          this.iconAndDescription($r("app.media.slidetohideanddisplace_setting"),
            $r('app.string.slidetohideanddisplace_settings'), new Size(SETTING_WIDTH, SETTING_WIDTH), 0, () => {
            })

          this.iconAndDescription($r("app.media.slidetohideanddisplace_dialog"),
            $r('app.string.slidetohideanddisplace_customer_service'), new Size(SETTING_WIDTH, SETTING_WIDTH), 0,
            () => {
            })
        }
        .width($r('app.integer.slidetohideanddisplace_height_eighty'))
        .justifyContent(FlexAlign.SpaceBetween)
        .opacity(this.userRowOpacity)
      }
      .height($r('app.integer.slidetohideanddisplace_height_one_hundred'))
      .width($r('app.string.slidetohideanddisplace_size_full'))
      // 当组件的不透明度小于阈值时，阻塞子节点和兄弟节点的触摸测试
      .hitTestBehavior(this.userRowOpacity < HIT_TEST_BLOCK_THRESHOLD ? HitTestMode.Block : HitTestMode.Default)

      // Scroll组件中显示个人信息以外的内容
      Scroll(this.scroller) {
        Column() {
          // 会员和权益中心栏目
          this.memberBanner()
          // 订单信息栏目
          this.orders()
          // 粉丝/收藏/关注/历史栏目
          this.interaction()
          // 橘子购物街会场
          this.shoppingVenue()

          Text($r('app.string.slidetohideanddisplace_in_the_end'))
            .fontColor(Color.Grey)
        }
        .width($r('app.string.slidetohideanddisplace_size_full'))
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .layoutWeight(1)
      .margin({ top: this.scrollMarginTop })
      .scrollBar(BarState.Off)
      .onDidScroll(() => {
        // TODO: 知识点: Scroll组件绑定onDidScroll事件，然后在此方法里改变该组件的margin和opacity属性值的大小实现组件移动和隐显
        // 性能知识点: onScroll属于频繁回调，不建议在onScroll做耗时和冗余操作
        const yOffset: number = this.scroller.currentOffset().yOffset;
        this.userRowOpacity = yOffset < Y_OFFSET60 ? 1 - yOffset / Y_OFFSET60 : 0;
        if (yOffset < Y_OFFSET_TOP) {
          this.scrollMarginTop = -yOffset;
          this.userImageHeight = Y_OFFSET50 * (1 - (yOffset / Y_OFFSET130));
          this.userImageMarginTop = -yOffset * RACE;
          this.userImageMarginLeft = Y_OFFSET20 * (yOffset / Y_OFFSET60) * RACE;
          if (yOffset > Y_OFFSET40) {
            this.userNameOpacity = (yOffset - Y_OFFSET40) / Y_OFFSET40;
          } else {
            this.userNameOpacity = 0;
          }
        } else {
          this.userImageHeight = Y_OFFSET50 * (1 - (Y_OFFSET_TOP / Y_OFFSET130));
          this.userImageMarginTop = -Y_OFFSET_TOP * RACE;
          this.userImageMarginLeft = Y_OFFSET20 * (Y_OFFSET_TOP / Y_OFFSET60) * RACE;
          this.userNameOpacity = 1;
        }
      })
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .width($r('app.string.slidetohideanddisplace_size_full'))
    .padding({
      top: $r('app.integer.slidetohideanddisplace_margin_default'),
      left: $r('app.integer.slidetohideanddisplace_margin_default'),
      right: $r('app.integer.slidetohideanddisplace_margin_default')
    })
    .backgroundColor('#F1F3F5')
  }
}
