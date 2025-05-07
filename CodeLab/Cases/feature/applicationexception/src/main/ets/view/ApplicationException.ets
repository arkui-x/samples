/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import hiAppEvent from '@ohos.hiviewdfx.hiAppEvent'
import { logger, PlatformInfo, PlatformTypeEnum } from 'utils'
import { PreferencesManager } from '../model/PreferencesManager'
import { BUTTON_TEXT } from '../model/MockData'
import { FaultDataSource } from '../model/DataSource'

const TAG: string = '[FaultLogger]' // 应用异常页面标识
const DELAY_TIME: number = 3000 // 延时时间

/**
 * 场景描述: 本示例介绍了通过应用事件打点hiAppEvent获取上一次应用异常信息的方法，主要分为应用崩溃、应用卡死以及系统查杀三种
 *
 * 推荐场景: 应用异常信息获取场景，如：调试应用等
 *
 * 核心组件:
 * 1. FaultArea
 * 2. FaultConstruction
 *
 * 实现步骤:
 * 1. 依次构建应用异常，应用退出后，进入本页面，等待订阅消息通知，待收到订阅消息后，通过EventSubscription.ets中的onReceive函数，
 * 接收到异常信息数据，并通过AppStorage.setOrCreate('appEventGroups',异常信息数据)双向绑定异常信息
 * 2. @StorageLink('appEventGroups')接收订阅事件函数传递的事件组信息，调用getFaultMessage函数对信息进行处理，将处理后的信息
 * 通过this.faultDataSource.pushData(message)添加到懒加载数据源中并通过this.faultDataSource.persistenceStorage()执行
 * 持久化存储，最后通过使用LazyForEach将数据信息加载到页面上
 */
@Component
export struct ApplicationExceptionView {
  // 初始化被点击的异常事件下标
  @Provide eventIndex: number = -1

  eventSubscription() {
    let appEventFilter: hiAppEvent.AppEventFilter = {
      domain: hiAppEvent.domain.OS
    }
    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      appEventFilter.names = [hiAppEvent.event.APP_CRASH, hiAppEvent.event.APP_FREEZE]
    } else if (PlatformInfo.isArkUIX()) {
      appEventFilter.names = [hiAppEvent.event.APP_CRASH]
    }
    // 添加应用事件观察者方法，可用于订阅应用事件
    hiAppEvent.addWatcher({
      // 开发者可以自定义观察者名称，系统会使用名称来标识不同的观察者
      name: "mst",
      // 开发者可以订阅感兴趣的系统事件，此处是订阅了崩溃事件
      appEventFilters: [appEventFilter],
      // TODO：知识点：获取事件组信息。开发者可以自行实现订阅回调函数，崩溃和卡死事件下次应用启动时会回调给开发者
      onReceive: async (domain: string, appEventGroups: Array<hiAppEvent.AppEventGroup>) => {
        logger.info(TAG, `HiAppEvent onReceive: domain=${domain}`)
        /**
         * 获取事件组信息，与ApplicationException文件中的@StorageLink('faultMessage') faultMessage进行双向数据绑定
         * 性能关注：如果开发者有同步的代码需要执行耗时操作，建议起worker或者taskpool线程来处理。但如果开发者使用storage和preferences，直接调用即可。
         */
        AppStorage.setOrCreate('appEventGroups', appEventGroups)
      }
    })
  }

  aboutToAppear(): void {
    // 事件订阅(获取上次异常退出信息)
    this.eventSubscription()
  }

  aboutToDisappear(): void {
    hiAppEvent.removeWatcher({ name: "mst" })
  }

  build() {
    Column() {
      // 场景描述组件
      FunctionDescription({
        title: $r('app.string.application_exception_application_fault_title'),
        content: PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS ?
        $r('app.string.application_exception_application_fault_description_harmonyos') :
        $r('app.string.application_exception_application_fault_description_arkuix')
      })

      // 异常信息显示组件
      FaultArea()

      // 构造异常组件
      FaultConstruction()

    }.padding($r('app.string.application_exception_card_padding_start'))
  }
}

@Component
export struct FunctionDescription {
  private title: ResourceStr = ''
  private content: ResourceStr = ''

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize($r('app.string.application_exception_text_size_headline'))
          .fontWeight(FontWeight.Medium)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .margin({ bottom: $r('app.string.application_exception_elements_margin_vertical_m') })

      Row() {
        Text(this.content)
          .wordBreak(WordBreak.BREAK_ALL)
      }
      .width('100%')
    }
    .width('100%')
    .backgroundColor($r('app.color.application_exception_color_sub_background'))
    .borderRadius($r('app.string.application_exception_corner_radius_default_m'))
    .padding($r('app.string.application_exception_card_padding_start'))
  }
}

@Component
struct FaultArea {
  // 被点击的异常事件下标
  @Consume eventIndex: number;
  // 懒加载数据源
  @State faultDataSource: FaultDataSource = new FaultDataSource();
  // 双向数据绑定懒加载数据源的数组长度
  @StorageLink('faultDataSourceLength') faultDataSourceLength: number = 0;
  // 双向数据绑定事件组，与AppStorage.setOrCreate进行绑定，此变量发生变化触发getFaultMessage函数
  @StorageLink('appEventGroups') @Watch('getFaultMessage') appEventGroups: Array<hiAppEvent.AppEventGroup> = [];
  // 异常触发标识
  @StorageLink('faultSign') faultSign: boolean = false;

  // 获取应用异常信息
  async getFaultMessage() {
    logger.info(TAG, `getAppEventGroups start`);
    if (this.appEventGroups && this.appEventGroups.length > 0) {
      // 遍历事件组
      this.appEventGroups.forEach((eventGroup: hiAppEvent.AppEventGroup) => {
        // 遍历事件对象集合
        eventGroup.appEventInfos.forEach(async (eventInfo: hiAppEvent.AppEventInfo) => {
          let data: string = '';
          if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
            data += `HiAppEvent eventInfo.domain=${eventInfo.domain}\n` // 事件领域
              + `HiAppEvent eventInfo.name=${eventInfo.name}\n`  // 事件名称
              + `HiAppEvent eventInfo.eventType=${eventInfo.eventType}\n` // 事件名称
              + `HiAppEvent eventInfo.params.time=${eventInfo.params['time']}\n` // 事件发生的时间
              + `HiAppEvent eventInfo.params.crash_type=${eventInfo.params['crash_type']}\n`
              + `HiAppEvent eventInfo.params.foreground=${eventInfo.params['foreground']}\n`
              + `HiAppEvent eventInfo.params.bundle_version=${eventInfo.params['bundle_version']}\n`
              + `HiAppEvent eventInfo.params.bundle_name=${eventInfo.params['bundle_name']}\n`
              + `HiAppEvent eventInfo.params.exception=${JSON.stringify(eventInfo.params['exception'])}\n`
              + `HiAppEvent eventInfo.params.hilog.size=${eventInfo.params['hilog'].length}\n`;
          } else if (PlatformInfo.isArkUIX()) {
            data += `HiAppEvent eventInfo.domain=${eventInfo.domain}\n` // 事件领域
              + `HiAppEvent eventInfo.name=${eventInfo.name}\n`  // 事件名称
              + `HiAppEvent eventInfo.eventType=${eventInfo.eventType}\n` // 事件名称
              + `HiAppEvent eventInfo.params.crash_type=${eventInfo.params['crash_type']}\n`
              + `HiAppEvent eventInfo.params.foreground=${eventInfo.params['foreground']}\n`
              + `HiAppEvent eventInfo.params.bundle_version=${eventInfo.params['bundle_version']}\n`
              + `HiAppEvent eventInfo.params.bundle_name=${eventInfo.params['bundle_name']}\n`
              + `HiAppEvent eventInfo.params.exception=${JSON.stringify(eventInfo.params['exception'])}\n`
          }
          let messages: Array<string> = [];
          messages.unshift(data);
          // TODO：知识点：持久化存储异常信息集合
          await PreferencesManager.putFaultMessage(messages);
          // TODO：知识点：通知懒加载数据源更新数据
          await PreferencesManager.getPreferences(this.faultDataSource);
        })
      })
    }
  }

  build() {
    List() {
      // 添加判断，如果异常信息集合的信息条数大于0，遍历异常信息
      if (this.faultDataSourceLength > 0) {
        // 性能：动态加载数据场景可以使用LazyForEach遍历数据。https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-rendering-control-lazyforeach-V5
        LazyForEach(this.faultDataSource, (message: string) => {
          ListItem() {
            Text(message)
              .textAlign(TextAlign.Start)
          }
        }, (item: string) => item)
      }
    }
    .width('100%')
    .height(300)
    .shadow(ShadowStyle.OUTER_DEFAULT_XS)
    .borderRadius($r('app.string.application_exception_corner_radius_default_m'))
    .padding($r('app.string.application_exception_card_padding_start'))
    .margin({ top: $r('app.string.application_exception_elements_margin_vertical_l') })
    .backgroundColor(Color.Grey)
  }
}

@Component
struct FaultConstruction {
  // 被点击的异常事件下标
  @Consume eventIndex: number
  // 双向数据绑定懒加载数据源的数组长度
  @StorageLink('faultDataSourceLength') faultDataSourceLength: number = 0
  // 异常触发标识
  @StorageLink('faultSign') faultSign: boolean = false

  handleOperate(index: number) {
    switch (index) {
      case 0:
        // 在按钮点击函数中构造一个APP_CRASH场景，触发应用崩溃事件
        const result: object = JSON.parse('')
        break
      case 1:
        if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
          // 在按钮点击函数中构造一个APP_FREEZE场景，触发应用卡死事件,500ms之后执行无限循环
          while (true) {
          }
        }
    }
  }

  build() {
    Column() {
      ForEach(BUTTON_TEXT, (item: string, index: number) => {
        if (index === 1) {
          if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
            Button(item)
              .type(ButtonType.Capsule)
              .size({ width: '100%' })
              .borderRadius($r('app.string.application_exception_corner_radius_default_m'))
              .margin({ top: $r('app.string.application_exception_elements_margin_vertical_m') })
              .onClick(() => {
                // 触发异常标识
                this.faultSign = true
                PreferencesManager.putFaultSign()
                // 点击异常的时候，清空页面信息数据，显示异常描述信息。控制页面信息数据的显示需要将此变量设置为0
                this.faultDataSourceLength = 0
                // 更新被点击的异常事件下标
                this.eventIndex = index
                // 3s之后执行系统崩溃操作
                setTimeout(() => {
                  this.handleOperate(index)
                }, DELAY_TIME)
              })
          }
        } else {
          Button(item)
            .type(ButtonType.Capsule)
            .size({ width: '100%' })
            .borderRadius($r('app.string.application_exception_corner_radius_default_m'))
            .margin({ top: $r('app.string.application_exception_elements_margin_vertical_m') })
            .onClick(() => {
              // 触发异常标识
              this.faultSign = true
              PreferencesManager.putFaultSign()
              // 点击异常的时候，清空页面信息数据，显示异常描述信息。控制页面信息数据的显示需要将此变量设置为0
              this.faultDataSourceLength = 0
              // 更新被点击的异常事件下标
              this.eventIndex = index
              // 3s之后执行系统崩溃操作
              this.handleOperate(index)
            })
        }
      }, (item: string) => JSON.stringify(item))
    }.margin({ top: $r('app.string.application_exception_elements_margin_vertical_l') })
  }
}
