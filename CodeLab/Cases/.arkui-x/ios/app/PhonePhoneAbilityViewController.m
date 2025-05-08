/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

#import "PhonePhoneAbilityViewController.h"
#import "BridgeUtil.h"

@interface PhonePhoneAbilityViewController ()
@property (nonatomic, strong) BridgeUtil* bridgeUtil;
@end

@implementation PhonePhoneAbilityViewController
- (instancetype)initWithInstanceName:(NSString *)instanceName {
    self = [super initWithInstanceName:instanceName];
    if (self) {
        [self initBridgePlugin];
    }
    return self;
}

- (void)initBridgePlugin {
    self.bridgeUtil = [[BridgeUtil alloc] initBridgePlugin:@"BridgeUtil" bridgeManager:[self getBridgeManager]];
    self.bridgeUtil.messageListener = self.bridgeUtil;
    self.bridgeUtil.methodResult = self.bridgeUtil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
}
@end
