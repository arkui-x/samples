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

import webview from '@ohos.web.webview';
import { UIContext } from '@ohos.arkui.UIContext';
import { BuilderNode, FrameNode, NodeController, NodeRenderType } from '@ohos.arkui.node';
import { PRODUCT_DATA } from '../mock/GoodsMock';
import { ProductDataModel } from '../model/GoodsModel';
import promptAction from '@ohos.promptAction';

/**
 * 使用arkweb同层渲染组件样例
 *
 * 核心组件:
 * 1. SearchNodeController
 *
 * 实现步骤:
 * 1. web内核识别到前端页面使用同层embed标签，基于embed标签创建独立surface绘制环境，web内核将surface和embed标签创建信息上报到应用侧
 * 2. 应用侧收到embed标签创建消息后，根据业务需要，创建离屏节点数
 * 3. web内核识别embed标签事件将转发给应用侧，通过应用根据业务需要转发给对应的离屏节点数
 */

const MARGIN_VERTICAL: number = 8; // 组件间距离
const OPACITY: number = 0.6; // 字体设置透明度

/**
 * 组件显示宽和高参数
 */
declare class Params {
  width: number
  height: number
}

/**
 * nodeController参数
 */
declare class NodeControllerParams {
  surfaceId: string
  type: string
  renderType: NodeRenderType
  embedId: string
  width: number
  height: number
}

/**
 * 用于控制和反馈对应的NodeContainer上的节点的行为，需要与NodeContainer一起使用
 */
class SearchNodeController extends NodeController {
  private rootNode: BuilderNode<[Params]> | undefined | null = null;
  private embedId: string = "";
  private surfaceId: string = "";
  private renderType: NodeRenderType = NodeRenderType.RENDER_TYPE_DISPLAY;
  private componentWidth: number = 0;
  private componentHeight: number = 0;
  private componentType: string = "";

  setRenderOption(params: NodeControllerParams): void {
    this.surfaceId = params.surfaceId;
    this.renderType = params.renderType;
    this.embedId = params.embedId;
    this.componentWidth = params.width;
    this.componentHeight = params.height;
    this.componentType = params.type;
  }

  /**
   * 在对应NodeContainer创建的时候调用、或者通过rebuild方法调用刷新
   */
  makeNode(uiContext: UIContext): FrameNode | null {
    this.rootNode = new BuilderNode(uiContext, { surfaceId: this.surfaceId, type: this.renderType });
    if (this.componentType === 'native/component') {
      // 创建组件树
      // TODO: 知识点：wrapBuilde封装全局@Builder
      this.rootNode.build(wrapBuilder(searchBuilder), { width: this.componentWidth, height: this.componentHeight });
    }
    // 返回FrameNode节点
    return this.rootNode.getFrameNode();
  }

  /**
   * 设置BuilderNode节点
   */
  setBuilderNode(rootNode: BuilderNode<Params[]> | null): void {
    this.rootNode = rootNode;
  }

  /**
   * 获取BuilderNode节点
   */
  getBuilderNode(): BuilderNode<[Params]> | undefined | null {
    return this.rootNode;
  }

  /**
   * 更新BuilderNode节点
   */
  updateNode(arg: Object): void {
    this.rootNode?.update(arg);
  }

  /**
   * 获取EmbedId
   */
  getEmbedId(): string {
    return this.embedId;
  }

  /**
   * 将触摸事件派发到rootNode创建出的FrameNode上
   */
  postEvent(event: TouchEvent | undefined): boolean {
    return this.rootNode?.postTouchEvent(event) as boolean;
  }
}

// 同层渲染显示原生组件
@Component
struct SearchComponent {
  @Prop params: Params;

  build() {
    Column({ space: MARGIN_VERTICAL }) {
      // 原生Text组件
      Text($r("app.string.nativeembed_mall")).fontSize($r('app.string.ohos_id_text_size_body1'))
      Row() {
        Image($r("app.media.nativeembed_search_icon"))
          .width($r("app.integer.nativeembed_search_icon_width"))
          .margin({ left: $r("app.integer.nativeembed_left_margin") })
        Text($r("app.string.nativeembed_search_text_placeholder"))
          .fontSize($r('app.string.ohos_id_text_size_body2'))
          .opacity(OPACITY)
          .fontColor($r('app.color.ohos_id_color_foreground'))
          .margin({ left: $r("app.integer.nativeembed_left_margin") })
      }
      .width($r("app.string.nativeembed_full_percent"))
      .margin($r("app.integer.nativeembed_row_margin"))
      .height($r("app.integer.nativeembed_search_row_height"))
      .backgroundColor($r('app.color.ohos_id_color_background'))
      .borderRadius($r("app.integer.nativeembed_search_border_radius"))
      .onClick(() => {
        // 点击搜索框提示
        promptAction.showToast({
          message: $r("app.string.nativeembed_prompt_text")
        });
      })

      Grid() {
        // 性能知识点：此处仅演示，数据量确定且数量较少，使用了ForEach，在数据量多的情况下，推荐使用LazyForeEach。[LazyForeEach](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-rendering-control-lazyforeach-0000001820879609)
        ForEach(PRODUCT_DATA, (item: ProductDataModel, index: number) => {
          GridItem() {
            Column({ space: MARGIN_VERTICAL }) {
              Image(item.uri).width($r("app.integer.nativeembed_image_size"))
              Row({ space: MARGIN_VERTICAL }) {
                Text(item.title).fontSize($r('app.string.ohos_id_text_size_body3'))
                Text(item.price).fontSize($r('app.string.ohos_id_text_size_body3'))
              }
            }
            .backgroundColor($r('app.color.ohos_id_color_background'))
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .width($r("app.string.nativeembed_full_percent"))
            .borderRadius($r('app.string.ohos_id_corner_radius_default_m'))
            .padding({ bottom: $r('app.integer.nativeembed_grid_item_column_padding_bottom') })
          }
        })
      }
      .columnsTemplate('1fr 1fr')
      .rowsGap($r('app.string.ohos_id_elements_margin_vertical_m'))
      .columnsGap($r('app.string.ohos_id_elements_margin_vertical_m'))
      .width($r("app.string.nativeembed_full_percent"))
      .backgroundColor($r('app.color.ohos_id_color_sub_background'))
    }
    .padding($r('app.string.ohos_id_card_margin_start'))
    .width(this.params.width)
    .height(this.params.height)
  }
}

@Builder
function searchBuilder(params: Params) {
  SearchComponent({ params: params })
    .backgroundColor($r('app.color.ohos_id_color_sub_background'))
}

@Component
export struct WebViewDemoComponent {
  browserTabController: WebviewController = new webview.WebviewController(); // WebviewController控制器
  @State componentIdArr: Array<string> = []; // 存放componentId的数组
  private nodeControllerMap: Map<string, SearchNodeController> =
    new Map(); // map对象，key为componentId，value为SearchNodeController

  build() {
    Stack() {
      // 性能知识点：此处componentId项确定且数量较少，使用了ForEach，在数据量多的情况下，推荐使用LazyForeEach。[LazyForeEach](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-rendering-control-lazyforeach-0000001820879609)
      ForEach(this.componentIdArr, (componentId: string) => {
        NodeContainer(this.nodeControllerMap.get(componentId));
      }, (embedId: string) => embedId)
      // web组件加载本地test.html页面
      Web({ src: $rawfile("nativeembed_view.html"), controller: this.browserTabController })
        .backgroundColor($r('app.color.ohos_id_color_sub_background'))
        .zoomAccess(false)// 不允许执行缩放
        .enableNativeEmbedMode(true)// TODO: 知识点：通过enableNativeEmbedMode（）配置同层渲染开关
        .onNativeEmbedLifecycleChange((embed) => { // TODO: 知识点：通过onNativeEmbedLifecycleChange获取embed标签的生命周期变化数据
          // 获取web侧embed元素的id
          const componentId = embed.info?.id?.toString() as string
          if (embed.status === NativeEmbedStatus.CREATE) {
            // 创建节点控制器，设置参数并rebuild
            let nodeController = new SearchNodeController();
            // 外接纹理与WebView同层渲染
            nodeController.setRenderOption({
              surfaceId: embed.surfaceId as string,
              type: embed.info?.type as string,
              renderType: NodeRenderType.RENDER_TYPE_TEXTURE,
              embedId: embed.embedId as string,
              width: px2vp(embed.info?.width),
              height: px2vp(embed.info?.height)
            });
            nodeController.rebuild();
            // 根据web传入的embed的id属性作为key，将nodeController存入map
            this.nodeControllerMap.set(componentId, nodeController);
            // 将web传入的embed的id属性存入@State状态数组变量中，用于动态创建nodeContainer节点容器，需要将push动作放在set之后
            this.componentIdArr.push(componentId);
          } else if (embed.status === NativeEmbedStatus.UPDATE) {
            let nodeController = this.nodeControllerMap.get(componentId);
            nodeController?.updateNode({
              text: 'update',
              width: px2vp(embed.info?.width),
              height: px2vp(embed.info?.height)
            } as ESObject);
            nodeController?.rebuild();
          } else {
            let nodeController = this.nodeControllerMap.get(componentId);
            nodeController?.setBuilderNode(null);
            nodeController?.rebuild();
          }
        })
        .onNativeEmbedGestureEvent((touch) => { // 获取同层渲染组件触摸事件信息
          this.componentIdArr.forEach((componentId: string) => {
            let nodeController = this.nodeControllerMap.get(componentId);
            if (nodeController?.getEmbedId() === touch.embedId) {
              nodeController?.postEvent(touch.touchEvent);
            }
          })
        })
    }
  }
}