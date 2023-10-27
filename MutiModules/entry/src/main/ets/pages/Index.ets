import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import common from '@ohos.app.ability.common';

@Entry
@Component
struct Index {
  @State message: string = 'Page entry'
  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(()=>{

            let context = getContext(this) as common.UIAbilityContext
            let wantInfo:Want = {
              bundleName = "com.example.mutimodules";
              moduleName = "feature1";
              abilityName = "Feature1Ability";
            };

            context.startAbility(wantInfo).then(() =>{
              console.info('start success');
            }).catch((err:Error)=>{
              console.info('error code'+ JSON.stringify(err))
            })

          })
      }
      .width('100%')
    }
    .height('100%')
  }
}