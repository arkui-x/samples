import { BusinessError } from '@kit.BasicServicesKit';
import { i18n } from '@kit.LocalizationKit';
import router from '@ohos.router';

interface ButtonItem {
  label: string;
  onClick: () => void;
}

interface  lauage{
  code:string;
  name:string
}
@Entry
@Component
struct I18NFilePathExample {
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

  private buttonList: ButtonItem[] = [
    { label: 'testi18ngetLineInstance001', onClick: () => this.testi18ngetLineInstance001() },
    { label: 'testi18ngetLineInstance002', onClick: () => this.testi18ngetLineInstance002() },
    { label: 'testi18ngetLineInstance003', onClick: () => this.testi18ngetLineInstance003() },
    { label: 'testi18ngetLineInstance004', onClick: () => this.testi18ngetLineInstance004() },
    { label: 'testi18ngetLineInstance005', onClick: () => this.testi18ngetLineInstance005() },
    { label: 'testi18ngetLineInstance006', onClick: () => this.testi18ngetLineInstance006() },
    { label: 'testi18ngetLineInstance007', onClick: () => this.testi18ngetLineInstance007() },
    { label: 'testi18ngetLineInstance008', onClick: () => this.testi18ngetLineInstance008() },
    { label: 'testi18ngetLineInstance009', onClick: () => this.testi18ngetLineInstance009() },
    { label: 'testi18ngetLineInstance010', onClick: () => this.testi18ngetLineInstance010() },


    { label: 'testi18ngetInstance001', onClick: () => this.testi18ngetInstance001() },
    { label: 'testi18ngetInstance002', onClick: () => this.testi18ngetInstance002() },
    { label: 'testi18ngetInstance003', onClick: () => this.testi18ngetInstance003() },
    { label: 'testi18ngetInstance004', onClick: () => this.testi18ngetInstance004() },
    { label: 'testi18ngetInstance005', onClick: () => this.testi18ngetInstance005() },


    // { label: '正常调用"month(M)"和“zh-Hans-CN”', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern001() },
    // { label: '正常调用单参数', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern002() },
    // { label: 'locale使用英文（美国）', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern003() },
    // { label: 'locale使用德语（德国）', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern004() },
    // { label: 'locale使用法语（法国）', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern005() },
    // { label: 'locale使用西班牙语（西班牙）', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern006() },
    // { label: 'pattern为string且pattern无""标识', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern007() },
    // { label: 'pattern为undefined', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern008() },
    // { label: 'pattern为null', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern009() },
    // { label: 'locale为null', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern010() },
    // { label: 'locale为undefined', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern011() },
    // { label: 'locale使用 " "', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern012() },
    // { label: 'locale使用 111111111111111', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern013() },
    // { label: 'locale使用 " abc"', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern014() },
    // { label: 'locale使用 "!#"', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern015() },
    // { label: 'locale使用 "汉字 "', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern016() },
    // { label: '2正常调用双参', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton001() },
    // { label: '2正常调用单参数', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton002() },
    // { label: '2locale使用英文（美国）', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton003() },
    // { label: '2locale使用德语（德国）', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton004() },
    // { label: '2locale使用法语（法国）', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton005() },
    // { label: '2locale使用西班牙语（西班牙）', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton006() },
    // { label: '2skeleton为null', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton007() },
    // { label: '2skeleton为undefined', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton008() },
    // { label: '2skeleton为""', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton009() },
    // { label: '2locale为undefined', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton010() },
    // { label: '2locale为null', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton011() },
    // { label: '2locale使用"111111111111111"', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton012() },
    // { label: '2locale使用 " abc"', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton013() },
    // { label: '2locale使用 "!#"', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton014() },
    // { label: '2locale使用 "汉字 "', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton015() },
    // { label: '3正常调用双参', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton001() },
    // { label: '3正常调用单参数', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton002() },
    // { label: '3locale使用 英文（美国', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton003() },
    // { label: '3locale使用 德语（德国）', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton004() },
    // { label: '3locale使用 法语（法国）', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton005() },
    // { label: '3locale使用 使用西班牙语（西班牙', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton006() },
    // { label: '3skeleton为null', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton007() },
    // { label: '3skeleton为空', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton008() },
    // { label: '3skeleton为undefined', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton009() },
    // { label: '3locale为undefined', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton010() },
    // { label: '3locale为null', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton011() },
    // { label: '3locale使用"111111111111111"', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton012() },
    // { label: '3locale使用 " abc"', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton013() },
    // { label: '3locale使用 "!#"', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton014() },
    // { label: '3locale使用 "汉字 "', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton015() },
  ];

  // 基础测试 - 英文locale
  testi18ngetLineInstance001(): void {
    try {
      this.addLog('========== testi18ngetLineInstance001 开始 ==========');
      // 测试参数
      const targetLocale = 'en';
      this.addLog(`测试参数：getLineInstance('${targetLocale}')`);

      // 调用方法
      let iterator: i18n.BreakIterator = i18n.getLineInstance(targetLocale);

      // 打印返回结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值类型：${typeof iterator}`);
      this.addLog(`  返回值是否为null：${iterator === null}`);
      this.addLog(`  返回值是否有效：${!!iterator}`);
      this.addLog(`  返回值详情：${iterator ? 'BreakIterator实例' : '空值'}`);

      // 验证结果
      if (iterator) {
        console.info("调用getLineInstance('en')成功");
        this.addLog(`验证结果：调用成功（获取到BreakIterator实例）`);
      } else {
        this.addLog(`验证结果：调用失败（未获取到有效实例）`);
      }
      this.addLog('========== testi18ngetLineInstance001 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.info(`调用getLineInstance出错: ${(error as Error).message}`);
      this.addLog(`testi18ngetLineInstance001 执行出错：`);
      this.addLog(`  错误码：${err.code || '无'}`);
      this.addLog(`  错误信息：${err.message || (error as Error).message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18ngetLineInstance001 结束 ==========\n');
    }
  }

  // 多语言测试 - 各地区语言
  testi18ngetLineInstance002(): void {
    try {
      this.addLog('========== testi18ngetLineInstance002 开始 ==========');
      // 定义测试的语言列表
      const localeList:lauage[] = [
        { code: 'de', name: '德语' },
        { code: 'fr', name: '法语' },
        { code: 'es', name: '西班牙语' },
        { code: 'it', name: '意大利语' },
        { code: 'nl', name: '荷兰语' },
        { code: 'ar', name: '阿拉伯语' },
        { code: 'he', name: '希伯来语' },
        { code: 'ur', name: '乌尔都语' }
      ];

      // 遍历测试各语言
      localeList.forEach(item => {
        try {
          this.addLog(`【测试 ${item.name}(${item.code})】`);
          let iterator: i18n.BreakIterator = i18n.getLineInstance(item.code);

          // 打印调用结果
          console.log(`iterator${item.code}: ${iterator ? "获取成功" : "获取失败"}`);
          this.addLog(`  调用getLineInstance('${item.code}')`);
          this.addLog(`  返回值是否有效：${!!iterator}`);
          this.addLog(`  返回值类型：${typeof iterator}`);

          // 验证结果
          if (iterator) {
            console.info(`调用getLineInstance('${item.code}')成功`);
            this.addLog(`  验证结果：调用成功（获取到BreakIterator实例）`);
          } else {
            this.addLog(`  验证结果：调用失败（未获取到有效实例）`);
          }
        } catch (err) {
          const error = err as BusinessError;
          this.addLog(`  执行出错：`);
          this.addLog(`    错误码：${error.code || '无'}`);
          this.addLog(`    错误信息：${error.message || (err as Error).message}`);
        }
      });

      this.addLog('========== testi18ngetLineInstance002 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.info(`调用getLineInstance出错: ${(error as Error).message}`);
      this.addLog(`testi18ngetLineInstance002 执行出错：`);
      this.addLog(`  错误码：${err.code || '无'}`);
      this.addLog(`  错误信息：${err.message || (error as Error).message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18ngetLineInstance002 结束 ==========\n');
    }
  }

  // 边界测试 - null参数
  testi18ngetLineInstance003(): void {
    try {
      this.addLog('========== testi18ngetLineInstance003 开始 ==========');
      // 测试参数
      const targetLocale = null;
      this.addLog(`测试参数：getLineInstance(null)`);
      this.addLog(`参数类型：${typeof targetLocale}`);

      // 调用方法
      let iterator: i18n.BreakIterator = i18n.getLineInstance(targetLocale);

      // 打印返回结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值是否有效：${!!iterator}`);
      this.addLog(`  返回值类型：${typeof iterator}`);
      this.addLog(`  返回值是否为null：${iterator === null}`);

      // 验证结果
      if (iterator) {
        console.info("调用getLineInstance(null)成功");
        this.addLog(`验证结果：调用成功（获取到BreakIterator实例）`);
      } else {
        this.addLog(`验证结果：调用失败（未获取到有效实例）`);
      }
      this.addLog('========== testi18ngetLineInstance003 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.info("调用getLineInstance出错");
      this.addLog(`testi18ngetLineInstance003 执行出错：`);
      this.addLog(`  错误码：${err.code || '无'}`);
      this.addLog(`  错误信息：${err.message || (error as Error).message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18ngetLineInstance003 结束 ==========\n');
    }
  }

  // 边界测试 - undefined参数
  testi18ngetLineInstance004(): void {
    try {
      this.addLog('========== testi18ngetLineInstance004 开始 ==========');
      // 测试参数
      const targetLocale = undefined;
      this.addLog(`测试参数：getLineInstance(undefined)`);
      this.addLog(`参数类型：${typeof targetLocale}`);

      // 调用方法
      let iterator: i18n.BreakIterator = i18n.getLineInstance(targetLocale);

      // 打印返回结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值是否有效：${!!iterator}`);
      this.addLog(`  返回值类型：${typeof iterator}`);
      this.addLog(`  返回值是否为undefined：${iterator === undefined}`);

      // 验证结果
      if (iterator) {
        console.info("调用getLineInstance(undefined)成功");
        this.addLog(`验证结果：调用成功（获取到BreakIterator实例）`);
      } else {
        this.addLog(`验证结果：调用失败（未获取到有效实例）`);
      }
      this.addLog('========== testi18ngetLineInstance004 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.info("调用getLineInstance出错");
      this.addLog(`testi18ngetLineInstance004 执行出错：`);
      this.addLog(`  错误码：${err.code || '无'}`);
      this.addLog(`  错误信息：${err.message || (error as Error).message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18ngetLineInstance004 结束 ==========\n');
    }
  }

  // 异常测试 - 空字符串参数
  testi18ngetLineInstance005(): void {
    try {
      this.addLog('========== testi18ngetLineInstance005 开始 ==========');
      // 测试参数
      const targetLocale = '';
      this.addLog(`测试参数：getLineInstance('${JSON.stringify(targetLocale)}')`);
      this.addLog(`参数长度：${targetLocale.length}`);

      // 调用方法
      let iterator: i18n.BreakIterator = i18n.getLineInstance(targetLocale);

      // 打印返回结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值是否有效：${!!iterator}`);
      this.addLog(`  返回值类型：${typeof iterator}`);

      // 验证结果
      if (iterator) {
        console.info("调用getLineInstance('')成功");
        this.addLog(`验证结果：调用成功（获取到BreakIterator实例）`);
      } else {
        this.addLog(`验证结果：调用失败（未获取到有效实例）`);
      }
      this.addLog('========== testi18ngetLineInstance005 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.info("调用getLineInstance出错");
      this.addLog(`testi18ngetLineInstance005 执行出错：`);
      this.addLog(`  错误码：${err.code || '无'}`);
      this.addLog(`  错误信息：${err.message || (error as Error).message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18ngetLineInstance005 结束 ==========\n');
    }
  }

  // 异常测试 - 空格参数
  testi18ngetLineInstance006(): void {
    try {
      this.addLog('========== testi18ngetLineInstance006 开始 ==========');
      // 测试参数
      const targetLocale = ' ';
      this.addLog(`测试参数：getLineInstance('${JSON.stringify(targetLocale)}')`);
      this.addLog(`参数内容：空格字符`);

      // 调用方法
      let iterator: i18n.BreakIterator = i18n.getLineInstance(targetLocale);

      // 打印返回结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值是否有效：${!!iterator}`);
      this.addLog(`  返回值类型：${typeof iterator}`);

      // 验证结果
      if (iterator) {
        console.info("调用getLineInstance(' ')成功");
        this.addLog(`验证结果：调用成功（获取到BreakIterator实例）`);
      } else {
        this.addLog(`验证结果：调用失败（未获取到有效实例）`);
      }
      this.addLog('========== testi18ngetLineInstance006 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.info("调用getLineInstance出错");
      this.addLog(`testi18ngetLineInstance006 执行出错：`);
      this.addLog(`  错误码：${err.code || '无'}`);
      this.addLog(`  错误信息：${err.message || (error as Error).message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18ngetLineInstance006 结束 ==========\n');
    }
  }



  // 异常测试 - 无效locale参数
  testi18ngetLineInstance007(): void {
    try {
      this.addLog('========== testi18ngetLineInstance007 开始 ==========');
      // 测试参数
      const targetLocale = 'invalid-locale-123';
      this.addLog(`测试参数：getLineInstance('${targetLocale}')`);
      this.addLog(`参数说明：无效的locale格式`);

      // 调用方法
      let iterator: i18n.BreakIterator = i18n.getLineInstance(targetLocale);

      // 打印返回结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值是否有效：${!!iterator}`);
      this.addLog(`  返回值类型：${typeof iterator}`);

      // 验证结果
      if (iterator) {
        console.info("调用getLineInstance('invalid-locale-123')成功");
        this.addLog(`验证结果：调用成功（获取到BreakIterator实例）`);
      } else {
        this.addLog(`验证结果：调用失败（未获取到有效实例）`);
      }
      this.addLog('========== testi18ngetLineInstance007 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.info("调用getLineInstance出错");
      this.addLog(`testi18ngetLineInstance007 执行出错：`);
      this.addLog(`  错误码：${err.code || '无'}`);
      this.addLog(`  错误信息：${err.message || (error as Error).message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18ngetLineInstance007 结束 ==========\n');
    }
  }

  // 异常测试 - 特殊字符参数
  testi18ngetLineInstance008(): void {
    try {
      this.addLog('========== testi18ngetLineInstance008 开始 ==========');
      // 测试参数
      const targetLocale = '!@#$%^&*()';
      this.addLog(`测试参数：getLineInstance('${targetLocale}')`);
      this.addLog(`参数说明：特殊字符组合`);

      // 调用方法
      let iterator: i18n.BreakIterator = i18n.getLineInstance(targetLocale);

      // 打印返回结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值是否有效：${!!iterator}`);
      this.addLog(`  返回值类型：${typeof iterator}`);

      // 验证结果
      if (iterator) {
        console.info("调用getLineInstance('!@#$%^&*()')成功");
        this.addLog(`验证结果：调用成功（获取到BreakIterator实例）`);
      } else {
        this.addLog(`验证结果：调用失败（未获取到有效实例）`);
      }
      this.addLog('========== testi18ngetLineInstance008 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.info("调用getLineInstance出错");
      this.addLog(`testi18ngetLineInstance008 执行出错：`);
      this.addLog(`  错误码：${err.code || '无'}`);
      this.addLog(`  错误信息：${err.message || (error as Error).message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18ngetLineInstance008 结束 ==========\n');
    }
  }

  // 异常测试 - 中文字符参数
  testi18ngetLineInstance009(): void {
    try {
      this.addLog('========== testi18ngetLineInstance009 开始 ==========');
      // 测试参数
      const targetLocale = '中文';
      this.addLog(`测试参数：getLineInstance('${targetLocale}')`);
      this.addLog(`参数说明：中文字符`);

      // 调用方法
      let iterator: i18n.BreakIterator = i18n.getLineInstance(targetLocale);

      // 打印返回结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值是否有效：${!!iterator}`);
      this.addLog(`  返回值类型：${typeof iterator}`);

      // 验证结果
      if (iterator) {
        console.info("调用getLineInstance('中文')成功");
        this.addLog(`验证结果：调用成功（获取到BreakIterator实例）`);
      } else {
        this.addLog(`验证结果：调用失败（未获取到有效实例）`);
      }
      this.addLog('========== testi18ngetLineInstance009 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.info("调用getLineInstance出错");
      this.addLog(`testi18ngetLineInstance009 执行出错：`);
      this.addLog(`  错误码：${err.code || '无'}`);
      this.addLog(`  错误信息：${err.message || (error as Error).message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18ngetLineInstance009 结束 ==========\n');
    }
  }

  // 异常测试 - 超长字符串参数
  testi18ngetLineInstance010(): void {
    try {
      this.addLog('========== testi18ngetLineInstance010 开始 ==========');
      // 测试参数
      const longLocale = 'a'.repeat(1000);
      this.addLog(`测试参数：getLineInstance(超长字符串)`);
      this.addLog(`参数详情：`);
      this.addLog(`  字符串长度：${longLocale.length} 字符`);
      this.addLog(`  字符串前10个字符：${longLocale.substring(0, 10)}...`);

      // 调用方法
      let iterator: i18n.BreakIterator = i18n.getLineInstance(longLocale);

      // 打印返回结果
      this.addLog(`调用结果：`);
      this.addLog(`  返回值是否有效：${!!iterator}`);
      this.addLog(`  返回值类型：${typeof iterator}`);

      // 验证结果
      if (iterator) {
        console.info("调用getLineInstance(longLocale)成功");
        this.addLog(`验证结果：调用成功（获取到BreakIterator实例）`);
      } else {
        this.addLog(`验证结果：调用失败（未获取到有效实例）`);
      }
      this.addLog('========== testi18ngetLineInstance010 结束 ==========\n');
    } catch (error) {
      const err = error as BusinessError;
      console.info("调用getLineInstance出错");
      this.addLog(`testi18ngetLineInstance010 执行出错：`);
      this.addLog(`  错误码：${err.code || '无'}`);
      this.addLog(`  错误信息：${err.message || (error as Error).message}`);
      this.addLog(`  错误详情：${JSON.stringify(error)}`);
      this.addLog('========== testi18ngetLineInstance010 结束 ==========\n');
    }
  }

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


  // testi18ngetSimpleDateTimeFormatByPattern001() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
  //     let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
  //     let date : Date = new Date(2024, 11, 13);
  //     let formattedDate: string = formatter.format(date);
  //     if(formattedDate == 'month(12)'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleDateTimeFormatByPattern002() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
  //     let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", );
  //     let date : Date = new Date(2024, 11, 13);
  //     let formattedDate: string = formatter.format(date);
  //     if(formattedDate == 'month(12)'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleDateTimeFormatByPattern003() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('en-US');
  //     let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
  //     let date : Date = new Date(2024, 11, 13);
  //     let formattedDate: string = formatter.format(date);
  //     if(formattedDate == 'month(12)'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleDateTimeFormatByPattern004() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('de-DE');
  //     let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
  //     let date : Date = new Date(2024, 11, 13);
  //     let formattedDate: string = formatter.format(date);
  //     if(formattedDate == 'month(12)'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleDateTimeFormatByPattern005() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('fr-FR');
  //     let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
  //     let date : Date = new Date(2024, 11, 13);
  //     let formattedDate: string = formatter.format(date);
  //     if(formattedDate == 'month(12)'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleDateTimeFormatByPattern006() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('es-ES');
  //     let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
  //     let date : Date = new Date(2024, 11, 13);
  //     let formattedDate: string = formatter.format(date);
  //     if(formattedDate == 'month(12)'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleDateTimeFormatByPattern007() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
  //     let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("month", locale);
  //     let date : Date = new Date(2024, 11, 13);
  //     let formattedDate: string = formatter.format(date);
  //     if(formattedDate == 'month(12)'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     console.error(`${err.code}`);
  //     this.addLog(`调用失败，${err.code}+${err.message}`);
  //   }
  // }
  // testi18ngetSimpleDateTimeFormatByPattern008() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
  //     let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern(undefined, locale);
  //     let date : Date = new Date(2024, 11, 13);
  //     let formattedDate: string = formatter.format(date);
  //     if(formattedDate == 'month(12)'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     console.error(`${err.code}`);
  //     this.addLog(`调用失败，${err.code}+${err.message}`);
  //   }
  // }
  // testi18ngetSimpleDateTimeFormatByPattern009() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
  //     let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern(null, locale);
  //     let date : Date = new Date(2024, 11, 13);
  //     let formattedDate: string = formatter.format(date);
  //     if(formattedDate == 'month(12)'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     console.error(`${err.code}`);
  //     this.addLog(`调用失败，${err.code}+${err.message}`);
  //   }
  // }
  // testi18ngetSimpleDateTimeFormatByPattern010() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
  //     let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", null);
  //     let date : Date = new Date(2024, 11, 13);
  //     let formattedDate: string = formatter.format(date);
  //     if(formattedDate == 'month(12)'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     console.error(`${err.code}`);
  //     this.addLog(`调用失败，${err.code}+${err.message}`);
  //   }
  // }
  // testi18ngetSimpleDateTimeFormatByPattern011() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
  //     let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", undefined);
  //     let date : Date = new Date(2024, 11, 13);
  //     let formattedDate: string = formatter.format(date);
  //     if(formattedDate == 'month(12)'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     console.error(`${err.code}`);
  //     this.addLog(`调用失败，${err.code}+${err.message}`);
  //   }
  // }
  // testi18ngetSimpleDateTimeFormatByPattern012() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('');
  //     let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
  //     let date : Date = new Date(2024, 11, 13);
  //     let formattedDate: string = formatter.format(date);
  //     if(formattedDate == 'month(12)'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleDateTimeFormatByPattern013() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('111111111111111');
  //     let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
  //     let date : Date = new Date(2024, 11, 13);
  //     let formattedDate: string = formatter.format(date);
  //     if(formattedDate == 'month(12)'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleDateTimeFormatByPattern014() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('a-b-c');
  //     let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
  //     let date : Date = new Date(2024, 11, 13);
  //     let formattedDate: string = formatter.format(date);
  //     if(formattedDate == 'month(12)'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleDateTimeFormatByPattern015() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('!#');
  //     let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
  //     let date : Date = new Date(2024, 11, 13);
  //     let formattedDate: string = formatter.format(date);
  //     if(formattedDate == 'month(12)'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleDateTimeFormatByPattern016() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('汉字');
  //     let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
  //     let date : Date = new Date(2024, 11, 13);
  //     let formattedDate: string = formatter.format(date);
  //     if(formattedDate == 'month(12)'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleDateTimeFormatBySkeleton001() :void{    try {
  //   let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
  //   let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
  //   let date : Date = new Date(2024, 11, 13);
  //   let formattedDate: string = formatter.format(date);
  //   if(formattedDate == '2024/12/13'){
  //     console.info('调用成功')
  //     this.addLog('调用成功')
  //   }
  // } catch (err) {
  //   console.info('调用失败')
  //   this.addLog('调用失败')
  // }
  // }
  // testi18ngetSimpleDateTimeFormatBySkeleton002() :void{    try {
  //   let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
  //   let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd',);
  //   let date : Date = new Date(2024, 11, 13);
  //   let formattedDate: string = formatter.format(date);
  //   if(formattedDate == '2024/12/13'){
  //     console.info('调用成功')
  //     this.addLog('调用成功')
  //   }
  // } catch (err) {
  //   console.info('调用失败')
  //   this.addLog('调用失败')
  // }
  // }
  // testi18ngetSimpleDateTimeFormatBySkeleton003() :void{    try {
  //   let locale: Intl.Locale = new Intl.Locale('en-US');
  //   let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
  //   let date : Date = new Date(2024, 11, 13);
  //   let formattedDate: string = formatter.format(date);
  //   if(formattedDate == '12/13/2024'){
  //     console.info('调用成功')
  //     this.addLog('调用成功')
  //   }
  // } catch (err) {
  //   console.info('调用失败')
  //   this.addLog('调用失败')
  // }
  // }
  // testi18ngetSimpleDateTimeFormatBySkeleton004() :void{    try {
  //   let locale: Intl.Locale = new Intl.Locale('de-DE');
  //   let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
  //   let date : Date = new Date(2024, 11, 13);
  //   let formattedDate: string = formatter.format(date);
  //   if(formattedDate == '13.12.2024'){
  //     console.info('调用成功')
  //     this.addLog('调用成功')
  //   }
  // } catch (err) {
  //   console.info('调用失败')
  //   this.addLog('调用失败')
  // }
  // }
  // testi18ngetSimpleDateTimeFormatBySkeleton005() :void{    try {
  //   let locale: Intl.Locale = new Intl.Locale('fr-FR');
  //   let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
  //   let date : Date = new Date(2024, 11, 13);
  //   let formattedDate: string = formatter.format(date);
  //   if(formattedDate == '13/12/2024'){
  //     console.info('调用成功')
  //     this.addLog('调用成功')
  //   }
  // } catch (err) {
  //   console.info('调用失败')
  //   this.addLog('调用失败')
  // }
  // }
  // testi18ngetSimpleDateTimeFormatBySkeleton006() :void{    try {
  //   let locale: Intl.Locale = new Intl.Locale('es-ES');
  //   let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
  //   let date : Date = new Date(2024, 11, 13);
  //   let formattedDate: string = formatter.format(date);
  //   if(formattedDate == '13/12/2024'){
  //     console.info('调用成功')
  //     this.addLog('调用成功')
  //   }
  // } catch (err) {
  //   console.info('调用失败')
  //   this.addLog('调用失败')
  // }
  // }
  // testi18ngetSimpleDateTimeFormatBySkeleton007() :void{    try {
  //   let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
  //   let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton(null, locale);
  //   let date : Date = new Date(2024, 11, 13);
  //   let formattedDate: string = formatter.format(date);
  //   if(formattedDate == '2024/12/13'){
  //     console.info('调用成功')
  //     this.addLog('调用成功')
  //   }
  // } catch (err) {
  //   console.info('调用失败')
  //   console.error(`${err.code}`);
  //   this.addLog(`调用失败，${err.code}+${err.message}`);
  // }
  // }
  // testi18ngetSimpleDateTimeFormatBySkeleton008() :void{    try {
  //   let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
  //   let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton(undefined, locale);
  //   let date : Date = new Date(2024, 11, 13);
  //   let formattedDate: string = formatter.format(date);
  //   if(formattedDate == '2024/12/13'){
  //     console.info('调用成功')
  //     this.addLog('调用成功')
  //   }
  // } catch (err) {
  //   console.info('调用失败')
  //   console.error(`${err.code}`);
  //   this.addLog(`调用失败，${err.code}+${err.message}`);
  // }
  // }
  // testi18ngetSimpleDateTimeFormatBySkeleton009() :void{    try {
  //   let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
  //   let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('', locale);
  //   let date : Date = new Date(2024, 11, 13);
  //   let formattedDate: string = formatter.format(date);
  //   if(formattedDate == '2024/12/13'){
  //     console.info('调用成功')
  //     this.addLog('调用成功')
  //   }
  // } catch (err) {
  //   console.info('调用失败')
  //   console.error(`${err.code}`);
  //   this.addLog(`调用失败，${err.code}+${err.message}`);
  // }
  // }
  // testi18ngetSimpleDateTimeFormatBySkeleton010() :void{    try {
  //   let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', undefined);
  //   let date : Date = new Date(2024, 11, 13);
  //   let formattedDate: string = formatter.format(date);
  //   if(formattedDate == '2024/12/13'){
  //     console.info('调用成功')
  //     this.addLog('调用成功')
  //   }
  // } catch (err) {
  //   console.info('调用失败')
  //   console.error(`${err.code}`);
  //   this.addLog(`调用失败，${err.code}+${err.message}`);
  // }
  // }
  // testi18ngetSimpleDateTimeFormatBySkeleton011() :void{    try {
  //   let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', null);
  //   let date : Date = new Date(2024, 11, 13);
  //   let formattedDate: string = formatter.format(date);
  //   if(formattedDate == '2024/12/13'){
  //     console.info('调用成功')
  //     this.addLog('调用成功')
  //   }
  // } catch (err) {
  //   console.info('调用失败')
  //   console.error(`${err.code}`);
  //   this.addLog(`调用失败，${err.code}+${err.message}`);
  // }
  // }
  // testi18ngetSimpleDateTimeFormatBySkeleton012() :void{    try {
  //   let locale: Intl.Locale = new Intl.Locale('111111111111111');
  //   let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
  //   let date : Date = new Date(2024, 11, 13);
  //   let formattedDate: string = formatter.format(date);
  //   if(formattedDate == '2024/12/13'){
  //     console.info('调用成功')
  //     this.addLog('调用成功')
  //   }
  // } catch (err) {
  //   console.info('调用失败')
  //   this.addLog('调用失败')
  // }
  // }
  // testi18ngetSimpleDateTimeFormatBySkeleton013() :void{    try {
  //   let locale: Intl.Locale = new Intl.Locale('a-b-c');
  //   let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
  //   let date : Date = new Date(2024, 11, 13);
  //   let formattedDate: string = formatter.format(date);
  //   if(formattedDate == '2024/12/13'){
  //     console.info('调用成功')
  //     this.addLog('调用成功')
  //   }
  // } catch (err) {
  //   console.info('调用失败')
  //   this.addLog('调用失败')
  // }
  // }
  // testi18ngetSimpleDateTimeFormatBySkeleton014() :void{    try {
  //   let locale: Intl.Locale = new Intl.Locale('!#');
  //   let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
  //   let date : Date = new Date(2024, 11, 13);
  //   let formattedDate: string = formatter.format(date);
  //   if(formattedDate == '2024/12/13'){
  //     console.info('调用成功')
  //     this.addLog('调用成功')
  //   }
  // } catch (err) {
  //   console.info('调用失败')
  //   this.addLog('调用失败')
  // }
  // }
  // testi18ngetSimpleDateTimeFormatBySkeleton015() :void{    try {
  //   let locale: Intl.Locale = new Intl.Locale('汉字');
  //   let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
  //   let date : Date = new Date(2024, 11, 13);
  //   let formattedDate: string = formatter.format(date);
  //   if(formattedDate == '2024/12/13'){
  //     console.info('调用成功')
  //     this.addLog('调用成功')
  //   }
  // } catch (err) {
  //   console.info('调用失败')
  //   this.addLog('调用失败')
  // }
  // }
  //
  // testi18ngetSimpleNumberFormatBySkeleton001() :void{    try {
  //   let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
  //   let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale );
  //   let formattedNumber: string = formatter.format(10);
  //   if(formattedNumber == '10%'){
  //     console.info('调用成功')
  //     this.addLog('调用成功')
  //   }
  // } catch (err) {
  //   console.info('调用失败')
  //   this.addLog('调用失败')
  // }
  // }
  // testi18ngetSimpleNumberFormatBySkeleton002() :void{    try {
  //   let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', );
  //   let formattedNumber: string = formatter.format(10);
  //   if(formattedNumber == '10%'){
  //     console.info('调用成功')
  //     this.addLog('调用成功')
  //   }
  // } catch (err) {
  //   console.info('调用失败')
  //   this.addLog('调用失败')
  // }
  // }
  // testi18ngetSimpleNumberFormatBySkeleton003() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('en-US');
  //     let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
  //     let formattedNumber: string = formatter.format(10);
  //     if(formattedNumber == '10%'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleNumberFormatBySkeleton004() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('de-DE');
  //     let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
  //     let formattedNumber: string = formatter.format(10);
  //     if(formattedNumber == '10 %'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleNumberFormatBySkeleton005() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('fr-FR');
  //     let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
  //     let formattedNumber: string = formatter.format(10);
  //     if(formattedNumber == '10 %'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleNumberFormatBySkeleton006() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('es-ES');
  //     let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
  //     let formattedNumber: string = formatter.format(10);
  //     if(formattedNumber == '10 %'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleNumberFormatBySkeleton007() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
  //     let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton(null, locale);
  //     let formattedNumber: string = formatter.format(10);
  //     if(formattedNumber == '10%'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     console.error(`${err.code}`);
  //     this.addLog(`调用失败，${err.code}+${err.message}`);
  //   }
  // }
  // testi18ngetSimpleNumberFormatBySkeleton008() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
  //     let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('', locale);
  //     let formattedNumber: string = formatter.format(10);
  //     if(formattedNumber == '10%'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     console.error(`${err.code}`);
  //     this.addLog(`调用失败，${err.code}+${err.message}`);
  //   }
  // }
  // testi18ngetSimpleNumberFormatBySkeleton009() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
  //     let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton(undefined, locale);
  //     let formattedNumber: string = formatter.format(10);
  //     if(formattedNumber == '10%'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     console.error(`${err.code}`);
  //     this.addLog(`调用失败，${err.code}+${err.message}`);
  //   }
  // }
  // testi18ngetSimpleNumberFormatBySkeleton010() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
  //     let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', undefined);
  //     let formattedNumber: string = formatter.format(10);
  //     if(formattedNumber == '10%'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     console.error(`${err.code}`);
  //     this.addLog(`调用失败，${err.code}+${err.message}`);
  //   }
  // }
  // testi18ngetSimpleNumberFormatBySkeleton011() :void{
  //   try {
  //     let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', null);
  //     let formattedNumber: string = formatter.format(10);
  //     if(formattedNumber == '10%'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     console.error(`${err.code}`);
  //     this.addLog(`调用失败，${err.code}+${err.message}`);
  //   }
  // }
  // testi18ngetSimpleNumberFormatBySkeleton012() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('111111111111111');
  //     let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
  //     let formattedNumber: string = formatter.format(10);
  //     if(formattedNumber == '10%'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleNumberFormatBySkeleton013() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('a-b-c');
  //     let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
  //     let formattedNumber: string = formatter.format(10);
  //     if(formattedNumber == '10%'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleNumberFormatBySkeleton014() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('!#');
  //     let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
  //     let formattedNumber: string = formatter.format(10);
  //     if(formattedNumber == '10%'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }
  // testi18ngetSimpleNumberFormatBySkeleton015() :void{
  //   try {
  //     let locale: Intl.Locale = new Intl.Locale('汉字');
  //     let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
  //     let formattedNumber: string = formatter.format(10);
  //     if(formattedNumber == '10%'){
  //       console.info('调用成功')
  //       this.addLog('调用成功')
  //     }
  //   } catch (err) {
  //     console.info('调用失败')
  //     this.addLog('调用失败')
  //   }
  // }

  build() {
    Column() {
      // 按钮列表
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
      .padding(20)
      .height('50%')

      // 日志显示区域
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

      // 清空日志按钮
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