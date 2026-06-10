// 导入鸿蒙ArkUI组件和所需工具包

import { i18n } from '@kit.LocalizationKit';

let systemLanguage: string = i18n.System.getSystemLanguage();

@Entry
@Component
struct WidgetCard {
  /*
   * The title.
   */
  readonly title: string = 'Hello World';
  /*
   * The action type.
   */
  readonly actionType: string = 'router';
  /*
   * The ability name.
   */
  readonly abilityName: string = 'EntryAbility';
  /*
   * The message.
   */
  readonly message: string = 'add detail';
  /*
   * The width percentage setting.
   */
  readonly fullWidthPercent: string = '100%';
  /*
   * The height percentage setting.
   */
  readonly fullHeightPercent: string = '100%';

  @State show: string = 'show';
  @State flag: boolean = true;


  build() {
    Row() {
      Column() {
        Button(this.show).width(80).height(30).margin(30)
          .onClick(() => {
            // 点击Button
            if (this.flag) {
              this.show = systemLanguage;
            } else {
              this.show = 'show';
            }
            this.flag = !this.flag;
          })
      }
      .width(this.fullWidthPercent)
    }
    .height(this.fullHeightPercent)
    .backgroundColor(Color.Blue)
  }
}