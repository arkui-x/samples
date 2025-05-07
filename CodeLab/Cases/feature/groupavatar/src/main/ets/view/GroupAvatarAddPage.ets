/*
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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
import { ImageCombination } from '../utils/ImageCombination';
import { NavigationBarContent } from './components/NavigationBarContent';
import { PersonContent } from './components/PersonContent';
import { image } from '@kit.ImageKit';
import { PersonData, SessionData } from '../datasource/GroupAvatarModel';
import { AppRouter, DynamicsRouter } from 'routermodule';
import { logger, PlatformInfo, PlatformTypeEnum } from 'utils';
import { PERSON_MSG } from '../datasource/DataSource';
import { SnapShotModel } from '../model/SnapShotModel';

/**
 * 功能描述：本示例介绍使用[组件截图](https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/js-apis-arkui-componentsnapshot-V5)
 * 实现组件的截图并获取pixelMap对象。发起群聊页面，包含导航栏、搜索组件（包含群成员列表）、好友列表、底部自定义按钮。该场景多用于通信类应用。
 *
 * 推荐场景：通信类应用的群聊功能
 *
 * 核心组件：
 * 1.ImageCombination - 图片拼接组件
 *
 * 实现步骤：
 *
 * 1.当前组件默认id为avatar_group，开发者也可以通过SnapShotModel的setComponentId函数来设置组件id值。
 * @example
 *
 * this.snapShotModel.setComponentId('id名称')
 *
 *
 * 2.构建图片拼接组件视图。
 * @example
 * ImageCombination({
 *   imageArr: this.imageArr,
 *   snapShotModel: this.snapShotModel
 * })
 *
 * 3. 执行组件截图逻辑。
 * @example
 * let imagePixelMap = this.snapShotModel?.getSnapShot();
 *
 *
 */

@AppRouter({ name: 'groupavatar/GroupAvatarAddPage' })
@Component
export struct GroupAvatarAddPage {
  // 已选择的联系人群组
  @State selectPersonGroup: PersonData[] = [];
  // 是否加载完成
  @State isLoading: boolean = false;
  // 组件截图属性类
  @State snapShotModel: SnapShotModel = new SnapShotModel();
  // 头像数组
  @State imageArr: (ResourceStr | image.PixelMap)[] = [];
  // 会话数组
  sessionGroup: SessionData[] = AppStorage.get('sessionList') as SessionData[];
  // 个人信息
  personMsg: PersonData = PERSON_MSG;
  @StorageLink('avoidAreaTopToModule') avoidAreaTopToModule: number = 0;

  build() {
    Stack() {
      if (this.isLoading) {
        // 使用堆叠组件，实现绘制组件在loading动画后执行
        Stack() {
          /**
           * ImageCombination - 图片拼接组件
           * imageArr - 已选择的联系人头像
           * snapShotModel - 组件截图属性类
           */
          ImageCombination({
            imageArr: this.imageArr,
            snapShotModel: this.snapShotModel
          })
          // loading弹框
          Column() {
            LoadingProgress()
              .color(Color.White)
              .width($r('app.integer.group_avatar_custom_loading_progress_size'))
              .height($r('app.integer.group_avatar_custom_loading_progress_size'))
            Text($r('app.string.group_avatar_loading_message'))
              .fontSize($r('app.integer.group_avatar_custom_loading_font_size'))
              .fontColor(Color.White)
          }
          .width($r('app.integer.group_avatar_custom_loading_size'))
          .height($r('app.integer.group_avatar_custom_loading_size'))
          .border({ radius: 20 })
          .backgroundColor($r('app.color.group_avatar_loading_background_color'))
          .justifyContent(FlexAlign.Center)
        }
        .width($r('app.string.group_avatar_full_size'))
        .height($r('app.string.group_avatar_full_size'))
        .zIndex(2)
      }
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.End, justifyContent: FlexAlign.End }) {
        Column() {
        }
        .width($r('app.string.group_avatar_full_size'))
        .height(px2vp(this.avoidAreaTopToModule))
        .backgroundColor($r('app.color.group_avatar_navigation'))

        // 顶部导航栏
        NavigationBarContent({
          title: $r('app.string.group_avatar_add_page_title'),
          isMenu: false,
          isSearch: false
        })

        // 好友列表
        PersonContent({ selectPersonList: this.selectPersonGroup })

        // 自定义按钮
        Row() {
          Column() {
            Text(`完成${this.selectPersonGroup.length > 0 ? `(${this.selectPersonGroup.length})` : ''}`)
              .fontColor($r('app.color.group_avatar_white'))
              .fontSize($r('app.integer.group_avatar_bottom_font_size'))
          }
          .id('group_avatar_finish_button')
          .justifyContent(FlexAlign.Center)
          .height($r('app.integer.group_avatar_add_button_height'))
          .width($r('app.integer.group_avatar_add_button_width'))
          .backgroundColor(this.selectPersonGroup.length > 0 ?
          $r('app.color.group_avatar_add_page_button_background_color') :
          $r('app.color.group_avatar_add_page_button_disabled_background_color'))
          .border({ radius: 5 })
          .margin({ right: 15 })
          .onClick(() => {
            if (this.selectPersonGroup.length > 0) {
              // 开启loading组件
              this.isLoading = true;
              // 模拟网络请求操作，请求网络1500毫秒后得到数据，通知组件，变更列表数据
              this.selectPersonGroup.forEach((item) => {
                this.imageArr.push(item.headImg);
              })
              this.imageArr.push(this.personMsg.headImg);
              setTimeout(() => {
                try {
                  // TODO: 知识点：根据组件的id属性获取组件截图。仅真机或模拟器可用，当组件visibility属性值为Visibility.Hidden时不生效
                  let imagePixelMap = this.snapShotModel?.getSnapShot();
                  if (!imagePixelMap) {
                    return
                  }
                  let wid: string = '';
                  const lastSessionData: SessionData | undefined = this.sessionGroup[0];
                  if (lastSessionData) {
                    wid = Number.parseInt(lastSessionData.wid) + 1 + '';
                  } else {
                    wid = '10001';
                  }

                  // 获取组件名称
                  let groupName: string = '';
                  this.selectPersonGroup.forEach((item: PersonData) => {
                    if (groupName === '') {
                      groupName += item.name;
                    } else {
                      groupName += '、' + item.name;
                    }
                  });

                  // 获取最后一条信息
                  const lastMessage: string = `你邀请${groupName}加入了群聊`;

                  groupName += ('、' + this.personMsg.name);
                  // 增加一条会话记录
                  this.sessionGroup.unshift({
                    wid: wid,
                    headImg: imagePixelMap,
                    name: groupName,
                    lastMsg: lastMessage
                  });

                  // 存储会话信息
                  AppStorage.setOrCreate('sessionList', this.sessionGroup);

                  // 关闭loading组件
                  this.isLoading = false;
                  // 返回会话首页
                  DynamicsRouter.popAppRouter();
                } catch (error) {
                  if (error) {
                    logger.error(`the err is ${error.code},errMessage: ${error.message}`);
                    // 当组件截图报错时，直接关闭弹框，避免loading动画无法关闭
                    this.isLoading = false;
                  }
                }
              }, 1500);
            }
          })
        }
        .align(Alignment.Bottom)
        .width($r('app.string.group_avatar_full_size'))
        .height($r('app.integer.group_avatar_add_button_component_height'))
        .backgroundColor($r('app.color.group_avatar_add_page_button_component_background_color'))
        .justifyContent(FlexAlign.End)
      }
      .id('group_avatar_add_session_page')
      .backgroundColor($r('app.color.group_avatar_white'))
      .width($r('app.string.group_avatar_full_size')).height($r('app.string.group_avatar_full_size'))
    }
    .gesture(
      SwipeGesture({ direction: SwipeDirection.Horizontal })
        .onAction((event: GestureEvent) => {
          if (PlatformInfo.getPlatform() === PlatformTypeEnum.IOS) {
            if (event) {
              DynamicsRouter.popAppRouter();
            }
          }
        })
    )
  }
}