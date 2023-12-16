/**
 * 判断是否是视频格式
 * @message string
 * @returns boolean
 */
export function checkIsVideo(message:string):boolean {
  if(message.includes('mp4') || message.includes('mov') || message.includes('MP4') || message.includes('MOV')) {
    return true;
  }else {
    return false;
  }
}

/**
 * 判断是否是图片截图
 * @message string
 * @returns boolean
 */
export function checkIsScreenshot(message:string):boolean {
  let str:string = message.toLowerCase();
  if(str.includes('screenshot')) {
    return true;
  }else {
    return false;
  }
}