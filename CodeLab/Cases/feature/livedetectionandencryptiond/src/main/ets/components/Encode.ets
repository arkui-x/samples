/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';

/**
 * 获取到的字符串转换成Uint8Array格式
 * @param str 字符串
 * @returns
 */
export function stringToUint8Array(str: string): Uint8Array {
  try {
    let textEncoder = new util.TextEncoder('utf-8');
    let array: Uint8Array = textEncoder.encodeInto(str);
    return array;
  } catch (err) {
    return new Uint8Array();
  }
}

/**
 * 指定的对称密钥材料
 * @returns
 */
export function genKeyMaterialBlob():
  cryptoFramework.DataBlob {
  let key = stringToUint8Array('Whh82GtW/EVjBkD8');
  return { data: key };
}

/**
 * 加密或者解密
 * @param plainText 加密或者解密内容
 * @param cryptoMode 加密或者解密模式
 * cryptoFramework.CryptoMode.DECRYPT_MODE--解密模式、cryptoFramework.CryptoMode.ENCRYPT_MODE--加密模式
 * @returns
 */
export async function encryptMessagePromise(plainText: string,
  cryptoMode: cryptoFramework.CryptoMode) {
  let base = new util.Base64Helper();
  // 通过指定算法名称，获取相应的Cipher实例。Cipher：提供加解密的算法操作功能。
  let cipher = cryptoFramework.createCipher('AES128|ECB|PKCS7');
  // 通过指定算法名称的字符串，获取相应的对称密钥生成器实例
  let symKeyGenerator = cryptoFramework.createSymKeyGenerator('AES128');
  let keyMaterialBlob = genKeyMaterialBlob();
  // 异步根据指定数据生成对称密钥，通过注册回调函数获取结果。
  let promiseSymKey = await symKeyGenerator.convertKey(keyMaterialBlob);
  // 初始化加解密的cipher对象
  await cipher.init(cryptoMode, promiseSymKey, null);
  // 加密或者解密的数据
  let text: cryptoFramework.DataBlob =
    cryptoMode === cryptoFramework.CryptoMode.ENCRYPT_MODE ? { data: stringToUint8Array(plainText) } :
      { data: base.decodeSync(plainText) };
  const promise = new Promise<Uint8Array>(async (resolve, reject) => {
    // 获取加密数据
    await cipher.doFinal(text).then((res) => {
      resolve(res.data);
    }).catch((err: BusinessError) => {
      reject(err);
    })
  })
  return promise;
}

export function arrayBufferToBase64(buffer: ArrayBuffer) {
  const base64Helper = new util.Base64Helper();
  let data = base64Helper.encodeSync(new Uint8Array(buffer.slice(0, buffer.byteLength)));
  let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
  return textDecoder.decodeToString(data, { stream: false });
}