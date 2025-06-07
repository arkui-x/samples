import Want from '@ohos.app.ability.Want'
import hilog from '@ohos.hilog'
import common from '@ohos.app.ability.common'

@Entry
@Component
struct One {
  controller: TextInputController = new TextInputController()
  @State keyboartStr: string =''
  @State isLunar: boolean = false
  private selectedDate: Date = new Date('2021-08-08')

  build() {
    Row() {
      Column() {

        Button('切换公历农历')
          .margin({ top: 30, bottom: 30 })
          .onClick(() => {
            this.isLunar = !this.isLunar
          })

        DatePicker({
          start: new Date('1970-1-1'),
          end: new Date('2100-1-1'),
          selected: this.selectedDate
        })
          .disappearTextStyle({color: Color.Gray, font: {size: '16fp', weight: FontWeight.Bold}})
          .textStyle({color: '#ff182431', font: {size: '18fp', weight: FontWeight.Normal}})
          .selectedTextStyle({color: '#ff0000FF', font: {size: '26fp', weight: FontWeight.Regular}})
          .lunar(this.isLunar)
          .onDateChange((value: Date) => {
            this.selectedDate = value
            console.info('select current date is: ' + value.toString())
          })

        Button("Arkui跳转ANDROID_ACTIVITY")
          .onClick(() => {
            let want:Want={
              bundleName:'com.example.enjoyarkuix',
              moduleName:'platformView',
              abilityName:'Jump',
              parameters:{from:'消息来自stageFragment',content:'hello,activity'}
            }
            let context= getContext(this) as common.UIAbilityContext;
            context.startAbility(want,(err,data)=>{});

          })
          .fontColor(Color.Black)
          .backgroundColor(Color.Grey)
          .margin({ top: 150, bottom: 30 })
      }

    }
    .alignItems(VerticalAlign.Top)
    .height('100%')
    .width('100%')
    .onClick(() =>{
      this.controller.stopEditing()
    })
  }
}