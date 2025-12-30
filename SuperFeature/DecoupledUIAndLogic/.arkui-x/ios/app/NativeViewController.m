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

#import <libarkui_ios/StageApplication.h>
#import <libarkui_ios/AbilityLoader.h>
#import "NativeViewController.h"
#import "BridgeUtil.h"

@interface NativeViewController () <IMethodResult, IMessageListener>

@property(nonatomic, strong) BridgeUtil* bridgeObject;
@property(nonatomic, strong) UIScrollView* mainScrollView;
@property(nonatomic, strong) UIButton* BTN_LoadHap;
@property(nonatomic, strong) UIButton* BTN_getDeviceInfo;
@property(nonatomic, strong) UIButton* BTN_requestBaidu;
@property(nonatomic, strong) UIButton* BTN_handleDatabaseOperation;

@end

@implementation NativeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bridgeObject = [BridgeUtil sharedInstance];
        self.bridgeObject.messageListener = self;
        self.bridgeObject.methodResult = self;
    }
    return self;
}

- (NSString*)onMessage:(id)data
{
    NSLog(@"[Test][iOS][NativeViewController]:: IMethodResult onMessage called; data is ( %@ )", data);
    return [NSString stringWithFormat:@"The message sent by the peer (ArkTS) via sendMessagehas been received"];
}

- (void)onMessageResponse:(id)data
{
    NSLog(@"[Test][iOS][NativeViewController]:: IMethodResult onMessageResponse called; data is ( %@ )", data);
}

- (void)onSuccess:(nonnull NSString*)methodName resultValue:(nonnull id)resultValue
{
    NSLog(@"[Test][iOS][NativeViewController]:: IMethodResult onSuccess called; data is ( %@ )", resultValue);
}

- (void)onError:(nonnull NSString*)methodName
       errorCode:(ErrorCode)errorCode
    errorMessage:(nonnull NSString*)errorMessage
{
    NSLog(@"[Test][iOS][NativeViewController]:: MethodResult onError called; data is ( methodName: %@; "
          @"errorCode: %d; errorMessage: %@ )", methodName, errorCode, errorMessage);
}

- (void)onMethodCancel:(nonnull NSString*)methodName
{
    NSLog(@"[Test][iOS][NativeViewController]:: IMethodResult onMethodCancel called; methodName is %@", methodName);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mainScrollView];

    CGFloat buttonHeight = 60;
    CGFloat spacing = 8;
    CGFloat titleHeight = 30;
    CGFloat margins = 20 + 20 + 20;
    NSInteger buttonCount = 4;
    CGFloat totalHeight = titleHeight + margins + (buttonHeight + spacing) * buttonCount;
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, totalHeight)];
    [self.mainScrollView addSubview:contentView];

    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 30)];
    titleLabel.text = @"Native";
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLabel];

    UIStackView* bottomButtonStack =
        [[UIStackView alloc] initWithFrame:CGRectMake(15, 70, self.view.bounds.size.width - 30, totalHeight - 90)];
    bottomButtonStack.axis = UILayoutConstraintAxisVertical;
    bottomButtonStack.spacing = spacing;
    bottomButtonStack.distribution = UIStackViewDistributionFillEqually;
    [contentView addSubview:bottomButtonStack];

    self.BTN_LoadHap = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.BTN_LoadHap setTitle:@"点击加载Hap" forState:UIControlStateNormal];
    [self.BTN_LoadHap setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.BTN_LoadHap.backgroundColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.0 alpha:1.0];
    self.BTN_LoadHap.layer.cornerRadius = 4;
    [self.BTN_LoadHap addTarget:self action:@selector(BTN_LoadHap:) forControlEvents:UIControlEventTouchUpInside];
    [bottomButtonStack addArrangedSubview:self.BTN_LoadHap];

    self.BTN_getDeviceInfo = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.BTN_getDeviceInfo setTitle:@"获取设备信息" forState:UIControlStateNormal];
    [self.BTN_getDeviceInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.BTN_getDeviceInfo.backgroundColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.0 alpha:1.0];
    self.BTN_getDeviceInfo.layer.cornerRadius = 4;
    [self.BTN_getDeviceInfo addTarget:self action:@selector(BTN_getDeviceInfo:) forControlEvents:UIControlEventTouchUpInside];
    [bottomButtonStack addArrangedSubview:self.BTN_getDeviceInfo];

    self.BTN_requestBaidu = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.BTN_requestBaidu setTitle:@"http请求百度" forState:UIControlStateNormal];
    [self.BTN_requestBaidu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.BTN_requestBaidu.backgroundColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.0 alpha:1.0];
    self.BTN_requestBaidu.layer.cornerRadius = 4;
    [self.BTN_requestBaidu addTarget:self action:@selector(BTN_requestBaidu:) forControlEvents:UIControlEventTouchUpInside];
    [bottomButtonStack addArrangedSubview:self.BTN_requestBaidu];

    self.BTN_handleDatabaseOperation = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.BTN_handleDatabaseOperation setTitle:@"数据库操作" forState:UIControlStateNormal];
    [self.BTN_handleDatabaseOperation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.BTN_handleDatabaseOperation.backgroundColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.0 alpha:1.0];
    self.BTN_handleDatabaseOperation.layer.cornerRadius = 4;
    [self.BTN_handleDatabaseOperation addTarget:self action:@selector(BTN_handleDatabaseOperation:) forControlEvents:UIControlEventTouchUpInside];
    [bottomButtonStack addArrangedSubview:self.BTN_handleDatabaseOperation];

    self.mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, totalHeight);
}

- (void)BTN_LoadHap:(UIButton*)sender
{
    [StageApplication loadModule:@"entry" entryFile:@"./ets/MyModuleLoader.ets"];
    [AbilityLoader loadAbility:@"com.example.hspui" moduleName:@"entry" abilityName:@"EntryAbility" params:@""];
}

- (void)BTN_getDeviceInfo:(UIButton*)sender
{
    @try {
        id data = [self.bridgeObject callMethodSync:@"getDeviceInfo" parameters:nil];
        if (data != nil && [data isKindOfClass:[NSString class]]) {
            NSString* resultString = (NSString*)data;
            if ([resultString containsString:@"[ArkTS]: (Native) call getDeviceInfo by callMethodSync success"]) {
                sender.backgroundColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0];
            } else {
                sender.backgroundColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
            }
        } else {
            sender.backgroundColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
        }
    } @catch (NSException* exception) {
        NSLog(@"[Test][iOS][NativeViewController]:: callMethodSync failed, error is : %@", exception);
        sender.backgroundColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
    }
}

- (void)BTN_requestBaidu:(UIButton*)sender
{
    @try {
        [self.bridgeObject callMethodSync:@"requestBaidu" parameters:nil];
        sender.backgroundColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0];
    } @catch (NSException* exception) {
        NSLog(@"[Test][iOS][NativeViewController]:: callMethodSync failed, error is : %@", exception);
        sender.backgroundColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
    }
}

- (void)BTN_handleDatabaseOperation:(UIButton*)sender
{
    @try {
        [self.bridgeObject callMethodSync:@"handleDatabaseOperation" parameters:nil];
        sender.backgroundColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0];
    } @catch (NSException* exception) {
        NSLog(@"[Test][iOS][NativeViewController]:: callMethodSync failed, error is : %@", exception);
        sender.backgroundColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
    }
}

@end
