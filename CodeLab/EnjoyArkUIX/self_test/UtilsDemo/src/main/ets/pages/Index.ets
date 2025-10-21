import { ArkTSUtils, taskpool } from '@kit.ArkTS';

// 创建条件变量实例
const conditionVar = ArkTSUtils.locks.ConditionVariable.request('demoCondition');

@Sendable
class ChildLRUCache extends ArkTSUtils.SendableLruCache<number, number> {
  constructor() {
    super();
  }

  createDefault(key: number): number {
    return key;
  }
}

@Concurrent
async function waitTask(cv: ArkTSUtils.locks.ConditionVariable): Promise<string[]> {
  const logs: string[] = [];

  // 直接使用字符串
  const startMsg = 'TaskPool waitTask: Waiting for signal...';
  logs.push(startMsg);
  console.info(startMsg);

  await cv.wait(); // 等待唤醒信号

  const receivedMsg = 'TaskPool waitTask: Received signal!';
  logs.push(receivedMsg);
  console.info(receivedMsg);

  return logs;
}

@Concurrent
async function waitForTask(cv: ArkTSUtils.locks.ConditionVariable): Promise<string[]> {
  const logs: string[] = [];

  const startMsg = 'TaskPool waitForTask: Waiting for signal...';
  logs.push(startMsg);
  console.info(startMsg);

  await cv.waitFor(8000); // 等待唤醒信号

  const receivedMsg = 'TaskPool waitForTask: Received signal!';
  logs.push(receivedMsg);
  console.info(receivedMsg);

  return logs;
}

@Concurrent
function notifyTask(cv: ArkTSUtils.locks.ConditionVariable): string[] {
  const logs: string[] = [];

  const msg = 'TaskPool notifyTask: Sending signal...';
  logs.push(msg);
  console.info(msg);
  cv.notifyAll(); // 发送唤醒信号

  return logs;
}

@Concurrent
function notifyOneTask(cv: ArkTSUtils.locks.ConditionVariable): string[] {
  const logs: string[] = [];

  const msg = 'TaskPool notifyOne: Sending signal...';
  logs.push(msg);
  console.info(msg);
  cv.notifyOne(); // 发送唤醒信号

  return logs;
}


@Entry
@Component
struct UtilsExample {
  private pro = new ArkTSUtils.SendableLruCache<string, string>(1);
  private originName = ['list1', 'list2', 'list3', 'list4', 'list5'];
  @State cacheName: string[] = [];
  @State value: number = 1;
  // 添加日志状态变量
  @State logs: string[] = [];

  aboutToAppear(): void {
    // 启动等待任务并处理返回的日志
    const waitTaskPromise = taskpool.execute(waitTask, conditionVar);
    const waitForTaskPromise = taskpool.execute(waitForTask, conditionVar);

    // 处理任务返回的日志
    this.processTaskLogs(waitTaskPromise);
    this.processTaskLogs(waitForTaskPromise);

    let lru = new ChildLRUCache();
    lru.put(2, 10);
    lru.get(3);
    lru.get(5);
    let res = lru.getCreateCount();
    this.addLog('SendableLruCache getCreateCount res:' + res);
  }

  // 处理任务返回的日志
  async processTaskLogs(taskPromise: Promise<Object>): Promise<void> {
    try {
      // 直接 await taskPromise，然后断言为字符串数组
      const logMessages = await taskPromise as string[];
      logMessages.forEach((logMsg: string) => {
        this.addLog(logMsg);
      });
    } catch (error) {
      this.addLog('Error processing task logs: ' + error);
    }
  }

  // 修改日志方法：新日志添加到开头，限制总长度<=30
  addLog(message: string): void {
    const timestamp = new Date().toLocaleTimeString();
    // 新日志添加到数组开头
    this.logs.unshift(`[${timestamp}] ${message}`);
    // 限制日志数量不超过30条
    if (this.logs.length > 30) {
      this.logs = this.logs.slice(0, 30);
    }
    console.log(message); // 同时输出到控制台
  }

  @Builder
  itemBuilder(value: string) {
    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      Text(value)
        .fontColor('#182431')
        .fontSize(16)
      Image($r('app.media.add')).width(24).height(24).onClick(() => {
        let result = this.pro.contains(value)
        if (!result) {
          this.pro.put(value, value)
          this.addLog('SendableLruCache put: ' + value);
          this.addLog('SendableLruCache getPutCount:' + this.pro.getPutCount());
          let pair: Iterable<Object[]> = this.pro.entries();
          let arrayValue = Array.from(pair);
          for (let value of arrayValue) {
            this.addLog("SendableLruCache entries:" + value[0] + ', ' + value[1]);
          }
          this.cacheName = this.pro.keys()
        }
      })
    }
    .width('100%')
    .height(56)
    .padding({ left: 12, right: 12 })
  }

  @Builder
  cacheBuilder(value: string) {
    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      Text(value)
        .fontColor('#182431')
        .fontSize(16)
      Image($r('app.media.delete')).width(24).height(24).onClick(() => {
        if (this.pro.contains(value)) {
          this.pro.remove(value)
          this.addLog('SendableLruCache remove: ' + value);
          this.addLog('SendableLruCache getRemoveCount:' + this.pro.getRemoveCount());
          let index = this.cacheName.findIndex(item => item === value)
          index > -1 && this.cacheName.splice(index, 1)
        }
      })
    }.width('100%').height(56).padding({ left: 12, right: 12 })
  }

  // 修改日志区域构建器：最新日志显示在最上面
  @Builder
  logBuilder() {
    Column() {
      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
        Text('操作日志 (最新显示在最上面)')
          .fontSize(18)
          .fontColor('#182431')
          .fontWeight(500)

        Button('清空日志')
          .fontSize(12)
          .padding(8)
          .onClick(() => {
            this.logs = [];
          })
      }
      .width('100%')
      .padding({ left: 12, right: 12 })

      if (this.logs.length > 0) {
        Scroll() {
          Column() {
            ForEach(this.logs, (log: string, index: number) => {
              Text(log)
                .fontSize(12)
                .fontColor('#666666')
                .textAlign(TextAlign.Start)
                .width('90%')
                .margin({ right: 10 })
                .backgroundColor(index % 2 === 0 ? '#F8F9FA' : '#FFFFFF')
            }, (log: string) => log)
          }
          .width('100%')
        }
        .scrollBar(BarState.Off)
        .height(200)
        .width('100%')
        .border({ width: 1, color: '#E5E5E5' })
        .margin(12)
      } else {
        Text('暂无日志')
          .fontSize(14)
          .fontColor('#999999')
          .textAlign(TextAlign.Center)
          .width('100%')
          .padding(20)
      }
    }
    .width('90%')
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ top: 12, bottom: 12 })
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          Text('cacheData').fontSize(18).fontColor('#182431').fontWeight(500).margin(24)

          if (this.cacheName.length) {
            List({ space: 12 }) {
              ForEach(this.cacheName, (item: string) => {
                ListItem() {
                  this.cacheBuilder(item)
                }
                .backgroundColor('#FFFFFF')
                .borderRadius(24)
              })
            }.width('90%')
          } else {
            Image($r('app.media.empty')).width(100).height(100)
          }
          Row() {
            Text("容量:")
            Counter() {
              Text(this.value.toString())
            }.margin(10)
            .onInc(() => {
              this.value++;
              this.pro.updateCapacity(this.pro.getCapacity() + 1) //点击加号缓冲区容量+1
              this.addLog('SendableLruCache capacity increased to: ' + this.pro.getCapacity());
              this.addLog('SendableLruCache:' + this.pro.toString())
              this.addLog('SendableLruCache keys:' + JSON.stringify(this.pro.keys()))
              this.addLog('SendableLruCache values:' + JSON.stringify(this.pro.values()))
            })
            .onDec(() => {
              this.value--;
              this.pro.updateCapacity(this.pro.getCapacity() - 1) //点击减号缓冲区容量-1
              this.addLog('SendableLruCache capacity decreased to: ' + this.pro.getCapacity());
              if (this.pro.length < this.cacheName.length) {
                this.cacheName.splice(0, 1)
                this.addLog('SendableLruCache getRemoveCount:' + this.pro.getRemoveCount());
              }
              this.addLog('SendableLruCache:' + this.pro.toString())
              this.addLog('SendableLruCache keys:' + JSON.stringify(this.pro.keys()))
              this.addLog('SendableLruCache values:' + JSON.stringify(this.pro.values()))
            })

            Text("清空：")
            Image($r('app.media.remove')).width(24).height(24).onClick(() => {
              if (!this.pro.isEmpty()) {
                this.pro.clear();
                this.addLog('SendableLruCache cleared');
                this.addLog('SendableLruCache length:' + this.pro.length)
                this.cacheName = []
                // 触发唤醒任务并处理返回的日志
                const notifyTaskPromise = taskpool.execute(notifyTask, conditionVar);
                this.processTaskLogs(notifyTaskPromise);
              }
              // 触发唤醒任务并处理返回的日志
              const notifyOneTaskPromise = taskpool.execute(notifyOneTask, conditionVar);
              this.processTaskLogs(notifyOneTaskPromise);
            })
          }

          // 根据数字创建的标记组件
          Text('originalData').fontSize(18).fontColor('#182431').fontWeight(500).margin(24)
          List() {
            ForEach(this.originName, (item: string) => {
              ListItem() {
                this.itemBuilder(item)
              }.onClick(() => {
                this.pro.get(item)
                this.addLog('SendableLruCache get: ' + item);
                this.addLog('SendableLruCache getMissCount:' + this.pro.getMissCount())
                this.addLog('SendableLruCache getMatchCount:' + this.pro.getMatchCount())
              })
            })
          }
          .width('90%')
          .backgroundColor('#FFFFFF')
          .borderRadius(24)
          .padding({ top: 4, bottom: 4 })
          .divider({
            strokeWidth: 0.5,
            color: 'rgba(0,0,0,0.1)',
            startMargin: 15,
            endMargin: 15
          })

          // 添加日志区域
          this.logBuilder()
        }.width('100%').backgroundColor('#F1F3F5').padding({ bottom: 12 })
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
    }.width('100%')
  }
}