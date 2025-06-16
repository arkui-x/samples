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

import router from '@ohos.router';
import { TitleBar } from '../component/TitleBar';
import Logger from '../utils/Logger';
import { MenuItemModifier, MenuModifier } from '@ohos.arkui.modifier';
import { LengthUnit } from '@kit.ArkUI';

class MyMenuModifier extends MenuModifier {
  applyNormalAttribute(instance: MenuModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .font({
        size: 16,
        family: 'HarmonyOS Sans',
        weight: FontWeight.Normal,
        style: FontStyle.Normal
      })
      .fontColor(Color.Red)
      .radius(25)
      .menuItemDivider({
        'strokeWidth': { 'value': 5, 'unit': LengthUnit.VP },
        'color': Color.Black,
        'startMargin': { 'value': 10, 'unit': LengthUnit.VP },
        'endMargin': { 'value': 10, 'unit': LengthUnit.VP },
      })
      .menuItemGroupDivider({
        'strokeWidth': { 'value': 5, 'unit': LengthUnit.VP },
        'color': Color.Black,
        'startMargin': { 'value': 10, 'unit': LengthUnit.VP },
        'endMargin': { 'value': 10, 'unit': LengthUnit.VP },
      })
      .subMenuExpandingMode(SubMenuExpandingMode.SIDE_EXPAND)
  }
}

class MyMenuItemModifier extends MenuItemModifier {
  applyNormalAttribute(instance: MenuItemModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .selected(false)
      .selectIcon(false)
      .contentFont({
        style: FontStyle.Normal
      })
      .contentFontColor(Color.Black)
      .labelFont({
        family: 'HarmonyOS Sans',
        weight: FontWeight.Normal,
        style: FontStyle.Normal
      })
      .labelFontColor(Color.Pink)
  }
}

@Entry
@Component
struct TestMenuItemModifier {
  @State title: string = ''
  @State myMenuModifier: MyMenuModifier = new MyMenuModifier()
  @State myMenuItemModifier: MyMenuItemModifier = new MyMenuItemModifier()

  @Builder
  SubMenu() {
    Menu() {
      MenuItem({ content: "复制" })
      MenuItem({ content: "粘贴" })
    }
  }

  @Builder
  MyMenu() {
    Menu() {
      MenuItemGroup({ header: '菜单Menu' }) {
        MenuItem({
          startIcon: $r("app.media.icon"),
          content: "菜单选项",
          endIcon: $r("app.media.icon"),
          builder: (): void => this.SubMenu()
        })
        MenuItem({
          startIcon: $r("app.media.app_icon"),
          content: "菜单选项",
          endIcon: $r("app.media.icon"),
          builder: (): void => this.SubMenu()
        })
          .attributeModifier(this.myMenuItemModifier)
      }
    }.attributeModifier(this.myMenuModifier)
  }

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    Logger.info('router.getParams() title is ' + params.title)
    this.title = params.title
  }

  build() {
    Column() {
      TitleBar({ title: this.title }).size({ height: '10%' })
      Column() {
        Scroll() {
          Column() {
            Text('点击展开菜单')
              .fontSize(30)
              .fontWeight(FontWeight.Bold)
              .bindMenu(this.MyMenu)
          }
        }.scrollBar(BarState.Off)
      }
      .size({ width: '98%', height: '40%' })
      .border({
        width: 3,
        color: Color.Pink,
        radius: 30,
        style: BorderStyle.Solid
      })
      .margin({ top: 10, bottom: 10 })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}