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

import { AppRouter, DynamicsRouter, Interceptor, InterceptorExecute } from 'routermodule';
import { IconList, IconList2, IconList3, IconListType, IconListsType, IconType } from '../model/DataModel';
import promptAction from '@ohos.promptAction';

const SPACE_DISTANCE = 12; // 子元素的间距

/**
 * Navigation路由拦截：
 * 如何封装：
 * 1、在路由模块增加路由拦截器interceptor.ets，定义拦截容器、注册方法和公共拦截逻辑。
 * 2、当点击本案例时，触发在路由模块的动态路由.push()中的interceptor的公共拦截方法（此处需动态路由完成加载后执行否则首次路由拦截失败）。
 * 3、子模块中定义业务具体拦截逻辑，做具体的拦截实现：通过routerInfo判断目的地为"我的页面"时判断登录状态是"未登录"，此时执行跳转到登录页并返回true给拦截容器list（告知需拦截），已登录返回false，放行。并且注册到拦截器容器list中
 * 4、拦截器获取拦截容器list中所有注册过的子模块的拦截函数，如果子模块拦截函数返回true，即需要拦截，否则放行。
 * 5、通过循环拦截容器list得到返回true时通知动态路由不再继续跳转, 否则返回false，通知动态路由继续执行跳转，跳转到我的页面。
 * 6、在登录页点击：手机号码一键登录后，登陆成功，登陆状态置为true，且跳转到主页。
 * 7、详情页中点击：注销登录，登录状态置为false，退出登录。
 * Navigation参考文档:https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/arkts-navigation-navigation-0000001453365116-V2
 */

@AppRouter({ name: "navigationinterceptor/InterceptorPage" })
@Component
export struct InterceptorPage {
  @StorageLink('login') hasLogin: boolean = true; // 记录登陆状态，true：已登录过。
  scorller: Scroller = new Scroller();
  private cateName: ResourceStr = $r('app.string.naviagtion_interceptor_more_service'); // 标题

  @Builder
  AppCate() {
    GridRow({ columns: { sm: 8, md: 8, lg: 8 } }) {
      ForEach(IconList, (item: IconType, index) => {
        GridCol({ span: { sm: 2, md: 2, lg: 2 } }) {
          Column() {
            Image(item.icon)
              .width($r('app.integer.naviagtion_interceptor_cate_img_width'))
              .height($r('app.integer.naviagtion_interceptor_cate_img_width'))

            Text(item.name)
              .fontSize($r('app.integer.naviagtion_interceptor_cate_text_font_size'))
              .margin({ top: $r('app.integer.naviagtion_interceptor_cate_text_margin_top') })
          }
        }
        .margin({
          top: $r('app.integer.naviagtion_interceptor_cate_margin_top'),
          bottom: $r('app.integer.naviagtion_interceptor_cate_margin_top')
        })
        .onClick(() => {
          // 点击后显示提示文本框
          promptAction.showToast({
            message: $r('app.string.naviagtion_interceptor_prompt_text')
          });
        })
      })
    }.padding($r('app.integer.naviagtion_interceptor_cate_padding'))
  }

  // 更多服务的组件
  @Builder
  AppCate2() {
    Column() {
      Text(this.cateName)
        .fontSize(16)
        .width('100%')
        .fontWeight(FontWeight.Bold)
        .margin({ left: 5 })
      GridRow({ columns: { sm: 8, md: 8, lg: 8 } }) {
        /* 性能知识点：当数据量较大时，推荐使用懒加载加载数据。
         * 参考使用数据懒加载文章：
         * https://gitee.com/harmonyos-cases/cases/blob/master/docs/performance/arkts-performance-improvement-recommendation.md
         */
        ForEach(IconList2, (item: IconListType, index) => {
          GridCol({ span: { sm: 2, md: 2, lg: 2 } }) {
            Column() {
              Image(item.icon)
                .width($r('app.integer.naviagtion_interceptor_cate_img_width'))
                .height($r('app.integer.naviagtion_interceptor_cate_img_width'))

              Text(item.name)
                .fontSize($r('app.integer.naviagtion_interceptor_cate_text_font_size'))
                .margin({ top: $r('app.integer.naviagtion_interceptor_cate_text_margin_top') })
            }
          }
          .margin({
            top: $r('app.integer.naviagtion_interceptor_cate_margin_top'),
            bottom: $r('app.integer.naviagtion_interceptor_cate_margin_top')
          })
          .onClick(() => {
            // 点击后显示提示文本框
            promptAction.showToast({
              message: $r('app.string.naviagtion_interceptor_prompt_text')
            });
          })
        })
      }
    }.padding($r('app.integer.naviagtion_interceptor_cate_padding'))
  }

  // 基础数据的组件
  @Builder
  AppCate3() {
    GridRow({ columns: { sm: 8, md: 8, lg: 8 } }) {
      /* 性能知识点：当数据量较大时，推荐使用懒加载加载数据。
       * 参考使用数据懒加载文章：
       * https://gitee.com/harmonyos-cases/cases/blob/master/docs/performance/arkts-performance-improvement-recommendation.md
       */
      ForEach(IconList3, (item: IconListsType, index) => {
        GridCol({ span: { sm: 2, md: 2, lg: 2 } }) {
          Column() {
            Text(item.num)
              .width($r('app.integer.naviagtion_interceptor_cate_img_width'))
              .height($r('app.integer.naviagtion_interceptor_cate_img_width'))
              .margin({ left: $r('app.integer.naviagtion_interceptor_cate_margin_left') })

            Text(item.name)
              .fontSize($r('app.integer.naviagtion_interceptor_cate_text_font_size'))
              .margin({ top: $r('app.integer.naviagtion_interceptor_cate_text_margin_top') })
          }
        }
        .margin({
          top: $r('app.integer.naviagtion_interceptor_cate_margin_top'),
          bottom: $r('app.integer.naviagtion_interceptor_cate_margin_top')
        })
        .onClick(() => {
          // 点击后显示提示文本框
          promptAction.showToast({
            message: $r('app.string.naviagtion_interceptor_prompt_text')
          });
        })
      })
    }.padding($r('app.integer.naviagtion_interceptor_cate_padding'))
  }

  build() {
    Column() {
      Image($r("app.media.naviagtion_interceptor_head_image"))
        .width($r('app.integer.naviagtion_interceptor_setting_head_image_width'))
        .height($r('app.integer.naviagtion_interceptor_setting_head_image_width'))
        .borderRadius($r('app.integer.naviagtion_interceptor_setting_my_icon_border_radius'))
        .position({
          x: $r('app.integer.naviagtion_interceptor_head_image_position_x'),
          y: $r('app.integer.naviagtion_interceptor_head_image_position_y')
        })
        .onClick(() => {
          // 点击后显示提示文本框
          promptAction.showToast({
            message: $r('app.string.naviagtion_interceptor_prompt_text')
          });
        })
      Text($r('app.string.naviagtion_interceptor_myself'))
        .fontSize($r('app.integer.naviagtion_interceptor_setting_name_font_size'))
        .fontColor(Color.Black)
        .fontFamily($r('app.string.naviagtion_interceptor_harmony_hei_ti'))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)
        .lineHeight($r('app.integer.naviagtion_interceptor_setting_name_line_height'))
        .position({
          x: $r('app.integer.naviagtion_interceptor_myself_position_x'),
          y: $r('app.integer.naviagtion_interceptor_myself_position_y')
        })
        .margin({ left: $r('app.integer.naviagtion_interceptor_myself_margin_left') })
        .onClick(() => {
          // 点击后显示提示文本框
          promptAction.showToast({
            message: $r('app.string.naviagtion_interceptor_prompt_text')
          });
        })
        .id('homePage')

      Text($r('app.string.naviagtion_interceptor_self_page'))
        .fontSize($r('app.integer.naviagtion_interceptor_self_page_font_size'))
        .fontColor($r('app.color.naviagtion_interceptor_setting_text_color'))
        .fontFamily($r('app.string.naviagtion_interceptor_harmony_hei_ti'))
        .fontWeight(FontWeight.Medium)
        .lineHeight($r('app.integer.naviagtion_interceptor_setting_name_line_height'))
        .position({
          x: $r('app.string.naviagtion_interceptor_text_position_x'),
          y: $r('app.integer.naviagtion_interceptor_text_position_y')
        })
        .margin({ left: $r('app.integer.naviagtion_interceptor_self_page_margin_left') })
        .onClick(() => {
          // 点击后显示提示文本框
          promptAction.showToast({
            message: $r('app.string.naviagtion_interceptor_prompt_text')
          });
        })

      List({ scroller: this.scorller }) {
        ListItem() {
          this.AppCate3(); // 渲染基础数据组件
        }
        .borderRadius(10)
        .margin({ top: $r('app.integer.naviagtion_interceptor_appcast3_margin_top') })

        ListItem() {
          this.AppCate(); // 渲染基础服务组件
        }
        .backgroundColor($r('app.color.naviagtion_interceptor_burble_bgc_color'))
        .borderRadius(10)
        .margin({ bottom: $r('app.integer.naviagtion_interceptor_appcast_margin_bottom') })

        ListItem() {
          GridRow({ columns: { sm: 4, md: 8, lg: 12 } }) {
            GridCol({ span: { sm: 2, md: 4, lg: 8 }, order: { sm: 1, md: 1, lg: 1 } }) {
              Row({ space: SPACE_DISTANCE }) {
                Text($r('app.string.naviagtion_interceptor_new_thing'))
                  .width($r('app.integer.naviagtion_interceptor_text_width'))
                  .fontSize($r('app.integer.naviagtion_interceptor_text_font_size'))
                  .margin({ top: $r('app.integer.naviagtion_interceptor_text_margin_top') })
                  .onClick(() => {
                    // 点击后显示提示文本框
                    promptAction.showToast({
                      message: $r('app.string.naviagtion_interceptor_prompt_text')
                    });
                  })
              }
              .justifyContent(FlexAlign.Start)
              .padding($r('app.integer.naviagtion_interceptor_row_padding'))
              .width($r('app.string.naviagtion_interceptor_row_width'))
            }

            GridCol({ span: { sm: 2, md: 1, lg: 4 }, order: { sm: 2, md: 2, lg: 3 } }) {
              Row({ space: SPACE_DISTANCE }) {
                Button($r('app.string.naviagtion_interceptor_send'), { type: ButtonType.Capsule })
                  .fontSize($r('app.integer.naviagtion_interceptor_btn_font_size'))
                  .fontColor(Color.Red)
                  .width($r('app.integer.naviagtion_interceptor_btn_width'))
                  .height($r('app.integer.naviagtion_interceptor_btn_height'))
                  .border({ width: $r('app.integer.naviagtion_interceptor_btn_border_width'), color: Color.Red })
                  .margin({ left: $r('app.integer.naviagtion_interceptor_btn_margin_left') })
                  .backgroundColor($r('app.color.naviagtion_interceptor_burble_bgc_color'))
                  .onClick(() => {
                    // 点击后显示提示文本框
                    promptAction.showToast({
                      message: $r('app.string.naviagtion_interceptor_prompt_text')
                    });
                  })
              }
              .justifyContent(FlexAlign.End)
              .padding($r('app.integer.naviagtion_interceptor_row_padding'))
              .width($r('app.string.naviagtion_interceptor_row_width'))
            }
          }
        }
        .backgroundColor($r('app.color.naviagtion_interceptor_burble_bgc_color'))
        .borderRadius(10)
        .margin({ bottom: $r('app.integer.naviagtion_interceptor_back_padding') })

        ListItem() {
          this.AppCate2();
        }
        .backgroundColor($r('app.color.naviagtion_interceptor_burble_bgc_color'))
        .borderRadius(10)
        .margin({ bottom: $r('app.integer.naviagtion_interceptor_back_padding') })
      }

      Button($r('app.string.naviagtion_interceptor_loginout'))
        .fontColor(Color.White)
        .fontWeight(FontWeight.Normal)
        .borderRadius($r('app.integer.naviagtion_interceptor_border_radius'))
        .type(ButtonType.Normal)
        .backgroundColor($r('app.color.naviagtion_interceptor_red'))
        .onClick(() => {
          this.hasLogin = false; // 注销登录，登录状态置为false，退出登录。
          DynamicsRouter.popAppRouter();
          promptAction.showToast({ message: $r('app.string.naviagtion_interceptor_logout') });
        })
        .width($r('app.string.naviagtion_interceptor_row_width'))
        .id('exitHomePage')
    }
    .backgroundColor($r('app.color.naviagtion_interceptor_bgc_color'))
    .width($r('app.string.naviagtion_interceptor_layout_100'))
    .height($r('app.string.naviagtion_interceptor_layout_100'))
    .padding({
      left: $r('app.integer.naviagtion_interceptor_setting_padding_left'),
      right: $r('app.integer.naviagtion_interceptor_setting_padding_left')
    })
    .alignItems(HorizontalAlign.Start)
  }
}

// 子模块实现拦截接口，做具体的拦截实现
export class MyPageInterceptorExecute implements InterceptorExecute {
  executeFunction(appUri: string, param?: string): boolean {
    // 通过routerInfo判断目的地为"我的页面"时判断登录状态是"未登录"，此时执行跳转到登录页并返回true给拦截容器list（告知需拦截），已登录返回false，放行。
    if (appUri !== undefined && appUri === "navigationinterceptor/InterceptorPage") {
      // 如果未登录
      if (!AppStorage.get("login")) {
        // 跳转登录页
        DynamicsRouter.pushUri("multimodaltransion/HalfModalWindow", param);
        return true; // true：路由拦截
      } else {
        return false; // false：否则放行
      }
    }
    // 通过routerInfo判断目的地为"登录页面"时放行。
    if (appUri !== undefined && appUri === "multimodaltransion/HalfModalWindow") {
      return false;
    }
    return false; // false，路由放行
  }
}

// 拦截器注册拦截函数
Interceptor.registerInterceptorPage(new MyPageInterceptorExecute());



