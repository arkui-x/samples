import { TitleBar } from './TitleBar';
export const entryName : string = 'WindowContent2';
@Entry({routeName: entryName})
@Component
export struct WindowContent2 {

    build() {
        Row() {
            Column() {
                TitleBar({ title: $r('app.string.WindowStageLoadContentByName_title') })
                    .width('100%')
                Text("测试窗口1")

            }
            .width('100%').backgroundColor(Color.Red)
        }
        .height('100%')
    }
}