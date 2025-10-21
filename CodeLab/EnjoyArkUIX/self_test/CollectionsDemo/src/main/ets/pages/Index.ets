import { collections } from '@kit.ArkTS';

interface ButtonConfig {
  name: string,
  action: () => void
}

@Entry
@Component
struct Index {
  @State inputValue: string = '1,2,3,4,5'
  @State results: string[] = []
  @State arrayShow: string[] = []
  @State inputArray: string[] = []

  // 定义按钮配置数组
  private buttonConfigs: ButtonConfig [] = [
    { name: 'Array.of', action: () => this.testArrayOf() },
    { name: 'Array.isArray', action: () => this.testIsArray() },
    { name: 'Array.From1', action: () => this.testArrayFrom1() },
    { name: 'Array.From2', action: () => this.testArrayFrom2() },
    { name: 'Array.reverse', action: () => this.testArrayReverse() },
    { name: 'Array.copyWithin', action: () => this.testArrayCopyWithin() },
    { name: 'Array.lastIndexOf', action: () => this.testArrayLastIndexOf() },
    { name: 'Array.every', action: () => this.testArrayEvery() },
    { name: 'Array.some', action: () => this.testArraySome() },
    { name: 'Array.toString', action: () => this.testArrayToString() },
    { name: 'Array.toLocaleString', action: () => this.testArrayToLocaleString() },
    { name: 'Array.reduceRight', action: () => this.testArrayReduceRight() },
    { name: 'Array.reduceRight2', action: () => this.testArrayReduceRight2() },
    { name: 'Int8Array.of', action: () => this.testInt8ArrayOf() },
    { name: 'Int8Array.lastIndexOf', action: () => this.testInt8ArrayLastIndexOf() },
    { name: 'Int8Array.toString', action: () => this.testInt8ArrayToString() },
    { name: 'Int8Array.toLocaleString', action: () => this.testInt8ArrayToLocaleString() },
    { name: 'Int8Array.reduceRight', action: () => this.testInt8ArrayReduceRight() },
    { name: 'Int8Array.reduceRight2', action: () => this.testInt8ArrayReduceRight2() },
    { name: 'Uint8ClampedArray.of', action: () => this.testUint8ClampedArrayOf() },
    { name: 'Uint8ClampedArray.lastIndexOf', action: () => this.testUint8ClampedArrayLastIndexOf() },
    { name: 'Uint8ClampedArray.toString', action: () => this.testUint8ClampedArrayToString() },
    { name: 'Uint8ClampedArray.toLocaleString', action: () => this.testUint8ClampedArrayToLocaleString() },
    { name: 'Uint8ClampedArray.reduceRight', action: () => this.testUint8ClampedArrayReduceRight() },
    { name: 'Uint8ClampedArray.reduceRight2', action: () => this.testUint8ClampedArrayReduceRight2() },
    { name: 'Uint8Array.of', action: () => this.testUint8ArrayOf() },
    { name: 'Uint8Array.lastIndexOf', action: () => this.testUint8ArrayLastIndexOf() },
    { name: 'Uint8Array.toString', action: () => this.testUint8ArrayToString() },
    { name: 'Uint8Array.toLocaleString', action: () => this.testUint8ArrayToLocaleString() },
    { name: 'Uint8Array.reduceRight', action: () => this.testUint8ArrayReduceRight() },
    { name: 'Uint8Array.reduceRight2', action: () => this.testUint8ArrayReduceRight2() },
    { name: 'Int16Array.of', action: () => this.testInt16ArrayOf() },
    { name: 'Int16Array.lastIndexOf', action: () => this.testInt16ArrayLastIndexOf() },
    { name: 'Int16Array.toString', action: () => this.testInt16ArrayToString() },
    { name: 'Int16Array.toLocaleString', action: () => this.testInt16ArrayToLocaleString() },
    { name: 'Int16Array.reduceRight', action: () => this.testInt16ArrayReduceRight() },
    { name: 'Int16Array.reduceRight2', action: () => this.testInt16ArrayReduceRight2() },
    { name: 'Uint16Array.of', action: () => this.testUint16ArrayOf() },
    { name: 'Uint16Array.lastIndexOf', action: () => this.testUint16ArrayLastIndexOf() },
    { name: 'Uint16Array.toString', action: () => this.testUint16ArrayToString() },
    { name: 'Uint16Array.toLocaleString', action: () => this.testUint16ArrayToLocaleString() },
    { name: 'Uint16Array.reduceRight', action: () => this.testUint16ArrayReduceRight() },
    { name: 'Uint16Array.reduceRight2', action: () => this.testUint16ArrayReduceRight2() },
    { name: 'Int32Array.of', action: () => this.testInt32ArrayOf() },
    { name: 'Int32Array.lastIndexOf', action: () => this.testInt32ArrayLastIndexOf() },
    { name: 'Int32Array.toString', action: () => this.testInt32ArrayToString() },
    { name: 'Int32Array.toLocaleString', action: () => this.testInt32ArrayToLocaleString() },
    { name: 'Int32Array.reduceRight', action: () => this.testInt32ArrayReduceRight() },
    { name: 'Int32Array.reduceRight2', action: () => this.testInt32ArrayReduceRight2() },
    { name: 'Uint32Array.of', action: () => this.testUint32ArrayOf() },
    { name: 'Uint32Array.lastIndexOf', action: () => this.testUint32ArrayLastIndexOf() },
    { name: 'Uint32Array.toString', action: () => this.testUint32ArrayToString() },
    { name: 'Uint32Array.toLocaleString', action: () => this.testUint32ArrayToLocaleString() },
    { name: 'Uint32Array.reduceRight', action: () => this.testUint32ArrayReduceRight() },
    { name: 'Uint32Array.reduceRight2', action: () => this.testUint32ArrayReduceRight2() },
    { name: 'Float32Array.of', action: () => this.testFloat32ArrayOf() },
    { name: 'Float32Array.lastIndexOf', action: () => this.testFloat32ArrayLastIndexOf() },
    { name: 'Float32Array.toString', action: () => this.testFloat32ArrayToString() },
    { name: 'Float32Array.toLocaleString', action: () => this.testFloat32ArrayToLocaleString() },
    { name: 'Float32Array.reduceRight', action: () => this.testFloat32ArrayReduceRight() },
    { name: 'Float32Array.reduceRight2', action: () => this.testFloat32ArrayReduceRight2() },
    { name: 'BitVector.push', action: () => this.testBitVectorPush() },
    { name: 'BitVector.pop', action: () => this.testBitVectorPop() },
    { name: 'BitVector.has', action: () => this.testBitVectorHas() },
    { name: 'BitVector.setBitsByRange', action: () => this.testBitVectorSetBitsByRange() },
    { name: 'BitVector.setAllBits', action: () => this.testBitVectorSetAllBits() },
    { name: 'BitVector.getBitsByRange', action: () => this.testBitVectorGetBitsByRange() },
    { name: 'BitVector.resize', action: () => this.testBitVectorResize() },
    { name: 'BitVector.getBitCountByRange', action: () => this.testBitVectorGetBitCountByRange() },
    { name: 'BitVector.getIndexOf', action: () => this.testBitVectorGetIndexOf() },
    { name: 'BitVector.getLastIndexOf', action: () => this.testBitVectorGetLastIndexOf() },
    { name: 'BitVector.flipBitByIndex', action: () => this.testBitVectorFlipBitByIndex() },
    { name: 'BitVector.flipBitsByRange', action: () => this.testBitVectorFlipBitsByRange() },
    { name: 'BitVector.values', action: () => this.testBitVectorValues() }
  ];

  build() {
    Row() {
      Column() {
        // 固定部分：标题、输入框和结果显示区域
        Column() {
          Text('ArkTS Array接口验证')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20, bottom: 10 })

          Text('请输入一组值（用逗号分隔）:')
            .fontSize(16)
            .width('90%')
            .textAlign(TextAlign.Start)

          TextInput({ placeholder: '例如: 1,2,3,4,5' })
            .width('90%')
            .height(40)
            .border({ width: 1, color: Color.Gray })
            .onChange((value: string) => {
              this.inputValue = value
            })

          Button('开始测试(每重新输入一次值都需要先点击)')
          .width('90%')
            .height(40)
            .margin({ top: 10})
            .backgroundColor('#FDFD0F')
            .fontColor(Color.Black)
            .onClick(() => {
              this.startTest()
            })

          // 结果显示区域，固定高度可滚动，最新的日志显示在最上面
          Column() {
            Text('当前数组:' + this.inputArray)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .width('90%')
              .textAlign(TextAlign.Start)
              .margin({ top: 15, bottom: 5 })

            Text('测试结果:')
              .fontSize(16)
              .width('90%')
              .textAlign(TextAlign.Start)
              .margin({ top: 15, bottom: 5 })

            // 滚动显示所有结果，但容器高度限制为显示5条
            Scroll() {
              Column() {
                // 使用反向循环，最新的日志显示在最上面
                ForEach(this.getReversedResults(), (item: string, index: number) => {
                  Text(`${this.results.length - index}. ${item}`)
                    .fontSize(14)
                    .width('90%')
                    .textAlign(TextAlign.Start)
                    .margin({ top: 3, bottom: 3 })
                }, (item: string) => item)
              }
              .width('100%')
            }
            .width('100%')
            .height(150) // 固定高度，大约显示5条日志

            // 添加清空结果按钮
            Button('清空测试结果')
              .width('95%')
              .height(40)
              .backgroundColor('#808080')
              .fontColor(Color.White)
              .onClick(() => {
                this.clearResults()
              })
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#F8F8F8')
          .borderRadius(5)
          .margin({ top: 10, bottom: 10 })
        }
        .width('100%')
        .padding(15)
        .backgroundColor(Color.White)
        .borderRadius(10)
        // .margin({ bottom: 10 })

        // 可滚动部分：按钮区域
        Scroll() {
          Column({ space: 15 }) {
            // 使用 ButtonConfig 接口类型
            ForEach(this.buttonConfigs, (config: ButtonConfig, index: number) => {
              Button(config.name)
                .width('95%')
                .height(40)
                .backgroundColor('#007FFF')
                .fontColor(Color.White)
                .onClick(() => {
                  config.action()
                })
            }, (config: ButtonConfig) => config.name)
          }
          .width('80%')
          .padding(10)
        }
        .width('100%')
        .layoutWeight(1) // 占据剩余空间
      }
      .width('100%')
      .height('100%')
      .padding(10)
    }
    .height('100%')
    // .backgroundColor('#F0F0F0')
  }

  // 获取反向的结果数组（最新的在最前面）
  getReversedResults(): string[] {
    return [...this.results].reverse();
  }

  // 清空结果
  clearResults(): void {
    this.results = [];
  }

  // 添加结果的方法
  addResult(result: string): void {
    this.results.push(result);
    // 如果结果太多，可以删除最旧的一些
    if (this.results.length > 30) {
      this.results = this.results.slice(-30);
    }
  }

  startTest() {
    this.inputArray = this.inputValue.split(',').map(item => item.trim());
  }

  testArrayOf():void {
    // 1. 使用Array.of将输入值转换为数组
    const arrayOf: collections.Array<string> = collections.Array.of(...this.inputArray)
    this.results.push(`Array.of() 结果: [${arrayOf.join(', ')}]`)
  }

  testIsArray():void {
    // 2. 使用Array.isArray判断结果是否为数组
    const collectionArr: collections.Array<string> = collections.Array.of(...this.inputArray)
    const isArrayResult = collections.Array.isArray(collectionArr)
    this.results.push(`Array.isArray() 结果: ${isArrayResult}`)
  }

  testArrayFrom1():void {
    // 3. 使用Array.from (同类型)
    const arrayFrom1 = collections.Array.from(this.inputArray, (value) => value + 1)
    this.results.push(`Array.from(同类型转换+1,string[]->string[]) 结果: [${arrayFrom1.join(', ')}]`)
  }

  testArrayFrom2():void {
    // 4. 使用Array.from (不同类型)
    const collectionArr: collections.Array<string> = collections.Array.of(...this.inputArray)
    const arrayFrom2 = collections.Array.from(collectionArr, (value) => Number(value))
    this.results.push(`Array.from(string[]->number[]) 结果: [${arrayFrom2.join(', ')}]`)
  }

  testArrayCopyWithin():void {
    // 5. 使用copyWithin方法
    const collectionArr: collections.Array<string> = collections.Array.of(...this.inputArray)
    const copyWithinArr = collectionArr.copyWithin(0, 3, 4)
    this.results.push(`copyWithin(0, 3, 4) 结果: [${copyWithinArr.join(', ')}]`)
  }

  testArrayReverse():void {
    // 6. 使用reverse方法
    const collectionArr: collections.Array<string> = collections.Array.of(...this.inputArray)
    const reverseArr = collectionArr.reverse()
    this.results.push(`reverse() 结果: [${reverseArr.join(', ')}]`)
  }

  testArrayLastIndexOf():void {
    // 7. 使用lastIndexOf方法
    const collectionArr: collections.Array<string> = collections.Array.of(...this.inputArray)
    const lastIndex = collectionArr.lastIndexOf('2')
    this.results.push(`lastIndexOf('2') 结果: ${lastIndex}`)
  }

  testArrayEvery():void {
    // 8. 使用every方法
    const collectionArr: collections.Array<string> = collections.Array.of(...this.inputArray)
    const numArray = collections.Array.from(collectionArr, (str: string) => {
      const num = Number(str);
      return isNaN(num) ? str : num;
    })
    const everyRes = numArray.every(item => typeof(item) === 'number')
    this.results.push(`every(typeof(item) === 'number') 结果: ${everyRes}`)
  }

  testArraySome():void {
    // 9. 使用some方法
    const collectionArr: collections.Array<string> = collections.Array.of(...this.inputArray)
    const hasEven = collectionArr.some(item => Number(item) % 2 === 0)
    this.results.push(`some(item => Number(item) % 2 === 0) 结果: ${hasEven}`)
  }

  testArrayToString():void {
    // 10. 使用toString方法
    const numArray = collections.Array.from(this.inputArray, (str: string) => {
      const num = Number(str);
      return isNaN(num) ? str : num;
    })
    const stringResult = numArray.toString()
    this.results.push(`toString() 结果: "${stringResult}"`)
  }

  testArrayToLocaleString():void {
    // 11. 使用toLocaleString方法
    const numArray2 = collections.Array.from(this.inputArray, (str: string) => {
      const num = Number(str);
      return isNaN(num) ? str : num;
    })
    let stringArray = numArray2.toLocaleString()
    this.results.push(`toLocaleString() 结果: "${stringArray}"`)
  }

  testArrayReduceRight():void {
    // 12. 使用reduceRight方法 (第一个重载)
    const numArray = collections.Array.from(this.inputArray, str => Number(str))
    const reducedRight = numArray.reduceRight((accumulator, value) => accumulator + value)
    this.results.push(`reduceRight((accumulator, value) => accumulator + value) 结果: ${reducedRight}\n (注意：非数字会被转为NaN)`)
  }

  testArrayReduceRight2():void {
    // 13. 使用reduceRight方法 (第二个重载，带初始值)
    const numArray = collections.Array.from(this.inputArray, str => Number(str))
    const reducedRightWithInit = numArray.reduceRight((accumulator, value) => accumulator + value, 10)
    this.results.push(`reduceRight((accumulator, value) => accumulator + value, 10) 结果: ${reducedRightWithInit}\n (注意：非数字会被转为NaN)`)
  }

  // isValidInt8Array(arr: number[]) {
  //   for (const str of this.inputArray) {
  //     const num = Number(str);
  //     if (Number.isInteger(num) && num >= -128 && num <= 127) {
  //       arr.push(num);
  //     } else {
  //       this.results.push(`请输入符合Int8Array范围(-128 到 127 的整数)`);
  //       return; // 遇到第一个无效数字就终止
  //     }
  //   }
  // }

  isNumber(arr: number[]) {
    for (const str of this.inputArray) {
      const num = Number(str);

      if (!isNaN(num) && isFinite(num) && this.inputArray.length != 0) {
        arr.push(num); // 所有有效数字都加入数组
      } else {
        this.results.push(`输入包含非数字的值: "${str}"`);
        return; // 遇到第一个非数字值就终止
      }
    }
  }

  //Int8Array
  testInt8ArrayOf(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)

    if(numbers.length > 0) {
      const int8ArrOf: collections.Int8Array = collections.Int8Array.of(...numbers);
      this.results.push(`int8Array of 结果: [${int8ArrOf.join(', ')}]`);
    }
  }

  testInt8ArrayLastIndexOf(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)

    if(numbers.length > 0) {
      const int8Arr: collections.Int8Array = collections.Int8Array.from(numbers)
      const lastIndex = int8Arr.lastIndexOf(3)
      this.results.push(`int8Array lastIndexOf(3) 结果: ${lastIndex}`)
    }
  }

  testInt8ArrayToString():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if(numbers.length > 0) {
      const int8Arr: collections.Int8Array = collections.Int8Array.from(numbers)
      const stringResult = int8Arr.toString()
      this.results.push(`toString() 结果: "${stringResult}"`)
    }
  }

  testInt8ArrayToLocaleString():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if(numbers.length > 0) {
      const int8Arr: collections.Int8Array = collections.Int8Array.from(numbers)
      let stringArray = int8Arr.toLocaleString()
      this.results.push(`toLocaleString() 结果: "${stringArray}"`)
    }
  }

  testInt8ArrayReduceRight(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if(numbers.length > 0) {
      const int8Arr: collections.Int8Array = collections.Int8Array.from(numbers)
      const reducedRight: number = int8Arr.reduceRight((accumulator: number, value: number) => accumulator + value);
      this.results.push(`int8Array reduceRight((accumulator, value) => accumulator + value) 结果: ${reducedRight}`)
    }
  }

  testInt8ArrayReduceRight2():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const int8Arr: collections.Int8Array = collections.Int8Array.from(numbers)
      const reducedRightWithInit = int8Arr.reduceRight((accumulator, value) => accumulator + value, 10)
      this.results.push(`reduceRight((accumulator, value) => accumulator + value, 10) 结果: ${reducedRightWithInit}`)
    }
  }

  //Uint8ClampedArray
  testUint8ClampedArrayOf(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint8ClampedArrayOf: collections.Uint8ClampedArray = collections.Uint8ClampedArray.of(...numbers);
      this.results.push(`int8Array of 结果: [${uint8ClampedArrayOf.join(', ')}]`)
    }
  }

  testUint8ClampedArrayLastIndexOf(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint8ClampedArrayOf: collections.Uint8ClampedArray = collections.Uint8ClampedArray.of(...numbers);
      const lastIndex = uint8ClampedArrayOf.lastIndexOf(3)
      this.results.push(`int8Array lastIndexOf(3) 结果: ${lastIndex}`)
    }
  }

  testUint8ClampedArrayToString():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint8ClampedArrayOf: collections.Uint8ClampedArray = collections.Uint8ClampedArray.of(...numbers);
      const stringResult = uint8ClampedArrayOf.toString()
      this.results.push(`toString() 结果: "${stringResult}"`)
    }
  }

  testUint8ClampedArrayToLocaleString():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint8ClampedArrayOf: collections.Uint8ClampedArray = collections.Uint8ClampedArray.of(...numbers);
      let stringArray = uint8ClampedArrayOf.toLocaleString()
      this.results.push(`toLocaleString() 结果: "${stringArray}"`)
    }
  }

  testUint8ClampedArrayReduceRight(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint8ClampedArrayOf: collections.Uint8ClampedArray = collections.Uint8ClampedArray.of(...numbers);
      const reducedRight: number =
        uint8ClampedArrayOf.reduceRight((accumulator: number, value: number) => accumulator + value);
      this.results.push(`int8Array reduceRight((accumulator, value) => accumulator + value) 结果: ${reducedRight}`)
    }
  }

  testUint8ClampedArrayReduceRight2():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint8ClampedArrayOf: collections.Uint8ClampedArray = collections.Uint8ClampedArray.of(...numbers);
      const reducedRightWithInit = uint8ClampedArrayOf.reduceRight((accumulator, value) => accumulator + value, 10)
      this.results.push(`reduceRight((accumulator, value) => accumulator + value, 10) 结果: ${reducedRightWithInit}`)
    }
  }

  testUint8ArrayOf(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint8ArrOf: collections.Uint8Array = collections.Uint8Array.of(...numbers);
      this.results.push(`int8Array of 结果: [${uint8ArrOf.join(', ')}]`)
    }
  }

  testUint8ArrayLastIndexOf(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint8Arr: collections.Uint8Array = collections.Uint8Array.of(...numbers);
      const lastIndex = uint8Arr.lastIndexOf(3)
      this.results.push(`int8Array lastIndexOf(3) 结果: ${lastIndex}`)
    }
  }

  testUint8ArrayToString():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint8Arr: collections.Uint8Array = collections.Uint8Array.of(...numbers);
      const stringResult = uint8Arr.toString()
      this.results.push(`toString() 结果: "${stringResult}"`)
    }
  }

  testUint8ArrayToLocaleString():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint8Arr: collections.Uint8Array = collections.Uint8Array.of(...numbers);
      let stringArray = uint8Arr.toLocaleString()
      this.results.push(`toLocaleString() 结果: "${stringArray}"`)
    }
  }

  testUint8ArrayReduceRight(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint8Arr: collections.Uint8Array = collections.Uint8Array.of(...numbers);
      const reducedRight: number = uint8Arr.reduceRight((accumulator: number, value: number) => accumulator + value);
      this.results.push(`int8Array reduceRight((accumulator, value) => accumulator + value) 结果: ${reducedRight}`)
    }
  }

  testUint8ArrayReduceRight2():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint8Arr: collections.Uint8Array = collections.Uint8Array.of(...numbers);
      const reducedRightWithInit = uint8Arr.reduceRight((accumulator, value) => accumulator + value, 10)
      this.results.push(`reduceRight((accumulator, value) => accumulator + value, 10) 结果: ${reducedRightWithInit}`)
    }
  }

  testInt16ArrayOf(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const int16Arr: collections.Int16Array = collections.Int16Array.of(...numbers);
      this.results.push(`int8Array of 结果: [${int16Arr.join(', ')}]`)
    }
  }

  testInt16ArrayLastIndexOf(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const int16Arr: collections.Int16Array = collections.Int16Array.of(...numbers);
      const lastIndex = int16Arr.lastIndexOf(3)
      this.results.push(`int8Array lastIndexOf(3) 结果: ${lastIndex}`)
    }
  }

  testInt16ArrayToString():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const int16Arr: collections.Int16Array = collections.Int16Array.of(...numbers);
      const stringResult = int16Arr.toString()
      this.results.push(`toString() 结果: "${stringResult}"`)
    }
  }

  testInt16ArrayToLocaleString():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const int16Arr: collections.Int16Array = collections.Int16Array.of(...numbers);
      let stringArray = int16Arr.toLocaleString()
      this.results.push(`toLocaleString() 结果: "${stringArray}"`)
    }
  }

  testInt16ArrayReduceRight(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const int16Arr: collections.Int16Array = collections.Int16Array.of(...numbers);
      const reducedRight: number = int16Arr.reduceRight((accumulator: number, value: number) => accumulator + value);
      this.results.push(`int8Array reduceRight((accumulator, value) => accumulator + value) 结果: ${reducedRight}`)
    }
  }

  testInt16ArrayReduceRight2():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const int16Arr: collections.Int16Array = collections.Int16Array.of(...numbers);
      const reducedRightWithInit = int16Arr.reduceRight((accumulator, value) => accumulator + value, 10)
      this.results.push(`reduceRight((accumulator, value) => accumulator + value, 10) 结果: ${reducedRightWithInit}`)
    }
  }

  testUint16ArrayOf(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint16Arr: collections.Uint16Array = collections.Uint16Array.of(...numbers);
      this.results.push(`int8Array of 结果: [${uint16Arr.join(', ')}]`)
    }
  }

  testUint16ArrayLastIndexOf(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint16Arr: collections.Uint16Array = collections.Uint16Array.of(...numbers);
      const lastIndex = uint16Arr.lastIndexOf(3)
      this.results.push(`int8Array lastIndexOf(3) 结果: ${lastIndex}`)
    }
  }

  testUint16ArrayToString():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint16Arr: collections.Uint16Array = collections.Uint16Array.of(...numbers);
      const stringResult = uint16Arr.toString()
      this.results.push(`toString() 结果: "${stringResult}"`)
    }
  }

  testUint16ArrayToLocaleString():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint16Arr: collections.Uint16Array = collections.Uint16Array.of(...numbers);
      let stringArray = uint16Arr.toLocaleString()
      this.results.push(`toLocaleString() 结果: "${stringArray}"`)
    }
  }

  testUint16ArrayReduceRight(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint16Arr: collections.Uint16Array = collections.Uint16Array.of(...numbers);
      const reducedRight: number = uint16Arr.reduceRight((accumulator: number, value: number) => accumulator + value);
      this.results.push(`int8Array reduceRight((accumulator, value) => accumulator + value) 结果: ${reducedRight}`)
    }
  }

  testUint16ArrayReduceRight2():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint16Arr: collections.Uint16Array = collections.Uint16Array.of(...numbers);
      const reducedRightWithInit = uint16Arr.reduceRight((accumulator, value) => accumulator + value, 10)
      this.results.push(`reduceRight((accumulator, value) => accumulator + value, 10) 结果: ${reducedRightWithInit}`)
    }
  }

  testInt32ArrayOf(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const int32Arr: collections.Int32Array = collections.Int32Array.of(...numbers);
      this.results.push(`int8Array of 结果: [${int32Arr.join(', ')}]`)
    }
  }

  testInt32ArrayLastIndexOf(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const int32Arr: collections.Int32Array = collections.Int32Array.of(...numbers);
      const lastIndex = int32Arr.lastIndexOf(3)
      this.results.push(`int8Array lastIndexOf(3) 结果: ${lastIndex}`)
    }
  }

  testInt32ArrayToString():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const int32Arr: collections.Int32Array = collections.Int32Array.of(...numbers);
      const stringResult = int32Arr.toString()
      this.results.push(`toString() 结果: "${stringResult}"`)
    }
  }

  testInt32ArrayToLocaleString():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const int32Arr: collections.Int32Array = collections.Int32Array.of(...numbers);
      let stringArray = int32Arr.toLocaleString()
      this.results.push(`toLocaleString() 结果: "${stringArray}"`)
    }
  }

  testInt32ArrayReduceRight(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const int32Arr: collections.Int32Array = collections.Int32Array.of(...numbers);
      const reducedRight: number = int32Arr.reduceRight((accumulator: number, value: number) => accumulator + value);
      this.results.push(`int8Array reduceRight((accumulator, value) => accumulator + value) 结果: ${reducedRight}`)
    }
  }

  testInt32ArrayReduceRight2():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const int32Arr: collections.Int32Array = collections.Int32Array.of(...numbers);
      const reducedRightWithInit = int32Arr.reduceRight((accumulator, value) => accumulator + value, 10)
      this.results.push(`reduceRight((accumulator, value) => accumulator + value, 10) 结果: ${reducedRightWithInit}`)
    }
  }

  testUint32ArrayOf(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint32Arr: collections.Uint32Array = collections.Uint32Array.of(...numbers);
      this.results.push(`int8Array of 结果: [${uint32Arr.join(', ')}]`)
    }
  }

  testUint32ArrayLastIndexOf(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint32Arr: collections.Uint32Array = collections.Uint32Array.of(...numbers);
      const lastIndex = uint32Arr.lastIndexOf(3)
      this.results.push(`int8Array lastIndexOf(3) 结果: ${lastIndex}`)
    }
  }

  testUint32ArrayToString():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint32Arr: collections.Uint32Array = collections.Uint32Array.of(...numbers);
      const stringResult = uint32Arr.toString()
      this.results.push(`toString() 结果: "${stringResult}"`)
    }
  }

  testUint32ArrayToLocaleString():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint32Arr: collections.Uint32Array = collections.Uint32Array.of(...numbers);
      let stringArray = uint32Arr.toLocaleString()
      this.results.push(`toLocaleString() 结果: "${stringArray}"`)
    }
  }

  testUint32ArrayReduceRight(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint32Arr: collections.Uint32Array = collections.Uint32Array.of(...numbers);
      const reducedRight: number = uint32Arr.reduceRight((accumulator: number, value: number) => accumulator + value);
      this.results.push(`int8Array reduceRight((accumulator, value) => accumulator + value) 结果: ${reducedRight}`)
    }
  }

  testUint32ArrayReduceRight2():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const uint32Arr: collections.Uint32Array = collections.Uint32Array.of(...numbers);
      const reducedRightWithInit = uint32Arr.reduceRight((accumulator, value) => accumulator + value, 10)
      this.results.push(`reduceRight((accumulator, value) => accumulator + value, 10) 结果: ${reducedRightWithInit}`)
    }
  }

  testFloat32ArrayOf(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const float32Arr: collections.Float32Array = collections.Float32Array.of(...numbers)
      this.results.push(`int8Array of 结果: [${float32Arr.join(', ')}]`)
    }
  }

  testFloat32ArrayLastIndexOf(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const float32Arr: collections.Float32Array = collections.Float32Array.of(...numbers)
      const lastIndex = float32Arr.lastIndexOf(3)
      this.results.push(`int8Array lastIndexOf(3) 结果: ${lastIndex}`)
    }
  }

  testFloat32ArrayToString():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const float32Arr: collections.Float32Array = collections.Float32Array.of(...numbers)
      const stringResult = float32Arr.toString()
      this.results.push(`toString() 结果: "${stringResult}"`)
    }
  }

  testFloat32ArrayToLocaleString():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const float32Arr: collections.Float32Array = collections.Float32Array.of(...numbers)
      let stringArray = float32Arr.toLocaleString()
      this.results.push(`toLocaleString() 结果: "${stringArray}"`)
    }
  }

  testFloat32ArrayReduceRight(): void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const float32Arr: collections.Float32Array = collections.Float32Array.of(...numbers)
      const reducedRight: number = float32Arr.reduceRight((accumulator: number, value: number) => accumulator + value);
      this.results.push(`int8Array reduceRight((accumulator, value) => accumulator + value) 结果: ${reducedRight}`)
    }
  }

  testFloat32ArrayReduceRight2():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const float32Arr: collections.Float32Array = collections.Float32Array.of(...numbers)
      const reducedRightWithInit = float32Arr.reduceRight((accumulator, value) => accumulator + value, 10)
      this.results.push(`reduceRight((accumulator, value) => accumulator + value, 10) 结果: ${reducedRightWithInit}`)
    }
  }

  testBitVectorPush():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const bitVector: collections.BitVector = new collections.BitVector(0)
      for (let i = 0; i < numbers.length; i++) {
        bitVector.push(numbers[i] !== 0 ? 1 : 0);
      }
      let pushRes = bitVector.push(0)
      this.results.push(`bitVector.push(0) 结果: ${pushRes}`)
    }
  }

  testBitVectorPop():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const bitVector: collections.BitVector = new collections.BitVector(0)
      for (let i = 0; i < numbers.length; i++) {
        bitVector.push(numbers[i] !== 0 ? 1 : 0);
      }
      const popRes = bitVector.pop()
      this.results.push(`bitVector.pop() 结果: ${popRes}`)
    }
  }

  testBitVectorHas():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const bitVector: collections.BitVector = new collections.BitVector(0)
      for (let i = 0; i < numbers.length; i++) {
        bitVector.push(numbers[i] !== 0 ? 1 : 0);
      }
      const popHas = bitVector.has(1,1,4)
      this.results.push(`bitVector.has(1,1,4) 结果: ${popHas}`)
    }
  }

  testBitVectorSetBitsByRange():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const bitVector: collections.BitVector = new collections.BitVector(0)
      for (let i = 0; i < numbers.length; i++) {
        bitVector.push(numbers[i] !== 0 ? 1 : 0);
      }
      bitVector.setBitsByRange(0, 1, 3)
      const arr: number[] = []
      for (let item of bitVector) {
        console.info("value: " + item);
        arr.push(item)
      }
      this.results.push(`bitVector.setBitsByRange(0, 1, 3)后, bitVector: [${arr.toString()}]`)
    }
  }

  testBitVectorSetAllBits():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const bitVector: collections.BitVector = new collections.BitVector(0)
      for (let i = 0; i < numbers.length; i++) {
        bitVector.push(numbers[i] !== 0 ? 1 : 0);
      }
      bitVector.setAllBits(0)
      const arr: number[] = []
      for (let item of bitVector) {
        console.info("value: " + item);
        arr.push(item)
      }
      this.results.push(`bitVector.setAllBits(0)后, bitVector: [${arr.toString()}]`)
    }
  }

  testBitVectorGetBitsByRange():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const bitVector: collections.BitVector = new collections.BitVector(0)
      for (let i = 0; i < numbers.length; i++) {
        bitVector.push(numbers[i] !== 0 ? 1 : 0);
      }
      const getBits = bitVector.getBitsByRange(1, 3)
      const arr: number[] = []
      for (let item of getBits) {
        console.info("value: " + item);
        arr.push(item)
      }
      this.results.push(`bitVector.getBitsByRange(1, 3)后, getBits: [${arr.toString()}]`)
    }
  }

  testBitVectorResize():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const bitVector: collections.BitVector = new collections.BitVector(0)
      for (let i = 0; i < numbers.length; i++) {
        bitVector.push(numbers[i] !== 0 ? 1 : 0);
      }
      bitVector.resize(10)
      const arr: number[] = []
      for (let item of bitVector) {
        console.info("value: " + item);
        arr.push(item)
      }
      this.results.push(`bitVector.resize(10)后, bitVector: [${arr.toString()}]`)
    }
  }

  testBitVectorGetBitCountByRange():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const bitVector: collections.BitVector = new collections.BitVector(0)
      for (let i = 0; i < numbers.length; i++) {
        bitVector.push(numbers[i] !== 0 ? 1 : 0);
      }
      let res: number = bitVector.getBitCountByRange(1, 1, 4);
      this.results.push(`bitVector.getBitCountByRange(1, 1, 4) 结果: ${res}`)
    }
  }

  testBitVectorGetIndexOf():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const bitVector: collections.BitVector = new collections.BitVector(0)
      for (let i = 0; i < numbers.length; i++) {
        bitVector.push(numbers[i] !== 0 ? 1 : 0);
      }
      let res: number = bitVector.getIndexOf(0, 1, 4);
      this.results.push(`bitVector.getIndexOf(0, 1, 4) 结果: ${res}`)
    }
  }

  testBitVectorGetLastIndexOf():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const bitVector: collections.BitVector = new collections.BitVector(0)
      for (let i = 0; i < numbers.length; i++) {
        bitVector.push(numbers[i] !== 0 ? 1 : 0);
      }
      let res: number = bitVector.getLastIndexOf(0, 1, 4);
      this.results.push(`bitVector.getLastIndexOf(0, 1, 4) 结果: ${res}`)
    }
  }

  testBitVectorFlipBitByIndex():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const bitVector: collections.BitVector = new collections.BitVector(0)
      for (let i = 0; i < numbers.length; i++) {
        bitVector.push(numbers[i] !== 0 ? 1 : 0);
      }
      bitVector.flipBitByIndex(3)
      const arr: number[] = []
      for (let item of bitVector) {
        console.info("value: " + item);
        arr.push(item)
      }
      this.results.push(`bitVector.flipBitByIndex(3)后, bitVector: [${arr.toString()}]`)
    }
  }

  testBitVectorFlipBitsByRange():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const bitVector: collections.BitVector = new collections.BitVector(0)
      for (let i = 0; i < numbers.length; i++) {
        bitVector.push(numbers[i] !== 0 ? 1 : 0);
      }
      bitVector.flipBitsByRange(1, 4)
      const arr: number[] = []
      for (let item of bitVector) {
        console.info("value: " + item);
        arr.push(item)
      }
      this.results.push(`bitVector.flipBitsByRange(1, 4)后, bitVector: [${arr.toString()}]`)
    }
  }

  testBitVectorValues():void {
    const numbers: number[] = [];
    this.isNumber(numbers)
    if (numbers.length > 0) {
      const bitVector: collections.BitVector = new collections.BitVector(0)
      for (let i = 0; i < numbers.length; i++) {
        bitVector.push(numbers[i] !== 0 ? 1 : 0);
      }
      let iter: IterableIterator<number> = bitVector.values();
      let temp: IteratorResult<number> = iter.next();
      const arr: number[] = []
      while (!temp.done) {
        arr.push(temp.value)
        console.info('zyn' + JSON.stringify(temp.value));
        temp = iter.next();
      }
      this.results.push(`bitVector.values() 结果: ${arr.toString()}`)
    }
  }
}