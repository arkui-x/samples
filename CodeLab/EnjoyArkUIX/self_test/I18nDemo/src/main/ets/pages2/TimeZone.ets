import router from '@ohos.router';
import { BusinessError } from '@kit.BasicServicesKit';
import { i18n } from '@kit.LocalizationKit';

export interface handle {
  title: string
  onclick: () => void;
}


@Entry
@Component
struct TimeZoneTest {
  @State log: string = '';

  // 日志显示格式：添加带时间戳的日志
  private addLog(content: string) {
    this.log += `[${new Date().toLocaleTimeString()}] ${content}\n`;
  }

  // 清空日志
  private clearLog(): void {
    this.log = '';
  }

  @State message: string = 'Timezone测试';

   testi18nimeZonegetDisplayName001(): void {
    try {
      console.info(' testi18nimeZonegetDisplayName001 开始')
      this.addLog(" testi18nimeZonegetDisplayName001 开始");
      let timezone: i18n.TimeZone = i18n.getTimeZone('Asia/Shanghai');
      let timezoneName: string = timezone.getDisplayName('zh-CN', false);
      this.addLog('获取时区对象名称在zh-CN语言下的翻译，并且不显示夏令时')
      this.addLog(timezoneName)
      console.info(' testi18nimeZonegetDisplayName001 调用成功')
      this.addLog(' testi18nimeZonegetDisplayName001 调用成功')

    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.info('报错')
      console.error(`call TimeZone. testi18nimeZonegetDisplayName001 failed, error code: ${err.code}, message: ${err.message}.`);
    }


  }
  testi18nimeZonegetDisplayName004(): void {
    try {
      console.info(' testi18nimeZonegetDisplayName002 开始')
      this.addLog(" testi18nimeZonegetDisplayName002 开始");
      let timezone: i18n.TimeZone = i18n.getTimeZone('Asia/Shanghai');
      let timezoneName: string = timezone.getDisplayName('en-US', false);
      this.addLog('获取时区对象名称在zh-CN语言下的翻译，并且不显示夏令时')
      this.addLog(timezoneName)
      console.info(' testi18nimeZonegetDisplayName002 调用成功')
      this.addLog(' testi18nimeZonegetDisplayName002 调用成功')

    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.info('报错')
      console.error(`call TimeZone. testi18nimeZonegetDisplayName001 failed, error code: ${err.code}, message: ${err.message}.`);
    }


  }
  testi18nimeZonegetDisplayName005(): void {
    try {
      console.info(' testi18nimeZonegetDisplayName003 开始')
      this.addLog(" testi18nimeZonegetDisplayName003 开始");
      let timezone: i18n.TimeZone = i18n.getTimeZone('Asia/Shanghai');
      let timezoneName: string = timezone.getDisplayName('ar-Arab', false);
      this.addLog('获取时区对象名称在zh-CN语言下的翻译，并且不显示夏令时')
      this.addLog(timezoneName)
      console.info(timezoneName)
      console.info(' testi18nimeZonegetDisplayName003 调用成功')
      this.addLog(' testi18nimeZonegetDisplayName003 调用成功')

    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.info('报错')
      console.error(`call TimeZone. testi18nimeZonegetDisplayName001 failed, error code: ${err.code}, message: ${err.message}.`);
    }


  }

   testi18nimeZonegetDisplayName002(): void {
    try {
      console.info(' testi18nimeZonegetDisplayName004 开始')
      this.addLog(" testi18nimeZonegetDisplayName004 开始");
      let timezone: i18n.TimeZone = i18n.getTimeZone('Asia/Shanghai');
      let timezoneName: string = timezone.getDisplayName();
      this.addLog(timezoneName)
      this.addLog('获取时区对象名称在系统默认语言下的翻译')
      console.info(' testi18nimeZonegetDisplayName004 调用成功')
      this.addLog(" testi18nimeZonegetDisplayName004 调用成功");
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.info('报错')
      console.error(`call TimeZone. testi18nimeZonegetDisplayName002 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

   testi18nimeZonegetDisplayName003(): void {
    try {
      console.info(' testi18nimeZonegetDisplayName005 开始')
      this.addLog(" testi18nimeZonegetDisplayName005 开始");
      let timezone: i18n.TimeZone = i18n.getTimeZone('Asia/Shanghai');
      let timezoneName: string = timezone.getDisplayName('zh-CN');
      this.addLog(timezoneName)
      this.addLog('获取时区对象名称在zh-CN语言下的翻译，显示夏令时')
      console.info(' testi18nimeZonegetDisplayName005 调用成功')
      this.addLog(" testi18nimeZonegetDisplayName005 调用成功");
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.info('报错')
      console.error(`call TimeZone. testi18nimeZonegetDisplayName003 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }


  // testi18nimeZonegetAvailableZoneCityIDs001(): void {
  //   try {
  //     console.info('testi18nimeZonegetAvailableZoneCityIDs001 开始')
  //     this.addLog("testi18nimeZonegetAvailableZoneCityIDs001 开始");
  //     let cityIDs: Array<string> = i18n.TimeZone.getAvailableZoneCityIDs();
  //     console.info('testi18nimeZonegetAvailableZoneCityIDs001 调用成功')
  //
  //     this.addLog("获取系统支持的时区城市ID列表");
  //     for(const val of cityIDs){
  //       this.addLog(val)
  //     }
  //     this.addLog("testi18nimeZonegetAvailableZoneCityIDs001 调用成功");
  //   } catch (error) {
  //     let err: BusinessError = error as BusinessError;
  //     console.info('报错')
  //     console.error(`call TimeZone.testi18nimeZonegetAvailableZoneCityIDs001 failed, error code: ${err.code}, message: ${err.message}.`);
  //   }
  // }

  //  testi18nimeZonegetCityDisplayName001(): void {
  //   try {
  //     console.info(' testi18nimeZonegetCityDisplayName001 开始')
  //     this.addLog(" testi18nimeZonegetCityDisplayName001 开始");
  //     let displayName: string = i18n.TimeZone.getCityDisplayName('Shanghai', 'zh-CN');
  //
  //     this.addLog("获取时区城市名称在指定语言下的翻译");
  //     this.addLog(displayName);
  //     console.info(' testi18nimeZonegetCityDisplayName001 调用成功')
  //     this.addLog(" testi18nimeZonegetCityDisplayName001 调用成功");
  //   } catch (error) {
  //     let err: BusinessError = error as BusinessError;
  //     console.info('报错')
  //     console.error(`call TimeZone. testi18nimeZonegetCityDisplayName001 failed, error code: ${err.code}, message: ${err.message}.`);
  //   }
  // }


  //  testi18nimeZonegetTimezoneFromCity001(): void {
  //   try {
  //     console.info(' testi18nimeZonegetTimezoneFromCity001 开始')
  //     this.addLog(" testi18nimeZonegetTimezoneFromCity001 开始");
  //     this.addLog(" 创建对应时区城市的时区对象");
  //     let timezone: i18n.TimeZone = i18n.TimeZone.getTimezoneFromCity('Shanghai');
  //     console.info(' testi18nimeZonegetTimezoneFromCity001 调用成功')
  //    if(timezone!=null){
  //      this.addLog("对应时区城市的时区对象实例不为空");
  //      this.addLog(" testi18nimeZonegetTimezoneFromCity001 调用成功");
  //    }else{
  //      this.addLog("对应时区城市的时区对象实例为空");
  //      return;
  //    }
  //
  //   } catch (error) {
  //     let err: BusinessError = error as BusinessError;
  //     console.info('报错')
  //     console.error(`call TimeZone. testi18nimeZonegetTimezoneFromCity001 failed, error code: ${err.code}, message: ${err.message}.`);
  //   }
  // }

  // testi18nimeZonegetTimezonesByLocation001(): void {
  //   try {
  //     console.info('  testi18nimeZonegetTimezonesByLocation001 开始')
  //     this.addLog("  testi18nimeZonegetTimezonesByLocation001 开始");
  //
  //     this.addLog("创建地理位置对应的时区对象数组");
  //     let timezoneArray: Array<i18n.TimeZone> = i18n.TimeZone.getTimezonesByLocation(40, 30);
  //     console.info('  testi18nimeZonegetTimezonesByLocation001 调用成功')
  //     if(timezoneArray!=null){
  //       this.addLog("创建地理位置对应的时区对象数组不为空");
  //       this.addLog("  testi18nimeZonegetTimezonesByLocation001 调用成功");
  //     }else{
  //       this.addLog("创建地理位置对应的时区对象数组实例为空");
  //       return;
  //     }
  //
  //   } catch (error) {
  //     let err: BusinessError = error as BusinessError;
  //     console.info('报错')
  //     console.error(`call TimeZone.  testi18nimeZonegetTimezonesByLocation001 failed, error code: ${err.code}, message: ${err.message}.`);
  //   }
  // }
  //
  //   testi18nimeZonegetTimezonesByLocation002(): void {
  //   console.info('  testi18nimeZonegetTimezonesByLocation002 开始')
  //   try {
  //     let timezoneArray: Array<i18n.TimeZone> = i18n.TimeZone.getTimezonesByLocation(null, 40);
  //     console.info('  testi18nimeZonegetTimezonesByLocation002 调用成功')
  //   } catch (err) {
  //     console.error('getTimezonesByLocation fail');
  //     console.error(`${err.code}`);
  //     this.addLog(`${err.code + err.message} `);
  //     this.addLog('testi18nimeZonegetTimezonesByLocation002 fail');
  //   }
  // }
  //
  //   testi18nimeZonegetTimezonesByLocation003(): void {
  //   console.info('  testi18nimeZonegetTimezonesByLocation003 开始')
  //   try {
  //     let timezoneArray: Array<i18n.TimeZone> = i18n.TimeZone.getTimezonesByLocation(undefined, 40);
  //     console.info('  testi18nimeZonegetTimezonesByLocation003 调用成功')
  //   } catch (err) {
  //     console.error('getTimezonesByLocation fail');
  //     console.error(`${err.code}`);
  //     this.addLog(`${err.code + err.message} `);
  //     this.addLog('testi18nimeZonegetTimezonesByLocation003 fail');
  //   }
  //
  // }
  //
  //   testi18nimeZonegetTimezonesByLocation004(): void {
  //   console.info('  testi18nimeZonegetTimezonesByLocation004 开始')
  //   try {
  //     let timezoneArray: Array<i18n.TimeZone> = i18n.TimeZone.getTimezonesByLocation(56, null);
  //     console.info('  testi18nimeZonegetTimezonesByLocation004 调用成功')
  //   } catch (err) {
  //     console.error('getTimezonesByLocation fail');
  //     console.error(`${err.code}`);
  //     this.addLog(`${err.code + err.message} `);
  //     this.addLog('testi18nimeZonegetTimezonesByLocation004 fail');
  //   }
  // }
  //
  //   testi18nimeZonegetTimezonesByLocation005(): void {
  //   console.info('  testi18nimeZonegetTimezonesByLocation005 开始')
  //   try {
  //     let timezoneArray: Array<i18n.TimeZone> = i18n.TimeZone.getTimezonesByLocation(59, undefined);
  //     console.info('  testi18nimeZonegetTimezonesByLocation005 调用成功')
  //   } catch (err) {
  //     console.error('getTimezonesByLocation fail');
  //     console.error(`${err.code}`);
  //     this.addLog(`${err.code + err.message} `);
  //     this.addLog('testi18nimeZonegetTimezonesByLocation005 fail');
  //   }
  // }
  //
  //   testi18nimeZonegetTimezonesByLocation006(): void {
  //   console.info('  testi18nimeZonegetTimezonesByLocation006 开始')
  //   try {
  //     let timezoneArray: Array<i18n.TimeZone> = i18n.TimeZone.getTimezonesByLocation(190, 40);
  //     console.info('  testi18nimeZonegetTimezonesByLocation006 调用成功')
  //   } catch (err) {
  //     console.error('getTimezonesByLocation fail');
  //     console.error(`${err.code}`);
  //     this.addLog(`${err.code + err.message} `);
  //     this.addLog('testi18nimeZonegetTimezonesByLocation006 fail');
  //   }
  // }
  //
  //   testi18nimeZonegetTimezonesByLocation007(): void {
  //   console.info('  testi18nimeZonegetTimezonesByLocation007 开始')
  //   try {
  //     let timezoneArray: Array<i18n.TimeZone> = i18n.TimeZone.getTimezonesByLocation(-200, 40);
  //     console.info('  testi18nimeZonegetTimezonesByLocation007 调用成功')
  //   } catch (err) {
  //     console.error('getTimezonesByLocation fail');
  //     console.error(`${err.code}`);
  //     this.addLog(`${err.code + err.message} `);
  //     this.addLog('testi18nimeZonegetTimezonesByLocation007 fail');
  //   }
  // }
  //
  //   testi18nimeZonegetTimezonesByLocation008(): void {
  //   try {
  //     console.info('  testi18nimeZonegetTimezonesByLocation008 开始')
  //     this.addLog("  testi18nimeZonegetTimezonesByLocation008 开始");
  //     let timezoneArray: Array<i18n.TimeZone> = i18n.TimeZone.getTimezonesByLocation(60, 120);
  //     console.info('  testi18nimeZonegetTimezonesByLocation008 调用成功')
  //   }catch (err) {
  //     console.error('getTimezonesByLocation fail');
  //     console.error(`${err.code}`);
  //     this.addLog(`${err.code + err.message} `);
  //     this.addLog('testi18nimeZonegetTimezonesByLocation008 fail');
  //   }
  // }
  //
  //   testi18nimeZonegetTimezonesByLocation009(): void {
  //   try {
  //     console.info('  testi18nimeZonegetTimezonesByLocation009 开始')
  //     let timezoneArray: Array<i18n.TimeZone> = i18n.TimeZone.getTimezonesByLocation(70, -100);
  //     console.info('  testi18nimeZonegetTimezonesByLocation009 调用成功')
  //   } catch (err) {
  //     console.error('getTimezonesByLocation fail');
  //     console.error(`${err.code}`);
  //     this.addLog(`${err.code + err.message} `);
  //     this.addLog('testi18nimeZonegetTimezonesByLocation009 fail');
  //   }
  // }

   testi18nimeZonegetZoneRules001(): void {
    try {
      console.info(' testi18nimeZonegetZoneRules001 开始')
      this.addLog(" testi18nimeZonegetZoneRules001 开始");
      let tzId: string = 'America/Tijuana';
      let timeZone: i18n.TimeZone = i18n.getTimeZone(tzId);
      this.addLog("获取时区跳变规则");
      let zoneRules: i18n.ZoneRules = timeZone.getZoneRules();
      console.info(' testi18nimeZonegetZoneRules001 调用成功')
      if(zoneRules!=null){
        this.addLog("获取时区跳变规则不为空");
        this.addLog(" testi18nimeZonegetZoneRules001 调用成功");
      }else{
        this.addLog("获取时区跳变规则为空");
        return;
      }

    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.info('报错')
      console.error(`call TimeZone. testi18nimeZonegetZoneRules001 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  private handleList: handle[] = [
    { title: ' testi18nimeZonegetDisplayName001', onclick: () => this. testi18nimeZonegetDisplayName001() },
    { title: ' testi18nimeZonegetDisplayName002', onclick: () => this. testi18nimeZonegetDisplayName004() },
    { title: ' testi18nimeZonegetDisplayName003', onclick: () => this. testi18nimeZonegetDisplayName005() },
    { title: ' testi18nimeZonegetDisplayName004', onclick: () => this. testi18nimeZonegetDisplayName002() },
    { title: ' testi18nimeZonegetDisplayName005', onclick: () => this. testi18nimeZonegetDisplayName003() },
    // { title: ' testi18nimeZonegetAvailableZoneCityIDs001', onclick: () => this.testi18nimeZonegetAvailableZoneCityIDs001() },
    // { title: ' testi18nimeZonegetCityDisplayName001', onclick: () => this. testi18nimeZonegetCityDisplayName001() },
    // { title: ' testi18nimeZonegetTimezoneFromCity001', onclick: () => this. testi18nimeZonegetTimezoneFromCity001() },
    // { title: ' testi18nimeZonegetTimezonesByLocation001', onclick: () => this.  testi18nimeZonegetTimezonesByLocation001() },
    // { title: ' testi18nimeZonegetTimezonesByLocation002', onclick: () => this.  testi18nimeZonegetTimezonesByLocation002() },
    // { title: ' testi18nimeZonegetTimezonesByLocation003', onclick: () => this.  testi18nimeZonegetTimezonesByLocation003() },
    // { title: ' testi18nimeZonegetTimezonesByLocation004', onclick: () => this.  testi18nimeZonegetTimezonesByLocation004() },
    // { title: ' testi18nimeZonegetTimezonesByLocation005', onclick: () => this.  testi18nimeZonegetTimezonesByLocation005() },
    // { title: ' testi18nimeZonegetTimezonesByLocation006', onclick: () => this.  testi18nimeZonegetTimezonesByLocation006() },
    // { title: ' testi18nimeZonegetTimezonesByLocation007', onclick: () => this.  testi18nimeZonegetTimezonesByLocation007() },
    // { title: ' testi18nimeZonegetTimezonesByLocation008', onclick: () => this.  testi18nimeZonegetTimezonesByLocation008() },
    // { title: ' testi18nimeZonegetTimezonesByLocation009', onclick: () => this.  testi18nimeZonegetTimezonesByLocation009() },
    { title: ' testi18nimeZonegetZoneRules001', onclick: () => this. testi18nimeZonegetZoneRules001() },

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
      .border({ width: 1, color: '#eee' })
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
