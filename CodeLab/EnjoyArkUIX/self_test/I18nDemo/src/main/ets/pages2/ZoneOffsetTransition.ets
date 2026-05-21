
import { BusinessError } from '@kit.BasicServicesKit';
import { i18n } from '@kit.LocalizationKit';
import router from '@ohos.router';
export interface handle {
  title: string
  onclick: () => void;
}

@Entry
@Component
struct ZoneOffsetTransitionTest{
  @State message: string = 'ZoneOffsetTransition测试';
  @State log: string = '';

  // 日志显示格式：添加带时间戳的日志
  private addLog(content: string) {
    this.log += `[${new Date().toLocaleTimeString()}] ${content}\n`;
  }

  // 清空日志
  private clearLog(): void {
    this.log = '';
    this.addLog('日志已清除');
    this.addLog('页面日志已清除');
  }

  // 日志显示区域的UI组件
  @Builder LogDisplay() {
    Scroll() {
      Text(this.log)
        .fontSize(14)
        .width('100%')
        .padding(10)
    }
    .height('30%')
    .width('100%')
    .border({ width: 1, color: '#eee' })
    .borderRadius(5)
  }
  testi18nZoneOffsetTransitiongetMilliseconds001001(): void {
     this.addLog('  testi18nZoneOffsetTransitiongetMilliseconds001001 开始')
    try {
      let timeZone: i18n.TimeZone = i18n.getTimeZone('America/Tijuana');
      let zoneRules: i18n.ZoneRules = timeZone.getZoneRules();
      let date = new Date(2025, 4, 13);
      let zoneOffsetTransition: i18n.ZoneOffsetTransition =
        zoneRules.nextTransition(date.getTime()); // 获取2025年5月13日以后的下一个时区跳变对象

      this.addLog('获取时区跳变点的时间戳为:')
      let val=zoneOffsetTransition.getMilliseconds(); // 跳变点的时间戳: 17620740000
      this.addLog(val.toString())
       this.addLog('  testi18nZoneOffsetTransitiongetMilliseconds001001 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
       this.addLog('报错')
      console.error(`call TimeZone.  testi18nZoneOffsetTransitiongetMilliseconds001001 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }


  testi18nZoneOffsetTransitiongetOffsetAfter001(): void {
     this.addLog('testi18nZoneOffsetTransitiongetOffsetAfter001 开始')
    try {
      let timeZone: i18n.TimeZone = i18n.getTimeZone('America/Tijuana');
      let zoneRules: i18n.ZoneRules = timeZone.getZoneRules();
      let date = new Date(2025, 4, 13);
      let zoneOffsetTransition: i18n.ZoneOffsetTransition =
        zoneRules.nextTransition(date.getTime()); // 获取2025年5月13日以后的下一个时区跳变对象
      this.addLog('获取时区跳变后的偏移量为:')
      let val=zoneOffsetTransition.getOffsetAfter(); // 跳变后的偏移量: -2880000
      this.addLog(val.toString())
       this.addLog('testi18nZoneOffsetTransitiongetOffsetAfter001 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
       this.addLog('报错')
      console.error(`call TimeZone.testi18nZoneOffsetTransitiongetOffsetAfter001 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }
   testi18nZoneOffsetTransitiongetgetOffsetBefore001(): void {
     this.addLog(' testi18nZoneOffsetTransitiongetgetOffsetBefore001 开始')
    try {
      let timeZone: i18n.TimeZone = i18n.getTimeZone('America/Tijuana');
      let zoneRules: i18n.ZoneRules = timeZone.getZoneRules();
      let date = new Date(2025, 4, 13);
      let zoneOffsetTransition: i18n.ZoneOffsetTransition =
        zoneRules.nextTransition(date.getTime()); // 获取2025年5月13日以后的下一个时区跳变对象
      this.addLog('获取时区跳变前的偏移量为:')
      let val=zoneOffsetTransition.getOffsetBefore(); // 跳变前的偏移量: -2520000
      this.addLog(val.toString())
       this.addLog(' testi18nZoneOffsetTransitiongetgetOffsetBefore001 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
       this.addLog('报错')
      console.error(`call TimeZone. testi18nZoneOffsetTransitiongetgetOffsetBefore001 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  private handleList: handle[] = [
    { title: 'testi18nZoneOffsetTransitiongetMilliseconds001001', onclick: () => this.  testi18nZoneOffsetTransitiongetMilliseconds001001() },
    { title: 'testi18nZoneOffsetTransitiongetOffsetAfter001', onclick: () => this.testi18nZoneOffsetTransitiongetOffsetAfter001() },
    { title: 'testi18nZoneOffsetTransitiongetgetOffsetBefore001', onclick: () => this. testi18nZoneOffsetTransitiongetgetOffsetBefore001() },


  ]
  build() {
    Column() {
      List() {
        ForEach(
          this.handleList,
          (item: handle) => {
            ListItem() {
              Flex({ justifyContent: FlexAlign.Center }) {
                Button(){
                  Text(item.title)
                    .fontSize(16)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })  // Text组件支持textOverflow
                    .width('100%')
                    .textAlign(TextAlign.Center)
                }
                .onClick(item.onclick)
                .width('100%')
                .height(45)
                .backgroundColor('#98FB98')
                .borderRadius(22)
              }
            }
            .width('100%') // 按钮在列表项中水平居中
            .padding({ top: 8, bottom: 8 })
          },
          (item: handle) => item.title
        )
      }
      .height('50%')
      .padding(20)
      //日志显示区域
      Scroll() {
        Text(this.log)
          .fontSize(14)
          .width('100%')
          .padding(10)
      }
      .height('30%')
      .width('100%')
      .border({width:1,color:'#eee'})
      .borderRadius(5)
      Button('clear')
        .onClick(() => this.clearLog())
        .height('10%')
      Button('返回主界面')
        .onClick(() => router.back())
        .fontSize(16)
        .width('80%')
        .height(45)
        .backgroundColor('#ff4757')
        .borderRadius(22)
    }
  }
}
