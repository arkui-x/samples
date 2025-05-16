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
 
#import "PlatformBridgeController.h"
#import "ArkBridgeClass.h"
#import <libarkui_ios/StageApplication.h>
#import <libarkui_ios/BridgePlugin.h>

@interface PlatformBridgeController ()

@property (nonatomic, strong) ArkBridgeClass* plugin;
@property (nonatomic, strong) ArkBridgeClass* pluginCodec;
@property (nonatomic, strong) ArkBridgeClass* pluginTask;

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) StageViewController *stageVC;
@property (nonatomic, assign) CGFloat statusBarHeight;

@end

@implementation PlatformBridgeController {
    NSObject<PlatformViewFactory> *factory;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.statusBarHeight = 0;
    if (self.isShowNavigationBar) {
        [self setNavigationBarWithCenterTitle:self.titleName];
        self.statusBarHeight = [self getStatusBarHeight] + [self getNavigationBarHeight];
    }
    [self createUI];

}

- (void)createUI {
    CGFloat top = self.isShowNavigationBar ? self.statusBarHeight : 0;
    self.mainView = [[UIView alloc] init];
    self.mainView.frame = CGRectMake(0, top, self.view.frame.size.width, self.view.frame.size.height - top);
    [self.view addSubview:self.mainView];
    self.stageVC = [[StageViewController alloc] initWithInstanceName:self.instanceName];
    self.stageVC.view.frame = CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height);
    self.stageVC.view.backgroundColor = [UIColor whiteColor];
    [self.mainView addSubview:self.stageVC.view];
    
    // 建立与ArkUI侧同名的平台桥接，即可用于消息传递
    self.plugin = [[ArkBridgeClass alloc] initBridgePlugin:@"Bridge" bridgeManager:[self.stageVC getBridgeManager]];
    self.pluginCodec = [[ArkBridgeClass alloc] initBridgePlugin:@"BridgeCodec" bridgeManager:[self.stageVC getBridgeManager] bridgeType:BINARY_TYPE];
    TaskOption *taskOption = [[TaskOption alloc] initTaskOption:true];
    self.pluginTask = [[ArkBridgeClass alloc] initBridgePlugin:@"BridgeTask" bridgeManager:[self.stageVC getBridgeManager] bridgeType:BINARY_TYPE taskOption:taskOption];
    
    self.plugin.messageListener = self.plugin;
    self.plugin.methodResult = self.plugin;

    self.pluginCodec.messageListener = self.pluginCodec;
    self.pluginCodec.methodResult = self.pluginCodec;

    self.pluginTask.messageListener = self.pluginTask;
    self.pluginTask.methodResult = self.pluginTask;
}
@end
