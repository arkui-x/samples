//
// import { BusinessError } from '@kit.BasicServicesKit';
// import { i18n } from '@kit.LocalizationKit';
//
// interface ButtonItem {
//   label: string;
//   onClick: () => void;
// }
//
// @Entry
// @Component
// struct I18n {
//   @State log: string = '';
//
//   // 日志显示格式：添加带时间戳的日志
//   private addLog(content: string) {
//     this.log += `[${new Date().toLocaleTimeString()}] ${content}\n`;
//   }
//
//   // 清空日志
//   private clearLog(): void {
//     this.log = '';
//     this.addLog('日志已清除');
//     console.info('页面日志已清除');
//   }
//
//   // 日志显示区域的UI组件
//   @Builder LogDisplay() {
//     Scroll() {
//       Text(this.log)
//         .fontSize(14)
//         .width('100%')
//         .padding(10)
//     }
//     .height('30%')
//     .width('100%')
//     .border({ width: 1, color: '#eee' })
//     .borderRadius(5)
//   }
//
//
//   testi18ngetSimpleDateTimeFormatByPattern001() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == 'month(12)'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatByPattern002() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", );
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == 'month(12)'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatByPattern003() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('en-US');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == 'month(12)'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatByPattern004() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('de-DE');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == 'month(12)'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatByPattern005() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('fr-FR');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == 'month(12)'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatByPattern006() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('es-ES');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == 'month(12)'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatByPattern007() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("month", locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == 'month(12)'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testi18ngetSimpleDateTimeFormatByPattern008() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern(undefined, locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == 'month(12)'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testi18ngetSimpleDateTimeFormatByPattern009() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern(null, locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == 'month(12)'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testi18ngetSimpleDateTimeFormatByPattern010() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", null);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == 'month(12)'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testi18ngetSimpleDateTimeFormatByPattern011() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", undefined);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == 'month(12)'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testi18ngetSimpleDateTimeFormatByPattern012() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == 'month(12)'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatByPattern013() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('111111111111111');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == 'month(12)'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatByPattern014() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('a-b-c');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == 'month(12)'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatByPattern015() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('!#');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == 'month(12)'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatByPattern016() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('汉字');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == 'month(12)'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatBySkeleton001() :void{    try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == '2024/12/13'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatBySkeleton002() :void{    try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd',);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == '2024/12/13'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatBySkeleton003() :void{    try {
//       let locale: Intl.Locale = new Intl.Locale('en-US');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == '12/13/2024'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatBySkeleton004() :void{    try {
//       let locale: Intl.Locale = new Intl.Locale('de-DE');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == '13.12.2024'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatBySkeleton005() :void{    try {
//       let locale: Intl.Locale = new Intl.Locale('fr-FR');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == '13/12/2024'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatBySkeleton006() :void{    try {
//       let locale: Intl.Locale = new Intl.Locale('es-ES');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == '13/12/2024'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatBySkeleton007() :void{    try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton(null, locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == '2024/12/13'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testi18ngetSimpleDateTimeFormatBySkeleton008() :void{    try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton(undefined, locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == '2024/12/13'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testi18ngetSimpleDateTimeFormatBySkeleton009() :void{    try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('', locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == '2024/12/13'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testi18ngetSimpleDateTimeFormatBySkeleton010() :void{    try {
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', undefined);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == '2024/12/13'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testi18ngetSimpleDateTimeFormatBySkeleton011() :void{    try {
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', null);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == '2024/12/13'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testi18ngetSimpleDateTimeFormatBySkeleton012() :void{    try {
//       let locale: Intl.Locale = new Intl.Locale('111111111111111');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == '2024/12/13'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatBySkeleton013() :void{    try {
//       let locale: Intl.Locale = new Intl.Locale('a-b-c');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == '2024/12/13'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatBySkeleton014() :void{    try {
//       let locale: Intl.Locale = new Intl.Locale('!#');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == '2024/12/13'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleDateTimeFormatBySkeleton015() :void{    try {
//       let locale: Intl.Locale = new Intl.Locale('汉字');
//       let formatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
//       let date : Date = new Date(2024, 11, 13);
//       let formattedDate: string = formatter.format(date);
//       if(formattedDate == '2024/12/13'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//
//   testi18ngetSimpleNumberFormatBySkeleton001() :void{    try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale );
//       let formattedNumber: string = formatter.format(10);
//       if(formattedNumber == '10%'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleNumberFormatBySkeleton002() :void{    try {
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', );
//       let formattedNumber: string = formatter.format(10);
//       if(formattedNumber == '10%'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleNumberFormatBySkeleton003() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('en-US');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
//       let formattedNumber: string = formatter.format(10);
//       if(formattedNumber == '10%'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleNumberFormatBySkeleton004() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('de-DE');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
//       let formattedNumber: string = formatter.format(10);
//       if(formattedNumber == '10 %'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleNumberFormatBySkeleton005() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('fr-FR');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
//       let formattedNumber: string = formatter.format(10);
//       if(formattedNumber == '10 %'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleNumberFormatBySkeleton006() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('es-ES');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
//       let formattedNumber: string = formatter.format(10);
//       if(formattedNumber == '10 %'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleNumberFormatBySkeleton007() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton(null, locale);
//       let formattedNumber: string = formatter.format(10);
//       if(formattedNumber == '10%'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testi18ngetSimpleNumberFormatBySkeleton008() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('', locale);
//       let formattedNumber: string = formatter.format(10);
//       if(formattedNumber == '10%'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testi18ngetSimpleNumberFormatBySkeleton009() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton(undefined, locale);
//       let formattedNumber: string = formatter.format(10);
//       if(formattedNumber == '10%'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testi18ngetSimpleNumberFormatBySkeleton010() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', undefined);
//       let formattedNumber: string = formatter.format(10);
//       if(formattedNumber == '10%'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testi18ngetSimpleNumberFormatBySkeleton011() :void{
//     try {
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', null);
//       let formattedNumber: string = formatter.format(10);
//       if(formattedNumber == '10%'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testi18ngetSimpleNumberFormatBySkeleton012() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('111111111111111');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
//       let formattedNumber: string = formatter.format(10);
//       if(formattedNumber == '10%'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleNumberFormatBySkeleton013() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('a-b-c');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
//       let formattedNumber: string = formatter.format(10);
//       if(formattedNumber == '10%'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleNumberFormatBySkeleton014() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('!#');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
//       let formattedNumber: string = formatter.format(10);
//       if(formattedNumber == '10%'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testi18ngetSimpleNumberFormatBySkeleton015() :void{
//     try {
//       let locale: Intl.Locale = new Intl.Locale('汉字');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
//       let formattedNumber: string = formatter.format(10);
//       if(formattedNumber == '10%'){
//         console.info('调用成功')
//         this.addLog('调用成功')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   private buttonList:ButtonItem[] = [
//     { label: '正常调用"month(M)"和“zh-Hans-CN”', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern001() },
//     { label: '正常调用单参数', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern002() },
//     { label: 'locale使用英文（美国）', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern003() },
//     { label: 'locale使用德语（德国）', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern004() },
//     { label: 'locale使用法语（法国）', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern005() },
//     { label: 'locale使用西班牙语（西班牙）', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern006() },
//     { label: 'pattern为string且pattern无""标识', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern007() },
//     { label: 'pattern为undefined', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern008() },
//     { label: 'pattern为null', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern009() },
//     { label: 'locale为null', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern010() },
//     { label: 'locale为undefined', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern011() },
//     { label: 'locale使用 " "', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern012() },
//     { label: 'locale使用 111111111111111', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern013() },
//     { label: 'locale使用 " abc"', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern014() },
//     { label: 'locale使用 "!#"', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern015() },
//     { label: 'locale使用 "汉字 "', onClick: () => this.testi18ngetSimpleDateTimeFormatByPattern016() },
//     { label: '2正常调用双参', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton001() },
//     { label: '2正常调用单参数', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton002() },
//     { label: '2locale使用英文（美国）', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton003() },
//     { label: '2locale使用德语（德国）', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton004() },
//     { label: '2locale使用法语（法国）', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton005() },
//     { label: '2locale使用西班牙语（西班牙）', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton006() },
//     { label: '2skeleton为null', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton007() },
//     { label: '2skeleton为undefined', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton008() },
//     { label: '2skeleton为""', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton009() },
//     { label: '2locale为undefined', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton010() },
//     { label: '2locale为null', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton011() },
//     { label: '2locale使用"111111111111111"', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton012() },
//     { label: '2locale使用 " abc"', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton013() },
//     { label: '2locale使用 "!#"', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton014() },
//     { label: '2locale使用 "汉字 "', onClick: () => this.testi18ngetSimpleDateTimeFormatBySkeleton015() },
//     { label: '3正常调用双参', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton001() },
//     { label: '3正常调用单参数', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton002() },
//     { label: '3locale使用 英文（美国', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton003() },
//     { label: '3locale使用 德语（德国）', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton004() },
//     { label: '3locale使用 法语（法国）', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton005() },
//     { label: '3locale使用 使用西班牙语（西班牙', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton006() },
//     { label: '3skeleton为null', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton007() },
//     { label: '3skeleton为空', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton008() },
//     { label: '3skeleton为undefined', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton009() },
//     { label: '3locale为undefined', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton010() },
//     { label: '3locale为null', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton011() },
//     { label: '3locale使用"111111111111111"', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton012() },
//     { label: '3locale使用 " abc"', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton013() },
//     { label: '3locale使用 "!#"', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton014() },
//     { label: '3locale使用 "汉字 "', onClick: () => this.testi18ngetSimpleNumberFormatBySkeleton015() },
//   ];
//
//   build() {
//     Column() {
//       List(){
//         ForEach(
//           this.buttonList,
//           (item:ButtonItem) =>{
//             ListItem(){
//               Flex({ justifyContent: FlexAlign.Center }){
//                 Button(item.label)
//                   .onClick(item.onClick)
//                   .fontSize(16)
//                   .width('80%')
//                   .height(45)
//                   .backgroundColor('#007dff')
//                   .borderRadius(22)
//               }
//             }
//             .width('100%')
//             .padding({ top: 8, bottom: 8})
//           },
//           (item:ButtonItem) => item.label
//         )
//       }
//       .height('60%')
//       .padding(20)
//       //日志显示区域
//       Scroll() {
//         Text(this.log)
//           .fontSize(14)
//           .width('100%')
//           .padding(10)
//       }
//       .height('30%')
//       .width('100%')
//       .border({width:1,color:'#eee'})
//       .borderRadius(5)
//       Button('clear')
//         .onClick(()=>this.clearLog())
//     }
//   }
// }
