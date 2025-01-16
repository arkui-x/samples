// import { Gson } from '@ohos/gson-ts'
import { Gson } from '../gson'
import { BusinessError } from '@ohos.base'

/**
 * 将字符串转换为对象
 * @param str
 * @returns
 */
function fromJsonObject(str: string): Object {
  try {
    return new Gson().fromJson(str)
  } catch (error) {
    console.error('GSON: JSON格式错误：' + (error as BusinessError).message)
    throw new Error('GSON: JSON格式错误：' + (error as BusinessError).message)
  }
}
/**
 * 将字符串转换为数组
 * @param str
 * @returns
 */
function fromJsonArray(str: string): Array<Object> {
  try {
    const resultArr: Array<Object> = new Array<Object>()
    const result: Object = new Gson().fromJson(str)
    resultArr.push(result)
    return resultArr
  } catch (error) {
    console.error('GSON: JSON格式错误：' + (error as BusinessError).message)
    throw new Error('GSON: JSON格式错误：' + (error as BusinessError).message)
  }
}

/**
 * 将对象转换为字符串
 * @param obj
 * @returns
 */
function toJson(obj: object): string {
  let jsonStr = '{}'
  try {
    jsonStr = new Gson().toJson(obj)
  } catch (error) {
    console.error('GSON: JSON格式错误：' + (error as BusinessError).message)
    throw new Error('GSON: JSON格式错误：' + (error as BusinessError).message)
  } finally {
    return jsonStr
  }
}

/**
 * 将字符串转换为对象
 * @param data
 * @returns
 */
function convertObjData(data: string): Object {
  try {
    return JSON.parse(data)
  } catch (error) {
    console.error('JS: JSON格式错误：' + (error as BusinessError).message)
    throw new Error('JS: JSON格式错误：' + (error as BusinessError).message)
  }
}

/**
 * 将字符串转换为数组
 * @param data
 * @returns
 */
function convertArrayData(data: string): Array<Object> {
  try {
    return JSON.parse(data)
  } catch (error) {
    console.error('JS: JSON格式错误：' + (error as BusinessError).message)
    throw new Error('JS: JSON格式错误：' + (error as BusinessError).message)
  }
}

export {
  convertObjData, convertArrayData, fromJsonObject, fromJsonArray, toJson
}