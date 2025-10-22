/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

#import "EntryEntryAbilityViewController.h"
#import "NativeAbilityViewController.h"
#import "BridgeManager.h"

@interface EntryEntryAbilityViewController ()<IMethodResult,IMessageListener>

@end

@implementation EntryEntryAbilityViewController

- (instancetype)initWithInstanceName:(NSString *)instanceName {
    self = [super initWithInstanceName:instanceName];
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    BridgeManager *bridgeManager = [BridgeManager sharedInstance];
    BridgeUtil *bridgeForJson = [bridgeManager getBridgeWithName:@"BridgeJsonObject" bridgeType:JSON_TYPE];
    bridgeForJson.methodResult = self;
    bridgeForJson.messageListener = self;
    BridgeUtil *bridgeForBinary = [bridgeManager getBridgeWithName:@"BridgeBinaryObject" bridgeType:BINARY_TYPE];
    bridgeForBinary.methodResult = self;
    bridgeForBinary.messageListener = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (NSString*)onMessage:(id)data {
    NSLog(@"[Native]:: IMethodResult onMessage called; data is ( %@ )", data);
    return  [NSString stringWithFormat:@"这里是<Native>，成功接收到<ArkTS>数据"];
}

- (void)onMessageResponse:(id)data {
    NSLog(@"[Native]:: IMethodResult onMessageResponse called; data is ( %@ )", data);
    NSString *str = [NSString stringWithFormat:@"2.数据发送成功，MessageResponse接收到返回消息:\n\n【 %@ 】", data];
    dispatch_async(dispatch_get_main_queue(), ^{
        NativeAbilityViewController *vc = [self.navigationController.viewControllers lastObject];
        if ([vc isKindOfClass: [NativeAbilityViewController class]]) {
            [vc updateTextView:str];
        }
    });
}

- (void)onSuccess:(nonnull NSString *)methodName resultValue:(nonnull id)resultValue {
    NSLog(@"[Native]:: IMethodResult onSuccess called; data is ( %@ )", resultValue);
    NSString *str = [NSString stringWithFormat:@"2.方法调用成功，onSuccess接收到返回值:\n\n【 %@ 】", resultValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        NativeAbilityViewController *vc = [self.navigationController.viewControllers lastObject];
        if ([vc isKindOfClass: [NativeAbilityViewController class]]) {
            [vc updateTextView:str];
        }
    });
}

- (void)onError:(nonnull NSString *)methodName errorCode:(ErrorCode)errorCode errorMessage:(nonnull NSString *)errorMessage {
    NSLog(@"[Native]:: MethodResult onError called; data is ( methodName: %@; errorCode: %d; errorMessage: %@ )", methodName, errorCode, errorMessage);
}

- (void)onMethodCancel:(nonnull NSString *)methodName {
    NSLog(@"[Native]:: IMethodResult onMethodCancel called; methodName is %@", methodName);
}

@end
