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

import {
  BarChart, // 柱状图图表类
  BarChartModel, // 柱状图配置构建类
  BarData, // 柱状图数据包
  BarDataSet, // 柱状图数据集合
  BarEntry, // 柱状图数据结构
  ChartGesture, // 手势事件模式
  Description, // 图表Description(描述)部件
  EntryOhos, // 图表数据结构基础类
  Fill, // 图表填充类型构建类
  Highlight, // 图表高亮数据
  IBarDataSet, // 柱状图数据集合的操作类
  JArrayList, // 工具类：数据集合
  Legend, // 图表Legend(图例)部件
  LimitLabelPosition, // 图表的LimitLine标签位置枚举类
  LimitLine, // 图表LimitLine
  MarkerView, // 图表的Marker(标志气泡)部件
  OnChartGestureListener, // 手势事件监听
  OnChartValueSelectedListener, // 数据选择监听
  XAxis, // 图表X轴部件
  XAxisPosition, // 图表X轴标签位置枚举类
  YAxis, // 图表Y轴部件
  YAxisLabelPosition // 图表Y轴标签位置枚举类
} from '@ohos/mpchart';
import { AppRouter } from 'routermodule';
import CustomMarkerView from './CustomMarkerView';
import { emitter } from '@kit.BasicServicesKit';

const TEXT_OPACITY: number = 0.6;
const TEXT_FONT_WEIGHT: number = 500;

@AppRouter({ name: "barchart/BarChartPage" })
@Component
export struct BarChartPage {
  private model: BarChartModel | null = null; // 柱状图配置构建类
  private leftAxis: YAxis | null = null; // 图表左Y轴信息
  private rightAxis: YAxis | null = null; // 图表右Y轴信息
  private xAxis: XAxis | null = null; // 图表X轴位置
  private limitLine1: LimitLine | null = null; // 限制线
  private limitLine2: LimitLine | null = null; // 限制线
  private data: BarData | null = null; // 柱状图数据
  private mMaxVisibleXCount: number = 20; // 图表最大的X轴显示范围
  private normalMarker: CustomMarkerView | null = null; // 自定义图表markerView标记视图
  @State isEnableXPosition: boolean = true; // 是否使能X轴位置
  @State isEnableLeftYAxis: boolean = true; // 是否使能左Y轴
  @State isEnableRightYAxis: boolean = false; // 是否使能右Y轴
  @State xPosition: string[] = ['Top', 'Bottom', 'Both Side', 'Top InSide', 'Bottom InSide']; // X轴位置
  @State xPositionIndex: number = 1; // 初始X轴位置，这里指Bottom
  @State yAxisLeftPosition: string = 'leftYAxisOutSide'; // 左Y轴当前设置的值
  @State yAxisRightPosition: string = 'RightYAxisOutSide'; // 右Y轴当前设置的值
  @State limitLinePosition: string = 'Both'; // 左Y轴LimitLine当前设置的值
  @State toggleFlag: boolean = false; // 左Y轴LimitLine是否在数据后标志位
  // 构造数据选择监听器
  private valueSelectedListener: OnChartValueSelectedListener = {
    onValueSelected: (e: EntryOhos, h: Highlight) => {
      console.info("ScrollBarChartPage onValueSelected: " + e.getX());
    },
    onNothingSelected: () => {
      console.info("ScrollBarChartPage onNothingSelected");
    }
  }
  // 为图表添加手势识别监听器
  private chartGestureListener: OnChartGestureListener = {
    onChartGestureStart: (isTouchEvent: boolean, me: TouchEvent | GestureEvent, lastPerformedGestureMode: ChartGesture) => {
      console.info("-----------------chartGestureListener onChartGestureStart lastMode: " + lastPerformedGestureMode);
    },
    onChartGestureEnd: (isTouchEvent: boolean, me: TouchEvent | GestureEvent, lastPerformedGestureMode: ChartGesture) => {
      console.info("-----------------chartGestureListener onChartGestureEnd lastMode: " + lastPerformedGestureMode);
    },
    onChartLongPressed: (isTouchEvent: boolean, me: TouchEvent | GestureEvent) => {
      console.info("-----------------chartGestureListener onChartLongPressed");
    },
    onChartDoubleTapped: (isTouchEvent: boolean, me: TouchEvent | GestureEvent) => {
      console.info("-----------------chartGestureListener onChartDoubleTapped");
    },
    onChartSingleTapped: (isTouchEvent: boolean, me: TouchEvent | GestureEvent) => {
      console.info("-----------------chartGestureListener onChartSingleTapped");
    },
    onChartFling: (isTouchEvent: boolean, me1: TouchEvent | GestureEvent, me2: TouchEvent, velocityX: number, velocityY: number) => {
      console.info("-----------------chartGestureListener onChartFling velocityX: " + velocityX + "  velocityY: " + velocityY);
    },
    onChartScale: (isTouchEvent: boolean, me: TouchEvent | GestureEvent, scaleX: number, scaleY: number) => {
      console.info("-----------------chartGestureListener onChartScale scaleX: " + scaleX + "  scaleY: " + scaleY);
    },
    onChartTranslate: (isTouchEvent: boolean, me: TouchEvent | GestureEvent, dX: number, dY: number) => {
      console.info("-----------------chartGestureListener onChartTranslate dx: " + dX + "  dy: " + dY);
    },
    onChartMove: (isTouchEvent: boolean, me: TouchEvent | GestureEvent) => {
      console.info("-----------------chartGestureListener onChartTranslate moved ");
    }
  }

  // 图表数据初始化
  aboutToAppear() {
    // TODO 知识点：必须初始化图表配置构建类
    this.model = new BarChartModel();
    // TODO 知识点：配置图表指定样式，为图表添加数据选择的监听器。
    this.model.setOnChartValueSelectedListener(this.valueSelectedListener);
    // 为图表添加手势识别监听器
    this.model.setOnChartGestureListener(this.chartGestureListener);
    // 获取图表描述部件，设置图表描述部件不可用，即图表不进行绘制描述部件
    const description: Description | null = this.model.getDescription();
    if (description) {
      description.setEnabled(false);
    }
    // 获取图表图例部件，设置图表图例部件不可用
    const legend: Legend | null = this.model.getLegend();
    if (legend) {
      legend.setEnabled(true);
    }
    // 禁用x和y轴方向同时缩放，但是可以单独x轴方向或者y轴方向缩放
    this.model.setPinchZoom(false);
    // 禁用缩放，可禁止单独x轴方向或者y轴方向缩放
    this.model.setScaleEnabled(false);
    // 设置是否支持双击放大
    this.model.setDoubleTapToZoomEnabled(false);
    // 启用绘制网格背景
    this.model.setDrawGridBackground(false);
    // 设置网格背景颜色
    this.model.setGridBackgroundColor('#500000ff');
    // 设置不绘制柱状图的柱体阴影背景
    this.model.setDrawBarShadow(false);
    // 设置柱状图的高亮范围是否为整个柱体，只在堆叠柱状图中有区别
    this.model.setHighlightFullBarEnabled(false);
    // 为左Y轴设置LimitLine,可设置限制线的宽度，线段样式，限制标签的位置，标签字体大小等
    this.limitLine1 = new LimitLine(80, 'Upper Limit');
    this.limitLine1.setLineWidth(4);
    this.limitLine1.enableDashedLine(10, 10, 0);
    this.limitLine1.setLabelPosition(LimitLabelPosition.RIGHT_TOP);
    this.limitLine1.setTextSize(vp2px(5));

    this.limitLine2 = new LimitLine(30, 'Lower Limit');
    this.limitLine2.setLineWidth(4);
    this.limitLine2.enableDashedLine(10, 10, 0);
    this.limitLine2.setLineColor(Color.Yellow);
    this.limitLine2.setLabelPosition(LimitLabelPosition.RIGHT_BOTTOM);
    this.limitLine2.setTextSize(vp2px(5));

    // 设置图表左Y轴信息
    this.leftAxis = this.model.getAxisLeft();
    if (this.leftAxis) {
      this.leftAxis.setAxisMinimum(0);
      this.leftAxis.setDrawLimitLinesBehindData(false);

      // 添加LimitLines
      this.leftAxis.addLimitLine(this.limitLine1);
      this.leftAxis.addLimitLine(this.limitLine2);
    }
    // 设置图表右Y轴信息
    this.rightAxis = this.model.getAxisRight();
    if (this.rightAxis) {
      this.rightAxis.setEnabled(false);
      this.rightAxis.setAxisMinimum(0);
    }
    // 设置X轴信息
    this.xAxis = this.model.getXAxis();
    if (this.xAxis) {
      this.xAxis.setPosition(XAxisPosition.BOTTOM);
    }
    // 为图表设置markerView
    this.normalMarker = new CustomMarkerView();
    this.model.setMarker(this.normalMarker);
    // 生成单一颜色数据
    this.data = this.getNormalData();
    // TODO 知识点：将数据与图表配置类绑定
    this.model.setData(this.data);
    // 设置图表最大的X轴显示范围，如不设置，则默认显示全部数据
    this.model.setVisibleXRangeMaximum(this.mMaxVisibleXCount);
  }

  // 生成单一颜色数据
  private getNormalData(): BarData {
    const values: JArrayList<BarEntry> = new JArrayList<BarEntry>();
    values.add(new BarEntry(1, 73.3));
    values.add(new BarEntry(2, 5.4));
    values.add(new BarEntry(3, 73.9));
    values.add(new BarEntry(4, 79.9));
    values.add(new BarEntry(5, 69.3));
    values.add(new BarEntry(6, 70.7));
    values.add(new BarEntry(7, 81.2));
    values.add(new BarEntry(8, 13.1));
    values.add(new BarEntry(9, 34.2));
    values.add(new BarEntry(10, 58.4));
    values.add(new BarEntry(11, 44.7));
    values.add(new BarEntry(12, 10.5));
    values.add(new BarEntry(13, 15.6));
    values.add(new BarEntry(14, 95.8));
    values.add(new BarEntry(15, 57.4));
    values.add(new BarEntry(16, 64.5));
    values.add(new BarEntry(17, 21.4));
    values.add(new BarEntry(18, 33.2));
    values.add(new BarEntry(19, 96.9));

    const dataSet: BarDataSet = new BarDataSet(values, 'DataSet');
    dataSet.setHighLightColor(Color.Black);
    dataSet.setDrawIcons(false);
    // 为柱体添加颜色信息
    dataSet.setColorByColor(Color.Pink);

    const dataSetList: JArrayList<IBarDataSet> = new JArrayList<IBarDataSet>();
    dataSetList.add(dataSet);

    const barData: BarData = new BarData(dataSetList);
    barData.setBarWidth(0.85);
    return barData;
  }

  // 生成渐变颜色数据
  private getGradientData(): BarData {
    const values: JArrayList<BarEntry> = new JArrayList<BarEntry>();
    values.add(new BarEntry(1, 32.9));
    values.add(new BarEntry(2, 44.7));
    values.add(new BarEntry(3, 2.1));
    values.add(new BarEntry(4, 46.9));
    values.add(new BarEntry(5, 8.8));
    values.add(new BarEntry(6, 82.1));
    values.add(new BarEntry(7, 86.9));
    values.add(new BarEntry(8, 15.9));
    values.add(new BarEntry(9, 29.4));
    values.add(new BarEntry(10, 71.6));
    values.add(new BarEntry(11, 55.7));
    values.add(new BarEntry(12, 35.8));
    values.add(new BarEntry(13, 67.7));
    values.add(new BarEntry(14, 34.9));
    values.add(new BarEntry(15, 50.9));
    values.add(new BarEntry(16, 40.5));
    values.add(new BarEntry(17, 27.1));
    values.add(new BarEntry(18, 45.7));
    values.add(new BarEntry(19, 26.8));

    const dataSet: BarDataSet = new BarDataSet(values, 'DataSet');
    dataSet.setHighLightColor(Color.Black);
    dataSet.setDrawIcons(false);
    const START_COLOR1: string = '#ffffbb33';
    const START_COLOR2: string = '#ff33b5e5';
    const START_COLOR3: string = '#ffffbb33';
    const START_COLOR4: string = '#ff99cc00';
    const START_COLOR5: string = '#ffff4444';
    const END_COLOR1: string = '#ff0099cc';
    const END_COLOR2: string = '#ffaa66cc';
    const END_COLOR3: string = '#ff669900';
    const END_COLOR4: string = '#ffcc0000';
    const END_COLOR5: string = '#ffff8800';
    const gradientFills: JArrayList<Fill> = new JArrayList<Fill>();
    gradientFills.add(new Fill(START_COLOR1, END_COLOR1));
    gradientFills.add(new Fill(START_COLOR2, END_COLOR2));
    gradientFills.add(new Fill(START_COLOR3, END_COLOR3));
    gradientFills.add(new Fill(START_COLOR4, END_COLOR4));
    gradientFills.add(new Fill(START_COLOR5, END_COLOR5));
    // 为柱体添加渐变的颜色信息
    dataSet.setFills(gradientFills);

    const dataSetList: JArrayList<IBarDataSet> = new JArrayList<IBarDataSet>();
    dataSetList.add(dataSet);

    const barData: BarData = new BarData(dataSetList);
    barData.setBarWidth(0.85);
    return barData;
  }

  // 生成堆叠颜色数据
  private getStackData(): BarData {
    const values: JArrayList<BarEntry> = new JArrayList<BarEntry>();
    values.add(new BarEntry(1, [38.0, 28.0, 39.8]));
    values.add(new BarEntry(2, [18.2, 16.1, 16.1]));
    values.add(new BarEntry(3, [45.8, 49.8, 26.7]));
    values.add(new BarEntry(4, [36.5, 43.8, 15.1]));
    values.add(new BarEntry(5, [51.5, 35.4, 24.1]));
    values.add(new BarEntry(6, [44.9, 21.4, 15.9]));
    values.add(new BarEntry(7, [32.9, 40.4, 32.7]));
    values.add(new BarEntry(8, [24.3, 31.0, 47.1]));
    values.add(new BarEntry(9, [17.4, 48.4, 49.6]));
    values.add(new BarEntry(10, [32.0, 29.8, 20.0]));
    values.add(new BarEntry(11, [43.9, 52.7, 27.7]));
    values.add(new BarEntry(12, [28.4, 46.2, 51.8]));
    values.add(new BarEntry(13, [42.6, 51.9, 44.0]));
    values.add(new BarEntry(14, [14.8, 22.4, 31.2]));
    values.add(new BarEntry(15, [50.3, 18.7, 18.3]));
    values.add(new BarEntry(16, [20.7, 22.9, 40.2]));
    values.add(new BarEntry(17, [49.4, 38.3, 41.7]));
    values.add(new BarEntry(18, [45.9, 40.7, 29.5]));
    values.add(new BarEntry(19, [37.1, 31.8, 42.9]));

    let dataSet: BarDataSet | null = null;
    dataSet = new BarDataSet(values, "Statistics Vienna 2014");
    dataSet.setDrawIcons(false);
    // 为柱体添加指定分段的颜色信息
    dataSet.setColorsByArr([Color.Red, Color.Green, Color.Pink]);
    dataSet.setStackLabels(["Births", "Divorces", "Marriages"]);

    const dataSets: JArrayList<IBarDataSet> = new JArrayList<IBarDataSet>();
    dataSets.add(dataSet);

    const data: BarData = new BarData(dataSets);
    data.setValueTextColor(Color.White);
    return data;
  }

  private refresh(): void {
    if (this.model) {
      this.model.notifyDataSetChanged();
      this.model.invalidate();
    }
  }

  @Builder
  xPositionMenu() {
    Column() {
      ForEach(this.xPosition, (item: string, index: number) => {
        Column() {
          Flex({
            direction: FlexDirection.Row,
            justifyContent: FlexAlign.SpaceBetween,
            alignItems: ItemAlign.Center
          }) {
            Text(item)
              .fontSize($r('app.integer.bar_chart_menu_text_size'))
              .fontWeight(TEXT_FONT_WEIGHT)
            Image($r('app.media.bar_chart_ok'))
              .visibility(this.xPositionIndex === index ? Visibility.Visible : Visibility.Hidden)
              .width($r('app.integer.bar_chart_menu_image_size'))
              .height($r('app.integer.bar_chart_menu_image_size'))
          }
          .height($r('app.integer.bar_chart_menu_item_height'))

          Divider()
            .visibility(index !== 3 ? Visibility.Visible : Visibility.Hidden)
            .width('100%')
        }
        .width($r('app.integer.bar_chart_menu_item_width'))
        .onClick(() => {
          this.xPositionIndex = index;
          if (this.xAxis) {
            switch (item) {
              case 'Top':
                this.xAxis.setPosition(XAxisPosition.TOP);
                break;
              case 'Bottom':
                this.xAxis.setPosition(XAxisPosition.BOTTOM);
                break;
              case 'Both Side':
                this.xAxis.setPosition(XAxisPosition.BOTH_SIDED);
                break;
              case 'Top InSide':
                this.xAxis.setPosition(XAxisPosition.TOP_INSIDE);
                break;
              case 'Bottom InSide':
                this.xAxis.setPosition(XAxisPosition.BOTTOM_INSIDE);
                break;
            }
            this.refresh();
          }
        })
      })
    }
    .borderRadius($r('app.integer.bar_chart_menu_border_radius'))
    .backgroundColor(Color.White)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width($r('app.integer.bar_chart_menu_width'))
  }

  build() {
    Column() {
      // TODO 知识点：为组件设置配置构建类。可通过在事件中使用this.model.notifyDataSetChanged()触发坐标轴数据更新。通过在事件中使用this.model.invalidate()触发绘制更新。
      BarChart({ model: this.model })
        .width('100%')
        .height($r('app.integer.bar_chart_height'))
        .backgroundColor(Color.White)
        .margin({
          top: $r('app.integer.bar_chart_border_padding'),
          bottom: $r('app.integer.bar_chart_border_padding'),
        })

      Scroll() {
        Column() {
          Column() {
            Text($r('app.string.bar_chart_control_data_type'))
              .fontSize($r('app.integer.bar_chart_list_small_text_size'))
              .opacity(TEXT_OPACITY)
              .fontColor(Color.Black)
              .fontWeight(TEXT_FONT_WEIGHT)
          }
          .justifyContent(FlexAlign.End)
          .margin({ left: $r('app.integer.bar_chart_list_small_text_margin') })
          .height($r('app.integer.bar_chart_list_small_text_height'))

          Column() {
            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text($r('app.string.bar_chart_control_normal'))
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Radio({ value: 'normal', group: 'dataType' })
                  .width($r('app.integer.bar_chart_list_checkbox_size'))
                  .height($r('app.integer.bar_chart_list_checkbox_size'))
                  .checked(true)
                  .id('normal')
                  .onChange((isChecked: boolean) => {
                    if (isChecked) {
                      this.data = this.getNormalData();
                      if (this.model) {
                        if (this.normalMarker) {
                          this.model.setMarker(this.normalMarker);
                        }
                        this.model.setData(this.data);
                      }
                    }
                  })
              }
              .height($r('app.integer.bar_chart_list_item_height'))

              Divider()
                .width('100%')
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })

            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text($r('app.string.bar_chart_control_gradient'))
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Radio({ value: 'gradient', group: 'dataType' })
                  .width($r('app.integer.bar_chart_list_checkbox_size'))
                  .height($r('app.integer.bar_chart_list_checkbox_size'))
                  .checked(false)
                  .id('gradient')
                  .onChange((isChecked: boolean) => {
                    if (isChecked) {
                      this.data = this.getGradientData();
                      if (this.model) {
                        if (this.normalMarker) {
                          this.model.setMarker(this.normalMarker);
                        }
                        this.model.setData(this.data);
                      }
                    }
                  })
              }
              .height($r('app.integer.bar_chart_list_item_height'))

              Divider()
                .width('100%')
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })

            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text($r('app.string.bar_chart_control_stack'))
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Radio({ value: 'stack', group: 'dataType' })
                  .width($r('app.integer.bar_chart_list_checkbox_size'))
                  .height($r('app.integer.bar_chart_list_checkbox_size'))
                  .checked(false)
                  .id('stack')
                  .onChange((isChecked: boolean) => {
                    if (isChecked) {
                      this.data = this.getStackData();
                      if (this.model) {
                        this.model.setData(this.data);
                      }
                    }
                    let stackChecked = isChecked;
                    emitter.emit({ eventId: 0, priority: 0 }, {
                      data: {
                        stackChecked: stackChecked
                      }
                    });
                  })
              }
              .height($r('app.integer.bar_chart_list_item_height'))
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })
          }
          .padding({
            top: $r('app.integer.bar_chart_list_card_padding'),
            bottom: $r('app.integer.bar_chart_list_card_padding')
          })
          .margin({ top: $r('app.integer.bar_chart_list_card_margin') })
          .borderRadius($r('app.integer.bar_chart_list_card_border_radius'))
          .backgroundColor(Color.White)
          .alignItems(HorizontalAlign.Start)
          .width('100%')

          Column() {
            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text($r('app.string.bar_chart_control_XAxis_location'))
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Row() {
                  Text(this.xPosition[this.xPositionIndex])
                    .fontSize($r('app.integer.bar_chart_list_small_text_size'))
                    .fontWeight(400)
                    .fontColor(Color.Black)
                    .opacity(TEXT_OPACITY)

                  Image($r('app.media.bar_chart_spinner'))
                    .width($r('app.integer.bar_chart_spinner_width'))
                    .height($r('app.integer.bar_chart_menu_text_size'))
                    .opacity(0.4)
                    .margin({ left: $r('app.integer.bar_chart_list_card_margin') })
                }
                .id('xAxisLocation')
                .bindMenu(this.xPositionMenu())
              }
              .height($r('app.integer.bar_chart_list_item_height'))
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })
          }
          .padding({
            top: $r('app.integer.bar_chart_list_card_padding'),
            bottom: $r('app.integer.bar_chart_list_card_padding')
          })
          .margin({ top: $r('app.integer.bar_chart_list_item_padding') })
          .borderRadius($r('app.integer.bar_chart_list_card_border_radius'))
          .backgroundColor(Color.White)
          .alignItems(HorizontalAlign.Start)
          .width('100%')

          Column() {
            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text($r('app.string.bar_chart_control_XAxis_is_display'))
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Toggle({ type: ToggleType.Switch, isOn: true })
                  .selectedColor('#0A59F7')
                  .id('xAxisToggle')
                  .onChange((isChecked: boolean) => {
                    if (this.xAxis) {
                      this.xAxis.setEnabled(isChecked);
                      this.isEnableXPosition = isChecked;
                      this.refresh();
                    }
                    let xAxisChecked = isChecked;
                    emitter.emit({ eventId: 0, priority: 0 }, {
                      data: {
                        xAxisChecked: xAxisChecked
                      }
                    });
                  })
              }
              .height($r('app.integer.bar_chart_list_item_height'))
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })
          }
          .padding({
            top: $r('app.integer.bar_chart_list_card_padding'),
            bottom: $r('app.integer.bar_chart_list_card_padding')
          })
          .margin({ top: $r('app.integer.bar_chart_list_item_padding') })
          .borderRadius($r('app.integer.bar_chart_list_card_border_radius'))
          .backgroundColor(Color.White)
          .alignItems(HorizontalAlign.Start)
          .width('100%')

          Column() {
            Text($r('app.string.bar_chart_control_left_YAxis_sheet'))
              .fontSize($r('app.integer.bar_chart_list_small_text_size'))
              .opacity(TEXT_OPACITY)
              .fontColor(Color.Black)
              .fontWeight(TEXT_FONT_WEIGHT)
          }
          .justifyContent(FlexAlign.End)
          .margin({ left: $r('app.integer.bar_chart_list_item_padding') })
          .height($r('app.integer.bar_chart_list_small_text_height'))

          Column() {
            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text($r('app.string.bar_chart_control_leftYAxis_is_display'))
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Toggle({ type: ToggleType.Switch, isOn: true })
                  .selectedColor('#0A59F7')
                  .id('leftYAxisToggle')
                  .onChange((isChecked: boolean) => {
                    if (this.leftAxis) {
                      this.leftAxis.setEnabled(isChecked);
                      this.isEnableLeftYAxis = isChecked;
                      this.refresh();
                    }
                    let leftYAxisChecked = isChecked;
                    emitter.emit({ eventId: 0, priority: 0 }, {
                      data: {
                        leftYAxisChecked: leftYAxisChecked
                      }
                    });
                  })
              }
              .height($r('app.integer.bar_chart_list_item_height'))
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })
          }
          .padding({
            top: $r('app.integer.bar_chart_list_card_padding'),
            bottom: $r('app.integer.bar_chart_list_card_padding')
          })
          .margin({ top: $r('app.integer.bar_chart_list_item_padding') })
          .borderRadius($r('app.integer.bar_chart_list_card_border_radius'))
          .backgroundColor(Color.White)
          .alignItems(HorizontalAlign.Start)
          .width('100%')

          Column() {
            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text($r('app.string.bar_chart_control_leftYAxis_sheet_outside'))
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Radio({ value: 'outSideChart', group: 'leftYAxisLabelPosition' })
                  .checked(this.yAxisLeftPosition === 'leftYAxisOutSide' ? true : false)
                  .enabled(this.isEnableLeftYAxis)
                  .id('outSideChart')
                  .onChange((isChecked: boolean) => {
                    if (this.leftAxis && isChecked) {
                      this.yAxisLeftPosition = 'leftYAxisOutSide';
                      this.leftAxis.setPosition(YAxisLabelPosition.OUTSIDE_CHART);
                      this.refresh();
                    }
                  })
              }
              .height($r('app.integer.bar_chart_list_item_height'))

              Divider()
                .width('100%')
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })

            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text($r('app.string.bar_chart_control_leftYAxis_sheet_inside'))
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Radio({ value: 'inSideChart', group: 'leftYAxisLabelPosition' })
                  .checked(this.yAxisLeftPosition === 'leftYAxisInSide' ? true : false)
                  .enabled(this.isEnableLeftYAxis)
                  .id('inSideChart')
                  .onChange((isChecked: boolean) => {
                    if (this.leftAxis && isChecked) {
                      this.yAxisLeftPosition = 'leftYAxisInSide';
                      this.leftAxis.setPosition(YAxisLabelPosition.INSIDE_CHART);
                      this.refresh();
                    }
                    let inSideChartChecked = isChecked;
                    emitter.emit({ eventId: 0, priority: 0 }, {
                      data: {
                        inSideChartChecked: inSideChartChecked
                      }
                    });
                  })
              }
              .height($r('app.integer.bar_chart_list_item_height'))
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })
          }
          .padding({
            top: $r('app.integer.bar_chart_list_card_padding'),
            bottom: $r('app.integer.bar_chart_list_card_padding')
          })
          .margin({ top: $r('app.integer.bar_chart_list_item_padding') })
          .borderRadius($r('app.integer.bar_chart_list_card_border_radius'))
          .backgroundColor(Color.White)
          .alignItems(HorizontalAlign.Start)
          .width('100%')

          Column() {
            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text($r('app.string.bar_chart_control_is_show_limitline_behinddata'))
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Toggle({ type: ToggleType.Switch, isOn: $$this.toggleFlag })
                  .selectedColor('#007DFF')
                  .enabled(this.isEnableLeftYAxis)
                  .id('isShowLimitLine')
                  .onChange((isChecked: boolean) => {
                    if (this.leftAxis) {
                      this.leftAxis.setDrawLimitLinesBehindData(isChecked);
                      this.refresh();
                    }
                    let isShowLimitLineChecked = isChecked;
                    emitter.emit({ eventId: 0, priority: 0 }, {
                      data: {
                        isShowLimitLineChecked: isShowLimitLineChecked
                      }
                    });
                  })
              }
              .height($r('app.integer.bar_chart_list_item_height'))
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })
          }
          .padding({
            top: $r('app.integer.bar_chart_list_card_padding'),
            bottom: $r('app.integer.bar_chart_list_card_padding')
          })
          .margin({ top: $r('app.integer.bar_chart_list_item_padding') })
          .borderRadius($r('app.integer.bar_chart_list_card_border_radius'))
          .backgroundColor(Color.White)
          .alignItems(HorizontalAlign.Start)
          .width('100%')

          Column() {
            Text($r('app.string.bar_chart_control_leftYAxis_limitline_location'))
              .fontSize($r('app.integer.bar_chart_list_small_text_size'))
              .opacity(TEXT_OPACITY)
              .fontColor(Color.Black)
              .fontWeight(TEXT_FONT_WEIGHT)
          }
          .justifyContent(FlexAlign.End)
          .margin({ left: $r('app.integer.bar_chart_list_item_padding') })
          .height($r('app.integer.bar_chart_list_small_text_height'))

          Column() {
            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text('Both')
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Radio({ value: 'both', group: 'limitLinePosition' })
                  .checked(this.limitLinePosition === 'Both' ? true : false)
                  .enabled(this.isEnableLeftYAxis)
                  .id('both')
                  .onChange((isChecked: boolean) => {
                    if (this.leftAxis && isChecked) {
                      this.limitLinePosition = 'Both';
                      this.leftAxis.removeAllLimitLines();
                      if (this.limitLine1) {
                        this.leftAxis.addLimitLine(this.limitLine1);
                      }
                      if (this.limitLine2) {
                        this.leftAxis.addLimitLine(this.limitLine2);
                      }
                      this.refresh();
                    }
                  })
              }
              .height($r('app.integer.bar_chart_list_item_height'))

              Divider()
                .width('100%')
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })

            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text('None')
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Radio({ value: 'none', group: 'limitLinePosition' })
                  .checked(this.limitLinePosition === 'None' ? true : false)
                  .enabled(this.isEnableLeftYAxis)
                  .id('none')
                  .onChange((isChecked: boolean) => {
                    if (this.leftAxis && isChecked) {
                      this.limitLinePosition = 'None';
                      this.leftAxis.removeAllLimitLines();
                      this.refresh();
                    }
                  })
              }
              .height($r('app.integer.bar_chart_list_item_height'))

              Divider()
                .width('100%')
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })

            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text('Upper')
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Radio({ value: 'upper', group: 'limitLinePosition' })
                  .checked(this.limitLinePosition === 'Upper' ? true : false)
                  .enabled(this.isEnableLeftYAxis)
                  .id('upper')
                  .onChange((isChecked: boolean) => {
                    if (this.leftAxis && isChecked) {
                      this.limitLinePosition = 'Upper';
                      this.leftAxis.removeAllLimitLines();
                      if (this.limitLine1) {
                        this.leftAxis.addLimitLine(this.limitLine1);
                      }
                      this.refresh();
                    }
                  })
              }
              .height($r('app.integer.bar_chart_list_item_height'))

              Divider()
                .width('100%')
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })

            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text('Lower')
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Radio({ value: 'lower', group: 'limitLinePosition' })
                  .checked(this.limitLinePosition === 'Lower' ? true : false)
                  .enabled(this.isEnableLeftYAxis)
                  .id('lower')
                  .onChange((isChecked: boolean) => {
                    if (this.leftAxis && isChecked) {
                      this.limitLinePosition = 'Lower';
                      this.leftAxis.removeAllLimitLines();
                      if (this.limitLine2) {
                        this.leftAxis.addLimitLine(this.limitLine2);
                      }
                      this.refresh();
                    }
                    let lowerChecked = isChecked;
                    emitter.emit({ eventId: 0, priority: 0 }, {
                      data: {
                        lowerChecked: lowerChecked
                      }
                    });
                  })
              }
              .height($r('app.integer.bar_chart_list_item_height'))
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })
          }
          .padding({
            top: $r('app.integer.bar_chart_list_card_padding'),
            bottom: $r('app.integer.bar_chart_list_card_padding')
          })
          .margin({ top: $r('app.integer.bar_chart_list_card_margin') })
          .borderRadius($r('app.integer.bar_chart_list_card_border_radius'))
          .backgroundColor(Color.White)
          .alignItems(HorizontalAlign.Start)
          .width('100%')

          Column() {
            Text($r('app.string.bar_chart_control_right_YAxis_sheet'))
              .fontSize($r('app.integer.bar_chart_list_small_text_size'))
              .opacity(TEXT_OPACITY)
              .fontColor(Color.Black)
              .fontWeight(TEXT_FONT_WEIGHT)
          }
          .justifyContent(FlexAlign.End)
          .margin({ left: $r('app.integer.bar_chart_list_item_padding') })
          .height($r('app.integer.bar_chart_list_small_text_height'))

          Column() {
            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text($r('app.string.bar_chart_control_rightYAxis_is_display'))
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Toggle({ type: ToggleType.Switch, isOn: false })
                  .selectedColor('#0A59F7')
                  .id('rightYAxis')
                  .onChange((isChecked: boolean) => {
                    if (this.rightAxis) {
                      this.rightAxis.setEnabled(isChecked);
                      this.isEnableRightYAxis = isChecked;
                      this.refresh();
                    }
                    let rightYAxisChecked = isChecked;
                    emitter.emit({ eventId: 0, priority: 0 }, {
                      data: {
                        rightYAxisChecked: rightYAxisChecked
                      }
                    });
                  })
              }
              .height($r('app.integer.bar_chart_list_item_height'))
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })
          }
          .padding({
            top: $r('app.integer.bar_chart_list_card_padding'),
            bottom: $r('app.integer.bar_chart_list_card_padding')
          })
          .margin({ top: $r('app.integer.bar_chart_list_item_padding') })
          .borderRadius($r('app.integer.bar_chart_list_card_border_radius'))
          .backgroundColor(Color.White)
          .alignItems(HorizontalAlign.Start)
          .width('100%')

          Column() {
            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text($r('app.string.bar_chart_control_rightYAxis_sheet_outside'))
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Radio({ value: 'outSideChart', group: 'rightYAxisLabelPosition' })
                  .checked(this.yAxisRightPosition === 'RightYAxisOutSide' ? true : false)
                  .enabled(this.isEnableRightYAxis)
                  .id('rightYAxisOutSide')
                  .onChange((isChecked: boolean) => {
                    if (this.rightAxis && isChecked) {
                      this.yAxisRightPosition = 'RightYAxisOutSide';
                      this.rightAxis.setPosition(YAxisLabelPosition.OUTSIDE_CHART);
                      this.refresh();
                    }
                  })
              }
              .height($r('app.integer.bar_chart_list_item_height'))

              Divider()
                .width('100%')
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })

            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text($r('app.string.bar_chart_control_rightYAxis_sheet_inside'))
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Radio({ value: 'inSideChart', group: 'rightYAxisLabelPosition' })
                  .checked(this.yAxisRightPosition === 'RightYAxisInSide' ? true : false)
                  .enabled(this.isEnableRightYAxis)
                  .id('rightYAxisInSide')
                  .onChange((isChecked: boolean) => {
                    if (this.rightAxis && isChecked) {
                      this.yAxisRightPosition = 'RightYAxisInSide';
                      this.rightAxis.setPosition(YAxisLabelPosition.INSIDE_CHART);
                      this.refresh();
                    }
                    let rightYAxisInSideChecked = isChecked;
                    emitter.emit({ eventId: 0, priority: 0 }, {
                      data: {
                        rightYAxisInSideChecked: rightYAxisInSideChecked
                      }
                    });
                  })
              }
              .height($r('app.integer.bar_chart_list_item_height'))
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })
          }
          .padding({
            top: $r('app.integer.bar_chart_list_card_padding'),
            bottom: $r('app.integer.bar_chart_list_card_padding')
          })
          .margin({ top: $r('app.integer.bar_chart_list_item_padding') })
          .borderRadius($r('app.integer.bar_chart_list_card_border_radius'))
          .backgroundColor(Color.White)
          .alignItems(HorizontalAlign.Start)
          .width('100%')

          Column() {
            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text($r('app.string.bar_chart_control_is_draw_background'))
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Toggle({ type: ToggleType.Switch, isOn: false })
                  .selectedColor('#007DFF')
                  .id('isDrawBackground')
                  .onChange((isChecked: boolean) => {
                    if (this.model) {
                      this.model.setDrawGridBackground(isChecked);
                      this.model.notifyDataSetChanged();
                      this.model.invalidate();
                    }
                    let isDrawBackgroundChecked = isChecked;
                    emitter.emit({ eventId: 0, priority: 0 }, {
                      data: {
                        isDrawBackgroundChecked: isDrawBackgroundChecked
                      }
                    });
                  })
              }
              .height($r('app.integer.bar_chart_list_item_height'))
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })
          }
          .padding({
            top: $r('app.integer.bar_chart_list_card_padding'),
            bottom: $r('app.integer.bar_chart_list_card_padding')
          })
          .margin({ top: $r('app.integer.bar_chart_list_item_padding') })
          .borderRadius($r('app.integer.bar_chart_list_card_border_radius'))
          .backgroundColor(Color.White)
          .alignItems(HorizontalAlign.Start)
          .width('100%')

          Column() {
            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceBetween,
                alignItems: ItemAlign.Center
              }) {
                Text($r('app.string.bar_chart_control_is_show_markerview'))
                  .fontSize($r('app.integer.bar_chart_list_big_text_size'))
                  .fontWeight(TEXT_FONT_WEIGHT)

                Toggle({ type: ToggleType.Switch, isOn: true })
                  .selectedColor('#007DFF')
                  .id('isShowMarkerView')
                  .onChange((isChecked: boolean) => {
                    if (this.model) {
                      // 使用setDrawMarkerViews设置true，点击柱状图中柱子会有弹窗效果
                      this.model.setDrawMarkerViews(isChecked);
                      this.model.notifyDataSetChanged();
                      this.model.invalidate();
                    }
                    let isShowMarkerViewChecked = isChecked;
                    emitter.emit({ eventId: 0, priority: 0 }, {
                      data: {
                        isShowMarkerViewChecked: isShowMarkerViewChecked
                      }
                    });
                  })
              }
              .height($r('app.integer.bar_chart_list_item_height'))
            }
            .padding({
              left: $r('app.integer.bar_chart_list_item_padding'),
              right: $r('app.integer.bar_chart_list_item_padding')
            })
          }
          .padding({
            top: $r('app.integer.bar_chart_list_card_padding'),
            bottom: $r('app.integer.bar_chart_list_card_padding')
          })
          .margin({ top: $r('app.integer.bar_chart_list_item_padding') })
          .borderRadius($r('app.integer.bar_chart_list_card_border_radius'))
          .backgroundColor(Color.White)
          .alignItems(HorizontalAlign.Start)
          .width('100%')
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding({
          left: $r('app.integer.bar_chart_border_padding'),
          right: $r('app.integer.bar_chart_border_padding')
        })
      }
      .padding({ bottom: $r('app.integer.bar_chart_padding_bottom') })
      .id('scroll')
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .backgroundColor($r('app.color.bar_chart_background_color'))
    .width('100%')
    .height('100%')
  }
}