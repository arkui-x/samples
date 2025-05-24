export class WantData {
  private constructor() {
  }

  private static instance: WantData;
  private static dataStr: string;

  public static getWantData(): WantData {
    if (!WantData.instance) {
      WantData.instance = new WantData();
    }
    return WantData.instance;
  }

  public static setData(data: string) {
    WantData.dataStr = data;
  }

  public static getDataStr(): string {
    return WantData.dataStr;
  }
}
