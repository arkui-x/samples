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

import { ConfigurationConstant } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction, router } from '@kit.ArkUI';
import { Authentication } from '@ohos/authentication';
import { Logger, UserAccount, UserTypeEnum, WindowUtil } from '@ohos/utils';
import { ACCOUNT_LIST, Constants } from '../constants/LoginConstants';
import { InputAreaView } from '../components/InputAreaView';
import { AccountModel } from '../model/AccountModel';

const TAG: string = '[LoginPage]';
const LOGIN_PAGE_IMAGE_GRAYSCALE: number = 0.5;

@Entry({ routeName: 'LoginPage' })
@Component
struct LoginPage {
  @State @Watch('LoadingEffect') isSigning: boolean = false;
  @State username: string = ACCOUNT_LIST[0];
  @State signingContent: Resource = $r('app.string.signing_content', '');
  @State curIndex: number = ACCOUNT_LIST.indexOf(this.username);
  @State password: string = Constants.INIT_PASSWORD;
  private accountModel: AccountModel = AccountModel.getInstance();
  private userAccount: UserAccount = new UserAccount();
  private backgroundImg: Resource =
    router.getParams() ? (router.getParams() as Record<string, Resource>)['bgImg'] : $r('app.media.ic_splash3');
  private timer: number = 0;

  onPageShow() {
    Logger.info(TAG, 'onPageShow');
    WindowUtil.getWindowUtil().updateStatusBarColor(getContext(this), true);
  }

  onPageHide() {
    WindowUtil.getWindowUtil().updateStatusBarColor(getContext(this),
      AppStorage.get('currentColorMode') === ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
  }

  LoadingEffect(): void {
    let count = 1;
    const contentList = ['  ', '. ', '..'];
    this.signingContent = $r('app.string.signing_content', contentList[count]);
    if (this.isSigning) {
      this.timer = setInterval(() => {
        count++;
        count %= 3;
        this.signingContent = $r('app.string.signing_content', contentList[count]);
      }, Constants.SIGNING_CONTEXT_DURATION);
    } else {
      clearTimeout(this.timer);
      this.signingContent = $r('app.string.signing_content', '');
    }
  }

  showLoginFiledToast() {
    promptAction.showDialog({
      title: $r('app.string.failed_msg_title'),
      message: $r('app.string.login_failed_msg'),
    })
  }

  login(): void {
    if (this.userAccount.userType === UserTypeEnum.HMOS && (this.userAccount.username.trim() === '') ||
      (this.password.trim() === '')) {
      promptAction.showDialog({
        title: $r('app.string.failed_msg_title'),
        message: $r('app.string.account_password_empty')
      })
      return;
    }
    this.isSigning = true;
    this.accountModel.clickLogin(this.userAccount).then((user: UserAccount | null) => {
      this.isSigning = false;
      if (user !== null) {
        AppStorage.setOrCreate('user', user);
        AppStorage.setOrCreate('userId', user.id);
        AppStorage.setOrCreate('isLogged', true);
        router.replaceNamedRoute({
          name: 'ThemeSettingPage',
          params: {
            firstTopic: true
          }
        });
      } else {
        promptAction.showDialog({
          title: $r('app.string.failed_msg_title'),
          message: $r('app.string.user_exception')
        })
      }
    }).catch((error: BusinessError) => {
      this.isSigning = false;
      Logger.error(TAG, `login failed err=${JSON.stringify(error)}`);
    })
  }

  build() {
    Stack() {
      Image(this.backgroundImg)
        .height(Constants.FULL_SCREEN)
        .width(Constants.FULL_SCREEN)
        .grayscale(LOGIN_PAGE_IMAGE_GRAYSCALE)
      Scroll() {
        GridRow({
          columns: { sm: Constants.COLUMN_SM, md: Constants.COLUMN_MD, lg: Constants.COLUMN_LG }
        }) {
          GridCol({
            span: { sm: Constants.SPAN_SM, md: Constants.SPAN_MD, lg: Constants.SPAN_LG },
            offset: { sm: Constants.OFFSET_SM, md: Constants.OFFSET_MD, lg: Constants.OFFSET_LG }
          }) {
            Column() {
              Image($r('app.media.ic_portrait'))
                .height($r('app.float.portrait_height'))
                .width($r('app.float.portrait_width'))
                .opacity(Constants.PORTRAIT_OPACITY)
                .margin({ top: $r('app.float.portrait_margin_top') })
              Text($r('app.string.account'))
                .fontColor($r('app.color.color_white'))
                .fontSize($r('app.float.account_text_size'))
                .margin({ top: $r('app.float.md_padding_margin') })
                .fontWeight(Constants.LOGIN_TITLE_FONT_WEIGHT)
                .height($r('app.float.account_height'))
              Text($r('app.string.account_description'))
                .fontColor($r('app.color.description_font_color'))
                .fontSize($r('app.float.login_context_font_size'))
                .fontWeight(FontWeight.Normal)
                .height($r('app.float.login_context_height'))
              InputAreaView({
                username: this.username,
                password: this.password,
                curIndex: this.curIndex
              })

              Button({
                type: ButtonType.Normal,
                stateEffect: true
              }) {
                Row() {
                  Text((this.isSigning && this.userAccount.userType === UserTypeEnum.HMOS) ?
                  this.signingContent : $r('app.string.login_button'))
                    .fontSize($r('app.float.login_text_font_size'))
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.button_background_color'))
                    .textAlign((this.isSigning && this.userAccount.userType === UserTypeEnum.HMOS) ?
                    TextAlign.Start :
                    TextAlign.Center)
                    .width($r('app.float.signing_row_width'))
                }
                .justifyContent(FlexAlign.Center)
                .alignItems(VerticalAlign.Center)
              }
              .borderRadius($r('app.float.button_border_radius'))
              .width(Constants.FULL_SCREEN)
              .backgroundColor($r('app.color.color_white'))
              .margin({ top: $r('app.float.button_margin_top') })
              .height($r('app.float.button_height'))
              .onClick(() => {
                this.userAccount = new UserAccount();
                this.userAccount.userType = UserTypeEnum.HMOS;
                this.userAccount.password = this.password;
                this.userAccount.username = this.username
                this.login();
              })

              Button() {
                Row() {
                  Image($r('app.media.ic_hw_white'))
                    .width($r('app.float.normal_icon_size'))
                    .height($r('app.float.normal_icon_size'))
                    .margin({ right: $r('app.float.sm_padding_margin') })
                  Text((this.isSigning && this.userAccount.userType === UserTypeEnum.HUAWEI) ?
                  this.signingContent : $r('app.string.hw_button'))
                    .fontSize($r('app.float.login_text_font_size'))
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.color_white'))
                }
              }
              .borderRadius($r('app.float.button_border_radius'))
              .width(Constants.FULL_SCREEN)
              .backgroundColor($r('sys.color.ohos_id_color_emphasize'))
              .height($r('app.float.button_height'))
              .margin({ top: $r('app.float.md_padding_margin') })
              .onClick(() => {
                this.userAccount = new UserAccount();
                Authentication.getAuthentication().getHWAuthorization().then((data: UserAccount) => {
                  this.userAccount.userType = data.userType;
                  this.userAccount.portrait = data.portrait;
                  this.userAccount.nickname = data.nickname;
                  this.userAccount.unionId = data.unionId;
                  this.login();
                }).catch((error: Resource) => {
                  promptAction.showDialog({
                    title: $r('app.string.failed_msg_title'),
                    message: error
                  })
                })
              })

              Blank()
                .height($r('app.float.button_height'))
              Row() {
                Text($r('app.string.privacy_statement'))
                  .grayTextStyle()

                Text($r('app.string.verification_code_login'))
                  .grayTextStyle()
              }
              .width(Constants.FULL_SCREEN)
              .margin({ bottom: $r('app.float.bottom_row_margin_bottom') })
            }
            .width(Constants.FULL_SCREEN)
            .padding({
              left: $r('app.float.md_padding_margin'),
              right: $r('app.float.md_padding_margin')
            })
          }
        }
      }.scrollBar(BarState.Off)
    }
    .width(Constants.FULL_SCREEN)
    .height(Constants.FULL_SCREEN)
  }
}

@Extend(Text)
function grayTextStyle() {
  .fontSize($r('app.float.normal_text_size'))
  .fontColor($r('app.color.input_background_color'))
  .layoutWeight(1)
  .textAlign(TextAlign.Center)
}