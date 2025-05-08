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

import { Constants } from '../constants/Constants';
import { ArticleSource } from '../model/BasicDataSource';
import { TreeNode } from '../model/TreeNode';

const COLLAPSE_MENU_DIVIDER_OPACITY = 0.2;

/**
 * 功能描述：
 * 1. 进入页面，呈现面板列表，点击普通面板，跳转到对应文章的网页。
 * 2. 点击折叠面板，面板展开，再次点击，面板收起。
 *
 * 实现原理：
 * 1. 使用List组件遍历折叠面板数据，如果数据含有children数据，使用ListGroup进行二次遍历渲染。(当前场景只支持嵌套层次为两级，多层级待扩展)
 * 2. 点击ListGroup的header组件以及visibility来控制子列表的显示和隐藏。
 *
 * @param {ArticleNode[]} articleNodes - 折叠面板列表数据
 * @param {(articleNode: ArticleNode)=>void} articleItemBuilder - 列表项视图
 * @param {(articleNode: ArticleNode, isExpand:boolean)=>void} articleHeaderBuilder - 列表项逻辑处理
 * @param {ArticleSource<TreeNode>} articleSource - 懒加载数据
 */
@Component
export struct CollapseMenuSection {
  articleNodes: TreeNode[] = [];
  @BuilderParam articleItemBuilder: (articleNode: TreeNode) => void;
  @BuilderParam articleHeaderBuilder: (articleNode: TreeNode) => void;
  @Provide articleSource: ArticleSource<TreeNode> = new ArticleSource();

  aboutToAppear(): void {
    this.articleSource.pushData(this.articleNodes)
  }

  build() {
    List({ space: 10 }) {
      LazyForEach(this.articleSource, (item: TreeNode, index: number) => {
        if (item.children?.length) {
          ArticleGroup({
            articleNode: item,
            articleGroupIndex: index,
            articleItemBuilder: this.articleItemBuilder,
            articleHeaderBuilder: this.articleHeaderBuilder
          })
        } else {
          ListItem() {
            this.articleItemBuilder(item);
          }
          .width('100%')
          .borderRadius($r('app.integer.collapse_menu_list_border_radius'))
          .backgroundColor(Color.White)
          .padding({
            left: $r('app.integer.collapse_menu_list_margin_left'),
            right: $r('app.integer.collapse_menu_list_margin_left'),
            bottom: $r('app.integer.collapse_menu_list_margin_top'),
            top: $r('app.integer.collapse_menu_list_margin_top')
          })
          .align(Alignment.TopStart)
        }
      }, (item: TreeNode) => JSON.stringify(item))
    }
    .width('100%')
    .cachedCount(3)
    .padding({
      left: $r('app.integer.collapse_menu_list_margin_left'),
      right: $r('app.integer.collapse_menu_list_padding_right'),
      bottom: $r('app.integer.collapse_menu_list_padding_right')
    })
    .scrollBar(BarState.Off)
    .layoutWeight(1)
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST
    })
    .backgroundColor('#F3F3F3')
  }
}

@Component
struct ArticleGroup {
  @ObjectLink articleNode: TreeNode;
  @BuilderParam articleItemBuilder: (articleNode: TreeNode) => void;
  @BuilderParam articleHeaderBuilder: (articleNode: TreeNode) => void;
  @State isExpand: boolean = true;
  articleGroupIndex: number = -1;

  @Builder
  treeBuilder(articleNodes: TreeNode[], count: number) {
    ForEach(articleNodes, (articleNode: TreeNode) => {
      this.createBuilder(articleNode, count)
      if (articleNode.expand === this.isExpand && articleNode.children?.length) {
        this.treeBuilder(articleNode.children, count + 1)
      }
    })
  }

  @Builder
  createBuilder(articleNode: TreeNode, count: number) {
    ArticleItem({
      articleNode: articleNode,
      articleItemBuilder: this.articleItemBuilder,
      articleHeaderBuilder: this.articleHeaderBuilder,
      count,
      articleGroupIndex: this.articleGroupIndex
    })
  }

  build() {
    ListItemGroup() {
      ListItem() {
        this.articleHeaderBuilder({
          expand: this.articleNode.expand,
          type: this.articleNode.type,
          title: this.articleNode.title,
          url: this.articleNode.url,
          children: this.articleNode.children,
        })
      }
      .onClick(() => {
        this.articleNode.expand = !this.articleNode.expand;
      })

      if (this.articleNode.expand && this.articleNode.children) {
        this.treeBuilder(this.articleNode.children, 1)
      }
    }
    .width('100%')
    .borderRadius($r('app.integer.collapse_menu_list_border_radius'))
    .backgroundColor(Color.White)
    .padding({
      left: $r('app.integer.collapse_menu_list_margin_left'),
      right: $r('app.integer.collapse_menu_list_margin_left'),
      bottom: $r('app.integer.collapse_menu_list_margin_top'),
      top: $r('app.integer.collapse_menu_list_margin_top')
    })
    .align(Alignment.TopStart)
  }
}

@Component
struct ArticleItem {
  @ObjectLink articleNode: TreeNode;
  @BuilderParam articleItemBuilder: (articleNode: TreeNode) => void;
  @BuilderParam articleHeaderBuilder: (articleNode: TreeNode) => void;
  count: number = 0;
  @Consume articleSource: ArticleSource<TreeNode>;
  articleGroupIndex: number = -1;

  build() {
    ListItem() {
      Column() {
        Column() {
          if (this.articleNode.type === Constants.COLLAPSE_MENU) {
            Column() {
              this.articleHeaderBuilder({
                expand: this.articleNode.expand,
                type: this.articleNode.type,
                title: this.articleNode.title,
                url: this.articleNode.url,
                children: this.articleNode.children,
              })
            }
            .onClick(() => {
              this.articleNode.expand = !this.articleNode.expand;
              this.articleSource.notifyDataChange(this.articleGroupIndex);
            })
          } else {
            this.articleItemBuilder(this.articleNode);
          }
        }.padding({
          left: 12 * this.count
        })
        .width('100%')

        Divider()
          .height(1)
          .opacity(COLLAPSE_MENU_DIVIDER_OPACITY)
          .color($r('app.color.font_color_dark'))
      }
    }
  }
}