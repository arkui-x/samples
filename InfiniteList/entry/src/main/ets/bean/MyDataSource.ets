import { BasicDataSource } from './BasicDataSource';
import { InfiniteData } from './InfiniteData'

/**
 * 继承实现IDataSource的基础数据类的无限列表自定义数据类
 */
export class MyDataSource extends BasicDataSource {
  private colorAry: Resource[] = [$r('app.color.light_pink'), $r('app.color.light_red'), $r('app.color.light_lilac'), $r('app.color.light_blue'),
  $r('app.color.light_green'), $r('app.color.light_lemon'), $r('app.color.light_aqua'), $r('app.color.light_yellow'), $r('app.color.light_lavender')]
  private priceAry: string[] = [`￥${(Math.random() * 3).toFixed(2)}`, `￥${(Math.random() * 3).toFixed(2)}`, `￥${(Math.random() * 3).toFixed(2)}`, `￥${(Math.random() * 3).toFixed(2)}`,
    `￥${(Math.random() * 3).toFixed(2)}`, `￥${(Math.random() * 3).toFixed(2)}`, `￥${(Math.random() * 3).toFixed(2)}`, `￥${(Math.random() * 3).toFixed(2)}`, `￥${(Math.random() * 3).toFixed(2)}`]
  private dataArray: InfiniteData[] = []

  constructor() {
    super();
    this.dataArray = this.setData()
  }

  public setData(initIndex: number = 0): InfiniteData[] {
    const data: Array<InfiniteData> = []
    const start_index: number = (initIndex * 200) + 1
    const total: number = start_index + 200
    for (let i = start_index; i < total; i++) {
      const single_data = new InfiniteData(this.colorAry[Math.floor(i % 9)], `Color #${i}`, this.priceAry[Math.floor(i % 9)])
      data.push(single_data)
    }
    return data
  }

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): object {
    return this.dataArray[index];
  }

  public addData(index: number, data: InfiniteData): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public addBatchData(data: InfiniteData[]): void {
    this.dataArray = this.dataArray.concat(data)
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public pushData(data: InfiniteData): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}