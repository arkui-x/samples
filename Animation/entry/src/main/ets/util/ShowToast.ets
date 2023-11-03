import prompt from '@ohos.promptAction'

class ShowToast {
  private longToastTime: number = 3000
  private shortToastTime: number = 1000

  showToast(message: ResourceStr, duration: number) {
    prompt.showToast({ message: message, duration: duration })
  }

  shortToast(message: ResourceStr) {
    this.showToast(message, this.shortToastTime)
  }

  longToast(message: ResourceStr) {
    this.showToast(message, this.longToastTime)
  }
}

export default new ShowToast()