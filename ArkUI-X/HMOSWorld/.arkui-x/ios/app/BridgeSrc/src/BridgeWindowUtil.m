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

#import "BridgeWindowUtil.h"

@implementation BridgeWindowUtil

- (void)updateStatusBarColor:(BOOL)isDark {
    if (UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else if (UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    } else {
        NSLog(@"BridgeWindowUtil can not set");
    }
}

- (NSString*)onMessage:(id)data {
    NSLog(@"BridgeWindowUtil onMessage data: %@", data);
    return [NSString stringWithFormat:@"BridgeWindowUtil Successfully receives the TsMessage. %@", data];
}

- (void)onMessageResponse:(id)data {
    NSLog(@"BridgeWindowUtil onMessageResponse data: %@", data);
}

- (void)onSuccess:(nonnull NSString *)methodName resultValue:(nonnull id)resultValue {
    if (resultValue) {
        NSLog(@"BridgeWindowUtil bridge onSuccess data: %@", resultValue);
        [self sendMessage:[NSString stringWithFormat:@"BridgeWindowUtil successfully calls  method of TS, and the return value is %@", resultValue]];
    }else {
        NSLog(@"BridgeWindowUtil bridge return data is null, call Success");
        [self sendMessage:@"BridgeWindowUtil successfully calls method of TS, The method is of type void"];
    }
}

- (void)onError:(nonnull NSString *)methodName errorCode:(ErrorCode)errorCode errorMessage:(nonnull NSString *)errorMessage {
    NSLog(@"BridgeWindowUtil Bridge: onError: %@ errorCode: %d errorMessage: %@",methodName, errorCode, errorMessage);
}

- (void)onMethodCancel:(nonnull NSString *)methodName {
    NSLog(@"BridgeWindowUtil Bridge: onMethodCancel");
}
@end
