import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@ohos.base';
import { logger } from '../../utils/Logger';
import { PlatformInfo, PlatformTypeEnum, BridgeUtil } from 'utils';

const SPACE_EIGHTEEN = 18; // 子元素的间距
const FONT_WEIGHT = 600; // 字体粗细

// 定义短信结构类
export class Contact {
  contactsName: string; // 接收人的名字
  telephone: string; // 接收人的号码

  constructor(contactsName: string, telephone: string) {
    this.contactsName = contactsName;
    this.telephone = telephone;
  }
}

/**
 * 功能描述: 本示例介绍如何在应用中调起系统短信，通过startAbility接口中的指定号码并调起系统的发送短信页面
 *
 * 推荐场景: 发送短信
 *
 * 核心组件:
 * 1. MessageView.content
 *
 * 实现步骤:
 * 1、本案例通过startAbility接口中的指定号码并调起系统的发送短信页面。
 * 2、点击页面"快捷发送短信"按钮时，通过指定的abilityName和bundleName拉起短信服务，并通过页面传入的want参数中填入短信内容与短信接收人的号码。
 * 3、从而实现在应用内实现跳转到短信编辑的功能，并且携带编辑内容和收件人号码。
 */
@Component
export struct MessageView {
  // 短信内容
  @State msg: string = '2618';
  // 短信接收人的号码
  @State number: string = '103981630163222';

  /**
   * 弹窗函数
   */
  showToast() {
    promptAction.showToast({
      message: $r('app.string.send_message_toast')
    })
  }

  build() {
    Column() {
      // 标题
      this.title()
      // 内容
      this.content()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }

  // 标题
  @Builder
  title() {
    Column({ space: SPACE_EIGHTEEN }) {
      Text($r('app.string.send_message_text1'))
        .fontSize($r('app.integer.send_message_text_font_size'))
        .fontWeight(FONT_WEIGHT)
        .fontColor(Color.Black)
      Text() {
        Span($r('app.string.send_message_span1'))
          .fontColor($r('app.color.send_message_font'))
          .fontSize($r('app.integer.send_message_span1_font_size'))
          .opacity(0.5)
        Span($r('app.string.send_message_span2'))
          .fontColor(Color.Black)
          .fontSize($r('app.integer.send_message_span2_font_size'))
          .opacity(0.5)
        Span($r('app.string.send_message_span3'))
          .fontColor($r('app.color.send_message_font'))
          .fontSize($r('app.integer.send_message_span1_font_size'))
          .opacity(0.5)
      }
    }
    .alignItems(HorizontalAlign.Center)
    .margin({ top: $r('app.integer.send_message_col_title_margin_top') })
  }

  // TODO:知识点:通过调用元能力startAbility接口指定号码并跳转到发送短信页面
  gotoMessage(contactInfo: Array<Contact>, msg: string) {
    let context = getContext(this) as common.UIAbilityContext;
    // 通过指定的abilityName和bundleName拉起短信服务，并通过页面传入的want参数中填入短信内容与短信接收人的号码。
    let want: Want = {
      bundleName: 'com.ohos.mms',
      abilityName: 'com.ohos.mms.MainAbility',
      parameters: {
        contactObjects: JSON.stringify(contactInfo),
        pageFlag: 'conversation',
        content: msg // 这里填写短信内容
      },
    };
    context.startAbilityForResult(want).then((data) => {
      logger.info(`Success` + JSON.stringify(data));
    }).catch((err: BusinessError) => {
      logger.error(`Failed to startAbility. Code: ${err.code}, message: ${err.message}`);
    });
  }

  // 标题
  @Builder
  content() {
    Column({ space: SPACE_EIGHTEEN }) {
      Row() {
        Text($r('app.string.send_message_edit_message'))
          .fontColor($r('app.color.send_message_font'))
          .fontSize($r('app.integer.send_message_text1_font_size'))
        Text(this.msg)
          .fontWeight(FontWeight.Bold)
          .margin({ left: $r('app.integer.send_message_text1_margin_left') })
          .backgroundColor(Color.Transparent)
          .width($r('app.string.send_message_msg_width'))
          .onClick(() => {
            promptAction.showToast({ message: $r('app.string.send_message_prompt_message') });
          })
      }
      .width($r('app.string.send_message_com_width'))

      Divider()
        .color($r('app.color.send_message_divider'))
        .strokeWidth(1)
        .width($r('app.string.send_message_com_width'))

      Row() {
        Text($r('app.string.send_message_send_message_to'))
          .fontColor($r('app.color.send_message_font'))
          .fontSize($r('app.integer.send_message_text1_font_size'))
        Text(this.number)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(Color.Transparent)
          .width($r('app.string.send_message_msg_width'))
          .margin({ left: $r('app.integer.send_message_number_margin_left') })
          .onClick(() => {
            promptAction.showToast({ message: $r('app.string.send_message_prompt_message') });
          })
      }
      .width($r('app.string.send_message_com_width'))

      Divider()
        .color($r('app.color.send_message_divider'))
        .strokeWidth(1)
        .width($r('app.string.send_message_com_width'))

      Row() {
        Text($r('app.string.send_message_send_message_question'))
          .fontColor($r('app.color.send_message_font'))
          .fontSize($r('app.integer.send_message_question_font_size'))
          .onClick(() => {
            this.showToast();
          })
        Blank()
        Text($r('app.string.send_message_text_send_message_fee'))
          .fontColor("#E1DFE4")
          .fontSize($r('app.integer.send_message_fee_font_size'))
          .onClick(() => {
            this.showToast();
          })
      }
      .width($r('app.string.send_message_com_width'))

      Button($r('app.string.send_message_quickly_sent_message'))
        .fontColor(Color.White)
        .borderRadius(35)
        .type(ButtonType.Normal)
        .backgroundColor("#E72A2B")
        .onClick(() => {
          let contactInfo: Array<Contact> = [];
          let number = this.number;
          let msg = this.msg;
          // 这里填入发送的联系人名字和号码
          contactInfo.push(new Contact("xx安全团队", number))
          // 点击时，将短信接收人的号码与短信内容传参给系统短信
          if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
            // 点击时，将短信接收人的号码与短信内容传参给系统短信
            this.gotoMessage(contactInfo, msg);
          } else if (PlatformInfo.getPlatform() === PlatformTypeEnum.ANDROID) {
            BridgeUtil.getInstance().startSms('Android');
          } else if (PlatformInfo.getPlatform() === PlatformTypeEnum.IOS) {
            BridgeUtil.getInstance().startSms('iOS')
          }
        })
        .width($r('app.string.send_message_btn_width'))
        .height($r('app.integer.send_message_btn_height'))
        .margin({
          left: $r('app.integer.send_message_btn_margin_left'),
          right: $r('app.integer.send_message_btn_margin_left'),
          bottom: $r('app.integer.send_message_btn_margin_bottom'),
          top: $r('app.integer.send_message_btn_margin_top')
        })
        .id('sendMessage')

      Button($r('app.string.send_message_already_sent'))
        .fontColor(Color.Black)
        .borderRadius(35)
        .type(ButtonType.Normal)
        .backgroundColor($r('app.color.send_message_already_sent'))
        .onClick(() => {
          this.showToast();
        })
        .width($r('app.string.send_message_btn_width'))
        .height($r('app.integer.send_message_btn_height'))
        .margin({ bottom: $r('app.integer.send_message_already_sent_btn_margin_top') })
    }
    .alignItems(HorizontalAlign.Center)
    .margin({ top: $r('app.integer.send_message_col_margin_top') })
  }
}