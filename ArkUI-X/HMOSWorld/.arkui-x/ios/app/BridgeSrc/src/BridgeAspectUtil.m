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

#import "BridgeAspectUtil.h"

@implementation BridgeAspectUtil

- (NSString*)getVersionName {
    NSString *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

- (void)exit{
    NSLog(@"Warning app will force quit.");
    exit(0);
}

- (NSString*)onMessage:(id)data {
    NSLog(@"BridgeAspectUtil onMessage data: %@", data);
    return  [NSString stringWithFormat:@"BridgeAspectUtil Successfully receives the TsMessage. %@", data];
}

- (void)onMessageResponse:(id)data {
    NSLog(@"BridgeAspectUtil onMessageResponse data: %@", data);
}

- (void)onSuccess:(nonnull NSString *)methodName resultValue:(nonnull id)resultValue {
    if (resultValue) {
        NSLog(@"BridgeAspectUtil bridge onSuccess data: %@", resultValue);
        [self sendMessage:[NSString stringWithFormat:@"BridgeAspectUtil successfully calls  method of TS, and the return value is %@", resultValue]];
    }else {
        NSLog(@"BridgeAspectUtil bridge return data is null, call Success");
        [self sendMessage:@"BridgeAspectUtil successfully calls method of TS, The method is of type void"];
    }
}

- (void)onError:(nonnull NSString *)methodName errorCode:(ErrorCode)errorCode errorMessage:(nonnull NSString *)errorMessage {
    NSLog(@"BridgeAspectUtil Bridge: onError: %@ errorCode: %d errorMessage: %@",methodName, errorCode, errorMessage);
}

- (void)onMethodCancel:(nonnull NSString *)methodName {
    NSLog(@"BridgeAspectUtil Bridge: onMethodCancel");
}
@end
