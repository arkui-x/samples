/**
 * tabs组件配置类
 */
export default class  TabsBean {
  private tabName: string; // 页签名称
  private tabContent: string; // 页签内容

  constructor(tabName: string, tabContent: string) {
    this.tabName = tabName;
    this.tabContent = tabContent;
  }

  /* 设置页签内容 */
  setTabContent(tabContent: string): void {
    this.tabContent = tabContent
  }
  getTabName(): string {
    return this.tabName
  }
  /* 获取页签内容 */
  getTabContent(): string {
    return this.tabContent
  }
}