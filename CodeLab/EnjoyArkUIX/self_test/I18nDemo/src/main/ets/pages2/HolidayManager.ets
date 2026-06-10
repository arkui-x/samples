
import { BusinessError } from '@kit.BasicServicesKit';
import { i18n } from '@kit.LocalizationKit';
import router from '@ohos.router';
import { common } from '@kit.AbilityKit';
import featureAbility from '@ohos.ability.featureAbility';
import fs from '@ohos.file.fs';
import deviceInfo from '@ohos.deviceInfo';
import fileIo from '@ohos.file.fs';

let platform: string = deviceInfo.osFullName.split(' ')[0];
let isAndroid: boolean = platform.includes("Android");
let isiOS: boolean = platform.includes("iOS");
let isOH: boolean = platform.includes("OpenHarmony");

export interface handle {
  title: string
  onclick: () => void;
}

@Entry
@Component
struct HolidayManagerTest {
  @State log: string = '';
  // 日志显示格式：添加带时间戳的日志
  private addLog(content: string) {
    this.log += `[${new Date().toLocaleTimeString()}] ${content}\n`;
  }
  // 清空日志
  private clearLog(): void {
    this.log = '';
  }
  @State message: string = 'HolidayManager测试';
  testi18nHolidayManagerconstructor001(): void {
     this.addLog('testi18nHolidayManagerconstructor001 开始')
    try {
      let icsPath = "/system/lib/reso.ics";
      const context = AppStorage.get<common.UIAbilityContext>("EntryAbilityContext") as common.UIAbilityContext;

      icsPath = context.filesDir+'/reso.ics';
      let data = this.getUIContext().getHostContext()?.resourceManager.getRawFileContentSync("reso.ics")
      let fd = fileIo.openSync(this.getUIContext().getHostContext()?.filesDir + '/reso.ics', fileIo.OpenMode.CREATE |
      fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.TRUNC)
      fileIo.writeSync(fd.fd, data?.buffer)
      fileIo.closeSync(fd)

      console.info(context.resourceDir)
      let holidayManager = new i18n.HolidayManager(icsPath)
      if(holidayManager!=null){
        this.addLog('创建HolidayManager对象实例不为空')
        this.addLog('testi18nHolidayManagerconstructor001 调用成功')
      }

    } catch (error) {
      let err: BusinessError = error as BusinessError;
       this.addLog('报错')
      console.error(`call TimeZone.testi18nHolidayManagerconstructor001 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }
  testi18nHolidayManagerisHoliday001(): void {
     this.addLog('testi18nHolidayManagerisHoliday001 开始')
     console.info('testi18nHolidayManagerisHoliday001 开始')
    try {
      let icsPath = "/system/lib/reso.ics";
      const context = AppStorage.get<common.UIAbilityContext>("EntryAbilityContext") as common.UIAbilityContext;

      icsPath = context.filesDir+'/reso.ics';
      let data = this.getUIContext().getHostContext()?.resourceManager.getRawFileContentSync("reso.ics")
      let fd = fileIo.openSync(this.getUIContext().getHostContext()?.filesDir + '/reso.ics', fileIo.OpenMode.CREATE |
      fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.TRUNC)
      fileIo.writeSync(fd.fd, data?.buffer)
      fileIo.closeSync(fd)


      console.info(context.resourceDir)
      let holidayManager = new i18n.HolidayManager(icsPath)
      console.info(icsPath)
      this.addLog(' 判断指定的日期是否是节假日')
     let isHoliday = holidayManager.isHoliday(new Date(2023,0,1))
      this.addLog(`${isHoliday}`)
      if(isHoliday===false)
       this.addLog('testi18nHolidayManagerisHoliday001 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
       this.addLog('报错')
      console.error(`call TimeZone.testi18nHolidayManagerisHoliday001 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }
  testi18nHolidayManagerisHoliday002(): void {
     this.addLog('testi18nHolidayManagerisHoliday002 开始')
     console.info('testi18nHolidayManagerisHoliday002 开始')
    try {
      let icsPath = "/system/lib/reso.ics";
      const context = AppStorage.get<common.UIAbilityContext>("EntryAbilityContext") as common.UIAbilityContext;

      icsPath = context.filesDir+'/reso.ics';
      let data = this.getUIContext().getHostContext()?.resourceManager.getRawFileContentSync("reso.ics")
      let fd = fileIo.openSync(this.getUIContext().getHostContext()?.filesDir + '/reso.ics', fileIo.OpenMode.CREATE |
      fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.TRUNC)
      fileIo.writeSync(fd.fd, data?.buffer)
      fileIo.closeSync(fd)

      console.info(context.resourceDir)
      let holidayManager = new i18n.HolidayManager(icsPath)
      this.addLog(' 判断当前日期是否是节假日')
      console.info('testi18nHolidayManagerisHoliday00343')
      let isHoliday = holidayManager.isHoliday()
      console.info('testi18nHolidayManagerisHoliday001233')
      this.addLog(isHoliday.toString())
      if(isHoliday===false)
       this.addLog('testi18nHolidayManagerisHoliday002 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
       this.addLog('报错')
      console.error(`call TimeZone.testi18nHolidayManagerisHoliday002 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  testi18nHolidayManagerisHoliday003(): void {
    this.addLog('testi18nHolidayManagerisHoliday003 开始')
    try {
      let icsPath = "/system/lib/reso.ics";
      const context = AppStorage.get<common.UIAbilityContext>("EntryAbilityContext") as common.UIAbilityContext;

      icsPath = context.filesDir+'/reso.ics';
      let data = this.getUIContext().getHostContext()?.resourceManager.getRawFileContentSync("reso.ics")
      let fd = fileIo.openSync(this.getUIContext().getHostContext()?.filesDir + '/reso.ics', fileIo.OpenMode.CREATE |
      fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.TRUNC)
      fileIo.writeSync(fd.fd, data?.buffer)
      fileIo.closeSync(fd)

      console.info(context.resourceDir)
      let holidayManager = new i18n.HolidayManager(icsPath)
      this.addLog(' 判断当前日期是否是节假日')
      let isHoliday = holidayManager.isHoliday(new Date(456.123,1.23,4.56))
      this.addLog(isHoliday.toString())
      if(isHoliday===false)
        this.addLog('testi18nHolidayManagerisHoliday003 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call TimeZone.testi18nHolidayManagerisHoliday002 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }
  testi18nHolidayManagergetHolidayInfoItemArray001(): void {
     this.addLog('testi18nHolidayManagergetHolidayInfoItemArray001 开始')
    try {
      let icsPath = "/system/lib/reso.ics";
      const context = AppStorage.get<common.UIAbilityContext>("EntryAbilityContext") as common.UIAbilityContext;

      icsPath = context.filesDir+'/reso.ics';
      let data = this.getUIContext().getHostContext()?.resourceManager.getRawFileContentSync("reso.ics")
      let fd = fileIo.openSync(this.getUIContext().getHostContext()?.filesDir + '/reso.ics', fileIo.OpenMode.CREATE |
      fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.TRUNC)
      fileIo.writeSync(fd.fd, data?.buffer)
      fileIo.closeSync(fd)


      console.info(context.resourceDir)
      let holidayManager = new i18n.HolidayManager(icsPath)
      this.addLog('获取指定年的节假日信息列表')
      let holidayInfoItemArray: Array<i18n.HolidayInfoItem> = holidayManager.getHolidayInfoItemArray(2023);
      if(holidayInfoItemArray!=null){
        this.addLog('获取指定年的节假日信息列表不为空')
        for(const val of holidayInfoItemArray){
          this.addLog(val.baseName)
        }
        this.addLog('testi18nHolidayManagergetHolidayInfoItemArray001 调用成功')
      }else{
        this.addLog('获取指定年的节假日信息列表为空')
        return;
      }

    } catch (error) {
      let err: BusinessError = error as BusinessError;
       this.addLog('报错')
      console.error(`call TimeZone.testi18nHolidayManagergetHolidayInfoItemArray001 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }
  testi18nHolidayManagergetHolidayInfoItemArray002(): void {
     this.addLog('testi18nHolidayManagergetHolidayInfoItemArray002 开始')
    try {
      let icsPath = "/system/lib/reso.ics";
      const context = AppStorage.get<common.UIAbilityContext>("EntryAbilityContext") as common.UIAbilityContext;

      icsPath = context.filesDir+'/reso.ics';
      let data = this.getUIContext().getHostContext()?.resourceManager.getRawFileContentSync("reso.ics")
      let fd = fileIo.openSync(this.getUIContext().getHostContext()?.filesDir + '/reso.ics', fileIo.OpenMode.CREATE |
      fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.TRUNC)
      fileIo.writeSync(fd.fd, data?.buffer)
      fileIo.closeSync(fd)


      console.info(context.resourceDir)
      let holidayManager = new i18n.HolidayManager(icsPath)
      this.addLog('获取当前年份的节假日信息列表')
      let holidayInfoItemArray: Array<i18n.HolidayInfoItem> = holidayManager.getHolidayInfoItemArray();
      if(holidayInfoItemArray!=null){
        this.addLog('获取前年份的节假日信息列表不为空')
        for(const val of holidayInfoItemArray){
          this.addLog(val.baseName)
        }
        this.addLog('testi18nHolidayManagergetHolidayInfoItemArray002 调用成功')
      }else{
        this.addLog('获取指定年的节假日信息列表为空')
        return;
      }
    } catch (error) {
      let err: BusinessError = error as BusinessError;
       this.addLog('报错')
      console.error(`call TimeZone.testi18nHolidayManagergetHolidayInfoItemArray002 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }
  testi18nHolidayManagergetHolidayInfoItemArray003(): void {
     this.addLog('testi18nHolidayManagergetHolidayInfoItemArray003 开始')
    try {
      let icsPath = "/system/lib/reso.ics";
      const context = AppStorage.get<common.UIAbilityContext>("EntryAbilityContext") as common.UIAbilityContext;

      icsPath = context.filesDir+'/reso.ics';
      let data = this.getUIContext().getHostContext()?.resourceManager.getRawFileContentSync("reso.ics")
      let fd = fileIo.openSync(this.getUIContext().getHostContext()?.filesDir + '/reso.ics', fileIo.OpenMode.CREATE |
      fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.TRUNC)
      fileIo.writeSync(fd.fd, data?.buffer)
      fileIo.closeSync(fd)


      console.info(context.resourceDir)
      let holidayManager = new i18n.HolidayManager(icsPath)
      let holidayInfoItemArray: Array<i18n.HolidayInfoItem> = holidayManager.getHolidayInfoItemArray(-1);
       this.addLog('testi18nHolidayManagergetHolidayInfoItemArray003 调用成功')
    }  catch (err) {
      console.error('normalize fail');
      console.error(`${err.code}`);
      this.addLog(`${err.code + err.message} `);
      this.addLog('testi18nHolidayManagergetHolidayInfoItemArray003 fail');
    }
  }
  testi18nHolidayManagergetHolidayInfoItemArray004(): void {
     this.addLog('testi18nHolidayManagergetHolidayInfoItemArray004 开始')
    try {
      let icsPath = "/system/lib/reso.ics";
      const context = AppStorage.get<common.UIAbilityContext>("EntryAbilityContext") as common.UIAbilityContext;

      icsPath = context.filesDir+'/reso.ics';
      let data = this.getUIContext().getHostContext()?.resourceManager.getRawFileContentSync("reso.ics")
      let fd = fileIo.openSync(this.getUIContext().getHostContext()?.filesDir + '/reso.ics', fileIo.OpenMode.CREATE |
      fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.TRUNC)
      fileIo.writeSync(fd.fd, data?.buffer)
      fileIo.closeSync(fd)


      console.info(context.resourceDir)
      let holidayManager = new i18n.HolidayManager(icsPath)
      let holidayInfoItemArray: Array<i18n.HolidayInfoItem> = holidayManager.getHolidayInfoItemArray(-3.5);
       this.addLog('testi18nHolidayManagergetHolidayInfoItemArray004 调用成功')
    }  catch (err) {
      console.error('normalize fail');
      console.error(`${err.code}`);
      this.addLog(`${err.code + err.message} `);
      this.addLog('testi18nHolidayManagergetHolidayInfoItemArray004 fail');
    }
  }



  private handleList: handle[] = [
    { title: 'testi18nHolidayManagerconstructor001', onclick: () => this.testi18nHolidayManagerconstructor001() },
    { title: 'testi18nHolidayManagerisHoliday001', onclick: () => this.testi18nHolidayManagerisHoliday001() },
    { title: 'testi18nHolidayManagerisHoliday002', onclick: () => this.testi18nHolidayManagerisHoliday002() },
    { title: 'testi18nHolidayManagerisHoliday003', onclick: () => this.testi18nHolidayManagerisHoliday003() },
    { title: 'testi18nHolidayManagergetHolidayInfoItemArray001', onclick: () => this.testi18nHolidayManagergetHolidayInfoItemArray001() },
    { title: 'testi18nHolidayManagergetHolidayInfoItemArray002', onclick: () => this.testi18nHolidayManagergetHolidayInfoItemArray002() },
    { title: 'testi18nHolidayManagergetHolidayInfoItemArray003', onclick: () => this.testi18nHolidayManagergetHolidayInfoItemArray003() },
    { title: 'testi18nHolidayManagergetHolidayInfoItemArray004', onclick: () => this.testi18nHolidayManagergetHolidayInfoItemArray004() },
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
