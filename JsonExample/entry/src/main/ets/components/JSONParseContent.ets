import { convertArrayData, convertObjData, fromJsonArray, fromJsonObject } from '../utils/ConvertJSON'
import { setTabs, convertObject, convertArray } from '../utils/Formatter'
import { getObjectKeys, isArray, isBasicArray, isBasicType } from '../utils/Index'

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
      // 若显示内容被""包裹，则去掉""
      if (this.innerContent.indexOf(`"`) === 0 ) {
        const removeDouble: RegExp = new RegExp('["|"](.*)["|"]')
        this.innerContent = this.innerContent.replace(removeDouble, "$1")
      }
      // 若显示内容被''包裹，则去掉''
      if (this.innerContent.indexOf(`'`) === 0) {
        const removeSingle: RegExp = new RegExp(`['|'](.*)['|']`)
        this.innerContent = this.innerContent.replace(removeSingle, "$1")
      }
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
    } catch (error) {
      this.message = `标准JSON格式如下：\n{"key": "value", "str": 123, "a": true, "b": []}\n\nJSON数据格式错误：\n\t${this.innerContent}`
      this.code = 500
    }
  }

  /**
   * 设置复杂数据集的文本内容
   * @param array
   * @returns
   */
  setComplexText(array: Array<Object> = []): string {
    let formatterJSONArr = '['
    const arrLen = array.length
    array.forEach((item: Object, index: number) => {
      const lastIndex = index === arrLen - 1
      const isComma = lastIndex ? '' : ','
      if (isBasicType(item)) { // 判断是否为基础数据类型
        if (typeof item === 'string') { // 判断是否为字符串类型，是字符串则加上""
          formatterJSONArr += `"${item}"${isComma}`
        } else {
          formatterJSONArr += `${item}${isComma}`
        }
      } else {
        if (item.constructor === Array) { // 判断是否为数组类型
          formatterJSONArr += convertArray(item, 1) // 调用构造数组类型文本内容的方法
        } else {
          formatterJSONArr += convertObject(item, 1,!lastIndex) // 调用构造对象类型文本内容的方法
        }
      }
    })
    formatterJSONArr += ']'
    return formatterJSONArr
  }

  /**
   * 构造数组类型的文本内容
   * @param $$ 双向同步变量
   * @param isTitle 是否需要标题
   * @param tabCount 制表符数量
   */
  @Builder
  buildArray(array: Array<Object>, isTitle: boolean = false, tabCount: number = 0) {
    Column() {
      if (array.length === 0) {
        Text('[]')
      } else {
        if (array.some((value: string | number | boolean | object) => isBasicType(value))) {
          Text(this.setComplexText(array))
        } else {
          ForEach(array, (item: Object, index: number) => {
            if (isTitle && undefined !== index) {
              Text('Object' + `${index + 1}:\n`)
                .fontSize(16)
                .fontColor('#FFFFFF')
                .fontWeight(FontWeight.Bold)
                .backgroundColor('#007DFF')
            } else {
              Text() {
                Span(`\t`)
              }
              .fontSize(12)
              .fontWeight(FontWeight.Bold)
              .backgroundColor('#FFFFFF')
            }
            if (isBasicType(item)) {
              Text(`${item},\n`)
            } else {
              this.buildObject(item, tabCount + 1)
            }
            Text(`\n`)
          })
        }
      }
    }
    .alignItems(HorizontalAlign.Start)
  }

  /**
   * 构造对象类型的文本内容
   * @param $$ 双向同步变量
   * @param tabCount 制表符数量
   */
  @Builder
  buildObject(obj: object, tabCount: number = 0) {
    Flex({ wrap: FlexWrap.Wrap, alignContent: FlexAlign.Start }) {
      ForEach(getObjectKeys(obj), (key: string, index) => {
        Flex({ wrap: FlexWrap.Wrap, alignContent: FlexAlign.Start }) {
          if (isBasicType(obj[key])) { // 判断是否为基础数据类型
            Text(`${setTabs(tabCount)}${key}:\t`)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
            if (typeof obj[key] === 'string') {
              Text(`"${obj[key]}"`)
            } else {
              Text(`${obj[key]}`)
            }
          } else {
            if (isArray(obj[key])) { // 判断是否为数组类型
              if (isBasicArray(obj[key])) {
                Text(`${setTabs(tabCount)}${key}:\t`)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                this.buildArray(obj[key])
              } else {
                Text(`${setTabs(tabCount)}${key}:\n`)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                this.buildArray(obj[key], false, tabCount + 1)
              }
            } else {
              if (null === obj[key]) {
                Text(`${setTabs(tabCount)}${key}:\t`)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                Text(`${obj[key]}`)
              } else {
                Text(`${setTabs(tabCount)}${key}:\n`)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                this.buildObject(obj[key], tabCount + 1)
              }
            }
          }
        }

        if (index !== getObjectKeys(obj).length - 1) Text(`\n`)
      })
    }
  }

  build() {
    Column() {
      if (this.code === 200) {
        if (this.contentArray.length > 0) {
          this.buildArray(this.contentArray, true)
        }
        if (getObjectKeys(this.content).length > 0) {
          this.buildObject(this.content)
        }
      } else {
        Text(this.message)
          .fontColor(Color.Red)
          .fontSize(16)
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}