/**
 * 简单对象类
 */
@Observed
export default class SimpleObject {
  typeString: string|null; // 字符串类型
  typeInt: number|null; // 整数类型
  typeDouble: number|null; // 浮点数类型
  typeStrList: Array<string>|null; // 字符串集
  typeIntList: Array<number>|null; // 整数集
  typeDoubleList: Array<number>|null; // 浮点数集

  constructor(
    typeString: string|null,
    typeInt: number|null,
    typeDouble: number|null,
    typeStrList: Array<string>|null,
    typeIntList: Array<number>|null,
    typeDoubleList: Array<number>|null
  ) {
    this.typeString = typeString
    this.typeInt = typeInt
    this.typeDouble = typeDouble
    this.typeStrList = typeStrList
    this.typeIntList = typeIntList
    this.typeDoubleList = typeDoubleList
    this.typeDouble = typeDouble
    this.typeDoubleList = typeDoubleList
  }
}