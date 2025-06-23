/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { AlphabetListItemType } from '../model/AlphabetListItemType';

export const COMPONENT_LIST = [
  new AlphabetListItemType(
    'A',
    ['AlphabetIndexer', 'AttributeUpdater'],
    ['pages/TestAlphabetIndexerModifier', 'pages/TestAttributeUpdaterModifier']
  ),
  new AlphabetListItemType(
    'B',
    ['Blank', 'Button'],
    ['pages/TestBlankModifier', 'pages/TestButtonModifier']
  ),
  new AlphabetListItemType(
    'C',
    ['CalendarPicker', 'Checkbox', 'CheckboxGroup', 'Column', 'ColumnSplit', 'CommonModifier', 'ContainerSpanModifier', 'Counter'],
    ['pages/TestCalendarPickerModifier', 'pages/TestCheckboxModifier', 'pages/TestCheckboxGroupModifier', 'pages/TestColumnModifier',
      'pages/TestColumnSplitModifier', 'pages/TestCommonModifier', 'pages/TestContainerSpanModifier', 'pages/TestCounterModifier']
  ),
  new AlphabetListItemType(
    'D',
    ['DataPanel', 'DatePicker', 'Divider'],
    ['pages/TestDataPanelModifier', 'pages/TestDatePickerModifier', 'pages/TestDividerModifier']
  ),
  new AlphabetListItemType(
    'G',
    ['Gauge', 'Grid', 'GridCol', 'GridItem', 'GridRow'],
    ['pages/TestGaugeModifier', 'pages/TestGridModifier', 'pages/TestGridColModifier', 'pages/TestGridItemModifier', 'pages/TestGridRowModifier']
  ),
  new AlphabetListItemType(
    'H',
    ['Hyperlink'],
    ['pages/TestHyperlinkModifier']
  ),
  new AlphabetListItemType(
    'I',
    ['Image', 'ImageAnimator', 'ImageSpan'],
    ['pages/TestImageModifier', 'pages/TestImageAnimatorModifier', 'pages/TestImageSpanModifier']
  ),
  new AlphabetListItemType(
    'L',
    ['Line', 'List', 'ListItem', 'ListItemGroup', 'LoadingProgress'],
    ['pages/TestLineModifier', 'pages/TestListModifier', 'pages/TestListItemModifier', 'pages/TestListItemGroupModifier', 'pages/TestLoadingProgressModifier']
  ),
  new AlphabetListItemType(
    'M',
    ['Marquee', 'Menu', 'MenuItem'],
    ['pages/TestMarqueeModifier', 'pages/TestMenuModifier', 'pages/TestMenuItemModifier']
  ),
  new AlphabetListItemType(
    'N',
    ['NavDestination', 'Navigation',],
    ['pages/TestNavDestinationModifier', 'pages/TestNavigationModifier']
  ),
  new AlphabetListItemType(
    'P',
    ['Path', 'PatternLock', 'Polygon', 'Polyline', 'Progress'],
    ['pages/TestPathModifier', 'pages/TestPatternLockModifier', 'pages/TestPolygonModifier',
      'pages/TestPolylineModifier', 'pages/TestProgressModifier']
  ),
  new AlphabetListItemType(
    'R',
    ['Radio', 'Rating', 'Rect', 'RefreshModifier', 'RichEditor', 'Row', 'RowSplit'],
    ['pages/TestRadioModifier', 'pages/TestRatingModifier', 'pages/TestRectModifier', 'pages/TestRefreshModifier', 'pages/TestRichEditorModifier',
      'pages/TestRowModifier', 'pages/TestRowSplitModifier']
  ),
  new AlphabetListItemType(
    'S',
    ['Scroll', 'Search', 'Select', 'Shape', 'SideBarContainer', 'Slider', 'Span', 'Stack', 'StepperItem', 'Swiper', 'SymbolGlyph', 'SymbolSpan'],
    ['pages/TestScrollModifier', 'pages/TestSearchModifier', 'pages/TestSelectModifier', 'pages/TestShapeModifier', 'pages/TestSideBarContainerModifier',
      'pages/TestSliderModifier', 'pages/TestSpanModifier', 'pages/TestStackModifier', 'pages/TestStepperItemModifier', 'pages/TestSwiperModifier',
      'pages/TestSymbolGlyphModifier', 'pages/TestSymbolSpanModifier']
  ),
  new AlphabetListItemType(
    'T',
    ['Tabs', 'Text', 'TextArea', 'TextClock', 'TextInput', 'TextPicker', 'TextTimer', 'TimePicker', 'Toggle'],
    ['pages/TestTabsModifier', 'pages/TestTextModifier', 'pages/TestTextAreaModifier', 'pages/TestTextClockModifier', 'pages/TestTextInputModifier',
      'pages/TestTextPickerModifier', 'pages/TestTextTimerModifier', 'pages/TestTimePickerModifier', 'pages/TestToggleModifier']
  ),
  new AlphabetListItemType(
    'V',
    ['Video'],
    ['pages/TestVideoModifier']
  ),
  new AlphabetListItemType(
    'W',
    ['WaterFlow'],
    ['pages/TestWaterFlowModifier']
  )
]