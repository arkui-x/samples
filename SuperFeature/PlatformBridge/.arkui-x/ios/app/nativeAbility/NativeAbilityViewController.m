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

#import <libarkui_ios/BridgeArray.h>
#import "NativeAbilityViewController.h"
#import "EntryEntryAbilityViewController.h"
#import "BridgeManager.h"
#import "BridgeUtil.h"

@interface NativeAbilityViewController ()<IMessageListener,IMethodResult>

@property (strong , nonatomic ) BridgeUtil *bridgeForJson;
@property (strong , nonatomic ) BridgeUtil *bridgeForBinary;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UILabel *bridgeTypeLabel;
@property (nonatomic, strong) UITextView *operationLogTextView;
@property (nonatomic, strong) UIButton *btnArkTS;
@property (nonatomic, strong) UIButton *btnResetText;
@property (nonatomic, strong) UIButton *btnSwitchType;
@property (nonatomic, strong) UIButton *btnSendMessage;
@property (nonatomic, strong) UIButton *btnCallMethod;
@property (nonatomic, strong) UIButton *btnCallMethodSync;

@end

static NSString *const MESSAGE_DATA = @"Native Message Data";

@implementation NativeAbilityViewController

-(void)updateTextView:(NSString *)strText{
    [self appendLog:strText];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    BridgeManager *bridgeManager = [BridgeManager sharedInstance];
    self.bridgeForBinary = [bridgeManager getBridgeWithName:@"BridgeBinaryObject" bridgeType:BINARY_TYPE];
    self.bridgeForBinary.methodResult = self;
    self.bridgeForBinary.messageListener = self;
    self.bridgeForJson = [bridgeManager getBridgeWithName:@"BridgeJsonObject" bridgeType:JSON_TYPE];
    self.bridgeForJson.methodResult = self;
    self.bridgeForJson.messageListener = self;
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.mainScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.mainScrollView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:self.mainScrollView.bounds];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mainScrollView addSubview:contentView];
    
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, width, 30)];
    titleLabel.text = @"Native";
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLabel];
    
    UIStackView *buttonStack = [[UIStackView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame) + 20, width - 30, 45)];
    buttonStack.axis = UILayoutConstraintAxisHorizontal;
    buttonStack.distribution = UIStackViewDistributionFillEqually;
    buttonStack.spacing = 8;
    
    self.btnArkTS = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.btnArkTS setTitle:@"ArkTS" forState:UIControlStateNormal];
    [self.btnArkTS setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnArkTS.backgroundColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.0 alpha:1.0];
    self.btnArkTS.layer.cornerRadius = 4;
    [self.btnArkTS addTarget:self action:@selector(arkTSButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [buttonStack addArrangedSubview:self.btnArkTS];
    
    self.btnResetText = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.btnResetText setTitle:@"重置文本" forState:UIControlStateNormal];
    [self.btnResetText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnResetText.backgroundColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.0 alpha:1.0];
    self.btnResetText.layer.cornerRadius = 4;
    [self.btnResetText addTarget:self action:@selector(resetButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [buttonStack addArrangedSubview:self.btnResetText];
    
    self.btnSwitchType = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.btnSwitchType setTitle:@"切换Type" forState:UIControlStateNormal];
    [self.btnSwitchType setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnSwitchType.backgroundColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.0 alpha:1.0];
    self.btnSwitchType.layer.cornerRadius = 4;
    [self.btnSwitchType addTarget:self action:@selector(switchTypeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [buttonStack addArrangedSubview:self.btnSwitchType];
    [contentView addSubview:buttonStack];
    
    self.bridgeTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(buttonStack.frame) + 20, width - 30, 60)];
    self.bridgeTypeLabel.text = @"BridgeType：JSON_TYPE";
    self.bridgeTypeLabel.font = [UIFont boldSystemFontOfSize:15];
    self.bridgeTypeLabel.textAlignment = NSTextAlignmentCenter;
    self.bridgeTypeLabel.layer.borderWidth = 1;
    self.bridgeTypeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bridgeTypeLabel.layer.cornerRadius = 4;
    [contentView addSubview:self.bridgeTypeLabel];
    
    self.operationLogTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.bridgeTypeLabel.frame) + 20, width - 30, 250)];
    self.operationLogTextView.text = @"操作日志：\n";
    self.operationLogTextView.font = [UIFont boldSystemFontOfSize:15];
    self.operationLogTextView.layer.borderWidth = 1;
    self.operationLogTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.operationLogTextView.layer.cornerRadius = 4;
    self.operationLogTextView.editable = NO;
    self.operationLogTextView.userInteractionEnabled = NO;
    [contentView addSubview:self.operationLogTextView];
    
    UIStackView *bottomButtonStack = [[UIStackView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.operationLogTextView.frame) + 20, width - 30, 180)];
    bottomButtonStack.axis = UILayoutConstraintAxisVertical;
    bottomButtonStack.spacing = 8;
    bottomButtonStack.distribution = UIStackViewDistributionFillEqually;

    self.btnSendMessage = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.btnSendMessage setTitle:@"sendMessage" forState:UIControlStateNormal];
    [self.btnSendMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnSendMessage.backgroundColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.0 alpha:1.0];
    self.btnSendMessage.layer.cornerRadius = 4;
    [self.btnSendMessage addTarget:self action:@selector(sendMessageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [bottomButtonStack addArrangedSubview:self.btnSendMessage];

    self.btnCallMethod = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.btnCallMethod setTitle:@"callMethod" forState:UIControlStateNormal];
    [self.btnCallMethod setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnCallMethod.backgroundColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.0 alpha:1.0];
    self.btnCallMethod.layer.cornerRadius = 4;
    [self.btnCallMethod addTarget:self action:@selector(callMethodButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [bottomButtonStack addArrangedSubview:self.btnCallMethod];

    self.btnCallMethodSync = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.btnCallMethodSync setTitle:@"callMethodSync" forState:UIControlStateNormal];
    [self.btnCallMethodSync setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnCallMethodSync.backgroundColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.0 alpha:1.0];
    self.btnCallMethodSync.layer.cornerRadius = 4;
    [self.btnCallMethodSync addTarget:self action:@selector(callMethodSyncButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [bottomButtonStack addArrangedSubview:self.btnCallMethodSync];
    [contentView addSubview:bottomButtonStack];
}

- (void)appendLog:(NSString *)log {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *currentText = self.operationLogTextView.text;
        NSString *newText = [NSString stringWithFormat:@"%@\n%@", currentText, log];
        self.operationLogTextView.text = newText;
        NSRange bottom = NSMakeRange(newText.length - 1, 1);
        [self.operationLogTextView scrollRangeToVisible:bottom];
    });
}

- (void)arkTSButtonTapped:(UIButton *)sender {
    NSString *instanceName = [NSString stringWithFormat:@"%@:%@:%@",@"com.example.bridge", @"entry", @"EntryAbility"];
    EntryEntryAbilityViewController *vc = [[EntryEntryAbilityViewController alloc]initWithInstanceName:instanceName];
    UIWindow *uiWindow = self.view.window;
    uiWindow.backgroundColor = [UIColor whiteColor];
    [uiWindow makeKeyAndVisible];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
    uiWindow.rootViewController = navi;
}

- (void)resetButtonTapped:(UIButton *)sender {
    self.operationLogTextView.text = @"操作日志：\n";
}

- (void)switchTypeButtonTapped:(UIButton *)sender {
    if (self.bridgeTypeLabel.text == @"BridgeType：JSON_TYPE") {
        self.bridgeTypeLabel.text = @"BridgeType：BINARY_TYPE";
    } else {
        self.bridgeTypeLabel.text = @"BridgeType：JSON_TYPE";
    }
}

- (void)sendMessageButtonTapped:(UIButton *)sender {
    self.operationLogTextView.text = @"操作日志\n";
    NSString *str = [NSString stringWithFormat:@"1.向ArkTS侧发送数据:\n\n【 (%@) 】\n\n", MESSAGE_DATA];
    [self appendLog:str];
    if (self.bridgeTypeLabel.text == @"BridgeType：JSON_TYPE") {
        [self.bridgeForJson sendMessage:MESSAGE_DATA];
    } else {
        [self.bridgeForBinary sendMessage:MESSAGE_DATA];
    }
}

- (void)callMethodButtonTapped:(UIButton *)sender {
    self.operationLogTextView.text = @"操作日志\n";
    NSString *arkFuncName = [NSString stringWithFormat:@"ArkTSMethod"];
    NSString *str = [NSString stringWithFormat:@"1.调用ArkTS侧方法:\n\n【 %@ (%@) 】\n\n", arkFuncName, MESSAGE_DATA];
    [self appendLog:str];
    MethodData *methodData = [[MethodData alloc] initMethodWithName:arkFuncName parameter:@[MESSAGE_DATA]];
    if (self.bridgeTypeLabel.text == @"BridgeType：JSON_TYPE") {
        [self.bridgeForJson callMethod:methodData];
    } else {
        [self.bridgeForBinary callMethod:methodData];
    }
}

- (void)callMethodSyncButtonTapped:(UIButton *)sender {
    self.operationLogTextView.text = @"操作日志\n";
    NSString *arkFuncName = [NSString stringWithFormat:@"ArkTSMethodSync"];
    NSString *str = [NSString stringWithFormat:@"1.同步方式调用ArkTS侧方法:\n\n【 %@ (%@) 】\n\n", arkFuncName, MESSAGE_DATA];
    [self appendLog:str];
    id data = nil;
    @try {
        if (
            self.bridgeTypeLabel.text == @"BridgeType：JSON_TYPE") {
            data = [self.bridgeForJson callMethodSync:arkFuncName parameters:MESSAGE_DATA, nil];
            str = [NSString stringWithFormat:@"2.方法同步调用成功，返回值:\n\n【 %@ 】", data];
            [self appendLog:str];
        } else {
            data = [self.bridgeForBinary callMethodSync:arkFuncName parameters:MESSAGE_DATA, nil];
            str = [NSString stringWithFormat:@"2.方法同步调用成功，返回值:\n\n【 %@ 】", data];
            [self appendLog:str];
        }
    } @catch (NSException *exception) {
        NSLog(@"[Native]:: callMethodSync failed, error is : %@", exception);
    }
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
