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

#ifndef BASEVIEWCONTROLLER_H
#define BASEVIEWCONTROLLER_H
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PublicHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIView *leftView;

@property (nonatomic, assign) BOOL isPortrait;

@property (nonatomic, strong) UITableView *mainTableView;

/// 左边返回，中间文字
- (void)setNavigationBarWithCenterTitle:(NSString *)centerTitle;

/// 顶部状态栏高度+安全区域
- (CGFloat)getStatusBarHeight;

/// 导航栏高度
- (CGFloat)getNavigationBarHeight;

- (void)setNewOrientation:(BOOL)fullscreen;

@end

NS_ASSUME_NONNULL_END
#endif