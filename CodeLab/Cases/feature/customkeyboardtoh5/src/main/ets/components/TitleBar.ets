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
import { Browser } from './Browser';
import {
  EKeyType,
  EKeyboardType,
  IKeyAttribute,
  lowerCaseKeyData,
  numericKeyData,
  specialKeyData,
  upperCaseKeyData
} from '../model/Constants';
import { CustomKeyboard } from './CustomKeyboard';
import { logger } from 'utils';
import promptAction from '@ohos.promptAction';

const BROWSER_PROGRESS: number = 100;

// 工具栏按钮对象
interface WebButton {
  imageSrc: Resource,
  id: number
}

// 自定义键盘传入js对象
interface WebKeyboardObj {
  login: Function,
  openDialog: Function
}

@Component
export struct TabletTitle {
  @Link browser: Browser;
  @State arrayIndex: number = 0; // 工具栏按钮索引
  private addr: string = ''; // 地址栏地址
  // 工具栏按钮列表
  private navigationButton: Array<WebButton> = [
    {
      imageSrc: $r("app.media.custom_keyboard_to_h5_ic_public_back"),
      id: 1
    },
    {
      imageSrc: $r("app.media.custom_keyboard_to_h5_ic_public_advance"),
      id: 2
    },
    {
      imageSrc: $r("app.media.custom_keyboard_to_h5_ic_public_refresh"),
      id: 3
    },
    {
      imageSrc: $r("app.media.custom_keyboard_to_h5_ic_public_home"),
      id: 4
    },
  ];
  private actionButton: WebButton =
    {
      imageSrc: $r("app.media.custom_keyboard_to_h5_submit"),
      id: 5
    };

  build() {
    Row() {
      // TODO: 高性能知识点: 使用ForEach组件循环渲染数据
      ForEach(this.navigationButton, (item: WebButton, index) => {
        Button({ type: ButtonType.Normal }) {
          Image(item.imageSrc)
        }
        .margin($r('app.integer.custom_keyboard_to_h5_title_bar_button_margin'))
        .id(`navigationButton${index}`)
        .width($r('app.integer.custom_keyboard_to_h5_button_width'))
        .height($r('app.integer.custom_keyboard_to_h5_button_height'))
        .backgroundColor(this.arrayIndex === item.id ? $r('app.color.custom_keyboard_to_h5_down_color') :
        $r('app.color.custom_keyboard_to_h5_up_color'))
        .borderRadius($r('app.integer.custom_keyboard_to_h5_button_radius'))
        .flexShrink(0)
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Down) {
            this.arrayIndex = item.id;
          }
          if (event.type === TouchType.Up) {
            this.arrayIndex = 0;
          }
        })
        .onClick((event: ClickEvent) => {
          switch (item.id) {
            case 1:
              this.browser.back();
              break;
            case 2:
              this.browser.forward();
              break;
            case 3:
              this.browser.refresh();
              break;
            case 4:
              this.browser.loadUrl($rawfile('custom_keyboard_to_h5_phone.html'));
              break;
          }
        })
      }, (item: WebButton) => item.id.toString())

      TextInput({ placeholder: $r('app.string.custom_keyboard_to_h5_input_url'), text: this.browser.inputValue })
        .enableKeyboardOnFocus(false)
        .selectAll(true)
        .placeholderFont({ size: $r('app.integer.custom_keyboard_to_h5_text_input_place_holder_size'), weight: 500 })
        .fontSize($r('app.integer.custom_keyboard_to_h5_text_input_size'))
        .margin($r('app.integer.custom_keyboard_to_h5_text_input_margin'))
        .id('inputUrl')
        .width($r('app.string.custom_keyboard_to_h5_layout_50'))
        .layoutWeight(1)
        .onChange((value: string) => {
          this.addr = value;
        })
        .onSubmit((enterKey: EnterKeyType) => {
          // 网址跳转
          if (this.addr.length !== 0) {
            this.browser.loadUrl(`${this.addr}`);
            this.addr = '';
          }
        })

      Button({ type: ButtonType.Normal }) {
        Image(this.actionButton.imageSrc)
      }
      .margin($r('app.integer.custom_keyboard_to_h5_title_bar_button_margin'))
      .id('actionButton')
      .width($r('app.integer.custom_keyboard_to_h5_button_width'))
      .height($r('app.integer.custom_keyboard_to_h5_button_height'))
      .backgroundColor(this.arrayIndex === this.actionButton.id ? $r('app.color.custom_keyboard_to_h5_down_color') :
      $r('app.color.custom_keyboard_to_h5_up_color'))
      .borderRadius($r('app.integer.custom_keyboard_to_h5_button_radius'))
      .flexShrink(0)
      .onTouch((event: TouchEvent) => {
        if (event.type === TouchType.Down) {
          this.arrayIndex = this.actionButton.id;
        }
        if (event.type === TouchType.Up) {
          this.arrayIndex = 0;
        }
      })
      .onClick((event: ClickEvent) => {
        // 网址跳转
        if (this.actionButton.id === 5) {
          this.browser.loadUrl(this.addr);
          this.addr = '';
        }
      })
    }
    .width($r('app.string.custom_keyboard_to_h5_layout_100'))
    .padding({ right: $r('app.integer.custom_keyboard_to_h5_title_bar_row_padding') })
  }
}


@Component
export struct WebTab {
  @State @Watch('changeDialogClose') dialogClose: boolean = true; // 输入法弹窗是否关闭
  @State @Watch('changeDialogOpen') dialogOpen: boolean = false; // 输入法弹窗是否开启
  @State @Watch('setInput') inputValue: string = ''; // 输入框内容
  @Link browser: Browser;
  @State curKeyboardType: EKeyboardType = EKeyboardType.NUMERIC; // 当前键盘类型，默认为数字键盘
  @State items: IKeyAttribute[] = numericKeyData; // 键盘按键数组
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomKeyboard({
      dialogClose: this.dialogClose,
      dialogOpen: this.dialogOpen,
      items: this.items,
      inputValue: this.inputValue,
      curKeyboardType: this.curKeyboardType,
      onKeyboardEvent: this.onKeyboardEvent,
      closeDialog: this.closeDialog,
    }),
    cancel: () => {
      this.dialogClose = true;
      this.dialogOpen = false;
    },
    isModal: false,
    alignment: DialogAlignment.Bottom,
    customStyle: true
  });
  webKeyboardObj: WebKeyboardObj = {
    // 点击登录按钮事件
    login: () => {
      promptAction.showToast({
        message: $r('app.string.custom_keyboard_to_h5_login_button'),
        duration: 2000
      });
      this.closeDialog();
    },
    // 输入法弹窗弹出事件
    openDialog: (value: string) => {
      this.dialogOpen = true;
      this.dialogClose = false;
      this.inputValue = value;
    }
  }

  aboutToDisappear(): void {
    this.closeDialog();
  }

  // 关闭弹窗
  closeDialog() {
    this.dialogClose = true;
    this.dialogOpen = false;
  }

  // 监听dialogClose触发关闭弹窗事件
  changeDialogClose() {
    if (this.dialogClose) {
      this.dialogController?.close();
    }
  }

  // 监听dialogOpen触发开启弹窗事件
  changeDialogOpen() {
    if (this.dialogOpen) {
      this.dialogController?.open();
    }
  }

  // 监听inputValue将输入内容映射到h5页面的input中
  setInput() {
    this.browser.webController.runJavaScript(`setInput('${this.inputValue}')`);
  }

  // 键盘按键事件响应函数
  onKeyboardEvent(item: IKeyAttribute) {
    switch (item.type) {
      // 输入类型，更新输入内容
      case EKeyType.INPUT:
        this.inputValue += item.value;
        break;
      // 删除一个已输入的末尾字符
      case EKeyType.DELETE:
        this.inputValue = this.inputValue.slice(0, -1);
        break;
      // 切换数字字符键盘
      case EKeyType.NUMERIC:
        if (this.curKeyboardType !== EKeyboardType.NUMERIC) {
          this.curKeyboardType = EKeyboardType.NUMERIC;
          this.items = numericKeyData;
        }
        break;
      // 切换大小写
      case EKeyType.CAPSLOCK:
        if (this.curKeyboardType === EKeyboardType.LOWERCASE) {
          // 切换大写字母键盘
          this.curKeyboardType = EKeyboardType.UPPERCASE;
          this.items = upperCaseKeyData;
        } else {
          // 切换小写字母键盘
          this.curKeyboardType = EKeyboardType.LOWERCASE;
          this.items = lowerCaseKeyData;
        }
        break;
      // 切换特殊字符键盘
      case EKeyType.SPECIAL:
        if (this.curKeyboardType !== EKeyboardType.SPECIAL) {
          this.curKeyboardType = EKeyboardType.SPECIAL;
          this.items = specialKeyData;
        }
        break;
      default:
        logger.info('Sorry, we are out of input type.')
    }
  }

  build() {
    Web({
      src: $rawfile('custom_keyboard_to_h5_phone.html'),
      controller: this.browser.webController
    })
      .layoutWeight(1)
      .domStorageAccess(true)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .onPageEnd((event) => {
        this.browser.webController.runJavaScript('adapterDevice()');
        this.registerFunc(this.browser); // 注册方法到h5的js中
        if (event && event.url.startsWith('http')) {
          this.browser.inputValue = event.url;
        } else {
          this.browser.inputValue = '';
        }
      })
      .onProgressChange((event) => {
        if (!event) {
          return;
        }
        // 进度条进度处理
        this.browser.progress = event.newProgress;
        if (this.browser.progress === BROWSER_PROGRESS) {
          this.browser.hideProgress = true;
        } else {
          this.browser.hideProgress = false;
        }
      })
  }

  // 注册方法到h5的js中
  registerFunc(browser: Browser) {
    if (!browser.isRegistered) {
      browser.webController.registerJavaScriptProxy(this.webKeyboardObj, 'etsObj',
        ['login', 'openDialog'])
      browser.isRegistered = true;
      browser.webController.refresh();
    }
  }
}