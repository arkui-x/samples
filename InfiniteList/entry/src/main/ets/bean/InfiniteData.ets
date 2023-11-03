/**
 * 无限列表展示的列表信息类
 */
export class InfiniteData {
  color: Resource;
  title: string;
  price: string;

  constructor(color: Resource, title: string, price: string) {
    this.color = color
    this.title = title
    this.price = price
  }
}