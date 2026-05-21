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
// struct StyledNumberFormat {
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
//     .border({ width: 1, color: '#fffdfcfc' })
//     .borderRadius(5)
//   }
//
//   format001() : void {
//     try {
//       let integerTextStyle: TextStyle = new TextStyle({ fontColor: Color.Red });
//       let decimalTextStyle: TextStyle = new TextStyle({ fontColor: Color.Brown });
//       let fractionTextStyle: TextStyle = new TextStyle({ fontColor: Color.Blue });
//       let unitTextStyle: TextStyle = new TextStyle({ fontColor: Color.Green });
//
//       let numFmt: Intl.NumberFormat = new Intl.NumberFormat('zh', { style: 'unit', unit: 'percent' });
//       let styledNumFmt: i18n.StyledNumberFormat = new i18n.StyledNumberFormat(numFmt, {
//         integer: integerTextStyle,
//         decimal: decimalTextStyle,
//         fraction: fractionTextStyle,
//         unit: unitTextStyle
//       });  // formattedNumber.getString() 为 '1,234.568%'。显示formattedNumber时'1,234'是红色，'.'是棕色，'568'是蓝色，'%'是绿色
//       let formattedNumber: StyledString = styledNumFmt.format(1234.5678);
//
//       let locale: Intl.Locale = new Intl.Locale('zh');
//       let simpleNumFmt: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('percent', locale);
//       let styledSimpleNumFmt: i18n.StyledNumberFormat = new i18n.StyledNumberFormat(simpleNumFmt, {
//         integer: integerTextStyle,
//         decimal: decimalTextStyle,
//         fraction: fractionTextStyle,
//         unit: unitTextStyle
//       });  // formattedSimpleNumber.getString() 为 '1,234.5678%'。显示formattedSimpleNumber时'1,234'是红色，'.'是棕色，'5678'是蓝色，'%'是绿色
//       let formattedSimpleNumber: StyledString = styledSimpleNumFmt.format(1234.5678);
//       this.addLog(`formattedNumber.getString() 为：${formattedNumber.getString()}，预期为 1,234.568% `);
//       this.addLog(`formattedSimpleNumber.getString() 为：${formattedSimpleNumber.getString()}，预期为 1,234.5678% `);
//       if(formattedNumber.getString()  == '1,234.568%'&&formattedSimpleNumber.getString()  == '1,234.5678%'){
//         console.info('与预期结果相符，调用成功')
//         this.addLog('与预期结果相符，调用成功')
//       }else{
//         console.info('与预期结果不符，调用失败')
//         this.addLog('与预期结果不符，调用失败')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testStyledNumberconstructorconstructor001() : void {
//     try {
//       let integerTextStyle: TextStyle = new TextStyle({ fontColor: Color.Red });
//       let decimalTextStyle: TextStyle = new TextStyle({ fontColor: Color.Brown });
//       let fractionTextStyle: TextStyle = new TextStyle({ fontColor: Color.Blue });
//       let unitTextStyle: TextStyle = new TextStyle({ fontColor: Color.Green });
//
//       let numFmt: Intl.NumberFormat = new Intl.NumberFormat('zh', { style: 'unit', unit: 'percent' });
//       let styledNumFmt: i18n.StyledNumberFormat = new i18n.StyledNumberFormat(numFmt, {
//         integer: integerTextStyle,
//         decimal: decimalTextStyle,
//         fraction: fractionTextStyle,
//         unit: unitTextStyle
//       });
//       let formattedNumber: StyledString = styledNumFmt.format(1234.5678);
//       this.addLog(`formattedNumber.getString() 为：${formattedNumber.getString()}，预期为 1,234.568% `);
//       if(formattedNumber.getString()  == '1,234.568%'){
//         console.info('与预期结果相符，调用成功')
//         this.addLog('与预期结果相符，调用成功')
//       }else{
//         console.info('与预期结果不符，调用失败')
//         this.addLog('与预期结果不符，调用失败')
//       }
//
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testStyledNumberconstructorconstructor002() : void {
//     try {
//       let integerTextStyle: TextStyle = new TextStyle({ fontColor: Color.Red });
//       let decimalTextStyle: TextStyle = new TextStyle({ fontColor: Color.Brown });
//       let fractionTextStyle: TextStyle = new TextStyle({ fontColor: Color.Blue });
//       let unitTextStyle: TextStyle = new TextStyle({ fontColor: Color.Green });
//
//       let locale: Intl.Locale = new Intl.Locale('zh');
//       let simpleNumFmt: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('percent', locale);
//       let styledSimpleNumFmt: i18n.StyledNumberFormat = new i18n.StyledNumberFormat(simpleNumFmt, {
//         integer: integerTextStyle,
//         decimal: decimalTextStyle,
//         fraction: fractionTextStyle,
//         unit: unitTextStyle
//       });
//       let formattedSimpleNumber: StyledString = styledSimpleNumFmt.format(1234.5678);
//       this.addLog(`formattedSimpleNumber.getString() 为：${formattedSimpleNumber.getString()}，预期为 1,234.5678% `);
//       if(formattedSimpleNumber.getString()  == '1,234.5678%'){
//         console.info('与预期结果相符，调用成功')
//         this.addLog('与预期结果相符，调用成功')
//       }else{
//         console.info('与预期结果不符，调用失败')
//         this.addLog('与预期结果不符，调用失败')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testStyledNumberconstructorconstructor003() : void {
//     try {
//       let integerTextStyle: TextStyle = new TextStyle({});
//       let decimalTextStyle: TextStyle = new TextStyle({});
//       let fractionTextStyle: TextStyle = new TextStyle({});
//       let unitTextStyle: TextStyle = new TextStyle({});
//
//       let numFmt: Intl.NumberFormat = new Intl.NumberFormat('zh', { style: 'unit', unit: 'percent' });
//       let styledNumFmt: i18n.StyledNumberFormat = new i18n.StyledNumberFormat(numFmt,{
//         integer: integerTextStyle,
//         decimal: decimalTextStyle,
//         fraction: fractionTextStyle,
//         unit: unitTextStyle
//       });
//       let formattedNumber: StyledString = styledNumFmt.format(1234.5678);
//       this.addLog(`formattedNumber.getString() 为：${formattedNumber.getString()}，预期为 1,234.568% `);
//       if(formattedNumber.getString()  == '1,234.568%'){
//         console.info('与预期结果相符，调用成功')
//         this.addLog('与预期结果相符，调用成功')
//       }else{
//         console.info('与预期结果不符，调用失败')
//         this.addLog('与预期结果不符，调用失败')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testStyledNumberconstructorconstructor004() : void {
//     try {
//       let integerTextStyle: TextStyle = new TextStyle({});
//       let decimalTextStyle: TextStyle = new TextStyle({});
//       let fractionTextStyle: TextStyle = new TextStyle({});
//       let unitTextStyle: TextStyle = new TextStyle({});
//
//       let locale: Intl.Locale = new Intl.Locale('zh');
//       let simpleNumFmt: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('percent', locale);
//       let styledSimpleNumFmt: i18n.StyledNumberFormat = new i18n.StyledNumberFormat(simpleNumFmt, {
//         integer: integerTextStyle,
//         decimal: decimalTextStyle,
//         fraction: fractionTextStyle,
//         unit: unitTextStyle
//       } );
//       let formattedSimpleNumber: StyledString = styledSimpleNumFmt.format(1234.5678);
//       this.addLog(`formattedSimpleNumber.getString() 为：${formattedSimpleNumber.getString()}，预期为 1,234.5678% `);
//       if(formattedSimpleNumber.getString()  == '1,234.5678%'){
//         console.info('与预期结果相符，调用成功')
//         this.addLog('与预期结果相符，调用成功')
//       }else{
//         console.info('与预期结果不符，调用失败')
//         this.addLog('与预期结果不符，调用失败')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testStyledNumberconstructorconstructor005() : void {
//     try {
//       let integerTextStyle: TextStyle = new TextStyle({ fontColor: Color.Red });
//       let decimalTextStyle: TextStyle = new TextStyle({ fontColor: Color.Brown });
//       let fractionTextStyle: TextStyle = new TextStyle({ fontColor: Color.Blue });
//       let unitTextStyle: TextStyle = new TextStyle({ fontColor: Color.Green });
//
//       let numFmt: Intl.NumberFormat = new Intl.NumberFormat('zh', { style: 'unit', unit: 'percent' });
//       let styledNumFmt: i18n.StyledNumberFormat = new i18n.StyledNumberFormat(numFmt, {
//         integer: integerTextStyle,
//         decimal: decimalTextStyle,
//         fraction: fractionTextStyle,
//         unit: unitTextStyle
//       });
//
//       let locale: Intl.Locale = new Intl.Locale('zh');
//       let simpleNumFmt: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('percent', locale);
//       let styledSimpleNumFmt: i18n.StyledNumberFormat = new i18n.StyledNumberFormat(simpleNumFmt, {
//         integer: integerTextStyle,
//         decimal: decimalTextStyle,
//         fraction: fractionTextStyle,
//         unit: unitTextStyle
//       });
//       let formattedNumber: StyledString = styledNumFmt.format(1234.5678);
//       let formattedSimpleNumber: StyledString = styledSimpleNumFmt.format(1234.5678);
//       this.addLog(`formattedNumber.getString() 为：${formattedNumber.getString()}，预期为 1,234.568% `);
//       this.addLog(`formattedSimpleNumber.getString() 为：${formattedSimpleNumber.getString()}，预期为 1,234.5678% `);
//       if(formattedNumber.getString()  == '1,234.568%'&&formattedSimpleNumber.getString()  == '1,234.5678%'){
//         console.info('与预期结果相符，调用成功')
//         this.addLog('与预期结果相符，调用成功')
//       }else{
//         console.info('与预期结果不符，调用失败')
//         this.addLog('与预期结果不符，调用失败')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testStyledNumberconstructorconstructor006() : void {
//     try {
//       let integerTextStyle: TextStyle = new TextStyle();
//       let decimalTextStyle: TextStyle = new TextStyle({ fontColor: Color.Brown });
//       let fractionTextStyle: TextStyle = new TextStyle({ fontColor: Color.Blue });
//       let unitTextStyle: TextStyle = new TextStyle({ fontColor: Color.Green });
//
//       let numFmt: Intl.NumberFormat = new Intl.NumberFormat('zh', { style: 'unit', unit: 'percent' });
//       let styledNumFmt: i18n.StyledNumberFormat = new i18n.StyledNumberFormat(numFmt, {
//         integer: integerTextStyle,
//         decimal: decimalTextStyle,
//         fraction: fractionTextStyle,
//         unit: unitTextStyle
//       });
//
//       let locale: Intl.Locale = new Intl.Locale('zh');
//       let simpleNumFmt: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('percent', locale);
//       let styledSimpleNumFmt: i18n.StyledNumberFormat = new i18n.StyledNumberFormat(simpleNumFmt, {
//         integer: integerTextStyle,
//         decimal: decimalTextStyle,
//         fraction: fractionTextStyle,
//         unit: unitTextStyle
//       });
//       let formattedNumber: StyledString = styledNumFmt.format(1234.5678);
//       let formattedSimpleNumber: StyledString = styledSimpleNumFmt.format(1234.5678);
//       this.addLog(`formattedNumber.getString() 为：${formattedNumber.getString()}，预期为 1,234.568% `);
//       this.addLog(`formattedSimpleNumber.getString() 为：${formattedSimpleNumber.getString()}，预期为 1,234.5678% `);
//       if(formattedNumber.getString()  == '1,234.568%'&&formattedSimpleNumber.getString()  == '1,234.5678%'){
//         console.info('与预期结果相符，调用成功')
//         this.addLog('与预期结果相符，调用成功')
//       }else{
//         console.info('与预期结果不符，调用失败')
//         this.addLog('与预期结果不符，调用失败')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testStyledNumberconstructorconstructor007() : void {
//     try {
//       let integerTextStyle: TextStyle = new TextStyle({ fontColor: Color.Red });
//       let decimalTextStyle: TextStyle = new TextStyle();
//       let fractionTextStyle: TextStyle = new TextStyle({ fontColor: Color.Blue });
//       let unitTextStyle: TextStyle = new TextStyle({ fontColor: Color.Green });
//
//       let numFmt: Intl.NumberFormat = new Intl.NumberFormat('zh', { style: 'unit', unit: 'percent' });
//       let styledNumFmt: i18n.StyledNumberFormat = new i18n.StyledNumberFormat(numFmt, {
//         integer: integerTextStyle,
//         decimal: decimalTextStyle,
//         fraction: fractionTextStyle,
//         unit: unitTextStyle
//       });
//
//       let locale: Intl.Locale = new Intl.Locale('zh');
//       let simpleNumFmt: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('percent', locale);
//       let styledSimpleNumFmt: i18n.StyledNumberFormat = new i18n.StyledNumberFormat(simpleNumFmt, {
//         integer: integerTextStyle,
//         decimal: decimalTextStyle,
//         fraction: fractionTextStyle,
//         unit: unitTextStyle
//       });
//       let formattedNumber: StyledString = styledNumFmt.format(1234.5678);
//       let formattedSimpleNumber: StyledString = styledSimpleNumFmt.format(1234.5678);
//       this.addLog(`formattedNumber.getString() 为：${formattedNumber.getString()}，预期为 1,234.568% `);
//       this.addLog(`formattedSimpleNumber.getString() 为：${formattedSimpleNumber.getString()}，预期为 1,234.5678% `);
//       if(formattedNumber.getString()  == '1,234.568%'&&formattedSimpleNumber.getString()  == '1,234.5678%'){
//         console.info('与预期结果相符，调用成功')
//         this.addLog('与预期结果相符，调用成功')
//       }else{
//         console.info('与预期结果不符，调用失败')
//         this.addLog('与预期结果不符，调用失败')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testStyledNumberconstructorconstructor008() : void {
//     try {
//       let integerTextStyle: TextStyle = new TextStyle({ fontColor: Color.Red });
//       let decimalTextStyle: TextStyle = new TextStyle({ fontColor: Color.Brown });
//       let fractionTextStyle: TextStyle = new TextStyle();
//       let unitTextStyle: TextStyle = new TextStyle({ fontColor: Color.Green });
//
//       let numFmt: Intl.NumberFormat = new Intl.NumberFormat('zh', { style: 'unit', unit: 'percent' });
//       let styledNumFmt: i18n.StyledNumberFormat = new i18n.StyledNumberFormat(numFmt, {
//         integer: integerTextStyle,
//         decimal: decimalTextStyle,
//         fraction: fractionTextStyle,
//         unit: unitTextStyle
//       });
//
//       let locale: Intl.Locale = new Intl.Locale('zh');
//       let simpleNumFmt: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('percent', locale);
//       let styledSimpleNumFmt: i18n.StyledNumberFormat = new i18n.StyledNumberFormat(simpleNumFmt, {
//         integer: integerTextStyle,
//         decimal: decimalTextStyle,
//         fraction: fractionTextStyle,
//         unit: unitTextStyle
//       });
//       let formattedNumber: StyledString = styledNumFmt.format(1234.5678);
//       let formattedSimpleNumber: StyledString = styledSimpleNumFmt.format(1234.5678);
//       this.addLog(`formattedNumber.getString() 为：${formattedNumber.getString()}，预期为 1,234.568% `);
//       this.addLog(`formattedSimpleNumber.getString() 为：${formattedSimpleNumber.getString()}，预期为 1,234.5678% `);
//       if(formattedNumber.getString()  == '1,234.568%'&&formattedSimpleNumber.getString()  == '1,234.5678%'){
//         console.info('与预期结果相符，调用成功')
//         this.addLog('与预期结果相符，调用成功')
//       }else{
//         console.info('与预期结果不符，调用失败')
//         this.addLog('与预期结果不符，调用失败')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//   testStyledNumberconstructorconstructor009() : void {
//     try {
//       let integerTextStyle: TextStyle = new TextStyle({ fontColor: Color.Red });
//       let decimalTextStyle: TextStyle = new TextStyle({ fontColor: Color.Brown });
//       let fractionTextStyle: TextStyle = new TextStyle({ fontColor: Color.Blue });
//       let unitTextStyle: TextStyle = new TextStyle();
//
//       let numFmt: Intl.NumberFormat = new Intl.NumberFormat('zh', { style: 'unit', unit: 'percent' });
//       let styledNumFmt: i18n.StyledNumberFormat = new i18n.StyledNumberFormat(numFmt, {
//         integer: integerTextStyle,
//         decimal: decimalTextStyle,
//         fraction: fractionTextStyle,
//         unit: unitTextStyle
//       });
//
//       let locale: Intl.Locale = new Intl.Locale('zh');
//       let simpleNumFmt: i18n.SimpleNumberFormat = i18n.getSimpleNumberFormatBySkeleton('percent', locale);
//       let styledSimpleNumFmt: i18n.StyledNumberFormat = new i18n.StyledNumberFormat(simpleNumFmt, {
//         integer: integerTextStyle,
//         decimal: decimalTextStyle,
//         fraction: fractionTextStyle,
//         unit: unitTextStyle
//       });
//       let formattedNumber: StyledString = styledNumFmt.format(1234.5678);
//       let formattedSimpleNumber: StyledString = styledSimpleNumFmt.format(1234.5678);
//       this.addLog(`formattedNumber.getString() 为：${formattedNumber.getString()}，预期为 1,234.568% `);
//       this.addLog(`formattedSimpleNumber.getString() 为：${formattedSimpleNumber.getString()}，预期为 1,234.5678% `);
//       if(formattedNumber.getString()  == '1,234.568%'&&formattedSimpleNumber.getString()  == '1,234.5678%'){
//         console.info('与预期结果相符，调用成功')
//         this.addLog('与预期结果相符，调用成功')
//       }else{
//         console.info('与预期结果不符，调用失败')
//         this.addLog('与预期结果不符，调用失败')
//       }
//     } catch (err) {
//       console.info('调用失败')
//       this.addLog('调用失败')
//     }
//   }
//
//   private buttonList:ButtonItem[] = [
//     { label: 'format001', onClick: () => this.format001() },
//     { label: 'constructor001', onClick: () => this.testStyledNumberconstructorconstructor001() },
//     { label: 'constructor002', onClick: () => this.testStyledNumberconstructorconstructor002() },
//     { label: 'constructor003', onClick: () => this.testStyledNumberconstructorconstructor003() },
//     { label: 'constructor004', onClick: () => this.testStyledNumberconstructorconstructor004() },
//     { label: '调用StyledNumberFormatOptions的format001', onClick: () => this.testStyledNumberconstructorconstructor005() },
//     { label: '调用StyledNumberFormatOptions的format002', onClick: () => this.testStyledNumberconstructorconstructor006() },
//     { label: '调用StyledNumberFormatOptions的format003', onClick: () => this.testStyledNumberconstructorconstructor007() },
//     { label: '调用StyledNumberFormatOptions的format004', onClick: () => this.testStyledNumberconstructorconstructor008() },
//     { label: '调用StyledNumberFormatOptions的format005', onClick: () => this.testStyledNumberconstructorconstructor009() },
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