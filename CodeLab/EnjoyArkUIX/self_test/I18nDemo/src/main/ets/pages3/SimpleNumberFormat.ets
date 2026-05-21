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
// struct SimpleNumberFormat {
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
//   testSimpleNumberFormatformat001() : void {
//     try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
//       let formattedNumber: string = formatter.format(10);
//       this.addLog(`formattedNumber为：${formattedNumber}，预期为 10% `);
//       if(formattedNumber == '10%'){
//         console.info('与预期结果相符，调用成功')
//         this.addLog('与预期结果相符，调用成功')
//       }else{
//         console.info('与预期结果不符，调用失败')
//         this.addLog('与预期结果不符，调用失败')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testSimpleNumberFormatformat002() : void {
//     try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
//       let formattedNumber: string = formatter.format(111111111111111);
//       this.addLog(`formattedNumber为：${formattedNumber}，预期为 111,111,111,111,111% `);
//       if(formattedNumber == '111,111,111,111,111%'){
//         console.info('与预期结果相符，调用成功')
//         this.addLog('与预期结果相符，调用成功')
//       }else{
//         console.info('与预期结果不符，调用失败')
//         this.addLog('与预期结果不符，调用失败')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testSimpleNumberFormatformat003() : void {
//     try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
//       let formattedNumber: string = formatter.format(1111.2222);
//       this.addLog(`formattedNumber为：${formattedNumber}，预期为 1,111.2222% `);
//       if(formattedNumber == '1,111.2222%'){
//         console.info('与预期结果相符，调用成功')
//         this.addLog('与预期结果相符，调用成功')
//       }else{
//         console.info('与预期结果不符，调用失败')
//         this.addLog('与预期结果不符，调用失败')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testSimpleNumberFormatformat004() : void {
//     try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
//       let formattedNumber: string = formatter.format(null);
//       this.addLog(`formattedNumber为：${formattedNumber}，预期为 null% `);
//       if(formattedNumber == '10%'){
//         console.info('与预期结果相符，调用成功')
//         this.addLog('与预期结果相符，调用成功')
//       }else{
//         console.info('与预期结果不符，调用失败')
//         this.addLog('与预期结果不符，调用失败')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   testSimpleNumberFormatformat005() : void {
//     try {
//       let locale: Intl.Locale = new Intl.Locale('zh-Hans-CN');
//       let formatter: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('%', locale);
//       let formattedNumber: string = formatter.format(undefined);
//       this.addLog(`formattedNumber为：${formattedNumber}，预期为 undefined% `);
//       if(formattedNumber == '10%'){
//         console.info('与预期结果相符，调用成功')
//         this.addLog('与预期结果相符，调用成功')
//       }else{
//         console.info('与预期结果不符，调用失败')
//         this.addLog('与预期结果不符，调用失败')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       console.error(`${err.code}`);
//       this.addLog(`调用失败，${err.code}+${err.message}`);
//     }
//   }
//   private buttonList:ButtonItem[] = [
//     { label: 'value为正常参数', onClick: () => this.testSimpleNumberFormatformat001() },
//     { label: 'value使用"111111111111111"', onClick: () => this.testSimpleNumberFormatformat002() },
//     { label: 'value使用"1111.2222"', onClick: () => this.testSimpleNumberFormatformat003() },
//     { label: 'value为null', onClick: () => this.testSimpleNumberFormatformat004() },
//     { label: 'value为undefined', onClick: () => this.testSimpleNumberFormatformat005() },
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