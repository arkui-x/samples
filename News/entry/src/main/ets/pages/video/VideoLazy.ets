import { NewsItem } from '../util/Request';

class BasicDataSource implements IDataSource {
  public listeners: DataChangeListener[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): Object {
    return Object;
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}

export class VideoSource extends BasicDataSource {
  public video: NewsItem[] = []

  public totalCount(): number {
    return this.video.length;
  }

  public getData(index: number): NewsItem {
    return this.video[index];
  }

  public addData(index: number, data: NewsItem): void {
    this.video.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public addBatchData(data: NewsItem[]): void {
    this.video = this.video.concat(data)
    this.notifyDataAdd(this.video.length - 1);
  }

  public pushData(data: NewsItem): void {
    this.video.push(data);
    this.notifyDataAdd(this.video.length - 1);
  }
}


