
import { BusinessError } from '@kit.BasicServicesKit';
import { i18n } from '@kit.LocalizationKit';
import router from '@ohos.router';
export interface handle {
  title: string
  onclick: () => void;
}

@Entry
@Component
struct NormalizerTest {
  @State message: string = 'Normalizer测试';
  @State log: string = '';

  // 日志显示格式：添加带时间戳的日志
  private addLog(content: string) {
    this.log += `[${new Date().toLocaleTimeString()}] ${content}\n`;
  }
  // 清空日志
  private clearLog(): void {
    this.log = '';
  }
  testi18nNormalizergetInstance001(): void {
     this.addLog('testi18nNormalizergetInstance001 开始')
    try {

      this.addLog('获取文本标准化对象:')
      let normalizer: i18n.Normalizer = i18n.Normalizer.getInstance(i18n.NormalizerMode.NFC);
      if(normalizer!=null){
        this.addLog('获取文本标准化对象实例不为空')
        this.addLog('testi18nNormalizergetInstance001 调用成功')
      }else{
        this.addLog('获取文本标准化对象实例为空')
        return;
      }


    } catch (error) {
      let err: BusinessError = error as BusinessError;
       this.addLog('报错')
      console.error(`call Normalizer.testi18nNormalizergetInstance001 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  testi18nNormalizergetInstance002(): void {
    this.addLog('testi18nNormalizergetInstance002 开始')
    try {
      this.addLog('获取文本标准化对象实例不为空')
      let normalizer: i18n.Normalizer = i18n.Normalizer.getInstance(i18n.NormalizerMode.NFD);
      if(normalizer!=null){
        this.addLog('获取文本标准化对象实例不为空')
        this.addLog('testi18nNormalizergetInstance002 调用成功')
      }else{
        this.addLog('获取文本标准化对象实例为空')
        return;
      }
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call Normalizer.testi18nNormalizergetInstance002 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }
  testi18nNormalizergetInstance003(): void {
    this.addLog('testi18nNormalizergetInstance003 开始')
    try {
      this.addLog('获取文本标准化对象实例不为空')
      let normalizer: i18n.Normalizer = i18n.Normalizer.getInstance(i18n.NormalizerMode.NFKC);
      if(normalizer!=null){
        this.addLog('获取文本标准化对象实例不为空')
        this.addLog('testi18nNormalizergetInstance003调用成功')
      }else{
        this.addLog('获取文本标准化对象实例为空')
        return;
      }
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call Normalizer.testi18nNormalizergetInstance003 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }
  testi18nNormalizergetInstance004(): void {
    this.addLog('testi18nNormalizergetInstance004 开始')
    try {
      this.addLog('获取文本标准化对象实例不为空')
      let normalizer: i18n.Normalizer = i18n.Normalizer.getInstance(i18n.NormalizerMode.NFKD);
      if(normalizer!=null){
        this.addLog('获取文本标准化对象实例不为空')
        this.addLog('testi18nNormalizergetInstance004 调用成功')
      }else{
        this.addLog('获取文本标准化对象实例为空')
        return;
      }
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call Normalizer.testi18nNormalizergetInstance004 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }
  testi18nNormalizergetInstance005(): void {
    this.addLog('testi18nNormalizergetInstance005 开始')
    try {
      let normalizer: i18n.Normalizer = i18n.Normalizer.getInstance(null);
      this.addLog('testi18nNormalizergetInstance005 调用成功')
    } catch (err) {
      console.error('getInstance fail');
      console.error(`${err.code}`);
      this.addLog(`${err.code + err.message} `);
      this.addLog('testi18nNormalizergetInstance005 fail');
    }
  }
  testi18nNormalizergetInstance006(): void {
    this.addLog('testi18nNormalizergetInstance006 开始')
    try {
      let normalizer: i18n.Normalizer = i18n.Normalizer.getInstance(undefined);
      this.addLog('testi18nNormalizergetInstance006 调用成功')
    } catch (err) {
      console.error('getInstance fail');
      console.error(`${err.code}`);
      this.addLog(`${err.code + err.message} `);
      this.addLog('testi18nNormalizergetInstance006 fail');
    }
  }
  testi18nNormalizergetInstance007(): void {
    this.addLog('testi18nNormalizergetInstance007 开始')
    try {
      let normalizer: i18n.Normalizer = i18n.Normalizer.getInstance(0);
      this.addLog('testi18nNormalizergetInstance007 调用成功')
    } catch (err) {
      console.error('getInstance fail');
      console.error(`${err.code}`);
      this.addLog(`${err.code + err.message} `);
      this.addLog('testi18nNormalizergetInstance007 fail');
    }
  }
  testi18nNormalizergetInstance008(): void {
    this.addLog('testi18nNormalizergetInstance008 开始')
    try {
      let normalizer: i18n.Normalizer = i18n.Normalizer.getInstance(5);
      this.addLog('testi18nNormalizergetInstance008 调用成功')
    } catch (err) {
      console.error('getInstance fail');
      console.error(`${err.code}`);
      this.addLog(`${err.code + err.message} `);
      this.addLog('testi18nNormalizergetInstance008 fail');
    }
  }
  testi18nNormalizernormalize001(): void {
     this.addLog('testi18nNormalizernormalize001 开始')
    try {
      let normalizer: i18n.Normalizer = i18n.Normalizer.getInstance(i18n.NormalizerMode.NFC);
      this.addLog('对字符串进行标准化处理后为：')
      let normalizedText: string = normalizer.normalize('\u1E9B\u0323');
      if('ẛ̣'===normalizedText){
        this.addLog(normalizedText)
        this.addLog('testi18nNormalizernormalize001调用成功')
      }else{
        this.addLog('testi18nNormalizernormalize001 调用和预期不符')
      }

    } catch (error) {
      let err: BusinessError = error as BusinessError;
       this.addLog('报错')
      console.error(`call Normalizer.testi18nNormalizernormalize001 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }
  testi18nNormalizernormalize002(): void {
     this.addLog('testi18nNormalizernormalize002 开始')
    try {
      let normalizer: i18n.Normalizer = i18n.Normalizer.getInstance(i18n.NormalizerMode.NFC);
      let normalizedText: string = normalizer.normalize(null);
       this.addLog('testi18nNormalizernormalize002 调用成功')
    } catch (err) {
      console.error('getInstance fail');
      console.error(`${err.code}`);
      this.addLog(`${err.code + err.message} `);
      this.addLog('testi18nNormalizernormalize002 fail');
    }
  }
  testi18nNormalizernormalize003(): void {
     this.addLog('testi18nNormalizernormalize003 开始')
    try {
      let normalizer: i18n.Normalizer = i18n.Normalizer.getInstance(i18n.NormalizerMode.NFC);
      let normalizedText: string = normalizer.normalize(undefined);
       this.addLog('testi18nNormalizernormalize003 调用成功')
    } catch (err) {
      console.error('normalize fail');
      console.error(`${err.code}`);
      this.addLog(`${err.code + err.message} `);
      this.addLog('testi18nNormalizernormalize002 fail');
    }
  }

  testi18nNormalizernormalize004(): void {
    this.addLog('testi18nNormalizernormalize004 开始')
    try {
      let normalizer: i18n.Normalizer = i18n.Normalizer.getInstance(2);
      this.addLog('对字符串进行标准化处理后为：')
      let normalizedText: string = normalizer.normalize('\u1E9B\u0323');
      if("ẛ̣"===normalizedText){
        this.addLog(normalizedText)
        this.addLog('testi18nNormalizernormalize004')
      }else{
        this.addLog(normalizedText)
        console.info(normalizedText+'lzwlzw')
        this.addLog('testi18nNormalizernormalize004 调用和预期不符')
      }

    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call Normalizer.testi18nNormalizernormalize004 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  testi18nNormalizernormalize005(): void {
    this.addLog('testi18nNormalizernormalize005 开始')
    try {
      let normalizer: i18n.Normalizer = i18n.Normalizer.getInstance(3);
      this.addLog('对字符串进行标准化处理后为：')
      let normalizedText: string = normalizer.normalize('\u1E9B\u0323');
      if("ṩ"===normalizedText){
        this.addLog(normalizedText)
        this.addLog('testi18nNormalizernormalize005 调用成功')
      }else{
        this.addLog(normalizedText)
        console.info(normalizedText+'lzwlzw')
        this.addLog('testi18nNormalizernormalize005 调用和预期不符')
      }

    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call Normalizer.testi18nNormalizernormalize005 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  testi18nNormalizernormalize006(): void {
    this.addLog('testi18nNormalizernormalize006 开始')
    try {
      let normalizer: i18n.Normalizer = i18n.Normalizer.getInstance(4);
      this.addLog('对字符串进行标准化处理后为：')
      let normalizedText: string = normalizer.normalize('\u1E9B\u0323');
      if("ṩ"===normalizedText){
        this.addLog(normalizedText)
        this.addLog('testi18nNormalizernormalize006 调用成功')
      }else{
        this.addLog(normalizedText)
        console.info(normalizedText+'lzwlzw')
        this.addLog('testi18nNormalizernormalize006 调用和预期不符')
      }

    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call Normalizer.testi18nNormalizernormalize006 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }


  private handleList: handle[] = [
    { title: 'testi18nNormalizergetInstance001', onclick: () => this.testi18nNormalizergetInstance001() },
    { title: 'testi18nNormalizergetInstance002', onclick: () => this.testi18nNormalizergetInstance002() },
    { title: 'testi18nNormalizergetInstance003', onclick: () => this.testi18nNormalizergetInstance003() },
    { title: 'testi18nNormalizergetInstance004', onclick: () => this.testi18nNormalizergetInstance004() },
    { title: 'testi18nNormalizergetInstance005', onclick: () => this.testi18nNormalizergetInstance005() },
    { title: 'testi18nNormalizergetInstance006', onclick: () => this.testi18nNormalizergetInstance006() },
    { title: 'testi18nNormalizergetInstance007', onclick: () => this.testi18nNormalizergetInstance007() },
    { title: 'testi18nNormalizergetInstance008', onclick: () => this.testi18nNormalizergetInstance008() },
    { title: 'testi18nNormalizernormalize001', onclick: () => this.testi18nNormalizernormalize001() },
    { title: 'testi18nNormalizernormalize002', onclick: () => this.testi18nNormalizernormalize004() },
    { title: 'testi18nNormalizernormalize003', onclick: () => this.testi18nNormalizernormalize005() },
    { title: 'testi18nNormalizernormalize004', onclick: () => this.testi18nNormalizernormalize006() },
    { title: 'testi18nNormalizernormalize005', onclick: () => this.testi18nNormalizernormalize002() },
    { title: 'testi18nNormalizernormalize006', onclick: () => this.testi18nNormalizernormalize003() },

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
