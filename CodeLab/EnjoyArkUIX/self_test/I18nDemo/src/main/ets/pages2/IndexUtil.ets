import { BusinessError } from '@kit.BasicServicesKit';
import { i18n } from '@kit.LocalizationKit';
import router from '@ohos.router';

export interface handle {
  title: string
  onclick: () => void;
}

@Entry
@Component
struct IndexUtilTest {
  @State message: string = 'IndexUtil测试';
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

  testi18nIndexUtilgetIndexList001(): void {
    this.addLog('testi18nIndexUtilgetIndexList001 开始')
    try {
      let indexUtil: i18n.IndexUtil = i18n.getInstance('zh-CN');
      let indexList: Array<string> = indexUtil.getIndexList();
      this.addLog('获取当前区域的索引列表:')
      for (const val of indexList) {
        this.addLog(val)
      }
      this.addLog('testi18nIndexUtilgetIndexList001 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call IndexUtil.testi18nIndexUtilgetIndexList001 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  testi18nIndexUtilgetIndexList002(): void {
    this.addLog('testi18nIndexUtilgetIndexList002 开始')
    try {
      let indexUtil: i18n.IndexUtil = i18n.getInstance('de-DE');
      let indexList: Array<string> = indexUtil.getIndexList();
      this.addLog('获取当前区域的索引列表:')
      for (const val of indexList) {
        this.addLog(val)
      }
      this.addLog('testi18nIndexUtilgetIndexList002 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call IndexUtil.testi18nIndexUtilgetIndexList002 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  testi18nIndexUtilgetIndexList003(): void {
    this.addLog('testi18nIndexUtilgetIndexList003 开始')
    try {
      let indexUtil: i18n.IndexUtil = i18n.getInstance('fr-FR');
      let indexList: Array<string> = indexUtil.getIndexList();
      this.addLog('获取当前区域的索引列表:')
      for (const val of indexList) {
        this.addLog(val)
      }
      this.addLog('testi18nIndexUtilgetIndexList003 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call IndexUtil.testi18nIndexUtilgetIndexList003 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  testi18nIndexUtilgetIndexList004(): void {
    this.addLog('testi18nIndexUtilgetIndexList004 开始')
    try {
      let indexUtil: i18n.IndexUtil = i18n.getInstance('it-IT');
      let indexList: Array<string> = indexUtil.getIndexList();
      this.addLog('获取当前区域的索引列表:')
      for (const val of indexList) {
        this.addLog(val)
      }
      this.addLog('testi18nIndexUtilgetIndexList004 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call IndexUtil.testi18nIndexUtilgetIndexList004 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  testi18nIndexUtiladdLocale001(): void {
    this.addLog(' testi18nIndexUtiladdLocale001 开始')
    try {
      let indexUtil: i18n.IndexUtil = i18n.getInstance('zh-CN');
      indexUtil.addLocale('ar-sa');
      let indexList: Array<string> = indexUtil.getIndexList();
      this.addLog('形成复合列表:')
      for (const val of indexList) {
        this.addLog(val)
      }
      this.addLog(' testi18nIndexUtiladdLocale001 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call IndexUtil. testi18nIndexUtiladdLocale001 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  testi18nIndexUtiladdLocale002(): void {
    this.addLog(' testi18nIndexUtiladdLocale002 开始')
    try {
      let indexUtil: i18n.IndexUtil = i18n.getInstance('de-DE');
      indexUtil.addLocale('ar-sa');
      let indexList: Array<string> = indexUtil.getIndexList();
      this.addLog('形成复合列表:')
      for (const val of indexList) {
        this.addLog(val)
      }
      this.addLog(' testi18nIndexUtiladdLocale002 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call IndexUtil. testi18nIndexUtiladdLocale002 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  testi18nIndexUtiladdLocale003(): void {
    this.addLog(' testi18nIndexUtiladdLocale003 开始')
    try {
      let indexUtil: i18n.IndexUtil = i18n.getInstance('fr-FR');
      indexUtil.addLocale('ar-sa');
      let indexList: Array<string> = indexUtil.getIndexList();
      this.addLog('形成复合列表:')
      for (const val of indexList) {
        this.addLog(val)
      }
      this.addLog(' testi18nIndexUtiladdLocale003 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call IndexUtil. testi18nIndexUtiladdLocale003 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  testi18nIndexUtiladdLocale004(): void {
    this.addLog(' testi18nIndexUtiladdLocale004 开始')
    try {
      let indexUtil: i18n.IndexUtil = i18n.getInstance('it-IT');
      indexUtil.addLocale('ar-sa');
      let indexList: Array<string> = indexUtil.getIndexList();
      this.addLog('形成复合列表:')
      for (const val of indexList) {
        this.addLog(val)
      }
      this.addLog(' testi18nIndexUtiladdLocale004 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call IndexUtil. testi18nIndexUtiladdLocale004 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  testi18nIndexUtilgetIndex001(): void {
    this.addLog(' testi18nIndexUtilgetIndex001 开始')
    try {
      let indexUtil: i18n.IndexUtil = i18n.getInstance('zh-CN');
      let index: string = indexUtil.getIndex('hi');
      this.addLog('获取输入文本对应的索引值')
      this.addLog(index)
      this.addLog(' testi18nIndexUtilgetIndex001 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call IndexUtil. testi18nIndexUtilgetIndex001 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  testi18nIndexUtilgetIndex002(): void {
    this.addLog(' testi18nIndexUtilgetIndex002 开始')
    try {
      let indexUtil: i18n.IndexUtil = i18n.getInstance('de-DE');
      let index: string = indexUtil.getIndex('hi');
      this.addLog('获取输入文本对应的索引值')
      this.addLog(index)
      this.addLog(' testi18nIndexUtilgetIndex002 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call IndexUtil. testi18nIndexUtilgetIndex002 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  testi18nIndexUtilgetIndex003(): void {
    this.addLog(' testi18nIndexUtilgetIndex003 开始')
    try {
      let indexUtil: i18n.IndexUtil = i18n.getInstance('fr-FR');
      let index: string = indexUtil.getIndex('hi');
      this.addLog('获取输入文本对应的索引值')
      this.addLog(index)
      this.addLog(' testi18nIndexUtilgetIndex003 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call IndexUtil. testi18nIndexUtilgetIndex003 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  testi18nIndexUtilgetIndex004(): void {
    this.addLog(' testi18nIndexUtilgetIndex004 开始')
    try {
      let indexUtil: i18n.IndexUtil = i18n.getInstance('it-IT');
      let index: string = indexUtil.getIndex('hi');
      this.addLog('获取输入文本对应的索引值')
      this.addLog(index)
      this.addLog(' testi18nIndexUtilgetIndex004 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call IndexUtil. testi18nIndexUtilgetIndex004 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  private handleList: handle[] = [
    { title: 'testi18nIndexUtilgetIndexList001', onclick: () => this.testi18nIndexUtilgetIndexList001() },
    { title: 'testi18nIndexUtilgetIndexList002', onclick: () => this.testi18nIndexUtilgetIndexList002() },
    { title: 'testi18nIndexUtilgetIndexList003', onclick: () => this.testi18nIndexUtilgetIndexList003() },
    { title: 'testi18nIndexUtilgetIndexList004', onclick: () => this.testi18nIndexUtilgetIndexList004() },
    { title: ' testi18nIndexUtiladdLocale001', onclick: () => this.testi18nIndexUtiladdLocale001() },
    { title: ' testi18nIndexUtiladdLocale002', onclick: () => this.testi18nIndexUtiladdLocale002() },
    { title: ' testi18nIndexUtiladdLocale003', onclick: () => this.testi18nIndexUtiladdLocale003() },
    { title: ' testi18nIndexUtiladdLocale004', onclick: () => this.testi18nIndexUtiladdLocale004() },
    { title: ' testi18nIndexUtilgetIndex001', onclick: () => this.testi18nIndexUtilgetIndex001() },
    { title: ' testi18nIndexUtilgetIndex002', onclick: () => this.testi18nIndexUtilgetIndex002() },
    { title: ' testi18nIndexUtilgetIndex003', onclick: () => this.testi18nIndexUtilgetIndex003() },
    { title: ' testi18nIndexUtilgetIndex004', onclick: () => this.testi18nIndexUtilgetIndex004() },


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
