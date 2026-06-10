
import { BusinessError } from '@kit.BasicServicesKit';
import { i18n } from '@kit.LocalizationKit';
export interface handle {
  label: string
  onclick: () => void;
}

@Entry
@Component
struct i18nTest {

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
  @State message: string = 'i18n测试';
  testi18ngetInstance001(): void {
     this.addLog('testi18ngetInstance001 开始')
    try {
      let indexUtil: i18n.IndexUtil = i18n.getInstance('zh-CN');
      if(indexUtil!=null){
        this.addLog('获取对象实例不为空,获取IndexUtil对象成功')
      }
    } catch (err) {
      console.error('listen fail');
      console.error(`${err.code}`);
      this.addLog(`${err.code + err.message} `);
      this.addLog('listen fail');
    }
  }
  testi18ngetInstance002(): void {
     this.addLog('testi18ngetInstance002 开始')
    try {
      let indexUtil: i18n.IndexUtil = i18n.getInstance('de-DE');
      if(indexUtil!=null){
        this.addLog('获取对象实例不为空,获取IndexUtil对象成功')
      }
    } catch (error) {
      let err: BusinessError = error as BusinessError;
       this.addLog('报错')
      console.error(`call TimeZone.testi18ngetInstance002 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }
  testi18ngetInstance003(): void {
     this.addLog('testi18ngetInstance003 开始')
    try {
      let indexUtil: i18n.IndexUtil = i18n.getInstance('fr-FR');
      if(indexUtil!=null){
        this.addLog('获取对象实例不为空,获取IndexUtil对象成功')
      }
    } catch (error) {
      let err: BusinessError = error as BusinessError;
       this.addLog('报错')
      console.error(`call TimeZone.testi18ngetInstance003 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }
  testi18ngetInstance004(): void {
     this.addLog('testi18ngetInstance004 开始')
    try {
      let indexUtil: i18n.IndexUtil = i18n.getInstance('it-IT');
      if(indexUtil!=null){
        this.addLog('获取对象实例不为空,获取IndexUtil对象成功')
      }
    } catch (error) {
      let err: BusinessError = error as BusinessError;
       this.addLog('报错')
      console.error(`call TimeZone.testi18ngetInstance004 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }
  testi18ngetInstance005(): void {
     this.addLog('testi18ngetInstance005 开始')
    try {
      let indexUtil: i18n.IndexUtil = i18n.getInstance();
      if(indexUtil!=null){
        this.addLog('获取对象实例不为空,无参调用获取IndexUtil对象成功')
      }
    } catch (err) {
      console.error('listen fail');
      console.error(`${err.code}`);
      this.addLog(`${err.code + err.message} `);
      this.addLog('listen fail');
    }
  }

  private handleList: handle[] = [
    { label: 'testi18ngetInstance001', onclick: () => this.testi18ngetInstance001() },
    { label: 'testi18ngetInstance002', onclick: () => this.testi18ngetInstance002() },
    { label: 'testi18ngetInstance003', onclick: () => this.testi18ngetInstance003() },
    { label: 'testi18ngetInstance004', onclick: () => this.testi18ngetInstance004() },
    { label: 'testi18ngetInstance005', onclick: () => this.testi18ngetInstance005() },

  ]
  build() {

    Column() {
      List() {
        ForEach(
          this.handleList,
          (item: handle) => {
            ListItem() {
              Flex({ justifyContent: FlexAlign.Center }) {
                Button(item.label)
                  .onClick(item.onclick)
                  .fontSize(16)
                  .width('80%')
                  .height(45)
                  .backgroundColor('#007dff')
                  .borderRadius(22)
              }
            }
            .width('100%') // 按钮在列表项中水平居中
            .padding({ top: 8, bottom: 8 })
          },
          (item: handle) => item.label
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
    }
  }
}
