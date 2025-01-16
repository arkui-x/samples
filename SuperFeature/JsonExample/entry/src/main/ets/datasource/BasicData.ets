const intList: Array<number> = [1, 2, 3, 4, 5, 6, 7] // 整数集

const doubleList: Array<number> = [1.25, 2.15, 3.22] // 浮点数集

const strList: Array<string> = ['a', 'b', 'c', 'd', 'e'] // 字符串集

const simpleList: Array<number | string> = new Array() // 简单复合数据类型集
simpleList.push(1)
simpleList.push('abc')
simpleList.push(2.1)

const simpleObj: Map<string, string | number> = new Map()
simpleObj.set("str", "abc,def")
simpleObj.set("num", 1)
simpleObj.set("doubleNum", 3.2)

const SIMPLE_OBJ = `{"str": "${simpleObj.get('str')}","num": ${simpleObj.get('num')}, "doubleNum": ${simpleObj.get('doubleNum')}}`

const BASIC_DATA: Map<string, string | number | boolean> = new Map()

BASIC_DATA.set("int", 1)
BASIC_DATA.set("double", 2.1)
BASIC_DATA.set("str", "abc")
BASIC_DATA.set("intList", JSON.stringify(intList))
BASIC_DATA.set("doubleList", JSON.stringify(doubleList))
BASIC_DATA.set("strList", JSON.stringify(strList))
BASIC_DATA.set("simpleList", JSON.stringify(simpleList))
BASIC_DATA.set("simpleObj", SIMPLE_OBJ)

let BASIC_DATA_STR: string = `{`

BASIC_DATA.forEach((value: string|number|boolean, key: string) => {
  if ("simpleObj" !== key) {
    BASIC_DATA_STR += "str" === key ? `"${key}": "${BASIC_DATA.get(key)}",` : `"${key}": ${BASIC_DATA.get(key)},`
  } else {
    BASIC_DATA_STR += `"${key}": ${BASIC_DATA.get(key)}}`
  }
})

export default BASIC_DATA_STR
