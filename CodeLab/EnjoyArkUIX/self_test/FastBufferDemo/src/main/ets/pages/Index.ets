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

import { fastbuffer } from '@kit.ArkTS';

interface ButtonConfig {
  name: string,
  action: () => void
}

@Entry
@Component
struct Index {
  @State resultText: string[] = [];
  @State showResult: boolean = false;

  // 定义按钮配置数组
  private buttonConfigs: ButtonConfig [] = [
    { name: 'fastbuffer.alloc', action: () => this.testAlloc() },
    { name: 'fastbuffer.allocUninitializedFromPool', action: () => this.testAllocUninitializedFromPool() },
    { name: 'fastbuffer.allocUninitialized', action: () => this.testAllocUninitialized() },
    { name: 'fastbuffer.byteLength', action: () => this.testByteLength() },
    { name: 'fastbuffer.concat', action: () => this.testConcat() },
    { name: 'fastbuffer.from_array', action: () => this.testFromArray() },
    { name: 'fastbuffer.from_arrayBuffer', action: () => this.testFromArrayBuffer() },
    { name: 'fastbuffer.from_buffer', action: () => this.testFromBuffer() },
    { name: 'fastbuffer.from_string', action: () => this.testFromString() },
    { name: 'fastbuffer.isBuffer', action: () => this.testIsBuffer() },
    { name: 'fastbuffer.isEncoding', action: () => this.testIsEncoding() },
    { name: 'fastbuffer.compare', action: () => this.testCompare() },
    { name: 'fastbuffer.transcode', action: () => this.testTranscode() },
    { name: 'FastBuffer.fill', action: () => this.testFastBufferFill() },
    { name: 'FastBuffer.compare', action: () => this.testFastBufferCompare() },
    { name: 'FastBuffer.copy', action: () => this.testFastBufferCopy() },
    { name: 'FastBuffer.equals', action: () => this.testFastBufferEquals() },
    { name: 'FastBuffer.includes', action: () => this.testFastBufferIncludes() },
    { name: 'FastBuffer.indexOf', action: () => this.testFastBufferIndexOf() },
    { name: 'FastBuffer.keys&values', action: () => this.testFastBufferKeysValues() },
    { name: 'FastBuffer.lastIndexOf', action: () => this.testFastBufferLastIndexOf() },
    { name: 'FastBuffer.entries', action: () => this.testFastBufferEntries() },
    { name: 'FastBuffer.readBig', action: () => this.testFastBufferReadBig() },
    { name: 'FastBuffer.readDouble&Float', action: () => this.testFastBufferReadDoubleFloat() },
    { name: 'FastBuffer.readInt', action: () => this.testFastBufferReadInt() },
    { name: 'FastBuffer.readUInt', action: () => this.testFastBufferReadUInt() },
    { name: 'FastBuffer.subarray', action: () => this.testFastBufferSubarray() },
    { name: 'FastBuffer.swap', action: () => this.testFastBufferSwap() },
    { name: 'FastBuffer.to', action: () => this.testFastBufferTo() },
    { name: 'FastBuffer.write', action: () => this.testFastBufferWrite() },
  ];

  build() {
    Row() {
      Column() {
        if (this.showResult) {
          Scroll() {
            Column() {
              Text('操作结果')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 10 })

              ForEach(this.resultText, (item: string, index: number) => {
                Text(`${index + 1}. ${item}`)
                  .fontSize(14)
                  .width('90%')
                  .textAlign(TextAlign.Start)
                  .margin({ top: 3, bottom: 3 })
              }, (item: string) => item)
              Button() {
                Text('关闭')
              }
              .margin({ top: 15 })
              .width('40%')
              .height(35)
              .onClick(() => {
                this.showResult = false;
              })
            }
            .width('90%')
            .padding(15)
            .backgroundColor('#F0F0F0')
            .borderRadius(10)
            .margin({ bottom: 20 })
          }
          .height(300)
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Off)
        }

        Scroll() {
          Column() {
            ForEach(this.buttonConfigs, (config: ButtonConfig, index: number) => {
              Button(config.name)
                .type(ButtonType.Capsule)
                .margin({ top: 25 })
                .backgroundColor(Color.Yellow)
                .fontColor(Color.Black)
                .width('80%')
                .height(50)
                .onClick(() => {
                  config.action()
                })
            }, (config: ButtonConfig) => config.name)

            Blank()
              .height(400)
          }
          .width('100%')
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
      }
      .width('100%')
      .height('100%')
    }
    .height('100%')
  }

  testAlloc():void {
    this.resultText = [];

    let buf1 = fastbuffer.alloc(5);
    let buf2 = fastbuffer.alloc(5, 'a');
    let buf3 = fastbuffer.alloc(11, 'aGVsbG8gd29ybGQ=', 'base64');

    // 输出结果：5
    this.resultText.push(`创建的FastBuffer对象字节长度为: ${buf1.length.toString()}`);
    // 输出结果：aaaaa
    this.resultText.push(`创建的FastBuffer对象为: ${buf2.toString()}`);
    // 输出结果：hello world
    this.resultText.push(`使用base64编码格式创建的FastBuffer对象为: ${buf3.toString()}`);
    this.showResult = true;
  }

  testAllocUninitializedFromPool():void {
    this.resultText = [];

    let buf = fastbuffer.allocUninitializedFromPool(10);
    buf.fill(0);
    // "buf":[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    this.resultText.push(`从内存池中分配的缓冲区的长度: ${buf.length.toString()}`); //10
    this.showResult = true;
  }

  testAllocUninitialized():void {
    this.resultText = [];

    let buf = fastbuffer.allocUninitialized(10);
    buf.fill(0);
    // "buf":[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    this.resultText.push(`缓冲区的长度: ${buf.length.toString()}`); //10
    this.showResult = true;
  }

  testByteLength():void {
    this.resultText = [];

    // 输出结果：11 bytes
    let result = fastbuffer.byteLength('hello world', 'utf-8');

    // 输出结果：12 bytes
    let result2 = fastbuffer.byteLength('\u00bd + \u00bc = \u00be', 'utf-8');

    this.resultText.push(`'hello world'的字节长度: ${result}`);
    this.resultText.push(`'\u00bd + \u00bc = \u00be'的字节长度: ${result2}`);
    this.showResult = true;
  }

  testConcat():void {
    this.resultText = [];

    let buf1 = fastbuffer.from("1234");
    let buf2 = fastbuffer.from("abcd");
    let buf = fastbuffer.concat([buf1, buf2]);

    // 输出结果：1234abcd
    this.resultText.push(`fastbuffer.concat([buf1, buf2]) result: ${buf.toString()}`);
    this.showResult = true;
  }

  testFromArray():void {
    this.resultText = [];

    let buf = fastbuffer.from([0x62, 0x75, 0x66, 0x66, 0x65, 0x72]);

    // 输出结果：627566666572
    this.resultText.push(`通过Array创建的FastBuffer对象: ${buf.toString('hex')}`);
    this.showResult = true;
  }

  testFromArrayBuffer():void {
    this.resultText = [];

    let arrayBuf = new ArrayBuffer(10);
    let buf = fastbuffer.from(arrayBuf, 0, 2);

    // 输出结果：2
    this.resultText.push(`通过ArrayBuffer创建的FastBuffer对象: ${buf.length.toString()}`);
    this.showResult = true;
  }

  testFromBuffer():void {
    this.resultText = [];

    // 以FastBuffer对象类型进行创建新的FastBuffer对象
    let buf1 = fastbuffer.from('buffer');
    let buf2 = fastbuffer.from(buf1);

    // 输出结果：buffer
    this.resultText.push(`通过FastBuffer创建的FastBuffer对象: ${buf2.toString()}`);

    // 以Uint8Array对象类型进行创建FastBuffer对象，保持对象间内存共享
    let uint8Array = new Uint8Array(10);
    let buf3 = fastbuffer.from(uint8Array);
    buf3.fill(1)
    // 输出结果：1,1,1,1,1,1,1,1,1,1
    this.resultText.push(`通过Uint8Array创建的FastBuffer对象: ${uint8Array}`);

    this.showResult = true;
  }

  testFromString():void {
    this.resultText = [];

    let buf1 = fastbuffer.from('this is a test');
    let buf2 = fastbuffer.from('7468697320697320612074c3a97374', 'hex');

    // 输出结果：this is a test
    this.resultText.push(`通过utf8 String创建的FastBuffer对象: ${buf1.toString()}`);

    // 输出结果：this is a tést
    this.resultText.push(`通过hex String创建的FastBuffer对象: ${buf2.toString()}`);
    this.showResult = true;
  }

  testIsBuffer():void {
    this.resultText = [];

    let result = fastbuffer.isBuffer(fastbuffer.alloc(10));
    // 输出结果：true
    this.resultText.push(`fastbuffer.alloc(10)是否为FastBuffer: ${result}`);

    let result1 = fastbuffer.isBuffer(fastbuffer.from('foo'));
    // 输出结果：true
    this.resultText.push(`fastbuffer.from('foo')是否为FastBuffer： ${result1}`);

    let result2 = fastbuffer.isBuffer('a string');
    // 输出结果：false
    this.resultText.push(`'a string'是否为FastBuffer: ${result2}`);

    let result3 = fastbuffer.isBuffer([]);
    // 输出结果：false
    this.resultText.push(`[]是否为FastBuffer: ${result3}`);

    let result4 = fastbuffer.isBuffer(new Uint8Array(1024));
    // 输出结果：false
    this.resultText.push(`new Uint8Array(1024)是否为FastBuffer: ${result4}`);

    this.showResult = true;
  }

  testIsEncoding():void {
    this.resultText = [];

    let result = fastbuffer.isEncoding('utf-8');
    // 输出结果：true
    this.resultText.push(`'utf-8'是否为支持的编码格式: ${result.toString()}`);

    let result2 = fastbuffer.isEncoding('hex');
    // 输出结果：true
    this.resultText.push(`'hex'是否为支持的编码格式: ${result2.toString()}`);

    let result3 = fastbuffer.isEncoding('utf/8');
    // 输出结果：false
    this.resultText.push(`'utf/8'是否为支持的编码格式: ${result3.toString()}`);

    let result4 = fastbuffer.isEncoding('');
    // 输出结果：false
    this.resultText.push(`''是否为支持的编码格式: ${result4.toString()}`);

    this.showResult = true;
  }

  testCompare():void {
    this.resultText = [];

    let buf1 = fastbuffer.from('1234');
    let buf2 = fastbuffer.from('0123');
    let res = fastbuffer.compare(buf1, buf2);

    // 输出结果：1
    this.resultText.push(`fastbuffer.compare(buf1, buf2) : ${res.toString()}`);

    this.showResult = true;
  }

  testTranscode():void {
    this.resultText = [];

    let newBuf = fastbuffer.transcode(fastbuffer.from('buffer'), 'utf-8', 'ascii');

    // 输出结果：buffer
    this.resultText.push(`将FastBuffer对象从utf-8编码转换为ascii编码后的FastBuffer对象为: ${newBuf.toString('ascii')}`);

    this.showResult = true;
  }

  testFastBufferFill():void {
    this.resultText = [];

    let b = fastbuffer.allocUninitializedFromPool(10).fill('h');

    // 输出结果：hhhhhhhhhh
    this.resultText.push(`从内存池中分配一个字节长度为10的缓冲区并全部初始化为h: ${b.toString()}`);

    this.showResult = true;
  }

  testFastBufferCompare():void {
    this.resultText = [];

    let buf1 = fastbuffer.from([1, 2, 3, 4, 5, 6, 7, 8, 9]);
    let buf2 = fastbuffer.from([5, 6, 7, 8, 9, 1, 2, 3, 4]);

    // 输出结果：0
    let result = buf1.compare(buf2, 5, 9, 0, 4);
    this.resultText.push(`比较buf1(0,4)与目标对象buf2(5,9)，比较结果: ${result.toString()}`);

    // 输出结果：-1
    let result2 = buf1.compare(buf2, 0, 6, 4);
    this.resultText.push(`比较buf1(4,)与目标对象buf2(0,6)，比较结果: ${result2.toString()}`);

    // 输出结果：1
    let result3 = buf1.compare(buf2, 5, 6, 5);
    this.resultText.push(`比较buf1(5,)与目标对象buf2(5,6)，比较结果: ${result3.toString()}`);

    this.showResult = true;
  }

  testFastBufferCopy():void {
    this.resultText = [];

    let buf1 = fastbuffer.allocUninitializedFromPool(26);
    let buf2 = fastbuffer.allocUninitializedFromPool(26).fill('!');
    for (let i = 0; i < 26; i++) {
      buf1.writeInt8(i + 97, i);
    }
    buf1.copy(buf2, 8, 16, 20);
    let res = buf2.toString('ascii', 0, 25);
    // 输出结果：!!!!!!!!qrst!!!!!!!!!!!!!
    this.resultText.push(`将buf1中指定位置的数据复制到buf2的指定位置上,buf2为: ${res}`);

    this.showResult = true;
  }

  testFastBufferEquals():void {
    this.resultText = [];

    let buf1 = fastbuffer.from('ABC');
    let buf2 = fastbuffer.from('414243', 'hex');
    let buf3 = fastbuffer.from('ABCD');

    let result = buf1.equals(buf2);
    // 输出结果：true
    this.resultText.push(`逐字节比较buf1和buf2是否相等 result: ${result}`);

    let result2 = buf1.equals(buf3);
    // 输出结果：false
    this.resultText.push(`逐字节比较buf1和buf3是否相等 result2: ${result2}`);

    this.showResult = true;
  }

  testFastBufferIncludes():void {
    this.resultText = [];

    let buf = fastbuffer.from('this is a buffer');
    let result = buf.includes('this');
    let result2 = buf.includes('be');

    this.resultText.push(`Fastbuffer对象中是否包含'this': ${result}`); // 输出结果：true
    this.resultText.push(`Fastbuffer对象中是否包含'be': ${result2}`); // 输出结果：false

    this.showResult = true;
  }

  testFastBufferIndexOf():void {
    this.resultText = [];

    let buf = fastbuffer.from('this is a buffer');

    let result = buf.indexOf('this');
    this.resultText.push(`'this is a buffer'中this首次出现的索引: ${result}`); // 输出结果：0

    let result2 = buf.indexOf('is');
    this.resultText.push(`'this is a buffer'中is首次出现的索引: ${result2}`); // 输出结果：2

    this.showResult = true;
  }

  testFastBufferKeysValues():void {
    this.resultText = [];

    let buf = fastbuffer.from('buffer');
    let keys = buf.keys();
    let allKeys: number[] = [];
    for (const key of keys) {
      allKeys.push(key);
    }
    this.resultText.push(`返回一个包含key值的迭代器: ${allKeys.toString()}`); // 输出结果：0,1,2,3,4,5

    let pair = buf.values();
    let next:IteratorResult<number> = pair.next();
    let allValues: number[] = [];

    while (!next.done) {
      allValues.push(next.value)
      next = pair.next();
    }
    this.resultText.push(`返回一个包含value值的迭代器: ${allValues.toString()}`); // 输出结果：98,117,102,102,101,114

    this.showResult = true;
  }

  testFastBufferLastIndexOf():void {
    this.resultText = [];

    let buf = fastbuffer.from('this buffer is a buffer');
    // 输出结果：0
    this.resultText.push(`'this buffer is a buffer'中this最后一次出现的索引: ${buf.lastIndexOf('this')}`);
    // 输出结果：17
    this.resultText.push(`'this buffer is a buffer'中buffer最后一次出现的索引: ${buf.lastIndexOf('buffer')}`);

    this.showResult = true;
  }

  testFastBufferEntries():void {
    this.resultText = [];

    let buf = fastbuffer.from('buffer');
    let pair = buf.entries();
    let next: IteratorResult<Object[]> = pair.next();
    let allValues: number[] = [];

    while (!next.done) {
      console.info("fastbuffer: " + next.value);
      allValues.push((next.value as [number, number])[1]);
      next = pair.next();
    }
    this.resultText.push(`返回的迭代器的值为: ${allValues.toString()}`); // 输出结果：98,117,102,102,101,114

    this.showResult = true;
  }

  testFastBufferReadBig():void {
    this.resultText = [];

    let buf = fastbuffer.from([0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x70,
      0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78]);
    let readBigInt64BE = buf.readBigInt64BE(0);
    // 输出结果：7161960797921896816
    this.resultText.push(`readBigInt64BE(0)读取出的内容: ${readBigInt64BE.toString()}`);

    let readBigInt64LE = buf.readBigInt64LE(0);
    // 输出结果：8100120198111388771
    this.resultText.push(`readBigInt64BE(0)读取出的内容: ${readBigInt64LE.toString()}`);

    let readBigUInt64BE = buf.readBigUInt64BE(0);
    // 输出结果：7161960797921896816
    this.resultText.push(`readBigInt64BE(0)读取出的内容: ${readBigUInt64BE.toString()}`);

    let readBigUInt64LE = buf.readBigUInt64LE(0);
    // 输出结果：8100120198111388771
    this.resultText.push(`readBigInt64BE(0)读取出的内容: ${readBigUInt64LE.toString()}`);

    this.showResult = true;
  }

  testFastBufferReadDoubleFloat():void {
    this.resultText = [];

    let buf = fastbuffer.from([1, 2, 3, 4, 5, 6, 7, 8]);
    let readDoubleBE = buf.readDoubleBE(0);
    // 输出结果：8.20788039913184e-304
    this.resultText.push(`readDoubleBE(0)读取出的内容: ${readDoubleBE.toString()}`);

    let readDoubleLE = buf.readDoubleLE(0);
    // 输出结果：5.447603722011605e-270
    this.resultText.push(`readDoubleBE(0)读取出的内容: ${readDoubleLE.toString()}`);

    let readFloatBE = buf.readFloatBE(0);
    // 输出结果：2.387939260590663e-38
    this.resultText.push(`readFloatBE(0)读取出的内容: ${readFloatBE.toString()}`);

    let readFloatLE = buf.readFloatLE(0);
    // 输出结果：1.539989614439558e-36
    this.resultText.push(`readFloatLE(0)读取出的内容: ${readFloatLE.toString()}`);

    this.showResult = true;
  }

  testFastBufferReadInt():void {
    this.resultText = [];

    let buf = fastbuffer.from([-1, 5]);
    let readInt8 = buf.readInt8(0);
    // 输出结果：-1
    this.resultText.push(`readInt8(0)读取出的内容: ${readInt8.toString()}`);

    let readInt8_2 = buf.readInt8(1);
    // 输出结果：5
    this.resultText.push(`readInt8(1)读取出的内容: ${readInt8_2.toString()}`);

    let buf2 = fastbuffer.from([0, 5]);
    let readInt16BE = buf2.readInt16BE(0);
    // 输出结果：5
    this.resultText.push(`readInt16BE(0)读取出的内容: ${readInt16BE.toString()}`);

    let readInt16LE = buf2.readInt16LE(0);
    // 输出结果：1280
    this.resultText.push(`readInt16LE(0)读取出的内容: ${readInt16LE.toString()}`);

    let buf3 = fastbuffer.from([0, 0, 0, 5]);
    let readInt32BE = buf3.readInt32BE(0);
    // 输出结果：5
    this.resultText.push(`readInt32BE(0)读取出的内容: ${readInt32BE.toString()}`);

    let readInt32LE = buf3.readInt32LE(0);
    // 输出结果：83886080
    this.resultText.push(`readInt32LE(0)读取出的内容: ${readInt32LE.toString()}`);

    let buf4 = fastbuffer.from("ab");
    let num = buf4.readIntBE(0, 1);
    // 输出结果：97
    this.resultText.push(`readInt32LE(0)读取出的内容: ${num.toString()}`);

    let buf5 = fastbuffer.from([0x12, 0x34, 0x56, 0x78, 0x90, 0xab]);
    let result = buf5.readIntLE(0, 6).toString(16);
    // 输出结果：-546f87a9cbee
    this.resultText.push(`readIntLE(0, 6)读取出的内容: ${result}`);

    this.showResult = true;
  }

  testFastBufferReadUInt():void {
    this.resultText = [];

    let buf = fastbuffer.from([1, -2]);
    let result = buf.readUInt8(0).toString();
    // 输出结果：1
    this.resultText.push(`readUInt8(0)读取出的内容: ${result}`);

    let result2 = buf.readUInt8(1).toString();
    // 输出结果：254
    this.resultText.push(`readUInt8(1)读取出的内容: ${result2}`);

    let buf2 = fastbuffer.from([0x12, 0x34, 0x56]);
    let result3 = buf2.readUInt16BE(0).toString(16);
    // 输出结果：1234
    this.resultText.push(`readUInt16BE(0)读取出的内容: ${result3}`);

    let result4 = buf2.readUInt16BE(1).toString(16);
    // 输出结果：3456
    this.resultText.push(`readUInt16BE(1)读取出的内容: ${result4}`);

    let result5 = buf2.readUInt16LE(0).toString(16);
    // 输出结果：3412
    this.resultText.push(`readUInt16LE(0)读取出的内容: ${result5}`);

    let result6 = buf2.readUInt16LE(1).toString(16);
    // 输出结果：5634
    this.resultText.push(`readUInt16LE(1)读取出的内容: ${result6}`);

    let buf3 = fastbuffer.from([0x12, 0x34, 0x56, 0x78]);
    let result7 = buf3.readUInt32BE(0).toString(16);
    // 输出结果：12345678
    this.resultText.push(`readUInt32BE(0)读取出的内容: ${result7}`);

    let result8 = buf3.readUInt32LE(0).toString(16);
    // 输出结果：78563412
    this.resultText.push(`readUInt32LE(0)读取出的内容: ${result8}`);

    let buf4 = fastbuffer.from([0x12, 0x34, 0x56, 0x78, 0x90, 0xab]);
    let result9 = buf4.readUIntBE(0, 6).toString(16);
    // 输出结果：1234567890ab
    this.resultText.push(`readUIntBE(0, 6)读取出的内容: ${result9}`);

    let result10 = buf4.readUIntLE(0, 6).toString(16);
    // 输出结果：ab9078563412
    this.resultText.push(`readUIntLE(0, 6)读取出的内容: ${result10}`);

    this.showResult = true;
  }

  testFastBufferSubarray():void {
    this.resultText = [];

    let buf1 = fastbuffer.allocUninitializedFromPool(26);

    for (let i = 0; i < 26; i++) {
      buf1.writeInt8(i + 97, i);
    }
    const buf2 = buf1.subarray(0, 3);
    let result = buf2.toString('ascii', 0, buf2.length)
    // 输出结果: abc
    this.resultText.push(`截取当前对象(0, 3)的数据并返回: ${result}`);

    this.showResult = true;
  }

  testFastBufferSwap():void {
    this.resultText = [];

    let buf1 = fastbuffer.from([0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8]);
    buf1.swap16();
    // 输出结果：0201040306050807
    this.resultText.push(`将当前对象转换为无符号的16位整数数组，并交换字节顺序: ${buf1.toString('hex')}`);

    buf1.swap32();
    // 输出结果：0304010207080506
    this.resultText.push(`将当前对象转换为无符号的32位整数数组，并交换字节顺序: ${buf1.toString('hex')}`);

    buf1.swap64();
    // 输出结果：0605080702010403
    this.resultText.push(`将当前对象转换为无符号的64位整数数组，并交换字节顺序: ${buf1.toString('hex')}`);

    this.showResult = true;
  }

  testFastBufferTo():void {
    this.resultText = [];

    let buf1 = fastbuffer.allocUninitializedFromPool(26);
    for (let i = 0; i < 26; i++) {
      buf1.writeInt8(i + 97, i);
    }
    let obj = buf1.toJSON();
    // 输出结果: {"type":"FastBuffer","data":[]}
    this.resultText.push(`将FastBuffer转为JSON: ${JSON.stringify(obj)}`);

    let result = buf1.toString('utf-8');
    // 输出结果: abcdefghijklmnopqrstuvwxyz
    this.resultText.push(`将FastBuffer转为String result: ${result}`);

    this.showResult = true;
  }

  testFastBufferWrite():void {
    this.resultText = [];

    let buf = fastbuffer.alloc(256);
    let len = buf.write('\u00bd + \u00bc = \u00be', 0);
    // 输出结果: 12 bytes: ½ + ¼ = ¾
    this.resultText.push(`buf.write('\u00bd + \u00bc = \u00be', 0) length: ${len} bytes: ${buf.toString('utf-8', 0, len)}`);

    let buffer1 = fastbuffer.alloc(10);
    let length = buffer1.write('abcd', 8);
    // 输出结果：length = 2
    this.resultText.push(`write 写入的字节数: ${length}`);

    let writeBigInt64BEResult = buffer1.writeBigInt64BE(BigInt(0x0102030405060708), 0);
    // 输出结果：length = 8
    this.resultText.push(`writeBigInt64BE 写入的字节数: ${writeBigInt64BEResult}`);

    let writeBigInt64LEResult = buffer1.writeBigInt64LE(BigInt(0x0102030405060708), 0);
    // 输出结果：length = 8
    this.resultText.push(`writeBigInt64LE 写入的字节数: ${writeBigInt64LEResult}`);

    let writeBigUInt64BEResult = buffer1.writeBigUInt64BE(BigInt(0xdecafafecacefade), 0);
    // 输出结果：length = 8
    this.resultText.push(`writeBigUInt64BE 写入的字节数: ${writeBigUInt64BEResult}`);

    let writeBigUInt64LEResult = buffer1.writeBigUInt64LE(BigInt(0xdecafafecacefade), 0);
    // 输出结果：length = 8
    this.resultText.push(`writeBigUInt64LE 写入的字节数: ${writeBigUInt64LEResult}`);

    let writeDoubleBEResult = buffer1.writeDoubleBE(123.456, 0);
    // 输出结果：result = 8
    this.resultText.push(`writeDoubleBE 写入的字节数: ${writeDoubleBEResult}`);

    let writeDoubleLEResult = buffer1.writeDoubleLE(123.456, 0);
    // 输出结果：result = 8
    this.resultText.push(`writeDoubleLE 写入的字节数: ${writeDoubleLEResult}`);

    let writeFloatBEResult = buffer1.writeFloatBE(0xcafebabe, 0);
    // 输出结果：result = 4
    this.resultText.push(`writeFloatBE 写入的字节数: ${writeFloatBEResult}`);

    let writeFloatLEResult = buffer1.writeFloatLE(0xcafebabe, 0);
    // 输出结果：result = 4
    this.resultText.push(`writeFloatLE 写入的字节数: ${writeFloatLEResult}`);

    let writeInt8Result1 = buffer1.writeInt8(2, 0);
    // 输出结果：result = 1
    this.resultText.push(`writeInt8(2, 0) 写入的字节数: ${writeInt8Result1}`);
    let writeInt8Result2 = buffer1.writeInt8(-2, 1);
    // 输出结果：result1 = 2
    this.resultText.push(`writeInt8(-2, 1) 写入的字节数: ${writeInt8Result2}`);

    let writeInt16BEResult = buffer1.writeInt16BE(0x0102, 0);
    // 输出结果：result = 2
    this.resultText.push(`writeInt16BE 写入的字节数: ${writeInt16BEResult}`);

    let writeInt16LEResult = buffer1.writeInt16LE(0x0304, 0);
    // 输出结果：result = 2
    this.resultText.push(`writeInt16BE 写入的字节数: ${writeInt16LEResult}`);

    let writeInt32BEResult = buffer1.writeInt32BE(0x01020304, 0);
    // 输出结果：result = 4
    this.resultText.push(`writeInt32BE 写入的字节数: ${writeInt32BEResult}`);

    let writeInt32LEResult = buffer1.writeInt32LE(0x05060708, 0);
    // 输出结果：result = 4
    this.resultText.push(`writeInt32BE 写入的字节数: ${writeInt32LEResult}`);

    let writeIntBEResult = buffer1.writeIntBE(0x1234567890ab, 0, 6);
    // 输出结果：result = 6
    this.resultText.push(`writeIntBE 写入的字节数: ${writeIntBEResult}`);

    let writeIntLEResult = buffer1.writeIntLE(0x1234567890ab, 0, 6);
    // 输出结果：result = 6
    this.resultText.push(`writeIntLE 写入的字节数: ${writeIntLEResult}`);

    let writeUInt8Reault1 = buffer1.writeUInt8(0x3, 0);
    // 输出结果：result = 1
    this.resultText.push(`writeUInt8(0x3, 0) 写入的字节数: ${writeUInt8Reault1}`);

    let writeUInt8Result2 = buffer1.writeUInt8(0x4, 1);
    // 输出结果：result = 2
    this.resultText.push(`writeUInt8(0x4, 1) 写入的字节数: ${writeUInt8Result2}`);

    let writeUInt8Result3 = buffer1.writeUInt8(0x23, 2);
    // 输出结果：result = 3
    this.resultText.push(`writeUInt8(0x23, 2) 写入的字节数: ${writeUInt8Result3}`);

    let writeUInt8Result4 = buffer1.writeUInt8(0x42, 3);
    // 输出结果：result = 4
    this.resultText.push(`writeUInt8(0x42, 2) 写入的字节数: ${writeUInt8Result4}`);

    let writeUInt16BEResult1 = buffer1.writeUInt16BE(0xdead, 0);
    // 输出结果：result = 2
    this.resultText.push(`writeUInt16BE(0xdead, 0) 写入的字节数: ${writeUInt16BEResult1}`);
    let writeUInt16BEResult2 = buffer1.writeUInt16BE(0xbeef, 2);
    // 输出结果：result1 = 4
    this.resultText.push(`writeUInt16BE(0xbeef, 2) 写入的字节数: ${writeUInt16BEResult2}`);

    let writeUInt16LEResult1 = buffer1.writeUInt16LE(0xdead, 0);
    // 输出结果：result = 2
    this.resultText.push(`writeUInt16LE(0xdead, 0) 写入的字节数: ${writeUInt16LEResult1}`);
    let writeUInt16LEResult2 = buffer1.writeUInt16LE(0xbeef, 2);
    // 输出结果：result1 = 4
    this.resultText.push(`writeUInt16LE(0xbeef, 2) 写入的字节数: ${writeUInt16LEResult2}`);

    let writeUInt32BEResult = buffer1.writeUInt32BE(0xfeedface, 0);
    // 输出结果：result = 4
    this.resultText.push(`writeUInt32BE 写入的字节数: ${writeUInt32BEResult}`);

    let writeUInt32LEResult = buffer1.writeUInt32LE(0xfeedface, 0);
    // 输出结果：result = 4
    this.resultText.push(`writeUInt32LE 写入的字节数: ${writeUInt32LEResult}`);

    let writeUIntBEResult = buffer1.writeUIntBE(0x1234567890ab, 0, 6);
    // 输出结果：result = 6
    this.resultText.push(`writeUIntBE 写入的字节数: ${writeUIntBEResult}`);

    let writeUIntLEResult = buf.writeUIntLE(0x1234567890ab, 0, 6);
    // 输出结果：result = 6
    this.resultText.push(`writeUIntLE 写入的字节数: ${writeUIntLEResult}`);

    this.showResult = true;
  }
}