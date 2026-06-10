import { Chip } from '@kit.ArkUI';
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
            SectionGroup({ title: '后缀图标播报' }) {
              SectionItem({ title: '自定义播报' }) {
                Chip({
                  label: { text: '操作块' },
                  suffixIcon: {
                    size: { width: 16, height: 16 },
                    src: $r('sys.media.ohos_ic_public_cut'),
                    accessibilityText: '图标',
                    accessibilityDescription: '新手提醒',
                    action: () => {
                      console.info("后缀图标被点击");
                    }
                  },
                  onClicked: () => {
                    console.info("操作块被点击");
                  },
                  accessibilityDescription: '自定义播报无障碍描述',
                })
              }
            }
          }
        }
      }
    }
  }
}