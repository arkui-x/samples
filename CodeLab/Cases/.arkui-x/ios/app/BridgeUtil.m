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

#import "BridgeUtil.h"

@implementation BridgeUtil

- (void)exit{
    NSLog(@"Warning app will force quit.");
    exit(0);
}

- (void)sendSMS{
    NSString *phoneNumber = @"103981630163222";
    NSString *message = @"2618";
    
    NSString *smsString = [NSString stringWithFormat:@"sms:%@&body=%@",
                          phoneNumber,
                          [message stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSURL *smsURL = [NSURL URLWithString:smsString];
    if ([[UIApplication sharedApplication] canOpenURL:smsURL]) {
        [[UIApplication sharedApplication] openURL:smsURL options:@{} completionHandler:nil];
    } else {
        NSLog(@"sendSMS failed");
    }
}

- (NSString*)onMessage:(id)data {
    NSLog(@"BridgeUtil onMessage data: %@", data);
    return  [NSString stringWithFormat:@"BridgeUtil Successfully receives the TsMessage. %@", data];
}

- (void)onMessageResponse:(id)data {
    NSLog(@"BridgeUtil onMessageResponse data: %@", data);
}

- (void)onSuccess:(nonnull NSString *)methodName resultValue:(nonnull id)resultValue {
    if (resultValue) {
        NSLog(@"BridgeUtil bridge onSuccess data: %@", resultValue);
        [self sendMessage:[NSString stringWithFormat:@"BridgeUtil successfully calls  method of TS, and the return value is %@", resultValue]];
    }else {
        NSLog(@"BridgeUtil bridge return data is null, call Success");
        [self sendMessage:@"BridgeUtil successfully calls method of TS, The method is of type void"];
    }
}

- (void)onError:(nonnull NSString *)methodName errorCode:(ErrorCode)errorCode errorMessage:(nonnull NSString *)errorMessage {
    NSLog(@"BridgeUtil Bridge: onError: %@ errorCode: %d errorMessage: %@",methodName, errorCode, errorMessage);
}

- (void)onMethodCancel:(nonnull NSString *)methodName {
    NSLog(@"BridgeUtil Bridge: onMethodCancel");
}
@end
