/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


import { taskpool } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

// 并发任务函数 - 模拟延迟
@Concurrent
function additionDelay(delay: number): void {
  let start: number = new Date().getTime();
  while (new Date().getTime() - start < delay) {
    continue;
  }
}

// 并发任务函数 - 模拟长时间运行的任务
@Concurrent
function printArgs(args: number): number {
  let t: number = Date.now();
  while (Date.now() - t < 5000) { // 修改为5秒以便更好观察取消效果
    continue;
  }
  if (taskpool.Task.isCanceled()) {
    console.info("task has been canceled after 5s sleep.");
    return args + 1;
  }
  console.info("printArgs: " + args);
  return args;
}

// 并发任务函数 - 取消任务
@Concurrent
function cancelFunction(taskId: number) {
  try {
    taskpool.cancel(taskId);
  } catch (e) {
    console.error(`taskpool: cancel error code: ${e.code}, info: ${e.message}`);
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'TaskPool模块Test';

  // AsyncRunner测试相关状态
  @State asyncRunnerLogs: string[] = [];
  @State isRunning1: boolean = false;
  @State isRunning2: boolean = false;

  // Task取消测试相关状态
  @State taskCancelLogs: string[] = [];
  @State taskStatus: string = '任务未开始';
  private taskId: number = 0;
  private hasTask: boolean = false;

  // 添加AsyncRunner日志
  addAsyncRunnerLog(log: string) {
    let timestamp = new Date().toLocaleTimeString();
    this.asyncRunnerLogs.unshift(`[${timestamp}] ${log}`);
    // 限制日志数量
    if (this.asyncRunnerLogs.length > 40) {
      this.asyncRunnerLogs.pop();
    }
  }

  // 添加Task取消日志
  addTaskCancelLog(log: string) {
    let timestamp = new Date().toLocaleTimeString();
    this.taskCancelLogs.unshift(`[${timestamp}] ${log}`);
    // 限制日志数量，避免内存溢出
    if (this.taskCancelLogs.length > 20) {
      this.taskCancelLogs.pop();
    }
  }

  // 睡眠函数
  sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  // 测试1: 使用名称和配置的AsyncRunner
  async testAsyncRunner1() {
    if (this.isRunning1) {
      this.addAsyncRunnerLog("测试1正在进行中...");
      return;
    }

    this.isRunning1 = true;
    this.addAsyncRunnerLog("开始测试1: 创建带名称的AsyncRunner(runner1, 5, 5)");

    try {
      let runner: taskpool.AsyncRunner = new taskpool.AsyncRunner("runner1", 5, 5);
      let completedCount = 0;
      let errorCount = 0;

      // 执行30个任务
      for (let i = 0; i < 30; i++) {
        let task: taskpool.Task = new taskpool.Task(additionDelay, 1000);

        runner.execute(task).then(() => {
          completedCount++;
          this.addAsyncRunnerLog(`测试1-任务${i}完成 (${completedCount}/30)`);

          // 所有任务完成
          if (completedCount + errorCount === 30) {
            this.isRunning1 = false;
            this.addAsyncRunnerLog(`测试1完成! 成功: ${completedCount}, 失败: ${errorCount}`);
          }
        }).catch((e: BusinessError) => {
          errorCount++;
          this.addAsyncRunnerLog(`测试1-任务${i}失败: ${e.code}-${e.message}`);

          if (completedCount + errorCount === 30) {
            this.isRunning1 = false;
            this.addAsyncRunnerLog(`测试1完成! 成功: ${completedCount}, 失败: ${errorCount}`);
          }
        });

        // 稍微延迟一下，避免瞬间创建过多任务
        if (i % 5 === 0) {
          await this.sleep(10);
        }
      }

      this.addAsyncRunnerLog("测试1: 所有任务已提交到AsyncRunner");
    } catch (e) {
      this.addAsyncRunnerLog(`测试1创建AsyncRunner失败: ${e.code}-${e.message}`);
      this.isRunning1 = false;
    }
  }

  // 测试2: 使用简单配置的AsyncRunner
  async testAsyncRunner2() {
    if (this.isRunning2) {
      this.addAsyncRunnerLog("测试2正在进行中...");
      return;
    }

    this.isRunning2 = true;
    this.addAsyncRunnerLog("开始测试2: 创建简单AsyncRunner(5)");

    try {
      let runner: taskpool.AsyncRunner = new taskpool.AsyncRunner(5);
      let completedCount = 0;

      // 执行20个任务
      for (let i = 0; i < 20; i++) {
        let task: taskpool.Task = new taskpool.Task(additionDelay, 1000);

        runner.execute(task).then(() => {
          completedCount++;
          this.addAsyncRunnerLog(`测试2-任务${i}完成 (${completedCount}/20)`);

          // 所有任务完成
          if (completedCount === 20) {
            this.isRunning2 = false;
            this.addAsyncRunnerLog("测试2完成! 所有任务成功执行");
          }
        });

        // 稍微延迟一下
        if (i % 5 === 0) {
          await this.sleep(10);
        }
      }

      this.addAsyncRunnerLog("测试2: 所有任务已提交到AsyncRunner");
    } catch (e) {
      this.addAsyncRunnerLog(`测试2创建AsyncRunner失败: ${e.code}-${e.message}`);
      this.isRunning2 = false;
    }
  }

  // 开始任务
  startTask() {
    if (this.hasTask) {
      this.addTaskCancelLog("已有任务正在运行，请先取消当前任务");
      return;
    }

    this.addTaskCancelLog("开始执行任务...");
    this.taskStatus = "任务执行中";
    this.hasTask = true;

    let task = new taskpool.Task(printArgs, 100);
    this.taskId = task.taskId;

    // 执行任务并处理结果
    taskpool.execute(task).then((result) => {
      this.addTaskCancelLog(`任务执行完成，结果: ${result}`);
      this.taskStatus = "任务已完成";
      this.hasTask = false;
    }).catch((error:BusinessError) => {
      this.addTaskCancelLog(`任务执行异常: ${error.code} - ${error.message}`);
      this.taskStatus = "任务异常";
      this.hasTask = false;
    });

    this.addTaskCancelLog(`任务ID: ${this.taskId}`);

    // 1秒后自动尝试取消任务（模拟原代码逻辑）
    // setTimeout(() => {
    //   if (this.hasTask) {
    //     this.cancelTask();
    //   }
    // }, 1000);
  }

  // 取消任务
  cancelTask() {
    if (!this.hasTask) {
      this.addTaskCancelLog("没有正在运行的任务");
      return;
    }

    this.addTaskCancelLog(`尝试取消任务ID: ${this.taskId}`);
    this.taskStatus = "取消任务中";

    try {
      let cancelTask = new taskpool.Task(cancelFunction, this.taskId);
      taskpool.execute(cancelTask).then(() => {
        this.addTaskCancelLog("取消指令已发送");
      }).catch((error:BusinessError) => {
        this.addTaskCancelLog(`取消任务失败: ${error.code} - ${error.message}`);
      });
    } catch (e) {
      this.addTaskCancelLog(`取消任务异常: ${e.code} - ${e.message}`);
    }
  }

  // 清空AsyncRunner日志
  clearAsyncRunnerLogs() {
    this.asyncRunnerLogs = [];
    this.addAsyncRunnerLog("日志已清空");
  }

  // 清空Task取消日志
  clearTaskCancelLogs() {
    this.taskCancelLogs = [];
    this.addTaskCancelLog("日志已清空");
  }

  build() {
    Scroll() {
      Column() {
        // 标题
        Text(this.message)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20, bottom: 20 })

        // AsyncRunner测试部分
        Text('1、AsyncRunner接口测试')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 20, bottom: 10 })

        // 测试说明
        Text('测试说明:')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 20, bottom: 5 })

        Text('测试1: AsyncRunner("runner1", 5, 5) - 30个任务\n测试2: AsyncRunner(5) - 20个任务')
          .fontSize(14)
          .margin({ left: 20, right: 20, bottom: 15 })

        // 控制按钮区域
        Row() {
          Button('开始测试1')
            .backgroundColor(this.isRunning1 ? '#FFA000' : '#347AF4')
            .fontColor(Color.White)
            .onClick(() => {
              this.testAsyncRunner1();
            })
            .margin({ right: 10 })

          Button('开始测试2')
            .backgroundColor(this.isRunning2 ? '#FFA000' : '#347AF4')
            .fontColor(Color.White)
            .onClick(() => {
              this.testAsyncRunner2();
            })
        }
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 15 })

        Button('清空AsyncRunner日志')
          .backgroundColor('#808080')
          .fontColor(Color.White)
          .onClick(() => {
            this.clearAsyncRunnerLogs();
          })
          .margin({ bottom: 15 })

        // 状态指示
        Row() {
          Text('测试1状态:')
            .fontSize(14)
          Text(this.isRunning1 ? '运行中' : '未运行')
            .fontSize(14)
            .fontColor(this.isRunning1 ? '#FF6B35' : '#666666')
            .margin({ left: 5, right: 20 })

          Text('测试2状态:')
            .fontSize(14)
          Text(this.isRunning2 ? '运行中' : '未运行')
            .fontSize(14)
            .fontColor(this.isRunning2 ? '#FF6B35' : '#666666')
            .margin({ left: 5 })
        }
        .margin({ bottom: 15 })

        // 日志标题
        Text('AsyncRunner执行日志:')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 20, bottom: 10 })

        // 日志显示区域
        Scroll() {
          Column() {
            ForEach(this.asyncRunnerLogs, (log: string, index: number) => {
              Text(log)
                .fontSize(12)
                .textAlign(TextAlign.Start)
                .padding(8)
                .backgroundColor(index % 2 === 0 ? '#F5F5F5' : '#FFFFFF')
                .borderRadius(4)
                .width('100%')
            }, (log: string) => log)
          }
          .width('100%')
        }
        .height(200)
        .padding(10)
        .backgroundColor('#FAFAFA')
        .border({ width: 1, color: '#E0E0E0', radius: 8 })
        .margin({ left: 20, right: 20, bottom: 30 })

        // Task取消测试部分
        Text('2、Task取消接口测试')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 20, bottom: 10 })

        // 任务状态显示
        Text(`当前状态: ${this.taskStatus}`)
          .fontSize(18)
          .fontColor(this.taskStatus === "任务执行中" ? "#FF6B35" :
            this.taskStatus === "任务已完成" ? "#4CAF50" :
              this.taskStatus === "取消任务中" ? "#FF9800" : "#666666")
          .margin({ bottom: 15 })

        // 控制按钮区域
        Row() {
          Button('开始任务')
            .backgroundColor('#347AF4')
            .fontColor(Color.White)
            .onClick(() => {
              this.startTask();
            })
            .margin({ right: 10 })

          Button('取消任务')
            .backgroundColor('#347AF4')
            .fontColor(Color.White)
            .onClick(() => {
              this.cancelTask();
            })
            .margin({ right: 10 })

          Button('清空Task取消日志')
            .backgroundColor('#808080')
            .fontColor(Color.White)
            .onClick(() => {
              this.clearTaskCancelLogs();
            })
        }
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 15 })

        // 日志标题
        Text('Task取消执行日志:')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 20, bottom: 10 })

        // 日志显示区域
        Scroll() {
          Column() {
            ForEach(this.taskCancelLogs, (log: string, index: number) => {
              Text(log)
                .fontSize(12)
                .textAlign(TextAlign.Start)
                .padding(8)
                .backgroundColor(index % 2 === 0 ? '#F5F5F5' : '#FFFFFF')
                .borderRadius(4)
                .width('100%')
            }, (log: string) => log)
          }
          .width('100%')
        }
        .height(200)
        .padding(10)
        .backgroundColor('#FAFAFA')
        .border({ width: 1, color: '#E0E0E0', radius: 8 })
        .margin({ left: 20, right: 20, bottom: 30 })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
  }
}