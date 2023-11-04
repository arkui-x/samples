import JsonExample from './JsonExample'
import CustomerExample from './CustomerExample'

@Entry
@Component
struct Index {
  @Provide currentPage: string = 'index'
  @Provide deserialize: string = 'gson'

  build() {
    Column() {
      if (this.currentPage === 'index') {
        Column() {
          Text(`JSON反序列化`)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .height('20%')
          Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Text('反序列化工具：')
              .width('40%')
            Flex() {
              Row() {
                Radio({ value: 'gson', group: 'radioGroup' }).checked(this.deserialize === 'gson')
                  .onChange((isChecked: boolean) => {
                    if (isChecked) {
                      this.deserialize = 'gson'
                    }
                  })
                Text('gson-ts')
              }
              .width('50%')

              Row() {
                Radio({ value: 'js', group: 'radioGroup' }).checked(this.deserialize === 'js')
                  .onChange((isChecked: boolean) => {
                    if (isChecked) {
                      this.deserialize = 'js'
                    }
                  })
                Text('原生JS')
              }
              .width('50%')
            }
            .width('50%')
          }
          .height('30%')

          Flex({ justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Start }) {
            Button('自定义数据')
              .onClick(() => {
                this.currentPage = 'customer'
              })
            Button('查看示例')
              .onClick(() => {
                this.currentPage = 'example'
              })
          }
          .height('50%')
        }
      } else {
        if (this.currentPage === 'customer') {
          CustomerExample()
        } else {
          JsonExample()
        }
      }
    }
    .width('100%')
    .height('100%')
  }
}