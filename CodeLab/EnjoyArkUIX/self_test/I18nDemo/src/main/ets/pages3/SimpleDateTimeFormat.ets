// import { BusinessError } from '@kit.BasicServicesKit';
// import { i18n } from '@kit.LocalizationKit';
//
// interface ButtonItem {
//   label: string;
//   onClick: () => void;
// }
//
//
// @Entry
// @Component
// struct SimpleDateTimeFormat {
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
//   testSimpleDateTimeFormatformat001() : void {
//     try {
//       let locale : Intl.Locale = new Intl.Locale("zh-Hans-CN");
//       let date : Date = new Date(2024, 11, 13);
//
//       let formatterWithText: i18n.SimpleDateTimeFormat =
//         i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
//       let formattedDate1: string = formatterWithText.format(date); // formattedDate = 'month(12)'
//
//       let patternFormatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern('yMd', locale);
//       let formattedDate2: string = patternFormatter.format(date); // formattedDate = '20241213'
//
//       let skeletonFormatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
//       let formattedDate3: string = skeletonFormatter.format(date); // formattedDate = '2024/12/13'
//       this.addLog(`formattedDate1为：${formattedDate1}，预期为 month(12) `);
//       this.addLog(`formattedDate2为：${formattedDate2}，预期为 20241213 `);
//       this.addLog(`formattedDate3为：${formattedDate3}，预期为 2024/12/13 `);
//       if(formattedDate1 == 'month(12)'&&formattedDate2 == '20241213'&&formattedDate3 == '2024/12/13'){
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
//   testSimpleDateTimeFormatformat002() : void {
//     try {
//       let locale : Intl.Locale = new Intl.Locale("zh-Hans-CN");
//       let date : Date|null = null;
//
//       let formatterWithText: i18n.SimpleDateTimeFormat =
//         i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
//       let formattedDate1: string = formatterWithText.format(date);
//
//       let patternFormatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern('yMd', locale);
//       let formattedDate2: string = patternFormatter.format(date);
//
//       let skeletonFormatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
//       let formattedDate3: string = skeletonFormatter.format(date);
//       this.addLog(`formattedDate1为：${formattedDate1}，预期为 month(12) `);
//       this.addLog(`formattedDate2为：${formattedDate2}，预期为 20241213 `);
//       this.addLog(`formattedDate3为：${formattedDate3}，预期为 2024/12/13 `);
//       if(formattedDate1 == 'month(12)'&&formattedDate2 == '20241213'&&formattedDate3 == '2024/12/13'){
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
//   testSimpleDateTimeFormatformat003() : void {
//     try {
//       let locale : Intl.Locale = new Intl.Locale("zh-Hans-CN");
//
//       let formatterWithText: i18n.SimpleDateTimeFormat =
//         i18n.getSimpleDateTimeFormatByPattern("'month('M')'", locale);
//       let formattedDate1: string = formatterWithText.format(undefined);
//
//       let patternFormatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatByPattern('yMd', locale);
//       let formattedDate2: string = patternFormatter.format(undefined);
//
//       let skeletonFormatter: i18n.SimpleDateTimeFormat = i18n.getSimpleDateTimeFormatBySkeleton('yMd', locale);
//       let formattedDate3: string = skeletonFormatter.format(undefined);
//       this.addLog(`formattedDate1为：${formattedDate1}，预期为 month(12) `);
//       this.addLog(`formattedDate2为：${formattedDate2}，预期为 20241213 `);
//       this.addLog(`formattedDate3为：${formattedDate3}，预期为 2024/12/13 `);
//       if(formattedDate1 == 'month(12)'&&formattedDate2 == '20241213'&&formattedDate3 == '2024/12/13'){
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
//
//   private buttonList:ButtonItem[] = [
//     { label: 'date为正常参数', onClick: () => this.testSimpleDateTimeFormatformat001() },
//     { label: 'date为null', onClick: () => this.testSimpleDateTimeFormatformat002() },
//     { label: 'date为undefined', onClick: () => this.testSimpleDateTimeFormatformat003() },
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