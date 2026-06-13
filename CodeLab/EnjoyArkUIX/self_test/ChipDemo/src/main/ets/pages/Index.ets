import { Chip, ChipSize, LengthMetrics, SymbolGlyphModifier } from '@kit.ArkUI';
import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State isActivated: boolean = false
  @State isActivated1: boolean = false

  build() {
    Row() {
      Scroll() {

        Column({ space: 10 }) {

          Text('自定义后缀图标')
            .fontSize(30)
            .margin(5)
          Chip({
            prefixIcon: {
              // 'app.media.chips'仅作示例，请替换为实际使用图片。
              src: $r('app.media.ic_unselect_universal'),
              size: { width: 16, height: 16 },
              fillColor: Color.Red
            },
            label: {
              text: "操作块",
              fontSize: 12,
              fontColor: Color.Blue,
              fontFamily: "HarmonyOS Sans",
              labelMargin: { left: 20, right: 30 }
            },
            suffixIcon: {
              // 'app.media.close'仅作示例，请替换为实际使用图片。
              src: $r('app.media.ic_unselect_universal'),
              size: { width: 16, height: 16 },
              fillColor: Color.Red,
              action: () => {
                console.log("chip on close")
              }
            },
            size: ChipSize.NORMAL,
            allowClose: false,
            enabled: true,
            backgroundColor: $r('sys.color.ohos_id_color_button_normal'),
            borderRadius: $r('sys.float.ohos_id_corner_radius_button')
          })

          Text('设置默认后缀图标')
            .fontSize(30)
            .margin(5)
          Chip({
            prefixIcon: {
              // 'app.media.chips'仅作示例，请替换为实际使用图片。
              src: $r('app.media.ic_unselect_universal'),
              size: { width: 16, height: 16 },
              fillColor: Color.Blue
            },
            label: {
              text: "操作块",
              fontSize: 12,
              fontColor: Color.Blue,
              fontFamily: "HarmonyOS Sans",
              labelMargin: { left: 20, right: 30 }
            },
            size: ChipSize.NORMAL,
            allowClose: true,
            enabled: true,
            backgroundColor: $r('sys.color.ohos_id_color_button_normal'),
            borderRadius: $r('sys.float.ohos_id_corner_radius_button')
          })

          Text('不显示后缀图标')
            .fontSize(30)
            .margin(5)
          Chip({
            prefixIcon: {
              src: $r('app.media.ic_unselect_universal'),
              size: { width: 16, height: 16 },
              fillColor: Color.Blue
            },
            label: {
              text: "操作块",
              fontSize: 12,
              fontColor: Color.Blue,
              fontFamily: "HarmonyOS Sans",
              labelMargin: { left: 20, right: 30 }
            },
            size: ChipSize.SMALL,
            allowClose: false,
            enabled: true,
            backgroundColor: $r('sys.color.ohos_id_color_button_normal'),
            borderRadius: $r('sys.float.ohos_id_corner_radius_button'),
            onClose: () => {
              console.log("chip on close")
            }
          })

          Text('激活态操作块')
            .fontSize(30)
            .margin(5)


          Chip({
            prefixIcon: {
              // 'app.media.chips'仅作示例，请替换为实际使用图片。
              src: $r('app.media.ic_unselect_universal'),
              size: { width: 16, height: 16 },
              fillColor: Color.Blue,
              activatedFillColor: $r('sys.color.ohos_id_color_text_primary_contrary')
            },
            label: {
              text: "操作块",
              fontSize: 12,
              fontColor: Color.Blue,
              activatedFontColor: $r('sys.color.ohos_id_color_text_primary_contrary'),
              fontFamily: "HarmonyOS Sans",
              labelMargin: { left: 20, right: 30 }
            },
            size: ChipSize.NORMAL,
            allowClose: true,
            enabled: true,
            activated: this.isActivated,
            backgroundColor: $r('sys.color.ohos_id_color_button_normal'),
            activatedBackgroundColor: $r('sys.color.ohos_id_color_emphasize'),
            borderRadius: $r('sys.float.ohos_id_corner_radius_button'),
            onClose: () => {
              console.info("chip on close")
            },
            onClicked: () => {
              console.info("chip on clicked")
            }
          })

          Button('改变激活状态').onClick(() => {
            this.isActivated = !this.isActivated
          })


          Text('设置symbol类型图标')
            .fontSize(30)
            .margin(5)
          Chip({
            prefixIcon: {
              // 'app.media.chips'仅作示例，请替换为实际使用图片。
              src: $r('app.media.icon'),
              size: { width: 16, height: 16 },
              fillColor: Color.Blue,
              activatedFillColor: $r('sys.color.ohos_id_color_text_primary_contrary')
            },
            prefixSymbol: {
              normal: new SymbolGlyphModifier($r('sys.symbol.ohos_star')).fontSize(16).fontColor([Color.Green]),
              activated: new SymbolGlyphModifier($r('sys.symbol.ohos_star')).fontSize(16).fontColor([Color.Red]),
            },
            label: {
              text: "操作块",
              fontSize: 12,
              fontColor: Color.Blue,
              activatedFontColor: $r('sys.color.ohos_id_color_text_primary_contrary'),
              fontFamily: "HarmonyOS Sans",
              labelMargin: { left: 20, right: 30 },
            },
            size: ChipSize.NORMAL,
            allowClose: true,
            enabled: true,
            activated: this.isActivated1,
            backgroundColor: $r('sys.color.ohos_id_color_button_normal'),
            activatedBackgroundColor: $r('sys.color.ohos_id_color_emphasize'),
            borderRadius: $r('sys.float.ohos_id_corner_radius_button'),
            onClose: () => {
              console.log("chip on close")
            },
            onClicked: () => {
              console.log("chip on clicked")
            }
          })

          Button('改变激活状态').onClick(() => {
            this.isActivated1 = !this.isActivated1
          })

          Text('设置镜像效果')
            .fontSize(30)
            .margin(5)

          Chip({
            direction: Direction.Rtl,
            prefixIcon: {
              // 'app.media.chips'仅作示例，请替换为实际使用图片。
              src: $r('app.media.ic_unselect_universal'),
              size: { width: 16, height: 16 },
              fillColor: Color.Red,
            },
            label: {
              text: "操作块",
              fontSize: 12,
              fontColor: Color.Blue,
              fontFamily: "HarmonyOS Sans",
              localizedLabelMargin: { start: LengthMetrics.vp(20), end: LengthMetrics.vp(20) },
            },
            suffixIcon: {
              // 此处'app.media.close'仅作示例，请替换为实际使用图片。
              src: $r('app.media.ic_unselect_component'),
              size: { width: 16, height: 16 },
              fillColor: Color.Red,
            },
            size: ChipSize.NORMAL,
            allowClose: false,
            enabled: true,
            backgroundColor: $r('sys.color.ohos_id_color_button_normal'),
            borderRadius: $r('sys.float.ohos_id_corner_radius_button')
          })
          Text('chip无障碍功能验证')
            .fontSize(30)
            .margin(5)

          Button('Image类型无障碍朗读')
            .width('50%')
            .height(50)
            .fontSize(15)
            .margin(5)
            .onClick(() => {
              router.pushUrl({ url: 'pages/test1' });
            })

          Button('symbol类型无障碍朗读')
            .width('50%')
            .height(50)
            .fontSize(15)
            .margin(5)
            .onClick(() => {
              router.pushUrl({ url: 'pages/test2' });
            })
          Button('Chip类型无障碍朗读')
            .width('50%')
            .height(50)
            .fontSize(15)
            .margin(5)
            .onClick(() => {
              router.pushUrl({ url: 'pages/test3' });
            })
        }
        .width('100%')
      }
    }
    .height('100%')
  }
}