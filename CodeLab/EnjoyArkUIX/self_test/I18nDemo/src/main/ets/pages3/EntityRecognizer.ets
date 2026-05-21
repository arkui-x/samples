import { BusinessError } from '@kit.BasicServicesKit';
import { i18n } from '@kit.LocalizationKit';
import { expect } from '@ohos/hypium';
import router from '@ohos.router';
interface ButtonItem {
  label: string;
  onClick: () => void;
}

@Entry
@Component
struct EntityRecognizer {

  @State log: string = '';

  // 日志显示格式：添加带时间戳的日志
  private addLog(content: string) {
    this.log += `[${new Date().toLocaleTimeString()}] ${content}\n`;
  }

  // 清空日志
  private clearLog(): void {
    this.log = '';
    this.addLog('日志已清除');
    console.info('页面日志已清除');
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

  testEntityRecognizerConstructor001() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('zh-CN');
      let phoneNumberText: string = '如有疑问，请联系15812342312';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      console.info(`识别结果: phoneNumberEntity phone_number is ${phoneNumberEntity[0].type}`);
      console.info(`识别结果: phoneNumberEntity begin is ${phoneNumberEntity[0].begin}`);
      console.info(`识别结果: phoneNumberEntity end is ${phoneNumberEntity[0].end}`);
      this.addLog(`phoneNumberEntity[0].type为：${phoneNumberEntity[0].type} ，phoneNumberEntity[0].begin为：${phoneNumberEntity[0].begin}，phoneNumberEntity[0].end为：${phoneNumberEntity[0].end}`);
      if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 8&&phoneNumberEntity[0].end == 19){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerconstructor002() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('en-US');
      let phoneNumberText: string = '如有疑问，请联系15812342312';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      console.info(`识别结果: phoneNumberEntity phone_number is ${phoneNumberEntity[0].type}`);
      console.info(`识别结果: phoneNumberEntity begin is ${phoneNumberEntity[0].begin}`);
      console.info(`识别结果: phoneNumberEntity end is ${phoneNumberEntity[0].end}`);
      this.addLog(`phoneNumberEntity[0].type为：${phoneNumberEntity[0].type} ，phoneNumberEntity[0].begin为：${phoneNumberEntity[0].begin}，phoneNumberEntity[0].end为：${phoneNumberEntity[0].end}`);
      if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 8&&phoneNumberEntity[0].end == 19){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerconstructor003() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('de-DE');
      let phoneNumberText: string = '如有疑问，请联系15812342312';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      console.info(`识别结果: phoneNumberEntity phone_number is ${phoneNumberEntity[0].type}`);
      console.info(`识别结果: phoneNumberEntity begin is ${phoneNumberEntity[0].begin}`);
      console.info(`识别结果: phoneNumberEntity end is ${phoneNumberEntity[0].end}`);
      this.addLog(`phoneNumberEntity[0].type为：${phoneNumberEntity[0].type} ，phoneNumberEntity[0].begin为：${phoneNumberEntity[0].begin}，phoneNumberEntity[0].end为：${phoneNumberEntity[0].end}`);
      if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 8&&phoneNumberEntity[0].end == 19){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerconstructor004() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('fr');
      let phoneNumberText: string = '如有疑问，请联系15812342312';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      this.addLog(`识别结果: phoneNumberEntity phone_number is ${phoneNumberEntity[0].type}`);
      this.addLog(`识别结果: phoneNumberEntity begin is ${phoneNumberEntity[0].begin}`);
      this.addLog(`识别结果: phoneNumberEntity end is ${phoneNumberEntity[0].end}`);
      this.addLog(`phoneNumberEntity[0].type为：${phoneNumberEntity[0].type} ，phoneNumberEntity[0].begin为：${phoneNumberEntity[0].begin}，phoneNumberEntity[0].end为：${phoneNumberEntity[0].end}`);
      if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 8&&phoneNumberEntity[0].end == 19){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerconstructor005() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('es');
      let phoneNumberText: string = '如有疑问，请联系15812342312';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      console.info(`识别结果: phoneNumberEntity phone_number is ${phoneNumberEntity[0].type}`);
      console.info(`识别结果: phoneNumberEntity begin is ${phoneNumberEntity[0].begin}`);
      console.info(`识别结果: phoneNumberEntity end is ${phoneNumberEntity[0].end}`);
      this.addLog(`phoneNumberEntity[0].type为：${phoneNumberEntity[0].type} ，phoneNumberEntity[0].begin为：${phoneNumberEntity[0].begin}，phoneNumberEntity[0].end为：${phoneNumberEntity[0].end}`);
      if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 8&&phoneNumberEntity[0].end == 19){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerconstructor006() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('it');
      let phoneNumberText: string = '如有疑问，请联系15812342312';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      console.info(`识别结果: phoneNumberEntity phone_number is ${phoneNumberEntity[0].type}`);
      console.info(`识别结果: phoneNumberEntity begin is ${phoneNumberEntity[0].begin}`);
      console.info(`识别结果: phoneNumberEntity end is ${phoneNumberEntity[0].end}`);
      this.addLog(`phoneNumberEntity[0].type为：${phoneNumberEntity[0].type} ，phoneNumberEntity[0].begin为：${phoneNumberEntity[0].begin}，phoneNumberEntity[0].end为：${phoneNumberEntity[0].end}`);
      if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 8&&phoneNumberEntity[0].end == 19){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerconstructor007() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('ar-SA');
      let phoneNumberText: string = '如有疑问，请联系15812342312';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      console.info(`识别结果: phoneNumberEntity phone_number is ${phoneNumberEntity[0].type}`);
      console.info(`识别结果: phoneNumberEntity begin is ${phoneNumberEntity[0].begin}`);
      console.info(`识别结果: phoneNumberEntity end is ${phoneNumberEntity[0].end}`);
      this.addLog(`phoneNumberEntity[0].type为：${phoneNumberEntity[0].type} ，phoneNumberEntity[0].begin为：${phoneNumberEntity[0].begin}，phoneNumberEntity[0].end为：${phoneNumberEntity[0].end}`);
      if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 8&&phoneNumberEntity[0].end == 19){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerconstructor008() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer();
      let phoneNumberText: string = '如有疑问，请联系15812342312';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      console.info(`识别结果: phoneNumberEntity phone_number is ${phoneNumberEntity[0].type}`);
      console.info(`识别结果: phoneNumberEntity begin is ${phoneNumberEntity[0].begin}`);
      console.info(`识别结果: phoneNumberEntity end is ${phoneNumberEntity[0].end}`);
      this.addLog(`phoneNumberEntity[0].type为：${phoneNumberEntity[0].type} ，phoneNumberEntity[0].begin为：${phoneNumberEntity[0].begin}，phoneNumberEntity[0].end为：${phoneNumberEntity[0].end}`);
      if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 8&&phoneNumberEntity[0].end == 19){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
      console.info('调用成功')
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerconstructor009() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('abc');
      let phoneNumberText: string = '如有疑问，请联系15812342312';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      console.info(`识别结果: phoneNumberEntity phone_number is ${phoneNumberEntity[0].type}`);
      console.info(`识别结果: phoneNumberEntity begin is ${phoneNumberEntity[0].begin}`);
      console.info(`识别结果: phoneNumberEntity end is ${phoneNumberEntity[0].end}`);
      this.addLog(`phoneNumberEntity[0].type为：${phoneNumberEntity[0].type} ，phoneNumberEntity[0].begin为：${phoneNumberEntity[0].begin}，phoneNumberEntity[0].end为：${phoneNumberEntity[0].end}`);
      if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 8&&phoneNumberEntity[0].end == 19){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerconstructor010() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('   ');
      let phoneNumberText: string = '如有疑问，请联系15812342312';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      console.info(`识别结果: phoneNumberEntity phone_number is ${phoneNumberEntity[0].type}`);
      console.info(`识别结果: phoneNumberEntity begin is ${phoneNumberEntity[0].begin}`);
      console.info(`识别结果: phoneNumberEntity end is ${phoneNumberEntity[0].end}`);
      this.addLog(`phoneNumberEntity[0].type为：${phoneNumberEntity[0].type} ，phoneNumberEntity[0].begin为：${phoneNumberEntity[0].begin}，phoneNumberEntity[0].end为：${phoneNumberEntity[0].end}`);
      if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 8&&phoneNumberEntity[0].end == 19){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerconstructor011() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('!@#$%');
      let phoneNumberText: string = '如有疑问，请联系15812342312';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      console.info(`识别结果: phoneNumberEntity phone_number is ${phoneNumberEntity[0].type}`);
      console.info(`识别结果: phoneNumberEntity begin is ${phoneNumberEntity[0].begin}`);
      console.info(`识别结果: phoneNumberEntity end is ${phoneNumberEntity[0].end}`);
      this.addLog(`phoneNumberEntity[0].type为：${phoneNumberEntity[0].type} ，phoneNumberEntity[0].begin为：${phoneNumberEntity[0].begin}，phoneNumberEntity[0].end为：${phoneNumberEntity[0].end}`);
      if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 8&&phoneNumberEntity[0].end == 19){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerconstructor012() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('汉字');
      let phoneNumberText: string = '如有疑问，请联系15812342312';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      console.info(`识别结果: phoneNumberEntity phone_number is ${phoneNumberEntity[0].type}`);
      console.info(`识别结果: phoneNumberEntity begin is ${phoneNumberEntity[0].begin}`);
      console.info(`识别结果: phoneNumberEntity end is ${phoneNumberEntity[0].end}`);
      this.addLog(`phoneNumberEntity[0].type为：${phoneNumberEntity[0].type} ，phoneNumberEntity[0].begin为：${phoneNumberEntity[0].begin}，phoneNumberEntity[0].end为：${phoneNumberEntity[0].end}`);
      if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 8&&phoneNumberEntity[0].end == 19){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerconstructor013() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer(undefined);
      let phoneNumberText: string = '如有疑问，请联系15812342312';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      console.info(`识别结果: phoneNumberEntity phone_number is ${phoneNumberEntity[0].type}`);
      console.info(`识别结果: phoneNumberEntity begin is ${phoneNumberEntity[0].begin}`);
      console.info(`识别结果: phoneNumberEntity end is ${phoneNumberEntity[0].end}`);
      this.addLog(`phoneNumberEntity[0].type为：${phoneNumberEntity[0].type} ，phoneNumberEntity[0].begin为：${phoneNumberEntity[0].begin}，phoneNumberEntity[0].end为：${phoneNumberEntity[0].end}`);
      if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 8&&phoneNumberEntity[0].end == 19){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerconstructor014() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('111111111111111');
      let phoneNumberText: string = '如有疑问，请联系15812342312';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      console.info(`识别结果: phoneNumberEntity phone_number is ${phoneNumberEntity[0].type}`);
      console.info(`识别结果: phoneNumberEntity begin is ${phoneNumberEntity[0].begin}`);
      console.info(`识别结果: phoneNumberEntity end is ${phoneNumberEntity[0].end}`);
      this.addLog(`phoneNumberEntity[0].type为：${phoneNumberEntity[0].type} ，phoneNumberEntity[0].begin为：${phoneNumberEntity[0].begin}，phoneNumberEntity[0].end为：${phoneNumberEntity[0].end}`);
      if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 8&&phoneNumberEntity[0].end == 19){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }

  testEntityRecognizerfindEntityInfo001() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('zh-CN');
      let phoneNumberText: string = '如有疑问，请联系15812345678';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      this.addLog(`识别结果: phoneNumberEntity phone_number is ${phoneNumberEntity[0].type}`);
      this.addLog(`识别结果: phoneNumberEntity begin is ${phoneNumberEntity[0].begin}`);
      this.addLog(`识别结果: phoneNumberEntity end is ${phoneNumberEntity[0].end}`);
      this.addLog(`phoneNumberEntity[0].type为：${phoneNumberEntity[0].type} ，phoneNumberEntity[0].begin为：${phoneNumberEntity[0].begin}，phoneNumberEntity[0].end为：${phoneNumberEntity[0].end}`);
      if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 8&&phoneNumberEntity[0].end == 19){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerfindEntityInfo002() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('zh-CN');
      let dateText: string = '我们2023年12月1日一起吃饭吧。';
      let dateEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(dateText);
      this.addLog(`识别结果: dateText date is ${dateEntity[0].type}`);
      this.addLog(`识别结果: dateText begin is ${dateEntity[0].begin}`);
      this.addLog(`识别结果: dateText end is ${dateEntity[0].end}`);
      this.addLog(`dateEntity[0].type为：${dateEntity[0].type} ，dateEntity[0].begin为：${dateEntity[0].begin}，dateEntity[0].end为：${dateEntity[0].end}`);
      if(dateEntity[0].type == 'date'&&dateEntity[0].begin == 2&&dateEntity[0].end == 12){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }

  testEntityRecognizerfindEntityInfo003() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('zh-CN');
      let dateText: string = '"2025 年 11 月 28 日下午 3 点，李四发送邮件至 lisi@example.com"。';
      let dateEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(dateText);
      this.addLog(`识别结果: dateText date is ${dateEntity[0].type}`);
      this.addLog(`识别结果: dateText begin is ${dateEntity[0].begin}`);
      this.addLog(`识别结果: dateText end is ${dateEntity[0].end}`);
      this.addLog(`dateEntity[0].type为：${dateEntity[0].type} ，dateEntity[0].begin为：${dateEntity[0].begin}，dateEntity[0].end为：${dateEntity[0].end}`);
      if(dateEntity[0].type == 'date'&&dateEntity[0].begin == 1&&dateEntity[0].end == 23){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }

  testEntityRecognizerfindEntityInfo004() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('zh-CN');
      let dateText: string = 'Tom 计划 2025-12-31 前往上海，与 Wang Li 会面';
      let dateEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(dateText);
      this.addLog(`识别结果: dateText date is ${dateEntity[0].type}`);
      this.addLog(`识别结果: dateText begin is ${dateEntity[0].begin}`);
      this.addLog(`识别结果: dateText end is ${dateEntity[0].end}`);
      this.addLog(`dateEntity[0].type为：${dateEntity[0].type} ，dateEntity[0].begin为：${dateEntity[0].begin}，dateEntity[0].end为：${dateEntity[0].end}`);
      if(dateEntity[0].type == 'date'&&dateEntity[0].begin == 7&&dateEntity[0].end == 17){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerfindEntityInfo005() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('zh-CN');
      let phoneNumberText: string = '手机号：138-0013-8000，邮箱：zhangsan+tag@example.co.uk';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      this.addLog(`识别结果: phoneNumberEntity phone_number is ${phoneNumberEntity[0].type}`);
      this.addLog(`识别结果: phoneNumberEntity begin is ${phoneNumberEntity[0].begin}`);
      this.addLog(`识别结果: phoneNumberEntity end is ${phoneNumberEntity[0].end}`);
      if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 4&&phoneNumberEntity[0].end == 17){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerfindEntityInfo006() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('zh-CN');
      let phoneNumberText: string = '2025/11/28 14:30:00，张三拨打了 400-888-8888';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      this.addLog(`识别结果: phoneNumberEntity phone_number is ${phoneNumberEntity[0].type}`);
      this.addLog(`识别结果: phoneNumberEntity begin is ${phoneNumberEntity[0].begin}`);
      this.addLog(`识别结果: phoneNumberEntity end is ${phoneNumberEntity[0].end}`);
      if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 26&&phoneNumberEntity[0].end == 38){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerfindEntityInfo007() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('zh-CN');
      let dateText: string = '张三在北京市海淀区中关村大街 1 号腾讯大厦工作。';
      let dateEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(dateText);
      this.addLog(`识别结果: phoneNumberEntity phone_number is ${dateEntity[0].type}`);
      this.addLog(`识别结果: phoneNumberEntity begin is ${dateEntity[0].begin}`);
      this.addLog(`识别结果: phoneNumberEntity end is ${dateEntity[0].end}`);
      if(dateEntity[0].type == 'date'&&dateEntity[0].begin == 2&&dateEntity[0].end == 12){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerfindEntityInfo008() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('zh-CN');
      let dateText: string = '!@#$%';
      let dateEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(dateText);
      this.addLog(`识别结果: phoneNumberEntity phone_number is ${dateEntity[0].type}`);
      this.addLog(`识别结果: phoneNumberEntity begin is ${dateEntity[0].begin}`);
      this.addLog(`识别结果: phoneNumberEntity end is ${dateEntity[0].end}`);
      this.addLog(`dateEntity[0].type为：${dateEntity[0].type} ，dateEntity[0].begin为：${dateEntity[0].begin}，dateEntity[0].end为：${dateEntity[0].end}`);
      if(dateEntity[0].type == 'date'&&dateEntity[0].begin == 2&&dateEntity[0].end == 12){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerfindEntityInfo009() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('zh-CN');
      let dateText: string = '111111111111111';
      let dateEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(dateText);
      this.addLog(`识别结果: phoneNumberEntity phone_number is ${dateEntity[0].type}`);
      this.addLog(`识别结果: phoneNumberEntity begin is ${dateEntity[0].begin}`);
      this.addLog(`识别结果: phoneNumberEntity end is ${dateEntity[0].end}`);
      this.addLog(`dateEntity[0].type为：${dateEntity[0].type} ，dateEntity[0].begin为：${dateEntity[0].begin}，dateEntity[0].end为：${dateEntity[0].end}`);
      if(dateEntity[0].type == 'date'&&dateEntity[0].begin == 2&&dateEntity[0].end == 12){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerfindEntityInfo010() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('zh-CN');
      let dateText:string|null = null;
      let dateEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(dateText);
      this.addLog(`识别结果: phoneNumberEntity phone_number is ${dateEntity[0].type}`);
      this.addLog(`识别结果: phoneNumberEntity begin is ${dateEntity[0].begin}`);
      this.addLog(`识别结果: phoneNumberEntity end is ${dateEntity[0].end}`);
      this.addLog(`dateEntity[0].type为：${dateEntity[0].type} ，dateEntity[0].begin为：${dateEntity[0].begin}，dateEntity[0].end为：${dateEntity[0].end}`);
      if(dateEntity[0].type == 'date'&&dateEntity[0].begin == 2&&dateEntity[0].end == 12){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerfindEntityInfo011() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('zh-CN');
      let dateText:string|undefined = undefined;
      let dateEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(dateText);
      this.addLog(`识别结果: phoneNumberEntity phone_number is ${dateEntity[0].type}`);
      this.addLog(`识别结果: phoneNumberEntity begin is ${dateEntity[0].begin}`);
      this.addLog(`识别结果: phoneNumberEntity end is ${dateEntity[0].end}`);
      this.addLog(`dateEntity[0].type为：${dateEntity[0].type} ，dateEntity[0].begin为：${dateEntity[0].begin}，dateEntity[0].end为：${dateEntity[0].end}`);
      if(dateEntity[0].type == 'date'&&dateEntity[0].begin == 2&&dateEntity[0].end == 12){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }
  testEntityRecognizerfindEntityInfo012() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('zh-CN');
      let dateText:string = '';
      let dateEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(dateText);
      this.addLog(`识别结果: phoneNumberEntity phone_number is ${dateEntity[0].type}`);
      this.addLog(`识别结果: phoneNumberEntity begin is ${dateEntity[0].begin}`);
      this.addLog(`识别结果: phoneNumberEntity end is ${dateEntity[0].end}`);
      this.addLog(`dateEntity[0].type为：${dateEntity[0].type} ，dateEntity[0].begin为：${dateEntity[0].begin}，dateEntity[0].end为：${dateEntity[0].end}`);
      if(dateEntity[0].type == 'date'&&dateEntity[0].begin == 2&&dateEntity[0].end == 12){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }

  testEntityRecognizerfindEntityInfo013() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('zh-CN');
      let dateText:string = 'a'.repeat(500);
      let dateEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(dateText);
      this.addLog(`识别结果: phoneNumberEntity phone_number is ${dateEntity[0].type}`);
      this.addLog(`识别结果: phoneNumberEntity begin is ${dateEntity[0].begin}`);
      this.addLog(`识别结果: phoneNumberEntity end is ${dateEntity[0].end}`);
      this.addLog(`dateEntity[0].type为：${dateEntity[0].type} ，dateEntity[0].begin为：${dateEntity[0].begin}，dateEntity[0].end为：${dateEntity[0].end}`);
      if(dateEntity[0].type == 'date'&&dateEntity[0].begin == 2&&dateEntity[0].end == 12){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`调用失败，${err.code}+${err.message}`);
    }
  }

  testEntityRecognizerEntityInfoItem001() : void {
  console.info('已进入')
  try {
    let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('zh-CN');
    let phoneNumberText: string = '如有疑问，请联系15814232312';
    let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
    this.addLog(`phoneNumberEntity[0].type为：${phoneNumberEntity[0].type} ，phoneNumberEntity[0].begin为：${phoneNumberEntity[0].begin}，phoneNumberEntity[0].end为：${phoneNumberEntity[0].end}`);
    if(phoneNumberEntity[0].type == 'phone_number'&&phoneNumberEntity[0].begin == 8&&phoneNumberEntity[0].end == 19){
      console.info('与预期结果相符，调用成功')
      this.addLog('与预期结果相符，调用成功')
    }else{
      console.info('与预期结果不符，调用失败')
      this.addLog('与预期结果不符，调用失败')
    }
    } catch (error) {
      console.info('调用失败')
      let err: BusinessError = error as BusinessError;
      console.error(`call EntityRecognizer.findEntityInfo failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }
  testEntityRecognizerEntityInfoItem002() : void {
    try {
      let entityRecognizer: i18n.EntityRecognizer = new i18n.EntityRecognizer('zh-CN');
      let phoneNumberText: string = '如有疑问，请联系15812345678';
      let phoneNumberEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(phoneNumberText);
      let dateText: string = '我们2023年12月1日一起吃饭吧。';
      let dateEntity: Array<i18n.EntityInfoItem> = entityRecognizer.findEntityInfo(dateText);
      this.addLog(`phoneNumberEntity[0].type为：${phoneNumberEntity[0].type} ，phoneNumberEntity[0].begin为：${phoneNumberEntity[0].begin}，phoneNumberEntity[0].end为：${phoneNumberEntity[0].end}`);
      this.addLog(`dateEntity[0].type为：${dateEntity[0].type} ，dateEntity[0].begin为：${dateEntity[0].begin}，dateEntity[0].end为：${dateEntity[0].end}`);
      if(dateEntity[0].type == 'date'&&dateEntity[0].begin == 2&&dateEntity[0].end == 12){
        console.info('与预期结果相符，调用成功')
        this.addLog('与预期结果相符，调用成功')
      }else{
        console.info('与预期结果不符，调用失败')
        this.addLog('与预期结果不符，调用失败')
      }
    } catch (err) {
      console.info('调用失败')
      console.error(`${err.code}`);
      this.addLog(`${err.code + err.message} `);
    }
  }
  private buttonList:ButtonItem[] = [
    { label: 'locale为"zh-CN"', onClick: () => this.testEntityRecognizerConstructor001() },
    { label: 'locale为"en-US"', onClick: () => this.testEntityRecognizerconstructor002() },
    { label: 'locale为"de-DE"', onClick: () => this.testEntityRecognizerconstructor003() },
    { label: 'locale为"fr-FR"', onClick: () => this.testEntityRecognizerconstructor004() },
    { label: 'locale为"es-ES"', onClick: () => this.testEntityRecognizerconstructor005() },
    { label: 'locale为"it-IT"', onClick: () => this.testEntityRecognizerconstructor006() },
    { label: 'locale为"ar-SA"', onClick: () => this.testEntityRecognizerconstructor007() },
    { label: 'locale为空', onClick: () => this.testEntityRecognizerconstructor008() },
    { label: 'locale使用 " abc"', onClick: () => this.testEntityRecognizerconstructor009() },
    { label: 'locale使用 "        "', onClick: () => this.testEntityRecognizerconstructor010() },
    { label: 'locale使用"!@#$%"', onClick: () => this.testEntityRecognizerconstructor011() },
    { label: 'locale使用 "汉字 "', onClick: () => this.testEntityRecognizerconstructor012() },
    { label: 'locale使用undefined', onClick: () => this.testEntityRecognizerconstructor013() },
    { label: 'locale使用"111111111111111"', onClick: () => this.testEntityRecognizerconstructor014() },
    { label: 'testEntityRecognizerfindEntityInfo001', onClick: () => this.testEntityRecognizerfindEntityInfo001() },
    { label: 'testEntityRecognizerfindEntityInfo002', onClick: () => this.testEntityRecognizerfindEntityInfo002() },
    { label: 'testEntityRecognizerfindEntityInfo003', onClick: () => this.testEntityRecognizerfindEntityInfo003() },
    { label: 'testEntityRecognizerfindEntityInfo004', onClick: () => this.testEntityRecognizerfindEntityInfo004() },
    { label: 'testEntityRecognizerfindEntityInfo005', onClick: () => this.testEntityRecognizerfindEntityInfo005() },
    { label: 'testEntityRecognizerfindEntityInfo006', onClick: () => this.testEntityRecognizerfindEntityInfo006() },
    { label: 'testEntityRecognizerfindEntityInfo007', onClick: () => this.testEntityRecognizerfindEntityInfo007() },
    { label: 'testEntityRecognizerfindEntityInfo008', onClick: () => this.testEntityRecognizerfindEntityInfo008() },
    { label: 'testEntityRecognizerfindEntityInfo009', onClick: () => this.testEntityRecognizerfindEntityInfo009() },
    { label: 'testEntityRecognizerfindEntityInfo010', onClick: () => this.testEntityRecognizerfindEntityInfo010() },
    { label: 'testEntityRecognizerfindEntityInfo011', onClick: () => this.testEntityRecognizerfindEntityInfo011() },
    { label: 'testEntityRecognizerfindEntityInfo012', onClick: () => this.testEntityRecognizerfindEntityInfo012() },
    { label: 'testEntityRecognizerfindEntityInfo013', onClick: () => this.testEntityRecognizerfindEntityInfo013() },
    { label: '测试返回值EntityInfoItem1', onClick: () => this.testEntityRecognizerEntityInfoItem001() },
    { label: '测试返回值EntityInfoItem2', onClick: () => this.testEntityRecognizerEntityInfoItem002() },
  ];

  build() {
    Column() {
      List(){
        ForEach(
          this.buttonList,
          (item:ButtonItem) =>{
            ListItem(){
              Flex({ justifyContent: FlexAlign.Center }){
                Button(){
                  Text(item.label)
                    .fontSize(16)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })  // Text组件支持textOverflow
                    .width('100%')
                    .textAlign(TextAlign.Center)
                }
                .onClick(item.onClick)
                .width('100%')
                .height(45)
                .backgroundColor('#98FB98')
                .borderRadius(22)
              }
            }
            .width('100%') // 按钮在列表项中水平居中
            .padding({ top: 8, bottom: 8})
          },
          (item:ButtonItem) => item.label
        )
      }
      .height('60%')
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
        .onClick(()=>this.clearLog())
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
