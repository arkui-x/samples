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

#import "PhoneEntryAbilityViewController.h"

@interface PhoneEntryAbilityViewController ()

@end

@implementation PhoneEntryAbilityViewController
- (instancetype)initWithInstanceName:(NSString *)instanceName {
    self = [super initWithInstanceName:instanceName];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    CGFloat statusBarHeight = 20;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets insets = self.view.safeAreaInsets;
        statusBarHeight = insets.top;
    } else {
        if ([self respondsToSelector:@selector(topLayoutGuide)]) {
            statusBarHeight = self.topLayoutGuide.length;
        }
    }
    self.view.frame = CGRectMake(0, statusBarHeight,
        CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - statusBarHeight);
}
@end
