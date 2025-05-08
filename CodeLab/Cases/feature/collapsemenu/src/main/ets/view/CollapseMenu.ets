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
 *
 **/

import { AppRouter } from 'routermodule';
import { ARTICLE_DATA } from '../model/MockData';
import { ArticleNode } from '../model/ArticleNode';
import { FoldableRouter } from 'routermodule';
import { CollapseMenuSection } from '../utils/CollapseMenuSection';
import { logger } from 'utils';
import { TreeNode } from '../model/TreeNode';

/**
 * 功能描述：本示例通过定义层级实现多层折叠面板，并在首页性能文章tab实际使用跳转到对应文章的web页面
 *
 * 推荐场景：折叠面板
 *
 * 核心组件：
 *
 * CollapseMenuSection - 折叠面板模块
 *
 * 实现步骤：
 *
 * 1. 定义面板数据类ArticleNode，开发者可以自行扩展数据属性。
 * @example
 * class TreeNode {
 *   expand: boolean = false;
 *   type: number | string | ESObject = 0
 *   title: string = ''
 *   url?: string = ''
 *   children?:TreeNode[] = []
 * }
 *
 * 2. 初始化数据。
 * @example
 * @State articleNodes: ArticleNode[] = [];
 *
 * aboutToAppear() {
 *   this.articleNodes = [...ARTICLE_DATA];
 * }
 *
 * 3. 构建折叠面板列表视图。
 * @example
 * CollapseMenuSection({
 *   articleNodes: this.articleNodes,
 *   articleItemBuilder: this.articleItemBuilder,
 *   articleHeaderBuilder: this.articleHeaderBuilder
 * })
 *
 *
 */

@AppRouter({ name: "collapsemenu/CollapseMenu" })
@Component
export struct CollapseMenu {
  @State articleNodes: TreeNode[] = [];

  aboutToAppear(): void {
    this.articleNodes = this.handleData(ARTICLE_DATA);
  }

  handleData(articleData: ArticleNode[]) {
    let newData = articleData.map((item) => {
      let obj = new TreeNode()
      obj.type = item.type;
      obj.title = item.title;
      obj.url = item.url;
      if (item.children) {
        obj.children = this.handleData(item.children);
      }
      return obj;
    })
    return newData;
  }

  build() {
    Column() {
      /**
       * 折叠面板视图
       *
       * @param {TreeNode[]} articleNodes - 折叠面板列表数据
       * @param {(articleNode: TreeNode)=>void} articleItemBuilder - 列表项视图
       * @param {(articleNode: TreeNode, isExpand:boolean)=>void} articleHeaderBuilder - 列表头部视图
       */
      CollapseMenuSection({
        articleNodes: this.articleNodes,
        articleItemBuilder: this.articleItemBuilder,
        articleHeaderBuilder: this.articleHeaderBuilder
      })
    }
  }

  @Builder
  articleItemBuilder(articleNode: TreeNode) {
    Column() {
      Row() {
        Text(articleNode.title)
          .fontSize($r('app.integer.collapse_menu_text_font_size'))
          .layoutWeight(1)
          .align(Alignment.Start)
          .fontFamily('HarmonyHeiTi-Medium')
          .fontColor($r('app.color.font_color_dark'))
        Blank()
      }
      .height($r('app.integer.collapse_menu_fourth_level_height'))
      .width('100%')
      .onClick(() => {
        if (articleNode.url) {
          logger.info(`ArticleNode` + JSON.stringify(articleNode));
          FoldableRouter.pushUri('collapsemenu/ArticleWebComponent', articleNode);
          AppStorage.setOrCreate('articleWebUrl', articleNode.url);
        }
      })
    }
  }

  @Builder
  articleHeaderBuilder(articleNode: TreeNode) {
    Row() {
      Text(articleNode.title)
        .fontSize($r('app.integer.collapse_menu_text_font_size'))
        .fontFamily('HarmonyHeiTi-Medium')
        .fontColor($r('app.color.font_color_dark'))

      Blank()

      Image(articleNode.expand ? $r('app.media.ic_down_arrow') : $r('app.media.ic_right_arrow'))
        .width(articleNode.expand ? $r('app.integer.collapse_menu_arrow_unfold_width') :
        $r('app.integer.collapse_menu_arrow_width'))
        .height(articleNode.expand ? $r('app.integer.collapse_menu_arrow_width') :
        $r('app.integer.collapse_menu_arrow_unfold_width'))
        .margin({ right: articleNode.expand ? 0 : $r('app.integer.collapse_menu_arrow_fold_margin_right') })
    }
    .height(56)
    .width('100%')
  }
}

