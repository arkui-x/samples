/**
 * Determine whether it is a video format
 * @message string
 * @returns boolean
 */
export function checkIsVideo(message: string): boolean {
  if (message.includes('mp4') || message.includes('mov') || message.includes('MP4') || message.includes('MOV')) {
    return true;
  } else {
    return false;
  }
}

/**
 * Determine whether it is a screenshot
 * @message string
 * @returns boolean
 */
export function checkIsScreenshot(message: string): boolean {
  let str: string = message.toLowerCase();
  if (str.includes('screenshot')) {
    return true;
  } else {
    return false;
  }
}