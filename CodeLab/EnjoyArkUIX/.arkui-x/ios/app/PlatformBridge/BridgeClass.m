/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
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

#import "BridgeClass.h"

@implementation BridgeClass

- (NSString *)getHelloArkUI:(id)param {
    return [NSString stringWithFormat:@"Hello ArkUI! %@", param];
}

- (NSString *)methodOfPlatform:(id)param {
    // 构造JS侧方法描述对象实例, jsMethodName需根据实际情况调整。
    MethodData * method = [[MethodData alloc] initMethodWithName:@"methodOfPlatform" parameter:@[param]];
    [self callMethod:method];
    return [NSString stringWithFormat:@"Method of Platform call successful. %@", param];
}

#pragma mark - IMessageListener ArkUI侧发送的消息代理实现
/**
  *  Arkui测调用sendMessage 发送消息到IOS测，将会触发次方法的回调
  *  @param data Arkui 传递过来的数据
  *   return 返回值传递传递给Arkui测
*/
- (NSString*)onMessage:(id)data {
    NSLog(@"onMessage data: %@", data);
    return  [NSString stringWithFormat:@"PlatformBridge Successfully receives the TsMessage. %@", data];
}

/**
 * iOS 通过sendMessage 方法发送消息到Arkui, Arkui成功接到消息后回调此方法传递结果
 * @param data Arkui 返回的信息
*/
- (void)onMessageResponse:(id)data {
    NSLog(@"onMessageResponse data: %@", data);
}

#pragma mark - IMethodResult 用于监听平台侧调用ArkUI侧注册的方法的执行情况
/**
  *  ArkUI侧调用unRegisterMethod方法时将触发该接口，用于通知平台侧事件被注销了。
  *  @param methodName ArkUI侧方法的名称
  *  @param resultValue ResultValue 类 ，并将ArkUI侧方法的返回值传递给平台侧
*/
- (void)onSuccess:(nonnull NSString *)methodName resultValue:(nonnull id)resultValue {
    if (resultValue) {
        NSLog(@"bridge onSuccess data: %@", resultValue);
        [self sendMessage:[NSString stringWithFormat:@"PlatformBridge successfully calls  method of TS, and the return value is %@", resultValue]];
    }else {
        NSLog(@"bridge return data is null, call Success");
        [self sendMessage:@"PlatformBridge successfully calls method of TS, The method is of type void"];
    }
}

/**
  *  平台侧调用ArkUI侧定义方法时，如果出错则触发该接口，并将出错信息返回平台侧。具体错误码查看ResultValue类中错误码或者接口文档
  *  @param methodName ArkUI侧方法的名称
  *  @param errorCode 错误码
  *  @param errorMessage 错误信息
*/
- (void)onError:(nonnull NSString *)methodName errorCode:(ErrorCode)errorCode errorMessage:(nonnull NSString *)errorMessage {
    NSLog(@"Bridge: onError: %@ errorCode: %d errorMessage: %@",methodName, errorCode, errorMessage);
}

/**
  *  ArkUI侧调用unRegisterMethod方法时将触发该接口，用于通知平台侧事件被注销了。
  *  @param methodName ArkUI侧方法的名称
*/
- (void)onMethodCancel:(nonnull NSString *)methodName {
    NSLog(@"Bridge: onMethodCancel");
}

@end
