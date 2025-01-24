import { common, Want } from '@kit.AbilityKit'
import { BusinessError } from '@kit.BasicServicesKit'
import EntryAbility from '../entryability/EntryAbility'

@Entry
@Component
struct WantPage {
  @State message: string = '此处显示WantParams信息'

  aboutToAppear() {
    this.message = "{\n"
    this.message += "  boolKey: " + EntryAbility.store.get("boolKey") + "\n"
    this.message += "  intKey: " + EntryAbility.store.get("intKey") + "\n"
    this.message += "  doubleKey: " + EntryAbility.store.get("doubleKey") + "\n"
    this.message += "  stringKey: " + EntryAbility.store.get("stringKey") + "\n"
    this.message += "  arrayKey: " + EntryAbility.store.get("arrayKey") + "\n"
    this.message += "  wantParamsKey: " + EntryAbility.store.get("wantParamsKey") + "\n"
    this.message += "}"
  }
  build() {
    Row() {
      Column() {
        Text("原生->ArkTS：")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
        Text(this.message)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({left:10, right: 10})
          .padding({left:10, right:10})
        Divider().strokeWidth(8).color('#F1F3F5')
        Button("ArkTSTo原生")
          .width('90%')
          .onClick(() => {
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext
            let want: Want  = {
              bundleName: 'com.example.wantparams',
              abilityName: 'Want',
              moduleName: 'Entry',
              parameters: {
                "boolKey" : true,
                "intKey" : 1234,
                "doubleKey" : 45.6723232,
                stringKey : "Hello, WantParams",
                arrayKey : [-2147483648,-2147483647,2147483647,2147483646, 0, 345, -3456],
                wantParamsKey : {
                  boolKey2 : false,
                  intKey2 : -0,
                  doubleKey2 : -23454.3546,
                  stringKey2 : "Hello, WantParams",
                  arrayKey2 : ["normal", "value1 value2, value3", "Hello, World!", "It's me."],
                }
              }
            }
            context.startAbility(want, (err: BusinessError) => {
              if (err.code) {
                console.log("startAbility failed: message = " + err.message + "  code = " + err.code)
              }
            });
          })
          .margin(5)
      }
      .width('100%')
    }
    .height('100%')
  }
}