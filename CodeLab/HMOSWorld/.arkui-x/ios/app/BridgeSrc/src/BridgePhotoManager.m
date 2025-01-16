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

#import "BridgePhotoManager.h"

@implementation BridgePhotoManager

- (void)copyToSandbox:(NSString *)uri andname:(NSString *)name{
    NSLog(@"BridgePhotoManager copyToSandbox fileURL is : %@", uri);
    NSLog(@"BridgePhotoManager copyToSandbox name is : %@", name);
    uri = [uri stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    UIImage *image = [UIImage imageWithContentsOfFile:uri];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *combinedString = [@"files/" stringByAppendingString:name];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:combinedString];
    NSData *imageData = UIImagePNGRepresentation(image);
    BOOL success = [imageData writeToFile:imagePath atomically:YES];
    if (success) {
        NSLog(@"BridgePhotoManager copyToSandbox success，path: %@", imagePath);
    } else {
        NSLog(@"BridgePhotoManager copyToSandbox failed");
    }
}

- (NSString*)onMessage:(id)data {
    NSLog(@"BridgePhotoManager onMessage data: %@", data);
    return  [NSString stringWithFormat:@"BridgePhotoManager Successfully receives the TsMessage. %@", data];
}

- (void)onMessageResponse:(id)data {
    NSLog(@"BridgePhotoManager onMessageResponse data: %@", data);
}

- (void)onSuccess:(nonnull NSString *)methodName resultValue:(nonnull id)resultValue {
    if (resultValue) {
        NSLog(@"BridgePhotoManager bridge onSuccess data: %@", resultValue);
        [self sendMessage:[NSString stringWithFormat:@"BridgePhotoManager successfully calls  method of TS, and the return value is %@", resultValue]];
    }else {
        NSLog(@"BridgePhotoManager bridge return data is null, call Success");
        [self sendMessage:@"BridgePhotoManager successfully calls method of TS, The method is of type void"];
    }
}

- (void)onError:(nonnull NSString *)methodName errorCode:(ErrorCode)errorCode errorMessage:(nonnull NSString *)errorMessage {
    NSLog(@"BridgePhotoManager Bridge: onError: %@ errorCode: %d errorMessage: %@",methodName, errorCode, errorMessage);
}

- (void)onMethodCancel:(nonnull NSString *)methodName {
    NSLog(@"BridgePhotoManager Bridge: onMethodCancel");
}
@end
