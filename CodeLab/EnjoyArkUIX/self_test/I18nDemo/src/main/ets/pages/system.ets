import { BusinessError } from '@kit.BasicServicesKit';
import { i18n } from '@kit.LocalizationKit';
import router from '@ohos.router';
import { Router } from '@kit.ArkUI';

interface ButtonItem {
  label: string;
  onClick: () => void;
}
interface testcase{
  lang: string, country?: string, desc:string
}

@Entry
@Component
struct system {
  @State log: string = '';

  // 日志显示格式
  private addLog(content: string) {
    this.log += `[${new Date().toLocaleTimeString()}] ${content}\n`;
  }

  // 清空日志
  private clearLog(): void {
    this.log = "";
    this.addLog('日志已清除');
    console.info('页面日志已清除');
  }

  private getWeekDayName(weekDay?: i18n.WeekDay): string {
    switch (weekDay) {
      case i18n.WeekDay.MON: return 'MON';
      case i18n.WeekDay.TUE: return 'TUE';
      case i18n.WeekDay.WED: return 'WED';
      case i18n.WeekDay.THU: return 'THU';
      case i18n.WeekDay.FRI: return 'FRI';
      case i18n.WeekDay.SAT: return 'SAT';
      case i18n.WeekDay.SUN: return 'SUN';
      default: return '未知枚举值';
    }
  }

  private buttonList: ButtonItem[] = [
    { label: 'testi18nSystemgetSystemLanguages001', onClick: () => this.testi18nSystemgetSystemLanguages001() },
    { label: 'testi18nSystemgetSystemCountries001', onClick: () => this.testi18nSystemgetSystemCountries001() },
    { label: 'testi18nSystemgetSystemCountries002', onClick: () => this.testi18nSystemgetSystemCountries002() },
    { label: 'testi18nSystemgetSystemCountries003', onClick: () => this.testi18nSystemgetSystemCountries003() },
    { label: 'testi18nSystemgetSystemCountries004', onClick: () => this.testi18nSystemgetSystemCountries004() },
    { label: 'testi18nSystemgetSystemCountries005', onClick: () => this.testi18nSystemgetSystemCountries005() },
    { label: 'testi18nSystemisSuggested001', onClick: () => this.testi18nSystemisSuggested001() },
    { label: 'testi18nSystemisSuggested002', onClick: () => this.testi18nSystemisSuggested002() },
    { label: 'testi18nSystemisSuggested003', onClick: () => this.testi18nSystemisSuggested003() },
    { label: 'testi18nSystemisSuggested004', onClick: () => this.testi18nSystemisSuggested004() },
    { label: 'testi18nSystemgetPreferredLanguageList001', onClick: () => this.testi18nSystemgetPreferredLanguageList001() },
    { label: 'testi18nSystemgetFirstPreferredLanguage001', onClick: () => this.testi18nSystemgetFirstPreferredLanguage001() },
    { label: 'testi18nSystemgetUsingLocalDigit001', onClick: () => this.testi18nSystemgetUsingLocalDigit001() },
    { label: 'testi18nSystemgetSimplifiedLanguage001', onClick: () => this.testi18nSystemgetSimplifiedLanguage001() },
    { label: 'testi18nSystemgetSimplifiedLanguage002', onClick: () => this.testi18nSystemgetSimplifiedLanguage002() },
    { label: 'testi18nSystemgetSimplifiedLanguage003', onClick: () => this.testi18nSystemgetSimplifiedLanguage003() },
    { label: 'testi18nSystemgetSimplifiedLanguage004', onClick: () => this.testi18nSystemgetSimplifiedLanguage004() },
    { label: 'testi18nSystemgetSimplifiedLanguage005', onClick: () => this.testi18nSystemgetSimplifiedLanguage005() },
    { label: 'testi18nSystemgetSimplifiedLanguage006', onClick: () => this.testi18nSystemgetSimplifiedLanguage006() },
    { label: 'testi18nSystemgetSimplifiedLanguage007', onClick: () => this.testi18nSystemgetSimplifiedLanguage007() },
    { label: 'testi18nSystemgetSimplifiedLanguage008', onClick: () => this.testi18nSystemgetSimplifiedLanguage008() },
    { label: 'testi18nSystemgetSimplifiedLanguage009', onClick: () => this.testi18nSystemgetSimplifiedLanguage009() },
    { label: 'testi18nSystemgetSimplifiedLanguage010', onClick: () => this.testi18nSystemgetSimplifiedLanguage010() },
    { label: 'testi18nSystemgetSimplifiedLanguage011', onClick: () => this.testi18nSystemgetSimplifiedLanguage011() },
    { label: 'testi18nSystemgettemperatureType001', onClick: () => this.getCurrentTemperatureType() },
    { label: 'testi18nSystemgetTemperatureName001', onClick: () => this.testTemperatureName(i18n.TemperatureType.CELSIUS, 'CELSIUS', 'celsius') },
    { label: 'testi18nSystemgetTemperatureName002', onClick: () => this.testTemperatureName(i18n.TemperatureType.FAHRENHEIT, 'FAHRENHEIT', 'fahrenheit') },
    { label: 'testi18nSystemgetTemperatureName003', onClick: () => this.testTemperatureName(i18n.TemperatureType.KELVIN, 'KELVIN', 'kelvin') },
    { label: 'testi18nSystemgetTemperatureName004', onClick: () => this.testi18nSystemgetTemperatureName004() },
    { label: 'testi18nSystemgetTemperatureName005', onClick: () => this.testi18nSystemgetTemperatureName005() },
    { label: 'testi18nSystemgetTemperatureName006', onClick: () => this.testi18nSystemgetTemperatureName006() },
    { label: 'testi18nSystemgetFirstDayOfWeek001', onClick: () => this.testFirstDayOfWeekNew(i18n.WeekDay.MON, 'MON(1)') },
    { label: 'testi18nSystemgetFirstDayOfWeek002', onClick: () => this.testFirstDayOfWeekNew(i18n.WeekDay.SAT, 'SAT(6)') },
    { label: 'testi18nSystemgetFirstDayOfWeek003', onClick: () => this.testFirstDayOfWeekNew(i18n.WeekDay.SUN, 'SUN(7)') },
    { label: 'testi18nSystemWeekDay001', onClick: () => this.testforWeekly(i18n.WeekDay.MON, 'MON(1)') },
    { label: 'testi18nSystemWeekDay002', onClick: () => this.testforWeekly(i18n.WeekDay.TUE, 'TUE(2)') },
    { label: 'testi18nSystemWeekDay003', onClick: () => this.testforWeekly(i18n.WeekDay.WED, 'WED(3)') },
    { label: 'testi18nSystemWeekDay004', onClick: () => this.testforWeekly(i18n.WeekDay.THU, 'THU(4)') },
    { label: 'testi18nSystemWeekDay005', onClick: () => this.testforWeekly(i18n.WeekDay.FRI, 'FRI(5)') },
    { label: 'testi18nSystemWeekDay006', onClick: () => this.testforWeekly(i18n.WeekDay.SAT, 'SAT(6)') },
    { label: 'testi18nSystemWeekDay007', onClick: () => this.testforWeekly(i18n.WeekDay.SUN, 'SUN(7)') },
  ];

  // 获取系统语言列表
  testi18nSystemgetSystemLanguages001(): void {
    try {
      this.addLog('========== testi18nSystemgetSystemLanguages001 开始 ==========');
      this.addLog(`调用API：i18n.System.getSystemLanguages()`);

      // 调用方法
      let systemLanguages: Array<string> = i18n.System.getSystemLanguages();

      // 打印结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值类型：${typeof systemLanguages}`);
      this.addLog(`  是否为数组：${Array.isArray(systemLanguages)}`);
      this.addLog(`  数组长度：${systemLanguages.length}`);
      this.addLog(`  数组内容：${JSON.stringify(systemLanguages)}`);
      this.addLog(`  前5个语言：${systemLanguages.slice(0, 5).join(', ')}${systemLanguages.length > 5 ? '...' : ''}`);

      console.info("getSystemLanguages调用完成");
      this.addLog(`验证结果：调用成功`);
      this.addLog('========== testi18nSystemgetSystemLanguages001 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.info("getSystemLanguages调用出错");
      this.addLog(`testi18nSystemgetSystemLanguages001 执行出错：`);
      this.addLog(`  错误码：${err.code || '无'}`);
      this.addLog(`  错误信息：${err.message || (error as Error).message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetSystemLanguages001 结束 ==========\n');
    }
  }

  // 获取系统国家列表 - 中文locale
  testi18nSystemgetSystemCountries001(): void {
    try {
      this.addLog('========== testi18nSystemgetSystemCountries001 开始 ==========');
      const locale = 'zh';
      this.addLog(`调用API：i18n.System.getSystemCountries('${locale}')`);

      // 调用方法
      let systemCountries: Array<string> = i18n.System.getSystemCountries(locale);

      // 打印结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值类型：${typeof systemCountries}`);
      this.addLog(`  是否为数组：${Array.isArray(systemCountries)}`);
      this.addLog(`  数组长度：${systemCountries.length}`);
      this.addLog(`  前10个国家码：${systemCountries.slice(0, 10).join(', ')}${systemCountries.length > 10 ? '...' : ''}`);

      this.addLog(`验证结果：调用成功`);
      this.addLog('========== testi18nSystemgetSystemCountries001 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getSystemCountries failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetSystemCountries001 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetSystemCountries001 结束 ==========\n');
    }
  }

  // 获取系统国家列表 - null参数
  testi18nSystemgetSystemCountries002(): void {
    try {
      this.addLog('========== testi18nSystemgetSystemCountries002 开始 ==========');
      const locale = null;
      this.addLog(`调用API：i18n.System.getSystemCountries(${locale})`);
      this.addLog(`参数类型：${typeof locale}`);

      // 调用方法
      let systemCountries: Array<string> = i18n.System.getSystemCountries(locale);

      // 打印结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值类型：${typeof systemCountries}`);
      this.addLog(`  是否为数组：${Array.isArray(systemCountries)}`);
      this.addLog(`  数组长度：${systemCountries.length}`);

      this.addLog(`验证结果：调用成功`);
      this.addLog('========== testi18nSystemgetSystemCountries002 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getSystemCountries failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetSystemCountries002 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetSystemCountries002 结束 ==========\n');
    }
  }

  // 获取系统国家列表 - undefined参数
  testi18nSystemgetSystemCountries003(): void {
    try {
      this.addLog('========== testi18nSystemgetSystemCountries003 开始 ==========');
      const locale = undefined;
      this.addLog(`调用API：i18n.System.getSystemCountries(${locale})`);
      this.addLog(`参数类型：${typeof locale}`);

      // 调用方法
      let systemCountries: Array<string> = i18n.System.getSystemCountries(locale);

      // 打印结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值类型：${typeof systemCountries}`);
      this.addLog(`  是否为数组：${Array.isArray(systemCountries)}`);
      this.addLog(`  数组长度：${systemCountries.length}`);

      this.addLog(`验证结果：调用成功`);
      this.addLog('========== testi18nSystemgetSystemCountries003 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getSystemCountries failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetSystemCountries003 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetSystemCountries003 结束 ==========\n');
    }
  }

  testi18nSystemgetSystemCountries004(): void {
    try {
      this.addLog('========== testi18nSystemgetSystemCountries001 开始 ==========');
      const locale = 'en';
      this.addLog(`调用API：i18n.System.getSystemCountries('${locale}')`);

      // 调用方法
      let systemCountries: Array<string> = i18n.System.getSystemCountries(locale);

      // 打印结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值类型：${typeof systemCountries}`);
      this.addLog(`  是否为数组：${Array.isArray(systemCountries)}`);
      this.addLog(`  数组长度：${systemCountries.length}`);
      this.addLog(`  前10个国家码：${systemCountries.slice(0, 10).join(', ')}${systemCountries.length > 10 ? '...' : ''}`);

      this.addLog(`验证结果：调用成功`);
      this.addLog('========== testi18nSystemgetSystemCountries001 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getSystemCountries failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetSystemCountries001 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetSystemCountries001 结束 ==========\n');
    }
  }
  testi18nSystemgetSystemCountries005(): void {
    try {
      this.addLog('========== testi18nSystemgetSystemCountries001 开始 ==========');
      const locale = 'ar';
      this.addLog(`调用API：i18n.System.getSystemCountries('${locale}')`);

      // 调用方法
      let systemCountries: Array<string> = i18n.System.getSystemCountries(locale);

      // 打印结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值类型：${typeof systemCountries}`);
      this.addLog(`  是否为数组：${Array.isArray(systemCountries)}`);
      this.addLog(`  数组长度：${systemCountries.length}`);
      this.addLog(`  前10个国家码：${systemCountries.slice(0, 10).join(', ')}${systemCountries.length > 10 ? '...' : ''}`);

      this.addLog(`验证结果：调用成功`);
      this.addLog('========== testi18nSystemgetSystemCountries001 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getSystemCountries failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetSystemCountries001 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetSystemCountries001 结束 ==========\n');
    }
  }
  // 验证语言/国家是否为推荐 - 双参数测试
  testi18nSystemisSuggested001(): void {
    try {
      this.addLog('========== testi18nSystemisSuggested001 开始 ==========');

      // 定义测试用例
      const testCases:testcase[] = [
        { lang: 'en', country: 'CN', desc: '英语+中国' },
        { lang: 'en', country: 'US', desc: '英语+美国' },
        { lang: 'zh', country: 'CN', desc: '中文+中国' },
        { lang: 'zh', country: 'US', desc: '中文+美国' }
      ];

      // 执行测试
      testCases.forEach((testCase, index) => {
        this.addLog(`【测试用例 ${index + 1}：${testCase.desc}】`);
        const result = i18n.System.isSuggested(testCase.lang, testCase.country);
        console.log(`isSuggestedCountry${index + 1}:`, result);
        this.addLog(`  调用：isSuggested('${testCase.lang}', '${testCase.country}')`);
        this.addLog(`  返回值：${result}`);
      });

      this.addLog(`验证结果：所有测试用例执行完成`);
      this.addLog('========== testi18nSystemisSuggested001 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.isSuggested failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemisSuggested001 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemisSuggested001 结束 ==========\n');
    }
  }

  // 验证语言/国家是否为推荐 - 单参数测试
  testi18nSystemisSuggested002(): void {
    try {
      this.addLog('========== testi18nSystemisSuggested002 开始 ==========');

      // 定义测试用例
      const testCases:testcase[] = [
        { lang: 'zh', desc: '中文（双参数）' },
        { lang: 'zh', desc: '中文（单参数）' },
        { lang: 'en', desc: '英语（单参数）' },
        { lang: 'zh', desc: '中文（对比测试）' },
        { lang: 'en', desc: '英语（对比测试）' }
      ];

      // 执行测试
      let results:boolean[] = [];
      results.push(i18n.System.isSuggested('zh', 'CN'));
      results.push(i18n.System.isSuggested('zh'));
      results.push(i18n.System.isSuggested('en'));
      results.push(i18n.System.isSuggested('zh'));
      results.push(i18n.System.isSuggested('en'));

      // 打印结果
      testCases.forEach((testCase, index) => {
        this.addLog(`【测试用例 ${index + 1}：${testCase.desc}】`);
        console.log(`isSuggestedCountry${index + 5}:`, results[index]);
        this.addLog(`  调用：isSuggested('${testCase.lang}'${index === 0 ? ', "CN"' : ''})`);
        this.addLog(`  返回值：${results[index]}（${results[index] ? 'true' : 'false'}）`);
        this.addLog(`  说明：${index === 0 ? '双参数调用' : '单参数调用，结果与系统当前地区相关'}`);
      });

      this.addLog(`验证结果：所有测试用例执行完成`);
      this.addLog('========== testi18nSystemisSuggested002 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.isSuggested failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemisSuggested002 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemisSuggested002 结束 ==========\n');
    }
  }

  // 验证语言/国家是否为推荐 - null参数
  testi18nSystemisSuggested003(): void {
    try {
      this.addLog('========== testi18nSystemisSuggested003 开始 ==========');
      const lang = null;
      this.addLog(`调用API：i18n.System.isSuggested(${lang})`);
      this.addLog(`参数值：${lang}`);
      this.addLog(`参数类型：${typeof lang}`);

      // 调用方法
      let isSuggestedCountry: boolean = i18n.System.isSuggested(lang);
      this.addLog(`第一次调用结果：${isSuggestedCountry}（${isSuggestedCountry ? 'true' : 'false'}）`);

      // 对比测试
      let compareResult = i18n.System.isSuggested('en');
      this.addLog(`对比调用：isSuggested('en')`);
      this.addLog(`对比结果：${compareResult}（${compareResult ? 'true' : 'false'}）`);

      this.addLog(`验证结果：调用完成`);
      this.addLog('========== testi18nSystemisSuggested003 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.isSuggested failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemisSuggested003 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemisSuggested003 结束 ==========\n');
    }
  }

  // 验证语言/国家是否为推荐 - undefined参数
  testi18nSystemisSuggested004(): void {
    try {
      this.addLog('========== testi18nSystemisSuggested004 开始 ==========');
      const lang = undefined;
      this.addLog(`调用API：i18n.System.isSuggested(${lang})`);
      this.addLog(`参数值：${lang}`);
      this.addLog(`参数类型：${typeof lang}`);

      // 调用方法
      let isSuggestedCountry: boolean = i18n.System.isSuggested(lang);
      this.addLog(`第一次调用结果：${isSuggestedCountry}（${isSuggestedCountry ? 'true' : 'false'}）`);

      // 对比测试
      let compareResult = i18n.System.isSuggested('en');
      this.addLog(`对比调用：isSuggested('en')`);
      this.addLog(`对比结果：${compareResult}（${compareResult ? 'true' : 'false'}）`);

      this.addLog(`验证结果：调用完成`);
      this.addLog('========== testi18nSystemisSuggested004 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.isSuggested failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemisSuggested004 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemisSuggested004 结束 ==========\n');
    }
  }

  // 获取偏好语言列表
  testi18nSystemgetPreferredLanguageList001(): void {
    try {
      this.addLog('========== testi18nSystemgetPreferredLanguageList001 开始 ==========');
      this.addLog(`调用API：i18n.System.getPreferredLanguageList()`);

      // 获取偏好语言列表
      let preferredLanguageList: Array<string> = i18n.System.getPreferredLanguageList();

      // 打印结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值类型：${typeof preferredLanguageList}`);
      this.addLog(`  是否为数组：${Array.isArray(preferredLanguageList)}`);
      this.addLog(`  数组长度：${preferredLanguageList.length}`);
      this.addLog(`  数组内容：${JSON.stringify(preferredLanguageList)}`);
      this.addLog(`  第一个语言：${preferredLanguageList[0] || '无'}`);

      console.info(`没有系统偏好语言，getPreferredLanguageList调用完成,列表信息:${preferredLanguageList}`);
      this.addLog(`验证结果：调用成功`);
      this.addLog('========== testi18nSystemgetPreferredLanguageList001 结束 ==========\n');
    } catch (error) {
      console.info("没有系统偏好语言，getPreferredLanguageList调用出错");
      this.addLog(`testi18nSystemgetPreferredLanguageList001 执行出错：`);
      this.addLog(`  错误信息：${(error as Error).message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetPreferredLanguageList001 结束 ==========\n');
    }
  }

  // 获取第一个偏好语言 - 空值测试
  testi18nSystemgetFirstPreferredLanguage001(): void {
    try {
      this.addLog('========== testi18nSystemgetFirstPreferredLanguage001 开始 ==========');


      this.addLog(`调用API：i18n.System.getFirstPreferredLanguage()`);

      // 获取第一个偏好语言
      let firstPreferredLanguage: string = i18n.System.getFirstPreferredLanguage();

      // 打印结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值类型：${typeof firstPreferredLanguage}`);
      this.addLog(`  返回值：${JSON.stringify(firstPreferredLanguage)}`);
      this.addLog(`  字符串长度：${firstPreferredLanguage?.length || 0}`);

      console.info(`没有系统偏好语言，testi18nSystemgetPreferredLanguageList001调用完成,列表中的第一个语言:${firstPreferredLanguage}`);
      this.addLog(`验证结果：调用成功`);
      this.addLog('========== testi18nSystemgetFirstPreferredLanguage001 结束 ==========\n');
    } catch (error) {
      console.info("没有系统偏好语言，getFirstPreferredLanguage调用出错");
      this.addLog(`testi18nSystemgetFirstPreferredLanguage001 执行出错：`);
      this.addLog(`  错误信息：${(error as Error).message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetFirstPreferredLanguage001 结束 ==========\n');
    }
  }


  // 获取是否使用本地数字格式
  testi18nSystemgetUsingLocalDigit001(): void {
    try {
      this.addLog('========== testi18nSystemgetUsingLocalDigit001 开始 ==========');
      this.addLog(`调用API：i18n.System.getUsingLocalDigit()`);

      // 调用方法
      let usingLocalDigit: boolean = i18n.System.getUsingLocalDigit();

      // 打印结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值类型：${typeof usingLocalDigit}`);
      this.addLog(`  返回值：${usingLocalDigit}（${usingLocalDigit ? 'true' : 'false'}）`);
      this.addLog(`  说明：${usingLocalDigit ? '使用本地数字格式' : '不使用本地数字格式'}`);

      console.info(`getUsingLocalDigit调用完成,列表信息:${usingLocalDigit}`);
      this.addLog(`验证结果：调用成功`);
      this.addLog('========== testi18nSystemgetUsingLocalDigit001 结束 ==========\n');
    } catch (error) {
      console.info("getUsingLocalDigit调用出错");
      this.addLog(`testi18nSystemgetUsingLocalDigit001 执行出错：`);
      this.addLog(`  错误信息：${(error as Error).message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetUsingLocalDigit001 结束 ==========\n');
    }
  }

  // 获取简化语言标识 - 无参数
  testi18nSystemgetSimplifiedLanguage001(): void {
    try {
      this.addLog('========== testi18nSystemgetSimplifiedLanguage001 开始 ==========');
      this.addLog(`调用API：i18n.System.getSimplifiedLanguage()`);

      // 调用方法
      let simplifiedLanguage: string = i18n.System.getSimplifiedLanguage();
      this.addLog(`第一次调用结果：${JSON.stringify(simplifiedLanguage)}`);

      // 再次调用获取系统语言
      let simplifiedSystemLanguage: string = i18n.System.getSimplifiedLanguage();
      this.addLog(`第二次调用结果：${JSON.stringify(simplifiedSystemLanguage)}`);
      this.addLog(`两次调用结果是否一致：${simplifiedLanguage === simplifiedSystemLanguage ? '是' : '否'}`);

      this.addLog(`验证结果：调用成功`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage001 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getSimplifiedLanguage failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetSimplifiedLanguage001 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage001 结束 ==========\n');
    }
  }

  // 获取简化语言标识 - 中文参数
  testi18nSystemgetSimplifiedLanguage002(): void {
    try {
      this.addLog('========== testi18nSystemgetSimplifiedLanguage002 开始 ==========');
      const lang = 'zh-Hans-CN';
      this.addLog(`调用API：i18n.System.getSimplifiedLanguage('${lang}')`);
      this.addLog(`参数说明：完整的中文语言标识`);

      // 调用方法
      let simplifiedLanguage: string = i18n.System.getSimplifiedLanguage(lang);
      this.addLog(`带参数调用结果：${JSON.stringify(simplifiedLanguage)}`);
      this.addLog(`预期结果：'zh'`);
      this.addLog(`是否匹配预期：${simplifiedLanguage === 'zh' ? '是' : '否'}`);

      this.addLog(`验证结果：调用成功`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage002 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getSimplifiedLanguage failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetSimplifiedLanguage002 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage002 结束 ==========\n');
    }
  }

  // 获取简化语言标识 - null参数
  testi18nSystemgetSimplifiedLanguage003(): void {
    try {
      this.addLog('========== testi18nSystemgetSimplifiedLanguage003 开始 ==========');
      const lang = null;
      this.addLog(`调用API：i18n.System.getSimplifiedLanguage(${lang})`);
      this.addLog(`参数值：${lang}`);
      this.addLog(`参数类型：${typeof lang}`);

      // 调用方法
      let simplifiedLanguage: string = i18n.System.getSimplifiedLanguage(lang);
      this.addLog(`带参数调用结果：${JSON.stringify(simplifiedLanguage)}`);

      // 对比系统语言
      let simplifiedSystemLanguage: string = i18n.System.getSimplifiedLanguage();
      this.addLog(`系统语言简化结果：${JSON.stringify(simplifiedSystemLanguage)}`);

      this.addLog(`验证结果：调用完成`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage003 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getSimplifiedLanguage failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetSimplifiedLanguage003 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage003 结束 ==========\n');
    }
  }

  // 获取简化语言标识 - undefined参数
  testi18nSystemgetSimplifiedLanguage004(): void {
    try {
      this.addLog('========== testi18nSystemgetSimplifiedLanguage004 开始 ==========');
      const lang = undefined;
      this.addLog(`调用API：i18n.System.getSimplifiedLanguage(${lang})`);
      this.addLog(`参数值：${lang}`);
      this.addLog(`参数类型：${typeof lang}`);

      // 调用方法
      let simplifiedLanguage: string = i18n.System.getSimplifiedLanguage(lang);
      this.addLog(`带参数调用结果：${JSON.stringify(simplifiedLanguage)}`);

      // 对比系统语言
      let simplifiedSystemLanguage: string = i18n.System.getSimplifiedLanguage();
      this.addLog(`系统语言简化结果：${JSON.stringify(simplifiedSystemLanguage)}`);

      this.addLog(`验证结果：调用完成`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage004 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getSimplifiedLanguage failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetSimplifiedLanguage004 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage004 结束 ==========\n');
    }
  }

  // 获取简化语言标识 - 空格参数
  testi18nSystemgetSimplifiedLanguage005(): void {
    try {
      this.addLog('========== testi18nSystemgetSimplifiedLanguage005 开始 ==========');
      const lang = ' ';
      this.addLog(`调用API：i18n.System.getSimplifiedLanguage('${JSON.stringify(lang)}')`);
      this.addLog(`参数说明：空格字符`);

      // 调用方法
      let simplifiedLanguage: string = i18n.System.getSimplifiedLanguage(lang);
      this.addLog(`带参数调用结果：${JSON.stringify(simplifiedLanguage)}`);

      // 对比系统语言
      let simplifiedSystemLanguage: string = i18n.System.getSimplifiedLanguage();
      this.addLog(`系统语言简化结果：${JSON.stringify(simplifiedSystemLanguage)}`);

      this.addLog(`验证结果：调用完成`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage005 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getSimplifiedLanguage failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetSimplifiedLanguage005 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage005 结束 ==========\n');
    }
  }

  // 获取简化语言标识 - 数字参数
  testi18nSystemgetSimplifiedLanguage006(): void {
    try {
      this.addLog('========== testi18nSystemgetSimplifiedLanguage006 开始 ==========');
      const lang = '111111111111111';
      this.addLog(`调用API：i18n.System.getSimplifiedLanguage('${lang}')`);
      this.addLog(`参数说明：纯数字字符串`);
      this.addLog(`参数长度：${lang.length}`);

      // 调用方法
      let simplifiedLanguage: string = i18n.System.getSimplifiedLanguage(lang);
      this.addLog(`带参数调用结果：${JSON.stringify(simplifiedLanguage)}`);

      // 对比系统语言
      let simplifiedSystemLanguage: string = i18n.System.getSimplifiedLanguage();
      this.addLog(`系统语言简化结果：${JSON.stringify(simplifiedSystemLanguage)}`);

      this.addLog(`验证结果：调用完成`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage006 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getSimplifiedLanguage failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetSimplifiedLanguage006 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage006 结束 ==========\n');
    }
  }

  // 获取简化语言标识 - 字母参数
  testi18nSystemgetSimplifiedLanguage007(): void {
    try {
      this.addLog('========== testi18nSystemgetSimplifiedLanguage007 开始 ==========');
      const lang = 'abc';
      this.addLog(`调用API：i18n.System.getSimplifiedLanguage('${lang}')`);
      this.addLog(`参数说明：纯字母字符串（非语言标识）`);

      // 调用方法
      let simplifiedLanguage: string = i18n.System.getSimplifiedLanguage(lang);
      this.addLog(`带参数调用结果：${JSON.stringify(simplifiedLanguage)}`);

      // 对比系统语言
      let simplifiedSystemLanguage: string = i18n.System.getSimplifiedLanguage();
      this.addLog(`系统语言简化结果：${JSON.stringify(simplifiedSystemLanguage)}`);

      this.addLog(`验证结果：调用完成`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage007 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getSimplifiedLanguage failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetSimplifiedLanguage007 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage007 结束 ==========\n');
    }
  }

  // 获取简化语言标识 - 特殊字符参数
  testi18nSystemgetSimplifiedLanguage008(): void {
    try {
      this.addLog('========== testi18nSystemgetSimplifiedLanguage008 开始 ==========');
      const lang = '!#';
      this.addLog(`调用API：i18n.System.getSimplifiedLanguage('${lang}')`);
      this.addLog(`参数说明：特殊字符组合`);

      // 调用方法
      let simplifiedLanguage: string = i18n.System.getSimplifiedLanguage(lang);
      this.addLog(`带参数调用结果：${JSON.stringify(simplifiedLanguage)}`);

      // 对比系统语言
      let simplifiedSystemLanguage: string = i18n.System.getSimplifiedLanguage();
      this.addLog(`系统语言简化结果：${JSON.stringify(simplifiedSystemLanguage)}`);

      this.addLog(`验证结果：调用完成`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage008 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getSimplifiedLanguage failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetSimplifiedLanguage008 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage008 结束 ==========\n');
    }
  }

  // 获取简化语言标识 - 中文字符参数
  testi18nSystemgetSimplifiedLanguage009(): void {
    try {
      this.addLog('========== testi18nSystemgetSimplifiedLanguage009 开始 ==========');
      const lang = '刘';
      this.addLog(`调用API：i18n.System.getSimplifiedLanguage('${lang}')`);
      this.addLog(`参数说明：中文字符`);

      // 调用方法
      let simplifiedLanguage: string = i18n.System.getSimplifiedLanguage(lang);
      this.addLog(`带参数调用结果：${JSON.stringify(simplifiedLanguage)}`);

      // 对比系统语言
      let simplifiedSystemLanguage: string = i18n.System.getSimplifiedLanguage();
      this.addLog(`系统语言简化结果：${JSON.stringify(simplifiedSystemLanguage)}`);

      this.addLog(`验证结果：调用完成`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage009 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getSimplifiedLanguage failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetSimplifiedLanguage009 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage009 结束 ==========\n');
    }
  }

  testi18nSystemgetSimplifiedLanguage010(): void {
    try {
      this.addLog('========== testi18nSystemgetSimplifiedLanguage010 开始 ==========');
      const lang = 'en-US';
      this.addLog(`调用API：i18n.System.getSimplifiedLanguage('${lang}')`);
      this.addLog(`参数说明：完整的中文语言标识`);

      // 调用方法
      let simplifiedLanguage: string = i18n.System.getSimplifiedLanguage(lang);
      this.addLog(`带参数调用结果：${JSON.stringify(simplifiedLanguage)}`);
      this.addLog(`预期结果：'en'`);
      this.addLog(`是否匹配预期：${simplifiedLanguage === 'en' ? '是' : '否'}`);


      this.addLog(`验证结果：调用成功`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage010 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getSimplifiedLanguage failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetSimplifiedLanguage002 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage002 结束 ==========\n');
    }
  }

  testi18nSystemgetSimplifiedLanguage011(): void {
    try {
      this.addLog('========== testi18nSystemgetSimplifiedLanguage011 开始 ==========');
      const lang = 'ar-Arab';
      this.addLog(`调用API：i18n.System.getSimplifiedLanguage('${lang}')`);
      this.addLog(`参数说明：完整的中文语言标识`);

      // 调用方法
      let simplifiedLanguage: string = i18n.System.getSimplifiedLanguage(lang);
      this.addLog(`带参数调用结果：${JSON.stringify(simplifiedLanguage)}`);
      this.addLog(`预期结果：'ar'`);
      this.addLog(`是否匹配预期：${simplifiedLanguage === 'ar' ? '是' : '否'}`);
      this.addLog(`验证结果：调用成功`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage011 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getSimplifiedLanguage failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetSimplifiedLanguage002 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetSimplifiedLanguage011 结束 ==========\n');
    }
  }

  // 测试周起始日
  private testFirstDayOfWeek(): void {
    try {
      this.addLog(`========== 测试getFirstDayOfWeek() 开始 ==========`);
      // 调用系统API获取周起始日
      const result = i18n.System.getFirstDayOfWeek();

      this.addLog(`调用API：i18n.System.getFirstDayOfWeek()`);
      this.addLog(`预期返回值：${i18n.WeekDay.SUN}`);
      this.addLog(`实际返回值：${result}（${this.getWeekDayName(result)}）`);
      this.addLog(`数值是否匹配：${result === i18n.WeekDay.SUN ? '是' : '否'}`);

      // 验证返回值是否符合预期
      if(i18n.System.getFirstDayOfWeek()===i18n.WeekDay.SUN){
        if (result === i18n.WeekDay.SUN) {
          this.addLog(`测试结果：通过（返回值匹配预期）`);
        } else {
          this.addLog(`测试结果：不通过（预期${i18n.WeekDay.SUN}，实际${result}）`);
        }
        this.addLog(`========== 测试getFirstDayOfWeek() 结束 ==========\n`);
      }
    } catch (error) {
      const err = error as BusinessError;
      this.addLog(`========== 测试getFirstDayOfWeek() 出错 ==========`);
      this.addLog(`错误码：${err.code}`);
      this.addLog(`错误信息：${err.message}`);
      this.addLog(`错误详情：${JSON.stringify(error)}`);
      this.addLog(`========== 测试getFirstDayOfWeek() 结束 ==========\n`);
    }
  }

  private testFirstDayOfWeekNew(expected: i18n.WeekDay, desc: string): void {
    try {
      this.addLog(`========== 测试getFirstDayOfWeek(${desc}) 开始 ==========`);
      // 调用系统API获取周起始日
        let result = i18n.System.getFirstDayOfWeek()

      this.addLog(`调用API：i18n.System.getFirstDayOfWeek()`);
      this.addLog(`预期返回值：${expected}（${desc} / ${this.getWeekDayName(expected)}）`);
      this.addLog(`实际返回值：${result}（${this.getWeekDayName(result)}）`);
      this.addLog(`数值是否匹配：${result === expected ? '是' : '否'}`);

      // 验证返回值是否符合预期
      if(i18n.System.getFirstDayOfWeek()===expected){
        if (result === expected) {
          this.addLog(`测试结果：通过（返回值匹配预期）`);
        } else {
          this.addLog(`测试结果：不通过（预期${expected}，实际${result}）`);
        }
        this.addLog(`========== 测试getFirstDayOfWeek(${desc}) 结束 ==========\n`);
      }
    } catch (error) {
      const err = error as BusinessError;
      this.addLog(`========== 测试getFirstDayOfWeek(${desc}) 出错 ==========`);
      this.addLog(`错误码：${err.code}`);
      this.addLog(`错误信息：${err.message}`);
      this.addLog(`错误详情：${JSON.stringify(error)}`);
      this.addLog(`========== 测试getFirstDayOfWeek(${desc}) 结束 ==========\n`);
    }
  }

  private testforWeekly(expected: i18n.WeekDay, desc: string):void {
    try {
      let calendar: i18n.Calendar = i18n.getCalendar('en-US', 'gregory');
      calendar.setFirstDayOfWeek(expected);
      let result: number = calendar.getFirstDayOfWeek();


      this.addLog(`调用API：i18n.System.getFirstDayOfWeek()`);
      this.addLog(`预期返回值：${expected}（${desc} / ${this.getWeekDayName(expected)}）`);
      this.addLog(`实际返回值：${result}（${this.getWeekDayName(result)}）`);
      this.addLog(`数值是否匹配：${result === expected ? '是' : '否'}`);

      // 验证返回值是否符合预期
      if (i18n.System.getFirstDayOfWeek() === expected) {
        if (result === expected) {
          this.addLog(`测试结果：通过（返回值匹配预期）`);
        } else {
          this.addLog(`测试结果：不通过（预期${expected}，实际${result}）`);
        }
        this.addLog(`========== 测试getFirstDayOfWeek(${desc}) 结束 ==========\n`);
      }
    } catch (error) {
      const err = error as BusinessError;
      this.addLog(`========== 测试getFirstDayOfWeek(${desc}) 出错 ==========`);
      this.addLog(`错误码：${err.code}`);
      this.addLog(`错误信息：${err.message}`);
      this.addLog(`错误详情：${JSON.stringify(error)}`);
      this.addLog(`========== 测试getFirstDayOfWeek(${desc}) 结束 ==========\n`);
    }
  }

  // 获取当前温度类型
  private getCurrentTemperatureType(): void {
    try {
      this.addLog('========== 获取系统温度类型 开始 ==========');
      this.addLog(`调用API：i18n.System.getTemperatureType()`);

      // 调用接口
      let temperatureType: i18n.TemperatureType = i18n.System.getTemperatureType();

      if(i18n.System.getTemperatureType()===i18n.TemperatureType.CELSIUS||i18n.System.getTemperatureType()===
      i18n.TemperatureType.FAHRENHEIT||i18n.System.getTemperatureType()===i18n.TemperatureType.KELVIN){
        this.addLog(`调用结果：`);
        this.addLog(`  返回值：${temperatureType}`);
        this.addLog(`  类型名称：${this.getTemperatureTypeName(temperatureType)}`);
        this.addLog(`  中文说明：${this.getTemperatureTypeDesc(temperatureType)}`);
        this.addLog(`  数值含义：${this.getTemperatureTypeValueDesc(temperatureType)}`);

        this.addLog(`验证结果：调用成功`);
        this.addLog('========== 获取系统温度类型 结束 ==========\n');
      }
    } catch (error) {
      const err = error as BusinessError;
      this.addLog(`========== 获取系统温度类型 出错 ==========`);
      this.addLog(`错误码：${err.code}，错误信息：${err.message}`);
      this.addLog(`错误详情：${JSON.stringify(error)}`);
      this.addLog(`========== 获取系统温度类型 结束 ==========\n`);
    }
  }

  private getTemperatureTypeName(type: i18n.TemperatureType): string {
    switch (type) {
      case i18n.TemperatureType.CELSIUS: return 'CELSIUS';
      case i18n.TemperatureType.FAHRENHEIT: return 'FAHRENHEIT';
      case i18n.TemperatureType.KELVIN: return 'KELVIN';
      default: return '未知温度类型';
    }
  }

  private getTemperatureTypeDesc(type: i18n.TemperatureType): string {
    switch (type) {
      case i18n.TemperatureType.CELSIUS: return '摄氏度(℃)';
      case i18n.TemperatureType.FAHRENHEIT: return '华氏度(℉)';
      case i18n.TemperatureType.KELVIN: return '开尔文(K)';
      default: return '无效类型';
    }
  }

  private getTemperatureTypeValueDesc(type: i18n.TemperatureType): string {
    switch (type) {
      case i18n.TemperatureType.CELSIUS: return '0 = 摄氏度';
      case i18n.TemperatureType.FAHRENHEIT: return '1 = 华氏度';
      case i18n.TemperatureType.KELVIN: return '2 = 开尔文';
      default: return `未知数值: ${type}`;
    }
  }

  // 测试温度类型名称
  private testTemperatureName(type: i18n.TemperatureType, typeDesc: string, expectedName: string): void {
    try {
      this.addLog(`========== 测试getTemperatureName(${typeDesc}) 开始 ==========`);
      this.addLog(`调用API：i18n.System.getTemperatureName(${typeDesc})`);
      this.addLog(`传入参数：`);
      this.addLog(`  枚举值：${type}`);
      this.addLog(`  枚举名称：${typeDesc}`);
      this.addLog(`  预期返回名称：${expectedName}`);

      // 调用API获取温度单位名称
      let temperatureName: string = i18n.System.getTemperatureName(type);

      this.addLog(`调用结果：`);
      this.addLog(`  实际返回名称：${JSON.stringify(temperatureName)}`);
      this.addLog(`  是否匹配预期：${temperatureName === expectedName ? '是' : '否'}`);

      // 验证返回名称是否符合预期
      if (temperatureName === expectedName) {
        this.addLog(`测试结果：通过（名称匹配预期）`);
      } else {
        this.addLog(`测试结果：不通过（预期${expectedName}，实际${temperatureName}）`);
      }
      this.addLog(`========== 测试getTemperatureName(${typeDesc}) 结束 ==========\n`);
    } catch (error) {
      const err = error as BusinessError;
      this.addLog(`========== 测试getTemperatureName(${typeDesc}) 出错 ==========`);
      this.addLog(`错误码：${err.code}`);
      this.addLog(`错误信息：${err.message}`);
      this.addLog(`错误详情：${JSON.stringify(error)}`);
      this.addLog(`========== 测试getTemperatureName(${typeDesc}) 结束 ==========\n`);
    }
  }

  // 获取温度类型名称 - null参数
  testi18nSystemgetTemperatureName004(): void {
    try {
      this.addLog('========== testi18nSystemgetTemperatureName004 开始 ==========');
      const type = null;
      this.addLog(`调用API：i18n.System.getTemperatureName(${type})`);
      this.addLog(`参数值：${type}`);
      this.addLog(`参数类型：${typeof type}`);

      // 调用方法
      let temperatureName: string = i18n.System.getTemperatureName(type);
      this.addLog(`调用结果：${JSON.stringify(temperatureName)}`);

      this.addLog(`验证结果：调用完成`);
      this.addLog('========== testi18nSystemgetTemperatureName004 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getTemperatureName failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetTemperatureName004 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetTemperatureName004 结束 ==========\n');
    }
  }

  // 获取温度类型名称 - undefined参数
  testi18nSystemgetTemperatureName005(): void {
    try {
      this.addLog('========== testi18nSystemgetTemperatureName005 开始 ==========');
      const type = undefined;
      this.addLog(`调用API：i18n.System.getTemperatureName(${type})`);
      this.addLog(`参数值：${type}`);
      this.addLog(`参数类型：${typeof type}`);

      // 调用方法
      let temperatureName: string = i18n.System.getTemperatureName(type);
      this.addLog(`调用结果：${JSON.stringify(temperatureName)}`);

      this.addLog(`验证结果：调用完成`);
      this.addLog('========== testi18nSystemgetTemperatureName005 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getTemperatureName failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetTemperatureName005 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetTemperatureName005 结束 ==========\n');
    }
  }

  // 获取温度类型名称 - 无效数值参数
  testi18nSystemgetTemperatureName006(): void {
    try {
      this.addLog('========== testi18nSystemgetTemperatureName006 开始 ==========');
      const type = 4;
      this.addLog(`调用API：i18n.System.getTemperatureName(${type})`);
      this.addLog(`参数值：${type}`);
      this.addLog(`参数说明：无效的温度类型数值（有效值：0=摄氏度,1=华氏度,2=开尔文）`);

      // 调用方法
      let temperatureName: string = i18n.System.getTemperatureName(type as i18n.TemperatureType);
      this.addLog(`调用结果：${JSON.stringify(temperatureName)}`);
      this.addLog(`验证结果：调用完成`);
      this.addLog('========== testi18nSystemgetTemperatureName006 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.error(`call System.getTemperatureName failed, error code: ${err.code}, message: ${err.message}.`);
      this.addLog(`testi18nSystemgetTemperatureName006 执行出错：`);
      this.addLog(`  错误码：${err.code}`);
      this.addLog(`  错误信息：${err.message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18nSystemgetTemperatureName006 结束 ==========\n');
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
      .height('50%')
      .padding(20);

      Scroll() {
        Text(this.log)
          .fontSize(14)
          .width('100%')
          .padding(10)
          .fontFamily('monospace') // 等宽字体，日志更整齐
      }
      .height('30%')
      .width('100%')
      .border({ width: 1, color: '#eee' })
      .borderRadius(5)
      .margin({ bottom: 10 })

      Button('清空日志')
        .onClick(() => this.clearLog())
        .fontSize(16)
        .width('80%')
        .height(45)
        .backgroundColor('#ff4757')
        .borderRadius(22)

      Button('返回主界面')
        .onClick(() => router.back())
        .fontSize(16)
        .width('80%')
        .height(45)
        .backgroundColor('#ff4757')
        .borderRadius(22)
    }
    .padding(10)
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}