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

import { FunctionDescription } from '../utils/FunctionDescription';
import dbUtils from '../utils/DBUtils';
import { Constants } from '../constants/Constants';
import commonUtils from '../utils/CommonUtils';
import { CustomFormComponent } from '../components/CustomFormComponent';
import { V1DataService, V2DataService } from '../service/DataService';

/**
 * 功能描述: 本示例介绍使用关系型数据库的接口来进行数据库升降级场景实现
 *
 * 推荐场景: 数据库版本升级
 *
 * 核心组件:
 * 1. DataService
 *
 * 实现步骤：
 * 1、数据迁移使用临时表方案，在升级时将旧表重命名为临时表，并创建一张与旧表未重命名前的名字相同的新表，分批次取出临时表中数据进行转换存入新表中，数据迁移完毕后删除临时表。
 * 2、为方便扩展迭代，在父类中定义整体逻辑，子类只需继承父类，重写字段转换逻辑即可。
 * 3、根据数据库当前版本和需升级至版本，选择对应的升级逻辑。
 * 4、数据库接口几乎都是异步接口，为实现与业务解耦，对数据库操作进行封装
 */

@Component
export struct DatabaseUpgradeComponent {
  @State res: object = Constants.students[0];
  @State v1Res: object = Constants.students[0];
  @State v2Res: object = Constants.students[0];
  @State versionNumber: number = Constants.V1;
  @State isUpdatedToV2: boolean = false;
  @State isUpdatedToV3: boolean = false;
  @State isRollback: boolean = false;
  private v1DataService: V1DataService = new V1DataService();
  private v2DataService: V2DataService = new V2DataService();

  aboutToAppear(): void {
    dbUtils.initDB();
  }

  aboutToDisappear(): void {
    dbUtils.deleteRdbStore();
  }

  async restore(version: number) {
    await dbUtils.restore(version);
    await dbUtils.queryData(Constants.STUDENT_TABLE, Constants.NUMBER_1, -Constants.NUMBER_1, async (resultSet) => {
      if (resultSet.goToFirstRow()) {
        this.res = resultSet.getRow();
      }
    });
    this.versionNumber = dbUtils.getStoreVersion();
    this.isRollback = true;
    commonUtils.showToast(Constants.ROLLBACK_SUCCESS);
  }

  async updateVersion(version: number) {
    const currentVersion = dbUtils.getStoreVersion();
    // 备份数据库
    await dbUtils.backup(currentVersion);
    switch (currentVersion) {
      case Constants.V1:
        await this.v1DataService.onUpgrade(version);
        break;
      case Constants.V2:
        await this.v2DataService.onUpgrade(version);
        break;
      default:
        throw new Error('The database version to which you need to upgrade is incorrect');
    }
    dbUtils.commit();
    await dbUtils.queryData(Constants.STUDENT_TABLE, Constants.NUMBER_1, -Constants.NUMBER_1, async (resultSet) => {
      if (resultSet.goToFirstRow()) {
        this.res = resultSet.getRow();
      }
    });
    this.versionNumber = dbUtils.getStoreVersion();
    this.isRollback = false;
    commonUtils.showToast(Constants.UPDATE_SUCCESS);
  }

  build() {
    Column() {
      // 功能描述
      FunctionDescription({
        title: $r("app.string.database_upgrade_case_title"),
        content: Constants.PRODUCTION
      })
      Column() {
        // 表模块
        Column() {
          // V1版本表
          Column() {
            if ((this.isUpdatedToV2 || this.isUpdatedToV3) && !(this.isUpdatedToV2 && this.isUpdatedToV3)) {
              CustomFormComponent({ res: this.v1Res, title: Constants.V1 })
              Row() {
                Text($r("app.string.database_upgrade_delete_class_name"))
                  .fontSize(Constants.NUMBER_10)
                Text($r("app.string.database_upgrade_arrowhead_text"))
                  .fontSize(Constants.NUMBER_50)
                if (!this.isUpdatedToV2 && this.isUpdatedToV3) {
                  Text($r("app.string.database_upgrade_add_teacher_first_name"))
                    .fontSize(Constants.NUMBER_10)
                } else {
                  Text($r("app.string.database_upgrade_add_teacher_name"))
                    .fontSize(Constants.NUMBER_10)
                }
              }
            }
          }

          // V2版本表
          Column() {
            if (this.isUpdatedToV2 && this.isUpdatedToV3) {
              CustomFormComponent({ res: this.v2Res, title: Constants.V2 })
              Row() {
                Text($r("app.string.database_upgrade_rename_teacher_name"))
                  .fontSize(Constants.NUMBER_10)
                Text($r("app.string.database_upgrade_arrowhead_text"))
                  .fontSize(Constants.NUMBER_50)
                Text($r("app.string.database_upgrade_to_teacher_first_name"))
                  .fontSize(Constants.NUMBER_10)
              }
            }
          }

          // 当前版本表
          CustomFormComponent({ res: this.res, title: this.versionNumber })
            .margin({ bottom: Constants.NUMBER_20 })
        }.height($r("app.string.database_upgrade_forty_percent"))

        // 按钮模块
        Column() {
          // 版本升级按钮模块
          Text($r("app.string.database_upgrade_version_upgrade_text"))
            .fontSize(Constants.NUMBER_12)
            .alignSelf(ItemAlign.Start)
            .margin({ bottom: Constants.NUMBER_12 })
          Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row }) {
            Button($r("app.string.database_upgrade_upgrade_to_v2_button_text"))
              .margin({ right: Constants.NUMBER_12 })
              .fontSize(Constants.NUMBER_12)
              .fontWeight(Constants.NUMBER_500)
              .enabled(this.versionNumber === Constants.V1)
              .onClick(async () => {
                this.isUpdatedToV2 = true;
                await this.updateVersion(Constants.V2);
              })
            Button($r("app.string.database_upgrade_upgrade_to_v3_button_text"))
              .enabled(this.versionNumber !== Constants.V3)
              .margin({ right: Constants.NUMBER_12 })
              .fontSize(Constants.NUMBER_12)
              .fontWeight(Constants.NUMBER_500)
              .onClick(async () => {
                this.isUpdatedToV3 = true;
                await this.updateVersion(Constants.V3);
              })
          }.margin({ bottom: Constants.NUMBER_20 })

          Text($r("app.string.database_upgrade_version_restore_text"))
            .alignSelf(ItemAlign.Start)
            .fontSize(Constants.NUMBER_12)
            .margin({ bottom: Constants.NUMBER_12 })
          Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row }) {
            Button($r("app.string.database_upgrade_restore_to_v2"))
              .margin({ right: Constants.NUMBER_12 })
              .fontSize(Constants.NUMBER_12)
              .fontWeight(Constants.NUMBER_500)
              .enabled(this.versionNumber === Constants.V3 && this.isUpdatedToV2)
              .onClick(async () => {
                await this.restore(Constants.V2);
                this.isUpdatedToV3 = false;
              })
            Button($r("app.string.database_upgrade_restore_to_v1"))
              .enabled(this.versionNumber !== Constants.V1)
              .margin({ right: Constants.NUMBER_12 })
              .fontSize(Constants.NUMBER_12)
              .fontWeight(Constants.NUMBER_500)
              .onClick(async () => {
                await this.restore(Constants.V1);
                this.isUpdatedToV2 = false;
                this.isUpdatedToV3 = false;
              })
          }
        }.margin({ top: 20 })
      }
      .border({
        width: Constants.NUMBER_1,
        color: $r("app.color.database_upgrade_border_color"),
        radius: Constants.NUMBER_10,
        style: BorderStyle.Solid
      })
      .margin({ top: Constants.NUMBER_20 })
    }.width($r("app.string.database_upgrade_ninety_percent"))
  }
}
