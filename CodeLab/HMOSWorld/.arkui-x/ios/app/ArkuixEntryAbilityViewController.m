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

#import "ArkuixEntryAbilityViewController.h"
#import <libarkui_ios/BridgePlugin.h>
#import <libarkui_ios/BridgePluginManager.h>
#import "BridgeSrc/include/BridgeAspectUtil.h"
#import "BridgeSrc/include/BridgeWindowUtil.h"
#import "BridgeSrc/include/BridgePhotoManager.h"

@interface ArkuixEntryAbilityViewController ()
@property (nonatomic, strong) BridgeAspectUtil* bridgeAspectUtil;
@property (nonatomic, strong) BridgeWindowUtil* bridgeWindowUtil;
@property (nonatomic, strong) BridgePhotoManager* bridgePhotoManager;
@end

@implementation ArkuixEntryAbilityViewController
- (instancetype)initWithInstanceName:(NSString *)instanceName {
    self = [super initWithInstanceName:instanceName];
    if (self) {
        [self initBridgePlugin];
    }
    return self;
}

- (void)initBridgePlugin {
    self.bridgeAspectUtil = [[BridgeAspectUtil alloc] initBridgePlugin:@"AspectUtil" bridgeManager:[self getBridgeManager]];
    self.bridgeAspectUtil.messageListener = self.bridgeAspectUtil;
    self.bridgeAspectUtil.methodResult = self.bridgeAspectUtil;
    
    self.bridgeWindowUtil = [[BridgeWindowUtil alloc] initBridgePlugin:@"WindowUtil" bridgeManager:[self getBridgeManager]];
    self.bridgeWindowUtil.messageListener = self.bridgeWindowUtil;
    self.bridgeWindowUtil.methodResult = self.bridgeWindowUtil;
    
    self.bridgePhotoManager = [[BridgePhotoManager alloc] initBridgePlugin:@"PhotoManager" bridgeManager:[self getBridgeManager]];
    self.bridgePhotoManager.messageListener = self.bridgePhotoManager;
    self.bridgePhotoManager.methodResult = self.bridgePhotoManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
}

@end
