import { BusinessError } from '@kit.BasicServicesKit';
import { i18n } from '@kit.LocalizationKit';
import router from '@ohos.router';

interface ButtonItem {
  label: string;
  onClick: () => void;
}

interface  lauage{
  code:string;
  expected:string;
  name:string
}

@Entry
@Component
struct I18NFilePathExample {
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
    { label: 'testCalendargetDisplayName001', onClick: () => this.testCalendargetDisplayName001() },
    { label: 'testCalendargetDisplayName002', onClick: () => this.testCalendargetDisplayName002() },
    { label: 'testCalendargetDisplayName003', onClick: () => this.testCalendargetDisplayName003() },
    { label: 'testCalendargetDisplayName004', onClick: () => this.testCalendargetDisplayName004() },
    { label: 'testCalendargetDisplayName005', onClick: () => this.testCalendargetDisplayName005() },
    { label: 'testCalendargetDisplayName006', onClick: () => this.testCalendargetDisplayName006() },
    { label: 'testCalendargetDisplayName007', onClick: () => this.testCalendargetDisplayName007() },
    { label: 'testCalendargetDisplayName008', onClick: () => this.testCalendargetDisplayName008() },
    { label: 'testCalendargetDisplayName009', onClick: () => this.testCalendargetDisplayName009() },
    { label: 'testCalendargetDisplayName010', onClick: () => this.testCalendargetDisplayName010() },
    { label: 'testCalendargetDisplayName011', onClick: () => this.testCalendargetDisplayName011() },
    { label: 'testCalendargetDisplayName012', onClick: () => this.testCalendargetDisplayName012() },
  ];

  // 基础测试 - 中文locale
  testCalendargetDisplayName001(): void {
    try {
      this.addlog('========== testCalendargetDisplayName001 开始 ==========');
      // 创建Calendar实例
      const calendarType = 'buddhist';
      const calendarLocale = 'en-US';
      let calendar: i18n.Calendar = i18n.getCalendar(calendarLocale, calendarType);
      this.addlog(`创建Calendar实例：`);
      this.addlog(`  区域设置：${calendarLocale}`);
      this.addlog(`  日历类型：${calendarType}`);

      // 调用getDisplayName
      const targetLocale = 'zh';
      let calendarName: string = calendar.getDisplayName(targetLocale);
      this.addlog(`调用getDisplayName('${targetLocale}')：`);
      this.addlog(`  实际返回值：${JSON.stringify(calendarName)}`);
      this.addlog(`  预期返回值："佛历"`);

      // 验证结果
      console.log("calendarName:" + calendarName);
      if (calendarName === '佛历') {
        console.info("调用getDisplayName成功");
        this.addlog(`验证结果：调用成功`);
      } else {
        this.addlog(`验证结果：调用失败（返回值与预期不符）`);
      }
      this.addlog('========== testCalendargetDisplayName001 结束 ==========\n');
    } catch (error) {
      console.info("调用getDisplayName出错", error);
      this.addlog(`testCalendargetDisplayName001 执行出错：${JSON.stringify(error)}`);
      this.addlog('========== testCalendargetDisplayName001 结束 ==========\n');
    }
  }

  // 多语言测试 - 欧洲各国语言
  testCalendargetDisplayName002(): void {
    try {
      this.addlog('========== testCalendargetDisplayName002 开始 ==========');
      // 创建Calendar实例
      const calendarType = 'buddhist';
      const calendarLocale = 'en-US';
      let calendar: i18n.Calendar = i18n.getCalendar(calendarLocale, calendarType);
      this.addlog(`创建Calendar实例：`);
      this.addlog(`  区域设置：${calendarLocale}`);
      this.addlog(`  日历类型：${calendarType}`);

      // 定义测试的语言列表
      const localeList:lauage[] = [
        { code: 'de', expected: 'Buddhistischer Kalender', name: '德语' },
        { code: 'fr', expected: 'calendrier bouddhiste', name: '法语' },
        { code: 'es', expected: 'calendario budista', name: '西班牙语' },
        { code: 'it', expected: 'Calendario buddista', name: '意大利语' },
        { code: 'pt', expected: 'Calendário Budista', name: '葡萄牙语' },
        { code: 'nl', expected: 'Boeddhistische kalender', name: '荷兰语' },
        { code: 'pl', expected: 'kalendarz buddyjski', name: '波兰语' },
        { code: 'ro', expected: 'calendar budist', name: '罗马尼亚语' },
        { code: 'hu', expected: 'Buddhista naptár', name: '匈牙利语' },
        { code: 'cs', expected: 'Buddhistický kalendář', name: '捷克语' },
      ];

      // 遍历测试各语言
      localeList.forEach(item => {
        try {
          let calendarName: string = calendar.getDisplayName(item.code);
          this.addlog(`【${item.name}(${item.code})】`);
          this.addlog(`  调用getDisplayName('${item.code}')`);
          this.addlog(`  实际返回值：${JSON.stringify(calendarName)}`);
          this.addlog(`  预期返回值：${JSON.stringify(item.expected)}`);
          this.addlog(`  验证结果：${calendarName === item.expected ? '成功' : '失败'}`);
        } catch (err) {
          this.addlog(`【${item.name}(${item.code})】执行出错：${JSON.stringify(err)}`);
        }
      });

      this.addlog('========== testCalendargetDisplayName002 结束 ==========\n');
    } catch (error) {
      console.info("调用getDisplayName(EU locales)出错", error);
      this.addlog(`testCalendargetDisplayName002 执行出错：${JSON.stringify(error)}`);
      this.addlog('========== testCalendargetDisplayName002 结束 ==========\n');
    }
  }

  // 边界测试 - null参数
  testCalendargetDisplayName003(): void {
    try {
      this.addlog('========== testCalendargetDisplayName003 开始 ==========');
      // 创建Calendar实例
      const calendarType = 'buddhist';
      const calendarLocale = 'en-US';
      let calendar: i18n.Calendar = i18n.getCalendar(calendarLocale, calendarType);
      this.addlog(`创建Calendar实例：`);
      this.addlog(`  区域设置：${calendarLocale}`);
      this.addlog(`  日历类型：${calendarType}`);

      // 调用getDisplayName(null)
      let calendarName: string = calendar.getDisplayName(null);
      this.addlog(`调用getDisplayName(null)：`);
      this.addlog(`  实际返回值：${JSON.stringify(calendarName)}`);
      this.addlog(`  预期返回值：undefined`);

      // 验证结果
      if (calendarName === undefined) {
        console.info("调用getDisplayName(null)成功（undefined）");
        this.addlog(`验证结果：调用成功（返回undefined）`);
      } else {
        this.addlog(`验证结果：调用失败（返回值不是undefined）`);
      }
      this.addlog('========== testCalendargetDisplayName003 结束 ==========\n');
    } catch (error) {
      console.info("调用getDisplayName出错", error);
      this.addlog(`testCalendargetDisplayName003 执行出错：${JSON.stringify(error)}`);
      this.addlog('========== testCalendargetDisplayName003 结束 ==========\n');
    }
  }

  // 边界测试 - undefined参数
  testCalendargetDisplayName004(): void {
    try {
      this.addlog('========== testCalendargetDisplayName004 开始 ==========');
      // 创建Calendar实例
      const calendarType = 'buddhist';
      const calendarLocale = 'en-US';
      let calendar: i18n.Calendar = i18n.getCalendar(calendarLocale, calendarType);
      this.addlog(`创建Calendar实例：`);
      this.addlog(`  区域设置：${calendarLocale}`);
      this.addlog(`  日历类型：${calendarType}`);

      // 调用getDisplayName(undefined)
      let calendarName: string = calendar.getDisplayName(undefined);
      this.addlog(`调用getDisplayName(undefined)：`);
      this.addlog(`  实际返回值：${JSON.stringify(calendarName)}`);
      this.addlog(`  预期返回值：undefined`);

      // 验证结果
      if (calendarName === undefined) {
        console.info("调用getDisplayName(undefined)成功（undefined）");
        this.addlog(`验证结果：调用成功（返回undefined）`);
      } else {
        this.addlog(`验证结果：调用失败（返回值不是undefined）`);
      }
      this.addlog('========== testCalendargetDisplayName004 结束 ==========\n');
    } catch (error) {
      console.info("调用getDisplayName出错", error);
      this.addlog(`testCalendargetDisplayName004 执行出错：${JSON.stringify(error)}`);
      this.addlog('========== testCalendargetDisplayName004 结束 ==========\n');
    }
  }

  // 异常测试 - 无效locale
  testCalendargetDisplayName005(): void {
    try {
      this.addlog('========== testCalendargetDisplayName005 开始 ==========');
      // 创建Calendar实例
      const calendarType = 'buddhist';
      const calendarLocale = 'en-US';
      let calendar: i18n.Calendar = i18n.getCalendar(calendarLocale, calendarType);
      this.addlog(`创建Calendar实例：`);
      this.addlog(`  区域设置：${calendarLocale}`);
      this.addlog(`  日历类型：${calendarType}`);

      // 调用getDisplayName(无效locale)
      const invalidLocale = 'invalid-locale-123';
      let calendarName: string = calendar.getDisplayName(invalidLocale);
      this.addlog(`调用getDisplayName('${invalidLocale}')：`);
      this.addlog(`  实际返回值：${JSON.stringify(calendarName)}`);
      this.addlog(`  预期返回值：""（空字符串）`);

      // 验证结果
      if (calendarName === '') {
        console.info(`调用getDisplayName('${invalidLocale}')成功（返回空）`);
        this.addlog(`验证结果：调用成功（返回空字符串）`);
      } else {
        this.addlog(`验证结果：调用失败（返回值不是空字符串）`);
      }
      this.addlog('========== testCalendargetDisplayName005 结束 ==========\n');
    } catch (error) {
      console.info("调用getDisplayName出错", error);
      this.addlog(`testCalendargetDisplayName005 执行出错：${JSON.stringify(error)}`);
      this.addlog('========== testCalendargetDisplayName005 结束 ==========\n');
    }
  }

  // 异常测试 - 空字符串locale
  testCalendargetDisplayName006(): void {
    try {
      this.addlog('========== testCalendargetDisplayName006 开始 ==========');
      // 创建Calendar实例
      const calendarType = 'buddhist';
      const calendarLocale = 'en-US';
      let calendar: i18n.Calendar = i18n.getCalendar(calendarLocale, calendarType);
      this.addlog(`创建Calendar实例：`);
      this.addlog(`  区域设置：${calendarLocale}`);
      this.addlog(`  日历类型：${calendarType}`);

      // 调用getDisplayName(空字符串)
      const emptyLocale = '';
      let calendarName: string = calendar.getDisplayName(emptyLocale);
      this.addlog(`调用getDisplayName('${emptyLocale}')：`);
      this.addlog(`  实际返回值：${JSON.stringify(calendarName)}`);
      this.addlog(`  预期返回值："buddhist"`);

      // 验证结果
      if (calendarName === 'buddhist') {
        console.info(`调用getDisplayName('')成功（默认值）`);
        this.addlog(`验证结果：调用成功（返回默认值"buddhist"）`);
      } else {
        this.addlog(`验证结果：调用失败（返回值不是"buddhist"）`);
      }
      this.addlog('========== testCalendargetDisplayName006 结束 ==========\n');
    } catch (error) {
      console.info("调用getDisplayName出错", error);
      this.addlog(`testCalendargetDisplayName006 执行出错：${JSON.stringify(error)}`);
      this.addlog('========== testCalendargetDisplayName006 结束 ==========\n');
    }
  }

  // 异常测试 - 超长locale字符串
  testCalendargetDisplayName007(): void {
    try {
      this.addlog('========== testCalendargetDisplayName007 开始 ==========');
      // 创建Calendar实例
      const calendarType = 'buddhist';
      const calendarLocale = 'en-US';
      let calendar: i18n.Calendar = i18n.getCalendar(calendarLocale, calendarType);
      this.addlog(`创建Calendar实例：`);
      this.addlog(`  区域设置：${calendarLocale}`);
      this.addlog(`  日历类型：${calendarType}`);

      // 生成超长locale字符串
      const longLocale = 'a'.repeat(1000);
      this.addlog(`生成超长locale字符串：长度=${longLocale.length}字符`);

      // 调用getDisplayName
      let calendarName: string = calendar.getDisplayName(longLocale);
      this.addlog(`调用getDisplayName(超长字符串)：`);
      this.addlog(`  实际返回值：${JSON.stringify(calendarName)}`);
      this.addlog(`  预期返回值：""（空字符串）`);

      // 验证结果
      if (calendarName === '') {
        console.info("调用getDisplayName(longLocale)成功（返回空）");
        this.addlog(`验证结果：调用成功（返回空字符串）`);
      } else {
        this.addlog(`验证结果：调用失败（返回值不是空字符串）`);
      }
      this.addlog('========== testCalendargetDisplayName007 结束 ==========\n');
    } catch (error) {
      console.info("调用getDisplayName出错", error);
      this.addlog(`testCalendargetDisplayName007 执行出错：${JSON.stringify(error)}`);
      this.addlog('========== testCalendargetDisplayName007 结束 ==========\n');
    }
  }

  // 异常测试 - 空格locale
  testCalendargetDisplayName008(): void {
    try {
      this.addlog('========== testCalendargetDisplayName008 开始 ==========');
      // 创建Calendar实例
      const calendarType = 'buddhist';
      const calendarLocale = 'en-US';
      let calendar: i18n.Calendar = i18n.getCalendar(calendarLocale, calendarType);
      this.addlog(`创建Calendar实例：`);
      this.addlog(`  区域设置：${calendarLocale}`);
      this.addlog(`  日历类型：${calendarType}`);

      // 调用getDisplayName(单个空格)
      const spaceLocale = ' ';
      let calendarName: string = calendar.getDisplayName(spaceLocale);
      this.addlog(`调用getDisplayName('${JSON.stringify(spaceLocale)}')：`);
      this.addlog(`  实际返回值：${JSON.stringify(calendarName)}`);
      this.addlog(`  预期返回值：""（空字符串）`);

      // 验证结果
      if (calendarName === '') {
        console.info(`调用getDisplayName(' ')成功（返回空）`);
        this.addlog(`验证结果：调用成功（返回空字符串）`);
      } else {
        this.addlog(`验证结果：调用失败（返回值不是空字符串）`);
      }
      this.addlog('========== testCalendargetDisplayName008 结束 ==========\n');
    } catch (error) {
      console.info("调用getDisplayName出错", error);
      this.addlog(`testCalendargetDisplayName008 执行出错：${JSON.stringify(error)}`);
      this.addlog('========== testCalendargetDisplayName008 结束 ==========\n');
    }
  }

  // 异常测试 - 多个空格locale
  testCalendargetDisplayName009(): void {
    try {
      this.addlog('========== testCalendargetDisplayName009 开始 ==========');
      // 创建Calendar实例
      const calendarType = 'buddhist';
      const calendarLocale = 'en-US';
      let calendar: i18n.Calendar = i18n.getCalendar(calendarLocale, calendarType);
      this.addlog(`创建Calendar实例：`);
      this.addlog(`  区域设置：${calendarLocale}`);
      this.addlog(`  日历类型：${calendarType}`);

      // 调用getDisplayName(多个空格)
      const multiSpaceLocale = '   ';
      let calendarName: string = calendar.getDisplayName(multiSpaceLocale);
      this.addlog(`调用getDisplayName('${JSON.stringify(multiSpaceLocale)}')：`);
      this.addlog(`  实际返回值：${JSON.stringify(calendarName)}`);
      this.addlog(`  预期返回值：""（空字符串）`);

      // 验证结果
      if (calendarName === '') {
        console.info(`调用getDisplayName('   ')成功（返回空）`);
        this.addlog(`验证结果：调用成功（返回空字符串）`);
      } else {
        this.addlog(`验证结果：调用失败（返回值不是空字符串）`);
      }
      this.addlog('========== testCalendargetDisplayName009 结束 ==========\n');
    } catch (error) {
      console.info("调用getDisplayName出错", error);
      this.addlog(`testCalendargetDisplayName009 执行出错：${JSON.stringify(error)}`);
      this.addlog('========== testCalendargetDisplayName009 结束 ==========\n');
    }
  }

  // 异常测试 - 特殊字符locale
  testCalendargetDisplayName010(): void {
    try {
      this.addlog('========== testCalendargetDisplayName010 开始 ==========');
      // 创建Calendar实例
      const calendarType = 'buddhist';
      const calendarLocale = 'en-US';
      let calendar: i18n.Calendar = i18n.getCalendar(calendarLocale, calendarType);
      this.addlog(`创建Calendar实例：`);
      this.addlog(`  区域设置：${calendarLocale}`);
      this.addlog(`  日历类型：${calendarType}`);

      // 调用getDisplayName(特殊字符)
      const specialCharLocale = '!@#$%^&*()';
      let calendarName: string = calendar.getDisplayName(specialCharLocale);
      this.addlog(`调用getDisplayName('${specialCharLocale}')：`);
      this.addlog(`  实际返回值：${JSON.stringify(calendarName)}`);
      this.addlog(`  预期返回值：""（空字符串）`);

      // 验证结果
      if (calendarName === '') {
        console.info(`调用getDisplayName('!@#$%^&*()')成功（返回空）`);
        this.addlog(`验证结果：调用成功（返回空字符串）`);
      } else {
        this.addlog(`验证结果：调用失败（返回值不是空字符串）`);
      }
      this.addlog('========== testCalendargetDisplayName010 结束 ==========\n');
    } catch (error) {
      console.info("调用getDisplayName出错", error);
      this.addlog(`testCalendargetDisplayName010 执行出错：${JSON.stringify(error)}`);
      this.addlog('========== testCalendargetDisplayName010 结束 ==========\n');
    }
  }

  // 异常测试 - 中文字符locale
  testCalendargetDisplayName011(): void {
    try {
      this.addlog('========== testCalendargetDisplayName011 开始 ==========');
      // 创建Calendar实例
      const calendarType = 'buddhist';
      const calendarLocale = 'en-US';
      let calendar: i18n.Calendar = i18n.getCalendar(calendarLocale, calendarType);
      this.addlog(`创建Calendar实例：`);
      this.addlog(`  区域设置：${calendarLocale}`);
      this.addlog(`  日历类型：${calendarType}`);

      // 调用getDisplayName(中文字符)
      const chineseLocale = '中文';
      let calendarName: string = calendar.getDisplayName(chineseLocale);
      this.addlog(`调用getDisplayName('${chineseLocale}')：`);
      this.addlog(`  实际返回值：${JSON.stringify(calendarName)}`);
      this.addlog(`  预期返回值：""（空字符串）`);

      // 验证结果
      if (calendarName === '') {
        console.info(`调用getDisplayName('中文')成功（返回空）`);
        this.addlog(`验证结果：调用成功（返回空字符串）`);
      } else {
        this.addlog(`验证结果：调用失败（返回值不是空字符串）`);
      }
      this.addlog('========== testCalendargetDisplayName011 结束 ==========\n');
    } catch (error) {
      console.info("调用getDisplayName出错", error);
      this.addlog(`testCalendargetDisplayName011 执行出错：${JSON.stringify(error)}`);
      this.addlog('========== testCalendargetDisplayName011 结束 ==========\n');
    }
  }

  // 异常测试 - 格式错误的locale
  testCalendargetDisplayName012(): void {
    try {
      this.addlog('========== testCalendargetDisplayName012 开始 ==========');
      // 创建Calendar实例
      const calendarType = 'buddhist';
      const calendarLocale = 'en-US';
      let calendar: i18n.Calendar = i18n.getCalendar(calendarLocale, calendarType);
      this.addlog(`创建Calendar实例：`);
      this.addlog(`  区域设置：${calendarLocale}`);
      this.addlog(`  日历类型：${calendarType}`);

      // 调用getDisplayName(格式错误的locale)
      const invalidFormatLocale = 'en-US#123';
      let calendarName: string = calendar.getDisplayName(invalidFormatLocale);
      this.addlog(`调用getDisplayName('${invalidFormatLocale}')：`);
      this.addlog(`  实际返回值：${JSON.stringify(calendarName)}`);
      this.addlog(`  预期返回值：""（空字符串）`);

      // 验证结果
      if (calendarName === '') {
        console.info(`调用getDisplayName('en-US#123')成功（返回空）`);
        this.addlog(`验证结果：调用成功（返回空字符串）`);
      } else {
        this.addlog(`验证结果：调用失败（返回值不是空字符串）`);
      }
      this.addlog('========== testCalendargetDisplayName012 结束 ==========\n');
    } catch (error) {
      console.info("调用getDisplayName出错", error);
      this.addlog(`testCalendargetDisplayName012 执行出错：${JSON.stringify(error)}`);
      this.addlog('========== testCalendargetDisplayName012 结束 ==========\n');
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
            .width('100%') // 按钮在列表项中水平居中
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