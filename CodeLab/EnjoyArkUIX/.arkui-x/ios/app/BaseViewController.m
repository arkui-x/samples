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
 
#import "BaseViewController.h"

#define CELL_HEIGHT  80

@interface BaseViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange)
                         name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)deviceOrientationDidChange {
    if(([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) ||
       ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)){
        self.isPortrait = YES;
    } else {
        //横屏
        self.isPortrait = NO;
    }
}

- (void)setNewOrientation:(BOOL)fullscreen {
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    if (fullscreen) {
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationMaskAll];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    } else {
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationMaskPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
}

/// 左边返回，中间文字
- (void)setNavigationBarWithCenterTitle:(NSString *)centerTitle {
    if (self.leftView) {
        [self.leftView removeFromSuperview];
    }
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, self.navigationController.navigationBar.frame.size.height)];
    UIImageView *leftImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    leftImgView.frame = CGRectMake(0, 0, 25, 25);
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.backgroundColor = [UIColor clearColor];
    self.leftButton.frame = CGRectMake(0, 0, self.leftView.frame.size.width, self.leftView.frame.size.height);
    [self.leftView addSubview:leftImgView];
    [self.leftView addSubview:self.leftButton];
    [self.leftButton addTarget:self action:@selector(pullClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftView];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = centerTitle;
}

- (void)pullClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/// 顶部安全高度
- (CGFloat)getSafeDistanceTop {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.top;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.top;
    }
    return 0;
}

/// 顶部状态栏高度+安全区域
- (CGFloat)getStatusBarHeight {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIStatusBarManager *statusManager = windowScene.statusBarManager;
        return statusManager.statusBarFrame.size.height;
    }
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

/// 导航栏高度
- (CGFloat)getNavigationBarHeight {
    return self.navigationController.navigationBar.frame.size.height;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.bounces = NO;
    }
    return _mainTableView;
}
@end
