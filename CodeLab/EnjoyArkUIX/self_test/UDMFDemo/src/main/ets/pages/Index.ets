/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { BusinessError } from '@kit.BasicServicesKit';
import UTD from '@ohos.data.uniformTypeDescriptor'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World /n';
  controller: TextAreaController = new TextAreaController();
  build() {
    Row() {
      Column() {
        TextArea({
          text: this.message,
          placeholder: 'The text area can hold an unlimited amount of text. input your word...',
          controller: this.controller,
        })
          .placeholderColor(Color.Grey)
          .placeholderFont({size: 14, weight: 400})
          .caretColor(Color.Blue)
          .width('100%')
          .height('45%')
          .margin(20)
          .fontSize(14)
          .focusable(true)
          .fontColor(Color.Black)
          .enableKeyboardOnFocus(false)
          .defaultFocus(true)
          .margin({ top: '1%' })
        Flex({ justifyContent: FlexAlign.Center, wrap: FlexWrap.Wrap}) {
          Button('getTypeDescriptor')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.getTypeDescriptor();
            })

          Button('getUniformDataTypeByFilenameExtension')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.FilenameExtension();
            })

          Button('getUniformDataTypeByMIMEType')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.MIME();
            })

          Button('getUniformDataTypesByFilenameExtension')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.TypesByFilename();
            })

          Button('getUniformDataTypesByMIMEType')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.TypesByMIME();
            })

          Button('BelongsTo')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.BelongsTo();
            })
          Button('isLowerLevelType')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.isLowerLevelType();
            })
          Button('isHigherLevelType')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.isHigherLevelType();
            })
          Button('equals')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.equals();
            })

          Button('清屏')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.message = '';
            })
        }
        .width('100%')
      }
      .width('100%')
    }
    .height('100%')
  }

  async getTypeDescriptor() {
    try {
      console.log('SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorJsAPITest_0100 start');
      this.message += `====>getTypeDescriptor success TEXT is: ${UTD.UniformDataType.TEXT} \n`;
      this.controller.caretPosition(this.message.length);
      let typeObj = UTD.getTypeDescriptor(UTD.UniformDataType.TEXT);
      console.log("typeId:" + typeObj.typeId);
      console.log("belongingToTypes:" + typeObj.belongingToTypes);
      console.log("description:" + typeObj.description);
      console.log("referenceURL:" + typeObj.referenceURL);
      console.log("iconFile:" + typeObj.iconFile);
      console.log("filenameExtensions:" + typeObj.filenameExtensions.toString());
      console.log("mimeTypes:" + typeObj.mimeTypes.toString());
      this.message += `====>getTypeDescriptor typeId is: ${typeObj.typeId} \n`;
      this.controller.caretPosition(this.message.length);
      this.message += `====>getTypeDescriptor belongingToTypes is: ${typeObj.belongingToTypes[0]} \n`;
      this.controller.caretPosition(this.message.length);
      this.message += `====>getTypeDescriptor description is: ${typeObj.description} \n`;
      this.controller.caretPosition(this.message.length);
      this.message += `====>getTypeDescriptor referenceURL is: ${typeObj.referenceURL} \n`;
      this.controller.caretPosition(this.message.length);
      this.message += `====>getTypeDescriptor iconFile is: ${typeObj.iconFile} \n`;
      this.controller.caretPosition(this.message.length);
      this.message += `====>getTypeDescriptor filenameExtensions is: ${typeObj.filenameExtensions.toString()} \n`;
      this.controller.caretPosition(this.message.length);
      this.message += `====>getTypeDescriptor mimeTypes is: ${typeObj.mimeTypes.toString()} \n`;
      this.controller.caretPosition(this.message.length);
      console.log("SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorJsAPITest_0100 end");
    } catch(e) {
      let error: BusinessError = e as BusinessError;
      console.error(`getTypeDescriptor throws an exception. code is ${error.code}, message is ${error.message} `);
    }
  }

  async FilenameExtension() {
    console.log('SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorJsAPITest_9785 start');
    try {
      let dynamicType = UTD.getUniformDataTypeByFilenameExtension(".hello");
      console.log("UDMF,result=====>" + dynamicType);
      let dynamicTypeObj = UTD.getTypeDescriptor(dynamicType);
      console.log("UDMF,typeId:" + dynamicTypeObj.typeId);
      console.log("UDMF,belongingToTypes:" + dynamicTypeObj.belongingToTypes);
      console.log("UDMF,filenameExtension:" + dynamicTypeObj.filenameExtensions);
      console.log("UDMF,mimeTypes:" + dynamicTypeObj.mimeTypes);
      this.message += `====>getTypeDescriptor UDMF typeId: is: ${dynamicTypeObj.typeId} \n`;
      this.controller.caretPosition(this.message.length);
      this.message += `====>getTypeDescriptor UDMF belongingToTypes: is: ${dynamicTypeObj.belongingToTypes.length} \n`;
      this.controller.caretPosition(this.message.length);
      this.message += `====>getTypeDescriptor UDMF filenameExtension is: ${dynamicTypeObj.filenameExtensions[0]} \n`;
      this.controller.caretPosition(this.message.length);
      this.message += `====>getTypeDescriptor UDMF mimeTypes: is: ${dynamicTypeObj.mimeTypes.length} \n`;
      this.controller.caretPosition(this.message.length);
    } catch (err) {
      console.log("err message:" + err.message + ";err code:" + err.code);
    }
    console.log("SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorJsAPITest_9785 end");
  }

  async MIME() {
    console.log('SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorJsAPITest_9840 start');
    try {
      let dynamicType = UTD.getUniformDataTypeByMIMEType("hello");
      console.log("dynamicType=====>" + dynamicType);
      let dynamicTypeObj = UTD.getTypeDescriptor(dynamicType);
      console.log("UDMF,typeId:" + dynamicTypeObj.typeId);
      console.log("UDMF,belongingToTypes:" + dynamicTypeObj.belongingToTypes);
      console.log("UDMF,filenameExtension:" + dynamicTypeObj.filenameExtensions);
      console.log("UDMF,mimeTypes:" + dynamicTypeObj.mimeTypes);
      this.message += `====>getTypeDescriptor UDMF typeId: is: ${dynamicTypeObj.typeId} \n`;
      this.controller.caretPosition(this.message.length);
      this.message += `====>getTypeDescriptor UDMF belongingToTypes: is: ${dynamicTypeObj.belongingToTypes.length} \n`;
      this.controller.caretPosition(this.message.length);
      this.message += `====>getTypeDescriptor UDMF filenameExtension: is: ${dynamicTypeObj.mimeTypes[0]} \n`;
      this.controller.caretPosition(this.message.length);
      this.message += `====>getTypeDescriptor UDMF mimeTypes: is: ${dynamicTypeObj.filenameExtensions.length} \n`;
      this.controller.caretPosition(this.message.length);
    } catch (err) {
      console.log("err message:" + err.message + ";err code:" + err.code);
    }
    console.log("SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorJsAPITest_9840 end");
  }


  async TypesByFilename() {
    console.log('SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorJsAPITest_1160 start');
    try {
      let dynamicType = UTD.getUniformDataTypesByFilenameExtension(".hello");
      console.log("UDMF,result=====>" + dynamicType);
      let dynamicTypeObj = UTD.getTypeDescriptor(dynamicType[0]);
      console.log("UDMF,typeId:" + dynamicTypeObj.typeId);
      console.log("UDMF,belongingToTypes:" + dynamicTypeObj.belongingToTypes);
      console.log("UDMF,filenameExtension:" + dynamicTypeObj.filenameExtensions);
      console.log("UDMF,mimeTypes:" + dynamicTypeObj.mimeTypes);
      this.message += `====>getTypeDescriptor UDMF typeId: is: ${dynamicTypeObj.typeId} \n`;
      this.controller.caretPosition(this.message.length);
      this.message += `====>getTypeDescriptor UDMF belongingToTypes: is: ${dynamicTypeObj.belongingToTypes.length} \n`;
      this.controller.caretPosition(this.message.length);
      this.message += `====>getTypeDescriptor UDMF filenameExtension: is: ${dynamicTypeObj.filenameExtensions[0]} \n`;
      this.controller.caretPosition(this.message.length);
      this.message += `====>getTypeDescriptor UDMF mimeTypes: is: ${dynamicTypeObj.mimeTypes.length} \n`;
      this.controller.caretPosition(this.message.length);
    } catch (err) {
      console.log("err message:" + err.message + ";err code:" + err.code);
    }
    console.log("SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorJsAPITest_1160 end");
  }


  async TypesByMIME() {
    console.log('SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorAPITest_1800 start');
    try {
      let result = UTD.getUniformDataTypesByMIMEType("audio/x-ms-wma", "com.microsoft.windows-media-wma");
      console.log("result=====>" + result);
      this.message += `====>getTypeDescriptor UDMF mimeTypes: is: ${result[0]} \n`;
      this.controller.caretPosition(this.message.length);
    } catch (err) {
      console.log("err message:" + err.message + ";err code:" + err.code);
    }
    console.log("SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorAPITest_1800 end");
  }

  async BelongsTo() {
    console.log('SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorJsAPITest_9610 start');
    let typeObj1 = UTD.getTypeDescriptor("general.navigation");
    try {
      let result = typeObj1.belongsTo("general.object");
      console.log("result==>" + result);
      this.message += `====>getTypeDescriptor BelongsTo result: is: ${result} \n`;
      this.controller.caretPosition(this.message.length);
    } catch (err) {
      console.log("err message:" + err.message + ";err code:" + err.code);
    }
    console.log("SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorJsAPITest_9610 end");
  }

  async isLowerLevelType() {
    console.log('SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorJsAPITest_9610 start');
    let typeObj1 = UTD.getTypeDescriptor("general.navigation");
    try {
      let result = typeObj1.isLowerLevelType("general.object");
      console.log("result==>" + result);
      this.message += `====>getTypeDescriptor isLowerLevelType result: is: ${result} \n`;
      this.controller.caretPosition(this.message.length);
    } catch (err) {
      console.log("err message:" + err.message + ";err code:" + err.code);
    }
    console.log("SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorJsAPITest_9610 end");
  }

  async isHigherLevelType() {
    console.log('SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorJsAPITest_9610 start');
    let typeObj1 = UTD.getTypeDescriptor("general.object");
    try {
      let result = typeObj1.isHigherLevelType("general.navigation");
      console.log("result==>" + result);
      this.message += `====>getTypeDescriptor isHigherLevelType result: is: ${result} \n`;
      this.controller.caretPosition(this.message.length);
    } catch (err) {
      console.log("err message:" + err.message + ";err code:" + err.code);
    }
    console.log("SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorJsAPITest_9610 end");
  }

  async equals() {
    console.log('SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorAPITest_2800 start');
    try {
      let typeObj1 = UTD.getTypeDescriptor('general.message');
      let typeObj2 = UTD.getTypeDescriptor('general.message');
      let result = typeObj1.equals(typeObj2);
      this.message += `====>getTypeDescriptor isHigherLevelType result: is: ${result} \n`;
      this.controller.caretPosition(this.message.length);
    } catch (err) {
      console.log("err message:" + err.message + ";err code:" + err.code);
    }
    console.log("SUB_DistributedData_UDMF_SDK_UniformTypeDescriptorAPITest_2800 end");
  }






}
