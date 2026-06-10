
import { BusinessError } from '@kit.BasicServicesKit';
import { i18n } from '@kit.LocalizationKit';
import router from '@ohos.router';
export interface handle {
  title: string
  onclick: () => void;
}

@Entry
@Component
struct TransliteratorTest {
  @State message: string = 'Transliterator测试';
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
   testi18nTransliteratorgetAvailableIDs001(): void {
    this.addLog(' testi18nTransliteratorgetAvailableIDs001 开始')
    try {

      this.addLog(' 获取音译支持的转换ID列表为：')
      let ids: string[] = i18n.Transliterator.getAvailableIDs();
      for(const val of ids){
        console.info(val)
        this.addLog(val)      }
      this.addLog(' testi18nTransliteratorgetAvailableIDs001 调用成功')
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call TimeZone. testi18nTransliteratorgetAvailableIDs001 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

   testi18nTransliteratorgetInstance001(): void {
    this.addLog(' testi18nTransliteratorgetInstance001 开始')
    try {
      this.addLog(' 创建指定转换ID的音译对象：')
      let transliterator: i18n.Transliterator = i18n.Transliterator.getInstance('Any-Latn');
      if(transliterator!=null){
        this.addLog(' 创建指定转换ID的音译对象实例不为空：')
        this.addLog(' testi18nTransliteratorgetInstance001 调用成功')
      }else{
        this.addLog(' 创建指定转换ID的音译对象实例为空：')
        return;
      }

    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call TimeZone. testi18nTransliteratorgetInstance001 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  testi18nTransliteratortransform001(): void {
    this.addLog('testi18nTransliteratortransform001 开始')
    try {
      // 汉语音译去声调
      let transliterator = i18n.Transliterator.getInstance('Any-Latn;Latin-Ascii');
      this.addLog('将输入文本从源格式转换为目标格式为:')
      let transliterateAscii: string = transliterator.transform('中国'); // transliterateAscii = 'zhong guo'
      this.addLog(transliterateAscii)
      if(transliterateAscii==='zhong guo') {
        this.addLog('testi18nTransliteratortransform001 调用成功')
      }
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call TimeZone.testi18nTransliteratortransform001 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }
  testi18nTransliteratortransform002(): void {
    this.addLog('testi18nTransliteratortransform002 开始')
    try {
      // 汉语音译去声调
      let transliterator = i18n.Transliterator.getInstance('Any-Latn');
      this.addLog('将输入文本从源格式转换为目标格式为:')
      let transliterateAscii: string = transliterator.transform('中国'); // transliterateAscii = 'zhong guo'
      if(transliterateAscii==='zhōng guó'){
      this.addLog(transliterateAscii)
      this.addLog('testi18nTransliteratortransform002 调用成功')
      }
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call TimeZone.testi18nTransliteratortransform001 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }
  testi18nTransliteratortransform003(): void {
    this.addLog('testi18nTransliteratortransform003 开始')
    try {
      // 汉语音译去声调
      let transliterator = i18n.Transliterator.getInstance('Han-Latin/Names');
      this.addLog('将输入文本从源格式转换为目标格式为:')
      let transliterateAscii: string = transliterator.transform('单老师');
      if(transliterateAscii==='shàn lǎo shī'){
      this.addLog(transliterateAscii)
      this.addLog('testi18nTransliteratortransform003 调用成功')
      }
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      this.addLog('报错')
      console.error(`call TimeZone.testi18nTransliteratortransform001 failed, error code: ${err.code}, message: ${err.message}.`);
    }
  }

  private handleList: handle[] = [
    { title: ' testi18nTransliteratorgetAvailableIDs001', onclick: () => this. testi18nTransliteratorgetAvailableIDs001() },
    { title: ' testi18nTransliteratorgetInstance001', onclick: () => this. testi18nTransliteratorgetInstance001() },
    { title: 'testi18nTransliteratortransform001', onclick: () => this.testi18nTransliteratortransform001() },
    { title: 'testi18nTransliteratortransform002', onclick: () => this.testi18nTransliteratortransform002() },
    { title: 'testi18nTransliteratortransform003', onclick: () => this.testi18nTransliteratortransform003() },




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
