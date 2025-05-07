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

const LINEAR_ANGLE = 90; // button渐变角度

/*
  自定义class实现button的AttributeModifier接口
*/
export class ButtonModifier implements AttributeModifier<ButtonAttribute> {
  applyNormalAttribute(instance: ButtonAttribute): void {
    instance.height($r('app.float.dynamicattributes_float_30'));
    instance.width($r('app.float.dynamicattributes_float_90'));
    instance.linearGradient({
      angle: LINEAR_ANGLE,
      colors: [[$r('app.color.dynamicattributes_buttonColor'), 0.5], [$r('app.color.dynamicattributes_orange'), 1.0]]
    });
  }
}

/*
  自定义class实现Text的AttributeModifier接口
*/
export class CommodityText implements AttributeModifier<TextAttribute> {
  textType: TextType = TextType.TYPE_ONE;
  textSize: number = 15;

  constructor(textType: TextType, textSize: number) {
    this.textType = textType;
    this.textSize = textSize;
  }

  applyNormalAttribute(instance: TextAttribute): void {
    if (this.textType === TextType.TYPE_ONE) {
      instance.fontSize(this.textSize);
      instance.fontColor($r('app.color.dynamicattributes_orange'));
      instance.fontWeight(FontWeight.Bolder);
      instance.width($r('app.string.dynamicattributes_max_size'));
    } else if (this.textType === TextType.TYPE_TWO) {
      instance.fontSize(this.textSize);
      instance.fontWeight(FontWeight.Bold);
      instance.fontColor($r('sys.color.ohos_id_counter_title_font_color'));
      instance.width($r('app.string.dynamicattributes_max_size'));
    } else if (this.textType === TextType.TYPE_Three) {
      instance.fontColor(Color.Gray);
      instance.fontSize(this.textSize);
      instance.fontWeight(FontWeight.Normal);
      instance.width($r('app.string.dynamicattributes_max_size'));
    } else if (this.textType === TextType.TYPE_FOUR) {
      instance.fontSize(this.textSize);
      instance.fontColor($r('app.color.dynamicattributes_orange'));
      instance.textAlign(TextAlign.Center);
      instance.border({ width: $r('app.float.dynamicattributes_float_1'), color: $r('app.color.dynamicattributes_orange'), style: BorderStyle.Solid });
      instance.margin({ right: $r('app.float.dynamicattributes_float_10') });
    }
  }
}

/*
  自定义class实现Image组件的AttributeModifier接口
*/
export class ImageModifier implements AttributeModifier<ImageAttribute> {
  width: Length | Resource = 0;
  height: Length | Resource = 0;

  constructor(width: Length | Resource, height: Length | Resource) {
    this.width = width;
    this.height = height;
  }

  applyNormalAttribute(instance: ImageAttribute): void {
    instance.width(this.width);
    instance.height(this.height);
    instance.borderRadius($r('app.float.dynamicattributes_float_10'));
  }
}

/*
   自定义class实现row组件的AttributeModifier接口
*/
export class BarModifier implements AttributeModifier<RowAttribute> {
  applyNormalAttribute(instance: RowAttribute): void {
    instance.height($r('app.float.dynamicattributes_float_60'));
    instance.width($r('app.string.dynamicattributes_max_size'));
    instance.padding($r('app.float.dynamicattributes_float_15'));
    instance.backgroundColor($r('app.color.dynamicattributes_barColor'));
    instance.justifyContent(FlexAlign.End);
    instance.border({
      width: { top: $r('app.float.dynamicattributes_float_1') },
      color: { top: $r('sys.color.ohos_id_color_component_normal') },
    });
  }
}

/*
   自定义class实现Checkbox组件的AttributeModifier接口
*/
export class CheckboxModifier implements AttributeModifier<CheckboxAttribute> {
  applyNormalAttribute(instance: CheckboxAttribute): void {
    instance.selectedColor($r('app.color.dynamicattributes_selectColor'));
    instance.width($r('app.float.dynamicattributes_float_15'));
    instance.height($r('app.float.dynamicattributes_float_15'));
    instance.margin({ right: $r('app.float.dynamicattributes_float_10') });
  }
}

/*
  枚举文本类型
*/
export enum TextType {
  TYPE_ONE,
  TYPE_TWO,
  TYPE_Three,
  TYPE_FOUR
}