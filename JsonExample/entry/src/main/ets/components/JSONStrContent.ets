import { convertArrayData, convertObjData, fromJsonArray, fromJsonObject } from '../utils/ConvertJSON'
import { convertObject, convertArray } from '../utils/Formatter'
import { getObjectKeys, isArray, isBasicType } from '../utils/Index'

@Component
export default struct MyTabContent {
  @State content: object = new Object(); // 反序列化后展示的对象
  @State contentArray: Array<object> = []; // 反序列化后展示的对象数组
  @State code: number = 200; // 反序列化结果，默认200. 200：反序列化成功。 500：反序列化失败
  @State message: string = ''; // 反序列化失败后的提示信息
  @Prop innerContent: string = ''; // 父组件传入需要展示的内容
  @Consume deserialize: string;

  aboutToAppear() {
    try {
      const isGson = this.deserialize === 'gson'
      const removeEmpty: RegExp = new RegExp('\\s+', 'g')
      const removeN: RegExp = new RegExp('[\r\n]', 'g')
      this.innerContent = this.innerContent.replace(removeEmpty, "") // 去掉空格
      this.innerContent = this.innerContent.replace(removeN, "") // 去掉\n
      const regex1: RegExp = new RegExp('^["|"](.*)["|"]$')
      const regex2: RegExp = new RegExp(`^['|'](.*)['|']$`)
      this.innerContent = this.innerContent.replace(regex1, "$1") // 若显示内容被""包裹，则去掉""
      this.innerContent = this.innerContent.replace(regex2, "$1") // 若显示内容被''包裹，则去掉''
      const object_content = this.innerContent.indexOf('{') === 0
      let objArray: Array<Object> = new Array<Object>()
      // 根据首页选择的反序列化工具调用不同API
      if (object_content) {
        const obj: Object = isGson ? fromJsonObject(this.innerContent) : convertObjData(this.innerContent)
        objArray.push(obj)
      } else {
        objArray = isGson ? fromJsonArray(this.innerContent) : convertArrayData(this.innerContent)
      }
      // 如果反序列化后结果为null或者结果为基本数据类型，则直接显示
      if (isBasicType(objArray[0])) {
        this.message = JSON.stringify(this.innerContent)
        this.code = 500
      } else {
        // 将数组和对象分别赋值
        if (!object_content) {
          this.contentArray = isGson ? objArray.flat() : objArray
        } else {
          this.content = objArray[0]
        }
      }
    } catch (e) {
      this.message = JSON.stringify(this.innerContent)
      this.code = 500
    }
  }

  build() {
    Column() {
      if (this.code === 200) {
        if (this.contentArray.length > 0) {
          Text(`'${convertArray(this.contentArray)}'`)
        }
        if (getObjectKeys(this.content).length > 0) {
          Text(`'${convertObject(this.content)}'`)
        }
      } else {
        Text(this.message)
          .fontSize(16)
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}