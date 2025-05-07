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

import { common2D } from '@kit.ArkGraphics2D';
import { Constants } from '../constants/Contants';
import { hexToRgb, hslToHex } from '../utils/ColorTypeConverter';
import { HslType, RgbType } from '../model/ColorModel';
import { HEX_HUES_DATA, HSL_HUES_DATA } from '../data/ColorsData';
import { MyNodeController, MyRenderNode } from '../model/RenderNodeModel';
import { promptAction } from '@kit.ArkUI';

/**
 * 功能描述: 本示例实现了一个网格渐变的画笔调色板，能够根据给定的 HSL 类型颜色和色阶数，按亮度生成渐变色，用户可以通过调色板选择颜色并在画布上绘制路径。
 *
 * 推荐场景: 画笔调色板绘制场景
 *
 * 核心组件:
 * 1. HslPalette
 *
 * 实现步骤：
 * 1.实现HSL、RGB和HEX颜色类型之间互相转换的函数hslToHex、hexToRgb等。
 * 2.定义MyRenderNode类初始化画笔、设置画笔颜色和绘制path路径。
 * 3.定义MyNodeController类管理NodeContainer上节点的创建和删除。
 * 4.创建自定义节点容器组件NodeContainer，接收MyNodeController的实例，通过添加自定义渲染节点MyRenderNode实现自定义绘制，组件的宽高为图片加载完成后实际内容区域的宽高，
 *   并通过相对容器布局的alignRules使NodeContainer与图片内容区域重叠，控制绘制区域。
 * 5.创建调色板组件HslPalette，根据传入的参数hslHues(HSL色相数组)和levels(渐变色阶数)计算Grid的行、列模板，并结合gradientStartPoint和gradientEndPoint(渐变开始
 *   和结束点的亮度值)生成渐变色，生成的渐变色使用函数hslToHex转换为HEX类型颜色后用colors存储，使用Gird组件遍历colors生成网格型的渐变色块，点击色块时修改@Link类型的状
 *   态变量selectedColor与父组件同步选中颜色。
 * 6.创建Builder函数bottomPenShape，展示当前选中颜色selectedColor并控制调色板组件HslPalette的显隐，以及根据HEX类型的颜色数组hexHues生成常用颜色网格。
 * 7.在NodeContainer组件的onTouch回调函数中，手指按下时基于当前选中颜色selectedColor创建新的MyRenderNode节点，并挂载到rootRenderNode，手指移动更新节点中的path对象，
 *   并将节点重新渲染，绘制对应颜色的移动轨迹。
 */
@Component
export struct PaletteComponent {
  @State selectedColor: string = ''; // 当前选中的画笔颜色
  @State nodeContainerWidth: number = 0; // 绘制区域 NodeContainer 宽度
  @State nodeContainerHeight: number = 0; // 绘制区域 NodeContainer 高度
  @State isShowPalette: boolean = false; // 控制调色板显隐
  private currentNode: MyRenderNode | null = null; // 当前正在绘制的节点
  private myNodeController: MyNodeController = new MyNodeController();
  private levels: number = Constants.GRADIENT_LEVELS; // 渐变色阶数
  // 常用色相（HEX格式）
  private hexHues: string[] = HEX_HUES_DATA;
  // 渐变基本色相（HSL格式）
  private hslHues: HslType[] = HSL_HUES_DATA;

  aboutToAppear(): void {
    if (this.hexHues.length !== 0) {
      this.selectedColor = this.hexHues[0];
    }
  }

  /**
   * touch事件触发后绘制手指移动轨迹
   */
  onTouchEvent(event: TouchEvent): void {
    // 获取手指触摸位置的坐标点
    const positionX: number = vp2px(event.touches[0].x);
    const positionY: number = vp2px(event.touches[0].y);
    switch (event.type) {
      case TouchType.Down: {
        this.isShowPalette = false; // 隐藏调色板
        // TODO：知识点：使用hexToRgb转换函数将当前选中的HEX类型颜色转为RGB格式，创建penColor对象，通过new MyRenderNode(penColor)修改节点中的画笔颜色
        const rgb: RgbType | null = hexToRgb(this.selectedColor);
        if (rgb === null) {
          return;
        }
        const penColor: common2D.Color = {
          alpha: 0xFF,
          red: rgb.red,
          green: rgb.green,
          blue: rgb.blue
        };
        // 每次手指按下，创建一个 MyRenderNode 对象，用于记录和绘制手指移动的轨迹，传入penColor设置画笔颜色
        const newNode = new MyRenderNode(penColor);
        // 定义newNode的大小和位置，位置从组件NodeContainer的左上角(0,0)坐标开始，大小为NodeContainer的宽高
        newNode.frame = {
          x: 0,
          y: 0,
          width: this.nodeContainerWidth,
          height: this.nodeContainerHeight
        };
        this.currentNode = newNode;
        // 移动新节点中的路径path到手指按下的坐标点
        this.currentNode.path.moveTo(positionX, positionY);
        if (this.myNodeController.rootRenderNode !== null) {
          // appendChild在renderNode最后一个子节点后添加新的子节点
          this.myNodeController.addNode(this.currentNode);
        }
        break;
      }
      case TouchType.Move: {
        if (this.currentNode !== null) {
          // 手指移动，绘制移动轨迹
          this.currentNode.path.lineTo(positionX, positionY);
          // 节点的path更新后需要调用invalidate()方法触发重新渲染
          this.currentNode.invalidate();
        }
        break;
      }
      case TouchType.Up: {
        // 手指抬起，释放this.currentNode
        this.currentNode = null;
      }
      default: {
        break;
      }
    }
  }

  // 顶部取消、保存按钮模块，仅作UX展示
  @Builder
  topButtonLine() {
    Row() {
      Image($r('app.media.palette_public_cancel_filled'))
        .width($r('app.integer.palette_top_button_size'))
        .height($r('app.integer.palette_top_button_size'))
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.palette_toast'),
            alignment: Alignment.Center
          })
        })
      Image($r('app.media.palette_public_ok_filled'))
        .width($r('app.integer.palette_top_button_size'))
        .height($r('app.integer.palette_top_button_size'))
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.palette_toast'),
            alignment: Alignment.Center
          })
        })
    }
    .width($r('app.string.palette_full_size'))
    .height($r('app.integer.palette_top_button_line_height'))
    .padding({
      left: $r('app.string.palette_card_padding_start'),
      right: $r('app.string.palette_card_padding_start')
    })
    .backgroundColor($r('app.color.palette_top_and_bottom_line_background_color'))
    .alignRules({
      top: { anchor: Constants.CONTAINER_ID, align: VerticalAlign.Top },
      left: { anchor: Constants.CONTAINER_ID, align: HorizontalAlign.Start }
    })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .id(Constants.TOP_BUTTON_LINE_ID)
  }

  // 底部画笔模块，展示已选中画笔颜色和常用颜色
  @Builder
  bottomPenShape() {
    Row() {
      Column() {
        Image($r('app.media.palette_screenshot_penshape'))
          .width($r('app.integer.palette_pen_shape_icon_size'))
          .height($r('app.integer.palette_pen_shape_icon_size'))
        Text($r('app.string.palette_pen_shape_text'))
          .fontSize($r('app.string.palette_text_size_body1'))
          .fontColor($r('app.color.palette_pen_shape_text_color'))
          .margin({ top: $r('app.integer.palette_pen_shape_text_margin_top') })
      }

      Divider()
        .vertical(true)
        .strokeWidth(Constants.DIVIDER_STROKE_WIDTH)
        .color($r('app.color.palette_divider_color'))
        .margin({ left: $r('app.integer.palette_divider_margin'), right: $r('app.integer.palette_divider_margin') })
        .height($r('app.integer.palette_bottom_pen_shape_content_height'))

      // 展示当前选中的画笔颜色
      Row()
        .id('selectedColor')
        .backgroundColor(this.selectedColor)
        .width($r('app.integer.palette_pen_color_circle_size'))
        .height($r('app.integer.palette_pen_color_circle_size'))
        .borderRadius($r('app.integer.palette_pen_color_circle_border_radius'))
        .border({
          width: $r('app.integer.palette_pen_color_circle_border_width'),
          color: $r('app.color.palette_pen_color_circle_border_color')
        })
        .margin({ right: $r('app.integer.palette_pen_color_circle_margin_right') })
        .onClick(() => {
          // 点击切换调色板的显隐
          this.isShowPalette = !this.isShowPalette;
        })

      // 预设的常用颜色
      Grid() {
        /**
         * TODO: 性能知识点：此处列表项确定且数量较少，使用了ForEach，在列表项多的情况下，推荐使用LazyForeEach
         * 文档参考链接：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-rendering-control-lazyforeach-0000001820879609
         */
        ForEach(this.hexHues, (color: string, index: number) => {
          GridItem() {
          }
          .id(`presetColor${index}`)
          .border({
            width: this.selectedColor === color ? $r('app.integer.palette_color_block_border_width_selected') :
            $r('app.integer.palette_color_block_border_width'),
            color: $r('app.color.palette_color_background'),
            radius: $r('app.integer.palette_common_color_block_border_radius')
          })
          .backgroundColor(color)
          .width($r('app.string.palette_full_size'))
          .height($r('app.string.palette_full_size'))
          .onClick(() => {
            // 点击切换选中颜色
            this.selectedColor = color;
          })
        }, (color: string) => color)
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr') // 6列
      .rowsTemplate('1fr 1fr') // 2行
      .columnsGap($r('app.integer.palette_common_color_block_gird_gap'))
      .rowsGap($r('app.integer.palette_common_color_block_gird_gap'))
      .padding({
        left: $r('app.string.palette_card_padding_start'),
        right: $r('app.string.palette_card_padding_start')
      })
      .height($r('app.integer.palette_bottom_pen_shape_content_height'))
      .width($r('app.integer.palette_common_color_block_gird_width'))
    }
    .width($r('app.string.palette_full_size'))
    .padding($r('app.string.palette_card_padding_start'))
    .backgroundColor($r('app.color.palette_top_and_bottom_line_background_color'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .alignRules({
      bottom: { anchor: Constants.CONTAINER_ID, align: VerticalAlign.Bottom },
      left: { anchor: Constants.CONTAINER_ID, align: HorizontalAlign.Start }
    })
    .alignItems(VerticalAlign.Center)
    .id(Constants.BOTTOM_PEN_SHAPE_ID)
  }

  // 画笔绘制区域
  @Builder
  drawingArea() {
    Image($r('app.media.palette_picture'))
      .width($r('app.string.palette_full_size'))
      .objectFit(ImageFit.Contain)
      .alignRules({
        top: { anchor: Constants.TOP_BUTTON_LINE_ID, align: VerticalAlign.Bottom },
        middle: { anchor: Constants.CONTAINER_ID, align: HorizontalAlign.Center },
        bottom: { anchor: Constants.BOTTOM_PEN_SHAPE_ID, align: VerticalAlign.Top }
      })
      .onComplete((event) => {
        if (event !== undefined) {
          // NodeContainer的宽高设置为图片成功加载后实际绘制的尺寸
          this.nodeContainerWidth = px2vp(event.contentWidth);
          this.nodeContainerHeight = px2vp(event.contentHeight);
        }
      })
    NodeContainer(this.myNodeController)
      .width(this.nodeContainerWidth)
      .height(this.nodeContainerHeight)
      .alignRules({
        top: { anchor: Constants.TOP_BUTTON_LINE_ID, align: VerticalAlign.Bottom },
        middle: { anchor: Constants.CONTAINER_ID, align: HorizontalAlign.Center },
        bottom: { anchor: Constants.BOTTOM_PEN_SHAPE_ID, align: VerticalAlign.Top }
      })// TODO: 性能知识点: onTouch是系统高频回调函数，避免在函数中进行冗余或耗时操作，例如应该减少或避免在函数打印日志，会有较大的性能损耗。
      .onTouch((event: TouchEvent) => {
        this.onTouchEvent(event);
      })
  }

  build() {
    RelativeContainer() {
      // 顶部取消、保存按钮模块，仅作UX展示
      this.topButtonLine()

      // 绘制区域
      this.drawingArea()

      // 调色板区域，使用 isShowPalette 控制显隐
      if (this.isShowPalette) {
        Row() {
          HslPalette({
            hslHues: this.hslHues,
            levels: this.levels,
            gradientStartPoint: Constants.GRADIENT_START_POINT,
            gradientEndPoint: Constants.GRADIENT_END_POINT,
            selectedColor: this.selectedColor
          })
            .id('palette')
        }
        .width($r('app.string.palette_hsl_palette_container_width'))
        .height($r('app.integer.palette_hsl_palette_container_height'))
        .backgroundColor($r('app.color.palette_hsl_palette_container_background_color'))
        .padding($r('app.string.palette_card_padding_start'))
        .borderRadius($r('app.string.palette_corner_radius_default_m'))
        .alignRules({
          bottom: { anchor: Constants.BOTTOM_PEN_SHAPE_ID, align: VerticalAlign.Top },
          left: { anchor: Constants.CONTAINER_ID, align: HorizontalAlign.Start }
        })
        .margin({
          bottom: $r('app.integer.palette_hsl_palette_container_margin'),
          left: $r('app.integer.palette_hsl_palette_container_margin')
        })
      }

      // 底部画笔模块，展示已选中画笔颜色和常用颜色
      this.bottomPenShape()
    }
    .height($r('app.string.palette_full_size'))
    .width($r('app.string.palette_full_size'))
    .backgroundColor($r('app.color.palette_color_foreground'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}


/**
 * HslPalette 组件是一个基于 HSL 颜色模型的调色板组件，允许用户通过选择不同的色相来浏览渐变颜色，并从中选择特定的颜色。
 *
 * 使用时需要传入属性hslHues、levels、gradientStartPoint和gradientEndPoint生成渐变调色板，
 * 并通过@Link类型的状态变量selectedColor与父组件同步点击选中的颜色。
 */
@Component
struct HslPalette {
  @State columnsTemplate: string = ''; // Gird 组件的columnsTemplate
  @State rowsTemplate: string = ''; // Gird 组件的rowsTemplate
  @State colors: string[] = []; // 栅格布局使用的 HEX 颜色数组
  @Link selectedColor: string; // 当前选中的颜色
  private hslHues: HslType[] = []; // HSL 类型颜色的源数组
  private levels: number = 0; // 渐变色阶数
  private gradientStartPoint: number = 0; // 渐变开始点的亮度值
  private gradientEndPoint: number = 0; // 渐变结束点的亮度值

  aboutToAppear(): void {
    // 初始化 Grid 模板
    this.initGridTemplate();
    // 计算 HSL 渐变颜色，并更新颜色数组
    this.colors = this.computeHSLGradient(this.hslHues, this.levels);
  }

  // 根据色相数和色阶数初始化Gird的columnsTemplate和rowsTemplate
  initGridTemplate() {
    if (this.hslHues.length === 0) {
      this.columnsTemplate = '';
      this.rowsTemplate = '';
      return;
    }
    let rowsTemplate = '';
    // 初始化列模板
    this.columnsTemplate = this.hslHues.map(hsl => Constants.GRID_TEMPLATE_UINT).join(' ');
    // 初始化行模板
    for (let i = 0; i < this.levels; i++) {
      if (i === 0) {
        rowsTemplate = Constants.GRID_TEMPLATE_UINT;
      } else {
        rowsTemplate = `${rowsTemplate} ${Constants.GRID_TEMPLATE_UINT}`;
      }
    }
    this.rowsTemplate = rowsTemplate;
  }

  // TODO：知识点：根据 HSL 色相数组和色阶数生成按亮度渐变的 HEX 格式颜色
  computeHSLGradient(hues: HslType[], levels: number): string[] {
    if (levels <= 0) {
      return [];
    }
    const colors: string[] = [];
    for (let i = 0; i < levels; i++) {
      hues.forEach(hsl => {
        // 根据给定的渐变亮度起止点和所处色阶计算渐变亮度
        const fadedL =
          this.gradientStartPoint + Math.round(i * (this.gradientEndPoint - this.gradientStartPoint) / levels); // 逐渐变淡
        // 将 HSL 转换为 HEX 格式
        const hex = hslToHex(hsl.hue, hsl.saturation, fadedL);
        // 添加到颜色数组
        colors.push(hex);
      });
    }
    return colors;
  }

  build() {
    Grid() {
      /**
       * TODO: 性能知识点：此处列表项确定且数量较少，使用了ForEach，在列表项多的情况下，推荐使用LazyForeEach
       * 文档参考链接：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-rendering-control-lazyforeach-0000001820879609
       */
      ForEach(this.colors, (color: string) => {
        GridItem() {
        }
        .border({
          width: this.selectedColor === color ? $r('app.integer.palette_color_block_border_width_selected') :
          $r('app.integer.palette_color_block_border_width'),
          color: $r('app.color.palette_color_background')
        })
        .backgroundColor(color)
        .width($r('app.string.palette_full_size'))
        .height($r('app.string.palette_full_size'))
        .onClick(() => {
          // 点击切换选中颜色
          this.selectedColor = color;
        })
      }, (color: string) => color)
    }
    .columnsTemplate(this.columnsTemplate)
    .rowsTemplate(this.rowsTemplate)
    .width($r('app.string.palette_full_size'))
    .height($r('app.string.palette_full_size'))
  }
}