import { AccessibilitySelectedType, Chip, ChipSize } from '@kit.ArkUI';
import { TitleBar } from './title';

@Entry
@Component
struct ChipAccessibilityExample {
  @State clickedChipActivated: boolean = false;
  @State checkedChipActivated: boolean = false;
  @State selectedChipActivated: boolean = false;

  build() {
    Column() {
      TitleBar()
      Column() {
        Column({ space: 20 }) {
          Text("Chip组件无障碍属性示例").fontSize(20).fontWeight(FontWeight.Bold)

          Chip({
            label: { text: "点击型Chip" },
            prefixIcon: {
              src: $r('sys.media.ohos_app_icon'),
              fillColor: Color.Blue
            },
            size: ChipSize.NORMAL,
            accessibilitySelectedType: AccessibilitySelectedType.CLICKED, // 点击型
            accessibilityDescription: "这是一个点击型Chip", // 整体无障碍描述
            accessibilityLevel: "yes", // 确保可被无障碍服务识别
            closeOptions: {
              accessibilityDescription: "删除此Chip，此操作无法撤销" // 为删除按钮提供详细说明
            },
            activated: this.clickedChipActivated,
            onClicked: () => {
              this.clickedChipActivated = !this.clickedChipActivated;
              console.info("点击型Chip被点击");
            },
            onClose: () => {
              console.info("点击型Chip的关闭按钮被点击");
            },
          })

          // 复选型Chip - CHECKED类型
          Chip({
            label: { text: "复选型Chip" },
            prefixIcon: {
              src: $r('sys.media.ohos_app_icon'),
              fillColor: Color.Green
            },
            size: ChipSize.NORMAL,
            accessibilitySelectedType: AccessibilitySelectedType.CHECKED, // 复选型
            accessibilityDescription: "这是一个复选型Chip", // 整体无障碍描述
            activated: this.checkedChipActivated,
            closeOptions: {
              accessibilityDescription: "删除此Chip，此操作无法撤销" // 为删除按钮提供详细说明
            },
            onClicked: () => {
              this.checkedChipActivated = !this.checkedChipActivated;
              console.info("复选型Chip被选中点击");
            },
          })

          // 单选型Chip - SELECTED类型
          Chip({
            label: { text: "单选型Chip" },
            prefixIcon: {
              src: $r('sys.media.ohos_app_icon'),
              fillColor: Color.Red
            },
            size: ChipSize.NORMAL,
            accessibilitySelectedType: AccessibilitySelectedType.SELECTED, // 单选型
            accessibilityDescription: "这是一个单选型Chip", // 整体无障碍描述
            activated: this.selectedChipActivated,
            closeOptions: {
              accessibilityDescription: "删除此Chip，此操作无法撤销" // 为删除按钮提供详细说明
            },
            onClicked: () => {
              this.selectedChipActivated = !this.selectedChipActivated;
              console.info("单选型Chip被选中点击");
            },
          })

          // 无障碍级别设置示例
          Chip({
            label: { text: "无障碍级别为no" },
            size: ChipSize.NORMAL,
            accessibilityLevel: "no", // 此Chip不能被无障碍服务识别
            closeOptions: {
              accessibilityLevel: "no"
            },
            backgroundColor: '#CCCCCC',
            onClicked: () => {
              console.info("此Chip无法被无障碍服务识别");
            }
          })

          Chip({
            label: { text: "无障碍级别为no-hide-descendants" },
            size: ChipSize.NORMAL,
            accessibilityLevel: "no-hide-descendants", // 此Chip不能被无障碍服务识别
            backgroundColor: '#CCCCCC',
            onClicked: () => {
              console.info("此Chip无法被无障碍服务识别");
            }
          })

          Chip({
            label: { text: '无障碍级别为auto,不设置action回调' },
            suffixIcon: {
              size: { width: 16, height: 16 },
              src: $r('sys.media.ohos_ic_public_cut'),
              accessibilityText: 'asd',
              accessibilityDescription: '412',
              accessibilityLevel: "auto",
            },
            accessibilityDescription: '自定义播报无障碍描述',
          })

          Chip({
            label: { text: '无障碍级别为auto, 设置action回调' },
            suffixIcon: {
              size: { width: 16, height: 16 },
              src: $r('sys.media.ohos_ic_public_cut'),
              accessibilityText: 'asd',
              accessibilityDescription: '412',
              accessibilityLevel: "auto",
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
        .width('100%')
        .padding(16)
      }
    }
  }
}