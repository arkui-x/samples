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

#import "PlatformBridgePlatformBridgeAbilityViewController.h"
#import <libarkui_ios/BridgePlugin.h>
#import <libarkui_ios/BridgeArray.h>
#import <libarkui_ios/TaskOption.h>
#import "BridgeClass.h"

@interface PlatformBridgePlatformBridgeAbilityViewController ()
@property (nonatomic, strong) BridgeClass* plugin;
@property (nonatomic, strong) BridgeClass* pluginCodec;
@property (nonatomic, strong) BridgeClass* pluginTask;
@end

@implementation PlatformBridgePlatformBridgeAbilityViewController
- (instancetype)initWithInstanceName:(NSString *)instanceName {
    self = [super initWithInstanceName:instanceName];
    if (self) {
        //初始化plugin
        [self initBridgePlugin];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"1.ArkUI通过Bridge调用原生平台";

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)initBridgePlugin {
//    int32_t instancedId = [self getInstanceId];
//    构造方法1. 通过instanceId 构造 此方法在API 11 已经废弃
//    self.plugin = [[BridgeClass alloc] initBridgePlugin:@"Bridge" instanceId:instancedId];

//    构造方法2. 通过bridgeManager 构造
    self.plugin = [[BridgeClass alloc] initBridgePlugin:@"Bridge" bridgeManager:[self getBridgeManager]];
//
//    构造方法3. 通过bridgeType、bridgeManager构造，bridgeType设置编解码类型
    self.pluginCodec = [[BridgeClass alloc] initBridgePlugin:@"BridgeCodec" bridgeManager:[self getBridgeManager] bridgeType:BINARY_TYPE];
//
//    构造方法4. 通过bridgeType、bridgeManager、taskOption构造
//    TaskOption设置队列任务类型 true 为异步串行，false 为异步并行
    TaskOption * taskOption = [[TaskOption alloc] initTaskOption:true];
    self.pluginTask = [[BridgeClass alloc] initBridgePlugin:@"BridgeTask" bridgeManager:[self getBridgeManager] bridgeType:BINARY_TYPE taskOption:taskOption];

//  添加代理
    self.plugin.messageListener = self.plugin;
    self.plugin.methodResult = self.plugin;

    self.pluginCodec.messageListener = self.pluginCodec;
    self.pluginCodec.methodResult = self.pluginCodec;

    self.pluginTask.messageListener = self.pluginTask;
    self.pluginTask.methodResult = self.pluginTask;
}
@end
