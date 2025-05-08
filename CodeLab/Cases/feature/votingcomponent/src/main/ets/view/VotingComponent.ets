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

import Constants from '../constants/Constants';
import { VotingView } from '../utils/VotingView';
import { VotingType } from '../model/DataType';


/**
 * 功能描述: 本示例介绍使用绘制组件中的Polygon组件配合使用显式动画以及borderRadius实现投票pk组件。
 *
 * 推荐场景: 需要投票pk的场景
 *
 * 核心组件:
 * 1. VotingView: 投票组件
 *
 * 实现步骤:
 * 1. 初始化投票资源属性内容。
 *
 * @example
 * @State votingSource: VotingType = new VotingType();
 *
 * 2. 构建投票视图组件。
 *
 * @example
VotingView({
 votingSource: this.votingSource,
 votingHandle: (isClick: boolean, notice: string) => {
 this.isClick = isClick;
 this.notice = notice;
 }
 })
 *
 */
@Component
export struct VotingViewComponent {
  // 是否已投票
  @State isClick: boolean = false;
  // 投票组件下方提示的内容
  @State notice: string = '点击上方按钮，选择你的观点';
  // 投票资源属性
  @State votingSource: VotingType = new VotingType(4, 13);

  build() {
    Column() {
      // 投票主题
      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.Start
      }) {
        Image($r("app.media.voting_component_avatars"))// 投票举行者头像
          .width($r("app.integer.voting_component_voting_theme_image_width"))
          .height($r("app.integer.voting_component_voting_theme_image_height"))
          .margin({
            left: $r("app.integer.voting_component_voting_theme_image_margin_left"),
            right: $r("app.integer.voting_component_voting_theme_image_margin_right")
          })
        Text($r("app.string.voting_component_voting_theme_image_text"))// 投票主题内容
          .fontSize($r("app.integer.voting_component_voting_theme_image_text_font_size"))
      }

      /**
       * 投票视图
       *
       * @param {VotingType} votingSource - 投票资源属性
       * @param {void} votingHandle - 点击投票逻辑
       */
      VotingView({
        votingSource: this.votingSource,
        votingHandle: (option: string) => {
          this.notice = '已选择"' + option + '"';
          if (!this.isClick) {
            this.isClick = true;
          }
        }
      })
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        // 提示
        Text(this.notice)
          .fontSize($r("app.integer.voting_component_bottom_text_font_size"))
          .margin({ left: $r("app.integer.voting_component_bottom_text_margin") })
        Stack() {
          if (this.isClick) {
            Text(this.votingSource.leftOptionChoose + this.votingSource.rightOptionChoose +
            Constants.BOTTOM_TEXT_SUFFIX)
              .fontSize($r("app.integer.voting_component_bottom_text_font_size"))
              .margin({ right: $r("app.integer.voting_component_bottom_text_margin") })
          }
        }
      }
    }
    .backgroundColor(Color.White)
    .height($r("app.string.voting_component_parent_column_height"))
    .width($r("app.string.voting_component_parent_column_width"))
    .justifyContent(FlexAlign.Center)
  }
}
