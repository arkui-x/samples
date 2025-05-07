import { MeasureText } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

let context = getContext(this);

export class TextUtils {
  /**
   * 获取收起后的短段落字符串
   * @param text       长段落字符串
   * @param fontSize   字符大小
   * @param maxLines   收起后最大行数
   * @param textWidth  段落宽度
   * @param suffix     省略号
   * @param lastSpan   展开收起按钮
   * @returns          短段落字符串
   */
  public static getShortText(text: string, fontSize: Resource | number | string, maxLines: number,
    textWidth: string | number | Resource,
    suffix: string, lastSpan: string): string {
    const minLinesTextSize: SizeOptions = MeasureText.measureTextSize({
      textContent: text,
      fontSize: fontSize,
      maxLines: maxLines,
      wordBreak: WordBreak.BREAK_ALL,
      constraintWidth: textWidth
    });
    const minHeight: Length | undefined = minLinesTextSize.height;
    if (minHeight === undefined) {
      return '';
    }
    // 使用二分法查找正好两行的长度的字符串
    let leftCursor: number = 0;
    let rightCursor: number = text.length;
    let cursor: number = Math.floor(rightCursor / 2);
    let tempTitle: string = '';
    while (true) {
      tempTitle = text.substring(0, cursor) + suffix + lastSpan;
      const currentLinesTextSize: SizeOptions = MeasureText.measureTextSize({
        textContent: tempTitle,
        fontSize: fontSize,
        wordBreak: WordBreak.BREAK_ALL,
        constraintWidth: textWidth
      });
      const currentLineHeight: Length | undefined = currentLinesTextSize.height;
      if (currentLineHeight === undefined) {
        return '';
      }
      if (currentLineHeight > minHeight) {
        // 当前字符已超过两行，向左继续找
        rightCursor = cursor;
        cursor = leftCursor + Math.floor((cursor - leftCursor) / 2);
      } else {
        // 当前字符小于两行了，可能已经ok，但仍需向右查找
        leftCursor = cursor;
        cursor += Math.floor((rightCursor - cursor) / 2);
      }
      if (Math.abs(rightCursor - leftCursor) <= 1) {
        // 两次指针基本重合了，代表已找到
        break;
      }
    }
    // 这里由于添加空格 所以cursor需要减1
    return text.substring(0, cursor - 1) + suffix + '  ';
  }

  public static getStringFromResource(source: Resource | string): string {
    try {
      if (typeof source === 'string') {
        return source;
      }
      return context.resourceManager.getStringSync(source);
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      console.log('getStringFromResource' + code + message);
      return '';
    }
  }
}