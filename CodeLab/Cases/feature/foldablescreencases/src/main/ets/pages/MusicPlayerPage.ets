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

import { display, window } from '@kit.ArkUI';

import CommonConstants from '../common/constants/CommonConstants';

import { MusicModel } from '../model/MusicModel';
import WindowModel from '../model/WindowModel';
import { MusicPlayerViewModel } from '../viewmodel/MusicPlayViewModel';

import { MusicPlayerCtrlComp } from '../components/MusicPlayerCtrlComp';
import { MusicPlayerInfoComp } from '../components/MusicPlayerInfoComp';

import { logger } from 'utils';
import { AppRouter } from 'routermodule';

/**
 * 音乐播放器页面
 * 实现步骤：
 * 1.通过display的isFoldable接口区分折叠屏和非折叠屏
 * 2.通过监听display的foldStatusChange，将折叠屏状态分发给各子组件
 * 3.折叠屏设备使用FolderStack容器组件实现，指定子组件在折叠屏悬停态，移到上屏的能力
 */

@AppRouter({ name: "foldablescreencases/MusicPlayerPage" })
@Component
export struct MusicPlayerPage {
  // 窗口管理model
  private windowModel: WindowModel = new WindowModel();
  // 当前页面的vm实例
  @Provide('musicPlayerViewModel') viewModel: MusicPlayerViewModel = new MusicPlayerViewModel();
  // 当前折叠屏状态（若当前为折叠屏设备才有效）
  @State curFoldStatus: display.FoldStatus = display.getFoldStatus();

  // 通用样式
  @Styles
  stackStyle() {
    .height("100%")
    .width("100%")
    .backgroundImage(this.viewModel.curMusicModel?.coverRes)
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
    .backgroundBlurStyle(BlurStyle.BACKGROUND_THIN)
  }

  aboutToAppear(): void {
    // 初始化窗口管理model
    const windowStage: window.WindowStage | undefined = AppStorage.get('windowStage');
    // 没有windowStage将无法执行下列逻辑
    if (!windowStage) {
      logger.warn('MusicPlayerPage', 'windowStage init error!');
      return;
    }

    // 初始化windowModel中的windowStage实例
    this.windowModel.setWindowStage(windowStage);
    // 初始化音乐播放器页面沉浸式展示
    this.windowModel.setMainWindowImmersive(true);
    // 折叠屏设备，音乐播放器页面的窗口属性初始化
    if (display.isFoldable()) {
      // 根据当前折叠屏状态修改窗口显示方向
      this.windowModel.updateMainWinPreferredOrientation();
      // 监听折叠屏状态变更，更新折叠态，修改窗口显示方向
      display.on('foldStatusChange', (curFoldStatus: display.FoldStatus) => {
        this.curFoldStatus = curFoldStatus;
        this.windowModel.updateMainWinPreferredOrientation(curFoldStatus);
      })
    }

    // vm初始化
    this.viewModel.init(getContext(this), CommonConstants.MUSIC_INFO_ARR);
  }

  aboutToDisappear(): void {
    // 关闭页面沉浸式展示
    this.windowModel.setMainWindowImmersive(false);
    // 释放vm实例持有的资源
    this.viewModel.release();
  }

  build() {
    // 折叠屏UI展示
    if (display.isFoldable()) {
      // TODO：知识点：FolderStack继承于Stack控件，通过upperItems字段识别指定id的组件，自动避让折叠屏折痕区后移到上半屏
      FolderStack({ upperItems: [CommonConstants.FOLDER_STACK_UP_COMP_ID] }) {
        MusicPlayerInfoComp({ curFoldStatus: this.curFoldStatus })
          .id(CommonConstants.FOLDER_STACK_UP_COMP_ID)
        MusicPlayerCtrlComp()
      }
      // TODO：知识点：是否使用默认动效
      .enableAnimation(false)
      // TODO：知识点：是否开启自动旋转，仅在系统自动旋转关闭时该属性生效
      .autoHalfFold(false)
      // TODO：知识点：folderStack如果不撑满页面全屏，作为普通Stack使用
      .stackStyle()
      .alignContent(Alignment.Bottom)
    } else { // 非折叠屏UI展示
      Stack() {
        MusicPlayerInfoComp()
        MusicPlayerCtrlComp()
      }
      .stackStyle()
      .alignContent(Alignment.Bottom)
    }
  }
}