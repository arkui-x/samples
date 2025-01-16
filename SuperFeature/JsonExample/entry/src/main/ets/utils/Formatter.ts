import { isBasicType } from './Index'

/**
 * 返回指定个数的制表符字符串
 * @param count
 * @returns
 */
function setTabs(count: number): string {
  let str = ''
  for (let i = 0; i < count; i++) {
    str += `\t`
  }
  return str
}

/**
 * 构造数组类型的文本内容
 * @param arr 被格式化的对象数组
 * @param tabCount 制表符个数
 * @returns
 */
function convertArray(arr: Array<object>, tabCount: number = 0): string {
  let formatterJSONArr = ''
  const arrLen = arr.length
  if (arrLen === 0) return formatterJSONArr += '[]'
  const someSimple = arr.some(item => isBasicType(item)) // 判断数组内数据是否存在基础数据类型
  if (someSimple) {
    // 如果数组长度大于5，则使用,\n分割，否则只使用,分割
    if (arrLen >= 5) {
      formatterJSONArr += `[\n`
      tabCount++
      formatterJSONArr += `${setTabs(tabCount)}`
      arr.forEach((item, index) => {
        const lastIndex = index === arrLen - 1
        if (null === item || isBasicType(item)) { // 判断是否为基础数据类型
          if (typeof item === 'string') {
            formatterJSONArr += `"${item}"${lastIndex ? '\n' : ',\n'}`
          } else {
            formatterJSONArr += `${item}${lastIndex ? '\n' : ',\n'}`
          }
        } else {
          if (item.constructor === Array) { // 判断是否为数组类型
            formatterJSONArr += convertArray(item, tabCount + 1) // 调用构造数组类型文本内容的方法
          } else {
            formatterJSONArr += convertObject(item, tabCount + 1,!lastIndex) // 调用构造对象类型文本内容的方法
          }
          formatterJSONArr += `\n`
        }
        // 不是最后一个元素则在前面加上制表符的空格
        if (!lastIndex) {
          formatterJSONArr += `${setTabs(tabCount)}`
        }
      })
      tabCount--
      formatterJSONArr += `${setTabs(tabCount)}`
      formatterJSONArr += `]`
    } else {
      formatterJSONArr += `[`
      arr.forEach((item, index) => {
        const lastIndex = index === arrLen - 1
        if (null === item || isBasicType(item)) {
          if (typeof item === 'string') {
            formatterJSONArr += `"${item}"${lastIndex ? '' : ','}`
          } else {
            formatterJSONArr += `${item}${lastIndex ? '' : ','}`
          }
        } else {
          if (item.constructor === Array) {
            formatterJSONArr += convertArray(item, tabCount + 1) // 调用构造数组类型文本内容的方法
          } else {
            formatterJSONArr += convertObject(item, tabCount + 1,!lastIndex) // 调用构造对象类型文本内容的方法
          }
          formatterJSONArr += `${setTabs(tabCount)}`
        }
      })
      formatterJSONArr += `]`
    }
  } else {
    formatterJSONArr = '[\n'
    tabCount++;
    arr.forEach((item, index) => {
      const lastIndex = index === arrLen - 1
      formatterJSONArr += `${setTabs(tabCount)}`
      formatterJSONArr += convertObject(item, tabCount,!lastIndex)
    })
    tabCount--
    formatterJSONArr += `${setTabs(tabCount)}]`
  }
  return formatterJSONArr
}

/**
 * 构造对象类型的文本内容
 * @param obj 被格式化的对象
 * @param tabCount 制表符个数
 * @param addComma 末尾是否需要增加逗号
 * @returns
 */
function convertObject(obj: object, tabCount: number = 0, addComma: boolean = false): string {
  const keys: Array<string> = Object.keys(obj) // 获取object的key
  const keysLen: number = keys.length
  let formatterJSON: string = keys.length > 0 ? '{\n' : '{'
  tabCount++;
  keys.forEach((key: string, index) => {
    const type = isBasicType(obj[key]) // 根据key获取value，判断value的类型
    const isStr = typeof obj[key] === 'string'
    const lastKey = index === keysLen - 1 // 是否为最后一个key
    if (null === obj[key] || type) { // 如果是简单类型的数据，直接拼接
      formatterJSON += `${setTabs(tabCount)}"${key}": ${isStr ? '"' + obj[key] + '"' : obj[key]}${lastKey ? '' : ','}\n`
    } else {
      // 判断非简单类型的数据是object还是array
      if (obj[key].constructor === Array) { // 如果是array，调用转化array的方法
        formatterJSON += `${setTabs(tabCount)}"${key}": ` + convertArray(obj[key], tabCount) + `${lastKey ? '' : ','}\n`
      } else {
        formatterJSON += `${setTabs(tabCount)}"${key}":` // 否则调用转化object的方法
        formatterJSON += convertObject(obj[key], tabCount,!lastKey)
      }
    }
  })
  tabCount--
  if (tabCount === 0) {
    formatterJSON += `${setTabs(tabCount)}}${addComma ? ',' : ''}`
  } else {
    formatterJSON += `${setTabs(tabCount)}}${addComma ? ',' : ''}\n`
  }
  return formatterJSON
}

export {
  convertArray, convertObject, setTabs
}