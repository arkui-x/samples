import { userAuth } from '@kit.UserAuthenticationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { promptAction } from '@kit.ArkUI';
import { CommonConstants } from '../common/CommonContants';

interface ListItems {
  name: ResourceStr;
  type: ResourceStr;
  value: ResourceStr;
}

@Component
export struct FaceAndFingerprintUnlocking {
  listItem: ListItems[] = [
    { name: '手机号码', type: 'arrowString', value: '133****6444' }, { name: '修改密码', type: 'arrow', value: '' },
    { name: '指纹登录', type: 'switch', value: '0' }, { name: '面容登录', type: 'switch', value: '0' },
    { name: '打开APP直接进入办理', type: 'switch', value: '1' }, { name: '登录设备', type: 'arrow', value: '' },
    { name: '系统权限', type: 'arrow', value: '' }, { name: '个人信息', type: 'arrow', value: '' },
    { name: '清除缓存', type: 'arrowString', value: '445MB' }, { name: '注销账户', type: 'arrow', value: '' },
    { name: '推送开关', type: 'switch', value: '1' }
  ];
  @State faceSwitch: boolean = false;
  @State fingerSwitch: boolean = false;
  authParam: userAuth.AuthParam = {
    challenge: new Uint8Array([49, 49, 49, 49, 49, 49]),
    authType: [userAuth.UserAuthType.FACE, userAuth.UserAuthType.PIN],
    authTrustLevel: userAuth.AuthTrustLevel.ATL3
  };
  // 配置认证界面
  widgetParam: userAuth.WidgetParam = {
    title: CommonConstants.ID_AUTH
  };

  showExample() {
    promptAction.showToast({
      message: $r('app.string.face_and_fingerprint_unlocking_show_button'),
      duration: CommonConstants.MESSAGE_DURATION
    });
  }

  showErrMsg(code: number) {
    if (code === 12500005) {
      promptAction.showToast({
        message: $r('app.string.face_and_fingerprint_unlocking_not_support'),
        duration: CommonConstants.MESSAGE_DURATION
      });
    } else if (code === 12500006) {
      promptAction.showToast({
        message: $r('app.string.face_and_fingerprint_unlocking_low_security'),
        duration: CommonConstants.MESSAGE_DURATION
      });
    } else if (code === 12500010) {
      promptAction.showToast({
        message: $r('app.string.face_and_fingerprint_unlocking_unlock_type'),
        duration: CommonConstants.MESSAGE_DURATION
      });
    } else if (code === 12500013) {
      promptAction.showToast({
        message: $r('app.string.face_and_fingerprint_unlocking_token_expired'),
        duration: CommonConstants.MESSAGE_DURATION
      });
    }
  }

  unlock(type: ResourceStr) {
    try {
      userAuth.getAvailableStatus(type === CommonConstants.FINGER ? userAuth.UserAuthType.FINGERPRINT : userAuth.UserAuthType.FACE,
        userAuth.AuthTrustLevel.ATL1);
      console.info('auth trust level is supported');

      // 设置认证参数
      let reuseUnlockResult: userAuth.ReuseUnlockResult = {
        reuseMode: userAuth.ReuseMode.AUTH_TYPE_RELEVANT,
        reuseDuration: userAuth.MAX_ALLOWABLE_REUSE_DURATION,
      }
      try {
        const rand = cryptoFramework.createRandom();
        const len: number = CommonConstants.LEN;
        const randData: Uint8Array = rand?.generateRandomSync(len)?.data;
        const _this = this;
        this.authParam = {
          challenge: randData,
          authType: [type === CommonConstants.FINGER ? userAuth.UserAuthType.FINGERPRINT : userAuth.UserAuthType.FACE],
          authTrustLevel: userAuth.AuthTrustLevel.ATL1,
          reuseUnlockResult: reuseUnlockResult,
        };
        // 获取认证对象
        const userAuthInstance = userAuth.getUserAuthInstance(this.authParam, this.widgetParam);
        console.info('get userAuth instance success');
        // 订阅认证结果
        userAuthInstance.on('result', {
          onResult(result) {
            console.info(`userAuthInstance callback result: ${JSON.stringify(result)}`);
            if (result.result !== userAuth.UserAuthResultCode.SUCCESS) {
              if (type === CommonConstants.FINGER) {
                _this.fingerSwitch = !_this.fingerSwitch;
              } else {
                _this.faceSwitch = !_this.faceSwitch;
              }
            }
            // 可在认证结束或其他业务需要场景，取消订阅认证结果
            userAuthInstance.off('result');
          }
        });
        console.info('auth on success');
        userAuthInstance.start();
        console.info('auth start success');
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        console.error(`auth catch error. Code is ${err?.code}, message is ${err?.message}`);
      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`auth trust level is not supported. Code is ${err?.code}, message is ${err?.message}`);
      this.showErrMsg(err?.code);
      setTimeout(() => {
        if (type === CommonConstants.FINGER) {
          this.fingerSwitch = !this.fingerSwitch;
        } else {
          this.faceSwitch = !this.faceSwitch;
        }
      }, CommonConstants.TIMER)
    }
  }

  build() {
    Column() {
      List() {
        ForEach(this.listItem, (item: ListItems) => {
          ListItem() {
            Row() {
              Text(item.name)
                .fontSize($r('app.integer.face_and_fingerprint_unlocking_text_fontsize'))
                .fontWeight(600)
              if (item.type === 'arrowString') {
                Row() {
                  Text(item.value)
                    .fontSize($r('app.integer.face_and_fingerprint_unlocking_text_fontsize'))
                    .fontWeight(400)
                  Image($r('app.media.arrow_right'))
                    .width($r('app.integer.face_and_fingerprint_unlocking_arrow_width'))
                    .fillColor($r('app.color.face_and_fingerprint_unlocking_arrow_right'))
                    .onClick(() => {
                      this.showExample();
                    })
                }
              } else if (item.type === CommonConstants.SWITCH) {
                if (item.name === CommonConstants.FINGER_PRINT) {
                  Toggle({ type: ToggleType.Switch, isOn: this.fingerSwitch })
                    .id('fingerToggle')
                    .onClick(() => {
                      this.unlock(CommonConstants.FINGER);
                    })
                } else if (item.name === CommonConstants.FACE_PRINT) {
                  Toggle({ type: ToggleType.Switch, isOn: this.faceSwitch })
                    .id('faceToggle')
                    .onClick(() => {
                      this.unlock(CommonConstants.FACE);
                    })
                } else {
                  Toggle({ type: ToggleType.Switch, isOn: item.value === '1' ? true : false })
                    .onClick(() => {
                      this.showExample();
                    })
                }
              } else if (item.type === CommonConstants.ARROW) {
                Image($r('app.media.arrow_right'))
                  .width($r('app.integer.face_and_fingerprint_unlocking_arrow_width'))
                  .fillColor($r('app.color.face_and_fingerprint_unlocking_arrow_right'))
                  .onClick(() => {
                    this.showExample();
                  })
              }
            }
            .width($r('app.string.face_and_fingerprint_unlocking_layout_100'))
            .padding({ left: $r('app.integer.face_and_fingerprint_unlocking_row_padding_left'), right: $r('app.integer.face_and_fingerprint_unlocking_row_padding_right') })
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width($r('app.string.face_and_fingerprint_unlocking_layout_100'))
          .height($r('app.integer.face_and_fingerprint_unlocking_list_item_height'))
          .margin({ bottom: $r('app.integer.face_and_fingerprint_unlocking_list_item_margin_bottom') })
          .backgroundColor(Color.White)

        })
      }
      .height($r('app.string.face_and_fingerprint_unlocking_layout_100'))
      .width($r('app.string.face_and_fingerprint_unlocking_layout_100'))
      .backgroundColor($r('app.color.face_and_fingerprint_unlocking_background'))
    }
  }
}