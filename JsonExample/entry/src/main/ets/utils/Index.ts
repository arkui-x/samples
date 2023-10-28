/**
 * 获取对象所有key
 * @param obj
 * @returns
 */
export function getObjectKeys(obj: object): Array<string> {
  return Object.keys(obj)
}

/**
 * 判断类型是否为数组
 * @param param
 * @returns
 */
export function isArray(param: any): Boolean {
  return Array.isArray(param)
}

/**
 * 判断一个数组是否全为基础类型数据
 * @param array
 * @returns
 */
export function isBasicArray(array: Array<any>): Boolean {
  return array.every(value => isBasicType(value))
}

/**
 * 判断数据类型是否为基础类型
 * @param param
 * @returns
 */
export function isBasicType(param: any): Boolean {
  const basicType = [
    '[object Number]',
    '[object String]',
    '[object Boolean]',
    '[object Null]',
    '[object Undefined]'
  ]
  const param_type = Object.prototype.toString.call(param)
  return basicType.includes(param_type)
}