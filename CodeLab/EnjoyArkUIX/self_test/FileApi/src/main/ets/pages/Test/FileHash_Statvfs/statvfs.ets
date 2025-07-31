import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs, statfs } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';
import { TitleBar } from '../../MainPage';

@Entry
@Component
struct Index {
  @State freeSpace: string = '可用空间： ';
  @State totalSpace: string = '总空间： ';
  @State title: string = '';

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    console.info('router.getParams() title is ' + params.title)
    this.title = params.title
  }
  build() {
    Column({ space: 20 }) {
      TitleBar({ title: this.title }).size({ height: '10%' })
      Row() {
        Text(this.freeSpace + ' bytes')
          .fontSize(16)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height('15%')
      .backgroundColor('#F5DEB3')
      .justifyContent(FlexAlign.Center)

      Row() {
        Text(this.totalSpace + ' bytes')
          .fontSize(16)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height('15%')
      .backgroundColor('#F5DEB3')
      .justifyContent(FlexAlign.Center)

      List({ space: 10 }) {
        ListItem() {
          Button("Total-Promise回调")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(150)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;

              // 获取总空间
              statfs.getTotalSize(pathDir).then((totalSize: number) => {
                this.totalSpace = "Total (Promise) 检查成功：" + totalSize.toString();
              }).catch((err: BusinessError) => {
                this.totalSpace = "Total (Promise) 检查失败: " + err.message;
              });
            })
            .width(350)
            .height(60)
        }
        ListItem() {
          Button("Free-Promise回调")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(150)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;

              // 获取可用空间
              statfs.getFreeSize(pathDir).then((freeSize: number) => {
                this.freeSpace = freeSize.toString();
                this.freeSpace = "Free (Promise) 检查成功：" + freeSize.toString();
              }).catch((err: BusinessError) => {
                this.freeSpace = "Free (Promise) 检查失败: " + err.message;
              });
            })
            .width(350)
            .height(60)
        }
        ListItem() {
          Button("Total-Callback回调")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(150)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;

              // 获取总空间
              statfs.getTotalSize(pathDir, (err: BusinessError, totalSize: number) => {
                if (err) {
                  this.totalSpace = "Total (Callback) 检查失败: " + err.message;
                } else {
                  this.totalSpace = "Total (Callback) 检查成功：" + totalSize.toString();
                }
              });
            })
            .width(350)
            .height(60)
        }
        ListItem() {
          Button("Free-Callback回调")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(150)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;

              // 获取可用空间
              statfs.getFreeSize(pathDir, (err: BusinessError, freeSize: number) => {
                if (err) {
                  this.freeSpace = "Free (Callback) 检查失败: " + err.message;
                } else {
                  this.freeSpace = "Free (Callback) 检查成功：" + freeSize.toString();
                }
              });
            })
            .width(350)
            .height(60)
        }
        ListItem() {
          Button("TotalSync")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(150)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;

              // 获取总空间
              let totalSize = statfs.getTotalSizeSync(pathDir);
              this.totalSpace = "Total (Sync) 检查成功：" + totalSize.toString();
            })
            .width(350)
            .height(60)
        }
        ListItem() {
          Button("FreeSync")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(150)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;

              // 获取可用空间
              let freeSize = statfs.getFreeSizeSync(pathDir);
              this.freeSpace = "Free (Sync) 检查成功：" + freeSize.toString();
            })
            .width(350)
            .height(60)
        }
      }
    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}