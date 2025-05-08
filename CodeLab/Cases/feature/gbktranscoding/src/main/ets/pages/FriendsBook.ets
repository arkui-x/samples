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
 * 实现步骤
 * 1. 使用Axios获取GBK格式的网络数据
 * 2. 使用util.TextDecoder方法进行解码
 */
import util from '@ohos.util';
import axios, { AxiosResponse } from '@ohos/axios';
import { BasicDataSource } from '../viewModel/BasicDataSource';
import promptAction from '@ohos.promptAction';

const LIST_SPACE: number = 0; // 列表默认间隔
const LAYOUT_WEIGHT: number = 1; // 自动分配剩余空间
const LIST_INITIAL_INDEX: number = 0;
const ID_SEARCH: string = 'search'; // 搜索框中搜索栏的ID
const URL: string = 'https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/gbktranscoding/src/main/ets/resources/rawfile/mockData.txt'

@Component
export struct FriendsBookComponent {
  private friendsListData: FriendListData = new FriendListData();

  build() {
    Column() {

      // 通讯录
        Text($r('app.string.gbk_contacts'))
          .fontSize($r('app.integer.gbk_friends_page_title_font_size'))
          .fontWeight(FontWeight.Bold)
          .lineHeight($r('app.integer.gbk_friends_page_title_height'))
          .fontColor($r('app.color.gbk_title_font_color'))
          .fontFamily($r('app.string.gbk_harmony_hei_ti'))
          .width($r('app.string.gbk_layout_100'))
          .height($r('app.integer.gbk_friends_page_title_bar_height'))

      // 搜索栏
      Row() {
        Search({ placeholder: $r('app.string.gbk_search_place_holder') })
          .enableKeyboardOnFocus(false)
          .placeholderFont({ size: $r('app.integer.gbk_search_font_size') })
          .searchIcon({
            src: $r("app.media.gbk_search_svg"),
            size: $r('app.integer.gbk_search_svg_height')
          })
          .placeholderColor($r('app.string.gbk_search_inline_border_color'))
          .backgroundColor(Color.White)
          .height($r('app.integer.gbk_search_inline_height'))
          .width($r('app.string.gbk_layout_100'))
          .textFont({ size: $r('app.integer.gbk_search_font_size') })
          .border({
            width: $r('app.float.gbk_search_inline_border_width'),
            color: $r('app.string.gbk_search_inline_border_color')
          })
          .borderRadius($r('app.integer.gbk_search_border_radius'))
          .id(ID_SEARCH)
          .onClick(()=>{
            promptAction.showToast({ message: $r('app.string.gbk_only_show') });
          })
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height($r('app.integer.gbk_search_outline_height'))
      .width($r('app.string.gbk_layout_100'))
      .backgroundColor($r('app.color.gbk_search_outline_background_color'))
      .margin({ top: $r('app.integer.gbk_discovery_list_margin_top') })

      Column() {
        List({
          space: LIST_SPACE, initialIndex: LIST_INITIAL_INDEX
        }) {
          // 懒加载数据
          LazyForEach(this.friendsListData, (msg: FriendData) => {
            ListItem() {
              ChatContactItemView({ text: msg.userName })
            }
          })
        }
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
        .layoutWeight(LAYOUT_WEIGHT)
        .divider({
          strokeWidth: $r('app.integer.gbk_friends_page_divider_width'),
          color: $r('app.color.gbk_friends_page_divider_color'),
          startMargin: $r('app.integer.gbk_friends_page_search_divider_start_margin')
        })
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .layoutWeight(LAYOUT_WEIGHT)
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .backgroundColor($r('app.color.gbk_friends_page_background'))
    .width($r('app.string.gbk_layout_100'))
    .height($r('app.string.gbk_layout_100'))
    .padding({
      left: $r('app.integer.gbk_friends_page_padding'),
      right: $r('app.integer.gbk_friends_page_padding')
    })
  }

  aboutToAppear() {
    // TODO: 知识点: 使用Axios获取Response.data为GBK格式的网络数据。
    axios<string, AxiosResponse<string>, null>({
      method: "get",
      url: URL,
      // 在使用util.TextDecoder方法时，编码和解码格式要一致，所以在获取时需将数据类型设置为ARRAY_BUFFER，否则会出现乱码。
      responseType: 'ARRAY_BUFFER'
    })
      .then((res: AxiosResponse) => {
        // TODO: 知识点: 使用util.TextDecoder解码。
        // 首先使用create构造TextDecoder实例，将编码格式设置为gbk。
        const textDecoder = util.TextDecoder.create('gbk', { ignoreBOM: true });
        // 其次使用decodeWithStream方法通过解码输入的参数，输出对应UTF-8格式的文本字符串。其中传入的参数必须为Uint8Array格式，因此需将获取的数据使用Uint8Array方法转换数组类型。
        const result = new Uint8Array(res.data);
        const resultString = textDecoder.decodeWithStream(result, { stream: false });
        // 解析json字符串。
        const jsonResult = JSON.parse(resultString) as JsonResult;
        const jsonObj: Array<FriendData> = jsonResult.ListModel;
        // 映射json数据为friendsListData对象。
        for (let i = 0; i < jsonObj.length; i++) {
          const contactTemp = new FriendData(jsonObj[i].userId, jsonObj[i].userName);
          this.friendsListData.pushData(contactTemp);
        }
      })
  }
}

/**
 * 通讯录页面中，联系人布局组件。
 */
@Component
export struct ChatContactItemView {
  private text: string | Resource = '';

  build() {
    Row() {
      Image($r("app.media.gbk_userImage"))
        .width($r('app.integer.gbk_friends_page_contact_image_width'))
        .height($r('app.integer.gbk_friends_page_contact_image_width'))
        .borderRadius($r('app.integer.gbk_friends_page_contact_image_border_radius'))
      Text(this.text)
        .width($r('app.integer.gbk_friends_page_contact_text_width'))
        .height($r('app.integer.gbk_friends_page_contact_text_height'))
        .fontSize($r('app.integer.gbk_friends_page_contact_text_font_size'))
        .fontFamily($r('app.string.gbk_harmony_hei_ti'))
        .fontColor($r('app.color.gbk_title_font_color'))
        .fontWeight(FontWeight.Bold)
        .margin({ left: $r('app.integer.gbk_friends_page_contact_text_margin_left') })
    }
    .width($r('app.string.gbk_layout_100'))
    .height($r('app.integer.gbk_friends_page_contact_row_height'))
    .backgroundColor(Color.White)
  }
}

class FriendData {
  userId: string
  userName: string | Resource

  toString(): string {
    return this.userId + '  ' + this.userName;
  }

  constructor(id: string, name: string | Resource) {
    this.userId = id;
    this.userName = name;
  }
}

class JsonResult {
  ListModel: Array<FriendData> = [];
}

class FriendListData extends BasicDataSource<FriendData> {
  friendList: Array<FriendData> = [];

  public totalCount(): number {
    return this.friendList.length;
  }

  public getData(index: number): FriendData {
    return this.friendList[index];
  }

  public addData(index: number, data: FriendData): void {
    this.friendList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: FriendData): void {
    this.friendList.push(data);
    this.notifyDataAdd(this.friendList.length - 1);
  }
}