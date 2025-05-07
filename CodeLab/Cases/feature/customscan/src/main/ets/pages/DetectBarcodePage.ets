import { url } from '@kit.ArkTS';
import { webview } from "@kit.ArkWeb";
import { logger } from 'utils';
import CommonConstants from '../common/constants/CommonConstants';
import CustomScanViewModel from '../viewmodel/CustomScanViewModel';

@Component
export struct DetectBarcodePage {
  @Consume('subPageStack') subPageStack: NavPathStack;
  @Consume('customScanVM') customScanVM: CustomScanViewModel;
  @State detectResult: string = '';
  @State urlForShow: string = '';
  private webController = new webview.WebviewController();

  aboutToAppear(): void {
    const pageParams: ESObject = this.subPageStack.getParamByIndex(this.subPageStack.size() - 1);
    const detectResult: string = pageParams.detectResult;
    if (!detectResult) {
      this.detectResult = CommonConstants.DETECT_NO_RESULT;
      return;
    }

    // 解析是否url，是url直接加载网页，非url展示识别文本
    try {
      const urlObj = url.URL.parseURL(detectResult);
      this.urlForShow = urlObj.toString();
    } catch (e) {
      logger.info('[customscan]', `detectResult is not url, is: ${detectResult}`);
      this.detectResult = detectResult;
    }
  }

  aboutToDisappear(): void {
    this.customScanVM.initCustomScan();
  }

  build() {
    if (this.urlForShow) {
      Web({ src: this.urlForShow, controller: this.webController })
        .width('100%')
        .height('100%')
        .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.BOTTOM])
        .onErrorReceive((event) => {
          if (event) {
            logger.error('[customscan]', `errorInfo: ${event.error.getErrorInfo()} errorCode: ${event.error.getErrorCode()}`)
            this.detectResult = this.urlForShow;
            this.urlForShow = '';
          }
        })
    } else {
      Text(this.detectResult)
        .height('100%')
        .alignSelf(ItemAlign.Center)
    }
  }
}
