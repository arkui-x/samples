import { Chip, SymbolGlyphModifier } from '@kit.ArkUI';

import router from '@ohos.router';
import { TitleBar } from './title';
@Builder
function DefaultFunction(): void {
}

@Component
struct SectionGroup {
  @Prop
  @Require
  title: ResourceStr;
  @BuilderParam
  @Require
  content: () => void = DefaultFunction;

  build() {
    Column({ space: 4 }) {
      Text(this.title)
        .fontColor('#FF666666')
        .fontSize(12)
      Column({ space: 8 }) {
        this.content()
      }
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
  }
}

@Component
struct SectionItem {
  @Prop
  @Require
  title: ResourceStr;
  @BuilderParam
  @Require
  content: () => void = DefaultFunction;

  build() {
    Column({ space: 12 }) {
      Text(this.title)
      this.content()
    }
    .backgroundColor('#FFFFFFFF')
    .borderRadius(12)
    .padding(12)
    .width('100%')
  }
}

@Entry
@Component
struct ChipExample2 {
  @State activated: boolean = false;

  build() {
    Column() {
      TitleBar()
      Column() {
        NavDestination() {
          Scroll() {
            SectionGroup({ title: '后缀Symbol播报' }) {
              SectionItem({ title: 'activatedAccessibility' }) {
                Chip({
                  label: { text: '操作块' },
                  activated: true,
                  suffixSymbol: {
                    activated: new SymbolGlyphModifier($r('sys.symbol.media_sound'))
                      .fontSize(72),
                  },
                  suffixSymbolOptions: {
                    activatedAccessibility: {
                      accessibilityText: '图标无障碍文本属性',
                      accessibilityDescription: '激活态无障碍朗读功能属性验证'
                    },
                    action: () => {
                      console.info("后缀Symbol被点击！");
                    }
                  },
                  onClicked: () => {
                    console.info("操作块被点击");
                  },
                  accessibilityDescription: 'activatedAccessibility无障碍描述',
                })
              }

              SectionItem({ title: 'normalAccessibility' }) {
                Chip({
                  label: { text: '操作块' },
                  suffixSymbol: {
                    normal: new SymbolGlyphModifier($r('sys.symbol.media_sound'))
                      .fontSize(72),
                  },
                  suffixSymbolOptions: {
                    normalAccessibility: {
                      accessibilityText: '图标无障碍文本属性',
                      accessibilityDescription: '非激活态无障碍朗读功能验证'
                    },
                    action: () => {
                      console.info("后缀Symbol被点击！");
                    }
                  },
                  onClicked: () => {
                    console.info("操作块被点击");
                  },
                  accessibilityLevel:'yes',
                  accessibilityDescription: 'normalAccessibility无障碍描述',
                })
              }
            }
          }
        }
        .padding({
          top: 8,
          bottom: 8,
          left: 16,
          right: 16,
        })
      }
    }
  }
}