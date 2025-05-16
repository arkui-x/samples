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
 
#import "BaseModuleViewController.h"
#import <libarkui_ios/StageApplication.h>
#import "PublicAlertView.h"
#import "DynamicShowViewController.h"
#import "OneToMoreViewController.h"

#define doc_path(_fileOrFolder) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:_fileOrFolder]

@interface BaseModuleViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) StageViewController *stageVC;
@property (nonatomic, assign) CGFloat statusBarHeight;

@property (nonatomic, strong) UIImage *needEffectImage;
@property (nonatomic, strong) PublicAlertView *publicAlertView;

@property (nonatomic, strong) NSMutableArray *inputResultArray;

@property (nonatomic, assign) BOOL isHaveDynamicContent;

@end

@implementation BaseModuleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.statusBarHeight = 0;
    if (self.isShowNavigationBar) {
        [self setNavigationBarWithCenterTitle:self.titleName];
        self.statusBarHeight = [self getStatusBarHeight] + [self getNavigationBarHeight];
    }
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = !self.isShowNavigationBar;
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = YES;
    [self setNewOrientation:YES];
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

}
@end
