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
import { PERSON_LIST } from '../../datasource/DataSource';
import { PersonData } from '../../datasource/GroupAvatarModel';

/**
 * 好友选择列表，包含顶部搜索栏（仅实现添加图片效果）和好友列表
 */
@Component
export struct PersonContent {
  private personList: PersonData[] = [...PERSON_LIST];
  @State searchHeight: number = 30;
  @Link selectPersonList: PersonData[];

  build() {
    Column() {
      // 搜索栏：使用横向List组件实现群组成员滑动列表
      Row() {
        List() {
          // TODO: 需求：真实场景下，当用户数据较大时，建议使用LazyForEach组件
          ForEach(this.selectPersonList, (item: PersonData, index: number) => {
            ListItem() {
              Column() {
                Image(typeof item.headImg === 'string' ? $rawfile(item.headImg) : item.headImg)
                  .width($r('app.integer.group_avatar_person_selected_header_size'))
                  .height($r('app.integer.group_avatar_person_selected_header_size'))
                  .borderRadius($r('app.integer.group_avatar_person_selected_header_radius'))
              }
              .height($r('app.integer.group_avatar_person_header_column_height'))
              .justifyContent(FlexAlign.Center)
            }
            .margin({ right: 5, left: index === 0 ? 5 : 0 })
          })
          ListItem() {
            Row() {
              Image($r("app.media.group_avatar_input_search"))
                .width($r('app.integer.group_avatar_person_header_search_icon_size'))
                .height($r('app.integer.group_avatar_person_header_search_icon_size'))
                .opacity(0.5)
              Text($r('app.string.group_avatar_search'))
                .fontSize($r('app.integer.group_avatar_person_header_search_font_size'))
                .opacity(0.5)
                .margin({ left: 6, right: 15 })
            }
            .justifyContent(FlexAlign.Start)
            .height($r('app.string.group_avatar_full_size'))
            .margin({
              left: 15
            })
          }
        }
        .listDirection(Axis.Horizontal)
        .scrollBar(BarState.Off)
        .backgroundColor($r('app.color.group_avatar_selected_person_list_background_color'))
        .border({ radius: 5 })
        .height(this.searchHeight)
        .width($r('app.string.group_avatar_person_search_width'))
      }
      .height(this.searchHeight + 10)
      .width($r('app.string.group_avatar_full_size'))
      .backgroundColor($r('app.color.group_avatar_selected_person_component_background_color'))
      .justifyContent(FlexAlign.Center)

      /**
       * 好友列表：使用checkbox实现好友选择
       */
      List() {
        ListItem() {
          Column() {
            Text($r('app.string.group_avatar_add_page_select_group'))
              .fontSize($r('app.integer.group_avatar_person_list_font_size'))
              .width($r('app.string.group_avatar_full_size'))
              .margin({
                top: 15,
                bottom: 15,
                left: 15
              })
              .width($r('app.string.group_avatar_full_size'))
            Divider()
              .width($r('app.string.group_avatar_full_size'))
              .color($r('app.color.group_avatar_black'))
              .opacity(0.1)
              .strokeWidth(0.8)
          }
          .width($r('app.string.group_avatar_full_size'))
          .height($r('app.integer.group_avatar_person_list_height'))
          .justifyContent(FlexAlign.Start)
        }

        ListItem() {
          Column() {
            Text($r('app.string.group_avatar_add_page_face_group'))
              .fontSize($r('app.integer.group_avatar_person_list_font_size'))
              .margin({
                top: 15,
                bottom: 15,
                left: 15
              })
              .width($r('app.string.group_avatar_full_size'))
            Divider()
              .width($r('app.string.group_avatar_full_size'))
              .color($r('app.color.group_avatar_black'))
              .opacity(0.1)
              .strokeWidth(0.8)
          }
          .width($r('app.string.group_avatar_full_size'))
          .height($r('app.integer.group_avatar_person_list_height'))
          .justifyContent(FlexAlign.Start)
        }

        ListItem() {
          Column() {
            Text($r('app.string.group_avatar_add_page_business_group'))
              .fontSize($r('app.integer.group_avatar_person_list_font_size'))
              .margin({
                top: 15,
                bottom: 15,
                left: 15
              })
              .width($r('app.string.group_avatar_full_size'))
            Divider()
              .width($r('app.string.group_avatar_full_size'))
              .color($r('app.color.group_avatar_black'))
              .opacity(0.1)
              .strokeWidth(0.8)
          }
          .width($r('app.string.group_avatar_full_size'))
          .height($r('app.integer.group_avatar_person_list_height'))
          .justifyContent(FlexAlign.Start)
        }
        .margin({ bottom: 1 })

        ForEach(this.personList, (item: PersonData, index: number) => {
          ListItem() {
            Row() {
              // 复选框
              Checkbox({})
                .id(`group_avatar_person_${index}`)
                .select(false)
                .selectedColor($r('app.color.group_avatar_selected_person_checkbox'))
                .shape(CheckBoxShape.CIRCLE)
                .onChange((value: boolean) => {
                  if (value) {
                    this.selectPersonList.push(item);
                    this.searchHeight = 50;
                  } else {
                    this.selectPersonList.splice(this.selectPersonList.indexOf(item), 1);
                    if (this.selectPersonList.length === 0) {
                      this.searchHeight = 30;
                    }
                  }
                })
                .margin({ left: 15 })

              // 头像
              Flex({
                direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems:
                ItemAlign.Center
              }) {
                Image(typeof item.headImg === 'string' ? $rawfile(item.headImg) : item.headImg)
                  .width($r('app.string.group_avatar_person_header_size'))
                  .height($r('app.string.group_avatar_person_header_size'))
                  .borderRadius(5)
                  .backgroundColor($r('app.color.group_avatar_head_image_background_color'))
              }
              .width($r('app.integer.group_avatar_person_header_flex_size'))
              .height($r('app.integer.group_avatar_person_header_flex_size'))

              // 昵称
              Column() {
                Text(item.name)
                  .width($r('app.string.group_avatar_full_size'))
                  .height($r('app.integer.group_avatar_person_name_height'))
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
                  .fontSize($r('app.integer.group_avatar_person_name_font_size'))
                Divider()
                  .width($r('app.string.group_avatar_full_size'))
                  .color($r('app.color.group_avatar_black'))
                  .opacity(0.1)
                  .strokeWidth(0.8)
              }.height($r('app.integer.group_avatar_person_header_flex_size')).layoutWeight(1)
            }
            .justifyContent(FlexAlign.Start)
            .height($r('app.integer.group_avatar_person_header_flex_size'))
            .width($r('app.string.group_avatar_full_size'))
            .backgroundColor($r('app.color.group_avatar_white'))
          }
        }, (item: PersonData) => item.wid)
      }
      .width($r('app.string.group_avatar_full_size'))
      .height($r('app.string.group_avatar_full_size'))
      .scrollBar(BarState.Off)
    }
    .width($r('app.string.group_avatar_full_size'))
    .height($r('app.string.group_avatar_full_size'))
    // 防止人员列表被底部按钮遮挡
    .margin({ bottom: 70 })
    .backgroundColor($r('app.color.group_avatar_white'))
  }
}

