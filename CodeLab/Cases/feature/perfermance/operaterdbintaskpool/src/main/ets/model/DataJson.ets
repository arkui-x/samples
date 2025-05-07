import { Contact } from './Contact';
import { util } from '@kit.ArkTS';

/*
 * 从rawfile中addressbook.json文件中json数据解析成json字符串
 * @param { string } jsonFileDir - json文件路径
 */
export function getJsonData(jsonFileDir: string): Array<Contact> {
  // 从本地文件中获取数据
  const value = getContext().resourceManager.getRawFileContentSync(jsonFileDir);
  // 解码为utf-8格式
  const textDecoder = util.TextDecoder.create('utf-8', {
    ignoreBOM: true
  });
  const textDecoderResult = textDecoder.decodeToString(new Uint8Array(value.buffer));
  const jsonObj: Array<Contact> = JSON.parse(textDecoderResult) as Array<Contact>;
  let contactModelBuckets: Array<Contact> = [];
  for (let i = 0; i < jsonObj.length; i++) {
    contactModelBuckets.push(new Contact(
      jsonObj[i].id,
      jsonObj[i].name,
      jsonObj[i].phone,
      jsonObj[i].email,
      jsonObj[i].address,
      jsonObj[i].avatar,
      jsonObj[i].category
    ));
  }
  return contactModelBuckets;
}
