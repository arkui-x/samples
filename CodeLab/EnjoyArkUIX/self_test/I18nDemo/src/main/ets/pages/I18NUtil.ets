// 导入鸿蒙ArkUI组件和所需工具包
import { BusinessError } from '@kit.BasicServicesKit';
import { i18n } from '@kit.LocalizationKit';
import router from '@ohos.router';

interface ButtonItem {
  label: string;
  onClick: () => void;
}

// 扩展日志项接口，用于结构化日志
interface LogItem {
  timestamp: string;
  functionName: string;
  action: string; // 调用成功/失败
  returnValue?: string|number;
  expectedValue?: string|number;
  isMatch?: boolean;
  errorCode?: number;
  errorMessage?: string;
}

@Entry
@Component
struct I18NUtil {
  @State log: string = '';
  @State mirrorPath: string = "";

  // 结构化添加日志，支持展示返回值、预期值、匹配结果
  private addLog(item: LogItem) {
    let logContent = `[${item.timestamp}] [${item.functionName}] `;

    if (item.action === '调用成功') {
      logContent += `✅ ${item.action}`;
      if (item.returnValue !== undefined) {
        logContent += ` | 返回值: ${JSON.stringify(item.returnValue)}`;
      }
      if (item.expectedValue !== undefined && item.isMatch !== undefined) {
        logContent += ` | 预期值: ${JSON.stringify(item.expectedValue)}|实际值：${item.returnValue}`;
        logContent += item.isMatch ? ' | ✅ 符合预期' : ' | ❌ 不符合预期';
      }
    } else if (item.action === '调用失败') {
      logContent += `❌ ${item.action}`;
      if (item.errorCode !== undefined && item.errorMessage !== undefined) {
        logContent += ` | 错误码: ${item.errorCode} | 错误信息: ${item.errorMessage}`;
      } else if (item.returnValue !== undefined) {
        logContent += ` | 返回值: ${JSON.stringify(item.returnValue)}`;
      }
    }

    this.log += `${logContent}\n`;
  }

  private addLogNew(content: string) {
    this.log += `[${new Date().toLocaleTimeString()}] ${content}\n`;
  }
  // 简化的日志快捷方法
  private logSuccess(
    functionName: string,
    returnValue: string|number,
    expectedValue?: string|number,
    isMatch?: boolean
  ) {
    this.addLog({
      timestamp: new Date().toLocaleTimeString(),
      functionName,
      action: '调用成功',
      returnValue,
      expectedValue,
      isMatch,
    });
  }

  private logFailure(
    functionName: string,
    error?: BusinessError,
    returnValue?: string|number
  ) {
    this.addLog({
      timestamp: new Date().toLocaleTimeString(),
      functionName,
      action: '调用失败',
      returnValue,
      errorCode: error?.code,
      errorMessage: error?.message
    });
  }

  // 清空日志
  private clearLog(): void {
    this.log = "";
    this.addLog({
      timestamp: new Date().toLocaleTimeString(),
      functionName: 'clearLog',
      action: '调用成功',
      returnValue: '日志已清除'
    });
    console.info('页面日志已清除');
  }

  private buttonList: ButtonItem[] = [
    { label: 'testi18nUtilunitConvert001', onClick: () => this.testUnitConvert001() },
    { label: 'testi18nUtilunitConvert002', onClick: () => this.testUnitConvert002() },
    { label: 'testi18nUtilunitConvert003', onClick: () => this.testUnitConvert003() },
    { label: 'testi18nUtilunitConvert004', onClick: () => this.testUnitConvert004() },
    { label: 'testi18nUtilunitConvert005', onClick: () => this.testUnitConvert005() },
    { label: 'testi18nUtilunitConvert006', onClick: () => this.testUnitConvert006() },
    { label: 'testi18nUtilunitConvert007', onClick: () => this.testUnitConvert007() },
    { label: 'testi18nUtilunitConvert008', onClick: () => this.testUnitConvert008() },
    { label: 'testi18nUtilunitConvert009', onClick: () => this.testUnitConvert009() },
    { label: 'testi18nUtilunitConvert010', onClick: () => this.testUnitConvert010() },
    { label: 'testi18nUtilunitConvert011', onClick: () => this.testUnitConvert011() },
    { label: 'testi18nUtilunitConvert012', onClick: () => this.testUnitConvert012() },
    { label: 'testi18nUtilunitConvert013', onClick: () => this.testUnitConvert013() },
    { label: 'testi18nUtilunitConvert014', onClick: () => this.testUnitConvert014() },
    { label: 'testi18nUtilunitConvert015', onClick: () => this.testUnitConvert014() },
    { label: 'testi18nUtilunitConvert016', onClick: () => this.testUnitConvert015() },
    { label: 'testi18nUtilunitConvert017', onClick: () => this.testUnitConvert016() },
    { label: 'testi18nUtilunitConvert018', onClick: () => this.testUnitConvert017() },
    { label: 'testi18nUtilunitConvert019', onClick: () => this.testUnitConvert018() },
    { label: 'testi18nUtilunitConvert020', onClick: () => this.testUnitConvert019() },
    { label: 'testi18nUtilunitConvert021', onClick: () => this.testUnitConvert020() },
    { label: 'testi18nUtilunitConvert022', onClick: () => this.testUnitConvert021() },
    { label: 'testi18nUtilunitConvert023', onClick: () => this.testUnitConvert022() },
    { label: 'testi18nUtilunitConvert024', onClick: () => this.testUnitConvert023() },
    { label: 'testi18nUtilunitConvert025', onClick: () => this.testUnitConvert024() },
    { label: 'testi18nUtilunitConvert026', onClick: () => this.testUnitConvert025() },
    { label: 'testi18nUtilunitConvert027', onClick: () => this.testUnitConvert026() },
    { label: 'testi18nUtilunitConvert028', onClick: () => this.testUnitConvert027() },
    { label: 'testi18nUtilunitConvert029', onClick: () => this.testUnitConvert028() },
    { label: 'testi18nUtilunitConvert030', onClick: () => this.testUnitConvert029() },
    { label: 'testi18nUtilunitConvert031', onClick: () => this.testUnitConvert030() },
    { label: 'testi18nUtilunitConvert032', onClick: () => this.testUnitConvert031() },
    { label: 'testi18nUtilunitConvert033', onClick: () => this.testUnitConvert032() },
    { label: 'testi18nUtilunitConvert034', onClick: () => this.testUnitConvert033() },
    { label: 'testi18nUtilunitConvert035', onClick: () => this.testUnitConvert034() },
    { label: 'testi18nUtilunitConvert036', onClick: () => this.testUnitConvert035() },
    { label: 'testi18nUtilunitConvert037', onClick: () => this.testUnitConvert036() },
    { label: 'testi18nI18NUtilgetTimePeriodName001', onClick: () => this.testi18nI18NUtilgetTimePeriodName001() },
    { label: 'testi18nI18NUtilgetTimePeriodName002', onClick: () => this.testi18nI18NUtilgetTimePeriodName002() },
    { label: 'testi18nI18NUtilgetTimePeriodName003', onClick: () => this.testi18nI18NUtilgetTimePeriodName003() },
    { label: 'testi18nI18NUtilgetTimePeriodName004', onClick: () => this.testi18nI18NUtilgetTimePeriodName004() },
    { label: 'testi18nI18NUtilgetTimePeriodName005', onClick: () => this.testi18nI18NUtilgetTimePeriodName005() },
    { label: 'testi18nI18NUtilgetTimePeriodName006', onClick: () => this.testi18nI18NUtilgetTimePeriodName006() },
    { label: 'testi18nI18NUtilgetTimePeriodName007', onClick: () => this.testi18nI18NUtilgetTimePeriodName007() },
    { label: 'testi18nI18NUtilgetTimePeriodName008', onClick: () => this.testi18nI18NUtilgetTimePeriodName008() },
    { label: 'testi18nI18NUtilgetTimePeriodName009', onClick: () => this.testi18nI18NUtilgetTimePeriodName009() },
    { label: 'testi18nI18NUtilgetTimePeriodName010', onClick: () => this.testi18nI18NUtilgetTimePeriodName010() },
    { label: 'testi18nI18NUtilgetTimePeriodName011', onClick: () => this.testi18nI18NUtilgetTimePeriodName011() },
    { label: 'testi18nI18NUtilgetTimePeriodName012', onClick: () => this.testi18nI18NUtilgetTimePeriodName012() },
    { label: 'testi18nI18NUtilgetTimePeriodName013', onClick: () => this.testi18nI18NUtilgetTimePeriodName013() },
    { label: 'testi18nI18NUtilgetThreeLetterLanguage001', onClick: () => this.testi18nI18NUtilgetThreeLetterLanguage001() },
    { label: 'testi18nI18NUtilgetThreeLetterLanguage002', onClick: () => this.testi18nI18NUtilgetThreeLetterLanguage002() },
    { label: 'testi18nI18NUtilgetThreeLetterLanguage003', onClick: () => this.testi18nI18NUtilgetThreeLetterLanguage003() },
    { label: 'testi18nI18NUtilgetThreeLetterLanguage004', onClick: () => this.testi18nI18NUtilgetThreeLetterLanguage004() },
    { label: 'testi18nI18NUtilgetThreeLetterLanguage005', onClick: () => this.testi18nI18NUtilgetThreeLetterLanguage005() },
    { label: 'testi18nI18NUtilgetThreeLetterLanguage006', onClick: () => this.testi18nI18NUtilgetThreeLetterLanguage006() },
    { label: 'testi18nI18NUtilgetThreeLetterLanguage007', onClick: () => this.testi18nI18NUtilgetThreeLetterLanguage007() },
    { label: 'testi18nI18NUtilgetThreeLetterLanguage008', onClick: () => this.testi18nI18NUtilgetThreeLetterLanguage008() },
    { label: 'testi18nI18NUtilgetThreeLetterLanguage009', onClick: () => this.testi18nI18NUtilgetThreeLetterLanguage009() },
    { label: 'testi18nI18NUtilgetThreeLetterRegion001', onClick: () => this.testi18nI18NUtilgetThreeLetterRegion001() },
    { label: 'testi18nI18NUtilgetThreeLetterRegion002', onClick: () => this.testi18nI18NUtilgetThreeLetterRegion002() },
    { label: 'testi18nI18NUtilgetThreeLetterRegion003', onClick: () => this.testi18nI18NUtilgetThreeLetterRegion003() },
    { label: 'testi18nI18NUtilgetThreeLetterRegion004', onClick: () => this.testi18nI18NUtilgetThreeLetterRegion004() },
    { label: 'testi18nI18NUtilgetThreeLetterRegion005', onClick: () => this.testi18nI18NUtilgetThreeLetterRegion005() },
    { label: 'testi18nI18NUtilgetThreeLetterRegion006', onClick: () => this.testi18nI18NUtilgetThreeLetterRegion006() },
    { label: 'testi18nI18NUtilgetThreeLetterRegion007', onClick: () => this.testi18nI18NUtilgetThreeLetterRegion007() },
    { label: 'testi18nI18NUtilgetThreeLetterRegion008', onClick: () => this.testi18nI18NUtilgetThreeLetterRegion008() },
    { label: 'testi18nI18NUtilgetThreeLetterRegion009', onClick: () => this.testi18nI18NUtilgetThreeLetterRegion009() },
    { label: 'testI18NUtilgetUnicodeWrappedFilePath001', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath001() },
     { label: 'testI18NUtilgetUnicodeWrappedFilePath002', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath002() },
    { label: 'testI18NUtilgetUnicodeWrappedFilePath003', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath003() },
    { label: 'testI18NUtilgetUnicodeWrappedFilePath004', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath004() },
    { label: 'testI18NUtilgetUnicodeWrappedFilePath005', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath005() },
    { label: 'testI18NUtilgetUnicodeWrappedFilePath006', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath006() },
    { label: 'testI18NUtilgetUnicodeWrappedFilePath007', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath007() },
    { label: 'testI18NUtilgetUnicodeWrappedFilePath008', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath008() },
    { label: 'testI18NUtilgetUnicodeWrappedFilePath009', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath009() },
    { label: 'testI18NUtilgetUnicodeWrappedFilePath010', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath010() },
    { label: 'testI18NUtilgetUnicodeWrappedFilePath011', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath011() },
    { label: 'testI18NUtilgetUnicodeWrappedFilePath012', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath012() },
    { label: 'testI18NUtilgetUnicodeWrappedFilePath013', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath013() },
    { label: 'testI18NUtilgetUnicodeWrappedFilePath014', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath014() },
    { label: 'testI18NUtilgetUnicodeWrappedFilePath015', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath015() },
    { label: 'testI18NUtilgetUnicodeWrappedFilePath016', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath016() },
    { label: 'testI18NUtilgetUnicodeWrappedFilePath017', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath017() },
    { label: 'testI18NUtilgetUnicodeWrappedFilePath018', onClick: () => this.testI18NUtilgetUnicodeWrappedFilePath018() },
  ];

  testUnitConvert001(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'en-US', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testUnitConvert002(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: '', measureSystem: '' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'en-US', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert003(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: '1111111111', measureSystem: '11111111111' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'en-US', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert004(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'abc', measureSystem: 'abc' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'en-US', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert005(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: '!#', measureSystem: '!#' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'en-US', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert006(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: '刘', measureSystem: '刘' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'en-US', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert007(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: '', measureSystem: '' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'en-US', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert008(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: '1111111111', measureSystem: '1111111111' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'en-US', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert009(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'abc', measureSystem: 'abc' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'en-US', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert010(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: '!#', measureSystem: '!#' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'en-US', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert011(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: '刘', measureSystem: '刘' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'en-US', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert012(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000.5, 'en-US', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert013(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 0, 'en-US', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testUnitConvert037(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, null, 'en-US', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert014(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, undefined, 'en-US', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert015(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 131564848798, 'en-US', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert016(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, -1, 'en-US', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert017(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'zh-CN', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert018(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, null, 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert019(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, undefined, 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert020(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, '', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert021(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, '1111111111', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert022(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, "a".repeat(500), 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert023(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'abc', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert024(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, '!#', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert025(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, '刘', 'long');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert026(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'zh-CN', null);

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert027(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'zh-CN', undefined);

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert028(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'zh-CN', '');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert029(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'zh-CN', '11111111111');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert030(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'zh-CN', 'a'.repeat(500));

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert031(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'zh-CN', 'abc');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert032(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'zh-CN', '!#');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert033(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'zh-CN', '刘');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert034(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'zh-CN');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert035(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'zh-CN', 'short');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testUnitConvert036(): void {
    const funcName = 'unitConvert';
    try {
      let fromUnit: i18n.UnitInfo = { unit: 'cup', measureSystem: 'US' };
      let toUnit: i18n.UnitInfo = { unit: 'liter', measureSystem: 'SI' };
      let convertResult: string = i18n.I18NUtil.unitConvert(fromUnit, toUnit, 1000, 'zh-CN', 'narrow');

      // 记录成功日志，展示返回值
      this.logSuccess(funcName, convertResult);
      console.info(`${funcName}调用完成，结果：`, convertResult);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testi18nI18NUtilgetTimePeriodName001(): void {
    const funcName = 'getTimePeriodName(2, "zh-CN")';
    try {
      let name: string = i18n.I18NUtil.getTimePeriodName(2, 'zh-CN');
      const expected = '凌晨';
      const isMatch = name === expected;

      this.logSuccess(funcName, name, expected, isMatch);
      console.info(`${funcName}调用完成，结果：`, name);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testi18nI18NUtilgetTimePeriodName002(): void {
    const funcName = 'getTimePeriodName(2, "en-US")';
    try {
      let name: string = i18n.I18NUtil.getTimePeriodName(2, 'en-US');
      const expected = 'at night';
      const isMatch = name === expected;

      this.logSuccess(funcName, name, expected, isMatch);
      console.info(`${funcName}调用完成，结果：`, name);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testi18nI18NUtilgetTimePeriodName003(): void {
    const funcName = 'getTimePeriodName(2, "ar")';
    try {
      let name: string = i18n.I18NUtil.getTimePeriodName(2, 'ar');
      const expected = 'ليلاً';
      const isMatch = name === expected;

      this.logSuccess(funcName, name, expected, isMatch);
      console.info(`${funcName}调用完成，结果：`, name);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetTimePeriodName004(): void {
    const funcName = 'getTimePeriodName(2)';
    try {
      let name: string = i18n.I18NUtil.getTimePeriodName(2);
      const expected = '凌晨';
      const isMatch = name === expected;

      this.logSuccess(funcName, name, expected, isMatch);
      console.info(`${funcName}调用完成，结果：`, name);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testi18nI18NUtilgetTimePeriodName005(): void {
    const funcName = 'getTimePeriodName(3.123123, "zh-CN")';
    try {
      let name: string = i18n.I18NUtil.getTimePeriodName(3.123123, 'zh-CN');
      const expected = '凌晨';
      const isMatch = name === expected;

      this.logSuccess(funcName, name, expected, isMatch);
      console.info(`${funcName}调用完成，结果：`, name);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetTimePeriodName006(): void {
    const funcName = 'getTimePeriodName(null)';
    try {
      let name: string = i18n.I18NUtil.getTimePeriodName(null);
      this.logSuccess(funcName, name);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetTimePeriodName007(): void {
    const funcName = 'getTimePeriodName(undefined)';
    try {
      let name: string = i18n.I18NUtil.getTimePeriodName(undefined);
      this.logSuccess(funcName, name);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetTimePeriodName008(): void {
    const funcName = 'getTimePeriodName(2, "")';
    try {
      let name: string = i18n.I18NUtil.getTimePeriodName(2, '');
      this.logSuccess(funcName, name);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetTimePeriodName009(): void {
    const funcName = 'getTimePeriodName(2, "1111111111111")';
    try {
      let name: string = i18n.I18NUtil.getTimePeriodName(2, '1111111111111');
      this.logSuccess(funcName, name);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testi18nI18NUtilgetTimePeriodName010(): void {
    const funcName = 'getTimePeriodName(2, 500个"a")';
    try {
      let name: string = i18n.I18NUtil.getTimePeriodName(2, "a".repeat(500));
      this.logSuccess(funcName, name);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetTimePeriodName011(): void {
    const funcName = 'getTimePeriodName(2, "abc")';
    try {
      let name: string = i18n.I18NUtil.getTimePeriodName(2, "abc");
      this.logSuccess(funcName, name);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testi18nI18NUtilgetTimePeriodName012(): void {
    const funcName = 'getTimePeriodName(2, "!#")';
    try {
      let name: string = i18n.I18NUtil.getTimePeriodName(2, "!#");
      this.logSuccess(funcName, name);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testi18nI18NUtilgetTimePeriodName013(): void {
    const funcName = 'getTimePeriodName(2, "刘")';
    try {
      let name: string = i18n.I18NUtil.getTimePeriodName(2, "刘");
      this.logSuccess(funcName, name);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testi18nI18NUtilgetThreeLetterLanguage001(): void {
    const funcName = 'getThreeLetterLanguage("zh")';
    try {
      let language: string = i18n.I18NUtil.getThreeLetterLanguage('zh');
      const expected = 'zho';
      const isMatch = language === expected;

      this.logSuccess(funcName, language, expected, isMatch);
      console.info(`${funcName}调用完成，结果：`, language);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetThreeLetterLanguage002(): void {
    const funcName = 'getThreeLetterLanguage(null)';
    try {
      let language: string = i18n.I18NUtil.getThreeLetterLanguage(null);
      this.logSuccess(funcName, language);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetThreeLetterLanguage003(): void {
    const funcName = 'getThreeLetterLanguage(undefined)';
    try {
      let language: string = i18n.I18NUtil.getThreeLetterLanguage(undefined);
      this.logSuccess(funcName, language);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetThreeLetterLanguage004(): void {
    const funcName = 'getThreeLetterLanguage(" ")';
    try {
      let language: string = i18n.I18NUtil.getThreeLetterLanguage(' ');
      this.logSuccess(funcName, language);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetThreeLetterLanguage005(): void {
    const funcName = 'getThreeLetterLanguage("111111111111111")';
    try {
      let language: string = i18n.I18NUtil.getThreeLetterLanguage('111111111111111');
      this.logSuccess(funcName, language);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetThreeLetterLanguage009(): void {
    const funcName = 'getThreeLetterLanguage(500个"a")';
    try {
      let language: string = i18n.I18NUtil.getThreeLetterLanguage('a'.repeat(500));
      this.logSuccess(funcName, language);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testi18nI18NUtilgetThreeLetterLanguage006(): void {
    const funcName = 'getThreeLetterLanguage("abc")';
    try {
      let language: string = i18n.I18NUtil.getThreeLetterLanguage('abc');
      this.logSuccess(funcName, language);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetThreeLetterLanguage007(): void {
    const funcName = 'getThreeLetterLanguage("!#")';
    try {
      let language: string = i18n.I18NUtil.getThreeLetterLanguage('!#');
      this.logSuccess(funcName, language);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetThreeLetterLanguage008(): void {
    const funcName = 'getThreeLetterLanguage("刘")';
    try {
      let language: string = i18n.I18NUtil.getThreeLetterLanguage('刘');
      this.logSuccess(funcName, language);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetThreeLetterRegion001(): void {
    const funcName = 'getThreeLetterRegion("CN")';
    try {
      let region: string = i18n.I18NUtil.getThreeLetterRegion('CN');
      const expected = 'CHN';
      const isMatch = region === expected;

      this.logSuccess(funcName, region, expected, isMatch);
      console.info(`${funcName}调用完成，结果：`, region);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetThreeLetterRegion002(): void {
    const funcName = 'getThreeLetterRegion(null)';
    try {
      let region: string = i18n.I18NUtil.getThreeLetterRegion(null);
      this.logSuccess(funcName, region);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetThreeLetterRegion003(): void {
    const funcName = 'getThreeLetterRegion(undefined)';
    try {
      let region: string = i18n.I18NUtil.getThreeLetterRegion(undefined);
      this.logSuccess(funcName, region);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetThreeLetterRegion004(): void {
    const funcName = 'getThreeLetterRegion(" ")';
    try {
      let region: string = i18n.I18NUtil.getThreeLetterRegion(' ');
      this.logSuccess(funcName, region);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetThreeLetterRegion005(): void {
    const funcName = 'getThreeLetterRegion("11111111111111")';
    try {
      let region: string = i18n.I18NUtil.getThreeLetterRegion('11111111111111');
      this.logSuccess(funcName, region);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }
  testi18nI18NUtilgetThreeLetterRegion009(): void {
    const funcName = 'getThreeLetterRegion(500个"a")';
    try {
      let region: string = i18n.I18NUtil.getThreeLetterRegion('a'.repeat(500));
      this.logSuccess(funcName, region);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetThreeLetterRegion006(): void {
    const funcName = 'getThreeLetterRegion("abc")';
    try {
      let region: string = i18n.I18NUtil.getThreeLetterRegion('abc');
      this.logSuccess(funcName, region);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetThreeLetterRegion007(): void {
    const funcName = 'getThreeLetterRegion("!#")';
    try {
      let region: string = i18n.I18NUtil.getThreeLetterRegion('!#');
      this.logSuccess(funcName, region);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testi18nI18NUtilgetThreeLetterRegion008(): void {
    const funcName = 'getThreeLetterRegion("刘")';
    try {
      let region: string = i18n.I18NUtil.getThreeLetterRegion('刘');
      this.logSuccess(funcName, region);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath001(): void {
    const funcName = 'getUnicodeWrappedFilePath("/data/out/tmp", "/", ar)';
    try {
      let path: string = '/data/out/tmp';
      let delimiter: string = '/';
      let locale: Intl.Locale = new Intl.Locale('ar');
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath(path, delimiter, locale);
      // mirrorPath = "123456";
      this.mirrorPath =mirrorPath
      let flag = i18n.Unicode.isRTL(mirrorPath);
      const expected = 'tmp/out/data/';
      const isMatch = (mirrorPath === expected);
      // this.mirrorPath = 'tmp/out/data/'
      this.addLogNew(`${flag}`);
      //this.addLogNew(`预期值：${expected},实际值:${this.mirrorPath}}`)
      console.info(`${funcName}调用完成，结果：`, this.mirrorPath);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath002(): void {
    const funcName = 'getUnicodeWrappedFilePath("/data/out/tmp")';
    try {
      let path: string = '/data/out/tmp';
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath(path);

      const expected = '/data/out/tmp';
      const isMatch = mirrorPath === expected;
      this.mirrorPath =mirrorPath
      this.logSuccess(funcName, mirrorPath, expected, isMatch);
      console.info(`${funcName}调用完成，结果：`, mirrorPath);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath003(): void {
    const funcName = 'getUnicodeWrappedFilePath(null, "/", ar)';
    try {
      let locale: Intl.Locale = new Intl.Locale('ar');
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath(null, '/', locale);
      this.logSuccess(funcName, mirrorPath);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath004(): void {
    const funcName = 'getUnicodeWrappedFilePath(undefined, "/", ar)';
    try {
      let locale: Intl.Locale = new Intl.Locale('ar');
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath(undefined, '/', locale);
      this.logSuccess(funcName, mirrorPath);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath005(): void {
    const funcName = 'getUnicodeWrappedFilePath(" ", "/", ar)';
    try {
      let locale: Intl.Locale = new Intl.Locale('ar');
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath("", '/', locale);
      this.logSuccess(funcName, mirrorPath);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath006(): void {
    const funcName = 'getUnicodeWrappedFilePath("111111111111111", "/", ar)';
    try {
      let locale: Intl.Locale = new Intl.Locale('ar');
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath('111111111111111', '/', locale);
      this.logSuccess(funcName, mirrorPath);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath007(): void {
    const funcName = 'getUnicodeWrappedFilePath("abc", "/", ar)';
    try {
      let locale: Intl.Locale = new Intl.Locale('ar');
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath('abc', '/', locale);
      this.logSuccess(funcName, mirrorPath);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath008(): void {
    const funcName = 'getUnicodeWrappedFilePath("!#", "/", ar)';
    try {
      let locale: Intl.Locale = new Intl.Locale('ar');
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath('!#', '/', locale);
      this.logSuccess(funcName, mirrorPath);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath009(): void {
    const funcName = 'getUnicodeWrappedFilePath("刘", "/", ar)';
    try {
      let locale: Intl.Locale = new Intl.Locale('ar');
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath('刘', '/', locale);
      this.logSuccess(funcName, mirrorPath);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath010(): void {
    const funcName = 'getUnicodeWrappedFilePath("/data/out/tmp", null, ar)';
    try {
      let locale: Intl.Locale = new Intl.Locale('ar');
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath('/data/out/tmp', null, locale);
      this.logSuccess(funcName, mirrorPath);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath011(): void {
    const funcName = 'getUnicodeWrappedFilePath("/data/out/tmp", undefined, ar)';
    try {
      let locale: Intl.Locale = new Intl.Locale('ar');
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath('/data/out/tmp', undefined, locale);
      this.logSuccess(funcName, mirrorPath);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath012(): void {
    const funcName = 'getUnicodeWrappedFilePath("/data/out/tmp", "", ar)';
    try {
      let locale: Intl.Locale = new Intl.Locale('ar');
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath('/data/out/tmp', '', locale);
      this.logSuccess(funcName, mirrorPath);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath013(): void {
    const funcName = 'getUnicodeWrappedFilePath("/data/out/tmp", "111111111111111", ar)';
    try {
      let locale: Intl.Locale = new Intl.Locale('ar');
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath('/data/out/tmp', '111111111111111', locale);
      this.logSuccess(funcName, mirrorPath);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath014(): void {
    const funcName = 'getUnicodeWrappedFilePath("/data/out/tmp", "abc", ar)';
    try {
      let locale: Intl.Locale = new Intl.Locale('ar');
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath('/data/out/tmp', 'abc', locale);
      this.logSuccess(funcName, mirrorPath);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath015(): void {
    const funcName = 'getUnicodeWrappedFilePath("/data/out/tmp", "!#", ar)';
    try {
      let locale: Intl.Locale = new Intl.Locale('ar');
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath('/data/out/tmp', '!#', locale);
      this.logSuccess(funcName, mirrorPath);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath016(): void {
    const funcName = 'getUnicodeWrappedFilePath("/data/out/tmp", "刘", ar)';
    try {
      let locale: Intl.Locale = new Intl.Locale('ar');
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath('/data/out/tmp', '刘', locale);
      this.logSuccess(funcName, mirrorPath);
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath017(): void {
    const funcName = 'getUnicodeWrappedFilePath("/data/out/tmp", "\\", ar)';
    try {
      let locale: Intl.Locale = new Intl.Locale('ar');
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath('/data/out/tmp', '\\', locale);

      let flag=i18n.Unicode.isRTL(mirrorPath);
      const expected = false
      if(flag==expected)
      this.addLogNew("获取到地址不为RTL格式，符合预期")
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }

  testI18NUtilgetUnicodeWrappedFilePath018(): void {
    const funcName = 'getUnicodeWrappedFilePath("/data/out/tmp", "|", ar)';
    try {
      let locale: Intl.Locale = new Intl.Locale('ar');
      let mirrorPath: string = i18n.I18NUtil.getUnicodeWrappedFilePath('/data/out/tmp', '|', locale);

      let flag=i18n.Unicode.isRTL(mirrorPath);
      const expected = false
      if(flag==expected)
        this.addLogNew("获取到地址不为RTL格式，符合预期")
    } catch (error) {
      const err = error as BusinessError;
      this.logFailure(funcName, err);
      console.error(`${funcName}调用失败：`, err);
    }
  }


  build() {
    Column() {
      List() {
        ForEach(
          this.buttonList,
          (item: ButtonItem) => {
            ListItem() {
              Flex({ justifyContent: FlexAlign.Center }) {
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
            .width('100%')
            .padding({ top: 8, bottom: 8 })
          },
          (item: ButtonItem) => item.label
        )
      }
      .height('40%')
      .padding(20);

      Scroll() {
        Text(this.log)
          .fontSize(14)
          .width('100%')
          .padding(10)
          .fontColor('#333');
      }
      .height('25%')
      .width('100%')
      .border({ width: 1, color: '#eee' })
      .borderRadius(5)
      .backgroundColor('#f9f9f9')
      Scroll() {
        Text(this.mirrorPath)
          .fontSize(14)
          .width('100%')
          .padding(10)
          .fontColor('#333');
      }
      .height('25%')
      .width('100%')
      .border({ width: 1, color: '#eee' })
      .borderRadius(5)
      .backgroundColor('#f9f9f9')

      Button('清空日志')
        .onClick(() => this.clearLog())
        .fontSize(16)
        .width('80%')
        .height(45)
        .backgroundColor('#ff4757')
        .borderRadius(22)
        .margin({ top: 10 })
      Button('返回主界面')
        .onClick(() => router.back())
        .fontSize(16)
        .width('80%')
        .height(45)
        .backgroundColor('#ff4757')
        .borderRadius(22)
    }
    .width('100%')
    .height('100%')
    .padding(10)
    .backgroundColor('#f5f5f5')
  }
}