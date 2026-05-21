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
struct BreakIterator {
  @State log: string = '';

  // 日志显示格式
  private addlog(content: string) {
    this.log += `[${new Date().toLocaleTimeString()}] ${content}\n`;
  }

  // 清空日志
  private clearLog(): void {
    this.log = ""; // 清空日志
    this.addlog('日志已清除'); // 添加清除确认
    console.info('页面日志已清除');
  }

  private buttonList: ButtonItem[] = [
    { label: 'testBreakIteratorcurrent001', onClick: () => this.testBreakIteratorcurrent001() },
    { label: 'testBreakIteratorcurrent002', onClick: () => this.testBreakIteratorcurrent002() },
    { label: 'testBreakIteratorfirst001', onClick: () => this.testBreakIteratorfirst001() },
    { label: 'testBreakIteratorfirst002', onClick: () => this.testBreakIteratorfirst002() },
    { label: 'testBreakIteratorlast001', onClick: () => this.testBreakIteratorlast001() },
    { label: 'testBreakIteratorlast002', onClick: () => this.testBreakIteratorlast002() },
    { label: 'testBreakIteratornext001', onClick: () => this.testBreakIteratornext001() },
    { label: 'testBreakIteratornext002', onClick: () => this.testBreakIteratornext002() },
    { label: 'testBreakIteratornext003', onClick: () => this.testBreakIteratornext003() },
    { label: 'testBreakIteratorprevious001', onClick: () => this.testBreakIteratorprevious001() },
    { label: 'testBreakIteratorprevious002', onClick: () => this.testBreakIteratorprevious002() },
    { label: 'testBreakIteratorprevious003', onClick: () => this.testBreakIteratorprevious003() },
    { label: 'testBreakIteratorsetLineBreakText001', onClick: () => this.testBreakIteratorsetLineBreakText001() },
    { label: 'testBreakIteratorsetLineBreakText002', onClick: () => this.testBreakIteratorsetLineBreakText002() },
    { label: 'testBreakIteratorfollowing001', onClick: () => this.testBreakIteratorfollowing001() },
    { label: 'testBreakIteratorfollowing002', onClick: () => this.testBreakIteratorfollowing002() },
    { label: 'testBreakIteratorfollowing003', onClick: () => this.testBreakIteratorfollowing003() },
    { label: 'testBreakIteratorgetLineBreakText001', onClick: () => this.testBreakIteratorgetLineBreakText001() },
    { label: 'testBreakIteratorgetLineBreakText002', onClick: () => this.testBreakIteratorgetLineBreakText002() },
    { label: 'testBreakIteratorisBoundary001', onClick: () => this.testBreakIteratorisBoundary001() },
    { label: 'testBreakIteratorisBoundary002', onClick: () => this.testBreakIteratorisBoundary002() },
  ];

  // current方法测试001
  testBreakIteratorcurrent001(): void {
    try {
      this.addlog('========== testBreakIteratorcurrent001 开始 ==========');
      let iterator: i18n.BreakIterator = i18n.getLineInstance('en');
      const testText = 'Apple is my favorite fruit.';
      iterator.setLineBreakText(testText);
      this.addlog(`设置的测试文本：${testText}`);

      let currentPos: number = iterator.current();
      // 打印实际返回值
      this.addlog(`current() 调用返回值：${currentPos}`);
      this.addlog(`current() 预期返回值：0`);

      if (currentPos == 0) {
        this.addlog("验证结果：current调用正确");
      } else {
        this.addlog("验证结果：current调用失败");
      }
      this.addlog('========== testBreakIteratorcurrent001 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorcurrent001 执行出错：${JSON.stringify(error)}`);
    }
  }

  // current方法测试002（多语言）
  testBreakIteratorcurrent002(): void {
    try {
      this.addlog('========== testBreakIteratorcurrent002 开始 ==========');
      const testText = 'Apple is my favorite fruit.';
      this.addlog(`设置的测试文本：${testText}`);

      // 定义测试的语言列表
      const languages:lauage[] = [
        { code: 'en', name: '英语' },
        { code: 'zh', name: '中文' },
        { code: 'de', name: '德语' },
        { code: 'fr', name: '法语' },
        { code: 'es', name: '西班牙语' },
        { code: 'it', name: '意大利语' },
        { code: 'ar', name: '阿拉伯语' },
        { code: 'he', name: '希伯来语' }
      ];

      // 遍历测试各语言
      languages.forEach(lang => {
        try {
          let iterator: i18n.BreakIterator = i18n.getLineInstance(lang.code);
          iterator.setLineBreakText(testText);
          let currentPos: number = iterator.current();
          this.addlog(`【${lang.name}(${lang.code})】`);
          this.addlog(`  current() 返回值：${currentPos}`);
          this.addlog(`  current() 预期值：0`);
          this.addlog(`  验证结果：${currentPos === 0 ? '调用正确' : '调用失败'}`);
        } catch (err) {
          this.addlog(`【${lang.name}(${lang.code})】执行出错：${JSON.stringify(err)}`);
        }
      });

      this.addlog('========== testBreakIteratorcurrent002 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorcurrent002 执行出错：${JSON.stringify(error)}`);
    }
  }

  // first方法测试001
  testBreakIteratorfirst001(): void {
    try {
      this.addlog('========== testBreakIteratorfirst001 开始 ==========');
      let iterator: i18n.BreakIterator = i18n.getLineInstance('en');
      const testText = 'Apple is my favorite fruit.';
      iterator.setLineBreakText(testText);
      this.addlog(`设置的测试文本：${testText}`);

      let firstPos: number = iterator.first();
      this.addlog(`first() 调用返回值：${firstPos}`);
      this.addlog(`first() 预期返回值：0`);
      this.addlog(`验证结果：${firstPos === 0 ? 'first调用正确' : 'first调用失败'}`);
      this.addlog('========== testBreakIteratorfirst001 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorfirst001 执行出错：${JSON.stringify(error)}`);
    }
  }

  // first方法测试002（多语言）
  testBreakIteratorfirst002(): void {
    try {
      this.addlog('========== testBreakIteratorfirst002 开始 ==========');
      const testText = 'Apple is my favorite fruit.';
      this.addlog(`设置的测试文本：${testText}`);

      const languages:lauage[] = [
        { code: 'en', name: '英语' },
        { code: 'zh', name: '中文' },
        { code: 'de', name: '德语' },
        { code: 'fr', name: '法语' },
        { code: 'es', name: '西班牙语' },
        { code: 'it', name: '意大利语' },
        { code: 'ar', name: '阿拉伯语' },
        { code: 'he', name: '希伯来语' }
      ];

      languages.forEach(lang => {
        try {
          let iterator: i18n.BreakIterator = i18n.getLineInstance(lang.code);
          iterator.setLineBreakText(testText);
          let firstPos: number = iterator.first();
          this.addlog(`【${lang.name}(${lang.code})】`);
          this.addlog(`  first() 返回值：${firstPos}`);
          this.addlog(`  first() 预期值：0`);
          this.addlog(`  验证结果：${firstPos === 0 ? '调用正确' : '调用失败'}`);
        } catch (err) {
          this.addlog(`【${lang.name}(${lang.code})】执行出错：${JSON.stringify(err)}`);
        }
      });

      this.addlog('========== testBreakIteratorfirst002 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorfirst002 执行出错：${JSON.stringify(error)}`);
    }
  }

  // last方法测试001
  testBreakIteratorlast001(): void {
    try {
      this.addlog('========== testBreakIteratorlast001 开始 ==========');
      let iterator: i18n.BreakIterator = i18n.getLineInstance('en');
      const testText = 'Apple is my favorite fruit.';
      iterator.setLineBreakText(testText);
      this.addlog(`设置的测试文本：${testText}`);
      this.addlog(`测试文本长度：${testText.length}`);

      let lastPos: number = iterator.last();
      this.addlog(`last() 调用返回值：${lastPos}`);
      this.addlog(`last() 预期返回值：${testText.length}(27)`);
      this.addlog(`验证结果：${lastPos === 27 ? 'last调用正确' : 'last调用失败'}`);
      this.addlog('========== testBreakIteratorlast001 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorlast001 执行出错：${JSON.stringify(error)}`);
    }
  }

  // last方法测试002（多语言）
  testBreakIteratorlast002(): void {
    try {
      this.addlog('========== testBreakIteratorlast002 开始 ==========');
      const testText = 'Apple is my favorite fruit.';
      const expectedLastPos = testText.length;
      this.addlog(`设置的测试文本：${testText}`);
      this.addlog(`测试文本长度/预期返回值：${expectedLastPos}`);

      const languages:lauage[] = [
        { code: 'en', name: '英语' },
        { code: 'zh', name: '中文' },
        { code: 'de', name: '德语' },
        { code: 'fr', name: '法语' },
        { code: 'es', name: '西班牙语' },
        { code: 'it', name: '意大利语' },
        { code: 'ar', name: '阿拉伯语' },
        { code: 'he', name: '希伯来语' }
      ];

      languages.forEach(lang => {
        try {
          let iterator: i18n.BreakIterator = i18n.getLineInstance(lang.code);
          iterator.setLineBreakText(testText);
          let lastPos: number = iterator.last();
          this.addlog(`【${lang.name}(${lang.code})】`);
          this.addlog(`  last() 返回值：${lastPos}`);
          this.addlog(`  last() 预期值：${expectedLastPos}`);
          this.addlog(`  验证结果：${lastPos === expectedLastPos ? '调用正确' : '调用失败'}`);
        } catch (err) {
          this.addlog(`【${lang.name}(${lang.code})】执行出错：${JSON.stringify(err)}`);
        }
      });

      this.addlog('========== testBreakIteratorlast002 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorlast002 执行出错：${JSON.stringify(error)}`);
    }
  }

  // next方法测试001
  testBreakIteratornext001(): void {
    try {
      this.addlog('========== testBreakIteratornext001 开始 ==========');
      let iterator: i18n.BreakIterator = i18n.getLineInstance('en');
      const testText = 'Apple is my favorite fruit.';
      iterator.setLineBreakText(testText);
      this.addlog(`设置的测试文本：${testText}`);

      let pos: number = iterator.first();
      this.addlog(`first() 返回值：${pos} (预期：0)`);

      pos = iterator.next();
      this.addlog(`next() 返回值：${pos}`);
      this.addlog(`next() 预期值：6`);
      this.addlog(`验证结果：${pos === 6 ? 'next调用正确' : 'next调用失败'}`);
      this.addlog('========== testBreakIteratornext001 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratornext001 执行出错：${JSON.stringify(error)}`);
    }
  }

  // next方法测试002（带参数）
  testBreakIteratornext002(): void {
    try {
      this.addlog('========== testBreakIteratornext002 开始 ==========');
      let iterator: i18n.BreakIterator = i18n.getLineInstance('en');
      const testText = 'Apple is my favorite fruit.';
      iterator.setLineBreakText(testText);
      this.addlog(`设置的测试文本：${testText}`);

      let pos: number = iterator.first();
      this.addlog(`步骤1 - first() 返回值：${pos} (预期：0)`);

      pos = iterator.next();
      this.addlog(`步骤2 - next() 返回值：${pos} (预期：6)`);

      pos = iterator.next(10);
      this.addlog(`步骤3 - next(10) 返回值：${pos}`);
      this.addlog(`步骤3 - next(10) 预期值：-1`);
      this.addlog(`验证结果：${pos === -1 ? 'next调用正确' : 'next调用失败'}`);
      this.addlog('========== testBreakIteratornext002 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratornext002 执行出错：${JSON.stringify(error)}`);
    }
  }

  // next方法测试003（多语言）
  testBreakIteratornext003(): void {
    try {
      this.addlog('========== testBreakIteratornext003 开始 ==========');
      const testText = 'Apple is my favorite fruit.';
      const expectedNextPos = 6;
      this.addlog(`设置的测试文本：${testText}`);
      this.addlog(`next() 预期返回值：${expectedNextPos}`);

      const languages:lauage[] = [
        { code: 'en', name: '英语' },
        { code: 'zh', name: '中文' },
        { code: 'de', name: '德语' },
        { code: 'fr', name: '法语' },
        { code: 'es', name: '西班牙语' },
        { code: 'it', name: '意大利语' },
        { code: 'ar', name: '阿拉伯语' },
        { code: 'he', name: '希伯来语' }
      ];

      languages.forEach(lang => {
        try {
          let iterator: i18n.BreakIterator = i18n.getLineInstance(lang.code);
          iterator.setLineBreakText(testText);
          iterator.first();
          let nextPos: number = iterator.next();
          this.addlog(`【${lang.name}(${lang.code})】`);
          this.addlog(`  next() 返回值：${nextPos}`);
          this.addlog(`  next() 预期值：${expectedNextPos}`);
          this.addlog(`  验证结果：${nextPos === expectedNextPos ? '调用正确' : '调用失败'}`);
        } catch (err) {
          this.addlog(`【${lang.name}(${lang.code})】执行出错：${JSON.stringify(err)}`);
        }
      });

      this.addlog('========== testBreakIteratornext003 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratornext003 执行出错：${JSON.stringify(error)}`);
    }
  }

  // previous方法测试001
  testBreakIteratorprevious001(): void {
    try {
      this.addlog('========== testBreakIteratorprevious001 开始 ==========');
      let iterator: i18n.BreakIterator = i18n.getLineInstance('en');
      const testText = 'Apple is my favorite fruit.';
      iterator.setLineBreakText(testText);
      this.addlog(`设置的测试文本：${testText}`);

      let pos: number = iterator.first();
      this.addlog(`步骤1 - first() 返回值：${pos} (预期：0)`);

      pos = iterator.next(3);
      this.addlog(`步骤2 - next(3) 返回值：${pos} (预期：12)`);

      pos = iterator.previous();
      this.addlog(`步骤3 - previous() 返回值：${pos}`);
      this.addlog(`步骤3 - previous() 预期值：9`);
      this.addlog(`验证结果：${pos === 9 ? 'previous调用正确' : 'previous调用失败'}`);
      this.addlog('========== testBreakIteratorprevious001 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorprevious001 执行出错：${JSON.stringify(error)}`);
    }
  }

  // previous方法测试002（边界值）
  testBreakIteratorprevious002(): void {
    try {
      this.addlog('========== testBreakIteratorprevious002 开始 ==========');
      let iterator: i18n.BreakIterator = i18n.getLineInstance('en');
      const testText = 'Apple is my favorite fruit.';
      iterator.setLineBreakText(testText);
      this.addlog(`设置的测试文本：${testText}`);

      let pos: number = iterator.first();
      this.addlog(`步骤1 - first() 返回值：${pos} (预期：0)`);

      pos = iterator.previous();
      this.addlog(`步骤2 - previous() 返回值：${pos}`);
      this.addlog(`步骤2 - previous() 预期值：-1`);
      this.addlog(`验证结果：${pos === -1 ? 'previous调用正确' : 'previous调用失败'}`);
      this.addlog('========== testBreakIteratorprevious002 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorprevious002 执行出错：${JSON.stringify(error)}`);
    }
  }

  // previous方法测试003（多语言）
  testBreakIteratorprevious003(): void {
    try {
      this.addlog('========== testBreakIteratorprevious003 开始 ==========');
      const testText = 'Apple is my favorite fruit.';
      const expectedPreviousPos = 9;
      this.addlog(`设置的测试文本：${testText}`);
      this.addlog(`previous() 预期返回值：${expectedPreviousPos}`);

      const languages:lauage[] = [
        { code: 'en', name: '英语' },
        { code: 'zh', name: '中文' },
        { code: 'de', name: '德语' },
        { code: 'fr', name: '法语' },
        { code: 'es', name: '西班牙语' },
        { code: 'it', name: '意大利语' },
        { code: 'ar', name: '阿拉伯语' },
        { code: 'he', name: '希伯来语' }
      ];

      languages.forEach(lang => {
        try {
          let iterator: i18n.BreakIterator = i18n.getLineInstance(lang.code);
          iterator.setLineBreakText(testText);
          iterator.first();
          const next3Pos = iterator.next(3);
          this.addlog(`【${lang.name}(${lang.code})】`);
          this.addlog(`  next(3) 返回值：${next3Pos}`);
          const prevPos = iterator.previous();
          this.addlog(`  previous() 返回值：${prevPos}`);
          this.addlog(`  previous() 预期值：${expectedPreviousPos}`);
          this.addlog(`  验证结果：${prevPos === expectedPreviousPos ? '调用正确' : '调用失败'}`);
        } catch (err) {
          this.addlog(`【${lang.name}(${lang.code})】执行出错：${JSON.stringify(err)}`);
        }
      });

      this.addlog('========== testBreakIteratorprevious003 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorprevious003 执行出错：${JSON.stringify(error)}`);
    }
  }

  // setLineBreakText方法测试001
  testBreakIteratorsetLineBreakText001(): void {
    try {
      this.addlog('========== testBreakIteratorsetLineBreakText001 开始 ==========');
      let iterator: i18n.BreakIterator = i18n.getLineInstance('en');
      const testText = 'Apple is my favorite fruit.';
      this.addlog(`准备设置的文本：${testText}`);

      iterator.setLineBreakText(testText);
      this.addlog(`setLineBreakText() 执行完成`);

      let res: string = iterator.getLineBreakText();
      this.addlog(`getLineBreakText() 获取到的文本：${res}`);
      this.addlog(`预期文本：${testText}`);
      this.addlog(`验证结果：${res === testText ? 'setLineBreakText调用正确' : 'setLineBreakText调用失败'}`);
      this.addlog('========== testBreakIteratorsetLineBreakText001 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorsetLineBreakText001 执行出错：${JSON.stringify(error)}`);
    }
  }

  // setLineBreakText方法测试002（多语言）
  testBreakIteratorsetLineBreakText002(): void {
    try {
      this.addlog('========== testBreakIteratorsetLineBreakText002 开始 ==========');
      const testText = 'Apple is my favorite fruit.';
      this.addlog(`准备设置的文本：${testText}`);

      const languages:lauage[] = [
        { code: 'en', name: '英语' },
        { code: 'zh', name: '中文' },
        { code: 'de', name: '德语' },
        { code: 'fr', name: '法语' },
        { code: 'es', name: '西班牙语' },
        { code: 'it', name: '意大利语' },
        { code: 'ar', name: '阿拉伯语' },
        { code: 'he', name: '希伯来语' }
      ];

      languages.forEach(lang => {
        try {
          let iterator: i18n.BreakIterator = i18n.getLineInstance(lang.code);
          iterator.setLineBreakText(testText);
          this.addlog(`【${lang.name}(${lang.code})】`);
          this.addlog(`  setLineBreakText() 执行完成`);
          const res = iterator.getLineBreakText();
          this.addlog(`  getLineBreakText() 获取到的文本：${res}`);
          this.addlog(`  预期文本：${testText}`);
          this.addlog(`  验证结果：${res === testText ? '调用正确' : '调用失败'}`);
        } catch (err) {
          this.addlog(`【${lang.name}(${lang.code})】执行出错：${JSON.stringify(err)}`);
        }
      });

      this.addlog('========== testBreakIteratorsetLineBreakText002 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorsetLineBreakText002 执行出错：${JSON.stringify(error)}`);
    }
  }

  // following方法测试001
  testBreakIteratorfollowing001(): void {
    try {
      this.addlog('========== testBreakIteratorfollowing001 开始 ==========');
      let iterator: i18n.BreakIterator = i18n.getLineInstance('en');
      const testText = 'Apple is my favorite fruit.';
      iterator.setLineBreakText(testText);
      this.addlog(`设置的测试文本：${testText}`);

      let pos: number = iterator.following(0);
      this.addlog(`following(0) 返回值：${pos}`);
      this.addlog(`following(0) 预期值：6`);
      this.addlog(`验证结果：${pos === 6 ? 'following调用正确' : 'following调用失败'}`);
      this.addlog('========== testBreakIteratorfollowing001 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorfollowing001 执行出错：${JSON.stringify(error)}`);
    }
  }

  // following方法测试002（边界值）
  testBreakIteratorfollowing002(): void {
    try {
      this.addlog('========== testBreakIteratorfollowing002 开始 ==========');
      let iterator: i18n.BreakIterator = i18n.getLineInstance('en');
      const testText = 'Apple is my favorite fruit.';
      iterator.setLineBreakText(testText);
      this.addlog(`设置的测试文本：${testText}`);

      let pos: number = iterator.following(0);
      this.addlog(`步骤1 - following(0) 返回值：${pos} (预期：6)`);

      pos = iterator.following(100);
      this.addlog(`步骤2 - following(100) 返回值：${pos}`);
      this.addlog(`步骤2 - following(100) 预期值：-1`);
      this.addlog(`验证结果：${pos === -1 ? 'following调用正确' : 'following调用失败'}`);
      this.addlog('========== testBreakIteratorfollowing002 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorfollowing002 执行出错：${JSON.stringify(error)}`);
    }
  }

  // following方法测试003（多语言）
  testBreakIteratorfollowing003(): void {
    try {
      this.addlog('========== testBreakIteratorfollowing003 开始 ==========');
      const testText = 'Apple is my favorite fruit.';
      const offset = 0;
      const expectedFollowingPos = 6;
      this.addlog(`设置的测试文本：${testText}`);
      this.addlog(`调用参数：following(${offset})`);
      this.addlog(`预期返回值：${expectedFollowingPos}`);

      const languages:lauage[] = [
        { code: 'en', name: '英语' },
        { code: 'zh', name: '中文' },
        { code: 'de', name: '德语' },
        { code: 'fr', name: '法语' },
        { code: 'es', name: '西班牙语' },
        { code: 'it', name: '意大利语' },
        { code: 'ar', name: '阿拉伯语' },
        { code: 'he', name: '希伯来语' }
      ];

      languages.forEach(lang => {
        try {
          let iterator: i18n.BreakIterator = i18n.getLineInstance(lang.code);
          iterator.setLineBreakText(testText);
          this.addlog(`【${lang.name}(${lang.code})】`);
          const follPos = iterator.following(offset);
          this.addlog(`  following(${offset}) 返回值：${follPos}`);
          this.addlog(`  following(${offset}) 预期值：${expectedFollowingPos}`);
          this.addlog(`  验证结果：${follPos === expectedFollowingPos ? '调用正确' : '调用失败'}`);
        } catch (err) {
          this.addlog(`【${lang.name}(${lang.code})】执行出错：${JSON.stringify(err)}`);
        }
      });

      this.addlog('========== testBreakIteratorfollowing003 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorfollowing003 执行出错：${JSON.stringify(error)}`);
    }
  }

  // getLineBreakText方法测试001
  testBreakIteratorgetLineBreakText001(): void {
    try {
      this.addlog('========== testBreakIteratorgetLineBreakText001 开始 ==========');
      let iterator: i18n.BreakIterator = i18n.getLineInstance('en');
      const testText = 'Apple is my favorite fruit.123';
      this.addlog(`准备设置的文本：${testText}`);

      iterator.setLineBreakText(testText);
      this.addlog(`setLineBreakText() 执行完成`);

      let res: string = iterator.getLineBreakText();
      this.addlog(`getLineBreakText() 获取到的文本：${res}`);
      this.addlog(`预期文本：${testText}`);
      this.addlog(`验证结果：${res === testText ? 'getLineBreakText调用正确' : 'getLineBreakText调用失败'}`);
      this.addlog('========== testBreakIteratorgetLineBreakText001 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorgetLineBreakText001 执行出错：${JSON.stringify(error)}`);
    }
  }

  // getLineBreakText方法测试002（多语言）
  testBreakIteratorgetLineBreakText002(): void {
    try {
      this.addlog('========== testBreakIteratorgetLineBreakText002 开始 ==========');
      const testText = 'Apple is my favorite fruit.123';
      this.addlog(`准备设置的文本：${testText}`);

      const languages:lauage[] = [
        { code: 'en', name: '英语' },
        { code: 'zh', name: '中文' },
        { code: 'de', name: '德语' },
        { code: 'fr', name: '法语' },
        { code: 'es', name: '西班牙语' },
        { code: 'it', name: '意大利语' },
        { code: 'ar', name: '阿拉伯语' },
        { code: 'he', name: '希伯来语' }
      ];

      languages.forEach(lang => {
        try {
          let iterator: i18n.BreakIterator = i18n.getLineInstance(lang.code);
          iterator.setLineBreakText(testText);
          this.addlog(`【${lang.name}(${lang.code})】`);
          this.addlog(`  setLineBreakText() 执行完成`);
          const res = iterator.getLineBreakText();
          this.addlog(`  getLineBreakText() 获取到的文本：${res}`);
          this.addlog(`  预期文本：${testText}`);
          this.addlog(`  验证结果：${res === testText ? '调用正确' : '调用失败'}`);
        } catch (err) {
          this.addlog(`【${lang.name}(${lang.code})】执行出错：${JSON.stringify(err)}`);
        }
      });

      this.addlog('========== testBreakIteratorgetLineBreakText002 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorgetLineBreakText002 执行出错：${JSON.stringify(error)}`);
    }
  }

  // isBoundary方法测试001
  testBreakIteratorisBoundary001(): void {
    try {
      this.addlog('========== testBreakIteratorisBoundary001 开始 ==========');
      let iterator: i18n.BreakIterator = i18n.getLineInstance('en');
      const testText = 'Apple is my favorite fruit.';
      iterator.setLineBreakText(testText);
      this.addlog(`设置的测试文本：${testText}`);

      // 测试isBoundary(0)
      let isBoundary: boolean = iterator.isBoundary(0);
      let pos: number = iterator.current();
      this.addlog(`步骤1 - isBoundary(0) 返回值：${isBoundary} (预期：true)`);
      this.addlog(`步骤1 - current() 返回值：${pos} (预期：0)`);

      // 测试isBoundary(5)
      let isBoundary1 = iterator.isBoundary(5);
      let pos1: number = iterator.current();
      this.addlog(`步骤2 - isBoundary(5) 返回值：${isBoundary1} (预期：false)`);
      this.addlog(`步骤2 - current() 返回值：${pos1} (预期：6)`);

      // 验证最终结果
      const isSuccess = (pos == 0 && pos1 == 6);
      this.addlog(`综合验证结果：`);
      this.addlog(`  pos(0) = ${pos}, pos1(6) = ${pos1}`);
      this.addlog(`  验证结果：${isSuccess ? 'isBoundary调用正确' : 'isBoundary调用失败'}`);
      this.addlog('========== testBreakIteratorisBoundary001 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorisBoundary001 执行出错：${JSON.stringify(error)}`);
    }
  }

  // isBoundary方法测试002（多语言）
  testBreakIteratorisBoundary002(): void {
    try {
      this.addlog('========== testBreakIteratorisBoundary002 开始 ==========');
      const testText = 'Apple is my favorite fruit.';
      this.addlog(`设置的测试文本：${testText}`);

      const languages:lauage[] = [
        { code: 'en', name: '英语' },
        { code: 'zh', name: '中文' },
        { code: 'de', name: '德语' },
        { code: 'fr', name: '法语' },
        { code: 'es', name: '西班牙语' },
        { code: 'it', name: '意大利语' },
        { code: 'ar', name: '阿拉伯语' },
        { code: 'he', name: '希伯来语' }
      ];

      languages.forEach(lang => {
        try {
          let iterator: i18n.BreakIterator = i18n.getLineInstance(lang.code);
          iterator.setLineBreakText(testText);
          this.addlog(`【${lang.name}(${lang.code})】`);

          // 测试isBoundary(0)
          const isBoundary0 = iterator.isBoundary(0);
          const pos0 = iterator.current();
          this.addlog(`  isBoundary(0) 返回值：${isBoundary0} (预期：true)`);
          this.addlog(`  current() 返回值：${pos0} (预期：0)`);

          // 测试isBoundary(5)
          const isBoundary5 = iterator.isBoundary(5);
          const pos5 = iterator.current();
          this.addlog(`  isBoundary(5) 返回值：${isBoundary5} (预期：false)`);
          this.addlog(`  current() 返回值：${pos5} (预期：6)`);

          // 验证结果
          const isSuccess = (pos0 === 0 && pos5 === 6);
          this.addlog(`  综合验证结果：${isSuccess ? '调用正确' : '调用失败'}`);
        } catch (err) {
          this.addlog(`【${lang.name}(${lang.code})】执行出错：${JSON.stringify(err)}`);
        }
      });

      this.addlog('========== testBreakIteratorisBoundary002 结束 ==========\n');
    } catch (error) {
      this.addlog(`testBreakIteratorisBoundary002 执行出错：${JSON.stringify(error)}`);
    }
  }

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